Class User.INSUOEORIUpDetails Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INSUD_OEORI_Rowid, SqlTableName = INSU_OEORIUpDetails, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// INSUD_OEORI_AdmDr
Property INSUDOEORIAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = INSUD_OEORI_AdmDr ];

/// INSUD_OEORI_InsuType
Property INSUDOEORIInsuType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INSUD_OEORI_InsuType ];

/// INSUD_OEORI_Yzlsh 医嘱流水号		不能为空医院医嘱的唯一标识号
Property INSUDOEORIYzlsh As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INSUD_OEORI_Yzlsh ];

/// INSUD_OEORI_YzGrp 医嘱组号		不能为为空
Property INSUDOEORIYzGrp As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = INSUD_OEORI_YzGrp ];

/// INSUD_OEORI_YzInd 医嘱顺序号	不能为为空
Property INSUDOEORIYzInd As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = INSUD_OEORI_YzInd ];

/// INSUD_OEORI_BillNo
Property INSUDOEORIBillNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = INSUD_OEORI_BillNo ];

/// INSUD_OEORI_InvPrtDr
Property INSUDOEORIInvPrtDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = INSUD_OEORI_InvPrtDr ];

/// INSUD_OEORI_Flag
Property INSUDOEORIFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = INSUD_OEORI_Flag ];

/// INSUD_OEORI_UserDr
Property INSUDOEORIUserDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = INSUD_OEORI_UserDr ];

/// INSUD_OEORI_iDate
Property INSUDOEORIiDate As %Library.Date [ SqlColumnNumber = 11, SqlFieldName = INSUD_OEORI_iDate ];

/// INSUD_OEORI_iTime
Property INSUDOEORIiTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = INSUD_OEORI_iTime ];

/// INSUD_OEORI_DeptCode
Property INSUDOEORIDeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = INSUD_OEORI_DeptCode ];

/// INSUD_OEORI_DoctCode
Property INSUDOEORIDoctCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = INSUD_OEORI_DoctCode ];

/// INSUD_OEORI_YzStDT
Property INSUDOEORIYzStDT As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = INSUD_OEORI_YzStDT ];

/// INSUD_OEORI_YzExcDT
Property INSUDOEORIYzExcDT As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = INSUD_OEORI_YzExcDT ];

/// INSUD_OEORI_YzXDT
Property INSUDOEORIYzXDT As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = INSUD_OEORI_YzXDT ];

/// INSUD_OEORI_XDoctCode
Property INSUDOEORIXDoctCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = INSUD_OEORI_XDoctCode ];

/// INSUD_OEORI_YzDesc
Property INSUDOEORIYzDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = INSUD_OEORI_YzDesc ];

/// INSUD_OEORI_YzFnc
Property INSUDOEORIYzFnc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = INSUD_OEORI_YzFnc ];

/// INSUD_OEORI_YzType	医嘱类型
Property INSUDOEORIYzType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = INSUD_OEORI_YzType ];

/// INSUD_OEORI_BedCode	床位号
Property INSUDOEORIBedCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = INSUD_OEORI_BedCode ];

/// INSUD_OEORI_UpInData	上传数据
Property INSUDOEORIUpInData As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = INSUD_OEORI_UpInData ];

/// INSUD_OEORI_XStr01	扩展串01
Property INSUDOEORIXStr01 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = INSUD_OEORI_XStr01 ];

/// INSUD_OEORI_XStr02	扩展串02
Property INSUDOEORIXStr02 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = INSUD_OEORI_XStr02 ];

/// INSUD_OEORI_XStr03	扩展串03
Property INSUDOEORIXStr03 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = INSUD_OEORI_XStr03 ];

/// INSUD_OEORI_XStr04	扩展串04
Property INSUDOEORIXStr04 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = INSUD_OEORI_XStr04 ];

/// INSUD_OEORI_XStr05	扩展串05
Property INSUDOEORIXStr05 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = INSUD_OEORI_XStr05 ];

/// INSUD_OEORI_InAdmDr
Property INSUDOEORIInAdmDr As User.INSUAdmInfo [ SqlColumnNumber = 29, SqlFieldName = INSUD_OEORI_InAdmDr ];

/// INSUD_OEORI_InDivDr
Property INSUDOEORIInDivDrr As User.INSUDivide [ SqlColumnNumber = 30, SqlFieldName = INSUD_OEORI_InDivDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINSUDOEORI)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="INSUD_OEORI_AdMDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INSUD_OEORI_BedCode">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INSUD_OEORI_BillNo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INSUD_OEORI_DeptCode">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INSUD_OEORI_DoctCode">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INSUD_OEORI_Flag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INSUD_OEORI_InAdmDr">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INSUD_OEORI_InDivDr">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="INSUD_OEORI_InsuType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INSUD_OEORI_InvPrtDr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INSUD_OEORI_UpInData">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INSUD_OEORI_UserDr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INSUD_OEORI_XDoctCode">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INSUD_OEORI_XStr01">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INSUD_OEORI_XStr02">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INSUD_OEORI_XStr03">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INSUD_OEORI_XStr04">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INSUD_OEORI_XStr05">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INSUD_OEORI_YzDesc">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INSUD_OEORI_YzExcDT">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INSUD_OEORI_YzFnc">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INSUD_OEORI_YzGrp">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INSUD_OEORI_YzInd">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INSUD_OEORI_YzStDT">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INSUD_OEORI_YzType">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INSUD_OEORI_YzXDT">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INSUD_OEORI_Yzlsh">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INSUD_OEORI_iDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INSUD_OEORI_iTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCINSUDOEORI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INSUD_OEORI_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{INSUD_OEORI_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexOfBillNo">
<Global>^DHCINSUDOEORI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INSUD_OEORI_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BillNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INSUD_OEORI_BillNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INSUD_OEORI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexOfInAdmDr">
<Global>^DHCINSUDOEORI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INSUD_OEORI_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InAdmDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INSUD_OEORI_InAdmDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INSUD_OEORI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexOfInDivDr">
<Global>^DHCINSUDOEORI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INSUD_OEORI_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InDivDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INSUD_OEORI_InDivDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INSUD_OEORI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexOfInvPrt">
<Global>^DHCINSUDOEORI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INSUD_OEORI_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INV"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INSUD_OEORI_InvPrtDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INSUD_OEORI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexOfYzlshGrpInd">
<Global>^DHCINSUDOEORI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>INSUD_OEORI_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Yzlsh"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INSUD_OEORI_Yzlsh}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Grp"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INSUD_OEORI_YzGrp}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"Ind"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{INSUD_OEORI_YzInd}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{INSUD_OEORI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexOfiDate">
<Global>^DHCINSUDOEORI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INSUD_OEORI_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"iDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INSUD_OEORI_iDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INSUD_OEORI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSUOEORIUpDetailsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
