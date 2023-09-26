/// 名称:	EMR.DB.PatientSign
/// 描述:	患者数据签名
/// 编写者：yejian
/// 编写日期: 2022-9-6
/// 产品组：电子病历产品组
Class EMR.DB.PatientSign Extends %Persistent
{

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 第三方版本
Property Version As %String(TRUNCATE = 1);

/// 记录ca的算法
Property Algorithm As %String(MAXLEN = 32000, TRUNCATE = 1);

/// 事件证书
Property EventCert As %String(MAXLEN = 32000, TRUNCATE = 1);

/// CA签名值
Property SignValue As %String(MAXLEN = 32000, TRUNCATE = 1);

/// 时间戳
Property TSValue As %String(MAXLEN = 32000, TRUNCATE = 1);

/// 摘要（病历哈希）
Property Digest As %String(MAXLEN = 32000, TRUNCATE = 0);

/// 生物特征(比如指纹、人脸图解析出特征值)
Property BioFeature As %GlobalCharacterStream(LOCATION = "^EMR.DB.PatientSignS");

/// 笔迹图
Property SignScript As %GlobalCharacterStream(LOCATION = "^EMR.DB.PatientSignS");

/// 拍照图
Property HeaderImage As %GlobalCharacterStream(LOCATION = "^EMR.DB.PatientSignS");

/// 指纹图
Property FingerPrint As %GlobalCharacterStream(LOCATION = "^EMR.DB.PatientSignS");

/// 整个签名数据包（某些厂商“生物特征、笔迹图、拍照图、指纹图”等是整体存储）
Property SignData As %GlobalCharacterStream(LOCATION = "^EMR.DB.PatientSignS");

Storage Default
{
<Data name="PatientSignDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CreateDate</Value>
</Value>
<Value name="3">
<Value>CreateTime</Value>
</Value>
<Value name="4">
<Value>Version</Value>
</Value>
<Value name="5">
<Value>Algorithm</Value>
</Value>
<Value name="6">
<Value>EventCert</Value>
</Value>
<Value name="7">
<Value>SignValue</Value>
</Value>
<Value name="8">
<Value>TSValue</Value>
</Value>
<Value name="9">
<Value>Digest</Value>
</Value>
<Value name="10">
<Value>BioFeature</Value>
</Value>
<Value name="11">
<Value>SignScript</Value>
</Value>
<Value name="12">
<Value>HeaderImage</Value>
</Value>
<Value name="13">
<Value>FingerPrint</Value>
</Value>
<Value name="14">
<Value>SignData</Value>
</Value>
</Data>
<DataLocation>^EMR.DB.PatientSignD</DataLocation>
<DefaultData>PatientSignDefaultData</DefaultData>
<IdLocation>^EMR.DB.PatientSignD</IdLocation>
<IndexLocation>^EMR.DB.PatientSignI</IndexLocation>
<StreamLocation>^EMR.DB.PatientSignS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
