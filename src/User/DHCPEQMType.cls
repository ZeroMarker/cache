/// 体检质量类型
Class User.DHCPEQMType Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract, User.Abstract) [ SqlTableName = DHC_PE_QMType ]
{

Parameter ClassName = "User.DHCPEQMType";

/// 代码
Property QMTCode As %String [ Required, SqlFieldName = QMT_Code ];

Index QMTCodeIndex On QMTCode [ Unique ];

/// 描述
Property QMTDesc As %String [ Required, SqlFieldName = QMT_Desc ];

Index QMTDescIndex On QMTDesc [ Unique ];

/// 激活标志
Property QMTActiveFlag As %String [ SqlFieldName = QMT_ActiveFlag ];

/// 备注
Property QMTRemark As %String [ SqlFieldName = QMT_Remark ];

/// 扩展信息
Property QMTExpStr As %String [ SqlFieldName = QMT_ExpStr ];

/// 更新日期
Property QMTUpdateDate As %Date [ SqlFieldName = QMT_UpdateDate ];

/// 更新时间
Property QMTUpdateTime As %Time [ SqlFieldName = QMT_UpdateTime ];

/// 更信人 指向SS_User
Property QMTUpdateUserDR As %String [ SqlFieldName = QMT_UpdateUserDR ];

/// 子表
Relationship QMETChild As User.DHCPEQMErrType [ Cardinality = children, Inverse = QMETParRef ];

Storage Default
{
<Data name="DHCPEQMTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QMTCode</Value>
</Value>
<Value name="3">
<Value>QMTDesc</Value>
</Value>
<Value name="4">
<Value>QMTActiveFlag</Value>
</Value>
<Value name="5">
<Value>QMTRemark</Value>
</Value>
<Value name="6">
<Value>QMTExpStr</Value>
</Value>
<Value name="7">
<Value>QMTUpdateDate</Value>
</Value>
<Value name="8">
<Value>QMTUpdateTime</Value>
</Value>
<Value name="9">
<Value>QMTUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEQMTypeD</DataLocation>
<DefaultData>DHCPEQMTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEQMTypeD</IdLocation>
<IndexLocation>^User.DHCPEQMTypeI</IndexLocation>
<StreamLocation>^User.DHCPEQMTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
