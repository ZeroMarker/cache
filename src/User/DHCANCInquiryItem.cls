Class User.DHCANCInquiryItem Extends %Persistent [ ProcedureBlock, SqlRowIdName = ANCII_RowId, SqlTableName = DHC_ANC_InquiryItem, StorageStrategy = CacheStorage ]
{

Relationship ANCIIParref As User.DHCANCInquiry [ Cardinality = parent, Inverse = ChildDHCANCInquiryItem, SqlFieldName = ANCII_Parref ];

/// 代码
Property ANCIICode As %String(MAXLEN = 500) [ SqlColumnNumber = 2, SqlFieldName = ANCII_Code ];

/// 描述
Property ANCIIDesc As %String [ SqlColumnNumber = 3, SqlFieldName = ANCII_Desc ];

/// 类型
Property ANCIIType As %String(DISPLAYLIST = ",Patient,Baseline,ICD,Docter,Order,Record,Lab", MAXLEN = 8, SELECTIVITY = "12.5%", TRUNCATE = 1, VALUELIST = ",P,B,I,D,O,R,L") [ SqlColumnNumber = 4, SqlFieldName = ANCII_Type ];

/// 查找项
Property ANCIIIsSearch As %Boolean [ SqlColumnNumber = 5, SqlFieldName = ANCII_IsSearch ];

/// 显示项
Property ANCIIIsDisplay As %Boolean [ SqlColumnNumber = 6, SqlFieldName = ANCII_IsDisplay ];

/// 字段
Property ANCIIDataField As %String [ SqlColumnNumber = 7, SqlFieldName = ANCII_DataField ];

/// 返回单条数据
Property ANCIIIsSingle As %Boolean [ SqlColumnNumber = 8, SqlFieldName = ANCII_IsSingle ];

/// 最小值
Property ANCIIMinQty As %Float [ SqlColumnNumber = 9, SqlFieldName = ANCII_MinQty ];

/// 最大值
Property ANCIIMaxQty As %Float [ SqlColumnNumber = 10, SqlFieldName = ANCII_MaxQty ];

/// 说明
Property ANCIINote As %String [ SqlColumnNumber = 11, SqlFieldName = ANCII_Note ];

/// 多选值
Property ANCIIMultiple As %String(MAXLEN = 500) [ SqlColumnNumber = 12, SqlFieldName = ANCII_Multiple ];

/// 开始时间
Property ANCIIStartDateTime As %String [ SqlColumnNumber = 13, SqlFieldName = ANCII_StartDateTime ];

/// 持续小时
Property ANCIIDurationHour As %Float [ SqlColumnNumber = 14, SqlFieldName = ANCII_DurationHour ];

/// 医嘱备注
Property ANCIIOeoriNote As %String [ SqlColumnNumber = 15, SqlFieldName = ANCII_OeoriNote ];

/// 起始时间
Property ANCIIFromTime As %Time [ SqlColumnNumber = 16, SqlFieldName = ANCII_FromTime ];

/// 终止时间
Property ANCIIToTime As %Time [ SqlColumnNumber = 17, SqlFieldName = ANCII_ToTime ];

/// 准确时间
Property ANCIIExactTime As %Time [ SqlColumnNumber = 18, SqlFieldName = ANCII_ExactTime ];

/// 参考常用医嘱ID
Property ANCIIRefAncoId As %String [ SqlColumnNumber = 19, SqlFieldName = ANCII_RefAncoId ];

/// 参考值
Property ANCIIRefValue As %String(MAXLEN = 100) [ SqlColumnNumber = 20, SqlFieldName = ANCII_RefValue ];

/// 排序号
Property ANCIISeqNo As %Float [ SqlColumnNumber = 21, SqlFieldName = ANCII_SeqNo ];

/// 筛选层
Property ANCIILevel As %Float [ SqlColumnNumber = 22, SqlFieldName = ANCII_Level ];

/// 起始常用医嘱ID
Property ANCIIFromAncoId As %String [ SqlColumnNumber = 23, SqlFieldName = ANCII_FromAncoId ];

/// 终止常用医嘱ID
Property ANCIIToAncoId As %String [ SqlColumnNumber = 24, SqlFieldName = ANCII_ToAncoId ];

/// 汇总类型
Property ANCIISummaryType As %String [ SqlColumnNumber = 25, SqlFieldName = ANCII_SummaryType ];

Property ANCIIDurationInterval As %Float [ SqlColumnNumber = 26, SqlFieldName = ANCII_DurationInterval ];

/// 关联ID
Property ANCIIRelateANCIIDr As %String [ SqlColumnNumber = 27, SqlFieldName = ANCII_RelateANCII_Dr ];

/// 列宽
Property ANCIIColumnWidth As %Float [ SqlColumnNumber = 28, SqlFieldName = ANCII_ColumnWidth ];

/// 是否结果筛选项
Property ANCIIIsResultSearch As %Boolean [ SqlColumnNumber = 29, SqlFieldName = ANCII_IsResultSearch ];

/// 开始日期(确定值)
Property ANCIIFromDate As %Date [ SqlColumnNumber = 30, SqlFieldName = ANCII_FromDate ];

/// 结束日期(确定值)
Property ANCIIToDate As %Date [ SqlColumnNumber = 31, SqlFieldName = ANCII_ToDate ];

/// 逻辑非
Property ANCIIIsNegative As %Boolean [ SqlColumnNumber = 32, SqlFieldName = ANCII_IsNegative ];

Storage CacheStorage
{
<Data name="DHCANCInquiryItemClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCANCInquiryItemData">
<Value name="1">
<Value>ANCIICode</Value>
</Value>
<Value name="2">
<Value>ANCIIDesc</Value>
</Value>
<Value name="3">
<Value>ANCIIType</Value>
</Value>
<Value name="4">
<Value>ANCIIIsSearch</Value>
</Value>
<Value name="5">
<Value>ANCIIIsDisplay</Value>
</Value>
<Value name="6">
<Value>ANCIIDataField</Value>
</Value>
<Value name="7">
<Value>ANCIIIsSingle</Value>
</Value>
<Value name="8">
<Value>ANCIIMinQty</Value>
</Value>
<Value name="9">
<Value>ANCIIMaxQty</Value>
</Value>
<Value name="10">
<Value>ANCIINote</Value>
</Value>
<Value name="11">
<Value>ANCIIMultiple</Value>
</Value>
<Value name="12">
<Value>ANCIIStartDateTime</Value>
</Value>
<Value name="13">
<Value>ANCIIDurationHour</Value>
</Value>
<Value name="14">
<Value>ANCIIOeoriNote</Value>
</Value>
<Value name="15">
<Value>ANCIIFromTime</Value>
</Value>
<Value name="16">
<Value>ANCIIToTime</Value>
</Value>
<Value name="17">
<Value>ANCIIExactTime</Value>
</Value>
<Value name="18">
<Value>ANCIIRefAncoId</Value>
</Value>
<Value name="19">
<Value>ANCIIRefValue</Value>
</Value>
<Value name="20">
<Value>ANCIISeqNo</Value>
</Value>
<Value name="21">
<Value>ANCIILevel</Value>
</Value>
<Value name="22">
<Value>ANCIIFromAncoId</Value>
</Value>
<Value name="23">
<Value>ANCIIToAncoId</Value>
</Value>
<Value name="24">
<Value>ANCIISummaryType</Value>
</Value>
<Value name="25">
<Value>ANCIIDurationInterval</Value>
</Value>
<Value name="26">
<Value>ANCIIRelateANCIIDr</Value>
</Value>
<Value name="27">
<Value>ANCIIColumnWidth</Value>
</Value>
<Value name="28">
<Value>ANCIIIsResultSearch</Value>
</Value>
<Value name="29">
<Value>ANCIIFromDate</Value>
</Value>
<Value name="30">
<Value>ANCIIToDate</Value>
</Value>
<Value name="31">
<Value>ANCIIIsNegative</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("I")</DataLocation>
<DefaultData>DHCANCInquiryItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("I")</IdLocation>
<IndexLocation>{%%PARENT}("I",0)</IndexLocation>
<StreamLocation>^User.DHCANCInquiryItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
