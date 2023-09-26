/// CRAFT Version(2313)
Class User.BLCCRAFTVersion Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = BLC_CRAFTVersion, StorageStrategy = SQLStorage ]
{

/// Code
Property CRAFTVCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CRAFTV_Code ];

/// Date From
Property CRAFTVDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = CRAFTV_DateFrom ];

/// Date To
Property CRAFTVDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = CRAFTV_DateTo ];

/// Description
Property CRAFTVDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CRAFTV_Desc ];

/// Payment Rate
Property CRAFTVPaymentRate As %Float [ SqlColumnNumber = 6, SqlFieldName = CRAFTV_PaymentRate ];

Parameter EXTENTSIZE = 2;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.BLCCRAFTVersion).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCCRAFTVersion","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.BLCCRAFTVersion).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCCRAFTVersion","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.BLCCRAFTVersion).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCCRAFTVersion","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.BLCCRAFTVersion).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCCRAFTVersion","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.BLCCRAFTVersion).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCCRAFTVersion","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>2</ExtentSize>
<Property name="CRAFTVCode">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="CRAFTVDateFrom">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="CRAFTVDateTo">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="CRAFTVDesc">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="CRAFTVPaymentRate">
<Selectivity>50.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^BLC("CRAFTV",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="CRAFTV_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CRAFTV_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CRAFTV_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CRAFTV_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CRAFTV_PaymentRate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^BLC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CRAFTV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CRAFTV"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CRAFTV_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^BLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CRAFTV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CRAFTV"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CRAFTV_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CRAFTV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^BLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CRAFTV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CRAFTV"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CRAFTV_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CRAFTV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CRAFTV_RowId</SqlRowIdName>
<StreamLocation>^User.BLCCRAFTVersionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
