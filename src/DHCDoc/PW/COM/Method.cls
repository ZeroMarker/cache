/// CTOR: QP
/// DATE: 2021-07-13
/// DESC: 公共方法
Class DHCDoc.PW.COM.Method Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2021-07-13
/// DESC: 
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.COM.Method).GetAbsTime("","1^1")
ClassMethod GetAbsTime(DateTime As %String) As %String
{
	Q:DateTime="" 0
	s Date=$p(DateTime,",",1)
	s Time=$p(DateTime,",",2)
	Q (Date*24*3600)+Time
}

/// CTOR: QP
/// DATE: 2021-07-13
/// DESC: 判断病危
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.COM.Method).IsCriticallyIll(7)
ClassMethod IsCriticallyIll(EpisodeID) As %String
{
	//n (EpisodeID)
	Quit:EpisodeID="" ""
	Set val = ##class(websys.Conversions).IsValidMethodName("web.DHCSETIMAGE","IfOrddailyExistByConfig")
	Set img = 0
	if val{
		Set img = ##class(web.DHCSETIMAGE).IfOrddailyExistByConfig(EpisodeID,"CRITICALLY")
	}
	Quit img
}

/// CTOR: QP
/// DATE: 2021-07-13
/// DESC: 判断病重
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.COM.Method).IsSeriouslyIll("243")
ClassMethod IsSeriouslyIll(EpisodeID) As %String
{
	Quit:EpisodeID="" ""
	set val = ##class(websys.Conversions).IsValidMethodName("web.DHCSETIMAGE","IfOrddailyExistByConfig")
	Set img = 0
	if val{
		Set img = ##class(web.DHCSETIMAGE).IfOrddailyExistByConfig(EpisodeID,"SERIOUSLY")
	}
	Quit img
}

/// CTOR: QP
/// DATE: 2019-05-22
/// DESC: 
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.COM.Method).IfExistOrder("243")
ClassMethod IfExistOrder(OrdDate As %String, EpisodeID As %String, ARCIMCodes As %String, STime As %String = "", ETime As %String = "", StartDate = "", EndDate = "") As %String
{
	s ret=0
	Q:EpisodeID="" ret
	s StartDateTime=##class(DHCDoc.PW.COM.Method).GetAbsTime(StartDate_","_STime)
	s EndDateTime=##class(DHCDoc.PW.COM.Method).GetAbsTime(EndDate_","_ETime)
	s OrdRowID=$o(^OEORD(0,"Adm",EpisodeID,0))
	Q:OrdRowID="" ret
	s Num=$l(ARCIMCodes,"^")
	f ARCIMSeq=1:1:Num {
		Q:ret=1
		s ARCIMCode=$p(ARCIMCodes,"^",ARCIMSeq)
		Q:ARCIMCode=""
		s ARCIMMain=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ARCIMCode),0))
		Q:ARCIMMain=""
		s ARCIMRowID=ARCIMMain_"||"_"1"
		s OrdStDate=0 f {
			s OrdStDate=$o(^OEORDi(0,"ARCIM",OrdRowID,ARCIMRowID,OrdStDate))
			Q:OrdStDate=""
			s OrdSub="" f {
				s OrdSub=$o(^OEORDi(0,"ARCIM",OrdRowID,ARCIMRowID,OrdStDate,OrdSub))
				Q:OrdSub=""
				continue:'$d(^OEORD(OrdRowID,"I",OrdSub,1))
				s OrdPriorityDR=$p($g(^OEORD(OrdRowID,"I",OrdSub,1)),"^",8)
				s ISLongOrderPrior=##class(appcom.OEOrdItem).ISLongOrderPrior(OrdPriorityDR)
				;时间
				s OrdStTime=$p($g(^OEORD(OrdRowID,"I",OrdSub,1)),"^",10)
				s OrdEndTime=$p($g(^OEORD(OrdRowID,"I",OrdSub,2)),"^",15)
				s OrdEndDate=$p($g(^OEORD(OrdRowID,"I",OrdSub,3)),"^",34)
				
				
				;日期 长期不能大于今天 临时等于今天
				if ISLongOrderPrior=1 {
					continue:OrdStDate>EndDate
				} else {
					continue:(OrdStDate<StartDate)||(OrdStDate>EndDate)
				}
				;continue:(ISLongOrderPrior=1)&&(OrdStDate>OrdDate)
				;continue:(ISLongOrderPrior'=1)&&(OrdStDate'=OrdDate)
				;continue:(OrdEndDate<OrdDate)&&(OrdEndDate'="")
				if OrdEndDate'="" {
					continue:OrdEndDate<StartDate
				}
				if (OrdStTime'="") {
					s SDT=##class(DHCDoc.PW.COM.Method).GetAbsTime(OrdStDate_","_OrdStTime)	
					continue:SDT>EndDateTime
				}
				if (OrdEndTime'="") {
					s EDT=##class(DHCDoc.PW.COM.Method).GetAbsTime(OrdEndDate_","_OrdEndTime)	
					continue:EDT<StartDateTime
				}
				;continue:(OrdStDate=StartDate)&&(OrdStTime>ETime)
				;continue:(OrdEndDate=EndDate)&&(OrdEndTime<STime)
				;状态 长期只算核实停止 临时只算核实
				s OrdStatDr=$p($g(^OEORD(OrdRowID,"I",OrdSub,1)),"^",13)
				continue:(ISLongOrderPrior=1)&&(OrdStatDr'="1")&&(OrdStatDr'="4")
				continue:(ISLongOrderPrior'=1)&&(OrdStatDr'="1")
				s ret=1
			}
		}
	}
	Q ret
}

