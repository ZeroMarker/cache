/// PayrollClassification(2198)
Class User.CTPayrollClassification Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_PayrollClassification, StorageStrategy = SQLStorage ]
{

/// Code
Property PAYCLSCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = PAYCLS_Code ];

/// Date From
Property PAYCLSDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = PAYCLS_DateFrom ];

/// Date To
Property PAYCLSDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = PAYCLS_DateTo ];

/// Description
Property PAYCLSDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PAYCLS_Desc ];

Parameter EXTENTSIZE = 4;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTPayrollClassification).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTPayrollClassification","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTPayrollClassification).OnTrigger($g(%d(1)))             
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTPayrollClassification","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTPayrollClassification).OnTrigger($g(%d(1))) 
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTPayrollClassification","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTPayrollClassification).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTPayrollClassification","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTPayrollClassification).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTPayrollClassification","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>4</ExtentSize>
<Property name="PAYCLSCode">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="PAYCLSDateFrom">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="PAYCLSDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PAYCLSDesc">
<Selectivity>25.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^CT("PAYCLS",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="PAYCLS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PAYCLS_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PAYCLS_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PAYCLS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAYCLS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAYCLS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAYCLS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PAYCLS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAYCLS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({PAYCLS_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PAYCLS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PAYCLS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAYCLS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({PAYCLS_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PAYCLS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PAYCLS_RowId</SqlRowIdName>
<StreamLocation>^User.CTPayrollClassificationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
