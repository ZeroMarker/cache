/// 名称: DHCMed.CD.CRReportTNB
/// 描述: 糖尿病报卡信息
/// 编写者：zhufei
/// 编写日期: 2015-08-21
Class DHCMed.CD.CRReportTNB Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.CD.CRReport [ Cardinality = parent, Inverse = ChildTNB ];

/// 卡片编号
Property CRKPBH As %String;

/// 诊断类型
Property CRZDLX As DHCMed.SS.Dictionary;

/// 诊断
Property CRZD As %String;

/// 诊断ICD-10
Property CRZDICD As %String;

/// 并发症
Property CRBFZ As list Of DHCMed.SS.Dictionary;

/// 危害因素
Property CRWHYS As list Of DHCMed.SS.Dictionary;

/// 体重
Property CRTZ As %String;

/// 身高
Property CRSG As %String;

/// 家族史
Property CRJZS As list Of DHCMed.SS.Dictionary;

/// 父母兄妹人数
Property CRRS As %String;

/// 诊断日期
Property CRZDRQ As %Date;

/// 死亡日期
Property CRSWRQ As %Date;

/// 死亡原因
Property CRSWYY As DHCMed.SS.Dictionary;

/// 死亡具体原因
Property CRJTSWYY As %String(MAXLEN = 200);

/// 死因ICD-10
Property CRSYICD As %String;

/// 死亡诊断
Property CRSWZD As %String;

/// 临床表现
Property CRLCBX As list Of DHCMed.SS.Dictionary;

/// 其他临床表现
Property CRQTLCBX As %String(MAXLEN = 200);

/// 最高诊断单位
Property CRZGZDDW As DHCMed.SS.Dictionary;

/// E1 空腹血糖值
Property CRZYJCQK1 As %String;

/// E2 随机血糖值
Property CRZYJCQK2 As %String;

/// E3 OGTT
Property CRZYJCQK3 As %String;

/// E4 总胆固醇
Property CRZYJCQK4 As %String;

/// E5 HDL-C
Property CRZYJCQK5 As %String;

/// E6 LDL-C
Property CRZYJCQK6 As %String;

/// E7 甘油三酯
Property CRZYJCQK7 As %String;

/// E8 尿微量蛋白
Property CRZYJCQK8 As %String;

/// E9 糖化血红蛋白
Property CRZYJCQK9 As %String;

/// Creator：     jiangpengpeng
/// CreatDate：   2015-11-02
/// Description:  根据ParRef取糖尿病卡信息
/// Table：       DHCMed.CD.CRReportTNB
/// Input：       ID:    DHCMed.CD.CRReportTNB.ParRef
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportTNB).GetObjByParRef(1)
ClassMethod GetObjByParRef(ParRef As %String) As DHCMed.CD.CRReportTNB
{
	new (ParRef)
	set return=""
	quit:ParRef="" return
	
	Set SubID=$o(^DHCMed.CD.CRReportD(+ParRef,"TNB",0))
	Set obj=##class(DHCMed.CD.CRReportTNB).GetObjById(ParRef_"||"_SubID)
	set return=obj
	quit return
}

