//
//  ContentView.swift
//  swfitapp
//
//  Created by chen dandan on 2025/4/15.
//

import SwiftUI

struct DataCard: View {
    let title: String
    let amount: String
    let percentage: String
    let change: String
    let isNegative: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(.white)
                .font(.system(size: 16))
            HStack(alignment: .bottom) {
                Text(amount)
                    .foregroundColor(.white)
                    .font(.system(size: 24, weight: .bold))
                Spacer()
                VStack(alignment: .trailing) {
                    Text(percentage)
                        .foregroundColor(.white)
                    Text(change)
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "8A6FE8"), Color(hex: "7C65E6")]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(12)
    }
}

struct DetailItem: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 16))
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "F5F5F5").edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // 核心数据部分
                        VStack(alignment: .leading, spacing: 10) {
                            Text("核心数据")
                                .font(.system(size: 18, weight: .medium))
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 10) {
                                DataCard(title: "今日收益", amount: "8911.07", percentage: "-12.52%", change: "-1274.86", isNegative: true)
                                DataCard(title: "昨日收益", amount: "10185.93", percentage: "-2.05%", change: "-212.73", isNegative: true)
                                DataCard(title: "昨日收益(国内)", amount: "995.35", percentage: "-0.64%", change: "-6.37", isNegative: true)
                                DataCard(title: "昨日收益(海外)", amount: "9190.58", percentage: "-2.2%", change: "-206.36", isNegative: true)
                                DataCard(title: "本月收益", amount: "16.23万", percentage: "-50.87%", change: "-16.80万", isNegative: true)
                                DataCard(title: "上月累计收益", amount: "33.03万", percentage: "+6.72%", change: "+2.08万", isNegative: false)
                            }
                        }
                        .padding(.horizontal)
                        
                        // 详细数据部分
                        VStack(alignment: .leading, spacing: 10) {
                            Text("详细数据")
                                .font(.system(size: 18, weight: .medium))
                                .padding(.horizontal)
                            
                            VStack(spacing: 1) {
                                DetailItem(icon: "building.columns", title: "账户", subtitle: "快速查看账户总收益")
                                DetailItem(icon: "square.grid.2x2", title: "应用", subtitle: "洞悉不同应用变现能力")
                                DetailItem(icon: "chevron.left.forwardslash.chevron.right", title: "代码位", subtitle: "掌握数据，优化广告位!")
                            }
                            .background(Color.white)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("首页")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "line.horizontal.3")
                            .foregroundColor(.white)
                    }
                }
            }
            .toolbarBackground(Color(hex: "4169E1"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

// 用于支持十六进制颜色的扩展
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    ContentView()
}
