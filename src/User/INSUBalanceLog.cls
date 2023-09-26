Class User.INSUBalanceLog Extends (%Library.Persistent, web.INSUCacheJSON) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INBLL_Rowid, SqlTableName = INSU_BalanceLog, StorageStrategy = SQLStorage ]
{

/// Creator：      王辉
/// CreatDate：    20160123
/// Description:： 医保对账记录表
Parameter EXTENTSIZE = 250;

/// INBLL_INSUTypte    医保类型
Property INBLLINSUTypte As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = INBLL_INSUTypte ];

/// INBLL_OptDate  对账日期
Property INBLLOptDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = INBLL_OptDate ];

/// INBLL_UserDr   操作员ID
Property INBLLUserDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INBLL_UserDr ];

/// INBLL_Flag   对账成功标志
Property INBLLFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = INBLL_Flag ];

/// INBLL_StartDate   对账开始日期
Property INBLLStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = INBLL_StartDate ];

/// INBLL_StartTime  对账开始时间
Property INBLLStartTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = INBLL_StartTime ];

/// INBLL_EndDate   对账结束日期
Property INBLLEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = INBLL_EndDate ];

/// INBLL_EndTime   对账结束时间
Property INBLLEndTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = INBLL_EndTime ];

/// INBLL_TotAmt    his对账总金额
Property INBLLTotAmt As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = INBLL_TotAmt ];

/// INBLL_JJZFE     his基金支付金额
Property INBLLJJZFE As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = INBLL_JJZFE ];

/// INBLL_ZHZFE  his账户支付金额
Property INBLLZHZFE As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = INBLL_ZHZFE ];

/// INBLL_GRZFE   his现金支付金额
Property INBLLGRZFE As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = INBLL_GRZFE ];

/// INBLL_TCZF   his基本统筹支付金额
Property INBLLTCZF As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = INBLL_TCZF ];

/// INBLL_DBZF his大病支付金额
Property INBLLDBZF As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = INBLL_DBZF ];

/// INBLL_GWYZF    his公务员支付金额
Property INBLLGWYZF As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = INBLL_GWYZF ];

/// INBLL_MZJZ    his民正救助金额
Property INBLLMZJZ As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = INBLL_MZJZ ];

/// INBLL_INSUTotAmt    医保返回对账总金额
Property INBLLINSUTotAmt As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = INBLL_INSUTotAmt ];

/// INBLL_INSUJJZFE  医保返回基金支付金额
Property INBLLINSUJJZFE As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = INBLL_INSUJJZFE ];

/// IINBLL_INSUZHZFE    医保返回账户支付金额
Property IINBLLINSUZHZFE As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = IINBLL_INSUZHZFE ];

/// INBLL_INSUGRZFE    医保返回现金支付金额
Property INBLLINSUGRZFE As %Library.Float [ SqlColumnNumber = 21, SqlFieldName = INBLL_INSUGRZFE ];

/// INBLL_INSUTCZF     医保返回基本统筹支付金额
Property INBLLINSUTCZF As %Library.Float [ SqlColumnNumber = 22, SqlFieldName = INBLL_INSUTCZF ];

/// INBLL_INSUDBZF    医保返回大病支付金额
Property INBLLINSUDBZF As %Library.Float [ SqlColumnNumber = 23, SqlFieldName = INBLL_INSUDBZF ];

/// INBLL_INSUGWYZF  医保返回公务员支付金额
Property INBLLINSUGWYZF As %Library.Float [ SqlColumnNumber = 24, SqlFieldName = INBLL_INSUGWYZF ];

/// INBLL_INSUMZJZ   医保返回民正救助金额
Property INBLLINSUMZJZ As %Library.Float [ SqlColumnNumber = 25, SqlFieldName = INBLL_INSUMZJZ ];

/// INBLL_Note   对账失败原因
Property INBLLNote As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = INBLL_Note ];

/// INBLL_Str1   扩展字段1
Property INBLLStr1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = INBLL_Str1 ];

/// INBLL_Str2   扩展字段2
Property INBLLStr2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = INBLL_Str2 ];

/// INBLL_Str3   扩展字段3
Property INBLLStr3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = INBLL_Str3 ];

/// INBLL_Str4   扩展字段4
Property INBLLStr4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = INBLL_Str4 ];

/// INBLL_Str5   扩展字段5
Property INBLLStr5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = INBLL_Str5 ];

/// INBLL_HospId   扩展字段5
Property INBLLHospId As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = INBLL_HospId ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINBLL)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="IINBLL_INSUZHZFE">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INBLL_DBZF">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INBLL_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INBLL_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INBLL_Flag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INBLL_GRZFE">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INBLL_GWYZF">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INBLL_HospId">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="INBLL_INSUDBZF">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INBLL_INSUGRZFE">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INBLL_INSUGWYZF">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INBLL_INSUJJZFE">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INBLL_INSUMZJZ">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INBLL_INSUTCZF">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INBLL_INSUTotAmt">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INBLL_INSUTypte">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INBLL_JJZFE">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INBLL_MZJZ">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INBLL_Note">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INBLL_OptDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INBLL_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INBLL_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INBLL_Str1">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INBLL_Str2">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INBLL_Str3">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INBLL_Str4">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="INBLL_Str5">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="INBLL_TCZF">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INBLL_TotAmt">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INBLL_UserDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INBLL_ZHZFE">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCINBLL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INBLL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{INBLL_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofEndDate">
<Global>^DHCINBLL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INBLL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EndDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INBLL_EndDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INBLL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofINSUTypte">
<Global>^DHCINBLL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INBLL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INSUTypte"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INBLL_INSUTypte}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INBLL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofOptDate">
<Global>^DHCINBLL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INBLL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OptDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INBLL_OptDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INBLL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofStartDate">
<Global>^DHCINBLL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INBLL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StartDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INBLL_StartDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INBLL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSUBalanceLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
