Class User.DHCStkMonRepLcBt Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SMRLB_Rowid, SqlTableName = DHC_StkMonRepLcBt, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On SMRLBChildsub [ IdKey, PrimaryKey, Unique ];

/// DHC_StkMonReport Parent Reference
Relationship SMRLBSMRParref As User.DHCStkMonReport [ Cardinality = parent, Inverse = ChildDHCStkMonRepLcBt, Required, SqlFieldName = SMRLB_SMR_Parref ];

/// SMRLB_Childsub
Property SMRLBChildsub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = SMRLB_Childsub ];

/// SMRLB_INCLB_DR
Property SMRLBINCLBDR As User.INCItmLcBt [ SqlColumnNumber = 3, SqlFieldName = SMRLB_INCLB_DR ];

/// SMRLB_Amount
Property SMRLBAmount As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = SMRLB_Amount ];

/// SMRLB_CostAmount
Property SMRLBCostAmount As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = SMRLB_CostAmount ];

/// SMRLB_LastAmount
Property SMRLBLastAmount As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = SMRLB_LastAmount ];

/// SMRLB_LastCostAmount
Property SMRLBLastCostAmount As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = SMRLB_LastCostAmount ];

/// SMRLB_Qty
Property SMRLBQty As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = SMRLB_Qty ];

/// SMRLB_LastQty
Property SMRLBLastQty As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = SMRLB_LastQty ];

/// SMRLB_Rec_Qty
Property SMRLBRecQty As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = SMRLB_Rec_Qty ];

/// SMRLB_Rec_Amt
Property SMRLBRecAmt As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = SMRLB_Rec_Amt ];

/// SMRLB_Rec_CoAmt
Property SMRLBRecCoAmt As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = SMRLB_Rec_CoAmt ];

/// SMRLB_Ret_Qty
Property SMRLBRetQty As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = SMRLB_Ret_Qty ];

/// SMRLB_Ret_Amt
Property SMRLBRetAmt As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = SMRLB_Ret_Amt ];

/// SMRLB_Trfo_Qty
Property SMRLBTrfoQty As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = SMRLB_Trfo_Qty ];

/// SMRLB_Trfo_Amt
Property SMRLBTrfoAmt As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = SMRLB_Trfo_Amt ];

/// SMRLB_Trfo_CoAmt
Property SMRLBTrfoCoAmt As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = SMRLB_Trfo_CoAmt ];

/// SMRLB_TrfI_Qty
Property SMRLBTrfIQty As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = SMRLB_TrfI_Qty ];

/// SMRLB_TrfI_Amt
Property SMRLBTrfIAmt As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = SMRLB_TrfI_Amt ];

/// SMRLB_TrfI_CoAmt
Property SMRLBTrfICoAmt As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = SMRLB_TrfI_CoAmt ];

/// SMRLB_Adj_Qty
Property SMRLBAdjQty As %Library.Float [ SqlColumnNumber = 21, SqlFieldName = SMRLB_Adj_Qty ];

/// SMRLB_Adj_Amt
Property SMRLBAdjAmt As %Library.Float [ SqlColumnNumber = 22, SqlFieldName = SMRLB_Adj_Amt ];

/// SMRLB_Adj_CoAmt
Property SMRLBAdjCoAmt As %Library.Float [ SqlColumnNumber = 23, SqlFieldName = SMRLB_Adj_CoAmt ];

/// SMRLB_Dsp_Qty
Property SMRLBDspQty As %Library.Float [ SqlColumnNumber = 24, SqlFieldName = SMRLB_Dsp_Qty ];

/// SMRLB_Dsp_Amt
Property SMRLBDspAmt As %Library.Float [ SqlColumnNumber = 25, SqlFieldName = SMRLB_Dsp_Amt ];

/// SMRLB_Dsp_CoAmt
Property SMRLBDspCoAmt As %Library.Float [ SqlColumnNumber = 26, SqlFieldName = SMRLB_Dsp_CoAmt ];

