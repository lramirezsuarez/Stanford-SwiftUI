//
//  PaletteStore.swift
//  EmojiArt
//
//  Created by Luis Alejandro Ramirez Suarez on 21/07/22.
//

import Foundation

struct Palette: Identifiable, Codable, Hashable {
    var name: String
    var emojis: String
    var id: Int
    
    fileprivate init(name: String, emojis: String, id: Int) {
        self.name = name
        self.emojis = emojis
        self.id = id
    }
}

class PaletteStore: ObservableObject {
    let name: String
    
    @Published var palettes = [Palette]() {
        didSet {
            storeInUserDefaults()
        }
    }
    
    private var userDefaultsKey: String {
        "PaletteStore: " + name
    }
    
    private func storeInUserDefaults() {
        
        UserDefaults.standard.set(try? JSONEncoder().encode(palettes), forKey: userDefaultsKey)
    }
    
    private func restoreFromUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey), let decodedPalettes = try? JSONDecoder().decode([Palette].self, from: jsonData) {
            palettes = decodedPalettes
        }
    }
    
    init(named name: String) {
        self.name = name
        restoreFromUserDefaults()
        if palettes.isEmpty {
            print("Using built-in palettes")
            insertPalette(named: "Vehicles", emojis: "πππππππππππ»ππππ²π΄π©Όπ¦Όπ¦½π΅ππΊπππππ πππππππππππππβοΈπ©π¬π«ππΈππΆβ΅οΈπ€π₯π³β΄π’")
            insertPalette(named: "Sports", emojis: "β½οΈππβΎοΈπ₯π±π₯πππΎπͺππΈππβ³οΈπ₯πͺππ₯π₯π₯π½πΉπΌπ·βΈπ₯πΏπͺππΉπ£π€Ώ")
            insertPalette(named: "Music", emojis: "π€π§πΌπΉπ₯πͺπ·πΊπͺπΈπͺπ»")
            insertPalette(named: "Animals", emojis: "ππ£π₯π¦π¦π¦π¦πΊππ΄π¦ππͺ±ππ¦ππππͺ°πͺ²πͺ³π¦π¦π·πΈπ¦π’ππ¦π¦π¦ππ¦π¦π¦π¦π‘π ππ¬π³ππ¦π¦­ππππ¦π¦π¦§π¦£ππ¦π¦πͺπ«π¦π¦π¦¬ππππππππ¦ππ¦ππ©π¦?πβπ¦Ίππββ¬πͺΆππ¦π¦€π¦π¦π¦’π¦©πππ¦π¦¨π¦‘π¦«π¦¦π¦₯πππΏπ¦πΎππ²")
            insertPalette(named: "Animal Faces", emojis: "πΆπ±π­πΉπ°π¦π»πΌπ»ββοΈπ¨π―π¦π?π·π½πΈπ΅πππ")
            insertPalette(named: "Flora", emojis: "π΅ππ²π³π΄πͺ΅π±πΏβοΈπππͺ΄πππππͺΊπͺΉπππͺΈπͺ¨πΎππ·πΉπ₯πͺ·πΊπΈπΌπ»")
            insertPalette(named: "Weather", emojis: "βοΈπ€βοΈπ₯βοΈπ¦π§βπ©π¨βοΈβοΈβοΈπͺππβοΈβοΈπ¨π¬")
            insertPalette(named: "COVID", emojis: "π€?π€§π·π€π€π¦ π")
            insertPalette(named: "Faces", emojis: "ππππππ₯Ήπππ€£π₯²βΊοΈππππππππ₯°πππππππππ€ͺπ€¨π§π€ππ₯Έπ€©π₯³πππππππβΉοΈπ£ππ«π©π₯Ίπ’π­π€π π‘π€¬π€―π³π₯΅π₯ΆπΆβπ«οΈπ±π¨π°π₯ππ€π€π«£π€­π«’π«‘π€«π« π€₯πΆπ«₯ππ«€ππ¬ππ―π¦π§π?π²π₯±π΄π€€πͺπ?βπ¨π΅π΅βπ«π€π₯΄π€’π€?π€§π·π€π€π€π€ ππΏπΉπΊπ€‘π©π»πβ οΈπ½πΎπ€π")
        } else {
            print("Successfully loaded palettes from user defaults.")
        }
    }
    
    // MARK: - Intent
    
    func palette(at index: Int) -> Palette {
        let safeIndex = min(max(index, 0), palettes.count - 1)
        return palettes[safeIndex]
    }
    
    @discardableResult
    func removePalette(at index: Int) -> Int {
        if palettes.count > 1, palettes.indices.contains(index) {
            palettes.remove(at: index)
        }
        return index % palettes.count
    }
    
    func insertPalette(named name: String, emojis: String? = nil, at index: Int = 0) {
        let unique = (palettes.max(by: { $0.id < $1.id })?.id ?? 0) + 1
        let palette = Palette(name: name, emojis: emojis ?? "", id: unique)
        let safeIndex = min(max(index, 0), palettes.count)
        palettes.insert(palette, at: safeIndex)
    }
}
