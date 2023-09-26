/// StaffType(2199)
Class User.CTStaffType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_StaffType, StorageStrategy = SQLStorage ]
{

/// Code
Property STAFFCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = STAFF_Code ];

/// Date From
Property STAFFDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = STAFF_DateFrom ];

/// Date To
Property STAFFDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = STAFF_DateTo ];

/// Description
Property STAFFDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = STAFF_Desc ];

Parameter EXTENTSIZE = 3;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTStaffType).OnTrigger($g(%d(1)))
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTStaffType).OnTrigger($g(%d(1)))
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTStaffType).OnTrigger($g(%d(1)))
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTStaffType).getOld($g(%d(1)))
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTStaffType).getOld($g(%d(1)))
}

Storage SQLStorage
{
<ExtentSize>3</ExtentSize>
<Property name="STAFFCode">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="STAFFDateFrom">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="STAFFDateTo">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="STAFFDesc">
<Selectivity>33.3333%</Selectivity>
</Property>
<SqlIdExpression>$i(^CT("STAFF",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="STAFF_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="STAFF_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="STAFF_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="STAFF_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>STAFF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"STAFF"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{STAFF_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>STAFF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"STAFF"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({STAFF_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{STAFF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>STAFF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"STAFF"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({STAFF_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{STAFF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>STAFF_RowId</SqlRowIdName>
<StreamLocation>^User.CTStaffTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
