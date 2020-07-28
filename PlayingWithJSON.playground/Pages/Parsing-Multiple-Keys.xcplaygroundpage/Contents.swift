import Foundation

let json = """
{
  "Afpak": {
    "id": 1,
    "race": "hybrid",
    "flavors": [
      "Earthy",
      "Chemical",
      "Pine"
    ],
    "effects": {
      "positive": [
        "Relaxed",
        "Hungry",
        "Happy",
        "Sleepy"
      ],
      "negative": [
        "Dizzy"
      ],
      "medical": [
        "Depression",
        "Insomnia",
        "Pain",
        "Stress",
        "Lack of Appetite"
      ]
    }
  },
  "African": {
    "id": 2,
    "race": "sativa",
    "flavors": [
      "Spicy/Herbal",
      "Pungent",
      "Earthy"
    ],
    "effects": {
      "positive": [
        "Euphoric",
        "Happy",
        "Creative",
        "Energetic",
        "Talkative"
      ],
      "negative": [
        "Dry Mouth"
      ],
      "medical": [
        "Depression",
        "Pain",
        "Stress",
        "Lack of Appetite",
        "Nausea",
        "Headache"
      ]
    }
  },
  "Afternoon Delight": {
    "id": 3,
    "race": "hybrid",
    "flavors": [
      "Pepper",
      "Flowery",
      "Pine"
    ],
    "effects": {
      "positive": [
        "Relaxed",
        "Hungry",
        "Euphoric",
        "Uplifted",
        "Tingly"
      ],
      "negative": [
        "Dizzy",
        "Dry Mouth",
        "Paranoid"
      ],
      "medical": [
        "Depression",
        "Insomnia",
        "Pain",
        "Stress",
        "Cramps",
        "Headache"
      ]
    }
  }
}
""".data(using: .utf8)!


// models

struct Strain: Decodable {
  let id: Int
  let race: String
  let flavors: [String]
  let effects: [String: [String]]
}

// decode JSON to Swift objects
do {
  let dictionary = try JSONDecoder().decode([String: Strain].self, from: json)
  // use a for-loop to create [Strain] or use map {}
  var strains = [Strain]()
  for (_, value) in dictionary {
    let strain = Strain(id: value.id,
                        race: value.race,
                        flavors: value.flavors,
                        effects: value.effects)
    strains.append(strain)
  }
  dump(strains)
} catch {
  print(error)
}

