Class User.DHCStkMonTrans Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SMT_Rowid, SqlTableName = DHC_StkMonTrans, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 25000;

Index RowIDBasedIDKeyIndex On SMTChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_StkMonReport Parent Reference
Relationship SMTSMRParref As User.DHCStkMonReport [ Cardinality = parent, Inverse = ChildDHCStkMonTrans, Required, SqlFieldName = SMT_SMR_Parref ];

/// SMT_ChildSub
Property SMTChildSub As %Library.Float [ InitialExpression = {$o(^DHCSM($p(%d(0),"||",1),"R",$p(%d(0),"||",2),"T",""),-1)+1}, Required, SqlColumnNumber = 2, SqlFieldName = SMT_ChildSub ];

/// SMT_TransType
Property SMTTransType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SMT_TransType ];

/// Pointer the ctloc or User or Vendor
Property SMTPointer As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SMT_Pointer ];

/// SMT_PhyQty
Property SMTPhyQty As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = SMT_PhyQty ];

/// SMT_Amount
Property SMTAmount As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = SMT_Amount ];

/// SMT_CostAmount
Property SMTCostAmount As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = SMT_CostAmount ];

/// pointer to ssuser
Property SMTRelaLocDR As User.CTLoc [ SqlColumnNumber = 8, SqlFieldName = SMT_RelaLoc_DR ];

/// SMT_RelaUser
Property SMTRelaUsrDR As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = SMT_RelaUsr_DR ];

/// SMT_RelaApcv_DR
Property SMTRelaApcvDR As User.APCVendor [ SqlColumnNumber = 10, SqlFieldName = SMT_RelaApcv_DR ];

/// SMT_OperateType
Property SMTOperateType As User.DHCOperateType [ SqlColumnNumber = 11, SqlFieldName = SMT_OperateType ];

/// SMT_SLG_DR
Property SMTSLGDR As User.DHCStkLocGroup [ SqlColumnNumber = 12, SqlFieldName = SMT_SLG_DR ];

/// SMT_INCSC_DR
Property SMTINCSCDR As User.INCStkCat [ SqlColumnNumber = 13, SqlFieldName = SMT_INCSC_DR ];

/// SMT_SCG_DR
Property SMTSCGDR As User.DHCStkCatGroup [ SqlColumnNumber = 14, SqlFieldName = SMT_SCG_DR ];

/// SMT_SUMTL_DR -> DHC_StkMonSum_TransLoc
Property SMTSUMTLDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = SMT_SUMTL_DR ];

/// SMT_RelaOrg - SMTPointer相应机构(G,R:供应商)
Property SMTRelaOrg As %Library.String [ SqlColumnNumber = 16, SqlFieldName = SMT_RelaOrg ];

Storage SQLStorage
{
<ExtentSize>25000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SMT_Amount">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SMT_CostAmount">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SMT_INCSC_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SMT_OperateType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SMT_PhyQty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SMT_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SMT_RelaApcv_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SMT_RelaLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SMT_RelaOrg">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SMT_RelaUsr_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SMT_SCG_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SMT_SLG_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SMT_SUMTL_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SMT_TransType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCSM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_StkMon.DHCSM_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_StkMonReport.SMR_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>SMT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_StkMon.DHCSM_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"R"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHC_StkMonReport.SMR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>"T"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{SMT_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSCG">
<Global>^DHCSM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_StkMon.DHCSM_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DHC_StkMonReport.SMR_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>SMT_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"TSCG"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{SMT_TransType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{SMT_SCG_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHC_StkMon.DHCSM_Rowid}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{DHC_StkMonReport.SMR_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>Sub</AccessType>
<Expression>{SMT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStkCat">
<Global>^DHCSM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_StkMon.DHCSM_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DHC_StkMonReport.SMR_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>SMT_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"TSC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{SMT_TransType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{SMT_INCSC_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHC_StkMon.DHCSM_Rowid}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{DHC_StkMonReport.SMR_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>Sub</AccessType>
<Expression>{SMT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSumTransLoc">
<Global>^DHCSM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_StkMon.DHCSM_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHC_StkMonReport.SMR_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>SMT_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"SUMTL"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{SMT_SUMTL_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_StkMon.DHCSM_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHC_StkMonReport.SMR_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{SMT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypePointer">
<Global>^DHCSM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_StkMon.DHCSM_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DHC_StkMonReport.SMR_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>SMT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"TC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{SMT_TransType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{SMT_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHC_StkMon.DHCSM_Rowid}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{DHC_StkMonReport.SMR_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>Sub</AccessType>
<Expression>{SMT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCStkMonTransS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
