/// in price
Class User.DHCStkMonStatInM Extends (%Library.Persistent, User.Abstract) [ SqlRowIdName = SMRDI_Rowid, SqlTableName = DHC_StkMonStatIn_M, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Property SMRDISMRDR As User.DHCStkMonReport [ SqlColumnNumber = 2, SqlFieldName = SMRDI_SMR_DR ];

Property SMRDIRECQTY As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = SMRDI_REC_QTY ];

Property SMRDIRecAmount As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = SMRDI_Rec_Amount ];

Property SMRDIRetQty As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = SMRDI_Ret_Qty ];

Property SMRDIRetAmount As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = SMRDI_Ret_Amount ];

Property SMRDITrfoQty As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = SMRDI_Trfo_Qty ];

Property SMRDITrfoAmount As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = SMRDI_Trfo_Amount ];

Property SMRDITrfIQty As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = SMRDI_TrfI_Qty ];

Property SMRDITrfIAmount As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = SMRDI_TrfI_Amount ];

Property SMRDIAdjQty As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = SMRDI_Adj_Qty ];

Property SMRDIAdjAmount As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = SMRDI_Adj_Amount ];

Property SMRDIDspPQty As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = SMRDI_DspP_Qty ];

Property SMRDIDspPAmount As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = SMRDI_DspP_Amount ];

Property SMRDIConsumeQty As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = SMRDI_Consume_Qty ];

Property SMRDIConsumeAmount As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = SMRDI_Consume_Amount ];

Property SMRDIDisposalQty As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = SMRDI_Disposal_Qty ];

Property SMRDIDisposalAmount As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = SMRDI_Disposal_Amount ];

Property SMRDIAspAmount As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = SMRDI_Asp_Amount ];

Property SMRDIPhaRetYQty As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = SMRDI_PhaRetY_Qty ];

Property SMRDIPhaRetYAmount As %Library.Float [ SqlColumnNumber = 21, SqlFieldName = SMRDI_PhaRetY_Amount ];

Property SMRDIGiftRecQty As %Library.Float [ SqlColumnNumber = 22, SqlFieldName = SMRDI_GiftRec_Qty ];

Property SMRDIGiftRecAmount As %Library.Float [ SqlColumnNumber = 23, SqlFieldName = SMRDI_GiftRec_Amount ];

Property SMRDIGiftTrfQty As %Library.Float [ SqlColumnNumber = 24, SqlFieldName = SMRDI_GiftTrf_Qty ];

Property SMRDIGiftTrfAmount As %Library.Float [ SqlColumnNumber = 25, SqlFieldName = SMRDI_GiftTrf_Amount ];

Property SMRDIChgCheckRecQty As %Library.Float [ SqlColumnNumber = 26, SqlFieldName = SMRDI_ChgCheckRec_Qty ];

Property SMRDIChgCheckRecAmount As %Library.Float [ SqlColumnNumber = 27, SqlFieldName = SMRDI_ChgCheckRec_Amount ];

Property SMRDIChgCheckRetQty As %Library.Float [ SqlColumnNumber = 28, SqlFieldName = SMRDI_ChgCheckRet_Qty ];

Property SMRDIChgCheckRetAmount As %Library.Float [ SqlColumnNumber = 29, SqlFieldName = SMRDI_ChgCheckRet_Amount ];

Property SMRDIDspFQty As %Library.Float [ SqlColumnNumber = 30, SqlFieldName = SMRDI_DspF_Qty ];

Property SMRDIDspFAmount As %Library.Float [ SqlColumnNumber = 31, SqlFieldName = SMRDI_DspF_Amount ];

Property SMRDIDspSQty As %Library.Float [ SqlColumnNumber = 32, SqlFieldName = SMRDI_DspS_Qty ];

Property SMRDIDspSAmount As %Library.Float [ SqlColumnNumber = 33, SqlFieldName = SMRDI_DspS_Amount ];

Property SMRDIPhaRetHQty As %Library.Float [ SqlColumnNumber = 34, SqlFieldName = SMRDI_PhaRetH_Qty ];

Property SMRDIPhaRetHAmount As %Library.Float [ SqlColumnNumber = 35, SqlFieldName = SMRDI_PhaRetH_Amount ];

Property SMRDIPhaRetZQty As %Library.Float [ SqlColumnNumber = 36, SqlFieldName = SMRDI_PhaRetZ_Qty ];

Property SMRDIPhaRetZAmount As %Library.Float [ SqlColumnNumber = 37, SqlFieldName = SMRDI_PhaRetZ_Amount ];

Property SMRDIRecAspAmount As %Library.Float [ SqlColumnNumber = 38, SqlFieldName = SMRDI_RecAsp_Amount ];

Property SMRDITrfIAspAmount As %Library.Float [ SqlColumnNumber = 39, SqlFieldName = SMRDI_TrfIAsp_Amount ];

Property SMRDIRetAspAmount As %Library.Float [ SqlColumnNumber = 40, SqlFieldName = SMRDI_RetAsp_Amount ];

Property SMRDIStkTkQty As %Library.Float [ SqlColumnNumber = 41, SqlFieldName = SMRDI_StkTk_Qty ];

Property SMRDIStkTkAmount As %Library.Float [ SqlColumnNumber = 42, SqlFieldName = SMRDI_StkTk_Amount ];

Property SMRDIManuXQty As %Library.Float [ SqlColumnNumber = 43, SqlFieldName = SMRDI_ManuX_Qty ];

Property SMRDIManuXAmount As %Library.Float [ SqlColumnNumber = 44, SqlFieldName = SMRDI_ManuX_Amount ];

Property SMRDIManuMQty As %Library.Float [ SqlColumnNumber = 45, SqlFieldName = SMRDI_ManuM_Qty ];

Property SMRDIManuMAmount As %Library.Float [ SqlColumnNumber = 46, SqlFieldName = SMRDI_ManuM_Amount ];

Property SMRDIMRecQty As %Library.Float [ SqlColumnNumber = 47, SqlFieldName = SMRDI_MRec_Qty ];

Property SMRDIMRecAmount As %Library.Float [ SqlColumnNumber = 48, SqlFieldName = SMRDI_MRec_Amount ];

Property SMRDIPhoRetAspAmount As %Library.Float [ SqlColumnNumber = 49, SqlFieldName = SMRDI_PhoRetAsp_Amount ];

Property SMRDIPhaRetAspAmount As %Library.Float [ SqlColumnNumber = 50, SqlFieldName = SMRDI_PhaRetAsp_Amount ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^SMSTATIM)</SqlIdExpression>
<SQLMap name="DataMasterSMSTATIm">
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
<Data name="SMRDI_DspF_Amount">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="SMRDI_DspF_Qty">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
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
<Global>^SMSTATIM</Global>
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
<SQLMap name="IndexSMRDRm">
<Global>^SMSTATIM</Global>
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
<SqlRowIdName>SMRDI_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCStkMonStatInMS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^SMSTATIM)
	s oldI = +$g(^mdata("DHCSTKMONSTATINM"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^SMSTATIM = maxI
	s ^mdata("DHCSTKMONSTATINM") = maxI
}

}
