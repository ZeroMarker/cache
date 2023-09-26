Class CHSS.PersonHISInfo Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 卡号
Property CardNumber As %String(TRUNCATE = 1);

///    XML格式：<Request><Name></Name><Sex></Sex><Birth></Birth><CredType></CredType><CredNo></CredNo><Address></Address><TelHome></TelHome><PatType></PatType><CardType></CardType><CardNo></CardNo><UserDR></UserDR></Request>
///   Property PersonInfoXML As %String(TRUNCATE = 1);
///  http://172.74.11.201/trakcarelive/trak/web/dhcservice.HealthFileTranCardService.cls
/// <Request><CardNumber>000000000001212</CardNumber></Request>

Storage Default
{
<Data name="PersonHISInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CardNumber</Value>
</Value>
<Value name="3">
<Value>PersonInfoXML</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonHISInfoD</DataLocation>
<DefaultData>PersonHISInfoDefaultData</DefaultData>
<IdLocation>^CHSS.PersonHISInfoD</IdLocation>
<IndexLocation>^CHSS.PersonHISInfoI</IndexLocation>
<StreamLocation>^CHSS.PersonHISInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
