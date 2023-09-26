/// 日间手术科室关联科室表 子表
/// 父表：User.ORCDaySurgeryLoc
/// 基础数据平台-李可凡
/// 2021-05-08
Class User.ORCDaySurgeryLocLinkLoc Extends (%Persistent, User.Abstract) [ SqlRowIdName = DSLLL_RowId, SqlTableName = ORC_DaySurgeryLocLinkLoc ]
{

Relationship DSLLLParRef As User.ORCDaySurgeryLoc [ Cardinality = parent, Inverse = ChildLinkLoc ];

/// 日间手术科室关联科室DR
Property DSLLLLinkLocDR As CTLoc [ Required, SqlColumnNumber = 2, SqlFieldName = DSLLL_LinkLocDR ];

Index LinkLocIndex On (DSLLLLinkLocDR As Exact, DSLLLParRef As Exact);

Index DSLocIndex On (DSLLLParRef As Exact, DSLLLLinkLocDR As Exact);

Storage Default
{
<Data name="ORCDaySurgeryLocLinkLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DSLLLLinkLocDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildLinkLoc")</DataLocation>
<DefaultData>ORCDaySurgeryLocLinkLocDefaultData</DefaultData>
<IdLocation>^User.ORCDaySurgeryLocC("ChildLinkLoc")</IdLocation>
<IndexLocation>^User.ORCDaySurgeryLocLinkLocI</IndexLocation>
<StreamLocation>^User.ORCDaySurgeryLocLinkLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
