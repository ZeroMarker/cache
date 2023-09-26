Class User.DHCRBCReportImageGrade Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DRIG_Rowid, SqlTableName = DHCRBC_ReportImage_Grade, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DRIG_OEOrdItem_DR
Property DRIGOEOrdItemDR As User.OEOrdItem [ SqlColumnNumber = 2, SqlFieldName = DRIG_OEOrdItem_DR ];

/// DRIG_StudyNo
Property DRIGStudyNo As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DRIG_StudyNo ];

/// DRIG_ReportDesc
Property DRIGReportDesc As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DRIG_ReportDesc ];

/// DRIG_ImageDesc
Property DRIGImageDesc As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DRIG_ImageDesc ];

/// DRIG_Doctor_DR
Property DRIGDoctorDR As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = DRIG_Doctor_DR ];

/// DRIG_Grade_Date
Property DRIGGradeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = DRIG_Grade_Date ];

/// DRIG_Grade_Time
Property DRIGGradeTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = DRIG_Grade_Time ];

/// DRIG_RptDoctor_DR
Property DRIGRptDoctorDR As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = DRIG_RptDoctor_DR ];

/// DRIG_RecLocDr
Property DRIGRecLocDr As User.CTLoc [ SqlColumnNumber = 10, SqlFieldName = DRIG_RecLocDr ];

/// DRIG_Remark
Property DRIGRemark As %Library.String(COLLATION = "Exact", MAXLEN = 90, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DRIG_Remark ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCRIG("RptImgGrade"))</SqlIdExpression>
<SQLMap name="IndexGradeDate">
<Global>^DHCRBCRIGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRIG_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"GradeDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRIG_Grade_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRIG_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOEOrdItemID">
<Global>^DHCRBCRIGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRIG_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OeOrdItemID-Grade"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRIG_OEOrdItem_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRIG_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRecLocDr">
<Global>^DHCRBCRIGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DRIG_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RecLoc-Grade"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRIG_RecLocDr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRIG_Grade_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRIG_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStudyNo">
<Global>^DHCRBCRIGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRIG_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"StudyNo-Grade"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRIG_StudyNo}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRIG_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDataIndex">
<Data name="DRIG_Doctor_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DRIG_Grade_Date">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DRIG_Grade_Time">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DRIG_ImageDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DRIG_OEOrdItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRIG_RecLocDr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DRIG_Remark">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DRIG_ReportDesc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DRIG_RptDoctor_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DRIG_StudyNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBCRIG</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DRIG_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RptImgGrade"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRIG_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCReportImageGradeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
