/// ComplaintClients(2220)
Class User.PAComplaintClients Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_ComplaintClients, StorageStrategy = SQLStorage ]
{

/// Childsub
Property PATChildsub As %Float [ InitialExpression = {$i(^PACM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"PAT",0))}, SqlColumnNumber = 2, SqlFieldName = PAT_Childsub ];

/// PA_Complaints Parent Reference
Relationship PATParRef As PAComplaints [ Cardinality = parent, Inverse = ChildPAComplaintClients, Required, SqlFieldName = PAT_ParRef ];

/// Des Ref Person
Property PATPersonDR As PAPerson [ SqlColumnNumber = 3, SqlFieldName = PAT_Person_DR ];

Index RowIDBasedIDKeyIndex On PATChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 37;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAComplaintClients).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAComplaintClients","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAComplaintClients).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAComplaintClients","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAComplaintClients).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAComplaintClients","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAComplaintClients).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAComplaintClients","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAComplaintClients).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAComplaintClients","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>37</ExtentSize>
<Property name="PATChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="PATParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="PATPersonDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="PAT_Person_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PACM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Complaints.PACM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PAT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Complaints.PACM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PAT_RowId</SqlRowIdName>
<StreamLocation>^User.PAComplaintClientsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
