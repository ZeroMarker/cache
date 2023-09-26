/// 名称: DHCMed.CD.CRReportXNXG
/// 描述: 心脑血管报卡
/// 编写者：zhouruimeng
/// 编写日期: 2015-08-20
Class DHCMed.CD.CRReportXNXG Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 主表ID
Relationship ParRef As DHCMed.CD.CRReport [ Cardinality = parent, Inverse = ChildXNXG ];

/// 卡片编号
Property CRKPBH As %String;

/// 报告卡类型CRReportType
Property CRBGKLX As DHCMed.SS.Dictionary;

/// 诊断ID
Property CRZDID As %String;

/// 诊断编码 ICD10
Property CRZDBM As %String;

/// 诊断名称
Property CRZDMC As %String;

/// 诊断分类
Property CRZDFL As DHCMed.SS.Dictionary;

/// 诊断依据 List of DHCMed.SS.Dictionary
Property CRZDYJ As list Of DHCMed.SS.Dictionary;

/// 病史
Property CRBS As list Of DHCMed.SS.Dictionary;

/// 首要症状(脑卒中)
Property CRSYZZ As list Of DHCMed.SS.Dictionary;

/// 发病日期
Property CRFBRQ As %Date;

/// 确诊日期
Property CRQZRQ As %Date;

/// 是否首次发病
Property CRSFSCFB As DHCMed.SS.Dictionary;

/// 确诊单位
Property CRQZDW As DHCMed.SS.Dictionary;

/// 转归
Property CRZG As DHCMed.SS.Dictionary;

/// 死亡日期
Property CRSWRQ As %Date;

/// 死亡原因
Property CRSWYY As DHCMed.SS.Dictionary;

/// 死因ID(ICD10)
Property CRSYID As %String;

/// 死因诊断
Property CRSWZD As %String;

/// 死因编码 ICD10
Property CRSYBM As %String;

/// 死因名称 ICD-10名称
Property CRSYMC As %String;

/// 病史摘要
Property CRBSZY As %String(MAXLEN = 500);

/// 死后推断
Property CRSHTD As DHCMed.SS.Dictionary;

/// 时间间隔
Property CRSJJG As DHCMed.SS.Dictionary;

/// 报卡地址-省
Property CRRepProvince As DHCMed.SS.AreaDic;

/// 报卡地址-市
Property CRRepCity As DHCMed.SS.AreaDic;

/// 报卡地址-县
Property CRRepCounty As DHCMed.SS.AreaDic;

/// 证件类型
Property CRCardType As DHCMed.SS.Dictionary;

/// 是否居住六个月以上
Property CRLiveSix As DHCMed.SS.Dictionary;

/// 单位级别
Property CRLevel As DHCMed.SS.Dictionary;

/// 转归
Property CROutCome As DHCMed.SS.Dictionary;

/// 心绞痛治疗措施
Property CRCureMethod As DHCMed.SS.Dictionary;

/// 脑卒中类型
Property CRApoplexyType As DHCMed.SS.Dictionary;

/// 确诊/推断
Property CRSCD As DHCMed.SS.Dictionary;

/// 推断依据
Property CRInfer As DHCMed.SS.Dictionary;

/// 诊断
Property CRDaig As DHCMed.SS.Dictionary;

/// 生化标志物
Property CRBiochemicalMark As DHCMed.SS.Dictionary;

/// 补发
Property CRReissue As DHCMed.SS.Dictionary;

/// Creator：     zhouruimeng
/// CreatDate：   2015-08-20
/// Description:  根据ID取报卡信息
/// Table：       DHCMed.CD.CRReportXNXG
/// Input：       ID:    DHCMed.CD.CRReportXNXG.ID
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportXNXG).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CD.CRReportXNXG
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CD.CRReportXNXG).%ExistsId(id) return
	set obj=##Class(DHCMed.CD.CRReportXNXG).%OpenId(id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-08-20
