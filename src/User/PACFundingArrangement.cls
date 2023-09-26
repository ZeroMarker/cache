/// PAC Funding Arrangement(1801)
Class User.PACFundingArrangement Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_FundingArrangement, StorageStrategy = SQLStorage ]
{

Relationship ChildPACFundingArrangementDet As PACFundingArrangementDet [ Cardinality = children, Inverse = DETParRef ];

/// Code
Property FUNDARCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = FUNDAR_Code ];

/// Description
Property FUNDARDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = FUNDAR_Desc ];

/// Date From
Property FUNDARDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = FUNDAR_DateFrom ];

/// Date To
Property FUNDARDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = FUNDAR_DateTo ];

/// Default
Property FUNDARDefault As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = FUNDAR_Default ];

/// National Code
Property FUNDARNationCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = FUNDAR_NationCode ];

/// ContractType
Property FUNDARContractType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = FUNDAR_ContractType ];

/// ContractRole
Property FUNDARContractRole As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = FUNDAR_ContractRole ];

/// AdmSource
Property FUNDARAdmSource As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = FUNDAR_AdmSource ];

/// DischDestin
Property FUNDARDischDestin As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = FUNDAR_DischDestin ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACFundingArrangement).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACFundingArrangement","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACFundingArrangement).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACFundingArrangement","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACFundingArrangement).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACFundingArrangement","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACFundingArrangement).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACFundingArrangement","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACFundingArrangement).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACFundingArrangement","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("FUNDAR",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="FUNDAR_AdmSource">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="FUNDAR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FUNDAR_ContractRole">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="FUNDAR_ContractType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="FUNDAR_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="FUNDAR_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="FUNDAR_Default">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="FUNDAR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="FUNDAR_DischDestin">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="FUNDAR_NationCode">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>FUNDAR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"FUNDAR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{FUNDAR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>FUNDAR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"FUNDAR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({FUNDAR_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{FUNDAR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>FUNDAR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"FUNDAR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({FUNDAR_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{FUNDAR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>FUNDAR_RowId</SqlRowIdName>
<StreamLocation>^User.PACFundingArrangementS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
