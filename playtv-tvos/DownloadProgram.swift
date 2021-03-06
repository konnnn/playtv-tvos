//
//  DownloadProgram.swift
//  playtv-tvos
//
//  Created by Evgeny Konkin on 11.05.2019.
//  Copyright © 2019 Evgeny Konkin. All rights reserved.
//

import Foundation
import RealmSwift

class DownloadProgram: NSObject {
    
    public static func download(yaid: Int, completion: @escaping (_ list: List<Program>, _ failure: Bool) -> Void) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let formatterSocial = DateFormatter()
        formatterSocial.dateFormat = "yyyy-MM-dd"
        
        let date = Calendar.current.date(byAdding: .hour, value: -1, to: Date())
        
        let yaidString: String = "\(yaid)"
        let dateString = formatter.string(from: date!)
        
        // http://tv.evgenykonkin.ru/hdl/playtv_program_request.php?token=PT24121978&yaids=1073&date=2019-05-11+13:35:00&limit=10
        var urlString = "http://tv.evgenykonkin.ru/hdl/playtv_program_request.php?token=PT24121978&yaids=\(yaidString)&date=\(dateString)&limit=10"
        urlString = urlString.replacingOccurrences(of: " ", with: "+")
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            guard let dataResponse = data, error == nil else { return }
            
            do {
                let programList = List<Program>()
                let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: [])
                
                guard let jsonArray = jsonResponse as? [[String: String]] else {
                    completion(programList, true)
                    return
                }
                
                for dict in jsonArray {
                    let newProgram = Program()
                    newProgram.yaid = Int(dict["channel_id"] ?? "0")!
                    newProgram.objectID = dict["obj_id"]?.trimmingCharacters(in: .whitespaces)
                    newProgram.programID = dict["program_id"]?.trimmingCharacters(in: .whitespaces)
                    newProgram.programTitle = dict["program_title"]?.trimmingCharacters(in: .whitespaces)
                    newProgram.programDesc = dict["program_description"]?.trimmingCharacters(in: .whitespaces)
                    newProgram.episodeID = dict["episode_id"]?.trimmingCharacters(in: .whitespaces)
                    newProgram.episodeTitle = dict["episode_title"]?.trimmingCharacters(in: .whitespaces)
                    newProgram.episodeDesc = dict["episode_description"]?.trimmingCharacters(in: .whitespaces)
                    newProgram.seasonNumber = Int(dict["season_number"] ?? "0")!
                    newProgram.imgBaseURL = dict["img_base_url"]?.trimmingCharacters(in: .whitespaces)
                    newProgram.ageRestriction = dict["age_restriction"]?.trimmingCharacters(in: .whitespaces)
                    newProgram.typeName = dict["type_name"]?.trimmingCharacters(in: .whitespaces)
                    newProgram.countries = dict["countries"]?.trimmingCharacters(in: .whitespaces)
                    newProgram.year = dict["year"]?.trimmingCharacters(in: .whitespaces)
                    newProgram.socialDate = formatterSocial.date(from: dict["social_date"]!)
                    newProgram.start = formatter.date(from: dict["start"]!)
                    newProgram.finish = formatter.date(from: dict["finish"]!)
                    programList.append(newProgram)
                }
                completion(programList, false)
                
            } catch let parsingError {
                print("Ошибка парсинга программы передач: ", parsingError)
            }
            
        }
        task.resume()
    }
    
}
