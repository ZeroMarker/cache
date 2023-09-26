Class web.DHCICUView Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 取监护数据DHC_ICU_Order
/// 入参：监护Id,就诊号EpisodeID,病区wardLocId，科室ctlocId(可为病区,为科室时找关联病区),
/// 所需要查询的显示分类ancvcCodeStr(用"^"分割的串)查，起止时间。icuoSourceStr="MA"只取手工录入数据
/// 
Query FindIcuOrder(icuaId As %String, startDate As %String, endDate As %String, ancvcCodeStr As %String(MAXLEN=20000) = "", icucriCodeStr As %String(MAXLEN=20000) = "", EpisodeID As %String = "", ctlocId As %String = "") As %Query(ROWSPEC = "Id,RecordItemId,OeoreId,UserId,StartDate,StartTime,EndDate,EndTime,ArcimId,Note,Qty,UomId,InstrId,RecordCatId,DoseSpeed,DocUserId,Volume,SpeedUnitId,Source,AncoDesc,ArcimDesc,ArrangeId,Instruction,Frequency,OeoriNote,Abbreviate,OrderItemNote,ParaItemId,DurationDay") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUView","FindIcuOrder",745,60333,$h,"AntimicrobialAgents^Pipe")
ClassMethod FindIcuOrderExecute(ByRef qHandle As %Binary, icuaId As %String, startDate As %String, endDate As %String, ancvcCodeStr As %String(MAXLEN=20000) = "", icucriCodeStr As %String(MAXLEN=20000) = "", EpisodeID As %String = "", ctlocId As %String = "") As %Status
{
	s firstDT=$h
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	s curId="",curIcucriId="",oeoreId="",curUserId="",curStartDate=""
	s curStartTime="",curEndDate="",curEndTime="",arcimId="",curNote=""
	s curQty="",uomId="",phcinId="",ancvcId="",doseSpeed=""
	s curDocUserId="",icuoVolume="",speedUnitId="",icuoSource="",icucriDesc=""
	s arcimDesc="",phcinDesc="",prcfrDesc="",oeoriNote=""
	s curAbbreviate="",icuoOrdItemNote="",icuoIcupiDr="",durationDay=""
	
	k ^TMPICU("Order",$j)
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=0
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s endTime=83999
	s sttDateTime=startDate+(startTime/100000)
	s endDateTime=endDate+(endTime/100000)
	s icucriIdStr="",ancvcIdStr=""
	i ancvcCodeStr'="" d
		.f i=1:1:$l(ancvcCodeStr,"^") d
			..s ancvcCode=$p(ancvcCodeStr,"^",i)
			..q:ancvcCode=""
			..s $p(ancvcIdStr,"^",i)=$o(^DHCICUC("ViewCat",0,ancvcCode,""))
		.//q:ancvcIdStr=""
		.//s icucriIdStr=##class(web.DHCICUCom).GetIcucriIdByAncvcId(ancvcIdStr)
	i icucriCodeStr'="" d 
		.f i=1:1:$l(icucriCodeStr,"^") d
			..s icucriCode=$p(icucriCodeStr,"^",i)
			..q:icucriCode=""
			..s $p(icucriIdStr,"^",i)=$o(^DHCICUC("RecordItem",0,"Code",icucriCode,""))
	//w ancvcIdStr,"/"_icucriIdStr,!
	
	s curDateTime=$h+($p($h,",",2)/100000)
	s icuaIdList=icuaId
	f i=1:1:$l(icuaIdList,"^") d
		.s icuaId=$p(icuaIdList,"^",i)
		.q:icuaId=""
		.s EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
		.q:EpisodeID=""
		.f j=1:1:$l(ancvcCodeStr,"^") d
			..s ancvcCode=$p(ancvcCodeStr,"^",j)
			..q:ancvcCode=""
			..s ancvcId=$o(^DHCICUC("ViewCat",0,ancvcCode,""))
			..q:ancvcId=""
			..s catList=$p($g(^DHCICUC("ViewCat",ancvcId)),"^",7)
			..i catList'="" d
				...s icuaStartDate=$p($g(^DHCICUArrange(icuaId)),"^",6)
				...i icuaStartDate<startDate s icuaStartDate=startDate
				...s seq=0
				...s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
				...//w oeordId,!
				...q:oeordId="" //未开过医嘱
				...s arcimId=""
				...f  s arcimId=$o(^OEORDi(0,"ARCIM",oeordId,arcimId)) q:arcimId=""  d
					....s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
					....q:phcdfId=""
					....s phcSubcatId=$p(^PHCD(+phcdfId,1),"^",3)
					....q:phcSubcatId=""
					....//s ancvcId=$O(^DHCICUC("ViewCat",0,"AntimicrobialAgents","")) //多个？
					....//i +arcimId=1174 w !,catList_"/"_phcSubcatId,!
					....q:("~"_catList_"~")'[("~"_phcSubcatId_"~")
					....;w arcimId,"/    "_phcSubcatId_"#"
					....s oeoriSttDate=startDate-1
					....f  s oeoriSttDate=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,oeoriSttDate)) q:oeoriSttDate=""  d
						.....s oeoriSub=""
						.....f  s oeoriSub=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,oeoriSttDate,oeoriSub)) q:oeoriSub=""  d
							......
							......s oeoreSub=0
							......f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:oeoreSub=""  d
								.......//w "ii"_$$GetOeOrderData("Y")
								.......q:$$GetOeOrderData("Y")<0
			..e  d
				...s icucvcIcucriIdStr=##class(web.DHCICUCom).GetIcucriIdByAncvcId(ancvcIdStr)
				...q:icucvcIcucriIdStr=""
				...i icucriIdStr="" s icucriIdStr=icucvcIcucriIdStr
				...e  s icucriIdStr=icucvcIcucriIdStr_"^"_icucriIdStr
		.f j=1:1:$l(icucriIdStr,"^") d
			..s icucriId=$p(icucriIdStr,"^",j)
			..q:icucriId=""
			..f date=startDate:1:endDate d
				...s time=""
				...f  s time=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time)) q:(time="")  d
					....s icuoId=""
					....f  s icuoId=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time,icuoId)) q:(icuoId="")  d
						.....q:$$GetIcuoData("Y")<0
	;b ;1
	s count=0
	s icuaId="" f  s icuaId=$o(^TMPICU("Order",$j,icuaId))  q:icuaId=""  d
	 	.s updateDateTime="" f  s updateDateTime=$o(^TMPICU("Order",$j,icuaId,updateDateTime))  q:updateDateTime=""  d
	     	..s icucriArcimId="" f  s icucriArcimId=$o(^TMPICU("Order",$j,icuaId,updateDateTime,icucriArcimId))  q:icucriArcimId=""  d
	         	...s icuoId="" f  s icuoId=$o(^TMPICU("Order",$j,icuaId,updateDateTime,icucriArcimId,icuoId))  q:icuoId=""  d
	             	....s Data=^TMPICU("Order",$j,icuaId,updateDateTime,icucriArcimId,icuoId)
	             	....d OutputIcuOrder
	             	....s count=count+1
	k ^TMPICU("Order",$j)
 	s qHandle=$lb(0,repid,0)
	q $$$OK
	
