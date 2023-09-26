/// MR Extra Observations(1717)
Class User.MRExtraObservations Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_ExtraObservations, StorageStrategy = SQLStorage ]
{

/// Childsub
Property XOBChildsub As %Float [ InitialExpression = {$i(^MR($p(%d(0),$c(1)),"XOB",0))}, SqlColumnNumber = 2, SqlFieldName = XOB_Childsub ];

/// GraphingMarker
Property XOBGraphingMarker As %Float [ SqlColumnNumber = 6, SqlFieldName = XOB_GraphingMarker ];

/// Line Thickness
Property XOBLineThick As %Float [ SqlColumnNumber = 7, SqlFieldName = XOB_LineThick ];

/// Des REf ObsGroup
Property XOBObsGroupDR As MRCObservationGroup [ SqlColumnNumber = 3, SqlFieldName = XOB_ObsGroup_DR ];

/// Des Ref ObsItem
Property XOBObsItemDR As MRCObservationItem [ SqlColumnNumber = 4, SqlFieldName = XOB_ObsItem_DR ];

/// MR_Adm Parent Reference
Relationship XOBParRef As MRAdm [ Cardinality = parent, Inverse = ChildMRExtraObservations, Required, SqlFieldName = XOB_ParRef ];

/// Row Position
Property XOBRowPosition As %Float [ SqlColumnNumber = 5, SqlFieldName = XOB_RowPosition ];

/// Y Axis On Graph
Property XOBYAxisOnGraph As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = XOB_YAxisOnGraph ];

Index RowIDBasedIDKeyIndex On XOBChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRExtraObservations).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRExtraObservations","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRExtraObservations).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRExtraObservations","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRExtraObservations).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRExtraObservations","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRExtraObservations).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRExtraObservations","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRExtraObservations).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRExtraObservations","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="XOB_GraphingMarker">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="XOB_LineThick">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="XOB_ObsGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="XOB_ObsItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="XOB_RowPosition">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="XOB_YAxisOnGraph">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>XOB_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"XOB"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{XOB_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGroup">
<Global>^MR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>XOB_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"XOB"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Grp"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{XOB_ObsGroup_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{XOB_ObsItem_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{XOB_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>XOB_RowId</SqlRowIdName>
<StreamLocation>^User.MRExtraObservationsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
