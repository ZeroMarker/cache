/// * ClassName: User.INSUBalanceUnusual
/// * Description: 医保对账差异明细表
/// * Creator WenYX
/// * Date: 2019-11-15
Class User.INSUBalanceUnusual Extends %Persistent [ Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Rowid, SqlTableName = INSU_BalanceUnusual, StorageStrategy = SQLStorage ]
{

/// HospitalCode 医院代码
Property HospitalCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = HospitalCode ];

/// DivideDr 指针User.INSUDivide
Property DivideDr As User.INSUDivide [ SqlColumnNumber = 3, SqlFieldName = DivideDr ];

/// InsuBalanceDayDr 指针User.INSUBalanceDay 日对账记录
Property InsuBalanceDayDr As User.INSUBalanceDay [ SqlColumnNumber = 4, SqlFieldName = InsuBalanceDayDr ];

/// INSUBalanceMonDr 指针User.INSUBalanceMon  月对账记录
Property InsuBalanceMonDr As User.INSUBalanceMon [ SqlColumnNumber = 5, SqlFieldName = InsuBalanceMonDr ];

/// INSUCenterSubDr 指针User.INSUCenterSub
Property InsuCenterSubDr As User.INSUCenterSub [ SqlColumnNumber = 6, SqlFieldName = InsuCenterSubDr ];

/// INSUType 医保类型
Property InsuType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = InsuType ];

/// INSUYllb 医疗类别
Property InsuYllb As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = InsuYllb ];

/// INSURylb 人员类别
Property InsuRylb As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = InsuRylb ];

/// DivType 结算类型	I正交易/R负交易
Property DivType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DivType ];

/// Name 姓名
Property Name As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = Name ];

/// INSUNo 医保号
Property InsuNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = InsuNo ];

/// ADMDr 就诊号
Property ADMDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = ADMDr ];

/// LocName 科室名称
Property LocName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = LocName ];

/// bcbxf HIS总费用
Property HisTotAmt As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = HisTotAmt ];

/// jjzfe HIS基金支付
Property HisJjzfe As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = HisJjzfe ];

/// zhzfe HIS帐户支付额
Property HisZhzfe As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = HisZhzfe ];

/// grzfe HIS个人现金支付额
Property HisGrzfe As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = HisGrzfe ];

/// INSUTotAmt 医保总费用
Property InsuTotAmt As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = InsuTotAmt ];

/// INSUjjzfe 医保基金支付额
Property InsuJjzfe As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = InsuJjzfe ];

/// INSUzhzfe 医保帐户支付额
Property InsuZhzfe As %Library.Float [ SqlColumnNumber = 21, SqlFieldName = InsuZhzfe ];

/// INSUgrzfe 医保个人现金支付额
Property InsuGrzfe As %Library.Float [ SqlColumnNumber = 22, SqlFieldName = InsuGrzfe ];

/// zylsh 登记流水号
Property zylsh As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = zylsh ];

/// djlsh 单据/结算流水号
Property djlsh As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = djlsh ];

/// jylsh 交易流水号
Property jylsh As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = jylsh ];

/// Flag 对账状态	String	0（HIS有数据医保没有）1（医保有数据HIS没有）
Property Flag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = Flag ];

/// OptDate 对账日期
Property OptDate As %Library.Date [ SqlColumnNumber = 27, SqlFieldName = OptDate ];

/// OptTime 对账时间
Property OptTime As %Library.Time [ SqlColumnNumber = 28, SqlFieldName = OptTime ];

/// sUserDr 操作员User.SSUser
Property sUserDr As User.SSUser [ SqlColumnNumber = 29, SqlFieldName = sUserDr ];

/// OptName 登记流水号
Property OptName As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = OptName ];

/// DivDate 收费日期
Property DivDate As %Library.Date [ SqlColumnNumber = 31, SqlFieldName = DivDate ];

/// DivTime 收费时间
Property DivTime As %Library.Time [ SqlColumnNumber = 32, SqlFieldName = DivTime ];

/// AdmDate 入院日期
Property AdmDate As %Library.Date [ SqlColumnNumber = 33, SqlFieldName = AdmDate ];

/// DisDate 出院日期
Property DisDate As %Library.Date [ SqlColumnNumber = 34, SqlFieldName = DisDate ];

/// PreDiagnosis 入院诊断
Property PreDiagnosis As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = PreDiagnosis ];

/// MainDiagnosis 出院诊断
Property MainDiagnosis As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = MainDiagnosis ];

