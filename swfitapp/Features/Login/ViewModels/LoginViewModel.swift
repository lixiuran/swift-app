import Foundation
import Combine

@MainActor
class LoginViewModel: ObservableObject {
    @Published var phoneNumber: String = ""
    @Published var verificationCode: String = ""
    @Published var countdown: Int = 60
    @Published var isCountingDown = false
    @Published var isLoading = false
    @Published var isAgreed = false
    @Published var alertMessage = ""
    @Published var showAlert = false
    
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    var canRequestCode: Bool {
        !isCountingDown && !phoneNumber.isEmpty
    }
    
    var canLogin: Bool {
        !isLoading && !phoneNumber.isEmpty && !verificationCode.isEmpty && isAgreed
    }
    
    func validatePhoneNumber() -> Bool {
        let phoneRegex = "^1[3-9]\\d{9}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        let isValid = phonePredicate.evaluate(with: phoneNumber)
        
        if !isValid {
            showError(.invalidPhoneNumber)
        }
        
        return isValid
    }
    
    func validateVerificationCode() -> Bool {
        let isValid = verificationCode.count == 6
        
        if !isValid {
            showError(.invalidVerificationCode)
        }
        
        return isValid
    }
    
    func startCountdown() {
        isCountingDown = true
        countdown = 60
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            Task { @MainActor in
                if self.countdown > 0 {
                    self.countdown -= 1
                } else {
                    self.stopCountdown()
                }
            }
        }
    }
    
    func stopCountdown() {
        timer?.invalidate()
        timer = nil
        isCountingDown = false
        countdown = 60
    }
    
    func sendVerificationCode() {
        guard validatePhoneNumber() else { return }
        
        // 模拟发送验证码的网络请求
        Task {
            startCountdown()
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1秒延迟
            alertMessage = "验证码已发送"
            showAlert = true
        }
    }
    
    func login() {
        guard validatePhoneNumber() else { return }
        guard validateVerificationCode() else { return }
        
        let request = LoginRequest(phoneNumber: phoneNumber, verificationCode: verificationCode)
        
        // 模拟登录请求
        Task {
            isLoading = true
            try? await Task.sleep(nanoseconds: 2_000_000_000) // 2秒延迟
            print("验证码登录: 手机号: \(request.phoneNumber), 验证码: \(request.verificationCode)")
            isLoading = false
            alertMessage = "登录成功"
            showAlert = true
        }
    }
    
    private func showError(_ error: LoginError) {
        alertMessage = error.message
        showAlert = true
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
} 
