Class User.ACCTYearPeriod Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = ACCT_YearPeriod ]
{

/// des ref to ACCTYear 会计期间
Property AcctYearDr As ACCTYear [ SqlFieldName = ACCT_Year_Dr ];

Property AcctMonth As %String(MAXLEN = 2) [ Required, SqlFieldName = acct_month ];

Property BeginDate As %Date [ Required, SqlFieldName = begin_date ];

Property EndDate As %Date [ Required, SqlFieldName = end_date ];

Property CashFlag As %Integer(DISPLAYLIST = ",0,1", VALUELIST = ",0,1") [ InitialExpression = 0, Required, SqlFieldName = cash_flag ];

Property FixFlag As %Integer(DISPLAYLIST = ",0,1", VALUELIST = ",0,1") [ InitialExpression = 0, Required, SqlFieldName = fix_flag ];

Property MatFlag As %Integer(DISPLAYLIST = ",0,1", VALUELIST = ",0,1") [ InitialExpression = 0, Required, SqlFieldName = mat_flag ];

Property MedFlag As %Integer(DISPLAYLIST = ",0,1", VALUELIST = ",0,1") [ InitialExpression = 0, Required, SqlFieldName = med_flag ];

Property DrugStoreFlag As %Integer(DISPLAYLIST = ",0,1", VALUELIST = ",0,1") [ InitialExpression = 0, Required, SqlFieldName = drugstore_flag ];

Property WageFlag As %Integer(DISPLAYLIST = ",0,1", VALUELIST = ",0,1") [ InitialExpression = 0, Required, SqlFieldName = wage_flag ];

Property AccFlag As %Integer(DISPLAYLIST = ",0,1", VALUELIST = ",0,1") [ InitialExpression = 0, Required, SqlFieldName = acc_flag ];

Property BudgFlag As %Integer(DISPLAYLIST = ",0,1", VALUELIST = ",0,1") [ InitialExpression = 0, Required, SqlFieldName = budg_flag ];

Property PerfFlag As %Integer(DISPLAYLIST = ",0,1", VALUELIST = ",0,1") [ InitialExpression = 0, Required, SqlFieldName = perf_flag ];

Property CostFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ Required, SqlFieldName = cost_flag ];

Property MatCheckDate As %Date [ SqlFieldName = mat_check_date ];

Property FixCheckDate As %Date [ SqlFieldName = fix_check_date ];

Property IsDepreciation As %Integer(DISPLAYLIST = ",0,1", VALUELIST = ",0,1") [ InitialExpression = 0, Required, SqlFieldName = is_depreciation ];

Index PKYearMonth On (AcctYearDr, AcctMonth) [ Unique ];

Storage Default
{
<Data name="ACCTYearPeriodDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AccFlag</Value>
</Value>
<Value name="3">
<Value>AcctMonth</Value>
</Value>
<Value name="4">
<Value>AcctYearDr</Value>
</Value>
<Value name="5">
<Value>BeginDate</Value>
</Value>
<Value name="6">
<Value>BudgFlag</Value>
</Value>
<Value name="7">
<Value>CashFlag</Value>
</Value>
<Value name="8">
<Value>CostFlag</Value>
</Value>
<Value name="9">
<Value>DrugStoreFlag</Value>
</Value>
<Value name="10">
<Value>EndDate</Value>
</Value>
<Value name="11">
<Value>FixCheckDate</Value>
</Value>
<Value name="12">
<Value>FixFlag</Value>
</Value>
<Value name="13">
<Value>IsDepreciation</Value>
</Value>
<Value name="14">
<Value>MatCheckDate</Value>
</Value>
<Value name="15">
<Value>MatFlag</Value>
</Value>
<Value name="16">
<Value>MedFlag</Value>
</Value>
<Value name="17">
<Value>PerfFlag</Value>
</Value>
<Value name="18">
<Value>WageFlag</Value>
</Value>
</Data>
<DataLocation>^User.ACCTYearPeriodD</DataLocation>
<DefaultData>ACCTYearPeriodDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.ACCTYearPeriodD</IdLocation>
<IndexLocation>^User.ACCTYearPeriodI</IndexLocation>
<StreamLocation>^User.ACCTYearPeriodS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
