/// Creater:wangpf
/// Descriptions:科室大记事记录
/// Date:2020-07-11
Class DHCINM.HB.MgLocEventRec Extends %Persistent
{

/// 会议病区
Property EventWard As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 2, SqlFieldName = Event_Ward ];

/// 会议日期
Property EventDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Event_Date ];

/// 会议主题
Property EventTopic As %String [ SqlColumnNumber = 4, SqlFieldName = Event_Topic ];

/// 会议内容
Property EventContent As %String(MAXLEN = 10000) [ SqlColumnNumber = 5, SqlFieldName = Event_Content ];

/// 状态 N:保存 Y:提交
Property EventStatus As %String(DISPLAYLIST = ",保存,提交", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",N,Y") [ SqlColumnNumber = 6, SqlFieldName = Event_Status ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 7, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 9, SqlFieldName = Create_Time ];

/// 会议内容
Property EventContentExt As %Stream.GlobalCharacter [ SqlColumnNumber = 10, SqlFieldName = Event_ContentExt ];

Index ToolIndex On (EventDate, EventWard, EventStatus);

Storage Default
{
<Data name="MgLocEventRecDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EventWard</Value>
</Value>
<Value name="3">
<Value>EventDate</Value>
</Value>
<Value name="4">
<Value>EventTopic</Value>
</Value>
<Value name="5">
<Value>EventContent</Value>
</Value>
<Value name="6">
<Value>EventStatus</Value>
</Value>
<Value name="7">
<Value>Creator</Value>
</Value>
<Value name="8">
<Value>CreateDate</Value>
</Value>
<Value name="9">
<Value>CreateTime</Value>
</Value>
<Value name="10">
<Value>EventContentExt</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HB.MgLocEventRecD</DataLocation>
<DefaultData>MgLocEventRecDefaultData</DefaultData>
<IdLocation>^DHCINM.HB.MgLocEventRecD</IdLocation>
<IndexLocation>^DHCINM.HB.MgLocEventRecI</IndexLocation>
<StreamLocation>^DHCINM.HB.MgLocEventRecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
