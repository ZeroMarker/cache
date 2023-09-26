Class User.DHCPHLibDataPooL Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHLDP_RowId, SqlTableName = DHC_PHLibDataPooL, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHLDP_Date
Property PHLDPDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = PHLDP_Date ];

/// PHLDP_Time
Property PHLDPTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = PHLDP_Time ];

/// PHLDP_PatId
Property PHLDPPatId As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PHLDP_PatId ];

/// PHLDP_Adm
Property PHLDPAdm As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PHLDP_Adm ];

/// PHLDP_ReportNo
Property PHLDPReportNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PHLDP_ReportNo ];

/// PHLDP_ItemCode
Property PHLDPItemCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PHLDP_ItemCode ];

/// PHLDP_Val
Property PHLDPVal As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PHLDP_Val ];

/// PHLDP_Type
Property PHLDPType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PHLDP_Type ];

/// PHLDP_EndDate
Property PHLDPEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = PHLDP_EndDate ];

/// PHLDP_EndTime
Property PHLDPEndTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = PHLDP_EndTime ];

/// PHLDP_KeyWord
Property PHLDPKeyWord As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PHLDP_KeyWord ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHLIBDP)</SqlIdExpression>
<SQLMap name="IndexPatDate">
<Global>^DHCPHLIBDP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHLDP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PatDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHLDP_PatId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHLDP_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PHLDP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHLDP_Adm">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHLDP_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHLDP_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHLDP_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHLDP_ItemCode">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHLDP_KeyWord">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHLDP_PatId">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHLDP_ReportNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHLDP_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHLDP_Type">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHLDP_Val">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCPHLIBDP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHLDP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHLDP_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHLibDataPooLS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
