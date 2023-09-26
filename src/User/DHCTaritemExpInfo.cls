Class User.DHCTaritemExpInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = TariExp_RowID, SqlTableName = DHC_TaritemExpInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// TariExp_CJ
Property TariExpManufacturer As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = TariExp_Manufacturer ];

/// TariExp_GG
Property TariExpSpecifications As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = TariExp_Specifications ];

/// TariExp_ZCBH
Property TariExpRegNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = TariExp_RegNum ];

/// TariExp_ZCHYXQ
Property TariExpRegNumValidDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = TariExp_RegNumValidDate ];

/// TariExp_Agent
Property TariExpAgent As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = TariExp_Agent ];

/// TariExp_Purchaseprice
Property TariExpPurchaseprice As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = TariExp_Purchaseprice ];

/// TariExp_BidDate
Property TariExpBidDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = TariExp_BidDate ];

/// TariExp_BidInvitUnit
Property TariExpBidInvitUnit As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = TariExp_BidInvitUnit ];

/// TariExp_Note1
Property TariExpTariCode As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = TariExp_TariCode ];

/// TariExp_Note2
Property TariExpTCTar As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = TariExp_TCTar ];

/// TariExp_Note3
Property TariExpOrdLinkTar As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = TariExp_OrdLinkTar ];

/// TariExp_Tari_Parref
Property TariExpTariParref As User.DHCTarItem [ SqlColumnNumber = 13, SqlFieldName = TariExp_Tari_Parref ];

/// 中日医院使用
/// TariExp_FloatingPrice	浮动价格
Property TariExpFloatingPrice As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = TariExp_FloatingPrice ];

/// TariExp_MinPrice	最小价格
Property TariExpMinPrice As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = TariExp_MinPrice ];

/// TariExp_MaxPrice	最大价格
Property TariExpMaxPrice As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = TariExp_MaxPrice ];

/// TariExp_GFWM	公费W码
Property TariExpGFWM As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = TariExp_GFWM ];

/// TariExp_Spec	规格
Property TariExpSpec As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = TariExp_Spec ];

/// TariExp_BelongLoc	所属科室
Property TariExpBelongLoc As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = TariExp_BelongLoc ];

/// TariExp_UseRange	使用范围
Property TariExpUseRange As %Library.String(DISPLAYLIST = ",ALL,OP,IP", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",A,O,I") [ SqlColumnNumber = 20, SqlFieldName = TariExp_UseRange ];

/// TariExp_ExceptNote	除外内容
Property TariExpExceptNote As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = TariExp_ExceptNote ];

/// TariExp_LimitRange	限定范围
Property TariExpLimitRange As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = TariExp_LimitRange ];

/// TariExp_LimitQty	数量限量
Property TariExpLimitQty As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = TariExp_LimitQty ];

/// TariExp_Remarks1	备注1
Property TariExpRemarks1 As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = TariExp_Remarks1 ];

/// TariExp_Remarks2	备注2
Property TariExpRemarks2 As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = TariExp_Remarks2 ];

/// TariExp_StDate	生效日期
Property TariExpStDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 26, SqlFieldName = TariExp_StDate ];

/// TariExp_EndDate	失效日期
Property TariExpEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 27, SqlFieldName = TariExp_EndDate ];

/// 同仁医院使用
/// TariExp_PrintName	打印名称
Property TariExpPrintName As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = TariExp_PrintName ];

/// 中日医院使用
/// TariExp_PromptContent	提示维护
Property TariExpPromptContent As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = TariExp_PromptContent ];

/// TariExp_StTime	生效时间
Property TariExpStTime As %Library.Time(FORMAT = 1) [ SqlColumnNumber = 30, SqlFieldName = TariExp_StTime ];

/// TariExp_EndTime	失效时间
Property TariExpEndTime As %Library.Time(FORMAT = 1) [ SqlColumnNumber = 31, SqlFieldName = TariExp_EndTime ];

/// TariExp_Factory   生产厂家
Property TariExpFactory As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = TariExp_Factory ];

/// 北京老年医院
/// TariExp_YJPTBM   医价平台编码
Property TariExpYJPTBM As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = TariExp_YJPTBM ];

/// TariExp_WJM   物价码
Property TariExpWJM As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = TariExp_WJM ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCTARIEXPINFO)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="TariExp_Agent">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TariExp_BelongLoc">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="TariExp_BidDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TariExp_BidInvitUnit">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TariExp_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="TariExp_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="TariExp_ExceptNote">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="TariExp_Factory">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="TariExp_FloatingPrice">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="TariExp_GFWM">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="TariExp_LimitQty">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="TariExp_LimitRange">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="TariExp_Manufacturer">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TariExp_MaxPrice">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="TariExp_MinPrice">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="TariExp_OrdLinkTar">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="TariExp_PrintName">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="TariExp_PromptContent">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="TariExp_Purchaseprice">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="TariExp_RegNum">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TariExp_RegNumValidDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TariExp_Remarks1">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="TariExp_Remarks2">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="TariExp_Spec">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="TariExp_Specifications">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TariExp_StDate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="TariExp_StTime">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="TariExp_TCTar">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="TariExp_TariCode">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="TariExp_Tari_Parref">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TariExp_UseRange">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="TariExp_WJM">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="TariExp_YJPTBM">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Global>^DHCTARIEXPINFO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TariExp_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{TariExp_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTari">
<Global>^DHCTARIEXPINFO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TariExp_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TARI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TariExp_Tari_Parref}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TariExp_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCTaritemExpInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
