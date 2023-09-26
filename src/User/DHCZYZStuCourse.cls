/// Function:学生选课表(默认存储)
/// CreatDate:2023-09-14
/// Creator:zhangyizhu
Class User.DHCZYZStuCourse Extends (%Persistent, User.Abstract) [ SqlTableName = DHCZYZ_StuCourse ]
{

Relationship StuParRef As DHCZYZStudent [ Cardinality = parent, Inverse = ChildCourse ];

// 课程

Property StCourseDR As User.DHCZYZCourse [ SqlColumnNumber = 2, SqlFieldName = St_Course_DR ];

// 成绩

Property StScore As User.DHCZYZCourse [ SqlColumnNumber = 3, SqlFieldName = St_Score ];

Storage Default
{
<Data name="DHCZYZStuCourseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StCourseDR</Value>
</Value>
<Value name="3">
<Value>StScore</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildCourse")</DataLocation>
<DefaultData>DHCZYZStuCourseDefaultData</DefaultData>
<IdLocation>^User.DHCZYZStudentC("ChildCourse")</IdLocation>
<IndexLocation>^User.DHCZYZStuCourseI</IndexLocation>
<StreamLocation>^User.DHCZYZStuCourseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
