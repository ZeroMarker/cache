/// MRC ICD Diagnosis       (MRCID,165)
Class User.MRCICDDx Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = MRC_ICDDx, StorageStrategy = SQLStorage ]
{

Relationship ChildMRCICDkeyw As MRCICDkeyw [ Cardinality = children, Inverse = MRCIKMRCIDParRef ];

Relationship ChildMRCICDAlias As MRCICDAlias [ Cardinality = children, Inverse = ALIASParRef ];

Relationship ChildMRCICDLocation As MRCICDLocation [ Cardinality = children, Inverse = LOCParREf ];

Relationship ChildMRCICDDxEdition As MRCICDDxEdition [ Cardinality = children, Inverse = EDParRef ];

Relationship ChildMRCICDDxOrders As MRCICDDxOrders [ Cardinality = children, Inverse = ITMParRef ];

/// 代码  //chenying update@20170704   将代码最大长度由15改成100
Property MRCIDCode As %String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = MRCID_Code ];

/// 名称
Property MRCIDDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = MRCID_Desc ];

/// Short Description
Property MRCIDShortDesc As %String(COLLATION = "AlphaUp", MAXLEN = 66, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlComputeCode = { s {MRCID_ShortDesc}=$e({MRCID_Desc},1,66)
}, SqlComputed, SqlFieldName = MRCID_ShortDesc, Transient ];

/// Description for Ins Co
Property MRCIDInsDesc As %String(COLLATION = "AlphaUp", MAXLEN = 150, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = MRCID_InsDesc ];

/// ICD10  //chenying update@20170704   将代码最大长度由15改成100
Property MRCIDICD9CMCode As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = MRCID_ICD9CM_Code ];

/// Max Waiting Period
Property MRCIDMaxWaitPeriod As %Float [ SqlColumnNumber = 7, SqlFieldName = MRCID_MaxWaitPeriod ];

/// 开始日期
Property MRCIDDateActiveFrom As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 8, SqlFieldName = MRCID_DateActiveFrom ];

/// 结束日期
Property MRCIDDateActiveTo As %Date [ SqlColumnNumber = 9, SqlFieldName = MRCID_DateActiveTo ];

/// 开始年龄
Property MRCIDAgeFrom As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = MRCID_AgeFrom ];

/// 截止年龄
Property MRCIDAgeTo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = MRCID_AgeTo ];

/// 性别
Property MRCIDSexDR As CTSex [ SqlColumnNumber = 12, SqlFieldName = MRCID_Sex_DR ];

/// Des Ref Billsub1
Property MRCIDBillsub1DR As ARCBillSub [ SqlColumnNumber = 13, SqlFieldName = MRCID_Billsub1_DR ];

/// Des Ref Billsub2
Property MRCIDBillsub2DR As ARCBillSub [ SqlColumnNumber = 14, SqlFieldName = MRCID_Billsub2_DR ];

/// 中医症型标志
Property MRCIDBillFlag1 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = MRCID_BillFlag1 ];

/// Bill Flag 2
Property MRCIDBillFlag2 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = MRCID_BillFlag2 ];

/// 中医诊断标志
Property MRCIDBillFlag3 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = MRCID_BillFlag3 ];

/// Des Ref PayorGroup
Property MRCIDPayorGroupDR As MRCPayorICDGroup [ SqlColumnNumber = 18, SqlFieldName = MRCID_PayorGroup_DR ];

/// SeriousDisease
Property MRCIDSeriousDis As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = MRCID_SeriousDis ];

/// Des Ref BodySysProbStat
Property MRCIDBodySysProbStatDR As MRCBodySystemProbStatus [ SqlColumnNumber = 20, SqlFieldName = MRCID_BodySysProbStat_DR ];

/// Des Ref BodyArea
Property MRCIDBodyAreaDR As MRCBodyArea [ SqlColumnNumber = 21, SqlFieldName = MRCID_BodyArea_DR ];

/// Age2From
Property MRCIDAge2From As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = MRCID_Age2From ];

