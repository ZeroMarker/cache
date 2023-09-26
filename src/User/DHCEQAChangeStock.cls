Class User.DHCEQAChangeStock Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ACS_RowID, SqlTableName = DHC_EQAChangeStock, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ACS_FromLocDR
Property ACSFromLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ACS_FromLocDR ];

/// ACS_ToLocDR
Property ACSToLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ACS_ToLocDR ];

/// ACS_ItemDR
Property ACSItemDR As User.DHCEQCAccessory [ SqlColumnNumber = 4, SqlFieldName = ACS_ItemDR ];

/// ACS_AccessoryTypeDR
Property ACSAccessoryTypeDR As User.DHCEQCAccessoryType [ SqlColumnNumber = 5, SqlFieldName = ACS_AccessoryTypeDR ];

/// ACS_BaseUOMDR
Property ACSBaseUOMDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ACS_BaseUOMDR ];

/// ACS_UOMDR
Property ACSUOMDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ACS_UOMDR ];

/// ACS_BaseStock
Property ACSBaseStock As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = ACS_BaseStock ];

/// ACS_Price
Property ACSPrice As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = ACS_Price ];

/// ACS_SourceType
Property ACSSourceType As %Library.String(DISPLAYLIST = ",入库明细,转移明细,出库明细", MAXLEN = 4, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 10, SqlFieldName = ACS_SourceType ];

/// ACS_SourceID
Property ACSSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = ACS_SourceID ];

/// ACS_Stock
Property ACSStock As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = ACS_Stock ];

/// ACS_AuditUserDR
Property ACSAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = ACS_AuditUserDR ];

/// ACS_OutDate
Property ACSOutDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = ACS_OutDate ];

/// ACS_AuditDate
Property ACSAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = ACS_AuditDate ];

/// ACS_Hold1
Property ACSHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = ACS_Hold1 ];

/// ACS_Hold2
Property ACSHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = ACS_Hold2 ];

/// ACS_Hold3
Property ACSHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = ACS_Hold3 ];

/// ACS_Hold4
Property ACSHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = ACS_Hold4 ];

/// ACS_Hold5
Property ACSHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = ACS_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQAChangeStock("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ACS_AccessoryTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ACS_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ACS_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ACS_BaseStock">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ACS_BaseUOMDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ACS_FromLocDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ACS_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ACS_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ACS_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ACS_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ACS_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ACS_ItemDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ACS_OutDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ACS_Price">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ACS_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ACS_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ACS_Stock">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ACS_ToLocDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ACS_UOMDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCEQAChangeStock</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ACS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ACS_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexFromLoc">
<Global>^DHCEQAChangeStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ACS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FromLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ACS_FromLocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ACS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexItem">
<Global>^DHCEQAChangeStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ACS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Item"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ACS_ItemDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ACS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSourceType">
<Global>^DHCEQAChangeStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ACS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SourceType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ACS_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ACS_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ACS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexToLoc">
<Global>^DHCEQAChangeStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ACS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ToLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ACS_ToLocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ACS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQAChangeStockS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
