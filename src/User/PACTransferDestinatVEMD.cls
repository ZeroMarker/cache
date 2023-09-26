/// PAC Transfer Detsination VEMD(1919
Class User.PACTransferDestinatVEMD Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_TransferDestinatVEMD, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On VEMDChildsub [ IdKey, PrimaryKey, Unique ];

/// PAC_TransferDestination Parent Reference
Relationship VEMDParRef As PACTransferDestination [ Cardinality = parent, Inverse = ChildPACTransferDestinatVEMD, Required, SqlFieldName = VEMD_ParRef ];

/// Childsub
Property VEMDChildsub As %Float [ InitialExpression = {$i(^PAC("TRD",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"VEMD",0))}, SqlColumnNumber = 2, SqlFieldName = VEMD_Childsub ];

/// DateFrom
Property VEMDDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = VEMD_DateFrom ];

/// DateTo
Property VEMDDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = VEMD_DateTo ];

/// VEMDCode
Property VEMDVEMDCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = VEMD_VEMDCode ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACTransferDestinatVEMD).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACTransferDestinatVEMD","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACTransferDestinatVEMD).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACTransferDestinatVEMD","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACTransferDestinatVEMD).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACTransferDestinatVEMD","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACTransferDestinatVEMD).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACTransferDestinatVEMD","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACTransferDestinatVEMD).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACTransferDestinatVEMD","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="VEMD_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="VEMD_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="VEMD_VEMDCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_TransferDestination.TRD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>VEMD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TRD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_TransferDestination.TRD_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"VEMD"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VEMD_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="Indexdate">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_TransferDestination.TRD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>VEMD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TRD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_TransferDestination.TRD_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"VEMD"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{VEMD_DateFrom}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{VEMD_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>VEMD_RowId</SqlRowIdName>
<StreamLocation>^User.PACTransferDestinatVEMDS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
