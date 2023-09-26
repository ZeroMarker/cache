/// Creater:dhh
/// Descriptions:交流获奖论文备案
/// Date:2020-07-23
Class DHCINM.SM.AwardThesis Extends %Persistent
{

/// 论文题目
Property AwardTitle As %String [ SqlColumnNumber = 2, SqlFieldName = Award_Title ];

/// 第一作者
Property AwardAuthor As list Of %String [ SqlColumnNumber = 3, SqlFieldName = Award_Author ];

/// 会议名称
Property AwardName As %String [ SqlColumnNumber = 4, SqlFieldName = Award_Name ];

/// 会议级别
Property AwardLevel As %String [ SqlColumnNumber = 5, SqlFieldName = Award_Level ];

/// 获奖情况
Property AwardSituation As %String [ SqlColumnNumber = 6, SqlFieldName = Award_Situation ];

/// 交流日期
Property AwardDate As %Date [ SqlColumnNumber = 7, SqlFieldName = Award_Date ];

/// 是否本专科(Y:是,N:否)
Property AwardSpec As %String(DISPLAYLIST = ",否,是", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",N,Y") [ SqlColumnNumber = 8, SqlFieldName = Award_Spec ];

/// 参与者
Property AwardPart As list Of %String [ SqlColumnNumber = 9, SqlFieldName = Award_Part ];

/// 附件
Property AwardFile As %String(MAXLEN = 2000) [ SqlColumnNumber = 10, SqlFieldName = Award_File ];

/// 状态(Y:提交,N:保存,B:驳回,S:审核)
Property AwardStatus As %String [ SqlColumnNumber = 11, SqlFieldName = Award_Status ];

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
<Data name="AwardThesisDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AwardTitle</Value>
</Value>
<Value name="3">
<Value>AwardAuthor</Value>
</Value>
<Value name="4">
<Value>AwardName</Value>
</Value>
<Value name="5">
<Value>AwardLevel</Value>
</Value>
<Value name="6">
<Value>AwardSituation</Value>
</Value>
<Value name="7">
<Value>AwardDate</Value>
</Value>
<Value name="8">
<Value>AwardSpec</Value>
</Value>
<Value name="9">
<Value>AwardPart</Value>
</Value>
<Value name="10">
<Value>AwardFile</Value>
</Value>
<Value name="11">
<Value>AwardStatus</Value>
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
<DataLocation>^DHCINM.SM.AwardThesisD</DataLocation>
<DefaultData>AwardThesisDefaultData</DefaultData>
<IdLocation>^DHCINM.SM.AwardThesisD</IdLocation>
<IndexLocation>^DHCINM.SM.AwardThesisI</IndexLocation>
<StreamLocation>^DHCINM.SM.AwardThesisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
