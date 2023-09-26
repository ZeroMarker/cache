/// * Description: 医保月对账总表(清算)
/// * ClassName: User.INSUBalanceMon
/// * Creator DingSH
/// * Date: 2019-11-15
Class User.INSUBalanceMon Extends %Persistent [ Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Rowid, SqlTableName = INSU_BalanceMon, StorageStrategy = SQLStorage ]
{

/// 医院代码
Property HospitalCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = HospitalCode ];

/// 医保类型
Property INSUType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INSUType ];

/// 社保经办机构（分中心）
Property INSUCenter As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INSUCenter ];

/// 医疗类别
Property Yllb As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = Yllb ];

/// 人员类别
Property Rylb As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = Rylb ];

/// HIS总费用
Property HisTotAmt As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = HisTotAmt ];

/// HIS总人次
Property HisTotCnt As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = HisTotCnt ];

/// HIS基金支付
Property Hisjjzfe As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = Hisjjzfe ];

/// HIS账户支付
Property Hiszhzfe As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = Hiszhzfe ];

/// HIS个人现金支付
Property Hisgrzfe As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = Hisgrzfe ];

/// 医保总费用
Property INSUTotAmt As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = INSUTotAmt ];

/// 医保总人次
Property INSUTotCnt As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = INSUTotCnt ];

/// 医保基金支付
Property INSUjjzfe As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = INSUjjzfe ];

/// 医保账户支付
Property INSUzhzfe As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = INSUzhzfe ];

/// 医保个人现金支付额
Property INSUgrzfe As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = INSUgrzfe ];

/// 对账流水号
Property dzlsh As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = dzlsh ];

/// 交易流水号/业务周期号 东软业务周期号和开始日期与结束日期互斥
Property jylsh As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = jylsh ];

/// 对账状态 N（未对账）Y（已对账清算）E(对账失败)
Property Flag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = Flag ];

/// 对账失败原因
Property Info As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = Info ];

/// 开始日期
Property BeginDate As %Library.Date [ SqlColumnNumber = 21, SqlFieldName = BeginDate ];

/// 结束日期
Property EndDate As %Library.Date [ SqlColumnNumber = 22, SqlFieldName = EndDate ];

/// 对账日期
Property OptDate As %Library.Date [ SqlColumnNumber = 23, SqlFieldName = OptDate ];

/// 对账时间
Property OptTime As %Library.Time [ SqlColumnNumber = 24, SqlFieldName = OptTime ];

/// 操作员
Property sUserDr As User.SSUser [ SqlColumnNumber = 25, SqlFieldName = sUserDr ];

/// 操作员姓名
Property OptName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = OptName ];

/// 对账期号
Property dzqh As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = dzqh ];

/// 医保支付1
Property InsuPay1 As %Float [ SqlColumnNumber = 28, SqlFieldName = InsuPay1 ];

/// 医保支付2
Property InsuPay2 As %Float [ SqlColumnNumber = 29, SqlFieldName = InsuPay2 ];

/// 医保支付3
Property InsuPay3 As %Float [ SqlColumnNumber = 30, SqlFieldName = InsuPay3 ];

/// 医保支付4
Property InsuPay4 As %Float [ SqlColumnNumber = 31, SqlFieldName = InsuPay4 ];

/// 医保支付5
Property InsuPay5 As %Float [ SqlColumnNumber = 32, SqlFieldName = InsuPay5 ];

/// 医保支付6
Property InsuPay6 As %Float [ SqlColumnNumber = 33, SqlFieldName = InsuPay6 ];

/// 医保支付7
Property InsuPay7 As %Float [ SqlColumnNumber = 34, SqlFieldName = InsuPay7 ];

/// 医保支付8
Property InsuPay8 As %Float [ SqlColumnNumber = 35, SqlFieldName = InsuPay8 ];

/// 医保支付9
Property InsuPay9 As %Float [ SqlColumnNumber = 36, SqlFieldName = InsuPay9 ];

/// 医保支付10（误差）
Property InsuPay10 As %Float [ SqlColumnNumber = 37, SqlFieldName = InsuPay10 ];

/// 扩展参数1
Property Zstr01 As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = Zstr01 ];

/// 扩展参数2
Property Zstr02 As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = Zstr02 ];

/// 扩展参数3
Property Zstr03 As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = Zstr03 ];

/// 扩展参数4
Property Zstr04 As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = Zstr04 ];

/// 扩展参数5
Property Zstr05 As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = Zstr05 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCINSUBalanceMon)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="BeginDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="EndDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="Flag">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="HisTotAmt">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="HisTotCnt">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Hisgrzfe">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="Hisjjzfe">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="Hiszhzfe">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="HospitalCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INSUCenter">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INSUTotAmt">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INSUTotCnt">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INSUType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INSUgrzfe">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INSUjjzfe">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INSUzhzfe">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="Info">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="InsuPay1">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="InsuPay10">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="InsuPay2">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="InsuPay3">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="InsuPay4">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="InsuPay5">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="InsuPay6">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="InsuPay7">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="InsuPay8">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="InsuPay9">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="OptDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="OptName">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="OptTime">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="Rylb">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Yllb">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Zstr01">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="Zstr02">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="Zstr03">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="Zstr04">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="Zstr05">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="dzlsh">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="dzqh">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="jylsh">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="sUserDr">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Global>^DHCINSUBalanceMon</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOfBeginDate">
<Global>^DHCINSUBalanceMon</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BeginDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BeginDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfDzlsh">
<Global>^DHCINSUBalanceMon</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"dzlsh"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{dzlsh}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfJylsh">
<Global>^DHCINSUBalanceMon</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"jylsh"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{jylsh}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexOfINSUType">
<Global>^DHCINSUBalanceMon</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INSUType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INSUType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSUBalanceMonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
