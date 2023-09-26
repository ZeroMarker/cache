/// Complaint Documents(2219)
Class User.PAComplaintDocuments Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_ComplaintDocuments, StorageStrategy = SQLStorage ]
{

/// Childsub
Property SDChildsub As %Float [ InitialExpression = {$i(^PACM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"SD",0))}, SqlColumnNumber = 2, SqlFieldName = SD_Childsub ];

/// Des Ref DocumType
Property SDDocumTypeDR As PACDocumentType [ SqlColumnNumber = 3, SqlFieldName = SD_DocumType_DR ];

/// File
Property SDFile As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = SD_File ];

/// PA_Complaints Parent Reference
Relationship SDParRef As PAComplaints [ Cardinality = parent, Inverse = ChildPAComplaintDocuments, Required, SqlFieldName = SD_ParRef ];

Index RowIDBasedIDKeyIndex On SDChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 2;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAComplaintDocuments).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAComplaintDocuments","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAComplaintDocuments).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAComplaintDocuments","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAComplaintDocuments).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAComplaintDocuments","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAComplaintDocuments).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAComplaintDocuments","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAComplaintDocuments).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAComplaintDocuments","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>2</ExtentSize>
<Property name="SDChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="SDDocumTypeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="SDFile">
<Selectivity>1</Selectivity>
</Property>
<Property name="SDParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="SD_DocumType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SD_File">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PACM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Complaints.PACM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Complaints.PACM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SD_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SD_RowId</SqlRowIdName>
<StreamLocation>^User.PAComplaintDocumentsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
