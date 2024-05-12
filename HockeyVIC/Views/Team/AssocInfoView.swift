//
//  AssocInfoView.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 9/5/2024.
//

import SwiftUI
import AudioToolbox

struct AssocInfoView: View {
    var assoc: AssocData
    let pasteboard = UIPasteboard.general
    @State private var pasted: Bool = false
    var body: some View {
        VStack (spacing: 15) {
            HStack {
                Image(systemName: "globe")
                    .foregroundStyle(Color("AccentColor"))
                Link(assoc.website, destination: URL(string: assoc.website)!)
            }
            if let phone = assoc.phone {
                HStack {
                    Image(systemName: "phone")
                        .foregroundStyle(Color("AccentColor"))
                    Text(phone)
                    Image(systemName: "doc.on.doc")
                        .foregroundStyle(pasted ? Color("AccentColor") : Color.gray )
                        .onTapGesture {
                            pasteboard.string = phone
                            pasted = true
                            AudioServicesPlaySystemSound(1520)
                        }
                }
            }
            if let email = assoc.email {
                HStack {
                    Image(systemName: "envelope")
                        .foregroundStyle(Color("AccentColor"))
                    Link(email, destination: URL(string: "mailto:\(email)")!)
                }
            }
            HStack (spacing: 20) {
                if let facebook = assoc.facebook {
                    Image("Facebook")
                        .renderingMode(.original)
                        .onTapGesture {
                            let appURL = URL(string: "fb://profile/\(assoc.fbid ?? "")")!
                            let webURL = URL(string: "https://www.facebook.com/\(facebook)")!
                            if UIApplication.shared.canOpenURL(appURL) { UIApplication.shared.open(appURL) }
                            else { UIApplication.shared.open(webURL) }
                        }
                }
                if let twitter = assoc.twitter {
                    Image("Twitter")
                        .renderingMode(.original)
                        .onTapGesture {
                            let appURL = URL(string: "twitter://user?screen_name=\(twitter)")!
                            let webURL = URL(string: "https://twitter.com/\(twitter)")!
                            if UIApplication.shared.canOpenURL(appURL as URL) { UIApplication.shared.open(appURL) }
                            else { UIApplication.shared.open(webURL) }
                        }
                }
                if let instagram = assoc.instagram {
                    Image("Instagram")
                        .renderingMode(.original)
                        .onTapGesture {
                            let appURL = URL(string: "instagram://user?username=\(instagram)")!
                            let webURL = URL(string: "https://instagram.com/\(instagram)")!
                            if UIApplication.shared.canOpenURL(appURL as URL) { UIApplication.shared.open(appURL) }
                            else { UIApplication.shared.open(webURL) }
                        }
                }
                if let youtube = assoc.youtube {
                    Image("Youtube")
                        .renderingMode(.original)
                        .onTapGesture {
                            let appURL = URL(string:"youtube://\(youtube)")!
                            let webURL = URL(string:"https://www.youtube.com/\(youtube)")!
                            if UIApplication.shared.canOpenURL(appURL as URL) { UIApplication.shared.open(appURL) }
                            else { UIApplication.shared.open(webURL) }
                        }
                }
                if let linkedin = assoc.linkedin {
                    Image("Linkedin")
                        .renderingMode(.original)
                        .onTapGesture {
                            let appURL = URL(string:"linkedin://company/\(linkedin)")!
                            let webURL = URL(string:"https://www.linkedin.com/company/\(linkedin)")!
                            if UIApplication.shared.canOpenURL(appURL as URL) { UIApplication.shared.open(appURL) }
                            else { UIApplication.shared.open(webURL) }
                        }
                }
            }
        }
        .foregroundStyle(Color("BackColor"))
        .symbolRenderingMode(.palette)
        .padding(.all, 20)
    }
}

#Preview {
    AssocInfoView(assoc: AssocData(id: UUID(), name: "", code: "", website: ""))
}

/*
 AssocData(id: UUID(), name: "Hockey Victoria", code: "vichockey", website: "http://www.hockeyvictoria.org.au/",
           phone: "(03) 9448 2100", email: "admin@hockeyvictoria.org.au", facebook: "hockeyvictoria",
          twitter: "hockeyvictoria", instagram: "hockeyvictoriaofficial",
          youtube: "UCKLiEfisDuOKWdsK7YV-bjQ", linkedin: "hockey-victoria"),
 */
