Class web.DHCSTMPDA.Entity.Request Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "http://his.ws.scm.dhcc.com/";

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property UserCode As %String(TRUNCATE = 1);

Property UserPassWord As %String(TRUNCATE = 1);

Property SxNo As %String(TRUNCATE = 1);

Property HVFlag As %String(TRUNCATE = 1);

Property NeedCheck As %String(TRUNCATE = 1);

Property Flag As %String(TRUNCATE = 1);

Property MainInfo As %String(TRUNCATE = 1);

Property ListData As %String(TRUNCATE = 1);

Property BarCode As %String(TRUNCATE = 1);

Property Type As %String(TRUNCATE = 1);

Storage Default
{
<Data name="RequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserCode</Value>
</Value>
<Value name="3">
<Value>UserPassWord</Value>
</Value>
<Value name="4">
<Value>SxNo</Value>
</Value>
<Value name="5">
<Value>HVFlag</Value>
</Value>
<Value name="6">
<Value>NeedCheck</Value>
</Value>
<Value name="7">
<Value>Flag</Value>
</Value>
<Value name="8">
<Value>MainInfo</Value>
</Value>
<Value name="9">
<Value>ListData</Value>
</Value>
<Value name="10">
<Value>BarCode</Value>
</Value>
<Value name="11">
<Value>LocStr</Value>
</Value>
<Value name="12">
<Value>type</Value>
</Value>
<Value name="13">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^web.DHCSTMPDA.Entity.RequestD</DataLocation>
<DefaultData>RequestDefaultData</DefaultData>
<IdLocation>^web.DHCSTMPDA.Entity.RequestD</IdLocation>
<IndexLocation>^web.DHCSTMPDA.Entity.RequestI</IndexLocation>
<StreamLocation>^web.DHCSTMPDA.Entity.RequestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