/// CTOR: QP
/// DATE: 2019-05-22
/// DESC: 判断就诊id是否存在某种状态
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.COM.Method).CheckExistStatus("243")
ClassMethod CheckExistStatus(LocID As %String, CheckStatus As %String, CheckAdmID As %String) As %String
{
	q:(LocID="")||(CheckStatus="")||(CheckAdmID="") ""
	s ExistStatusFlag="N"
	f StatusSeq=1:1:$l(CheckStatus,"^") {
		s OneStatus=$p(CheckStatus,"^",StatusSeq)
		continue:OneStatus=""
		i $d(^BS.OPDoc.PW(LocID,OneStatus,CheckAdmID)) s ExistStatusFlag="N"
	}
	Q ExistStatusFlag
}

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 计算原有
/// IN  : 科室ID
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.COM.Method).SetPreSumGlobal()
ClassMethod SetPreSumGlobal(StartDate As %String, EndDate As %String, LocId As %String, BCCode As %String) As %String
{
	s GZStr=##class(DHCDoc.PW.CFG.BCRule).GetRuleValue(LocId,"PreSum")
	s GZLen=$l(GZStr,"^")
	f PatAdmDate=StartDate:1:EndDate d
	.f i=1:1:GZLen d
	..s curRecord=$P(GZStr,"^",i)
	..s node=$P(curRecord,"!",1),nodeFlag=$P(curRecord,"!",2)
	..s nodeDate=PatAdmDate
	..s admId="" 
	..f  s admId=$o(^||BS.PW.NMain("RealCount",LocId,nodeDate,BCCode,node,admId)) q:admId=""  d
	...s sortNum="" f  s sortNum=$o(^||BS.PW.NMain("RealCount",LocId,nodeDate,BCCode,node,admId,sortNum)) q:sortNum=""  d
	....i nodeFlag=1 s ^||BS.PW.NMain("RealCount",LocId,nodeDate,BCCode,"PreSum",admId)=""
	....e  k ^||BS.PW.NMain("RealCount",LocId,nodeDate,BCCode,"PreSum",admId)
	
	s sortNum=1,nodeDate=""
	f  s nodeDate=$o(^||BS.PW.NMain("RealCount",LocId,nodeDate)) q:nodeDate=""  d
	.s admId=""
	.f  s admId=$o(^||BS.PW.NMain("RealCount",LocId,nodeDate,BCCode,"PreSum",admId)) q:admId=""  d
	..s ^||BS.PW.NMain("RealCount",LocId,nodeDate,BCCode,"PreSum",admId,sortNum)=""
	..s sortNum=sortNum+1
	
	Q 0
}

