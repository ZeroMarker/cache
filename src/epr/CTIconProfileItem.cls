Class epr.CTIconProfileItem Extends %Library.Persistent [ ClassType = persistent, CompileAfter = epr.CTIconProfile, Not ProcedureBlock ]
{

Property IconDR As epr.CTIconAssociation;

Property LinkComponent As %Library.String(TRUNCATE = 1);

Property LinkExpression As websys.Expression;

Property LinkItemDR As websys.WorkFlowItemDefinition;

Property LinkUrl As %Library.String(TRUNCATE = 1);

Relationship ParRef As epr.CTIconProfile [ Cardinality = parent, Inverse = Items ];

Property Sequence As %Library.String(TRUNCATE = 1);

Property LinkChartBookDR As epr.ChartBook;

Property Active As %Boolean [ InitialExpression = 1 ];

/// Created for Log 26756
Method Get(EpisodeID As %Library.String = "", PARAMS As %Library.String, ByRef ARY As %Library.String, ByRef imgLIST As %Library.String)
{
}

/// Created for Log 26756
/// by wuqk 2011-06-30
ClassMethod InsertItem(compref As %Library.String, ProfileID As %Library.String = "", Icon As %Library.String = "")
{
}

/// Created for Log 26756
/// by wuqk 2011-05-27
ClassMethod websysDelete(ID As %Library.String)
{
}

Query Find() As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID, IconDR, LinkItemDR")
{
SELECT ID, IconDR, LinkItemDR
FROM epr.CTIconProfileItem
}

Storage Default
{
<Data name="CTIconProfileItemClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="CTIconProfileItemDefaultData">
<Value name="1">
<Value>Icon</Value>
</Value>
<Value name="2">
<Value>LinkItem</Value>
</Value>
<Value name="3">
<Value>IconDR</Value>
</Value>
<Value name="4">
<Value>LinkItemDR</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>LinkComponent</Value>
</Value>
<Value name="7">
<Value>LinkExpression</Value>
</Value>
<Value name="8">
<Value>LinkUrl</Value>
</Value>
<Value name="9">
<Value>LinkNewWindow</Value>
</Value>
<Value name="10">
<Value>LinkChartBookDR</Value>
</Value>
<Value name="11">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Items")</DataLocation>
<DefaultData>CTIconProfileItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("Items")</IdLocation>
<IndexLocation>^epr.CTIconProfileItemI</IndexLocation>
<StreamLocation>^epr.CTIconProfileItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
