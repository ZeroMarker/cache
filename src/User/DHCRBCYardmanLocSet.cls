Class User.DHCRBCYardmanLocSet Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DYLS_RowID, SqlTableName = DHCRBC_YardmanLocSet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DYLS_Dispatcher_DR
Property DYLSDispatcherDR As User.DHCRBCOutWorkerSet [ SqlColumnNumber = 2, SqlFieldName = DYLS_Dispatcher_DR ];

/// DYLS_RecLoc_DR
Property DYLSRecLocDR As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = DYLS_RecLoc_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCYardmanLocSet)</SqlIdExpression>
<SQLMap name="IndexDispatcher">
<Global>^DHCRBCYardmanLocSeti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DYLS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Yardman-Loc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DYLS_Dispatcher_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DYLS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DYLS_Dispatcher_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DYLS_RecLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBCYardmanLocSet</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DYLS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DYLS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCYardmanLocSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
