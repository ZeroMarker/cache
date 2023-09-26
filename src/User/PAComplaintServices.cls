/// Complaint Services(2221)
Class User.PAComplaintServices Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_ComplaintServices, StorageStrategy = SQLStorage ]
{

/// Des Ref CTLOC
Property SERCTLOCDR As CTLoc [ SqlColumnNumber = 3, SqlFieldName = SER_CTLOC_DR ];

/// Childsub
Property SERChildsub As %Float [ InitialExpression = {$i(^PACM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"SER",0))}, SqlColumnNumber = 2, SqlFieldName = SER_Childsub ];

/// PA_Complaints Parent Reference
Relationship SERParRef As PAComplaints [ Cardinality = parent, Inverse = ChildPAComplaintServices, Required, SqlFieldName = SER_ParRef ];

Index RowIDBasedIDKeyIndex On SERChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 22;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAComplaintServices).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAComplaintServices","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAComplaintServices).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAComplaintServices","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAComplaintServices).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAComplaintServices","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAComplaintServices).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAComplaintServices","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAComplaintServices).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAComplaintServices","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>22</ExtentSize>
<Property name="SERCTLOCDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="SERChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="SERParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="SER_CTLOC_DR">
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
<Field>SER_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Complaints.PACM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SER"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SER_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SER_RowId</SqlRowIdName>
<StreamLocation>^User.PAComplaintServicesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
