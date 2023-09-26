/// DICOM workflow(1755)
Class User.DICOMWorkflow Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DICOM_Workflow, StorageStrategy = SQLStorage ]
{

/// Date
Property WFDate As %Date [ SqlColumnNumber = 2, SqlFieldName = WF_Date ];

/// Modality
Property WFModality As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = WF_Modality ];

/// Status
Property WFStatus As %String(DISPLAYLIST = ",Ready,Sent,Error,Ignore,Pending", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",R,S,E,I,P") [ SqlColumnNumber = 4, SqlFieldName = WF_Status ];

/// Des Ref OEORI
Property WFOEORIDR As OEOrdItem [ SqlColumnNumber = 5, SqlFieldName = WF_OEORI_DR ];

/// Error Message
Property WFErrorMessage As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = WF_ErrorMessage ];

/// Time
Property WFTime As %Float [ SqlColumnNumber = 7, SqlFieldName = WF_Time ];

/// FileName
Property WFFileName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = WF_FileName ];

/// Time of Entry
Property WFTimeEntry As %Time [ InitialExpression = "N", SqlColumnNumber = 9, SqlFieldName = WF_TimeEntry ];

/// Start Time
Property WFStartTime As %Time [ SqlColumnNumber = 10, SqlFieldName = WF_StartTime ];

/// Finish Time
Property WFFinishTime As %Time [ SqlColumnNumber = 11, SqlFieldName = WF_FinishTime ];

/// PACS to rectrieve the images from
Property WFPACS As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = WF_PACS ];

/// Priority for retrieving images
Property WFPriority As %Float [ SqlColumnNumber = 13, SqlFieldName = WF_Priority ];

/// Study Instance UID
Property WFStudyInstanceUID As %String(COLLATION = "Exact", MAXLEN = 65, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = WF_StudyInstanceUID ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.DICOMWorkflow).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMWorkflow","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.DICOMWorkflow).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMWorkflow","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.DICOMWorkflow).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMWorkflow","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.DICOMWorkflow).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMWorkflow","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.DICOMWorkflow).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMWorkflow","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DICOM("WF",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="WF_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WF_ErrorMessage">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="WF_FileName">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="WF_FinishTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="WF_Modality">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WF_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WF_PACS">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="WF_Priority">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="WF_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="WF_Status">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WF_StudyInstanceUID">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="WF_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="WF_TimeEntry">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DICOM</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>WF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WF"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WF_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DICOMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WF"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WF_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WF_Status}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOEORI">
<Global>^DICOMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WF"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"OEORI"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WF_OEORI_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>WF_RowId</SqlRowIdName>
<StreamLocation>^User.DICOMWorkflowS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
