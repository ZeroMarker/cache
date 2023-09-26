Class User.DHCMGNurMessage Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//通知公告

Property MessUser As %String(TRUNCATE = 1);

Property MessDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$p($h,",",1)}, Required ];

Property MessTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required ];

Property MessTitle As %String(TRUNCATE = 1);

Property MessContent As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0);

Index Date On MessDate;

Storage Default
{
<Data name="DHCMGNurMessageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MessContent</Value>
</Value>
<Value name="3">
<Value>MessDate</Value>
</Value>
<Value name="4">
<Value>MessTime</Value>
</Value>
<Value name="5">
<Value>MessTitle</Value>
</Value>
<Value name="6">
<Value>MessUser</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGNurMessageD</DataLocation>
<DefaultData>DHCMGNurMessageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGNurMessageD</IdLocation>
<IndexLocation>^User.DHCMGNurMessageI</IndexLocation>
<StreamLocation>^User.DHCMGNurMessageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
