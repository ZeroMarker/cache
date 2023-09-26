/// 名称:	EMR.DB.AnySign
/// 描述:	患者数据签名
/// 编写者：yejian
/// 编写日期: 2022-9-6
/// 产品组：电子病历产品组
Class EMR.DB.PatientSignStream Extends %Persistent
{

Index IdxMain On SignID;

/// 患者签
Property SignID As EMR.DB.PatientSign;

/// 摘要（病历哈希）
Property Digest As %String(MAXLEN = 32000, TRUNCATE = 0);

/// 病历原文
Property DocumentData As %GlobalBinaryStream(LOCATION = "^EMR.DB.PatientSignStreamS");

Storage Default
{
<Data name="PatientSignStreamDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Digest</Value>
</Value>
<Value name="3">
<Value>DocumentData</Value>
</Value>
<Value name="4">
<Value>PatientSign</Value>
</Value>
<Value name="5">
<Value>SignID</Value>
</Value>
</Data>
<DataLocation>^EMR.DB.PatientSignStreamD</DataLocation>
<DefaultData>PatientSignStreamDefaultData</DefaultData>
<IdLocation>^EMR.DB.PatientSignStreamD</IdLocation>
<IndexLocation>^EMR.DB.PatientSignStreamI</IndexLocation>
<StreamLocation>^EMR.DB.PatientSignStreamS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
