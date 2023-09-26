/// Creater:wangpf
/// Descriptions:医患座谈会记录
/// Date:2020-07-10
Class DHCINM.HB.MgPatMeetingRec Extends %Persistent
{

/// 会议级别 H:护理部 L:科室 W:病区
Property MeetingLevel As %String(DISPLAYLIST = ",护理部,科室,病区", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",H,L,W") [ SqlColumnNumber = 2, SqlFieldName = Meeting_Level ];

/// 会议日期
Property MeetingDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Meeting_Date ];

/// 会议时间
Property MeetingTime As %Time [ SqlColumnNumber = 4, SqlFieldName = Meeting_Time ];

/// 会议地点
Property MeetingLocation As %String [ SqlColumnNumber = 5, SqlFieldName = Meeting_Location ];

/// 会议参与部门
Property MeetingDepartment As %String [ SqlColumnNumber = 6, SqlFieldName = Meeting_Department ];

/// 会议参与病区及人数
Property MeetingWard As list Of %String [ SqlColumnNumber = 7, SqlFieldName = Meeting_Ward ];

/// 会议参与人
Property MeetingParticipant As list Of %String [ SqlColumnNumber = 8, SqlFieldName = Meeting_Participant ];

/// 会议主持人
Property MeetingHoster As CF.DHCINM.HR.Persons [ SqlColumnNumber = 9, SqlFieldName = Meeting_Hoster ];

/// 会议主持人职务
Property MeetingHosterPost As CT.DHCINM.DB.MgSetCodeSub [ SqlColumnNumber = 10, SqlFieldName = Meeting_HosterPost ];

/// 会议记录人
Property MeetingRecorder As CF.DHCINM.HR.Persons [ SqlColumnNumber = 11, SqlFieldName = Meeting_Recorder ];

/// 会议主题
Property MeetingTopic As %String [ SqlColumnNumber = 12, SqlFieldName = Meeting_Topic ];

/// 会议内容
Property MeetingContent As %String(MAXLEN = 1000) [ SqlColumnNumber = 13, SqlFieldName = Meeting_Content ];

/// 会议附件
Property MeetingFile As list Of %String [ SqlColumnNumber = 14, SqlFieldName = Meeting_File ];

/// 会议问题
Property MeetingQuestion As %String(MAXLEN = 1000) [ SqlColumnNumber = 15, SqlFieldName = Meeting_Question ];

/// 会议措施
Property MeetingStep As %String(MAXLEN = 1000) [ SqlColumnNumber = 16, SqlFieldName = Meeting_Step ];

/// 会议申请
Property MeetingApp As %String(MAXLEN = 1000) [ SqlColumnNumber = 17, SqlFieldName = Meeting_App ];

/// 会议落实评价 N:未落实 P:部分落实 Y:落实
Property MeetingAssess As %String(DISPLAYLIST = ",未落实,部分落实,落实", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",N,P,Y") [ SqlColumnNumber = 18, SqlFieldName = Meeting_Assess ];

/// 会议落实评价说明
Property MeetingReason As %String(MAXLEN = 1000) [ SqlColumnNumber = 19, SqlFieldName = Meeting_Reason ];

/// 会议落实评价日期
Property MeetingAssessDate As %Date [ SqlColumnNumber = 20, SqlFieldName = Meeting_AssessDate ];

/// 科护士长审核结果 N:未通过 P:部分通过 Y:通过
Property MeetingLStatus As %String(DISPLAYLIST = ",未通过,部分通过,通过", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",N,P,Y") [ SqlColumnNumber = 21, SqlFieldName = Meeting_LStatus ];

/// 科护士长审核人
Property MeetingLAuditor As %String [ SqlColumnNumber = 22, SqlFieldName = Meeting_LAuditor ];

/// 科护士长审核日期
Property MeetingLAuditeDate As %Date [ SqlColumnNumber = 23, SqlFieldName = Meeting_LAuditeDate ];

/// 科护士长审核意见
Property MeetingLReason As %String(MAXLEN = 1000) [ SqlColumnNumber = 24, SqlFieldName = Meeting_LReason ];

