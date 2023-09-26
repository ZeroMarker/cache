Class User.DHCIPBillPatFeeConfirm Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Confirm_RowId, SqlTableName = DHC_IPBillPatFeeConfirm, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCIPBillPatOrderConfirm As User.DHCIPBillPatOrderConfirm [ Cardinality = children, Inverse = ConfSubParRef ];

/// Confirm_Bill
Property ConfirmBill As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = Confirm_Bill ];

/// Confirm_CommitDate
Property ConfirmCommitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = Confirm_CommitDate ];

/// Confirm_CommitTime
Property ConfirmCommitTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = Confirm_CommitTime ];

/// Confirm_CommitUer
Property ConfirmCommitUer As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = Confirm_CommitUer ];

/// Confirm_CommitStatus
Property ConfirmCommitStatus As %Library.String(DISPLAYLIST = ",UnCommit,Commit,Recall", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",U,C,R") [ SqlColumnNumber = 6, SqlFieldName = Confirm_CommitStatus ];

/// Confirm_ConfirmDate
Property ConfirmConfirmDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = Confirm_ConfirmDate ];

/// Confirm_ConfirmTime
Property ConfirmConfirmTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = Confirm_ConfirmTime ];

/// Confirm_ConfirmUser
Property ConfirmConfirmUser As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = Confirm_ConfirmUser ];

/// Confirm_ConfirmStatus
Property ConfirmConfirmStatus As %Library.String(DISPLAYLIST = ",UnConfirm,Confirm,Recall", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",U,C,R") [ SqlColumnNumber = 10, SqlFieldName = Confirm_ConfirmStatus ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCIPBillPatFeeConfirm)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="Confirm_Bill">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Confirm_CommitDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Confirm_CommitStatus">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Confirm_CommitTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Confirm_CommitUer">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Confirm_ConfirmDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="Confirm_ConfirmStatus">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="Confirm_ConfirmTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Confirm_ConfirmUser">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCIPBillPatFeeConfirm</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Confirm_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{Confirm_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBill">
<Global>^DHCIPBillPatFeeConfirmi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Confirm_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Bill"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Confirm_Bill}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Confirm_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexConfirmDate">
<Global>^DHCIPBillPatFeeConfirmi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>Confirm_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ConfrimDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Confirm_ConfirmDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Confirm_Bill}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Confirm_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexconfirmstatus">
<Global>^DHCIPBillPatFeeConfirmi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>Confirm_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ConfirmStatus"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Confirm_ConfirmStatus}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Confirm_Bill}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Confirm_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexCommitDate">
<Global>^DHCIPBillPatFeeConfirmi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>Confirm_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CommitDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Confirm_CommitDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Confirm_Bill}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Confirm_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexCommitStatus">
<Global>^DHCIPBillPatFeeConfirmi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>Confirm_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CommitStatus"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Confirm_CommitStatus}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Confirm_Bill}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Confirm_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCIPBillPatFeeConfirmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
