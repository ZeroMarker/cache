Import SQLUser

Class web.DHCICUStatMerge Extends %RegisteredObject
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
	..b ;01
	..q:(^DHCICUInquiry(ICUCIRowid,icirowid)="")
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
	.i (("^"_$p(type,"~",2)_"^")[("^"_"SPOAepinephrine1."_(i)_"^")) s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,"DetailDosePump",theDay,"8:00",theDay,"8:00","First","","",oeoriNote,"") //肾上腺素
	.i (("^"_$p(type,"~",2)_"^")[("^"_"SOFANoradrenaline1."_(i)_"^")) s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,"DetailDosePump",theDay,"8:00",theDay,"8:00","First","","",oeoriNote,"") //去甲肾	
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
 	.i (("^"_$p(type,"~",2)_"^")[("^"_"SirsStandard1."_(i)_"^")) d
 	..s value=##class(web.DHCICUStat).JudgeSirsStandard(icuaId,theDay,"0:00",theDay,"23:59:59") //符合SIRS标准
 	..i value=1 s value="是"
 	..e  s value="否"
 	.i (("^"_$p(type,"~",2)_"^")[("^"_"SepsisStandard1."_(i)_"^")) d
 	..s value=##class(web.DHCICUStat).getVasoactiveAgents(icuaId,"AntimicrobialAgents",theDay,theDay) //符合Sepsis标准
 	..i value=1 s value="是"
 	..e  s value="否"
 	.i (("^"_$p(type,"~",2)_"^")[("^"_"SevereSepsisStandard1."_(i)_"^")) d
 	..s value=##class(web.DHCICUStat).JudgeSevereSepsisStandard(icuaId,theDay,"0:00",theDay,"23:59") //符合SevereSepsis标准
 	..i value=1 s value="是"
 	..e  s value="否"
 	.i (("^"_$p(type,"~",2)_"^")[("^"_"SepticShockStandard1."_(i)_"^")) d
 	..s value=##class(web.DHCICUStat).getVasoactiveAgents(icuaId,"VasoactiveAgents",theDay,theDay) //符合SepticShock标准
 	..i value=1 s value="是"
 	..e  s value="否" 	
	.i value'="" s ifValue="1"
	q value_"/"_ifValue
}

ClassMethod GetInfoByIcuaId(icuaId, type, needNote = "", durationHour = "", fdate = "", tdate = "", oeoriNote = "")
{
	// w ##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,type)
	s value="",formWard="",Amountfdate="",Amounttdate="",AmountInpatients=""
	
	s Amountfdate=$zd(fdate,3)
	s Amounttdate=$zd(tdate,3)
	
    ;s value= AmountInpatients
	;i type="AmountInpatients" b ;"AmountInpatients"
	;q:(type="AmountInpatients") AmountInpatients b ;"AmountInpatients"
	q:(type="HospitalDay") ##class(web.DHCICUStat).GetMRIPData(fdate,tdate)
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
	
	i type="AmountInpatients"  s value=$$GetRYRS^DHCWLBuildKPIData(Amountfdate,Amounttdate)
	
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
	.s value=..GetInWardInfoByIcuaId(icuaId,type,inDate,inTime,outDate,outTime,oeoriNote)
	.s value=$p(value,"/",1)
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
	.i $p($g(^DHCICUArrange(icuaId)),"^",43)="D" s value="是"
	.e  s value="否"  
	i type="autoLeave" d
	.i $p($g(^DHCICUArrange(icuaId)),"^",43)="A" s value="是"
	.e  s value="否"
	.;e  i $p($g(^DHCICUArrange(icuaId)),"^",43)="" s value=$p(^PAPER(papmiId,"ALL"),"^",12)
	i type="icuInDateTime" s value=$zd(inDate,3)_" "_$zt(inTime,2)
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
	i type="ApacheTotalScore" s value=$p($g(^DHCICUArrange(+icuaId)),"^",40) //ApacheTotalScore
	
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
				
	q value
}

/// w ##class(web.DHCICUStatMerge).FindIcuInquiry("56^2166",2)
/// w ##class(web.DHCICUStatMerge).FindIcuInquiry("39",6,"2014-8-1","2014-8-31","I")
/// w ##class(web.DHCICUStatMerge).FindIcuInquiry("28",15,"2015-5-1","2015-5-2","I")
/// w ##class(web.DHCICUStatMerge).FindIcuInquiry("28",42,"2015-9-5","2015-9-11","I")
/// I:入病区时间,空为在病区时间
ClassMethod FindIcuInquiry(ctlocIdStr, icuciId, inquiryFromDate, inquiryToDate, dateForWardType = "", needIcuaId = "", needIcuciiSub = "")
{
	k ^DHCICUDebug
	k ^DHCICUInquiryMainNurse
	
	s curWardLocId=$lg(^DHCICUCInquiry(icuciId),3)
	
    k ^DHCICUInquiryInOutHospital
	k ^DHCICUInquiry("userId")
	k ^DHCICUInquiry(+icuciId)
	k ^TEMPWHL("LabEpisodeNo")
	k ^TEMPDHCICUInquiryWHL
	k ^DHCICUInquiryJXKH
	q:icuciId="" -11
	k ^DHCICUInquiry(+icuciId),^DHCICUInquiry(icuciId,"F")
	s sumStr="",orderCategory=""
	s ^DHCICUCInquiry(+icuciId,"count")=0
	s leaveCount=0,leaveDayPos=0,CirculVelocityPos=0,ScorePos=0,ScoreCount=0 //计算APPCHEII平均分数数量
	i $d(^DHCICUPara(0,"Ctloc",ctlocIdStr)) d	
		.;若在科室模板中已配置
		.s retStr=$$FindIcuInquiryByWardId(ctlocIdStr,icuciId,inquiryFromDate,inquiryToDate,dateForWardType)
	e  d
		.;科室模板中未配置,认为是科室,查找出相应病区
		.s sub=0,wardLocIdStr=""
		.f  s sub=$O(^CTLOC(ctlocIdStr,"LINK",sub)) q:sub=""  d
			..s wardLocId=^CTLOC(ctlocIdStr,"LINK",sub)
			..q:'$d(^DHCICUPara(0,"Ctloc",wardLocId))
			..i wardLocIdStr'="" s wardLocIdStr=wardLocIdStr_"^"
			..s wardLocIdStr=wardLocIdStr_wardLocId
		.w ctlocIdStr_"    main/"_inquiryFromDate_"/"_inquiryToDate,!
		.s retStr=$$FindIcuInquiryByWardId(wardLocIdStr,icuciId,inquiryFromDate,inquiryToDate,dateForWardType)
		.w "retStr="_retStr,!
	i sumStr'="" d
		.//s count=^DHCICUCInquiry(+icuciId,"count")+1
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
			..i "^Percent^Multiply^"[("^"_$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),24)_"^") d
				...s delimter="*"
				...i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),24)="Percent" s delimter="/"
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
				...i (icuciiSub=14)||(icuciiSub=15)||(icuciiSub=16) s value=value*10
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
	m ^DHCICUDebug=^DHCICUInquiry(icuciId) //temp
	m ^DHCICUDebug(1)=^DHCICUInquiry(icuciId,0) //temp
	q 0

FindIcuInquiryByWardId(ctlocIdStr, icuciId, inquiryFromDate, inquiryToDate, dateForWardType = "")
	s preDT=$h
	q:ctlocIdStr="" -1
	q:icuciId="" -2
	s pos=0,titleStr=""
	k posList
	//s icuciIsByDate=$lg(^DHCICUCInquiry(icuciId),9)
	//i 'icuciIsByDate s inquiryFromDate="",inquiryToDate="" //!!!!日期是否生效
	w ctlocIdStr_"    first/"_inquiryFromDate_"/"_inquiryToDate,!
	s inquiryFromDate=##class(web.DHCClinicCom).ConvertToDateH(inquiryFromDate)
	s inquiryToDate=##class(web.DHCClinicCom).ConvertToDateH(inquiryToDate)
	w ctlocIdStr_"    second/"_inquiryFromDate_"/"_inquiryToDate,!
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
	
	s icuciiSub=0,mainClusteringSub=""
	f  s icuciiSub=$o(^DHCICUCInquiry(icuciId,"I",icuciiSub)) q:icuciiSub=""  d
		.i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),4)=1 d //查找项
			..//q:$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),21)="" //没有等级，默认0!!!!
			..s searchList(+$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),21),icuciiSub)=""
		.e  d
			..s searchList((10000+icuciiSub),icuciiSub)="" //tobe 
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
			..;w icuciodCode_","_dataField_","_needNote_oeoriNote_","_refValue_"/"_posList(icuciodCode_","_dataField_","_needNote_oeoriNote_","_refValue),!
			..i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)="LeaveDay" s leaveDayPos=pos //平均住院日
			..i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)="CirculVelocity" s CirculVelocityPos=pos
	k tmpPosList
	s ^DHCICUInquiry(icuciId,0)=titleStr
	w inquiryFromDate_" "_inquiryToDate,!
	s wardIdStr=""
	f i=1:1:$l(ctlocIdStr,"^") d
		.s ctlocId=$p(ctlocIdStr,"^",i)
		.q:ctlocId=""
		.s wardId=$o(^PAWARD(0,"WARD_LocationDR",ctlocId,0))
		.q:wardId=""
		.i wardIdStr'="" s wardIdStr=wardIdStr_"^"
		.s wardIdStr=wardIdStr_wardId
	s icuStr="",icuaSeq=0,searchLevel=1
	s count=^DHCICUCInquiry(+icuciId,"count")
	s retstr=$$FindICUArrange(wardIdStr, icuciId, inquiryFromDate, inquiryToDate, dateForWardType,icuaSearch)
	;e  s retstr=$$FindUserTotal(wardIdStr, icuciId, inquiryFromDate, inquiryToDate, dateForWardType,icuaSearch)
	q retstr
