/// 日间手术科室表 父表
/// 子表：User.ORCDaySurgeryLocLinkLoc
/// 基础数据平台-李可凡
/// 2021-05-08
Class User.ORCDaySurgeryLoc Extends (%Persistent, User.Abstract) [ SqlRowIdName = DSL_RowId, SqlTableName = ORC_DaySurgeryLoc ]
{

/// 日间手术科室关联科室表
Relationship ChildLinkLoc As User.ORCDaySurgeryLocLinkLoc [ Cardinality = children, Inverse = DSLLLParRef ];

/// 日间手术科室DR
Property DSLDaySurgeryLocDR As CTLoc [ Required, SqlColumnNumber = 2, SqlFieldName = DSL_DaySurgeryLocDR ];

/// 日间手术科室索引
Index DaySurgeryLocIndex On DSLDaySurgeryLocDR As Exact;

Storage Default
{
<Data name="ORCDaySurgeryLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DSLDaySurgeryLocDR</Value>
</Value>
</Data>
<DataLocation>^User.ORCDaySurgeryLocD</DataLocation>
<DefaultData>ORCDaySurgeryLocDefaultData</DefaultData>
<IdLocation>^User.ORCDaySurgeryLocD</IdLocation>
<IndexLocation>^User.ORCDaySurgeryLocI</IndexLocation>
<StreamLocation>^User.ORCDaySurgeryLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