Method ToString(separete As %String, Languages As %String = "") As %String
{
	new (separete,Languages)
	Set return=..CRKPBH_separete
	Set return=return_..GetDicByObj(..CRZDLX,Languages)_separete	//1
	
	Set return=return_..GetICDDescByID(..CRZD,Languages)_separete
	Set return=return_..CRZDICD_separete	//3
	
	Set BFZ=..CRBFZ
	Set BFZstr=""
	For ind=1:1:BFZ.Count() {
		Set objDic=BFZ.GetAt(ind)
		Continue:'$IsObject(objDic)
		Set BFZstr=BFZstr_","_objDic.%Id()
	}
	Set:BFZstr'="" BFZstr=$e(BFZstr,2,$l(BFZstr))
	Set return=return_BFZstr_separete		//4
	
	Set WHYS=..CRWHYS
	Set WHYSstr=""
	For ind=1:1:WHYS.Count() {
		Set objDic=WHYS.GetAt(ind)
		Continue:'$IsObject(objDic)
		Set WHYSstr=WHYSstr_","_objDic.%Id()
	}
	Set:WHYSstr'="" WHYSstr=$e(WHYSstr,2,$l(WHYSstr))
	Set return=return_WHYSstr_separete	//5
	
	Set return=return_..CRTZ_separete
	Set return=return_..CRSG_separete
	
	Set JZS=..CRJZS
	Set JZSstr=""
	For ind=1:1:JZS.Count() {
		Set objDic=JZS.GetAt(ind)
		Continue:'$IsObject(objDic)
		Set JZSstr=JZSstr_","_objDic.%Id()
	}
	Set:JZSstr'="" JZSstr=$e(JZSstr,2,$l(JZSstr))
	Set return=return_JZSstr_separete	//8
	
	Set return=return_..CRRS_separete
	Set ZDRQ=..CRZDRQ
	;Set:ZDRQ'="" ZDRQ=$zd(ZDRQ,3)
	Set:ZDRQ'="" ZDRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ZDRQ)
	Set return=return_ZDRQ_separete	//10
	Set SWRQ=..CRSWRQ
	;Set:SWRQ'="" SWRQ=$zd(SWRQ,3)
	Set:SWRQ'="" SWRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SWRQ)
	Set return=return_SWRQ_separete
	Set return=return_..GetDicByObj(..CRSWYY,Languages)_separete	//12
	Set return=return_..CRJTSWYY_separete
	Set return=return_..CRSYICD_separete	//14
	Set return=return_..GetICDDescByID(..CRSWZD,Languages)_separete
	Set LCBX=..CRLCBX
	Set LCBXstr=""
	For ind=1:1:LCBX.Count() {
		Set objDic=LCBX.GetAt(ind)
		Continue:'$IsObject(objDic)
		Set LCBXstr=LCBXstr_","_objDic.%Id()
	}
	Set:LCBXstr'="" LCBXstr=$e(LCBXstr,2,$l(LCBXstr))
	Set return=return_LCBXstr_separete	//16
	
	Set return=return_..CRQTLCBX_separete
	Set return=return_..GetDicByObj(..CRZGZDDW,Languages)_separete
	Set return=return_..CRZYJCQK1_separete
	Set return=return_..CRZYJCQK2_separete
	Set return=return_..CRZYJCQK3_separete
	Set return=return_..CRZYJCQK4_separete
	Set return=return_..CRZYJCQK5_separete
	Set return=return_..CRZYJCQK6_separete
	Set return=return_..CRZYJCQK7_separete
	Set return=return_..CRZYJCQK8_separete
	Set return=return_..CRZYJCQK9_separete
	quit return
}

ClassMethod GetDicByObj(obj As DHCMed.SS.Dictionary, Languages As %String = "") As %String
{
	new (obj,Languages)
	set return=""
	quit:'$IsObject(obj) return
	
	set return=obj.%Id()_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,obj.Description)
	quit return
}

ClassMethod GetICDDescByID(ICDRowID As %String, Languages As %String = "") As %String
{
	new (ICDRowID,Languages)
	set return=""
	Quit:ICDRowID="" return
	
	Set tmp=$g(^MRC("ID",ICDRowID))
	Quit:tmp="" return
	Set ICDDesc=$p(tmp,"^",2)
	Set ICDDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.MRCICDDx","MRCIDDesc",Languages,ICDDesc)
	
	set return=ICDRowID_$c(1)_ICDDesc
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-11-03
/// Description:  根据ParRef取糖尿病卡信息
/// Table：       DHCMed.CD.CRReportTNB
/// Input：       ID:    DHCMed.CD.CRReportTNB.ParRef
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportTNB).GetStringByParRef(13)
ClassMethod GetStringByParRef(ParRef As %String) As %String
{
	new (ParRef,%session)
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	set return=""
	quit:ParRef="" return
	
	Set obj=##class(DHCMed.CD.CRReportTNB).GetObjByParRef(ParRef)
	if $IsObject(obj){
		set return=obj.ToString("^",Languages)
	}
	quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-11-03
/// Description:  根据ID取糖尿病卡信息
/// Table：       DHCMed.CD.CRReportTNB
/// Input：       ID:    DHCMed.CD.CRReportTNB.ID
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportTNB).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CD.CRReportTNB
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CD.CRReportTNB).%ExistsId(id) return
	set obj=##Class(DHCMed.CD.CRReportTNB).%OpenId(id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-11-03
