/// Creater:wangpf
/// Descriptions:质控活动记录
/// Date:2020-07-16
Class DHCINM.HB.MgQualActivity Extends %Persistent
{

/// 活动病区
Property ActivityWard As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 2, SqlFieldName = Activity_Ward ];

/// 活动类型 1:质控会议 2:质量讲评
Property ActivityType As %Integer [ SqlColumnNumber = 3, SqlFieldName = Activity_Type ];

/// 活动日期
Property ActivityDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Activity_Date ];

/// 活动主持人
Property ActivityHost As CF.DHCINM.HR.Persons [ SqlColumnNumber = 5, SqlFieldName = Activity_Host ];

/// 活动记录人
Property ActivityRecorder As CF.DHCINM.HR.Persons [ SqlColumnNumber = 6, SqlFieldName = Activity_Recorder ];

/// 活动参与人
Property ActivityParticipant As list Of %String [ SqlColumnNumber = 7, SqlFieldName = Activity_Participant ];

/// 活动主题
Property ActivityTopic As %String [ SqlColumnNumber = 8, SqlFieldName = Activity_Topic ];

/// 活动记录
Property ActivityContent As %String(MAXLEN = 10000) [ SqlColumnNumber = 9, SqlFieldName = Activity_Content ];

/// 状态 N:保存 Y:提交
Property ActivityStatus As %String(DISPLAYLIST = ",保存,提交", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",N,Y") [ SqlColumnNumber = 10, SqlFieldName = Activity_Status ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 11, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 12, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 13, SqlFieldName = Create_Time ];

/// 活动记录
Property ActivityContentExt As %Stream.GlobalCharacter [ SqlColumnNumber = 14, SqlFieldName = Activity_ContentExt ];

Index ToolIndex On (ActivityDate, ActivityWard, ActivityType, ActivityStatus);

Storage Default
{
<Data name="MgQualActivityDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ActivityWard</Value>
</Value>
<Value name="3">
<Value>ActivityType</Value>
</Value>
<Value name="4">
<Value>ActivityDate</Value>
</Value>
<Value name="5">
<Value>ActivityHost</Value>
</Value>
<Value name="6">
<Value>ActivityRecorder</Value>
</Value>
<Value name="7">
<Value>ActivityParticipant</Value>
</Value>
<Value name="8">
<Value>ActivityTopic</Value>
</Value>
<Value name="9">
<Value>ActivityContent</Value>
</Value>
<Value name="10">
<Value>ActivityStatus</Value>
</Value>
<Value name="11">
<Value>Creator</Value>
</Value>
<Value name="12">
<Value>CreateDate</Value>
</Value>
<Value name="13">
<Value>CreateTime</Value>
</Value>
<Value name="14">
<Value>ActivityContentExt</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HB.MgQualActivityD</DataLocation>
<DefaultData>MgQualActivityDefaultData</DefaultData>
<IdLocation>^DHCINM.HB.MgQualActivityD</IdLocation>
<IndexLocation>^DHCINM.HB.MgQualActivityI</IndexLocation>
<StreamLocation>^DHCINM.HB.MgQualActivityS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
