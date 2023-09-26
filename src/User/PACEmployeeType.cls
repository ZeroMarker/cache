/// PAC Employee Type      (PACET,1059)
Class User.PACEmployeeType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_EmployeeType, StorageStrategy = SQLStorage ]
{

/// Code
Property EPECode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = EPE_Code ];

/// Description
Property EPEDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = EPE_Desc ];

Index EPECodeUnqIdx1 On EPECode [ Unique ];

Parameter EXTENTSIZE = 3;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACEmployeeType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACEmployeeType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACEmployeeType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACEmployeeType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACEmployeeType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACEmployeeType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACEmployeeType).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACEmployeeType","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACEmployeeType).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACEmployeeType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>3</ExtentSize>
<Property name="EPECode">
<Selectivity>1</Selectivity>
</Property>
<Property name="EPEDesc">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("EPE",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EPE_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EPE_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>EPE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EPE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{EPE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EPE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EPE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({EPE_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EPE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EPE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EPE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({EPE_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EPE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>EPE_RowId</SqlRowIdName>
<StreamLocation>^User.PACEmployeeTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
