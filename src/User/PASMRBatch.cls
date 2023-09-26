/// PA SMR Batch(2003)
Class User.PASMRBatch Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_SMRBatch, StorageStrategy = SQLStorage ]
{

/// Date
Property SMRBDate As %Date [ SqlColumnNumber = 2, SqlFieldName = SMRB_Date ];

/// Time
Property SMRBTime As %Time [ SqlColumnNumber = 3, SqlFieldName = SMRB_Time ];

/// Description
Property SMRBDesc As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = SMRB_Desc ];

/// Batch Record
Property SMRBBatchRecord As %String(COLLATION = "Exact", MAXLEN = 700, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = SMRB_BatchRecord ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PASMRBatch).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASMRBatch","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PASMRBatch).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASMRBatch","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PASMRBatch).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASMRBatch","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PASMRBatch).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASMRBatch","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASMRBatch","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PASMRBatch).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASMRBatch","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PASMRB(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SMRB_BatchRecord">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SMRB_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SMRB_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SMRB_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PASMRB</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SMRB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{SMRB_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SMRB_RowId</SqlRowIdName>
<StreamLocation>^User.PASMRBatchS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
