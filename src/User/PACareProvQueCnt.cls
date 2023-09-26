/// Care Provider Que Cnt   (CPQC,5017)
Class User.PACareProvQueCnt Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_CareProvQueCnt, StorageStrategy = SQLStorage ]
{

/// Care Provider
Property CPQCCareProviderDR As CTCareProv [ SqlColumnNumber = 3, SqlFieldName = CPQC_CareProviderDR ];

/// Counter
Property CPQCCounter As %Float [ SqlColumnNumber = 2, SqlFieldName = CPQC_Counter ];

/// Date
Property CPQCDate As %Date [ InitialExpression = "T", SqlColumnNumber = 4, SqlFieldName = CPQC_Date ];

Index RowIDBasedIDKeyIndex On (CPQCDate, CPQCCareProviderDR) [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACareProvQueCnt).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACareProvQueCnt","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACareProvQueCnt).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACareProvQueCnt","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACareProvQueCnt).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACareProvQueCnt","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACareProvQueCnt).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACareProvQueCnt","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACareProvQueCnt).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACareProvQueCnt","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaterMap">
<Data name="CPQC_Counter">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAQUE1</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>CPQC_Date</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>CPQC_CareProviderDR</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CNT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CPQC_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CPQC_CareProviderDR}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>CPQC_RowID</SqlRowIdName>
<StreamLocation>^User.PACareProvQueCntS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
