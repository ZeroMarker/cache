/// Function:课程表  （默认存储）
/// CreateDate:2023-09-12
/// Creator:谢海洋
Class User.DHCCoursexhy Extends %Persistent [ SqlTableName = DHC_Coursexhy ]
{

/// 代码
Property CrsCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Crs_Code ];

/// 名称
Property CrsDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = Crs_Desc ];

/// 有效标志
Property CrsActive As %String(DISPLAYLIST = "Yes,No", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = Crs_Active ];

Storage Default
{
<Data name="DHCCoursexhyDefaultData">
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
<DataLocation>^User.DHCCoursexhyD</DataLocation>
<DefaultData>DHCCoursexhyDefaultData</DefaultData>
<IdLocation>^User.DHCCoursexhyD</IdLocation>
<IndexLocation>^User.DHCCoursexhyI</IndexLocation>
<StreamLocation>^User.DHCCoursexhyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
