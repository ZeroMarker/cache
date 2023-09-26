/// PAC Actvity when injured(1877)
Class User.PACActivityWhenInjured Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_ActivityWhenInjured, StorageStrategy = SQLStorage ]
{

/// Code
Property ACTINJCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ACTINJ_Code ];

/// Date From
Property ACTINJDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = ACTINJ_DateFrom ];

/// Date To
Property ACTINJDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = ACTINJ_DateTo ];

/// Description
Property ACTINJDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ACTINJ_Desc ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACActivityWhenInjured).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACActivityWhenInjured","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACActivityWhenInjured).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACActivityWhenInjured","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACActivityWhenInjured).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACActivityWhenInjured","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACActivityWhenInjured).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACActivityWhenInjured","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACActivityWhenInjured).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACActivityWhenInjured","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="ACTINJCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="ACTINJDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="ACTINJDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="ACTINJDesc">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("ACTINJ",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ACTINJ_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ACTINJ_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ACTINJ_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ACTINJ_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ACTINJ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ACTINJ"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ACTINJ_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ACTINJ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ACTINJ"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ACTINJ_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ACTINJ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ACTINJ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ACTINJ"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ACTINJ_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ACTINJ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ACTINJ_RowId</SqlRowIdName>
<StreamLocation>^User.PACActivityWhenInjuredS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
