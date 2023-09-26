Class User.DHCOPReturnReason Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_OPReturnReason, StorageStrategy = SQLStorage ]
{

/// Return Code
Property ReturnCode As %String [ SqlFieldName = Reason_Code ];

/// Return Desc
Property ReturnDesc As %String [ SqlFieldName = Reason_Desc ];

/// Date From
Property ReturnDateFrom As %Date [ SqlFieldName = Reason_DateFrom ];

/// Date To
Property ReturnDateTo As %Date [ SqlFieldName = Reason_DateTo ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^ReturnReason(0))</SqlIdExpression>
<SQLMap name="Map1">
<Data name="Reason_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Reason_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Reason_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Reason_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ReturnReason</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RTRowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RTRowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RTRowId</SqlRowIdName>
<StreamLocation>^User.DHCOPReturnReasonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
