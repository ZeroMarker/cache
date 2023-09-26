/// Likely Transferout ICU(2088)
Class User.PACLikelyTransferoutICU Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_LikelyTransferoutICU, StorageStrategy = SQLStorage ]
{

/// Code
Property LTICUCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = LTICU_Code ];

/// Description
Property LTICUDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = LTICU_Desc ];

/// Icon Name
Property LTICUIconName As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = LTICU_IconName ];

/// Icon Priority
Property LTICUIconPrior As %Float [ SqlColumnNumber = 5, SqlFieldName = LTICU_IconPrior ];

Parameter EXTENTSIZE = 3;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACLikelyTransferoutICU).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACLikelyTransferoutICU","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACLikelyTransferoutICU).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACLikelyTransferoutICU","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACLikelyTransferoutICU).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACLikelyTransferoutICU","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACLikelyTransferoutICU).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACLikelyTransferoutICU","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACLikelyTransferoutICU).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACLikelyTransferoutICU","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>3</ExtentSize>
<Property name="LTICUCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="LTICUDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="LTICUIconName">
<Selectivity>1</Selectivity>
</Property>
<Property name="LTICUIconPrior">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("LTICU",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LTICU_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LTICU_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LTICU_IconName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LTICU_IconPrior">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>LTICU_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LTICU"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{LTICU_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>LTICU_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LTICU"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({LTICU_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LTICU_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>LTICU_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LTICU"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({LTICU_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LTICU_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LTICU_RowId</SqlRowIdName>
<StreamLocation>^User.PACLikelyTransferoutICUS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
