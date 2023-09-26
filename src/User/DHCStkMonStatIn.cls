/// in price
Class User.DHCStkMonStatIn Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SMRDI_Rowid, SqlTableName = DHC_StkMonStatIn, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// SMRDI_SMR_DR
Property SMRDISMRDR As User.DHCStkMonReport [ SqlColumnNumber = 2, SqlFieldName = SMRDI_SMR_DR ];

/// SMRDI_REC_QTY
Property SMRDIRECQTY As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = SMRDI_REC_QTY ];

/// SMRDI_Rec_Amount
Property SMRDIRecAmount As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = SMRDI_Rec_Amount ];

/// SMRDI_Ret_Qty
Property SMRDIRetQty As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = SMRDI_Ret_Qty ];

/// SMRDI_Ret_Amount
Property SMRDIRetAmount As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = SMRDI_Ret_Amount ];

/// SMRDI_Trfo_Qty
Property SMRDITrfoQty As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = SMRDI_Trfo_Qty ];

/// SMRDI_Trfo_Amount
Property SMRDITrfoAmount As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = SMRDI_Trfo_Amount ];

/// SMRDI_TrfI_Qty
Property SMRDITrfIQty As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = SMRDI_TrfI_Qty ];

/// SMRDI_TrfI_Amount
Property SMRDITrfIAmount As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = SMRDI_TrfI_Amount ];

/// SMRDI_Adj_Qty
Property SMRDIAdjQty As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = SMRDI_Adj_Qty ];

/// SMRDI_Adj_Amount
Property SMRDIAdjAmount As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = SMRDI_Adj_Amount ];

/// SMRDI_DspP_Qty
Property SMRDIDspPQty As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = SMRDI_DspP_Qty ];

/// SMRDI_DspP_Amount
Property SMRDIDspPAmount As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = SMRDI_DspP_Amount ];

/// SMRDI_Consume_Qty
Property SMRDIConsumeQty As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = SMRDI_Consume_Qty ];

/// SMRDI_Consume_Amount
Property SMRDIConsumeAmount As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = SMRDI_Consume_Amount ];

/// SMRDI_Disposal_Qty
Property SMRDIDisposalQty As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = SMRDI_Disposal_Qty ];

/// SMRDI_Disposal_Amount
Property SMRDIDisposalAmount As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = SMRDI_Disposal_Amount ];

/// SMRDI_Asp_Amount
Property SMRDIAspAmount As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = SMRDI_Asp_Amount ];

/// SMRDI_PhaRetY_Qty
Property SMRDIPhaRetYQty As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = SMRDI_PhaRetY_Qty ];

/// SMRDI_PhaRetY_Amount
Property SMRDIPhaRetYAmount As %Library.Float [ SqlColumnNumber = 21, SqlFieldName = SMRDI_PhaRetY_Amount ];

/// SMRDI_GiftRec_Qty
Property SMRDIGiftRecQty As %Library.Float [ SqlColumnNumber = 22, SqlFieldName = SMRDI_GiftRec_Qty ];

/// SMRD_GiftRec_Amount
Property SMRDIGiftRecAmount As %Library.Float [ SqlColumnNumber = 23, SqlFieldName = SMRDI_GiftRec_Amount ];

/// SMRDI_GiftTrf_Qty
Property SMRDIGiftTrfQty As %Library.Float [ SqlColumnNumber = 24, SqlFieldName = SMRDI_GiftTrf_Qty ];

/// SMRDI_GiftTrf_Amount
Property SMRDIGiftTrfAmount As %Library.Float [ SqlColumnNumber = 25, SqlFieldName = SMRDI_GiftTrf_Amount ];

/// SMRDI_ChgCheckRec_Qty
Property SMRDIChgCheckRecQty As %Library.Float [ SqlColumnNumber = 26, SqlFieldName = SMRDI_ChgCheckRec_Qty ];

/// SMRDI_ChgCheckRec_Amount
Property SMRDIChgCheckRecAmount As %Library.Float [ SqlColumnNumber = 27, SqlFieldName = SMRDI_ChgCheckRec_Amount ];

/// SMRDI_ChgCheckRet_Qty
Property SMRDIChgCheckRetQty As %Library.Float [ SqlColumnNumber = 28, SqlFieldName = SMRDI_ChgCheckRet_Qty ];

/// SMRDI_ChgCheckRet_Amount
Property SMRDIChgCheckRetAmount As %Library.Float [ SqlColumnNumber = 29, SqlFieldName = SMRDI_ChgCheckRet_Amount ];

/// SMRDI_DspF_Qty
Property SMRDIDspFQty As %Library.Float [ SqlColumnNumber = 30, SqlFieldName = SMRDI_DspF_Qty ];

/// SMRDI_DspF_Amount
Property SMRDIDspFAmount As %Library.Float [ SqlColumnNumber = 31, SqlFieldName = SMRDI_DspF_Amount ];

/// SMRDI_DspS_Qty
Property SMRDIDspSQty As %Library.Float [ SqlColumnNumber = 32, SqlFieldName = SMRDI_DspS_Qty ];

