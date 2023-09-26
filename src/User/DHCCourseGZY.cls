Class User.DHCCourseGZY Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_Course_GZY123 ]
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
<Value>CrsActive</Value>
</Value>
<Value name="5">
<Value>CrsActiveFlag</Value>
</Value>
</Data>
<DataLocation>^User.DHCCourseGZYD</DataLocation>
<DefaultData>DHCCourseGZYDefaultData</DefaultData>
<IdLocation>^User.DHCCourseGZYD</IdLocation>
<IndexLocation>^User.DHCCourseGZYI</IndexLocation>
<SqlRowIdName>Crs_RowId</SqlRowIdName>
<StreamLocation>^User.DHCCourseGZYS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
