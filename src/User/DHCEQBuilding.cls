Class User.DHCEQBuilding Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BD_RowID, SqlTableName = DHC_EQBuilding, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// BD_EquipDR
Property BDEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = BD_EquipDR ];

/// BD_StructDR
Property BDStructDR As User.DHCEQCBuildingStruct [ SqlColumnNumber = 3, SqlFieldName = BD_StructDR ];

/// BD_BuildingArea
Property BDBuildingArea As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = BD_BuildingArea ];

/// BD_UtilizationArea
Property BDUtilizationArea As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = BD_UtilizationArea ];

/// BD_SubArea
Property BDSubArea As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = BD_SubArea ];

/// BD_Place
Property BDPlace As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = BD_Place ];

// Property BDOwnerFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = BD_OwnerFlag ];

/// BD_OwnerFlag 产权形式
Property BDOwnerFlag As %Library.String(DISPLAYLIST = ",有产权,无产权,产权待界定", MAXLEN = 4, SELECTIVITY = "25.00000%", VALUELIST = ",1,2,3") [ SqlColumnNumber = 8, SqlFieldName = BD_OwnerFlag ];

/// BD_SelfUseArea
Property BDSelfUseArea As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = BD_SelfUseArea ];

/// BD_LendingArea
Property BDLendingArea As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = BD_LendingArea ];

/// BD_RentArea
Property BDRentArea As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = BD_RentArea ];

/// BD_WorkArea
Property BDWorkArea As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = BD_WorkArea ];

/// BD_IdleArea
Property BDIdleArea As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = BD_IdleArea ];

/// BD_OtherArea
Property BDOtherArea As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = BD_OtherArea ];

/// BD_LendCompany
Property BDLendCompany As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = BD_LendCompany ];

/// BD_RentCompany
Property BDRentCompany As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = BD_RentCompany ];

/// BD_OwnerCertificate
Property BDOwnerCertificate As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = BD_OwnerCertificate ];

/// BD_CertificateNo
Property BDCertificateNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = BD_CertificateNo ];

/// BD_CertificateDate
Property BDCertificateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = BD_CertificateDate ];

/// BD_FloorNum
Property BDFloorNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = BD_FloorNum ];

/// BD_UnderFloorNum
Property BDUnderFloorNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = BD_UnderFloorNum ];

/// BD_BuildName
Property BDBuildName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = BD_BuildName ];

/// BD_BuildKey
Property BDBuildKey As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = BD_BuildKey ];

/// BD_UseState
Property BDUseState As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = BD_UseState ];

/// BD_FunctionCat
Property BDFunctionCat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = BD_FunctionCat ];

/// BD_FunctionSub
Property BDFunctionSub As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = BD_FunctionSub ];

/// BD_Remark
Property BDRemark As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = BD_Remark ];

/// BD_OpenCheckListDR
Property BDOpenCheckListDR As User.DHCEQOpenCheckList [ SqlColumnNumber = 28, SqlFieldName = BD_OpenCheckListDR ];

// Property BDOwnerKind As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = BD_OwnerKind ];

/// BD_OwnerKind 权属性质
Property BDOwnerKind As %Library.String(DISPLAYLIST = ",国有,集体", MAXLEN = 3, SELECTIVITY = "33.33330%", VALUELIST = ",1,2") [ SqlColumnNumber = 29, SqlFieldName = BD_OwnerKind ];

/// BD_OwnershipYear 权属年限
Property BDOwnershipYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = BD_OwnershipYear ];

/// BD_Owner 房屋所有人
Property BDOwner As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = BD_Owner ];

/// BD_CompletionDate 竣工日期
Property BDCompletionDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 32, SqlFieldName = BD_CompletionDate ];

/// BD_SelfUseFee 自用价值
Property BDSelfUseFee As %Library.Float [ SqlColumnNumber = 33, SqlFieldName = BD_SelfUseFee ];

/// BD_LendingFee 出借价值
Property BDLendingFee As %Library.Float [ SqlColumnNumber = 34, SqlFieldName = BD_LendingFee ];

/// BD_RentFee 出租价值
Property BDRentFee As %Library.Float [ SqlColumnNumber = 35, SqlFieldName = BD_RentFee ];

/// BD_WorkFee 经营价值
Property BDWorkFee As %Library.Float [ SqlColumnNumber = 36, SqlFieldName = BD_WorkFee ];

/// BD_IdleFee 闲置价值
Property BDIdleFee As %Library.Float [ SqlColumnNumber = 37, SqlFieldName = BD_IdleFee ];

/// BD_OtherFee 其他价值
Property BDOtherFee As %Library.Float [ SqlColumnNumber = 38, SqlFieldName = BD_OtherFee ];

/// BD_AllotArea
Property BDAllotArea As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = BD_AllotArea ];

/// BD_LandArea
Property BDLandArea As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = BD_LandArea ];

/// BD_RightTypeDR 使用权类型
Property BDRightTypeDR As User.DHCEQCRightType [ SqlColumnNumber = 41, SqlFieldName = BD_RightTypeDR ];

/// EQ_DangerousArea
Property BDDangerousArea As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = BD_DangerousArea ];

/// BD_HeatArea
Property BDHeatArea As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = BD_HeatArea ];

/// BD_Hold1
Property BDHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = BD_Hold1 ];

/// BD_Hold2
Property BDHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = BD_Hold2 ];

/// BD_Hold3
Property BDHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = BD_Hold3 ];

/// BD_Hold4
Property BDHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = BD_Hold4 ];

/// BD_Hold5
Property BDHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 48, SqlFieldName = BD_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQBuilding("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BD_AllotArea">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="BD_BuildKey">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="BD_BuildName">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="BD_BuildingArea">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BD_CertificateDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="BD_CertificateNo">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="BD_CompletionDate">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="BD_DangerousArea">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="BD_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BD_FloorNum">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="BD_FunctionCat">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="BD_FunctionSub">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="BD_HeatArea">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="BD_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="BD_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="BD_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="BD_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="BD_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="BD_IdleArea">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="BD_IdleFee">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="BD_LandArea">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="BD_LendCompany">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="BD_LendingArea">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BD_LendingFee">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="BD_OpenCheckListDR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="BD_OtherArea">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="BD_OtherFee">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="BD_Owner">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="BD_OwnerCertificate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="BD_OwnerFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BD_OwnerKind">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="BD_OwnershipYear">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="BD_Place">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BD_Remark">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="BD_RentArea">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BD_RentCompany">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="BD_RentFee">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="BD_RightTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="BD_SelfUseArea">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BD_SelfUseFee">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="BD_StructDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BD_SubArea">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BD_UnderFloorNum">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="BD_UseState">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="BD_UtilizationArea">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BD_WorkArea">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BD_WorkFee">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Global>^DHCEQBuilding</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{BD_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBuildKey">
<Global>^DHCEQBuilding</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>{BD_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BuildKey"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BD_BuildKey}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCertificateNo">
<Global>^DHCEQBuilding</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CertificateNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BD_CertificateNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquipDR">
<Global>^DHCEQBuilding</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EquipDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BD_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQBuilding</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OpenCheckList"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BD_OpenCheckListDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQBuildingS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
