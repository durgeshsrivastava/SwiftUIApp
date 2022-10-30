//
//  Authentication.swift
//  LearningTab
//
//  Created by Durgesh on 10/29/22.
//

import LocalAuthentication

class Authentication{
    
    //@State var isUnlocked = false
    
    func authenticate(completion:@escaping (Bool) -> Void) {
        
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Welcome! Let us verify"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                success, authenticationError in
               DispatchQueue.main.async {
                   completion(success)
                }
            }
        }

        else {
            completion(true)
        }
    }
    
} // Authentication
