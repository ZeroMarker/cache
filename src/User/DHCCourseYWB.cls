/// Function:科目类（默认存储）
/// CreateTime:2023-09-12
/// Creator:YiWenbo
/// 建立课程表表名DHC_Course ,类名User.DHCCourse 主键  Crs_RowID字段Crs_Code,Crs_Desc,Crs_ActiveFlag(Y/N)
Class User.DHCCourseYWB Extends (%Persistent, User.Abstract) [ SqlRowIdName = Crs_RowId, SqlTableName = DHC_CourseYWB ]
{

Property CrsCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Crs_Code ];

Property CrsDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = Crs_Desc ];

Property CrsActiveFlag As %String(VALUELIST = ",Y,N") [ Required, SqlColumnNumber = 4, SqlFieldName = Crs_ActiveFlag ];

Index Code On CrsCode As Exact;

Index Desc On CrsDesc As Exact;

Storage Default
{
<Data name="DHCCourseYWBDefaultData">
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
<Value>CrsActiveFlag</Value>
</Value>
</Data>
<DataLocation>^User.DHCCourseYWBD</DataLocation>
<DefaultData>DHCCourseYWBDefaultData</DefaultData>
<IdLocation>^User.DHCCourseYWBD</IdLocation>
<IndexLocation>^User.DHCCourseYWBI</IndexLocation>
<StreamLocation>^User.DHCCourseYWBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
