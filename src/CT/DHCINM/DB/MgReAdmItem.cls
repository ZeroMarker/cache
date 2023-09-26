/// Creater:wangpf
/// Descriptions:专科护士再认证项目
/// Date:2020-07-24
Class CT.DHCINM.DB.MgReAdmItem Extends %Persistent
{

/// 代码
Property ItemCode As %String [ SqlColumnNumber = 2, SqlFieldName = Item_Code ];

/// 约束条件
Property ItemOption As list Of %String(MAXLEN = 500) [ SqlColumnNumber = 3, SqlFieldName = Item_Option ];

/// 约束条件值
Property ItemOptionValue As list Of %String [ SqlColumnNumber = 4, SqlFieldName = Item_OptionValue ];

/// 结果方法
Property ItemResult As %String(MAXLEN = 500) [ SqlColumnNumber = 5, SqlFieldName = Item_Result ];

/// 评分说明
Property ItemDesc As %String [ SqlColumnNumber = 6, SqlFieldName = Item_Desc ];

/// 评分标准
Property ItemStandard As %String [ SqlColumnNumber = 7, SqlFieldName = Item_Standard ];

/// 开始日期
Property ItemStDate As %Date [ SqlColumnNumber = 8, SqlFieldName = Item_StDate ];

/// 结束日期
Property ItemEndDate As %Date [ SqlColumnNumber = 9, SqlFieldName = Item_EndDate ];

Storage Default
{
<Data name="MgReAdmItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemCode</Value>
</Value>
<Value name="3">
<Value>ItemOption</Value>
</Value>
<Value name="4">
<Value>ItemOptionValue</Value>
</Value>
<Value name="5">
<Value>ItemResult</Value>
</Value>
<Value name="6">
<Value>ItemDesc</Value>
</Value>
<Value name="7">
<Value>ItemStandard</Value>
</Value>
<Value name="8">
<Value>ItemStDate</Value>
</Value>
<Value name="9">
<Value>ItemEndDate</Value>
</Value>
</Data>
<DataLocation>^CT.DHCINM.DB.MgReAdmItemD</DataLocation>
<DefaultData>MgReAdmItemDefaultData</DefaultData>
<IdLocation>^CT.DHCINM.DB.MgReAdmItemD</IdLocation>
<IndexLocation>^CT.DHCINM.DB.MgReAdmItemI</IndexLocation>
<StreamLocation>^CT.DHCINM.DB.MgReAdmItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
