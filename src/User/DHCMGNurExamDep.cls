Class User.DHCMGNurExamDep Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//科护士长

Property ManagerDep As %String(TRUNCATE = 1);

Property ManagerNur As %String(TRUNCATE = 1);

Index Nur On ManagerNur;

ClassMethod IfExist(par) As %String
{
	s nur=$P(par,"^",1)
	s dep=$P(par,"^",2)
	s ret=""
	s rw="" f  s rw=$O(^User.DHCMGNurExamDepI("Nur"," "_nur,rw)) q:(rw="")!(ret'="")  d
	.s a=^User.DHCMGNurExamDepD(rw)
	.s curdep=$List(a,2)
	.if dep=curdep s ret=rw q
   q ret
}

ClassMethod Save(Parr As %String) As %String
{
	//w ##class(User.DHCMGNurExamDep).Save("1^1^1")
	s id=$P(Parr,"^",1)
	s nur=$P(Parr,"^",2)
	s dep=$P(Parr,"^",3)
	s ret=..IfExist(nur_"^"_dep)
	q:ret'="" 0
	if id'="" s a=##class(User.DHCMGNurExamDep).%OpenId(id)
	e  s a=##class(User.DHCMGNurExamDep).%New()
	s a.ManagerNur=nur
	s a.ManagerDep=dep
	d a.%Save()
	q 0
}

ClassMethod Delete(id As %String) As %String
{
	d ##class(User.DHCMGNurExamDep).%DeleteId(id)
	q 0
}

ClassMethod GetNurDep(parr) As %String
{
	//w ##class(User.DHCMGNurExamDep).GetNurDep("1")
	s nur=$P(parr,"^",1)
	q:nur="" ""
	s ret=""
	s rw="" f  s rw=$O(^User.DHCMGNurExamDepI("Nur"," "_nur,rw)) q:(rw="")  d
	.s a=^User.DHCMGNurExamDepD(rw)
	.s depId=$List(a,2)
	.s des=$P(^CTLOC(depId),"^",2)
	.s ret=ret_depId_"|"_des_"^"
   q ret
}

Storage Default
{
<Data name="DHCMGNurExamDepDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ManagerDep</Value>
</Value>
<Value name="3">
<Value>ManagerNur</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGNurExamDepD</DataLocation>
<DefaultData>DHCMGNurExamDepDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGNurExamDepD</IdLocation>
<IndexLocation>^User.DHCMGNurExamDepI</IndexLocation>
<StreamLocation>^User.DHCMGNurExamDepS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
