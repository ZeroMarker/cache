/// PA Deceased Details(1635)
Class User.PADeceasedDetails Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_DeceasedDetails, StorageStrategy = SQLStorage ]
{

/// Childsub
Property DETChildsub As %Float [ InitialExpression = {$i(^PADC($p(%d(0),$c(1)),"DET",0))}, SqlColumnNumber = 2, SqlFieldName = DET_Childsub ];

/// PA_DeceasedPatient Parent Reference
Relationship DETParRef As PADeceasedPatient [ Cardinality = parent, Inverse = ChildPADeceasedDetails, Required, SqlFieldName = DET_ParRef ];

/// Status
Property DETStatus As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DET_Status ];

/// Table
Property DETTable As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DET_Table ];

/// Table RowId
Property DETTableRowId As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DET_TableRowId ];

Index RowIDBasedIDKeyIndex On DETChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 1221;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PADeceasedDetails).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PADeceasedDetails","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PADeceasedDetails).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PADeceasedDetails","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PADeceasedDetails).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PADeceasedDetails","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PADeceasedDetails).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PADeceasedDetails","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PADeceasedDetails).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PADeceasedDetails","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1221</ExtentSize>
<Property name="DETChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="DETParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="DETStatus">
<Selectivity>1</Selectivity>
</Property>
<Property name="DETTable">
<Selectivity>1</Selectivity>
</Property>
<Property name="DETTableRowId">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="DET_Status">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DET_Table">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DET_TableRowId">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PADC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_DeceasedPatient.DEC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_DeceasedPatient.DEC_RowId}</Expression>
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
<SqlRowIdName>DET_RowId</SqlRowIdName>
<StreamLocation>^User.PADeceasedDetailsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
