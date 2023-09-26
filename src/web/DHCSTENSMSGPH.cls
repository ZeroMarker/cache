Class web.DHCSTENSMSGPH Extends (%RegisteredObject, %XML.Adaptor)
{

//Parameter XMLIGNOREINVALIDTAG = 1;

//Parameter XMLNAME = "Response";

/// Descript:摆药机接口从平台返回值信息
/// 响应信息
Property ResultContent As %String(MAXLEN = 32767, TRUNCATE = 1);

/// 响应码(0-成功)
Property ResultCode As %String(MAXLEN = 32767, TRUNCATE = 1);

Storage Default
{
<Data name="DHCSTENSMSGPHDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ResultCode</Value>
</Value>
<Value name="3">
<Value>ResultContent</Value>
</Value>
</Data>
<DataLocation>^web.DHCSTENSMSGPHD</DataLocation>
<DefaultData>DHCSTENSMSGPHDefaultData</DefaultData>
<IdLocation>^web.DHCSTENSMSGPHD</IdLocation>
<IndexLocation>^web.DHCSTENSMSGPHI</IndexLocation>
<StreamLocation>^web.DHCSTENSMSGPHS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
