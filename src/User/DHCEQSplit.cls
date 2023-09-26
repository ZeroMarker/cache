Class User.DHCEQSplit Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = S_RowID, SqlTableName = DHC_EQSplit, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index SRequestNoUnqIdx1 On SRequestNo [ Unique ];

/// S_RequestNo
Property SRequestNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = S_RequestNo ];

/// S_EquipDR
Property SEquipDR As User.DHCEQEquip [ SqlColumnNumber = 3, SqlFieldName = S_EquipDR ];

/// S_OriginalFee
Property SOriginalFee As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = S_OriginalFee ];

/// S_DepreTotalFee
Property SDepreTotalFee As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = S_DepreTotalFee ];

/// S_NetFee
Property SNetFee As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = S_NetFee ];

/// S_LimitYearsNum
Property SLimitYearsNum As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = S_LimitYearsNum ];

/// S_DepreMethodDR
Property SDepreMethodDR As User.DHCEQCDepreMethod [ SqlColumnNumber = 8, SqlFieldName = S_DepreMethodDR ];

/// S_EquipTypeDR
Property SEquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 9, SqlFieldName = S_EquipTypeDR ];

/// S_StatCatDR
Property SStatCatDR As User.DHCEQCStatCat [ SqlColumnNumber = 10, SqlFieldName = S_StatCatDR ];

/// S_EquipCatDR
Property SEquipCatDR As User.DHCEQCEquipeCat [ SqlColumnNumber = 11, SqlFieldName = S_EquipCatDR ];

/// S_LocDR
Property SLocDR As User.DHCEQCDepartment [ SqlColumnNumber = 12, SqlFieldName = S_LocDR ];

/// S_OriginDR
Property SOriginDR As User.DHCEQCOrigin [ SqlColumnNumber = 13, SqlFieldName = S_OriginDR ];

/// S_EquipStatus
Property SEquipStatus As %Library.String(DISPLAYLIST = ",在库,启用,停用,报废", MAXLEN = 4, SELECTIVITY = "20%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 14, SqlFieldName = S_EquipStatus ];

/// S_TransAssetDate
Property STransAssetDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = S_TransAssetDate ];

/// S_StartDate
Property SStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = S_StartDate ];

/// S_ProviderDR
Property SProviderDR As User.DHCEQCVendor [ SqlColumnNumber = 17, SqlFieldName = S_ProviderDR ];

/// S_ManuFactoryDR
Property SManuFactoryDR As User.DHCEQCVendor [ SqlColumnNumber = 18, SqlFieldName = S_ManuFactoryDR ];

/// S_ModelDR
Property SModelDR As User.DHCEQCModel [ SqlColumnNumber = 19, SqlFieldName = S_ModelDR ];

/// S_IsKeep
Property SIsKeep As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = S_IsKeep ];

/// S_Reason
Property SReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = S_Reason ];

/// S_Remark
Property SRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = S_Remark ];

/// S_Status
Property SStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 4, SELECTIVITY = "20%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 23, SqlFieldName = S_Status ];

/// S_RequestUserDR
Property SRequestUserDR As User.DHCEQCUser [ SqlColumnNumber = 24, SqlFieldName = S_RequestUserDR ];

/// S_RequestDate
Property SRequestDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 25, SqlFieldName = S_RequestDate ];

/// S_AuditUserDR
Property SAuditUserDR As User.DHCEQCUser [ SqlColumnNumber = 26, SqlFieldName = S_AuditUserDR ];

/// S_AuditDate
Property SAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 27, SqlFieldName = S_AuditDate ];

/// S_InvalidFlag
Property SInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = S_InvalidFlag ];

/// S_SplitOriginalFee
Property SSplitOriginalFee As %Library.Float [ SqlColumnNumber = 29, SqlFieldName = S_SplitOriginalFee ];

/// S_SplitDepreTotalFee
Property SSplitDepreTotalFee As %Library.Float [ SqlColumnNumber = 30, SqlFieldName = S_SplitDepreTotalFee ];

/// S_SplitNetFee
Property SSplitNetFee As %Library.Float [ SqlColumnNumber = 31, SqlFieldName = S_SplitNetFee ];

/// S_Job
Property SJob As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = S_Job ];

/// S_Hold2
Property SHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = S_Hold2 ];

/// S_Hold3
Property SHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = S_Hold3 ];

/// S_Hold4
Property SHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = S_Hold4 ];

/// S_Hold5
Property SHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = S_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQSplit("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="S_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="S_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="S_DepreMethodDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="S_DepreTotalFee">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="S_EquipCatDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="S_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="S_EquipStatus">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="S_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="S_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="S_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="S_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="S_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="S_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="S_IsKeep">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="S_Job">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="S_LimitYearsNum">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="S_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="S_ManuFactoryDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="S_ModelDR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="S_NetFee">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="S_OriginDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="S_OriginalFee">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="S_ProviderDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="S_Reason">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="S_Remark">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="S_RequestDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="S_RequestNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="S_RequestUserDR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="S_SplitDepreTotalFee">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="S_SplitNetFee">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="S_SplitOriginalFee">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="S_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="S_StatCatDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="S_Status">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="S_TransAssetDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Global>^DHCEQSplit</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>S_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{S_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQSplit</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>S_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EquipDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{S_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{S_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquipType">
<Global>^DHCEQSplit</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>S_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EquipTypeDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{S_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{S_EquipDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{S_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRequestNo">
<Global>^DHCEQSplit</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>S_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RequestNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{S_RequestNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{S_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQSplitS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
