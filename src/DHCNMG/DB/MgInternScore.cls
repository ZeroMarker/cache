/// creator: lulin
/// createdate: 2017年12月12日 20:21:31
/// description: 量化评分配置表
Class DHCNMG.DB.MgInternScore Extends %Persistent
{

Relationship ChildSub As DHCNMG.DB.MgInternScoreSub [ Cardinality = children, Inverse = Parref ];

/// 评分代码
Property ScoreCode As %String [ SqlColumnNumber = 2, SqlFieldName = Score_Code ];

/// 评分描述
Property ScoreDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Score_Desc ];

/// 启用日期
Property ScoreStDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Score_StDate ];

/// 停用日期
Property ScoreEndDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Score_EndDate ];

/// 创建人
Property ScorePerDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 6, SqlFieldName = Score_PerDR ];

Index flag On ScoreCode;

Storage Default
{
<Data name="MgInternScoreDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ScoreCode</Value>
</Value>
<Value name="3">
<Value>ScoreDesc</Value>
</Value>
<Value name="4">
<Value>ScoreStDate</Value>
</Value>
<Value name="5">
<Value>ScoreEndDate</Value>
</Value>
<Value name="6">
<Value>ScorePer</Value>
</Value>
<Value name="7">
<Value>ScorePerDR</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgInternScoreD</DataLocation>
<DefaultData>MgInternScoreDefaultData</DefaultData>
<IdLocation>^DHCNMG.DB.MgInternScoreD</IdLocation>
<IndexLocation>^DHCNMG.DB.MgInternScoreI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgInternScoreS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
