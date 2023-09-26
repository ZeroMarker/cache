/// SS Audit Rules(1726)
Class User.SSAuditRules Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_AuditRules, StorageStrategy = SQLStorage ]
{

/// Track Delete
Property AUDRDelete As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = AUDR_Delete ];

/// Track Insert
Property AUDRInsert As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = AUDR_Insert ];

/// Des Ref SSTable
Property AUDRSSTableDR As SSTable [ SqlColumnNumber = 2, SqlFieldName = AUDR_SSTable_DR ];

/// Table Name
Property AUDRTableName As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = AUDR_TableName ];

/// Track Update
Property AUDRUpdate As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = AUDR_Update ];

Parameter EXTENTSIZE = 35;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSAuditRules).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSAuditRules","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSAuditRules).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSAuditRules","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSAuditRules).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSAuditRules","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSAuditRules).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSAuditRules","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSAuditRules).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSAuditRules","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>35</ExtentSize>
<Property name="AUDRDelete">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="AUDRInsert">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="AUDRSSTableDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="AUDRTableName">
<Selectivity>1</Selectivity>
</Property>
<Property name="AUDRUpdate">
<Selectivity>33.3333%</Selectivity>
</Property>
<SqlIdExpression>$i(^CT("AUDR",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AUDR_Delete">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AUDR_Insert">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AUDR_SSTable_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AUDR_TableName">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AUDR_Update">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>AUDR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"AUDR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{AUDR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTable">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AUDR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"AUDR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Table"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AUDR_SSTable_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AUDR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTableName">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AUDR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"AUDR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"TableName"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({AUDR_TableName})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AUDR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>AUDR_RowId</SqlRowIdName>
<StreamLocation>^User.SSAuditRulesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
