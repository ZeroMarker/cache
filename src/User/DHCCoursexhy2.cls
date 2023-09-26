/// Function:课程表（SQL storage ）
/// CreateDate:2023-09-12
/// Creator:谢海洋
Class User.DHCCoursexhy2 Extends %Persistent [ SqlTableName = DHC_Coursexhy2 ]
{

/// 代码
Property CrsCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Crs_Code ];

/// 名称
Property CrsDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = Crs_Desc ];

/// 有效标志
Property CrsActive As %String(DISPLAYLIST = "Yes,No", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = Crs_Active ];

Storage Default
{
<Data name="DHCCoursexhy2DefaultData">
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
<DataLocation>^User.DHCCoursexhy2D</DataLocation>
<DefaultData>DHCCoursexhy2DefaultData</DefaultData>
<IdLocation>^User.DHCCoursexhy2D</IdLocation>
<IndexLocation>^User.DHCCoursexhy2I</IndexLocation>
<StreamLocation>^User.DHCCoursexhy2S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
