Class DHCNMG.Intern.MgScoreSub Extends %Persistent
{

Relationship Parref As DHCNMG.Intern.MgScore [ Cardinality = parent, Inverse = ChildSub ];

/// 评分配置表id
Property SubScoreId As %String [ SqlColumnNumber = 2, SqlFieldName = Sub_ScoreId ];

/// 评分表描述
Property SubScoreDesc As %String(MAXLEN = 1000) [ SqlColumnNumber = 3, SqlFieldName = Sub_ScoreDesc ];

/// 评分配置明细表id
Property SubSubScoreId As %String [ SqlColumnNumber = 4, SqlFieldName = Sub_SubScoreId ];

/// 评分表子类描述
Property SubSubScoreDesc As %String(MAXLEN = 1000) [ SqlColumnNumber = 5, SqlFieldName = Sub_SubScoreDesc ];

/// 评分总分
Property SubScore As %String [ SqlColumnNumber = 6, SqlFieldName = Sub_Score ];

/// 评分得分
Property SubRelScore As %String [ SqlColumnNumber = 7, SqlFieldName = Sub_RelScore ];

Index ScoreId On (Parref, SubScoreId, SubSubScoreId);

Storage Default
{
<Data name="MgScoreSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SubScoreId</Value>
</Value>
<Value name="3">
<Value>SubScoreDesc</Value>
</Value>
<Value name="4">
<Value>SubSubScoreId</Value>
</Value>
<Value name="5">
<Value>SubSubScoreDesc</Value>
</Value>
<Value name="6">
<Value>SubScore</Value>
</Value>
<Value name="7">
<Value>SubRelScore</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Intern.MgScoreSubD</DataLocation>
<DefaultData>MgScoreSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNMG.Intern.MgScoreSubI</IndexLocation>
<StreamLocation>^DHCNMG.Intern.MgScoreSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
