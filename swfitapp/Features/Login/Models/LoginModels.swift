import Foundation

struct LoginRequest {
    let phoneNumber: String
    let verificationCode: String
}

enum LoginError: Error {
    case invalidPhoneNumber
    case invalidVerificationCode
    case networkError
    
    var message: String {
        switch self {
        case .invalidPhoneNumber:
            return "请输入正确的手机号码"
        case .invalidVerificationCode:
            return "请输入6位验证码"
        case .networkError:
            return "网络错误，请稍后重试"
        }
    }
} 