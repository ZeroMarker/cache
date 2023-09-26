/// Retroplacental Clot(2248)
Class User.PACRetroplacentalClot Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_RetroplacentalClot, StorageStrategy = SQLStorage ]
{

/// Active
Property PLACCLOTActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PLACCLOT_Active ];

/// Code
Property PLACCLOTCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = PLACCLOT_Code ];

/// Date From
Property PLACCLOTDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = PLACCLOT_DateFrom ];

/// DateTo
Property PLACCLOTDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = PLACCLOT_DateTo ];

/// Description
Property PLACCLOTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PLACCLOT_Desc ];

/// National code
Property PLACCLOTNationalCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = PLACCLOT_NationalCode ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACRetroplacentalClot).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACRetroplacentalClot","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACRetroplacentalClot).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACRetroplacentalClot","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACRetroplacentalClot).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACRetroplacentalClot","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACRetroplacentalClot).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACRetroplacentalClot","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACRetroplacentalClot).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACRetroplacentalClot","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="PLACCLOTActive">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="PLACCLOTCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="PLACCLOTDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="PLACCLOTDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="PLACCLOTDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="PLACCLOTNationalCode">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("PLACCLOT",0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="PLACCLOT_Active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PLACCLOT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PLACCLOT_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PLACCLOT_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PLACCLOT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PLACCLOT_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PLACCLOT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PLACCLOT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PLACCLOT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PLACCLOT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PLACCLOT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({PLACCLOT_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PLACCLOT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PLACCLOT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PLACCLOT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({PLACCLOT_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PLACCLOT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PLACCLOT_RowId</SqlRowIdName>
<StreamLocation>^User.PACRetroplacentalClotS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
