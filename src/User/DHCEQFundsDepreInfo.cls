Class User.DHCEQFundsDepreInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = FD_RowID, SqlTableName = DHC_EQFundsDepreInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// FD_DepreTotalFee
Property FDDepreTotalFee As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = FD_DepreTotalFee ];

/// FD_DepreTypeDR
Property FDDepreTypeDR As User.DHCEQCDepreType [ SqlColumnNumber = 3, SqlFieldName = FD_DepreTypeDR ];

/// FD_FundsDR
Property FDFundsDR As User.DHCEQFunds [ SqlColumnNumber = 2, SqlFieldName = FD_FundsDR ];

/// FD_Hold1
Property FDHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = FD_Hold1 ];

/// FD_Hold10
Property FDHold10 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = FD_Hold10 ];

/// FD_Hold2
Property FDHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = FD_Hold2 ];

/// FD_Hold3
Property FDHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = FD_Hold3 ];

/// FD_Hold4
Property FDHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = FD_Hold4 ];

/// FD_Hold5
Property FDHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = FD_Hold5 ];

/// FD_Hold6
Property FDHold6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = FD_Hold6 ];

/// FD_Hold7
Property FDHold7 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = FD_Hold7 ];

/// FD_Hold8
Property FDHold8 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = FD_Hold8 ];

/// FD_Hold9
Property FDHold9 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = FD_Hold9 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQFundsDepreInfo("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="FD_DepreTotalFee">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="FD_DepreTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="FD_FundsDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FD_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="FD_Hold10">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="FD_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="FD_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="FD_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="FD_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="FD_Hold6">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="FD_Hold7">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="FD_Hold8">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="FD_Hold9">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCEQFundsDepreInfo</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>FD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{FD_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexFunds">
<Global>^DHCEQFundsDepreInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>FD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DepreTypeFunds"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{FD_DepreTypeDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{FD_FundsDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{FD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQFundsDepreInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
