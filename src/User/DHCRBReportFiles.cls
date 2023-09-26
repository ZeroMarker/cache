Class User.DHCRBReportFiles Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DRPF_RowID, SqlTableName = DHCRB_Report_Files, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DRPFChildSub [ IdKey, PrimaryKey, Unique ];

/// DHCRB_Report Parent Reference
Relationship DRPFParRef As User.DHCRBReport [ Cardinality = parent, Inverse = ChildDHCRBReportFiles, Required, SqlFieldName = DRPF_ParRef ];

/// Child subscript
Property DRPFChildSub As %Library.Float [ InitialExpression = {$i(^DHCRB("DHCRBREPORTFILES"))}, Required, SqlColumnNumber = 2, SqlFieldName = DRPF_ChildSub ];

/// DRPF_FullFileName
Property DRPFFullFileName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DRPF_FullFileName ];

/// DRPF_Medium_DR
Property DRPFMediumDR As User.DHCRBCMedium [ SqlColumnNumber = 4, SqlFieldName = DRPF_Medium_DR ];

/// DRPF_ExtName
Property DRPFExtName As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DRPF_ExtName ];

/// DRPF_Images_DR
Property DRPFImagesDR As User.DHCRBStudyImages [ SqlColumnNumber = 6, SqlFieldName = DRPF_Images_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="DRPF_ExtName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DRPF_FullFileName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRPF_Images_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DRPF_Medium_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCRBStudy</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCRB_Report.DRPT_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DRPF_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ReportFiles"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCRB_Report.DRPT_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRPF_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMedium">
<Global>^DHCRBReporti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCRB_Report.DRPT_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DRPF_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Medium"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRPF_Medium_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCRB_Report.DRPT_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRPF_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRBReportFilesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
