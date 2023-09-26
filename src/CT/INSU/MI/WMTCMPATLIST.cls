/// 1301 西药中成药目录表
Class CT.INSU.MI.WMTCMPATLIST Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = Rowid ]
{

/// 1医院ID	HOSP_ID	VARCHAR	30	否
Property HospId As %String(CAPTION = "医院ID", MAXLEN = 6) [ SqlColumnNumber = 2, SqlFieldName = HOSP_ID ];

/// 2医保类型	HI_TYPE	VARCHAR	30	否
Property HiType As %String(CAPTION = "医保类型", MAXLEN = 10) [ SqlColumnNumber = 3, SqlFieldName = HI_TYPE ];

/// 3医疗目录编码	MED_LIST_CODG	VARCHAR	50	是	
Property MedListCodg As %String(CAPTION = "医疗目录编码", MAXLEN = 50) [ SqlColumnNumber = 4, SqlFieldName = MED_LIST_CODG ];

/// 4药品商品名	DRUG_PRODNAME	VARCHAR	500	是		
Property DrugProdname As %String(CAPTION = "药品商品名", MAXLEN = 500) [ SqlColumnNumber = 5, SqlFieldName = DRUG_PRODNAME ];

/// 5通用名编码	GENNAME_CODG
Property GennamCodg As %String(CAPTION = "通用名编码", MAXLEN = 100) [ SqlColumnNumber = 6, SqlFieldName = GENNAME_CODG ];

/// 6药品通用名	DRUG_GENNAME	VARCHAR	500	是	
Property DrugGenname As %String(CAPTION = "药品通用名", MAXLEN = 20) [ SqlColumnNumber = 7, SqlFieldName = DRUG_GENNAME ];

/// 7化学名称	CHEMNAME	VARCHAR	100	否	
Property Chemname As %String(CAPTION = "化学名称", MAXLEN = 100) [ SqlColumnNumber = 8, SqlFieldName = CHEMNAME ];

/// 8别名	ALIS	VARCHAR	100	是
Property Alis As %String(CAPTION = "别名", MAXLEN = 100) [ SqlColumnNumber = 9, SqlFieldName = ALIS ];

/// 9英文名称	ENG_NAME	VARCHAR	255	是	
Property EngName As %String(CAPTION = "英文名称", MAXLEN = 255) [ SqlColumnNumber = 10, SqlFieldName = ENG_NAME ];

/// 10注册名称	REG_NAME	VARCHAR	500	是		
Property RegName As %String(CAPTION = "注册名称", MAXLEN = 200) [ SqlColumnNumber = 11, SqlFieldName = REG_NAME ];

/// 11药监本位码	DRUGSTDCODE
Property Drugstdcode As %String(CAPTION = "药监本位码", MAXLEN = 200) [ SqlColumnNumber = 12, SqlFieldName = DRUGSTDCODE ];

/// 12药品剂型	DRUG_DOSFORM	VARCHAR	50	否		
Property DrugDosform As %String(CAPTION = "药品剂型", MAXLEN = 50) [ SqlColumnNumber = 13, SqlFieldName = DRUG_DOSFORM ];

/// 13药品剂型名称	DRUG_DOSFORM_NAME	VARCHAR	50	是		
Property DrugDosformName As %String(CAPTION = "药品剂型名称", MAXLEN = 50) [ SqlColumnNumber = 14, SqlFieldName = DRUG_DOSFORM_NAME ];

/// 14药品类别	DRUG_TYPE	VARCHAR	10	是	
Property DrugType As %String(CAPTION = "药品类别", MAXLEN = 10) [ SqlColumnNumber = 15, SqlFieldName = DRUG_TYPE ];

/// 15药品类别名称	DRUG_TYPE_NAME	VARCHAR	500	是
Property DrugTypeName As %String(CAPTION = "药品类别名称", MAXLEN = 200) [ SqlColumnNumber = 16, SqlFieldName = DRUG_TYPE_NAME ];

/// 16药品规格	DRUG_SPEC	VARCHAR	255	是	
Property DrugSpec As %String(CAPTION = "医院ID", MAXLEN = 255) [ SqlColumnNumber = 17, SqlFieldName = DRUG_SPEC ];

/// 17药品规格代码	DRUG_SPEC_CODE	VARCHAR	50	是	
Property DrugSpecCode As %String(CAPTION = "药品规格代码", MAXLEN = 50) [ SqlColumnNumber = 18, SqlFieldName = DRUG_SPEC_CODE ];

/// 18注册剂型	REG_DOSFORM	VARCHAR	500	否		
Property RegDosform As %String(CAPTION = "注册剂型", MAXLEN = 50) [ SqlColumnNumber = 19, SqlFieldName = REG_DOSFORM ];

/// 19注册规格	REG_SPEC	VARCHAR	500	是		
Property RegSpec As %String(CAPTION = "注册规格", MAXLEN = 200) [ SqlColumnNumber = 20, SqlFieldName = REG_SPEC ];

/// 20注册规格代码	REG_SPEC_CODE	VARCHAR	50	是	
Property RegSpecCode As %String(CAPTION = "注册规格代码", MAXLEN = 50) [ SqlColumnNumber = 21, SqlFieldName = REG_SPEC_CODE ];

/// 21每次用量	EACH_DOS	LONGTEXT	0	是	
Property EachDos As %String(CAPTION = "每次用量", MAXLEN = 50) [ SqlColumnNumber = 22, SqlFieldName = EACH_DOS ];

/// 22使用频次	USED_FRQU	VARCHAR	30	是	
Property UsedFrqu As %String(CAPTION = "使用频次", MAXLEN = 30) [ SqlColumnNumber = 23, SqlFieldName = USED_FRQU ];

/// 23酸根盐基	ACDBAS	VARCHAR	50	是		
Property Acdbas As %String(CAPTION = "酸根盐基", MAXLEN = 50) [ SqlColumnNumber = 24, SqlFieldName = ACDBAS ];

/// 24国家药品编号	NAT_DRUG_NO	VARCHAR	20	是	
Property NatDrugNo As %String(CAPTION = "国家药品编号", MAXLEN = 20) [ SqlColumnNumber = 25, SqlFieldName = NAT_DRUG_NO ];

/// 25用法	USED_MTD
Property UsedMtd As %String(CAPTION = "用法", MAXLEN = 20) [ SqlColumnNumber = 26, SqlFieldName = USED_MTD ];

/// 26中成药标志	TCMPAT_FLAG	VARCHAR	3	是	
Property TcmpatFlag As %String(CAPTION = "中成药标志", MAXLEN = 4) [ SqlColumnNumber = 27, SqlFieldName = TCMPAT_FLAG ];

/// 27生产地类别	PRODPLAC_TYPE	VARCHAR	6	是	
Property ProdplacType As %String(CAPTION = "生产地类别", MAXLEN = 6) [ SqlColumnNumber = 28, SqlFieldName = PRODPLAC_TYPE ];

/// 28生产地类别名称	PRODPLAC_TYPE_NAME	VARCHAR	50	是	
Property ProdplacTypeName As %String(CAPTION = "生产地类别名称", MAXLEN = 50) [ SqlColumnNumber = 29, SqlFieldName = PRODPLAC_TYPE_NAME ];

/// 29计价单位类型	PRCUNT_TYPE	VARCHAR	3	是	
Property PrcuntType As %String(CAPTION = "计价单位类型", MAXLEN = 4) [ SqlColumnNumber = 30, SqlFieldName = PRCUNT_TYPE ];

/// 30非处方药标志	OTC_FLAG	VARCHAR	3	是	
Property OtcFlag As %String(CAPTION = "非处方药标志", MAXLEN = 4) [ SqlColumnNumber = 31, SqlFieldName = OTC_FLAG ];

/// 31非处方药标志名称	OTC_FLAG_NAME	VARCHAR	3	是	
Property OtcFlagName As %String(CAPTION = "非处方药标志名称", MAXLEN = 4) [ SqlColumnNumber = 32, SqlFieldName = OTC_FLAG_NAME ];

/// 32包装材质	PACMATL	VARCHAR	500	是	
Property Pacmatl As %String(CAPTION = "包装材质", MAXLEN = 500) [ SqlColumnNumber = 33, SqlFieldName = PACMATL ];

/// 33包装材质名称	PACMATL_NAME	VARCHAR	500	否	
Property PacmatlName As %String(CAPTION = "包装材质名称", MAXLEN = 500) [ SqlColumnNumber = 34, SqlFieldName = PACMATL_NAME ];

/// 34包装规格	PACSPEC	VARCHAR	100	是	
Property PacSpec As %String(CAPTION = "包装规格", MAXLEN = 100) [ SqlColumnNumber = 35, SqlFieldName = PACSPEC ];

/// 35包装数量	PAC_CNT	VARCHAR	20	是	
Property PacCnt As %String(CAPTION = "包装数量", MAXLEN = 20) [ SqlColumnNumber = 36, SqlFieldName = PAC_CNT ];

/// 36功能主治	EFCC_ATD	TEXT	0	是		
Property EfccAtd As %String(CAPTION = "功能主治", MAXLEN = 1000) [ SqlColumnNumber = 37, SqlFieldName = EFCC_ATD ];

/// 37给药途径	RUTE	VARCHAR	30	是	
Property Rute As %String(CAPTION = "给药途径", MAXLEN = 30) [ SqlColumnNumber = 38, SqlFieldName = RUTE ];

/// 38说明书	MANL	VARCHAR	2000	是	
Property Manl As %String(CAPTION = "说明书", MAXLEN = 2000) [ SqlColumnNumber = 39, SqlFieldName = MANL ];

/// 39开始日期	BEGNDATE	DATE	0	是	
Property Begndate As %String(CAPTION = "开始日期", MAXLEN = 20) [ SqlColumnNumber = 40, SqlFieldName = BEGNDATE ];

/// 40结束日期	ENDDATE	DATE	0	否		
Property Enddate As %String(CAPTION = "结束日期", MAXLEN = 20) [ SqlColumnNumber = 41, SqlFieldName = ENDDATE ];

/// 41最小使用单位	MIN_USEUNT	VARCHAR	30	是	
Property MinUseunt As %String(CAPTION = "最小使用单位", MAXLEN = 30) [ SqlColumnNumber = 42, SqlFieldName = MINUSEUNT ];

/// 42最小销售单位	MIN_SALUNT	VARCHAR	30	是	
Property MinSalUnt As %String(CAPTION = "最小销售单位", MAXLEN = 30) [ SqlColumnNumber = 43, SqlFieldName = MINSALUNT ];

/// 43最小计量单位	MIN_UNT	VARCHAR	30	是	
Property MinUnt As %String(CAPTION = "最小计量单位", MAXLEN = 30) [ SqlColumnNumber = 44, SqlFieldName = MIN_UNT ];

/// 44最小包装数量	MIN_PAC_CNT	INT	0	是	
Property MinPacCnt As %String(CAPTION = "最小包装数量", MAXLEN = 20) [ SqlColumnNumber = 45, SqlFieldName = MIN_PAC_CNT ];

/// 45最小包装单位	MIN_PACUNT	VARCHAR	30	是	
Property MinPacunt As %String(CAPTION = "最小包装单位", MAXLEN = 30) [ SqlColumnNumber = 46, SqlFieldName = MIN_PACUNT ];

/// 46最小制剂单位	MIN_PREPUNT	VARCHAR	30	是	
Property MinPrepunt As %String(CAPTION = "最小制剂单位", MAXLEN = 30) [ SqlColumnNumber = 47, SqlFieldName = MIN_PREPUNT ];

/// 47最小包装单位名称	MINPACUNT_NAME	VARCHAR	50	否		
Property MinpacuntName As %String(CAPTION = "最小包装单位名称", MAXLEN = 50) [ SqlColumnNumber = 48, SqlFieldName = MINPACUNT_NAME ];

/// 48最小制剂单位名称	MIN_PREPUNT_NAME	VARCHAR	50	是		
Property MinPrepuntName As %String(CAPTION = "最小制剂单位名称", MAXLEN = 50) [ SqlColumnNumber = 49, SqlFieldName = MIN_PREPUNT_NAME ];

/// 49转换比	CONVRAT	INT	0	是	
Property Convrat As %String(CAPTION = "转换比", MAXLEN = 30) [ SqlColumnNumber = 50, SqlFieldName = CONVRAT ];

/// 50药品有效期	DRUG_EXPY	VARCHAR	255	是	
Property DrugExpy As %String(CAPTION = "药品有效期", MAXLEN = 20) [ SqlColumnNumber = 51, SqlFieldName = DRUG_EXPY ];

/// 51最小计价单位	MIN_PRCUNT	VARCHAR	50	是	
Property MinPrcunt As %String(CAPTION = "最小计价单位", MAXLEN = 50) [ SqlColumnNumber = 52, SqlFieldName = MIN_PRCUNT ];

/// 52五笔助记码	WUBI	VARCHAR	50	是	
Property Wubi As %String(CAPTION = "五笔助记码", MAXLEN = 30) [ SqlColumnNumber = 53, SqlFieldName = WUBI ];

/// 53拼音助记码	PINYIN	VARCHAR	300	是		
Property Pinyin As %String(CAPTION = "拼音助记码", MAXLEN = 30) [ SqlColumnNumber = 54, SqlFieldName = PINYIN ];

/// 54分包装厂家	SUBPCK_FCTY	VARCHAR	500	是	
Property SubpckFcty As %String(CAPTION = "分包装厂家", MAXLEN = 500) [ SqlColumnNumber = 55, SqlFieldName = SUBPCK_FCTY ];

/// 55生产企业代码	PRODENTP_CODE
Property ProdentpCode As %String(CAPTION = "生产企业代码", MAXLEN = 500) [ SqlColumnNumber = 56, SqlFieldName = PRODENTP_CODE ];

/// 56生产企业名称	PRODENTP_NAME	VARCHAR	200	否		
Property ProdentpName As %String(CAPTION = "生产企业名称", MAXLEN = 200) [ SqlColumnNumber = 57, SqlFieldName = PRODENTP_NAME ];

/// 57特殊限价药品标志	SP_LMTPRIC_DRUG_FLAG	VARCHAR	3	是	
Property SpLmtpricDrugFlag As %String(CAPTION = "特殊限价药品标志", MAXLEN = 4) [ SqlColumnNumber = 58, SqlFieldName = SP_LMTPRIC_DRUG_FLAG ];

/// 58特殊药品标志	SP_DRUG_FLAG	VARCHAR	3	是		
Property SpDrugFlag As %String(CAPTION = "特殊药品标志", MAXLEN = 4) [ SqlColumnNumber = 59, SqlFieldName = SP_DRUG_FLAG ];

/// 59限制使用范围	LMT_USESCP	VARCHAR	500	是		
Property LmtUsescp As %String(CAPTION = "限制使用范围", MAXLEN = 500) [ SqlColumnNumber = 60, SqlFieldName = LMT_USESCP ];

/// 60限制使用标志	LMT_USED_FLAG	VARCHAR	3	是		
Property LmtUsedFlag As %String(CAPTION = "限制使用标志", MAXLEN = 4) [ SqlColumnNumber = 61, SqlFieldName = LMT_USED_FLAG ];

/// 61药品注册证号	DRUG_REGNO
Property DrugRegno As %String(CAPTION = "药品注册证号", MAXLEN = 200) [ SqlColumnNumber = 62, SqlFieldName = DRUG_REGNO ];

/// 62药品注册证号开始日期	DRUG_REGCERT_BEGNDATE	DATE	0	是	
Property DrugRegcertBegndate As %String(CAPTION = "药品注册证号开始日期", MAXLEN = 20) [ SqlColumnNumber = 63, SqlFieldName = DRUG_REGCERT_BEGNDATE ];

/// 63药品注册证号结束日期	DRUG_REGCERT_ENDDATE	DATE	0	是	
Property DrugRegcertEnddate As %String(CAPTION = "药品注册证号结束日期", MAXLEN = 20) [ SqlColumnNumber = 64, SqlFieldName = DRUG_REGCERT_ENDDATE ];

/// 64批准文号	APRVNO	VARCHAR	100	否	
Property Aprvno As %String(CAPTION = "批准文号", MAXLEN = 100) [ SqlColumnNumber = 65, SqlFieldName = APRVNO ];

/// 65批准文号开始日期	APRVNO_BEGNDATE	DATE	0	是	
Property AprvnoBegndate As %String(CAPTION = "批准文号开始日期", MAXLEN = 20) [ SqlColumnNumber = 66, SqlFieldName = APRVNO_BEGNDATE ];

/// 66批准文号结束日期	APRVNO_ENDDATE	DATE	0	是		
Property AprvnoEnddate As %String(CAPTION = "批准文号结束日期", MAXLEN = 20) [ SqlColumnNumber = 67, SqlFieldName = APRVNO_ENDDATE ];

/// 67市场状态	MKT_STAS	VARCHAR	3	是	
Property MktStas As %String(CAPTION = "市场状态", MAXLEN = 4) [ SqlColumnNumber = 68, SqlFieldName = MKT_STAS ];

/// 68市场状态名称	MKT_STAS_NAME	VARCHAR	500	是	
Property MktStasName As %String(CAPTION = "市场状态名称", MAXLEN = 500) [ SqlColumnNumber = 69, SqlFieldName = MKT_STAS_NAME ];

/// 69药品注册批件电子档案	DRUG_REG_APPVLETR_ELECACS	VARCHAR	500	是	
Property DrugRegAppvletrElecacs As %String(CAPTION = "药品注册批件电子档案", MAXLEN = 200) [ SqlColumnNumber = 70, SqlFieldName = DRUG_REG_APPVLETR_ELECACS ];

/// 70药品补充申请批件电子档案	SPLM_APPY_APPVLETR_FILE	VARCHAR	500	是	
Property SplmAppyAppvketrFile As %String(CAPTION = "药品补充申请批件电子档案", MAXLEN = 200) [ SqlColumnNumber = 71, SqlFieldName = SPLM_APPY_APPVLETR_FILE ];

/// 71国家医保药品目录备注	NAT_HI_DRUGLIST_MEMO	VARCHAR	500	是	
Property NatHiDruglistMemo As %String(CAPTION = "国家医保药品目录备注", MAXLEN = 500) [ SqlColumnNumber = 72, SqlFieldName = NAT_HI_DRUGLIST_MEMO ];

/// 72基本药物标志名称	BAS_MEDN_FLAG_NAME	VARCHAR	3	是	
Property BasMednFlagName As %String(CAPTION = "基本药物标志名称", MAXLEN = 4) [ SqlColumnNumber = 73, SqlFieldName = BAS_MEDN_FLAG_NAME ];

/// 73基本药物标志	BAS_MEDN_FLAG	VARCHAR	3	是		
Property BasMednFlag As %String(CAPTION = "基本药物标志", MAXLEN = 4) [ SqlColumnNumber = 74, SqlFieldName = BAS_MEDN_FLAG ];

/// 74增值税调整药品标志	ADVALTAX_ADJM_DRUG_FLAG	VARCHAR	3	是	
Property AdvaltaxAdjmDrugFlag As %String(CAPTION = "增值税调整药品标志", MAXLEN = 4) [ SqlColumnNumber = 75, SqlFieldName = ADVALTAX_ADJM_DRUG_FLAG ];

/// 75增值税调整药品名称	ADVALTAX_ADJM_DRUG_NAME	VARCHAR	3	是		
Property AdvaltaxAdjmDrugName As %String(CAPTION = "增值税调整药品名称", MAXLEN = 4) [ SqlColumnNumber = 76, SqlFieldName = ADVALTAX_ADJM_DRUG_NAME ];

/// 76上市药品目录集药品	LSTD_DRUGLIST_DRUG	VARCHAR	10	是	
Property LstdDruglistDrug As %String(CAPTION = "上市药品目录集药品", MAXLEN = 10) [ SqlColumnNumber = 77, SqlFieldName = LSTD_DRUGLIST_DRUG ];

/// 77医保谈判药品标志	HI_NEGO_DRUG_FLAG	VARCHAR	3	是	
Property HiNegoDrugFlag As %String(CAPTION = "医保谈判药品标志", MAXLEN = 4) [ SqlColumnNumber = 78, SqlFieldName = HI_NEGO_DRUG_FLAG ];

/// 78医保谈判药品名称	HI_NEGO_DRUG_NAME	VARCHAR	3	是		
Property HiNegoDrugName As %String(CAPTION = "医保谈判药品名称", MAXLEN = 4) [ SqlColumnNumber = 79, SqlFieldName = HI_NEGO_DRUG_NAME ];

/// 79卫健委药品编码	NHC_DRUG_CODG	VARCHAR	50	是	
Property NhcDrugCodg As %String(CAPTION = "卫健委药品编码", MAXLEN = 50) [ SqlColumnNumber = 80, SqlFieldName = NHC_DRUG_CODG ];

/// 80备注	MEMO	LONGTEXT	0	是		
Property Memo As %String(CAPTION = "备注", MAXLEN = 500) [ SqlColumnNumber = 81, SqlFieldName = MEMO ];

/// 81有效标志	VALI_FLAG	VARCHAR	3	是		
Property ValiFlag As %String(CAPTION = "ValiFlag", MAXLEN = 4) [ SqlColumnNumber = 82, SqlFieldName = VALI_FLAG ];

/// 82数据唯一记录号	RID
Property Rid As %String(CAPTION = "数据唯一记录号", MAXLEN = 40) [ SqlColumnNumber = 83, SqlFieldName = RID ];

/// 83数据创建时间	CRTE_TIME	DATETIME	0	否	
Property CrteTime As %String(CAPTION = "数据创建时间", MAXLEN = 30) [ SqlColumnNumber = 84, SqlFieldName = CRTE_TIME ];

/// 84数据更新时间	UPDT_TIME	DATETIME	0	否		
Property UpdtTime As %String(CAPTION = "数据更新时间", MAXLEN = 30) [ SqlColumnNumber = 85, SqlFieldName = UPDT_TIME ];

/// 85版本号	VER	VARCHAR	20	否	
Property Ver As %String(CAPTION = "版本号", MAXLEN = 20) [ SqlColumnNumber = 86, SqlFieldName = VER ];

/// 86版本名称	VER_NAME	VARCHAR	30	是	
Property VerName As %String(CAPTION = "版本名称", MAXLEN = 30) [ SqlColumnNumber = 87, SqlFieldName = VER_NAME ];

/// 87儿童用药	CHLD_MEDC	LONGTEXT	0	是	
Property ChldMedc As %String(CAPTION = "儿童用药", MAXLEN = 200) [ SqlColumnNumber = 88, SqlFieldName = CHLD_MEDC ];

/// 88公司名称	CO_NAME	VARCHAR	255	是	
Property CoName As %String(CAPTION = "公司名称", MAXLEN = 255) [ SqlColumnNumber = 89, SqlFieldName = CO_NAME ];

/// 89仿制药一致性评价药品	CONSEVAL_DRUG	VARCHAR	6	是	
Property ConsevalDrug As %String(CAPTION = "仿制药一致性评价药品", MAXLEN = 6) [ SqlColumnNumber = 90, SqlFieldName = CONSEVAL_DRUG ];

/// 90经销企业	DSTR	VARCHAR	255	是	
Property Dstr As %String(CAPTION = "经销企业", MAXLEN = 255) [ SqlColumnNumber = 91, SqlFieldName = DSTR ];

/// 91经销企业联系人	DSTR_CONER	VARCHAR	128	是		
Property DstrConer As %String(CAPTION = "经销企业联系人", MAXLEN = 128) [ SqlColumnNumber = 92, SqlFieldName = DSTR_CONER ];

/// 92经销企业授权书电子档案	DSTR_AUTH_FILE_ELECACS	VARCHAR	500	是	
Property DstrAuthFileElecacs As %String(CAPTION = "经销企业授权书电子档案", MAXLEN = 200) [ SqlColumnNumber = 93, SqlFieldName = DSTR_AUTH_FILE_ELECACS ];

/// 93国家医保药品目录剂型	NAT_HI_DRUGLIST_DOSFORM	VARCHAR	255	是		
Property NatHiDruglistDosform As %String(CAPTION = "国家医保药品目录剂型", MAXLEN = 255) [ SqlColumnNumber = 94, SqlFieldName = NAT_HI_DRUGLIST_DOSFORM ];

/// 94国家医保药品目录甲乙类标识	NAT_HI_DRUGLIST_CHRGITM_LV	VARCHAR	10	是	
Property NatHiDruglistChrgitmLv As %String(CAPTION = "国家医保药品目录甲乙类标识", MAXLEN = 10) [ SqlColumnNumber = 95, SqlFieldName = NAT_HI_DRUGLIST_CHRGITM_LV ];

/// 95HIS下载批次	BATCH	VARCHAR	30	否 210322162500001
Property HisBatch As %String(CAPTION = "HIS下载批次", MAXLEN = 100) [ SqlColumnNumber = 96, SqlFieldName = HIS_BATCH ];

/// 96HIS创建人 CRTER	VARCHAR	30	否
Property HisCrterId As %String(CAPTION = "HIS创建人", MAXLEN = 30) [ SqlColumnNumber = 97, SqlFieldName = HIS_CRTER_ID ];

/// 97HIS创建日期	CRTE_DATE	日期	
Property HisCrteDate As %Library.Date(CAPTION = "HIS创建日期") [ SqlColumnNumber = 98, SqlFieldName = HIS_CRTE_DATE ];

/// 98HIS创建时间	CRTE_TIME	时间		
Property HisCrteTime As %Library.Time(CAPTION = "HIS创建时间") [ SqlColumnNumber = 99, SqlFieldName = HIS_CRTE_TIME ];

/// 99HIS更新人ID	UPDT_ID			
Property HisUpdtId As %String(CAPTION = "HIS更新人ID", MAXLEN = 30) [ SqlColumnNumber = 100, SqlFieldName = HIS_UPDT_ID ];

/// 100HIS更新日期	UPDT_DATE	日期		
Property HisUpdtDate As %Library.Date(CAPTION = "HIS更新日期") [ SqlColumnNumber = 101, SqlFieldName = HIS_UPDT_DATE ];

/// 101HIS更新时间	HISUPDT_ITIME	时间
Property HisUpdtTime As %Library.Time(CAPTION = "HIS更新时间") [ SqlColumnNumber = 102, SqlFieldName = HIS_UPDT_TIME ];

/// 索引 HIS下载批次
Index IdxHISBATCH On (HospId As Exact, HisBatch As Exact);

/// 索引 HIS创建日期
Index IdxHISCRTEDATE On (HospId As Exact, HisCrteDate As Exact);

/// 索引HIS更新日期
Index IdxHISUPDTDATE On (HospId As Exact, HisUpdtDate As Exact);

/// 索引医疗目录编码
Index IdxMEDLISTCODG On (HospId As Exact, MedListCodg As Exact);

/// 索引药品商品名	DRUG_PRODNAME
Index IdxDRUGPRODNAME On (HospId As Exact, DrugProdname As Exact);

/// 索引 批准文号	APRVNO
Index IdxAPRVNO On (HospId As Exact, Aprvno As Exact);

/// 索引 注册名称	REG_NAME
Index IdxREGNAME On (HospId As Exact, RegName As Exact);

/// 索引 药品本位码	DRUGSTDCODE
Index IdxDRUGSTDCODE On (HospId As Exact, Drugstdcode As Exact);

/// 索引 生产企业代码	PRODENTP_CODE
Index IdxPRODENTPCODE On (HospId As Exact, ProdentpCode As Exact);

Storage Default
{
<Data name="WMTCMPATLISTDefaultData">
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
<Value>DrugProdname</Value>
</Value>
<Value name="6">
<Value>GennamCodg</Value>
</Value>
<Value name="7">
<Value>DrugGenname</Value>
</Value>
<Value name="8">
<Value>Chemname</Value>
</Value>
<Value name="9">
<Value>Alis</Value>
</Value>
<Value name="10">
<Value>EngName</Value>
</Value>
<Value name="11">
<Value>RegName</Value>
</Value>
<Value name="12">
<Value>Drugstdcode</Value>
</Value>
<Value name="13">
<Value>DrugDosform</Value>
</Value>
<Value name="14">
<Value>DrugDosformName</Value>
</Value>
<Value name="15">
<Value>DrugType</Value>
</Value>
<Value name="16">
<Value>DrugTypeName</Value>
</Value>
<Value name="17">
<Value>DrugSpec</Value>
</Value>
<Value name="18">
<Value>DrugSpecCode</Value>
</Value>
<Value name="19">
<Value>RegDosform</Value>
</Value>
<Value name="20">
<Value>RegSpec</Value>
</Value>
<Value name="21">
<Value>RegSpecCode</Value>
</Value>
<Value name="22">
<Value>EachDos</Value>
</Value>
<Value name="23">
<Value>UsedFrqu</Value>
</Value>
<Value name="24">
<Value>Acdbas</Value>
</Value>
<Value name="25">
<Value>NatDrugNo</Value>
</Value>
<Value name="26">
<Value>UsedMtd</Value>
</Value>
<Value name="27">
<Value>TcmpatFlag</Value>
</Value>
<Value name="28">
<Value>ProdplacType</Value>
</Value>
<Value name="29">
<Value>ProdplacTypeName</Value>
</Value>
<Value name="30">
<Value>PrcuntType</Value>
</Value>
<Value name="31">
<Value>OtcFlag</Value>
</Value>
<Value name="32">
<Value>OtcFlagName</Value>
</Value>
<Value name="33">
<Value>Pacmatl</Value>
</Value>
<Value name="34">
<Value>PacmatlName</Value>
</Value>
<Value name="35">
<Value>PacSpec</Value>
</Value>
<Value name="36">
<Value>PacCnt</Value>
</Value>
<Value name="37">
<Value>EfccAtd</Value>
</Value>
<Value name="38">
<Value>Rute</Value>
</Value>
<Value name="39">
<Value>Manl</Value>
</Value>
<Value name="40">
<Value>Begndate</Value>
</Value>
<Value name="41">
<Value>Enddate</Value>
</Value>
<Value name="42">
<Value>MinUseunt</Value>
</Value>
<Value name="43">
<Value>MinSalUnt</Value>
</Value>
<Value name="44">
<Value>MinUnt</Value>
</Value>
<Value name="45">
<Value>MinPacCnt</Value>
</Value>
<Value name="46">
<Value>MinPacunt</Value>
</Value>
<Value name="47">
<Value>MinPrepunt</Value>
</Value>
<Value name="48">
<Value>MinpacuntName</Value>
</Value>
<Value name="49">
<Value>MinPrepuntName</Value>
</Value>
<Value name="50">
<Value>Convrat</Value>
</Value>
<Value name="51">
<Value>DrugExpy</Value>
</Value>
<Value name="52">
<Value>MinPrcunt</Value>
</Value>
<Value name="53">
<Value>Wubi</Value>
</Value>
<Value name="54">
<Value>Pinyin</Value>
</Value>
<Value name="55">
<Value>SubpckFcty</Value>
</Value>
<Value name="56">
<Value>ProdentpCode</Value>
</Value>
<Value name="57">
<Value>ProdentpName</Value>
</Value>
<Value name="58">
<Value>SpLmtpricDrugFlag</Value>
</Value>
<Value name="59">
<Value>SpDrugFlag</Value>
</Value>
<Value name="60">
<Value>LmtUsescp</Value>
</Value>
<Value name="61">
<Value>LmtUsedFlag</Value>
</Value>
<Value name="62">
<Value>DrugRegno</Value>
</Value>
<Value name="63">
<Value>DrugRegcertBegndate</Value>
</Value>
<Value name="64">
<Value>DrugRegcertEnddate</Value>
</Value>
<Value name="65">
<Value>Aprvno</Value>
</Value>
<Value name="66">
<Value>AprvnoBegndate</Value>
</Value>
<Value name="67">
<Value>AprvnoEnddate</Value>
</Value>
<Value name="68">
<Value>MktStas</Value>
</Value>
<Value name="69">
<Value>MktStasName</Value>
</Value>
<Value name="70">
<Value>DrugRegAppvletrElecacs</Value>
</Value>
<Value name="71">
<Value>SplmAppyAppvketrFile</Value>
</Value>
<Value name="72">
<Value>NatHiDruglistMemo</Value>
</Value>
<Value name="73">
<Value>BasMednFlagName</Value>
</Value>
<Value name="74">
<Value>BasMednFlag</Value>
</Value>
<Value name="75">
<Value>AdvaltaxAdjmDrugFlag</Value>
</Value>
<Value name="76">
<Value>AdvaltaxAdjmDrugName</Value>
</Value>
<Value name="77">
<Value>LstdDruglistDrug</Value>
</Value>
<Value name="78">
<Value>HiNegoDrugFlag</Value>
</Value>
<Value name="79">
<Value>HiNegoDrugName</Value>
</Value>
<Value name="80">
<Value>NhcDrugCodg</Value>
</Value>
<Value name="81">
<Value>Memo</Value>
</Value>
<Value name="82">
<Value>ValiFlag</Value>
</Value>
<Value name="83">
<Value>Rid</Value>
</Value>
<Value name="84">
<Value>CrteTime</Value>
</Value>
<Value name="85">
<Value>UpdtTime</Value>
</Value>
<Value name="86">
<Value>Ver</Value>
</Value>
<Value name="87">
<Value>VerName</Value>
</Value>
<Value name="88">
<Value>ChldMedc</Value>
</Value>
<Value name="89">
<Value>CoName</Value>
</Value>
<Value name="90">
<Value>ConsevalDrug</Value>
</Value>
<Value name="91">
<Value>Dstr</Value>
</Value>
<Value name="92">
<Value>DstrConer</Value>
</Value>
<Value name="93">
<Value>DstrAuthFileElecacs</Value>
</Value>
<Value name="94">
<Value>NatHiDruglistDosform</Value>
</Value>
<Value name="95">
<Value>NatHiDruglistChrgitmLv</Value>
</Value>
<Value name="96">
<Value>HisBatch</Value>
</Value>
<Value name="97">
<Value>HisCrterId</Value>
</Value>
<Value name="98">
<Value>HisCrteDate</Value>
</Value>
<Value name="99">
<Value>HisCrteTime</Value>
</Value>
<Value name="100">
<Value>HisUpdtId</Value>
</Value>
<Value name="101">
<Value>HisUpdtDate</Value>
</Value>
<Value name="102">
<Value>HisUpdtTime</Value>
</Value>
</Data>
<DataLocation>^CT.INSU.MI.WMTCMPATLISTD</DataLocation>
<DefaultData>WMTCMPATLISTDefaultData</DefaultData>
<IdLocation>^CT.INSU.MI.WMTCMPATLISTD</IdLocation>
<IndexLocation>^CT.INSU.MI.WMTCMPATLISTI</IndexLocation>
<StreamLocation>^CT.INSU.MI.WMTCMPATLISTS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
