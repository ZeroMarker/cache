Class User.DHCPHUNDISPITMCLB Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHUNDIC_ROWID, SqlTableName = DHC_PHUNDISPITMCLB, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHUNDICCHILDSUB [ IdKey, PrimaryKey, Unique ];

/// DHC_PHUNDISPITM Parent Reference
Relationship PHUNDICPHUNDIPARREF As User.DHCPHUNDISPITM [ Cardinality = parent, Inverse = ChildDHCPHUNDISPITMCLB, Required, SqlFieldName = PHUNDIC_PHUNDI_PARREF ];

/// PHUNDIC_CHILDSUB
Property PHUNDICCHILDSUB As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHUNDIC_CHILDSUB ];

/// PHUNDIC_QTY
Property PHUNDICQTY As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = PHUNDIC_QTY ];

/// PHUNDIC_INCLB_DR
Property PHUNDICINCLBDR As User.INCItmLcBt [ SqlColumnNumber = 10, SqlFieldName = PHUNDIC_INCLB_DR ];

/// PHUNDIC_Rp
Property PHUNDICRp As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = PHUNDIC_Rp ];

/// PHUNDIC_RpAmt
Property PHUNDICRpAmt As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = PHUNDIC_RpAmt ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="PHUNDICMASTER">
<Data name="PHUNDIC_INCLB_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHUNDIC_QTY">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHUNDIC_Rp">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHUNDIC_RpAmt">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHUND</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHUNDISPEN.PHUND_ROWID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_PHUNDISPITM.PHUNDI_CHILDSUB</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PHUNDIC_CHILDSUB</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PHUNDISPEN.PHUND_ROWID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_PHUNDISPITM.PHUNDI_CHILDSUB}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"INCLB"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PHUNDIC_CHILDSUB}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHUNDISPITMCLBS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
