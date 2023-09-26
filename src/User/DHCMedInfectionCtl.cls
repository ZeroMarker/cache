Class User.DHCMedInfectionCtl Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MIFC_Rowid, SqlTableName = DHC_MedInfectionCtl, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On MIFCChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_MedInfection Parent Reference
Relationship MIFCParRef As User.DHCMedInfection [ Cardinality = parent, Inverse = ChildDHCMedInfectionCtl, Required, SqlFieldName = MIFC_ParRef ];

/// MIFC_ChildSub
Property MIFCChildSub As %Library.Float [ InitialExpression = {$i(^DHCMIF($p(%d(0),$c(1),1),"I",0))}, Required, SqlColumnNumber = 2, SqlFieldName = MIFC_ChildSub ];

/// MIFC_ActiveFlag
Property MIFCActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = MIFC_ActiveFlag ];

/// MIFC_InfType
Property MIFCInfType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MIFC_InfType ];

/// MIFC_InfKind
Property MIFCInfKind As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MIFC_InfKind ];

/// MIFC_ItmDesc
Property MIFCItmDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = MIFC_ItmDesc ];

/// MIFC_ItmExplain
Property MIFCItmExplain As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MIFC_ItmExplain ];

/// MIFC_Demo
Property MIFCDemo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MIFC_Demo ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="MIFC_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MIFC_Demo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MIFC_InfKind">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MIFC_InfType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MIFC_ItmDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MIFC_ItmExplain">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCMIF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MedInfection.MIF_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MIFC_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_MedInfection.MIF_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MIFC_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedInfectionCtlS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
