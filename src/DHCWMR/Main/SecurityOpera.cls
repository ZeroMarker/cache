/// 描述: 病案管理菜单操作权限表
Class DHCWMR.Main.SecurityOpera Extends (%Persistent, DHCWMR.Abstract) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

/// 安全组指针
Property SSGroupDr As %Integer [ Required ];

/// 菜单操作指针  DHCWMR.SS.MenuOperation
Property MenuOperaDr As %Integer [ Required ];

/// 权限
Property Authority As %Boolean;

Index IndexOfGOpera On (SSGroupDr, MenuOperaDr) [ Unique ];

Storage Default
{
<Data name="SecurityOperaDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SSGroupDr</Value>
</Value>
<Value name="3">
<Value>MenuOperaDr</Value>
</Value>
<Value name="4">
<Value>Authority</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.Main.SecurityOperaD</DataLocation>
<DefaultData>SecurityOperaDefaultData</DefaultData>
<IdLocation>^DHCWMR.Main.SecurityOperaD</IdLocation>
<IndexLocation>^DHCWMR.Main.SecurityOperaI</IndexLocation>
<StreamLocation>^DHCWMR.Main.SecurityOperaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
