/// CT Phone Nums(2032)
Class User.CTPhoneNums Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_PhoneNums, StorageStrategy = SQLStorage ]
{

/// Des Ref Category
Property PHNUMCategoryDR As CTPhoneNumCategory [ SqlColumnNumber = 4, SqlFieldName = PHNUM_Category_DR ];

/// Code
Property PHNUMCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = PHNUM_Code ];

/// Description
Property PHNUMDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PHNUM_Desc ];

Index PHNUMCodeUnqIdx1 On PHNUMCode [ Unique ];

Parameter EXTENTSIZE = 5;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTPhoneNums).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTPhoneNums","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTPhoneNums).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTPhoneNums","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTPhoneNums).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTPhoneNums","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTPhoneNums).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTPhoneNums","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTPhoneNums).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTPhoneNums","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>5</ExtentSize>
<Property name="PHNUMCategoryDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PHNUMCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="PHNUMDesc">
<Selectivity>20.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^CT("PHNUM",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHNUM_Category_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHNUM_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHNUM_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHNUM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PHNUM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHNUM_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHNUM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PHNUM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({PHNUM_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHNUM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHNUM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PHNUM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({PHNUM_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHNUM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PHNUM_RowId</SqlRowIdName>
<StreamLocation>^User.CTPhoneNumsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
