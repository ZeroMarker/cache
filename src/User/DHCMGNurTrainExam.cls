Class User.DHCMGNurTrainExam Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//护理技术操作培训考评情况

Property ExamDep As %String(TRUNCATE = 1);

Property ExamNur As User.DHCMGPersons;

Property ExamContent As %String(TRUNCATE = 1);

Property ExamScore As %String(TRUNCATE = 1);

Property ExamDate As %Library.Date(FORMAT = 1);

Property ExamTypDr As User.DHCMGNurExamTyp;

Index DateDep On (ExamDate, ExamDep);

Index Nur On ExamNur;

ClassMethod Save(parr As %String) As %String
{
	//id + "^" + dep + "^" + person + "^" + date + "^" + content  + "^" + score + "^" +typ;
	//w ##class(User.DHCMGNurTrainExam).Save("^1^3043^2010-06-22^护理操作^100")
	s id=$P(parr,"^",1)
	s dep=$P(parr,"^",2)
	s per=$P(parr,"^",3)
	s date=$P(parr,"^",4)
	s content=$P(parr,"^",5)
	s score=$P(parr,"^",6)
	s typ=$P(parr,"^",7)
		
	if id'="" s a=##class(User.DHCMGNurTrainExam).%OpenId(id)
	e  s a=##class(User.DHCMGNurTrainExam).%New()
	s a.ExamDep=dep
	s a.ExamNur=##class(User.DHCMGPersons).%OpenId(per)
	s a.ExamContent=content
	s a.ExamScore=score
	s a.ExamDate=$ZDH(date,3)
	s a.ExamTypDr=##class(User.DHCMGNurExamTyp).%OpenId(typ)  
	d a.%Save()
	q 0
}

ClassMethod Delete(id As %String) As %String
{
	d ##class(User.DHCMGNurTrainExam).%DeleteId(id)
	q 0
}

Storage Default
{
<Data name="DHCMGNurTrainExamDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ExamContent</Value>
</Value>
<Value name="3">
<Value>ExamDate</Value>
</Value>
<Value name="4">
<Value>ExamDep</Value>
</Value>
<Value name="5">
<Value>ExamNur</Value>
</Value>
<Value name="6">
<Value>ExamScore</Value>
</Value>
<Value name="7">
<Value>ExamTypDr</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGNurTrainExamD</DataLocation>
<DefaultData>DHCMGNurTrainExamDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGNurTrainExamD</IdLocation>
<IndexLocation>^User.DHCMGNurTrainExamI</IndexLocation>
<StreamLocation>^User.DHCMGNurTrainExamS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
