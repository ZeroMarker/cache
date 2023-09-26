Class User.DHCEQFundsRecord Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = FR_RowID, SqlTableName = DHC_EQFundsRecord, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// FR_Desc
Property FRDesc As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = FR_Desc ];

/// FR_No
Property FRNo As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = FR_No ];

/// FR_FundsTypeDR
Property FRFundsTypeDR As User.DHCEQCFundsType [ SqlColumnNumber = 4, SqlFieldName = FR_FundsTypeDR ];

/// FR_Fee
Property FRFee As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = FR_Fee ];

/// FR_FromDept
Property FRFromDept As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = FR_FromDept ];

/// FR_FromDate
Property FRFromDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = FR_FromDate ];

/// FR_ToDate
Property FRToDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = FR_ToDate ];

/// FR_Date
Property FRDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = FR_Date ];

/// FR_Remark
Property FRRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = FR_Remark ];

/// FR_Hold1
Property FRHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = FR_Hold1 ];

/// FR_Hold2
Property FRHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = FR_Hold2 ];

/// FR_Hold3
Property FRHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = FR_Hold3 ];

/// FR_Hold4
Property FRHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = FR_Hold4 ];

/// FR_Hold5
Property FRHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = FR_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQFundsRecord("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="FR_Date">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="FR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FR_Fee">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="FR_FromDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="FR_FromDept">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="FR_FundsTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="FR_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="FR_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="FR_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="FR_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="FR_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="FR_No">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="FR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="FR_ToDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCEQFundsRecord</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>FR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{FR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexNo">
<Global>^DHCEQFundsRecord</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"No"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({FR_No})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{FR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQFundsRecordS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
