/// CT Health Care Area(1403)
Class User.CTHealthCareArea Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_HealthCareArea, StorageStrategy = SQLStorage ]
{

/// Code
Property HCACode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = HCA_Code ];

/// Date From
Property HCADateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = HCA_DateFrom ];

/// Date To
Property HCADateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = HCA_DateTo ];

/// Description
Property HCADesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = HCA_Desc ];

/// Des Ref HCR
Property HCAHCRDR As CTHealthCareRegion [ SqlColumnNumber = 4, SqlFieldName = HCA_HCR_DR ];

Index HCACodeUnqIdx1 On HCACode [ Unique ];

Index HCADescUnqIdx2 On HCADesc [ Unique ];

Parameter EXTENTSIZE = 577;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTHealthCareArea).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHealthCareArea","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTHealthCareArea).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHealthCareArea","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTHealthCareArea).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHealthCareArea","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTHealthCareArea).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHealthCareArea","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTHealthCareArea).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHealthCareArea","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>577</ExtentSize>
<Property name="HCACode">
<Selectivity>1</Selectivity>
</Property>
<Property name="HCADateFrom">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="HCADateTo">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="HCADesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="HCAHCRDR">
<Selectivity>0.9346%</Selectivity>
</Property>
<SqlIdExpression>$i(^CT("HCA",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="HCA_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HCA_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="HCA_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="HCA_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HCA_HCR_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>HCA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HCA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{HCA_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>HCA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HCA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({HCA_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HCA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>HCA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HCA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({HCA_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HCA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>HCA_RowId</SqlRowIdName>
<StreamLocation>^User.CTHealthCareAreaS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
