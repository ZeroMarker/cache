/// PregContr(2742)
Class User.PAPregContr Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PregContr, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On CONTRChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_Pregnancy Parent Reference
Relationship CONTRParRef As PAPregnancy [ Cardinality = parent, Inverse = ChildPAPregContr, Required, SqlFieldName = CONTR_ParRef ];

/// Childsub
Property CONTRChildsub As %Float [ InitialExpression = {$i(^PAPRG($p(initvalue,$c(1)),"CONTR",0))}, SqlColumnNumber = 2, SqlFieldName = CONTR_Childsub ];

/// Des Ref ContraceptMethod
Property CONTRContraceptMethodDR As PACContraceptiveMethods [ SqlColumnNumber = 3, SqlFieldName = CONTR_ContraceptMethod_DR ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PAPregContr).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregContr","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PAPregContr).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregContr","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PAPregContr).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregContr","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PAPregContr).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregContr","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PAPregContr).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregContr","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="CONTR_ContraceptMethod_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAPRG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>CONTR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CONTR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CONTR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>CONTR_RowId</SqlRowIdName>
<StreamLocation>^User.PAPregContrS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
