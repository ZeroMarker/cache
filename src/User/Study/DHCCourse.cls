/// Function:课程(默认存储)
/// CreateDate:2023-09-12
/// Creator:yanghongrui
/// Table:DHC_Course
/// Input:	Crs_RowId：课程主键
/// Output:	CrsCode,CrsDesc,CrsActiveFlag(Y/N)
/// Others:	w ##class(User.Study.DHCCourse).GetStudentInfo(1)
Class User.Study.DHCCourse Extends (%Persistent, User.Abstract) [ SqlRowIdName = Crs_RowId, Not SqlRowIdPrivate, SqlTableName = DHC_Course ]
{

/// 字段：字段 Crs_Code,Crs_Desc,Crs_Active
/// 代码
Property CrsCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Crs_Code ];

/// 名称
Property CrsDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Crs_Desc ];

/// 有效标志
Property CrsActive As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = Crs_Active ];

/// 对代码进行唯一性限制
/// 课程号索引
Index Code On CrsCode As Exact;

/// 课程名索引
Index Desc On CrsDesc As Exact;

Storage Default
{
<Data name="DHCCourseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CrsCode</Value>
</Value>
<Value name="3">
<Value>CrsDesc</Value>
</Value>
<Value name="4">
<Value>CrsActive</Value>
</Value>
</Data>
<DataLocation>^User.Study.DHCCourseD</DataLocation>
<DefaultData>DHCCourseDefaultData</DefaultData>
<IdLocation>^User.Study.DHCCourseD</IdLocation>
<IndexLocation>^User.Study.DHCCourseI</IndexLocation>
<SqlRowIdName>Crs_RowId</SqlRowIdName>
<StreamLocation>^User.Study.DHCCourseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
