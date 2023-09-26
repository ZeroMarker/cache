/// Creater:wangpf
/// Descriptions:专科主题活动
/// Date:2020-07-22
Class DHCINM.Special.SpecialActivity Extends %Persistent
{

/// 病区
Property ActivityWard As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 2, SqlFieldName = Activity_Ward ];

/// 参与人
Property ActivityNurse As list Of %String [ SqlColumnNumber = 3, SqlFieldName = Activity_Nurse ];

/// 活动形式 L:主题论坛 T:主题讨论 B:专题读书报告 J:论坛讲座 G:专业组讲座 O:其他
Property ActivityType As %String(DISPLAYLIST = ",主题论坛,主题讨论,专题读书报告,论坛讲座,专业组讲座,其他", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",L,T,B,J,G,O") [ SqlColumnNumber = 4, SqlFieldName = Activity_Type ];

/// 参与形式 P:参与 H:主持 C:负责 Z:组织 O:其他
Property ActivityParType As %String(DISPLAYLIST = ",参与,主持,负责,组织,其他", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",P,H,C,Z,O") [ SqlColumnNumber = 5, SqlFieldName = Activity_ParType ];

/// 级别 H:护理部 L:科室 W:病区
Property ActivityLevel As %String(DISPLAYLIST = ",护理部,科室,病区", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",H,L,W") [ SqlColumnNumber = 6, SqlFieldName = Activity_Level ];

/// 活动日期
Property ActivityDate As %Date [ SqlColumnNumber = 7, SqlFieldName = Activity_Date ];

/// 主题
Property ActivityTopic As %String [ SqlColumnNumber = 8, SqlFieldName = Activity_Topic ];

/// 地点
Property ActivityLocation As %String [ SqlColumnNumber = 9, SqlFieldName = Activity_Location ];

/// 文件
Property ActivityFile As %String(MAXLEN = 2000) [ SqlColumnNumber = 10, SqlFieldName = Activity_File ];

/// 状态 N:保存 Y:提交 A:审核 B:驳回
Property ActivityStatus As %String(DISPLAYLIST = ",保存,提交,审核,驳回", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",N,Y,A,B") [ SqlColumnNumber = 11, SqlFieldName = Activity_Status ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 12, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 13, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 14, SqlFieldName = Create_Time ];

/// 审核人
Property Auditor As %String [ SqlColumnNumber = 15, SqlFieldName = Auditor ];

/// 审核日期
Property AuditDate As %Date [ SqlColumnNumber = 16, SqlFieldName = AuditDate ];

/// 审核时间
Property AuditTime As %Time [ SqlColumnNumber = 17, SqlFieldName = AuditTime ];

/// 审核意见
Property AuditOpinion As %String(MAXLEN = 1000) [ SqlColumnNumber = 18, SqlFieldName = AuditOpinion ];

Index ToolIndex On (ActivityDate, ActivityWard, ActivityLevel, ActivityType, ActivityParType, ActivityStatus);

Storage Default
{
<Data name="SpecialActivityDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ActivityWard</Value>
</Value>
<Value name="3">
<Value>ActivityNurse</Value>
</Value>
<Value name="4">
<Value>ActivityType</Value>
</Value>
<Value name="5">
<Value>ActivityParType</Value>
</Value>
<Value name="6">
<Value>ActivityLevel</Value>
</Value>
<Value name="7">
<Value>ActivityDate</Value>
</Value>
<Value name="8">
<Value>ActivityTopic</Value>
</Value>
<Value name="9">
<Value>ActivityLocation</Value>
</Value>
<Value name="10">
<Value>ActivityFile</Value>
</Value>
<Value name="11">
<Value>ActivityStatus</Value>
</Value>
<Value name="12">
<Value>Creator</Value>
</Value>
<Value name="13">
<Value>CreateDate</Value>
</Value>
<Value name="14">
<Value>CreateTime</Value>
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
<Value>AuditOpinion</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Special.SpecialActivityD</DataLocation>
<DefaultData>SpecialActivityDefaultData</DefaultData>
<IdLocation>^DHCINM.Special.SpecialActivityD</IdLocation>
<IndexLocation>^DHCINM.Special.SpecialActivityI</IndexLocation>
<StreamLocation>^DHCINM.Special.SpecialActivityS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
