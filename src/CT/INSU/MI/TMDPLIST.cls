/// 1302 中药饮片目录表
Class CT.INSU.MI.TMDPLIST Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = Rowid ]
{

/// 1 医院ID	HOSP_ID	VARCHAR	30	否
Property HospId As %String(CAPTION = "医院ID", MAXLEN = 6) [ SqlColumnNumber = 2, SqlFieldName = HOSP_ID ];

/// 2 医保类型	HI_TYPE	VARCHAR	30	否
Property HiType As %String(CAPTION = "医保类型", MAXLEN = 10) [ SqlColumnNumber = 3, SqlFieldName = HI_TYPE ];

/// 3医疗目录编码	MED_LIST_CODG	VARCHAR	50	是
Property MedListCodg As %String(CAPTION = "医疗目录编码", MAXLEN = 30) [ SqlColumnNumber = 4, SqlFieldName = MED_LIST_CODG ];

/// 4单味药名称	SINDRUG_NAME	VARCHAR	30	是
Property SindrugName As %String(CAPTION = "单味药名称", MAXLEN = 30) [ SqlColumnNumber = 5, SqlFieldName = SINDRUG_NAME ];

/// 5单复方标志	CPND_FLAG	VARCHAR	3	是
Property CpndFlag As %String(CAPTION = "单复方标志", MAXLEN = 4) [ SqlColumnNumber = 6, SqlFieldName = CPND_FLAG ];

/// 6质量等级	QLT_REG	VARCHAR	6	是
Property QltReg As %String(CAPTION = "质量等级", MAXLEN = 4) [ SqlColumnNumber = 7, SqlFieldName = QLT_REG ];

/// 7中草药年份	TCMHERB_YEAR	INT	0	是
Property TcmherbYear As %String(CAPTION = "中草药年份", MAXLEN = 30) [ SqlColumnNumber = 8, SqlFieldName = TCMHERB_YEAR ];

/// 8药用部位	MED_PART	VARCHAR	50	是
Property MedPart As %String(CAPTION = "药用部位", MAXLEN = 50) [ SqlColumnNumber = 9, SqlFieldName = MED_PART ];

/// 9安全计量	SAFE_MTR	VARCHAR	100	是
Property SafeMtr As %String(CAPTION = "安全计量", MAXLEN = 100) [ SqlColumnNumber = 10, SqlFieldName = SAFE_MTR ];

/// 10常规用法	CNVL_USED	VARCHAR	100	是
Property CnvlUsed As %String(CAPTION = "常规用法", MAXLEN = 100) [ SqlColumnNumber = 11, SqlFieldName = CNVL_USED ];

/// 性味	NATFLA	VARCHAR	255	是
Property Natfla As %String(CAPTION = "性味", MAXLEN = 255) [ SqlColumnNumber = 12, SqlFieldName = NATFLA ];

/// 归经	MERTPM	VARCHAR	30	是
Property Mertpm As %String(CAPTION = "归经", MAXLEN = 30) [ SqlColumnNumber = 13, SqlFieldName = MERTPM ];

/// 品种	CAT	VARCHAR	500	是
Property Cat As %String(CAPTION = "品种", MAXLEN = 100) [ SqlColumnNumber = 14, SqlFieldName = CAT ];

/// 开始日期	BEGNDATE	DATE	0	是
Property Begndate As %String(CAPTION = "开始日期", MAXLEN = 20) [ SqlColumnNumber = 15, SqlFieldName = BEGNDATE ];

/// 结束日期	ENDDATE	DATE	0	否
Property Enddate As %String(CAPTION = "结束日期", MAXLEN = 20) [ SqlColumnNumber = 16, SqlFieldName = ENDDATE ];

/// 有效标志	VALI_FLAG	VARCHAR	3	是
Property ValiFlag As %String(CAPTION = "有效标志", MAXLEN = 4) [ SqlColumnNumber = 17, SqlFieldName = VALI_FLAG ];

/// RID唯一记录号	
Property Rid As %String(CAPTION = "唯一记录号", MAXLEN = 40) [ SqlColumnNumber = 18, SqlFieldName = RID ];

/// 数据创建时间	CRTE_TIME	DATETIME	0	否
Property CrteTime As %String(CAPTION = "数据创建时间", MAXLEN = 30) [ SqlColumnNumber = 19, SqlFieldName = CRTE_TIME ];

/// 数据更新时间	UPDT_TIME	DATETIME	0	否
Property UpdtTime As %String(CAPTION = "数据更新时间", MAXLEN = 30) [ SqlColumnNumber = 20, SqlFieldName = UPDT_TIME ];

/// 版本号	VER	VARCHAR	20	否
Property Ver As %String(CAPTION = "版本号", MAXLEN = 20) [ SqlColumnNumber = 21, SqlFieldName = VER ];

/// 版本名称	VER_NAME	VARCHAR	30	是
Property VerName As %String(CAPTION = "版本名称", MAXLEN = 30) [ SqlColumnNumber = 22, SqlFieldName = VER_NAME ];

/// 药材名称	MLMS_NAME	VARCHAR	255	是
Property MlmsName As %String(CAPTION = "药材名称", MAXLEN = 255) [ SqlColumnNumber = 23, SqlFieldName = MLMS_NAME ];

/// 功能主治	EFCC_ATD	TEXT	0	是
Property EfccAtd As %String(CAPTION = "功能主治", MAXLEN = 500) [ SqlColumnNumber = 24, SqlFieldName = EFCC_ATD ];

/// 炮制方法	PSDG_MTD	VARCHAR	255	是
Property PsdgMtd As %String(CAPTION = "炮制方法", MAXLEN = 255) [ SqlColumnNumber = 25, SqlFieldName = PSDG_MTD ];

/// 功效分类	ECY_TYPE	VARCHAR	255	是
Property EcyType As %String(CAPTION = "功效分类", MAXLEN = 255) [ SqlColumnNumber = 26, SqlFieldName = ECY_TYPE ];

/// 药材种来源	MLMS_CAT_SOUC	VARCHAR	255	是
Property MlmsCatSouc As %String(CAPTION = "药材种来源", MAXLEN = 255) [ SqlColumnNumber = 27, SqlFieldName = MLMS_CAT_SOUC ];

/// 国家医保支付政策	NAT_HI_PAY_POL	VARCHAR	255	是
Property NatHiPayPol As %String(CAPTION = "国家医保支付政策", MAXLEN = 255) [ SqlColumnNumber = 28, SqlFieldName = NAT_HI_PAY_POL ];

/// 省级医保支付政策	PROV_HI_PAY_POL	VARCHAR	255	是
Property ProvHiPayPol As %String(CAPTION = "省级医保支付政策", MAXLEN = 255) [ SqlColumnNumber = 29, SqlFieldName = PROV_HI_PAY_POL ];

/// 标准名称	STD_NAME	VARCHAR	200	是
Property StdName As %String(CAPTION = "标准名称", MAXLEN = 200) [ SqlColumnNumber = 30, SqlFieldName = STD_NAME ];

/// 标准页码	STD_PAGEN	VARCHAR	255	是
Property StdPagen As %String(CAPTION = "标准页码", MAXLEN = 20) [ SqlColumnNumber = 31, SqlFieldName = STD_PAGEN ];

/// 标准电子档案	STD_ELECACS	VARCHAR	500	是
Property StdElecacs As %String(CAPTION = "标准电子档案", MAXLEN = 200) [ SqlColumnNumber = 32, SqlFieldName = STD_ELECACS ];

/// HIS下载批次	BATCH	VARCHAR	30	否 210322162500001
Property HisBatch As %String(CAPTION = "HIS下载批次", MAXLEN = 30) [ SqlColumnNumber = 33, SqlFieldName = HIS_BATCH ];

/// HIS创建人 CRTER	VARCHAR	30	否
Property HisCrterId As %String(CAPTION = "HIS创建人", MAXLEN = 30) [ SqlColumnNumber = 34, SqlFieldName = HIS_CRTER_ID ];

/// HIS创建日期	CRTE_DATE	日期	
Property HisCrteDate As %Library.Date(CAPTION = "HIS创建日期") [ SqlColumnNumber = 35, SqlFieldName = HIS_CRTE_DATE ];

/// HIS创建时间	CRTE_TIME	时间		
Property HisCrteTime As %Library.Time(CAPTION = "HIS创建时间") [ SqlColumnNumber = 36, SqlFieldName = HIS_CRTE_TIME ];

/// HIS更新人ID	UPDT_ID			
Property HisUpdtId As %String(CAPTION = "HIS更新人ID") [ SqlColumnNumber = 37, SqlFieldName = HIS_UPDT_ID ];

/// HIS更新日期	UPDT_DATE	日期		
Property HisUpdtDate As %Library.Date(CAPTION = "HIS更新日期") [ SqlColumnNumber = 38, SqlFieldName = HIS_UPDT_DATE ];

/// HIS更新时间	HISUPDT_ITIME	时间
Property HisUpdtTime As %Library.Time(CAPTION = "HIS更新时间") [ SqlColumnNumber = 39, SqlFieldName = HIS_UPDT_TIME ];

/// 索引 HIS下载批次
Index IdxHISBATCH On (HospId As Exact, HisBatch As Exact);

/// 索引 HIS创建日期
Index IdxHISCRTEDATE On (HospId As Exact, HisCrteDate As Exact);

/// 索引HIS更新日期
Index IdxHISUPDTDATE On (HospId As Exact, HisUpdtDate As Exact);

/// 索引医疗目录编码
Index IdxMEDLISTCODG On (HospId As Exact, MedListCodg As Exact);

/// 单位药名称
Index IdxSINDRUGNAME On (HospId As Exact, SindrugName As Exact);

Storage Default
{
<Data name="TMDPLISTDefaultData">
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
<Value>SindrugName</Value>
</Value>
<Value name="6">
<Value>CpndFlag</Value>
</Value>
<Value name="7">
<Value>QltReg</Value>
</Value>
<Value name="8">
<Value>TcmherbYear</Value>
</Value>
<Value name="9">
<Value>MedPart</Value>
</Value>
<Value name="10">
<Value>SafeMtr</Value>
</Value>
<Value name="11">
<Value>CnvlUsed</Value>
</Value>
<Value name="12">
<Value>Natfla</Value>
</Value>
<Value name="13">
<Value>Mertpm</Value>
</Value>
<Value name="14">
<Value>Cat</Value>
</Value>
<Value name="15">
<Value>Begndate</Value>
</Value>
<Value name="16">
<Value>Enddate</Value>
</Value>
<Value name="17">
<Value>ValiFlag</Value>
</Value>
<Value name="18">
<Value>Rid</Value>
</Value>
<Value name="19">
<Value>CrteTime</Value>
</Value>
<Value name="20">
<Value>UpdtTime</Value>
</Value>
<Value name="21">
<Value>Ver</Value>
</Value>
<Value name="22">
<Value>VerName</Value>
</Value>
<Value name="23">
<Value>MlmsName</Value>
</Value>
<Value name="24">
<Value>EfccAtd</Value>
</Value>
<Value name="25">
<Value>PsdgMtd</Value>
</Value>
<Value name="26">
<Value>EcyType</Value>
</Value>
<Value name="27">
<Value>MlmsCatSouc</Value>
</Value>
<Value name="28">
<Value>NatHiPayPol</Value>
</Value>
<Value name="29">
<Value>ProvHiPayPol</Value>
</Value>
<Value name="30">
<Value>StdName</Value>
</Value>
<Value name="31">
<Value>StdPagen</Value>
</Value>
<Value name="32">
<Value>StdElecacs</Value>
</Value>
<Value name="33">
<Value>HisBatch</Value>
</Value>
<Value name="34">
<Value>HisCrterId</Value>
</Value>
<Value name="35">
<Value>HisCrteDate</Value>
</Value>
<Value name="36">
<Value>HisCrteTime</Value>
</Value>
<Value name="37">
<Value>HisUpdtId</Value>
</Value>
<Value name="38">
<Value>HisUpdtDate</Value>
</Value>
<Value name="39">
<Value>HisUpdtTime</Value>
</Value>
</Data>
<DataLocation>^CT.INSU.MI.TMDPLISTD</DataLocation>
<DefaultData>TMDPLISTDefaultData</DefaultData>
<IdLocation>^CT.INSU.MI.TMDPLISTD</IdLocation>
<IndexLocation>^CT.INSU.MI.TMDPLISTI</IndexLocation>
<StreamLocation>^CT.INSU.MI.TMDPLISTS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