/// Age2To
Property MRCIDAge2To As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = MRCID_Age2To ];

/// AgeCheckType
Property MRCIDAgeCheckType As %String(DISPLAYLIST = ",MRW,MWO,MWW,YRO,YRW,YWO,YWW,MRO", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Age in months - Rejection if within range,Age in months - Warning if outside range,Age in months - Warning if within range,Age in years - Rejection if outside range,Age in years - Rejection if within range,Age in years - Warning if outside range,Age in years - Warning if within range,Age in months - Rejection if outside range") [ SqlColumnNumber = 24, SqlFieldName = MRCID_AgeCheckType ];

/// SexCheckType
Property MRCIDSexCheckType As %String(DISPLAYLIST = ",RN,RM,WN,WM", MAXLEN = 2, TRUNCATE = 1, VALUELIST = ",RejectSexNoMatch,RejectSexMatch,WarnSexNoMatch,WarnSexMatch") [ SqlColumnNumber = 25, SqlFieldName = MRCID_SexCheckType ];

/// Age2CheckType
Property MRCIDAge2CheckType As %String(DISPLAYLIST = ",YWW,MRW,MWO,MWW,YRO,YRW,YWO,MRO", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Age in years - Warning if within range,Age in months - Rejection if within range,Age in months - Warning if outside range,Age in months - Warning if within range,Age in years - Rejection if outside range,Age in years - Rejection if within range,Age in years - Warning if outside range,Age in months - Rejection if outside range") [ SqlColumnNumber = 26, SqlFieldName = MRCID_Age2CheckType ];

/// External Cause
Property MRCIDExternalCause As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = MRCID_ExternalCause ];

/// Unacceptable PDx
Property MRCIDUnacceptablePDx As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = MRCID_UnacceptablePDx ];

/// 有效标志，为N的数据临床开不出该诊断
Property MRCIDValid As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 29, SqlFieldName = MRCID_Valid ];

/// Des Ref to Sex Check Type
Property MRCIDSexCheckTypeDR As MRCSexCheckType [ SqlColumnNumber = 30, SqlFieldName = MRCID_SexCheckTypeDR ];

/// Des Ref Age Check Type1
Property MRCIDAgeCheckType1DR As MRCAgeCheckType [ SqlColumnNumber = 31, SqlFieldName = MRCID_AgeCheckType1DR ];

/// Des Ref Age Check Type2
Property MRCIDAgeCheckType2DR As MRCAgeCheckType [ SqlColumnNumber = 32, SqlFieldName = MRCID_AgeCheckType2_DR ];

/// Area Code Restraint DR
Property MRCIDAreaCodeRestraintDR As MRCAreaCodeRestraint [ SqlColumnNumber = 33, SqlFieldName = MRCID_AreaCodeRestraintDR ];

/// Des Ref Dagger N Asterisk Edit
Property MRCIDDaggerNAsteriskEditDR As MRCDaggerAnAsteriskEdit [ SqlColumnNumber = 34, SqlFieldName = MRCID_DaggerNAsteriskEditDR ];

/// Des Ref Additional Code Requirement
Property MRCIDAdditionalCodeREqDR As MRCAdditCodeReq [ SqlColumnNumber = 35, SqlFieldName = MRCID_AdditionalCodeREqDR ];

/// Des Ref Coding Practices
Property MRCIDCodingPracticesDR As MRCCodingPractices [ SqlColumnNumber = 36, SqlFieldName = MRCID_CodingPracticesDR ];

/// ICD9代码
Property MRCIDICD9Map As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 37, SqlFieldName = MRCID_ICD9_Map ];

/// 注释
Property MRCIDLongDescription As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 38, SqlFieldName = MRCID_LongDescription ];

/// Alternate Desc
Property MRCIDAlternateDesc As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 39, SqlFieldName = MRCID_AlternateDesc ];

/// MorphologyCode
Property MRCIDMorphologyCode As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 40, SqlFieldName = MRCID_MorphologyCode ];

