/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 医生交班本配置表
Class User.DHCDocPassWorkBCMain Extends (%Persistent, User.Abstract)
{

Relationship ChildTime As User.DHCDocPassWorkBCTime [ Cardinality = children, Inverse = BCParRef ];

Relationship ChildLoc As User.DHCDocPassWorkBCLoc [ Cardinality = children, Inverse = BLParRef ];

Relationship ChildPatType As User.DHCDocPassWorkBCPatType [ Cardinality = children, Inverse = BPParRef ];

Relationship ChildRule As User.DHCDocPassWorkBCRule [ Cardinality = children, Inverse = BRParRef ];

Relationship ChildTPL As User.DHCDocPassWorkBCTpl [ Cardinality = children, Inverse = TPLParRef ];

/// 医院
Property BMHosp As CTHospital [ SqlColumnNumber = 2, SqlFieldName = BM_Hosp ];

/// 班次类型(L/C:科室类型/通用类型)
Property BMType As %String [ SqlColumnNumber = 3, SqlFieldName = BM_Type ];

/// 类型描述
Property BMDesc As %String [ SqlColumnNumber = 4, SqlFieldName = BM_Desc ];

/// 是否激活(1/0)
Property BMActive As %String [ SqlColumnNumber = 5, SqlFieldName = BM_Active ];

Index BMType On BMType As Exact;

Index BMHosp On BMHosp As Exact;

Index BMHospType On (BMHosp As Exact, BMType As Exact);

Storage Default
{
<Data name="DHCDocPassWorkBCMainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BMHosp</Value>
</Value>
<Value name="3">
<Value>BMType</Value>
</Value>
<Value name="4">
<Value>BMDesc</Value>
</Value>
<Value name="5">
<Value>BMActive</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocPassWorkBCMainD</DataLocation>
<DefaultData>DHCDocPassWorkBCMainDefaultData</DefaultData>
<IdLocation>^User.DHCDocPassWorkBCMainD</IdLocation>
<IndexLocation>^User.DHCDocPassWorkBCMainI</IndexLocation>
<StreamLocation>^User.DHCDocPassWorkBCMainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
