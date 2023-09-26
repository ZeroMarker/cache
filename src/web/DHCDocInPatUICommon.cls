Class web.DHCDocInPatUICommon Extends (DHCDoc.Util.RegisteredObject, %Library.DynamicAbstractObject)
{

/// 根据就诊ID获取下医嘱人列表
/// w ##class(web.DHCDocInPatUICommon).GetAdmInfoJson(29)
ClassMethod GetAdmInfoJson(EpisodeID As %String) As %String
{
	Set langid=..%LanguageID()
	s retObj=[{"id":0,"text":(##class(websys.Translation).Get("ipdoc.patinfoview.csp","全部")),"selected":1}]
	s orderParref=$o(^OEORD(0,"Adm",+EpisodeID,0))
	Q:+orderParref=0 retObj.%ToJSON()
	s orderId=0 f  s orderId = $o(^OEORD(orderParref,"I",orderId)) q:orderId=""  d
	.q:$d(^OEORD(orderParref,"I",orderId,1))'=1
	.s DoctorDr=$p(^OEORD(orderParref,"I",orderId,1),"^",11)
	.q:+DoctorDr=0
	.q:$D(DocList(DoctorDr))
	.s DocList(DoctorDr)=""
	.s TDoctor = $p($g(^CTPCP(DoctorDr,1)),"^",2)
	.Set TDoctor= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",TDoctor,langid)
	.d retObj.%Push({"id":(DoctorDr),"text":(TDoctor)})
	Q retObj.%ToJSON()
}

/// 获取医嘱重分类json串
/// w ##class(web.DHCDocInPatUICommon).GetOrdReSubCatListJson(29)
ClassMethod GetOrdReSubCatListJson() As %String
{
	s retObj=[{"id":"ALL","text":(##class(websys.Translation).Get("ipdoc.patinfoview.csp","全部"))}]
	s ModuleId=0,FindRowID=""
	f  s ModuleId=$o(^DHCDocCT("Module",ModuleId)) q:(ModuleId="")||(FindRowID'="")  d
	.s ModuleDesc=$g(^DHCDocCT("Module",ModuleId))
	.i ModuleDesc="医嘱重分类" s FindRowID=ModuleId
	Q:FindRowID="" retObj.%ToJSON()
	s CTDefine=0
	f  s CTDefine=$o(^DHCDocCTi(0,"Define","ModuleDR",FindRowID,CTDefine)) q:CTDefine=""  d
	.s DefineDataID=0
	.f  s DefineDataID=$o(^DHCDocCT("DefineData",CTDefine,"D",DefineDataID)) q:DefineDataID=""  d
	..s DefineDataDesc=$p(^DHCDocCT("DefineData",CTDefine,"D",DefineDataID),"^",2)
	..s DefineDataFrom=$p(^DHCDocCT("DefineData",CTDefine,"D",DefineDataID),"^",3)
	..q:(DefineDataFrom'="")&&(DefineDataFrom>+$h)
	..s DefineDataTo=$p(^DHCDocCT("DefineData",CTDefine,"D",DefineDataID),"^",4)
	..q:(DefineDataTo'="")&&(DefineDataTo<=..%SysDate())
	..s id=CTDefine_"||"_DefineDataID
	..s DefineDataDesc=##class(websys.Translation).Get("ipdoc.patinfoview.csp",DefineDataDesc)
	..d retObj.%Push({"id":(id),"text":(DefineDataDesc)})
	Q retObj.%ToJSON()
}

/// 获取停止时间的json串
/// w ##Class(web.DHCDocInPatUICommon).GetIntervalTimeList("Y")
ClassMethod GetIntervalTimeList(BeginCurrTime As %String = "") As %String
{
	s JsonObj=[]
	//s Bool=##Class(%Library.Boolean).%New()
	s Inteval=..%ZTH("00:15:00")
	if (BeginCurrTime="Y"){
		s JsonData={}
		do JsonData.%Set("id",..%ZT(..%SysTime()))
		do JsonData.%Set("text",..%ZT(..%SysTime()))
		do JsonData.%Set("selected","1")
		do JsonObj.%Push(JsonData,"")
		s LoopTime=(..%SysTime()\Inteval+1)*Inteval
	}else{
		s LoopTime=Inteval
	}
	
	while (LoopTime<..%ZTH("23:59:59")) {
		s JsonData={}
		do JsonData.%Set("id",..%ZT(LoopTime))
		do JsonData.%Set("text",..%ZT(LoopTime))
		do JsonData.%Set("selected","0")
		//do JsonData.%Set("selected",Bool.XSDToLogical(0))
		do JsonObj.%Push(JsonData,"")
		if ((LoopTime+Inteval)>..%SysTime())&&(LoopTime<..%SysTime()){
			s JsonData={}
			do JsonData.%Set("id",..%ZT(..%SysTime()))
			do JsonData.%Set("text",..%ZT(..%SysTime()))
			do JsonData.%Set("selected","1")
			do JsonObj.%Push(JsonData,"")
		}
		s LoopTime=LoopTime+Inteval
	}
	Q JsonObj.%ToJSON()
}

/// 获取撤销、停止执行记录原因json
/// w ##Class(web.DHCDocInPatUICommon).GetOECStatusChReason()
ClassMethod GetOECStatusChReason(Type As %String = "S") As %String
{
	s JsonObj=[]
	s ASCRRowId=0 
	Set langid=..%LanguageID() 
	for{
		  s ASCRRowId=$o(^OEC("ASCR",ASCRRowId)) 
		  q:ASCRRowId="" 
		  s UserType=$p(^OEC("ASCR",ASCRRowId),"^",3)
		  s PDAExcute=$p(^OEC("ASCR",ASCRRowId),"^",4)
		  s datafrom=$p(^OEC("ASCR",ASCRRowId),"^",5)
		  s datato=$p(^OEC("ASCR",ASCRRowId),"^",6)
		  continue:(datafrom'="")&&(datafrom>+$H)
		  continue:(datato'="")&&(datato<+$H)
		  continue:(Type="S")&&(UserType'="Y")
		  continue:(Type="E")&&(PDAExcute'="Y")
		  s ASCRDesc=$p(^OEC("ASCR",ASCRRowId),"^",2)
		  s ASCRDesc=##class(User.OECAdminStatusChReason).GetTranByDesc("ASCRDesc",ASCRDesc,langid)
		  s JsonData={}
		 do JsonData.%Set("id",ASCRRowId)
		 do JsonData.%Set("text",ASCRDesc)
		 do JsonObj.%Push(JsonData,"")
	}
	Q JsonObj.%ToJSON()
}

/// 排序方式
ClassMethod GetViewOrderSortJson(UserRowID As %String, GroupRowID As %String, isNurseLogin As %String) As %String
{
	s DefaultValue=##class(web.DHCDocConfig).GetUserPageSetting("InPatOrderView","obj",UserRowID,GroupRowID).ViewOrderSort
	i DefaultValue="" s DefaultValue="AT"
	s retObj=[]
	d retObj.%Push({"id":"AT","text":(##class(websys.Translation).Get("ipdoc.patinfoview.csp","时间正序")),"selected":(DefaultValue="AT")})
	d retObj.%Push({"id":"DT","text":(##class(websys.Translation).Get("ipdoc.patinfoview.csp","时间倒序")),"selected":(DefaultValue="DT")})
	Q retObj.%ToJSON()
}

/// 医嘱类型
/// w ##Class(web.DHCDocInPatUICommon).GetViewOrderTypeJson(4634,29)
ClassMethod GetViewOrderTypeJson(UserRowID As %String, GroupRowID As %String, isNurseLogin As %String) As %String
{
	s DefaultValue=##class(web.DHCDocConfig).GetUserPageSetting("OrderEntry","obj",UserRowID,GroupRowID).DefPriorType
	s DefaultValue=$CASE(DefaultValue,"LongOrderPrior":"S","ShortOrderPrior":"OM","OutOrderPrior":"OM",:"ALL")
	s retObj=[]
	d retObj.%Push({"id":"ALL","text":(##class(websys.Translation).Get("ipdoc.patinfoview.csp","全部")),"selected":(DefaultValue="ALL")})
	d retObj.%Push({"id":"S","text":(##class(websys.Translation).Get("ipdoc.patinfoview.csp","长嘱")),"selected":(DefaultValue="S")})
	d retObj.%Push({"id":"OM","text":(##class(websys.Translation).Get("ipdoc.patinfoview.csp","临嘱")),"selected":(DefaultValue="OM")})
	Q retObj.%ToJSON()
}

/// 开出科室
/// w ##Class(web.DHCDocInPatUICommon).GetViewLocDescJson(18885,"23",1,"92")
ClassMethod GetViewLocDescJson(UserRowID As %String, GroupRowID As %String, isNurseLogin As %String, EpisodeID As %String = "") As %String
{
	//s ^tan("GetViewLocDescJson")=$LB(UserRowID , GroupRowID , isNurseLogin , EpisodeID)
	Set langid=..%LanguageID()
	s DefaultValue=##class(web.DHCDocConfig).GetUserPageSetting("InPatOrderView","obj",UserRowID,GroupRowID).ViewLocDesc
	i DefaultValue="" s DefaultValue="1"
	s retObj=[]
	d retObj.%Push({"id":"1","text":(##class(websys.Translation).Get("ipdoc.patinfoview.csp","本科室与病区")),"selected":(DefaultValue="1")})
	d retObj.%Push({"id":"2","text":(##class(websys.Translation).Get("ipdoc.patinfoview.csp","其它科室")),"selected":(DefaultValue="2")})
	d retObj.%Push({"id":"3","text":(##class(websys.Translation).Get("ipdoc.patinfoview.csp","全部")),"selected":(DefaultValue="3")})
	if (isNurseLogin=1)&&(EpisodeID'=""){
		k TransacArr
		s PatAdmTransaction=##class(Nur.DoctorOrderSheet).getPatLocs(EpisodeID,UserRowID)
		if (PatAdmTransaction'=""){
			d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(PatAdmTransaction,.TransacArr)
		}
		
		s CurrAdmLocRowID=$p(^PAADM(EpisodeID),"^",4)
		s i="",num=0,FindCurrLocFlag="N"
		if ($O(TransacArr(""),-1)=1){k TransacArr}
		for {
			s i=$O(TransacArr(i))
			q:(i="")
			continue:('$d(TransacArr(i)))
			s TransToLocId=TransacArr(i,"LocId")
			//continue:(TransToLocId'=LogOnLoc)&&(LogOnLoc'="")
			s TransToWardDesc=$g(TransacArr(i,"WardDesc"))
			/*
			if ($O(TransacArr(i))'=""){
				if (TransToLocId=CurrAdmLocRowID){
					s FindCurrLocFlag="Y"
				}
			}
			if ($O(TransacArr(i))=""){
				///如果患者仅在当前科室呆过一次且是最后一次，或者患者根本没有转过科室
				///则不需要显示转科记录中的当前科室，直接使用【本科是与病区】条件进行查询即可
				if ((TransToLocId=CurrAdmLocRowID)&&(FindCurrLocFlag="Y")){
					continue
				}
			}*/
			//continue:(TransToWardDesc'=LogOnWardDesc)&&(LogOnWardDesc'="")
			//s TransToWardDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",TransToWardDesc,langid)
			s num=num+1
			s StartDateSys=..%ZDH(TransacArr(i,"StartDate"))
			s StartDate=..%ZD(StartDateSys)
			s StartTimeSys=..%ZTH(TransacArr(i,"StartTime"))
			s StartTime=..%ZT(StartTimeSys)
			if (StartDate'=""){
				s StartDateStr=StartDate_" "_StartTime
			}
			s EndDateSys=..%ZDH(TransacArr(i,"EndDate"))
			s EndDate=..%ZD(EndDateSys)
			s EndTimeSys=..%ZTH(TransacArr(i,"EndTime"))
			s EndTime=..%ZT(EndTimeSys)
			s EndDateStr=""
			if (EndDate'=""){
				s EndDateStr=EndDate_" "_EndTime
			}
			s Desc=StartDate_" "_..%ZT(StartTimeSys,2)_"转入"_TransToWardDesc
			if (num=1) s Desc=StartDate_" "_..%ZT(StartTimeSys,2)_"入院"_TransToWardDesc
			s Value="S^"_TransToLocId
			s JsonData={}
			do JsonData.%Set("id",Value)
			do JsonData.%Set("text",Desc)
			do JsonData.%Set("TimeRange",StartDateStr_"^"_EndDateStr)
			do JsonData.%Set("selected",0)
			do retObj.%Push(JsonData,"")
		}
	}

	
	Q retObj.%ToJSON()
}

/// 查询范围
ClassMethod GetViewScopeDescJson(UserRowID As %String, GroupRowID As %String, isNurseLogin As %String, AdmType As %String = "I") As %String
{
	s DefaultValue=##class(web.DHCDocConfig).GetUserPageSetting("InPatOrderView","obj",UserRowID,GroupRowID).ViewScopeDesc
	i DefaultValue="" {
		s:isNurseLogin=0 DefaultValue="3"
		s:isNurseLogin=1 DefaultValue="8"
	}
	s retObj=[]
	d retObj.%Push({"id":"1","text":(##class(websys.Translation).Get("ipdoc.patinfoview.csp","全部")),"selected":(DefaultValue="1")})
	if (AdmType="I"){
		d retObj.%Push({"id":"2","text":(##class(websys.Translation).Get("ipdoc.patinfoview.csp","作废")),"selected":(DefaultValue="2")})
	}
	d retObj.%Push({"id":"3","text":(##class(websys.Translation).Get("ipdoc.patinfoview.csp","当前")),"selected":(DefaultValue="3")})
	if (isNurseLogin=0)&&(AdmType="I"){
		;d retObj.%Push({"id":"4","text":(##class(websys.Translation).Get("ipdoc.patinfoview.csp","待审核")),"selected":(DefaultValue="4")})
		d retObj.%Push({"id":"10","text":(##class(websys.Translation).Get("ipdoc.patinfoview.csp","退回未处理")),"selected":(DefaultValue="10")})
	}
	d retObj.%Push({"id":"5","text":(##class(websys.Translation).Get("ipdoc.patinfoview.csp","已停止")),"selected":(DefaultValue="5")})
	if (isNurseLogin=1)&&(AdmType="I"){
		d retObj.%Push({"id":"8","text":(##class(websys.Translation).Get("ipdoc.patinfoview.csp","待处理")),"selected":(DefaultValue="8")})
		d retObj.%Push({"id":"9","text":(##class(websys.Translation).Get("ipdoc.patinfoview.csp","已处理")),"selected":(DefaultValue="9")})
	}
	if (isNurseLogin=0)&&(AdmType="I"){
		d retObj.%Push({"id":"6","text":(##class(websys.Translation).Get("ipdoc.patinfoview.csp","今日有效")),"selected":(DefaultValue="6")})
		d retObj.%Push({"id":"7","text":(##class(websys.Translation).Get("ipdoc.patinfoview.csp","三日有效")),"selected":(DefaultValue="7")})
		d retObj.%Push({"id":"11","text":(##class(websys.Translation).Get("ipdoc.patinfoview.csp","全排斥长期")),"selected":(DefaultValue="11")})
	}
	Q retObj.%ToJSON()
}

/// 医嘱单类型
ClassMethod GetViewNurderBillJson(UserRowID As %String, GroupRowID As %String, isNurseLogin As %String) As %String
{
	s DefaultValue=##class(web.DHCDocConfig).GetUserPageSetting("InPatOrderView","obj",UserRowID,GroupRowID).ViewNurderBill
	i DefaultValue="" s DefaultValue="ALL"
	s retObj=[]
	d retObj.%Push({"id":"ALL","text":(##class(websys.Translation).Get("ipdoc.patinfoview.csp","全部")),"selected":(DefaultValue="ALL")})
	d retObj.%Push({"id":"N","text":(##class(websys.Translation).Get("ipdoc.patinfoview.csp","医嘱单")),"selected":(DefaultValue="N")})
	if (isNurseLogin="1"){
		d retObj.%Push({"id":"Nurse","text":(##class(websys.Translation).Get("ipdoc.patinfoview.csp","护嘱单")),"selected":(DefaultValue="Nurse")})
	}
	Q retObj.%ToJSON()
}

/// 信息总览布局
ClassMethod GetViewIPDocPatInfoLayOutJson(UserRowID As %String, GroupRowID As %String, isNurseLogin As %String) As %String
{
	s DefaultValue=##class(web.DHCDocConfig).GetUserPageSetting("InPatView","obj",UserRowID,GroupRowID).ViewIPDocPatInfoLayOut
	i DefaultValue="" s DefaultValue="1"
	s retObj=[]
	d retObj.%Push({"id":"1","text":(##class(websys.Translation).Get("ipdoc.patinfoview.csp","宽屏布局")),"selected":(DefaultValue="1")})
	d retObj.%Push({"id":"2","text":(##class(websys.Translation).Get("ipdoc.patinfoview.csp","方屏布局")),"selected":(DefaultValue="2")})
	Q retObj.%ToJSON()
}

/// 用法
ClassMethod GetAdmInstrJson(Adm As %String) As %String
{
	s orderParref=+$o(^OEORD(0,"Adm",+Adm,0))
	Set langid=..%LanguageID()
	s retObj=[]
	d retObj.%Push({"id":"","text":(##class(websys.Translation).Get("ipdoc.patinfoview.csp","全部"))})
	s orderId = 0 
	for{
		s orderId = $o(^OEORD(orderParref,"I",orderId))
		q:orderId="" 
		s InstrRowid=$P($G(^OEORD(orderParref,"I",orderId,2)),"^",7)
		continue:+InstrRowid=0
		continue:$D(InstrList(InstrRowid))
		s InstrList(InstrRowid)=""
		s instrDesc=$p($g(^PHCIN(InstrRowid)),"^",2)
		s instrDesc=##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",instrDesc,langid)
		d retObj.%Push({"id":(InstrRowid),"text":(instrDesc)})
	}
	Q retObj.%ToJSON()
}

/// 频次
ClassMethod GetAdmFreqJson(Adm As %String) As %String
{
	s orderParref=+$o(^OEORD(0,"Adm",+Adm,0))
	Set langid=..%LanguageID()
	s retObj=[]
	d retObj.%Push({"id":"","text":(##class(websys.Translation).Get("ipdoc.patinfoview.csp","全部"))})
	s orderId = 0 
	for{
		s orderId = $o(^OEORD(orderParref,"I",orderId))
		q:orderId="" 
		s FreqRowid=$P($G(^OEORD(orderParref,"I",orderId,2)),"^",4)
		continue:+FreqRowid=0
		continue:$D(FreqList(FreqRowid))
		s FreqList(FreqRowid)=""
		s FreqDesc=$p(^PHCFR(FreqRowid),"^",3)
		s FreqDesc=##class(User.PHCFreq).GetTranByDesc("PHCFRDesc1",FreqDesc,langid)
		d retObj.%Push({"id":(FreqRowid),"text":(FreqDesc)})
	}
	Q retObj.%ToJSON()
}

}
