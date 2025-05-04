//
//  AuthError.swift
//  habits
//
//  Created by gio on 4/30/25.
//
import Foundation
import FirebaseAuth

enum AuthError: Error {
    // أخطاء التحقق
    case invalidEmail
    case invalidPassword
    case invalidName
    
    // أخطاء Firebase
    case emailAlreadyInUse
    case userNotFound
    case weakPassword
    case networkError
    
    // أخطاء التطبيق
    
    case signInFailed(String)  // تم تحديث هذه الحالة لتقبل رسالة
    case signUpFailed(String)
    case signOutFailed(String)
    case passwordResetFailed(String)
    case profileUpdateFailed(String)
    case emailVerificationFailed(String)
    
    // أخطاء عامة
    case unknownError
    case noUserLoggedIn
    
    var localizedDescription: String {
            switch self {
            case .invalidEmail:
                return "البريد الإلكتروني غير صالح"
            case .invalidPassword:
                return "كلمة المرور يجب أن تحتوي على 6 أحرف على الأقل"
            case .invalidName:
                return "الاسم يجب أن يحتوي على حرفين على الأقل"
            case .emailAlreadyInUse:
                return "البريد الإلكتروني مستخدم بالفعل"
            case .userNotFound:
                return "المستخدم غير موجود"
            case .weakPassword:
                return "كلمة المرور ضعيفة جداً"
            case .networkError:
                return "خطأ في الاتصال بالشبكة"
            case .signInFailed(let message):
                return "فشل تسجيل الدخول: \(message)"
            case .signUpFailed(let message):
                return "فشل إنشاء الحساب: \(message)"
            case .signOutFailed(let message):
                return "فشل تسجيل الخروج: \(message)"
            case .passwordResetFailed(let message):
                return "فشل إعادة تعيين كلمة المرور: \(message)"
            case .profileUpdateFailed(let message):
                return "فشل تحديث الملف الشخصي: \(message)"
            case .emailVerificationFailed(let message):
                return "فشل إرسال رسالة التحقق: \(message)"
            case .unknownError:
                return "حدث خطأ غير معروف"
            case .noUserLoggedIn:
                return "لا يوجد مستخدم مسجل الدخول"
            }
        }
    
    static func mapFromFirebaseError(_ error: Error) -> AuthError {
        let nsError = error as NSError
        
        switch nsError.code {
        case AuthErrorCode.invalidEmail.rawValue:
            return .invalidEmail
        case AuthErrorCode.wrongPassword.rawValue:
            return .invalidPassword
        case AuthErrorCode.userNotFound.rawValue:
            return .userNotFound
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return .emailAlreadyInUse
        case AuthErrorCode.weakPassword.rawValue:
            return .weakPassword
        case AuthErrorCode.networkError.rawValue:
            return .networkError
        default:
            return .unknownError
        }
    }
}
