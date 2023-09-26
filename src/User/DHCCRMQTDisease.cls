Class User.DHCCRMQTDisease Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlRowIdName = QTD_RowId, SqlTableName = DHC_CRM_QTDisease ]
{

Parameter ClassName = "User.DHCCRMQTDisease";

Property QTDCode As %Library.String [ Required, SqlColumnNumber = 2, SqlFieldName = QTD_Code ];

Property QTDDesc As %Library.String [ Required, SqlColumnNumber = 3, SqlFieldName = QTD_Desc ];

Index QTDCodeIndex On QTDCode;

Storage Default
{
<Data name="DHCCRMQTDiseaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QTDCode</Value>
</Value>
<Value name="3">
<Value>QTDDesc</Value>
</Value>
</Data>
<DataLocation>^User.DHCCRMQTDiseaseD</DataLocation>
<DefaultData>DHCCRMQTDiseaseDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCCRMQTDiseaseD</IdLocation>
<IndexLocation>^User.DHCCRMQTDiseaseI</IndexLocation>
<StreamLocation>^User.DHCCRMQTDiseaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
