Class DHCNMG.Intern.MgScoreSta Extends %Persistent
{

/// 评分实习生
Property ScoreStaStu As %String [ SqlColumnNumber = 2, SqlFieldName = ScoreSta_Stu ];

/// 岗前培训理论
Property ScoreStaTheory As %String [ SqlColumnNumber = 3, SqlFieldName = ScoreSta_Theory ];

/// 岗前培训操作
Property ScoreStaOperation As %String [ SqlColumnNumber = 4, SqlFieldName = ScoreSta_Operation ];

/// 期中考核
Property ScoreStaMidterm As %String [ SqlColumnNumber = 5, SqlFieldName = ScoreSta_Midterm ];

/// 期末考核
Property ScoreStaTerm As %String [ SqlColumnNumber = 6, SqlFieldName = ScoreSta_Term ];

/// 更新人
Property ScoreStaRecDR As %String [ SqlColumnNumber = 7, SqlFieldName = ScoreSta_RecDR ];

/// 更新时间
Property ScoreStaDate As %Date [ SqlColumnNumber = 8, SqlFieldName = ScoreSta_Date ];

Index Stu On ScoreStaStu;

Storage Default
{
<Data name="MgScoreStaDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ScoreStaStu</Value>
</Value>
<Value name="3">
<Value>ScoreStaTheory</Value>
</Value>
<Value name="4">
<Value>ScoreStaOperation</Value>
</Value>
<Value name="5">
<Value>ScoreStaMidterm</Value>
</Value>
<Value name="6">
<Value>ScoreStaTerm</Value>
</Value>
<Value name="7">
<Value>ScoreStaRecDR</Value>
</Value>
<Value name="8">
<Value>ScoreStaDate</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Intern.MgScoreStaD</DataLocation>
<DefaultData>MgScoreStaDefaultData</DefaultData>
<IdLocation>^DHCNMG.Intern.MgScoreStaD</IdLocation>
<IndexLocation>^DHCNMG.Intern.MgScoreStaI</IndexLocation>
<StreamLocation>^DHCNMG.Intern.MgScoreStaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
