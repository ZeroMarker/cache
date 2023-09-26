/// Description: 配液综合查询
Class web.DHCSTPIVAS.Generally Extends web.DHCSTPIVAS.Common
{

/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Generally","PogData", {"loc":"186","ordStartDate":"2022-09-25","ordEndDate":"2022-11-22","locGrp":"","wardStr":"","priority":"","passResult":"","psNumber":"","oeoreStat":"","patNo":"","pogsNo":"","pNoStart":"","pNoEnd":"","batNoStr":"1,2,3,4,5,6,空","prtStoped":"","barCode":"","instruc":"","freq":"","prtStartDate":"2022-09-25","prtEndDate":"2022-11-21","inci":"","pivaCat":"","prtStartTime":"","prtEndTime":"","refuseFlag":"","ordStartTime":"","ordEndTime":"","workType":"","packFlag":""}.%ToJSON())
Query PogData(pJsonStr = "{}") As websys.Query(ROWSPEC = "doseDateTime, wardDesc, bedNo, patNo, patName, batNo, drugsArr, freqDesc, instrucDesc, durationDesc,  priDesc, oeoreStat, visitStatus, xDateTime, psName, passResultDesc, pNo, printUser, printDateTime, refUser, refDateTime, barCode, cPrtDateTime, cPrtUser, pog, mDsp, warnInfo, packFlag, sameFlag, altFlag, linkFeeAmt, phaOrdDateTime, phaOrdUser, oeoriStatDesc, oeoreStatDesc, nurSeeDateTime, nurSeeUser, nurSeeDesc, refReasonDesc, psNumber")
{
}

ClassMethod PogDataExecute(ByRef qHandle As %Binary, pJsonStr = "{}") As %Status
{
	// s ^PHATMP("MYQ", $this, "PogData") = pJsonStr
	s repid = $i(^CacheTemp)
	s qHandle = $lb(0, repid, 0)
	s ind = 1
	q:(pJsonStr = "{}") $$$OK
	s pJson = ##class(PHA.COM.Json).Parse(pJsonStr)
	q:'$IsObject(pJson) $$$OK
	s pLoc = pJson.loc
	s auditTimes=##class(web.DHCSTPIVAS.Settings).GetAppParamProp("", pLoc, "OeAudit", "AuditTimes")
	s ps10 = ..LocPsIdByPsNumber(pLoc, 10)
	d ..Collect(pJsonStr, .collectData)
	s lastPatNo = "", altCnt = 0
	s sortIndex = ""
	for {
		s sortIndex = $o(collectData(sortIndex))
		q:(sortIndex = "")
		s firstPog = $o(collectData(sortIndex, 0))
		s firstDsp = $p($g(^PIVA(firstPog)), "^", 1)
		s dspData = $g(^DHCOEDISQTY(firstDsp))
		s wardLoc = $p(dspData, "^", 22)
		s wardDesc = ##class(PHA.PIVAS.Data.Base).LocDesc(wardLoc)
		s adm = $p(dspData, "^", 26)
		s admData = $g(^PAADM(adm))
		s pat = $p(admData, "^", 1)
		s patNo = $p(^PAPER(pat, "PAT", 1), "^", 1)
		s bedNo = $p(##class(web.DHCSTCOMMONORDER).GetAdmBedCode(adm), "^", 2)
	 	s patName = $p(^PAPER(pat, "ALL"), "^", 1)
	 	s patSex = $p(^PAPER(pat, "ALL"), "^", 7)
	 	s patSex = ##class(PHA.PIVAS.Data.Base).SexDesc(patSex)
	 	s patAge =##class(PHA.FACE.IN.Com).GetAge(pat, adm) 	
		s visitStatus = ..IfQuitAdmStatusD(adm)
		s visitStatus = $s(visitStatus = "1" : ##class(PHA.COM.Base).Get("出院") , 1 : ##class(PHA.COM.Base).Get("在院"))
		s pog = ""
		for {
			s pog = $o(collectData(sortIndex, pog))
			q:(pog = "")
			s mDsp = $p($g(^PIVA(pog)), "^", 1)
			s mDspData = $g(^DHCOEDISQTY(mDsp))
			s mOeore = $p(mDspData, "^", 3)
	        s mOeori = $p(mDspData, "^", 1)
	        s mOeore = $p(mDspData, "^", 3)
	        s doseTime=$p(mDspData,"^",20)
	        s doseDate=$p(mDspData,"^",21)
	        s wardLoc = $p(mDspData, "^", 22)
	        s wardDesc= ##class(PHA.PIVAS.Data.Base).LocDesc(wardLoc)
	        s adm = $p(dspData, "^", 26)
	        s packFlag = ..DspPackFlag(mDsp)
	        s doseDateTime = ..DateShortFormat(doseDate)_" "_..TimeShortFormat(doseTime)        
	        s freqDesc=$p(..OeoriFreq(mOeori), "^", 2)
	        s instrucDesc=$p(..OeoriInstruc(mOeori), "^", 2)
	        s docName=$p(..OeoriDoctor(mOeori), "^", 2)
	        s pivaCatDesc = $p(..GetOrdPivaCat(mOeori), "^", 2)
			s (phaOrdDate, phaOrdTime, phaOrdUser, phaOrdDateTime) = ""
			s phaOrdResultStr=..GetOrdPassState(mOeori, doseDate, auditTimes, pLoc)
			s passResultDesc = $p(phaOrdResultStr, "^", 2)
			s phaOrd = $p(phaOrdResultStr, "^", 3)
			if (phaOrd '= "")&&(passResultDesc '= ""){
				s phaOrdData = $g(^DHCPHORDM(phaOrd))
				s phaOrdDate = $p(phaOrdData,"^",3)
				s phaOrdTime = $p(phaOrdData, "^",4)
				s phaOrdDateTime =  $$$zd(phaOrdDate) _ " " _ $$$zt(phaOrdTime)
				s phaOrdUser = $p($g(^DHCPHORDM(phaOrd)), "^", 1)
				s phaOrdUser = ##class(PHA.PIVAS.Data.Base).UserName(phaOrdUser)
			}

			s pogData = $g(^PIVA(pog))
			s batNo = $p(pogData, "^", 3)
			s ps = $p(pogData, "^", 6)
			s pNo = $j($p(pogData, "^", 11), 4) 
			s psName = ##class(PHA.COM.Data.Base).PIVASStateName(ps)
            s psNumber = $p(^PIVAS(ps), "^", 1)
			s priDesc = $p(..OeoriPriority(mOeori), "^", 3)
			s durationDesc = $p(..OeoriDuration(mOeori), "^", 2)
			s oeoreStatDesc = $p(..OeoreStat(mOeore), "^", 2)
			i (oeoreStatDesc["停止"){
				s oeStatus=##class(web.DHCSTCOMMONSRV).GetOreStatus(mOeore)
				i (oeStatus=1) {
					s oeoreStatDesc=oeoreStatDesc_"(未退药)"
					s allowRetFlag = $p(pogData, "^", 28)
					if (allowRetFlag = "Y"){
						s oeoreStatDesc = oeoreStatDesc_"已置可退"
					}
				}
				elseif (oeStatus>1) {
					s oeoreStatDesc=oeoreStatDesc_"(已退药)"
				} 
			}
			
			s pogs10 = $o(^PIVA(0, "PS", ps10, pog, 0))
			s pogs10Data = $g(^PIVA(pog, "S", pogs10))
		 	s printUser = $p(pogs10Data, "^", 3)
		 	s printDate = $p(pogs10Data, "^", 4)
		 	s printTime = $p(pogs10Data, "^", 5)
		 	s printDateTime = $$$zd(printDate) _ " " _ $$$zt(printTime)
		 	s printUser = ##class(PHA.PIVAS.Data.Base).UserName(printUser)
		
			s specStat = $p(pogData, "^", 8)
			s (refDateTime, refUser, refReasonDesc) = ""
			if (specStat = "R") {
				s refUser = $p(pogData, "^", 12)
				s refDate = $p(pogData, "^", 13)
				s refTime = $p(pogData, "^", 14)
			 	s refDateTime = $$$zd(refDate) _ " " _ $$$zt(refTime)
				s refUser = ##class(PHA.PIVAS.Data.Base).UserName(+refUser)
				s refReasonDesc = ..PogRefuseReason(pog)		
			}
			
			s cPrint = $p(pogData, "^", 15)
			s (cPrtDateTime, cPrtUser) = ""
			if (cPrint '= "") {
				s cPrtData = $g(^PIVACP(cPrint))
				s cPrtUser = $p(cPrtData, "^", 2)
				s cPrtDate = $p(cPrtData, "^", 3)
 				s cPrtTime = $p(cPrtData, "^", 4)
 				s cPrtDateTime = $$$zd(cPrtDate) _ " "_ $$$zt(cPrtTime)
				s cPrtUser = ##class(PHA.PIVAS.Data.Base).UserName(+cPrtUser)
			}
			s oeoreXData = $g(^OEORD(+mOeore, "I", +$p(mOeore, "||", 2), "X", +$p(mOeore, "||", 3)))
			s xDate = $p(oeoreXData, "^", 12)
			s xTime = $p(oeoreXData, "^", 14)
			s xDateTime = $$$zd(xDate) _ " " _ $$$zt(xTime)
			s oeoriStatDesc = $p(..OeoriStat(mOeori), "^", 2)
	        s drugsArr = ..GetOeoreDrugsArr(mOeore)
			s barCode = ..OeoreToBarCode(mOeore)
			s warnInfo = ""
			s linkFeeAmt = ..GetLinkFeeAmt(pog)
			s linkFeeAmt = $s(+linkFeeAmt=0 : "" , 1 : $fn(linkFeeAmt, "", 2))
			s nurSeeDesc = $p(..GetNurseSeeType(mOeori, pLoc), "^", 3)
			s (nurSeeUser, nurSeeDateTime) = ""
			if (nurSeeDesc '= ""){
				s nurSeeData = $g(^OEORD(+mOeori, "I", +$p(mOeori, "||", 2), "NUR"))
				s nurSeeUser = $p(nurSeeData, "^", 4)
				s nurSeeDate = $$$zd($p(nurSeeData, "^", 5))
				s nurSeeTime = $$$zt($p(nurSeeData, "^", 6))
				s nurSeeDateTime = nurSeeDate _ " " _ nurSeeTime
				s nurSeeUser = ##class(PHA.PIVAS.Data.Base).UserName(+nurSeeUser)
			}	
			s sameFlag = "" 
			if (lastPatNo = patNo) {
				s sameFlag = "Y"
			}
			if (lastPatNo '= patNo){
				s altFlag = "N"
				s altCnt = altCnt + 1
				i altCnt = 2 s altFlag = "Y", altCnt = 0	
			}
			s pNo=$j(pNo,5)
			s lastPatNo = patNo
			s ^CacheTemp(repid, ind) = $lb(doseDateTime, wardDesc, bedNo, patNo, patName)
									 _ $lb(batNo, drugsArr, freqDesc, instrucDesc, durationDesc)
									 _ $lb(priDesc, "", visitStatus, xDateTime, psName)  
									 _ $lb(passResultDesc, pNo, printUser, printDateTime,refUser) 
									 _ $lb(refDateTime, barCode, cPrtDateTime, cPrtUser, pog)  
									 _ $lb(mDsp, warnInfo, packFlag, sameFlag, altFlag)  
									 _ $lb(linkFeeAmt, phaOrdDateTime, phaOrdUser, oeoriStatDesc, oeoreStatDesc)  
									 _ $lb(nurSeeDateTime, nurSeeUser, nurSeeDesc, refReasonDesc, psNumber)
			
			s ind = ind + 1				
		}
	}
	q $$$OK
}

ClassMethod Collect(pJsonStr = "{}", Output collectData)
{
	q:pJsonStr="{}" ""
	s pJson = ##class(PHA.COM.Json).Parse(pJsonStr)
	q:'$IsObject(pJson) ""
	
	s pLoc = pJson.loc 
	s pOrdStartDate = pJson.ordStartDate, pOrdEndDate = pJson.ordEndDate, pOrdStartTime = pJson.ordStartTime, pOrdEndTime = pJson.ordEndTime
	s pPrtStartDate = pJson.prtStartDate, pPrtEndDate = pJson.prtEndDate, pPrtStartTime = pJson.prtStartTime, pPrtEndTime = pJson.prtEndTime
	s pPatNo = pJson.patNo
	s pBarCode= pJson.barCode, pPogsNo = pJson.pogsNo
	s pPNoStart = pJson.pNoStart
	s pPNoEnd = pJson.pNoEnd
	s pBatNoList = $lfs(pJson.batNoStr)
	s pPsNumber = pJson.psNumber
	s pInstruc = pJson.instruc
	s pFreq = pJson.freq
	s pInci = pJson.inci
	s pPivaCat = pJson.pivaCat
	s pPriority = pJson.priority
	s pPassResult = pJson.passResult
	s pOeoreStat = pJson.oeoreStat
	s pWorkType = pJson.workType
	s pPrtStoped = pJson.prtStoped
	s pRefuse = pJson.refuseFlag
	s pLocGrp = pJson.locGrp
	s pPack = pJson.packFlag
	s pWardList = $lfs(pJson.wardStr)	
	
	s pOrdStartDate = $$$zdh(pOrdStartDate)
	s pOrdEndDate = $$$zdh(pOrdEndDate)
	s pOrdStartTime= $$$zth(pOrdStartTime)
	s pOrdEndTime = $$$zth(pOrdEndTime)

	s pPrtStartDate = $$$zdh(pPrtStartDate)
	s pPrtEndDate = $$$zdh(pPrtEndDate)
	s pPrtStartTime= $$$zth(pPrtStartTime)
	s pPrtEndTime = $$$zth(pPrtEndTime)
    q:(pPNoStart '= "")&&(pPNoStart '= +pPNoStart) ""
    q:(pPNoEnd '= "")&&(pPNoEnd '= +pPNoEnd) ""
	q:(pLoc="") ""
	s auditTimes=##class(web.DHCSTPIVAS.Settings).GetAppParamProp("", pLoc, "OeAudit", "AuditTimes")
	s ps10 = ..LocPsIdByPsNumber(pLoc, 10)
	k calcData
	if pBarCode '= "" {
		s mOeore = ..BarCodeToOeore(pBarCode)
		q:(mOeore = "")
		s mDsp = $o(^DHCOEDISQTY(0, "OEORE", mOeore, 0))
		q:(mDsp = "")
		s pog = $o(^PIVA(0, "DSP", mDsp, 0))
		q:(pog = "")
		s calcData(pog) = ""
	} elseif pPogsNo '= "" {
		s pog = 0
		for {
			s pog = $o(^PIVA(0, "PogsNo", pPogsNo, pog)) 
			q:(pog = "")
			s calcData(pog) = ""
		}
	} else {
		for calcDate = pOrdStartDate : 1 : pOrdEndDate {
			s pog = 0
			for {
				s pog = $o(^PIVA(0, "LOCORDDATE", pLoc, calcDate, pog))
				q:(pog = "")
				s calcData(pog) = ""
			}
		}
	}
	/* 默认筛选与排序 */
	s pog = ""
	for {
		s pog = $o(calcData(pog))
		q:(pog = "")
		k calcData(pog)
		s pogs10 = $o(^PIVA(0, "PS", ps10, pog, 0))
		continue:(pogs10 = "")
		s pogData = $g(^PIVA(pog))
		s mDsp = $p(pogData, "^", 1)
		s batNo = $p(pogData, "^", 3)
 		s ps = $p(pogData, "^", 6)
 		s specStat = $p(pogData, "^", 8)		// 特殊状态
 		s pNo = $p(pogData, "^", 11)
		s workType = $p(pogData, "^", 24)	
 		s psNumber = $P(^PIVAS(ps), "^", 1)
		s mDspData = $g(^DHCOEDISQTY(mDsp))
		s mOeori = $p(mDspData, "^", 1)
		s mOeore = $p(mDspData, "^", 3)
		s doseDate = $p(mDspData, "^", 21)
		s doseTime=$p(mDspData,"^",20)
		s wardLoc = $p(mDspData, "^", 22)
		s ward = $o(^PAWARD(0, "WARD_LocationDR", wardLoc, 0))
		s packFlag = ..DspPackFlag(mDsp)
		s mOrd = +mOeori
		s mOrdItm = +$p(mOeori, "||", 2)
		s adm = $P(^OEORD(mOrd), "^", 1)
		s pat = $p(^PAADM(adm), "^", 1)
		s patNo = $p(^PAPER(pat, "PAT", 1), "^", 1)
		s mOeRetStatus=##class(web.DHCSTCOMMONSRV).GetOreStatus(mOeore)

		continue:(pPNoStart '= "")&&(pNo < pPNoStart)
		continue:(pPNoEnd '= "")&&(pNo > pPNoEnd)
		continue:($lf(pBatNoList, batNo) = 0)
		continue:(pPsNumber '= "")&&(pPsNumber '= psNumber)
		continue:(pPatNo '= "")&(pPatNo '= patNo)
		continue:(pInstruc '= "")&&(pInstruc '= +..OeoriInstruc(mOeori))
		continue:(pFreq '= "")&&(pFreq '= +..OeoriFreq(mOeori))
		continue:(pInci '= "")&&(..IsInciInPog(pog, pInci) '= "Y")
		continue:(pPivaCat '= "")&&(pPivaCat '= +..GetOrdPivaCat(mOeori))
		continue:(pPriority '= "")&&(pPriority '= +..OrdPriority(mOeori))
		continue:(pPassResult '= "")&&(pPassResult '= $p(..GetOrdPassState(mOeori, doseDate, auditTimes), "^", 1))
		continue:(pOeoreStat = 1)&&(..CheckOeoreStat(mOeore) '= 1)
		continue:((pOeoreStat=2)||(pOeoreStat=3))&&(..CheckOeoreStat(mOeore)=1)
		//continue:(pOeoreStat = 2)&&(..CheckOeoreStat(mOeore) = 1)
		continue:(pOeoreStat=2)&&(mOeRetStatus>1)   //停止(未退药)  
		continue:(pOeoreStat=3)&&(mOeRetStatus<=1)  //停止(已退药)
		continue:(pWorkType '= "")&&(pWorkType '= workType)
		continue:(pPrtStoped = "Y")&&($p(pogData, "^", 15) = "")
		continue:(pPrtStoped = "N")&&($p(pogData, "^", 15) '= "")
		continue:(pRefuse = "Y")&&(specStat '= "R")
		continue:(pRefuse = "N")&&(specStat = "R")
		continue:(..CheckDspPack(mDsp, pPack)'= "Y")
		continue:(pLocGrp '= "")&&(..CheckLocGrp(pLocGrp,wardLoc) = 0)
		continue:(pWardList '= "")&&($lf(pWardList, ward) = 0)
		continue:(doseDate = pOrdStartDate)&&(pOrdStartTime '= "")&&(doseTime < pOrdStartTime)
		continue:(doseDate = pOrdEndDate)&&(pOrdEndTime '= "")&&(doseTime > pOrdEndTime)
		s pogs10Data = $g(^PIVA(pog, "S", pogs10))
		s prtDate = $p(pogs10Data, "^", 4)
		s prtTime = $p(pogs10Data, "^", 5)
		continue:(prtDate < pPrtStartDate)
		continue:(prtDate > pPrtEndDate)
		continue:(prtDate = pPrtStartDate)&&(pPrtStartTime '= "")&&(prtTime < pPrtStartTime)
		continue:(prtDate = pPrtEndDate)&&(pPrtEndTime '= "")&&(prtTime > pPrtEndTime)
		
		s bedNo = $p(pogData, "^", 34)
		
		s sortIndex = "1"
		if pPogsNo '= "" {
			s sortIndex = pNo
		} else {
			s sortIndex = doseDate _ "||" _ $j(wardLoc, 5) _ "||" _ $j(bedNo, 5) _ "||" _ patNo _ "||" _ $j(batNo, 5)
		}
	
		s collectData(sortIndex, pog) = ""		
	}
	q ""
}

}