/// CTOR: QP
/// DATE: 2021-07-13
/// DESC: 根据科室ID得到班次主表ID
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.COM.Method).GetMIDByLoc("113")
ClassMethod GetMIDByLoc(LocID) As %String
{
	s MID=""  
	Q:LocID="" MID
	i $d(^User.DHCDocPassWorkBCLocI("BLLoc",LocID)) {
		s MID=$O(^User.DHCDocPassWorkBCLocI("BLLoc",LocID,""))
		i MID'="" {
			s Active=$lg(^User.DHCDocPassWorkBCMainD(MID),5)
			i Active'=1 s MID=""
		}
	} 
	i MID="" {
		s InHosp=$p(^CTLOC(LocID),"^",22)
		s MID=$O(^User.DHCDocPassWorkBCMainI("BMHospType",InHosp,"C",""))
		Q:MID="" MID
		s Active=$lg(^User.DHCDocPassWorkBCMainD(MID),5)
		i Active'=1 s MID=""
	}
		
	Q MID
}

/// CTOR: QP
/// DATE: 2021-07-13
/// DESC: 根据科室ID得到班次主表ID
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.COM.Method).GetNID("113","2021-07-14","D")
ClassMethod GetNID(LocID, BCDate, BCCode) As %String
{
	Q:LocID=""||BCDate=""||BCCode="" ""
	//s BCCode=$$ALPHAUP^SSUTIL4(BCCode)   
	s BCDate=##class(websys.Conversions).DateHtmlToLogical(BCDate) 
	s NID=$O(^User.DHCDocPassWorkNMainI("MLocMBCDateCode",LocID,BCDate,BCCode,""))
	
	Q NID
}

