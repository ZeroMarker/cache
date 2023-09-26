Class User.DHCEQPayRecordDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PRD_RowID, SqlTableName = DHC_EQPayRecordDetail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PRD_SourceType
Property PRDSourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PRD_SourceType ];

/// PRD_SourceID
Property PRDSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PRD_SourceID ];

/// PRD_PayNum
Property PRDPayNum As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PRD_PayNum ];

/// PRD_Amount
Property PRDAmount As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PRD_Amount ];

/// PRD_ProviderDR
Property PRDProviderDR As User.DHCEQCVendor [ SqlColumnNumber = 6, SqlFieldName = PRD_ProviderDR ];

/// PRD_No
Property PRDNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PRD_No ];

/// PRD_Item
Property PRDItem As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PRD_Item ];

/// PRD_EquipTypeDR
Property PRDEquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 9, SqlFieldName = PRD_EquipTypeDR ];

/// PRD_Status
Property PRDStatus As %Library.String(DISPLAYLIST = ",未付,部分支付,已付", MAXLEN = 4, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 10, SqlFieldName = PRD_Status ];

/// PRD_Hold1
Property PRDHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PRD_Hold1 ];

/// PRD_Hold2
Property PRDHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PRD_Hold2 ];

/// PRD_Hold3
Property PRDHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PRD_Hold3 ];

/// PRD_Hold4
Property PRDHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PRD_Hold4 ];

/// PRD_Hold5
Property PRDHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PRD_Hold5 ];

/// PRD_Price
Property PRDPrice As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = PRD_Price ];

/// PRD_Num
Property PRDNum As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = PRD_Num ];

/// PRD_Hold6
Property PRDHold6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = PRD_Hold6 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQPayRecordDetail("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PRD_Amount">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PRD_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PRD_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PRD_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PRD_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PRD_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PRD_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PRD_Hold6">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PRD_Item">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PRD_No">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PRD_Num">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PRD_PayNum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PRD_Price">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PRD_ProviderDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PRD_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PRD_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PRD_Status">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCEQPayRecordDetail</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PRD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PRD_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSourceID">
<Global>^DHCEQPayRecordDetail</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PRD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SourceID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PRD_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PRD_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PRD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCEQPayRecordDetail</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>PRD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PRD_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PRD_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>+{PRD_Hold2}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{PRD_Status}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{PRD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQPayRecordDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
