Class CKB.PDSS.DicLog Extends (%Persistent, User.Abstract) [ SqlRowIdName = DLG_RowID, SqlTableName = DicLog ]
{

/// D ##class(CKB.PDSS.DicLog).%BuildIndices()
/// 表ID
Property DLGDicDr As %String(MAXLEN = 100) [ SqlColumnNumber = 2, SqlFieldName = DLG_Dic ];

/// 记录ID
Property DLGDataDr As %String [ SqlColumnNumber = 3, SqlFieldName = DLG_Data_Dr ];

/// 功能
Property DLGFunction As %String(MAXLEN = 1000) [ SqlColumnNumber = 4, SqlFieldName = DLG_Function ];

/// 操作人
Property DLGOperator As %String(MAXLEN = 100) [ SqlColumnNumber = 5, SqlFieldName = DLG_Operator ];

/// 操作日期  EC_RDate
Property DLGDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = DLG_Date ];

/// 操作时间  EC_RTime
Property DLGTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = DLG_Time ];

/// 作用域
Property DLGScope As %String(MAXLEN = 1000) [ SqlColumnNumber = 8, SqlFieldName = DLG_Scope ];

/// 作用域值
Property DLGScopeValue As %String(MAXLEN = 1000) [ SqlColumnNumber = 9, SqlFieldName = DLG_ScopeValue ];

/// IP
Property DLGClientIPAddress As %String(MAXLEN = 1000) [ SqlColumnNumber = 10, SqlFieldName = DLG_ClientIPAddress ];

Index DLGDataDr On DLGDataDr As Exact;

Index Date On DLGDate As Exact;

Index FunSCOPE On (DLGFunction As Exact, DLGDicDr As Exact, DLGScope As Exact, DLGScopeValue As Exact, DLGDataDr As Exact);

Index Function On (DLGDicDr As Exact, DLGDataDr As Exact, DLGFunction As Exact);

Index SCOPE On (DLGScope As Exact, DLGScopeValue As Exact, DLGDicDr As Exact, DLGDataDr As Exact, DLGFunction As Exact);

Storage Default
{
<Data name="DicLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DLGDicDr</Value>
</Value>
<Value name="3">
<Value>DLGDataDr</Value>
</Value>
<Value name="4">
<Value>DLGFunction</Value>
</Value>
<Value name="5">
<Value>DLGOperator</Value>
</Value>
<Value name="6">
<Value>DLGDate</Value>
</Value>
<Value name="7">
<Value>DLGTime</Value>
</Value>
<Value name="8">
<Value>DLGScope</Value>
</Value>
<Value name="9">
<Value>DLGScopeValue</Value>
</Value>
<Value name="10">
<Value>DLGClientIPAddress</Value>
</Value>
</Data>
<DataLocation>^CKB.PDSS.DicLogD</DataLocation>
<DefaultData>DicLogDefaultData</DefaultData>
<IdLocation>^CKB.PDSS.DicLogD</IdLocation>
<IndexLocation>^CKB.PDSS.DicLogI</IndexLocation>
<StreamLocation>^CKB.PDSS.DicLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