/// CTOR: QP
/// DATE: 2021-07-13
/// DESC: 得到总共有几个班次
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.COM.Method).GetBCTotalNum("113","2021-07-13")
ClassMethod GetBCTotalNum(LocId, BCDate) As %String
{
	s mRtn=0
	s MID=##class(DHCDoc.PW.COM.Method).GetMIDByLoc(LocId)
	Q:MID="" mRtn
	s BCDate=##class(websys.Conversions).DateHtmlToLogical(BCDate)
	s sub=""
	f  s sub=$o(^User.DHCDocPassWorkBCMainD(MID,"ChildTime",sub)) q:sub=""  d
	.s active=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildTime",sub),8)
	.q:active'=1
	.s mRtn=mRtn+1
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2018-10-23
/// DESC: 返回默认班次日期
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.COM.Method).GetDefaultDate(113)
ClassMethod GetDefaultDate(LocId)
{
	/*
		1.规定，第一班次一定要从当天开始。
	
	*/
	;i $d(^CF.OPDoc.PW("Default","Date")) s mRtn=$g(^CF.OPDoc.PW("Default","Date"))
	;e  s mRtn=+$H
	s CDate=+$H,CTime=$p($H,",",2)
	//特殊情况
	//现在是16号的凌晨1点，需要判断是否是前一天日期
	s CBCInfo=..GetCurrentBC(LocId)
	s nextDay=$lg(CBCInfo,5)
	s sTime=$lg(CBCInfo,3)
	s eTime=$lg(CBCInfo,4)
	s DefaultDay=CDate
	i nextDay=1	{	
		s DefaultDay=CDate-1	
	} 
	i nextDay=2 {	;横跨今明22:00-1:00
		i (sTime<=CTime)&&(CTime<=86400) {
			//说明现在还是在当天
		}
		i (0<=CTime)&&(CTime<=eTime) {
			s DefaultDay=CDate-1
		}
	}
	s datestr=$zd(DefaultDay,3)
	s Year=$p(datestr,"-",1),Month=+$p(datestr,"-",2)-1,Day=$p(datestr,"-",3)
	s DateHTML=##class(websys.Conversions).DateLogicalToHtml(DefaultDay)
	s mRtn=DateHTML_"^"_Year_"^"_Month_"^"_Day
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2021-07-15
/// DESC: 得到所选日期默认的班次代码
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.COM.Method).GetDefaultBCode(113,"2021-07-16")
ClassMethod GetDefaultBCode(LocId, BCDate) As %String
{
	s mRtn=..GetCurrentBCCodeByNID(LocId,BCDate)
	i mRtn="" s mRtn=..GetCurrentBCCode(LocId)
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2021-07-13
/// DESC: 根据业务表得到当前时间所属班次的代码
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.COM.Method).GetCurrentBCCodeByNID(113,"2021-07-16")
ClassMethod GetCurrentBCCodeByNID(LocId, BCDate) As %String
{
	s CBCInfo=..GetCurrentBCByNID(LocId,BCDate)
	s mRtn=$lg(CBCInfo,1)
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2021-07-15
/// DESC: 根据业务表得到当前时间所属班次信息
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.COM.Method).GetCurrentBCByNID(113,"2021-07-16")
ClassMethod GetCurrentBCByNID(LocId, BCDate) As %String
{
	s mRtn=""
	Q:LocId=""||BCDate="" mRtn
	s BCDate=##class(websys.Conversions).DateHtmlToLogical(BCDate)
	s findFlag=0,cTime=$p($h,",",2)
	s seqno=""
	f  s seqno=$o(^User.DHCDocPassWorkNMainI("MLocMBCDateSeqno",LocId,BCDate,seqno)) q:(seqno="")||(findFlag=1)  d
	.s NID=""
	.f  s NID=$o(^User.DHCDocPassWorkNMainI("MLocMBCDateSeqno",LocId,BCDate,seqno,NID)) q:(NID="")||(findFlag=1)  d
	..s code=$lg(^User.DHCDocPassWorkNMainD(NID),9)
	..s name=$lg(^User.DHCDocPassWorkNMainD(NID),10)
	..s sTime=$lg(^User.DHCDocPassWorkNMainD(NID),11)
	..s eTime=$lg(^User.DHCDocPassWorkNMainD(NID),12)
	..s nextDay=$lg(^User.DHCDocPassWorkNMainD(NID),13)
	..s record=$lb(code,name,sTime,eTime,nextDay,seqno)
	..i nextDay=2 d
	...i (sTime<=cTime)&&(cTime<=86400) d
	....s findFlag=1
	....s mRtn=record
	...i (0<=cTime)&&(cTime<=eTime) d
	....s findFlag=1
	....s mRtn=record
	..e  i nextDay=1 d
	...i (0<=cTime)&&(cTime<=eTime) d
	....s findFlag=1
	....s mRtn=record
	..e  d
	...i (sTime<=cTime)&&(cTime<=eTime) d
	....s findFlag=1
	....s mRtn=record
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2021-07-13
/// DESC: 根据配置表得到当前时间所属班次的代码
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.COM.Method).GetCurrentBCCode(113)
ClassMethod GetCurrentBCCode(LocId) As %String
{
	s CBCInfo=..GetCurrentBC(LocId)
	s mRtn=$lg(CBCInfo,1)
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2019-02-14
/// DESC: 根据配置表得到当前时间所属班次信息
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.COM.Method).GetCurrentBC(113)
ClassMethod GetCurrentBC(LocId) As %String
{
	s seqno="",mRtn=""
	s findFlag=0,cTime=$p($h,",",2)
	s MID=..GetMIDByLoc(LocId)
	Q:MID="" ""
	f  s seqno=$o(^User.DHCDocPassWorkBCTimeI("BCSeqno",seqno)) q:(seqno="")||(findFlag=1)  d
	.s sub=""
	.f  s sub=$o(^User.DHCDocPassWorkBCTimeI("BCSeqno",seqno,MID,sub)) q:(sub="")||(findFlag=1)  d
	..s active=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildTime",sub),8)
	..q:active'=1
	..s code=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildTime",sub),2)
	..s name=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildTime",sub),3)
	..s sTime=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildTime",sub),4)
	..s eTime=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildTime",sub),5)
	..s nextDay=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildTime",sub),6)
	..s note=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildTime",sub),7)
	..i nextDay=2 d
	...i (sTime<=cTime)&&(cTime<=86400) s findFlag=1
	...i (0<=cTime)&&(cTime<=eTime) s findFlag=1
	..e  i nextDay=1 d
	...i (0<=cTime)&&(cTime<=eTime) s findFlag=1
	..e  d
	...i (sTime<=cTime)&&(cTime<=eTime) s findFlag=1
	..s mRtn=$lb(code,name,sTime,eTime,nextDay,seqno)
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2018-10-24
/// DESC: 得到所有病人类型
/// IN  : 
/// OUT : 1/0
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.COM.Method).GetClassPropertyList("DHCDoc.PW.Model.NMain")
ClassMethod GetClassPropertyList(cls As %String) As %String
{
	
	s myItems=""
	s myobj=##class(%Dictionary.CompiledClass).%OpenId(cls)
	s myCount = myobj.Properties.Count()
	
	s mylist=""	;$p(ClassName,".",$l(ClassName,"."))
	
	For i = 1:1:myCount {
		s myproperty=myobj.Properties.GetAt(i)
		s myName=myproperty.Name
		continue:myName="%%OID"	
		;s cfgInfo=$g(^CF.OPDoc.PW("WKType",myName))
		;continue:cfgInfo=""
		;s isDisplay=$p(cfgInfo,"^",2)
		;continue:isDisplay'=1
		if (mylist="")
		{
			s mylist= myName
		}else
		{
	    	s mylist=mylist_"^"_myName
		}
	}
	i mylist'="" s mylist=mylist
	q mylist
}

