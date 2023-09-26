/// Baby Resuscitation Method(2271)
Class User.PAPrDelBabyResusMthd Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PrDelBabyResusMthd, StorageStrategy = SQLStorage ]
{

/// Childsub
Property PDBRMChildsub As %Float [ InitialExpression = {$i(^PAPRG($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"DEL",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"BABY",$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),"PDBRM",0))}, SqlColumnNumber = 2, SqlFieldName = PDBRM_Childsub ];

/// PA_PregDelBaby Parent Reference
Relationship PDBRMParRef As PAPregDelBaby [ Cardinality = parent, Inverse = ChildPAPrDelBabyResusMthd, Required, SqlFieldName = PDBRM_ParRef ];

/// Des Ref PAC_ResusMethods
Property PDBRMResusMthdDR As PACResusMethods [ SqlColumnNumber = 3, SqlFieldName = PDBRM_ResusMthd_DR ];

/// Sort Order
Property PDBRMSortOrder As %Float [ SqlColumnNumber = 4, SqlFieldName = PDBRM_SortOrder ];

Index RowIDBasedIDKeyIndex On PDBRMChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 3;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAPrDelBabyResusMthd).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelBabyResusMthd","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAPrDelBabyResusMthd).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelBabyResusMthd","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAPrDelBabyResusMthd).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelBabyResusMthd","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAPrDelBabyResusMthd).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelBabyResusMthd","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAPrDelBabyResusMthd).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPrDelBabyResusMthd","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>3</ExtentSize>
<Property name="PDBRMChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="PDBRMParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="PDBRMResusMthdDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="PDBRMSortOrder">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMasterMap">
<Data name="PDBRM_ResusMthd_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDBRM_SortOrder">
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
<Field>PDBRM_Childsub</Field>
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
<Expression>"PDBRM"</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{PDBRM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexResucitation">
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
<Field>PDBRM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PDBRM_ResusMthd_DR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDBRM_ResusMthd_DR}</Expression>
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
<Expression>"PDBRM"</Expression>
</Subscript>
<Subscript name="9">
<Expression>{PDBRM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PDBRM_RowId</SqlRowIdName>
<StreamLocation>^User.PAPrDelBabyResusMthdS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
