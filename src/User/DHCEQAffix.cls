Class User.DHCEQAffix Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AF_RowID, SqlTableName = DHC_EQAffix, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// AF_AddDate
Property AFAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = AF_AddDate ];

/// AF_AffixCatDR
Property AFAffixCatDR As User.DHCEQCAffixCat [ SqlColumnNumber = 4, SqlFieldName = AF_AffixCatDR ];

/// AF_AffixDR
Property AFAffixDR As User.DHCEQCAffix [ SqlColumnNumber = 3, SqlFieldName = AF_AffixDR ];

/// AF_ChangeAccountAddDR
Property AFChangeAccountAddDR As User.DHCEQChangeAccount [ SqlColumnNumber = 23, SqlFieldName = AF_ChangeAccountAddDR ];

/// AF_ChangeAccountReduceDR
Property AFChangeAccountReduceDR As User.DHCEQChangeAccount [ SqlColumnNumber = 24, SqlFieldName = AF_ChangeAccountReduceDR ];

/// AF_CheckListDR
Property AFCheckListDR As User.DHCEQOpenCheckList [ SqlColumnNumber = 20, SqlFieldName = AF_CheckListDR ];

/// AF_CurrencyDR
Property AFCurrencyDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = AF_CurrencyDR ];

/// AF_DisuseFlag
Property AFDisuseFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = AF_DisuseFlag ];

/// AF_EquipDR
Property AFEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = AF_EquipDR ];

/// AF_GuaranteeEndDate
Property AFGuaranteeEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 27, SqlFieldName = AF_GuaranteeEndDate ];

/// AF_GuaranteeStartDate
Property AFGuaranteeStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 26, SqlFieldName = AF_GuaranteeStartDate ];

/// AF_Hold1 医疗注册证
Property AFHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = AF_Hold1 ];

/// AF_Hold2 建议使用年限
Property AFHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = AF_Hold2 ];

/// AF_Hold3
Property AFHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = AF_Hold3 ];

/// AF_Hold4
Property AFHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = AF_Hold4 ];

/// AF_Hold5
Property AFHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = AF_Hold5 ];

/// AF_InvalidFlag
Property AFInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = AF_InvalidFlag ];

/// AF_InvoiceNo
Property AFInvoiceNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = AF_InvoiceNo ];

/// AF_LeaveFacNo
Property AFLeaveFacNo As %Library.String(MAXLEN = "") [ SqlColumnNumber = 10, SqlFieldName = AF_LeaveFacNo ];

/// AF_LeaveDate
Property AFLeaveDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 30, SqlFieldName = AF_LeaveDate ];

/// AF_ManuFactoryDR
Property AFManuFactoryDR As User.DHCEQCVendor [ SqlColumnNumber = 7, SqlFieldName = AF_ManuFactoryDR ];

/// AF_OldRowID
Property AFOldRowID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = AF_OldRowID ];

/// AF_OperFlag
Property AFOperFlag As %Library.String(DISPLAYLIST = ",新增,更新,删除", MAXLEN = 2, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 22, SqlFieldName = AF_OperFlag ];

/// AF_PartModel
Property AFPartModel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = AF_PartModel ];

/// AF_PartSpec
Property AFPartSpec As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = AF_PartSpec ];

/// AF_PriceFee
Property AFPriceFee As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = AF_PriceFee ];

/// AF_ProviderDR
Property AFProviderDR As User.DHCEQCVendor [ SqlColumnNumber = 25, SqlFieldName = AF_ProviderDR ];

/// AF_QuantityNum
Property AFQuantityNum As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = AF_QuantityNum ];

/// AF_ReceiverDR
Property AFReceiverDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = AF_ReceiverDR ];

/// AF_Remark
Property AFRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = AF_Remark ];

/// AF_SplitFlag
Property AFSplitFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = AF_SplitFlag ];

/// AF_UpdateDate
Property AFUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = AF_UpdateDate ];

/// AF_UpdateTime
Property AFUpdateTime As %Library.Time [ SqlColumnNumber = 19, SqlFieldName = AF_UpdateTime ];

/// AF_UpdateUserDR
Property AFUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = AF_UpdateUserDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQAffix("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AF_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AF_AffixCatDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AF_AffixDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AF_ChangeAccountAddDR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="AF_ChangeAccountReduceDR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="AF_CheckListDR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="AF_CurrencyDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AF_DisuseFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AF_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AF_GuaranteeEndDate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="AF_GuaranteeStartDate">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="AF_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="AF_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="AF_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="AF_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="AF_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="AF_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AF_InvoiceNo">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="AF_LeaveDate">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="AF_LeaveFacNo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AF_ManuFactoryDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AF_OldRowID">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="AF_OperFlag">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="AF_PartModel">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AF_PartSpec">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AF_PriceFee">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AF_ProviderDR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="AF_QuantityNum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AF_ReceiverDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AF_Remark">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AF_SplitFlag">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="AF_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="AF_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="AF_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Global>^DHCEQAffix</Global>
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
<SQLMap name="IndexChangeAccountAdd">
<Global>^DHCEQAffix</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ChangeAccountAdd"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{AF_ChangeAccountAddDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexChangeAccountReduce">
<Global>^DHCEQAffix</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ChangeAccountReduce"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{AF_ChangeAccountReduceDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCheckList">
<Global>^DHCEQAffix</Global>
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
<Expression>"CheckListDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AF_CheckListDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQAffix</Global>
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
<SQLMap name="IndexOldRowID">
<Global>^DHCEQAffix</Global>
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
<Expression>"OldRowID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AF_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AF_OldRowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQAffixS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
