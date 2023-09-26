Class dbo.BBDifficultMatch Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_DifficultMatch, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSeqNum On SeqNum [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBDIFFICULTMATCH On RowID [ PrimaryKey, SqlName = PK_BB_DIFFICULTMATCH, Type = index, Unique ];

/// RowID
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 4 ];

/// 描述
Property Description As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 5 ];

/// 序号
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 提示级别 0:警告 1强制提示
Property PromptLevel As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 激活
Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BBDifficultMatchDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>SeqNum</Value>
</Value>
<Value name="6">
<Value>PromptLevel</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBDifficultMatchD</DataLocation>
<DefaultData>BBDifficultMatchDefaultData</DefaultData>
<IdLocation>^dbo.BBDifficultMatchD</IdLocation>
<IndexLocation>^dbo.BBDifficultMatchI</IndexLocation>
<StreamLocation>^dbo.BBDifficultMatchS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
