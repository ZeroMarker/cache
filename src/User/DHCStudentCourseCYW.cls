/// Function:学生选课表
/// CreateDate:2023-09-16
/// Creator:蔡耀伟
Class User.DHCStudentCourseCYW Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_StudentCourseCYW ]
{

Relationship ParRef As DHCStudentCYW [ Cardinality = parent, Inverse = ChildCourse, SqlFieldName = DHCSc_ParRef ];

Property DHCScCourseDR As DHCCourseCYW [ SqlColumnNumber = 2, SqlFieldName = DHCSc_Course_DR ];

Property DHCScScore As %Integer [ SqlColumnNumber = 3, SqlFieldName = DHC_ScScore ];

Index Course On DHCScCourseDR As Exact;

Storage Default
{
<Data name="DHCStudentCourseCYWDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DHCScCourseDR</Value>
</Value>
<Value name="3">
<Value>DHCScScore</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildCourse")</DataLocation>
<DefaultData>DHCStudentCourseCYWDefaultData</DefaultData>
<IdLocation>^User.DHCStudentC("ChildCourse")</IdLocation>
<IndexLocation>^User.DHCStudentCourseCYWI</IndexLocation>
<StreamLocation>^User.DHCStudentCourseCYWS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
