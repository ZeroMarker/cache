Class User.DHCPEOMEIllness Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_OMEIllness ]
{

Parameter ClassName = "User.DHCPEOMEIllness";

///  目标疾病代码
Property ITCode As %String(MAXLEN = 20) [ Required, SqlFieldName = IT_Code ];

///  目标疾病描述
Property ITDesc As %String(MAXLEN = 20) [ Required, SqlFieldName = IT_Desc ];

///  激活，Y，N
Property ITActive As %String(MAXLEN = 1) [ SqlFieldName = IT_Active ];

///  目标疾病结论分类
Property ITConclusionDR As User.DHCPEConclusion [ Required, SqlFieldName = IT_ConclusionDR ];

///  目标疾病扩展信息
Property ITExpInfo As %String(MAXLEN = 10) [ SqlFieldName = IT_ExpInfo ];

///  备注
Property ITRemark As %String(MAXLEN = 200) [ SqlFieldName = IT_Remark ];

/// 代码索引
Index ITCodeIndex On ITCode [ Unique ];

/// 描述索引
Index ITDescIndex On ITDesc [ Unique ];

/// 结论分类索引
Index ConclusionIndex On ITConclusionDR As AlphaUp;

Storage Default
{
<Data name="DHCPEOMEIllnessDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ITCode</Value>
</Value>
<Value name="3">
<Value>ITDesc</Value>
</Value>
<Value name="4">
<Value>ITActive</Value>
</Value>
<Value name="5">
<Value>ITConclusionDR</Value>
</Value>
<Value name="6">
<Value>ITExpInfo</Value>
</Value>
<Value name="7">
<Value>ITRemark</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEOMEIllnessD</DataLocation>
<DefaultData>DHCPEOMEIllnessDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEOMEIllnessD</IdLocation>
<IndexLocation>^User.DHCPEOMEIllnessI</IndexLocation>
<StreamLocation>^User.DHCPEOMEIllnessS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
