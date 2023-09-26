/// Nursing Note Codes     (MRNNC,1151)
Class User.MRCNursingNoteCodes Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_NursingNoteCodes, StorageStrategy = SQLStorage ]
{

Relationship ChildMRCNursingNoteCodeInterven As MRCNursingNoteCodeIntervent [ Cardinality = children, Inverse = INTParRef ];

/// Code
Property NURNCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = NURN_Code ];

/// Text
Property NURNText As list Of %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = NURN_Text, SqlListType = SUBNODE ];

/// Des Ref to NURN_NURG
Property NURNNURGDR As MRCNurseNotesGroup [ SqlColumnNumber = 4, SqlFieldName = NURN_NURG_DR ];

/// First Line of Descr
Property NURNFirstLine As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlComputeCode = { s {NURN_FirstLine}=$li({NURN_Text},1)
}, SqlComputed, SqlFieldName = NURN_FirstLine, Transient ];

Index NURNCodeUnqIdx1 On NURNCode [ Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRCNursingNoteCodes).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCNursingNoteCodes","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRCNursingNoteCodes).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCNursingNoteCodes","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRCNursingNoteCodes).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCNursingNoteCodes","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRCNursingNoteCodes).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCNursingNoteCodes","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRCNursingNoteCodes).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCNursingNoteCodes","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCNursingNoteCodes","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^MRC("NURN",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="NURN_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="NURN_NURG_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="NURN_Text">
<Node>"Notes"</Node>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>NURN_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NURN"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{NURN_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>NURN_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NURN"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({NURN_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{NURN_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>NURN_RowId</SqlRowIdName>
<StreamLocation>^User.MRCNursingNoteCodesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
