/// Table:医保科室上传记录表
/// Creator:DingSH
/// Date:20180920
Class User.INSULocRec Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INLCR_Rowid, SqlTableName = INSU_LocRec, StorageStrategy = CacheSQLStorage ]
{

/// INLCR_CTDr	医保科室信息指针	INSU_LocInfo.RowId
Property INLCRCTDr As User.INSULocInfo [ SqlColumnNumber = 2, SqlFieldName = INLCR_CTDr ];

/// INLCR_Center	医保中心统筹区编码	VARCHAR2(10) 
Property INLCRCenter As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INLCR_Center ];

/// INLCR_States	医保中心行政区划代码	VARCHAR2(1) 
Property INLCRStates As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INLCR_States ];

/// IINLCR_SeriNo	申请流水号	VARCHAR2(30) 
Property INLCRSeriNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = INLCR_SeriNo ];

/// INLCR_BusiNo	发送方交易流水号	VARCHAR2(60) 		
Property INLCRBusiNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = INLCR_BusiNo ];

/// INLCR_InsuType	医保类型	VARCHAR2(30) 		
Property INLCRInsuType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = INLCR_InsuType ];

/// INLCR_HSPUserDr	医院审批人	VARCHAR2(20) 
Property INLCRHSPUserDr As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = INLCR_HSPUserDr ];

/// INLCR_HSPFlag	医院审批状态	VARCHAR2(30) 		0 未审核 1 审批通过
Property INLCRHSPFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = INLCR_HSPFlag ];

/// INLCR_HSPDate	医院审批日期	Date
Property INLCRHSPDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = INLCR_HSPDate ];

/// INLCR_HSPTime	医院审批时间	Time
Property INLCRHSPTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = INLCR_HSPTime ];

/// INLCR_ISPUserDr	医保审批人	VARCHAR2(20) 
Property INLCRISPUserDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = INLCR_ISPUserDr ];

/// INLCR_ISPFlag	医保审批状态	VARCHAR2(30) 
Property INLCRISPFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = INLCR_ISPFlag ];

/// INLCR_ISPDate	医保审批日期	Date
Property INLCRISPDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = INLCR_ISPDate ];

/// INLCR_ISPTime	医保审批时间	Time
Property INLCRISPTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = INLCR_ISPTime ];

/// INLCR_UserDr	经办人	VARCHAR2(20) 
Property INLCRUserDr As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = INLCR_UserDr ];

/// INLCR_Date	经办日期	Date
Property INLCRDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = INLCR_Date ];

/// INLCR_Time	经办时间	Time
Property INLCRTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = INLCR_Time ];

/// INLCR_ExtStr01	扩展01	VARCHAR2(30) 
Property INLCRExtStr01 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = INLCR_ExtStr01 ];

/// INLCR_ExtStr02	扩展02	VARCHAR2(30) 
Property INLCRExtStr02 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = INLCR_ExtStr02 ];

/// INLCR_ExtStr03	扩展03	VARCHAR2(30) 
Property INLCRExtStr03 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = INLCR_ExtStr03 ];

/// INLCR_ExtStr04	扩展04	VARCHAR2(30) 
Property INLCRExtStr04 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = INLCR_ExtStr04 ];

/// INLCR_ExtStr05	扩展05	VARCHAR2(30) 
Property INLCRExtStr05 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = INLCR_ExtStr05 ];

/// INLCR_HospDr	
Property INLCRHospDr As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = INLCR_HospDr ];

Storage CacheSQLStorage
{
<SqlIdExpression>$i(^DHCINLCR)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="INLCR_BusiNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INLCR_CTDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INLCR_Center">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INLCR_Date">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INLCR_ExtStr01">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INLCR_ExtStr02">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INLCR_ExtStr03">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INLCR_ExtStr04">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INLCR_ExtStr05">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INLCR_HSPDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INLCR_HSPFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INLCR_HSPTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INLCR_HSPUserDr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INLCR_HospDr">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INLCR_ISPDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INLCR_ISPFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INLCR_ISPTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INLCR_ISPUserDr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INLCR_InsuType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INLCR_SeriNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INLCR_States">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INLCR_Time">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INLCR_UserDr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Global>^DHCINLCR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INLCR_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{INLCR_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexOfCTDr">
<Global>^DHCINLCR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INLCR_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CTDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INLCR_CTDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INLCR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexOfCTDrHosp">
<Global>^DHCINLCR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INLCR_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INLCR_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"CTDR"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INLCR_CTDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INLCR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSULocRecS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
