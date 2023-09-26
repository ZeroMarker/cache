/// creator: xbl
/// createdate: 20170825
/// description:排班休假代码
Class DHCNMG.DB.MgArgHoliday Extends %Persistent
{

Relationship ChildSub As DHCNMG.DB.MgArgHolidaySub [ Cardinality = children, Inverse = Parref ];

/// 代码
Property HolidayCode As %String [ SqlColumnNumber = 2, SqlFieldName = Holiday_Code ];

/// 描述
Property HolidayDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Holiday_Desc ];

/// 简称 
Property HolidayShort As %String [ SqlColumnNumber = 4, SqlFieldName = Holiday_Short ];

/// 折合时长
Property HolidayHour As %Float [ SqlColumnNumber = 5, SqlFieldName = Holiday_Hour ];

/// 计数
Property CountFlag As %String [ SqlColumnNumber = 6, SqlFieldName = Count_Flag ];

/// 计岗
Property PostFlag As %String [ SqlColumnNumber = 7, SqlFieldName = Post_Flag ];

/// 计结余
Property SurplusFlag As %String [ SqlColumnNumber = 8, SqlFieldName = Surplus_Flag ];

/// 周末计岗
Property WeekPostFlag As %String [ SqlColumnNumber = 9, SqlFieldName = WeekPost_Flag ];

/// 周末计结余
Property WeekSurplusFlag As %String [ SqlColumnNumber = 10, SqlFieldName = WeekSurplus_Flag ];

/// 跳过周末
Property JumpWeekFlag As %String [ SqlColumnNumber = 11, SqlFieldName = JumpWeek_Flag ];

/// 跳过节假日
Property JumpHolidayFlag As %String [ SqlColumnNumber = 12, SqlFieldName = JumpHoliday_Flag ];

/// 跨年清零
Property YearClearFlag As %String [ SqlColumnNumber = 13, SqlFieldName = YearClear_Flag ];

/// 状态
Property HolidayStatus As %String [ SqlColumnNumber = 14, SqlFieldName = Holiday_Status ];

/// 优先级
Property HolidayLevel As %Integer [ SqlColumnNumber = 15, SqlFieldName = Holiday_Level ];

/// 字体颜色
Property HolidayFontColor As %String [ SqlColumnNumber = 16, SqlFieldName = Holiday_FontColor ];

/// 背景颜色
Property HolidayBgColor As %String [ SqlColumnNumber = 17, SqlFieldName = Holiday_BgColor ];

Index Code On HolidayCode;

Storage Default
{
<Data name="MgArgHolidayDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HolidayCode</Value>
</Value>
<Value name="3">
<Value>HolidayDesc</Value>
</Value>
<Value name="4">
<Value>HolidayShort</Value>
</Value>
<Value name="5">
<Value>HolidayHour</Value>
</Value>
<Value name="6">
<Value>CountFlag</Value>
</Value>
<Value name="7">
<Value>PostFlag</Value>
</Value>
<Value name="8">
<Value>SurplusFlag</Value>
</Value>
<Value name="9">
<Value>WeekPostFlag</Value>
</Value>
<Value name="10">
<Value>WeekSurplusFlag</Value>
</Value>
<Value name="11">
<Value>JumpWeekFlag</Value>
</Value>
<Value name="12">
<Value>JumpHolidayFlag</Value>
</Value>
<Value name="13">
<Value>YearClearFlag</Value>
</Value>
<Value name="14">
<Value>HolidayStatus</Value>
</Value>
<Value name="15">
<Value>HolidayLevel</Value>
</Value>
<Value name="16">
<Value>HolidayFontColor</Value>
</Value>
<Value name="17">
<Value>HolidayBgColor</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgArgHolidayD</DataLocation>
<DefaultData>MgArgHolidayDefaultData</DefaultData>
<IdLocation>^DHCNMG.DB.MgArgHolidayD</IdLocation>
<IndexLocation>^DHCNMG.DB.MgArgHolidayI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgArgHolidayS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
