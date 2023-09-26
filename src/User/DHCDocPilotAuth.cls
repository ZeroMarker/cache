/// CTOR: QP
/// DATE: 2022-03-04
/// DESC: 药物临床试验权限表
Class User.DHCDocPilotAuth Extends (%Persistent, User.Abstract)
{

Relationship ChildSub As User.DHCDocPilotAuthSub [ Cardinality = children, Inverse = SParRef ];

/// 院区
Property AHospID As User.CTHospital [ Required, SqlColumnNumber = 2, SqlFieldName = A_HospID ];

/// 类型【Group:安全组 Loc:科室】
Property AType As %String [ SqlColumnNumber = 3, SqlFieldName = A_Type ];

/// 值
Property AValue As %String [ SqlColumnNumber = 4, SqlFieldName = A_Value ];

/// 是否启用
Property AActive As %String [ SqlColumnNumber = 5, SqlFieldName = A_Active ];

/// 添加日期
Property AAddDate As %Date [ SqlColumnNumber = 6, SqlFieldName = A_AddDate ];

/// 添加日期
Property AAddTime As %Time [ SqlColumnNumber = 7, SqlFieldName = A_AddTime ];

/// 添加用户
Property AAddUser As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = A_AddUser ];

Index HospTypeValue On (AHospID As Exact, AType As Exact, AValue As Exact);

Storage Default
{
<Data name="DHCDocPilotAuthDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AHospID</Value>
</Value>
<Value name="3">
<Value>AType</Value>
</Value>
<Value name="4">
<Value>AValue</Value>
</Value>
<Value name="5">
<Value>AActive</Value>
</Value>
<Value name="6">
<Value>AAddDate</Value>
</Value>
<Value name="7">
<Value>AAddTime</Value>
</Value>
<Value name="8">
<Value>AAddUser</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocPilotAuthD</DataLocation>
<DefaultData>DHCDocPilotAuthDefaultData</DefaultData>
<IdLocation>^User.DHCDocPilotAuthD</IdLocation>
<IndexLocation>^User.DHCDocPilotAuthI</IndexLocation>
<StreamLocation>^User.DHCDocPilotAuthS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
