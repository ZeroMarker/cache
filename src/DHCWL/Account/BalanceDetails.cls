/// 记录在院病人费用的明细数据
/// DHCWL_Account.BalanceDetails  d ##class(DHCWL.Account.BalanceDetails).%BuildIndices()
/// 2017-03-04 V6
Class DHCWL.Account.BalanceDetails Extends %Persistent [ ClassType = persistent, SqlTableName = BalanceDetails ]
{

/// 主表id
Property BalancePeriodDr As %Integer [ SqlColumnNumber = 2, SqlFieldName = BalancePeriodDr ];

/// Admid
Property Admid As %Integer [ SqlColumnNumber = 3, SqlFieldName = Admid ];

/// 账单Rowid
Property PBRowid As %Integer [ SqlColumnNumber = 4, SqlFieldName = PBRowid ];

/// 科室
Property PatDepdr As %String [ SqlColumnNumber = 5, SqlFieldName = PatDepdr ];

/// 病人病区
Property PatWardr As %String [ SqlColumnNumber = 6, SqlFieldName = PatWardr ];

/// 病人医生
Property PatDocdr As %String [ SqlColumnNumber = 7, SqlFieldName = PatDocdr ];

/// 收费项目分类(默认会计分类)
Property TARACDr As %String [ SqlColumnNumber = 8, SqlFieldName = TARACDr ];

/// H(应收)、I(实收)、C(余额)
Property BalanceDetailsType As %String [ SqlColumnNumber = 9, SqlFieldName = BalanceDetailsType ];

/// 费用
Property fee As %Float [ SqlColumnNumber = 10, SqlFieldName = fee ];

/// 折扣费用
Property DisAmount As %Float [ SqlColumnNumber = 11, SqlFieldName = DisAmount ];

/// 医保费用
Property PayorShare As %Float [ SqlColumnNumber = 12, SqlFieldName = PayorShare ];

/// 自付费用
Property PatientShare As %Float [ SqlColumnNumber = 13, SqlFieldName = PatientShare ];

Index BalanceType On (BalancePeriodDr, BalanceDetailsType);

Index BalanceAdmid On (BalancePeriodDr, Admid);

Index BalancePatDep On (BalancePeriodDr, PatDepdr);

Index BalancePB On (BalancePeriodDr, PBRowid);

Index BalancePeriod On BalancePeriodDr;

Storage Default
{
<Data name="BalanceDetailsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BalancePeriodDr</Value>
</Value>
<Value name="3">
<Value>fee</Value>
</Value>
<Value name="4">
<Value>TARACDr</Value>
</Value>
<Value name="5">
<Value>PatDepdr</Value>
</Value>
<Value name="6">
<Value>BalanceDetailsType</Value>
</Value>
<Value name="7">
<Value>Admid</Value>
</Value>
<Value name="8">
<Value>DisAmount</Value>
</Value>
<Value name="9">
<Value>PayorShare</Value>
</Value>
<Value name="10">
<Value>PatientShare</Value>
</Value>
<Value name="11">
<Value>PatDocdr</Value>
</Value>
<Value name="12">
<Value>PatWardr</Value>
</Value>
<Value name="13">
<Value>PBRowid</Value>
</Value>
</Data>
<DataLocation>^DHCWL.Account.BalanceDetailsD</DataLocation>
<DefaultData>BalanceDetailsDefaultData</DefaultData>
<IdLocation>^DHCWL.Account.BalanceDetailsD</IdLocation>
<IndexLocation>^DHCWL.Account.BalanceDetailsI</IndexLocation>
<StreamLocation>^DHCWL.Account.BalanceDetailsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
