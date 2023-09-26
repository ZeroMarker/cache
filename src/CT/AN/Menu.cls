/// 菜单
Class CT.AN.Menu Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Menu ]
{

/// 菜单代码
Property Code As %String [ Required, SqlColumnNumber = 2 ];

/// 菜单名称
Property Description As %String [ Required, SqlColumnNumber = 3 ];

Storage Default
{
<Data name="MenuDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^CT.AN.MenuD</DataLocation>
<DefaultData>MenuDefaultData</DefaultData>
<IdLocation>^CT.AN.MenuD</IdLocation>
<IndexLocation>^CT.AN.MenuI</IndexLocation>
<StreamLocation>^CT.AN.MenuS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
