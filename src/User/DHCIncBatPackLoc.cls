Class User.DHCIncBatPackLoc Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INBPL_RowID, SqlTableName = DHC_IncBatPackLoc, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 30000;

Property INBPLINBPDr As User.DHCIncBatPack [ Required, SqlColumnNumber = 2, SqlFieldName = INBPL_INBP_Dr ];

Property INBPLLOCDr As User.CTLoc [ Required, SqlColumnNumber = 3, SqlFieldName = INBPL_LOC_Dr ];

Property INBPLBarQty As %Float [ SqlColumnNumber = 4, SqlFieldName = INBPL_BarQty ];

Property INBPLAvailBQty As %Float [ SqlColumnNumber = 5, SqlFieldName = INBPL_AvailBQty ];

Property INBPLINCLBDr As User.INCItmLcBt [ SqlColumnNumber = 6, SqlFieldName = INBPL_INCLB_Dr ];

Property INBPLSanQty As %Float [ SqlColumnNumber = 7, SqlFieldName = INBPL_SanQty ];

Storage SQLStorage
{
<ExtentSize>30000</ExtentSize>
<SqlIdExpression>$i(^DHCINBPL(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="INBPL_AvailBQty">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INBPL_BarQty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INBPL_INBP_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INBPL_INCLB_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INBPL_LOC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INBPL_SanQty">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCINBPL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INBPL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{INBPL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBPLOC">
<Global>^DHCINBPLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INBPL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"BPLOC"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{INBPL_INBP_Dr}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INBPL_LOC_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INBPL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINCLB">
<Global>^DHCINBPLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INBPL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"INCLB"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INBPL_INCLB_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INBPL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCIncBatPackLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