/// Cancer
Property MRCIDCancer As %String(DISPLAYLIST = ",MustBeCancerRegistered,MayBeCancerRegistered,PastHistoryOfCancer,Other", MAXLEN = 22, TRUNCATE = 1, VALUELIST = ",MUCR,MACR,PHC,OTH") [ SqlColumnNumber = 41, SqlFieldName = MRCID_Cancer ];

/// 肿瘤形态学编码标志
Property MRCIDMetastaticSite As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 42, SqlFieldName = MRCID_MetastaticSite ];

/// 损伤中毒外部原因标志
Property MRCIDInjuryPoisoningCode As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 43, SqlFieldName = MRCID_InjuryPoisoningCode ];

/// Valid M Code Extention
Property MRCIDValidMCodeExt As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 44, SqlFieldName = MRCID_ValidMCodeExt ];

/// 副编码
Property MRCID2ndCodeInPair As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 45, SqlFieldName = MRCID_2ndCodeInPair ];

/// AllowToDuplicate
Property MRCIDAllowToDuplicate As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 46, SqlFieldName = MRCID_AllowToDuplicate ];

/// Des Ref DiagGroup1
Property MRCIDDiagGroup1DR As MRCDiagnosisGroup1 [ SqlColumnNumber = 47, SqlFieldName = MRCID_DiagGroup1_DR ];

/// ICD诊断分类  2019-03-29 add by chenying
Property MRCIDTypeDR As User.MRCICDDxType [ SqlColumnNumber = 48, SqlFieldName = MRCID_Type_DR ];

/// 就诊类型(门诊O,急诊E,住院I,体检H,新生儿N) 节点位置47, 2020-01-13 add by chenying 
Property MRCIDClinicType As %String(MAXLEN = "") [ SqlColumnNumber = 49, SqlFieldName = MRCID_ClinicType ];

/// 无效主诊断标识（Y时不能作为主诊断来开） 2020-12-22
Property MRCIDInvalidMainFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 50, SqlFieldName = MRCID_InvalidMainFlag ];

/// 国家标准名称 节点位置49
Property MRCIDNationalDesc As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 51, SqlFieldName = MRCID_NationalDesc ];

/// 国家标准编码 节点位置50
Property MRCIDNationalCode As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 52, SqlFieldName = MRCID_NationalCode ];

/// 国家医保编码 节点位置51
Property MRCIDInsuCode As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 53, SqlFieldName = MRCID_InsuCode ];

/// 国家医保名称 节点位置52
Property MRCIDInsuDesc As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 54, SqlFieldName = MRCID_InsuDesc ];

/// 从年龄类型 （岁/月/日） ^53
Property MRCIDAgeFromType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 55, SqlFieldName = MRCID_AgeFromType ];

/// 到年龄类型 （岁/月/日） ^54
Property MRCIDAgeToType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 56, SqlFieldName = MRCID_AgeToType ];

/// 医保灰码  ^55
Property MRCIDGrayCodeFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 57, SqlFieldName = MRCID_GrayCodeFlag ];

/// 版本号 ^56 add@2022-12-27
Property MRCIDVersionDictDR As CT.BDP.CT.BDVersionDict [ SqlColumnNumber = 58, SqlFieldName = MRCID_VersionDict_DR ];

/// 诊断类型 ^57 add@2023-3-7  中医，西医，证型
Property MRCIDDiagnosticType As %String(DISPLAYLIST = ",Traditional Chinese medicine,Western medicine,Syndrome type", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",TCM,WM,ST") [ SqlColumnNumber = 59, SqlFieldName = MRCID_DiagnosticType ];

