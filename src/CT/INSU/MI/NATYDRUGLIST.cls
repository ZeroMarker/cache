/// 1304 民族药品目录下载
Class CT.INSU.MI.NATYDRUGLIST Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = Rowid ]
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
Property GennameCodg As %String(CAPTION = "通用名编码", MAXLEN = 50) [ SqlColumnNumber = 6, SqlFieldName = GENNAME_CODG ];

/// 6药品通用名	DRUG_GENNAME	VARCHAR	500	是	
Property DrugGenname As %String(CAPTION = "药品通用名", MAXLEN = 500) [ SqlColumnNumber = 7, SqlFieldName = DRUG_GENNAME ];

/// 7民族药种类	ETHDRUG_TYPE	VARCHAR	3	是		
Property EthdrugType As %String(CAPTION = "民族药种类", MAXLEN = 4) [ SqlColumnNumber = 8, SqlFieldName = ETHDRUG_TYPE ];

/// 8化学名称	CHEMNAME	VARCHAR	100	否	
Property Chemname As %String(CAPTION = "化学名称", MAXLEN = 100) [ SqlColumnNumber = 9, SqlFieldName = CHEMNAME ];

/// 9别名	ALIS	VARCHAR	100	是	
Property Alis As %String(CAPTION = "别名", MAXLEN = 100) [ SqlColumnNumber = 10, SqlFieldName = ALIS ];

/// 10英文名称	ENG_NAME	VARCHAR	255	是	
Property EngName As %String(CAPTION = "英文名称", MAXLEN = 255) [ SqlColumnNumber = 11, SqlFieldName = ENG_NAME ];

/// 11剂型	DOSFORM	VARCHAR	255	是	
Property Dosform As %String(CAPTION = "剂型", MAXLEN = 255) [ SqlColumnNumber = 12, SqlFieldName = DOSFORM ];

/// 12每次用量	EACH_DOS	LONGTEXT	0	是	
Property EachDos As %String(CAPTION = "每次用量", MAXLEN = 20) [ SqlColumnNumber = 13, SqlFieldName = EACH_DOS ];

/// 13使用频次	USED_FRQU	VARCHAR	30	是
Property UsedFrqu As %String(CAPTION = "使用频次", MAXLEN = 30) [ SqlColumnNumber = 14, SqlFieldName = USED_FRQU ];

/// 14国家药品编号	NAT_DRUG_NO	VARCHAR	20	是	
Property NatDrugNo As %String(CAPTION = "国家药品编号", MAXLEN = 20) [ SqlColumnNumber = 15, SqlFieldName = NAT_DRUG_NO ];

/// 15使用方法	USED_MTD
Property UsedMtd As %String(CAPTION = "使用方法", MAXLEN = 200) [ SqlColumnNumber = 16, SqlFieldName = USED_MTD ];

/// 16成分	ING	VARCHAR	500	是	
Property Ing As %String(CAPTION = "成分", MAXLEN = 500) [ SqlColumnNumber = 17, SqlFieldName = ING ];

/// 17性状	CHRT	VARCHAR	500	否	
Property Chrt As %String(CAPTION = "性状", MAXLEN = 500) [ SqlColumnNumber = 18, SqlFieldName = CHRT ];

/// 18不良反应	DEFS	VARCHAR	1000	是
Property Defs As %String(CAPTION = "不良反应", MAXLEN = 1000) [ SqlColumnNumber = 19, SqlFieldName = DEFS ];

/// 19禁忌	TABO	VARCHAR	500	是	
Property Tabo As %String(CAPTION = "禁忌", MAXLEN = 500) [ SqlColumnNumber = 20, SqlFieldName = TABO ];

/// 20注意事项	MNAN	VARCHAR	500	否	
Property Mnan As %String(CAPTION = "注意事项", MAXLEN = 500) [ SqlColumnNumber = 21, SqlFieldName = MNAN ];

