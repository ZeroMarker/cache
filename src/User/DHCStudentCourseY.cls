/// Function:学生选课表
/// CreateDate:2023-09-15
/// Creator:yanghongrui
Class User.DHCStudentCourseY Extends %Persistent [ SqlTableName = DHCStudentCourseY ]
{

/// 课程
Property DHCScCourseDR As DHCCourseC [ SqlColumnNumber = 2, SqlFieldName = DHCSc_Course_DR ];

/// 成绩
Property DHCScScore As %Integer [ SqlColumnNumber = 3, SqlFieldName = DHC_ScScore ];

Storage Default
{
<Data name="DHCStudentCourseYDefaultData">
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
<DataLocation>^User.DHCStudentCourseYD</DataLocation>
<DefaultData>DHCStudentCourseYDefaultData</DefaultData>
<IdLocation>^User.DHCStudentCourseYD</IdLocation>
<IndexLocation>^User.DHCStudentCourseYI</IndexLocation>
<StreamLocation>^User.DHCStudentCourseYS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
