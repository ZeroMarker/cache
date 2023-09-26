Class User.DHCWLAnaesthesia Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHCWL_Anaesthesia, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCWLAnOperation As DHCWLAnOperation [ Cardinality = children, Inverse = WLOPParRef ];

/// WLAN_PAADM_DR
Property WLANPAADMDR As PAAdm [ SqlColumnNumber = 2, SqlFieldName = WLAN_PAADM_DR ];

/// WLAN_PAPMI_DR
Property WLANPAPMIDR As PAPatMas [ SqlColumnNumber = 3, SqlFieldName = WLAN_PAPMI_DR ];

/// WLAN_ADMReason_DR
Property WLANADMReasonDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = WLAN_ADMReason_DR ];

/// WLAN_Type
Property WLANType As %String(DISPLAYLIST = ",In Patient,Out Patient,Emergency,New Born,Health Promotion", MAXLEN = 16, VALUELIST = ",I,O,E,N,H") [ SqlColumnNumber = 5, SqlFieldName = WLAN_Type ];

/// WLAN_PatLoc_DR
Property WLANPatLocDR As CTLoc [ SqlColumnNumber = 6, SqlFieldName = WLAN_PatLoc_DR ];

/// WLAN_PatWard_DR
Property WLANPatWardDR As CTLoc [ SqlColumnNumber = 7, SqlFieldName = WLAN_PatWard_DR ];

/// WLAN_PatDoc_dr
Property WLANPatDocdr As CTCareProv [ SqlColumnNumber = 8, SqlFieldName = WLAN_PatDoc_dr ];

/// WLAN_Method
Property WLANMethod As %String [ SqlColumnNumber = 9, SqlFieldName = WLAN_Method ];

/// WLAN_Anaesthesia Doc
Property WLANAnaesthesiaDocDR As CTCareProv [ SqlColumnNumber = 10, SqlFieldName = WLAN_AnaesthesiaDoc_DR ];

/// WLAN_SDate
Property WLANSDate As %Date [ SqlColumnNumber = 11, SqlFieldName = WLAN_SDate ];

/// WLAN_STime
Property WLANSTime As %Time [ SqlColumnNumber = 12, SqlFieldName = WLAN_STime ];

/// WLAN_EDate
Property WLANEDate As %Date [ SqlColumnNumber = 13, SqlFieldName = WLAN_EDate ];

/// WLAN_ETime
Property WLANETime As %Time [ SqlColumnNumber = 14, SqlFieldName = WLAN_ETime ];

/// WLAN_Continuance
Property WLANContinuance As %Float [ SqlColumnNumber = 15, SqlFieldName = WLAN_Continuance ];

/// WLAN_WrDoc_Dr
Property WLANWrDocDr As CTCareProv [ SqlColumnNumber = 16, SqlFieldName = WLAN_WrDoc_Dr ];

/// WLAN_WrDocDep_Dr
Property WLANWrDocDepDr As CTLoc [ SqlColumnNumber = 17, SqlFieldName = WLAN_WrDocDep_Dr ];

/// WLAN_Cut_DR
Property WLANCutDR As PACDischClassification [ SqlColumnNumber = 18, SqlFieldName = WLAN_Cut_DR ];

/// WLAN_OperRoom_DR
Property WLANOperRoomDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = WLAN_OperRoom_DR ];

/// WLAN_Complication1
Property WLANComplication1 As ORAnaestComplications [ SqlColumnNumber = 20, SqlFieldName = WLAN_Complication1 ];

/// WLAN_Complication2
Property WLANComplication2 As ORAnaestComplications [ SqlColumnNumber = 21, SqlFieldName = WLAN_Complication2 ];

/// WLAN_MonitorDevice1
Property WLANMonitorDevice1 As ORCEquipment [ SqlColumnNumber = 22, SqlFieldName = WLAN_MonitorDevice1 ];

/// WLAN_MonitorDevice2
Property WLANMonitorDevice2 As ORCEquipment [ SqlColumnNumber = 23, SqlFieldName = WLAN_MonitorDevice2 ];

/// WLAN_MonitorDevice3
Property WLANMonitorDevice3 As ORCEquipment [ SqlColumnNumber = 24, SqlFieldName = WLAN_MonitorDevice3 ];

/// WLAN_MonitorDevice4
Property WLANMonitorDevice4 As ORCEquipment [ SqlColumnNumber = 25, SqlFieldName = WLAN_MonitorDevice4 ];

