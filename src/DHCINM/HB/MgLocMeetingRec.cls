/// Creater:wangpf
/// Descriptions:科务会记录
/// Date:2020-07-10
Class DHCINM.HB.MgLocMeetingRec Extends %Persistent
{

/// 会议科室
Property MeetingLoc As CF.DHCINM.DB.MgWardLoc [ SqlColumnNumber = 2, SqlFieldName = Meeting_Loc ];

/// 会议日期
Property MeetingDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Meeting_Date ];

/// 会议时间
Property MeetingTime As %Time [ SqlColumnNumber = 4, SqlFieldName = Meeting_Time ];

/// 会议地点
Property MeetingLocation As %String [ SqlColumnNumber = 5, SqlFieldName = Meeting_Location ];

/// 会议主持人
Property MeetingHoster As CF.DHCINM.HR.Persons [ SqlColumnNumber = 6, SqlFieldName = Meeting_Hoster ];

/// 会议记录人
Property MeetingRecorder As CF.DHCINM.HR.Persons [ SqlColumnNumber = 7, SqlFieldName = Meeting_Recorder ];

/// 会议参与人
Property MeetingParticipant As list Of %String [ SqlColumnNumber = 8, SqlFieldName = Meeting_Participant ];

/// 会议主题
Property MeetingTopic As %String [ SqlColumnNumber = 9, SqlFieldName = Meeting_Topic ];

/// 会议内容
Property MeetingContent As %String(MAXLEN = 10000) [ SqlColumnNumber = 10, SqlFieldName = Meeting_Content ];

/// 状态 N:保存 Y:提交
Property MeetingStatus As %String(DISPLAYLIST = ",保存,提交", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",N,Y") [ SqlColumnNumber = 11, SqlFieldName = Meeting_Status ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 12, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 13, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 14, SqlFieldName = Create_Time ];

/// 会议内容
Property MeetingContentExt As %Stream.GlobalCharacter [ SqlColumnNumber = 15, SqlFieldName = Meeting_ContentExt ];

Index ToolIndex On (MeetingDate, MeetingLoc, MeetingStatus);

Storage Default
{
<Data name="MgLocMeetingRecDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MeetingLoc</Value>
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
<Value>MeetingHoster</Value>
</Value>
<Value name="7">
<Value>MeetingRecorder</Value>
</Value>
<Value name="8">
<Value>MeetingParticipant</Value>
</Value>
<Value name="9">
<Value>MeetingTopic</Value>
</Value>
<Value name="10">
<Value>MeetingContent</Value>
</Value>
<Value name="11">
<Value>MeetingStatus</Value>
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
<Value>MeetingContentExt</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HB.MgLocMeetingRecD</DataLocation>
<DefaultData>MgLocMeetingRecDefaultData</DefaultData>
<IdLocation>^DHCINM.HB.MgLocMeetingRecD</IdLocation>
<IndexLocation>^DHCINM.HB.MgLocMeetingRecI</IndexLocation>
<StreamLocation>^DHCINM.HB.MgLocMeetingRecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
