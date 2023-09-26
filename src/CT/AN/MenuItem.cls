/// 菜单项
Class CT.AN.MenuItem Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = MenuItem ]
{

/// 菜单
Property Menu As CT.AN.Menu [ Required, SqlColumnNumber = 2 ];

/// 菜单项代码
Property Code As %String [ Required, SqlColumnNumber = 3 ];

/// 菜单项名称
Property Description As %String [ Required, SqlColumnNumber = 4 ];

/// 链接模块
Property LinkModule As CT.AN.DataModule [ SqlColumnNumber = 5 ];

/// 链接的页面
Property Url As %String [ SqlColumnNumber = 6 ];

/// 参数表达式
Property Exp As %String(MAXLEN = 200) [ SqlColumnNumber = 7 ];

/// 主菜单
Property MainItem As CT.AN.MenuItem [ SqlColumnNumber = 8 ];

/// 显示名称
Property DisplayName As %String [ SqlColumnNumber = 9 ];

/// 数据归属
Property DataAttribution As CF.AN.DataAttribution [ SqlColumnNumber = 10 ];

/// 菜单索引
Index IMenu On Menu;

/// 代码唯一性约束
Index ICode On Code [ Unique ];

/// 菜单外键约束
ForeignKey FKMenu(Menu) References CT.AN.Menu() [ OnDelete = cascade ];

Storage Default
{
<Data name="MenuItemDefaultData">
<Value name="1">
<Value>Menu</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>LinkModule</Value>
</Value>
<Value name="5">
<Value>Url</Value>
</Value>
<Value name="6">
<Value>Exp</Value>
</Value>
<Value name="7">
<Value>MainItem</Value>
</Value>
<Value name="8">
<Value>DisplayName</Value>
</Value>
<Value name="9">
<Value>DataAttribution</Value>
</Value>
</Data>
<DataLocation>^CT.AN.MenuItemD</DataLocation>
<DefaultData>MenuItemDefaultData</DefaultData>
<IdLocation>^CT.AN.MenuItemD</IdLocation>
<IndexLocation>^CT.AN.MenuItemI</IndexLocation>
<StreamLocation>^CT.AN.MenuItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
