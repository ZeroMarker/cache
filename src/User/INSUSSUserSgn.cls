/// 描述：医保用户签到信息表
/// 作者：DingSH 
/// 日期：2019-07-15
Class User.INSUSSUserSgn Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INS_Rowid, SqlTableName = INSU_SSUserSgn, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// INS_UserDr	操作员Dr
Property INSUserDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = INS_UserDr ];

/// INS_UserCode 操作员Code
Property INSUserCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INS_UserCode ];

/// INS_UserDesc 操作员Desc
Property INSUserDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INS_UserDesc ];

/// INS_InsuType 医保类型
Property INSInsuType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = INS_InsuType ];

/// INS_LgInDate 签到日期
Property INSLgInDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = INS_LgInDate ];

/// INS_LgInTime	签到时间
Property INSLgInTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = INS_LgInTime ];

/// INS_LgOutDate	签退日期
Property INSLgOutDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = INS_LgOutDate ];

/// INS_LgOutTime	签退时间
Property INSLgOutTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = INS_LgOutTime ];

/// INS_MAC	签到MAC地址
Property INSLgInMAC As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = INS_LgInMAC ];

/// INS_IP	签到IP地址
Property INSLgInIP As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = INS_LgInIP ];

/// INS_MAC	签退MAC地址
Property INSLgOutMAC As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = INS_LgOutMAC ];

/// INS_IP	签退IP地址
Property INSLgOutIP As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = INS_LgOutIP ];

/// INS_YWLX	业务类型（空:全部、 1:门诊、2:住院）
Property INSYWLX As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = INS_YWLX ];

/// INS_BusiNo	业务周期流水号    
Property INSBusiNo As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = INS_BusiNo ];

/// INS_ActFlag	有效标志    
Property INSActFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = INS_ActFlag ];

/// INS_iDate	操作日期
Property INSiDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = INS_iDate ];

/// INS_iTime	操作时间
Property INSiTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = INS_iTime ];

/// INS_HospDr	院区DR
Property INSHospDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = INS_HospDr ];

/// INS_Ext01	扩展01  
Property INSExt01 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = INS_Ext01 ];

/// INS_Ext02	扩展02  
Property INSExt02 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = INS_Ext02 ];

/// INS_Ext03	扩展03  
Property INSExt03 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = INS_Ext03 ];

/// INS_Ext02	扩展04 
Property INSExt04 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = INS_Ext04 ];

/// INS_Ext01	扩展05
Property INSExt05 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = INS_Ext05 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINSUSSGN)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="INS_ActFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INS_BusiNo">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INS_Ext01">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INS_Ext02">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INS_Ext03">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INS_Ext04">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INS_Ext05">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INS_HospDr">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INS_InsuType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INS_LgInDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INS_LgInIP">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INS_LgInMAC">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INS_LgInTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INS_LgOutDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INS_LgOutIP">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INS_LgOutMAC">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INS_LgOutTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INS_UserCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INS_UserDesc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INS_UserDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INS_YWLX">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INS_iDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INS_iTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Global>^DHCINSUSSGN</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INS_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{INS_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOfUserDrDate">
<Global>^DHCINSUSSGN</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INS_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"USERDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INS_UserDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INS_iDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexOfBusiNo">
<Global>^DHCINSUSSGN</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INS_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BUSINO"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INS_BusiNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSUSSUserSgnS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
