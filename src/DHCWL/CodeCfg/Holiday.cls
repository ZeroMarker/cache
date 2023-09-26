/// 节假日维护
Class DHCWL.CodeCfg.Holiday Extends (%Persistent, DHCWL.ABSCodeCFG) [ ClassType = persistent, Inheritance = right, SqlTableName = DHCWLCodeCfgHoliday ]
{

/// 节假日
Property HolidayName As %Date [ SqlColumnNumber = 2, SqlFieldName = Holiday_Name ];

/// 类型
Property HolidayType As %String [ SqlColumnNumber = 3, SqlFieldName = Holiday_Type ];

/// 时段
Property HolidayAmOrPm As %String [ SqlColumnNumber = 4, SqlFieldName = Holiday_AmOrPm ];

/// 更新日期
Property HolidayUpdate As %String [ SqlColumnNumber = 5, SqlFieldName = Holiday_Update ];

Index Holiday On (HolidayName, HolidayType, HolidayAmOrPm);

Index HolidayType On (HolidayType, HolidayName, HolidayAmOrPm);

///       DHCWL_CodeCfg.DHCWLCodeCfgHoliday   d ##class(DHCWL.CodeCfg.Holiday).%BuildIndices()

Storage Default
{
<Data name="HolidayDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HolidayName</Value>
</Value>
<Value name="3">
<Value>HolidayType</Value>
</Value>
<Value name="4">
<Value>HolidayAmOrPm</Value>
</Value>
<Value name="5">
<Value>HolidayUpdate</Value>
</Value>
</Data>
<DataLocation>^DHCWL.CodeCfg.HolidayD</DataLocation>
<DefaultData>HolidayDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.CodeCfg.HolidayD</IdLocation>
<IndexLocation>^DHCWL.CodeCfg.HolidayI</IndexLocation>
<StreamLocation>^DHCWL.CodeCfg.HolidayS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
