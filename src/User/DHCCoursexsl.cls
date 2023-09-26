Class User.DHCCoursexsl Extends %Persistent [ SqlTableName = DHC_Coursexsl ]
{

Property CrsCode As %String [ SqlColumnNumber = 2, SqlFieldName = Crs_Code ];

Property CrsDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Crs_Desc ];

Property CrsActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = Crs_ActiveFlag ];

Index CrsCodeInx On CrsCode As EXACT;

Index CrsDescInx On CrsDesc As EXACT;

Storage Default
{
<Data name="DHCCoursexslDefaultData">
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
<DataLocation>^User.DHCCoursexslD</DataLocation>
<DefaultData>DHCCoursexslDefaultData</DefaultData>
<IdLocation>^User.DHCCoursexslD</IdLocation>
<IndexLocation>^User.DHCCoursexslI</IndexLocation>
<StreamLocation>^User.DHCCoursexslS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