/// WLAN_MonitorDevice5
Property WLANMonitorDevice5 As ORCEquipment [ SqlColumnNumber = 26, SqlFieldName = WLAN_MonitorDevice5 ];

/// WLAN_RHBolldType
Property WLANRHBolldType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = WLAN_RHBolldType ];

/// WLAN_PatHeight
Property WLANPatHeight As %String [ SqlColumnNumber = 28, SqlFieldName = WLAN_PatHeight ];

/// WLAN_PatWeight
Property WLANPatWeight As %String [ SqlColumnNumber = 29, SqlFieldName = WLAN_PatWeight ];

/// WLAN_DeadDate
Property WLANDeadDate As %Date [ SqlColumnNumber = 30, SqlFieldName = WLAN_DeadDate ];

/// WLAN_ToLoc_DR
Property WLANToLocDR As CTLoc [ SqlColumnNumber = 31, SqlFieldName = WLAN_ToLoc_DR ];

/// WLAN_Evaluate_DR
Property WLANEvaluateDR As ORCASAClassPhActiv [ SqlColumnNumber = 32, SqlFieldName = WLAN_Evaluate_DR ];

/// WLAN_Units
Property WLANUnits As %Float [ SqlColumnNumber = 33, SqlFieldName = WLAN_Units ];

/// WLAN_ Price
Property WLANPrice As %Float [ SqlColumnNumber = 34, SqlFieldName = WLAN_Price ];

/// WLAN_BloodAnount
Property WLANBloodAnount As %Float [ SqlColumnNumber = 35, SqlFieldName = WLAN_BloodAnount ];

/// WLAN_Memo
Property WLANMemo As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = WLAN_Memo ];

/// WLAN_ Anaest _Type
Property WLANAnaestType As ORCAnaestType [ SqlColumnNumber = 37, SqlFieldName = WLAN_Anaest_Type ];

/// WLAN_ Anaest_Complications
Property WLANAnaestComplications As ORCAnaestComplications [ SqlColumnNumber = 38, SqlFieldName = WLAN_Anaest_Complications ];

/// WLAN_ASA_DR
Property WLANASADR As ORCASAClassPhActiv [ SqlColumnNumber = 39, SqlFieldName = WLAN_ASA_DR ];

/// WLAN_Date
Property WLANDate As %Date [ SqlColumnNumber = 40, SqlFieldName = WLAN_Date ];

/// WLAN_Time
Property WLANTime As %Date [ SqlColumnNumber = 41, SqlFieldName = WLAN_Time ];

/// WLAN_Counts
Property WLANCounts As %Float [ SqlColumnNumber = 42, SqlFieldName = WLAN_Counts ];

/// WLAN_OPER_DR
Property WLANOPERDR As ORCOperation [ SqlColumnNumber = 43, SqlFieldName = WLAN_OPER_DR ];

/// WLAN_ICD_DR
Property WLANICDDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = WLAN_ICD_DR ];

/// WLAN_PreopDiag_DR
Property WLANPreopDiagDR As MRCICDDx [ SqlColumnNumber = 45, SqlFieldName = WLAN_PreopDiag_DR ];

/// WLAN_PostDiag_DR
Property WLANPostDiagDR As MRCICDDx [ SqlColumnNumber = 46, SqlFieldName = WLAN_PostDiag_DR ];

/// WLAN_DiagFlag
Property WLANDiagFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 47, SqlFieldName = WLAN_DiagFlag ];

/// WLAN_BodySite_DR
Property WLANBodySiteDR As ORCOperPosition [ SqlColumnNumber = 48, SqlFieldName = WLAN_BodySite_DR ];

/// WLAN_OPDate
Property WLANOPDate As %Date [ SqlColumnNumber = 49, SqlFieldName = WLAN_OPDate ];

/// WLAN_OPTime
Property WLANOPTime As %Time [ SqlColumnNumber = 50, SqlFieldName = WLAN_OPTime ];

/// WLAN_OpDoc_DR
Property WLANOpDocDR As CTCareProv [ SqlColumnNumber = 51, SqlFieldName = WLAN_OpDoc_DR ];

/// WLAN_DocDep_DR
Property WLANDocDepDR As CTLoc [ SqlColumnNumber = 52, SqlFieldName = WLAN_DocDep_DR ];

/// WLAN_AssistDoc1_DR
Property WLANAssistDoc1DR As CTCareProv [ SqlColumnNumber = 53, SqlFieldName = WLAN_AssistDoc1_DR ];

