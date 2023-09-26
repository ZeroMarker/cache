/// creator: xbl
/// createdate: 2017/12/18
/// description: 学生列表
Class DHCNMG.Intern.MgStudent Extends %Persistent
{

/// 学生
Property StudyPerDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 2, SqlFieldName = Study_PerDR ];

/// 带教老师
Property TeacherDR As DHCNMG.Intern.MgTeacher [ SqlColumnNumber = 3, SqlFieldName = Teacher_DR ];

Index Student On StudyPerDR;

Index Teacher On TeacherDR;

Index Repeat On (TeacherDR, StudyPerDR);

Storage Default
{
<Data name="MgStudentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StudentPerDR</Value>
</Value>
<Value name="3">
<Value>TeacherDR</Value>
</Value>
<Value name="4">
<Value>StudentDR</Value>
</Value>
<Value name="5">
<Value>StudyPerDR</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Intern.MgStudentD</DataLocation>
<DefaultData>MgStudentDefaultData</DefaultData>
<IdLocation>^DHCNMG.Intern.MgStudentD</IdLocation>
<IndexLocation>^DHCNMG.Intern.MgStudentI</IndexLocation>
<StreamLocation>^DHCNMG.Intern.MgStudentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
