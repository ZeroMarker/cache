/// Function:学生选课表
/// CreateDate:2023-09-14
/// Creator:yiwenbo
Class User.DHCStudentCourseYWB Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_StudentCourseYWB ]
{

Relationship ParRef As DHCStudent [ Cardinality = parent, Inverse = ChildCourse, SqlFieldName = DHCSc_ParRef ];

Property DHCScCourseDR As DHCCourseYWB [ SqlColumnNumber = 2, SqlFieldName = DHCSc_Course_DR ];

Property DHCScScore As %Integer [ SqlColumnNumber = 3, SqlFieldName = DHC_ScScore ];

Index Course On DHCScCourseDR As Exact;

Storage Default
{
<Data name="DHCStudentCourseYWBDefaultData">
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
<DefaultData>DHCStudentCourseYWBDefaultData</DefaultData>
<IdLocation>^User.DHCStudentC("ChildCourse")</IdLocation>
<IndexLocation>^User.DHCStudentCourseYWBI</IndexLocation>
<StreamLocation>^User.DHCStudentCourseYWBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
