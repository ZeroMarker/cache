/// Standby Status(2414)
Class User.PACStandbyStatus Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_StandbyStatus, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 50;

/// Code
Property STANDSTCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = STANDST_Code ];

/// Description
Property STANDSTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = STANDST_Desc ];

/// Date From
Property STANDSTDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = STANDST_DateFrom ];

/// Date To
Property STANDSTDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = STANDST_DateTo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACStandbyStatus).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACStandbyStatus","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACStandbyStatus).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACStandbyStatus","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACStandbyStatus).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACStandbyStatus","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACStandbyStatus).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACStandbyStatus","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACStandbyStatus).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACStandbyStatus","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>50</ExtentSize>
<Property name="STANDSTCode">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="STANDSTDateFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="STANDSTDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="STANDSTDesc">
<Selectivity>33.3333%</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("STANDST",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="STANDST_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="STANDST_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="STANDST_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="STANDST_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>STANDST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"STANDST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{STANDST_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>STANDST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"STANDST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({STANDST_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{STANDST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexdesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>STANDST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"STANDST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({STANDST_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{STANDST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>STANDST_RowId</SqlRowIdName>
<StreamLocation>^User.PACStandbyStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
