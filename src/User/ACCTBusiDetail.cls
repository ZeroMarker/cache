Class User.ACCTBusiDetail Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ACCTBD_Rowid, SqlTableName = ACCT_BusiDetail ]
{

/// des ref to ACCTSysBusiSection
Property AcctSysBusiSectionDr As ACCTSysBusiSection [ SqlFieldName = ACCT_SysBusiSection_Dr ];

/// des ref to ACCTSysBusiPhase
Property AcctSysBusiPhaseDr As ACCTSysBusiPhase [ SqlFieldName = ACCT_SysBusiPhase_Dr ];

/// des ref to ACCTSysBusiType
Property AcctSysBusiTypeDr As ACCTSysBusiType [ SqlFieldName = ACCT_SysBusiType_Dr ];

/// des ref to ACCTYear
Property AcctYearDr As ACCTYear [ SqlFieldName = ACCT_Year_Dr ];

Property AcctSubjDr As ACCTSubj [ SqlFieldName = ACCT_Subj_Dr ];

Property Summary As %String(MAXLEN = 100) [ Required, SqlFieldName = summary ];

Property Caption As %String(MAXLEN = 40) [ Required, SqlFieldName = caption ];

Property Direction As %Integer(DISPLAYLIST = ",0,1", VALUELIST = ",0,1") [ InitialExpression = 0, Required, SqlFieldName = direction ];

Property IsAutoCreate As %Integer(DISPLAYLIST = ",0,1", VALUELIST = ",0,1") [ InitialExpression = 0, Required, SqlFieldName = is_auto_create ];

Property RelayType As %Integer [ SqlFieldName = relay_type ];

Property IsGroup As %Integer(DISPLAYLIST = ",0,1", VALUELIST = ",0,1") [ Required, SqlFieldName = is_group ];

Property MoneyField As %String(DISPLAYLIST = ",Purchase,Sale,Margin", MAXLEN = 8, VALUELIST = ",P,S,M") [ Required, SqlFieldName = money_field ];

Property WhileSql As %String(MAXLEN = 100) [ SqlFieldName = while_sql ];

Property IsFund As %Integer(DISPLAYLIST = ",0,1", VALUELIST = ",0,1") [ InitialExpression = 0, Required, SqlFieldName = is_fund ];

Property IsPay As %Integer(DISPLAYLIST = "0,1", VALUELIST = ",0,1") [ Required, SqlFieldName = is_pay ];

Index PKAcctyearBusitype On (AcctYearDr, AcctSysBusiTypeDr);

Storage Default
{
<Data name="ACCTBusiDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AcctSubjCode</Value>
</Value>
<Value name="3">
<Value>AcctSysBusiSectionDr</Value>
</Value>
<Value name="4">
<Value>AcctYearDr</Value>
</Value>
<Value name="5">
<Value>Caption</Value>
</Value>
<Value name="6">
<Value>DetailId</Value>
</Value>
<Value name="7">
<Value>Direction</Value>
</Value>
<Value name="8">
<Value>IsAutoCreate</Value>
</Value>
<Value name="9">
<Value>IsFund</Value>
</Value>
<Value name="10">
<Value>IsGroup</Value>
</Value>
<Value name="11">
<Value>IsPay</Value>
</Value>
<Value name="12">
<Value>MoneyField</Value>
</Value>
<Value name="13">
<Value>RelayType</Value>
</Value>
<Value name="14">
<Value>Summary</Value>
</Value>
<Value name="15">
<Value>WhileSql</Value>
</Value>
<Value name="16">
<Value>AcctSysBusiPhaseDr</Value>
</Value>
<Value name="17">
<Value>AcctSysBusiTypeDr</Value>
</Value>
<Value name="18">
<Value>AcctSubjDr</Value>
</Value>
</Data>
<DataLocation>^User.ACCTBusiDetailD</DataLocation>
<DefaultData>ACCTBusiDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.ACCTBusiDetailD</IdLocation>
<IndexLocation>^User.ACCTBusiDetailI</IndexLocation>
<StreamLocation>^User.ACCTBusiDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
