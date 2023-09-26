/// Description: 配液医嘱查询
Class web.DHCSTPIVAS.OeQuery Extends web.DHCSTPIVAS.Common
{

Query PatData(pJsonStr = "{}") As websys.Query(ROWSPEC = "pat, patNo, patName, patSex, patAge, bedNo, wardDesc")
{
}

ClassMethod PatDataExecute(ByRef qHandle As %Binary, pJsonStr = "{}") As %Status
{
	s repid = $i(^CacheTemp)
	s qHandle = $lb(0, repid, 0)
	s ind = 1
	q:(pJsonStr = "{}") $$$OK
	
	d ..Collect(pJsonStr, .collectData)
	
	s patIndex = ""
	for {
		s patIndex = $o(collectData(patIndex))
		q:(patIndex = "")
		s dsp = $o(collectData(patIndex, 0))
		s dspData = $g(^DHCOEDISQTY(dsp))
		s wardLoc = $p(dspData, "^", 22)
		s wardDesc = $p(^CTLOC(wardLoc), "^", 2)
		s adm = $p(dspData, "^", 26)
		s admData = $g(^PAADM(adm))
		s pat = $p(admData, "^", 1)
		s patNo = $p(^PAPER(pat, "PAT", 1), "^", 1)
		s bedNo = $p(##class(web.DHCSTCOMMONORDER).GetAdmBedCode(adm), "^", 2)
	 	s patName = $p(^PAPER(pat, "ALL"), "^", 1)
	 	s patSex = $p(^PAPER(pat, "ALL"), "^", 7)
	 	s patSex = $p($g(^CT("SEX", +patSex)), "^", 2)
	 	s patAge = ##class(PHA.FACE.IN.Com).GetAge(pat, adm) 	
		s ^CacheTemp(repid, ind) = $lb(pat, patNo, patName, patSex, patAge, bedNo, wardDesc)    
		s ind = ind + 1	
	}
	q $$$OK
}

Query OrdExeData(pJsonStr = "{}") As websys.Query(ROWSPEC = "mOeore,doseDateTime,passResultDesc, psNumber, psDesc, batNo, drugsArr,freqDesc, instrucDesc, priDesc, docName, packFlag, barCode, oeoriStatDesc, oeoreStatDesc")
{
}

ClassMethod OrdExeDataExecute(ByRef qHandle As %Binary, pJsonStr = "{}") As %Status
{
	s repid = $i(^CacheTemp)
	s qHandle = $lb(0, repid, 0)
	s ind = 1
	q:(pJsonStr = "{}") $$$OK
	s pJson = ##class(PHA.COM.Json).Parse(pJsonStr)
	q:'$IsObject(pJson) $$$OK
	s pLoc = pJson.loc
	s auditTimes=##class(web.DHCSTPIVAS.Settings).GetAppParamProp("", pLoc, "OeAudit", "AuditTimes")
	
	d ..Collect(pJsonStr, .collectData)
	
	s patIndex = ""
	for {
		s patIndex = $o(collectData(patIndex))
		q:(patIndex = "")
		s firtstDsp = $o(collectData(patIndex, 0))
		s dspData = $g(^DHCOEDISQTY(firtstDsp))
		s wardLoc = $p(dspData, "^", 22)
		s wardDesc = $p(^CTLOC(wardLoc), "^", 2)
		s adm = $p(dspData, "^", 26)
		s admData = $g(^PAADM(adm))
		s pat = $p(admData, "^", 1)
		s patNo = $p(^PAPER(pat, "PAT", 1), "^", 1)
		s bedNo = ##class(web.DHCSTCOMMONORDER).GetAdmBedCode(adm)
	 	s patName = $p(^PAPER(pat, "ALL"), "^", 1)
	 	s patSex = $p(^PAPER(pat, "ALL"), "^", 7)
	 	s patSex = $p($g(^CT("SEX", +patSex)), "^", 2)
	 	s patAge = ##class(PHA.FACE.IN.Com).GetAge(pat, adm) 	
		s mDsp = ""
		for {
			s mDsp = $o(collectData(patIndex, mDsp))
			q:(mDsp = "")
			s mDspData = $g(^DHCOEDISQTY(mDsp))
			s mOeore = $p(mDspData, "^", 3)
	        s mOeori = $p(mDspData, "^", 1)
	        s mOeore = $p(mDspData, "^", 3)
	        s doseTime=$p(mDspData,"^",20)
	        s doseDate=$p(mDspData,"^",21)
	        s wardLoc = $p(mDspData, "^", 22)
	        s wardDesc= $p(^CTLOC(wardLoc), "^", 2)
	        s adm = $p(dspData, "^", 26)
	        s packFlag = ..DspPackFlag(mDsp)
	        s doseDateTime = ..DateShortFormat(doseDate)_" "_..TimeShortFormat(doseTime)        
	        s freqDesc=$p(..OeoriFreq(mOeori), "^", 2)
	        s instrucDesc=$p(..OeoriInstruc(mOeori), "^", 2)
	        s docName=$p(..OeoriDoctor(mOeori), "^", 2)
	        s pivaCatDesc = $p(..GetOrdPivaCat(mOeori), "^", 2)
	        s passResultDesc = $p(..GetOrdPassState(mOeori, doseDate, auditTimes, pLoc), "^", 2)
			s batNo = ""
			s pog = $o(^PIVA(0,"DSP",mDsp,""))
			i pog '= "" d
			.s batNo = $p($g(^PIVA(pog)), "^", 3)
			s psStr = ..CurPsState(mDsp)
			s psNumber = $p(psStr, "^", 1)
			s psDesc = $p(psStr, "^", 2)
			s priDesc=$p(..OeoriPriority(mOeori), "^", 3)
	        s drugsArr = ..GetOeoreDrugsArr(mOeore)
			s oeoriStatDesc = $p(..OeoriStat(mOeori), "^", 2)
			s oeoreStatDesc = $p(..OeoreStat(mOeore), "^", 2)
			s barCode = ..OeoreToBarCode(mOeore)
			s ^CacheTemp(repid, ind) = $lb(mOeore, doseDateTime, passResultDesc, psNumber, psDesc)
									 _ $lb(batNo, drugsArr, freqDesc, instrucDesc, priDesc)
									 _ $lb(docName, packFlag, barCode, oeoriStatDesc, oeoreStatDesc)    
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
	
	s pLoc = pJson.loc, pStartDate = pJson.startDate, pEndDate = pJson.endDate, pStartTime = pJson.startTime
	s pEndTime = pJson.endTime, pWard = pJson.ward, pPatNo = pJson.patNo
	
	s pStartDate = $$$zdh(pStartDate)
	s pEndDate = $$$zdh(pEndDate)
	s pStartTime= $$$zth(pStartTime)
	s pEndTime = $$$zth(pEndTime)
	q:(pLoc="") ""
	
	s statusStr = "TC^C"      
	s len = $l(statusStr, "^")  
	for i = 1 : 1 : len {
		s status = $p(statusStr, "^", i)
		for calcDate = pStartDate : 1 : pEndDate {
			s adm = 0
			for {
				s adm = $o(^DHCOEDISQTY(0, "ADM", pLoc, calcDate, status, adm))
				q:(adm = "")
				s admData = $g(^PAADM(adm))
				continue:($p(admData, "^", 2) '= "I")
				s pat = $p(admData, "^", 1)
				s patNo = $p(^PAPER(pat, "PAT", 1), "^", 1)
				continue:(pPatNo '= "")&&(pPatNo '= patNo)
				s dsp = 0
				for {
					s dsp = $o(^DHCOEDISQTY(0,"ADM",pLoc, calcDate, status, adm, dsp))
					q:(dsp = "")
					s dspData = $g(^DHCOEDISQTY(dsp))
					s doseTime=$p(dspData,"^",20)
					continue:(pStartTime '= "")&&(calcDate = pStartDate)&&(pStartTime > doseTime)
					continue:(pEndTime '= "")&&(calcDate = pEndDate)&&(pEndTime < doseTime)
					s oeori = $p(dspData, "^", 1)
					continue:($p(..GetArcItmCatByOeori(oeori), "^", 4) '= "R")
					s catCode = $p(dspData, "^", 27)
					continue:(catCode '= 0)
					s wardLoc = $p(dspData, "^", 22)
				    s ward = $o(^PAWARD(0, "WARD_LocationDR", wardLoc, ""))
					continue:(pWard '= "")&&(pWard '= ward)
					s seqNo = $p(dspData, "^", 4)
					s mDsp = ..GetMainDspId(dsp, seqNo)
					continue:(mDsp = "")
					continue:($d(collectData(mDsp)))
					s bedNo = ##class(web.DHCSTCOMMONORDER).GetAdmBedCode(adm, ward)
					if (bedNo = "") {
						s bedNo = $$$MaxStr
					}
					s patIndex = $j(ward,10) _ "||" _ $j(bedNo, 10) _ "||" _ patNo
					s collectData(patIndex, mDsp) = ""
				}	
			}
		}
	}
	q ""
}

}
