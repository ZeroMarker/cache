Class User.DHCPEIndustry Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_Industry ]
{

Parameter ClassName = "User.DHCPEIndustry";

///  行业代码
Property ICode As %String(MAXLEN = 20) [ Required, SqlFieldName = I_Code ];

///  行业描述
Property IDesc As %String(MAXLEN = 20) [ Required, SqlFieldName = I_Desc ];

///  激活，Y，N
Property IActive As %String(MAXLEN = 1) [ SqlFieldName = I_Active ];

///  行业扩展信息
Property IExpInfo As %String(MAXLEN = 10) [ SqlFieldName = I_ExpInfo ];

///  行业备注
Property IRemark As %String(MAXLEN = 200) [ SqlFieldName = I_Remark ];

/// 代码索引
Index ICodeIndex On ICode [ Unique ];

/// 描述索引
Index IDescIndex On IDesc [ Unique ];

Storage Default
{
<Data name="DHCPEIndustryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ICode</Value>
</Value>
<Value name="3">
<Value>IDesc</Value>
</Value>
<Value name="4">
<Value>IActive</Value>
</Value>
<Value name="5">
<Value>IExpInfo</Value>
</Value>
<Value name="6">
<Value>IRemark</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEIndustryD</DataLocation>
<DefaultData>DHCPEIndustryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEIndustryD</IdLocation>
<IndexLocation>^User.DHCPEIndustryI</IndexLocation>
<StreamLocation>^User.DHCPEIndustryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
