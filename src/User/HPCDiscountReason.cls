/// HPC Reason for Discount(1316)
Class User.HPCDiscountReason Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = HPC_DiscountReason, StorageStrategy = SQLStorage ]
{

/// Code
Property DISCRCode As %String(COLLATION = "AlphaUp", MAXLEN = 4, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = DISCR_Code ];

/// Description
Property DISCRDesc As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = DISCR_Desc ];

Index DISCRCodeUnqIdx1 On DISCRCode [ Unique ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.HPCDiscountReason).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.HPCDiscountReason","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.HPCDiscountReason).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.HPCDiscountReason","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.HPCDiscountReason).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.HPCDiscountReason","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.HPCDiscountReason).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.HPCDiscountReason","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.HPCDiscountReason).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.HPCDiscountReason","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="DISCRCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="DISCRDesc">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^HPC("DISCR",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DISCR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DISCR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^HPC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DISCR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DISCR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DISCR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^HPC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DISCR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DISCR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({DISCR_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DISCR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^HPC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DISCR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DISCR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({DISCR_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DISCR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DISCR_RowId</SqlRowIdName>
<StreamLocation>^User.HPCDiscountReasonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
