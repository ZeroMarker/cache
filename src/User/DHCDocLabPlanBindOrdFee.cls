Class User.DHCDocLabPlanBindOrdFee Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHCDocLabPlanBindOrdFee, StorageStrategy = NewStorage1 ]
{

Index LabPlanDr On LabPlanDr;

Index LabPlanBindArcimDr On (LabPlanDr, LabPlanBindArcimDr);

Index LabPlanBindOrdFeeType On (LabPlanDr, LabPlanBindType);

Property LabPlanDr As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

Property LabPlanBindArcimDr As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

Property LabPlanBindQty As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// Unit 统一采血费 Specimen 标本绑定 Container 容器绑定
Property LabPlanBindType As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// 是否重复加收 Y 是 其他不是
Property LabPlanBindIsRepeat As %String(TRUNCATE = 1) [ SqlColumnNumber = 6 ];

Storage NewStorage1
{
<Data name="DHCDocLabPlanBindOrdFeeDefaultData">
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
<Value>LabPlanBindArcimDr</Value>
</Value>
<Value name="3">
<Value>LabPlanBindQty</Value>
</Value>
<Value name="4">
<Value>LabPlanBindType</Value>
</Value>
<Value name="5">
<Value>LabPlanBindIsRepeat</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocLabPlanBindOrdFeeD</DataLocation>
<DefaultData>DHCDocLabPlanBindOrdFeeDefaultData</DefaultData>
<IdLocation>^User.DHCDocLabPlanBindOrdFeeD</IdLocation>
<IndexLocation>^User.DHCDocLabPlanBindOrdFeeI</IndexLocation>
<StreamLocation>^User.DHCDocLabPlanBindOrdFeeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
