/// 医疗服务项目（新）目录表
/// Creater:靳帅1010
/// Time:2023/02/09
/// desc:保存【1321】医疗服务项目（新）目录下载 
/// Table:CT_INSU_MI.NewTrtServ
Class CT.INSU.MI.NewTrtServ Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = Rowid ]
{

/// 1 医院ID	HOSP_ID	VARCHAR	30	是
Property HospId As %String(CAPTION = "医院ID", MAXLEN = 6) [ SqlColumnNumber = 2, SqlFieldName = HOSP_ID ];

/// 2 医保类型	HI_TYPE	VARCHAR	30	是
Property HiType As %String(CAPTION = "医保类型", MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = HI_TYPE ];

/// 3 传输数据 ID	TRAM_DATA_ID	VARCHAR	40	是
Property TramDataId As %String(CAPTION = "传输数据 ID", MAXLEN = 40) [ SqlColumnNumber = 4, SqlFieldName = TRAM_DATA_ID ];

/// 4 父级 ID	PRNT_ID	VARCHAR	40	是
Property PrntId As %String(CAPTION = "父级 ID", MAXLEN = 40) [ SqlColumnNumber = 5, SqlFieldName = PRNT_ID ];

/// 5 医疗目录编码	MED_LIST_CODG	VARCHAR	50	是
Property MedListCodg As %String(CAPTION = "医疗目录编码", MAXLEN = 50) [ SqlColumnNumber = 6, SqlFieldName = MED_LIST_CODG ];

/// 6 分解码	BREK_CODE	10	是
Property BrekCode As %String(CAPTION = "分解码", MAXLEN = 10) [ SqlColumnNumber = 7, SqlFieldName = BREK_CODE ];

/// 7 加收码	SCHG_CODE	VARCHAR	10	否
Property SchgCode As %String(CAPTION = "加收码", MAXLEN = 10) [ SqlColumnNumber = 8, SqlFieldName = SCHG_CODE ];

/// 8 顺序码	SEQ_CODE	VARCHAR	10	是
Property SeqCode As %String(CAPTION = "顺序码", MAXLEN = 10) [ SqlColumnNumber = 9, SqlFieldName = SEQ_CODE ];

/// 9 医疗服务项目名称	SERVITEM_NAME	VARCHAR 255	是
Property ServitemName As %String(CAPTION = "医疗服务项目名称", MAXLEN = 255) [ SqlColumnNumber = 10, SqlFieldName = SERVITEM_NAME ];

/// 10 医疗服务项目输出	SERVITEM_OUPT	VARCHAR	1000	是
Property ServitemOupt As %String(CAPTION = "医疗服务项目输出", MAXLEN = 1000) [ SqlColumnNumber = 11, SqlFieldName = SERVITEM_OUPT ];

/// 11 价格构成	PRIC_COMP	VARCHAR	1000	是	
Property PricComp As %String(CAPTION = "价格构成", MAXLEN = 1000) [ SqlColumnNumber = 12, SqlFieldName = PRIC_COMP ];

/// 12 基本物料损耗	BAS_MATLS_LOS	VARCHAR	2000	是	
Property BasMatlsLos As %String(CAPTION = "基本物料损耗", MAXLEN = 2000) [ SqlColumnNumber = 13, SqlFieldName = BAS_MATLS_LOS ];

/// 13 计价单位	PRCUNT	VARCHAR	500	是
Property Prcunt As %String(CAPTION = "计价单位", MAXLEN = 500) [ SqlColumnNumber = 14, SqlFieldName = PRCUNT ];

/// 14 计价说明	PricDscr	VARCHAR	500	是	
Property LstdFilStas As %String(CAPTION = "计价说明", MAXLEN = 500) [ SqlColumnNumber = 15, SqlFieldName = PRIC_DSCR ];

/// 15 附件	ATT	VARCHAR	1000	是	
Property Att As %String(CAPTION = "附件", MAXLEN = 1000) [ SqlColumnNumber = 16, SqlFieldName = ATT ];

/// 16 有效标志	VALI_FLAG	3	是
Property ValiFlag As %String(CAPTION = "有效标志", MAXLEN = 4) [ SqlColumnNumber = 17, SqlFieldName = VALI_FLAG ];

/// 17 层级	HERY	VARCHAR	6	是	
Property Hery As %String(CAPTION = "层级", MAXLEN = 6) [ SqlColumnNumber = 18, SqlFieldName = HERY ];

/// 18 层级树	HERY_TREE	VARCHAR	500	是
Property HeryTree As %String(CAPTION = "层级树", MAXLEN = 500) [ SqlColumnNumber = 19, SqlFieldName = HERY_TREE ];

/// 19 诊疗项目说明	TRT_ITEM_DSCR	VARCHAR	2000	是	
Property TrtItemDscr As %String(CAPTION = "诊疗项目说明", MAXLEN = 2000) [ SqlColumnNumber = 20, SqlFieldName = TRT_ITEM_DSCR ];

/// 20 费用类型口径	FEE_TYPE_CALI	VARCHAR	10	是	
Property FeeTypeCali As %String(CAPTION = "费用类型口径", MAXLEN = 10) [ SqlColumnNumber = 21, SqlFieldName = FEE_TYPE_CALI ];

/// 21 医保区划    ADMDVS      VARCHAR	6  否
Property Admdvs As %String(CAPTION = "医保区划", MAXLEN = 6) [ SqlColumnNumber = 22, SqlFieldName = ADMDVS ];

/// 22 下发标志	ISU_FLAG	3	是
Property IsuFlag As %String(CAPTION = "下发标志", MAXLEN = 4) [ SqlColumnNumber = 23, SqlFieldName = ISU_FLAG ];

/// 23 版本号	VER	VARCHAR	20	是
Property Ver As %String(CAPTION = "版本号", MAXLEN = 30) [ SqlColumnNumber = 24, SqlFieldName = VER ];

/// 24 版本名称	VER_NAME	VARCHAR	30	是
Property VerName As %String(CAPTION = "版本名称", MAXLEN = 30) [ SqlColumnNumber = 25, SqlFieldName = VER_NAME ];

/// 25 生效时间	EFFT_TIME	255	否
Property EfftTime As %String(CAPTION = "生效时间", MAXLEN = 255) [ SqlColumnNumber = 26, SqlFieldName = EFFT_TIME ];

/// 26 失效时间 INVD_TIME	100	否
Property InvdTime As %String(CAPTION = "失效时间", MAXLEN = 100) [ SqlColumnNumber = 27, SqlFieldName = INVD_TIME ];

/// 27 数据唯一记录号	RID	40	是
Property Rid As %String(CAPTION = "数据唯一记录号", MAXLEN = 40) [ SqlColumnNumber = 28, SqlFieldName = RID ];

/// 28 创建人ID	CRTER_ID	VARCHAR	20	否
Property CrterId As %String(CAPTION = "创建人ID", MAXLEN = 20) [ SqlColumnNumber = 29, SqlFieldName = CRTER_ID ];

/// 29 创建人姓名	CRTER_NAME		50	否
Property CrterName As %String(CAPTION = "创建人姓名", MAXLEN = 50) [ SqlColumnNumber = 30, SqlFieldName = CRTER_NAME ];

/// 30 数据创建时间	CRTE_TIME		   是
Property CrteTime As %String(CAPTION = "数据创建时间", MAXLEN = 40) [ SqlColumnNumber = 31, SqlFieldName = CRTE_TIME ];

/// 31 数据更新时间	UPDT_TIME		   是
Property UpdtTime As %String(CAPTION = "数据更新时间", MAXLEN = 40) [ SqlColumnNumber = 32, SqlFieldName = UPDT_TIME ];

/// 32 创建机构编号	CRTE_OPTINS_NO	VARCHAR	20	否	
Property CrteOptinsNo As %String(CAPTION = "创建机构编号", MAXLEN = 20) [ SqlColumnNumber = 33, SqlFieldName = CRTE_OPTINS_NO ];

/// 33 经办人	OPTER_ID	VARCHAR	20	否		
Property OpterId As %String(CAPTION = "经办人", MAXLEN = 20) [ SqlColumnNumber = 34, SqlFieldName = OPTER_ID ];

/// 34 经办人姓名	OPTER_NAME	字符型	50	否	
Property OpterName As %String(CAPTION = "经办人姓名", MAXLEN = 50) [ SqlColumnNumber = 35, SqlFieldName = OPTER_NAME ];

/// 35 经办时间	OPT_TIME	日期型		否
Property OptTime As %String(CAPTION = "经办时间", MAXLEN = 20) [ SqlColumnNumber = 36, SqlFieldName = OPT_TIME ];

/// 36 经办机构	OPTINS_NO	VARCHAR	20	否
Property OptinsNo As %String(CAPTION = "经办机构", MAXLEN = 20) [ SqlColumnNumber = 37, SqlFieldName = OPTINS_NO ];

/// 37 HIS批次	HIS_BATCH	字符型	30	否
Property HisBatch As %String(CAPTION = "HIS批次", MAXLEN = 30) [ SqlColumnNumber = 38, SqlFieldName = HIS_BATCH ];

/// 38 HIS创建人	HIS_CRTER_ID	字符型	30	否
Property HisCrterId As %String(CAPTION = "HIS创建人", MAXLEN = 30) [ SqlColumnNumber = 39, SqlFieldName = HIS_CRTER_ID ];

/// 39 HIS创建日期	HIS_CRTE_DATE	日期
Property HisCrteDate As %Library.Date(CAPTION = "HIS创建日期") [ SqlColumnNumber = 40, SqlFieldName = HIS_CRTE_DATE ];

/// 40 HIS创建时间	HIS_CRTE_TIME	时间	
Property HisCrteTime As %Library.Time(CAPTION = "HIS创建时间") [ SqlColumnNumber = 41, SqlFieldName = HIS_CRTE_TIME ];

/// 41 HIS更新人ID	HIS_UPDT_ID	字符型
Property HisUpdtId As %String(CAPTION = "HIS更新人ID", MAXLEN = 30) [ SqlColumnNumber = 42, SqlFieldName = HIS_UPDT_ID ];

/// 42 HIS更新日期	HIS_UPDT_DATE	日期
Property HisUpdtDate As %Library.Date(CAPTION = "HIS更新日期") [ SqlColumnNumber = 43, SqlFieldName = HIS_UPDT_DATE ];

/// 43 HIS更新时间	HIS_UPDT_TIME	时间	
Property HisUpdtTime As %Library.Time(CAPTION = "HIS更新时间") [ SqlColumnNumber = 44, SqlFieldName = HIS_UPDT_TIME ];

/// 索引 医疗目录编码
Index IdxMedListCodg On (HospId As Exact, MedListCodg As Exact);

/// 索引 医疗服务项目名称
Index IdxServitemName On (HospId As Exact, ServitemName As Exact);

/// 索引 HIS下载批次
Index IdxHISBATCH On (HospId As Exact, HisBatch As Exact);

/// 索引 HIS创建日期
Index IdxHisCrteDate On (HospId As Exact, HisCrteDate As Exact);

/// 索引HIS更新日期
Index IdxHisUpdtDate On (HospId As Exact, HisUpdtDate As Exact);

Storage Default
{
<Data name="NewTrtServDefaultData">
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
<Value>TramDataId</Value>
</Value>
<Value name="5">
<Value>PrntId</Value>
</Value>
<Value name="6">
<Value>MedListCodg</Value>
</Value>
<Value name="7">
<Value>BrekCode</Value>
</Value>
<Value name="8">
<Value>SchgCode</Value>
</Value>
<Value name="9">
<Value>SeqCode</Value>
</Value>
<Value name="10">
<Value>ServitemName</Value>
</Value>
<Value name="11">
<Value>ServitemOupt</Value>
</Value>
<Value name="12">
<Value>PricComp</Value>
</Value>
<Value name="13">
<Value>BasMatlsLos</Value>
</Value>
<Value name="14">
<Value>Prcunt</Value>
</Value>
<Value name="15">
<Value>LstdFilStas</Value>
</Value>
<Value name="16">
<Value>Att</Value>
</Value>
<Value name="17">
<Value>ValiFlag</Value>
</Value>
<Value name="18">
<Value>Hery</Value>
</Value>
<Value name="19">
<Value>HeryTree</Value>
</Value>
<Value name="20">
<Value>TrtItemDscr</Value>
</Value>
<Value name="21">
<Value>FeeTypeCali</Value>
</Value>
<Value name="22">
<Value>Admdvs</Value>
</Value>
<Value name="23">
<Value>IsuFlag</Value>
</Value>
<Value name="24">
<Value>Ver</Value>
</Value>
<Value name="25">
<Value>VerName</Value>
</Value>
<Value name="26">
<Value>EfftTime</Value>
</Value>
<Value name="27">
<Value>InvdTime</Value>
</Value>
<Value name="28">
<Value>Rid</Value>
</Value>
<Value name="29">
<Value>CrterId</Value>
</Value>
<Value name="30">
<Value>CrterName</Value>
</Value>
<Value name="31">
<Value>CrteTime</Value>
</Value>
<Value name="32">
<Value>UpdtTime</Value>
</Value>
<Value name="33">
<Value>CrteOptinsNo</Value>
</Value>
<Value name="34">
<Value>OpterId</Value>
</Value>
<Value name="35">
<Value>OpterName</Value>
</Value>
<Value name="36">
<Value>OptTime</Value>
</Value>
<Value name="37">
<Value>OptinsNo</Value>
</Value>
<Value name="38">
<Value>HisBatch</Value>
</Value>
<Value name="39">
<Value>HisCrterId</Value>
</Value>
<Value name="40">
<Value>HisCrteDate</Value>
</Value>
<Value name="41">
<Value>HisCrteTime</Value>
</Value>
<Value name="42">
<Value>HisUpdtId</Value>
</Value>
<Value name="43">
<Value>HisUpdtDate</Value>
</Value>
<Value name="44">
<Value>HisUpdtTime</Value>
</Value>
</Data>
<DataLocation>^CT.INSU.MI.NewTrtServD</DataLocation>
<DefaultData>NewTrtServDefaultData</DefaultData>
<IdLocation>^CT.INSU.MI.NewTrtServD</IdLocation>
<IndexLocation>^CT.INSU.MI.NewTrtServI</IndexLocation>
<StreamLocation>^CT.INSU.MI.NewTrtServS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
