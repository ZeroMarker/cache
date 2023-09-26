Class User.DHCInStkTkItmTrack Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INSTIT_RowID, SqlTableName = DHC_InStkTkItmTrack, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On INSTITChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_InStkTkItm Parent Reference
Relationship INSTITINSTIParref As User.DHCInStkTkItm [ Cardinality = parent, Inverse = ChildDHCInStkTkItmTrack, Required, SqlFieldName = INSTIT_INSTI_Parref ];

/// INSTIT_ChildSub
Property INSTITChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = INSTIT_ChildSub ];

/// INSTIT_DHCIT_DR
Property INSTITDHCITDR As User.DHCItmTrack [ SqlColumnNumber = 3, SqlFieldName = INSTIT_DHCIT_DR ];

/// INSTIT_InStkTkFlag - 盘点标志
Property INSTITInStkTkFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = INSTIT_InStkTkFlag ];

/// INSTIT_CountDate
Property INSTITCountDate As %Library.Date [ SqlColumnNumber = 5, SqlFieldName = INSTIT_CountDate ];

/// INSTIT_CountTime
Property INSTITCountTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = INSTIT_CountTime ];

/// INSTIT_CountUser_DR
Property INSTITCountUserDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = INSTIT_CountUser_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="IndexDHCIT">
<Global>^DHCINST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_InStkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHC_InStkTkItm.INSTI_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>INSTIT_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"DHCIT"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INSTIT_DHCIT_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_InStkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHC_InStkTkItm.INSTI_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{INSTIT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MapMaster">
<Data name="INSTIT_CountDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INSTIT_CountTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INSTIT_CountUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INSTIT_DHCIT_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INSTIT_InStkTkFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCINST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_InStkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_InStkTkItm.INSTI_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>INSTIT_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_InStkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"STI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHC_InStkTkItm.INSTI_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>"STIT"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{INSTIT_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCInStkTkItmTrackS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
