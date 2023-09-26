/// 1316	医疗目录与医保目录匹配信息查询
Class CT.INSU.MI.MEDLISTHILISTMAP Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = Rowid ]
{

/// 1 医院ID	HOSP_ID	VARCHAR	30	否
Property HospId As %String(CAPTION = "医院ID", MAXLEN = 6) [ SqlColumnNumber = 2, SqlFieldName = HOSP_ID ];

/// 2 医保类型	HI_TYPE	VARCHAR	30	否
Property HiType As %String(CAPTION = "医保类型", MAXLEN = 10) [ SqlColumnNumber = 3, SqlFieldName = HI_TYPE ];

/// 3 医疗目录编码	MED_LIST_CODG	VARCHAR	50
Property MedListCodg As %String(CAPTION = "医疗目录编码", MAXLEN = 50) [ SqlColumnNumber = 4, SqlFieldName = MED_LIST_CODG ];

/// 4 医保目录编码	HILIST_CODE	VARCHAR	50
Property HilistCode As %String(CAPTION = "医保目录编码", MAXLEN = 50) [ SqlColumnNumber = 5, SqlFieldName = HILIST_CODE ];

/// 5 目录类别	LIST_TYPE	VARCHAR	6
Property ListType As %String(CAPTION = "目录类别", MAXLEN = 6) [ SqlColumnNumber = 6, SqlFieldName = LIST_TYPE ];

/// 6 参保机构医保区划	INSU_ADMDVS	VARCHAR	6
Property InsuAdmdvs As %String(CAPTION = "参保机构医保区划", MAXLEN = 6) [ SqlColumnNumber = 7, SqlFieldName = INSU_ADMDVS ];

/// 7 开始日期	BEGNDATE	DATE	0
Property Begndate As %String(CAPTION = "开始日期", MAXLEN = 20) [ SqlColumnNumber = 8, SqlFieldName = BEGNDATE ];

/// 8 结束日期	ENDDATE	DATE	0
Property Enddate As %String(CAPTION = "结束日期", MAXLEN = 20) [ SqlColumnNumber = 9, SqlFieldName = ENDDATE ];

/// 9 备注	MEMO	LONGTEXT	0
Property Memo As %String(CAPTION = "备注", MAXLEN = 500) [ SqlColumnNumber = 10, SqlFieldName = MEMO ];

/// 10 有效标志	VALI_FLAG	VARCHAR	3
Property ValiFlag As %String(CAPTION = "有效标志", MAXLEN = 3) [ SqlColumnNumber = 11, SqlFieldName = VALI_FLAG ];

/// 11 唯一记录号	RID	VARCHAR	40
Property Rid As %String(CAPTION = "唯一记录号", MAXLEN = 40) [ SqlColumnNumber = 12, SqlFieldName = RID ];

/// 12 更新时间	UPDT_TIME	VARCHAR	
Property UpdtTime As %String(CAPTION = "更新时间", MAXLEN = 30) [ SqlColumnNumber = 13, SqlFieldName = UPDT_TIME ];

/// 13 创建人	CRTER_ID	VARCHAR	20
Property CrterId As %String(CAPTION = "创建人", MAXLEN = 20) [ SqlColumnNumber = 14, SqlFieldName = CRTER_ID ];

/// 14 创建人姓名	CRTER_NAME	VARCHAR	50
Property CrterName As %String(CAPTION = "创建人姓名", MAXLEN = 50) [ SqlColumnNumber = 15, SqlFieldName = CRTER_NAME ];

/// 15 创建时间	CRTE_TIME	VARCHAR	
Property CrteTime As %String(CAPTION = "创建时间", MAXLEN = 30) [ SqlColumnNumber = 16, SqlFieldName = CRTE_TIME ];

/// 16 创建机构	CRTE_OPTINS_NO	VARCHAR	20
Property CrteOptinsNo As %String(CAPTION = "创建机构", MAXLEN = 20) [ SqlColumnNumber = 17, SqlFieldName = CRTE_OPTINS_NO ];

/// 17 经办人	OPTER_ID	VARCHAR	20
Property OpterId As %String(CAPTION = "经办人", MAXLEN = 20) [ SqlColumnNumber = 18, SqlFieldName = OPTER_ID ];

/// 18 经办人姓名	OPTER_NAME	VARCHAR	50
Property OpterName As %String(CAPTION = "经办人姓名", MAXLEN = 50) [ SqlColumnNumber = 19, SqlFieldName = OPTER_NAME ];

/// 19 经办时间	OPT_TIME	DATETIME	0
Property OptTime As %String(CAPTION = "经办时间", MAXLEN = 20) [ SqlColumnNumber = 20, SqlFieldName = OPT_TIME ];

/// 20 经办机构	OPTINS_NO	VARCHAR	20
Property OptinsNo As %String(CAPTION = "经办机构", MAXLEN = 20) [ SqlColumnNumber = 21, SqlFieldName = OPTINS_NO ];

/// 21 统筹区	POOLAREA_NO	VARCHAR	6
Property PoolareaNo As %String(CAPTION = "统筹区", MAXLEN = 6) [ SqlColumnNumber = 22, SqlFieldName = POOLAREA_NO ];

/// 22 HIS批次	HIS_BATCH	字符型	30	否
Property HisBatch As %String(CAPTION = "HIS批次", MAXLEN = 30) [ SqlColumnNumber = 23, SqlFieldName = HIS_BATCH ];

/// 23 HIS创建人	HIS_CRTER_ID	字符型	30	否
Property HisCrterId As %String(CAPTION = "HIS创建人", MAXLEN = 30) [ SqlColumnNumber = 24, SqlFieldName = HIS_CRTER_ID ];

/// 24 HIS创建日期	HIS_CRTE_DATE	日期
Property HisCrteDate As %Library.Date(CAPTION = "HIS创建日期") [ SqlColumnNumber = 25, SqlFieldName = HIS_CRTE_DATE ];

/// 25 HIS创建时间	HIS_CRTE_TIME	时间	
Property HisCrteTime As %Library.Time(CAPTION = "HIS创建时间") [ SqlColumnNumber = 26, SqlFieldName = HIS_CRTE_TIME ];

/// 26 HIS更新人ID	HIS_UPDT_ID	字符型
Property HisUpdtId As %String(CAPTION = "HIS更新人ID", MAXLEN = 30) [ SqlColumnNumber = 27, SqlFieldName = HIS_UPDT_ID ];

/// 27 HIS更新日期	HIS_UPDT_DATE	日期
Property HisUpdtDate As %String(CAPTION = "HIS更新日期", MAXLEN = 20) [ SqlColumnNumber = 28, SqlFieldName = HIS_UPDT_DATE ];

/// 28 HIS更新时间	HIS_UPDT_TIME	时间	
Property HisUpdtTime As %String(CAPTION = "HIS更新时间", MAXLEN = 20) [ SqlColumnNumber = 29, SqlFieldName = HIS_UPDT_TIME ];

/// 索引 HIS批次
Index IdxHisBatch On (HospId As Exact, HisBatch As Exact);

/// 索引 HIS创建日期
Index IdxHisCrteDate On (HospId As Exact, HisCrteDate As Exact);

/// 索引HIS更新日期
Index IdxHisUpdtDate On (HospId As Exact, HisUpdtDate As Exact);

/// 索引医疗目录编码
Index IdxMedListCodg On (HospId As Exact, MedListCodg As Exact);

/// 索引医保目录编码
Index IdxHilistCode On (HospId As Exact, HilistCode As Exact);

Storage Default
{
<Data name="MEDLISTHILISTMAPDefaultData">
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
<Value>HilistCode</Value>
</Value>
<Value name="6">
<Value>ListType</Value>
</Value>
<Value name="7">
<Value>InsuAdmdvs</Value>
</Value>
<Value name="8">
<Value>Begndate</Value>
</Value>
<Value name="9">
<Value>Enddate</Value>
</Value>
<Value name="10">
<Value>Memo</Value>
</Value>
<Value name="11">
<Value>ValiFlag</Value>
</Value>
<Value name="12">
<Value>Rid</Value>
</Value>
<Value name="13">
<Value>UpdtTime</Value>
</Value>
<Value name="14">
<Value>CrterId</Value>
</Value>
<Value name="15">
<Value>CrterName</Value>
</Value>
<Value name="16">
<Value>CrteTime</Value>
</Value>
<Value name="17">
<Value>CrteOptinsNo</Value>
</Value>
<Value name="18">
<Value>OpterId</Value>
</Value>
<Value name="19">
<Value>OpterName</Value>
</Value>
<Value name="20">
<Value>OptTime</Value>
</Value>
<Value name="21">
<Value>OptinsNo</Value>
</Value>
<Value name="22">
<Value>PoolareaNo</Value>
</Value>
<Value name="23">
<Value>HisBatch</Value>
</Value>
<Value name="24">
<Value>HisCrterId</Value>
</Value>
<Value name="25">
<Value>HisCrteDate</Value>
</Value>
<Value name="26">
<Value>HisCrteTime</Value>
</Value>
<Value name="27">
<Value>HisUpdtId</Value>
</Value>
<Value name="28">
<Value>HisUpdtDate</Value>
</Value>
<Value name="29">
<Value>HisUpdtTime</Value>
</Value>
</Data>
<DataLocation>^CT.INSU.MI.MEDLISTHILISTMAPD</DataLocation>
<DefaultData>MEDLISTHILISTMAPDefaultData</DefaultData>
<IdLocation>^CT.INSU.MI.MEDLISTHILISTMAPD</IdLocation>
<IndexLocation>^CT.INSU.MI.MEDLISTHILISTMAPI</IndexLocation>
<StreamLocation>^CT.INSU.MI.MEDLISTHILISTMAPS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
