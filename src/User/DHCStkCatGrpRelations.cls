Class User.DHCStkCatGrpRelations Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SCGR_Rowid, SqlTableName = DHC_StkCatGrpRelations, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On SCGRChildsub [ IdKey, PrimaryKey, Unique ];

/// DHC_StkCatGroup Parent Reference
Relationship SCGRSCGParref As User.DHCStkCatGroup [ Cardinality = parent, Inverse = ChildDHCStkCatGrpRelations, Required, SqlFieldName = SCGR_SCG_Parref ];

/// SCGR_StkCat_DR
Property SCGRStkCatDR As User.INCStkCat [ SqlColumnNumber = 3, SqlFieldName = SCGR_StkCat_DR ];

/// SCGR_Childsub
Property SCGRChildsub As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = SCGR_Childsub ];

/// SCGR_Type
Property SCGRType As %Library.String(MAXLEN = 8, SELECTIVITY = "25.0000%", VALUELIST = ",Material,Drug,Other") [ SqlColumnNumber = 5, SqlFieldName = SCGR_Type ];

Index SCGRStkCatDRUnqIdx1 On SCGRStkCatDR;

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterDHCSCGR">
<Data name="SCGR_StkCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SCGR_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCSCG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_StkCatGroup.SCG_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SCGR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_StkCatGroup.SCG_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SCGR_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexStkcat">
<Global>^DHCSCG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_StkCatGroup.SCG_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>SCGR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"STKCAT"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{SCGR_StkCat_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_StkCatGroup.SCG_Rowid}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{SCGR_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCStkCatGrpRelationsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