/// 21贮藏	STOG	VARCHAR	500	否		
Property Stog As %String(CAPTION = "贮藏", MAXLEN = 500) [ SqlColumnNumber = 22, SqlFieldName = STOG ];

/// 22药品规格	DRUG_SPEC	VARCHAR	255	是	
Property DrugSpec As %String(CAPTION = "药品规格", MAXLEN = 255) [ SqlColumnNumber = 23, SqlFieldName = DRUG_SPEC ];

/// 23计价单位类型	PRCUNT_TYPE	VARCHAR	3	是	
Property PrcuntType As %String(CAPTION = "计价单位类型", MAXLEN = 4) [ SqlColumnNumber = 24, SqlFieldName = PRCUNT_TYPE ];

/// 24非处方药标志	OTC_FLAG	VARCHAR	3	是	
Property OtcFlag As %String(CAPTION = "非处方药标志", MAXLEN = 4) [ SqlColumnNumber = 25, SqlFieldName = OTC_FLAG ];

/// 25包装材质	PACMATL	VARCHAR	500	是	
Property pacMatl As %String(CAPTION = "包装材质", MAXLEN = 500) [ SqlColumnNumber = 26, SqlFieldName = PACMATL ];

/// 26包装规格	PACSPEC	VARCHAR	100	是	
Property PacSpec As %String(CAPTION = "包装规格", MAXLEN = 100) [ SqlColumnNumber = 27, SqlFieldName = PACSPEC ];

/// 27最小使用单位	MIN_USEUNT	VARCHAR	30	是	
Property MinUseunt As %String(CAPTION = "最小使用单位", MAXLEN = 30) [ SqlColumnNumber = 28, SqlFieldName = MIN_USEUNT ];

/// 28最小销售单位	MIN_SALUNT	VARCHAR	30	是	
Property MinSalunt As %String(CAPTION = "最小销售单位", MAXLEN = 30) [ SqlColumnNumber = 29, SqlFieldName = MIN_SALUNT ];

/// 29说明书	MANL	VARCHAR	2000	是	
Property Manl As %String(CAPTION = "说明书", MAXLEN = 2000) [ SqlColumnNumber = 30, SqlFieldName = MANL ];

/// 30给药途径	RUTE	VARCHAR	30	是	
Property Rute As %String(CAPTION = "给药途径", MAXLEN = 30) [ SqlColumnNumber = 31, SqlFieldName = RUTE ];

/// 31开始日期	BEGNDATE	DATE	0	是	
Property BegnDate As %String(CAPTION = "开始日期", MAXLEN = 20) [ SqlColumnNumber = 32, SqlFieldName = BEGNDATE ];

/// 32结束日期	ENDDATE	DATE	0	否		
Property Enddate As %String(CAPTION = "结束日期", MAXLEN = 20) [ SqlColumnNumber = 33, SqlFieldName = ENDDATE ];

/// 33药理分类	PHAM_TYPE	VARCHAR	40	是	
Property PhamType As %String(CAPTION = "药理分类", MAXLEN = 40) [ SqlColumnNumber = 34, SqlFieldName = PHAM_TYPE ];

/// 34备注	MEMO	LONGTEXT	0	是
Property Meomo As %String(CAPTION = "备注", MAXLEN = 500) [ SqlColumnNumber = 35, SqlFieldName = MEMO ];

/// 35包装数量	PAC_CNT	VARCHAR	20	是	
Property PacCnt As %String(CAPTION = "包装数量", MAXLEN = 20) [ SqlColumnNumber = 36, SqlFieldName = PAC_CNT ];

/// 36最小计量单位	MIN_UNT	VARCHAR	30	是
Property MinUnt As %String(CAPTION = "最小计量单位", MAXLEN = 30) [ SqlColumnNumber = 37, SqlFieldName = MIN_UNT ];

