/// Transferring
Class User.PACTransferring Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_Transferring, StorageStrategy = SQLStorage ]
{

/// Code
Property TRANSFCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = TRANSF_Code ];

/// Date From
Property TRANSFDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = TRANSF_DateFrom ];

/// Date To
Property TRANSFDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = TRANSF_DateTo ];

/// Description
Property TRANSFDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = TRANSF_Desc ];

/// National Code
Property TRANSFNationCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = TRANSF_NationCode ];

/// Numeric Value
Property TRANSFNumericVal As %Float(MAXVAL = 100, MINVAL = 0) [ SqlColumnNumber = 6, SqlFieldName = TRANSF_NumericVal ];

Parameter EXTENTSIZE = 4;

Trigger TAfterDel [ Event = DELETE, Order = 5, Time = AFTER ]
{
 d ##Class(User.PACTransferring).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACTransferring","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACTransferring).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACTransferring","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 4, Time = AFTER ]
{
 d ##Class(User.PACTransferring).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACTransferring","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 6 ]
{
 d ##Class(User.PACTransferring).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACTransferring","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 2 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 3 ]
{
 d ##Class(User.PACTransferring).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACTransferring","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>4</ExtentSize>
<Property name="TRANSFCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRANSFDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRANSFDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRANSFDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRANSFNationCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRANSFNumericVal">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("TRANSF",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="TRANSF_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TRANSF_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TRANSF_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TRANSF_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TRANSF_NationCode">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TRANSF_NumericVal">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>TRANSF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TRANSF"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{TRANSF_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TRANSF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TRANSF"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({TRANSF_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TRANSF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TRANSF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TRANSF"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({TRANSF_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TRANSF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TRANSF_RowId</SqlRowIdName>
<StreamLocation>^User.PACTransferringS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
