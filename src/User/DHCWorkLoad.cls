/// WorkLoad Statistic
Class User.DHCWorkLoad Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = WorkLoad_Rowid, SqlTableName = DHC_WorkLoad, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// WorkLoad_RecDep_DR
Property WorkLoadRecDepDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = WorkLoad_RecDep_DR ];

/// WorkLoad_ItemOrd_DR
Property WorkLoadItemOrdDR As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = WorkLoad_ItemOrd_DR ];

/// Pat Dep
Property WorkLoadResDepDR As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = WorkLoad_ResDep_DR ];

/// WorkLoad_Type
Property WorkLoadType As %Library.String(DISPLAYLIST = ",In Patient,Out Patient,Emergency,New Born,Health Promotion", MAXLEN = 16, SELECTIVITY = "16.6667%", VALUELIST = ",I,O,E,N,H") [ SqlColumnNumber = 5, SqlFieldName = WorkLoad_Type ];

/// WorkLoad_OrdDate
Property WorkLoadOrdDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 6, SqlFieldName = WorkLoad_OrdDate ];

/// WorkLoad_Time
Property WorkLoadOrdTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = WorkLoad_OrdTime ];

/// WorkLoad_StatDate
Property WorkLoadStatDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 8, SqlFieldName = WorkLoad_StatDate ];

/// WorkLoad_StatTime
Property WorkLoadStatTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = WorkLoad_StatTime ];

/// WorkLoad_ItemCat_DR
Property WorkLoadItemCatDR As User.ARCItemCat [ SqlColumnNumber = 10, SqlFieldName = WorkLoad_ItemCat_DR ];

/// WorkLoad_BillGrp_DR
Property WorkLoadBillGrpDR As User.ARCBillGrp [ SqlColumnNumber = 11, SqlFieldName = WorkLoad_BillGrp_DR ];

/// WorkLoad_BillSub_DR
Property WorkLoadBillSubDR As User.ARCBillSub [ SqlColumnNumber = 12, SqlFieldName = WorkLoad_BillSub_DR ];

/// WorkLoad_PAADM_DR
Property WorkLoadPAADMDR As User.PAAdm [ SqlColumnNumber = 13, SqlFieldName = WorkLoad_PAADM_DR ];

/// WorkLoad_PAPMI_DR
Property WorkLoadPAPMIDR As User.PAPatMas [ SqlColumnNumber = 14, SqlFieldName = WorkLoad_PAPMI_DR ];

/// WorkLoad_UnitPrice
Property WorkLoadUnitPrice As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = WorkLoad_UnitPrice ];

/// WorkLoad_Quantity
Property WorkLoadQuantity As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = WorkLoad_Quantity ];

/// WorkLoad_TotalPrice
Property WorkLoadTotalPrice As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = WorkLoad_TotalPrice ];

/// WorkLoad_OrdStatus
Property WorkLoadOrdStatus As %Library.String(DISPLAYLIST = ",Paid,Billed,Cancel", MAXLEN = 6, SELECTIVITY = "25.0000%", VALUELIST = ",P,B,C") [ SqlColumnNumber = 18, SqlFieldName = WorkLoad_OrdStatus ];

/// WorkLoad_RecDoc_DR
Property WorkLoadRecDocDR As User.CTCareProv [ SqlColumnNumber = 19, SqlFieldName = WorkLoad_RecDoc_DR ];

/// WorkLoad_ResDoc_DR
Property WorkLoadResDocDR As User.CTCareProv [ SqlColumnNumber = 20, SqlFieldName = WorkLoad_ResDoc_DR ];

/// WorkLoad_ARPBL_DR
Property WorkLoadARPBLDR As User.ARPatientBill [ SqlColumnNumber = 21, SqlFieldName = WorkLoad_ARPBL_DR ];

/// WorkLoad_OEORI_DR
Property WorkLoadOEORIDR As User.OEOrdItem [ SqlColumnNumber = 22, SqlFieldName = WorkLoad_OEORI_DR ];

