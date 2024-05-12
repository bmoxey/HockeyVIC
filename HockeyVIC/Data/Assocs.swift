//
//  Assocs.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 5/5/2024.
//

import Foundation
struct AssocData: Equatable, Hashable {
    var id: UUID
    var name: String
    var code: String
    var website: String
    var phone: String?
    var email: String?
    var facebook: String?
    var fbid: String?
    var twitter: String?
    var instagram: String?
    var youtube: String?
    var linkedin: String?
}
var assocs: [AssocData] = [
    AssocData(id: UUID(), name: "Hockey Victoria", code: "vichockey", website: "http://www.hockeyvictoria.org.au/",
             phone: "(03) 9448 2100", email: "admin@hockeyvictoria.org.au", facebook: "hockeyvictoria",
             fbid: "174054042617024" ,twitter: "hockeyvictoria", instagram: "hockeyvictoriaofficial",
             youtube: "@hockeyvictoriavideo", linkedin: "hockey-victoria"),
    AssocData(id: UUID(), name: "Ballarat", code: "hockeyballarat", website: "http://www.hockeyballarat.com.au/",
             facebook: "HockeyBallarat", fbid: "100545662441747",instagram: "HockeyBallarat"),
    AssocData(id: UUID(), name: "Central Vic", code: "hockeycentralv", website: "https://www.revolutionise.com.au/hockeycentralv/",
              email: "hcv.secretary@gmail.com" ,facebook: "HockeyCentralVic", fbid: "582524505100761"),
    AssocData(id: UUID(), name: "Geelong", code: "geelongha", website: "https://www.hockeygeelong.asn.au/",
              email: "admin@hockeygeelong.asn.au", facebook: "hockeygeelongofficial", fbid: "552242114917174", instagram: "hockey.geelong"),
    AssocData(id: UUID(), name: "Goulburn Valley", code: "gvha", website: "https://gvhockey.com.au/",
             email: "info@gvhockey.com.au" ,facebook: "gvhockey", fbid: "1575701422680247" ,instagram: "gv.hockey", linkedin: "gvhockey"),
    AssocData(id: UUID(), name: "North Central", code: "northcentralha", website: "https://www.revolutionise.com.au/northcentralha",
             facebook: "North-Central-Hockey-Association-129879000422224", fbid: "129879000422224"),
    AssocData(id: UUID(), name: "South West", code: "wndha", website: "https://www.hockeysouthwest.org.au/",
             email: "contact@hockeysouthwest.org.au" ,facebook: "hockeysouthwest", fbid: "71052114668" ,instagram: "hockeysouthwest"),
    AssocData(id: UUID(), name: "Sunraysia", code: "sunraysiaha", website: "https://www.sunraysiahockey.com.au/",
             email: "sunraysiahockey@gmail.com", facebook: "SunraysiaHockeyAssociation", fbid: "240560789423038")
]

var currentAssoc: AssocData = assocs[0]
