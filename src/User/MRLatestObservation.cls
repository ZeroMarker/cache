/// Latest Observation(2247)
Class User.MRLatestObservation Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_LatestObservation, StorageStrategy = SQLStorage ]
{

/// Childsub
Property LOBSChildsub As %Float [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"LOBS",0))}, SqlColumnNumber = 2, SqlFieldName = LOBS_Childsub ];

/// Des Ref MRObsItem_
Property LOBSMRObsItemDR As MRObservations [ SqlColumnNumber = 4, SqlFieldName = LOBS_MRObsItem_DR ];

/// Des Ref ObsItem
Property LOBSObsItemDR As MRCObservationItem [ SqlColumnNumber = 3, SqlFieldName = LOBS_ObsItem_DR ];

/// MR_Adm Parent Reference
Relationship LOBSParRef As MRAdm [ Cardinality = parent, Inverse = ChildMRLatestObservation, Required, SqlFieldName = LOBS_ParRef ];

/// Value
Property LOBSValue As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = LOBS_Value ];

Index RowIDBasedIDKeyIndex On LOBSChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 118;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRLatestObservation).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRLatestObservation","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRLatestObservation).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRLatestObservation","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRLatestObservation).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRLatestObservation","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRLatestObservation).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRLatestObservation","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRLatestObservation).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRLatestObservation","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>118</ExtentSize>
<Property name="LOBSChildsub">
<Selectivity>4.7619%</Selectivity>
</Property>
<Property name="LOBSMRObsItemDR">
<Selectivity>0.9804%</Selectivity>
</Property>
<Property name="LOBSObsItemDR">
<Selectivity>4.1667%</Selectivity>
</Property>
<Property name="LOBSParRef">
<Selectivity>8.3333%</Selectivity>
</Property>
<Property name="LOBSValue">
<Selectivity>2.6316%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="LOBS_MRObsItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LOBS_ObsItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LOBS_Value">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>LOBS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOBS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LOBS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexItem">
<Global>^MR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>LOBS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOBS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Item"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LOBS_ObsItem_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LOBS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LOBS_RowId</SqlRowIdName>
<StreamLocation>^User.MRLatestObservationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
