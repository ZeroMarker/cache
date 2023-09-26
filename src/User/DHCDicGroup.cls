Class User.DHCDicGroup Extends (%Persistent, User.Abstract) [ SqlRowIdName = DG_Rowid, SqlTableName = DHC_DicGroup, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// 安全组
Property DGGroupDR As User.SSGroup [ SqlColumnNumber = 2, SqlFieldName = DG_Group_DR ];

/// 物资代码
Property DGCode As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = DG_Code ];

/// 物资名称
Property DGDesc As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = DG_Desc ];

/// 收费类型
Property DGChargeType As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = DG_ChargeType ];

/// 当前售价
Property DGSp As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = DG_Sp ];

/// 招标进价
Property DGPbRp As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = DG_PbRp ];

/// 规格
Property DGSpec As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = DG_Spec ];

/// 类组
Property DGScg As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = DG_Scg ];

/// 库存分类
Property DGStkcat As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = DG_Stkcat ];

/// 品牌
Property DGBrand As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = DG_Brand ];

/// 单位
Property DGUom As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = DG_Uom ];

/// 生产厂家
Property DGPbManf As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = DG_PbManf ];

/// 供应商
Property DGPbVendor As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = DG_PbVendor ];

/// 高值
Property DGHVFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = DG_HVFlag ];

/// 注册证号码
Property DGCertNo As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = DG_CertNo ];

/// 供应科室
Property DGProvLoc As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = DG_ProvLoc ];

/// 物资主图
Property DGPruPic As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = DG_PruPic ];

/// 供应链
Property DGItmSA As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = DG_ItmSA ];

/// 生产厂家注册证
Property DGMCert As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = DG_MCert ];

/// 材料生产许
Property DGMMatProduct As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = DG_MMatProduct ];

/// 工商执照
Property DGMComLic As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = DG_MComLic ];

/// 工商注册号
Property DGMBusinessReg As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 23, SqlFieldName = DG_MBusinessReg ];

/// 组织机构代码
Property DGMOrgCode As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = DG_MOrgCode ];

/// 器械经营许可证
Property DGMMatManLic As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = DG_MMatManLic ];

/// 供应商授权书
Property DGVLic As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = DG_VLic ];

/// 供应商工商执照
Property DGVComlic As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = DG_VComlic ];

/// 供应商税务登记
Property DGVRevreg As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = DG_VRevreg ];

/// 供应商医疗器械经营许可
Property DGVMatmanlic As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 29, SqlFieldName = DG_VMatmanlic ];

/// 供应商医疗器械注册证
Property DGVMatenrol As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 30, SqlFieldName = DG_VMatenrol ];

/// 供应商卫生许可证
Property DGVSanitation As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 31, SqlFieldName = DG_VSanitation ];

/// 供应商组织机构代码
Property DGVOrgcode As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 32, SqlFieldName = DG_VOrgcode ];

/// 	供应商GSP认证
Property DGVGsp As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 33, SqlFieldName = DG_VGsp ];

/// 供应商器械生产许可
Property DGVMatpro As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 34, SqlFieldName = DG_VMatpro ];

/// 供应商生产制造认可表
Property DGVPropermit As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 35, SqlFieldName = DG_VPropermit ];

/// 供应商进口医疗器械注册证
Property DGVImpenrol As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 36, SqlFieldName = DG_VImpenrol ];

/// 供应商进口注册登记表
Property DGVImplic As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 37, SqlFieldName = DG_VImplic ];

/// 供应商代理销售授权书
Property DGVAgentlic As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 38, SqlFieldName = DG_VAgentlic ];

/// 供应商质量承诺书
Property DGVQuality As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 39, SqlFieldName = DG_VQuality ];

/// 供应商业务员授权书
Property DGVSales As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 40, SqlFieldName = DG_VSales ];

/// 入院审批材料
Property DGHospAllowed As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 41, SqlFieldName = DG_HospAllowed ];

/// 物资普通图片
Property DGPruCommonPic As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 42, SqlFieldName = DG_PruCommonPic ];

/// 物资说明书图片
Property DGPruDocumentPic As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 43, SqlFieldName = DG_PruDocumentPic ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCDICGROUP)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DG_Brand">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DG_CertNo">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DG_ChargeType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DG_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DG_Group_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DG_HVFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DG_HospAllowed">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="DG_ItmSA">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DG_MBusinessReg">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DG_MCert">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DG_MComLic">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DG_MMatManLic">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DG_MMatProduct">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DG_MOrgCode">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DG_PbManf">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DG_PbRp">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DG_PbVendor">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DG_ProvLoc">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DG_PruCommonPic">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="DG_PruDocumentPic">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="DG_PruPic">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DG_Scg">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DG_Sp">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DG_Spec">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DG_Stkcat">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DG_Uom">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DG_VAgentlic">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="DG_VComlic">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="DG_VGsp">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="DG_VImpenrol">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="DG_VImplic">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="DG_VLic">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="DG_VMatenrol">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="DG_VMatmanlic">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="DG_VMatpro">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="DG_VOrgcode">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="DG_VPropermit">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="DG_VQuality">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="DG_VRevreg">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="DG_VSales">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="DG_VSanitation">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Global>^DHCDICGROUP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DG_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DG_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGroup">
<Global>^DHCDICGROUP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DG_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"Group"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DG_Group_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DG_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DG_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCDicGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCDICGROUP)
	s oldI = +$g(^mdata("DHCDICGROUP"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCDICGROUP = maxI
	s ^mdata("DHCDICGROUP") = maxI
}

}
