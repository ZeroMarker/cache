/// graphing item definition, containing order items, observations and test set codes
Class epr.CTGraphItemDefinition Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

Property CTGIColour As %Library.String(TRUNCATE = 1);

/// this is NOT strictly a DR we can use.
/// It is simply the value of the lab.CTTestCode as a string.
Property CTGILabItemDR As %Library.String(TRUNCATE = 1);

Property CTGILegendSequence As %Library.String(TRUNCATE = 1);

Property CTGILowerRange As %Library.String(TRUNCATE = 1);

Property CTGIMarker As %Library.String(TRUNCATE = 1);

Property CTGINormalLineType As %Library.String(TRUNCATE = 1);

Property CTGIObsItemDR As User.MRCObservationItem;

Property CTGIOrderItemDR As User.ARCItmMast;

Property CTGIRefLineColour As %Library.String(TRUNCATE = 1);

Property CTGIUpperRange As %Library.String(TRUNCATE = 1);

Property CTGIVariableLineType As %Library.String(TRUNCATE = 1);

Property CTGIYAxis As %Library.String(TRUNCATE = 1);

Property CTGItemType As %Library.String(DISPLAYLIST = ",Order Item,Lab Item,Observation Item,", TRUNCATE = 1, VALUELIST = ",OR,LB,OB,") [ Required ];

Property CTGILinkedOrderItemDR As User.ARCItmMast;

Property CTGILinkedLabItemDR As %Library.String(TRUNCATE = 1);

Property CTGILinkedObsItemDR As User.MRCObservationItem;

Property CTGINonLinearRefRanges As list Of epr.CTGraphRefRange;

Property CTGIMarkerSize As %Library.String(TRUNCATE = 1);

/// Observation item only
Property CTGIObsOnly As %Library.String(TRUNCATE = 1);

ClassMethod GetGraphItemDetails(GraphID As %Library.String = "", GraphItemID As %Library.String = "")
{
}

/// KM Feb-2001 
ClassMethod GraphItemDelete(GraphID As %String, itemIdx As %String)
{
}

ClassMethod LookUpBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod websysSave(GraphItemID As %Library.String = "")
{
}

ClassMethod LookUpForListBoxClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpForListBoxFetch ]
{
}

ClassMethod LookUpForListBoxExecute(ByRef QHandle As %Library.Binary, graphID As %String = "", graphItemID As %String = "") As %Library.Status
{
}

ClassMethod LookUpForListBoxFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpForListBoxExecute ]
{
}

Query LookUpForListBox(graphID As %String = "", graphItemID As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Code:%String,Description:%String")
{
}

ClassMethod zLookUpLabItemClose(QHandle As %Library.Binary) As %Library.Status
{
}

ClassMethod zLookUpLabItemExecute(ByRef QHandle As %Library.Binary, labdesc As %Library.String = "") As %Library.Status
{
}

ClassMethod zLookUpLabItemFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0)
{
}

Storage Default
{
<Data name="CTGraphItemDefinitionState">
<Value name="1">
<Value>CTGItemType</Value>
</Value>
<Value name="2">
<Value>CTGIColour</Value>
</Value>
<Value name="3">
<Value>CTGILabItemDR</Value>
</Value>
<Value name="4">
<Value>CTGILegendSequence</Value>
</Value>
<Value name="5">
<Value>CTGILowerRange</Value>
</Value>
<Value name="6">
<Value>CTGIMarker</Value>
</Value>
<Value name="7">
<Value>CTGINormalLineType</Value>
</Value>
<Value name="8">
<Value>CTGIObsItemDR</Value>
</Value>
<Value name="9">
<Value>CTGIOrderItemDR</Value>
</Value>
<Value name="10">
<Value>CTGIUpperRange</Value>
</Value>
<Value name="11">
<Value>CTGIVariableLineType</Value>
</Value>
<Value name="12">
<Value>CTGIYAxis</Value>
</Value>
<Value name="13">
<Value>CTGIRefLineColour</Value>
</Value>
<Value name="14">
<Value>CTGIGroupType</Value>
</Value>
<Value name="15">
<Value>CTGILinkedLabItemDR</Value>
</Value>
<Value name="16">
<Value>CTGILinkedObsItemDR</Value>
</Value>
<Value name="17">
<Value>CTGILinkedOrderItemDR</Value>
</Value>
<Value name="18">
<Value>CTGIMarkerSize</Value>
</Value>
<Value name="19">
<Value>CTGINonLinearLowerRange</Value>
</Value>
<Value name="20">
<Value>CTGINonLinearUpperRange</Value>
</Value>
<Value name="21">
<Value>CTGINonLinearRefRanges</Value>
</Value>
<Value name="22">
<Value>CTGIObsOnly</Value>
</Value>
</Data>
<State>CTGraphItemDefinitionState</State>
<StreamLocation>^epr.CTGraphItemDefinitionS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
