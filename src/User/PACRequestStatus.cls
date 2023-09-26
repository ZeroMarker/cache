/// RequestStatus(2163)
Class User.PACRequestStatus Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_RequestStatus, StorageStrategy = SQLStorage ]
{

/// Code
Property REQSTCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = REQST_Code ];

/// Date From
Property REQSTDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = REQST_DateFrom ];

/// Date To
Property REQSTDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = REQST_DateTo ];

/// Description
Property REQSTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = REQST_Desc ];

Parameter EXTENTSIZE = 2;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACRequestStatus).OnTrigger($g(%d(1)))
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACRequestStatus).OnTrigger($g(%d(1)))
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACRequestStatus).OnTrigger($g(%d(1)))
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACRequestStatus).getOld($g(%d(1)))
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACRequestStatus).getOld($g(%d(1)))
}

Storage SQLStorage
{
<ExtentSize>2</ExtentSize>
<Property name="REQSTCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="REQSTDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="REQSTDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="REQSTDesc">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("REQSTAT",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="REQST_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="REQST_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="REQST_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="REQST_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>REQST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REQSTAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{REQST_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>REQST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REQSTAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({REQST_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{REQST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>REQST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REQSTAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({REQST_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{REQST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>REQST_RowId</SqlRowIdName>
<StreamLocation>^User.PACRequestStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
