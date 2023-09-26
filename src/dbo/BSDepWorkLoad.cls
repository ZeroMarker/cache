/// 输血科工作量汇总
Class dbo.BSDepWorkLoad Extends %Persistent [ Owner = {UnknownUser}, SqlTableName = BS_DepWorkLoad ]
{

Index IndexMaster On (WorkGroupDR, OperationDate, OperationUserDR, OperationType) [ SqlName = Index_Master, Type = index ];

Index IndexOperationType On (WorkGroupDR, OperationType, OperationDate, OperationUserDR) [ SqlName = Index_OperationType, Type = index ];

/// DDL Primary Key Specification
Index PKWorkLoadId On RowID [ PrimaryKey, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 医院代码
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 操作日期
Property OperationDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 操作者
Property OperationUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 1:输血科检测 COMP,2:血袋入库 INPAKC 3:配血 XMPLAN 4:发血 ISS,接收申请单 RECIVE
Property OperationType As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 6 ];

/// 数量汇总
Property TotalNumber As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 7 ];

/// 操作日期
Property OperationTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BSDepWorkLoadDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkGroupDR</Value>
</Value>
<Value name="3">
<Value>OperationDate</Value>
</Value>
<Value name="4">
<Value>OperationUserDR</Value>
</Value>
<Value name="5">
<Value>OperationType</Value>
</Value>
<Value name="6">
<Value>TotalNumber</Value>
</Value>
<Value name="7">
<Value>OperationTime</Value>
</Value>
</Data>
<DataLocation>^dbo.BSDepWorkLoadD</DataLocation>
<DefaultData>BSDepWorkLoadDefaultData</DefaultData>
<IdLocation>^dbo.BSDepWorkLoadD</IdLocation>
<IndexLocation>^dbo.BSDepWorkLoadI</IndexLocation>
<StreamLocation>^dbo.BSDepWorkLoadS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
