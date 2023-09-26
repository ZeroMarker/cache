/// 急诊担保申请
Class User.DHCEmDocGuarantee Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_EmDocGuarantee ]
{

/// 就诊id
Property DGUAdm As %String [ SqlFieldName = DGU_Adm ];

Index DGUAdmIndex On DGUAdm;

/// 申请人
Property DGUCreator As SSUser [ SqlFieldName = DGU_Creator ];

/// 抵押日期
Property DGUCreateDate As %Date [ InitialExpression = {+$p($h,",",1)}, SqlFieldName = DGU_CreateDate ];

/// 抵押品
Property DGUGuarantee As %String [ SqlFieldName = DGU_Guarantee ];

/// 担保金额
Property DGUMoney As User.DHCEmGuaLevel [ SqlFieldName = DGU_Money ];

/// 担保原因
Property DGUGuaReason As User.DHCEmGuaReason [ SqlFieldName = DGU_GuaReason ];

/// 担保开始日期
Property DGUStartDate As %Date [ SqlFieldName = DGU_StartDate ];

/// 担保结束日期
Property DGUEndTime As %Date [ SqlFieldName = DGU_EndTime ];

/// 担保状态 R(申请) Y(申请通过) N(申请拒绝) C(取消审核)
Property DGUStatus As %String [ SqlFieldName = DGU_Status ];

/// 审核人
Property DGUAuditor As SSUser [ SqlFieldName = DGU_Auditor ];

/// 审核日期
Property DGUAuditDate As %Date [ SqlFieldName = DGU_AuditDate ];

/// 审核时间
Property DGUAuditTime As %Time [ SqlFieldName = DGU_AuditTime ];

/// 担保人
Property DGUUser As %String [ SqlFieldName = DGU_User ];

/// 抵押时间
Property DGUCreateTime As %Time [ InitialExpression = {+$p($h,",",2)}, SqlFieldName = DGU_CreateTime ];

/// 拒绝原因
Property DGURefuseReason As %String(MAXLEN = 5000) [ SqlFieldName = DGU_RefuseReason ];

Storage Default
{
<Data name="DHCEmDocGuaranteeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DGUAdm</Value>
</Value>
<Value name="3">
<Value>DGUCreator</Value>
</Value>
<Value name="4">
<Value>DGUCreateDate</Value>
</Value>
<Value name="5">
<Value>DGUGuarantee</Value>
</Value>
<Value name="6">
<Value>DGUMoney</Value>
</Value>
<Value name="7">
<Value>DGUGuaReason</Value>
</Value>
<Value name="8">
<Value>DGUStartDate</Value>
</Value>
<Value name="9">
<Value>DGUEndTime</Value>
</Value>
<Value name="10">
<Value>DGUStatus</Value>
</Value>
<Value name="11">
<Value>DGUAuditor</Value>
</Value>
<Value name="12">
<Value>DGUAuditDate</Value>
</Value>
<Value name="13">
<Value>DGUAuditTime</Value>
</Value>
<Value name="14">
<Value>DGUUser</Value>
</Value>
<Value name="15">
<Value>DGUCreateTime</Value>
</Value>
<Value name="16">
<Value>DGURefuseReason</Value>
</Value>
</Data>
<DataLocation>^User.DHCEmDocGuaranteeD</DataLocation>
<DefaultData>DHCEmDocGuaranteeDefaultData</DefaultData>
<IdLocation>^User.DHCEmDocGuaranteeD</IdLocation>
<IndexLocation>^User.DHCEmDocGuaranteeI</IndexLocation>
<StreamLocation>^User.DHCEmDocGuaranteeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Index DGUCreateDateIndex On DGUCreateDate;

}
