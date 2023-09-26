/// MRC Clin PathwEp Days(1765)
Class User.MRCClinPathwEpDays Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_ClinPathwEpDays, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DAYSChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildMRCClinPathWaysEpDaysOS As MRCClinPathWaysEpDaysOS [ Cardinality = children, Inverse = OSParRef ];

/// MRC_ClinPathwaysEpisodes Parent Reference
Relationship DAYSParRef As MRCClinPathwaysEpisodes [ Cardinality = parent, Inverse = ChildMRCClinPathwEpDays, Required, SqlFieldName = DAYS_ParRef ];

/// Childsub
Property DAYSChildsub As %Float [ InitialExpression = {$i(^MRC("CPW",$p($s($d(initvalue):initvalue,1:%d(0)),"||"),"EP",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"DAYS",0))}, SqlColumnNumber = 2, SqlFieldName = DAYS_Childsub ];

/// Day
Property DAYSDay As %Float [ SqlColumnNumber = 3, SqlFieldName = DAYS_Day ];

/// Notes
Property DAYSNotes As list Of %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DAYS_Notes, SqlListType = subnode ];

/// Description
Property DAYSDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DAYS_Desc ];

/// Day Number
Property DAYSDayNumber As %Float [ SqlColumnNumber = 6, SqlFieldName = DAYS_DayNumber ];

/// Des Ref Service
Property DAYSServiceDR As RBCServices [ SqlColumnNumber = 7, SqlFieldName = DAYS_Service_DR ];

/// Des Ref RBResource
Property DAYSRBResourceDR As RBResource [ SqlColumnNumber = 8, SqlFieldName = DAYS_RBResource_DR ];

/// Des Ref CTLOC
Property DAYSCTLOCDR As CTLoc [ SqlColumnNumber = 9, SqlFieldName = DAYS_CTLOC_DR ];

/// IPEpisodeRequired
Property DAYSIPEpisodeRequired As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = DAYS_IPEpisodeRequired ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.MRCClinPathwEpDays).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCClinPathwEpDays","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.MRCClinPathwEpDays).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCClinPathwEpDays","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.MRCClinPathwEpDays).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCClinPathwEpDays","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.MRCClinPathwEpDays).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCClinPathwEpDays","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.MRCClinPathwEpDays).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCClinPathwEpDays","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCClinPathwEpDays","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>124</ExtentSize>
<Property name="DAYSCTLOCDR">
<Selectivity>7.6923%</Selectivity>
</Property>
<Property name="DAYSChildsub">
<Selectivity>1.9608%</Selectivity>
</Property>
<Property name="DAYSDay">
<Selectivity>2.7778%</Selectivity>
</Property>
<Property name="DAYSDayNumber">
<Selectivity>9.0909%</Selectivity>
</Property>
<Property name="DAYSDesc">
<Selectivity>4.0000%</Selectivity>
</Property>
<Property name="DAYSIPEpisodeRequired">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DAYSNotes">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="DAYSParRef">
<Selectivity>4.1667%</Selectivity>
</Property>
<Property name="DAYSRBResourceDR">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="DAYSServiceDR">
<Selectivity>7.1429%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="DAYS_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DAYS_Day">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DAYS_DayNumber">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DAYS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DAYS_IPEpisodeRequired">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DAYS_Notes">
<Node>"NOTES"</Node>
</Data>
<Data name="DAYS_RBResource_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DAYS_Service_DR">
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
<Field>MRC_ClinPathwaysEpisodes.EP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>DAYS_Childsub</Field>
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
<Expression>{DAYS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDay">
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
<Expression>{L9}</Expression>
<Field>DAYS_Childsub</Field>
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
<Expression>0</Expression>
</Subscript>
<Subscript name="7">
<Expression>"Days"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{DAYS_Day}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{DAYS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DAYS_RowId</SqlRowIdName>
<StreamLocation>^User.MRCClinPathwEpDaysS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
