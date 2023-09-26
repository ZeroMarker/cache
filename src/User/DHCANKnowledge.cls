/// DHC_AN_Knowledge
Class User.DHCANKnowledge Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ANK_RowId, SqlTableName = DHC_AN_Knowledge, StorageStrategy = CacheStorage ]
{

Parameter EXTENTSIZE = 250;

/// ANK_Code
Property ANKCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ANK_Code ];

/// ANK_Desc
Property ANKDesc As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ANK_Desc ];

/// ANK_ANCKSC_Dr
Property ANKANCKSCDr As User.DHCANCKnowledgeSubCat [ SqlColumnNumber = 4, SqlFieldName = ANK_ANCKSC_Dr ];

/// ANK_KeyWord
Property ANKKeyWord As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = ANK_KeyWord ];

/// ANK_KeyWordAlias
Property ANKKeyWordAlias As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ANK_KeyWordAlias ];

/// ANK_Data
Property ANKData As %GlobalCharacterStream(LOCATION = "^DHCANKnowledgeS") [ SqlColumnNumber = 7, SqlFieldName = ANK_Data ];

/// ANK_Status
Property ANKStatus As %Library.String(DISPLAYLIST = ",Normal,Super,Cancel", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",N,S,C") [ SqlColumnNumber = 8, SqlFieldName = ANK_Status ];

/// ANK_Source_Dr
Property ANKSourceDr As User.DHCANCKnowledgeSource [ SqlColumnNumber = 9, SqlFieldName = ANK_Source_Dr ];

/// ANK_Date
Property ANKDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = ANK_Date ];

/// ANK_UpdateUser_Dr
Property ANKUpdateUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = ANK_UpdateUser_Dr ];

/// ANK_UpdateDate
Property ANKUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = ANK_UpdateDate ];

/// ANK_UpdateTime
Property ANKUpdateTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = ANK_UpdateTime ];

Storage CacheStorage
{
<Data name="DefaultData">
<Attribute>ANKCode</Attribute>
<Value name="1">
<Value>ANKCode</Value>
</Value>
<Value name="2">
<Value>ANKDesc</Value>
</Value>
<Value name="3">
<Value>ANKANCKSCDr</Value>
</Value>
<Value name="4">
<Value>ANKKeyWord</Value>
</Value>
<Value name="5">
<Value>ANKKeyWordAlias</Value>
</Value>
<Value name="6">
<Value>ANKData</Value>
</Value>
<Value name="7">
<Value>ANKStatus</Value>
</Value>
<Value name="8">
<Value>ANKSourceDr</Value>
</Value>
<Value name="9">
<Value>ANKDate</Value>
</Value>
<Value name="10">
<Value>ANKUpdateUserDr</Value>
</Value>
<Value name="11">
<Value>ANKUpdateDate</Value>
</Value>
<Value name="12">
<Value>ANKUpdateTime</Value>
</Value>
<Value name="13">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCANKnowledgeD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^DHCANKnowledgeD</IdLocation>
<IndexLocation>^DHCANKnowledgeI</IndexLocation>
<StreamLocation>^DHCANKnowledgeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