/// WLAN_AssistDoc2_DR
Property WLANAssistDoc2DR As CTCareProv [ SqlColumnNumber = 54, SqlFieldName = WLAN_AssistDoc2_DR ];

/// WLAN_AssistDoc3_DR
Property WLANAssistDoc3DR As CTCareProv [ SqlColumnNumber = 55, SqlFieldName = WLAN_AssistDoc3_DR ];

/// WLAN_AnFADoc1_DR
Property WLANAnFADoc1DR As CTCareProv [ SqlColumnNumber = 56, SqlFieldName = WLAN_AnFADoc1_DR ];

/// WLAN_AnFADoc2_DR
Property WLANAnFADoc2DR As CTCareProv [ SqlColumnNumber = 57, SqlFieldName = WLAN_AnFADoc2_DR ];

/// WLAN_AnFADoc3_DR
Property WLANAnFADoc3DR As CTCareProv [ SqlColumnNumber = 58, SqlFieldName = WLAN_AnFADoc3_DR ];

/// WLAN_CirNurse1_DR
Property WLANCirNurse1DR As %String [ SqlColumnNumber = 59, SqlFieldName = WLAN_CirNurse1_DR ];

/// WLAN_CirNurse2_DR
Property WLANCirNurse2DR As %String [ SqlColumnNumber = 60, SqlFieldName = WLAN_CirNurse2_DR ];

/// WLAN_ScrNurse1_DR
Property WLANScrNurse1DR As %String [ SqlColumnNumber = 61, SqlFieldName = WLAN_ScrNurse1_DR ];

/// WLAN_ScrNurse2_DR
Property WLANScrNurse2DR As %String [ SqlColumnNumber = 62, SqlFieldName = WLAN_ScrNurse2_DR ];

/// WLAN_RecLoc_DR
Property WLANRecLocDR As CTLoc [ SqlColumnNumber = 63, SqlFieldName = WLAN_RecLoc_DR ];

/// WLAN_OPLevel_Code
Property WLANOPLevelCode As %Float [ SqlColumnNumber = 65, SqlFieldName = WLAN_OPLevel_Code ];

/// WLAN_OPType
Property WLANOPType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 66, SqlFieldName = WLAN_OPType ];

/// WLAN_Arrange_Dr
Property WLANArrangeDr As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 67, SqlFieldName = WLAN_Arrange_Dr ];

/// WLAN_SpecialFlag
Property WLANSpecialFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 68, SqlFieldName = WLAN_SpecialFlag ];

/// WLAN_HBsAg
Property WLANHBsAg As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 69, SqlFieldName = WLAN_HBsAg ];

/// WLAN_HBZGRflag
Property WLANHBZGRflag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 70, SqlFieldName = WLAN_HBZGRflag ];

/// WLAN_HolidayFlag
Property WLANHolidayFlag As %Float [ SqlColumnNumber = 71, SqlFieldName = WLAN_HolidayFlag ];

/// WLAN_UseSelfBloodFlag
Property WLANUseSelfBloodFlag As %Float [ SqlColumnNumber = 72, SqlFieldName = WLAN_UseSelfBloodFlag ];

/// WLAN_OPLevel1_Code
Property WLANOPLevel1Code As ORCOperationCategory [ SqlColumnNumber = 73, SqlFieldName = WLAN_OPLevel1_Code ];

/// WLAN_OPStartDate
Property WLANOPStartDate As %Date [ SqlColumnNumber = 74, SqlFieldName = WLAN_OPStartDate ];

/// WLAN_OPStartTime
Property WLANOPStartTime As %Time [ SqlColumnNumber = 75, SqlFieldName = WLAN_OPStartTime ];

/// WLAN_OPEndDate
Property WLANOPEndDate As %Date [ SqlColumnNumber = 76, SqlFieldName = WLAN_OPEndDate ];

