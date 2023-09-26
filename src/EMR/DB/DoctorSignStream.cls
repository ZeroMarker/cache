/// 名称:	EMR.DB.DoctorSignStream
/// 描述:	医护数据签名
/// 编写者：yejian
/// 编写日期: 2022-9-6
/// 产品组：电子病历产品组
Class EMR.DB.DoctorSignStream Extends %Persistent
{

Index IdxMain On SignID;

/// 患者签
Property SignID As CA.DigitalSignature;

/// 摘要（病历哈希）
Property Digest As %String(MAXLEN = 32000, TRUNCATE = 0);

/// 病历原文
Property DocumentData As %GlobalBinaryStream(LOCATION = "^EMR.DB.DoctorSignStreamS");

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
<DataLocation>^EMR.DB.DoctorSignStreamD</DataLocation>
<DefaultData>DoctorSignStreamDefaultData</DefaultData>
<IdLocation>^EMR.DB.DoctorSignStreamD</IdLocation>
<IndexLocation>^EMR.DB.DoctorSignStreamI</IndexLocation>
<StreamLocation>^EMR.DB.DoctorSignStreamS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
