Class User.DHCPEQMErrType Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_QMErrType ]
{

Parameter ClassName = "User.DHCPEQMErrType";

Relationship QMETParRef As User.DHCPEQMType [ Cardinality = parent, Inverse = QMETChild ];

/// 代码
Property QMETCode As %String [ Required, SqlFieldName = QMET_Code ];

Index QMETCodeIndex On QMETCode [ Unique ];

/// 描述
Property QMETDesc As %String [ Required, SqlFieldName = QMET_Desc ];

Index QMETDescIndex On QMETDesc [ Unique ];

/// 激活标志
Property QMETActiveFlag As %String(MAXLEN = 1) [ SqlFieldName = QMET_ActiveFlag ];

/// 扩展信息
Property QMETExpStr As %String [ SqlFieldName = QMET_ExpStr ];

/// 备注
Property QMETRemark As %String [ SqlFieldName = QMET_Remark ];

Storage Default
{
<Data name="DHCPEQMErrTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QMETCode</Value>
</Value>
<Value name="3">
<Value>QMETDesc</Value>
</Value>
<Value name="4">
<Value>QMETActiveFlag</Value>
</Value>
<Value name="5">
<Value>QMETExpStr</Value>
</Value>
<Value name="6">
<Value>QMETRemark</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("QMETChild")</DataLocation>
<DefaultData>DHCPEQMErrTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEQMTypeC("QMETChild")</IdLocation>
<IndexLocation>^User.DHCPEQMErrTypeI</IndexLocation>
<StreamLocation>^User.DHCPEQMErrTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
