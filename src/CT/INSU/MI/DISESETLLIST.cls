/// 1310	按病种付费病种目录
Class CT.INSU.MI.DISESETLLIST Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = Rowid ]
{

/// 1 医院ID	HOSP_ID	VARCHAR	30	否
Property HospId As %String(CAPTION = "医院ID", MAXLEN = 6) [ SqlColumnNumber = 2, SqlFieldName = HOSP_ID ];

/// 2 医保类型	HI_TYPE	VARCHAR	30	否
Property HiType As %String(CAPTION = "医保类型", MAXLEN = 10) [ SqlColumnNumber = 3, SqlFieldName = HI_TYPE ];

/// 3 病种结算目录ID	DISE_SETL_LIST_ID	VARCHAR	40	否
Property DiseSetlListId As %String(CAPTION = "病种结算目录ID", MAXLEN = 40) [ SqlColumnNumber = 4, SqlFieldName = DISE_SETL_LIST_ID ];

/// 4 按病种结算病种目录代码	BYDISE_SETL_LIST_CODE	VARCHAR	30	否
Property BydiseSetlListCode As %String(CAPTION = "按病种结算病种目录代码", MAXLEN = 30) [ SqlColumnNumber = 5, SqlFieldName = BYDISE_SETL_LIST_CODE ];

/// 5 按病种结算病种名称	BYDISE_SETL_DISE_NAME	VARCHAR	500	是
Property BydiseSetlDiseName As %String(CAPTION = "按病种结算病种名称", MAXLEN = 500) [ SqlColumnNumber = 6, SqlFieldName = BYDISE_SETL_DISE_NAME ];

/// 6 限定手术操作代码	QUA_OPRN_OPRT_CODE	VARCHAR	200	否
Property QuaOprnOprtCode As %String(CAPTION = "限定手术操作代码", MAXLEN = 30) [ SqlColumnNumber = 7, SqlFieldName = QUA_OPRN_OPRT_CODE ];

/// 7 限定手术操作名称	QUA_OPRN_OPRT_NAME	VARCHAR	500	否
Property QuaOprnOprtName As %String(CAPTION = "限定手术操作名称", MAXLEN = 500) [ SqlColumnNumber = 8, SqlFieldName = QUA_OPRN_OPRT_NAME ];

/// 8 有效标志	VALI_FLAG	VARCHAR	3	是
Property ValiFlag As %String(CAPTION = "有效标志", MAXLEN = 4) [ SqlColumnNumber = 9, SqlFieldName = VALI_FLAG ];

/// 9 唯一记录号	RID	VARCHAR	40	否
Property Rid As %String(CAPTION = "唯一记录号", MAXLEN = 40) [ SqlColumnNumber = 10, SqlFieldName = RID ];

/// 10 数据创建时间	CRTE_TIME	DATETIME	0	否
Property CrteTime As %String(CAPTION = "数据创建时间", MAXLEN = 30) [ SqlColumnNumber = 11, SqlFieldName = CRTE_TIME ];

/// 11 数据更新时间	UPDT_TIME	DATETIME	0	否
Property UpdtTime As %String(CAPTION = "数据更新时间", MAXLEN = 30) [ SqlColumnNumber = 12, SqlFieldName = UPDT_TIME ];

/// 12 版本号	VER	VARCHAR	20	否
Property Ver As %String(CAPTION = "版本号", MAXLEN = 20) [ SqlColumnNumber = 13, SqlFieldName = VER ];

/// 13 病种内涵	DISE_CONT	TEXT	0	是
Property DiseCont As %String(CAPTION = "病种内涵", MAXLEN = 10000) [ SqlColumnNumber = 14, SqlFieldName = DISE_CONT ];

/// 14 备注	MEMO	LONGTEXT	0	是
Property Memo As %String(CAPTION = "备注", MAXLEN = 500) [ SqlColumnNumber = 15, SqlFieldName = MEMO ];

/// 15 版本名称	VER_NAME	VARCHAR	30	是
Property VerName As %String(CAPTION = "版本名称", MAXLEN = 30) [ SqlColumnNumber = 16, SqlFieldName = VER_NAME ];

/// 16 诊疗指南页码	TRT_GUIDE_PAGEN	VARCHAR	255	是
Property TrtGuidePagen As %String(CAPTION = "诊疗指南页码", MAXLEN = 255) [ SqlColumnNumber = 17, SqlFieldName = TRT_GUIDE_PAGEN ];

/// 17 诊疗指南电子档案	TRT_GUIDE_ELECACS	VARCHAR	500	是
Property TrtGuideElecacs As %String(CAPTION = "诊疗指南电子档案", MAXLEN = 200) [ SqlColumnNumber = 18, SqlFieldName = TRT_GUIDE_ELECACS ];

/// 18 HIS批次	HIS_BATCH	字符型	30	否
Property HisBatch As %String(CAPTION = "HIS批次", MAXLEN = 30) [ SqlColumnNumber = 19, SqlFieldName = HIS_BATCH ];

/// 19 HIS创建人	HIS_CRTER_ID	字符型	30	否
Property HisCrterId As %String(CAPTION = "HIS创建人", MAXLEN = 30) [ SqlColumnNumber = 20, SqlFieldName = HIS_CRTER_ID ];

/// 20 HIS创建日期	HIS_CRTE_DATE	日期
Property HisCrteDate As %Library.Date(CAPTION = "HIS创建日期") [ SqlColumnNumber = 21, SqlFieldName = HIS_CRTE_DATE ];

/// 21 HIS创建时间	HIS_CRTE_TIME	时间	
Property HisCrteTime As %Library.Time(CAPTION = "HIS创建时间") [ SqlColumnNumber = 22, SqlFieldName = HIS_CRTE_TIME ];

/// 22 HIS更新人ID	HIS_UPDT_ID	字符型
Property HisUpdtId As %String(CAPTION = "HIS更新人ID", MAXLEN = 30) [ SqlColumnNumber = 23, SqlFieldName = HIS_UPDT_ID ];

/// 23 HIS更新日期	HIS_UPDT_DATE	日期
Property HisUpdtDate As %String(CAPTION = "HIS更新日期", MAXLEN = 20) [ SqlColumnNumber = 24, SqlFieldName = HIS_UPDT_DATE ];

/// 24 HIS更新时间	HIS_UPDT_TIME	时间	
Property HisUpdtTime As %String(CAPTION = "HIS更新时间", MAXLEN = 20) [ SqlColumnNumber = 25, SqlFieldName = HIS_UPDT_TIME ];

/// 索引 HIS批次
Index IdxHisBatch On (HospId As Exact, HisBatch As Exact);

/// 索引 HIS创建日期
Index IdxHisCrteDate On (HospId As Exact, HisCrteDate As Exact);

/// 索引HIS更新日期
Index IdxHisUpdtDate On (HospId As Exact, HisUpdtDate As Exact);

/// 索引病种结算病种目录代码
Index IdxBydiseSetlListCode On (HospId As Exact, BydiseSetlListCode As Exact);

/// 索引病种结算病种名称
Index IdxBydiseSetlDiseName On (HospId As Exact, BydiseSetlDiseName As Exact);

Storage Default
{
<Data name="DISESETLLISTDefaultData">
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
<Value>DiseSetlListId</Value>
</Value>
<Value name="5">
<Value>BydiseSetlListCode</Value>
</Value>
<Value name="6">
<Value>BydiseSetlDiseName</Value>
</Value>
<Value name="7">
<Value>QuaOprnOprtCode</Value>
</Value>
<Value name="8">
<Value>QuaOprnOprtName</Value>
</Value>
<Value name="9">
<Value>ValiFlag</Value>
</Value>
<Value name="10">
<Value>Rid</Value>
</Value>
<Value name="11">
<Value>CrteTime</Value>
</Value>
<Value name="12">
<Value>UpdtTime</Value>
</Value>
<Value name="13">
<Value>Ver</Value>
</Value>
<Value name="14">
<Value>DiseCont</Value>
</Value>
<Value name="15">
<Value>Memo</Value>
</Value>
<Value name="16">
<Value>VerName</Value>
</Value>
<Value name="17">
<Value>TrtGuidePagen</Value>
</Value>
<Value name="18">
<Value>TrtGuideElecacs</Value>
</Value>
<Value name="19">
<Value>HisBatch</Value>
</Value>
<Value name="20">
<Value>HisCrterId</Value>
</Value>
<Value name="21">
<Value>HisCrteDate</Value>
</Value>
<Value name="22">
<Value>HisCrteTime</Value>
</Value>
<Value name="23">
<Value>HisUpdtId</Value>
</Value>
<Value name="24">
<Value>HisUpdtDate</Value>
</Value>
<Value name="25">
<Value>HisUpdtTime</Value>
</Value>
</Data>
<DataLocation>^CT.INSU.MI.DISESETLLISTD</DataLocation>
<DefaultData>DISESETLLISTDefaultData</DefaultData>
<IdLocation>^CT.INSU.MI.DISESETLLISTD</IdLocation>
<IndexLocation>^CT.INSU.MI.DISESETLLISTI</IndexLocation>
<StreamLocation>^CT.INSU.MI.DISESETLLISTS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
