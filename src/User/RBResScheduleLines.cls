Class User.RBResScheduleLines Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_ResScheduleLines, StorageStrategy = SQLStorage ]
{

Property RSLCode As %String [ SqlColumnNumber = 2, SqlFieldName = RSL_Code ];

Property RSLDesc As %String [ SqlColumnNumber = 3, SqlFieldName = RSL_Desc ];

Property RSLStartDate As %Date [ SqlColumnNumber = 4, SqlFieldName = RSL_StartDate ];

Property RSLEndDate As %Date [ SqlColumnNumber = 5, SqlFieldName = RSL_EndDate ];

Property RSLNotes As %String(COLLATION = "Exact", MAXLEN = 9999999999, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = RSL_Notes ];

Property RSLAddUserDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = RSL_AddUser_DR ];

Property RSLAddLocDR As User.CTLoc [ SqlColumnNumber = 8, SqlFieldName = RSL_AddLoc_DR ];

Property RSLAddDate As %Date [ SqlColumnNumber = 9, SqlFieldName = RSL_AddDate ];

Property RSLAddTime As %Time [ SqlColumnNumber = 10, SqlFieldName = RSL_AddTime ];

Property RSLDefault As %String [ SqlColumnNumber = 11, SqlFieldName = RSL_Default ];

Storage SQLStorage
{
<SqlIdExpression>$i(^RB("RSL",0))</SqlIdExpression>
<SQLMap name="Master">
<Data name="RSL_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RSL_AddLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RSL_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RSL_AddUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RSL_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RSL_Default">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RSL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RSL_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RSL_Notes">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RSL_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^RB</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RSL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"RSL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RSL_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RSL_RowId</SqlRowIdName>
<StreamLocation>^User.RBResScheduleLinesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
