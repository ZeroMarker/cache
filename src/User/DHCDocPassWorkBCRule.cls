/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 医生交班本规则配置
Class User.DHCDocPassWorkBCRule Extends (%Persistent, User.Abstract)
{

Relationship BRParRef As User.DHCDocPassWorkBCMain [ Cardinality = parent, Inverse = ChildRule, Required, SqlFieldName = BR_ParRef ];

/// 代码
Property BRCode As %String [ SqlColumnNumber = 2, SqlFieldName = BR_Code ];

/// 描述
Property BRDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BR_Desc ];

/// 数值
Property BRValue As %String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = BR_Value ];

/// 备注
Property BRNote As %String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = BR_Note ];

Index BRCode On BRCode As Exact;

Storage Default
{
<Data name="DHCDocPassWorkBCRuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BRCode</Value>
</Value>
<Value name="3">
<Value>BRDesc</Value>
</Value>
<Value name="4">
<Value>BRValue</Value>
</Value>
<Value name="5">
<Value>BRNote</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildRule")</DataLocation>
<DefaultData>DHCDocPassWorkBCRuleDefaultData</DefaultData>
<IdLocation>^User.DHCDocPassWorkBCMainC("ChildRule")</IdLocation>
<IndexLocation>^User.DHCDocPassWorkBCRuleI</IndexLocation>
<StreamLocation>^User.DHCDocPassWorkBCRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
