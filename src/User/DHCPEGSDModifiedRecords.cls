Class User.DHCPEGSDModifiedRecords Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = GSDMR_RowID, SqlTableName = DHC_PE_GSDModifiedRecords, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEGSDModifiedRecords";

Parameter EXTENTSIZE = 250;

/// GSDMR_Advice
Property GSDMRAdvice As %Library.String(COLLATION = "Exact", MAXLEN = 900, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = GSDMR_Advice ];

/// GSDMR_DiagnoseConclusion
Property GSDMRDiagnoseConclusion As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = GSDMR_DiagnoseConclusion ];

/// GSDMR_ED_DR
Property GSDMREDDR As User.DHCPEExpertDiagnosis [ SqlColumnNumber = 3, SqlFieldName = GSDMR_ED_DR ];

/// GSDMR_GSD_ParRef
Property GSDMRGSDParRef As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = GSDMR_GSD_ParRef ];

/// GSDMR_GSD_Sub
Property GSDMRGSDSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = GSDMR_GSD_Sub ];

/// GSDMR_GenType
Property GSDMRGenType As %Library.String(DISPLAYLIST = ",System,Loc,Doc", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",S,L,D") [ SqlColumnNumber = 10, SqlFieldName = GSDMR_GenType ];

/// GSDMR_SSD_DR
Property GSDMRSSDDR As User.DHCPESSDiagnosis [ SqlColumnNumber = 4, SqlFieldName = GSDMR_SSD_DR ];

/// GSDMR_Sort
Property GSDMRSort As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = GSDMR_Sort ];

/// GSDMR_Type
Property GSDMRType As %Library.String(DISPLAYLIST = ",Delete,Update,Insert", MAXLEN = 8, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",D,U,I") [ SqlColumnNumber = 6, SqlFieldName = GSDMR_Type ];

/// GSDMR_UpdateDate
Property GSDMRUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = GSDMR_UpdateDate ];

/// GSDMR_UpdateTime
Property GSDMRUpdateTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = GSDMR_UpdateTime ];

/// GSDMR_UpdateUser_DR
Property GSDMRUpdateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = GSDMR_UpdateUser_DR ];

/// GSDMR_YGFlag
Property GSDMRYGFlag As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = GSDMR_YGFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPEGSDM)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="GSDMR_Advice">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="GSDMR_DiagnoseConclusion">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GSDMR_ED_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GSDMR_GSD_ParRef">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="GSDMR_GSD_Sub">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="GSDMR_GenType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="GSDMR_SSD_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GSDMR_Sort">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="GSDMR_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="GSDMR_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="GSDMR_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="GSDMR_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="GSDMR_YGFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^DHCPEGSDM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>GSDMR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{GSDMR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGSD">
<Global>^DHCPEGSDM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>GSDMR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GSDMR_GSD_ParRef}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"GSDSub"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{GSDMR_GSD_Sub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{GSDMR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEGSDModifiedRecordsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
