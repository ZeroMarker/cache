/// 自动审核公式项
Class dbo.BTCheckValidFormulaItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_CheckValidFormulaItem ]
{

/// Foreign Key FKBTCheckValidFormulaItemCheckValidFormulaDR created via DDL
ForeignKey FKBTCheckValidFormulaItemCheckValidFormulaDR(CheckValidFormulaDR) References dbo.BTCheckValidFormula(PKBTCHECKVALIDFORMULA) [ SqlName = FK_BTCheckValidFormulaItemCheckValidFormulaDR ];

/// DDL Primary Key Specification
Index PKBTCHECKVALIDFORMULAITEM On RowID [ PrimaryKey, SqlName = PK_BT_CHECKVALIDFORMULAITEM, Type = index, Unique ];

Index IndexMaster On (CheckValidFormulaDR, ItemType) [ SqlName = Index_Master, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 公式主键
Property CheckValidFormulaDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 项目类型
Property ItemType As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BTCheckValidFormulaItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckValidFormulaDR</Value>
</Value>
<Value name="3">
<Value>ItemType</Value>
</Value>
<Value name="4">
<Value>TestCodeDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTCheckValidFormulaItemD</DataLocation>
<DefaultData>BTCheckValidFormulaItemDefaultData</DefaultData>
<IdLocation>^dbo.BTCheckValidFormulaItemD</IdLocation>
<IndexLocation>^dbo.BTCheckValidFormulaItemI</IndexLocation>
<StreamLocation>^dbo.BTCheckValidFormulaItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
