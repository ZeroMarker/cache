/// Register Queue
Class User.DHCVISRegQueue Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RowID, SqlTableName = DHC_VIS_RegQueue, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Patient Queue No
Property QueueNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// Patient Name
Property PatientName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// Patient Sex
Property PatientSex As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// Patient Register No 
Property RegisterNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

/// Patient Adm Department or Check Department
Property Department As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

/// Patient Check Window Name Or Room Name
Property WindowName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

/// Check Room Doctor
Property Doctor As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8 ];

/// Register ComputerIP
Property ComputerIP As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9 ];

/// Insert Data Date
Property CreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10 ];

/// Insert Data Time
Property CreateTime As %Library.Time [ SqlColumnNumber = 11 ];

/// Register Infomation State
Property RegState As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12 ];

/// Bak Field
Property Note As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13 ];

/// Patient Status
Property PatientStatus As %Library.String(DISPLAYLIST = ",Ready,Wait,Call,Skip,Finith", MAXLEN = 3, SELECTIVITY = "16.6666%", TRUNCATE = 1, VALUELIST = ",R,W,C,S,F") [ SqlColumnNumber = 14 ];

/// Bak Field
Property StudyGroup As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 15 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCVISRegQueue)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ComputerIP">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
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
<Piece>12</Piece>
</Data>
<Data name="PatientName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PatientSex">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PatientStatus">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="QueueNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RegState">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RegisterNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="StudyGroup">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="WindowName">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCVISRegQueue</Global>
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
<SQLMap name="IndexDateDepWindowState">
<Global>^DHCVISRegQueuei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateDepWindowState"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Department}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WindowName}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RegState}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateDepartmentStat">
<Global>^DHCVISRegQueuei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateDepState"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Department}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RegState}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateIP">
<Global>^DHCVISRegQueuei</Global>
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
<Expression>"DateIP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ComputerIP}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateRegisterNo">
<Global>^DHCVISRegQueuei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateRegisterNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RegisterNo}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateState">
<Global>^DHCVISRegQueuei</Global>
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
<Expression>"DateState"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RegState}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateStatus">
<Global>^DHCVISRegQueuei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateStatus"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PatientStatus}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCVISRegQueueS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
