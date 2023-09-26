/// Desc:    his 医师级别与电子病历签名级别对照表
/// Creator: candy 
Class EMRmeta.SignRoleLinkCarPrvTp Extends (%Persistent, %XML.Adaptor)
{

Index IdxSignRoleCarPrvTp On (SignRoleCode, CarPrvTpCode);

Index IdxCarPrvTpSignRole On (CarPrvTpCode, SignRoleCode);

/// EMRmea.SignRole Code
Property SignRoleCode As %String;

/// CT_CarPrvTp Code
Property CarPrvTpCode As %String;

Storage Default
{
<Data name="SignRoleLinkCarPrvTpDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SignRoleCode</Value>
</Value>
<Value name="3">
<Value>CarPrvTpCode</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.SignRoleLinkCarPrvTpD</DataLocation>
<DefaultData>SignRoleLinkCarPrvTpDefaultData</DefaultData>
<IdLocation>^DHCEMRM.SignRoleLinkCarPrvTpD</IdLocation>
<IndexLocation>^DHCEMRM.SignRoleLinkCarPrvTpI</IndexLocation>
<StreamLocation>^DHCEMRM.SignRoleLinkCarPrvTpS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
