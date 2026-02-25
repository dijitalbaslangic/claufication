import Foundation

// MARK: - JSONL Session Entry

struct SessionEntry: Decodable {
    let type: String
    let timestamp: String?
    let subtype: String?
    let message: EntryMessage?

    // For turn_duration entries
    let costUSD: Double?
    let durationMs: Int?
    let durationApiMs: Int?

    enum CodingKeys: String, CodingKey {
        case type, timestamp, subtype, message
        case costUSD = "costUSD"
        case durationMs = "durationMs"
        case durationApiMs = "durationApiMs"
    }
}

struct EntryMessage: Decodable {
    let role: String?
    let content: MessageContent?
}

// Content can be a plain String or an array of ContentBlocks
enum MessageContent: Decodable {
    case text(String)
    case blocks([ContentBlock])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let text = try? container.decode(String.self) {
            self = .text(text)
            return
        }
        if let blocks = try? container.decode([ContentBlock].self) {
            self = .blocks(blocks)
            return
        }
        self = .text("")
    }

    var plainText: String {
        switch self {
        case .text(let str):
            return str
        case .blocks(let blocks):
            return blocks
                .filter { $0.type == "text" }
                .compactMap(\.text)
                .joined(separator: "\n")
        }
    }

    var hasToolUse: Bool {
        switch self {
        case .text:
            return false
        case .blocks(let blocks):
            return blocks.contains { $0.type == "tool_use" }
        }
    }
}

struct ContentBlock: Decodable {
    let type: String
    let text: String?
    let name: String?
    let input: AnyCodable?
}

// Lightweight wrapper for arbitrary JSON values we don't need to inspect
struct AnyCodable: Decodable {
    init(from decoder: Decoder) throws {
        // Just consume the value, we don't need it
        _ = try? decoder.singleValueContainer()
    }
}
