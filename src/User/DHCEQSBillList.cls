Class User.DHCEQSBillList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BL_RowID, SqlTableName = DHC_EQSBillList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// BL_BillDR
Property BLBillDR As User.DHCEQSBill [ SqlColumnNumber = 2, SqlFieldName = BL_BillDR ];

/// BL_RentDR
Property BLRentDR As User.DHCEQSRent [ SqlColumnNumber = 3, SqlFieldName = BL_RentDR ];

/// BL_FromLocDR
Property BLFromLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = BL_FromLocDR ];

/// BL_RequestLocDR
Property BLRequestLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = BL_RequestLocDR ];

/// BL_ShareType
Property BLShareType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = BL_ShareType ];

/// BL_ShareItemDR
Property BLShareItemDR As User.DHCEQSCShareItem [ SqlColumnNumber = 7, SqlFieldName = BL_ShareItemDR ];

/// BL_StartDate
Property BLStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = BL_StartDate ];

/// BL_StartTime
Property BLStartTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = BL_StartTime ];

/// BL_EndDate
Property BLEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = BL_EndDate ];

/// BL_EndTime
Property BLEndTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = BL_EndTime ];

/// BL_Duration
Property BLDuration As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = BL_Duration ];

/// BL_UomQuantity
Property BLUomQuantity As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = BL_UomQuantity ];

/// BL_UOMDR
Property BLUOMDR As User.DHCEQCUOM [ SqlColumnNumber = 14, SqlFieldName = BL_UOMDR ];

/// BL_Price
Property BLPrice As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = BL_Price ];

/// BL_TotalFee
Property BLTotalFee As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = BL_TotalFee ];

/// BL_CostFee
Property BLCostFee As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = BL_CostFee ];

/// BL_InvalidFlag
Property BLInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = BL_InvalidFlag ];

/// BL_Hold1
Property BLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = BL_Hold1 ];

/// BL_Hold2
Property BLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = BL_Hold2 ];

/// BL_Hold3
Property BLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = BL_Hold3 ];

/// BL_Hold4
Property BLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = BL_Hold4 ];

/// BL_Hold5
Property BLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = BL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQSBillList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BL_BillDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BL_CostFee">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="BL_Duration">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BL_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BL_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BL_FromLocDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="BL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="BL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="BL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="BL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="BL_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="BL_Price">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="BL_RentDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BL_RequestLocDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BL_ShareItemDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BL_ShareType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BL_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BL_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BL_TotalFee">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="BL_UOMDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="BL_UomQuantity">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCEQSBillList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{BL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBill">
<Global>^DHCEQSBillList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Bill"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BL_BillDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQSBillListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
