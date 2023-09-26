Class User.DHCMGSuckleWoman Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property Sucklewm As User.DHCMGPersons;

Property SuckleStDate As %Library.Date(FORMAT = 1);

Property SuckleEdDate As %Library.Date(FORMAT = 1);

Property SuckleDepDR As %String(TRUNCATE = 1);

Index women On Sucklewm;

Index dep On SuckleDepDR;

ClassMethod save(parr) As %String
{
  s id=$P(parr,"^")
  s men=$P(parr,"^",2)
  s stdate=$P(parr,"^",3)
  s endate=$P(parr,"^",4)
  s dep=$P(parr,"^",5)
  if stdate'="" s stdate=$ZDH(stdate,3)
  if endate'="" s endate=$ZDH(endate,3)
  if endate<stdate q 0
  if id'="" s a=##class(User.DHCMGSuckleWoman).%OpenId(id)
  e  s a=##class(User.DHCMGSuckleWoman).%New()
  s a.Sucklewm=##class(User.DHCMGPersons).%OpenId(men)
  s a.SuckleStDate=stdate
  s a.SuckleEdDate=endate
  s a.SuckleDepDR=dep
  d a.%Save()
  q 0
}

ClassMethod getsuckleflag(per, date) As %String
{
 //s a=##class(User.DHCMGSuckleWoman).getsuckleflag()
   s flag="false"
   s rw="" s rw=$O(^User.DHCMGSuckleWomanI("women",per,rw))
   if rw="" q flag
   s a=^User.DHCMGSuckleWomanD(rw)
   s stdate=$list(a,3),edate=$list(a,2)
   if (date'<stdate)&(date'>edate) s flag="true"
   q flag
}

Storage Default
{
<Data name="DHCMGSuckleWomanDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SuckleEdDate</Value>
</Value>
<Value name="3">
<Value>SuckleStDate</Value>
</Value>
<Value name="4">
<Value>Sucklewm</Value>
</Value>
<Value name="5">
<Value>SuckleDepDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGSuckleWomanD</DataLocation>
<DefaultData>DHCMGSuckleWomanDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGSuckleWomanD</IdLocation>
<IndexLocation>^User.DHCMGSuckleWomanI</IndexLocation>
<StreamLocation>^User.DHCMGSuckleWomanS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
