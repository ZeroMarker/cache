/// Function:学生选课表
/// CreateDate:2023-09-15
/// Creator:yanghongrui
Class User.DHCStudentCourseR Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_StudentCourseR ]
{

Relationship ParRef As DHCStudentY [ Cardinality = parent, Inverse = ChildCourse, SqlFieldName = DHCSc_ParRef ];

/// 课程
Property DHCScCourseDR As DHCCourseC [ SqlColumnNumber = 2, SqlFieldName = DHCSc_Course_DR ];

/// 成绩
Property DHCScScore As %Integer [ SqlColumnNumber = 3, SqlFieldName = DHC_ScScore ];

Index Course On DHCScCourseDR As Exact;

Storage Default
{
<Data name="DHCStudentCourseRDefaultData">
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
<DefaultData>DHCStudentCourseRDefaultData</DefaultData>
<IdLocation>^User.DHCStudentYC("ChildCourse")</IdLocation>
<IndexLocation>^User.DHCStudentCourseRI</IndexLocation>
<StreamLocation>^User.DHCStudentCourseRS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
