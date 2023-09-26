Class User.DHCPEEDCheckCriteria Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_EDCheckCriteria ]
{

Parameter ClassName = "User.DHCPEEDCheckCriteria";

Relationship EDCCParref As User.DHCPEEndanger [ Cardinality = parent, Inverse = EDCheckCriteriaChild ];

/// 诊断标准代码
Property EDCCCode As %String(MAXLEN = 20) [ Required, SqlFieldName = EDCC_Code ];

/// 诊断标准
Property EDCCDCDR As User.DHCPEDiagnosticCriteria [ Required, SqlFieldName = EDCC_DCDR ];

/// 检查种类
Property EDCCOMETypeDR As User.DHCPEOMEType [ Required, SqlFieldName = EDCC_OMETypeDR ];

/// 激活，Y，N
Property EDCCActive As %String(MAXLEN = 1) [ SqlFieldName = EDCC_Active ];

/// 诊断标准扩展信息
Property EDCCExpInfo As %String(MAXLEN = 100) [ SqlFieldName = EDCC_ExpInfo ];

/// 备注
Property EDCCRemark As %String(MAXLEN = 200) [ SqlFieldName = EDCC_Remark ];

/// 代码索引
Index EDCCCodeIndex On EDCCCode [ Unique ];

/// 检查种类索引
Index EDCCOMETypeDRIndex On EDCCOMETypeDR As AlphaUp;

Storage Default
{
<Data name="DHCPEEDCheckCriteriaDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EDCCode</Value>
</Value>
<Value name="3">
<Value>EDCDesc</Value>
</Value>
<Value name="4">
<Value>EDCOMETypeDR</Value>
</Value>
<Value name="5">
<Value>EDCActive</Value>
</Value>
<Value name="6">
<Value>EDCExpInfo</Value>
</Value>
<Value name="7">
<Value>EDCRemark</Value>
</Value>
<Value name="8">
<Value>EDCCCode</Value>
</Value>
<Value name="9">
<Value>EDCCDesc</Value>
</Value>
<Value name="10">
<Value>EDCCOMETypeDR</Value>
</Value>
<Value name="11">
<Value>EDCCExpInfo</Value>
</Value>
<Value name="12">
<Value>EDCCRemark</Value>
</Value>
<Value name="13">
<Value>EDCCActive</Value>
</Value>
<Value name="14">
<Value>EDCCDCDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("EDCheckCriteriaChild")</DataLocation>
<DefaultData>DHCPEEDCheckCriteriaDefaultData</DefaultData>
<IdLocation>^User.DHCPEEndangerC("EDCheckCriteriaChild")</IdLocation>
<IndexLocation>^User.DHCPEEDCheckCriteriaI</IndexLocation>
<StreamLocation>^User.DHCPEEDCheckCriteriaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
