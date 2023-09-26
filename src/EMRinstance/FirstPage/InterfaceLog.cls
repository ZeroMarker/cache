Class EMRinstance.FirstPage.InterfaceLog Extends %Persistent
{

Property CreatDate As %String;

Property CreatTime As %String;

Property Status As %String;

Property EpisodeID As %String;

Property Message As %String;

Index IdxStatusEpisodeID On (Status, EpisodeID);

Index IdxDateTimeStatus On (CreatDate, CreatTime, Status);

Storage Default
{
<Data name="InterfaceLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CreatDate</Value>
</Value>
<Value name="3">
<Value>CreatTime</Value>
</Value>
<Value name="4">
<Value>Status</Value>
</Value>
<Value name="5">
<Value>EpisodeID</Value>
</Value>
<Value name="6">
<Value>Message</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.FPageInterfaceLogD</DataLocation>
<DefaultData>InterfaceLogDefaultData</DefaultData>
<IdLocation>^DHCEMRI.FPageInterfaceLogD</IdLocation>
<IndexLocation>^DHCEMRI.FPageInterfaceLogI</IndexLocation>
<StreamLocation>^DHCEMRI.FPageInterfaceLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
