/// MRC Nursing Notes Intervention(1341
Class User.MRCNursingNoteCodeIntervent Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_NursingNoteCodeIntervent, StorageStrategy = SQLStorage ]
{

/// Childsub
Property INTChildsub As %Float [ InitialExpression = {$i(^MRC("NURN",$p(%d(0),$c(1)),"INT",0))}, SqlColumnNumber = 2, SqlFieldName = INT_Childsub ];

/// Code
Property INTCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = INT_Code ];

/// FirstLine
Property INTFirstLine As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlComputeCode = { s {INT_FirstLine}=$li({INT_Text},1)
}, SqlComputed, SqlFieldName = INT_FirstLine, Transient ];

/// MRC_NursingNoteCodes Parent Reference
Relationship INTParRef As MRCNursingNoteCodes [ Cardinality = parent, Inverse = ChildMRCNursingNoteCodeInterven, Required, SqlFieldName = INT_ParRef ];

/// Text
Property INTText As list Of %String(COLLATION = "Exact", MAXLEN = 45, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = INT_Text, SqlListType = SUBNODE ];

Index RowIDBasedIDKeyIndex On INTChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 6;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRCNursingNoteCodeIntervent).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCNursingNoteCodeIntervent","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRCNursingNoteCodeIntervent).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCNursingNoteCodeIntervent","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRCNursingNoteCodeIntervent).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCNursingNoteCodeIntervent","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRCNursingNoteCodeIntervent).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCNursingNoteCodeIntervent","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRCNursingNoteCodeIntervent).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCNursingNoteCodeIntervent","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>6</ExtentSize>
<Property name="INTChildsub">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="INTCode">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="INTFirstLine">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="INTParRef">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INTText">
<Selectivity>16.6667%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="INT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INT_Text">
<Node>"TXT"</Node>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MRC_NursingNoteCodes.NURN_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>INT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NURN"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRC_NursingNoteCodes.NURN_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"INT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>INT_RowId</SqlRowIdName>
<StreamLocation>^User.MRCNursingNoteCodeInterveS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
