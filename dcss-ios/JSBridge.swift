//
//  JSBridge.swift
//  dcss-ios
//
//  Created by Jonathan Lazar on 11/26/21.
//

import Foundation

let _aExScript =
"""
var press = jQuery.Event("keypress");
press.which = 111;
$("body").trigger(press);
"""
