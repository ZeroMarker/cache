Class DHCEPRFS.META.QAEPR Extends %Persistent
{

Property EPRDocID As %String [ SqlColumnNumber = 2 ];

Property ActionCode As %String [ SqlColumnNumber = 3 ];

Property TitleList As %String(MAXLEN = 2000) [ SqlColumnNumber = 4 ];

Index IdxMain On (EPRDocID, ActionCode) [ Unique ];

Storage Default
{
<Data name="QAEPRDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EPRDocID</Value>
</Value>
<Value name="3">
<Value>ActionCode</Value>
</Value>
<Value name="4">
<Value>TitleList</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.QAEPRD</DataLocation>
<DefaultData>QAEPRDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.QAEPRD</IdLocation>
<IndexLocation>^DHCEPRFS.META.QAEPRI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.QAEPRS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
