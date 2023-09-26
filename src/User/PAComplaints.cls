/// PA Complaints(1819)
Class User.PAComplaints Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_Complaints, StorageStrategy = SQLStorage ]
{

Relationship ChildPAComplaintClients As PAComplaintClients [ Cardinality = children, Inverse = PATParRef ];

Relationship ChildPAComplaintClinician As PAComplaintClinician [ Cardinality = children, Inverse = DOCParRef ];

Relationship ChildPAComplaintDocuments As PAComplaintDocuments [ Cardinality = children, Inverse = SDParRef ];

Relationship ChildPAComplaintHistory As PAComplaintHistory [ Cardinality = children, Inverse = HISParRef ];

Relationship ChildPAComplaintServices As PAComplaintServices [ Cardinality = children, Inverse = SERParRef ];

/// Des Ref CTLOC
Property PACMCTLOCDR As CTLoc [ SqlColumnNumber = 2, SqlFieldName = PACM_CTLOC_DR ];

/// Des Ref Category
Property PACMCategoryDR As PACComplaintCategory [ SqlColumnNumber = 12, SqlFieldName = PACM_Category_DR ];

/// Changes Details
Property PACMChangesDetails As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = PACM_ChangesDetails, SqlListType = SUBNODE ];

/// Des Ref User
Property PACMComplaintHandler As SSUser [ SqlColumnNumber = 8, SqlFieldName = PACM_ComplaintHandler ];

/// Date Complaint
Property PACMDateComplaint As %Date [ SqlColumnNumber = 6, SqlFieldName = PACM_DateComplaint ];

/// Target Date for Next Action
Property PACMDateNextAction As %Date [ SqlColumnNumber = 13, SqlFieldName = PACM_DateNextAction ];

/// Date Resolved
Property PACMDateResolved As %Date [ SqlColumnNumber = 9, SqlFieldName = PACM_DateResolved ];

/// Details
Property PACMDetails As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PACM_Details, SqlListType = SUBNODE ];

/// Keyword
Property PACMKeyword As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = PACM_Keyword ];

/// Des Ref User
Property PACMMadeTo As SSUser [ SqlColumnNumber = 7, SqlFieldName = PACM_MadeTo ];

/// Des Ref PAADM
Property PACMPAADMDR As PAAdm [ SqlColumnNumber = 4, SqlFieldName = PACM_PAADM_DR ];

/// Des Ref Person
Property PACMPersonDR As PAPerson [ SqlColumnNumber = 3, SqlFieldName = PACM_Person_DR ];

/// Des Ref Priority
Property PACMPriorityDR As PACComplaintPriority [ SqlColumnNumber = 15, SqlFieldName = PACM_Priority_DR ];

/// Des Ref RecordedUser
Property PACMRecordedUserDR As SSUser [ SqlColumnNumber = 14, SqlFieldName = PACM_RecordedUser_DR ];

/// Des Ref Relation
Property PACMRelationDR As CTRelation [ SqlColumnNumber = 16, SqlFieldName = PACM_Relation_DR ];

/// Reported By
Property PACMReportedBy As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = PACM_ReportedBy ];

/// Des Ref Status
Property PACMStatusDR As PACComplaintStatus [ SqlColumnNumber = 11, SqlFieldName = PACM_Status_DR ];

/// Type
Property PACMType As %String(DISPLAYLIST = ",Complaint,Plaudit", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",C,P") [ SqlColumnNumber = 19, SqlFieldName = PACM_Type ];

Parameter EXTENTSIZE = 27;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAComplaints).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAComplaints","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAComplaints).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAComplaints","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAComplaints).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAComplaints","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAComplaints).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAComplaints","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAComplaints).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAComplaints","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>27</ExtentSize>
<Property name="PACMCTLOCDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="PACMCategoryDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="PACMChangesDetails">
<Selectivity>1</Selectivity>
</Property>
<Property name="PACMComplaintHandler">
<Selectivity>1</Selectivity>
</Property>
<Property name="PACMDateComplaint">
<Selectivity>1</Selectivity>
</Property>
<Property name="PACMDateNextAction">
<Selectivity>1</Selectivity>
</Property>
<Property name="PACMDateResolved">
<Selectivity>1</Selectivity>
</Property>
<Property name="PACMDetails">
<Selectivity>1</Selectivity>
</Property>
<Property name="PACMKeyword">
<Selectivity>1</Selectivity>
</Property>
<Property name="PACMMadeTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="PACMPAADMDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="PACMPersonDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="PACMPriorityDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="PACMRecordedUserDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="PACMRelationDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="PACMReportedBy">
<Selectivity>1</Selectivity>
</Property>
<Property name="PACMStatusDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="PACMType">
<Selectivity>33.3333%</Selectivity>
</Property>
<SqlIdExpression>$i(^PACM(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PACM_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PACM_Category_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PACM_ChangesDetails">
<Node>"CH"</Node>
</Data>
<Data name="PACM_ComplaintHandler">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PACM_DateComplaint">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PACM_DateNextAction">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PACM_DateResolved">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PACM_Details">
<Node>"DET"</Node>
</Data>
<Data name="PACM_Keyword">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PACM_MadeTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PACM_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PACM_Person_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PACM_Priority_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PACM_RecordedUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PACM_Relation_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PACM_ReportedBy">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PACM_Status_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PACM_Type">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Global>^PACM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PACM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PACM_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^PACM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PACM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PACM_DateComplaint}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PACM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexKeyword">
<Global>^PACM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PACM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Keyw"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({PACM_Keyword})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PACM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPerson">
<Global>^PACM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PACM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Person"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PACM_Person_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PACM_DateComplaint}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PACM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PACM_RowId</SqlRowIdName>
<StreamLocation>^User.PAComplaintsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
