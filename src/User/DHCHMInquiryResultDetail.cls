/// Description:问诊结果表介绍表  考虑后期是否根据婚姻 状况或性别提供不同的介绍，所以以子表的形式存储
/// Creator:wangguoying
Class User.DHCHMInquiryResultDetail Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlTableName = DHC_HM_InquiryResultDetail ]
{

Parameter ClassName = "User.DHCHMInquiryResultDetail";

Relationship IRDParRef As User.DHCHMInquiryResult [ Cardinality = parent, Inverse = IRDetail ];

/// 介绍
Property IRDIntroduce As %String(MAXLEN = 1000) [ Required, SqlColumnNumber = 2, SqlFieldName = IRD_Introduce ];

/// 健康建议
Property IRDAdvice As %GlobalCharacterStream [ Required, SqlColumnNumber = 3, SqlFieldName = IRD_Advice ];

/// 备注
Property IRDRemark As %String(MAXLEN = 1000) [ SqlColumnNumber = 4, SqlFieldName = IRD_Remark ];

/// 作废标记
Property IRDNoActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = IRD_NoActive ];

/// 更新日期
Property IRDUpdateDate As %Date [ SqlFieldName = IRD_UpdateDate ];

/// 更新时间
Property IRDUpdateTime As %Time [ SqlFieldName = IRD_UpdateTime ];

/// 更信人 指向SS_User
Property IRDUpdateUserDR As %String [ SqlFieldName = IRD_UpdateUserDR ];

Storage Default
{
<Data name="DHCHMInquiryResultDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IRDIntroduce</Value>
</Value>
<Value name="3">
<Value>IRDAdvice</Value>
</Value>
<Value name="4">
<Value>IRDRemark</Value>
</Value>
<Value name="5">
<Value>IRDNoActive</Value>
</Value>
<Value name="6">
<Value>IRDUpdateDate</Value>
</Value>
<Value name="7">
<Value>IRDUpdateTime</Value>
</Value>
<Value name="8">
<Value>IRDUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("IRDetail")</DataLocation>
<DefaultData>DHCHMInquiryResultDetailDefaultData</DefaultData>
<IdLocation>^User.DHCHMInquiryResultC("IRDetail")</IdLocation>
<IndexLocation>^User.DHCHMInquiryResultDetailI</IndexLocation>
<StreamLocation>^User.DHCHMInquiryResultDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