/// Description:  根据ParRef取心脑血管报卡信息
/// Table：       DHCMed.CD.CRReportXNXG
/// Input：       ID:    DHCMed.CD.CRReportXNXG.ParRef
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportXNXG).GetObjByParRef(1)
ClassMethod GetObjByParRef(ParRef As %String) As DHCMed.CD.CRReportXNXG
{
	new (ParRef)
	set return=""
	quit:ParRef="" return
	
	Set SubID=$o(^DHCMed.CD.CRReportD(+ParRef,"XNXG",0))
	Set obj=##class(DHCMed.CD.CRReportXNXG).GetObjById(ParRef_"||"_SubID)
	set return=obj
	quit return
}

Method ToString(separete As %String, Languages As %String = "") As %String
{
	new (separete,Languages)
	Set return=..CRKPBH_separete
	//Set return=return_..CRZDID_separete  //1
	Set return=return_..GetICDDescByID(..CRZDID,Languages)_separete  
	Set return=return_..CRZDBM_separete
	Set return=return_..CRZDMC_separete	 //诊断名称实际存储诊断分类描述
	Set return=return_..GetDicByObj(..CRZDFL,Languages)_separete
	Set CRZDYJDrs=..CRZDYJ                 // 诊断依据
	Set CRZDYJList=""
	For ind=1:1:CRZDYJDrs.Count() {
		Set objDic=CRZDYJDrs.GetAt(ind)
		Continue:'$IsObject(objDic)
		Set CRZDYJList=CRZDYJList_","_objDic.%Id()
	}
	Set:CRZDYJList'="" CRZDYJList=$e(CRZDYJList,2,$l(CRZDYJList))
	Set return=return_CRZDYJList_separete 
	
	Set BS=..CRBS
	Set BSstr=""
	For ind=1:1:BS.Count() {
		Set objDic=BS.GetAt(ind)
		Continue:'$IsObject(objDic)
		Set BSstr=BSstr_","_objDic.%Id()
	}
	Set:BSstr'="" BSstr=$e(BSstr,2,$l(BSstr))
	Set return=return_BSstr_separete	//6
	
	Set FBRQ=..CRFBRQ
	;Set:FBRQ'="" FBRQ=$zd(FBRQ,3)
	Set:FBRQ'="" FBRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(FBRQ)
	Set return=return_FBRQ_separete	//7
	Set QZRQ=..CRQZRQ
	;Set:QZRQ'="" QZRQ=$zd(QZRQ,3)
	Set:QZRQ'="" QZRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(QZRQ)
	Set return=return_QZRQ_separete //8
	Set return=return_..GetDicByObj(..CRSFSCFB,Languages)_separete
	Set return=return_..GetDicByObj(..CRQZDW,Languages)_separete
	Set return=return_..GetDicByObj(..CRZG,Languages)_separete	//11
	Set SWRQ=..CRSWRQ
	;Set:SWRQ'="" SWRQ=$zd(SWRQ,3)
	Set:SWRQ'="" SWRQ=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SWRQ)
	Set return=return_SWRQ_separete
	Set return=return_..GetDicByObj(..CRSWYY,Languages)_separete
	Set return=return_..CRSYID_separete	//14
	Set return=return_..CRSYBM_separete
	Set return=return_..CRSYMC_separete
	Set return=return_..CRBSZY_separete	//17
	Set return=return_..GetDicByObj(..CRBGKLX,Languages)_separete
	
	Set SYZZ=..CRSYZZ
	Set SYZZstr=""
	For ind=1:1:SYZZ.Count() {
		Set objDic=SYZZ.GetAt(ind)
		Continue:'$IsObject(objDic)
		Set SYZZstr=SYZZstr_","_objDic.%Id()
	}
	Set:SYZZstr'="" SYZZstr=$e(SYZZstr,2,$l(SYZZstr))
	Set return=return_SYZZstr_separete
	
	Set return=return_..GetDicByObj(..CRSHTD,Languages)_separete	//20
	Set return=return_..GetDicByObj(..CRSJJG,Languages)_separete
	Set return=return_..GetICDDescByID(..CRSWZD,Languages)_separete
	
	Set return=return_..GetAreaByObj(..CRRepProvince)_separete
	Set return=return_..GetAreaByObj(..CRRepCity)_separete
	Set return=return_..GetAreaByObj(..CRRepCounty)_separete
	Set return=return_..GetDicByObj(..CRCardType,Languages)_separete
	Set return=return_..GetDicByObj(..CRLiveSix,Languages)_separete
	Set return=return_..GetDicByObj(..CRLevel,Languages)_separete
	Set return=return_..GetDicByObj(..CROutCome,Languages)_separete
	
	Set return=return_..GetDicByObj(..CRCureMethod,Languages)_separete
	Set return=return_..GetDicByObj(..CRApoplexyType,Languages)_separete
	Set return=return_..GetDicByObj(..CRSCD,Languages)_separete
	Set return=return_..GetDicByObj(..CRInfer,Languages)_separete
	Set return=return_..GetDicByObj(..CRDaig,Languages)_separete
	Set return=return_..GetDicByObj(..CRBiochemicalMark,Languages)_separete
	Set return=return_..GetDicByObj(..CRReissue,Languages)_separete

	Quit return
}

