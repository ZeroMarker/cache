Class web.DHCPE.CallVoice.Entity.Patient Extends (%Persistent, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = persistent, Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 患者姓名
Property Name As %String(TRUNCATE = 1);

/// 患者性别
Property Sex As %String(TRUNCATE = 1);

/// 平诊
Property Priority As %String(TRUNCATE = 1);

/// 排队号
Property QueueNo As %String(TRUNCATE = 1);

/// 登记号
Property RegisterNo As %String(TRUNCATE = 1);

/// 就诊科室
Property Department As %String(TRUNCATE = 1);

Storage Default
{
<Data name="PatientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Department</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Priority</Value>
</Value>
<Value name="5">
<Value>QueueNo</Value>
</Value>
<Value name="6">
<Value>RegisterNo</Value>
</Value>
<Value name="7">
<Value>Sex</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.CallVoice91B.PatientD</DataLocation>
<DefaultData>PatientDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.CallVoice91B.PatientD</IdLocation>
<IndexLocation>^web.DHCPE.CallVoice91B.PatientI</IndexLocation>
<StreamLocation>^web.DHCPE.CallVoice91B.PatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