GetOeOrderData(ifByDateTime = "")
	//oeordId,arcimId,oeoriSttDate,oeoriSub
	s oeoriId=oeordId_"||"_oeoriSub,oeoreId=oeordId_"||"_oeoriSub_"||"_oeoreSub
	s curIcuoId=0,icuoId=""
	f  s curIcuoId=$o(^DHCICUOrder(0,"OEORE",oeoreId,icuaId,"")) q:icuoId=""  d
		.q:"ICD"[$p(^DHCICUOrder(curIcuoId),"^",25)
		.s icuoId=curIcuoId
	s icuoStartDate=$p($g(^DHCICUOrder(+icuoId)),"^",5)
	s icuoStartTime=$p($g(^DHCICUOrder(+icuoId)),"^",6)
	s icuoEndDate=$p($g(^DHCICUOrder(+icuoId)),"^",7)
	s icuoEndTime=$p($g(^DHCICUOrder(+icuoId)),"^",8)
	s icuoUpdateDate=$p($g(^DHCICUOrder(+icuoId)),"^",21)
	s icuoUpdateTime=$p($g(^DHCICUOrder(+icuoId)),"^",22)
	s oecprId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",8)
	q:oecprId="" ""
	s oecprCode=$p(^OECPR(oecprId),"^",1)
	q:oecprCode="" ""
	
	s oeoriStat=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",13) ;医嘱状态
	s oeoriXdate=$p(^OEORD(oeordId,"I",oeoriSub,3),"^",34) ;停医嘱日期
	s oeoriXTime=$p(^OEORD(oeordId,"I",oeoriSub,2),"^",15) ;停医嘱时间
	w "stopOrder："_oeoriXdate_" ,"_oeoriXTime_"---status:"_oeoriStat,!

	i icuoStartDate="" d
		.s icuoStartDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
		.s icuoStartTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
		.i (oecprCode="S")!(oecprCode="OMST")!(oecprCode="OMCQZT") d
			..s icuoStartDate=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",1)
			..s icuoStartTime=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",2)
		.e  d
			..s icuoEndDate=icuoStartDate,icuoEndTime=icuoStartTime
		.s icuoUpdateDate=icuoStartDate,icuoUpdateTime=icuoStartTime //temp!!??
		
	;停了的医嘱不再做数据累加	
	;w "stopOrder："_oeoriXdate_" ,"_oeoriXTime_"---status:"_oeoriStat,!
	;w "icuoStOrder："_icuoStartDate_" ,"_icuoStartTime_"---status:"_oeoriStat,!
	q:((+oeoriXdate)<(+icuoStartDate))&&(oeoriStat="4") ""  
	q:(oeoriXdate=icuoStartDate)&&((+oeoriXTime)<(+icuoStartTime))&&(oeoriStat="4") ""
	
	i icuoEndDate<icuoStartDate s icuoEndDate=icuoStartDate,icuoEndTime=icuoStartTime //!!
	i (icuoEndDate=icuoStartDate)&(icuoEndTime<icuoStartTime) s icuoEndTime=icuoStartTime
	//s mainIcuoEditFlag=$p($g(^DHCICUOrder(+icuoId)),"^",25)
	//q:"I"[mainIcuoEditFlag -3 //旧版本ICD

	s icuoStartDateTime=icuoStartDate+(icuoStartTime/100000)
	s icuoEndDateTime=icuoEndDate+(icuoEndTime/100000)
	//w icuoStartDateTime_"/"_icuoEndDateTime_"/"_sttDateTime_"/"_icuoStartTime,"/"_icuoEndTime,!
	q:(ifByDateTime="Y")&(icuoEndDateTime'>sttDateTime) -4 //开始时间点不计
	q:(ifByDateTime="Y")&(icuoStartDateTime>endDateTime) -5 //结束时间点计入
	//q:($p($g(^DHCICUOrder(+icuoId)),"^",29)="I")&(curDateTime-icuoStartDateTime>30) -6 //不查看三十天以上的数据，旧版一天
	
	//s arcimId=$p($g(^DHCICUOrder(+icuoId)),"^",9)				//ICUO_ARCIM_Dr
	s icucriId=$p($g(^DHCICUOrder(+icuoId)),"^",2)				//ICUO_ComOrd_Dr
	//s ancvcId=$p($g(^DHCICUOrder(+icuoId)),"^",16)			//ICUO_ViewCat_Dr
	//q:(icucriId="")&(arcimId="")&(ancvcId="") -8
	s speedUnitId=$p(^DHCICUOrder(+icuoId),"^",20)
	
	s curId=icuoId //s tmpStr=icuoId_"^"
	s curIcucriId=icucriId //s tmpStr=tmpStr_icucriId_"^"
	s curUserId=$p($g(^DHCICUOrder(+icuoId)),"^",4) // tmpStr=tmpStr_$p($g(^DHCICUOrder(+icuoId)),"^",4)_"^"	//ICUO_User_Dr
	s curStartDate=$zd(icuoStartDate,3)
	s curStartTime=$zt(icuoStartTime)
	s curEndDate=$zd(icuoEndDate,3)
	s curEndTime=$zt(icuoEndTime)
	s curNote=$p($g(^DHCICUOrder(+icuoId)),"^",10) //ICUO_Note num:10
	//s curQty=$p($g(^DHCICUOrder(+icuoId)),"^",11)	//ICUO_Qty
	s curQty=$p($g(^OEORD(oeordId,"I",+oeoriSub,2)),"^",1) //doseQty
	s unitUomId=$p($g(^OEORD(oeordId,"I",+oeoriSub,2)),"^",3)
	i curQty="" s curQty=$p($g(^OEORD(oeordId,"I",+oeoriSub,1)),"^",12) //phOrdQty
	
	s oeorditemStr=##class(web.DHCICUOrder).GetOeorditemInfo(oeoriId)
	s uomId=$p(oeorditemStr,"^",12)
	s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7) //$p($g(^DHCICUOrder(+icuoId)),"^",15)
	s phcdId=+phcdfId,phcdfSub=$p(phcdfId,"||",2)
	//s eqId=0,volumeEqQty=0
	//f  s eqId=$o(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)) q:eqId=""  d
		//.s eqUomId=+^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)
		//.//i eqUomId=volumeCtuomId s volumeEqQty=$p(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId),"^",2)
	s eqId=$o(^PHCD(phcdId,"DF",phcdfSub,"EQ",0))
	i eqId'="" s uomId=+^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)
		
	s ancvcDesc=""
	i ancvcId'="" s ancvcDesc=$p($g(^DHCICUC("ViewCat",ancvcId)),"^",2)
	s doseSpeed=##class(web.DHCICUOrder).GetDoseSpeed(+icuoId)
	s curUpdateDate=$zd(icuoUpdateDate,3) //s tmpStr=tmpStr_$ZD(icuoUpdateDate,3)_"^" //num:20
	s curUpdateTime=$zt(icuoUpdateTime) //s tmpStr=tmpStr_$ZT(icuoUpdateTime)_"^"
	s curEditFlag=$p($g(^DHCICUOrder(+icuoId)),"^",25) //s tmpStr=tmpStr_$p($g(^DHCICUOrder(+icuoId)),"^",25)_"^"	//ICUO_EditFlag
	s curDocUserId=$p($g(^DHCICUOrder(+icuoId)),"^",27) //s tmpStr=tmpStr_$p($g(^DHCICUOrder(+icuoId)),"^",27)_"^"	//ICUO_DocUser_Dr
	s icuoVolume=+$p($g(^DHCICUOrder(+icuoId)),"^",28) //s tmpStr=tmpStr_+$p($g(^DHCICUOrder(+icuoId)),"^",28)_"^"	//ICUO_Volume
	s icuoSpeedUnitDr=$p($g(^DHCICUOrder(+icuoId)),"^",20) //s tmpStr=tmpStr_$p($g(^DHCICUOrder(+icuoId)),"^",20)_"^" //ICUO_SpeedUnit_Dr
	s icuoSource=$p($g(^DHCICUOrder(+icuoId)),"^",29) //s tmpStr=tmpStr_$p($g(^DHCICUOrder(+icuoId)),"^",29)_"^"	//ICUO_Source
	s icucriDesc=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",2) //s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",+$p($g(^DHCICUOrder(+icuoId)),"^",2))),"^",2)_"^"
	s arcimDesc=$p($g(^ARCIM(+arcimId,1,1)),"^",2) //s tmpStr=tmpStr_$p($g(^ARCIM(+arcimId,1,1)),"^",2)_"^"
	i $p(oeorditemStr,"^",6)'="" s $p(oeorditemStr,"^",6)=$p(oeorditemStr,"^",6)_"||"_oeoreSub
	s phcinDesc=$p(oeorditemStr,"^",5) //s tmpStr=tmpStr_$p(oeorditemStr,"^",5)_"^"		//用法 phcinDesc  40
	s prcfrDesc=$p(oeorditemStr,"^",15) //s tmpStr=tmpStr_$p(oeorditemStr,"^",15)_"^"		//频率 num: 41
	s oeoriNote=$p(oeorditemStr,"^",17) //s tmpStr=tmpStr_$p(oeorditemStr,"^",17)_"^"		//医嘱备注 42
	s curAbbreviate=$p($g(^DHCICUOrder(+icuoId)),"^",34)
	i curAbbreviate="" s curAbbreviate=##class(web.DHCClinicCom).GetOeoriGroupDesc(oeoriId)
	//s tmpStr=tmpStr_icuoAbbreviate_"^"	//常用医嘱缩写 ICUO_Abbreviate
	//s tmpStr=tmpStr_$p($g(^DHCICUOrder(+icuoId)),"^",34)_"^"	//常用医嘱缩写 ICUO_Abbreviate
	s icuoOrdItemNote=$p($g(^DHCICUOrder(+icuoId)),"^",35) //s tmpStr=tmpStr_$p($g(^DHCICUOrder(+icuoId)),"^",35)_"^"	//HIS医嘱说明 ICUO_OrdItemNote
	s icuoIcupiDr=$p($g(^DHCICUOrder(+icuoId)),"^",38) //s tmpStr=tmpStr_"^"_$p($g(^DHCICUOrder(+icuoId)),"^",38)	//ICUO_ICUPI_Dr  total 47
	s fillerno=$p($g(^OEORD(oeordId,"I",+oeoriSub,9)),"^",12)
	s firstOeoriId=$p(fillerno,"!!",1)
	s firstStartDate=icuoStartDate
	i firstOeoriId'="" d
		.s firstOeoriSub=$p(firstOeoriId,"||",2)
		.s firstStartDate=$p($g(^OEORD(oeordId,"I",+firstOeoriSub,1)),"^",9)
	s durationDay=icuoStartDate-firstStartDate+1
	//w "durationDay="_durationDay_" /"_oeordId_" /"_oeoreId,!
	
	s oreGroup=""
	s updateDateTime=icuoUpdateDate+(icuoUpdateTime/100000)
	s curId=icuoId
	s icuodSub=0
	s ^TMPICU("Order",$j,icuaId,updateDateTime,oreGroup_","_icucriId_","_arcimId,+icuoId)=$lb(curId,curIcucriId,oeoreId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,phcinId,ancvcId,doseSpeed,curDocUserId,icuoVolume,speedUnitId,icuoSource,icucriDesc,arcimDesc,icuaId,phcinDesc,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoIcupiDr,durationDay)
	q 0

GetIcuoData(ifByDateTime = "")
	q:'$d(^DHCICUOrder(icuoId)) -1
	//q:(icuoSourceStr'="")&(icuoSourceStr'[$p(^DHCICUOrder(icuoId),"^",29)) -2
	s icuoUpdateDate=$p(^DHCICUOrder(icuoId),"^",21)
	s icuoUpdateTime=$p(^DHCICUOrder(icuoId),"^",22)
	s icuoStartDate=$p(^DHCICUOrder(icuoId),"^",5)
	s icuoStartTime=$p(^DHCICUOrder(icuoId),"^",6)
	s icuoEndDate=$p(^DHCICUOrder(icuoId),"^",7)
	s icuoEndTime=$p(^DHCICUOrder(icuoId),"^",8)
	s mainIcuoEditFlag=$p(^DHCICUOrder(icuoId),"^",25)
	q:"ICD"[mainIcuoEditFlag -3 //旧版本ICD

	s icuoStartDateTime=icuoStartDate+(icuoStartTime/100000)
	s icuoEndDateTime=icuoEndDate+(icuoEndTime/100000)
	q:(ifByDateTime="Y")&(icuoEndDateTime'>sttDateTime) -4 //开始时间点不计
	q:(ifByDateTime="Y")&(icuoStartDateTime>endDateTime) -5 //结束时间点计入
	//q:($p(^DHCICUOrder(icuoId),"^",29)="I")&(curDateTime-icuoStartDateTime>30) -6 //不查看三十天以上的数据，旧版一天
	
	s arcimId=$p(^DHCICUOrder(icuoId),"^",9)				//ICUO_ARCIM_Dr
	//s icucriId=$p(^DHCICUOrder(icuoId),"^",2)				//ICUO_ComOrd_Dr
	//q:(icucriIdStr'="")&(("^"_icucriIdStr_"^")'[("^"_icucriId_"^")) -7
	s ancvcId=$p(^DHCICUOrder(icuoId),"^",16)			//ICUO_ViewCat_Dr
	q:(icucriId="")&(arcimId="")&(ancvcId="") -8
	s oeoreId=$p(^DHCICUOrder(icuoId),"^",3)
	s oeordId=+oeoreId
	s oeoriSub=$p(oeoreId,"||",2)
	s oeoreSub=$p(oeoreId,"||",3)
	s oeoriId=""
	i oeoriSub'="" s oeoriId=oeordId_"||"_oeoriSub
	q:(icucriId="")&(ancvcId="") -8
		
	s curId=icuoId //s tmpStr=icuoId_"^"
	s curIcucriId=icucriId //s tmpStr=tmpStr_icucriId_"^"
	s curUserId=$p(^DHCICUOrder(icuoId),"^",4) // tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",4)_"^"	//ICUO_User_Dr
	s curStartDate=$zd(icuoStartDate,3) //s tmpStr=tmpStr_$ZD(icuoStartDate,3)_"^"			//ICUO_StartDate
	s curStartTime=$zt(icuoStartTime) //s tmpStr=tmpStr_$ZT(icuoStartTime)_"^"
	s curEndDate=$zd(icuoEndDate,3) //s tmpStr=tmpStr_$ZD(icuoEndDate,3)_"^"
	s curEndTime=$zt(icuoEndTime) //s tmpStr=tmpStr_$ZT(icuoEndTime)_"^"
	s curNote=$p(^DHCICUOrder(icuoId),"^",10) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",10)_"^"	//ICUO_Note num:10
	s curQty=$p(^DHCICUOrder(icuoId),"^",11) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",11)_"^"	//ICUO_Qty
	
	s oeorditemStr=##class(web.DHCICUOrder).GetOeorditemInfo(oeoriId)
	i oeorditemStr="" s oeorditemStr=##class(web.DHCICUOrder).GetICUOrditemInfo(icuoId)
	s uomId=$p(^DHCICUOrder(icuoId),"^",12)
	i uomId="" s uomId=$p(oeorditemStr,"^",12)
	//s tmpStr=tmpStr_uomId_"^"	//ICUO_Uom_Dr
	s phcinId=$p(^DHCICUOrder(icuoId),"^",15)	
	//s tmpStr=tmpStr_phcinId_"^"	//ICUO_Instr_Dr
	s ancvcDesc=""
	i ancvcId'="" s ancvcDesc=$p($g(^DHCICUC("ViewCat",ancvcId)),"^",2)
	//s tmpStr=tmpStr_ancvcId_"^" //tmpStr_ancvcDesc_"^"
	s doseSpeed=##class(web.DHCICUOrder).GetDoseSpeed(+icuoId)
	w "doseSpeed="_doseSpeed,!
	s curUpdateDate=$zd(icuoUpdateDate,3) //s tmpStr=tmpStr_$ZD(icuoUpdateDate,3)_"^" //num:20
	s curUpdateTime=$zt(icuoUpdateTime) //s tmpStr=tmpStr_$ZT(icuoUpdateTime)_"^"
	s curEditFlag=$p(^DHCICUOrder(icuoId),"^",25) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",25)_"^"	//ICUO_EditFlag
	s curDocUserId=$p(^DHCICUOrder(icuoId),"^",27) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",27)_"^"	//ICUO_DocUser_Dr
	s icuoVolume=+$p(^DHCICUOrder(icuoId),"^",28) //s tmpStr=tmpStr_+$p(^DHCICUOrder(icuoId),"^",28)_"^"	//ICUO_Volume
	s icuoSpeedUnitDr=$p(^DHCICUOrder(icuoId),"^",20) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",20)_"^" //ICUO_SpeedUnit_Dr
	s icuoSource=$p(^DHCICUOrder(icuoId),"^",29) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",29)_"^"	//ICUO_Source
	s icucriDesc=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",2) //s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",+$p(^DHCICUOrder(icuoId),"^",2))),"^",2)_"^"
	s arcimDesc=$p($g(^ARCIM(+arcimId,1,1)),"^",2) //s tmpStr=tmpStr_$p($g(^ARCIM(+arcimId,1,1)),"^",2)_"^"
	i $p(oeorditemStr,"^",6)'="" s $p(oeorditemStr,"^",6)=$p(oeorditemStr,"^",6)_"||"_oeoreSub
	s phcinDesc=$p(oeorditemStr,"^",5) //s tmpStr=tmpStr_$p(oeorditemStr,"^",5)_"^"		//用法 phcinDesc  40
	s prcfrDesc=$p(oeorditemStr,"^",15) //s tmpStr=tmpStr_$p(oeorditemStr,"^",15)_"^"		//频率 num: 41
	s oeoriNote=$p(oeorditemStr,"^",17) //s tmpStr=tmpStr_$p(oeorditemStr,"^",17)_"^"		//医嘱备注 42
	s speedUnitId=$p(^DHCICUOrder(+icuoId),"^",20)
	s curAbbreviate=$p(^DHCICUOrder(icuoId),"^",34)
	i curAbbreviate="" s curAbbreviate=##class(web.DHCClinicCom).GetOeoriGroupDesc(oeoriId)
	//s tmpStr=tmpStr_icuoAbbreviate_"^"	//常用医嘱缩写 ICUO_Abbreviate
	//s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",34)_"^"	//常用医嘱缩写 ICUO_Abbreviate
	s icuoOrdItemNote=$p(^DHCICUOrder(icuoId),"^",35) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",35)_"^"	//HIS医嘱说明 ICUO_OrdItemNote
	s icuoIcupiDr=$p(^DHCICUOrder(icuoId),"^",38) //s tmpStr=tmpStr_"^"_$p(^DHCICUOrder(icuoId),"^",38)	//ICUO_ICUPI_Dr  total 47
	s fillerno=$p($g(^OEORD(oeordId,"I",+oeoriSub,9)),"^",12)
	s firstOeoriId=$p(fillerno,"!!",1)
	s firstStartDate=$p($g(^OEORD(oeordId,"I",+oeoriSub,1)),"^",9) //to be ordexec!!!!
	i firstOeoriId'="" d
		.s firstOeoriSub=$p(firstOeoriId,"||",2)
		.s firstStartDate=$p($g(^OEORD(oeordId,"I",+firstOeoriSub,1)),"^",9)
	s durationDay=icuoStartDate-firstStartDate+1
	
	s oreGroup=""
	s updateDateTime=icuoUpdateDate+(icuoUpdateTime/100000)
	s curId=icuoId
	s icuodSub=0
	s ^TMPICU("Order",$j,icuaId,updateDateTime,oreGroup_","_icucriId_","_arcimId,icuoId)=$lb(curId,curIcucriId,oeoreId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,phcinId,ancvcId,doseSpeed,curDocUserId,icuoVolume,speedUnitId,icuoSource,icucriDesc,arcimDesc,icuaId,phcinDesc,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoIcupiDr,durationDay)
	q 0
    
