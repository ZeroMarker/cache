Class User.DHCPHIDISPSUB Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHIDS_ROWID, SqlTableName = DHC_PHIDISPSUB, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHIDSCHILDSUB [ IdKey, PrimaryKey, Unique ];

/// PHIDS_CHILDSUB
Property PHIDSCHILDSUB As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = PHIDS_CHILDSUB ];

/// PHIDS_OEORI_DR
Property PHIDSOEORIDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PHIDS_OEORI_DR ];

/// PHIDS_PAYAMOUNT
Property PHIDSPAYAMOUNT As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PHIDS_PAYAMOUNT ];

/// DHC_PHIDISPEN Parent Reference
Relationship PHIDSPHIDPARREF As User.DHCPHIDISPEN [ Cardinality = parent, Inverse = ChildDHCPHIDISPSUB, Required, SqlFieldName = PHIDS_PHID_PARREF ];

/// PHIDS_PRICE
Property PHIDSPRICE As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PHIDS_PRICE ];

/// PHIDS_QTY
Property PHIDSQTY As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PHIDS_QTY ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="PHIDSMASTER">
<Data name="PHIDS_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHIDS_PAYAMOUNT">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHIDS_PRICE">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHIDS_QTY">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHIDS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHIDISPEN.PHID_ROWID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHIDS_CHILDSUB</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PHIDISPEN.PHID_ROWID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHIDS_CHILDSUB}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHIDISPSUBS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
