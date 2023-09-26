Class User.DHCMGSSGROUP Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//安全组

Property grpname As %String(TRUNCATE = 1);

Property grpcode As %String(TRUNCATE = 1);

Property Typ As %Library.String(DISPLAYLIST = ",Doc,Nur,All", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",D,N,A");

ClassMethod save(parr As %String) As %String
{
   s id=$P(parr,"^",1)
   s name=$P(parr,"^",2)
   s code=$P(parr,"^",3)
   s typ=$P(parr,"^",4)
   if id="" s a=##class(User.DHCMGSSGROUP).%New()
   e  s a=##class(User.DHCMGSSGROUP).%OpenId(id)
   s a.grpname=name
   s a.grpcode=code
   s a.Typ=typ
   d a.%Save()
   q 0
}

ClassMethod getssgrp() As %String
{
   s ret=""
   s rw=""  f  s rw=$O(^User.DHCMGSSGROUPD(rw)) q:rw=""  d
   .s name=$List(^User.DHCMGSSGROUPD(rw),2)
   .s ret=ret_rw_"|"_name_"^"
   q ret
}

Storage Default
{
<Data name="DHCMGSSGROUPDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>grpcode</Value>
</Value>
<Value name="3">
<Value>grpname</Value>
</Value>
<Value name="4">
<Value>Typ</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGSSGROUPD</DataLocation>
<DefaultData>DHCMGSSGROUPDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGSSGROUPD</IdLocation>
<IndexLocation>^User.DHCMGSSGROUPI</IndexLocation>
<StreamLocation>^User.DHCMGSSGROUPS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
