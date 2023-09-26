/// Operation Secondary Procedure(2752)
Class User.ORAnOperSecProc Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OR_An_Oper_SecProc, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On SPRChildsub [ IdKey, PrimaryKey, Unique ];

/// OR_Anaest_Operation Parent Reference
Relationship SPRParRef As ORAnaestOperation [ Cardinality = parent, Inverse = ChildORAnOperSecProc, Required, SqlFieldName = SPR_ParRef ];

/// Childsub
Property SPRChildsub As %Float [ InitialExpression = {$i(^OR($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"ANA",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"OP",$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),"SPR",0))}, SqlColumnNumber = 2, SqlFieldName = SPR_Childsub ];

/// Des Ref StatePPP
Property SPRStatePPPDR As PACStatePPP [ SqlColumnNumber = 3, SqlFieldName = SPR_StatePPP_DR ];

/// Des Ref Operation
Property SPROperationDR As ORCOperation [ SqlColumnNumber = 4, SqlFieldName = SPR_Operation_DR ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.ORAnaesthesia).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnaesthesia","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.ORAnOperSecProc).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnOperSecProc","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.ORAnOperSecProc).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnOperSecProc","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.ORAnOperSecProc).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnOperSecProc","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnOperSecProc","OnBeforeInsert")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.ORAnOperSecProc).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnOperSecProc","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SPR_Operation_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SPR_StatePPP_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^OR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OR_Anaesthesia.ANA_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>OR_Anaest_Operation.ANAOP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L7}</Expression>
<Field>SPR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ANA"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OR_Anaesthesia.ANA_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"OP"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OR_Anaest_Operation.ANAOP_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"SPR"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SPR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SPR_RowId</SqlRowIdName>
<StreamLocation>^User.ORAnOperSecProcS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
