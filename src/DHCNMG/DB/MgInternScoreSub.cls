/// creator: lulin
/// createdate: 2017年12月12日 20:21:31
/// description: 量化评分配置明细表
Class DHCNMG.DB.MgInternScoreSub Extends %Persistent
{

Relationship Parref As DHCNMG.DB.MgInternScore [ Cardinality = parent, Inverse = ChildSub ];

/// 评分明细代码
Property SubCode As %String(MAXLEN = 1000) [ SqlColumnNumber = 2, SqlFieldName = Sub_Code ];

/// 评分明细描述
Property SubDesc As %String(MAXLEN = 1000) [ SqlColumnNumber = 3, SqlFieldName = Sub_Desc ];

/// 分值
Property SubScore As %String [ SqlColumnNumber = 4, SqlFieldName = Sub_Score ];

/// 启用日期
Property SubStDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Sub_StDate ];

/// 停用日期
Property SubEndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = Sub_EndDate ];

/// 创建人
Property SubPerDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 7, SqlFieldName = Sub_PerDR ];

Storage Default
{
<Data name="MgInternScoreSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SubCode</Value>
</Value>
<Value name="3">
<Value>SubDesc</Value>
</Value>
<Value name="4">
<Value>SubScore</Value>
</Value>
<Value name="5">
<Value>SubStDate</Value>
</Value>
<Value name="6">
<Value>SubEndDate</Value>
</Value>
<Value name="7">
<Value>SubPer</Value>
</Value>
<Value name="8">
<Value>SubPerDR</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgInternScoreSubD</DataLocation>
<DefaultData>MgInternScoreSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNMG.DB.MgInternScoreSubI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgInternScoreSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
