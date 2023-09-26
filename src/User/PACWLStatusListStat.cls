/// WLStatusListStat(2334)
Class User.PACWLStatusListStat Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_WLStatusListStat, StorageStrategy = SQLStorage ]
{

/// Childsub
Property STATChildsub As %Float [ InitialExpression = {$i(^PAC("WLSL",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"STAT",0))}, SqlColumnNumber = 2, SqlFieldName = STAT_Childsub ];

/// PAC_WLStatusList Parent Reference
Relationship STATParRef As PACWLStatusList [ Cardinality = parent, Inverse = ChildPACWLStatusListStat, Required, SqlFieldName = STAT_ParRef ];

/// Des Ref WLStatus
Property STATWLStatusDR As PACWaitingListStatus [ SqlColumnNumber = 3, SqlFieldName = STAT_WLStatus_DR ];

Index RowIDBasedIDKeyIndex On STATChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 2;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACWLStatusListStat).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWLStatusListStat","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACWLStatusListStat).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWLStatusListStat","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACWLStatusListStat).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWLStatusListStat","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACWLStatusListStat).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWLStatusListStat","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACWLStatusListStat).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWLStatusListStat","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>2</ExtentSize>
<Property name="STATChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="STATParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="STATWLStatusDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="STAT_WLStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_WLStatusList.WLSL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>STAT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WLSL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_WLStatusList.WLSL_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"STAT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{STAT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexStat">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_WLStatusList.WLSL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>STAT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WLSL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_WLStatusList.WLSL_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"STAT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Stat"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{STAT_WLStatus_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{STAT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>STAT_RowId</SqlRowIdName>
<StreamLocation>^User.PACWLStatusListStatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
