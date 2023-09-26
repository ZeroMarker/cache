/// Function:课程类（默认存储）
/// CreateDate:2023-9-15
/// Creator:刘酝泽
Class User.DHCCourseLYZ Extends %Persistent [ SqlTableName = DHC_Course_LYZ ]
{

Property CrsCode As %String [ SqlColumnNumber = 2, SqlFieldName = Crs_Code ];

Property CrsDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Crs_Desc ];

Property CrsActiveFlag As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = Crs_Active ];

Index Code On CrsCode As Exact;

Index Desc On CrsDesc As Exact;

Storage Default
{
<Data name="DHCCourseLYZDefaultData">
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
<DataLocation>^User.DHCCourseLYZD</DataLocation>
<DefaultData>DHCCourseLYZDefaultData</DefaultData>
<IdLocation>^User.DHCCourseLYZD</IdLocation>
<IndexLocation>^User.DHCCourseLYZI</IndexLocation>
<StreamLocation>^User.DHCCourseLYZS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
