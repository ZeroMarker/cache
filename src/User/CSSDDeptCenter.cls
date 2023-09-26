/// 消毒供应科室定义
Class User.CSSDDeptCenter Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_DeptCenter ]
{

/// 消毒供应室
Property CSSDDLoc As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = CSSDD_Loc_DR ];

Property CSSDDHospDR As User.CTHospital [ SqlColumnNumber = 3, SqlFieldName = CSSDD_Hosp_DR ];

Index CSSDDLocIndex On CSSDDLoc As Exact;

Index HospDept On (CSSDDHospDR As Exact, CSSDDLoc As Exact);

Storage Default
{
<Data name="CSSDDeptCenterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDDLoc</Value>
</Value>
<Value name="3">
<Value>CSSDDHospDR</Value>
</Value>
</Data>
<DataLocation>^User.CSSDDeptCenterD</DataLocation>
<DefaultData>CSSDDeptCenterDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.CSSDDeptCenterD</IdLocation>
<IndexLocation>^User.CSSDDeptCenterI</IndexLocation>
<StreamLocation>^User.CSSDDeptCenterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
