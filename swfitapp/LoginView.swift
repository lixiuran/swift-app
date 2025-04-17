import SwiftUI

struct LoginView: View {
    @State private var phoneNumber: String = ""
    @State private var verificationCode: String = ""
    @State private var countdown: Int = 60
    @State private var isCountingDown = false
    @State private var timer: Timer?
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    @State private var isAgreed = false
    @State private var showPrivacyAlert = false
    @State private var showUserAgreementAlert = false
    
    var body: some View {
        ZStack {
            // 背景色，用于点击收起键盘
            Color(.systemBackground)
                .onTapGesture {
                    hideKeyboard()
                }
            
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        Spacer()
                            .frame(height: max(0, (geometry.size.height - 600) / 2)) // 估算内容高度约600
                        
                        // Logo
                        Image(systemName: "hexagon")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.blue)
                            .padding(.bottom, 20)
                            .rotationEffect(.degrees(isLoading ? 360 : 0))
                            .animation(isLoading ? .linear(duration: 1).repeatForever(autoreverses: false) : .default, value: isLoading)
                        
                        // 手机号输入框
                        HStack {
                            Image(systemName: "phone")
                                .foregroundColor(.gray)
                            TextField("手机号", text: Binding(
                                get: { phoneNumber },
                                set: { newValue in
                                    let filtered = newValue.filter { $0.isNumber }
                                    phoneNumber = String(filtered.prefix(11))
                                }
                            ))
                            .keyboardType(.numberPad)
                            
                            if !phoneNumber.isEmpty {
                                Button(action: {
                                    withAnimation {
                                        phoneNumber = ""
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        
                        // 验证码输入框和获取按钮
                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.gray)
                            TextField("验证码", text: Binding(
                                get: { verificationCode },
                                set: { newValue in
                                    let filtered = newValue.filter { $0.isNumber }
                                    verificationCode = String(filtered.prefix(6))
                                }
                            ))
                            .keyboardType(.numberPad)
                            
                            if !verificationCode.isEmpty {
                                Button(action: {
                                    withAnimation {
                                        verificationCode = ""
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            Button(action: {
                                if validatePhoneNumber() {
                                    withAnimation {
                                        startCountdown()
                                        sendVerificationCode()
                                    }
                                }
                            }) {
                                Text(isCountingDown ? "\(countdown)秒" : "获取验证码")
                                    .foregroundColor(isCountingDown ? .gray : .white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(isCountingDown ? Color.gray.opacity(0.3) : Color.blue)
                                    .cornerRadius(8)
                            }
                            .disabled(isCountingDown || phoneNumber.isEmpty)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        
                        // 登录按钮
                        Button(action: {
                            validateAndLogin()
                        }) {
                            ZStack {
                                Text("登录")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    .opacity(isLoading ? 0 : 1)
                                
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                }
                            }
                        }
                        .disabled(!isAgreed || isLoading || phoneNumber.isEmpty || verificationCode.isEmpty)
                        .animation(.easeInOut, value: isLoading)
                        
                        // 用户协议和隐私政策
                        HStack(alignment: .top, spacing: 4) {
                            Button(action: {
                                withAnimation {
                                    isAgreed.toggle()
                                }
                            }) {
                                Image(systemName: isAgreed ? "checkmark.square.fill" : "square")
                                    .foregroundColor(isAgreed ? .blue : .gray)
                            }
                            
                            Group {
                                Text("我已阅读并同意")
                                    .foregroundColor(.gray)
                                
                                Button("《用户协议》") {
                                    showUserAgreementAlert = true
                                }
                                .foregroundColor(.blue)
                                
                                Text("和")
                                    .foregroundColor(.gray)
                                
                                Button("《隐私政策》") {
                                    showPrivacyAlert = true
                                }
                                .foregroundColor(.blue)
                            }
                            .font(.caption)
                        }
                        .padding(.top, 10)
                        
                        Spacer()
                            .frame(height: max(0, (geometry.size.height - 600) / 2))
                    }
                    .padding(.horizontal, 20)
                }
                .scrollDisabled(geometry.size.height >= 600)
            }
            .alert("提示", isPresented: $showAlert) {
                Button("确定", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .alert("用户协议", isPresented: $showUserAgreementAlert) {
                Button("确定", role: .cancel) { }
            } message: {
                Text("这是用户协议的内容...")
            }
            .alert("隐私政策", isPresented: $showPrivacyAlert) {
                Button("确定", role: .cancel) { }
            } message: {
                Text("这是隐私政策的内容...")
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onDisappear {
            stopCountdown()
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func validatePhoneNumber() -> Bool {
        let phoneRegex = "^1[3-9]\\d{9}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        let isValid = phonePredicate.evaluate(with: phoneNumber)
        
        if !isValid {
            alertMessage = "请输入正确的手机号码"
            showAlert = true
        }
        
        return isValid
    }
    
    private func validateVerificationCode() -> Bool {
        let isValid = verificationCode.count == 6
        
        if !isValid {
            alertMessage = "请输入6位验证码"
            showAlert = true
        }
        
        return isValid
    }
    
    private func validateAndLogin() {
        if !validatePhoneNumber() {
            return
        }
        
        if !validateVerificationCode() {
            return
        }
        
        login()
    }
    
    private func startCountdown() {
        isCountingDown = true
        countdown = 60
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if countdown > 0 {
                countdown -= 1
            } else {
                stopCountdown()
            }
        }
    }
    
    private func stopCountdown() {
        timer?.invalidate()
        timer = nil
        isCountingDown = false
        countdown = 60
    }
    
    private func sendVerificationCode() {
        // 模拟发送验证码的网络请求
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            alertMessage = "验证码已发送"
            showAlert = true
        }
    }
    
    private func login() {
        isLoading = true
        
        // 模拟登录请求
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("验证码登录: 手机号: \(phoneNumber), 验证码: \(verificationCode)")
            isLoading = false
            
            alertMessage = "登录成功"
            showAlert = true
        }
    }
}

#Preview {
    LoginView()
} 
