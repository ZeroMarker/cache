/// Induction Indicators(2256)
Class User.PACInductionIndicators Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_InductionIndicators, StorageStrategy = SQLStorage ]
{

/// Active flag
Property INDINDCTRActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = INDINDCTR_Active ];

/// Code
Property INDINDCTRCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = INDINDCTR_Code ];

/// Date From
Property INDINDCTRDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = INDINDCTR_DateFrom ];

/// Date To
Property INDINDCTRDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = INDINDCTR_DateTo ];

/// Description
Property INDINDCTRDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = INDINDCTR_Desc ];

/// National code
Property INDINDCTRNationalCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = INDINDCTR_NationalCode ];

Parameter EXTENTSIZE = 4;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACInductionIndicators).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACInductionIndicators","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACInductionIndicators).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACInductionIndicators","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACInductionIndicators).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACInductionIndicators","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACInductionIndicators).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACInductionIndicators","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACInductionIndicators).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACInductionIndicators","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>4</ExtentSize>
<Property name="INDINDCTRActive">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INDINDCTRCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="INDINDCTRDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="INDINDCTRDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="INDINDCTRDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="INDINDCTRNationalCode">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("INDINDCTR",0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="INDINDCTR_Active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INDINDCTR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INDINDCTR_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INDINDCTR_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INDINDCTR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INDINDCTR_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>INDINDCTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INDINDCTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INDINDCTR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INDINDCTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INDINDCTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({INDINDCTR_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INDINDCTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INDINDCTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INDINDCTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({INDINDCTR_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INDINDCTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INDINDCTR_RowId</SqlRowIdName>
<StreamLocation>^User.PACInductionIndicatorsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
