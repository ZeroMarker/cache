Class User.ACCTSubj Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = ACCT_Subj ]
{

/// 会计科目
/// des ref to ACCTYear
Property AcctYearDr As ACCTYear [ SqlFieldName = ACCT_Year_Dr ];

/// des ref to ACCTSubjType
Property AcctSubjTypeDr As ACCTSubjType [ SqlFieldName = ACCT_SubjTypeDr ];

Property AcctSubjCode As %String(MAXLEN = 30) [ Required, SqlFieldName = acct_subj_code ];

Property ACCTSubjName As %String(MAXLEN = 50) [ Required, SqlFieldName = acct_subj_name ];

Property ACCTSubjNameAll As %String(MAXLEN = 100) [ Required, SqlFieldName = acct_subj_name_all ];

Property SuperSubj As ACCTSubj [ SqlFieldName = acct_SuperSubj ];

Property SubjLevel As %Integer [ Required, SqlFieldName = subj_level ];

Property IsLast As %Integer(DISPLAYLIST = ",0,1", VALUELIST = ",0,1") [ Required, SqlFieldName = is_last ];

Property Direction As %Integer(DISPLAYLIST = ",0,1", VALUELIST = ",0,1") [ Required, SqlFieldName = direction ];

Property IsCash As %Integer(DISPLAYLIST = ",0,1", VALUELIST = ",0,1") [ InitialExpression = 0, Required, SqlFieldName = is_cash ];

Property IsNum As %Integer(DISPLAYLIST = ",0,1", VALUELIST = ",0,1") [ InitialExpression = 0, Required, SqlFieldName = is_num ];

Property IsFc As %Integer(DISPLAYLIST = ",0,1", VALUELIST = ",0,1") [ InitialExpression = 0, Required, SqlFieldName = is_fc ];

Property IsCheck As %Integer(DISPLAYLIST = ",0,1", VALUELIST = ",0,1") [ InitialExpression = 0, Required, SqlFieldName = is_check ];

Property CheckType1 As %String(MAXLEN = 10) [ SqlFieldName = check_type1 ];

Property CheckType2 As %String(MAXLEN = 10) [ SqlFieldName = check_type2 ];

Property CheckType3 As %String(MAXLEN = 10) [ SqlFieldName = check_type3 ];

Property CheckType4 As %String(MAXLEN = 10) [ SqlFieldName = check_type4 ];

Property CheckType5 As %String(MAXLEN = 10) [ SqlFieldName = check_type5 ];

Property CheckType6 As %String(MAXLEN = 10) [ SqlFieldName = check_type6 ];

Property CheckType7 As %String(MAXLEN = 10) [ SqlFieldName = check_type7 ];

Property CheckType8 As %String(MAXLEN = 10) [ SqlFieldName = check_type8 ];

Property Define As %String(MAXLEN = 15) [ SqlFieldName = define ];

Property Spell As %String(MAXLEN = 25) [ SqlFieldName = spell ];

Property IsStop As %Integer(DISPLAYLIST = ",0,1", VALUELIST = ",0,1") [ InitialExpression = 0, Required, SqlFieldName = is_stop ];

Property IsCbcs As %Integer(DISPLAYLIST = ",0,1", VALUELIST = ",0,1") [ InitialExpression = 0, Required, SqlFieldName = is_cbcs ];

Property IsZero As %Integer(DISPLAYLIST = ",0,1", VALUELIST = ",0,1") [ InitialExpression = 0, Required, SqlFieldName = is_zero ];

Property SubjDefine As %Integer [ InitialExpression = 0, Required, SqlFieldName = subj_define ];

Property IsBudge As %String(MAXLEN = 10) [ SqlFieldName = is_budge ];

Index PKAcctyearSubjcode On (AcctYearDr, AcctSubjCode) [ Unique ];

Storage Default
{
<Data name="ACCTSubjDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ACCTSubjName</Value>
</Value>
<Value name="3">
<Value>ACCTSubjNameAll</Value>
</Value>
<Value name="4">
<Value>AcctSubjCode</Value>
</Value>
<Value name="5">
<Value>AcctSubjTypeDr</Value>
</Value>
<Value name="6">
<Value>AcctYearDr</Value>
</Value>
<Value name="7">
<Value>BeginDate</Value>
</Value>
<Value name="8">
<Value>CheckType1</Value>
</Value>
<Value name="9">
<Value>CheckType2</Value>
</Value>
<Value name="10">
<Value>CheckType3</Value>
</Value>
<Value name="11">
<Value>CheckType4</Value>
</Value>
<Value name="12">
<Value>CheckType5</Value>
</Value>
<Value name="13">
<Value>CheckType6</Value>
</Value>
<Value name="14">
<Value>CheckType7</Value>
</Value>
<Value name="15">
<Value>CheckType8</Value>
</Value>
<Value name="16">
<Value>Define</Value>
</Value>
<Value name="17">
<Value>Direction</Value>
</Value>
<Value name="18">
<Value>EndDate</Value>
</Value>
<Value name="19">
<Value>IsBudge</Value>
</Value>
<Value name="20">
<Value>IsCash</Value>
</Value>
<Value name="21">
<Value>IsCbcs</Value>
</Value>
<Value name="22">
<Value>IsCheck</Value>
</Value>
<Value name="23">
<Value>IsFc</Value>
</Value>
<Value name="24">
<Value>IsLast</Value>
</Value>
<Value name="25">
<Value>IsNum</Value>
</Value>
<Value name="26">
<Value>IsStop</Value>
</Value>
<Value name="27">
<Value>IsZero</Value>
</Value>
<Value name="28">
<Value>Spell</Value>
</Value>
<Value name="29">
<Value>SubjDefine</Value>
</Value>
<Value name="30">
<Value>SubjLevel</Value>
</Value>
<Value name="31">
<Value>SuperCode</Value>
</Value>
<Value name="32">
<Value>SuperSubj</Value>
</Value>
</Data>
<DataLocation>^User.ACCTSubjD</DataLocation>
<DefaultData>ACCTSubjDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.ACCTSubjD</IdLocation>
<IndexLocation>^User.ACCTSubjI</IndexLocation>
<StreamLocation>^User.ACCTSubjS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
