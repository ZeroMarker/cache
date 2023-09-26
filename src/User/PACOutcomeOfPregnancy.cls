/// PAC Outcome of pregnancy(1972)
Class User.PACOutcomeOfPregnancy Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_OutcomeOfPregnancy, StorageStrategy = SQLStorage ]
{

/// Code
Property OPREGCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = OPREG_Code ];

/// Description
Property OPREGDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = OPREG_Desc ];

/// National code
Property OPREGNationalCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = OPREG_NationalCode ];

/// Para condition flag
Property OPREGUseForPara As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = OPREG_UseForPara ];

/// Outcome type
Property OPREGOutcomeType As %String(DISPLAYLIST = ",Living Children,Multiple Birth,PretermBirth,Termination of Pregnancy,Therapeutic Abortion/Miscarriage", MAXLEN = 32, TRUNCATE = 1, VALUELIST = ",LC,MB,PB,TP,TAM") [ SqlColumnNumber = 6, SqlFieldName = OPREG_OutcomeType ];

/// Automatic Registration
Property OPREGAutoRegister As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = OPREG_AutoRegister ];

/// Automatic Admission
Property OPREGAutoAdmit As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = OPREG_AutoAdmit ];

/// OutcomeTypeText
Property OPREGOutcomeTypeText As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = OPREG_OutcomeTypeText ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PACOutcomeOfPregnancy).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACOutcomeOfPregnancy","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PACOutcomeOfPregnancy).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACOutcomeOfPregnancy","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PACOutcomeOfPregnancy).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACOutcomeOfPregnancy","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PACOutcomeOfPregnancy).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACOutcomeOfPregnancy","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PACOutcomeOfPregnancy).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACOutcomeOfPregnancy","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACOutcomeOfPregnancy","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("OPREG",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="OPREG_AutoAdmit">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OPREG_AutoRegister">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OPREG_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OPREG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OPREG_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OPREG_OutcomeType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OPREG_OutcomeTypeText">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OPREG_UseForPara">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>OPREG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OPREG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{OPREG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OPREG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OPREG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({OPREG_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OPREG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OPREG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OPREG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({OPREG_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OPREG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>OPREG_RowId</SqlRowIdName>
<StreamLocation>^User.PACOutcomeOfPregnancyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
