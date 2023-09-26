/// Soc Worker Centre(2181)
Class User.CTSocWorkerCentre Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_SocWorkerCentre, StorageStrategy = SQLStorage ]
{

/// Code
Property SWCCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = SWC_Code ];

/// Date From
Property SWCDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = SWC_DateFrom ];

/// Date To
Property SWCDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = SWC_DateTo ];

/// Description
Property SWCDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = SWC_Desc ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTSocWorkerCentre).OnTrigger($g(%d(1)))
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTSocWorkerCentre).OnTrigger($g(%d(1)))
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTSocWorkerCentre).OnTrigger($g(%d(1)))
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTSocWorkerCentre).getOld($g(%d(1)))
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTSocWorkerCentre).getOld($g(%d(1)))
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="SWCCode">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SWCDateFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SWCDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SWCDesc">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^CT("SWC",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="SWC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SWC_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SWC_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SWC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SWC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SWC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SWC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SWC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SWC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SWC_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SWC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SWC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SWC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SWC_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SWC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SWC_RowId</SqlRowIdName>
<StreamLocation>^User.CTSocWorkerCentreS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
