/// 记录未结账单生成数据的日期表 
/// DHCWL_Account.UnPaidPeriod  d ##class(DHCWL.Account.UnPaidPeriod).%BuildIndices()
/// 2017-03-04 V6
Class DHCWL.Account.UnPaidPeriod Extends %Persistent [ ClassType = persistent, SqlTableName = UnPaidPeriod ]
{

/// 生成的数据日期
Property PeriodName As %String [ SqlColumnNumber = 2, SqlFieldName = PeriodName ];

/// 生成的数据日期
Property PeriodDate As %Date [ SqlColumnNumber = 3, SqlFieldName = PeriodDate ];

/// 指向上期
Property LastRowid As %String [ SqlColumnNumber = 4, SqlFieldName = LastRowid ];

/// 自动执行任务 日期
Property PeriodCreatDate As %Date [ SqlColumnNumber = 5, SqlFieldName = PeriodCreatDate ];

/// 自动执行任务 时间
Property PeriodCreatTime As %Time [ SqlColumnNumber = 6, SqlFieldName = PeriodCreatTime ];

/// 索引
Index PeriodDate On PeriodDate;

Storage Default
{
<Data name="UnPaidPeriodDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AccName</Value>
</Value>
<Value name="3">
<Value>AccDate</Value>
</Value>
<Value name="4">
<Value>LastRowid</Value>
</Value>
<Value name="5">
<Value>AccCreatDate</Value>
</Value>
<Value name="6">
<Value>AccCreatTime</Value>
</Value>
<Value name="7">
<Value>PeriodName</Value>
</Value>
<Value name="8">
<Value>PeriodDate</Value>
</Value>
<Value name="9">
<Value>PeriodCreatDate</Value>
</Value>
<Value name="10">
<Value>PeriodCreatTime</Value>
</Value>
</Data>
<DataLocation>^DHCWL.Account.UnPaidPeriodD</DataLocation>
<DefaultData>UnPaidPeriodDefaultData</DefaultData>
<IdLocation>^DHCWL.Account.UnPaidPeriodD</IdLocation>
<IndexLocation>^DHCWL.Account.UnPaidPeriodI</IndexLocation>
<StreamLocation>^DHCWL.Account.UnPaidPeriodS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
