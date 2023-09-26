/// DICOM_Unassoc Imags(1928)
Class User.DICOMUnassocImgs Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DICOM_UnassocImgs, StorageStrategy = SQLStorage ]
{

/// PatID
Property DCUNASSOCPatID As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DCUNASSOC_PatID ];

/// PatName
Property DCUNASSOCPatName As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DCUNASSOC_PatName ];

/// AccessionNo
Property DCUNASSOCAccessionNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DCUNASSOC_AccessionNo ];

/// Modality
Property DCUNASSOCModality As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DCUNASSOC_Modality ];

/// Description
Property DCUNASSOCDescription As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DCUNASSOC_Description ];

/// Date
Property DCUNASSOCDate As %Date [ SqlColumnNumber = 7, SqlFieldName = DCUNASSOC_Date ];

/// Time
Property DCUNASSOCTime As %Time [ SqlColumnNumber = 8, SqlFieldName = DCUNASSOC_Time ];

/// ImgNo
Property DCUNASSOCImgNo As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = DCUNASSOC_ImgNo ];

/// Physician
Property DCUNASSOCPhysician As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = DCUNASSOC_Physician ];

/// StyUID
Property DCUNASSOCStyUID As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = DCUNASSOC_StyUID ];

/// Reason
Property DCUNASSOCReason As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = DCUNASSOC_Reason ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.DICOMUnassocImgs).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMUnassocImgs","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.DICOMUnassocImgs).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMUnassocImgs","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.DICOMUnassocImgs).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMUnassocImgs","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.DICOMUnassocImgs).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMUnassocImgs","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.DICOMUnassocImgs).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMUnassocImgs","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DICOM("UNASI",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DCUNASSOC_AccessionNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DCUNASSOC_Date">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DCUNASSOC_Description">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DCUNASSOC_ImgNo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DCUNASSOC_Modality">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DCUNASSOC_PatID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DCUNASSOC_PatName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DCUNASSOC_Physician">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DCUNASSOC_Reason">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DCUNASSOC_StyUID">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DCUNASSOC_Time">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DICOM</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DCUNASSOC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"UNASI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCUNASSOC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAcession">
<Global>^DICOMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCUNASSOC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"UNASI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Acc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCUNASSOC_AccessionNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCUNASSOC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DICOMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCUNASSOC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"UNASI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCUNASSOC_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCUNASSOC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDescription">
<Global>^DICOMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCUNASSOC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"UNASI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({DCUNASSOC_Description})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCUNASSOC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexImg">
<Global>^DICOMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCUNASSOC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"UNASI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Img"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCUNASSOC_ImgNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCUNASSOC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexModality">
<Global>^DICOMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCUNASSOC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"UNASI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Mod"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCUNASSOC_Modality}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCUNASSOC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatId">
<Global>^DICOMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCUNASSOC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"UNASI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PatId"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({DCUNASSOC_PatID})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCUNASSOC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatname">
<Global>^DICOMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCUNASSOC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"UNASI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PatName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({DCUNASSOC_PatName})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCUNASSOC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPhysician">
<Global>^DICOMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCUNASSOC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"UNASI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Phys"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({DCUNASSOC_Physician})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCUNASSOC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStyUID">
<Global>^DICOMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCUNASSOC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"UNASI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StyUID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCUNASSOC_StyUID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCUNASSOC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DCUNASSOC_RowId</SqlRowIdName>
<StreamLocation>^User.DICOMUnassocImgsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
