/// ARC Item Diet Modifier(2010)
Class User.ARCItemDietModifier Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_ItemDietModifier, StorageStrategy = SQLStorage ]
{

/// Childsub
Property DMChildsub As %Float [ InitialExpression = {$i(^ARCIM($p($s($d(initvalue):initvalue,1:%d(0)),"||"),$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"DT",0))}, SqlColumnNumber = 2, SqlFieldName = DM_Childsub ];

/// Default
Property DMDefault As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = DM_Default ];

/// Des Ref Modifier
Property DMModifierDR As DTCModifier [ SqlColumnNumber = 3, SqlFieldName = DM_Modifier_DR ];

/// ARC_ItmMast Parent Reference
Relationship DMParRef As ARCItmMast [ Cardinality = parent, Inverse = ChildARCItemDietModifier, Required, SqlFieldName = DM_ParRef ];

Index RowIDBasedIDKeyIndex On DMChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 35;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCItemDietModifier).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemDietModifier","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCItemDietModifier).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemDietModifier","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCItemDietModifier).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemDietModifier","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCItemDietModifier).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemDietModifier","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCItemDietModifier).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemDietModifier","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>35</ExtentSize>
<Property name="DMChildsub">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="DMDefault">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DMModifierDR">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="DMParRef">
<Selectivity>8.3333%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="DM_Default">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DM_Modifier_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^ARCIM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_ItmMast.ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>ARC_ItmMast.ARCIM_Version</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L4}</Expression>
<Field>DM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DM"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DM_RowId</SqlRowIdName>
<StreamLocation>^User.ARCItemDietModifierS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
