/// Description： 结构化数据
/// Creator：李得原
/// Date： 2018-11-22
Class User.MKBStructuredData Extends (%Persistent, User.Abstract) [ SqlTableName = MKB_StructuredData ]
{

/// 父表指向子表字段
Relationship MKBSDStructResult As User.MKBStructuredDataResult [ Cardinality = children, Inverse = MKBSDStructData, SqlColumnNumber = 2 ];

/// 父表指向科室频次子表字段
Relationship MKBSDStructLoc As User.MKBStructuredDataLoc [ Cardinality = children, Inverse = MKBSDStructData, SqlColumnNumber = 3 ];

/// 父表指向别名/其他描述
Relationship MKBSDStructOther As User.MKBStructuredDataOther [ Cardinality = children, Inverse = MKBSDStructData, SqlColumnNumber = 4 ];

/// 父表指向专业科室
Relationship MKBSDStructProLoc As User.MKBStructuredDataProLoc [ Cardinality = children, Inverse = MKBSDStructData ];

/// 诊断名
Property MKBSDDiag As %String(MAXLEN = "") [ SqlFieldName = MKBSD_Diag ];

/// 科室名
Property MKBSDLoc As %String(MAXLEN = "") [ SqlFieldName = MKBSD_Loc ];

/// 诊断出现频次
Property MKBSDFrequency As %String(MAXLEN = "") [ SqlFieldName = MKBSD_Frequency ];

/// 数据处理状态
Property MKBSDStatus As %String(DISPLAYLIST = ",已处理,未处理,放弃处理,预处理,上报待处理,已审核", VALUELIST = ",Y,N,G,P,X,O") [ SqlFieldName = MKBSD_Status ];

/// 参考中心词
Property MKBSDCenterWordID As %String [ SqlFieldName = MKBSD_CenterWordID ];

/// 操作时间
Property MKBSDDate As %Date [ SqlFieldName = MKBSD_Date ];

/// 操作人(从Session中取)
Property MKBSDUpdateUser As User.SSUser [ SqlFieldName = MKBSD_UpdateUser ];

/// 分词结果
Property MKBSDSegmentation As %String(MAXLEN = "") [ SqlFieldName = MKBSD_Segmentation ];

/// 诊断来源标识
Property MKBSDDiaSource As %String [ SqlFieldName = MKBSD_DiaSource ];

/// MRC指向
Property MKBSDICDTermDr As User.MKBTerm [ SqlFieldName = MKBSD_ICDTermDr ];

/// 别名
Property MKBSDAlias As %String(MAXLEN = "") [ SqlFieldName = MKBSD_Alias ];

/// 科室总频次
Property MKBSDTotalFreq As %String [ SqlFieldName = MKBSD_TotalFreq ];

/// 标识有没有结构化，1为结构化
Property MKBSDChildStructFlag As %String [ SqlFieldName = MKBSD_ChildStructFlag ];

/// 合并标志 C代表已合并将不再显示，未合并为空 D名称一样的中英文括号
Property MKBSDMergeFlag As %String [ SqlFieldName = MKBSD_MergeFlag ];

/// 备注（上报理由）
Property MKBSDNote As %String(MAXLEN = "") [ SqlFieldName = MKBSD_Note ];

/// 上报理由类型（缺诊断短语A，诊断短语不正确B，缺诊断表达式C，诊断表达式不正确D，缺ICDE，ICD不正确F）
Property MKBSDReson As %String(MAXLEN = "") [ SqlFieldName = MKBSD_Reson ];

/// 最优ICD（多个诊断短语匹配了同一个结构化诊断，取出最先匹配的icd）
Property MKBSDInitialICD As %String(MAXLEN = "") [ SqlFieldName = MKBSD_InitialICD ];

/// 诊断名拼音码
Property MKBSDDiagPYCode As %String(MAXLEN = "") [ SqlFieldName = MKBSD_DiagPYCode ];

/// ICD编码
Property MKBSDICD As %String [ SqlFieldName = MKBSD_ICD ];

/// ICD中文描述
Property MKBSDICDDesc As %String(MAXLEN = "") [ SqlFieldName = MKBSD_ICDDesc ];

/// 工厂注册指向
Property MKBSDBaseDr As User.MKBStructuredBase [ SqlFieldName = MKBSD_BaseDr ];

/// 诊断1 2 3之间的关系 AND OR
Property MKBSDResultRelation As %String [ SqlFieldName = MKBSD_ResultRelation ];

/// 中医诊断标识 2021-04-15 -》MRCIDBillFlag3
Property MKBSDTCMDiagFlag As %String [ SqlFieldName = MKBSD_TCMDiagFlag ];

/// 中医证型标识 2021-04-15 -》MRCIDBillFlag1
Property MKBSDTCMSynFlag As %String [ SqlFieldName = MKBSD_TCMSynFlag ];

/// 肿瘤形态学编码标识 2021-04-15 -》MRCIDMetastaticSite
Property MKBSDTumourFlag As %String [ SqlFieldName = MKBSD_TumourFlag ];

/// 损伤中毒外部原因标志 2021-04-15 -》MRCIDInjuryPoisoningCode
Property MKBSDInjuryFlag As %String [ SqlFieldName = MKBSD_InjuryFlag ];

/// 开始日期 2021-04-15 -》MRCIDDateActiveFrom
Property MKBSDDateActiveFrom As %Date [ SqlFieldName = MKBSD_DateActiveFrom ];

/// 截止日期 2021-04-15 -》MRCIDDateActiveTo
Property MKBSDDateActiveTo As %Date [ SqlFieldName = MKBSD_DateActiveTo ];

/// his诊断ID 2021-06-15 -》MKBSDHisRowID
Property MKBSDHisRowID As %String [ SqlFieldName = MKBSD_HisRowID ];

/// HIS诊断代码 2021-06-15 -》MKBSDHisCode
Property MKBSDHisCode As %String [ SqlFieldName = MKBSD_HisCode ];

/// 副编码 2021-06-15 -》MKBSDDeputyCode
Property MKBSDDeputyCode As %String [ SqlFieldName = MKBSD_DeputyCode ];

/// 就诊类型 2021-06-15 -》MKBSDClinicType	（门诊O。急诊E。住院I。体检H。新生儿N）
Property MKBSDClinicType As %String [ SqlFieldName = MKBSD_ClinicType ];

/// icd诊断分类 2021-06-15 -》MKBSDClassification	
Property MKBSDClassification As %String [ SqlFieldName = MKBSD_Classification ];

/// 限制性别 2021-06-15 -》MKBSDLimitSex
Property MKBSDLimitSex As %String [ SqlFieldName = MKBSD_LimitSex ];

/// 注释2021-06-15 -》MKBSDHisRemark
Property MKBSDHisRemark As %String(MAXLEN = "") [ SqlFieldName = MKBSD_HisRemark ];

/// 从年龄 2021-06-15 -》MKBSDAgeFrom
Property MKBSDAgeFrom As %String [ SqlFieldName = MKBSD_AgeFrom ];

/// 到年龄 2021-06-15 -》MKBSDAgeTo
Property MKBSDAgeTo As %String [ SqlFieldName = MKBSD_AgeTo ];

/// icd9代码 2021-06-15 -》MKBSDICDCode9
Property MKBSDICD9Code As %String [ SqlFieldName = MKBSD_ICD9Code ];

/// 国家标准名称 2021-06-15 -》MKBSDNationalDesc
Property MKBSDNationalDesc As %String(MAXLEN = "") [ SqlFieldName = MKBSD_NationalDesc ];

/// 是否能匹配全局化词表标志 2021-08-6   钟荣枫
Property MKBSDMatchGlobalFlag As %String [ SqlFieldName = MKBSD_MatchGlobalFlag ];

/// his诊断ID为唯一索引 2021-06-15
Index HisIDIndex On (MKBSDBaseDr, MKBSDHisRowID As Exact);

Index HisCodeIndex On (MKBSDBaseDr, MKBSDHisCode As Exact);

/// 诊断+ICD编码为唯一索引 2021-04-15
Index DiagICDIndex On (MKBSDBaseDr, MKBSDDiag As Exact, MKBSDICD As Exact);

Index MKBSDDiagIndex On (MKBSDBaseDr, MKBSDDiag);

Index SegmIndex On MKBSDSegmentation;

Index TotalFreqIndex On (MKBSDTotalFreq As Exact, MKBSDDiag As Exact);

Index ICDIndex On MKBSDICD As Exact;

Index StructIndex On MKBSDChildStructFlag As Exact;

Index MergeIndex On MKBSDMergeFlag As Exact;

Index InitialICDIndex On MKBSDInitialICD As Exact;

Index BaseIndex On MKBSDBaseDr;

Storage Default
{
<Data name="MKBStructuredDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBSDDiag</Value>
</Value>
<Value name="3">
<Value>MKBSDLoc</Value>
</Value>
<Value name="4">
<Value>MKBSDFrequency</Value>
</Value>
<Value name="5">
<Value>MKBSDStatus</Value>
</Value>
<Value name="6">
<Value>MKBSDCenterWordID</Value>
</Value>
<Value name="7">
<Value>MKBSDDate</Value>
</Value>
<Value name="8">
<Value>MKBSDUpdateUser</Value>
</Value>
<Value name="9">
<Value>MKBSDSegmentation</Value>
</Value>
<Value name="10">
<Value>MKBSDDiaSource</Value>
</Value>
<Value name="11">
<Value>MKBSDICDTermDr</Value>
</Value>
<Value name="12">
<Value>MKBSDAlias</Value>
</Value>
<Value name="13">
<Value>MKBSDTotalFreq</Value>
</Value>
<Value name="14">
<Value>MKBSDChildStructFlag</Value>
</Value>
<Value name="15">
<Value>MKBSDMergeFlag</Value>
</Value>
<Value name="16">
<Value>MKBSDNote</Value>
</Value>
<Value name="17">
<Value>MKBSDReson</Value>
</Value>
<Value name="18">
<Value>MKBSDInitialICD</Value>
</Value>
<Value name="19">
<Value>MKBSDDiagPYCode</Value>
</Value>
<Value name="20">
<Value>MKBSDICD</Value>
</Value>
<Value name="21">
<Value>MKBSDICDDesc</Value>
</Value>
<Value name="22">
<Value>MKBSDBaseDr</Value>
</Value>
<Value name="23">
<Value>MKBSDResultRelation</Value>
</Value>
<Value name="24">
<Value>MKBSDTCMDiagFlag</Value>
</Value>
<Value name="25">
<Value>MKBSDTCMSynFlag</Value>
</Value>
<Value name="26">
<Value>MKBSDTumourFlag</Value>
</Value>
<Value name="27">
<Value>MKBSDInjuryFlag</Value>
</Value>
<Value name="28">
<Value>MKBSDDateActiveFrom</Value>
</Value>
<Value name="29">
<Value>MKBSDDateActiveTo</Value>
</Value>
<Value name="30">
<Value>MKBSDHisRowID</Value>
</Value>
<Value name="31">
<Value>MKBSDHisCode</Value>
</Value>
<Value name="32">
<Value>MKBSDDeputyCode</Value>
</Value>
<Value name="33">
<Value>MKBSDClinicType</Value>
</Value>
<Value name="34">
<Value>MKBSDClassification</Value>
</Value>
<Value name="35">
<Value>MKBSDLimitSex</Value>
</Value>
<Value name="36">
<Value>MKBSDHisRemark</Value>
</Value>
<Value name="37">
<Value>MKBSDAgeFrom</Value>
</Value>
<Value name="38">
<Value>MKBSDAgeTo</Value>
</Value>
<Value name="39">
<Value>MKBSDICD9Code</Value>
</Value>
<Value name="40">
<Value>MKBSDNationalDesc</Value>
</Value>
<Value name="41">
<Value>MKBSDMatchGlobalFlag</Value>
</Value>
</Data>
<DataLocation>^User.MKBStructuredDataD</DataLocation>
<DefaultData>MKBStructuredDataDefaultData</DefaultData>
<IdLocation>^User.MKBStructuredDataD</IdLocation>
<IndexLocation>^User.MKBStructuredDataI</IndexLocation>
<StreamLocation>^User.MKBStructuredDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
