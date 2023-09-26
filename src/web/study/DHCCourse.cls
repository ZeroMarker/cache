Class web.study.DHCCourse Extends (%Persistent, User.Abstract) [ SqlRowIdName = Crs_RowID, SqlTableName = DHC_Course ]
{

/// 崔兴阳 基础平台
/// Crs_Code,Crs_Desc,Crs_ActiveFlag(Y/N)
Property CrsCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Crs_Code ];

Property CrsDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = Crs_Desc ];

Property CrsActiveFlag As %String(DISPLAYLIST = ",Y,N", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = Crs_ActiveFlag ];

Index Code On CrsCode As Exact;

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
<Value>CrsActiveFlag</Value>
</Value>
</Data>
<DataLocation>^web.study.DHCCourseD</DataLocation>
<DefaultData>DHCCourseDefaultData</DefaultData>
<IdLocation>^web.study.DHCCourseD</IdLocation>
<IndexLocation>^web.study.DHCCourseI</IndexLocation>
<StreamLocation>^web.study.DHCCourseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
