/// desc 第三方CDSS工具维护
/// creator duan
/// createDate 2020-06-03
Class EMRmeta.CDSS.CDSSTool Extends %Persistent
{

Index CDSSToolActive On IsActive;

Index CDSSActive On (CDSSTool, IsActive);

/// 维护第三方工具标识（CDSSHM:惠每 ,CDSSBD:百度CDSS, CDSSDH:东华CDSS）
Property CDSSTool As %String;

/// 是否启用 1 启用 0 不启用
Property IsActive As %String;

/// CDSS需要的标准参数
Property Paramter As %String(MAXLEN = 100);

/// 第三方工具的开关控制
Property CDSSLock As %String(MAXLEN = 10000);

Storage Default
{
<Data name="CDSSToolDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CDSSTool</Value>
</Value>
<Value name="3">
<Value>IsActive</Value>
</Value>
<Value name="4">
<Value>Paramter</Value>
</Value>
<Value name="5">
<Value>CDSSLock</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.CDSSToolD</DataLocation>
<DefaultData>CDSSToolDefaultData</DefaultData>
<IdLocation>^DHCEMRM.CDSSToolD</IdLocation>
<IndexLocation>^DHCEMRM.CDSSToolI</IndexLocation>
<StreamLocation>^DHCEMRM.CDSSToolS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
