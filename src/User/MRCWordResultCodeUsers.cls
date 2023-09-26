/// WordResultCodeUsers(2353)
Class User.MRCWordResultCodeUsers Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_WordResultCodeUsers, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On USRChildsub [ IdKey, PrimaryKey, Unique ];

/// MRC_WordResultCode Parent Reference
Relationship USRParRef As MRCWordResultCode [ Cardinality = parent, Inverse = ChildMRCWordResultCodeUsers, Required, SqlFieldName = USR_ParRef ];

/// Childsub
Property USRChildsub As %Float [ InitialExpression = {$i(^MRC("WORD",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"USR",0))}, SqlColumnNumber = 2, SqlFieldName = USR_Childsub ];

/// Des Ref User
Property USRUserDR As SSUser [ SqlColumnNumber = 3, SqlFieldName = USR_User_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRCWordResultCodeUsers).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCWordResultCodeUsers","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRCWordResultCodeUsers).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCWordResultCodeUsers","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRCWordResultCodeUsers).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCWordResultCodeUsers","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRCWordResultCodeUsers).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCWordResultCodeUsers","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRCWordResultCodeUsers).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCWordResultCodeUsers","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="USR_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MRC_WordResultCode.WORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>USR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WORD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRC_WordResultCode.WORD_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"USR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{USR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MRC_WordResultCode.WORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>USR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WORD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRC_WordResultCode.WORD_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"USR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{USR_User_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{USR_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>USR_RowId</SqlRowIdName>
<StreamLocation>^User.MRCWordResultCodeUsersS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