/// 37最小包装数量	MIN_PAC_CNT	INT	0	是	
Property MinPacCnt As %String(CAPTION = "最小包装数量", MAXLEN = 30) [ SqlColumnNumber = 38, SqlFieldName = MIN_PAC_CNT ];

/// 38最小包装单位	MIN_PACUNT	VARCHAR	30	是	
Property MinPacunt As %String(CAPTION = "最小包装单位", MAXLEN = 30) [ SqlColumnNumber = 39, SqlFieldName = MIN_PACUNT ];

/// 39最小制剂单位	MIN_PREPUNT	VARCHAR	30	是	
Property MinPrepunt As %String(CAPTION = "最小制剂单位", MAXLEN = 30) [ SqlColumnNumber = 40, SqlFieldName = MIN_PREPUNT ];

/// 40药品有效期	DRUG_EXPY	VARCHAR	255	是	
Property DrugExpy As %String(CAPTION = "药品有效期", MAXLEN = 255) [ SqlColumnNumber = 41, SqlFieldName = DRUG_EXPY ];

/// 41功能主治	EFCC_ATD	TEXT	0	是	
Property EfccAtd As %String(CAPTION = "功能主治", MAXLEN = 200) [ SqlColumnNumber = 42, SqlFieldName = EFCC_ATD ];

/// 42最小计价单位	MIN_PRCUNT	VARCHAR	50	是
Property MinPrcunt As %String(CAPTION = "最小计价单位", MAXLEN = 50) [ SqlColumnNumber = 43, SqlFieldName = MIN_PRCUNT ];

/// 43五笔助记码	WUBI	VARCHAR	30	是	
Property Wubi As %String(CAPTION = "五笔助记码", MAXLEN = 30) [ SqlColumnNumber = 44, SqlFieldName = WUBI ];

/// 44拼音助记码	PINYIN	VARCHAR	30	是	
Property Pinyin As %String(CAPTION = "拼音助记码", MAXLEN = 30) [ SqlColumnNumber = 45, SqlFieldName = PINYIN ];

/// 45有效标志	VALI_FLAG	VARCHAR	3	是	
Property ValiFlag As %String(CAPTION = "有效标志", MAXLEN = 4) [ SqlColumnNumber = 46, SqlFieldName = VALIFLAG ];

/// 46数据唯一记录号	RID
Property Rid As %String(CAPTION = "数据唯一记录号", MAXLEN = 40) [ SqlColumnNumber = 47, SqlFieldName = RID ];

/// 47数据创建时间	CRTE_TIME	DATETIME	0	否	
Property CrteTime As %String(CAPTION = "数据创建时间", MAXLEN = 30) [ SqlColumnNumber = 48, SqlFieldName = CRTE_TIME ];

/// 48数据更新时间	UPDT_TIME	DATETIME	0	否	
Property UpdtTime As %String(CAPTION = "数据更新时间", MAXLEN = 30) [ SqlColumnNumber = 49, SqlFieldName = UPDT_TIME ];

/// 49创建人ID	CRTER_ID
Property CrterId As %String(CAPTION = "创建人ID", MAXLEN = 30) [ SqlColumnNumber = 50, SqlFieldName = CRTER_ID ];

/// 50创建人姓名	CRTER_NAME	VARCHAR	50	是	
Property CrterName As %String(CAPTION = "创建人姓名", MAXLEN = 50) [ SqlColumnNumber = 51, SqlFieldName = CRTER_NAME ];

/// 51创建机构编号	CRTE_OPTINS_NO
Property CrteOptinsNo As %String(CAPTION = "创建机构编号", MAXLEN = 50) [ SqlColumnNumber = 52, SqlFieldName = CRTE_OPTINS_NO ];

/// 52经办人ID	OPTER_ID
Property OpterId As %String(CAPTION = "经办人ID", MAXLEN = 30) [ SqlColumnNumber = 53, SqlFieldName = OPTER_ID ];

