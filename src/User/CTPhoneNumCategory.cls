/// CT Phone Num Category(2031)
Class User.CTPhoneNumCategory Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_PhoneNumCategory, StorageStrategy = SQLStorage ]
{

/// Code
Property PHNCCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = PHNC_Code ];

/// Description
Property PHNCDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PHNC_Desc ];

Index PHNCCodeUnqIdx1 On PHNCCode [ Unique ];

Parameter EXTENTSIZE = 2;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTPhoneNumCategory).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTPhoneNumCategory","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTPhoneNumCategory).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTPhoneNumCategory","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTPhoneNumCategory).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTPhoneNumCategory","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTPhoneNumCategory).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTPhoneNumCategory","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTPhoneNumCategory).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTPhoneNumCategory","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>2</ExtentSize>
<Property name="PHNCCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="PHNCDesc">
<Selectivity>50.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^CT("PHNC",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHNC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHNC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHNC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PHNC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHNC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHNC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PHNC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({PHNC_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHNC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHNC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PHNC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({PHNC_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHNC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PHNC_RowId</SqlRowIdName>
<StreamLocation>^User.CTPhoneNumCategoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
