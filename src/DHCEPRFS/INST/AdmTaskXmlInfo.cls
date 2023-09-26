Class DHCEPRFS.INST.AdmTaskXmlInfo Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property EpisodeID As %String;

Property MRItemID As %String;

// xml 信息

Property XMLInfo As %String(MAXLEN = 10000);

Property OperDate As %Date;

Property OperTime As %Time;

Property OperIP As %String;

// 成功标志(1=成功，0=失败)

Property SucceedFlag As %String;

// 处理日期

Property ProcessDate As %Date;

// 处理时间

Property ProcessTime As %Time;

// 处理IP

Property ProcessIP As %String;

// 返回给平台的xml

Property PlatformXMLInfo As %String(MAXLEN = 10000);

// 平台的返回值

Property PlatformRet As %String(MAXLEN = 1000);

Storage Default
{
<Data name="AdmTaskXmlInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>XMLInfo</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>MRItemID</Value>
</Value>
<Value name="5">
<Value>OperDate</Value>
</Value>
<Value name="6">
<Value>OperTime</Value>
</Value>
<Value name="7">
<Value>SucceedFlag</Value>
</Value>
<Value name="8">
<Value>ProcessDate</Value>
</Value>
<Value name="9">
<Value>ProcessTime</Value>
</Value>
<Value name="10">
<Value>ProcessIP</Value>
</Value>
<Value name="11">
<Value>OperIP</Value>
</Value>
<Value name="12">
<Value>PlatformXMLInfo</Value>
</Value>
<Value name="13">
<Value>PlatformRet</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.AdmTaskXmlInfoD</DataLocation>
<DefaultData>AdmTaskXmlInfoDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.AdmTaskXmlInfoD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.AdmTaskXmlInfoI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.AdmTaskXmlInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
