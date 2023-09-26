/// Function:课程类（默认存储）
/// CreateDate:2023-9-13
/// Creator:蔡耀伟
Class User.DHCCourseCYW Extends (%Persistent, User.Abstract) [ SqlRowIdName = Crs_RowId, SqlTableName = DHC_CourseCYW ]
{

/// 代码
Property CrsCode As %String [ SqlColumnNumber = 2, SqlFieldName = Crs_Code ];

/// 名称
Property CrsDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Crs_Desc ];

/// 有效标志
Property CrsActiveFlag As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = Crs_ActiveFlag ];

/// 代码索引
Index Code On CrsCode As Exact;

/// 名称索引
Index Desc On CrsDesc As Exact;

Storage Default
{
<Data name="DHCCourseCYWDefaultData">
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
<DataLocation>^User.DHCCourseCYWD</DataLocation>
<DefaultData>DHCCourseCYWDefaultData</DefaultData>
<IdLocation>^User.DHCCourseCYWD</IdLocation>
<IndexLocation>^User.DHCCourseCYWI</IndexLocation>
<StreamLocation>^User.DHCCourseCYWS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
