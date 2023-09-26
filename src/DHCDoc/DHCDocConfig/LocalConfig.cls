/// CTOR: QP
/// DATE: 2018-11-01
/// DESC: 医生站-本地化参数配置类
Class DHCDoc.DHCDocConfig.LocalConfig Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2018-11-01
/// DESC: 查询本地化参数
/// IN  : 
/// OUT : 
/// TABL: //^CF.DOC("LocalConfig","产品线代码","配置代码")="名称^值^说明^院区ID"
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.LocalConfig","QryPara","")
Query QryPara(SearchContent As %String = "", HospId As %String = "") As %Query(ROWSPEC = "productCode,productDesc,cfgCode,cfgName,cfgValue,cfgNote,cfgHosp,cfgHospDesc,productLine")
{
}

ClassMethod QryParaExecute(ByRef qHandle As %Binary, SearchContent As %String = "", HospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
	}
	s productCode=""
	f  s productCode=$o(^CF.DOC(HospCodeNode,"LocalConfig",productCode)) q:productCode=""  d
	.q:productCode="ProductLineName"
	.s cfgCode=""
	.f  s cfgCode=$o(^CF.DOC(HospCodeNode,"LocalConfig",productCode,cfgCode)) q:cfgCode=""  d
	..s cfgData=$g(^CF.DOC(HospCodeNode,"LocalConfig",productCode,cfgCode))
	..s productDesc=..GetProductLine(.Product,productCode)
	..s productLine=productDesc	//_"（"_productCode_"）"
	..s cfgName=$p(cfgData,"^",1)
	..s cfgValue=$p(cfgData,"^",2)
	..s cfgNote=$p(cfgData,"^",3)
	..s cfgHosp=HospId //$p(cfgData,"^",4)
	..s cfgHospDesc=""
	..i cfgHosp'="" s cfgHospDesc=$p(^CT("HOSP",cfgHosp),"^",2)
	..s isExit=1
	..i SearchContent'="" d
	...s SearchContent=$zcvt(SearchContent,"U")
	...s curProcode=$zcvt(productCode,"U")
	...s curCfgCode=$zcvt(cfgCode,"U")
	...s cfgSearchName=$zcvt(cfgName,"U")
	...s cfgSearchNote=$zcvt(cfgNote,"U")
	...i curProcode[SearchContent s isExit=0
	...i curCfgCode[SearchContent s isExit=0
	...i cfgSearchName[SearchContent s isExit=0
	...i cfgSearchNote[SearchContent s isExit=0
	...i productDesc[SearchContent s isExit=0
	..q:(isExit=1)&&(SearchContent'="")
	..d DHCDocOut1
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
DHCDocOut1
	set Data=$lb(productCode,productDesc,cfgCode,cfgName,cfgValue,cfgNote,cfgHosp,cfgHospDesc,productLine)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod QryParaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryParaExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryParaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryParaExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2018-11-01
/// DESC: 查询院区
/// IN  : 
/// OUT : 
/// TABL: CT_Hospital
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.LocalConfig","QryHosptial","")
Query QryHosptial(SearchContent As %String = "") As %Query(ROWSPEC = "hospID,hospDesc")
{
}

ClassMethod QryHosptialExecute(ByRef qHandle As %Binary, SearchContent As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s hospID=0
	f  s hospID=$o(^CT("HOSP",hospID)) q:hospID=""  d
	.s hospDesc=$p(^CT("HOSP",hospID),"^",2)
	.d DHCDocOut2
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
DHCDocOut2
	set Data=$lb(hospID,hospDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod QryHosptialFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHosptialExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryHosptialClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHosptialExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 保存本地参数配置
/// IN  : "产品线名称^名称^值^说明^院区ID"
/// OUT : "DOC^ANTIME^抗菌药物^抗菌药物开关2^1^快递费即可^2^edit^ANTIME^ANT"
/// TABL: 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.LocalConfig).SaveLocalConfig("DOC","ANTIME","抗菌药物^抗菌药物开关2^1^快递费即可^2","edit","ANTIME",ANT")
ClassMethod SaveLocalConfig(procode, code, para, action, oldcode = "", oldProcode = "", HospId As %String = "")
{
	n (procode,code,para,action,oldcode,oldProcode,HospId,%session)
	s mRtn=0
	q:(procode="")||(code="") "-1"
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		q:($d(^CF.DOC(HospCodeNode,"LocalConfig",procode,code)))&&(action="add") "-2" ;配置已存在
		s ProductLineName=$p(para,"^",1)
		s ^CF.DOC(HospCodeNode,"LocalConfig",procode,code)=para
		i (oldcode'="")&&(oldProcode="") d ..DeleteLocalConfig(procode,oldcode,HospId)
	    i (oldProcode'="")&&(oldcode'="") d ..DeleteLocalConfig(oldProcode,oldcode,HospId)
	}else{
		q:($d(^CF.DOC("LocalConfig",procode,code)))&&(action="add") "-2" ;配置已存在
		s ProductLineName=$p(para,"^",1)
		s ^CF.DOC("LocalConfig",procode,code)=para
		i (oldcode'="")&&(oldProcode="") d ..DeleteLocalConfig(procode,oldcode)
	    i (oldProcode'="")&&(oldcode'="") d ..DeleteLocalConfig(oldProcode,oldcode)
	}
	
    
    q mRtn
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 删除本地参数配置
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.LocalConfig).DeleteLocalConfig("")
ClassMethod DeleteLocalConfig(procode, code, HospId As %String = "")
{
	n (procode,code,HospId)
	s mRtn=0
	q:(procode="")||(code="") "-1"
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		q:'$d(^CF.DOC(HospCodeNode,"LocalConfig",procode,code)) "-2"
		k ^CF.DOC(HospCodeNode,"LocalConfig",procode,code)
	}else{
		q:'$d(^CF.DOC("LocalConfig",procode,code)) "-2"
		k ^CF.DOC("LocalConfig",procode,code)
	}
    q mRtn
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 判断此配置是否存在
/// IN  : 
/// OUT : 1存在，0不存在
/// TABL: 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.LocalConfig).HasLocalConfig("ANT","ANTIME")
ClassMethod HasLocalConfig(procode, code, HospId As %String = "")
{
	n (procode,code,HospId,%session)
	s mRtn=0
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		q:$d(^CF.DOC(HospCodeNode,"LocalConfig",procode,code)) 1
	}else{
		q:$d(^CF.DOC("LocalConfig",procode,code)) 1
	}
    q mRtn
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 根据产品代码和配置代码获取配置数据
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.LocalConfig).GetLocalConfigData("ANT","ANTIME")
ClassMethod GetLocalConfigData(procode, code, HospId As %String = "")
{
	n (procode,code,HospId,%session)
	s mRtn=""
	q:(procode="")||(code="") mRtn
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		q:'$d(^CF.DOC(HospCodeNode,"LocalConfig",procode,code)) mRtn
	    q $g(^CF.DOC(HospCodeNode,"LocalConfig",procode,code))
	}else{
		q:'$d(^CF.DOC("LocalConfig",procode,code)) mRtn
	    q $g(^CF.DOC("LocalConfig",procode,code))
    }
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 根据产品代码和配置代码获取配置数值
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.LocalConfig).GetLocalConfigValue("ANT","ANTIME")
ClassMethod GetLocalConfigValue(procode, code, HospId As %String = "")
{
	n (procode,code,HospId,%session)
	s mRtn=""
	q:(procode="")||(code="") mRtn
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		q:'$d(^CF.DOC(HospCodeNode,"LocalConfig",procode,code)) mRtn
	    s mRtn=$p(^CF.DOC(HospCodeNode,"LocalConfig",procode,code),"^",2)
	}else{
		q:'$d(^CF.DOC("LocalConfig",procode,code)) mRtn
	    s mRtn=$p(^CF.DOC("LocalConfig",procode,code),"^",2)
	}
    q mRtn
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 得到产品线
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.DHCDocConfig.LocalConfig).GetProductLine(.Product,"ANT")
ClassMethod GetProductLine(Product, code)
{
	s Product("Reg")="患者管理"
	s Product("OPAdm")="预约挂号系统"
	s Product("Alloc")="门诊护士分诊系统"
	s Product("OPDoc")="门诊医生站"
	s Product("IPDoc")="住院医嘱系统"
	s Product("Pilot")="临床药理试验系统"
	s Product("Cure")="治疗科室系统"
	s Product("Ant")="抗菌药物管理"
	s Product("PW")="医生交班本"
	s Product("Chemo")="化疗管理系统"
	q:code="" ""
	q $g(Product(code))
}

/// CTOR: QP
/// DATE: 2018-11-01
/// DESC: 查询产品线
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.LocalConfig","QryProductLine")
Query QryProductLine() As %Query(ROWSPEC = "code,name")
{
}

ClassMethod QryProductLineExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	//产品线：
	d ..GetProductLine(.Product,"")
	s code="" f  s code=$o(Product(code)) q:code=""  d
	.s name=Product(code)
	.d DHCDocOut3
	
	k Product
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
DHCDocOut3
	set Data=$lb(code,name)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod QryProductLineFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryProductLineExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryProductLineClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryProductLineExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// 检查值是否在本地参数设置中存在
/// input：procode:产品线code、code:配置code、value:需校验值、dime:分割符
/// output:1:存在、0：不存在
/// w ##class(DHCDoc.DHCDocConfig.LocalConfig).CheckExitLocalConfigValue("OPDoc","OrderSingleDise",44)
ClassMethod CheckExitLocalConfigValue(procode, code, value, dime = "*", HospId As %String = "") As %String
{
	n (procode, code, value, dime, HospId, %session)
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	s ExitFlag=0
	s LocalConfigStr=##class(DHCDoc.DHCDocConfig.LocalConfig).GetLocalConfigValue(procode,code,HospId)
	q:(LocalConfigStr="")||(value="") ExitFlag
	s value=","_value_","
	f i=1:1:$l(LocalConfigStr,dime) {
		q:ExitFlag=1
		s LocalConfig=$p(LocalConfigStr,dime,i)
		s LocalConfig=","_LocalConfig_","
		s ExitFlag=LocalConfig[value
	}
	q ExitFlag
}

}
