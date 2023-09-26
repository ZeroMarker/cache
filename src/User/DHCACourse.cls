/// Foution：科室表（默认存储）
/// CreateDate:2023-09-12
/// Creator:翁瑞珍
Class User.DHCACourse Extends (%Persistent, User.Abstract) [ SqlRowIdName = Crs_Rowid, SqlTableName = DHCA_Course ]
{

/// 代码
Property CrsCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Crs_Code ];

/// 名称
Property CrsDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Crs_Desc ];

/// 有效标志
Property CrsActiveFlag As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = Crs_ActiveFlag ];

/// 日期
Property CrsDob As %Date [ SqlColumnNumber = 5, SqlFieldName = Crs_Dob ];

/// 增加索引
Index Code On CrsCode As Exact;

Index Desc On CrsDesc As Exact;

Storage Default
{
<Data name="DHCACourseDefaultData">
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
<Value name="5">
<Value>CrsDob</Value>
</Value>
</Data>
<DataLocation>^User.DHCACourseD</DataLocation>
<DefaultData>DHCACourseDefaultData</DefaultData>
<IdLocation>^User.DHCACourseD</IdLocation>
<IndexLocation>^User.DHCACourseI</IndexLocation>
<StreamLocation>^User.DHCACourseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
