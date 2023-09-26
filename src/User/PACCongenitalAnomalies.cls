/// Congenital Anomalies(2259)
Class User.PACCongenitalAnomalies Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_CongenitalAnomalies, StorageStrategy = SQLStorage ]
{

/// Active
Property CONGANOMActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = CONGANOM_Active ];

/// Anomaly type
Property CONGANOMAnomType As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = CONGANOM_AnomType ];

/// Code
Property CONGANOMCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CONGANOM_Code ];

/// Date From
Property CONGANOMDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = CONGANOM_DateFrom ];

/// DateTo
Property CONGANOMDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = CONGANOM_DateTo ];

/// Description
Property CONGANOMDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CONGANOM_Desc ];

/// National Code
Property CONGANOMNationalCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = CONGANOM_NationalCode ];

Parameter EXTENTSIZE = 4;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACCongenitalAnomalies).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACCongenitalAnomalies","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACCongenitalAnomalies).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACCongenitalAnomalies","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACCongenitalAnomalies).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACCongenitalAnomalies","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACCongenitalAnomalies).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACCongenitalAnomalies","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACCongenitalAnomalies).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACCongenitalAnomalies","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>4</ExtentSize>
<Property name="CONGANOMActive">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CONGANOMAnomType">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONGANOMCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONGANOMDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONGANOMDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONGANOMDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONGANOMNationalCode">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("CONGANOM",0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="CONGANOM_Active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CONGANOM_AnomType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CONGANOM_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CONGANOM_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CONGANOM_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CONGANOM_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CONGANOM_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CONGANOM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONGANOM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CONGANOM_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CONGANOM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONGANOM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CONGANOM_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CONGANOM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CONGANOM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONGANOM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CONGANOM_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CONGANOM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CONGANOM_RowId</SqlRowIdName>
<StreamLocation>^User.PACCongenitalAnomaliesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
