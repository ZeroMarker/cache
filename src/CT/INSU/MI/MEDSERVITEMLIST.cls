/// 1305 医疗服务项目目录下载
Class CT.INSU.MI.MEDSERVITEMLIST Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = Rowid ]
{

/// 1医院ID	HOSP_ID	VARCHAR	30	否
Property HospId As %String(CAPTION = "医院ID", MAXLEN = 6) [ SqlColumnNumber = 2, SqlFieldName = HOSP_ID ];

/// 2医保类型	HI_TYPE	VARCHAR	30	否
Property HiType As %String(CAPTION = "医保类型", MAXLEN = 10) [ SqlColumnNumber = 3, SqlFieldName = HI_TYPE ];

/// 3医疗目录编码	MED_LIST_CODG	VARCHAR	50	是
Property MedListCodg As %String(CAPTION = "医疗目录编码", MAXLEN = 50) [ SqlColumnNumber = 4, SqlFieldName = MED_LIST_CODG ];

/// 4计价单位	PRCUNT	VARCHAR	100	是		
Property Prcunt As %String(CAPTION = "计价单位", MAXLEN = 100) [ SqlColumnNumber = 5, SqlFieldName = PRCUNT ];

/// 5计价单位名称	PRCUNT_NAME	VARCHAR	20	是	
Property PrcuntName As %String(CAPTION = "计价单位名称", MAXLEN = 20) [ SqlColumnNumber = 6, SqlFieldName = PRCUNT_NAME ];

/// 6诊疗项目说明	TRT_ITEM_DSCR	VARCHAR	500	是
Property TrtItemDscr As %String(CAPTION = "诊疗项目说明", MAXLEN = 500) [ SqlColumnNumber = 7, SqlFieldName = TRT_ITEM_DSCR ];

/// 7诊疗除外内容	TRT_EXCT_CONT	VARCHAR	500	是	
Property TrtExctCont As %String(CAPTION = "诊疗除外内容", MAXLEN = 500) [ SqlColumnNumber = 8, SqlFieldName = TRT_EXCT_CONT ];

/// 8诊疗项目内涵	TRT_ITEM_CONT	VARCHAR	1024	是	
Property TriItemCont As %String(CAPTION = "诊疗项目内涵", MAXLEN = 1024) [ SqlColumnNumber = 9, SqlFieldName = TRT_ITEM_CONT ];

/// 9有效标志	VALI_FLAG	VARCHAR	3	是	
Property ValiFlag As %String(CAPTION = "有效标志", MAXLEN = 4) [ SqlColumnNumber = 10, SqlFieldName = VALI_FLAG ];

/// 10备注	MEMO	LONGTEXT	0	是	
Property Memo As %String(CAPTION = "备注", MAXLEN = 500) [ SqlColumnNumber = 11, SqlFieldName = MEMO ];

/// 11服务项目类别	SERVITEM_TYPE	VARCHAR	15	是	
Property ServitemType As %String(CAPTION = "服务项目类别", MAXLEN = 15) [ SqlColumnNumber = 12, SqlFieldName = SERVITEM_TYPE ];

/// 12医疗服务项目名称	SERVITEM_NAME	VARCHAR	100	是
Property ServitemName As %String(CAPTION = "医疗服务项目名称", MAXLEN = 100) [ SqlColumnNumber = 13, SqlFieldName = SERVITEM_NAME ];

/// 13项目说明	ITEM_DSCR	VARCHAR	500	是		
Property ItemDscr As %String(CAPTION = "项目说明", MAXLEN = 200) [ SqlColumnNumber = 14, SqlFieldName = ITEM_DSCR ];

/// 14开始日期	BEGNDATE	DATE	0	是	
Property Begndate As %String(CAPTION = "开始日期", MAXLEN = 20) [ SqlColumnNumber = 15, SqlFieldName = BEGNDATE ];

/// 15结束日期	ENDDATE	DATE	0	否	
Property Enddate As %String(CAPTION = "结束日期", MAXLEN = 20) [ SqlColumnNumber = 16, SqlFieldName = ENDDATE ];

/// 16数据唯一记录号	RID
Property Rid As %String(CAPTION = "数据唯一记录号", MAXLEN = 40) [ SqlColumnNumber = 17, SqlFieldName = RID ];

/// 17版本号	VER	VARCHAR	20	否	
Property Ver As %String(CAPTION = "版本号", MAXLEN = 20) [ SqlColumnNumber = 18, SqlFieldName = VER ];

/// 18版本名称	VER_NAME	VARCHAR	30	是		
Property VerName As %String(CAPTION = "版本名称", MAXLEN = 30) [ SqlColumnNumber = 19, SqlFieldName = VER_NAME ];

/// 19HIS下载批次	BATCH	VARCHAR	30	否 210322162500001
Property HisBatch As %String(CAPTION = "HIS下载批次", MAXLEN = 30) [ SqlColumnNumber = 20, SqlFieldName = HIS_BATCH ];

/// 20HIS创建人 CRTER	VARCHAR	30	否
Property HisCrterId As %String(CAPTION = "HIS创建人", MAXLEN = 30) [ SqlColumnNumber = 21, SqlFieldName = HIS_CRTER_ID ];

/// 21HIS创建日期	CRTE_DATE	日期	
Property HisCrteDate As %Library.Date(CAPTION = "HIS创建日期") [ SqlColumnNumber = 22, SqlFieldName = HIS_CRTE_DATE ];

/// 22HIS创建时间	CRTE_TIME	时间		
Property HisCrteTime As %Library.Time(CAPTION = "HIS创建时间") [ SqlColumnNumber = 23, SqlFieldName = HIS_CRTE_TIME ];

/// 23HIS更新人ID	UPDT_ID			
Property HisUpdtId As %String(CAPTION = "HIS更新人ID") [ SqlColumnNumber = 24, SqlFieldName = HIS_UPDT_ID ];

/// 24HIS更新日期	UPDT_DATE	日期		
Property HisUpdtDate As %Library.Date(CAPTION = "HIS更新日期") [ SqlColumnNumber = 25, SqlFieldName = HIS_UPDT_DATE ];

/// 25HIS更新时间	HISUPDT_ITIME	时间
Property HisUpdtTime As %Library.Time(CAPTION = "HIS更新时间") [ SqlColumnNumber = 26, SqlFieldName = HIS_UPDT_TIME ];

/// 索引 HIS下载批次
Index IdxHISBATCH On (HospId As Exact, HisBatch As Exact);

/// 索引 HIS创建日期
Index IdxHISCRTEDATE On (HospId As Exact, HisCrteDate As Exact);

/// 索引HIS更新日期
Index IdxHISUPDTDATE On (HospId As Exact, HisUpdtDate As Exact);

/// 索引医疗目录编码
Index IdxMEDLISTCODG On (HospId As Exact, MedListCodg As Exact);

/// 索引医疗服务项目名称
Index IdxSERVITEMNAME On (HospId As Exact, ServitemName As Exact);

Storage Default
{
<Data name="MEDSERVITEMLISTDefaultData">
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
<Value>Prcunt</Value>
</Value>
<Value name="6">
<Value>PrcuntName</Value>
</Value>
<Value name="7">
<Value>TrtItemDscr</Value>
</Value>
<Value name="8">
<Value>TrtExctCont</Value>
</Value>
<Value name="9">
<Value>TriItemCont</Value>
</Value>
<Value name="10">
<Value>ValiFlag</Value>
</Value>
<Value name="11">
<Value>Memo</Value>
</Value>
<Value name="12">
<Value>ServitemType</Value>
</Value>
<Value name="13">
<Value>ServitemName</Value>
</Value>
<Value name="14">
<Value>ItemDscr</Value>
</Value>
<Value name="15">
<Value>Begndate</Value>
</Value>
<Value name="16">
<Value>Enddate</Value>
</Value>
<Value name="17">
<Value>Rid</Value>
</Value>
<Value name="18">
<Value>Ver</Value>
</Value>
<Value name="19">
<Value>VerName</Value>
</Value>
<Value name="20">
<Value>HisBatch</Value>
</Value>
<Value name="21">
<Value>HisCrterId</Value>
</Value>
<Value name="22">
<Value>HisCrteDate</Value>
</Value>
<Value name="23">
<Value>HisCrteTime</Value>
</Value>
<Value name="24">
<Value>HisUpdtId</Value>
</Value>
<Value name="25">
<Value>HisUpdtDate</Value>
</Value>
<Value name="26">
<Value>HisUpdtTime</Value>
</Value>
</Data>
<DataLocation>^CT.INSU.MI.MEDSERVITEMLISTD</DataLocation>
<DefaultData>MEDSERVITEMLISTDefaultData</DefaultData>
<IdLocation>^CT.INSU.MI.MEDSERVITEMLISTD</IdLocation>
<IndexLocation>^CT.INSU.MI.MEDSERVITEMLISTI</IndexLocation>
<StreamLocation>^CT.INSU.MI.MEDSERVITEMLISTS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
