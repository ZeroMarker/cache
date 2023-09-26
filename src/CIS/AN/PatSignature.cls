Class CIS.AN.PatSignature Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = PatSignature ]
{

/// 手术麻醉记录表单
Property RecordSheet As CIS.AN.RecordSheet [ Required, SqlColumnNumber = 2 ];

/// 签名代码（用于识别是哪一项业务的签名）
Property SignCode As %String(MAXLEN = 200) [ SqlColumnNumber = 3 ];

/// 签名原文
Property HashData As %String(MAXLEN = 999999) [ SqlColumnNumber = 4 ];

/// 签名数据
Property SignData As %GlobalCharacterStream(LOCATION = "^CIS.AN.PatSignatureS") [ SqlColumnNumber = 5 ];

/// 指纹图片数据
Property FingerImage As %GlobalCharacterStream(LOCATION = "^CIS.AN.PatSignatureS") [ SqlColumnNumber = 6 ];

/// 签名笔迹图片数据
Property HeaderImage As %GlobalCharacterStream(LOCATION = "^CIS.AN.PatSignatureS") [ SqlColumnNumber = 7 ];

/// 更新用户
Property UpdateUser As %String [ SqlColumnNumber = 8 ];

/// 签名日期
Property SignDate As %Date [ SqlColumnNumber = 9 ];

/// 签名时间
Property SignTime As %Time [ SqlColumnNumber = 10 ];

Property Algorithm As %String(MAXLEN = 999999) [ SqlColumnNumber = 11 ];

Property BioFeature As %GlobalCharacterStream(LOCATION = "^CIS.AN.PatSignatureS") [ SqlColumnNumber = 12 ];

Property EventCert As %String(MAXLEN = 999999) [ SqlColumnNumber = 13 ];

/// 签名时间戳
Property TSValue As %String(MAXLEN = 999999) [ SqlColumnNumber = 14 ];

Property Version As %String [ SqlColumnNumber = 15 ];

/// 签名笔迹图片数据
Property SignScript As %GlobalCharacterStream(LOCATION = "^CIS.AN.PatSignatureS") [ SqlColumnNumber = 16 ];

Property SignValue As %String(MAXLEN = 999999) [ SqlColumnNumber = 17 ];

Property IsValid As %Boolean [ SqlColumnNumber = 18 ];

Property UpdateDate As %Date [ SqlColumnNumber = 19 ];

Property UpdateTime As %Time [ SqlColumnNumber = 20 ];

Index ISheetSignCode On (RecordSheet, SignCode);

Index ISignValid On (RecordSheet, SignCode, IsValid) [ Unique ];

Storage Default
{
<Data name="PatSignatureDefaultData">
<Value name="1">
<Value>RecordSheet</Value>
</Value>
<Value name="2">
<Value>SignCode</Value>
</Value>
<Value name="3">
<Value>HashData</Value>
</Value>
<Value name="4">
<Value>SignData</Value>
</Value>
<Value name="5">
<Value>FingerImage</Value>
</Value>
<Value name="6">
<Value>HeaderImage</Value>
</Value>
<Value name="7">
<Value>UpdateUser</Value>
</Value>
<Value name="8">
<Value>SignDate</Value>
</Value>
<Value name="9">
<Value>SignTime</Value>
</Value>
<Value name="10">
<Value>Algorithm</Value>
</Value>
<Value name="11">
<Value>BioFeature</Value>
</Value>
<Value name="12">
<Value>EventCert</Value>
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
<Value>SignValue</Value>
</Value>
<Value name="17">
<Value>IsValid</Value>
</Value>
<Value name="18">
<Value>UpdateDate</Value>
</Value>
<Value name="19">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.PatSignatureD</DataLocation>
<DefaultData>PatSignatureDefaultData</DefaultData>
<IdLocation>^CIS.AN.PatSignatureD</IdLocation>
<IndexLocation>^CIS.AN.PatSignatureI</IndexLocation>
<StreamLocation>^CIS.AN.PatSignatureS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