/// SMRDI_DspS_Amount
Property SMRDIDspSAmount As %Library.Float [ SqlColumnNumber = 33, SqlFieldName = SMRDI_DspS_Amount ];

/// SMRDI_PhaRetH_Qty
Property SMRDIPhaRetHQty As %Library.Float [ SqlColumnNumber = 34, SqlFieldName = SMRDI_PhaRetH_Qty ];

/// SMRDI_PhaRetH_Amount
Property SMRDIPhaRetHAmount As %Library.Float [ SqlColumnNumber = 35, SqlFieldName = SMRDI_PhaRetH_Amount ];

/// SMRDI_PhaRetZ_Qty
Property SMRDIPhaRetZQty As %Library.Float [ SqlColumnNumber = 36, SqlFieldName = SMRDI_PhaRetZ_Qty ];

/// SMRDI_PhaRetZ_Amount
Property SMRDIPhaRetZAmount As %Library.Float [ SqlColumnNumber = 37, SqlFieldName = SMRDI_PhaRetZ_Amount ];

/// SMRDI_RecAsp_Amount
Property SMRDIRecAspAmount As %Library.Float [ SqlColumnNumber = 38, SqlFieldName = SMRDI_RecAsp_Amount ];

/// SMRDI_TrfIAsp_Amount
Property SMRDITrfIAspAmount As %Library.Float [ SqlColumnNumber = 39, SqlFieldName = SMRDI_TrfIAsp_Amount ];

/// SMRDI_RetAsp_Amount
Property SMRDIRetAspAmount As %Library.Float [ SqlColumnNumber = 40, SqlFieldName = SMRDI_RetAsp_Amount ];

/// SMRDI_StkTk_Qty
Property SMRDIStkTkQty As %Library.Float [ SqlColumnNumber = 41, SqlFieldName = SMRDI_StkTk_Qty ];

/// SMRDI_StkTk_Amount
Property SMRDIStkTkAmount As %Library.Float [ SqlColumnNumber = 42, SqlFieldName = SMRDI_StkTk_Amount ];

/// SMRDI_ManuX_Qty
Property SMRDIManuXQty As %Library.Float [ SqlColumnNumber = 43, SqlFieldName = SMRDI_ManuX_Qty ];

/// SMRDI_ManuX_Amount
Property SMRDIManuXAmount As %Library.Float [ SqlColumnNumber = 44, SqlFieldName = SMRDI_ManuX_Amount ];

/// SMRDI_ManuM_Qty
Property SMRDIManuMQty As %Library.Float [ SqlColumnNumber = 45, SqlFieldName = SMRDI_ManuM_Qty ];

/// SMRDI_ManuM_Amount
Property SMRDIManuMAmount As %Library.Float [ SqlColumnNumber = 46, SqlFieldName = SMRDI_ManuM_Amount ];

/// SMRDI_MRec_Qty
Property SMRDIMRecQty As %Library.Float [ SqlColumnNumber = 47, SqlFieldName = SMRDI_MRec_Qty ];

/// SMRDI_MRec_Amount
Property SMRDIMRecAmount As %Library.Float [ SqlColumnNumber = 48, SqlFieldName = SMRDI_MRec_Amount ];

/// SMRDI_PhoRetAsp_Amount
Property SMRDIPhoRetAspAmount As %Library.Float [ SqlColumnNumber = 49, SqlFieldName = SMRDI_PhoRetAsp_Amount ];

/// SMRDI_PhaRetAsp_Amount
Property SMRDIPhaRetAspAmount As %Library.Float [ SqlColumnNumber = 50, SqlFieldName = SMRDI_PhaRetAsp_Amount ];

/// SMRDI_LastNoPaid_Amount(上期未付款金额)
Property SMRDILastNoPaidAmount As %Library.Float [ SqlColumnNumber = 51, SqlFieldName = SMRDI_LastNoPaid_Amount ];

/// SMRDI_NoPaid_Amount(本期未付款金额)
Property SMRDINoPaidAmount As %Library.Float [ SqlColumnNumber = 52, SqlFieldName = SMRDI_NoPaid_Amount ];

/// SMRDI_Paid_Amount(本期付款金额(入库单))
Property SMRDIPaidAmount As %Library.Float [ SqlColumnNumber = 53, SqlFieldName = SMRDI_Paid_Amount ];

/// SMRDI_PaidRet_Amount(本期付款金额(退货单))
Property SMRDIPaidRetAmount As %Library.Float [ SqlColumnNumber = 54, SqlFieldName = SMRDI_PaidRet_Amount ];

/// SMRDI_Unpay_Amount
Property SMRDIUnpayAmount As %Library.Float [ SqlColumnNumber = 55, SqlFieldName = SMRDI_Unpay_Amount ];

/// SMRDI_Unpay_Qty
Property SMRDIUnpayQty As %Library.Float [ SqlColumnNumber = 56, SqlFieldName = SMRDI_Unpay_Qty ];