OutputIcuOrder
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindIcuOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindIcuOrderExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindIcuOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindIcuOrderExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 取监护数据DHC_ICU_Order
/// 入参：监护Id,就诊号EpisodeID,病区wardLocId，科室ctlocId(可为病区,为科室时找关联病区),
/// 所需要查询的显示分类ancvcIdStr(用"^"分割的串)查，起止时间。icuoSourceStr="MA"只取手工录入数据
Query FindIcuVitalSign(icuaId As %String, startDate As %String, endDate As %String, ancvcCodeStr As %String = "", icucriCodeStr As %String(MAXLEN=20000) = "", EpisodeID As %String = "", ctlocId As %String = "") As %Query(ROWSPEC = "Id,RecordItemId,UserId,StartDate,StartTime,EndDate,EndTime,Note,Qty,UomId,RecordCatId,DocUserId,Source,AncoDesc,ArrangeId,Abbreviate,ParaItemId") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUView","FindIcuVitalSign",92,60333,$h,"")
ClassMethod FindIcuVitalSignExecute(ByRef qHandle As %Binary, icuaId As %String, startDate As %String, endDate As %String, ancvcCodeStr As %String = "", icucriCodeStr As %String(MAXLEN=2000) = "", EpisodeID As %String = "", ctlocId As %String = "") As %Status
{
	s firstDT=$h
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	
	k ^DHCICUTMP("VitalSign",$j)
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=0
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s endTime=83999
	s sttDateTime=startDate+(startTime/100000)
	s endDateTime=endDate+(endTime/100000)
	
	s ancvcIdStr="",icucriIdStr=""
	i icucriCodeStr="" d
		.f i=1:1:$l(ancvcCodeStr,"^") d
			..s ancvcCode=$p(ancvcCodeStr,"^",i)
			..q:ancvcCode=""
			..s $p(ancvcIdStr,"^",i)=$o(^DHCICUC("ViewCat",0,ancvcCode,""))
		.q:ancvcIdStr=""
		.s icucriIdStr=##class(web.DHCICUCom).GetIcucriIdByAncvcId(ancvcIdStr)
	e  d 
		.f i=1:1:$l(icucriCodeStr,"^") d
			..s icucriCode=$p(icucriCodeStr,"^",i)
			..q:icucriCode=""
			..s $p(icucriIdStr,"^",i)=$o(^DHCICUC("RecordItem",0,"Code",icucriCode,""))
	s curDateTime=$h+($p($h,",",2)/100000)
	/*s fDate=startDate-1
	f curDate=fDate:1:endDate d
	    .q:ancvcIdStr'=""
	    .f i=1:1:$l(icuaIdList,"^") d
	        ..s icuaId=$p(icuaIdList,"^",i)
	        ..i icuoSourceStr="I" d
	        	...s curTime=""
	        	...f  s curTime=$o(^DHCICUArrange(0,"CData",icuaId,curDate,curTime),-1) q:(curTime="")  d
	        		....s icucdSub=""
	        		....f  s icucdSub=$o(^DHCICUArrange(0,"CData",icuaId,curDate,curTime,icucdSub)) q:icucdSub=""  d
	        			.....q:$$GetCollectData("Y")<0
	        ..*/
	s icuaIdList=icuaId
	f i=1:1:$l(icuaIdList,"^") d
		.s icuaId=$p(icuaIdList,"^",i)
		.q:icuaId=""
		.f j=1:1:$l(icucriIdStr,"^") d
			..s icucriId=$p(icucriIdStr,"^",j)
			..q:icucriId=""
			..s icuaStartDate=$p($g(^DHCICUArrange(icuaId)),"^",6)
			..i icuaStartDate<startDate s icuaStartDate=startDate
			..s seq=0
			..f date=startDate:1:endDate d
				...s time=""
				...f  s time=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time)) q:(time="")  d
					....s icuoId=""
					....f  s icuoId=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time,icuoId)) q:(icuoId="")  d
						.....q:$$GetIcuoVitalSign("Y")<0
	s count=0
	s icuaId="" f  s icuaId=$o(^DHCICUTMP("VitalSign",$j,icuaId))  q:icuaId=""  d
	 	.s updateDateTime="" f  s updateDateTime=$o(^DHCICUTMP("VitalSign",$j,icuaId,updateDateTime))  q:updateDateTime=""  d
	     	..s icucriArcimId="" f  s icucriArcimId=$o(^DHCICUTMP("VitalSign",$j,icuaId,updateDateTime,icucriArcimId))  q:icucriArcimId=""  d
	         	...s icuoId="" f  s icuoId=$o(^DHCICUTMP("VitalSign",$j,icuaId,updateDateTime,icucriArcimId,icuoId))  q:icuoId=""  d
	             		....s Data=^DHCICUTMP("VitalSign",$j,icuaId,updateDateTime,icucriArcimId,icuoId)
	             		....d OutputIcuVitalSign
	             		....s count=count+1
	w count,"/"_firstDT,"/"_$h,!
	k ^DHCICUTMP("VitalSign",$j)
 	s qHandle=$lb(0,repid,0)
	q $$$OK
GetIcuoVitalSign(ifByDateTime = "")
	q:'$d(^DHCICUOrder(icuoId)) -1
	//q:(icuoSourceStr'="")&(icuoSourceStr'[$p(^DHCICUOrder(icuoId),"^",29)) -2
	s icuoUpdateDate=$p(^DHCICUOrder(icuoId),"^",21)
	s icuoUpdateTime=$p(^DHCICUOrder(icuoId),"^",22)
	s icuoStartDate=$p(^DHCICUOrder(icuoId),"^",5)
	s icuoStartTime=$p(^DHCICUOrder(icuoId),"^",6)
	s icuoEndDate=$p(^DHCICUOrder(icuoId),"^",7)
	s icuoEndTime=$p(^DHCICUOrder(icuoId),"^",8)
	s mainIcuoEditFlag=$p(^DHCICUOrder(icuoId),"^",25)
	q:"ICD"[mainIcuoEditFlag -3 //旧版本ICD
	s icuoStartDateTime=icuoStartDate+(icuoStartTime/100000)
	s icuoEndDateTime=icuoEndDate+(icuoEndTime/100000)
	q:(ifByDateTime="Y")&(icuoEndDateTime'>sttDateTime) -4 //开始时间点不计
	q:(ifByDateTime="Y")&(icuoStartDateTime>endDateTime) -5 //结束时间点计入
	//q:($p(^DHCICUOrder(icuoId),"^",29)="I")&(curDateTime-icuoStartDateTime>30) -6 //不查看三十天以上的数据，旧版一天
	
	//s icucriId=$p(^DHCICUOrder(icuoId),"^",2)				//ICUO_ComOrd_Dr
	//q:(icucriIdStr'="")&(("^"_icucriIdStr_"^")'[("^"_icucriId_"^")) -7
	s ancvcId=$p(^DHCICUOrder(icuoId),"^",16)			//ICUO_ViewCat_Dr
	q:(icucriId="")&(ancvcId="") -8
		
	s curId=icuoId //s tmpStr=icuoId_"^"
	s curIcucriId=icucriId //s tmpStr=tmpStr_icucriId_"^"
	s curUserId=$p(^DHCICUOrder(icuoId),"^",4) // tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",4)_"^"	//ICUO_User_Dr
	s curStartDate=$zd(icuoStartDate,3) //s tmpStr=tmpStr_$ZD(icuoStartDate,3)_"^"			//ICUO_StartDate
	s curStartTime=$zt(icuoStartTime) //s tmpStr=tmpStr_$ZT(icuoStartTime)_"^"
	s curEndDate=$zd(icuoEndDate,3) //s tmpStr=tmpStr_$ZD(icuoEndDate,3)_"^"
	s curEndTime=$zt(icuoEndTime) //s tmpStr=tmpStr_$ZT(icuoEndTime)_"^"
	s curNote=$p(^DHCICUOrder(icuoId),"^",10) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",10)_"^"	//ICUO_Note num:10
	s curQty=$p(^DHCICUOrder(icuoId),"^",11) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",11)_"^"	//ICUO_Qty
	
	s uomId=$p(^DHCICUOrder(icuoId),"^",12)
	s ancvcDesc=""
	i ancvcId'="" s ancvcDesc=$p($g(^DHCICUC("ViewCat",ancvcId)),"^",2)
	s curUpdateDate=$zd(icuoUpdateDate,3) //s tmpStr=tmpStr_$ZD(icuoUpdateDate,3)_"^" //num:20
	s curUpdateTime=$zt(icuoUpdateTime) //s tmpStr=tmpStr_$ZT(icuoUpdateTime)_"^"
	s curEditFlag=$p(^DHCICUOrder(icuoId),"^",25) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",25)_"^"	//ICUO_EditFlag
	s curDocUserId=$p(^DHCICUOrder(icuoId),"^",27) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",27)_"^"	//ICUO_DocUser_Dr
	s icuoSource=$p(^DHCICUOrder(icuoId),"^",29) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",29)_"^"	//ICUO_Source
	s icucriDesc=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",2) //s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",+$p(^DHCICUOrder(icuoId),"^",2))),"^",2)_"^"
	s curAbbreviate=$p(^DHCICUOrder(icuoId),"^",34)
	s icuoIcupiDr=$p(^DHCICUOrder(icuoId),"^",38) //s tmpStr=tmpStr_"^"_$p(^DHCICUOrder(icuoId),"^",38)	//ICUO_ICUPI_Dr  total 47

	s oreGroup=""
	
	s updateDateTime=icuoUpdateDate+(icuoUpdateTime/100000)
	s curId=icuoId
	s icuodSub=0
	s ^DHCICUTMP("VitalSign",$j,icuaId,updateDateTime,oreGroup_","_icucriId_",",icuoId)=$lb(curId,curIcucriId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,curNote,curQty,uomId,ancvcId,curDocUserId,icuoSource,icucriDesc,icuaId,curAbbreviate,icuoIcupiDr)
	q 0
    
