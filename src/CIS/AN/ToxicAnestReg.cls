/// 毒麻药领用登记
Class CIS.AN.ToxicAnestReg Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = ToxicAnestReg ]
{

/// 领取毒麻药的医生
Property CareProv As %String [ Required, SqlColumnNumber = 2 ];

/// 领取使用日期
Property RegDate As %Date [ Required, SqlColumnNumber = 3 ];

/// 请领操作日期
Property ApplyDate As %Date [ SqlColumnNumber = 4 ];

/// 请领操作时间
Property ApplyTime As %Time [ SqlColumnNumber = 5 ];

/// 领取日期
Property ClaimDate As %Date [ SqlColumnNumber = 6 ];

/// 领取时间
Property ClaimTime As %Time [ SqlColumnNumber = 7 ];

/// 退还日期
Property ReturnDate As %Date [ SqlColumnNumber = 8 ];

/// 退还时间
Property ReturnTime As %Time [ SqlColumnNumber = 9 ];

/// 请领审核人
Property ApplyCheckUser As %String [ SqlColumnNumber = 10 ];

/// 领取审核人
Property ClaimCheckUser As %String [ SqlColumnNumber = 11 ];

/// 退还审核人
Property ReturnCheckUser As %String [ SqlColumnNumber = 12 ];

/// 请领审核CA签名证书序列号
Property ApplyCheckCertID As %String [ SqlColumnNumber = 13 ];

/// 请领审核CA用户签名ID
Property ApplyCheckUserCertID As %String [ SqlColumnNumber = 14 ];

/// 请领审核CA签名内容
Property ApplyCheckSignData As %Library.GlobalCharacterStream(LOCATION = "^CIS.AN.ToxicAnestRegS") [ SqlColumnNumber = 15 ];

/// 请领审核CA签名时间戳
Property ApplyCheckSignTimeStamp As %Library.GlobalCharacterStream(LOCATION = "^CIS.AN.ToxicAnestRegS") [ SqlColumnNumber = 16 ];

/// 领取审核CA签名证书序列号
Property ClaimCheckCertID As %String [ SqlColumnNumber = 17 ];

/// 领取审核CA签名证书用户唯一标识符
Property ClaimCheckUserCertID As %String [ SqlColumnNumber = 18 ];

/// 领取审核CA签名内容
Property ClaimCheckSignData As %Library.GlobalCharacterStream(LOCATION = "^CIS.AN.ToxicAnestRegS") [ SqlColumnNumber = 19 ];

/// 领取审核CA签名时间戳
Property ClaimCheckSignTimeStamp As %Library.GlobalCharacterStream(LOCATION = "^CIS.AN.ToxicAnestRegS") [ SqlColumnNumber = 20 ];

/// 退还审核CA签名证书序列号
Property ReturnCheckCertID As %String [ SqlColumnNumber = 21 ];

/// 退还审核CA证书用户唯一标识符
Property ReturnCheckUserCertID As %String [ SqlColumnNumber = 22 ];

/// 退还审核CA签名内容
Property ReturnCheckSignData As %Library.GlobalCharacterStream(LOCATION = "^CIS.AN.ToxicAnestRegS") [ SqlColumnNumber = 23 ];

/// 退还审核CA签名时间戳
Property ReturnCheckSignTimeStamp As %Library.GlobalCharacterStream(LOCATION = "^CIS.AN.ToxicAnestRegS") [ SqlColumnNumber = 24 ];

/// 是否有效，无效即为已删除
Property IsActive As %String(DISPLAYLIST = ",有效,无效", MAXLEN = 2, VALUELIST = ",Y,N") [ SqlColumnNumber = 25 ];

/// 更新日期
Property UpdateDate As %Date [ SqlColumnNumber = 26 ];

/// 更新时间
Property UpdateTime As %Time [ SqlColumnNumber = 27 ];

/// 更新用户ID
Property UpdateUser As %String [ SqlColumnNumber = 28 ];

/// 登记日期索引
Index IDate On RegDate;

/// 领用医生、登记日期索引
Index CPDate On (CareProv, RegDate);

Storage Default
{
<Data name="ToxicAnestRegDefaultData">
<Value name="1">
<Value>CareProv</Value>
</Value>
<Value name="2">
<Value>RegDate</Value>
</Value>
<Value name="3">
<Value>ApplyDate</Value>
</Value>
<Value name="4">
<Value>ApplyTime</Value>
</Value>
<Value name="5">
<Value>ClaimDate</Value>
</Value>
<Value name="6">
<Value>ClaimTime</Value>
</Value>
<Value name="7">
<Value>ReturnDate</Value>
</Value>
<Value name="8">
<Value>ReturnTime</Value>
</Value>
<Value name="9">
<Value>ApplyCheckUser</Value>
</Value>
<Value name="10">
<Value>ClaimCheckUser</Value>
</Value>
<Value name="11">
<Value>ReturnCheckUser</Value>
</Value>
<Value name="12">
<Value>ApplyCheckCertID</Value>
</Value>
<Value name="13">
<Value>ApplyCheckUserCertID</Value>
</Value>
<Value name="14">
<Value>ApplyCheckSignData</Value>
</Value>
<Value name="15">
<Value>ApplyCheckSignTimeStamp</Value>
</Value>
<Value name="16">
<Value>ClaimCheckCertID</Value>
</Value>
<Value name="17">
<Value>ClaimCheckUserCertID</Value>
</Value>
<Value name="18">
<Value>ClaimCheckSignData</Value>
</Value>
<Value name="19">
<Value>ClaimCheckSignTimeStamp</Value>
</Value>
<Value name="20">
<Value>ReturnCheckCertID</Value>
</Value>
<Value name="21">
<Value>ReturnCheckUserCertID</Value>
</Value>
<Value name="22">
<Value>ReturnCheckSignData</Value>
</Value>
<Value name="23">
<Value>ReturnCheckSignTimeStamp</Value>
</Value>
<Value name="24">
<Value>IsActive</Value>
</Value>
<Value name="25">
<Value>UpdateDate</Value>
</Value>
<Value name="26">
<Value>UpdateTime</Value>
</Value>
<Value name="27">
<Value>UpdateUser</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.ToxicAnestRegD</DataLocation>
<DefaultData>ToxicAnestRegDefaultData</DefaultData>
<IdLocation>^CIS.AN.ToxicAnestRegD</IdLocation>
<IndexLocation>^CIS.AN.ToxicAnestRegI</IndexLocation>
<StreamLocation>^CIS.AN.ToxicAnestRegS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
