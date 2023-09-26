/// Rec. Location to print Presc(1449)
Class User.CFOEConfigRecieveLocPrint Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CF_OEConfig_RecieveLocPrint, StorageStrategy = SQLStorage ]
{

/// Des Ref CTLOC
Property LOCCTLOCDR As CTLoc [ SqlColumnNumber = 3, SqlFieldName = LOC_CTLOC_DR ];

/// Childsub
Property LOCChildsub As %Float [ InitialExpression = {$i(^CF("OE",$p(%d(0),$c(1)),"LOC",0))}, SqlColumnNumber = 2, SqlFieldName = LOC_Childsub ];

/// CF_OEConfig Parent Reference
Relationship LOCParRef As CFOEConfig [ Cardinality = parent, Inverse = ChildCFOEConfigRecieveLocPrint, Required, SqlFieldName = LOC_ParRef ];

Index RowIDBasedIDKeyIndex On LOCChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CFOEConfigRecieveLocPrint).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CFOEConfigRecieveLocPrint","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CFOEConfigRecieveLocPrint).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CFOEConfigRecieveLocPrint","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CFOEConfigRecieveLocPrint).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CFOEConfigRecieveLocPrint","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CFOEConfigRecieveLocPrint).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CFOEConfigRecieveLocPrint","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CFOEConfigRecieveLocPrint).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CFOEConfigRecieveLocPrint","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="LOC_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^CF</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CF_OEConfig.OECF_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>LOC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CF_OEConfig.OECF_RowID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LOC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^CF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CF_OEConfig.OECF_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>LOC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CF_OEConfig.OECF_RowID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LOC_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LOC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LOC_RowId</SqlRowIdName>
<StreamLocation>^User.CFOEConfigRecieveLocPrintS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
