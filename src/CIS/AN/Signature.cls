/// 表单签名
Class CIS.AN.Signature Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Signature ]
{

/// 手术麻醉记录表单
Property RecordSheet As CIS.AN.RecordSheet [ Required, SqlColumnNumber = 2 ];

/// 签名代码（用于识别是哪一项业务的签名）
Property SignCode As %String(MAXLEN = 200) [ SqlColumnNumber = 3 ];

/// 签名用户
Property SignUser As %String [ SqlColumnNumber = 4 ];

/// 签名原文
Property HashData As %String(MAXLEN = 999999) [ SqlColumnNumber = 5 ];

/// 签名密文
Property SignData As %String(MAXLEN = 999999) [ SqlColumnNumber = 6 ];

/// 签名的时间戳
Property SignTimeStamp As %String(MAXLEN = 999999) [ SqlColumnNumber = 7 ];

/// 证书唯一标识符
Property UserCertCode As %String [ SqlColumnNumber = 8 ];

/// 外部系统ID
Property ExternalID As %String [ SqlColumnNumber = 9 ];

/// 签名日期
Property SignDate As %Date [ SqlColumnNumber = 10 ];

/// 签名时间
Property SignTime As %Time [ SqlColumnNumber = 11 ];

/// CA.DigitalSignature关联Id
Property CASignatueId As %String [ SqlColumnNumber = 12 ];

/// 手术麻醉记录表单索引
Index ISheet On RecordSheet;

/// 表单签名业务唯一性约束
Index ISheetSignCode On (RecordSheet, SignCode) [ Unique ];

Index IExt On ExternalID;

/// 手术麻醉记录表单外键约束
ForeignKey FKRecordSheet(RecordSheet) References CIS.AN.RecordSheet() [ OnDelete = cascade ];

Storage Default
{
<Data name="SignatureDefaultData">
<Value name="1">
<Value>RecordSheet</Value>
</Value>
<Value name="2">
<Value>SignCode</Value>
</Value>
<Value name="3">
<Value>SignUser</Value>
</Value>
<Value name="4">
<Value>HashData</Value>
</Value>
<Value name="5">
<Value>SignData</Value>
</Value>
<Value name="6">
<Value>SignTimeStamp</Value>
</Value>
<Value name="7">
<Value>UserCertCode</Value>
</Value>
<Value name="8">
<Value>ExternalID</Value>
</Value>
<Value name="9">
<Value>SignDate</Value>
</Value>
<Value name="10">
<Value>SignTime</Value>
</Value>
<Value name="11">
<Value>CASignatueId</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.SignatureD</DataLocation>
<DefaultData>SignatureDefaultData</DefaultData>
<IdLocation>^CIS.AN.SignatureD</IdLocation>
<IndexLocation>^CIS.AN.SignatureI</IndexLocation>
<StreamLocation>^CIS.AN.SignatureS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
