/// Creater:dhh
/// Descriptions:专利备案
/// Date:2020-07-27
Class DHCINM.SM.Patent Extends %Persistent
{

/// 专利名称
Property PatentName As %String [ SqlColumnNumber = 2, SqlFieldName = Patent_Name ];

/// 专利类型
Property PatentType As %String [ SqlColumnNumber = 3, SqlFieldName = Patent_Type ];

/// 认证机构
Property PatentMechanism As %String [ SqlColumnNumber = 4, SqlFieldName = Patent_Mechanism ];

/// 专利号
Property PatentNumber As %String [ SqlColumnNumber = 5, SqlFieldName = Patent_Number ];

/// 申请日期
Property PatentDate As %String [ SqlColumnNumber = 6, SqlFieldName = Patent_Date ];

/// 发明人
Property PatentPer As list Of %String [ SqlColumnNumber = 7, SqlFieldName = Patent_Per ];

/// 附件
Property PatentPic As %String(MAXLEN = 1000) [ SqlColumnNumber = 8, SqlFieldName = Patent_Pic ];

/// 状态(Y:提交,N:保存,B:驳回,S:审核)
Property PatentStatus As %String [ SqlColumnNumber = 9, SqlFieldName = Patent_Status ];

/// 驳回意见
Property Reason As %String [ SqlColumnNumber = 10, SqlFieldName = Reason ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 11, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 12, SqlFieldName = Create_Date ];

/// 病区
Property PatentWard As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 13, SqlFieldName = Paten_tWard ];

/// 审核人
Property Auditor As %String [ SqlColumnNumber = 14, SqlFieldName = Auditor ];

/// 审核日期
Property AuditDate As %Date [ SqlColumnNumber = 15, SqlFieldName = AuditDate ];

/// 审核时间
Property AuditTime As %Time [ SqlColumnNumber = 16, SqlFieldName = AuditTime ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 17, SqlFieldName = Create_Time ];

Storage Default
{
<Data name="PatentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PatentName</Value>
</Value>
<Value name="3">
<Value>PatentType</Value>
</Value>
<Value name="4">
<Value>PatentMechanism</Value>
</Value>
<Value name="5">
<Value>PatentNumber</Value>
</Value>
<Value name="6">
<Value>PatentDate</Value>
</Value>
<Value name="7">
<Value>PatentPer</Value>
</Value>
<Value name="8">
<Value>PatentPic</Value>
</Value>
<Value name="9">
<Value>PatentStatus</Value>
</Value>
<Value name="10">
<Value>Reason</Value>
</Value>
<Value name="11">
<Value>Creator</Value>
</Value>
<Value name="12">
<Value>CreateDate</Value>
</Value>
<Value name="13">
<Value>PatentWard</Value>
</Value>
<Value name="14">
<Value>Auditor</Value>
</Value>
<Value name="15">
<Value>AuditDate</Value>
</Value>
<Value name="16">
<Value>AuditTime</Value>
</Value>
<Value name="17">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^DHCINM.SM.PatentD</DataLocation>
<DefaultData>PatentDefaultData</DefaultData>
<IdLocation>^DHCINM.SM.PatentD</IdLocation>
<IndexLocation>^DHCINM.SM.PatentI</IndexLocation>
<StreamLocation>^DHCINM.SM.PatentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
