/// 中药配方颗粒产品信息表
/// Creater:靳帅1010
/// Time:2023/02/09
/// desc:保存【1320】中药配方颗粒目录下载 信息
/// Table:CT_INSU_MI.TcmfParcProd
Class CT.INSU.MI.TcmfParcProd Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = Rowid ]
{

/// 1 医院ID	HOSP_ID	VARCHAR	30	是
Property HospId As %String(CAPTION = "医院ID", MAXLEN = 6) [ SqlColumnNumber = 2, SqlFieldName = HOSP_ID ];

/// 2 医保类型	HI_TYPE	VARCHAR	30	是
Property HiType As %String(CAPTION = "医保类型", MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = HI_TYPE ];

/// 3 中药配方颗粒 Id	TCMF_PARC_ID	VARCHAR	40	是
Property TcmFParcId As %String(CAPTION = "中药配方颗粒Id", MAXLEN = 40) [ SqlColumnNumber = 4, SqlFieldName = TCMF_PARC_ID ];

/// 4 中药配方颗粒代码	TCMF_PARC_CODE	VARCHAR	3	是
Property TcmfParcCode As %String(CAPTION = "中药配方颗粒代码", MAXLEN = 30) [ SqlColumnNumber = 5, SqlFieldName = TCMF_PARC_CODE ];

/// 5 中药配方颗粒名称	TCMF_PARC_NAME	VARCHAR	50	是
Property TcmfParcName As %String(CAPTION = "中药配方颗粒名称", MAXLEN = 50) [ SqlColumnNumber = 6, SqlFieldName = TCMF_PARC_NAME ];

/// 6 最小计量单位	MIN_UNT	VARCHAR	30	是
Property MinUnt As %String(CAPTION = "最小计量单位", MAXLEN = 30) [ SqlColumnNumber = 7, SqlFieldName = MIN_UNT ];

/// 7 道地药材	FARD	int	11	否
Property Fard As %String(CAPTION = "道地药材", MAXLEN = 11) [ SqlColumnNumber = 8, SqlFieldName = FARD ];

/// 8 规格	SPEC	VARCHAR	500	是
Property Spec As %String(CAPTION = "规格", MAXLEN = 500) [ SqlColumnNumber = 9, SqlFieldName = SPEC ];

/// 9 中药配方颗粒包装规格	TCMF_PARC_PACSPEC	text	是
Property TcmfParcPacspec As %String(CAPTION = "中药配方颗粒包装规格", MAXLEN = 200) [ SqlColumnNumber = 10, SqlFieldName = TCMF_PARC_PACSPEC ];

/// 10 保质期	SHLF	VARCHAR	50	是
Property Shlf As %String(CAPTION = "保质期", MAXLEN = 50) [ SqlColumnNumber = 11, SqlFieldName = SHLF ];

/// 11 生产企业名称	PRODENTP_NAME	VARCHAR	255	是	
Property ProdentpName As %String(CAPTION = "生产企业名称", MAXLEN = 255) [ SqlColumnNumber = 12, SqlFieldName = PRODENTP_NAME ];

/// 12 生产企业地址	PRODENTP_ADDR	VARCHAR	255	是	
Property ProdentpAddr As %String(CAPTION = "生产企业地址", MAXLEN = 255) [ SqlColumnNumber = 13, SqlFieldName = PRODENTP_ADDR ];

/// 13 上市备案号	LSTD_FIL_NO	VARCHAR	50	是
Property LstdFilNo As %String(CAPTION = "上市备案号", MAXLEN = 50) [ SqlColumnNumber = 14, SqlFieldName = LSTD_FIL_NO ];

/// 14 上市备案时间	LSTD_FIL_TIME	日期
Property LstdFilTime As %String(CAPTION = "上市备案时间", MAXLEN = 50) [ SqlColumnNumber = 15, SqlFieldName = LSTD_FIL_TIME ];

/// 15 上市备案状态	LSTD_FIL_STAS	VARCHAR	4	是	
Property LstdFilStas As %String(CAPTION = "上市备案状态", MAXLEN = 4) [ SqlColumnNumber = 16, SqlFieldName = LSTD_FIL_STAS ];

/// 16 上市备案地方机构	LSTD_FIL_PLACE_ORG	VARCHAR	100	是	
Property LstdFilPlaceOrg As %String(CAPTION = "上市备案地方机构", MAXLEN = 100) [ SqlColumnNumber = 17, SqlFieldName = LSTD_FIL_PLACE_ORG ];

/// 17 上市备案信息	NATSTD_DIAG_NAME	VARCHAR	255	是	
Property LstdFilInfo As %String(CAPTION = "上市备案信息", MAXLEN = 255) [ SqlColumnNumber = 18, SqlFieldName = LSTD_FIL_INFO ];

/// 18 中药配方颗粒执行标准	TCMF_PARC_EXESTD	VARCHAR	100	是
Property TcmfParcExestd As %String(CAPTION = "中药配方颗粒执行标准", MAXLEN = 100) [ SqlColumnNumber = 19, SqlFieldName = TCMF_PARC_EXESTD ];

/// 19 执行标准	EXESTD	VARCHAR	255	是	
Property Exestd As %String(CAPTION = "执行标准", MAXLEN = 255) [ SqlColumnNumber = 20, SqlFieldName = EXESTD ];

/// 20 中药配方颗粒执行标准电子文档	TCMF_PARC_EXESTD_ELEC_DOC	VARCHAR	255	是	
Property TcmfParcExestdElecDoc As %String(CAPTION = "中药配方颗粒执行标准电子文档", MAXLEN = 255) [ SqlColumnNumber = 21, SqlFieldName = TCMF_PARC_EXESTD_ELEC_DOC ];

/// 21 不良反应检查信息	DEFS_EXAM_INFO	VARCHAR	255	否	
Property DefsExamInfo As %String(CAPTION = "不良反应检查信息", MAXLEN = 255) [ SqlColumnNumber = 22, SqlFieldName = DEFS_EXAM_INFO ];

/// 22 中药饮片代码	TMDP_CODE VARCHAR	10	是
Property TmdpCode As %String(CAPTION = "中药饮片代码", MAXLEN = 10) [ SqlColumnNumber = 23, SqlFieldName = TMDP_CODE ];

/// 23 中药饮片名称	TMDP_NAME	100	是
Property TmdpName As %String(CAPTION = "中药饮片名称", MAXLEN = 100) [ SqlColumnNumber = 24, SqlFieldName = TMDP_NAME ];

/// 24 药材名称	MLMS_NAME	255	否
Property MlmsName As %String(CAPTION = "药材名称", MAXLEN = 255) [ SqlColumnNumber = 25, SqlFieldName = MLMS_NAME ];

/// 25 功效分类	ECY_TYPE	255	否
Property EcyType As %String(CAPTION = "功效分类", MAXLEN = 255) [ SqlColumnNumber = 26, SqlFieldName = ECY_TYPE ];

/// 26 功能主治 EFCC_ATD	100	否
Property EfccAtd As %String(CAPTION = "功能主治", MAXLEN = 500) [ SqlColumnNumber = 27, SqlFieldName = EFCC_ATD ];

/// 27 常规用法	CNVL_USED	2048	否
Property CnvlUsed As %String(CAPTION = "常规用法", MAXLEN = 2048) [ SqlColumnNumber = 28, SqlFieldName = CNVL_USED ];

/// 28 中药饮片执行标准	TMDP_EXESTD	255	是
Property TmdpExestd As %String(CAPTION = "中药饮片执行标准", MAXLEN = 255) [ SqlColumnNumber = 29, SqlFieldName = TMDP_EXESTD ];

/// 29 生产企业统一社会信用代码	PRODENTP_USCC	50	是
Property ProdentpUscc As %String(CAPTION = "生产企业统一社会信用代码", MAXLEN = 50) [ SqlColumnNumber = 30, SqlFieldName = PRODENTP_USCC ];

/// 30 下发标志	ISU_FLAG VARCHAR	3	是
Property IsuFlag As %String(CAPTION = "下发标志", MAXLEN = 4) [ SqlColumnNumber = 31, SqlFieldName = ISU_FLAG ];

/// 31 有效标志	VALI_FLAG	3	是
Property ValiFlag As %String(CAPTION = "有效标志", MAXLEN = 4) [ SqlColumnNumber = 32, SqlFieldName = VALI_FLAG ];

/// 32 数据唯一记录号	RID	40	是
Property Rid As %String(CAPTION = "数据唯一记录号", MAXLEN = 40) [ SqlColumnNumber = 33, SqlFieldName = RID ];

/// 33 数据更新时间 UPDT_TIME   是
Property UpdtTime As %String(CAPTION = "数据更新时间", MAXLEN = 40) [ SqlColumnNumber = 34, SqlFieldName = UPDT_TIME ];

/// 34 创建人ID	CRTER_ID	VARCHAR	20	否
Property CrterId As %String(CAPTION = "创建人ID", MAXLEN = 20) [ SqlColumnNumber = 35, SqlFieldName = CRTER_ID ];

/// 35 创建人姓名	CRTER_NAME	字符型	50	否
Property CrterName As %String(CAPTION = "创建人姓名", MAXLEN = 50) [ SqlColumnNumber = 36, SqlFieldName = CRTER_NAME ];

/// 36 数据创建时间	CRTE_TIME	字符型	   是
Property CrteTime As %String(CAPTION = "数据创建时间", MAXLEN = 40) [ SqlColumnNumber = 37, SqlFieldName = CRTE_TIME ];

/// 37 创建机构编号	CRTE_OPTINS_NO	VARCHAR	20	否	
Property CrteOptinsNo As %String(CAPTION = "创建机构编号", MAXLEN = 20) [ SqlColumnNumber = 38, SqlFieldName = CRTE_OPTINS_NO ];

/// 38 经办人	OPTER_ID	VARCHAR	20	否		
Property OpterId As %String(CAPTION = "经办人", MAXLEN = 20) [ SqlColumnNumber = 39, SqlFieldName = OPTER_ID ];

/// 39 经办人姓名	OPTER_NAME	字符型	50	否	
Property OpterName As %String(CAPTION = "经办人姓名", MAXLEN = 50) [ SqlColumnNumber = 40, SqlFieldName = OPTER_NAME ];

/// 40 经办时间	OPT_TIME	日期型		否
Property OptTime As %String(CAPTION = "经办时间", MAXLEN = 40) [ SqlColumnNumber = 41, SqlFieldName = OPT_TIME ];

/// 41 经办机构	OPTINS_NO	VARCHAR	20	否
Property OptinsNo As %String(CAPTION = "经办机构", MAXLEN = 20) [ SqlColumnNumber = 42, SqlFieldName = OPTINS_NO ];

/// 42 医保区划    ADMDVS      VARCHAR	6  否
Property Admdvs As %String(CAPTION = "医保区划", MAXLEN = 6) [ SqlColumnNumber = 43, SqlFieldName = ADMDVS ];

/// 43 备注	MEMO	LONGTEXT	0	否
Property Memo As %String(CAPTION = "备注", MAXLEN = 500) [ SqlColumnNumber = 44, SqlFieldName = MEMO ];

/// 44 版本号	VER	VARCHAR	20	是
Property Ver As %String(CAPTION = "版本号", MAXLEN = 30) [ SqlColumnNumber = 45, SqlFieldName = VER ];

/// 45 版本名称	VER_NAME	VARCHAR	30	是
Property VerName As %String(CAPTION = "版本名称", MAXLEN = 30) [ SqlColumnNumber = 46, SqlFieldName = VER_NAME ];

/// 46 传输数据 ID  TRAM_DATA_ID   VARCHAR	40  否
Property TramDataId As %String(CAPTION = "传输数据 ID", MAXLEN = 40) [ SqlColumnNumber = 47, SqlFieldName = TRAM_DATA_ID ];

/// 47 HIS批次	HIS_BATCH	字符型	30	否
Property HisBatch As %String(CAPTION = "HIS批次", MAXLEN = 30) [ SqlColumnNumber = 48, SqlFieldName = HIS_BATCH ];

/// 48 HIS创建人	HIS_CRTER_ID	字符型	30	否
Property HisCrterId As %String(CAPTION = "HIS创建人", MAXLEN = 30) [ SqlColumnNumber = 49, SqlFieldName = HIS_CRTER_ID ];

/// 49 HIS创建日期	HIS_CRTE_DATE	日期
Property HisCrteDate As %Library.Date(CAPTION = "HIS创建日期") [ SqlColumnNumber = 50, SqlFieldName = HIS_CRTE_DATE ];

/// 50 HIS创建时间	HIS_CRTE_TIME	时间	
Property HisCrteTime As %Library.Time(CAPTION = "HIS创建时间") [ SqlColumnNumber = 51, SqlFieldName = HIS_CRTE_TIME ];

/// 51 HIS更新人ID	HIS_UPDT_ID	字符型
Property HisUpdtId As %String(CAPTION = "HIS更新人ID", MAXLEN = 30) [ SqlColumnNumber = 52, SqlFieldName = HIS_UPDT_ID ];

/// 52 HIS更新日期	HIS_UPDT_DATE	日期
Property HisUpdtDate As %Library.Date(CAPTION = "HIS更新日期") [ SqlColumnNumber = 53, SqlFieldName = HIS_UPDT_DATE ];

/// 53 HIS更新时间	HIS_UPDT_TIME	时间	
Property HisUpdtTime As %Library.Time(CAPTION = "HIS更新时间") [ SqlColumnNumber = 54, SqlFieldName = HIS_UPDT_TIME ];

/// 索引 中药配方颗粒代码
Index IdxTcmfParcCode On (HospId As Exact, TcmfParcCode As Exact);

/// 索引 中药配方颗粒名称
Index IdxTcmfParcName On (HospId As Exact, TcmfParcName As Exact);

/// 索引 中药中药饮片代码
Index IdxTmdpCode On (HospId As Exact, TmdpCode As Exact);

/// 索引 中药中药饮片名称
Index IdxTmdpName On (HospId As Exact, TmdpName As Exact);

/// 索引 HIS下载批次
Index IdxHISBATCH On (HospId As Exact, HisBatch As Exact);

/// 索引 HIS创建日期
Index IdxHisCrteDate On (HospId As Exact, HisCrteDate As Exact);

/// 索引HIS更新日期
Index IdxHisUpdtDate On (HospId As Exact, HisUpdtDate As Exact);

Storage Default
{
<Data name="TcmfParcProdDefaultData">
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
<Value>TcmFParcId</Value>
</Value>
<Value name="5">
<Value>TcmfParcCode</Value>
</Value>
<Value name="6">
<Value>TcmfParcName</Value>
</Value>
<Value name="7">
<Value>MinUnt</Value>
</Value>
<Value name="8">
<Value>Fard</Value>
</Value>
<Value name="9">
<Value>Spec</Value>
</Value>
<Value name="10">
<Value>TcmfParcPacspec</Value>
</Value>
<Value name="11">
<Value>Shlf</Value>
</Value>
<Value name="12">
<Value>ProdentpName</Value>
</Value>
<Value name="13">
<Value>ProdentpAddr</Value>
</Value>
<Value name="14">
<Value>LstdFilNo</Value>
</Value>
<Value name="15">
<Value>LstdFilTime</Value>
</Value>
<Value name="16">
<Value>LstdFilStas</Value>
</Value>
<Value name="17">
<Value>LstdFilPlaceOrg</Value>
</Value>
<Value name="18">
<Value>LstdFilInfo</Value>
</Value>
<Value name="19">
<Value>TcmfParcExestd</Value>
</Value>
<Value name="20">
<Value>Exestd</Value>
</Value>
<Value name="21">
<Value>TcmfParcExestdElecDoc</Value>
</Value>
<Value name="22">
<Value>DefsExamInfo</Value>
</Value>
<Value name="23">
<Value>TmdpCode</Value>
</Value>
<Value name="24">
<Value>TmdpName</Value>
</Value>
<Value name="25">
<Value>MlmsName</Value>
</Value>
<Value name="26">
<Value>EcyType</Value>
</Value>
<Value name="27">
<Value>EfccAtd</Value>
</Value>
<Value name="28">
<Value>CnvlUsed</Value>
</Value>
<Value name="29">
<Value>TmdpExestd</Value>
</Value>
<Value name="30">
<Value>ProdentpUscc</Value>
</Value>
<Value name="31">
<Value>IsuFlag</Value>
</Value>
<Value name="32">
<Value>ValiFlag</Value>
</Value>
<Value name="33">
<Value>Rid</Value>
</Value>
<Value name="34">
<Value>UpdtTime</Value>
</Value>
<Value name="35">
<Value>CrterId</Value>
</Value>
<Value name="36">
<Value>CrterName</Value>
</Value>
<Value name="37">
<Value>CrteTime</Value>
</Value>
<Value name="38">
<Value>CrteOptinsNo</Value>
</Value>
<Value name="39">
<Value>OpterId</Value>
</Value>
<Value name="40">
<Value>OpterName</Value>
</Value>
<Value name="41">
<Value>OptTime</Value>
</Value>
<Value name="42">
<Value>OptinsNo</Value>
</Value>
<Value name="43">
<Value>Admdvs</Value>
</Value>
<Value name="44">
<Value>Memo</Value>
</Value>
<Value name="45">
<Value>Ver</Value>
</Value>
<Value name="46">
<Value>VerName</Value>
</Value>
<Value name="47">
<Value>TramDataId</Value>
</Value>
<Value name="48">
<Value>HisBatch</Value>
</Value>
<Value name="49">
<Value>HisCrterId</Value>
</Value>
<Value name="50">
<Value>HisCrteDate</Value>
</Value>
<Value name="51">
<Value>HisCrteTime</Value>
</Value>
<Value name="52">
<Value>HisUpdtId</Value>
</Value>
<Value name="53">
<Value>HisUpdtDate</Value>
</Value>
<Value name="54">
<Value>HisUpdtTime</Value>
</Value>
</Data>
<DataLocation>^CT.INSU.MI.TcmfParcProdD</DataLocation>
<DefaultData>TcmfParcProdDefaultData</DefaultData>
<IdLocation>^CT.INSU.MI.TcmfParcProdD</IdLocation>
<IndexLocation>^CT.INSU.MI.TcmfParcProdI</IndexLocation>
<StreamLocation>^CT.INSU.MI.TcmfParcProdS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
