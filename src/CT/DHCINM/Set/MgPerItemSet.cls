/// 护士档案子级项目页签配置
Class CT.DHCINM.Set.MgPerItemSet Extends %Persistent
{

/// 项目编码
Property ItemCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = PerItem_Code ];

/// 项目名称
Property ItemDesc As %String [ SqlColumnNumber = 3, SqlFieldName = PerItem_Desc ];

/// 显示顺序
Property SortIdx As %Integer [ Required, SqlColumnNumber = 4, SqlFieldName = PerItem_SortIdx ];

/// 是否显示
Property ShowFlag As %String(DISPLAYLIST = ",显示,隐藏", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = PerItem_ShowFlag ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 6, SqlFieldName = PerItem_CreateDate ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {+$p($h, ",", 2)}, SqlColumnNumber = 7, SqlFieldName = PerItem_CreateTime ];

Index Code On ItemCode;

Index Sort On SortIdx;

Index CodeSort On (ItemCode, SortIdx);

Storage Default
{
<Data name="MgPerItemSetDefaultData">
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
<Value>SortIdx</Value>
</Value>
<Value name="5">
<Value>ShowFlag</Value>
</Value>
<Value name="6">
<Value>CreateDate</Value>
</Value>
<Value name="7">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^CT.DHCINM.Set.MgPerItemSetD</DataLocation>
<DefaultData>MgPerItemSetDefaultData</DefaultData>
<IdLocation>^CT.DHCINM.Set.MgPerItemSetD</IdLocation>
<IndexLocation>^CT.DHCINM.Set.MgPerItemSetI</IndexLocation>
<StreamLocation>^CT.DHCINM.Set.MgPerItemSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
