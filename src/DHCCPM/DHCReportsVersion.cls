Class DHCCPM.DHCReportsVersion Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, Owner = {_SYSTEM}, ProcedureBlock, SqlTableName = DHC_ReportsVersion ]
{

Relationship ParRef As DHCCPM.DHCReports [ Cardinality = parent, Inverse = ReportsVersion ];

Property RVAuthor As %String(MAXLEN = 100, TRUNCATE = 1) [ Required, SqlFieldName = RV_Author ];

Property RVCreateDate As %Date [ SqlFieldName = RV_CreateDate ];

Property RVCreateTime As %Time [ SqlFieldName = RV_CreateTime ];

Property RVData As %GlobalCharacterStream [ SqlFieldName = RV_Data ];

Property RVPublicationDate As %Date [ SqlFieldName = RV_PublicationDate ];

Property RVPublicationTime As %Time [ SqlFieldName = RV_PublicationTime ];

Property RVXMLSchemaFile As %GlobalCharacterStream [ SqlFieldName = RV_XMLSchemaFile ];

Property RVStatus As %Integer [ SqlFieldName = RV_Status ];

Property RVVersionNumber As %Integer [ Required, SqlFieldName = RV_VersionNumber ];

/// 获取报表版本的记录集
Query GetRepVerList() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,RV_Author,RV_CreateDate,RV_CreateTime,RV_PublicationDate,RV_PublicationTime,RV_Status,RV_VersionNumber,ParRef FROM DHC_ReportsVersion
 ORDER BY ParRef, %ID
}

/// 根据报表获取不同的版本号码
Query GetVerByRep(RepRowID As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,RV_Author,RV_CreateDate,RV_CreateTime,RV_PublicationDate,RV_PublicationTime,RV_Status,RV_VersionNumber FROM DHC_ReportsVersion
 WHERE (ParRef = :RepRowID)
}

Storage Default
{
<Data name="DHCReportsVersionClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCReportsVersionDefaultData">
<Value name="1">
<Value>RVAuthor</Value>
</Value>
<Value name="2">
<Value>RVCreateDate</Value>
</Value>
<Value name="3">
<Value>RVCreateTime</Value>
</Value>
<Value name="4">
<Value>RVData</Value>
</Value>
<Value name="5">
<Value>RVStatus</Value>
</Value>
<Value name="6">
<Value>RVVersionNumber</Value>
</Value>
<Value name="7">
<Value>RVXMLSchemaFile</Value>
</Value>
<Value name="8">
<Value>RVPublicationDate</Value>
</Value>
<Value name="9">
<Value>RVPublicationTime</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ReportsVersion")</DataLocation>
<DefaultData>DHCReportsVersionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ReportsVersion")</IdLocation>
<IndexLocation>^DHCCPM.DHCReportsVersionI</IndexLocation>
<StreamLocation>^DHCCPM.DHCReportsVersionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
