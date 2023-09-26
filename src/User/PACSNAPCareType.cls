/// SNAP Care Type(2378)
Class User.PACSNAPCareType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_SNAPCareType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 2;

Relationship ChildPACSNAPCareTypeADLType As PACSNAPCareTypeADLType [ Cardinality = children, Inverse = ADLParRef ];

/// Code
Property SNAPCTCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = SNAPCT_Code ];

/// Description
Property SNAPCTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = SNAPCT_Desc ];

/// Date From
Property SNAPCTDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = SNAPCT_DateFrom ];

/// Date To
Property SNAPCTDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = SNAPCT_DateTo ];

/// National Code
Property SNAPCTNationalCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = SNAPCT_NationalCode ];

/// Display Converted Score
Property SNAPCTConvertedScore As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = SNAPCT_ConvertedScore ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACSNAPCareType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSNAPCareType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACSNAPCareType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSNAPCareType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACSNAPCareType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSNAPCareType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACSNAPCareType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSNAPCareType","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACSNAPCareType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSNAPCareType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>2</ExtentSize>
<Property name="SNAPCTCode">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="SNAPCTConvertedScore">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SNAPCTDateFrom">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="SNAPCTDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SNAPCTDesc">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="SNAPCTNationalCode">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("SNAPCT",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SNAPCT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SNAPCT_ConvertedScore">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SNAPCT_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SNAPCT_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SNAPCT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SNAPCT_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SNAPCT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SNAPCT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SNAPCT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SNAPCT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SNAPCT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SNAPCT_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SNAPCT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SNAPCT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SNAPCT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SNAPCT_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SNAPCT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SNAPCT_RowId</SqlRowIdName>
<StreamLocation>^User.PACSNAPCareTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
