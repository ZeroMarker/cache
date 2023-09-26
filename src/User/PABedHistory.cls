/// Bed History(2374)
Class User.PABedHistory Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_BedHistory, StorageStrategy = SQLStorage ]
{

/// Des Ref Ward
Property BHWardDR As PACWard [ SqlColumnNumber = 2, SqlFieldName = BH_Ward_DR ];

/// Des Ref Bed
Property BHBedDR As PACBed [ SqlColumnNumber = 3, SqlFieldName = BH_Bed_DR ];

/// Date From
Property BHDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = BH_DateFrom ];

/// Date To
Property BHDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = BH_DateTo ];

/// Des Ref PAADM
Property BHPAADMDR As PAAdm [ SqlColumnNumber = 6, SqlFieldName = BH_PAADM_DR ];

/// Time From
Property BHTimeFrom As %Time [ SqlColumnNumber = 7, SqlFieldName = BH_TimeFrom ];

/// Time To
Property BHTimeTo As %Time [ SqlColumnNumber = 8, SqlFieldName = BH_TimeTo ];

/// Des Ref AdmTransaction
Property BHAdmTransactionDR As PAAdmTransaction [ SqlColumnNumber = 9, SqlFieldName = BH_AdmTransaction_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PABedHistory).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PABedHistory","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PABedHistory).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PABedHistory","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PABedHistory).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PABedHistory","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PABedHistory).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PABedHistory","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PABedHistory).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PABedHistory","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PABDH(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BH_AdmTransaction_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BH_Bed_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BH_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BH_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BH_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BH_TimeFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BH_TimeTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BH_Ward_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PABDH</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BH_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{BH_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^PABDH</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BH_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BH_PAADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BH_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAdmTrans">
<Global>^PABDH</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BH_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AdmTrans"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BH_AdmTransaction_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BH_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBedDate">
<Global>^PABDH</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>BH_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BedDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BH_Bed_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BH_DateFrom}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BH_TimeFrom}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{BH_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^PABDH</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BH_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BH_DateFrom}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BH_TimeFrom}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BH_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWardDate">
<Global>^PABDH</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>BH_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"WardDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BH_Ward_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BH_DateFrom}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BH_TimeFrom}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{BH_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BH_RowId</SqlRowIdName>
<StreamLocation>^User.PABedHistoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
