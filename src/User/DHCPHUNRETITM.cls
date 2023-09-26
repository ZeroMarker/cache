Class User.DHCPHUNRETITM Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHUNRI_ROWID, SqlTableName = DHC_PHUNRETITM, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHUNRICHILDSUB [ IdKey, PrimaryKey, Unique ];

/// PHUNRI_CHILDSUB
Property PHUNRICHILDSUB As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHUNRI_CHILDSUB ];

/// PHUNRI_CTUOM_DR
Property PHUNRICTUOMDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = PHUNRI_CTUOM_DR ];

/// PHUNRI_INCLB_DR
Property PHUNRIINCIDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PHUNRI_INCI_DR ];

/// DHC_PHUNRETURN Parent Reference
Relationship PHUNRIPHUNRPARREF As User.DHCPHUNRETURN [ Cardinality = parent, Inverse = ChildDHCPHUNRETITM, Required, SqlFieldName = PHUNRI_PHUNR_PARREF ];

/// PHUNRI_PRICE
Property PHUNRIPRICE As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = PHUNRI_PRICE ];

/// PHUNRI_QTY
Property PHUNRIQTY As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PHUNRI_QTY ];

/// PHUNRI_TOTAL
Property PHUNRITOTAL As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PHUNRI_TOTAL ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="PHUNRIMASTER">
<Data name="PHUNRI_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHUNRI_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHUNRI_PRICE">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHUNRI_QTY">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHUNRI_TOTAL">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCPHUNRI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHUNRETURN.PHUNR_ROWID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHUNRI_CHILDSUB</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PHUNRETURN.PHUNR_ROWID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHUNRI_CHILDSUB}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHUNRETITMS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
