Class DHCWL.DM.T.ThemeDataLog Extends %Persistent
{

Property ThemeBase As ThemeBase [ Required ];

Property LogDate As %Date [ Required ];

Property FetchConfigBase As ThemeFetchConfig [ Required ];

Property LogTime As %Time;

Property Status As %String;

Property ScheduleFilterParams As %String;

Property LinkExpressionParams As %String;

Index MainI On (ThemeBase, LogDate, FetchConfigBase);

Storage Default
{
<Data name="ThemeDataLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ThemeBase</Value>
</Value>
<Value name="3">
<Value>LogDate</Value>
</Value>
<Value name="4">
<Value>FetchConfigBase</Value>
</Value>
<Value name="5">
<Value>LogTime</Value>
</Value>
<Value name="6">
<Value>Status</Value>
</Value>
<Value name="7">
<Value>ScheduleFilterParams</Value>
</Value>
<Value name="8">
<Value>LinkExpressionParams</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.ThemeDataLogD</DataLocation>
<DefaultData>ThemeDataLogDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.ThemeDataLogD</IdLocation>
<IndexLocation>^DHCWL.DM.T.ThemeDataLogI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.ThemeDataLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
