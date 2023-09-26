/// 名称: User.DHCCourseDef.cls
/// 描述: 科目默认存储表
/// 编写者: 黄钰
/// 编写日期: 2023-09-12
Class User.DHCCourseDef Extends %Persistent [ SqlRowIdName = Crs_RowID, SqlTableName = DHC_Course_Def ]
{

/// 科目号
Property CrsCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Crs_Code ];

/// 科目名称
Property CrsDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = Crs_Desc ];

/// 是否可用
Property CrsActiveFlag As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ Required, SqlColumnNumber = 4, SqlFieldName = Crs_ActiveFlag ];

Index Code On CrsCode As Exact;

Index Desc On CrsDesc As Exact;

Storage Default
{
<Data name="DHCCourseDefDefaultData">
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
<DataLocation>^User.DHCCourseDefD</DataLocation>
<DefaultData>DHCCourseDefDefaultData</DefaultData>
<IdLocation>^User.DHCCourseDefD</IdLocation>
<IndexLocation>^User.DHCCourseDefI</IndexLocation>
<StreamLocation>^User.DHCCourseDefS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
