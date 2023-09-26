Class DHCCPM.DHCReportsCategory Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlTableName = DHC_ReportsCategory ]
{

Relationship Reports As DHCCPM.DHCReports [ Cardinality = many, Inverse = RepCategoryDR ];

Property RCCaption As %String(TRUNCATE = 1) [ Required, SqlFieldName = RC_Caption ];

Property RCName As %String(TRUNCATE = 1) [ Required, SqlFieldName = RC_Name ];

Property RCategoryDR As DHCReportsCategory [ SqlFieldName = RC_CategoryDR ];

Index RCNameIndex On RCName [ Unique ];

Index RCatDRIdx On RCategoryDR As Exact;

Query GetRepCatList() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID, RC_Caption,RC_Name,RC_CategoryDR
FROM DHC_ReportsCategory
 ORDER BY RC_CategoryDR, %ID
}

Storage Default
{
<Data name="DHCReportsCategoryClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCReportsCategoryDefaultData">
<Value name="1">
<Value>RCName</Value>
</Value>
<Value name="2">
<Value>RCCaption</Value>
</Value>
<Value name="3">
<Value>RCategoryDR</Value>
</Value>
</Data>
<DataLocation>^DHCCPM.DHCReportsCategoryD</DataLocation>
<DefaultData>DHCReportsCategoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCPM.DHCReportsCategoryD</IdLocation>
<IndexLocation>^DHCCPM.DHCReportsCategoryI</IndexLocation>
<StreamLocation>^DHCCPM.DHCReportsCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
