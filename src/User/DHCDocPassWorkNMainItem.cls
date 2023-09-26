/// CTOR: QP
/// DATE: 2021-07-14
/// DESC: 医生交班本主表
Class User.DHCDocPassWorkNMainItem Extends (%Persistent, User.Abstract)
{

Relationship IParRef As User.DHCDocPassWorkNMain [ Cardinality = parent, Inverse = ChildItem, Required, SqlFieldName = I_ParRef ];

/// 代码
Property ICode As %String [ SqlColumnNumber = 2, SqlFieldName = I_Code ];

/// 值
Property IValue As %String [ SqlColumnNumber = 3, SqlFieldName = I_Value ];

Index ICode On ICode As Exact;

Storage Default
{
<Data name="DHCDocPassWorkNMainItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ICode</Value>
</Value>
<Value name="3">
<Value>IValue</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildItem")</DataLocation>
<DefaultData>DHCDocPassWorkNMainItemDefaultData</DefaultData>
<IdLocation>^User.DHCDocPassWorkNMainC("ChildItem")</IdLocation>
<IndexLocation>^User.DHCDocPassWorkNMainItemI</IndexLocation>
<StreamLocation>^User.DHCDocPassWorkNMainItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
