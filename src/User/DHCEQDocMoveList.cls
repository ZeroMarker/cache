Class User.DHCEQDocMoveList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DML_RowID, SqlTableName = DHC_EQDocMoveList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DML_DocMoveDR
Property DMLDocMoveDR As User.DHCEQDocMove [ SqlColumnNumber = 2, SqlFieldName = DML_DocMoveDR ];

/// DML_ShareNum
Property DMLShareNum As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = DML_ShareNum ];

/// DML_PagesNum
Property DMLPagesNum As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = DML_PagesNum ];

/// DML_Remark
Property DMLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DML_Remark ];

/// DML_DocDR
Property DMLDocDR As User.DHCEQDoc [ SqlColumnNumber = 6, SqlFieldName = DML_DocDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQDocMoveList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DML_DocDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DML_DocMoveDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DML_PagesNum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DML_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DML_ShareNum">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQDocMoveList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DML_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DML_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQDocMoveListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
