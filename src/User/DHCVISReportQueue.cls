/// Pacs Ris Report Show Queue
Class User.DHCVISReportQueue Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RowID, SqlTableName = DHC_VIS_ReportQueue, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Patient Queue No
Property QueueNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// Report Patient Name
Property PatientName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// Patient Sex
Property PatientSex As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// Patient Register No
Property RegisterNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

/// Department
Property Department As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

/// Window Or Room Name
Property WindowName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

/// Check Doctor
Property Doctor As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8 ];

/// Check No
Property CheckNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9 ];

/// Check Cat
Property CheckCat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10 ];

/// SendReport ComputerIP
Property ComputerIP As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11 ];

/// Report State
Property ReportState As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12 ];

/// Send Report Date
Property CreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13 ];

/// Send Report Time
Property CreateTime As %Library.Time [ SqlColumnNumber = 14 ];

/// Clear Report Date
Property UpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15 ];

/// Clear Report Time
Property UpdateTime As %Library.Time [ SqlColumnNumber = 16 ];

/// Bak
Property Note As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCVISReportQueue)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CheckCat">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CheckNo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ComputerIP">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="Department">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Doctor">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Note">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PatientName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PatientSex">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="QueueNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RegisterNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ReportState">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="WindowName">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCVISReportQueue</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCheckNo">
<Global>^DHCVISReportQueuei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CheckNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CheckNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCreateDateCat">
<Global>^DHCVISReportQueuei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CreateDateCat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CheckCat}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCreateDateState">
<Global>^DHCVISReportQueuei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CreateDateState"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ReportState}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexQueueNo">
<Global>^DHCVISReportQueuei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"QueueNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{QueueNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRegisterNo">
<Global>^DHCVISReportQueuei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RegisterNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RegisterNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCVISReportQueueS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
