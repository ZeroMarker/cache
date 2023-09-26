/// Funciton:建立科目表（默认存储）
/// CreateDate:2023-09-14
/// Creator:zhangyizhu
Class User.DHCZYZFCourse Extends (%Persistent, User.Abstract) [ SqlRowIdName = Crs_RowId, SqlTableName = DHCZYZF_Course ]
{

/// 课程代码
Property CrsCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Crs_Code ];

/// 课程名称
Property CrsDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = Crs_Desc ];

/// 有效标志
Property CrsActive As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = Crs_Active ];

/// 代码索引
Index Code On CrsCode [ Unique ];

/// 课程名称索引
Index Desc On CrsDesc As Exact;

Storage Default
{
<Data name="DHCZYZFCourseDefaultData">
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
<DataLocation>^User.DHCZYZFCourseD</DataLocation>
<DefaultData>DHCZYZFCourseDefaultData</DefaultData>
<IdLocation>^User.DHCZYZFCourseD</IdLocation>
<IndexLocation>^User.DHCZYZFCourseI</IndexLocation>
<StreamLocation>^User.DHCZYZFCourseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
