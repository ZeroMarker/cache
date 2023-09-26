/// Creater:dhh
/// Descriptions:获奖创新备案
/// Date:2020-07-27
Class DHCINM.SM.AwaInnovate Extends %Persistent
{

/// 获奖创新类型
Property AwaInnType As %String [ SqlColumnNumber = 2, SqlFieldName = AwaInn_Type ];

/// 获奖创新主题
Property AwaInnTheme As %String [ SqlColumnNumber = 3, SqlFieldName = AwaInn_Theme ];

/// 获奖创新科室
Property AwaInnWard As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 4, SqlFieldName = AwaInn_Ward ];

/// 是否本专科
Property AwaInnSpec As %String [ SqlColumnNumber = 5, SqlFieldName = AwaInn_Spec ];

/// 负责人
Property AwaInnLead As CF.DHCINM.HR.Persons [ SqlColumnNumber = 6, SqlFieldName = AwaInn_Lead ];

/// 参与人
Property AwaInnPart As list Of %String [ SqlColumnNumber = 7, SqlFieldName = AwaInn_Part ];

/// 获奖奖项
Property AwaInnAward As %String [ SqlColumnNumber = 8, SqlFieldName = AwaInn_Award ];

/// 获奖级别
Property AwaInnLevel As %String [ SqlColumnNumber = 9, SqlFieldName = AwaInn_Level ];

/// 附件
Property AwaInnPic As %String(MAXLEN = 1000) [ SqlColumnNumber = 10, SqlFieldName = AwaInn_Pic ];

/// 状态(Y:提交,N:保存,B:驳回,S:审核)
Property AwaInnStatus As %String [ SqlColumnNumber = 11, SqlFieldName = AwaInn_Status ];

/// 驳回意见
Property Reason As %String [ SqlColumnNumber = 12, SqlFieldName = Reason ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 13, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 14, SqlFieldName = Create_Date ];

/// 审核人
Property Auditor As %String [ SqlColumnNumber = 15, SqlFieldName = Auditor ];

/// 审核日期
Property AuditDate As %Date [ SqlColumnNumber = 16, SqlFieldName = AuditDate ];

/// 审核时间
Property AuditTime As %Time [ SqlColumnNumber = 17, SqlFieldName = AuditTime ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 18, SqlFieldName = Create_Time ];

Storage Default
{
<Data name="AwaInnovateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AwaInnType</Value>
</Value>
<Value name="3">
<Value>AwaInnTheme</Value>
</Value>
<Value name="4">
<Value>AwaInnWard</Value>
</Value>
<Value name="5">
<Value>AwaInnSpec</Value>
</Value>
<Value name="6">
<Value>AwaInnLead</Value>
</Value>
<Value name="7">
<Value>AwaInnPart</Value>
</Value>
<Value name="8">
<Value>AwaInnAward</Value>
</Value>
<Value name="9">
<Value>AwaInnLevel</Value>
</Value>
<Value name="10">
<Value>AwaInnPic</Value>
</Value>
<Value name="11">
<Value>AwaInnStatus</Value>
</Value>
<Value name="12">
<Value>Reason</Value>
</Value>
<Value name="13">
<Value>Creator</Value>
</Value>
<Value name="14">
<Value>CreateDate</Value>
</Value>
<Value name="15">
<Value>Auditor</Value>
</Value>
<Value name="16">
<Value>AuditDate</Value>
</Value>
<Value name="17">
<Value>AuditTime</Value>
</Value>
<Value name="18">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^DHCINM.SM.AwaInnovateD</DataLocation>
<DefaultData>AwaInnovateDefaultData</DefaultData>
<IdLocation>^DHCINM.SM.AwaInnovateD</IdLocation>
<IndexLocation>^DHCINM.SM.AwaInnovateI</IndexLocation>
<StreamLocation>^DHCINM.SM.AwaInnovateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
