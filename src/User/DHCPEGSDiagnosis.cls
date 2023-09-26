Class User.DHCPEGSDiagnosis Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = GSD_RowId, SqlTableName = DHC_PE_GSDiagnosis, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEGSDiagnosis";

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On GSDChildSub [ IdKey, PrimaryKey, Unique ];

/// GSD_Advice
Property GSDAdvice As %Library.String(COLLATION = "Exact", MAXLEN = 900, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = GSD_Advice ];

/// GSD_ChildSub
Property GSDChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCPEGS($p(%d(0),$c(1),1),"Diagnosis",0))}, Required, SqlColumnNumber = 2, SqlFieldName = GSD_ChildSub ];

/// GSD_DiagnoseConclusion
Property GSDDiagnoseConclusion As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = GSD_DiagnoseConclusion ];

/// GSD_ED_DR
Property GSDEDDR As User.DHCPEExpertDiagnosis [ SqlColumnNumber = 3, SqlFieldName = GSD_ED_DR ];

/// GSD_GenType
Property GSDGenType As %Library.String(DISPLAYLIST = ",System,Loc,Doc", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",S,L,D") [ SqlColumnNumber = 10, SqlFieldName = GSD_GenType ];

/// DHC_PE_GeneralSummarize Parent Reference
Relationship GSDParRef As User.DHCPEGeneralSummarize [ Cardinality = parent, Inverse = ChildDHCPEGSDiagnosis, Required, SqlFieldName = GSD_ParRef ];

/// GSD_ReportPrint
Property GSDReportPrint As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = GSD_ReportPrint ];

/// GSD_SSD_DR
Property GSDSSDDR As User.DHCPESSDiagnosis [ SqlColumnNumber = 4, SqlFieldName = GSD_SSD_DR ];

/// GSD_Sort
Property GSDSort As %Library.Numeric(SCALE = 0) [ SqlColumnNumber = 12, SqlFieldName = GSD_Sort ];

/// GSD_UpdateDate
Property GSDUpdateDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 8, SqlFieldName = GSD_UpdateDate ];

/// GSD_UpdateTime
Property GSDUpdateTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = GSD_UpdateTime ];

/// GSD_UpdateUser_DR
Property GSDUpdateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = GSD_UpdateUser_DR ];

/// GSD_Status   0:使用  1:被合并  2:被删除
Property GSDStatus As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = GSD_Status ];

/// GSD_YGFlag   乙肝标记
Property GSDYGFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = GSD_YGFlag ];

/// GSD_ST_DR   站点
Property GSDSTDR As User.DHCPEStation [ SqlColumnNumber = 15, SqlFieldName = GSD_ST_DR ];

/// GSD_STloc_DR   站点分类
Property GSDSTLocDR As User.DHCPEStationLoc [ SqlColumnNumber = 16, SqlFieldName = GSD_STloc_DR ];

Trigger BeforeDelete [ Event = DELETE ]
{
	Set id = {GSD_RowID}
	d ##Class(web.DHCPE.ResultDiagnosis).InsertGSDM(id, "D")
}

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterDHCPEGS">
<Data name="GSD_Advice">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="GSD_DiagnoseConclusion">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GSD_ED_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GSD_GenType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="GSD_ReportPrint">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="GSD_SSD_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GSD_STLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="GSD_ST_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="GSD_Sort">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="GSD_Status">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="GSD_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="GSD_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="GSD_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="GSD_YGFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCPEGS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PE_GeneralSummarize.GS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>GSD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_GeneralSummarize.GS_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Diagnosis"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{GSD_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEDDR">
<Global>^DHCPEGS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PE_GeneralSummarize.GS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>GSD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"EDDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{GSD_ED_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_GeneralSummarize.GS_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{GSD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGSDSort">
<Global>^DHCPEGS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_PE_GeneralSummarize.GS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>GSD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"GSDSort"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_GeneralSummarize.GS_RowId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{GSD_Sort}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{GSD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSSDDR">
<Global>^DHCPEGS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PE_GeneralSummarize.GS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>GSD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SSDDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{GSD_SSD_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_GeneralSummarize.GS_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{GSD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEGSDiagnosisS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