ClassMethod GetAreaByObj(obj As DHCMed.SS.AreaDic) As %String
{
	new (obj)
	set return=""
	quit:'$IsObject(obj) return
	
	set return=obj.%Id()_$c(1)_obj.ShortDesc
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
/// CreatDate：   2015-08-20
/// Description:  根据ParRef取心脑血管报卡信息
/// Table：       DHCMed.CD.CRReportXNXG
/// Input：       ID:    DHCMed.CD.CRReportXNXG.ParRef
/// Return：      返回Object
/// w ##class(DHCMed.CD.CRReportXNXG).GetStringByParRef(25)
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
	
	Set obj=##class(DHCMed.CD.CRReportXNXG).GetObjByParRef(ParRef)
	if $IsObject(obj){
		set return=obj.ToString("^",Languages)
	}
	quit return
}

/// Creator：     zhouruimeng
/// CreatDate：   2015-08-21
/// Description:  更新心脑血管报卡信息
/// Table：       DHCMed.CD.CRReportXNXG
/// Input：       主卡ID以及各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.CD.CRReportXNXG).Update("31^2022020004^647^6489^I21.900^^6428,6433^^2022-01-05^2022-01-05^6446^751^^2022-01-05^^C90.206^^^^^^2562^2^3^23^6438^6446^6449^6453^6497^6498^6505^6506","^")
ClassMethod Update(InputStr As %String, Separete As %String) As %String
{
	New (InputStr,Separete)
	Set return=0
	Quit:InputStr="" return
	
	Set Parref=$p(InputStr,Separete,1)
	Set SubID=$o(^DHCMed.CD.CRReportD(Parref,"XNXG",0))
	
	If (SubID="") {
		Set obj=##class(DHCMed.CD.CRReportXNXG).%New()
	} Else {
		Set obj=##class(DHCMed.CD.CRReportXNXG).%OpenId(Parref_"||"_SubID)
	}
	Quit:'$IsObject(obj) return
	
	Set CardNo     = $p(InputStr,Separete,2)	//卡片编码
	Set RepType    = $p(InputStr,Separete,3)	//报告卡类型
	Set Diagnose   = $p(InputStr,Separete,4)	//诊断ID
	Set ICD10      = $p(InputStr,Separete,5)	//ICD编码
	Set DiagnoseType   = $p(InputStr,Separete,6)	//诊断分类
	Set CRZDFLID	   = $p(DiagnoseType,",",1)
	Set ICDDesc	   = $p(DiagnoseType,",",2)
	Set DiagBase   = $p(InputStr,Separete,7)	//诊断依据
	Set History    = $p(InputStr,Separete,8)	//病史
	Set InfDate    = $p(InputStr,Separete,9)	//发病日期
	Set DisDate	   = $p(InputStr,Separete,10)	//确诊日期
	Set IsFirstInf = $p(InputStr,Separete,11)	//是否首次发病
	Set DiagUnit   = $p(InputStr,Separete,12)	//确诊单位
	Set Prognosis  = $p(InputStr,Separete,13)	//转归
	Set DeathDate  = $p(InputStr,Separete,14)	//死亡日期
	Set DeathReason= $p(InputStr,Separete,15)	//死亡原因
	Set DeathReasonID=$p(DeathReason,",",1)
	Set DeathReasonDesc=$p(DeathReason,",",2)
	Set DeathICD   = $p(InputStr,Separete,16)	//死亡ICD
	Set DeathCause = $p(InputStr,Separete,17)	//死亡名称
	Set Symptom	   = $p(InputStr,Separete,18)	//首要症状(脑卒中)
	Set CRBSZY     = $p(InputStr,Separete,19)
	Set CRSHTD     = $p(InputStr,Separete,20)
	Set CRSJJG     = $p(InputStr,Separete,21)
	Set CRSWZD     = $p(InputStr,Separete,22)
	
	Set CRRepProvince   = $p(InputStr,Separete,23)
	Set CRRepCity     	= $p(InputStr,Separete,24)
	Set CRRepCounty     = $p(InputStr,Separete,25)
	Set CRCardType      = $p(InputStr,Separete,26)
	Set CRLiveSix       = $p(InputStr,Separete,27)
	Set CRLevel         = $p(InputStr,Separete,28)
	Set CROutCome       = $p(InputStr,Separete,29)
	
	Set CRCureMethod    = $p(InputStr,Separete,30)
	Set CRApoplexyType  = $p(InputStr,Separete,31)
	Set CRSCD       	= $p(InputStr,Separete,32)
	Set CRInfer       	= $p(InputStr,Separete,33)
	Set BiochemicalMark = $p(InputStr,Separete,34)
	Set Reissue       	= $p(InputStr,Separete,35)
	;Set:InfDate["-" InfDate=$zdh(InfDate,3)
	;Set:InfDate["\" InfDate=$zdh(InfDate,4)
	Set:InfDate'="" InfDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(InfDate)
	;Set:DisDate["-" DisDate=$zdh(DisDate,3)
	;Set:DisDate["\" DisDate=$zdh(DisDate,4)
	Set:DisDate'="" DisDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(DisDate)
	;Set:DeathDate["-" DeathDate=$zdh(DeathDate,3)
	;Set:DeathDate["\" DeathDate=$zdh(DeathDate,4)
	Set:DeathDate'="" DeathDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(DeathDate)
	
	Set obj.ParRef   = ##class(DHCMed.CD.CRReport).GetObjById(Parref)
	If (CardNo="") {
		Set CardNo=##class(DHCMed.CDService.Service).GetNewRepNo("XNXG")
	}
	Set obj.CRKPBH   = CardNo
	Set obj.CRZDID   = ""
	Set obj.CRZDBM   = ICD10
	Set obj.CRZDMC   = ICDDesc
	Set obj.CRBGKLX  =##class(DHCMed.SS.Dictionary).GetObjById(RepType)
	Set obj.CRZDFL   =##class(DHCMed.SS.Dictionary).GetObjById(CRZDFLID)         //诊断分类
   
	While (obj.CRZDYJ.Count()>0) {
		Do obj.CRZDYJ.RemoveAt(1)
	}
	Set DiagBaselList=""
	For ind=1:1:$length(DiagBase,",") {
		Set aDiagBase=$p(DiagBase,",",ind)
		Continue:($listfind(DiagBaselList,aDiagBase)>0)
		Set DiagBaselList=DiagBaselList_$lb(aDiagBase)
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(aDiagBase)
		Continue:'$IsObject(objDic)
		Do obj.CRZDYJ.Insert(objDic)
	}
	
	While (obj.CRBS.Count()>0) {
		Do obj.CRBS.RemoveAt(1)
	}
	For i=1:1:$l(History,","){
		Set tmpID=$p(History,",",i)
		Continue:tmpID=""
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(tmpID)
		Continue:'$IsObject(objDic)
		Do obj.CRBS.Insert(objDic)	//病史,List
	}
	
	While (obj.CRSYZZ.Count()>0) {
		Do obj.CRSYZZ.RemoveAt(1)
	}
	For i=1:1:$l(Symptom,","){
		Set tmpID=$p(Symptom,",",i)
		Continue:tmpID=""
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(tmpID)
		Continue:'$IsObject(objDic)
		Do obj.CRSYZZ.Insert(objDic)	//病史,List
	}
	
	Set obj.CRFBRQ   = InfDate
	Set obj.CRQZRQ   = DisDate
	Set obj.CRSFSCFB = ##class(DHCMed.SS.Dictionary).GetObjById(+IsFirstInf)
	Set obj.CRQZDW   = ##class(DHCMed.SS.Dictionary).GetObjById(+DiagUnit)
	Set obj.CRZG   	 = ##class(DHCMed.SS.Dictionary).GetObjById(+Prognosis)
	Set obj.CRSWRQ   = DeathDate
	Set obj.CRSWYY   = ##class(DHCMed.SS.Dictionary).GetObjById(+DeathReasonID)
	Set obj.CRSYID   = DeathReasonID
	Set obj.CRSYBM   = DeathICD
	Set obj.CRSYMC   = DeathCause
	Set obj.CRBSZY	 = CRBSZY
	Set obj.CRSHTD	 = ##class(DHCMed.SS.Dictionary).GetObjById(+CRSHTD)
	Set obj.CRSJJG	 = ##class(DHCMed.SS.Dictionary).GetObjById(+CRSJJG)
	Set obj.CRSWZD   = CRSWZD
	Set obj.CRRepProvince = ##class(DHCMed.SS.AreaDic).GetObjById(+CRRepProvince)
	Set obj.CRRepCity     = ##class(DHCMed.SS.AreaDic).GetObjById(+CRRepCity)
	Set obj.CRRepCounty   = ##class(DHCMed.SS.AreaDic).GetObjById(+CRRepCounty)
	Set obj.CRCardType    = ##class(DHCMed.SS.Dictionary).GetObjById(+CRCardType)
	Set obj.CRLiveSix     = ##class(DHCMed.SS.Dictionary).GetObjById(+CRLiveSix)
	Set obj.CRLevel       = ##class(DHCMed.SS.Dictionary).GetObjById(+CRLevel)
	Set obj.CROutCome     = ##class(DHCMed.SS.Dictionary).GetObjById(+CROutCome)
	Set obj.CRCureMethod  = ##class(DHCMed.SS.Dictionary).GetObjById(+CRCureMethod)
	Set obj.CRApoplexyType= ##class(DHCMed.SS.Dictionary).GetObjById(+CRApoplexyType)
	Set obj.CRSCD     	  = ##class(DHCMed.SS.Dictionary).GetObjById(+CRSCD)
	Set obj.CRInfer       = ##class(DHCMed.SS.Dictionary).GetObjById(+CRInfer)
	Set obj.CRDaig     	  = ##class(DHCMed.SS.Dictionary).GetObjById(+Diagnose)
	Set obj.CRBiochemicalMark = ##class(DHCMed.SS.Dictionary).GetObjById(+BiochemicalMark)
	Set obj.CRReissue     	  = ##class(DHCMed.SS.Dictionary).GetObjById(+Reissue)
	
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2021-12-06
/// Description:  根据基础字典类别,基础字典项目名称获取基础字典记录
/// Table：       DHCMed.SS.Dictionary
/// Input：       type：   类型
///               code： 代码
/// Return：      返回obj
/// w ##class(DHCMed.CD.CRReportXNXG).GetObjByTypeDesc("CRCardType","军官证")
ClassMethod GetObjByTypeDesc(argTypeCode As %String, argDesc As %String, argIsActive As %String = 1) As %String
{
	New (argTypeCode,argDesc,argIsActive)
	Set return=""
	Quit:(argTypeCode="")||(argDesc="") return
	
	Set TypeCode=$ZCVT(argTypeCode,"U")
	Set Desc=$ZCVT(argDesc,"U")
	Set DicID=0
	For {
		Set DicID=$o(^DHCMed.SS.DictionaryI("IndexTypeDesc"," "_TypeCode," "_Desc,DicID))
		Quit:DicID=""
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(DicID)
		Continue:'$IsObject(objDic)
		Set Description=objDic.Description
		Continue:Description'=argDesc
		Set IsActive=objDic.Active
		Continue:(argIsActive'="")&&(argIsActive'=IsActive)
		
		Set return=objDic.%Id()
	}
	
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CRKPBH</Value>
</Value>
<Value name="3">
<Value>CRBGKLX</Value>
</Value>
<Value name="4">
<Value>CRZDID</Value>
</Value>
<Value name="5">
<Value>CRZDBM</Value>
</Value>
<Value name="6">
<Value>CRZDMC</Value>
</Value>
<Value name="7">
<Value>CRZDFL</Value>
</Value>
<Value name="8">
<Value>CRZDYJ</Value>
</Value>
<Value name="9">
<Value>CRBS</Value>
</Value>
<Value name="10">
<Value>CRSYZZ</Value>
</Value>
<Value name="11">
<Value>CRFBRQ</Value>
</Value>
<Value name="12">
<Value>CRQZRQ</Value>
</Value>
<Value name="13">
<Value>CRSFSCFB</Value>
</Value>
<Value name="14">
<Value>CRQZDW</Value>
</Value>
<Value name="15">
<Value>CRZG</Value>
</Value>
<Value name="16">
<Value>CRSWRQ</Value>
</Value>
<Value name="17">
<Value>CRSWYY</Value>
</Value>
<Value name="18">
<Value>CRSYID</Value>
</Value>
<Value name="19">
<Value>CRSWZD</Value>
</Value>
<Value name="20">
<Value>CRSYBM</Value>
</Value>
<Value name="21">
<Value>CRSYMC</Value>
</Value>
<Value name="22">
<Value>CRBSZY</Value>
</Value>
<Value name="23">
<Value>CRSHTD</Value>
</Value>
<Value name="24">
<Value>CRSJJG</Value>
</Value>
<Value name="25">
<Value>CRRepProvince</Value>
</Value>
<Value name="26">
<Value>CRRepCity</Value>
</Value>
<Value name="27">
<Value>CRRepCounty</Value>
</Value>
<Value name="28">
<Value>CRCardType</Value>
</Value>
<Value name="29">
<Value>CRLiveSix</Value>
</Value>
<Value name="30">
<Value>CRLevel</Value>
</Value>
<Value name="31">
<Value>CROutCome</Value>
</Value>
<Value name="32">
<Value>CRCureMethod</Value>
</Value>
<Value name="33">
<Value>CRApoplexyType</Value>
</Value>
<Value name="34">
<Value>CRSCD</Value>
</Value>
<Value name="35">
<Value>CRInfer</Value>
</Value>
<Value name="36">
<Value>CRDaig</Value>
</Value>
<Value name="37">
<Value>CRBiochemicalMark</Value>
</Value>
<Value name="38">
<Value>CRReissue</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("XNXG")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("XNXG")</IdLocation>
<IndexLocation>^DHCMed.CD.CRReportI("XNXG")</IndexLocation>
<StreamLocation>^DHCMed.CD.CRReportXNXGS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
