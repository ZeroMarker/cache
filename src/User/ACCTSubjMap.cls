Class User.ACCTSubjMap Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = ACCT_SubjMap ]
{

Property AcctModDr As ACCTSysMode [ Required, SqlFieldName = Acct_Mod_Dr ];

Property AcctSubjDr As ACCTSubj [ Required, SqlFieldName = Acct_Subj_Dr ];

Property TypeCode As %String(MAXLEN = 30) [ Required, SqlFieldName = type_code ];

Property LocDr As CTLoc [ Required, SqlFieldName = loc_dr ];

Property DocType As %String(MAXLEN = 20) [ Required, SqlFieldName = doc_type ];

Index IndexModSubj On (AcctModDr, AcctSubjDr);

Storage Default
{
<Data name="ACCTSubjMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AcctSubjDr</Value>
</Value>
<Value name="3">
<Value>DocType</Value>
</Value>
<Value name="4">
<Value>LocDr</Value>
</Value>
<Value name="5">
<Value>TypeCode</Value>
</Value>
<Value name="6">
<Value>AcctModDr</Value>
</Value>
</Data>
<DataLocation>^User.ACCTSubjMapD</DataLocation>
<DefaultData>ACCTSubjMapDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.ACCTSubjMapD</IdLocation>
<IndexLocation>^User.ACCTSubjMapI</IndexLocation>
<StreamLocation>^User.ACCTSubjMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
