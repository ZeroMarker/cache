/// 记录账单表每天未结账单记录 
/// DHCWL_Account.UnPaidPB  d ##class(DHCWL.Account.UnPaidPB).%BuildIndices()
/// 2017-03-04 V6
Class DHCWL.Account.UnPaidPB Extends %Persistent [ ClassType = persistent, SqlTableName = UnPaidPB ]
{

/// 未结账单日期
Property day As %Date [ SqlColumnNumber = 2, SqlFieldName = day ];

/// Admid
Property Admid As %Integer [ SqlColumnNumber = 3, SqlFieldName = Admid ];

/// 账单Rowid
Property PBRowid As %Integer [ SqlColumnNumber = 4, SqlFieldName = PBRowid ];

/// 费用  记录账单当时的费用
Property fee As %Float [ SqlColumnNumber = 5, SqlFieldName = fee ];

/// 生成的数据日
Property Insdate As %String [ SqlColumnNumber = 6, SqlFieldName = Insdate ];

/// 账单状态[B:未结>POver:凌晨结账>PSeal:封账]
Property Status As %String [ SqlColumnNumber = 7, SqlFieldName = Status ];

Index day On day;

Index PBRowid On PBRowid;

Index dayPB On (day, PBRowid);

Index dayAdmd On (day, Admid);

Storage Default
{
<Data name="UnPaidPBDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>day</Value>
</Value>
<Value name="3">
<Value>Insdate</Value>
</Value>
<Value name="4">
<Value>PBRowid</Value>
</Value>
<Value name="5">
<Value>fee</Value>
</Value>
<Value name="6">
<Value>Admid</Value>
</Value>
<Value name="7">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^DHCWL.Account.UnPaidPBD</DataLocation>
<DefaultData>UnPaidPBDefaultData</DefaultData>
<IdLocation>^DHCWL.Account.UnPaidPBD</IdLocation>
<IndexLocation>^DHCWL.Account.UnPaidPBI</IndexLocation>
<StreamLocation>^DHCWL.Account.UnPaidPBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
