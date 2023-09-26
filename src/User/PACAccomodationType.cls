/// AccomodationType(2080)
Class User.PACAccomodationType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_AccomodationType, StorageStrategy = SQLStorage ]
{

/// Code
Property ACCOMTCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ACCOMT_Code ];

/// Date From
Property ACCOMTDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = ACCOMT_DateFrom ];

/// Date To
Property ACCOMTDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = ACCOMT_DateTo ];

/// Description
Property ACCOMTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ACCOMT_Desc ];

/// National Code
Property ACCOMTNationalCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = ACCOMT_NationalCode ];

/// Waiting List
Property ACCOMTWL As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = ACCOMT_WL ];

Parameter EXTENTSIZE = 2;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACAccomodationType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAccomodationType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACAccomodationType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAccomodationType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACAccomodationType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAccomodationType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACAccomodationType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAccomodationType","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACAccomodationType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAccomodationType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>2</ExtentSize>
<Property name="ACCOMTCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="ACCOMTDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="ACCOMTDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="ACCOMTDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="ACCOMTNationalCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="ACCOMTWL">
<Selectivity>33.3333%</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("ACCOMT",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ACCOMT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ACCOMT_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ACCOMT_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ACCOMT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ACCOMT_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ACCOMT_WL">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ACCOMT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ACCOMT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ACCOMT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ACCOMT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ACCOMT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ACCOMT_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ACCOMT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ACCOMT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ACCOMT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ACCOMT_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ACCOMT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ACCOMT_RowId</SqlRowIdName>
<StreamLocation>^User.PACAccomodationTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
