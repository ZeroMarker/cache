/// Observation Notes(2352)
Class User.MRObservationNotes Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_ObservationNotes, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On OBSNChildsub [ IdKey, PrimaryKey, Unique ];

/// MR_Adm Parent Reference
Relationship OBSNParRef As MRAdm [ Cardinality = parent, Inverse = ChildMRObservationNotes, Required, SqlFieldName = OBSN_ParRef ];

/// Childsub
Property OBSNChildsub As %Float [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"OBSN",0))}, SqlColumnNumber = 2, SqlFieldName = OBSN_Childsub ];

/// Date
Property OBSNDate As %Date [ SqlColumnNumber = 3, SqlFieldName = OBSN_Date ];

/// Time
Property OBSNTime As %Time [ SqlColumnNumber = 4, SqlFieldName = OBSN_Time ];

/// Notes
Property OBSNNotes As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = OBSN_Notes, SqlListType = subnode ];

/// LastUpdateDate
Property OBSNLastUpdateDate As %Date [ SqlColumnNumber = 6, SqlFieldName = OBSN_LastUpdateDate ];

/// LastUpdateTime
Property OBSNLastUpdateTime As %Time [ SqlColumnNumber = 7, SqlFieldName = OBSN_LastUpdateTime ];

/// Des Ref LastUpdateUser
Property OBSNLastUpdateUserDR As SSUser [ SqlColumnNumber = 8, SqlFieldName = OBSN_LastUpdateUser_DR ];

/// Des Ref LastUpdateHospital
Property OBSNLastUpdateHospitalDR As CTHospital [ SqlColumnNumber = 9, SqlFieldName = OBSN_LastUpdateHospital_DR ];

/// Des Ref LastUpdateObsGroup
Property OBSNLastUpdateObsGroupDR As MRCObservationGroup [ SqlColumnNumber = 10, SqlFieldName = OBSN_LastUpdateObsGroup_DR ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.MRObservationNotes).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRObservationNotes","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.MRObservationNotes).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRObservationNotes","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.MRObservationNotes).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRObservationNotes","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.MRObservationNotes).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRObservationNotes","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRObservationNotes","OnBeforeInsert")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.MRObservationNotes).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRObservationNotes","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="OBSN_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OBSN_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OBSN_LastUpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OBSN_LastUpdateObsGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OBSN_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OBSN_LastUpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OBSN_Notes">
<Node>"NOTES"</Node>
</Data>
<Data name="OBSN_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OBSN_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OBSN"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OBSN_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^MR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>OBSN_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OBSN"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OBSN_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OBSN_Time}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OBSN_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>OBSN_RowId</SqlRowIdName>
<StreamLocation>^User.MRObservationNotesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
