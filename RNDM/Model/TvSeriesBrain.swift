//
//  TvSeriesBrain.swift
//  RNDM
//
//  Created by Michael Reinders on 5/18/22.
//

import Foundation

struct TvSeriesBrain {
    var createSeriesArray: Array<Int> = []
    
    mutating func createSeriesFromSeasons(seasons:Int) {
        createSeriesArray = []// ensure start with fresh array
        for _ in 0..<seasons {
            createSeriesArray.append(1)
        }
    }
    
    mutating func editEpisodeCount(season: Int, episodes: Int) {
        createSeriesArray[season] = episodes
    }
    
    func saveSeries(name:String) {
        // create seasons + episodes- loop
        var seasons: Array<Season> = []
        let seasonsCount = createSeriesArray.count
        var totalEpisodeCount = 0
        for season in 0..<seasonsCount {
            var episodes: Array<Episode> = []
            for episode in 0..<createSeriesArray[season] {
                // init the episode and add one to offset array starting at zero
                let e = Episode.init(number: episode + 1)
                episodes.append(e)
                // increment totalepisodecount
                totalEpisodeCount += 1
            }
            print("Season " + String(season + 1))
            let s = Season.init(number: season + 1, episodeCount: episodes.count, episodes: episodes)
            seasons.append(s)
        }
        // create and save to Defaults
        let tvSeries = Series.init(title: name, seasonsCount: seasons.count, totalEpisodes: totalEpisodeCount, seasons: seasons)
        savedTV.append(tvSeries)
    }
}

struct Series: Codable {
    var title: String
    var seasonsCount: Int
    var totalEpisodes: Int
    var seasons: Array<Season>
    var plot: String?
    var image: URL?
    var premiere: Int?
    var finale: Int?
    
    func getRandomEpisode() -> RandomEpisode {
        let s = Int.random(in: 1..<seasonsCount)
        let e = Int.random(in: 1..<seasons[s].episodes.count)
        return RandomEpisode.init(season: s, episode: e)
    }
}

struct Season: Codable {
    var number: Int
    var episodeCount: Int
    var episodes: Array<Episode>
    var title: String?
    var year: String?
    var summary: String?
}

struct Episode: Codable {
    var number: Int
    var title: String?
    var summary: String?
    var image: URL?
    var runTime: String?
    var airDate: String?
}

struct RandomEpisode {
    var season: Int
    var episode: Int
}
