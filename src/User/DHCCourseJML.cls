/// Function:课程类（默认存储）
/// CreateDate:2023-9-13
/// Creator:蒋美林
Class User.DHCCourseJML Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_Course ]
{

/// 代码
Property CrsCode As %String [ SqlColumnNumber = 2, SqlFieldName = Crs_Code ];

/// 名称
Property CrsDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Crs_Desc ];

/// 有效标志
Property CrsActiveFlag As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = Crs_Active ];

/// 代码索引
Index Code On CrsCode As Exact;

/// 名称索引
Index Desc On CrsDesc As Exact;

Storage Default
{
<Data name="DHCCourseJMLDefaultData">
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
<DataLocation>^User.DHCCourseJMLD</DataLocation>
<DefaultData>DHCCourseJMLDefaultData</DefaultData>
<IdLocation>^User.DHCCourseJMLD</IdLocation>
<IndexLocation>^User.DHCCourseJMLI</IndexLocation>
<StreamLocation>^User.DHCCourseJMLS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