/// SMRLB_Cons_Qty
Property SMRLBConsQty As %Library.Float [ SqlColumnNumber = 27, SqlFieldName = SMRLB_Cons_Qty ];

/// SMRLB_Cons_Amt
Property SMRLBConsAmt As %Library.Float [ SqlColumnNumber = 28, SqlFieldName = SMRLB_Cons_Amt ];

/// SMRLB_Cons_CoAmt
Property SMRLBConsCoAmt As %Library.Float [ SqlColumnNumber = 29, SqlFieldName = SMRLB_Cons_CoAmt ];

/// SMRLB_Disp_Qty
Property SMRLBDispQty As %Library.Float [ SqlColumnNumber = 30, SqlFieldName = SMRLB_Disp_Qty ];

/// SMRLB_Disp_Amt
Property SMRLBDispAmt As %Library.Float [ SqlColumnNumber = 31, SqlFieldName = SMRLB_Disp_Amt ];

/// SMRLB_PhaRet_Qty
Property SMRLBPhaRetQty As %Library.Float [ SqlColumnNumber = 32, SqlFieldName = SMRLB_PhaRet_Qty ];

/// SMRLB_PhaRet_Amt
Property SMRLBPhaRetAmt As %Library.Float [ SqlColumnNumber = 33, SqlFieldName = SMRLB_PhaRet_Amt ];

/// SMRLB_Asp_Amt
Property SMRLBAspAmt As %Library.Float [ SqlColumnNumber = 34, SqlFieldName = SMRLB_Asp_Amt ];

/// SMRLB_Disp_CoAmt
Property SMRLBDispCoAmt As %Library.Float [ SqlColumnNumber = 35, SqlFieldName = SMRLB_Disp_CoAmt ];

/// SMRLB_Ret_CoAmt
Property SMRLBRetCoAmt As %Library.Float [ SqlColumnNumber = 36, SqlFieldName = SMRLB_Ret_CoAmt ];

/// SMRLB_PhaRet_CoAmt
Property SMRLBPhaRetCoAmt As %Library.Float [ SqlColumnNumber = 37, SqlFieldName = SMRLB_PhaRet_CoAmt ];

/// SMRLB_Asp_CoAmt
Property SMRLBAspCoAmt As %Library.Float [ SqlColumnNumber = 38, SqlFieldName = SMRLB_Asp_CoAmt ];

/// SMRLB_DspO_Qty
Property SMRLBDspOQty As %Library.Float [ SqlColumnNumber = 39, SqlFieldName = SMRLB_DspO_Qty ];

/// SMRLB_DspO_Amt
Property SMRLBDspOAmt As %Library.Float [ SqlColumnNumber = 40, SqlFieldName = SMRLB_DspO_Amt ];

/// SMRLB_DspO_CoAmt
Property SMRLBDspOCoAmt As %Library.Float [ SqlColumnNumber = 41, SqlFieldName = SMRLB_DspO_CoAmt ];

/// SMRLB_PhoRet_Qty
Property SMRLBPhoRetQty As %Library.Float [ SqlColumnNumber = 42, SqlFieldName = SMRLB_PhoRet_Qty ];

/// SMRLB_PhoRet_Amt
Property SMRLBPhoRetAmt As %Library.Float [ SqlColumnNumber = 43, SqlFieldName = SMRLB_PhoRet_Amt ];

/// SMRLB_PhoRet_CoAmt
Property SMRLBPhoRetCoAmt As %Library.Float [ SqlColumnNumber = 44, SqlFieldName = SMRLB_PhoRet_CoAmt ];

/// SMRLB_RecAsp_Amt
Property SMRLBRecAspAmt As %Library.Float [ SqlColumnNumber = 45, SqlFieldName = SMRLB_RecAsp_Amt ];

/// SMRLB_RecAsp_CoAmt
Property SMRLBRecAspCoAmt As %Library.Float [ SqlColumnNumber = 46, SqlFieldName = SMRLB_RecAsp_CoAmt ];

