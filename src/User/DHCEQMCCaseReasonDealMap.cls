Class User.DHCEQMCCaseReasonDealMap Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CRDM_RowID, SqlTableName = DHC_EQMCCaseReasonDealMap, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CRDM_MapType
Property CRDMMapType As %Library.String(DISPLAYLIST = ",故障现象与故障原因对照,故障原因与解决方法对照", MAXLEN = 11, SELECTIVITY = "33.3333%", VALUELIST = ",1,2") [ SqlColumnNumber = 2, SqlFieldName = CRDM_MapType ];

/// CRDM_SourceID
Property CRDMSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CRDM_SourceID ];

/// CRDM_MapSourceID
Property CRDMMapSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = CRDM_MapSourceID ];

/// CRDM_Hold1
Property CRDMHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CRDM_Hold1 ];

/// CRDM_Hold2
Property CRDMHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CRDM_Hold2 ];

/// CRDM_Hold3
Property CRDMHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CRDM_Hold3 ];

/// CRDM_Hold4
Property CRDMHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = CRDM_Hold4 ];

/// CRDM_Hold5
Property CRDMHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = CRDM_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQMCCaseReasonDealMap("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CRDM_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CRDM_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CRDM_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CRDM_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CRDM_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CRDM_MapSourceID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CRDM_MapType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CRDM_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CRDM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQMCCaseReasonDealMap"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CRDM_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMapSourceID">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CRDM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQMCCaseReasonDealMap"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"MapSourceID"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CRDM_MapType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CRDM_MapSourceID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{CRDM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSourceID">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CRDM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQMCCaseReasonDealMap"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"SourceID"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CRDM_MapType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CRDM_SourceID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{CRDM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQMCCaseReasonDealMapS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
