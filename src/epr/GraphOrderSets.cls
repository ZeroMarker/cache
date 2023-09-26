Class epr.GraphOrderSets Extends (%Library.Persistent, websys.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 90;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "OGPHCode";

Parameter SQLDESCRIPTION = "OGPHDesc";

Parameter SQLROWID = "ID";

Property OGPHCode As %Library.String(COLLATION = "ALPHAUP", TRUNCATE = 1) [ Required ];

Property OGPHDesc As %Library.String(TRUNCATE = 1);

Property OGPHItemList As %Library.String(MAXLEN = 99999, TRUNCATE = 1);

Property OGPHOrderItemCount As %Library.Integer;

Index UniqueOGPHCodeIndex On OGPHCode [ Unique ];

/// Used in epr.emrgraph.asp
ClassMethod DateLogicalToYMD(dt As %Library.String) As %Library.String
{
}

/// Uniqueness index for property OGPHCode
ClassMethod GetOrderItemsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = GetOrderItemsFetch ]
{
}

ClassMethod GetOrderItemsExecute(ByRef QHandle As %Library.Binary, ID As %Library.String) As %Library.Status
{
}

ClassMethod GetOrderItemsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = GetOrderItemsExecute ]
{
}

ClassMethod GetChartFXServer() As %Library.String
{
}

ClassMethod websysSaveAll(id As %Library.String)
{
}

Query GetOrderItemCount(Code As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "OGPHOrderItemCount:%Library.Integer")
{
SELECT OGPHOrderItemCount
FROM epr.GraphOrderSets
WHERE (OGPHCode = :Code) OR (OGPHDesc = :Code)
}

/// SA: Implemented for Chart FX test
/// Used by component epr.GraphOrderSets.Edit to fill field "LabItemsList"
/// and by epr.EMRGraph.asp to retrieve the codes required to fill the graph data
/// Functionality -  to get the saved items for the table 
/// property OGPHItemList list
Query GetOrderItems(ID As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "Code:%String,Description:%String")
{
}

Storage Default
{
<Data name="GraphOrderSetsClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="GraphOrderSetsDefaultData">
<Value name="1">
<Value>OGPHCode</Value>
</Value>
<Value name="2">
<Value>OGPHDesc</Value>
</Value>
<Value name="3">
<Value>OGPHItemList</Value>
</Value>
<Value name="4">
<Value>OGPHOrderItemCount</Value>
</Value>
</Data>
<DataLocation>^epr.GraphOrderSetsD</DataLocation>
<DefaultData>GraphOrderSetsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^epr.GraphOrderSetsD</IdLocation>
<IndexLocation>^epr.GraphOrderSetsI</IndexLocation>
<StreamLocation>^epr.GraphOrderSetsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
