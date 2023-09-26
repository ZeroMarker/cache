Class User.DHCStkMonStatM Extends (%Library.Persistent, User.Abstract) [ SqlRowIdName = SMRD_Rowid, SqlTableName = DHC_StkMonStat_M, StorageStrategy = SQLStorage ]
{

Property SMRDSMRDR As User.DHCStkMonReport [ SqlColumnNumber = 2, SqlFieldName = SMRD_SMR_DR ];

Property SMRDRecQty As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = SMRD_Rec_Qty ];

Property SMRDRecAmount As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = SMRD_Rec_Amount ];

Property SMRDRetQty As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = SMRD_Ret_Qty ];

Property SMRDRetAmount As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = SMRD_Ret_Amount ];

Property SMRDTrfoQty As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = SMRD_Trfo_Qty ];

Property SMRDTrfoAmount As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = SMRD_Trfo_Amount ];

Property SMRDTrfIQty As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = SMRD_TrfI_Qty ];

Property SMRDTrfIAmount As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = SMRD_TrfI_Amount ];

Property SMRDAdjQty As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = SMRD_Adj_Qty ];

Property SMRDAdjAmount As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = SMRD_Adj_Amount ];

Property SMRDDspPQty As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = SMRD_DspP_Qty ];

Property SMRDDspPAmount As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = SMRD_DspP_Amount ];

Property SMRDConsumeQty As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = SMRD_Consume_Qty ];

Property SMRDConsumeAmount As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = SMRD_Consume_Amount ];

Property SMRDDisposalQty As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = SMRD_Disposal_Qty ];

Property SMRDDisposalAmount As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = SMRD_Disposal_Amount ];

Property SMRDAspAmount As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = SMRD_Asp_Amount ];

Property SMRDPhaRetYQty As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = SMRD_PhaRetY_Qty ];

Property SMRDPhaRetYAmount As %Library.Float [ SqlColumnNumber = 21, SqlFieldName = SMRD_PhaRetY_Amount ];

Property SMRDDspFQty As %Library.Float [ SqlColumnNumber = 22, SqlFieldName = SMRD_DspF_Qty ];

Property SMRDDspFAmount As %Library.Float [ SqlColumnNumber = 23, SqlFieldName = SMRD_DspF_Amount ];

Property SMRDDspSQty As %Library.Float [ SqlColumnNumber = 24, SqlFieldName = SMRD_DspS_Qty ];

Property SMRDDspSAmount As %Library.Float [ SqlColumnNumber = 25, SqlFieldName = SMRD_DspS_Amount ];

Property SMRDPhaRetHQty As %Library.Float [ SqlColumnNumber = 26, SqlFieldName = SMRD_PhaRetH_Qty ];

Property SMRDPhaRetHAmount As %Library.Float [ SqlColumnNumber = 27, SqlFieldName = SMRD_PhaRetH_Amount ];

Property SMRDPhaRetZQty As %Library.Float [ SqlColumnNumber = 28, SqlFieldName = SMRD_PhaRetZ_Qty ];

Property SMRDPhaRetZAmount As %Library.Float [ SqlColumnNumber = 29, SqlFieldName = SMRD_PhaRetZ_Amount ];

Property SMRDGiftRecQty As %Library.Float [ SqlColumnNumber = 30, SqlFieldName = SMRD_GiftRec_Qty ];

Property SMRDGiftRecAmount As %Library.Float [ SqlColumnNumber = 31, SqlFieldName = SMRD_GiftRec_Amount ];

Property SMRDGiftTrfQty As %Library.Float [ SqlColumnNumber = 32, SqlFieldName = SMRD_GiftTrf_Qty ];

Property SMRDGiftTrfAmount As %Library.Float [ SqlColumnNumber = 33, SqlFieldName = SMRD_GiftTrf_Amount ];

Property SMRDChgCheckRecQty As %Library.Float [ SqlColumnNumber = 34, SqlFieldName = SMRD_ChgCheckRec_Qty ];

Property SMRDChgCheckRecAmount As %Library.Float [ SqlColumnNumber = 35, SqlFieldName = SMRD_ChgCheckRec_Amount ];

Property SMRDChgCheckRetQty As %Library.Float [ SqlColumnNumber = 36, SqlFieldName = SMRD_ChgCheckRet_Qty ];

Property SMRDChgCheckRetAmount As %Library.Float [ SqlColumnNumber = 37, SqlFieldName = SMRD_ChgCheckRet_Amount ];

