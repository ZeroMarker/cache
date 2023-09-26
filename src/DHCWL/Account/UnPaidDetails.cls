/// 记录未结账单的明细数据
/// DHCWL_Account.UnPaidDetails  d ##class(DHCWL.Account.UnPaidDetails).%BuildIndices()
/// 2017-03-04 V6
Class DHCWL.Account.UnPaidDetails Extends %Persistent [ ClassType = persistent, SqlTableName = UnPaidDetails ]
{

/// 主表id
Property UnPaidPeriodDr As %Integer [ SqlColumnNumber = 2, SqlFieldName = UnPaidPeriodDr ];

/// Admid
Property Admid As %String [ SqlColumnNumber = 3, SqlFieldName = Admid ];

/// 科室
Property PatDepdr As %String [ SqlColumnNumber = 4, SqlFieldName = PatDepdr ];

/// 账单号
Property PBRowid As %Integer [ SqlColumnNumber = 5, SqlFieldName = PBRowid ];

/// 病人病区
Property PatWardr As %String [ SqlColumnNumber = 6, SqlFieldName = PatWardr ];

/// 病人医生
Property PatDocdr As %String [ SqlColumnNumber = 7, SqlFieldName = PatDocdr ];

/// 收费项目分类(默认会计分类)
Property TARACDr As %String [ SqlColumnNumber = 8, SqlFieldName = TARACDr ];

/// H(应收)、I(实收)、C(余额)
Property UnPaidType As %String [ SqlColumnNumber = 9, SqlFieldName = UnPaidType ];

/// 费用
Property fee As %Float [ SqlColumnNumber = 10, SqlFieldName = fee ];

/// 折扣费用
Property DisAmount As %Float [ SqlColumnNumber = 11, SqlFieldName = DisAmount ];

/// 医保费用
Property PayorShare As %Float [ SqlColumnNumber = 12, SqlFieldName = PayorShare ];

/// 自付费用
Property PatientShare As %Float [ SqlColumnNumber = 13, SqlFieldName = PatientShare ];

Index UnPaidPeriod On UnPaidPeriodDr;

Index UnPaidType On (UnPaidPeriodDr, UnPaidType);

Index UnPaidAdmid On (UnPaidPeriodDr, Admid);

Index UnPaidPB On (UnPaidPeriodDr, PBRowid);

Index UnPaidPatDep On (UnPaidPeriodDr, PatDepdr);

Storage Default
{
<Data name="UnPaidDetailsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UnPaidPeriodDr</Value>
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
<Value>UnPaidType</Value>
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
<DataLocation>^DHCWL.Account.UnPaidDetailsD</DataLocation>
<DefaultData>UnPaidDetailsDefaultData</DefaultData>
<IdLocation>^DHCWL.Account.UnPaidDetailsD</IdLocation>
<IndexLocation>^DHCWL.Account.UnPaidDetailsI</IndexLocation>
<StreamLocation>^DHCWL.Account.UnPaidDetailsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
