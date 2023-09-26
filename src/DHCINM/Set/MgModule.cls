/// Creator:
/// Descriptions:系统设置-模块表
/// Date:
Class DHCINM.Set.MgModule Extends %Persistent
{

/// 模块名
Property ModuleDesc As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Module_Desc ];

/// 模块代码
Property ModuleCode As %String [ Required, SqlColumnNumber = 3, SqlFieldName = Module_Code ];

/// 默认加载菜单
Property ModuleMenuDR As DHCINM.Set.MgMenu [ SqlColumnNumber = 4, SqlFieldName = Module_MenuDR ];

/// 显示顺序
Property ModuleSort As %Integer [ Required, SqlColumnNumber = 5, SqlFieldName = Module_Sort ];

/// 启用日期
Property ModuleStDate As %Date [ SqlColumnNumber = 6, SqlFieldName = Module_StDate ];

/// 停用日期
Property ModuleEndDate As %Date [ SqlColumnNumber = 7, SqlFieldName = Module_EndDate ];

/// 是否为高级版：Y:是，N/"":否
Property IsAdvanced As %String [ SqlColumnNumber = 8, SqlFieldName = IsAdvanced ];

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
<Value>ModuleMenuDR</Value>
</Value>
<Value name="5">
<Value>ModuleSort</Value>
</Value>
<Value name="6">
<Value>ModuleStDate</Value>
</Value>
<Value name="7">
<Value>ModuleEndDate</Value>
</Value>
<Value name="8">
<Value>IsAdvanced</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Set.MgModuleD</DataLocation>
<DefaultData>MgModuleDefaultData</DefaultData>
<IdLocation>^DHCINM.Set.MgModuleD</IdLocation>
<IndexLocation>^DHCINM.Set.MgModuleI</IndexLocation>
<StreamLocation>^DHCINM.Set.MgModuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
