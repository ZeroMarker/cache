Class User.DHCMGExam Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHCMG_Exam ]
{

//考核

Property ExamNurDR As User.DHCMGPersons;

Property ExamDate As %Library.Date(FORMAT = 1);

Property ExamTherorSubject As %String(TRUNCATE = 1);

Property ExamTherorPoint As %String(TRUNCATE = 1);

Property ExamOperationSubject As %String(TRUNCATE = 1);

Property ExamOperationPoint As %String(TRUNCATE = 1);

Property ExamRecUser As User.DHCMGPersons;

Property ExamRecDate As %Library.Date(FORMAT = 1);

Index Person On ExamNurDR;

ClassMethod Save(parr As %String) As %String
{
 
 // s parr="^607^2009-03-15^jj^78^oo^89^561"
   s id=$P(parr,"^",1)
   s nur=$P(parr,"^",2)
   s ExamDate=$P(parr,"^",3)
   s theroSubject=$P(parr,"^",4)
   s theropoint=$P(parr,"^",5)
   s opsubject=$P(parr,"^",6)
   s oppoint=$P(parr,"^",7)
   s user=$P(parr,"^",8)
   if id'="" s a=##class(User.DHCMGExam).%OpenId(id)
   e  s a=##class(User.DHCMGExam).%New()
   s a.ExamNurDR=##class(User.DHCMGPersons).%OpenId(nur)
   s a.ExamDate=$ZDH(ExamDate,3)
   s a.ExamTherorSubject=theroSubject
   s a.ExamTherorPoint=theropoint
   s a.ExamOperationSubject=opsubject
   s a.ExamOperationPoint=oppoint
   s a.ExamRecUser=##class(User.DHCMGPersons).%OpenId(user)
   s a.ExamRecDate=+$H
   b
   d a.%Save()
   q 0
}

Storage Default
{
<Data name="DHCMGExamDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ExamDate</Value>
</Value>
<Value name="3">
<Value>ExamNurDR</Value>
</Value>
<Value name="4">
<Value>ExamOperationPoint</Value>
</Value>
<Value name="5">
<Value>ExamOperationSubject</Value>
</Value>
<Value name="6">
<Value>ExamTherorPoint</Value>
</Value>
<Value name="7">
<Value>ExamTherorSubject</Value>
</Value>
<Value name="8">
<Value>ExamRecDate</Value>
</Value>
<Value name="9">
<Value>ExamRecUser</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGExamD</DataLocation>
<DefaultData>DHCMGExamDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGExamD</IdLocation>
<IndexLocation>^User.DHCMGExamI</IndexLocation>
<StreamLocation>^User.DHCMGExamS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
