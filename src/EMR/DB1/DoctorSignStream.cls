/// 名称:	EMR.DB1.DoctorSignStream
/// 描述:	医护数据签名
/// 编写者：yejian
/// 编写日期: 2022-9-6
/// 产品组：电子病历产品组
Class EMR.DB1.DoctorSignStream Extends %Persistent
{

Index IdxMain On SignID;

/// 患者签
Property SignID As CA.DigitalSignature;

/// 摘要（病历哈希）
Property Digest As %String(MAXLEN = 32000, TRUNCATE = 0);

/// 病历原文
Property DocumentData As %GlobalBinaryStream(LOCATION = "^EMR.DB1.DoctorSignStreamS");

Storage Default
{
<Data name="DoctorSignStreamDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SignID</Value>
</Value>
<Value name="3">
<Value>Digest</Value>
</Value>
<Value name="4">
<Value>DocumentData</Value>
</Value>
</Data>
<DataLocation>^EMR.DB1.DoctorSignStreamD</DataLocation>
<DefaultData>DoctorSignStreamDefaultData</DefaultData>
<IdLocation>^EMR.DB1.DoctorSignStreamD</IdLocation>
<IndexLocation>^EMR.DB1.DoctorSignStreamI</IndexLocation>
<StreamLocation>^EMR.DB1.DoctorSignStreamS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
