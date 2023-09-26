/// User Round(2215)
Class User.SSUserRound Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_UserRound, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On RNDChildsub [ IdKey, PrimaryKey, Unique ];

/// SS_User Parent Reference
Relationship RNDParRef As SSUser [ Cardinality = parent, Inverse = ChildSSUserRound, Required, SqlFieldName = RND_ParRef ];

/// Childsub
Property RNDChildsub As %Float [ InitialExpression = {$i(^SSU("SSUSR",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"RND",0))}, SqlColumnNumber = 2, SqlFieldName = RND_Childsub ];

/// Des Ref CTCP
Property RNDCTCPDR As CTCareProv [ SqlColumnNumber = 3, SqlFieldName = RND_CTCP_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSMessage).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSMessage","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSMessage).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSMessage","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSMessage).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSMessage","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSMessage).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSMessage","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSMessage).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSMessage","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="RND_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_User.SSUSR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RND_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_User.SSUSR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RND"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RND_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDoc">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_User.SSUSR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>RND_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_User.SSUSR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RND"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Doc"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RND_CTCP_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RND_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDoc1">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SS_User.SSUSR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>RND_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RoundDoc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RND_CTCP_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SS_User.SSUSR_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RND_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RND_RowId</SqlRowIdName>
<StreamLocation>^User.SSUserRoundS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
