/// 名称:	CT.MA.QC.QualityEntry
/// 描述:	一致性检查点数据表
/// 编写者：hky
/// 编写日期: 2021-06-30
Class CT.MA.QC.QualityEntry Extends %Persistent
{

Index IdxRuleDR On RuleDR;

Index IdxPoolDR On PoolDR;

Index IdxStructDR On StructDR;

Index IdxRuleStruct On (RuleDR, StructDR);

Index IdxIsVetoGrade On (IsVeto, VetoGrade);

Index IdxRulePool On (RuleDR, PoolDR) [ Unique ];

/// 关联质控标准
Property RuleDR As %String(TRUNCATE = 1);

/// 关联质控条目基础数据
Property PoolDR As %String(TRUNCATE = 1);

/// 关联质控结构
Property StructDR As %String(TRUNCATE = 1);

/// 分数
Property Score As %String(TRUNCATE = 1);

/// 位置
Property Sequence As %String(TRUNCATE = 1);

/// 多次评价
Property IsMultiErr As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N");

/// 单项否决
Property IsVeto As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N");

/// 单项否决等级
Property VetoGrade As %String(TRUNCATE = 1);

/// 是否有效
Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N");

/// 条目检查条件
Property EntryConditionDR As %String(TRUNCATE = 1);

Storage Default
{
<Data name="QualityEntryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RuleDR</Value>
</Value>
<Value name="3">
<Value>PoolDR</Value>
</Value>
<Value name="4">
<Value>StructDR</Value>
</Value>
<Value name="5">
<Value>Score</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
<Value name="7">
<Value>IsMultiErr</Value>
</Value>
<Value name="8">
<Value>IsVeto</Value>
</Value>
<Value name="9">
<Value>VetoGrade</Value>
</Value>
<Value name="10">
<Value>IsActive</Value>
</Value>
<Value name="11">
<Value>EntryConditionDR</Value>
</Value>
</Data>
<DataLocation>^CT.MA.QC.QualityEntryD</DataLocation>
<DefaultData>QualityEntryDefaultData</DefaultData>
<IdLocation>^CT.MA.QC.QualityEntryD</IdLocation>
<IndexLocation>^CT.MA.QC.QualityEntryI</IndexLocation>
<StreamLocation>^CT.MA.QC.QualityEntryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