/// 53经办人姓名	OPTER_NAME	VARCHAR	50	是	
Property OpterName As %String(CAPTION = "经办人姓名", MAXLEN = 50) [ SqlColumnNumber = 54, SqlFieldName = OPTER_NAME ];

/// 54经办时间	OPT_TIME	DATETIME	0	是	
Property OptTime As %String(CAPTION = "经办时间", MAXLEN = 2) [ SqlColumnNumber = 55, SqlFieldName = OPT_TIME ];

/// 55经办机构编号	OPTINS_NO
Property OptinsNo As %String(CAPTION = "经办机构编号", MAXLEN = 50) [ SqlColumnNumber = 56, SqlFieldName = OPTINS_NO ];

/// 56版本号	VER	VARCHAR	20	否	
Property Ver As %String(CAPTION = "版本号", MAXLEN = 20) [ SqlColumnNumber = 57, SqlFieldName = VER ];

/// 57HIS下载批次	BATCH	VARCHAR	30	否 210322162500001
Property HisBatch As %String(CAPTION = "HIS下载批次", MAXLEN = 30) [ SqlColumnNumber = 58, SqlFieldName = HIS_BATCH ];

/// 58HIS创建人 CRTER	VARCHAR	30	否
Property HisCrterId As %String(CAPTION = "HIS创建人", MAXLEN = 30) [ SqlColumnNumber = 59, SqlFieldName = HIS_CRTER_ID ];

/// 59HIS创建日期	CRTE_DATE	日期	
Property HisCrteDate As %Library.Date(CAPTION = "HIS创建日期") [ SqlColumnNumber = 60, SqlFieldName = HIS_CRTE_DATE ];

/// 60HIS创建时间	CRTE_TIME	时间		
Property HisCrteTime As %Library.Time(CAPTION = "HIS创建时间") [ SqlColumnNumber = 61, SqlFieldName = HIS_CRTE_TIME ];

/// 61HIS更新人ID	UPDT_ID			
Property HisUpdtId As %String(CAPTION = "HIS更新人ID") [ SqlColumnNumber = 62, SqlFieldName = HIS_UPDT_ID ];

/// 62HIS更新日期	UPDT_DATE	日期		
Property HisUpdtDate As %Library.Date(CAPTION = "HIS更新日期") [ SqlColumnNumber = 63, SqlFieldName = HIS_UPDT_DATE ];

/// 63HIS更新时间	HISUPDT_ITIME	时间
Property HisUpdtTime As %Library.Time(CAPTION = "HIS更新时间") [ SqlColumnNumber = 64, SqlFieldName = HIS_UPDT_TIME ];

/// 索引 HIS下载批次
Index IdxHISBATCH On (HospId As Exact, HisBatch As Exact);

/// 索引 HIS创建日期
Index IdxHISCRTEDATE On (HospId As Exact, HisCrteDate As Exact);

/// 索引HIS更新日期
Index IdxHISUPDTIDATE On (HospId As Exact, HisUpdtDate As Exact);

/// 索引医疗目录编码
Index IdxMEDLISTCODG On (HospId As Exact, MedListCodg As Exact);

/// 索引药品商品名	DRUG_PRODNAME
Index IdxDRUGPRODNAME On (HospId As Exact, DrugProdname As Exact);

