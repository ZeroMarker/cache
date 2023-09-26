/// PAC Management of Abortion(1970)
Class User.PACManagementOfAbortion Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_ManagementOfAbortion, StorageStrategy = SQLStorage ]
{

/// Code
Property MABORTCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = MABORT_Code ];

/// Description
Property MABORTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = MABORT_Desc ];

/// National code
Property MABORTNationalCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = MABORT_NationalCode ];

Parameter EXTENTSIZE = 4;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACManagementOfAbortion).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACManagementOfAbortion","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACManagementOfAbortion).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACManagementOfAbortion","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACManagementOfAbortion).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACManagementOfAbortion","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACManagementOfAbortion).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACManagementOfAbortion","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACManagementOfAbortion).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACManagementOfAbortion","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>4</ExtentSize>
<Property name="MABORTCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="MABORTDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="MABORTNationalCode">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("MABORT",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MABORT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MABORT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MABORT_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MABORT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MABORT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MABORT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MABORT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MABORT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({MABORT_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MABORT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MABORT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MABORT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({MABORT_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MABORT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MABORT_RowId</SqlRowIdName>
<StreamLocation>^User.PACManagementOfAbortionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
