/// DispositDet(2555)
Class User.CTDispositDet Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_DispositDet, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DETChildsub [ IdKey, PrimaryKey, Unique ];

/// CT_Disposit Parent Reference
Relationship DETParRef As CTDisposit [ Cardinality = parent, Inverse = ChildCTDispositDet, Required, SqlFieldName = DET_ParRef ];

/// Childsub
Property DETChildsub As %Float [ InitialExpression = {$i(^CT("DSP",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"DET",0))}, SqlColumnNumber = 2, SqlFieldName = DET_Childsub ];

/// Date From
Property DETDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = DET_DateFrom ];

/// Date To
Property DETDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = DET_DateTo ];

/// TransferSource
Property DETTransferSource As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DET_TransferSource ];

/// IntentReAdmit
Property DETIntentReAdmit As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DET_IntentReAdmit ];

/// CareAvailability
Property DETCareAvailability As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = DET_CareAvailability ];

/// CareTyp
Property DETCareTyp As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = DET_CareTyp ];

/// SeparationReferral
Property DETSeparationReferral As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = DET_SeparationReferral ];

/// ReasonForCritCareTransfer
Property DETReasonForCritCareTransfe As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = DET_ReasonForCritCareTransfe ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTDispositDet).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTDispositDet","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTDispositDet).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTDispositDet","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTDispositDet).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTDispositDet","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTDispositDet).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTDispositDet","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTDispositDet).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTDispositDet","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DET_CareAvailability">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DET_CareTyp">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DET_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DET_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DET_IntentReAdmit">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DET_ReasonForCritCareTransfe">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DET_SeparationReferral">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DET_TransferSource">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CT_Disposit.CTDSP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DSP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CT_Disposit.CTDSP_RowID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DET"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DET_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DET_RowId</SqlRowIdName>
<StreamLocation>^User.CTDispositDetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