/// 护理部审核结果 N:未通过 P:部分通过 Y:通过
Property MeetingHStatus As %String(DISPLAYLIST = ",未通过,部分通过,通过", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",N,P,Y") [ SqlColumnNumber = 25, SqlFieldName = Meeting_HStatus ];

/// 护理部审核人
Property MeetingHAuditor As %String [ SqlColumnNumber = 26, SqlFieldName = Meeting_HAuditor ];

/// 护理部审核日期
Property MeetingHAuditeDate As %Date [ SqlColumnNumber = 27, SqlFieldName = Meeting_HAuditeDate ];

/// 护理部审核意见
Property MeetingHReason As %String(MAXLEN = 1000) [ SqlColumnNumber = 28, SqlFieldName = Meeting_HReason ];

/// 状态 N:保存 Y:提交 A:完成(完成状态取决于是否填写落实情况)
Property MeetingStatus As %String(DISPLAYLIST = ",保存,提交,完成", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",N,Y,A") [ SqlColumnNumber = 29, SqlFieldName = Meeting_Status ];

/// 当前进度 A:完成 NY:提请科护士长审核 LY:提请护理部审核
Property MeetingCurStep As %String(DISPLAYLIST = ",完成,提请科护士长审核,提请护理部审核", MAXLEN = 2, TRUNCATE = 1, VALUELIST = ",A,NY,LY") [ SqlColumnNumber = 30, SqlFieldName = Meeting_CurStep ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 31, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 32, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 33, SqlFieldName = Create_Time ];

Index Level On MeetingLevel;

Storage Default
{
<Data name="MgPatMeetingRecDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MeetingLevel</Value>
</Value>
<Value name="3">
<Value>MeetingDate</Value>
</Value>
<Value name="4">
<Value>MeetingTime</Value>
</Value>
<Value name="5">
<Value>MeetingLocation</Value>
</Value>
<Value name="6">
<Value>MeetingDepartment</Value>
</Value>
<Value name="7">
<Value>MeetingWard</Value>
</Value>
<Value name="8">
<Value>MeetingParticipant</Value>
</Value>
<Value name="9">
<Value>MeetingHoster</Value>
</Value>
<Value name="10">
<Value>MeetingHosterPost</Value>
</Value>
<Value name="11">
<Value>MeetingRecorder</Value>
</Value>
<Value name="12">
<Value>MeetingTopic</Value>
</Value>
<Value name="13">
<Value>MeetingContent</Value>
</Value>
<Value name="14">
<Value>MeetingFile</Value>
</Value>
<Value name="15">
<Value>MeetingQuestion</Value>
</Value>
<Value name="16">
<Value>MeetingStep</Value>
</Value>
<Value name="17">
<Value>MeetingApp</Value>
</Value>
<Value name="18">
<Value>MeetingAssess</Value>
</Value>
<Value name="19">
<Value>MeetingReason</Value>
</Value>
<Value name="20">
<Value>MeetingAssessDate</Value>
</Value>
<Value name="21">
<Value>MeetingLStatus</Value>
</Value>
<Value name="22">
<Value>MeetingLAuditor</Value>
</Value>
<Value name="23">
<Value>MeetingLAuditeDate</Value>
</Value>
<Value name="24">
<Value>MeetingLReason</Value>
</Value>
<Value name="25">
<Value>MeetingHStatus</Value>
</Value>
<Value name="26">
<Value>MeetingHAuditor</Value>
</Value>
<Value name="27">
<Value>MeetingHAuditeDate</Value>
</Value>
<Value name="28">
<Value>MeetingHReason</Value>
</Value>
<Value name="29">
<Value>MeetingStatus</Value>
</Value>
<Value name="30">
<Value>MeetingCurStep</Value>
</Value>
<Value name="31">
<Value>Creator</Value>
</Value>
<Value name="32">
<Value>CreateDate</Value>
</Value>
<Value name="33">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HB.MgPatMeetingRecD</DataLocation>
<DefaultData>MgPatMeetingRecDefaultData</DefaultData>
<IdLocation>^DHCINM.HB.MgPatMeetingRecD</IdLocation>
<IndexLocation>^DHCINM.HB.MgPatMeetingRecI</IndexLocation>
<StreamLocation>^DHCINM.HB.MgPatMeetingRecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
