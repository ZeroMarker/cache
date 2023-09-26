Class User.ACCTYear Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = ACCT_Year ]
{

Property CompCode As %String(MAXLEN = 20) [ Required, SqlFieldName = comp_code ];

Property CopyCode As %String(MAXLEN = 3) [ Required, SqlFieldName = copy_code ];

Property AcctYear As %String(MAXLEN = 4) [ Required, SqlFieldName = acct_year ];

Property BeginDate As %Date [ Required, SqlFieldName = begin_date ];

Property EndDate As %Date [ Required, SqlFieldName = end_date ];

Property PeriodNum As %Integer [ Required, SqlFieldName = period_num ];

Property AccFlag As %Integer(DISPLAYLIST = ",0,1", VALUELIST = ",0,1") [ InitialExpression = 0, Required, SqlFieldName = acc_flag ];

Property BudgFlag As %Integer(DISPLAYLIST = ",0,1", VALUELIST = ",0,1") [ InitialExpression = 0, Required, SqlFieldName = budg_flag ];

Property PerfFlag As %Integer(DISPLAYLIST = ",0,1", VALUELIST = ",0,1") [ InitialExpression = 0, Required, SqlFieldName = perf_flag ];

Property CostFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ Required, SqlFieldName = cost_flag ];

Property CashDate As %Date [ SqlFieldName = cash_date ];

Index PKCompcodeCopycodeAcctyear On (CompCode, CopyCode, AcctYear) [ Unique ];

Storage Default
{
<Data name="ACCTYearDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AccFlag</Value>
</Value>
<Value name="3">
<Value>AccountYear</Value>
</Value>
<Value name="4">
<Value>BeginDate</Value>
</Value>
<Value name="5">
<Value>BudgFlag</Value>
</Value>
<Value name="6">
<Value>CashDate</Value>
</Value>
<Value name="7">
<Value>CompCode</Value>
</Value>
<Value name="8">
<Value>CopyCode</Value>
</Value>
<Value name="9">
<Value>CostFlag</Value>
</Value>
<Value name="10">
<Value>EndDate</Value>
</Value>
<Value name="11">
<Value>PerfFlag</Value>
</Value>
<Value name="12">
<Value>PeriodNum</Value>
</Value>
<Value name="13">
<Value>AcctYear</Value>
</Value>
</Data>
<DataLocation>^User.ACCTYearD</DataLocation>
<DefaultData>ACCTYearDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.ACCTYearD</IdLocation>
<IndexLocation>^User.ACCTYearI</IndexLocation>
<StreamLocation>^User.ACCTYearS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
