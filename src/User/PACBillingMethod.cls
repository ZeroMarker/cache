/// Billing Method(mt2116)
Class User.PACBillingMethod Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_BillingMethod, StorageStrategy = SQLStorage ]
{

/// Code
Property BLMCode As %String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = BLM_Code ];

/// Date From
Property BLMDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = BLM_DateFrom ];

/// Date To
Property BLMDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = BLM_DateTo ];

/// Description
Property BLMDesc As %String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = BLM_Desc ];

/// National Code
Property BLMNationalCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = BLM_NationalCode ];

Index BLMCodeUnqIdx1 On BLMCode [ Unique ];

Parameter EXTENTSIZE = 3;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACBillingMethod).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACBillingMethod","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACBillingMethod).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACBillingMethod","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACBillingMethod).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACBillingMethod","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACBillingMethod).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACBillingMethod","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACBillingMethod).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACBillingMethod","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>3</ExtentSize>
<Property name="BLMCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="BLMDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="BLMDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="BLMDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="BLMNationalCode">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("BLM",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BLM_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BLM_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BLM_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BLM_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BLM_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BLM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BLM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BLM_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BLM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BLM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({BLM_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BLM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BLM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BLM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({BLM_RowId})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BLM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BLM_RowId</SqlRowIdName>
<StreamLocation>^User.PACBillingMethodS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
