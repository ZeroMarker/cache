Class User.DHCEQAppendFee Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AF_RowID, SqlTableName = DHC_EQAppendFee, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// AF_AddDate
Property AFAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = AF_AddDate ];

/// AF_AddTime
Property AFAddTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = AF_AddTime ];

/// AF_AddUserDR
Property AFAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = AF_AddUserDR ];

/// AF_AppendFee
Property AFAppendFee As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = AF_AppendFee ];

/// AF_AppendFeeTypeDR
Property AFAppendFeeTypeDR As User.DHCEQCAppendFeeType [ SqlColumnNumber = 3, SqlFieldName = AF_AppendFeeTypeDR ];

/// AF_CurrencyDR
Property AFCurrencyDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = AF_CurrencyDR ];

/// AF_EquipDR
Property AFEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = AF_EquipDR ];

/// AF_InvalidFlag
Property AFInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = AF_InvalidFlag ];

/// AF_InvoiceDate
Property AFInvoiceDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = AF_InvoiceDate ];

/// AF_InvoiceNo
Property AFInvoiceNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = AF_InvoiceNo ];

/// AF_OccDate
Property AFOccDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = AF_OccDate ];

/// AF_PayUserDR
Property AFPayUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = AF_PayUserDR ];

/// AF_Remark
Property AFRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = AF_Remark ];

/// AF_UpdateDate
Property AFUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = AF_UpdateDate ];

/// AF_UpdateTime
Property AFUpdateTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = AF_UpdateTime ];

/// AF_UpdateUserDR
Property AFUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = AF_UpdateUserDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQAppendFee("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AF_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AF_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AF_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AF_AppendFee">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AF_AppendFeeTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AF_CurrencyDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AF_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AF_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="AF_InvoiceDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AF_InvoiceNo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AF_OccDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AF_PayUserDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AF_Remark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AF_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AF_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AF_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCEQAppendFee</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{AF_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAddDate">
<Global>^DHCEQAppendFee</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AddDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AF_AddDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQAppendFee</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AF_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUpdateDate">
<Global>^DHCEQAppendFee</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UpdateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AF_UpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AF_InvalidFlag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQAppendFeeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