/// WorkLoad_TarItem_DR
Property WorkLoadTarItemDR As User.DHCTarItem [ SqlColumnNumber = 23, SqlFieldName = WorkLoad_TarItem_DR ];

/// Ord Dep
Property WorkLoadPatDepDR As User.CTLoc [ SqlColumnNumber = 24, SqlFieldName = WorkLoad_PatDep_DR ];

/// WorkLoad_PatWard_DR
Property WorkLoadPatWardDR As User.CTLoc [ SqlColumnNumber = 25, SqlFieldName = WorkLoad_PatWard_DR ];

/// WorkLoad_PatDoc_DR
Property WorkLoadPatDocDR As User.CTCareProv [ SqlColumnNumber = 26, SqlFieldName = WorkLoad_PatDoc_DR ];

/// WorkLoad_Flag
Property WorkLoadFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = WorkLoad_Flag ];

/// WorkLoad_FlagDate
Property WorkLoadFlagDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 28, SqlFieldName = WorkLoad_FlagDate ];

/// WorkLoad_Receipt_DR
Property WorkLoadReceiptIDR As %Library.String(COLLATION = "Exact", MAXLEN = 19, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = WorkLoad_ReceiptI_DR ];

/// WorkLoad_Casher_DR
Property WorkLoadCasherODR As User.SSUser [ SqlColumnNumber = 30, SqlFieldName = WorkLoad_CasherO_DR ];

/// WorkLoad_UserDep_DR
Property WorkLoadUserDepDR As User.CTLoc [ SqlColumnNumber = 31, SqlFieldName = WorkLoad_UserDep_DR ];

/// WorkLoad_User_DR
Property WorkLoadUserDR As User.SSUser [ SqlColumnNumber = 32, SqlFieldName = WorkLoad_User_DR ];

/// WorkLoad_HoldFlag
Property WorkLoadHoldFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = WorkLoad_HoldFlag ];

/// WorkLoad_HoldFlagDate
Property WorkLoadHoldFlagDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 34, SqlFieldName = WorkLoad_HoldFlagDate ];

/// WorkLoad_HoldDep_DR
Property WorkLoadHoldDepDR As User.CTLoc [ SqlColumnNumber = 35, SqlFieldName = WorkLoad_HoldDep_DR ];

/// WorkLoad_HoldDoc_DR
Property WorkLoadHoldDocDR As User.CTCareProv [ SqlColumnNumber = 36, SqlFieldName = WorkLoad_HoldDoc_DR ];

/// WorkLoad_ReceiptO_DR
Property WorkLoadReceiptODR As %Library.String(COLLATION = "Exact", MAXLEN = 19, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = WorkLoad_ReceiptO_DR ];

/// WorkLoad_CasherI_DR
Property WorkLoadCasherIDR As User.SSUser [ SqlColumnNumber = 38, SqlFieldName = WorkLoad_CasherI_DR ];

/// WorkLoad_DisDate
Property WorkLoadDisDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 39, SqlFieldName = WorkLoad_DisDate ];

/// WorkLoad_DisFlag
Property WorkLoadDisFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = WorkLoad_DisFlag ];

/// WorkLoad_TarAC_dr
Property WorkLoadTarACdr As User.DHCTarAcctCate [ SqlColumnNumber = 41, SqlFieldName = WorkLoad_TarAC_dr ];

/// WorkLoad_TarSC_Dr
Property WorkLoadTarSCDr As User.DHCTarSubCate [ SqlColumnNumber = 42, SqlFieldName = WorkLoad_TarSC_Dr ];

/// WorkLoad_TarOut_Dr
Property WorkLoadTarOutDr As User.DHCTarOutpatCate [ SqlColumnNumber = 43, SqlFieldName = WorkLoad_TarOut_Dr ];

