/// RT Mas Vol Admission(1991)
Class User.RTMasVolAdm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RT_MasVolAdm, StorageStrategy = SQLStorage ]
{

/// Childsub
Property ADMChildsub As %Float [ InitialExpression = {$i(^RT($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"RTMAV",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"ADM",0))}, SqlColumnNumber = 2, SqlFieldName = ADM_Childsub ];

/// Des Ref PAADM
Property ADMPAADMDR As PAAdm [ SqlColumnNumber = 3, SqlFieldName = ADM_PAADM_DR ];

/// RT_MasVol Parent Reference
Relationship ADMParRef As RTMasVol [ Cardinality = parent, Inverse = ChildRTMasVolAdm, Required, SqlFieldName = ADM_ParRef ];

Index RowIDBasedIDKeyIndex On ADMChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 7693;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RTMasVolAdm).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RTMasVolAdm","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RTMasVolAdm).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RTMasVolAdm","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RTMasVolAdm).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RTMasVolAdm","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RTMasVolAdm).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RTMasVolAdm","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RTMasVolAdm).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RTMasVolAdm","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>7693</ExtentSize>
<Property name="ADMChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="ADMPAADMDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ADMParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="ADM_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^RT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RT_Master.RTMAS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>RT_MasVol.RTMAV_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>ADM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RT_Master.RTMAS_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RTMAV"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RT_MasVol.RTMAV_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^RT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RT_Master.RTMAS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>RT_MasVol.RTMAV_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>ADM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adm1"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADM_PAADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RT_Master.RTMAS_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RT_MasVol.RTMAV_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ADM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ADM_RowId</SqlRowIdName>
<StreamLocation>^User.RTMasVolAdmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
