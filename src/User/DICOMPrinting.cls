/// DICOM Printing(2015)
Class User.DICOMPrinting Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DICOM_Printing, StorageStrategy = SQLStorage ]
{

/// Date
Property PRDate As %Date [ SqlColumnNumber = 2, SqlFieldName = PR_Date ];

/// Status
Property PRStatus As %String(DISPLAYLIST = ",Ready,Error,Ignore,Sent", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",R,E,I,S") [ SqlColumnNumber = 3, SqlFieldName = PR_Status ];

/// AETitle
Property PRAETitle As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PR_AETitle ];

/// Format
Property PRFormat As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PR_Format ];

/// Images
Property PRImages As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = PR_Images ];

/// Des Ref OEORI
Property PROEORIDR As OEOrdItem [ SqlColumnNumber = 7, SqlFieldName = PR_OEORI_DR ];

/// Time
Property PRTime As %Time [ SqlColumnNumber = 8, SqlFieldName = PR_Time ];

/// Reason
Property PRReason As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = PR_Reason ];

/// Dicom Port
Property PRPort As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = PR_Port ];

/// Printer IPAddress
Property PRIPAddress As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = PR_IPAddress ];

/// PR_TimeInMins
Property PRTimeInMins As %Float [ SqlColumnNumber = 12, SqlFieldName = PR_TimeInMins ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.DICOMPrinting).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMPrinting","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.DICOMPrinting).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMPrinting","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.DICOMPrinting).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMPrinting","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.DICOMPrinting).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMPrinting","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.DICOMPrinting).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.DICOMPrinting","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DICOM("PR",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PR_AETitle">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PR_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PR_Format">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PR_IPAddress">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PR_Images">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PR_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PR_Port">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PR_Reason">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PR_Status">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PR_Time">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PR_TimeInMins">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DICOM</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PR_RowId</SqlRowIdName>
<StreamLocation>^User.DICOMPrintingS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
