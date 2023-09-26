/// SS User Password (1723)
Class User.SSUserPassword Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_UserPassword, StorageStrategy = SQLStorage ]
{

/// Childsub
Property PASSChildsub As %Float [ InitialExpression = {$i(^SSU("SSUSR",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"PASS",0))}, SqlColumnNumber = 2, SqlFieldName = PASS_Childsub ];

/// SS_User Parent Reference
Relationship PASSParRef As SSUser [ Cardinality = parent, Inverse = ChildSSUserPassword, Required, SqlFieldName = PASS_ParRef ];

/// Password
Property PASSPassword As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PASS_Password ];

Index RowIDBasedIDKeyIndex On PASSChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 419;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSUserPassword).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserPassword","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSUserPassword).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserPassword","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSUserPassword).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserPassword","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSUserPassword).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserPassword","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSUserPassword).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserPassword","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>419</ExtentSize>
<Property name="PASSChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="PASSParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="PASSPassword">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="PASS_Password">
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
<Field>PASS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_User.SSUSR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PASS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PASS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPassword">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_User.SSUSR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>PASS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_User.SSUSR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PASS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Password"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PASS_Password}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PASS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PASS_RowId</SqlRowIdName>
<StreamLocation>^User.SSUserPasswordS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
