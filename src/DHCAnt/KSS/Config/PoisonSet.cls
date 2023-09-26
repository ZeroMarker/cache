/// CTOR: QP
/// DATE: 2020-04-15
/// DESC: 管制分类设置
Class DHCAnt.KSS.Config.PoisonSet Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-04-15
/// DESC: 保存
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCAnt.KSS.Config.PoisonSet).Save("^2^1^Y")
ClassMethod Save(inPara As %String)
{
	s id=$p(inPara,"^",1)
	s hosp=$p(inPara,"^",2)
	s phpo=$p(inPara,"^",3)
	s active=$p(inPara,"^",4)
	q:hosp="" "-2" 	//院区为空
	
	i id="" {
		q:$d(^CF.ANT("PoisonSet",0,"HospPhpo",hosp,phpo)) "-1"	//配置已存在
		s a=##class(DHCAnt.Base.Config.PoisonSet).%New()
		
	} else {
		s a=##class(DHCAnt.Base.Config.PoisonSet).%OpenId(id)
		s oldPhpo=a.PSPhpoDRGetObjectId()
		s oldHosp=a.PSHospGetObjectId()
		q:$d(^CF.ANT.ItmMastI("HospArcim",hosp,phpo))&&(oldPhpo'=phpo)&&(oldHosp'=hosp) "-1"	//配置已存在
	}
	d a.PSHospSetObjectId(hosp)
	d a.PSPhpoDRSetObjectId(phpo)
	s a.PSActive=active
	s sc=a.%Save()
	If $$$ISERR(sc) {	//QP
		//d $system.OBJ.DisplayError(sc) 
		Quit "-100"
	}
	
	Q 0
}

/// Creator：     QP
/// CreatDate：   2020-04-15
/// Description:  
/// Table：    
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCAnt.KSS.Config.PoisonSet","QryPoison","")
Query QryPoison(InHosp = "", InPhpo = "") As %Query(ROWSPEC = "id,cHosp,hospName,cPhpo,phpoDesc,active")
{
}

ClassMethod QryPoisonExecute(ByRef qHandle As %Binary, InHosp = "", InPhpo = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s cHosp=""
	f  s cHosp=$o(^CF.ANT("PoisonSet",0,"HospPhpo",cHosp)) q:cHosp=""  d
	.q:(InHosp'="")&&(InHosp'=cHosp)
	.s cPhpo=""
	.f  s cPhpo=$o(^CF.ANT("PoisonSet",0,"HospPhpo",cHosp,cPhpo)) q:cPhpo=""  d
	..q:(InPhpo'="")&&(InPhpo'=cPhpo)
	..s id=$o(^CF.ANT("PoisonSet",0,"HospPhpo",cHosp,cPhpo,""))
	..q:id=""
	..s hospName=$p(^CT("HOSP",cHosp),"^",2)
	..s phpoDesc=$p(^PHCPO(cPhpo),"^",2)
	..s active=$p(^CF.ANT("PoisonSet",id),"^",3)
	..d output1
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output1
	Set Data=$lb(id,cHosp,hospName,cPhpo,phpoDesc,active)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryPoisonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPoisonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPoisonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPoisonExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// Creator：     QP
/// CreatDate：   2020-04-15
/// Description:  
/// Table：    
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCAnt.KSS.Config.PoisonSet","QryPhpo")
Query QryPhpo() As %Query(ROWSPEC = "id,desc")
{
}

ClassMethod QryPhpoExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	
 	s id=0
 	f  s id=$o(^PHCPO(id)) q:id=""  d
 	.s desc=$p(^PHCPO(id),"^",2)
	.d output1
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output1
	Set Data=$lb(id,desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryPhpoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPhpoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPhpoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPhpoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// CTOR: QP
/// DATE: 2020-04-16
/// DESC: 删除
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCAnt.KSS.Config.ArcimSet).Delete()
ClassMethod Delete(pid As %String)
{
	&SQL(DELETE FROM DHCAnt_Base_Config.PoisonSet WHERE PS_ID=:pid)	
	
	q SQLCODE
}

/// CTOR: QP
/// DATE: 2020-04-16
/// DESC: 是否控制
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCAnt.KSS.Config.PoisonSet).InControl(2,1)
ClassMethod InControl(InHosp, InPhpo)
{
	Q:(InHosp="")||(InPhpo="") 0
	Q:'$d(^CF.ANT("PoisonSet",0,"HospPhpo",InHosp,InPhpo)) 0
	
	Q 1
}

/// CTOR: QP
/// DATE: 2020-04-16
/// DESC: 
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCAnt.KSS.Config.PoisonSet).ValidatePhpo(2,1,"I")
ClassMethod ValidatePhpo(InHosp, InPhpo, InAdmType)
{
	s inControl=..InControl(InHosp,InPhpo)
	Q:inControl=0 1
	s switchFlag=##class(DHCAnt.KSS.Common.Method).GetKJSwitchFlag(InAdmType,InHosp)
	Q switchFlag
}

/// CTOR: QP
/// DATE: 2021-12-03
/// DESC: 根据医嘱项设置管制分类代码
/// IN  : 
/// OUT : 0：返回true，-1：退出，1：继续往下
/// TABL: 
/// EXEC: w ##class(DHCAnt.KSS.Config.PoisonSet).ValidatePhpoNew("2","5","I","5563||1")
ClassMethod ValidatePhpoNew(InHosp, InPoisonRowId, InAdmType, ArcimRowid)
{
	s ^QP("ValidatePhpoNew")=$LB(InHosp, InPoisonRowId, InAdmType, ArcimRowid)
	s dynObj={
		"msg": "",
		"code": "0",	
		"PoisonRowId":"",
		"OrderPoisonCode":""
	}
	s PoisonRowId="",OrderPoisonCode=""
	;根据医嘱项设置管制分类代码
	s code=##class(PHA.FACE.OUT.Com).GetDrugAntiLevel(ArcimRowid)
	i code'="" {
		s OrderPoisonCode=$case(code,"O":"ATD1","S":"ATD2",:"")
		i '$d(^PHCPO(0,"Code",OrderPoisonCode)) {
			do dynObj.%Set("msg","请配置抗肿瘤药物的管制分类代码！")
			do dynObj.%Set("code","-1")
			Q dynObj.%ToJSON()
		} else {
			s PoisonRowId=$o(^PHCPO(0,"Code",OrderPoisonCode,""))
			s InPoisonRowId=PoisonRowId
			do dynObj.%Set("PoisonRowId",PoisonRowId)
			do dynObj.%Set("OrderPoisonCode",OrderPoisonCode)
		}
	} 
	;判断是否是管制分类
	if (InPoisonRowId="") {
		Q dynObj.%ToJSON()	
	}
	;ATD
	s switchFlag=1
	if (OrderPoisonCode["ATD") {
		s switchFlag=##class(DHCAnt.KSS.Common.Method).GetATDSwitchFlag(InAdmType,InHosp)
	} else {
		s switchFlag=##class(DHCAnt.KSS.Config.PoisonSet).ValidatePhpo(InHosp, InPoisonRowId, InAdmType)
	}
	i switchFlag=1 {
		;未启用
		Q dynObj.%ToJSON()	
	} else {
		;启用
		do dynObj.%Set("code","1")
	}
	
	Q dynObj.%ToJSON()
}

}
