/// Description:	课程类 (DefaultStorage)
/// CreateDate:	2023年9月12日
/// Creator:		赵子豪
Class User.DHCCourseZZHDefault Extends %Persistent [ SqlRowIdName = Crs_RowID, SqlTableName = DHC_CourseZZH1 ]
{

/// 代码
Property CrsCode As %String [ SqlColumnNumber = 2, SqlFieldName = Crs_Code ];

/// 名称
Property CrsDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Crs_Desc ];

/// 激活标致
Property CrsActiveFlag As %String(VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = Crs_ActiveFlag ];

/// 索引
Index Code On CrsCode As Exact;

Index Desc On CrsDesc As Exact;

Storage Default
{
<Data name="DHCCourseZZHDefaultDefaultData">
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
<DataLocation>^User.DHCCourseZZHDefaultD</DataLocation>
<DefaultData>DHCCourseZZHDefaultDefaultData</DefaultData>
<IdLocation>^User.DHCCourseZZHDefaultD</IdLocation>
<IndexLocation>^User.DHCCourseZZHDefaultI</IndexLocation>
<StreamLocation>^User.DHCCourseZZHDefaultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
