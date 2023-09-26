Class User.PMPImprovementList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IPML_Rowid, SqlTableName = PMP_ImprovementList, StorageStrategy = SQLStorage ]
{

Relationship ChildPMPImprovementList As PMPImprovementDetail [ Cardinality = children, Inverse = PMPImprovementListParRef ];

Relationship ChildPMPImprovementRevList As PMPImprovmentRevList [ Cardinality = children, Inverse = PMPImprovementRevListParRef ];

Relationship ChildPMPAppraisal As PMPImprovementAppraisal [ Cardinality = children, Inverse = PMPAppraisalParRef ];

/// IPMLCode
Property IPMLCode As %String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = IPML_Code ];

/// IPMLName
Property IPMLName As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = IPML_Name ];

/// IPMLEmergencyDR
Property IPMLEmergencyDR As PMPDictionary3 [ SqlColumnNumber = 4, SqlFieldName = IPML_Emergency_DR ];

/// IPMLModuleDR
Property IPMLModuleDR As PMPModule [ SqlColumnNumber = 5, SqlFieldName = IPML_Module_DR ];

/// IPMLEngineerDR
Property IPMLEngineerDR As PMPProjectUser [ SqlColumnNumber = 6, SqlFieldName = IPML_Engineer_DR ];

/// IPMLDevelopUser
Property IPMLDevelopUser As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = IPML_DevelopUser ];

/// IPMLSituation
Property IPMLSituation As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = IPML_Situation ];

/// IPMLStatusDR
Property IPMLStatusDR As PMPDictionary3 [ SqlColumnNumber = 9, SqlFieldName = IPML_Status_DR ];

/// IPMLAuditor1
Property IPMLAuditor1 As %String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = IPML_Auditor1 ];

/// IPMLAuditor2
Property IPMLAuditor2 As %String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = IPML_Auditor2 ];

/// IPMLAuditor3
Property IPMLAuditor3 As %String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = IPML_Auditor3 ];

/// IPMLAuditor4
Property IPMLAuditor4 As %String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = IPML_Auditor4 ];

/// IPMLAuditor5
Property IPMLAuditor5 As %String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = IPML_Auditor5 ];

/// IPMLAuditor
Property IPMLAuditor As PMPProjectUser [ SqlColumnNumber = 15, SqlFieldName = IPML_Auditor ];

/// IPMLCreateTime
Property IPMLCreateTime As %Time [ SqlColumnNumber = 16, SqlFieldName = IPML_CreateTime ];

/// IPMLCreateDate
Property IPMLCreateDate As %Date [ SqlColumnNumber = 17, SqlFieldName = IPML_CreateDate ];

/// IPMLCreateUserDR
Property IPMLCreateUserDR As %String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = IPML_CreateUser_DR ];

/// IPMLCreateLocDR
Property IPMLCreateLocDR As CTLoc [ SqlColumnNumber = 19, SqlFieldName = IPML_CreateLoc_DR ];

/// IPMLAssignEngineer_R
Property IPMLAssignEngineerDR As PMPProjectUser [ SqlColumnNumber = 20, SqlFieldName = IPML_AssignEngineer_DR ];

/// IPMLTestDate
Property IPMLTestDate As %Date [ SqlColumnNumber = 21, SqlFieldName = IPML_TestDate ];

/// IPMLTestTime
Property IPMLTestTime As %Time [ SqlColumnNumber = 22, SqlFieldName = IPML_TestTime ];

/// IPMLFinishDate
Property IPMLFinishDate As %Date [ SqlColumnNumber = 23, SqlFieldName = IPML_FinishDate ];

/// IPMLFinishTime
Property IPMLFinishTime As %Time [ SqlColumnNumber = 24, SqlFieldName = IPML_FinishTime ];

/// IPMLMenu
Property IPMLMenu As %String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = IPML_Menu ];

/// IPMLCreateTel
Property IPMLCreateTel As %String(COLLATION = "Exact", MAXLEN = 11, TRUNCATE = 1) [ SqlColumnNumber = 26, SqlFieldName = IPML_CreateTel ];

/// IPMLAdjunctFlag
Property IPMLAdjunctFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = IPML_AdjunctFlag ];

/// IPMLSolution
Property IPMLSolution As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = IPML_Solution ];

/// IPMLType
Property IPMLType As PMPDictionary3 [ SqlColumnNumber = 29, SqlFieldName = IPML_Type ];

/// IPMLPredictTime
Property IPMLPredictTime As %String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = IPML_PredictTime ];

/// IPMLProjectDR
Property IPMLProjectDR As PMPProject [ SqlColumnNumber = 31, SqlFieldName = IPML_Project_DR ];

/// IPMLDegreeDR
Property IPMLDegreeDR As PMPDictionary3 [ SqlColumnNumber = 32, SqlFieldName = IPML_Degree_DR ];

/// IPMLStandby1
Property IPMLStandby1 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 33, SqlFieldName = IPML_Standby1 ];

/// IPMLStandby2
Property IPMLStandby2 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 34, SqlFieldName = IPML_Standby2 ];

