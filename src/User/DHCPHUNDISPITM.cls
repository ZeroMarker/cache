Class User.DHCPHUNDISPITM Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHUNDI_ROWID, SqlTableName = DHC_PHUNDISPITM, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHUNDICHILDSUB [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCPHUNDISPITMCLB As User.DHCPHUNDISPITMCLB [ Cardinality = children, Inverse = PHUNDICPHUNDIPARREF ];

/// DHC_PHUNDISPEN Parent Reference
Relationship PHUNDIPHUNDPARREF As User.DHCPHUNDISPEN [ Cardinality = parent, Inverse = ChildDHCPHUNDISPITM, Required, SqlFieldName = PHUNDI_PHUND_PARREF ];

/// PHUNDI_CHILDSUB
Property PHUNDICHILDSUB As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHUNDI_CHILDSUB ];

/// PHUNDI_INCLB_DR
Property PHUNDIINCIDR As User.INCItm [ SqlColumnNumber = 4, SqlFieldName = PHUNDI_INCI_DR ];

/// PHUNDI_QTY
Property PHUNDIQTY As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PHUNDI_QTY ];

/// PHUNDI_TOTAL
Property PHUNDITOTAL As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = PHUNDI_TOTAL ];

/// PHUNDI_PRICE
Property PHUNDIPRICE As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = PHUNDI_PRICE ];

/// PHUNDI_CTUOM_DR
Property PHUNDICTUOMDR As User.CTUOM [ SqlColumnNumber = 8, SqlFieldName = PHUNDI_CTUOM_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="PHUNDIMASTER">
<Data name="PHUNDI_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHUNDI_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHUNDI_PRICE">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHUNDI_QTY">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHUNDI_TOTAL">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCPHUND</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHUNDISPEN.PHUND_ROWID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHUNDI_CHILDSUB</Field>
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
<Expression>{PHUNDI_CHILDSUB}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHUNDISPITMS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
