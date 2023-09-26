Class User.DHCEQAccountNoList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ANL_RowID, SqlTableName = DHC_EQAccountNoList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ANL_AccountNoDR
Property ANLAccountNoDR As User.DHCEQAccountNo [ SqlColumnNumber = 2, SqlFieldName = ANL_AccountNoDR ];

/// ANL_SourceType
Property ANLSourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ANL_SourceType ];

/// ANL_SourceID
Property ANLSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ANL_SourceID ];

/// ANL_EquipTypeDR
Property ANLEquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 5, SqlFieldName = ANL_EquipTypeDR ];

/// ANL_ProviderDR
Property ANLProviderDR As User.DHCEQCVendor [ SqlColumnNumber = 6, SqlFieldName = ANL_ProviderDR ];

/// ANL_ManuFactory
Property ANLManuFactory As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ANL_ManuFactory ];

/// ANL_EquipName
Property ANLEquipName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = ANL_EquipName ];

/// ANL_QuantityNum
Property ANLQuantityNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = ANL_QuantityNum ];

/// ANL_Amount
Property ANLAmount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = ANL_Amount ];

/// ANL_Remark
Property ANLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = ANL_Remark ];

/// ANL_UpdateUserDR
Property ANLUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = ANL_UpdateUserDR ];

/// ANL_UpdateDate
Property ANLUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = ANL_UpdateDate ];

/// ANL_UpdateTime
Property ANLUpdateTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = ANL_UpdateTime ];

/// ANL_Hold1
Property ANLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = ANL_Hold1 ];

/// ANL_Hold2
Property ANLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = ANL_Hold2 ];

/// ANL_Hold3
Property ANLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = ANL_Hold3 ];

/// ANL_Hold4
Property ANLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = ANL_Hold4 ];

/// ANL_Hold5
Property ANLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = ANL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQAccountNoList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ANL_AccountNoDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANL_Amount">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ANL_EquipName">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ANL_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ANL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ANL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ANL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ANL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ANL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ANL_ManuFactory">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ANL_ProviderDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ANL_QuantityNum">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ANL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ANL_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ANL_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ANL_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ANL_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ANL_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCEQAccountNoList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ANL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ANL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAccountNoDR">
<Global>^DHCEQAccountNoList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ANL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AccountNoDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ANL_AccountNoDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ANL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQAccountNoList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ANL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ANL_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ANL_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ANL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQAccountNoListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
