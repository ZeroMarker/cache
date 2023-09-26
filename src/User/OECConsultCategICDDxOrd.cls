/// ConsultCategICDDxOrd(2700)
Class User.OECConsultCategICDDxOrd Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OEC_ConsultCategICDDxOrd, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 1;

Index RowIDBasedIDKeyIndex On ITMChildsub [ IdKey, PrimaryKey, Unique ];

/// OEC_ConsultCateg Parent Reference
Relationship ITMParRef As OECConsultCateg [ Cardinality = parent, Inverse = ChildOECConsultCategICDDxOrd, Required, SqlFieldName = ITM_ParRef ];

/// Childsub
Property ITMChildsub As %Float [ InitialExpression = {$i(^OEC("CONS",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"DXORD",0))}, SqlColumnNumber = 2, SqlFieldName = ITM_Childsub ];

/// Des Ref ARCIM1
Property ITMARCIM1DR As ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = ITM_ARCIM1_DR ];

/// Des Ref ARCIM2
Property ITMARCIM2DR As ARCItmMast [ SqlColumnNumber = 4, SqlFieldName = ITM_ARCIM2_DR ];

/// Des Ref ARCIM3
Property ITMARCIM3DR As ARCItmMast [ SqlColumnNumber = 5, SqlFieldName = ITM_ARCIM3_DR ];

/// Des Ref ARCIM4
Property ITMARCIM4DR As ARCItmMast [ SqlColumnNumber = 6, SqlFieldName = ITM_ARCIM4_DR ];

/// Des Ref ARCOS
Property ITMARCOSDR As ARCOrdSets [ SqlColumnNumber = 7, SqlFieldName = ITM_ARCOS_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OECConsultCategICDDxOrd).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECConsultCategICDDxOrd","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OECConsultCategICDDxOrd).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECConsultCategICDDxOrd","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OECConsultCategICDDxOrd).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECConsultCategICDDxOrd","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OECConsultCategICDDxOrd).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECConsultCategICDDxOrd","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OECConsultCategICDDxOrd).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECConsultCategICDDxOrd","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="ITMARCIM1DR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ITMARCIM2DR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ITMARCIM3DR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ITMARCIM4DR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ITMARCOSDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ITMChildsub">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ITMParRef">
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="ITM_ARCIM1_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ITM_ARCIM2_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ITM_ARCIM3_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ITM_ARCIM4_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ITM_ARCOS_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^OEC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>OEC_ConsultCateg.CONS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{OEC_ConsultCateg.CONS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DXORD"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ITM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCIM1">
<Global>^OEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>OEC_ConsultCateg.CONS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{OEC_ConsultCateg.CONS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DXORD"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ARCIM1"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ITM_ARCIM1_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexARCIM2">
<Global>^OEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>OEC_ConsultCateg.CONS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{OEC_ConsultCateg.CONS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DXORD"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ARCIM2"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ITM_ARCIM2_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexARCIM3">
<Global>^OEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>OEC_ConsultCateg.CONS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{OEC_ConsultCateg.CONS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DXORD"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ARCIM3"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ITM_ARCIM3_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexARCIM4">
<Global>^OEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>OEC_ConsultCateg.CONS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{OEC_ConsultCateg.CONS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DXORD"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ARCIM4"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ITM_ARCIM4_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexARCOS">
<Global>^OEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>OEC_ConsultCateg.CONS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{OEC_ConsultCateg.CONS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DXORD"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ARCOS"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ITM_ARCOS_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ITM_RowId</SqlRowIdName>
<StreamLocation>^User.OECConsultCategICDDxOrdS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
