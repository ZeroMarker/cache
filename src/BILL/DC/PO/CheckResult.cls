Class BILL.DC.PO.CheckResult Extends (%Persistent, %XML.Adaptor, %ZEN.DataModel.Adaptor) [ SqlRowIdName = RowId, SqlTableName = CheckResult, StorageStrategy = NewStorage1 ]
{

/// 指标业务类型
Property BusinessCode As %String(CAPTION = "指标业务类型", COLLATION = "EXACT") [ Required, SqlColumnNumber = 2, SqlFieldName = BusinessCode ];

/// 指标代码
Property IndicatorCode As %String(CAPTION = "指标代码", COLLATION = "EXACT") [ Required, SqlColumnNumber = 3, SqlFieldName = IndicatorCode ];

/// 指标名称
Property IndicatorName As %String(CAPTION = "指标名称", COLLATION = "EXACT") [ SqlColumnNumber = 4, SqlFieldName = IndicatorName ];

/// 核查方式
Property CheckMode As %String(CAPTION = "核查方式", COLLATION = "EXACT") [ SqlColumnNumber = 5, SqlFieldName = CheckMode ];

/// 核查开始日期
Property CheckStartDate As %Library.Date(CAPTION = "核查开始日期") [ SqlColumnNumber = 6, SqlFieldName = CheckStartDate ];

/// 核查开始时间
Property CheckStartTime As %Library.Time(CAPTION = "核查开始时间") [ SqlColumnNumber = 7, SqlFieldName = CheckStartTime ];

/// 核查结束日期
Property CheckEndDate As %Library.Date(CAPTION = "核查结束日期") [ SqlColumnNumber = 8, SqlFieldName = CheckEndDate ];

/// 核查结束时间
Property CheckEndTime As %Library.Time(CAPTION = "核查结束时间") [ SqlColumnNumber = 9, SqlFieldName = CheckEndTime ];

/// 审核标志 已审核/未审核
Property CheckFlag As %String(CAPTION = "审核标志", COLLATION = "EXACT") [ SqlColumnNumber = 10, SqlFieldName = CheckFlag ];

/// 院区
Property HospDr As %String(CAPTION = "院区", COLLATION = "EXACT") [ SqlColumnNumber = 11, SqlFieldName = HospDr ];

/// -----
/// 创建人
Property OpterId As %String(CAPTION = "创建人", COLLATION = "EXACT") [ SqlColumnNumber = 12, SqlFieldName = OpterId ];

/// 创建日期
Property OptDate As %Library.Date(CAPTION = "创建日期") [ SqlColumnNumber = 13, SqlFieldName = OptDate ];

/// 创建时间
Property OptTime As %Library.Time(CAPTION = "创建时间") [ SqlColumnNumber = 14, SqlFieldName = OptTime ];

/// 审核人
Property UpdtId As %String(CAPTION = "审核人", COLLATION = "EXACT") [ SqlColumnNumber = 15, SqlFieldName = UpdtId ];

/// 审核日期
Property UpdtDate As %Library.Date(CAPTION = "审核日期") [ SqlColumnNumber = 16, SqlFieldName = UpdtDate ];

/// 审核时间
Property UpdtTime As %Library.Time(CAPTION = "审核时间") [ SqlColumnNumber = 17, SqlFieldName = UpdtTime ];

/// 核查批次 
Property CheckBatch As %String(CAPTION = "核查批次", COLLATION = "EXACT") [ Required, SqlColumnNumber = 18, SqlFieldName = CheckBatch ];

/// 异常数量
Property ExceptionNum As %String(CAPTION = "审核人", COLLATION = "EXACT") [ SqlColumnNumber = 19, SqlFieldName = ExceptionNum ];

Index IndexUnique On (CheckBatch As Exact, BusinessCode As Exact, IndicatorCode As Exact);

Index IndexIndicator On (BusinessCode As Exact, IndicatorCode As Exact);

Index IndexOptDateCheckBatch On (OptDate As Exact, CheckBatch As Exact);

Storage NewStorage1
{
<Data name="DataMaster">
<Value name="1">
<Value>BusinessCode</Value>
</Value>
<Value name="2">
<Value>IndicatorCode</Value>
</Value>
<Value name="3">
<Value>IndicatorName</Value>
</Value>
<Value name="4">
<Value>CheckMode</Value>
</Value>
<Value name="5">
<Value>CheckStartDate</Value>
</Value>
<Value name="6">
<Value>CheckStartTime</Value>
</Value>
<Value name="7">
<Value>CheckEndDate</Value>
</Value>
<Value name="8">
<Value>CheckEndTime</Value>
</Value>
<Value name="9">
<Value>CheckFlag</Value>
</Value>
<Value name="10">
<Value>HospDr</Value>
</Value>
<Value name="11">
<Value>OpterId</Value>
</Value>
<Value name="12">
<Value>OptDate</Value>
</Value>
<Value name="13">
<Value>OptTime</Value>
</Value>
<Value name="14">
<Value>UpdtId</Value>
</Value>
<Value name="15">
<Value>UpdtDate</Value>
</Value>
<Value name="16">
<Value>UpdtTime</Value>
</Value>
<Value name="17">
<Value>CheckBatch</Value>
</Value>
<Value name="18">
<Value>ExceptionNum</Value>
</Value>
<Value name="19">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^BILL.DC.PO.CheckResultD</DataLocation>
<DefaultData>DataMaster</DefaultData>
<IdLocation>^BILL.DC.PO.CheckResultD</IdLocation>
<IndexLocation>^BILL.DC.PO.CheckResultI</IndexLocation>
<StreamLocation>^BILL.DC.PO.CheckResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
