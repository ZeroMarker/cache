Class User.DHCPayMon Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PM_Rowid, SqlTableName = DHC_PayMon, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPayMonVendor As User.DHCPayMonVendor [ Cardinality = children, Inverse = PMVParRef ];

Relationship ChildDHCPayMonLB As User.DHCPayMonLB [ Cardinality = children, Inverse = PMLBPMParref ];

/// PM_MonthDate
Property PMMonthDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = PM_MonthDate ];

/// PM_FrDate
Property PMDateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = PM_DateFrom ];

/// PM_ToDate
Property PMDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = PM_DateTo ];

/// PM_DateCreated
Property PMCreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = PM_CreateDate ];

/// PM_CreateTime
Property PMCreateTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = PM_CreateTime ];

/// PM_SSUSR_DR :User.SSUser
Property PMSSUSRDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = PM_SSUSR_DR ];

/// PM_EndSpAmt
Property PMEndSpAmt As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = PM_EndSpAmt ];

/// PM_EndPpAmt
Property PMEndPpAmt As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = PM_EndPpAmt ];

/// PM_EndRpAmt
Property PMEndRpAmt As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = PM_EndRpAmt ];

/// PM_PayedSpAmt
Property PMPayedSpAmt As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = PM_PayedSpAmt ];

/// PM_PayedPpAmt
Property PMPayedPpAmt As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = PM_PayedPpAmt ];

/// PM_PayedRpAmt
Property PMPayedRpAmt As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = PM_PayedRpAmt ];

/// PM_LastSpAmt
Property PMLastSpAmt As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = PM_LastSpAmt ];

/// PM_LastPpAmt
Property PMLastPpAmt As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = PM_LastPpAmt ];

/// PM_LastRpAmt
Property PMLastRpAmt As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = PM_LastRpAmt ];

/// PM_ArrearSpAmt
Property PMArrearSpAmt As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = PM_ArrearSpAmt ];

/// PM_ArrearPpAmt
Property PMArrearPpAmt As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = PM_ArrearPpAmt ];

/// PM_ArrearRpAmt
Property PMArrearRpAmt As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = PM_ArrearRpAmt ];

/// PM_CTLOC_DR :User.CTLoc
Property PMCTLOCDR As User.CTLoc [ SqlColumnNumber = 20, SqlFieldName = PM_CTLOC_DR ];

/// PM_APCVM_DR
Property PMAPCVMDR As User.APCVendor [ SqlColumnNumber = 21, SqlFieldName = PM_APCVM_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPAYM)</SqlIdExpression>
<SQLMap name="DataMasterPaySum">
<Data name="PM_APCVM_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PM_ArrearPpAmt">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PM_ArrearRpAmt">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PM_ArrearSpAmt">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PM_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PM_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PM_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PM_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PM_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PM_EndPpAmt">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PM_EndRpAmt">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PM_EndSpAmt">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PM_LastPpAmt">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PM_LastRpAmt">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PM_LastSpAmt">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PM_MonthDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PM_PayedPpAmt">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PM_PayedRpAmt">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PM_PayedSpAmt">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PM_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCPAYM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PM_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PM_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAPCVMDR">
<Global>^DHCPAYM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PM_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"Vendor"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PM_APCVM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{PM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCPAYM</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PM_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMonthLoc">
<Global>^DHCPAYM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PM_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"MLOC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PM_MonthDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{PM_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{PM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPayMonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPAYM)
	s oldI = +$g(^mdata("DHCPAYMON"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPAYM = maxI
	s ^mdata("DHCPAYMON") = maxI
}

}
