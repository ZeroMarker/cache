Class DHCWL.DM.T.ThemeTaskConfig Extends %Persistent
{

Property ThemeBase As ThemeBase [ Required ];

Property ScheduleConfig As %String [ Required ];

Property IsActived As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",Y,N") [ Required ];

Property UpdateDate As %Integer;

Index MainI On ThemeBase [ PrimaryKey ];

Storage Default
{
<Data name="ThemeTaskConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ThemeBase</Value>
</Value>
<Value name="3">
<Value>ScheduleConfig</Value>
</Value>
<Value name="4">
<Value>IsActived</Value>
</Value>
<Value name="5">
<Value>UpdateDate</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.ThemeTaskConfigD</DataLocation>
<DefaultData>ThemeTaskConfigDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.ThemeTaskConfigD</IdLocation>
<IndexLocation>^DHCWL.DM.T.ThemeTaskConfigI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.ThemeTaskConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
