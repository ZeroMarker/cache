Class epr.CTProfileParams Extends (%Library.Persistent, websys.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 161;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "PPDesc";

Parameter SQLDESCRIPTION = "PPDesc";

Parameter SQLROWID = "ID";

Property PPDesc As %Library.String(COLLATION = "ALPHAUP", MAXLEN = "", SELECTIVITY = "", TRUNCATE = 1) [ Required ];

Property PPParameters As %Library.String(MAXLEN = "", SELECTIVITY = 1.5, TRUNCATE = 1);

Property PPTypeDR As epr.CTChartItemType(SELECTIVITY = 1.5) [ Required ];

/// Uniqueness index for property PPDesc
Index UniquePPDescIndex On PPDesc [ Unique ];

/// by wuqk 2011-06-16
ClassMethod BrokerGetParams(itmjsex As %Library.String, id As %Library.String)
{
}

ClassMethod LookUpByTypeClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpByTypeFetch ]
{
}

ClassMethod LookUpByTypeExecute(ByRef QHandle As %Library.Binary, desc As %Library.String, PPType As %Library.String) As %Library.Status
{
}

ClassMethod LookUpByTypeFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpByTypeExecute ]
{
}

/// zhaocz 2011-06-16
ClassMethod LookUpParamsBroker(itmjs As %Library.String, itmjsex As %Library.String, PPDesc As %Library.String, PPType As %Library.String)
{
}

ClassMethod LookUpParamsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpParamsFetch ]
{
}

ClassMethod LookUpParamsExecute(ByRef QHandle As %Library.Binary, desc As %Library.String, PPType As %Library.String) As %Library.Status
{
}

ClassMethod LookUpParamsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpParamsExecute ]
{
}

/// KM: 21May2001: Called from epr.Chart.Edit component
Query LookUpByType(desc As %Library.String, PPType As %Library.String) As %Library.Query(CONTAINID = 2, ROWSPEC = "ProfileName:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

/// KM: 21May2001: Called from epr.Chart.Edit component
Query LookUpParams(desc As %Library.String, PPType As %Library.String) As %Library.Query(CONTAINID = 2, ROWSPEC = "ProfileName:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

/// ab 22.03.06 56897 - called from OEOrder.Edit.CytoProfile
/// by wuqk 2011-06-14 未实现
Query LookUpForListBox(type As %String, val As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Code:%String,Description:%String")
{
}

ClassMethod LookUpForListBoxClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpForListBoxFetch ]
{
}

ClassMethod LookUpForListBoxExecute(ByRef QHandle As %Library.Binary, type As %String = "", val As %String = "") As %Library.Status
{
}

ClassMethod LookUpForListBoxFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpForListBoxExecute ]
{
}

Storage Default
{
<Data name="CTProfileParamsClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="CTProfileParamsDefaultData">
<Value name="1">
<Value>PPDesc</Value>
</Value>
<Value name="2">
<Value>PPParameters</Value>
</Value>
<Value name="3">
<Value>deleted</Value>
</Value>
<Value name="4">
<Value>PPTypeDR</Value>
</Value>
<Value name="5">
<Value>PPGraphDefinitionDR</Value>
</Value>
</Data>
<DataLocation>^epr.CTProfileParamsD</DataLocation>
<DefaultData>CTProfileParamsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^epr.CTProfileParamsD</IdLocation>
<IndexLocation>^epr.CTProfileParamsI</IndexLocation>
<StreamLocation>^epr.CTProfileParamsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