/// IPMLStandby3
Property IPMLStandby3 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 35, SqlFieldName = IPML_Standby3 ];

/// IPMLStandby4
Property IPMLStandby4 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 36, SqlFieldName = IPML_Standby4 ];

/// IPMLStandby5
Property IPMLStandby5 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 37, SqlFieldName = IPML_Standby5 ];

/// IPMLMode
Property IPMLMode As %String(DISPLAYLIST = ",CS,BS,Other", MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",CS,BS,Other") [ SqlColumnNumber = 38, SqlFieldName = IPML_Mode ];

/// IPMLList
Property IPMLList As PMPImprovementList [ SqlColumnNumber = 39, SqlFieldName = IPML_List ];

/// IPMLRevList
Property IPMLRevList As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 40, SqlFieldName = IPML_RevList ];

/// IPMLRevListIMP
Property IPMLRevListIMP As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 41, SqlFieldName = IPML_RevListIMP ];

/// IPMLUpdateType
Property IPMLUpdateType As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 42, SqlFieldName = IPML_UpdateType ];

/// IPMLHosInDem  区分院内外需求的标志
Property IPMLHosInDem As %String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 43, SqlFieldName = IPML_HosInDem ];

/// IPMLInNote
Property IPMLInNote As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 44, SqlFieldName = IPML_InNote ];

/// IPMLHosInHandler  指定院内需求处理人
Property IPMLHosInHandler As %String(COLLATION = "Exact", MAXLEN = 25, TRUNCATE = 1) [ SqlColumnNumber = 45, SqlFieldName = IPML_HosInHandler ];

/// IPMLEidtedSituation   项目修改后的需求
Property IPMLEidtedSituation As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 1) [ SqlColumnNumber = 46, SqlFieldName = IPML_EidtedSituation ];

/// IPMLEidtUser   项目修改后的需求修改人
Property IPMLEidtUser As %String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 47, SqlFieldName = IPML_EidtUser ];

/// IPMLStandtb1
Property IPMLStandtb1 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 48, SqlFieldName = IPML_Standtb1 ];

/// IPMLStandtb2
Property IPMLStandtb2 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 49, SqlFieldName = IPML_Standtb2 ];

/// IPMLStandtb3
Property IPMLStandtb3 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 50, SqlFieldName = IPML_Standtb3 ];

/// IPMLStandtb4
Property IPMLStandtb4 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 51, SqlFieldName = IPML_Standtb4 ];

/// IPMLStandtb5
Property IPMLStandtb5 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 52, SqlFieldName = IPML_Standtb5 ];

/// IPMLStandtb6
Property IPMLStandtb6 As %String(COLLATION = "Exact", MAXLEN = 2048, TRUNCATE = 1) [ SqlColumnNumber = 53, SqlFieldName = IPML_Standtb6 ];

/// IPMLStandtb7
Property IPMLStandtb7 As PMPDevelop [ SqlColumnNumber = 54, SqlFieldName = IPML_Standtb7 ];

/// IPMLPresident
Property IPMLPresident As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 55, SqlFieldName = IPML_President ];

/// IPMLDhccFlag
Property IPMLDhccFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 56, SqlFieldName = IPML_DhccFlag ];

/// IPMLDhccDate
Property IPMLDhccDate As %Date [ SqlColumnNumber = 57, SqlFieldName = IPML_DhccDate ];

/// IPMLDhccTime
Property IPMLDhccTime As %Time [ SqlColumnNumber = 58, SqlFieldName = IPML_DhccTime ];

/// IPMLDhccUser
Property IPMLDhccUser As PMPProjectUser [ SqlColumnNumber = 59, SqlFieldName = IPML_DhccUser ];

/// IPMLDhccType
Property IPMLDhccType As PMPDictionary3 [ SqlColumnNumber = 60, SqlFieldName = IPML_DhccType ];

/// IPMLStandby6
Property IPMLStandby6 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 61, SqlFieldName = IPML_Standby6 ];

/// IPMLStandby7
Property IPMLStandby7 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 62, SqlFieldName = IPML_Standby7 ];

/// IPMLStandby8
Property IPMLStandby8 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 63, SqlFieldName = IPML_Standby8 ];

/// IPMLStandby9
Property IPMLStandby9 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 64, SqlFieldName = IPML_Standby9 ];

/// IPMLStandby10
Property IPMLStandby10 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 65, SqlFieldName = IPML_Standby10 ];

/// IPMLStandby11
Property IPMLStandby11 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 66, SqlFieldName = IPML_Standby11 ];

/// IPMLStandby12
Property IPMLStandby12 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 67, SqlFieldName = IPML_Standby12 ];

/// IPMLStandby13
Property IPMLStandby13 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 68, SqlFieldName = IPML_Standby13 ];

/// IPMLStandby14
Property IPMLStandby14 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 69, SqlFieldName = IPML_Standby14 ];

/// IPMLStandby15
Property IPMLStandby15 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 70, SqlFieldName = IPML_Standby15 ];

/// IPMLStandby16
Property IPMLStandby16 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 71, SqlFieldName = IPML_Standby16 ];

