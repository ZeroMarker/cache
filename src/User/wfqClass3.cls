/// Function: 科目表（默认Storage）
/// CreateDate: 2023-09-12
/// Creator: 魏方茜
Class User.wfqClass3 Extends (%Persistent, User.Abstract) [ SqlRowIdName = Crs_RowId, SqlTableName = DHC_Coursewfq ]
{

/// 代码
Property CrsCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Crs_Code ];

/// 名称
Property CrsDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = Crs_Desc ];

/// 有效标志
Property CrsActive As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = Crs_Active ];

Storage Default
{
<Data name="wfqClass3DefaultData">
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
</Data>
<DataLocation>^User.wfqclass3D</DataLocation>
<DefaultData>wfqClass3DefaultData</DefaultData>
<IdLocation>^User.wfqclass3D</IdLocation>
<IndexLocation>^User.wfqClass3I</IndexLocation>
<StreamLocation>^User.wfqClass3S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
