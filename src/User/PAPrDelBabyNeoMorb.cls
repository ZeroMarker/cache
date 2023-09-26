/// Baby Neonatal Morbidity(2270)
Class User.PAPrDelBabyNeoMorb Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PrDelBabyNeoMorb, StorageStrategy = SQLStorage ]
{

/// Childsub
Property PDBNMChildsub As %Float [ InitialExpression = {$i(^PAPRG($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"DEL",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"BABY",$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),"PDBNM",0))}, SqlColumnNumber = 2, SqlFieldName = PDBNM_Childsub ];

/// Des Ref PAC_NeonatalMorbidity
Property PDBNMMorbidityDR As PACNeonatalMorbidity [ SqlColumnNumber = 3, SqlFieldName = PDBNM_Morbidity_DR ];

/// PA_PregDelBaby Parent Reference
Relationship PDBNMParRef As PAPregDelBaby [ Cardinality = parent, Inverse = ChildPAPrDelBabyNeoMorb, Required, SqlFieldName = PDBNM_ParRef ];

/// Sort Order
Property PDBNMSortOrder As %Float [ SqlColumnNumber = 4, SqlFieldName = PDBNM_SortOrder ];

Index RowIDBasedIDKeyIndex On PDBNMChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 4;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAPrDelBabyNeoMorb).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelBabyNeoMorb","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAPrDelBabyNeoMorb).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelBabyNeoMorb","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAPrDelBabyNeoMorb).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelBabyNeoMorb","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAPrDelBabyNeoMorb).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelBabyNeoMorb","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAPrDelBabyNeoMorb).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelBabyNeoMorb","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>4</ExtentSize>
<Property name="PDBNMChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="PDBNMMorbidityDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="PDBNMParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="PDBNMSortOrder">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMasterMap">
<Data name="PDBNM_Morbidity_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDBNM_SortOrder">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAPRG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PA_PregDelBaby.BABY_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L7}</Expression>
<Field>PDBNM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PA_PregDelBaby.BABY_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>"PDBNM"</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{PDBNM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMorbidity">
<Global>^PAPRGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Pregnancy.PREG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PA_PregDelivery.DEL_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>PA_PregDelBaby.BABY_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L9}</Expression>
<Field>PDBNM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PDBNM_Morbidity_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDBNM_Morbidity_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Pregnancy.PREG_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PregDelivery.DEL_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"BABY"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PA_PregDelBaby.BABY_Childsub}</Expression>
</Subscript>
<Subscript name="8">
<Expression>"PDBNM"</Expression>
</Subscript>
<Subscript name="9">
<Expression>{PDBNM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PDBNM_RowId</SqlRowIdName>
<StreamLocation>^User.PAPrDelBabyNeoMorbS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
