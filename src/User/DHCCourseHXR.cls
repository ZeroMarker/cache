/// 科目表：DHC_CourseHXR
/// 表名DHC_Course ,类名User.DHCCourse 主键  Crs_RowID
/// 字段Crs_Code,Crs_Desc,Crs_ActiveFlag(Y/N)
/// crestor:黄欣然
Class User.DHCCourseHXR Extends %Persistent [ SqlTableName = DHC_CourseHXR ]
{

/// 号
Property CrsCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Crs_code ];

/// 描述
Property CrsDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = Crs_Desc ];

/// 是否有效
Property CrsActiveFlag As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = Crs_ActiveFlag ];

Storage Default
{
<Data name="DHCCourseHXRDefaultData">
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
<DataLocation>^User.DHCCourseHXRD</DataLocation>
<DefaultData>DHCCourseHXRDefaultData</DefaultData>
<IdLocation>^User.DHCCourseHXRD</IdLocation>
<IndexLocation>^User.DHCCourseHXRI</IndexLocation>
<StreamLocation>^User.DHCCourseHXRS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
