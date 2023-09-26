Class User.DHCDocLabPlanBloodFlag Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHCDocLabPlanBloodFlag, StorageStrategy = NewStorage1 ]
{

Index LabPlanDr On (LabPlanDr, LabPlanTypeCode);

/// 绑定方案ID
Property LabPlanDr As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 容器/标本Code
Property LabPlanTypeCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 容器/标本取血类型 1 统一采血
Property LabPlanBloodFlag As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

Storage NewStorage1
{
<Data name="DHCDocLabPlanBloodFlagDefaultData">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="Node1">
<Value name="1">
<Value>LabPlanDr</Value>
</Value>
<Value name="2">
<Value>LabPlanTypeCode</Value>
</Value>
<Value name="3">
<Value>LabPlanBloodFlag</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocLabPlanBloodFlagD</DataLocation>
<DefaultData>DHCDocLabPlanBloodFlagDefaultData</DefaultData>
<IdLocation>^User.DHCDocLabPlanBloodFlagD</IdLocation>
<IndexLocation>^User.DHCDocLabPlanBloodFlagI</IndexLocation>
<StreamLocation>^User.DHCDocLabPlanBloodFlagS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
