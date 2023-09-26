/// Creator: 王聪聪
/// Date：2019-09-06
/// Desc: 考核维度字表维护
Class DHCNMG.DB.MgAssessItemSub Extends %Persistent
{

Relationship Parref As DHCNMG.DB.MgAssessItem [ Cardinality = parent, Inverse = ChildSub ];

/// 指标条目
Property SubDesc As %String(MAXLEN = 1000) [ SqlColumnNumber = 2, SqlFieldName = Sub_Desc ];

/// 扣分标准
Property SubStandard As %String(MAXLEN = 1000) [ SqlColumnNumber = 3, SqlFieldName = Sub_Standard ];

/// 分值
Property SubScore As %String [ SqlColumnNumber = 4, SqlFieldName = Sub_Score ];

/// 父节点
Property SubPar As %String [ SqlColumnNumber = 5, SqlFieldName = Sub_Par ];

/// 序号
Property SubSort As %String [ SqlColumnNumber = 6, SqlFieldName = Sub_Sort ];

/// 启用日期
Property SubStDate As %Date [ SqlColumnNumber = 7, SqlFieldName = Sub_StDate ];

/// 停用日期
Property SubEndDate As %Date [ SqlColumnNumber = 8, SqlFieldName = Sub_EndDate ];

Index par On SubPar;

Storage Default
{
<Data name="MgAssessItemSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SubDesc</Value>
</Value>
<Value name="3">
<Value>SubStandard</Value>
</Value>
<Value name="4">
<Value>SubScore</Value>
</Value>
<Value name="5">
<Value>SubPar</Value>
</Value>
<Value name="6">
<Value>SubSort</Value>
</Value>
<Value name="7">
<Value>SubStDate</Value>
</Value>
<Value name="8">
<Value>SubEndDate</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgAssessItemSubD</DataLocation>
<DefaultData>MgAssessItemSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNMG.DB.MgAssessItemSubI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgAssessItemSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
