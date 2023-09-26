/// 描述: 病案管理菜单表
Class DHCWMR.Main.Menus Extends (%Persistent, DHCWMR.Abstract) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

/// 菜单代码
Property MenuCode As %String(TRUNCATE = 1) [ Required ];

/// 菜单名称
Property MenuCaption As %String(TRUNCATE = 1) [ Required ];

/// 目标地址
Property LinkUrl As %String(TRUNCATE = 1);

/// 表达式
Property Expression As %String(MAXLEN = 100, TRUNCATE = 1);

/// 产品指针
Property ProductDr As %Integer [ Required ];

/// 显示顺序
Property ShowIndex As %Integer;

/// 图标样式
Property IconClass As %String(TRUNCATE = 1);

/// 父菜单指针
Property ParentMenuDr As %Integer;

Index MenuCodeIndex On MenuCode [ Unique ];

Index IndexProParentIndex On (ProductDr, ParentMenuDr, ShowIndex);

Storage Default
{
<Data name="MenusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MenuCode</Value>
</Value>
<Value name="3">
<Value>MenuCaption</Value>
</Value>
<Value name="4">
<Value>LinkUrl</Value>
</Value>
<Value name="5">
<Value>Expression</Value>
</Value>
<Value name="6">
<Value>ProductDr</Value>
</Value>
<Value name="7">
<Value>ShowIndex</Value>
</Value>
<Value name="8">
<Value>IconClass</Value>
</Value>
<Value name="9">
<Value>ParentMenuDr</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.Main.MenusD</DataLocation>
<DefaultData>MenusDefaultData</DefaultData>
<IdLocation>^DHCWMR.Main.MenusD</IdLocation>
<IndexLocation>^DHCWMR.Main.MenusI</IndexLocation>
<StreamLocation>^DHCWMR.Main.MenusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
