Class User.DHCBPCInquiryItem Extends %Persistent [ ProcedureBlock, SqlRowIdName = BPCII_RowId, SqlTableName = DHC_BPC_InquiryItem, StorageStrategy = CacheStorage ]
{

Relationship BPCIIParref As User.DHCBPCInquiry [ Cardinality = parent, Inverse = ChildDHCBPCInquiryItem, SqlFieldName = BPCII_Parref ];

/// 代码
Property BPCIICode As %String(MAXLEN = 500) [ SqlColumnNumber = 2, SqlFieldName = BPCII_Code ];

/// 描述
Property BPCIIDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BPCII_Desc ];

/// 类型
Property BPCIIType As %String(DISPLAYLIST = ",Patient,Baseline,ICD,Detection,Arrange,Order,Record,Lab,ArrangeOrder", MAXLEN = 9, SELECTIVITY = "10%", TRUNCATE = 1, VALUELIST = ",P,B,I,D,A,O,R,L,AO") [ SqlColumnNumber = 4, SqlFieldName = BPCII_Type ];

/// 查找项
Property BPCIIIsSearch As %Boolean [ SqlColumnNumber = 5, SqlFieldName = BPCII_IsSearch ];

/// 显示项
Property BPCIIIsDisplay As %Boolean [ SqlColumnNumber = 6, SqlFieldName = BPCII_IsDisplay ];

/// 字段
Property BPCIIDataField As %String [ SqlColumnNumber = 7, SqlFieldName = BPCII_DataField ];

/// 返回单条数据
Property BPCIIIsSingle As %Boolean [ SqlColumnNumber = 8, SqlFieldName = BPCII_IsSingle ];

/// 最小值
Property BPCIIMinQty As %Float [ SqlColumnNumber = 9, SqlFieldName = BPCII_MinQty ];

/// 最大值
Property BPCIIMaxQty As %Float [ SqlColumnNumber = 10, SqlFieldName = BPCII_MaxQty ];

/// 说明
Property BPCIINote As %String [ SqlColumnNumber = 11, SqlFieldName = BPCII_Note ];

/// 多选值
Property BPCIIMultiple As %String(MAXLEN = 200) [ SqlColumnNumber = 12, SqlFieldName = BPCII_Multiple ];

/// 开始时间
Property BPCIIStartDateTime As %String [ SqlColumnNumber = 13, SqlFieldName = BPCII_StartDateTime ];

/// 持续小时
Property BPCIIDurationHour As %Float [ SqlColumnNumber = 14, SqlFieldName = BPCII_DurationHour ];

/// 医嘱备注
Property BPCIIOeoriNote As %String [ SqlColumnNumber = 15, SqlFieldName = BPCII_OeoriNote ];

/// 起始时间
Property BPCIIFromAdjSecond As %Integer [ SqlColumnNumber = 16, SqlFieldName = BPCII_FromAdjSecond ];

/// 终止时间
Property BPCIIToAdjSecond As %Integer [ SqlColumnNumber = 17, SqlFieldName = BPCII_ToAdjSecond ];

/// 准确时间
Property BPCIIExactTime As %Time [ SqlColumnNumber = 18, SqlFieldName = BPCII_ExactTime ];

/// 参考常用医嘱ID
Property BPCIIRefBpcriId As User.DHCBPCRecordItem [ SqlColumnNumber = 19, SqlFieldName = BPCII_RefBpcriId ];

/// 参考值
Property BPCIIRefValue As %String [ SqlColumnNumber = 20, SqlFieldName = BPCII_RefValue ];

/// 排序号
Property BPCIISeqNo As %Float [ SqlColumnNumber = 21, SqlFieldName = BPCII_SeqNo ];

/// 筛选层
Property BPCIILevel As %Float [ SqlColumnNumber = 22, SqlFieldName = BPCII_Level ];

/// 起始常用医嘱ID
Property BPCIIFromBpcriId As User.DHCBPCRecordItem [ SqlColumnNumber = 23, SqlFieldName = BPCII_FromBpcriId ];

/// 终止常用医嘱ID
Property BPCIIToBpcriId As User.DHCBPCRecordItem [ SqlColumnNumber = 24, SqlFieldName = BPCII_ToBpcriId ];

/// 汇总类型
Property BPCIISummaryType As %String [ SqlColumnNumber = 25, SqlFieldName = BPCII_SummaryType ];

/// 最小持续间隔
Property BPCIIDurationInterval As %Float [ SqlColumnNumber = 26, SqlFieldName = BPCII_DurationInterval ];

/// 列宽
Property BPCIIColumnWidth As %Float [ SqlColumnNumber = 27, SqlFieldName = BPCII_ColumnWidth ];

/// 主项指针
Property BPCIISummarySeqNo As %String [ SqlColumnNumber = 28, SqlFieldName = BPCII_SummarySeqNo ];

Property BPCIISummaryChartType As %String [ SqlColumnNumber = 29, SqlFieldName = BPCII_SummaryChartType ];

Storage CacheStorage
{
<Data name="DHCBPCInquiryItemClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPCInquiryItemData">
<Value name="1">
<Value>BPCIICode</Value>
</Value>
<Value name="2">
<Value>BPCIIDesc</Value>
</Value>
<Value name="3">
<Value>BPCIIType</Value>
</Value>
<Value name="4">
<Value>BPCIIIsSearch</Value>
</Value>
<Value name="5">
<Value>BPCIIIsDisplay</Value>
</Value>
<Value name="6">
<Value>BPCIIDataField</Value>
</Value>
<Value name="7">
<Value>BPCIIIsSingle</Value>
</Value>
<Value name="8">
<Value>BPCIIMinQty</Value>
</Value>
<Value name="9">
<Value>BPCIIMaxQty</Value>
</Value>
<Value name="10">
<Value>BPCIINote</Value>
</Value>
<Value name="11">
<Value>BPCIIMultiple</Value>
</Value>
<Value name="12">
<Value>BPCIIStartDateTime</Value>
</Value>
<Value name="13">
<Value>BPCIIDurationHour</Value>
</Value>
<Value name="14">
<Value>BPCIIOeoriNote</Value>
</Value>
<Value name="15">
<Value>BPCIIFromAdjSecond</Value>
</Value>
<Value name="16">
<Value>BPCIIToAdjSecond</Value>
</Value>
<Value name="17">
<Value>BPCIIExactTime</Value>
</Value>
<Value name="18">
<Value>BPCIIRefBpcriId</Value>
</Value>
<Value name="19">
<Value>BPCIIRefValue</Value>
</Value>
<Value name="20">
<Value>BPCIISeqNo</Value>
</Value>
<Value name="21">
<Value>BPCIILevel</Value>
</Value>
<Value name="22">
<Value>BPCIIFromBpcriId</Value>
</Value>
<Value name="23">
<Value>BPCIIToBpcriId</Value>
</Value>
<Value name="24">
<Value>BPCIISummaryType</Value>
</Value>
<Value name="25">
<Value>BPCIIDurationInterval</Value>
</Value>
<Value name="26">
<Value>BPCIIColumnWidth</Value>
</Value>
<Value name="27">
<Value>BPCIISummarySeqNo</Value>
</Value>
<Value name="28">
<Value>BPCIISummaryChartType</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("I")</DataLocation>
<DefaultData>DHCBPCInquiryItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("I")</IdLocation>
<IndexLocation>{%%PARENT}("I",0)</IndexLocation>
<StreamLocation>^User.DHCBPCInquiryItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
