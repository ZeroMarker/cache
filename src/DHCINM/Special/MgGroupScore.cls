/// Creater:wangpf
/// Descriptions:专业组年终评分
/// Date:2020-07-23
Class DHCINM.Special.MgGroupScore Extends %Persistent
{

/// 人员
Property ScorePer As CF.DHCINM.HR.Persons [ SqlColumnNumber = 2, SqlFieldName = Score_Per ];

/// 专业组
Property ScoreType As CT.DHCINM.DB.MgSetCodeSub [ SqlColumnNumber = 3, SqlFieldName = Score_Type ];

/// 积极性分数
Property ScoreMotivation As %String [ SqlColumnNumber = 4, SqlFieldName = Score_Motivation ];

/// 实际贡献情况分数
Property ScoreContribute As %String [ SqlColumnNumber = 5, SqlFieldName = Score_Contribute ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 6, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 8, SqlFieldName = Create_Time ];

/// 更新人
Property Updator As %String [ SqlColumnNumber = 9, SqlFieldName = Updator ];

/// 更新日期
Property UpdateDate As %Date [ SqlColumnNumber = 10, SqlFieldName = Update_Date ];

/// 更新时间
Property UpdateTime As %Time [ SqlColumnNumber = 11, SqlFieldName = Update_Time ];

Index ToolIndex On (ScoreType, UpdateDate);

Storage Default
{
<Data name="MgGroupScoreDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ScorePer</Value>
</Value>
<Value name="3">
<Value>ScoreType</Value>
</Value>
<Value name="4">
<Value>ScoreMotivation</Value>
</Value>
<Value name="5">
<Value>ScoreContribute</Value>
</Value>
<Value name="6">
<Value>Creator</Value>
</Value>
<Value name="7">
<Value>CreateDate</Value>
</Value>
<Value name="8">
<Value>CreateTime</Value>
</Value>
<Value name="9">
<Value>Updator</Value>
</Value>
<Value name="10">
<Value>UpdateDate</Value>
</Value>
<Value name="11">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Special.MgGroupScoreD</DataLocation>
<DefaultData>MgGroupScoreDefaultData</DefaultData>
<IdLocation>^DHCINM.Special.MgGroupScoreD</IdLocation>
<IndexLocation>^DHCINM.Special.MgGroupScoreI</IndexLocation>
<StreamLocation>^DHCINM.Special.MgGroupScoreS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