/// CTOR: QP
/// DATE: 2019-02-14
/// DESC: 组织XML串
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.COM.Method).BuildXML("1^2^3^4^5^6^7^8^9^10")
ClassMethod BuildXMLOld(ByRef MDList) As %String
{
	s mRtn="<PW>"
	/*s MDList("PreSum")=$p(mRtn,"^",1)
	s MDList("NowSum")=$p(mRtn,"^",2)
	s MDList("OutHospNum")=$p(mRtn,"^",3)
	s MDList("InHospNum")=$p(mRtn,"^",4)
	s MDList("OutWardNum")=$p(mRtn,"^",5)
	s MDList("InWardNum")=$p(mRtn,"^",6)
	s MDList("OperNum")=$p(mRtn,"^",7)
	s MDList("SeverityNum")=$p(mRtn,"^",8)
	s MDList("CritiNum")=$p(mRtn,"^",9)
	s MDList("DeathNum")=$p(mRtn,"^",10)*/
	
	s clsp=..GetClassPropertyList("DHCDoc.PW.Model.NMain")
	
	f i=1:1:$l(clsp,"^") {
		s code=$p(clsp,"^",i)	
		s mRtn=mRtn_"<"_code_">"_MDList(code)_"</"_code_">"
	}
	s mRtn=mRtn_"</PW>"
	Q mRtn
}

/// CTOR: QP
/// DATE: 2019-02-14
/// DESC: 组织XML串
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.COM.Method).BuildXML("1^2^3^4^5^6^7^8^9^10")
ClassMethod BuildXML(ByRef MDList) As %String
{
	s mRtn=""
	s clsp=..GetClassPropertyList("DHCDoc.PW.Model.NMain")
	
	f i=1:1:$l(clsp,"^") {
		s code=$p(clsp,"^",i)	
		i mRtn="" s mRtn=code_":"_MDList(code)
		e  s mRtn=mRtn_"^"_code_":"_MDList(code)
	}
	Q mRtn
}

