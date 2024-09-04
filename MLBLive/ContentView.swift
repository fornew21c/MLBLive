//
//  ContentView.swift
//  MLBLive
//
//  Created by 허원철(Woncheol Heo) on 9/3/24.
//

import SwiftUI
import ActivityKit

struct ContentView: View {
    @State var activities = Activity<MLBLiveAttributes>.activities
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("Create an activity to start a live activity")
                
                    Button(action: {
                        createActivity()
                        listAllDeliveries()
                    }) {
                        Text("Live Start").font(.headline)
                            .foregroundColor(.blue)
                    }
                    Button(action: {
                        endAllActivity()
                        listAllDeliveries()
                    }) {
                        Text("모든 중계 종료").font(.headline)
                            .foregroundColor(.blue)
                    }
                }
                Section {
                    if !activities.isEmpty {
                        Text("중계 중 경기")
                    }
                    activitiesView()
                }
            }
      
            .navigationTitle("MLB 실시간 현황")
            .fontWeight(.ultraLight)
        }
    }
    
    func createActivity() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if error != nil {
                // Handle the error here.
            }
            
            // Enable or disable features based on the authorization.
        }
        
    
        
        let contentState = MLBLiveAttributes.ContentState(awayTeam: "LAD",
                                                          homeTeam: "SF",
                                                          awayScore: 7,
                                                          homeScore: 5,
                                                          pitcher: "Otani Shohei",
                                                          hitter: "Junghu Lee",
                                                          era: "3.07",
                                                          battingAverage: "0.375",
                                                          live: "Bot 9th 3-2 2out",
                                                          imageName: "baseball")
        
        let content = ActivityContent(state: contentState, staleDate: nil, relevanceScore: 0)
        
        let attritues = MLBLiveAttributes(ballpark: "Fanway Park")
        do {
            let activity = try Activity<MLBLiveAttributes>.request(
                attributes: attritues,
                content: content,
                pushType: PushType.token)
            
            print("Activity Added Successfully. id: \(activity.id)")
            Task {
                 for await data in activity.pushTokenUpdates {
                    let myToken = data.map {String(format: "%02x", $0)}.joined()
                    // Keep this myToken for sending push notifications
                     print("act push token: \(myToken)")
                 }
              }
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
    
    func update(activity: Activity<MLBLiveAttributes>) {
        
        Task {
            let updatedStatus = MLBLiveAttributes.ContentState(awayTeam: activity.content.state.awayTeam,
                                                               homeTeam: activity.content.state.homeTeam,
                                                               awayScore: activity.content.state.awayScore,
                                                               homeScore: activity.content.state.homeScore,
                                                               pitcher: activity.content.state.pitcher,
                                                               hitter: activity.content.state.hitter,
                                                               era: activity.content.state.era,
                                                               battingAverage: activity.content.state.battingAverage,
                                                               live: activity.content.state.live,
                                                               imageName: activity.content.state.imageName)

            await activity.update(using: updatedStatus, alertConfiguration: AlertConfiguration(title: "Title",
                                                                                               body: "Body",
                                                                                               sound: .default))
        }
    }
    
    func updateFromView(activity: Activity<MLBLiveAttributes>) {
      
        Task {
            let updatedStatus = MLBLiveAttributes.ContentState(awayTeam: "LAD",
                                                               homeTeam: "SF",
                                                               awayScore: 7,
                                                               homeScore: 8,
                                                               pitcher: "Ohtani Shohei",
                                                               hitter: "Junghu Lee",
                                                               era: "3.14",
                                                               battingAverage: "0.382",
                                                               live: "JungHu hits 3 homerun.\n The match just ended",
                                                               imageName: "ball")

            await activity.update(using: updatedStatus, alertConfiguration: AlertConfiguration(title: "Title",
                                                                                               body: "Body",
                                                                                               sound: .default))
        }
    }
    
    func listAllDeliveries() {
        var activities = Activity<MLBLiveAttributes>.activities
        activities.sort { $0.id > $1.id }
        self.activities = activities
    }

    func endAllActivity() {
        Task {
            for activity in Activity<MLBLiveAttributes>.activities{
                await activity.end(dismissalPolicy: .immediate)
            }
        }
    }
}

@available(iOS 16.1, *)
extension ContentView {
    
    func activitiesView() -> some View {
        var body: some View {
            ScrollView {
                ForEach(activities, id: \.id) { activity in
                    let ballpark = String(activity.attributes.ballpark)
                    HStack(alignment: .center) {
                        Text("중계 구장: " + ballpark)
                    
                        Text("update")
                            .font(.headline)
                            .foregroundColor(.green)
                            .onTapGesture {
                                updateFromView(activity: activity)
                           
                            }
                     
                    }
                }
            }
        }
        return body
    }
}
