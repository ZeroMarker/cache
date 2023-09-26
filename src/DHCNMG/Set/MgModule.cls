/// creator:xbl
/// createdate:20170710
/// description:模块
Class DHCNMG.Set.MgModule Extends %Persistent
{

/// 模块名
Property ModuleDesc As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Module_Desc ];

/// 模块代码
Property ModuleCode As %String [ Required, SqlColumnNumber = 3, SqlFieldName = Module_Code ];

/// 默认加载菜单
Property ModuleMenuDR As DHCNMG.Set.MgMenu [ SqlColumnNumber = 4, SqlFieldName = Module_MenuDR ];

/// 显示顺序
Property ModuleSort As %Integer [ Required, SqlColumnNumber = 5, SqlFieldName = Module_Sort ];

/// 启用日期
Property ModuleStDate As %Date [ SqlColumnNumber = 6, SqlFieldName = Module_StDate ];

/// 停用日期
Property ModuleEndDate As %Date [ SqlColumnNumber = 7, SqlFieldName = Module_EndDate ];

/// 路径
Property ModulePath As %String [ SqlColumnNumber = 8, SqlFieldName = Module_Path ];

Index Code On ModuleCode [ Unique ];

Index Sort On ModuleSort [ Unique ];

Storage Default
{
<Data name="MgModuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ModuleDesc</Value>
</Value>
<Value name="3">
<Value>ModuleCode</Value>
</Value>
<Value name="4">
<Value>ModuleSort</Value>
</Value>
<Value name="5">
<Value>ModuleMenuDR</Value>
</Value>
<Value name="6">
<Value>ModuleStDate</Value>
</Value>
<Value name="7">
<Value>ModuleEndDate</Value>
</Value>
<Value name="8">
<Value>ModulePath</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Set.MgModuleD</DataLocation>
<DefaultData>MgModuleDefaultData</DefaultData>
<IdLocation>^DHCNMG.Set.MgModuleD</IdLocation>
<IndexLocation>^DHCNMG.Set.MgModuleI</IndexLocation>
<StreamLocation>^DHCNMG.Set.MgModuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
