/// Function:课程类
/// CreateDate:2023-09-12
/// Creator:孔晋川
Class User.DHCCourseKjc Extends (%Persistent, User.Abstract) [ SqlRowIdName = Crs_RowID, SqlTableName = DHC_CourseKjc ]
{

/// 编码
Property CrsCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Crs_Code ];

/// 描述
Property CrsDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Crs_Desc ];

/// 有效标志
Property CrsActiveFlag As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = Crs_ActiveFlag ];

/// 编码索引
Index Code On CrsCode As Exact;

/// 描述索引
Index Desc On CrsDesc As Exact;

Storage Default
{
<Data name="DHCCourseKjcDefaultData">
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
<DataLocation>^User.DHCCourseKjcD</DataLocation>
<DefaultData>DHCCourseKjcDefaultData</DefaultData>
<IdLocation>^User.DHCCourseKjcD</IdLocation>
<IndexLocation>^User.DHCCourseKjcI</IndexLocation>
<StreamLocation>^User.DHCCourseKjcS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
