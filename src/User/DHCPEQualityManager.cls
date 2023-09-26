/// 质量控制记录
Class User.DHCPEQualityManager Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_QualityManager ]
{

Parameter ClassName = "User.DHCPEQualityManager";

/// 就诊记录
Property QMPAADMDR As User.PAAdm [ SqlFieldName = QM_PAADM_DR ];

/// 错误类型
Property QMErrTypeDR As User.DHCPEQMType [ SqlFieldName = QM_Type_DR ];

/// 错误内容
Property QMErrDetail As %String(MAXLEN = 500) [ SqlFieldName = QM_ErrDetail ];

/// 备注
Property QMRemark As %String(MAXLEN = 500) [ SqlFieldName = QM_Remark ];

/// 发生错误人
Property QMErrUserDR As User.SSUser [ SqlFieldName = QM_ErrUser_DR ];

/// 发现错误人
Property QMCreateUserDR As User.SSUser [ SqlFieldName = QM_CreateUser_DR ];

/// 发现错误日期
Property QMCreateDate As %Library.Date [ SqlFieldName = QM_CreateDate ];

/// 发现错误时间
Property QMCreateTime As %Library.Time [ SqlFieldName = QM_CreateTime ];

/// 数据状态 N:正常 D:删除
Property QMStatus As %String(MAXLEN = 1) [ SqlFieldName = QM_Status ];

/// 最后更新人
Property QMUpdateUserDR As User.SSUser [ SqlFieldName = QM_UpdateUser_DR ];

/// 最后更新日期
Property QMUpdateDate As %Library.Date [ SqlFieldName = QM_UpdateDate ];

/// 最后更新时间
Property QMUpdateTime As %Library.Time [ SqlFieldName = QM_UpdateTime ];

/// 录入错误时错误的项目，医嘱表ID
Property QMOrderDR As User.OEOrdItem [ SqlFieldName = QM_Order_DR ];

/// 就诊记录的索引
Index PAADMIndex On QMPAADMDR;

/// 日期索引
Index DateIndex On QMCreateDate;

Storage Default
{
<Data name="DHCPEQualityManagerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QMPAADMDR</Value>
</Value>
<Value name="3">
<Value>QMErrTypeDR</Value>
</Value>
<Value name="4">
<Value>QMErrDetail</Value>
</Value>
<Value name="5">
<Value>QMRemark</Value>
</Value>
<Value name="6">
<Value>QMErrUserDR</Value>
</Value>
<Value name="7">
<Value>QMCreateUserDR</Value>
</Value>
<Value name="8">
<Value>QMCreateDate</Value>
</Value>
<Value name="9">
<Value>QMCreateTime</Value>
</Value>
<Value name="10">
<Value>QMStatus</Value>
</Value>
<Value name="11">
<Value>QMUpdateUserDR</Value>
</Value>
<Value name="12">
<Value>QMUpdateDate</Value>
</Value>
<Value name="13">
<Value>QMUpdateTime</Value>
</Value>
<Value name="14">
<Value>QMOrderDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEQualityManagerD</DataLocation>
<DefaultData>DHCPEQualityManagerDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEQualityManagerD</IdLocation>
<IndexLocation>^User.DHCPEQualityManagerI</IndexLocation>
<StreamLocation>^User.DHCPEQualityManagerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
