Class User.DHCINStktkPackage Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DSTKP_RowId, SqlTableName = DHC_INStktkPackage, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DSTKPChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_InStkTkInput Parent Reference
Relationship DSTKPParref As User.DHCInStkTkInput [ Cardinality = parent, Inverse = ChildINStktkPackage, Required, SqlFieldName = DSTKP_Parref ];

/// DSTKP_ChildSub
Property DSTKPChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = DSTKP_ChildSub ];

/// DSTKP_MATP_Dr
Property DSTKPMATPDr As User.MATPackage [ SqlColumnNumber = 3, SqlFieldName = DSTKP_MATP_Dr ];

/// DSTKP_InStkTkFlag - 盘点标志
Property DSTKPInStkTkFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = DSTKP_InStkTkFlag ];

/// DSTKP_CountDate
Property DSTKPCountDate As %Library.Date [ SqlColumnNumber = 5, SqlFieldName = DSTKP_CountDate ];

/// DSTKP_CountTime
Property DSTKPCountTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = DSTKP_CountTime ];

/// DSTKP_CountUser_DR
Property DSTKPCountUserDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = DSTKP_CountUser_DR ];

Storage SQLStorage
{
<SQLMap name="MasterData">
<Data name="DSTKP_CountDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DSTKP_CountTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DSTKP_CountUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DSTKP_InStkTkFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DSTKP_MATP_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DSTKP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_InStkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_InStkTkInput.DHCSTI_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>DSTKP_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_InStkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"STK"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHC_InStkTkInput.DHCSTI_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>"STKI"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DSTKP_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexpakage">
<Global>^DSTKP</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAKAGE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSTKP_MATP_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_InStkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_InStkTkInput.DHCSTI_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DSTKP_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINStktkPackageS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
