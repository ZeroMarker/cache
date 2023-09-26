/// Creater:wangpf
/// Descriptions:病区常规会议记录
/// Date:2020-07-11
Class DHCINM.HB.MgWardMeetingRec Extends %Persistent
{

/// 会议科室
Property MeetingWard As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 2, SqlFieldName = Meeting_Ward ];

/// 会议类型
Property MeetingType As %String(DISPLAYLIST = ",月例会,周例会,晨例会", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",M,W,D") [ SqlColumnNumber = 3, SqlFieldName = Meeting_Type ];

/// 会议日期
Property MeetingDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Meeting_Date ];

/// 会议时间
Property MeetingTime As %Time [ SqlColumnNumber = 5, SqlFieldName = Meeting_Time ];

/// 会议地点
Property MeetingLocation As %String [ SqlColumnNumber = 6, SqlFieldName = Meeting_Location ];

/// 会议主持人
Property MeetingHoster As CF.DHCINM.HR.Persons [ SqlColumnNumber = 7, SqlFieldName = Meeting_Hoster ];

/// 会议参与人
Property MeetingParticipant As list Of %String [ SqlColumnNumber = 8, SqlFieldName = Meeting_Participant ];

/// 会议人员签到
Property MeetingSign As list Of %String [ SqlColumnNumber = 9, SqlFieldName = Meeting_Sign ];

/// 会议内容
Property MeetingContent As %String(MAXLEN = 1000) [ SqlColumnNumber = 10, SqlFieldName = Meeting_Content ];

/// 状态 N:保存 Y:发布 A:完成
Property MeetingStatus As %String(DISPLAYLIST = ",保存,发布,完成", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",N,Y,A") [ SqlColumnNumber = 11, SqlFieldName = Meeting_Status ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 12, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 13, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 14, SqlFieldName = Create_Time ];

Index ToolIndex On (MeetingDate, MeetingWard, MeetingType, MeetingStatus);

Storage Default
{
<Data name="MgWardMeetingRecDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MeetingWard</Value>
</Value>
<Value name="3">
<Value>MeetingType</Value>
</Value>
<Value name="4">
<Value>MeetingDate</Value>
</Value>
<Value name="5">
<Value>MeetingTime</Value>
</Value>
<Value name="6">
<Value>MeetingLocation</Value>
</Value>
<Value name="7">
<Value>MeetingHoster</Value>
</Value>
<Value name="8">
<Value>MeetingParticipant</Value>
</Value>
<Value name="9">
<Value>MeetingSign</Value>
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
</Data>
<DataLocation>^DHCINM.HB.MgWardMeetingRecD</DataLocation>
<DefaultData>MgWardMeetingRecDefaultData</DefaultData>
<IdLocation>^DHCINM.HB.MgWardMeetingRecD</IdLocation>
<IndexLocation>^DHCINM.HB.MgWardMeetingRecI</IndexLocation>
<StreamLocation>^DHCINM.HB.MgWardMeetingRecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
