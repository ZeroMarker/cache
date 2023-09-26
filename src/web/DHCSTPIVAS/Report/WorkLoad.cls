/// Description:配液工作量统计
Class web.DHCSTPIVAS.Report.WorkLoad Extends %RegisteredObject
{

/// Input: calcType - tabPerson: 按人, tabWard: 按病区, tabCat: 按配液大类
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Report.WorkLoad","WorkStat","2022-04-19","2022-04-19","186","tabPerson","","","A")
Query WorkStat(startDate, endDate, pivaLoc, calcType = "", StartTime = "", EndTime = "", sysType = "") As websys.Query(ROWSPEC = "typeDesc,stateDesc,stateIndex:%Integer,workCnt:%Float,calcDesc") [ SqlProc ]
{
}

ClassMethod WorkStatExecute(ByRef qHandle As %Binary, startDate, endDate, pivaLoc, calcType = "", StartTime = "", EndTime = "", sysType = "") As %Status
{
	//tro  
	//s ^PHATMP("MYQ",$this,"WorkStat")=$lb(startDate, endDate, pivaLoc, calcType, StartTime, EndTime,sysType )
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:(startDate="")||(endDate="")||(pivaLoc="") $$$OK
	s startDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(startDate)
	s endDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(endDate)
	s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
	s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
	s calcDesc=$case(calcType,"tabPerson":"人员","tabWard":"病区","tabCat":"类别",:"未知")

	/* 配伍审核 */
	s calcuDate=""
	f calcuDate=endDate:-1:startDate d
    .s phaOrd=""
    .f  s phaOrd=$o(^DHCPHORDM(0,"DateLoc",calcuDate,pivaLoc,phaOrd)) q:phaOrd=""  d
    ..s appType=$p(^DHCPHORDM(phaOrd),"^",9)
    ..q:appType'="PIVAS"
    ..q:$p(^DHCPHORDM(phaOrd),"^",2)="D"
    ..s phaOrdTime=$p(^DHCPHORDM(phaOrd),"^",4)
    ..q:(calcuDate=startDate)&&(StartTime'="")&&(phaOrdTime<StartTime)
    ..q:(calcuDate=endDate)&&(EndTime'="")&&(phaOrdTime>EndTime)
    ..s phaOrdItm=$o(^DHCPHORDM(phaOrd,"I",""),-1)
    ..q:phaOrdItm=""
    ..s phNote=$p(^DHCPHORDM(phaOrd),"^",6)
    ..s phaOrdResultStr=##class(web.DHCSTPIVAS.Common).GetPhaOrdResult(phaOrd)
    ..s phaOrdResult=$p(phaOrdResultStr,"^",1)
    ..q:phaOrdResult=""
    ..s passStat=""
    ..i phaOrdResult="SHTG" s passStat="审核通过"
    ..e  i phaOrdResult="SHJJ" s passStat="审核拒绝"
	..q:passStat=""
    ..s mOeori=$p(^DHCPHORDM(phaOrd,"I",phaOrdItm),"^",2)
    ..s admType = $p(^PAADM($p(^OEORD(+mOeori), "^", 1)), "^", 2)
    ..q:(sysType = "I")&&(admType'="I")
    ..q:(sysType = "O")&&(admType="I")
    ..q:(calcType="tabWard")&&(admType'="I")
    ..q:$d(WorkStatOeoriArr(mOeori))
    ..s WorkStatOeoriArr(mOeori)=""
    ..
	..i calcType="tabPerson" d
	...s typeDR=$p(^DHCPHORDM(phaOrd),"^",1)
	...s typeDesc=$p(^SSU("SSUSR",typeDR),"^",2)
	..e  i calcType="tabWard" d
	...
	...s firstDsp=$o(^DHCOEDISQTY(0,"OEORI",mOeori,""))
	...q:firstDsp=""
	...s typeDR=$p(^DHCOEDISQTY(firstDsp),"^",22)
	...s typeDesc=$p(^CTLOC(typeDR),"^",2)
	..e  i calcType="tabCat" d
	...s pivaCatStr=##class(web.DHCSTPIVAS.Common).GetOrdPivaCat(mOeori)
	...s typeDR=$p(pivaCatStr,"^",1)
	...s typeDesc=$p(pivaCatStr,"^",2)
	..i '$d(WorkStatData(typeDR,passStat)) d
	...s WorkStatData(typeDR,passStat)=$lb(1,typeDesc)
	..e  d
	...s $list(WorkStatData(typeDR,passStat),1)=$list(WorkStatData(typeDR,passStat),1)+1
	
	/* 配液流程-User.PIVAOrdGrpState */
	f calcuDate=startDate:1:endDate d
	.s psUserId=""
	.f  s psUserId=$o(^PIVA(0,"SDUS",calcuDate,psUserId)) q:psUserId=""  d
	..s psId=""
	..f  s psId=$o(^PIVA(0,"SDUS",calcuDate,psUserId,psId)) q:psId=""  d
	...s psData=$g(^PIVAS(psId))
	...s psDesc=$p(psData,"^",2)
	...s psNumber=$p(psData,"^",1)
	...q:psNumber=""
	...s psType = $p(psData,"^",9)
	...q:(sysType = "I")&&(psType'="I")
    ...q:(sysType = "O")&&(psType="I")
	...q:(calcType="tabWard")&&(psType'="I")
	...s pogId=""
	...f  s pogId=$o(^PIVA(0,"SDUS",calcuDate,psUserId,psId,pogId)) q:pogId=""  d
	....q:pivaLoc'=$p($g(^PIVA(pogId)),"^",7)
	....s pogState=$o(^PIVA(0,"SDUS",calcuDate,psUserId,psId,pogId,""))
	....s pogsTime=$p(^PIVA(pogId,"S",pogState),"^",5)
    ....q:(calcuDate=startDate)&&(StartTime'="")&&(pogsTime<StartTime)
    ....q:(calcuDate=endDate)&&(EndTime'="")&&(pogsTime>EndTime)
	....s mDsp=$p($g(^PIVA(pogId)),"^",1)
	....i calcType="tabPerson" d
	.....s typeDR=psUserId
	.....s typeDesc=$p(^SSU("SSUSR",typeDR),"^",2)
	....e  i calcType="tabWard" d
	.....s typeDR=$p(^DHCOEDISQTY(mDsp),"^",22)
	.....s typeDesc=$p(^CTLOC(typeDR),"^",2)
	....e  i calcType="tabCat" d
	.....s mOeori=$p(^DHCOEDISQTY(mDsp),"^",1)
	.....s pivaCatStr=##class(web.DHCSTPIVAS.Common).GetOrdPivaCat(mOeori)
	.....s typeDR=$p(pivaCatStr,"^",1)
	.....s typeDesc=$p(pivaCatStr,"^",2)
	....i '$d(WorkStatData(typeDR,psNumber)) d
	.....s WorkStatData(typeDR,psNumber)=$lb(1,typeDesc)
	....e  d
	.....s $list(WorkStatData(typeDR,psNumber),1)=$list(WorkStatData(typeDR,psNumber),1)+1
	..../* 难度系数 */
	....i psNumber=60 d
	.....s pogState=$o(^PIVA(0,"SDUS",calcuDate,psUserId,psId,pogId,""))
	.....q:pogState=""
	.....s coef=..CalcuPSCoef(pogId_"||"_pogState)
	.....
	.....i '$d(WorkStatData(typeDR,61)) d
	......s WorkStatData(typeDR,61)=$lb(coef,typeDesc)
	.....e  d
	......s $list(WorkStatData(typeDR,61),1)=$list(WorkStatData(typeDR,61),1)+coef

	/* 配液拒绝 - todo, 目前没索引*/
	
	/* 退药 */
	k mOeoreArr
	f calcuDate=startDate:1:endDate q:(sysType="O")  d
	.s phar=0
	.f  s phar=$o(^PHARET(0,"RECLOC",pivaLoc,calcuDate,phar)) q:phar=""  d
	..s retTime=$p(^PHARET(phar),"^",2) 
    ..q:(calcuDate=startDate)&&(StartTime'="")&&(retTime<StartTime)
    ..q:(calcuDate=endDate)&&(EndTime'="")&&(retTime>EndTime)
	..s pharItm=0
	..f  s pharItm=$o(^PHARET(phar,"I",pharItm)) q:pharItm=""  d
	...s dsp=$p(^PHARET(phar,"I",pharItm),"^",13)
	...s oeore=$p(^DHCOEDISQTY(dsp),"^",3)
	...s mOeore=##class(web.DHCSTPIVAS.Common).GetMainOeore(oeore)
	...q:$d(mOeoreArr(mOeore))
	...s mOeoreArr(mOeore)=""
	...i calcType="tabPerson" d
	....s typeDR=$p(^PHARET(phar),"^",3)
	....s typeDesc=$p(^SSU("SSUSR",typeDR),"^",2)
	...e  i calcType="tabWard" d
	....s typeDR=$p(^DHCOEDISQTY(dsp),"^",22)
	....s typeDesc=$p(^CTLOC(typeDR),"^",2)
	...e  i calcType="tabCat" d
	....s pivaCatStr=##class(web.DHCSTPIVAS.Common).GetOrdPivaCat($p(mOeore,"||",1,2))
	....s typeDR=$p(pivaCatStr,"^",1)
	....s typeDesc=$p(pivaCatStr,"^",2)
	...i '$d(WorkStatData(typeDR,"退药")) d
	....s WorkStatData(typeDR,"退药")=$lb(1,typeDesc)
	...e  d
	....s $list(WorkStatData(typeDR,"退药"),1)=$list(WorkStatData(typeDR,"退药"),1)+1
	
	/* 门诊退药 */
	k mOeoreArr
	s phl=$o(^DHCPHLOCi("LOC",pivaLoc,""),-1)
	i ((phl'="")&&(calcType'="tabWard")) d
	.f calcuDate=startDate:1:endDate q:(sysType="I")  d
	..s phret=""
	..f  s phret=$o(^DHCPHRETi(calcuDate,phl,phret)) q:phret=""  d
	...s retTime=$p(^DHCPHRET(phret),"^",10) 
    ...q:(calcuDate=startDate)&&(StartTime'="")&&(retTime<StartTime)
    ...q:(calcuDate=endDate)&&(EndTime'="")&&(retTime>EndTime)
	...s phretItm=""
	...f  s phretItm=$o(^DHCPHRTI(phret,"RTI",phretItm)) q:phretItm=""  d
	....s phdclbDr=$p(^DHCPHRTI(phret,"RTI",phretItm),"^",11)
	....s dspbatch=$p($g(^DHCPHDI(+phdclbDr,"PHDI",+$p(phdclbDr,"||",2),"INCLB",+$p(phdclbDr,"||",3))),"^",9)
	....s dsp=+dspbatch
	....q:(dsp="")
	....s oeore=$p(^DHCOEDISQTY(dsp),"^",3)
	....s mOeore=##class(web.DHCSTPIVAS.Common).GetMainOeore(oeore)
	....q:$d(mOeoreArr(mOeore))
	....s mOeoreArr(mOeore)=""
	....i calcType="tabPerson" d
	.....s phpDR=+$p(^DHCPHRET(phret),"^",8)
	.....s typeDR=$p($g(^DHCPHPER(phpDR)),"^",5)
	.....s typeDesc=$p(^SSU("SSUSR",typeDR),"^",2)
	....e  i calcType="tabWard" d
	.....s typeDR=$p(^DHCOEDISQTY(dsp),"^",22)
	.....s typeDesc=$p(^CTLOC(typeDR),"^",2)
	....e  i calcType="tabCat" d
	.....s pivaCatStr=##class(web.DHCSTPIVAS.Common).GetOrdPivaCat($p(mOeore,"||",1,2))
	.....s typeDR=$p(pivaCatStr,"^",1)
	.....s typeDesc=$p(pivaCatStr,"^",2)
	....i '$d(WorkStatData(typeDR,"退药")) d
	.....s WorkStatData(typeDR,"退药")=$lb(1,typeDesc)
	....e  d
	.....s $list(WorkStatData(typeDR,"退药"),1)=$list(WorkStatData(typeDR,"退药"),1)+1


	s preColStr=",审核通过,审核通过^,审核拒绝,审核拒绝^,61,难度系数"
	s sufColStr=",退药,退药"
	s psStateStr=##class(web.DHCSTPIVAS.Common).PivasLocStateList(pivaLoc)
	s colStr=preColStr_"^"_psStateStr_"^"_sufColStr
	s colLen=$l(colStr,"^")
	s colI=0
	f colI=1:1:colLen d
	.s stateStr=$p(colStr,"^",colI)
	.q:stateStr=""
	.s stateCode=$p(stateStr,",",2)
	.s stateDesc=$p(stateStr,",",3)
	.i $l(stateDesc)>2 s stateDesc=$e(stateDesc,1,2)_$c(13,10)_$e(stateDesc,3,4)
	.s typeDR=""
	.f  s typeDR=$o(WorkStatData(typeDR)) q:typeDR=""  d
	..s typeDesc=""
	..i calcType="tabPerson" d
	...s typeDesc=$p($g(^SSU("SSUSR",+typeDR)),"^",2)
	..e  i calcType="tabWard" d
	...s typeDesc=$p($g(^CTLOC(+typeDR)),"^",2)
	..e  i calcType="tabCat" d
	...s typeDesc=$p($g(^POLI(+typeDR)),"^",1)
	..
	..s workCnt=+$lg($g(WorkStatData(typeDR,stateCode)),1)
	..d outputRow
	Quit $$$OK
outputRow  
	s Data=$lb(typeDesc,stateDesc,colI,workCnt,calcDesc)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// Description:计算流程内的配液难度系数
/// w ##class(web.DHCSTPIVAS.Report.WorkLoad).CalcuPSCoef("84||7")
ClassMethod CalcuPSCoef(PogStateId)
{
	//s ^PHATMP("MYQ",$this,"CalcuPSCoef",PogStateId) = ""
	s pogCoef=0
	s pogId=+PogStateId
	s pogState=$p(PogStateId,"||",2)
	s POGS=$g(^PIVA(pogId,"S",pogState))
	s scanNo=$p(POGS,"^",10)
	s locId=$p(^PIVA(pogId),"^",7)
	s pogItm=""
	f  s pogItm=$o(^PIVA(pogId,"I",pogItm)) q:pogItm=""  d
	.q:+pogItm=0
	.s dspId=$p(^PIVA(pogId,"I",pogItm),"^",1)
	.s oeori=$p(^DHCOEDISQTY(dspId),"^",1)
	.q:oeori=""
	.s arcim=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),1)),"^",2)
 	.s inci=$O(^INCI(0,"ARCIM_DR",+arcim,""))
 	.q:inci=""
	.s inciCh=$o(^INCI("IL_LOC",locId,inci,""))
	.q:inciCh=""
	.s incil=inci_"||"_inciCh
	.s dhcIncil=$o(^DHCINCIL(0,"INCIL",incil,""))
	.q:dhcIncil=""
	.s coef=$p($g(^DHCINCIL(dhcIncil)),"^",30)
	.s DHCINCILPIVAS=$g(^DHCINCIL(dhcIncil,"PIVAS"))
	.s conCoef=$p(DHCINCILPIVAS,"^",5)
	.s sameCoef=$p(DHCINCILPIVAS,"^",6)
	.s qty=$p(^DHCOEDISQTY(dspId),"^",5)
	.s intQty = +$p(qty, ".", 1)
	.i (qty > intQty) d
	..s qty = intQty + 1
	.i (scanNo=1)||(+scanNo=0) d
	..s psCoef=coef+((qty-1)*sameCoef)
	.e  d
	..s psCoef=conCoef+((qty-1)*sameCoef)
	.s pogCoef=pogCoef+psCoef
	q pogCoef
}

}