FindICUArrange(wardIdStr, icuciId, inquiryFromDate, inquiryToDate,dateForWardType = "",icuaSearch="")
	w "FindICUArr  inquiryFromDate="_inquiryFromDate," inquiryToDate="_inquiryToDate," dateForWardType="_dateForWardType," icuaSearch="_icuaSearch,!
	///s ^mfcTemp(icuciId)="FindICUArr  inquiryFromDate="_inquiryFromDate_" inquiryToDate="_inquiryToDate_" dateForWardType="_dateForWardType_" icuaSearch="_icuaSearch
	s count=..InitIcuaSearch(wardIdStr, icuciId, inquiryFromDate, inquiryToDate, dateForWardType, icuaSearch, needIcuaId)
	s count=0
		
	w "FindICUArr begin output  inquiryFromDate="_inquiryFromDate," inquiryToDate="_inquiryToDate,!
	s ifDebug=1
	
	s icuciDataType=$lg(^DHCICUCInquiry(icuciId),10)
	///查找项和显示项，输出
	s icuaSeq=0,tmpCount=0,maxToTime="23:59:59"
	f  s icuaSeq=$o(^DHCICUInquiry(icuciId,"F",icuaSeq)) q:icuaSeq=""  d
		.s icuaId=icuaSeq //^DHCICUInquiry(icuciId,"F",icuaSeq)
		.s needExactDate="",needExactTime=""
		.i icuaId'=+icuaId d
			..s icuaId=+icuaId
			..s needExactDate=$p(icuaSeq,",",2)
			..s needExactTime=$p(icuaSeq,",",3)
		.w "icuaId="_icuaId_"/"_needExactDate,"/"_needExactTime,!
		.s ^DHCICUCInquiry(+icuciId,"icuaId",icuaId)=icuaId
		.s value=$p(^DHCICUArrange(icuaId),"^",43) //转科状态
		.s EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
		.;s ICUAChargeNurseCTCPdr=$p($p(##class(web.DHCICUArrange).GetMainNurse(EpisodeID),"^",1),"!",1) //主管护士1
		.;i ICUAChargeNurseCTCPdr'="" s ICUAChargeNurseDr=$o(^SSU("SSUSR",0,"CTPCP",ICUAChargeNurseCTCPdr,""))	
		.s ICUAChargeNurseDr=$p(^DHCICUArrange(icuaId),"^",60)	
		.i ICUAChargeNurseDr'="" s ^DHCICUInquiryInOutHospital(+icuciId,"InHospital",ICUAChargeNurseDr)=+$g(^DHCICUInquiryInOutHospital(+icuciId,"InHospital",ICUAChargeNurseDr))+1   //主管护士1收治病人数
	    .i ICUAChargeNurseDr'="" s ^DHCICUInquiryMainNurse(icuciId,ICUAChargeNurseDr)=""
        .s value=$p(^DHCICUArrange(icuaId),"^",43) //转科状态
	    .i ICUAChargeNurseDr'="" s OutHospital=$g(^DHCICUInquiryInOutHospital(+icuciId,"OutHospital",ICUAChargeNurseDr))
	    .i (ICUAChargeNurseDr'="")&&(value'="")&&("AT"[value) s ^DHCICUInquiryInOutHospital(+icuciId,"OutHospital",ICUAChargeNurseDr)=OutHospital+1   //出院及转科数目
	    .i ICUAChargeNurseDr'="" s ^DHCICUInquiryInOutHospital(+icuciId,"icuaId",ICUAChargeNurseDr,icuaId)=""



		
		.;s ICUAChargeNurseCTCPdr2=$p($p(##class(web.DHCICUArrange).GetMainNurse(EpisodeID),"^",2),"!",1) //主管护士2
		.;i ICUAChargeNurseCTCPdr2'="" s ICUAChargeNurseDr2=$o(^SSU("SSUSR",0,"CTPCP",ICUAChargeNurseCTCPdr2,""))
		.s ICUAChargeNurseDr2=$p(^DHCICUArrange(icuaId),"^",61)
		.i ICUAChargeNurseDr2'="" s ^DHCICUInquiryInOutHospital(+icuciId,"InHospital2",ICUAChargeNurseDr2)=+$g(^DHCICUInquiryInOutHospital(+icuciId,"InHospital2",ICUAChargeNurseDr2))+1   //主管护士2收治病人数
	    .i ICUAChargeNurseDr2'="" s ^DHCICUInquiryMainNurse(icuciId,ICUAChargeNurseDr2)=""
        .i ICUAChargeNurseDr2'="" s OutHospital2=$g(^DHCICUInquiryInOutHospital(+icuciId,"OutHospital2",ICUAChargeNurseDr2))
	    .i (ICUAChargeNurseDr2'="")&&(value'="")&&("AT"[value) s ^DHCICUInquiryInOutHospital(+icuciId,"OutHospital2",ICUAChargeNurseDr2)=OutHospital2+1   //出院及转科数目
	    .i ICUAChargeNurseDr2'="" s ^DHCICUInquiryInOutHospital(+icuciId,"icuaId",ICUAChargeNurseDr2,icuaId)=""




	   
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
		.//w "in,out DateTime="_inDateTime_"/"_outDateTime,!
		.s icuStr=""
		.s icuciiSub=0		
		.s searchLevel="",ifQuitSearch=0
		.f  s searchLevel=$o(searchList(searchLevel)) q:(searchLevel="")!(ifQuitSearch)  d
			..f  s icuciiSub=$o(searchList(searchLevel,icuciiSub)) q:(icuciiSub="")!(ifQuitSearch)  d //查找项筛选
				...q:(needIcuciiSub'="")&(needIcuciiSub'=icuciiSub)
				...s posCode=..GetIcuciPosCode(icuciId,icuciiSub)
				...s startDate=inDate,startTime=inTime
				...s durationHour=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),13)
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
				...s fromTime=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),15)
				...s toTime=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),16)
				...s exactTime=##class(web.DHCClinicCom).ConvertToTimeH($lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),17),"")
				...s curFromDate=inquiryFromDate
				...s curFromTime=0
				...s curToDate=inquiryToDate
				...s curToTime=maxToTime
				...i fromTime'="" d
					....i toTime="" s toTime=fromTime
					....i needExactDate'="" d
						.....s dateTimeStr=##class(web.DHCClinicCom).DateTimeAdd(needExactDate,needExactTime,-fromTime)
						.....s curFromDate=$p(dateTimeStr,"^",1),curFromTime=$p(dateTimeStr,"^",2)
						.....s dateTimeStr=##class(web.DHCClinicCom).DateTimeAdd(needExactDate,needExactTime,toTime)
						.....s curToDate=$p(dateTimeStr,"^",1),curToTime=$p(dateTimeStr,"^",2)
				...s fromDate=startDate,toDate=endDate
				...i ((fromDate'="")&(toTime'="")) d
					....i startTime>fromTime d
						.....s fromDate=fromDate+1,toDate=fromDate
						.....i (toDate>outDate) s toDate=outDate
						.....i (toDate=outDate)&(toTime>outTime) s toTime=outTime
					....e  d
						.....s toDate=fromDate
				...e  d
					....s fromTime=startTime
					....s toTime=endTime
				...s icuciodCode=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)
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
				...
				...s mainIcuciiIdStr=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),27) //关联主项
				...s mainItemCount=0
				...i mainIcuciiIdStr'="" d
					....f mainIcuciiIdIndex=1:1:$l(mainIcuciiIdStr,"^") d
						.....s mainIcuciiId=$p(mainIcuciiIdStr,"^",mainIcuciiIdIndex)
						.....s mainIcuciiSub=$p(mainIcuciiId,"||",2)
						.....s mainPosCode=0
						.....
						.....q:mainIcuciiSub=""
						.....s mainPosCode=..GetIcuciPosCode(icuciId,mainIcuciiSub)
						.....i $p(icuStr,"^",$g(posList(mainPosCode)))'="" s mainItemCount=mainItemCount+1
						.....w mainPosCode_"/"_$g(posList(mainPosCode)),"/"_$g(posList(mainPosCode)),"/"_icuStr,!
				...//i icuciiSub=30 w $p(icuStr,"^",$g(posList(mainPosCode))) b
				...q:(mainIcuciiIdStr'="")&(mainItemCount<1) //主项为空则不向下找
				...
				...s typeCat=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),31) //类别主项
				...s specCode=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),32) //标本代码
				...//i typeCat'="" w typeCat,! b
				...s value="",searchVal=""
				...//b
				...i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3)="O" d
				   
					....s isFind=0,times=""
					....s arcimId=""
					....f  s arcimId=$o(^OEORDi(0,"ARCIM",oeordId,arcimId)) q:(arcimId="")!(isFind)  d
						.....q:(typeCat="")&(("^"_icuciodCode_"^")'[("^"_arcimId_"^"))
						.....//w icuciiSub_"   /"_arcimId,"/"_typeCat_"/"_icuciodCode,! b
						.....s phcPoisonCode=""
						.....i typeCat="Poison" d
							......s phcPoisonCode=##class(web.DHCClinicCom).GetPHCPoisonCode(arcimId)
						.....//i phcPoisonCode'="" w phcPoisonCode,! b
						.....q:(typeCat="Poison")&(("^"_icuciodCode_"^")'[("^"_phcPoisonCode_"^"))
						.....s oeoriSttDate="",ArcimDesc=""
						.....s oeoriSttDate=inquiryFromDate-1
						.....f  s oeoriSttDate=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,oeoriSttDate)) q:(oeoriSttDate="")!(isFind)  d
							......i (oeoriSttDate>inquiryToDate) s oeoriSttDate=$h+10000 //退出
							......s oeoriSub=""
							......f  s oeoriSub=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,oeoriSttDate,oeoriSub)) q:(oeoriSub="")!(isFind)  d
								.......q:'$d(^OEORD(oeordId,"I",oeoriSub))
								.......s oeoriId=oeordId_"||"_oeoriSub
								.......s oecprCode="",oecprType=""
								.......s oecprId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",8)								
								.......i oecprId>0 s oecprCode=$p($g(^OECPR(+oecprId)),"^",1) 
								.......i (oecprCode="S")!(oecprCode="OMST")!(oecprCode="OMCQZT") s oecprType="Y" //长期医嘱
								.......s ordStatCode=##Class(web.DHCClinicCom).GetOrdStatCode(oeoriId)
								.......q:("DIU"[ordStatCode)&&(oecprType'="Y")
								.......q:("IU"[ordStatCode)&&(oecprType="Y")
								.......//w $p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2),!
								.......q:$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",12)'=""
								.......s oeoriSttDat=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
								.......s oeoriSttTim=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
								.......s oeoriSttDateTime=oeoriSttDat+(oeoriSttTim/100000)
								.......q:oeoriSttDateTime<inDateTime
								.......q:oeoriSttDateTime>outDateTime
								.......s curSpecCode=""
								.......i specCode'="" d
									........s curSpecSub=$o(^OEORD(oeordId,"I",oeoriSub,"SPEC",0))
									........s curSpecCode=$p(^OEORD(oeordId,"I",oeoriSub,"SPEC",curSpecSub),"^",1)
								.......q:(specCode'="")&(specCode'=curSpecCode)
								.......i (dataField["Times")&&(dataField["DateTime") d //add 20140801显示次数和时间
								........s times=times+1 //$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",12)
								........s ArcimDesc=ArcimDesc_" "_$zd(oeoriSttDat,3)_" "_$zt(oeoriSttTim,2)
								........s value=times_"次日期,"_ArcimDesc_" "
								.......e  d
								........;i dataField'="Times" s isFind=1 
								........;e  s times=times+1 //$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",12)
								........i dataField'="DateTime" d  //获取医嘱名称 add mfc 20140609								
									.........i (dataField="NoteAndOriQty")||(dataField="OriQty")||(dataField="OriDecide") d //医嘱备注和剂量或者总剂量
										..........s oriNote=$g(^OEORD(oeordId,"I",+oeoriSub,"DEP",1))
										..........i oriNote="" s oriNote="未填写医嘱备注"
										..........s doseQty=$p($g(^OEORD(oeordId,"I",+oeoriSub,2)),"^",1)
										..........i doseQty="" d
										...........s ViewSuperCat="" ,ViewCat="",arcim=""
										...........f  s ViewSuperCat=$O(^DHCICUC("OrdMapping",ViewSuperCat)) q:(ViewSuperCat="")  d
										............f  s ViewCat=$O(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat)) q:(ViewCat="")  d								
										.............f  s arcim=$O(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)) q:(arcim="")  d
										..............q:arcim'=arcimId									
										..............s doseQty=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)),"^",5)																	
										..........;i dataField="Times" s times=times+1
										..........s times=times+1										
									.........e  d
										..........s oriNote=$g(^OEORD(oeordId,"I",+oeoriSub,"DEP",1))							
										..........q:(oeoriNote'="")&&((oriNote)'[(oeoriNote))
										..........s value=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",2)
										..........i (needNote'="")&&(value'="")&&(value=needNote) s value="是"							  													
										..........i dataField'="Times" s isFind=1
										..........e  s times=times+1
										..........;i (icuciId=25)&&(icuciiSub=46)&&(icuaId=6963) s ^MfcTemp("2011")=times
								........e  s value=$zd(oeoriSttDat,3) //获取医嘱时间 add mfc 20140609														
								........//w "         times="_value_":"_times,!
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
								........;q:(LevelIf'="")&&(LevelIf'="1") //多个主项目时，选择LevelIf为1的项目执行 
								.......i $g(^TmpICUOeoriSDt(icuaId,icuciiSub))="" s ^TmpICUOeoriSDt(icuaId,icuciiSub)=oeoriSttDat_" "_oeoriSttTim //;记录第一次时间
								.......e  i $p($g(^TmpICUOeoriSDt(icuaId,icuciiSub))," ",1)>oeoriSttDat	s ^TmpICUOeoriSDt(icuaId,icuciiSub)=oeoriSttDat_" "_oeoriSttTim
					....s searchVal=value
					....q:$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),5)'=1
					....s $p(icuStr,"^",posList(posCode))=value	
						
					....;i (icuciiSub="46")&(icuciId=45) b ;"35"			
					....i dataField="Times" d
						.....s $p(icuStr,"^",posList(posCode))=times
						.....;i sumType'="" s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),times)
					....q:times=0
					....i (icuciId=45)&(icuciiSub=46) s ^dhcwhltemp(icuaId)=times
					....i sumType'="" s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),times)
					
				...i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3)="R" d		//重症记录
					....q:'$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),5)
					....;i icuciiSub=4 b ;"i icuciiSub=1"
					....//q:$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),27)'="" //子项不在此处执行//temp!!!!
					....s i=0
					....s icucriCode=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)
					....;i icucriCode="ApacheTotalScore" b ;"ApacheTotalScore"
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
					....;i icucriCode="ApacheTotalScore" b ;"ApacheTotalScore1"
					....s value="",textValue=""
					....s ARCIMRowIdStr=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),29) ;包含对应医嘱项ID串^分隔
					....s orderNote=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),30) ;包含对应医嘱备注
					....s orderCategory=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),31) ;包含对应医嘱项显示大类^分隔
					....s itemcat=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),32) ;包含对应医嘱项显示大类^分隔
					....;i icucriCode="ApacheTotalScore" b ;"ApacheTotalScore3"
					....f i=1:1:$l(icucriIdStr,"^") d
						.....s icucriId=$p(icucriIdStr,"^",i)
						.....q:icucriId=""
						.....s returnValue=""
						.....s icucriDataField=$p($g(^DHCICUC("RecordItem",icucriId)),"^",24)
						.....i (icuciiStartDateTime'="InWardDateTime")&&(icuciiStartDateTime'="OutWardDateTime")&&(icuciiStartDateTime'="FindDateTime") d
							......;i icucriCode="ApacheTotalScore" b ;"ApacheTotalScore3"
							......w icuciiSub_"  -----------------"_dataField,!
							......;i icuciiSub=4 b ;"i icuciiSub=4"
							......i ($lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),15)'="U") d
								.......i "^DurationDay^DurationHour^Times^Rate^"'[("^"_dataField_"^") d  //非持续时间
									........w "searchLevel:"_searchLevel,!
									........s curType=dataField
									........i icucriCode="ApacheTotalScore" b ;"ApacheTotalScore61"
									........i (icuciDataType="D")&(searchLevel<2)&(dataField="DateTime") d
										.........s curType="All"														
									........s tmpRecordV=##class(web.DHCICUOrder).GetRecordValue(icuaId,icucriId,curFromDate,curFromTime,curToDate,curToTime,curType,"","",oeoriNote,"AddDateTime",refIcucriId,refValue,needNote)
									........;s ^dhctmpmfc(icuaId)=curFromDate_"/"_curFromTime_"/"_curToDate_"/"_curToTime_"/"_curType_"/"_dataField_"/"_needNote_"/"_value
									........//i ifDebug w value,icuaSeq
									........f k=1:1:$l(tmpRecordV,"#") d //整理显示数据和记录主项时间点
									.........s tmpRecordVAndDT=$p(tmpRecordV,"#",k)							
									.........s tmpRecordValue=$p(tmpRecordVAndDT,"~",1)
									.........s tmpRecordDT=$p(tmpRecordVAndDT,"~",2)
									.........i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),27)="" d
									..........i $g(^TmpICUOeoriSDt(icuaId,icuciiSub))="" s ^TmpICUOeoriSDt(icuaId,icuciiSub)=$p($g(tmpRecordDT)," ",1)_" "_$p($g(tmpRecordDT)," ",2) //;记录第一次时间
									..........e  i $p($g(^TmpICUOeoriSDt(icuaId,icuciiSub))," ",1)>$p(tmpRecordDT," ",1)	s ^TmpICUOeoriSDt(icuaId,icuciiSub)=$p($g(tmpRecordDT)," ",1)_" "_$p($g(tmpRecordDT)," ",2)
									.........i (curType="FirstDT")||(curType="MinDT")||(curType="MaxDT")||(curType="MinMaxDT") d
									..........i value="" s value=tmpRecordValue_"~"_tmpRecordDT
									..........e  s value=value_"#"_tmpRecordValue_"~"_tmpRecordDT
									.........e  d 
 				 					..........i value="" s value=tmpRecordValue
 				 					..........e  s value=value_"#"_tmpRecordValue 
 				 					
									........s returnValue=value									
									........i curType="All" d
										.........s curDateTime=""
										.........f  s curDateTime=$o(^TMPICU("RecordValue",$j,curDateTime)) q:curDateTime=""  d
											..........s ^DHCICUInquiry(icuciId,"F",icuaId_","_curDateTime)=""
										.........k ^TMPICU("RecordValue",$j)
										.........k ^DHCICUInquiry(icuciId,"F",icuaId)
								.......e  d //计算持续时间
									........w "cal duration",!
									........s fromIcucriId=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),22)
									........s toIcucriId=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),23)
									........;i (icuaId=5559) w icuaId_"&&"_icucriId_"&&"_inquiryFromDate_"&&"_0_"&&"_inquiryToDate
									........i (fromIcucriId'="")&(toIcucriId'="") d //根据置管和拔管时间计算相关值
										.........w icuaId_","_icucriId_","_inquiryFromDate_","_0_","_inquiryToDate_","_0_","_fromIcucriId_","_toIcucriId_","_outDateTime,!
										.........s durationStr=##class(web.DHCICUOrder).GetCatheterDuration(icuaId,icucriId,inquiryFromDate,0,inquiryToDate,maxToTime,fromIcucriId,toIcucriId,outDateTime)
										.........;i icuciiSub=45 w durationStr b
										.........//i durationStr>0 b 
										.........i ifDebug w "durationStr 1="_durationStr,"?"_icuaId_"/"_icucriId_"/"_inquiryFromDate_"/"_0_"/"_inquiryToDate_"/"_maxToTime_"/"_fromIcucriId_"/"_toIcucriId_"/"_outDateTime,!									
									........e  d
							     		.........w "value11="_$lg(^DHCICUCInquiry(icuciId),11),!
							     		.........i ($lg(^DHCICUCInquiry(icuciId),11)="R")||($lg(^DHCICUCInquiry(icuciId),11)="") d
											..........//i icucriCode="VDeviceName" s needNote=""
											..........s durationStr=##class(web.DHCICUOrder).GetRecordDuration(icuaId,icucriId,inquiryFromDate,0,inquiryToDate,maxToTime,minUnit,needNote,oeoriNote)
											..........w icucriCode_"/"_durationStr,!
										.........e  i ($lg(^DHCICUCInquiry(icuciId),11)="I") d //按照入病区时间或者当前查询时间获取
											..........w "In ward",!
											..........s durationStr=##class(web.DHCICUOrder).GetRecordDuration(icuaId,icucriId,$p($g(inDateTime),".",1),0,$p($g(outDateTime),".",1),maxToTime,minUnit,needNote,oeoriNote)
									........i minQty=15,dataField="Times" w minQty_"==============/"_value_"/"_maxQty_"/"_durationStr,!
									........i ifDebug w "durationStr out="_durationStr,!
									........//w dataField_"/in value "_value
									........i dataField="DurationDay" s value=value+$p(durationStr,"^",1),returnValue=$p(durationStr,"^",1)
									........i dataField="DurationHour" s value=value+$p(durationStr,"^",2),returnValue=$p(durationStr,"^",2)
									........i dataField="Times" s value=value+$p(durationStr,"^",4),returnValue=$p(durationStr,"^",4)
									........i (value="0") s value=""
									........i (returnValue="0") s returnValue=""
								.......q:value=""
								.......;i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),27)="" d
								........;s DateTimeValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,icucriId,curFromDate,curFromTime,curToDate,curToTime,curType,"","",oeoriNote,"AddDateTime","","",needNote)
								........;s DateTimeValue=$p($g(DateTimeValue),"#",1) //记录关联主项执行日期(自定义使用)
								........;s DateTimeValue=$p($g(DateTimeValue),"~",2)						
								........;i $g(^TmpICUOeoriSDt(icuaId,icuciiSub))="" s ^TmpICUOeoriSDt(icuaId,icuciiSub)=$p($g(DateTimeValue)," ",1)_" "_$p($g(DateTimeValue)," ",2) //;记录第一次时间
								........;e  i $p($g(^TmpICUOeoriSDt(icuaId,icuciiSub))," ",1)>$p(DateTimeValue," ",1)	s ^TmpICUOeoriSDt(icuaId,icuciiSub)=$p($g(DateTimeValue)," ",1)_" "_$p($g(DateTimeValue)," ",2)
								.......;i minQty=15,dataField="Times" w minQty_"==============/"_value_"/"_maxQty,!
								.......q:("^Qty^Volume^"[("^"_icucriDataField_"^"))&(((minQty'="")&&(value<minQty))!((maxQty'="")&&(value>maxQty)))
								.......//q:("^Qty^Volume^"[("^"_icucriDataField_"^"))&((value<minQty)!(value>maxQty))
								.......w needNote_"/"_value_"/"_icucriDataField,!		
								.......s searchVal=value
								.......;i icucriCode="CRBSI" b ;"CRBSI"
								.......q:$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),5)'=1							
								.......s $p(icuStr,"^",$g(posList(posCode)))=value
								.......i sumType'="" d
									........s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),returnValue)
							......e  d
						    	.......;w posCode,ARCIMRowIdStr,!
								.......s retstr=..GetRecordValueByUserID(icuaId,icucriId,inquiryFromDate,0,inquiryToDate+1,0,dataField,"","",oeoriNote,"","","","",posList(posCode),icuciId,ARCIMRowIdStr)
									    
					.....i ($lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),15)'="U") d
						......q:(icuciiStartDateTime'="InWardDateTime")&&(icuciiStartDateTime'="OutWardDateTime")&&(icuciiStartDateTime'="FindDateTime")		
						......s ^TEMPWHL("icuciId",icuciId,icucriId,icuaId)=posList(posCode)_"^"_posCode				
			       		......w icucriIdStr
						......i icuciiStartDateTime="InWardDateTime" d //入病区数据,结束时间应该根据配置数据走						
							.......s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,icucriId,inDate,inTime,inDate+1,inTime,dataField,"","",oeoriNote,"","","",needNote)
							.......//b ;r05
						......e  i icuciiStartDateTime="OutWardDateTime" d //出病区数据
							.......s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,icucriId,$p($g(outDateTime),".",1)-1,outTime,$p($g(outDateTime),".",1),outTime,dataField,"","",oeoriNote,"","","",needNote)
						......e  i icuciiStartDateTime="FindDateTime" d //查找日期数据 暂时未用
							.......s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,icucriId,inquiryFromDate,0,inquiryToDate,maxToTime,dataField,"","",oeoriNote,"","","",needNote)					
						......e  d	
							.......s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,icucriId,inDate,inTime,outDate,outTime,dataField,"","",oeoriNote,"","","",needNote)
							.......w "  null para:"_icuaId_","_icucriId_","_inDate_","_inTime_","_outDate_","_outTime_","_dataField,",,,",oeoriNote_","_dataField,!
						......i ifDebug w " last/"_value,!
						......//b "value1"
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
					.....e  d
						......w icuaId,icucriId,!
	                	......;w posCode,ARCIMRowIdStr,!
	                	......;i ARCIMRowIdStr'="" b ;"ARCIMRowIdStr"
						......s retstr=..GetRecordValueByUserID(icuaId,icucriId,inquiryFromDate,0,inquiryToDate+1,0,dataField,"","",oeoriNote,"","","","",posList(posCode),icuciId,ARCIMRowIdStr)
				...i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3)="L" d
					....s i=0,testQtyStr=""
					....s testCodeList=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)
					....s isSingle=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),7)
					....s minQty=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),8)
					....s maxQty=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),9)					
					....s findFromDateTime=inquiryFromDate+(0/100000)
					....s findToDateTime=inquiryToDate+(($zth(maxToTime,3))/100000)
					....s findFromDate=inquiryFromDate,findToDate=inquiryToDate
					....i (findFromDateTime<inDateTime) s findFromDate=inDate
					....i (findToDateTime>outDateTime) s findToDate=outDate
					....//w testCode_"    in/"_fromDate_"/"_fromTime_"/"_toDate_"/"_toTime,!
					....f j=1:1:$l(testCodeList,"^")  d
					.....s testCode=$p(testCodeList,"^",j)
					.....s tmpStr=##class(web.DHCClinicCom).GetTestResult("", regNo, "", testCode, findFromDate, "0", findToDate, maxToTime, isSingle,needNote,dataField)
					.....i icuaId=7396 w regNo,"/"_EpisodeID_"/"_tmpStr b
					.....;s tmpStr=##class(web.DHCClinicCom).GetTestResult("", regNo, "", testCode, fromDate, "0", toDate, "0", isSingle,needNote)		
					.....i testQtyStr="" s testQtyStr=tmpStr
					.....e  s testQtyStr=testQtyStr_"^"_tmpStr			
					....f z=1:1:$l(testQtyStr,"^")  d
					.....i value="" s value=$p($p(testQtyStr,"^",z),"\",1)
					.....e  s value=value_" "_$p($p(testQtyStr,"^",z),"\",1)
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
					....s typeName=icuciodCode
					....s value=..GetInfoByIcuaId(icuaId,typeName,needNote,durationHour,inquiryFromDate,inquiryToDate,oeoriNote)
					....i (icuciodCode="VAP")!(icuciodCode="CR-BSI")!(icuciodCode="CA-UTI") d
						.....s retHI=##class(DHCMed.NINFService.Service).GetInfTypeByAdm(EpisodeID) 
						.....q:icuciodCode'=$p(retHI,":")
						.....s hiDate=$p(retHI,":",2)
						.....q:hiDate=""
						.....s hiDate=##class(web.DHCClinicCom).ConvertToDateH(hiDate)
						.....q:(hiDate<inquiryFromDate)!(hiDate>inquiryToDate)
						.....s value=$p(retHI,":",2)
					....s inDate=$p($g(inDateTime),".",1) //获取入病区日期 add mfc 20140609
					....i (typeName="ICUCount")&&((inDate>=inquiryFromDate)&&(inDate<=inquiryToDate)) s tmpCount=tmpCount+1,value=tmpCount
					....e  i typeName="ICUCount" s value=" "
					....i typeName="LeaveDay",value'="" s leaveCount=leaveCount+1
					....q:(minQty'="")&(maxQty'="")&((value<minQty)!(value>maxQty))
					....s oeoriNote=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),14) //持续泵用
					....q:(needNote'="")&(("^"_needNote_"^")'[("^"_value_"^"))
					....;q:(needNote'="")&(typeName="ICUAShockType")&((","_value_",")'[(","_needNote_","))
					....s searchVal=value
					....i icuciiSub=4 w "value="_value,!	
					....q:$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),5)'=1
					....	
					....s $p(icuStr,"^",posList(posCode))=value
					....//i icuciiSub=4 b
					....w icuciodCode_","_dataField_","_needNote_oeoriNote_","_refValue_"/"_posList(posCode),!
					....;i typeName="AmountInpatients"  b ;"2222"
					....i sumType'="" s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),value)
					....;i needNote["EO" b ;p02
				...i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3)="D" d //医生
					....s docName=icuciodCode
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
				...i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3)="OLR" d //医嘱、检验、监护层层相扣获取			  
					....s typeName=icuciodCode	
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
				....s typeName=icuciodCode	
				....s findArcimDT="",findLabDesc="",findRecordV="",againArcimDT="",findLabDesc2="",value=""
				....s findLabDesc=$g(^TmpICUOeoriSDt(icuaId,$p($lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),27),"||",2)))
				....;i icuaId=8952 s ^dhctmpmfc(icuaId,icuciId,icuciiSub,$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),27))	=findLabDesc
				....s icuciiStartDateTime=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),12)	
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
						........s oeordPreDateTime=..getPreDateTime(oeordDate,oeordTime,"-",minQty)
						........s oeordPreDate=$p(oeordPreDateTime," ",1),oeordPreTime=$p(oeordPreDateTime," ",2)
						........s tmpRecAfterV=##class(web.DHCClinicCom).GetTestResult("", regNo, "", LabCode, oeordPreDate, oeordPreTime, oeordDate, oeordTime, isSingle,$p(needNote,"^",1))
						........s tmpMinIndex=1,tmpDateValue="",tmpTimeValue=""
						........i tmpRecAfterV'="" d				
  						.........f y=1:1:$l(tmpRecAfterV,"^") d
  						..........q:($p($p(tmpRecAfterV,"^",y),"\",1)="")
  						..........i (y=1) s tmpDateValue=$p($p(tmpRecAfterV,"^",y),"\",4),tmpTimeValue=$p($p(tmpRecAfterV,"^",y),"\",5)
  						..........s retVal= ##class(web.DHCClinicCom).CompareDateTime($p($p(tmpRecAfterV,"^",y),"\",4),$p($p(tmpRecAfterV,"^",y),"\",5),tmpDateValue,tmpTimeValue) //获取最小或者等于
  						..........i (retVal=1)||(retVal=0) s tmpMinIndex=y,tmpDateValue=$p($p(tmpRecAfterV,"^",y),"\",4),tmpTimeValue=$p($p(tmpRecAfterV,"^",y),"\",5)			 			
						........i tmpRecAfterV="" q
						........i findRecFormerV="" s findRecFormerV=$p($p(tmpRecAfterV,"^",tmpMinIndex),"\",1)
						........e  s findRecFormerV=findRecFormerV_" "_$p($p(tmpRecAfterV,"^",tmpMinIndex),"\",1)
						
					.......;
					.......i (minQty="")&&(maxQty'="") d //标本送检后小时数据(第一次)									
						........s oeordNowDateTime=..getPreDateTime(oeordDate,oeordTime,"+",maxQty)
						........s oeordNowDate=$p(oeordNowDateTime," ",1),oeordNowTime=$p(oeordNowDateTime," ",2)
						........s tmpRecAfterV=##class(web.DHCClinicCom).GetTestResult("", regNo, "", LabCode,  oeordDate, oeordTime,oeordNowDate, oeordNowTime, isSingle,$p(needNote,"^",1))
						........s tmpMinIndex=1,tmpDateValue="",tmpTimeValue=""
						........i tmpRecAfterV'="" d				
  						.........f y=1:1:$l(tmpRecAfterV,"^") d
  						..........q:($p($p(tmpRecAfterV,"^",y),"\",1)="")
  						..........i (y=1) s tmpDateValue=$p($p(tmpRecAfterV,"^",y),"\",4),tmpTimeValue=$p($p(tmpRecAfterV,"^",y),"\",5)
  						..........s retVal= ##class(web.DHCClinicCom).CompareDateTime($p($p(tmpRecAfterV,"^",y),"\",4),$p($p(tmpRecAfterV,"^",y),"\",5),tmpDateValue,tmpTimeValue)
  						..........i (retVal=-1)||(retVal=0) s tmpMinIndex=y,tmpDateValue=$p($p(tmpRecAfterV,"^",y),"\",4),tmpTimeValue=$p($p(tmpRecAfterV,"^",y),"\",5)			 			
						........i tmpRecAfterV="" q	
						........i findRecFormerV="" s findRecFormerV=$p($p(tmpRecAfterV,"^",tmpMinIndex),"\",1)
						........e  s findRecFormerV=findRecFormerV_" "_$p($p(tmpRecAfterV,"^",tmpMinIndex),"\",1)
					.......
					.......i (minQty'="")&&(maxQty'="") d //标本送检前后小时数据
 						........s tmpRecordV=""
 						........s oeordPreDateTime=..getPreDateTime(oeordDate,oeordTime,"-",minQty)					
						........s oeordPreDate=$p(oeordPreDateTime," ",1),oeordPreTime=$p(oeordPreDateTime," ",2)
						........s oeordNowDateTime=..getPreDateTime(oeordDate,oeordTime,"+",maxQty)
						........s oeordNowDate=$p(oeordNowDateTime," ",1),oeordNowTime=$p(oeordNowDateTime," ",2)					
						........s tmpRecAfterV=##class(web.DHCClinicCom).GetTestResult("", regNo, "", LabCode, oeordPreDate, oeordPreTime, oeordNowDate, oeordNowTime, isSingle,$p(needNote,"^",1))
  						........s tmpMinIndex=1,tmpDateValue="",tmpTimeValue=""
						........i tmpRecAfterV'="" d				
  						.........f y=1:1:$l(tmpRecAfterV,"^") d
  						..........q:($p($p(tmpRecAfterV,"^",y),"\",1)="")
  						..........i (y=1) s tmpDateValue=$p($p(tmpRecAfterV,"^",y),"\",4),tmpTimeValue=$p($p(tmpRecAfterV,"^",y),"\",5)
  						..........s retVal= ##class(web.DHCClinicCom).CompareDateTime($p($p(tmpRecAfterV,"^",y),"\",4),$p($p(tmpRecAfterV,"^",y),"\",5),tmpDateValue,tmpTimeValue)
  						..........i (retVal=1)||(retVal=0) s tmpMinIndex=y,tmpDateValue=$p($p(tmpRecAfterV,"^",y),"\",4),tmpTimeValue=$p($p(tmpRecAfterV,"^",y),"\",5)			 			
						.........i tmpRecAfterV="" q
						.........i findRecFormerV="" s findRecFormerV=$p($p(tmpRecAfterV,"^",tmpMinIndex),"\",1)
						.........e  s findRecFormerV=findRecFormerV_" "_$p($p(tmpRecAfterV,"^",tmpMinIndex),"\",1)
						........
						.......i findLabDesc2="" s findLabDesc2=findRecFormerV
 						.......e  s findLabDesc2=findLabDesc2_"@"_findRecFormerV 						
 				....i ($lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3)="R")&&(findLabDesc'="") d //监护数据 								
					.....;i icuaId=7653 	s ^dhctmpmfc(icuaId,icuciId,icuciiSub)=typeName
					.....b ;"R"
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
						........s oeordPreDateTime=..getPreDateTime(oeordDate,oeordTime,"-",minQty)
						........s oeordPreDate=$p(oeordPreDateTime," ",1),oeordPreTime=$p(oeordPreDateTime," ",2)
						........s tmpRecordV=##class(web.DHCICUOrder).GetRecordValue(icuaId,icucriId,oeordPreDate,oeordPreTime,oeordDate,oeordTime,dataField,"","",oeoriNote,"","","","")
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
						........s tmpRecordV=##class(web.DHCICUOrder).GetRecordValue(icuaId,icucriId,oeordDate,oeordTime,oeordNowDate,oeordNowTime,dataField,"","",oeoriNote,"AddDateTime","","","")
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
						........s oeordPreDateTime=..getPreDateTime(oeordDate,oeordTime,"-",minQty)
						........s oeordPreDate=$p(oeordPreDateTime," ",1),oeordPreTime=$p(oeordPreDateTime," ",2)
						........s oeordNowDateTime=..getPreDateTime(oeordDate,oeordTime,"+",maxQty)
						........s oeordNowDate=$p(oeordNowDateTime," ",1),oeordNowTime=$p(oeordNowDateTime," ",2)				
						........s tmpRecordV=##class(web.DHCICUOrder).GetRecordValue(icuaId,icucriId,oeordPreDate,oeordPreTime,oeordNowDate,oeordNowTime,dataField,"","",oeoriNote,"","","","")
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
 						.......i findRecordV="" s findRecordV=findRecFormerV 					
 						.......e  s findRecordV=findRecordV_"@"_findRecFormerV
 				....i (("^"_$p(typeName,"~",1)_"^")[("^"_"GetTotalOut"_"^"))&&(findLabDesc'="") d //总出量
 					.....f j=1:1:$l(findLabDesc,"#") d //主项执行时间
						......s tmpRecordV="",findRecFormerV="",findRecAfterV=""
						......s LabDesc=$p(findLabDesc,"#",j)
						......s oeordDate=$p(LabDesc," ",1),oeordTime=$p(LabDesc," ",2)				
						......s oeordDate=##class(web.DHCClinicCom).ConvertToDateH(oeordDate)
						......s oeordTime=##class(web.DHCClinicCom).ConvertToTimeH(oeordTime)
						......i (minQty="")&&(maxQty'="") d //标本送检后小时数据	
						.......s tmpRecordV=""			
						.......s oeordNowDateTime=..getPreDateTime(oeordDate,oeordTime,"+",maxQty)
						.......s oeordNowDate=$p(oeordNowDateTime," ",1),oeordNowTime=$p(oeordNowDateTime," ",2)
						.......s findRecFormerV=##class(web.DHCICUOrder).GetIORate(icuaId,oeordDate,oeordTime,oeordNowDate,oeordNowTime)
						.......s findRecFormerV=$p($g(findRecFormerV),"/",2)
						.......s findRecordV=findRecordV+findRecFormerV	
				....i (("^"_$p(typeName,"~",1)_"^")[("^"_"GetTotalIn"_"^"))&&(findLabDesc'="") d //总入量
 					.....f j=1:1:$l(findLabDesc,"#") d //主项执行时间
						......s tmpRecordV="",findRecFormerV="",findRecAfterV=""
						......s LabDesc=$p(findLabDesc,"#",j)
						......s oeordDate=$p(LabDesc," ",1),oeordTime=$p(LabDesc," ",2)				
						......s oeordDate=##class(web.DHCClinicCom).ConvertToDateH(oeordDate)
						......s oeordTime=##class(web.DHCClinicCom).ConvertToTimeH(oeordTime)
						......i (minQty="")&&(maxQty'="") d //标本送检后小时数据	
						.......s tmpRecordV=""			
						.......s oeordNowDateTime=..getPreDateTime(oeordDate,oeordTime,"+",maxQty)
						.......s oeordNowDate=$p(oeordNowDateTime," ",1),oeordNowTime=$p(oeordNowDateTime," ",2)
						.......s findRecFormerV=##class(web.DHCICUOrder).GetIORate(icuaId,oeordDate,oeordTime,oeordNowDate,oeordNowTime)
						.......s findRecFormerV=$p($g(findRecFormerV),"/",1)
						.......s findRecordV=findRecordV+findRecFormerV			 					
 					....i ($lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3)="L") s value=findLabDesc2
 					....i (("^"_$p(typeName,"~",1)_"^")[("^"_"ExeDate"_"^")) s value=findLabDesc2				
					....i ($lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3)="R") s value=findRecordV
					....i (("^"_$p(typeName,"~",1)_"^")[("^"_"GetTotalOut"_"^"))||(("^"_$p(typeName,"~",2)_"^")[("^"_"GetTotalIn"_"^")) s value=findRecordV
					....i (("^"_$p(typeName,"~",1)_"^")[("^"_"GetYZ"_"^")) s value=againArcimDT			
					....s searchVal=value
					....q:$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),5)'=1
					....s $p(icuStr,"^",posList(posCode))=value
					....i sumType'="" s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),value)
				...i (searchVal="")&($lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),4)=1) s ifQuitSearch=1				
		.q:icuStr=""
		.q:ifQuitSearch
		.//计算列
		.s icuciiSub=0
		.f  s icuciiSub=$o(^DHCICUCInquiry(icuciId,"I",icuciiSub)) q:icuciiSub=""  d
			..q:$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),3)'="C"
			..
			..s mainIcuciiIdStr=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),27) //关联主项
			..s mainIcuciiSub=$p(mainIcuciiIdStr,"||",2)
			..s mainPosCode=0
			..i mainIcuciiSub'="" d
				...s mainPosCode=..GetIcuciPosCode(icuciId,mainIcuciiSub)
				...w mainPosCode_"/"_$g(posList(mainPosCode)),!
				...b
			..q:(mainIcuciiSub'="")&($p(icuStr,"^",$g(posList(mainPosCode)))="")
			..
			..s value=""
			..//q:("^Percent^Multiply^")'[("^"_$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)_"^")
			..s delimter="*"
			..i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)="Percent" s delimter="/"
			..i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)="Multiply" s delimter="*"
			..s icuciiCalculateExpression=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),30)
			..s part=$p(icuciiCalculateExpression,delimter,1),total=$p(icuciiCalculateExpression,delimter,2)
			..s part=##class(web.DHCClinicCom).Replace(part,"-","+-"),total=##class(web.DHCClinicCom).Replace(total,"-","+-")
			..w "in================="_delimter,"/"_part_"/"_total,!
			..s partSum=0,totalSum=0
			..f iItem=1:1:$l(part,"+") d
				...s item=$p(part,"+",iItem)
				...q:item=""
				...s itemPos=$lg($g(^DHCICUCInquiry(icuciId,"I",$zabs(item))),20)
				...s partSum=(item/$zabs(item))*$p(icuStr,"^",itemPos)+partSum
			..f iItem=1:1:$l(total,"+") d
				...s item=$p(total,"+",iItem)
				...q:item=""
				...s itemPos=$lg($g(^DHCICUCInquiry(icuciId,"I",$zabs(item))),20)
				...s totalSum=(item/$zabs(item))*$p(icuStr,"^",itemPos)+totalSum
			..i totalSum>0 w "partSum="_partSum_"/totalSum"_totalSum_"/"_(partSum/totalSum),!
			..q:totalSum=0
			..i delimter="*" s value=partSum*totalSum
			..i delimter="/" s value=partSum/totalSum
			..q:value=""
			..i $lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),1)="Percent" s value=value*100
			..s pos=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),20)
			..w "cal=============="_pos
			..q:(pos<1) //!(partPos<1)!(totalPos<1)
			..s $p(icuStr,"^",pos)=$fn(value,"",2)
			..s posCode=..GetIcuciPosCode(icuciId,icuciiSub)
			..//s sumType=$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),24)
			..s sumStr=..SetSumStr(sumStr,sumType,posList(posCode),value)
		.
		.s count=count+1
		.s ^DHCICUCInquiry(+icuciId,"count")=count
		.;s ^DHCICUInquiry(icuciId,icuaId)=icuStr
		.q:(icuciDataType="D")&(icuaSeq=+icuaSeq)
		.i ($lg(^DHCICUCInquiry(icuciId),15)="") d  s ^DHCICUInquiry(icuciId,icuaSeq)=icuStr w icuStr,!
		.w count_"       "_icuStr,!
		.w sumStr,!
		.s icuStr=""
    b ;"end"		
	i icuciId=14 d ..MergingData(icuciId)
	m ^TEMPDHCICUInquiryWHL(icuciId)=^DHCICUInquiry(icuciId)
	i icuciId=14  m ^DHCICUInquiryJXKH(icuciId,0)=^DHCICUInquiry(icuciId,0) k ^DHCICUInquiry(icuciId)
	i icuciId=14  m ^DHCICUInquiry(icuciId)=^DHCICUInquiryJXKH(icuciId)  
	k ^DHCICUInquiryJXKH(icuciId)
	k ^TmpICUInOutDateTime
	k ^TmpICUOeoriSDt
 	w preDT_" pre\now "_$h_" duration:"_($p($h,",",2)-$p(preDT,",",2)),!
 	m ^DHCICUDebug=^DHCICUInquiry(icuciId) //temp
	m ^DHCICUDebug(1)=^DHCICUInquiry(icuciId,0) //temp
 	
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
	i $p(^DHCICUArrange(icuaId),"^",10)="" d
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
				...i OeordDr'="" s ARCIMID=$g(^OEORD(oeordId,"I",oeoriSub,1))
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
				...;i ARCIMRowIdStr="ECMOLL" b ;"start4"
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
          ..s apcheIIcount=$p($g(^DHCICUInquiry(icuciId,icuaId)),"^",4)
          ..i apcheIIcount'="" s $p(^DHCICUInquiryJXKH(icuciId,userId),"^",4)=$p(^DHCICUInquiryJXKH(icuciId,userId),"^",4)+1

	f  s userId=$o(^DHCICUInquiryJXKH(icuciId,userId)) q:userId=""  d
	   .s username=""
	   .s username=##class(web.DHCICUStatTEST).GetNameById(userId)
	   .q:username=""
	   .s $p(^DHCICUInquiryJXKH(icuciId,userId),"^",1)=username
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

/// 取现有人数，从出入转中按科室取出在院人数之和
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

// w ##class(web.DHCICUStatTEST).GetOpAndocByDate("2015-05-01","2015-05-01")

ClassMethod GetOpAndocByDate(stdate As %String, enddate As %String, andocdr As %String = "") As %String
{
	 s SubNode="SDate"
	 s sdate=##Class(web.DHCANOPCom).ConvertToDateH(stdate),edate=##Class(web.DHCANOPCom).ConvertToDateH(enddate)
	 f date=sdate:1:edate
	 {
		s opaId="" 
		f  s opaId=$O(^DHCANOPArrange(0,SubNode,date,opaId)) q:opaId=""  d
		.q:$d(^DHCANOPArrange(opaId))<1
		.s adm=$P(^DHCANOPArrange(opaId),"^",1)
	    .s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
		.s mzdr=$P(^OR(adm,"ANA",chl),"^",6)        					;ANA_Anaesthetist_Dr 
		.i mzdr'="" d
		..s andoc=##class(web.DHCANOPCom).GetNameById(mzdr)
		.e  s andoc=""
		.i andoc'="" w andoc,!
		 
	}
	
	q ""
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
	
	q:icuaLeaveDate="" retStr
	s icuBedId=$p($g(^DHCICUArrange(icuaId)),"^",4)
	s ctlocId=$p(^PAWARD(+icuBedId),"^",5)
	//w icucriId_"/"_icuaStartDate_"/"_icuaStartTime_"/"_icuaLeaveDate_"/"_icuaLeaveTime,!
	s retStr=..FindIcuInquiry(ctlocId,icuciId,icuaStartDate,icuaLeaveDate+1,"",icuaId,icuciiSub)
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
	i (TemperValue+HRValue+RRValue+WBCValue)>2 s retstr=1
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

/// 是否使用药物
/// w ##class(web.DHCICUStat).getVasoactiveAgents(7964,"VasoactiveAgents","2015-11-01","2015-11-05")
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
	.;B ;001
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
	...s phcSubcatId=$p(^PHCD(+phcdfId,1),"^",3)
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

}