Storage Default
{
<Data name="NATYDRUGLISTDefaultData">
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
<Value>GennameCodg</Value>
</Value>
<Value name="7">
<Value>DrugGenname</Value>
</Value>
<Value name="8">
<Value>EthdrugType</Value>
</Value>
<Value name="9">
<Value>Chemname</Value>
</Value>
<Value name="10">
<Value>Alis</Value>
</Value>
<Value name="11">
<Value>EngName</Value>
</Value>
<Value name="12">
<Value>Dosform</Value>
</Value>
<Value name="13">
<Value>EachDos</Value>
</Value>
<Value name="14">
<Value>UsedFrqu</Value>
</Value>
<Value name="15">
<Value>NatDrugNo</Value>
</Value>
<Value name="16">
<Value>UsedMtd</Value>
</Value>
<Value name="17">
<Value>Ing</Value>
</Value>
<Value name="18">
<Value>Chrt</Value>
</Value>
<Value name="19">
<Value>Defs</Value>
</Value>
<Value name="20">
<Value>Tabo</Value>
</Value>
<Value name="21">
<Value>Mnan</Value>
</Value>
<Value name="22">
<Value>Stog</Value>
</Value>
<Value name="23">
<Value>DrugSpec</Value>
</Value>
<Value name="24">
<Value>PrcuntType</Value>
</Value>
<Value name="25">
<Value>OtcFlag</Value>
</Value>
<Value name="26">
<Value>pacMatl</Value>
</Value>
<Value name="27">
<Value>PacSpec</Value>
</Value>
<Value name="28">
<Value>MinUseunt</Value>
</Value>
<Value name="29">
<Value>MinSalunt</Value>
</Value>
<Value name="30">
<Value>Manl</Value>
</Value>
<Value name="31">
<Value>Rute</Value>
</Value>
<Value name="32">
<Value>BegnDate</Value>
</Value>
<Value name="33">
<Value>Enddate</Value>
</Value>
<Value name="34">
<Value>PhamType</Value>
</Value>
<Value name="35">
<Value>Meomo</Value>
</Value>
<Value name="36">
<Value>PacCnt</Value>
</Value>
<Value name="37">
<Value>MinUnt</Value>
</Value>
<Value name="38">
<Value>MinPacCnt</Value>
</Value>
<Value name="39">
<Value>MinPacunt</Value>
</Value>
<Value name="40">
<Value>MinPrepunt</Value>
</Value>
<Value name="41">
<Value>DrugExpy</Value>
</Value>
<Value name="42">
<Value>EfccAtd</Value>
</Value>
<Value name="43">
<Value>MinPrcunt</Value>
</Value>
<Value name="44">
<Value>Wubi</Value>
</Value>
<Value name="45">
<Value>Pinyin</Value>
</Value>
<Value name="46">
<Value>ValiFlag</Value>
</Value>
<Value name="47">
<Value>Rid</Value>
</Value>
<Value name="48">
<Value>CrteTime</Value>
</Value>
<Value name="49">
<Value>UpdtTime</Value>
</Value>
<Value name="50">
<Value>CrterId</Value>
</Value>
<Value name="51">
<Value>CrterName</Value>
</Value>
<Value name="52">
<Value>CrteOptinsNo</Value>
</Value>
<Value name="53">
<Value>OpterId</Value>
</Value>
<Value name="54">
<Value>OpterName</Value>
</Value>
<Value name="55">
<Value>OptTime</Value>
</Value>
<Value name="56">
<Value>OptinsNo</Value>
</Value>
<Value name="57">
<Value>Ver</Value>
</Value>
<Value name="58">
<Value>HisBatch</Value>
</Value>
<Value name="59">
<Value>HisCrterId</Value>
</Value>
<Value name="60">
<Value>HisCrteDate</Value>
</Value>
<Value name="61">
<Value>HisCrteTime</Value>
</Value>
<Value name="62">
<Value>HisUpdtId</Value>
</Value>
<Value name="63">
<Value>HisUpdtDate</Value>
</Value>
<Value name="64">
<Value>HisUpdtTime</Value>
</Value>
</Data>
<DataLocation>^CT.INSU.MI.NATYDRUGLISTD</DataLocation>
<DefaultData>NATYDRUGLISTDefaultData</DefaultData>
<IdLocation>^CT.INSU.MI.NATYDRUGLISTD</IdLocation>
<IndexLocation>^CT.INSU.MI.NATYDRUGLISTI</IndexLocation>
<StreamLocation>^CT.INSU.MI.NATYDRUGLISTS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
