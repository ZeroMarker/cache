Class EMRservice.entity.ESpechars Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 代码
Property CharCode As %String(TRUNCATE = 1);

/// 描述
Property CharDesc As %String(TRUNCATE = 1);

/// 顺序
Property Sequence As %String;

Relationship Category As EMRservice.entity.ESpecharsCategory [ Cardinality = parent, Inverse = Spechars ];

}