/// WorkLoad_TarEC_Dr
Property WorkLoadTarECDr As User.DHCTarEMCCate [ SqlColumnNumber = 44, SqlFieldName = WorkLoad_TarEC_Dr ];

/// WorkLoad_TarMC_Dr
Property WorkLoadTarMCDr As User.DHCTarMRCate [ SqlColumnNumber = 45, SqlFieldName = WorkLoad_TarMC_Dr ];

/// WorkLoad_TarIC_Dr
Property WorkLoadTarICDr As User.DHCTarInpatCate [ SqlColumnNumber = 46, SqlFieldName = WorkLoad_TarIC_Dr ];

/// WorkLoad_FlagTime
Property WorkLoadFlagTime As %Library.Time [ SqlColumnNumber = 47, SqlFieldName = WorkLoad_FlagTime ];

/// WorkLoad_DataType
Property WorkLoadDataType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 48, SqlFieldName = WorkLoad_DataType ];

/// WorkLoad_PBDDR
Property WorkLoadPBDDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 49, SqlFieldName = WorkLoad_PBDDR ];

/// WorkLoad_ResMedUnitCareProv_dr
Property WorkLoadResMedUnitCareProvdr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 50, SqlFieldName = WorkLoad_ResMedUnitCareProv_dr ];

/// WorkLoad_RecMedUnitCareProv_dr
Property WorkLoadRecMedUnitCareProvdr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 51, SqlFieldName = WorkLoad_RecMedUnitCareProv_dr ];

/// WorkLoad_PatMedUnitCareProv_dr
Property WorkLoadPatMedUnitCareProvdr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 52, SqlFieldName = WorkLoad_PatMedUnitCareProv_dr ];

/// WorkLoad_AdmReason_DR
Property WorkLoadAdmReasonDR As %Library.Float [ SqlColumnNumber = 53, SqlFieldName = WorkLoad_AdmReason_DR ];

/// WorkLoad_TarMCNew_Dr
Property WorkLoadTarMCNewDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 54, SqlFieldName = WorkLoad_TarMCNew_Dr ];

/// WorkLoad_OEORE_Dr
Property WorkLoadOEOREDr As User.OEOrdExec [ SqlColumnNumber = 55, SqlFieldName = WorkLoad_OEORE_Dr ];

/// WorkLoad_SocialStatus_DR
Property WorkLoadSocialStatusDR As User.CTSocialStatus [ SqlColumnNumber = 56, SqlFieldName = WorkLoad_SocialStatus_DR ];

/// WorkLoad_PHCC_DR
Property WorkLoadPHCCDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 57, SqlFieldName = WorkLoad_PHCC_DR ];

/// WorkLoad_PHCD_DR
Property WorkLoadPHCDDR As User.PHCDrgForm [ SqlColumnNumber = 58, SqlFieldName = WorkLoad_PHCD_DR ];

/// WorkLoad_PHCDF_DR
Property WorkLoadPHCDFDR As User.PHCForm [ SqlColumnNumber = 59, SqlFieldName = WorkLoad_PHCDF_DR ];

/// WorkLoad_PHCIN_DR
Property WorkLoadPHCINDR As User.PHCInstruc [ SqlColumnNumber = 60, SqlFieldName = WorkLoad_PHCIN_DR ];

/// WorkLoad_PayorPrice
Property WorkLoadPayorPrice As %Library.Float [ SqlColumnNumber = 61, SqlFieldName = WorkLoad_PayorPrice ];

/// WorkLoad_DiscPrice
Property WorkLoadDiscPrice As %Library.Float [ SqlColumnNumber = 62, SqlFieldName = WorkLoad_DiscPrice ];

/// WorkLoad_PaSharePrice
Property WorkLoadPaSharePrice As %Library.Float [ SqlColumnNumber = 63, SqlFieldName = WorkLoad_PaSharePrice ];

/// WorkLoad_PatRoom_DR
Property WorkLoadPatRoomDR As User.PACRoom [ SqlColumnNumber = 64, SqlFieldName = WorkLoad_PatRoom_DR ];

