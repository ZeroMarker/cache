Class User.DHCICUCInquiryItem Extends %Persistent [ ProcedureBlock, SqlRowIdName = ICUCII_RowId, SqlTableName = DHC_ICUC_InquiryItem, StorageStrategy = CacheStorage ]
{

Relationship ICUCIIParref As User.DHCICUCInquiry [ Cardinality = parent, Inverse = ChildDHCICUCInquiryItem, SqlFieldName = ICUCII_Parref ];

/// 代码
Property ICUCIICode As %String(MAXLEN = 500) [ SqlColumnNumber = 2, SqlFieldName = ICUCII_Code ];

/// 描述
Property ICUCIIDesc As %String [ SqlColumnNumber = 3, SqlFieldName = ICUCII_Desc ];

/// 类型
Property ICUCIIType As %String(DISPLAYLIST = ",Patient,Baseline,ICD,Docter,Order,Record,Lab,Calculate,EMR", MAXLEN = 9, SELECTIVITY = "10%", TRUNCATE = 1, VALUELIST = ",P,B,I,D,O,R,L,C,E") [ SqlColumnNumber = 4, SqlFieldName = ICUCII_Type ];

/// 查找项
Property ICUCIIIsSearch As %Boolean [ SqlColumnNumber = 5, SqlFieldName = ICUCII_IsSearch ];

/// 显示项
Property ICUCIIIsDisplay As %Boolean [ SqlColumnNumber = 6, SqlFieldName = ICUCII_IsDisplay ];

/// 字段
Property ICUCIIDataField As %String [ SqlColumnNumber = 7, SqlFieldName = ICUCII_DataField ];

/// 返回单条数据
Property ICUCIIIsSingle As %Boolean [ SqlColumnNumber = 8, SqlFieldName = ICUCII_IsSingle ];

/// 最小值
Property ICUCIIMinQty As %Float [ SqlColumnNumber = 9, SqlFieldName = ICUCII_MinQty ];

/// 最大值
Property ICUCIIMaxQty As %Float [ SqlColumnNumber = 10, SqlFieldName = ICUCII_MaxQty ];

/// 说明
Property ICUCIINote As %String [ SqlColumnNumber = 11, SqlFieldName = ICUCII_Note ];

/// 多选值
Property ICUCIIMultiple As %String(MAXLEN = 200) [ SqlColumnNumber = 12, SqlFieldName = ICUCII_Multiple ];

/// 开始时间
Property ICUCIIStartDateTime As %String [ SqlColumnNumber = 13, SqlFieldName = ICUCII_StartDateTime ];

/// 持续小时
Property ICUCIIDurationHour As %Float [ SqlColumnNumber = 14, SqlFieldName = ICUCII_DurationHour ];

/// 医嘱备注
Property ICUCIIOeoriNote As %String [ SqlColumnNumber = 15, SqlFieldName = ICUCII_OeoriNote ];

/// 起始时间
Property ICUCIIFromAdjSecond As %Integer [ SqlColumnNumber = 16, SqlFieldName = ICUCII_FromAdjSecond ];

/// 终止时间
Property ICUCIIToAdjSecond As %Integer [ SqlColumnNumber = 17, SqlFieldName = ICUCII_ToAdjSecond ];

/// 准确时间
Property ICUCIIExactTime As %Time [ SqlColumnNumber = 18, SqlFieldName = ICUCII_ExactTime ];

/// 参考常用医嘱ID
Property ICUCIIRefIcuriId As %String [ SqlColumnNumber = 19, SqlFieldName = ICUCII_RefIcuriId ];

/// 参考值
Property ICUCIIRefValue As %String [ SqlColumnNumber = 20, SqlFieldName = ICUCII_RefValue ];

/// 排序号
Property ICUCIISeqNo As %Float [ SqlColumnNumber = 21, SqlFieldName = ICUCII_SeqNo ];

/// 筛选层
Property ICUCIILevel As %Float [ SqlColumnNumber = 22, SqlFieldName = ICUCII_Level ];

/// 起始常用医嘱ID
Property ICUCIIFromIcuriId As User.DHCICUCRecordItem [ SqlColumnNumber = 23, SqlFieldName = ICUCII_FromIcuriId ];

/// 终止常用医嘱ID
Property ICUCIIToIcuriId As User.DHCICUCRecordItem [ SqlColumnNumber = 24, SqlFieldName = ICUCII_ToIcuriId ];

/// 汇总类型
Property ICUCIISummaryType As %String [ SqlColumnNumber = 25, SqlFieldName = ICUCII_SummaryType ];

/// 最小持续间隔
Property ICUCIIDurationInterval As %Float [ SqlColumnNumber = 26, SqlFieldName = ICUCII_DurationInterval ];

/// 列宽
Property ICUCIIColumnWidth As %Float [ SqlColumnNumber = 27, SqlFieldName = ICUCII_ColumnWidth ];

/// 主项指针
Property ICUCIIMainICUCIIDr As User.DHCICUCInquiryItem [ SqlColumnNumber = 28, SqlFieldName = ICUCII_MainICUCII_Dr ];

/// 聚集项
Property ICUCIIClustering As %String [ SqlColumnNumber = 29, SqlFieldName = ICUCII_Clustering ];

/// 常用医嘱对应的HIS医嘱代码
Property ICUCIIArcimCode As %String [ SqlColumnNumber = 30, SqlFieldName = ICUCII_ArcimCode ];

/// 计算表达式
Property ICUCIICalculateExpression As %String [ SqlColumnNumber = 31, SqlFieldName = ICUCII_CalculateExpression ];

/// 分类Poison，代码属性
Property ICUCIITypeCat As %String [ SqlColumnNumber = 32, SqlFieldName = ICUCII_TypeCat ];

/// 检验标本代码
Property ICUCIISpecimenCode As %String [ SqlColumnNumber = 33, SqlFieldName = ICUCII_SpecimenCode ];

/// 分割位置
Property ICUCIISplitPos As %String [ SqlColumnNumber = 34, SqlFieldName = ICUC_IISplitPos ];

/// 包含组合项目说明
Property ICUCIIIsCludeRemark As %Boolean [ SqlColumnNumber = 35, SqlFieldName = ICUCII_IsCludeRemark ];

/// 标题组代码，与User.DHCICUCInquiryHeaderGroup对应
Property ICUCIIICUCIHGCode As %String [ SqlColumnNumber = 36, SqlFieldName = ICUCII_ICUCIHGCode ];

Storage CacheStorage
{
<Data name="DHCICUCInquiryItemClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCICUCInquiryItemData">
<Value name="1">
<Value>ICUCIICode</Value>
</Value>
<Value name="2">
<Value>ICUCIIDesc</Value>
</Value>
<Value name="3">
<Value>ICUCIIType</Value>
</Value>
<Value name="4">
<Value>ICUCIIIsSearch</Value>
</Value>
<Value name="5">
<Value>ICUCIIIsDisplay</Value>
</Value>
<Value name="6">
<Value>ICUCIIDataField</Value>
</Value>
<Value name="7">
<Value>ICUCIIIsSingle</Value>
</Value>
<Value name="8">
<Value>ICUCIIMinQty</Value>
</Value>
<Value name="9">
<Value>ICUCIIMaxQty</Value>
</Value>
<Value name="10">
<Value>ICUCIINote</Value>
</Value>
<Value name="11">
<Value>ICUCIIMultiple</Value>
</Value>
<Value name="12">
<Value>ICUCIIStartDateTime</Value>
</Value>
<Value name="13">
<Value>ICUCIIDurationHour</Value>
</Value>
<Value name="14">
<Value>ICUCIIOeoriNote</Value>
</Value>
<Value name="15">
<Value>ICUCIIFromAdjSecond</Value>
</Value>
<Value name="16">
<Value>ICUCIIToAdjSecond</Value>
</Value>
<Value name="17">
<Value>ICUCIIExactTime</Value>
</Value>
<Value name="18">
<Value>ICUCIIRefIcuriId</Value>
</Value>
<Value name="19">
<Value>ICUCIIRefValue</Value>
</Value>
<Value name="20">
<Value>ICUCIISeqNo</Value>
</Value>
<Value name="21">
<Value>ICUCIILevel</Value>
</Value>
<Value name="22">
<Value>ICUCIIFromIcuriId</Value>
</Value>
<Value name="23">
<Value>ICUCIIToIcuriId</Value>
</Value>
<Value name="24">
<Value>ICUCIISummaryType</Value>
</Value>
<Value name="25">
<Value>ICUCIIDurationInterval</Value>
</Value>
<Value name="26">
<Value>ICUCIIColumnWidth</Value>
</Value>
<Value name="27">
<Value>ICUCIIMainICUCIIDr</Value>
</Value>
<Value name="28">
<Value>ICUCIIClustering</Value>
</Value>
<Value name="29">
<Value>ICUCIIArcimCode</Value>
</Value>
<Value name="30">
<Value>ICUCIICalculateExpression</Value>
</Value>
<Value name="31">
<Value>ICUCIITypeCat</Value>
</Value>
<Value name="32">
<Value>ICUCIISpecimenCode</Value>
</Value>
<Value name="33">
<Value>ICUCIISplitPos</Value>
</Value>
<Value name="34">
<Value>ICUCIIIsCludeRemark</Value>
</Value>
</Data>
<Data name="DHCICUCInquiryItemDefaultData">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>ICUCIIICUCIHGDr</Value>
</Value>
<Value name="2">
<Value>ICUCIIICUCIHGCode</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("I")</DataLocation>
<DefaultData>DHCICUCInquiryItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("I")</IdLocation>
<IndexLocation>{%%PARENT}("I",0)</IndexLocation>
<StreamLocation>^User.DHCICUCInquiryItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
