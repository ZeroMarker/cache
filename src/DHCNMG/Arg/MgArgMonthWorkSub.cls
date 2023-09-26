/// Creator:gzj
/// Date:2018-07-20
/// Descriptions:护士月报工作量登记表子表
Class DHCNMG.Arg.MgArgMonthWorkSub Extends %Persistent [ Owner = {dhpm1} ]
{

Relationship Parref As DHCNMG.Arg.MgArgMonthWork [ Cardinality = parent, Inverse = ChildSub ];

/// 节点大项的ID 对应json中的parentid
Property ParentId As %String [ SqlColumnNumber = 2, SqlFieldName = Parent_Id ];

/// 子节点的ID 对应json中children中的CheckItmId
Property CheckItmId As %String [ SqlColumnNumber = 3, SqlFieldName = Check_ItmId ];

/// 检查人次/人次
Property CheckNum As %String [ SqlColumnNumber = 4, SqlFieldName = Check_Num ];

/// 总分
Property Total As %String [ SqlColumnNumber = 5, SqlFieldName = Total ];

/// 平均分
Property Avge As %String [ SqlColumnNumber = 6, SqlFieldName = Avge ];

/// 分子数量
Property MoleNum As %Integer [ SqlColumnNumber = 7, SqlFieldName = Mole_Num ];

/// 分母数量
Property DenoNum As %Integer [ SqlColumnNumber = 8, SqlFieldName = Deno_Num ];

/// 率
Property Rate As %String [ SqlColumnNumber = 9, SqlFieldName = Rate ];

Storage Default
{
<Data name="MgArgMonthWorkSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ParentId</Value>
</Value>
<Value name="3">
<Value>CheckItmId</Value>
</Value>
<Value name="4">
<Value>MoleNum</Value>
</Value>
<Value name="5">
<Value>DenoNum</Value>
</Value>
<Value name="6">
<Value>Rate</Value>
</Value>
<Value name="7">
<Value>CheckNum</Value>
</Value>
<Value name="8">
<Value>Total</Value>
</Value>
<Value name="9">
<Value>Avge</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Arg.MgArgMonthWorkSubD</DataLocation>
<DefaultData>MgArgMonthWorkSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNMG.Arg.MgArgMonthWorkSubI</IndexLocation>
<StreamLocation>^DHCNMG.Arg.MgArgMonthWorkSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