OutputIcuVitalSign
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindIcuVitalSignFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindIcuVitalSignExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindIcuVitalSignClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindIcuVitalSignExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 取检验数据
/// 入参：监护Id,就诊号EpisodeID,病区wardLocId，科室ctlocId(可为病区,为科室时找关联病区),
/// 所需要查询的显示分类ancvcCodeStr(用"^"分割的串)查，起止时间。icuoSourceStr="MA"只取手工录入数据
Query FindIcuLab(icuaId As %String, startDate As %String, endDate As %String, ancvcCodeStr As %String = "", testCodeStr As %String(MAXLEN=20000) = "", icucriCodeStr As %String(MAXLEN=20000) = "", EpisodeID As %String = "", ctlocId As %String = "") As %Query(ROWSPEC = "Id,RecordItemId,OeoreId,UserId,StartDate,StartTime,EndDate,EndTime,ArcimId,Note,Qty,UomId,RecordCatId,DocUserId,AncoDesc,ArcimDesc,ArrangeId,Frequency,OeoriNote,Abbreviate,OrderItemNote,ParaItemId,durationDay") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUView","FindIcuLab",3,"2020-09-01","2020-10-01","Lab","WBC","WBC")
ClassMethod FindIcuLabExecute(ByRef qHandle As %Binary, icuaId As %String, startDate As %String, endDate As %String, ancvcCodeStr As %String = "", testCodeStr As %String(MAXLEN=20000) = "", icucriCodeStr As %String(MAXLEN=20000) = "", EpisodeID As %String = "", ctlocId As %String = "") As %Status
{
	s firstDT=$h
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	
	k ^TMPICU("Lab",$j)
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=0
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s endTime=83999
	s sttDateTime=startDate+(startTime/100000)
	s endDateTime=endDate+(endTime/100000)
	s oeoreId="",icuoSpeed=""
	s icucriIdStr="",ancvcIdStr="",arcimDesc="",prcfrDesc="",oeoriNote="",curAbbreviate="",icuoOrdItemNote="",icuoIcupiDr=""
	i ancvcCodeStr'="" d
		.f i=1:1:$l(ancvcCodeStr,"^") d
			..s ancvcCode=$p(ancvcCodeStr,"^",i)
			..q:ancvcCode=""
			..s $p(ancvcIdStr,"^",i)=$o(^DHCICUC("ViewCat",0,ancvcCode,""))
	;w ancvcIdStr,!
	
	s curDateTime=$h+($p($h,",",2)/100000)
	//监护记录中的检验代码
	i icucriCodeStr="" s icucriCodeStr="pH^pCO2^pO2^HCO3-^Lac^K+^Na+^Glu^Ca++^sO2^Gap^SampleType^CultureResult"
	//HIS中的检验代码，目前的为复兴代码
	i testCodeStr="" s testCodeStr="WBC^PLT^Hb^K^Na^UNa^BUN^CR^Ca^P^xalb^ALT^AST^TBil^DBil^APTT^DDimer^CK^CKMB^TnT^NTproBNP^PCT^CRP^LAC^CultureResult^CRXJ"
	s icuaIdList=icuaId
	//s ETX="#"
	//s STX="\"
	s STX=$c(2)
	s ETX=$c(3)
	f i=1:1:$l(icuaIdList,"^") d
		.s icuaId=$p(icuaIdList,"^",i)
		.q:icuaId=""
		.s EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
		.q:EpisodeID=""
		.f j=1:1:$l(ancvcCodeStr,"^") d
			..s ancvcCode=$p(ancvcCodeStr,"^",j)
			..q:ancvcCode=""
			..s ancvcId=$o(^DHCICUC("ViewCat",0,ancvcCode,""))
			..q:ancvcId=""
			..s icuaStartDate=$p($g(^DHCICUArrange(icuaId)),"^",6)
			..i icuaStartDate<startDate s icuaStartDate=startDate
			..s seq=0,ifByDateTime="Y"
			..f k=1:1:$l(icucriCodeStr,"^") d
				...s testCode=$p(icucriCodeStr,"^",k)
				...q:testCode=""
				...i ("^"_icucriCodeStr_"^")[("^"_testCode_"^") d
					....w "------------",testCode,!
					....s icucriId=$o(^DHCICUC("RecordItem",0,"Code",testCode,""))
					....q:icucriId=""
					....f date=startDate:1:endDate d
						.....s time=""
						.....f  s time=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time)) q:(time="")  d
							......s icuoId=""
							......f  s icuoId=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time,icuoId)) q:(icuoId="")  d
								.......q:'$d(^DHCICUOrder(icuoId))
								.......s arcimId=testCode
								.......s icuoUpdateDate=$p(^DHCICUOrder(icuoId),"^",21)
								.......s icuoUpdateTime=$p(^DHCICUOrder(icuoId),"^",22)
								.......s icuoStartDate=$p(^DHCICUOrder(icuoId),"^",5)
								.......s icuoStartTime=$p(^DHCICUOrder(icuoId),"^",6)
								.......s icuoEndDate=$p(^DHCICUOrder(icuoId),"^",7)
								.......s icuoEndTime=$p(^DHCICUOrder(icuoId),"^",8)
								.......s mainIcuoEditFlag=$p(^DHCICUOrder(icuoId),"^",25)
								.......q:"ICD"[mainIcuoEditFlag //旧版本ICD
								.......s icuoStartDateTime=icuoStartDate+(icuoStartTime/100000)
								.......s icuoEndDateTime=icuoEndDate+(icuoEndTime/100000)
								.......q:(ifByDateTime="Y")&(icuoEndDateTime'>sttDateTime) //开始时间点不计
								.......q:(ifByDateTime="Y")&(icuoStartDateTime>endDateTime) //结束时间点计入
								.......s ancvcId=$p(^DHCICUOrder(icuoId),"^",16)			//ICUO_ViewCat_Dr
								.......q:(icucriId="")&(ancvcId="")
								.......
								.......s curId=icuoId //s tmpStr=icuoId_"^"
								.......s curIcucriId=icucriId //s tmpStr=tmpStr_icucriId_"^"
								.......s curUserId=$p(^DHCICUOrder(icuoId),"^",4) // tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",4)_"^"	//ICUO_User_Dr
								.......s curStartDate=$zd(icuoStartDate,3) //s tmpStr=tmpStr_$ZD(icuoStartDate,3)_"^"			//ICUO_StartDate
								.......s curStartTime=$zt(icuoStartTime) //s tmpStr=tmpStr_$ZT(icuoStartTime)_"^"
								.......s curEndDate=$zd(icuoEndDate,3) //s tmpStr=tmpStr_$ZD(icuoEndDate,3)_"^"
								.......s curEndTime=$zt(icuoEndTime) //s tmpStr=tmpStr_$ZT(icuoEndTime)_"^"
								.......s curNote=$p(^DHCICUOrder(icuoId),"^",10) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",10)_"^"	//ICUO_Note num:10
								.......s curQty=$p(^DHCICUOrder(icuoId),"^",11) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",11)_"^"	//ICUO_Qty
								.......
								.......s uomId=$p(^DHCICUOrder(icuoId),"^",12)
								.......s ancvcDesc=""
								.......i ancvcId'="" s ancvcDesc=$p($g(^DHCICUC("ViewCat",ancvcId)),"^",2)
								.......s curUpdateDate=$zd(icuoUpdateDate,3) //s tmpStr=tmpStr_$ZD(icuoUpdateDate,3)_"^" //num:20
								.......s curUpdateTime=$zt(icuoUpdateTime) //s tmpStr=tmpStr_$ZT(icuoUpdateTime)_"^"
								.......s curEditFlag=$p(^DHCICUOrder(icuoId),"^",25) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",25)_"^"	//ICUO_EditFlag
								.......s curDocUserId=$p(^DHCICUOrder(icuoId),"^",27) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",27)_"^"	//ICUO_DocUser_Dr
								.......s icuoSource=$p(^DHCICUOrder(icuoId),"^",29) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",29)_"^"	//ICUO_Source
								.......s icucriDesc=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",2) //s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",+$p(^DHCICUOrder(icuoId),"^",2))),"^",2)_"^"
								.......s curAbbreviate=$p(^DHCICUOrder(icuoId),"^",34)
								.......s icuoIcupiDr=$p(^DHCICUOrder(icuoId),"^",38) //s tmpStr=tmpStr_"^"_$p(^DHCICUOrder(icuoId),"^",38)	//ICUO_ICUPI_Dr  total 47
								.......s oreGroup=""
								.......s updateDateTime=icuoUpdateDate+(icuoUpdateTime/100000)
								.......s curId=icuoId
								.......s icuodSub=0
								.......s ^TMPICU("Lab",$j,icuaId,updateDateTime,oreGroup_","_icucriId_","_testCode_"l",+icuoId)=$lb(curId,curIcucriId,oeoreId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,ancvcId,icuoSpeed,curDocUserId,icucriDesc,arcimDesc,icuaId,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoIcupiDr)
					....
					....
					..b //before searching test result
			..f k=1:1:$l(testCodeStr,"^") d
				...s testCode=$p(testCodeStr,"^",k)
				...q:testCode=""
				...s testQtyStr=##class(web.DHCClinicCom).GetTestResult(EpisodeID, "", "", testCode, startDate, startTime, endDate, endTime, 0)
				...//w "/testQtyStr:"_testQtyStr_"/",!
				...f l=1:1:$l(testQtyStr,"ETX") d
					....s testQty=$p(testQtyStr,ETX,l)
					....//w "testQty="_testQty,!
					....q:testQty=""
					....q:$$GetLabData("Y")<0
	s count=0
	s icuaId="" f  s icuaId=$o(^TMPICU("Lab",$j,icuaId))  q:icuaId=""  d
	 	.s updateDateTime="" f  s updateDateTime=$o(^TMPICU("Lab",$j,icuaId,updateDateTime))  q:updateDateTime=""  d
	     	..s icucriArcimId="" f  s icucriArcimId=$o(^TMPICU("Lab",$j,icuaId,updateDateTime,icucriArcimId))  q:icucriArcimId=""  d
	         	...s icuoId="" f  s icuoId=$o(^TMPICU("Lab",$j,icuaId,updateDateTime,icucriArcimId,icuoId))  q:icuoId=""  d
	             	....s Data=^TMPICU("Lab",$j,icuaId,updateDateTime,icucriArcimId,icuoId)
	             	....d OutputIcuLab
	             	....s count=count+1
	k ^TMPICU("Lab",$j)
 	s qHandle=$lb(0,repid,0)
	q $$$OK
	
