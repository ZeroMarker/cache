Class User.DHCConfirmInvoice Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Confirm_RowID, SqlTableName = DHC_ConfirmInvoice, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Confirm_Invoice_DR
Property ConfirmInvoiceDR As User.DHCINVOICE [ SqlColumnNumber = 2, SqlFieldName = Confirm_Invoice_DR ];

/// Confirm_Date
Property ConfirmDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = Confirm_Date ];

/// Confirm_User
Property ConfirmTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = Confirm_Time ];

/// ConfirmUser
Property ConfirmUser As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = Confirm_User ];

///  Confirm_Note1
Property ConfrimNote1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = Confrim_Note1 ];

/// Confrim_Note2
Property ConfrimNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = Confrim_Note2 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCONFIRMINVOICE)</SqlIdExpression>
<SQLMap name="indexDate">
<Global>^DHCCONFIRMINVOICE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Confirm_Date</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Confirm_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Confirm_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexinvoice">
<Global>^DHCCONFIRMINVOICE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Confirm_Invoice_DR</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InvoiceDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Confirm_Invoice_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Confirm_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexuser">
<Global>^DHCCONFIRMINVOICE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Confirm_User</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UserDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Confirm_User}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Confirm_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="masterdate">
<Data name="Confirm_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Confirm_Invoice_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Confirm_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Confirm_User">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Confrim_Note1">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Confrim_Note2">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCCONFIRMINVOICE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Confirm_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{Confirm_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCConfirmInvoiceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
