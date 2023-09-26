Class User.DHCMGNurExamDepSort Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 质控科室
Property ExamDepDR As %String(TRUNCATE = 1);

Property ExamDepSort As %String(TRUNCATE = 1);

Property ExamTyp As %String(TRUNCATE = 1);

Index TypDep On (ExamTyp, ExamDepDR);

ClassMethod SaveDepSort(parr As %String, Typ As %String) As %String
{
   
	//w ##class(User.DHCMGNurExamDepSort).SaveDepSort("211^210","W")
	s ln=$L(parr,"^")
	f i=1:1:ln
	{
		s itm=$P(parr,"^",i)
		q:itm=""
		s dep=$P(itm,"|",1)
		s sortno=$P(itm,"|",2)
		s rw="" s rw=$O(^User.DHCMGNurExamDepSortI("TypDep"," "_Typ," "_dep,rw))
		if rw="" s deport=##class(User.DHCMGNurExamDepSort).%New()
		e  s deport=##class(User.DHCMGNurExamDepSort).%OpenId(rw)
		s deport.ExamDepDR=dep
		s deport.ExamDepSort=sortno
		s deport.ExamTyp=Typ
		d deport.%Save()
		s tmp(dep)=""
	}
	q 0
}

ClassMethod GetSortDep(typ) As %String
{
	//获取排序科室
	//w ##class(User.DHCMGNurExamDepSort).GetSortDep("W")
	q:typ="" ""
	k DepSort
	s dep=""  f  s dep=$O(^User.DHCMGNurExamDepSortI("TypDep"," "_typ,dep)) q:dep=""  d
	.b //000
	.s rw=""  f  s rw=$O(^User.DHCMGNurExamDepSortI("TypDep"," "_typ,dep,rw)) q:rw=""  d
	..s sort=$List(^User.DHCMGNurExamDepSortD(rw),3)
	..s DepSort(sort)=dep
	
	s ret=""
	s rw="" f  s rw=$O(DepSort(rw)) q:rw=""  d
	.s dep=DepSort(rw), des=$P(^CTLOC($TR(dep," ")),"^",2)
	.s ret=ret_$TR(dep," ")_"|"_des_"^"
	q ret
}

Storage Default
{
<Data name="DHCMGNurExamDepSortDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ExamDepDR</Value>
</Value>
<Value name="3">
<Value>ExamDepSort</Value>
</Value>
<Value name="4">
<Value>ExamTyp</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGNurExamDepSortD</DataLocation>
<DefaultData>DHCMGNurExamDepSortDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGNurExamDepSortD</IdLocation>
<IndexLocation>^User.DHCMGNurExamDepSortI</IndexLocation>
<StreamLocation>^User.DHCMGNurExamDepSortS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
