/// ARC Reason for Discretionary(1057)
Class User.ARCReasonDiscret Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_ReasonDiscret, StorageStrategy = SQLStorage ]
{

/// Code
Property READISCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = READIS_Code ];

/// Description
Property READISDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = READIS_Desc ];

Index READISCodeUnqIdx1 On READISCode [ Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCReasonDiscret).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCReasonDiscret","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCReasonDiscret).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCReasonDiscret","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCReasonDiscret).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCReasonDiscret","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCReasonDiscret).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCReasonDiscret","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCReasonDiscret).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCReasonDiscret","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^ARC("READIS",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="READIS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="READIS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>READIS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"READIS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{READIS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>READIS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"READIS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({READIS_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{READIS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>READIS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"READIS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({READIS_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{READIS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>READIS_RowId</SqlRowIdName>
<StreamLocation>^User.ARCReasonDiscretS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
