/// PA Adm Process(1457)
Class User.PAProcess Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_Process, StorageStrategy = SQLStorage ]
{

/// Billed
Property PRBilled As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = PR_Billed ];

/// Des Ref DRG
Property PRDRGDR As MRCDRGCodes [ SqlColumnNumber = 3, SqlFieldName = PR_DRG_DR ];

/// Date of Creation
Property PRDateCreation As %Date [ SqlColumnNumber = 7, SqlFieldName = PR_DateCreation ];

/// Process Number
Property PRNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = PR_No ];

/// Status
Property PRStatus As %String(DISPLAYLIST = ",Open,Close", MAXLEN = 5, TRUNCATE = 1, VALUELIST = ",O,C") [ SqlColumnNumber = 4, SqlFieldName = PR_Status ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAProcess).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAProcess","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAProcess).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAProcess","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAProcess).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAProcess","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAProcess).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAProcess","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAProcess).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAProcess","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="PRBilled">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="PRDRGDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="PRDateCreation">
<Selectivity>1</Selectivity>
</Property>
<Property name="PRNo">
<Selectivity>1</Selectivity>
</Property>
<Property name="PRStatus">
<Selectivity>33.3333%</Selectivity>
</Property>
<SqlIdExpression>$i(^PAPR(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PR_Billed">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PR_DRG_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PR_DateCreation">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PR_No">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PR_Status">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAPR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDRG">
<Global>^PAPRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DRG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PR_DRG_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^PAPRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PR_DateCreation}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNumber">
<Global>^PAPRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"No"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({PR_No})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PR_RowId</SqlRowIdName>
<StreamLocation>^User.PAProcessS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
