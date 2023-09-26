Class dbo.BTErrTranslate Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_ErrTranslate ]
{

Index IndexData On (Oper, OldData) [ SqlName = IndexCode, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTERRTRANSLATE On RowID [ PrimaryKey, SqlName = PK_BT_ERRTRANSLATE, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 老数据  
Property OldData As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ Required, SqlColumnNumber = 3 ];

/// 翻译数据  
Property TransData As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ Required, SqlColumnNumber = 4 ];

/// 操作  {0:等于,1:包含,2:替换}
Property Oper As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ Required, SqlColumnNumber = 5 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTErrTranslateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OldData</Value>
</Value>
<Value name="3">
<Value>TransData</Value>
</Value>
<Value name="4">
<Value>Oper</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTErrTranslateD</DataLocation>
<DefaultData>BTErrTranslateDefaultData</DefaultData>
<IdLocation>^dbo.BTErrTranslateD</IdLocation>
<IndexLocation>^dbo.BTErrTranslateI</IndexLocation>
<StreamLocation>^dbo.BTErrTranslateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