/// 罕见病标志  ^58
Property MRCIDRareDiseaseFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 60, SqlFieldName = MRCID_RareDiseaseFlag ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
    d ##Class(User.MRCICDDx).OnTrigger($g(%d(1)))
    d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCICDDx","OnAfterInsert")
    d PRFILUPD^at165({MRCID_RowId})
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRCICDDx).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCICDDx","OnAfterUpdate")
 d PRFILUPD^at165({MRCID_RowId})
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRCICDDx).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCICDDx","OnBeforeDelete")
 d VALDEL^atgen
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRCICDDx).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCICDDx","OnBeforeUpdate")
 d VALUPD^atgen
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCICDDx","OnBeforeInsert")
 d VALINS^atgen
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRCICDDx).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCICDDx","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^MRC("ID",0))</SqlIdExpression>
<SQLMap name="IndexCancer">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MRCID_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Cancer"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MRCID_Cancer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MRCID_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDiagnosticType">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MRCID_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Diagnostic"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MRCID_DiagnosticType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MRCID_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexICD">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MRCID_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ICD"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MRCID_ICD9CM_Code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MRCID_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInsDesc">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MRCID_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"InsDesc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({MRCID_InsDesc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MRCID_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMetastatticSite">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MRCID_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Metast"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MRCID_MetastaticSite}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MRCID_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMorphologyCode">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MRCID_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Morph"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MRCID_MorphologyCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MRCID_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSeriousDisCode">
<Condition>{MRCID_SeriousDis}["Y"</Condition>
<ConditionFields>MRCID_Code,MRCID_SeriousDis</ConditionFields>
<Global>^MRC</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MRCID_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SerCode"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({MRCID_Code})_"Z"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MRCID_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeDR">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MRCID_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"TypeDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MRCID_Type_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MRCID_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexVersionDictDR">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MRCID_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"VersionDictDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MRCID_VersionDict_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MRCID_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MRCIDDataMasterMap">
<Data name="MRCID_2ndCodeInPair">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="MRCID_AdditionalCodeREqDR">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="MRCID_Age2CheckType">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="MRCID_Age2From">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="MRCID_Age2To">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="MRCID_AgeCheckType">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="MRCID_AgeCheckType1DR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="MRCID_AgeCheckType2_DR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="MRCID_AgeFrom">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MRCID_AgeFromType">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="MRCID_AgeTo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MRCID_AgeToType">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="MRCID_AllowToDuplicate">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="MRCID_AlternateDesc">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="MRCID_AreaCodeRestraintDR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="MRCID_BillFlag1">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MRCID_BillFlag2">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MRCID_BillFlag3">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MRCID_Billsub1_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MRCID_Billsub2_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MRCID_BodyArea_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MRCID_BodySysProbStat_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MRCID_Cancer">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="MRCID_ClinicType">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="MRCID_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MRCID_CodingPracticesDR">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="MRCID_DaggerNAsteriskEditDR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="MRCID_DateActiveFrom">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MRCID_DateActiveTo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MRCID_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MRCID_DiagGroup1_DR">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="MRCID_DiagnosticType">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="MRCID_ExternalCause">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="MRCID_GrayCodeFlag">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="MRCID_ICD9CM_Code">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MRCID_ICD9_Map">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="MRCID_InjuryPoisoningCode">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="MRCID_InsDesc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MRCID_InsuCode">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="MRCID_InsuDesc">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="MRCID_InvalidMainFlag">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="MRCID_LongDescription">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="MRCID_MaxWaitPeriod">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MRCID_MetastaticSite">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="MRCID_MorphologyCode">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="MRCID_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="MRCID_NationalDesc">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="MRCID_PayorGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MRCID_RareDiseaseFlag">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="MRCID_SeriousDis">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MRCID_SexCheckType">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="MRCID_SexCheckTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="MRCID_Sex_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MRCID_Type_DR">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="MRCID_UnacceptablePDx">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="MRCID_Valid">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="MRCID_ValidMCodeExt">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="MRCID_VersionDict_DR">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MRCID_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"ID"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{MRCID_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="MRCIDIndexMRCIDCode">
<Data name="MRCID_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MRCID_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"ID"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({MRCID_Code})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MRCID_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MRCIDIndexMRCIDDesc">
<Data name="MRCID_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MRCID_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"ID"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({MRCID_ShortDesc})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MRCID_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MRCID_RowId</SqlRowIdName>
<StreamLocation>^User.MRCICDDxS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
