/// PAC Account Class(1796)
Class User.PACAccountClass Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_AccountClass, StorageStrategy = SQLStorage ]
{

/// AccomType
Property ACCLAccomType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = ACCL_AccomType ];

/// CareType
Property ACCLCareType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = ACCL_CareType ];

/// Case Payment Rate
Property ACCLCasePaymentRate As %Float [ SqlColumnNumber = 11, SqlFieldName = ACCL_CasePaymentRate ];

/// Code
Property ACCLCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ACCL_Code ];

/// Date From
Property ACCLDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = ACCL_DateFrom ];

/// Date To
Property ACCLDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = ACCL_DateTo ];

/// Default
Property ACCLDefault As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = ACCL_Default ];

/// Description
Property ACCLDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ACCL_Desc ];

/// FundingSource
Property ACCLFundingSource As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = ACCL_FundingSource ];

/// Unqualified Adm
Property ACCLUnqualifiedAdm As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = ACCL_UnqualifiedAdm ];

Parameter EXTENTSIZE = 2;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACAccountClass).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAccountClass","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACAccountClass).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAccountClass","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACAccountClass).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAccountClass","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACAccountClass).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAccountClass","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACAccountClass).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAccountClass","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>2</ExtentSize>
<Property name="ACCLAccomType">
<Selectivity>1</Selectivity>
</Property>
<Property name="ACCLCareType">
<Selectivity>1</Selectivity>
</Property>
<Property name="ACCLCasePaymentRate">
<Selectivity>1</Selectivity>
</Property>
<Property name="ACCLCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="ACCLDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="ACCLDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="ACCLDefault">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ACCLDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="ACCLFundingSource">
<Selectivity>1</Selectivity>
</Property>
<Property name="ACCLUnqualifiedAdm">
<Selectivity>33.3333%</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("ACCL",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ACCL_AccomType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ACCL_CareType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ACCL_CasePaymentRate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ACCL_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ACCL_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ACCL_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ACCL_Default">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ACCL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ACCL_FundingSource">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ACCL_UnqualifiedAdm">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ACCL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ACCL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ACCL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ACCL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ACCL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ACCL_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ACCL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ACCL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ACCL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ACCL_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ACCL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ACCL_RowId</SqlRowIdName>
<StreamLocation>^User.PACAccountClassS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
