/// Creater:wangpf
/// Descriptions:公休会记录
/// Date:2020-07-09
Class DHCINM.HB.MgRecessRecord Extends %Persistent
{

/// 会议级别 H:护理部 L:科室 W:病区
Property RecessLevel As %String(DISPLAYLIST = ",护理部,科室,病区", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",H,L,W") [ SqlColumnNumber = 2, SqlFieldName = Recess_Level ];

/// 会议日期
Property RecessDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Recess_Date ];

/// 会议时间
Property RecessTime As %Time [ SqlColumnNumber = 4, SqlFieldName = Recess_Time ];

/// 会议地点
Property RecessLocation As %String [ SqlColumnNumber = 5, SqlFieldName = Recess_Location ];

/// 会议参与部门
Property RecessDepartment As %String [ SqlColumnNumber = 6, SqlFieldName = Recess_Department ];

/// 会议参与病区及人数
Property RecessWard As list Of %String [ SqlColumnNumber = 7, SqlFieldName = Recess_Ward ];

/// 会议参与人
Property RecessParticipant As list Of %String [ SqlColumnNumber = 8, SqlFieldName = Recess_Participant ];

/// 会议主持人
Property RecessHoster As CF.DHCINM.HR.Persons [ SqlColumnNumber = 9, SqlFieldName = Recess_Hoster ];

/// 会议主持人职务
Property RecessHosterPost As CT.DHCINM.DB.MgSetCodeSub [ SqlColumnNumber = 10, SqlFieldName = Recess_HosterPost ];

/// 会议记录人
Property RecessRecorder As CF.DHCINM.HR.Persons [ SqlColumnNumber = 11, SqlFieldName = Recess_Recorder ];

/// 会议主题
Property RecessTopic As %String [ SqlColumnNumber = 12, SqlFieldName = Recess_Topic ];

/// 会议内容
Property RecessContent As %String(MAXLEN = 1000) [ SqlColumnNumber = 13, SqlFieldName = Recess_Content ];

/// 会议附件
Property RecessFile As list Of %String [ SqlColumnNumber = 14, SqlFieldName = Recess_File ];

/// 会议问题
Property RecessQuestion As %String(MAXLEN = 1000) [ SqlColumnNumber = 15, SqlFieldName = Recess_Question ];

/// 会议措施
Property RecessStep As %String(MAXLEN = 1000) [ SqlColumnNumber = 16, SqlFieldName = Recess_Step ];

/// 会议申请
Property RecessApp As %String(MAXLEN = 1000) [ SqlColumnNumber = 17, SqlFieldName = Recess_App ];

/// 会议落实评价 N:未落实 P:部分落实 Y:落实
Property RecessAssess As %String(DISPLAYLIST = ",未落实,部分落实,落实", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",N,P,Y") [ SqlColumnNumber = 18, SqlFieldName = Recess_Assess ];

/// 会议落实评价说明
Property RecessReason As %String(MAXLEN = 1000) [ SqlColumnNumber = 19, SqlFieldName = Recess_Reason ];

/// 会议落实评价日期
Property RecessAssessDate As %Date [ SqlColumnNumber = 20, SqlFieldName = Recess_AssessDate ];

/// 科护士长审核结果 N:未通过 P:部分通过 Y:通过
Property RecessLStatus As %String(DISPLAYLIST = ",未通过,部分通过,通过", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",N,P,Y") [ SqlColumnNumber = 21, SqlFieldName = Recess_LStatus ];

/// 科护士长审核人
Property RecessLAuditor As %String [ SqlColumnNumber = 22, SqlFieldName = Recess_LAuditor ];

/// 科护士长审核日期
Property RecessLAuditeDate As %Date [ SqlColumnNumber = 23, SqlFieldName = Recess_LAuditeDate ];

/// 科护士长审核意见
Property RecessLReason As %String(MAXLEN = 1000) [ SqlColumnNumber = 24, SqlFieldName = Recess_LReason ];

/// 护理部审核结果 N:未通过 P:部分通过 Y:通过
Property RecessHStatus As %String(DISPLAYLIST = ",未通过,部分通过,通过", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",N,P,Y") [ SqlColumnNumber = 25, SqlFieldName = Recess_HStatus ];

