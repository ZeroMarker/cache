Class User.DHCMGGroupPersons Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property PerGrpDr As User.DHCMGCGroup;

Property PersonDr As %String(TRUNCATE = 1);

Index Person On PersonDr;

Index Grp On PerGrpDr;

ClassMethod SaveGrp(parr As %String) As %String
{
  s id=$P(parr,"^",1)
  s Grp=$P(parr,"^",2)
  s person=$P(parr,"^",3)
  s ln=$L(person,"|")
  s a=""
  for i=1:1:ln
  {
    s per=$P(person,"|",i)
    q:per=""
    s ret=..SaveGrpPerson(id_"^"_Grp_"^"_per)
    if ret'=0
    {
	  s a=a_ret_"^"
	}
  }
  if a'="" q a
  e  q 0
}

ClassMethod SaveGrpPerson(parr As %String) As %String
{
 
  s id=$P(parr,"^",1)
  s Grp=$P(parr,"^",2)
  s person=$P(parr,"^",3)
  s rw="" s rw=$O(^User.DHCMGGroupPersonsI("Person"," "_person,rw))
  s flag=0
  if rw'="" 
  {
	  s per=##class(User.DHCMGGroupPersons).%OpenId(rw)
	  s pergrp=per.PerGrpDr
	  if pergrp'=##class(User.DHCMGCGroup).%OpenId(Grp)
	  {
		  s flag=1
	  }
  }
  q:flag=1 pergrp.GrpName_"有此人"
  if id="" s a=##class(User.DHCMGGroupPersons).%New()
  e  s a=##class(User.DHCMGGroupPersons).%OpenId(id)
  s a.PerGrpDr=##class(User.DHCMGCGroup).%OpenId(Grp)
  s a.PersonDr=person
  d a.%Save()
  q 0
}

ClassMethod DelPerson(id As %String) As %String
{
	d ##class(User.DHCMGGroupPersons).%DeleteId(id)
	q 0
}

ClassMethod DelPersonByper(per As %String) As %String
{
	
   f id=""  s id=$o(^User.DHCMGGroupPersonsI("Person"," "_per,"")) q:id=""  d
   .d ##class(User.DHCMGGroupPersons).%DeleteId(id)
	q 0
}

Storage Default
{
<Data name="DHCMGGroupPersonsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PerGrpDr</Value>
</Value>
<Value name="3">
<Value>PersonDr</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGGroupPersonsD</DataLocation>
<DefaultData>DHCMGGroupPersonsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGGroupPersonsD</IdLocation>
<IndexLocation>^User.DHCMGGroupPersonsI</IndexLocation>
<StreamLocation>^User.DHCMGGroupPersonsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
