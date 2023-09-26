Class BILL.DC.PO.CheckResultDet Extends (%Persistent, %XML.Adaptor, %ZEN.DataModel.Adaptor) [ SqlRowIdName = RowId, SqlTableName = CheckResultDet, StorageStrategy = NewStorage1 ]
{

/// 核查结果主表ID BILL_DC_PO.CheckResult
Property ParID As %String(CAPTION = "主表ID", COLLATION = "EXACT") [ SqlColumnNumber = 2, SqlFieldName = ParID ];

/// 数据源
Property DataSrc As %String(CAPTION = "数据源", COLLATION = "EXACT") [ SqlColumnNumber = 3, SqlFieldName = DataSrc ];

/// 数据唯一ID
Property DataID As %String(CAPTION = "数据唯一ID", COLLATION = "EXACT") [ SqlColumnNumber = 4, SqlFieldName = DataID ];

/// 提示代码
Property ErrCode As %String(CAPTION = "提示代码", COLLATION = "EXACT") [ SqlColumnNumber = 5, SqlFieldName = ErrCode ];

/// 提示信息
Property ErrInfo As %String(CAPTION = "提示信息", COLLATION = "EXACT", MAXLEN = 500) [ SqlColumnNumber = 6, SqlFieldName = ErrInfo ];

/// 父节点来源
Property ParNodeDataSrc As %String(CAPTION = "父节点来源", COLLATION = "EXACT") [ SqlColumnNumber = 7, SqlFieldName = ParNodeDataSrc ];

/// 父节点ID
Property ParNodeDataID As %String(CAPTION = "父节点ID", COLLATION = "EXACT") [ SqlColumnNumber = 8, SqlFieldName = ParNodeDataID ];

/// 父节点标志
Property ParNodeFlag As %String(CAPTION = "父节点标志", COLLATION = "EXACT") [ SqlColumnNumber = 9, SqlFieldName = ParNodeFlag ];

/// 审核状态
Property CheckFlag As %String(CAPTION = "审核状态", COLLATION = "EXACT") [ SqlColumnNumber = 10, SqlFieldName = CheckFlag ];

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

/// 审核人
Property UpdtDemo As %String(CAPTION = "审核备注", COLLATION = "EXACT", MAXLEN = 500) [ SqlColumnNumber = 18, SqlFieldName = UpdtDemo ];

Index IndexParID On ParID As Exact;

Index IndexUnique On (ParID As Exact, ErrCode As Exact, DataSrc As Exact, DataID As Exact);

Storage NewStorage1
{
<Data name="DataMaster">
<Value name="1">
<Value>ParID</Value>
</Value>
<Value name="2">
<Value>DataSrc</Value>
</Value>
<Value name="3">
<Value>DataID</Value>
</Value>
<Value name="4">
<Value>ErrCode</Value>
</Value>
<Value name="5">
<Value>ErrInfo</Value>
</Value>
<Value name="6">
<Value>ParNodeDataSrc</Value>
</Value>
<Value name="7">
<Value>ParNodeDataID</Value>
</Value>
<Value name="8">
<Value>ParNodeFlag</Value>
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
<Value>UpdtDemo</Value>
</Value>
<Value name="18">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^BILL.DC.PO.CheckResultDetD</DataLocation>
<DefaultData>DataMaster</DefaultData>
<IdLocation>^BILL.DC.PO.CheckResultDetD</IdLocation>
<IndexLocation>^BILL.DC.PO.CheckResultDetI</IndexLocation>
<StreamLocation>^BILL.DC.PO.CheckResultDetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
