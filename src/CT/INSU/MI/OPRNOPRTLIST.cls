/// 1308 手术操作目录下载
Class CT.INSU.MI.OPRNOPRTLIST Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = Rowid ]
{

/// 1 医院ID	HOSP_ID	VARCHAR	30	否
Property HospId As %String(CAPTION = "医院ID", MAXLEN = 6) [ SqlColumnNumber = 2, SqlFieldName = HOSP_ID ];

/// 2 医保类型	HI_TYPE	VARCHAR	30	否
Property HiType As %String(CAPTION = "医保类型", MAXLEN = 10) [ SqlColumnNumber = 3, SqlFieldName = HI_TYPE ];

/// 3 手术标准目录ID	OPRN_STD_LIST_ID	VARCHAR	40	否
Property OprnStdListId As %String(CAPTION = "手术标准目录ID", MAXLEN = 40) [ SqlColumnNumber = 4, SqlFieldName = OPRN_STD_LIST_ID ];

/// 4 章	CPR	VARCHAR	3	是		
Property Cpr As %String(CAPTION = "章", MAXLEN = 4) [ SqlColumnNumber = 5, SqlFieldName = CPR ];

/// 5 章代码范围	CPR_CODE_SCP	VARCHAR	10	是	
Property CprCodeScp As %String(CAPTION = "章代码范围", MAXLEN = 10) [ SqlColumnNumber = 6, SqlFieldName = CPR_CODE_SCP ];

/// 6 章名称	CPR_NAME	VARCHAR	500	是	
Property Cprname As %String(CAPTION = "章名称", MAXLEN = 500) [ SqlColumnNumber = 7, SqlFieldName = CPRNAME ];

/// 7 类目代码	CGY_CODE	VARCHAR	10	是		
Property CGyCode As %String(CAPTION = "类目代码", MAXLEN = 10) [ SqlColumnNumber = 8, SqlFieldName = CGY_CODE ];

/// 8 类目名称	CGY_NAME	VARCHAR	500	是	
Property CgyName As %String(CAPTION = "类目名称", MAXLEN = 500) [ SqlColumnNumber = 9, SqlFieldName = CGY_NAME ];

/// 9 亚目代码	SOR_CODE	VARCHAR	20	是
Property SorCode As %String(CAPTION = "亚目代码", MAXLEN = 20) [ SqlColumnNumber = 10, SqlFieldName = SOR_CODE ];

/// 10 亚目名称	SOR_NAME	VARCHAR	500	是	
Property SorName As %String(CAPTION = "亚目名称", MAXLEN = 500) [ SqlColumnNumber = 11, SqlFieldName = SOR_NAME ];

/// 11 细目代码	DTLS_CODE	VARCHAR	20	是	
Property DtlsCode As %String(CAPTION = "细目代码", MAXLEN = 20) [ SqlColumnNumber = 12, SqlFieldName = DTLS_CODE ];

/// 12 细目名称	DTLS_NAME	VARCHAR	500	是		
Property DtlsName As %String(CAPTION = "细目名称", MAXLEN = 500) [ SqlColumnNumber = 13, SqlFieldName = DTLS_NAME ];

/// 13 手术操作代码	OPRN_OPRT_CODE	VARCHAR	30	是	
Property OprnOprtCode As %String(CAPTION = "手术操作代码", MAXLEN = 30) [ SqlColumnNumber = 14, SqlFieldName = OPRN_OPRT_CODE ];

/// 14 手术操作名称	OPRN_OPRT_NAME	VARCHAR	500	是
Property OprnOprtName As %String(CAPTION = "手术操作名称", MAXLEN = 500) [ SqlColumnNumber = 15, SqlFieldName = OPRN_OPRT_NAME ];

/// 15 使用标记	USED_STD	VARCHAR	20	是	
Property UsedStd As %String(CAPTION = "使用标记", MAXLEN = 20) [ SqlColumnNumber = 16, SqlFieldName = USED_STD ];

/// 16 团标版手术操作代码	RTL_OPRN_OPRT_CODE	VARCHAR	20	是	
Property RtlOprnOprtCode As %String(CAPTION = "团标版手术操作代码", MAXLEN = 20) [ SqlColumnNumber = 17, SqlFieldName = RTL_OPRN_OPRT_CODE ];

/// 17 团标版手术操作名称	RTL_OPRN_OPRT_NAME	VARCHAR	500	是
Property RtlOprnOprtName As %String(CAPTION = "团标版手术操作名称", MAXLEN = 500) [ SqlColumnNumber = 18, SqlFieldName = RTL_OPRN_OPRT_NAME ];

/// 18 临床版手术操作代码	CLNC_OPRN_OPRT_CODE	VARCHAR	20	是	
Property ClncOprnOprtCode As %String(CAPTION = "临床版手术操作代码", MAXLEN = 20) [ SqlColumnNumber = 19, SqlFieldName = CLNC_OPRN_OPRT_CODE ];

/// 19 临床版手术操作名称	CLNC_OPRN_OPRT_NAME	VARCHAR	500	是
Property ClncOprnName As %String(CAPTION = "临床版手术操作名称", MAXLEN = 500) [ SqlColumnNumber = 20, SqlFieldName = CLNC_OPRN_OPRT_NAME ];

/// 20 备注	MEMO	LONGTEXT	0	是	
Property Memo As %String(CAPTION = "备注", MAXLEN = 500) [ SqlColumnNumber = 21, SqlFieldName = MEMO ];

/// 21 有效标志	VALI_FLAG	VARCHAR	3	是	
Property ValiFlag As %String(CAPTION = "有效标志", MAXLEN = 4) [ SqlColumnNumber = 22, SqlFieldName = VALI_FLAG ];

/// 22 数据唯一记录号	RID
Property Rid As %String(CAPTION = "数据唯一记录号", MAXLEN = 40) [ SqlColumnNumber = 23, SqlFieldName = RID ];

/// 23 数据创建时间	CRTE_TIME	DATETIME	0	否		
Property CrteTime As %String(CAPTION = "数据创建时间", MAXLEN = 30) [ SqlColumnNumber = 24, SqlFieldName = CRTE_TIME ];

/// 24 数据更新时间	UPDT_TIME	DATETIME	0	否	
Property UpdtTime As %String(CAPTION = "数据更新时间", MAXLEN = 30) [ SqlColumnNumber = 25, SqlFieldName = UPDT_TIME ];

/// 25 版本号	VER	VARCHAR	20	否	
Property Ver As %String(CAPTION = "版本号", MAXLEN = 30) [ SqlColumnNumber = 26, SqlFieldName = VER ];

/// 26 版本名称	VER_NAME	VARCHAR	30	是	
Property VerName As %String(CAPTION = "版本名称", MAXLEN = 30) [ SqlColumnNumber = 27, SqlFieldName = VER_NAME ];

/// 27 HIS下载批次	BATCH	VARCHAR	30	否 210322162500001
Property HisBatch As %String(CAPTION = "HIS下载批次", MAXLEN = 30) [ SqlColumnNumber = 28, SqlFieldName = HIS_BATCH ];

/// 28 HIS创建人 CRTER	VARCHAR	30	否
Property HisCrterId As %String(CAPTION = "HIS创建人", MAXLEN = 30) [ SqlColumnNumber = 29, SqlFieldName = HIS_CRTER_ID ];

/// 29 HIS创建日期	CRTE_DATE	日期	
Property HisCrteDate As %Library.Date(CAPTION = "HIS创建日期") [ SqlColumnNumber = 30, SqlFieldName = HIS_CRTE_DATE ];

/// 30 HIS创建时间	CRTE_TIME	时间		
Property HisCrteTIme As %Library.Time(CAPTION = "HIS创建时间") [ SqlColumnNumber = 31, SqlFieldName = HIS_CRTE_TIME ];

/// 31 HIS更新人ID	UPDT_ID			
Property HisUpdtId As %String(CAPTION = "HIS更新人ID") [ SqlColumnNumber = 32, SqlFieldName = HIS_UPDT_ID ];

/// 32 HIS更新日期	UPDT_DATE	日期		
Property HisUpdtDate As %Library.Date(CAPTION = "HIS更新日期") [ SqlColumnNumber = 33, SqlFieldName = HIS_UPDT_DATE ];

/// 33 HIS更新时间	HISUPDT_ITIME	时间
Property HisUpdtTime As %Library.Time(CAPTION = "HIS更新时间") [ SqlColumnNumber = 34, SqlFieldName = HIS_UPDT_TIME ];

/// 34 院内版本号	HIS_VER   VARCHAR	30   +20230115 HanZH
Property HisVer As %String(CAPTION = "院内版本号", MAXLEN = 30) [ SqlColumnNumber = 35, SqlFieldName = HIS_VER ];

/// 索引 HIS下载批次
Index IdxHISBATCH On (HospId As Exact, HisBatch As Exact);

/// 索引 HIS创建日期
Index IdxHISCRTEDATE On (HospId As Exact, HisCrteDate As Exact);

/// 索引HIS更新日期
Index IdxHISUPDTDATE On (HospId As Exact, HisUpdtDate As Exact);

/// 索引手术标准目录ID	
Index IdxOPRNSTDLISTID On (HospId As Exact, OprnStdListId As Exact);

/// 索引章
Index IdxCPR On (HospId As Exact, Cpr As Exact);

/// 手術操作代碼 20210719
Index IdxOprnOprtCode On (HospId As Exact, OprnOprtCode As Exact);

/// 手術操作名称 20210830
Index IdxOprnOprtName On (HospId As Exact, OprnOprtName As Exact);

/// 院内版本号 20230115
Index IdxHisVer On (HospId As Exact, HisVer As Exact);

Storage Default
{
<Data name="OPRNOPRTLISTDefaultData">
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
<Value>OprnStdListId</Value>
</Value>
<Value name="5">
<Value>Cpr</Value>
</Value>
<Value name="6">
<Value>CprCodeScp</Value>
</Value>
<Value name="7">
<Value>Cprname</Value>
</Value>
<Value name="8">
<Value>CGyCode</Value>
</Value>
<Value name="9">
<Value>CgyName</Value>
</Value>
<Value name="10">
<Value>SorCode</Value>
</Value>
<Value name="11">
<Value>SorName</Value>
</Value>
<Value name="12">
<Value>DtlsCode</Value>
</Value>
<Value name="13">
<Value>DtlsName</Value>
</Value>
<Value name="14">
<Value>OprnOprtCode</Value>
</Value>
<Value name="15">
<Value>OprnOprtName</Value>
</Value>
<Value name="16">
<Value>UsedStd</Value>
</Value>
<Value name="17">
<Value>RtlOprnOprtCode</Value>
</Value>
<Value name="18">
<Value>RtlOprnOprtName</Value>
</Value>
<Value name="19">
<Value>ClncOprnOprtCode</Value>
</Value>
<Value name="20">
<Value>ClncOprnName</Value>
</Value>
<Value name="21">
<Value>Memo</Value>
</Value>
<Value name="22">
<Value>ValiFlag</Value>
</Value>
<Value name="23">
<Value>Rid</Value>
</Value>
<Value name="24">
<Value>CrteTime</Value>
</Value>
<Value name="25">
<Value>UpdtTime</Value>
</Value>
<Value name="26">
<Value>Ver</Value>
</Value>
<Value name="27">
<Value>VerName</Value>
</Value>
<Value name="28">
<Value>HisBatch</Value>
</Value>
<Value name="29">
<Value>HisCrterId</Value>
</Value>
<Value name="30">
<Value>HisCrteDate</Value>
</Value>
<Value name="31">
<Value>HisCrteTIme</Value>
</Value>
<Value name="32">
<Value>HisUpdtId</Value>
</Value>
<Value name="33">
<Value>HisUpdtDate</Value>
</Value>
<Value name="34">
<Value>HisUpdtTime</Value>
</Value>
<Value name="35">
<Value>HisVer</Value>
</Value>
</Data>
<DataLocation>^CT.INSU.MI.OPRNOPRTLISTD</DataLocation>
<DefaultData>OPRNOPRTLISTDefaultData</DefaultData>
<IdLocation>^CT.INSU.MI.OPRNOPRTLISTD</IdLocation>
<IndexLocation>^CT.INSU.MI.OPRNOPRTLISTI</IndexLocation>
<StreamLocation>^CT.INSU.MI.OPRNOPRTLISTS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
