Class User.DHCCRMQTICDRelate Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlRowIdName = QTR_RowId, SqlTableName = DHC_CRM_QTICDRelate ]
{

Parameter ClassName = "User.DHCCRMQTICDRelate";

Property QTRQTDDR As User.DHCCRMQTDisease [ Required, SqlColumnNumber = 2, SqlFieldName = QTR_QTDDR ];

Property QTRICDDR As User.MRCICDDx [ Required, SqlColumnNumber = 3, SqlFieldName = QTR_ICDDR ];

Index QTRQTDDRIndex On QTRQTDDR;

Index QTRICDDRIndex On QTRICDDR;

Storage Default
{
<Data name="DHCCRMQTICDRelateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QTRQTDDR</Value>
</Value>
<Value name="3">
<Value>QTRICDDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCCRMQTICDRelateD</DataLocation>
<DefaultData>DHCCRMQTICDRelateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCCRMQTICDRelateD</IdLocation>
<IndexLocation>^User.DHCCRMQTICDRelateI</IndexLocation>
<StreamLocation>^User.DHCCRMQTICDRelateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
