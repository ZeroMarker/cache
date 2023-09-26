/// 医保目录扩展表
Class CT.INSU.MI.TarItemsExt Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = Rowid ]
{

/// 1 InsuCode	医保目录编码
Property InsuCode As %String(CAPTION = "医保目录编码", MAXLEN = 100) [ SqlColumnNumber = 2, SqlFieldName = INTIM_InsuCode ];

/// 2 InsuDesc	医保目录名称
Property InsuDesc As %String(CAPTION = "医保目录名称", MAXLEN = 200) [ SqlColumnNumber = 3, SqlFieldName = INTIM_InsuDesc ];

/// 3 HiType	医保类型
Property HiType As %String(CAPTION = "医保类型", MAXLEN = 100) [ SqlColumnNumber = 4, SqlFieldName = INTIM_HiType ];

/// 4 SpFlag	特殊标志
Property SpFlag As %String(CAPTION = "特殊标志", MAXLEN = 20) [ SqlColumnNumber = 5, SqlFieldName = INTIM_SpFlag ];

/// 5 XzType	险种类型
Property XzType As %String(CAPTION = "险种类型", MAXLEN = 20) [ SqlColumnNumber = 6, SqlFieldName = INTIM_XzType ];

/// 6 HiGrp	    医保人群
Property HiGrp As %String(CAPTION = "医保人群", MAXLEN = 30) [ SqlColumnNumber = 7, SqlFieldName = INTIM_HiGrp ];

/// 7 SelfPayProp	自付比例 
Property SelfPayProp As %Float(CAPTION = "自付比例") [ SqlColumnNumber = 8, SqlFieldName = INTIM_SelfPayProp ];

/// 8 MedType	    医疗类别
Property MedType As %String(CAPTION = "医疗类别", MAXLEN = 30) [ SqlColumnNumber = 9, SqlFieldName = INTIM_MedType ];

/// 9 LmtCondDscr	限用条件说明
Property LmtCondDscr As %String(CAPTION = "限用条件说明", MAXLEN = 500) [ SqlColumnNumber = 10, SqlFieldName = INTIM_LmtCondDscr ];

/// 10 BegnDate	启用日期
Property BegnDate As %Date(CAPTION = "启用日期") [ SqlColumnNumber = 11, SqlFieldName = INTIM_BegnDate ];

/// 11 EndDate	    有效期限
Property EndDate As %Date(CAPTION = "有效期限") [ SqlColumnNumber = 12, SqlFieldName = INTIM_EndDate ];

/// 12 ValidFlag	有效标志
Property ValidFlag As %String(CAPTION = "有效期限", MAXLEN = 10) [ SqlColumnNumber = 13, SqlFieldName = INTIM_ValidFlag ];

/// 13 创建人	HIS_CRTER_ID	字符型	30	否
Property CrterId As User.SSUser(CAPTION = "创建人") [ SqlColumnNumber = 14, SqlFieldName = INTIM_CRTER_ID ];

/// 14 HIS创建日期	HIS_CRTE_DATE	日期
Property CrteDate As %Library.Date(CAPTION = "创建日期") [ SqlColumnNumber = 15, SqlFieldName = INTIM_CRTE_DATE ];

/// 15 HIS创建时间	HIS_CRTE_TIME	时间	
Property CrteTime As %Library.Time(CAPTION = "创建时间") [ SqlColumnNumber = 16, SqlFieldName = INTIM_CRTE_TIME ];

/// 16 HIS更新人ID	HIS_UPDT_ID	字符型
Property UpdtId As User.SSUser(CAPTION = "更新人ID") [ SqlColumnNumber = 17, SqlFieldName = INTIM_UPDT_ID ];

/// 17 HIS更新日期	HIS_UPDT_DATE	日期
Property UpdtDate As %String(CAPTION = "更新日期", MAXLEN = 20) [ SqlColumnNumber = 18, SqlFieldName = INTIM_UPDT_DATE ];

/// 18 HIS更新时间	HIS_UPDT_TIME	时间	
Property UpdtTime As %String(CAPTION = "更新时间", MAXLEN = 20) [ SqlColumnNumber = 19, SqlFieldName = INTIM_UPDT_TIME ];

/// 19 医院ID	HOSP_ID	VARCHAR	30	否
Property HospId As User.CTHospital(CAPTION = "医院ID") [ SqlColumnNumber = 20, SqlFieldName = INTIM_HOSP_ID ];

/// 索引 医保目录编码
Index IdxInsuCode On (HospId As Exact, InsuCode As Exact);

/// 索引 医保目录名称
Index IdxInsuDesc On (HospId As Exact, InsuDesc As Exact);

/// 索引 创建人
Index IdxCrterId On (HospId As Exact, CrterId As Exact);

/// 索引 HIS创建日期
Index IdxCrteDate On (HospId As Exact, CrteDate As Exact);

/// 索引更新人
Index IdxUpdtId On (HospId As Exact, UpdtId As Exact);

/// 索引HIS更新日期
Index IdxUpdtDate On (HospId As Exact, UpdtDate As Exact);

Storage Default
{
<Data name="TarItemsExtDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InsuCode</Value>
</Value>
<Value name="3">
<Value>InsuDesc</Value>
</Value>
<Value name="4">
<Value>HiType</Value>
</Value>
<Value name="5">
<Value>SpFlag</Value>
</Value>
<Value name="6">
<Value>XzType</Value>
</Value>
<Value name="7">
<Value>HiGrp</Value>
</Value>
<Value name="8">
<Value>SelfPayProp</Value>
</Value>
<Value name="9">
<Value>MedType</Value>
</Value>
<Value name="10">
<Value>LmtCondDscr</Value>
</Value>
<Value name="11">
<Value>BegnDate</Value>
</Value>
<Value name="12">
<Value>EndDate</Value>
</Value>
<Value name="13">
<Value>ValidFlag</Value>
</Value>
<Value name="14">
<Value>CrterId</Value>
</Value>
<Value name="15">
<Value>CrteDate</Value>
</Value>
<Value name="16">
<Value>CrteTime</Value>
</Value>
<Value name="17">
<Value>UpdtId</Value>
</Value>
<Value name="18">
<Value>UpdtDate</Value>
</Value>
<Value name="19">
<Value>UpdtTime</Value>
</Value>
<Value name="20">
<Value>HospId</Value>
</Value>
</Data>
<DataLocation>^CT.INSU.MI.TarItemsExtD</DataLocation>
<DefaultData>TarItemsExtDefaultData</DefaultData>
<IdLocation>^CT.INSU.MI.TarItemsExtD</IdLocation>
<IndexLocation>^CT.INSU.MI.TarItemsExtI</IndexLocation>
<StreamLocation>^CT.INSU.MI.TarItemsExtS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