/// SMRDI_adjzy_Amount
Property SMRDIadjzyAmount As %Library.Float [ SqlColumnNumber = 57, SqlFieldName = SMRDI_adjzy_Amount ];

/// SMRDI_adjzy_Qty
Property SMRDIadjzyQty As %Library.Float [ SqlColumnNumber = 58, SqlFieldName = SMRDI_adjzy_Qty ];

/// SMRDI_FinAmtLast - 财务期初(上期结存)
Property SMRDIFinAmtLast As %Library.Float [ SqlColumnNumber = 59, SqlFieldName = SMRDI_FinAmtLast ];

/// SMRDI_FinAmt - 财务本期结存
Property SMRDIFinAmt As %Library.Float [ SqlColumnNumber = 60, SqlFieldName = SMRDI_FinAmt ];

/// SMRDI_FinInAmt - 财务本期收入(入库-退货)
Property SMRDIFinInAmt As %Library.Float [ SqlColumnNumber = 61, SqlFieldName = SMRDI_FinInAmt ];

/// SMRDI_FinOutAmt  - 财务本期支出(出库-退库)
Property SMRDIFinOutAmt As %Library.Float [ SqlColumnNumber = 62, SqlFieldName = SMRDI_FinOutAmt ];

Property SMRDIBGQty As %Library.Float [ SqlColumnNumber = 63, SqlFieldName = SMRDI_BG_Qty ];

Property SMRDIBGAmount As %Library.Float [ SqlColumnNumber = 64, SqlFieldName = SMRDI_BG_Amount ];

Property SMRDIDspPAAmount As %Library.Float [ SqlColumnNumber = 65, SqlFieldName = SMRDI_DspPA_Amount ];

Property SMRDIDspFAAmount As %Library.Float [ SqlColumnNumber = 66, SqlFieldName = SMRDI_DspFA_Amount ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^SMSTATI)</SqlIdExpression>
<SQLMap name="DataMasterSMSTATI">
<Data name="SMRDI_Adj_Amount">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SMRDI_Adj_Qty">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SMRDI_Asp_Amount">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="SMRDI_BG_Amount">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="SMRDI_BG_Qty">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="SMRDI_ChgCheckRec_Amount">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="SMRDI_ChgCheckRec_Qty">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="SMRDI_ChgCheckRet_Amount">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="SMRDI_ChgCheckRet_Qty">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="SMRDI_Consume_Amount">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SMRDI_Consume_Qty">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SMRDI_Disposal_Amount">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SMRDI_Disposal_Qty">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SMRDI_DspFA_Amount">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="SMRDI_DspF_Amount">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="SMRDI_DspF_Qty">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="SMRDI_DspPA_Amount">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="SMRDI_DspP_Amount">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="SMRDI_DspP_Qty">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="SMRDI_DspS_Amount">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="SMRDI_DspS_Qty">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="SMRDI_FinAmt">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="SMRDI_FinAmtLast">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="SMRDI_FinInAmt">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="SMRDI_FinOutAmt">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="SMRDI_GiftRec_Amount">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="SMRDI_GiftRec_Qty">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="SMRDI_GiftTrf_Amount">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="SMRDI_GiftTrf_Qty">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="SMRDI_LastNoPaid_Amount">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="SMRDI_MRec_Amount">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="SMRDI_MRec_Qty">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="SMRDI_ManuM_Amount">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="SMRDI_ManuM_Qty">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="SMRDI_ManuX_Amount">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="SMRDI_ManuX_Qty">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="SMRDI_NoPaid_Amount">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="SMRDI_PaidRet_Amount">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="SMRDI_Paid_Amount">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="SMRDI_PhaRetAsp_Amount">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="SMRDI_PhaRetH_Amount">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="SMRDI_PhaRetH_Qty">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="SMRDI_PhaRetY_Amount">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="SMRDI_PhaRetY_Qty">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="SMRDI_PhaRetZ_Amount">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="SMRDI_PhaRetZ_Qty">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="SMRDI_PhoRetAsp_Amount">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="SMRDI_REC_QTY">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SMRDI_RecAsp_Amount">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="SMRDI_Rec_Amount">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SMRDI_RetAsp_Amount">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="SMRDI_Ret_Amount">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SMRDI_Ret_Qty">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SMRDI_SMR_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SMRDI_StkTk_Amount">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="SMRDI_StkTk_Qty">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="SMRDI_TrfIAsp_Amount">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="SMRDI_TrfI_Amount">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SMRDI_TrfI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SMRDI_Trfo_Amount">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SMRDI_Trfo_Qty">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SMRDI_Unpay_Amount">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="SMRDI_Unpay_Qty">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="SMRDI_adjzy_Amount">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="SMRDI_adjzy_Qty">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Global>^SMSTATI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SMRDI_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{SMRDI_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSMRDR">
<Global>^SMSTATI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SMRDI_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SMR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SMRDI_SMR_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{SMRDI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCStkMonStatInS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^SMSTATI)
	s oldI = +$g(^mdata("DHCSTKMONSTATIN"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^SMSTATI = maxI
	s ^mdata("DHCSTKMONSTATIN") = maxI
}

}
