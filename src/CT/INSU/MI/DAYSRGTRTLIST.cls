/// 1311	日间手术治疗病种目录
Class CT.INSU.MI.DAYSRGTRTLIST Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = Rowid ]
{

/// 1 医院ID	HOSP_ID	VARCHAR	30	否
Property HospId As %String(CAPTION = "医院ID", MAXLEN = 6) [ SqlColumnNumber = 2, SqlFieldName = HOSP_ID ];

/// 2 医保类型	HI_TYPE	VARCHAR	30	否
Property HiType As %String(CAPTION = "医保类型", MAXLEN = 10) [ SqlColumnNumber = 3, SqlFieldName = HI_TYPE ];

/// 3 日间手术治疗目录ID	DAYSRG_TRT_LIST_ID	VARCHAR	40	否
Property DaysrgTrtListId As %String(CAPTION = "日间手术治疗目录ID", MAXLEN = 40) [ SqlColumnNumber = 4, SqlFieldName = DAYSRG_TRT_LIST_ID ];

/// 4 日间手术病种目录代码	DAYSRG_DISE_LIST_CODE	VARCHAR	10	否
Property DaysrgDiseListCode As %String(CAPTION = "日间手术病种目录代码", MAXLEN = 30) [ SqlColumnNumber = 5, SqlFieldName = DAYSRG_DISE_LIST_CODE ];

/// 5 日间手术病种名称	DAYSRG_DISE_NAME	VARCHAR	500	是
Property DaysrgDiseName As %String(CAPTION = "日间手术病种名称", MAXLEN = 500) [ SqlColumnNumber = 6, SqlFieldName = DAYSRG_DISE_NAME ];

/// 6 有效标志	VALI_FLAG	VARCHAR	3	是
Property ValiFlag As %String(CAPTION = "有效标志", MAXLEN = 4) [ SqlColumnNumber = 7, SqlFieldName = VALI_FLAG ];

/// 7 唯一记录号	RID	VARCHAR	40	否
Property Rid As %String(CAPTION = "唯一记录号", MAXLEN = 40) [ SqlColumnNumber = 8, SqlFieldName = RID ];

/// 8 数据创建时间	CRTE_TIME	DATETIME	0	否
Property CrteTime As %String(CAPTION = "数据创建时间", MAXLEN = 30) [ SqlColumnNumber = 9, SqlFieldName = CRTE_TIME ];

/// 9 数据更新时间	UPDT_TIME	DATETIME	0	否
Property UpdtTime As %String(CAPTION = "数据更新时间", MAXLEN = 30) [ SqlColumnNumber = 10, SqlFieldName = UPDT_TIME ];

/// 10 版本号	VER	VARCHAR	20	否
Property Ver As %String(CAPTION = "版本号", MAXLEN = 20) [ SqlColumnNumber = 11, SqlFieldName = VER ];

/// 11 病种内涵	DISE_CONT	TEXT	0	是
Property DiseCont As %String(CAPTION = "病种内涵", MAXLEN = 10000) [ SqlColumnNumber = 12, SqlFieldName = DISE_CONT ];

/// 12 备注	MEMO	LONGTEXT	0	是
Property Memo As %String(CAPTION = "备注", MAXLEN = 500) [ SqlColumnNumber = 13, SqlFieldName = MEMO ];

/// 13 版本名称	VER_NAME	VARCHAR	30	是
Property VerName As %String(CAPTION = "版本名称", MAXLEN = 30) [ SqlColumnNumber = 14, SqlFieldName = VER_NAME ];

/// 14 诊疗指南页码	TRT_GUIDE_PAGEN	VARCHAR	255	是
Property TrtGuidePagen As %String(CAPTION = "诊疗指南页码", MAXLEN = 255) [ SqlColumnNumber = 15, SqlFieldName = TRT_GUIDE_PAGEN ];

/// 15 诊疗指南电子档案	TRT_GUIDE_ELECACS	VARCHAR	500	是
Property TrtGuideElecacs As %String(CAPTION = "诊疗指南电子档案", MAXLEN = 200) [ SqlColumnNumber = 16, SqlFieldName = TRT_GUIDE_ELECACS ];

/// 16 手术操作名称	OPRN_OPRT_NAME	VARCHAR	500	是
Property OprnOprtName As %String(CAPTION = "手术操作名称", MAXLEN = 500) [ SqlColumnNumber = 17, SqlFieldName = OPRN_OPRT_NAME ];

/// 17 手术操作代码	OPRN_OPRT_CODE	VARCHAR	30	是
Property OprnOprtCode As %String(CAPTION = "手术操作代码", MAXLEN = 30) [ SqlColumnNumber = 18, SqlFieldName = OPRN_OPRT_CODE ];

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
Property HisUpdtDate As %Library.Date(CAPTION = "HIS更新日期") [ SqlColumnNumber = 24, SqlFieldName = HIS_UPDT_DATE ];

/// 24 HIS更新时间	HIS_UPDT_TIME	时间	
Property HisUpdtTime As %Library.Time(CAPTION = "HIS更新时间") [ SqlColumnNumber = 25, SqlFieldName = HIS_UPDT_TIME ];

/// 索引 HIS批次
Index IdxHisBatch On (HospId As Exact, HisBatch As Exact);

/// 索引 HIS创建日期
Index IdxHisCrteDate On (HospId As Exact, HisCrteDate As Exact);

/// 索引HIS更新日期
Index IdxHisUpdtDate On (HospId As Exact, HisUpdtDate As Exact);

/// 索引日间手术病种目录代码
Index IdxDaysrgTrtListId On (HospId As Exact, DaysrgTrtListId As Exact);

/// 索引日间手术病种名称
Index IdxDaysrgDiseName On (HospId As Exact, DaysrgDiseName As Exact);

Storage Default
{
<Data name="DAYSRGTRTLISTDefaultData">
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
<Value>DaysrgTrtListId</Value>
</Value>
<Value name="5">
<Value>DaysrgDiseListCode</Value>
</Value>
<Value name="6">
<Value>DaysrgDiseName</Value>
</Value>
<Value name="7">
<Value>ValiFlag</Value>
</Value>
<Value name="8">
<Value>Rid</Value>
</Value>
<Value name="9">
<Value>CrteTime</Value>
</Value>
<Value name="10">
<Value>UpdtTime</Value>
</Value>
<Value name="11">
<Value>Ver</Value>
</Value>
<Value name="12">
<Value>DiseCont</Value>
</Value>
<Value name="13">
<Value>Memo</Value>
</Value>
<Value name="14">
<Value>VerName</Value>
</Value>
<Value name="15">
<Value>TrtGuidePagen</Value>
</Value>
<Value name="16">
<Value>TrtGuideElecacs</Value>
</Value>
<Value name="17">
<Value>OprnOprtName</Value>
</Value>
<Value name="18">
<Value>OprnOprtCode</Value>
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
<DataLocation>^CT.INSU.MI.DAYSRGTRTLISTD</DataLocation>
<DefaultData>DAYSRGTRTLISTDefaultData</DefaultData>
<IdLocation>^CT.INSU.MI.DAYSRGTRTLISTD</IdLocation>
<IndexLocation>^CT.INSU.MI.DAYSRGTRTLISTI</IndexLocation>
<StreamLocation>^CT.INSU.MI.DAYSRGTRTLISTS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
