Class User.DHCEQInventoryList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IL_RowID, SqlTableName = DHC_EQInventoryList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// IL_InventoryDR
Property ILInventoryDR As User.DHCEQInventory [ SqlColumnNumber = 2, SqlFieldName = IL_InventoryDR ];

/// IL_BillEquipDR
Property ILBillEquipDR As User.DHCEQEquip [ SqlColumnNumber = 3, SqlFieldName = IL_BillEquipDR ];

/// IL_ActerEquipDR
Property ILActerEquipDR As User.DHCEQEquip [ SqlColumnNumber = 4, SqlFieldName = IL_ActerEquipDR ];

/// IL_BillStoreLocDR
Property ILBillStoreLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = IL_BillStoreLocDR ];

/// IL_BillUseLocDR
Property ILBillUseLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = IL_BillUseLocDR ];

/// IL_ActerStoreLocDR
Property ILActerStoreLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = IL_ActerStoreLocDR ];

/// IL_ActerUseLocDR
Property ILActerUseLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = IL_ActerUseLocDR ];

/// IL_BillOriginalFee
Property ILBillOriginalFee As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = IL_BillOriginalFee ];

/// IL_BillNetFee
Property ILBillNetFee As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = IL_BillNetFee ];

/// IL_BillDepreTotalFee
Property ILBillDepreTotalFee As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = IL_BillDepreTotalFee ];

/// IL_UserDR
Property ILUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = IL_UserDR ];

/// IL_Date
Property ILDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = IL_Date ];

/// IL_Time
Property ILTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = IL_Time ];

/// IL_Status
Property ILStatus As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",账物一致,科室不符,盘亏,待查找,有报废单", MAXLEN = 2, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",1,2,3,4,5") [ SqlColumnNumber = 15, SqlFieldName = IL_Status ];

/// IL_Remark
Property ILRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = IL_Remark ];

/// IL_Hold1
Property ILHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = IL_Hold1 ];

/// IL_Hold2
Property ILHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = IL_Hold2 ];

/// IL_Hold3
Property ILHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = IL_Hold3 ];

/// IL_Hold4
Property ILHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = IL_Hold4 ];

/// IL_Hold5
Property ILHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = IL_Hold5 ];

/// IL_Condition
Property ILCondition As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",完好,待报废,有缺损,盘亏", MAXLEN = 2, SELECTIVITY = "20%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 22, SqlFieldName = IL_Condition ];

/// IL_ProcessFlag
Property ILProcessFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",未处理,处理中,处理完成", MAXLEN = 2, SELECTIVITY = "25%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 23, SqlFieldName = IL_ProcessFlag ];

/// IL_BussType
Property ILBussType As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",报废,减少,维修,验收,入库,数据调整,转移", MAXLEN = 2, SELECTIVITY = "12.5%", TRUNCATE = 1, VALUELIST = ",34,23,31,11,21,61,22") [ SqlColumnNumber = 24, SqlFieldName = IL_BussType ];

/// IL_BussID
Property ILBussID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = IL_BussID ];

/// LI_UseStatus
Property LIUseStatus As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",在用,拆封未使用,未拆封,积压闲置,已盘亏", MAXLEN = 2, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",1,2,3,4,5") [ SqlColumnNumber = 26, SqlFieldName = LI_UseStatus ];

/// LI_Purpose
Property LIPurpose As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",医院日常使用,储备物资", MAXLEN = 2, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",1,2") [ SqlColumnNumber = 27, SqlFieldName = LI_Purpose ];

/// LI_LossReasonDR
Property LILossReasonDR As User.DHCEQCLossReason [ SqlColumnNumber = 28, SqlFieldName = LI_LossReasonDR ];

/// IL_DisposeStatus
Property ILDisposeStatus As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",账物一致,科室不符,盘亏,待查找,有报废单,盘盈,计划外科室不符", MAXLEN = 2, SELECTIVITY = "12.5%", TRUNCATE = 1, VALUELIST = ",1,2,3,4,5,6,7") [ SqlColumnNumber = 29, SqlFieldName = IL_DisposeStatus ];

/// IL_DisposeResult
Property ILDisposeResult As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",账物一致,盘盈入库,科室不符已转科,科室不符不处理,盘亏已减少,报废", MAXLEN = 2, SELECTIVITY = "14.2857%", TRUNCATE = 1, VALUELIST = ",1,2,3,4,5,6") [ SqlColumnNumber = 30, SqlFieldName = IL_DisposeResult ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQInventoryList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IL_ActerEquipDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IL_ActerStoreLocDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IL_ActerUseLocDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IL_BillDepreTotalFee">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IL_BillEquipDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IL_BillNetFee">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IL_BillOriginalFee">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IL_BillStoreLocDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IL_BillUseLocDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IL_BussID">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="IL_BussType">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="IL_Condition">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="IL_Date">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IL_DisposeResult">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="IL_DisposeStatus">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="IL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="IL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="IL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="IL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="IL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="IL_InventoryDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IL_ProcessFlag">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="IL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="IL_Status">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="IL_Time">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="IL_UserDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="LI_LossReasonDR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="LI_Purpose">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="LI_UseStatus">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Global>^DHCEQInventoryList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{IL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActerEquip">
<Global>^DHCEQInventoryList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ActerEquip"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{IL_InventoryDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{IL_ActerEquipDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{IL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBillEquip">
<Global>^DHCEQInventoryList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"BillEquip"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{IL_InventoryDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{IL_BillEquipDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{IL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBussID">
<Global>^DHCEQInventoryList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BussID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IL_BussType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IL_BussID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInventory">
<Global>^DHCEQInventoryList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IL_RowID</Field>
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
<Expression>{IL_InventoryDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{IL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStoreLoc">
<Global>^DHCEQInventoryList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>IL_RowID</Field>
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
<Expression>{IL_InventoryDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{IL_BillStoreLocDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{IL_BillEquipDR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{IL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQInventoryListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
