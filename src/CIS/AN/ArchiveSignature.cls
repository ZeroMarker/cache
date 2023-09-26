/// 手术麻醉表单提交归档签名
Class CIS.AN.ArchiveSignature Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = ArchiveSignature ]
{

/// 手术麻醉表单提交归档记录
Property ArchiveRecord As CIS.AN.ArchiveRecord [ Required, SqlColumnNumber = 2 ];

/// 签名代码（用于识别是哪一项业务的签名）
Property SignCode As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 3 ];

/// 签名用户
Property SignUser As %String [ SqlColumnNumber = 4 ];

/// 签名原文
Property OriginalData As %String(MAXLEN = 999999) [ SqlColumnNumber = 5 ];

/// 签名密文
Property SignedData As %String(MAXLEN = 999999) [ SqlColumnNumber = 6 ];

/// 签名的时间戳
Property SignTimeStamp As %String(MAXLEN = 999999) [ SqlColumnNumber = 7 ];

/// 证书唯一标识符
Property UserCertCode As %String [ SqlColumnNumber = 8 ];

/// 签名日期
Property SignDate As %Date [ InitialExpression = {+$H}, SqlColumnNumber = 9 ];

/// 签名时间
Property SignTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 10 ];

/// CA.DigitalSignature关联Id
Property CASignatueId As %String [ SqlColumnNumber = 11 ];

/// 外部系统ID
Property ExternalID As %String [ SqlColumnNumber = 12 ];

/// 签名证书
Property SignCert As %String [ SqlColumnNumber = 13 ];

Index IArchive On ArchiveRecord;

Index IArchiveSignCode On (ArchiveRecord, SignCode) [ Unique ];

Index IExt On ExternalID;

ForeignKey FKArchiveRecord(ArchiveRecord) References CIS.AN.ArchiveRecord() [ OnDelete = cascade ];

Storage Default
{
<Data name="ArchiveSignatureDefaultData">
<Value name="1">
<Value>ArchiveRecord</Value>
</Value>
<Value name="2">
<Value>SignCode</Value>
</Value>
<Value name="3">
<Value>SignUser</Value>
</Value>
<Value name="4">
<Value>OriginalData</Value>
</Value>
<Value name="5">
<Value>SignedData</Value>
</Value>
<Value name="6">
<Value>SignTimeStamp</Value>
</Value>
<Value name="7">
<Value>UserCertCode</Value>
</Value>
<Value name="8">
<Value>SignDate</Value>
</Value>
<Value name="9">
<Value>SignTime</Value>
</Value>
<Value name="10">
<Value>CASignatueId</Value>
</Value>
<Value name="11">
<Value>ExternalID</Value>
</Value>
<Value name="12">
<Value>SignCert</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.ArchiveSignatureD</DataLocation>
<DefaultData>ArchiveSignatureDefaultData</DefaultData>
<IdLocation>^CIS.AN.ArchiveSignatureD</IdLocation>
<IndexLocation>^CIS.AN.ArchiveSignatureI</IndexLocation>
<StreamLocation>^CIS.AN.ArchiveSignatureS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
