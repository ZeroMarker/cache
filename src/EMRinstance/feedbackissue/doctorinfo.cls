Class EMRinstance.feedbackissue.doctorinfo Extends %Persistent
{

Property DocId As %String;

Property UserName As %String;

Property SelfPhoneNumber As %String;

Property LocPhoneNumber As %String;

Property RealName As %String;

Index IdxDocID On DocId;

Storage Default
{
<Data name="FeedBackDocInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>DocId</Value>
</Value>
<Value name="4">
<Value>PhoneNub</Value>
</Value>
<Value name="5">
<Value>UserName</Value>
</Value>
<Value name="6">
<Value>SelfPhoneNumber</Value>
</Value>
<Value name="7">
<Value>LocPhoneNumber</Value>
</Value>
<Value name="8">
<Value>RealName</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.FeedBackDocInfoD</DataLocation>
<DefaultData>FeedBackDocInfoDefaultData</DefaultData>
<IdLocation>^DHCEMRI.FeedBackDocInfoD</IdLocation>
<IndexLocation>^DHCEMRI.FeedBackDocInfoI</IndexLocation>
<StreamLocation>^DHCEMRI.FeedBackDocInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
