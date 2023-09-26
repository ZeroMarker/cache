/// Function:学生选课表
/// CreateDate:2023-09-15
/// Creator:yanghongrui
Class User.DHCStudentCourseG Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_StudentCourseG ]
{

/// 建立关系
/// 定义ChildSub
/// 课程
Property DHCScCourseDR As DHCCourseC [ SqlColumnNumber = 2, SqlFieldName = DHCSc_Course_DR ];

/// 成绩
Property DHCScScore As %Integer [ SqlColumnNumber = 3, SqlFieldName = DHC_ScScore ];

Storage Default
{
<Data name="DHCStudentCourseGDefaultData">
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
<DefaultData>DHCStudentCourseGDefaultData</DefaultData>
<IndexLocation>^User.DHCStudentCourseGI</IndexLocation>
<StreamLocation>^User.DHCStudentCourseGS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
