Class web.study.DHCCourseGZY Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_Course_GZY ]
{

Property CrsCode As %String [ SqlColumnNumber = 2, SqlFieldName = Crs_Code ];

Property CrsDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Crs_Desc ];

Property CrsActiveFlag As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = Crs_ActiveFlag ];

Index Code On CrsCode As Exact;

Index Desc On CrsDesc As Exact;

Storage Default
{
<Data name="DHCCourseGZYDefaultData">
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
<DataLocation>^web.study.DHCCourseGZYD</DataLocation>
<DefaultData>DHCCourseGZYDefaultData</DefaultData>
<IdLocation>^web.study.DHCCourseGZYD</IdLocation>
<IndexLocation>^web.study.DHCCourseGZYI</IndexLocation>
<StreamLocation>^web.study.DHCCourseGZYS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
