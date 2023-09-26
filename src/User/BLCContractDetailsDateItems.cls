/// BLC Contract Details Date Items1492
Class User.BLCContractDetailsDateItems Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = BLC_ContractDetailsDateItems, StorageStrategy = SQLStorage ]
{

/// Des Ref ARCIM
Property ITMARCIMDR As ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = ITM_ARCIM_DR ];

/// Des Ref ARCOS
Property ITMARCOSDR As ARCOrdSets [ SqlColumnNumber = 6, SqlFieldName = ITM_ARCOS_DR ];

/// Childsub
Property ITMChildsub As %Float [ InitialExpression = {$i(^BLC("CONTR",$p(%d(0),"||"),"DATE",$p(%d(0),"||",2),"ITM",0))}, SqlColumnNumber = 2, SqlFieldName = ITM_Childsub ];

/// Des Ref Department
Property ITMDepartmentDR As CTLoc [ SqlColumnNumber = 5, SqlFieldName = ITM_Department_DR ];

/// Episode Type
Property ITMEpisodeType As %String(DISPLAYLIST = ",InPatient,OutPatient,Emergency,HealthPromotion,NewBorn", MAXLEN = 15, TRUNCATE = 1, VALUELIST = ",I,O,E,H,N") [ SqlColumnNumber = 4, SqlFieldName = ITM_EpisodeType ];

/// BLC_ContractDetailsDate Parent Reference
Relationship ITMParRef As BLCContractDetailsDate [ Cardinality = parent, Inverse = ChildBLCContractDetailsDateItem, Required, SqlFieldName = ITM_ParRef ];

Index RowIDBasedIDKeyIndex On ITMChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.BLCContractDetailsDateItems).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCContractDetailsDateItems","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.BLCContractDetailsDateItems).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCContractDetailsDateItems","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.BLCContractDetailsDateItems).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCContractDetailsDateItems","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.BLCContractDetailsDateItems).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCContractDetailsDateItems","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.BLCContractDetailsDateItems).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCContractDetailsDateItems","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ITM_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ITM_ARCOS_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ITM_Department_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ITM_EpisodeType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^BLC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BLC_ContractDetails.CONTR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>BLC_ContractDetailsDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BLC_ContractDetails.CONTR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BLC_ContractDetailsDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ITM"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ITM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCIM">
<Global>^BLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BLC_ContractDetails.CONTR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>BLC_ContractDetailsDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L9}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BLC_ContractDetails.CONTR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BLC_ContractDetailsDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ITM"</Expression>
</Subscript>
<Subscript name="6">
<Expression>0</Expression>
</Subscript>
<Subscript name="7">
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ITM_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexARCOS">
<Global>^BLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BLC_ContractDetails.CONTR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>BLC_ContractDetailsDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L9}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BLC_ContractDetails.CONTR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BLC_ContractDetailsDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ITM"</Expression>
</Subscript>
<Subscript name="6">
<Expression>0</Expression>
</Subscript>
<Subscript name="7">
<Expression>"ARCOS"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ITM_ARCOS_DR}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDepartEpisARCOS">
<Global>^BLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BLC_ContractDetails.CONTR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>BLC_ContractDetailsDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L11}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BLC_ContractDetails.CONTR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BLC_ContractDetailsDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ITM"</Expression>
</Subscript>
<Subscript name="6">
<Expression>0</Expression>
</Subscript>
<Subscript name="7">
<Expression>"DEP-EPIS-ARCOS"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ITM_Department_DR}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{ITM_EpisodeType}</Expression>
</Subscript>
<Subscript name="10">
<Expression>{ITM_ARCOS_DR}</Expression>
</Subscript>
<Subscript name="11">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDepartEpisArcim">
<Global>^BLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BLC_ContractDetails.CONTR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>BLC_ContractDetailsDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L11}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BLC_ContractDetails.CONTR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BLC_ContractDetailsDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ITM"</Expression>
</Subscript>
<Subscript name="6">
<Expression>0</Expression>
</Subscript>
<Subscript name="7">
<Expression>"DEP-EPIS-ARCIM"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ITM_Department_DR}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{ITM_EpisodeType}</Expression>
</Subscript>
<Subscript name="10">
<Expression>{ITM_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="11">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDepartmentARCIM">
<Global>^BLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BLC_ContractDetails.CONTR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>BLC_ContractDetailsDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L10}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BLC_ContractDetails.CONTR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BLC_ContractDetailsDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ITM"</Expression>
</Subscript>
<Subscript name="6">
<Expression>0</Expression>
</Subscript>
<Subscript name="7">
<Expression>"DEP-ARCIM"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ITM_Department_DR}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{ITM_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="10">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDepartmentARCOS">
<Global>^BLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BLC_ContractDetails.CONTR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>BLC_ContractDetailsDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L10}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BLC_ContractDetails.CONTR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BLC_ContractDetailsDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ITM"</Expression>
</Subscript>
<Subscript name="6">
<Expression>0</Expression>
</Subscript>
<Subscript name="7">
<Expression>"DEP-ARCOS"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ITM_Department_DR}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{ITM_ARCOS_DR}</Expression>
</Subscript>
<Subscript name="10">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEpisTypeARCIM">
<Global>^BLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BLC_ContractDetails.CONTR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>BLC_ContractDetailsDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L10}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BLC_ContractDetails.CONTR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BLC_ContractDetailsDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ITM"</Expression>
</Subscript>
<Subscript name="6">
<Expression>0</Expression>
</Subscript>
<Subscript name="7">
<Expression>"EPIS-ARCIM"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ITM_EpisodeType}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{ITM_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="10">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEpisTypeARCOS">
<Global>^BLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BLC_ContractDetails.CONTR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>BLC_ContractDetailsDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L10}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONTR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BLC_ContractDetails.CONTR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BLC_ContractDetailsDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ITM"</Expression>
</Subscript>
<Subscript name="6">
<Expression>0</Expression>
</Subscript>
<Subscript name="7">
<Expression>"EPIS-ARCOS"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ITM_EpisodeType}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{ITM_ARCOS_DR}</Expression>
</Subscript>
<Subscript name="10">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ITM_RowId</SqlRowIdName>
<StreamLocation>^User.BLCContractDetailsDateIteS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
