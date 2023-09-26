/// creator:llin
/// createdate:2018-08-06
/// desc:科室病区关联表
Class DHCNMG.DB.MgWardLocUnit Extends %Persistent
{

/// 病区ID
Property UnitWardDR As %Integer [ SqlColumnNumber = 2, SqlFieldName = Unit_WardDR ];

/// 科室ID
Property UnitLocDR As %Integer [ SqlColumnNumber = 3, SqlFieldName = Unit_LocDR ];

/// 备注
Property UnitDesc As %String [ SqlColumnNumber = 4, SqlFieldName = Unit_Desc ];

Index Loc On (UnitLocDR, UnitWardDR);

Index Ward On (UnitWardDR, UnitLocDR);

Storage Default
{
<Data name="MgWardLocUnitDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UnitWardDR</Value>
</Value>
<Value name="3">
<Value>UnitLocDR</Value>
</Value>
<Value name="4">
<Value>UnitDesc</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgWardLocUnitD</DataLocation>
<DefaultData>MgWardLocUnitDefaultData</DefaultData>
<IdLocation>^DHCNMG.DB.MgWardLocUnitD</IdLocation>
<IndexLocation>^DHCNMG.DB.MgWardLocUnitI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgWardLocUnitS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
