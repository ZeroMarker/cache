/// Description:节假日设置
/// Creator:gzj
/// Date:2018-03-26
Class DHCNMG.DB.MgHolidaySet Extends %Persistent
{

/// 年份
Property HolidayYear As %Integer [ SqlColumnNumber = 2, SqlFieldName = Holiday_Year ];

/// 节假日ID 指向公共代码子表ID
Property HolidayID As DHCNMG.DB.MgSetCodeSub [ SqlColumnNumber = 3, SqlFieldName = Holiday_ID ];

/// 日期段
Property HolidayDate As %String [ SqlColumnNumber = 4, SqlFieldName = HolidayDate ];

Property HolidayFlag As %String [ SqlColumnNumber = 5, SqlFieldName = Holiday_Flag ];

Index code On (HolidayYear, HolidayID);

Index flag On (HolidayYear, HolidayID, HolidayDate);

Storage Default
{
<Data name="MgHolidaySetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HolidayYear</Value>
</Value>
<Value name="3">
<Value>HolidayID</Value>
</Value>
<Value name="4">
<Value>HolidayDate</Value>
</Value>
<Value name="5">
<Value>HolidayFlag</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgHolidaySetD</DataLocation>
<DefaultData>MgHolidaySetDefaultData</DefaultData>
<IdLocation>^DHCNMG.DB.MgHolidaySetD</IdLocation>
<IndexLocation>^DHCNMG.DB.MgHolidaySetI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgHolidaySetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
