Class CKB.PDSS.KnowUpdateLog Extends (%Persistent, User.Abstract) [ SqlRowIdName = KUL_RowID, SqlTableName = KnowUpdateLog ]
{

/// 安全用药知识更新管理日志类 
/// D ##class(CKB.PDSS.KnowUpdateLog).%BuildIndices()
/// 规则更新开始日期
Property KULFromDate As %String [ SqlColumnNumber = 2, SqlFieldName = KUL_FromDate ];

/// 规则更新结束日期
Property KULToDate As %String [ SqlColumnNumber = 3, SqlFieldName = KUL_ToDate ];

/// 更新人
Property KULUserName As %String [ SqlColumnNumber = 4, SqlFieldName = KUL_UserName ];

/// 更新日期
Property KULUpDate As %Date [ SqlColumnNumber = 5, SqlFieldName = KUL_UpDate ];

/// 更新时间
Property KULUpTime As %Time [ SqlColumnNumber = 6, SqlFieldName = KUL_UpTime ];

/// 更新路径
Property KULPath As %String(MAXLEN = 1000) [ SqlColumnNumber = 7, SqlFieldName = KUL_Path ];

/// 更新类型(知识/规则/基础数据)
Property KULType As %String [ SqlColumnNumber = 8, SqlFieldName = KUL_Type ];

/// 更新状态(导入,导出)
Property KULStatus As %String [ SqlColumnNumber = 9, SqlFieldName = KUL_Status ];

/// 更新医院
Property KULHosp As %String [ SqlColumnNumber = 10, SqlFieldName = KUL_Hosp ];

/// 更新版本号(医院全拼缩写码+时间戳)
Property KULVersion As %String(MAXLEN = 1000) [ SqlColumnNumber = 11, SqlFieldName = KUL_Version ];

Storage Default
{
<Data name="KnowUpdateLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>KULFromDate</Value>
</Value>
<Value name="3">
<Value>KULToDate</Value>
</Value>
<Value name="4">
<Value>KULUserName</Value>
</Value>
<Value name="5">
<Value>KULUpDate</Value>
</Value>
<Value name="6">
<Value>KULUpTime</Value>
</Value>
<Value name="7">
<Value>KULPath</Value>
</Value>
<Value name="8">
<Value>KULType</Value>
</Value>
<Value name="9">
<Value>KULStatus</Value>
</Value>
<Value name="10">
<Value>KULVersion</Value>
</Value>
<Value name="11">
<Value>KULHosp</Value>
</Value>
</Data>
<DataLocation>^CKB.PDSS.KnowUpdateLogD</DataLocation>
<DefaultData>KnowUpdateLogDefaultData</DefaultData>
<IdLocation>^CKB.PDSS.KnowUpdateLogD</IdLocation>
<IndexLocation>^CKB.PDSS.KnowUpdateLogI</IndexLocation>
<StreamLocation>^CKB.PDSS.KnowUpdateLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
