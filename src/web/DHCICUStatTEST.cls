Import SQLUser

Class web.DHCICUStatTEST Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator：      	ypz
/// CreatDate：    	2011-08-30
/// Description： 	质量检查:查整点未记录数据，查超最高、最低值。
/// Table：        	DHC_ICU_Arrange,PA_Adm,DHC_ICU_Order
/// Input：        	startDate开始日期，endDate结束日期，icuaId重症监护安排ID,EpisodeID就诊号;ctlocId:科室ID;
/// 				
/// Output：        病区名,床位名,登记号,病人姓名,日期,时间,项目,状态,icuaId重症监护安排ID
/// Return：       	返回0正常，否则提示出错信息。(相同状态不插入)
Query CheckData(startDate, endDate, icuaId, EpisodeID = "", ctlocId = "") As %Query(ROWSPEC = "tWardDesc,tBedCode,tRegNo,tPatName,tDate,tTime,tCheckDesc,tCheckStatus,icuaId") [ SqlProc ]
{
}

ClassMethod CheckDataExecute(ByRef qHandle As %Binary, startDate, endDate, icuaId, EpisodeID = "", ctlocId = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1	

	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s icuaIdList=##class(web.DHCICUCom).FindIcuaIdList(icuaId, EpisodeID,ctlocId)
	
	s ancoCode=0,maxMinAncoIdList=""
	f  s ancoCode=$o(^DHCICUC("RecordItem",0,"Code",ancoCode)) q:ancoCode=""  d
		.s ancoId=$o(^DHCICUC("RecordItem",0,"Code",ancoCode,""))
		.q:ancoId=""
		.q:ancoId<5000
		.q:+$p($g(^DHCICUC("RecordItem",ancoId)),"^",19)=0
		.q:$p($g(^DHCICUC("RecordItem",ancoId)),"^",20)=""
		.s maxMinAncoIdList(ancoId,"Max")=$p($g(^DHCICUC("RecordItem",ancoId)),"^",19)
		.s maxMinAncoIdList(ancoId,"Min")=$p($g(^DHCICUC("RecordItem",ancoId)),"^",20)
	
	f curDate=startDate:1:endDate d
	    .f i=1:1:$l(icuaIdList,"^") d
	        ..s icuaId=$p(icuaIdList,"^",i)
	        ..q:icuaId=""
	        ..q:$p(^DHCICUArrange(icuaId),"^",18)="D"
	        ..s EpisodeID=$p(^DHCICUArrange(icuaId),"^",1)
	        ..q:EpisodeID=""
	        ..q:curDate<$p($g(^PAADM(EpisodeID)),"^",6)
	        ..//按病区查时，按转入时间；按人查时，按监护开始时间
	        ..i ctlocId'="" d
	        	...s wardInDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
	        	...s wardInDateTime=+wardInDateTime+($p(wardInDateTime,"^",2)/100000)
	        ..e  s wardInDateTime=$p(^DHCICUArrange(icuaId),"^",6)+($p(^DHCICUArrange(icuaId),"^",8)/100000)
	        ..//w wardInDateTime,1
	        ..s icuBedId=$p(^DHCICUArrange(icuaId),"^",4)
	        ..s bedSub=$p(icuBedId,"||",2)
			..s tBedCode=$p($g(^PAWARD(+icuBedId,"BED",+bedSub)),"^",1)
			..s tWardDesc=$P($g(^PAWARD(+icuBedId)),"^",2)
			..i $l(tWardDesc,"-")>1 s tWardDesc=$p(tWardDesc,"-",2)
			..s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
			..s tRegNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
			..s tPatName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
			..s tDate=$zd(curDate,3)
	        ..f j=0:1:23 d
	        	...s icuoSttTime=j*3600
	        	...q:(curDate=+$h)&(icuoSttTime>$p($h,",",2))
	        	...s checkDateTime=curDate+(icuoSttTime/100000)
	        	...q:checkDateTime<wardInDateTime
	        	...i icuoSttTime=0 s icuoSttTime=1
	        	...s tTime=$zt(icuoSttTime,2)
	            ...s tIcuoId="",curAncoIdList=""
	            ...f  s tIcuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,tIcuoId)) q:tIcuoId=""  d
	                ....q:'$d(^DHCICUOrder(tIcuoId))
	                ....q:"ICD"[$p(^DHCICUOrder(tIcuoId),"^",25)
	                ....q:"I"=$p(^DHCICUOrder(tIcuoId),"^",29)
	                ....s tAncoId=$p(^DHCICUOrder(tIcuoId),"^",2)
	                ....q:(tAncoId="")
	                ....i curAncoIdList'="" s curAncoIdList=curAncoIdList_"^"
	                ....s curAncoIdList=curAncoIdList_tAncoId
	                ....//w curAncoIdList," list/"_icuoSttTime,!
	                ....//s tIcuoUpdateDate=$p(^DHCICUOrder(tIcuoId),"^",21)
	                ....//s tIcuoUpdateTime=$p(^DHCICUOrder(tIcuoId),"^",22)
	                ....//s tTime=$p(^DHCICUOrder(tIcuoId),"^",6)
	                ....
	                ....//q:(needAncoId'="")&(("^"_needAncoId_"^")'[("^"_tAancoId_"^"))
	                ....
	                ....//s tAncoDesc=$p($g(^DHCICUC("RecordItem",tAncoId)),"^",2)_"^"
	                ....//s tUserDesc=$p($g(^SSU("SSUSR",$p(^DHCICUOrder(tIcuoId),"^",4))),"^",2)	//ICUO_User_Dr
	                ....//s tDate=$zd(tDate,3)_"^"					//ICUO_StartDate
	                ....//s tTime=$zt(tTime)_"^"
	                ....//s tIcuoUpdateDate=$zd(tIcuoUpdateDate,3)_"^"
	                ....//s tIcuoUpdateTime=$zt(tIcuoUpdateTime)_"^"
	                ....//s tIcuoValue=$p(^DHCICUOrder(tIcuoId),"^",11)	//ICUO_Qty
	                ....//s tIcuoValue=tIcuoValue_" "_$p(^DHCICUOrder(tIcuoId),"^",10)_"^"	//ICUO_Note num:10
	            ...k checkList
	            ...s checkNum=0
	            ...f  s checkNum=$o(^DHCCLSet("ICU","Check",checkNum)) q:checkNum=""  d
	            	....s checkStr=^DHCCLSet("ICU","Check",checkNum)
	            	....s timePointStr=$p(checkStr,"^",1)
	            	....q:(timePointStr'="")&(("|"_timePointStr_"|")'[("|"_j_"|"))
	            	....f k=2:1:$l(checkStr,"^") d
	            		.....s matchNum=0
	            		.....s ancoStr=$p(checkStr,"^",k)
	            		.....s checkDesc=$p(ancoStr,"|",1)
	            		.....q:checkDesc=""
	            		.....q:$l(ancoStr,"|")<2
	            		.....f l=2:1:$l(ancoStr,"|") d
	            			......s ancoId=$p(ancoStr,"|",l)
	            			......q:ancoId=""
	            			......//w "/"_curAncoIdList_"["_ancoId_"/",!
	            			......i ("^"_curAncoIdList_"^")[("^"_ancoId_"^") s matchNum=matchNum+1
	            		.....s checkList(checkDesc)=$fn(matchNum/($l(ancoStr,"|")-1),"",2)+$g(checkList(checkDesc))
	            		.....//i matchNum>0 w checkDesc,"/",checkList(checkDesc)
	            ...s tCheckDesc=""
	            ...f  s tCheckDesc=$o(checkList(tCheckDesc)) q:tCheckDesc=""  d
	            	....q:checkList(tCheckDesc)'<1
	            	....s tCheckStatus="无数据"
	            	....i checkList(tCheckDesc)<1,checkList(tCheckDesc)>0 s tCheckStatus="部分数据"
	            	....d OutputRow
	         ..s icuoSttTime=""
	         ..f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
	         	...s tIcuoId="",curAncoIdList=""
	         	...s tTime=$zt(icuoSttTime,2)
	            ...f  s tIcuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,tIcuoId)) q:tIcuoId=""  d
	                ....q:'$d(^DHCICUOrder(tIcuoId))
	                ....s tAncoId=$p(^DHCICUOrder(tIcuoId),"^",2)
	                ....q:(tAncoId="")
	                ....q:'$d(maxMinAncoIdList(tAncoId))
	                ....q:"ICD"[$p(^DHCICUOrder(tIcuoId),"^",25)
	                ....s icuoQty=$p(^DHCICUOrder(tIcuoId),"^",11)
	                ....s tCheckStatus=""
	                ....i icuoQty>$g(maxMinAncoIdList(tAncoId,"Max")) s tCheckStatus="超最高值"
	                ....i icuoQty<$g(maxMinAncoIdList(tAncoId,"Min")) s tCheckStatus="超最低值"
	                ....q:tCheckStatus=""
	                ....s tCheckDesc=$p($g(^DHCICUC("RecordItem",tAncoId)),"^",2)
	                ....d OutputRow

		Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(tWardDesc,tBedCode,tRegNo,tPatName,tDate,tTime,tCheckDesc,tCheckStatus,icuaId) 
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CheckDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CheckDataExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {	
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod CheckDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CheckDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      	ypz
/// CreatDate：    	2013-07-22
/// Description： 	取插管的数据。
/// Table：        	DHC_ICU_Arrange,DHC_ICU_Order
/// Input：        	startDate开始日期，endDate结束日期，icuaId重症监护安排ID,EpisodeID就诊号;
/// 				catheterCode代码:"Ventilator"为气管插管,"CVP"为中心静脉置管,"Urethra"为尿管置管
/// Output：        
/// Return：       	分为两级，第一级以"^"分割，按天返回一组数据，
/// 					第二级依次以$c(3)为分割：标识ID,(未用),插管日,拔管日,管类型,插管人员,置管科室,置管腔数
/// w ##class(web.DHCICUStat).GetCatheter($h-10,$h,22,"","Ventilator")
ClassMethod GetCatheter(startDate, endDate, icuaId, EpisodeID = "", catheterCode = "") As %String
{
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	q:endDate<startDate -1
	s startPos=3
	
	i icuaId'="" s icuaIdList(icuaId)=""
	e  d
		.f  s icuaId=$o(^DHCICUArrange(0,"Adm",EpisodeID,icuaId)) q:(icuaId="")  d
			..q:'$d(^DHCICUArrange(icuaId))
			..s icuaStatus=$p($g(^DHCICUArrange(icuaId)),"^",18)
			..q:icuaStatus=""
			..q:"D"[icuaStatus //停止的
			..q:$p(^DHCICUArrange(icuaId),"^",6)>endDate
			..q:($p(^DHCICUArrange(icuaId),"^",7)'="")&($p(^DHCICUArrange(icuaId),"^",7)<startDate)
			..s icuaIdList(icuaId)=""
	s catheterIdStr=$g(^DHCICUC("Stat",catheterCode))
	
	k statList
	s retStr=""
	s icuaId=""
	f  s icuaId=$o(icuaIdList(icuaId)) q:icuaId=""  d
		.//w $p($g(^DHCICUArrange(icuaId)),"^",1),!   //EpisodeID
		.s icupId=$o(^DHCICUPara(0,"ICUA",icuaId,""))
		.q:icupId=""
		.//w $p(^DHCICUArrange(icuaId),"^"),!
		.s icupiSub=10000
		.f  s icupiSub=$o(^DHCICUPara(icupId,"I",icupiSub)) q:icupiSub=""  d //子项到主项的映射
			..s icupiStr=^DHCICUPara(icupId,"I",icupiSub)
			..s ancoId=$p(icupiStr,"^",4)
			..q:("^"_$p(catheterIdStr,"^",startPos,startPos+6)_"^")'[ancoId
			..s mainIcupiId=$p(icupiStr,"^",19)
			..q:mainIcupiId=""
			..s mainIcupiSub=$p(mainIcupiId,"||",2)
			..s mainAncoId=$p($g(^DHCICUPara(icupId,"I",mainIcupiSub)),"^",4)
			..q:(";"_$p(catheterIdStr,"^",2)_";")'[mainAncoId
			..s icupiSubList(icupId_"||"_icupiSub)=mainIcupiId
			..//w "find:"_icupiSub_"/"_mainIcupiId,!
		.s startIcuoId=""
		.f curDate=startDate:1:endDate d
			..s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,""))
			..q:icuoSttTime=""
			..s startIcuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,""))
			..q:startIcuoId=""
			..s endIcuoId=""
			..s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,""),-1)
			..s endIcuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,""),-1)
			..q:endIcuoId=""
			..//w startIcuoId_"/"_endIcuoId,!
			..s dataStr=""
			..s $p(dataStr,"^",$l(catheterIdStr,"^"))=""
			..f i=startPos:1:$l(catheterIdStr,"^") d
				...s ancoId=$p(catheterIdStr,"^",i)
				...q:ancoId=""
				...s icuoId=startIcuoId-1
				...f  s icuoId=$o(^DHCICUOrder(0,"CommOrd",ancoId,icuaId,icuoId)) q:(icuoId="")!(icuoId>endIcuoId)  d
					....q:'$d(^DHCICUOrder(icuoId))
					....q:curDate'=$p(^DHCICUOrder(icuoId),"^",5)
					....q:"ICD"[$p(^DHCICUOrder(icuoId),"^",25)
					....s icuoIcupiDr=$p(^DHCICUOrder(icuoId),"^",38)
					....q:icuoIcupiDr=""
					....//w icuoIcupiDr,!
					....q:'$d(icupiSubList(icuoIcupiDr))
					....//w "set:"_i_"/"_ icuoId_"/"_icuoIcupiDr_"/"_$p(^DHCICUOrder(icuoId),"^",10)_"/"_dataStr,!
					....s $p(dataStr,"^")=icupiSubList(icuoIcupiDr)
					....s $p(dataStr,"^",i)=$p(^DHCICUOrder(icuoId),"^",10)
					....q:$p(dataStr,"^",3)=""
			..//w $zd(curDate)_"    "_dataStr,!
			..q:$p(dataStr,"^")=""
			..q:$p(dataStr,"^",3)=""
			..s icupiDate=$p(dataStr,"^")_":"_$p(dataStr,"^",3)
			..s $p(dataStr,"^")=icupiDate
			..s dataStr=$tr(dataStr,"^",$c(3))
			..i '$d(statList(icupiDate)) s statList(icupiDate)=dataStr q
 			..f i=2:1:$l(dataStr,$c(3)) d
 				...q:$p(dataStr,$c(3),i)=""
 				...s $p(statList(icupiDate),$c(3),i)=$p(dataStr,$c(3),i)
	s icupiDate=""
	f  s icupiDate=$o(statList(icupiDate)) q:icupiDate=""  d
		.i retStr'="" s retStr=retStr_"^"
		.s retStr=retStr_statList(icupiDate)
	q retStr
}

// w ##class(web.DHCICUStat).GetArcimByFuzzyDesc()

ClassMethod GetArcimByFuzzyDesc(arcimDesc, needOrcatId = "")
{
	s arcimId=0,count=0
	f  s arcimId=$o(^ARCIM(arcimId)) q:arcimId=""  d
		.//w $p($g(^ARCIM(arcimId,1,1)),"^",2)
		.q:$p($g(^ARCIM(arcimId,1,1)),"^",2)'[arcimDesc
		.s arcicId=$p($g(^ARCIM(arcimId,1,1)),"^",10)
		.q:arcicId=""
		.s orcatId=$p($g(^ARC("IC",arcicId)),"^",8)
		.q:orcatId=""
		.//q:(needOrcatId'="")&(needOrcatId'=orcatId)
		.s tmpList(orcatId_","_arcicId_","_arcimId)=orcatId_$p(^OEC("ORCAT",orcatId),"^",2)_","_"/"_arcicId_","_$p($g(^ARC("IC",arcicId)),"^",2)_"/"_arcimId_":"_$p($g(^ARCIM(arcimId,1,1)),"^",1,2)
	s arcimStr=""
	f  s arcimStr=$o(tmpList(arcimStr)) q:arcimStr=""  d
	.s count=count+1
		.i count[500 b
		.w tmpList(arcimStr),!
	q count
}

/// creater: mfc 20150106
/// input:	userId操作用户,icucriId常用医嘱ID,icuoId数据Order表ID,ExactTimeList班次时间(^分割),InExCathDTList置管拔管日期时间(^分割)
/// output:	获取操作用户的某个项目操作持续小时
/// Desc：	不是小时的交接班项目(班次记录一次项目)操作持续小时
ClassMethod getUserCathHCout(icuaId, userId, icucriId, icuoId, ExactTimeList, InExCathDTList = "")
{
	//w ##class(web.DHCICUStat).getUserCathHCout(1475,6904,"37318057","7:30^19:30","63530^13200^^")
	q:icuaId=""
	q:userId=""
	q:icucriId=""
	q:icuoId=""
	s retstr=""
	s ^tmpCriIdInExCathDT(icuaId,icucriId,icuoId)=InExCathDTList		
	s userRowID="",proCathIf="",countV=0
	i $g(^tmpProCathDate(icuaId,icucriId))'="" s proCathIf=$g(^tmpProCathDate(icuaId,icucriId))
	s icuoRowId="",proCathDate=""
	f  s icuoRowId=$o(^tmpProCathDate(icuaId,icucriId,icuoRowId)) q:(icuoRowId="")  d
	.i $g(^tmpProCathDate(icuaId,icucriId,icuoRowId))'="" d
	..i (proCathDate'="")&&(($g(^tmpProCathDate(icuaId,icucriId,icuoRowId))-proCathDate)>1) d
	...s ^tmpProCathDate(icuaId,icucriId)=""	
	..s proCathDate=$g(^tmpProCathDate(icuaId,icucriId,icuoRowId))
	
	s icuoRowId="",proCathDate=0
	f  s icuoRowId=$o(^tmpCriIdInExCathDT(icuaId,icucriId,icuoRowId)) q:(icuoRowId="")  d
	.;q:'$d(^tmpCriIdInExCathDT(userRowID,criRowID,icuoRowId))	
	.s inCathDate=$p($g(^tmpCriIdInExCathDT(icuaId,icucriId,icuoRowId)),"^",1)
	.s inCathTime=$p($g(^tmpCriIdInExCathDT(icuaId,icucriId,icuoRowId)),"^",2)
	.s exCathDate=$p($g(^tmpCriIdInExCathDT(icuaId,icucriId,icuoRowId)),"^",3)
	.s exCathTime=$p($g(^tmpCriIdInExCathDT(icuaId,icucriId,icuoRowId)),"^",4)
	.s startDate=$p($g(^tmpCriIdInExCathDT(icuaId,icucriId,icuoRowId)),"^",3)
	.s startTime=$p($g(^tmpCriIdInExCathDT(icuaId,icucriId,icuoRowId)),"^",4)
	.s oneShiftTime="",twoShiftTime="",threeShiftTime=""
	.i $p(ExactTimeList,"^",1)'="" s oneShiftTime=##class(web.DHCClinicCom).ConvertToTimeH($p(ExactTimeList,"^",1))
	.i $p(ExactTimeList,"^",2)'="" s twoShiftTime=##class(web.DHCClinicCom).ConvertToTimeH($p(ExactTimeList,"^",2))
	.i $p(ExactTimeList,"^",3)'="" s threeShiftTime=##class(web.DHCClinicCom).ConvertToTimeH($p(ExactTimeList,"^",3))
	.i userId=4918 w userId_"/"_icucriId_"/"_icuoId_"/"_oneShiftTime_"/"_twoShiftTime_"/"_threeShiftTime,!
	.i (threeShiftTime="") d //两班
	..i (proCathIf="")&&(exCathDate="") d //第一次和拔管为空，首次置管
	...i (inCathTime<oneShiftTime) s countV=(oneShiftTime-inCathTime)/3600
	...i (inCathTime>=twoShiftTime) s countV=(inCathTime-twoShiftTime)/3600
	...i (inCathTime>=oneShiftTime)&&(inCathTime<twoShiftTime) s countV=(inCathTime-oneShiftTime)/3600
	..e  i (proCathIf'="")&&(exCathDate="") d //中间历次插管
	...i (inCathTime<oneShiftTime) s countV=((86400-twoShiftTime)+oneShiftTime)/3600
	...i (inCathTime>=twoShiftTime) s countV=((86400-twoShiftTime)+oneShiftTime)/3600
	...i (inCathTime>=oneShiftTime)&&(inCathTime<twoShiftTime) s countV=(twoShiftTime-oneShiftTime)/3600
	..e  i (proCathIf'="")&&(exCathDate'="") d //最后拔管
	...i (inCathTime<oneShiftTime) s countV=((86400-twoShiftTime)+exCathTime)/3600
	...i (inCathTime>=twoShiftTime) s countV=(exCathTime-twoShiftTime)/3600
	...i (inCathTime>=oneShiftTime)&&(inCathTime<twoShiftTime) s countV=(inCathTime-oneShiftTime)/3600
	...s ^tmpProCathDate(icuaId,icucriId,icuoId)="",^tmpProCathDate(icuaId,icucriId)=""
	...s countV=$NORMALIZE(countV,1)
	...;i retstr="" s retstr=$p($g(^DHCICUOrder(icuoId)),"^",4)_"^"_countV
	.i $g(^tmpProCathDate(icuaId,icucriId,icuoId))="" s ^tmpProCathDate(icuaId,icucriId,icuoId)=startDate,^tmpProCathDate(icuaId,icucriId)=startDate
	.s proCathDate=inCathDate
	q $NORMALIZE(countV,1)
}

/// creater: mfc 20150106
/// input:	icuaId安排ID,icucriId常用医嘱ID,inCathIcucriId置管ID,exCathIcucriId拔管ID
/// output:	置管、拔管/操作时间日期时间
/// Desc：	通过主项获取分项目的置管、拔管时间，"^"分割的多条结果
ClassMethod getInOutCathDateTime(icuaId, icucriId, fromDate = "", fromTime = "", toDate = "", toTime = "", inCathIcucriId = "", exCathIcucriId = "")
{
	q:icuaId=""
	q:icucriId=""
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s fromTime=##class(web.DHCClinicCom).ConvertToTimeH(fromTime)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	s toTime=##class(web.DHCClinicCom).ConvertToTimeH(toTime)
	s inCathDate="",inCathTime="",exCathDate="",exCathTime="",startDate="",startTime=""
	s icupId=$o(^DHCICUPara(0,"ICUA",icuaId,""))
	q:icupId="" ""
	s icupiSub=10000,isQuit=0
	s mainIcupiId=0,inCathIcupiId="",exCathIcupiId=""
	f  s icupiSub=$o(^DHCICUPara(icupId,"I",icupiSub)) q:(icupiSub="")!(isQuit)  d //子项到主项的映射
		.s icupiStr=^DHCICUPara(icupId,"I",icupiSub)
		.i $p(icupiStr,"^",4)[icucriId s mainIcupiId=icupId_"||"_icupiSub
		.q:mainIcupiId=""
		.i ($p(icupiStr,"^",19)=mainIcupiId)&($p(icupiStr,"^",4)=inCathIcucriId) s inCathIcupiId=icupId_"||"_icupiSub
		.i ($p(icupiStr,"^",19)=mainIcupiId)&($p(icupiStr,"^",4)=exCathIcucriId) s exCathIcupiId=icupId_"||"_icupiSub
		.i inCathIcupiId'="",exCathIcupiId'="" s isQuit=1
	;i (icuaId=4766)&&(icucriId=6904) w inCathIcupiId_"/"_exCathIcupiId_"/"_fromDate_"/"_fromTime_"/"_toDate_"/"_toTime,!
	s duraDay=0,duraHour=0,duraMin=0,times=0
	s ifNewDuration=1,firstDate="",firstTime="",preDate="",preTime="",lastDate="",lastTime=""
	s date=fromDate-1
	f  s date=$o(^DHCICUOrder(0,"RecordItem",inCathIcucriId,date)) q:(date="")!(date>toDate)  d
		.s time=fromTime-1
		.f  s time=$o(^DHCICUOrder(0,"RecordItem",inCathIcucriId,date,icuaId,time)) q:(time="")!(time>toTime)  d			
			..s icuoId=""
			..f  s icuoId=$o(^DHCICUOrder(0,"RecordItem",inCathIcucriId,date,icuaId,time,icuoId)) q:(icuoId="")  d
				...q:'$d(^DHCICUOrder(icuoId))
				...q:$p(^DHCICUOrder(icuoId),"^",38)'=inCathIcupiId
				...q:"ICD"[$p(^DHCICUOrder(icuoId),"^",25)
				...s inCathDateTime=$p(^DHCICUOrder(icuoId),"^",10)
				...s inCathDate=##class(web.DHCClinicCom).ConvertToDateH($p(inCathDateTime," "))
				...s inCathTime=##class(web.DHCClinicCom).ConvertToTimeH($p(inCathDateTime," ",2))
				...s startDate=##class(web.DHCClinicCom).ConvertToDateH($p(^DHCICUOrder(icuoId),"^",5))
				...s startTime=##class(web.DHCClinicCom).ConvertToTimeH($p(^DHCICUOrder(icuoId),"^",6))		
				...;i (icuaId=4766)&&(icucriId=6904) w inCathDate_","_inCathTime,!		
		.s time=fromTime-1
		.f  s time=$o(^DHCICUOrder(0,"RecordItem",exCathIcucriId,date,icuaId,time)) q:(time="")!(time>toTime)  d			
			..s icuoId=""
			..f  s icuoId=$o(^DHCICUOrder(0,"RecordItem",exCathIcucriId,date,icuaId,time,icuoId)) q:(icuoId="")  d	
				...q:'$d(^DHCICUOrder(icuoId))		
				...q:$p(^DHCICUOrder(icuoId),"^",38)'=exCathIcupiId				
				...q:"ICD"[$p(^DHCICUOrder(icuoId),"^",25)			
				...s exCathDateTime=$p(^DHCICUOrder(icuoId),"^",10)
				...s exCathDate=##class(web.DHCClinicCom).ConvertToDateH($p(exCathDateTime," "))
				...s exCathTime=##class(web.DHCClinicCom).ConvertToTimeH($p(exCathDateTime," ",2))
				...s startDate=##class(web.DHCClinicCom).ConvertToDateH($p(^DHCICUOrder(icuoId),"^",5))
				...s startTime=##class(web.DHCClinicCom).ConvertToTimeH($p(^DHCICUOrder(icuoId),"^",6))
				...;i (icuaId=4766)&&(icucriId=6904) w exCathDate_","_exCathTime,!
	;i (icuaId=4766)&&(icucriId=6904) w inCathDate_","_inCathTime_","_exCathDate_","_exCathTime,!	
	q inCathDate_"^"_inCathTime_"^"_exCathDate_"^"_exCathTime_"^"_startDate_"^"_startTime
}

/// creater: mfc 20141022
/// input:	inquiryFromDate开始日期,inquiryToDate结束日期,inDateTime入病区日期时间,outDateTime出病区日期时间,arcimIdStr医嘱IDID串,oeordId医嘱项目ID,SpecimenStr采集标本ID,dataField获取结果格式(医嘱ID+日期时间),ordStat医嘱状态(E执行V审核),doseNote医嘱备注
/// output:	oeoriId医嘱单项号,oeoriSttDat下医嘱日期,oeoriSttTim下医嘱时间
/// Desc：	返回医嘱ID或者下医嘱日期时间，"#"分割的多条结果，"！"分割医嘱单项号和下医嘱日期时间
ClassMethod getOeOrdAndDateTime(inquiryFromDate, inquiryFromTime, inquiryToDate, inquiryToTime, inDateTime = "", outDateTime = "", arcimIdStr, oeordId, SpecimenStr = "", dataField = "oerIdAndDT", ordStat = "E", doseNote = "")
{
	q:(inquiryFromDate="")||(inquiryToDate="")||(arcimIdStr="") ""
	q:(oeordId="") ""
	;s inquiryFromDate=##class(web.DHCClinicCom).ConvertToDateH(inquiryFromDate)
	;s inquiryFromTime=##class(web.DHCClinicCom).ConvertToTimeH(inquiryFromTime)
	;s inquiryToDate=##class(web.DHCClinicCom).ConvertToDateH(inquiryToDate)
	;s inquiryToTime=##class(web.DHCClinicCom).ConvertToTimeH(inquiryToTime)
	s ArcimDescDT=""
	f i=1:1:$l(arcimIdStr,"^") d
	.s arcimId=$p(arcimIdStr,"^",i)
	.q:arcimId=""
	.s oeoriSttDate=""
	.;s ^tempmfc(arcimId)=oeordId_"^"_arcimId
	.i (inquiryFromDate'="") s oeoriSttDate=inquiryFromDate-1
	.f  s oeoriSttDate=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,oeoriSttDate)) q:(oeoriSttDate="")  d
	..i (inquiryFromDate'="")&(oeoriSttDate>inquiryToDate) s oeoriSttDate=$h+10000 //退出
	..s oeoriSub=""
	..f  s oeoriSub=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,oeoriSttDate,oeoriSub)) q:(oeoriSub="")  d
	...q:'$d(^OEORD(oeordId,"I",oeoriSub))
	...s oeoriId=oeordId_"||"_oeoriSub
	...q:$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",12)'=""
	...s Specimen=$p($g(^OEORD(oeordId,"I",oeoriSub,"SPEC",1)),"^",1)
	...i (SpecimenStr'="")&&($l(SpecimenStr,"!")>1) q:(SpecimenStr'="")&&(("^"_$p(SpecimenStr,"!",2)_"^")[("^"_Specimen_"^"))
	...i (SpecimenStr'="")&&($l(SpecimenStr,"!")=1) q:(SpecimenStr'="")&&(("^"_SpecimenStr_"^")'[("^"_Specimen_"^"))
	...s oriNote=$g(^OEORD(oeordId,"I",+oeoriSub,"DEP",1))
	...q:(doseNote'="")&&(oriNote'[doseNote)
	...s ordStatCode=##Class(web.DHCClinicCom).GetOrdStatCode(oeoriId)
	...;q:(("E"'[ordStatCode))&&("V"'[ordStatCode)
	...q:ordStatCode'=ordStat
	...s oeoriSttDat=$p(^OEORD(oeordId,"I",oeoriSub,"ST",1),"^",1) //下医嘱日期
	...s oeoriSttTim=$p(^OEORD(oeordId,"I",oeoriSub,"ST",1),"^",2)
	...q:((inquiryFromDate'="")&&(inquiryFromDate>oeoriSttDat))||((inquiryToDate'="")&&(inquiryToDate<oeoriSttDat))
	...q:((inquiryFromDate=oeoriSttDat)&&(inquiryFromTime'="")&&(inquiryFromTime>oeoriSttTim))||((inquiryToDate=oeoriSttDat)&&(inquiryToTime'="")&&(inquiryToTime<oeoriSttTim))
	...s oeoriSttDateTime=oeoriSttDat+(oeoriSttTim/100000)					
	...i inDateTime="" d	
	....s inDateTimeStr=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
	....q:inDateTimeStr=""		
	....s inDate=$p(inDateTimeStr,"^"),inTime=$p(inDateTimeStr,"^",2)
	....s inDateTime=inDate+(inTime/100000)
	...i outDateTime="" d
	....s outDateTimeStr=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
	....i outDateTimeStr="" d
	.....s outDateTime=$h+($p($h,",",2)/100000)
	....e  d
	.....s outDate=$p(outDateTimeStr,"^"),outTime=$p(outDateTimeStr,"^",2)
	.....s outDateTime=outDate+(outTime/100000)
	...q:oeoriSttDateTime<inDateTime
	...q:oeoriSttDateTime>outDateTime							 					
	...i (dataField["oerIdAndDT") d
	....i ArcimDescDT="" s ArcimDescDT=oeoriId_"!"_$zd(oeoriSttDat,3)_" "_$zt(oeoriSttTim,2)
	....e  s ArcimDescDT=ArcimDescDT_"#"_oeoriId_"!"_$zd(oeoriSttDat,3)_" "_$zt(oeoriSttTim,2)
	q ArcimDescDT
}

/// creater: mfc 20141022
/// input:	NowDate日期,NowTime时间,operAS运算符("+"向后算时间、"-"向前算时间),HourV前、后几小时
/// output:	returnDate前、后几小时日期,returnTime前、后几小时时间
/// Desc：	根据输入的日期时间,换算出HourV小时前、后的日期时间,根据operAS运算符决定往前还是往后
/// w ##class(web.DHCICUStat).getPreDateTime("2014-10-30","01:00","-","3")
ClassMethod getPreDateTime(NowDate, NowTime, operAS, HourV = 0)
{
	q:NowDate=""||NowTime=""
	s NowDate=##class(web.DHCClinicCom).ConvertToDateH(NowDate)
	s NowTime=##class(web.DHCClinicCom).ConvertToTimeH(NowTime)
	s returnDate="",returnTime=""
	i operAS="-" d
	.s returnDate=NowDate
	.s returnTime=NowTime-(HourV*3600)
	.i returnTime<0 d
	..s returnDate=returnDate+(returnTime\86400)-1
	..s returnTime=returnTime#86400
	..;s returnDate=returnDate-1
	..;s returnTime=86400+returnTime
	i operAS="+" d
	.s returnDate=NowDate
	.s returnTime=NowTime+(HourV*3600)
	.i returnTime>=86400 d
	..s returnDate=returnDate+(returnTime\86400)
	..s returnTime=returnTime#86400
	q returnDate_" "_returnTime
}

ClassMethod SetSumStr(sumStr, sumType, pos, value)
{
	q:sumType="" sumStr
	i sumType["Sum" s $p(sumStr,"^",pos)=$p(sumStr,"^",pos)+value
	i sumType["Times",value'="" s $p(sumStr,"^",pos)=$p(sumStr,"^",pos)+1
	i sumType="Average",value'="" d
		.s curStr=$p(sumStr,"^",pos)
		.s $p(curStr,"/")=$p(curStr,"/")+value
		.s $p(curStr,"/",2)=$p(curStr,"/",2)+1
		.s $p(sumStr,"^",pos)=curStr
		.q:curStr=""
		.//w sumStr_"    curStr="_curStr,!
	i sumType["Max",value>$p(sumStr,"^",pos) s $p(sumStr,"^",pos)=value	
	q sumStr
}

ClassMethod IfPostOperation(EpisodeID, date, time) As %String
{
	s retStr="N"
	q:EpisodeID="" retStr
	s opaId=""
	f  s opaId=$o(^DHCANOPArrange(0,"Adm",EpisodeID,opaId)) q:opaId=""  d
		.q:'$d(^DHCANOPArrange(opaId))
		.s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
		.q:"ARDILP"[opaStatus
		.s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
		.s anaSub=$p(anaId,"||",2)
		.q:anaSub=""
		.s anaTheatreOutDate=$p(^OR(+anaId,"ANA",anaSub),"^",41)
		.s anaTheatreOutTime=$p(^OR(+anaId,"ANA",anaSub),"^",42)
		.w !,opaId_"/"_anaId
		.i anaTheatreOutDate="" d
			..s opaStartDate=$P(^DHCANOPArrange(opaId),"^",14)
			..s opaStartTime=$P(^DHCANOPArrange(opaId),"^",15)
			..s duraHour=##class(web.DHCClinicCom).CalculateDuration(opaStartDate,opaStartTime,date,time,"H")
			..w " Start "_"/dur:"_opaStartDate_"/"_opaStartDate_"/"_duraHour
			..q:(duraHour>28)!(duraHour<-6)
			..w "    Y"
			..s retStr="Y"
		.e  d
			..s duraHour=##class(web.DHCClinicCom).CalculateDuration(anaTheatreOutDate,anaTheatreOutTime,date,time,"H")
			..w " End   "_"/dur:"_anaTheatreOutDate_"/"_anaTheatreOutTime_"/"_duraHour
			..q:(duraHour>8)!(duraHour<-2)
			..w "    Y"
			..s retStr="Y"	
	q retStr
}

/// 功能:通过医嘱名称,获取相关医嘱的开始时间
/// 入参:arcimDesc医嘱名称,EpisodeID就诊号
/// 返回:retstr医嘱开始时间串，通过"^"分割
ClassMethod insertOrOutTube(arcimDesc As %String, EpisodeID As %String) As %String
{
	s arcimId=0,arcimRowId="",retstr=""
    f  s arcimId=$o(^ARCIM(arcimId)) q:arcimId=""  d
    .q:$p($g(^ARCIM(arcimId,1,1)),"^",2)'[arcimDesc       
	.s arcimRowId=arcimId_"||1"	 
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))				
    s oeoriSttDate=""
    f  s oeoriSttDate=$o(^OEORDi(0,"ARCIM",oeordId,arcimRowId,oeoriSttDate)) q:(oeoriSttDate="")  d
    .i retstr="" s retstr=oeoriSttDate
    .e  s retstr=retstr_"^"_oeoriSttDate
    q retstr
}

/// w ##class(web.DHCICUStat).FindCLScoreNumber("2014-02-01","2014-02-28","56^2166","")
/// 创建：Add mfc 20140213
/// 说明：获取月收治患者数量和评分
/// 功能：根据数量，得出评分
/// 入参：fromDate开始时间,toDate结束时间,RecordItemId:常用医嘱Id,arcimDesc:医嘱名称,wardIdStr:科室列表,用"^"分割,CTMUDesc:医生分组(A1组/A2组/B1组/B2组)
/// 返回：以"$"分割的记录
ClassMethod FindCLScoreNumber(fromDate As %String, toDate As %String, ctlocIdStr As %String, CTMUDesc As %String = "") As %String
{
	s retstr=""
	s ArrSum=0 //计算监护病人总数	
	s CTMUDesc=CTMUDesc //医生所在分组
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	s wardIdStr=""
	f i=1:1:$l(ctlocIdStr,"^") d
		.s ctlocId=$p(ctlocIdStr,"^",i)
		.q:ctlocId=""
		.s wardId=$o(^PAWARD(0,"WARD_LocationDR",ctlocId,0))
		.q:wardId=""
		.i wardIdStr'="" s wardIdStr=wardIdStr_"^"
		.s wardIdStr=wardIdStr_wardId
	f date=fromDate:1:toDate d
	.s icuaId=""
    .f  s icuaId=$o(^DHCICUArrange(0,"SDate",date,icuaId)) q:icuaId=""  d
    ..q:'$d(^DHCICUArrange(icuaId))    
    ..s EpisodeID=$p(^DHCICUArrange(icuaId),"^",1)
	..q:EpisodeID=""
	..s inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
	..s outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")	
	..s WardinDate=$p(inDateTime,"^",1),WardinTime=	$p(inDateTime,"^",2)
	..i outDateTime'="" s WardoutDate=$p(outDateTime,"^",1),WardoutTime=$p(outDateTime,"^",2)
	..e  s WardoutDate="",WardoutTime=""
	..;q:(date<WardinDate)||((outDateTime'="")&&(date>WardoutDate))
	..&SQL(select ICUO_RowId into :tableFlag from DHC_ICU_Order where ICUO_ICUA_Dr=:icuaId)
	..q:(tableFlag="")  //数据为空
	..s arrsttime=$p(^DHCICUArrange(icuaId),"^",8)
	..s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	..s icuBedId=$p($g(^DHCICUArrange(icuaId)),"^",4)
	..q:(wardIdStr'="")&(("^"_wardIdStr_"^")'[("^"_(+icuBedId)_"^"))
	..s wardLocId=$p(^PAWARD(+icuBedId),"^",5)	
	..s PatName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	..s cTGroupDesc="",bedDoctorDesc=""
	..s CTLocDr=$p(^DHCICUArrange(icuaId),"^",2)
	..s rowid=""	
	..f  s rowid=$o(^PAADM(EpisodeID,"TRANS",rowid)) q:rowid=""  d
	...s LocID=$p(^PAADM(EpisodeID,"TRANS",rowid),"^",6)
	...q:LocID'=CTLocDr
	...s bedDoctorDr=$p(^PAADM(EpisodeID,"TRANS",rowid),"^",5) //主治医生
	...q:bedDoctorDr=""	
	...s CTChildsub="",MUCPChildsub=""  //分组查询
	...f  s CTChildsub=$o(^CTLOC(CTLocDr,"MU",CTChildsub)) q:(CTChildsub="")  d
    ....f  s MUCPChildsub=$o(^CTLOC(CTLocDr,"MU", CTChildsub,"CP", MUCPChildsub)) q:MUCPChildsub=""   d
    .....s MUCPDoctorDR=$p(^CTLOC(CTLocDr,"MU", CTChildsub,"CP", MUCPChildsub),"^",1)
    .....q:MUCPDoctorDR'=bedDoctorDr
    .....s bedDoctorDesc=$P($g(^CTPCP(MUCPDoctorDR,1)),"^",2)
    .....s cTGroupDesc=$p(^CTLOC(CTLocDr,"MU",CTChildsub),"^",2)
    ..q:((CTMUDesc'="")&(("^"_cTGroupDesc_"^")'[("^"_(CTMUDesc)_"^")))
    ..i retstr="" s retstr=EpisodeID_"^"_icuaId_"^"_PatName_"^"_$zd(WardinDate,3)_" "_$zt(WardinTime)_"^"_$zd(WardoutDate,3)_" "_$zt(WardoutTime)_"^"_$zd(date,3)_" "_$zt(arrsttime)_"^"_$p($G(^CTLOC(wardLocId)),"^",2)_"^"_bedDoctorDesc_"^"_cTGroupDesc
	..e  s retstr=retstr_"$"_EpisodeID_"^"_icuaId_"^"_PatName_"^"_$zd(WardinDate,3)_" "_$zt(WardinTime)_"^"_$zd(WardoutDate,3)_" "_$zt(WardoutTime)_"^"_$zd(date,3)_" "_$zt(arrsttime)_"^"_$p($G(^CTLOC(wardLocId)),"^",2)_"^"_bedDoctorDesc_"^"_cTGroupDesc	
	..s ArrSum=ArrSum+1  ///月收治患者数量	
	s ArrNumberScore= 20+(ArrSum-49) //月收治患者数量评分 基础分20   
    s ^tempApacheScore("ArrNumber")="月收治患者数量"_"^"_"20"_"^"_ArrNumberScore_"^"_ArrSum
   q retstr
}

/// ##class(web.DHCICUStat).FindBedItem("56^2166")
/// 创建： Add mfc 20140213
/// 功能：根据病区索引获取床位索引
/// 入参：ctlocIdStr病区，"^"分割
/// 返回："^"分割的床位索引
ClassMethod FindBedItem(ctlocIdStr = "") As %String
{
	q:ctlocIdStr=""
	s wardIdStr=""
	f i=1:1:$l(ctlocIdStr,"^") d
		.s ctlocId=$p(ctlocIdStr,"^",i)
		.q:ctlocId=""
		.s wardId=$o(^PAWARD(0,"WARD_LocationDR",ctlocId,0))
		.q:wardId=""
		.i wardIdStr'="" s wardIdStr=wardIdStr_"^"
		.s wardIdStr=wardIdStr_wardId
	q wardIdStr
}

/// w ##class(web.DHCICUStat).FindCLScoreRecord("2014-03-01","2014-03-31","","56^2166","")
/// 创建： Add mfc 20140213
/// 功能:获取相关监护安排记录
/// 入参:fromDate开始时间,toDate结束时间,RecordItemId:常用医嘱Id,wardIdStr:科室列表,用"^"分割,CTMUDesc:医生分组(A1组/A2组/B1组/B2组)
/// 返回:"^"分割的，获取有数据的监护安排
ClassMethod FindCLScoreRecord(fromDate As %String, toDate As %String, RecordItemId As %String = "", ctlocIdStr As %String = "", CTMUDesc As %String = "") As %String
{
	s retstr=""	
	i RecordItemId="" s RecordItemId="6385" //ApacheII默认医嘱	
	s CTMUDesc=CTMUDesc //医生所在分组
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	s wardIdStr=..FindBedItem(ctlocIdStr)	
	s icuaIdList=""
	f date=fromDate:1:toDate d
	.s icuaId=""
	.f  s icuaId=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId)) q:icuaId=""  d
	..q:'$d(^DHCICUArrange(icuaId))
	..i icuaIdList="" s icuaIdList=icuaId
	..e  i (("^"_icuaIdList_"^")'[("^"_icuaId_"^")) s icuaIdList=icuaIdList_"^"_icuaId
	f i=1:1:$l(icuaIdList,"^") d
	.s icuaId=$p(icuaIdList,"^",i)   
    .s EpisodeID=$p(^DHCICUArrange(icuaId),"^",1)
	.q:EpisodeID=""
	.s inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
	.s outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")	
	.s WardinDate=$p(inDateTime,"^",1),WardinTime=	$p(inDateTime,"^",2)
	.i outDateTime'="" s WardoutDate=$p(outDateTime,"^",1),WardoutTime=$p(outDateTime,"^",2)
	.e  s WardoutDate="",WardoutTime=""	
	.q:((outDateTime'="")&&(WardoutDate<fromDate))||(WardinDate>toDate)
	.;&SQL(select ICUO_RowId into :tableFlag from DHC_ICU_Order where ICUO_ICUA_Dr=:icuaId)
	.;q:(tableFlag="")  //数据为空
	.s arrstdate=$p(^DHCICUArrange(icuaId),"^",6)
	.s arrsttime=$p(^DHCICUArrange(icuaId),"^",8)
	.s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	.s icuBedId=$p($g(^DHCICUArrange(icuaId)),"^",4)
	.q:(wardIdStr'="")&(("^"_wardIdStr_"^")'[("^"_(+icuBedId)_"^"))
	.s wardLocId=$p(^PAWARD(+icuBedId),"^",5)	
	.s PatName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	.s cTGroupDesc="",bedDoctorDesc=""
	.s CTLocDr=$p(^DHCICUArrange(icuaId),"^",2)
	.s rowid=""	
	.f  s rowid=$o(^PAADM(EpisodeID,"TRANS",rowid)) q:rowid=""  d
	..s LocID=$p(^PAADM(EpisodeID,"TRANS",rowid),"^",6)
	..q:LocID'=CTLocDr
	..s bedDoctorDr=$p(^PAADM(EpisodeID,"TRANS",rowid),"^",5) //主治医生
	..q:bedDoctorDr=""	
	..s CTChildsub="",MUCPChildsub=""  //分组查询
	..f  s CTChildsub=$o(^CTLOC(CTLocDr,"MU",CTChildsub)) q:(CTChildsub="")  d
    ...f  s MUCPChildsub=$o(^CTLOC(CTLocDr,"MU", CTChildsub,"CP", MUCPChildsub)) q:MUCPChildsub=""   d
    ....s MUCPDoctorDR=$p(^CTLOC(CTLocDr,"MU", CTChildsub,"CP", MUCPChildsub),"^",1)
    ....q:MUCPDoctorDR'=bedDoctorDr
    ....s bedDoctorDesc=$P($g(^CTPCP(MUCPDoctorDR,1)),"^",2)
    ....s cTGroupDesc=$p(^CTLOC(CTLocDr,"MU",CTChildsub),"^",2) 
    .q:((CTMUDesc'="")&(("^"_cTGroupDesc_"^")'[("^"_(CTMUDesc)_"^")))
	.;w EpisodeID_"^"_icuaId_"^"_PatName_"^"_$zd(WardinDate,3)_" "_$zt(WardinTime)_"^"_$zd(WardoutDate,3)_" "_$zt(WardoutTime)_"^"_$zd(date,3)_" "_$zt(arrsttime)_"^"_$p($G(^CTLOC(wardLocId)),"^",2)_"^"_bedDoctorDesc_"^"_cTGroupDesc_"$"	
	.i retstr="" s retstr=EpisodeID_"^"_icuaId_"^"_PatName_"^"_$zd(WardinDate,3)_" "_$zt(WardinTime)_"^"_$zd(WardoutDate,3)_" "_$zt(WardoutTime)_"^"_$zd(arrstdate,3)_" "_$zt(arrsttime)_"^"_$p($G(^CTLOC(wardLocId)),"^",2)_"^"_bedDoctorDesc_"^"_cTGroupDesc
	.e  s retstr=retstr_"$"_EpisodeID_"^"_icuaId_"^"_PatName_"^"_$zd(WardinDate,3)_" "_$zt(WardinTime)_"^"_$zd(WardoutDate,3)_" "_$zt(WardoutTime)_"^"_$zd(arrstdate,3)_" "_$zt(arrsttime)_"^"_$p($G(^CTLOC(wardLocId)),"^",2)_"^"_bedDoctorDesc_"^"_cTGroupDesc	
	q retstr
}

/// w ##class(web.DHCICUStat).FindAPACHEII("2014-03-01","2014-03-31","","","56^2166","")
/// 创建： Add mfc 20140213
/// 说明:通过调用FindCLScoreRecord方法获取
/// 功能:APACHE II≥15病人数，得出评分
/// 入参:fromDate开始时间,toDate结束时间,RecordItemId:常用医嘱Id,wardIdStr:科室列表,用"^"分割,CTMUDesc:医生分组(A1组/A2组/B1组/B2组)
/// 返回:"^"分割，"^"分割的床位索引记录数据，把评分值保存到Global
///      就诊号^Icuaid^姓名^入病区日期 时间^出病区日期 时间^监护开始日期 时间^科室^主管医生^医生所在组
ClassMethod FindAPACHEII(fromDate As %String, toDate As %String, RecordItemId As %String = "", arcimDesc As %String = "", ctlocIdStr As %String = "", CTMUDesc As %String = "") As %String
{
	s retstr=""
	s apacheSum=0 //APACHE II≥15病人数
	i RecordItemId="" s RecordItemId="6385" //Apache默认医嘱
	s clScoreRecordList=..FindCLScoreRecord(fromDate,toDate,RecordItemId,ctlocIdStr,CTMUDesc)
	f i=1:1:$l(clScoreRecordList,"$") d
	.s clScoreRecord=$p(clScoreRecordList,"$",i)
	.s icuaId=$p(clScoreRecord,"^",2)
	.q:icuaId=""
	.;///月APACHE II≥15病人数
	.s apacheQty=##class(web.DHCICUOrder).GetRecordValue(icuaId,RecordItemId,fromDate,"",toDate,"","Max")
	.i apacheQty>=15 d
	..s apacheSum=apacheSum+1
	..i retstr="" s retstr=$p(clScoreRecord,"^",1)_"^"_icuaId_"^"_$p(clScoreRecord,"^",3)_"^"_$p(clScoreRecord,"^",4)_"^"_$p(clScoreRecord,"^",5)_"^"_apacheQty_"^"_$p(clScoreRecord,"^",7)_"^"_$p(clScoreRecord,"^",8)_"^"_$p(clScoreRecord,"^",9)
	..e  s retstr=retstr_"$"_$p(clScoreRecord,"^",1)_"^"_icuaId_"^"_$p(clScoreRecord,"^",3)_"^"_$p(clScoreRecord,"^",4)_"^"_$p(clScoreRecord,"^",5)_"^"_apacheQty_"^"_$p(clScoreRecord,"^",7)_"^"_$p(clScoreRecord,"^",8)_"^"_$p(clScoreRecord,"^",9)
	s apacheSumScore=20+(apacheSum-8)*3 //月APACHE II≥15病人数 基础分20
	s ^tempApacheScore("apacheSum")="月APACHE II≥15病人数"_"^"_"20"_"^"_apacheSumScore_"^"_apacheSum
	q retstr
}

/// w ##class(web.DHCICUStat).FindICUOut("2014-03-01","2014-03-31","","","56^2166","")
/// 创建： Add mfc 20140213
/// 说明:通过调用FindCLScoreRecord方法获取
/// 功能:死亡数量病人数，得出评分
/// 入参:fromDate开始时间,toDate结束时间,RecordItemId:常用医嘱Id,wardIdStr:科室列表,用"^"分割,CTMUDesc:医生分组(A1组/A2组/B1组/B2组)
/// 返回:"^"分割，"^"分割的床位索引记录数据，把评分值保存到Global
///      就诊号^Icuaid^姓名^入病区日期 时间^出病区日期 时间^监护开始日期 时间^科室^主管医生^医生所在组
ClassMethod FindICUOut(fromDate As %String, toDate As %String, RecordItemId As %String = "", arcimDesc As %String = "", ctlocIdStr As %String = "", CTMUDesc As %String = "") As %String
{
	s retstr=""	
	s outSum=0 //死亡数量
	s clScoreRecordList=..FindCLScoreRecord(fromDate,toDate,RecordItemId,ctlocIdStr,CTMUDesc)
	f i=1:1:$l(clScoreRecordList,"$") d
	.s clScoreRecord=$p(clScoreRecordList,"$",i)
	.s icuaId=$p(clScoreRecord,"^",2)
	.q:icuaId=""
	.s WardinDate=$zdh($p($p(clScoreRecord,"^",4)," ",1),3)
	.s WardinTime=$zth($p($p(clScoreRecord,"^",4)," ",2))
	.s WardoutDate=$zdh($p($p(clScoreRecord,"^",5)," ",1),3)
	.s WardoutTime=$zth($p($p(clScoreRecord,"^",5)," ",2))	
	.s EpisodeID=$p(^DHCICUArrange(icuaId),"^",1)
	.q:EpisodeID=""
	.s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	.s outDate=$p(^PAPER(papmiId,"ALL"),"^",13) //死亡日期
	.s outTime=$p(^PAPER(papmiId,"ALL"),"^",8) //死亡时间
	.i outDate'="" d 
    ..i ((WardinDate<outDate)&&(WardoutDate>outDate)) d
    ...s outSum=outSum+1
    ...i retstr="" s retstr=EpisodeID_"^"_icuaId_"^"_$p(clScoreRecord,"^",3)_"^"_$zd(WardinDate,3)_" "_$zt(WardinTime,2)_"^"_$zd(WardoutDate,3)_" "_$zt(WardoutTime,2)_"^"_$zd(outDate,3)_" "_$zt(outTime,2)_"^"_$p(clScoreRecord,"^",7)_"^"_$p(clScoreRecord,"^",8)_"^"_$p(clScoreRecord,"^",9) 
    ...e  s retstr=retstr_"$"_EpisodeID_"^"_icuaId_"^"_$p(clScoreRecord,"^",3)_"^"_$zd(WardinDate,3)_" "_$zt(WardinTime,2)_"^"_$zd(WardoutDate,3)_" "_$zt(WardoutTime,2)_"^"_$zd(outDate,3)_" "_$zt(outTime,2)_"^"_$p(clScoreRecord,"^",7)_"^"_$p(clScoreRecord,"^",8)_"^"_$p(clScoreRecord,"^",9)
    ..i ((WardinDate=outDate)&&(WardinTime<=outTime)) d
    ...s outSum=outSum+1
    ...i retstr="" s retstr= EpisodeID_"^"_icuaId_"^"_$p(clScoreRecord,"^",3)_"^"_$zd(WardinDate,3)_" "_$zt(WardinTime,2)_"^"_$zd(WardoutDate,3)_" "_$zt(WardoutTime,2)_"^"_$zd(outDate,3)_" "_$zt(outTime,2)_"^"_$p(clScoreRecord,"^",7)_"^"_$p(clScoreRecord,"^",8)_"^"_$p(clScoreRecord,"^",9)
    ...e  s retstr=retstr_"$"_EpisodeID_"^"_icuaId_"^"_$p(clScoreRecord,"^",3)_"^"_$zd(WardinDate,3)_" "_$zt(WardinTime,2)_"^"_$zd(WardoutDate,3)_" "_$zt(WardoutTime,2)_"^"_$zd(outDate,3)_" "_$zt(outTime,2)_"^"_$p(clScoreRecord,"^",7)_"^"_$p(clScoreRecord,"^",8)_"^"_$p(clScoreRecord,"^",9)
    ..e  i ((WardoutDate=outDate)&&(WardoutTime>=outTime)) d
    ...s outSum=outSum+1
    ...i retstr="" s retstr=EpisodeID_"^"_icuaId_"^"_$p(clScoreRecord,"^",3)_"^"_$zd(WardinDate,3)_" "_$zt(WardinTime,2)_"^"_$zd(WardoutDate,3)_" "_$zt(WardoutTime,2)_"^"_$zd(outDate,3)_" "_$zt(outTime,2)_"^"_$p(clScoreRecord,"^",7)_"^"_$p(clScoreRecord,"^",8)_"^"_$p(clScoreRecord,"^",9)
    ...e  s retstr=retstr_"$"_EpisodeID_"^"_icuaId_"^"_$p(clScoreRecord,"^",3)_"^"_$zd(WardinDate,3)_" "_$zt(WardinTime,2)_"^"_$zd(WardoutDate,3)_" "_$zt(WardoutTime,2)_"^"_$zd(outDate,3)_" "_$zt(outTime,2)_"^"_$p(clScoreRecord,"^",7)_"^"_$p(clScoreRecord,"^",8)_"^"_$p(clScoreRecord,"^",9)
    s OutNumberScore= 20-(outSum-1)*2  //月死亡病例数 基础分20
    s ^tempApacheScore("OutNumber")="月死亡病例数"_"^"_"20"_"^"_OutNumberScore_"^"_outSum    
	q retstr
}

/// w ##class(web.DHCICUStat).FindInbedSum("2014-03-01","2014-03-31","","","56^2166","")
/// 创建： Add mfc 20140213
/// 说明:通过调用FindCLScoreRecord方法获取
/// 功能:压床病例数（入ICU 4W以上)，得出评分
/// 入参:fromDate开始时间,toDate结束时间,RecordItemId:常用医嘱Id,wardIdStr:科室列表,用"^"分割,CTMUDesc:医生分组(A1组/A2组/B1组/B2组)
/// 返回:"^"分割，"^"分割的床位索引记录数据，把评分值保存到Global
///      就诊号^Icuaid^姓名^入病区日期 时间^出病区日期 时间^监护开始日期 时间^科室^主管医生^医生所在组
ClassMethod FindInbedSum(fromDate As %String, toDate As %String, RecordItemId As %String = "", arcimDesc As %String = "", ctlocIdStr As %String = "", CTMUDesc As %String = "") As %String
{
	s retstr=""
	s inbedSum=0 //压床病例数（入ICU 4W以上)
	s clScoreRecordList=..FindCLScoreRecord(fromDate,toDate,RecordItemId,ctlocIdStr,CTMUDesc)
	f i=1:1:$l(clScoreRecordList,"$") d
	.s clScoreRecord=$p(clScoreRecordList,"$",i)
	.s icuaId=$p(clScoreRecord,"^",2)
	.q:icuaId=""
	.s WardinDate=$zdh($p($p(clScoreRecord,"^",4)," ",1),3)
	.s WardinTime=$zth($p($p(clScoreRecord,"^",4)," ",2))
	.s WardoutDate=$zdh($p($p(clScoreRecord,"^",5)," ",1),3)
	.s WardoutTime=$zth($p($p(clScoreRecord,"^",5)," ",2))	
    .//压床病例数（入ICU 4W以上)
    .s icuHour=(WardoutTime-WardinTime)\3600+((WardoutDate-WardinDate)*24)
    .s icuDay=icuHour\24
    .i icuDay>28 d
    ..s inbedSum=inbedSum+1
    ..;w EpisodeID_"^"_icuaId_"^"_PatName_"^"_$zd(WardinDate,3)_" "_$zt(WardinTime,2)_"^"_$zd(WardoutDate,3)_" "_$zt(WardoutTime,2)_"^"_icuDay_"^"_$p($G(^CTLOC(wardLocId)),"^",2)_"^"_cTGroupDesc_"$"
	..i retstr="" s retstr=$p(clScoreRecord,"^",1)_"^"_icuaId_"^"_$p(clScoreRecord,"^",3)_"^"_$p(clScoreRecord,"^",4)_"^"_$p(clScoreRecord,"^",5)_"^"_icuDay_"^"_$p(clScoreRecord,"^",7)_"^"_$p(clScoreRecord,"^",9)
	..e  s retstr=retstr_"$"_$p(clScoreRecord,"^",1)_"^"_icuaId_"^"_$p(clScoreRecord,"^",3)_"^"_$p(clScoreRecord,"^",4)_"^"_$p(clScoreRecord,"^",5)_"^"_icuDay_"^"_$p(clScoreRecord,"^",7)_"^"_$p(clScoreRecord,"^",9)
	s inbedSumScore=5-(inbedSum-1)*2 //压床病例数（入ICU 4W以上）基础分5
	s ^tempApacheScore("inbedSum")="压床病例数(入ICU 4W以上)"_"^"_"5"_"^"_inbedSumScore_"^"_inbedSum
    q retstr
}

/// w ##class(web.DHCICUStat).FindInTube("2014-03-01","2014-03-31","","","56^2166","")
/// 创建： Add mfc 20140213
/// 说明:通过调用FindCLScoreRecord方法获取
/// 功能:48小时再插气管病例数，得出评分
/// 入参:fromDate开始时间,toDate结束时间,RecordItemId:常用医嘱Id,wardIdStr:科室列表,用"^"分割,CTMUDesc:医生分组(A1组/A2组/B1组/B2组)
/// 返回:"^"分割，"^"分割的床位索引记录数据，把评分值保存到Global
///      就诊号^Icuaid^姓名^入病区日期 时间^出病区日期 时间^监护开始日期 时间^科室^主管医生^医生所在组
ClassMethod FindInTube(fromDate As %String, toDate As %String, RecordItemId As %String = "", arcimDesc As %String = "", ctlocIdStr As %String = "", CTMUDesc As %String = "") As %String
{
	s retstr=""
	s tubeSum=0 //48小时再插气管病例数
	i arcimDesc="" s arcimDesc="气管插管术E0078"  //30156
	s clScoreRecordList=..FindCLScoreRecord(fromDate,toDate,RecordItemId,ctlocIdStr,CTMUDesc)
	f i=1:1:$l(clScoreRecordList,"$") d
	.s clScoreRecord=$p(clScoreRecordList,"$",i)
	.s icuaId=$p(clScoreRecord,"^",2)
	.q:icuaId=""
	.s EpisodeID=$p(^DHCICUArrange(icuaId),"^",1)
	.//48小时再插气管病例数（非预期）
    .s oeorInsertStr="",oeorOutStr=""    
    .s oeorInsertStr=##Class(web.DHCICUStat).insertOrOutTube(arcimDesc,EpisodeID)  //插管医嘱
    .;i (oeorInsertStr'="")&&($l(oeorInsertStr,"^")>1) d  
    ..;w EpisodeID_"^"_icuaId_"^"_oeorInsertStr_"$"   
    .i $l(oeorInsertStr,"^")>1 d
    ..s oeorOutStr=##Class(web.DHCICUStat).insertOrOutTube("拔除气管插管",EpisodeID) //拔管医嘱
    ..;w EpisodeID_"^"_icuaId_"^"_oeorOutStr_"$"
    ..f i=1:1:$l(oeorInsertStr,"^") d
    ...s stInsertOneDate=$p(oeorInsertStr,"^",i)
    ...s stInserttwoDate=$p(oeorInsertStr,"^",i+1)
    ...s stOutDate=$p(oeorOutStr,"^",i)
    ...i ((stOutDate>=stInserttwoDate)&&((stOutDate-stInserttwoDate)<=2)) s tubeSum=tubeSum+1
    ...i retstr="" s retstr=EpisodeID_"^"_icuaId_"^"_$p(clScoreRecord,"^",3)_"^"_$p(clScoreRecord,"^",4)_"^"_$p(clScoreRecord,"^",5)_"^"_icuDay_"^"_$p(clScoreRecord,"^",7)_"^"_$p(clScoreRecord,"^",9)
	...e  s retstr=retstr_"$"_EpisodeID_"^"_icuaId_"^"_$p(clScoreRecord,"^",3)_"^"_$p(clScoreRecord,"^",4)_"^"_$p(clScoreRecord,"^",5)_"^"_icuDay_"^"_$p(clScoreRecord,"^",7)_"^"_$p(clScoreRecord,"^",9)	
    s tubeSumScore=5-(tubeSum-1)*2  //48小时再插气管病例数
    s ^tempApacheScore("tubeSum")="48小时再插气管病例数(非预期)"_"^"_"5"_"^"_tubeSumScore_"^"_tubeSum
	q retstr
}

/// w ##class(web.DHCICUStat).GetDocGroup(2150,"")
ClassMethod GetDocGroup(icuaId As %String = "", CTMUDesc As %String = "") As %String
{
	s cTGroupDesc="",bedDoctorDesc=""
	s CTLocDr=$p(^DHCICUArrange(icuaId),"^",2)
	s EpisodeID=$p(^DHCICUArrange(icuaId),"^",1)
	s rowid=""	
	f  s rowid=$o(^PAADM(EpisodeID,"TRANS",rowid)) q:rowid=""  d
	.s LocID=$p(^PAADM(EpisodeID,"TRANS",rowid),"^",6)
	.q:LocID'=CTLocDr
	.s bedDoctorDr=$p(^PAADM(EpisodeID,"TRANS",rowid),"^",5) //主治医生
	.q:bedDoctorDr=""	
	.s CTChildsub="",MUCPChildsub=""  //分组查询
	.f  s CTChildsub=$o(^CTLOC(CTLocDr,"MU",CTChildsub)) q:(CTChildsub="")  d
    ..f  s MUCPChildsub=$o(^CTLOC(CTLocDr,"MU", CTChildsub,"CP", MUCPChildsub)) q:MUCPChildsub=""   d
    ...s MUCPDoctorDR=$p(^CTLOC(CTLocDr,"MU", CTChildsub,"CP", MUCPChildsub),"^",1)
    ...q:MUCPDoctorDR'=bedDoctorDr
    ...s bedDoctorDesc=$P($g(^CTPCP(MUCPDoctorDR,1)),"^",2)
    ...s cTGroupDesc=$p(^CTLOC(CTLocDr,"MU",CTChildsub),"^",2)
    q:((CTMUDesc'="")&(("^"_cTGroupDesc_"^")'[("^"_(CTMUDesc)_"^")))
    q cTGroupDesc
}

/// w ##class(web.DHCICUStat).CompareInBedTime(2150,2161,"","")
ClassMethod CompareInBedTime(icuaid As %String = "", icuaid2 As %String = "", patName As %String = "", CTMUDesc As %String = "") As %String
{
	s retstr="",icuHour=""
	s againSum=0 //48小时再转入ICU病例数	
	s inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaid,"","","^","D")
    s outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaid,"","","^","D")
    s WardinDate=$p(inDateTime,"^",1),WardinTime=	$p(inDateTime,"^",2)
	s WardoutDate=$p(outDateTime,"^",1),WardoutTime=	$p(outDateTime,"^",2)
	s icuBedId=$p($g(^DHCICUArrange(icuaid)),"^",4)
	s wardLocId=$p(^PAWARD(+icuBedId),"^",5)
	s EpisodeID=$p(^DHCICUArrange(icuaid),"^",1)
	s cTGroupDesc=..GetDocGroup(icuaid,CTMUDesc)
	s inDateTime2=##class(web.DHCICUCom).GetWardInDateTime("",icuaid2,"","","^","D")
    s outDateTime2=##class(web.DHCICUCom).GetWardOutDateTime("",icuaid2,"","","^","D")
    s WardinDate2=$p(inDateTime2,"^",1),WardinTime2=	$p(inDateTime2,"^",2)
	s WardoutDate2=$p(outDateTime2,"^",1),WardoutTime2=	$p(outDateTime2,"^",2)
	s icuBedId2=$p($g(^DHCICUArrange(icuaid2)),"^",4)
	s wardLocId2=$p(^PAWARD(+icuBedId2),"^",5)
	s cTGroupDesc2=..GetDocGroup(icuaid2,CTMUDesc)
    i WardoutDate<WardinDate2 s icuHour=(WardinTime2-WardoutTime)\3600+((WardinDate2-WardoutDate)*24)
    i icuHour<=48  d 
    .s againSum=againSum+1
    .i retstr="" s retstr=EpisodeID_"^"_icuaid_"^"_patName_"^"_$zd(WardinDate,3)_" "_$zt(WardinTime,2)_"^"_$zd(WardoutDate,3)_" "_$zt(WardoutTime,2)_"^"_$p($G(^CTLOC(wardLocId)),"^",2)_"^"_cTGroupDesc_"^"_icuaid2_"^"_$zd(WardinDate2,3)_" "_$zt(WardinTime2,2)_"^"_$zd(WardoutDate2,3)_" "_$zt(WardoutTime2,2)_"^"_$p($G(^CTLOC(wardLocId2)),"^",2)_"^"_cTGroupDesc2 
    .e  s retstr=retstr_"$"_EpisodeID_"^"_icuaid_"^"_patName_"^"_$zd(WardinDate,3)_" "_$zt(WardinTime,2)_"^"_$zd(WardoutDate,3)_" "_$zt(WardoutTime,2)_"^"_$p($G(^CTLOC(wardLocId)),"^",2)_"^"_cTGroupDesc_"^"_icuaid2_"^"_$zd(WardinDate2,3)_" "_$zt(WardinTime2,2)_"^"_$zd(WardoutDate2,3)_" "_$zt(WardoutTime2,2)_"^"_$p($G(^CTLOC(wardLocId2)),"^",2)_"^"_cTGroupDesc2 
    s againSumScore=5-(againSum-0)*2 //48小时再转入ICU病例数(非预期）基础分5
    s ^tempApacheScore("againSum")="48小时再转入ICU病例数(非预期)"_"^"_"5"_"^"_againSumScore_"^"_againSum
    q retstr
}

/// w ##class(web.DHCICUStat).FindBeginInLoc("2014-03-01","2014-03-31","","","56^2166","")
/// 创建： Add mfc 20140213
/// 说明:通过调用FindCLScoreRecord方法获取
/// 功能:48小时再转入ICU病例数，得出评分
/// 入参:fromDate开始时间,toDate结束时间,RecordItemId:常用医嘱Id,wardIdStr:科室列表,用"^"分割,CTMUDesc:医生分组(A1组/A2组/B1组/B2组)
/// 返回:"^"分割，"^"分割的床位索引记录数据，把评分值保存到Global
///      就诊号^Icuaid^姓名^入病区日期 时间^出病区日期 时间^监护开始日期 时间^科室^主管医生^医生所在组
ClassMethod FindBeginInLoc(fromDate As %String, toDate As %String, RecordItemId As %String = "", arcimDesc As %String = "", ctlocIdStr As %String = "", CTMUDesc As %String = "") As %String
{
	s retstr="",EpisodeIDList=""
	s againSum=0 //48小时再转入ICU病例数
	s wardIdStr=..FindBedItem(ctlocIdStr)	
	s clScoreRecordList=..FindCLScoreRecord(fromDate,toDate,RecordItemId,ctlocIdStr,CTMUDesc)	
	f i=1:1:$l(clScoreRecordList,"$") d
	.s clScoreRecord=$p(clScoreRecordList,"$",i)	
	.s icuaId=$p(clScoreRecord,"^",2)
	.q:icuaId=""
	.s EpisodeID=$p(^DHCICUArrange(icuaId),"^",1)	
	.q:(EpisodeIDList[EpisodeID)	
	.//48小时再转入ICU病例数(非预期）
    .s icuaId2="",icuaIdList=""
    .f  s icuaId2=$o(^DHCICUArrange(0,"Adm",EpisodeID,icuaId2)) q:icuaId2=""  d
    ..;q:icuaId>=icuaId2
    ..q:'$d(^DHCICUArrange(icuaId2))
    ..i icuaIdList="" s icuaIdList=icuaId2
    ..e  s icuaIdList=icuaIdList_"^"_icuaId2
    .f i=1:1:$l(icuaIdList,"^") d
    ..s icuaId3=$p(icuaIdList,"^",i)  //当前安排记录
    ..s icuaIdNext=$p(icuaIdList,"^",i+1) //下一次安排
    ..q:icuaIdNext=""
    ..s icuHour3=""    
	..s icuBedId3=$p($g(^DHCICUArrange(icuaId3)),"^",4)
	..q:(wardIdStr'="")&(("^"_wardIdStr_"^")'[("^"_(+icuBedId3)_"^"))
	..s icuBedIdNext=$p($g(^DHCICUArrange(icuaIdNext)),"^",4)
	..q:(wardIdStr'="")&(("^"_wardIdStr_"^")'[("^"_(+icuBedIdNext)_"^"))	
	..&SQL(select ICUO_RowId into :tableFlag2 from SQLUSER.DHC_ICU_Order where ICUO_ICUA_Dr=:icuaId3)
	..q:(tableFlag2="")
	..&SQL(select ICUO_RowId into :tableFlag2 from SQLUSER.DHC_ICU_Order where ICUO_ICUA_Dr=:icuaIdNext)
	..q:(tableFlag2="")
	..i retstr="" s retstr=..CompareInBedTime(icuaId3,icuaIdNext,$p(clScoreRecord,"^",3))
	..e  s retstr=retstr_"$"_..CompareInBedTime(icuaId3,icuaIdNext,$p(clScoreRecord,"^",3))
    ..;i WardoutDate<WardinDate2 s icuHour3=(WardinTime2-WardoutTime)\3600+((WardinDate2-WardoutDate)*24) 
    ..;i inDateTime>=inDateTime2 s icuHour2=(WardoutTime-WardinTime2)\3600+((WardoutDate-WardinDate2)*24) 
    ..;i icuHour3<=48  d 
    ...;s againSum=againSum+1
    ...;w EpisodeID_"^"_icuaId_"^"_$zd(WardinDate,3)_" "_$zt(WardinTime,2)_"^"_$zd(WardoutDate,3)_" "_$zt(WardoutTime,2)_"^"_icuaId2_"^"_$zd(WardinDate2,3)_" "_$zt(WardinTime2,2)_"^"_$zd(WardoutDate2,3)_" "_$zt(WardoutTime2,2)_"^"_$p($G(^CTLOC(wardLocId)),"^",2)_"^"_cTGroupDesc_"$"
	.s EpisodeIDList= EpisodeIDList_"^"_EpisodeID
	q retstr
}

/// Add mfc 20140226
/// 根据统计名称获取相关列名(显示自动)自动获取
/// 入参:ColumnHeaderText统计项目名称
/// 返回：TColumnTitle统计项目名称，TOrderClassName统计主项(科室)类名,TOrderMethodName统计主项的方法
///       TSubClassName统计字段(子项)类名,TSubMethodName统计字段(子项)方法
/// 说明：ClassOrMetNameList讲统计项目名称、主项类名、主项方法、统计字段类名(子项)、统计字段方法
///      多个用"$"分割,单个用"^"分割
/// d ##class(%ResultSet).RunQuery("web.DHCICUStat","FindTemplateTotalData","42","4445")
Query FindTemplateTotalData(ICUCIRowid As %String, IcuaId As %String) As %Query(ROWSPEC = "ColumnTitle:%String") [ SqlProc ]
{
}

ClassMethod FindTemplateTotalDataExecute(ByRef qHandle As %Binary, ICUCIRowid As %String, args As %String) As %Status
{
	// D ##class(%ResultSet).RunQuery("web.DHCICUStat","FindTemplateTotalData",42,"1^2015-05-18 14-57-54^2015-05-18 14-58-19")
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s icirowid=0,datalb=""
	s IcuaId=+args
	q:'##class(User.DHCICUCInquiry).%ExistsId(ICUCIRowid)
	s obj=##class(User.DHCICUCInquiry).%OpenId(ICUCIRowid)
	// 生成序号与rowId索引
	;s sub=0
	;s index=1
	;f  s sub=$o(^DHCICUCInquiry(ICUCIRowid,"I",sub)) q:sub=""  d
	.;s itemRowId=ICUCIRowid_"||"_sub
	.;q:'##class(User.DHCICUCInquiryItem).%ExistsId(itemRowId)
	.;s itemObj=##class(User.DHCICUCInquiryItem).%OpenId(itemRowId)
	.;q:('itemObj.ICUCIIIsDisplay)
	.;s TmpSeqRowId(itemObj.ICUCIISeqNo)=index
	.;w index
	.;s index=index+1
	//s ^mfcTemp(ICUCIRowid)=obj.ICUCIDataType
	b
	i obj.ICUCIDataType="P" d
	.
	.d FindDataByRecordId(ICUCIRowid,IcuaId)
	e  i obj.ICUCIDataType="M" d
	.d FindDataByLocId(ICUCIRowid,args)
	e  d
	.
	.f  s icirowid=$o(^DHCICUInquiry(ICUCIRowid,icirowid)) q:icirowid=""  d
	..q:+icirowid=0
	..;b ;01
	..q:($g(^DHCICUInquiry(ICUCIRowid,icirowid))="")
	..s datalb=$g(^DHCICUInquiry(ICUCIRowid,icirowid))
	..;s datalb=""
	..;s seq=""
	..;f  s seq=$O(TmpSeqRowId(seq)) q:seq=""  d
	...;s index=$g(TmpSeqRowId(seq))
	...;s InquiryData=$p($g(^DHCICUInquiry(ICUCIRowid,icirowid)),"^",index)
	...;s datalb=datalb_""_InquiryData_"^"
	...;i datalb="" s datalb=InquiryData
	...;e  s datalb=datalb_"^"_InquiryData
	..s datalb=$lb(datalb)
	..d OutputRow11
	..

	d obj.%Close()
	Set qHandle=$lb(0,repid,0)	
	Quit $$$OK
OutputRow11
	set Data=datalb
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
FindDataByRecordId(ICUCIRowid,icuaId,argType="icuaId",scope=0,fromDate=0,fromTime=0,toDate=0,toTime=0)
	s rset=##class(%ResultSet).%New("web.DHCICUStat:FindDataByRecordId")
	s ret=""	
	do rset.Execute(ICUCIRowid,icuaId,argType,scope,fromDate,fromTime,toDate,toTime)
	while (rset.Next()) {
	s data=rset.GetData(1)
	s datalb=$lb(data)
	d OutputRow11
	}
	d rset.Close()
	q
FindDataByLocId(ICUCIRowid,args)
	s stDate=$p(args,"^",2) s stDate=$p(stDate," ",1)
	s endDate=$p(args,"^",3) s endDate=$p(endDate," ",1)
	q:'##class(User.DHCICUCInquiry).%ExistsId(ICUCIRowid)
	s itemObj=##class(User.DHCICUCInquiry).%OpenId(ICUCIRowid)
	d itemObj.%Close()
	s tagWardId=itemObj.ICUCICtlocDr
	q:tagWardId=""
	s linkSub=""
	s scope=0
	i $d(^DHCICUPara(0,"Ctloc",tagWardId)) d
	.b ;若在科室模板中已配置
	.d FindDataByRecordId(ICUCIRowid,tagWardId,"wardId",scope,stDate,0,endDate,0)
	e  d
	.;科室模板中未配置,认为是科室,查找出相应病区
	.s sub="" f  s sub=$O(^CTLOC(tagWardId,"LINK",sub)) q:sub=""  d
	..q:sub=""
	..s linkWardId=^CTLOC(tagWardId,"LINK",sub)
	..q:'$d(^DHCICUPara(0,"Ctloc",linkWardId))
	..b ;why
	..d FindDataByRecordId(ICUCIRowid,linkWardId,"wardId",scope,stDate,0,endDate,0)
	q

	// 查询出有数据的icuaId
	s stDate=##class(web.DHCClinicCom).ConvertToDateH(stDate)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s recordId=6737
	q:'##class(User.DHCICUCInquiry).%ExistsId(ICUCIRowid)
	s itemObj=##class(User.DHCICUCInquiry).%OpenId(ICUCIRowid)
	d itemObj.%Close()
	s tagWardId=itemObj.ICUCICtlocDr
	w "stDate:",stDate,!
	f  s stDate=$O(^DHCICUOrder(0,"RecordItem",recordId,stDate)) q:((stDate="")||(stDate>endDate))  d
	.s id=""
	.;w "date:",stDate,!
	.f  s id=$O(^DHCICUOrder(0,"RecordItem",recordId,stDate,id)) q:id=""  d
	..q:'##class(User.DHCICUArrange).%ExistsId(id)
	..s arrangeObj=##class(User.DHCICUArrange).%OpenId(id)
	..s icuBedId=arrangeObj.ICUABedDr
	..d arrangeObj.%Close()
	..s wardId=$P($g(^PAWARD(+icuBedId)),"^",5)
	..q:tagWardId'=wardId
	..w "icuaId:",id,!
	..s TMPArrangId(id)=id
	s icuaId=""
	f  s icuaId=$O(TMPArrangId(icuaId)) q:icuaId=""  d
	.d FindDataByRecordId(ICUCIRowid,icuaId)
}

ClassMethod FindTemplateTotalDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTemplateTotalDataExecute ]
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

ClassMethod FindTemplateTotalDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTemplateTotalDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 返回值格式: Value1^Value1^Value3...
///             Value的是以"^"分隔开的，数量顺序由queryId中配置确定
/// 			用queryId中的查询项目查询，然后以queryId显示项目显示
/// scope       :  查询数据时的查找范围
/// icuaId      : DHC_ICU_Arrange的RowId
/// queryIdStr  : 要查询的Id串，是逻辑与的关系，同一时间内包含所以ID才能满足条件
/// displayIdStr: 要显示的ID串
/// fromDate,fromTime: 起始时间点
/// toDate,toTime    : 结束时间点 
///        toDate是0时，查询fromDate的fromTime开始fromDate这一天的数据
/// 查找显示项的时间范围，为0时精确查找
/// d ##class(%ResultSet).RunQuery("web.DHCICUStat","FindDataByRecordId",queryId,icuaId)
Query FindDataByRecordId(queryId, icuaIdOrWardId, argType = "icuaId", scope = 0, fromDate = 0, fromTime = 0, toDate = 0, toTime = 0) As %Query(ROWSPEC = "Items:%String") [ SqlProc ]
{
}

ClassMethod FindDataByRecordIdExecute(ByRef qHandle As %Binary, queryId, icuaIdOrWardId, argType = "icuaId", scope = 0, fromDate = 0, fromTime = 0, toDate = 0, toTime = 0) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1	
	k ^DHCICUDebug
	s ^tmpicudebug("FindDataByRecordId")=queryId_","_icuaIdOrWardId_","_argType_","_ scope_","_fromDate_","_fromTime_","_toDate_","_toTime
	// D ##class(%ResultSet).RunQuery("web.DHCICUStat","FindDataByRecordId",icuaId,quryId)
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	s fromTime=##class(web.DHCClinicCom).ConvertToTimeH(fromTime)
	s fromTime=##class(web.DHCClinicCom).ConvertToTimeH(toTime)
	
	s itemNameStr="",queryIdStr="", displayIdStr="",sub=""
	i $ISVALIDNUM(fromDate) d Init

	w "displayIdStr:",displayIdStr,!
	w "queryIdStr:",queryIdStr,!
	
	i ((fromDate)&(toDate=0)) d
	.;查fromdate一天的数据
	.s toDate=fromDate+1
	.s toTime=0
	s daySecs=3600*24
	s fromDateTime=(daySecs*fromDate)+fromTime
	s toDateTime=(daySecs*toDate)+fromTime
	
	s queryIdCount=$l(queryIdStr,"^")
	s diplayIdCount=$l(displayIdStr,"^")
	
	s icucriId=$p(queryIdStr,"^",1)
	q:icucriId="" $$$OK
	b ;//////////////////
	// 通过queryIdStr、fromDate、fromTime、fromDate、fromTime找出时间点
	s date=fromDate,time=fromTime
	i fromDate>0 s date=date-1
	i fromTime>0 s time=time-1
	s quit=0
	f  s date=$o(^DHCICUOrder(0,"RecordItem",icucriId,date)) q:((quit=1)||(date=""))  d
	.i date'=fromDate s time=0
	.i ((toDate'=0)&&(date>toDate)) s quit=1 
	.q:quit=1
	.s icuaId=""
	.f  s icuaId=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId)) q:((quit=1)||(date="")||(icuaId=""))  d
	..q:((argType="icuaId")&&(icuaId'=icuaIdOrWardId))
	..s icuBedId=$p($g(^DHCICUArrange(icuaId)),"^",4)  ;不要查询的重症记录
	..s wardId=$P($g(^PAWARD(+icuBedId)),"^",5)
	..w "wardId:",wardId,"icuaId:",icuaId,!
	..q:((argType="wardId")&&(wardId'=icuaIdOrWardId)) ;不是这个病区的退出
	..f  s time=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time)) q:((quit=1)||(time=""))  d
	...s dateTime=(date*daySecs)+time
	...i ((toDate'=0)&&(dateTime>toDateTime)) s quit=1 b
	...q:quit=1
	...s status="",rowId=""
	...s sub="" f  s sub=$O(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time,sub)) q:sub=""  d
	....s status=$$GetStatus(sub)
	....q:("NE"'[status)
	....s rowId=sub
	...q:rowId=""
	...s isAll=1
	...f i=2:1:queryIdCount q:(isAll=0)  d
	....s rowId=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,rowId))
	....q:("NE"'[$$GetStatus(rowId))
	....i isAll=1 d
	.....s theID=$p(queryIdStr,"^",i)
	.....s theTime=$o(^DHCICUOrder(0,"RecordItem",theID,date,time))
	.....i theTime="" s isAll=0
	...i isAll=1 d
	....s TimeArray(icuaId,dateTime)=dateTime
	
	// 通过displayIdStr中的ID取各时间点的数据
	s sub="",icuaId=""
	f  s icuaId=$O(TimeArray(icuaId)) q:icuaId=""  d
	.s sub=""
	.f  s sub=$O(TimeArray(icuaId,sub)) q:sub=""  d
	..
	..s dateTime=TimeArray(icuaId,sub)
	..s qDate=dateTime\daySecs
	..s qTime=dateTime#daySecs
	..s regNo=..GetInfoByIcuaId(icuaId,"regNo")
	..s valueStr=$$OneTimePoint(icuaId,queryId,qDate,qTime,regNo)	
	..i valueStr'="" s ret=$$OutputRow1(valueStr)
	..w valueStr,!	
	..
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Init
	// 按序号排序
	s sub="" f  s sub=$O(^DHCICUCInquiry(queryId,"I",sub)) q:sub=""  d
	.s itemStr=$g(^DHCICUCInquiry(queryId,"I",sub))
	.q:itemStr=""
	.s seqNo=$LG(itemStr,20)
	.s name=$LG(itemStr,2)
	.s isSearch=$LG(itemStr,4)
	.s isDisplay=$LG(itemStr,5)
	.s recordId=$LG(itemStr,1)
	.s fieldStr=$LG(itemStr,6) ; 字段
	.s code=$lg(itemStr,1)
	.s isSingle=$lg(itemStr,7)
	.i recordId'=+recordId s code=recordId s recordId="" s recordId=$O(^DHCICUC("RecordItem",0,"Code",code,recordId))
	.s type=$lg(itemStr,3)
	.s TmpSeq(seqNo)=name_"^"_isSearch_"^"_isDisplay_"^"_recordId_"^"_fieldStr_"^"_type
	.s TmpSeq(seqNo,"Code")=code
	.s TmpSeq(seqNo,"isSingle")=isSingle
	.s TmpSeq(seqNo,"Filed")=fieldStr
	.s TmpSeq(seqNo,"gap")=$LG(itemStr,10)
	.w "seqNo"_seqNo_" "_TmpSeq(seqNo)
	
	s sub="",itemNameStr="" f  s sub=$O(TmpSeq(sub)) q:sub=""  d
	.s itemStr=$g(TmpSeq(sub))
	.q:itemStr=""
	.s name=$p(itemStr,"^",1)
	.s isSearch=$p(itemStr,"^",2)
	.s isDisplay=$p(itemStr,"^",3)
	.s recordId=$p(itemStr,"^",4)
	.s fieldStr=$p(itemStr,"^",5)
	.i name="" s itemNameStr=name
	.e  s itemNameStr=itemNameStr_"^"_name
	.i isDisplay d
	..i displayIdStr="" s displayIdStr=recordId
	..e  s displayIdStr=displayIdStr_"^"_recordId
	.
	.i isSearch d
	..i queryIdStr="" s queryIdStr=recordId
	..e  s queryIdStr=queryIdStr_"^"_recordId
	..	
	q
OneTimePoint(icuaId,icuciId,qDate,qTime,regNo)
	// 返回一个电间点各查寻项目的值
	s dateTime=$zd(qDate,3)_" "_$zt(qTime)
	w "DateTime:",dateTime,!
	s seq="",valueStr=""
	s index=1,Search=0
	f  s seq=$O(TmpSeq(seq)) q:(seq="")!(Search)  d
	.s itemStr=$g(TmpSeq(seq))
	.q:itemStr=""
	.s isDisplay=$p(itemStr,"^",3)
	.q:('isDisplay)
	.s recordId=$p(itemStr,"^",4)
	.s fieldStr=$p(itemStr,"^",5)	
	.s type=$p(itemStr,"^",6)
	.i type="L" d
	..;检验项目
	..s testCode=TmpSeq(seq,"Code")
	..s isSingle=TmpSeq(seq,"isSingle")
	..s value=##class(web.DHCClinicCom).GetTestResultByScope("", regNo, "", testCode, qDate, qTime,scope, isSingle)
	..s value=$p(value,"\",1)
	..i value'="" 
	.e  i type="R" d
	..;普通项(如血气、PICCO、血糖)
	..s gap=+$g(TmpSeq(seq,"gap"))
	..i gap>0 s scope=gap*60
	..s value=##class(web.DHCICUOrder).GetRecordValueByScope(icuaId,recordId,qDate,qTime,scope)
	..
	.e  i type="P" d
	..s typeName=$g(TmpSeq(seq,"Code"))
	..s value=..GetInfoByIcuaId(icuaId,typeName)
	..
	.i ($p(itemStr,"^",2)=1)&&((value="")||(value=0)) s valueStr="",Search=1 q
	.i fieldStr="DateTime" s value=dateTime
	.i index=1 s valueStr=value
	.e  s valueStr=valueStr_"^"_value
	.s index=index+1
	q valueStr

GetStatus(rowId)
	q:'##class(User.DHCICUOrder).%ExistsId(rowId) "Invalid RowId"
	s obj=##class(User.DHCICUOrder).%OpenId(rowId)
	s editFlag=obj.ICUOEditFlag
	d obj.%Close()	
	q editFlag
OutputRow1(data)
	set Data=$lb(data)
 	Set ^CacheTemp(repid,ind)=Data
    Set ^DHCICUDebug(ind)=data
    b ;"1"
 	Set ind=ind+1
	quit ind
}

ClassMethod FindDataByRecordIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUCInquiryExecute ]
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

ClassMethod FindDataByRecordIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUCInquiryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// w ##class(web.DHCICUStat).GetInWardInfoByIcuaId(3726,"Researchon-SOFANoradrenaline1.1","2014-08-07","19:30","2014-08-07","19:30","EPI")

/// 获取项目数值
/// Input: icuaId监护ID,type项目参数,inDate入病区日期,inTime入病区时间,outDate出病区日期,outTime出病区时间,oeoriNote项目备注
/// Output:返回项目数值 value项目值 ifValue是否有值
ClassMethod GetInWardInfoByIcuaId(icuaId, type, inDate = "", inTime = "", outDate = "", outTime = "", oeoriNote = "") As %String
{
	s value="",ifValue="0",lessValue="0",addInt=0
	q:type=""
	s inIcuDay=((outDate-inDate)+1) //在院天数
	s addInt=$p($p(type,"~",2),".",2) //循环变量
	f i=1:1:inIcuDay d
	.q:i'=addInt
	.s theDay=inDate+(i-1)	//当天
	.i (("^"_$p(type,"~",2)_"^")[("^"_"Date1."_(i)_"^")) s value=$zd(theDay,3) //研究日
	.i (("^"_$p(type,"~",2)_"^")[("^"_"Time1."_(i)_"^"))&&(i=1) s value=$zt(86340-inTime,2) //在院时间
	.i (("^"_$p(type,"~",2)_"^")[("^"_"Time1."_(i)_"^"))&&((i>1)&&(i<inIcuDay)) s value="24:00"
	.i (("^"_$p(type,"~",2)_"^")[("^"_"Time1."_(i)_"^"))&&(i=inIcuDay) s value=$zt(outTime,2)
	.i (("^"_$p(type,"~",2)_"^")[("^"_"PaO2FiO21."_(i)_"^")) s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,"SOFAPaO2/FiO2",theDay,"0:00",theDay,"23:59:59","First","","","","") //sofa评分氧合
	.i (("^"_$p(type,"~",2)_"^")[("^"_"RespSupport1."_(i)_"^")) d //呼吸支持
	..s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,"VDeviceName",theDay,"8:00",theDay,"8:00","First","","","","")
	..i value'="" s value="有"
	.i (("^"_$p(type,"~",2)_"^")[("^"_"MecVent1."_(i)_"^")) d //有创机械通气
	..s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,"VDeviceName",theDay,"8:00",theDay,"8:00","First","","","","")
	..i (value'="")&&(value="PhlipsV60") s value=""
	..e  i (value'="") s value="有" 
 	.i (("^"_$p(type,"~",2)_"^")[("^"_"Heart1."_(i)_"^")) s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,"HR",theDay,"8:00",theDay,"8:00","First","","","","") //心率
	.i (("^"_$p(type,"~",2)_"^")[("^"_"NSBP1."_(i)_"^")) s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,"NSBP",theDay,"8:00",theDay,"8:00","First","","","","") //收缩压
	.i (("^"_$p(type,"~",2)_"^")[("^"_"NDBP1."_(i)_"^")) s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,"NDBP",theDay,"8:00",theDay,"8:00","First","","","","") //舒张压
	.i (("^"_$p(type,"~",2)_"^")[("^"_"NMBP1."_(i)_"^")) s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,"NMBP",theDay,"8:00",theDay,"8:00","First","","","","") //平均压
	.i (("^"_$p(type,"~",2)_"^")[("^"_"ApacheCreatinine1."_(i)_"^")) s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,"SOFACreatinineAndUrine",theDay,"0:00",theDay,"23:59:59","First","","","","") //血肌酐
	.i (("^"_$p(type,"~",2)_"^")[("^"_"SOFASoterocyte1."_(i)_"^")) s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,"SOFASoterocyte",theDay,"0:00",theDay,"23:59:59","First","","","","") //血小板
	.i (("^"_$p(type,"~",2)_"^")[("^"_"SOFAHematoidin1."_(i)_"^")) s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,"SOFAHematoidin",theDay,"0:00",theDay,"23:59:59","First","","","","") //胆红素
	.i (("^"_$p(type,"~",2)_"^")[("^"_"SPOAepinephrine1."_(i)_"^")) d
		..s patWeight=$p($g(^DHCICUArrange(+icuaId)),"^",25)
		..s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,"DetailDosePump",theDay,"8:00",theDay,"8:00","First","","",oeoriNote,"") //肾上腺素
		..s value=$fn(value/patWeight,"",3)
	.i (("^"_$p(type,"~",2)_"^")[("^"_"SOFANoradrenaline1."_(i)_"^")) d
		..s patWeight=$p($g(^DHCICUArrange(+icuaId)),"^",25)
		..s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,"DetailDosePump",theDay,"8:00",theDay,"8:00","First","","",oeoriNote,"") //去甲肾	
		..s value=$fn(value/patWeight,"",3)
	.i (("^"_$p(type,"~",2)_"^")[("^"_"SOFAdopamine1."_(i)_"^")) s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,"DetailDosePump",theDay,"8:00",theDay,"8:00","First","","",oeoriNote,"") //多巴胺
	.i (("^"_$p(type,"~",2)_"^")[("^"_"AdopamineDobu1."_(i)_"^")) s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,"DetailDosePump",theDay,"8:00",theDay,"8:00","First","","",oeoriNote,"") //多巴酚丁胺
	.i (("^"_$p(type,"~",2)_"^")[("^"_"ApacheGCS1."_(i)_"^")) s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,"ApacheGCS",theDay,"0:00",theDay,"23:59:59","First","","","","") //GCS评分
	.i (("^"_$p(type,"~",2)_"^")[("^"_"SOFATotal1."_(i)_"^")) s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,"SOFATotal",theDay,"0:00",theDay,"23:59:59","First","","","","") //SOFA评分
	.i (("^"_$p(type,"~",2)_"^")[("^"_"CVP1."_(i)_"^")) s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,"CVP",theDay,"0:00",theDay,"23:59:59","First","","","","") //CVP
	.i (("^"_$p(type,"~",2)_"^")[("^"_"nyndgnl1."_(i)_"^")) s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,"nyndgnl",theDay,"0:00",theDay,"23:59:59","Sum","","","","") //尿量
	.i (("^"_$p(type,"~",2)_"^")[("^"_"SexNL1."_(i)_"^"))||(("^"_$p(type,"~",2)_"^")[("^"_"TwelveNL1."_(i)_"^"))||(("^"_$p(type,"~",2)_"^")[("^"_"TwentyFourNL1."_(i)_"^")) d //连续小时<特定毫升尿量
	..s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,"nyndgnl",theDay,"0:00",theDay,"23:59:59","touchQty","","","","")
	..s patWeightV=$p($g(^DHCICUArrange(+icuaId)),"^",25)
	..i (("^"_$p(type,"~",2)_"^")[("^"_"SexNL1."_(i)_"^")) d //6小时<0.5ml尿量
	...f k=1:1:6 d
	....i ($p(value,"^",k)/patWeightV)>=0.5 s lessValue="1"
	...i lessValue'="1" s value="是"
	...e  s value=""
	..i (("^"_$p(type,"~",2)_"^")[("^"_"TwelveNL1."_(i)_"^")) d //12小时<0.5ml尿量
	...f k=1:1:12 d
	....i ($p(value,"^",k)/patWeightV)>=0.5 s lessValue="1"
	...i lessValue'="1" s value="是"
	...e  s value=""
	..i (("^"_$p(type,"~",2)_"^")[("^"_"TwentyFourNL1."_(i)_"^")) d //24小时<0.3ml尿量或无尿>12hr
	...f k=1:1:24 d
	....i ($p(value,"^",k)/patWeightV)>=0.3 s lessValue="1"
	...i lessValue="1" d
	....f k=1:1:13 d
	.....i ($p(value,"^",k)'=0)||($p(value,"^",k)'="") s lessValue="1"
	...i lessValue'="1" s value="是"
	...e  s value=""
	.i (("^"_$p(type,"~",2)_"^")[("^"_"ZHY1."_(i)_"^")) d
	..s formerValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,"FormerDiluent",theDay,"7:00",theDay+1,"6:59","Sum","","","","") //置换液(前稀释液)
	..s afterValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,"DiluentAfter",theDay,"7:00",theDay+1,"6:59","Sum","","","","") //置换液(后稀释液)
	..s value=formerValue+afterValue
	..i value=0 s value=""
	.i (("^"_$p(type,"~",2)_"^")[("^"_"CLL1."_(i)_"^")) s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,"UltrafiltrationRateAct",theDay,"7:00",theDay+1,"6:59","Sum","","","","") //超滤量
	.i (("^"_$p(type,"~",2)_"^")[("^"_"TotalIn1."_(i)_"^"))||(("^"_$p(type,"~",2)_"^")[("^"_"TotalOut1."_(i)_"^")) d
	..i (("^"_$p(type,"~",2)_"^")[("^"_"TotalIn1."_(i)_"^")) s icucriId=##class(web.DHCICUCom).GetIcuriIdByCode("TotalIn3") //MICU总入量
	..i (("^"_$p(type,"~",2)_"^")[("^"_"TotalOut1."_(i)_"^")) s icucriId=##class(web.DHCICUCom).GetIcuriIdByCode("TotalOut3") //MICU总出量
	..s count=##class(web.DHCICUOrder).GetSummaryData("", icuaId, theDay, "7:00", theDay+1, "6:59", "7:00")	
 	..i count=+count d
 		..f seqNum=1:1:count d
 			...s Data=$g(^TMPICU("Summary",$j,seqNum))
 			...k ^TMPICU("Summary",$j,seqNum)
 			...q:Data="" 			  	
 			...q:$li(Data,3)'=icucriId	
 			...i value="" s value=$li(Data,6)
 			...e  s value=value+$li(Data,6)
 	.;s isSirs=0,isSepsis=0,isSevereSepsis=0,isSepticShock=0
 	.i (("^"_$p(type,"~",2)_"^")[("^"_"SirsStandard1."_(i)_"^"))!(("^"_$p(type,"~",2)_"^")[("^"_"SepsisStandard1."_(i)_"^"))!(("^"_$p(type,"~",2)_"^")[("^"_"SevereSepsisStandard1."_(i)_"^"))!(("^"_$p(type,"~",2)_"^")[("^"_"SepticShockStandard1."_(i)_"^")) d
 		..s isSirs=##class(web.DHCICUStat).JudgeSirsStandard(icuaId,theDay,"0:00",theDay,"23:59:59") //符合SIRS标准
 		..s isSepsis=##class(web.DHCICUStat).getVasoactiveAgents(icuaId,"AntimicrobialAgents",theDay,theDay) //符合Sepsis标准
	 	..s isSevereSepsis=##class(web.DHCICUStat).JudgeSevereSepsisStandard(icuaId,theDay,"0:00",theDay,"23:59") //符合SevereSepsis标准
	 	..s isSepticShock=##class(web.DHCICUStat).JudgeSepticShockStandard(icuaId,theDay,"0:00",theDay,"23:59:59")
 		..i (("^"_$p(type,"~",2)_"^")[("^"_"SirsStandard1."_(i)_"^"))&&(isSirs=1) d  s value="是"
 		..i (("^"_$p(type,"~",2)_"^")[("^"_"SepsisStandard1."_(i)_"^"))&&(isSirs=1)&&(isSepsis=1) d  s value="是"
 		..i (("^"_$p(type,"~",2)_"^")[("^"_"SevereSepsisStandard1."_(i)_"^"))&&(isSirs=1)&&(isSepsis=1)&&(isSevereSepsis=1) d  s value="是"
 		..i (("^"_$p(type,"~",2)_"^")[("^"_"SepticShockStandard1."_(i)_"^"))&&(isSirs=1)&&(isSepsis=1)&&(isSevereSepsis=1)&&(isSepticShock=1) d  s value="是"
 	.	
	.i value'="" s ifValue="1"
	q value_"/"_ifValue
}

ClassMethod GetInfoByIcuaId(icuaId, type, needNote = "", durationHour = "", fdate = "", tdate = "", oeoriNote = "", refValue = "", exactTime = "", dataField = "")
{
	// w ##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,type)
	s value="",formWard="",Amountfdate="",Amounttdate="",AmountInpatients=""
	
	s Amountfdate=$zd(fdate,3)
	s Amounttdate=$zd(tdate,3)
	
    ;s value= AmountInpatients
	;i type="AmountInpatients" b ;"AmountInpatients"
	;q:(type="AmountInpatients") AmountInpatients b ;"AmountInpatients"
	q:(type="HospitalDay") ##class(web.DHCICUStat).GetMRIPData(fdate,tdate) //医院收治床日数
	s EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
	s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
	s inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
	s inDate=$p(inDateTime,"^"),inTime=$p(inDateTime,"^",2)
	s outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
	s inWardPat=0
	i outDateTime'="" s outDate=$p(outDateTime,"^"),outTime=$p(outDateTime,"^",2)
	e  s outDate=+$h,outTime=$p($h,",",2),inWardPat=1	
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:oeordId=""
	s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	s paadmtype=$p($g(^PAADM(EpisodeID)),"^",2)
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s admDate=$p($g(^PAADM(EpisodeID)),"^",6)
	s dischgDate=$p($g(^PAADM(EpisodeID)),"^",17)
	i type="fromInWard" d
	.s formWardList=##class(web.DHCICUCom).GetWardInInfo("",icuaId,"","","D")
	.s formWard=$p($g(formWardList),"^",3)
	.i formWard'="" s value=$p($g(formWard),"-",2)
	.e  s value="入院"
	.;i formWardList'="" s formWard=$p($p($g(formWardList),"^",3),"-",2)
	.;i formWard'="" s value=formWard
	i type="hospital" d
	.s locId=$p($g(^DHCICUArrange(+icuaId)),"^",2)
	.i locId'="" d
	..s hospitalDr=$P($g(^CTLOC(locId)),"^",22)
	..i hospitalDr'="" s value=$p($g(^CT("HOSP",hospitalDr)),"^",2)
	i type="ICUDay" d //全部天数
	.s value=(outDate-inDate)+1 //i outDate<dischgDate  s value=(outDate-inDate)+1
	.//e  s value=(dischgDate-inDate)+1
	i type="ICUDayByDate" d //按查找日期天数
	.s tmpOutDate=outDate
	.i tdate<outDate s tmpOutDate=tdate
	.s tmpInDate=inDate
	.i fdate>tmpInDate'="" s tmpInDate=fdate
	.s value=(tmpOutDate-tmpInDate)+1
	
	i type="AmountInpatients"  s value=$$GetRYRS^DHCWLBuildKPIData(Amountfdate,Amounttdate) //入院人数，统计组接口
	
	i type="regNo" s value=regNo
	i type="papmiMedicare" s value=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,paadmtype,.ErrMsg)  //$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	i type="patName" s value=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	i type="icuBed" s value=$P($g(^PAWARD(+icuBedId,"BED",+$P(icuBedId,"||",2))),"^",1)
	i type="patSex" s value=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	i type="dateOfBirth" s birDate=$p($g(^PAPER(papmiId,"ALL")),"^",6),value=$zd(birDate,3) //出生日期
	i type="nation" d  //民族	
	.s NationDr=$p($g(^PAPER(papmiId,"PER",2)),"^",1)
	.i NationDr'="" s value=$P(^CT("NAT",NationDr),"^",2)
	i type="patHeight" s value=$p($g(^DHCICUArrange(+icuaId)),"^",24)
	i type="patWeight" s value=$p($g(^DHCICUArrange(+icuaId)),"^",25)
	i type="homeAddres" s value=$g(^PAPER(papmiId,"PER","ADD",1))     // 住址
	i type="homeTel" s value=$p($g(^PAPER(papmiId,"PER",1)),"^",11)   //家庭电话
	i type="workTel" s value=$p($g(^PAPER(papmiId,"PER",1)),"^",9)    //工作电话
	i type="handtel" s value=$p($g(^PAPER(papmiId,"PER",4)),"^",21)   //手机
	i type="admDate" s value=$zd(admDate,3)   //入院日期
	//病人身份(费用类型)
	i type="admRea" d
		.s admReasonId=$piece(^PAADM(EpisodeID,1),"^",7)
		.i admReasonId'="" set value=$piece($get(^PAC("ADMREA",admReasonId)),"^",2)
	
	i type="dischgDate" d
	.q:dischgDate=""
	.s value=$zd(dischgDate,3) //出院日期	
	i type="inWardCause" d //入ICU主要原因
	.s opExecute=$p($g(^DHCICUArrange(+icuaId)),"^",30) //非手术
	.i opExecute="N" d
	..s DCatCLCSODr=$p($g(^DHCICUArrange(+icuaId)),"^",41)
	..i DCatCLCSODr'="" s value=$li(^DHCCLC("Score",$p(DCatCLCSODr,"||",1),"O",$p(DCatCLCSODr,"||",2)),2)
	i type="patSource" d //病人来源
	.s opExecute=$p($g(^DHCICUArrange(+icuaId)),"^",30) //非手术
	.i opExecute="N" d
	..s formWardList=##class(web.DHCICUCom).GetWardInInfo("",icuaId,"","","D")
	..i formWardList'="" s formWard=$p($p(formWardList,"^",3),"-",2)
	..i formWard'="" s value=formWard
	..e  s value="其它医院"	
	.i opExecute="E" s value="急诊手术"
	.i opExecute="B" s value="择期手术"
	i type="patIsOP" d //是否手术
	.s opExecute=$p($g(^DHCICUArrange(+icuaId)),"^",30)
	.i (opExecute="B")||(opExecute="E") s value="是"
	.e  s value="否"
	;i (value'="")&(needNote'="")&(("^"_needNote_"^")'[("^"_value_"^")) q value=""
	q:(value'="") value	
	i $p(type,"~",1)="UnderlyingD" d //基础疾病
	.s UDList=##Class(web.DHCICUCom).GetDHCICUUnderlyingDisease(+icuaId)
	.i UDList'="" d
	..s UDCount=$l(UDList,"^")
	..f i=1:1:UDCount d
	...s UDDr=$p(UDList,"^",i),UDCode=""
	...i UDDr'="" s UDCode=$li($g(^DHCCLC("UnderlyingDisease",UDDr)),1)
	...i ($p(type,"~",2)="FZMS") d //评分描述
	....i ((UDCode="GRH")||(UDCode="MXSGNSJ")) s value="非手术或急诊手术后患者"
	....i ((UDCode="XGNIVJ")||(UDCode="MXXZXZS")) s value="择期手术后患者"
	....i (("^"_"STZLGFZY^AIDS^BXB^MXLBXBXB^GSL^LBL^QTXYXTZL^HUALIAO^LIQUE^MXRYZJB^GSYZ^QTYZ^FSMYB^TPZJSSYS^PQCSH^CSLJP^LZXBPX^XTMYQX"_"^")[("^"_UDCode_"^")) s value="无慢性器官功能不全或免疫抑制"
	....i ($p(type,"~",3)="FZ") d //分值
	.....i (value="非手术或急诊手术后患者") s value="5"
	.....i (value="择期手术后患者") s value="2"
	.....i (value="无慢性器官功能不全或免疫抑制") s value="0"
	...q:($p(type,"~",2)'="")&&(("^"_$p(type,"~",2)_"^")'[("^"_UDCode_"^"))
	...//基础疾病
	...i (("^"_$p(type,"~",2)_"^")[("^"_"MXXZXZS"_"^"))&&($p(type,"~",3)="") s value="慢性阻塞性肺疾病"
	...i (("^"_$p(type,"~",2)_"^")[("^"_"GXB"_"^"))&&($p(type,"~",3)="") s value="冠心病"
	...i (("^"_$p(type,"~",2)_"^")[("^"_"GXY"_"^"))&&($p(type,"~",3)="") s value="高血压"
	...i (("^"_$p(type,"~",2)_"^")[("^"_"TNB"_"^"))&&($p(type,"~",3)="") s value="2型糖尿病"
	...i (("^"_$p(type,"~",2)_"^")[("^"_"GRH"_"^"))&&($p(type,"~",3)="") s value="肝硬化"	
	...i (("^"_$p(type,"~",2)_"^")[("^"_"STZLGFZY^BXB^MXLBXBXB^GSL^LBL^QTXYXTZL"_"^"))&&($p(type,"~",3)="") s value="恶性肿瘤"
	...i (("^"_$p(type,"~",2)_"^")[("^"_"MXSGNSJ"_"^"))&&($p(type,"~",3)="") s value="慢性肾脏病5期"
	...//患病部位
	...i (("^"_$p(type,"~",2)_"^")[("^"_"GRH"_"^"))&&($p(type,"~",3)="BW") s value="肝脏"
	...i (("^"_$p(type,"~",2)_"^")[("^"_"MXSGNSJ"_"^"))&&($p(type,"~",3)="BW") s value="肾脏"
	...i (("^"_$p(type,"~",2)_"^")[("^"_"XGNIVJ"_"^"))&&($p(type,"~",3)="BW") s value="心血管"
	...i (("^"_$p(type,"~",2)_"^")[("^"_"MXXZXZS"_"^"))&&($p(type,"~",3)="BW") s value="呼吸"
	...i (("^"_$p(type,"~",2)_"^")[("^"_"STZLGFZY^AIDS^BXB^MXLBXBXB^GSL^LBL^QTXYXTZL^HUALIAO^LIQUE^MXRYZJB^GSYZ^QTYZ^FSMYB^TPZJSSYS^PQCSH^CSLJP^LZXBPX^XTMYQX"_"^"))&&($p(type,"~",3)="BW") s value="免疫抑制"
	i $p(type,"~",1)="Researchon" d //脓毒症科研研究日停留时间等每天相关数据
	.i (("^"_$p(type,"~",2)_"^")[("^"_"Temper"_"^")) s value=$p($g(^Researchon(icuaId)),"^",2) //add bylyn
	.e  i (("^"_$p(type,"~",2)_"^")[("^"_"HR"_"^")) s value=$p($g(^Researchon(icuaId)),"^",3)
	.e  i (("^"_$p(type,"~",2)_"^")[("^"_"RR"_"^")) s value=$p($g(^Researchon(icuaId)),"^",4)
	.e  i (("^"_$p(type,"~",2)_"^")[("^"_"WBC"_"^")) s value=$p($g(^Researchon(icuaId)),"^",5)
	.e  i (("^"_$p(type,"~",2)_"^")[("^"_"NSBP"_"^")) s value=$p($g(^Researchon(icuaId)),"^",6) ;收缩压
	.e  i (("^"_$p(type,"~",2)_"^")[("^"_"MAP"_"^")) s value=$p($g(^Researchon(icuaId)),"^",7) 	;平均动脉压
	.e  d
		..s value=..GetInWardInfoByIcuaId(icuaId,type,inDate,inTime,outDate,outTime,oeoriNote)
		..s value=$p(value,"/",1)
	;i $p(type,"~",1)="ApacheCreatinine" d //血肌酐未测
	;.s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,"ApacheCreatinine",inDate,"0:00",inDate+6,"23:59:59","First","","","","")
	;.i value="" s value="是"
	;i $p(type,"~",1)="SOFASoterocyte" d //血小板未测
	;.s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,"SOFASoterocyte",inDate,"0:00",inDate+6,"23:59:59","First","","","","")
	;.i value="" s value="是"
	;i $p(type,"~",1)="SOFAHematoidin" d //胆红素未测
	;.s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,"SOFAHematoidin",inDate,"0:00",inDate+6,"23:59:59","First","","","","")
	;.i value="" s value="是"
	//血肌酐/血小板/胆红素/肾上腺素/去甲肾/多巴胺/多巴酚丁胺/sofa评分/CVP/尿量/6h尿量/12h尿量/24h尿量/晶体液/胶体液/置换液/超滤量未用
	i ($p(type,"~",1)="ApacheCreatinine")||($p(type,"~",1)="SOFASoterocyte")||($p(type,"~",1)="SOFAHematoidin")||($p(type,"~",1)="SPOAepinephrine")||($p(type,"~",1)="SOFANoradrenaline")||($p(type,"~",1)="SOFAdopamine")||($p(type,"~",1)="AdopamineDobu")||($p(type,"~",1)="SOFATotal")||($p(type,"~",1)="CVP")||($p(type,"~",1)="nyndgnl")||($p(type,"~",1)="SexNL")||($p(type,"~",1)="TwelveNL")||($p(type,"~",1)="TwentyFourNL")||($p(type,"~",1)="JinTY")||($p(type,"~",1)="JiaoTY")||($p(type,"~",1)="ZHY")||($p(type,"~",1)="CLL")  d
	.s ifVal=0
	.f j=1:1:7 d	
	..s tmpType=type_j
	..s value=..GetInWardInfoByIcuaId(icuaId,tmpType,inDate,inTime,outDate,outTime,oeoriNote)
	..i ($p(value,"/",2)="1") s ifVal=$p(value,"/",2) q	
	.i (ifVal="0") s value="是"
	.e  s value=""	
	q:(value'="") value
	i type="diag" d
		.s value=##Class(web.DHCClinicCom).GetMRDiagnos($P(^PAADM(EpisodeID),"^",61))
		.;w "EpisodeID="_EpisodeID_"/"_$P(^PAADM(EpisodeID),"^",61)_"/"_value,!
	i type="papmiDecease" d
		.s DeceStatus= $p($g(^DHCICUArrange(icuaId)),"^",43)
		.i DeceStatus="D" s value="是"
		.e  s value="否" 
		.i (dataField="DateTime") D 
		..i (DeceStatus="D") s value=$zd(outDate,3)_" "_$zt(outTime,2)
		..e  d  s value=""			
	i type="autoLeave" d
	.i $p($g(^DHCICUArrange(icuaId)),"^",43)="A" s value="是"
	.e  s value="否"
	.;e  i $p($g(^DHCICUArrange(icuaId)),"^",43)="" s value=$p(^PAPER(papmiId,"ALL"),"^",12)
	i type="icuInDateTime" s value=$zd(inDate,3)_" "_$zt(inTime,2)
	i type="MechanVentilation" d
		.s mechHour=$p($g(^DHCICUArrange(+icuaId)),"^",47) ;有创呼吸机（小时）
		.i (+mechHour)'=0 s value="是"
		.e  s value="否"
	i type="CrrtHour" d
		.s crrtHour=$p($g(^DHCICUArrange(+icuaId)),"^",52) ;CRRT（小时）
		.i (+crrtHour)'=0 s value="是"
		.e  s value="否"
	i type="LimitedTreatment" d
		.s limiteTreat=$p($g(^DHCICUArrange(+icuaId)),"^",81) //限制治疗
		.i (refValue'="")&&(refValue=limiteTreat) s value="是"
		.e  s value="否"
		.i (dataField="DateTime") d
			..i (refValue'="")&&(refValue=limiteTreat)  s value=$zd(outDate,3)_" "_$zt(outTime,2)
			..e  s value="" 
	i type="IsOutICU" d
		.i inWardPat s value="否"
		.e  d  s value="是"
	i type="icuOutDateTime" d
		.i inWardPat s value="在科"
		.e  s value=$zd(outDate,3)_" "_$zt(outTime,2)
	i type="icuaId" s value=icuaId
	i type="RateOfReturn24" s value=icuaId
	i type="ICUADeathProbability" s value=$fn($p(^DHCICUArrange(icuaId),"^",42),"",3)
	s icuHour=##class(web.DHCClinicCom).CalculateDuration(inDate,inTime,outDate,outTime,"H")
	i type="ICUAInfectedSite" d
		.s value=$p(^DHCICUArrange(icuaId),"^",31)  //mfc 20140619感染部位
		.i value="None" s value=""
	i type="ICUAShockType" d
		.s value=$p(^DHCICUArrange(icuaId),"^",32) 	//休克类型
		.i value["感染性" s value="是"
		.i value="None" s value=""
	i type="ICUASepsis" d //脓毒症患者
		.s value=..JudgeSepsisStandard(icuaId)
		.w "        ICUASepsis=============="_value,!
		.//i value=1 b
		.i value=1 s value="是"
		.e  s value="否" 
	q:(value'="") value
	i type="ICUALeaveCondition" d
		.//w icuHour_" durationHour="_durationHour,!
		.q:(durationHour'="")&(icuHour>durationHour)
		.//w "||||||||set:"
		.s value=$p(^DHCICUArrange(icuaId),"^",43)
		.s val=value
		.s value=$s(val="":"",val="D":"死亡",value="T":"转科",value="A":"自动出院",value="M":"可出院",value="O":"外出治疗")
		.//w "val="_val_"/"_value,!
	//数值型
	i type="ICUPreInterval" d
		.s value=##class(web.DHCICUCom).GetPreIcuaIdInterval(icuaId)
		.//w "Interval="_value,!
	i type="48ICUPre" s value=##class(web.DHCCLScore).GetFYQ(icuaId,fdate,48)
	i type="24ICUPre" s value=##class(web.DHCCLScore).GetFYQ(icuaId,fdate,24)
	i type="ICUHour" s value=icuHour
	i type="LeaveDay" d
		.q:$p(^DHCICUArrange(icuaId),"^",43)=""
		.s value=(outDate-inDate)+1
		.//s value=outDate-inDate
	i type="LeaveHour" d
		.q:$p(^DHCICUArrange(icuaId),"^",43)=""
		.s value=icuHour
	i (value'="")&(needNote'="")&(("^"_needNote_"^")'[("^"_value_"^")) s value=""
	//i type="ICUALeaveCondition" w needNote," after neednote/value "_value
	i type="GCSTotalScore" s value=$p($g(^DHCICUArrange(+icuaId)),"^",36) //glasgow评分
	i type="ApacheTotalScore" d
	.s value=$p($g(^DHCICUArrange(+icuaId)),"^",40) //ApacheTotalScore
	.i +value=0 d   //update by lyn 20160405
		..s icuOId="",IsQuit=0,apacheQty=""
		..s icucriId=##class(web.DHCICUCom).GetIcuriIdByCode("ApacheTotalScore")
		..f  s icuOId=$o(^DHCICUOrder(0,"Arr",icuaId,icuOId)) q:(icuOId="")!(IsQuit=1)  d
			...s icuComOId=$p($g(^DHCICUOrder(icuOId)),"^",2)
			...q:icucriId'=icuComOId
			...s apacheQty=$p($g(^DHCICUOrder(icuOId)),"^",11)
			...s IsQuit=1
		..s value=apacheQty
	
	i type="SurgeryType" s value=$p($g(^DHCICUArrange(+icuaId)),"^",86) //内科ICU收治类型20151223whl

	
	i $p(type,"~",1)="Score" d //Apache评分
	.i $p(type,"~",2)="ApacheTotalScore" s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,"ApacheTotalScore",inDate,inTime,inDate+1,inTime,"First","","","","")
	.i $p(type,"~",2)="ApacheAgeNumScore" s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,"ApacheAgeNumScore",inDate,inTime,inDate+1,inTime,"First","","","","")
	.i $p(type,"~",2)="ApacheCHPScore" s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,"ApacheCHPScore",inDate,inTime,inDate+1,inTime,"First","","","","")
	.i $p(type,"~",2)="ApacheAPSScore" d
	..s ApacheTotal=##class(web.DHCICUOrder).GetRecordValue(icuaId,"ApacheTotalScore",inDate,inTime,inDate+1,inTime,"First","","","","")
	..s ApacheAge=##class(web.DHCICUOrder).GetRecordValue(icuaId,"ApacheAgeNumScore",inDate,inTime,inDate+1,inTime,"First","","","","")
	..s ApacheCHP=##class(web.DHCICUOrder).GetRecordValue(icuaId,"ApacheCHPScore",inDate,inTime,inDate+1,inTime,"First","","","","")
	..s value=ApacheTotal-ApacheAge-ApacheCHP
	..i value<0 s value=""
	q:(value'="") value

	i type="ReInTube" d
		.s inTube=##class(web.DHCICUOrder).GetRecordValue(icuaId,6047,fdate,0,tdate,86399,"First")
		.q:inTube=""
		.s inTubeDateTime=##class(web.DHCICUOrder).GetRecordValue(icuaId,6047,fdate,0,tdate,86399,"First","","","","DateTime")
		.//w "inTubeDateTime="_inTubeDateTime,!
		.q:inTubeDateTime=""
		.s inTubeDate=##class(web.DHCClinicCom).ConvertToDateH($p(inTubeDateTime," "))
		.s inTubeTime=##class(web.DHCClinicCom).ConvertToTimeH($p(inTubeDateTime," ",2))
		.s outTube=##class(web.DHCICUOrder).GetRecordValue(icuaId,6057,inTubeDate-2,inTubeTime,inTubeDate,inTubeTime,"First")
		.i outTube'="" s value=1
		.//w inTubeDate_"/"_inTubeTime,"/       value="_value,!
		.q
		.s tubeSum=0 //48小时再插气管病例数
		.s arcimDesc="气管插管术E0078"  //30156
		.//s clScoreRecordList=..FindCLScoreRecord(fromDate,toDate,RecordItemId,ctlocIdStr,CTMUDesc)
		.//f i=1:1:$l(clScoreRecordList,"$") d
			.//.s clScoreRecord=$p(clScoreRecordList,"$",i)
		.//.s icuaId=$p(clScoreRecord,"^",2)
		.//.q:icuaId=""
		.s EpisodeID=$p(^DHCICUArrange(icuaId),"^",1)
		.//48小时再插气管病例数（非预期）
    	.s oeorInsertStr="",oeorOutStr=""
    	.s oeorInsertStr=##Class(web.DHCICUStat).insertOrOutTube(arcimDesc,EpisodeID)  //插管医嘱
    	.;w EpisodeID_"=====^"_icuaId_"^"_oeorInsertStr_"$",!
    	.i $l(oeorInsertStr,"^")>1 d
    		..s oeorOutStr=##Class(web.DHCICUStat).insertOrOutTube("拔除气管插管",EpisodeID) //拔管医嘱
    		..;w EpisodeID_"^"_icuaId_"^"_oeorOutStr_"$"
    		..w "in2"
    		..f i=1:1:$l(oeorInsertStr,"^") d
    			...w "in3"
    			...s stInsertOneDate=$p(oeorInsertStr,"^",i)
    			...s stInserttwoDate=$p(oeorInsertStr,"^",i+1)
    			...s stOutDate=$p(oeorOutStr,"^",i)
    			...i ((stOutDate>=stInserttwoDate)&&((stOutDate-stInserttwoDate)<=2)) s tubeSum=tubeSum+1
    			...s value=##class(web.DHCClinicCom).CalculateDuration(stInsertOneDate,0,stInserttwoDate,0,"D")
    			...//i retstr="" s retstr=EpisodeID_"^"_icuaId_"^"_$p(clScoreRecord,"^",3)_"^"_$p(clScoreRecord,"^",4)_"^"_$p(clScoreRecord,"^",5)_"^"_icuDay_"^"_$p(clScoreRecord,"^",7)_"^"_$p(clScoreRecord,"^",9)
				...//e  s retstr=retstr_"$"_EpisodeID_"^"_icuaId_"^"_$p(clScoreRecord,"^",3)_"^"_$p(clScoreRecord,"^",4)_"^"_$p(clScoreRecord,"^",5)_"^"_icuDay_"^"_$p(clScoreRecord,"^",7)_"^"_$p(clScoreRecord,"^",9)	
    //s tubeSumScore=5-(tubeSum-1)*2  //48小时再插气管病例数

	
	q:type="patAge" ##class(web.DHCClinicCom).CalAge($p($g(^PAPER(papmiId,"ALL")),"^",6),inDate)
	// 复杂计算的
	i type="wardDesc" d
	.s wardDesc=$p(^PAWARD(+icuBedId),"^",2)
	.s value=$p(wardDesc,"-",2)	
	e  i type="MainDoctor" d
	.s docID=$P($g(^DHCICUArrange(icuaId)),"^",29)
	.q:docID=""
	.s value=$p(##class(web.DHCClinicCom).GetUserTypeName(docID),"^",2)
	e  i type="ResidentDoctor" d
	.s docID=$P($g(^DHCICUArrange(icuaId)),"^",28)
	.q:docID=""
	.s value=$p(##class(web.DHCClinicCom).GetUserTypeName(docID),"^",2)
	e  i (type="icuHour") d
	.;在ICU的小时数
	.;s inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
	.q:inDateTime=""
	.;s inDate=$p(inDateTime,"^"),inTime=$p(inDateTime,"^",2)
	.s inDateTime=inDate+(inTime/100000)
	.;s outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
	.s isCurrPat=0
	.s outDate=+$h,outTime=$p($h,",",2)
	.i outDateTime="" d
		..s outDateTime=$h+($p($h,",",2)/100000)
		..s isCurrPat=1
	.e  d
		..s outDate=$p(outDateTime,"^"),outTime=$p(outDateTime,"^",2)
		..s outDateTime=outDate+(outTime/100000)
	.s icuHour=(outTime-inTime)\3600+((outDate-inDate)*24)
	.i outTime<inTime s icuHour=icuHour-1
	.q:(outDate<inDate)!((outDate=inDate)&(outTime<inTime))
	.s value=icuHour
	e  i type="icuDay" d
	.;s inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
	.q:inDateTime=""
	.;s inDate=$p(inDateTime,"^"),inTime=$p(inDateTime,"^",2)
	.i inDate<=fdate s inDate=fdate	
	.s inDateTime=inDate+(inTime/100000)
	.;s outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
	.s isCurrPat=0
	.i outDateTime="" d
		..;s outDateTime=tdate+(inTime/100000)
		..;s outDate=$p(outDateTime,"^"),outTime=$p(outDateTime,"^",2)
		..;s isCurrPat=1
		..s value=(tdate-inDate)+1
	.e  d				 		
		..s outDate=$p(outDateTime,"^"),outTime=$p(outDateTime,"^",2)
		..i (inDate<=tdate)&&(tdate<outDate) s value=value+1
		..;i (inDate<tdate)&&(tdate<outDate) s value=value+1
		..i outDate>tdate s outDate=tdate 
		..s value=value+(outDate-inDate)		
		..;i tdate<=outDate s outDate=tdate	
		..;s outDateTime=outDate+(outTime/100000)
	.;s icuHour=(outTime-inTime)\3600+((outDate-inDate)*24)
	.;i outTime<inTime s icuHour=icuHour-1
	.;i (outDate<inDate)!((outDate=inDate)&(outTime<inTime)) s icuHour=0
	.;s value=$NUMBER(icuHour/24,0)
	e  i type="ICUGuardDay" d
		.s startDate=$p($g(^DHCICUArrange(+icuaId)),"^",6)
		.s startTime=+$p($g(^DHCICUArrange(+icuaId)),"^",8)
		.s inWardDateTimeStr=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
		.s inWardDate=startDate,inWardTime=startTime
		.i inWardDateTimeStr'=" " d
			..s inWardDate=$p(inWardDateTimeStr,"^"),inWardTime=$p(inWardDateTimeStr,"^",2)
		.s inWardDateTime=inWardDate+(inWardTime/100000)
		.s outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
		.s curDateTime=$h+($p($h,",",2)/100000)
		.i outDateTime="" s curDate=($p($h,",",1))
		.e  s curDate=$p(outDateTime,"^")
		.s wardInOutNote=""
		.i outDateTime="" d
			..;s duration=curDateTime-inWardDateTime
			..;i duration>1 s value=$p(duration,".")_"天(在院)"
			..;e  s value="<1天(在院)"
			..s value=(curDate-inDate)+1
		.e  d
			..;s outDate=$p(outDateTime,"^",1),outTime=$p(outDateTime,"^",2)
			..;s outDateTime=outDate+(outTime/100000)
			..;s leavePat=0
			..;s duration=outDateTime-inWardDateTime
			..;i duration>1 s value=$p(duration,".")_"天"
			..;e  s value="<1天"
			..s outDate=$p(outDateTime,"^",1),outTime=$p(outDateTime,"^",2)
			..s value=(outDate-inDate)+1
		.i outDateTime="" s outDate=+$h,outTime=$p($h,",",2)
		.e  d
			..s outDate=$p(outDateTime,".",1)
			..s outTime=(outDateTime-outDate)*100000
	i $p(type,"~",1)="CommonConst" d //打印固定常量 BY LYN 20160127
	.i $p(type,"~",2)=+($p(type,"~",2)) s value=$p(type,"~",2)
	.i $p(type,"~",2)="Yes" s value="是"
	.i $p(type,"~",2)="No" s value="否"	
	
	s ret=..JudgeSepsisStandard(icuaId)
	i type="SepsisZeroDurHour" d //脓毒症零点时间间隔
	.i ret=1 s value=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"",""," ","")	
	i type="UseAntibiotic" d
	.i ret=1 s value="是"	
	i type="MainDiag" d //病案首页出院主诊断
	.s MainDiagDesc=##Class(EMRservice.Tools.EMRRecordDataExport).GetFirstPageDiagByAdm(EpisodeID)
	.s value=$TRANSLATE($p($p(MainDiagDesc,$c(1),4),"^",1)," ")
	i type="OtherDiag" d //病案首页出院其他诊断
	.s OtherDiagDesc=##Class(EMRservice.Tools.EMRRecordDataExport).GetFirstPageDiagByAdm(EpisodeID)
	.s value=$TRANSLATE($p($p(OtherDiagDesc,$c(1),5),"^",1)," ")
	i type="OpDiag" d //病案首页门（急）诊诊断
	.s OpDiagDesc=##Class(EMRservice.Tools.EMRRecordDataExport).GetFirstPageDiagByAdm(EpisodeID)
	.s value=$TRANSLATE($p($p(OpDiagDesc,$c(1),1),"^",1)," ")	
	//i type="LQXPY" d
	//.i ret=1 s value="是"	
	q value
}

/// w ##class(web.DHCICUStat).FindIcuInquiry("56^2166",2)
/// w ##class(web.DHCICUStatTEST).FindIcuInquiry(39,14,"2017-5-20","2017-6-2","I")
/// w ##class(web.DHCICUStat).FindIcuInquiry(28,15,"2016-8-1","2016-8-31","I")
/// w ##class(web.DHCICUStat).FindIcuInquiry(28,65,"2016-4-1","2016-4-9","I")
/// dateForWardType:空为入病区时间,I为在病区时间,
ClassMethod FindIcuInquiry(ctlocIdStr, icuciId, inquiryFromDate, inquiryToDate, dateForWardType = "", inquiryFromTime = "", inquiryToTime = "", needIcuaId = "", needIcuciiSub = "") As %String
{
	k ^DHCICUDebug
	i (icuciId=54)!(icuciId=51)!(icuciId=50)!(icuciId=34)!(icuciId=35)!(icuciId=55) q ##class(web.DHCICULyn).FindIcuInquiry(ctlocIdStr, icuciId, inquiryFromDate, inquiryToDate, dateForWardType) 
	;i (icuciId=14)!(icuciId=78) q ##class(web.DHCICUStatTEST).FindIcuInquiry(ctlocIdStr, icuciId, inquiryFromDate, inquiryToDate, dateForWardType) 
    k ^TMPDHCICUInquiry
	k ^DHCICUInquiryMainNurse
	s curWardLocId=$lg(^DHCICUCInquiry(icuciId),3)
	k ^TEMPWHL(icuciId)
    k ^DHCICUInquiryInOutHospital
	k ^DHCICUInquiry("userId")
	k ^DHCICUInquiry(+icuciId)
	k ^TEMPWHL("LabEpisodeNo")
	k ^TEMPDHCICUInquiryWHL
	k ^DHCICUInquiryJXKH
	k ^TMPICU("Test") //查询检验数据清空
	k ^TMPDHCPATION("regNo") 
	k ^TMPICU("labNo")
	k ^Researchon  ; add by lyn 脓毒症诊断sheet的条件
	q:icuciId="" -11
	k ^DHCICUInquiry(+icuciId),^DHCICUInquiry(icuciId,"F")
	s sumStr="",orderCategory=""
	s ^DHCICUInquiry(+icuciId,"count")=0
	s leaveCount=0,leaveDayPos=0,CirculVelocityPos=0,ScorePos=0,ScoreCount=0 //计算APPCHEII平均分数数量
	i $d(^DHCICUPara(0,"Ctloc",ctlocIdStr)) d	
		.;若在科室模板中已配置
		.s retStr=$$FindIcuInquiryByWardId(ctlocIdStr,icuciId,inquiryFromDate,inquiryToDate,dateForWardType,inquiryFromTime,inquiryToTime)
	e  d
		.;科室模板中未配置,认为是科室,查找出相应病区
		.s sub=0,wardLocIdStr=""
		.f  s sub=$O(^CTLOC(ctlocIdStr,"LINK",sub)) q:sub=""  d
			..s wardLocId=^CTLOC(ctlocIdStr,"LINK",sub)
			..q:'$d(^DHCICUPara(0,"Ctloc",wardLocId))
			..i wardLocIdStr'="" s wardLocIdStr=wardLocIdStr_"^"
			..s wardLocIdStr=wardLocIdStr_wardLocId
		.w ctlocIdStr_"    main/"_inquiryFromDate_"/"_inquiryToDate,!
		.s retStr=$$FindIcuInquiryByWardId(wardLocIdStr,icuciId,inquiryFromDate,inquiryToDate,dateForWardType,inquiryFromTime,inquiryToTime)
		.w "retStr="_retStr,!
	i sumStr'="" d
		.//s count=^DHCICUInquiry(+icuciId,"count")+1
		.s count=$o(^DHCICUInquiry(icuciId,"F",""),-1)
		.w count,!
		.q:+count=0
		.s count=count+10000
		.i leaveDayPos>0,leaveCount>0 d
			..i inquiryToDate'<inquiryFromDate s $p(sumStr,"^",CirculVelocityPos)=$fn(leaveCount/15,"",2)
			..s $p(sumStr,"^",leaveDayPos)=$fn($p(sumStr,"^",leaveDayPos)/leaveCount,"",2)
		.i (ScorePos>0)&&(ScoreCount>0) s $p(sumStr,"^",ScorePos)=$fn($p(sumStr,"^",ScorePos)/ScoreCount,"",2) //计算平均分数
		.w "sum     "_sumStr,!
		.//汇总计算
		.s icuciiSub=0
		.f  s icuciiSub=$o(^DHCICUCInquiry(icuciId,"I",icuciiSub)) q:icuciiSub=""  d
			..i "^Percent^PerThousand^Multiply^Divide^"[("^"_$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),24)_"^") d
				...s delimter="*"
				...i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),24)="Percent" s delimter="/"
				...i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),24)="PerThousand" s delimter="/"
				...i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),24)="Divide" s delimter="/"
				...i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),24)="Multiply" s delimter="*"
				...s icuciiCalculateExpression=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),30)
				...s part=$p(icuciiCalculateExpression,delimter,1)
				...s total=$p(icuciiCalculateExpression,delimter,2)
				...s part=##class(web.DHCClinicCom).Replace(part,"-","+-")
				...s total=##class(web.DHCClinicCom).Replace(total,"-","+-")
				...s partSum=0,totalSum=0
				...f iItem=1:1:$l(part,"+") d
					....s item=$p(part,"+",iItem)
					....q:item=""
					....s itemPos=$lg($g(^DHCICUCInquiry(icuciId,"I",$zabs(item))),20)
					....s partSum=(item/$zabs(item))*$p(sumStr,"^",itemPos)+partSum
				...f iItem=1:1:$l(total,"+") d
					....s item=$p(total,"+",iItem)
					....q:item=""
					....s itemPos=$lg($g(^DHCICUCInquiry(icuciId,"I",$zabs(item))),20)
					....s totalSum=(item/$zabs(item))*$p(sumStr,"^",itemPos)+totalSum
				...i totalSum>0 w "partSum="_partSum_"/totalSum"_totalSum_"/"_(partSum/totalSum),!
				...q:totalSum=0
				...i delimter="*" s value=partSum*totalSum
				...i delimter="/" s value=partSum/totalSum
				...q:value=""
				...i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),24)="Percent" s value=value*100
				...i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),24)="PerThousand" s value=value*1000
				...s pos=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),20)
				...q:(pos<1) //!(partPos<1)!(totalPos<1)
				...s $p(sumStr,"^",pos)=$fn(value,"",2)
			..i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),24)="Average" d
				...s itemPos=$lg($g(^DHCICUCInquiry(icuciId,"I",icuciiSub)),20)
				...
				...s curStr=$p(sumStr,"^",itemPos)
				...w itemPos_" curStr="_curStr,!
				...q:+$p(curStr,"/",2)=0
				...s $p(sumStr,"^",itemPos)=$fn(($p(curStr,"/",1)/$p(curStr,"/",2)),"",2)
		.s ^DHCICUInquiry(icuciId,count)=sumStr
		.w "sum     "_sumStr,!
	m ^DHCICUDebug=^DHCICUInquiry($j,icuciId) //temp
	m ^DHCICUDebug(1)=^DHCICUInquiry(icuciId,0) //temp
	q 0

FindIcuInquiryByWardId(ctlocIdStr, icuciId, inquiryFromDate, inquiryToDate, dateForWardType = "",inquiryFromTime = "",inquiryToTime = "")
	s preDT=$h
	w "ctlocIdStr="_ctlocIdStr,!
	q:ctlocIdStr="" -1
	q:icuciId="" -2
	s pos=0,titleStr=""
	k posList
	//s icuciIsByDate=$lg(^DHCICUCInquiry(icuciId),9)
	//i 'icuciIsByDate s inquiryFromDate="",inquiryToDate="" //!!!!日期是否生效
	w ctlocIdStr_"    first/"_inquiryFromDate_"/"_inquiryToDate,!
	s inquiryFromDate=##class(web.DHCClinicCom).ConvertToDateH(inquiryFromDate)
	s inquiryToDate=##class(web.DHCClinicCom).ConvertToDateH(inquiryToDate)
	s inquiryFromTime=##class(web.DHCClinicCom).ConvertToTimeH(inquiryFromTime,"")
	s inquiryToTime=##class(web.DHCClinicCom).ConvertToTimeH(inquiryToTime,"")
	
	w ctlocIdStr_"    second/"_inquiryFromDate_"/"_inquiryToDate_"/"_inquiryFromTime_"/"_inquiryToTime,!
	
	s firstIcuaId=$o(^DHCICUArrange(0))
	s startAppDate=$p($g(^DHCICUArrange(firstIcuaId)),"^",12) //开始使用日期
	i inquiryFromDate<startAppDate s inquiryFromDate=startAppDate
	i inquiryToDate>$h s inquiryToDate=+$h
	q:inquiryToDate<inquiryFromDate 0
	s icuaId="",dayIcuaCount=0
	f  s icuaId=$o(^DHCICUOrder(0,"SttDateTime",inquiryToDate-1,icuaId)) q:icuaId=""  d
		.s dayIcuaCount=dayIcuaCount+1
	s toDateIcuaId=$o(^DHCICUArrange(0,"SDate",inquiryToDate,""),-1)+100 //冗余，保证转科与执行跨天正常
	s icuaSearch=0
	i toDateIcuaId<((inquiryToDate-inquiryFromDate)*dayIcuaCount) s icuaSearch=1
	i dateForWardType="I" s icuaSearch=1
	w ctlocIdStr_"    /"_dayIcuaCount_"/"_toDateIcuaId_"/"_inquiryFromDate_"/"_inquiryToDate_"/"_icuaSearch,!
	
	//找最大子节点，便于有主项时，先找子项
	s icuciiSub="",mainClusteringSub=""
	f  s icuciiSub=$o(^DHCICUCInquiry(icuciId,"I",icuciiSub),-1) q:icuciiSub=""  d
		.s maxSeqNo(icuciiSub)=icuciiSub
		.s mainIcuciiIdStr=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),27)
		.i mainIcuciiIdStr'="" d
			..f mainIcuciiIdIndex=1:1:$l(mainIcuciiIdStr,"^") d  //或的关联
				...s mainIcuciiId=$p(mainIcuciiIdStr,"^",mainIcuciiIdIndex)
				...s mainIcuciiSub=$p(mainIcuciiId,"||",2)
				...i maxSeqNo(icuciiSub)<mainIcuciiSub s maxSeqNo(icuciiSub)=mainIcuciiSub
			..
	s icuciiSub=0,mainClusteringSub=""
	f  s icuciiSub=$o(^DHCICUCInquiry(icuciId,"I",icuciiSub)) q:icuciiSub=""  d
		.i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),4)=1 d //查找项
			..//q:$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),21)="" //没有等级，默认0!!!!
			..//s searchList(+$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),21),icuciiSub)=""
			..s searchList(icuciiSub,icuciiSub)=""
		.e  d
			..i maxSeqNo(icuciiSub)=icuciiSub s searchSeqno=icuciiSub
			..e  s searchSeqno=maxSeqNo(icuciiSub)+(icuciiSub/10000)
			..s searchList(searchSeqno,icuciiSub)="" //tobe
		.
		.i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),5)=1 d //显示项
			..s posCode=..GetIcuciPosCode(icuciId,icuciiSub)
			..s tmpPosList(+posCode,posCode)=icuciiSub
		.i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),28)="M"
			..s mainClusteringSub=icuciiSub
	
	//调整显示顺序，序号相同的以代码的顺序
	s seqNo=""
	f  s seqNo=$o(tmpPosList(seqNo)) q:seqNo=""  d
		.s posCode=""		
		.f  s posCode=$o(tmpPosList(seqNo,posCode)) q:posCode=""  d
			..s icuciiSub=tmpPosList(seqNo,posCode)
			..s pos=pos+1			
			..s posList(posCode)=pos	
			..s $p(titleStr,"^",pos)=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),2)
			..;w icuciiCode_","_dataField_","_needNote_oeoriNote_","_refValue_"/"_posList(icuciiCode_","_dataField_","_needNote_oeoriNote_","_refValue),!
			..i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)="LeaveDay" s leaveDayPos=pos //平均住院日
			..i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)="CirculVelocity" s CirculVelocityPos=pos
	k tmpPosList
	s ^DHCICUInquiry(icuciId,0)=titleStr
	//w inquiryFromDate_" "_inquiryToDate,!
	s wardIdStr=""
	f i=1:1:$l(ctlocIdStr,"^") d
		.s ctlocId=$p(ctlocIdStr,"^",i)
		.q:ctlocId=""
		.s wardId=$o(^PAWARD(0,"WARD_LocationDR",ctlocId,0))
		.q:wardId=""
		.i wardIdStr'="" s wardIdStr=wardIdStr_"^"
		.s wardIdStr=wardIdStr_wardId
	s icuStr="",icuaSeq=0,searchLevel=1
	s count=^DHCICUInquiry(+icuciId,"count")
	s retstr=$$FindICUArrange(wardIdStr, icuciId, inquiryFromDate, inquiryToDate, dateForWardType, icuaSearch, inquiryFromTime, inquiryToTime)
	;e  s retstr=$$FindUserTotal(wardIdStr, icuciId, inquiryFromDate, inquiryToDate, dateForWardType,icuaSearch)
	q retstr
FindICUArrange(wardIdStr, icuciId, inquiryFromDate, inquiryToDate, dateForWardType = "", icuaSearch="", inquiryFromTime = "", inquiryToTime = "")
	//w "FindICUArr  inquiryFromDate="_inquiryFromDate," inquiryToDate="_inquiryToDate," dateForWardType="_dateForWardType," icuaSearch="_icuaSearch,!
	///s ^mfcTemp(icuciId)="FindICUArr  inquiryFromDate="_inquiryFromDate_" inquiryToDate="_inquiryToDate_" dateForWardType="_dateForWardType_" icuaSearch="_icuaSearch
	s count=..InitIcuaSearch(wardIdStr, icuciId, inquiryFromDate, inquiryToDate, dateForWardType, icuaSearch, needIcuaId)
	s count=0
	s papmiId="",tRegNo=""
	w "FindICUArr begin output  inquiryFromDate="_inquiryFromDate," inquiryToDate="_inquiryToDate,!
	s ifDebug=1
	s icuciDataType=$lg(^DHCICUCInquiry(icuciId),10)
	w icuciDataType,icuciId,!
	s icuaSeq=0,tmpCount=0,maxToTime=$p($h,",",2)
	f  s icuaSeq=$o(^DHCICUInquiry(icuciId,"F",icuaSeq)) q:icuaSeq=""  d  //每个icuaId可能有多项
		.;i (icuaId=11460) b "11460"
		.s icuaId=icuaSeq //^DHCICUInquiry(icuciId,"F",icuaSeq)
		.s needExactDate="",needExactTime=""
		.i icuaId'=+icuaId d  //icuaSeq由icuaId、date、time用"^"分隔
			..s icuaId=+icuaId
			..s needExactDate=$p(icuaSeq,",",2)
			..s needExactTime=$p(icuaSeq,",",3)
		.w "icuaId="_icuaId_"/"_needExactDate,"/"_needExactTime,!
		.//s ^DHCICUInquiry(+icuciId,"icuaId",icuaId)=icuaId
		.s value=$p(^DHCICUArrange(icuaId),"^",43) //转科状态
		.s EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
		.s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	    .s tRegNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)  //登记号20160527 whl
		.;s ICUAChargeNurseCTCPdr=$p($p(##class(web.DHCICUArrange).GetMainNurse(EpisodeID),"^",1),"!",1) //主管护士1
		.;i ICUAChargeNurseCTCPdr'="" s ICUAChargeNurseDr=$o(^SSU("SSUSR",0,"CTPCP",ICUAChargeNurseCTCPdr,""))	
		.s ICUAChargeNurseDr=$p(^DHCICUArrange(icuaId),"^",60)	
		.i ICUAChargeNurseDr'="" s ^DHCICUInquiryInOutHospital(+icuciId,"InHospital",ICUAChargeNurseDr)=+$g(^DHCICUInquiryInOutHospital(+icuciId,"InHospital",ICUAChargeNurseDr))+1   //主管护士1收治病人数
	    .i ICUAChargeNurseDr'="" s ^DHCICUInquiryMainNurse(icuciId,ICUAChargeNurseDr)=""
        .s value=$p(^DHCICUArrange(icuaId),"^",43) //转科状态
	    .i ICUAChargeNurseDr'="" s OutHospital=$g(^DHCICUInquiryInOutHospital(+icuciId,"OutHospital",ICUAChargeNurseDr))
	    .i (ICUAChargeNurseDr'="")&&(value'="")&&("AT"[value) s ^DHCICUInquiryInOutHospital(+icuciId,"OutHospital",ICUAChargeNurseDr)=OutHospital+1   //出院及转科数目
	    .i ICUAChargeNurseDr'="" s ^DHCICUInquiryInOutHospital(+icuciId,"icuaId",ICUAChargeNurseDr,icuaId)=""
		.
		.
		.;s ICUAChargeNurseCTCPdr2=$p($p(##class(web.DHCICUArrange).GetMainNurse(EpisodeID),"^",2),"!",1) //主管护士2
		.;i ICUAChargeNurseCTCPdr2'="" s ICUAChargeNurseDr2=$o(^SSU("SSUSR",0,"CTPCP",ICUAChargeNurseCTCPdr2,""))
		.s ICUAChargeNurseDr2=$p(^DHCICUArrange(icuaId),"^",61)
		.i ICUAChargeNurseDr2'="" s ^DHCICUInquiryInOutHospital(+icuciId,"InHospital2",ICUAChargeNurseDr2)=+$g(^DHCICUInquiryInOutHospital(+icuciId,"InHospital2",ICUAChargeNurseDr2))+1   //主管护士2收治病人数
	    .i ICUAChargeNurseDr2'="" s ^DHCICUInquiryMainNurse(icuciId,ICUAChargeNurseDr2)=""
        .i ICUAChargeNurseDr2'="" s OutHospital2=$g(^DHCICUInquiryInOutHospital(+icuciId,"OutHospital2",ICUAChargeNurseDr2))
	    .i (ICUAChargeNurseDr2'="")&&(value'="")&&("AT"[value) s ^DHCICUInquiryInOutHospital(+icuciId,"OutHospital2",ICUAChargeNurseDr2)=OutHospital2+1   //出院及转科数目
	    .i ICUAChargeNurseDr2'="" ;s ^DHCICUInquiryInOutHospital(+icuciId,"icuaId",ICUAChargeNurseDr2,icuaId)=""
	    .
	    .
		.s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
		.s patWeight=$p(^DHCICUArrange(icuaId),"^",25)
		.s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
		.s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
		.//w icuStr,!
		.s inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D") //获取入病区时间 add mfc 20140609
		.s outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D") //获取出病区时间
		.s outType=$p(outDateTime,"^",3)
		.s isCurrPat=0
		.s outDate="",outTime=""
		.i outDateTime="" d
			..s outDateTime=$h+($p($h,",",2)/100000)
			..s outDate=+$h,outTime=$p($h,",",2)
			..s isCurrPat=1
		.e  d
			..s outDate=$p(outDateTime,"^"),outTime=$p(outDateTime,"^",2)
			..s outDateTime=outDate+(outTime/100000)
		.i inDateTime'="" d
			..s inDate=$p(inDateTime,"^"),inTime=$p(inDateTime,"^",2)
			..s inDateTime=inDate+(inTime/100000)
		.s inDate=$p(inDateTime,"."),inTime=(inDateTime-inDate)*100000
		.s outDate=$p(outDateTime,"."),outTime=(outDateTime-outDate)*100000		
		.w "in,out DateTime="_inDateTime_"/"_outDateTime,!
		.s icuStr=""
		.s icuciiSub=0
		.
		.s searchLevel="",ifQuitSearch=0
		.f  s searchLevel=$o(searchList(searchLevel)) q:(searchLevel="")!(ifQuitSearch)  d  //组织查找顺序
			..f  s icuciiSub=$o(searchList(searchLevel,icuciiSub)) q:(icuciiSub="")!(ifQuitSearch)  d //查找项筛选
				...q:(needIcuciiSub'="")&(needIcuciiSub'=icuciiSub)
				...s posCode=..GetIcuciPosCode(icuciId,icuciiSub)
				...s startDate=inDate,startTime=inTime
				...s durationHour=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),13)
				...s icuciiStartDateTime=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),12)
				...s icuciFromTime=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),15)
				...s icuciToTime=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),16)
				...s endDate=outDate,endTime=outTime
				...i durationHour'="" d 
					....s durationDay=durationHour\24
					....s durationSecond=60*(durationHour-(durationDay*24))
					....s endDate=startDate+durationDay
					....s endTime=startTime+durationSecond
					....i endTime>86399 d
						.....s endDate=endDate+1
						.....s endTime=endTime-86400
				...i (endDate>outDate)!((endDate=outDate)&(endTime>outTime)) d
					....s endDate=outDate,endTime=outTime
				...;w icuaId_"/startEndDateTime: "_startDate_"/"_startTime_"/"_endDate_"/"_endTime,!
				...s exactTime=##class(web.DHCClinicCom).ConvertToTimeH($lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),17),"")
				...s curFromDate=inquiryFromDate
				...s curToDate=inquiryToDate
				...s curFromTime=inquiryFromTime, curToTime=inquiryToTime				
				...i curFromTime="" s curFromTime=0
				...i curToTime="" s curToTime=maxToTime
				...s findFromDate=inquiryFromDate,findToDate=inquiryToDate  //目前用于医嘱O、检验L，按日期ypz
				...s findFromTime=curFromTime,findToTime=curToTime			
				...i icuciFromTime'="" d
					....i icuciToTime="" s icuciToTime=icuciFromTime
					....i needExactDate'="" d //数据按时间点排序
						.....s dateTimeStr=##class(web.DHCClinicCom).DateTimeAdd(needExactDate,needExactTime,-icuciFromTime)
						.....s curFromDate=$p(dateTimeStr,"^",1),curFromTime=$p(dateTimeStr,"^",2)
						.....s dateTimeStr=##class(web.DHCClinicCom).DateTimeAdd(needExactDate,needExactTime,icuciToTime)
						.....s curToDate=$p(dateTimeStr,"^",1),curToTime=$p(dateTimeStr,"^",2)
					....i (icuciDataType'="D") d
						.....q:icuciiStartDateTime="PartialSum"
						.....i icuciiStartDateTime="InWardDateTime" d
							......s findFromDate=inDate,findFromTime=inTime,findToDate=inDate,findToTime=inTime
						.....i icuciiStartDateTime="OutWardDateTime" d
							......s findFromDate=outDate,findFromTime=outTime,findToDate=outDate,findToTime=outTime						
						.....s dateTimeStr=##class(web.DHCClinicCom).DateTimeAdd(findFromDate,findFromTime,icuciFromTime)
						.....s findFromDate=$p(dateTimeStr,"^",1),findFromTime=$p(dateTimeStr,"^",2)
						.....s dateTimeStr=##class(web.DHCClinicCom).DateTimeAdd(findToDate,findToTime,icuciToTime)
						.....s findToDate=$p(dateTimeStr,"^",1),findToTime=$p(dateTimeStr,"^",2)
						.....
						.....s curFromDate=findFromDate,curFromTime=findFromTime  //暂时，以后合为一个
						.....s curToDate=findToDate,curToTime=findToTime
				...s findFromDateTime=findFromDate+(findFromTime/100000)
				...s findToDateTime=findToDate+(findToTime/100000)
				...i (findFromDateTime<inDateTime)&&(icuciiStartDateTime'="OutWardDateTime") s findFromDate=inDate,findFromTime=inTime
				...i (findToDateTime>outDateTime)&&(icuciiStartDateTime'="InWardDateTime") s findToDate=outDate,findToTime=outTime
				...
				...//i icuciiSub=16 w findFromDate_"/"_findToDate_"/"_findFromTime_"/"_findToTime,! b
				...
				...s icuciiCode=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)
				...s dataField=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),6) //显示字段
				...i dataField="" s dataField="First"
				...s minQty=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),8)
				...s maxQty=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),9)
				...s needNote=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),10) //数据的筛选
				...s refIcucriCode=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),18) //
				...s refIcucriId=""
				...i refIcucriCode'="" s refIcucriId=$o(^DHCICUC("RecordItem",0,"Code",refIcucriCode,""))
				...s refValue=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),19)
				...s sumType=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),24) //汇总用
				...i sumType="" s sumType="First"
				...s minUnit=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),25) //add mfc 20140613间隔分钟单位
				...i minUnit="" s minUnit="60"
				...s oeoriNote=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),14) //持续泵用
				...s LevelIf=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),21) //筛选层
				...//w icuciId_","_icuciiSub b
				...s mainIcuciiIdStr=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),27) //关联主项
				...s mainItemCount=0,mainItemStr=""
				...s icuciiIsCludeRemark=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),34) //合并项是否显示子项标题
				...;w icuStr,!
				...i mainIcuciiIdStr'="" d //主项过滤，组织计算项的值和数量
					....f mainIcuciiIdIndex=1:1:$l(mainIcuciiIdStr,"^") d  //或的关联
						.....//q:mainItemCount>0
						.....s mainIcuciiId=$p(mainIcuciiIdStr,"^",mainIcuciiIdIndex)
						.....s mainIcuciiSub=$p(mainIcuciiId,"||",2)
						.....s mainPosCode=0
						.....q:mainIcuciiSub=""
						.....s mainIcuciiCode=$lg(^DHCICUCInquiry(icuciId,"I",mainIcuciiSub),1)
						.....s mainPosCode=..GetIcuciPosCode(icuciId,mainIcuciiSub)
						.....i $p(icuStr,"^",$g(posList(mainPosCode)))'="" d //有主项
							......s mainItemCount=mainItemCount+1
							......i ($lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3)="C") d //计算项之一：主项组合
								.......s attachStr="" //多个主项或关系时，项目备注说明
								.......i icuciiIsCludeRemark d
									........i ($lg(^DHCICUCInquiry(icuciId,"I",mainIcuciiSub),3)="R") d
										.........q:("^^Min^Max^"'[("^"_$lg(^DHCICUCInquiry(icuciId,"I",mainIcuciiSub),6)_"^"))
										.........s mainIcucriId=$o(^DHCICUC("RecordItem",0,"Code",mainIcuciiCode,""))
										.........q:mainIcucriId=""
										.........s attachStr=$p($g(^DHCICUC("RecordItem",mainIcucriId)),"^",2)
									........i ($lg(^DHCICUCInquiry(icuciId,"I",mainIcuciiSub),3)="L") d
										.........q:("^^Min^Max^"'[("^"_$lg(^DHCICUCInquiry(icuciId,"I",mainIcuciiSub),6)_"^"))
										.........s attachStr=mainIcuciiCode
									........i ($lg(^DHCICUCInquiry(icuciId,"I",mainIcuciiSub),3)="C") d
										.........s attachStr=$lg(^DHCICUCInquiry(icuciId,"I",mainIcuciiSub),2)
									........i attachStr'="" s attachStr=attachStr_":"
								.......i mainItemStr'="" s mainItemStr=mainItemStr_" "
								.......//i icuciiSub=6 w "    "_mainIcuciiSub_"/"_icuciiSub_"/"_mainItemStr_"/"_attachStr b
								.......s mainItemStr=mainItemStr_attachStr
								.......s mainItemStr=mainItemStr_$p(icuStr,"^",$g(posList(mainPosCode)))
						.....i icuciiStartDateTime="MainDateTime" d	//按主项时间
							......q:mainIcuciiIdIndex>1 //多个主项只有第一个主项起作用
							......s findMainExeDTList=$g(^TmpICUOeoriSDt(icuaId,mainIcuciiSub))
							......q:findMainExeDTList=""
							......f j=1:1:$l(findMainExeDTList,"#") d
								.......s findMainExeDT=$p(findMainExeDTList,"#",j) 							
								.......s findFromDate=##class(web.DHCClinicCom).ConvertToDateH($p(findMainExeDT," ",1))
								.......s findFromTime=##class(web.DHCClinicCom).ConvertToTimeH($p(findMainExeDT," ",2))
								.......s findToDate=findFromDate
								.......s findToTime=findFromTime								
								.......s dateTimeStr=##class(web.DHCClinicCom).DateTimeAdd(findFromDate,findFromTime,icuciFromTime)							
								.......s findFromDate=$p(dateTimeStr,"^",1),findFromTime=$p(dateTimeStr,"^",2)
								.......s findFromDateTime=findFromDate+(findFromTime/100000)								
								.......s dateTimeStr=##class(web.DHCClinicCom).DateTimeAdd(findToDate,findToTime,icuciToTime)								
								.......s findToDate=$p(dateTimeStr,"^",1),findToTime=$p(dateTimeStr,"^",2)
								.......s findToDateTime=findToDate+(findToTime/100000)
						.....;w mainPosCode_"/"_$g(posList(mainPosCode)),"/"_$g(posList(mainPosCode)),"/"_icuStr,!				
				...q:(mainIcuciiIdStr'="")&(mainItemCount<1) //是子项，主项为空则不向下找
				...//w mainIcuciiIdStr_"/"_$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3)_"/"_minQty_"/"_mainItemCount_"/"_maxQty,!
				...q:(mainIcuciiIdStr'="")&($lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3)="C")&(minQty'="")&(maxQty'="")&((mainItemCount<minQty)!(mainItemCount>maxQty)) //是子项，不完全或关系
				...///mainItemCount不可另外赋值，后面要用
				...
				...s typeCat=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),31) //类别主项：(毒麻药、抗生素)分类
				...s specCode=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),32) //标本代码
				...//i typeCat'="" w typeCat,! b
				...s value="",searchVal=""
				...
				...s splitMainIcuc=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),33) //是否从已查询出的结果中获取数据
				...i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3)="O" d
				   	....s isFind=0,times=""
					....s arcimId=""
					....f  s arcimId=$o(^OEORDi(0,"ARCIM",oeordId,arcimId)) q:(arcimId="")!(isFind)  d
						.....q:(typeCat="")&(("^"_icuciiCode_"^")'[("^"_arcimId_"^"))
						.....//w icuciiSub_"   /"_arcimId,"/"_typeCat_"/"_icuciiCode,! b
						.....s phcPoisonCode=""
						.....i (typeCat="Poison")||(typeCat="Antibiotics") d
							......s phcPoisonCode=##class(web.DHCClinicCom).GetPHCPoisonCode(arcimId)
						.....//i phcPoisonCode'="" w phcPoisonCode,! b
						.....q:(typeCat="Poison")&(("^"_icuciiCode_"^")'[("^"_phcPoisonCode_"^"))
						.....s oeoriSttDate="",ArcimDesc=""						
						.....s oeoriSttDate=findFromDate-1											
						.....f  s oeoriSttDate=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,oeoriSttDate)) q:(oeoriSttDate="")!(isFind)  d
							......i (oeoriSttDate>findToDate) s oeoriSttDate=$h+100000 //退出
							......s oeoriSub="",doseQty=0
							......f  s oeoriSub=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,oeoriSttDate,oeoriSub)) q:(oeoriSub="")!(isFind)  d
								.......;i (icuaId=11644) w oeoriSttDate b ;""
								.......q:'$d(^OEORD(oeordId,"I",oeoriSub))
								.......s oeoriId=oeordId_"||"_oeoriSub
								.......s oecprCode="",oecprType="",exStDate="",exStTime=""													
								.......s oecprId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",8)								
								.......i oecprId>0 s oecprCode=$p($g(^OECPR(+oecprId)),"^",1) 
								.......i (oecprCode="S")!(oecprCode="OMST")!(oecprCode="OMCQZT") s oecprType="Y" //长期医嘱
								.......s ordStatCode=##Class(web.DHCClinicCom).GetOrdStatCode(oeoriId)								
								.......q:("DIU"[ordStatCode)&&(oecprType'="Y")
								.......q:("IU"[ordStatCode)&&(oecprType="Y")								
								.......;i (oeoriSub=719) s ^dhctmpmfc(icuaId,oeordId,oeoriSub,arcimId,oeoriSttDate)="Antibiotics"_"/"_##class(web.DHCClinicCom).GetDDD(arcimId)								
								.......//w $p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2),!
								.......;q:$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",12)'=""								
								.......s oeoriSttDat=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
								.......s oeoriSttTim=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
								.......s oeoriSttDateTime=oeoriSttDat+(oeoriSttTim/100000)
								.......;b ;datetime						
								.......q:oeoriSttDateTime<inDateTime
								.......q:oeoriSttDateTime>outDateTime
								.......q:oeoriSttDateTime<findFromDateTime	//!!!!长嘱滚执行记录不适用
								.......q:oeoriSttDateTime>findToDateTime	//!!!!长嘱滚执行记录不适用
								.......;i (icuaId=10196) s ^dhctmpmfc(icuaId,oeordId,oeoriSub,arcimId,oeoriSttDat,oeoriSttTim)=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",2)_"/"_oeoriSttDateTime_"/"_inDateTime_"/"_outDateTime
								.......s oeoriEndDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",34)
								.......s oeoriEndTime=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",15)							
								.......i (oecprType="Y")  d
									........s oeoreSub=0,isFrist=0
									........f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:(oeoreSub="")!(isFrist)  d
										.........q:'$g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub))								
										.........s exStDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",1)
										.........s exStTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",2)
										.........s isFrist=1								
										.........;i (icuaId=10233) s ^dhcmfctmp(icuaId,oeordId,oeoriSub,oeoreSub)=oeoriEndDate_"/"_oeoriEndTime_"/"_exStDate_"/"_exStTime	
								.......q:(oeoriEndDate'="")&&(exStDate'="")&&(exStDate>oeoriEndDate)
								.......q:(oeoriEndDate'="")&&(oeoriEndTime'="")&&(exStDate'="")&&(exStTime'="")&&(exStDate=oeoriEndDate)&&(exStTime>oeoriEndTime)
								.......s curSpecCode=""
								.......i specCode'="" d
									........s curSpecSub=$o(^OEORD(oeordId,"I",oeoriSub,"SPEC",0))
									........s curSpecCode=$p(^OEORD(oeordId,"I",oeoriSub,"SPEC",curSpecSub),"^",1)
								.......q:(specCode'="")&(specCode'=curSpecCode)						
								.......i (dataField["Times")&&(dataField["DateTime") d //add 20140801显示次数和时间
									........s times=times+1 //$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",12)
									........s ArcimDesc=ArcimDesc_" "_$zd(oeoriSttDat,3)_" "_$zt(oeoriSttTim,2)
									........s value=times_"次日期,"_ArcimDesc_" "
									........;i (icuaId=11647) w oeoriSttDate b ;"in"
								.......;i (icuaId=11647) w oeoriSttDate,value b ;""
								.......e  i typeCat="Antibiotics" d  //抗生素DDD值
									........;s tmpValue=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",2) ;医嘱名称
									........;i (oeoriSub=719) s ^dhctmpmfc(icuaId,oeordId,oeoriSub,arcimId,oeoriSttDate)="Antibiotics"_"/"_##class(web.DHCClinicCom).GetDDD(arcimId)
									........;s value=value+(doseQty/##class(web.DHCClinicCom).GetDDD(arcimId))
									........s arcicOrderType=##class(web.DHCClinicCom).GetOrdSubCatType(oeordId_"||"_oeoriSub)
									........q:(arcicOrderType'="R") //非药品退出
									........s oeoreSub=0
									........;b ;"DDD"
									........f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:(oeoreSub="")  d
										.........q:'$g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub))								
										.........s exStDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",1)
										.........s exStTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",2)								
										.........q:(oeoriEndDate'="")&&(exStDate>oeoriEndDate)
										.........q:(oeoriEndDate'="")&&(oeoriEndTime'="")&&(exStDate=oeoriEndDate)&&(exStTime>oeoriEndTime)
										.........;s dddQty=$p(##class(web.DHCClinicCom).GetDDD(arcimId),"^",1)
										.........s dddQty=##class(web.DHCAntService).GetAntDDD(arcimId)
										.........s phQtyOrd=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",5)
										.........q:('(phQtyOrd>0))||('(dddQty>0))
										.........
										.........s arcimDr=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
										.........s arcimPHCDFDR=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
										.........q:'$o(^PHCD(+arcimPHCDFDR,"DF",$p(arcimPHCDFDR,"||",2),""))
										.........s formDoseEquiv=$o(^PHCD(+arcimPHCDFDR,"DF",$p(arcimPHCDFDR,"||",2),"EQ",0))
										.........q:formDoseEquiv=""
										.........s eqQty=$p($g(^PHCD(+arcimPHCDFDR,"DF",$p(arcimPHCDFDR,"||",2),"EQ",formDoseEquiv)),"^",2)
										.........s ArcimDesc=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",2) ;医嘱名称
										.........;s ^dhctmpmfc(icuaId,oeordId,oeoriSub,oeoreSub,arcimId,oeoriSttDate)=ArcimDesc_"/"_dddQty_"/"_phQtyOrd_"/"_eqQty
										.........;i (icuaId=10233) s ^dhctmpmfc(icuaId,oeordId,oeoriSub,oeoreSub,arcimId,oeoriSttDate)=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",2)_"/"_phQtyOrd_"/"_eqQty_"/"_##class(web.DHCClinicCom).GetDDD(arcimId)
										.........i eqQty>0 d
											..........s pheqQtyValue=(phQtyOrd/eqQty)
											..........s value=value+(pheqQtyValue/dddQty)
								.......e  i dataField="DurationHour" d  ;add by lyn 获取医嘱在入icu之后多久之后!!!!????
										........s Hours=##class(web.DHCClinicCom).CalculateDuration(inDate,inTime,oeoriSttDat,oeoriSttTim,"H")
										........i Hours<24 s value="<24小时"
										........i Hours>=24,Hours<48 s value="24-48小时"
										........i Hours>=48,Hours<72 s value="48-72小时"
										........i Hours>=72,Hours<168 s value="72小时-1周"
										........i Hours>=168 s value="≥ 1周"															
								.......e  i dataField="DateTime" d  //获取医嘱名称 add mfc 20140609
								........s value=$zd(oeoriSttDat,3)_" "_$zt(oeoriSttTim,2) //获取医嘱时间 add mfc 20140609																						
								........s isFind=1
								.......e  i (dataField="NoteAndOriQty")||(dataField="OriQty")||(dataField="OriDecide")||(dataField="DoseQty") d //医嘱备注和剂量或者总剂量									
										........s oriNote=$g(^OEORD(oeordId,"I",+oeoriSub,"DEP",1))
										........i oriNote="" s oriNote="未填写医嘱备注"
										........s doseQty=$p($g(^OEORD(oeordId,"I",+oeoriSub,2)),"^",1)
										........i doseQty="" d
										.........s ViewSuperCat="" ,ViewCat="",arcim=""
										.........f  s ViewSuperCat=$O(^DHCICUC("OrdMapping",ViewSuperCat)) q:(ViewSuperCat="")  d
										..........f  s ViewCat=$O(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat)) q:(ViewCat="")  d								
										...........f  s arcim=$O(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)) q:(arcim="")  d
										............q:arcim'=arcimId									
										............s doseQty=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)),"^",5)																	
										........s times=times+1
								.......e  d									    
										........s oriNote=$g(^OEORD(oeordId,"I",+oeoriSub,"DEP",1))
										........;i (icuaId=10196) s ^dhctmpmfc(icuaId,oeordId,oeoriSub,arcimId,oeoriSttDate)=arcicOrderType_"/"_oriNote							
										........q:(oeoriNote'="")&&((oriNote)'[(oeoriNote))
										........s ArcimDesc=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",2) ;医嘱名称
										........i (needNote'="")&&(ArcimDesc'="")&&(ArcimDesc=needNote) s value="是"															  													
										........i (dataField'="Times")&&(dataField'="touchQty") s isFind=1,value=ArcimDesc
										........e  d
										.........s times=times+1
										.........i value="" s value=ArcimDesc_" "_$zd(oeoriSttDat,3)_" "_$zt(oeoriSttTim,2)
 				 						.........e  s value=value_"#"_ArcimDesc_" "_$zd(oeoriSttDat,3)_" "_$zt(oeoriSttTim,2)
										........;i (icuciId=25)&&(icuciiSub=46)&&(icuaId=6963) s ^MfcTemp("2011")=times								
								........//w "         times="_value_":"_times,!								
								.......i dataField="DoseQty" s value=doseQty 
								.......i dataField="Record" d  //按医嘱项获取护理记录用量 add  by lyn
									........s value=##class(web.DHCICUStat).SumByArcimID(icuaId,curFromDate,curFromTime,curToDate,curToTime,arcimId)
								.......i dataField="NoteAndOriQty" d //医嘱备注和剂量
								........q:(oeoriNote'="")&&(oriNote'="未填写医嘱备注")&&((oriNote)'[(oeoriNote)) //区分备注名称医嘱
								........q:(oeoriNote'="")&&(oriNote="未填写医嘱备注")&&(oeoriNote'="RBC") //未填写备注算入RBC
								........i value="" s value=oriNote
								........e  s value=value_"#"_oriNote
								.......i dataField="OriQty" d //总剂量
								........q:(oeoriNote'="")&&(oriNote'="未填写医嘱备注")&&((oriNote)'[(oeoriNote)) //区分备注名称医嘱
								........q:(oeoriNote'="")&&(oriNote="未填写医嘱备注")&&(oeoriNote'="RBC") //未填写备注算入RBC							
								........s value=value+doseQty
								.......i dataField="OriDecide" d //下医嘱为是(把第一次的时间点记录下来)
								........q:(oeoriNote'="")&&(oriNote'="未填写医嘱备注")&&((oriNote)'[(oeoriNote)) //区分备注名称医嘱
								........q:(oeoriNote'="")&&(oriNote="未填写医嘱备注")&&(oeoriNote'="RBC") //未填写备注算入RBC							
								........i oriNote'="" s value="是"
								........q:(value'="") //多个主项目时，选择LevelIf为1的项目执行 
								.......i $g(^TmpICUOeoriSDt(icuaId,icuciiSub))="" s ^TmpICUOeoriSDt(icuaId,icuciiSub)=oeoriSttDat_" "_oeoriSttTim //;记录第一次时间
								.......e  i $p($g(^TmpICUOeoriSDt(icuaId,icuciiSub))," ",1)>oeoriSttDat	s ^TmpICUOeoriSDt(icuaId,icuciiSub)=oeoriSttDat_" "_oeoriSttTim
					....s searchVal=value
					....;i (icuaId=11571)&((icuciiSub="11")||(icuciiSub="12"))&(icuciId=60)	w icuStr,!			
					....q:$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),5)'=1
					....s $p(icuStr,"^",posList(posCode))=value
					....;i (icuciiSub="46")&(icuciId=45) b ;"35"			
					....i dataField="Times" d
						.....s $p(icuStr,"^",posList(posCode))=times
						.....;i sumType'="" s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),times)
					....q:times=0
					....i (icuciId=45)&(icuciiSub=46) s ^dhcwhltemp(icuaId)=times
					....i sumType'="" s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),times)
				...//i icuciiSub=15 w 1, icuStr,! b
				...i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3)="R" d	//重症记录
					....q:'$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),5) //必须是显示项
					....s i=0
					....i (icuaId=11460)&(icuciiSub=14) b "11460"
					....s icucriCode=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)
					....//i icucriCode="ApacheTotalScore" b ;"ApacheTotalScore"
					....//i icucriCode="GCSTotalScore" b ;"GCSTotalScore"
					....q:icucriCode=""
					....i icucriCode'=+icucriCode s icucriIdStr=##class(web.DHCICUCom).GetIcuriIdByCode(icucriCode)
					....e  s icucriIdStr=icucriCode //icucriIdStr=6385
					....q:icucriIdStr=""
					....s isSingle=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),7)
					....s icuciiStartDateTime=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),12) //InWardDateTime
					....s oeoriNote=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),14) //持续泵用
					....s inTime=("."_$p($g(inDateTime),".",2))*100000 //获取入病区时间 add mfc 20140609
					....s outTime=("."_$p($g(outDateTime),".",2))*100000 //获取出病区时间
					....i ifDebug w "icuciiSub="_icuciiSub_" icucriIdStr="_icucriIdStr,"/"_icuciiStartDateTime,!
					....;b ;r04
					....s value="",textValue=""
					....s ARCIMRowIdStr=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),29) ;包含对应医嘱项ID串^分隔
					....s orderNote=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),30) ;包含对应医嘱备注
					....s orderCategory=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),31) ;包含对应医嘱项显示大类^分隔
					....s itemcat=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),32) ;包含对应医嘱项显示大类^分隔
					....s fromIcucriId=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),22)
					....s toIcucriId=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),23)
					....f i=1:1:$l(icucriIdStr,"^") d
						.....s icucriId=$p(icucriIdStr,"^",i)
						.....q:icucriId=""
						.....s returnValue=""
						.....s icucriDataField=$p($g(^DHCICUC("RecordItem",icucriId)),"^",24)
						.....i ("^PartialSum^")[("^"_icuciiStartDateTime_"^") d //partialSum部分汇总（每两小时的最小值）
							......q:("^Min^Max^"[("^"_dataField_"^"))&(icuciFromTime'="")&(icuciToTime)  //ICUCII_DurationInterval,计算平均最小值,最大值
							......//s curValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,icucriId,curFromDate,curFromTime,oeordNowDate,oeordNowTime,"Sum")
							......s icuciiDurationInterval=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),25) //未用
							......q:icuciFromTime>icuciToTime
							......s minSum="",maxSum=""
							......f indDate=findFromDate:1:findToDate d //计算部分时间汇总
								.......f indHour=0:1:23 d //按小时递进
									........w indHour_"/"
									........q:(indDate=findFromDate)&((indHour*3600)'>findFromTime)
									........q:(indDate=findToDate)&((indHour*3600)>findToTime)
									........q:(indDate=outDate)&((indHour*3600)>outTime)
									........w "indHour="_indHour,!
									........s dateTimeStr=##class(web.DHCClinicCom).DateTimeAdd(indDate,indHour*3600,icuciFromTime)
									........s curFromDate=$p(dateTimeStr,"^",1),curFromTime=$p(dateTimeStr,"^",2)
									........w ##class(web.DHCClinicCom).CalculateDuration(curFromDate,curFromTime,inDate,inTime)_" a/b"
									........q:##class(web.DHCClinicCom).CalculateDuration(curFromDate,curFromTime,inDate,inTime)'<3600
									........
									........s dateTimeStr=##class(web.DHCClinicCom).DateTimeAdd(indDate,indHour*3600,icuciToTime)
									........s curToDate=$p(dateTimeStr,"^",1),curToTime=$p(dateTimeStr,"^",2)
									........w ##class(web.DHCClinicCom).CalculateDuration(outDate,outTime,curToDate,curToTime)_" cd"
									........q:##class(web.DHCClinicCom).CalculateDuration(outDate,outTime,curToDate,curToTime)'<3600
									........
									........s curValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,icucriId,curFromDate,curFromTime,curToDate,curToTime,"Sum")
									........w findFromDate_"/"_$zt(findFromTime)_"/"_findToDate_"/"_$zt(findToTime)_"/"_$zd(curFromDate,3)_"/"_$zt(curFromTime)_"/"_$zd(curToDate,3)_"/"_$zt(curToTime)_"/"_curValue,!
									........i (minSum="")!((minSum'="")&(minSum>curValue)) s minSum=curValue
									........i (maxSum="")!((maxSum'="")&(maxSum<curValue)) s maxSum=curValue
									........
								.......//w icuaId_"/"_curValue_"  val/"_minSum_"/"_maxSum,! b ;minmax
								.......i dataField="Min" s value=minSum
								.......i dataField="Max" s value=maxSum
							......i ifDebug w " last/"_value,!
							......;q:(needNote'="")&(("^"_needNote_"^")'[("^"_value_"^")) //mfc 20140612添加过滤条件
							......s searchVal=value
							......q:$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),5)'=1
							......q:'$d(posList(posCode))
							......q:(minQty'="")&(maxQty'="")&((value<minQty)!(value>maxQty))
							......s $p(icuStr,"^",posList(posCode))=value //_$g(addStr)
							......i sumType'="" d				
								.......s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),value)
								.......i (dataField="Average")&&(value'="") d //计算平均分数
									........s Pos=posList(posCode)
									........s $p(sumStr,"^",Pos)=$p(sumStr,"^",pos)+value,ScorePos=Pos,ScoreCount=ScoreCount+1
							.......
						.....e  d //常规统计
							......w icuciiSub_"/"_icuciiStartDateTime_"  ==========="_dataField,!
							......//i (icuaId=11420)&(icuciiSub=28) b ;"normal"
							......i "^DurationDay^DurationHour^DurationTimes^Rate^"[("^"_dataField_"^") d //计算持续操作
								.......i (fromIcucriId'="")&(toIcucriId'="") d //根据置管和拔管时间计算相关值
									........w icuaId_","_icucriId_","_inquiryFromDate_","_0_","_inquiryToDate_","_0_","_fromIcucriId_","_toIcucriId_","_outDateTime,!
									........s durationStr=##class(web.DHCICUOrder).GetCatheterDuration(icuaId,icucriId,findFromDate,findFromTime,findToDate,findToTime,fromIcucriId,toIcucriId,outDateTime)
									........i ifDebug w "durationStr 1="_durationStr,"?"_icuaId_"/"_icucriId_"/"_inquiryFromDate_"/"_0_"/"_inquiryToDate_"/"_maxToTime_"/"_fromIcucriId_"/"_toIcucriId_"/"_outDateTime,!
									........w durationStr,!	
									........//i (icuaId=11420)&(icuciiSub>47) b ;"cahheter"		
								.......e  d //连续操作根据时间间隔分
									........;i (icuciiSub="47")&(icuciId=25)&(icuaId=11738) s ^dhctmpmfc(icuaId,icucriId,1)=$zd(findFromDate,3)_"/"_$zt(findFromTime,2)_"/"_$zd(findToDate,3)_"/"_$zt(findToTime,2)_"/"_minUnit_"/"_needNote_"/"_oeoriNote
									........//w "begin" b
									........s durationStr=##class(web.DHCICUOrder).GetRecordDuration(icuaId,icucriId,findFromDate,findFromTime,findToDate,findToTime,minUnit,needNote,oeoriNote,minQty,maxQty)
								    ........//i (icuaId=11420)&(icuciiSub>47) b ;"record"
								.......w icuciiSub_" durationStr out="_durationStr,!
								.......i dataField="DurationDay" s value=value+$p(durationStr,"^",1),returnValue=$p(durationStr,"^",1)
								.......i dataField="DurationHour" s value=value+$p(durationStr,"^",2),returnValue=$p(durationStr,"^",2)
								.......i dataField="DurationTimes" s value=value+$p(durationStr,"^",4),returnValue=$p(durationStr,"^",4)
								.......//w value,!
								.......//i (icuaId=9601)&(icuciiSub=16) b ;GetRecordDuration
								.......i (value="0") s value=""
								.......i (returnValue="0") s returnValue=""
							......e  d //非持续时间 
								.......w "searchLevel:"_searchLevel,!
								.......s curType=dataField,tmpRecordV="",oeordPreDate="",oeordPreTime=""
								.......;i (icuciDataType="D")&(dataField="DateTime") d  //
								.......;b ;"//按时间点统计记录条数"
							    .......s retstr=..GetRecordValueByUserID(icuaId,icucriId,inquiryFromDate,0,inquiryToDate+1,0,dataField,"","",oeoriNote,"","","","",posList(posCode),icuciId,ARCIMRowIdStr)
								.......i (icuciDataType="D")&(isSingle=0) d  //按时间点统计记录条数
									........s curType="All"
									........s curDateTime="",icuoId=""
									........s tmpRecordV=##class(web.DHCICUOrder).GetRecordValue(icuaId,icucriId,curFromDate,curFromTime,curToDate,curToTime,curType,"","",oeoriNote,"AddDateTime",refIcucriId,refValue,needNote,minQty,maxQty)
                                    ........b ;"//按时间点统计记录条数"
									........f  s curDateTime=$o(^TMPICU("RecordValue",$j,curDateTime)) q:curDateTime=""  d
										.........f  s icuoId=$o(^TMPICU("RecordValue",$j,curDateTime,icuoId)) q:icuoId=""  d
											..........s remarks=..GetparentItemRemarkByIcuoId(icuoId)
											..........i remarks'="" s ^TEMPWHLL("remarks",icuoId)=..GetparentItemRemarkByIcuoId(icuoId)
											..........s $p(^TMPDHCICUInquiry(icuciId,"F",icuaId_","_curDateTime_","_icuoId),"^",$g(posList(posCode)))=^TMPICU("RecordValue",$j,curDateTime,icuoId)_..GetparentItemRemarkByIcuoId(icuoId)
											..........i (icuciId=67) s $p(^TMPDHCICUInquiry(icuciId,"F",icuaId_","_curDateTime_","_icuoId),"^",$g(posList(posCode)))=$p(^TMPICUO("RecordValue",$j,curDateTime,icuoId),"@",1)
											..........s $p(^TMPDHCICUInquiry(icuciId,"F",icuaId_","_curDateTime_","_icuoId),"^",3)=##class(web.DHCClinicCom).ConvertToDate($p(curDateTime,",",1))_","_##class(web.DHCClinicCom).ConvertToTime($p(curDateTime,",",2))
											..........s $p(^TMPDHCICUInquiry(icuciId,"F",icuaId_","_curDateTime_","_icuoId),"^",2)=tRegNo
											..........;b ;"67"
											..........s $p(^TMPDHCICUInquiry(icuciId,icuaId_","_curDateTime_","_icuoId),"^",$g(posList(posCode)))=^TMPICU("RecordValue",$j,curDateTime,icuoId)_$p(^DHCICUOrder(icuoId),"^",37)
											..........s remark=..GetparentItemRemarkByIcuoId(icuoId)
											..........i (icuciId=67) s $p(^TMPDHCICUInquiry(icuciId,icuaId_","_curDateTime,icuoId),"^",$g(posList(posCode)))=$p(^TMPICUO("RecordValue",$j,curDateTime,icuoId),"@",1)_..GetparentItemRemarkByIcuoId(icuoId)
											..........i (icuciId=67)&(remark'="") s $p(^TMPDHCICUInquiry(icuciId,icuaId_","_curDateTime_","_icuoId),"^",$g(posList(posCode)))=$p(^TMPICUO("RecordValue",$j,curDateTime,icuoId),"@",1)_"#"_remark
											..........s $p(^TMPDHCICUInquiry(icuciId,icuaId_","_curDateTime_","_icuoId),"^",2)=tRegNo
											..........s $p(^TMPDHCICUInquiry(icuciId,icuaId_","_curDateTime_","_icuoId),"^",3)=##class(web.DHCClinicCom).ConvertToDate($p(curDateTime,",",1))_","_##class(web.DHCClinicCom).ConvertToTime($p(curDateTime,",",2))
											..........s $p(^TMPDHCICUInquiry(icuciId,icuaId_","_curDateTime_","_icuoId),"^",1)=icuaId
											..........i (icuciId=67) s $p(^TMPDHCICUInquiry(icuciId,icuaId_","_curDateTime_","_icuoId),"^",5)=..GetparentItemNameByIcuoId(icuoId)
											..........i (icuciId=76) s $p(^TMPDHCICUInquiry(icuciId,icuaId_","_curDateTime_","_icuoId),"^",5)=..GetparentItemNameByIcuoId(icuoId)
 											..........s tempvalue=^TMPICU("RecordValue",$j,curDateTime,icuoId)
									........k ^TMPICU("RecordValue",$j)
									........k ^DHCICUInquiry(icuciId,"F",icuaId)										
									........s curDateTime="",icuoId=""
								.......e  i ((("^"_icucriCode_"^")[("^"_"TotalIn"))||(("^"_icucriCode_"^")[("^"_"TotalOut"))||(("^"_icucriCode_"^")[("^"_"TotalBalance"))) d //总入量、总出量、出入量平衡
								 	........s count=##class(web.DHCICUOrder).GetSummaryData("",icuaId,findFromDate,findFromTime,findToDate,findToTime,"")								 				
									........i count=+count d
 									.........f seqNum=1:1:count d
 									..........s Data=$g(^TMPICU("Summary",$j,seqNum))
 									..........q:Data=""
 									..........s curcomordId=$li(Data,3) 									
 									..........q:"^"_icucriId_"^"'[curcomordId 			 																
									..........s findIORate=$li(Data,6)									
									..........s tmpRecordV=tmpRecordV+findIORate
									.........k ^TMPICUView("Summary",$j,seqNum)									
								.......e  d //普通记录项
								    ........;i (icuciiSub=117)&(icuaId=12612)  s ^dhctmpmfc(icuaId,1)=icuaId_","_icucriId_","_findFromDate_","_findFromTime_","_findToDate_","_findToTime_","_curType_","_""_","_""_","_oeoriNote_","_"AddDateTime"_","_refIcucriId_","_refValue_","_needNote_","_minQty_","_maxQty
								    ........w icuaId_","_icucriId_","_findFromDate_","_findFromTime_","_findToDate_","_findToTime_","_curType_","_""_","_""_","_oeoriNote_","_"AddDateTime"_","_refIcucriId_","_refValue_","_needNote_","_minQty_","_maxQty,!
									........s tmpRecordV=##class(web.DHCICUOrder).GetRecordValue(icuaId,icucriId,findFromDate,findFromTime,findToDate,findToTime,curType,"","",oeoriNote,"AddDateTime",refIcucriId,refValue,needNote,minQty,maxQty)
									........//i (icuaId=9596)&(icuciiSub=13) b ;GetRecordValue
								.......w "tmpRecordV="_tmpRecordV,!
								.......f k=1:1:$l(tmpRecordV,"#") d //整理显示数据和记录主项时间点
									........s tmpRecordVAndDT=$p(tmpRecordV,"#",k)							
									........s tmpRecordValue=$p(tmpRecordVAndDT,"~",1)
									........s tmpRecordDT=$p(tmpRecordVAndDT,"~",2)
									........i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),27)="" d //主项
										.........i $g(^TmpICUOeoriSDt(icuaId,icuciiSub))="" s ^TmpICUOeoriSDt(icuaId,icuciiSub)=$p($g(tmpRecordDT)," ",1)_" "_$p($g(tmpRecordDT)," ",2) //;记录第一次时间
										.........e  i $p($g(^TmpICUOeoriSDt(icuaId,icuciiSub))," ",1)>$p(tmpRecordDT," ",1)	s ^TmpICUOeoriSDt(icuaId,icuciiSub)=$p($g(tmpRecordDT)," ",1)_" "_$p($g(tmpRecordDT)," ",2)
									........i (curType="FirstDT")||(curType="MinDT")||(curType="MaxDT")||(curType="MinMaxDT") d
										.........i tmpRecordValue'="" d
											..........i value="" s value=tmpRecordValue_"~"_tmpRecordDT
											..........e  s value=value_"#"_tmpRecordValue_"~"_tmpRecordDT
									........e  d 
 				 							.........i value="" s value=tmpRecordValue
 				 							.........e  s value=value_"#"_tmpRecordValue 
								.......//w value,!
								.......s returnValue=value
							......q:value=""
							......//i icuciiSub=16 w minQty_"/"_maxQty_"/"_value,! b
							......q:(minQty'="")&(maxQty'="")&((value<minQty)!(value>maxQty))&(dataField'="DurationHour")
							......s searchVal=value
							......q:$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),5)'=1
							......s $p(icuStr,"^",$g(posList(posCode)))=value
							......//i icuciiSub=16 b ;icuStr
							......i sumType'="" d
								.......s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),returnValue)
				...i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3)="L" d
					....s i=0,testQtyStr=""
					....s testCodeList=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)
					....s isSingle=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),7)
					....s minQty=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),8)
					....s maxQty=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),9)	
					....s seqNo=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),20) //显示顺序			
					....s curType=""
					....i (icuciDataType="D") d  //&(searchLevel<2)
						.....s curType="All"
					....w icuciiSub_":"_findFromDate_"/"_findFromTime_"/"_findToDate_"/"_findToTime_"/"_inDate_"/"_inTime_"/"_curFromTime_"/"_curToTime,!
					....f j=1:1:$l(testCodeList,"^")  d
						.....s testCode=$p(testCodeList,"^",j)
						.....s ^TEMPTESTCode(testCode)=seqNo
						.....s tmpStr=##class(web.DHCClinicCom).GetTestResult("", regNo, "", testCode, findFromDate, findFromTime, findToDate, findToTime, isSingle,needNote,dataField)
						.....//i icuaId=7396 w regNo,"/"_EpisodeID_"/"_tmpStr b
						.....;s tmpStr=##class(web.DHCClinicCom).GetTestResult("", regNo, "", testCode, fromDate, "0", toDate, "0", isSingle,needNote)		
						.....i testQtyStr="" s testQtyStr=tmpStr
						.....e  s testQtyStr=testQtyStr_"~"_tmpStr	
					....;b ;"All"
					....i curType="All" d
					    .....;b ;"AllIn"
						.....s curDateTime="",RegNo="",testCode="",labNo="",standardCode=""
						.....f  s RegNo=$o(^TMPICU("labNo",$j,RegNo)) q:RegNo=""  d
         			    ......f  s curDateTime=$o(^TMPICU("labNo",$j,RegNo,curDateTime)) q:curDateTime=""  d
         			    .......f  s standardCode=$o(^TMPICU("labNo",$j,RegNo,curDateTime,standardCode)) q:standardCode=""  d
 						........f  s testCode=$o(^TMPICU("labNo",$j,RegNo,curDateTime,standardCode,testCode)) q:testCode=""  d
                        .........f  s labNo=$o(^TMPICU("labNo",$j,RegNo,curDateTime,standardCode,testCode,labNo)) q:labNo=""  d
                        ..........;b ;"end"
						..........;s $p(^TMPDHCICUInquiry(icuciId,"F",RegNo_","_curDateTime_","_standardCode_","_testCode_","_labNo),"^",$g(^TEMPTESTCode(standardCode)))=standardCode_"@"_^TMPICU("labNo",$j,RegNo,curDateTime,standardCode,testCode,labNo)
					 	..........;s $p(^TMPDHCICUInquiry(icuciId,RegNo_","_curDateTime_","_standardCode_","_testCode_","_labNo),"^",$g(^TEMPTESTCode(standardCode)))=standardCode_"@"_^TMPICU("labNo",$j,RegNo,curDateTime,standardCode,testCode,labNo)
 						..........;s $p(^TMPDHCICUInquiry(icuciId,"F",RegNo_","_curDateTime_","_standardCode_","_testCode_","_labNo),"^",3)=##class(web.DHCClinicCom).ConvertToDate($p(curDateTime,",",1))_","_##class(web.DHCClinicCom).ConvertToTime($p(curDateTime,",",2))
					 	..........;s $p(^TMPDHCICUInquiry(icuciId,RegNo_","_curDateTime_","_standardCode_","_testCode_","_labNo),"^",3)=##class(web.DHCClinicCom).ConvertToDate($p(curDateTime,",",1))_","_##class(web.DHCClinicCom).ConvertToTime($p(curDateTime,",",2))
						..........s $p(^TMPDHCICUInquiry(icuciId,"F",RegNo_","_curDateTime),"^",$g(^TEMPTESTCode(standardCode)))=^TMPICU("labNo",$j,RegNo,curDateTime,standardCode,testCode,labNo)
					 	..........s $p(^TMPDHCICUInquiry(icuciId,RegNo_","_curDateTime),"^",$g(^TEMPTESTCode(standardCode)))=^TMPICU("labNo",$j,RegNo,curDateTime,standardCode,testCode,labNo)
 						..........s $p(^TMPDHCICUInquiry(icuciId,"F",RegNo_","_curDateTime),"^",3)=##class(web.DHCClinicCom).ConvertToDate($p(curDateTime,",",1))_","_##class(web.DHCClinicCom).ConvertToTime($p(curDateTime,",",2))
					 	..........s $p(^TMPDHCICUInquiry(icuciId,RegNo_","_curDateTime),"^",3)=##class(web.DHCClinicCom).ConvertToDate($p(curDateTime,",",1))_","_##class(web.DHCClinicCom).ConvertToTime($p(curDateTime,",",2))
						..........b ;"qty"
  						..........i (icuciId=67) s $p(^TMPDHCICUInquiry(icuciId,curDateTime_","_RegNo),"^",5)=""
  						.......... s qty=""
						..........f  s qty=$o(^TMPDHCPATION("regNo",icuciId,RegNo,qty)) q:qty=""  d
						...........s $p(^TMPDHCICUInquiry(icuciId,"F",RegNo_","_curDateTime),"^",qty)=$g(^TMPDHCPATION("regNo",icuciId,RegNo,qty))
					 	...........s $p(^TMPDHCICUInquiry(icuciId,RegNo_","_curDateTime),"^",qty)=$g(^TMPDHCPATION("regNo",icuciId,RegNo,qty)) 	 
 					....f z=1:1:$l(testQtyStr,"~")  d
						.....s tmpQtyStr=$p(testQtyStr,"~",z)
						.....f y=1:1:$l(tmpQtyStr,"^")  d	
							......i dataField="BiaoBen"	d
								.......s tmpValue=$p($p(tmpQtyStr,"^",y),"\",10)
								.......i ("#"_value_"#")[("#"_tmpValue_"#") s tmpValue=""
							......e  s tmpValue=$p($p(tmpQtyStr,"^",y),"\",1)							
							......i y=1  d  //记录主项时间点(单次)							
							.......i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),27)="" d //主项
							........i $g(^TmpICUOeoriSDt(icuaId,icuciiSub))="" s ^TmpICUOeoriSDt(icuaId,icuciiSub)=$p($p(tmpQtyStr,"^",y),"\",4)_" "_$p($p(tmpQtyStr,"^",y),"\",5) //;记录第一次时间
							........e  i $p($g(^TmpICUOeoriSDt(icuaId,icuciiSub))," ",1)>$p($p(tmpQtyStr,"^",y),"\",4)	s ^TmpICUOeoriSDt(icuaId,icuciiSub)=$p($p(tmpQtyStr,"^",y),"\",4)_" "_$p($p(tmpQtyStr,"^",y),"\",5)							
							......i value="" s value=tmpValue
							......e  i tmpValue'="" s value=value_"#"_tmpValue
							......;i value="" s value=$p($p(tmpQtyStr,"^",y),"\",1)
							......;e  i $p($p(tmpQtyStr,"^",y),"\",1)'="" s value=value_"#"_$p($p(tmpQtyStr,"^",y),"\",1)
							......;i dataField="touchQty" d
								.......;i value="" s value=$p($p(tmpQtyStr,"^",y),"\",1)_"@"_##class(web.DHCClinicCom).ConvertToDate($p($p(tmpQtyStr,"^",y),"\",4))_"@"_##class(web.DHCClinicCom).ConvertToTime($p($p(tmpQtyStr,"^",y),"\",5))
								.......;e  s value=value_" "_$p($p(tmpQtyStr,"^",y),"\",1)_"@"_##class(web.DHCClinicCom).ConvertToDate($p($p(tmpQtyStr,"^",y),"\",4))_"@"_##class(web.DHCClinicCom).ConvertToTime($p($p(tmpQtyStr,"^",y),"\",5))
							......;e  d
								.......;i value="" s value=$p($p(tmpQtyStr,"^",y),"\",1)
								.......;e  s value=value_" "_$p($p(tmpQtyStr,"^",y),"\",1)
					....q:(minQty'="")&(maxQty'="")&((value<minQty)!(value>maxQty))
					....s searchVal=value
					....q:$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),5)'=1
					....s $p(icuStr,"^",posList(posCode))=value
					....i sumType'="" s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),value)
				...i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3)="B" d
					....//w "    BaseOut",!
					....s icuciCode=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)
				    ....;s ^TEMPWHL("icuciCode",icuciCode)=icuciCode
					....s clcudIdList=""
					....f i=1:1:$l(icuciCode,"^") d
						.....s icucudCode=$p(icuciCode,"^",i)
						.....q:icucudCode=""
						.....;s curWardLocId=$lg(^DHCICUCInquiry(icuciId),3)
						.....s $p(clcudIdList,"^",i)=$o(^DHCCLC("UnderlyingDisease",0,"Code",icucudCode,curWardLocId,""))
						.....q:$p(clcudIdList,"^",i)=""
					....s value=""
					....f i=1:1:$l(clcudIdList,"^") d
						.....s clcudId=$p(clcudIdList,"^",i)
						.....q:clcudId=""
						.....s icuudId=$o(^DHCICUUnderlyingDisease(0,"UDisease",clcudId,icuaId,""))
						.....q:icuudId=""
						.....q:$lg(^DHCCLC("UnderlyingDisease",clcudId),2)=""
						.....i value'="" s value=value_","
						.....s value=value_$lg(^DHCCLC("UnderlyingDisease",clcudId),2)
						.....//w value,!
					....i icuciCode="" d
						.....s icuudId=""
						.....f  s icuudId=$o(^DHCICUUnderlyingDisease(0,"ICUA",icuaId,icuudId)) q:icuudId=""  d
							......s clcudId=$lg($g(^DHCICUUnderlyingDisease(icuudId)),2)
							......q:clcudId=""
							......q:$lg(^DHCCLC("UnderlyingDisease",clcudId),2)=""
							......i value'="" s value=value_","
							......s value=value_$lg(^DHCCLC("UnderlyingDisease",clcudId),2)
							......//w value,!
					....s searchVal=value
					....q:$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),5)'=1
					....s $p(icuStr,"^",posList(posCode))=value
					....i sumType'="" s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),value)
				...i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3)="P" d
					....s typeName=icuciiCode
					....s value=..GetInfoByIcuaId(icuaId,typeName,needNote,durationHour,inquiryFromDate,inquiryToDate,oeoriNote,refValue,exactTime,dataField)
					....i (icuciiCode="VAP")!(icuciiCode="CR-BSI")!(icuciiCode="CA-UTI") d
						.....
						.....s retHI=##class(DHCMed.NINFService.Service).GetInfTypeByAdm(EpisodeID) //院感接口
						.....//i retHI'="" w retHI b
						.....q:icuciiCode'=$p(retHI,":")
						.....s hiDate=$p(retHI,":",2)
						.....q:hiDate=""
						.....s hiDate=##class(web.DHCClinicCom).ConvertToDateH(hiDate)
						.....q:(hiDate<inquiryFromDate)!(hiDate>inquiryToDate)
						.....s value=$p(retHI,":",2)
					....;s inDate=$p($g(inDateTime),".",1),inTime=(inDateTime-inDate)*100000	 //获取入病区日期 add mfc 20140609
					....i (typeName="ICUCount")&&((inDate>=inquiryFromDate)&&(inDate<=inquiryToDate)) s tmpCount=tmpCount+1,value=tmpCount
					....e  i typeName="ICUCount" s value=" "
					....i typeName="LeaveDay",value'="" s leaveCount=leaveCount+1
					....q:(minQty'="")&(maxQty'="")&((value<minQty)!(value>maxQty))
					....s oeoriNote=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),14) //持续泵用
					....q:(needNote'="")&(("^"_needNote_"^")'[("^"_value_"^"))
					....;q:(needNote'="")&(typeName="ICUAShockType")&((","_value_",")'[(","_needNote_","))
					....s dateTimeStr=""
					....i (icuciiCode="icuInDateTime") d  //主项目时间：入病区时间
					.....s dateTimeStr=##class(web.DHCClinicCom).DateTimeAdd(inDate,inTime,icuciToTime)
					....i (icuciiCode="icuOutDateTime") d  //主项目时间：出病区时间
					.....s dateTimeStr=##class(web.DHCClinicCom).DateTimeAdd(outDate,outTime,icuciFromTime)								
					....i dateTimeStr'="" d //保存主项目时间(出入病区时间)
					.....i exactTime="" s exactTime=$p(dateTimeStr,"^",2)							
					.....i $g(^TmpICUOeoriSDt(icuaId,icuciiSub))="" s ^TmpICUOeoriSDt(icuaId,icuciiSub)=$p(dateTimeStr,"^",1)_" "_exactTime //;记录第一次时间
					.....s value=$zd($p(dateTimeStr,"^",1),3)_" "_$zt(exactTime,2)
					....s searchVal=value
					....q:$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),5)'=1
					....s curType=""
					....s $p(icuStr,"^",posList(posCode))=value
					....i (icuciDataType="D") d  //按数据时间显示
					.....s curType="All"
					....i curType="All" d
					.....s ^TMPDHCPATION("regNo",icuciId,regNo,posList(posCode))=value
					.....s curDateTime="",RegNo=""
					....i sumType'="" s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),value)
					....;i needNote["EO" b ;p02
					....//i (icuciiCode="VAP")!(icuciiCode="CR-BSI")!(icuciiCode="CA-UTI") d
				...i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3)="D" d //医生
					....s docName=icuciiCode
					....s docStr=##class(web.DHCCLScore).FindResidentAndAttendingCtcp(+^DHCICUArrange(icuaId),39)
					....s residentDoc=$p(docStr,"^",1)
					....s attendingDoc=$p(docStr,"^",2)
					....i dataField="Resident" s value=residentDoc
					....i dataField="Attending" s value=attendingDoc
					....i dataField="Charge" d
						.....s chargeNurseDr=$p($g(^DHCICUArrange(+icuaId)),"^",60) //责任护士 LYN 20160118
						.....i chargeNurseDr'="" s value=$p(##class(web.DHCClinicCom).GetUserTypeName(chargeNurseDr),"^",2)
					....i dataField="Supervisor" d
						.....s supervisorNurseDr=$p($g(^DHCICUArrange(+icuaId)),"^",61) //主管护士 LYN 20160118
						.....i supervisorNurseDr'="" s value=$p(##class(web.DHCClinicCom).GetUserTypeName(supervisorNurseDr),"^",2)
					....s searchVal=value
					....q:$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),5)'=1
					....s $p(icuStr,"^",posList(posCode))=value
					....i sumType'="" s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),value)
				...i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3)="OLR" d //(新单据不使用！)医嘱、检验、监护层层相扣获取			  
					....s typeName=icuciiCode	
					....s findArcimDT="",findLabDesc="",findRecordV="",againArcimDT="",findLabDesc2="",value=""
					....//typeName：GetYZ(获取医嘱)-GetJY(获取检验)-GetJH(监护数据)/GetYZ(获取医嘱)-医嘱ID-监护项目ID-医嘱ID-检验ID
					....//needNote:采集标本"^"检验子项目
					....i (("^"_$p(typeName,"~",1)_"^")[("^"_"GetYZ"_"^")) d //医嘱
					.....s arcimIdStr=$p(typeName,"~",4)
					.....s findArcimDT=..getOeOrdAndDateTime(inquiryFromDate,"",inquiryToDate,"",inDateTime,outDateTime,arcimIdStr,oeordId,$p(needNote,"^",1),dataField,"E")
					....i (("^"_$p(typeName,"~",2)_"^")[("^"_"GetJY"_"^"))&&(findArcimDT'="") d //检验
					.....s ArcimDesc="",ArcimDateTime=""
					.....f i=1:1:$l(findArcimDT,"#") d				
					......s ArcimDesc=$p(findArcimDT,"#",i)
					......s ArcimDr=$p(ArcimDesc,"!",1)
					......s ArcimDateTime=$p(ArcimDesc,"!",2)				
					......s temstr=$G(^OEORD($p(ArcimDr,"||",1),"I",$p(ArcimDr,"||",2),3))
 					......s TestSetRow=$P(temstr,"^",35)
 					......q:TestSetRow="" 				 	
 					......s labno=$P(TestSetRow,"||",1)
 					......s ts=$P(TestSetRow,"||",2)
 					......s tscnt=$P(TestSetRow,"||",3)
 					......s tc=""
 					......f  s tc=$O(^TEPI(labno,1,ts,tscnt,"DATA",tc)) q:tc=""  d
    				.......s resstr=$p(^(tc),"\",1)
    				.......q:resstr="" 
 					.......s (resdate,tcPrintSeq)=""
 					.......s testCode="",testCodeStr=""
 					.......i ($p(needNote,"^",2)'="") d //获取检验子项目
					........f  s testCode=$o(^TTABi("TC","NNL",$p(needNote,"^",2),testCode)) q:testCode=""  d
					.........i testCodeStr'="" s testCodeStr=testCodeStr_"^"
					.........s testCodeStr=testCodeStr_testCode
 					.......q:(testCodeStr'="")&&(("^"_testCodeStr_"^")'[("^"_tc_"^")) 
 					.......s temres=##Class(LabService.TCCommon).GetTestCodeResult(labno,tc,resstr)
 					.......s ItemDesc=$Piece(temres,$Char(2),2)
 					.......s ItemResult=$Piece(temres,$Char(2),3)
 					.......i (ItemResult'="")&&($p($g(^TTAB("TC",tc)),"\",3)="V") d
 					........s ItemResult=$p($g(^TTAB("BUG",ItemResult)),"\",1)
 					.......i findLabDesc="" d
 					........i ItemResult'="" s findLabDesc=ItemResult_"_"_ArcimDateTime
 					.......e  d
 					........i ItemResult'="" s findLabDesc=findLabDesc_"#"_ItemResult_"_"_ArcimDateTime
 					....i (("^"_$p(typeName,"~",3)_"^")[("^"_"GetJH"_"^"))&&(findLabDesc'="") d //监护
					.....s icucriCode=$p(typeName,"~",5)
					.....q:icucriCode=""
					.....i icucriCode'=+icucriCode s icucriIdStr=##class(web.DHCICUCom).GetIcuriIdByCode(icucriCode)
					.....e  s icucriIdStr=icucriCode
					.....q:icucriIdStr=""
					.....f i=1:1:$l(icucriIdStr,"^") d
						......s icucriId=$p(icucriIdStr,"^",i)
						......q:icucriId=""			
						......;i (icuaId=4246) s ^tempmfc(4246)=icuaId_"/"_icucriId_"/"_findArcimDT			
						......f j=1:1:$l(findLabDesc,"#") d //下医嘱日期时间
						.......s tmpRecordV="",findRecFormerV="",findRecAfterV=""
						.......s LabDesc=$p(findLabDesc,"#",j),LabDesc=$p(LabDesc,"_",2)	
						.......s oeordDate=$p(LabDesc," ",1),oeordTime=$p(LabDesc," ",2)				
						.......s oeordDate=##class(web.DHCClinicCom).ConvertToDateH(oeordDate)
						.......s oeordTime=##class(web.DHCClinicCom).ConvertToTimeH(oeordTime)
						.......i (minQty'="")&&(maxQty="") d //标本送检前小时数据
						........s maxNum="",minNum="",maxNumRecV="",minNumRecV="",RecFormerV=""	
						........s tmpRecordV=""			
						........s oeordPreDateTime=..getPreDateTime(oeordDate,oeordTime,"-",minQty)
						........s oeordPreDate=$p(oeordPreDateTime," ",1),oeordPreTime=$p(oeordPreDateTime," ",2)
						........s tmpRecordV=##class(web.DHCICUOrder).GetRecordValue(icuaId,icucriId,oeordPreDate,oeordPreTime,oeordDate,oeordTime,"touchQty","","","","AddDateTime")
 				 		........i tmpRecordV'="" d			
						.........s tmpRecordStr=$p(tmpRecordV,"#",1),tmpRecordDT=$p(tmpRecordV,"#",2)
						.........f x=1:1:$l(tmpRecordStr,"^") d
						..........q:$p(tmpRecordStr,"^",x)=""
						..........i (x=1) s maxNum=$p(tmpRecordStr,"^",x),minNum= $p(tmpRecordStr,"^",x),minNumRecV=$p(tmpRecordStr,"^",x)_"_"_$p(tmpRecordDT,"^",x),maxNumRecV=$p(tmpRecordStr,"^",x)_"_"_$p(tmpRecordDT,"^",x)
						..........i $p(tmpRecordStr,"^",x)=+$p(tmpRecordStr,"^",x) d
						...........i $p(tmpRecordStr,"^",x)<=minNum s minNum= $p(tmpRecordStr,"^",x),minNumRecV=$p(tmpRecordStr,"^",x)_"_"_$p(tmpRecordDT,"^",x)
						...........i $p(tmpRecordStr,"^",x)>=maxNum s maxNum= $p(tmpRecordStr,"^",x),maxNumRecV=$p(tmpRecordStr,"^",x)_"_"_$p(tmpRecordDT,"^",x) 					
						...........s RecFormerV=minNumRecV_" "_maxNumRecV
						..........e  d
						...........i RecFormerV="" s RecFormerV=$p(tmpRecordStr,"^",x)_"_"_$p(tmpRecordDT,"^",x)
						...........e  s RecFormerV=RecFormerV_" "_$p(tmpRecordStr,"^",x)_"_"_$p(tmpRecordDT,"^",x)
						.........s findRecFormerV=RecFormerV
 				 		.......i (minQty'="")&&(maxQty'="") d //标本送检前后小时数据
 				 		........s maxNum="",minNum="",maxNumRecV="",minNumRecV="",RecFormerV=""														
						........f k=maxQty:-1:minQty d //前六小时监护数据
						.........s tmpRecordV=""			
						.........s oeordPreDateTime=..getPreDateTime(oeordDate,oeordTime,"-",k)
						.........s oeordPreDate=$p(oeordPreDateTime," ",1),oeordPreTime=$p(oeordPreDateTime," ",2)
						.........s oeordNowDateTime=..getPreDateTime(oeordDate,oeordTime,"-",k-1)
						.........s oeordNowDate=$p(oeordNowDateTime," ",1),oeordNowTime=$p(oeordNowDateTime," ",2)
						.........s tmpRecordV=##class(web.DHCICUOrder).GetRecordValue(icuaId,icucriId,oeordPreDate,oeordPreTime,oeordNowDate,oeordNowTime,"First","","","","AddDateTime")
 				 		.........i (tmpRecordV'="")&&(tmpRecordV'=" ") d
 				 		..........i (k=maxQty-1) s maxNum=$p(tmpRecordV," ",1),minNum= $p(tmpRecordV," ",1),minNumRecV=$p(tmpRecordV," ",1)_"_"_$p(tmpRecordV," ",2)_" "_$p(tmpRecordV," ",3),maxNumRecV=$p(tmpRecordV," ",1)_"_"_$p(tmpRecordV," ",2)_"_"_$p(tmpRecordV," ",3)
						..........i $p(tmpRecordV," ",1)=+$p(tmpRecordV," ",1) d
						...........i $p(tmpRecordV," ",1)<=minNum s minNum= $p(tmpRecordV," ",1),minNumRecV=$p(tmpRecordV," ",1)_"_"_$p(tmpRecordV," ",2)_" "_$p(tmpRecordV," ",3)
						...........i $p(tmpRecordV," ",1)>=maxNum s maxNum= $p(tmpRecordV," ",1),maxNumRecV=$p(tmpRecordV," ",1)_"_"_$p(tmpRecordV," ",2)_" "_$p(tmpRecordV," ",3)
						...........s RecFormerV=minNumRecV_" "_maxNumRecV
						..........e  d
						...........i RecFormerV="" s RecFormerV=$p(tmpRecordV," ",1)_"_"_$p(tmpRecordV," ",2)_" "_$p(tmpRecordV," ",3)
						...........e  s RecFormerV=RecFormerV_" "_$p(tmpRecordV," ",1)_"_"_$p(tmpRecordV," ",2)_" "_$p(tmpRecordV," ",3)
 				 		........i findRecFormerV="" s findRecFormerV=RecFormerV
 						........e  s findRecFormerV=findRecFormerV_" "_RecFormerV 			
 						........s maxNum="",minNum="",maxNumRecV="",minNumRecV="",RecFormerV=""
 						........f z=minQty:1:maxQty d //后六小时监护数据
 						.........s tmpRecordV=""
 						.........s oeordPreDateTime=..getPreDateTime(oeordDate,oeordTime,"+",z-1)					
						.........s oeordPreDate=$p(oeordPreDateTime," ",1),oeordPreTime=$p(oeordPreDateTime," ",2)
						.........s oeordNowDateTime=..getPreDateTime(oeordDate,oeordTime,"+",z)
						.........s oeordNowDate=$p(oeordNowDateTime," ",1),oeordNowTime=$p(oeordNowDateTime," ",2)
						.........;i (icuaId=4146) s ^tempmfc("2013"_i_j_z)=$zd(oeordPreDate,3)_" "_$zt(oeordPreTime,2)_" "_$zd(oeordNowDate,3)_" "_$zt(oeordNowTime,2)
						.........s tmpRecordV=##class(web.DHCICUOrder).GetRecordValue(icuaId,icucriId,oeordPreDate,oeordPreTime,oeordNowDate,oeordNowTime,"First","","","","AddDateTime")
  						.........i (tmpRecordV'="")&&(tmpRecordV'=" ") d
  						..........i (z=minQty-1) s maxNum=$p(tmpRecordV," ",1),minNum= $p(tmpRecordV," ",1),minNumRecV=$p(tmpRecordV," ",1)_"_"_$p(tmpRecordV," ",2)_" "_$p(tmpRecordV," ",3),maxNumRecV=$p(tmpRecordV," ",1)_"_"_$p(tmpRecordV," ",2)_" "_$p(tmpRecordV," ",3)
						..........i $p(tmpRecordV," ",1)=+$p(tmpRecordV," ",1) d
						...........i $p(tmpRecordV," ",1)<=minNum s minNum= $p(tmpRecordV," ",1),minNumRecV=$p(tmpRecordV," ",1)_"_"_$p(tmpRecordV," ",2)_" "_$p(tmpRecordV," ",3)
						...........i $p(tmpRecordV," ",1)>=maxNum s maxNum= $p(tmpRecordV," ",1),maxNumRecV=$p(tmpRecordV," ",1)_"_"_$p(tmpRecordV," ",2)_" "_$p(tmpRecordV," ",3)
						...........s RecFormerV=minNumRecV_" "_maxNumRecV
						..........e  d
						...........i RecFormerV="" s RecFormerV=$p(tmpRecordV," ",1)_"_"_$p(tmpRecordV," ",2)_" "_$p(tmpRecordV," ",3)
						...........e  s RecFormerV=RecFormerV_" "_$p(tmpRecordV," ",1)_"_"_$p(tmpRecordV," ",2)_" "_$p(tmpRecordV," ",3)	
  						........i findRecFormerV="" s findRecFormerV=RecFormerV
 						........e  s findRecFormerV=findRecFormerV_" "_RecFormerV
 						.......i findRecordV="" s findRecordV=findRecFormerV 					
 						.......e  s findRecordV=findRecordV_"#"_findRecFormerV
 					....i (("^"_$p(typeName,"~",3)_"^")[("^"_"GetYZ"_"^")) d //重叠获取医嘱
 					.....s arcimIdStr=$p(typeName,"~",6)
 					.....f i=1:1:$l(arcimIdStr,"^") d
					......s arcimId=$p(arcimIdStr,"^",i)				
 					......f j=1:1:$l(findLabDesc,"#") d //下医嘱日期时间
 					.......q:$p(findLabDesc,"#",j)=""
 					.......;i (icuaId=4294) s ^tempmfc("2013"_i_j)=$p(findLabDesc,"#",j)
					.......s findRecFormerV="",findRecAfterV=""
					.......s LabDesc=$p(findLabDesc,"#",j),LabDesc=$p(LabDesc,"_",2)	
					.......s oeordDate=$p(LabDesc," ",1),oeordTime=$p(LabDesc," ",2)				
					.......s oeordDate=##class(web.DHCClinicCom).ConvertToDateH(oeordDate)
					.......s oeordTime=##class(web.DHCClinicCom).ConvertToTimeH(oeordTime)
					.......s tmpRecFormerV="",oeordPreDate="",oeordPreTime="",oeordNowDate="",oeordNowTime=""
					.......i (minQty'="")&&(maxQty="") d //标本送检前 超过使用48小时
					........s tmpRecFormerV=..getOeOrdAndDateTime(inquiryFromDate,0,oeordDate,oeordTime,inDateTime,outDateTime,arcimId,oeordId,"",dataField,"V")
					........i tmpRecFormerV'="" d
					.........f x=1:1:$l(tmpRecFormerV,"#") d
					..........q:($p($p(tmpRecFormerV,"#",x),"!",2)="")
					..........s tmpDate=$zdh($p($p($p(tmpRecFormerV,"#",x),"!",2)," ",1),3),tmpTime=$zth($p($p($p(tmpRecFormerV,"#",x),"!",2)," ",2),2)
					..........q:##class(web.DHCClinicCom).CalculateDuration(tmpDate,tmpTime,oeordDate,oeordTime,"H")<=minQty
					..........i findRecFormerV="" s findRecFormerV=$p($p(tmpRecFormerV,"#",x),"!",2)
					..........e  s findRecFormerV=findRecFormerV_" "_$p($p(tmpRecFormerV,"#",x),"!",2)
					.......i (minQty'="")&&(maxQty'="") d	//标本送检前后多少小时
					........f k=maxQty:-1:minQty d //前几小时医嘱数据
					.........s tmpRecFormerV="",tmpRecAfterV=""			
					.........s oeordPreDateTime=..getPreDateTime(oeordDate,oeordTime,"-",k)
					.........s oeordPreDate=$p(oeordPreDateTime," ",1),oeordPreTime=$p(oeordPreDateTime," ",2)
					........s tmpRecFormerV=..getOeOrdAndDateTime(oeordPreDate,oeordPreTime,oeordDate,oeordTime,inDateTime,outDateTime,arcimId,oeordId,"",dataField,"V")
					........i tmpRecFormerV'="" d
					.........f x=1:1:$l(tmpRecFormerV,"#") d
					..........q:($p($p(tmpRecFormerV,"#",x),"!",2)="")
					..........i findRecFormerV="" s findRecFormerV=$p($p(tmpRecFormerV,"#",x),"!",2)
					..........e  s findRecFormerV=findRecFormerV_" "_$p($p(tmpRecFormerV,"#",x),"!",2)								
 					........f z=minQty:1:maxQty d //后几小时医嘱数据 				
					.........s oeordNowDateTime=..getPreDateTime(oeordDate,oeordTime,"+",z)
					.........s oeordNowDate=$p(oeordNowDateTime," ",1),oeordNowTime=$p(oeordNowDateTime," ",2)
					........s tmpRecAfterV=..getOeOrdAndDateTime(oeordDate,oeordTime,oeordNowDate,oeordNowTime,inDateTime,outDateTime,arcimId,oeordId,"",dataField,"V")
  					........i tmpRecAfterV'="" d
  					.........f y=1:1:$l(tmpRecAfterV,"#") d
  					..........q:($p($p(tmpRecAfterV,"#",y),"!",2)="")  			
					..........i findRecFormerV="" s findRecFormerV=$p($p(tmpRecAfterV,"#",y),"!",2)
					..........e  s findRecFormerV=findRecFormerV_" "_$p($p(tmpRecAfterV,"#",y),"!",2)  				
 					.......i againArcimDT="" s againArcimDT=findRecFormerV
 					.......e  i findRecFormerV'="" s againArcimDT=againArcimDT_"#"_findRecFormerV
 					....i (("^"_$p(typeName,"~",3)_"^")[("^"_"GetJY"_"^")) d //重叠获取检验
 					.....s isSingle=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),7)
 					.....s LabCodeStr=$p(typeName,"~",7)
 					.....f i=1:1:$l(LabCodeStr,"^") d
					......s LabCode=$p(LabCodeStr,"^",i)				
 					......f j=1:1:$l(findLabDesc,"#") d //下医嘱日期时间
 					.......q:$p(findLabDesc,"#",j)=""
 					.......s findRecFormerV="",findRecAfterV=""
					.......s LabDesc=$p(findLabDesc,"#",j),LabDesc=$p(LabDesc,"_",2)	
					.......s oeordDate=$p(LabDesc," ",1),oeordTime=$p(LabDesc," ",2)								
					.......s oeordDate=##class(web.DHCClinicCom).ConvertToDateH(oeordDate)
					.......s oeordTime=##class(web.DHCClinicCom).ConvertToTimeH(oeordTime)
					.......s maxNum="",minNum="",maxNumRecV="",minNumRecV="",RecFormerV=""			
					.......i (minQty'="")&&(maxQty="") d //标本送检前小时数据						
					........s oeordPreDateTime=..getPreDateTime(oeordDate,oeordTime,"-",minQty)
					........s oeordPreDate=$p(oeordPreDateTime," ",1),oeordPreTime=$p(oeordPreDateTime," ",2)
					........s tmpRecAfterV=##class(web.DHCClinicCom).GetTestResult("", regNo, "", LabCode, oeordPreDate, oeordPreTime, oeordDate, oeordTime, isSingle,$p(needNote,"^",1))
					........i tmpRecAfterV'="" d
  					.........f y=1:1:$l(tmpRecAfterV,"^") d
  					..........q:($p($p(tmpRecAfterV,"^",y),"\",1)="")
  					..........s tmpValue=$p($p(tmpRecAfterV,"^",y),"\",1)
  					..........s tmpDateTime=$zd($p($p(tmpRecAfterV,"^",y),"\",4),3)_" "_$zt($p($p(tmpRecAfterV,"^",y),"\",5),2)
  					..........i (y=1) s maxNum=$p($p(tmpRecAfterV,"^",y),"\",1),minNum= $p($p(tmpRecAfterV,"^",y),"\",1),minNumRecV=tmpValue_"_"_tmpDateTime,maxNumRecV=tmpValue_"_"_tmpDateTime
					..........i tmpValue=+tmpValue d
					...........i tmpValue<minNum s minNum=tmpValue,minNumRecV=tmpValue_"_"_tmpDateTime
					...........i tmpValue>maxNum s maxNum=tmpValue,maxNumRecV=tmpValue_"_"_tmpDateTime				
					...........s RecFormerV=minNumRecV_" "_maxNumRecV
					..........e  d
					...........i RecFormerV="" s RecFormerV=tmpValue_"_"_tmpDateTime
					...........e  s RecFormerV=RecFormerV_" "_tmpValue_"_"_tmpDateTime
					.........s findRecFormerV=RecFormerV  				  				 			
					.......i findLabDesc2="" s findLabDesc2=findRecFormerV
 					.......e  s findLabDesc2=findLabDesc2_"#"_findRecFormerV
					....i (("^"_$p(typeName,"~",1)_"^")[("^"_"GetYZ"_"^")) s value=findArcimDT
					....i (("^"_$p(typeName,"~",2)_"^")[("^"_"GetJY"_"^")) s value=findLabDesc
					....i (("^"_$p(typeName,"~",3)_"^")[("^"_"GetJH"_"^")) s value=findRecordV
					....i (("^"_$p(typeName,"~",3)_"^")[("^"_"GetYZ"_"^")) s value=againArcimDT
					....i (("^"_$p(typeName,"~",3)_"^")[("^"_"GetJY"_"^")) s value=findLabDesc2
					....s searchVal=value
					....q:$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),5)'=1
					....s $p(icuStr,"^",posList(posCode))=value
					....i sumType'="" s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),value)
				...i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),27)'="" d //获取主项数据 
					....q //不再使用
					....q:icuciId=42
					....q:icuciId=45
					....q:icuciId=75
					....s ^dhctmpmfc(icuaId,icuciId,icuciiSub)=icuciiCode
					....s typeName=icuciiCode	
					....s findArcimDT="",findLabDesc="",findRecordV="",againArcimDT="",findLabDesc2="",value=""
					....s findLabDesc=$g(^TmpICUOeoriSDt(icuaId,$p($lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),27),"||",2)))
					....;i icuaId=8952 s ^dhctmpmfc(icuaId,icuciId,icuciiSub,$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),27))	=findLabDesc
					....	
					....s durationHour=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),13)		
					....s inDate=$p($g(inDateTime),".",1) //获取入病区日期 add mfc 20140609
					....s outDate=$p($g(outDateTime),".",1)
					....s inTime=("."_$p($g(inDateTime),".",2))*100000 //获取入病区时间 add mfc 20140609
					....s outTime=("."_$p($g(outDateTime),".",2))*100000 //获取出病区时间				
					....i icuciiStartDateTime="InWardData" s findLabDesc=inDate_" "_inTime
					....i icuciiStartDateTime="OutWardData" s findLabDesc=outDate_" "_outTime				
					....i (minQty="")&&(maxQty="") s maxQty="24" //当前时间点	
					....i (icuciiStartDateTime="InExeDate")&&(durationHour'="") d  //设置起始日期
						.....q:durationHour=""			
						.....f j=1:1:$l(findLabDesc,"#") d //主项执行时间		
 						......q:$p(findLabDesc,"#",j)="" 		
						......s LabDesc=$p(findLabDesc,"#",j) //,LabDesc=$p(LabDesc," ",2)	
						......s oeordDate=$p(LabDesc," ",1),oeordTime=$p(LabDesc," ",2)
						......s oeordNowDateTime=..getPreDateTime(oeordDate,oeordTime,"+",durationHour)
						......s $p(findLabDesc,"#",j)=oeordNowDateTime
					....
					....i (("^"_$p(typeName,"~",1)_"^")[("^"_"ExeDate"_"^")) d  //获取主项执行时间
						.....f j=1:1:$l(findLabDesc,"#") d //主项执行时间
 						......q:$p(findLabDesc,"#",j)=""
						......s LabDesc=$p(findLabDesc,"#",j) //,LabDesc=$p(LabDesc," ",2)	
						......s oeordDate=$p(LabDesc," ",1),oeordTime=$p(LabDesc," ",2)
						......i findLabDesc2="" s findLabDesc2=$zd(oeordDate,3)_" "_$zt(oeordTime,2)
 						......e  s findLabDesc2=findLabDesc2_"#"_$zd(oeordDate,3)_" "_$zt(oeordTime,2)
 					....i (icuciiStartDateTime="InExeDate") d //主项执行时间为空，取入病区时间
 						.....f j=1:1:$l(findLabDesc,"#") d //主项执行时间
 						......;q:$p(findLabDesc,"#",j)=""
						......s LabDesc=$p(findLabDesc,"#",j) //,LabDesc=$p(LabDesc," ",2)	
						......s oeordDate=$p(LabDesc," ",1),oeordTime=$p(LabDesc," ",2)
						......i oeordDate="" d
						.......
						.......i (durationHour'="") d
						........s oeordDate=inDate,oeordTime=inTime
						........s oeordNowDateTime=..getPreDateTime(oeordDate,oeordTime,"+",durationHour)
						........s $p(findLabDesc,"#",j)=oeordNowDateTime
						.......e  d
						........s $p(findLabDesc,"#",j)=inDate_" "_inTime
					....
					....i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3)="L" d //获取检验数据
 						.....s isSingle=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),7) 					
 						.....s LabCodeStr=$p(typeName,"~",1)
 						.....f i=1:1:$l(LabCodeStr,"^") d
						......s LabCode=$p(LabCodeStr,"^",i)				
 						......f j=1:1:$l(findLabDesc,"#") d //主项执行时间					
 						.......q:$p(findLabDesc,"#",j)=""
 						.......s findRecFormerV="",findRecAfterV=""
						.......s LabDesc=$p(findLabDesc,"#",j) //,LabDesc=$p(LabDesc," ",2)	
						.......s oeordDate=$p(LabDesc," ",1),oeordTime=$p(LabDesc," ",2)								
						.......s oeordDate=##class(web.DHCClinicCom).ConvertToDateH(oeordDate)
						.......s oeordTime=##class(web.DHCClinicCom).ConvertToTimeH(oeordTime)
						.......
						.......i (minQty'="")&&(maxQty="") d //标本送检前小时数据(最后一次)						
						........s oeordPreDateTime=..getPreDateTime(oeordDate,oeordTime,"+",minQty)
						........s oeordPreDate=$p(oeordPreDateTime," ",1),oeordPreTime=$p(oeordPreDateTime," ",2)
						........s tmpRecAfterV=##class(web.DHCClinicCom).GetTestResult("", regNo, "", LabCode, oeordPreDate, oeordPreTime, oeordDate, oeordTime, isSingle,$p(needNote,"^",1),dataField)
						........s tmpMinIndex=1,tmpDateValue="",tmpTimeValue=""
						........i tmpRecAfterV'="" d				
  						.........f y=1:1:$l(tmpRecAfterV,"^") d
  						..........q:($p($p(tmpRecAfterV,"^",y),"\",1)="")  						
						..........i findRecFormerV="" s findRecFormerV=$p($p(tmpRecAfterV,"^",y),"\",1)
						..........e  s findRecFormerV=findRecFormerV_" "_$p($p(tmpRecAfterV,"^",y),"\",1)
						.......;
						.......i (minQty="")&&(maxQty'="") d //标本送检后小时数据(第一次)									
						........s oeordNowDateTime=..getPreDateTime(oeordDate,oeordTime,"+",maxQty)
						........s oeordNowDate=$p(oeordNowDateTime," ",1),oeordNowTime=$p(oeordNowDateTime," ",2)
						........s tmpRecAfterV=##class(web.DHCClinicCom).GetTestResult("", regNo, "", LabCode,  oeordDate, oeordTime,oeordNowDate, oeordNowTime, isSingle,$p(needNote,"^",1),dataField)
						........s tmpMinIndex=1,tmpDateValue="",tmpTimeValue=""
  						........i tmpRecAfterV'="" d				
  						.........f y=1:1:$l(tmpRecAfterV,"^") d
  						..........q:($p($p(tmpRecAfterV,"^",y),"\",1)="")  						
						..........i findRecFormerV="" s findRecFormerV=$p($p(tmpRecAfterV,"^",y),"\",1)
						..........e  s findRecFormerV=findRecFormerV_" "_$p($p(tmpRecAfterV,"^",y),"\",1)
						.......
						.......i (minQty'="")&&(maxQty'="") d //标本送检前后小时数据
 						........s tmpRecordV=""
 						........s oeordPreDateTime=..getPreDateTime(oeordDate,oeordTime,"+",minQty)					
						........s oeordPreDate=$p(oeordPreDateTime," ",1),oeordPreTime=$p(oeordPreDateTime," ",2)
						........s oeordNowDateTime=..getPreDateTime(oeordDate,oeordTime,"+",maxQty)
						........s oeordNowDate=$p(oeordNowDateTime," ",1),oeordNowTime=$p(oeordNowDateTime," ",2)					
						........s tmpRecAfterV=##class(web.DHCClinicCom).GetTestResult("", regNo, "", LabCode, oeordPreDate, oeordPreTime, oeordNowDate, oeordNowTime, isSingle,$p(needNote,"^",1),dataField)
						........i tmpRecAfterV'="" d				
  						.........f y=1:1:$l(tmpRecAfterV,"^") d
  						..........q:($p($p(tmpRecAfterV,"^",y),"\",1)="")  						
						..........i findRecFormerV="" s findRecFormerV=$p($p(tmpRecAfterV,"^",y),"\",1)
						..........e  s findRecFormerV=findRecFormerV_" "_$p($p(tmpRecAfterV,"^",y),"\",1)
						........
						.......i findLabDesc2="" s findLabDesc2=findRecFormerV
 						.......e  s findLabDesc2=findLabDesc2_"@"_findRecFormerV 						
 					....i ($lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3)="R")&&(findLabDesc'="") d //监护数据 								
						.....i icuaId=10460 	s ^dhctmpmfc(icuaId,icuciId,icuciiSub)=typeName b ;"R"
						.....i icuaId=10460  b ;"10460" 
						.....w icuaId ,!
						.....b ;"10460"
						.....s icucriCode=$p(typeName,"~",1)
						.....q:icucriCode=""																			
						.....i icucriCode'=+icucriCode s icucriIdStr=##class(web.DHCICUCom).GetIcuriIdByCode(icucriCode)
						.....e  s icucriIdStr=icucriCode					 
						.....q:icucriIdStr=""									
						.....f i=1:1:$l(icucriIdStr,"^") d
						......q:(findRecordV'="")&&(("^"_icucriCode_"^"["^NMBP^")||("^"_icucriCode_"^"["^AMBP^")) //获取有创无创任意一个
						......s icucriId=$p(icucriIdStr,"^",i)
						......q:icucriId=""			
						......f j=1:1:$l(findLabDesc,"#") d //主项执行时间						
						.......s tmpRecordV="",findRecFormerV="",findRecAfterV=""
						.......s LabDesc=$p(findLabDesc,"#",j) //,LabDesc=$p(LabDesc,"_",2)	
						.......s oeordDate=$p(LabDesc," ",1),oeordTime=$p(LabDesc," ",2)				
						.......s oeordDate=##class(web.DHCClinicCom).ConvertToDateH(oeordDate)
						.......s oeordTime=##class(web.DHCClinicCom).ConvertToTimeH(oeordTime)
						.......i (minQty'="")&&(maxQty="") d //前小时数据	
						........s tmpRecordV=""			
						........s oeordPreDateTime=..getPreDateTime(oeordDate,oeordTime,"+",minQty)
						........s oeordPreDate=$p(oeordPreDateTime," ",1),oeordPreTime=$p(oeordPreDateTime," ",2)						
						........s tmpRecordV=##class(web.DHCICUOrder).GetRecordValue(icuaId,icucriId,oeordPreDate,oeordPreTime,oeordDate,oeordTime,dataField,"","",oeoriNote,"AddDateTime",refIcucriId,refValue,needNote)					
 				 	 	........;i icuaId=7653 s ^dhctmpmfc(i,icuciId,icuciiSub)=icuaId_"/"_icucriId_"/"_oeordDate_"/"_oeordTime_"/"_oeordNowDate_"/"_oeordNowTime_"/"_dataField_"/"_oeoriNote
 				 		........i (tmpRecordV'="")&&(tmpRecordV'="#") d
 				 			.........f k=1:1:$l(tmpRecordV,"#") d //
							..........s tmpRecordVAndDT=$p(tmpRecordV,"#",k)							
							..........s tmpRecordValue=$p(tmpRecordVAndDT,"~",1)
							..........s tmpRecordDT=$p(tmpRecordVAndDT,"~",2)
							..........i $g(^TmpICUOeoriSDt(icuaId,icuciiSub))="" s ^TmpICUOeoriSDt(icuaId,icuciiSub)=$p($g(tmpRecordDT)," ",1)_" "_$p($g(tmpRecordDT)," ",2) //;记录第一次时间
							..........e  i $p($g(^TmpICUOeoriSDt(icuaId,icuciiSub))," ",1)>$p(tmpRecordDT," ",1)	s ^TmpICUOeoriSDt(icuaId,icuciiSub)=$p($g(tmpRecordDT)," ",1)_" "_$p($g(tmpRecordDT)," ",2)
							..........i (dataField="FirstDT")||(dataField="MinDT")||(dataField="MaxDT")||(dataField="MinMaxDT") d
							...........i findRecFormerV="" s findRecFormerV=tmpRecordValue_"~"_tmpRecordDT
							...........e  s findRecFormerV=findRecFormerV_"#"_tmpRecordValue_"~"_tmpRecordDT
							..........e  d 
 				 			...........i findRecFormerV="" s findRecFormerV=tmpRecordValue
 				 			...........e  s findRecFormerV=findRecFormerV_"#"_tmpRecordValue 			 				
 				 		.......i (minQty="")&&(maxQty'="") d //后小时数据	
						........s tmpRecordV=""			
						........s oeordNowDateTime=..getPreDateTime(oeordDate,oeordTime,"+",maxQty)
						........s oeordNowDate=$p(oeordNowDateTime," ",1),oeordNowTime=$p(oeordNowDateTime," ",2)
						........;i icuaId=8969 s ^dhctmpmfc(i,icuciId,icuciiSub)=icuaId_"/"_icucriId_"/"_oeordDate_"/"_oeordTime_"/"_oeordNowDate_"/"_oeordNowTime_"/"_dataField_"/"_oeoriNote
						........s tmpRecordV=##class(web.DHCICUOrder).GetRecordValue(icuaId,icucriId,oeordDate,oeordTime,oeordNowDate,oeordNowTime,dataField,"","",oeoriNote,"AddDateTime",refIcucriId,refValue,needNote)
						........;i icuaId=8952 s ^dhctmpmfc(icuaId,i,icuciId,icuciiSub)=icuaId_"/"_icucriId_"/"_oeordDate_"/"_oeordTime_"/"_oeordNowDate_"/"_oeordNowTime_"/"_dataField_"/"_oeoriNote_"/"_tmpRecordV
 				 		........i (tmpRecordV'="")&&(tmpRecordV'="#") d
 				 			.........
 				 			.........f k=1:1:$l(tmpRecordV,"#") d //
							..........s tmpRecordVAndDT=$p(tmpRecordV,"#",k)							
							..........s tmpRecordValue=$p(tmpRecordVAndDT,"~",1)
							..........s tmpRecordDT=$p(tmpRecordVAndDT,"~",2)
							..........i $g(^TmpICUOeoriSDt(icuaId,icuciiSub))="" s ^TmpICUOeoriSDt(icuaId,icuciiSub)=$p($g(tmpRecordDT)," ",1)_" "_$p($g(tmpRecordDT)," ",2) //;记录第一次时间
							..........e  i $p($g(^TmpICUOeoriSDt(icuaId,icuciiSub))," ",1)>$p(tmpRecordDT," ",1)	s ^TmpICUOeoriSDt(icuaId,icuciiSub)=$p($g(tmpRecordDT)," ",1)_" "_$p($g(tmpRecordDT)," ",2)
							..........i (dataField="FirstDT")||(dataField="MinDT")||(dataField="MaxDT")||(dataField="MinMaxDT") d
							...........i findRecFormerV="" s findRecFormerV=tmpRecordValue_"~"_tmpRecordDT
							...........e  s findRecFormerV=findRecFormerV_"#"_tmpRecordValue_"~"_tmpRecordDT
							..........e  d 
 				 			...........i findRecFormerV="" s findRecFormerV=tmpRecordValue
 				 			...........e  s findRecFormerV=findRecFormerV_"#"_tmpRecordValue 	
 				 		.......i (minQty'="")&&(maxQty'="") d //前后小时数据
						........s tmpRecordV=""			
						........s oeordPreDateTime=..getPreDateTime(oeordDate,oeordTime,"+",minQty)
						........s oeordPreDate=$p(oeordPreDateTime," ",1),oeordPreTime=$p(oeordPreDateTime," ",2)
						........s oeordNowDateTime=..getPreDateTime(oeordDate,oeordTime,"+",maxQty)
						........s oeordNowDate=$p(oeordNowDateTime," ",1),oeordNowTime=$p(oeordNowDateTime," ",2)
						........;s ^dhctmpmfc(icuaId,icucriId)=icuaId_"/"_icucriId_"/"_oeordPreDate_"/"_oeordPreTime_"/"_oeordNowDate_"/"_oeordNowTime_"/"_dataField_"/"_""_"/"_""_"/"_oeoriNote_"/"_"AddDateTime"_"/"_refIcucriId_"/"_refValue_"/"_needNote				
						........s tmpRecordV=##class(web.DHCICUOrder).GetRecordValue(icuaId,icucriId,oeordPreDate,oeordPreTime,oeordNowDate,oeordNowTime,dataField,"","",oeoriNote,"AddDateTime",refIcucriId,refValue,needNote)
 				 		........i (tmpRecordV'="")&&(tmpRecordV'="#") d
 				 			.........f k=1:1:$l(tmpRecordV,"#") d //
 				 			..........;q:(k>5) 				 			
							..........s tmpRecordVAndDT=$p(tmpRecordV,"#",k)
							..........s tmpRecordValue=$p(tmpRecordVAndDT,"~",1)
							..........s tmpRecordDT=$p(tmpRecordVAndDT,"~",2)
							..........i $g(^TmpICUOeoriSDt(icuaId,icuciiSub))="" s ^TmpICUOeoriSDt(icuaId,icuciiSub)=$p($g(tmpRecordDT)," ",1)_" "_$p($g(tmpRecordDT)," ",2) //;记录第一次时间
							..........e  i $p($g(^TmpICUOeoriSDt(icuaId,icuciiSub))," ",1)>$p(tmpRecordDT," ",1)	s ^TmpICUOeoriSDt(icuaId,icuciiSub)=$p($g(tmpRecordDT)," ",1)_" "_$p($g(tmpRecordDT)," ",2)
							..........i (dataField="FirstDT")||(dataField="MinDT")||(dataField="MaxDT")||(dataField="MinMaxDT") d
							...........i findRecFormerV="" s findRecFormerV=tmpRecordValue_"~"_tmpRecordDT
							...........e  s findRecFormerV=findRecFormerV_"#"_tmpRecordValue_"~"_tmpRecordDT
							..........e  d 
 				 			...........i findRecFormerV="" s findRecFormerV=tmpRecordValue
 				 			...........e  s findRecFormerV=findRecFormerV_"#"_tmpRecordValue  				 		
 						.......i findRecordV="" s findRecordV=findRecFormerV 					
 						.......e  s findRecordV=findRecordV_"@"_findRecFormerV
					....i (("^"_$p(typeName,"~",1)_"^")[("^"_"TotalOut"_"^"))&&(findLabDesc'="") d //总出量
 						.....f j=1:1:$l(findLabDesc,"#") d //主项执行时间
						......s tmpRecordV="",findRecFormerV="",findRecAfterV=""
						......s LabDesc=$p(findLabDesc,"#",j)
						......s oeordDate=$p(LabDesc," ",1),oeordTime=$p(LabDesc," ",2)				
						......s oeordDate=##class(web.DHCClinicCom).ConvertToDateH(oeordDate)
						......s oeordTime=##class(web.DHCClinicCom).ConvertToTimeH(oeordTime)
						......i (minQty'="")&&(maxQty="") d //标本送检前小时数据	
						.......s tmpRecordV=""			
						.......s oeordNowDateTime=..getPreDateTime(oeordDate,oeordTime,"+",minQty)
						.......s oeordNowDate=$p(oeordNowDateTime," ",1),oeordNowTime=$p(oeordNowDateTime," ",2)
						.......s findRecFormerV=##class(web.DHCICUOrder).GetIORate(icuaId,oeordNowDate,oeordNowTime,oeordDate,oeordTime)
						.......s findRecFormerV=$p($g(findRecFormerV),"/",2)
						.......s findRecordV=findRecordV+findRecFormerV	
						......i (minQty="")&&(maxQty'="") d //标本送检后小时数据	
						.......s tmpRecordV=""			
						.......s oeordNowDateTime=..getPreDateTime(oeordDate,oeordTime,"+",maxQty)
						.......s oeordNowDate=$p(oeordNowDateTime," ",1),oeordNowTime=$p(oeordNowDateTime," ",2)
						.......s findRecFormerV=##class(web.DHCICUOrder).GetIORate(icuaId,oeordDate,oeordTime,oeordNowDate,oeordNowTime)
						.......s findRecFormerV=$p($g(findRecFormerV),"/",2)
						.......s findRecordV=findRecordV+findRecFormerV
						......i (minQty'="")&&(maxQty'="") d //标本送检前后小时数据	
						.......s tmpRecordV=""			
						.......s oeordPreDateTime=..getPreDateTime(oeordDate,oeordTime,"+",minQty)
						.......s oeordPreDate=$p(oeordPreDateTime," ",1),oeordPreTime=$p(oeordPreDateTime," ",2)
						.......s oeordNowDateTime=..getPreDateTime(oeordDate,oeordTime,"+",maxQty)
						.......s oeordNowDate=$p(oeordNowDateTime," ",1),oeordNowTime=$p(oeordNowDateTime," ",2)
						.......s findRecFormerV=##class(web.DHCICUOrder).GetIORate(icuaId,oeordPreDate,oeordPreTime,oeordNowDate,oeordNowTime)
						.......s findRecFormerV=$p($g(findRecFormerV),"/",2)
						.......s findRecordV=findRecordV+findRecFormerV	
					....i (("^"_$p(typeName,"~",1)_"^")[("^"_"TotalIn"_"^"))&&(findLabDesc'="") d //总入量
 						.....f j=1:1:$l(findLabDesc,"#") d //主项执行时间
						......s tmpRecordV="",findRecFormerV="",findRecAfterV=""
						......s LabDesc=$p(findLabDesc,"#",j)
						......s oeordDate=$p(LabDesc," ",1),oeordTime=$p(LabDesc," ",2)				
						......s oeordDate=##class(web.DHCClinicCom).ConvertToDateH(oeordDate)
						......s oeordTime=##class(web.DHCClinicCom).ConvertToTimeH(oeordTime)
						......i (minQty'="")&&(maxQty="") d //标本送检前小时数据	
						.......s tmpRecordV=""			
						.......s oeordNowDateTime=..getPreDateTime(oeordDate,oeordTime,"+",minQty)
						.......s oeordNowDate=$p(oeordNowDateTime," ",1),oeordNowTime=$p(oeordNowDateTime," ",2)
						.......s findRecFormerV=##class(web.DHCICUOrder).GetIORate(icuaId,oeordNowDate,oeordNowTime,oeordDate,oeordTime)
						.......s findRecFormerV=$p($g(findRecFormerV),"/",1)
						.......s findRecordV=findRecordV+findRecFormerV	
						......i (minQty="")&&(maxQty'="") d //标本送检后小时数据	
						.......s tmpRecordV=""			
						.......s oeordNowDateTime=..getPreDateTime(oeordDate,oeordTime,"+",maxQty)
						.......s oeordNowDate=$p(oeordNowDateTime," ",1),oeordNowTime=$p(oeordNowDateTime," ",2)
						.......s findRecFormerV=##class(web.DHCICUOrder).GetIORate(icuaId,oeordDate,oeordTime,oeordNowDate,oeordNowTime)
						.......s findRecFormerV=$p($g(findRecFormerV),"/",1)
						.......s findRecordV=findRecordV+findRecFormerV
						......i (minQty'="")&&(maxQty'="") d //标本送检前后小时数据	
						.......s tmpRecordV=""			
						.......s oeordPreDateTime=..getPreDateTime(oeordDate,oeordTime,"+",minQty)
						.......s oeordPreDate=$p(oeordPreDateTime," ",1),oeordPreTime=$p(oeordPreDateTime," ",2)
						.......s oeordNowDateTime=..getPreDateTime(oeordDate,oeordTime,"+",maxQty)
						.......s oeordNowDate=$p(oeordNowDateTime," ",1),oeordNowTime=$p(oeordNowDateTime," ",2)
						.......s findRecFormerV=##class(web.DHCICUOrder).GetIORate(icuaId,oeordPreDate,oeordPreTime,oeordNowDate,oeordNowTime)
						.......s findRecFormerV=$p($g(findRecFormerV),"/",1)
						.......s findRecordV=findRecordV+findRecFormerV
					....i (("^"_$p(typeName,"~",1)_"^")[("^"_"TotalBalance"_"^"))&&(findLabDesc'="") d //出入量平衡
 						.....f j=1:1:$l(findLabDesc,"#") d //主项执行时间
						......s tmpRecordV="",findRecFormerV="",findRecAfterV=""
						......s LabDesc=$p(findLabDesc,"#",j)
						......s oeordDate=$p(LabDesc," ",1),oeordTime=$p(LabDesc," ",2)				
						......s oeordDate=##class(web.DHCClinicCom).ConvertToDateH(oeordDate)
						......s oeordTime=##class(web.DHCClinicCom).ConvertToTimeH(oeordTime)
						......i (minQty'="")&&(maxQty="") d //标本送检前小时数据	
						.......s tmpRecordV=""			
						.......s oeordNowDateTime=..getPreDateTime(oeordDate,oeordTime,"+",minQty)
						.......s oeordNowDate=$p(oeordNowDateTime," ",1),oeordNowTime=$p(oeordNowDateTime," ",2)
						.......s findRecFormerV=##class(web.DHCICUOrder).GetIORate(icuaId,oeordNowDate,oeordNowTime,oeordDate,oeordTime)
						.......s findRecFormerV=$p($g(findRecFormerV),"/",1)-$p($g(findRecFormerV),"/",2)
						.......s findRecordV=findRecordV+findRecFormerV	
						......i (minQty="")&&(maxQty'="") d //标本送检后小时数据	
						.......s tmpRecordV=""			
						.......s oeordNowDateTime=..getPreDateTime(oeordDate,oeordTime,"+",maxQty)
						.......s oeordNowDate=$p(oeordNowDateTime," ",1),oeordNowTime=$p(oeordNowDateTime," ",2)
						.......s findRecFormerV=##class(web.DHCICUOrder).GetIORate(icuaId,oeordDate,oeordTime,oeordNowDate,oeordNowTime)
						.......s findRecFormerV=$p($g(findRecFormerV),"/",1)-$p($g(findRecFormerV),"/",2)
						.......s findRecordV=findRecordV+findRecFormerV
						......i (minQty'="")&&(maxQty'="") d //标本送检前后小时数据	
						.......s tmpRecordV=""			
						.......s oeordPreDateTime=..getPreDateTime(oeordDate,oeordTime,"+",minQty)
						.......s oeordPreDate=$p(oeordPreDateTime," ",1),oeordPreTime=$p(oeordPreDateTime," ",2)
						.......s oeordNowDateTime=..getPreDateTime(oeordDate,oeordTime,"+",maxQty)
						.......s oeordNowDate=$p(oeordNowDateTime," ",1),oeordNowTime=$p(oeordNowDateTime," ",2)
						.......s findRecFormerV=##class(web.DHCICUOrder).GetIORate(icuaId,oeordPreDate,oeordPreTime,oeordNowDate,oeordNowTime)
						.......s findRecFormerV=$p($g(findRecFormerV),"/",1)-$p($g(findRecFormerV),"/",2)
						.......s findRecordV=findRecordV+findRecFormerV
					....q:$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3)="O" 				 					
 					....i ($lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3)="L") s value=findLabDesc2
 					....i (("^"_$p(typeName,"~",1)_"^")[("^"_"ExeDate"_"^")) s value=findLabDesc2				
					....i ($lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3)="R") s value=findRecordV
					....i (("^"_$p(typeName,"~",1)_"^")[("^"_"GetTotalOut"_"^"))||(("^"_$p(typeName,"~",2)_"^")[("^"_"GetTotalIn"_"^")) s value=findRecordV
					....i (("^"_$p(typeName,"~",1)_"^")[("^"_"GetYZ"_"^")) s value=againArcimDT			
					....s searchVal=value
					....q:$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),5)'=1
					....s $p(icuStr,"^",posList(posCode))=value
					....i sumType'="" s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),value)
				...i ($lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3)="C") d
					....s icuciiCalculateExpression=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),30)
					....i (icuciiCalculateExpression="") d //之一：无表达式（主项组合）
						.....i (mainIcuciiIdStr'="") d //有主项
							......i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),6)="" s value=mainItemStr
							......i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),6)="Times" s value=mainItemCount
							......//q:value=""
							......//s posCode=..GetIcuciPosCode(icuciId,icuciiSub)
							......//s $p(icuStr,"^",posList(posCode))=value
							......//s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),value)
					....e  d  //之二：计算表达式
						.....//q:icuciId'=75
						.....s icuciiCalculateExpression=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),30)
						.....q:icuciiCalculateExpression=""
						.....s mainIcuciiIdStr=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),27) //关联主项
						.....s mainIcuciiSub=$p(mainIcuciiIdStr,"||",2)
						.....s mainPosCode=0
						.....i mainIcuciiSub'="" d
							......s mainPosCode=..GetIcuciPosCode(icuciId,mainIcuciiSub)
							......//w mainPosCode_"/"_$g(posList(mainPosCode)),!
						.....q:(mainIcuciiSub'="")&($p(icuStr,"^",$g(posList(mainPosCode)))="")  //定义主项，但无主项数据退出
						.....s minQty=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),8)
						.....s maxQty=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),9)
						.....s value=""
						.....//q:("^Percent^Multiply^")'[("^"_$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)_"^")
						.....s delimter="*"
						.....i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)="Percent" s delimter="/"
						.....i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)="PerThousand" s delimter="/"
						.....i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)="Divide" s delimter="/"
						.....i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)="Multiply" s delimter="*"
						.....
						.....s part=$p(icuciiCalculateExpression,delimter,1),total=$p(icuciiCalculateExpression,delimter,2)
						.....s part=##class(web.DHCClinicCom).Replace(part,"-","+-"),total=##class(web.DHCClinicCom).Replace(total,"-","+-")
						.....//w "in================="_icuaId_"/"_delimter,"/"_part_"/"_total,!
						.....
						.....s partSum="",totalSum=""
						.....f iItem=1:1:$l(part,"+") d
							......s item=$p(part,"+",iItem)
							......q:item=""
							......s itemPos=$lg($g(^DHCICUCInquiry(icuciId,"I",$zabs(item))),20)
							......q:$p(icuStr,"^",itemPos)=""
							......w "partSum="_$p(icuStr,"^",itemPos),!
							......s partSum=(item/$zabs(item))*$p(icuStr,"^",itemPos)+partSum
						.....q:partSum=""
						.....f iItem=1:1:$l(total,"+") d
							......s item=$p(total,"+",iItem)
							......q:item=""
							......s itemPos=$lg($g(^DHCICUCInquiry(icuciId,"I",$zabs(item))),20)
							......q:$p(icuStr,"^",itemPos)=""
							......s totalSum=(item/$zabs(item))*$p(icuStr,"^",itemPos)+totalSum
						.....i totalSum>0 w icuaId_" partSum="_partSum_"/totalSum"_totalSum_"/"_(partSum/totalSum),!
						.....//i partSum>0 b //part
						.....q:+totalSum=0
						.....i delimter="*" s value=partSum*totalSum
						.....i delimter="/" s value=partSum/totalSum
						.....q:value=""
						.....q:(minQty'="")&(value<minQty)
						.....q:(maxQty'="")&(value>maxQty)
						.....i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)="Percent" s value=value*100
						.....i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)="PerThousand" s value=value*1000
						.....s value=$fn(value,"",2)
						.....//s pos=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),20)
						.....//q:(pos<1) //!(partPos<1)!(totalPos<1)
						.....//s $p(icuStr,"^",pos)=value
					....s posCode=..GetIcuciPosCode(icuciId,icuciiSub)
					....s $p(icuStr,"^",posList(posCode))=value
					....s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),value)
					....
				...i ($lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3)="CC") d //公共常量
					....s $p(icuStr,"^",posList(posCode))=refValue
				...i ($lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3)="US") d  ;add by lyn 主项作为条件项使用
					....;q:(splitMainIcuc="")!((mainIcuciiIdStr'="")&(mainItemCount<1))
					....s mainPosCode=..GetIcuciPosCode(icuciId,$p(mainIcuciiIdStr,"||",2))
					....s mainValue=$p(icuStr,"^",$g(posList(mainPosCode)))
					....i splitMainIcuc'="" d
						..... s value=$p($g(mainValue),"#",+splitMainIcuc)
						.....;f index=1:1:$l(mainValue,"#") d
							......;i +splitMainIcuc=index s value=$p($g(mainValue),"#",+splitMainIcuc)
					....e  d
						.....i (icuciiCode="YesOrNo")&&(mainValue'="") d  s value="是"
					....s $p(icuStr,"^",posList(posCode))=value	
				...i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3)="E" d //病案首页
					....s typeName=icuciiCode
					....s value=..GetInfoByIcuaId(icuaId,typeName,needNote,durationHour,inquiryFromDate,inquiryToDate,oeoriNote,refValue,exactTime,dataField)
					....;q:(minQty'="")&(maxQty'="")&((value<minQty)!(value>maxQty))
					....q:(needNote'="")&(value'="")&(value'[needNote)
					....s searchVal=value
					....q:$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),5)'=1
					....s $p(icuStr,"^",posList(posCode))=value
					....i sumType'="" s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),value)
				...i (searchVal="")&($lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),4)=1) s ifQuitSearch=1				
		.q:icuStr=""
		.q:ifQuitSearch
		.//最后计算列
		.s icuciiSub=0
		.f  s icuciiSub=$o(^DHCICUCInquiry(icuciId,"I",icuciiSub)) q:icuciiSub=""  d
			..q //应该重复了
			..
			..q:$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3)'="C" //计算项之二：表达式计算
			..//q:icuciId=75
			..s icuciiCalculateExpression=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),30)
			..q:icuciiCalculateExpression=""
			..//s mainIcuciiIdStr=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),27) //关联主项
			..//s mainIcuciiSub=$p(mainIcuciiIdStr,"||",2)
			..//s mainPosCode=0
			..//i mainIcuciiSub'="" d
				..//.s mainPosCode=..GetIcuciPosCode(icuciId,mainIcuciiSub)
				..//.w mainPosCode_"/"_$g(posList(mainPosCode)),!
			..//q:(mainIcuciiSub'="")&($p(icuStr,"^",$g(posList(mainPosCode)))="")  //定义主项，但无主项数据退出
			..s minQty=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),8)
			..s maxQty=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),9)
			..s value=""
			..//q:("^Percent^Multiply^")'[("^"_$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)_"^")
			..s delimter="*"
			..i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)="Percent" s delimter="/"
			..i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)="PerThousand" s delimter="/"
			..i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)="Divide" s delimter="/"
			..i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)="Multiply" s delimter="*"
			..
			..s part=$p(icuciiCalculateExpression,delimter,1),total=$p(icuciiCalculateExpression,delimter,2)
			..s part=##class(web.DHCClinicCom).Replace(part,"-","+-"),total=##class(web.DHCClinicCom).Replace(total,"-","+-")
			..s partSum="",totalSum=""
			..f iItem=1:1:$l(part,"+") d
				...s item=$p(part,"+",iItem)
				...q:item=""
				...s itemPos=$lg($g(^DHCICUCInquiry(icuciId,"I",$zabs(item))),20)
				...q:$p(icuStr,"^",itemPos)=""
				...s partSum=(item/$zabs(item))*$p(icuStr,"^",itemPos)+partSum
			..q:partSum=""
			..f iItem=1:1:$l(total,"+") d
				...s item=$p(total,"+",iItem)
				...q:item=""
				...s itemPos=$lg($g(^DHCICUCInquiry(icuciId,"I",$zabs(item))),20)
				...q:$p(icuStr,"^",itemPos)=""
				...s totalSum=(item/$zabs(item))*$p(icuStr,"^",itemPos)+totalSum
			..//i totalSum>0 w icuaId_" partSum="_partSum_"/totalSum"_totalSum_"/"_(partSum/totalSum),!
			..
			..q:+totalSum=0
			..i delimter="*" s value=partSum*totalSum
			..i delimter="/" s value=partSum/totalSum
			..q:value=""
			..q:(minQty'="")&(value<minQty)
			..q:(maxQty'="")&(value>maxQty)
			..i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)="Percent" s value=value*100
			..i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)="PerThousand" s value=value*1000
			..s pos=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),20)
			..q:(pos<1) //!(partPos<1)!(totalPos<1)
			..s $p(icuStr,"^",pos)=$fn(value,"",2)
			..s posCode=..GetIcuciPosCode(icuciId,icuciiSub)
			..//s sumType=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),24)
			..s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),value)
		.
		.s count=count+1
		.s ^DHCICUInquiry(+icuciId,"count")=count
		.i ($lg(^DHCICUCInquiry(icuciId),15)="U") d  s ^DHCICUInquiry(icuciId,icuaId)=icuStr
		.w icuaId_"  "_icuStr,!
		.;b ;w
		.q:(icuciDataType="D")&(icuaSeq=+icuaSeq)
		.w icuStr,!
		.//b ;icuStr
		.;i ($lg(^DHCICUCInquiry(icuciId),15)="")&(icuciDataType="D") d  s ^DHCICUInquiry(icuciId,icuaSeq)=icuStr w icuStr,!
		.i ($lg(^DHCICUCInquiry(icuciId),15)="") d  s ^DHCICUInquiry(icuciId,icuaSeq)=icuStr w icuStr,!
		.w count_"       "_icuStr,!
		.w sumStr,!
		.s icuStr=""
	//b ;"end2"
	i icuciId=14 d ..MergingData(icuciId)
	m ^TEMPDHCICUInquiryWHL(icuciId)=^DHCICUInquiry($j,icuciId)
	i icuciId=14  m ^DHCICUInquiryJXKH(icuciId,0)=^DHCICUInquiry(icuciId,0) k ^DHCICUInquiry($j,icuciId)
	i icuciId=14  m ^DHCICUInquiry($j,icuciId)=^DHCICUInquiryJXKH(icuciId)  
	s ^TEMPzpf("Jo")=$j
	k ^DHCICUInquiryJXKH(icuciId)
	k ^TmpICUInOutDateTime
	k ^TmpICUOeoriSDt
 	w preDT_" pre\now "_$h_" duration:"_($p($h,",",2)-$p(preDT,",",2)),!
 	;b ;"end"
 	m ^DHCICUDebug=^DHCICUInquiry($j,icuciId) //temp
	m ^DHCICUDebug(1)=^DHCICUInquiry(icuciId,0) //temp
	;i icuciId=66  m ^TEMPWHL(icuciId)=^DHCICUInquiry(icuciId,"F")
    ;i icuciId=66  m ^DHCICUInquiry($j,icuciId)=^TEMPWHL(icuciId)
	;i icuciId=66  m ^DHCICUInquiry($j,icuciId)=^TEMPWHL(icuciId)
 	;i icuciId=66  m ^DHCICUDebug=^DHCICUInquiry($j,icuciId) 
	i icuciDataType="D"  m ^DHCICUDebug(1)=^TMPDHCICUInquiry(icuciId,0) m ^DHCICUDebug(icuciId)=^TMPDHCICUInquiry($j,icuciId)
	i icuciDataType="D"  m ^DHCICUInquiry(1)=^TMPDHCICUInquiry(icuciId,0) m ^DHCICUInquiry($j,icuciId)=^TMPDHCICUInquiry($j,icuciId)
 	q 0
FindUserTotal(wardIdStr, icuciId, inquiryFromDate, inquiryToDate) 
	f ICUOStartDate=inquiryFromDate:1:inquiryToDate d	
	.s icuoIcuaDr="",valueList=""
	.f  s icuoIcuaDr=$o(^DHCICUOrder(0,"SttDateTime",ICUOStartDate,icuoIcuaDr)) q:icuoIcuaDr=""  d
	..;w ICUOStartDate,!
	..s icuoStartTime=0
	..f  s icuoStartTime=$o(^DHCICUOrder(0,"SttDateTime",ICUOStartDate,icuoIcuaDr,icuoStartTime)) q:icuoStartTime=""  d
	...s icuoId=""
	...f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",ICUOStartDate,icuoIcuaDr,icuoStartTime,icuoId)) q:icuoId=""  d
	....q:"ICD"[$p(^DHCICUOrder(icuoId),"^",25)
	....;q:ICUOStartDate>inquiryToDate
	....s icuaId=$p($g(^DHCICUOrder(icuoId)),"^",1)
	....s icuBedId=$p($g(^DHCICUArrange(icuaId)),"^",4)
	....q:(wardIdStr'="")&(("^"_wardIdStr_"^")'[("^"_(+icuBedId)_"^"))
	....s userId=$p($g(^DHCICUOrder(icuoId)),"^",4)
	....q:userId=""
	....s icuoNote=$p(^DHCICUOrder(icuoId),"^",10)
	....s icuoQty=$p(^DHCICUOrder(icuoId),"^",11)
	....s RecordItemId=$p($g(^DHCICUOrder(icuoId)),"^",2)
	....s icuciiSub=0
	....f  s icuciiSub=$o(searchList(searchLevel,icuciiSub)) q:icuciiSub=""  d //查找项筛选
	.....;w searchLevel_"/"_icuciiSub_"/"_searchList(searchLevel,icuciiSub),!
	.....q:'$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),4)
	.....i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3)="R" d
		......s i=0
		......s icucriCode=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)
		......q:icucriCode=""
		......i icucriCode'=+icucriCode s icucriId=$o(^DHCICUC("RecordItem",0,"Code",icucriCode,""))
		......e  s icucriId=icucriCode
		......q:icucriId=""
		......q:icucriId'=$p($g(^DHCICUOrder(icuoId)),"^",2)			
		......s dataField=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),6)
		......s isSingle=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),7)
		......s minQty=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),8)
		......s maxQty=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),9) 
		......s oeoriNote=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),14) 
		......s needNote=""
		......s needNote=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),10)
		......s icucriDataField=$p(^DHCICUC("RecordItem",icucriId),"^",24)
		......s inCathIcucriId=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),22)
		......s exCathIcucriId=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),23)
		......s ExactTimeList=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),17) //计算个人上班时间(倒班)	
		......q:(icucriDataField="Note")&(needNote'="")&(("^"_needNote_"^")'[("^"_icuoNote_"^"))
		......q:(icucriDataField="Qty")&(minQty'="")&(icuoQty<minQty)
		......q:(icucriDataField="Qty")&(maxQty'="")&(icuoQty>maxQty)
		......s icuaSeq=icuaSeq+1
		......s valueList=$g(^DHCICUInquiry(icuciId,"F",userId))
		......s $p(valueList,"^",icuciiSub)=$p(valueList,"^",icuciiSub)+1
		......i (inCathIcucriId'="")&&(exCathIcucriId'="") d //护理记录项目不是按照小时记录
		.......s inAndExCathDateTime=..getInOutCathDateTime(icuaId,icucriId,ICUOStartDate,icuoStartTime,ICUOStartDate,icuoStartTime,inCathIcucriId,exCathIcucriId)
		.......s hourCount=..getUserCathHCout(icuaId,userId,icucriId,icuoId,ExactTimeList,inAndExCathDateTime)
		......e  d
		.......s valueList=$g(^DHCICUInquiry(icuciId,"F",userId))
		.......s $p(valueList,"^",icuciiSub)=$p(valueList,"^",icuciiSub)+1
		.......s ^DHCICUInquiry(icuciId,"F",userId)=valueList
		......
	q 0
	k ^tmpCriIdInExCathDT,^tmpProCathDate
}

ClassMethod GetIcuciPosCode(icuciId, icuciiSub)
{
	s retStr=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),20)				//seqNo-new
	s retStr=retStr_","_$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)	//code
	s retStr=retStr_","_$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),6)	//dataField
	s retStr=retStr_","_$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),8)	//minQty-new
	s retStr=retStr_","_$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),9)	//maxQty-new
	s retStr=retStr_","_$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),10)	//note
	s retStr=retStr_","_$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),14)	//oeoriNote
	s retStr=retStr_","_$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),18)	//refId-new
	s retStr=retStr_","_$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),19)	//refValue
	q retStr
}

ClassMethod InitIcuaSearch(wardIdStr, icuciId, inquiryFromDate, inquiryToDate, dateForWardType, icuaSearch = "", needIcuaId = "") As %String
{
	w "dateForWardType="_dateForWardType_"  icuaSearch="_icuaSearch,!
	s icuaSeq=0
	//s icuaSearch=0
	s icuciCode=$lg(^DHCICUCInquiry(icuciId),1) //
	s ^LynG("icuciCode")=icuciCode,sepsisFlag=0
	i needIcuaId'="" s ^DHCICUInquiry(icuciId,"F",needIcuaId)=needIcuaId q 1
	i (dateForWardType="I")!(icuaSearch) d
		.s icuaId=0,toIcuaId=""
		.i dateForWardType="I" d
			..s icuaId=$o(^DHCICUArrange(0,"SDate",inquiryFromDate-1,"")) //保证冗余
			..s toIcuaId=$o(^DHCICUArrange(0,"SDate",inquiryToDate+2,"")) 
		.i toIcuaId="" s toIcuaId=$g(^DHCICUArrange(0))
		.i icuaId<0 s icuaId=0
		.w "icuaId="_icuaId,"/"_inquiryFromDate_"/toIcuaId="_toIcuaId,!
		.f  s icuaId=$o(^DHCICUArrange(icuaId)) q:(icuaId="")!(icuaId>toIcuaId)  d
			..//q:icuaId>45 //2238
			..q:'..IfInSearch(wardIdStr,icuaId,inquiryFromDate,inquiryToDate,dateForWardType)		
			..s icuaSeq=icuaSeq+1,^DHCICUInquiry(icuciId,"F",icuaId)=icuaId
	e  d
		.w "Order",!
		.f icuoDate=inquiryFromDate:1:inquiryToDate d
			..s icuaId=""
			..f  s icuaId=$o(^DHCICUOrder(0,"SttDateTime",icuoDate,icuaId)) q:icuaId=""  d				
				...q:$d(^DHCICUInquiry(icuciId,"F",icuaId))>0
				...;w wardIdStr_"/"_icuaId_"/"_inquiryFromDate_"/"_inquiryToDate_"/"_dateForWardType_"/"_icuoDate,!				
				...s retVal=##class(web.DHCICUStat).IfInSearch(wardIdStr,icuaId,inquiryFromDate,inquiryToDate,dateForWardType,icuoDate)
				...;w "retVal="_retVal,!
				...q:'(retVal)				
				...q:##class(web.DHCICUOrder).CheckValidICUAID(icuaId)="N" //判断数据是否有效
				...s icuaSeq=icuaSeq+1,^DHCICUInquiry(icuciId,"F",icuaId)=icuaId
	w "icuaSeq="_icuaSeq,!
	q icuaSeq
}

/// 是否在查找范围内
ClassMethod IfInSearch(wardIdStr, icuaId, inquiryFromDate, inquiryToDate, dateForWardType, icuoDate = "") As %String
{
	//w "in "_icuaId,!
	s retVal=0
	s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
		
	q:(wardIdStr'="")&(("^"_wardIdStr_"^")'[("^"_(+icuBedId)_"^")) retVal
	s curWardLocId=$p(^PAWARD(+icuBedId),"^",5)
	s EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
	s admStatus=$p($g(^PAADM(EpisodeID)),"^",20)
	q:admStatus="C" retVal	
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:oeordId="" retVal
	
	s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
	s wardDesc=$P($g(^PAWARD(+icuBedId)),"^",2)
	
	s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	//s papmiMedicare=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	s paadmtype=$p($g(^PAADM(EpisodeID)),"^",2)
	s papmiMedicare=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,paadmtype,.ErrMsg)

	s icuaStartDate=$p(^DHCICUArrange(icuaId),"^",6)
	s icuaStartTime=$p(^DHCICUArrange(icuaId),"^",8)

	s inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
	
	q:inDateTime="" retVal
	s inDate=$p(inDateTime,"^"),inTime=$p(inDateTime,"^",2)
	s ifValidIcuId=##class(web.DHCICUOrder).CheckValidICUAID(icuaId)
	i $p(^DHCICUArrange(icuaId),"^",10)="" d //确认七天以上监护是否为有效监护，提高后期检索速度。
		.q:(($h-inDate)<7)
		.//w icuaId_"set valid ",!
		.i ifValidIcuId="Y" s $p(^DHCICUArrange(icuaId),"^",10)="N"
		.e  s $p(^DHCICUArrange(icuaId),"^",10)="A"
	q:ifValidIcuId="N" 0 //判断数据是否有效
	s inDiff=(icuaStartDate-inDate)*86400+icuaStartTime-inTime
	s inDiff=$fn(inDiff/60,"",1)
	//s ^DHCICUTmpIO(icuaId)=regNo_"^"_patName_"^"_papmiMedicare_"^"_wardDesc_"^"_$zd(inDate,3)_"^"_$zt(inTime,2)_"^"_$zd(icuaStartDate,3)_"^"_$zt(icuaStartTime,2)_"^"_inDiff
	
	;//查询日期范围为入病区时间范围时，过滤条件
	//w icuaId,"/"_inDate_"/"_inquiryFromDate,"/"_inquiryToDate,!
	q:(dateForWardType="I")&&((inquiryFromDate>inDate)||(inquiryToDate<inDate)) retVal
	q:(inquiryToDate<inDate) retVal
	q:(icuoDate'="")&(icuoDate<inDate) retVal
	//add later//s ifPostOperation=..IfPostOperation(EpisodeID,inDate,inTime)
	s inDateTime=inDate+(inTime/100000)
	s outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
	s outType=$p(outDateTime,"^",3)
	s icuaLeaveDate=$p($g(^DHCICUArrange(icuaId)),"^",44)
	s icuaLeaveTime=$p($g(^DHCICUArrange(icuaId)),"^",45)
	s diff=""
	i outDateTime'="",icuaLeaveDate'="" d
		.s dischDate=$p(^PAADM(EpisodeID),"^",17)
		.s dischTime=$p(^PAADM(EpisodeID),"^",18)
		.s disch=0
		.i outDateTime=(dischDate_"^"_dischTime) s disch=1
		.q:disch=1
		.//i $zabs(diff)>3599 w icuaId_"/"_diff,!

	
	//w "  outDateTime="_outDateTime,!
	s isCurrPat=0
	s outDate=+$h,outTime=$p($h,",",2)
	i outDateTime="" d
		.s outDateTime=$h+($p($h,",",2)/100000)
		.s isCurrPat=1
	e  d
		.s outDate=$p(outDateTime,"^"),outTime=$p(outDateTime,"^",2)
		.s outDateTime=outDate+(outTime/100000)
	s icuHour=(outTime-inTime)\3600+((outDate-inDate)*24)
	i outTime<inTime s icuHour=icuHour-1
	q:(outDate<inDate)!((outDate=inDate)&(outTime<inTime)) retVal
	q:(inquiryFromDate>outDate) retVal
	
	s outDiff=(icuaLeaveDate-outDate)*86400+icuaLeaveTime-outTime
	s outDiff=$fn(outDiff/60,"",1)
	;w outDate,!
	i outDate'="" d
		.i ((outType="T")!(outType="D"))&(($h-outDate)>7) d
			..q:$p(^DHCICUArrange(+icuaId),"^",44)'=""
			..s $p(^DHCICUArrange(+icuaId),"^",44)=outDate
			..s $p(^DHCICUArrange(+icuaId),"^",45)=outTime
			..;w icuaId_" set:"_outType_"/"_outDate_"/"_outTime,!
		.;s outDate=$zd(outDate,3),outTime=$zt(outTime,2)		
	e  s outDiff=""
	
	i outType="T" s outType="转科"
	i outType="D" s outType="出院"
	i outType="L" s outType="转归"
	i outType="" s outType="科内"
	i icuaLeaveDate'="" s icuaLeaveDate=$zd(icuaLeaveDate,3),icuaLeaveTime=$zt(icuaLeaveTime,2)
	e  s outDiff=""
	
	//s ^DHCICUTmpIO(icuaId)=^DHCICUTmpIO(icuaId)_"^"_outType_"^"_outDate_"^"_outTime_"^"_icuaLeaveDate_"^"_icuaLeaveTime_"^"_outDiff_"^"_ifValidIcuId
	
	;w icuoDate_"/"_outDate_"/"_(icuoDate>outDate),!
	q:(icuoDate'="")&(icuoDate>outDate) retVal
	q 1
}

ClassMethod GetClustering(mainClusteringSub)
{
}

/// 取数据，type:Min最低值,Max最高值,First第一个值,MinMax最低值^最高值,Exact最接近exactDate,exactTime的值 Times数据存在次数
/// dateField:"DateTime", 附加时间。  ^DHCICUInquiry(icuciId,icuaId)   oeordrstr 包含医嘱项ID
/// w ##class(web.DHCICUStat).GetRecordValueByUserID(2240,5330,$h,28800,$h,57600,"Exact",$h,"11:20")
/// w ##class(web.DHCICUStat).GetRecordValueByUserID(6076,6704,$h,28800,$h,57600,"First","","","","","","","",1)
ClassMethod GetRecordValueByUserID(icuaId, icucriId, fromDate, fromTime, toDate, toTime, type = "", exactDate = "", exactTime = "", oeoriNote = "", dataField = "", refIcucriCode = "", refValue = "", needNote = "", pos = 0, icuciId = 0, ARCIMRowIdStr = "") As %String
{
	q:icuaId="" ""
	q:icucriId="" ""
	q:'$d(^DHCICUC("RecordItem"))="" ""
	i icucriId'=+icucriId s icucriId=##class(web.DHCICUCom).GetIcuriIdByCode(icucriId)	
	s icucriDataField=$p($g(^DHCICUC("RecordItem",icucriId)),"^",24)
	q:icucriDataField="" ""
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s fromTime=##class(web.DHCClinicCom).ConvertToTimeH(fromTime)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	s toTime=##class(web.DHCClinicCom).ConvertToTimeH(toTime)
	
	s exactDate=##class(web.DHCClinicCom).ConvertToDateH(exactDate,"")
	s exactTime=##class(web.DHCClinicCom).ConvertToTimeH(exactTime,"")
	;i ARCIMRowIdStr="CVVH" b ;"start"
	s orderCategory=""
	s minQty="",maxQty="",value="",sumQty="",touchQty="",QtyDateTime="",timesInt=0,averageQty=""
	s userId="",maxUserId="",minUserId=""
	s baseIcuoId="",ifQuit=0,preDate="",preTime="",preDeparture="",curDeparture=""
	s date=fromDate-1
	s retstr="",OeordDr="",CatAndCategoryStr="",CategoryStr="",LabEpisodeNo="",IfExistLabEpisodeNo=""
	s findRecordId="",valueDateTime="",minDateTime="",maxDateTime=""
	f  s date=$o(^DHCICUOrder(0,"RecordItem",icucriId,date)) q:(date="")!(date>toDate)!(ifQuit)  d
		.s time=""
		.f  s time=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time)) q:(time="")!(ifQuit)  d
		    ..;i ARCIMRowIdStr="CVVH" b ;"start7"
			..q:(date=fromDate)&(time<fromTime)
			..q:(date=toDate)&(time>toTime)
			..s icuoId=""
			..f  s icuoId=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time,icuoId)) q:(icuoId="")!(ifQuit)  d
				...s OeordDr=$p(^DHCICUOrder(icuoId),"^",3)
				...i OeordDr'="" s oeordId=$p(OeordDr,"||",1)
				...i OeordDr'="" s oeoriSub=$p(OeordDr,"||",2)
				...i OeordDr'="" s ARCIMID=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
				...;i ARCIMRowIdStr="CVVH" b ;"start6"
				...q:'$d(^DHCICUOrder(icuoId))
				...q:"ICD"[$p(^DHCICUOrder(icuoId),"^",25)
				...s userId=$p(^DHCICUOrder(icuoId),"^",4)
				...;i ARCIMRowIdStr="CVVH" b ;"start2"
				...i (exactDate'="")&(type="Exact") d
					....s preDeparture=##class(web.DHCClinicCom).CalculateDuration(preDate,preTime,exactDate,exactTime)
					....s curDeparture=##class(web.DHCClinicCom).CalculateDuration(date,time,exactDate,exactTime)
					....i ($zabs(preDeparture)<$zabs(curDeparture)) s ifQuit=1
				...s icupICode=""
				...i oeoriNote'="" d
					....s icupiId=$p(^DHCICUOrder(icuoId),"^",38)
					....q:icupiId=""
					....s icupICode=$p(^DHCICUPara(+icupiId,"I",+$p(icupiId,"||",2)),"^",13)
				...;i ARCIMRowIdStr="CVVH" b ;"start3"
				...q:(icupICode'="")&(icupICode'[(oeoriNote))
				...s value=##class(web.DHCICUOrder).GetRecordValueSingle(icuoId,icucriDataField,"",needNote)
				...q:value=""
				...i ARCIMRowIdStr="ECMOLL" b ;"start4"
				...s valueDateTime=$zd(date,3)_" "_$zt(time,2)
				...s findRecordId=icuoId
				...;i ARCIMRowIdStr="ECMOLL" b ;"start5"
				...s preDate=date,preTime=time
				...s ifFirstData=..GetRecordValueIfFirstOrderData(icuoId)
				...s arcimId=..GetArcimIdByIcuoId(icuoId)
				...i arcimId'=""  s CatAndCategoryStr=..GetArcimCatAndCategoryByOeordDr(arcimId)
				...i CatAndCategoryStr'="" s CategoryStr=$p(CatAndCategoryStr,"^",4)
				
				...s oeorditemStr=##class(web.DHCICUOrder).GetOeorditemInfo(OeordDr)
				...s oeoriNoteStr=$p(oeorditemStr,"^",17) //获取医嘱备注
				...s LabEpisodeNo=..GeLabEpisodeNoByOeordID(OeordDr)
				...i (LabEpisodeNo'="") s IfExistLabEpisodeNo=$o(^TEMPWHL("LabEpisodeNo",LabEpisodeNo,""))
				...i (LabEpisodeNo'="")&&(IfExistLabEpisodeNo="") s ^TEMPWHL("LabEpisodeNo",LabEpisodeNo,OeordDr)=OeordDr
				...i (orderCategory'="")&&(IfExistLabEpisodeNo'="") q  //检验同一个标本号只取一次数据
				...s username=""
				...i userId'="" s username=..GetNameById(userId)	
				...q:(username="")
				...q:(icucriId="")	
				...q:value=""	
				...i value'="" s $p(^DHCICUInquiryJXKH(icuciId,userId),"^",1)=username
				...s count=$p($g(^DHCICUInquiryJXKH(icuciId,userId)),"^",pos)
				...i count="" s count=0
				...i (arcimId="33706||1") s $p(^DHCICUInquiryJXKH(icuciId,userId),"^",pos)=$p($g(^DHCICUInquiryJXKH(icuciId,userId)),"^",pos)+1   q 
				...i (ARCIMRowIdStr="Outexamination") s $p(^DHCICUInquiryJXKH(icuciId,userId),"^",pos)=$p($g(^DHCICUInquiryJXKH(icuciId,userId)),"^",pos)+1   q   //外出检查
				...i (ARCIMRowIdStr="CVVH") s $p(^DHCICUInquiryJXKH(icuciId,userId),"^",pos)=$p($g(^DHCICUInquiryJXKH(icuciId,userId)),"^",pos)+1   q
			 	...i (ARCIMRowIdStr="ECMOLL")&&(value'="") s $p(^DHCICUInquiryJXKH(icuciId,userId),"^",pos)=$p($g(^DHCICUInquiryJXKH(icuciId,userId)),"^",pos)+1  q
			    ...i (orderCategory'="")&&(orderCategory[CategoryStr) s $p(^DHCICUInquiryJXKH(icuciId,userId),"^",pos)=$p($g(^DHCICUInquiryJXKH(icuciId,userId)),"^",pos)+1   q
				...i (orderCategory="")&&(needNote'="")&&(needNote[oeoriNoteStr)&&(ARCIMRowIdStr'="")&&(ARCIMRowIdStr[arcimId)&&(arcimId'="")&&(icucriId'="")&&(ifFirstData="Y") s $p(^DHCICUInquiryJXKH(icuciId,userId),"^",pos)=$p($g(^DHCICUInquiryJXKH(icuciId,userId)),"^",pos)+1 i (userId=841) q
				...i (orderCategory="")&&(ARCIMRowIdStr'="")&&(ARCIMRowIdStr[arcimId)&&(arcimId'="")&&(ifFirstData="Y") s $p(^DHCICUInquiryJXKH(icuciId,userId),"^",pos)=$p($g(^DHCICUInquiryJXKH(icuciId,userId)),"^",pos)+1 q
				...i (orderCategory="")&&(ARCIMRowIdStr="")&&(ifFirstData="Y") s $p(^DHCICUInquiryJXKH(icuciId,userId),"^",pos)=$p($g(^DHCICUInquiryJXKH(icuciId,userId)),"^",pos)+1 q
				...i (orderCategory="")&&(ARCIMRowIdStr="")&&(ifFirstData="N") s $p(^DHCICUInquiryJXKH(icuciId,userId),"^",pos)=$p($g(^DHCICUInquiryJXKH(icuciId,userId)),"^",pos)+1 q

	      q retstr
}

// 合并统计数据

ClassMethod MergingData(icuciId)
{
   s userId="",icuaId=""
	f  s userId=$o(^DHCICUInquiryMainNurse(icuciId,userId)) q:userId=""  d
	   .s $p(^DHCICUInquiryJXKH(icuciId,userId),"^",2)=$g(^DHCICUInquiryInOutHospital(+icuciId,"InHospital",userId))
	   .s $p(^DHCICUInquiryJXKH(icuciId,userId),"^",3)=$g(^DHCICUInquiryInOutHospital(+icuciId,"OutHospital",userId))
       .s $p(^DHCICUInquiryJXKH(icuciId,userId),"^",14)=$g(^DHCICUInquiryInOutHospital(+icuciId,"InHospital2",userId))
	   .s $p(^DHCICUInquiryJXKH(icuciId,userId),"^",15)=$g(^DHCICUInquiryInOutHospital(+icuciId,"OutHospital2",userId))
       .f  s icuaId=$o(^DHCICUInquiryInOutHospital(+icuciId,"icuaId",userId,icuaId))   q:icuaId=""  d
          ..;s apcheIIcount=$p($g(^DHCICUInquiry(icuciId,icuaId)),"^",4)
          ..s apcheII=$p(^DHCICUArrange(icuaId),"^",40)
          ..i apcheII>14 s $p(^DHCICUInquiryJXKH(icuciId,userId),"^",4)=$p(^DHCICUInquiryJXKH(icuciId,userId),"^",4)+1

	f  s userId=$o(^DHCICUInquiryJXKH(icuciId,userId)) q:userId=""  d
	   .s username=""
	   .s username=##class(web.DHCICUStatTEST).GetNameById(userId)
	   .q:username=""
	   .s $p(^DHCICUInquiryJXKH(icuciId,userId),"^",1)=username_"@"_userId
}

/// 通过医生 护士 ID取得姓名User表
/// w ##class(web.DHCICUStatTEST).GetNameById(1455)
ClassMethod GetNameById(userId As %String) As %String
{
	q:(userId="") ""
	s docName=""
	s docName=$p($g(^SSU("SSUSR",userId)),"^",2)
	s docWorkNo=$p($g(^SSU("SSUSR",userId)),"^",1)
	s ctcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
	q:ctcpId="" docName
	s ctcptId=$p($g(^CTPCP(+ctcpId,1)),"^",4)  ;CTPCP_CarPrvTp_DR
	s ctcptType=$p($g(^CT("CPT",+ctcptId)),"^",4)  ;CT_CarPrvTp
    q:(ctcptType'="NURSE") ""
	i docName="" q "用户不存在!"
	q docName_"  工号"_docWorkNo
}

/// 是否为第一个有效的医嘱数据
/// w ##class(web.DHCICUStatTEST).GetRecordValueIfFirstOrderData("47503144")
ClassMethod GetRecordValueIfFirstOrderData(icuoIdstr) As %String
{
	q:'$d(^DHCICUOrder(icuoIdstr)) "N"
	s OeordDr=$p(^DHCICUOrder(icuoIdstr),"^",3)
	q:OeordDr="" "N"
	s icuaID=$p(^DHCICUOrder(icuoIdstr),"^",1)
	s icuoId=""
	s count=0
	s retstr="N"
	f  s icuoId=$o(^DHCICUOrder(0,"OEORE",OeordDr,icuaID,icuoId))  q:icuoId=""  d
	   .q:"ICD"[$p(^DHCICUOrder(icuoId),"^",25)
	   .s count=count+1
	   .i (count=1)&&(icuoId=icuoIdstr) s retstr="Y"
	q retstr
}

/// 根据icuoid获取his医嘱项ID
/// w ##class(web.DHCICUStatTEST).GetArcimIdByIcuoId("47503144")
ClassMethod GetArcimIdByIcuoId(icuoId) As %String
{
	q:'$d(^DHCICUOrder(icuoId)) "N"
	s OeordDr=$p(^DHCICUOrder(icuoId),"^",3)
	q:OeordDr="" ""
	i OeordDr'="" s oeordId=$p(OeordDr,"||",1)
	i OeordDr'="" s oeoriSub=$p(OeordDr,"||",2)
    i OeordDr'="" s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
    s str=$p(^ARCIM($p(arcimId,"||",1),$p(arcimId,"||",2),1),"^",2)
	q arcimId
}

/// 根据icuoid获取his医嘱项ID
/// w ##class(web.DHCICUStat).GetArcimIdByOeordDr("47503144")
ClassMethod GetArcimIdByOeordDr(OeordDr) As %String
{
	q:OeordDr="" ""
	i OeordDr'="" s oeordId=$p(OeordDr,"||",1)
	i OeordDr'="" s oeoriSub=$p(OeordDr,"||",2)
    i OeordDr'="" s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
    s str=$p(^ARCIM($p(arcimId,"||",1),$p(arcimId,"||",2),1),"^",2)
    ;s retstr=arcimId
	q arcimId
}

/// 获取检验医嘱的标本号
/// w ##class(web.DHCICUStatTEST).GeLabEpisodeNoByOeordID("||")
ClassMethod GeLabEpisodeNoByOeordID(OeordDr) As %String
{
	s LabEpisodeNo=""
	q:OeordDr="" ""
	i OeordDr'="" s oeordId=$p(OeordDr,"||",1)
	i OeordDr'="" s oeoriSub=$p(OeordDr,"||",2)
    i OeordDr'="" s LabEpisodeNo=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",20) //获取标本号
	q LabEpisodeNo
}

/// 根据获取医嘱项的大类和分类
/// w ##class(web.DHCICUStatTEST).GetArcimCatAndCategoryByOeordDr("47503144")
ClassMethod GetArcimCatAndCategoryByOeordDr(arcimId) As %String
{
    q:arcimId="" ""
    s str=$p(^ARCIM($p(arcimId,"||",1),$p(arcimId,"||",2),1),"^",2)
    s ItemCatCatDr=$p(^ARCIM($p(arcimId,"||",1),$p(arcimId,"||",2),1),"^",10) 
    s ItemCatCatDesc=$p(^ARC("IC",ItemCatCatDr),"^",2)
    
    s ORCatDr=$p(^ARC("IC",ItemCatCatDr),"^",8)
    s ORCatDesc=$p(^OEC("ORCAT",ORCatDr),"^",2)
   
	q ItemCatCatDr_"^"_ItemCatCatDesc_"^"_ORCatDr_"^"_ORCatDesc
}

/// 取现有人数，从出入转中按科室取出在院人数之和（医院收治床日数）,统计组程序
/// DHCMRIPday
/// w ##class(web.DHCICUStat).GetMRIPData("2015-06-01","2015-06-11")
ClassMethod GetMRIPData(startDate, endDate) As %String
{
	s $zt="ErrorReturn"
	//k ^TEMPDHCWL($j)
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s daySum=0
	f date=startDate:1:endDate d
		.s mrId=0 f  s mrId=$o(^MRIPdaily("MRIP_DATE",date,mrId)) q:mrId=""  d
			..s xyrs=0
			..s loc=$p(^MRIPdaily(mrId),"^",7) q:loc="" //科室
			..s xyrs=$p(^MRIPdaily(mrId),"^",18)  //现有人数	MRIP_XYRS 
			..//s ^TEMPDHCWL($j,loc,"XYRSKS")=$g(^TEMPDHCWL($j,loc,"XYRSKS"))+xyrs
			..s daySum=daySum+xyrs
	q daySum 
	
ErrorReturn
	 k ^TEMPDHCWL($j)
	 q 0
}

/// 按病人统计
ClassMethod StatIcuArrangeSingle(icuaId, icuciiDesc) As %String
{
	//w ##class(web.DHCICUStat).StatIcuArrangeSingle(249,"CRRTHour")
	s retStr=""
	q:'$d(^DHCICUArrange(icuaId)) retStr
	s tmpIcuciId=0,icuciId=0
	f  s tmpIcuciId=$o(^DHCICUCInquiry(tmpIcuciId)) q:tmpIcuciId=""  d
		.i $lg($g(^DHCICUCInquiry(tmpIcuciId)),1)="IcuArrangeSingle" s icuciId=tmpIcuciId
	q:icuciId=0 retStr
	q:icuciiDesc="" retStr
	
	s tmpIcuciiSub=0,icuciiSub=0
	f  s tmpIcuciiSub=$o(^DHCICUCInquiry(icuciId,"I",tmpIcuciiSub)) q:tmpIcuciiSub=""  d
		.i icuciiDesc=$lg(^DHCICUCInquiry(icuciId,"I",tmpIcuciiSub),2) s icuciiSub=tmpIcuciiSub
	q:icuciiSub=0 retStr
	s icuaStartDate=$p(^DHCICUArrange(icuaId),"^",6)
	s icuaStartTime=$p(^DHCICUArrange(icuaId),"^",8)
	
	s icuaLeaveDate=$p($g(^DHCICUArrange(+icuaId)),"^",44)
	s icuaLeaveTime=$p($g(^DHCICUArrange(+icuaId)),"^",45)
	
	s posCode=..GetIcuciPosCode(icuciId,icuciiSub)
	
	q:icuaLeaveDate="" retStr
	s icuBedId=$p($g(^DHCICUArrange(icuaId)),"^",4)
	s ctlocId=$p(^PAWARD(+icuBedId),"^",5)
	s retStr=..FindIcuInquiry(ctlocId,icuciId,icuaStartDate,icuaLeaveDate+1,"","","",icuaId,icuciiSub)
	s seqNo=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),20)
	q:seqNo<1 retStr
	s retStr=$p($g(^DHCICUInquiry(icuciId,icuaId)),"^",seqNo)
	q retStr
}

/// 根据就诊号和代码取重症信息
ClassMethod StatIcuArrange(EpisodeID, icuciiDesc) As %String
{
	//w ##class(web.DHCICUStat).StatIcuArrange(2463890,"CRRTHour")
	q:EpisodeID="" ""
	q:icuciiDesc="" ""
	s icuaId="",retStr="",ifQuit=0
	f  s icuaId=$o(^DHCICUArrange(0,"Adm",EpisodeID,icuaId)) q:(icuaId="")!(ifQuit)  d
		.s retStr=..StatIcuArrangeSingle(icuaId, icuciiDesc)
		.i retStr'="" s ifQuit=1
	q retStr
}

// dateForWardType  I  在病区    ""  入病区

// w ##class(web.DHCICUStatTEST).GetIcuaCount(39,"2015-05-01","2015-06-01","I")

ClassMethod GetIcuaCount(wardIdStr, inquiryFromDate, inquiryToDate, dateForWardType) As %String
{
	s inquiryFromDate=##class(web.DHCClinicCom).ConvertToDateH(inquiryFromDate)
	s inquiryToDate=##class(web.DHCClinicCom).ConvertToDateH(inquiryToDate)
	s icuaSeq=0
	i (dateForWardType="I") d
		.s icuaId=0,toIcuaId=""
		.i dateForWardType="I" d
			..s icuaId=$o(^DHCICUArrange(0,"SDate",inquiryFromDate-1,"")) //保证冗余
			..s toIcuaId=$o(^DHCICUArrange(0,"SDate",inquiryToDate+2,"")) 
		.i toIcuaId="" s toIcuaId=$g(^DHCICUArrange(0))
		.i icuaId<0 s icuaId=0
		.f  s icuaId=$o(^DHCICUArrange(icuaId)) q:(icuaId="")!(icuaId>toIcuaId)  d
			..q:'..IfInSearch(wardIdStr,icuaId,inquiryFromDate,inquiryToDate,dateForWardType)
			..s icuaSeq=icuaSeq+1
	e  d
		.f icuoDate=inquiryFromDate:1:inquiryToDate d
			..s icuaId=""
			..f  s icuaId=$o(^DHCICUOrder(0,"SttDateTime",icuoDate,icuaId)) q:icuaId=""  d				
				...s retVal=##class(web.DHCICUStat).IfInSearch(wardIdStr,icuaId,inquiryFromDate,inquiryToDate,dateForWardType,icuoDate)
				...i retVal'=0 b ;"666"
				...q:'(retVal)				
				...q:##class(web.DHCICUOrder).CheckValidICUAID(icuaId)="N" //判断数据是否有效
				...b ;"123"
				...s icuaSeq=icuaSeq+1
	q icuaSeq
}

/// 取病人汇总数据
/// 
/// w ##class(web.DHCICUStat).GetIcuaTotalDuration(249,"PBP_METHOD")
/// w ##class(web.DHCICUStat).GetIcuaTotalDuration(249,"VentilatorMode","A/C^T形管吸氧")
ClassMethod GetIcuaTotalDuration(icuaId, icucriCode, note = "", type = "H") As %String
{
	q:'$d(^DHCICUArrange(icuaId)) "-1"
	q:icucriCode="" "-2"
	s icucriId=##class(web.DHCICUCom).GetIcuriIdByCode(icucriCode)
	q:icucriId="" "-3"
	
	s icuaStartDate=$p(^DHCICUArrange(icuaId),"^",6)
	s icuaStartTime=$p(^DHCICUArrange(icuaId),"^",8)
	
	s icuaLeaveDate=$p($g(^DHCICUArrange(+icuaId)),"^",44)
	s icuaLeaveTime=$p($g(^DHCICUArrange(+icuaId)),"^",45)
	
	q:icuaLeaveDate="" "-4"
	w icucriId_"/"_icuaStartDate_"/"_icuaStartTime_"/"_icuaLeaveDate_"/"_icuaLeaveTime,!
	s durationStr=##class(web.DHCICUOrder).GetRecordDuration(icuaId,icucriId,icuaStartDate,icuaStartTime,icuaLeaveDate,icuaLeaveTime,60,note)
	i type="D" q $p(durationStr,"^")
	i type="H" q $p(durationStr,"^",2)
	i type="M" q $p(durationStr,"^",3)
	i type="Time" q $p(durationStr,"^",4)
	
	q 0
}

/// creator: LYN
/// CreatDate:2015/10/21
/// Description:判断患者是否诊断脓毒症，是返回1，否返回0
/// w ##class(web.DHCICUStat).JudgeSepsisStandard(7805)
ClassMethod JudgeSepsisStandard(icuaId As %String) As %String
{
	q:icuaId="" 0
	s ret=0,clcsoCode=""
	s ICUAShockType=$p($g(^DHCICUArrange(+icuaId)),"^",32) ;休克类型-〉感染
	//获取基线值中的apache诊断
	s ICUADiagnosticCatCLCSODr=$p($g(^DHCICUArrange(+icuaId)),"^",41) ;apache诊断-〉sepsis(脓毒症)
	i ICUADiagnosticCatCLCSODr'=""  d
	.s clcsiRowid=$p(ICUADiagnosticCatCLCSODr,"||",1)
	.s clcsoRowid=$p(ICUADiagnosticCatCLCSODr,"||",2)
	.i (clcsiRowid'="")&(clcsoRowid'="") d
	..q:$g(^DHCCLC("Score",clcsiRowid,"O",clcsoRowid))="" 
	..s clcsoCode=$lg(^DHCCLC("Score",clcsiRowid,"O",clcsoRowid),1) ;是否为Sepsis	
	i ((","_ICUAShockType_",")[(",感染性,"))&&(clcsoCode="Sepsis") s ret=1	
	q ret
}

/// 是否符合SIRS标准
/// w ##class(web.DHCICUStat).JudgeSirsStandard(7964,"2015-11-04","0","2015-11-04","23:59")
ClassMethod JudgeSirsStandard(icuaId As %String, fromDate As %String = "", fromTime As %String = "", toDate As %String = "", toTime As %String = "") As %String
{
	q:icuaId=""	
	s retstr=0,TemperValue=0,HRValue=0,RRValue=0,WBCValue=0	
	s EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
	s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s fromTime=##class(web.DHCClinicCom).ConvertToTimeH(fromTime)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	s toTime=##class(web.DHCClinicCom).ConvertToTimeH(toTime)	
	s TemperMinValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,"Temper",fromDate,fromTime,toDate,toTime,"Min","","","","")
	s TemperMaxValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,"Temper",fromDate,fromTime,toDate,toTime,"Max","","","","")
	//s HRMinValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,"HR",fromDate,fromTime,toDate,toTime,"Min","","","","")
	s HRMaxValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,"HR",fromDate,fromTime,toDate,toTime,"Max","","","","")
	//s RRMinValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,"RR",fromDate,fromTime,toDate,toTime,"Min","","","","")
	s RRMaxValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,"RR",fromDate,fromTime,toDate,toTime,"Max","","","","")
	s WBCRetValue=##class(web.DHCClinicCom).GetTestResult("", regNo, "", "WBC", fromDate,fromTime,toDate,toTime, "1","SP36")
	s WBCRetValue=$p(WBCRetValue,"\",1)
	;w TemperMaxValue_"/"_HRMaxValue_"/"_RRMaxValue_"/"_WBCValue,!
	i ((TemperMaxValue'="")&&(TemperMaxValue>38))||((TemperMinValue'="")&&(TemperMinValue<36)) s TemperValue=1 //体温
	i (HRMaxValue'="")&&(HRMaxValue>90) s HRValue=1 //心率
	i (RRMaxValue'="")&&(RRMaxValue>20) s RRValue=1 //呼吸频率
	i (WBCRetValue'="")&&(WBCRetValue>12||WBCRetValue<4) s WBCValue=1 //WBC
	;w TemperValue_"/"_HRValue_"/"_RRValue_"/"_WBCValue,!
	i (TemperValue+HRValue+RRValue+WBCValue)>2 d  //update by lyn
		.i $p($g(^Researchon(icuaId)),"^",1)="" s $p(^Researchon(icuaId),"^",1)=TemperMinValue
		.i $p($g(^Researchon(icuaId)),"^",2)="" s $p(^Researchon(icuaId),"^",2)=TemperMaxValue
		.i $p($g(^Researchon(icuaId)),"^",3)="" s $p(^Researchon(icuaId),"^",3)=HRMaxValue
		.i $p($g(^Researchon(icuaId)),"^",4)="" s $p(^Researchon(icuaId),"^",4)=RRMaxValue
		.i $p($g(^Researchon(icuaId)),"^",5)="" s $p(^Researchon(icuaId),"^",5)=WBCRetValue
		.s retstr=1
	q retstr
}

/// 是否符合SevereSepsis标准
/// w ##class(web.DHCICUStat).JudgeSevereSepsisStandard(7964,"2015-11-04","0","2015-11-04","23:59")
ClassMethod JudgeSevereSepsisStandard(icuaId As %String, fromDate As %String = "", fromTime As %String = "", toDate As %String = "", toTime As %String = "") As %String
{
	s retStr=0,vasoactiveValue=0,LacValue=0,NLValue=0
	s vasoactiveAgentValue=##class(web.DHCICUStat).getVasoactiveAgents(icuaId,"VasoactiveAgents",fromDate,toDate)
	s LacMaxValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,"Lac",fromDate,fromTime,toDate,toTime,"Max","","","","")
	s NLMinValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,"nyndgnl",fromDate,fromTime,toDate,toTime,"Min","","","","")
	s NLMaxValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,"nyndgnl",fromDate,fromTime,toDate,toTime,"Max","","","","")
	i vasoactiveAgentValue'="" s vasoactiveValue=vasoactiveAgentValue
	i (LacMaxValue'="")&&(LacMaxValue>2) s LacValue=1
	i ((NLMaxValue'="")&&(NLMaxValue>38))||((NLMinValue'="")&&(NLMinValue<36)) s NLValue=1
	w vasoactiveValue_"/"_LacValue_"/"_NLValue,!
	i (vasoactiveValue+LacValue+NLValue)>1  s retStr=1
	q retStr
}

/// 是否符合SepticShock标准
/// w ##class(web.DHCICUStat).JudgeSepticShockStandard(7964,"2015-11-04","0","2015-11-04","23:59")
ClassMethod JudgeSepticShockStandard(icuaId As %String, fromDate As %String = "", fromTime As %String = "", toDate As %String = "", toTime As %String = "") As %String
{
	s retStr=0
	s NSBPValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,"NSBP",fromDate,fromTime,toDate,toTime,"Min","","","","")
	s MAPMinValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,"MAP",fromDate,fromTime,toDate,toTime,"Min","","","","")
	s MAPMaxValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,"MAP",fromDate,fromTime,toDate,toTime,"Max","","","","")
	i (NSBPValue<90)!(MAPMinValue<60) d  s retStr=1
	i retStr=1 d
		.i $p($g(^Researchon(icuaId)),"^",6)="" s $p(^Researchon(icuaId),"^",6)=NSBPValue
		.i $p($g(^Researchon(icuaId)),"^",7)="" s $p(^Researchon(icuaId),"^",7)=MAPMinValue
		.i $p($g(^Researchon(icuaId)),"^",8)="" s $p(^Researchon(icuaId),"^",8)=MAPMaxValue
		.i ($p($g(^Researchon(icuaId)),"^",9)="") d
			..i (MAPMaxValue-MAPMinValue>40) s $p(^Researchon(icuaId),"^",9)="是"
			..e  s $p(^Researchon(icuaId),"^",9)="否"
		 
	q retStr
}

/// 是否使用药物
/// AntimicrobialAgents  抗生素
/// w ##class(web.DHCICUStat).getVasoactiveAgents(7964,"AntimicrobialAgents","2016-01-01","2016-02-17")
ClassMethod getVasoactiveAgents(icuaId As %String, ancvcCodeStr As %String = "", startDate As %String = "", toDate As %String = "") As %String
{
	s retStr=0	
	q:icuaId=""
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	s EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
	q:EpisodeID=""
	f j=1:1:$l(ancvcCodeStr,"^") d
	.s ancvcCode=$p(ancvcCodeStr,"^",j)
	.q:ancvcCode=""
	.s ancvcId=$o(^DHCICUC("ViewCat",0,ancvcCode,""))
	.q:ancvcId=""
	.s catList=$p($g(^DHCICUC("ViewCat",ancvcId)),"^",7)
	.i catList'="" d
	..s icuaStartDate=$p($g(^DHCICUArrange(icuaId)),"^",6)
	..i icuaStartDate<startDate s icuaStartDate=startDate
	..s seq=0
	..s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	..q:oeordId="" //未开过医嘱
	..s arcimId=""
	..f  s arcimId=$o(^OEORDi(0,"ARCIM",oeordId,arcimId)) q:arcimId=""  d
	...s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
	...q:phcdfId=""
	...s desc=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",2)
	...s phcSubcatId=$p($g(^PHCD(+phcdfId,1)),"^",3)
	...q:phcSubcatId=""
	...q:("~"_catList_"~")'[("~"_phcSubcatId_"~")
	...;w icuaId_"/ "_arcimId,"/    "_phcSubcatId_"/  "_desc,!
	...s oeoriSttDate=startDate-1
	...f  s oeoriSttDate=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,oeoriSttDate)) q:oeoriSttDate=""  d
	....i (oeoriSttDate>toDate) s oeoriSttDate=$h+10000 //退出	
	....s oeoriSub=""
	....f  s oeoriSub=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,oeoriSttDate,oeoriSub)) q:oeoriSub=""  d
	.....q:'$d(^OEORD(oeordId,"I",oeoriSub))
	.....s oeoriStat=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",13) ;医嘱状态
	.....s oeoriXdate=$p(^OEORD(oeordId,"I",oeoriSub,3),"^",34) ;停医嘱日期
	.....s oeoriXTime=$p(^OEORD(oeordId,"I",oeoriSub,2),"^",15) ;停医嘱时间
	.....q:((+oeoriXdate)<(+startDate))&&(oeoriStat="4")
	.....s oeoreSub=0
	.....f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:oeoreSub=""  d	
	......s oeoreId=oeordId_"||"_oeoriSub_"||"_oeoreSub
	......s icuoStartDate=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",1)
	......s icuoStartTime=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",2)
	......q:(icuoStartDate<startDate)||(icuoStartDate>toDate)
	......s retStr=1
	q retStr
}

// w ##class(web.DHCICUStatTEST).GetTestResultByWardID(33,"2015-12-01","2015-12-28")

ClassMethod GetTestResultByWardID(wardId, fromDate As %String, toDate As %String) As %String
{
	k ^DHCICUDebug
	s ^DHCICUDebug(0)="床号^病案号^姓名^标本来源^病原菌^标本送检日期+时间^病人来源科室^收入ICU时长（小时）^留取标本当时导管类型^是否免疫抑制"
	//是否免疫的基础疾病code   immunosuppression
	s immunosuppression="^STZLGFZY^AIDS^BXB^MXLBXBXB^GSL^LBL^QTXYXTZL^HUALIAO^LIQUE^MXRYZJB^GSYZ ^QTYZ^FSMYB^TPZJSSYS^PQCSH^CSLJP^LZXBPX^XTMYQX^"
	
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	s icuaIdList=""
	f date=fromDate:1:toDate d
	.s icuaId=""
	.f  s icuaId=$o(^DHCICUArrange(0,"SDate",date,icuaId)) q:icuaId=""  d
				..q:'$d(^DHCICUArrange(icuaId))
				..s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
				..q:+icuBedId'=wardId			 
				..i ("^"_icuaIdList_"^")'[icuaId s icuaIdList=icuaIdList_"^"_icuaId
	s arcimdesc=""
	
	f j=1:1:$l(icuaIdList,"^") d
			.s icuaId=+$p(icuaIdList,"^",j)
			.q:icuaId=""
			.s retstr="",Teststr=""
			.s EpisodeID=$p($g(^DHCICUArrange(+icuaId)),"^",1) ;就诊号
			.s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
			.;s PapmiMedicare=$p($g(^PAPER(papmiId,"PAT",1)),"^",22) ;病案号
			.s paadmtype=$p($g(^PAADM(EpisodeID)),"^",2)
			.s PapmiMedicare=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,paadmtype,.ErrMsg)
			.s PatName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
			.s oeordId=""
			.s retstr=icuaId
			.s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
			.s icuBedSub=$p(icuBedId,"||",2)
			.s tBedCode=$p($g(^PAWARD(+icuBedId,"BED",+icuBedSub)),"^",1)
			
			.s $p(retstr,"^",1)=tBedCode
			.s $p(retstr,"^",2)=PapmiMedicare
			.s $p(retstr,"^",3)=PatName
			.s value=""
			.s opExecute=$p($g(^DHCICUArrange(+icuaId)),"^",30) //非手术
			.i opExecute="N" d
			..s formWardList=##class(web.DHCICUCom).GetWardInInfo("",icuaId,"","","D")
			..i formWardList'="" s formWard=$p($p(formWardList,"^",3),"-",2)
			..i formWard'="" s value=formWard
			..e  s value="其它医院"	
			.i opExecute="E" s value="急诊手术"
			.i opExecute="B" s value="择期手术"
			
			.s $p(retstr,"^",7)=value ;病人来源
			
			.s inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
	        .s inDate=$p(inDateTime,"^"),inTime=$p(inDateTime,"^",2)
			.s outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
			.s inWardPat=0
			.i outDateTime'="" s outDate=$p(outDateTime,"^"),outTime=$p(outDateTime,"^",2)
			.e  s outDate=+$h,outTime=$p($h,",",2)
			.s icuHour=##class(web.DHCClinicCom).CalculateDuration(inDate,inTime,outDate,outTime,"H")
			.s $p(retstr,"^",8)=icuHour ;入ICU时长
			
			
			.s icuudId="",value=""
			.f  s icuudId=$o(^DHCICUUnderlyingDisease(0,"ICUA",icuaId,icuudId)) q:icuudId=""  d
			 ..s clcudId=$lg(^DHCICUUnderlyingDisease(icuudId),2)
			 ..q:clcudId=""
			 ..s clccode=$lg($g(^DHCCLC("UnderlyingDisease",clcudId)),1)
			 ..q:immunosuppression'[clccode
			 ..q:$lg($g(^DHCCLC("UnderlyingDisease",clcudId)),2)=""
			 ..i value'="" s value=value_","
			 ..s value=value_$lg($g(^DHCCLC("UnderlyingDisease",clcudId)),2)
			.s $p(retstr,"^",10)=value ;是否免疫		
			
			
			
			
			.f  s oeordId=$o(^OEORD(0,"Adm",EpisodeID,oeordId))  q:oeordId=""  d
			 ..s arcimId=""
			 ..f  s arcimId=$o(^OEORDi(0,"ARCIM",oeordId,arcimId)) q:(arcimId="")  d
			 
			  ...s arcimsub=$p(arcimId,"||",1)
			  ...s arcimsub2=$p(arcimId,"||",2)
			  ...s arcimCat=$p(^ARCIM(arcimsub,arcimsub2,1),"^",10)
			  ...q:(arcimCat'=196)&&(arcimCat'=342)
			  ...;w arcimCat,!
			  ...s arcimdesc=$p(^ARCIM(arcimsub,arcimsub2,1),"^",2)
			  ...;b ;"arcimdesc"
			  ...s oeoriSttDate=fromDate-1
			  ...f  s oeoriSttDate=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,oeoriSttDate)) q:(oeoriSttDate="")  d
				....i (oeoriSttDate>toDate) s oeoriSttDate=$h+10000 //退出
				....s oeoriSub=""
				....f  s oeoriSub=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,oeoriSttDate,oeoriSub)) q:(oeoriSub="")  d
				.....s labNo=$p(^OEORD(oeordId,"I",oeoriSub,3),"^",20)
				.....q:'$d(^OEORD(oeordId,"I",oeoriSub))
				.....s oeoriSttDat=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
				.....s oeoriSttTim=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
                .....s oeoriSttDat=##class(web.DHCClinicCom).ConvertToDate(oeoriSttDat)
				.....s oeoriSttTim=##class(web.DHCClinicCom).ConvertToTime(oeoriSttTim)
				.....s curSpecSub=$o(^OEORD(oeordId,"I",oeoriSub,"SPEC",0))
				.....q:curSpecSub=""
				.....s curSpecCode=$p(^OEORD(oeordId,"I",oeoriSub,"SPEC",curSpecSub),"^",1)
				.....s curSpecDesc=^TTAB("SPEC",curSpecCode)
				.....s $p(retstr,"^",4)=$p(curSpecDesc,"\",1) ;标本来源
 			    .....s labno=labNo
 				.....s ts=""
 				.....q:labno=""
 				.....f  s ts=$O(^TEPI(labno,1,ts)) q:ts=""  d
 				......s tscnt=""
 				......f  s tscnt=$O(^TEPI(labno,1,ts,tscnt)) q:tscnt=""  d 
 				.......s receiveDate=$p(^TEPI(labno,1,ts,tscnt),"\",1)
				.......s receiveTime=$p(^TEPI(labno,1,ts,tscnt),"\",2)*60
 				.......s receiveDate=##class(web.DHCClinicCom).ConvertToDate(receiveDate)
				.......s receiveTime=##class(web.DHCClinicCom).ConvertToTime(receiveTime)
 				.......s $p(retstr,"^",6)=receiveDate_" "_receiveTime   ;标本接收日期+时间
 				.......s tc=""
 				.......f  s tc=$O(^TEPI(labno,1,ts,tscnt,"DATA",tc)) q:tc=""  d
    			........s resstr=$p(^TEPI(labno,1,ts,tscnt,"DATA",tc),"\",1)
    			........s tcdesc=$p(^TTAB("TC",tc),"\",1)
    			........s value=tcdesc_","_resstr_","_labno
    			........i Teststr'="" s Teststr=Teststr_"@"_value
			    ........e  s Teststr=value
    		
    			
 			.s $p(retstr,"^",5)=Teststr ;结果
 			.s ParaItemStr=##class(web.DHCICUStatTEST).GetParaItemByicuaId(icuaId,fromDate,"",toDate,"","zsgxjm^CV:ysgxjm^zjnjm^yjnjm^zgjm^ygjm")
            .s $p(retstr,"^",9)=ParaItemStr ;导管类型
 			.s ^DHCICUDebug(icuaId)=retstr
 				
			
	s ^DHCICUDebug(1)="床号^病案号^姓名^标本来源^病原菌^标本送检日期+时间^病人来源科室^收入ICU时长（小时）^留取标本当时导管类型^是否免疫抑制"
		
  q "11111"
}

// 获取某段时间有数据的显示项目

// icucriCode=zsgxjm^CV:ysgxjm^zjnjm^yjnjm^zgjm^ygjm

// w ##class(web.DHCICUStatTEST).GetParaItemByicuaId(8523,"2015-12-01","9:00","2015-12-29","9:00","zsgxjm^CV:ysgxjm^zjnjm^yjnjm^zgjm^ygjm")

ClassMethod GetParaItemByicuaId(icuaId, fromDate As %String, fromTime As %String, toDate As %String, toTime As %String, icucriCode As %String) As %String
{
   s icucriCode="youjingneidongmaizhiguan^zsgxjm^CV:ysgxjm^zjnjm^yjnjm^zgjm^ygjm^UserDefinedzxjm^TISSCVC^TISSCVCScore^zjnjm2^yjnjm2^yjzg^yyjm^zyjm"
   s retstr=""
   q:icucriCode=""
   i icucriCode'=+icucriCode s icucriIdStr=##class(web.DHCICUCom).GetIcuriIdByCode(icucriCode)
   e  s icucriIdStr=icucriCode 
   q:icucriIdStr=""
   s vulue=""
   f i=1:1:$l(icucriIdStr,"^") d
	.s icucriId=$p(icucriIdStr,"^",i)
	.q:icucriId=""
	.s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,icucriId,fromDate,fromTime,toDate,toTime,"First","","")
    .q:value=""
    .s RecordItemDesc=$p($g(^DHCICUC("RecordItem",icucriId)),"^",2)
    .i retstr="" s retstr=RecordItemDesc
    .e  s retstr=retstr_"@"_RecordItemDesc   
   q retstr
}

/// 替换统计维护项目Code
/// w ##class(web.DHCICUStat).replaceCodeValue()
ClassMethod replaceCodeValue(icuciId As %String, replacestr As %String = "")
{
	q:icuciId=""
	s icuciiSub=0,ret=""
	f  s icuciiSub=$o(^DHCICUCInquiry(icuciId,"I",icuciiSub)) q:icuciiSub=""  d
	.s codeStr=""
	.s codeList= $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)
	.f i=1:1:$l(codeList,"-") d
	..s code=$p(codeList,"-",i)
	..i codeStr'="" s codeStr=codeStr_replacestr
	..s codeStr=codeStr_code
	.w codeStr,!
	.TSTART
	.s PLIST(2)=codeStr
	.&SQL(update DHC_ICUC_InquiryItem values:PLIST() where ICUCII_Parref=:icuciId and childsub=:icuciiSub)
	.TCOMMIT
	q ret
}

/// Creator：      	wll
/// CreatDate：    	2016-03-21
/// Description： 	根据重症科室查找重症病区
/// d ##class(%ResultSet).RunQuery("web.DHCICUStat","FindICUWardList","19")
Query FindICUWardList(loc As %String) As %Query(ROWSPEC = "Id:%String,Code:%String,Desc:%String,Summuary:%String,Available:%String,UnAvailable:%String,bedrate:%String") [ SqlProc ]
{
}

ClassMethod FindICUWardListExecute(ByRef qHandle As %Binary, loc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	quit:loc="" "0"
	set linkSub=0
	for  set linkSub=$o(^CTLOC(loc,"LINK",linkSub)) q:linkSub=""  d
	.s ctlocId=^CTLOC(loc,"LINK",linkSub)
	.s ctlocCode="",ctlocDesc=""
	.i ctlocId'=""  d
	..s ctlocCode=$p($g(^CTLOC(ctlocId)),"^",1)
	..s ctlocDesc=$p($g(^CTLOC(ctlocId)),"^",2)
	..i $l(ctlocDesc,"-")>1  s ctlocDesc=$p(ctlocDesc,"-",2)
	..s Ward=$o(^PAWARD(0,"WARD_LocationDR",ctlocId,""))
	..s bedsub=0,sum=0,avail=0,unavail=0
	..f  s bedsub=$o(^PAWARD(Ward,"BED",bedsub)) q:bedsub=""  d
	...s sum=sum+1
	...s bedId=Ward_"||"_bedsub
	...&sql(select BED_Available into :bedflag from PAC_Bed where BED_RowID=:bedId)
    ...i bedflag="N"  s unavail=unavail+1
    ...e  s avail=avail+1
    ..s bedrate=avail_"/"_sum
	..d OutputRow
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
	Set Data=$lb(ctlocId,ctlocCode,ctlocDesc,sum,avail,unavail,bedrate)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindICUWardListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUWardListExecute ]
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

ClassMethod FindICUWardListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUWardListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      	wll
/// CreatDate：    	2016-03-22
/// Description： 	根据护理单元ID获取对应病区ID
/// d ##class(web.DHCICUStat).GetWardIdByLocId("19")
ClassMethod GetWardIdByLocId(loc) As %String
{
	q:loc="" "0"
	q $o(^PAWARD(0,"WARD_LocationDR",loc,""))
}

/// Creator：      	wll
/// CreatDate：    	2016-03-22
/// Description： 	根据床位Id判断床位是否空闲
/// w ##class(web.DHCICUStat).GetBedStatus("23||1")
ClassMethod GetBedStatus(bed) As %String
{
	q:bed="" "0"
	&sql(select BED_Available into :bedstatus from PAC_Bed where BED_RowID=:bed)
	q bedstatus
}

/// Creator：      	wll
/// CreatDate：    	2016-03-22
/// Description： 	根据床位Id获取该床位的病人的icuaId,没有病人返回为0
/// w ##class(web.DHCICUStat).GetIcuaIdIdByBedId("23||1")
ClassMethod GetIcuaIdIdByBedId(bed) As %String
{
	q:bed="" "0"
	s wardId=$p(bed,"||",1)
	s bedsub=$p(bed,"||",2)
    s admsub=$o(^PAWARDA(wardId,"BED",bedsub,"ADM",0))
    i (admsub="")  s adm=0
    e  s adm=$p(^PAWARDA(wardId,"BED",bedsub,"ADM",admsub),"^",1)
    i (adm'=0) s icuaId=$o(^DHCICUArrange(0,"Adm",adm,0))
    e  s icuaId=0
    q adm_"^"_icuaId
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUStat","FindBed",23)
Query FindBed(BedRowid As %String) As %Query(ROWSPEC = "RoomDesc:%String,RoomRowid1:%String,status") [ SqlProc ]
{
}

ClassMethod FindBedExecute(ByRef qHandle As %Binary, wardId As %String) As %Status
{
 
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i wardId'=""  d
	.s childsub=0
	.f  s childsub=$o(^PAWARD(wardId,"BED",childsub))  q:childsub=""  d
	..s RoomDesc=$p(^PAWARD(wardId,"BED",childsub),"^",1)
	..s RoomRowid1=wardId_"||"_childsub
	..s admsub=$o(^PAWARDA(wardId,"BED",childsub,"ADM",0))
    ..i (admsub="")  s adm=0
    ..e  s adm=$p(^PAWARDA(wardId,"BED",childsub,"ADM",admsub),"^",1)
    ..i (adm'=0) s icuaId=$o(^DHCICUArrange(0,"Adm",adm,0))
    ..e  s icuaId=0
    ..i (icuaId'=0) s status=$p($g(^DHCICUArrange(+icuaId)),"^",18)
    ..e  s status=""
	..d OutputRow2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(RoomDesc,RoomRowid1,status)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBedFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBedExecute ]
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

ClassMethod FindBedClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBedExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      	wll
/// CreatDate：    	2016-03-22
/// Description： 	根据IcuaId获取icu病人基本信息
/// d ##class(%ResultSet).RunQuery("web.DHCICUStat","FindInfoByIcuaId",74)
Query FindInfoByIcuaId(icuaId) As %Query(ROWSPEC = "icuaId,icustatus,patName,patSex,patAge,papmiMedicare,ResidentDoctor,MainDoctor,ChargeNurse,Apachevalue,Sofavalue,Tissvalue,TracheaCannula,Bgri,VDeviceName,Picco,LabPanic,Cvvh,Ecmo,PronepositionTimes,EarlyactTimes,CheckoutTimes,SGcatheterTimes,BloodcultureTimes") [ SqlProc ]
{
}

ClassMethod FindInfoByIcuaIdExecute(ByRef qHandle As %Binary, icuaId) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
    s EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
	s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
	s icustatus=$p($g(^DHCICUArrange(+icuaId)),"^",18)
	s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	s nowDate=+$h
	s nowTime=$p($h,",",2)
	s inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
	s outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
    i outDateTime="" d
        .b ;01
	    .s outDateTime=$h+($p($h,",",2)/100000)
	    .s outDate=+$h,outTime=$p($h,",",2)
		.s isCurrPat=1
    e  d
		.s outDate=$p(outDateTime,"^"),outTime=$p(outDateTime,"^",2)
		.s outDateTime=outDate+(outTime/100000)
	i inDateTime'="" d
		.s inDate=$p(inDateTime,"^"),inTime=$p(inDateTime,"^",2)
		.s inDateTime=inDate+(inTime/100000)
	s inDate=$p(inDateTime,"."),inTime=(inDateTime-inDate)*100000	
	;姓名
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1) 
	;性别
	s patSex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2) 
	;年龄
	s patAge=##class(web.DHCClinicCom).CalAge($p($g(^PAPER(papmiId,"ALL")),"^",6),+$h)
	;病案号
	//s papmiMedicare=$p($g(^PAPER(papmiId,"PAT",1)),"^",22) 
	s paadmtype=$p($g(^PAADM(EpisodeID)),"^",2)
	s papmiMedicare=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,paadmtype,.ErrMsg)
    ;主管医生
    s ResidentDoctor="" 
    s ResidentdocID=$P($g(^DHCICUArrange(icuaId)),"^",28)
    i ResidentdocID'="" s ResidentDoctor=$p(##class(web.DHCClinicCom).GetUserTypeName(ResidentdocID),"^",2)
    ;主治医生
    s MainDoctor=""
    s MaindocID=$P($g(^DHCICUArrange(icuaId)),"^",29)
    i MaindocID'="" s MainDoctor=$p(##class(web.DHCClinicCom).GetUserTypeName(MaindocID),"^",2)
    ;责任护士
    s ChargeNurse=""
    s ChargeNurseDr=$p($g(^DHCICUArrange(+icuaId)),"^",60)
    i ChargeNurseDr'="" s ChargeNurse=$p(##class(web.DHCClinicCom).GetUserTypeName(ChargeNurseDr),"^",2)
    ;APACHE II评分
    s ApachRecordId=##class(web.DHCICUCom).GetIcuriIdByCode("ApacheTotalScore")
    s Apachevalue=##class(web.DHCICUOrder).GetRecordValue(icuaId,ApachRecordId,inDate,inTime,"","","First") 
    ;SOFA 评分
    s SofaRecordId=##class(web.DHCICUCom).GetIcuriIdByCode("SOFATotal")
    s Sofavalue=##class(web.DHCICUOrder).GetRecordValue(icuaId,SofaRecordId,inDate,inTime,"","","First") 
    ;TISS 评分
    s TissRecordId=##class(web.DHCICUCom).GetIcuriIdByCode("TISSTotal")
    s Tissvalue=##class(web.DHCICUOrder).GetRecordValue(icuaId,TissRecordId,inDate,inTime,"","","First") 
    ;气管插管
    s TracheaCannulaId=##class(web.DHCICUCom).GetIcuriIdByCode("TracheaCannula")
    s TracheaCannula=##class(web.DHCICUOrder).GetRecordValue(icuaId,TracheaCannulaId,inDate,inTime,"","","Exact",nowDate,nowTime)
	;气管插管状态
	s BgriId=##class(web.DHCICUCom).GetIcuriIdByCode("bgri")
	s Bgri=##class(web.DHCICUOrder).GetRecordValue(icuaId,BgriId,inDate,inTime,"","")
	;呼吸机
	s VDeviceNameId=##class(web.DHCICUCom).GetIcuriIdByCode("VDeviceName")
	s VDeviceName=##class(web.DHCICUOrder).GetRecordValue(icuaId,VDeviceNameId,inDate,inTime,"","","Exact",nowDate,nowTime)
	;PICCO
	s PiccoId=##class(web.DHCICUCom).GetIcuriIdByCode("P:CCO")
	s Picco=##class(web.DHCICUOrder).GetRecordValue(icuaId,PiccoId,inDate,inTime,"","","Exact",nowDate,nowTime)
	;危急值
	s LabPanicId=##class(web.DHCICUCom).GetIcuriIdByCode("LabPanic")
	s LabPanic=##class(web.DHCICUOrder).GetRecordValue(icuaId,LabPanicId,inDate,inTime,"","","Exact",nowDate,nowTime)
	;CVVH
	s CvvhId=##class(web.DHCICUCom).GetIcuriIdByCode("PBP_METHOD")
	s Cvvh=##class(web.DHCICUOrder).GetRecordValue(icuaId,CvvhId,inDate,inTime,"","","Exact",nowDate,nowTime)
	;ECMO
	s EcmoId=##class(web.DHCICUCom).GetIcuriIdByCode("ECMOLL")
	s Ecmo=##class(web.DHCICUOrder).GetRecordValue(icuaId,EcmoId,inDate,inTime,"","","Exact",nowDate,nowTime)
	;俯卧位当天执行次数
	s PronepositionTimes=..GetTimesByDate("","",inDateTime,outDateTime,oeordId,"19850||1")
	;早期活动当天执行次数
	s EarlyactTimes=..GetTimesByDate("","",inDateTime,outDateTime,oeordId,"33457||1")
	;外出检查当天执行次数
	s CheckoutTimes=..GetTimesByDate("","",inDateTime,outDateTime,oeordId,"33706||1")
	;SG导管当天执行次数
	s SGcatheterTimes=..GetTimesByDate("","",inDateTime,outDateTime,oeordId,"33346||1")
	;血培养在病区执行次数
	s BloodcultureTimes=..GetTimesByDate(inDate,outDate,inDateTime,outDateTime,oeordId,"33346||1")
	do OutputRow
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(icuaId,icustatus,patName,patSex,patAge,papmiMedicare,ResidentDoctor,MainDoctor,ChargeNurse,Apachevalue,Sofavalue,Tissvalue,TracheaCannula,Bgri,VDeviceName,Picco,LabPanic,Cvvh,Ecmo,PronepositionTimes,EarlyactTimes,CheckoutTimes,SGcatheterTimes,BloodcultureTimes)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindInfoByIcuaIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInfoByIcuaIdExecute ]
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

ClassMethod FindInfoByIcuaIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInfoByIcuaIdExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// 根据就诊号获取病人信息
/// d ##class(%ResultSet).RunQuery("web.DHCICUStat","FindPatientInfo","277")
Query FindPatientInfo(EpisodeID) As %Query(ROWSPEC = "MasterID,EpisodeID,RegisterNo,MedicareNo,Name,Gender,Age,BirthDate,BloodType,PersonID,HomeAddress,HomePhoneNo,WorkPhoneNo,MobilePhoneNo,AdmReason,AdmissionDate,PatientLocId,PatientLoc,PatientWardId,PatientBedId,patientbedcode") [ SqlProc ]
{
}

ClassMethod FindPatientInfoExecute(ByRef qHandle As %Binary, EpisodeID) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	set patMasterID=$piece(^PAADM(EpisodeID),"^",1)
	set patientInfo=^PAPER(patMasterID,"ALL")
	
	//病人登记号 统一调用病案的接口
	set registerNo=##class(web.DHCClinicCom).GetRegNobyEpisodeID(EpisodeID)
	
	//病人姓名
	set patientName=$piece(patientInfo,"^",1)
	
	//病人病案号(住院号) 统一调用病案的接口
	//set medicareNo=##class(web.DHCClinicCom).GetMedicareNo("",EpisodeID)
	set paadmtype=$p($g(^PAADM(EpisodeID)),"^",2)
	set medicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,paadmtype,.ErrMsg)
	
	//病人性别 存在没有性别的情况
	set genderId=$piece(patientInfo,"^",7)
	set gender=""
	if (genderId'="")
	{
		set gender=$piece($get(^CT("SEX",genderId)),"^",2)	
	}
	
	//病人年龄
	set birthDate=$piece(patientInfo,"^",6)
	set today=+$horolog
	set age=##class(web.DHCClinicCom).CalAge(birthDate,today)
	
	//病人出生日期
	
	set birthDate=##class(web.DHCClinicCom).ConvertToDate(birthDate)
	
	//病人血型
	set bloodType=##class(web.DHCClinicCom).GetBloodType(registerNo)
	
	//病人身份证号
	set personID=$piece(patientInfo,"^",9)
	
	//家庭住址
	set homeAddress=$get(^PAPER(patMasterID,"PER","ADD",1))
	
	//家庭电话号码
	set homePhoneNo=$piece($get(^PAPER(patMasterID,"PER",1)),"^",11)
	
	//工作电话号码
	set workPhoneNo=$piece($get(^PAPER(patMasterID,"PER",1)),"^",9)
	
	//移动电话号码
	set mobilePhoneNo=$piece($get(^PAPER(patMasterID,"PER",4)),"^",21)
	
	//病人身份(费用类型)
	set admReasonId=$piece(^PAADM(EpisodeID,1),"^",7)
	set admReason=""
	if (admReasonId'="")
	{
		set admReason=$piece($get(^PAC("ADMREA",admReasonId)),"^",2)	
	}
	
	//入院日期
	set admissionDate=$piece(^PAADM(EpisodeID),"^",6)
	set admissionDate=##class(web.DHCClinicCom).ConvertToDate(admissionDate)
	
	//就诊科室
    set patientlocId=$piece(^PAADM(EpisodeID),"^",4)
    set patientloc=""
    if (patientlocId'="")
    {
	    set patientloc=$piece($get(^CTLOC(patientlocId)),"^",2)
	    if ($piece(patientloc,"-",2)'="") set patientloc=$piece(patientloc,"-",2)
    }
    //病区
    set patientwardId=$piece(^PAADM(EpisodeID),"^",70)
    //床位
    set patientbedId=$piece(^PAADM(EpisodeID),"^",73)
    //床号
    set patientbedsub=$p(patientbedId,"||",2)
    set patientbedcode=""
    if (patientwardId'="")&&(patientbedsub'="") s patientbedcode=$p($g(^PAWARD(patientwardId,"BED",patientbedsub)),"^",1)  
	do OutputRow
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(patMasterID,EpisodeID,registerNo,medicareNo,patientName,gender,age,birthDate,bloodType,personID,homeAddress,homePhoneNo,workPhoneNo,mobilePhoneNo,admReason,admissionDate,patientlocId,patientloc,patientwardId,patientbedId,patientbedcode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindPatientInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPatientInfoExecute ]
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

ClassMethod FindPatientInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPatientInfoExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator：      	wll
/// CreatDate：    	2016-03-24
/// Description： 	获取医嘱某段时间内的执行次数
/// w ##class(web.DHCICUStat).GetTimesByDate("2013-11-6","2015-12-1","63131.5503","63901.36",16,"10337||1")
ClassMethod GetTimesByDate(startDate, endDate, inDateTime, outDateTime, oeordId, arcimIdStr) As %String
{
	q:(oeordId="")!(arcimIdStr="") "0"
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s times=0
	f i=1:1:$l(arcimIdStr) d
	.s arcimId=$p(arcimIdStr,"^",i)
	.q:arcimId=""
	.s oeoriSttDate="",ArcimDesc=""
	.s oeoriSttDate=startDate-1
	.f  s oeoriSttDate=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,oeoriSttDate)) q:(oeoriSttDate="")  d
	    ..i (oeoriSttDate>endDate) s oeoriSttDate=$h+10000 //退出
	    ..s oeoriSub=""
	    ..f  s oeoriSub=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,oeoriSttDate,oeoriSub)) q:(oeoriSub="")  d
	        ...q:'$d(^OEORD(oeordId,"I",oeoriSub))
	        ...s oeoriId=oeordId_"||"_oeoriSub
	        ...s oecprCode="",oecprType=""
	        ...s oecprId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",8)
	        ...i oecprId>0 s oecprCode=$p($g(^OECPR(+oecprId)),"^",1)
	        ...i (oecprCode="S")!(oecprCode="OMST")!(oecprCode="OMCQZT") s oecprType="Y" //长期医嘱
	        ...s ordStatCode=##Class(web.DHCClinicCom).GetOrdStatCode(oeoriId)
	        ...q:("DIU"[ordStatCode)&&(oecprType'="Y")
	        ...q:("IU"[ordStatCode)&&(oecprType="Y")
	        ...q:$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",12)'=""
	        ...s oeoriSttDat=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
	        ...s oeoriSttTim=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
	        ...s oeoriSttDateTime=oeoriSttDat+(oeoriSttTim/100000)
	        ...q:oeoriSttDateTime<inDateTime
	        ...q:oeoriSttDateTime>outDateTime
	        ...s times=times+1
	q times
}

/// 根据科室病区汇总
/// d ##class(%ResultSet).RunQuery("web.DHCICUStat","GetOverviewInfo",23)
Query GetOverviewInfo(Ward) As %Query(ROWSPEC = "bedrate,ageavg") [ SqlProc ]
{
}

ClassMethod GetOverviewInfoExecute(ByRef qHandle As %Binary, Ward) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s bedsub=0,sum=0,avail=0,unavail=0
	s sumage=0,admnum=0
	f  s bedsub=$o(^PAWARD(Ward,"BED",bedsub)) q:bedsub=""  d
	.s sum=sum+1
	.s bedId=Ward_"||"_bedsub
	.&sql(select BED_Available into :bedflag from PAC_Bed where BED_RowID=:bedId)
    .i bedflag="N"  s unavail=unavail+1
    .e  s avail=avail+1
    .s admsub=$o(^PAWARDA(Ward,"BED",bedsub,"ADM",0))
    .i (admsub="")  s adm=0
    .e  s adm=$p(^PAWARDA(Ward,"BED",bedsub,"ADM",admsub),"^",1)
    .i (adm'=0)  d
    ..s admnum=admnum+1
    ..s papmiId=$p($g(^PAADM(adm)),"^",1)
    ..s patAge=##class(web.DHCClinicCom).CalAge($p($g(^PAPER(papmiId,"ALL")),"^",6),+$h)
    ..s sumage=sumage+(+patAge)
    i admnum'=0 s ageavg=$fn(sumage/admnum,",",2)_"岁"
    e  s ageavg="0岁"
    s bedrate=unavail_"/"_sum
	do OutputRow
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(bedrate,ageavg)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetOverviewInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOverviewInfoExecute ]
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

ClassMethod GetOverviewInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOverviewInfoExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// 提取医生工作量统计数据
/// d ##class(%ResultSet).RunQuery("web.DHCICUStat","GetDocWorkInfo",34)
Query GetDocWorkInfo(icuciId) As %Query(ROWSPEC = "doc,apache,newpatnum,leave,trachea,vdevice,picco,sg,cvvh,overturn,active,total") [ SqlProc ]
{
}

ClassMethod GetDocWorkInfoExecute(ByRef qHandle As %Binary, icuciId) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	if ($d(^DHCICUInquiry(icuciId,0))=0)  d
	.s doc="",apache="",newpatnum="",leave="",trachea="",vdevice="",picco="",sg="",cvvh="",overturn="",active="",total=""
	.do OutputRow
	else  d
	.s rowid=""  f  s rowid=$o(^DHCICUInquiry(icuciId,rowid))  q:rowid=""  d
	..q:rowid=0
    ..s doc=$p(^DHCICUInquiry(icuciId,rowid),"^",1)
    ..s apache=$p(^DHCICUInquiry(icuciId,rowid),"^",2)
    ..s newpatnum=$p(^DHCICUInquiry(icuciId,rowid),"^",3)
    ..s leave=$p(^DHCICUInquiry(icuciId,rowid),"^",4)
    ..s trachea=$p(^DHCICUInquiry(icuciId,rowid),"^",5)
    ..s vdevice=$p(^DHCICUInquiry(icuciId,rowid),"^",6)
    ..s picco=$p(^DHCICUInquiry(icuciId,rowid),"^",7)
    ..s sg=$p(^DHCICUInquiry(icuciId,rowid),"^",8)
    ..s cvvh=$p(^DHCICUInquiry(icuciId,rowid),"^",9)
    ..s overturn=$p(^DHCICUInquiry(icuciId,rowid),"^",10)
    ..s active=$p(^DHCICUInquiry(icuciId,rowid),"^",11)
    ..s total=$p(^DHCICUInquiry(icuciId,rowid),"^",12)    
	..do OutputRow
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(doc,apache,newpatnum,leave,trachea,vdevice,picco,sg,cvvh,overturn,active,total)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetDocWorkInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDocWorkInfoExecute ]
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

ClassMethod GetDocWorkInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDocWorkInfoExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Descpritation:按医嘱项获取护理记录用量
/// Input:icuaId,fromDate,fromTime,toDate,toTime,ArcimID
/// Output:实际数据用量
/// w ##class(web.DHCICUStat).SumByArcimID(11539,64174,0,64174,86399,"26953||1")
ClassMethod SumByArcimID(icuaId As %String, fromDate As %String, fromTime As %String, toDate As %String, toTime As %String, ArcimId As %String) As %String
{
	q:(icuaId="")!(ArcimId="") 0
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s fromTime=##class(web.DHCClinicCom).ConvertToTimeH(fromTime)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	s toTime=##class(web.DHCClinicCom).ConvertToTimeH(toTime)
	s icucriId=##class(web.DHCICUCom).GetIcuriIdByCode("DetailVolumePump")
	s fromDateTime=fromDate+(fromTime/100000)
	s toDateTime=toDate+(toTime/100000)
	s icuoid="",sumQty=0
	f  s icuoid=$o(^DHCICUOrder(0,"Arr",icuaId,icuoid)) q:(icuoid="")  d
		.s icuoArcimDr=$p($g(^DHCICUOrder(icuoid)),"^",9)
		.q:(icuoArcimDr'="")&&(icuoArcimDr'=ArcimId)
		.s startDate=$p($g(^DHCICUOrder(icuoid)),"^",5)
		.s startTime=$p($g(^DHCICUOrder(icuoid)),"^",6)
		.s startDateTime=startDate+(startTime/100000)
		.q:(startDateTime<fromDateTime)!(startDateTime>toDateTime)
		.;w startDateTime,!
		.s icuComOrdDr=$p($g(^DHCICUOrder(icuoid)),"^",2)
		.q:(icuComOrdDr'="")&&(icuComOrdDr'=icucriId)
		.s sumQty=sumQty+(+$p($g(^DHCICUOrder(icuoid)),"^",11))
	q sumQty
}

// 根据icuoId获取主项备注20160616

// w ##class(web.DHCICUStat).GetparentItemRemarkByIcuoId(70)

ClassMethod GetparentItemRemarkByIcuoId(icuoId) As %String
{
   s parentItemRemark=""
   s mainIcuoId=$p(^DHCICUOrder(icuoId),"^",36)
   q:mainIcuoId="" ""
   s parentItemRemark=$p($g(^DHCICUOrder(mainIcuoId)),"^",37)
   q parentItemRemark
}

// 根据icuoId获取主项名称20160616

// w ##class(web.DHCICUStat).GetparentItemNameByIcuoId(70)

ClassMethod GetparentItemNameByIcuoId(icuoId) As %String
{
  s parentItemName=""
   s icuoparaitemId=$p(^DHCICUOrder(icuoId),"^",38)
   q:icuoparaitemId="" ""
   s IcuParaId= $p(icuoparaitemId,"||",1)
   s IcuParaItemId= $p(icuoparaitemId,"||",2)
   s parentitemid=$p($g(^DHCICUPara(IcuParaId,"I",IcuParaItemId)),"^",19)
   s parentItemName=$p($g(^DHCICUPara(IcuParaId,"I",IcuParaItemId)),"^",14)
   i parentitemid=""  q parentItemName
   q:parentitemid="" ""
   s ParaId= $p(parentitemid,"||",1)
   s ParaItemId= $p(parentitemid,"||",2)
   s parentItemName=$p(^DHCICUPara(ParaId,"I",ParaItemId),"^",14)
   q parentItemName
}

// 

// w ##class(web.DHCICUStat).CalculateDuration("2016-09-01","15:00:00","2016-09-02","10:00","H")

ClassMethod CalculateDuration(sourceDate, sourceTime, targetDate, targetTime, type = "S") As %String
{
	s sourceDate=##class(web.DHCClinicCom).ConvertToDateH(sourceDate,"")
	s targetDate=##class(web.DHCClinicCom).ConvertToDateH(targetDate,"")
	s sourceTime=##class(web.DHCClinicCom).ConvertToTimeH(sourceTime,"")
	s targetTime=##class(web.DHCClinicCom).ConvertToTimeH(targetTime,"")
	i sourceTime="" s sourceTime=-1
	i targetTime="" s targetTime=86400
	s durationDay=targetDate-sourceDate
	i targetTime<sourceTime s durationDay=durationDay-1,targetTime=targetTime+86400
	q:type="D" durationDay
	q:type="H" durationDay*24+((targetTime-sourceTime)\3600)
	q:type="M" durationDay*1440+((targetTime-sourceTime)\60)
	q:type="S" durationDay*86400+(targetTime-sourceTime)
	q 0
}

Query FindICUInquiryDetail(needIcuaId, icuciId, icuciiSub, fromDate = "", toDate = "") As %Query(ROWSPEC = "IcuaId:%String,ItemCode:%String,ItemDesc:%String,StartDateTime:%String,LeaveDateTime:%String,CurDatetime:%String,Note:%String,Qty:%String,BeforeStartSecond:%String,AfterLeaveSecond:%String,ExeDateTime:%String,LabEpisodeNo:%String,SpeciDesc:%String,oeoriXDateTime:%String") [ SqlProc ]
{
}

/// w ##class(web.DHCICUStat).FindICUInquiryDetail("",6,18)
/// Creator: YPZ
/// CreatDate: 2016-11-22
/// Description: 查询统计明细数据  
/// Table：DHC_ICUC_InquiryItem,DHC_ICU_Debug,DHC_ICU_Arrange,DHC_ICU_Order,OE_OrdItem
/// Input：needIcuaId:DHC_ICU_Arrange的Id，空时查在查出结果的查询内容中的icuaId，
/// 			icuciId_"||"_icuciiSub:DHC_ICUC_InquiryItem查询项定义表Id，
/// 		fromDate，toDate：起止时间：空时为病人开始日期向前提1000天、转归日期向后调1000天 
/// Result：返回Query并在DHC_ICU_Debug显示查询结果。
ClassMethod FindICUInquiryDetailExecute(ByRef qHandle As %Binary, needIcuaId, icuciId, icuciiSub, fromDate = "", toDate = "") As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCICUStat","FindICUInquiryDetail",9601,65,15)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1	

	i (icuciId="")!(icuciiSub="") Set qHandle=$lb(0,repid,0) Quit $$$OK //"查询项Id错!"
	i '$d(^DHCICUCInquiry(icuciId,"I",icuciiSub)) Set qHandle=$lb(0,repid,0) Quit $$$OK //"无数据查询项数据!"
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate,"")
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate,"")
	i "ORL"'[$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3) Set qHandle=$lb(0,repid,0) Quit $$$OK //"只支持O、R、L类型数据明细!"
	
	k ^DHCICUDebug
	s count=1
	s ^DHCICUDebug(count)="icuaId^项目代码^项目名称^开始监护日期时间^转归日期时间^数据日期时间^Note^Qty^早于开始时间秒数^晚于转归时间秒数^医嘱执行表时间(长嘱)^标本号^检验标本^停医嘱日期时间(长嘱)"
	i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3)="O" d
		.s icuciiCode=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)
		.q:icuciiCode=""
		.s typeCat=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),31)
		.//s arcimId=$p(icuciiCode,"^",i)
		.//q:arcimId=""
		.i (needIcuaId'="")&($d(^DHCICUInquiry($j,icuciId))<10) d
			..s ^DHCICUInquiry(icuciId,0)=""
		.s icuaId="",ifQuit=0
		.f  s icuaId=$o(^DHCICUInquiry(icuciId,icuaId)) q:(icuaId="")!(ifQuit)  d
			..i (needIcuaId'="") d
				...s icuaId=needIcuaId,ifQuit=1
			..q:+icuaId=0
			..q:'$d(^DHCICUArrange(icuaId))
			..s icuaStartDate=$p(^DHCICUArrange(icuaId),"^",6)
			..s icuaStartTime=$p(^DHCICUArrange(icuaId),"^",8)
			..s icuaLeaveDate=$p($g(^DHCICUArrange(icuaId)),"^",44)
			..s icuaLeaveTime=$p($g(^DHCICUArrange(icuaId)),"^",45)
			..s startDateTime=$zd(icuaStartDate,3)_" "_$zt(icuaStartTime)
			..s leaveDateTime=""
			..i icuaLeaveDate'="" s leaveDateTime=$zd(icuaLeaveDate,3)_" "_$zt(icuaLeaveTime)
			..s findFromDate=icuaStartDate-1000
			..//i (fromDate'="")&(fromDate>icuaStartDate) s findFromDate=fromDate
			..i (fromDate'="") s findFromDate=fromDate
			..s findToDate=icuaLeaveDate
			..i findToDate="" s findToDate=+$h
			..s findToDate=findToDate+1000
			..//i (toDate'="")&(toDate<findToDate) s findToDate=toDate
			..i (toDate'="") s findToDate=toDate
			..w findFromDate,"/"_findToDate,!
			..w icuaId,!
			..s EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
			..s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
			..q:oeordId=""
			..s arcimId=""
			..f  s arcimId=$o(^OEORDi(0,"ARCIM",oeordId,arcimId)) q:(arcimId="")  d
				...q:(typeCat="")&(("^"_icuciiCode_"^")'[("^"_arcimId_"^"))
				...w icuciiCode_"    "_arcimId,typeCat,!
				...s phcPoisonCode=""
				...i (typeCat="Poison")||(typeCat="Antibiotics") d
					....s phcPoisonCode=##class(web.DHCClinicCom).GetPHCPoisonCode(arcimId)
				...//i phcPoisonCode'="" w phcPoisonCode,! b
				...q:(typeCat="Poison")&(("^"_icuciiCode_"^")'[("^"_phcPoisonCode_"^"))
				...s arcimCode=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",1)
				...s arcimDesc=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",2)
				...w arcimId_"/"_arcimCode,"/"_arcimDesc,"/"_findFromDate,!
				...s oeoriSttDate=findFromDate-1
				...f  s oeoriSttDate=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,oeoriSttDate)) q:(oeoriSttDate="")  d
					....i (oeoriSttDate>findToDate) s oeoriSttDate=$h+100000 //退出
					....s oeoriSub="",doseQty=0
					....f  s oeoriSub=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,oeoriSttDate,oeoriSub)) q:(oeoriSub="")  d
							.....;i (needIcuaId=11644) w oeoriSttDate b ;""
							.....q:'$d(^OEORD(oeordId,"I",oeoriSub))
							.....s oeoriId=oeordId_"||"_oeoriSub
							.....s oecprId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",8)								
							.....s oecprCode=$p($g(^OECPR(+oecprId)),"^",1) 
							.....s oecprType="N"
							.....i (oecprCode="S")!(oecprCode="OMST")!(oecprCode="OMCQZT") s oecprType="Y" //长期医嘱
							.....s ordStatCode=##Class(web.DHCClinicCom).GetOrdStatCode(oeoriId)
							.....q:("DIU"[ordStatCode)&&(oecprType'="Y")
							.....q:("IU"[ordStatCode)&&(oecprType="Y")
							.....//w $p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2),!
							.....;q:$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",12)'=""								
							.....s oeoriSttDat=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
							.....s oeoriSttTim=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
							.....s oeoriXDate=$p(^OEORD(oeordId,"I",oeoriSub,3),"^",34) ;停医嘱日期
							.....s oeoriXTime=$p(^OEORD(oeordId,"I",oeoriSub,2),"^",15) ;停医嘱时间
							.....s oeoriXDateTime=""
							.....i oeoriXDate'="" s oeoriXDateTime=$zd(oeoriXDate,3)_" "_$zt(oeoriXTime)
							.....s beforeStartSecond=##class(web.DHCClinicCom).CalculateDuration(icuaStartDate,icuaStartTime,oeoriSttDat,oeoriSttTim)
							.....i beforeStartSecond>0 s beforeStartSecond=""
							.....s afterLeaveSecond=""
							.....i icuaLeaveDate'="" d
								......s afterLeaveSecond=##class(web.DHCClinicCom).CalculateDuration(icuaLeaveDate,icuaLeaveTime,oeoriSttDat,oeoriSttTim)
								......i afterLeaveSecond<0 s afterLeaveSecond=""
							.....s doseQty=$p($g(^OEORD(oeordId,"I",+oeoriSub,2)),"^",1)
							.....s oriNote=$g(^OEORD(oeordId,"I",+oeoriSub,"DEP",1))
							.....s labEpisodeNo=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",20)
							.....s specSub=$o(^OEORD(oeordId,"I",oeoriSub,"SPEC",0))
							.....s specDesc=""
							.....i specSub>0 d
								......s specCode=$p($g(^OEORD(oeordId,"I",oeoriSub,"SPEC",+specSub)),"^",1) 
								......s specDesc=$p($g(^TTAB("SPEC",specCode)),"\",1)
							.....s oeoreSub=0
							.....f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:(oeoreSub="")  d
								......q:'$g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub))								
								......s exStDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",1)
								......s exStTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",2)								
								......//q:(findToDate'="")&&(exStDate>findToDate)
								......s exeDateTime=""
								......i oecprType="Y" s exeDateTime=$zd(exStDate,3)_" "_$zt(exStTime)
								......s phQtyOrd=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",5)
								......s count=count+1
								......s ^DHCICUDebug(count)=icuaId_"^"_arcimCode_"^"_arcimDesc_"^"_startDateTime_"^"_leaveDateTime_"^"_$zd(oeoriSttDat,3)_" "_$zt(oeoriSttTim)_"^"_oriNote_"^"_doseQty_"^"_beforeStartSecond_"^"_afterLeaveSecond_"^"_exeDateTime_"^"_labEpisodeNo_"^"_specDesc_"^"_oeoriXDateTime
								......s Data=$lb(icuaId,arcimCode,arcimDesc,startDateTime,leaveDateTime,$zd(oeoriSttDat,3)_" "_$zt(oeoriSttTim),oriNote,doseQty,beforeStartSecond,afterLeaveSecond,exeDateTime,labEpisodeNo,specDesc,oeoriXDateTime)
								......d OutputRowDetail
	i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3)="R" d
		.s icucriCode=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)
		.q:icucriCode=""
		.s icucriIdStr=##class(web.DHCICUCom).GetIcuriIdByCode(icucriCode)
		.f i=1:1:$l(icucriIdStr,"^") d
			..s icucriId=$p(icucriIdStr,"^",i)
			..q:icucriId=""
			..s icucriCode=$p($g(^DHCICUC("RecordItem",icucriId)),"^",1)
			..s icucriDesc=$p($g(^DHCICUC("RecordItem",icucriId)),"^",2)
			..w icucriId_"/"_icucriCode,"/"_icucriDesc,!
			..i (needIcuaId'="")&($d(^DHCICUInquiry($j,icuciId))<10) d
				...s ^DHCICUInquiry(icuciId,0)=""
			..s icuaId="",ifQuit=0
			..f  s icuaId=$o(^DHCICUInquiry(icuciId,icuaId)) q:(icuaId="")!(ifQuit)  d
				...i (needIcuaId'="") d
					....s icuaId=needIcuaId,ifQuit=1
				...q:+icuaId=0
				...q:'$d(^DHCICUArrange(icuaId))
				...s icuaStartDate=$p(^DHCICUArrange(icuaId),"^",6)
				...s icuaStartTime=$p(^DHCICUArrange(icuaId),"^",8)
				...s icuaLeaveDate=$p($g(^DHCICUArrange(icuaId)),"^",44)
				...s icuaLeaveTime=$p($g(^DHCICUArrange(icuaId)),"^",45)
				...s startDateTime=$zd(icuaStartDate,3)_" "_$zt(icuaStartTime)
				...s leaveDateTime=""
				...i icuaLeaveDate'="" s leaveDateTime=$zd(icuaLeaveDate,3)_" "_$zt(icuaLeaveTime)
				...s findFromDate=icuaStartDate-1000
				...//i (fromDate'="")&(fromDate>icuaStartDate) s findFromDate=fromDate
				...i (fromDate'="") s findFromDate=fromDate
				...s findToDate=icuaLeaveDate
				...i findToDate="" s findToDate=+$h
				...s findToDate=findToDate+1000
				...//i (toDate'="")&(toDate<findToDate) s findToDate=toDate
				...i (toDate'="") s findToDate=toDate
				...w findFromDate,"/"_findToDate,!
				...w icuaId,!
				...f date=findFromDate:1:findToDate d
					....s time=""
					....f  s time=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time)) q:(time="")  d
						.....//q:(date=fromDate)&(time<fromTime)
						.....//q:(date=toDate)&(time>toTime)
						.....s icuoId=""
						.....f  s icuoId=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time,icuoId)) q:(icuoId="")  d
							......q:'$d(^DHCICUOrder(icuoId))
							......q:"ICD"[$p(^DHCICUOrder(icuoId),"^",25)
							......s note=$p(^DHCICUOrder(icuoId),"^",10)
							......s qty=##class(web.DHCICUOrder).GetRecordValueSingle(icuoId,"")  //$p(^DHCICUOrder(icuoId),"^",11)
							......s itemDesc=icucriDesc
							......s icupiId=$p(^DHCICUOrder(icuoId),"^",38)
							......s icupiSub=$p(icupiId,"||",2)
							......i icupiSub'="" d
								.......s mainIcupiId=$p(^DHCICUPara(+icupiId,"I",+icupiSub),"^",19)
								.......s mainIcupiSub=$p(mainIcupiId,"||",2)
								.......s itemDesc=itemDesc_"("_$p(^DHCICUPara(+mainIcupiId,"I",+mainIcupiSub),"^",14)_")"_icupiId
							......s icupiCode=$p(^DHCICUPara(+icupiId,"I",+icupiSub),"^",13)
							......s oeoriNote=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),14)
							......s ifIncluded=0
							......i (oeoriNote'="") d
								.......f oeoriNoteI=1:1:$l(oeoriNote,"^") d
									........i (","_icupiCode_",")[(","_$p(oeoriNote,"^",oeoriNoteI)_",") s ifIncluded=1
									........w icupiCode,"/"_$p(oeoriNote,"^",oeoriNoteI)_"/"_ifIncluded,!
							......q:(oeoriNote'="")&('ifIncluded)
							......s beforeStartSecond=##class(web.DHCClinicCom).CalculateDuration(icuaStartDate,icuaStartTime,date,time)
							......i beforeStartSecond>0 s beforeStartSecond=""
							......s afterLeaveSecond=""
							......i icuaLeaveDate'="" d
								.......s afterLeaveSecond=##class(web.DHCClinicCom).CalculateDuration(icuaLeaveDate,icuaLeaveTime,date,time)
								.......i afterLeaveSecond<0 s afterLeaveSecond=""
							......s exeDateTime="",labEpisodeNo="",specDesc="",oeoriXDateTime=""
							......s count=count+1
							......s ^DHCICUDebug(count)=icuaId_"^"_icucriCode_"^"_itemDesc_"^"_startDateTime_"^"_leaveDateTime_"^"_$zd(date,3)_" "_$zt(time)_"^"_note_"^"_qty_"^"_beforeStartSecond_"^"_afterLeaveSecond_"^"_exeDateTime_"^"_labEpisodeNo_"^"_specDesc_"^"_oeoriXDateTime
							......s Data=$lb(icuaId,icucriCode,icucriDesc,startDateTime,leaveDateTime,$zd(date,3)_" "_$zt(time),note,qty,beforeStartSecond,afterLeaveSecond,exeDateTime,labEpisodeN,specDesc,oeoriXDateTime)
							......d OutputRowDetail
	i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3)="L" d
		.s testCodeList=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)
		.q:testCodeList=""
		.f j=1:1:$l(testCodeList,"^")  d
			..s testCodeNL=$p(testCodeList,"^",j)
			..q:testCodeNL=""
			..//s testDesc=$p($g(^TTAB("TC",testCode)),"\",1)
			..i (needIcuaId'="")&($d(^DHCICUInquiry($j,icuciId))<10) d
				...s ^DHCICUInquiry(icuciId,0)=""
			..s note=""
			..s icuaId="",ifQuit=0
			..f  s icuaId=$o(^DHCICUInquiry(icuciId,icuaId)) q:(icuaId="")!(ifQuit)  d
				...i (needIcuaId'="") d
					....s icuaId=needIcuaId,ifQuit=1
				...q:+icuaId=0
				...q:'$d(^DHCICUArrange(icuaId))
				...s icuaStartDate=$p(^DHCICUArrange(icuaId),"^",6)
				...s icuaStartTime=$p(^DHCICUArrange(icuaId),"^",8)
				...s icuaLeaveDate=$p($g(^DHCICUArrange(icuaId)),"^",44)
				...s icuaLeaveTime=$p($g(^DHCICUArrange(icuaId)),"^",45)
				...s startDateTime=$zd(icuaStartDate,3)_" "_$zt(icuaStartTime)
				...s leaveDateTime=""
				...i icuaLeaveDate'="" s leaveDateTime=$zd(icuaLeaveDate,3)_" "_$zt(icuaLeaveTime)
				...s findFromDate=icuaStartDate-1000
				...//i (fromDate'="")&(fromDate>icuaStartDate) s findFromDate=fromDate
				...i (fromDate'="") s findFromDate=fromDate
				...s findToDate=icuaLeaveDate
				...i findToDate="" s findToDate=+$h
				...s findToDate=findToDate+1000
				...//i (toDate'="")&(toDate<findToDate) s findToDate=toDate
				...i (toDate'="") s findToDate=toDate
				...w icuaId,!
				...s EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
				...//w findFromDate,"/"_findToDate,!
				...s resultStr=##class(web.DHCClinicCom).GetTestResult(EpisodeID, "", "", testCodeNL, findFromDate, 0, findToDate, "23:59:59")
				...f i=1:1:$l(resultStr,"^") d
					....s singleResult=$p(resultStr,"^",i)
					....q:singleResult=""
					....s qty=$p(singleResult,"\",1)
					....//s note=$p(^DHCICUOrder(icuoId),"^",10)
					....s receivedDate=$p(singleResult,"\",4)
					....s receivedTime=$p(singleResult,"\",5)
					....s testCode=$p(singleResult,"\",7)
					....s testDesc=$p($g(^TTAB("TC",testCode)),"\",1)
					....s labEpisodeNo=$p(singleResult,"\",9)
					....s speciDesc=$p(singleResult,"\",10)
					....s beforeStartSecond=##class(web.DHCClinicCom).CalculateDuration(icuaStartDate,icuaStartTime,receivedDate,receivedTime)
					....i beforeStartSecond>0 s beforeStartSecond=""
					....s exeDateTime="",afterLeaveSecond=""
					....i icuaLeaveDate'="" d
						.....s afterLeaveSecond=##class(web.DHCClinicCom).CalculateDuration(icuaLeaveDate,icuaLeaveTime,receivedDate,receivedTime)
						.....i afterLeaveSecond<0 s afterLeaveSecond=""
					....s count=count+1
					....s ^DHCICUDebug(count)=icuaId_"^"_testCode_"^"_testDesc_"^"_startDateTime_"^"_leaveDateTime_"^"_$zd(receivedDate,3)_" "_$zt(receivedTime)_"^"_note_"^"_qty_"^"_beforeStartSecond_"^"_afterLeaveSecond_"^^"_labEpisodeNo_"^"_speciDesc_"^"_oeoriXDateTime
					....s Data=$lb(icuaId,testCode,testDesc,startDateTime,leaveDateTime,$zd(receivedDate,3)_" "_$zt(receivedTime),note,qty,beforeStartSecond,afterLeaveSecond,exeDateTime,labEpisodeNo,speciDesc,oeoriXDateTime)
	                ....d OutputRowDetail
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowDetail
	//set Data=$lb(tWardDesc,tBedCode,tRegNo,tPatName,tDate,tTime,tCheckDesc,tCheckStatus,icuaId)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindICUInquiryDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUInquiryDetailExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {	
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindICUInquiryDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUInquiryDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// w ##class(web.DHCICUStatTEST).AutoInsertBRJBPFHZ(1,15000,88)

ClassMethod AutoInsertBRJBPFHZ(starticuaid As %String, endicuaid As %String, ctloc As %String) As %String
{
    s icuciId=17,icuciiSub=""
    k ^TEMPWHL("AutoInsertBRJBPFHZ")
	f icuaId=starticuaid:1:endicuaid d
	     .q:'$d(^DHCICUArrange(icuaId))
	     .s icuBedId=$p($g(^DHCICUArrange(icuaId)),"^",4)
	     .s ctlocId=$p(^PAWARD(+icuBedId),"^",5)
	     .q:ctloc'=ctlocId
	     .f  s icuciiSub=$o(^DHCICUCInquiry(icuciId,"I",icuciiSub)) q:icuciiSub=""  d
	     ..s desc=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),2)
		 ..s value=##class(web.DHCICUStat).StatIcuArrangeSingle(icuaId,desc)
		 ..;b ;"value"
		 ..q:value=""
		 ..q:value=0
		 ..w icuaId_"%"_desc_"%"_value,!
		 ..i desc="NoninvasiveVentilatorHour" s $p(^DHCICUArrange(+icuaId),"^",48)=value q ;"无创呼吸机";无创呼吸机（小时）
		 ..i desc="InvasiveVentilatorHour" s $p(^DHCICUArrange(+icuaId),"^",47)=value q ;有创呼吸机（小时）
	     ..i desc="PronePositionDayTimes" s $p(^DHCICUArrange(+icuaId),"^",78)=value q ;有俯卧位（天）
	     ..i desc="CRRTHour" s $p(^DHCICUArrange(+icuaId),"^",52)=value q ;CRRT（小时）
	     ..i desc="NEHour" s $p(^DHCICUArrange(+icuaId),"^",82)=value q ;去甲肾上腺素（小时）
	     ..i desc="EpiHour" s $p(^DHCICUArrange(+icuaId),"^",83)=value q ;肾上腺素（小时）
	     ..i desc="DAHour" s $p(^DHCICUArrange(+icuaId),"^",84)=value q ;多巴胺（小时）
	     ..i desc="DobuHour" s $p(^DHCICUArrange(+icuaId),"^",85)=value q ;多巴酚丁胺（小时）
		 ..s ^TEMPWHL("AutoInsertBRJBPFHZ",icuaId,desc)=value
 	q:""
}

}
