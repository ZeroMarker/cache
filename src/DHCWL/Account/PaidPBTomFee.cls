/// 记录已结账单的明日医嘱费用 
/// DHCWL_Account.PaidPBTomFee  d ##class(DHCWL.Account.PaidPBTomFee).%BuildIndices()
/// 2017-03-04 V6
Class DHCWL.Account.PaidPBTomFee Extends %Persistent [ ClassType = persistent, SqlTableName = PaidPBTomFee ]
{

/// 日期发生值 
Property day As %Date [ SqlColumnNumber = 2, SqlFieldName = day ];

/// Admid
Property Admid As %Integer [ SqlColumnNumber = 3, SqlFieldName = Admid ];

/// 账单Rowid
Property PBRowid As %Integer [ SqlColumnNumber = 4, SqlFieldName = PBRowid ];

/// 科室(病人科室)
Property PatDepdr As %String [ SqlColumnNumber = 5, SqlFieldName = PatDepdr ];

/// 病区(病人病区)
Property PatWardr As %String [ SqlColumnNumber = 6, SqlFieldName = PatWardr ];

/// 病人医生
Property PatDocdr As %String [ SqlColumnNumber = 7, SqlFieldName = PatDocdr ];

/// 费用分类(默认为会计分类)
Property TARACdr As %String [ SqlColumnNumber = 8, SqlFieldName = TARACdr ];

/// 费用
Property fee As %Float [ SqlColumnNumber = 9, SqlFieldName = fee ];

/// 折扣费用
Property DisAmount As %Float [ SqlColumnNumber = 10, SqlFieldName = DisAmount ];

/// 医保费用
Property PayorShare As %Float [ SqlColumnNumber = 11, SqlFieldName = PayorShare ];

/// 自付费用
Property PatientShare As %Float [ SqlColumnNumber = 12, SqlFieldName = PatientShare ];

/// 生成的数据日期
Property Insdate As %String [ SqlColumnNumber = 13, SqlFieldName = Insdate ];

Index day On day;

Index Admid On Admid;

Index PBRowid On PBRowid;

Index dayPB On (day, PBRowid);

Index dayAdmd On (day, Admid);

Storage Default
{
<Data name="PaidPBTomFeeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>day</Value>
</Value>
<Value name="3">
<Value>Admid</Value>
</Value>
<Value name="4">
<Value>PBRowid</Value>
</Value>
<Value name="5">
<Value>PatDepdr</Value>
</Value>
<Value name="6">
<Value>PatWardr</Value>
</Value>
<Value name="7">
<Value>TARACdr</Value>
</Value>
<Value name="8">
<Value>fee</Value>
</Value>
<Value name="9">
<Value>Insdate</Value>
</Value>
<Value name="10">
<Value>PatDocdr</Value>
</Value>
<Value name="11">
<Value>DisAmount</Value>
</Value>
<Value name="12">
<Value>PayorShare</Value>
</Value>
<Value name="13">
<Value>PatientShare</Value>
</Value>
</Data>
<DataLocation>^DHCWL.Account.PaidPBTomFeeD</DataLocation>
<DefaultData>PaidPBTomFeeDefaultData</DefaultData>
<IdLocation>^DHCWL.Account.PaidPBTomFeeD</IdLocation>
<IndexLocation>^DHCWL.Account.PaidPBTomFeeI</IndexLocation>
<StreamLocation>^DHCWL.Account.PaidPBTomFeeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
