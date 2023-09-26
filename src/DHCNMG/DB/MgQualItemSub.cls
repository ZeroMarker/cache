/// Creator:guozj
/// Descriptions:质控项目子表维护
/// Date:2017-09-09
/// 
Class DHCNMG.DB.MgQualItemSub Extends %Persistent
{

Relationship Parref As DHCNMG.DB.MgQualItem [ Cardinality = parent, Inverse = ChildSub ];

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
<Data name="MgQualItemSubDefaultData">
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
<Value>SubStandard</Value>
</Value>
<Value name="6">
<Value>SubPar</Value>
</Value>
<Value name="7">
<Value>SubSort</Value>
</Value>
<Value name="8">
<Value>SubStDate</Value>
</Value>
<Value name="9">
<Value>SubEndDate</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgQualItemSubD</DataLocation>
<DefaultData>MgQualItemSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNMG.DB.MgQualItemSubI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgQualItemSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
