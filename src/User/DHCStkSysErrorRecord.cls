Class User.DHCStkSysErrorRecord Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCSTER_RowId, SqlTableName = DHC_StkSysErrorRecord, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DHCSTER_Date
Property DHCSTERDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = DHCSTER_Date ];

/// DHCSTER_Time
Property DHCSTERTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = DHCSTER_Time ];

/// DHCSTER_App
Property DHCSTERApp As User.DHCStkSysApp [ SqlColumnNumber = 4, SqlFieldName = DHCSTER_App ];

/// DHCSTER_ErrInfo
Property DHCSTERErrInfo As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DHCSTER_ErrInfo ];

/// DHCSTER_KeyValue
Property DHCSTERKeyValue As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DHCSTER_KeyValue ];

/// DHCSTER_ErrorTrigger
Property DHCSTERErrorTrigger As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DHCSTER_ErrorTrigger ];

/// DHCSTER_IP
Property DHCSTERIP As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DHCSTER_IP ];

/// DHCSTER_SSUSR_DR
Property DHCSTERSSUSRDR As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = DHCSTER_SSUSR_DR ];

/// DHCSTER_BrowserInfo
Property DHCSTERBrowserInfo As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = DHCSTER_BrowserInfo ];

/// DHCSTER_StkType
Property DHCSTERStkType As %String(DISPLAYLIST = ",Drug,Material,Others", MAXLEN = 8, SELECTIVITY = "25.0000%", VALUELIST = ",G,M,O") [ SqlColumnNumber = 11, SqlFieldName = DHCSTER_StkType ];

Property DHCSTERPageName As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = DHCSTER_PageName ];

Property DHCSTERExceptionName As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DHCSTER_ExceptionName ];

Property DHCSTERExceptionType As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = DHCSTER_ExceptionType ];

Property DHCSTERAppVersion As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = DHCSTER_AppVersion ];

Property DHCSTEROSVersion As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = DHCSTER_OSVersion ];

Property DHCSTERDeviceModel As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = DHCSTER_DeviceModel ];

Property DHCSTERDeviceID As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = DHCSTER_DeviceID ];

Property DHCSTERNetWorkType As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = DHCSTER_NetWorkType ];

Property DHCSTERCMemoryInfo As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = DHCSTER_MemoryInfo ];

Property DHCSTERExceptionsStackDetail As %Library.Text(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = DHCSTER_ExceptionsStackDetail ];

Property DHCSTERLocDR As User.CTLoc [ SqlColumnNumber = 22, SqlFieldName = DHCSTER_Loc_DR ];

Property DHCSTERGroupDR As User.SSGroup [ SqlColumnNumber = 23, SqlFieldName = DHCSTER_Group_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSTERROR)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DHCSTER_App">
<Delimiter>$c(1)</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCSTER_AppVersion">
<Delimiter>$c(1)</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DHCSTER_BrowserInfo">
<Delimiter>$c(1)</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCSTER_Date">
<Delimiter>$c(1)</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCSTER_DeviceID">
<Delimiter>$c(1)</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DHCSTER_DeviceModel">
<Delimiter>$c(1)</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DHCSTER_ErrInfo">
<Delimiter>$c(1)</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCSTER_ErrorTrigger">
<Delimiter>$c(1)</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCSTER_ExceptionName">
<Delimiter>$c(1)</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DHCSTER_ExceptionType">
<Delimiter>$c(1)</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DHCSTER_ExceptionsStackDetail">
<Delimiter>$c(1)</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DHCSTER_Group_DR">
<Delimiter>$c(1)</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DHCSTER_IP">
<Delimiter>$c(1)</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCSTER_KeyValue">
<Delimiter>$c(1)</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCSTER_Loc_DR">
<Delimiter>$c(1)</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DHCSTER_MemoryInfo">
<Delimiter>$c(1)</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DHCSTER_NetWorkType">
<Delimiter>$c(1)</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DHCSTER_OSVersion">
<Delimiter>$c(1)</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DHCSTER_PageName">
<Delimiter>$c(1)</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DHCSTER_SSUSR_DR">
<Delimiter>$c(1)</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCSTER_StkType">
<Delimiter>$c(1)</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DHCSTER_Time">
<Delimiter>$c(1)</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCSTERROR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCSTER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHCSTER_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCSTERROR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCSTER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHCSTER_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHCSTER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCStkSysErrorRecordS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCSTERROR)
	s oldI = +$g(^mdata("DHCSTKSYSERRORRECORD"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCSTERROR = maxI
	s ^mdata("DHCSTKSYSERRORRECORD") = maxI
}

}
