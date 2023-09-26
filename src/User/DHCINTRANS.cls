Class User.DHCINTRANS Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INTR_RowId, SqlTableName = DHC_INTRANS, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 25000;

/// Amount
Property INTRAmount As %Library.Float(MAXVAL = 999999999999.9999, MINVAL = -99999999999999.9999) [ SqlColumnNumber = 2, SqlFieldName = INTR_Amount ];

/// Average Price
Property INTRAveragePrice As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = INTR_AveragePrice ];

/// Des Ref to CTUOM (Unit of Me
Property INTRCTUOMDR As User.CTUOM [ SqlColumnNumber = 4, SqlFieldName = INTR_CTUOM_DR ];

/// Transaction Date
Property INTRDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 5, SqlFieldName = INTR_Date ];

/// GL Batch
Property INTRGLBatchDR As User.GLBatch [ SqlColumnNumber = 6, SqlFieldName = INTR_GLBatch_DR ];

/// Des Ref INCI
Property INTRINCIDR As User.INCItm [ SqlColumnNumber = 7, SqlComputeCode = {	s {INTR_INCI_DR}=$p({INTR_INCLB_DR},"||")
}, SqlComputed, SqlFieldName = INTR_INCI_DR, Transient ];

/// Des Ref to INCLB
Property INTRINCLBDR As User.INCItmLcBt [ SqlColumnNumber = 8, SqlFieldName = INTR_INCLB_DR ];

/// Transaction Number
Property INTRNo As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = INTR_No ];

/// Pointer to other table
Property INTRPointer As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = INTR_Pointer ];

/// Quantity
Property INTRQty As %Library.Float(MAXVAL = 9999999999999999, MINVAL = -99999999999999) [ SqlColumnNumber = 11, SqlFieldName = INTR_Qty ];

/// Des ref to SSUSR
Property INTRSSUSRDR As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = INTR_SSUSR_DR ];

/// Transaction Time
Property INTRTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = INTR_Time ];

/// Stock Transaction Type
Property INTRType As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = INTR_Type ];

/// Update Balance Flag
Property INTRUpdBalFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = INTR_UpdBalFlag ];

/// Update Inventory Flag
Property INTRUpdFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = INTR_UpdFlag ];

/// INTR_Rp
Property INTRRp As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = INTR_Rp ];

/// INTR_RpAmount
Property INTRRpAmount As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = INTR_RpAmount ];

/// INTR_StkQty
Property INTRStkQty As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = INTR_StkQty ];

/// INTR_LbQty
Property INTRLbQty As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = INTR_LbQty ];

/// INTR_InsuCode
Property INTRInsuCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = INTR_InsuCode ];

/// INTR_ProvCode
Property INTRProvCode As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = INTR_ProvCode ];

/// 计费发票id
Property INTRPrtDR As User.DHCINVPRT [ SqlColumnNumber = 23, SqlFieldName = INTR_PrtDR ];

Storage SQLStorage
{
<ExtentSize>25000</ExtentSize>
<SqlIdExpression>$i(^DHCINTR)</SqlIdExpression>
<SQLMap name="DataMasterDHCINTR">
<Data name="INTR_Amount">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INTR_AveragePrice">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INTR_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INTR_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INTR_GLBatch_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INTR_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INTR_INCLB_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INTR_InsuCode">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INTR_LbQty">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INTR_No">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INTR_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INTR_ProvCode">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INTR_PrtDR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INTR_Qty">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INTR_Rp">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INTR_RpAmount">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INTR_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INTR_StkQty">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INTR_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INTR_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INTR_UpdBalFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INTR_UpdFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCINTR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INTR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCINTR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INTR_RowId</Field>
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
<Expression>{INTR_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGlBatch">
<Global>^DHCINTR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"GlBatch"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INTR_GLBatch_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGlPosted">
<Global>^DHCINTR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"GlPost"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INTR_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINCLB">
<Global>^DHCINTR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"INCLB"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INTR_INCLB_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INTR_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInciDate">
<Global>^DHCINTR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INTR_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INTR_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocTypeDate">
<Global>^DHCINTR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INTR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOCTYPEDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$LOC^ST01({INTR_INCLB_DR})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INTR_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTR_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrt">
<Global>^DHCINTR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INTR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypePrt"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INTR_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INTR_PrtDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeDate">
<Global>^DHCINTR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TypeDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INTR_Type}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INTR_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeNo">
<Global>^DHCINTR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TypeNo"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INTR_Type}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({INTR_No})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypePointer">
<Global>^DHCINTR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TypePointer"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INTR_Type}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INTR_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypePointerInclb">
<Global>^DHCINTR</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INTR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypePointerInclb"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INTR_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INTR_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTR_INCLB_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexinciltypedate">
<Global>^DHCINTR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ILTYPEDATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$P({INTR_INCLB_DR},"||",1,2)</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INTR_Type}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INTR_Date}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{INTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINTRANSS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCINTR)
	s oldI = +$g(^mdata("DHCINTRANS"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	i newI '> 0 s maxI = maxI + 100
	s ^DHCINTR = maxI
	s ^mdata("DHCINTRANS") = maxI
}

}
