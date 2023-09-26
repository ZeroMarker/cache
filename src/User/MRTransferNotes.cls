/// MR Transfer Notes(1246)
Class User.MRTransferNotes Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_TransferNotes, StorageStrategy = SQLStorage ]
{

/// Des Ref to CTCP
Property TRANCTCPDR As CTCareProv [ SqlColumnNumber = 5, SqlFieldName = TRAN_CTCP_DR ];

/// Des Ref to CTPCP
Property TRANCTCPRefDR As CTCareProv [ SqlColumnNumber = 9, SqlFieldName = TRAN_CTCPRef_DR ];

/// Des Ref to CTLOC
Property TRANCTLOCDR As CTLoc [ SqlColumnNumber = 6, SqlFieldName = TRAN_CTLOC_DR ];

/// Childsub
Property TRANChildsub As %Float [ InitialExpression = {$i(^MR($p(%d(0),$c(1)),"TRAN",0))}, SqlColumnNumber = 2, SqlFieldName = TRAN_Childsub ];

/// Date
Property TRANDate As %Date [ InitialExpression = "T", SqlColumnNumber = 3, SqlFieldName = TRAN_Date ];

/// Transfer Notes
Property TRANNotes As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = TRAN_Notes, SqlListType = SUBNODE ];

/// MR_Adm Parent Reference
Relationship TRANParRef As MRAdm [ Cardinality = parent, Inverse = ChildMRTransferNotes, Required, SqlFieldName = TRAN_ParRef ];

/// Time
Property TRANTime As %Time [ InitialExpression = "N", SqlColumnNumber = 4, SqlFieldName = TRAN_Time ];

/// Type
Property TRANType As %String(DISPLAYLIST = ",In,Out", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",I,O") [ SqlColumnNumber = 7, SqlFieldName = TRAN_Type ];

/// Des Ref User
Property TRANUpdateUserDR As SSUser [ SqlColumnNumber = 10, SqlFieldName = TRAN_UpdateUser_DR ];

Index RowIDBasedIDKeyIndex On TRANChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRTransferNotes).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRTransferNotes","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRTransferNotes).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRTransferNotes","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRTransferNotes).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRTransferNotes","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRTransferNotes).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRTransferNotes","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRTransferNotes).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRTransferNotes","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="TRAN_CTCPRef_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TRAN_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TRAN_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TRAN_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TRAN_Notes">
<Node>"REM"</Node>
</Data>
<Data name="TRAN_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TRAN_Type">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TRAN_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>TRAN_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TRAN"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TRAN_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>TRAN_RowId</SqlRowIdName>
<StreamLocation>^User.MRTransferNotesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
