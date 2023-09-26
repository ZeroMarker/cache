Class User.DHCDocLabPlan Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHCDocLabPlan, StorageStrategy = NewStorage1 ]
{

Index LabPlanHospDr On LabPlanHospDr;

Property LabPlanName As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

Property LabPlanHospDr As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

Property LabPlanLimitLocStr As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

Property LabPlanLimitAdmType As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

Property LabPlanLimitAgeFrom As %String(TRUNCATE = 1) [ SqlColumnNumber = 6 ];

Property LabPlanLimitAgeTo As %String(TRUNCATE = 1) [ SqlColumnNumber = 7 ];

Property LabPlanLimitSexStr As %String(TRUNCATE = 1) [ SqlColumnNumber = 8 ];

/// 方案算法
Property LabPlanAlgorithms As %String(TRUNCATE = 1) [ SqlColumnNumber = 9 ];

/// 合并方案
Property LabPlanMergeLabPlan As %String(TRUNCATE = 1) [ SqlColumnNumber = 10 ];

Storage NewStorage1
{
<Data name="Node1">
<Value name="1">
<Value>LabPlanName</Value>
</Value>
<Value name="2">
<Value>LabPlanHospDr</Value>
</Value>
<Value name="3">
<Value>LabPlanLimitLocStr</Value>
</Value>
<Value name="4">
<Value>LabPlanLimitAdmType</Value>
</Value>
<Value name="5">
<Value>LabPlanLimitAgeFrom</Value>
</Value>
<Value name="6">
<Value>LabPlanLimitAgeTo</Value>
</Value>
<Value name="7">
<Value>LabPlanLimitSexStr</Value>
</Value>
<Value name="8">
<Value>LabPlanAlgorithms</Value>
</Value>
<Value name="9">
<Value>LabPlanMergeLabPlan</Value>
</Value>
<Value name="10">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocLabPlanD</DataLocation>
<DefaultData>Node1</DefaultData>
<IdLocation>^User.DHCDocLabPlanD</IdLocation>
<IndexLocation>^User.DHCDocLabPlanI</IndexLocation>
<StreamLocation>^User.DHCDocLabPlanS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
