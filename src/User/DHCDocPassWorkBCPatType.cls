/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 医生交班本病人类型表
Class User.DHCDocPassWorkBCPatType Extends (%Persistent, User.Abstract)
{

Relationship BPParRef As User.DHCDocPassWorkBCMain [ Cardinality = parent, Inverse = ChildPatType, Required, SqlFieldName = BP_ParRef ];

/// 代码
Property BPCode As %String [ SqlColumnNumber = 2, SqlFieldName = BP_Code ];

/// 描述
Property BPDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BP_Desc ];

/// 是否显示(1/0)
Property BPActive As %String [ SqlColumnNumber = 4, SqlFieldName = BP_Active ];

/// 显示顺序
Property BPNum As %String [ SqlColumnNumber = 5, SqlFieldName = BP_Num ];

/// 宽高
Property BPWH As %String [ SqlColumnNumber = 6, SqlFieldName = BP_WH ];

/// 模板链接
Property BPURL As %String [ SqlColumnNumber = 7, SqlFieldName = BP_URL ];

/// 默认选中
Property BPSelected As %String [ SqlColumnNumber = 8, SqlFieldName = BP_Selected ];

Index BPCode On BPCode As Exact;

Index BPNum On BPNum As Exact;

Index BPURL On BPURL As Exact;

Storage Default
{
<Data name="DHCDocPassWorkBCPatTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BPCode</Value>
</Value>
<Value name="3">
<Value>BPDesc</Value>
</Value>
<Value name="4">
<Value>BPActive</Value>
</Value>
<Value name="5">
<Value>BPNum</Value>
</Value>
<Value name="6">
<Value>BPWH</Value>
</Value>
<Value name="7">
<Value>BPURL</Value>
</Value>
<Value name="8">
<Value>BPSelected</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildPatType")</DataLocation>
<DefaultData>DHCDocPassWorkBCPatTypeDefaultData</DefaultData>
<IdLocation>^User.DHCDocPassWorkBCMainC("ChildPatType")</IdLocation>
<IndexLocation>^User.DHCDocPassWorkBCPatTypeI</IndexLocation>
<StreamLocation>^User.DHCDocPassWorkBCPatTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
