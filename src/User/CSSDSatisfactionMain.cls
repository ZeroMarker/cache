/// 满意度调查主表
Class User.CSSDSatisfactionMain Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_SatisfactionMain ]
{

Property CSSDSMNo As %String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = CSSDSM_No ];

Property CSSDSMLoc As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = CSSDSM_Loc ];

Property CSSDSMDate As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = CSSDSM_Date ];

Property CSSDSMTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = CSSDSM_Time ];

Property CSSDSMUserDr As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = CSSDSM_User_DR ];

/// 提交标志 Y提交，N未提交
Property CSSDSMFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ InitialExpression = "N", Required, SqlColumnNumber = 7, SqlFieldName = CSSDSM_Flag ];

/// 提交日期
Property CSSDSMSubmitDate As %Library.Date [ SqlColumnNumber = 8, SqlFieldName = CSSDSM_SubmitDate ];

/// 提交时间
Property CSSDSMSubmitTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = CSSDSM_SubmitTime ];

Property CSSDSMSubmitUserDr As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = CSSDSM_SubmitUser_DR ];

Index CSSDSMDateLocIndex On (CSSDSMDate As Exact, CSSDSMLoc As Exact);

Storage Default
{
<Data name="CSSDSatisfactionMainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDSMNo</Value>
</Value>
<Value name="3">
<Value>CSSDSMLoc</Value>
</Value>
<Value name="4">
<Value>CSSDSMDate</Value>
</Value>
<Value name="5">
<Value>CSSDSMTime</Value>
</Value>
<Value name="6">
<Value>CSSDSMUserDr</Value>
</Value>
<Value name="7">
<Value>CSSDSMFlag</Value>
</Value>
<Value name="8">
<Value>CSSDSMSubmitDate</Value>
</Value>
<Value name="9">
<Value>CSSDSMSubmitTime</Value>
</Value>
<Value name="10">
<Value>CSSDSMSubmitUserDr</Value>
</Value>
</Data>
<DataLocation>^User.CSSDSatisfactionMainD</DataLocation>
<DefaultData>CSSDSatisfactionMainDefaultData</DefaultData>
<IdLocation>^User.CSSDSatisfactionMainD</IdLocation>
<IndexLocation>^User.CSSDSatisfactionMainI</IndexLocation>
<StreamLocation>^User.CSSDSatisfactionMainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
