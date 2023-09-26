Class epr.OrderCycle Extends (%Library.Persistent, websys.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 589;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ID";

Parameter SQLDESCRIPTION = "ID";

Parameter SQLROWID = "ID";

/// ab 19.04.06 56897
/// called from custom item on OEOrdItem.ListCytoEMR
ClassMethod DisplayCytoProfile()
{
}

Storage Default
{
<Data name="OrderCycleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^epr.OrderCycleD</DataLocation>
<DefaultData>OrderCycleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^epr.OrderCycleD</IdLocation>
<IndexLocation>^epr.OrderCycleI</IndexLocation>
<StreamLocation>^epr.OrderCycleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
