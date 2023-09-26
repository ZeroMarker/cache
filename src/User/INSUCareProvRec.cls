/// Table:医保医师上传记录
/// Creator:DingSH
/// Date:2018-09-21
Class User.INSUCareProvRec Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INCPR_Rowid, SqlTableName = INSU_CareProvRec, StorageStrategy = CacheSQLStorage ]
{

/// INCPR_CPDr	医保医师信息指针	INSU_CareProvInfo.RowId
Property INCPRCPDr As User.INSUCareProvInfo [ SqlColumnNumber = 2, SqlFieldName = INCPR_CPDr ];

/// INCPR_Center	医保中心统筹区编码	VARCHAR2(10) 
Property INCPRCenter As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INCPR_Center ];

/// INCPR_States	医保中心行政区划代码	VARCHAR2(1) 
Property INCPRStates As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INCPR_States ];

/// IINCPR_SeriNo	申请流水号	VARCHAR2(30) 
Property INCPRSeriNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = INCPR_SeriNo ];

/// INCPR_BusiNo	发送方交易流水号	VARCHAR2(60) 		
Property INCPRBusiNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = INCPR_BusiNo ];

/// INCPR_InsuType	医保类型	VARCHAR2(30) 		
Property INCPRInsuType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = INCPR_InsuType ];

/// INCPR_HSPUserDr	医院审批人	VARCHAR2(20) 
Property INCPRHSPUserDr As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = INCPR_HSPUserDr ];

/// INCPR_HSPFlag	医院审批状态	VARCHAR2(30) 		0 未审核 1 审批通过
Property INCPRHSPFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = INCPR_HSPFlag ];

/// INCPR_HSPDate	医院审批日期	Date
Property INCPRHSPDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = INCPR_HSPDate ];

/// INCPR_HSPTime	医院审批时间	Time
Property INCPRHSPTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = INCPR_HSPTime ];

/// INCPR_ISPUserDr	医保审批人	VARCHAR2(20) 
Property INCPRISPUserDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = INCPR_ISPUserDr ];

/// INCPR_ISPFlag	医保审批状态	VARCHAR2(30) 
Property INCPRISPFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = INCPR_ISPFlag ];

/// INCPR_ISPDate	医保审批日期	Date
Property INCPRISPDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = INCPR_ISPDate ];

/// INCPR_ISPTime	医保审批时间	Time
Property INCPRISPTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = INCPR_ISPTime ];

/// INCPR_UserDr	经办人	VARCHAR2(20) 
Property INCPRUserDr As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = INCPR_UserDr ];

/// INCPR_Date	经办日期	Date
Property INCPRDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = INCPR_Date ];

/// INCPR_Time	经办时间	Time
Property INCPRTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = INCPR_Time ];

/// INCPR_ExtStr01	扩展01	VARCHAR2(30) 
Property INCPRExtStr01 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = INCPR_ExtStr01 ];

/// INCPR_ExtStr02	扩展02	VARCHAR2(30) 
Property INCPRExtStr02 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = INCPR_ExtStr02 ];

/// INCPR_ExtStr03	扩展03	VARCHAR2(30) 
Property INCPRExtStr03 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = INCPR_ExtStr03 ];

/// INCPR_ExtStr04	扩展04	VARCHAR2(30) 
Property INCPRExtStr04 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = INCPR_ExtStr04 ];

/// INCPR_ExtStr05	扩展05	VARCHAR2(30) 
Property INCPRExtStr05 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = INCPR_ExtStr05 ];

/// INCPR_HospDr	
Property INCPRHospDr As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = INCPR_HospDr ];

Storage CacheSQLStorage
{
<SqlIdExpression>$i(^DHCINCPR)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="INCPR_BusiNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INCPR_CPDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INCPR_Center">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INCPR_Date">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INCPR_ExtStr01">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INCPR_ExtStr02">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INCPR_ExtStr03">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INCPR_ExtStr04">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INCPR_ExtStr05">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INCPR_HSPDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INCPR_HSPFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INCPR_HSPTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INCPR_HSPUserDr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INCPR_HospDr">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INCPR_ISPDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INCPR_ISPFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INCPR_ISPTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INCPR_ISPUserDr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INCPR_InsuType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INCPR_SeriNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INCPR_States">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INCPR_Time">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INCPR_UserDr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Global>^DHCINCPR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INCPR_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{INCPR_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexOfINCPDR">
<Global>^DHCINCPR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INCPR_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INCPDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCPR_CPDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCPR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexOfINCPDRHosp">
<Global>^DHCINCPR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INCPR_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCPR_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"INCPDR"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INCPR_CPDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INCPR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSUCareProvRecS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
