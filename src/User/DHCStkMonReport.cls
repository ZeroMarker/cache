Class User.DHCStkMonReport Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SMR_Rowid, SqlTableName = DHC_StkMonReport, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCStkMonRepLcBt As User.DHCStkMonRepLcBt [ Cardinality = children, Inverse = SMRLBSMRParref ];

Index RowIDBasedIDKeyIndex On SMRChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCStkMonTrans As User.DHCStkMonTrans [ Cardinality = children, Inverse = SMTSMRParref ];

/// DHC_StkMon Parent Reference
Relationship SMRSMParref As User.DHCStkMon [ Cardinality = parent, Inverse = ChildDHCStkMonReport, Required, SqlFieldName = SMR_SM_Parref ];

/// SMR_MonthDate
Property SMRMonthDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = SMR_MonthDate ];

/// SMR_Date
Property SMRDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = SMR_Date ];

/// SMR_INCI_DR
Property SMRINCIDR As User.INCItm [ SqlColumnNumber = 4, SqlFieldName = SMR_INCI_DR ];

/// SMR_CTLOC_DR
Property SMRCTLOCDR As User.CTLoc [ SqlColumnNumber = 5, SqlFieldName = SMR_CTLOC_DR ];

/// SMR_INCIL_DR
Property SMRINCILDR As User.INCItmLoc [ SqlColumnNumber = 6, SqlFieldName = SMR_INCIL_DR ];

/// SMR_PhyQty
Property SMRPhyQty As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = SMR_PhyQty ];

/// SMR_Amount
Property SMRAmount As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = SMR_Amount ];

/// SMR_CostAmount
Property SMRCostAmount As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = SMR_CostAmount ];

/// SMR_LastPhyQty
Property SMRLastPhyQty As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = SMR_LastPhyQty ];

/// SMR_LastAmount
Property SMRLastAmount As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = SMR_LastAmount ];

/// SMR_LastCostAmount
Property SMRLastCostAmount As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = SMR_LastCostAmount ];

/// SMR_Remarks
Property SMRRemarks As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = SMR_Remarks ];

/// SMR_SSUSR_DR
Property SMRSSUSRDR As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = SMR_SSUSR_DR ];

/// SMR_Childsub
Property SMRChildsub As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = SMR_Childsub ];

/// SMR_INCSC_DR
Property SMRINCSCDR As User.INCStkCat [ SqlColumnNumber = 17, SqlFieldName = SMR_INCSC_DR ];

/// SMR_SCG_DR
Property SMRSCGDR As User.DHCStkCatGroup [ SqlColumnNumber = 18, SqlFieldName = SMR_SCG_DR ];

/// 高值标记
Property SMRHVFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = SMR_HVFlag ];

/// 差异金额(售价)
Property SMRDiffAmount As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = SMR_DiffAmount ];

/// 差异金额(进价)
Property SMRCostDiffAmount As %Library.Float [ SqlColumnNumber = 21, SqlFieldName = SMR_CostDiffAmount ];

/// 本年累计差异金额(售价)
Property SMRTotalDiffAmount As %Library.Float [ SqlColumnNumber = 22, SqlFieldName = SMR_TotalDiffAmount ];

/// 本年累计差异金额(进价)
Property SMRTotalCostDiffAmount As %Library.Float [ SqlColumnNumber = 23, SqlFieldName = SMR_TotalCostDiffAmount ];

/// 上期合计金额(售价)
Property SMRTotalLastAmount As %Library.Float [ SqlColumnNumber = 24, SqlFieldName = SMR_TotalLastAmount ];

/// 上期合计金额(进价)
Property SMRTotalLastCostAmount As %Library.Float [ SqlColumnNumber = 25, SqlFieldName = SMR_TotalLastCostAmount ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterSMR">
<Data name="SMR_Amount">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SMR_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SMR_CostAmount">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SMR_CostDiffAmount">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="SMR_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SMR_DiffAmount">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="SMR_HVFlag">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="SMR_INCIL_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SMR_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SMR_INCSC_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SMR_LastAmount">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SMR_LastCostAmount">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SMR_LastPhyQty">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SMR_MonthDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SMR_PhyQty">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SMR_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SMR_SCG_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SMR_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SMR_TotalCostDiffAmount">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="SMR_TotalDiffAmount">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="SMR_TotalLastAmount">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="SMR_TotalLastCostAmount">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Global>^DHCSM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_StkMon.DHCSM_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SMR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_StkMon.DHCSM_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"R"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SMR_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINCILMon">
<Global>^DHCSM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_StkMon.DHCSM_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>SMR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"INCILMon"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SMR_INCIL_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{SMR_MonthDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHC_StkMon.DHCSM_Rowid}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{SMR_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINCIMon">
<Global>^DHCSM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_StkMon.DHCSM_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>SMR_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SMR_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_StkMon.DHCSM_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SMR_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCStkMonReportS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
