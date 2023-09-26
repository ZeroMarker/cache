Class User.DHCEQUseConsumableItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = UCI_RowID, SqlTableName = DHC_EQUseConsumableItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// UCI_AddDate
Property UCIAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = UCI_AddDate ];

/// UCI_Amount
Property UCIAmount As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = UCI_Amount ];

/// UCI_CancelDate
Property UCICancelDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = UCI_CancelDate ];

/// UCI_ConsumableItemDR
Property UCIConsumableItemDR As User.DHCEQCConsumableItem [ SqlColumnNumber = 3, SqlFieldName = UCI_ConsumableItemDR ];

/// UCI_ExID
Property UCIExID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = UCI_ExID ];

/// UCI_ExType
Property UCIExType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = UCI_ExType ];

/// UCI_Hold3
Property UCIHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = UCI_Hold1 ];

/// UCI_Hold4
Property UCIHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = UCI_Hold2 ];

/// UCI_Hold5
Property UCIHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = UCI_Hold3 ];

/// UCI_Hold4
Property UCIHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = UCI_Hold4 ];

/// UCI_Hold5
Property UCIHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = UCI_Hold5 ];

/// UCI_MonthStr
Property UCIMonthStr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = UCI_MonthStr ];

/// UCI_Price
Property UCIPrice As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = UCI_Price ];

/// UCI_Quantity
Property UCIQuantity As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = UCI_Quantity ];

/// UCI_QuantityType
Property UCIQuantityType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = UCI_QuantityType ];

/// UCI_RelativeQty
Property UCIRelativeQty As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = UCI_RelativeQty ];

/// UCI_ServDetItemDR
Property UCIServDetItemDR As User.DHCEQCServDetItem [ SqlColumnNumber = 14, SqlFieldName = UCI_ServDetItemDR ];

/// UCI_ServDetItemQty
Property UCIServDetItemQty As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = UCI_ServDetItemQty ];

/// UCI_ServiceItemDR
Property UCIServiceItemDR As User.DHCEQCServiceItem [ SqlColumnNumber = 13, SqlFieldName = UCI_ServiceItemDR ];

/// UCI_Hold2
Property UCISourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = UCI_SourceID ];

/// UCI_Hold1
Property UCISourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = UCI_SourceType ];

/// UCI_SumByMonthFlag
Property UCISumByMonthFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = UCI_SumByMonthFlag ];

/// UCI_UomDR
Property UCIUomDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = UCI_UomDR ];

/// UCI_UseDate
Property UCIUseDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = UCI_UseDate ];

/// UCI_UseLocDR
Property UCIUseLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = UCI_UseLocDR ];

/// UCI_UseRecordDR
Property UCIUseRecordDR As User.DHCEQUseRecord [ SqlColumnNumber = 2, SqlFieldName = UCI_UseRecordDR ];

/// UCI_PayPrice
Property UCIPayPrice As %Library.Float [ SqlColumnNumber = 28, SqlFieldName = UCI_PayPrice ];

/// UCI_PayAmount
Property UCIPayAmount As %Library.Float [ SqlColumnNumber = 29, SqlFieldName = UCI_PayAmount ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQUseConsumableItem("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="UCI_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="UCI_Amount">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="UCI_CancelDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="UCI_ConsumableItemDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UCI_ExID">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="UCI_ExType">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="UCI_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="UCI_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="UCI_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="UCI_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="UCI_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="UCI_MonthStr">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="UCI_PayAmount">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="UCI_PayPrice">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="UCI_Price">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="UCI_Quantity">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="UCI_QuantityType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="UCI_RelativeQty">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="UCI_ServDetItemDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="UCI_ServDetItemQty">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="UCI_ServiceItemDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="UCI_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="UCI_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="UCI_SumByMonthFlag">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="UCI_UomDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="UCI_UseDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="UCI_UseLocDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="UCI_UseRecordDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQUseConsumableItem</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>UCI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{UCI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCancelDateExID">
<Global>^DHCEQUseConsumableItem</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>UCI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CancelDateExID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{UCI_CancelDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{UCI_UseLocDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{UCI_ExType}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{UCI_ExID}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{UCI_QuantityType}</Expression>
</Subscript>
<Subscript name="8">
<AccessType>sub</AccessType>
<Expression>{UCI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexConsumableItem">
<Global>^DHCEQUseConsumableItem</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UCI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ConsumableItem"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{UCI_ConsumableItemDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{UCI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMonthStr">
<Global>^DHCEQUseConsumableItem</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>UCI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"MonthStr"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{UCI_SumByMonthFlag}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{UCI_SourceType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{UCI_SourceID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{UCI_MonthStr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{UCI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUseDateExID">
<Global>^DHCEQUseConsumableItem</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>UCI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"UseDateExID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{UCI_UseDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{UCI_UseLocDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{UCI_ExType}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{UCI_ExID}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{UCI_QuantityType}</Expression>
</Subscript>
<Subscript name="8">
<AccessType>sub</AccessType>
<Expression>{UCI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUseRecord">
<Global>^DHCEQUseConsumableItem</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UCI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"UseRecord"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{UCI_UseRecordDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{UCI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQUseConsumableItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
