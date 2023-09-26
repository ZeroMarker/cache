/// Liquor Colour(2240)
Class User.PACLiquorColour Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_LiquorColour, StorageStrategy = SQLStorage ]
{

/// Active flag
Property LIQCOLORActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = LIQCOLOR_Active ];

/// Code
Property LIQCOLORCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = LIQCOLOR_Code ];

/// Date From
Property LIQCOLORDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = LIQCOLOR_DateFrom ];

/// Date To
Property LIQCOLORDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = LIQCOLOR_DateTo ];

/// Description
Property LIQCOLORDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = LIQCOLOR_Desc ];

/// National Code
Property LIQCOLORNationalCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = LIQCOLOR_NationalCode ];

Parameter EXTENTSIZE = 5;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACLiquorColour).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACLiquorColour","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACLiquorColour).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACLiquorColour","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACLiquorColour).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACLiquorColour","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACLiquorColour).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACLiquorColour","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACLiquorColour).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACLiquorColour","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>5</ExtentSize>
<Property name="LIQCOLORActive">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="LIQCOLORCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="LIQCOLORDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="LIQCOLORDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="LIQCOLORDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="LIQCOLORNationalCode">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("LIQCOLOR",0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="LIQCOLOR_Active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="LIQCOLOR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LIQCOLOR_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LIQCOLOR_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LIQCOLOR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LIQCOLOR_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>LIQCOLOR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LIQCOLOR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{LIQCOLOR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>LIQCOLOR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LIQCOLOR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({LIQCOLOR_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LIQCOLOR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>LIQCOLOR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LIQCOLOR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({LIQCOLOR_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LIQCOLOR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LIQCOLOR_RowId</SqlRowIdName>
<StreamLocation>^User.PACLiquorColourS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
