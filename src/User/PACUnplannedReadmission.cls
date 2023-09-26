/// Unplanned Readmission(2430)
Class User.PACUnplannedReadmission Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_UnplannedReadmission, StorageStrategy = SQLStorage ]
{

/// Code
Property UNPLREADCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = UNPLREAD_Code ];

/// Date From
Property UNPLREADDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = UNPLREAD_DateFrom ];

/// Date To
Property UNPLREADDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = UNPLREAD_DateTo ];

/// Description
Property UNPLREADDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = UNPLREAD_Desc ];

Parameter EXTENTSIZE = 2;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACUnplannedReadmission).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACUnplannedReadmission","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACUnplannedReadmission).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACUnplannedReadmission","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACUnplannedReadmission).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACUnplannedReadmission","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACUnplannedReadmission).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACUnplannedReadmission","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACUnplannedReadmission).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACUnplannedReadmission","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>2</ExtentSize>
<Property name="UNPLREADCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="UNPLREADDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="UNPLREADDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="UNPLREADDesc">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("UNPLREAD",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="UNPLREAD_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="UNPLREAD_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="UNPLREAD_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="UNPLREAD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>UNPLREAD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"UNPLREAD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{UNPLREAD_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>UNPLREAD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"UNPLREAD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({UNPLREAD_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UNPLREAD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexdesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>UNPLREAD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"UNPLREAD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({UNPLREAD_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UNPLREAD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>UNPLREAD_RowId</SqlRowIdName>
<StreamLocation>^User.PACUnplannedReadmissionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
