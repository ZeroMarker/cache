/// Local Authority(2172)
Class User.CTLocalAuthority Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_LocalAuthority, StorageStrategy = SQLStorage ]
{

/// Code
Property LOCAUTHCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = LOCAUTH_Code ];

/// Description
Property LOCAUTHDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = LOCAUTH_Desc ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTLocalAuthority).OnTrigger($g(%d(1)))
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTLocalAuthority).OnTrigger($g(%d(1)))
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTLocalAuthority).OnTrigger($g(%d(1)))
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTLocalAuthority).getOld($g(%d(1)))
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTLocalAuthority).getOld($g(%d(1)))
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="LOCAUTHCode">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="LOCAUTHDesc">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^CT("LOCAUTH",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="LOCAUTH_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LOCAUTH_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>LOCAUTH_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LOCAUTH"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{LOCAUTH_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>LOCAUTH_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LOCAUTH"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({LOCAUTH_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LOCAUTH_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>LOCAUTH_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LOCAUTH"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({LOCAUTH_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LOCAUTH_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LOCAUTH_RowId</SqlRowIdName>
<StreamLocation>^User.CTLocalAuthorityS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
