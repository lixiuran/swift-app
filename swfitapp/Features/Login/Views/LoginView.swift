import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
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
                            .frame(height: max(0, (geometry.size.height - 600) / 2))
                        
                        // Logo
                        Image(systemName: "hexagon")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.blue)
                            .padding(.bottom, 20)
                            .rotationEffect(.degrees(viewModel.isLoading ? 360 : 0))
                            .animation(viewModel.isLoading ? .linear(duration: 1).repeatForever(autoreverses: false) : .default, value: viewModel.isLoading)
                        
                        // 手机号输入框
                        HStack {
                            Image(systemName: "phone")
                                .foregroundColor(.gray)
                            TextField("手机号", text: Binding(
                                get: { viewModel.phoneNumber },
                                set: { newValue in
                                    let filtered = newValue.filter { $0.isNumber }
                                    viewModel.phoneNumber = String(filtered.prefix(11))
                                }
                            ))
                            .keyboardType(.numberPad)
                            
                            if !viewModel.phoneNumber.isEmpty {
                                Button(action: {
                                    withAnimation {
                                        viewModel.phoneNumber = ""
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
                                get: { viewModel.verificationCode },
                                set: { newValue in
                                    let filtered = newValue.filter { $0.isNumber }
                                    viewModel.verificationCode = String(filtered.prefix(6))
                                }
                            ))
                            .keyboardType(.numberPad)
                            
                            if !viewModel.verificationCode.isEmpty {
                                Button(action: {
                                    withAnimation {
                                        viewModel.verificationCode = ""
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            Button(action: {
                                viewModel.sendVerificationCode()
                            }) {
                                Text(viewModel.isCountingDown ? "\(viewModel.countdown)秒" : "获取验证码")
                                    .foregroundColor(viewModel.isCountingDown ? .gray : .white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(viewModel.isCountingDown ? Color.gray.opacity(0.3) : Color.blue)
                                    .cornerRadius(8)
                            }
                            .disabled(!viewModel.canRequestCode)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        
                        // 登录按钮
                        Button(action: {
                            viewModel.login()
                        }) {
                            ZStack {
                                Text("登录")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    .opacity(viewModel.isLoading ? 0 : 1)
                                
                                if viewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                }
                            }
                        }
                        .disabled(!viewModel.canLogin)
                        .animation(.easeInOut, value: viewModel.isLoading)
                        
                        // 用户协议和隐私政策
                        HStack(alignment: .top, spacing: 4) {
                            Button(action: {
                                withAnimation {
                                    viewModel.isAgreed.toggle()
                                }
                            }) {
                                Image(systemName: viewModel.isAgreed ? "checkmark.square.fill" : "square")
                                    .foregroundColor(viewModel.isAgreed ? .blue : .gray)
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
            .alert("提示", isPresented: $viewModel.showAlert) {
                Button("确定", role: .cancel) { }
            } message: {
                Text(viewModel.alertMessage)
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
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    LoginView()
} 