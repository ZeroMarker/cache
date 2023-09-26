Class EPRinstance.SelfPrintRecord Extends %Persistent [ ProcedureBlock ]
{

Property EpisodeID As %String [ SqlColumnNumber = 2 ];

Property PrintReason As %String [ SqlColumnNumber = 3 ];

Property PrintItems As %String [ SqlColumnNumber = 4 ];

Property PrintUserID As %String [ SqlColumnNumber = 5 ];

Property PrintDate As %Date [ SqlColumnNumber = 6 ];

Property PrintTime As %Time [ SqlColumnNumber = 7 ];

Index IdxOnPrintReason On (EpisodeID, PrintReason);

Storage Default
{
<Data name="SelfPrintRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>PrintReason</Value>
</Value>
<Value name="4">
<Value>PrintItems</Value>
</Value>
<Value name="5">
<Value>PrintUserID</Value>
</Value>
<Value name="6">
<Value>PrintDate</Value>
</Value>
<Value name="7">
<Value>PrintTime</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.SelfPrintRecordD</DataLocation>
<DefaultData>SelfPrintRecordDefaultData</DefaultData>
<IdLocation>^DHCEPRI.SelfPrintRecordD</IdLocation>
<IndexLocation>^DHCEPRI.SelfPrintRecordI</IndexLocation>
<StreamLocation>^DHCEPRI.SelfPrintRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
