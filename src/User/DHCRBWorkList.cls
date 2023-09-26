Class User.DHCRBWorkList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DWL_RowID, SqlTableName = DHCRB_WorkList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DWL_OrdItem_DR
Property DWLOrdItemDR As User.OEOrdItem [ SqlColumnNumber = 2, SqlFieldName = DWL_OrdItem_DR ];

/// DWL_StudyNo
Property DWLStudyNo As %Library.String(COLLATION = "Exact", MAXLEN = 19, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DWL_StudyNo ];

/// DWL_PatientStatus_DR
Property DWLPatientStatusDR As User.DHCRBCPatientStatus [ SqlColumnNumber = 4, SqlFieldName = DWL_PatientStatus_DR ];

/// DWL_ReportStatus_DR
Property DWLReportStatusDR As User.DHCRBCReportStatus [ SqlColumnNumber = 5, SqlFieldName = DWL_ReportStatus_DR ];

/// DWL_Date
Property DWLDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = DWL_Date ];

/// DWL_Time
Property DWLTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = DWL_Time ];

/// DWL_PatientID
Property DWLPatientID As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DWL_PatientID ];

/// DWL_PatientName
Property DWLPatientName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DWL_PatientName ];

/// DWL_PatientType
Property DWLPatientType As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DWL_PatientType ];

/// DWL_ExecLoc_DR
Property DWLExecLocDR As User.CTLoc [ SqlColumnNumber = 11, SqlFieldName = DWL_ExecLoc_DR ];

/// DWL_AppLoc_DR
Property DWLAppLocDR As User.CTLoc [ SqlColumnNumber = 12, SqlFieldName = DWL_AppLoc_DR ];

/// DWL_Ward_DR
Property DWLWardDR As User.PACWard [ SqlColumnNumber = 13, SqlFieldName = DWL_Ward_DR ];

/// DWL_ResSchduleDetail_DR
Property DWLResSchduleDetailDR As User.DHCRBCResSchduleDetail [ SqlColumnNumber = 14, SqlFieldName = DWL_ResSchduleDetail_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBWorkList)</SqlIdExpression>
<SQLMap name="IndexAppLoc">
<Global>^DHCRBWorkListi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DWL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"AppLoc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DWL_AppLoc_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DWL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAppointment">
<Global>^DHCRBWorkListi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DWL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WLBOOK"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DWL_ResSchduleDetail_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DWL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCRBWorkListi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DWL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DWL_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DWL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOEORD">
<Global>^DHCRBWorkListi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DWL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OEORI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DWL_OrdItem_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DWL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatientStatus">
<Global>^DHCRBWorkListi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DWL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PatientStatus"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DWL_PatientStatus_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DWL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRecLoc">
<Global>^DHCRBWorkListi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DWL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RecLoc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DWL_ExecLoc_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DWL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRegNo">
<Global>^DHCRBWorkListi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DWL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RegNo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DWL_PatientID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DWL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexReportStatus">
<Global>^DHCRBWorkListi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DWL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ReportStatus"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DWL_ReportStatus_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DWL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStudyNo">
<Global>^DHCRBWorkListi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DWL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"StudyNo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DWL_StudyNo}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DWL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWard">
<Global>^DHCRBWorkListi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DWL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Ward"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DWL_Ward_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DWL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDataIndex">
<Data name="DWL_AppLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DWL_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DWL_ExecLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DWL_OrdItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DWL_PatientID">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DWL_PatientName">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DWL_PatientStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DWL_PatientType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DWL_ReportStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DWL_ResSchduleDetail_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DWL_StudyNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DWL_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DWL_Ward_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCRBWorkList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DWL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DWL_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBWorkListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
