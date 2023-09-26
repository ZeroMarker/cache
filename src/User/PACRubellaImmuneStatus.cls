/// Rubella Immune Status(2253)
Class User.PACRubellaImmuneStatus Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_RubellaImmune_Status, StorageStrategy = SQLStorage ]
{

/// Active
Property RUBIMSTSActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = RUBIMSTS_Active ];

/// Code
Property RUBIMSTSCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = RUBIMSTS_Code ];

/// Date From
Property RUBIMSTSDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = RUBIMSTS_DateFrom ];

/// Date To
Property RUBIMSTSDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = RUBIMSTS_DateTo ];

/// Description
Property RUBIMSTSDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = RUBIMSTS_Desc ];

/// National code
Property RUBIMSTSNationalCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = RUBIMSTS_NationalCode ];

Parameter EXTENTSIZE = 2;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACRubellaImmuneStatus).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACRubellaImmuneStatus","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACRubellaImmuneStatus).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACRubellaImmuneStatus","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACRubellaImmuneStatus).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACRubellaImmuneStatus","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACRubellaImmuneStatus).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACRubellaImmuneStatus","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACRubellaImmuneStatus).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACRubellaImmuneStatus","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>2</ExtentSize>
<Property name="RUBIMSTSActive">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="RUBIMSTSCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="RUBIMSTSDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="RUBIMSTSDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="RUBIMSTSDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="RUBIMSTSNationalCode">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("RUBIMSTS",0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="RUBIMSTS_Active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RUBIMSTS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RUBIMSTS_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RUBIMSTS_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RUBIMSTS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RUBIMSTS_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RUBIMSTS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RUBIMSTS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RUBIMSTS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RUBIMSTS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RUBIMSTS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({RUBIMSTS_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RUBIMSTS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RUBIMSTS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RUBIMSTS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({RUBIMSTS_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RUBIMSTS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RUBIMSTS_RowId</SqlRowIdName>
<StreamLocation>^User.PACRubellaImmuneStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
