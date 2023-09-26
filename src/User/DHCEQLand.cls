Class User.DHCEQLand Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = L_RowID, SqlTableName = DHC_EQLand, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// L_EquipDR
Property LEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = L_EquipDR ];

/// L_Area 权属面积
Property LArea As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = L_Area ];

/// L_LandNo
Property LLandNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = L_LandNo ];

/// L_OwnerFlag 产权形式
Property LOwnerFlag As %Library.String(DISPLAYLIST = ",有产权,无产权,产权待界定", MAXLEN = 4, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",1,2,3") [ SqlColumnNumber = 5, SqlFieldName = L_OwnerFlag ];

/// L_Place 坐落位置
Property LPlace As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = L_Place ];

/// L_SelfUsedArea 自用面积
Property LSelfUsedArea As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = L_SelfUsedArea ];

/// L_IdleArea 闲置面积
Property LIdleArea As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = L_IdleArea ];

/// L_LendingArea 出借面积
Property LLendingArea As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = L_LendingArea ];

/// L_RentArea 出租面积
Property LRentArea As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = L_RentArea ];

/// L_WorkArea 在用面积
Property LWorkArea As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = L_WorkArea ];

/// L_OtherArea 其他面积
Property LOtherArea As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = L_OtherArea ];

/// L_LendCompany 出借公司
Property LLendCompany As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = L_LendCompany ];

/// L_RentCompany 出租公司
Property LRentCompany As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = L_RentCompany ];

/// L_OwnerCertificate 权属证明
Property LOwnerCertificate As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = L_OwnerCertificate ];

/// L_CertificateNo 权属证号
Property LCertificateNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = L_CertificateNo ];

/// L_CertificateDate 发证日期
Property LCertificateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = L_CertificateDate ];

/// L_OwnerKind 权属性质
Property LOwnerKind As %Library.String(DISPLAYLIST = ",国有,集体", MAXLEN = 4, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",1,2") [ SqlColumnNumber = 18, SqlFieldName = L_OwnerKind ];

/// L_CertificateArea 权属面积
Property LCertificateArea As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = L_CertificateArea ];

/// L_OWNER 权属人
Property LOWNER As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = L_OWNER ];

/// L_Hold2
Property LHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = L_Hold2 ];

/// L_Hold3
Property LHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = L_Hold3 ];

/// L_Hold4
Property LHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = L_Hold4 ];

/// L_Hold5
Property LHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = L_Hold5 ];

/*
GR0021 土地资产卡片添加字段
DHC_EQLand		L_SelfUsedFee			自用价值	
DHC_EQLand		L_IdleFee			闲置价值	
DHC_EQLand		L_LendingFee			出借价值	
DHC_EQLand		L_RentFee			出租价值	
DHC_EQLand		L_WorkFee			经营价值	
DHC_EQLand		L_OtherFee			其他价值	
DHC_EQLand		L_SelfOwnFee			独占面积	
DHC_EQLand		L_ShareFee			分摊面积	
DHC_EQLand		L_SubjectsRecorded			入账科目	
DHC_EQLand		L_UserRightType			使用权类型	
DHC_EQLand		L_OwnershipYear			权属年限	
DHC_EQLand		L_GetFee			取得价格
DHC_EQLand		L_SourceType		0:指向验收，1：指向台帐
DHC_EQLand		L_SourceID			指向表的rowid
DHC_EQLand		L_UserRightArea			使用权面积
DHC_EQLand		L_Remark			备注	
*/
Property LSelfUsedFee As %Library.Float [ SqlColumnNumber = 25, SqlFieldName = L_SelfUsedFee ];

Property LIdleFee As %Library.Float [ SqlColumnNumber = 26, SqlFieldName = L_IdleFee ];

Property LLendingFee As %Library.Float [ SqlColumnNumber = 27, SqlFieldName = L_LendingFee ];

Property LRentFee As %Library.Float [ SqlColumnNumber = 28, SqlFieldName = L_RentFee ];

Property LWorkFee As %Library.Float [ SqlColumnNumber = 29, SqlFieldName = L_WorkFee ];

Property LOtherFee As %Library.Float [ SqlColumnNumber = 30, SqlFieldName = L_OtherFee ];

Property LSelfOwnArea As %Library.Float [ SqlColumnNumber = 31, SqlFieldName = L_SelfOwnArea ];

Property LShareArea As %Library.Float [ SqlColumnNumber = 32, SqlFieldName = L_ShareArea ];

Property LSubjectsRecorded As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = L_SubjectsRecorded ];

Property LUserRightType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = L_UserRightType ];

Property LOwnershipYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = L_OwnershipYear ];

Property LGetFee As %Library.Float [ SqlColumnNumber = 36, SqlFieldName = L_GetFee ];

Property LSourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = L_SourceType ];

/// L_SourceID
Property LSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = L_SourceID ];

/// L_UserRightArea
Property LUserRightArea As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = L_UserRightArea ];

/// L_Remark
Property LRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = L_Remark ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQLAND("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="L_Area">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="L_CertificateArea">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="L_CertificateDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="L_CertificateNo">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="L_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="L_GetFee">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="L_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="L_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="L_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="L_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="L_IdleArea">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="L_IdleFee">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="L_LandNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="L_LendCompany">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="L_LendingArea">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="L_LendingFee">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="L_OWNER">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="L_OtherArea">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="L_OtherFee">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="L_OwnerCertificate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="L_OwnerFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="L_OwnerKind">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="L_OwnershipYear">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="L_Place">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="L_Remark">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="L_RentArea">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="L_RentCompany">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="L_RentFee">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="L_SelfOwnArea">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="L_SelfUsedArea">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="L_SelfUsedFee">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="L_ShareArea">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="L_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="L_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="L_SubjectsRecorded">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="L_UserRightArea">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="L_UserRightType">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="L_WorkArea">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="L_WorkFee">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Global>^DHCEQLand</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>L_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{L_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQLand</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>L_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{L_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{L_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLand">
<Global>^DHCEQLand</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{L_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{L_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{L_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLandNo">
<Global>^DHCEQLand</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>L_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"LandNo"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({L_LandNo})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{L_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQLandS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
