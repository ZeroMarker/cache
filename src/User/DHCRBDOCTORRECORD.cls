Class User.DHCRBDOCTORRECORD Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DDR_Rowid, SqlTableName = DHCRB_DOCTORRECORD, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DDR_Loc_DR
Property DDRLocDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = DDR_Loc_DR ];

/// DDR_LoginLoc_DR
Property DDRLoginLocDR As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = DDR_LoginLoc_DR ];

/// DDR_PatientID
Property DDRPatientID As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DDR_PatientID ];

/// DDR_StudyNo
Property DDRStudyNo As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DDR_StudyNo ];

/// DDR_DATE
Property DDRDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = DDR_DATE ];

/// DDR_TIME
Property DDRTIME As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = DDR_TIME ];

/// DDR_User_DR
Property DDRUserDR As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = DDR_User_DR ];

/// DDR_Result
Property DDRResult As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DDR_Result ];

/// DDR_IDATE
Property DDRIDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = DDR_IDATE ];

/// DDR_ITEME
Property DDRITIME As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = DDR_ITIME ];

/// DDR_IUser_DR
Property DDRIUserDR As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = DDR_IUser_DR ];

/// DDR_ImageNote
Property DDRImageNote As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DDR_ImageNote ];

/// DDR_Orditem_DR
Property DDROrditemDR As User.OEOrdItem [ SqlColumnNumber = 14, SqlFieldName = DDR_Orditem_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBDOCRECORD("DOCTOR-RECORD"))</SqlIdExpression>
<SQLMap name="IndexOrditemID">
<Global>^DHCRBDOCRECORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DDR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OrdItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DDR_Orditem_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatientID">
<Global>^DHCRBDOCRECORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DDR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RegNo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DDR_PatientID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStudyNo">
<Global>^DHCRBDOCRECORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DDR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"StudyNo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DDR_StudyNo}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDataIndex">
<Data name="DDR_DATE">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DDR_IDATE">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DDR_ITIME">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DDR_IUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DDR_ImageNote">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DDR_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DDR_LoginLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DDR_Orditem_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DDR_PatientID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DDR_Result">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DDR_StudyNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DDR_TIME">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DDR_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCRBDOCRECORD</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DDR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DOCTOR-RECORD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DDR_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBDOCTORRECORDS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
