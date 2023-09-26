Class User.DHCICUDigitalSignLog Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ICUDSL_RowId, SqlTableName = DHC_ICU_DigitalSignLog, StorageStrategy = CacheStorage ]
{

Index ICUADocCode On (ICUDSLICUADr As Exact, ICUDSLDocumentCode As Exact);

Index DateICUA On (ICUDSLStartDate, ICUDSLICUADr);

Property ICUDSLSignDr As %String [ SqlColumnNumber = 2, SqlFieldName = ICUDSL_Sign_Dr ];

Property ICUDSLUserDr As %String [ SqlColumnNumber = 3, SqlFieldName = ICUDSL_User_Dr ];

Property ICUDSLADMDr As %String [ SqlColumnNumber = 4, SqlFieldName = ICUDSL_ADM_Dr ];

Property ICUDSLICUADr As %String [ SqlColumnNumber = 5, SqlFieldName = ICUDSL_ICUA_Dr ];

Property ICUDSLDocumentCode As %String [ SqlColumnNumber = 6, SqlFieldName = ICUDSL_DocumentCode ];

Property ICUDSLContentHash As %String(MAXLEN = 999999, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = ICUDSL_ContentHash ];

Property ICUDSLIsValid As %Boolean [ SqlColumnNumber = 8, SqlFieldName = ICUDSL_IsValid ];

Property ICUDSLStartDate As %Date [ SqlColumnNumber = 9, SqlFieldName = ICUDSL_StartDate ];

Property ICUDSLStartTime As %Time [ SqlColumnNumber = 10, SqlFieldName = ICUDSL_StartTime ];

Property ICUDSLEndDate As %Date [ SqlColumnNumber = 11, SqlFieldName = ICUDSL_EndDate ];

Property ICUDSLEndTime As %Time [ SqlColumnNumber = 12, SqlFieldName = ICUDSL_EndTime ];

Property ICUDSLType As %String [ SqlColumnNumber = 13, SqlFieldName = ICUDSL_Type ];

Property ICUDSLCreateDate As %Date [ SqlColumnNumber = 14, SqlFieldName = ICUDSL_CreateDate ];

Property ICUDSLCreateTime As %Time [ SqlColumnNumber = 15, SqlFieldName = ICUDSL_CreateTime ];

Storage CacheStorage
{
<Data name="DHCICUDigitalSignLogClass">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCICUDigitalSignLogData">
<Value name="1">
<Value>ICUDSLSignDr</Value>
</Value>
<Value name="2">
<Value>ICUDSLUserDr</Value>
</Value>
<Value name="3">
<Value>ICUDSLADMDr</Value>
</Value>
<Value name="4">
<Value>ICUDSLICUADr</Value>
</Value>
<Value name="5">
<Value>ICUDSLDocumentCode</Value>
</Value>
<Value name="6">
<Value>ICUDSLContentHash</Value>
</Value>
<Value name="7">
<Value>ICUDSLIsValid</Value>
</Value>
<Value name="8">
<Value>ICUDSLStartDate</Value>
</Value>
<Value name="9">
<Value>ICUDSLStartTime</Value>
</Value>
<Value name="10">
<Value>ICUDSLEndDate</Value>
</Value>
<Value name="11">
<Value>ICUDSLEndTime</Value>
</Value>
<Value name="12">
<Value>ICUDSLType</Value>
</Value>
<Value name="13">
<Value>ICUDSLCreateDate</Value>
</Value>
<Value name="14">
<Value>ICUDSLCreateTime</Value>
</Value>
</Data>
<DataLocation>^DHCICUDigitalSignLog</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCICUDigitalSignLog</IdLocation>
<IndexLocation>^DHCICUDigitalSignLog(0)</IndexLocation>
<StreamLocation>^User.DHCICUDigitalSignLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
