/// 帐套
Class User.ACCTSysCopy Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = ACCT_SysCopy ]
{

/// des ref to ACCTSysCompany 修改成单位
Property AcctSysCompanyDr As ACCTSysCompany [ SqlFieldName = ACCT_SysCompany_Dr ];

Property CopyCode As %String(MAXLEN = 3) [ Required, SqlFieldName = copy_code ];

Property CopyName As %String(MAXLEN = 20) [ Required, SqlFieldName = copy_name ];

Property CoCode As %String(MAXLEN = 10) [ Required, SqlFieldName = co_code ];

Property CopyStartYear As %String(MAXLEN = 4) [ Required, SqlFieldName = copy_start_year ];

Property CopyStartMonth As %String(MAXLEN = 2) [ Required, SqlFieldName = copy_start_month ];

Property StartYear As %String(MAXLEN = 4) [ SqlFieldName = start_year ];

Property StartMonth As %String(MAXLEN = 2) [ SqlFieldName = start_month ];

Property CurYear As %String(MAXLEN = 4) [ SqlFieldName = cur_year ];

Property CurMonth As %String(MAXLEN = 2) [ SqlFieldName = cur_month ];

Property EndDay As %String(MAXLEN = 4) [ Required, SqlFieldName = end_day ];

Property CopyType As %Integer [ InitialExpression = 1, Required, SqlFieldName = copy_type ];

Property IsAnalyse As %Integer(DISPLAYLIST = ",0,1", VALUELIST = ",0,1") [ InitialExpression = 0, Required, SqlFieldName = is_analyse ];

Property IsCheck As %Integer(DISPLAYLIST = ",0,1", VALUELIST = ",0,1") [ InitialExpression = 0, Required, SqlFieldName = is_check ];

Index PKSysCompanyCopyCode On (AcctSysCompanyDr, CopyCode) [ Unique ];

Storage Default
{
<Data name="ACCTSysCopyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AcctSysCompanyDr</Value>
</Value>
<Value name="3">
<Value>CoCode</Value>
</Value>
<Value name="4">
<Value>CopyCode</Value>
</Value>
<Value name="5">
<Value>CopyName</Value>
</Value>
<Value name="6">
<Value>CopyStartMonth</Value>
</Value>
<Value name="7">
<Value>CopyStartYear</Value>
</Value>
<Value name="8">
<Value>CopyType</Value>
</Value>
<Value name="9">
<Value>CurMonth</Value>
</Value>
<Value name="10">
<Value>CurYear</Value>
</Value>
<Value name="11">
<Value>EndDay</Value>
</Value>
<Value name="12">
<Value>IsAnalyse</Value>
</Value>
<Value name="13">
<Value>IsCheck</Value>
</Value>
<Value name="14">
<Value>StartMonth</Value>
</Value>
<Value name="15">
<Value>StartYear</Value>
</Value>
</Data>
<DataLocation>^User.ACCTSysCopyD</DataLocation>
<DefaultData>ACCTSysCopyDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.ACCTSysCopyD</IdLocation>
<IndexLocation>^User.ACCTSysCopyI</IndexLocation>
<StreamLocation>^User.ACCTSysCopyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
