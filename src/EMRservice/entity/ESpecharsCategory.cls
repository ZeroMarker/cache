Class EMRservice.entity.ESpecharsCategory Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 代码
Property CategoryCode As %String(TRUNCATE = 1);

/// 描述
Property CategoryDesc As %String(TRUNCATE = 1);

/// 顺序
Property Sequence As %String;

Relationship Spechars As EMRservice.entity.ESpechars [ Cardinality = children, Inverse = Category ];

}
