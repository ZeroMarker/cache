Class User.DHCEQConfig Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = C_RowID, SqlTableName = DHC_EQConfig, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// C_Type
Property CType As %Library.String(DISPLAYLIST = ",附件，附属设备,文件,硬件配置,软件配置", MAXLEN = 2, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",0,1,2,3,4") [ SqlColumnNumber = 2, SqlFieldName = C_Type ];

/// C_SourceType
Property CSourceType As %Library.String(DISPLAYLIST = ",验收,设备", MAXLEN = 2, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",1,2") [ SqlColumnNumber = 3, SqlFieldName = C_SourceType ];

/// C_SourceID
Property CSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = C_SourceID ];

/// C_ItemDR
Property CItemDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = C_ItemDR ];

/// C_Item
Property CItem As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = C_Item ];

/// C_Price
Property CPrice As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = C_Price ];

/// C_QuantityNum
Property CQuantityNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = C_QuantityNum ];

/// C_UnitDR
Property CUnitDR As User.DHCEQCUOM [ SqlColumnNumber = 9, SqlFieldName = C_UnitDR ];

/// C_BrandDR
Property CBrandDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = C_BrandDR ];

/// C_ProviderDR
Property CProviderDR As User.DHCEQCVendor [ SqlColumnNumber = 11, SqlFieldName = C_ProviderDR ];

/// C_ManuFactoryDR
Property CManuFactoryDR As User.DHCEQCVendor [ SqlColumnNumber = 12, SqlFieldName = C_ManuFactoryDR ];

/// C_Spec
Property CSpec As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = C_Spec ];

/// C_Model
Property CModel As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = C_Model ];

/// C_Parameters
Property CParameters As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = C_Parameters ];

/// C_GuaranteePeriodNum
Property CGuaranteePeriodNum As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = C_GuaranteePeriodNum ];

/// C_CountryDR
Property CCountryDR As User.CTCountry [ SqlColumnNumber = 17, SqlFieldName = C_CountryDR ];

/// C_LeaveFacNo
Property CLeaveFacNo As %Library.String(MAXLEN = "") [ SqlColumnNumber = 18, SqlFieldName = C_LeaveFacNo ];

/// C_LeaveDate
Property CLeaveDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = C_LeaveDate ];

/// C_Location
Property CLocation As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = C_Location ];

/// C_ReceiverDR
Property CReceiverDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = C_ReceiverDR ];

/// C_MeasureFlag
Property CMeasureFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = C_MeasureFlag ];

/// C_GuaranteeStartDate
Property CGuaranteeStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 23, SqlFieldName = C_GuaranteeStartDate ];

/// C_GuaranteeEndDate
Property CGuaranteeEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 24, SqlFieldName = C_GuaranteeEndDate ];

/// C_DisuseFlag
Property CDisuseFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = C_DisuseFlag ];

/// C_DisuseDate
Property EQDisuseDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 26, SqlFieldName = C_DisuseDate ];

/// C_InvoiceNo
Property CInvoiceNo As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = C_InvoiceNo ];

/// C_OpenFlag
Property COpenFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = C_OpenFlag ];

/// C_Remark
Property CRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = C_Remark ];

/// C_Status
Property CStatus As %Library.String(DISPLAYLIST = ",新增,修改,审核", MAXLEN = 2, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 30, SqlFieldName = C_Status ];

/// C_UpdateUserDR
Property CUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = C_UpdateUserDR ];

/// C_UpdateDate
Property CUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 32, SqlFieldName = C_UpdateDate ];

/// C_UpdateTime
Property CUpdateTime As %Library.Time [ SqlColumnNumber = 33, SqlFieldName = C_UpdateTime ];

/// C_AuditUserDR
Property CAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = C_AuditUserDR ];

/// C_AuditDate
Property CAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 35, SqlFieldName = C_AuditDate ];

/// C_AuditTime
Property CAuditTime As %Library.Time [ SqlColumnNumber = 36, SqlFieldName = C_AuditTime ];

/// C_ServiceHandler
Property CServiceHandler As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = C_ServiceHandler ];

/// C_ServiceTel
Property CServiceTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = C_ServiceTel ];

/// C_RegisterNo 注册证号
Property CRegisterNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = C_RegisterNo ];

/// C_RecomendYears 建议年限
Property CRecomendYears As %Library.Float [ SqlColumnNumber = 40, SqlFieldName = C_RecomendYears ];

/// C_Hold3
Property CHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = C_Hold3 ];

/// C_Hold4
Property CHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = C_Hold4 ];

/// C_Hold5
Property CHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = C_Hold5 ];

/// C_Hold6 是否生成台账标识
Property CHold6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = C_Hold6 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQConfig("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="C_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="C_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="C_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="C_BrandDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="C_CountryDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="C_DisuseDate">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="C_DisuseFlag">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="C_GuaranteeEndDate">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="C_GuaranteePeriodNum">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="C_GuaranteeStartDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="C_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="C_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="C_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="C_Hold6">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="C_InvoiceNo">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="C_Item">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="C_ItemDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="C_LeaveDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="C_LeaveFacNo">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="C_Location">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="C_ManuFactoryDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="C_MeasureFlag">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="C_Model">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="C_OpenFlag">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="C_Parameters">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="C_Price">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="C_ProviderDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="C_QuantityNum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="C_ReceiverDR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="C_RecomendYears">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="C_RegisterNo">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="C_Remark">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="C_ServiceHandler">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="C_ServiceTel">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="C_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="C_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="C_Spec">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="C_Status">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="C_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="C_UnitDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="C_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="C_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="C_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Global>^DHCEQConfig</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>C_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{C_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSourceID">
<Global>^DHCEQConfig</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>C_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SourceID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{C_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{C_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{C_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQConfigS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