Property SMRDRetAspAmount As %Library.Float [ SqlColumnNumber = 38, SqlFieldName = SMRD_RetAsp_Amount ];

Property SMRDPhaRetAspAmount As %Library.Float [ SqlColumnNumber = 39, SqlFieldName = SMRD_PhaRetAsp_Amount ];

Property SMRDMrecQty As %Library.Float [ SqlColumnNumber = 40, SqlFieldName = SMRD_Mrec_Qty ];

Property SMRDMrecAmount As %Library.Float [ SqlColumnNumber = 41, SqlFieldName = SMRD_Mrec_Amount ];

Property SMRDStkTkQty As %Library.Float [ SqlColumnNumber = 42, SqlFieldName = SMRD_StkTk_Qty ];

Property SMRDStkTkAmount As %Library.Float [ SqlColumnNumber = 43, SqlFieldName = SMRD_StkTk_Amount ];

Property SMRDManuXQty As %Library.Float [ SqlColumnNumber = 44, SqlFieldName = SMRD_ManuX_Qty ];

Property SMRDManuXAmount As %Library.Float [ SqlColumnNumber = 45, SqlFieldName = SMRD_ManuX_Amount ];

Property SMRDManuMQty As %Library.Float [ SqlColumnNumber = 46, SqlFieldName = SMRD_ManuM_Qty ];

Property SMRDManuMAmount As %Library.Float [ SqlColumnNumber = 47, SqlFieldName = SMRD_ManuM_Amount ];

Property SMRDPhoRetAspAmount As %Library.Float [ SqlColumnNumber = 48, SqlFieldName = SMRD_PhoRetAsp_Amount ];

Property SMRDTrfIAspAmount As %Library.Float [ SqlColumnNumber = 49, SqlFieldName = SMRD_TrfIAsp_Amount ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^SMSTATM)</SqlIdExpression>
<SQLMap name="DataMasterSMSTATm">
<Data name="SMRD_Adj_Amount">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SMRD_Adj_Qty">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SMRD_Asp_Amount">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="SMRD_ChgCheckRec_Amount">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="SMRD_ChgCheckRec_Qty">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="SMRD_ChgCheckRet_Amount">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="SMRD_ChgCheckRet_Qty">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="SMRD_Consume_Amount">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SMRD_Consume_Qty">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SMRD_Disposal_Amount">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SMRD_Disposal_Qty">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SMRD_DspF_Amount">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="SMRD_DspF_Qty">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="SMRD_DspP_Amount">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="SMRD_DspP_Qty">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="SMRD_DspS_Amount">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="SMRD_DspS_Qty">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="SMRD_GiftRec_Amount">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="SMRD_GiftRec_Qty">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="SMRD_GiftTrf_Amount">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="SMRD_GiftTrf_Qty">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="SMRD_ManuM_Amount">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="SMRD_ManuM_Qty">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="SMRD_ManuX_Amount">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="SMRD_ManuX_Qty">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="SMRD_Mrec_Amount">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="SMRD_Mrec_Qty">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="SMRD_PhaRetAsp_Amount">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="SMRD_PhaRetH_Amount">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="SMRD_PhaRetH_Qty">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="SMRD_PhaRetY_Amount">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="SMRD_PhaRetY_Qty">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="SMRD_PhaRetZ_Amount">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="SMRD_PhaRetZ_Qty">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="SMRD_PhoRetAsp_Amount">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="SMRD_Rec_Amount">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SMRD_Rec_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SMRD_RetAsp_Amount">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="SMRD_Ret_Amount">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SMRD_Ret_Qty">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SMRD_SMR_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SMRD_StkTk_Amount">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="SMRD_StkTk_Qty">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="SMRD_TrfIAsp_Amount">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="SMRD_TrfI_Amount">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SMRD_TrfI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SMRD_Trfo_Amount">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SMRD_Trfo_Qty">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^SMSTATM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SMRD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{SMRD_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSMRDRm">
<Global>^SMSTATM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SMRD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"SMR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SMRD_SMR_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{SMRD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SMRD_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCStkMonStatMS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^SMSTATM)
	s oldI = +$g(^mdata("DHCSTKMONSTATM"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^SMSTATM = maxI
	s ^mdata("DHCSTKMONSTATM") = maxI
}

Parameter EXTENTSIZE = 250;

}
