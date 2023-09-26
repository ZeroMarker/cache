/// 1306 医用耗材目录下载
Class CT.INSU.MI.MEDMCSLIST Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = Rowid ]
{

/// 1 医院ID	HOSP_ID	VARCHAR	30	否
Property HospId As %String(CAPTION = "医院ID", MAXLEN = 6) [ SqlColumnNumber = 2, SqlFieldName = HOSP_ID ];

/// 2 医保类型	HI_TYPE	VARCHAR	30	否
Property HiType As %String(CAPTION = "医保类型", MAXLEN = 10) [ SqlColumnNumber = 3, SqlFieldName = HI_TYPE ];

/// 3 医疗目录编码	MED_LIST_CODG	VARCHAR	50	是	
Property MedListCodg As %String(CAPTION = "医疗目录编码", MAXLEN = 50) [ SqlColumnNumber = 4, SqlFieldName = MED_LIST_CODG ];

/// 4 耗材名称	MCS_NAME	VARCHAR	500	是	
Property McsName As %String(CAPTION = "耗材名称", MAXLEN = 500) [ SqlColumnNumber = 5, SqlFieldName = MCS_NAME ];

/// 5 医疗器械唯一标识码	UDI	VARCHAR	500	是
Property Udi As %String(CAPTION = "医疗器械唯一标识码", MAXLEN = 200) [ SqlColumnNumber = 6, SqlFieldName = UDI ];

/// 6 医保通用名代码	HI_GENNAME_CODE	VARCHAR	50	是	
Property HiGennameCode As %String(CAPTION = "医保通用名代码", MAXLEN = 50) [ SqlColumnNumber = 7, SqlFieldName = HI_GENNAME_CODE ];

/// 7 医保通用名	HI_GENNAME	VARCHAR	50	是		
Property HiGenname As %String(CAPTION = "医保通用名", MAXLEN = 50) [ SqlColumnNumber = 8, SqlFieldName = HI_GENNAME ];

/// 8 产品型号	PROD_MOL	VARCHAR	50	是	
Property ProdMol As %String(CAPTION = "产品型号", MAXLEN = 50) [ SqlColumnNumber = 9, SqlFieldName = PROD_MOL ];

/// 9 规格代码	SPEC_CODE	VARCHAR	20	是		
Property SpecCode As %String(CAPTION = "规格代码", MAXLEN = 20) [ SqlColumnNumber = 10, SqlFieldName = SPEC_CODE ];

/// 10 规格	SPEC	VARCHAR	200	是
Property Spec As %String(CAPTION = "规格", MAXLEN = 200) [ SqlColumnNumber = 11, SqlFieldName = SPEC ];

/// 11 耗材分类	MCS_TYPE	VARCHAR	255	是
Property McsType As %String(CAPTION = "耗材分类", MAXLEN = 255) [ SqlColumnNumber = 12, SqlFieldName = MCS_TYPE ];

/// 12 规格型号	SPEC_MOL	LONGTEXT	0	是	
Property SpecMol As %String(CAPTION = "规格型号", MAXLEN = 255) [ SqlColumnNumber = 13, SqlFieldName = SPEC_MOL ];

/// 13 材质代码	MATL_CODE	VARCHAR	3	是		
Property MatlCode As %String(CAPTION = "材质代码", MAXLEN = 4) [ SqlColumnNumber = 14, SqlFieldName = MATL_CODE ];

/// 14 耗材材质	MCS_MATL	VARCHAR	500	是
Property MacMatl As %String(CAPTION = "耗材材质", MAXLEN = 500) [ SqlColumnNumber = 15, SqlFieldName = MCS_MATL ];

/// 15 包装规格	PACSPEC	VARCHAR	100	是		
Property PacSpec As %String(CAPTION = "包装规格", MAXLEN = 100) [ SqlColumnNumber = 16, SqlFieldName = PACSPEC ];

/// 16 包装数量	PAC_CNT	VARCHAR	20	是	
Property PacCnt As %String(CAPTION = "包装数量", MAXLEN = 20) [ SqlColumnNumber = 17, SqlFieldName = PAC_CNT ];

/// 17 产品包装材质	PROD_PACMATL	VARCHAR	500	是	
Property ProdPacmatl As %String(CAPTION = "产品包装材质", MAXLEN = 500) [ SqlColumnNumber = 18, SqlFieldName = PROD_PACMATL ];

/// 18 包装单位	PACUNT	VARCHAR	50	是
Property Pacunt As %String(CAPTION = "包装单位", MAXLEN = 50) [ SqlColumnNumber = 19, SqlFieldName = PACUNT ];

/// 19 产品转换比	PROD_CONVRAT	VARCHAR	20	是	
Property ProdConvrat As %String(CAPTION = "产品转换比", MAXLEN = 20) [ SqlColumnNumber = 20, SqlFieldName = PROD_CONVRAT ];

/// 20 最小使用单位	MIN_USEUNT	VARCHAR	30	是		
Property MinUseunt As %String(CAPTION = "最小使用单位", MAXLEN = 30) [ SqlColumnNumber = 21, SqlFieldName = MIN_USEUNT ];

/// 21 生产地类别	PRODPLAC_TYPE	VARCHAR	6	是	
Property ProdplacType As %String(CAPTION = "生产地类别", MAXLEN = 6) [ SqlColumnNumber = 22, SqlFieldName = PRODPLAC_TYPE ];

/// 22 生产地类别名称	PRODPLAC_TYPE_NAME	VARCHAR	50	是
Property ProdplacTypeName As %String(CAPTION = "生产地类别名称", MAXLEN = 50) [ SqlColumnNumber = 23, SqlFieldName = PRODPLAC_TYPE_NAME ];

/// 23 产品标准	PRODSTRD	VARCHAR	100	是	
Property PordStrd As %String(CAPTION = "产品标准", MAXLEN = 100) [ SqlColumnNumber = 24, SqlFieldName = PRODSTRD ];

/// 24 产品有效期	PRODEXPY	VARCHAR	50	是
Property ProdExpy As %String(CAPTION = "产品有效期", MAXLEN = 50) [ SqlColumnNumber = 25, SqlFieldName = PRODEXPY ];

/// 25 性能结构与组成	PERF_STRU_COMP	VARCHAR	100	是
Property PerfStruComp As %String(CAPTION = "性能结构与组成", MAXLEN = 100) [ SqlColumnNumber = 26, SqlFieldName = PERF_STRU_COMP ];

/// 26 适用范围	APB_SCP	LONGTEXT	0	是	
Property ApbScp As %String(CAPTION = "适用范围", MAXLEN = 100) [ SqlColumnNumber = 27, SqlFieldName = APB_SCP ];

/// 27 产品使用方法	PROD_ISTR	VARCHAR	100	否
Property ProdIstr As %String(CAPTION = "产品使用方法", MAXLEN = 100) [ SqlColumnNumber = 28, SqlFieldName = PROD_ISTR ];

/// 28 产品图片编号	PROD_IMG_NO	VARCHAR	200	是
Property ProdImgNo As %String(CAPTION = "产品图片编号", MAXLEN = 200) [ SqlColumnNumber = 29, SqlFieldName = PROD_IMG_NO ];

/// 29 产品质量标准	PROD_QLT_STD	VARCHAR	200	否
Property ProdQltStd As %String(CAPTION = "产品质量标准", MAXLEN = 200) [ SqlColumnNumber = 30, SqlFieldName = PROD_QLT_STD ];

/// 30 说明书	MANL	VARCHAR	2000	是	
Property Manl As %String(CAPTION = "说明书", MAXLEN = 2000) [ SqlColumnNumber = 31, SqlFieldName = MANL ];

/// 31 其他证明材料	OTH_CERT_MATL	VARCHAR	2000	是		
Property OthCertMatl As %String(CAPTION = "其他证明材料", MAXLEN = 200) [ SqlColumnNumber = 32, SqlFieldName = OTH_CERT_MATL ];

/// 32 专机专用标志	SPED_FLAG	VARCHAR	3	是	
Property SpedFlag As %String(CAPTION = "专机专用标志", MAXLEN = 4) [ SqlColumnNumber = 33, SqlFieldName = SPED_FLAG ];

/// 33 专机名称	SPED_NAME	VARCHAR	20	否	
Property SpedName As %String(CAPTION = "专机名称", MAXLEN = 20) [ SqlColumnNumber = 34, SqlFieldName = SPED_NAME ];

/// 34 组套名称	COMB_NAME	VARCHAR	20	否	
Property CombName As %String(CAPTION = "组套名称", MAXLEN = 20) [ SqlColumnNumber = 35, SqlFieldName = COMB_NAME ];

/// 35 机套标志	CASE_FLAG	VARCHAR	3	是	
Property CaseFalg As %String(CAPTION = "机套标志", MAXLEN = 4) [ SqlColumnNumber = 36, SqlFieldName = CASE_FLAG ];

/// 36 限制使用标志	LMT_USED_FLAG	VARCHAR	3	是
Property LmtUsedFlag As %String(CAPTION = "限制使用标志", MAXLEN = 4) [ SqlColumnNumber = 37, SqlFieldName = LMT_USED_FLAG ];

/// 37 医保限用范围	HI_LMT_SCP	VARCHAR	50	否
Property HiLmtScp As %String(CAPTION = "医保限用范围", MAXLEN = 50) [ SqlColumnNumber = 38, SqlFieldName = HI_LMT_SCP ];

/// 38 最小销售单位	MIN_SALUNT	VARCHAR	30	是	
Property MinSalunt As %String(CAPTION = "最小销售单位", MAXLEN = 30) [ SqlColumnNumber = 39, SqlFieldName = MIN_SALUNT ];

/// 39 高值耗材标志	HIGHVAL_MCS_FLAG	VARCHAR	3	是	
Property HighvalMcsFlag As %String(CAPTION = "高值耗材标志", MAXLEN = 4) [ SqlColumnNumber = 40, SqlFieldName = HIGHVAL_MCS_FLAG ];

/// 40 医用材料分类代码	MATL_TYPE_CODE	VARCHAR	3	是	
Property MatlTypeCode As %String(CAPTION = "医用材料分类代码", MAXLEN = 4) [ SqlColumnNumber = 41, SqlFieldName = MATL_TYPE_CODE ];

/// 41 植入材料和人体器官标志	IMPT_MATL_HMORGN_FLAG	VARCHAR	3	是	
Property ImptMatlHmorgnFlag As %String(CAPTION = "植入材料和人体器官标志", MAXLEN = 4) [ SqlColumnNumber = 42, SqlFieldName = IMPT_MATL_HMORGN_FLAG ];

/// 42 灭菌标志	STLZ_FLAG	VARCHAR	3	是	
Property StlzFlag As %String(CAPTION = "灭菌标志", MAXLEN = 4) [ SqlColumnNumber = 43, SqlFieldName = STLZ_FLAG ];

/// 43 灭菌标志名称	STLZ_FLAG_NAME	VARCHAR	3	是	
Property StlzFlagName As %String(CAPTION = "灭菌标志名称", MAXLEN = 4) [ SqlColumnNumber = 44, SqlFieldName = STLZ_FLAG_NAME ];

/// 44 植入或介入类标志	IMPT_ITVT_CLSS_FLAG	VARCHAR	3	是	
Property ImptItvtClssFlag As %String(CAPTION = "植入或介入类标志", MAXLEN = 4) [ SqlColumnNumber = 45, SqlFieldName = IMPT_ITVT_CLSS_FLAG ];

/// 45 植入或介入类名称	IMPT_ITVT_CLSS_NAME	VARCHAR	3	是
Property ImptItvtClssName As %String(CAPTION = "植入或介入类名称", MAXLEN = 4) [ SqlColumnNumber = 46, SqlFieldName = IMPT_ITVT_CLSS_NAME ];

/// 46 一次性使用标志	DSPO_USED_FLAG	VARCHAR	3	是	
Property DspoUsedFlag As %String(CAPTION = "一次性使用标志", MAXLEN = 4) [ SqlColumnNumber = 47, SqlFieldName = DSPO_USED_FLAG ];

/// 47 一次性使用标志名称	DSPO_USED_FLAG_NAME	VARCHAR	3	是	
Property DspoUsedFlagName As %String(CAPTION = "一次性使用标志名称", MAXLEN = 4) [ SqlColumnNumber = 48, SqlFieldName = DSPO_USED_FLAG_NAME ];

/// 48 注册备案人名称	REGER_NAME	VARCHAR	500	是
Property RegerName As %String(CAPTION = "注册备案人名称", MAXLEN = 50) [ SqlColumnNumber = 49, SqlFieldName = REGER_NAME ];

/// 49 开始日期	BEGNDATE	DATE	0	是	
Property BegnDate As %String(CAPTION = "开始日期", MAXLEN = 20) [ SqlColumnNumber = 50, SqlFieldName = BEGNDATE ];

/// 50 结束日期	ENDDATE		DATE	0	否	
Property Enddate As %String(CAPTION = "结束日期", MAXLEN = 20) [ SqlColumnNumber = 51, SqlFieldName = ENDDATE ];

/// 51 医疗器械管理类别	MED_EQU_MGT_TYPE	VARCHAR	10	是		
Property MedEquMgtType As %String(CAPTION = "医疗器械管理类别", MAXLEN = 10) [ SqlColumnNumber = 52, SqlFieldName = MED_EQU_MGT_TYPE ];

/// 52 医疗器械管理类别名称	MED_EQU_MGT_TYPE_NAME	VARCHAR	10	是
Property MedEquMgtTypeName As %String(CAPTION = "医疗器械管理类别名称", MAXLEN = 10) [ SqlColumnNumber = 53, SqlFieldName = MED_EQU_MGT_TYPE_NAME ];

/// 53 注册备案号	REG_FIL_NO	VARCHAR	50	是	
Property RegFilNo As %String(CAPTION = "注册备案号", MAXLEN = 50) [ SqlColumnNumber = 54, SqlFieldName = REG_FIL_NO ];

/// 54 注册备案产品名称	REG_FIL_PROD_NAME	VARCHAR	500	是	
Property RegFilProdName As %String(CAPTION = "注册备案产品名称", MAXLEN = 500) [ SqlColumnNumber = 55, SqlFieldName = REG_FIL_PROD_NAME ];

/// 55 结构及组成	STRU_COMP	LONGTEXT	0	是	
Property StruComp As %String(CAPTION = "结构及组成", MAXLEN = 500) [ SqlColumnNumber = 56, SqlFieldName = STRU_COMP ];

/// 56 其他内容	OTH_CONT	LONGTEXT	0	是
Property OthCont As %String(CAPTION = "其他内容", MAXLEN = 500) [ SqlColumnNumber = 57, SqlFieldName = OTH_CONT ];

/// 57 批准日期	APRV_DATE	DATE	0	是
Property AprvDate As %String(CAPTION = "批准日期", MAXLEN = 20) [ SqlColumnNumber = 58, SqlFieldName = APRV_DATE ];

/// 58 注册备案人住所	REGER_ADDR	VARCHAR	500	是
Property RegerAddr As %String(CAPTION = "注册备案人住所", MAXLEN = 500) [ SqlColumnNumber = 59, SqlFieldName = REGER_ADDR ];

/// 59 注册证有效期开始时间	REGCERT_EXPY_BEGNTIME	DATETIME	0	是
Property RegcertExpyBegntime As %String(CAPTION = "注册证有效期开始时间", MAXLEN = 30) [ SqlColumnNumber = 60, SqlFieldName = REGCERT_EXPY_BEGNTIME ];

/// 60 注册证有效期结束时间	REGCERT_EXPY_ENDTIME	DATETIME	0	是	
Property RegcertExpyEndtime As %String(CAPTION = "注册证有效期结束时间", MAXLEN = 30) [ SqlColumnNumber = 61, SqlFieldName = REGCERT_EXPY_ENDTIME ];

/// 61 生产企业代码	PRODENTP_CODE
Property ProdEntpCode As %String(CAPTION = "生产企业代码", MAXLEN = 50) [ SqlColumnNumber = 62, SqlFieldName = PRODENTP_CODE ];

/// 62 生产企业名称	PRODENTP_NAME	VARCHAR	200	否	
Property ProdEntpName As %String(CAPTION = "生产企业名称", MAXLEN = 200) [ SqlColumnNumber = 63, SqlFieldName = PRODENTP_NAME ];

/// 63 生产地址	MANU_ADDR	VARCHAR	2048	是	
Property ManuAddr As %String(CAPTION = "生产地址", MAXLEN = 2048) [ SqlColumnNumber = 64, SqlFieldName = MANU_ADDR ];

/// 64 代理人企业	AGNT_ENTP	VARCHAR	200	是
Property AgntEntp As %String(CAPTION = "代理人企业", MAXLEN = 200) [ SqlColumnNumber = 65, SqlFieldName = AGNT_ENTP ];

/// 65 代理人企业地址	AGNT_ENTP_ADDR	VARCHAR	200	是	
Property AgntEntpAddr As %String(CAPTION = "代理人企业地址", MAXLEN = 200) [ SqlColumnNumber = 66, SqlFieldName = AGNT_ENTP_ADDR ];

/// 66 生产国或地区	MANU_NAT_REGN	VARCHAR	200	是	
Property ManuNatRegn As %String(CAPTION = "生产国或地区", MAXLEN = 200) [ SqlColumnNumber = 67, SqlFieldName = MANU_NAT_REGN ];

/// 67 售后服务机构	AFTSAL_SERINS	VARCHAR	200	是	
Property AftsalSerins As %String(CAPTION = "售后服务机构", MAXLEN = 200) [ SqlColumnNumber = 68, SqlFieldName = AFTSAL_SERINS ];

/// 68 注册或备案证电子档案	REG_FIL_ELEC_FILE	VARCHAR	500	是	
Property RegFilElecFile As %String(CAPTION = "注册或备案证电子档案", MAXLEN = 200) [ SqlColumnNumber = 69, SqlFieldName = REG_FIL_ELEC_FILE ];

/// 69 产品影像	PROD_IMG	VARCHAR	500	是
Property ProdImg As %String(CAPTION = "产品影像", MAXLEN = 200) [ SqlColumnNumber = 70, SqlFieldName = PROD_IMG ];

/// 70 有效标志	VALI_FLAG	VARCHAR	3	是	
Property ValiFlag As %String(CAPTION = "有效标志", MAXLEN = 4) [ SqlColumnNumber = 71, SqlFieldName = VALI_FLAG ];

/// 71 数据唯一记录号	RID
Property Rid As %String(CAPTION = "数据唯一记录号", MAXLEN = 40) [ SqlColumnNumber = 72, SqlFieldName = RID ];

/// 72 版本号	VER	VARCHAR	20	否		
Property Ver As %String(CAPTION = "版本号", MAXLEN = 20) [ SqlColumnNumber = 73, SqlFieldName = VER ];

/// 73 版本名称	VER_NAME	VARCHAR	30	是	
Property VerName As %String(CAPTION = "版本名称", MAXLEN = 30) [ SqlColumnNumber = 74, SqlFieldName = VER_NAME ];

/// 74 HIS下载批次	BATCH	VARCHAR	30	否 210322162500001
Property HisBatch As %String(CAPTION = "HIS下载批次", MAXLEN = 30) [ SqlColumnNumber = 75, SqlFieldName = HIS_BATCH ];

/// 75 HIS创建人 CRTER	VARCHAR	30	否
Property HisCrterId As %String(CAPTION = "HIS创建人", MAXLEN = 30) [ SqlColumnNumber = 76, SqlFieldName = HIS_CRTER_ID ];

/// 76 HIS创建日期	CRTE_DATE	日期	
Property HisCrteDate As %Library.Date(CAPTION = "HIS创建日期") [ SqlColumnNumber = 77, SqlFieldName = HIS_CRTE_DATE ];

/// 77 HIS创建时间	CRTE_TIME	时间		
Property HisCrteTime As %Library.Time(CAPTION = "HIS创建时间") [ SqlColumnNumber = 78, SqlFieldName = HIS_CRTE_TIME ];

/// 78 HIS更新人ID	UPDT_ID			
Property HisUpdtId As %String(CAPTION = "HIS更新人ID", MAXLEN = 30) [ SqlColumnNumber = 79, SqlFieldName = HIS_UPDT_ID ];

/// 79 HIS更新日期	UPDT_DATE	日期		
Property HisUpdtDate As %Library.Date(CAPTION = "HIS更新日期") [ SqlColumnNumber = 80, SqlFieldName = HIS_UPDT_DATE ];

/// 80 HIS更新时间	HISUPDT_ITIME	时间
Property HisUpdtTime As %Library.Time(CAPTION = "HIS更新时间") [ SqlColumnNumber = 81, SqlFieldName = HIS_UPDT_TIME ];

/// 索引 HIS下载批次
Index IdxHISBATCH On (HospId As Exact, HisBatch As Exact);

/// 索引 HIS创建日期
Index IdxHISCRTEDATE On (HospId As Exact, HisCrteDate As Exact);

/// 索引HIS更新日期
Index IdxHISUPDTDATE On (HospId As Exact, HisUpdtDate As Exact);

/// 索引医疗目录编码
Index IdxMEDLISTCODG On (HospId As Exact, MedListCodg As Exact);

/// 索引耗材名称
Index IdxMCSNAME On (HospId As Exact, McsName As Exact);

Storage Default
{
<Data name="MEDMCSLISTDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HospId</Value>
</Value>
<Value name="3">
<Value>HiType</Value>
</Value>
<Value name="4">
<Value>MedListCodg</Value>
</Value>
<Value name="5">
<Value>McsName</Value>
</Value>
<Value name="6">
<Value>Udi</Value>
</Value>
<Value name="7">
<Value>HiGennameCode</Value>
</Value>
<Value name="8">
<Value>HiGenname</Value>
</Value>
<Value name="9">
<Value>ProdMol</Value>
</Value>
<Value name="10">
<Value>SpecCode</Value>
</Value>
<Value name="11">
<Value>Spec</Value>
</Value>
<Value name="12">
<Value>McsType</Value>
</Value>
<Value name="13">
<Value>SpecMol</Value>
</Value>
<Value name="14">
<Value>MatlCode</Value>
</Value>
<Value name="15">
<Value>MacMatl</Value>
</Value>
<Value name="16">
<Value>PacSpec</Value>
</Value>
<Value name="17">
<Value>PacCnt</Value>
</Value>
<Value name="18">
<Value>ProdPacmatl</Value>
</Value>
<Value name="19">
<Value>Pacunt</Value>
</Value>
<Value name="20">
<Value>ProdConvrat</Value>
</Value>
<Value name="21">
<Value>MinUseunt</Value>
</Value>
<Value name="22">
<Value>ProdplacType</Value>
</Value>
<Value name="23">
<Value>ProdplacTypeName</Value>
</Value>
<Value name="24">
<Value>PordStrd</Value>
</Value>
<Value name="25">
<Value>ProdExpy</Value>
</Value>
<Value name="26">
<Value>PerfStruComp</Value>
</Value>
<Value name="27">
<Value>ApbScp</Value>
</Value>
<Value name="28">
<Value>ProdIstr</Value>
</Value>
<Value name="29">
<Value>ProdImgNo</Value>
</Value>
<Value name="30">
<Value>ProdQltStd</Value>
</Value>
<Value name="31">
<Value>Manl</Value>
</Value>
<Value name="32">
<Value>OthCertMatl</Value>
</Value>
<Value name="33">
<Value>SpedFlag</Value>
</Value>
<Value name="34">
<Value>SpedName</Value>
</Value>
<Value name="35">
<Value>CombName</Value>
</Value>
<Value name="36">
<Value>CaseFalg</Value>
</Value>
<Value name="37">
<Value>LmtUsedFlag</Value>
</Value>
<Value name="38">
<Value>HiLmtScp</Value>
</Value>
<Value name="39">
<Value>MinSalunt</Value>
</Value>
<Value name="40">
<Value>HighvalMcsFlag</Value>
</Value>
<Value name="41">
<Value>MatlTypeCode</Value>
</Value>
<Value name="42">
<Value>ImptMatlHmorgnFlag</Value>
</Value>
<Value name="43">
<Value>StlzFlag</Value>
</Value>
<Value name="44">
<Value>StlzFlagName</Value>
</Value>
<Value name="45">
<Value>ImptItvtClssFlag</Value>
</Value>
<Value name="46">
<Value>ImptItvtClssName</Value>
</Value>
<Value name="47">
<Value>DspoUsedFlag</Value>
</Value>
<Value name="48">
<Value>DspoUsedFlagName</Value>
</Value>
<Value name="49">
<Value>RegerName</Value>
</Value>
<Value name="50">
<Value>BegnDate</Value>
</Value>
<Value name="51">
<Value>Enddate</Value>
</Value>
<Value name="52">
<Value>MedEquMgtType</Value>
</Value>
<Value name="53">
<Value>MedEquMgtTypeName</Value>
</Value>
<Value name="54">
<Value>RegFilNo</Value>
</Value>
<Value name="55">
<Value>RegFilProdName</Value>
</Value>
<Value name="56">
<Value>StruComp</Value>
</Value>
<Value name="57">
<Value>OthCont</Value>
</Value>
<Value name="58">
<Value>AprvDate</Value>
</Value>
<Value name="59">
<Value>RegerAddr</Value>
</Value>
<Value name="60">
<Value>RegcertExpyBegntime</Value>
</Value>
<Value name="61">
<Value>RegcertExpyEndtime</Value>
</Value>
<Value name="62">
<Value>ProdEntpCode</Value>
</Value>
<Value name="63">
<Value>ProdEntpName</Value>
</Value>
<Value name="64">
<Value>ManuAddr</Value>
</Value>
<Value name="65">
<Value>AgntEntp</Value>
</Value>
<Value name="66">
<Value>AgntEntpAddr</Value>
</Value>
<Value name="67">
<Value>ManuNatRegn</Value>
</Value>
<Value name="68">
<Value>AftsalSerins</Value>
</Value>
<Value name="69">
<Value>RegFilElecFile</Value>
</Value>
<Value name="70">
<Value>ProdImg</Value>
</Value>
<Value name="71">
<Value>ValiFlag</Value>
</Value>
<Value name="72">
<Value>Rid</Value>
</Value>
<Value name="73">
<Value>Ver</Value>
</Value>
<Value name="74">
<Value>VerName</Value>
</Value>
<Value name="75">
<Value>HisBatch</Value>
</Value>
<Value name="76">
<Value>HisCrterId</Value>
</Value>
<Value name="77">
<Value>HisCrteDate</Value>
</Value>
<Value name="78">
<Value>HisCrteTime</Value>
</Value>
<Value name="79">
<Value>HisUpdtId</Value>
</Value>
<Value name="80">
<Value>HisUpdtDate</Value>
</Value>
<Value name="81">
<Value>HisUpdtTime</Value>
</Value>
</Data>
<DataLocation>^CT.INSU.MI.MEDMCSLISTD</DataLocation>
<DefaultData>MEDMCSLISTDefaultData</DefaultData>
<IdLocation>^CT.INSU.MI.MEDMCSLISTD</IdLocation>
<IndexLocation>^CT.INSU.MI.MEDMCSLISTI</IndexLocation>
<StreamLocation>^CT.INSU.MI.MEDMCSLISTS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
