Class User.DHCPEProtectiveMeasures Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_ProtectiveMeasures ]
{

Parameter ClassName = "User.DHCPEProtectiveMeasures";

///  防护措施代码
Property PMCode As %String(MAXLEN = 20) [ Required, SqlFieldName = PM_Code ];

///  防护措施描述
Property PMDesc As %String(MAXLEN = 20) [ Required, SqlFieldName = PM_Desc ];

///  激活，Y，N
Property PMActive As %String(MAXLEN = 1) [ SqlFieldName = PM_Active ];

///  防护措施扩展信息
Property PMExpInfo As %String(MAXLEN = 10) [ SqlFieldName = PM_ExpInfo ];

///  备注
Property PMRemark As %String(MAXLEN = 200) [ SqlFieldName = PM_Remark ];

/// 代码索引
Index PMCodeIndex On PMCode [ Unique ];

/// 描述索引
Index PMDescIndex On PMDesc [ Unique ];

Storage Default
{
<Data name="DHCPEProtectiveMeasuresDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PMCode</Value>
</Value>
<Value name="3">
<Value>PMDesc</Value>
</Value>
<Value name="4">
<Value>PMActive</Value>
</Value>
<Value name="5">
<Value>PMExpInfo</Value>
</Value>
<Value name="6">
<Value>PMRemark</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEProtectiveMeasuresD</DataLocation>
<DefaultData>DHCPEProtectiveMeasuresDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEProtectiveMeasuresD</IdLocation>
<IndexLocation>^User.DHCPEProtectiveMeasuresI</IndexLocation>
<StreamLocation>^User.DHCPEProtectiveMeasuresS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
