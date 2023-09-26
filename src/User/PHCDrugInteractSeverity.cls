/// DrugInteractSeverity(2609)
Class User.PHCDrugInteractSeverity Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PHC_DrugInteractSeverity, StorageStrategy = SQLStorage ]
{

/// Code
Property DRGINTSCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DRGINTS_Code ];

/// Description
Property DRGINTSDesc As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DRGINTS_Desc ];

/// Color
Property DRGINTSColor As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DRGINTS_Color ];

/// DateFrom
Property DRGINTSDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = DRGINTS_DateFrom ];

/// DateTo
Property DRGINTSDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = DRGINTS_DateTo ];

/// Priority
Property DRGINTSPriority As %Float [ SqlColumnNumber = 7, SqlFieldName = DRGINTS_Priority ];

/// MandatoryOverride
Property DRGINTSMandatoryOverride As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = DRGINTS_MandatoryOverride ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PHCDrugInteractSeverity).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCDrugInteractSeverity","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PHCDrugInteractSeverity).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCDrugInteractSeverity","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PHCDrugInteractSeverity).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCDrugInteractSeverity","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PHCDrugInteractSeverity).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCDrugInteractSeverity","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PHCDrugInteractSeverity).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCDrugInteractSeverity","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PHC("DRGINTS",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DRGINTS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRGINTS_Color">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DRGINTS_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DRGINTS_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DRGINTS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DRGINTS_MandatoryOverride">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DRGINTS_Priority">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^PHC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DRGINTS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DRGINTS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRGINTS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PHC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DRGINTS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DRGINTS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({DRGINTS_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DRGINTS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PHC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DRGINTS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DRGINTS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({DRGINTS_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DRGINTS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DRGINTS_RowId</SqlRowIdName>
<StreamLocation>^User.PHCDrugInteractSeverityS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
