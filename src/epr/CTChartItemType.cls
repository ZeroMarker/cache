Class epr.CTChartItemType Extends (%Library.Persistent, websys.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, StorageStrategy = default ]
{

Parameter BUILD = 109;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property CITClass As %Library.String(TRUNCATE = 1);

Property CITCode As %Library.String(COLLATION = "ALPHAUP", TRUNCATE = 1) [ Required ];

Property CITDesc As %Library.String(TRUNCATE = 1);

Property CITEditEPRComponentDR As websys.Component;

Property CITListEPRComponentDR As websys.Component;

Property CITListProfileComponentDR As websys.Component;

Property CITURL As %Library.String(TRUNCATE = 1);

/// Uniqueness index for property CITCode
Index UniqueCITCodeIndex On CITCode [ Unique ];

/// by wuqk 2011-06-01
Method CITURLSet(val As %Library.String) As %Library.Status
{
}

Parameter SQLCODE = "CITCode";

Parameter SQLDESCRIPTION = "CITDesc";

Parameter SQLROWID = "ID";

/// KM 26-Apr-2001: Called From epr.Chart.websysSave
Query Find() As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,CITCode:%Library.String,CITDesc:%Library.String,CITClass:%Library.String")
{
SELECT ID, CITCode, CITDesc, CITClass
FROM CTChartItemType
}

/// KM 2Apr2001: Used by epr.Chart.chartSettingsSelect
Query FindByCode(Code As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,CITCode,CITDesc,CITListProfileComponentDR,CITListEPRComponentDR,CITEditEPRComponentDR,CITClass")
{
SELECT ID, CITCode, CITDesc, CITListProfileComponentDR, CITListEPRComponentDR->Name,CITEditEPRComponentDR->Name, CITClass
FROM epr.CTChartItemType
WHERE CITCode=:Code
}

Storage default
{
<Data name="CTChartItemTypeClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="CTChartItemTypeDefaultData">
<Value name="1">
<Value>CITCode</Value>
</Value>
<Value name="2">
<Value>CITParametersCode</Value>
</Value>
<Value name="3">
<Value>CITDesc</Value>
</Value>
<Value name="4">
<Value>CITClass</Value>
</Value>
<Value name="5"/>
<Value name="6"/>
<Value name="7"/>
<Value name="8"/>
<Value name="9"/>
<Value name="10">
<Value>CITListProfileComponentDR</Value>
</Value>
<Value name="11"/>
<Value name="12">
<Value>CITURL</Value>
</Value>
<Value name="13"/>
<Value name="14">
<Value>CITblah</Value>
</Value>
<Value name="15">
<Value>CITEditEPRComponentDR</Value>
</Value>
<Value name="16">
<Value>CITListEPRComponentDR</Value>
</Value>
</Data>
<DataLocation>^epr.CTChartItemTypeD</DataLocation>
<DefaultData>CTChartItemTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^epr.CTChartItemTypeD</IdLocation>
<IndexLocation>^epr.CTChartItemTypeI</IndexLocation>
<StreamLocation>^epr.CTChartItemTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
