/// GLC Account             (GLCAC,226)
Class User.GLCAcct Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = GLC_Acct, StorageStrategy = SQLStorage ]
{

/// Budget Flag For Cash Management
Property GLCACBudFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = GLCAC_BudFlag ];

/// Account Class
Property GLCACClass As %String(DISPLAYLIST = ",D - Detail Account,C - Control Account", MAXLEN = 19, TRUNCATE = 1, VALUELIST = ",D,C") [ SqlColumnNumber = 6, SqlFieldName = GLCAC_Class ];

/// Des Ref to CTCO
Property GLCACCoCodeDR As CTCompany [ SqlColumnNumber = 3, SqlFieldName = GLCAC_CoCode_DR ];

/// Account Code
Property GLCACCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = GLCAC_Code ];

/// Description
Property GLCACDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = GLCAC_Desc ];

/// Archived Flag
Property GLCACRcFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = {N}, SqlColumnNumber = 8, SqlFieldName = GLCAC_RcFlag ];

/// Account Type
Property GLCACType As %String(DISPLAYLIST = ",A - Assets,L - Liabilities,E - Expenses,R - Revenues,C - Capital", MAXLEN = 15, TRUNCATE = 1, VALUELIST = ",A,L,E,R,C") [ SqlColumnNumber = 5, SqlFieldName = GLCAC_Type ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.GLCAcct).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.GLCAcct","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.GLCAcct).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.GLCAcct","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.GLCAcct).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.GLCAcct","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.GLCAcct).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.GLCAcct","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.GLCAcct).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.GLCAcct","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^GLC("GLCAC",0))</SqlIdExpression>
<SQLMap name="GLCACDataMasterMap">
<Data name="GLCAC_BudFlag">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GLCAC_Class">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GLCAC_CoCode_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GLCAC_Code">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="GLCAC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="GLCAC_RcFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="GLCAC_Type">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^GLC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>GLCAC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"GLCAC"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{GLCAC_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="GLCACIndexGLCACCode">
<Data name="GLCAC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^GLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>GLCAC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"GLCAC"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"GLCAC_Code"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({GLCAC_Code})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{GLCAC_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="GLCACIndexGLCACDesc">
<Data name="GLCAC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^GLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>GLCAC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"GLCAC"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"GLCAC_Desc"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({GLCAC_Desc})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{GLCAC_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>GLCAC_RowId</SqlRowIdName>
<StreamLocation>^User.GLCAcctS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
