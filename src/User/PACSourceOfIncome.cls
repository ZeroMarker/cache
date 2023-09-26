/// Source Of Income(2158)
Class User.PACSourceOfIncome Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_SourceOfIncome, StorageStrategy = SQLStorage ]
{

/// Code
Property SRCINCCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = SRCINC_Code ];

/// Date From
Property SRCINCDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = SRCINC_DateFrom ];

/// Date To
Property SRCINCDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = SRCINC_DateTo ];

/// Description
Property SRCINCDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = SRCINC_Desc ];

/// National Code
Property SRCINCNationCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = SRCINC_NationCode ];

/// National Code Description
Property SRCINCNationCodeDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = SRCINC_NationCodeDesc ];

Parameter EXTENTSIZE = 3;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACSourceOfIncome).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSourceOfIncome","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACSourceOfIncome).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSourceOfIncome","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACSourceOfIncome).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSourceOfIncome","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACSourceOfIncome).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSourceOfIncome","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACSourceOfIncome).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSourceOfIncome","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>3</ExtentSize>
<Property name="SRCINCCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="SRCINCDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="SRCINCDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="SRCINCDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="SRCINCNationCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="SRCINCNationCodeDesc">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("SRCINC",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="SRCINC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SRCINC_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SRCINC_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SRCINC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SRCINC_NationCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SRCINC_NationCodeDesc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SRCINC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SRCINC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SRCINC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SRCINC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SRCINC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SRCINC_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SRCINC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexdesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SRCINC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SRCINC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SRCINC_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SRCINC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SRCINC_RowId</SqlRowIdName>
<StreamLocation>^User.PACSourceOfIncomeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