/// CTOR: QP
/// DATE: 2019-02-14
/// DESC: 组织XML串
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.COM.Method).ParseXML("CritiNum:1^DeathNum:0^InHospNum:0^InWardNum:0^NowSum:22^OperNum:0^OutHospNum:0^OutWardNum:0^PreSum:22^SeverityNum:0")
ClassMethod ParseXML(XML, ByRef XMLList) As %String
{
	f i=1:1:$l(XML,"^") {
		s str=$p(XML,"^",i)
		s code=$p(str,":",1)
		s val=$p(str,":",2)
		s XMLList(code)=val
	}
	Q 0
}

/// CTOR: QP
/// DATE: 2018-10-23
/// DESC: 根据登记号获取当前的有效住院记录ID
/// IN  : 
/// OUT : 1/0
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.COM.Method).GetAdmIdByPatNo("0000000035")
ClassMethod GetAdmIdByPatNo(PapmiNo)
{
	s mRtn=""
	q:PapmiNo="" mRtn
	s PAPMI=$o(^PAPERi("PAPMI_PatNo",PapmiNo,""))
	q:PAPMI="" mRtn
	s PAAdm="" f  s PAAdm=$O(^PAPERdr(PAPMI,"ADM","I",PAAdm)) Q:(PAAdm="")||(mRtn'="")  d
  	.s VistiStatus=$P($g(^PAADM(PAAdm)),"^",20)
  	.q:VistiStatus'="A"
  	.S mRtn=PAAdm
  	
  	Q mRtn
}

/// CTOR: QP
/// DATE: 2018-10-23
/// DESC: 判断是否为本院区患者
/// IN  : 
/// OUT : 1/0
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.COM.Method).IsSelfHospPatient("0000000022",2)
ClassMethod IsSelfHospPatient(PapmiNo, InHosp)
{
	s mRtn=0
	q:PapmiNo="" mRtn
	s PAPMI=$o(^PAPERi("PAPMI_PatNo",PapmiNo,""))
	q:PAPMI="" mRtn
	s PAAdm="" f  s PAAdm=$O(^PAPERdr(PAPMI,"ADM","I",PAAdm)) Q:(PAAdm="")||(mRtn'=0)  d
  	.s VistiStatus=$P($g(^PAADM(PAAdm)),"^",20)
  	.q:VistiStatus'="A"
  	.s AdmLoc=$P($g(^PAADM(PAAdm)),"^",4)
  	.q:AdmLoc=""
  	.s Hosp=$p(^CTLOC(AdmLoc),"^",22)
  	.Q:InHosp'=Hosp
  	.s mRtn=1
  	
  	Q mRtn
}

/// CTOR: QP
/// DATE: 2018-10-23
/// DESC: 根据登记号获取当前的有效住院记录ID
/// IN  : 
/// OUT : 1/0
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.COM.Method).ToList("1,2,3",.DList)
ClassMethod ToList(mstr, ByRef DList)
{
	Q:mstr="" 0
	f i=1:1:$l(mstr,",") {
		s code=$p(mstr,",",i)	
		s DList(code)=""
	}
	Q 0
}

/// CTOR: QP
/// DATE: 2018-10-23
/// DESC: 找出One在Two中不存在的数
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.COM.Method).HasNoNums("1,2,3","2,4")
ClassMethod HasNoNums(One, Two)
{
	s mRtn=""
	Q:Two="" One
	Q:One="" mRtn
	
	d ..ToList(Two,.TWOList)
	f i=1:1:$l(One,",") {
		s val=$p(One,",",i)	
		i '$d(TWOList(val)) {
			i mRtn="" s mRtn=val
			e  s mRtn=mRtn_","_val
		}
	}
	Q mRtn
}

/// CTOR: QP
/// DATE: 2019-02-14
/// DESC: 清楚索引
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.COM.Method).ClearIndex("")
ClassMethod ClearIndex(ByRef MDList) As %String
{
	k ^User.DHCDocPassWorkNMainI
	k ^User.DHCDocPassWorkNSubI
	k ^DHCDocPassWorkNSubTypeI
}

