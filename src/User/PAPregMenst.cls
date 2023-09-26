/// PregMenst(2741)
Class User.PAPregMenst Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PregMenst, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On MHPChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_Pregnancy Parent Reference
Relationship MHPParRef As PAPregnancy [ Cardinality = parent, Inverse = ChildPAPregMenst, Required, SqlFieldName = MHP_ParRef ];

/// Childsub
Property MHPChildsub As %Float [ InitialExpression = {$i(^PAPRG($p(initvalue,$c(1)),"MHP",0))}, SqlColumnNumber = 2, SqlFieldName = MHP_Childsub ];

/// Des Ref MenstHistProb
Property MHPMenstHistProbDR As PACMenstrualHistoryProbs [ SqlColumnNumber = 3, SqlFieldName = MHP_MenstHistProb_DR ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PAPregMenst).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregMenst","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PAPregMenst).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregMenst","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PAPregMenst).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregMenst","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PAPregMenst).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregMenst","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PAPregMenst).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregMenst","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="MHP_MenstHistProb_DR">
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
<Field>MHP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MHP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MHP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MHP_RowId</SqlRowIdName>
<StreamLocation>^User.PAPregMenstS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
