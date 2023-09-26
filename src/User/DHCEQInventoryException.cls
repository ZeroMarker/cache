Class User.DHCEQInventoryException Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IE_RowID, SqlTableName = DHC_EQInventoryException, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// IE_InventoryDR
Property IEInventoryDR As User.DHCEQInventory [ SqlColumnNumber = 2, SqlFieldName = IE_InventoryDR ];

/// IE_EquipName
Property IEEquipName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = IE_EquipName ];

/// IE_EquipNo
Property IEEquipNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = IE_EquipNo ];

/// IE_OriginalFee
Property IEOriginalFee As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = IE_OriginalFee ];

/// IE_Model
Property IEModel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = IE_Model ];

/// IE_StartDate
Property IEStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = IE_StartDate ];

/// IE_TransAssetDate
Property IETransAssetDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = IE_TransAssetDate ];

/// IE_UserLocDR
Property IEUserLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = IE_UserLocDR ];

/// IE_StoreLocDR
Property IEStoreLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = IE_StoreLocDR ];

/// IE_ManuFactoryDR
Property IEManuFactoryDR As User.DHCEQCVendor [ SqlColumnNumber = 11, SqlFieldName = IE_ManuFactoryDR ];

/// IE_ProviderDR
Property IEProviderDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = IE_ProviderDR ];

/// IE_LocationDR
Property IELocationDR As User.DHCEQCLocation [ SqlColumnNumber = 13, SqlFieldName = IE_LocationDR ];

/// IE_LeaveFactoryNo
Property IELeaveFactoryNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = IE_LeaveFactoryNo ];

/// IE_Date
Property IEDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = IE_Date ];

/// IE_Time
Property IETime As %Library.Time [ SqlColumnNumber = 16, SqlFieldName = IE_Time ];

/// IE_Remark
Property IERemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = IE_Remark ];

/// IE_Hold1
Property IEHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = IE_Hold1 ];

/// IE_Hold2
Property IEHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = IE_Hold2 ];

/// IE_Hold3
Property IEHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = IE_Hold3 ];

/// IE_Hold4
Property IEHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = IE_Hold4 ];

/// IE_Hold5
Property IEHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = IE_Hold5 ];

/// IE_UseStatus
Property IEUseStatus As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",在用,拆封未使用,未拆封,积压闲置,已盘亏", MAXLEN = 2, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",1,2,3,4,5") [ SqlColumnNumber = 23, SqlFieldName = IE_UseStatus ];

/// IE_Purpose
Property IEPurpose As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",医院日常使用,储备物资", MAXLEN = 2, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",1,2") [ SqlColumnNumber = 24, SqlFieldName = IE_Purpose ];

/// IE_ActerEquipDR
Property IEActerEquipDR As User.DHCEQEquip [ SqlColumnNumber = 25, SqlFieldName = IE_ActerEquipDR ];

/// IE_Brand
Property IEBrand As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = IE_Brand ];

/// IE_KeeperDR
Property IEKeeperDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = IE_KeeperDR ];

/// IE_ProfitReasonDR
Property IEProfitReasonDR As User.DHCEQCProfitReason [ SqlColumnNumber = 28, SqlFieldName = IE_ProfitReasonDR ];

/// IE_EquipTypeDR
Property IEEquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 29, SqlFieldName = IE_EquipTypeDR ];

/// IE_DisposeStatus
Property IEDisposeStatus As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",账物一致,科室不符,盘亏,待查找,有报废单,盘盈,计划外科室不符", MAXLEN = 2, SELECTIVITY = "12.5%", TRUNCATE = 1, VALUELIST = ",1,2,3,4,5,6,7") [ SqlColumnNumber = 30, SqlFieldName = IE_DisposeStatus ];

/// IE_DisposeResult
Property IEDisposeResult As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",账物一致,盘盈入库,科室不符已转科,科室不符不处理,盘亏已减少,报废", MAXLEN = 2, SELECTIVITY = "14.2857%", TRUNCATE = 1, VALUELIST = ",1,2,3,4,5,6") [ SqlColumnNumber = 31, SqlFieldName = IE_DisposeResult ];

/// IE_Status
Property IEStatus As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",科室不符,盘盈,计划外科室不符", MAXLEN = 2, SELECTIVITY = "25%", TRUNCATE = 1, VALUELIST = ",1,2,3") [ SqlColumnNumber = 32, SqlFieldName = IE_Status ];

/// IE_UserDR
Property IEUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = IE_UserDR ];

/// IE_BussType
Property IEBussType As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",报废,减少,维修,验收,入库,数据调整,转移", MAXLEN = 2, SELECTIVITY = "12.5%", TRUNCATE = 1, VALUELIST = ",34,23,31,11,21,61,22") [ SqlColumnNumber = 34, SqlFieldName = IE_BussType ];

/// IE_BussID
Property IEBussID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = IE_BussID ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQInventoryException("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IE_ActerEquipDR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="IE_Brand">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="IE_BussID">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="IE_BussType">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="IE_Date">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="IE_DisposeResult">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="IE_DisposeStatus">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="IE_EquipName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IE_EquipNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IE_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="IE_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="IE_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="IE_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="IE_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="IE_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="IE_InventoryDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IE_KeeperDR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="IE_LeaveFactoryNo">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="IE_LocationDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IE_ManuFactoryDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IE_Model">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IE_OriginalFee">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IE_ProfitReasonDR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="IE_ProviderDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IE_Purpose">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="IE_Remark">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="IE_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IE_Status">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="IE_StoreLocDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IE_Time">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="IE_TransAssetDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IE_UseStatus">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="IE_UserDR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="IE_UserLocDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCEQInventoryException</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IE_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{IE_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBussID">
<Global>^DHCEQInventoryException</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BussID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IE_BussType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IE_BussID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquipNo">
<Global>^DHCEQInventoryException</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EquipNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IE_EquipNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInventory">
<Global>^DHCEQInventoryException</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IE_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Inventory"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{IE_InventoryDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{IE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStoreLoc">
<Global>^DHCEQInventoryException</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IE_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"StoreLoc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{IE_InventoryDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{IE_StoreLocDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{IE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQInventoryExceptionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