/// CTOR: QP
/// DATE: 2021-01-12
/// DESC: 得到科室类型
/// OUT : O/I/E/H
/// EXEC: w ##class(DHCDoc.PW.COM.Method).GetDepType(2)
ClassMethod GetDepType(locid)
{
	s mRtn=""
	i $d(^PAC("ADMLOC",0,"AdmType","O",locid)) {
		s mRtn="O"
	} elseif ($d(^PAC("ADMLOC",0,"AdmType","E",locid))) {
		s mRtn="E"
	} elseif ($d(^PAC("ADMLOC",0,"AdmType","I",locid))) {
		s mRtn="I"
	} elseif ($d(^PAC("ADMLOC",0,"AdmType","H",locid))) {
		s mRtn="H"
	} else {}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-07-20
/// DESC: 得到手术名称
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.COM.Method).GetOperNameByAdmid()
ClassMethod GetOperNameByAdmid(EpisodeID) As %String
{
	s mRtn=""
	s langid=##class(DHCDoc.PW.COM.Method).%LanguageID()
	Set opaAdmDr=EpisodeID
	s opaId="" f  s opaId=$O(^DHCANOPArrange(0,"Adm",EpisodeID,opaId)) q:opaId=""  d
	.s anaId=$P(^DHCANOPArrange(opaId),"^",2) ;手术麻醉Id
	.s OPAStatus=$P(^DHCANOPArrange(opaId),"^",27)
	.q:((OPAStatus="D")||(OPAStatus="C"))
	.s anaSub=$P(anaId,"||",2)
	.s anaopSub=0 
	.Set opName="",operCut="" 
	.Set operLocId=""
	.f  s anaopSub=$O(^OR(opaAdmDr,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  d  
	..s curOperId=$P(^OR(opaAdmDr,"ANA",anaSub,"OP",anaopSub),"^",6)
	..q:curOperId=""
	..if $D(^ORC("OPER",curOperId)) d
	...s tmpName=$P(^ORC("OPER",curOperId),"^",2)
	...s tmpName=##class(User.ORCOperation).GetTranByDesc("OPERDesc",tmpName,langid)
	...i opName="" s opName=tmpName
	...e  s opName=$G(opName)_","_tmpName
	.i mRtn="" s mRtn=opName
	.e  s mRtn=mRtn_","_opName
   	
	q mRtn
}

/// CTOR: QP
/// DATE: 2021-08-27
/// DESC: 清楚配置数据
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.COM.Method).ClearConfig()
ClassMethod ClearConfig() As %String
{
	&SQL(TRUNCATE TABLE SQLUser.DHCDocPassWorkBCMain)
	Q 1
}

/// CTOR: QP
/// DATE: 2021-08-27
/// DESC: 清楚业务数据
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.COM.Method).ClearBS()
ClassMethod ClearBS() As %String
{
	&SQL(TRUNCATE TABLE SQLUser.DHCDocPassWorkNMain)
	&SQL(TRUNCATE TABLE SQLUser.DHCDocPassWorkNSubExt)
	
	Q 1
}

/// CTOR: QP
/// DATE: 2021-11-11
/// DESC: 获取当前配置的翻译语言
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.COM.Method).%LanguageID()
ClassMethod %LanguageID() As %String
{
    Set langid=20
    if ($d(%session)){
        set langid=+$g(%session.Data("LOGON.LANGID"))
    }
    q langid
}

