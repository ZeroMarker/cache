/// 1315	中医证候目录下载
Class CT.INSU.MI.TCMSYMPTYPE Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = Rowid ]
{

/// 1 医院ID	HOSP_ID	VARCHAR	30	否
Property HospId As %String(CAPTION = "医院ID", MAXLEN = 6) [ SqlColumnNumber = 2, SqlFieldName = HOSP_ID ];

/// 2 医保类型	HI_TYPE	VARCHAR	30	否
Property HiType As %String(CAPTION = "医保类型", MAXLEN = 10) [ SqlColumnNumber = 3, SqlFieldName = HI_TYPE ];

/// 3 中医证候ID	TCMSYMP_ID	VARCHAR	40	否
Property TcmsympId As %String(CAPTION = "中医证候ID", MAXLEN = 100) [ SqlColumnNumber = 4, SqlFieldName = TCMSYMP_ID ];

/// 4 证候类目代码	SDS_CGY_CODE	VARCHAR	3	是
Property SdsCgyCode As %String(CAPTION = "证候类目代码", MAXLEN = 4) [ SqlColumnNumber = 5, SqlFieldName = SDS_CGY_CODE ];

/// 5 证候类目名称	SDS_CGY_NAME	VARCHAR	500	是
Property SdsCgyName As %String(CAPTION = "证候类目名称", MAXLEN = 200) [ SqlColumnNumber = 6, SqlFieldName = SDS_CGY_NAME ];

/// 6 证候属性代码	SDS_ATTR_CODE	VARCHAR	6	是
Property SdsAttrCode As %String(CAPTION = "证候属性代码", MAXLEN = 6) [ SqlColumnNumber = 7, SqlFieldName = SDS_ATTR_CODE ];

/// 7 证候属性	SDS_ATTR	VARCHAR	500	是
Property SdsAttr As %String(CAPTION = "证候属性", MAXLEN = 200) [ SqlColumnNumber = 8, SqlFieldName = SDS_ATTR ];

/// 8 证候分类代码	SDS_TYPE_CODE	VARCHAR	6	是
Property SdsTypeCode As %String(CAPTION = "证候分类代码", MAXLEN = 6) [ SqlColumnNumber = 9, SqlFieldName = SDS_TYPE_CODE ];

/// 9 证候分类名称	SDS_TYPE_NAME	VARCHAR	500	是
Property SdsTypeName As %String(CAPTION = "证候分类名称", MAXLEN = 200) [ SqlColumnNumber = 10, SqlFieldName = SDS_TYPE_NAME ];

/// 10 备注	MEMO	LONGTEXT	0	是
Property Memo As %String(CAPTION = "备注", MAXLEN = 500) [ SqlColumnNumber = 11, SqlFieldName = MEMO ];

/// 11 有效标志	VALI_FLAG	VARCHAR	3	是
Property ValiFlag As %String(CAPTION = "有效标志", MAXLEN = 4) [ SqlColumnNumber = 12, SqlFieldName = VALI_FLAG ];

/// 12 唯一记录号	RID	VARCHAR	40	
Property Rid As %String(CAPTION = "唯一记录号", MAXLEN = 40) [ SqlColumnNumber = 13, SqlFieldName = RID ];

/// 13 数据创建时间	CRTE_TIME	DATETIME	0	否
Property CrteTime As %String(CAPTION = "数据创建时间", MAXLEN = 30) [ SqlColumnNumber = 14, SqlFieldName = CRTE_TIME ];

/// 14 数据更新时间	UPDT_TIME	DATETIME	0	否
Property UpdtTime As %String(CAPTION = "数据更新时间", MAXLEN = 30) [ SqlColumnNumber = 15, SqlFieldName = UPDT_TIME ];

/// 15 版本号	VER	VARCHAR	20	否
Property Ver As %String(CAPTION = "版本号", MAXLEN = 30) [ SqlColumnNumber = 16, SqlFieldName = VER ];

/// 16 版本名称	VER_NAME	VARCHAR	30	是
Property VerName As %String(CAPTION = "版本名称", MAXLEN = 30) [ SqlColumnNumber = 17, SqlFieldName = VER_NAME ];

/// 17 HIS批次	HIS_BATCH	字符型	30	否
Property HisBatch As %String(CAPTION = "HIS批次", MAXLEN = 30) [ SqlColumnNumber = 18, SqlFieldName = HIS_BATCH ];

/// 18 HIS创建人	HIS_CRTER_ID	字符型	30	否
Property HisCrterId As %String(CAPTION = "HIS创建人", MAXLEN = 30) [ SqlColumnNumber = 19, SqlFieldName = HIS_CRTER_ID ];

/// 19 HIS创建日期	HIS_CRTE_DATE	日期
Property HisCrteDate As %Library.Date(CAPTION = "HIS创建日期") [ SqlColumnNumber = 20, SqlFieldName = HIS_CRTE_DATE ];

/// 20 HIS创建时间	HIS_CRTE_TIME	时间	
Property HisCrteTime As %Library.Time(CAPTION = "HIS创建时间") [ SqlColumnNumber = 21, SqlFieldName = HIS_CRTE_TIME ];

/// 21 HIS更新人ID	HIS_UPDT_ID	字符型
Property HisUpdtId As %String(CAPTION = "HIS更新人ID", MAXLEN = 30) [ SqlColumnNumber = 22, SqlFieldName = HIS_UPDT_ID ];

/// 22 HIS更新日期	HIS_UPDT_DATE	日期
Property HisUpdtDate As %Library.Date(CAPTION = "HIS更新日期") [ SqlColumnNumber = 23, SqlFieldName = HIS_UPDT_DATE ];

/// 23 HIS更新时间	HIS_UPDT_TIME	时间	
Property HisUpdtTime As %Library.Time(CAPTION = "HIS更新时间") [ SqlColumnNumber = 24, SqlFieldName = HIS_UPDT_TIME ];

/// 索引 HIS批次
Index IdxHisBatch On (HospId As Exact, HisBatch As Exact);

/// 索引 HIS创建日期
Index IdxHisCrteDate On (HospId As Exact, HisCrteDate As Exact);

/// 索引HIS更新日期
Index IdxHisUpdtDate On (HospId As Exact, HisUpdtDate As Exact);

/// 索引证候类目代码
Index IdxSdsCgyCode On (HospId As Exact, SdsCgyCode As Exact);

/// 索引证候类目名称
Index IdxSdsTypeName On (HospId As Exact, SdsTypeName As Exact);

Storage Default
{
<Data name="TCMSYMPTYPEDefaultData">
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
<Value>TcmsympId</Value>
</Value>
<Value name="5">
<Value>SdsCgyCode</Value>
</Value>
<Value name="6">
<Value>SdsCgyName</Value>
</Value>
<Value name="7">
<Value>SdsAttrCode</Value>
</Value>
<Value name="8">
<Value>SdsAttr</Value>
</Value>
<Value name="9">
<Value>SdsTypeCode</Value>
</Value>
<Value name="10">
<Value>SdsTypeName</Value>
</Value>
<Value name="11">
<Value>Memo</Value>
</Value>
<Value name="12">
<Value>ValiFlag</Value>
</Value>
<Value name="13">
<Value>Rid</Value>
</Value>
<Value name="14">
<Value>CrteTime</Value>
</Value>
<Value name="15">
<Value>UpdtTime</Value>
</Value>
<Value name="16">
<Value>Ver</Value>
</Value>
<Value name="17">
<Value>VerName</Value>
</Value>
<Value name="18">
<Value>HisBatch</Value>
</Value>
<Value name="19">
<Value>HisCrterId</Value>
</Value>
<Value name="20">
<Value>HisCrteDate</Value>
</Value>
<Value name="21">
<Value>HisCrteTime</Value>
</Value>
<Value name="22">
<Value>HisUpdtId</Value>
</Value>
<Value name="23">
<Value>HisUpdtDate</Value>
</Value>
<Value name="24">
<Value>HisUpdtTime</Value>
</Value>
</Data>
<DataLocation>^CT.INSU.MI.TCMSYMPTYPED</DataLocation>
<DefaultData>TCMSYMPTYPEDefaultData</DefaultData>
<IdLocation>^CT.INSU.MI.TCMSYMPTYPED</IdLocation>
<IndexLocation>^CT.INSU.MI.TCMSYMPTYPEI</IndexLocation>
<StreamLocation>^CT.INSU.MI.TCMSYMPTYPES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
