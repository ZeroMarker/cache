/// 记录病人的预交金 数据来源与计费组程序  
/// DHCWL_Account.Deposit  d ##class(DHCWL.Account.Deposit).%BuildIndices()
/// 2017-03-04 V6
Class DHCWL.Account.Deposit Extends %Persistent [ ClassType = persistent, SqlTableName = Deposit ]
{

/// 主表id
Property BalancePeriodDr As DHCWL.Account.BalancePeriod [ SqlColumnNumber = 2, SqlFieldName = BalancePeriodDr ];

/// 预缴金
Property fee As %Float [ SqlColumnNumber = 3, SqlFieldName = fee ];

/// Admid
Property Admid As %Integer [ SqlColumnNumber = 4, SqlFieldName = Admid ];

Index PeriodAdm On (BalancePeriodDr, Admid);

Index PeriodDr On BalancePeriodDr;

Storage Default
{
<Data name="DepositDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ACCDEPAdmDr</Value>
</Value>
<Value name="3">
<Value>ACCDEPDr</Value>
</Value>
<Value name="4">
<Value>ACCDEPFEE</Value>
</Value>
<Value name="5">
<Value>BalancePeriodDr</Value>
</Value>
<Value name="6">
<Value>fee</Value>
</Value>
<Value name="7">
<Value>Admid</Value>
</Value>
</Data>
<DataLocation>^DHCWL.Account.DepositD</DataLocation>
<DefaultData>DepositDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.Account.DepositD</IdLocation>
<IndexLocation>^DHCWL.Account.DepositI</IndexLocation>
<StreamLocation>^DHCWL.Account.DepositS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
