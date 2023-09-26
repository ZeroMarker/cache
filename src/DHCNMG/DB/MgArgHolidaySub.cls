/// creator:xbl
/// createdate:20170828
/// description:休假标准
Class DHCNMG.DB.MgArgHolidaySub Extends %Persistent
{

Relationship Parref As DHCNMG.DB.MgArgHoliday [ Cardinality = parent, Inverse = ChildSub ];

/// 代码
Property SubCode As %String [ SqlColumnNumber = 4, SqlFieldName = Sub_Code ];

/// 描述
Property SubDesc As %String [ SqlColumnNumber = 5, SqlFieldName = Sub_Desc ];

Storage Default
{
<Data name="MgArgHolidaySubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SubCode</Value>
</Value>
<Value name="3">
<Value>SubDesc</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgArgHolidaySubD</DataLocation>
<DefaultData>MgArgHolidaySubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNMG.DB.MgArgHolidaySubI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgArgHolidaySubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
