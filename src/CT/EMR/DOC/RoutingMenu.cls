/// 名称:	CT.EMR.DOC.RoutingMenu
/// 描述:	通用文档管理模块 Document(Doc) 菜单管理
/// 编写者：yejian
/// 编写日期: 2020-11-9
Class CT.EMR.DOC.RoutingMenu Extends %Persistent
{

Index IdxParentId On ParentId;

Index IdxRowId On (ParentId, OrderNum);

/// 菜单ID
/// Property MenuId As %Integer;
/// 菜单名称
Property MenuName As %String(TRUNCATE = 1);

/// 父菜单Id
Property ParentId As %Integer;

/// 显示顺序
Property OrderNum As %Integer;

/// 路由地址
Property Path As %String(TRUNCATE = 1);

/// 路由参数
Property Params As %String(TRUNCATE = 1);

/// 组件路径
Property Component As %String(TRUNCATE = 1);

/// 菜单类型（M目录，C菜单，F按钮）
Property MenuType As %String(TRUNCATE = 1);

/// 菜单状态（0显示，1隐藏）
Property Visible As %String(TRUNCATE = 1);

/// 菜单状态（0正常，1停用）
Property Status As %String(TRUNCATE = 1);

/// 权限标识
Property Perms As %String(TRUNCATE = 1);

/// 菜单图标
Property Icon As %String(TRUNCATE = 1);

/// 创建者
Property CreatBy As %String(TRUNCATE = 1);

/// 创建时间
Property CreatTime As %String(TRUNCATE = 1);

/// 更新者
Property UpdateBy As %String(TRUNCATE = 1);

/// 更新时间
Property UpdateTime As %String(TRUNCATE = 1);

/// 备注
/// Property Remark As %String(TRUNCATE = 1);
/// 是否删除（0未删除, 1已删除）
Property IsExist As %String(TRUNCATE = 1);

Storage Default
{
<Data name="RoutingMenuDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MenuId</Value>
</Value>
<Value name="3">
<Value>MenuName</Value>
</Value>
<Value name="4">
<Value>ParentId</Value>
</Value>
<Value name="5">
<Value>OrderNum</Value>
</Value>
<Value name="6">
<Value>Path</Value>
</Value>
<Value name="7">
<Value>Params</Value>
</Value>
<Value name="8">
<Value>Component</Value>
</Value>
<Value name="9">
<Value>MenuType</Value>
</Value>
<Value name="10">
<Value>Visible</Value>
</Value>
<Value name="11">
<Value>Status</Value>
</Value>
<Value name="12">
<Value>Perms</Value>
</Value>
<Value name="13">
<Value>Icon</Value>
</Value>
<Value name="14">
<Value>CreatBy</Value>
</Value>
<Value name="15">
<Value>CreatTime</Value>
</Value>
<Value name="16">
<Value>UpdateBy</Value>
</Value>
<Value name="17">
<Value>UpdateTime</Value>
</Value>
<Value name="18">
<Value>IsExist</Value>
</Value>
</Data>
<DataLocation>^CT.EMR.DOC.RoutingMenuD</DataLocation>
<DefaultData>RoutingMenuDefaultData</DefaultData>
<IdLocation>^CT.EMR.DOC.RoutingMenuD</IdLocation>
<IndexLocation>^CT.EMR.DOC.RoutingMenuI</IndexLocation>
<StreamLocation>^CT.EMR.DOC.RoutingMenuS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
