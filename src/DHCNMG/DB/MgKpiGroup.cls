Class DHCNMG.DB.MgKpiGroup Extends %Persistent
{

/// 名称
Property GroupDesc As %String [ SqlColumnNumber = 2, SqlFieldName = Group_Desc ];

/// 病区
Property GroupWardDR As list Of %String [ SqlColumnNumber = 3, SqlFieldName = Group_WardDR ];

Storage Default
{
<Data name="MgKpiGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GroupDesc</Value>
</Value>
<Value name="3">
<Value>GroupWardDR</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgKpiGroupD</DataLocation>
<DefaultData>MgKpiGroupDefaultData</DefaultData>
<IdLocation>^DHCNMG.DB.MgKpiGroupD</IdLocation>
<IndexLocation>^DHCNMG.DB.MgKpiGroupI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgKpiGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
