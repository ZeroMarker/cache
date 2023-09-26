/// ORC Operation Alias(1868)
Class User.ORCOperationAlias Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = ORC_OperationAlias, StorageStrategy = SQLStorage ]
{

/// Childsub
Property ALIASChildsub As %Float [ InitialExpression = {$i(^ORC("OPER",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"ALIAS",0))}, SqlColumnNumber = 2, SqlFieldName = ALIAS_Childsub ];

/// ORC_Operation Parent Reference
Relationship ALIASParRef As ORCOperation [ Cardinality = parent, Inverse = ChildORCOperationAlias, Required, SqlFieldName = ALIAS_ParRef ];

/// Text
Property ALIASText As %String(COLLATION = "AlphaUp", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ALIAS_Text ];

Index RowIDBasedIDKeyIndex On ALIASChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ORCOperationAlias).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCOperationAlias","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ORCOperationAlias).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCOperationAlias","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ORCOperationAlias).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCOperationAlias","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ORCOperationAlias).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCOperationAlias","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ORCOperationAlias).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCOperationAlias","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ALIAS_Text">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^ORC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ORC_Operation.OPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ALIAS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OPER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ORC_Operation.OPER_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="3">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ALIAS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAlias">
<Global>^ORC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ORC_Operation.OPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>ALIAS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OPER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ALIAS_Text})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ORC_Operation.OPER_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ALIAS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ALIAS_RowId</SqlRowIdName>
<StreamLocation>^User.ORCOperationAliasS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
