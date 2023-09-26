/// 重症评分数据表
Class User.DHCICUScoreData Extends %Library.Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DHC_ICU_ScoreData ]
{

Property ICUScore As User.DHCICUScore [ Required, SqlColumnNumber = 2 ];

Property ItemCode As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 3 ];

Property ItemDesc As %String(MAXLEN = 1000) [ Required, SqlColumnNumber = 4 ];

Property ItemValue As %String(MAXLEN = 3000) [ SqlColumnNumber = 5 ];

Property ItemDate As %Date [ SqlColumnNumber = 6 ];

Property ItemTime As %Time [ SqlColumnNumber = 7 ];

Property UpdateUser As %String [ SqlColumnNumber = 8 ];

Property UpdateDate As %Date [ SqlColumnNumber = 9 ];

Property UpdateTime As %Time [ SqlColumnNumber = 10 ];

Property ItemNote As %String(MAXLEN = 3000) [ SqlColumnNumber = 11 ];

Index IScore On ICUScore;

Index ICode On (ICUScore, ItemCode) [ Unique ];

/// 数据项外键约束
ForeignKey FKScore(ICUScore) References User.DHCICUScore() [ OnDelete = cascade ];

Storage Default
{
<Data name="DHCICUScoreDataDefaultData">
<Value name="1">
<Value>ICUScore</Value>
</Value>
<Value name="2">
<Value>ItemCode</Value>
</Value>
<Value name="3">
<Value>ItemDesc</Value>
</Value>
<Value name="4">
<Value>ItemValue</Value>
</Value>
<Value name="5">
<Value>ItemDate</Value>
</Value>
<Value name="6">
<Value>ItemTime</Value>
</Value>
<Value name="7">
<Value>UpdateUser</Value>
</Value>
<Value name="8">
<Value>UpdateDate</Value>
</Value>
<Value name="9">
<Value>UpdateTime</Value>
</Value>
<Value name="10">
<Value>ItemNote</Value>
</Value>
</Data>
<DataLocation>^User.DHCICUScoreDataD</DataLocation>
<DefaultData>DHCICUScoreDataDefaultData</DefaultData>
<IdLocation>^User.DHCICUScoreDataD</IdLocation>
<IndexLocation>^User.DHCICUScoreDataI</IndexLocation>
<StreamLocation>^User.DHCICUScoreDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
