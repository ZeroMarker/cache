/// 手术麻醉表单提交记录患者签名
Class CIS.AN.ArchivePatSignature Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = ArchivePatSignature ]
{

/// 手术麻醉表单提交归档记录
Property ArchiveRecord As CIS.AN.ArchiveRecord [ Required, SqlColumnNumber = 2 ];

/// 签名代码（用于识别是哪一项业务的签名）
Property SignCode As %String(MAXLEN = 200) [ SqlColumnNumber = 3 ];

/// 签名原文
Property HashData As %String(MAXLEN = 999999) [ SqlColumnNumber = 4 ];

/// 签名数据
Property SignData As %GlobalCharacterStream(LOCATION = "^CIS.AN.ArchivePatSignatureS") [ SqlColumnNumber = 5 ];

/// 指纹图片数据
Property FingerImage As %GlobalCharacterStream(LOCATION = "^CIS.AN.ArchivePatSignatureS") [ SqlColumnNumber = 6 ];

/// 签名笔迹图片数据
Property HeaderImage As %GlobalCharacterStream(LOCATION = "^CIS.AN.ArchivePatSignatureS") [ SqlColumnNumber = 7 ];

/// 更新用户
Property UpdateUser As %String [ SqlColumnNumber = 8 ];

/// 签名日期
Property SignDate As %Date [ SqlColumnNumber = 9 ];

/// 签名时间
Property SignTime As %Time [ SqlColumnNumber = 10 ];

/// 签名算法
Property Algorithm As %String(MAXLEN = 999999) [ SqlColumnNumber = 11 ];

/// 签名生命体征
Property BioFeature As %GlobalCharacterStream(LOCATION = "^CIS.AN.ArchivePatSignatureS") [ SqlColumnNumber = 12 ];

/// 事件证书
Property EventCert As %String(MAXLEN = 999999) [ SqlColumnNumber = 13 ];

/// 签名时间戳
Property TSValue As %String(MAXLEN = 999999) [ SqlColumnNumber = 14 ];

/// 签名版本
Property Version As %String [ SqlColumnNumber = 15 ];

/// 签名笔迹图片数据
Property SignScript As %GlobalCharacterStream(LOCATION = "^CIS.AN.ArchivePatSignatureS") [ SqlColumnNumber = 16 ];

/// 签名值
Property SignValue As %String(MAXLEN = 999999) [ SqlColumnNumber = 17 ];

/// 是否有效
Property IsValid As %Boolean [ SqlColumnNumber = 18 ];

/// 更新日期
Property UpdateDate As %Date [ SqlColumnNumber = 19 ];

/// 更新时间
Property UpdateTime As %Time [ SqlColumnNumber = 20 ];

Index IArchive On ArchiveRecord;

Index IArchiveSignCode On (ArchiveRecord, SignCode) [ Unique ];

Index ISignValid On (ArchiveRecord, SignCode, IsValid) [ Unique ];

ForeignKey FKArchiveRecord(ArchiveRecord) References CIS.AN.ArchiveRecord() [ OnDelete = cascade ];

Storage Default
{
<Data name="ArchivePatSignatureDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ArchiveRecord</Value>
</Value>
<Value name="3">
<Value>SignCode</Value>
</Value>
<Value name="4">
<Value>HashData</Value>
</Value>
<Value name="5">
<Value>SignData</Value>
</Value>
<Value name="6">
<Value>FingerImage</Value>
</Value>
<Value name="7">
<Value>HeaderImage</Value>
</Value>
<Value name="8">
<Value>UpdateUser</Value>
</Value>
<Value name="9">
<Value>SignDate</Value>
</Value>
<Value name="10">
<Value>SignTime</Value>
</Value>
<Value name="11">
<Value>Algorithm</Value>
</Value>
<Value name="12">
<Value>BioFeature</Value>
</Value>
<Value name="13">
<Value>EventCert</Value>
</Value>
<Value name="14">
<Value>TSValue</Value>
</Value>
<Value name="15">
<Value>Version</Value>
</Value>
<Value name="16">
<Value>SignScript</Value>
</Value>
<Value name="17">
<Value>SignValue</Value>
</Value>
<Value name="18">
<Value>IsValid</Value>
</Value>
<Value name="19">
<Value>UpdateDate</Value>
</Value>
<Value name="20">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.ArchivePatSignatureD</DataLocation>
<DefaultData>ArchivePatSignatureDefaultData</DefaultData>
<IdLocation>^CIS.AN.ArchivePatSignatureD</IdLocation>
<IndexLocation>^CIS.AN.ArchivePatSignatureI</IndexLocation>
<StreamLocation>^CIS.AN.ArchivePatSignatureS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