/// CTOR: QP
/// DATE: 2018-10-23
/// DESC: 获取病人基本信息
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.COM.Method).GetPatInfo(2)
ClassMethod GetPatInfo(AdmRowID As %String) As %String
{
	s PAPMIRowID=$p($g(^PAADM(AdmRowID)),"^",1)
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(AdmRowID)
	s ErrMsg=""
	s PatMedicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(AdmRowID,AdmType,.ErrMsg) ;病历号
	s PatNo=$p($g(^PAPER(PAPMIRowID,"PAT",1)),"^",1)
	;s PatMedicareNo=$p($g(^PAPER(PAPMIRowID,"PAT",1)),"^",22)
	s PatName=$p($g(^PAPER(PAPMIRowID,"ALL")),"^",1)
	s PatSexDesc=""
	s PatSexId=$p($g(^PAPER(PAPMIRowID,"ALL")),"^",7)
	i PatSexId'="" s PatSexDesc=$p($g(^CT("SEX",PatSexId)),"^",2)
	s PatBirth=$p($g(^PAPER(PAPMIRowID,"ALL")),"^",6)
	s PatAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PAPMIRowID,AdmRowID)
	S PatHomeAddres=$g(^PAPER(PAPMIRowID,"PER","ADD"))		;家庭住址
	s PatHomeTel=$p($g(^PAPER(PAPMIRowID,"PER",1)),"^",11)	;家庭电话
	s PatWorkTel=$p($g(^PAPER(PAPMIRowID,"PER",1)),"^",9)	;工作电话
	s PatHandTel=$p($g(^PAPER(PAPMIRowID,"PER",4)),"^",21)	;手机
    ;
	s AdmLocId=$p($g(^PAADM(AdmRowID)),"^",4)
	s AdmLocDesc=$p($g(^CTLOC(AdmLocId)),"^",2)
	s AdmDocDesc=""
	s AdmDocId=$p(^PAADM(AdmRowID),"^",9)
	i AdmDocId'="" s AdmDocDesc=$p($g(^CTPCP(AdmDocId,1)),"^",2)
	s CurWardDesc=""
	s CurWardId=$p($g(^PAADM(AdmRowID)),"^",70)
	i CurWardId'="" s CurWardDesc=$p($g(^PAWARD(CurWardId)),"^",1)
	s AdmRoomDesc=""
	s AdmRoomId=$p(^PAADM(AdmRowID),"^",69)
	i AdmRoomId'="" s AdmRoomDesc=$p($g(^PAROOM(AdmRoomId)),"^",2)
	s CurBedCode=""
	s CurBedId=$p($g(^PAADM(AdmRowID)),"^",73)
	i CurBedId'="" s CurBedCode=$p($g(^PAWARD(+CurBedId,"BED",$p(CurBedId,"||",2))),"^",1)
	s MRDiagnos=""
    s MRAdmId=$p($g(^PAADM(AdmRowID)),"^",61)
    s MRDiagnos=##class(web.DHCDocInPatientList).GetMRAdmDiagnosis(MRAdmId,";")
    /*s MRAdmSub=0 f  s MRAdmSub=$o(^MR(MRAdmId,"DIA",MRAdmSub)) q:MRAdmSub=""  d
    .s ICDCodeDesc=""
	.s ICDCodeDr=$p($g(^MR(MRAdmId,"DIA",MRAdmSub)),"^",1)
	.i ICDCodeDr'="" s ICDCodeDesc=$p($g(^MRC("ID",ICDCodeDr)),"^",2)
	.s DescSub=$o(^MR(MRAdmId,"DIA",MRAdmSub,"DES",0))
	.i DescSub'="" d
	..i ICDCodeDesc="" s ICDCodeDesc=$g(^MR(MRAdmId,"DIA",MRAdmSub,"DES",DescSub))
	..e  s ICDCodeDesc=ICDCodeDesc_$g(^MR(MRAdmId,"DIA",MRAdmSub,"DES",DescSub))
	.i MRDiagnos="" s MRDiagnos=ICDCodeDesc
	.e  s MRDiagnos=MRDiagnos_","_ICDCodeDesc*/
    s retStr=PAPMIRowID_"^"_PatNo_"^"_PatName_"^"_PatSexDesc_"^"_PatAge_"^"_PatMedicareNo_"^"_PatHomeTel_"  "_PatWorkTel_"  "_PatHandTel_"^"_PatHomeAddres_"^"_MRDiagnos_"^"_AdmLocDesc_"^"_AdmDocDesc_"^"_CurWardDesc_"^"_AdmRoomDesc_"^"_CurBedCode
    q retStr
}

}
