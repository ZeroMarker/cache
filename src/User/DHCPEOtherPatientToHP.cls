/// 其它类型的就诊者需要出体检报告
Class User.DHCPEOtherPatientToHP Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_OtherPatientToHP ]
{

Parameter ClassName = "User.DHCPEOtherPatientToHP";

/// 就诊ID
Property OTHPAADMDR As User.PAAdm [ Required, SqlFieldName = OTH_PAAADM_DR ];

/// 加入人
Property OTHCreateUserDR As User.SSUser [ Required, SqlFieldName = OTH_CreateUser_DR ];

/// 加入日期
Property OTHCreateDate As %Date [ SqlFieldName = OTH_CreateDate ];

/// 加入时间
Property OTHCreateTime As %Time [ Required, SqlFieldName = OTH_CreateTime ];

/// 删除人
Property OTHDeleteUserDR As User.SSUser [ SqlFieldName = OTH_DeleteUser_DR ];

/// 加入日期
Property OTHDeleteDate As %Date [ SqlFieldName = OTH_DeleteDate ];

/// 加入时间
Property OTHDeleteTime As %Time [ SqlFieldName = OTH_DeleteTime ];

Index OTHPAADMDRIndex On OTHPAADMDR;

Index OTHCreateDateIndex On OTHCreateDate;

/// 报告打印人
Property OTHPrintUserDR As User.SSUser [ SqlFieldName = OTH_PrintUser_DR ];

/// 打印日期
Property OTHPrintDate As %Date [ SqlFieldName = OTH_PrintDate ];

/// 报告打印时间
Property OTHPrintTime As %Time [ SqlFieldName = OTH_PrintTime ];

/// 状态 0：已删除  1：未审核   2：已审核  3：已打印  4：已取
Property OTHStatus As %String [ SqlFieldName = OTH_status ];

/// 审核人
Property OTHAuditUserDR As User.SSUser [ SqlFieldName = OTH_AuditUser_DR ];

/// 审核日期
Property OTHAuditDate As %Date [ SqlFieldName = OTH_AuditDate ];

/// 审核时间
Property OTHAuditTime As %Time [ SqlFieldName = OTH_AuditTime ];

/// 审核人
Property OTHCancelAuditUserDR As User.SSUser [ SqlFieldName = OTH_CancelAuditUser_DR ];

/// 审核日期
Property OTHCancelAuditDate As %Date [ SqlFieldName = OTH_CancelAuditDate ];

/// 审核时间
Property OTHCancelAuditTime As %Time [ SqlFieldName = OTH_CancelAuditTime ];

/// 审核日期索引
Index AuditDateIndex On OTHAuditDate;

/// 打印日期索引
Index PrintDateIndex On OTHPrintDate;

Storage Default
{
<Data name="DHCPEOtherPatientToHPDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OTHPAADMDR</Value>
</Value>
<Value name="3">
<Value>OTHCreateUserDR</Value>
</Value>
<Value name="4">
<Value>OTHCreateDate</Value>
</Value>
<Value name="5">
<Value>OTHCreateTime</Value>
</Value>
<Value name="6">
<Value>OTHDeleteUserDR</Value>
</Value>
<Value name="7">
<Value>OTHDeleteDate</Value>
</Value>
<Value name="8">
<Value>OTHDeleteTime</Value>
</Value>
<Value name="9">
<Value>OTHPrintUserDR</Value>
</Value>
<Value name="10">
<Value>OTHPrintDate</Value>
</Value>
<Value name="11">
<Value>OTHPrintTime</Value>
</Value>
<Value name="12">
<Value>OTHStatus</Value>
</Value>
<Value name="13">
<Value>OTHAuditUserDR</Value>
</Value>
<Value name="14">
<Value>OTHAuditDate</Value>
</Value>
<Value name="15">
<Value>OTHAuditTime</Value>
</Value>
<Value name="16">
<Value>OTHCancelAuditUserDR</Value>
</Value>
<Value name="17">
<Value>OTHCancelAuditDate</Value>
</Value>
<Value name="18">
<Value>OTHCancelAuditTime</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEOtherPatientToHPD</DataLocation>
<DefaultData>DHCPEOtherPatientToHPDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEOtherPatientToHPD</IdLocation>
<IndexLocation>^User.DHCPEOtherPatientToHPI</IndexLocation>
<StreamLocation>^User.DHCPEOtherPatientToHPS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