/// WorkLoad_PatBed_DR
Property WorkLoadPatBedDR As User.PACBed [ SqlColumnNumber = 65, SqlFieldName = WorkLoad_PatBed_DR ];

/// WorkLoad_PatDepExt_DR
Property WorkLoadPatDepExtDR As User.CTLoc [ SqlColumnNumber = 66, SqlFieldName = WorkLoad_PatDepExt_DR ];

/// WorkLoad_ResDocExt_DR
Property WorkLoadResDocExtDR As User.CTCareProv [ SqlColumnNumber = 67, SqlFieldName = WorkLoad_ResDocExt_DR ];

/// WorkLoad_OeoriUnitPrice
Property WorkLoadOeoriUnitPrice As %Library.Float [ SqlColumnNumber = 68, SqlFieldName = WorkLoad_OeoriUnitPrice ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCWorkLoad(0))</SqlIdExpression>
<SQLMap name="DataMasterDHCWorkLoad">
<Data name="WorkLoad_ARPBL_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="WorkLoad_AdmReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="WorkLoad_BillGrp_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="WorkLoad_BillSub_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="WorkLoad_CasherI_DR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="WorkLoad_CasherO_DR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="WorkLoad_DataType">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="WorkLoad_DisDate">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="WorkLoad_DisFlag">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="WorkLoad_DiscPrice">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="WorkLoad_Flag">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="WorkLoad_FlagDate">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="WorkLoad_FlagTime">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="WorkLoad_HoldDep_DR">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="WorkLoad_HoldDoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="WorkLoad_HoldFlag">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="WorkLoad_HoldFlagDate">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="WorkLoad_ItemCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="WorkLoad_ItemOrd_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WorkLoad_OEORE_Dr">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="WorkLoad_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="WorkLoad_OeoriUnitPrice">
<Delimiter>"^"</Delimiter>
<Piece>67</Piece>
</Data>
<Data name="WorkLoad_OrdDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="WorkLoad_OrdStatus">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="WorkLoad_OrdTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="WorkLoad_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="WorkLoad_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="WorkLoad_PBDDR">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="WorkLoad_PHCC_DR">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="WorkLoad_PHCDF_DR">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="WorkLoad_PHCD_DR">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="WorkLoad_PHCIN_DR">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="WorkLoad_PaSharePrice">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="WorkLoad_PatBed_DR">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="WorkLoad_PatDepExt_DR">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="WorkLoad_PatDep_DR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="WorkLoad_PatDoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="WorkLoad_PatMedUnitCareProv_dr">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="WorkLoad_PatRoom_DR">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="WorkLoad_PatWard_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="WorkLoad_PayorPrice">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="WorkLoad_Quantity">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="WorkLoad_RecDep_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WorkLoad_RecDoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="WorkLoad_RecMedUnitCareProv_dr">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="WorkLoad_ReceiptI_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="WorkLoad_ReceiptO_DR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="WorkLoad_ResDep_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WorkLoad_ResDocExt_DR">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="WorkLoad_ResDoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="WorkLoad_ResMedUnitCareProv_dr">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="WorkLoad_SocialStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="WorkLoad_StatDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="WorkLoad_StatTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="WorkLoad_TarAC_dr">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="WorkLoad_TarEC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="WorkLoad_TarIC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="WorkLoad_TarItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="WorkLoad_TarMCNew_Dr">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="WorkLoad_TarMC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="WorkLoad_TarOut_Dr">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="WorkLoad_TarSC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="WorkLoad_TotalPrice">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="WorkLoad_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WorkLoad_UnitPrice">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="WorkLoad_UserDep_DR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="WorkLoad_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Global>^DHCWorkLoad</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{WorkLoad_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARPBL">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ARPBL"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_ARPBL_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBillGrp">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BILLGRP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_BillGrp_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBillSub">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BILLSUB"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_BillSub_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCasherI">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CasherI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_CasherI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCasherO">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CasherO"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_CasherO_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateARPBL">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateARPBL"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_OrdDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_ARPBL_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateBillSub">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateBillSub"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_OrdDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_BillSub_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateItemOrd">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateItemOrd"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_OrdDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_ItemOrd_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateOEORI">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateOEORI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_OrdDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_OEORI_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDisDate">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DISDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_DisDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDisDatePatDep">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DISDATEPatDep"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_DisDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_PatDep_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDisDatePatDoc">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DISDATEPatDoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_DisDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_PatDoc_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDisDatePatMedUnit">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DisDatePatMedUnit"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_DisDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_PatMedUnitCareProv_dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDisDatePatWard">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DISDATEPatWard"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_DisDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_PatWard_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDisDateRecDep">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DisDateRecDep"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_DisDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_RecDep_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDisDateRecDoc">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DisDateRecDoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_DisDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_RecDoc_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDisDateRecMedUnit">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DisDateRecMedUnit"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_DisDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_RecMedUnitCareProv_dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDisDateResDep">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DISDATEResDep"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_DisDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_ResDep_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDisDateResDoc">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DisDateResDoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_DisDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_ResDoc_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDisDateResMedUnit">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DisDateResMedUnit"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_DisDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_ResMedUnitCareProv_dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFlagDPatDepItemCat">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FlagDPatDepItemCat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_FlagDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_PatDep_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_ItemCat_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFlagDPatDocItemCat">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FlagDPatDocItemCat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_FlagDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_PatDoc_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_ItemCat_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFlagDRecDepItemCat">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FlagDRecDepItemCat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_FlagDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_RecDep_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_ItemCat_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFlagDRecDocItemCat">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FlagDRecDocItemCat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_FlagDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_RecDoc_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_ItemCat_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFlagDResDepItemCat">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FlagDaDResDepItemCat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_FlagDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_ResDep_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_ItemCat_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFlagDResDocItemCat">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FlagDResDocItemCat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_FlagDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_ResDoc_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_ItemCat_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFlagDWardItemCat">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FlagDWardItemCat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_FlagDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_PatWard_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_ItemCat_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFlagDate">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FlagDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_FlagDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFlagDatePHCC">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FlagDatePHCC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_FlagDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_PHCC_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFlagDatePHCD">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FlagDatePHCD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_FlagDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_PHCD_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFlagDatePHCDF">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FlagDatePHCDF"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_FlagDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_PHCDF_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFlagDatePHCIN">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FlagDatePHCIN"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_FlagDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_PHCIN_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFlagDatePatDep">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FlagDatePatDep"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_FlagDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_PatDep_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFlagDatePatDoc">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FlagDatePatDoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_FlagDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_PatDoc_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFlagDatePatMedUnit">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FlagDatePatMedUnit"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_FlagDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_PatMedUnitCareProv_dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFlagDatePatWard">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FlagDatePatWard"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_FlagDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_PatWard_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFlagDateRecDep">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FlagDateRecDep"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_FlagDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_RecDep_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFlagDateRecDoc">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FlagDateRecDoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_FlagDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_RecDoc_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFlagDateRecMedUnit">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FlagDateRecMedUnit"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_FlagDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_RecMedUnitCareProv_dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFlagDateResDep">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FlagDateResDep"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_FlagDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_ResDep_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFlagDateResDoc">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FlagDateResDoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_FlagDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_ResDoc_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFlagDateResMedUnit">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FlagDateResMedUnit"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_FlagDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_ResMedUnitCareProv_dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFlagDateSocial">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FlagDateSocial"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_FlagDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_SocialStatus_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexItemCat">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ITEMCAT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_ItemCat_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexItemOrd">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ITEMORD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_ItemOrd_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOEORE">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OEORE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_OEORE_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOEORI">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OEORI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_OEORI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdDate">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ORDDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_OrdDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdDatePHCC">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdDatePHCC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_OrdDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_PHCC_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdDatePHCD">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdDatePHCD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_OrdDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_PHCD_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdDatePHCDF">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdDatePHCDF"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_OrdDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_PHCDF_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdDatePHCIN">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdDatePHCIN"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_OrdDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_PHCIN_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdDatePatDep">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ORDDATEPatDep"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_OrdDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_PatDep_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdDatePatDepItemCat">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdDatePatDepItemCat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_OrdDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_PatDep_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_ItemCat_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdDatePatDoc">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ORDDATEPatDoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_OrdDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_PatDoc_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdDatePatDocItemcat">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdDatePatDocItemcat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_OrdDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_PatDoc_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_ItemCat_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdDatePatMedUnit">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdDatePatMedUnit"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_OrdDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_PatMedUnitCareProv_dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdDatePatWard">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ORDDATEPatWard"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_OrdDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_PatWard_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdDateRecDep">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ORDDATERECDEP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_OrdDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_RecDep_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdDateRecDepItemCat">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdDateRecDepItemCat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_OrdDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_RecDep_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_ItemCat_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdDateRecDoc">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ORDDATERECDOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_OrdDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_RecDoc_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdDateRecDocItemCat">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdDateRecDocItemCat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_OrdDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_RecDoc_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_ItemCat_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdDateRecMedUnit">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdDateRecMedUnit"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_OrdDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_RecMedUnitCareProv_dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdDateResDep">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ORDDATERESDEP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_OrdDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_ResDep_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdDateResDepItemCat">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdDateResDepItemCat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_OrdDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_ResDep_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_ItemCat_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdDateResDoc">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ORDDATERESDOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_OrdDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_ResDoc_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdDateResDocItemCat">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdDateResDocItemCat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_OrdDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_ResDoc_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_ItemCat_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdDateResMedUnit">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdDateResMedUnit"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_OrdDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_ResMedUnitCareProv_dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdDateSocial">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdDateSocialStatus"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_OrdDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_SocialStatus_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdDateWardItemCat">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdDateWardItemCat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_OrdDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_PatWard_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WorkLoad_ItemCat_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdStatus">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ORDSTATUS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_OrdStatus}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdTime">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ORDTIME"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_OrdTime}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAADM">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_PAADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAPMI">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPBDDR">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PBDDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_PBDDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPHCC">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PHCC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_PHCC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPHCD">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PHCD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_PHCD_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPHCDF">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PHCDF"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_PHCDF_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPHCIN">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PHCIN"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_PHCIN_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatDep">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PatDep"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_PatDep_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatDoc">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PatDoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_PatDoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatMedUnit">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PatMedUnit"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_PatMedUnitCareProv_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatWard">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PatWard"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_PatWard_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRecDep">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RECDEP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_RecDep_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRecDoc">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RECDOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_RecDoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRecMedUnit">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RecMedUnit"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_RecMedUnitCareProv_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexReceiptI">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ReceiptI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_ReceiptI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexReceiptO">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ReceiptO"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_ReceiptO_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexResDep">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RESDEP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_ResDep_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexResDoc">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RESDOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_ResDoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexResMedUnit">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ResMedUnit"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_ResMedUnitCareProv_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSocialStatus">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SocialStatus"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_SocialStatus_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatDate">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"STATDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_StatDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatTime">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"STATTIME"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_StatTime}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTarAC">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TarAC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_TarAC_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTarEC">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TarEC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_TarEC_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTarIC">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TarIC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_TarIC_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTarItem">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TARITEM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_TarItem_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTarMC">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TarMC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_TarMC_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTarMCNew">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TarMCNew"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_TarMCNew_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTarOC">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TarOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_TarOut_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTarSC">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TarSC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_TarSC_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TYPE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_User_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserDep">
<Global>^DHCWorkLoad</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WorkLoad_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UserDep"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WorkLoad_UserDep_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WorkLoad_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCWorkLoadS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
