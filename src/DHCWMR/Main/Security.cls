/// 描述: 病案管理菜单权限表
Class DHCWMR.Main.Security Extends (%Persistent, DHCWMR.Abstract) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

/// 安全组指针
Property SSGroupDr As %Integer [ Required ];

/// 产品指针
Property ProductDr As %Integer [ Required ];

/// 菜单指针
Property MenuDr As %Integer [ Required ];

/// 权限
Property Authority As %Boolean;

Index IndexOfGPM On (SSGroupDr, ProductDr, MenuDr);

Index IndexOfMenu On (SSGroupDr, MenuDr) [ Unique ];

Storage Default
{
<Data name="SecurityDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SSGroupDr</Value>
</Value>
<Value name="3">
<Value>ProductDr</Value>
</Value>
<Value name="4">
<Value>MenuDr</Value>
</Value>
<Value name="5">
<Value>Authority</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.Main.SecurityD</DataLocation>
<DefaultData>SecurityDefaultData</DefaultData>
<IdLocation>^DHCWMR.Main.SecurityD</IdLocation>
<IndexLocation>^DHCWMR.Main.SecurityI</IndexLocation>
<StreamLocation>^DHCWMR.Main.SecurityS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
