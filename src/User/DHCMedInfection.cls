Class User.DHCMedInfection Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MIF_RowId, SqlTableName = DHC_MedInfection, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCMedInfectionAlias As User.DHCMedInfectionAlias [ Cardinality = children, Inverse = MIFAParRef ];

Relationship ChildDHCMedInfectionArcim As User.DHCMedInfectionArcim [ Cardinality = children, Inverse = Parref ];

Relationship ChildDHCMedInfectionCtl As User.DHCMedInfectionCtl [ Cardinality = children, Inverse = MIFCParRef ];

Relationship ChildDHCMedInfectionICD As User.DHCMedInfectionICD [ Cardinality = children, Inverse = MIFIParRef ];

/// MIF_ICD
Property MIFICD As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MIF_ICD ];

/// MIF_Disease
Property MIFDisease As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MIF_Disease ];

/// MIF_Kind
Property MIFKind As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MIF_Kind ];

/// MIF_Rank
Property MIFRank As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MIF_Rank ];

/// MIF_Appendix
Property MIFAppendix As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = MIF_Appendix ];

/// MIF_Multi
Property MIFMulti As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = MIF_Multi ];

/// MIF_Dependence
Property MIFDependence As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = MIF_Dependence ];

/// MIF_TimeLimit
Property MIFTimeLimit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = MIF_TimeLimit ];

/// MIF_Resume
Property MIFResume As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = MIF_Resume ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMIF)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="MIF_Appendix">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MIF_Dependence">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MIF_Disease">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MIF_ICD">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MIF_Kind">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MIF_Multi">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MIF_Rank">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MIF_Resume">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MIF_TimeLimit">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCMIF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MIF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MIF_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexICD">
<Global>^DHCMIF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MIF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ICD"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MIF_ICD}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MIF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMedInfectionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
