Class User.DHCMGPersonRelation Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//结束日期

Property RelDepDR As %String(TRUNCATE = 1);

Property RelPersonParDR As %String(TRUNCATE = 1);

Property RelPersonSubDR As %String(TRUNCATE = 1);

Property RelFromDate As %Library.Date(FORMAT = 1);

Property RelEndDate As %Library.Date(FORMAT = 1);

Index Rel On (RelDepDR, RelPersonParDR);

ClassMethod RemoveRelPerson(rw As %String) As %String
{
  s a= ##class(User.DHCMGPersonRelation).%DeleteId(rw)
  q 0
}

ClassMethod saveRelper(parr As %String) As %String
{
 //关联人员
   //s parr="186^266^2009-02-17^2009-02-17^1079^"
   s par=$P(parr,"^")
   s sub=$P(parr,"^",2)
   s frdate=$P(parr,"^",3)
   s edate=$P(parr,"^",4)
   s dep=$P(parr,"^",5)
   s id=$P(parr,"^",6)
  if id="" s a=##class(User.DHCMGPersonRelation).%New()
  e  s a=##class(User.DHCMGPersonRelation).%OpenId(id)
   s a.RelPersonParDR=par
   s a.RelPersonSubDR=sub
   s a.RelFromDate=$ZDH(frdate,3)
   s a.RelEndDate=$ZDH(edate,3)
   s a.RelDepDR=dep
   d a.%Save()
   q 0
}

Storage Default
{
<Data name="DHCMGPersonRelationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RelEndDate</Value>
</Value>
<Value name="3">
<Value>RelFromDate</Value>
</Value>
<Value name="4">
<Value>RelPersonParDR</Value>
</Value>
<Value name="5">
<Value>RelPersonSubDR</Value>
</Value>
<Value name="6">
<Value>RelDepDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGPersonRelationD</DataLocation>
<DefaultData>DHCMGPersonRelationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGPersonRelationD</IdLocation>
<IndexLocation>^User.DHCMGPersonRelationI</IndexLocation>
<StreamLocation>^User.DHCMGPersonRelationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
