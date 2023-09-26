/// 医保目录信息查询
Class CT.INSU.MI.HIINFOLIST Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = Rowid ]
{

/// 1 医院ID	HOSP_ID	VARCHAR	30	否
Property HospId As %String(CAPTION = "医院ID", MAXLEN = 6) [ SqlColumnNumber = 2, SqlFieldName = HOSP_ID ];

/// 2 医保类型	HI_TYPE	VARCHAR	30	否
Property HiType As %String(CAPTION = "医保类型", MAXLEN = 10) [ SqlColumnNumber = 3, SqlFieldName = HI_TYPE ];

/// 3 医保目录编码	HILIST_CODE	VARCHAR	50	是	
Property HilistCode As %String(CAPTION = "医保目录编码", MAXLEN = 50) [ SqlColumnNumber = 4, SqlFieldName = HILIST_CODE ];

/// 4 医保目录名称	HILIST_NAME	VARCHAR	200	是
Property HilistName As %String(CAPTION = "医保目录名称", MAXLEN = 200) [ SqlColumnNumber = 5, SqlFieldName = HILIST_NAME ];

/// 5 参保机构医保区划	INSU_ADMDVS
Property InsuAdmdvs As %String(CAPTION = "参保机构医保区划", MAXLEN = 6) [ SqlColumnNumber = 6, SqlFieldName = INSU_ADMDVS ];

/// 6 开始日期	BEGNDATE	DATE	0	是	
Property Begndate As %String(CAPTION = "开始日期", MAXLEN = 20) [ SqlColumnNumber = 7, SqlFieldName = BEGNDATE ];

/// 7 结束日期	ENDDATE	DATE	0	否	
Property Enddate As %String(CAPTION = "结束日期", MAXLEN = 20) [ SqlColumnNumber = 8, SqlFieldName = ENDDATE ];

/// 8 医疗收费项目类别	MED_CHRGITM_TYPE	VARCHAR	6	否	
Property MedChrgItmType As %String(CAPTION = "医疗收费项目类别", MAXLEN = 6) [ SqlColumnNumber = 9, SqlFieldName = MED_CHRGITM_TYPE ];

/// 9 收费项目等级	CHRGITM_LV	VARCHAR	3	是	
Property ChrgitmLv As %String(CAPTION = "收费项目等级", MAXLEN = 4) [ SqlColumnNumber = 10, SqlFieldName = CHRGITM_LV ];

/// 10 限制使用标志	LMT_USED_FLAG	VARCHAR	3	是	
Property LmtUsedFlag As %String(CAPTION = "限制使用标志", MAXLEN = 4) [ SqlColumnNumber = 11, SqlFieldName = LMT_USED_FLAG ];

/// 11 目录类别	LIST_TYPE	VARCHAR	6	是	
Property ListType As %String(CAPTION = "目录类别", MAXLEN = 6) [ SqlColumnNumber = 12, SqlFieldName = LIST_TYPE ];

/// 12 医疗使用标志	MED_USE_FLAG	VARCHAR	3	否	
Property MedUseFlag As %String(CAPTION = "医疗使用标志", MAXLEN = 4) [ SqlColumnNumber = 13, SqlFieldName = MED_USE_FLAG ];

/// 13 生育使用标志	MATN_USED_FLAG	VARCHAR	3	是	
Property MatnUsedFlag As %String(CAPTION = "生育使用标志", MAXLEN = 4) [ SqlColumnNumber = 14, SqlFieldName = MATN_USED_FLAG ];

/// 14 医保目录使用类别	HILIST_USE_TYPE	VARCHAR	3	否
Property HilistUseType As %String(CAPTION = "医保目录使用类别", MAXLEN = 4) [ SqlColumnNumber = 15, SqlFieldName = HILIST_USE_TYPE ];

/// 15 限复方使用类型	LMT_CPND_TYPE	VARCHAR	3	否	
Property LmtCpndType As %String(CAPTION = "限复方使用类型", MAXLEN = 4) [ SqlColumnNumber = 16, SqlFieldName = LMT_CPND_TYPE ];

/// 16 五笔助记码	WUBI	VARCHAR	50	是		
Property Wubi As %String(CAPTION = "五笔助记码", MAXLEN = 30) [ SqlColumnNumber = 17, SqlFieldName = WUBI ];

/// 17 拼音助记码	PINYIN	VARCHAR	300	是	
Property Pinyin As %String(CAPTION = "拼音助记码", MAXLEN = 30) [ SqlColumnNumber = 18, SqlFieldName = PINYIN ];

/// 18 备注	MEMO	LONGTEXT	0	是	
Property Memo As %String(CAPTION = "备注", MAXLEN = 500) [ SqlColumnNumber = 19, SqlFieldName = MEMO ];

/// 19 有效标志	VALI_FLAG	VARCHAR	3	是
Property ValiFlag As %String(CAPTION = "有效标志", MAXLEN = 4) [ SqlColumnNumber = 20, SqlFieldName = VALI_FLAG ];

/// 20 数据唯一记录号	RID
Property Rid As %String(CAPTION = "数据唯一记录号", MAXLEN = 40) [ SqlColumnNumber = 21, SqlFieldName = RID ];

/// 21 数据更新时间	UPDT_TIME
Property UpdtTime As %String(CAPTION = "数据更新时间", MAXLEN = 30) [ SqlColumnNumber = 22, SqlFieldName = UPDT_TIME ];

/// 22 创建人ID	CRTER_ID
Property CrterId As %String(CAPTION = "创建人ID", MAXLEN = 30) [ SqlColumnNumber = 23, SqlFieldName = CRTER_ID ];

/// 23 创建人姓名	CRTER_NAME	VARCHAR	50	是
Property CrterName As %String(CAPTION = "创建人姓名", MAXLEN = 50) [ SqlColumnNumber = 24, SqlFieldName = CRTER_NAME ];

/// 24 数据创建时间	CRTE_TIME
Property CrteTime As %String(CAPTION = "数据创建时间", MAXLEN = 20) [ SqlColumnNumber = 25, SqlFieldName = CRTE_TIME ];

/// 25 创建机构编号	CRTE_OPTINS_NO
Property CrteOptinsNo As %String(CAPTION = "创建机构编号", MAXLEN = 50) [ SqlColumnNumber = 26, SqlFieldName = CRTE_OPTINS_NO ];

/// 26 经办人ID	OPTER_ID
Property OpterId As %String(CAPTION = "经办人ID", MAXLEN = 20) [ SqlColumnNumber = 27, SqlFieldName = OPTER_ID ];

/// 27 经办人姓名	OPTER_NAME	VARCHAR	50	是
Property OpterName As %String(CAPTION = "经办人姓名", MAXLEN = 50) [ SqlColumnNumber = 28, SqlFieldName = OPTER_NAME ];

/// 28 经办时间	OPT_TIME	DATETIME	0	是	
Property OptTime As %String(CAPTION = "经办时间", MAXLEN = 20) [ SqlColumnNumber = 29, SqlFieldName = OPT_TIME ];

/// 29 经办机构ID	OPTINS_ID
Property OptinsId As %String(CAPTION = "经办机构ID", MAXLEN = 50) [ SqlColumnNumber = 30, SqlFieldName = OPTINS_ID ];

/// 30 统筹区编号	POOLAREA_NO
Property PoolareaNo As %String(CAPTION = "统筹区编号", MAXLEN = 6) [ SqlColumnNumber = 31, SqlFieldName = POOLAREA_NO ];

/// 31 HIS下载批次	BATCH	VARCHAR	30	否 210322162500001
Property HisBatch As %String(CAPTION = "HIS下载批次", MAXLEN = 30) [ SqlColumnNumber = 32, SqlFieldName = HIS_BATCH ];

/// 32 HIS创建人 CRTER	VARCHAR	30	否
Property HisCrterId As %String(CAPTION = "HIS创建人", MAXLEN = 30) [ SqlColumnNumber = 33, SqlFieldName = HIS_CRTER_ID ];

/// 33 HIS创建日期	CRTE_DATE	日期	
Property HisCrteDate As %Library.Date(CAPTION = "HIS创建日期") [ SqlColumnNumber = 34, SqlFieldName = HIS_CRTE_DATE ];

/// 34 HIS创建时间	CRTE_TIME	时间		
Property HisCrteTime As %Library.Time(CAPTION = "HIS创建时间") [ SqlColumnNumber = 35, SqlFieldName = HIS_CRTE_TIME ];

/// 35 HIS更新人ID	UPDT_ID			
Property HisUpdtId As %String(CAPTION = "HIS更新人ID", MAXLEN = 30) [ SqlColumnNumber = 36, SqlFieldName = HIS_UPDT_ID ];

/// 36 HIS更新日期	UPDT_DATE	日期		
Property HisUpdtDate As %Library.Date(CAPTION = "HIS更新日期") [ SqlColumnNumber = 37, SqlFieldName = HIS_UPDT_DATE ];

/// 37 HIS更新时间	HISUPDT_ITIME	时间
Property HisUpdtTime As %Library.Time(CAPTION = "HIS更新时间") [ SqlColumnNumber = 38, SqlFieldName = HIS_UPDT_TIME ];

/// 索引 HIS下载批次
Index IdxHISBATCH On (HospId As Exact, HisBatch As Exact);

/// 索引 HIS创建日期
Index IdxHISCRTEDATE On (HospId As Exact, HisCrteDate As Exact);

/// 索引HIS更新日期
Index IdxHISUPDTDATE On (HospId As Exact, HisUpdtDate As Exact);

/// 索引医保目录编码	
Index IdxHILISTCODE On (HospId As Exact, HilistCode As Exact);

/// 索引医保目录名称
Index IdxHILISTNAME On (HospId As Exact, HilistName As Exact);

/// 索引五笔助记码
Index IdxWUBI On (HospId As Exact, Wubi As Exact);

/// 索引拼音助记码
Index IdxPINYIN On (HospId As Exact, Pinyin As Exact);

/// 索引 更新时间(医保中心更新时间)
Index IdxUpdtTime On (HospId As Exact, UpdtTime As SQLUPPER(11));

Storage Default
{
<Data name="HIINFOLISTDefaultData">
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
<Value>HilistCode</Value>
</Value>
<Value name="5">
<Value>HilistName</Value>
</Value>
<Value name="6">
<Value>InsuAdmdvs</Value>
</Value>
<Value name="7">
<Value>Begndate</Value>
</Value>
<Value name="8">
<Value>Enddate</Value>
</Value>
<Value name="9">
<Value>MedChrgItmType</Value>
</Value>
<Value name="10">
<Value>ChrgitmLv</Value>
</Value>
<Value name="11">
<Value>LmtUsedFlag</Value>
</Value>
<Value name="12">
<Value>ListType</Value>
</Value>
<Value name="13">
<Value>MedUseFlag</Value>
</Value>
<Value name="14">
<Value>MatnUsedFlag</Value>
</Value>
<Value name="15">
<Value>HilistUseType</Value>
</Value>
<Value name="16">
<Value>LmtCpndType</Value>
</Value>
<Value name="17">
<Value>Wubi</Value>
</Value>
<Value name="18">
<Value>Pinyin</Value>
</Value>
<Value name="19">
<Value>Memo</Value>
</Value>
<Value name="20">
<Value>ValiFlag</Value>
</Value>
<Value name="21">
<Value>Rid</Value>
</Value>
<Value name="22">
<Value>UpdtTime</Value>
</Value>
<Value name="23">
<Value>CrterId</Value>
</Value>
<Value name="24">
<Value>CrterName</Value>
</Value>
<Value name="25">
<Value>CrteTime</Value>
</Value>
<Value name="26">
<Value>CrteOptinsNo</Value>
</Value>
<Value name="27">
<Value>OpterId</Value>
</Value>
<Value name="28">
<Value>OpterName</Value>
</Value>
<Value name="29">
<Value>OptTime</Value>
</Value>
<Value name="30">
<Value>OptinsId</Value>
</Value>
<Value name="31">
<Value>PoolareaNo</Value>
</Value>
<Value name="32">
<Value>HisBatch</Value>
</Value>
<Value name="33">
<Value>HisCrterId</Value>
</Value>
<Value name="34">
<Value>HisCrteDate</Value>
</Value>
<Value name="35">
<Value>HisCrteTime</Value>
</Value>
<Value name="36">
<Value>HisUpdtId</Value>
</Value>
<Value name="37">
<Value>HisUpdtDate</Value>
</Value>
<Value name="38">
<Value>HisUpdtTime</Value>
</Value>
</Data>
<DataLocation>^CT.INSU.MI.HIINFOLISTD</DataLocation>
<DefaultData>HIINFOLISTDefaultData</DefaultData>
<IdLocation>^CT.INSU.MI.HIINFOLISTD</IdLocation>
<IndexLocation>^CT.INSU.MI.HIINFOLISTI</IndexLocation>
<StreamLocation>^CT.INSU.MI.HIINFOLISTS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
