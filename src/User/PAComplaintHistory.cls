/// PA Complaint History(1822)
Class User.PAComplaintHistory Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_ComplaintHistory, StorageStrategy = SQLStorage ]
{

/// Childsub
Property HISChildsub As %Float [ InitialExpression = {$i(^PACM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"HIS",0))}, SqlColumnNumber = 2, SqlFieldName = HIS_Childsub ];

/// Date
Property HISDate As %Date [ SqlColumnNumber = 3, SqlFieldName = HIS_Date ];

/// Details
Property HISDetails As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = HIS_Details, SqlListType = SUBNODE ];

/// PA_Complaints Parent Reference
Relationship HISParRef As PAComplaints [ Cardinality = parent, Inverse = ChildPAComplaintHistory, Required, SqlFieldName = HIS_ParRef ];

/// Des Ref Status
Property HISStatusDR As PACComplaintStatus [ SqlColumnNumber = 6, SqlFieldName = HIS_Status_DR ];

/// Time
Property HISTime As %Time [ SqlColumnNumber = 4, SqlFieldName = HIS_Time ];

/// Des Ref User
Property HISUserDR As SSUser [ SqlColumnNumber = 5, SqlFieldName = HIS_User_DR ];

Index RowIDBasedIDKeyIndex On HISChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 3;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAComplaintHistory).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAComplaintHistory","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAComplaintHistory).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAComplaintHistory","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAComplaintHistory).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAComplaintHistory","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAComplaintHistory).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAComplaintHistory","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAComplaintHistory).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAComplaintHistory","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>3</ExtentSize>
<Property name="HISChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="HISDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="HISDetails">
<Selectivity>1</Selectivity>
</Property>
<Property name="HISParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="HISStatusDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="HISTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="HISUserDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="HIS_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HIS_Details">
<Node>"DET"</Node>
</Data>
<Data name="HIS_Status_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="HIS_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HIS_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PACM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Complaints.PACM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>HIS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Complaints.PACM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HIS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HIS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>HIS_RowId</SqlRowIdName>
<StreamLocation>^User.PAComplaintHistoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
