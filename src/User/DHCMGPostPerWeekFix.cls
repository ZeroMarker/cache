Class User.DHCMGPostPerWeekFix Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property Dep As %String(TRUNCATE = 1);

Property Person As User.DHCMGPersons;

Property Post As User.DHCMGPost;

Property Week As %String(TRUNCATE = 1);

Property StDate As %Library.Date(FORMAT = 1);

Property EnDate As %Library.Date(FORMAT = 1);

Property mDate As %Library.Date(FORMAT = 1);

Property mtime As %Library.Time;

Property mUser As User.DHCMGPersons;

Index Dep On Dep;

Index Person On Person;

ClassMethod save(parr As %String) As %String
{
   s id=$P(parr,"^",1)
   s dep=$P(parr,"^",2)
   s per=$P(parr,"^",3)
   s pst=$P(parr,"^",4)
   s week=$P(parr,"^",5)
   s stdate=$P(parr,"^",6)
   s user=$P(parr,"^",7)
   
   if id="" s a=##class(User.DHCMGPostPerWeekFix).%New()
   e  s a=##class(User.DHCMGPostPerWeekFix).%OpenId(id)
   s a.Dep=dep
   s a.Person=##class(User.DHCMGPersons).%OpenId(per)
   s a.Post=##class(User.DHCMGPost).%OpenId(pst)
   s a.Week=week
   s a.StDate=$ZDH(stdate,3)
   s a.mDate=+$H
   s a.mtime=$P($H,",",2)
   s a.mUser=##class(User.DHCMGPersons).%OpenId(user)
   d a.%Save()
   q 0
}

Storage Default
{
<Data name="DHCMGPostPerWeekFixDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Dep</Value>
</Value>
<Value name="3">
<Value>Person</Value>
</Value>
<Value name="4">
<Value>Post</Value>
</Value>
<Value name="5">
<Value>Week</Value>
</Value>
<Value name="6">
<Value>StDate</Value>
</Value>
<Value name="7">
<Value>EnDate</Value>
</Value>
<Value name="8">
<Value>mDate</Value>
</Value>
<Value name="9">
<Value>mUser</Value>
</Value>
<Value name="10">
<Value>mtime</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGPostPerWeekFixD</DataLocation>
<DefaultData>DHCMGPostPerWeekFixDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGPostPerWeekFixD</IdLocation>
<IndexLocation>^User.DHCMGPostPerWeekFixI</IndexLocation>
<StreamLocation>^User.DHCMGPostPerWeekFixS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
