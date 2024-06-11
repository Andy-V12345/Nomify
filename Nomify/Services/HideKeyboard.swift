//
//  HideKeyboard.swift
//  Nomify
//
//  Created by Andy Vu on 6/11/24.
//

import SwiftUI

func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}
