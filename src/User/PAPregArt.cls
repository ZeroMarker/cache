/// Artificial Reproductive Methods
Class User.PAPregArt Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PregArt, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PARMChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_Pregnancy Parent Reference
Relationship PARMParRef As PAPregnancy [ Cardinality = parent, Inverse = ChildPAPregArt, Required, SqlFieldName = PARM_ParRef ];

/// Childsub
Property PARMChildsub As %Float [ InitialExpression = {$i(^PAPRG($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"PARM",0))}, SqlColumnNumber = 2, SqlFieldName = PARM_Childsub ];

/// Des Ref PAC_Art
Property PARMMethodDR As PACArt [ SqlColumnNumber = 3, SqlFieldName = PARM_Method_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAPregArt).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregArt","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAPregArt).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregArt","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAPregArt).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregArt","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAPregArt).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregArt","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAPregArt).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPregArt","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMasterIndex">
<Data name="PARM_Method_DR">
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
<Field>PARM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"PARM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PARM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMethod">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PARM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PARM_Method_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PARM_Method_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"PARM"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PARM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PARM_RowId</SqlRowIdName>
<StreamLocation>^User.PAPregArtS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
