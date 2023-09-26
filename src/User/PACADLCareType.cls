/// ADLCareType(2379)
Class User.PACADLCareType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_ADLCareType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 2;

Relationship ChildPACADLCareTypeSub As PACADLCareTypeSub [ Cardinality = children, Inverse = SUBParRef ];

/// Code
Property ADLCTCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ADLCT_Code ];

/// Description
Property ADLCTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ADLCT_Desc ];

/// Date From
Property ADLCTDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = ADLCT_DateFrom ];

/// Date To
Property ADLCTDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = ADLCT_DateTo ];

/// National Code
Property ADLCTNationalCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = ADLCT_NationalCode ];

/// Convert To FIM
Property ADLCTConvertToFIM As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = ADLCT_ConvertToFIM ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACADLCareType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACADLCareType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACADLCareType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACADLCareType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACADLCareType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACADLCareType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACADLCareType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACADLCareType","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACADLCareType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACADLCareType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>2</ExtentSize>
<Property name="ADLCTCode">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="ADLCTConvertToFIM">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ADLCTDateFrom">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="ADLCTDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ADLCTDesc">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="ADLCTNationalCode">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("ADLCT",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="ADLCT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADLCT_ConvertToFIM">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ADLCT_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ADLCT_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ADLCT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADLCT_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ADLCT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADLCT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ADLCT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ADLCT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADLCT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ADLCT_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADLCT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ADLCT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADLCT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ADLCT_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADLCT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ADLCT_RowId</SqlRowIdName>
<StreamLocation>^User.PACADLCareTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
