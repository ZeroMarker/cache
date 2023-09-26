/// 记录在院病人费用数据生成的日期表
/// DHCWL_Account.BalancePeriod  d ##class(DHCWL.Account.BalancePeriod).%BuildIndices()
/// 2017-03-04 V6
Class DHCWL.Account.BalancePeriod Extends %Persistent [ ClassType = persistent, SqlTableName = BalancePeriod ]
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
<Data name="BalancePeriodDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PeriodName</Value>
</Value>
<Value name="3">
<Value>PeriodDate</Value>
</Value>
<Value name="4">
<Value>LastRowid</Value>
</Value>
<Value name="5">
<Value>PeriodCreatDate</Value>
</Value>
<Value name="6">
<Value>PeriodCreatTime</Value>
</Value>
</Data>
<DataLocation>^DHCWL.Account.BalancePeriodD</DataLocation>
<DefaultData>BalancePeriodDefaultData</DefaultData>
<IdLocation>^DHCWL.Account.BalancePeriodD</IdLocation>
<IndexLocation>^DHCWL.Account.BalancePeriodI</IndexLocation>
<StreamLocation>^DHCWL.Account.BalancePeriodS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
