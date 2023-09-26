/// creator: xbl
/// createdate: 20170824
/// description: 病区排班班次
Class DHCNMG.DB.MgArgWardPost Extends %Persistent
{

/// 排班名称
Property PostDesc As %String [ SqlColumnNumber = 2, SqlFieldName = Post_Desc ];

/// 病区
Property WardDR As DHCNMG.DB.MgWard [ Required, SqlColumnNumber = 3, SqlFieldName = Ward_DR ];

/// 所属分类
Property PostDR As DHCNMG.DB.MgArgPost [ Required, SqlColumnNumber = 4, SqlFieldName = Post_DR ];

/// 班次
Property PostClass As %String [ SqlColumnNumber = 5, SqlFieldName = Post_Class ];

/// 一阶段开始时间
Property PostStTime1 As %String [ SqlColumnNumber = 6, SqlFieldName = Post_StTime1 ];

/// 一阶段结束时间
Property PostEndTime1 As %String [ SqlColumnNumber = 7, SqlFieldName = Post_EndTime1 ];

/// 二阶段开始时间
Property PostStTime2 As %String [ SqlColumnNumber = 8, SqlFieldName = Post_StTime2 ];

/// 二阶段结束时间
Property PostEndTime2 As %String [ SqlColumnNumber = 9, SqlFieldName = Post_EndTime2 ];

/// 总分钟数
Property PostMinutes As %String [ SqlColumnNumber = 10, SqlFieldName = Post_Minutes ];

/// 当日时长
Property PostDayMinutes As %String [ SqlColumnNumber = 11, SqlFieldName = Post_DayMinutes ];

/// 次日时长
Property PostNextMinutes As %String [ SqlColumnNumber = 12, SqlFieldName = Post_NextMinutes ];

/// 说明
Property PostRemark As %String(MAXLEN = 1000) [ SqlColumnNumber = 13, SqlFieldName = Post_Remark ];

/// 显示顺序
Property PostSort As %Integer [ SqlColumnNumber = 14, SqlFieldName = Post_Sort ];

/// 创建日期
Property PostCrtDate As %Date [ SqlColumnNumber = 15, SqlFieldName = Post_CrtDate ];

/// 创建时间
Property PostCrtTime As %Time [ SqlColumnNumber = 16, SqlFieldName = Post_CrtTime ];

/// 创建人
Property PostCrtUser As DHCNMG.HR.MgPersons [ SqlColumnNumber = 17, SqlFieldName = Post_CrtUser ];

/// 三阶段开始时间
Property PostStTime3 As %String [ SqlColumnNumber = 18, SqlFieldName = Post_StTime3 ];

/// 三阶段结束时间
Property PostEndTime3 As %String [ SqlColumnNumber = 19, SqlFieldName = Post_EndTime3 ];

/// 班次分类
Property PostCategory As %String [ SqlColumnNumber = 20, SqlFieldName = Post_Category ];

/// 班种系数
Property PostFactor As %String [ SqlColumnNumber = 21, SqlFieldName = Post_Factor ];

Index Ward On WardDR;

Index Post On PostDR;

Index WardPost On (WardDR, PostDR);

Index WardSort On (WardDR, PostSort);

Storage Default
{
<Data name="MgArgWardPostDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WardDR</Value>
</Value>
<Value name="3">
<Value>PostDR</Value>
</Value>
<Value name="4">
<Value>PostSort</Value>
</Value>
<Value name="5">
<Value>FontColor</Value>
</Value>
<Value name="6">
<Value>BgColor</Value>
</Value>
<Value name="7">
<Value>PostHour</Value>
</Value>
<Value name="8">
<Value>PostNightHour</Value>
</Value>
<Value name="9">
<Value>PostAttendDay</Value>
</Value>
<Value name="10">
<Value>PostSaisonal</Value>
</Value>
<Value name="11">
<Value>PostLeaveFlag</Value>
</Value>
<Value name="12">
<Value>PostCalculateType</Value>
</Value>
<Value name="13">
<Value>PostLeaveDefault</Value>
</Value>
<Value name="14">
<Value>PostPeriod1</Value>
</Value>
<Value name="15">
<Value>PostStTime1</Value>
</Value>
<Value name="16">
<Value>PostEndTime1</Value>
</Value>
<Value name="17">
<Value>PostPeriod2</Value>
</Value>
<Value name="18">
<Value>PostStTime2</Value>
</Value>
<Value name="19">
<Value>PostEndTime2</Value>
</Value>
<Value name="20">
<Value>PostPeriod3</Value>
</Value>
<Value name="21">
<Value>PostStTime3</Value>
</Value>
<Value name="22">
<Value>PostEndTime3</Value>
</Value>
<Value name="23">
<Value>PostHour1</Value>
</Value>
<Value name="24">
<Value>PostHour2</Value>
</Value>
<Value name="25">
<Value>PostDesc</Value>
</Value>
<Value name="26">
<Value>PostType</Value>
</Value>
<Value name="27">
<Value>PostMinutes</Value>
</Value>
<Value name="28">
<Value>PostDayMinutes</Value>
</Value>
<Value name="29">
<Value>PostNextMinutes</Value>
</Value>
<Value name="30">
<Value>PostRemark</Value>
</Value>
<Value name="31">
<Value>PostClass</Value>
</Value>
<Value name="32">
<Value>PostCrtDate</Value>
</Value>
<Value name="33">
<Value>PostCrtTime</Value>
</Value>
<Value name="34">
<Value>PostCrtUser</Value>
</Value>
<Value name="35">
<Value>PostCategory</Value>
</Value>
<Value name="36">
<Value>PostFactor</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgArgWardPostD</DataLocation>
<DefaultData>MgArgWardPostDefaultData</DefaultData>
<IdLocation>^DHCNMG.DB.MgArgWardPostD</IdLocation>
<IndexLocation>^DHCNMG.DB.MgArgWardPostI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgArgWardPostS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
