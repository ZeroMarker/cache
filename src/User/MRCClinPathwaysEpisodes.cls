/// MRC Clin PathwEpisodes(1764)
Class User.MRCClinPathwaysEpisodes Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_ClinPathwaysEpisodes, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On EPChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildMRCClinPathwEpDays As MRCClinPathwEpDays [ Cardinality = children, Inverse = DAYSParRef ];

/// MRC_ClinicalPathways Parent Reference
Relationship EPParRef As MRCClinicalPathways [ Cardinality = parent, Inverse = ChildMRCClinPathwaysEpisodes, Required, SqlFieldName = EP_ParRef ];

/// Childsub
Property EPChildsub As %Float [ InitialExpression = {$i(^MRC("CPW",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"EP",0))}, SqlColumnNumber = 2, SqlFieldName = EP_Childsub ];

/// Episode
Property EPEpisode As %Float [ SqlColumnNumber = 3, SqlFieldName = EP_Episode ];

/// Description
Property EPDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = EP_Desc ];

/// CycleOffsetDays
Property EPCycleOffsetDays As %Float [ SqlColumnNumber = 5, SqlFieldName = EP_CycleOffsetDays ];

/// TotalDays
Property EPTotalDays As %Float [ SqlColumnNumber = 6, SqlFieldName = EP_TotalDays ];

/// IP Episode Required
Property EPIPEpisodeRequired As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = EP_IPEpisodeRequired ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.MRCClinPathwaysEpisodes).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCClinPathwaysEpisodes","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.MRCClinPathwaysEpisodes).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCClinPathwaysEpisodes","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.MRCClinPathwaysEpisodes).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCClinPathwaysEpisodes","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.MRCClinPathwaysEpisodes).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCClinPathwaysEpisodes","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.MRCClinPathwaysEpisodes).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCClinPathwaysEpisodes","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCClinPathwaysEpisodes","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>31</ExtentSize>
<Property name="EPChildsub">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="EPCycleOffsetDays">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="EPDesc">
<Selectivity>5.2632%</Selectivity>
</Property>
<Property name="EPEpisode">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="EPIPEpisodeRequired">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="EPParRef">
<Selectivity>5.5556%</Selectivity>
</Property>
<Property name="EPTotalDays">
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="EP_CycleOffsetDays">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EP_Episode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EP_IPEpisodeRequired">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EP_TotalDays">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MRC_ClinicalPathways.CPW_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>EP_Childsub</Field>
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
<Expression>{EP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEpisode">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MRC_ClinicalPathways.CPW_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>EP_Childsub</Field>
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
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Epis"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{EP_Episode}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{EP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>EP_RowId</SqlRowIdName>
<StreamLocation>^User.MRCClinPathwaysEpisodesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
