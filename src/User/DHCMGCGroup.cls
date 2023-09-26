Class User.DHCMGCGroup Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property GrpDepDr As %String(TRUNCATE = 1);

Property GrpName As %String(TRUNCATE = 1);

Index Dep On GrpDepDr;

ClassMethod SaveGroup(parr As %String) As %String
{
   s id=$P(parr,"^",1)
   s Dep=$P(parr,"^",3)
   s grpname=$P(parr,"^",2)
   if id="" s a=##class(User.DHCMGCGroup).%New()
   e  s a=##class(User.DHCMGCGroup).%OpenId(id)
   s a.GrpDepDr=Dep
   s a.GrpName=grpname
   d a.%Save()
   q 0
}

Storage Default
{
<Data name="DHCMGCGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GrpDepDr</Value>
</Value>
<Value name="3">
<Value>GrpName</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGCGroupD</DataLocation>
<DefaultData>DHCMGCGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGCGroupD</IdLocation>
<IndexLocation>^User.DHCMGCGroupI</IndexLocation>
<StreamLocation>^User.DHCMGCGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