GetLabData(ifByDateTime = "")
	//s curIcuoId=0,icuoId=""
	//f  s curIcuoId=$o(^DHCICUOrder(0,"OEORE",oeoreId,icuaId,"")) q:icuoId=""  d
	//	.q:"ICD"[$p(^DHCICUOrder(curIcuoId),"^",25)
	//	.s icuoId=curIcuoId
	
	s icuoStartDate=$p($g(testQty),STX,4)
	q:icuoStartDate<1 -3
	s icuoStartTime=$p($g(testQty),STX,5)
	s icuoEndDate=icuoStartDate
	s icuoEndTime=icuoStartTime
	s icuoUpdateDate=icuoStartDate
	s icuoUpdateTime=icuoStartTime
	s arcimId=testCode
	
	i (icuoEndDate=icuoStartDate)&(icuoEndTime<icuoStartTime) s icuoEndTime=icuoStartTime

	s icuoStartDateTime=icuoStartDate+(icuoStartTime/100000)
	s icuoEndDateTime=icuoEndDate+(icuoEndTime/100000)
	w icuoEndDate_"/"_icuoStartDate_"/"_icuoEndTime_"/"_icuoStartTime,!
	//w icuoStartDateTime_"/"_icuoEndDateTime_"/"_sttDateTime_"/"_icuoStartTime,"/"_icuoEndTime,!
	q:(ifByDateTime="Y")&(icuoEndDateTime'>sttDateTime) -4 //开始时间点不计
	q:(ifByDateTime="Y")&(icuoStartDateTime>endDateTime) -5 //结束时间点计入
	
	s curId="" //icuoId
	s curIcucriId="" //icucriId
	s curUserId="" //$p($g(^DHCICUOrder(+icuoId)),"^",4)
	s curStartDate=$zd(icuoStartDate,3)
	s curStartTime=$zt(icuoStartTime)
	s curEndDate=$zd(icuoEndDate,3)
	s curEndTime=$zt(icuoEndTime)
	s curNote=$p($g(testQty),STX,1)
	s curQty="" //检验结果有的是中文，所以统一给note
	s unitUomId="" 
	
	s uomId=""
	s icuoSpeed=""
	s icucriId=0,icuoId=0
	s ancvcDesc="",oeorditemStr=""
	i ancvcId'="" s ancvcDesc=$p($g(^DHCICUC("ViewCat",ancvcId)),"^",2)
	s curUpdateDate=$zd(icuoUpdateDate,3)
	s curUpdateTime=$zt(icuoUpdateTime)
	s curEditFlag=$p($g(^DHCICUOrder(+icuoId)),"^",25)
	s curDocUserId=$p($g(^DHCICUOrder(+icuoId)),"^",27)
	s icuoSource=$p($g(^DHCICUOrder(+icuoId)),"^",29)
	s mainIcuoEditFlag=$p($g(^DHCICUOrder(+icuoId)),"^",25)
	q:("ICD"[mainIcuoEditFlag)&(mainIcuoEditFlag'="") -3 //旧版本ICD
	s icucriDesc=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",2)
	;s icucriDesc="" 
	s labNo=$p($g(testQty),STX,9)
	;根据检验号找到标本号，再找到医嘱id
	
	s arcimDesc=""
	i $p(oeorditemStr,"^",6)'="" s $p(oeorditemStr,"^",6)=$p(oeorditemStr,"^",6)_"||"_oeoreSub
	s prcfrDesc=$p(oeorditemStr,"^",15)
	s oeoriNote=$p(oeorditemStr,"^",17)
	s curAbbreviate=$p($g(^DHCICUOrder(+icuoId)),"^",34)	
	s icuoOrdItemNote=$p($g(^DHCICUOrder(+icuoId)),"^",35)
	s icuoIcupiDr=$p($g(^DHCICUOrder(+icuoId)),"^",38)
	
	s oreGroup=""
	s updateDateTime=icuoUpdateDate+(icuoUpdateTime/100000)
	s curId=icuoId
	s icuodSub=0
	s testCodestr0=$p($g(testQty),STX,6)
	s testCodestr1=$p($g(testQty),STX,7)
	s testCodestr2=$p($g(testQty),STX,8)
	//q:testCodestr2="" "ww"
	s testCodestr=testCodestr0_"|"_testCodestr1_"|"_testCodestr2
	if testCodestr2="" s arcimId=testCode
	e  d
		.s arcimId=testCode_"|"_testCodestr0_"|"_testCodestr2
		.s arcimDesc=$p(^TTAB("ANT",testCodestr2),"\",1)
	////																						Id:   RecordItemId:OeoreId:UserId:StartDate:StartTime:EndDate:EndTime              :ArcimId:Note:Qty:UomId:RecordCatId  :DocUserId:AncoDesc:ArcimDesc:ArrangeId:Frequency:OeoriNote:Abbreviate:OrderItemNote:ParaItemId:durationDay:
	s ^TMPICU("Lab",$j,icuaId,updateDateTime,oreGroup_","_icucriId_"|"_testCodestr,+icuoId)=$lb(curId,curIcucriId,oeoreId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,ancvcId,curDocUserId,icucriDesc,arcimDesc,icuaId,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoIcupiDr,"")
	q 0

OutputIcuLab
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindIcuLabFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindIcuLabExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindIcuLabClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindIcuLabExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 取检验微生物数据DHC_ICU_Order
/// 入参：监护Id,就诊号EpisodeID,病区wardLocId，科室ctlocId(可为病区,为科室时找关联病区),
/// 所需要查询的显示分类ancvcCodeStr(用"^"分割的串)查，起止时间。icuoSourceStr="MA"只取手工录入数据
/// 
Query FindIcuLabByOeord(icuaId As %String, startDate As %String, endDate As %String, standardCode As %String) As %Query(ROWSPEC = "ItemName,value,ResultStr") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUView","FindIcuLabByOeord",856,"2015-12-30","2015-12-30","CultureResult-T")
/// /// d ##class(%ResultSet).RunQuery("web.DHCICUView","FindIcuLabByOeord",852,"2015-12-28","2015-12-28","CultureResult-T")
ClassMethod FindIcuLabByOeordExecute(ByRef qHandle As %Binary, icuaId As %String, startDate As %String, endDate As %String, standardCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i icuaId<1 Set qHandle=$lb(0,repid,0) Quit $$$OK


	s EpisodeID=$p(^DHCICUArrange(+icuaId),"^",1)
	q:EpisodeID="" 0
	//查找医生所下医嘱
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:oeordId="" "" //未开过医嘱
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=0
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s endTime=83999
	s sttDateTime=startDate+(startTime/100000)
	s endDateTime=endDate+(endTime/100000)
	s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s testCode2="",testCodeStr=""
	s sCode=standardCode
	s testSpec=""
	s scodeLength=$l(standardCode,"-")
	i scodeLength>1 d
		.s sCode=$p(standardCode,"-",1)
		.s testSpec= $p(standardCode,"-",2)
	f  s testCode2=$o(^TTABi("TC","NNL",$$ALPHAUP^SSUTIL4(sCode),testCode2)) q:testCode2=""  d
		.i testCodeStr'="" s testCodeStr=testCodeStr_"^"
		.s testCodeStr=testCodeStr_testCode2
	//s arcimDesc="微生物培养"

	i testSpec="U" s arcimDesc="尿培养"
	i testSpec="B" s arcimDesc="血培养"
	i testSpec="S" s arcimDesc="便培养"
	i testSpec="T" s arcimDesc="痰培养"
	s retStr="",retStrV=""
	s testCode="" f  s testCode=$o(^TDHCOldResult(1,regNo,testCode)) q:(testCode="")  d
		.q:("^"_testCodeStr_"^")'[("^"_testCode_"^")	;这块准备做个改进
		.f date=startDate:1:endDate d
			..s time="" f  s time=$o(^TDHCOldResult(1,regNo,testCode,date,time),-1) q:(time="")  d
				...s labNo="" f  s labNo=$o(^TDHCOldResult(1,regNo,testCode,date,time,labNo)) q:(labNo="")  d
					....s ts="" f  s ts=$o(^TDHCOldResult(1,regNo,testCode,date,time,labNo,ts)) q:ts=""  d
						.....s tscnt=""
						.....f  s tscnt=$o(^TDHCOldResult(1,regNo,testCode,date,time,labNo,ts,tscnt)) q:tscnt=""  d
					    	......s specCode=$p($g(^TEPI(labNo,1,ts,tscnt)),"\",46)
					    	......s specDesc=$p(^TTAB("SPEC",specCode),"\",1)
					    	......s arcimDesc=""
							......s oeordId=$o(^OEORD(0,"EpisNo",labNo,"")) //根据检验号获取医嘱
							......i oeordId'="" d
								.......s oeoriSub=$o(^OEORD(0,"EpisNo",labNo,oeordId,""))
								.......q:oeoriSub=""
								.......s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
								.......s arcimDesc=$p($g(^ARCIM(+arcimId,1,1)),"^",2)






					    	......s tc="" f  s tc=$O(^TEPI(labNo,1,ts,tscnt,"DATA",tc)) q:tc=""  d
						    	.......q:("^"_testCodeStr_"^")'[("^"_tc_"^")
						    	.......s labItemDesc=$p($g(^TTAB("TC",tc)),"\",1)	;检验项目名称
								.......s itmtype=$p(^TTAB("TC",tc),"\",3)	////Micro Pathogen||V 微生物
								.......q:itmtype'="V"
								.......s curResult=$p(^TEPI(labNo,1,ts,tscnt,"DATA",tc),"\",1)
								.......s recDateD=$p(^TEPI(labNo,1,ts,tscnt),"\",4)	
								.......s recDateT=$p(^TEPI(labNo,1,ts,tscnt),"\",5)
								.......s recDate=$zd(recDateD,3)_" "_$zt(recDateT*60,2)
								.......s ^tmpDylBlood($j,"T",recDate)=""
								.......i curResult'="" s curResult=$p(^TTAB("BUG",curResult),"\",1)
								.......s curResult=curResult_$c(13)_$c(10)_"("_specDesc_")"
								.......s retStr=recDate_"|"_curResult_"|"_labItemDesc_"|"_arcimDesc_"|"_labNo
								.......s ^TMPICU("LabMOrd",$j,labItemDesc,recDate)=retStr
								.......s antibioticId=""

								.......f  s antibioticId=$o(^TEPI(labNo,1,ts,tscnt,"DATA",tc,"ANT",antibioticId)) q:antibioticId=""  d
									........s antibioticDesc=$p(^TTAB("ANT",antibioticId),"\",1)	//抗菌药物名
									........s ctsnCode=$p($g(^TEPI(labNo,1,ts,tscnt,"DATA",tc,"ANT",antibioticId)),"\",1)  //药敏Id
									........s ctsnDesc=""
									........i ctsnCode'="" s ctsnDesc=$p($g(^TTAB("SENS",ctsnCode)),"\") //药敏结果
									........s snValue=$p($g(^TEPI(labNo,1,ts,tscnt,"DATA",tc,"ANT",antibioticId)),"\",4) //药敏值
									........i snValue'="" s snValue="("_snValue_")"


									........s retStrV=recDate_"|"_ctsnDesc_snValue_"|"_antibioticDesc_"|"_arcimDesc_"|"_labNo
									........s ^TMPICU("LabMOrd",$j,labItemDesc_":"_antibioticDesc,recDate)=retStrV
	s item="" f  s item=$o(^TMPICU("LabMOrd",$j,item))  q:item=""  d
		.s recDate="" f  s recDate=$o(^TMPICU("LabMOrd",$j,item,recDate))  q:recDate=""  d
			  ..s retData=^TMPICU("LabMOrd",$j,item,recDate)
			  ..s retDate=$p($g(^TMPICU("LabMOrd",$j,item,recDate)),"|",1)
			  ..s arcimDesc=$p($g(^TMPICU("LabMOrd",$j,item,recDate)),"|",4)
			  ..s value=$p($g(^TMPICU("LabMOrd",$j,item,recDate)),"|",3)	//描述
			  ..s resultStr=$p($g(^TMPICU("LabMOrd",$j,item,recDate)),"|",2)
			  ..s date=""  f  s date=$o(^tmpDylBlood($j,"T",date)) q:date=""  d
					...i retData'[date d
						....s retData=retData_"^"_$g(^TMPICU("LabMOrd",$j,item,date))
		.d OutputIcuLabByOrd
	k ^TMPICU("LabMOrd",$j)
	k ^tmpDylBlood
 	s qHandle=$lb(0,repid,0)
	q $$$OK



OutputIcuLabByOrd
	
 	s ^CacheTemp(repid,ind)=$lb(arcimDesc,value,retData)
 	s ind=ind+1
	q
}

ClassMethod FindIcuLabByOeordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindIcuLabByOeordExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindIcuLabByOeordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindIcuLabByOeordExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 检查医嘱项目是否是否检验医嘱
ClassMethod isLabTS(ItemMast As %String) As %String
{
	s ItemMast=$g(ItemMast)
	s RtnValue="0"
	s ItmCat=$p(^ARCIM(+ItemMast,$p(ItemMast,"||",2),1),"^",10)
	i $l(ItmCat),$d(^ARC("IC",ItmCat)){
		i $p(^ARC("IC",ItmCat),"^",7)="L" s RtnValue="1"
	}
	Quit RtnValue
}

Query FindIcuUrine(icuaId As %String, startDate As %String, startTime As %String, endDate As %String, endTime As %String, icucriCodeStr As %String = "") As %Query(ROWSPEC = "ArrangeId,RecordCatId,RecordItemId,StartDate,StartTime,Qty,Volume") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUView","FindIcuUrine",808,"2015-12-03","06:59","2015-12-04","06:59","UrineVolume")
ClassMethod FindIcuUrineExecute(ByRef qHandle As %Binary, icuaId As %String, startDate As %String, startTime As %String, endDate As %String, endTime As %String, icucriCodeStr As %String = "") As %Status
{
	s firstDT=$h
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	i icucriCodeStr="" s qHandle=$lb(0,repid,0) q $$$OK
	
	s ^tmpDyl("Urine",icuaId)=startDate_"/"_startTime_"/"_endDate_"/"_endTime
	k ^DHCICUTMP("URINE",$j)
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime="07:00"
	s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s endTime="06:59" 
	 s endTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
	s sttDateTime=startDate+(startTime/100000)
	s endDateTime=endDate+(endTime/100000)
	s dayBaseTime="07:00"
	s dayBaseTime=##class(web.DHCClinicCom).ConvertToTimeH(dayBaseTime)

	s ancvcIdStr="",icucriIdStr=""
	;通过常用医嘱代码获取常用医嘱Id
	f i=1:1:$l(icucriCodeStr,"^") d
		.s icucriCode=$p(icucriCodeStr,"^",i)
		.q:icucriCode=""
		.s $p(icucriIdStr,"^",i)=$o(^DHCICUC("RecordItem",0,"Code",icucriCode,""))
	s icuaIdList=icuaId
	q:icuaId="" ""
	k tmplistDYL
	s count=0
	f j=1:1:$l(icucriIdStr,"^") d
		.s icucriId=$p(icucriIdStr,"^",j)
		.q:icucriId=""
		.s icuStartDate=$p($g(^DHCICUArrange(+icuaId)),"^",6)	
		.i icuStartDate>startDate s startDate= icuStartDate
		.f date=startDate:1:endDate d
			..s time="",sum=""
			..f  s time=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time)) q:(time="")  d
					...q:(date=startDate)&(time<dayBaseTime)
					...s icuoId=""
					...f  s icuoId=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time,icuoId)) q:(icuoId="")  d
						....q:$$GetIcuoItem("Y")<0
						....s Data=^DHCICUTMP("URINE",$j,icuaId,actDateTime,icucriId,icuoId)
						....s curQty=$li(Data,6)
						....i time<dayBaseTime d
							.....s tmplistDYL(date-1,+"10000"_time)=curQty
							.....s tmpTimelist(date-1,+"10000"_time)=date_"^"_time
						....e  d
							.....s tmplistDYL(date,time)=curQty
							.....s tmpTimelist(date,time)=date_"^"_time
		
		s edate="" f  s edate=$o(tmplistDYL(edate)) q:edate=""  d
			.s sum=0
			.;b	;w edate
			.s etime="" f  s etime=$o(tmplistDYL(edate,etime)) q:etime=""  d
				..s sum=sum+tmplistDYL(edate,etime)
				..;b	;w sum_"/"_edate_"/"_etime
				.s $li(Data,6)=sum
				.s $li(Data,7)=sum
				.;s $li(Data,9)=tmplistDYL(edate,etime)
				.s $li(Data,4)=$zd(edate+1,3)
				.s $li(Data,5)="06:00"
				.;s $li(Data,5)=$zt($p(tmpTimelist(edate,etime),"^",2),2)
				.;s $li(Data,6)=$zd($p(tmpTimelist(edate,etime),"^",1),3)
				.;s $li(Data,7)=$zt($p(tmpTimelist(edate,etime),"^",2))
				.
				.
				.d OutIcuItem
		 
	;w count,"/"_firstDT,"/"_$h,!
	;ArrangeId,RecordCatId,RecordItemId,StartDate,StartTime,Qty,Volume
	;$lb(icuaId,ancvcId,curIcucriId,curStartDate,curStartTime,curQty,Volume)
	k ^DHCICUTMP("URINE",$j)
 	s qHandle=$lb(0,repid,0)
	q $$$OK
GetIcuoItem(ifByDateTime="")
	q:'$d(^DHCICUOrder(icuoId)) -1
	s icuoUpdateDate=$p(^DHCICUOrder(icuoId),"^",21)	;更新
	s icuoUpdateTime=$p(^DHCICUOrder(icuoId),"^",22)
	s icuoStartDate=$p(^DHCICUOrder(icuoId),"^",5)	;开始
	s icuoStartTime=$p(^DHCICUOrder(icuoId),"^",6)
	s icuoEndDate=$p(^DHCICUOrder(icuoId),"^",7)	;结束
	s icuoEndTime=$p(^DHCICUOrder(icuoId),"^",8)
	s mainIcuoEditFlag=$p(^DHCICUOrder(icuoId),"^",25)
	q:"ICD"[mainIcuoEditFlag -3 //旧版本ICD

	s icuoStartDateTime=icuoStartDate+(icuoStartTime/100000)
	s icuoEndDateTime=icuoEndDate+(icuoEndTime/100000)
	q:(ifByDateTime="Y")&(icuoEndDateTime'>sttDateTime) -4 //开始时间点不计
	q:(ifByDateTime="Y")&(icuoStartDateTime>endDateTime) -5 //结束时间点计入
	s ancvcId=$p(^DHCICUOrder(icuoId),"^",16)			//ICUO_ViewCat_Dr
	q:(icucriId="")&(ancvcId="") -8
		
	s curId=icuoId //s tmpStr=icuoId_"^"
	s curIcucriId=icucriId //s tmpStr=tmpStr_icucriId_"^"
	s curUserId=$p(^DHCICUOrder(icuoId),"^",4) // tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",4)_"^"	//ICUO_User_Dr
	s curStartDate=$zd(icuoStartDate,3) //s tmpStr=tmpStr_$ZD(icuoStartDate,3)_"^"			//ICUO_StartDate
	s curStartTime=$zt(icuoStartTime,2) //s tmpStr=tmpStr_$ZT(icuoStartTime)_"^"
	
	s curEndDate=$zd(icuoEndDate,3) //s tmpStr=tmpStr_$ZD(icuoEndDate,3)_"^"
	s curEndTime=$zt(icuoEndTime) //s tmpStr=tmpStr_$ZT(icuoEndTime)_"^"
	s curNote=$p(^DHCICUOrder(icuoId),"^",10) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",10)_"^"	//ICUO_Note num:10
	s curQty=$p(^DHCICUOrder(icuoId),"^",11) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",11)_"^"	//ICUO_Qty
	
	s uomId=$p(^DHCICUOrder(icuoId),"^",12)
	s ancvcDesc=""
	i ancvcId'="" s ancvcDesc=$p($g(^DHCICUC("ViewCat",ancvcId)),"^",2)
	s curUpdateDate=$zd(icuoUpdateDate,3) //s tmpStr=tmpStr_$ZD(icuoUpdateDate,3)_"^" //num:20
	s curUpdateTime=$zt(icuoUpdateTime) //s tmpStr=tmpStr_$ZT(icuoUpdateTime)_"^"
	s curEditFlag=$p(^DHCICUOrder(icuoId),"^",25) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",25)_"^"	//ICUO_EditFlag
	s curDocUserId=$p(^DHCICUOrder(icuoId),"^",27) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",27)_"^"	//ICUO_DocUser_Dr
	s icuoSource=$p(^DHCICUOrder(icuoId),"^",29) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",29)_"^"	//ICUO_Source
	s icucriDesc=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",2) //s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",+$p(^DHCICUOrder(icuoId),"^",2))),"^",2)_"^"
	s curAbbreviate=$p(^DHCICUOrder(icuoId),"^",34)
	s icuoIcupiDr=$p(^DHCICUOrder(icuoId),"^",38) //s tmpStr=tmpStr_"^"_$p(^DHCICUOrder(icuoId),"^",38)	//ICUO_ICUPI_Dr  total 47

	s oreGroup=""
	s actDateTime=icuoStartDate+(icuoStartTime/100000)
	s updateDateTime=icuoUpdateDate+(icuoUpdateTime/100000)
	;b	;w updateDateTime
	s curId=icuoId
	s icuodSub=0
	;b	;in
	s ^DHCICUTMP("URINE",$j,icuaId,actDateTime,icucriId,icuoId)=$lb(icuaId,ancvcId,curIcucriId,curStartDate,curStartTime,curQty)
	;$lb(curId,curIcucriId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,curNote,curQty,uomId,ancvcId,curDocUserId,icuoSource,icucriDesc,icuaId,curAbbreviate,icuoIcupiDr)
	q 0
    
OutIcuItem
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindIcuUrineFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindIcuUrineExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindIcuUrineClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindIcuUrineExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

// 取出入量数据

// 当天是7:00至当时，昨天是昨天的7:00至今天的6:59

Query FindTSummary(ctlocId, icuaId, startDate, startTime, endDate, endTime, dayBaseTime) As %Query(ROWSPEC = "ArrangeId:%String,RecordCatId:%String,RecordItemId:%String,StartDate:%String,StartTime:%String,Qty:%String,Volume:%String") [ SqlProc ]
{
}

// d ##class(%ResultSet).RunQuery("web.DHCICUView","FindTSummary","2705","808","2015-12-06","","2015-12-06","","07:00")

ClassMethod FindTSummaryExecute(ByRef qHandle As %Binary, ctlocId, icuaId, startDate, startTime, endDate, endTime, dayBaseTime) As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	//20150608
 	s icuStartDate=$p($g(^DHCICUArrange(+icuaId)),"^",6)	;开始监护日期：2015-05-07
 	s icuStartTime=$p($g(^DHCICUArrange(+icuaId)),"^",8)	;开始监护时间:8:00
 	s HStartDate=$zdh(startDate,3)	;2015-05-04
 	s HStartTime=$zth(startTime,2)	;05:00
 	;如果开始监护日期小于查询的日期:查询日期
 	;如果开始监护日期大于查询的日期：开始监护日期：
 	s ctmpTime=(+$zt(icuStartTime,2)-2)
 	i ctmpTime<0 d
 		.s tmpicuStartDate=icuStartDate-1
 		.s ctmpTime=ctmpTime+24
 	e  d
 		.s tmpicuStartDate=icuStartDate
 	i HStartDate<icuStartDate d
 		.s startDate=$zd(tmpicuStartDate,3),startTime=ctmpTime_":"_"00"
 	i (HStartDate=icuStartDate)&(HStartTime<icuStartTime) d
 		.s startDate=$zd(tmpicuStartDate,3)
 		.s startTime=ctmpTime_":"_"00"
 	;如果监护日期小于查询的日期:监护日期
 	;如果监护日期大于查询的日期：查询日期
 	s icuEndDate=$p($g(^DHCICUArrange(+icuaId)),"^",7)
 	s icuEndTime=$p($g(^DHCICUArrange(+icuaId)),"^",9)
 	s HEndDate=$zdh(endDate,3)
 	s HEndTime=$zth(endTime,2)
 	i (HEndDate>icuEndDate)&(icuEndDate'="") d
 		.s endDate=$zd(icuEndDate,3),endTime=+$zt(icuEndTime,2)
 	i (HEndDate=icuEndDate)&(HEndTime>icuEndTime) d
 		.s endDate=$zd(icuEndDate,3)
 		.s endTime=+$zt(icuEndTime,2)
 	;b
 	s ^tmpDyl("SI")=startDate_"/"_startTime_";"_endDate_"/"_endTime_";"_icuaId_"/"_dayBaseTime
	//20150608
 	s count=..GetSummaryData(ctlocId, icuaId, startDate, startTime, endDate, endTime, dayBaseTime)
 	i count=+count d
 		.f seqNum=1:1:count d
 			..s Data=$g(^TMPICUView("Summary",$j,seqNum))
 			..q:Data=""
 			..s curcomordId=$li(Data,3)
 			..q:"5361^5497^5498^5533^"'[curcomordId
 			..s starttime=$li(Data,5)
 			..q:starttime'="06:00"
 			..k ^TMPICUView("Summary",$j,seqNum)
 			..d OutPutSum
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutPutSum
	//s Data=$lb(desc,rowId)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindTSummaryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTSummaryExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindTSummaryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTSummaryExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

/// ctlocId, icuaId不能同时空，dayBaseTime是第一个班次开始时间
/// w ##class(web.DHCICUOrder).GetSummaryData(2706,489,"2015-06-07","22:00","2015-06-07","22:59","22:00")
/// w ##class(web.DHCICUOrder).GetSummaryData(2706,489,"2015-06-05","21:00","2015-06-05","21:59","21:00")
/// w ##class(web.DHCICUOrder).GetSummaryData(2706,489,"2015-06-06","03:00","2015-06-06","03:59","03:00")
ClassMethod GetSummaryData(ctlocId, icuaId, startDate, startTime, endDate, endTime, dayBaseTime, isSumAfter = 0) As %Library.String
{
	s retStr=0
	q:(ctlocId="")&(icuaId="") -1
	
	k ^TMPICUView("Summary",$j)
	s icuaIdList=icuaId
	i icuaIdList="" d
		.s icuaIdList=##class(web.DHCICUCom).FindIcuaIdList(icuaId, "", ctlocId)
	q:icuaIdList="" -2
	
	//i startDate="" s startDate=$h-1
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s endTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
	s dayBaseTime=##class(web.DHCClinicCom).ConvertToTimeH(dayBaseTime)
		
	k icucriSumList,subIcucriList
	s wardCtlocId=ctlocId
	i wardCtlocId="" s wardCtlocId=##Class(web.DHCICUCom).GetWardCtlocId("",icuaId)
	s icucioiId=0 //出入量汇总码表
	f  s icucioiId=$o(^DHCICUC("IOItem",0,"Ctloc",wardCtlocId,icucioiId)) q:icucioiId=""  d
		.q:'$d(^DHCICUC("IOItem",icucioiId))
		.q:$p(^DHCICUC("IOItem",icucioiId),"^",7)'="Y"
		.s icucioiStrategy=$p(^DHCICUC("IOItem",icucioiId),"^",10)
		.q:"^HourAndTotal^AfterTotalInOut^"'[("^"_icucioiStrategy_"^")
		.s mainIcucioiId=$p(^DHCICUC("IOItem",icucioiId),"^",9) //icucioiMainIcucioiId
		.//w wardCtlocId,"\"_icucioiId,"\",mainIcucioiId,"\"
		.q:mainIcucioiId=""
		.s mainIcucriId=$p(^DHCICUC("IOItem",mainIcucioiId),"^",4)
		.q:mainIcucriId=""
		.s subIcucriId=$p(^DHCICUC("IOItem",icucioiId),"^",4)
		.q:subIcucriId=""
		.s icucriSumList(mainIcucriId,"Hour")=0
		.s icucriSumList(mainIcucriId,"Day")=0
		.s icucriSumList(mainIcucriId,subIcucriId)=0	//20150514
		.i "HourAndTotal"=icucioiStrategy s subIcucriList(subIcucriId,mainIcucriId)=icucioiId
		.i "AfterTotalInOut"=icucioiStrategy s afterIOIcucriList(subIcucriId)=mainIcucriId_"^"_icucioiId //w "second:"_mainIcucriId,!
	s $ZT="ERROR"
	k timeList
	k ^TMPICUView("Summary",$j)
	s startDateTime=startDate+(startTime/100000)
	s endDateTime=endDate+(endTime/100000)
	s seqNum=0
	s searchStartDate=startDate
	i dayBaseTime>startTime s searchStartDate=searchStartDate-1
	f curDate=searchStartDate:1:endDate d //设置时间点
		.q:curDate=""
		.f time=0:1:23 d
			..q:(curDate=searchStartDate)&(time*3600<dayBaseTime)
			..s dateTime=curDate+(time*3600/100000)
			..q:dateTime>endDateTime //dateTime'<endDateTime
			..s timeList(dateTime)=""	//各个时间点
			..//w dateTime,!
	s firstSumTime=dayBaseTime //第一个汇总点
	i isSumAfter s firstSumTime=dayBaseTime+3600
	i firstSumTime=86400 s firstSumTime=0
	s count=0
	f i=1:1:$l(icuaIdList) d
		.s icuaId=$p(icuaIdList,"^",i)
		.q:icuaId=""
		.s icupId=$o(^DHCICUPara(0,"ICUA",icuaId,""))
		.s latestDateTime=$o(timeList("")),preDateTime=$o(timeList("")) //从第一个汇总时间点起
		.f curDate=searchStartDate:1:endDate d
			..s icuoSttTime=""
			..f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
				...q:('isSumAfter)&(curDate=searchStartDate)&(icuoSttTime<dayBaseTime) //开始时间入
				...q:(isSumAfter)&(curDate=searchStartDate)&(icuoSttTime'>dayBaseTime) //开始时间入
				...q:('isSumAfter)&(curDate=endDate)&(icuoSttTime'<endTime) //(icuoSttTime>endTime) //(icuoSttTime'<endTime)
				...q:(isSumAfter)&(curDate=endDate)&(icuoSttTime>endTime) //(icuoSttTime>endTime) //(icuoSttTime'<endTime)
				...s sttDateTime=curDate+(icuoSttTime/100000)
				...//w "      icuoSttTime:"_$zt(icuoSttTime,2),!
				...s dateTime=latestDateTime,newDateTime=latestDateTime //查找汇总整点，可多个
				...f  s dateTime=$o(timeList(dateTime)) q:(dateTime="")!(dateTime>sttDateTime)!(isSumAfter&(dateTime=sttDateTime))  d //整点小于等于数据时>;小于'<
					....//w "innernextDateTime:"_dateTime,!
					....s sumDateTime=preDateTime
					....i isSumAfter s sumDateTime=dateTime
					....i (sumDateTime-$p(sumDateTime,"."))*100000=firstSumTime d //每天开始时间，日汇总与小时相同
						.....s icucriId=""
						.....f  s icucriId=$o(icucriSumList(icucriId)) q:icucriId=""  d
							......s icucriSumList(icucriId,"Day")=$g(icucriSumList(icucriId,"Hour"))
					....//w "create! "_preDateTime_"/"_$zt((dateTime-$p(dateTime,"."))*100000)," pre:"_$zt((preDateTime-$p(preDateTime,"."))*100000),!
					....m timeList(sumDateTime)=icucriSumList //汇总时间
					....s preDateTime=dateTime
					....s newDateTime=dateTime
					....s icucriId=""
					....f  s icucriId=$o(icucriSumList(icucriId)) q:icucriId=""  d
						.....//w dateTime_"/"_icucriId_" hour:"_icucriSumList(icucriId,"Hour"),!
						.....s icucriSumList(icucriId,"Hour")=0
				...s latestDateTime=newDateTime
				...//w newDateTime
				...s icuoId=""
				...f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
					....q:'$d(^DHCICUOrder(icuoId))
					....q:"ICDRU"[$p(^DHCICUOrder(icuoId),"^",25) 
					....s icucriId=$p(^DHCICUOrder(icuoId),"^",2)				//ICUO_ComOrd_Dr
					....s arcimId=$p(^DHCICUOrder(icuoId),"^",9)
					....q:(icucriId="")
					....q:'$d(subIcucriList(icucriId))
					....//??s mainIcuoId=$p(^DHCICUOrder(icuoId),"^",36)
					....//??q:mainIcuoId'=""
					....s mainIcucriId=""
					....f  s mainIcucriId=$o(subIcucriList(icucriId,mainIcucriId)) q:mainIcucriId=""  d
						.....//q:mainIcucriId=""
						.....s icucioiId=subIcucriList(icucriId,mainIcucriId)
						.....q:icucioiId=""
						.....s icupiId=$p(^DHCICUOrder(icuoId),"^",38)
						.....//w icupiId_"/"_icupId,!
						.....q:("|"_icupiId)'[("|"_icupId_"|")
						.....s icucriSumList(mainIcucriId,"Hour")=icucriSumList(mainIcucriId,"Hour")+##class(web.DHCICUOrder).GetSumValue(icucioiId,icuoId)
						.....;w icucriSumList(mainIcucriId,"Hour")_"/"_icucioiId,!
						.....s icucriSumList(mainIcucriId,"Day")=icucriSumList(mainIcucriId,"Day")+##class(web.DHCICUOrder).GetSumValue(icucioiId,icuoId)
						.....;w icucriSumList(mainIcucriId,"Day")_"/"_icucioiId,!
						.....w icuoSttTime_" value:"_##class(web.DHCICUOrder).GetSumValue(icucioiId,icuoId)_":"_icucioiId_":"_icuoId_"/"_$p(^DHCICUC("IOItem",icucioiId),"^",2),!
		.s dateTime=latestDateTime
		.s dateTime=$o(timeList(dateTime),-1) //结束后汇总最后一次
		.i isSumAfter s dateTime=latestDateTime
		.f  s dateTime=$o(timeList(dateTime)) q:dateTime=""  d
			..m timeList(dateTime)=icucriSumList
			.. 
			..s icucriId=""
			..f  s icucriId=$o(icucriSumList(icucriId)) q:icucriId=""  d
				...;w dateTime_"/"_icucriId_" hour:"_icucriSumList(icucriId,"Hour"),!
				...i (dateTime-$p(dateTime,"."))*100000=firstSumTime s icucriSumList(icucriId,"Day")=icucriSumList(icucriId,"Hour")
				...s icucriSumList(icucriId,"Hour")=0
		.s afterIOIcucriId="" //二次汇总
		.f  s afterIOIcucriId=$o(afterIOIcucriList(afterIOIcucriId)) q:afterIOIcucriId=""  d
			..s curMainIcucriId=$p(afterIOIcucriList(afterIOIcucriId),"^")
			..q:curMainIcucriId=""
			..s icucioiId=$p(afterIOIcucriList(afterIOIcucriId),"^",2)
			..q:icucioiId=""
			..s dateTime=""
			..f  s dateTime=$o(timeList(dateTime)) q:dateTime=""  d
				...q:'$d(timeList(dateTime,afterIOIcucriId))
				...s value=##class(web.DHCICUOrder).GetSumValue(icucioiId,0,timeList(dateTime,afterIOIcucriId,"Hour"))
				...s timeList(dateTime,curMainIcucriId,"Hour")=timeList(dateTime,curMainIcucriId,"Hour")+value
				...;w timeList(dateTime,curMainIcucriId,"Hour"),!
				...s value=##class(web.DHCICUOrder).GetSumValue(icucioiId,0,timeList(dateTime,afterIOIcucriId,"Day"))
				...s timeList(dateTime,curMainIcucriId,"Day")=timeList(dateTime,curMainIcucriId,"Day")+value
				...;w timeList(dateTime,curMainIcucriId,"Day")
		.s dateTime=""
		.f  s dateTime=$o(timeList(dateTime)) q:dateTime=""  d
			..q:dateTime<startDateTime
			..s mainIcucriId=""
			..f  s mainIcucriId=$o(timeList(dateTime,mainIcucriId)) q:mainIcucriId=""  d
				...s count=count+1
				...s ancvcId=$p($g(^DHCICUC("RecordItem",mainIcucriId)),"^",5)
				...s ^TMPICUView("Summary",$j,count)=$lb(icuaId,ancvcId,mainIcucriId,$zd($p(dateTime,"."),3),$zt((dateTime-$p(dateTime,".")*100000),2),timeList(dateTime,mainIcucriId,"Hour"),timeList(dateTime,mainIcucriId,"Day"))
				...//w icuaId,"/",mainIcucriId,"/",$zd($p(dateTime,"."),3),"/",$zt((dateTime-$p(dateTime,".")*100000),2),"/",timeList(dateTime,mainIcucriId,"Hour"),"/",timeList(dateTime,mainIcucriId,"Day"),!
	q count
ERROR	; 
	q $ZE	           //得到系统返回的错误消息
 	//Quit "-1"
}

Query FindCheckOrder(icuaId As %String, startDate As %String, endDate As %String, ancvcCodeStr As %String(MAXLEN=20000) = "") As %Query(ROWSPEC = "Id,RecordItemId,OeoreId,StartDate,StartTime,EndDate,EndTime,ArcimId,Note,Qty,UomId,InstrId,RecordCatId,DoseSpeed,DocUserId,Volume,SpeedUnitId,Source,AncoDesc,ArcimDesc,ArrangeId,Instruction,Frequency,OeoriNote,Abbreviate,OrderItemNote,ParaItemId,DurationDay") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUView","FindCheckOrder",856,$h-7,$h,"ICUCheckData")
ClassMethod FindCheckOrderExecute(ByRef qHandle As %Binary, icuaId As %String, startDate As %String, endDate As %String, ancvcCodeStr As %String(MAXLEN=20000) = "") As %Status
{
	s firstDT=$h
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	s curId="",curIcucriId="",oeoreId="",curUserId="",curStartDate=""
	s curStartTime="",curEndDate="",curEndTime="",arcimId="",curNote=""
	s curQty="",uomId="",phcinId="",ancvcId="",doseSpeed=""
	s curDocUserId="",icuoVolume="",speedUnitId="",icuoSource="",icucriDesc=""
	s arcimDesc="",phcinDesc="",prcfrDesc="",oeoriNote=""
	s curAbbreviate="",icuoOrdItemNote="",icuoIcupiDr="",durationDay=""
	
	k ^TMPICU("Check",$j)
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=0
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s endTime=83999
	s sttDateTime=startDate+(startTime/100000)
	s endDateTime=endDate+(endTime/100000)
	s icucriIdStr="",ancvcIdStr=""
	s curDateTime=$h+($p($h,",",2)/100000)
	s icuaIdList=icuaId
	f i=1:1:$l(icuaIdList,"^") d
		.s icuaId=$p(icuaIdList,"^",i)
		.q:icuaId=""
		.s EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
		.q:EpisodeID=""
		.f j=1:1:$l(ancvcCodeStr,"^") d
			..s ancvcCode=$p(ancvcCodeStr,"^",j)
			..q:ancvcCode=""
			..s ancvcId=$o(^DHCICUC("ViewCat",0,ancvcCode,""))
			..q:ancvcId=""
			..s icuaStartDate=$p($g(^DHCICUArrange(icuaId)),"^",6)
			..i icuaStartDate<startDate s icuaStartDate=startDate
			..s seq=0
			..s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
			..q:oeordId="" //未开过医嘱
			..s arcimId=""
			..f  s arcimId=$o(^OEORDi(0,"ARCIM",oeordId,arcimId)) q:arcimId=""  d
    				...;b	;in1
    				...s arcicId=$p($g(^ARCIM(+arcimId,1,1)),"^",10)
    				...q:(arcicId'=621)&(arcicId'=623)
					...;b	;in2
					...s oeoriSttDate=startDate-1
					...f  s oeoriSttDate=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,oeoriSttDate)) q:oeoriSttDate=""  d
						....s oeoriSub=""
						....f  s oeoriSub=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,oeoriSttDate,oeoriSub)) q:oeoriSub=""  d
							.....
							.....s oeoreSub=0
							.....f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:oeoreSub=""  d
								......;w oeordId_"/"_arcimId_"*"
								......q:$$GetCheckOrderData("Y")<0
	;b ;1
	s count=0
	s icuaId="" f  s icuaId=$o(^TMPICU("Check",$j,icuaId))  q:icuaId=""  d
	 	.s updateDateTime="" f  s updateDateTime=$o(^TMPICU("Check",$j,icuaId,updateDateTime))  q:updateDateTime=""  d
	     	..s icucriArcimId="" f  s icucriArcimId=$o(^TMPICU("Check",$j,icuaId,updateDateTime,icucriArcimId))  q:icucriArcimId=""  d
	         	...s icuoId="" f  s icuoId=$o(^TMPICU("Check",$j,icuaId,updateDateTime,icucriArcimId,icuoId))  q:icuoId=""  d
	             	....s Data=^TMPICU("Check",$j,icuaId,updateDateTime,icucriArcimId,icuoId)
	             	....d OutputCheckOrder
	             	....s count=count+1
	k ^TMPICU("Check",$j)
 	s qHandle=$lb(0,repid,0)
	q $$$OK
	
GetCheckOrderData(ifByDateTime="")
	;w "In1"
	;b	;1//oeordId,arcimId,oeoriSttDate,oeoriSub
	s oeoriId=oeordId_"||"_oeoriSub,oeoreId=oeordId_"||"_oeoriSub_"||"_oeoreSub
	s curIcuoId=0,icuoId=""
	f  s curIcuoId=$o(^DHCICUOrder(0,"OEORE",oeoreId,icuaId,"")) q:icuoId=""  d
		.q:"ICD"[$p(^DHCICUOrder(curIcuoId),"^",25)
		.s icuoId=curIcuoId
	s icuoStartDate=$p($g(^DHCICUOrder(+icuoId)),"^",5)
	s icuoStartTime=$p($g(^DHCICUOrder(+icuoId)),"^",6)
	s icuoEndDate=$p($g(^DHCICUOrder(+icuoId)),"^",7)
	s icuoEndTime=$p($g(^DHCICUOrder(+icuoId)),"^",8)
	s icuoUpdateDate=$p($g(^DHCICUOrder(+icuoId)),"^",21)
	s icuoUpdateTime=$p($g(^DHCICUOrder(+icuoId)),"^",22)
	s oecprId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",8)
	q:oecprId="" ""
	s oecprCode=$p(^OECPR(oecprId),"^",1)
	q:oecprCode="" ""

	i icuoStartDate="" d
		.s icuoStartDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
		.s icuoStartTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
		.i (oecprCode="S")!(oecprCode="OMST")!(oecprCode="OMCQZT") d
			..s icuoStartDate=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",1)
			..s icuoStartTime=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",2)
		.e  d
			..s icuoEndDate=icuoStartDate,icuoEndTime=icuoStartTime
		.s icuoUpdateDate=icuoStartDate,icuoUpdateTime=icuoStartTime //temp!!??
	i icuoEndDate<icuoStartDate s icuoEndDate=icuoStartDate,icuoEndTime=icuoStartTime //!!
	i (icuoEndDate=icuoStartDate)&(icuoEndTime<icuoStartTime) s icuoEndTime=icuoStartTime
	//s mainIcuoEditFlag=$p($g(^DHCICUOrder(+icuoId)),"^",25)
	//q:"I"[mainIcuoEditFlag -3 //旧版本ICD

	s icuoStartDateTime=icuoStartDate+(icuoStartTime/100000)
	s icuoEndDateTime=icuoEndDate+(icuoEndTime/100000)
	//w icuoStartDateTime_"/"_icuoEndDateTime_"/"_sttDateTime_"/"_icuoStartTime,"/"_icuoEndTime,!
	q:(ifByDateTime="Y")&(icuoEndDateTime'>sttDateTime) -4 //开始时间点不计
	q:(ifByDateTime="Y")&(icuoStartDateTime>endDateTime) -5 //结束时间点计入
	//q:($p($g(^DHCICUOrder(+icuoId)),"^",29)="I")&(curDateTime-icuoStartDateTime>30) -6 //不查看三十天以上的数据，旧版一天
	
	//s arcimId=$p($g(^DHCICUOrder(+icuoId)),"^",9)				//ICUO_ARCIM_Dr
	s icucriId=$p($g(^DHCICUOrder(+icuoId)),"^",2)				//ICUO_ComOrd_Dr
	s speedUnitId=$p(^DHCICUOrder(+icuoId),"^",20)
	
	s curId=icuoId //s tmpStr=icuoId_"^"
	s curIcucriId=icucriId //s tmpStr=tmpStr_icucriId_"^"
	s curUserId=$p($g(^DHCICUOrder(+icuoId)),"^",4) // tmpStr=tmpStr_$p($g(^DHCICUOrder(+icuoId)),"^",4)_"^"	//ICUO_User_Dr
	s curStartDate=$zd(icuoStartDate,3)
	s curStartTime=$zt(icuoStartTime)
	s curEndDate=$zd(icuoEndDate,3)
	s curEndTime=$zt(icuoEndTime)
	s curNote=$p($g(^DHCICUOrder(+icuoId)),"^",10) //ICUO_Note num:10
	//s curQty=$p($g(^DHCICUOrder(+icuoId)),"^",11)	//ICUO_Qty
	s curQty=$p($g(^OEORD(oeordId,"I",+oeoriSub,2)),"^",1) //doseQty
	s unitUomId=$p($g(^OEORD(oeordId,"I",+oeoriSub,2)),"^",3)
	i curQty="" s curQty=$p($g(^OEORD(oeordId,"I",+oeoriSub,1)),"^",12) //phOrdQty
	
	s oeorditemStr=##class(web.DHCICUOrder).GetOeorditemInfo(oeoriId)
	s uomId=$p(oeorditemStr,"^",12)		
	s ancvcDesc=""
	i ancvcId'="" s ancvcDesc=$p($g(^DHCICUC("ViewCat",ancvcId)),"^",2)
	s retDosStr=##class(web.DHCICUOrder).GetDoseSpeed(+icuoId)
	s doseSpeed=$p($g(retDosStr),"^",10)
	
	s curUpdateDate=$zd(icuoUpdateDate,3) //s tmpStr=tmpStr_$ZD(icuoUpdateDate,3)_"^" //num:20
	s curUpdateTime=$zt(icuoUpdateTime) //s tmpStr=tmpStr_$ZT(icuoUpdateTime)_"^"
	s curEditFlag=$p($g(^DHCICUOrder(+icuoId)),"^",25) //s tmpStr=tmpStr_$p($g(^DHCICUOrder(+icuoId)),"^",25)_"^"	//ICUO_EditFlag
	s curDocUserId=$p($g(^DHCICUOrder(+icuoId)),"^",27) //s tmpStr=tmpStr_$p($g(^DHCICUOrder(+icuoId)),"^",27)_"^"	//ICUO_DocUser_Dr
	s icuoVolume=+$p($g(^DHCICUOrder(+icuoId)),"^",28) //s tmpStr=tmpStr_+$p($g(^DHCICUOrder(+icuoId)),"^",28)_"^"	//ICUO_Volume
	s icuoSpeedUnitDr=$p($g(^DHCICUOrder(+icuoId)),"^",20) //s tmpStr=tmpStr_$p($g(^DHCICUOrder(+icuoId)),"^",20)_"^" //ICUO_SpeedUnit_Dr
	s icuoSource=$p($g(^DHCICUOrder(+icuoId)),"^",29) //s tmpStr=tmpStr_$p($g(^DHCICUOrder(+icuoId)),"^",29)_"^"	//ICUO_Source
	s icucriDesc=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",2) //s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",+$p($g(^DHCICUOrder(+icuoId)),"^",2))),"^",2)_"^"
	s arcimDesc=$p($g(^ARCIM(+arcimId,1,1)),"^",2) //s tmpStr=tmpStr_$p($g(^ARCIM(+arcimId,1,1)),"^",2)_"^"
	i $p(oeorditemStr,"^",6)'="" s $p(oeorditemStr,"^",6)=$p(oeorditemStr,"^",6)_"||"_oeoreSub
	s phcinDesc=$p(oeorditemStr,"^",5) //s tmpStr=tmpStr_$p(oeorditemStr,"^",5)_"^"		//用法 phcinDesc  40
	s prcfrDesc=$p(oeorditemStr,"^",15) //s tmpStr=tmpStr_$p(oeorditemStr,"^",15)_"^"		//频率 num: 41
	s oeoriNote=$p(oeorditemStr,"^",17) //s tmpStr=tmpStr_$p(oeorditemStr,"^",17)_"^"		//医嘱备注 42
	s curAbbreviate=$p($g(^DHCICUOrder(+icuoId)),"^",34)
	i curAbbreviate="" s curAbbreviate=##class(web.DHCClinicCom).GetOeoriGroupDesc(oeoriId)
	//s tmpStr=tmpStr_icuoAbbreviate_"^"	//常用医嘱缩写 ICUO_Abbreviate
	//s tmpStr=tmpStr_$p($g(^DHCICUOrder(+icuoId)),"^",34)_"^"	//常用医嘱缩写 ICUO_Abbreviate
	s icuoOrdItemNote=$p($g(^DHCICUOrder(+icuoId)),"^",35) //s tmpStr=tmpStr_$p($g(^DHCICUOrder(+icuoId)),"^",35)_"^"	//HIS医嘱说明 ICUO_OrdItemNote
	s icuoIcupiDr=$p($g(^DHCICUOrder(+icuoId)),"^",38) //s tmpStr=tmpStr_"^"_$p($g(^DHCICUOrder(+icuoId)),"^",38)	//ICUO_ICUPI_Dr  total 47
	s fillerno=$p($g(^OEORD(oeordId,"I",+oeoriSub,9)),"^",12)
	s firstOeoriId=$p(fillerno,"!!",1)
	s firstStartDate=icuoStartDate
	i firstOeoriId'="" d
		.s firstOeoriSub=$p(firstOeoriId,"||",2)
		.s firstStartDate=$p($g(^OEORD(oeordId,"I",+firstOeoriSub,1)),"^",9)
	s durationDay=icuoStartDate-firstStartDate+1
	;w "durationDay="_durationDay_" /"_oeoreId,!
	
	s oreGroup=""
	s updateDateTime=icuoUpdateDate+(icuoUpdateTime/100000)
	s curId=icuoId
	s icuodSub=0
	s ^TMPICU("Check",$j,icuaId,updateDateTime,oreGroup_","_icucriId_","_arcimId,+icuoId)=$lb(curId,curIcucriId,oeoreId,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,"","",ancvcId,doseSpeed,curDocUserId,icuoVolume,speedUnitId,icuoSource,icucriDesc,arcimDesc,icuaId,phcinDesc,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoIcupiDr,"")
	q 0

    
OutputCheckOrder
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindCheckOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckOrderExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindCheckOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckOrderExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

}
