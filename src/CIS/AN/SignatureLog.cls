/// 签名日志
Class CIS.AN.SignatureLog Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = SignatureLog ]
{

/// 签名对象
Property Signature As CIS.AN.Signature [ Required, SqlColumnNumber = 2 ];

/// 签名用户
Property SignUser As %String [ Required, SqlColumnNumber = 3 ];

/// 签名日期
Property SignDate As %Date [ SqlColumnNumber = 4 ];

/// 签名时间
Property SignTime As %Time [ SqlColumnNumber = 5 ];

/// 签名索引
Index ISignature On Signature;

/// 签名外键约束
ForeignKey FKSignature(Signature) References CIS.AN.Signature() [ OnDelete = cascade ];

Storage Default
{
<Data name="SignatureLogDefaultData">
<Value name="1">
<Value>Signature</Value>
</Value>
<Value name="2">
<Value>SignUser</Value>
</Value>
<Value name="3">
<Value>SignDate</Value>
</Value>
<Value name="4">
<Value>SignTime</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.SignatureLogD</DataLocation>
<DefaultData>SignatureLogDefaultData</DefaultData>
<IdLocation>^CIS.AN.SignatureLogD</IdLocation>
<IndexLocation>^CIS.AN.SignatureLogI</IndexLocation>
<StreamLocation>^CIS.AN.SignatureLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
