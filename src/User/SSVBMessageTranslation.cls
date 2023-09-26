/// SS VB Message Translation(1689)
Class User.SSVBMessageTranslation Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_VBMessageTranslation, StorageStrategy = SQLStorage ]
{

/// Code
Property TRANSCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = TRANS_Code ];

/// Description
Property TRANSDesc As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = TRANS_Desc ];

/// Des Ref Language
Property TRANSLanguageDR As SSLanguage [ SqlColumnNumber = 2, SqlFieldName = TRANS_Language_DR ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSVBMessageTranslation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSVBMessageTranslation","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSVBMessageTranslation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSVBMessageTranslation","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSVBMessageTranslation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSVBMessageTranslation","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSVBMessageTranslation).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSVBMessageTranslation","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSVBMessageTranslation).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSVBMessageTranslation","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="TRANSCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRANSDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRANSLanguageDR">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^SSLAN("TRANS",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="TRANS_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TRANS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TRANS_Language_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^SSLAN</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>TRANS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TRANS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{TRANS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Data name="TRANS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^SSLAN</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>TRANS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TRANS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TRANS_Language_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({TRANS_Code})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TRANS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^SSLAN</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>TRANS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TRANS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TRANS_Language_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TRANS_Desc}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TRANS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TRANS_RowId</SqlRowIdName>
<StreamLocation>^User.SSVBMessageTranslationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