/// InsuPay1 医保支付1
Property InsuPay1 As %Library.Float [ SqlColumnNumber = 37, SqlFieldName = InsuPay1 ];

/// InsuPay2 医保支付2
Property InsuPay2 As %Library.Float [ SqlColumnNumber = 38, SqlFieldName = InsuPay2 ];

/// InsuPay3 医保支付3
Property InsuPay3 As %Library.Float [ SqlColumnNumber = 39, SqlFieldName = InsuPay3 ];

/// InsuPay4 医保支付4
Property InsuPay4 As %Library.Float [ SqlColumnNumber = 40, SqlFieldName = InsuPay4 ];

/// InsuPay5 医保支付5
Property InsuPay5 As %Library.Float [ SqlColumnNumber = 41, SqlFieldName = InsuPay5 ];

/// InsuPay6 医保支付6
Property InsuPay6 As %Library.Float [ SqlColumnNumber = 42, SqlFieldName = InsuPay6 ];

/// InsuPay7 医保支付7
Property InsuPay7 As %Library.Float [ SqlColumnNumber = 43, SqlFieldName = InsuPay7 ];

/// InsuPay8 医保支付8
Property InsuPay8 As %Library.Float [ SqlColumnNumber = 44, SqlFieldName = InsuPay8 ];

/// InsuPay9 医保支付9
Property InsuPay9 As %Library.Float [ SqlColumnNumber = 45, SqlFieldName = InsuPay9 ];

/// InsuPay10 医保支付10
Property InsuPay10 As %Library.Float [ SqlColumnNumber = 46, SqlFieldName = InsuPay10 ];

/// InsuDISAmt 医保拒付金额
Property InsuDISAmt As %Library.Float [ SqlColumnNumber = 47, SqlFieldName = InsuDISAmt ];

/// InsuDISInfo 医保拒付原因
Property InsuDISInfo As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 48, SqlFieldName = InsuDISInfo ];

/// Zstr01 扩展参数
Property Zstr01 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 49, SqlFieldName = Zstr01 ];

/// Zstr02 扩展参数
Property Zstr02 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 50, SqlFieldName = Zstr02 ];

/// Zstr03 扩展参数
Property Zstr03 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 51, SqlFieldName = Zstr03 ];

/// Zstr04 扩展参数
Property Zstr04 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 52, SqlFieldName = Zstr04 ];

/// Zstr05 扩展参数
Property Zstr05 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 53, SqlFieldName = Zstr05 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCINSUBalanceUnusual)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="ADMDr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AdmDate">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="DisDate">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="DivDate">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="DivTime">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="DivType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DivideDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Flag">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="HisGrzfe">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="HisJjzfe">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="HisTotAmt">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="HisZhzfe">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="HospitalCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="InsuBalanceDayDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="InsuBalanceMonDr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="InsuCenterSubDr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="InsuDISAmt">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="InsuDISInfo">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="InsuGrzfe">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="InsuJjzfe">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="InsuNo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="InsuPay1">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="InsuPay10">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="InsuPay2">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="InsuPay3">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="InsuPay4">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="InsuPay5">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="InsuPay6">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="InsuPay7">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="InsuPay8">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="InsuPay9">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="InsuRylb">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="InsuTotAmt">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="InsuType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="InsuYllb">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="InsuZhzfe">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="LocName">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MainDiagnosis">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="Name">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="OptDate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="OptName">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="OptTime">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PreDiagnosis">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="Zstr01">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="Zstr02">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="Zstr03">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="Zstr04">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="Zstr05">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="djlsh">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="jylsh">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="sUserDr">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="zylsh">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Global>^DHCINSUBalanceUnusual</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOfDivideDr">
<Global>^DHCINSUBalanceUnusual</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DivideDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DivideDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfDjlsh">
<Global>^DHCINSUBalanceUnusual</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"djlsh"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{djlsh}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfINSUBalanceDayDr">
<Global>^DHCINSUBalanceUnusual</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INSUBalanceDayDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INSUBalanceDayDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfINSUCenterSubDr">
<Global>^DHCINSUBalanceUnusual</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INSUCenterSubDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INSUCenterSubDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfINSUType">
<Global>^DHCINSUBalanceUnusual</Global>
<PopulationType>nonnull</PopulationType>
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
<SQLMap name="IndexOfZylsh">
<Global>^DHCINSUBalanceUnusual</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"zylsh"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{zylsh}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSUBalanceUnusualS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
