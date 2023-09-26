Class User.DHCJFIPRcptInv Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = VOI_Rowid, SqlTableName = DHC_JFIPRcptInv, StorageStrategy = SQLStorage ]
{

/// VOI_Date
Property VOIDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = VOI_Date ];

/// VOI_Time
Property VOITime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = VOI_Time ];

/// VOI_InvNo
Property VOIInvNo As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = VOI_InvNo ];

/// VOI_ReportDr
Property VOIReportDr As User.DHCJFUSERJK [ SqlColumnNumber = 5, SqlFieldName = VOI_ReportDr ];

/// VOI_Usr
Property VOIUsr As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = VOI_Usr ];

/// VOI_Reason
Property VOIReason As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = VOI_Reason ];

/// VOI_RepDate
Property VOIHandDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = VOI_HandDate ];

/// VOI_RepTime
Property VOIHandTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = VOI_HandTime ];

/// PRT_Handin
Property VOIHandin As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = VOI_Handin ];

Property VOIRcptDr As User.dhcsfprintdetail [ SqlColumnNumber = 11, SqlFieldName = VOI_RcptDr ];

Property VOIFlag As %Library.String(DISPLAYLIST = ",Abort,Noraml", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",A,N") [ SqlColumnNumber = 12, SqlFieldName = VOI_Flag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCRcptInv)</SqlIdExpression>
<SQLMap name="IndexDate">
<Global>^DHCRcptInvi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VOI_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VOI_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VOI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRcpt">
<Global>^DHCRcptInvi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VOI_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RcpNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VOI_RcptDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VOI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexReport">
<Global>^DHCRcptInvi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VOI_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Hand"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VOI_ReportDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VOI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="VOI_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="VOI_Flag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="VOI_HandDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="VOI_HandTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="VOI_Handin">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="VOI_InvNo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="VOI_RcptDr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="VOI_Reason">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="VOI_ReportDr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="VOI_Time">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="VOI_Usr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCRcptInv</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>VOI_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{VOI_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCJFIPRcptInvS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
