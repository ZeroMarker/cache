/// 科室专业组分配表
Class User.DHCSubLocGrpAllot Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SLGA_Rowid, SqlTableName = DHC_SubLocGrpAllot, StorageStrategy = sqlStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCSubLocGrpAllotItm As User.DHCSubLocGrpAllotItm [ Cardinality = children, Inverse = SLGAISLGAParref ];

Relationship ChildDHCSubLocGrpAllotScale As User.DHCSubLocGrpAllotScale [ Cardinality = children, Inverse = SLGASSLGAParref ];

/// SLGA_No
Property SLGANo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = SLGA_No ];

/// SLGA_Date	制单日期
Property SLGADate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = SLGA_Date ];

/// SLGA_Time	制单时间
Property SLGATime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = SLGA_Time ];

/// SLGA_SSUSR_DR	制单人
Property SLGASSUSRDR As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = SLGA_SSUSR_DR ];

/// SLGA_CTLOC_DR
Property SLGACTLOCDR As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = SLGA_CTLOC_DR ];

/// SLGA_UserGrp_DR
Property SLGAUserGrpDR As User.DHCSubLocUserGroup [ SqlColumnNumber = 7, SqlFieldName = SLGA_UserGrp_DR ];

/// SLGA_Completed
Property SLGACompleted As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = SLGA_Completed ];

/// SLGA_AckDate	审核日期
Property SLGAAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = SLGA_AuditDate ];

/// SLGA_AckTime	审核时间
Property SLGAAuditTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = SLGA_AuditTime ];

/// SLGA_SSUSR_Ack_DR	审核人
Property SLGASSUSRAuditDR As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = SLGA_SSUSR_Audit_DR ];

/// SLGA_AuditFlag	审核标志
Property SLGAAuditFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = SLGA_AuditFlag ];

/// SLGA_SCG_DR
Property SLGASCGDR As User.DHCStkCatGroup [ SqlColumnNumber = 13, SqlFieldName = SLGA_SCG_DR ];

/// SLGA_StkType
Property SLGAStkType As %Library.String(DISPLAYLIST = ",Drug,Material,Others", MAXLEN = 8, SELECTIVITY = "25.0000%", VALUELIST = ",G,M,O") [ SqlColumnNumber = 14, SqlFieldName = SLGA_StkType ];

/// SLGA_Month	制单日期
Property SLGAMonth As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = SLGA_Month ];

Storage sqlStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSLGA)</SqlIdExpression>
<SQLMap name="IndexAllotMon">
<Global>^DHCSLGA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SLGA_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ALLOTMON"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SLGA_Month}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SLGA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAuditDate">
<Global>^DHCSLGA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SLGA_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"AUDITDATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{SLGA_AuditFlag}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{SLGA_AuditDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{SLGA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCSLGA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SLGA_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{SLGA_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{SLGA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCSLGA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SLGA_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{SLGA_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{SLGA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="SLGA_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SLGA_AuditFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SLGA_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SLGA_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SLGA_Completed">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SLGA_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SLGA_Month">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SLGA_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SLGA_SCG_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SLGA_SSUSR_Audit_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SLGA_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SLGA_StkType">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SLGA_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SLGA_UserGrp_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCSLGA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SLGA_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{SLGA_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCSubLocGrpAllotS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCSLGA)
	s oldI = +$g(^mdata("DHCSLGA"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCSLGA = maxI
	s ^mdata("DHCSLGA") = maxI
}

}
