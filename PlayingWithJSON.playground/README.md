# Parsing JSON using Swift Playgrounds 

There are four examples in the **Pages** folder of this repo.

```swift 
let json = """
{
 "results": [
   {
      "dataStructure": "Array"
    },
    {
      "dataStructure": "Dictionary"
    },
    {
      "dataStructure": "Stack"
    }
 ]
}
""".data(using: .utf8)!

struct DSAWrapper: Decodable {
  let results: [DSA]
}

struct DSA: Decodable {
  let dataStructure: String
}


let dictionary = try JSONDecoder().decode(DSAWrapper.self, from: json)

dump(dictionary.results)

/*
 ▿ 3 elements
 ▿ __lldb_expr_214.DSA
   - dataStructure: "Array"
 ▿ __lldb_expr_214.DSA
   - dataStructure: "Dictionary"
 ▿ __lldb_expr_214.DSA
   - dataStructure: "Stack"
*/
```