/// WLAN_OPEndTime
Property WLANOPEndTime As %Time [ SqlColumnNumber = 77, SqlFieldName = WLAN_OPEndTime ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCWLAnaesthesia(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="WLAN_ADMReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WLAN_ASA_DR">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="WLAN_AnFADoc1_DR">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="WLAN_AnFADoc2_DR">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="WLAN_AnFADoc3_DR">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="WLAN_Anaest_Complications">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="WLAN_Anaest_Type">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="WLAN_AnaesthesiaDoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="WLAN_Arrange_Dr">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="WLAN_AssistDoc1_DR">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="WLAN_AssistDoc2_DR">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="WLAN_AssistDoc3_DR">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="WLAN_BloodAnount">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="WLAN_BodySite_DR">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="WLAN_CirNurse1_DR">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="WLAN_CirNurse2_DR">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="WLAN_Complication1">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="WLAN_Complication2">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="WLAN_Continuance">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="WLAN_Counts">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="WLAN_Cut_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="WLAN_Date">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="WLAN_DeadDate">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="WLAN_DiagFlag">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="WLAN_DocDep_DR">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="WLAN_EDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="WLAN_ETime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="WLAN_Evaluate_DR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="WLAN_HBZGRflag">
<Delimiter>"^"</Delimiter>
<Piece>69</Piece>
</Data>
<Data name="WLAN_HBsAg">
<Delimiter>"^"</Delimiter>
<Piece>68</Piece>
</Data>
<Data name="WLAN_HolidayFlag">
<Delimiter>"^"</Delimiter>
<Piece>70</Piece>
</Data>
<Data name="WLAN_ICD_DR">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="WLAN_Memo">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="WLAN_Method">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="WLAN_MonitorDevice1">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="WLAN_MonitorDevice2">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="WLAN_MonitorDevice3">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="WLAN_MonitorDevice4">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="WLAN_MonitorDevice5">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="WLAN_OPDate">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="WLAN_OPER_DR">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="WLAN_OPEndDate">
<Delimiter>"^"</Delimiter>
<Piece>75</Piece>
</Data>
<Data name="WLAN_OPEndTime">
<Delimiter>"^"</Delimiter>
<Piece>76</Piece>
</Data>
<Data name="WLAN_OPLevel1_Code">
<Delimiter>"^"</Delimiter>
<Piece>72</Piece>
</Data>
<Data name="WLAN_OPLevel_Code">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="WLAN_OPStartDate">
<Delimiter>"^"</Delimiter>
<Piece>73</Piece>
</Data>
<Data name="WLAN_OPStartTime">
<Delimiter>"^"</Delimiter>
<Piece>74</Piece>
</Data>
<Data name="WLAN_OPTime">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="WLAN_OPType">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="WLAN_OpDoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="WLAN_OperRoom_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="WLAN_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WLAN_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WLAN_PatDoc_dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="WLAN_PatHeight">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="WLAN_PatLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="WLAN_PatWard_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="WLAN_PatWeight">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="WLAN_PostDiag_DR">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="WLAN_PreopDiag_DR">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="WLAN_Price">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="WLAN_RHBolldType">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="WLAN_RecLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="WLAN_SDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="WLAN_STime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="WLAN_ScrNurse1_DR">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="WLAN_ScrNurse2_DR">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="WLAN_SpecialFlag">
<Delimiter>"^"</Delimiter>
<Piece>67</Piece>
</Data>
<Data name="WLAN_Time">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="WLAN_ToLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="WLAN_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WLAN_Units">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="WLAN_UseSelfBloodFlag">
<Delimiter>"^"</Delimiter>
<Piece>71</Piece>
</Data>
<Data name="WLAN_WrDocDep_Dr">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="WLAN_WrDoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Global>^DHCWLAnaesthesia</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>WLAN_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{WLAN_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexArrange">
<Global>^DHCWLAnaesthesia</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WLAN_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Arrange"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WLAN_Arrange_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WLAN_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCWLAnaesthesia</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WLAN_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WLAN_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WLAN_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEdate">
<Global>^DHCWLAnaesthesia</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WLAN_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EndDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WLAN_EDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WLAN_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOPType">
<Global>^DHCWLAnaesthesia</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WLAN_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OPType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WLAN_OPType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WLAN_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPaadm">
<Global>^DHCWLAnaesthesia</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WLAN_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"paadm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WLAN_PAADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WLAN_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPapmi">
<Global>^DHCWLAnaesthesia</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WLAN_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WLAN_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WLAN_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatLoc">
<Global>^DHCWLAnaesthesia</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WLAN_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PatLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WLAN_PatLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WLAN_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatWard">
<Global>^DHCWLAnaesthesia</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WLAN_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PatWard"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WLAN_PatWard_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WLAN_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatDate">
<Global>^DHCWLAnaesthesia</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WLAN_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"STATDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WLAN_SDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WLAN_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCWLAnaesthesia</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WLAN_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TYPE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WLAN_Anaest_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WLAN_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>WLAN_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCWLAnaesthesiaS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