/// 护理部审核人
Property RecessHAuditor As %String [ SqlColumnNumber = 26, SqlFieldName = Recess_HAuditor ];

/// 护理部审核日期
Property RecessHAuditeDate As %Date [ SqlColumnNumber = 27, SqlFieldName = Recess_HAuditeDate ];

/// 护理部审核意见
Property RecessHReason As %String(MAXLEN = 1000) [ SqlColumnNumber = 28, SqlFieldName = Recess_HReason ];

/// 状态 N:保存 Y:提交 A:完成(完成状态取决于是否填写落实情况)
Property RecessStatus As %String(DISPLAYLIST = ",保存,提交,完成", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",N,Y,A") [ SqlColumnNumber = 29, SqlFieldName = Recess_Status ];

/// 当前进度 A:完成 NY:提请科护士长审核 LY:提请护理部审核
Property RecessCurStep As %String(DISPLAYLIST = ",完成,提请科护士长审核,提请护理部审核", MAXLEN = 2, TRUNCATE = 1, VALUELIST = ",A,NY,LY") [ SqlColumnNumber = 30, SqlFieldName = Recess_CurStep ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 31, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 32, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 33, SqlFieldName = Create_Time ];

/// 会议参与人（输入框）
Property RecessParticipantInput As %String(MAXLEN = 300) [ SqlColumnNumber = 34, SqlFieldName = Recess_ParticipantInput ];

Index Level On RecessLevel;

Storage Default
{
<Data name="MgRecessRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RecessLevel</Value>
</Value>
<Value name="3">
<Value>RecessDate</Value>
</Value>
<Value name="4">
<Value>RecessTime</Value>
</Value>
<Value name="5">
<Value>RecessLocation</Value>
</Value>
<Value name="6">
<Value>RecessDepartment</Value>
</Value>
<Value name="7">
<Value>RecessWard</Value>
</Value>
<Value name="8">
<Value>RecessParticipant</Value>
</Value>
<Value name="9">
<Value>RecessHoster</Value>
</Value>
<Value name="10">
<Value>RecessHosterPost</Value>
</Value>
<Value name="11">
<Value>RecessRecorder</Value>
</Value>
<Value name="12">
<Value>RecessTopic</Value>
</Value>
<Value name="13">
<Value>RecessContent</Value>
</Value>
<Value name="14">
<Value>RecessFile</Value>
</Value>
<Value name="15">
<Value>RecessQuestion</Value>
</Value>
<Value name="16">
<Value>RecessStep</Value>
</Value>
<Value name="17">
<Value>RecessApp</Value>
</Value>
<Value name="18">
<Value>RecessAssess</Value>
</Value>
<Value name="19">
<Value>RecessReason</Value>
</Value>
<Value name="20">
<Value>RecessAssessDate</Value>
</Value>
<Value name="21">
<Value>RecessLStatus</Value>
</Value>
<Value name="22">
<Value>RecessLAuditor</Value>
</Value>
<Value name="23">
<Value>RecessLAuditeDate</Value>
</Value>
<Value name="24">
<Value>RecessLReason</Value>
</Value>
<Value name="25">
<Value>RecessHStatus</Value>
</Value>
<Value name="26">
<Value>RecessHAuditor</Value>
</Value>
<Value name="27">
<Value>RecessHAuditeDate</Value>
</Value>
<Value name="28">
<Value>RecessHReason</Value>
</Value>
<Value name="29">
<Value>RecessStatus</Value>
</Value>
<Value name="30">
<Value>RecessCurStep</Value>
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
<Value name="34">
<Value>RecessParticipantInput</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HB.MgRecessRecordD</DataLocation>
<DefaultData>MgRecessRecordDefaultData</DefaultData>
<IdLocation>^DHCINM.HB.MgRecessRecordD</IdLocation>
<IndexLocation>^DHCINM.HB.MgRecessRecordI</IndexLocation>
<StreamLocation>^DHCINM.HB.MgRecessRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
