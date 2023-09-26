/// CT Health Care Region(1525)
Class User.CTHealthCareRegion Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_HealthCareRegion, StorageStrategy = SQLStorage ]
{

/// Code
Property HCRCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = HCR_Code ];

/// Date From
Property HCRDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = HCR_DateFrom ];

/// Date To
Property HCRDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = HCR_DateTo ];

/// Description
Property HCRDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = HCR_Desc ];

Index HCRCodeUnqIdx1 On HCRCode [ Unique ];

Parameter EXTENTSIZE = 113;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTHealthCareRegion).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHealthCareRegion","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTHealthCareRegion).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHealthCareRegion","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTHealthCareRegion).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHealthCareRegion","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTHealthCareRegion).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHealthCareRegion","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTHealthCareRegion).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHealthCareRegion","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>113</ExtentSize>
<Property name="HCRCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="HCRDateFrom">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="HCRDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HCRDesc">
<Selectivity>0.8850%</Selectivity>
</Property>
<SqlIdExpression>$i(^CT("HCR",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="HCR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HCR_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HCR_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="HCR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>HCR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HCR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{HCR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>HCR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HCR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({HCR_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HCR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>HCR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HCR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({HCR_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HCR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>HCR_RowId</SqlRowIdName>
<StreamLocation>^User.CTHealthCareRegionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
