
import Foundation
struct Habit: Identifiable, Codable{
    var id: String = UUID().uuidString
    var titel: String
    var createdAtn : Date
}
