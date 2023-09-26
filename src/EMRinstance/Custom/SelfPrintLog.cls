/// 自助设备打印记录
Class EMRinstance.Custom.SelfPrintLog Extends %Persistent
{

Property InstanceDataID As %String;

Property PrintDate As %Date;

Property PrintTime As %Time;

Property IPAddress As %String;

Property UserID As %String;

Index IdxInstanceDataID On InstanceDataID;

Index IdxPrintDate On PrintDate;

Storage Default
{
<Data name="SelfPrintLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InstanceDataID</Value>
</Value>
<Value name="3">
<Value>CreateDate</Value>
</Value>
<Value name="4">
<Value>CreateTime</Value>
</Value>
<Value name="5">
<Value>PrintDate</Value>
</Value>
<Value name="6">
<Value>PrintTime</Value>
</Value>
<Value name="7">
<Value>IPAddress</Value>
</Value>
<Value name="8">
<Value>UserID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.SelfPrintLogD</DataLocation>
<DefaultData>SelfPrintLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRI.SelfPrintLogD</IdLocation>
<IndexLocation>^DHCEMRI.SelfPrintLogI</IndexLocation>
<StreamLocation>^DHCEMRI.SelfPrintLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
