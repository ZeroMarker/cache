/// DICOM Patient(1694)
Class User.DICOMPatient Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DICOM_Patient, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DCPATPatientID [ IdKey, PrimaryKey, Unique ];

/// Patients Name
Property DCPATPatientName As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DCPAT_PatientName ];

/// Patient ID
Property DCPATPatientID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DCPAT_PatientID ];

/// Patient Date of Birth
Property DCPATPatientDOB As %Date [ SqlColumnNumber = 4, SqlFieldName = DCPAT_PatientDOB ];

/// Sex
Property DCPATSex As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DCPAT_Sex ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.DICOMPatient).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMPatient","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.DICOMPatient).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMPatient","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.DICOMPatient).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMPatient","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.DICOMPatient).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMPatient","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.DICOMPatient).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMPatient","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DCPAT_PatientDOB">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DCPAT_PatientName">
<Node>"NAM"</Node>
</Data>
<Data name="DCPAT_Sex">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DICOM</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DCPAT_PatientID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCPAT_PatientID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DICOMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCPAT_PatientID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({DCPAT_PatientName})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCPAT_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DCPAT_ROWID</SqlRowIdName>
<StreamLocation>^User.DICOMPatientS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
