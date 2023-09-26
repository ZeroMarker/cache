/// 1317	医药机构目录匹配信息表
Class CT.INSU.MI.MEDINSLISTMAP Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = Rowid ]
{

/// 1 医院ID	HOSP_ID	VARCHAR	30	否
Property HospId As %String(CAPTION = "医院ID", MAXLEN = 6) [ SqlColumnNumber = 2, SqlFieldName = HOSP_ID ];

/// 2 医保类型	HI_TYPE	VARCHAR	30	否
Property HiType As %String(CAPTION = "医保类型", MAXLEN = 10) [ SqlColumnNumber = 3, SqlFieldName = HI_TYPE ];

/// 3 定点医药机构编号	FIXMEDINS_CODE	VARCHAR	30	否
Property FixmedinsCode As %String(CAPTION = "定点医药机构编号", MAXLEN = 30) [ SqlColumnNumber = 4, SqlFieldName = FIXMEDINS_CODE ];

/// 4 定点医药机构目录编号	MEDINS_LIST_CODG	VARCHAR	150	否
Property MedinsListCodg As %String(CAPTION = "定点医药机构目录编号", MAXLEN = 150) [ SqlColumnNumber = 5, SqlFieldName = MEDINS_LIST_CODG ];

/// 5 定点医药机构目录名称	MEDINS_LIST_NAME	VARCHAR	100	否
Property MedinsListName As %String(CAPTION = "定点医药机构目录名称", MAXLEN = 100) [ SqlColumnNumber = 6, SqlFieldName = MEDINS_LIST_NAME ];

/// 6 参保机构医保区划	INSU_ADMDVS	VARCHAR	6	否
Property InsuAdmdvs As %String(CAPTION = "参保机构医保区划", MAXLEN = 6) [ SqlColumnNumber = 7, SqlFieldName = INSU_ADMDVS ];

/// 7 目录类别	LIST_TYPE	VARCHAR	6	否
Property ListType As %String(CAPTION = "目录类别", MAXLEN = 6) [ SqlColumnNumber = 8, SqlFieldName = LIST_TYPE ];

/// 8 医疗目录编码	MED_LIST_CODG	VARCHAR	50	否
Property MedListCodg As %String(CAPTION = "医疗目录编码", MAXLEN = 50) [ SqlColumnNumber = 9, SqlFieldName = MED_LIST_CODG ];

/// 9 开始日期	BEGNDATE	DATE		否
Property Begndate As %String(CAPTION = "开始日期", MAXLEN = 20) [ SqlColumnNumber = 10, SqlFieldName = BEGNDATE ];

/// 10 结束日期	ENDDATE	DATE		是
Property Enddate As %String(CAPTION = "结束日期", MAXLEN = 20) [ SqlColumnNumber = 11, SqlFieldName = ENDDATE ];

/// 11 批准文号	APRVNO	VARCHAR	100	是
Property Aprvno As %String(CAPTION = "批准文号", MAXLEN = 100) [ SqlColumnNumber = 12, SqlFieldName = APRVNO ];

/// 12 剂型	DOSFORM	VARCHAR	255	是
Property Dosform As %String(CAPTION = "剂型", MAXLEN = 255) [ SqlColumnNumber = 13, SqlFieldName = DOSFORM ];

/// 13 除外内容	EXCT_CONT	VARCHAR	2000	是
Property ExctCont As %String(CAPTION = "除外内容", MAXLEN = 2000) [ SqlColumnNumber = 14, SqlFieldName = EXCT_CONT ];

/// 14 项目内涵	ITEM_CONT	VARCHAR	2000	是
Property ItemCont As %String(CAPTION = "项目内涵", MAXLEN = 2000) [ SqlColumnNumber = 15, SqlFieldName = ITEM_CONT ];

/// 15 计价单位	PRCUNT	VARCHAR	100	是
Property Prcunt As %String(CAPTION = "计价单位", MAXLEN = 100) [ SqlColumnNumber = 16, SqlFieldName = PRCUNT ];

/// 16 规格	SPEC	VARCHAR	200	是
Property Spec As %String(CAPTION = "规格", MAXLEN = 200) [ SqlColumnNumber = 17, SqlFieldName = SPEC ];

/// 17 包装规格	PACSPEC	VARCHAR	100	是
Property Pacspec As %String(CAPTION = "包装规格", MAXLEN = 100) [ SqlColumnNumber = 18, SqlFieldName = PACSPEC ];

/// 18 备注	MEMO	LONGTEXT		是
Property Memo As %String(CAPTION = "备注", MAXLEN = 500) [ SqlColumnNumber = 19, SqlFieldName = MEMO ];

/// 19 有效标志	VALI_FLAG	VARCHAR	3	否
Property ValiFlag As %String(CAPTION = "有效标志", MAXLEN = 4) [ SqlColumnNumber = 20, SqlFieldName = VALI_FLAG ];

/// 20 唯一记录号	RID	VARCHAR	40	否
Property Rid As %String(CAPTION = "唯一记录号", MAXLEN = 40) [ SqlColumnNumber = 21, SqlFieldName = RID ];

/// 21 更新时间	UPDT_TIME	DATETIME		否
Property UpdtTime As %String(CAPTION = "更新时间", MAXLEN = 30) [ SqlColumnNumber = 22, SqlFieldName = UPDT_TIME ];

/// 22 创建人	CRTER_ID	VARCHAR	20	是
Property CrterId As %String(CAPTION = "创建人", MAXLEN = 20) [ SqlColumnNumber = 23, SqlFieldName = CRTER_ID ];

/// 23 创建人姓名	CRTER_NAME	VARCHAR	50	是
Property CrterName As %String(CAPTION = "创建人姓名", MAXLEN = 50) [ SqlColumnNumber = 24, SqlFieldName = CRTER_NAME ];

/// 24 创建时间	CRTE_TIME	DATETIME		否
Property CrteTime As %String(CAPTION = "创建时间", MAXLEN = 20) [ SqlColumnNumber = 25, SqlFieldName = CRTE_TIME ];

/// 25 创建机构	CRTE_OPTINS_NO	VARCHAR	20	是
Property CrteOptinsNo As %String(CAPTION = "创建机构", MAXLEN = 20) [ SqlColumnNumber = 26, SqlFieldName = CRTE_OPTINS_NO ];

/// 26 经办人	OPTER_ID	VARCHAR	20	是
Property OpterId As %String(CAPTION = "经办人", MAXLEN = 20) [ SqlColumnNumber = 27, SqlFieldName = OPTER_ID ];

/// 27 经办人姓名	OPTER_NAME	VARCHAR	50	是
Property OpterName As %String(CAPTION = "经办人姓名", MAXLEN = 50) [ SqlColumnNumber = 28, SqlFieldName = OPTER_NAME ];

/// 28 经办时间	OPT_TIME	DATETIME		是
Property OptTime As %String(CAPTION = "经办时间", MAXLEN = 20) [ SqlColumnNumber = 29, SqlFieldName = OPT_TIME ];

/// 29 经办机构	OPTINS_NO	VARCHAR	20	是
Property OptinsNo As %String(CAPTION = "经办机构", MAXLEN = 20) [ SqlColumnNumber = 30, SqlFieldName = OPTINS_NO ];

/// 30 统筹区	POOLAREA_NO	VARCHAR	6	是
Property PoolareaNo As %String(CAPTION = "统筹区", MAXLEN = 6) [ SqlColumnNumber = 31, SqlFieldName = POOLAREA_NO ];

/// 31 HIS批次	HIS_BATCH	字符型	30	否
Property HisBatch As %String(CAPTION = "HIS批次", MAXLEN = 30) [ SqlColumnNumber = 32, SqlFieldName = HIS_BATCH ];

/// 32 HIS创建人	HIS_CRTER_ID	字符型	30	否
Property HisCrterId As %String(CAPTION = "HIS创建人", MAXLEN = 30) [ SqlColumnNumber = 33, SqlFieldName = HIS_CRTER_ID ];

/// 33 HIS创建日期	HIS_CRTE_DATE	日期
Property HisCrteDate As %Library.Date(CAPTION = "HIS创建日期") [ SqlColumnNumber = 34, SqlFieldName = HIS_CRTE_DATE ];

/// 34 HIS创建时间	HIS_CRTE_TIME	时间	
Property HisCrteTime As %Library.Time(CAPTION = "HIS创建时间") [ SqlColumnNumber = 35, SqlFieldName = HIS_CRTE_TIME ];

/// 35 HIS更新人ID	HIS_UPDT_ID	字符型
Property HisUpdtId As %String(CAPTION = "HIS更新人ID", MAXLEN = 30) [ SqlColumnNumber = 36, SqlFieldName = HIS_UPDT_ID ];

/// 36 HIS更新日期	HIS_UPDT_DATE	日期
Property HisUpdtDate As %String(CAPTION = "HIS更新日期", MAXLEN = 20) [ SqlColumnNumber = 37, SqlFieldName = HIS_UPDT_DATE ];

/// 37 HIS更新时间	HIS_UPDT_TIME	时间	
Property HisUpdtTime As %String(CAPTION = "HIS更新时间", MAXLEN = 20) [ SqlColumnNumber = 38, SqlFieldName = HIS_UPDT_TIME ];

/// 索引 HIS批次
Index IdxHisBatch On (HospId As Exact, HisBatch As Exact);

/// 索引 HIS创建日期
Index IdxHisCrteDate On (HospId As Exact, HisCrteDate As Exact);

/// 索引HIS更新日期
Index IdxHisUpdtDate On (HospId As Exact, HisUpdtDate As Exact);

/// 索引定点医药机构目录编号
Index IdxMedinsListCodg On (HospId As Exact, MedinsListCodg As Exact);

/// 索引定点医药机构目录名称
Index IdxMedinsListName On (HospId As Exact, MedinsListName As Exact);

Storage Default
{
<Data name="MEDINSLISTMAPDefaultData">
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
<Value>FixmedinsCode</Value>
</Value>
<Value name="5">
<Value>MedinsListCodg</Value>
</Value>
<Value name="6">
<Value>MedinsListName</Value>
</Value>
<Value name="7">
<Value>InsuAdmdvs</Value>
</Value>
<Value name="8">
<Value>ListType</Value>
</Value>
<Value name="9">
<Value>MedListCodg</Value>
</Value>
<Value name="10">
<Value>Begndate</Value>
</Value>
<Value name="11">
<Value>Enddate</Value>
</Value>
<Value name="12">
<Value>Aprvno</Value>
</Value>
<Value name="13">
<Value>Dosform</Value>
</Value>
<Value name="14">
<Value>ExctCont</Value>
</Value>
<Value name="15">
<Value>ItemCont</Value>
</Value>
<Value name="16">
<Value>Prcunt</Value>
</Value>
<Value name="17">
<Value>Spec</Value>
</Value>
<Value name="18">
<Value>Pacspec</Value>
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
<Value>OptinsNo</Value>
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
<DataLocation>^CT.INSU.MI.MEDINSLISTMAPD</DataLocation>
<DefaultData>MEDINSLISTMAPDefaultData</DefaultData>
<IdLocation>^CT.INSU.MI.MEDINSLISTMAPD</IdLocation>
<IndexLocation>^CT.INSU.MI.MEDINSLISTMAPI</IndexLocation>
<StreamLocation>^CT.INSU.MI.MEDINSLISTMAPS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
