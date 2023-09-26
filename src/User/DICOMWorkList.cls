/// DICOM WorkList(1793)
Class User.DICOMWorkList Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DICOM_WorkList, StorageStrategy = SQLStorage ]
{

/// Des Ref OEORI
Property WLOEORIDR As OEOrdItem [ SqlColumnNumber = 2, SqlFieldName = WL_OEORI_DR ];

/// Date
Property WLDate As %Date [ SqlColumnNumber = 3, SqlFieldName = WL_Date ];

/// Des Ref PAPMI
Property WLPAPMIDR As PAPatMas [ SqlColumnNumber = 4, SqlFieldName = WL_PAPMI_DR ];

/// Des Ref PAADM
Property WLPAADMDR As PAAdm [ SqlColumnNumber = 5, SqlFieldName = WL_PAADM_DR ];

/// Accession Number
Property WLAccessionNumber As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = WL_AccessionNumber ];

/// Modality
Property WLModality As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = WL_Modality ];

/// Time
Property WLTime As %Time [ SqlColumnNumber = 8, SqlFieldName = WL_Time ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.DICOMWorkList).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMWorkList","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.DICOMWorkList).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMWorkList","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.DICOMWorkList).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMWorkList","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.DICOMWorkList).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMWorkList","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.DICOMWorkList).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMWorkList","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DICOM("WL",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="WL_AccessionNumber">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="WL_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WL_Modality">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="WL_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WL_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WL_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WL_Time">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DICOM</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAccession">
<Global>^DICOMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Accession"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_AccessionNumber}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DICOMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOEORI">
<Global>^DICOMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"OEORI"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_OEORI_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAPMI">
<Global>^DICOMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>WL_RowId</SqlRowIdName>
<StreamLocation>^User.DICOMWorkListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
