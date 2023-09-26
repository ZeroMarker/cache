/// DICOM Series(1695)
Class User.DICOMSeries Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DICOM_Series, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DCSRSSeriesInstanceUID [ IdKey, PrimaryKey, Unique ];

/// Study DR
Property DCSRSStudyDR As DICOMStudy [ SqlColumnNumber = 2, SqlFieldName = DCSRS_Study_DR ];

/// Modality
Property DCSRSSeriesModality As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DCSRS_SeriesModality ];

/// Series Number
Property DCSRSSeriesNumber As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DCSRS_SeriesNumber ];

/// Series Instance UID
Property DCSRSSeriesInstanceUID As %String(COLLATION = "Exact", MAXLEN = 65, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DCSRS_SeriesInstanceUID ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.DICOMSeries).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMSeries","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.DICOMSeries).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMSeries","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.DICOMSeries).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMSeries","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.DICOMSeries).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMSeries","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.DICOMSeries).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMSeries","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DCSRS_SeriesModality">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DCSRS_SeriesNumber">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DCSRS_Study_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DICOM</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DCSRS_SeriesInstanceUID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SRS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCSRS_SeriesInstanceUID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexModality">
<Global>^DICOMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCSRS_SeriesInstanceUID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SRS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Mod"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({DCSRS_SeriesModality})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCSRS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSeriesNumber">
<Global>^DICOMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCSRS_SeriesInstanceUID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SRS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SeriesNum"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCSRS_SeriesNumber}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCSRS_SeriesInstanceUID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStudy">
<Global>^DICOMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCSRS_SeriesInstanceUID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SRS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Study"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCSRS_Study_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCSRS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DCSRS_RowID</SqlRowIdName>
<StreamLocation>^User.DICOMSeriesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
