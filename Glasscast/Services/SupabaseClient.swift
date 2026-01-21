//
//  SupabaseClient.swift
//  Glasscast
//
//  Created by Astha Arora on 20/01/26.
//


import Foundation
import Supabase

struct SupabaseConfig {
    static let url = URL(string: "https://qiikaaunpcmsgyzmitkl.supabase.co")!
    static let anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFpaWthYXVucGNtc2d5em1pdGtsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg4MTU0ODcsImV4cCI6MjA4NDM5MTQ4N30.ZHdvLUzPY6SZZXEtqu8BaoZZZaAetuy_G7QHniEEhhQ"
}

let supabase = SupabaseClient(
    supabaseURL: SupabaseConfig.url,
    supabaseKey: SupabaseConfig.anonKey
)
