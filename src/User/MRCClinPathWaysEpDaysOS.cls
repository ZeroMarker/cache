/// MRC ClinPathwEpDaysOS(1767)
Class User.MRCClinPathWaysEpDaysOS Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_ClinPathWaysEpDaysOS, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On OSChildsub [ IdKey, PrimaryKey, Unique ];

/// MRC_ClinPathwEpDays Parent Reference
Relationship OSParRef As MRCClinPathwEpDays [ Cardinality = parent, Inverse = ChildMRCClinPathWaysEpDaysOS, Required, SqlFieldName = OS_ParRef ];

/// Childsub
Property OSChildsub As %Float [ InitialExpression = {$i(^MRC("CPW",$p($s($d(initvalue):initvalue,1:%d(0)),"||"),"EP",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"DAYS",$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),"OS",0))}, SqlColumnNumber = 2, SqlFieldName = OS_Childsub ];

/// Des Ref OrdSet
Property OSOrdSetDR As ARCOrdSets [ SqlColumnNumber = 3, SqlFieldName = OS_OrdSet_DR ];

/// Des Ref ARCIM
Property OSARCIMDR As ARCItmMast [ SqlColumnNumber = 4, SqlFieldName = OS_ARCIM_DR ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.MRCClinPathWaysEpDaysOS).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCClinPathWaysEpDaysOS","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.MRCClinPathWaysEpDaysOS).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCClinPathWaysEpDaysOS","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.MRCClinPathWaysEpDaysOS).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCClinPathWaysEpDaysOS","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.MRCClinPathWaysEpDaysOS).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCClinPathWaysEpDaysOS","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.MRCClinPathWaysEpDaysOS).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCClinPathWaysEpDaysOS","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCClinPathWaysEpDaysOS","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>59</ExtentSize>
<Property name="OSARCIMDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="OSChildsub">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="OSOrdSetDR">
<Selectivity>2.3810%</Selectivity>
</Property>
<Property name="OSParRef">
<Selectivity>2.0408%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="OS_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OS_OrdSet_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MRC_ClinicalPathways.CPW_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>MRC_ClinPathwaysEpisodes.EP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>MRC_ClinPathwEpDays.DAYS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L8}</Expression>
<Field>OS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CPW"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRC_ClinicalPathways.CPW_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"EP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MRC_ClinPathwaysEpisodes.EP_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"DAYS"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MRC_ClinPathwEpDays.DAYS_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>"OS"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{OS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCIM">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MRC_ClinicalPathways.CPW_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>MRC_ClinPathwaysEpisodes.EP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>MRC_ClinPathwEpDays.DAYS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L11}</Expression>
<Field>OS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CPW"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRC_ClinicalPathways.CPW_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"EP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MRC_ClinPathwaysEpisodes.EP_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"DAYS"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MRC_ClinPathwEpDays.DAYS_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>"OS"</Expression>
</Subscript>
<Subscript name="8">
<Expression>0</Expression>
</Subscript>
<Subscript name="9">
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="10">
<Expression>{OS_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="11">
<Expression>{OS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOS">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MRC_ClinicalPathways.CPW_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>MRC_ClinPathwaysEpisodes.EP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>MRC_ClinPathwEpDays.DAYS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L11}</Expression>
<Field>OS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CPW"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRC_ClinicalPathways.CPW_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"EP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MRC_ClinPathwaysEpisodes.EP_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"DAYS"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MRC_ClinPathwEpDays.DAYS_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>"OS"</Expression>
</Subscript>
<Subscript name="8">
<Expression>0</Expression>
</Subscript>
<Subscript name="9">
<Expression>"Set"</Expression>
</Subscript>
<Subscript name="10">
<Expression>{OS_OrdSet_DR}</Expression>
</Subscript>
<Subscript name="11">
<Expression>{OS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>OS_RowId</SqlRowIdName>
<StreamLocation>^User.MRCClinPathWaysEpDaysOSS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
