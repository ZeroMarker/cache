/// * ClassName: User.INSUCenterSub
/// * Description: 医保中心结算流水表
/// * Creator WenYX
/// * Date: 2019-11-15
Class User.INSUCenterSub Extends %Persistent [ Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Rowid, SqlTableName = INSU_CenterSub, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// 医院代码
Property HospitalCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = HospitalCode ];

/// 日对账Dr
Property InsuBalanceDayDr As User.INSUBalanceDay [ SqlColumnNumber = 3, SqlFieldName = InsuBalanceDayDr ];

/// 操作员日对账Dr
Property InUserBalDr As User.INSUBalanceDay [ SqlColumnNumber = 4, SqlFieldName = InUserBalDr ];

/// 医保结算流水表Dr
Property InsuMedicalSubDr As User.INSUMedicalSub [ SqlColumnNumber = 5, SqlFieldName = InsuMedicalSubDr ];

/// InsuType
Property InsuType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = InsuType ];

/// InsuYllb
Property INSUYllb As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = InsuYllb ];

/// InsuRylb
Property InsuRylb As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = InsuRylb ];

/// DivType
Property DivType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DivType ];

/// Name
Property Name As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = Name ];

/// InsuNo
Property InsuNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = InsuNo ];

/// InsuTotAmt
Property InsuTotAmt As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = InsuTotAmt ];

/// InsuJjzfe
Property InsuJjzfe As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = InsuJjzfe ];

/// InsuZhzfe
Property InsuZhzfe As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = InsuZhzfe ];

/// INSUgrzfe
Property InsuGrzfe As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = InsuGrzfe ];

/// zylsh
Property zylsh As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = zylsh ];

/// djlsh
Property djlsh As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = djlsh ];

/// jylsh
Property jylsh As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = jylsh ];

/// Flag
Property Flag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = Flag ];

/// sUserDr
Property sUserDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = sUserDr ];

/// OptName
Property OptName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = OptName ];

/// OptDate
Property OptDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = OptDate ];

/// OptTime
Property OptTime As %Library.Time(FORMAT = 1) [ SqlColumnNumber = 23, SqlFieldName = OptTime ];

/// AdmDate
Property AdmDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 24, SqlFieldName = AdmDate ];

/// DisDate
Property DisDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 25, SqlFieldName = DisDate ];

/// PreDiagnosis
Property PreDiagnosis As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = PreDiagnosis ];

/// MainDiagnosis
Property MainDiagnosis As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = MainDiagnosis ];

/// InsuPay1
Property InsuPay1 As %Library.Float [ SqlColumnNumber = 28, SqlFieldName = InsuPay1 ];

/// InsuPay2
Property InsuPay2 As %Library.Float [ SqlColumnNumber = 29, SqlFieldName = InsuPay2 ];

/// InsuPay3
Property InsuPay3 As %Library.Float [ SqlColumnNumber = 30, SqlFieldName = InsuPay3 ];

/// InsuPay4
Property InsuPay4 As %Library.Float [ SqlColumnNumber = 31, SqlFieldName = InsuPay4 ];

/// InsuPay5
Property InsuPay5 As %Library.Float [ SqlColumnNumber = 32, SqlFieldName = InsuPay5 ];

/// InsuPay6
Property InsuPay6 As %Library.Float [ SqlColumnNumber = 33, SqlFieldName = InsuPay6 ];

/// InsuPay7
Property InsuPay7 As %Library.Float [ SqlColumnNumber = 34, SqlFieldName = InsuPay7 ];

/// InsuPay8
Property InsuPay8 As %Library.Float [ SqlColumnNumber = 35, SqlFieldName = InsuPay8 ];

/// InsuPay9
Property InsuPay9 As %Library.Float [ SqlColumnNumber = 36, SqlFieldName = InsuPay9 ];

/// InsuPay109
Property InsuPay10 As %Library.Float [ SqlColumnNumber = 37, SqlFieldName = InsuPay10 ];

/// InsuDISAmt
Property InsuDISAmt As %Library.Float [ SqlColumnNumber = 38, SqlFieldName = InsuDISAmt ];

/// InsuDISInfo
Property InsuDISInfo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = InsuDISInfo ];

/// Zstr01
Property Zstr01 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = Zstr01 ];

/// Zstr02
Property Zstr02 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = Zstr02 ];

/// Zstr03
Property Zstr03 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = Zstr03 ];

/// Zstr04
Property Zstr04 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = Zstr04 ];

/// Zstr05
Property Zstr05 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = Zstr05 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINSUCenterSub)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="AdmDate">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DisDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DivType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="Flag">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="HospitalCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="InUserBalDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="InsuBalanceDayDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="InsuDISAmt">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="InsuDISInfo">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="InsuGrzfe">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="InsuJjzfe">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="InsuMedicalSubDr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="InsuNo">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
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
<Data name="InsuRylb">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="InsuTotAmt">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="InsuType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="InsuYllb">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="InsuZhzfe">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MainDiagnosis">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="Name">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OptDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="OptName">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="OptTime">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PreDiagnosis">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="Zstr01">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="Zstr02">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="Zstr03">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="Zstr04">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="Zstr05">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="djlsh">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="jylsh">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="sUserDr">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="zylsh">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Global>^DHCINSUCenterSub</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOfDjlsh">
<Global>^DHCINSUCenterSub</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Djlsh"</Expression>
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
<Global>^DHCINSUCenterSub</Global>
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
<Expression>{InsuBalanceDayDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfOptDate">
<Global>^DHCINSUCenterSub</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OptDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OptDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfUserBalDr">
<Global>^DHCINSUCenterSub</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UserBalDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InUserBalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfZylsh">
<Global>^DHCINSUCenterSub</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Zylsh"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{zylsh}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSUCenterSubS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
