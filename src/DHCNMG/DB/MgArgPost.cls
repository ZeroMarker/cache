/// creator:xbl
/// createdate:20170823
/// description:排班班次代码表
Class DHCNMG.DB.MgArgPost Extends %Persistent
{

/// 代码
Property PostCode As %String [ SqlColumnNumber = 2, SqlFieldName = Post_Code ];

/// 描述
Property PostDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Post_Desc ];

/// 类型
Property PostType As %String [ SqlColumnNumber = 4, SqlFieldName = Post_Type ];

/// 休假时间
Property HolidayTime As %String [ SqlColumnNumber = 5, SqlFieldName = Holiday_Time ];

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

/// 应用类型
Property PostUseType As %String [ SqlColumnNumber = 13, SqlFieldName = Post_UseType ];

/// 应用范围
Property PostUseLimit As %String(MAXLEN = 2000) [ SqlColumnNumber = 14, SqlFieldName = Post_UseLimit ];

/// 字体颜色
Property PostFontColor As %String [ SqlColumnNumber = 15, SqlFieldName = Post_FontColor ];

/// 背景颜色
Property PostBgColor As %String [ SqlColumnNumber = 16, SqlFieldName = Post_BgColor ];

/// 说明
Property PostRemark As %String(MAXLEN = 1000) [ SqlColumnNumber = 17, SqlFieldName = Post_Remark ];

/// 状态
Property PostStatus As %String [ SqlColumnNumber = 18, SqlFieldName = Post_Status ];

/// 创建日期
Property PostCrtDate As %Date [ SqlColumnNumber = 19, SqlFieldName = Post_CrtDate ];

/// 创建时间
Property PostCrtTime As %Time [ SqlColumnNumber = 20, SqlFieldName = Post_CrtTime ];

/// 创建人
Property PostCrtUser As %String [ SqlColumnNumber = 21, SqlFieldName = Post_CrtUser ];

/// 三阶段开始时间
Property PostStTime3 As %String [ SqlColumnNumber = 22, SqlFieldName = Post_StTime3 ];

/// 三阶段结束时间
Property PostEndTime3 As %String [ SqlColumnNumber = 23, SqlFieldName = Post_EndTime3 ];

/// 班次分类
Property PostCategory As %String [ SqlColumnNumber = 24, SqlFieldName = Post_Category ];

/// 班次级别
Property PostLevel As %String [ SqlColumnNumber = 25, SqlFieldName = Post_Level ];

Property PostSort As %Integer [ SqlColumnNumber = 26, SqlFieldName = Post_Sort ];

Index Desc On PostDesc;

Index Type On PostType;

Index Sort On PostSort;

Storage Default
{
<Data name="MgArgPostDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PostCode</Value>
</Value>
<Value name="3">
<Value>PostDesc</Value>
</Value>
<Value name="4">
<Value>PostShort</Value>
</Value>
<Value name="5">
<Value>PostType</Value>
</Value>
<Value name="6">
<Value>PostPeriod</Value>
</Value>
<Value name="7">
<Value>PostHour</Value>
</Value>
<Value name="8">
<Value>PostNightHour</Value>
</Value>
<Value name="9">
<Value>PostAttendType</Value>
</Value>
<Value name="10">
<Value>PostAttendDay</Value>
</Value>
<Value name="11">
<Value>PostUseType</Value>
</Value>
<Value name="12">
<Value>PostSaisonal</Value>
</Value>
<Value name="13">
<Value>PostLeaveType</Value>
</Value>
<Value name="14">
<Value>PostCalculateType</Value>
</Value>
<Value name="15">
<Value>PostLeaveDefault</Value>
</Value>
<Value name="16">
<Value>PostFontColor</Value>
</Value>
<Value name="17">
<Value>PostBgColor</Value>
</Value>
<Value name="18">
<Value>PostCountType</Value>
</Value>
<Value name="19">
<Value>PostPeriod1</Value>
</Value>
<Value name="20">
<Value>PostStTime1</Value>
</Value>
<Value name="21">
<Value>PostEndTime1</Value>
</Value>
<Value name="22">
<Value>PostPeriod2</Value>
</Value>
<Value name="23">
<Value>PostStTime2</Value>
</Value>
<Value name="24">
<Value>PostEndTime2</Value>
</Value>
<Value name="25">
<Value>PostPeriod3</Value>
</Value>
<Value name="26">
<Value>PostStTime3</Value>
</Value>
<Value name="27">
<Value>PostEndTime3</Value>
</Value>
<Value name="28">
<Value>PostStatus</Value>
</Value>
<Value name="29">
<Value>PostLeaveFlag</Value>
</Value>
<Value name="30">
<Value>PostLevel</Value>
</Value>
<Value name="31">
<Value>PostUseLimit</Value>
</Value>
<Value name="32">
<Value>HolidayTime</Value>
</Value>
<Value name="33">
<Value>PostMinutes</Value>
</Value>
<Value name="34">
<Value>PostDayMinutes</Value>
</Value>
<Value name="35">
<Value>PostNextMinutes</Value>
</Value>
<Value name="36">
<Value>PostCrtDate</Value>
</Value>
<Value name="37">
<Value>PostCrtTime</Value>
</Value>
<Value name="38">
<Value>PostCrtUser</Value>
</Value>
<Value name="39">
<Value>PostRemark</Value>
</Value>
<Value name="40">
<Value>PostCategory</Value>
</Value>
<Value name="41">
<Value>PostSort</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgArgPostD</DataLocation>
<DefaultData>MgArgPostDefaultData</DefaultData>
<IdLocation>^DHCNMG.DB.MgArgPostD</IdLocation>
<IndexLocation>^DHCNMG.DB.MgArgPostI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgArgPostS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
