/// Extract Details(2606)
Class User.PAExtractDetails Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_ExtractDetails, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DETChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_Extract Parent Reference
Relationship DETParRef As PAExtract [ Cardinality = parent, Inverse = ChildPAExtractDetails, Required, SqlFieldName = DET_ParRef ];

/// Childsub
Property DETChildsub As %Float [ InitialExpression = {$i(^PA("EXTR",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"DET",0))}, SqlColumnNumber = 2, SqlFieldName = DET_Childsub ];

/// Des Ref WaitList
Property DETWaitListDR As PAWaitingList [ SqlColumnNumber = 3, SqlFieldName = DET_WaitList_DR ];

/// Des Ref PAPMI
Property DETPAPMIDR As PAPatMas [ SqlColumnNumber = 4, SqlFieldName = DET_PAPMI_DR ];

/// RecordType
Property DETRecordType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DET_RecordType ];

/// RecordData
Property DETRecordData As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DET_RecordData ];

/// Status
Property DETStatus As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = DET_Status ];

/// RemoveDate
Property DETRemoveDate As %Date [ SqlColumnNumber = 8, SqlFieldName = DET_RemoveDate ];

/// Des Ref PAADM
Property DETPAADMDR As PAAdm [ SqlColumnNumber = 9, SqlFieldName = DET_PAADM_DR ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PAExtractDetails).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAExtractDetails","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PAExtractDetails).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAExtractDetails","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PAExtractDetails).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAExtractDetails","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PAExtractDetails).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAExtractDetails","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAExtractDetails","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PAExtractDetails).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAExtractDetails","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DET_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DET_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DET_RecordData">
<Node>"DATA"</Node>
</Data>
<Data name="DET_RecordType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DET_RemoveDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DET_Status">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DET_WaitList_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PA</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PA_Extract.EXTR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EXTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PA_Extract.EXTR_RowId}</Expression>
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
<SQLMap name="IndexPAADM">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_Extract.EXTR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EXTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PAADM"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DET_PAADM_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_Extract.EXTR_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DET_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAPMI">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_Extract.EXTR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EXTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DET_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_Extract.EXTR_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DET_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRecType">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_Extract.EXTR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EXTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RecType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DET_RecordType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_Extract.EXTR_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DET_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRemoveDate">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_Extract.EXTR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EXTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RemoveDate"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DET_RemoveDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_Extract.EXTR_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DET_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWL">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_Extract.EXTR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EXTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"WL"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DET_WaitList_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_Extract.EXTR_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DET_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DET_RowId</SqlRowIdName>
<StreamLocation>^User.PAExtractDetailsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
