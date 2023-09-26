/// CTOR: QP
/// DATE: 2022-03-11
/// DESC: 药物临床试验项目药品
Class User.DHCDocPilotProDrug Extends (%Persistent, User.Abstract)
{

/// 项目ID
Property DProjectID As User.DHCDocPilotProject [ SqlColumnNumber = 2, SqlFieldName = D_ProjectID ];

/// 医嘱项
Property DArcimDR As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = D_ArcimDR ];

/// 添加日期
Property DAddDate As %Date [ SqlColumnNumber = 4, SqlFieldName = D_AddDate ];

/// 添加日期
Property DAddTime As %Time [ SqlColumnNumber = 5, SqlFieldName = D_AddTime ];

/// 添加用户
Property DAddUser As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = D_AddUser ];

Index Project On DProjectID As Exact;

Index ProjectArcim On (DProjectID As Exact, DArcimDR As Exact);

Storage Default
{
<Data name="DHCDocPilotProDrugDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DProjectID</Value>
</Value>
<Value name="3">
<Value>DArcimDR</Value>
</Value>
<Value name="4">
<Value>DAddDate</Value>
</Value>
<Value name="5">
<Value>DAddTime</Value>
</Value>
<Value name="6">
<Value>DAddUser</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocPilotProDrugD</DataLocation>
<DefaultData>DHCDocPilotProDrugDefaultData</DefaultData>
<IdLocation>^User.DHCDocPilotProDrugD</IdLocation>
<IndexLocation>^User.DHCDocPilotProDrugI</IndexLocation>
<StreamLocation>^User.DHCDocPilotProDrugS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
