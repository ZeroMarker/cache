Class CT.BILL.DC.DicData Extends (%Persistent, %XML.Adaptor, %ZEN.DataModel.Adaptor) [ SqlRowIdName = RowId, StorageStrategy = NewStorage1 ]
{

/// 字典代码
Property DicCode As %String(CAPTION = "字典代码", COLLATION = "EXACT") [ SqlColumnNumber = 2, SqlFieldName = DicCode ];

/// 字典描述
Property DicDesc As %String(CAPTION = "字典描述", COLLATION = "EXACT", MAXLEN = 500) [ SqlColumnNumber = 3, SqlFieldName = DicDesc ];

/// 备注
Property Demo As %String(CAPTION = "备注", COLLATION = "EXACT", MAXLEN = 500) [ SqlColumnNumber = 4, SqlFieldName = Demo ];

/// 对照描述
Property ConDesc As %String(CAPTION = "对照描述", COLLATION = "EXACT", MAXLEN = 500) [ SqlColumnNumber = 5, SqlFieldName = ConDesc ];

/// 对照备注
Property ConDemo As %String(CAPTION = "对照备注", COLLATION = "EXACT") [ SqlColumnNumber = 6, SqlFieldName = ConDemo ];

/// 有效标志
Property ActiveFlag As %String(CAPTION = "有效标志", COLLATION = "EXACT") [ SqlColumnNumber = 7, SqlFieldName = ActiveFlag ];

/// 院区
Property HospDr As %String(CAPTION = "院区", COLLATION = "EXACT") [ SqlColumnNumber = 8, SqlFieldName = HospDr ];

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

/// 对照代码
Property ConCode As %String(CAPTION = "对照代码", COLLATION = "EXACT", MAXLEN = 1000) [ SqlColumnNumber = 15, SqlFieldName = ConCode ];

/// 字典类型
Property DicType As %String(CAPTION = "字典类型", COLLATION = "EXACT") [ SqlColumnNumber = 16, SqlFieldName = DicType ];

Index IndexDicTypeHosp On (HospDr As Exact, DicType As Exact);

Index IndexDicType On DicType As Exact;

Index IndexDicTypeCodeHosp On (HospDr As Exact, DicType As Exact, DicCode As Exact);

Storage NewStorage1
{
<Data name="DataMaster">
<Value name="1">
<Value>DicCode</Value>
</Value>
<Value name="2">
<Value>DicDesc</Value>
</Value>
<Value name="3">
<Value>Demo</Value>
</Value>
<Value name="4">
<Value>ConDesc</Value>
</Value>
<Value name="5">
<Value>ConDemo</Value>
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
<Value>ConCode</Value>
</Value>
<Value name="15">
<Value>DicType</Value>
</Value>
<Value name="16">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CT.BILL.DC.DicDataD</DataLocation>
<DefaultData>DataMaster</DefaultData>
<IdLocation>^CT.BILL.DC.DicDataD</IdLocation>
<IndexLocation>^CT.BILL.DC.DicDataI</IndexLocation>
<StreamLocation>^CT.BILL.DC.DicDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
