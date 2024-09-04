//
//  LiveWidgetLiveActivity.swift
//  LiveWidget
//
//  Created by 허원철(Woncheol Heo) on 9/3/24.
//

import ActivityKit
import WidgetKit
import SwiftUI



struct LiveWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MLBLiveAttributes.self) { context in
            LockScreenView(context: context)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    dynamicIslandExpandedLeadingView(context: context)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    dynamicIslandExpandedTrailingView(context: context)
                }
                
                DynamicIslandExpandedRegion(.center) {
                    dynamicIslandExpandedCenterView(context: context)
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    dynamicIslandExpandedBottomView(context: context)
                    // more content
                }
            } compactLeading: {
                compactLeadingView(context: context)
            } compactTrailing: {
                compactTrailingView(context: context)
            } minimal: {
                minimalView(context: context)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }

    
    func compactLeadingView(context: ActivityViewContext<MLBLiveAttributes>) -> some View {
        HStack {
            Image(context.state.awayTeam)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 20, height: 20)
                .cornerRadius(10)
            Spacer().frame(width:8)
            Text("\(context.state.awayScore)")
                .font(.system(size:14))
                .bold()
            Spacer().frame(width:10)
        }
    }
    
    func compactTrailingView(context: ActivityViewContext<MLBLiveAttributes>) -> some View {
        HStack {

            Text("\(context.state.homeScore)")
                .font(.system(size:14))
                .bold()
            Spacer().frame(width:8)
            Image(context.state.homeTeam)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 20, height: 20)
                .cornerRadius(10)


        }
    }
    
    func dynamicIslandExpandedLeadingView(context: ActivityViewContext<MLBLiveAttributes>) -> some View {
        VStack {
            HStack {
                Spacer().frame(width: 10)
                Text(context.state.awayTeam)
                    .font(.system(size:25))
                    .bold()
                Spacer().frame(width:8)
                Text("\(context.state.awayScore)")
                    .font(.system(size:25))
                    .bold()
            }
        }
    }
    
    func dynamicIslandExpandedTrailingView(context: ActivityViewContext<MLBLiveAttributes>) -> some View {
        VStack {
            HStack {
                Text(context.state.homeTeam)
                    .font(.system(size:25))
                    .bold()
                Spacer().frame(width:8)
                Text("\(context.state.homeScore)")
                    .font(.system(size:25))
                    .bold()
                Spacer().frame(width:10)
            }
        }
    }
    
    func dynamicIslandExpandedCenterView(context: ActivityViewContext<MLBLiveAttributes>) -> some View {
        HStack {
            Image(context.state.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 30, height: 30)
                .cornerRadius(15)
                .activityBackgroundTint(Color.black)
        }
    }

    
    func dynamicIslandExpandedBottomView(context: ActivityViewContext<MLBLiveAttributes>) -> some View {
        VStack {
            HStack {
                Spacer().frame(width: 10)
                Text(context.state.pitcher)
                    .font(.system(size:14))
                    .bold()
                Spacer()
                Text(context.state.hitter)
                    .font(.system(size:14))
                    .bold()
                Spacer().frame(width: 10)
            }
            
            HStack {
                Spacer().frame(width: 10)
                Text(context.state.era)
                    .font(.system(size:14))
                Spacer()
                Text(context.state.live)
                    .font(.system(size:14))
                    .multilineTextAlignment(.center)
                    .bold()
                
                Spacer()
                Text(context.state.battingAverage)
                    .font(.system(size:14))
                Spacer().frame(width: 10)
            }
         
        }
    }
    
    func minimalView(context: ActivityViewContext<MLBLiveAttributes>) -> some View {
        var imageName = ""
        var text = "winning"
        if context.state.awayScore > context.state.homeScore {
            imageName = context.state.awayTeam
        } else if context.state.awayScore < context.state.homeScore {
            imageName = context.state.homeTeam
        } else {
            imageName = "ball"
            text = "tie"
        }
        return VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 13, height: 13)
                .cornerRadius(6)
            Text(text)
                .font(.system(size:6))
        }
    }

}

@available(iOSApplicationExtension 16.1, *)
struct LockScreenView: View {
    var context: ActivityViewContext<MLBLiveAttributes>
    var body: some View {
        VStack {
            HStack {
                LockScreenLeadingView(context: context)
                Spacer()
                LockScreenCenterView(context: context)
                Spacer()
                LockScreenTrailingView(context: context)
            }
            HStack {
                LockScreenBottomView(context: context)
            }
        }
        .padding(15)
        .background(Color.white)
       
    }
    
    func LockScreenLeadingView(context: ActivityViewContext<MLBLiveAttributes>) -> some View {
        VStack {
            HStack {
                Spacer().frame(width: 10)
                Text(context.state.awayTeam)
                    .font(.system(size:25))
                    .bold()
                Spacer().frame(width:8)
                Text("\(context.state.awayScore)")
                    .font(.system(size:25))
                    .bold()
                
            }
        }
    }
    
    func LockScreenCenterView(context: ActivityViewContext<MLBLiveAttributes>) -> some View {
        HStack {
            Image(context.state.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .activityBackgroundTint(Color.black)
        }
    }
    
    func LockScreenTrailingView(context: ActivityViewContext<MLBLiveAttributes>) -> some View {
        VStack {
            HStack {
                Text(context.state.homeTeam)
                    .font(.system(size:25))
                    .bold()
                Spacer().frame(width:8)
                Text("\(context.state.homeScore)")
                    .font(.system(size:25))
                    .bold()
                Spacer().frame(width:10)
            }
        }
    }
    
    func LockScreenBottomView(context: ActivityViewContext<MLBLiveAttributes>) -> some View {
        VStack {
            HStack {
                Spacer().frame(width: 10)
                Text(context.state.pitcher)
                    .font(.system(size:14))
                    .bold()
                Spacer()
                Text(context.state.hitter)
                    .font(.system(size:14))
                    .bold()
                Spacer().frame(width: 10)
            }
            
            HStack {
                Spacer().frame(width: 10)
                Text(context.state.era)
                    .font(.system(size:14))
                Spacer()
                Text(context.state.live)
                    .font(.system(size:14))
                    .bold()
                Spacer()
                Text(context.state.battingAverage)
                    .font(.system(size:14))
                Spacer().frame(width: 10)
            }
        }
    
    }
}

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
    
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
