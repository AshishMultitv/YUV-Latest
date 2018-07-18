//
//  Constant.swift
//  Dollywood Play
//
//  Created by Cybermac002 on 26/09/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit

//////livenocturnalheader///////////
let livenocturnalheader = "Live@Nocturnal"
let livenocturnaldes = "A live performance by the artist with a selected setlist of his/her best originals, interspersed with shortform interviews"


///////////backstageheader/////////////
let backstageheader = "Backstage Pass"
let backstagedes = "Footage entailing the creative process, including the making of a song/album. Rehearsals and what sparks the collaborative process."

///////////kickoutjamsheader/////////////

let kickoutjamsheader = "Kick Out The Jams"
let kickoutjamsdes = "Footage of spontaneous jam session at Nocturnal and encapsulating &quot; music as a collaborative art &quot;"


///////////muzakheader/////////////

let muzakheader = "Motaimadi Muzak"
let muzakdes = "Live from the terrace... mostly casual jams, bits of interviews per-jam"





///////////soundstoriesheader/////////////

let soundstoriesheader = "Sounds & Stories"
let soundstoriesdes = "Stories about the journey of the artists, some rare moments encapsulating the creative process and their personal insights into their work."


///////////revampsheader/////////////

let revampsheader = "Revamps"
let revampsdes = "A live performance by the artist with a selected list of covers, theme-based, interspersed with short-form interviews about their inspiration from the song and maybe the re-interpretation with context."

///////////twotangoheader/////////////

let twotangoheader = "Two to Tango"
let twotangodes = "Two or more experienced artists discussing their craft at Nocturnal."


///////////insideasongheader/////////////

let insideasongheader = "Inside A Song"
let insideasongdes = "Interesting anecdotes from Tamil Songs."


///////////yoseeheader/////////////

let yoseeheader = "YoSee"
let yoseedes = "Tamil Movie Reviews by Charu Nivedita."



///////////mustwatchheader/////////////

let mustwatchheader = "Must Watch"
let mustwatchdes = "100 Tamil Films, 100 Hollywood Films, 100 Best Films of World Cinema."


///////////filmroomheader/////////////

let filmroomheader = "Film Room"
let filmroomdes = "Raw talent exists but no one starts at the very top. Short Films from Tomorrow\'s Big Film Makers."


///////////comedystireheader/////////////

let comedystireheader = "Comedy & Satire"
let comedystiredes = "Constructively criticize people\'s follies &amp; Vices.Humor, Slapstick, Farce, Irony, Wit &amp; Satire."


///////////standupheader/////////////

let standupheader = "Stand-Up"
let standupdes = "Ring side experience for on-line audiences to see amazing stand-up routines by leading practitioners."



///////////maydayheader/////////////

let maydayheader = "May Day"
let maydaydes = "Movies will make you famous; Television will make you rich - But theatre will make you good.\n    - Terrence Mann \n\nBringing live theatre performances to your screens. Begin this experience with these six short plays.\n\n 1. Sure Thing \n 2. Death of an Actor \n 3. Love actually\n 4  Remorse\n 5. Victim \n 6. My Name Is Rosa"


///////////maydayheader/////////////

let augustrushheader = "August Rush"
let augustrushdes = "An actor must never be afraid to make a fool of himself.\n - Harvey Cocks \n \nIn the second edition, we took things one steap further.\n For more theatrical thrills, unexpected twists and some \"bare\"performances watch these ten short live plays!\n\n1. Ordinary City \n2. My Knight in Dull Armour \n3. Family Feud \n4. Flowers \n5. Am I Beautiful?\n6. The Blind Side \n. Once A Year\n8. Do you Believe Me?  \n9. The Last Goodbye \n10. The Interpreter"


///////////redoctoberheader/////////////

let redoctoberheader = "Red October"
let redoctoberdes = "We\'re actors - we\'re the opposite of people.\" \n   - Tom Stoppard\n\nOctober promises to shake your notions of comfort and give you some chills and shivers down your spine.\nOur theme goes insane as we push beyond our boundaries to give you ten plays that will have you jumping in your seats!\n\nDate: 6th October 2017\nVenue: Museum Theatre\nTime: 7 pm"

///////////comeseptemberheader/////////////

let comeseptemberheader = "Come September"
let comeseptemberdes = "Act well your part; there all the honour lies.\n      - Alexander Pope \n\nCome, September 30th 2017 to watch as we go EVEN grander with a live band, musical productions, stand-up comedy, movement theatre, dance theatre and a varying gamut of genres across ten plays.\n\n Tickets available on instamojo - http://imojo.in/codafortheatre at a nominal entry fee of Rs150/\n\nDate: 30th September 2017\nVenue: Music Academy Main Hall \n Time: 7 pm"


class Constant: NSObject {
    ///////////// nonrenewsubscription /////////
    static let onedaynonrenewsubscription = "OneDayNonRenewing"
    static let oneweeknonrenewsubscription = "OneWeekNonRenewing"
    static let onemonthnonrenewsubscription = "YuvOneMonthNonRenewing"
    static let threemonthnonrenewsubscription = "ThreeMonthNonRenewing"
    static let sixmonthnonrenewsubscription = "SixMonthNonRenewing"
    static let oneyearnonrenewsubscription = "OneYearNonRenewing"
    
      ///////////// Autorenewsubscription /////////
    static let onemonthautorenewsubscription = "OneMonthAutoRenewable"
    static let threemonthautorenewsubscription = "ThreeMonthAutoRenewable"
    static let sixmonthautorenewsubscription = "SixMonthAutoRenewable"
    static let oneyearautorenewsubscription = "OneYearAutoRenewable"
    
    ///////////// nonrenews Internatinal subscription /////////
    static let onemonthInternationalnonrenewsubscription = "YuvInternationalOneMonthNonRenewing"
    static let oneyearInternationalnonrenewsubscription =  "YuvInternationalOneYearNonRenewing"

    
    static let iapsecreatKey = "91020750d82b4a93bde3dcd19645abd3"
    
    

    
    
static func getsubscriptionid(subscriptiontype:String,subscriptionname:String,regiontype:String) -> String
    {
        
       
        
       if(regiontype == "2")
       {
        
        switch subscriptionname {
         case "1 month":
            return Constant.onemonthInternationalnonrenewsubscription
         case "1 year":
            return Constant.oneyearInternationalnonrenewsubscription
        default:
            return ""
        }
        
        }
        else
       {
         if(subscriptiontype == "AutoRenewable") {
            switch subscriptionname {
            case "1 month":
                return Constant.onemonthautorenewsubscription
            case "3 month":
                return Constant.threemonthautorenewsubscription
            case "6 month":
                return Constant.sixmonthautorenewsubscription
            case "1 year":
                return Constant.oneyearautorenewsubscription
             default:
                return ""
            }
        }
        else if (subscriptiontype == "NonRenewable")
        {
            switch subscriptionname {
            case "1 day":
                return Constant.onedaynonrenewsubscription
            case "1 week":
                return Constant.oneweeknonrenewsubscription
            case "1 month":
                return Constant.onemonthnonrenewsubscription
            case "3 month":
                return Constant.threemonthnonrenewsubscription
            case "6 month":
                return Constant.sixmonthnonrenewsubscription
             case "1 year":
                return Constant.oneyearnonrenewsubscription
            default:
                return ""
            }
        }
         return ""
     
    }
    }
    
    
}
