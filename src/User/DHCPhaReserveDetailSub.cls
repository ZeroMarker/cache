Class User.DHCPhaReserveDetailSub Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PRDETS_Rowid, SqlTableName = DHC_PhaReserveDetailSub, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PRDETSChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PhaReserveDetail Parent Reference
Relationship PRDETSPRDETParref As User.DHCPhaReserveDetail [ Cardinality = parent, Inverse = ChildDHCPhaReserveDetailSub, Required, SqlFieldName = PRDETS_PRDET_Parref ];

/// PRDETS_ChildSub
Property PRDETSChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PRDETS_ChildSub ];

/// PRDETS_PHARET_Dr,医嘱改造指向孙表
Property PRDETSPHARETDr As User.DHCPhaReturnItmLB [ SqlColumnNumber = 3, SqlFieldName = PRDETS_PHARET_Dr ];

/// PRDETS_Qty
Property PRDETSQty As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PRDETS_Qty ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="IndexPhaRet">
<Global>^DHCPRES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PhaReserve.PRES_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHC_PhaReserveDetail.PRDET_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>PRDETS_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PhaRet"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRDETS_PHARET_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PhaReserve.PRES_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_PhaReserveDetail.PRDET_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PRDETS_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="datamast">
<Data name="PRDETS_PHARET_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PRDETS_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPRES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PhaReserve.PRES_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_PhaReserveDetail.PRDET_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PRDETS_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PhaReserve.PRES_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DET"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_PhaReserveDetail.PRDET_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"SUB"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PRDETS_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPhaReserveDetailSubS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
