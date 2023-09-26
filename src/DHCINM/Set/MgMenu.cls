/// Creator:
/// Descriptions:系统设置-菜单表
/// Date:
Class DHCINM.Set.MgMenu Extends %Persistent
{

Relationship ChildSub As DHCINM.Set.MgMenuElement [ Cardinality = children, Inverse = Parref ];

/// 菜单代码
Property MenuCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Menu_Code ];

/// 菜单描述
Property MenuDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = Menu_Desc ];

/// 所属模块
Property MenuModuleDR As DHCINM.Set.MgModule [ Required, SqlColumnNumber = 4, SqlFieldName = Menu_ModuleDR ];

/// 父节点
Property MenuParentDR As DHCINM.Set.MgMenu [ SqlColumnNumber = 5, SqlFieldName = Menu_ParentDR ];

/// 路由名称【应具有唯一性】
Property MenuRouter As %String [ SqlColumnNumber = 6, SqlFieldName = Menu_Router ];

/// 链接【关联第三方链接，暂时未使用】
Property MenuLink As %String [ SqlColumnNumber = 7, SqlFieldName = Menu_Link ];

/// 参数
Property MenuParams As %String [ SqlColumnNumber = 8, SqlFieldName = Menu_Params ];

/// 图标
Property MenuIcon As %String [ SqlColumnNumber = 9, SqlFieldName = Menu_Icon ];

/// 排序
Property MenuSort As %Integer [ SqlColumnNumber = 10, SqlFieldName = Menu_Sort ];

/// 启用日期
Property MenuStDate As %Date [ SqlColumnNumber = 11, SqlFieldName = Menu_StDate ];

/// 结束日期
Property MenuEndDate As %Date [ SqlColumnNumber = 12, SqlFieldName = Menu_EndDate ];

/// 组件路径【末端菜单路径，如果为文件夹可为空。】
Property MenuPath As %String [ SqlColumnNumber = 13, SqlFieldName = Menu_Path ];

/// 是否为高级版：Y:是，N/"":否
Property IsAdvanced As %String [ SqlColumnNumber = 14, SqlFieldName = IsAdvanced ];

Index Code On MenuCode [ Unique ];

Index Module On MenuModuleDR;

Index ParentSort On (MenuParentDR, MenuSort) [ Condition = {Menu_Parent_DR'=""} ];

Index ModuleSort On (MenuModuleDR, MenuSort);

Index route On MenuRouter;

Storage Default
{
<Data name="MgMenuDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MenuCode</Value>
</Value>
<Value name="3">
<Value>MenuDesc</Value>
</Value>
<Value name="4">
<Value>MenuModuleDR</Value>
</Value>
<Value name="5">
<Value>MenuParentDR</Value>
</Value>
<Value name="6">
<Value>MenuRouter</Value>
</Value>
<Value name="7">
<Value>MenuLink</Value>
</Value>
<Value name="8">
<Value>MenuParams</Value>
</Value>
<Value name="9">
<Value>MenuIcon</Value>
</Value>
<Value name="10">
<Value>MenuSort</Value>
</Value>
<Value name="11">
<Value>MenuStDate</Value>
</Value>
<Value name="12">
<Value>MenuEndDate</Value>
</Value>
<Value name="13">
<Value>MenuPath</Value>
</Value>
<Value name="14">
<Value>IsAdvanced</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Set.MgMenuD</DataLocation>
<DefaultData>MgMenuDefaultData</DefaultData>
<IdLocation>^DHCINM.Set.MgMenuD</IdLocation>
<IndexLocation>^DHCINM.Set.MgMenuI</IndexLocation>
<StreamLocation>^DHCINM.Set.MgMenuS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
