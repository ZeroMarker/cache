Class User.DHCPECAHandSignLog Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract)
{

Parameter ClassName = "User.DHCPECAHandSignLog";

/// 签名是否有效
Property IsValid As %String;

/// 类型代码   User.DHCPEHandSignMassage的Code
Property Code As %String;

/// 指向 dhc_pe_preiadm
Property CRMID As %String;

Property CreatDate As %Date;

Property CreatTime As %Time;

Property UpdateDate As %Date;

Property UpdateTime As %Time;

/// signValue
/// 签名算法
Property Algorithm As %String(MAXLEN = 999999, TRUNCATE = 1);

/// 生物特征
Property BioFeature As %GlobalCharacterStream(LOCATION = "^DHCPE.AnySignLogS");

/// 事件证书
Property EventCert As %String(MAXLEN = 999999, TRUNCATE = 1);

/// 签名值
Property SigValue As %String(MAXLEN = 32000, TRUNCATE = 1);

/// 时间戳
Property TSValue As %String(MAXLEN = 999999, TRUNCATE = 1);

/// CA产品版本号
Property Version As %String(TRUNCATE = 1);

/// evidenceData
/// 签名笔迹图片
Property SignScript As %GlobalCharacterStream(LOCATION = "^DHCPE.AnySignLogS");

/// 患者头像图片
Property HeaderImage As %GlobalCharacterStream(LOCATION = "^DHCPE.AnySignLogS");

/// 患者指纹图片
Property FingerPrint As %GlobalCharacterStream(LOCATION = "^DHCPE.AnySignLogS");

/// 签名原文
Property PlainText As %String(MAXLEN = 999999, TRUNCATE = 1);

Index TypeADMIndex On (Code As AlphaUp, CRMID);

Index DateTypeIndex On (CreatDate, Code As AlphaUp);

Storage Default
{
<Data name="DHCPECAHandSignLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IsValid</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
<Value name="4">
<Value>CRMID</Value>
</Value>
<Value name="5">
<Value>CreatDate</Value>
</Value>
<Value name="6">
<Value>CreatTime</Value>
</Value>
<Value name="7">
<Value>UpdateDate</Value>
</Value>
<Value name="8">
<Value>UpdateTime</Value>
</Value>
<Value name="9">
<Value>Algorithm</Value>
</Value>
<Value name="10">
<Value>BioFeature</Value>
</Value>
<Value name="11">
<Value>EventCert</Value>
</Value>
<Value name="12">
<Value>SigValue</Value>
</Value>
<Value name="13">
<Value>TSValue</Value>
</Value>
<Value name="14">
<Value>Version</Value>
</Value>
<Value name="15">
<Value>SignScript</Value>
</Value>
<Value name="16">
<Value>HeaderImage</Value>
</Value>
<Value name="17">
<Value>FingerPrint</Value>
</Value>
<Value name="18">
<Value>PlainText</Value>
</Value>
<Value name="19">
<Value>TypeCode</Value>
</Value>
<Value name="20">
<Value>MsgType</Value>
</Value>
<Value name="21">
<Value>Code</Value>
</Value>
</Data>
<DataLocation>^User.DHCPECAHandSignLogD</DataLocation>
<DefaultData>DHCPECAHandSignLogDefaultData</DefaultData>
<IdLocation>^User.DHCPECAHandSignLogD</IdLocation>
<IndexLocation>^User.DHCPECAHandSignLogI</IndexLocation>
<StreamLocation>^User.DHCPECAHandSignLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