/// Description:  更新主卡信息
/// Table：       DHCMed.CD.CRReportTNB
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.CD.CRReportTNB).Update("")
ClassMethod Update(aInput As %String, separete As %String) As %String
{
	new (aInput,separete)
	set return=0
	quit:aInput="" return
	
	Set Parref=$p(aInput,separete,1)
	Set SubID=$o(^DHCMed.CD.CRReportD(Parref,"TNB",0))
	
	If (SubID="") {
		Set obj=##class(DHCMed.CD.CRReportTNB).%New()
	} Else {
		Set obj=##class(DHCMed.CD.CRReportTNB).%OpenId(Parref_"||"_SubID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ParRef=##class(DHCMed.CD.CRReport).GetObjById(Parref)
	Set CardNo=$p(aInput,separete,2)
	If (CardNo="") {
		Set CardNo=##class(DHCMed.CDService.Service).GetNewRepNo("TNB")
	}
	Set obj.CRKPBH=CardNo
	Set CRZDLXID=$p(aInput,separete,3)
	Set obj.CRZDLX=##class(DHCMed.SS.Dictionary).GetObjById(CRZDLXID)
	Set obj.CRZD=$p(aInput,separete,4)
	Set obj.CRZDICD=$p(aInput,separete,5)
	
	Set CRBFZs=$p(aInput,separete,6)
	While (obj.CRBFZ.Count()>0) {
		Do obj.CRBFZ.RemoveAt(1)
	}
	Set CRBFZLB=""
	For ind=1:1:$length(CRBFZs,",") {
		Set CRBFZ=$p(CRBFZs,",",ind)
		Continue:($listfind(CRBFZLB,CRBFZ)>0)
		Set CRBFZLB=CRBFZLB_$lb(CRBFZ)
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(CRBFZ)
		Continue:'$IsObject(objDic)
		Do obj.CRBFZ.Insert(objDic)
	}
	
	Set CRWHYSs=$p(aInput,separete,7)
	While (obj.CRWHYS.Count()>0) {
		Do obj.CRWHYS.RemoveAt(1)
	}
	Set CRWHYSLB=""
	For ind=1:1:$length(CRWHYSs,",") {
		Set CRWHYS=$p(CRWHYSs,",",ind)
		Continue:($listfind(CRWHYSLB,CRWHYS)>0)
		Set CRWHYSLB=CRWHYSLB_$lb(CRWHYS)
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(CRWHYS)
		Continue:'$IsObject(objDic)
		Do obj.CRWHYS.Insert(objDic)
	}
	
	Set obj.CRTZ=$p(aInput,separete,8)
	Set obj.CRSG=$p(aInput,separete,9)
	
	Set CRJZSs=$p(aInput,separete,10)
	While (obj.CRJZS.Count()>0) {
		Do obj.CRJZS.RemoveAt(1)
	}
	Set CRJZSLB=""
	For ind=1:1:$length(CRJZSs,",") {
		Set CRJZS=$p(CRJZSs,",",ind)
		Continue:($listfind(CRJZSLB,CRJZS)>0)
		Set CRJZSLB=CRJZSLB_$lb(CRJZS)
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(CRJZS)
		Continue:'$IsObject(objDic)
		Do obj.CRJZS.Insert(objDic)
	}
	
	Set obj.CRRS=$p(aInput,separete,11)
	Set CRZDRQ=$p(aInput,separete,12)
	;Set:CRZDRQ["-" CRZDRQ=$zdh(CRZDRQ,3)
	Set:CRZDRQ'="" CRZDRQ=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(CRZDRQ)
	Set obj.CRZDRQ=CRZDRQ
	Set CRSWRQ=$p(aInput,separete,13)
	;Set:CRSWRQ["-" CRSWRQ=$zdh(CRSWRQ,3)
	Set:CRSWRQ'="" CRSWRQ=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(CRSWRQ)
	Set obj.CRSWRQ=CRSWRQ
	Set CRSWYYID=$p(aInput,separete,14)
	Set obj.CRSWYY=##class(DHCMed.SS.Dictionary).GetObjById(CRSWYYID)
	Set obj.CRSYICD=$p(aInput,separete,15)
	Set obj.CRJTSWYY=$p(aInput,separete,16)
	Set obj.CRSWZD=$p(aInput,separete,17)
	Set CRLCBXs=$p(aInput,separete,18)
	While (obj.CRLCBX.Count()>0) {
		Do obj.CRLCBX.RemoveAt(1)
	}
	Set CRLCBXLB=""
	For ind=1:1:$length(CRLCBXs,",") {
		Set CRLCBX=$p(CRLCBXs,",",ind)
		Continue:($listfind(CRLCBXLB,CRLCBX)>0)
		Set CRLCBXLB=CRLCBXLB_$lb(CRLCBX)
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(CRLCBX)
		Continue:'$IsObject(objDic)
		Do obj.CRLCBX.Insert(objDic)
	}
	
	Set obj.CRQTLCBX=$p(aInput,separete,19)
	Set CRZGZDDWID=$p(aInput,separete,20)
	Set obj.CRZGZDDW=##class(DHCMed.SS.Dictionary).GetObjById(CRZGZDDWID)
	Set obj.CRZYJCQK1=$p(aInput,separete,21)
	Set obj.CRZYJCQK2=$p(aInput,separete,22)
	Set obj.CRZYJCQK3=$p(aInput,separete,23)
	Set obj.CRZYJCQK4=$p(aInput,separete,24)
	Set obj.CRZYJCQK5=$p(aInput,separete,25)
	Set obj.CRZYJCQK6=$p(aInput,separete,26)
	Set obj.CRZYJCQK7=$p(aInput,separete,27)
	Set obj.CRZYJCQK8=$p(aInput,separete,28)
	Set obj.CRZYJCQK9=$p(aInput,separete,29)
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

Storage Default
{
<Data name="CRReportTNBDefaultData">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>CRKPBH</Value>
</Value>
<Value name="2">
<Value>CRZDLX</Value>
</Value>
<Value name="3">
<Value>CRZD</Value>
</Value>
<Value name="4">
<Value>CRZDICD</Value>
</Value>
<Value name="5">
<Value>CRBFZ</Value>
</Value>
<Value name="6">
<Value>CRWHYS</Value>
</Value>
<Value name="7">
<Value>CRTZ</Value>
</Value>
<Value name="8">
<Value>CRSG</Value>
</Value>
<Value name="9">
<Value>CRJZS</Value>
</Value>
<Value name="10">
<Value>CRRS</Value>
</Value>
<Value name="11">
<Value>CRSWRQ</Value>
</Value>
<Value name="12">
<Value>CRSWYY</Value>
</Value>
<Value name="13">
<Value>CRJTSWYY</Value>
</Value>
<Value name="14">
<Value>CRSYICD</Value>
</Value>
<Value name="15">
<Value>CRLCBX</Value>
</Value>
<Value name="16">
<Value>CRQTLCBX</Value>
</Value>
<Value name="17">
<Value>CRZDRQ</Value>
</Value>
<Value name="18">
<Value>CRSWZD</Value>
</Value>
<Value name="19">
<Value>CRZGZDDW</Value>
</Value>
<Value name="20">
<Value>CRZYJCQK1</Value>
</Value>
<Value name="21">
<Value>CRZYJCQK2</Value>
</Value>
<Value name="22">
<Value>CRZYJCQK3</Value>
</Value>
<Value name="23">
<Value>CRZYJCQK4</Value>
</Value>
<Value name="24">
<Value>CRZYJCQK5</Value>
</Value>
<Value name="25">
<Value>CRZYJCQK6</Value>
</Value>
<Value name="26">
<Value>CRZYJCQK7</Value>
</Value>
<Value name="27">
<Value>CRZYJCQK8</Value>
</Value>
<Value name="28">
<Value>CRZYJCQK9</Value>
</Value>
</Data>
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("TNB")</DataLocation>
<DefaultData>CRReportTNBDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("TNB")</IdLocation>
<IndexLocation>^DHCMed.CD.CRReportI("TNB")</IndexLocation>
<StreamLocation>^DHCMed.CD.CRReportTNBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
