Class User.DHCINScrap Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INSCP_RowID, SqlTableName = DHC_INScrap, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCINSpItm As User.DHCINSpItm [ Cardinality = children, Inverse = INSPIParref ];

/// INSCP_NO
Property INSCPNO As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = INSCP_NO ];

/// INSCP_Date
Property INSCPDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = INSCP_Date ];

/// INSCP_Time
Property INSCPTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = INSCP_Time ];

/// INSCP_Reason
Property INSCPReason As User.DHCIncReasonForStockScrap [ SqlColumnNumber = 5, SqlFieldName = INSCP_Reason ];

/// INSCP_CTLOC_DR
Property INSCPCTLOCDR As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = INSCP_CTLOC_DR ];

/// INSCP_SSUSR_DR
Property INSCPSSUSRDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = INSCP_SSUSR_DR ];

/// INSCP_ChkDate
Property INSCPChkDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = INSCP_ChkDate ];

/// INSCP_ChkTime
Property INSCPChkTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = INSCP_ChkTime ];

/// INSCP_ChkUSR_DR
Property INSCPChkUSRDR As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = INSCP_ChkUSR_DR ];

/// INSCP_Stat
Property INSCPStat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = INSCP_Stat ];

/// INSCP_Remarks
Property INSCPRemarks As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = INSCP_Remarks ];

/// INSCP_Completed
Property INSCPCompleted As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = INSCP_Completed ];

/// INSCP_SCG_DR
Property INSCPSCGDR As User.DHCStkCatGroup [ SqlColumnNumber = 14, SqlFieldName = INSCP_SCG_DR ];

/// INSCP_ChkFlag
Property INSCPChkFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = INSCP_ChkFlag ];

/// INSCP_StkType
Property INSCPStkType As %Library.String(DISPLAYLIST = ",Drug,Material,Others", MAXLEN = 8, SELECTIVITY = "25.0000%", VALUELIST = ",G,M,O") [ SqlColumnNumber = 16, SqlFieldName = INSCP_StkType ];

/// INSCP_CanChkFlag 撤销审核
Property INSCPCanChkFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = INSCP_CanChkFlag ];

/// INSCP_StkCat_DR库存分类
Property INSCPStkCatDR As User.INCStkCat [ SqlColumnNumber = 18, SqlFieldName = INSCP_StkCat_DR ];

/// 打印次数
Property INSCPPrintTimes As %Library.Integer [ SqlColumnNumber = 19, SqlFieldName = INSCP_PrintTimes ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINSP)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="INSCP_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INSCP_CanChkFlag">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INSCP_ChkDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INSCP_ChkFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INSCP_ChkTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INSCP_ChkUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INSCP_Completed">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INSCP_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INSCP_NO">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INSCP_PrintTimes">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INSCP_Reason">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INSCP_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INSCP_SCG_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INSCP_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INSCP_Stat">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INSCP_StkCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INSCP_StkType">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INSCP_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCINSP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INSCP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INSCP_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexChDate">
<Global>^DHCINSP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INSCP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ChDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INSCP_ChkDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INSCP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexDate">
<Global>^DHCINSP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INSCP_RowID</Field>
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
<Expression>{INSCP_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INSCP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexLOC">
<Global>^DHCINSP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INSCP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INSCP_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INSCP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexNO">
<Global>^DHCINSP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INSCP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"NO"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INSCP_NO}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INSCP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINScrapS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCINSP)
	s oldI = +$g(^mdata("DHCINSCRAP"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCINSP = maxI
	s ^mdata("DHCINSCRAP") = maxI
}

}
