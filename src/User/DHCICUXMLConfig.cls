Class User.DHCICUXMLConfig Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHC_ICU_XMLConfig ]
{

Property ICUXCCtcpType As %String(DISPLAYLIST = ",DOCTOR,NURSE", MAXLEN = 6, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",D,N") [ SqlFieldName = ICUXC_CtcpType ];

Property ICUXCDocumentContent As %GlobalCharacterStream(LOCATION = "^DHCICUXMLConfigS") [ SqlFieldName = ICUXC_DocumentContent ];

Property ICUXCLocationDr As %String(TRUNCATE = 1) [ SqlFieldName = ICUXC_Location_Dr ];

Property ICUXCDocumentType As %String(TRUNCATE = 1) [ SqlFieldName = ICUXC_DocumentType ];

Property ICUXCUpdateDate As %Date [ SqlFieldName = ICUXC_UpdateDate ];

Property ICUXCUserGroupDr As %String(TRUNCATE = 1) [ SqlFieldName = ICUXC_UserGroup_Dr ];

Property ICUXCUpdateTime As %Time [ SqlFieldName = ICUXC_UpdateTime ];

Property ICUXCUserDr As %String(TRUNCATE = 1) [ SqlFieldName = ICUXC_User_Dr ];

Property ICUXCUpdateUserDr As %String(TRUNCATE = 1) [ SqlFieldName = ICUXC_UpdateUser_Dr ];

Property ICUXCVersion As %Float [ Required, SqlFieldName = ICUXC_Version ];

Storage Default
{
<Data name="DHCICUXMLConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ICUXCCtcpType</Value>
</Value>
<Value name="3">
<Value>ICUXCLayoutConfig</Value>
</Value>
<Value name="4">
<Value>ICUXCLocationDr</Value>
</Value>
<Value name="5">
<Value>ICUXCPrintConfig</Value>
</Value>
<Value name="6">
<Value>ICUXCUserDr</Value>
</Value>
<Value name="7">
<Value>ICUXCUserGroupDr</Value>
</Value>
<Value name="8">
<Value>ICUXCVersion</Value>
</Value>
<Value name="9">
<Value>ICUXCUpdateDate</Value>
</Value>
<Value name="10">
<Value>ICUXCUpdateTime</Value>
</Value>
<Value name="11">
<Value>ICUXCUpdateUserDr</Value>
</Value>
<Value name="12">
<Value>ICUXCDocumentContent</Value>
</Value>
<Value name="13">
<Value>ICUXCDocumentType</Value>
</Value>
</Data>
<DataLocation>^DHCICUXMLConfig</DataLocation>
<DefaultData>DHCICUXMLConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCICUXMLConfig</IdLocation>
<IndexLocation>^DHCICUXMLConfigI</IndexLocation>
<StreamLocation>^DHCICUXMLConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
