/// creator:xbl
/// date:20170713
/// desc:菜单
Class DHCNMG.Set.MgMenu Extends %Persistent
{

Relationship ChildSub As DHCNMG.Set.MgMenuElement [ Cardinality = children, Inverse = Parref ];

/// 菜单代码
Property MenuCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Menu_Code ];

/// 菜单描述
Property MenuDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = Menu_Desc ];

/// 所属模块
Property MenuModuleDR As DHCNMG.Set.MgModule [ Required, SqlColumnNumber = 4, SqlFieldName = Menu_ModuleDR ];

/// 父节点
Property MenuParentDR As DHCNMG.Set.MgMenu [ SqlColumnNumber = 5, SqlFieldName = Menu_ParentDR ];

/// 组件名称
Property MenuComponent As %String [ Required, SqlColumnNumber = 6, SqlFieldName = Menu_Component ];

/// 路由
Property MenuRouter As %String [ Required, SqlColumnNumber = 7, SqlFieldName = Menu_Router ];

/// 链接
Property MenuLink As %String [ SqlColumnNumber = 8, SqlFieldName = Menu_Link ];

/// 参数
Property MenuParams As %String [ SqlColumnNumber = 9, SqlFieldName = Menu_Params ];

/// 图标
Property MenuIcon As %String [ SqlColumnNumber = 10, SqlFieldName = Menu_Icon ];

/// 排序
Property MenuSort As %Integer [ SqlColumnNumber = 11, SqlFieldName = Menu_Sort ];

/// 启用日期
Property MenuStDate As %Date [ SqlColumnNumber = 12, SqlFieldName = Menu_StDate ];

/// 结束日期
Property MenuEndDate As %Date [ SqlColumnNumber = 13, SqlFieldName = Menu_EndDate ];

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
<Value>MenuComponent</Value>
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
<Value>MenuStdate</Value>
</Value>
<Value name="12">
<Value>MenuEnddate</Value>
</Value>
<Value name="13">
<Value>MenuRouter</Value>
</Value>
<Value name="14">
<Value>MenuStDate</Value>
</Value>
<Value name="15">
<Value>MenuEndDate</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Set.MgMenuD</DataLocation>
<DefaultData>MgMenuDefaultData</DefaultData>
<IdLocation>^DHCNMG.Set.MgMenuD</IdLocation>
<IndexLocation>^DHCNMG.Set.MgMenuI</IndexLocation>
<StreamLocation>^DHCNMG.Set.MgMenuS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
