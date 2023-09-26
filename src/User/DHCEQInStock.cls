Class User.DHCEQInStock Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IS_RowID, SqlTableName = DHC_EQInStock, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index ISInStockNoUnqIdx1 On ISInStockNo [ Unique ];

/// IS_AuditDate
Property ISAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = IS_AuditDate ];

/// IS_AuditUserDR
Property ISAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = IS_AuditUserDR ];

/// IS_BillAuditDate
Property ISBillAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = IS_BillAuditDate ];

/// IS_BillAuditUserDR
Property ISBillAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = IS_BillAuditUserDR ];

/// IS_BuyLocDR
Property ISBuyLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = IS_BuyLocDR ];

/// IS_BuyUserDR
Property ISBuyUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = IS_BuyUserDR ];

/// IS_CancelDate
Property ISCancelDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 24, SqlFieldName = IS_CancelDate ];

/// IS_CancelTime
Property ISCancelTime As %Library.Time [ SqlColumnNumber = 25, SqlFieldName = IS_CancelTime ];

/// IS_CancelUser
Property ISCancelUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = IS_CancelUser ];

/// IS_EquipTypeDR
Property ISEquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 21, SqlFieldName = IS_EquipTypeDR ];

/// IS_FromDeptDR
Property ISFromDeptDR As User.DHCEQCFromToDept [ SqlColumnNumber = 17, SqlFieldName = IS_FromDeptDR ];

/// IS_Hold1
Property ISHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = IS_Hold1 ];

/// IS_Hold2
Property ISHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = IS_Hold2 ];

/// IS_Hold3
Property ISHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = IS_Hold3 ];

/// IS_Hold4
Property ISHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = IS_Hold4 ];

/// IS_Hold5
Property ISHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = IS_Hold5 ];

/// IS_InDate
Property ISInDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = IS_InDate ];

/// IS_InStockNo
Property ISInStockNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = IS_InStockNo ];

/// IS_InvalidFlag
Property ISInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = IS_InvalidFlag ];

/// IS_LocDR
Property ISLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = IS_LocDR ];

/// IS_OriginDR
Property ISOriginDR As User.DHCEQCOrigin [ SqlColumnNumber = 16, SqlFieldName = IS_OriginDR ];

/// IS_ProviderDR
Property ISProviderDR As User.DHCEQCVendor [ SqlColumnNumber = 18, SqlFieldName = IS_ProviderDR ];

/// IS_RejectDate
Property ISRejectDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = IS_RejectDate ];

/// IS_RejectReason
Property ISRejectReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = IS_RejectReason ];

/// IS_RejectReasonDR
Property ISRejectReasonDR As User.DHCEQCRejectReason [ SqlColumnNumber = 4, SqlFieldName = IS_RejectReasonDR ];

/// IS_RejectUserDR
Property ISRejectUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = IS_RejectUserDR ];

/// IS_Remark
Property ISRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = IS_Remark ];

/// IS_RequestDate
Property ISRequestDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = IS_RequestDate ];

/// IS_RequestUserDR
Property ISRequestUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = IS_RequestUserDR ];

/// IS_StatCatDR
Property ISStatCatDR As User.DHCEQCStatCat [ SqlColumnNumber = 22, SqlFieldName = IS_StatCatDR ];

/// IS_Status
Property ISStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 11, SqlFieldName = IS_Status ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQInStock("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IS_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IS_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IS_BillAuditDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="IS_BillAuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IS_BuyLocDR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="IS_BuyUserDR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="IS_CancelDate">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="IS_CancelTime">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="IS_CancelUser">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="IS_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="IS_FromDeptDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="IS_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="IS_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="IS_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="IS_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="IS_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="IS_InDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IS_InStockNo">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="IS_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="IS_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IS_OriginDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="IS_ProviderDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="IS_RejectDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IS_RejectReason">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="IS_RejectReasonDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IS_RejectUserDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IS_Remark">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IS_RequestDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IS_RequestUserDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IS_StatCatDR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="IS_Status">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCEQInStock</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{IS_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAuditDateStat">
<Global>^DHCEQInStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AuditDateStat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IS_AuditDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{IS_StatCatDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBillDate">
<Global>^DHCEQInStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BillDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IS_BillAuditDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{IS_StatCatDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInStockNo">
<Global>^DHCEQInStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InStockNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IS_InStockNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCEQInStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>IS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{IS_LocDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{IS_BillAuditDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>+{IS_StatCatDR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{IS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexProvider">
<Global>^DHCEQInStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Provider"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IS_ProviderDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeDate">
<Global>^DHCEQInStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TypeDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{IS_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{IS_BillAuditDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{IS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQInStockS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
