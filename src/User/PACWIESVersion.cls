/// WIESVersion(2297)
Class User.PACWIESVersion Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_WIESVersion, StorageStrategy = SQLStorage ]
{

/// CareType
Property WIESVCareType As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = WIESV_CareType ];

/// Code
Property WIESVCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = WIESV_Code ];

/// Contract Role
Property WIESVContractRole As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = WIESV_ContractRole ];

/// DRG
Property WIESVDRG As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = WIESV_DRG ];

/// Date From
Property WIESVDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = WIESV_DateFrom ];

/// Date To
Property WIESVDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = WIESV_DateTo ];

/// Description
Property WIESVDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = WIESV_Desc ];

/// Program Fund Source
Property WIESVProgramFundSource As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = WIESV_ProgramFundSource ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACWIESVersion).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWIESVersion","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACWIESVersion).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWIESVersion","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACWIESVersion).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWIESVersion","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACWIESVersion).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWIESVersion","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACWIESVersion).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWIESVersion","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="WIESVCareType">
<Selectivity>1</Selectivity>
</Property>
<Property name="WIESVCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="WIESVContractRole">
<Selectivity>1</Selectivity>
</Property>
<Property name="WIESVDRG">
<Selectivity>1</Selectivity>
</Property>
<Property name="WIESVDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="WIESVDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="WIESVDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="WIESVProgramFundSource">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("WIESV",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="WIESV_CareType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="WIESV_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WIESV_ContractRole">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="WIESV_DRG">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="WIESV_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WIESV_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WIESV_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WIESV_ProgramFundSource">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>WIESV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WIESV"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WIESV_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WIESV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WIESV"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({WIESV_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WIESV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WIESV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WIESV"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({WIESV_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WIESV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>WIESV_RowId</SqlRowIdName>
<StreamLocation>^User.PACWIESVersionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
