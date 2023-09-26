/// creator: xbl
/// createdate: 20170925
/// description: 调查项目维护
Class DHCNMG.DB.MgSurveyItem Extends %Persistent
{

Relationship ChildSub As DHCNMG.DB.MgSurveyItemSub [ Cardinality = children, Inverse = Parref ];

Relationship StdChildSub As DHCNMG.DB.MgSurveyStandard [ Cardinality = children, Inverse = Parref ];

/// 代码
Property ItemCode As %String [ SqlColumnNumber = 2, SqlFieldName = Item_Code ];

/// 描述
Property ItemDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Item_Desc ];

/// 调查类型
Property ItemTypeDR As DHCNMG.Set.MgSysParamSub [ SqlColumnNumber = 4, SqlFieldName = Item_TypeDR ];

/// 适用范围
Property ItemUseType As %String [ SqlColumnNumber = 5, SqlFieldName = Item_UseType ];

/// 范围设置
Property ItemUseDR As %String [ SqlColumnNumber = 6, SqlFieldName = Item_UseDR ];

/// 启用日期
Property ItemStDate As %Date [ SqlColumnNumber = 7, SqlFieldName = Item_StDate ];

/// 停用日期
Property ItemEndDate As %Date [ SqlColumnNumber = 8, SqlFieldName = Item_EndDate ];

/// 备注
Property ItemRemark As %String(MAXLEN = 1000) [ SqlColumnNumber = 9, SqlFieldName = Item_Remark ];

Index Code On ItemCode;

Index Type On ItemTypeDR;

Index Use On (ItemUseType, ItemUseDR);

Storage Default
{
<Data name="MgSurveyItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemCode</Value>
</Value>
<Value name="3">
<Value>ItemDesc</Value>
</Value>
<Value name="4">
<Value>ItemTypeDR</Value>
</Value>
<Value name="5">
<Value>ItemUseType</Value>
</Value>
<Value name="6">
<Value>ItemUseDR</Value>
</Value>
<Value name="7">
<Value>ItemRemark</Value>
</Value>
<Value name="8">
<Value>ItemResultType</Value>
</Value>
<Value name="9">
<Value>ItemResult</Value>
</Value>
<Value name="10">
<Value>ItemStDate</Value>
</Value>
<Value name="11">
<Value>ItemEndDate</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgSurveyItemD</DataLocation>
<DefaultData>MgSurveyItemDefaultData</DefaultData>
<IdLocation>^DHCNMG.DB.MgSurveyItemD</IdLocation>
<IndexLocation>^DHCNMG.DB.MgSurveyItemI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgSurveyItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
