Class User.DHCMedDeathBSub Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MDBS_Rowid, SqlTableName = DHC_MedDeathBSub, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On MDBSChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_MedDeathBook Parent Reference
Relationship MDBSParRef As User.DHCMedDeathBook [ Cardinality = parent, Inverse = ChildDHCMedDeathBSub, Required, SqlFieldName = MDBS_ParRef ];

/// MDBS_ChildSub
Property MDBSChildSub As %Library.Float [ InitialExpression = {$i(^DHCMDB($p(%d(0),$c(1),1),"I",0))}, SqlColumnNumber = 2, SqlFieldName = MDBS_ChildSub ];

/// MDBS_NOFrom
Property MDBSNOFrom As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MDBS_NOFrom ];

/// MDBS_NOTo
Property MDBSNOTo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MDBS_NOTo ];

/// MDBS_SetUsr_DR
Property MDBSSetUsrDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = MDBS_SetUsr_DR ];

/// MDBS_GetUsr_DR
Property MDBSGetUsrDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = MDBS_GetUsr_DR ];

/// MDBS_GetLoc_DR
Property MDBSGetLocDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = MDBS_GetLoc_DR ];

/// MDBS_Date
Property MDBSDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = MDBS_Date ];

/// MDBS_Time
Property MDBSTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = MDBS_Time ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="MDBS_Date">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MDBS_GetLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MDBS_GetUsr_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MDBS_NOFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MDBS_NOTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MDBS_SetUsr_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MDBS_Time">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCMDB</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MedDeathBook.MDB_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MDBS_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_MedDeathBook.MDB_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MDBS_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedDeathBSubS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