/// IPMLStandby17
Property IPMLStandby17 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 72, SqlFieldName = IPML_Standby17 ];

/// IPMLStandby18
Property IPMLStandby18 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 73, SqlFieldName = IPML_Standby18 ];

/// IPMLStandby19
Property IPMLStandby19 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 74, SqlFieldName = IPML_Standby19 ];

/// IPMLStandby20
Property IPMLStandby20 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 75, SqlFieldName = IPML_Standby20 ];

/// IPMLDhccStatus
Property IPMLDhccStatus As PMPDictionary3 [ SqlColumnNumber = 76, SqlFieldName = IPML_DhccStatus ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^User.PMPImprovementList(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="IPML_AdjunctFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IPML_AssignEngineer_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IPML_Auditor">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IPML_Auditor1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IPML_Auditor2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IPML_Auditor3">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IPML_Auditor4">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IPML_Auditor5">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IPML_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IPML_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IPML_CreateLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IPML_CreateTel">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="IPML_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="IPML_CreateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="IPML_Degree_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="IPML_DevelopUser">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="IPML_DhccDate">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="IPML_DhccFlag">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="IPML_DhccStatus">
<Delimiter>"^"</Delimiter>
<Piece>75</Piece>
</Data>
<Data name="IPML_DhccTime">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="IPML_DhccType">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="IPML_DhccUser">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="IPML_EidtUser">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="IPML_EidtedSituation">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="IPML_Emergency_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="IPML_Engineer_DR">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="IPML_FinishDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="IPML_FinishTime">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="IPML_HosInDem">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="IPML_HosInHandler">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="IPML_InNote">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="IPML_List">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="IPML_Menu">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="IPML_Mode">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="IPML_Module_DR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="IPML_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IPML_PredictTime">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="IPML_President">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="IPML_Project_DR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="IPML_RevList">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="IPML_RevListIMP">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="IPML_Situation">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="IPML_Solution">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="IPML_Standby1">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="IPML_Standby10">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="IPML_Standby11">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="IPML_Standby12">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="IPML_Standby13">
<Delimiter>"^"</Delimiter>
<Piece>67</Piece>
</Data>
<Data name="IPML_Standby14">
<Delimiter>"^"</Delimiter>
<Piece>68</Piece>
</Data>
<Data name="IPML_Standby15">
<Delimiter>"^"</Delimiter>
<Piece>69</Piece>
</Data>
<Data name="IPML_Standby16">
<Delimiter>"^"</Delimiter>
<Piece>70</Piece>
</Data>
<Data name="IPML_Standby17">
<Delimiter>"^"</Delimiter>
<Piece>71</Piece>
</Data>
<Data name="IPML_Standby18">
<Delimiter>"^"</Delimiter>
<Piece>72</Piece>
</Data>
<Data name="IPML_Standby19">
<Delimiter>"^"</Delimiter>
<Piece>73</Piece>
</Data>
<Data name="IPML_Standby2">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="IPML_Standby20">
<Delimiter>"^"</Delimiter>
<Piece>74</Piece>
</Data>
<Data name="IPML_Standby3">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="IPML_Standby4">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="IPML_Standby5">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="IPML_Standby6">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="IPML_Standby7">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="IPML_Standby8">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="IPML_Standby9">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="IPML_Standtb1">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="IPML_Standtb2">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="IPML_Standtb3">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="IPML_Standtb4">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="IPML_Standtb5">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="IPML_Standtb6">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="IPML_Standtb7">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="IPML_Status_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="IPML_TestDate">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="IPML_TestTime">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="IPML_Type">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="IPML_UpdateType">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Global>^PMPImprovementList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{IPML_Rowid}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{IPML_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofCode">
<Global>^PMPImprovementListi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IPML_Code}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPML_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofCreateDate">
<Global>^PMPImprovementListi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"CreateDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IPML_CreateDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPML_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofCreateLoc">
<Global>^PMPImprovementListi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"CreateLoc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IPML_CreateLoc_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPML_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDHCCDATE">
<Global>^PMPImprovementListi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"DHCCDATE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IPML_DhccFlag}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPML_DhccDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IPML_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDHCCFLAG">
<Global>^PMPImprovementListi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"DHCFLAG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IPML_DhccFlag}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPML_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDHCCstatus">
<Global>^PMPImprovementListi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"dhccstatus"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IPML_DhccFlag}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPML_DhccStatus}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IPML_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDemFlag">
<Global>^PMPImprovementListi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"DemFlag"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IPML_HosInDem}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPML_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofFinishDate">
<Global>^PMPImprovementListi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"FinlshDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IPML_FinishDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPML_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofIPMLProjectDR">
<Global>^PMPImprovementListi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>{IPML_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IPML_Project_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPML_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofMenu">
<Global>^PMPImprovementListi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Menu"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IPML_Menu}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPML_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofModuleDR">
<Global>^PMPImprovementListi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>{IPML_Module_DR}</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>{IPML_Rowid}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Module"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IPML_Module_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPML_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexofStatus">
<Global>^PMPImprovementListi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"IPMLStatusDR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IPML_Status_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPML_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PMPImprovementListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
