/// 预交金四列帐 
/// DHCWL.Account.DepositBalance  d ##class(DHCWL.Account.DepositBalance).%BuildIndices()
/// 2020-06-12
Class DHCWL.Account.DepositBalance Extends %Persistent
{

/// 日期
Property Accdate As %Date [ SqlColumnNumber = 2 ];

/// 患者信息
Property PapmiCode As %Integer [ SqlColumnNumber = 3 ];

/// 就诊信息
Property AdmCode As %Integer [ SqlColumnNumber = 4 ];

/// 业务域
Property BFCode As %String [ SqlColumnNumber = 5 ];

/// 上期预交金余额
Property LastAmt As %Float [ SqlColumnNumber = 6 ];

/// 本期贷方
Property HAmt As %Float [ SqlColumnNumber = 7 ];

/// 本期借方
Property IAmt As %Float [ SqlColumnNumber = 8 ];

/// 本期预交金余额 差值
Property CAmt As %Float [ SqlColumnNumber = 9 ];

/// 接口调用预交金余额
Property JAmt As %Float [ SqlColumnNumber = 10 ];

/// 插入日期
Property CreatDate As %Date [ SqlColumnNumber = 11 ];

/// 插入时间
Property CreatTime As %Time [ SqlColumnNumber = 12 ];

/// 更新日期
Property UpdateDate As %Date [ SqlColumnNumber = 13 ];

/// 更新时间
Property UpdateTime As %Time [ SqlColumnNumber = 14 ];

Index dateIdx On Accdate As Exact;

Index AdmCodeIdx On AdmCode As Exact;

Index dateAdmCodeIdx On (Accdate As Exact, AdmCode As Exact);

Index dateBFIdx On (Accdate As Exact, BFCode As Exact);

Index CreatDateIdx On CreatDate As Exact;

Index UpdateDateIdx On UpdateDate As Exact;

Storage Default
{
<Data name="DepositBalanceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Accdate</Value>
</Value>
<Value name="3">
<Value>PapmiCode</Value>
</Value>
<Value name="4">
<Value>AdmCode</Value>
</Value>
<Value name="5">
<Value>BFCode</Value>
</Value>
<Value name="6">
<Value>LastAmt</Value>
</Value>
<Value name="7">
<Value>HAmt</Value>
</Value>
<Value name="8">
<Value>IAmt</Value>
</Value>
<Value name="9">
<Value>CAmt</Value>
</Value>
<Value name="10">
<Value>JAmt</Value>
</Value>
<Value name="11">
<Value>CreatDate</Value>
</Value>
<Value name="12">
<Value>CreatTime</Value>
</Value>
<Value name="13">
<Value>UpdateDate</Value>
</Value>
<Value name="14">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCWL.Account.DepositBalanceD</DataLocation>
<DefaultData>DepositBalanceDefaultData</DefaultData>
<IdLocation>^DHCWL.Account.DepositBalanceD</IdLocation>
<IndexLocation>^DHCWL.Account.DepositBalanceI</IndexLocation>
<StreamLocation>^DHCWL.Account.DepositBalanceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
