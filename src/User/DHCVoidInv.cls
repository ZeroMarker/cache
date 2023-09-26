Class User.DHCVoidInv Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = VOI_Rowid, SqlTableName = DHC_VoidInv, StorageStrategy = SQLStorage ]
{

/// VOI_Date
Property VOIDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$h}, SqlColumnNumber = 2, SqlFieldName = VOI_Date ];

/// VOI_Time
Property VOITime As %Library.Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 3, SqlFieldName = VOI_Time ];

/// VOI_InvNo
Property VOIInvNo As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = VOI_InvNo ];

/// VOI_Reports_DR
Property VOIReportsDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = VOI_Report_DR ];

/// VOI_User_DR
Property VOIUserDR As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = VOI_User_DR ];

/// VOI_Reason
Property VOIReason As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = VOI_Reason ];

/// VOI_RepDate
Property VOIHandDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = VOI_HandDate ];

/// VOI_RepTime
Property VOIHandTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = VOI_HandTime ];

/// PRT_Handin
Property VOIHandin As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 10, SqlFieldName = VOI_Handin ];

/// VOI_Type  ("OD":门诊预交金, "OP":门诊发票, "ID":住院押金, "IP":住院发票)
Property VOIType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = VOI_Type ];

/// VOI_Hosp_DR
Property VOIHospDR As User.CTHospital [ SqlColumnNumber = 12, SqlFieldName = VOI_Hosp_DR ];

Index VOIInvNoIndex On (VOIInvNo, VOIType) [ Unique ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCVoidInv)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="VOI_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="VOI_HandDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="VOI_HandTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="VOI_Handin">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="VOI_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="VOI_InvNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="VOI_Reason">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="VOI_Report_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="VOI_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="VOI_Type">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="VOI_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCVoidInv</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>VOI_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{VOI_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCVoidInv</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VOI_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{VOI_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{VOI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHandin">
<Global>^DHCVoidInv</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>VOI_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HandIn"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VOI_Handin}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VOI_User_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{VOI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRepDr">
<Global>^DHCVoidInv</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VOI_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"RepDr"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{VOI_Report_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{VOI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCVoidInv</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VOI_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{VOI_User_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{VOI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserDate">
<Global>^DHCVoidInv</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>VOI_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UserDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VOI_User_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VOI_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{VOI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCJFOPVoidInvS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
