Class User.DHCDocLabPlanOrdLimit Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHCDocLabPlanOrdLimit, StorageStrategy = NewStorage1 ]
{

Index LimitLabPlanDr On LimitLabPlanDr;

Index LimitArcimDr On LimitArcimDr;

Index LimitPlanArcimDr On (LimitLabPlanDr, LimitArcimDr);

Property LimitLabPlanDr As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

Property LimitArcimDr As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

Storage NewStorage1
{
<Data name="DHCDocLabPlanOrdLimitDefaultData">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="Node1">
<Value name="1">
<Value>LimitLabPlanDr</Value>
</Value>
<Value name="2">
<Value>LimitArcimDr</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocLabPlanOrdLimitD</DataLocation>
<DefaultData>DHCDocLabPlanOrdLimitDefaultData</DefaultData>
<IdLocation>^User.DHCDocLabPlanOrdLimitD</IdLocation>
<IndexLocation>^User.DHCDocLabPlanOrdLimitI</IndexLocation>
<StreamLocation>^User.DHCDocLabPlanOrdLimitS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
