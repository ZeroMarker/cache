/// Creator:guozj
/// Descriptions:质控重组模板子表
/// Date:2017-09-14
/// 
Class DHCNMG.DB.MgQualModelSub Extends %Persistent
{

Relationship Parref As DHCNMG.DB.MgQualModel [ Cardinality = parent, Inverse = ChildSub ];

/// 条目名称
Property RestructItem As %String(MAXLEN = 1000) [ SqlColumnNumber = 2, SqlFieldName = Restruct_Item ];

/// 扣分标准
Property RestructStand As %String(MAXLEN = 1000) [ SqlColumnNumber = 3, SqlFieldName = Restruct_Stand ];

/// 分值
Property RestructScore As %String [ SqlColumnNumber = 4, SqlFieldName = Restruct_Score ];

/// 父节点
Property RestructPar As %String [ SqlColumnNumber = 5, SqlFieldName = Restruct_Par ];

/// 序号
Property RestructSort As %String [ SqlColumnNumber = 6, SqlFieldName = Restruct_Sort ];

/// 启用日期
Property RestructStDate As %Date [ SqlColumnNumber = 7, SqlFieldName = Restruct_StDate ];

/// 停用日期
Property RestructEndDate As %Date [ SqlColumnNumber = 8, SqlFieldName = Restruct_EndDate ];

/// 标准质控对应ID
Property QualItemID As DHCNMG.DB.MgQualItemSub [ SqlColumnNumber = 9, SqlFieldName = QualItem_ID ];

Index par On RestructPar;

Index qual On QualItemID;

Storage Default
{
<Data name="MgQualModelSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RestructItem</Value>
</Value>
<Value name="3">
<Value>RestructSort</Value>
</Value>
<Value name="4">
<Value>RestructPar</Value>
</Value>
<Value name="5">
<Value>RestructScore</Value>
</Value>
<Value name="6">
<Value>RestructStand</Value>
</Value>
<Value name="7">
<Value>RestructStDate</Value>
</Value>
<Value name="8">
<Value>RestructEndDate</Value>
</Value>
<Value name="9">
<Value>QualItemID</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgQualModelSubD</DataLocation>
<DefaultData>MgQualModelSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNMG.DB.MgQualModelSubI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgQualModelSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
