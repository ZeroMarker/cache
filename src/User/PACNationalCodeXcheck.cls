/// PAC National Code X check(2040)
Class User.PACNationalCodeXcheck Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_NationalCodeXcheck, StorageStrategy = SQLStorage ]
{

/// Additional ValidationXCHECK_A
Property XCHECKAddVal As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = XCHECK_AddVal ];

/// Code Type
Property XCHECKCodeType As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = XCHECK_CodeType ];

/// Value
Property XCHECKValue As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = XCHECK_Value ];

Parameter EXTENTSIZE = 126;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACNationalCodeXcheck).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACNationalCodeXcheck","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACNationalCodeXcheck).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACNationalCodeXcheck","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACNationalCodeXcheck).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACNationalCodeXcheck","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACNationalCodeXcheck).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACNationalCodeXcheck","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACNationalCodeXcheck).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACNationalCodeXcheck","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>126</ExtentSize>
<Property name="XCHECKAddVal">
<Selectivity>1</Selectivity>
</Property>
<Property name="XCHECKCodeType">
<Selectivity>1</Selectivity>
</Property>
<Property name="XCHECKValue">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("XCHECK",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="XCHECK_AddVal">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="XCHECK_CodeType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="XCHECK_Value">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>XCHECK_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"XCHECK"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{XCHECK_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>XCHECK_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"XCHECK"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({XCHECK_CodeType})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{XCHECK_Value}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{XCHECK_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>XCHECK_RowId</SqlRowIdName>
<StreamLocation>^User.PACNationalCodeXcheckS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
