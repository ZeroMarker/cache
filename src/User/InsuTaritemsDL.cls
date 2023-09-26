/// 医保目录下载表：下载的数据首先保存在这个表中，医保办审核后才保存到医保目录表<Insu_taritems>
/// 修改履历：董科锋 2020 02 24 新做成
Class User.InsuTaritemsDL Extends %Persistent
{

/// 医保发票分类，如：西药费、中药费
Property INTIMsfdlbm As %String(CAPTION = "收费大类代码") [ SqlColumnNumber = 2, SqlFieldName = INTIM_sfdlbm ];

/// 医保类别，如：省医保、市医保
Property INTIMsfxmbm As %String(CAPTION = "医保类型") [ SqlColumnNumber = 3, SqlFieldName = INTIM_sfxmbm ];

Property INTIMxmbm As %String(CAPTION = "项目编码", MAXLEN = 50) [ SqlColumnNumber = 4, SqlFieldName = INTIM_xmbm ];

Property INTIMxmmc As %String(CAPTION = "项目名称", MAXLEN = 100) [ SqlColumnNumber = 5, SqlFieldName = INTIM_xmmc ];

Property INTIMxmrj As %String(CAPTION = "项目热键（拼音玛") [ SqlColumnNumber = 6, SqlFieldName = INTIM_xmrj ];

Property INTIMtxbz As %String(CAPTION = "特殊项标志") [ SqlColumnNumber = 7, SqlFieldName = INTIM_txbz ];

/// 药品、诊疗、服务设施
Property INTIMxmlb As %String(CAPTION = "项目类别") [ SqlColumnNumber = 8, SqlFieldName = INTIM_xmlb ];

Property INTIMjx As %String(CAPTION = "剂型") [ SqlColumnNumber = 9, SqlFieldName = INTIM_jx ];

Property INTIMgg As %String(CAPTION = "规格", MAXLEN = 300) [ SqlColumnNumber = 10, SqlFieldName = INTIM_gg ];

Property INTIMdw As %String(CAPTION = "单位") [ SqlColumnNumber = 11, SqlFieldName = INTIM_dw ];

Property INTIMyf As %String(CAPTION = "用法") [ SqlColumnNumber = 12, SqlFieldName = INTIM_yf ];

Property INTIMyl As %String(CAPTION = "用量") [ SqlColumnNumber = 13, SqlFieldName = INTIM_yl ];

Property INTIMsl As %String(CAPTION = "数量") [ SqlColumnNumber = 14, SqlFieldName = INTIM_sl ];

Property INTIMpzwh As %String(CAPTION = "批准文号") [ SqlColumnNumber = 15, SqlFieldName = INTIM_pzwh ];

Property INTIMbzjg As %String(CAPTION = "标准价格") [ SqlColumnNumber = 16, SqlFieldName = INTIM_bzjg ];

Property INTIMsjjg As %String(CAPTION = "实际价格") [ SqlColumnNumber = 17, SqlFieldName = INTIM_sjjg ];

Property INTIMzgxj As %String(CAPTION = "最高限价") [ SqlColumnNumber = 18, SqlFieldName = INTIM_zgxj ];

Property INTIMzfbl1 As %String(CAPTION = "自付比例1") [ SqlColumnNumber = 19, SqlFieldName = INTIM_zfbl1 ];

Property INTIMzfbl2 As %String(CAPTION = "自付比例2") [ SqlColumnNumber = 20, SqlFieldName = INTIM_zfbl2 ];

Property INTIMzfbl3 As %String(CAPTION = "自付比例3") [ SqlColumnNumber = 21, SqlFieldName = INTIM_zfbl3 ];

Property INTIMbpxe As %String(CAPTION = "报批限额") [ SqlColumnNumber = 22, SqlFieldName = INTIM_bpxe ];

Property INTIMbz As %String(CAPTION = "备注", MAXLEN = 999) [ SqlColumnNumber = 23, SqlFieldName = INTIM_bz ];

/// 医保类别：甲、乙、丙
Property INTIMtjdm As %String(CAPTION = "统计项目 ") [ SqlColumnNumber = 24, SqlFieldName = INTIM_tjdm ];

/// 是否医保
Property INTIMflzb1 As %String(CAPTION = "分类指标1") [ SqlColumnNumber = 25, SqlFieldName = INTIM_flzb1 ];

/// 有效标志
Property INTIMflzb2 As %String(CAPTION = "分类指标2") [ SqlColumnNumber = 26, SqlFieldName = INTIM_flzb2 ];

/// 国药准字
Property INTIMflzb3 As %String(CAPTION = "分类指标3") [ SqlColumnNumber = 27, SqlFieldName = INTIM_flzb3 ];

Property INTIMflzb4 As %String(CAPTION = "分类指标4") [ SqlColumnNumber = 28, SqlFieldName = INTIM_flzb4 ];

Property INTIMflzb5 As %String(CAPTION = "分类指标5") [ SqlColumnNumber = 29, SqlFieldName = INTIM_flzb5 ];

Property INTIMflzb6 As %String(CAPTION = "分类指标6") [ SqlColumnNumber = 30, SqlFieldName = INTIM_flzb6 ];

Property INTIMflzb7 As %String(CAPTION = "分类指标7") [ SqlColumnNumber = 31, SqlFieldName = INTIM_flzb7 ];

Property INTIMspmc As %String(CAPTION = "商品名称") [ SqlColumnNumber = 32, SqlFieldName = INTIM_spmc ];

Property INTIMspmcrj As %String(CAPTION = "商品名称热键") [ SqlColumnNumber = 33, SqlFieldName = INTIM_spmcrj ];

Property INTIMljzfbz As %String(CAPTION = "累计增负标志") [ SqlColumnNumber = 34, SqlFieldName = INTIM_ljzfbz ];

Property INTIMyyjzjbz As %String(CAPTION = "医院增加标志") [ SqlColumnNumber = 35, SqlFieldName = INTIM_yyjzjbz ];

/// 物价编码或药品收费项编码
Property INTIMyysmbm As %String(CAPTION = "医院三目编码") [ SqlColumnNumber = 36, SqlFieldName = INTIM_yysmbm ];

Property INTIMfplb As %String(CAPTION = "发票类别") [ SqlColumnNumber = 37, SqlFieldName = INTIM_fplb ];

Property INTIMDicType As %String(CAPTION = "目录类别") [ SqlColumnNumber = 38, SqlFieldName = INTIM_DicType ];

Property INTIMUserDR As %String(CAPTION = "添加人") [ SqlColumnNumber = 39, SqlFieldName = INTIM_UserDR ];

Property INTIMDate As %Date(CAPTION = "添加日期") [ SqlColumnNumber = 40, SqlFieldName = INTIM_Date ];

Property INTIMTime As %Time(CAPTION = "添加时间") [ SqlColumnNumber = 41, SqlFieldName = INTIM_Time ];

Property INTIMADDIP As %String(CAPTION = "修改机器") [ SqlColumnNumber = 42, SqlFieldName = INTIM_ADDIP ];

Property INTIMActiveDate As %Date(CAPTION = "生效日期") [ SqlColumnNumber = 43, SqlFieldName = INTIM_ActiveDate ];

Property INTIMUnique As %String(CAPTION = "医保中心唯一码") [ SqlColumnNumber = 44, SqlFieldName = INTIM_Unique ];

Property INTIMExpiryDate As %Date(CAPTION = "失效日期") [ SqlColumnNumber = 45, SqlFieldName = INTIM_ExpiryDate ];

/// 1:有效(默认) 0：无效
Property ActiveFlg As %String(CAPTION = "有效标志") [ InitialExpression = "1", SqlColumnNumber = 46, SqlFieldName = ActiveFlg ];

/// 以下载日期做为下载数据的批次，通常情况下每日下载一次，当日下载第二次的时候覆盖上次下载的内容，可以根据这个字段来判断最近是否有过下载数据。
Property DataVersion As %String(CAPTION = "下载数据批次") [ SqlColumnNumber = 47, SqlFieldName = DataVersion ];

/// 1：新增 2:更新 3:有效标识变化 0：无差异 99：未比较(默认)
Property DifferenceCate As %String(CAPTION = "差异标志") [ InitialExpression = "99", SqlColumnNumber = 48, SqlFieldName = DifferenceCate ];

/// 差异原因/备注信息
Property DifferenceCom As %String(CAPTION = "差异内容", MAXLEN = 1500) [ SqlColumnNumber = 49, SqlFieldName = DifferenceCom ];

Property TarItmesDr As %String(CAPTION = "对应医保目录Dr") [ SqlColumnNumber = 50, SqlFieldName = TarItmesDr ];

/// 0：未审核 1：审核导入 2：审核拒绝
Property AuditImportFlag As %String(CAPTION = "审核导入标记") [ InitialExpression = "0", SqlColumnNumber = 51, SqlFieldName = AuditImportFlag ];

Property AuiditUserCode As %String(CAPTION = "审核人编码") [ SqlColumnNumber = 52, SqlFieldName = AuiditUserCode ];

Property RefuseCommon As %String(CAPTION = "拒绝原因") [ SqlColumnNumber = 53, SqlFieldName = RefuseCommon ];

Property AuiditDate As %Date(CAPTION = "审核日期") [ SqlColumnNumber = 54, SqlFieldName = AuiditDate ];

Property AuiditTime As %Time(CAPTION = "审核时间") [ SqlColumnNumber = 55, SqlFieldName = AuiditTime ];

Property HospId As %String(CAPTION = "院区指针") [ SqlColumnNumber = 56, SqlFieldName = HosId ];

/// 数据的逻辑主键(数据批次,医保类型,项目编码)
Index IDataKey On (HospId As Exact, DataVersion As Exact, INTIMsfxmbm As Exact, INTIMxmbm As Exact);

/// 项目编码索引(医保类型,项目编码)
Index idxINTIMxmbm On (HospId As Exact, INTIMsfxmbm As Exact, INTIMxmbm As Exact);

/// 审核标记索引(数据批次,医保类型,项目编码,审核导入标记)
Index idxAuditFlag On (HospId As Exact, DataVersion As Exact, INTIMsfxmbm As Exact, INTIMxmbm As Exact, AuditImportFlag As Exact);

/// 差异标志索引(数据批次,医保类型,项目编码,差异标志)
Index idxDifferenceCate On (HospId As Exact, DataVersion As Exact, INTIMsfxmbm As Exact, INTIMxmbm As Exact, DifferenceCate As Exact);

/*
/// This callback method is invoked by the <METHOD>%Save</METHOD> method to 
/// provide notification that the object is being saved. It is called after 
/// the object's data has been successfully written to disk.
/// 
/// <P><VAR>insert</VAR> will be set to 1 if this object is being saved for the first time.
/// 
/// <P>If this method returns an error then the call to <METHOD>%Save</METHOD> will fail.
Method %OnAfterSave(insert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
	d ..CompareAndSaveResult($this)    ;比较当前数据与医保目录中的数据之间的差异并保存差异结果信息
	
	Quit $$$OK
}

/// 功能说明：sql插入语句以后的触发器
/// 修改履历：董科锋 2020 02 19 新做成
Trigger AfterInsert [ Event = INSERT, Time = AFTER ]
{
	s id=$g(%d(1))
	s objTarItm=..%OpenId(id)
	
	d ..CompareAndSaveResult(objTarItm)    ;比较当前数据与医保目录中的数据之间的差异并保存差异结果信息
}


/// 功能说明：sql更新语句以后的触发器
/// 修改履历：董科锋 2020 02 19 新做成
Trigger AfterUpdate [ Event = UPDATE, Time = AFTER ]
{
	s id=$g(%d(1))
	s objTarItm=..%OpenId(id)
	
	d ..CompareAndSaveResult(objTarItm)    ;比较当前数据与医保目录中的数据之间的差异并保存差异结果信息
}

/// 功能说明：比较当前数据与医保目录中的数据之间的差异并保存差异结果信息
/// 入参说明：objTarItm     --> 下载的目录数据对象 
/// 修改履历：董科锋 2020 02 19 新做成
ClassMethod CompareAndSaveResult(objTarItm As User.InsuTaritemsTmp) As %Status
{
	//触发器的比较方法是否生效 1 生效(默认) 0 不生效
	s TriggerActiveFlg=##class(web.DHCINSUPort).GetDicByCodeAndInd("INSU_Global_ProCase", "TriggerActiveFlg", 6)  
	s:TriggerActiveFlg="" TriggerActiveFlg="1"
	q:TriggerActiveFlg'="1" $$$OK
	
	//判断比较数据是否有差异的方法是否存在 不存在的情况下退出
	s CompareClassName="web.InsuTaritemsTmpCtl"
	s CompareMethod="CompareTarItem"
	s haveMethodFlg=##class(websys.Conversions).IsValidMethodName(CompareClassName, CompareMethod)
	q:haveMethodFlg'="1" $$$OK
	
	q:$isobject(objTarItm)=0 $$$OK             ;非对象直接退出
	s DifferenceFlg=objTarItm.DifferenceFlg    ;差异标志 A：新增 U:更新 E:失效 0：无差异 99：未比较(默认)
	q:DifferenceFlg'="99" $$$OK                ;已比较过的数据不需再次比较
	s AuditImportFlg=objTarItm.AuditImportFlg  ;审核导入标记 0：未审核 1：审核导入
	q:AuditImportFlg'="0" $$$OK                ;已审核的数据不再需要比较
	
	//调用比较方法 判断当前数据是否有差异
	s Common=""
	s RtnFlg=##class(web.InsuTaritemsTmpCtl).CompareTarItem(objTarItm, .Common)    ;当前数据在医保目录表中是否存在
	q:RtnFlg="99" $$$OK      ;未比较的场合、直接退出
	
	//保存差异结果信息
	s objTarItm.DifferenceFlg=RtnFlg
	s objTarItm.DifferenceCom=Common
	s sc=objTarItm.%Save()
	
	q $$$OK
}
*/
Storage Default
{
<Data name="InsuTaritemsDLDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>INTIMsfdlbm</Value>
</Value>
<Value name="3">
<Value>INTIMsfxmbm</Value>
</Value>
<Value name="4">
<Value>INTIMxmbm</Value>
</Value>
<Value name="5">
<Value>INTIMxmmc</Value>
</Value>
<Value name="6">
<Value>INTIMxmrj</Value>
</Value>
<Value name="7">
<Value>INTIMtxbz</Value>
</Value>
<Value name="8">
<Value>INTIMxmlb</Value>
</Value>
<Value name="9">
<Value>INTIMjx</Value>
</Value>
<Value name="10">
<Value>INTIMgg</Value>
</Value>
<Value name="11">
<Value>INTIMdw</Value>
</Value>
<Value name="12">
<Value>INTIMyf</Value>
</Value>
<Value name="13">
<Value>INTIMyl</Value>
</Value>
<Value name="14">
<Value>INTIMsl</Value>
</Value>
<Value name="15">
<Value>INTIMpzwh</Value>
</Value>
<Value name="16">
<Value>INTIMbzjg</Value>
</Value>
<Value name="17">
<Value>INTIMsjjg</Value>
</Value>
<Value name="18">
<Value>INTIMzgxj</Value>
</Value>
<Value name="19">
<Value>INTIMzfbl1</Value>
</Value>
<Value name="20">
<Value>INTIMzfbl2</Value>
</Value>
<Value name="21">
<Value>INTIMzfbl3</Value>
</Value>
<Value name="22">
<Value>INTIMbpxe</Value>
</Value>
<Value name="23">
<Value>INTIMbz</Value>
</Value>
<Value name="24">
<Value>INTIMtjdm</Value>
</Value>
<Value name="25">
<Value>INTIMflzb1</Value>
</Value>
<Value name="26">
<Value>INTIMflzb2</Value>
</Value>
<Value name="27">
<Value>INTIMflzb3</Value>
</Value>
<Value name="28">
<Value>INTIMflzb4</Value>
</Value>
<Value name="29">
<Value>INTIMflzb5</Value>
</Value>
<Value name="30">
<Value>INTIMflzb6</Value>
</Value>
<Value name="31">
<Value>INTIMflzb7</Value>
</Value>
<Value name="32">
<Value>INTIMspmc</Value>
</Value>
<Value name="33">
<Value>INTIMspmcrj</Value>
</Value>
<Value name="34">
<Value>INTIMljzfbz</Value>
</Value>
<Value name="35">
<Value>INTIMyyjzjbz</Value>
</Value>
<Value name="36">
<Value>INTIMyysmbm</Value>
</Value>
<Value name="37">
<Value>INTIMfplb</Value>
</Value>
<Value name="38">
<Value>INTIMDicType</Value>
</Value>
<Value name="39">
<Value>INTIMUserDR</Value>
</Value>
<Value name="40">
<Value>INTIMDate</Value>
</Value>
<Value name="41">
<Value>INTIMTime</Value>
</Value>
<Value name="42">
<Value>INTIMADDIP</Value>
</Value>
<Value name="43">
<Value>INTIMActiveDate</Value>
</Value>
<Value name="44">
<Value>INTIMUnique</Value>
</Value>
<Value name="45">
<Value>INTIMExpiryDate</Value>
</Value>
<Value name="46">
<Value>ActiveFlg</Value>
</Value>
<Value name="47">
<Value>DataVersion</Value>
</Value>
<Value name="48">
<Value>DifferenceCate</Value>
</Value>
<Value name="49">
<Value>DifferenceCom</Value>
</Value>
<Value name="50">
<Value>AuditImportFlag</Value>
</Value>
<Value name="51">
<Value>AuiditUserCode</Value>
</Value>
<Value name="52">
<Value>RefuseCommon</Value>
</Value>
<Value name="53">
<Value>AuiditDate</Value>
</Value>
<Value name="54">
<Value>AuiditTime</Value>
</Value>
<Value name="55">
<Value>TarItmesDr</Value>
</Value>
<Value name="56">
<Value>HospId</Value>
</Value>
</Data>
<DataLocation>^User.InsuTaritemsDLD</DataLocation>
<DefaultData>InsuTaritemsDLDefaultData</DefaultData>
<IdLocation>^User.InsuTaritemsDLD</IdLocation>
<IndexLocation>^User.InsuTaritemsDLI</IndexLocation>
<StreamLocation>^User.InsuTaritemsDLS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
