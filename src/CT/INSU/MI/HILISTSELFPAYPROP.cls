/// 1319	医保目录先自付比例信息下载
Class CT.INSU.MI.HILISTSELFPAYPROP Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = Rowid ]
{

/// 1 医院ID	HOSP_ID	VARCHAR	30	否
Property HospId As %String(CAPTION = "医院ID", MAXLEN = 6) [ SqlColumnNumber = 2, SqlFieldName = HOSP_ID ];

/// 2 医保类型	HI_TYPE	VARCHAR	30	否
Property HiType As %String(CAPTION = "医保类型", MAXLEN = 10) [ SqlColumnNumber = 3, SqlFieldName = HI_TYPE ];

/// 3 医保目录编码	HILIST_CODE	VARCHAR	30	是
Property HilistCode As %String(CAPTION = "医保目录编码", MAXLEN = 30) [ SqlColumnNumber = 4, SqlFieldName = HILIST_CODE ];

/// 4 医保目录自付比例人员类别	SELFPAY_PROP_PSN_TYPE	DATE	6	是
Property SelfpayPropPsnType As %String(CAPTION = "医保目录自付比例人员类别", MAXLEN = 6) [ SqlColumnNumber = 5, SqlFieldName = SELFPAY_PROP_PSN_TYPE ];

/// 5 目录自付比例类别	SELFPAY_PROP_TYPE	VARCHAR	6	是
Property SelfpayPropType As %String(CAPTION = "目录自付比例类别", MAXLEN = 6) [ SqlColumnNumber = 6, SqlFieldName = SELFPAY_PROP_TYPE ];

/// 6 参保机构医保区划	INSU_ADMDVS	VARCHAR	6	是
Property InsuAdmdvs As %String(CAPTION = "参保机构医保区划", MAXLEN = 6) [ SqlColumnNumber = 7, SqlFieldName = INSU_ADMDVS ];

/// 7 开始日期	BEGNDATE	DATE		是
Property Begndate As %String(CAPTION = "开始日期", MAXLEN = 20) [ SqlColumnNumber = 8, SqlFieldName = BEGNDATE ];

/// 8 结束日期	ENDDATE	DATE		否
Property Enddate As %String(CAPTION = "结束日期", MAXLEN = 20) [ SqlColumnNumber = 9, SqlFieldName = ENDDATE ];

/// 9 自付比例	SELFPAY_PROP	DECIMAL	5	是
Property SelfpayProp As %String(CAPTION = "自付比例", MAXLEN = 5) [ SqlColumnNumber = 10, SqlFieldName = SELFPAY_PROP ];

/// 10 有效标志	VALI_FLAG	VARCHAR	3	是
Property ValiFlag As %String(CAPTION = "有效标志", MAXLEN = 4) [ SqlColumnNumber = 11, SqlFieldName = VALI_FLAG ];

/// 11 唯一记录号	RID	VARCHAR	40	是
Property Rid As %String(CAPTION = "唯一记录号", MAXLEN = 40) [ SqlColumnNumber = 12, SqlFieldName = RID ];

/// 12 更新时间	UPDT_TIME	DATE		是
Property UpdtTime As %String(CAPTION = "更新时间", MAXLEN = 30) [ SqlColumnNumber = 13, SqlFieldName = UPDT_TIME ];

/// 13 创建人	CRTER_ID	VARCHAR	20	否
Property CrterId As %String(CAPTION = "创建人", MAXLEN = 20) [ SqlColumnNumber = 14, SqlFieldName = CRTER_ID ];

/// 14 创建人姓名	CRTER_NAME	VARCHAR	50	否
Property CrterName As %String(CAPTION = "创建人姓名", MAXLEN = 50) [ SqlColumnNumber = 15, SqlFieldName = CRTER_NAME ];

/// 15 创建时间	CRTE_TIME	DATE		是
Property CrteTime As %String(CAPTION = "创建时间", MAXLEN = 20) [ SqlColumnNumber = 16, SqlFieldName = CRTE_TIME ];

/// 16 创建机构	CRTE_OPTINS_NO	VARCHAR	20	否
Property CrteOptinsNo As %String(CAPTION = "创建机构", MAXLEN = 20) [ SqlColumnNumber = 17, SqlFieldName = CRTE_OPTINS_NO ];

/// 17 经办人	OPTER_ID	VARCHAR	20	否
Property OpterId As %String(CAPTION = "经办人", MAXLEN = 20) [ SqlColumnNumber = 18, SqlFieldName = OPTER_ID ];

/// 18 经办人姓名	OPTER_NAME	VARCHAR	50	否
Property OpterName As %String(CAPTION = "经办人姓名", MAXLEN = 50) [ SqlColumnNumber = 19, SqlFieldName = OPTER_NAME ];

/// 19 经办时间	OPT_TIME	DATE		否
Property OptTime As %String(CAPTION = "经办时间", MAXLEN = 20) [ SqlColumnNumber = 20, SqlFieldName = OPT_TIME ];

/// 20 经办机构	OPTINS_NO	VARCHAR	20	否
Property OptinsNo As %String(CAPTION = "经办机构", MAXLEN = 20) [ SqlColumnNumber = 21, SqlFieldName = OPTINS_NO ];

/// 21 表名	TABNAME	VARCHAR	100	否
Property Tabname As %String(CAPTION = "表名", MAXLEN = 100) [ SqlColumnNumber = 22, SqlFieldName = TABNAME ];

/// 22 统筹区	POOLAREA_NO	VARCHAR	6	否
Property PoolareaNo As %String(CAPTION = "统筹区", MAXLEN = 6) [ SqlColumnNumber = 23, SqlFieldName = POOLAREA_NO ];

/// 23 HIS批次	HIS_BATCH	字符型	30	否
Property HisBatch As %String(CAPTION = "HIS批次", MAXLEN = 30) [ SqlColumnNumber = 24, SqlFieldName = HIS_BATCH ];

/// 24 HIS创建人	HIS_CRTER_ID	字符型	30	否
Property HisCrterId As %String(CAPTION = "HIS创建人", MAXLEN = 30) [ SqlColumnNumber = 25, SqlFieldName = HIS_CRTER_ID ];

/// 25 HIS创建日期	HIS_CRTE_DATE	日期
Property HisCrteDate As %Library.Date(CAPTION = "HIS创建日期") [ SqlColumnNumber = 26, SqlFieldName = HIS_CRTE_DATE ];

/// 26 HIS创建时间	HIS_CRTE_TIME	时间	
Property HisCrteTime As %Library.Time(CAPTION = "HIS创建时间") [ SqlColumnNumber = 27, SqlFieldName = HIS_CRTE_TIME ];

/// 27 HIS更新人ID	HIS_UPDT_ID	字符型
Property HisUpdtId As %String(CAPTION = "HIS更新人ID", MAXLEN = 30) [ SqlColumnNumber = 28, SqlFieldName = HIS_UPDT_ID ];

/// 28 HIS更新日期	HIS_UPDT_DATE	日期
Property HisUpdtDate As %String(CAPTION = "HIS更新日期", MAXLEN = 20) [ SqlColumnNumber = 29, SqlFieldName = HIS_UPDT_DATE ];

/// 29 HIS更新时间	HIS_UPDT_TIME	时间	
Property HisUpdtTime As %String(CAPTION = "HIS更新时间", MAXLEN = 20) [ SqlColumnNumber = 30, SqlFieldName = HIS_UPDT_TIME ];

/// 索引 HIS批次
Index IdxHisBatch On (HospId As Exact, HisBatch As Exact);

/// 索引 HIS创建日期
Index IdxHisCrteDate On (HospId As Exact, HisCrteDate As Exact);

/// 索引HIS更新日期
Index IdxHisUpdtDate On (HospId As Exact, HisUpdtDate As Exact);

/// 索引医保目录编码
Index IdxHilistCode On (HospId As Exact, HilistCode As Exact);

Storage Default
{
<Data name="HILISTSELFPAYPROPDefaultData">
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
<Value>SelfpayPropPsnType</Value>
</Value>
<Value name="6">
<Value>SelfpayPropType</Value>
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
<Value>SelfpayProp</Value>
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
<Value>Tabname</Value>
</Value>
<Value name="23">
<Value>PoolareaNo</Value>
</Value>
<Value name="24">
<Value>HisBatch</Value>
</Value>
<Value name="25">
<Value>HisCrterId</Value>
</Value>
<Value name="26">
<Value>HisCrteDate</Value>
</Value>
<Value name="27">
<Value>HisCrteTime</Value>
</Value>
<Value name="28">
<Value>HisUpdtId</Value>
</Value>
<Value name="29">
<Value>HisUpdtDate</Value>
</Value>
<Value name="30">
<Value>HisUpdtTime</Value>
</Value>
</Data>
<DataLocation>^CT.INSU.MI.HILISTSELFPAYPROPD</DataLocation>
<DefaultData>HILISTSELFPAYPROPDefaultData</DefaultData>
<IdLocation>^CT.INSU.MI.HILISTSELFPAYPROPD</IdLocation>
<IndexLocation>^CT.INSU.MI.HILISTSELFPAYPROPI</IndexLocation>
<StreamLocation>^CT.INSU.MI.HILISTSELFPAYPROPS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
