/// 描述: 病案管理菜单操作表
Class DHCWMR.Main.MenuOperation Extends (%Persistent, DHCWMR.Abstract) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

/// 菜单指针
Property MenuDr As %Integer [ Required ];

/// 操作代码
Property OperaCode As %String(TRUNCATE = 1) [ Required ];

/// 操作名称
Property OperaName As %String(TRUNCATE = 1);

Index IndexOfMenuOpera On (MenuDr, OperaCode) [ Unique ];

Storage Default
{
<Data name="MenuOperationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MenuDr</Value>
</Value>
<Value name="3">
<Value>OperaCode</Value>
</Value>
<Value name="4">
<Value>OperaName</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.Main.MenuOperationD</DataLocation>
<DefaultData>MenuOperationDefaultData</DefaultData>
<IdLocation>^DHCWMR.Main.MenuOperationD</IdLocation>
<IndexLocation>^DHCWMR.Main.MenuOperationI</IndexLocation>
<StreamLocation>^DHCWMR.Main.MenuOperationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
