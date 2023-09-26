Class User.DHCPHDISITMCLB Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHDIC_ROWID, SqlTableName = DHC_PHDISITMCLB, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHDICCHILDSUB [ IdKey, PrimaryKey, Unique ];

/// DHC_PHDISITEM Parent Reference
Relationship PHDICPHDIPARREF As User.DHCPHDISITEM [ Cardinality = parent, Inverse = ChildDHCPHDISITMCLB, Required, SqlFieldName = PHDIC_PHDI_PARREF ];

/// PHDIC_BASQTY
Property PHDICBASQTY As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = PHDIC_BASQTY ];

/// PHDIC_BASRETQTY
Property PHDICBASRETQTY As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PHDIC_BASRETQTY ];

/// PHDIC_CHILDSUB
Property PHDICCHILDSUB As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHDIC_CHILDSUB ];

/// PHDIC_INCLB_DR
Property PHDICINCLBDR As User.INCItmLcBt [ SqlColumnNumber = 5, SqlFieldName = PHDIC_INCLB_DR ];

/// PHDIC_STATUS
Property PHDICSTATUS As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PHDIC_STATUS ];

/// PHDIC_Rp
Property PHDICRp As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = PHDIC_Rp ];

/// PHDIC_RpAmt
Property PHDICRpAmt As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = PHDIC_RpAmt ];

/// PHDIC_Sp
Property PHDICSp As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = PHDIC_Sp ];

/// PHDIC_SpAmt
Property PHDICSpAmt As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = PHDIC_SpAmt ];

/// 打包批次
Property PHDICDSPBDR As User.DHCOEDispBatch [ SqlColumnNumber = 11, SqlFieldName = PHDIC_DSPB_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="IndexDspBatch">
<Global>^DHCPHDIi</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_PHDISPEN.PHD_ROWID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DHC_PHDISITEM.PHDI_CHILDSUB</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PHDIC_CHILDSUB</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DSPB"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHDIC_DSPB_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_PHDISPEN.PHD_ROWID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PHDISITEM.PHDI_CHILDSUB}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHDIC_CHILDSUB}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHDICMASTER">
<Data name="PHDIC_BASQTY">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHDIC_BASRETQTY">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHDIC_DSPB_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHDIC_INCLB_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHDIC_Rp">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHDIC_RpAmt">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHDIC_STATUS">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHDIC_Sp">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHDIC_SpAmt">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCPHDI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHDISPEN.PHD_ROWID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_PHDISITEM.PHDI_CHILDSUB</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PHDIC_CHILDSUB</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_PHDISPEN.PHD_ROWID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PHDI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHC_PHDISITEM.PHDI_CHILDSUB}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"INCLB"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{PHDIC_CHILDSUB}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHDISITMCLBS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
