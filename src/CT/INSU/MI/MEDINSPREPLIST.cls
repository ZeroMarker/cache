/// 1303 医疗机构制剂目录下载
Class CT.INSU.MI.MEDINSPREPLIST Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = Rowid ]
{

/// 1 医院ID	HOSP_ID	VARCHAR	30	否
Property HospId As %String(CAPTION = "医院ID", MAXLEN = 6) [ SqlColumnNumber = 2, SqlFieldName = HOSP_ID ];

/// 2 医保类型	HI_TYPE	VARCHAR	30	否
Property HiType As %String(CAPTION = "医保类型", MAXLEN = 10) [ SqlColumnNumber = 3, SqlFieldName = HI_TYPE ];

/// 3 医疗目录编码	MED_LIST_CODG	VARCHAR	50	是
Property MedListCodg As %String(CAPTION = "医疗目录编码", MAXLEN = 50) [ SqlColumnNumber = 4, SqlFieldName = MED_LIST_CODG ];

/// 4 药品商品名	DRUG_PRODNAME	VARCHAR	500	是	
Property DrugProdname As %String(CAPTION = "药品商品名", MAXLEN = 500) [ SqlColumnNumber = 5, SqlFieldName = DRUG_PRODNAME ];

/// 5 别名	ALIS	VARCHAR	100	是	
Property Alis As %String(CAPTION = "别名", MAXLEN = 100) [ SqlColumnNumber = 6, SqlFieldName = ALIS ];

/// 6 英文名称	ENG_NAME	VARCHAR	255	是	
Property EngName As %String(CAPTION = "英文名称", MAXLEN = 255) [ SqlColumnNumber = 7, SqlFieldName = ENG_NAME ];

/// 7 剂型	DOSFORM	VARCHAR	255	是		
Property Dosform As %String(CAPTION = "剂型", MAXLEN = 255) [ SqlColumnNumber = 8, SqlFieldName = DOSFORM ];

/// 8 剂型名称	DOSFORM_NAME	VARCHAR	200	是		
Property DosFormName As %String(CAPTION = "剂型名称", MAXLEN = 200) [ SqlColumnNumber = 9, SqlFieldName = DOSFORM_NAME ];

/// 9 注册剂型	REG_DOSFORM	VARCHAR	500	否		
Property RegDosform As %String(CAPTION = "注册剂型", MAXLEN = 500) [ SqlColumnNumber = 10, SqlFieldName = REG_DOSFORM ];

/// 10 成分	ING	VARCHAR	500	是	
Property Ing As %String(CAPTION = "成分", MAXLEN = 500) [ SqlColumnNumber = 11, SqlFieldName = ING ];

/// 11 功能主治	EFCC_ATD	TEXT	0	是		
Property EfccAtd As %String(CAPTION = "功能主治", MAXLEN = 500) [ SqlColumnNumber = 12, SqlFieldName = EFCC_ATD ];

/// 12 性状	CHRT	VARCHAR	500	否		
Property Chrt As %String(CAPTION = "性状", MAXLEN = 500) [ SqlColumnNumber = 13, SqlFieldName = CHRT ];

/// 13 药品规格	DRUG_SPEC	VARCHAR	255	是		
Property DrugSpec As %String(CAPTION = "药品规格", MAXLEN = 255) [ SqlColumnNumber = 14, SqlFieldName = DRUG_SPEC ];

/// 14 药品规格代码	DRUG_SPEC_CODE	VARCHAR	50	是	
Property DrugSpecCode As %String(CAPTION = "药品规格代码", MAXLEN = 50) [ SqlColumnNumber = 15, SqlFieldName = DRUG_SPEC_CODE ];

/// 15 注册规格	REG_SPEC	VARCHAR	500	是	
Property RegSpec As %String(CAPTION = "注册规格", MAXLEN = 255) [ SqlColumnNumber = 16, SqlFieldName = REG_SPEC ];

/// 16 注册规格代码	REG_SPEC_CODE	VARCHAR	50	是	
Property RegSpecCode As %String(CAPTION = "注册规格代码", MAXLEN = 50) [ SqlColumnNumber = 17, SqlFieldName = REG_SPEC_CODE ];

/// 17 给药途径	RUTE	VARCHAR	30	是	
Property Rute As %String(CAPTION = "给药途径", MAXLEN = 30) [ SqlColumnNumber = 18, SqlFieldName = RUTE ];

/// 18 贮藏	STOG	VARCHAR	500	否		
Property Stog As %String(CAPTION = "贮藏", MAXLEN = 500) [ SqlColumnNumber = 19, SqlFieldName = STOG ];

/// 19 使用频次	USED_FRQU	VARCHAR	30	是	
Property UsedFrqu As %String(CAPTION = "使用频次", MAXLEN = 30) [ SqlColumnNumber = 20, SqlFieldName = USED_FRQU ];

/// 20 每次用量	EACH_DOS	LONGTEXT	0	是	
Property EachDos As %String(CAPTION = "每次用量", MAXLEN = 200) [ SqlColumnNumber = 21, SqlFieldName = EACH_DOS ];

/// 21 药品类别	DRUG_TYPE	VARCHAR	10	是		
Property DrugType As %String(CAPTION = "药品类别", MAXLEN = 10) [ SqlColumnNumber = 22, SqlFieldName = DRUG_TYPE ];

/// 22 药品类别名称	DRUG_TYPE_NAME	VARCHAR	500	是		
Property DrugTypeName As %String(CAPTION = "药品类别名称", MAXLEN = 500) [ SqlColumnNumber = 23, SqlFieldName = DRUG_TYPE_NAME ];

/// 23 非处方药标志	OTC_FLAG	VARCHAR	3	是		
Property OtcFlag As %String(CAPTION = "非处方药标志", MAXLEN = 4) [ SqlColumnNumber = 24, SqlFieldName = OTC_FLAG ];

/// 24 非处方药标志名称	OTC_FLAG_NAME	VARCHAR	3	是	
Property OtcFlagName As %String(CAPTION = "非处方药标志名称", MAXLEN = 4) [ SqlColumnNumber = 25, SqlFieldName = OTC_FLAG_NAME ];

/// 25 包装材质	PACMATL	VARCHAR	500	是		
Property Pacmatl As %String(CAPTION = "包装材质", MAXLEN = 500) [ SqlColumnNumber = 26, SqlFieldName = PACMATL ];

/// 26 包装材质名称	PACMATL_NAME	VARCHAR	500	否
Property PacmatlName As %String(CAPTION = "包装材质名称", MAXLEN = 500) [ SqlColumnNumber = 27, SqlFieldName = PACMATL_NAME ];

/// 27 包装规格	PACSPEC	VARCHAR	100	是	
Property Pacspec As %String(CAPTION = "包装规格", MAXLEN = 100) [ SqlColumnNumber = 28, SqlFieldName = PACSPEC ];

/// 28 说明书	MANL	VARCHAR	2000	是		
Property Manl As %String(CAPTION = "说明书", MAXLEN = 2000) [ SqlColumnNumber = 29, SqlFieldName = MANL ];

/// 29 包装数量	PAC_CNT	VARCHAR	20	是		
Property PacCnt As %String(CAPTION = "包装数量", MAXLEN = 20) [ SqlColumnNumber = 30, SqlFieldName = PAC_CNT ];

/// 30 最小使用单位	MIN_USEUNT	VARCHAR	30	是	
Property MinUseUnt As %String(CAPTION = "最小使用单位", MAXLEN = 30) [ SqlColumnNumber = 31, SqlFieldName = MIN_USEUNT ];

/// 31 最小销售单位	MIN_SALUNT	VARCHAR	30	是	
Property MinSalUnt As %String(CAPTION = "最小销售单位", MAXLEN = 30) [ SqlColumnNumber = 32, SqlFieldName = MIN_SALUNT ];

/// 32 最小计量单位	MIN_UNT	VARCHAR	30	是	
Property MinUnt As %String(CAPTION = "最小计量单位", MAXLEN = 30) [ SqlColumnNumber = 33, SqlFieldName = MIN_UNT ];

/// 33 最小包装数量	MIN_PAC_CNT	INT	0	是	
Property MinPacCnt As %String(CAPTION = "最小包装数量", MAXLEN = 20) [ SqlColumnNumber = 34, SqlFieldName = MIN_PAC_CNT ];

/// 34 最小包装单位	MIN_PACUNT	VARCHAR	30	是		
Property MinPacunt As %String(CAPTION = "最小包装单位", MAXLEN = 30) [ SqlColumnNumber = 35, SqlFieldName = MIN_PACUNT ];

/// 35 最小制剂单位	MIN_PREPUNT	VARCHAR	30	是	
Property MinPrepunt As %String(CAPTION = "最小制剂单位", MAXLEN = 30) [ SqlColumnNumber = 36, SqlFieldName = MIN_PREPUNT ];

/// 36 最小制剂单位名称	MIN_PREPUNT_NAME	VARCHAR	50	是	
Property MinPrepuntName As %String(CAPTION = "最小制剂单位名称", MAXLEN = 50) [ SqlColumnNumber = 37, SqlFieldName = MIN_PREPUNT_NAME ];

/// 37 药品有效期	DRUG_EXPY	VARCHAR	255	是	
Property DrugExpy As %String(CAPTION = "药品有效期", MAXLEN = 255) [ SqlColumnNumber = 38, SqlFieldName = DRUG_EXPY ];

/// 38 最小计价单位	MIN_PRCUNT	VARCHAR	50	是	
Property MinPrcunt As %String(CAPTION = "最小计价单位", MAXLEN = 50) [ SqlColumnNumber = 39, SqlFieldName = MIN_PRCUNT ];

/// 39 不良反应	DEFS	VARCHAR	1000	是
Property Defs As %String(CAPTION = "不良反应", MAXLEN = 1000) [ SqlColumnNumber = 40, SqlFieldName = DEFS ];

/// 40 注意事项	MNAN	VARCHAR	500	否	
Property Mnan As %String(CAPTION = "注意事项", MAXLEN = 500) [ SqlColumnNumber = 41, SqlFieldName = MNAN ];

/// 41 禁忌	TABO	VARCHAR	500	是		
Property Tabo As %String(CAPTION = "禁忌", MAXLEN = 500) [ SqlColumnNumber = 42, SqlFieldName = TABO ];

/// 42 生产企业代码	PRODENTP_CODE
Property ProdentpCode As %String(CAPTION = "生产企业代码", MAXLEN = 50) [ SqlColumnNumber = 43, SqlFieldName = PRODENTP_CODE ];

/// 43 生产企业名称	PRODENTP_NAME	VARCHAR	200	否	
Property ProdentpName As %String(CAPTION = "生产企业名称", MAXLEN = 200) [ SqlColumnNumber = 44, SqlFieldName = PRODENTP_NAME ];

/// 44 生产企业地址	PRODENTP_ADDR	VARCHAR	200	是		
Property ProdentpAddr As %String(CAPTION = "生产企业地址", MAXLEN = 200) [ SqlColumnNumber = 45, SqlFieldName = PRODENTP_ADDR ];

/// 45 特殊限价药品标志	SP_LMTPRIC_DRUG_FLAG	VARCHAR	3	是	
Property SpLmtpricDrugFlag As %String(CAPTION = "特殊限价药品标志", MAXLEN = 4) [ SqlColumnNumber = 46, SqlFieldName = SP_LMTPRIC_DRUG_FLAG ];

/// 46 批准文号	APRVNO	VARCHAR	100	否		
Property Aprvno As %String(CAPTION = "批准文号", MAXLEN = 100) [ SqlColumnNumber = 47, SqlFieldName = APRVNO ];

/// 47 批准文号开始日期	APRVNO_BEGNDATE	DATE	0	是	
Property AprvnoBegndate As %String(CAPTION = "批准文号开始日期", MAXLEN = 20) [ SqlColumnNumber = 48, SqlFieldName = APRVNO_BEGNDATE ];

/// 48 批准文号结束日期	APRVNO_ENDDATE	DATE	0	是		
Property AprvnoEnddate As %String(CAPTION = "批准文号结束日期", MAXLEN = 20) [ SqlColumnNumber = 49, SqlFieldName = APRVNO_ENDDATE ];

/// 49 药品注册证编号	DRUG_REGNO
Property DrugRegno As %String(CAPTION = "药品注册证编号", MAXLEN = 100) [ SqlColumnNumber = 50, SqlFieldName = DRUG_REGNO ];

/// 50 药品注册证号开始日期	DRUG_REGCERT_BEGNDATE	DATE	0	是	
Property DrugRegcertBegndate As %String(CAPTION = "药品注册证号开始日期", MAXLEN = 20) [ SqlColumnNumber = 51, SqlFieldName = DRUG_REGCERT_BEGNDATE ];

/// 51 药品注册证号结束日期	DRUG_REGCERT_ENDDATE	DATE	0	是	
Property DrugRegcertEnddate As %String(CAPTION = "药品注册证号结束日期", MAXLEN = 20) [ SqlColumnNumber = 52, SqlFieldName = DRUG_REGCERT_ENDDATE ];

/// 52 转换比	CONVRAT	INT	0	是		
Property Convrat As %String(CAPTION = "转换比", MAXLEN = 20) [ SqlColumnNumber = 53, SqlFieldName = CONVRAT ];

/// 53 限制使用范围	LMT_USESCP	VARCHAR	500	是		
Property LmtUseScp As %String(CAPTION = "限制使用范围", MAXLEN = 500) [ SqlColumnNumber = 54, SqlFieldName = LMT_USESCP ];

/// 54 最小包装单位名称	MINPACUNT_NAME	VARCHAR	50	否	
Property MinpacuntName As %String(CAPTION = "最小包装单位名称", MAXLEN = 50) [ SqlColumnNumber = 55, SqlFieldName = MINPACUNT_NAME ];

/// 55 注册名称	REG_NAME	VARCHAR	500	是	
Property RegName As %String(CAPTION = "注册名称", MAXLEN = 200) [ SqlColumnNumber = 56, SqlFieldName = REG_NAME ];

/// 56 分包装厂家	SUBPCK_FCTY	VARCHAR	500	是	
Property SubpckFcty As %String(CAPTION = "分包装厂家", MAXLEN = 200) [ SqlColumnNumber = 57, SqlFieldName = SUBPCK_FCTY ];

/// 57 市场状态	MKT_STAS	VARCHAR	3	是		
Property MktStas As %String(CAPTION = "市场状态", MAXLEN = 4) [ SqlColumnNumber = 58, SqlFieldName = MKT_STAS ];

/// 58 药品注册批件电子档案	DRUG_REG_APPVLETR_ELECACS	VARCHAR	500	是
Property DrugRegAppvletrElecacs As %String(CAPTION = "药品注册批件电子档案", MAXLEN = 200) [ SqlColumnNumber = 59, SqlFieldName = DRUG_REG_APPVLETR_ELECACS ];

/// 59 药品补充申请批件电子档案	SPLM_APPY_APPVLETR_FILE	VARCHAR	500	是		
Property SplmAppyAppvletrFile As %String(CAPTION = "药品补充申请批件电子档案", MAXLEN = 200) [ SqlColumnNumber = 60, SqlFieldName = SPLM_APPY_APPVLETR_FILE ];

/// 60 国家医保药品目录编号	NAT_HI_DRUGLIST_NO	VARCHAR	500	是	
Property NatHiDruglistNo As %String(CAPTION = "国家医保药品目录编号", MAXLEN = 200) [ SqlColumnNumber = 61, SqlFieldName = NAT_HI_DRUGLIST_NO ];

/// 61 国家医保药品目录备注	NAT_HI_DRUGLIST_MEMO	VARCHAR	500	是	
Property NatHiDruglistMemo As %String(CAPTION = "国家医保药品目录备注", MAXLEN = 500) [ SqlColumnNumber = 62, SqlFieldName = NAT_HI_DRUGLIST_MEMO ];

/// 62 增值税调整药品标志	ADVALTAX_ADJM_DRUG_FLAG	VARCHAR	3	是		
Property AdvaltaxAdjmDrugFlag As %String(CAPTION = "增值税调整药品标志", MAXLEN = 4) [ SqlColumnNumber = 63, SqlFieldName = ADVALTAX_ADJM_DRUG_FLAG ];

/// 63 增值税调整药品名称	ADVALTAX_ADJM_DRUG_NAME	VARCHAR	3	是	
Property AdvaltaxAdjmDrugName As %String(CAPTION = "增值税调整药品名称", MAXLEN = 4) [ SqlColumnNumber = 64, SqlFieldName = ADVALTAX_ADJM_DRUG_NAME ];

/// 64 上市药品目录集药品	LSTD_DRUGLIST_DRUG	VARCHAR	10	是	
Property LstdDruglistDrug As %String(CAPTION = "上市药品目录集药品", MAXLEN = 10) [ SqlColumnNumber = 65, SqlFieldName = LSTD_DRUGLIST_DRUG ];

/// 65 卫健委药品编码	NHC_DRUG_CODG	VARCHAR	50	是	
Property NhcDrugCodg As %String(CAPTION = "卫健委药品编码", MAXLEN = 50) [ SqlColumnNumber = 66, SqlFieldName = NHC_DRUG_CODG ];

/// 66 备注	MEMO	LONGTEXT	0	是	
Property Memo As %String(CAPTION = "备注", MAXLEN = 500) [ SqlColumnNumber = 67, SqlFieldName = MEMO ];

/// 67 有效标志	VALI_FLAG	VARCHAR	3	是	
Property ValiFlag As %String(CAPTION = "有效标志", MAXLEN = 4) [ SqlColumnNumber = 68, SqlFieldName = VALI_FLAG ];

/// 68 开始时间	BEGNTIME	DATETIME	0	否	
Property Begntime As %String(CAPTION = "开始时间", MAXLEN = 20) [ SqlColumnNumber = 69, SqlFieldName = BEGNTIME ];

/// 69 结束时间	ENDTIME	DATETIME	0	是	
Property Endtime As %String(CAPTION = "结束时间", MAXLEN = 20) [ SqlColumnNumber = 70, SqlFieldName = ENDTIME ];

/// 70 数据唯一记录号	RID
Property Rid As %String(CAPTION = "数据唯一记录号", MAXLEN = 40) [ SqlColumnNumber = 71, SqlFieldName = RID ];

/// 71 数据创建时间	CRTE_TIME	DATETIME	0	否	
Property CrteTime As %String(CAPTION = "数据创建时间", MAXLEN = 30) [ SqlColumnNumber = 72, SqlFieldName = CRTE_TIME ];

/// 72 数据更新时间	UPDT_TIME	DATETIME	0	否	
Property UpdtTime As %String(CAPTION = "数据更新时间", MAXLEN = 30) [ SqlColumnNumber = 73, SqlFieldName = UPDT_TIME ];

/// 73 版本号	VER	VARCHAR	20	否		
Property Ver As %String(CAPTION = "版本号", MAXLEN = 20) [ SqlColumnNumber = 74, SqlFieldName = VER ];

/// 74 版本名称	VER_NAME	VARCHAR	30	是		
Property VerName As %String(CAPTION = "版本名称", MAXLEN = 30) [ SqlColumnNumber = 75, SqlFieldName = VER_NAME ];

/// 75 自制剂许可证号	SELFPREP_PMTNO	VARCHAR	50	是	
Property SelfprepPmtno As %String(CAPTION = "自制剂许可证号", MAXLEN = 50) [ SqlColumnNumber = 76, SqlFieldName = SELFPREP_PMTNO ];

/// 76 儿童用药	CHLD_MEDC	LONGTEXT	0	是	
Property ChldMedc As %String(CAPTION = "儿童用药", MAXLEN = 50) [ SqlColumnNumber = 77, SqlFieldName = CHLD_MEDC ];

/// 77 老年患者用药	ELD_PATN_MEDC	VARCHAR	200	是		
Property EldPatnMedc As %String(CAPTION = "老年患者用药", MAXLEN = 200) [ SqlColumnNumber = 78, SqlFieldName = ELD_PATN_MEDC ];

/// 78 医疗机构联系人姓名	MEDINS_CONER_NAME	VARCHAR	50	是	
Property MedinsConerName As %String(CAPTION = "医疗机构联系人姓名", MAXLEN = 50) [ SqlColumnNumber = 79, SqlFieldName = MEDINS_CONER_NAME ];

/// 79 医疗机构联系人电话	MEDINS_CONER_TEL	VARCHAR	50	是	
Property MedinsConerTel As %String(CAPTION = "医疗机构联系人电话", MAXLEN = 50) [ SqlColumnNumber = 80, SqlFieldName = MEDINS_CONER_TEL ];

/// 80 自制剂许可证电子档案	SELFPREP_PMTNO_ELECACS	TEXT	0	是	
Property SelfprepPmtnoElecacs As %String(CAPTION = "自制剂许可证电子档案", MAXLEN = 200) [ SqlColumnNumber = 81, SqlFieldName = SELFPREP_PMTNO_ELECACS ];

/// 81 HIS下载批次	BATCH	VARCHAR	30	否 210322162500001
Property HisBatch As %String(CAPTION = "HIS下载批次", MAXLEN = 30) [ SqlColumnNumber = 82, SqlFieldName = HIS_BATCH ];

/// 82 HIS创建人 CRTER	VARCHAR	30	否
Property HisCrterId As %String(CAPTION = "HIS创建人", MAXLEN = 30) [ SqlColumnNumber = 83, SqlFieldName = HIS_CRTER_ID ];

/// 83 HIS创建日期	CRTE_DATE	日期	
Property HisCrteDate As %Library.Date(CAPTION = "HIS创建日期") [ SqlColumnNumber = 84, SqlFieldName = HIS_CRTE_DATE ];

/// 84 HIS创建时间	CRTE_TIME	时间		
Property HisCrteTime As %Library.Time(CAPTION = "HIS创建时间") [ SqlColumnNumber = 85, SqlFieldName = HIS_CRTE_TIME ];

/// 85 HIS更新人ID	UPDT_ID			
Property HisUpdtId As %String(CAPTION = "HIS更新人ID", MAXLEN = 30) [ SqlColumnNumber = 86, SqlFieldName = HIS_UPDT_ID ];

/// 86 HIS更新日期	UPDT_DATE	日期		
Property HisUpdtDate As %Library.Date(CAPTION = "HIS更新日期") [ SqlColumnNumber = 87, SqlFieldName = HIS_UPDT_DATE ];

/// 87 HIS更新时间	HISUPDT_ITIME	时间
Property HisUpdtTime As %Library.Time(CAPTION = "HIS更新时间") [ SqlColumnNumber = 88, SqlFieldName = HIS_UPDT_TIME ];

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

Storage Default
{
<Data name="MEDINSPREPLISTDefaultData">
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
<Value>Alis</Value>
</Value>
<Value name="7">
<Value>EngName</Value>
</Value>
<Value name="8">
<Value>Dosform</Value>
</Value>
<Value name="9">
<Value>DosFormName</Value>
</Value>
<Value name="10">
<Value>RegDosform</Value>
</Value>
<Value name="11">
<Value>Ing</Value>
</Value>
<Value name="12">
<Value>EfccAtd</Value>
</Value>
<Value name="13">
<Value>Chrt</Value>
</Value>
<Value name="14">
<Value>DrugSpec</Value>
</Value>
<Value name="15">
<Value>DrugSpecCode</Value>
</Value>
<Value name="16">
<Value>RegSpec</Value>
</Value>
<Value name="17">
<Value>RegSpecCode</Value>
</Value>
<Value name="18">
<Value>Rute</Value>
</Value>
<Value name="19">
<Value>Stog</Value>
</Value>
<Value name="20">
<Value>UsedFrqu</Value>
</Value>
<Value name="21">
<Value>EachDos</Value>
</Value>
<Value name="22">
<Value>DrugType</Value>
</Value>
<Value name="23">
<Value>DrugTypeName</Value>
</Value>
<Value name="24">
<Value>OtcFlag</Value>
</Value>
<Value name="25">
<Value>OtcFlagName</Value>
</Value>
<Value name="26">
<Value>Pacmatl</Value>
</Value>
<Value name="27">
<Value>PacmatlName</Value>
</Value>
<Value name="28">
<Value>Pacspec</Value>
</Value>
<Value name="29">
<Value>Manl</Value>
</Value>
<Value name="30">
<Value>PacCnt</Value>
</Value>
<Value name="31">
<Value>MinUseUnt</Value>
</Value>
<Value name="32">
<Value>MinSalUnt</Value>
</Value>
<Value name="33">
<Value>MinUnt</Value>
</Value>
<Value name="34">
<Value>MinPacCnt</Value>
</Value>
<Value name="35">
<Value>MinPacunt</Value>
</Value>
<Value name="36">
<Value>MinPrepunt</Value>
</Value>
<Value name="37">
<Value>MinPrepuntName</Value>
</Value>
<Value name="38">
<Value>DrugExpy</Value>
</Value>
<Value name="39">
<Value>MinPrcunt</Value>
</Value>
<Value name="40">
<Value>Defs</Value>
</Value>
<Value name="41">
<Value>Mnan</Value>
</Value>
<Value name="42">
<Value>Tabo</Value>
</Value>
<Value name="43">
<Value>ProdentpCode</Value>
</Value>
<Value name="44">
<Value>ProdentpName</Value>
</Value>
<Value name="45">
<Value>ProdentpAddr</Value>
</Value>
<Value name="46">
<Value>SpLmtpricDrugFlag</Value>
</Value>
<Value name="47">
<Value>Aprvno</Value>
</Value>
<Value name="48">
<Value>AprvnoBegndate</Value>
</Value>
<Value name="49">
<Value>AprvnoEnddate</Value>
</Value>
<Value name="50">
<Value>DrugRegno</Value>
</Value>
<Value name="51">
<Value>DrugRegcertBegndate</Value>
</Value>
<Value name="52">
<Value>DrugRegcertEnddate</Value>
</Value>
<Value name="53">
<Value>Convrat</Value>
</Value>
<Value name="54">
<Value>LmtUseScp</Value>
</Value>
<Value name="55">
<Value>MinpacuntName</Value>
</Value>
<Value name="56">
<Value>RegName</Value>
</Value>
<Value name="57">
<Value>SubpckFcty</Value>
</Value>
<Value name="58">
<Value>MktStas</Value>
</Value>
<Value name="59">
<Value>DrugRegAppvletrElecacs</Value>
</Value>
<Value name="60">
<Value>SplmAppyAppvletrFile</Value>
</Value>
<Value name="61">
<Value>NatHiDruglistNo</Value>
</Value>
<Value name="62">
<Value>NatHiDruglistMemo</Value>
</Value>
<Value name="63">
<Value>AdvaltaxAdjmDrugFlag</Value>
</Value>
<Value name="64">
<Value>AdvaltaxAdjmDrugName</Value>
</Value>
<Value name="65">
<Value>LstdDruglistDrug</Value>
</Value>
<Value name="66">
<Value>NhcDrugCodg</Value>
</Value>
<Value name="67">
<Value>Memo</Value>
</Value>
<Value name="68">
<Value>ValiFlag</Value>
</Value>
<Value name="69">
<Value>Begntime</Value>
</Value>
<Value name="70">
<Value>Endtime</Value>
</Value>
<Value name="71">
<Value>Rid</Value>
</Value>
<Value name="72">
<Value>CrteTime</Value>
</Value>
<Value name="73">
<Value>UpdtTime</Value>
</Value>
<Value name="74">
<Value>Ver</Value>
</Value>
<Value name="75">
<Value>VerName</Value>
</Value>
<Value name="76">
<Value>SelfprepPmtno</Value>
</Value>
<Value name="77">
<Value>ChldMedc</Value>
</Value>
<Value name="78">
<Value>EldPatnMedc</Value>
</Value>
<Value name="79">
<Value>MedinsConerName</Value>
</Value>
<Value name="80">
<Value>MedinsConerTel</Value>
</Value>
<Value name="81">
<Value>SelfprepPmtnoElecacs</Value>
</Value>
<Value name="82">
<Value>HisBatch</Value>
</Value>
<Value name="83">
<Value>HisCrterId</Value>
</Value>
<Value name="84">
<Value>HisCrteDate</Value>
</Value>
<Value name="85">
<Value>HisCrteTime</Value>
</Value>
<Value name="86">
<Value>HisUpdtId</Value>
</Value>
<Value name="87">
<Value>HisUpdtDate</Value>
</Value>
<Value name="88">
<Value>HisUpdtTime</Value>
</Value>
</Data>
<DataLocation>^CT.INSU.MI.MEDINSPREPLISTD</DataLocation>
<DefaultData>MEDINSPREPLISTDefaultData</DefaultData>
<IdLocation>^CT.INSU.MI.MEDINSPREPLISTD</IdLocation>
<IndexLocation>^CT.INSU.MI.MEDINSPREPLISTI</IndexLocation>
<StreamLocation>^CT.INSU.MI.MEDINSPREPLISTS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
