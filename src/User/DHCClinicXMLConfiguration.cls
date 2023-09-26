Class User.DHCClinicXMLConfiguration Extends (%Persistent, %XML.Adaptor) [ Owner = {_SYSTEM}, SqlTableName = DHCClinic_XMLConfiguration, StorageStrategy = Default ]
{

Property XCDocumentName As %String(TRUNCATE = 1) [ SqlFieldName = XC_DocumentName ];

Property XCDocumentContent As %GlobalCharacterStream(LOCATION = "^DHCClinicXMLConfigS") [ SqlFieldName = XC_DocumentContent ];

Property XCUpdateDate As %Date [ SqlFieldName = XC_UpdateDate ];

Property XCUpdateTime As %Time [ SqlFieldName = XC_UpdateTime ];

Property XCUpdateUserDr As %String(TRUNCATE = 1) [ SqlFieldName = XC_UpdateUser_Dr ];

Storage Default
{
<Data name="DHCClinicXMLConfigDefaultData">
<Value name="1">
<Value>%%ClASSNAME</Value>
</Value>
<Value name="2">
<Value>XCDocumentName</Value>
</Value>
<Value name="3">
<Value>XCDocumentContent</Value>
</Value>
<Value name="4">
<Value>XCUpdateDate</Value>
</Value>
<Value name="5">
<Value>XCUpdateTime</Value>
</Value>
<Value name="6">
<Value>XCUpdateUserDr</Value>
</Value>
<Value name="7">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCClinicXMLConfig</DataLocation>
<DefaultData>DHCClinicXMLConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCClinicXMLConfig</IdLocation>
<IndexLocation>^DHCClinicXMLConfigI</IndexLocation>
<StreamLocation>^DHCClinicXMLConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
