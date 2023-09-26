/// Complaint Clinician(2222)
Class User.PAComplaintClinician Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_ComplaintClinician, StorageStrategy = SQLStorage ]
{

/// Des Ref CareProv
Property DOCCareProvDR As CTCareProv [ SqlColumnNumber = 3, SqlFieldName = DOC_CareProv_DR ];

/// Childsub
Property DOCChildsub As %Float [ InitialExpression = {$i(^PACM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"DOC",0))}, SqlColumnNumber = 2, SqlFieldName = DOC_Childsub ];

/// PA_Complaints Parent Reference
Relationship DOCParRef As PAComplaints [ Cardinality = parent, Inverse = ChildPAComplaintClinician, Required, SqlFieldName = DOC_ParRef ];

Index RowIDBasedIDKeyIndex On DOCChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 11;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAComplaintClinician).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAComplaintClinician","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAComplaintClinician).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAComplaintClinician","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAComplaintClinician).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAComplaintClinician","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAComplaintClinician).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAComplaintClinician","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAComplaintClinician).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAComplaintClinician","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>11</ExtentSize>
<Property name="DOCCareProvDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="DOCChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="DOCParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="DOC_CareProv_DR">
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
<Field>DOC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Complaints.PACM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DOC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DOC_RowId</SqlRowIdName>
<StreamLocation>^User.PAComplaintClinicianS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
