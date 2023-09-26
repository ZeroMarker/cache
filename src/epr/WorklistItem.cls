Class epr.WorklistItem Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

Property DisplayHeader As %Library.Boolean;

Property Frame As %Library.String(DISPLAYLIST = ",Left,Right,Top,Bottom", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",L,R,T,B") [ InitialExpression = "L", Required ];

Property HideMenus As %Library.Boolean;

Property Item As epr.CTWorklistItemDef [ Required ];

Property ItemParams As epr.WorklistItemParams;

Property LinkOnly As %Library.Boolean;

Property Rows As %Library.Integer;

Property Sequence As %Library.String(TRUNCATE = 1);

Property LinkNewWindow As %Library.Boolean;

Storage Default
{
<Data name="WorklistItemState">
<Value name="1">
<Value>DisplayHeader</Value>
</Value>
<Value name="2">
<Value>Frame</Value>
</Value>
<Value name="3">
<Value>Item</Value>
</Value>
<Value name="4">
<Value>Rows</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>HideMenus</Value>
</Value>
<Value name="7">
<Value>LinkOnly</Value>
</Value>
<Value name="8">
<Value>ItemParams</Value>
</Value>
<Value name="9">
<Value>LinkNewWindow</Value>
</Value>
</Data>
<DataLocation>^epr.WorklistItemD</DataLocation>
<IdLocation>^epr.WorklistItemD</IdLocation>
<IndexLocation>^epr.WorklistItemI</IndexLocation>
<State>WorklistItemState</State>
<StreamLocation>^epr.WorklistItemS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
