/// Fountion：学生课程表（sqlstorage）
/// CreateDate:2023-09-14
/// Creator:翁瑞珍
Class User.DHCAStudentCourse Extends (%Persistent, User.Abstract) [ SqlTableName = DHCA_StudentCourse ]
{

/// 子表中建立与父表的关系
Relationship StudentParRef As User.DHCAStudent [ Cardinality = parent, Inverse = childCourse ];

/// 课程
Property SCACourse As %String [ Required, SqlColumnNumber = 2, SqlFieldName = SCA_Course ];

/// 分数
Property SCAScore As %String [ Required, SqlColumnNumber = 3, SqlFieldName = SCA_Score ];

Storage Default
{
<Data name="DHCAStudentCourseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SCACourse</Value>
</Value>
<Value name="3">
<Value>SCAScore</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("childCourse")</DataLocation>
<DefaultData>DHCAStudentCourseDefaultData</DefaultData>
<IdLocation>^User.DHCAStudentC("childCourse")</IdLocation>
<IndexLocation>^User.DHCAStudentCourseI</IndexLocation>
<StreamLocation>^User.DHCAStudentCourseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
