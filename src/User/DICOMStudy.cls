/// DICOM Study (1696)
Class User.DICOMStudy Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DICOM_Study, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DCSTYStudyInstanceUID [ IdKey, PrimaryKey, Unique ];

/// DICOM Patient DR
Property DCSTYPatientDR As DICOMPatient [ SqlColumnNumber = 2, SqlFieldName = DCSTY_Patient_DR ];

/// Study Date
Property DCSTYStudyDate As %Date [ SqlColumnNumber = 3, SqlFieldName = DCSTY_StudyDate ];

/// Study Time
Property DCSTYStudyTime As %Time [ SqlColumnNumber = 4, SqlFieldName = DCSTY_StudyTime ];

/// Accession Number
Property DCSTYAccessionNumber As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DCSTY_AccessionNumber ];

/// StudyID
Property DCSTYStudyID As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DCSTY_StudyID ];

/// Study Instance UID
Property DCSTYStudyInstanceUID As %String(COLLATION = "Exact", MAXLEN = 65, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = DCSTY_StudyInstanceUID ];

/// Ref Doctor Name
Property DCSTYRefDoctorName As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = DCSTY_RefDoctorName ];

/// Description
Property DCSTYDescription As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = DCSTY_Description ];

/// Delete Status Date
Property DCSTYDeleteStatusDate As %Date [ SqlColumnNumber = 10, SqlFieldName = DCSTY_DeleteStatusDate ];

/// Status of Study
Property DCSTYDeleteStatus As %String(DISPLAYLIST = ",Deleted,Queued,Available", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",D,Q,A") [ SqlColumnNumber = 11, SqlFieldName = DCSTY_DeleteStatus ];

/// Delete status time
Property DCSTYDeleteStatusTime As %Time [ SqlColumnNumber = 12, SqlFieldName = DCSTY_DeleteStatusTime ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.DICOMStudy).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMStudy","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.DICOMStudy).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMStudy","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.DICOMStudy).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMStudy","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.DICOMStudy).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMStudy","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.DICOMStudy).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMStudy","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DCSTY_AccessionNumber">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DCSTY_DeleteStatus">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DCSTY_DeleteStatusDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DCSTY_DeleteStatusTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DCSTY_Description">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DCSTY_Patient_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DCSTY_RefDoctorName">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DCSTY_StudyDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DCSTY_StudyID">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DCSTY_StudyTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DICOM</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DCSTY_StudyInstanceUID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"STY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCSTY_StudyInstanceUID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdnexStudyID">
<Global>^DICOMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCSTY_StudyInstanceUID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"STY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StudID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({DCSTY_StudyID})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCSTY_StudyInstanceUID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAccessNo">
<Global>^DICOMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCSTY_StudyInstanceUID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"STY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AccNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCSTY_AccessionNumber}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCSTY_StudyInstanceUID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDeleteStatus">
<Global>^DICOMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DCSTY_StudyInstanceUID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DelStatus"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCSTY_DeleteStatus}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCSTY_DeleteStatusDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCSTY_DeleteStatusTime}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DCSTY_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatientID">
<Global>^DICOMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCSTY_StudyInstanceUID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"STY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PatID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCSTY_Patient_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCSTY_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStudyDate">
<Global>^DICOMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCSTY_StudyInstanceUID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"STY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCSTY_StudyDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCSTY_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DCSTY_RowID</SqlRowIdName>
<StreamLocation>^User.DICOMStudyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