/// SMRLB_TrfIAsp_Amt
Property SMRLBTrfIAspAmt As %Library.Float [ SqlColumnNumber = 47, SqlFieldName = SMRLB_TrfIAsp_Amt ];

/// SMRLB_TrfIAsp_CoAmt
Property SMRLBTrfIAspCoAmt As %Library.Float [ SqlColumnNumber = 48, SqlFieldName = SMRLB_TrfIAsp_CoAmt ];

/// SMRLB_RetAsp_Amt
Property SMRLBRetAspAmt As %Library.Float [ SqlColumnNumber = 49, SqlFieldName = SMRLB_RetAsp_Amt ];

/// SMRLB_RetAsp_CoAmt
Property SMRLBRetAspCoAmt As %Library.Float [ SqlColumnNumber = 50, SqlFieldName = SMRLB_RetAsp_CoAmt ];

/// SMRLB_PhaRetAsp_Amt
Property SMRLBPhaRetAspAmt As %Library.Float [ SqlColumnNumber = 51, SqlFieldName = SMRLB_PhaRetAsp_Amt ];

/// SMRLB_PhaRetAsp_CoAmt
Property SMRLBPhaRetAspCoAmt As %Library.Float [ SqlColumnNumber = 52, SqlFieldName = SMRLB_PhaRetAsp_CoAmt ];

/// SMRLB_PhoRetAsp_Amt
Property SMRLBPhoRetAspAmt As %Library.Float [ SqlColumnNumber = 53, SqlFieldName = SMRLB_PhoRetAsp_Amt ];

/// SMRLB_PhoRetAsp_CoAmt
Property SMRLBPhoRetAspCoAmt As %Library.Float [ SqlColumnNumber = 54, SqlFieldName = SMRLB_PhoRetAsp_CoAmt ];

/// SMRLB_StkTk_Qty
Property SMRLBStkTkQty As %Library.Float [ SqlColumnNumber = 55, SqlFieldName = SMRLB_StkTk_Qty ];

/// SMRLB_StkTk_Amt
Property SMRLBStkTkAmt As %Library.Float [ SqlColumnNumber = 56, SqlFieldName = SMRLB_StkTk_Amt ];

/// SMRLB_StkTk_CoAmt
Property SMRLBStkTkCoAmt As %Library.Float [ SqlColumnNumber = 57, SqlFieldName = SMRLB_StkTk_CoAmt ];

/// SMRLB_BG_Amt
Property SMRLBBGAmt As %Library.Float [ SqlColumnNumber = 58, SqlFieldName = SMRLB_BG_Amt ];

