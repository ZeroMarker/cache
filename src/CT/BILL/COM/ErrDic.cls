Class CT.BILL.COM.ErrDic Extends %Persistent [ SqlRowIdName = RowId, StorageStrategy = NewStorage1 ]
{

/// 提示代码
Property ErrCode As %String(CAPTION = "提示代码", COLLATION = "EXACT") [ Required, SqlColumnNumber = 2, SqlFieldName = ErrCode ];

/// 默认提示描述
Property ErrDefaultDesc As %String(CAPTION = "默认提示描述", COLLATION = "EXACT", MAXLEN = 500) [ SqlColumnNumber = 3, SqlFieldName = ErrDefaultDesc ];

/// 提示公式
Property ErrConfig As %String(CAPTION = "提示公式", COLLATION = "EXACT", MAXLEN = 500) [ SqlColumnNumber = 4, SqlFieldName = ErrConfig ];

/// 备注
Property Demo As %String(CAPTION = "备注", COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 5, SqlFieldName = Demo ];

/// 规则描述
Property RuleInfo As %String(CAPTION = "规则描述", COLLATION = "EXACT", MAXLEN = 500) [ SqlColumnNumber = 6, SqlFieldName = RuleInfo ];

/// 有效标志
Property ActiveFlag As %String(CAPTION = "有效标志", COLLATION = "EXACT") [ Required, SqlColumnNumber = 7, SqlFieldName = ActiveFlag ];

/// 院区
Property HospDr As %String(CAPTION = "院区", COLLATION = "EXACT") [ Required, SqlColumnNumber = 8, SqlFieldName = HospDr ];

/// -----
/// 创建人
Property OpterId As %String(CAPTION = "创建人", COLLATION = "EXACT") [ SqlColumnNumber = 9, SqlFieldName = OpterId ];

/// 创建日期
Property OptDate As %Library.Date(CAPTION = "创建日期") [ SqlColumnNumber = 10, SqlFieldName = OptDate ];

/// 创建时间
Property OptTime As %Library.Time(CAPTION = "创建时间") [ SqlColumnNumber = 11, SqlFieldName = OptTime ];

/// 更新人
Property UpdtId As %String(CAPTION = "更新人", COLLATION = "EXACT") [ SqlColumnNumber = 12, SqlFieldName = UpdtId ];

/// 更新日期
Property UpdtDate As %Library.Date(CAPTION = "更新日期") [ SqlColumnNumber = 13, SqlFieldName = UpdtDate ];

/// 更新时间
Property UpdtTime As %Library.Time(CAPTION = "更新时间") [ SqlColumnNumber = 14, SqlFieldName = UpdtTime ];

/// 产品线
Property ProductLine As %String(CAPTION = "产品线", COLLATION = "EXACT") [ SqlColumnNumber = 15, SqlFieldName = ProductLine ];

/// 模块
Property ProductModule As %String(CAPTION = "模块", COLLATION = "EXACT") [ SqlColumnNumber = 16, SqlFieldName = ProductModule ];

/// 提示类型
Property ErrType As %String(CAPTION = "提示类型", COLLATION = "EXACT") [ SqlColumnNumber = 17, SqlFieldName = ErrType ];

Index IndexErrCodeHospAct On (ErrCode As Exact, HospDr As Exact, ActiveFlag As Exact);

Storage NewStorage1
{
<Data name="DataMaster">
<Value name="1">
<Value>ErrCode</Value>
</Value>
<Value name="2">
<Value>ErrDefaultDesc</Value>
</Value>
<Value name="3">
<Value>ErrConfig</Value>
</Value>
<Value name="4">
<Value>Demo</Value>
</Value>
<Value name="5">
<Value>RuleInfo</Value>
</Value>
<Value name="6">
<Value>ActiveFlag</Value>
</Value>
<Value name="7">
<Value>HospDr</Value>
</Value>
<Value name="8">
<Value>OpterId</Value>
</Value>
<Value name="9">
<Value>OptDate</Value>
</Value>
<Value name="10">
<Value>OptTime</Value>
</Value>
<Value name="11">
<Value>UpdtId</Value>
</Value>
<Value name="12">
<Value>UpdtDate</Value>
</Value>
<Value name="13">
<Value>UpdtTime</Value>
</Value>
<Value name="14">
<Value>ProductLine</Value>
</Value>
<Value name="15">
<Value>ProductModule</Value>
</Value>
<Value name="16">
<Value>ErrType</Value>
</Value>
<Value name="17">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CT.BILL.COM.ErrDicD</DataLocation>
<DefaultData>DataMaster</DefaultData>
<IdLocation>^CT.BILL.COM.ErrDicD</IdLocation>
<IndexLocation>^CT.BILL.COM.ErrDicI</IndexLocation>
<StreamLocation>^CT.BILL.COM.ErrDicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
