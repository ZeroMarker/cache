/// Review Configuration(1463)
Class User.CFRVI Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CF_RVI, StorageStrategy = SQLStorage ]
{

/// Previous Claim
Property RVIPreviousClaim As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 2, SqlFieldName = RVI_PreviousClaim ];

/// CF_RVI Row ID
Property RVIRowId As %Float [ InitialExpression = 1, Required, SqlFieldName = RVI_RowId ];

Index RowIDBasedIDKeyIndex On RVIRowId [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CFRVI).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CFRVI","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CFRVI).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CFRVI","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CFRVI).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CFRVI","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CFRVI).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CFRVI","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CFRVI).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CFRVI","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>1</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RVI_PreviousClaim">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^CF</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RVI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RVI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RVI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RVI_RowId</SqlRowIdName>
<StreamLocation>^User.CFRVIS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
