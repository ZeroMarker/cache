/// PA Merge Patient Details(1466)
Class User.PAMergePatientDetails Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_MergePatientDetails, StorageStrategy = SQLStorage ]
{

/// Childsub
Property DETChildsub As %Float [ InitialExpression = {$i(^PAMR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"DET",0))}, SqlColumnNumber = 2, SqlFieldName = DET_Childsub ];

/// PA_MergePatient Parent Reference
Relationship DETParRef As PAMergePatient [ Cardinality = parent, Inverse = ChildPAMergePatientDetails, Required, SqlFieldName = DET_ParRef ];

/// Table
Property DETTable As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DET_Table ];

/// Table RowId
Property DETTableRowId As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DET_TableRowId ];

Index RowIDBasedIDKeyIndex On DETChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 1220;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAMergePatientDetails).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAMergePatientDetails","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAMergePatientDetails).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAMergePatientDetails","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAMergePatientDetails).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAMergePatientDetails","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAMergePatientDetails).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAMergePatientDetails","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAMergePatientDetails).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAMergePatientDetails","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1220</ExtentSize>
<Property name="DETChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="DETParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="DETTable">
<Selectivity>1</Selectivity>
</Property>
<Property name="DETTableRowId">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="DET_Table">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DET_TableRowId">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAMR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_MergePatient.MRG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_MergePatient.MRG_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DET"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DET_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DET_Rowid</SqlRowIdName>
<StreamLocation>^User.PAMergePatientDetailsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
