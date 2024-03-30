//
//  Struct.swift
//  MyDua
//
//  Created by IB Arts Mac on 30/03/24.
//

import Foundation


struct ArabicAamaal: Codable {
    
    var aamaal_type: String!
    var amalRecord: [AamallRecord]
    
    
}

struct AamallRecord: Codable {
    
    var aamaal_title: String!
    var musicURL: String!
    var musicTitle: String!
    var pdfString: String!
    
}


class ArabicAamaall {
    
    var aamaal_type: String!
    var amalRecord: [AamallRecord]
    
    init(aamaal_type: String!, amalRecord: [AamallRecord]) {
        self.aamaal_type = aamaal_type
        self.amalRecord = amalRecord
    }
    
    struct AamallRecord {
        
        var aamaal_title: String!
        var musicURL: String!
        var musicTitle: String!
        var pdfString: String!
        
        
        init(aamaal_title: String!, musicURL: String!, musicTitle: String!, pdfString: String!) {
            self.aamaal_title = aamaal_title
            self.musicURL = musicURL
            self.musicTitle = musicTitle
            self.pdfString = pdfString
        }
    }
    
    static var myAamaallArray: [ArabicAamaall] = [
        ArabicAamaall(aamaal_type: "Night Dua", amalRecord: [ ArabicAamaall.AamallRecord(aamaal_title: "Book of companions- Iqbal Aamal - 19th",
                                                                                         musicURL: " ",
                                                                                         musicTitle: " ",
                                                                                         pdfString: "سُبْحَانَهُ سُبْحَانَهُ سُبْحَانَهُ سُبْحَانَهُ"),
                                                              ArabicAamaall.AamallRecord(aamaal_title: "Book of companions- Iqbal Aamal - 19th",
                                                                                           musicURL: "Test",
                                                                                           musicTitle: "Test",
                                                                                           pdfString: "سُبْحَانَهُ سُبْحَانَهُ سُبْحَانَهُ سُبْحَانَهُ"),
        ]),
        ArabicAamaall(aamaal_type: "Dua after obligatory prayer", amalRecord: [ ArabicAamaall.AamallRecord(aamaal_title: "Munajat Imam Ali(as)- Masjid Kufa Sahifa",
                                                                                         musicURL: "https://mydua.online/wp-content/uploads/2023/11/Arabic-Munajat-Imam-Alias-Masjid-Kufa-Sahifa.mp3",
                                                                                         musicTitle: "Munajat Imam Ali(as)- Masjid Kufa Sahifa",
                                                                                         pdfString: "ايَ يا مَوْلايَ أَنْتَ الْمَوْلىٰ وَأَنَا")
        ]),
        ArabicAamaall(aamaal_type: "Dua Sahar", amalRecord: [ ArabicAamaall.AamallRecord(aamaal_title: "Common Aamal of Shab-e-Qadr",
                                                                                         musicURL: " ",
                                                                                         musicTitle: " ",
                                                                                         pdfString: "سْتَغْفِرُ اللهَ واَتُوْبُ اِلَيْ"),
                                                              ArabicAamaall.AamallRecord(aamaal_title: "Common Aamal of Shab-e-Qadr",
                                                                                         musicURL: " ",
                                                                                         musicTitle: " ",
                                                                                         pdfString: "سْتَغْفِرُ اللهَ واَتُوْبُ اِلَيْ")
        ])
    ]

    
}
