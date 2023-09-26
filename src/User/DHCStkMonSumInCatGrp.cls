/// 
Class User.DHCStkMonSumInCatGrp Extends (%Library.Persistent, User.Abstract) [ SqlRowIdName = SUMCG_RowId, SqlTableName = DHC_StkMonSumIn_CatGrp, StorageStrategy = SQLStorage1 ]
{

Parameter EXTENTSIZE = 250;

Property SUMCGSMDR As User.DHCStkMon [ SqlColumnNumber = 2, SqlFieldName = SUMCG_SM_DR ];

Property SUMCGStkCatDR As User.INCStkCat [ SqlColumnNumber = 3, SqlFieldName = SUMCG_StkCat_DR ];

Property SUMCGSCGDR As User.DHCStkCatGroup [ SqlColumnNumber = 4, SqlFieldName = SUMCG_SCG_DR ];

Property SUMCGAmt As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = SUMCG_Amt ];

Property SUMCGLastAmt As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = SUMCG_LastAmt ];

Property SUMCGRecAmt As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = SUMCG_Rec_Amt ];

Property SUMCGRetAmt As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = SUMCG_Ret_Amt ];

Property SUMCGTrfOAmt As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = SUMCG_Trf_O_Amt ];

Property SUMCGTrfIAmt As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = SUMCG_Trf_I_Amt ];

Property SUMCGAdjAmt As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = SUMCG_Adj_Amt ];

Property SUMCGConsumeAmt As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = SUMCG_Consume_Amt ];

Property SUMCGDisposalAmt As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = SUMCG_Disposal_Amt ];

Property SUMCGAspAmt As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = SUMCG_Asp_Amt ];

Property SUMCGGiftRecAmt As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = SUMCG_Gift_Rec_Amt ];

Property SUMCGGiftTrfAmt As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = SUMCG_Gift_Trf_Amt ];

Property SUMCGChgCheckRecAmt As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = SUMCG_ChgCheck_Rec_Amt ];

Property SUMCGChgCheckRetAmt As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = SUMCG_ChgCheck_Ret_Amt ];

/// 住院发
Property SUMCGDspPAmt As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = SUMCG_Dsp_P_Amt ];

/// 住院退
Property SUMCGPhaRetYAmt As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = SUMCG_PhaRet_Y_Amt ];

/// 门诊发
Property SUMCGDspFAmt As %Library.Float [ SqlColumnNumber = 21, SqlFieldName = SUMCG_Dsp_F_Amt ];

/// 门诊退
Property SUMCGPhaRetHAmt As %Library.Float [ SqlColumnNumber = 22, SqlFieldName = SUMCG_PhaRet_H_Amt ];

Property SUMCGDspSAmt As %Library.Float [ SqlColumnNumber = 23, SqlFieldName = SUMCG_Dsp_S_Amt ];

Property SUMCGPhaRetZAmt As %Library.Float [ SqlColumnNumber = 24, SqlFieldName = SUMCG_PhaRet_Z_Amt ];

Property SUMCGStkTkAmt As %Library.Float [ SqlColumnNumber = 25, SqlFieldName = SUMCG_StkTk_Amt ];

Property SUMCGManuXAmt As %Library.Float [ SqlColumnNumber = 26, SqlFieldName = SUMCG_Manu_X_Amt ];

Property SUMCGManuMAmt As %Library.Float [ SqlColumnNumber = 27, SqlFieldName = SUMCG_Manu_M_Amt ];

Property SUMCGMRecAmt As %Library.Float [ SqlColumnNumber = 28, SqlFieldName = SUMCG_M_Rec_Amt ];

Property SUMCGRecAspAmt As %Library.Float [ SqlColumnNumber = 29, SqlFieldName = SUMCG_Rec_Asp_Amt ];

Property SUMCGRetAspAmt As %Library.Float [ SqlColumnNumber = 30, SqlFieldName = SUMCG_Ret_Asp_Amt ];

Property SUMCGTrfIAspAmt As %Library.Float [ SqlColumnNumber = 31, SqlFieldName = SUMCG_Trf_I_Asp_Amt ];

/// (门诊)退调价损益
Property SUMCGPhoRetAspAmt As %Library.Float [ SqlColumnNumber = 32, SqlFieldName = SUMCG_Pho_Ret_Asp_Amt ];

/// (住院)退调价损益
Property SUMCGPhaRetAspAmt As %Library.Float [ SqlColumnNumber = 33, SqlFieldName = SUMCG_Pha_Ret_Asp_Amt ];

/// 台账损益
Property SUMCGBGAspAmt As %Library.Float [ SqlColumnNumber = 34, SqlFieldName = SUMCG_BG_Asp_Amt ];

Storage SQLStorage1
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSMSum("SUMCG",0))</SqlIdExpression>
<SQLMap name="DataMasterDHCSMSumIn">
<Data name="SUMCG_Adj_Amt">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SUMCG_Amt">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SUMCG_Asp_Amt">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SUMCG_BG_Asp_Amt">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="SUMCG_ChgCheck_Rec_Amt">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="SUMCG_ChgCheck_Ret_Amt">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="SUMCG_Consume_Amt">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SUMCG_Disposal_Amt">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SUMCG_Dsp_F_Amt">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="SUMCG_Dsp_P_Amt">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="SUMCG_Dsp_S_Amt">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="SUMCG_Gift_Rec_Amt">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SUMCG_Gift_Trf_Amt">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SUMCG_LastAmt">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SUMCG_M_Rec_Amt">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="SUMCG_Manu_M_Amt">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="SUMCG_Manu_X_Amt">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="SUMCG_PhaRet_H_Amt">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="SUMCG_PhaRet_Y_Amt">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="SUMCG_PhaRet_Z_Amt">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="SUMCG_Pha_Ret_Asp_Amt">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="SUMCG_Pho_Ret_Asp_Amt">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="SUMCG_Rec_Amt">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SUMCG_Rec_Asp_Amt">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="SUMCG_Ret_Amt">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SUMCG_Ret_Asp_Amt">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="SUMCG_SCG_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SUMCG_SM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SUMCG_StkCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SUMCG_StkTk_Amt">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="SUMCG_Trf_I_Amt">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SUMCG_Trf_I_Asp_Amt">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="SUMCG_Trf_O_Amt">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCSMSum</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SUMCG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"SUMCG"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{SUMCG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMon">
<Global>^DHCSMSum</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SUMCG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"SUMCG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Mon"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SUMCG_SM_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SUMCG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SUMCG_RowId</SqlRowIdName>
<StreamLocation>^User.DHCStkMonSumInCatGrpS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
