/// Enquiry Contact(2180)
Class User.PAEnquiryContact Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_EnquiryContact, StorageStrategy = SQLStorage ]
{

/// Date
Property ENQDate As %Date [ SqlColumnNumber = 2, SqlFieldName = ENQ_Date ];

/// Time
Property ENQTime As %Time [ SqlColumnNumber = 3, SqlFieldName = ENQ_Time ];

/// Contact Name
Property ENQContactName As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = ENQ_ContactName ];

/// Contact Number
Property ENQContactNumber As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ENQ_ContactNumber ];

/// Des Ref PAPER
Property ENQPAPERDR As PAPerson [ SqlColumnNumber = 6, SqlFieldName = ENQ_PAPER_DR ];

/// Des Ref RequestType
Property ENQRequestTypeDR As PACRequestType [ SqlColumnNumber = 7, SqlFieldName = ENQ_RequestType_DR ];

/// Des Ref RequestStatus
Property ENQRequestStatusDR As PACRequestStatus [ SqlColumnNumber = 8, SqlFieldName = ENQ_RequestStatus_DR ];

/// Req Desc
Property ENQReqDesc As list Of %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = ENQ_ReqDesc, SqlListType = subnode ];

/// Req Reason
Property ENQReqReason As list Of %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = ENQ_ReqReason, SqlListType = subnode ];

/// Des Ref CTCP
Property ENQCTCPDR As CTCareProv [ SqlColumnNumber = 11, SqlFieldName = ENQ_CTCP_DR ];

/// Des Ref Resource
Property ENQResourceDR As RBResource [ SqlColumnNumber = 12, SqlFieldName = ENQ_Resource_DR ];

/// Action Details
Property ENQActionDetails As list Of %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = ENQ_ActionDetails, SqlListType = subnode ];

/// Estim Time
Property ENQEstimTime As %Time [ SqlColumnNumber = 14, SqlFieldName = ENQ_EstimTime ];

/// Date Update
Property ENQDateUpdate As %Date [ SqlColumnNumber = 15, SqlFieldName = ENQ_DateUpdate ];

/// Time Update
Property ENQTimeUpdate As %Time [ SqlColumnNumber = 16, SqlFieldName = ENQ_TimeUpdate ];

/// Des Ref User
Property ENQUserDR As SSUser [ SqlColumnNumber = 17, SqlFieldName = ENQ_User_DR ];

/// EstimMins
Property ENQEstimMins As %Float [ SqlColumnNumber = 18, SqlFieldName = ENQ_EstimMins ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PAEnquiryContact).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAEnquiryContact","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PAEnquiryContact).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAEnquiryContact","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PAEnquiryContact).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAEnquiryContact","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PAEnquiryContact).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAEnquiryContact","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PAEnquiryContact).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAEnquiryContact","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAEnquiryContact","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>16</ExtentSize>
<Property name="ENQActionDetails">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="ENQCTCPDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="ENQContactName">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ENQContactNumber">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ENQDate">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="ENQDateUpdate">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="ENQEstimMins">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="ENQEstimTime">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="ENQPAPERDR">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="ENQReqDesc">
<Selectivity>9.0909%</Selectivity>
</Property>
<Property name="ENQReqReason">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="ENQRequestStatusDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="ENQRequestTypeDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="ENQResourceDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="ENQTime">
<Selectivity>9.0909%</Selectivity>
</Property>
<Property name="ENQTimeUpdate">
<Selectivity>6.2500%</Selectivity>
</Property>
<Property name="ENQUserDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^PAENQ(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ENQ_ActionDetails">
<Node>"DET"</Node>
</Data>
<Data name="ENQ_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ENQ_ContactName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ENQ_ContactNumber">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ENQ_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ENQ_DateUpdate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ENQ_EstimMins">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ENQ_EstimTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ENQ_PAPER_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ENQ_ReqDesc">
<Node>"DES"</Node>
</Data>
<Data name="ENQ_ReqReason">
<Node>"REA"</Node>
</Data>
<Data name="ENQ_RequestStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ENQ_RequestType_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ENQ_Resource_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ENQ_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ENQ_TimeUpdate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ENQ_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^PAENQ</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ENQ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ENQ_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPAPER">
<Global>^PAENQi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>ENQ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Person"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ENQ_PAPER_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ENQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexdate">
<Global>^PAENQi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>ENQ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ENQ_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ENQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ENQ_RowId</SqlRowIdName>
<StreamLocation>^User.PAEnquiryContactS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
