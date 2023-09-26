Class User.DHCPEGGSDiagnosis Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = GGSD_RowId, SqlTableName = DHC_PE_GGSDiagnosis, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEGGSDiagnosis";

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On GGSDChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PE_GGeneralSummarize Parent Reference
Relationship GGSDParRef As User.DHCPEGGeneralSummarize [ Cardinality = parent, Inverse = ChildDHCPEGGSDiagnosis, Required, SqlFieldName = GGSD_ParRef ];

/// GGSD_ChildSub
Property GGSDChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCPEGGS($p(%d(0),$c(1),1),"Diagnosis",0))}, Required, SqlColumnNumber = 2, SqlFieldName = GGSD_ChildSub ];

/// GGSD_ILLS_DR
Property GGSDILLSDR As User.DHCPEIllnessStandard [ SqlColumnNumber = 3, SqlFieldName = GGSD_ILLS_DR ];

/// GGSD_DiagnoseConclusion
Property GGSDDiagnoseConclusion As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = GGSD_DiagnoseConclusion ];

/// GGSD_ReportPrint
Property GGSDReportPrint As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = GGSD_ReportPrint ];

/// GGSD_UpdateUser_DR
Property GGSDUpdateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = GGSD_UpdateUser_DR ];

/// GGSD_UpdateDate
Property GGSDUpdateDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 7, SqlFieldName = GGSD_UpdateDate ];

/// GGSD_UpdateTime
Property GGSDUpdateTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = GGSD_UpdateTime ];

/// GGSD_GenType
Property GGSDGenType As %Library.String(DISPLAYLIST = ",System,Loc,Doc", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",S,L,D") [ SqlColumnNumber = 9, SqlFieldName = GGSD_GenType ];

/// GGSD_Advice
Property GGSDAdvice As %Library.String(COLLATION = "Exact", MAXLEN = 900, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = GGSD_Advice ];

/// GGSD_Sort
Property GGSDSort As %Library.Numeric(SCALE = 0) [ SqlColumnNumber = 11, SqlFieldName = GGSD_Sort ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterDHCPEGGS">
<Data name="GGSD_Advice">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="GGSD_DiagnoseConclusion">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GGSD_GenType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="GGSD_ILLS_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GGSD_ReportPrint">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GGSD_Sort">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="GGSD_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="GGSD_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="GGSD_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPEGGS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PE_GGeneralSummarize.GGS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>GGSD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_GGeneralSummarize.GGS_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Diagnosis"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{GGSD_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGSDSort">
<Global>^DHCPEGGS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_PE_GGeneralSummarize.GGS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>GGSD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"GSSDSort"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_GGeneralSummarize.GGS_RowId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{GGSD_Sort}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{GGSD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexILLSDR">
<Global>^DHCPEGGS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PE_GGeneralSummarize.GGS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>GGSD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ILLSDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{GGSD_ILLS_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_GGeneralSummarize.GGS_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{GGSD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUpdateDateTime">
<Global>^DHCPEGGS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_PE_GGeneralSummarize.GGS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>GGSD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"UpdateDateTime"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{GGSD_UpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{GGSD_UpdateTime}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_GGeneralSummarize.GGS_RowId}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{GGSD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUpdateUser">
<Global>^DHCPEGGS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PE_GGeneralSummarize.GGS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>GGSD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"UpdateUser"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{GGSD_UpdateUser_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_GGeneralSummarize.GGS_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{GGSD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEGGSDiagnosisS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
