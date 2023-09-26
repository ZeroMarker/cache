/// DICOM Image(1693)
Class User.DICOMImage Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DICOM_Image, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DCIMGSOPInstanceUID [ IdKey, PrimaryKey, Unique ];

/// Series DR
Property DCIMGSeriesDR As DICOMSeries [ SqlColumnNumber = 2, SqlFieldName = DCIMG_Series_DR ];

/// Image Number
Property DCIMGImageNumber As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DCIMG_ImageNumber ];

/// Image SOP Instance UID
Property DCIMGSOPInstanceUID As %String(COLLATION = "Exact", MAXLEN = 65, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DCIMG_SOPInstanceUID ];

/// Image File Name
Property DCIMGImageFileName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DCIMG_ImageFileName ];

/// Des Ref OeOrdRes
Property DCIMGOeOrdResDR As OEOrdResult [ SqlColumnNumber = 6, SqlComputeCode = { s {DCIMG_OeOrdRes_DR}=$$CO6^at1693({DCIMG_SOPInstanceUID})
}, SqlComputed, SqlFieldName = DCIMG_OeOrdRes_DR, Transient ];

/// Image deleted
Property DCIMGDeleted As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = DCIMG_Deleted ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.DICOMImage).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMImage","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.DICOMImage).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMImage","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.DICOMImage).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMImage","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.DICOMImage).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMImage","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.DICOMImage).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMImage","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DCIMG_Deleted">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DCIMG_ImageFileName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DCIMG_ImageNumber">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DCIMG_Series_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DICOM</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DCIMG_SOPInstanceUID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"IMG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCIMG_SOPInstanceUID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSeries">
<Global>^DICOMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCIMG_SOPInstanceUID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"IMG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Srs"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCIMG_Series_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCIMG_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DCIMG_RowID</SqlRowIdName>
<StreamLocation>^User.DICOMImageS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
