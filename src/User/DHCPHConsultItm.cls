Class User.DHCPHConsultItm Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHCONI_RowID, SqlTableName = DHC_PHConsultItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHCONIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHConsult Parent Reference
Relationship PHCONIParRefDr As User.DHCPHConsult [ Cardinality = parent, Inverse = ChildDHCPHConsultItm, Required, SqlFieldName = PHCONI_ParRef_Dr ];

/// PHCONI_ChildSub
Property PHCONIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHCONI_ChildSub ];

/// PHCONI_Drug_Dr
Property PHCONIDrugDr As User.PHCDrgForm [ SqlColumnNumber = 3, SqlFieldName = PHCONI_Drug_Dr ];

/// PHCONI_GoodsName
Property PHCONIGoodsName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PHCONI_GoodsName ];

/// PHCONI_Spec
Property PHCONISpec As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PHCONI_Spec ];

/// PHCONI_Form
Property PHCONIForm As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PHCONI_Form ];

/// PHCONI_Manf
Property PHCONIManf As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PHCONI_Manf ];

/// PHCONI_Instruc
Property PHCONIInstruc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PHCONI_Instruc ];

/// PHCONI_Dosage
Property PHCONIDosage As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PHCONI_Dosage ];

/// PHCONI_Duration
Property PHCONIDuration As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PHCONI_Duration ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PHCONI_Dosage">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHCONI_Drug_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHCONI_Duration">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHCONI_Form">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHCONI_GoodsName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHCONI_Instruc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHCONI_Manf">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHCONI_Spec">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCPHCONI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHConsult.PHCON_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHCONI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PHConsult.PHCON_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"D"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHCONI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHConsultItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
