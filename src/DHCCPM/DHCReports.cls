Class DHCCPM.DHCReports Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, CompileAfter = DHCCPM.DHCReportsCategory, Inheritance = right, Owner = {_SYSTEM}, ProcedureBlock, SqlTableName = DHC_Reports ]
{

/// 对应的组件名称
Property ComponentName As %String(TRUNCATE = 1) [ SqlFieldName = ComponentName ];

Property ComponentDR As %String(TRUNCATE = 1) [ SqlFieldName = RPComponentDR ];

Property DateFrom As %Date [ SqlFieldName = DateFrom ];

Property PublishVersion As %Integer [ Required, SqlFieldName = PublishVersion ];

Property DateTo As %Date;

Property RepCaption As %String(MAXLEN = 500, TRUNCATE = 1) [ Required, SqlFieldName = RepCaption ];

Property LastVersion As %Integer [ Required, SqlFieldName = LastVersion ];

Relationship RepCategoryDR As DHCCPM.DHCReportsCategory [ Cardinality = one, Inverse = Reports ];

/// 描述
Property RepDescription As %String(MAXLEN = "", TRUNCATE = 1) [ SqlFieldName = RepDescription ];

Relationship RepPanels As DHCCPM.DHCRepPanels [ Cardinality = children, Inverse = ParRef ];

Property RepName As %String(TRUNCATE = 1) [ InitialExpression = {"Report"_$I(^DHCCPM.Unique)}, Required, SqlFieldName = RepName ];

Relationship ReportsVersion As DHCCPM.DHCReportsVersion [ Cardinality = children, Inverse = ParRef ];

/// 统一的DataSet关系模板流
Property XMLSchemaFile As %GlobalCharacterStream [ SqlFieldName = XMLSchemaFile ];

Index ComponentDRIndex On ComponentDR As Exact;

/// 报表名称的索引
Index RNameIdx On RepName As Exact;

Index RepCategoryDRIndex On RepCategoryDR As Exact;

Index RepNameIndex On RepName [ Unique ];

/// 根据报表目录获取报表信息
Query GetRepsByCatDR(RepCatDR As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,DateFrom,DateTo,LastVersion,PublishVersion,RepCaption,RepName,RPComponentDR,Count(*) As RepCount, RepDescription FROM DHC_Reports
 WHERE (RepCategoryDR = :RepCatDR)
 ORDER BY %ID
}

Query GetRepsList() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,DateFrom,DateTo,LastVersion,PublishVersion,RepCaption,RepName,RPComponentDR,RepCategoryDR->ID as RepCategoryDR,Count(*) As RepCount, RepDescription FROM DHC_Reports
 ORDER BY RepCategoryDR, %ID
}

Query GetList() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,DateFrom,DateTo,LastVersion,PublishVersion,RepCaption FROM DHC_Reports
}

Storage Default
{
<Data name="DHCReportsClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCReportsDefaultData">
<Value name="1">
<Value>XMLSchemaFile</Value>
</Value>
<Value name="2">
<Value>ReportsGroupDR</Value>
</Value>
<Value name="3">
<Value>ComponentDR</Value>
</Value>
<Value name="4">
<Value>RepCaption</Value>
</Value>
<Value name="5">
<Value>RepName</Value>
</Value>
<Value name="6">
<Value>RepCategoryDR</Value>
</Value>
<Value name="7">
<Value>PublishVersion</Value>
</Value>
<Value name="8">
<Value>DateFrom</Value>
</Value>
<Value name="9">
<Value>DateTo</Value>
</Value>
<Value name="10">
<Value>LastVersion</Value>
</Value>
<Value name="11">
<Value>RepDescription</Value>
</Value>
<Value name="12">
<Value>ComponentName</Value>
</Value>
</Data>
<DataLocation>^DHCCPM.DHCReportsD</DataLocation>
<DefaultData>DHCReportsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCPM.DHCReportsD</IdLocation>
<IndexLocation>^DHCCPM.DHCReportsI</IndexLocation>
<StreamLocation>^DHCCPM.DHCReportsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
