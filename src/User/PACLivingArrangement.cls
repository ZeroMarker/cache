/// Living Arrangement(2159)
Class User.PACLivingArrangement Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_LivingArrangement, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 3;

/// Code
Property LIVARRCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = LIVARR_Code ];

/// Description
Property LIVARRDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = LIVARR_Desc ];

/// Date From
Property LIVARRDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = LIVARR_DateFrom ];

/// Date To
Property LIVARRDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = LIVARR_DateTo ];

/// National Code
Property LIVARRNationCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = LIVARR_NationCode ];

/// National Code Description
Property LIVARRNationCodeDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = LIVARR_NationCodeDesc ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACLivingArrangement).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACLivingArrangement","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACLivingArrangement).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACLivingArrangement","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACLivingArrangement).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACLivingArrangement","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACLivingArrangement).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACLivingArrangement","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACLivingArrangement).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACLivingArrangement","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>3</ExtentSize>
<Property name="LIVARRCode">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="LIVARRDateFrom">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="LIVARRDateTo">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="LIVARRDesc">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="LIVARRNationCode">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="LIVARRNationCodeDesc">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("LIVARR",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LIVARR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LIVARR_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LIVARR_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LIVARR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LIVARR_NationCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LIVARR_NationCodeDesc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>LIVARR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LIVARR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{LIVARR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>LIVARR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LIVARR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({LIVARR_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LIVARR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>LIVARR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LIVARR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({LIVARR_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LIVARR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LIVARR_RowId</SqlRowIdName>
<StreamLocation>^User.PACLivingArrangementS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
