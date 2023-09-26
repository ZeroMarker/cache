Class epr.ChartItem Extends %Library.SerialObject [ Not Abstract, ClassType = serial, Not ProcedureBlock ]
{

Property AdHocGraphLink As %Boolean;

Property Collapse As %Library.Boolean;

Property DisplayAddButton As %Boolean [ InitialExpression = "0" ];

Property DisplayHeader As %Boolean;

Property GraphDR As epr.CTGraphDefinition;

/// Bit of overkill, this one.... 
/// GraphDR is a DR to a SINGLE graph value.
/// If there are no 'Graphs' items, we will assume a single Graph item is available.
/// Then I'll copy the single GraphDr into Graphs.GetAt(1), which we will use in the future...
/// 
Property Graphs As list Of epr.CTGraphDefinition;

Property Heading As list Of %Library.String(TRUNCATE = 1);

Property Item As %String(TRUNCATE = 1) [ Required ];

Property ItemType As %Library.String(TRUNCATE = 1) [ InitialExpression = "EP", Required ];

Property Rows As %Integer;

Property Sequence As %String(TRUNCATE = 1);

/// Log 39287 - AI - 02-10-2003 : New field Column Width - applies to Result columns and Order Item.
Property ColumnWidth As %Integer;

Property ConditionalExpression As %String(MAXLEN = 999, TRUNCATE = 1);

Property AcrossEpisodes As %Boolean [ InitialExpression = "0" ];

/// Log 55973 - PJC - 20-12-2005 : Add the "Only show entries marked for DS Report" checkbox.
Property OnlyMarkedForDSReport As %Boolean [ InitialExpression = "0" ];

Storage Default
{
<Data name="ChartItemState">
<Value name="1">
<Value>DisplayedRows</Value>
</Value>
<Value name="2">
<Value>Header</Value>
</Value>
<Value name="3">
<Value>Page</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
<Value name="5">
<Value>ShowAddButton</Value>
</Value>
<Value name="6">
<Value>PageType</Value>
</Value>
<Value name="7">
<Value>Item</Value>
</Value>
<Value name="8">
<Value>ItemType</Value>
</Value>
<Value name="9">
<Value>DisplayAddButton</Value>
</Value>
<Value name="10">
<Value>DisplayCaption</Value>
</Value>
<Value name="11">
<Value>DisplayHeader</Value>
</Value>
<Value name="12">
<Value>Rows</Value>
</Value>
<Value name="13">
<Value>GraphDR</Value>
</Value>
<Value name="14">
<Value>Heading</Value>
</Value>
<Value name="15">
<Value>Collapse</Value>
</Value>
<Value name="16">
<Value>Graphs</Value>
</Value>
<Value name="17">
<Value>ColumnWidth</Value>
</Value>
<Value name="18">
<Value>AdHocGraphLink</Value>
</Value>
<Value name="19">
<Value>ConditionalExpression</Value>
</Value>
<Value name="20">
<Value>AcrossEpisodes</Value>
</Value>
<Value name="21">
<Value>TabColour</Value>
</Value>
<Value name="22">
<Value>OnlyMarkedForDSReport</Value>
</Value>
</Data>
<State>ChartItemState</State>
<StreamLocation>^epr.ChartItemS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
