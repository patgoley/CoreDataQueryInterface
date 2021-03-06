//
// Generated by CDQI on 2016-04-30.
//
// This file was generated by a tool. Further invocations of this tool will overwrite this file.
// Edit it at your own risk.
//

import CoreDataQueryInterface

class SongAttribute: EntityAttribute, Aggregable {
    private(set) lazy var name: StringAttribute = { StringAttribute("name", parent: self) }()
    private(set) lazy var position: NumericAttribute = { NumericAttribute("position", parent: self, type: .Integer32AttributeType) }()
    private(set) lazy var year: NumericAttribute = { NumericAttribute("year", parent: self, type: .Integer32AttributeType) }()
    private(set) lazy var artist: ArtistAttribute = { ArtistAttribute("artist", parent: self) }()
}

extension Song: EntityType {
    typealias EntityAttributeType = SongAttribute
}

