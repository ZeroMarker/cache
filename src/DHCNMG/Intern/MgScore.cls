Class DHCNMG.Intern.MgScore Extends %Persistent
{

Relationship ChildSub As DHCNMG.Intern.MgScoreSub [ Cardinality = children, Inverse = Parref ];

/// 评分实习生
Property ScoreStu As %String [ SqlColumnNumber = 2, SqlFieldName = Score_Stu ];

/// 评分实习生病区
Property ScoreWard As DHCNMG.DB.MgWard [ SqlColumnNumber = 3, SqlFieldName = Score_Ward ];

/// 创建人
Property ScoreRecDR As %String [ SqlColumnNumber = 4, SqlFieldName = Score_RecDR ];

/// 创建时间
Property ScoreDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Score_Date ];

/// 总分
Property ScoreScore As %String [ SqlColumnNumber = 6, SqlFieldName = Score_Score ];

/// 轮转次数(第几次)
Property ScoreNum As %Integer [ SqlColumnNumber = 7, SqlFieldName = Score_Num ];

/// 是否已提交,Y已提交，N未提交
Property ScoreFlag As %String [ SqlColumnNumber = 8, SqlFieldName = Score_Flag ];

Index Stu On ScoreStu;

Index Num On ScoreNum;

Index Ward On ScoreWard;

Index StuNum On (ScoreStu, ScoreNum);

Index DateWardStu On (ScoreDate, ScoreWard, ScoreStu);

Storage Default
{
<Data name="MgScoreDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ScoreStu</Value>
</Value>
<Value name="3">
<Value>ScoreWard</Value>
</Value>
<Value name="4">
<Value>ScoreRecDR</Value>
</Value>
<Value name="5">
<Value>ScoreDate</Value>
</Value>
<Value name="6">
<Value>ScoreScore</Value>
</Value>
<Value name="7">
<Value>ScoreNum</Value>
</Value>
<Value name="8">
<Value>ScoreFlag</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Intern.MgScoreD</DataLocation>
<DefaultData>MgScoreDefaultData</DefaultData>
<IdLocation>^DHCNMG.Intern.MgScoreD</IdLocation>
<IndexLocation>^DHCNMG.Intern.MgScoreI</IndexLocation>
<StreamLocation>^DHCNMG.Intern.MgScoreS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
