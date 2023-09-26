/// Funciton:建立科目表（默认存储）
/// CreateDate:2023-09-12
/// Creator:zhangyizhu
Class User.DHCZYZCourse Extends (%Persistent, User.Abstract) [ SqlRowIdName = Crs_RowId, SqlTableName = DHCZYZ_Course ]
{

/// 课程代码
Property CrsCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Crs_Code ];

/// 课程名称
Property CrsDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = Crs_Desc ];

/// 有效标志
Property CrsActive As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = Crs_Active ];

/// 代码索引
Index Code On CrsCode As Exact;

/// 课程名称索引
Index Desc On CrsDesc As Exact;

Storage Default
{
<Data name="DHCZYZCourseDefaultData">
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
<DataLocation>^User.DHCZYZCourseD</DataLocation>
<DefaultData>DHCZYZCourseDefaultData</DefaultData>
<IdLocation>^User.DHCZYZCourseD</IdLocation>
<IndexLocation>^User.DHCZYZCourseI</IndexLocation>
<StreamLocation>^User.DHCZYZCourseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
