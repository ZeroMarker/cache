Class User.DHCMGNurExamGrp Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property MGGroup As %String(TRUNCATE = 1);

Property ExamTyp As %String(TRUNCATE = 1);

Property ExamTypSub As %String(TRUNCATE = 1);

Index Grp On MGGroup;

ClassMethod save(parr) As %String
{
   //w ##class(User.DHCMGNurExamGrp).save("^4^1")
   s id=$P(parr,"^",1)
   s group=$P(parr,"^",2)
   s typ=$P(parr,"^",3)
   if id="" s a=##class(User.DHCMGNurExamGrp).%New()
   e  s a=##class(User.DHCMGNurExamGrp).%OpenId(id)
   s a.MGGroup=group
   s a.ExamTyp=typ
   d a.%Save()
   q 0
}

ClassMethod savesub(parr) As %String
{
   //w ##class(User.DHCMGNurExamGrp).savesub("1^Y!Y!Y!Y!Y!Y!Y")
   s id=$P(parr,"^",1)
   s typsub=$P(parr,"^",2)
   if id="" s a=##class(User.DHCMGNurExamGrp).%New()
   e  s a=##class(User.DHCMGNurExamGrp).%OpenId(id)
   s a.ExamTypSub=typsub
   d a.%Save()
   q 0
}

ClassMethod GetTypSub(parr) As %String
{
	//w ##class(User.DHCMGNurExamGrp).GetTypSub("3^8")
	s ret="1|特一级病人^2|抽查份数^3|平均分^4|合格率(%)^5|出院份数^6|平均分^7|合格率(%)"
	s group=$P(parr,"^",1)
	s typdr=$P(parr,"^",2)
	i group'="" d
	.s mggroup=$List(^User.DHCMGSSGROUPD(group),3)
	.i mggroup["护理部" d
	..i typdr'="" d
	...s typ=$List(^User.DHCMGNurExamTypD(typdr),3)
	...i typ["护理病历" s ret="1|特一级病人^2|运行份数^3|平均分^4|合格率(%)^5|出院份数^6|平均分^7|合格率(%)" 
	q ret
}

Storage Default
{
<Data name="DHCMGNurExamGrpDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ExamTyp</Value>
</Value>
<Value name="3">
<Value>ExamTypSub</Value>
</Value>
<Value name="4">
<Value>MGGroup</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGNurExamGrpD</DataLocation>
<DefaultData>DHCMGNurExamGrpDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGNurExamGrpD</IdLocation>
<IndexLocation>^User.DHCMGNurExamGrpI</IndexLocation>
<StreamLocation>^User.DHCMGNurExamGrpS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
