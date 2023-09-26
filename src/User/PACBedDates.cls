/// PAC Bed Dates(1930)
Class User.PACBedDates Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_BedDates, StorageStrategy = SQLStorage ]
{

/// Code
Property BDATECode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = BDATE_Code ];

/// Color
Property BDATEColor As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = BDATE_Color ];

/// Confirmed
Property BDATEConfirmed As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = BDATE_Confirmed ];

/// Days From
Property BDATEDaysFrom As %Float [ SqlColumnNumber = 4, SqlFieldName = BDATE_DaysFrom ];

/// Days To
Property BDATEDaysTo As %Float [ SqlColumnNumber = 5, SqlFieldName = BDATE_DaysTo ];

/// Description
Property BDATEDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = BDATE_Desc ];

/// Font Color
Property BDATEFontColor As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = BDATE_FontColor ];

/// Unconfirmed
Property BDATEUnconfirmed As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = BDATE_Unconfirmed ];

Parameter EXTENTSIZE = 7;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACBedDates).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACBedDates","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACBedDates).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACBedDates","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACBedDates).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACBedDates","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACBedDates).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACBedDates","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACBedDates).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACBedDates","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>7</ExtentSize>
<Property name="BDATECode">
<Selectivity>1</Selectivity>
</Property>
<Property name="BDATEColor">
<Selectivity>1</Selectivity>
</Property>
<Property name="BDATEConfirmed">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="BDATEDaysFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="BDATEDaysTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="BDATEDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="BDATEFontColor">
<Selectivity>1</Selectivity>
</Property>
<Property name="BDATEUnconfirmed">
<Selectivity>33.3333%</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("BDATE",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BDATE_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BDATE_Color">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BDATE_Confirmed">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BDATE_DaysFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BDATE_DaysTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BDATE_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BDATE_FontColor">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BDATE_Unconfirmed">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BDATE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BDATE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BDATE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BDATE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BDATE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({BDATE_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BDATE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BDATE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BDATE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({BDATE_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BDATE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BDATE_RowId</SqlRowIdName>
<StreamLocation>^User.PACBedDatesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
