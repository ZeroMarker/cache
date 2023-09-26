Class User.DHCPHLocPreCode Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHLPC_RowID, SqlTableName = DHC_PHLocPreCode, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// 编码
/// PHLPC_CODE
Property PHLPCCODE As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHLPC_CODE ];

/// 科室ID
/// PHLPC_CTLOC_DR
Property PHLPCCTLOCDR As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = PHLPC_CTLOC_DR ];

/// 发药主表ID 
/// PHLPC_PHA_DR
Property PHLPCPHADR As User.DHCPHACollected [ SqlColumnNumber = 4, SqlFieldName = PHLPC_PHA_DR ];

/// 处方号
/// PHLPC_PRESCNO
Property PHLPCPRESCNO As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PHLPC_PRESCNO ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHLPC)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHLPC_CODE">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHLPC_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHLPC_PHA_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHLPC_PRESCNO">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHLPC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHLPC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHLPC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPrescNo">
<Global>^DHCPHLPC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHLPC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PrescNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHLPC_PRESCNO}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHLPC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHLocPreCodeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