/// SMRLB_BG_CoAmt
Property SMRLBBGCoAmt As %Library.Float [ SqlColumnNumber = 59, SqlFieldName = SMRLB_BG_CoAmt ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SMRLB_Adj_Amt">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>2</Piece>
</Data>
<Data name="SMRLB_Adj_CoAmt">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>3</Piece>
</Data>
<Data name="SMRLB_Adj_Qty">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>1</Piece>
</Data>
<Data name="SMRLB_Amount">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>5</Piece>
</Data>
<Data name="SMRLB_Asp_Amt">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>13</Piece>
</Data>
<Data name="SMRLB_Asp_CoAmt">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>14</Piece>
</Data>
<Data name="SMRLB_BG_Amt">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>14</Piece>
</Data>
<Data name="SMRLB_BG_CoAmt">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>15</Piece>
</Data>
<Data name="SMRLB_Cons_Amt">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>5</Piece>
</Data>
<Data name="SMRLB_Cons_CoAmt">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>6</Piece>
</Data>
<Data name="SMRLB_Cons_Qty">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>4</Piece>
</Data>
<Data name="SMRLB_CostAmount">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>7</Piece>
</Data>
<Data name="SMRLB_Disp_Amt">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>8</Piece>
</Data>
<Data name="SMRLB_Disp_CoAmt">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>9</Piece>
</Data>
<Data name="SMRLB_Disp_Qty">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>7</Piece>
</Data>
<Data name="SMRLB_DspO_Amt">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>16</Piece>
</Data>
<Data name="SMRLB_DspO_CoAmt">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>17</Piece>
</Data>
<Data name="SMRLB_DspO_Qty">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>15</Piece>
</Data>
<Data name="SMRLB_Dsp_Amt">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>14</Piece>
</Data>
<Data name="SMRLB_Dsp_CoAmt">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>15</Piece>
</Data>
<Data name="SMRLB_Dsp_Qty">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>13</Piece>
</Data>
<Data name="SMRLB_INCLB_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>1</Piece>
</Data>
<Data name="SMRLB_LastAmount">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>4</Piece>
</Data>
<Data name="SMRLB_LastCostAmount">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>6</Piece>
</Data>
<Data name="SMRLB_LastQty">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>2</Piece>
</Data>
<Data name="SMRLB_PhaRetAsp_Amt">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>7</Piece>
</Data>
<Data name="SMRLB_PhaRetAsp_CoAmt">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>8</Piece>
</Data>
<Data name="SMRLB_PhaRet_Amt">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>11</Piece>
</Data>
<Data name="SMRLB_PhaRet_CoAmt">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>12</Piece>
</Data>
<Data name="SMRLB_PhaRet_Qty">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>10</Piece>
</Data>
<Data name="SMRLB_PhoRetAsp_Amt">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>9</Piece>
</Data>
<Data name="SMRLB_PhoRetAsp_CoAmt">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>10</Piece>
</Data>
<Data name="SMRLB_PhoRet_Amt">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>19</Piece>
</Data>
<Data name="SMRLB_PhoRet_CoAmt">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>20</Piece>
</Data>
<Data name="SMRLB_PhoRet_Qty">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>18</Piece>
</Data>
<Data name="SMRLB_Qty">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>3</Piece>
</Data>
<Data name="SMRLB_RecAsp_Amt">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>1</Piece>
</Data>
<Data name="SMRLB_RecAsp_CoAmt">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>2</Piece>
</Data>
<Data name="SMRLB_Rec_Amt">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>2</Piece>
</Data>
<Data name="SMRLB_Rec_CoAmt">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>3</Piece>
</Data>
<Data name="SMRLB_Rec_Qty">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>1</Piece>
</Data>
<Data name="SMRLB_RetAsp_Amt">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>5</Piece>
</Data>
<Data name="SMRLB_RetAsp_CoAmt">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>6</Piece>
</Data>
<Data name="SMRLB_Ret_Amt">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>5</Piece>
</Data>
<Data name="SMRLB_Ret_CoAmt">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>6</Piece>
</Data>
<Data name="SMRLB_Ret_Qty">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>4</Piece>
</Data>
<Data name="SMRLB_StkTk_Amt">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>11</Piece>
</Data>
<Data name="SMRLB_StkTk_CoAmt">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>12</Piece>
</Data>
<Data name="SMRLB_StkTk_Qty">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>13</Piece>
</Data>
<Data name="SMRLB_TrfIAsp_Amt">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>3</Piece>
</Data>
<Data name="SMRLB_TrfIAsp_CoAmt">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>4</Piece>
</Data>
<Data name="SMRLB_TrfI_Amt">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>8</Piece>
</Data>
<Data name="SMRLB_TrfI_CoAmt">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>9</Piece>
</Data>
<Data name="SMRLB_TrfI_Qty">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>7</Piece>
</Data>
<Data name="SMRLB_Trfo_Amt">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>11</Piece>
</Data>
<Data name="SMRLB_Trfo_CoAmt">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>12</Piece>
</Data>
<Data name="SMRLB_Trfo_Qty">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>10</Piece>
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
<Field>SMRLB_Childsub</Field>
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
<Expression>{DHC_StkMonReport.SMR_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"B"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{SMRLB_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="INCLB">
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
<Field>SMRLB_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INCLB"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{SMRLB_INCLB_DR}</Expression>
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
<Expression>{SMRLB_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCStkMonRepLcBtS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
