/// 满意度调查明细
Class User.CSSDSatisfactionDetail Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_SatisfactionDetail ]
{

Property CSSDSDMainDr As User.CSSDSatisfactionMain [ SqlColumnNumber = 2, SqlFieldName = CSSDSD_MainDr ];

Property CSSDSDSatisfactionDr As CT.STER.CSSD.Satisfaction [ SqlColumnNumber = 3, SqlFieldName = CSSDSD_SatisfactionDr ];

/// S:满意 RS：相对满意 DS：较满意  其他：输入框的值
Property CSSDSDResult As %String(COLLATION = "Exact") [ SqlColumnNumber = 4, SqlFieldName = CSSDSD_Result ];

Index CSSDSDMainDrSatisfactionDrIndex On (CSSDSDMainDr As Exact, CSSDSDSatisfactionDr As Exact);

Index CSSDSDMainDrIndex On CSSDSDMainDr As Exact;

Index CSSDSDSatisfactionDrIndex On CSSDSDSatisfactionDr As Exact;

Storage Default
{
<Data name="CSSDSatisfactionDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDSDMainDr</Value>
</Value>
<Value name="3">
<Value>CSSDSDSatisfactionDr</Value>
</Value>
<Value name="4">
<Value>CSSDSDResult</Value>
</Value>
</Data>
<DataLocation>^User.CSSDSatisfactionDetailD</DataLocation>
<DefaultData>CSSDSatisfactionDetailDefaultData</DefaultData>
<IdLocation>^User.CSSDSatisfactionDetailD</IdLocation>
<IndexLocation>^User.CSSDSatisfactionDetailI</IndexLocation>
<StreamLocation>^User.CSSDSatisfactionDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
