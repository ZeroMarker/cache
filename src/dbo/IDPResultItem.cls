/// 鉴定过程结果项
Class dbo.IDPResultItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = IDP_ResultItem ]
{

Index IndexMaster On IDPResultDR [ SqlName = Index_Master, Type = index ];

Index IndexIDPElementItemDR On (IDPResultDR, IDPElementItemDR) [ SqlName = Index_IDPElementItemDR, Type = index ];

Index IndexDataCode On (IDPResultDR, DataCode) [ SqlName = Index_DataCode, Type = index ];

/// Foreign Key FKIDPResultDR created via DDL
ForeignKey FKIDPResultDR(IDPResultDR) References dbo.IDPResult(PKIDPRESULT) [ SqlName = FK_IDPResultDR ];

/// Foreign Key FKIDPElementItemDR created via DDL
ForeignKey FKIDPElementItemDR(IDPElementItemDR) References dbo.BTIDPElementItem(PKBTIDPELEMENTITEM) [ SqlName = FK_IDPElementItemDR ];

/// DDL Primary Key Specification
Index PKIDPRESULTITEM On RowID [ PrimaryKey, SqlName = PK_IDP_RESULTITEM, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 鉴定过程结果主键
Property IDPResultDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 鉴定元素选项
Property IDPElementItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 结果
Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 5 ];

/// 文本结果
Property TxtResult As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 6 ];

/// 数据代码
Property DataCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="IDPResultItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IDPResultDR</Value>
</Value>
<Value name="3">
<Value>IDPElementItemDR</Value>
</Value>
<Value name="4">
<Value>Result</Value>
</Value>
<Value name="5">
<Value>TxtResult</Value>
</Value>
<Value name="6">
<Value>DataCode</Value>
</Value>
</Data>
<DataLocation>^dbo.IDPResultItemD</DataLocation>
<DefaultData>IDPResultItemDefaultData</DefaultData>
<IdLocation>^dbo.IDPResultItemD</IdLocation>
<IndexLocation>^dbo.IDPResultItemI</IndexLocation>
<StreamLocation>^dbo.IDPResultItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
