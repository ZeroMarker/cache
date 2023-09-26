Class User.GZYDHCCourse Extends %Persistent [ SqlRowIdName = Crs_RowId, SqlTableName = GZY_DHC_Course ]
{

Property CrsCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Crs_Code ];

Property CrsDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = Crs_Desc ];

Property CrsActiveFlag As %String(VALUELIST = ",Y,N") [ Required, SqlColumnNumber = 4, SqlFieldName = Crs_ActiveFlag ];

Index Code On CrsCode As Exact;

Index Desc On CrsDesc As Exact;

Storage Default
{
<Data name="GZYDHCCourseDefaultData">
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
<DataLocation>^User.GZYDHCCourseD</DataLocation>
<DefaultData>GZYDHCCourseDefaultData</DefaultData>
<IdLocation>^User.GZYDHCCourseD</IdLocation>
<IndexLocation>^User.GZYDHCCourseI</IndexLocation>
<StreamLocation>^User.GZYDHCCourseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
