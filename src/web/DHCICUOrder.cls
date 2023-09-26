Import SQLUser

Class web.DHCICUOrder Extends web.DHCClinicCom [ ClassType = "", ProcedureBlock ]
{

/// 取监护数据DHC_ICU_Order
/// 入参：监护Id,就诊号EpisodeID,病区wardLocId，科室ctlocId(可为病区,为科室时找关联病区),
/// 所需要查询的显示分类ancvcIdStr(用"^"分割的串)查，起止时间。icuoSourceStr="MA"只取手工录入数据
Query FindIcuOrder(icuaId, startDate, startTime, endDate, endTime, EpisodeID = "", ctlocId = "", ancvcIdStr = "", icuoSourceStr = "", shiftStartTime = "") As %Query(ROWSPEC = "Id,RecordItemId,OeoreId,UserId,StartDate,StartTime,EndDate,EndTime,ArcimId,Note,Qty,UomId,Concentration,OriginalOrderId,InstrId,RecordCatId,Flag,DrugMode,Speed,UpdateDate,UpdateTime,Reason,EditFlag,EditedIcuoId,RecvLoc,DocUserId,Volume,SpeedUnitId,Source,Type,AncoDesc,ArcimDesc,PrepareIntake,AttachOeoriId,Report,ArrangeId,MainOeoreId,SubOrderId,Priority,Instruction,Frequency,OeoriNote,Abbreviate,OrderItemNote,MainIcuoId,Remarks,ParaItemId,DoseSpeed,TotalQty") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","FindIcuOrder",21,"2023-04-24","06:59","2023-04-25","06:59","","","","MAI","")
ClassMethod FindIcuOrderExecute(ByRef qHandle As %Binary, icuaId, startDate, startTime, endDate, endTime, EpisodeID = "", ctlocId = "", ancvcIdStr = "", icuoSourceStr = "", shiftStartTime = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	s ^dhcicudebug("FindIcuOrder")=icuaId_","_startDate_","_startTime_","_endDate_","_endTime_","_EpisodeID_","_ctlocId_","_ancvcIdStr_","_icuoSourceStr_","_shiftStartTime
	k ^TMPICU("Order",$j)
	//k ^TMPICU("OrderRet",$j)
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s endTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
	i shiftStartTime'="" s shiftStartTime=##class(web.DHCClinicCom).ConvertToTimeH(shiftStartTime)
	i startTime\60*60=startTime s startTime=startTime+30
	i endTime\60*60=endTime s endTime=endTime+30
	i shiftStartTime'="",shiftStartTime\60*60=shiftStartTime s shiftStartTime=shiftStartTime+30
	i (icuaId'="")&(shiftStartTime'="") d
		.s icuaStartDate=$p(^DHCICUArrange(icuaId),"^",6)
		.//i startTime<shiftStartTime s startDate=startDate-1
		.i startTime'>shiftStartTime s startDate=startDate-1
		.s startTime=shiftStartTime
		.
		.///取打印记录最早时间作为数据开始时间
		.s icuprId="",isFind=0
		.f  s icuprId=$o(^DHCICUArrange(icuaId,"PR",icuprId),-1) q:(+icuprId=0)!(isFind)  d
			..s icuprDate=$p(^DHCICUArrange(icuaId,"PR",icuprId),"^")
			..s icuprTime=$p(^DHCICUArrange(icuaId,"PR",icuprId),"^",2)
			..i ##class(web.DHCClinicCom).CompareDateTime(startDate,startTime,icuprDate,icuprTime)>0 d
				...s printSecond=icuprTime-(icuprTime\60*60)
				...//s ^tmpYpz("startDT",11)=^tmpYpz("startDT",11)_"|"_icuprId_"^"_printSecond
				...q:(printSecond=21) //小结所在行为21和22秒，跨行显示
				...s startDate=icuprDate
				...s startTime=icuprTime+1
				...s isFind=1
		.i 'isFind d //取监护开始时间
			..s startDate=icuaStartDate,startTime=$p(^DHCICUArrange(icuaId),"^",8)
			..s startTime=startTime-18000
			..i startTime<0 s startTime=startTime+86400,startDate=startDate-1
		.///取打印记录最晚时间页的结束时间作为数据结束时间
		.s icuprId=0,isFind=0
		.f  s icuprId=$o(^DHCICUArrange(icuaId,"PR",icuprId)) q:(+icuprId=0)!(isFind)  d
			..s icuprDate=$p(^DHCICUArrange(icuaId,"PR",icuprId),"^")
			..s icuprTime=$p(^DHCICUArrange(icuaId,"PR",icuprId),"^",2)
			..i ##class(web.DHCClinicCom).CompareDateTime(endDate,endTime,icuprDate,icuprTime)<1 d
				...s endDate=icuprDate
				...s endTime=icuprTime+1
				...s isFind=1
	s sttDateTime=startDate+(startTime/100000)
	s endDateTime=endDate+(endTime/100000)
	s icuaIdList=##class(web.DHCICUCom).FindIcuaIdList(icuaId, EpisodeID,ctlocId)
	i icuaIdList="" s qHandle=$lb(0,repid,0) q $$$OK
	
	//s ancvcCodeList=$g(^DHCCLSet("ICU","AllDataAncvcCode"))
	//s icucriIdStr=##class(web.DHCICUCom).GetAncoIdByAncvcCode(ancvcCodeList)
	s icucriIdStr=##class(web.DHCICUCom).GetIcucriIdByAncvcId(ancvcIdStr)
	s curDateTime=$h+($p($h,",",2)/100000)
	s fDate=startDate-1
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
	        ..q:icuoSourceStr="I"
	        ..
	        ..k adjTimeList
	        ..s icuoSttTime=""
	        ..f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
	            ...//q:(curDate=startDate)&(icuoSttTime<startTime)
	            ...//q:(curDate=endDate)&(icuoSttTime'<endTime)  //结束时间跨时间段?
	            ...k tmpCurTime //当前时间点最后修改数据记录
	            ...s haveDrug=0,haveMonData=0,haveExclude=0
	            ...s icuoId="",seq=0
	            ...f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
	                ....q:$d(^DHCICUOrder(icuoId))<1
	                ....
				    ....s ICUOICUPIDr=$p($g(^DHCICUOrder(icuoId)),"^",38)
				    ....;q:(ICUOICUPIDr="")
				    ....q:(((ICUOICUPIDr'="")&&($p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1))),"^",1)'=icuaId)))	///不是该病人对应个人模板的数据过滤 20210911
	                ....
	                ....s icucriId=$p(^DHCICUOrder(icuoId),"^",2)
	                ....q:(icucriIdStr'="")&(icucriId'="")&(("^"_icucriIdStr_"^")[("^"_icucriId_"^"))
	                ....q:$$GetIcuoData("Y")<0
	                .... 
	                ....s icucriCode=""
	                ....i icucriId'="" s icucriCode=$p($g(^DHCICUC("RecordItem",+icucriId)),"^")
	                ....q:icucriCode=""
	                ....//i (arcimId'="")!(icucriCode="UserDefinedDrugItem") s haveDrug=1
	                ....i (arcimId'="")!($p(^DHCICUC("RecordItem",+icucriId),"^",3)="D") s haveDrug=1
	                ....i (icucriCode'="NursingRecord")!($p(^DHCICUOrder(icuoId),"^",17)'="T") s haveMonData=1
	                ....
	                ....q:(arcimId="")&(icucriCode'="UserDefinedDrugItem")&(icucriCode'="NursingRecord")
	                ....q:(icucriCode="NursingRecord")&($p(^DHCICUOrder(icuoId),"^",17)'="T") //非独占时间
	                ....//q:(startTime-(startTime\60*60)>20) //非生成数据
	                ....
	                ....s adjTimeList(icuoStartDateTime)=""
	                ....s mainIcuoId=$p(^DHCICUOrder(icuoId),"^",36)
	                ....i mainIcuoId="" s mainIcuoId=icuoId
	                ....i (icucriCode="NursingRecord")&($p(^DHCICUOrder(icuoId),"^",17)="T") d
	                	.....s mainIcuoId=0_mainIcuoId //保证护理记录在后面
	                	.....s haveExclude=1
	                ....s adjTimeList(icuoStartDateTime,mainIcuoId,icuoId)=updateDateTime_"^"_oreGroup_icucriId_arcimId_"^"_icuoId
	            ...i 'haveDrug,haveMonData,haveExclude s adjTimeList(icuoStartDateTime,0,0)=0
			..s icuoStartDateTime=""
			..f  s icuoStartDateTime=$o(adjTimeList(icuoStartDateTime)) q:icuoStartDateTime=""  d
				...s mainIcuoId=$o(adjTimeList(icuoStartDateTime,"")) //第一个时间不调整
				...f  s mainIcuoId=$o(adjTimeList(icuoStartDateTime,mainIcuoId)) q:mainIcuoId=""  d
					....q //新版暂不自动调整时间
					....
					....s curDateTime=icuoStartDateTime
					....s isFind=0,newDateTime=""
					....
					....f j=1:1:20 d //暂用20个
						.....s curDateTime=curDateTime+0.00001
						.....i curDateTime-$p(curDateTime,".")>0.86399 s curDateTime=$p(curDateTime,".")+1
						.....q:$d(adjTimeList(curDateTime))
						.....q:isFind
						.....s newDateTime=curDateTime
						.....s isFind=1
					....//w mainIcuoId_"/"_icuoStartDateTime_"/"_newDateTime,!
					....q:newDateTime=""
					....s adjTimeList(newDateTime)=""
					....s adjTimeList(icuoStartDateTime,mainIcuoId)=newDateTime
					....s icuoStartTime=(icuoStartDateTime-$p(icuoStartDateTime,"."))*100000
					....s newTime=(newDateTime-$p(newDateTime,"."))*100000
					....s icuoId=""
					....f  s icuoId=$o(adjTimeList(icuoStartDateTime,mainIcuoId,icuoId)) q:icuoId=""  d
						.....s updateDateTime=$p(adjTimeList(icuoStartDateTime,mainIcuoId,icuoId),"^",1)
						.....s oreGroupStr=$p(adjTimeList(icuoStartDateTime,mainIcuoId,icuoId),"^",2)
						.....q:'$d(^TMPICU("Order",$j,icuaId,updateDateTime,oreGroupStr,icuoId))
						.....s $p(^TMPICU("Order",$j,icuaId,updateDateTime,oreGroupStr,icuoId),"^",6)=$zt(newTime)
						.....k ^DHCICUOrder(0,"SttDateTime",$p(icuoStartDateTime,"."),icuaId,icuoStartTime,icuoId)
						.....s ^DHCICUOrder(0,"SttDateTime",$p(icuoStartDateTime,"."),icuaId,newTime,icuoId)=""
						.....s $p(^DHCICUOrder(icuoId),"^",6)=newTime
	f i=1:1:$l(icuaIdList,"^") d
		.s icuaId=$p(icuaIdList,"^",i)
		.q:icuaId=""
		.f j=1:1:$l(icucriIdStr,"^") d
			..s icucriId=$p(icucriIdStr,"^",j)
			..q:icucriId=""
			..s icuoId="",seq=0
			..f  s icuoId=$o(^DHCICUOrder(0,"CommOrd",icucriId,icuaId,icuoId)) q:icuoId=""  d
				...q:$$GetIcuoData("Y")<0
	
	s icuaId="" f  s icuaId=$o(^TMPICU("Order",$j,icuaId))  q:icuaId=""  d
	 	.s updateDateTime="" f  s updateDateTime=$o(^TMPICU("Order",$j,icuaId,updateDateTime))  q:updateDateTime=""  d
	     	..s icucriArcimId="" f  s icucriArcimId=$o(^TMPICU("Order",$j,icuaId,updateDateTime,icucriArcimId))  q:icucriArcimId=""  d
	         	...s icuoId="" f  s icuoId=$o(^TMPICU("Order",$j,icuaId,updateDateTime,icucriArcimId,icuoId))  q:icuoId=""  d
	             	....//s i=i+1
	             	....//s ^TMPICU("OrderRet",$j,i)=^TMPICU("Order",$j,icuaId,updateDateTime,icucriArcimId,icuoId)
	             	....s Data=^TMPICU("Order",$j,icuaId,updateDateTime,icucriArcimId,icuoId)
	             	....d OutputIcuOrder
 	s qHandle=$lb(0,repid,0)
	q $$$OK
GetIcuoData(ifByDateTime = "")
	q:'$d(^DHCICUOrder(icuoId)) -1
	q:(icuoSourceStr'="")&(icuoSourceStr'[$p(^DHCICUOrder(icuoId),"^",29)) -2
	s icuoUpdateDate=$p(^DHCICUOrder(icuoId),"^",21)
	s icuoUpdateTime=$p(^DHCICUOrder(icuoId),"^",22)
	s icuoStartDate=$p(^DHCICUOrder(icuoId),"^",5)
	s icuoStartTime=$p(^DHCICUOrder(icuoId),"^",6)
	s icuoEndDate=$p(^DHCICUOrder(icuoId),"^",7)
	s icuoEndTime=$p(^DHCICUOrder(icuoId),"^",8)
	s mainIcuoEditFlag=$p(^DHCICUOrder(icuoId),"^",25)
	q:"I"[mainIcuoEditFlag -3 //旧版本ICD

	s icuoStartDateTime=icuoStartDate+(icuoStartTime/100000)
	s icuoEndDateTime=icuoEndDate+(icuoEndTime/100000)
	q:(ifByDateTime="Y")&(icuoEndDateTime'>sttDateTime) -4 //开始时间点不计
	q:(ifByDateTime="Y")&(icuoStartDateTime>endDateTime) -5 //结束时间点计入
	//q:($p(^DHCICUOrder(icuoId),"^",29)="I")&(curDateTime-icuoStartDateTime>30) -6 //不查看三十天以上的数据，旧版一天
	
	s arcimId=$p(^DHCICUOrder(icuoId),"^",9)				//ICUO_ARCIM_Dr
	s icucriId=$p(^DHCICUOrder(icuoId),"^",2)				//ICUO_ComOrd_Dr
	q:(icucriIdStr'="")&(("^"_icucriIdStr_"^")'[("^"_icucriId_"^")) -7
	s ancvcId=$p(^DHCICUOrder(icuoId),"^",16)			//ICUO_ViewCat_Dr
	q:(icucriId="")&(arcimId="")&(ancvcId="") -8
	s oeoreId=$p(^DHCICUOrder(icuoId),"^",3)
	s oeordId=+oeoreId
	s oeoriSub=$p(oeoreId,"||",2)
	s oeoreSub=$p(oeoreId,"||",3)
	s oeoriId=""
	i oeoriSub'="" s oeoriId=oeordId_"||"_oeoriSub
	
	i $p($g(^DHCICUC("RecordItem",+icucriId)),"^",2)="MicroPump" d
		.q:oeoriSub=""
		.s xDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",34)
    	.q:xDate=""
    	.s xTime=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",15)
		.i ##class(web.DHCClinicCom).CompareDateTime(icuoEndDate,icuoEndTime,xDate,xTime)>0 d
			..s icuoEndDate=xDate,icuoEndTime=xTime
			..i ##class(web.DHCClinicCom).CompareDateTime(icuoStartDate,icuoStartTime,icuoEndDate,icuoEndTime)>0 d
				...s icuoEndDate=icuoStartDate,icuoEndTime=icuoStartTime
			..s $p(^DHCICUOrder(icuoId),"^",7)=icuoEndDate,$p(^DHCICUOrder(icuoId),"^",8)=icuoEndTime
	
	s curId=icuoId //s tmpStr=icuoId_"^"
	s curIcucriId=icucriId //s tmpStr=tmpStr_icucriId_"^"
	//s tmpStr=tmpStr_oeoreId_"^"	//ICUO_OEORE_Dr
	s curUserId=$p(^DHCICUOrder(icuoId),"^",4) // tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",4)_"^"	//ICUO_User_Dr
	s curStartDate=$zd(icuoStartDate,3) //s tmpStr=tmpStr_$ZD(icuoStartDate,3)_"^"			//ICUO_StartDate
	s curStartTime=$zt(icuoStartTime) //s tmpStr=tmpStr_$ZT(icuoStartTime)_"^"
	s curEndDate=$zd(icuoEndDate,3) //s tmpStr=tmpStr_$ZD(icuoEndDate,3)_"^"
	s curEndTime=$zt(icuoEndTime) //s tmpStr=tmpStr_$ZT(icuoEndTime)_"^"
	//s tmpStr=tmpStr_arcimId_"^"
	s curNote=$p(^DHCICUOrder(icuoId),"^",10) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",10)_"^"	//ICUO_Note num:10
	s curQty=$p(^DHCICUOrder(icuoId),"^",11) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",11)_"^"	//ICUO_Qty
	
	s oeorditemStr=..GetOeorditemInfo(oeoriId)
	i oeorditemStr="" s oeorditemStr=..GetICUOrditemInfo(icuoId)
	s uomId=$p(^DHCICUOrder(icuoId),"^",12)
	i uomId="" s uomId=$p(oeorditemStr,"^",12)
	//s tmpStr=tmpStr_uomId_"^"	//ICUO_Uom_Dr
	s icuoConcentration=$p(^DHCICUOrder(icuoId),"^",13) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",13)_"^"	//ICUO_Concentration
	s icuoOriginateFromIcuodr=$p(^DHCICUOrder(icuoId),"^",14) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",14)_"^"	//ICUO_OriginateFromICUO_Dr
	s phcinId=$p(^DHCICUOrder(icuoId),"^",15)	
	//s tmpStr=tmpStr_phcinId_"^"	//ICUO_Instr_Dr
	s ancvcDesc=""
	i ancvcId'="" s ancvcDesc=$p($g(^DHCICUC("ViewCat",ancvcId)),"^",2)
	s doseSpeed=$p($g(^DHCICUOrder(icuoId)),"^",40)
	i (+doseSpeed=0)&(icucriId=5380) s doseSpeed=##class(web.DHCICUOrder).GetDoseSpeed(icuoId,"","DoseSpeed")
	//s tmpStr=tmpStr_ancvcId_"^" //tmpStr_ancvcDesc_"^"
	s icuoFlag=$p(^DHCICUOrder(icuoId),"^",17) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",17)_"^"	//ICUO_Flag
	s icuoDrugMode=$p(^DHCICUOrder(icuoId),"^",18) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",18)_"^"	//ICUO_DrugMode
	s icuoSpeed=$p(^DHCICUOrder(icuoId),"^",19) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",19)_"^"	//ICUO_Speed
	s curUpdateDate=$zd(icuoUpdateDate,3) //s tmpStr=tmpStr_$ZD(icuoUpdateDate,3)_"^" //num:20
	s curUpdateTime=$zt(icuoUpdateTime) //s tmpStr=tmpStr_$ZT(icuoUpdateTime)_"^"
	s icuoReason=$p(^DHCICUOrder(icuoId),"^",24) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",24)_"^"	//ICUO_Reason
	s curEditFlag=$p(^DHCICUOrder(icuoId),"^",25) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",25)_"^"	//ICUO_EditFlag
	s curEditedId=$p(^DHCICUOrder(icuoId),"^",23) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",23)_"^"	//ICUO_ICUO_DR
	s icuoRecLocId=$p(^DHCICUOrder(icuoId),"^",26) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",26)_"^"	//ICUO_RecLoc_Dr
	s curDocUserId=$p(^DHCICUOrder(icuoId),"^",27) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",27)_"^"	//ICUO_DocUser_Dr
	s icuoVolume=+$p(^DHCICUOrder(icuoId),"^",28) //s tmpStr=tmpStr_+$p(^DHCICUOrder(icuoId),"^",28)_"^"	//ICUO_Volume
	s icuoSpeedUnitDr=$p(^DHCICUOrder(icuoId),"^",20) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",20)_"^" //ICUO_SpeedUnit_Dr
	s icuoSource=$p(^DHCICUOrder(icuoId),"^",29) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",29)_"^"	//ICUO_Source
	s icuoType=$p(^DHCICUOrder(icuoId),"^",30) //tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",30)_"^"	//ICUO_Type //num:30
	s icucriDesc=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",2) //s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",+$p(^DHCICUOrder(icuoId),"^",2))),"^",2)_"^"
	s arcimDesc=$p($g(^ARCIM(+arcimId,1,1)),"^",2) //s tmpStr=tmpStr_$p($g(^ARCIM(+arcimId,1,1)),"^",2)_"^"
	s icuoPreparedVolume=+$p(^DHCICUOrder(icuoId),"^",31) //s tmpStr=tmpStr_+$p(^DHCICUOrder(icuoId),"^",31)_"^"	//ICUO_PreparedVolume
	s icuoAttachOeoriId=$p(^DHCICUOrder(icuoId),"^",32) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",32)_"^"     //ICUO_AttachOeoriId
	s icuoReportResult=$p(^DHCICUOrder(icuoId),"^",33) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",33)_"^"     //ICUO_ReportResult
	//s tmpStr=tmpStr_icuaId_"^"  //
	i $p(oeorditemStr,"^",6)'="" s $p(oeorditemStr,"^",6)=$p(oeorditemStr,"^",6)_"||"_oeoreSub
	s mainOeoriId=$p(oeorditemStr,"^",6) //s tmpStr=tmpStr_$p(oeorditemStr,"^",6)_"^"		//主医嘱mainOeoriId
	s subOeoriId=$p(oeorditemStr,"^",7) //s tmpStr=tmpStr_$p(oeorditemStr,"^",7)_"^"		//从医嘱subOeoriId
	s oecprDesc=$p(oeorditemStr,"^",13) //s tmpStr=tmpStr_$p(oeorditemStr,"^",13)_"^"		//优先级
	s phcinDesc=$p(oeorditemStr,"^",5) //s tmpStr=tmpStr_$p(oeorditemStr,"^",5)_"^"		//用法 phcinDesc  40
	s prcfrDesc=$p(oeorditemStr,"^",15) //s tmpStr=tmpStr_$p(oeorditemStr,"^",15)_"^"		//频率 num: 41
	s oeoriNote=$p(oeorditemStr,"^",17) //s tmpStr=tmpStr_$p(oeorditemStr,"^",17)_"^"		//医嘱备注 42
	s curAbbreviate=$p(^DHCICUOrder(icuoId),"^",34)
	i curAbbreviate="" s curAbbreviate=##class(web.DHCClinicCom).GetOeoriGroupDesc(oeoriId)
	//s tmpStr=tmpStr_icuoAbbreviate_"^"	//常用医嘱缩写 ICUO_Abbreviate
	//s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",34)_"^"	//常用医嘱缩写 ICUO_Abbreviate
	s icuoOrdItemNote=$p(^DHCICUOrder(icuoId),"^",35) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",35)_"^"	//HIS医嘱说明 ICUO_OrdItemNote
	s icuoMainIcuoDr=$p(^DHCICUOrder(icuoId),"^",36) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",36)_"^"	//主医嘱的ICUOId：ICUO_MainIcuo_Dr
	s icuoRemarks=$p(^DHCICUOrder(icuoId),"^",37) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",37)	//ICUO_Remarks
	s icuoIcupiDr=$p(^DHCICUOrder(icuoId),"^",38) //s tmpStr=tmpStr_"^"_$p(^DHCICUOrder(icuoId),"^",38)	//ICUO_ICUPI_Dr  total 47

	s mainOeoriSub=$p(mainOeoriId,"||",2)
	s tmpDateTime=icuoStartDate+(icuoStartTime/100000)
	s tmpSub=oeoriSub
	i mainOeoriSub="" s mainOeoriSub=oeoriSub,tmpSub=0
	s oreGroup=mainOeoriSub+((seq/100)+(tmpSub/1000000))
	
	s updateDateTime=icuoUpdateDate+(icuoUpdateTime/100000)
	s curTimeStr=icucriId_","_oeoreId_","_icuoIcupiDr_"^"_icuoStartDateTime
	s originalAncvcId=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",5)
	//i ("^"_$g(^DHCCLSet("CollectAncvcId"))_"^")[originalAncvcId s curTimeStr=icucriId_","
	i icucriId>0,"EN"[mainIcuoEditFlag,$g(tmpCurTime(curTimeStr))'="" d //clear duplicate data
		.//w updateDateTime_" update/"_icucriId_"/"_icuoId_": "_tmpCurTime(curTimeStr),!
		.i updateDateTime'<$g(tmpCurTime(curTimeStr)) d
			..k ^TMPICU("Order",$j,icuaId,$p(tmpCurTime(curTimeStr),"^"),$p(tmpCurTime(curTimeStr),"^",2),$p(tmpCurTime(curTimeStr),"^",3))
			..s clearIcuoId=+$p(tmpCurTime(curTimeStr),"^",3)
			..q:'$d(^DHCICUOrder(clearIcuoId))
			..s $p(^DHCICUOrder(clearIcuoId),"^",25)=""
			..s ^TMPICUClear(clearIcuoId)=icuaId_"/"_$h_"/"_icuoStartDateTime
		.e  d
			..//w icuoId_"/"_curTimeStr_"/"_$g(tmpCurTime(curTimeStr)),!
			..s $p(^DHCICUOrder(icuoId),"^",25)=""
			..s ^TMPICUClear(icuoId)=icuaId_"/"_$h_"/"_icuoStartDateTime
			..//w "k:"_icuoId
	q:("EN"[mainIcuoEditFlag)&(updateDateTime<$g(tmpCurTime(curTimeStr))) -11 //当前时间点有正常数据，但不是最新修改
	//i startDate=63204,icucriId=5330 w mainIcuoEditFlag_"/3:"_updateDateTime_"^"_oreGroup_","_icucriId_","_arcimId_"^"_icuoId,!
	i ("EN"[mainIcuoEditFlag)&(icucriId>0) d
		.s tmpCurTime(curTimeStr)=updateDateTime_"^"_oreGroup_","_icucriId_","_arcimId_"^"_icuoId //记录最新修改数据
	 	.//i startDate=63204,icucriId=5330 w curTimeStr_"/4:"_tmpCurTime(curTimeStr),!
	 	.//w curTimeStr_"/tmpCurTime:"_tmpCurTime(curTimeStr),!
	s curId=icuoId
	s icuodSub=0
	s totalQty=$p(^DHCICUOrder(icuoId),"^",39)
	s ^TMPICU("Order",$j,icuaId,updateDateTime,oreGroup_","_icucriId_","_arcimId,icuoId)=$lb(curId,curIcucriId,oeoreId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,icuoConcentration,icuoOriginateFromIcuodr,phcinId,ancvcId,icuoFlag,icuoDrugMode,icuoSpeed,curUpdateDate,curUpdateTime,icuoReason,curEditFlag,curEditedId,icuoRecLocId,curDocUserId,icuoVolume,icuoSpeedUnitDr,icuoSource,icuoType,icucriDesc,arcimDesc,icuoPreparedVolume,icuoAttachOeoriId,icuoReportResult,icuaId,mainOeoriId,subOeoriId,oecprDesc,phcinDesc,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoMainIcuoDr,icuoRemarks,icuoIcupiDr,doseSpeed,"")
	//s ^TMPICU("Order",$j,icuaId,updateDateTime,oreGroup_","_icucriId_","_arcimId,icuoId_","_icuodSub)=$lb(curId,curIcucriId,oeoreId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,icuoConcentration,icuoOriginateFromIcuodr,phcinId,ancvcId,icuoFlag,icuoDrugMode,icuoSpeed,curUpdateDate,curUpdateTime,icuoReason,curEditFlag,curEditedId,icuoRecLocId,curDocUserId,icuoVolume,icuoSpeedUnitDr,icuoSource,icuoType,icucriDesc,arcimDesc,icuoPreparedVolume,icuoAttachOeoriId,icuoReportResult,icuaId,mainOeoriId,subOeoriId,oecprDesc,phcinDesc,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoMainIcuoDr,icuoRemarks,icuoIcupiDr)
	//s ^TMPICU("Ordes",$j,icuaId,updateDateTime,oreGroup_","_icucriId_","_arcimId,icuoId_","_icuodSub)=curId_"^"_curIcucriId_"^"_oeoreId_"^"_curUserId_"^"_curStartDate_"^"_curStartTime_"^"_curEndDate_"^"_curEndTime_"^"_arcimId_"^"_curNote_"^"_curQty_"^"_uomId_"^"_icuoConcentration_"^"_icuoOriginateFromIcuodr_"^"_phcinId_"^"_ancvcId_"^"_icuoFlag_"^"_icuoDrugMode_"^"_icuoSpeed_"^"_curUpdateDate_"^"_curUpdateTime_"^"_icuoReason_"^"_curEditFlag_"^"_curEditedId_"^"_icuoRecLocId_"^"_curDocUserId_"^"_icuoVolume_"^"_icuoSpeedUnitDr_"^"_icuoSource_"^"_icuoType_"^"_icucriDesc_"^"_arcimDesc_"^"_icuoPreparedVolume_"^"_icuoAttachOeoriId_"^"_icuoReportResult_"^"_icuaId_"^"_mainOeoriId_"^"_subOeoriId_"^"_oecprDesc_"^"_phcinDesc_"^"_prcfrDesc_"^"_oeoriNote_"^"_curAbbreviate_"^"_icuoOrdItemNote_"^"_icuoMainIcuoDr_"^"_icuoRemarks_"^"_icuoIcupiDr
	//w "all:"_tmpStr,!
	f  s icuodSub=$o(^DHCICUOrder(icuoId,"D",icuodSub)) q:icuodSub=""  d
		.q //未用
		.
		.q:"C"[mainIcuoEditFlag
		.q:$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",12)["D"
		.s icuodStartDate=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",1)
		.s icuodStartTime=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",2)
		.s icuodStartDateTime=icuodStartDate+(icuodStartTime/100000)
		.q:endDateTime'>icuodStartDateTime
	 	.s icuodEndDate=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",3)
		.s icuodEndTime=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",4)
		.s icuodEndDateTime=icuodEndDate+(icuodEndTime/100000)
		.q:sttDateTime>icuodEndDateTime
		.
		.s curId=icuoId_"||"_icuodSub //s $p(tmpStr,"^",1)=icuoId_"||"_icuodSub
		.s curStartDate=$zd(icuodStartDate,3) //s $p(tmpStr,"^",5)=$ZD(icuodStartDate,3)
	 	.s curStartTime=$zt(icuodStartTime) //s $p(tmpStr,"^",6)=$ZT(icuodStartTime)
		.s curEndDate=$zd(icuodEndDate,3) //s $p(tmpStr,"^",7)=$ZD(icuodEndDate,3)
		.s curEndTime=$zt(icuodEndTime) //s $p(tmpStr,"^",8)=$ZT(icuodEndTime)
		.s curIcucriId=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",5) //ICUOD_ComOrd_Dr
		.s curAbbreviate=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",6) //ICUOD_Abbreviate
		.s curQty=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",7) //icuod_Qty
		.s curNote=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",8) //icuod_Note
		.s curUserId=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",9) //icuod_User_Dr
		.s curUpdateDate=$zd($p(^DHCICUOrder(icuoId,"D",icuodSub),"^",10),3) //icuod_UpdateDate
		.s curUpdateTime=$zt($p(^DHCICUOrder(icuoId,"D",icuodSub),"^",11)) //icuod_UpdateTime
		.s curEditFlag=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",12) //icuod_EditFlag
	    .s curEditedId=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",13) //icuod_icuod_Dr
		.s ^TMPICU("Order",$j,icuaId,updateDateTime,oreGroup_","_icucriId_","_arcimId,icuoId_","_icuodSub)=$lb(curId,curIcucriId,oeoreId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,icuoConcentration,icuoOriginateFromIcuodr,phcinId,ancvcId,icuoFlag,icuoDrugMode,icuoSpeed,curUpdateDate,curUpdateTime,icuoReason,curEditFlag,curEditedId,icuoRecLocId,curDocUserId,icuoVolume,icuoSpeedUnitDr,icuoSource,icuoType,icucriDesc,arcimDesc,icuoPreparedVolume,icuoAttachOeoriId,icuoReportResult,icuaId,mainOeoriId,subOeoriId,oecprDesc,phcinDesc,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoMainIcuoDr,icuoRemarks,icuoIcupiDr,"","")
		.//s ^TMPICU("Ordes",$j,icuaId,updateDateTime,oreGroup_","_icucriId_","_arcimId,icuoId_","_icuodSub)=curId_"^"_curIcucriId_"^"_oeoreId_"^"_curUserId_"^"_curStartDate_"^"_curStartTime_"^"_curEndDate_"^"_curEndTime_"^"_arcimId_"^"_curNote_"^"_curQty_"^"_uomId_"^"_icuoConcentration_"^"_icuoOriginateFromIcuodr_"^"_phcinId_"^"_ancvcId_"^"_icuoFlag_"^"_icuoDrugMode_"^"_icuoSpeed_"^"_curUpdateDate_"^"_curUpdateTime_"^"_icuoReason_"^"_curEditFlag_"^"_curEditedId_"^"_icuoRecLocId_"^"_curDocUserId_"^"_icuoVolume_"^"_icuoSpeedUnitDr_"^"_icuoSource_"^"_icuoType_"^"_icucriDesc_"^"_arcimDesc_"^"_icuoPreparedVolume_"^"_icuoAttachOeoriId_"^"_icuoReportResult_"^"_icuaId_"^"_mainOeoriId_"^"_subOeoriId_"^"_oecprDesc_"^"_phcinDesc_"^"_prcfrDesc_"^"_oeoriNote_"^"_curAbbreviate_"^"_icuoOrdItemNote_"^"_icuoMainIcuoDr_"^"_icuoRemarks_"^"_icuoIcupiDr
	q 0
GetCollectData(ifByDateTime="")
	q:'$d(^DHCICUArrange(icuaId,"C",icucdSub)) -1
	s icucdStartDate=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",2)
	s icucdStartTime=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",3)

	s icucdStartDateTime=icucdStartDate+(icucdStartTime/100000)
	s icucdEndDateTime=icucdStartDateTime
	q:(ifByDateTime="Y")&(icucdEndDateTime'>sttDateTime) -4 //开始时间点不计
	q:(ifByDateTime="Y")&(icucdStartDateTime>endDateTime) -5 //结束时间点计入
	
	s icucriId=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",1)
	q:icucriId="" -2
	s icucdUpdateDate=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",6)
	s icucdUpdateTime=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",7)
	s updateDateTime=icucdUpdateDate+(icucdUpdateTime/100000)
	
	s curId="" //s tmpStr="^" //??
	s curIcucriId=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",1) //s tmpStr=tmpStr_$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",1)_"^"
	s oeoreId="" //s tmpStr=tmpStr_"^"	//ICUO_OEORE_Dr
	s curUserId="" //s tmpStr=tmpStr_"^"	//ICUO_User_Dr
	s curStartDate=$zd($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",2),3) //s tmpStr=tmpStr_$ZD($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",2),3)_"^"	//ICUO_StartDate
	s curStartTime=$zt($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",3)) //s tmpStr=tmpStr_$ZT($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",3))_"^"
	s curEndDate=$zd($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",2),3) //s tmpStr=tmpStr_$ZD($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",2),3)_"^"
	s curEndTime=$zt($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",3)) //s tmpStr=tmpStr_$ZT($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",3))_"^"
	s arcimId="" //s tmpStr=tmpStr_"^"
	s curNote=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",4) //s tmpStr=tmpStr_$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",4)_"^"	//ICUO_Note num:10
	s curQty=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",5) //s tmpStr=tmpStr_$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",5)_"^"	//ICUO_Qty
	s uomId="" //s tmpStr=tmpStr_"^"	//ICUO_Uom_Dr
	s icuoConcentration="" //s tmpStr=tmpStr_"^"	//ICUO_Concentration
	s icuoOriginateFromIcuodr="" //s tmpStr=tmpStr_"^"	//ICUO_OriginateFromICUO_Dr
	s phcinId="" //s tmpStr=tmpStr_"^"	//ICUO_Instr_Dr
	s ancvcId=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",5) //s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",icucriId)),"^",5)_"^" //tmpStr_ancvcDesc_"^"
	s doseSpeed=""
	s icuoFlag="N" //s tmpStr=tmpStr_"N^"	//ICUO_Flag
	s icuoDrugMode="" //s tmpStr=tmpStr_"^"	//ICUO_DrugMode
	s icuoSpeed="" //s tmpStr=tmpStr_"^"	//ICUO_Speed
	s curUpdateDate=$zd(icucdUpdateDate,3) //s tmpStr=tmpStr_$ZD(icucdUpdateDate,3)_"^" //num:20
	s curUpdateTime=$zt(icucdUpdateTime) //s tmpStr=tmpStr_$ZT(icucdUpdateTime)_"^"
	s icuoReason="" //s tmpStr=tmpStr_"^"	//ICUO_Reason
	s curEditFlag="N" //s tmpStr=tmpStr_"N^"	//ICUO_EditFlag
	s curEditedId="" //s tmpStr=tmpStr_"^"	//ICUO_ICUO_DR
	s icuoRecLocId="" //s tmpStr=tmpStr_"^"	//ICUO_RecLoc_Dr
	s curDocUserId="" //s tmpStr=tmpStr_"^"	//ICUO_DocUser_Dr
	s icuoVolume=0 //s tmpStr=tmpStr_"0^"	//ICUO_Volume
	s icuoSpeedUnitDr="" //s tmpStr=tmpStr_"^" //ICUO_SpeedUnit_Dr
	s icuoSource="A" //s tmpStr=tmpStr_"A^"	//ICUO_Source
	s icuoType=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",3) //s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",icucriId)),"^",3)_"^"	//ICUO_Type //num:30
	s icucriDesc=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",2) //s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",icucriId)),"^",2)_"^"
	s arcimDesc="" //s tmpStr=tmpStr_"^"
	s icuoPreparedVolume=0 //s tmpStr=tmpStr_"0^"	//ICUO_PreparedVolume
	s icuoAttachOeoriId="" //s tmpStr=tmpStr_"^"     //ICUO_AttachOeoriId
	s icuoReportResult="" //s tmpStr=tmpStr_"^"     //ICUO_ReportResult
	//s tmpStr=tmpStr_icuaId_"^"  //
	s mainOeoriId="",subOeoriId="",oecprDesc="",phcinDesc="",prcfrDesc="",oeoriNote="",curAbbreviate="",icuoOrdItemNote="",icuoMainIcuoDr="",icuoRemarks="",icuoIcupiDr=""
	s $p(tmpStr,"^",47)="^"
	s ^TMPICU("Order",$j,icuaId,updateDateTime,icucriId,icucdSub)=$lb(curId,curIcucriId,oeoreId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,icuoConcentration,icuoOriginateFromIcuodr,phcinId,ancvcId,icuoFlag,icuoDrugMode,icuoSpeed,curUpdateDate,curUpdateTime,icuoReason,curEditFlag,curEditedId,icuoRecLocId,curDocUserId,icuoVolume,icuoSpeedUnitDr,icuoSource,icuoType,icucriDesc,arcimDesc,icuoPreparedVolume,icuoAttachOeoriId,icuoReportResult,icuaId,mainOeoriId,subOeoriId,oecprDesc,phcinDesc,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoMainIcuoDr,icuoRemarks,icuoIcupiDr,doseSpeed,"")
	q 0
    
OutputIcuOrder
	//s Data=$lb(curId,curIcucriId,oeoreId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,icuoConcentration,icuoOriginateFromIcuodr,phcinId,ancvcId,icuoFlag,icuoDrugMode,icuoSpeed,curUpdateDate,curUpdateTime,icuoReason,curEditFlag,curEditedId,icuoRecLocId,curDocUserId,icuoVolume,icuoSpeedUnitDr,icuoSource,icuoType,icucriDesc,arcimDesc,icuoPreparedVolume,icuoAttachOeoriId,icuoReportResult,icuaId,mainOeoriId,subOeoriId,oecprDesc,phcinDesc,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoMainIcuoDr,icuoRemarks,icuoIcupiDr)
	//s Data=$lb(Id,RecordItemId,OeoreId,UserId,StartDate,StartTime,EndDate,EndTime,ArcimId,Note,Qty,UomId,Concentration,OriginalOrderId,InstrId,RecordCatId,Flag,DrugMode,Speed,UpdateDate,UpdateTime,Reason,EditFlag,EditedIcuoId,RecvLoc,DocUserId,Volume,SpeedUnitId,Source,Type,icucriDesc,ArcimDesc,PrepareIntake,AttachOeoriId,Report,ArrangeId,MainOeoreId,SubOrderId,Priority,Instruction,Frequency,OeoriNote,Abbreviate,OrderItemNote,MainIcuoId,Remarks,ParaItemId)
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

/// 取监护数据DHC_ICU_Order	//新版未用
/// 入参：监护Id,就诊号EpisodeID,病区wardLocId，科室ctlocId(可为病区,为科室时找关联病区),
/// 所需要查询的常用医嘱needicuoId(用"^"分割的串)查，起止时间。icuoSourceStr="MA"只取手工录入数据
ClassMethod GetByIcuaAndDateTime(icuaId, startDate, startTime, endDate, endTime, EpisodeID = "", ctlocId = "", needIcucriId = "", icuoSourceStr = "", shiftStartTime = "")
{
	//w ##class(web.DHCICUOrder).GetByIcuaAndDateTime(8,"2008-08-29","00:00","2009-08-29","00:00")
	//w ##class(web.DHCICUOrder).GetByIcuaAndDateTime(8,61653,0,61655,0)
	k ^TMPICU("Order",$j)
	k ^TMPICU("OrderRet",$j)
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s endTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
	i shiftStartTime'="" s shiftStartTime=##class(web.DHCClinicCom).ConvertToTimeH(shiftStartTime)
	i startTime\60*60=startTime s startTime=startTime+30
	i endTime\60*60=endTime s endTime=endTime+30
	i shiftStartTime'="",shiftStartTime\60*60=shiftStartTime s shiftStartTime=shiftStartTime+30
	i (icuaId'="")&(shiftStartTime'="") d
		.s icuaStartDate=$p(^DHCICUArrange(icuaId),"^",6)
		.//i startTime<shiftStartTime s startDate=startDate-1
		.i startTime'>shiftStartTime s startDate=startDate-1
		.s startTime=shiftStartTime
		.
		.///取打印记录最早时间作为数据开始时间
		.s icuprId="",isFind=0
		.f  s icuprId=$o(^DHCICUArrange(icuaId,"PR",icuprId),-1) q:(+icuprId=0)!(isFind)  d
			..s icuprDate=$p(^DHCICUArrange(icuaId,"PR",icuprId),"^")
			..s icuprTime=$p(^DHCICUArrange(icuaId,"PR",icuprId),"^",2)
			..i ##class(web.DHCClinicCom).CompareDateTime(startDate,startTime,icuprDate,icuprTime)>0 d
				...s printSecond=icuprTime-(icuprTime\60*60)
				...//s ^tmpYpz("startDT",11)=^tmpYpz("startDT",11)_"|"_icuprId_"^"_printSecond
				...q:(printSecond=21) //小结所在行为21和22秒，跨行显示
				...s startDate=icuprDate
				...s startTime=icuprTime+1
				...s isFind=1
		.i 'isFind d //取监护开始时间
			..s startDate=icuaStartDate,startTime=$p(^DHCICUArrange(icuaId),"^",8)
			..s startTime=startTime-18000
			..i startTime<0 s startTime=startTime+86400,startDate=startDate-1
		.///取打印记录最晚时间页的结束时间作为数据结束时间
		.s icuprId=0,isFind=0
		.f  s icuprId=$o(^DHCICUArrange(icuaId,"PR",icuprId)) q:(+icuprId=0)!(isFind)  d
			..s icuprDate=$p(^DHCICUArrange(icuaId,"PR",icuprId),"^")
			..s icuprTime=$p(^DHCICUArrange(icuaId,"PR",icuprId),"^",2)
			..i ##class(web.DHCClinicCom).CompareDateTime(endDate,endTime,icuprDate,icuprTime)<1 d
				...s endDate=icuprDate
				...s endTime=icuprTime+1
				...s isFind=1
	s sttDateTime=startDate+(startTime/100000)
	s endDateTime=endDate+(endTime/100000)
	s icuaIdList=##class(web.DHCICUCom).FindIcuaIdList(icuaId, EpisodeID,ctlocId)
	q:icuaIdList="" 0
	
	s ancvcCodeList=$g(^DHCCLSet("ICU","AllDataAncvcCode"))
	s icucriIdStr=##class(web.DHCICUCom).GetAncoIdByAncvcCode(ancvcCodeList)
	s curDateTime=$h+($p($h,",",2)/100000)
	s fDate=startDate-1
	f curDate=fDate:1:endDate d
	    .f i=1:1:$l(icuaIdList,"^") d
	        ..s icuaId=$p(icuaIdList,"^",i)
	        ..i icuoSourceStr="I" d
	        	...s curTime=""
	        	...f  s curTime=$o(^DHCICUArrange(0,"CData",icuaId,curDate,curTime),-1) q:(curTime="")  d
	        		....s icucdSub=""
	        		....f  s icucdSub=$o(^DHCICUArrange(0,"CData",icuaId,curDate,curTime,icucdSub)) q:icucdSub=""  d
	        			.....q:$$GetCollectData("Y")<0
	        ..q:icuoSourceStr="I"
	        ..
	        ..k adjTimeList
	        ..s icuoSttTime=""
	        ..f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
	            ...//q:(curDate=startDate)&(icuoSttTime<startTime)
	            ...//q:(curDate=endDate)&(icuoSttTime'<endTime)  //结束时间跨时间段?
	            ...k tmpCurTime
	            ...s haveDrug=0,haveMonData=0,haveExclude=0
	            ...s icuoId="",seq=0
	            ...f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
	                ....s icucriId=$p(^DHCICUOrder(icuoId),"^",2)
	                ....q:(icucriIdStr'="")&(icucriId'="")&(("^"_icucriIdStr_"^")[("^"_icucriId_"^"))
	                ....q:$$GetIcuoData("Y")<0
	                .... 
	                ....s icucriCode=""
	                ....i icucriId'="" s icucriCode=$p(^DHCICUC("RecordItem",+icucriId),"^")
	                ....//i (arcimId'="")!(icucriCode="UserDefinedDrugItem") s haveDrug=1
	                ....i (arcimId'="")!($p(^DHCICUC("RecordItem",+icucriId),"^",3)="D") s haveDrug=1
	                ....i (icucriCode'="NursingRecord")!($p(^DHCICUOrder(icuoId),"^",17)'="T") s haveMonData=1
	                ....
	                ....q:(arcimId="")&(icucriCode'="UserDefinedDrugItem")&(icucriCode'="NursingRecord")
	                ....q:(icucriCode="NursingRecord")&($p(^DHCICUOrder(icuoId),"^",17)'="T") //非独占时间
	                ....//q:(startTime-(startTime\60*60)>20) //非生成数据
	                ....
	                ....s adjTimeList(icuoStartDateTime)=""
	                ....s mainIcuoId=$p(^DHCICUOrder(icuoId),"^",36)
	                ....i mainIcuoId="" s mainIcuoId=icuoId
	                ....i (icucriCode="NursingRecord")&($p(^DHCICUOrder(icuoId),"^",17)="T") d
	                	.....s mainIcuoId=0_mainIcuoId //保证护理记录在后面
	                	.....s haveExclude=1
	                ....s adjTimeList(icuoStartDateTime,mainIcuoId,icuoId)=updateDateTime_"^"_oreGroup_icucriId_arcimId_"^"_icuoId
	            ...i 'haveDrug,haveMonData,haveExclude s adjTimeList(icuoStartDateTime,0,0)=0
			..s icuoStartDateTime=""
			..f  s icuoStartDateTime=$o(adjTimeList(icuoStartDateTime)) q:icuoStartDateTime=""  d
				...s mainIcuoId=$o(adjTimeList(icuoStartDateTime,"")) //第一个时间不调整
				...f  s mainIcuoId=$o(adjTimeList(icuoStartDateTime,mainIcuoId)) q:mainIcuoId=""  d
					....q //新版暂不自动调整时间
					....
					....
					....s curDateTime=icuoStartDateTime
					....s isFind=0,newDateTime=""
					....
					....f j=1:1:20 d //暂用20个
						.....s curDateTime=curDateTime+0.00001
						.....i curDateTime-$p(curDateTime,".")>0.86399 s curDateTime=$p(curDateTime,".")+1
						.....q:$d(adjTimeList(curDateTime))
						.....q:isFind
						.....s newDateTime=curDateTime
						.....s isFind=1
					....//w mainIcuoId_"/"_icuoStartDateTime_"/"_newDateTime,!
					....q:newDateTime=""
					....s adjTimeList(newDateTime)=""
					....s adjTimeList(icuoStartDateTime,mainIcuoId)=newDateTime
					....s icuoStartTime=(icuoStartDateTime-$p(icuoStartDateTime,"."))*100000
					....s newTime=(newDateTime-$p(newDateTime,"."))*100000
					....s icuoId=""
					....f  s icuoId=$o(adjTimeList(icuoStartDateTime,mainIcuoId,icuoId)) q:icuoId=""  d
						.....s updateDateTime=$p(adjTimeList(icuoStartDateTime,mainIcuoId,icuoId),"^",1)
						.....s oreGroupStr=$p(adjTimeList(icuoStartDateTime,mainIcuoId,icuoId),"^",2)
						.....q:'$d(^TMPICU("Order",$j,icuaId,updateDateTime,oreGroupStr,icuoId))
						.....s $p(^TMPICU("Order",$j,icuaId,updateDateTime,oreGroupStr,icuoId),"^",6)=$zt(newTime)
						.....k ^DHCICUOrder(0,"SttDateTime",$p(icuoStartDateTime,"."),icuaId,icuoStartTime,icuoId)
						.....s ^DHCICUOrder(0,"SttDateTime",$p(icuoStartDateTime,"."),icuaId,newTime,icuoId)=""
						.....s $p(^DHCICUOrder(icuoId),"^",6)=newTime
	/*s arcimId="" f  s arcimId=$o(^TMPICU("Order",$j,arcimId))  q:arcimId=""  d
	 .s dat="" f  s dat=$o(^TMPICU("Order",$j,arcimId,dat))  q:dat=""  d
	     ..s tim="" f  s tim=$o(^TMPICU("Order",$j,arcimId,dat,tim))  q:tim=""  d
	         ...s icuoId="" f  s icuoId=$o(^TMPICU("Order",$j,arcimId,dat,tim,icuoId))  q:icuoId=""  d
	             ....s i=i+1
	             ....s ^TMPICU("OrderRet",$j,i)=^TMPICU("Order",$j,arcimId,dat,tim,icuoId)
	             ....//w i_": " _^TMPICU("OrderRet",$j,i),!
	*/
	f i=1:1:$l(icuaIdList,"^") d
		.s icuaId=$p(icuaIdList,"^",i)
		.q:icuaId=""
		.f j=1:1:$l(icucriIdStr,"^") d
			..s icucriId=$p(icucriIdStr,"^",j)
			..q:icucriId=""
			..s icuoId="",seq=0
			..f  s icuoId=$o(^DHCICUOrder(0,"CommOrd",icucriId,icuaId,icuoId)) q:icuoId=""  d
				...q:$$GetIcuoData("N")<0
	s i=0
	s icuaId="" f  s icuaId=$o(^TMPICU("Order",$j,icuaId))  q:icuaId=""  d
	 	.s updateDateTime="" f  s updateDateTime=$o(^TMPICU("Order",$j,icuaId,updateDateTime))  q:updateDateTime=""  d
	     	..s icucriArcimId="" f  s icucriArcimId=$o(^TMPICU("Order",$j,icuaId,updateDateTime,icucriArcimId))  q:icucriArcimId=""  d
	         	...s icuoId="" f  s icuoId=$o(^TMPICU("Order",$j,icuaId,updateDateTime,icucriArcimId,icuoId))  q:icuoId=""  d
	             	....s i=i+1
	             	....s ^TMPICU("OrderRet",$j,i)=^TMPICU("Order",$j,icuaId,updateDateTime,icucriArcimId,icuoId)
	             	....//w i_": " _^TMPICU("OrderRet",$j,i),!
	Quit i
GetIcuoData(ifByDateTime = "")
	q:'$d(^DHCICUOrder(icuoId)) -1
	q:(icuoSourceStr'="")&(icuoSourceStr'[$p(^DHCICUOrder(icuoId),"^",29)) -2
	s icuoUpdateDate=$p(^DHCICUOrder(icuoId),"^",21)
	s icuoUpdateTime=$p(^DHCICUOrder(icuoId),"^",22)
	s icuoStartDate=$p(^DHCICUOrder(icuoId),"^",5)
	s icuoStartTime=$p(^DHCICUOrder(icuoId),"^",6)
	s icuoEndDate=$p(^DHCICUOrder(icuoId),"^",7)
	s icuoEndTime=$p(^DHCICUOrder(icuoId),"^",8)
	s mainIcuoEditFlag=$p(^DHCICUOrder(icuoId),"^",25)
	q:"I"[mainIcuoEditFlag -3 //旧版本ICD

	s icuoStartDateTime=icuoStartDate+(icuoStartTime/100000)
	s icuoEndDateTime=icuoEndDate+(icuoEndTime/100000)
	q:(ifByDateTime="Y")&(icuoEndDateTime'>sttDateTime) -4 //开始时间点不计
	q:(ifByDateTime="Y")&(icuoStartDateTime>endDateTime) -5 //结束时间点计入
	q:($p(^DHCICUOrder(icuoId),"^",29)="I")&(curDateTime-icuoStartDateTime>30) -6 //不查看三天以上的数据，旧版一天
	
	s arcimId=$p(^DHCICUOrder(icuoId),"^",9)				//ICUO_ARCIM_Dr
	s icucriId=$p(^DHCICUOrder(icuoId),"^",2)				//ICUO_ComOrd_Dr
	q:(needIcucriId'="")&(("^"_needIcucriId_"^")'[("^"_icucriId_"^")) -7
	s ancvcId=$p(^DHCICUOrder(icuoId),"^",16)			//ICUO_ViewCat_Dr
	q:(icucriId="") -8  //&(arcimId="")&(ancvcId="") -8
	s oeoreId=$p(^DHCICUOrder(icuoId),"^",3)
	s oeordId=+oeoreId
	s oeoriSub=$p(oeoreId,"||",2)
	s oeoreSub=$p(oeoreId,"||",3)
	s oeoriId=""
	i oeoriSub'="" s oeoriId=oeordId_"||"_oeoriSub
	
	i $p(^DHCICUC("RecordItem",+icucriId),"^",2)="MicroPump" d
		.q:oeoriSub=""
		.s xDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",34)
    	.q:xDate=""
    	.s xTime=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",15)
		.i ##class(web.DHCClinicCom).CompareDateTime(icuoEndDate,icuoEndTime,xDate,xTime)>0 d
			..s icuoEndDate=xDate,icuoEndTime=xTime
			..i ##class(web.DHCClinicCom).CompareDateTime(icuoStartDate,icuoStartTime,icuoEndDate,icuoEndTime)>0 d
				...s icuoEndDate=icuoStartDate,icuoEndTime=icuoStartTime
			..s $p(^DHCICUOrder(icuoId),"^",7)=icuoEndDate,$p(^DHCICUOrder(icuoId),"^",8)=icuoEndTime
	s tmpStr=icuoId_"^"
	s tmpStr=tmpStr_icucriId_"^"
	s tmpStr=tmpStr_oeoreId_"^"	//ICUO_OEORE_Dr
	s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",4)_"^"	//ICUO_User_Dr
	s tmpStr=tmpStr_$ZD(icuoStartDate,3)_"^"					//ICUO_StartDate
	s tmpStr=tmpStr_$ZT(icuoStartTime)_"^"
	s tmpStr=tmpStr_$ZD(icuoEndDate,3)_"^"
	s tmpStr=tmpStr_$ZT(icuoEndTime)_"^"
	s tmpStr=tmpStr_arcimId_"^"
	s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",10)_"^"	//ICUO_Note num:10
	s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",11)_"^"	//ICUO_Qty
	
	s oeorditemStr=..GetOeorditemInfo(oeoriId)
	i oeorditemStr="" s oeorditemStr=..GetICUOrditemInfo(icuoId)
	s uomId=$p(^DHCICUOrder(icuoId),"^",12)
	i uomId="" s uomId=$p(oeorditemStr,"^",12)
	s tmpStr=tmpStr_uomId_"^"	//ICUO_Uom_Dr
	s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",13)_"^"	//ICUO_Concentration
	s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",14)_"^"	//ICUO_OriginateFromICUO_Dr
	s phcinId=$p(^DHCICUOrder(icuoId),"^",15)
	i phcinId="" s phcinId=$p(oeorditemStr,"^",3)	
	s tmpStr=tmpStr_phcinId_"^"	//ICUO_Instr_Dr
	//s ancvcId=$p(^DHCICUOrder(icuoId),"^",16)			//ICUO_ViewCat_Dr
	s ancvcDesc=""
	i ancvcId'="" s ancvcDesc=$p($g(^DHCICUC("ViewCat",ancvcId)),"^",2)
	s tmpStr=tmpStr_ancvcId_"^" //tmpStr_ancvcDesc_"^"
	s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",17)_"^"	//ICUO_Flag
	s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",18)_"^"	//ICUO_DrugMode
	s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",19)_"^"	//ICUO_Speed
	s tmpStr=tmpStr_$ZD(icuoUpdateDate,3)_"^" //num:20
	s tmpStr=tmpStr_$ZT(icuoUpdateTime)_"^"
	s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",24)_"^"	//ICUO_Reason
	s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",25)_"^"	//ICUO_EditFlag
	s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",23)_"^"	//ICUO_ICUO_DR
	s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",26)_"^"	//ICUO_RecLoc_Dr
	s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",27)_"^"	//ICUO_DocUser_Dr
	s tmpStr=tmpStr_+$p(^DHCICUOrder(icuoId),"^",28)_"^"	//ICUO_Volume
	s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",20)_"^" //ICUO_SpeedUnit_Dr
	s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",29)_"^"	//ICUO_Source
	s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",30)_"^"	//ICUO_Type //num:30
	s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",+$p(^DHCICUOrder(icuoId),"^",2))),"^",2)_"^"
	s tmpStr=tmpStr_$p($g(^ARCIM(+arcimId,1,1)),"^",2)_"^"
	s tmpStr=tmpStr_+$p(^DHCICUOrder(icuoId),"^",31)_"^"	//ICUO_PreparedVolume
	//s icuoId=query.GetDataByName("ICUO_RowId")
	s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",32)_"^"     //ICUO_AttachOeoriId
	s icuoReportResult=""
	s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",33)_"^"     //ICUO_ReportResult
	s tmpStr=tmpStr_icuaId_"^"  //
	i $p(oeorditemStr,"^",6)'="" s $p(oeorditemStr,"^",6)=$p(oeorditemStr,"^",6)_"||"_oeoreSub
	s tmpStr=tmpStr_$p(oeorditemStr,"^",6)_"^"		//主医嘱mainOeoriId
	s tmpStr=tmpStr_$p(oeorditemStr,"^",7)_"^"		//从医嘱subOeoriId
	s tmpStr=tmpStr_$p(oeorditemStr,"^",13)_"^"		//优先级
	s tmpStr=tmpStr_$p(oeorditemStr,"^",5)_"^"		//用法 phcinDesc  40
	s tmpStr=tmpStr_$p(oeorditemStr,"^",15)_"^"		//频率 num: 41
	s tmpStr=tmpStr_$p(oeorditemStr,"^",17)_"^"		//医嘱备注 42
	s icuoAbbreviate=$p(^DHCICUOrder(icuoId),"^",34)
	i icuoAbbreviate="" s icuoAbbreviate=##class(web.DHCClinicCom).GetOeoriGroupDesc(oeoriId)
	s tmpStr=tmpStr_icuoAbbreviate_"^"	//常用医嘱缩写 ICUO_Abbreviate
	//s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",34)_"^"	//常用医嘱缩写 ICUO_Abbreviate
	s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",35)_"^"	//HIS医嘱说明 ICUO_OrdItemNote
	s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",36)_"^"	//主医嘱的ICUOId：ICUO_MainIcuo_Dr
	s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",37)	//ICUO_Remarks
	s tmpStr=tmpStr_"^"_$p(^DHCICUOrder(icuoId),"^",38)	//ICUO_ICUPI_Dr  total 47
	//s ^TMPICU("Order",$j,icucriId_arcimId,icuoUpdateDate,icuoUpdateTime,icuoId)=tmpStr
	s mainOeoriId=$p(oeorditemStr,"^",6)
	s mainOeoriSub=$p(mainOeoriId,"||",2)
	s tmpDateTime=icuoStartDate+(icuoStartTime/100000)
	s tmpSub=oeoriSub
	i mainOeoriSub="" s mainOeoriSub=oeoriSub,tmpSub=0
	s oreGroup=mainOeoriSub+((seq/100)+(tmpSub/1000000))
	
	s updateDateTime=icuoUpdateDate+(icuoUpdateTime/100000)
	i icucriId>0,$g(tmpCurTime(icucriId))'="",updateDateTime'<$g(tmpCurTime(icucriId)) d
		.q //新版不考虑
		.k ^TMPICU("Order",$j,icuaId,$p(tmpCurTime(icucriId),"^"),$p(tmpCurTime(icucriId),"^",2),$p(tmpCurTime(icucriId),"^",3))
		.//w "k----"_icucriId_"/"_icuoId_"/"_$g(tmpCurTime(icucriId)),!
	q:(icucriId>0)&&(updateDateTime<$g(tmpCurTime(icucriId))) -11 //有正常数据，但不是最近一次修改
	i icucriId>0 s tmpCurTime(icucriId)=updateDateTime_"^"_oreGroup_","_icucriId_","_arcimId_"^"_icuoId
	//i icucriId>0 w icuoStartTime_"/"_icucriId_"/"_$g(tmpCurTime(icucriId)),!
	s icuodSub=0
	s ^TMPICU("Order",$j,icuaId,updateDateTime,oreGroup_","_icucriId_","_arcimId,icuoId_","_icuodSub)=tmpStr
	//w "all:"_tmpStr,!
	f  s icuodSub=$o(^DHCICUOrder(icuoId,"D",icuodSub)) q:icuodSub=""  d
		.q:"C"[mainIcuoEditFlag
		.q:$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",12)["D"
		.s icuodStartDate=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",1)
		.s icuodStartTime=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",2)
		.s icuodStartDateTime=icuodStartDate+(icuodStartTime/100000)
		.q:endDateTime'>icuodStartDateTime
	 	.s icuodEndDate=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",3)
		.s icuodEndTime=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",4)
		.s icuodEndDateTime=icuodEndDate+(icuodEndTime/100000)
		.q:sttDateTime>icuodEndDateTime
		.s $p(tmpStr,"^",1)=icuoId_"||"_icuodSub
		.s $p(tmpStr,"^",5)=$ZD(icuodStartDate,3)
	 	.s $p(tmpStr,"^",6)=$ZT(icuodStartTime)
		.s $p(tmpStr,"^",7)=$ZD(icuodEndDate,3)
		.s $p(tmpStr,"^",8)=$ZT(icuodEndTime)
		.s $p(tmpStr,"^",2)=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",5) //ICUOD_ComOrd_Dr
		.s $p(tmpStr,"^",43)=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",6) //ICUOD_Abbreviate
		.s $p(tmpStr,"^",11)=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",7) //icuod_Qty
		.s $p(tmpStr,"^",10)=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",8) //icuod_Note
		.s $p(tmpStr,"^",4)=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",9) //icuod_User_Dr
		.s $p(tmpStr,"^",20)=$zd($p(^DHCICUOrder(icuoId,"D",icuodSub),"^",10),3) //icuod_UpdateDate
		.s $p(tmpStr,"^",21)=$zt($p(^DHCICUOrder(icuoId,"D",icuodSub),"^",11)) //icuod_UpdateTime
		.s $p(tmpStr,"^",23)=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",12) //icuod_EditFlag
	    .s $p(tmpStr,"^",24)=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",13) ////icuod_icuod_Dr
		.s ^TMPICU("Order",$j,icuaId,updateDateTime,oreGroup_","_icucriId_","_arcimId,icuoId_","_icuodSub)=tmpStr
	q 0
GetCollectData(ifByDateTime="")
	q:'$d(^DHCICUArrange(icuaId,"C",icucdSub)) -1
	s icucdStartDate=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",2)
	s icucdStartTime=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",3)

	s icucdStartDateTime=icucdStartDate+(icucdStartTime/100000)
	s icucdEndDateTime=icucdStartDateTime
	q:(ifByDateTime="Y")&(icucdEndDateTime'>sttDateTime) -4 //开始时间点不计
	q:(ifByDateTime="Y")&(icucdStartDateTime>endDateTime) -5 //结束时间点计入
	
	s icucriId=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",1)
	q:icucriId="" -2
	s icucdUpdateDate=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",6)
	s icucdUpdateTime=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",7)
	s updateDateTime=icucdUpdateDate+(icucdUpdateTime/100000)
	s tmpStr="^" //??
	s tmpStr=tmpStr_$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",1)_"^"
	s tmpStr=tmpStr_"^"	//ICUO_OEORE_Dr
	s tmpStr=tmpStr_"^"	//ICUO_User_Dr
	s tmpStr=tmpStr_$ZD($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",2),3)_"^"					//ICUO_StartDate
	s tmpStr=tmpStr_$ZT($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",3))_"^"
	s tmpStr=tmpStr_$ZD($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",2),3)_"^"
	s tmpStr=tmpStr_$ZT($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",3))_"^"
	s tmpStr=tmpStr_"^"
	s tmpStr=tmpStr_$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",4)_"^"	//ICUO_Note num:10
	s tmpStr=tmpStr_$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",5)_"^"	//ICUO_Qty
	s tmpStr=tmpStr_"^"	//ICUO_Uom_Dr
	s tmpStr=tmpStr_"^"	//ICUO_Concentration
	s tmpStr=tmpStr_"^"	//ICUO_OriginateFromICUO_Dr
	s tmpStr=tmpStr_"^"	//ICUO_Instr_Dr
	s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",+icucriId)),"^",5)_"^" //tmpStr_ancvcDesc_"^"
	s tmpStr=tmpStr_"N^"	//ICUO_Flag
	s tmpStr=tmpStr_"^"	//ICUO_DrugMode
	s tmpStr=tmpStr_"^"	//ICUO_Speed
	s tmpStr=tmpStr_$ZD(icucdUpdateDate,3)_"^" //num:20
	s tmpStr=tmpStr_$ZT(icucdUpdateTime)_"^"
	s tmpStr=tmpStr_"^"	//ICUO_Reason
	s tmpStr=tmpStr_"N^"	//ICUO_EditFlag
	s tmpStr=tmpStr_"^"	//ICUO_ICUO_DR
	s tmpStr=tmpStr_"^"	//ICUO_RecLoc_Dr
	s tmpStr=tmpStr_"^"	//ICUO_DocUser_Dr
	s tmpStr=tmpStr_"0^"	//ICUO_Volume
	s tmpStr=tmpStr_"^" //ICUO_SpeedUnit_Dr
	s tmpStr=tmpStr_"A^"	//ICUO_Source
	s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",+icucriId)),"^",3)_"^"	//ICUO_Type //num:30
	s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",+icucriId)),"^",2)_"^"
	s tmpStr=tmpStr_"^"
	s tmpStr=tmpStr_"0^"	//ICUO_PreparedVolume
	s tmpStr=tmpStr_"^"     //ICUO_AttachOeoriId
	s tmpStr=tmpStr_"^"     //ICUO_ReportResult
	s tmpStr=tmpStr_icuaId_"^"  //
	s $p(tmpStr,"^",48)="^"
	s ^TMPICU("Order",$j,icuaId,updateDateTime,icucriId,icucdSub)=tmpStr
	q 0
}

/// 未用
ClassMethod GetIcuOrderDetail(icuaId, startDate, startTime, endDate, endTime, EpisodeID = "", ctlocId = "", needIcucriId = "", icuoSourceStr = "", shiftStartTime = "")
{
	//w ##class(web.DHCICUOrder).GetIcuOrderDetail(80,"2008-08-29","00:00","2009-08-29","00:00")
	//w ##class(web.DHCICUOrder).GetIcuOrderDetail(60,61653,0,61655,0)
	k ^TMPICU("OrderDetail",$j)
	k ^TMPICU("OrderRetDetail",$j)
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s endTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
	i shiftStartTime'="" s shiftStartTime=##class(web.DHCClinicCom).ConvertToTimeH(shiftStartTime)
	i startTime\60*60=startTime s startTime=startTime+30
	i endTime\60*60=endTime s endTime=endTime+30
	i shiftStartTime'="",shiftStartTime\60*60=shiftStartTime s shiftStartTime=shiftStartTime+30
	i (icuaId'="")&(shiftStartTime'="") d
		.s icuaStartDate=$p(^DHCICUArrange(icuaId),"^",6)
		.//i startTime<shiftStartTime s startDate=startDate-1
		.i startTime'>shiftStartTime s startDate=startDate-1
		.s startTime=shiftStartTime
		.
		.///取打印记录最早时间作为数据开始时间
		.s icuprId="",isFind=0
		.f  s icuprId=$o(^DHCICUArrange(icuaId,"PR",icuprId),-1) q:(+icuprId=0)!(isFind)  d
			..s icuprDate=$p(^DHCICUArrange(icuaId,"PR",icuprId),"^")
			..s icuprTime=$p(^DHCICUArrange(icuaId,"PR",icuprId),"^",2)
			..i ##class(web.DHCClinicCom).CompareDateTime(startDate,startTime,icuprDate,icuprTime)>0 d
				...s printSecond=icuprTime-(icuprTime\60*60)
				...//s ^tmpYpz("startDT",11)=^tmpYpz("startDT",11)_"|"_icuprId_"^"_printSecond
				...q:(printSecond=21) //小结所在行为21和22秒，跨行显示
				...s startDate=icuprDate
				...s startTime=icuprTime+1
				...s isFind=1
		.i 'isFind d //取监护开始时间
			..s startDate=icuaStartDate,startTime=$p(^DHCICUArrange(icuaId),"^",8)
			..s startTime=startTime-18000
			..i startTime<0 s startTime=startTime+86400,startDate=startDate-1
		.///取打印记录最晚时间页的结束时间作为数据结束时间
		.s icuprId=0,isFind=0
		.f  s icuprId=$o(^DHCICUArrange(icuaId,"PR",icuprId)) q:(+icuprId=0)!(isFind)  d
			..s icuprDate=$p(^DHCICUArrange(icuaId,"PR",icuprId),"^")
			..s icuprTime=$p(^DHCICUArrange(icuaId,"PR",icuprId),"^",2)
			..i ##class(web.DHCClinicCom).CompareDateTime(endDate,endTime,icuprDate,icuprTime)<1 d
				...s endDate=icuprDate
				...s endTime=icuprTime+1
				...s isFind=1
	s sttDateTime=startDate+(startTime/100000)
	s endDateTime=endDate+(endTime/100000)
	s icuaIdList=##class(web.DHCICUCom).FindIcuaIdList(icuaId, EpisodeID,ctlocId)
	q:icuaIdList="" 0
	
	s curDateTime=$h+($p($h,",",2)/100000)
	s fDate=startDate-1
	f curDate=fDate:1:endDate d
		.f i=1:1:$l(icuaIdList,"^") d
			..s icuaId=$p(icuaIdList,"^",i)
			..s icuoSttTime=""
			..f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
				...s haveDrug=0,haveMonData=0,haveExclude=0
				...s icuoId="",seq=0
				...f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
					....q:'$d(^DHCICUOrder(icuoId))
					....q:(icuoSourceStr'="")&(icuoSourceStr'[$p(^DHCICUOrder(icuoId),"^",29))
					....q:($p(^DHCICUOrder(icuoId),"^",29)="I")
					....
					....s icuoUpdateDate=$p(^DHCICUOrder(icuoId),"^",21)
					....s icuoUpdateTime=$p(^DHCICUOrder(icuoId),"^",22)
					....s icuoStartDate=$p(^DHCICUOrder(icuoId),"^",5)
					....s icuoStartTime=$p(^DHCICUOrder(icuoId),"^",6)
					....s icuoEndDate=$p(^DHCICUOrder(icuoId),"^",7)
					....s icuoEndTime=$p(^DHCICUOrder(icuoId),"^",8)
					....//q:"ICD"[$p(^DHCICUOrder(icuoId),"^",25)
					....s icuoStartDateTime=icuoStartDate+(icuoStartTime/100000)
					....s icuoEndDateTime=icuoEndDate+(icuoEndTime/100000)
					....q:icuoEndDateTime'>sttDateTime
					....q:icuoStartDateTime>endDateTime
					....
					....s icucriId=$p(^DHCICUOrder(icuoId),"^",2)				//ICUO_ComOrd_Dr
					....q:(needIcucriId'="")&(("^"_needIcucriId_"^")'[("^"_icucriId_"^"))
					....s ancvcId=$p(^DHCICUOrder(icuoId),"^",16)			//ICUO_ViewCat_Dr
					....q:(icucriId="")&(ancvcId="")
					....//q:($p($g(^DHCICUC("RecordItem",+icucriId)),"^",3)'="D")
					....s icuodSub=0
					....f  s icuodSub=$o(^DHCICUOrder(icuoId,"D",icuodSub)) q:icuodSub=""  d
						.....s tmpStr=icuoId
						.....s tmpStr=tmpStr_"^"_icuoId_"||"_icuodSub
						.....s tmpStr=tmpStr_"^"_##class(web.DHCClinicCom).ConvertToDate($p(^DHCICUOrder(icuoId,"D",icuodSub),"^",1)) //icuodStartDate
						.....s tmpStr=tmpStr_"^"_##class(web.DHCClinicCom).ConvertToTime($p(^DHCICUOrder(icuoId,"D",icuodSub),"^",2)) //icuodStartTime
						.....s tmpStr=tmpStr_"^"_##class(web.DHCClinicCom).ConvertToDate($p(^DHCICUOrder(icuoId,"D",icuodSub),"^",3)) //icuodEndDate
						.....s tmpStr=tmpStr_"^"_##class(web.DHCClinicCom).ConvertToTime($p(^DHCICUOrder(icuoId,"D",icuodSub),"^",4)) //icuodEndTime
						.....s tmpStr=tmpStr_"^"_$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",5) //		ICUODComOrdDr
						.....s tmpStr=tmpStr_"^"_$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",6) //		ICUODAbbreviate
						.....s tmpStr=tmpStr_"^"_+$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",7) //		ICUODQty
						.....s tmpStr=tmpStr_"^"_$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",8) //		ICUODNote
						.....s tmpStr=tmpStr_"^"_$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",9) //		ICUODUserDr
						.....s tmpStr=tmpStr_"^"_##class(web.DHCClinicCom).ConvertToDate($p(^DHCICUOrder(icuoId,"D",icuodSub),"^",10)) //		ICUODUpdateDate
						.....s tmpStr=tmpStr_"^"_##class(web.DHCClinicCom).ConvertToTime($p(^DHCICUOrder(icuoId,"D",icuodSub),"^",11)) //		ICUODUpdateTime
						.....s tmpStr=tmpStr_"^"_$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",12) //		ICUODEditFlag
						.....s tmpStr=tmpStr_"^"_$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",13) //		ICUODICUODDr
						.....s $p(tmpStr,"^",48)=""
						.....s ^TMPICU("OrderDetail",$j,icuaId,icuoId,icuodSub)=tmpStr
						.....//w "detail:"_tmpStr,!
	s i=0
	s icuaId="" f  s icuaId=$o(^TMPICU("OrderDetail",$j,icuaId))  q:icuaId=""  d
		.s icuoId="" f  s icuoId=$o(^TMPICU("OrderDetail",$j,icuaId,icuoId))  q:icuoId=""  d
			..s icuodSub="" f  s icuodSub=$o(^TMPICU("OrderDetail",$j,icuaId,icuoId,icuodSub))  q:icuodSub=""  d
				...s i=i+1
				...s ^TMPICU("OrderRetDetail",$j,i)=^TMPICU("OrderDetail",$j,icuaId,icuoId,icuodSub)
				...//w i_": " _^TMPICU("OrderRet",$j,i),!
	Quit i
}

ClassMethod getItems(i As %String, j As %String, node As %String = "OrderRet") As %Library.List
{
	//n (i,j,node)
	q:node="" ""
	s k=0,returnList=""
	f k=i:1:(i+j) d
	.i $d(^TMPICU(node,$j,k))=1 d
	..s returnList=returnList_$LB($LB(^TMPICU(node,$j,k)))
	..k ^TMPICU(node,$j,k)
	q returnList
}

/// 未用
Query SelectAll() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	SELECT %ID,ICUO_ICUO_DR,ICUO_ARCIM_Dr,ICUO_OriginateFromICUO_Dr,ICUO_Concentration,ICUO_DrugMode,ICUO_EditFlag,ICUO_EndDate,ICUO_EndTime,ICUO_Flag,ICUO_Instr_Dr,ICUO_SpeedUnit_Dr,ICUO_Note,ICUO_OEORE_Dr,'ICUO_ICUA_Dr->ID','ICUO_ICUA_Dr->ICUA_Adm_dr',ICUO_ViewCat_Dr,ICUO_Qty,ICUO_Reason,ICUO_Speed,ICUO_StartDate,ICUO_StartTime,ICUO_Uom_Dr,ICUO_UpdateDate,ICUO_UpdateTime,ICUO_User_Dr,ICUO_Volume FROM SQLUser.DHC_ICU_Order
}

/// 取医生医嘱OE_OrdItem
/// 入参：ifDrug为"Y"查询药品，ifDrug为"N"查询治疗，治疗医嘱大类的ID定义在^DHCCLSet("ICU","TherapyCatId")中，为空查询全部
/// 	  ifStand"Y"查询长期医嘱，为"N"查询临时医嘱，为""查询全部。
///       ifNurExecuted为"Y"查询护士已执行医嘱，ifNurExecuted为"N"查询护士未执行医嘱，为空查询全部；
/// 临时医嘱: 按医嘱表时间判,不跨天; 当天的第一条返回医嘱时间(直接显示),其它的返回分发时间(提前半小时显示),一次只显示一条
/// 长期医嘱: 按执行表时间判,会跨天(提前半小时显示),一次只显示一条
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","FindDtHealthOrderItem","9","2021-07-19","2021-07-19","Y","","")
Query FindDtHealthOrderItem(icuaId, startDate = "", endDate = "", ifDrug = "Y", ifStand = "", ifNurExecuted = "") As %Query(ROWSPEC = "Id,RecordItemId,OeoreId,UserId,StartDate,StartTime,EndDate,EndTime,ArcimId,Note,Qty,UomId,Concentration,OriginalOrderId,InstrId,RecordCatId,Flag,DrugMode,Speed,UpdateDate,UpdateTime,Reason,EditFlag,EditedIcuoId,RecvLoc,DocUserId,Volume,SpeedUnitId,Source,Type,AncoDesc,ArcimDesc,PreparedIntake,AttachOeoriId,Report,ArrangeId,MainOeoreId,SubOrderId,Priority,Instruction,Frequency,OeoriNote,Abbreviate,OrderItemNote,MainIcuoId,OrderItemStatus,OrderItemSeqNo,IcuoCtcpDesc,OriginalOrderItemId,icuoStartDateTime,Description") [ SqlProc ]
{
}

ClassMethod FindDtHealthOrderItemExecute(ByRef qHandle As %Binary, icuaId, startDate = "", endDate = "", ifDrug = "Y", ifStand = "", ifNurExecuted = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1

	k ^TMPICU("Oeore",$j)
	i icuaId="" s qHandle=$lb(0,repid,0) q $$$OK
	i ..SetMainSubIcucriList(icuaId,.mainSubIcucriList)<0 s qHandle=$lb(0,repid,0) q $$$OK

	s EpisodeID=$p(^DHCICUArrange(+icuaId),"^",1)
	q:EpisodeID="" 0

	s Config=##Class(websys.Configuration).%OpenId(1)
	s LABDATA=Config.LabDataNamespace
	s CurNamespace=$ZNSPACE

	//查找医生所下医嘱
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	i oeordId="" s qHandle=$lb(0,repid,0) q $$$OK //未开过医嘱

	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)

	s fDate=startDate-1,tDate=endDate+1
	d ##class(web.DHCICUCom).GetAdmPriorityList(1,"",.admPriorityList)
	s needArcbsId=$g(^DHCCLSet("ICU","BillSub")) //此账单子类作为药品处理ARC_BillSub
	s isOrdOnce=$g(^DHCCLSet("ICU","OrdOnce"))	 //医嘱只出现一次
	s isExecStandNow=$g(^DHCCLSet("ICU","ExecStandNow")) //是否执行当天长嘱
	s phcinStr=$g(^DHCCLSet("ICU","IgnorePhcinId")) //不需要处理的用药途径
	s ignoreFreqArcimIdStr=$g(^DHCCLSet("ICU","IgnoreFreqArcimIdStr")) //不考虑频次(Q1H,Q2H)，必须显示的医嘱
	s locId=$p($g(^DHCICUArrange(+icuaId)),"^",2)
	i (locId'="")&&($d(^DHCCLSet("ICU","IgnoreFreqArcimIdStr",locId))) d //不同科室显示医嘱
	.s ignoreFreqArcimIdStr=$g(^DHCCLSet("ICU","IgnoreFreqArcimIdStr",locId))	
	s NoIgnoreFreqArcimIdStr="" 
	i (locId'="")&&($d(^DHCCLSet("ICU","NoIgnoreFreqArcimIdStr",locId))) d //不同科室不显示医嘱
	.s NoIgnoreFreqArcimIdStr=$g(^DHCCLSet("ICU","NoIgnoreFreqArcimIdStr",locId))
	//s therapyCatIdStr=$g(^DHCCLSet("ICU","TherapyCatId"))
	s oeoriSub=0,oeoriIdStr=""
	
	s icuoAttachOeoriId=""
	s curUserId="" //ICUO_User_Dr
	s curNote=""	//ICUO_Note
	s icuoSource="M" //ICUO_Source
	s curDocUserId="" //ICUO_DocUser_Dr
	s curEndDate="" //ICUO_EndDate
	s curEndTime="" //ICUO_EndTime
	s icuoOriginateFromIcuodr="" //ICUO_Compli_Dr
	s icuoFlag="N" //ICUO_Flag
	s icuoDrugMode="" //ICUO_DrugMode
	s curUpdateDate="",curUpdateTime=""
	s icuoReason="" //ICUO_Reason
	s curEditedId="" //ICUO_ICUO_DR
	s doseTestQty=""
	s wardCtlocId=##Class(web.DHCICUCom).GetWardCtlocId("",icuaId)
	s locIdStr=##class(web.DHCClinicCom).GetLinkLocId(wardCtlocId)
	s volumeCtuomId=##Class(web.DHCClinicCom).GetVolumeCtuomId()
	s wardId=+$p($g(^DHCICUArrange(+icuaId)),"^",4)
	s abbrevLocIdStr=$g(^DHCCLSet("ICU","AbbrevLocId"))
	s isAbbrevArcim=0
	i ("^"_abbrevLocIdStr_"^")[("^"_+wardCtlocId_"^") s isAbbrevArcim=1

	s isDebug=0
	i $g(^tmpIcuDebug("DocOrd"))=icuaId s isDebug=1
	f sttDate=fDate:1:tDate d
		.s ordSttTime=""
		.;f  s oeoriSub=$o(^OEORDi(0,"StDt",sttDate,oeordId,oeoriSub)) q:(oeoriSub="")  d
		.f  s ordSttTime=$o(^OEORDi(0,"Date",oeordId,sttDate,ordSttTime))  q:ordSttTime=""  d
		..s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"Date",oeordId,sttDate,ordSttTime,oeoriSub)) q:(oeoriSub="")  d
			...i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)="//1.In"
			...
			...q:'$d(^OEORD(oeordId,"I",oeoriSub))
			...s oeoriId=oeordId_"||"_oeoriSub
			...s ordStatCode=##Class(web.DHCClinicCom).GetOrdStatCode(oeoriId)
			...;q:oeoriId'="555||9"
			...q:(ordStatCode="U")!(ordStatCode="I")
			...s oeoriXDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",34)
    		...s oeoriXTime=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",15)
    		...i oeoriXDate="" s oeoriXDate=99999
    		...s oeoriXDateTime=oeoriXDate+(oeoriXTime/100000)
    		...i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//1.1 discon & Extra Drug?"_oeoriXDate
    		...s oecprId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",8)
			...q:oecprId=""
			...;w oeoriId,!
			...;b ;0
			...s oecprCode=$p(^OECPR(oecprId),"^",1)
			...q:oecprCode=""
			...q:((ordStatCode="D")!(ordStatCode="PD"))&((oecprCode'="S")&(oecprCode'="OMST")&(oecprCode'="OMCQZT"))
			...s orcatId=##Class(web.DHCClinicCom).GetOrdCatId(oeoriId)
			...;w orcatId,!
			...q:orcatId=""
			...s ocgrpId=$p($g(^OEC("ORCAT",orcatId)),"^",15) //OEC_OrderCategoryGroup
			...s ocgrpCode=$p($g(^OEC("OCGRP",+ocgrpId)),"^",1)
			...s arcicOrderType=##Class(web.DHCClinicCom).GetOrdSubCatType(oeoriId)
			...s arcimId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",2)
			...s arcimDesc=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",2)
			...
			...;医嘱序号
			...s orderItemSeqNo=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",4)
			...;20130830+医嘱状态--
			...s orderItemStatus=""
		    ...s ordStatId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)  ;OEORI_ItemStat_DR
		    ...s orderItemStatus=$p($g(^OEC("OSTAT",+ordStatId)),"^",2)
		    ...;---
			...s ordLocId=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",2)
			...;w ordLocId,locIdStr,!
			...q:(ordLocId'="")&(("^"_locIdStr_"^")'[("^"_ordLocId_"^"))&(ordLocId'=wardCtlocId)
			...
			...s icuoType=arcicOrderType
			...s arcsgId=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",9)
			...i (arcsgId'="")&(arcsgId=needArcbsId) s icuoType="D"
			...//i arcicOrderType="R" s icuoType="D" //药品
			...i ocgrpCode="EXAM" s icuoType="L"
			...
			...i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//2.Exam & Extra Drug?"_arcsgId_"=="_needArcbsId
			...//q:("RL"'[arcicOrderType)&(ocgrpCode'="EXAM")&((arcsgId'="")&(arcsgId'=needArcbsId))&(("^"_therapyCatIdStr_"^")'[("^"_orcatId_"^"))
			...;w oeoriId,!
			...s icucriStr=..GetIcucriStr(oeoriId,icuaId)
			...;w oeoriId_"-"_icucriStr,!
			...;w oeoriId,"----",icucriStr,!
			...//s ifOmitFreq=""
			...//i icucriStr'="" s ifOmitFreq=$p(icucriStr,"^",9)
			...s icucriId=+icucriStr
			...i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//3.MappingComOrd?"
			...q:icucriId'>0
			...s curIcucriId=icucriId
			...q:'$d(^DHCICUC("RecordItem",curIcucriId))
			...s icuoType=$p($g(^DHCICUC("RecordItem",curIcucriId)),"^",3)
			...s icucriDesc=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",2) //s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",+icucriId)),"^",2)_"^"
			...s ancvcId="" //$o(^DHCICUC("ViewCat",0,"DrugIntake",""))
			...i icucriId>0 s ancvcId=$p($g(^DHCICUC("RecordItem",icucriId)),"^",5)
			...s icucriType=$p($g(^DHCICUC("RecordItem",icucriId)),"^",3)
			...
			...
			...i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//4.Drug?"_ifDrug_"/"_icuoType_"/"_icucriType
			...q:(ifDrug="Y")&(icucriType'="D") //&(icuoType'="R")&(icucriType'="D") //药品
			...
			...i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//4.1.Drug?"_ifDrug_"/"_icuoType_"/"_icucriType
			...q:(ifDrug="N")&(icucriType="D") //&((icuoType="R")!(icucriType="D")) //(("^"_therapyCatIdStr_"^")'[("^"_orcatId_"^")) //治疗
			...
			...i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//5.UnExecLab?"
			...//q:(ordStatCode'="E")&(arcicOrderType="L") //检验
			...i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//6.UnExecExam?"
			...//q:(ordStatCode'="E")&(ocgrpCode="EXAM")   //检查
			...
			...//s lIcucriId=0,icucriId=0
			...//f  s lIcucriId=$o(^DHCICUC("RecordItem",lIcucriId)) q:(lIcucriId="")!(icucriId>0)  d
			...//.i arcimId=$p($G(^DHCICUC("RecordItem",lIcucriId)),"^",4) s icucriId=lIcucriId
			...//q:"ONE^OUT"[oecprCode //取药医嘱和出院带药
			...s isStandSort=2
			...i (oecprCode="S")!(oecprCode="OMST")!(oecprCode="OMCQZT") s isStandSort=1
			...i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//7.stand?"
			...q:(ifStand="Y")&(oecprCode'="S")&(oecprCode'="OMST")&(oecprCode'="OMCQZT")
			...i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//8.normal?"
			...q:(ifStand="N")&(ifStand'="Y")&((oecprCode="S")!(oecprCode="OMST")!(oecprCode="OMCQZT"))
			...//s icucriStr=""
			...//i icucriId>0 s icucriStr=$g(^DHCICUC("RecordItem",+icucriId))
			...//i $p(icucriStr,"^",11)="" s $p(icucriStr,"^",11)=""
			...//i $p(icucriStr,"^",4)="" s $p(icucriStr,"^",4)=arcimId
			...//s $p(icucriStr,"^",5)=ancvcId
			...
			...s phcinId=+$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7)
			...i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//9.phcinStr?"
			...q:(icuoType="D")&(phcinId'="")&(("^"_phcinStr_"^")[("^"_phcinId_"^"))
			...i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//9.1 phcinStr?"
			...q:(phcinId'="")&(("^"_$g(^DHCCLSet("ICU","MicroPumpInstrId"))_"^")[("^"_phcinId_"^"))&(arcicOrderType="R")
			...i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//9.2 phcinStr?"_phcinId_"|"_arcicOrderType_"|"_icuoType
			...//q:(phcinId'="")&(arcicOrderType'="R")&(ifDrug="N")
			...q:(icuoType="D")&(ifDrug="N")
			...;b ;1
			...s phcfrFactor=1,phcfrCode=""
			...s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
			...i phcfrId'="" d 
				....s phcfrFactor=$p(^PHCFR(phcfrId),"^",2)
				....s phcfrCode=$p(^PHCFR(phcfrId),"^",1)
			...;w phcfrFactor,"%",phcfrCode,!
			...i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//9.8phcinStr?"
			...//q:(ifOmitFreq'="Y")&(phcfrCode="Ialways") //暂时写死
			...q:(phcfrCode="Ialways") //暂时写死
			...//q:(ifDrug="N")&(ifOmitFreq'="Y")&((phcfrCode="IQ1H")!(phcfrCode="IQ2H"))&(("^"_ignoreFreqArcimIdStr_"^")'[("^"_arcimId_"^"))
			...q:(ifDrug="N")&((phcfrCode="IQ1H")!(phcfrCode="IQ2H"))&(("^"_ignoreFreqArcimIdStr_"^")'[("^"_arcimId_"^"))
			...;b ;2
			...s icuoReportResult=""
			...i ocgrpCode="EXAM" s icuoReportResult=..GetRisReportResult(oeoriId)  //取检查结果
			...i arcicOrderType="L" s icuoReportResult=..GetLabReportResult(oeoriId,CurNamespace,LABDATA) //取检验结果
			...i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//10.labResult?"
			...//q:(icuoReportResult="")&(arcicOrderType="L")
			...i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//11.examResult?"
			...//q:(icuoReportResult="")&(ocgrpCode="EXAM")
			...;w icucriStr,!,arcimDesc,!,"---------------------------------------------",!
			...s oeoriSttDat=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
			...s oeoriSttTim=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
			...i $o(^OEORD(oeordId,"I",oeoriSub,"X",0))="" d //没有执行记录则插入
				....q:(oecprCode="S")!(oecprCode="OMST")!(oecprCode="OMCQZT")
				....s PLIST(0)=oeoriId
				....s PLIST(16)=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",1)  ;剂量OEORE_PhQtyOrd
				....s PLIST(26)=oeoriSttDat  ;OEORE_ExStDate
				....s PLIST(27)=oeoriSttTim ;OEORE_ExStTime
				....s PLIST(41)=0                                             ;OEORE_PhQtyIss
				....s PLIST(42)=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",1)  ;剂量OEORE_QtyAdmin
				....s PLIST(43)="TB"                                          ;OEORE_Billed
				....&sql(insert into OE_OrdExec Values :PLIST())
				....s ^TmpDebug("insertExec","Find",oeordId,oeoriSub)=$zd(+$h)_" "_$zt($p($h,",",2))
				....//i SQLCODE s ok="执行记录插入有误!"
			...
			...s icuoRecLocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
			...//s oeoriAddUserId=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)
			...//s eqUomQty=##class(web.DHCICUCom).GetEqUomQty(arcimId)
			...s doseQty=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",1)
			...s unitUomId=""
			...i doseQty'="" s unitUomId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",3)
			...i unitUomId'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)
			...i (doseQty'="")&($p(doseQty,".")="") s doseQty="0"_doseQty
			...s curQty=doseQty //ICUO_Qty
			...
			...s phcdtTimeList=""
			...s phcdtId=0
			...f  s phcdtId=$o(^PHCFR(+phcfrId,"DT",phcdtId)) q:phcdtId=""  d
				....i phcdtTimeList'="" s phcdtTimeList=phcdtTimeList_"^"
				....s phcdtTimeList=phcdtTimeList_^PHCFR(+phcfrId,"DT",phcdtId)
			...i phcdtTimeList="" s phcdtTimeList=28800
			...
			...s description=##class(web.DHCClinicCom).GetOeoriGroupDesc(oeoriId,isAbbrevArcim)
			...s curAbbreviate=description
			...
			...s oeorditemStr=..GetOeorditemInfo(oeoriId)
			...;w oeoriId,"------",oeorditemStr,!
			...i phcinId="" s phcinId=+$p(oeorditemStr,"^",3)
			...s subOeoriId=$p(oeorditemStr,"^",7) //从医嘱subOeoriId
			...s oecprDesc=$p(oeorditemStr,"^",13) //优先级
			...s phcinDesc=$p(oeorditemStr,"^",5) //用法 phcinDesc  40
			...q:((phcinDesc="口服")||(phcinDesc["鼻饲")||(phcinDesc["吸入")||(phcinDesc["外用")||(phcinDesc["漱口"))
			...;q:((phcinDesc="口服"))
			...s prcfrDesc=$p(oeorditemStr,"^",15) //频率 num: 41
			...s oeoriNote=$p(oeorditemStr,"^",17) //医嘱备注 42
			...s icuoPreparedVolume=$p(oeorditemStr,"^",18) //ICUO_PreparedVolume
			...;W icuoPreparedVolume,!
			...s icuoVolume=0 //ICUO_Volume
			...s icuoSpeedUnitDr=0 //ICUO_SpeedUnit_Dr
			...s uomId=unitUomId //ICUO_Uom_Dr
			...s icuoConcentration="" //ICUO_Concentration
			...s icuoSpeed="" //ICUO_Speed
			...i $l(icucriStr,"^")>1 d
				....s icuoSpeedUnitDr=$p(icucriStr,"^",2)
				....i $p(icucriStr,"^",3)'="" s uomId=$p(icucriStr,"^",3)
				....s icuoConcentration=$p(icucriStr,"^",4)
				....i $p(icucriStr,"^",5)>0 s curQty=$p(icucriStr,"^",5)
				....i $p(icucriStr,"^",6)>0 s icuoPreparedVolume=$p(icucriStr,"^",6)
				....i curQty'>0 s curQty=icuoPreparedVolume*icuoConcentration
				....i curQty'>0 s curQty=icuoPreparedVolume
				....//s curAbbreviate=$p(icucriStr,"^",7)
			...i +icuoSpeedUnitDr=0 d
				....s subIcucriId=""
					....f  s subIcucriId=$o(mainSubIcucriList(icucriId,subIcucriId)) q:subIcucriId=""  d
						.....i mainSubIcucriList(icucriId,subIcucriId)="Speed" s icuoSpeedUnitDr=1
			...i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//12.recordedOrder?"
			...q:(+icuoPreparedVolume>9999)&(icuoSpeedUnitDr>0)&(..RecordedOrder(oeoriId)="Y") //暂不根据配置走
			...//i (oeoriNote'="")&(ifDrug'="N") s curAbbreviate=curAbbreviate_"("_oeoriNote_")"
			...i (oeoriNote'="") d
			....i (icuoType="D") s curAbbreviate=curAbbreviate ;_"("_oeoriNote_")" ;药品
			....e  d ;非药品(治疗)
			.....s showNoteOeore=$g(^DHCCLSet("ICU","ShowNoteOeore"))
			.....i (showNoteOeore'="")&(("^"_showNoteOeore_"^")[("^"_arcimId_"^")) s curAbbreviate=curAbbreviate_"("_oeoriNote_")"
			...;b ;21
			...s originalOeoriId=""
			...i isStandSort=1 d
				....s originalOeoriId=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",12)
				....i originalOeoriId'="" s originalOeoriId=$p(originalOeoriId,"!!")
				....i originalOeoriId="" s originalOeoriId=oeoriId
			...s seq=0
			...s oeoreSub=0,oeoreId="",ifFind="N" //循环执行表，每条对应一个重症记录，没有对应上，则输出
			...f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:(oeoreSub="")!(ifFind="Y")  d
			    ....;W oeordId,"@",oeoriSub,"@",oeoreSub,!
				....//不论执行与否//q:$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",16)'=""  //不考虑在别处执行的情况
				....i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//21."_seq_"Exec?"
				....q:(ifNurExecuted="Y")&($p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",16)="")
				....i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//22."_seq_"unExec?"
				....//q:(ifNurExecuted="N")&($p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",16)'="")
				....//“停止执行”状态不显示
				....s oeoreStatusId=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",16)
				....s oeoreStatus=$p($g(^OEC("STAT",+oeoreStatusId)),"^",1)
				....q:(oeoreStatus="D")
				....
				....s oeoreId=oeoriId_"||"_oeoreSub
				....s seq=seq+1
				....;W icuoPreparedVolume,"@",icuoSpeedUnitDr,"@",seq,!
				....q:(+icuoPreparedVolume>9999)&(icuoSpeedUnitDr>0)&(seq>1)
				....s oeoreDate=oeoriSttDat //!会转日期和时间，不可移到上一循环
				....s oeoreTime=oeoriSttTim
				....i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//23."_seq_"Normal?"
				....q:(oecprCode'="S")&(oecprCode'="OMST")&(oecprCode'="OMCQZT")&(oeoreDate<startDate) //临嘱开始时间早于查询日期
				....s icuoCtcpDesc=""
				....
				....s curOeoreId=oeoriId_"||"_oeoreSub
				....s curIcuoId="",quitFlag=0,icuoEditFlag="",icuoId="",icuoStartDate=0,icuoStartTime=0
				....;W curOeoreId
				....f  s curIcuoId=$o(^DHCICUOrder(0,"OEORE",curOeoreId,icuaId,curIcuoId)) q:((curIcuoId="")!(quitFlag))  d
				    .....;W curIcuoId,"123",!
					.....q:'$d(^DHCICUOrder(+curIcuoId))
					.....s tmpIcuoEditFlag=$p(^DHCICUOrder(+curIcuoId),"^",25)
					.....i icuoEditFlag="" s icuoEditFlag=tmpIcuoEditFlag
					.....i (tmpIcuoEditFlag'="")&(("^N^E^")[("^"_tmpIcuoEditFlag_"^")) d
					......s icuoEditFlag=tmpIcuoEditFlag
					......s icuoPreparedVolume=$p(^DHCICUOrder(+curIcuoId),"^",31)
					.....e  q
					.....;i (("^N^E^")[("^"_icuoEditFlag_"^"))&(isOrdOnce="Y") s ifFind="Y"
					.....;i ("^N^E^")[("^"_icuoEditFlag_"^") s quitFlag=1 q //停止"D"视为未输入,相当于未处理过
					.....s icuoId=curIcuoId
					.....s icuoUserId=$p(^DHCICUOrder(+curIcuoId),"^",4)
					.....s ctcpId=$p($g(^SSU("SSUSR",+icuoUserId)),"^",14)
					.....s icuoCtcpDesc=$p($g(^CTPCP(+ctcpId,1)),"^",2)
					.....;W icuoCtcpDesc,!
					.....s curStartDate=$p(^DHCICUOrder(+curIcuoId),"^",5)
					.....s curStartTime=$p(^DHCICUOrder(+curIcuoId),"^",6)
					.....i icuoStartDate=0 s icuoStartDate=curStartDate s icuoStartTime=curStartTime
					.....s startDateTime=icuoStartDate*100000+icuoStartTime
					.....s curStartDateTime=icuoStartDate*100000+icuoStartTime
					.....i curStartDateTime<startDateTime s icuoStartDate=curStartDate s icuoStartTime=curStartTime
					.....
				....i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//24."_seq_"icuOrdered?"
				....q:quitFlag
				....i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//25."_seq_"updated?"
				....//q:($p(^DHCICUOrder(+icuoId),"^",14)'="")&(icuoEditFlag'="D") //ICUO_OriginateFromICUO_Dr 余液数据
				....//分发时间为1的临嘱取医嘱时间,不计时
				....i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//25.1:"_seq_"updated?"
				....//i (phcfrFactor=1)&(oecprCode'="S")&(oecprCode'="OMST") s oeoreId=curOeoreId q //100708
				....//调整临时医嘱的分发时间
				....i (oecprCode'="S")&(oecprCode'="OMST")&(oecprCode'="OMCQZT") d
					.....q:phcfrFactor=1 //无频次为1
					.....//q:seq=1
					.....s oeoreTime=$p(phcdtTimeList,"^",seq)
				....e  d //长嘱
					.....q:(+icuoPreparedVolume>9999)&(icuoSpeedUnitDr>0)
					.....s oeoreDate=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",1)
					.....s oeoreTime=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",2)
					.....i ifNurExecuted="" d
						......q:isExecStandNow=""
						......s oeoreTime=$p(phcdtTimeList,"^",seq)
						......i isExecStandNow'="Y" d
							.......s oeoreDate=oeoriSttDat+1
				....//i (oecprCode'="S")&(oecprCode'="OMST")&(seq=1) s oeoreId=curOeoreId q //临嘱第一条立即返
				....i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//26."_seq_"dayBefore?"
				....;W oeoreDate,"--",startDate,!
				....q:(oeoreDate<startDate)
				....i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//27."_seq_"dayAfter?"
				....q:(oeoreDate>(endDate+1))
				....;W endDate,!
				....s curDate=+$h,curTime=$p($h,",",2)
				....i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//27.1"_seq_"discon later?"
				....q:(oeoriXDate<oeoreDate)!((oeoriXDate=oeoreDate)&(oeoriXTime<oeoreTime))
				....//q:((curDate-oeoreDate)*86400+curTime+1800-oeoreTime)<0
				....//s oeoreId=curOeoreId
				....;W oeoriXDate,"--",oeoreDate,"--",oeoriXTime,"--",oeoreTime,!
				....s ctacuId=##class(web.DHCICUCom).GetDateTimeListData(.admPriorityList,oeoreDate,oeoreTime)
				....i ctacuId'="",("|"_$p($g(^DHCCLSet("ICU","SERIOUS")),"^")_"|")'[("|"_ctacuId_"|") q
				....
				....//w uomId_"/"_icuoConcentration_": "_curQty_"/"_icuoPreparedVolume_" ="
				....i uomId=volumeCtuomId s icuoConcentration=1
				....i icuoPreparedVolume>0,+icuoConcentration=0 s icuoConcentration=$fn((curQty/icuoPreparedVolume),"",4)
				....;w "HJTEST2"_""_icuoConcentration,!
				....q:oeoreDate>+$h  //不显示今天之后的医嘱
				....s curId=+icuoId //ICUO_RowId
				....s curOeoreDate=$zd(oeoreDate,3) //ICUO_StartDate
				....s curOeoreTime=$zt(oeoreTime,2) //ICUO_StartTime
				....i icuoStartDate=0 s icuoStartDateTime=""
				....e  s icuoStartDateTime=$zd(icuoStartDate,3)_" "_$zt(icuoStartTime,2)
				....
				....s curEditFlag=icuoEditFlag //ICUO_EditFlag
				....s icuoOrdItemNote=$p($g(^DHCICUOrder(+icuoId)),"^",35) //HIS医嘱说明 ICUO_OrdItemNote 
				....s icuoMainIcuoDr=$p($g(^DHCICUOrder(+icuoId)),"^",36) //主医嘱的ICUOId：ICUO_MainIcuo_Dr  total 45
				....s mainOeoriId=$p(oeorditemStr,"^",6) //主医嘱mainOeoriId
				....i mainOeoriId'="" s mainOeoriId=mainOeoriId_"||"_oeoreSub
				....s mainOeoriSub=$p(mainOeoriId,"||",2)
				....//s ^TMPICU("Oeore",$j,icucriId_arcimId_oeoriId,+icuoUpdateDate,+icuoUpdateTime,icuoId)=tmpStr //_icuoId
				....s tmpDateTime=oeoreDate+(oeoreTime/100000)
				....s tmpSub=oeoriSub
				....i mainOeoriSub="" s mainOeoriSub=oeoriSub,tmpSub=0
				....s oreGroup=mainOeoriSub+((seq/100)+(tmpSub/1000000))
				....i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//99."_seq_"ok!"
				....//s ^TMPICU("Oeore",$j,tmpDateTime,oreGroup,oeoriSub,icucriId_arcimId_oeoriId)=tmpStr //_icuoId
				....i phcinId=0 s phcinId=""
				....I icuoCtcpDesc="" D
					.....s execCTPCP=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",15)
					.....i execCTPCP'="" s icuoCtcpDesc=$p($g(^CTPCP(execCTPCP,1)),"^",2) 
				....
				....s ^TMPICU("Oeore",$j,tmpDateTime,oreGroup,oeoriSub,icucriId_arcimId_oeoriId)=$lb(curId,curIcucriId,oeoreId,curUserId,curOeoreDate,curOeoreTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,icuoConcentration,icuoOriginateFromIcuodr,phcinId,ancvcId,icuoFlag,icuoDrugMode,icuoSpeed,curUpdateDate,curUpdateTime,icuoReason,curEditFlag,curEditedId,icuoRecLocId,curDocUserId,icuoVolume,icuoSpeedUnitDr,icuoSource,icuoType,icucriDesc,arcimDesc,icuoPreparedVolume,icuoAttachOeoriId,icuoReportResult,icuaId,mainOeoriId,subOeoriId,oecprDesc,phcinDesc,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoMainIcuoDr,orderItemStatus,orderItemSeqNo,icuoCtcpDesc,originalOeoriId,icuoStartDateTime,description)
				....//s ^TMPICU("Ordes",$j,tmpDateTime,oreGroup,oeoriSub,icucriId_arcimId_oeoriId)=curId_"^"_curIcucriId_"^"_oeoreId_"^"_curUserId_"^"_curStartDate_"^"_curStartTime_"^"_curEndDate_"^"_curEndTime_"^"_arcimId_"^"_curNote_"^"_curQty_"^"_uomId_"^"_icuoConcentration_"^"_icuoOriginateFromIcuodr_"^"_phcinId_"^"_ancvcId_"^"_icuoFlag_"^"_icuoDrugMode_"^"_icuoSpeed_"^"_curUpdateDate_"^"_curUpdateTime_"^"_icuoReason_"^"_curEditFlag_"^"_curEditedId_"^"_icuoRecLocId_"^"_curDocUserId_"^"_icuoVolume_"^"_icuoSpeedUnitDr_"^"_icuoSource_"^"_icuoType_"^"_icucriDesc_"^"_arcimDesc_"^"_icuoPreparedVolume_"^"_icuoAttachOeoriId_"^"_icuoReportResult_"^"_icuaId_"^"_mainOeoriId_"^"_subOeoriId_"^"_oecprDesc_"^"_phcinDesc_"^"_prcfrDesc_"^"_oeoriNote_"^"_curAbbreviate_"^"_icuoOrdItemNote_"^"_icuoMainIcuoDr
	s updateDate="" f  s updateDate=$o(^TMPICU("Oeore",$j,updateDate))  q:updateDate=""  d
		.s updateTime="" f  s updateTime=$o(^TMPICU("Oeore",$j,updateDate,updateTime))  q:updateTime=""  d
			..s icucriArcimId="" f  s icucriArcimId=$o(^TMPICU("Oeore",$j,updateDate,updateTime,icucriArcimId))  q:icucriArcimId=""  d
				...s icuoId="" f  s icuoId=$o(^TMPICU("Oeore",$j,updateDate,updateTime,icucriArcimId,icuoId))  q:icuoId=""  d
					....//s ^TMPICU("OeoreRet",$j,i)=^TMPICU("Oeore",$j,updateDate,updateTime,icucriArcimId,icuoId)
					....s Data=^TMPICU("Oeore",$j,updateDate,updateTime,icucriArcimId,icuoId)
					....d OutputRowDtHealthOrder
	s qHandle=$lb(0,repid,0)
	q $$$OK

OutputRowDtHealthOrder
	//s Data=$lb(inattId,tPhcinId,tArcimId,tQty,tDefault)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindDtHealthOrderItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDtHealthOrderItemExecute ]
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

ClassMethod FindDtHealthOrderItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDtHealthOrderItemExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 取医生医嘱OE_OrdItem	///新版未用
/// 临时医嘱: 按医嘱表时间判,不跨天; 当天的第一条返回医嘱时间(直接显示),其它的返回分发时间(提前半小时显示),一次只显示一条
/// 长期医嘱: 按执行表时间判,会跨天(提前半小时显示),一次只显示一条
ClassMethod GetDtHealthOrderItem(icuaId, startDate = "", endDate = "", ifByOrdItem = "Y", ifStand = "") As %Library.String
{
	//GetOeordItemArcim
	//w ##class(web.DHCICUOrder).GetDtHealthOrderItem(60)
	//n (icuaId)
	q:icuaId="" 0
	k ^TMPICU("Oeore",$j)
	k ^TMPICU("OeoreRet",$j)
	
	s EpisodeID=$p(^DHCICUArrange(+icuaId),"^",1)
	q:EpisodeID="" 0
	
	s Config=##Class(websys.Configuration).%OpenId(1)
	s LABDATA=Config.LabDataNamespace
	s CurNamespace=$ZNSPACE
	
	//查找医生所下医嘱
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:oeordId="" "" //未开过医嘱
	/*i startDate="" s startDate=$h-1 //核实查找天数!!
	i $l(startDate,"-")>2 s startDate=$zdh(startDate,3)
	i endDate="" s endDate=+$h
	i $l(endDate,"-")>2 s endDate=$zdh(endDate,3)
	*/
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	
	s i=0,fDate=startDate-1,tDate=endDate
	d ##class(web.DHCICUCom).GetAdmPriorityList(1,"",.admPriorityList)
	s needArcbsId=$g(^DHCCLSet("ICU","BillSub")) //此账单子类作为药品处理ARC_BillSub
	s isOrdOnce=$g(^DHCCLSet("ICU","OrdOnce"))	 //医嘱只出现一次
	s isExecStandNow=$g(^DHCCLSet("ICU","ExecStandNow")) //是否执行当天长嘱
	s phcinStr=$g(^DHCCLSet("ICU","IgnorePhcinId")) //不需要处理的用药途径
	s oeoriSub=0,oeoriIdStr=""
	s isDebug=0
	i $g(^tmpIcuDebug("DocOrd"))=icuaId s isDebug=1
	f sttDate=fDate:1:tDate d
		.s oeoriSub=0
		.f  s oeoriSub=$o(^OEORDi(0,"StDt",sttDate,oeordId,oeoriSub)) q:(oeoriSub="")  d
			..i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)="//1.In"
			..q:'$d(^OEORD(oeordId,"I",oeoriSub))
			..s oeoriId=oeordId_"||"_oeoriSub
			..s ordStatCode=##Class(web.DHCClinicCom).GetOrdStatCode(oeoriId)
			..//q:ordStatCode'="V"
			..s orcatId=##Class(web.DHCClinicCom).GetOrdCatId(oeoriId)
			..q:orcatId=""
			..s ocgrpId=$p($g(^OEC("ORCAT",orcatId)),"^",15) //OEC_OrderCategoryGroup
			..s ocgrpCode=$p($g(^OEC("OCGRP",+ocgrpId)),"^",1)
			..s arcicOrderType=##Class(web.DHCClinicCom).GetOrdSubCatType(oeoriId)
			..s arcimId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",2)
			..s arcimDesc=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",2)
			..
			..s arcsgId=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",9)
			..i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//2.Exam & Extra Drug?"_arcsgId_"=="_needArcbsId
			..q:("RL"'[arcicOrderType)&(ocgrpCode'="EXAM")&((arcsgId'="")&(arcsgId'=needArcbsId))
			..
			..i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//3.Drug?"
			..q:(ordStatCode'="V")&(ordStatCode'="D")&(ordStatCode'="TPD")&(arcicOrderType="R") //药品
			..i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//4.UnExecLab?"
			..q:(ordStatCode'="E")&(arcicOrderType="L") //检验
			..i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//5.UnExecExam?"
			..q:(ordStatCode'="E")&(ocgrpCode="EXAM")   //检查
			..
			..s icuoType=arcicOrderType
			..i (arcsgId'="")&(arcsgId=needArcbsId) s icuoType="D"
			..i arcicOrderType="R" s icuoType="D"
			..i ocgrpCode="EXAM" s icuoType="L"
			..
			..s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7) //医嘱用法指针
			..i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//6.phcinStr?"
			..q:(icuoType="D")&(phcinId'="")&(("^"_phcinStr_"^")[("^"_phcinId_"^"))
			..
			..i $o(^OEORD(oeordId,"I",oeoriSub,"X",0))="" d //没有执行记录则插入
				...q:(oecprCode="S")!(oecprCode="OMST")!(oecprCode="OMCQZT")
				...s PLIST(0)=oeoriId
				...s PLIST(16)=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",1)  ;剂量OEORE_PhQtyOrd
				...s PLIST(26)=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)  ;OEORE_ExStDate
				...s PLIST(27)=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10) ;OEORE_ExStTime
				...s PLIST(41)=0                                             ;OEORE_PhQtyIss
				...s PLIST(42)=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",1)  ;剂量OEORE_QtyAdmin
				...s PLIST(43)="TB"                                          ;OEORE_Billed
				...&sql(insert into OE_OrdExec Values :PLIST())
				...s ^TmpDebug("insertExec","Get",oeordId,oeoriSub)=$zd(+$h)_" "_$zt($p($h,",",2))
				...//i SQLCODE s ok="执行记录插入有误!"
			..
			..s oeoriSttDat=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
			..s icuoStartDate=oeoriSttDat
			..s icuoStartTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
			..s phcfrFactor=1
			..s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
			..i phcfrId'="" s phcfrFactor=$p(^PHCFR(phcfrId),"^",2)
			..s prcfrDesc=$p($g(^PHCFR(+phcfrId)),"^",3)
			..
			..s oecprId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",8)
			..q:oecprId=""
			..s oecprCode=$p(^OECPR(oecprId),"^",1)
			..q:oecprCode=""
			..s isStandSort=2
			..i (oecprCode="S")!(oecprCode="OMST")!(oecprCode="OMCQZT") s isStandSort=1
			..i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//7.stand?"
			..q:(ifStand="Y")&(oecprCode'="S")&(oecprCode'="OMST")&(oecprCode'="OMCQZT")
			..i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//8.normal?"
			..q:(ifStand'="")&(ifStand'="Y")&((oecprCode="S")!(oecprCode="OMST")!(oecprCode="OMCQZT"))
			..s oecprDesc=$p(^OECPR(oecprId),"^",2)
			..
			..s phcdtTimeList=""
			..//i (oecprCode'="S")&(oecprCode'="OMST") d
			..//q:phcfrId=""
			..s phcdtId=0
			..f  s phcdtId=$o(^PHCFR(+phcfrId,"DT",phcdtId)) q:phcdtId=""  d
				...i phcdtTimeList'="" s phcdtTimeList=phcdtTimeList_"^"
				...s phcdtTimeList=phcdtTimeList_^PHCFR(+phcfrId,"DT",phcdtId)
			..i phcdtTimeList="" s phcdtTimeList=28800
			..s icuoId="",seq=0
			..s oeoreSub=0,oeoreId="",ifFind="N" //循环执行表，每条对应一个重症记录，没有对应上，则输出
			..f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:(oeoreSub="")!(ifFind="Y")  d
				...//不论执行与否//q:$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",16)'=""  //不考虑在别处执行的情况
				...s seq=seq+1
				...s icuoStartDate=oeoriSttDat
				...i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//11."_seq_"inExec?"
				...q:(oecprCode'="S")&(oecprCode'="OMST")&(oecprCode'="OMCQZT")&(icuoStartDate<startDate) //临嘱开始时间早于查询日期
				...s curOeoreId=oeoriId_"||"_oeoreSub
				...s curIcuoId="",quitFlag=0,icuoEditFlag="",icuoId=""
				...f  s curIcuoId=$o(^DHCICUOrder(0,"OEORE",curOeoreId,icuaId,curIcuoId)) q:(curIcuoId="")!(quitFlag)  d
					....s icuoEditFlag=$p(^DHCICUOrder(+curIcuoId),"^",25)
					....;i (("^N^E^")[("^"_icuoEditFlag_"^"))&(isOrdOnce="Y") s ifFind="Y"
					....;i ("^N^E^")[("^"_icuoEditFlag_"^") s quitFlag=1 q //停止"D"视为未输入,相当于未处理过
					....s icuoId=curIcuoId
				...i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//12."_seq_"icuOrdered?"
				...q:quitFlag
				...i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//13."_seq_"updated?"
				...q:($p(^DHCICUOrder(+icuoId),"^",14)'="")&(icuoEditFlag'="D") //ICUO_OriginateFromICUO_Dr 余液数据
				...//分发时间为1的临嘱取医嘱时间,不计时
				...//i (phcfrFactor=1)&(oecprCode'="S")&(oecprCode'="OMST") s oeoreId=curOeoreId q //100708
				...//调整临时医嘱的分发时间
				...i (oecprCode'="S")&(oecprCode'="OMST")&(oecprCode'="OMCQZT") d
					....q:phcfrFactor=1
					....//q:seq=1
					....s icuoStartTime=$p(phcdtTimeList,"^",seq)
				...e  d //长嘱
					....s icuoStartTime=$p(phcdtTimeList,"^",seq)
					....i isExecStandNow'="Y" d
					    .....s icuoStartDate=oeoriSttDat+1
						.....;s icuoStartDate=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",1)
						.....;s icuoStartTime=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",2)
				...//i (oecprCode'="S")&(oecprCode'="OMST")&(seq=1) s oeoreId=curOeoreId q //临嘱第一条立即返
				...i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//14."_seq_"dayBefore?"
				...q:(icuoStartDate<startDate)
				...i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//15."_seq_"dayAfter?"
				...q:(icuoStartDate>endDate)
				...
				...s curDate=+$h,curTime=$p($h,",",2)
				...//w !,curDate_"/"_icuoStartDate_"/"_oeoriSub_"/"_oecprCode_"/"_icuoStartTime_"/"_((curDate-icuoStartDate)*86400+curTime+1800-icuoStartTime),!
				...//q:((curDate-icuoStartDate)*86400+curTime+1800-icuoStartTime)<0
				...s oeoreId=curOeoreId
				...
				...//w "oeoreId="_oeoreId
				...s ctacuId=##class(web.DHCICUCom).GetDateTimeListData(.admPriorityList,icuoStartDate,icuoStartTime)
				...//w ctacuId,!
				...i ctacuId'="",("|"_$p($g(^DHCCLSet("ICU","SERIOUS")),"^")_"|")'[("|"_ctacuId_"|") q
				...
				...s icuoStartDate=$zd(icuoStartDate,3)
				...s icuoStartTime=$zt(icuoStartTime,2)
				...
				...s lIcucriId=0,icucriId=0
				...f  s lIcucriId=$o(^DHCICUC("RecordItem",lIcucriId)) q:(lIcucriId="")!(icucriId>0)  d
				    ....i arcimId=$p($G(^DHCICUC("RecordItem",lIcucriId)),"^",4) s icucriId=lIcucriId
				...s icucriStr=..GetIcucriStr(oeoriId,icuaId)
				...s icucriId=+icucriStr
				...s ancvcId=$o(^DHCICUC("ViewCat",0,"DrugIntake","")) //$o(^DHCICUC("ViewCat",0,"oEvent",""))
				...i icucriId>0 s ancvcId=$p(^DHCICUC("RecordItem",icucriId),"^",5)
				...//s eqUomQty=##class(web.DHCICUCom).GetEqUomQty(arcimId)
				...//s icucriStr=""
				...//i icucriId>0 s icucriStr=$g(^DHCICUC("RecordItem",+icucriId))
				...//i $p(icucriStr,"^",11)="" s $p(icucriStr,"^",11)=""
				...//i $p(icucriStr,"^",4)="" s $p(icucriStr,"^",4)=arcimId
				...//s $p(icucriStr,"^",5)=ancvcId
				...s doseQty=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",1)
				...s unitUomId=""
				...i doseQty'="" s unitUomId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",3)
				...i unitUomId'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)
				...i (doseQty'="")&($p(doseQty,".")="") s doseQty="0"_doseQty
				...//i (doseQty'="")&(unitDesc'="") s val("doseQtyUnit")=doseQty_" "_unitDesc
				...;用法
				...s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7)
				...s reclocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
				...//s oeoriAddUserId=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)
				...//
				...s icuoId=+icuoId //query.GetDataByName("ICUO_RowId")
				...s tmpStr=icuoId_"^"									//ICUO_RowId
				...s tmpStr=tmpStr_icucriId_"^"
				...s tmpStr=tmpStr_oeoreId_"^"  //ypz 090423 改为存医嘱执行Id//ICUO_OEORE_Dr
				...s tmpStr=tmpStr_"^"	//ICUO_User_Dr
				...s tmpStr=tmpStr_icuoStartDate_"^"	//ICUO_StartDate
				...s tmpStr=tmpStr_icuoStartTime_"^" //ICUO_StartTime
				...s tmpStr=tmpStr_"^" //ICUO_EndDate
				...s tmpStr=tmpStr_"^" //ICUO_EndTime
				...s tmpStr=tmpStr_arcimId_"^"
				...s tmpStr=tmpStr_"^"	//ICUO_Note  //num:10
				...s tmpStr=tmpStr_doseQty_"^"	//ICUO_Qty
				...s tmpStr=tmpStr_unitUomId_"^"	//ICUO_Uom_Dr
				...s tmpStr=tmpStr_"^"	//ICUO_Concentration
				...s tmpStr=tmpStr_"^"	//ICUO_Compli_Dr
				...s tmpStr=tmpStr_phcinId_"^"	//ICUO_Instr_Dr
				...s tmpStr=tmpStr_ancvcId_"^" //
				...s tmpStr=tmpStr_"N^"	//ICUO_Flag
				...s tmpStr=tmpStr_"^"	//ICUO_DrugMode
				...s tmpStr=tmpStr_"0^"	//ICUO_Speed
				...s icuoUpdateDate="",icuoUpdateTime=""
				...s tmpStr=tmpStr_icuoUpdateDate_"^" //ICUO_UpdateDate //num: 20
				...s tmpStr=tmpStr_icuoUpdateTime_"^" //ICUO_UpdateTime
				...s tmpStr=tmpStr_"^"	//ICUO_Reason
				...s tmpStr=tmpStr_icuoEditFlag_"^"	//ICUO_EditFlag
				...s tmpStr=tmpStr_"^"	//ICUO_ICUO_DR
				...s tmpStr=tmpStr_reclocId_"^"	//ICUO_RecLoc_Dr
				...s tmpStr=tmpStr_"^"	//ICUO_DocUser_Dr
				...s tmpStr=tmpStr_"0^"	//ICUO_Volume
				...s tmpStr=tmpStr_"0^" //ICUO_SpeedUnit_Dr
				...s tmpStr=tmpStr_"M^"	//ICUO_Source
				...s tmpStr=tmpStr_icuoType_"^"	//ICUO_Type //num:30
				...s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",+icucriId)),"^",2)_"^"
				...s tmpStr=tmpStr_arcimDesc_"^"
				...
				...s oeorditemStr=..GetOeorditemInfo(oeoriId)
				...s tmpStr=tmpStr_$p(oeorditemStr,"^",18)_"^" //ICUO_PreparedVolume
				...s attachOeoriId=""
				...s tmpStr=tmpStr_attachOeoriId_"^" //ICUO_AttachOeoriId 
				...
				...s icuoReportResult=""
				...i ocgrpCode="EXAM" s icuoReportResult=..GetRisReportResult(oeoriId)  //取检查结果
				...i arcicOrderType="L" s icuoReportResult=..GetLabReportResult(oeoriId,CurNamespace,LABDATA) //取检验结果
				...
				...i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//16."_seq_"labResult?"
				...q:(icuoReportResult="")&(arcicOrderType="L")
				...i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//17."_seq_"examResult?"
				...q:(icuoReportResult="")&(ocgrpCode="EXAM")
				...
				...s tmpStr=tmpStr_icuoReportResult_"^"  //ICUO_ReportResult
				...s tmpStr=tmpStr_icuaId_"^" //
				...i $p(oeorditemStr,"^",6)'="" s $p(oeorditemStr,"^",6)=$p(oeorditemStr,"^",6)_"||"_oeoreSub
				...s tmpStr=tmpStr_$p(oeorditemStr,"^",6)_"^"		//主医嘱mainOeoriId
				...s tmpStr=tmpStr_$p(oeorditemStr,"^",7)_"^"		//从医嘱subOeoriId
				...s tmpStr=tmpStr_$p(oeorditemStr,"^",13)_"^"		//优先级
				...s tmpStr=tmpStr_$p(oeorditemStr,"^",5)_"^"		//用法 phcinDesc  40
				...s tmpStr=tmpStr_$p(oeorditemStr,"^",15)_"^"		//频率 num: 41
				...s tmpStr=tmpStr_$p(oeorditemStr,"^",17)_"^"		//医嘱备注 42
				...s icuoAbbreviate=##class(web.DHCClinicCom).GetOeoriGroupDesc(oeoriId)
				...s tmpStr=tmpStr_icuoAbbreviate_"^"	//常用医嘱缩写 ICUO_Abbreviate  
				...s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",35)_"^"	//HIS医嘱说明 ICUO_OrdItemNote 
				...s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",36)	//主医嘱的ICUOId：ICUO_MainIcuo_Dr  total 45
				...//i arcicOrderType="L" w tmpStr,!
				...//i ocgrpCode="EXAM" w tmpStr,!
				...//s ^TMPICU("Oeore",$j,icucriId_arcimId_oeoriId,+icuoUpdateDate,+icuoUpdateTime,icuoId)=tmpStr //_icuoId
				...s mainOeoriId=$p(oeorditemStr,"^",6)
				...s mainOeoriSub=$p(mainOeoriId,"||",2)
				...//w oeoriSub,!
				...s tmpDateTime=icuoStartDate+(icuoStartTime/100000)
				...s tmpSub=oeoriSub
				...i mainOeoriSub="" s mainOeoriSub=oeoriSub,tmpSub=0
				...s oreGroup=mainOeoriSub+((seq/100)+(tmpSub/1000000))
				...//i ifByOrdItem="Y" 
				...i isDebug s ^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("DocOrd",icuaId,oeordId,oeoriSub)_"//99."_seq_"ok!"
				...s ^TMPICU("Oeore",$j,tmpDateTime,oreGroup,oeoriSub,icucriId_arcimId_oeoriId)=tmpStr //_icuoId
				...//w tmpStr,!
				...//e  d
					...//.s ^TMPICU("Oeore",$j,isStandSort,oreGroup,oeoriSub,tmpDateTime)=tmpStr
				...//i ifByOrdItem="Y" s ifFind="Y"
				...//w oeoriId_"/"_oeoreSub_"/"_tmpStr,!
	s updateDate="" f  s updateDate=$o(^TMPICU("Oeore",$j,updateDate))  q:updateDate=""  d
		.s updateTime="" f  s updateTime=$o(^TMPICU("Oeore",$j,updateDate,updateTime))  q:updateTime=""  d
			..s icucriArcimId="" f  s icucriArcimId=$o(^TMPICU("Oeore",$j,updateDate,updateTime,icucriArcimId))  q:icucriArcimId=""  d
				...s icuoId="" f  s icuoId=$o(^TMPICU("Oeore",$j,updateDate,updateTime,icucriArcimId,icuoId))  q:icuoId=""  d
					....s i=i+1
					....s ^TMPICU("OeoreRet",$j,i)=^TMPICU("Oeore",$j,updateDate,updateTime,icucriArcimId,icuoId)
					....//w i_": " _^TMPICU("OeoreRet",$j,i),!
	q i
}

/// 俞工修改，按照科室分组显示药品
/// 返回icucriId^speedUnitId^uomId^concentration^qty^prepareVolume^abbreviate^defSpeed^ctlocId
/// w ##class(web.DHCICUOrder).GetIcucriStr("555||9",7)
ClassMethod GetIcucriStr(oeoreId, icuaId) As %String
{
	// w ##class(web.DHCICUOrder).GetIcucriStr("13851||50673",876)
	s confWardLocId=""
	s episodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
	s bedId=$p($g(^DHCICUArrange(icuaId)),"^",4)
	s papmiId=$p($g(^PAADM(episodeID)),"^",1)
	q:bedId="" ""
	s wardId=$p(bedId,"||",1)
	s wardLocId=$p(^PAWARD(+wardId),"^",5)
	;w wardLocId,!
	q:wardLocId="" ""
	
	s oeoriSub=$p(oeoreId,"||",2)
	q:oeoriSub="" ""
	s oeordId=+oeoreId
	s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
	//w arcimId,!
	q:arcimId="" ""
	
 	s arcimVersion=$p(arcimId,"||",2)
 	q:'$d(^ARCIM(+arcimId,arcimVersion,1)) ""
 	s arcicId=$p(^ARCIM(+arcimId,arcimVersion,1),"^",10)
 	q:arcicId="" ""
 	q:'$d(^ARC("IC",arcicId)) ""
 	s orcatId=$p(^ARC("IC",arcicId),"^",8)
 	q:orcatId="" ""
 	q:'$d(^OEC("ORCAT",orcatId)) ""
 	
 	s oecprId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",8)
	q:oecprId="" ""

	s oecprCode=$p(^OECPR(oecprId),"^",1)
	q:oecprCode="" ""
 	
 	s icucriStr=""
 	s oeoriDepProcNotes=$g(^OEORD(oeordId,"I",oeoriSub,"DEP",1))
 	i oeoriDepProcNotes'="" s icucriStr=$g(^DHCICUC("OrdMapping",orcatId,arcicId,arcimId,oeoriDepProcNotes))
	d CHECKWARDLOC
	//w "1 icucriStr="_icucriStr,!
 	q:icucriStr'="" icucriStr
 	q:confWardLocId'="" icucriStr
 	s curPhcInId=""
 	;开医嘱中的用法
 	s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7)
 	;配置的医嘱对应的用法：医嘱关联常用医嘱
 	s icucriStr=$g(^DHCICUC("OrdMapping",orcatId,arcicId,arcimId))
	i icucriStr'="" s curPhcInId=$p(icucriStr,"^",10)
	;如果医嘱用法是泵入则返回配置的,不是则按照真实路径走
	//w "curPhcInId="_curPhcInId,"/"_icucriStr,!
	i (curPhcInId'="")&(curPhcInId'=phcinId) s icucriStr=""
	//q:(curPhcInId="")&(icucriStr'="") icucriStr
	//s icucriStr="" 
 	//w orcatId_"/"_arcicId_"/"_arcimId_"/"_oeoriDepProcNotes_"/"_icucriStr,!
 	d CHECKWARDLOC
 	//w "2 icucriStr="_icucriStr,!
	
 	q:icucriStr'="" icucriStr
 	q:confWardLocId'="" icucriStr
 	s icucriStr=$g(^DHCICUC("OrdMapping",orcatId,arcicId))
 	d CHECKWARDLOC
  	//w "3 icucriStr="_icucriStr,!
	
 	q:icucriStr'="" icucriStr
 	q:confWardLocId'="" icucriStr
 	s confWardLocId=$p(icucriStr,"^",9)
 	i confWardLocId'="" q 
 	s icucriStr=$g(^DHCICUC("OrdMapping",orcatId))
 	d CHECKWARDLOC
 	
	q:icucriStr'="" icucriStr
	q:confWardLocId'="" icucriStr
	s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7)
	;b
	q:phcinId="" ""
	
	;w phcinId_"/"_$p($g(^PHCIN(phcinId)),"^",2),!
	s icucriStr=$g(^DHCCLSet("ICU","Oeore","DefaultDrugComOrd"))
	i icucriStr="" s icucriStr=$o(^DHCICUC("RecordItem",0,"Code","IntravenousIntake",""))
	q:("^"_$g(^DHCCLSet("ICU","Oeore","ExcludedInstruct"))_"^")[("^"_phcinId_"^") ""
	s oecprId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",8)
	//w oecprId,!
	//w icucriStr,!
	
	//20210807ypz
	s curIcucriId=""
	f  s curIcucriId=$o(^DHCCLSet("ICU","Oeore","Instruct",curIcucriId)) q:curIcucriId=""  d
		.i ("^"_$g(^DHCCLSet("ICU","Oeore","Instruct",curIcucriId,wardLocId))_"^")[("^"_phcinId_"^") d
			..s wardLocIds=$g(^DHCCLSet("ICU","Oeore","Instruct",curIcucriId,"WardLocIds"))
			..s icucriStr=curIcucriId
			..;不显示长期口服药医嘱等的的科室
			..i ("^"_wardLocIds_"^")[("^"_wardLocId_"^") d
			...;是长期医嘱、自备药医嘱等，则不显示
			...i (oecprCode="S")||(oecprCode="OMST")||(oecprCode="OMCQZT") s icucriStr=""
			..
	q:icucriStr'="" icucriStr
	/*
	s curIcucriId=""
	f  s curIcucriId=$o(^DHCCLSet("ICU","Oeore","Instruct",curIcucriId)) q:curIcucriId=""  d
		.i ("^"_^DHCCLSet("ICU","Oeore","Instruct",curIcucriId)_"^")[("^"_phcinId_"^") d
			..s wardLocIds=$g(^DHCCLSet("ICU","Oeore","Instruct",curIcucriId,"WardLocIds"))
			..s icucriStr=curIcucriId
			..;不显示长期口服药医嘱等的的科室
			..i ("^"_wardLocIds_"^")[("^"_wardLocId_"^") d
			...;是长期医嘱、自备药医嘱等，则不显示
			...i (oecprCode="S")||(oecprCode="OMST")||(oecprCode="OMCQZT") s icucriStr=""
			..
	
	q:icucriStr="" ""
	;w 5,!
	*/
	//i ("^"_$g(^DHCCLSet("ICU","ArcicId","TransBlood"))_"^")[("^"_arcicId_"^") s icucriStr=$o(^DHCICUC("RecordItem",0,"TypeCode","D","TransBlood",""))
	//b
	q icucriStr
CHECKWARDLOC
	s confWardLocId=$p(icucriStr,"^",9)
	//b "confWardLocId"
	s tmpDoseSpeed=$p(icucriStr,"^",2)
 	i confWardLocId="" d ;w "所有科室",!
 		.i tmpDoseSpeed'="" s $p(icucriStr,"^",2)=+tmpDoseSpeed
 	e  d
 		.i (";"_confWardLocId_";")'[(";"_wardLocId_";") s icucriStr=""  // 不是该科室的配置
 		.q:icucriStr=""
 		.q:tmpDoseSpeed="" //分科室处理速度剂量
 		.f i=1:1:$l(confWardLocId,";") d
 			..s tmpWardLocId=$p(confWardLocId,";",i)
 			..q:tmpWardLocId'=wardLocId
 			..q:tmpWardLocId=""
 			..s curDoseSpeed=$p(tmpDoseSpeed,"|",i)
 			..i curDoseSpeed="" s curDoseSpeed=+tmpDoseSpeed
 			..s $p(icucriStr,"^",2)=curDoseSpeed
	q
}

/// 查看医嘱是否有效Y/N
ClassMethod VerifyOrder(oeoreId As %String, date As %String = "", time As %String = "") As %String
{
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	//w date_"/",time,!
	//q:(date>$h)!((date=+$h)&(time>$p($h,",",2))) "N"
	s oeoriSub=$p(oeoreId,"||",2)
	q:oeoriSub="" "N"
	s oeordId=+oeoreId
	s oecprId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",8)
    s oecprCode=""
    i oecprId>0 s oecprCode=$p($g(^OECPR(+oecprId)),"^",1)
    s oecprDesc=$p($g(^OECPR(+oecprId)),"^",2)
    s oecprType=""
    q:(oecprCode'="S")&(oecprCode'="OMST")&(oecprCode'="OMCQZT") "N" //临时医嘱退出

	s oeoriSttDat=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
	//w date,"/"_oeoriSttDat,!
	s arcimId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",2)
	s fillerno=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",12)
	
	s firstOeoriId=$p(fillerno,"!!",1)
	i firstOeoriId="" d
		.s curOeoriSub=oeoriSub
	e  d
		.//s tmpOeoriSub="",curOeoriSub=""
		.//f  s tmpOeoriSub=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,oeoriSttDat,tmpOeoriSub)) q:tmpOeoriSub=""  d
			.//.w tmpOeoriSub_"/"_$p($g(^OEORD(oeordId,"I",tmpOeoriSub,9)),"^",12),!
			.//.i $p($g(^OEORD(oeordId,"I",tmpOeoriSub,9)),"^",12)[firstOeoriId s curOeoriSub=tmpOeoriSub,tmpOeoriSub=tmpOeoriSub_"00"
		.//q
		.s curOeoriSub=""
		.s curDate=$h+1
		.f  s curDate=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,curDate),-1) q:(curDate="")!(curDate<oeoriSttDat)!(curOeoriSub'="")  d
			..//w curDate,!
			..s tmpOeoriSub=""
			..f  s tmpOeoriSub=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,curDate,tmpOeoriSub)) q:(tmpOeoriSub="")!(curOeoriSub'="")  d
				...//w tmpOeoriSub_"/"_$p($g(^OEORD(oeordId,"I",tmpOeoriSub,9)),"^",12),!
				...i $p($g(^OEORD(oeordId,"I",tmpOeoriSub,9)),"^",12)[(firstOeoriId_"!!") s curOeoriSub=tmpOeoriSub
		.//w "out:"_curOeoriSub,!
	q:curOeoriSub="" "N"
	
	s ordStatId=$p($g(^OEORD(oeordId,"I",curOeoriSub,1)),"^",13)  ;OEORI_ItemStat_DR
    s ordStatCode=$p($g(^OEC("OSTAT",+ordStatId)),"^")
    q:ordStatCode'="D" "Y"
    s xDate=$p($g(^OEORD(oeordId,"I",curOeoriSub,3)),"^",34)
    s xTime=$p($g(^OEORD(oeordId,"I",curOeoriSub,2)),"^",15)
    //w xDate,"/"_xTime,!
	s dateTimeVal=(date*100000)+time
	s xDateTimeVal=(xDate*100000)+xTime
	q:dateTimeVal>xDateTimeVal "N" 
	q "Y"
}

/// 查看医嘱是否已引用
ClassMethod RecordedOrder(oeoreId As %String) As %String
{
	s oeoriSub=$p(oeoreId,"||",2)
	q:oeoriSub="" "N"
	s oeordId=+oeoreId
	s date=+$h,time=$p($h,",",2)
	s oecprId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",8)
    s oecprCode=""
    i oecprId>0 s oecprCode=$p($g(^OECPR(+oecprId)),"^",1)
    s oecprDesc=$p($g(^OECPR(+oecprId)),"^",2)
    s oecprType=""
    //q:(oecprCode'="S")&(oecprCode'="OMST") "N"

	s arcimId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",2)
	s oeoriFillerNo=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",12)
	s firstOeoriId=$p(oeoriFillerNo,"!!",1)
	i firstOeoriId="" s firstOeoriId=oeordId_"||"_oeoriSub
	s firstOeoriSub=$p(firstOeoriId,"||",2)
	q:firstOeoriSub="" "N" //error data
	s firstSttDate=$p($g(^OEORD(oeordId,"I",firstOeoriSub,1)),"^",9)
	q:firstSttDate="" "N"
	s retStr="N"
	f curDate=firstSttDate:1:date+1 q:(retStr="Y")  d
		.//w " curDate="_curDate_"/"_firstOeoriId
		.s tmpOeoriSub=""
		.f  s tmpOeoriSub=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,curDate,tmpOeoriSub)) q:tmpOeoriSub=""  d
			..q:'$d(^OEORD(oeordId,"I",tmpOeoriSub,9))
			..q:($p(^OEORD(oeordId,"I",tmpOeoriSub,9),"^",12)'="")&($p(^OEORD(oeordId,"I",tmpOeoriSub,9),"^",12)'[firstOeoriId)
			..q:($p(^OEORD(oeordId,"I",tmpOeoriSub,9),"^",12)="")&(firstOeoriSub'=tmpOeoriSub)
			..//w "  orisub="_tmpOeoriSub,!
			..s curOeoriId=oeordId_"||"_tmpOeoriSub_"||"
			..s tmpOeoreId=curOeoriId
			..f  s tmpOeoreId=$o(^DHCICUOrder(0,"OEORE",tmpOeoreId)) q:(tmpOeoreId="")!(tmpOeoreId'[curOeoriId)  d
				...//w " __oreId="_tmpOeoreId,!
				...s icuaId=$o(^DHCICUOrder(0,"OEORE",tmpOeoreId,""))
				...q:icuaId=""
				...s icuoId=""
				...f  s icuoId=$o(^DHCICUOrder(0,"OEORE",tmpOeoreId,icuaId,icuoId)) q:(icuoId="")!(retStr="Y")  d
					....//w " icuoId="_icuoId
					....q:"ICDRU"[$p(^DHCICUOrder(icuoId),"^",25)
					....//w "get!"
					....s retStr="Y"
	q retStr
}

/// 未用
ClassMethod GetTotalIO(icuaId As %String, fromDate As %String = "", toDate As %String = "", fromTime As %String = "", toTime As %String = "") As %String
{
	//注意，扩展此表后一定要加此保护
	//n (icuaId,fromDate,toDate,fromTime,toTime)
	q:icuaId="" 0
	k ^TMPICU("TotalIO",$j)
	k ^TMPICU("TotalIORet",$j)
	
	s i=0
	s EpisodeID=$p(^DHCICUArrange(+icuaId),"^",1)
	q:EpisodeID="" ""

	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:oeordId="" 0
	i $l(fromDate,"-")>2 s fromDate=$zdh(fromDate,3)
	i fromDate="" s fromDate=$p(^PAADM(EpisodeID),"^",6)
	q:fromDate<1 0 
	i $l(toDate,"-")>2 s toDate=$zdh(toDate,3)
	i toDate="" s toDate=+$h
	s oeoriIdStr=""
	
	i fromTime'="" s fromTime=$zth(fromTime,3)
	e  s fromTime=0
	i toTime'="" s toTime=$zth(toTime,3) 
	e  s toTime=86400

	f startDate=fromDate:1:toDate d
	    .s icutioId=0
	    .f  s icutioId=$o(^DHCICUTotalIO(0,"SDate",startDate,icuaId,icutioId)) q:(icutioId="")  d
	        ..q:'$d(^DHCICUTotalIO(icutioId))
	        ..s icutioData=$g(^DHCICUTotalIO(icutioId))
	        ..s summaryStartDate=$p(icutioData,"^",2)
	        ..s summaryEndDate=$p(icutioData,"^",3)
		    ..s startTime=$p(icutioData,"^",4)
		    ..s endTime=$p(icutioData,"^",5)
		    ..q:(fromDate>summaryEndDate)!((fromDate=summaryEndDate)&(fromTime>=endTime))
		    ..q:(toDate<summaryStartDate)!((toDate=summaryStartDate)&(toTime<=startTime))
	        ..s $p(icutioData,"^",33)=$p(icutioData,"^",33) //新设计已不需要修改
	        ..s $p(icutioData,"^",2)=$zd($p(icutioData,"^",2),3)
	        ..s $p(icutioData,"^",3)=$zd($p(icutioData,"^",3),3)
	        ..s $p(icutioData,"^",4)=$zt($p(icutioData,"^",4))
	        ..s $p(icutioData,"^",5)=$zt($p(icutioData,"^",5))
	        ..s ^TMPICU("TotalIO",$j,+startDate,+icutioId)=icutioId_"^"_icutioData
	        ..//w $l(icutioData,"^")_"/"_icutioId_"^"_icutioData,!
	s startDate="" f  s startDate=$o(^TMPICU("TotalIO",$j,startDate))  q:startDate=""  d
	 .s icutioId="" f  s icutioId=$o(^TMPICU("TotalIO",$j,startDate,icutioId))  q:icutioId=""  d
	     ..s i=i+1
	     ..s ^TMPICU("TotalIORet",$j,i)=^TMPICU("TotalIO",$j,startDate,icutioId)
	     ..//w i_": " _^TMPICU("TotalIORet",$j,i),!
    q i
}

ClassMethod GetLabReportResult(oeoriId As %String, CurNamespace As %String, LABDATA As %String) As %Library.String
{
	;1:项目代码
	;2:项目名称
	;3:缩写
	;4:结果
	;5:单位
	;6:结果标志
	;7:范围
	//n (oeoriId,CurNamespace,LABDATA)
	q:oeoriId="" ""
	s oeordId=$p(oeoriId,"||",1)
	s oeoriSub=$p(oeoriId,"||",2)
	s oeoriLabTestSetRow=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",35)
	q:oeoriLabTestSetRow="" ""
	s labno=+oeoriLabTestSetRow
	s ts=$p(oeoriLabTestSetRow,"||",2)
	s tscnt=$p(oeoriLabTestSetRow,"||",3)
	q:$p($g(^TEPI(labno,1,ts,tscnt)),"\",31)'="E" "" //如果没审核则退出
	zn LABDATA
	k PLIST
	s ret=$$GetResultbyRowid^CHDhcLabReport(labno,ts,tscnt,"Y")
	q:ret'=0 ""
	s num=0,labReportResult=""
	f  s num=$o(PLIST(num)) q:num=""  d
	    .//q:num>1 //暂时返回一条
	    .i labReportResult'="" s labReportResult=labReportResult_"!"
	    .s labReportResult=labReportResult_$p(PLIST(num),$c(2),3)_":"_$p(PLIST(num),$c(2),4) //_$p(PLIST(num),$c(2),5) //PLIST(num) 
	zn CurNamespace
	q labReportResult
}

ClassMethod GetRisReportResult(oeoriId As %String) As %Library.String
{
	//n (oeoriId)
	q:oeoriId="" ""
	s oeordId=$p(oeoriId,"||",1)
	s oeoriSub=$p(oeoriId,"||",2)
	//w oeoriId,!
	
	s rarId=$o(^DHCPACRegInfoi("OEORI",oeoriId,""))
	q:rarId="" ""
	s rarStudyNo=$p($g(^DHCPACRegInfo(rarId)),"^",2)
	//w "rarId=",rarId_"/"_rarStudyNo,!
	s drptId=$o(^DHCRBStudyi("Report","StudyNo",rarStudyNo,""))
	//s drptId=$o(^DHCRBStudyi("Report-Oeorditm",oeoriId,"")) //new version
	q:drptId="" ""
	q:'$d(^DHCRBStudy("Report",drptId)) ""
	s drsId=$p(^DHCRBStudy("Report",drptId),"^",4)
	q:drsId="" ""
	q:$p($g(^DHCRBCStatus("ReportStatus",drsId)),"^")'="V" ""  //如果没审核则退出
	s risReportResult=$g(^DHCRBStudy("Report",drptId,"ResultDescEx"))
	s num=$l(risReportResult,"_$c(13,10)_")
	s tmpStr=""
	f i=1:1:num d
	    .s tmpStr=tmpStr_$p(risReportResult,"_$c(13,10)_",i)
	//i risReportResult'="" s risReportResult=$p(risReportResult,"_$c(13,10)")
	s risReportResult=tmpStr
	q risReportResult
}

/// 取医嘱信息：
/// 入参：医嘱表RowId或医嘱执行表RowId
/// 返回值：用"^"分割的几部分：oecprType:Y/N/"",Y长嘱，N临嘱，""不应执行的医嘱(取药、出院带药);oecprCode:医嘱优先级代码;
///         phcinId:用法指针;phcinCode:用法代码;phcinDesc：用法描述,mainOeoriId:主医嘱RowId;subOeoriId:从医嘱RowId,
///         defPhcinId:缺省用法指针;defPhcinCode:缺省用法代码;defPhcinDesc：缺省用法描述;用"!"分割
///         oriQty:医嘱药品为剂量，非药品其它为数量;unitUomId:医嘱单位。
///         注：如果医嘱是从医嘱mainOeoriId有值，如果是主医嘱，从医嘱subOeoriId有值。
ClassMethod GetOeorditemInfo(oeoriId As %String) As %String
{
	//w ##class(web.DHCICUOrder).GetOeorditemInfo("911637||7")
	s oeoriSub=$p(oeoriId,"||",2)
	q:oeoriSub="" ""
	s oeordId=+oeoriId
	s oeoriId=oeordId_"||"_oeoriSub
	s ordStatCode=##Class(web.DHCClinicCom).GetOrdStatCode(oeoriId)
    q:("VED"'[ordStatCode)&("TPD"'[ordStatCode) ""
    s oecprId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",8)
    s oecprCode=""
    i oecprId>0 s oecprCode=$p($g(^OECPR(+oecprId)),"^",1)
    s oecprDesc=$p($g(^OECPR(+oecprId)),"^",2)
    s oecprType=""
    i (oecprCode="S")!(oecprCode="OMST")!(oecprCode="OMCQZT") s oecprType="Y" //长期医嘱
    i ((oecprCode="NORM")!(oecprCode="OM")!(oecprCode="STAT")!(oecprCode="PRN")) s oecprType="N" //临时医嘱
    s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7) //医嘱用法指针
    s phcinCode="",phcinDesc="" 
    i phcinId'="" s phcinCode=$p($g(^PHCIN(phcinId)),"^",1),phcinDesc=$p($g(^PHCIN(phcinId)),"^",2)
	s mainOeoriId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)
	s volume=##Class(web.DHCClinicCom).GetVolume(oeoriId)
	s arcicOrderType=##Class(web.DHCClinicCom).GetOrdSubCatType(oeoriId)
	s subOeoriId=""
	i oeoriSub'="" d
	    .s curOriSub=""
	    .f  s curOriSub=$o(^OEORDi(0,"OEORI",oeordId,oeoriId,curOriSub)) q:(curOriSub="")  d
			..s curArcimId=$p(^OEORD(oeordId,"I",curOriSub,1),"^",2)
			..s arcimDesc=$p($g(^ARCIM(+curArcimId,+$p(curArcimId,"||",2),1)),"^",2)
			..q:arcimDesc=""
		    ..q:(arcicOrderType="R")&(##Class(web.DHCClinicCom).GetOrdSubCatType(oeordId_"||"_curOriSub)'=arcicOrderType)
		    ..i subOeoriId'="" s subOeoriId=subOeoriId_"!"
		    ..s subOeoriId=subOeoriId_oeordId_"||"_curOriSub
		    ..s volume=volume+##Class(web.DHCClinicCom).GetVolume(oeordId_"||"_curOriSub)
	
	//for 第三方HIS begin
	s EpisodeID=+^OEORD(+oeoriId)
	s lhnOrderNo=$o(^DHCLHN(0,"OEORI",EpisodeID,oeoriId,""))
	i lhnOrderNo'="" d //以此为标志
	    .s mainOeoriId=""
	    .s subOeoriId=""
	    .s mainLhnId=$o(^DHCLHN(0,"PAADM",EpisodeID,lhnOrderNo,1,""))
	    .q:mainLhnId=""
	    .q:'$d(^DHCLHN(mainLhnId))
	    .i oeoriId'=$p(^DHCLHN(mainLhnId),"^",4) s mainOeoriId=$p(^DHCLHN(mainLhnId),"^",4)
	    .q:mainOeoriId'="" //有主医嘱指针，是从医嘱
	    .s lhnOrderSubNo=1
	    .f  s lhnOrderSubNo=$o(^DHCLHN(0,"PAADM",EpisodeID,lhnOrderNo,lhnOrderSubNo)) q:lhnOrderSubNo=""  d
	        ..s lhnId=""
	        ..f  s lhnId=$o(^DHCLHN(0,"PAADM",EpisodeID,lhnOrderNo,lhnOrderSubNo,lhnId)) q:lhnId=""  d
	        	...q:'$d(^DHCLHN(lhnId)) 
	        	...i subOeoriId'="" s subOeoriId=subOeoriId_"!"
	        	...s subOeoriId=subOeoriId_$p(^DHCLHN(lhnId),"^",4)
	//w mainOeoriId_"/"_subOeoriId,!
	//for 第三方HIS end
	
	s arcimId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",2)
	s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
    s phcdId=+phcdfId,phcdfSub=+$p(phcdfId,"||",2)
    s defPhcinId=+$p($g(^PHCD(phcdId,"DF",phcdfSub,1)),"^",5)
    s defPhcinCode=$p($g(^PHCIN(defPhcinId)),"^",1),defPhcinDesc=$p($g(^PHCIN(defPhcinId)),"^",2)
    s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
	s prcfrDesc=$p($g(^PHCFR(+phcfrId)),"^",3)
	s phcfrFactor=$p(^PHCFR(+phcfrId),"^",2)

    s doseQty=$p($g(^OEORD(oeordId,"I",+oeoriSub,2)),"^",1)
	s unitUomId=$p($g(^OEORD(oeordId,"I",+oeoriSub,2)),"^",3)
	s phOrdQty=$p($g(^OEORD(oeordId,"I",+oeoriSub,1)),"^",12)
	i doseQty="",phOrdQty="" s unitUomId=""
	i (doseQty'="")&($p(doseQty,".")="") s doseQty="0"_doseQty
	s oriQty=doseQty
	i oriQty="" s oriQty=phOrdQty
	s oeoriNote=$g(^OEORD(oeordId,"I",+oeoriSub,"DEP",1))
    
    q oecprType_"^"_oecprCode_"^"_phcinId_"^"_phcinCode_"^"_phcinDesc_"^"_mainOeoriId_"^"_subOeoriId_"^"_defPhcinId_"^"_defPhcinCode_"^"_defPhcinDesc_"^"_oriQty_"^"_unitUomId_"^"_oecprDesc_"^"_phcfrId_"^"_prcfrDesc_"^"_phcfrFactor_"^"_oeoriNote_"^"_volume
}

ClassMethod GetOeordiIfLong(oeoriId As %String) As %String
{
	//w ##class(web.DHCICUOrder).GetOeorditemInfo("911637||7")
	s oeoriSub=$p(oeoriId,"||",2)
	q:oeoriSub="" ""
	s oeordId=+oeoriId
	s oeoriId=oeordId_"||"_oeoriSub
	s ordStatCode=##Class(web.DHCClinicCom).GetOrdStatCode(oeoriId)
    q:("VED"'[ordStatCode)&("TPD"'[ordStatCode) ""
    s oecprId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",8)
    s oecprCode=""
    i oecprId>0 s oecprCode=$p($g(^OECPR(+oecprId)),"^",1)
    s oecprDesc=$p($g(^OECPR(+oecprId)),"^",2)
    s oecprType="N"
    i (oecprCode="S")!(oecprCode="OMST")!(oecprCode="OMCQZT") s oecprType="Y" //长期医嘱
    i ((oecprCode="NORM")!(oecprCode="OM")!(oecprCode="STAT")!(oecprCode="PRN")) s oecprType="N" //临时医嘱
    q oecprType
}

/// 护士执行医嘱
ClassMethod UpdateOrdGroup(setSkinTest, oeoreId, execStatusCode, userId, userDeptId, queryTypeCode, execDate, execTime, changeReasonDr) As %String
{
	
	s retstr=##class(Nur.CommonInterface.OrderHandle).UpdateOrdGroup(setSkinTest, oeoreId, execStatusCode, userId, userDeptId, queryTypeCode, execDate, execTime, changeReasonDr)
	s ^DHCICUExecOrder(oeoreId,userId,+$h,$p($h,",",2))=$lb(retstr,setSkinTest,oeoreId,execStatusCode,userId,userDeptId,queryTypeCode,execDate,execTime,changeReasonDr)
	q retstr
}

ClassMethod GetICUOrditemInfo(icuoId) As %String
{
	q:icuoId="" ""
	q:'$d(^DHCICUOrder(icuoId)) ""
	s icuoOrdItemNote=$p(^DHCICUOrder(icuoId),"^",35)	//主医嘱|从医嘱|优先级Id|频率Id|医嘱备注
	s phcinId=$p(^DHCICUOrder(icuoId),"^",15)			//ICUO_Instr_Dr
	s phcinCode="",phcinDesc=""
	i phcinId'="" s phcinCode=$p($g(^PHCIN(phcinId)),"^",1),phcinDesc=$p($g(^PHCIN(phcinId)),"^",2)
	s mainOeoriId=$p(icuoOrdItemNote,"|",1)
	s subOeoriId=$p(icuoOrdItemNote,"|",2)
	s oecprId=$p(icuoOrdItemNote,"|",3)	
	s oecprCode=""
	i oecprId>0 s oecprCode=$p(^OECPR(+oecprId),"^",1)	//优先级
	s oecprDesc=$p($g(^OECPR(+oecprId)),"^",2)
    s oecprType=""
    i (oecprCode="S")!(oecprCode="OMST")!(oecprCode="OMCQZT") s oecprType="Y" //长期医嘱
    i ((oecprCode="NORM")!(oecprCode="OM")!(oecprCode="STAT")!(oecprCode="PRN")) s oecprType="N" //临时医嘱
    s phcfrId=$p(icuoOrdItemNote,"|",4)
    //w $g(^PHCFR(+phcfrId)),!
	s prcfrDesc=$p($g(^PHCFR(+phcfrId)),"^",3)
	s phcfrFactor=$p($g(^PHCFR(+phcfrId)),"^",2)
    s oeoriNote=$p(icuoOrdItemNote,"|",5)
    
    s defPhcinId="",defPhcinCode="",defPhcinDesc="",oriQty="",unitUomId=""
	q oecprType_"^"_oecprCode_"^"_phcinId_"^"_phcinCode_"^"_phcinDesc_"^"_mainOeoriId_"^"_subOeoriId_"^"_defPhcinId_"^"_defPhcinCode_"^"_defPhcinDesc_"^"_oriQty_"^"_unitUomId_"^"_oecprDesc_"^"_phcfrId_"^"_prcfrDesc_"^"_phcfrFactor_"^"_oeoriNote
}

ClassMethod GetAttOrdStr(oeoriId, phcinId = "") As %String
{
	//w ##Class(web.DHCICUOrder).GetAttOrdStr("388422||28")
	/*q:oeoriId=""
	s oeordId=+oeoriId,oeoriSub=$p($g(oeoriId),"||",2)
	q:(oeordId=0)!(oeoriSub="") ""
    s oeoriId=oeordId_"||"_oeoriSub
    q:$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)'="" ""
    i phcinId="" s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7)
    */
    q:phcinId="" ""
    s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
    q:phcfrId="" ""
    s phfactor=$p($g(^PHCFR(phcfrId)),"^",2)
    k inattList
    s inattId="",itmmstStr=""
    f  s inattId=$o(^DHCOEInstrAttachOrd(0,"PHCInstr",phcinId,inattId))  q:inattId=""   d
        .s inattType=$p(^DHCOEInstrAttachOrd(inattId),"^",7)
        .q:inattType=""
        .s inPhcfrId=$p(^DHCOEInstrAttachOrd(inattId),"^",2)
        .q:(+inPhcfrId'=0)&(+phcfrId'=+inPhcfrId) //频次不对
        .i $d(inattList(inattType,+inPhcfrId))=0 s inattList(inattType,+inPhcfrId)=""
        .i inattList(inattType,+inPhcfrId)'="" s inattList(inattType,+inPhcfrId)=inattList(inattType,+inPhcfrId)_"^"
        .s inattList(inattType,+inPhcfrId)=$g(inattList(inattType,+inPhcfrId))_inattId
    s inattType=""
    f  s inattType=$o(inattList(inattType)) q:(inattType="")  d
        .i $d(inattList(inattType,0)) s inattList(inattType)=inattList(inattType,0)  //未指定频次
        .i $d(inattList(inattType,phcfrId)) s inattList(inattType)=inattList(inattType,phcfrId)  //有指定频次

    i ('$d(^DHCInstrAttOrd(+$h))) k ^DHCInstrAttOrd($h-7) //清除一周前数据
	s insTimes=0
    //s inattType="F"
    //s inattIdStr=$g(inattList(inattType))
    k insOrdList,normInsOrdList
    s maxPhfactor=$o(^DHCInstrAttOrd(+$h,+^OEORD(oeordId),phcinId,"F",""),-1)
	s insTimes=phfactor-maxPhfactor
    i insTimes<0 s insTimes=0
    s normTimes=phfactor
    //w "maxPhfactor="_maxPhfactor_"/"_insTimes_"/"_normTimes,!
    i $d(inattList("F")) s inattList("F","times")=insTimes,normTimes=normTimes-insTimes
    i $d(inattList("N")) s inattList("N","times")=normTimes
    s inattType=""
    f  s inattType=$o(inattList(inattType)) q:inattType=""  d
    	.q:$g(inattList(inattType,"times"))<1
    	.//q:$g(inattList(inattType))=""
    	.f iAtt=1:1:$l(inattList(inattType),"^") d
        	..s inattId=$p(inattList(inattType),"^",iAtt)
        	..q:inattId=""
        	..s arcimId=$p(^DHCOEInstrAttachOrd(inattId),"^",4)
        	..q:arcimId=""
        	..s qty=inattList(inattType,"times")*$p(^DHCOEInstrAttachOrd(inattId),"^",5)
        	..q:+qty=0
        	..s insOrdList(inattType,arcimId)=$g(insOrdList(inattType,arcimId))+qty
        	..s inattDefault=$p(^DHCOEInstrAttachOrd(inattId),"^",6)
        	..i inattDefault="" s inattDefault="S"
        	..s insOrdList(inattType,arcimId)=insOrdList(inattType,arcimId)_$c(3)_inattDefault  //新加
    s inattType="",retStr=""
    f  s inattType=$o(insOrdList(inattType)) q:(inattType="")  d
    	.s arcimId=""
    	.f  s arcimId=$o(insOrdList(inattType,arcimId)) q:(arcimId="")  d
        	..s qty=insOrdList(inattType,arcimId)
        	..i retStr'="" s retStr=retStr_"^"
        	..s retStr=retStr_arcimId_$c(3)_qty
    q retStr
}

/// Creator：      	ypz
/// CreatDate：    	2010-03-30
/// Description： 	查找用法关联的医嘱(类型为N,频率不为空的不考虑,默认计费模式是单位计费Y)
/// Table：        	DHC_OE_InstrAttachOrd
/// Input：        	入参：用法phcinId,为空查全部
/// Output：        返回：用法phcinId; 医嘱arcimId; 默认数量qty;表的INATT_Default字段用作计费模式(N为连续计费,Y为单次计费);
/// Return：       	
Query FindPhcinAttachArcim(phcinId) As %Query(ROWSPEC = "inattId:%String,tPhcinId:%String,tQty:%String,tDefaultMode:%String,tDefault:%String") [ SqlProc ]
{
}

ClassMethod FindPhcinAttachArcimExecute(ByRef qHandle As %Binary, phcinId) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1

    s tPhcinId=0
    f  s tPhcinId=$o(^DHCOEInstrAttachOrd(0,"PHCInstr",tPhcinId)) q:tPhcinId=""  d
        .q:(phcinId'="")&(phcinId'=tPhcinId)
        .s inattId=0
        .f  s inattId=$o(^DHCOEInstrAttachOrd(0,"PHCInstr",tPhcinId,inattId)) q:inattId=""  d
            ..s inattType=$p(^DHCOEInstrAttachOrd(inattId),"^",7)
            ..q:inattType=""
            ..q:inattType'="N"
            ..//w inattId,inattType
            ..q:$p(^DHCOEInstrAttachOrd(inattId),"^",2)'="" //暂不考虑用法不为空的
            ..s tArcimId=$p(^DHCOEInstrAttachOrd(inattId),"^",4)
            ..q:tArcimId=""
            ..//w inattId,!
            ..s tQty=$p(^DHCOEInstrAttachOrd(inattId),"^",5)
            ..s tDefault=$p(^DHCOEInstrAttachOrd(inattId),"^",6)
            ..i tDefault="" s tDefault="Y"
	        ..d OutputRow1
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(inattId,tPhcinId,tArcimId,tQty,tDefault)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindPhcinAttachArcimFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPhcinAttachArcimExecute ]
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

ClassMethod FindPhcinAttachArcimClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPhcinAttachArcimExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 体温单用
ClassMethod GetICUOrderDataByTime(icuaId As %String, date As %String, time As %String, icucriCodeStr As %String, curIcucriList As %String) As %Library.String
{
	s num=0
	q:icuaId="" num
	q:icucriCodeStr="" num
	;b ;"GetICUOrderDataByTime"
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	
	f i=1:1:$l(icucriCodeStr,"^") d
		.s icucriCode=$p(icucriCodeStr,"^",i)
		.s icucriId=$o(^DHCICUC("RecordItem",0,"Code",icucriCode,""))
		.s value=..GetRecordValue(icuaId,icucriId,date,time,date,time,"First")
		.s userId=..GetRecordValue(icuaId,icucriId,date,time,date,time,"First","","","","UserId")
		.i value="" d
			..s spareIcucriCode=$p(curIcucriList(icucriCode),"^",4)
			..q:spareIcucriCode=""
			..s spareIcucriId=$o(^DHCICUC("RecordItem",0,"Code",spareIcucriCode,""))
			..q:spareIcucriId=""
			..s value=..GetRecordValue(icuaId,spareIcucriId,date,time,date,time,"First")
			..q:value=""
			..s userId=..GetRecordValue(icuaId,spareIcucriId,date,time,date,time,"First","","","","UserId")
		.q:value=""
		.s num=num+1
		.s ^TMPICU("Temperature",$j,icuaId,date,time,icucriCode)=value_"^"_userId // $p(^DHCICUOrder(icuoId),"^",11)_"^"_$p(^DHCICUOrder(icuoId),"^",4)
	q num
	
	s icuoId=""
	f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId,time,icuoId)) q:icuoId=""  d
		.q:'$d(^DHCICUOrder(icuoId))
		.q:"ICDRU"[$p(^DHCICUOrder(icuoId),"^",25)  //状态P视为普通
		.s icucriId=$p(^DHCICUOrder(icuoId),"^",2)	//ICUO_ComOrd_Dr
		.s icucriCode=$p(^DHCICUC("RecordItem",icucriId),"^",1)
		.q:icucriCode=""
		.q:("^"_icucriCodeStr_"^")'[("^"_icucriCode_"^")	//接口未定义
		.;w "icuoId="_icuoId_" icucriId="_icucriId,!
		.s num=num+1
		.s ^TMPICU("Temperature",$j,icuaId,date,time,icucriCode)=$p(^DHCICUOrder(icuoId),"^",11)_"^"_$p(^DHCICUOrder(icuoId),"^",4)
		.q:'$d(curIcucriList(icucriCode))
		.q:$p(curIcucriList(icucriCode),"^",3)=""
		.i $p(^DHCICUOrder(icuoId),"^",11)'<$p(curIcucriList(icucriCode),"^",2) d
			..s addDate=date,addTime=time+$p(curIcucriList(icucriCode),"^",3)
			..q:addTime<time
			..i addTime'<86400 d
				...s addTime=addTime-86400
				...s addDate=addDate+1
			..s addIcuoId=""
			..f  s addIcuoId=$o(^DHCICUOrder(0,"SttDateTime",addDate,icuaId,addTime,addIcuoId)) q:addIcuoId=""  d
				...q:'$d(^DHCICUOrder(addIcuoId))
				...q:$p(^DHCICUOrder(addIcuoId),"^",2)'=icucriId
				...q:"ICDRU"[$p(^DHCICUOrder(addIcuoId),"^",25)  //状态P视为普通
				...w addDate_"/"_addTime_"/"_addIcuoId,!
				...s ^TMPICU("Temperature",$j,icuaId,addDate,addTime,icucriCode)=$p(^DHCICUOrder(addIcuoId),"^",11)_"^"_$p(^DHCICUOrder(addIcuoId),"^",4)
				...s num=num+1
	q num
}

ClassMethod GetSumValue(icucioiId, icuoId, value = "") As %String
{
	q:(icucioiId="")!(icuoId="") 0
	q:'$d(^DHCICUC("IOItem",icucioiId)) 0
	q:$p(^DHCICUC("IOItem",icucioiId),"^",7)'="Y" 0
	//q:'$d(^DHCICUC("RecordItem",icucriId)) 0
	q:$p(^DHCICUC("IOItem",icucioiId),"^",10)="TimePoint" 1
	i value="" d
		.i $p(^DHCICUC("IOItem",icucioiId),"^",12)="Qty" s value=$p(^DHCICUOrder(icuoId),"^",11)
		.i $p(^DHCICUC("IOItem",icucioiId),"^",12)="Volume" s value=$p(^DHCICUOrder(icuoId),"^",28)
	q:$p(^DHCICUC("IOItem",icucioiId),"^",11)="" value
	q $fn($p(^DHCICUC("IOItem",icucioiId),"^",11)*value,"",4)
}

/// 按时间汇总出入量数据，供前台显示  ctlocId, icuaId不能同时空，dayBaseTime是第一个班次开始时间,isSumAfter是否汇总到下一整点
/// w ##class(web.DHCICUOrder).GetSummaryData(88,4742,$h-1,"7:00",$h,"6:59","7:00")
/// w ##class(web.DHCICUOrder).GetSummaryData(88,4742,$h-1,"6:01",$h,"6:00","6:00",1)
ClassMethod GetSummaryData(ctlocId, icuaId, startDate, startTime, endDate, endTime, dayBaseTime, isSumAfter = 0) As %Library.String
{
	s retStr=0
	q:(ctlocId="")&(icuaId="") -1
	
	k ^TMPICU("Summary",$j)
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
		.//w icucioiId,!
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
		.//w mainIcucriId,"/"_subIcucriId,!
		.//q:'$d(mainSummaryList(mainIcucioiId))
		.s icucriSumList(mainIcucriId,"Hour")=0
		.s icucriSumList(mainIcucriId,"Day")=0
		.s icucriSumList(mainIcucriId,subIcucriId)=0
		.i "HourAndTotal"=icucioiStrategy s subIcucriList(subIcucriId,mainIcucriId)=icucioiId
		.i "AfterTotalInOut"=icucioiStrategy s afterIOIcucriList(subIcucriId)=mainIcucriId_"^"_icucioiId //w "second:"_mainIcucriId,!
	s $ZT="ERROR"
	k timeList
	k ^TMPICU("Temperature",$j)
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
						.....//w $zt(icuoSttTime)_" value:"_..GetSumValue(icucioiId,icuoId),!
						.....s icucriSumList(mainIcucriId,"Hour")=icucriSumList(mainIcucriId,"Hour")+..GetSumValue(icucioiId,icuoId)
						.....s icucriSumList(mainIcucriId,"Day")=icucriSumList(mainIcucriId,"Day")+..GetSumValue(icucioiId,icuoId)
		.s dateTime=latestDateTime
		.s dateTime=$o(timeList(dateTime),-1) //结束后汇总最后一次
		.i isSumAfter s dateTime=latestDateTime
		.f  s dateTime=$o(timeList(dateTime)) q:dateTime=""  d
			..m timeList(dateTime)=icucriSumList
			.. 
			..s icucriId=""
			..f  s icucriId=$o(icucriSumList(icucriId)) q:icucriId=""  d
				...//w dateTime_"/"_icucriId_" hour:"_icucriSumList(icucriId,"Hour"),!
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
				...s value=..GetSumValue(icucioiId,0,timeList(dateTime,afterIOIcucriId,"Hour"))
				...s timeList(dateTime,curMainIcucriId,"Hour")=timeList(dateTime,curMainIcucriId,"Hour")+value
				...s value=..GetSumValue(icucioiId,0,timeList(dateTime,afterIOIcucriId,"Day"))
				...s timeList(dateTime,curMainIcucriId,"Day")=timeList(dateTime,curMainIcucriId,"Day")+value
		.s dateTime=""
		.f  s dateTime=$o(timeList(dateTime)) q:dateTime=""  d
			..q:dateTime<startDateTime
			..s mainIcucriId=""
			..f  s mainIcucriId=$o(timeList(dateTime,mainIcucriId)) q:mainIcucriId=""  d
				...s count=count+1
				...s ancvcId=$p($g(^DHCICUC("RecordItem",mainIcucriId)),"^",5)
				...//监护记录Id，显示分类Id、常用医嘱Id，汇总日期，汇总时间，小时汇总量，第一班次开始汇总量
				...s ^TMPICU("Summary",$j,count)=$lb(icuaId,ancvcId,mainIcucriId,$zd($p(dateTime,"."),3),$zt((dateTime-$p(dateTime,".")*100000),2),timeList(dateTime,mainIcucriId,"Hour"),timeList(dateTime,mainIcucriId,"Day"))
				...s ^TMPICUTOTAL("Summary",$j,icuaId,$zd($p(dateTime,"."),3)_","_$zt((dateTime-$p(dateTime,".")*100000),2),mainIcucriId)=timeList(dateTime,mainIcucriId,"Hour") ;$lb(icuaId,ancvcId,mainIcucriId,$zd($p(dateTime,"."),3),$zt((dateTime-$p(dateTime,".")*100000),2),timeList(dateTime,mainIcucriId,"Hour"),timeList(dateTime,mainIcucriId,"Day"))
				...s ^TMPICUTOTALTEST("Summary",$j,icuaId,$zd($p(dateTime,"."),3),$zt((dateTime-$p(dateTime,".")*100000),2),mainIcucriId)=timeList(dateTime,mainIcucriId,"Hour") ;$lb(icuaId,ancvcId,mainIcucriId,$zd($p(dateTime,"."),3),$zt((dateTime-$p(dateTime,".")*100000),2),timeList(dateTime,mainIcucriId,"Hour"),timeList(dateTime,mainIcucriId,"Day"))
				...;w icuaId,"/",mainIcucriId,"/",$zd($p(dateTime,"."),3),"/",$zt((dateTime-$p(dateTime,".")*100000),2),"/",timeList(dateTime,mainIcucriId,"Hour"),"/",timeList(dateTime,mainIcucriId,"Day"),!
	q count
ERROR	; 
	q $ZE	           //得到系统返回的错误消息
 	//Quit "-1"
}

/// 按时间汇总出入量数据，供前台显示  ctlocId, icuaId不能同时空，dayBaseTime是第一个班次开始时间,isSumAfter是否汇总到下一整点
/// w ##class(web.DHCICUOrder).GetSummaryData(88,4742,$h-1,"7:00",$h,"6:59","7:00")
/// w ##class(web.DHCICUOrder).GetSummaryDataNew(16,2,"2023-05-15","7:00","2023-05-16","6:59","7:00")
ClassMethod GetSummaryDataNew(ctlocId, icuaId, startDate, startTime, endDate, endTime, dayBaseTime, isSumAfter = 0) As %Library.String
{
	// w ##class(web.DHCICUOrdr).IOSummary(617,"240002","2019-06-03","07:00","2019-06-04","07:00","07:00")
	k ^TMPICU("Summary",$j)
	s isSumAfter=0
	s isSumAfter=1
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s endTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
	s dayBaseTime=##class(web.DHCClinicCom).ConvertToTimeH(dayBaseTime)
	do Init
	
	
	s icupId=$o(^DHCICUPara(0,"ICUA",icuaId,""))
	// b // s latestDateTime=$o(timeList("")),preDateTime=$o(timeList("")) //从第一个汇总时间点起
	
	f curDate=startDate:1:endDate
	{
		s icuoSttTime=""
		f
		{
			s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime))
			q:icuoSttTime=""
			continue:('isSumAfter)&(curDate=startDate)&(icuoSttTime<dayBaseTime) //开始时间入
			continue:(isSumAfter)&(curDate=startDate)&(icuoSttTime<dayBaseTime) //开始时间入
			continue:('isSumAfter)&(curDate=endDate)&(icuoSttTime'<endTime) //(icuoSttTime>endTime) //(icuoSttTime'<endTime)
			continue:(isSumAfter)&(curDate=endDate)&(icuoSttTime>endTime) //(icuoSttTime>endTime) //(icuoSttTime'<endTime)
			s sttDateTime=curDate+(icuoSttTime/100000)

			s icuoId=""
			f
			{
				s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId))
				q:icuoId=""

				q:'$d(^DHCICUOrder(icuoId))
				s order=##class(User.DHCICUOrder).%OpenId(icuoId)
				continue:"ICDRU"[order.ICUOEditFlag
				continue:order.ICUOComOrdDr=""
				s recordId=order.ICUOComOrdDr.%Id()				//ICUO_ComOrd_Dr
				s arcimId=order.ICUOArcimDr
				continue:(recordId="")
				continue:'$d(SubRecordList(recordId))
				s intTime=icuoSttTime\3600 ; 向下取整
				i isSumAfter s intTime=(icuoSttTime-1)\3600+1 ;向上取整
				s intDatetime=curDate_"."_intTime
				d CalData(recordId,intDatetime,curDate,icuoSttTime)

			}
		}
	}
	
	// 添加为空的数据
	s startDateTime=(startDate*24)+(startTime\3600)
	s endDateTime=(endDate*24)+(endTime\3600)
	s hourCount=endDateTime-startDateTime
	;b //
	s count=1
	i ('$D(ResultList)){
		s mainId=""
    	for
    	{
	    	s mainId=$O(MainRecordList(mainId))
	    	q:mainId=""
    		s ResultList(mainId)=0 
    		
    	}
	}
	s mainId=""
	f
	{
		s mainId=$O(ResultList(mainId))
		q:mainId=""
		s dayValue=0
		s ancvcId=$p($g(^DHCICUC("RecordItem",mainId)),"^",5)
		f hourTime=startDateTime:1:endDateTime
		{
			s date=hourTime\24
			s time=(hourTime#24)
			s intDateTime=date_"."_time
			i '$D(ResultList(mainId,"Hour",intDateTime)) s ResultList(mainId,"Hour",intDateTime)=0
			i '$D(ResultList(mainId,"Day",intDateTime)) s ResultList(mainId,"Day",date)=0

			s dateStr=$zd(date,3)
			s timeStr=$zt(time*3600,2)
			s hourValue=ResultList(mainId,"Hour",intDateTime)
			s curDayValue=$g(ResultList(mainId,"Day",intDateTime))
			i curDayValue'="" s dayValue=curDayValue
			s ^TMPICU("Summary",$j,count)=$lb(icuaId,ancvcId,mainId,dateStr,timeStr,hourValue,dayValue)
			s count=count+1
		}
		s actDateTime=""
		f
		{
			s actDateTime=$O(NonIntTime(actDateTime))
			q:actDateTime=""
			s curValue=$g(ResultList(mainId,"Exact",actDateTime))
			s curAccValue=$g(ResultList(mainId,"ExactAcc",actDateTime))
			s actDateStr=##class(web.DHCClinicCom).ConvertToDate(+actDateTime)
			s actTimeStr=##class(web.DHCClinicCom).ConvertToTime($p(actDateTime,",",2))
			s ^TMPICU("Summary",$j,count)=$lb(icuaId,ancvcId,mainId,actDateStr,actTimeStr,curValue,curAccValue)
			s count=count+1
		}
	}
	q count

CalData(recordId,intDateTime,actDate,actTime)
    s actDateTime=actDate_","_actTime
    s intDate=$p(intDateTime,".",1)
    
    s mainId=""
    for
    {
	    s mainId=$O(MainRecordList(mainId))
	    q:mainId=""
    	// s ResultList(mainId,"Exact",actDateTime)=0
    	i $g(ResultList(mainId,"Exact",actDateTime))=""
    	{
    		s ResultList(mainId,"Exact",actDateTime)=0 ; 非整点
    	}
    	i $g(ResultList(mainId,"ExactAcc",actDateTime))=""
    	{
    		s ResultList(mainId,"ExactAcc",actDateTime)=+$g(ResultList(mainId,"Acc")) ; 非整点累计
    	}
    }
	s mainIcucriId=""
	q:recordId=""
	for
	{
		s mainIcucriId=$o(SubRecordList(recordId,mainIcucriId))
		q:mainIcucriId=""
		s ioId=$g(SubRecordList(recordId,mainIcucriId))
		q:ioId=""
		s icupiId=order.ICUOICUPIDr 
		s value=..GetSumValue(ioId,icuoId)

		i mainIcucriId=5669 b
		s ResultList(mainIcucriId,"Hour",intDateTime)=+$g(ResultList(mainIcucriId,"Hour",intDateTime))+value
		s ResultList(mainIcucriId,"Acc")=+$g(ResultList(mainIcucriId,"Acc"))+value ;整点累计
		s ResultList(mainIcucriId,"Day",intDateTime)=+$g(ResultList(mainIcucriId,"Acc")) ;整点累计
		continue:(actTime#3600)=0
		s ResultList(mainIcucriId,"Exact",actDateTime)=+$g(ResultList(mainIcucriId,"Exact",actDateTime))+value ; 非整点
		s ResultList(mainIcucriId,"ExactAcc",actDateTime)=+$g(ResultList(mainIcucriId,"Acc")) ; 非整点累计
		s NonIntTime(actDateTime)=actDateTime
	}
    q
GetTemplateMainRecordId(locId,code)
    // 根据Code从科室模板获取RecordItemId
    s id=""
    &sql(SELECT ICUPI_ComOrd_Dr into:id FROM DHC_ICU_ParaItem 
    WHERE ICUPI_Parref->ICUP_Ctloc_Dr=:locId AND ICUPI_Code=:code )
    q id
Init()
	set locId=ctlocId
	s rowId=""
    m LocIndex(locId)=^DHCICUC("IOItem",0,"Ctloc",locId)
	for
	{
		set rowId=$o(LocIndex(locId,rowId))
		quit:rowId=""

		continue:$p(^DHCICUC("IOItem",rowId),"^",7)'="Y"
		s ioInfo=##class(User.DHCICUCIOItem).%OpenId(rowId)
		s strategy=ioInfo.ICUCIOIStrategy
		i strategy="Normal" s strategy="HourAndTotal"
		i strategy="TherapySummary" s strategy="HourAndTotal"
		i rowId=180 b
		continue:"^HourAndTotal^AfterTotalInOut^TherapySummary^OnlyDataQty^"'[("^"_strategy_"^")
		continue:ioInfo.ICUCIOIComOrdDr=""
		s subRecordId=ioInfo.ICUCIOIComOrdDr.%Id()
		; 汇总ID根据Code与科室模板匹配
		set mainRecordId=$$GetMainRecordItemId()

		continue:mainRecordId=""

		set subObj=##class(User.DHCICUCRecordItem).%OpenId(subRecordId)
		s subCode=ioInfo.ICUCIOICode

		continue:subRecordId=""
		set SubRecordList(subRecordId,mainRecordId)=rowId 
		set MainRecordList(mainRecordId,subRecordId)=rowId
	}
	q 0
GetMainRecordItemId()
    s mainRecordId=""
    i ioInfo.ICUCIOIStrategy="TherapySummary"
    {
    	;s mainRecordId=subRecordId ; 治疗统计 以Code对应的Id为统计项;以RecordItemId为数据项

    	s mainRecordId=$$GetTemplateMainRecordId(locId,ioInfo.ICUCIOICode)

    	s subRecordId=ioInfo.ICUCIOIComOrdDr.%Id()
    }
    else
    {
		; s mainRecordId=$p(^DHCICUC("IOItem",mainId),"^",4)
		; 汇总ID根据Code与科室模板匹配
		i ioInfo.ICUCIOIMainICUCIOIDr'=""
		{
			s mainRecordId=$$GetTemplateMainRecordId(locId,ioInfo.ICUCIOIMainICUCIOIDr.ICUCIOICode)
		}
    }
	q mainRecordId
}

/// Creator：      	ypz
/// CreatDate：    	2013-03-14
/// Description： 	查询汇总数据
/// Table：        	DHC_ICU_Order
/// Input：        	入参：ctlocId科室ID，icuaId监护ID, 开始日期,开始时间,结束日期,结束时间,第一个班次开始时间
/// Output：        监护记录Id，显示分类Id，常用医嘱Id，汇总日期，汇总时间，小时汇总量，第一班次开始汇总量
/// Return：       	
Query FindSummaryData(ctlocId, icuaId, startDate, startTime, endDate, endTime, dayBaseTime) As %Query(ROWSPEC = "ArrangeId:%String,RecordCatId:%String,RecordItemId:%String,StartDate:%String,StartTime:%String,Qty:%String,Volume:%String") [ SqlProc ]
{
}

ClassMethod FindSummaryDataExecute(ByRef qHandle As %Binary, ctlocId, icuaId, startDate, startTime, endDate, endTime, dayBaseTime) As %Status
{
	//d ##CLASS(%ResultSet).RunQuery("web.DHCICUOrder","FindSummaryData",(88,12864,$h,"7:00",$h+1,"6:59","7:00")
	s repid=$i(^CacheTemp)
 	s ind=1
 	//20150608
 	s icuStartDate=$p($g(^DHCICUArrange(+icuaId)),"^",6)
 	s icuStartTime=$p($g(^DHCICUArrange(+icuaId)),"^",8)
 	s icuStartDate=##class(web.DHCClinicCom).ConvertToDateH(icuStartDate)
	s icuStartTime=##class(web.DHCClinicCom).ConvertToTimeH(icuStartTime)
 	s hStartDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
 	s hStartTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime) 	
 	s startDateTime=##class(web.DHCClinicCom).DateTimeAdd(icuStartDate,icuStartTime,"-7200") //冗余两小时
 	b ;"111"
 	i hStartDate<icuStartDate d
 		.s startDate=hStartDate ;$p(startDateTime,"^",1)
 		.s startTime=$p(startDateTime,"^",2)
 	i (hStartDate=icuStartDate)&(hStartTime<icuStartTime) d
 		.s startTime=hStartTime ;$p(startDateTime,"^",2)
 	s icuEndDate=$p($g(^DHCICUArrange(+icuaId)),"^",7)
 	s icuEndTime=$p($g(^DHCICUArrange(+icuaId)),"^",9)
 	s hEndDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
 	s hEndTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
 	
 	i ((hEndDate>icuEndDate)&(icuEndDate'=""))!((hEndDate=icuEndDate)&(hEndTime>icuEndTime)) d
 		.s endDate=##class(web.DHCClinicCom).ConvertToDateH(icuEndDate)
 		.s endTime=##class(web.DHCClinicCom).ConvertToTimeH(icuEndTime)
	//20150608
 	s count=..GetSummaryData(ctlocId, icuaId, startDate, startTime, endDate, endTime, dayBaseTime)
 	i count=+count d
 		.f seqNum=1:1:count d
 			..s Data=$g(^TMPICU("Summary",$j,seqNum))
 			..q:Data=""
 			..k ^TMPICU("Summary",$j,seqNum)
 			..d OutPutSum
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutPutSum
	//s Data=$lb(desc,rowId)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindSummaryDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSummaryDataExecute ]
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

ClassMethod FindSummaryDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSummaryDataExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

/// Creator：      	ypz
/// CreatDate：    	2013-03-14
/// Description： 	查询汇总数据
/// Table：        	DHC_ICU_Order
/// Input：        	入参：ctlocId科室ID，icuaId监护ID, 开始日期,开始时间,结束日期,结束时间,第一个班次开始时间
/// Output：        监护记录Id，显示分类Id，常用医嘱Id，汇总日期，汇总时间，小时汇总量，第一班次开始汇总量
/// Return：       d ##class(%ResultSet).RunQuery("web.DHCICUOrder","FindSummaryDataNew",16,2,"2023-05-15","7:00","2023-05-16","6:59","7:00")
Query FindSummaryDataNew(ctlocId, icuaId, startDate, startTime, endDate, endTime, dayBaseTime) As %Query(ROWSPEC = "ArrangeId:%String,RecordCatId:%String,RecordItemId:%String,StartDate:%String,StartTime:%String,Qty:%String,Volume:%String") [ SqlProc ]
{
}

ClassMethod FindSummaryDataNewExecute(ByRef qHandle As %Binary, ctlocId, icuaId, startDate, startTime, endDate, endTime, dayBaseTime) As %Status
{
	//d ##CLASS(%ResultSet).RunQuery("web.DHCICUOrder","FindSummaryDataNew",(16,21,"2023-04-24","7:00","2023-04-25","6:59","7:00")
	s repid=$i(^CacheTemp)
 	s ind=1
 	//20150608
 	s icuStartDate=$p($g(^DHCICUArrange(+icuaId)),"^",6)
 	s icuStartTime=$p($g(^DHCICUArrange(+icuaId)),"^",8)
 	s icuStartDate=##class(web.DHCClinicCom).ConvertToDateH(icuStartDate)
	s icuStartTime=##class(web.DHCClinicCom).ConvertToTimeH(icuStartTime)
 	s hStartDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
 	s hStartTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime) 	
 	s startDateTime=##class(web.DHCClinicCom).DateTimeAdd(icuStartDate,icuStartTime,"-7200") //冗余两小时
 	i hStartDate<icuStartDate d
 		.s startDate=hStartDate ;$p(startDateTime,"^",1)
 		.s startTime=$p(startDateTime,"^",2)
 	i (hStartDate=icuStartDate)&(hStartTime<icuStartTime) d
 		.s startTime=hStartTime ;$p(startDateTime,"^",2)
 	s icuEndDate=$p($g(^DHCICUArrange(+icuaId)),"^",7)
 	s icuEndTime=$p($g(^DHCICUArrange(+icuaId)),"^",9)
 	s hEndDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
 	s hEndTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
 	
 	// 港大当前时间之后的汇总数据不生成 by ccq 20210813
 	set now=(+$h)+($p($h,",",2)/100000)
 	set endDTH=hEndDate+(hEndTime/100000)
 	if (now<endDTH)
 	{
		;set endDate=+$h
		;set endTime=$p($h,",",2) 	
	}
 	
 	i ((hEndDate>icuEndDate)&(icuEndDate'=""))!((hEndDate=icuEndDate)&(hEndTime>icuEndTime)) d
 		.s endDate=##class(web.DHCClinicCom).ConvertToDateH(icuEndDate)
 		.s endTime=##class(web.DHCClinicCom).ConvertToTimeH(icuEndTime)
	//20150608
	b
 	s count=..GetSummaryDataNew(ctlocId, icuaId, startDate, startTime, endDate, endTime, dayBaseTime)
 	b
 	i count=+count d
 		.f seqNum=1:1:count d
 			..s Data=$g(^TMPICU("Summary",$j,seqNum))
 			..q:Data=""
 			..k ^TMPICU("Summary",$j,seqNum)
 			..d OutPutSum
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutPutSum
	//s Data=$lb(desc,rowId)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindSummaryDataNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSummaryDataNewExecute ]
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

ClassMethod FindSummaryDataNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSummaryDataNewExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

/// 获取体温单相关数据，根据入参插入数据
/// 入参：科室ctlocId, 重症病人icuaId, 开始日期startDate, 开始时间startTime, 结束日期endDate, 结束时间endTime, 是否发送ifSend
/// icuaId和ctlocId不能同时为空，icuaId优先级高;开始时间为""，默认前一天日期，结束日期为"",默认当天。
ClassMethod GetTemperatureData(ctlocId, icuaId, startDate, startTime, endDate, endTime, ifSend = "Y") As %Library.String
{
	//w ##class(web.DHCICUOrder).GetTemperatureData("",2798,"2014-05-06","00:00","2014-05-06","23:00","N")
	s $ZT="ERROR"
	s retStr=0
	q:(ctlocId="")&(icuaId="") "数据为空!"
	s InIcuDate=$p($g(^DHCICUArrange(+icuaId)),"^",6)
    s InIcuTime=+$p($g(^DHCICUArrange(+icuaId)),"^",8)
	s arrangeList=""
	s icuaIdList=icuaId
	i icuaIdList="" d
		.s icuaIdList=##class(web.DHCICUCom).FindIcuaIdList("", "", ctlocId)
	q:icuaIdList="" retStr
	s wardCtlocId=ctlocId
	i wardCtlocId="" s wardCtlocId=##Class(web.DHCICUCom).GetWardCtlocId("",icuaId)
	k timeList,sumList
	s icuctId="",summaryTime=0,arrangeList=""
	f  s icuctId=$o(^DHCICUC("Temperature",icuctId)) q:icuctId=""  d //配置时间体温单参数
		.s icuctList=^DHCICUC("Temperature",icuctId)
		.q:$lg(icuctList,10)'=wardCtlocId
		.s icucriCode=$li(icuctList,1)
		.s cIcucriList(icucriCode)=$li(icuctList,2)_"^"_$li(icuctList,6)_"^"_$li(icuctList,7)_"^"_$lg(icuctList,12)
		.s icuctType=$li(icuctList,8)
		.i icuctType="A" d
			..f i=1:1:$li(icuctList,3) d
				...s time=i*86400/$li(icuctList,3)+$li(icuctList,4)
				...i time'<86400 s time=time-86400
				...i '$d(arrangeList(time)) s arrangeList(time)=icucriCode
				...e  s arrangeList(time)=arrangeList(time)_"^"_icucriCode
		.;w "icucriId="_icucriCode_"^"_icuctType,!
		.s icucriId=$o(^DHCICUC("RecordItem",0,"Code",icucriCode,""))
		.q:icucriId=""
		.i (icuctType="R") d
			..i ($lg(icuctList,11)'="S") d
		    	...s icucriCode=$p(^DHCICUC("RecordItem",icucriId),"^",1)
				...f i=1:1:$li(icuctList,3) d
					....s time=i*86400/$li(icuctList,3)+$li(icuctList,4)
					....i time'<86400 s time=time-86400
					....i '$d(baseTimeList(time)) s baseTimeList(time)=icucriCode
					....e  s baseTimeList(time)=baseTimeList(time)_"^"_icucriCode
					....;w time_":"_baseTimeList(time),!
			..e  d //主汇总项
		    	...s icucriCode=$p(^DHCICUC("RecordItem",icucriId),"^",1)
				...s sumList(icucriId)=icucriCode
				...w "mainIcucriId:"_icucriId_":"_icucriCode,!
				...s summaryTime=$lg(icuctList,9)
				...s summaryInsertTime=$lg(icuctList,4)
	i startDate="" s startDate=$h-1
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s endTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
	s nowDate=$p($h,",",1)
	s nowTime=$p($h,",",2)
	s secend=##class(web.DHCClinicCom).CalculateDuration(endDate,endTime,nowDate,nowTime,"S")
	i secend>0 d
		.s endDate=nowDate
		.s endTime=nowTime
	s icucioiId=0
	f  s icucioiId=$o(^DHCICUC("IOItem",0,"Ctloc",wardCtlocId,icucioiId)) q:icucioiId=""  d //主项对应汇总项列表
		.q:'$d(^DHCICUC("IOItem",icucioiId))
		.q:$p(^DHCICUC("IOItem",icucioiId),"^",7)'="Y"
		.s mainIcucioiId=$p(^DHCICUC("IOItem",icucioiId),"^",9) //icucioiMainIcucioiId
		.s mainIcucriId=$p(^DHCICUC("IOItem",+mainIcucioiId),"^",4)
		.s subIcucriId=$p(^DHCICUC("IOItem",icucioiId),"^",4)
		.i $d(sumList(subIcucriId)) s mainIcucriId=subIcucriId
		.q:mainIcucriId=""
		.q:'$d(sumList(mainIcucriId))
		.//w mainIcucriId,"/"_subIcucriId,!
		.//s mainIcucriId=mainSummaryList(mainIcucioiId)
		.q:$d(sumList(mainIcucriId,subIcucriId))
		.i '$d(sumList(mainIcucriId,subIcucriId)) s sumList(mainIcucriId,subIcucriId)=icucioiId  
		.e  s sumList(mainIcucriId,subIcucriId)=sumList(mainIcucriId,subIcucriId)_"^"_icucioiId //多个？目前不支持
		.w mainIcucriId_" mainIcucriId:"_subIcucriId_"="_sumList(mainIcucriId,subIcucriId),!
	
	k ^TMPICU("Temperature",$j)
	s seqNum=0
	f curDate=startDate:1:endDate d
		.q:curDate=""
		.s time=""
		.f  s time=$o(baseTimeList(time)) q:time=""  d
			..q:(curDate=startDate)&(time<startTime)
			..q:(curDate=endDate)&(time'<endTime)
			..f i=1:1:$l(icuaIdList,"^") d
				...s icuaId=$p(icuaIdList,"^",i)
				...q:icuaId=""
				...s num=..GetICUOrderDataByTime(icuaId, curDate, time, baseTimeList(time), .cIcucriList)
				...//i num>0 w num_","_curDate_"/"_time_"/"_baseTimeList(time),!
	

	f curDate=startDate:1:endDate d
		.q:curDate=""
		.s time=""
		.f  s time=$o(arrangeList(time)) q:time=""  d
			..q:(curDate=startDate)&(time<startTime)
			..q:(curDate=endDate)&(time'<endTime)
			..f i=1:1:$l(icuaIdList,"^") d
				...s icuaId=$p(icuaIdList,"^",i)
				...q:icuaId=""
				...s icuInDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
				...s startWeekDate=$p(icuInDateTime,"^",1),inTime=$p(icuInDateTime,"^",2)
				...i inTime>time s startWeekDate=startWeekDate+1
				...s weekDay=$zd(startWeekDate,10)
				...//w icuaId_": "_curDate_"/"_$zd(curDate,10)_"  "_startWeekDate_"/"_weekDay
				...q:$zd(curDate,10)'=weekDay
				...//w time,arrangeList,!
				...i ("^"_arrangeList(time)_"^")[("^"_"PatHeight"_"^") s ^TMPICU("Temperature",$j,icuaId,curDate,time,"PatHeight")=$p(^DHCICUArrange(icuaId),"^",24)
				...i ("^"_arrangeList(time)_"^")[("^"_"PatWeight"_"^") s ^TMPICU("Temperature",$j,icuaId,curDate,time,"PatWeight")=$p(^DHCICUArrange(icuaId),"^",25)

	f curDate=startDate:1:endDate d
		.f i=1:1:$l(icuaIdList) d
			..s icuaId=$p(icuaIdList,"^",i)
			..q:icuaId=""
			..s icuoSttTime=""
			..f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
				...q:(curDate=startDate)&(icuoSttTime<summaryTime) //开始时间入
				...q:(curDate=endDate)&(icuoSttTime'<summaryTime)
				...s summaryDate=curDate
				...i icuoSttTime'<summaryTime s summaryDate=curDate+1
				...s sttDateTime=curDate+(icuoSttTime/100000)
				...s icuoId=""
				...f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
					....q:'$d(^DHCICUOrder(icuoId))
					....q:"ICDRU"[$p(^DHCICUOrder(icuoId),"^",25) 
					....s icucriId=$p(^DHCICUOrder(icuoId),"^",2)				//ICUO_ComOrd_Dr
					....s arcimId=$p(^DHCICUOrder(icuoId),"^",9)
					....q:(icucriId="")&(arcimId="")
					....s mainIcuoId=$p(^DHCICUOrder(icuoId),"^",36)
					....q:mainIcuoId'=""
					....s mainIcucriId=""
					....//w icucriId,!
					....f  s mainIcucriId=$o(sumList(mainIcucriId)) q:mainIcucriId=""  d
						.....s subIcucriId=""
						.....f  s subIcucriId=$o(sumList(mainIcucriId,subIcucriId)) q:subIcucriId=""  d
							......q:(subIcucriId'=icucriId)
							......w subIcucriId_"===="_icucriId,!
							......s icucioiId=sumList(mainIcucriId,subIcucriId)
							......s mainIcucriCode=$p(^DHCICUC("RecordItem",mainIcucriId),"^",1)
							......s tmpStr=$g(^TMPICU("Temperature",$j,icuaId,summaryDate,summaryInsertTime,mainIcucriCode))+..GetSumValue(icucioiId,icuoId)
							......s tmpStr=tmpStr_"^"_$p(^DHCICUOrder(icuoId),"^",4) //最后时间用户
							......s ^TMPICU("Temperature",$j,icuaId,summaryDate,summaryInsertTime,mainIcucriCode)=tmpStr
							......//w sumList(mainIcucriId)_"/"_icuoId_"/"_mainIcucriId_"/"_curDate_" "_icuoSttTime_"/"_$zt(icuoSttTime)_" sum:"_tmpStr,!
	//i $d(^DHCICUSendTemperture(icuaId,curDate,curTime))>0 s ifSent="Y"
	;k ^TEMPWHL("GetTemperatureData")
	;q:ifSend'="Y" retStr
	b //before sync
	s singleInsertResult="",retStr=""
	s icuaId=""
	f  s icuaId=$o(^TMPICU("Temperature",$j,icuaId)) q:icuaId=""  d
		.s EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
		.s updateUserId=$p($g(^DHCICUArrange(icuaId)),"^",14)
		.s date=""
		.f  s date=$o(^TMPICU("Temperature",$j,icuaId,date)) q:date=""  d
			..s time=""
			..f  s time=$o(^TMPICU("Temperature",$j,icuaId,date,time)) q:time=""  d
				...s icucriCode=""
				...f  s icucriCode=$o(^TMPICU("Temperature",$j,icuaId,date,time,icucriCode)) q:icucriCode=""  d
					....s qty=$p(^TMPICU("Temperature",$j,icuaId,date,time,icucriCode),"^",1)
					....;s qtyASBP=$p($g(^TMPICU("Temperature",$j,icuaId,date,time,"ASBP")),"^",1)
					....;s qtyADBP=$p($g(^TMPICU("Temperature",$j,icuaId,date,time,"ADBP")),"^",1)
     				....;i (qtyASBP'="")&(icucriCode="NSBP") s qty=qtyASBP
					....;i (qtyADBP'="")&(icucriCode="NDBP") s qty=qtyADBP
					....;i (qtyASBP'="")&&(qtyADBP'="") ;w "qtyASBP="_qtyASBP_"qtyADBP="_qtyADBP_"^"_date_"^"_time ,!
					....s userId=$p(^TMPICU("Temperature",$j,icuaId,date,time,icucriCode),"^",2)
					....i userId="" s userId=updateUserId
					....;q:'$d(cIcucriList(icucriCode))
					....;w icucriCode,!
					....
					....s obItemId=$p(cIcucriList(icucriCode),"^",1)
					....q:obItemId=""
					....q:date<10000
					....s insertDate=date,insertTime=time
					....q:(insertDate=InIcuDate)&&(insertTime<InIcuTime)
					....i insertTime=0 s insertDate=insertDate-1,insertTime=86399
					....;护理组旧版体温单接口,第二个入参为项目Id
					....;i ifSend="Y" s singleInsertResult=##class(web.DHCTHREEE).InsertData(EpisodeID,obItemId,$zd(insertDate,3),$zt(insertTime),userId,qty)
					....;护理组新版体温单接口,第二个入参为项目code  YuanLin  20180906
					....i ifSend="Y" s singleInsertResult=##Class(Nur.Interface.OutSide.Patient).saveTemperature(EpisodeID,obItemId,qty,$zd(insertDate,3),$zt(insertTime),userId,ctlocId)
					....i singleInsertResult'=1 d LogFailure
					....s ^TEMPWHL("GetTemperatureData",icuaId,obItemId,$zd(date,3),$zt(time))="insert:"_ctlocId_","_icuaId_","_EpisodeID_","_obItemId_","_$zd(date,3)_","_$zt(time)_","_userId_","_qty_","_icucriCode_"^"_ifSend
				    ....w "insert:"_icuaId_","_EpisodeID_","_obItemId_","_$zd(date,3)_","_$zt(time)_","_userId_","_qty_","_icucriCode ,!
	i retStr="" s retStr=0
	i '$d(^TMPICU("Temperature",$j)) s retStr="无可同步体温单的数据！"
	q retStr
	
LogFailure()
	s failMessage=$p($g(^MRC("OBITM",+obItemId)),"^",2)_" 时间："_$zd(insertDate,3)_" "_$zt(insertTime)_" 插入失败 SQLCODE："_singleInsertResult
	s:retStr'="" retStr=retStr_$c(10)
	s retStr=retStr_failMessage
	q

ERROR	; 
	q $ZE	           //得到系统返回的错误消息
 	//Quit "-1"
}

/// Creator：      	ypz		//新版未用
/// CreatDate：    	2010-08-11
/// Description： 	按病人、时间点,偏离adjTime范围内最近的时间点数据,依常用医嘱数组
/// Table：        	DHC_ICU_Order
/// Input：        	入参：icuaId监护ID, dateTimeList用"^"分割的时间点，日期与时间用"|"分割,icucriIdList用"^"分割的常用医嘱串,
/// 					adjTime时间点偏离的时间(秒)。
/// Output：        
/// Return：       	返回：按时间点返回用"^"分割的数据，每个常用医嘱数据间用$c(3)分割。
ClassMethod GetICUOrdByTimeList(icuaId As %String, dateTimeList As %String, icucriIdStr As %String, adjTime As %String = 0) As %Library.String
{
	//w ##class(web.DHCICUOrder).GetICUOrdByTimeList(8,"61653|36000^61653|56000","85^86^90^910",3600)
	q:icuaId="" ""
	q:dateTimeList="" ""
	q:icucriIdStr="" ""
	s icuaIdList=icuaId
	i adjTime<0 s adjTime=0
	i adjTime>86400 s adjTime=adjTime-(adjTime\86400*86400)
	
	s icucriNum=$l(icucriIdStr,"^")
	f i=1:1:$l(icucriIdStr,"^") d
	    .s icucriId=$p(icucriIdStr,"^",i)
	    .q:icucriId=""
	    .s icucriIdPos(icucriId)=i
	
	s num=$l(dateTimeList,"^")
	s retStr="",needInd=1
	k retList
	f iDateTime=1:1:num d
		.s needDate=##class(web.DHCClinicCom).ConvertToDateH($p($p(dateTimeList,"^",iDateTime),"|",1))
		.s needTime=##class(web.DHCClinicCom).ConvertToTimeH($p($p(dateTimeList,"^",iDateTime),"|",2))
		.s needDateTime=needDate+(needTime/100000)
	    .//w needDateTime,!
	    .
	    .s startDate=needDate,endDate=needDate
	    .s startTime=needTime-adjTime
	    .i startTime<0 s startTime=startTime+86400,startDate=startDate-1
	    .s endTime=needTime+adjTime
	    .i endTime>86400 s endTime=endTime-86400,endDate=endDate+1
	    .s minTime=1 //一天
	    .
	    .f iIcucriId=1:1:icucriNum s $p(minTimeList,"^",iIcucriId)=1
	    .f iIcucriId=1:1:icucriNum s $p(findList,"^",iIcucriId)=0
	    .f curDate=startDate:1:endDate d
	        ..s icuoSttTime=""
	        ..i curDate=startDate s icuoSttTime=startTime-1 //当天
	        ..//w curDate,"/",icuoSttTime,!
	        ..s isExit=0
	        ..f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:(icuoSttTime="")!(isExit)  d
	            ...q:(curDate=startDate)&(icuoSttTime<startTime)
	            ...i (curDate=endDate)&(icuoSttTime'<endTime) s isExit=1 q
	            ...s sttDateTime=curDate+(icuoSttTime/100000)
	            ...s curMinTime=$zabs(sttDateTime-needDateTime)
	            ...
	            ...s icuoId=""
	            ...f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
	                ....q:'$d(^DHCICUOrder(icuoId))
	                ....s icucriId=$p(^DHCICUOrder(icuoId),"^",2)				//ICUO_ComOrd_Dr
	                ....q:icucriId=""
	                ....q:"DCRUI"[$p(^DHCICUOrder(icuoId),"^",25)  //状态P视为普通
	                ....q:$g(icucriIdPos(icucriId))<1 //接口未要求//!!未定义数据在外层过滤
	                ....i $p(minTimeList,"^",icucriIdPos(icucriId))<curMinTime s $p(findList,"^",icucriIdPos(icucriId))=1 q
	                ....
	                ....s $p(minTimeList,"^",icucriIdPos(icucriId))=curMinTime
	                ....s icuoStartDate=$p(^DHCICUOrder(icuoId),"^",5)
	                ....s icuoStartTime=$p(^DHCICUOrder(icuoId),"^",6)
	                ....s tmpStr=$p(^DHCICUOrder(icuoId),"^",4)_"!"			//ICUO_User_Dr
	                ....s tmpStr=tmpStr_$ZD(curDate,3)_"!"					//ICUO_StartDate
	                ....s tmpStr=tmpStr_$ZT(icuoStartTime)_"!"				//ICUO_StartTime
	                ....s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",10)_"!"	//ICUO_Note num:10
	                ....s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",11)_"!"	//ICUO_Qty
	                ....s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",12)_"!"	//ICUO_Uom_Dr
	                ....s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",29)_"!"	//ICUO_Source
	                ....s retList(needDateTime,icucriId)=tmpStr
	                ....//w needDateTime_"  "_icucriId_":"_retList(needDateTime,icucriId),!
	            ...s allFind=1
	            ...f iIcucriId=1:1:icucriNum i $p(findList,"^",iIcucriId)=0 s allFind=0
	            ...i allFind s isExit=1
	s needDateTime="",retStr=""
	f  s needDateTime=$o(retList(needDateTime)) q:needDateTime=""  d
		.s icucriId=""
		.f  s icucriId=$o(retList(needDateTime,icucriId)) q:icucriId=""  d
			..q:'$d(icucriIdPos(icucriId))
			..q:icucriIdPos(icucriId)<1
			..s $p(retStr,"^",icucriIdPos(icucriId))=retList(needDateTime,icucriId)
			..//w !,needDateTime_"  "_icucriId_":"_retList(needDateTime,icucriId)
	//w retStr,!
	q retStr
}

/// ??实入量位置//总有科室Id?	//新版未用
/// Creator：      	ypz
/// CreatDate：    	2010-08-11
/// Description： 	按病人、时间点,偏离adjTime范围内最近的时间点数据,依常用医嘱数组
/// Table：        	DHC_ICU_Order
/// Input：        	入参：icuaId监护ID, startDate开始日期，startTime开始时间，endDate结束日期，endTime结束时间，icucriIdList用"^"分割的常用医嘱串
/// 							icuoNoteList,用"^"分割，对应icucriIdList字段属性，为"S"取备注名,只能有一个
/// Output：        
/// Return：       	返回：以"|"分割的第一部分是按时间范围返回用"^"分割的各常用医嘱汇总。
/// 					第二部分是按备注分类。第二级以^分割多组，第三级是以$c(3)分割数据项，对应icucriIdList的名称或数量。
ClassMethod SumICUOrder(icuaId As %String, startDate As %String, startTime As %String, endDate As %String, endTime As %String, icucriIdStr As %String, icucriTypeList As %String = "") As %Library.String
{
	s retStr=""
	q:icuaId="" ""
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s endTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
	q:icucriIdStr="" retStr
	k icucriIdNoteList
	f i=1:1:$l(icucriIdStr,"^") s $p(retStr,"^",i)=0
	f curDate=startDate:1:endDate d
		.s icuoSttTime="",isExit=0
		.f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:(icuoSttTime="")!(isExit)  d
			..q:(curDate=startDate)&(icuoSttTime<startTime)
			..i (curDate=endDate)&(icuoSttTime'<endTime) s isExit=1 q
			..s sttDateTime=curDate+(icuoSttTime/100000)
			..s icuoId="",curNote="",valStr=""
			..f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
				...q:'$d(^DHCICUOrder(icuoId))
				...s icucriId=$p(^DHCICUOrder(icuoId),"^",2)				//ICUO_ComOrd_Dr
				...q:icucriId=""
				...q:"ICDRU"[$p(^DHCICUOrder(icuoId),"^",25)
				...q:("^"_icucriIdStr_"^")'[("^"_icucriId_"^")
				...s ind=0
				...f i=1:1:$l(icucriIdStr,"^") i $p(icucriIdStr,"^",i)=icucriId s ind=i
				...q:ind=0
				...s $p(retStr,"^",ind)=$p(retStr,"^",ind)+$p(^DHCICUOrder(icuoId),"^",11)
				...i $p(icucriTypeList,"^",ind)="S" s curNote=$p(^DHCICUOrder(icuoId),"^",10)
				...e  s $p(valStr,"^",ind)=$p(^DHCICUOrder(icuoId),"^",11)
			..i curNote'="" d
				...//w curNote_","_valStr,!
				...s noteStr=""
				...f i=1:1:$l(icucriIdStr,"^") d
					....i $p(icucriTypeList,"^",i)="S" s $p(icucriIdNoteList(curNote),$c(3),i)=curNote q
					....s $p(icucriIdNoteList(curNote),$c(3),i)=$p($g(icucriIdNoteList(curNote)),$c(3),i)+$p(valStr,"^",i)
	s retStr=retStr_"^" //保证原来程序不修改
	s noteStr="",icuoNote=""
	f  s icuoNote=$o(icucriIdNoteList(icuoNote)) q:icuoNote=""  d
		.i noteStr'="" s noteStr=noteStr_"^"
		.s noteStr=noteStr_icucriIdNoteList(icuoNote)
	i noteStr'="" s retStr=retStr_"|"_noteStr
	q retStr
}

/// Description： 	取出量汇总及单个项目出量
/// Table：        	DHC_ICU_Order
/// Input：        	入参：icuaId监护ID, dateTimeList用"^"分割的时间点，日期与时间用"|"分割,icucriIdList用"^"分割的常用医嘱串,needAncvcId:显示分类Id
/// Output：        
/// Return：       	返回：按时间点返回用"^"分割的数据，每个常用医嘱数据间用$c(3)分割。
/// w ##class(web.DHCICUOrder).SumICUOutLiang("9","65876","08:00","65876","19:59")
/// w ##class(web.DHCICUOrder).SumICUOutLiang("9","65876","08:00","65877","07:59")
/// w ##class(web.DHCICUOrder).SumICUOutLiang("2","2021-05-23","17:00","2021-05-23","17:59")
/// w ##class(web.DHCICUOrder).SumICUOutLiang("3","2021-06-08","8:00","2021-06-09","07:59",7378)
/// w ##class(web.DHCICUOrder).SumICUOutLiang("4","2021-07-22","8:00","2021-07-23","07:59",7378)
/// w ##class(web.DHCICUOrder).SumICUOutLiang("4","2021-07-22","8:00","2021-07-22","14:59",7378)
ClassMethod SumICUOutLiang(icuaId As %String, startDate As %String, startTime As %String, endDate As %String, endTime As %String, comOrdId As %String = "", needAncvcId As %String = "") As %Library.String
{
	s retStr=""
	s icuaIdList=icuaId
	q:icuaIdList="" retStr
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s endTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
	s ctlocId=""
	i ctlocId="" d
		.s EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
		.q:EpisodeID=""
		.s wardId=$p($g(^PAADM(EpisodeID)),"^",70)
		.s ctlocId=$p(^PAWARD(+wardId),"^",5) //准备取科室定义的出入量
	q:ctlocId="" "" 
	s inIcucriIdList="",outIcucriIdList="",inAncvcIdList="",outAncvcIdList=""
	s icucioiId=""
	f  s icucioiId=$o(^DHCICUC("IOItem",icucioiId)) q:icucioiId=""  d
		.q:$p(^DHCICUC("IOItem",icucioiId),"^",8)'=ctlocId
		.q:$p(^DHCICUC("IOItem",icucioiId),"^",9)=1553	///过滤掉水平衡关联项目
		.q:$p(^DHCICUC("IOItem",icucioiId),"^",9)=1552	///过滤掉平均尿量关联项目
		.q:"IO"'[$p(^DHCICUC("IOItem",icucioiId),"^",3)
		.i +$p(^DHCICUC("IOItem",icucioiId),"^",4)>0 d
			..i $p(^DHCICUC("IOItem",icucioiId),"^",3)="O" d
				...;q:$p(^DHCICUC("IOItem",icucioiId),"^",4)'=7378
				...i outIcucriIdList'="" s outIcucriIdList=outIcucriIdList_"^"
				...s outIcucriIdList=outIcucriIdList_$p(^DHCICUC("IOItem",icucioiId),"^",4)
		.e  d
			..q:+$p(^DHCICUC("IOItem",icucioiId),"^",5)=0
			..i $p(^DHCICUC("IOItem",icucioiId),"^",3)="O" d
				...;q:$p(^DHCICUC("IOItem",icucioiId),"^",4)'=7378
				...i outAncvcIdList'="" s outAncvcIdList=outAncvcIdList_"^"
				...s outAncvcIdList=outAncvcIdList_$p(^DHCICUC("IOItem",icucioiId),"^",5)

	s totalInput=0,totalOutput=0,LevelTotalPut=0
	f curDate=startDate:1:endDate d
		.f i=1:1:$l(icuaIdList) d
			..s icuaId=$p(icuaIdList,"^",i)
			..q:icuaId=""
			..s icuoSttTime="",isExit=0
			..f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:(icuoSttTime="")!(isExit)  d
				...q:(curDate=startDate)&(icuoSttTime<startTime)
				...i (curDate=endDate)&(icuoSttTime'<endTime) s isExit=1 q
				...s sttDateTime=curDate+(icuoSttTime/100000)
				...s icuoId=""
				...f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
					....q:'$d(^DHCICUOrder(icuoId))
					....//w icuoId,!
					....s icucriId=$p(^DHCICUOrder(icuoId),"^",2)				//ICUO_ComOrd_Dr
					....q:(comOrdId'="")&(comOrdId'=icucriId)
					....s arcimId=$p(^DHCICUOrder(icuoId),"^",9)
					....q:(icucriId="")&(arcimId="")
					....s mainIcuoId=$p(^DHCICUOrder(icuoId),"^",36)
					....q:mainIcuoId'=""
					....q:"DCRUI"[$p(^DHCICUOrder(icuoId),"^",25)
					....
					....s ancvcId=$p(^DHCICUOrder(icuoId),"^",16)
					....q:(needAncvcId'="")&(needAncvcId'=ancvcId)
					....i (("^"_inIcucriIdList_"^")[("^"_icucriId_"^"))!(("^"_inAncvcIdList_"^")[("^"_ancvcId_"^")) d
						.....s totalInput=totalInput+$p(^DHCICUOrder(icuoId),"^",11)
					....i (("^"_outIcucriIdList_"^")[("^"_icucriId_"^"))!(("^"_outAncvcIdList_"^")[("^"_ancvcId_"^")) d
						.....s totalOutput=totalOutput+$p(^DHCICUOrder(icuoId),"^",11)
	q totalOutput
}

/// Creator：      	ypz	//新版未用
/// CreatDate：    	2010-08-12
/// Description： 	取科室总出入量
/// Table：        	DHC_ICU_Order
/// Input：        	入参：icuaId监护ID, dateTimeList用"^"分割的时间点，日期与时间用"|"分割,icucriIdList用"^"分割的常用医嘱串,needAncvcId:显示分类Id
/// Output：        
/// Return：       	返回：按时间点返回用"^"分割的数据，每个常用医嘱数据间用$c(3)分割。
/// w ##class(web.DHCICUOrder).SumICUInLiang("9","65876","08:00","65876","19:59")
/// w ##class(web.DHCICUOrder).SumICUInLiang("9","65876","08:00","65877","07:59")
/// w ##class(web.DHCICUOrder).SumICUInLiang("2","2021-05-23","17:00","2021-05-23","17:59")
/// w ##class(web.DHCICUOrder).SumICUInLiang("3","2021-06-08","8:00","2021-06-09","07:59","7397^7401")
/// w ##class(web.DHCICUOrder).SumICUInLiang("3","2021-06-08","8:00","2021-06-09","07:59","7397")
/// w ##class(web.DHCICUOrder).SumICUInLiang("9","2021-07-20","7:00","2021-07-21","06:59","")
ClassMethod SumICUInLiang(icuaId As %String, startDate As %String, startTime As %String, endDate As %String, endTime As %String, comOrdId As %String, needAncvcId As %String = "") As %Library.String
{
	s retStr=""
	s icuaIdList=icuaId
	q:icuaIdList="" retStr
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s endTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
	s ctlocId=""
	i ctlocId="" d
		.s EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
		.q:EpisodeID=""
		.s wardId=$p($g(^PAADM(EpisodeID)),"^",70)
		.s ctlocId=$p(^PAWARD(+wardId),"^",5) //准备取科室定义的出入量
	q:ctlocId="" "" 
	s inIcucriIdList="",outIcucriIdList="",inAncvcIdList="",outAncvcIdList=""
	s icucioiId=""
	f  s icucioiId=$o(^DHCICUC("IOItem",icucioiId)) q:icucioiId=""  d
		.q:$p(^DHCICUC("IOItem",icucioiId),"^",8)'=ctlocId
		.q:$p(^DHCICUC("IOItem",icucioiId),"^",9)=1553	///过滤掉水平衡关联项目
		.q:$p(^DHCICUC("IOItem",icucioiId),"^",9)=1552	///过滤掉平均尿量关联项目
		.q:"IO"'[$p(^DHCICUC("IOItem",icucioiId),"^",3)
		.i +$p(^DHCICUC("IOItem",icucioiId),"^",4)>0 d
			..i $p(^DHCICUC("IOItem",icucioiId),"^",3)="I" d
				...i inIcucriIdList'="" s inIcucriIdList=inIcucriIdList_"^"
				...s inIcucriIdList=inIcucriIdList_$p(^DHCICUC("IOItem",icucioiId),"^",4)
		.e  d
			..q:+$p(^DHCICUC("IOItem",icucioiId),"^",5)=0
			..i $p(^DHCICUC("IOItem",icucioiId),"^",3)="I" d
				...i inAncvcIdList'="" s inAncvcIdList=inAncvcIdList_"^"
				...s inAncvcIdList=inAncvcIdList_$p(^DHCICUC("IOItem",icucioiId),"^",5)
	b ;0
	s totalInput=0,totalOutput=0,LevelTotalPut=0
	f curDate=startDate:1:endDate d
		.f i=1:1:$l(icuaIdList) d
			..s icuaId=$p(icuaIdList,"^",i)
			..q:icuaId=""
			..s icuoSttTime="",isExit=0
			..f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:(icuoSttTime="")!(isExit)  d
				...q:(curDate=startDate)&(icuoSttTime<startTime)
				...i (curDate=endDate)&(icuoSttTime'<endTime) s isExit=1 q
				...s sttDateTime=curDate+(icuoSttTime/100000)
				...s icuoId=""
				...f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
					....q:'$d(^DHCICUOrder(icuoId))
					....//w icuoId,!
					....s icucriId=$p(^DHCICUOrder(icuoId),"^",2)				//ICUO_ComOrd_Dr
					....q:(comOrdId'="")&(comOrdId'[icucriId)
					....s arcimId=$p(^DHCICUOrder(icuoId),"^",9)
					....q:(icucriId="")&(arcimId="")
					....s mainIcuoId=$p(^DHCICUOrder(icuoId),"^",36)
					....q:mainIcuoId'=""
					....q:"DCRUI"[$p(^DHCICUOrder(icuoId),"^",25)
					....
					....s ancvcId=$p(^DHCICUOrder(icuoId),"^",16)
					....q:(needAncvcId'="")&(needAncvcId'=ancvcId)
					....//w icuoId_"/"_icucriId,"/"_ancvcId,":"_inIcucriIdList_":"_inAncvcIdList,!
					....i (("^"_inIcucriIdList_"^")[("^"_icucriId_"^"))!(("^"_inAncvcIdList_"^")[("^"_ancvcId_"^")) d
						.....s totalInput=totalInput+$p(^DHCICUOrder(icuoId),"^",11)
						.....//w icuoId_"/"_icucriId_" totalInput:"_totalInput,!
	q totalInput
}

/// Creator：      	ypz	//新版未用 在用 20210728 ly
/// CreatDate：    	2010-08-12
/// Description： 	取科室总出入量
/// Table：        	DHC_ICU_Order
/// Input：        	入参：icuaId监护ID, dateTimeList用"^"分割的时间点，日期与时间用"|"分割,icucriIdList用"^"分割的常用医嘱串,needAncvcId:显示分类Id
/// Output：        
/// Return：       	返回：按时间点返回用"^"分割的数据，每个常用医嘱数据间用$c(3)分割。
/// w ##class(web.DHCICUOrder).SumICUInOut("9","65876","08:00","65876","19:59")
/// w ##class(web.DHCICUOrder).SumICUInOut("9","65876","08:00","65877","07:59")
/// w ##class(web.DHCICUOrder).SumICUInOut("2","2021-05-23","17:00","2021-05-23","17:59")
/// w ##class(web.DHCICUOrder).SumICUInOut("27","2021-08-13","8:00","2021-08-13","19:59")
ClassMethod SumICUInOut(icuaId As %String, startDate As %String, startTime As %String, endDate As %String, endTime As %String, needAncvcId As %String = "") As %Library.String
{
	//w ##class(web.DHCICUOrder).SumICUInOut("146","61967","32458","61968","32458")
	s retStr=""
	//q:(ctlocId="")&(icuaId="") ""
	s icuaIdList=icuaId
	//i icuaIdList="" d
	//	.s icuaIdList=##class(web.DHCICUCom).FindIcuaIdList(icuaId, EpisodeID, ctlocId)
	q:icuaIdList="" retStr
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s endTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
	s ctlocId=""
	i ctlocId="" d
		.s EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
		.q:EpisodeID=""
		.s wardId=$p($g(^PAADM(EpisodeID)),"^",70)
		.s ctlocId=$p(^PAWARD(+wardId),"^",5) //准备取科室定义的出入量
	q:ctlocId="" "" 
	s inIcucriIdList="",outIcucriIdList="",inAncvcIdList="",outAncvcIdList=""
	s icucioiId=""
	f  s icucioiId=$o(^DHCICUC("IOItem",icucioiId)) q:icucioiId=""  d
		.q:$p(^DHCICUC("IOItem",icucioiId),"^",8)'=ctlocId
		.q:$p(^DHCICUC("IOItem",icucioiId),"^",7)="N"
		.q:$p(^DHCICUC("IOItem",icucioiId),"^",9)=1553	///过滤掉水平衡关联项目
		.q:$p(^DHCICUC("IOItem",icucioiId),"^",9)=1552	///过滤掉平均尿量关联项目
		.q:"IO"'[$p(^DHCICUC("IOItem",icucioiId),"^",3)
		.i +$p(^DHCICUC("IOItem",icucioiId),"^",4)>0 d
			..i $p(^DHCICUC("IOItem",icucioiId),"^",3)="I" d
				...i inIcucriIdList'="" s inIcucriIdList=inIcucriIdList_"^"
				...s inIcucriIdList=inIcucriIdList_$p(^DHCICUC("IOItem",icucioiId),"^",4)
			..e  d
				...i outIcucriIdList'="" s outIcucriIdList=outIcucriIdList_"^"
				...s outIcucriIdList=outIcucriIdList_$p(^DHCICUC("IOItem",icucioiId),"^",4)
		.e  d
			..q:+$p(^DHCICUC("IOItem",icucioiId),"^",5)=0
			..i $p(^DHCICUC("IOItem",icucioiId),"^",3)="I" d
				...i inAncvcIdList'="" s inAncvcIdList=inAncvcIdList_"^"
				...s inAncvcIdList=inAncvcIdList_$p(^DHCICUC("IOItem",icucioiId),"^",5)
			..e  d
				...i outAncvcIdList'="" s outAncvcIdList=outAncvcIdList_"^"
				...s outAncvcIdList=outAncvcIdList_$p(^DHCICUC("IOItem",icucioiId),"^",5)
	
	//w "inAnc:"_inIcucriIdList,!
	//w "outAnc:"_outIcucriIdList,!
	//w "inAnc:"_inAncvcIdList,!
	//w "outAnc:"_outAncvcIdList,!
	s totalInput=0,totalOutput=0,LevelTotalPut=0
	f curDate=startDate:1:endDate d
		.f i=1:1:$l(icuaIdList) d
			..s icuaId=$p(icuaIdList,"^",i)
			..q:icuaId=""
			..s icuoSttTime="",isExit=0
			..f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:(icuoSttTime="")!(isExit)  d
				...q:(curDate=startDate)&(icuoSttTime<startTime)
				...i (curDate=endDate)&(icuoSttTime'<endTime) s isExit=1 q
				...s sttDateTime=curDate+(icuoSttTime/100000)
				...s icuoId=""
				...f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
					....q:'$d(^DHCICUOrder(icuoId))
					....//w icuoId,!
					....s icucriId=$p(^DHCICUOrder(icuoId),"^",2)				//ICUO_ComOrd_Dr
					....s arcimId=$p(^DHCICUOrder(icuoId),"^",9)
					....q:(icucriId="")&(arcimId="")
					....s mainIcuoId=$p(^DHCICUOrder(icuoId),"^",36)
					....q:mainIcuoId'=""
					....q:"DCRUI"[$p(^DHCICUOrder(icuoId),"^",25)
					....
					....s ancvcId=$p(^DHCICUOrder(icuoId),"^",16)
					....q:(needAncvcId'="")&(needAncvcId'=ancvcId)
					....//w icuoId_"/"_icucriId,"/"_ancvcId,":"_inIcucriIdList_":"_inAncvcIdList,!
					....i (("^"_inIcucriIdList_"^")[("^"_icucriId_"^"))!(("^"_inAncvcIdList_"^")[("^"_ancvcId_"^")) d
						.....s totalInput=totalInput+$p(^DHCICUOrder(icuoId),"^",11)
						.....//w icuoId_"/"_icucriId_" totalInput:"_totalInput,!
					....i (("^"_outIcucriIdList_"^")[("^"_icucriId_"^"))!(("^"_outAncvcIdList_"^")[("^"_ancvcId_"^")) d
						.....s totalOutput=totalOutput+$p(^DHCICUOrder(icuoId),"^",11)
						.....//w icuoId_"/"_icucriId_" totalOutput:"_totalOutput,!
	if ((totalInput'="")&&(totalOutput'="")) s LevelTotalPut=totalInput-totalOutput
	/*
	if totalInput=0  s totalInput=""
	if totalOutput=0  s totalOutput=""
	if LevelTotalPut=0  s LevelTotalPut=""
	*/
	q totalInput_"^"_totalOutput_"^"_LevelTotalPut
}

/// 未用
ClassMethod SumICUInOutEveryHourNew(icuaId As %String, startDate As %String) As %Library.String
{
	q:icuaId="" ""
	if startDate="" s startDate=+$h
	else  s startDate=##Class(web.DHCANOPCom).ConvertToDateH(startDate)
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s totalInOutLevel=""
	f i=1:1:24
    {	
    	i (i<17)
    	{
	    	s everyTotal=""
		    s time=(7+i)*3600
		    s everyTotal=..SumICUInOutEveryHourOld(icuaId,startDate,time)
		    
		    i totalInOutLevel="" s totalInOutLevel=everyTotal
		    else  s totalInOutLevel=totalInOutLevel_"#"_everyTotal
    	}
    	else
    	{
	    	s startDate=startDate+1
	    	s everyTotal=""
		    s time=(i-17)*3600
		    s everyTotal=..SumICUInOutEveryHourOld(icuaId,startDate,time)
		    
		    i totalInOutLevel="" s totalInOutLevel=everyTotal
		    else  s totalInOutLevel=totalInOutLevel_"#"_everyTotal
	    }
	    
    }
	q totalInOutLevel
}

/// 注：该方法只取到了整点上的数据（bug） 未用
/// Creator：      	ly
/// CreatDate：    	2021-05-14
/// Description： 	取科室每小时入量数据和  出量数据和 和出入量平衡
/// Table：        	DHC_ICU_Order
/// Input：        	入参：icuaId监护ID, dateTimeList用"^"分割的时间点，日期与时间用"|"分割,icucriIdList用"^"分割的常用医嘱串,needAncvcId:显示分类Id
/// Output：        
/// Return：       	返回：按时间点返回用"^"分割的数据，每个常用医嘱数据间用$c(3)分割。
/// w ##class(web.DHCICUOrder).SumICUInOutEveryHourOld("9","2021-5-12","09:00")
/// w ##class(web.DHCICUOrder).SumICUInOutEveryHourOld("9","2021-5-12","10:00")
ClassMethod SumICUInOutEveryHourOld(icuaId As %String, startDate As %String, startTime As %String) As %Library.String
{
	s retStr=""
	//q:(ctlocId="")&(icuaId="") ""
	s icuaIdList=icuaId

	q:icuaIdList="" retStr
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	s ctlocId=""
	i ctlocId="" d
		.s EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
		.q:EpisodeID=""
		.s wardId=$p($g(^PAADM(EpisodeID)),"^",70)
		.s ctlocId=$p(^PAWARD(+wardId),"^",5) //准备取科室定义的出入量
	q:ctlocId="" "" 
	s inIcucriIdList="",outIcucriIdList="",inAncvcIdList="",outAncvcIdList=""
	s icucioiId=""
	f  s icucioiId=$o(^DHCICUC("IOItem",icucioiId)) q:icucioiId=""  d
		.q:$p(^DHCICUC("IOItem",icucioiId),"^",8)'=ctlocId
		.q:"IO"'[$p(^DHCICUC("IOItem",icucioiId),"^",3)
		.q:$p(^DHCICUC("IOItem",icucioiId),"^",9)=""
		.i +$p(^DHCICUC("IOItem",icucioiId),"^",4)>0 d
			..i $p(^DHCICUC("IOItem",icucioiId),"^",3)="I" d
				...i inIcucriIdList'="" s inIcucriIdList=inIcucriIdList_"^"
				...s inIcucriIdList=inIcucriIdList_$p(^DHCICUC("IOItem",icucioiId),"^",4)
			..e  d
				...i outIcucriIdList'="" s outIcucriIdList=outIcucriIdList_"^"
				...s outIcucriIdList=outIcucriIdList_$p(^DHCICUC("IOItem",icucioiId),"^",4)
		.e  d
			..q:+$p(^DHCICUC("IOItem",icucioiId),"^",5)=0
			..i $p(^DHCICUC("IOItem",icucioiId),"^",3)="I" d
				...i inAncvcIdList'="" s inAncvcIdList=inAncvcIdList_"^"
				...s inAncvcIdList=inAncvcIdList_$p(^DHCICUC("IOItem",icucioiId),"^",5)
			..e  d
				...i outAncvcIdList'="" s outAncvcIdList=outAncvcIdList_"^"
				...s outAncvcIdList=outAncvcIdList_$p(^DHCICUC("IOItem",icucioiId),"^",5)

	s totalInput=0,totalOutput=0,LevelTotalPut=0
	
	s icuoId=""
	f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",startDate,icuaId,startTime,icuoId)) q:icuoId=""  d
		.q:'$d(^DHCICUOrder(icuoId))
		.s icucriId=$p(^DHCICUOrder(icuoId),"^",2)				//ICUO_ComOrd_Dr
		.s arcimId=$p(^DHCICUOrder(icuoId),"^",9)
		.q:(icucriId="")&(arcimId="")
		.s mainIcuoId=$p(^DHCICUOrder(icuoId),"^",36)
		.q:mainIcuoId'=""
		.q:"DCRUI"[$p(^DHCICUOrder(icuoId),"^",25)
		.s ancvcId=$p(^DHCICUOrder(icuoId),"^",16)
		.i (("^"_inIcucriIdList_"^")[("^"_icucriId_"^"))!(("^"_inAncvcIdList_"^")[("^"_ancvcId_"^")) d
			..s totalInput=totalInput+$p(^DHCICUOrder(icuoId),"^",11)
		.i (("^"_outIcucriIdList_"^")[("^"_icucriId_"^"))!(("^"_outAncvcIdList_"^")[("^"_ancvcId_"^")) d
			..s totalOutput=totalOutput+$p(^DHCICUOrder(icuoId),"^",11)
	if ((totalInput'="")&&(totalOutput'="")) s LevelTotalPut=totalInput-totalOutput
	if totalInput=0  s totalInput=""
	if totalOutput=0  s totalOutput=""
	if LevelTotalPut=0  s LevelTotalPut=""
	q totalInput_"^"_totalOutput_"^"_LevelTotalPut
}

/*
///startTime为整点
ClassMethod SumBewOrdEveryHour(icuaId As %String, startDate As %String, startTime As %String) As %String
{
	s startDT="",endDT=""
	s stDate="",stTime=""
	;i startDate'="" s stDate=##class(web.DHCClinicCom).ConvertToDate(startDate)
	;else  s stDate=##class(web.DHCClinicCom).ConvertToDate(+$h)
	s stDate=##class(web.DHCClinicCom).ConvertToDate(startDate)
	;i startTime'=""  s stTime=##class(web.DHCClinicCom).ConvertToTime(startTime)
	;else  s stTime=##class(web.DHCClinicCom).ConvertToTime($p($h,",",2))
	s stTime=##class(web.DHCClinicCom).ConvertToTime(startTime)
	s startDT=stDate_" "_stTime
	s endDT=stDate_" "_##class(web.DHCClinicCom).ConvertToTime(startTime+3599)
	
}
*/
/// 整点数据+整点后面非整点数据和所有和
/// Creator：      	ly
/// CreatDate：    	2021-07-20
/// Description： 	取科室每小时入量数据和  出量数据和 和出入量平衡
/// Table：        	DHC_ICU_Order
/// Input：        	入参：icuaId监护ID, dateTimeList用"^"分割的时间点，日期与时间用"|"分割,icucriIdList用"^"分割的常用医嘱串,needAncvcId:显示分类Id
/// Output：        
/// Return：       	返回：按时间点返回用"^"分割的数据，每个常用医嘱数据间用$c(3)分割。
/// w ##class(web.DHCICUOrder).SumICUInOutEveryHour("9","2021-5-12","09:00")
/// w ##class(web.DHCICUOrder).SumICUInOutEveryHour("9","2021-5-12","10:00")
/// w ##class(web.DHCICUOrder).SumICUInOutEveryHour("9","2021-7-20","17:00")
/// w ##class(web.DHCICUOrder).SumICUInOutEveryHour("4","2021-8-7","18:00")
/// w ##class(web.DHCICUOrder).SumICUInOutEveryHour("15","2021-8-13","01:00")
ClassMethod SumICUInOutEveryHour(icuaId As %String, startDate As %String, startTime As %String, ctlocRowId As %String = "") As %String
{
	s retStr=""
	//q:(ctlocId="")&(icuaId="") ""
	s icuaIdList=icuaId

	q:icuaIdList="" retStr
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	s ctlocId=""
	i ctlocId="" d
		.s EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
		.q:EpisodeID=""
		.s wardId=$p($g(^PAADM(EpisodeID)),"^",70)
		.s ctlocId=$p(^PAWARD(+wardId),"^",5) //准备取科室定义的出入量
	q:ctlocId="" "" 
	i ctlocRowId'="" s ctlocId=ctlocRowId
	s inIcucriIdList="",outIcucriIdList="",inAncvcIdList="",outAncvcIdList=""
	s icucioiId=""
	f  s icucioiId=$o(^DHCICUC("IOItem",icucioiId)) q:icucioiId=""  d
		.q:$p(^DHCICUC("IOItem",icucioiId),"^",8)'=ctlocId
		.q:$p(^DHCICUC("IOItem",icucioiId),"^",7)="N"
		.q:"IO"'[$p(^DHCICUC("IOItem",icucioiId),"^",3)
		.q:$p(^DHCICUC("IOItem",icucioiId),"^",9)=""
		.i +$p(^DHCICUC("IOItem",icucioiId),"^",4)>0 d
			..i $p(^DHCICUC("IOItem",icucioiId),"^",3)="I" d
				...i inIcucriIdList'="" s inIcucriIdList=inIcucriIdList_"^"
				...s inIcucriIdList=inIcucriIdList_$p(^DHCICUC("IOItem",icucioiId),"^",4)
			..e  d
				...i outIcucriIdList'="" s outIcucriIdList=outIcucriIdList_"^"
				...s outIcucriIdList=outIcucriIdList_$p(^DHCICUC("IOItem",icucioiId),"^",4)
		.e  d
			..q:+$p(^DHCICUC("IOItem",icucioiId),"^",5)=0
			..i $p(^DHCICUC("IOItem",icucioiId),"^",3)="I" d
				...i inAncvcIdList'="" s inAncvcIdList=inAncvcIdList_"^"
				...s inAncvcIdList=inAncvcIdList_$p(^DHCICUC("IOItem",icucioiId),"^",5)
			..e  d
				...i outAncvcIdList'="" s outAncvcIdList=outAncvcIdList_"^"
				...s outAncvcIdList=outAncvcIdList_$p(^DHCICUC("IOItem",icucioiId),"^",5)

	s totalInput=0,totalOutput=0,LevelTotalPut=0
	s icuoSttTime="" f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",startDate,icuaId,icuoSttTime)) q:(icuoSttTime="")  d
	.;q:((icuoSttTime>=startTime)&(icuoSttTime<(startTime+3600)))
	.q:((icuoSttTime<startTime)||(icuoSttTime>=(startTime+3600)))	///当前整点和该整点后，下一个整点前所有非整点数据的总和
	.
	.s icuoId="" f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",startDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
	..q:'$d(^DHCICUOrder(icuoId))
	..s icucriId=$p(^DHCICUOrder(icuoId),"^",2)				//ICUO_ComOrd_Dr
	..s arcimId=$p(^DHCICUOrder(icuoId),"^",9)
	..q:(icucriId="")&(arcimId="")
	..s mainIcuoId=$p(^DHCICUOrder(icuoId),"^",36)
	..q:mainIcuoId'=""
	..q:"DCRUI"[$p(^DHCICUOrder(icuoId),"^",25)
	..
	..
	..s pItemId=$p($g(^DHCICUOrder(icuoId)),"^",38)
	..q:((pItemId'="")&&($p($g(^DHCICUPara($p(pItemId,"||",1))),"^",1)'=icuaId))
	..
	..
	..s ancvcId=$p(^DHCICUOrder(icuoId),"^",16)
	..;s icucriId=$p(^DHCICUOrder(icuoId),"^",2)				//ICUO_ComOrd_Dr
	..i (("^"_inIcucriIdList_"^")[("^"_icucriId_"^"))!(("^"_inAncvcIdList_"^")[("^"_ancvcId_"^")) d
	...if ("8741^6741^5379^8745^5374"[icucriId)  d
	....s totalInput=totalInput+$p(^DHCICUOrder(icuoId),"^",28)
	...else  d
	....s totalInput=totalInput+$p(^DHCICUOrder(icuoId),"^",11)
	..i (("^"_outIcucriIdList_"^")[("^"_icucriId_"^"))!(("^"_outAncvcIdList_"^")[("^"_ancvcId_"^")) d
	...s totalOutput=totalOutput+$p(^DHCICUOrder(icuoId),"^",11)
	...
	if ((totalInput'="")&&(totalOutput'="")) s LevelTotalPut=totalInput-totalOutput
	;if totalInput'=0 s totalInput=$fn(totalInput,"",1)
	;if totalOutput'=0 s totalOutput=$fn(totalOutput,"",1)
	;if LevelTotalPut'=0 s LevelTotalPut=$fn(LevelTotalPut,"",1)
	q totalInput_"^"_totalOutput_"^"_LevelTotalPut
}

/// Creator：      	ly
/// CreatDate：    	2021-05-14
/// Description： 	取科室当天24小时入量数据 和  出量数据 和 出入量平衡
/// Table：        	DHC_ICU_Order
/// Input：        	入参：icuaId监护ID, startDate打印日期
/// Output：        
/// Return：       	返回：按时间点返回用"#"分割每个小时的数据
/// w ##class(web.DHCICUOrder).SumICUInOutHours24("9","2021-5-12")
/// w ##class(web.DHCICUOrder).SumICUInOutHours24("4","2021-08-07",210)
/// w ##class(web.DHCICUOrder).SumICUInOutHours24("15","2021-8-12",210)
/// w ##class(web.DHCICUOrder).SumICUInOutHours24("8","2021-11-15",210)
ClassMethod SumICUInOutHours24(icuaId As %String, stDate As %String, ctloc As %String = "") As %String
{
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(stDate)
	s startDT="",endDT=""
	s startDT=stDate_" "_"08:00",endDT=##class(web.DHCClinicCom).ConvertToDate(startDate+1)_" "_"07:59"
	
	s totalInOutLevel=""
	s preNum=7,NextNum=17,midNum=17
	if ((ctloc=210)||(ctloc=234)||(ctloc=278)||(ctloc=1220))
	{
		s preNum=6,NextNum=18,midNum=18
		s startDT=stDate_" "_"07:00",endDT=##class(web.DHCClinicCom).ConvertToDate(startDate+1)_" "_"06:59"
	}
	s SumNewOEStr=##class(ICU.BS.Order).GetOrderSumDataStr(icuaId,startDT,endDT)
	b ;1
	f i=1:1:24
    {	
    	i (i<midNum)
    	{
	    	s everyTotal=""
		    s time=(preNum+i)*3600
		    ;s everyTotal=..SumICUInOutEveryHourOld(icuaId,startDate,time)
		    s everyTotal=..SumICUInOutEveryHour(icuaId,startDate,time,ctloc)
		    if ($p($p(SumNewOEStr,"^",i),"#",1)'="0")
		    {
			    s $p(everyTotal,"^",1)=$p(everyTotal,"^",1)+$p($p(SumNewOEStr,"^",i),"#",1)
		    }
		    i totalInOutLevel="" s totalInOutLevel=everyTotal
		    else  s totalInOutLevel=totalInOutLevel_"#"_everyTotal
    	}
    	else
    	{
	    	;s startDate=startDate+1
	    	s everyTotal=""
		    s time=(i-NextNum)*3600
		    ;s everyTotal=..SumICUInOutEveryHourOld(icuaId,startDate,time)
		    s everyTotal=..SumICUInOutEveryHour(icuaId,startDate+1,time,ctloc)
		    if ($p($p(SumNewOEStr,"^",i),"#",1)'="0")
		    {
			    s $p(everyTotal,"^",1)=$p(everyTotal,"^",1)+$p($p(SumNewOEStr,"^",i),"#",1)
		    }
		    i totalInOutLevel="" s totalInOutLevel=everyTotal
		    else  s totalInOutLevel=totalInOutLevel_"#"_everyTotal
	    }
	    
    }
	q totalInOutLevel
}

/// 20210728 ly add
/// ICU使用+PICU
/// w ##class(web.DHCICUOrder).SumICUInOutHoursHZ24("18","2021-8-11",236)
/// w ##class(web.DHCICUOrder).SumICUInOutHoursHZ24("15","2021-8-12",210)
/// w ##class(web.DHCICUOrder).SumICUInOutHoursHZ24("105","2021-8-18",61)
/// w ##class(web.DHCICUOrder).SumICUInOutHoursHZ24("1203","2021-12-1",558)
/// 24小时时间点的汇总
ClassMethod SumICUInOutHoursHZ24(icuaId As %String, stDate As %String, ctloc As %String = "") As %Library.String
{
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(stDate)
	
	s startDT="",endDT=""
	s startDT=stDate_" "_"08:00",endDT=##class(web.DHCClinicCom).ConvertToDate(startDate+1)_" "_"07:59"
	
	s totalInOutLevel=""
	s preNum=8,NextNum=16,midNum=16
	s startTimeStr="08:00"
	if ((ctloc=210)||(ctloc=234)||(ctloc=278)||(ctloc=1220)){
		s startTimeStr="07:00"
		s preNum=7,NextNum=17,midNum=17
		
		s startDT=stDate_" "_"07:00",endDT=##class(web.DHCClinicCom).ConvertToDate(startDate+1)_" "_"06:59"
	}
	s SumNewOEStr=##class(ICU.BS.Order).GetOrderSumDataStr(icuaId,startDT,endDT)
	w SumNewOEStr,!
	f i=1:1:24
    {	
    	i (i<midNum)
    	{
	    	s everyTotal=""
		    s time=(preNum+i)*3600
		    ;s everyTotal=..SumICUInOutEveryHourOld(icuaId,startDate,time)
		    s everyTotal=..SumICUInOutICU(icuaId,startDate,startTimeStr,startDate,time,"",ctloc)
		    if ($p($p(SumNewOEStr,"^",i),"#",2)'="0")
		    {
			    s $p(everyTotal,"^",1)=$p(everyTotal,"^",1)+$p($p(SumNewOEStr,"^",i),"#",2)
			    s $p(everyTotal,"^",3)=$p(everyTotal,"^",3)+$p($p(SumNewOEStr,"^",i),"#",2)
		    }
		    i totalInOutLevel="" s totalInOutLevel=everyTotal
		    else  s totalInOutLevel=totalInOutLevel_"#"_everyTotal
    	}
    	else
    	{
	    	s startDate2=startDate+1
	    	s everyTotal=""
		    s time=(i-NextNum)*3600
		    ;s everyTotal=..SumICUInOutEveryHourOld(icuaId,startDate,time)
		    ;s everyTotal=..SumICUInOutICU(icuaId,startDate,startTimeStr,startDate2,time,"",ctloc)
		    s everyTotal=..SumICUInOutICU(icuaId,startDate,startTimeStr,startDate+1,time,"",ctloc)
		    if ($p($p(SumNewOEStr,"^",i),"#",2)'="0")
		    {
			    s $p(everyTotal,"^",1)=$p(everyTotal,"^",1)+$p($p(SumNewOEStr,"^",i),"#",2)
			    s $p(everyTotal,"^",3)=$p(everyTotal,"^",3)+$p($p(SumNewOEStr,"^",i),"#",2)
		    }
		    i totalInOutLevel="" s totalInOutLevel=everyTotal
		    else  s totalInOutLevel=totalInOutLevel_"#"_everyTotal
	    }
    }
	q totalInOutLevel
}

/// Creator：      	ypz	//新版未用 在用 20210728 ly
/// CreatDate：    	2010-08-12
/// Description： 	取科室总出入量
/// Table：        	DHC_ICU_Order
/// Input：        	入参：icuaId监护ID, dateTimeList用"^"分割的时间点，日期与时间用"|"分割,icucriIdList用"^"分割的常用医嘱串,needAncvcId:显示分类Id
/// Output：        
/// Return：       	返回：按时间点返回用"^"分割的数据，每个常用医嘱数据间用$c(3)分割。
/// w ##class(web.DHCICUOrder).SumICUInOutICU("9","65876","08:00","65876","19:59")
/// w ##class(web.DHCICUOrder).SumICUInOutICU("9","65876","08:00","65877","07:59")
/// w ##class(web.DHCICUOrder).SumICUInOutICU("2","2021-05-23","17:00","2021-05-23","17:59")
/// w ##class(web.DHCICUOrder).SumICUInOutICU("3","2021-06-08","8:00","2021-06-09","07:59")
ClassMethod SumICUInOutICU(icuaId As %String, startDate As %String, startTime As %String, endDate As %String, endTime As %String, needAncvcId As %String = "", ctlocRowId As %String = "") As %Library.String
{
	//w ##class(web.DHCICUOrder).SumICUInOut("146","61967","32458","61968","32458")
	s retStr=""
	//q:(ctlocId="")&(icuaId="") ""
	s icuaIdList=icuaId
	//i icuaIdList="" d
	//	.s icuaIdList=##class(web.DHCICUCom).FindIcuaIdList(icuaId, EpisodeID, ctlocId)
	q:icuaIdList="" retStr
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s endTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
	s ctlocId=""
	i ctlocId="" d
		.s EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
		.q:EpisodeID=""
		.s wardId=$p($g(^PAADM(EpisodeID)),"^",70)
		.s ctlocId=$p(^PAWARD(+wardId),"^",5) //准备取科室定义的出入量
	q:ctlocId="" "" 
	i ctlocRowId'="" s ctlocId=ctlocRowId
	s inIcucriIdList="",outIcucriIdList="",inAncvcIdList="",outAncvcIdList=""
	s icucioiId=""
	f  s icucioiId=$o(^DHCICUC("IOItem",icucioiId)) q:icucioiId=""  d
		.q:$p(^DHCICUC("IOItem",icucioiId),"^",8)'=ctlocId
		.q:$p(^DHCICUC("IOItem",icucioiId),"^",7)="N"
		.q:$p(^DHCICUC("IOItem",icucioiId),"^",9)=1553	///过滤掉水平衡关联项目
		.q:$p(^DHCICUC("IOItem",icucioiId),"^",9)=1552	///过滤掉平均尿量关联项目
		.q:"IO"'[$p(^DHCICUC("IOItem",icucioiId),"^",3)
		.i +$p(^DHCICUC("IOItem",icucioiId),"^",4)>0 d
			..i $p(^DHCICUC("IOItem",icucioiId),"^",3)="I" d
				...i inIcucriIdList'="" s inIcucriIdList=inIcucriIdList_"^"
				...s inIcucriIdList=inIcucriIdList_$p(^DHCICUC("IOItem",icucioiId),"^",4)
			..e  d
				...i outIcucriIdList'="" s outIcucriIdList=outIcucriIdList_"^"
				...s outIcucriIdList=outIcucriIdList_$p(^DHCICUC("IOItem",icucioiId),"^",4)
		.e  d
			..q:+$p(^DHCICUC("IOItem",icucioiId),"^",5)=0
			..i $p(^DHCICUC("IOItem",icucioiId),"^",3)="I" d
				...i inAncvcIdList'="" s inAncvcIdList=inAncvcIdList_"^"
				...s inAncvcIdList=inAncvcIdList_$p(^DHCICUC("IOItem",icucioiId),"^",5)
			..e  d
				...i outAncvcIdList'="" s outAncvcIdList=outAncvcIdList_"^"
				...s outAncvcIdList=outAncvcIdList_$p(^DHCICUC("IOItem",icucioiId),"^",5)
	
	//w "inAnc:"_inIcucriIdList,!
	//w "outAnc:"_outIcucriIdList,!
	//w "inAnc:"_inAncvcIdList,!
	//w "outAnc:"_outAncvcIdList,!
	s totalInput=0,totalOutput=0,LevelTotalPut=0
	f curDate=startDate:1:endDate d
	.f i=1:1:$l(icuaIdList) d
	..s icuaId=$p(icuaIdList,"^",i)
	..q:icuaId=""
	..s icuoSttTime="",isExit=0
	..f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:(icuoSttTime="")!(isExit)  d
	...q:(curDate=startDate)&(icuoSttTime<startTime)
	...i (curDate=endDate)&(icuoSttTime'<endTime) s isExit=1 q
	...s sttDateTime=curDate+(icuoSttTime/100000)
	...s icuoId=""
	...f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
	....q:'$d(^DHCICUOrder(icuoId))
	....//w icuoId,!
	....s icucriId=$p(^DHCICUOrder(icuoId),"^",2)				//ICUO_ComOrd_Dr
	....s arcimId=$p(^DHCICUOrder(icuoId),"^",9)
	....q:(icucriId="")&(arcimId="")
	....s mainIcuoId=$p(^DHCICUOrder(icuoId),"^",36)
	....q:mainIcuoId'=""
	....q:"DCRUI"[$p(^DHCICUOrder(icuoId),"^",25)
	....
	....s pItemId=$p($g(^DHCICUOrder(icuoId)),"^",38)
	....q:((pItemId'="")&&($p($g(^DHCICUPara($p(pItemId,"||",1))),"^",1)'=icuaId))
	....
	....
	....s ancvcId=$p(^DHCICUOrder(icuoId),"^",16)
	....q:(needAncvcId'="")&(needAncvcId'=ancvcId)
	....
	....i (("^"_inIcucriIdList_"^")[("^"_icucriId_"^"))!(("^"_inAncvcIdList_"^")[("^"_ancvcId_"^")) d
	.....;s totalInput=totalInput+$p(^DHCICUOrder(icuoId),"^",11)
	.....if ("8741^6741^5379^8745^5374"[icucriId)  d
	......s totalInput=totalInput+$p(^DHCICUOrder(icuoId),"^",28)
	.....else  d
	......s totalInput=totalInput+$p(^DHCICUOrder(icuoId),"^",11)
	....i (("^"_outIcucriIdList_"^")[("^"_icucriId_"^"))!(("^"_outAncvcIdList_"^")[("^"_ancvcId_"^")) d
	.....s totalOutput=totalOutput+$p(^DHCICUOrder(icuoId),"^",11)
	.....
	if ((totalInput'="")&&(totalOutput'="")) s LevelTotalPut=totalInput-totalOutput
	/*
	if totalInput=0  s totalInput=""
	if totalOutput=0  s totalOutput=""
	if LevelTotalPut=0  s LevelTotalPut=""
	*/
	;if totalInput'=0 s totalInput=$fn(totalInput,"",1)
	;if totalOutput'=0 s totalOutput=$fn(totalOutput,"",1)
	;if LevelTotalPut'=0 s LevelTotalPut=$fn(LevelTotalPut,"",1)

	q totalInput_"^"_totalOutput_"^"_LevelTotalPut
}

/// w ##class(web.DHCICUOrder).SumICUInOutHoursPJNL24("4","2021-7-22")
/// 24小时时间点平均尿量
ClassMethod SumICUInOutHoursPJNL24(icuaId As %String, startDate As %String, ctloc As %String = "") As %Library.String
{
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s totalInOutLevel=""
	s preNum=8,NextNum=16,midNum=16
	s weight=1
	s weight=##class(web.DHCICUBaseInfoOne).GetCurrentWeight(icuaId,startDate)
	f i=1:1:24
    {	
    	i (i<midNum)
    	{
	    	s everyTotal=""
		    s time=(preNum+i)*3600
		    ;s everyTotal=..SumICUInOutEveryHourOld(icuaId,startDate,time)
		    s everyTotal=..SumICUOutLiang(icuaId,startDate,"08:00",startDate,time,7378)/i/weight
		    s everyTotal=$fn(everyTotal,"",1)
		    i totalInOutLevel="" s totalInOutLevel=everyTotal
		    else  s totalInOutLevel=totalInOutLevel_"#"_everyTotal
		    ;w i_"--"_weight_"--"_everyTotal
		    b ;1
    	}
    	else
    	{
	    	s startDate2=startDate+1
	    	s everyTotal=""
		    s time=(i-NextNum)*3600
		    ;s everyTotal=..SumICUInOutEveryHourOld(icuaId,startDate,time)
		    ;s everyTotal=..SumICUOutLiang(icuaId,startDate,"08:00",startDate2,time,7378)/i/weight
		    s everyTotal=..SumICUOutLiang(icuaId,startDate,"08:00",startDate+1,time,7378)/i/weight
		    s everyTotal=$fn(everyTotal,"",1)
		    i totalInOutLevel="" s totalInOutLevel=everyTotal
		    else  s totalInOutLevel=totalInOutLevel_"#"_everyTotal
	    }
    }
	q totalInOutLevel
}

/// w ##class(web.DHCICUOrder).SumICUInOutHoursSPH24("4","2021-7-22")
/// 24小时时间点水平衡 NICU
ClassMethod SumICUInOutHoursSPH24(icuaId As %String, startDate As %String, ctloc As %String = "") As %Library.String
{
	s weight=1
	s weight=##class(web.DHCICUBaseInfoOne).GetCurrentWeight(icuaId,startDate)
	
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s totalInOutLevel=""
	s preNum=8,NextNum=16,midNum=16
	if ((ctloc=210)||(ctloc=234)||(ctloc=278)||(ctloc=1220))
	{
		s preNum=7,NextNum=17,midNum=17
	}
	f i=1:1:24
    {	
    	i (i<midNum)
    	{
	    	s everyTotal=""
		    s time=(preNum+i)*3600
		    ;s everyTotal=..SumICUInOutEveryHourOld(icuaId,startDate,time)
		    s everyTotal=..SumICUInOut(icuaId,startDate,"08:00",startDate,time)
		    s everyTotal=$fn($p(everyTotal,"^",3)/weight,"",1)
		    i totalInOutLevel="" s totalInOutLevel=everyTotal
		    else  s totalInOutLevel=totalInOutLevel_"#"_everyTotal
    	}
    	else
    	{
	    	s startDate2=startDate+1
	    	s everyTotal=""
		    s time=(i-NextNum)*3600
		    ;s everyTotal=..SumICUInOutEveryHourOld(icuaId,startDate,time)
		    ;s everyTotal=..SumICUInOut(icuaId,startDate,"08:00",startDate2,time)
		    s everyTotal=..SumICUInOut(icuaId,startDate,"08:00",startDate+1,time)
		    s everyTotal=$fn($p(everyTotal,"^",3)/weight,"",1)
		    i totalInOutLevel="" s totalInOutLevel=everyTotal
		    else  s totalInOutLevel=totalInOutLevel_"#"_everyTotal
	    }
	    
    }
	q totalInOutLevel
}

/// Creator：      	ypz		//新版未用
/// CreatDate：    	2011-12-14
/// Description： 	取体温单数据
/// Table：        	DHC_ICU_Order
/// Input：        	入参：ctlocId科室ID，icuaId监护ID, 开始日期,开始时间,结束日期,结束时间, 是否后台发送(Y/N)
/// Output：        EpisodeID,icuaId,第三方patientId,第三方住院次数visitId,病人科室deptDesc,病人病区wardDesc,日期,时间,
/// 					inputQty入量,outputQty出量,stoolTimes大便次数,urineVolume尿量,sysBloodPressure收缩压,diaBloodPressure舒张压,
/// 					temperature体温,pulse脉博,respiration呼吸,hr心率,ctcpDesc护士,ifSentData是否发送过)
/// Return：       	返回查询数据条数，否则出错信息。
ClassMethod GetTemperatureChart(ctlocId, icuaId, startDate, startTime, endDate, endTime, ifSend = "Y") As %Library.String
{
	//w  ##class(web.DHCICUOrder).GetTemperatureChart("",8,62222,0,62224,0)
	s retStr="0"
	q:(ctlocId="")&(icuaId="") "数据为空!"
	s icuaIdList=icuaId
	i icuaIdList="" d
		.s icuaIdList=##class(web.DHCICUCom).FindIcuaIdList(icuaId, "", ctlocId)
	q:icuaIdList="" retStr
	s timePointStr=$g(^DHCCLSet("ICU","TemperatureTime"))
	i timePointStr="" s timePointStr="10800^25200|Y^39600^54000^68400^82800" //3、7、11、15、19、23
	s adjTime=$g(^DHCCLSet("ICU","TemperatureTimeOffset")) //"1800" 
	i adjTime="" s adjTime=1800
	//s newBornCtlocIdList=$g(^DHCCLSet("ICU","NewBornCtlocId")) //"40"
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s endTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
	s dayTime=0
	f i=1:1:$l(timePointStr,"^") d
		.i $p($p(timePointStr,"^",i),"|",2)="Y" s dayTime=$p($p(timePointStr,"^",i),"|",1)
	//w dayTime,!
	
	//q:(ctlocId="")&(dateTimeVal>latestDateTimeVal) "单个病人更新须在科室更新后!"
	s totalInput=0,totalOutput=0
	s $ZT="ERROR"
	s seqNum=0
	f curDate=startDate:1:endDate d
		.q:curDate=""
		.f timeInd=1:1:$l(timePointStr,"^") d
			..s curTime=+$p(timePointStr,"^",timeInd)
			..q:(curDate=startDate)&(curTime<startTime)
			..q:(curDate=endDate)&(curTime>startTime)
			..f i=1:1:$l(icuaIdList,"^") d
				...s icuaId=$p(icuaIdList,"^",i)					//*新生儿流水号
				...//w "icuaIdList("_i_"):"_icuaId,!
				...q:icuaId=""
				...//s temperFlow=icuaId_"TMain"_measureDate		//体温单主表流水号
				...s EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
				...s OARowID=$o(^DHCENSOA("0","Paadm",EpisodeID,""))
				...s patientId=$p($g(^DHCENSOA(+OARowID)),"^",4)	//OA_PatientId	
				...s visitId=$p($g(^DHCENSOA(+OARowID)),"^",5)	//OA_VisitId
				...//s visitId="000"_visitId
				...//s visitId=$E(visitId,$l(visitId)-3,$l(visitId))
				...//s inPatientFlow=patientId_"_"_visitId			//*住院流水号??待确认
				...//s temperFlow=inPatientFlow_"TMain"_measureDate		//体温单主表流水号
				...s deptId=+$p($g(^DHCICUArrange(+icuaId)),"^",2)
				...s deptDesc=$p($g(^CTLOC(deptId)),"^",2)		//*病人所在科室名
				...s wardId=+$p($g(^DHCICUArrange(+icuaId)),"^",4)
				...s wardDesc=$p($g(^PAWARD(+wardId)),"^",2)		//*病人所在病区名
				...//s recordModifyTime=$tr($zd(curDate,3),"-","")_$tr($zt(curTime),":","")	//*记录最后修改时间14位
				...s inputQty="",outputQty="",stoolTimes="",urineVolume="",sysBloodPressure="",diaBloodPressure=""
				...i dayTime=curTime d 			//一天取一次的数据
					....s sumInOutStr=##class(web.DHCICUOrder).SumICUInOut(icuaId, curDate-1, curTime, curDate, curTime)
					....s inputQty=$p(sumInOutStr,"^",1)			//*入量
					....s outputQty=$p(sumInOutStr,"^",2)			//*总出量
					....s sumICUOrderStr=##class(web.DHCICUOrder).SumICUOrder(icuaId, curDate-1, curTime, curDate, curTime, "5020^5021")
					....s stoolTimes=$p(sumICUOrderStr,"^",1)		//*大便次数
					....s urineVolume=$p(sumICUOrderStr,"^",2)		//*尿量
					....s icuOrderStr=##class(web.DHCICUOrder).GetICUOrdByTimeList(icuaId, curDate_"|"_curTime, "5010^5005", adjTime)
					....//s bloodPressure=""
					....i $p($p(icuOrderStr,"^",1),"!",5)'="" d
						.....//s bloodPressure=$p($p(icuOrderStr,"^",1),"!",5)_"/"_$p($p(icuOrderStr,"^",2),"!",5)	//*血压(使用"/"分割两个数值)
						.....s sysBloodPressure=$p($p(icuOrderStr,"^",1),"!",5)
						.....s diaBloodPressure=$p($p(icuOrderStr,"^",2),"!",5)
					....//s recordOwnName=ctcpDesc					//记录所有者姓名
					....//写普通主表接口程序
					....//s dataPara=temperFlow_"#"_inPatientFlow_"#"_patientId_"#"_icuaId_"#"_recordModifyTime_"#"_inputQty_"#"_outputQty_"#"_stoolTimes_"#"_urineVolume_"#"_bloodPressure_"#"_""_"#"_deptDesc_"#"_wardDesc_"#"_"2"
					....//S ^SendTemperatureData("Main",measureDate,tTime,temperFlow)=dataPara
					....//s retStr=..InsertTemperatureMain(icuaId,measureDate,dataPara)
					....//S ^SendTemperatureData("Main",measureDate,tTime,temperFlow,"Result")=retStr
				...//e  d    //插入主表
					...//.s dataPara=temperFlow_"#"_inPatientFlow_"#"_patientId_"#"_icuaId_"#"_recordModifyTime_"#"_""_"#"_""_"#"_""_"#"_""_"#"_""_"#"_""_"#"_deptDesc_"#"_wardDesc_"#"_"1"
					...//.S ^SendTemperatureData("Main",measureDate,tTime,temperFlow)=dataPara
					...//.s retStr=..InsertTemperatureMain(icuaId,measureDate,dataPara)
					...//.S ^SendTemperatureData("Main",measureDate,tTime,temperFlow,"Result")=retStr
				...//s tFraeFlow=inPatientFlow_"TFrae"_measureDate_tTime	//体温单子表流水号（住院流水号＋"TFrae"＋8位测量日期＋4位测量时间点）
				...s icuOrderStr=##class(web.DHCICUOrder).GetICUOrdByTimeList(icuaId, curDate_"|"_curTime, "5001^5062^5008^5006", adjTime)
				...s temperature=$p($p(icuOrderStr,"^",1),"!",5)	//*体温
				...s pulse=$p($p(icuOrderStr,"^",2),"!",5)			//*脉搏
				...s respiration=$p($p(icuOrderStr,"^",3),"!",5)	//*呼吸
				...s hr=$p($p(icuOrderStr,"^",4),"!",5)				//*心率
				...q:(temperature="")&(pulse="")&(respiration="")&(hr="")
				...//w icuaId_":"_curDate_","_curTime,!
				...s userId=$p($p(icuOrderStr,"^",1),"!",1)
				...s ctcpId=$p($g(^SSU("SSUSR",+userId)),"^",14)
				...s ctcpDesc=$p($g(^CTPCP(+ctcpId,1)),"^",2)		
				...//写普通子表接口程序
				...//s dataPara=tFraeFlow_"#"_temperFlow_"#"_inPatientFlow_"#"_patientId_"#"_icuaId_"#"_recordModifyTime_"#"_""_"#"_temperature_"#"_pulse_"#"_breath_"#"_hr_"#"_deptDesc_"#"_wardDesc_"#"_flag
				...//s ^SendTemperatureData("Sub",measureDate,tTime,tFraeFlow)=dataPara
				...//s retStr=..InsertTemperatureSub(icuaId,measureDate,tTime,dataPara)
				...//s ^SendTemperatureData("Sub",measureDate,tTime,tFraeFlow,"Result")=retStr
				...s ifSentData="N"
				...i $d(^DHCICUSendTemperture(icuaId,curDate,curTime))>0 s ifSentData="Y"
				...//w EpisodeID,","_icuaId,","_patientId,","_visitId,","_+deptDesc,","_+wardDesc,","_$zd(curDate,3),","_$zt(curTime,2,","_inputQty,","_outputQty,","_stoolTimes,","_urineVolume,","_sysBloodPressure,","_diaBloodPressure,","_temperature,","_pulse,","_respiration,","_hr,","_ctcpDesc,","_ifSentData,!
				...i ifSend'="Y" d
					....s data=$lb(EpisodeID,icuaId,patientId,visitId,deptDesc,wardDesc,$zd(curDate,3),$zt(curTime,2),inputQty,outputQty,stoolTimes,urineVolume,sysBloodPressure,diaBloodPressure,temperature,pulse,respiration,hr,ctcpDesc,ifSentData)
					....s seqNum=seqNum+1
					....s ^TMPICU("TemperatureChart",$j,seqNum)=data
	q seqNum
ERROR	; 
	q $ZE	           //得到系统返回的错误消息
 	//Quit "-1"
}

/// Creator：      	ypz	//新版未用
/// CreatDate：    	2011-12-14
/// Description： 	查询体温单数据
/// Table：        	DHC_ICU_Order
/// Input：        	入参：ctlocId科室ID，icuaId监护ID, 开始日期,开始时间,结束日期,结束时间
/// Output：        参GetTemperatureChart
/// Return：       	返回0正常，否则出错信息。
Query FindTemperatureChart(ctlocId, icuaId, startDate, startTime, endDate, endTime) As %Query(ROWSPEC = "EpisodeID:%String,icuaId:%String,patientId:%String,visitId:%String,deptDesc:%String,wardDesc:%String,curDate:%String,curTime:%String,inputQty:%String,outputQty:%String,stoolTimes:%String,urineVolume:%String,sysBloodPressure:%String,diaBloodPressure:%String,temperature:%String,pulse:%String,respiration:%String,hr:%String,ctcpDesc:%String,ifSentData:%String") [ SqlProc ]
{
}

ClassMethod FindTemperatureChartExecute(ByRef qHandle As %Binary, ctlocId, icuaId, startDate, startTime, endDate, endTime) As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	k ^TMPICU("TemperatureChart",$j)
 	s count=..GetTemperatureChart(ctlocId, icuaId, startDate, startTime, endDate, endTime, "N")
 	i count=+count d
 		.f seqNum=1:1:count d
 			..s Data=$g(^TMPICU("TemperatureChart",$j,seqNum))
 			..q:Data=""
 			..k ^TMPICU("TemperatureChart",$j,seqNum)
 			..d OutPut
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutPut
	//s Data=$lb(desc,rowId)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindTemperatureChartFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTemperatureChartExecute ]
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

ClassMethod FindTemperatureChartClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTemperatureChartExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

/// Creator：      	ypz	//新版未用
/// CreatDate：    	2011-12-12
/// Description： 	保存发送数据记录（按天汇总暂与时间点一起保存）
/// Table：        	
/// Input：        	入参:icuaId监护ID,参数dateTimePara,用户userId
/// 					参数dateTimePara:分为两级，第一级以"^"分为多条时间点，第二级以"|"分割成日期、时间
/// Output：        
/// Return：       	返回0正常，否则出错信息。
ClassMethod SetSentTemperatureChart(icuaId, dateTimePara, userId = "") As %String
{
	q:(icuaId="")&(dateTimePara="") -1
	s updateDate=$h,updateTime=$p($h,",",2)
	f i=1:1:$l(dateTimePara,"^") d
		.s dateTimeStr=$p(dateTimePara,"^",i)
		.s date=##class(web.DHCClinicCom).ConvertToDateH($p(dateTimeStr,"|",1),"")
		.q:date=""
		.s time=##class(web.DHCClinicCom).ConvertToDateH($p(dateTimeStr,"|",2),"")
		.//s isDay=##class(web.DHCClinicCom).ConvertToDateH($p(dateTimeStr,"|",3))
		.//q:(isDay'="Y")&(time="")
		.q:(time="")
		.//i (isDay="Y") s ^DHCICUSendTemperture(icuaId,date)=updateDate_"^"_updateTime_"^"_userId
		.e  s ^DHCICUSendTemperture(icuaId,date,time)=updateDate_"^"_updateTime_"^"_userId
	q 0
}

/// 新版未用
ClassMethod SendTemperatureDataSchedule() As %Library.String
{
	//w ##class(web.DHCICUOrder).SendTemperatureDataSchedule()
	s sendTemperatureResult=0
	s date=$p($h,",",1)
	s time=$p($h,",",2)
	s SendTemperatureCtlocIdList=$g(^DHCCLSet("ICU","SendTemperatureCtlocIdList"))
	//w SendTemperatureCtlocIdList,!
	f i=1:1:$l(SendTemperatureCtlocIdList,"^") d 
	.s ctlocId=$p(SendTemperatureCtlocIdList,"^",i)
	.q:ctlocId=""
    .s sendTemperatureResult=##class(web.DHCICUOrder).SendTemperatureData(ctlocId, "", date, time)
    q sendTemperatureResult
}

/// 新版未用
ClassMethod SendTemperatureDataInBatch() As %Library.String
{
	//w ##class(web.DHCICUOrder).SendTemperatureDataInBatch()
	s timePointStr=$g(^DHCCLSet("ICU","TemperatureTime")) //"10800||Y^25200|Y|Y^39600||Y^54000||Y^68400||Y^82800||Y"
	q:timePointStr="" "未定义取数据时间点!"
	s adjTime=$g(^DHCCLSet("ICU","TemperatureTimeOffset")) //"1800" 
	i adjTime="" s adjTime=1800
	
	s currentDate=$p($h,",",1)
	s currentTime=$p($h,",",2)
	
	s sendTemperatureResult=0
	s sendTimePointStr=""
	
	s loopSign=0
	s spanPosition=0
	s sendTimePointStrOffset=1
	f i=1:1:$l(timePointStr,"^") d
		.s time=$p($p(timePointStr,"^",i),"|",1)
		.s time=(+time)+(+adjTime+1)
		.s ^SendTemperatureData("SendTemperatureDataInBatch",time)=i_":"_time_":"_currentTime
		.i +time>+currentTime & loopSign=0 d
		..s spanPosition=i+1
		..s ^SendTemperatureData("SendTemperatureDataInBatch","spanPosition")=spanPosition
		..s loopSign=1
		
	f i=spanPosition:1:$l(timePointStr,"^") d
		.s time=$p($p(timePointStr,"^",i),"|",1)
		.s time=(+time)+(+adjTime+1)
		.s $p(sendTimePointStr,"^",sendTimePointStrOffset)=(+currentDate)-1_"|"_time
		.s sendTimePointStrOffset=sendTimePointStrOffset+1
	f i=1:1:spanPosition-1 d
		.s time=$p($p(timePointStr,"^",i),"|",1)
		.s time=(+time)+(+adjTime+1)
		.s $p(sendTimePointStr,"^",sendTimePointStrOffset)=currentDate_"|"_time	
		.s sendTimePointStrOffset=sendTimePointStrOffset+1
	
	s ^SendTemperatureData("SendTemperatureDataInBatch")=sendTimePointStr
	f i=1:1:$l(sendTimePointStr,"^") d
		.s date=$p($p(sendTimePointStr,"^",i),"|",1)
		.s time=$p($p(sendTimePointStr,"^",i),"|",2)
		.s ^SendTemperatureData("SendTemperatureDataInBatch",i)=date_""_time
		.s SendTemperatureCtlocIdList=$g(^DHCCLSet("ICU","SendTemperatureCtlocIdList"))
		.f j=1:1:$l(SendTemperatureCtlocIdList,"^") d 
			..s ctlocId=$p(SendTemperatureCtlocIdList,"^",j)
			..q:ctlocId=""
    		..s sendTemperatureResult=##class(web.DHCICUOrder).SendTemperatureData(ctlocId, "", date, time)
    q sendTemperatureResult
}

/// 将数据插入普通体温单主表	//新版未用
ClassMethod InsertTemperatureMain(icuaId As %String, measureDate As %String, dataPara As %String) As %String
{
	//w ##class(web.DHCICURMD.ReceiveMonitorDataAdpter).InsertTemperChildMain(icuaId,measureDate,dataPara)
	s ^tempSjqDebug("Main",measureDate,icuaId)=dataPara
	q:(icuaId="") "重症监护安排ID不能为空!"
	q:dataPara="" "无数据!"
	
	Set $ZT="ERROR"
	TSTART
	s temperFlow=$p(dataPara,"#",1)
	s inPatientFlow=$p(dataPara,"#",2)
	s patientId=$p(dataPara,"#",3)
	//s inChildFlow=$p(dataPara,"#",4)
	s recordModifyTime=$p(dataPara,"#",5)
	s inputQty=$p(dataPara,"#",6)
	s outputQty=$p(dataPara,"#",7)
	s stoolTimes=$p(dataPara,"#",8)
	s urineVolume=$p(dataPara,"#",9)
	s bloodPressure=$p(dataPara,"#",10)
	s recordOwnName=$p(dataPara,"#",11)
	s deptDesc=$p(dataPara,"#",12)
	s wardDesc=$p(dataPara,"#",13)
	s flag=$p(dataPara,"#",14)
	s tableFlag=""
	.//temp//&SQL(select flag into :tableFlag from DHC_ICU_HTTemperatureMainTest where TEMPER_FLOW=:temperFlow)
	//q:(flag=1 & tableFlag'="")
	i flag=2 & tableFlag="" s flag=1
	
	b //ccq
	i flag="1" d
	.//增加测量日期字段，保留主键字段，去掉了新生儿的IN_CHILD_FLOW字段(传空串即可)
	.//temp//&SQL(Insert into DHC_ICU_HTTemperatureMainTest(MEASURE_DATE,TEMPER_FLOW,IN_PATIENT_FLOW,MR_ID,RECORDMODIFY_TIME,INPUT_QTT,OUTPUT_QTT,STOOL_TIMES,STALE_QTT,BLOOD_PRESSURE,RECORDOWN_NAME,DEPT_NAME,AREA_NAME,flag) values(:measureDate,:temperFlow,:inPatientFlow,:patientId,:recordModifyTime,:inputQty,:outputQty,:stoolTimes,:urineVolume,:bloodPressure,:recordOwnName,:deptDesc,:wardDesc,:flag))
	e  d
	.//去掉主键字段，去掉了新生儿的IN_CHILD_FLOW字段(传空串即可)
	.//temp//&SQL(update DHC_ICU_HTTemperatureMainTest (IN_PATIENT_FLOW,MR_ID,RECORDMODIFY_TIME,INPUT_QTT,OUTPUT_QTT,STOOL_TIMES,STALE_QTT,BLOOD_PRESSURE,RECORDOWN_NAME,DEPT_NAME,AREA_NAME,flag) values(:inPatientFlow,:patientId,:recordModifyTime,:inputQty,:outputQty,:stoolTimes,:urineVolume,:bloodPressure,:recordOwnName,:deptDesc,:wardDesc,:flag) where  TEMPER_FLOW=:temperFlow) 
	i SQLCODE TROLLBACK
	Q:SQLCODE 1
	TCOMMIT
	q SQLCODE
ERROR
	Set ErrorMsg=$ZE
	TROLLBACK
	Quit "<ERROR>"_VALUE
	q SQLCODE
}

/// 将数据插入普通体温单子表	//新版未用
ClassMethod InsertTemperatureSub(icuaId As %String, measureDate As %String, tTime As %String, dataPara As %String) As %String
{
	//w ##class(web.DHCICURMD.ReceiveMonitorDataAdpter).InsertTemperatureFrae(icuaId,measureDate,tTime，dataPara)
	s ^tempSjqDebug("Frae",measureDate,tTime,icuaId)=dataPara
	
	q:(icuaId="") "重症监护安排ID不能为空!"
	q:dataPara="" "无数据!"

	Set $ZT="ERROR"
	TSTART
	s tFraeFlow=$p(dataPara,"#",1)
	s temperFlow=$p(dataPara,"#",2)
	s inPatientFlow=$p(dataPara,"#",3)
	s patientId=$p(dataPara,"#",4)
	//s inChildFlow=$p(dataPara,"#",5)
	s recordModifyTime=$p(dataPara,"#",6)
	s recordOwnName=$p(dataPara,"#",7)
	s temperature=$p(dataPara,"#",8)
	s pulse=$p(dataPara,"#",9)
	s breath=$p(dataPara,"#",10)
	s hr=$p(dataPara,"#",11)
	s deptDesc=$p(dataPara,"#",12)
	s wardDesc=$p(dataPara,"#",13)
	s flag=$p(dataPara,"#",14)
	s isCall="Y"
	s tableFlag=""
	.//temp//&SQL(select flag into :tableFlag from DHC_ICU_HTTemperatureFraeTest where T_FRAE_FLOW=:tFraeFlow)
	//q:(flag=1 & tableFlag'="")
	i flag=2 & tableFlag="" s flag=1
	
	i flag="1" d
	.//增加测量日期、时间字段，保留主键字段,，去掉了新生儿的IN_CHILD_FLOW字段(传空串即可)
	.//temp//&SQL(Insert into DHC_ICU_HTTemperatureFraeTest(MEASURE_DATE,T_TIME,T_FRAE_FLOW,TEMPER_FLOW,IN_PATIENT_FLOW,MR_ID,RECORDMODIFY_TIME,RECORDOWN_NAME,TEMPERATURE,PULSE,BREATH,HR,DEPT_NAME,AREA_NAME,flag,is_call) values(:measureDate,:tTime,:tFraeFlow,:temperFlow,:inPatientFlow,:patientId,:recordModifyTime,:recordOwnName,:temperature,:pulse,:breath,:hr,:deptDesc,:wardDesc,:flag,:isCall))
	e  d
	.//去掉主键字段，日期，时间字段
	.//temp//&SQL(update DHC_ICU_HTTemperatureFraeTest (TEMPER_FLOW,IN_PATIENT_FLOW,MR_ID,RECORDMODIFY_TIME,RECORDOWN_NAME,TEMPERATURE,PULSE,BREATH,HR,DEPT_NAME,AREA_NAME,flag,is_call) values(:temperFlow,:inPatientFlow,:patientId,:recordModifyTime,:recordOwnName,:temperature,:pulse,:breath,:hr,:deptDesc,:wardDesc,:flag,:isCall) where  TEMPER_FLOW=:temperFlow)
	i SQLCODE TROLLBACK
	Q:SQLCODE 1
	TCOMMIT
	q SQLCODE
ERROR
	Set ErrorMsg=$ZE
	TROLLBACK
	Quit "<ERROR>"_VALUE
	q SQLCODE
}

/// Creator：      	ypz
/// CreatDate：    	2010-03-30
/// Description： 	保存病人打印记录
/// Table：        	DHC_ICU_PrintRecord
/// Input：        	入参：icuaId监护ID, date重症记录日期, time重症记录时间, dateTimeSeq序号(暂未用), page打印页, pageRow行数, userId用户
/// Output：        
/// Return：       	返回：0成功，其它出错信息。
/// 
ClassMethod SavePrintRecord(icuaId As %String, date As %String, time As %String, dateTimeSeq As %String, page As %String, pageRow As %String, userId As %String) As %Library.String
{
	q:icuaId="" "监护号不能为空!"
	q:'$d(^DHCICUArrange(icuaId)) "监护号没有数据!"
	q:page="" "页码不能为空!"
	q:(date="")!(time="") "日期和时间不能为空!"
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	k PLIST
	s PLIST(3)=date
	s PLIST(4)=time
	s PLIST(5)=dateTimeSeq
	s PLIST(6)=page
	s PLIST(7)=pageRow
	s PLIST(8)=userId
	s PLIST(9)=+$h
	s PLIST(10)=$p($h,",",2)
	
	s icuprSub=$o(^DHCICUArrange(0,"PrintPage",icuaId,page,""))
	i icuprSub'="" d
		.s icuprId=icuaId_"||"_icuprSub
		.&sql(update DHC_ICU_PrintRecord VALUES :PLIST() WHERE ICUPR_RowId=:icuprId)
	e  d
		.s PLIST(0)=icuaId
		.&sql(insert into DHC_ICU_PrintRecord VALUES :PLIST())
	s retStr=0
	i SQLCODE s retStr="保存数据错! code="_SQLCODE
	q retStr
}

/// Creator：      	ypz
/// CreatDate：    	2010-03-30
/// Description： 	取病人打印记录
/// Table：        	DHC_ICU_PrintRecord
/// Input：        	入参：icuaId监护ID, date重症记录日期, time重症记录时间, page打印页。
/// Output：        
/// Return：       	返回：以"^"分割的多条数据，以$c(3)分割数据中的各部分：date重症记录日期, time重症记录时间, dateTimeSeq序号, page打印页, pageRow行数, userId用户,打印日期,打印时间
/// 				其中，页码和日期均为空时，传回最后一页。页码和日期均不空时，传回页码数据。
ClassMethod GetPrintRecord(icuaId As %String, date As %String, time As %String, page As %String, isNextPage As %String = "Y") As %Library.String
{
	q:icuaId="" "监护号不能为空!"
	q:'$d(^DHCICUArrange(icuaId)) "监护号没有数据!"
	//q:page="" "页码不能为空!"
	i date'="" s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i time'="" s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	i time'="",time\60*60=time s time=time+30
	
	s retStr="",icuprSub=""
	i page'="" s icuprSub=$o(^DHCICUArrange(0,"PrintPage",icuaId,page,""))
	i icuprSub="",date="" d
		.s date=$o(^DHCICUArrange(0,"PrintDate",icuaId,""),-1)
		.q:date=""
		.s icuprSub=$o(^DHCICUArrange(0,"PrintDate",icuaId,date,""),-1)
	i icuprSub'="" d
		.s icuprStr=$g(^DHCICUArrange(icuaId,"PR",icuprSub))
		.q:icuprStr=""
		.s $p(icuprStr,"^",1)=$zd($p(icuprStr,"^",1),3)
		.s $p(icuprStr,"^",2)=$zt($p(icuprStr,"^",2))
		.s $p(icuprStr,"^",7)=$zd($p(icuprStr,"^",7),3)
		.s $p(icuprStr,"^",8)=$zt($p(icuprStr,"^",8))
		.s retStr=$tr(icuprStr,"^",$c(3))
	q:retStr'="" retStr
	q:date="" retStr
	i isNextPage'="Y" d
		.s icuprSub=$o(^DHCICUArrange(0,"PrintDate",icuaId,(date+1),"")) //后一天的第一条打印数据
		.s isFind=0
		.f  s icuprSub=$o(^DHCICUArrange(icuaId,"PR",icuprSub),-1) q:(+icuprSub=0)!(isFind)  d
			..s icuprStr=$g(^DHCICUArrange(icuaId,"PR",icuprSub))
			..q:icuprStr=""
			..q:$p(icuprStr,"^",1)>date
			..q:($p(icuprStr,"^",1)=date)&(time'="")&(time<$p(icuprStr,"^",2))
			..s $p(icuprStr,"^",1)=$zd($p(icuprStr,"^",1),3)
			..s $p(icuprStr,"^",2)=$zt($p(icuprStr,"^",2))
			..s $p(icuprStr,"^",7)=$zd($p(icuprStr,"^",7),3)
			..s $p(icuprStr,"^",8)=$zt($p(icuprStr,"^",8))
			..s retStr=$tr(icuprStr,"^",$c(3))
			..s isFind=1
	e  d
		.s preDate=$o(^DHCICUArrange(0,"PrintDate",icuaId,date),-1)
		.q:preDate=""
		.s icuprSub=$o(^DHCICUArrange(0,"PrintDate",icuaId,preDate,""))
		.s isFind=0
		.f  s icuprSub=$o(^DHCICUArrange(icuaId,"PR",icuprSub)) q:(+icuprSub=0)!(isFind)  d
			..s icuprStr=$g(^DHCICUArrange(icuaId,"PR",icuprSub))
			..q:icuprStr=""
			..q:$p(icuprStr,"^",1)<date
			..q:($p(icuprStr,"^",1)=date)&(time'="")&(time>$p(icuprStr,"^",2))
			..s $p(icuprStr,"^",1)=$zd($p(icuprStr,"^",1),3)
			..s $p(icuprStr,"^",2)=$zt($p(icuprStr,"^",2))
			..s $p(icuprStr,"^",7)=$zd($p(icuprStr,"^",7),3)
			..s $p(icuprStr,"^",8)=$zt($p(icuprStr,"^",8))
			..//i retStr'="" s retStr=retStr_"^"
			..//s retStr=retStr_$tr(icuprStr,"^",$c(3))
			..s retStr=$tr(icuprStr,"^",$c(3))
			..s isFind=1
	q retStr
}

/// Creator：      	ypz
/// CreatDate：    	2010-09-21
/// Description： 	根据医嘱串返回是否显示
/// Table：        	DHC_ICU_Order
/// Input：        	入参：以"^"分割的多条医嘱ID数据。
/// Output：        
/// Return：       	返回：以"^"分割的多条数据，记录该医嘱需要显示次数，大于0的显示。
ClassMethod GetICUOrderFactor(oeoreIdList As %String, date As %String = "") As %Library.String
{
	q:oeoreIdList="" 0
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	s retStr=0
	f i=1:1:$l(oeoreIdList,"^") d
		.s oeoreId=$p(oeoreIdList,"^",i)
		.s $p(retStr,"^",i)=1	//默认显示
		.s icuaId=0,count=0,phcfrFactor=0
		.f  s icuaId=$o(^DHCICUOrder(0,"OEORE",oeoreId,icuaId)) q:icuaId=""  d
			..s icuoId=0
			..f  s icuoId=$o(^DHCICUOrder(0,"OEORE",oeoreId,icuaId,icuoId)) q:icuoId=""  d
				...q:'$d(^DHCICUOrder(icuoId))
				...q:$p(retStr,"^",i)<1
				...s icuoStartDate=$p(^DHCICUOrder(icuoId),"^",5)
				...//w icuoId_","_date_","_icuoStartDate,!
				...q:icuoStartDate'=date	//长期医嘱会有多天
				...//w "stat:"_$p(^DHCICUOrder(icuoId),"^",25),!
				...q:"DCU"[$p(^DHCICUOrder(icuoId),"^",25) //D删除，R废弃
				...i count=0 d
					....s icuoOrdItemNote=$p(^DHCICUOrder(icuoId),"^",35)	//主医嘱|从医嘱|优先级Id|频率Id|医嘱备注
    				....s phcfrId=$p(icuoOrdItemNote,"|",4)
    				....s phcfrFactor=$p($g(^PHCFR(+phcfrId)),"^",2)
    				....i phcfrFactor<1 s phcfrFactor=1
    			...s count=count+1
    			...s $p(retStr,"^",i)=phcfrFactor-count
				...//w " last:"_phcfrFactor_"/"_$p(retStr,"^",i),!
	q retStr
}

/// Creator：      	ypz	//新版未用,?未用
/// CreatDate：    	2011-08-05
/// Description： 	根据医嘱串返回是否显示
/// Table：        	DHC_ICU_Shift,DHC_ICU_ShiftItem
/// Input：        	入参：监护表Id,科室Id,开始日期，结束日期
/// Output：        以"^"分割的多条数据，存在^TMPICU("OrderRet",$j)中。"^"分为两部分：交班表信息;交班明细表信息。
/// 					交班表信息以$c(3)分割:交班日期，交班时间，交班类型(D日交班，S小交班，O其它)，交班人Id，接班人Id
/// 					交班明细表信息以$c(3)分割:常用医嘱Id，数量，说明。
/// Return：       	返回数据条数
ClassMethod GetICUShiftItem(icuaId As %String, ctlocId As %String, startDate As %String = "", endDate As %String = "") As %Library.String
{
	k ^TMPICU("OrderRet",$j)
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	i endDate>$h s endDate=$h+1
	s icuaIdList=##class(web.DHCICUCom).FindIcuaIdList(icuaId, "", ctlocId)
	//w icuaIdList,!
	s num=0
	f i=1:1:$l(icuaIdList,"^") d
		.s icuaId=$p(icuaIdList,"^",i)
		.q:icuaId=""
		.s EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
		.q:'$d(^PAADM(EpisodeID))
		.s curStartDate=startDate
		.i curStartDate<$p(^PAADM(EpisodeID),"^",6) s curStartDate=$p(^PAADM(EpisodeID),"^",6)-1
		.f date=curStartDate:1:endDate d
			..s icusSub=0
			..f  s icusSub=$o(^DHCICUArrange(0,"ShiftDate",date,icuaId,icusSub)) q:(icusSub="")  d
				...s icusStr=$tr(^DHCICUArrange(icuaId,"Shift",icusSub),"^",$c(3))
				...s $p(icusStr,$c(3),1)=##class(web.DHCClinicCom).ConvertToDate($p(icusStr,$c(3),1))
				...s $p(icusStr,$c(3),2)=##class(web.DHCClinicCom).ConvertToTime($p(icusStr,$c(3),2))
				...s icusiSub=0
				...f  s icusiSub=$o(^DHCICUArrange(icuaId,"Shift",icusSub,"I",icusiSub)) q:(icusiSub="")  d
					....s icusiStr=$tr(^DHCICUArrange(icuaId,"Shift",icusSub,"I",icusiSub),"^",$c(3))
					....s num=num+1
					....s ^TMPICU("OrderRet",$j,num)=icusStr_"^"_icusiStr
					....//w ^TMPICU("OrderRet",$j,num),!
	q num
}

/// Creator：      	ypz	//新版未用
/// CreatDate：    	2011-04-6
/// Description： 	查找ICU数据，看是否已分余液
/// Table：        	DHC_ICU_Order
/// Input：        	icuoIdStr："^"
/// Output：       
/// Return：       	对应为"Y"的已分余液
ClassMethod CheckRemainICUOrder(icuoIdStr As %String = "") As %String
{
	s $p(retStr,"^",$l(icuoIdStr,"^"))=""
	f i=1:1:$l(icuoIdStr,"^") d
		.s icuoId=$p(icuoIdStr,"^",i)
		.q:icuoId=""
		.q:'$d(^DHCICUOrder(icuoId))
		.s icuaId=+^DHCICUOrder(icuoId)
		.s icuoStartDate=$p(^DHCICUOrder(icuoId),"^",5)
		.q:icuaId=0
		.s isQuit=0,tmpIcuoId=icuoId
		.f  s tmpIcuoId=$o(^DHCICUOrder(0,"Arr",icuaId,tmpIcuoId)) q:(tmpIcuoId="")!(isQuit)  d
			..s icuoOriginateFromICUODr=$p(^DHCICUOrder(tmpIcuoId),"^",14)
			..i $p(^DHCICUOrder(tmpIcuoId),"^",5)-1>$p(^DHCICUOrder(icuoId),"^",5) s isQuit=1
			..q:icuoOriginateFromICUODr'=icuoId
			..q:("NE"'[$p(^DHCICUOrder(tmpIcuoId),"^",25))
			..s $p(retStr,"^",i)="Y"
			..s isQuit=1
	q retStr
}

/// Creator：      	ypz	//新版未用
/// CreatDate：    	2011-11-14
/// Description： 	查找ICU数据中已使用的HIS医嘱数据
/// Table：        	DHC_ICU_Order
/// Input：        	重症icuaId, 开始日期startDate, 结束日期endDate, 就诊号EpisodeID
/// Output：       
/// Return：       	以"^"分割的ICUO_OEORE_Dr串
ClassMethod GetRecordedOeOrdExec(icuaId, startDate, endDate, EpisodeID = "")
{
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s icuaIdList=##class(web.DHCICUCom).FindIcuaIdList(icuaId, EpisodeID,"")
	q:icuaIdList="" ""
	
	s retStr=""
	s fDate=startDate
	f curDate=fDate:1:endDate d
	    .f i=1:1:$l(icuaIdList,"^") d
	        ..s icuaId=$p(icuaIdList,"^",i)
	        ..s icuoSttTime=""
	        ..f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
	            ...s icuoId=""
	            ...f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
	                ....q:'$d(^DHCICUOrder(icuoId))
	                ....s icuoStartDate=$p(^DHCICUOrder(icuoId),"^",5)
	                ....s icuoEndDate=$p(^DHCICUOrder(icuoId),"^",7)
	                ....q:"ICD"[$p(^DHCICUOrder(icuoId),"^",25)
	                ....q:($p(^DHCICUOrder(icuoId),"^",29)="I")
	                ....
	                ....s arcimId=$p(^DHCICUOrder(icuoId),"^",9)	//ICUO_ARCIM_Dr
	                ....q:(arcimId="")
	                ....s oeoreId=$p(^DHCICUOrder(icuoId),"^",3)
	                ....q:oeoreId=""
	                ....i retStr'="" s retStr=retStr_"^"
	                ....s retStr=retStr_oeoreId		//ICUO_OEORE_Dr
	q retStr
}

/// 以下部分为PDA相关程序
/// 
/// 
/// 以下程序ICU 取录入的数据项 供PDA使用
Query GetItemResult(para As %String = "") As %Query(ROWSPEC = "icucriOrArcimDesc:%String,anoValue:%String,ctuomDesc:%String,ctuomId:%String,icucriType:%String,icucriOrArcimId:%String,ancvcId:%String,icuoId:%String,optionFlag:%String,oeoriId:%String") [ SqlProc ]
{
}

ClassMethod GetItemResultExecute(ByRef qHandle As %Binary, para As %String = "") As %Status
{
	//d ##CLASS(%ResultSet).RunQuery("web.DHCICUOrder","GetItemResult","1024515^1^^^^^^^1")
	//d ##CLASS(%ResultSet).RunQuery("web.DHCICUOrder","GetItemResult","1^69^^^^^^^1")
	s repid=$i(^CacheTemp)
 	s ind=1
	s icuaId=$P(para,"^",1)
	s userId=$P(para,"^",2)
	s ctlocId=$P(para,"^",3)
	s startDate=$P(para,"^",4)
	s startTime=$P(para,"^",5)
	s endDate=$P(para,"^",6)
	s endTime=$P(para,"^",7)
	s needIcucriType=$P(para,"^",8) //D,V,L
	s insertFlag=$P(para,"^",9) //新增或修改
	/////???????
	/////(EpisodeID, userId, ctlocId, startDate, startTime, endDate, endTime) As %String
	//s (icucriOrArcimDesc,anoValue,ctuomDesc,ctuomId,icucriType,icucriOrArcimId,ancvcId,icuoId,optionFlag)=1
 	//d OutItemResult
 	//s (icucriOrArcimDesc,anoValue,ctuomDesc,ctuomId,icucriType,icucriOrArcimId,ancvcId,icuoId,optionFlag)=0
 	s retStr=$$GetItemResult(icuaId, userId, ctlocId, startDate, startTime, endDate, endTime, needIcucriType, insertFlag)
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutItemResult

	s Data=$lb(icucriOrArcimDesc,anoValue,ctuomDesc,ctuomId,icucriType,icucriOrArcimId,ancvcId,icuoId,optionFlag,oeoriId)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
GetItemResult(icuaId, userId, ctlocId, startDate, startTime, endDate, endTime, needIcucriType, insertFlag)
	//w ##class(web.DHCICUOrder).GetItemResult(1024515,1)
	q:(icuaId="")!(userId="") ""
	s EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
	
	//取显示参数
	s i=0,tmpStr=""
	i (+icuaId=0) s icupId="Default"
	e  s icupId=##class(web.DHCICUCom).GetIcupId(icuaId,ctlocId)
	q:icupId="" 0
	s itemList=""
	i insertFlag=1 d
	    .s icupiSub=0
	    .f  s icupiSub=$o(^DHCICUPara(icupId,"I",icupiSub)) q:icupiSub=""  d
	        ..s icupiStr=^DHCICUPara(icupId,"I",icupiSub)
	        ..//w icupiStr,!
	        ..s ancvscId=$p(icupiStr,"^",2)
	        ..s ancvcId=$p(icupiStr,"^",11)
	        ..s icucriId=$p(icupiStr,"^",4)
	        ..s arcimId=$p(icupiStr,"^",3)
	        ..s oeoriId=""
	        ..s mainOeoriId=""
	        ..s subOeoriId=""
	        ..s ctuomId=$p(icupiStr,"^",12)
	        ..s icucriType=$p(icupiStr,"^",1)
	        ..s icucriOptions=""
	        ..i icucriId'="" d
	            ...s icucriType=$p($g(^DHCICUC("RecordItem",icucriId)),"^",3)
	            ...s ctuomId=$p($g(^DHCICUC("RecordItem",icucriId)),"^",6)
	            ...s arcimId=$p($g(^DHCICUC("RecordItem",icucriId)),"^",4)
	            ...s ancvcId=$p($g(^DHCICUC("RecordItem",icucriId)),"^",5)
	            ...s icucriOptions=$p($g(^DHCICUC("RecordItem",icucriId)),"^",11)
	            ...i ancvcId'="",ancvscId="" s ancvscId=$p($g(^DHCICUC("ViewCat",ancvcId)),"^",10)
	        ..q:ancvscId=""
	        ..q:ancvcId=""
	        ..q:(icucriId="")&(arcimId="")
	        ..q:(needIcucriType'="")&(needIcucriType'[icucriType)
	        ..
	        ..s ancvscStr="",ancvcDesc="",icucriDesc="",arcimDesc="",ctuomDesc=""
	        ..i ancvscId'="" s ancvscStr=ancvscId_$c(4)_$p($g(^DHCICUC("VSCat",ancvscId)),"^",2)
	        ..i ancvcId'="" s ancvcDesc=$p($g(^DHCICUC("ViewCat",ancvcId)),"^",2)
	        ..i icucriId'="" s icucriDesc=$p($g(^DHCICUC("RecordItem",icucriId)),"^",2)
	        ..i arcimId'="" s arcimDesc=$p($g(^ARCIM(+arcimId,1,1)),"^",2)
	        ..i ctuomId'="" s ctuomDesc=$p($g(^CT("UOM",ctuomId)),"^",2)
	        ..
	        ..//icucriOrArcimDesc,anoValue,ctuomDesc,ctuomId,icucriType,icucriOrArcimId,ancvcId,icuoId,optionFlag
	        ..s anoValue="",icuoId="",oeoriId=""
	        ..s optionFlag=0
	        ..i icucriOptions'="" s optionFlag=1
	        ..s icucriOrArcimDesc=icucriDesc,icucriOrArcimId=icucriId
	        ..i icucriOrArcimDesc="" s icucriOrArcimDesc=arcimDesc,icucriOrArcimId=arcimId
	        ..
	        ..i itemList'="" s itemList=itemList_"^"
	        ..s itemList=itemList_icucriId_","_arcimId
	        ..d OutItemResult
	        ..////s tmpData(ancvscId,ancvcId,icucriId_","_arcimId)=ancvscStr_$c(3)_ancvcDesc_$c(3)_icucriDesc_$c(3)_arcimDesc_$c(3)_oeoriId_$c(3)_ctuomId_$c(3)_icucriType_$c(3)_icucriOptions

	i endTime="" s endTime=86400
	e  s endTime=$zth(endTime,3)
	i startTime="" s startTime=0
	e  s startTime=$zth(startTime,3)
	i endDate="" s endDate=+$h
	e  s endDate=$zdh(endDate,3)
	i startDate="" d
	    .i EpisodeID'="" s startDate=$p($g(^PAADM(EpisodeID)),"^",6)
	    .e  s startDate=+$h
	e  d //有开始日期时，结束日期、时间同开始日期、时间
	    .s startDate=$zdh(startDate,3)
	    .s endDate=startDate
	    .s endTime=startTime 
	
	//按日期取新增项目
	f curDate=startDate:1:endDate d
	    .s icuoSttTime=""
	    .f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
	        ..s icuoId=""
	        ..f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
	            ...q:'$d(^DHCICUOrder(icuoId))
	            ...s icuoUpdateDate=$p(^DHCICUOrder(icuoId),"^",21)
	            ...s icuoUpdateTime=$p(^DHCICUOrder(icuoId),"^",22)
	            ...s icuoStartTime=$p(^DHCICUOrder(icuoId),"^",6)
	            ...s icuoEndDate=$p(^DHCICUOrder(icuoId),"^",7)
	            ...s icuoEndTime=$p(^DHCICUOrder(icuoId),"^",8)
	            ...
	            ...q:(curDate=startDate)&(icuoStartTime<startTime)
	            ...q:(curDate=endDate)&(icuoEndTime>endTime)
	            ...
	            ...//q:query.GetDataByName("ICUO_EditFlag")="D"
	            ...s icucriId=$p(^DHCICUOrder(icuoId),"^",2)				//ICUO_ComOrd_Dr")
	            ...s arcimId=$p(^DHCICUOrder(icuoId),"^",9)				//ICUO_ARCIM_Dr")
	            ...
	            ...s ancvscId=""
	            ...s ancvcId=$p(^DHCICUOrder(icuoId),"^",16)
	            ...
	            ...s oeoreId=$p(^DHCICUOrder(icuoId),"^",3)
	            ...s oeordId=+oeoreId
	            ...s oeoriSub=$p(oeoreId,"||",2)
	            ...s mainOeoriId=""	//ICUO_MainOeori_Dr
	            ...//i oeoriSub'="" s mainOeoriId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)
	            ...s ctuomId=$p(^DHCICUOrder(icuoId),"^",12)
	            ...s icucriType=$p(^DHCICUOrder(icuoId),"^",30)
	            ...s icucriOptions=""
	            ...i icucriId'="" d
	                ....s icucriType=$p($g(^DHCICUC("RecordItem",icucriId)),"^",3)
	                ....s ctuomId=$p($g(^DHCICUC("RecordItem",icucriId)),"^",6)
	                ....s arcimId=$p($g(^DHCICUC("RecordItem",icucriId)),"^",4)
	                ....s ancvcId=$p($g(^DHCICUC("RecordItem",icucriId)),"^",5)
	                ....s icucriOptions=$p($g(^DHCICUC("RecordItem",icucriId)),"^",11)
	                ....i ancvcId'="",ancvscId="" s ancvscId=$p($g(^DHCICUC("ViewCat",ancvcId)),"^",10)
	            ...q:(ancvscId="")&(icucriId'="")  //??
	            ...q:(ancvcId="")&(icucriId'="")  //??
	            ...q:(icucriId="")&(arcimId="")
	            ...q:(needIcucriType'="")&(needIcucriType'[icucriType)
	            ...s ancvscStr="",ancvcDesc="",icucriDesc="",arcimDesc="",ctuomDesc=""
	            ...i ancvscId'="" s ancvscStr=ancvscId_$c(4)_$p($g(^DHCICUC("VSCat",ancvscId)),"^",2)
	            ...i ancvcId'="" s ancvcDesc=$p($g(^DHCICUC("ViewCat",ancvcId)),"^",2)
	            ...i icucriId'="" s icucriDesc=$p($g(^DHCICUC("RecordItem",icucriId)),"^",2)
	            ...i arcimId'="" s arcimDesc=$p($g(^ARCIM(+arcimId,1,1)),"^",2)
		        ...i ctuomId'="" s ctuomDesc=$p($g(^CT("UOM",ctuomId)),"^",2)
	    	    ...
	            ...//s anoValue="",icuoId=""
	            ...s optionFlag=0
	            ...i icucriOptions'="" s optionFlag=1
	            ...s anoValue=$p(^DHCICUOrder(icuoId),"^",10)
	            ...i (icucriType="D")!(icucriType="V"&optionFlag'=1) s anoValue=$p(^DHCICUOrder(icuoId),"^",11)
	            ...s icucriOrArcimDesc=icucriDesc,icucriOrArcimId=icucriId
	            ...i icucriOrArcimDesc="" s icucriOrArcimDesc=arcimDesc,icucriOrArcimId=arcimId
	            ...
	            ...//w itemList_"/"_icucriId_","_arcimId
	            ...q:("^"_itemList_"^")[("^"_icucriId_","_arcimId_"^")
	            ...//w !
	            ...
	            ...i itemList'="" s itemList=itemList_"^"
	            ...s itemList=itemList_icucriId_","_arcimId
	            ...d OutItemResult
	            ...////s tmpData(ancvscId,ancvcId,icucriId_","_arcimId)=ancvscStr_$c(3)_ancvcDesc_$c(3)_icucriDesc_$c(3)_arcimDesc_$c(3)_oeoriId_$c(3)_ctuomId_$c(3)_icucriType_$c(3)_icucriOptions
	
	q:insertFlag'=1 0
	
	//取HIS医嘱
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:oeordId="" ""
	//s curDate=+$h,endDate=$h-1,i=0 //核实查找天数
	s oeoriSub=0,oeoriIdStr=""
	f sttDate=startDate:1:endDate d
	    .s oeoriSub=0
	    .f  s oeoriSub=$o(^OEORDi(0,"StDt",sttDate,oeordId,oeoriSub)) q:(oeoriSub="")  d
	        ..q:'$d(^OEORD(oeordId,"I",oeoriSub))
		    ..s oeoriId=oeordId_"||"_oeoriSub
		    ..s ordStatCode=##Class(web.DHCClinicCom).GetOrdStatCode(oeoriId)
	        ..s icuoId=$o(^DHCICUOrder(0,"OEORE",oeoriId,icuaId,""))
	        ..q:icuoId'=""
    	    ..
    	    ..s orcatId=##Class(web.DHCClinicCom).GetOrdCatId(oeoriId)
    	    ..q:orcatId=""
    	    ..s ocgrpId=$p($g(^OEC("ORCAT",orcatId)),"^",15) //OEC_OrderCategoryGroup
    	    ..s ocgrpCode=$p($g(^OEC("OCGRP",+ocgrpId)),"^",1)
   	        ..s arcicOrderType=##Class(web.DHCClinicCom).GetOrdSubCatType(oeoriId)
	        ..q:("RL"'[arcicOrderType)&(ocgrpCode'="EXAM")
	        ..
	        ..q:(ordStatCode'="V")&(arcicOrderType="R") //药品
	        ..q:(ordStatCode'="E")&(arcicOrderType="L") //检验
	        ..q:(ordStatCode'="E")&(ocgrpCode="EXAM")   //检查
	        ..
	    	..s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7) //医嘱用法指针
	    	..s phcinCode="",phcinDesc=""
	    	..i phcinId'="" s phcinCode=$p($g(^PHCIN(phcinId)),"^",1),phcinDesc=$p($g(^PHCIN(phcinId)),"^",2)
	    	..s phcinCode=$$ALPHAUP^SSUTIL4(phcinCode)
	    	..//q:(arcicOrderType="R")&(phcinCode'["PUMP")&(phcinCode'["IV")
	    	..
	        ..s icucriType=arcicOrderType
	        ..i arcicOrderType="R" s icucriType="D"
	        ..i ocgrpCode="EXAM" s icucriType="L"
	        ..q:(needIcucriType'="")&(needIcucriType'[icucriType)
	        ..s arcimId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",2)
			..s lIcucriId=0,icucriId=0
			..f  s lIcucriId=$o(^DHCICUC("RecordItem",lIcucriId)) q:(lIcucriId="")!(icucriId>0)  d
			    ...i arcimId=$p($G(^DHCICUC("RecordItem",lIcucriId)),"^",4) s icucriId=lIcucriId
			..
	        ..q:("^"_itemList_"^")[("^"_icucriId_","_arcimId_"^")
			..
			..s ancvcId="" //ypz无初始值//$o(^DHCICUC("ViewCat",0,"oEvent",""))
	        ..s ancvscId="",icucriOptions=""
	    	..i icucriId'="" d
	        	...//s icucriType=$p($g(^DHCICUC("RecordItem",icucriId)),"^",3)
	        	...//s ctuomId=$p($g(^DHCICUC("RecordItem",icucriId)),"^",6)
	        	...//s arcimId=$p($g(^DHCICUC("RecordItem",icucriId)),"^",4)
	        	...s ancvcId=$p($g(^DHCICUC("RecordItem",icucriId)),"^",5)
	        	...s icucriOptions=$p($g(^DHCICUC("RecordItem",icucriId)),"^",11)
	        	...i ancvcId'="",ancvscId="" s ancvscId=$p($g(^DHCICUC("ViewCat",ancvcId)),"^",10)
			..i icucriId>0 s ancvcId=$p(^DHCICUC("RecordItem",icucriId),"^",5)
		    ..s doseQty=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",1)
		    ..s ctuomId=""
		    ..i doseQty'="" s ctuomId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",3)
		    ..
		    ..//s oeoriAddUserId=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)
	        ..
	        ..s mainOeoriId=""	//ICUO_MainOeori_Dr
	        ..i oeoriSub'="" s mainOeoriId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)
	        ..s tmpStr=tmpStr_mainOeoriId_"^"
	        ..s subOeoriId=""
	        ..
	    	..//q:ancvscId=""
	    	..//q:ancvcId=""
	    	..q:(icucriId="")&(arcimId="")
	    	..i +icucriId=0 d
	    	    ...i phcinCode["PUMP" s ancvcId=$o(^DHCICUC("ViewCat",0,"ICUmicropumpIntakes",""))
	    	    ...i phcinCode["IV" s ancvcId=$o(^DHCICUC("ViewCat",0,"ICUveinIntakes",""))
	    	..
	    	..s ancvscStr="",ancvcDesc="",icucriDesc="",arcimDesc="",ctuomDesc=""
	    	..i ancvscId'="" s ancvscStr=ancvscId_$c(4)_$p($g(^DHCICUC("VSCat",ancvscId)),"^",2)
	    	..i ancvcId'="" s ancvcDesc=$p($g(^DHCICUC("ViewCat",ancvcId)),"^",2)
	    	..i icucriId'="" s icucriDesc=$p($g(^DHCICUC("RecordItem",icucriId)),"^",2)
	    	..i arcimId'="" s arcimDesc=$p($g(^ARCIM(+arcimId,1,1)),"^",2)
		    ..i ctuomId'="" s ctuomDesc=$p($g(^CT("UOM",ctuomId)),"^",2)
	    	..
	        ..s anoValue="",icuoId=""
	        ..s optionFlag=0
	        ..i icucriOptions'="" s optionFlag=1
	        ..s icucriOrArcimDesc=icucriDesc,icucriOrArcimId=icucriId
	        ..i icucriOrArcimDesc="" s icucriOrArcimDesc=arcimDesc,icucriOrArcimId=arcimId
	        ..
	        ..i itemList'="" s itemList=itemList_"^"
	        ..s itemList=itemList_icucriId_","_arcimId
	        ..d OutItemResult
	        ..////s tmpData(+ancvscId,+ancvcId,icucriId_","_arcimId)=ancvscStr_$c(3)_ancvcDesc_$c(3)_icucriDesc_$c(3)_arcimDesc_$c(3)_oeoriId_$c(3)_ctuomId_$c(3)_icucriType_$c(3)_icucriOptions
	q 0
	/*s i=0,retStr=""
	s ancvscId="" f  s ancvscId=$o(tmpData(ancvscId))  q:ancvscId=""  d
	 .s ancvcId="" f  s ancvcId=$o(tmpData(ancvscId,ancvcId))  q:ancvcId=""  d
	     ..s icucriArcimId="" f  s icucriArcimId=$o(tmpData(ancvscId,ancvcId,icucriArcimId))  q:icucriArcimId=""  d
	         ...s i=i+1
	         ...i retStr="" s retStr=retStr_"^"
	         ...s retStr=retStr_tmpData(ancvscId,ancvcId,icucriArcimId)
	         ...w tmpData(ancvscId,ancvcId,icucriArcimId),!
    w i,!
    q retStr*/
}

ClassMethod GetItemResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItemResultExecute ]
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

ClassMethod GetItemResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItemResultExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

/// 取单位
Query GetUOM() As %SQLQuery(CONTAINID = 1, ROWSPEC = "CTUOM_RowId:%Integer,CTUOM_Desc:%String") [ SqlProc ]
{
    select CTUOM_RowId,CTUOM_Desc from CT_UOM
}

// 取类型

Query GetType() As %Query(ROWSPEC = "type_Desc:%String,type_Rowid:%String") [ SqlProc ]
{
}

ClassMethod GetTypeExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	s desc="用药",rowId="D" d OutType
 	s desc="生命体征",rowId="V" d OutType
 	//s desc="事件",rowId="E" d OutType
 	s desc="治疗",rowId="T" d OutType
 	s desc="检验",rowId="L" d OutType
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutType
	s Data=$lb(desc,rowId)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTypeExecute ]
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

ClassMethod GetTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTypeExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

// 取一天有数据的时间点 

// !!新加了入参icuaId 100324

Query GetTimePoint(nowDate As %String = "", icuaId As %String = "") As %Query(ROWSPEC = "timePoint:%String,seqNo:%String") [ SqlProc ]
{
}

ClassMethod GetTimePointExecute(ByRef qHandle As %Binary, startDate As %String = "", icuaId As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	i startDate="" s startDate=+$h
 	e  s startDate=$zdh(startDate,3)
 	s curIcuaId=0,seqNo=0
 	f  s curIcuaId=$o(^DHCICUOrder(0,"SttDateTime",startDate,curIcuaId)) q:curIcuaId=""  d
 	    .q:(icuaId'="")&(icuaId'=curIcuaId)
 	    .s anoTime=""
 	    .f  s anoTime=$o(^DHCICUOrder(0,"SttDateTime",startDate,curIcuaId,anoTime)) q:anoTime=""  d
 	        ..s seqNo=seqNo+1
 	        ..s timePoint=$zt(anoTime)
 	        ..d OutTimePoint
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutTimePoint
	s Data=$lb(timePoint,seqNo)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetTimePointFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTimePointExecute ]
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

ClassMethod GetTimePointClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTimePointExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

// 取项目的选项

/// GetItemOption
Query GetItemOption(icucriId As %String = "") As %Query(ROWSPEC = "option:%String,optionSeqNo:%String") [ SqlProc ]
{
}

ClassMethod GetItemOptionExecute(ByRef qHandle As %Binary, icucriId As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	s option=""
 	s icucriOptions=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",11)
 	s num=$l(icucriOptions,";")
 	i icucriOptions="" s num=0
 	f optionSeqNo=1:1:num d
 	    .s option=$p(icucriOptions,";",optionSeqNo)
 	    .d OutItemOption
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutItemOption
	s Data=$lb(option,optionSeqNo)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetItemOptionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItemOptionExecute ]
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

ClassMethod GetItemOptionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItemOptionExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

/// Creator：      	ypz
/// CreatDate：    	2009-03-10
/// Description： 	更新、保存数据到ICU记录表中，供PDA用
/// Table：        	DHC_ICU_Order
/// Input：        	para：分两级，第一级"^",第二级$c(3)。第一个"^"内容是公共数据部分。第二个"^"以后是每条记录的其他数据。
/// 			   	icuaId(监护安排Id)_$c(3)_userId_$c(3)_sttDate_$c(3)_sttTime_$c(3)_icucriType(监护类型)"^"itemId_$c(3)_itemValue_$c(3)_ctuomId_$c(3)_icuoId_$c(3)_viewCatId_$c(3)_oeoriId"^"....
/// Output：       
/// Return：       	0-正常，其他-异常返回信息
ClassMethod SaveICUItemValue(para As %String = "") As %String
{
	
	//s para=8_$c(3)_1_$c(3)_"2009-3-11"_$c(3)_"10:0"_$c(3)_"D"_$c(3)_"1^315"_$c(3)_"灵敏"_$c(3)_""_$c(3)_3427_$c(3)_24_$c(3)_"1111||1^315"_$c(3)_""_$c(3)_615_$c(3)_3426_$c(3)_24_$c(3)_"2222||1"
	//s para=8_$c(3)_1_$c(3)_"2009-3-11"_$c(3)_"10:0"_$c(3)_"D"_$c(3)_"1^422"_$c(3)_22_$c(3)_""_$c(3)_3422_$c(3)_24_$c(3)_"1111||1^421"_$c(3)_""_$c(3)_615_$c(3)_3423_$c(3)_24_$c(3)_"2222||1"
	k PLIST
	s retStr=0
	s patInfo=$P(para,"^")
	s PLIST(2)=$P(patInfo,$c(3),1) //icuaId=$P(patInfo,"^",1) //ypz change
	s PLIST(5)=$P(patInfo,$c(3),2) //userId=$P(patInfo,"^",2)
	s sttDate=$P(patInfo,$c(3),3)
	i $l(sttDate,"-")>2 s sttDate=$zdh(sttDate,3)
	s PLIST(6)=sttDate
	s sttTime=$P(patInfo,$c(3),4)
	i $l(sttTime,":")>1 s sttTime=$zth(sttTime)
	s PLIST(7)=sttTime
	s PLIST(8)=sttDate
	s PLIST(9)=sttTime
	s icucriType=$P(patInfo,$c(3),5)
	s PLIST(31)=icucriType
	//s itemInfo=$P(para,"!",2)
	///itemId + "|" + itemValue + "|" + uomId + "|" + ICUORowId + "|" + viewCatId+"^"
	s itemNum=$L(para,"^")
	f i=2:1:itemNum d
	.q:retStr'=0
	.s itemStr=$P(para,"^",i)
	.q:itemStr=""
	.s icucriOrArcimId=$P(itemStr,$c(3),1)
	.s icucriId="",arcimId=""
	.i $p(icucriOrArcimId,"||",2)'="" s arcimId=icucriOrArcimId
	.e  s icucriId=icucriOrArcimId
	.s icucriOrArcimValue=$P(itemStr,$c(3),2)
	.s PLIST(13)=$P(itemStr,$c(3),3) //ctuomId=$P(itemStr,"^",3)
	.s icuoId=$P(itemStr,$c(3),4)
	.s PLIST(17)=$P(itemStr,$c(3),5) //ancvcId=$P(itemStr,"^",5)
	.s oeoreId=$P(itemStr,$c(3),6)  //ypz add
	.s PLIST(3)=icucriId
	.s PLIST(4)=oeoreId
	.s PLIST(10)=arcimId
	.s PLIST(18)="N" //ICUO_Flag
	.s PLIST(19)="S" //ICUO_DrugMode
	.s PLIST(22)=+$h //ICUO_UpdateDate
	.s PLIST(26)="N" //ICUO_EditFlag
	.s PLIST(23)=$p($h,",",2) //ICUO_UpdateTime
	.s PLIST(30)="A" //ICUO_ICUO_Source
	.s icucriOptions=""
	.i icucriId'="" s icucriOptions=$p($g(^DHCICUC("RecordItem",icucriId)),"^",11)
	.//s ^tmpYpz("ICU",i)=icucriId_"/"_icucriType_"/"_icucriOptions_"/"
	.i (icucriType="D")!((icucriType="V")&(icucriOptions="")) s PLIST(12)=icucriOrArcimValue //数值ICUO_Qty
	.e  s PLIST(11)=icucriOrArcimValue //文本ICUO_Note
	.//s ^tmpYpz("ICU",i)=icucriId_"/"_icucriType_"/"_icucriOptions_"/"_$g(PLIST(11))_"/"_$g(PLIST(12))_"/"
	.i icuoId="" d //无记录号是插入
	    ..q:icucriOrArcimValue=""
	    ..&SQL(Insert into DHC_ICU_Order Values :PLIST())
	    ..i SQLCODE s retStr="插入数据错!"_SQLCODE
	.e  d
	    ..k PLIST(1)
	    ..s PLIST(26)="C" //ICUO_EditFlag
	    ..i icucriOrArcimValue="" s PLIST(26)="D" //无值是置删除标志
	    ..&SQL(Update DHC_ICU_Order Values :PLIST() Where ICUO_RowId=:icuoId)
	    ..i SQLCODE s retStr="修改源数据错!"_SQLCODE
	    ..q:retStr'=0
	    ..q:icucriOrArcimValue="" //删除标志后不另外补新数据
	    ..s PLIST(24)=icuoId //ICUO_ICUO_DR
	    ..s PLIST(25)="D" //ICUO_Reason
	    ..s PLIST(26)="E" //ICUO_EditFlag
	    ..&SQL(Insert Into DHC_ICU_Order Values :PLIST())
	    ..i SQLCODE s retStr="插入新数据错!"_SQLCODE
	q retStr
}

ClassMethod GetAllDataAncvcCode() As %String
{
	q $g(^DHCCLSet("ICU","AllDataAncvcCode"))
}

// 返回值:最来返执行最来一个locId的的返回值

// w ##class(web.DHCICUOrder).ConfirmCollectData()

/// 以上为PDA相关程序
/// 每小时的59分时插入数据
ClassMethod ConfirmCollectData(isDebug As %String = "") As %String
{
	SET $ZTRAP="ERR"
	s time=$p($h,",",2)
	s hour=time\3600
	s min=(time-(hour*3600))\60
	s dStr=$zd($p($h,",",1))
	s iDate=+$p(dStr,"/",2)
	
	
	// 采集相关
	s ^tmpICUDebug("ComfirmCollectData","First")=$zt($p($h,",",2))
	d ..AddCollectDataToICUOrder()
    s locId=""
     &sql(DECLARE LocCursor CURSOR FOR SELECT TOP 100 ICUP_Ctloc_Dr into :locId 
		FROM SQLUSer.DHC_ICU_Para 
		WHERE ICUP_Ctloc_Dr IS NOT NULL)
		set locId=""
		&sql(open LocCursor)
		&sql(FETCH LocCursor)
		While (SQLCODE = 0) 
		{
        set PLIST(locId)=locId
        do GenData(locId)
        &sql(FETCH LocCursor)
        
    }
    &sql(Close LocCursor)

	set date=$h-10
	&sql(delete DHC_ICU_Log where LogDate<:date)
	&sql(delete DHC_ICU_OrderLog where DataDate<:date)
	&sql(SELECT count(RowId) into :dataCount FROM DHC_ICU_Log)
	set ^DHCANICUDebug("ICULogCount")=dataCount
	&sql(SELECT count(RowId) into :dataCount FROM DHC_ICU_OrderLog)
	set ^DHCANICUDebug("ICUOrderLogCount")=dataCount
	q retStr
	
	
GenData(locId)
	set date=+$h
    try
    {
    do ..ProcessScore(date,iDate,hour,locId,1) // 自动插入评分数据
    w ##class(web.DHCICUEvent).GenData(locId,+$h,hour) // 生成评分预警数据
    ;s curRetStr=##class(web.DHCICUCom).AutoAddLabPanicRecord($h-1,$h,"",locId,0) // 自动插入检验危机值数据
    
    }
    catch(sc)
	{
		s dateStr=##class(web.DHCClinicCom).ConvertToDate(+$h)
	set ^DHCICUICUDEBUG("ConfirmCollectDataEror-GenData",dateStr,$ztime($p($h,",",2)))=sc.Location b
	}
	quit 0
	
ERR
	s dateStr=##class(web.DHCClinicCom).ConvertToDate(+$h)
	s ^TMPICUDEBUG("ComfirmCollectData",dateStr,$ztime($p($h,",",2)))=$zerror
	q "-1"
}

ClassMethod AddCollectDataToICUOrder()
{
	// w ##class(web.DHCICUOrder).AddCollectDataToICUOrder()
	s dateStr=##class(web.DHCClinicCom).ConvertToDate(+$h)
	s ^TMPICUDEBUG("AddCollectDataToICUOrder-Begin",dateStr,$ztime($p($h,",",2)))="Begin"
	SET $ZTRAP="ERR"
	;b ;11
	s wardId="" f  s wardId=$O(^User.DHCICUDeviceI("DepartmentIndex",wardId)) q:wardId=""  d
	.s wardLocId=$p($g(^PAWARD(+wardId)),"^",5)
	.q:wardLocId=""
	.s retStr=..ConfirmSingleCollectData("","","",wardLocId)
	.s ^TMPICUDEBUG("AddCollectDataToICUOrder",dateStr,$ztime($p($h,",",2)))=retStr
	s ^TMPICUDEBUG("AddCollectDataToICUOrder-Finish",dateStr,$ztime($p($h,",",2)))="Finish"
	q "0"
ERR
	s dateStr=##class(web.DHCClinicCom).ConvertToDate(+$h)
	s ^TMPICUDEBUG("AddCollectDataToICUOrder-Error",dateStr,$ztime($p($h,",",2)))=$zerror
	q "-1"
}

// 返回值:

// 1:插入当前时间已确认，2:无插入项，0:成功(有插入项)

// w ##class(web.DHCICUOrder).ConfirmSingleCollectData("","","",locId)

ClassMethod ConfirmSingleCollectData(icuaId As %String = "", date As %String = "", time As %String = "", ctlocId As %String = "", isCurTime As %String = "") As %String
{
	// w ##class(web.DHCICUOrder).ComfirmSingleCollectData("","","",56)
	s ^tmpICUDebug("Comfirm",$p($h,",",1),$p($h,",",2))="in"_$zdate($p($h,",",1))_$ztime($p($h,",",2))
	q:(icuaId="")&(ctlocId="") 0
	s wardId=+$p($g(^DHCICUArrange(+icuaId)),"^",4)
	i wardId=0 s wardId=""
	q:(wardId="")&(ctlocId="") 0
	// 初始化comItems
	i $o(^DHCCLSet("ComfirmData","GroupData"))="" d Init
	e  m comItems=^DHCCLSet("ComfirmData","GroupData")

	s lastTime=""
	s min=+$g(^DHCCLSet("ICU","ConfirmedTime")) ;入库间隔分钟数
	i min=0 s min=60
	s sti=min*60 ;入库间隔时间(以秒为单位)
	s ssti=10*60 ;采集间隔
	s scope=3*ssti ;入库时间振幅
	i (date="")!(time="") d
	.;以当前时间为基准计算
	.s date=$p($h,",",1)
	.s time=$p($h,",",2)
	.s lastTime=$g(^DHCCLSet("ICU","ConfirmedDateTime",ctlocId)) ;上次入库时间
	i isCurTime="" d
	.s time=((time+(sti/2))\sti)*sti
	.i time=(24*3600) s time=0  s date=date+1
	// 已确认则退出
	q:(date=$p(lastTime,"^",1))&(time=$p(lastTime,"^",2)) 1
	i isCurTime="" s ^DHCCLSet("ICU","ConfirmedDateTime",ctlocId)=date_"^"_time

	s patientList=##class(web.DHCICUCom).FindWardPatient(wardId, ctlocId)
	q:patientList="" 0
	s isConfirmed=0
	s retStr=2
	b ;"begin"
	s paraIcuaId=icuaId ;传入的icuaId
	f i=1:1:$l(patientList,"^") d
		.q:isConfirmed
		.q:$p(patientList,"^",i)=""
		.s icuaId=$p($p(patientList,"^",i),"|",4)
		.q:icuaId=""
		.d ..NBPComfirmData(icuaId, date, time) ;//2014-11-11 dtj
		.;根据isCurTime=true时，根据只查找指定的icuaId
		.q:(isCurTime="true")&&(paraIcuaId'=icuaId)
		.q:$p(^DHCICUArrange(icuaId),"^",18)'="M"
		.s icuoId=""
		.f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId,time,icuoId)) q:(icuoId="")!(isConfirmed)  d
			..q:'$d(^DHCICUOrder(icuoId))
			..i $p(^DHCICUOrder(icuoId),"^",29)="A" s isConfirmed=1
		.k IcucriList
		
		.s curDate=date
		.s curTime=time
		.i curTime=0 s curTime=86400,curDate=curDate-1
		.s isExit=0
		.;b ;"ss"
		.f  s curTime=$o(^DHCICUArrange(0,"CData",icuaId,curDate,curTime),-1) q:(curTime="")!(isExit)  d
			..b ;11
			..i $zabs(((date*3600*24)+time)-((curDate*3600*24)+curTime))>scope s isExit=1 q //十分钟内数据
			..b ;bb
			..s icucdSub=""
			..f  s icucdSub=$o(^DHCICUArrange(0,"CData",icuaId,curDate,curTime,icucdSub)) q:icucdSub=""  d
				...q:'$d(^DHCICUArrange(icuaId,"C",icucdSub))
				...q:$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",1)=""
				...q:$d(IcucriList($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",1)))
				...s recordItemId=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",1) ;2014-11-11 dtj
				...s recordItemCode=$p($g(^DHCICUC("RecordItem",recordItemId)),"^",1)
				...i ((recordItemCode'="NSBP")&&(recordItemCode'="NDBP")&&(recordItemCode'="NMBP")) d
				....; 非无创血压
				....s IcucriList(recordItemId)=icucdSub
				...
		.;b ;"begin2"
		.s icucriId=""
		.f  s icucriId=$o(IcucriList(icucriId)) q:icucriId=""  d
			..;b ;vv
			..s icucdSub=IcucriList(icucriId)
			..q:'$d(^DHCICUArrange(icuaId,"C",icucdSub))
			..s txtValue=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",4) //ICUO_Note
			..s numValue=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",5) //ICUO_Qty
			..d Insert2ICUOrder
			..;b "Insert"
			..// 组合项数据收集
			..s itemName=$p($g(^DHCICUC("RecordItem",icucriId)),"^",1)
			..s itemValue="" s txtValue=""
			..i itemValue="" s itemValue=numValue
			..
			..s isub=""
			..f  s isub=$o(comItems(isub)) q:isub=""  d  
			...s comItem=comItems(isub)
			...i comItem[itemName s comItems(isub,icuaId,itemName)=itemValue
			..
		.// 组合项
		.s txtValue=""
		.s numValue=""
		.s isub=""
		.
		.f  s isub=$o(comItems(isub)) q:isub=""  d 
		..;b "After s isub=$o(comItems(isub)) q:isub=""  d "
		..s csub="" s csub=$o(comItems(isub,icuaId,csub))
		..q:csub=""
		..s icucriId=isub
		..s txtValue=comItems(isub,"format") ;{0}/{1}({2})
		..s count=$l(txtValue,"{")-2
		..s nullValue=txtValue
		..f j=0:1:count d
		...;s fStr=$REPLACE("{N}","N",j);2010以上
		...s fStr=..Replace("{N}","N",j)
		...
		...s itemName=$p(comItems(isub),";",j+1)
		...i itemName="" s aValue=""
		...e  s aValue=$g(comItems(isub,icuaId,itemName))
		...
		...;s txtValue=$REPLACE(txtValue,fStr,aValue) ;2010以上
		...s txtValue=..Replace(txtValue,fStr,aValue)
		...s nullValue=..Replace(nullValue,fStr,"")
		..;b "After i aValue'="" s txtValue=$REPLACE(txtValue,fStr,aValue)"
		..;如果值为空则退出
		..;b "如果值为空则退出"
		..q:nullValue=txtValue  
		..d Insert2ICUOrder
		
	q retStr
	
Insert2ICUOrder	
	s wardIds=$g(^DHCCLSet("RecentDataWardId")) ;不需要添加最近时间的参数的科室
	s wardId=$p($p($g(^DHCICUArrange(icuaId)),"^",4),"||",1)
	s InsertedRecentData=""
	s viewCat=$p($g(^DHCICUC("RecordItem",icucriId)),"^",5)
	q:(("^"_wardIds_"^")[("^"_wardId_"^"))&&(viewCat=231)
	// 查询后插入
	;b ;"Insert2ICUOrder1"
	
	///20210520 start
	s ICUPRowId=$o(^DHCICUPara(0,"ICUA",icuaId,""))
	s ChildSub="",ICUPIICUPIDr=""
	for  s ChildSub=$o(^DHCICUPara(ICUPRowId,"I",ChildSub)) q:ChildSub=""  d
	.i ($p($g(^DHCICUPara(ICUPRowId,"I",ChildSub)),"^",4)=icucriId)  d
	..s ICUPIICUPIDr=ICUPRowId_"||"_ChildSub
	///20210520 end
	
	s isFind=0
	s sub=""
	f  s sub=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId,time,sub)) q:((sub="")||(isFind=1))  d
	.s ctuomId=$p($g(^DHCICUOrder(sub)),"^",2)
	.i ctuomId=icucriId s isFind=1 	 
	q:isFind=1
	;b ;"Insert2ICUOrder2"
	k PLIST
	s PLIST(2)=icuaId //icuaId
	s PLIST(3)=icucriId //icucriId
	s PLIST(5)="" //userId
	s PLIST(6)=date //startDate
	s PLIST(7)=time //startTime
	s PLIST(8)=date //endDate
	s PLIST(9)=time //endTime
	s PLIST(11)=txtValue
	s PLIST(12)=numValue
	s PLIST(13)="" //ctuomId
	s PLIST(17)=$p($g(^DHCICUC("RecordItem",icucriId)),"^",5) //ancvcId
	s PLIST(18)="N" //ICUO_Flag
	s PLIST(22)=+$h //ICUO_UpdateDate
	s PLIST(23)=$p($h,",",2) //ICUO_UpdateTime
	s PLIST(24)="" //ICUO_ICUO_Dr
	s PLIST(26)="N" //ICUO_EditFlag
	s PLIST(30)="I" //ICUO_ICUO_Source
	s PLIST(31)=$p($g(^DHCICUC("RecordItem",icucriId)),"^",3) //ICUO_Type
	
	s PLIST(39)=ICUPIICUPIDr
	
	&SQL(Insert into DHC_ICU_Order Values :PLIST())
	i SQLCODE s retStr=icuoId_":ICU SQLCODE:"_SQLCODE //icuoId"插入数据错! SQLCode="_SQLCODE
	s ^tmpICUDebug("Comfirmed",$h)=SQLCODE_",rowId="_$g(%ROWID)
	s retStr=0
	q 
Init
	// 组合项初始化
	s comOrd=""
	//b "Init"
	f  s comOrd=$o(^DHCICUC("RecordItem",comOrd)) q:comOrd=""  d
	.s comItem=$g(^DHCICUC("RecordItem",comOrd))
	.s cTypeID=$p(comItem,"^",5)
	.q:cTypeID=""
	.s cTypeCode=$p($g(^DHCICUC("ViewCat",cTypeID)),"^",1) // 类型:只处理生命体征
	.q:cTypeCode=""
	.s forStr=$p(comItem,"^",25)
	.s paraStr=$p(comItem,"^",27)
	.
	.i ($p(comItem,"^",24)="Note")&((cTypeCode="VitalSign")||(cTypeCode="ICUBloodAnalysis")||(cTypeCode="ICUBloodAnalysis")||(cTypeCode="RespiratorySupport")||(cTypeCode="HF"))&(forStr["{0}") d
	..s comItems(comOrd)=$p(comItem,"^",27) ;NSBP;NDBP;NMBP
	..s comItems(comOrd,"format")=$p(comItem,"^",25) ; {0}/{1}({2})	
	m ^DHCCLSet("ComfirmData","GroupData")=comItems	
	q
}

// 无创血压入库

ClassMethod NBPComfirmData(icuaId, dstDate, dstTime, scope = 3600)
{
	// w ##class(web.DHCICUOrder).NBPComfirmData(4497, "2014-11-11", "10:00")
	i dstDate'=+dstDate s dstDate=##class(web.DHCClinicCom).ConvertToDateH(dstDate)
	i dstTime'=+dstTime s dstTime=##class(web.DHCClinicCom).ConvertToTimeH(dstTime)
	
	s NBPs="NSBP",NBPd="NDBP",NBPm="NMBP",NBP="NBP",isExit=0
	// 如果存在配置，则加载配置
	i $g(^DHCCLSet("ICU","NBPs"))'="" s NBPs=$g(^DHCCLSet("ICU","NBPs"))
	i $g(^DHCCLSet("ICU","NBPd"))'="" s NBPd=$g(^DHCCLSet("ICU","NBPd"))
	i $g(^DHCCLSet("ICU","NBPm"))'="" s NBPm=$g(^DHCCLSet("ICU","NBPm"))
	i $g(^DHCCLSet("ICU","NBP"))'="" s NBP=$g(^DHCCLSet("ICU","NBP"))
	
	s NBPsId=$O(^DHCICUC("RecordItem",0,"Code",NBPs,""))
	s NBPdId=$O(^DHCICUC("RecordItem",0,"Code",NBPd,""))
	s NBPmId=$O(^DHCICUC("RecordItem",0,"Code",NBPm,""))
	s NBPId=$O(^DHCICUC("RecordItem",0,"Code",NBP,""))
	i ((NBPsId="")||(NBPdId="")||(NBPmId="")) d
	.s ^TMPICUDEBUG("NBPComfirmData",+$h)=##class(web.DHCClinicCom).ConvertToDate(date)_" "_##class(web.DHCClinicCom).ConvertToTime(time)_NBPsId_"/"_NBPdId_"/"_NBPmId
	
	s index=0
	s date="" f  s date=$O(^DHCICUArrange(0,"CData",icuaId,date),-1) q:((isExit)||(date=""))  d
	.i date=dstDate s time=dstTime+1
	.e  s time=""
	.f  s time=$O(^DHCICUArrange(0,"CData",icuaId,date,time),-1) q:((isExit)||(time=""))  d
	..i $zabs(((date*3600*24)+time)-((dstDate*3600*24)+dstTime))>scope s isExit=1 q 
	..
	..s sys=..FindCollectData(icuaId,date,time,NBPsId)
	..q:sys=""
	..s dia=..FindCollectData(icuaId,date,time,NBPdId)
	..s mean=..FindCollectData(icuaId,date,time,NBPmId)
	..s calMean=(sys*(1/4))+(dia*(3/4))
	..//===========入库==============
	..w icuaId_" "_##class(web.DHCClinicCom).ConvertToDate(date)_" "_##class(web.DHCClinicCom).ConvertToTime(time)_"  "_sys_"/"_dia_"/"_mean,!
	..s isExit=1 ; 只找最近的一组数据
	..
	..i ..FindAnyDataFromCollectData(icuaId,dstDate,dstTime) d
	...; 如果半小时之内有其他生命体征数据，则认为病人仍在ICU,需要入库；否则，认为已离开ICU，不将无创血压填写在curTime
	...; 以下入库方式可能会修改用户添加的数据,但因为采集的数据更客观所以覆盖(也避免重复调用时产生多条数据引起数据库爆涨)
	...s sysId=##class(web.DHCICUCom).Insert2ICUOrder(icuaId,NBPsId,dstDate,dstTime,sys,"")
	...s diaId=##class(web.DHCICUCom).Insert2ICUOrder(icuaId,NBPdId,dstDate,dstTime,dia,"")
	...s meanId=##class(web.DHCICUCom).Insert2ICUOrder(icuaId,NBPmId,dstDate,dstTime,mean,"")
	...s nbpId=##class(web.DHCICUCom).Insert2ICUOrder(icuaId,NBPId,dstDate,dstTime,"",sys_"/"_dia_"("_mean_")")
	...s ^tmpdebug("dtj-nbp",icuaId,dstDate,dstDate,NBPs)=sysId_" "_sys_" "_##class(web.DHCClinicCom).ConvertToDate(date)_" "_##class(web.DHCClinicCom).ConvertToTime(time)
	...s ^tmpdebug("dtj-nbp",icuaId,dstDate,dstDate,NBPd)=diaId_" "_dia_" "_##class(web.DHCClinicCom).ConvertToDate(date)_" "_##class(web.DHCClinicCom).ConvertToTime(time)
	...s ^tmpdebug("dtj-nbp",icuaId,dstDate,dstDate,NBPm)=meanId_" "_mean_" "_##class(web.DHCClinicCom).ConvertToDate(date)_" "_##class(web.DHCClinicCom).ConvertToTime(time)
	..i ((mean>=sys)||(mean<=dia)) d
	...; ========异常数据入库==========
	...s str="icuaId:"_icuaId_"  "_##class(web.DHCClinicCom).ConvertToDate(date)_" "_##class(web.DHCClinicCom).ConvertToTime(time)_"  "_sys_"/"_dia_"/"_mean
	...w str,!
	...s dateStr=##class(web.DHCClinicCom).ConvertToDate(date)
	...s ^tmpdebug("dtj-Collect",dateStr,icuaId,index)=str
	...s index=index+1
	q "Over"
}

/// 执行医嘱一条医嘱/医嘱执行记录，正常返回值为0
ClassMethod NurseExecOrder(oeoreId, userId) As %String
{
	q ##class(web.DHCNurCom).UpdateOrdGroup("", oeoreId, userId, 1)
}

/// 取消执行一条医嘱/医嘱执行记录，正常返回值为0
ClassMethod UndoNurseExecOrder(oeoreId, userId) As %String
{
	q ##class(web.DHCNurCom).UpdateOrdGroup("", oeoreId, userId, 0)
}

/*
/// 批量保存重症监护数据
/// orderParaList由重症监护数据串拼接而成，以"^"分割。数据串以$c(3)分割，按照表DHC_ICU_Order的SqlColumnNumber顺序拼接而成。
/// 数据串第一个字段固定为数据的RowId(ICUO_RowId)，如果是新增的数据，那么第一个字段为空。
/// 返回结果为保存后的数据Id串，以"^"分割
ClassMethod SaveICUOrder(orderParaList As %String) As %String
{
	s result=""
	s ifOperOEOrder=$g(^DHCCLSet("ICU","OperOEOrder"))
	f i=1:1:$l(orderParaList,"^")  d
	.s orderPara=$p(orderParaList,"^",i)
	.q:orderPara=""
	.s orderObj=..SetICUOrderValue(orderPara)
	.s orderId=$p(orderPara,$c(3),1)
	.s icuaId=$p(orderPara,$c(3),2)
	.s icucriId=$p(orderPara,$c(3),3)
	.s startDate=##class(DHCClinicCom).ConvertToDateH($p(orderPara,$c(3),6))
	.s startTime=##class(DHCClinicCom).ConvertToTimeH($p(orderPara,$c(3),7))
	.;b "here"
	.s icuoId="",unSameIcuoId="",isFind=0
	.//w icucriId_"\"_startDate_"\"_icuaId_"\"_startTime,!
	.i orderId="" d
		..f  s icuoId=$o(^DHCICUOrder(0,"RecordItem",+icucriId,+startDate,+icuaId,+startTime,icuoId)) q:(icuoId="")  d
			...q:'$d(^DHCICUOrder(icuoId))
			...q:"ICD"[$p(^DHCICUOrder(icuoId),"^",25)
			...//w "    icuoId="_icuoId
			...s paraItemId=$p(orderPara,$c(3),39)
			...s icuoIcupiId=$p(^DHCICUOrder(icuoId),"^",38)
			...q:$p(^DHCICUOrder(icuoId),"^",3)'=$p(orderPara,$c(3),4) // ICUO_Oeore_Dr 2014-03-22
			...q:(icuoIcupiId="")!(paraItemId="")
			...q:(icuoIcupiId'=paraItemId)
			...s isQuit=1,isFind=1
			...i $p(^DHCICUOrder(icuoId),"^",9)'=$p(orderPara,$c(3),10) s isQuit=0	//ICUO_Arcim_Dr
			...i $p(^DHCICUOrder(icuoId),"^",10)'=$p(orderPara,$c(3),11) s isQuit=0	//ICUO_Note
			...i $p(^DHCICUOrder(icuoId),"^",11)'=+$p(orderPara,$c(3),12) s isQuit=0	//ICUO_Qty
			...i $p(^DHCICUOrder(icuoId),"^",12)'=$p(orderPara,$c(3),13) s isQuit=0	//ICUO_UomDr
			...i $p(^DHCICUOrder(icuoId),"^",13)'=+$p(orderPara,$c(3),14) s isQuit=0	//ICUO_Concentration
			...i $p(^DHCICUOrder(icuoId),"^",15)'=$p(orderPara,$c(3),16) s isQuit=0	//ICUO_InstrDr
			...i $p(^DHCICUOrder(icuoId),"^",16)'=$p(orderPara,$c(3),17) s isQuit=0	//ICUO_ViewCatDr
			...i $p(^DHCICUOrder(icuoId),"^",19)'=+$p(orderPara,$c(3),20) s isQuit=0	//ICUO_Speed
			...i $p(^DHCICUOrder(icuoId),"^",20)'=$p(orderPara,$c(3),21) s isQuit=0	//ICUO_SpeedUnitDr
			...i $p(^DHCICUOrder(icuoId),"^",28)'=+$p(orderPara,$c(3),29) s isQuit=0	//ICUOVolume
			...i $p(^DHCICUOrder(icuoId),"^",31)'=+$p(orderPara,$c(3),32) s isQuit=0	//ICUOPreparedVolume
			...//i $p(^DHCICUOrder(icuoId),"^",32)'=$p(orderPara,$c(3),33) s isQuit=0	//ICUOAttachOeoriId
			...//i $p(^DHCICUOrder(icuoId),"^",34)'=$p(orderPara,$c(3),35) s isQuit=0	//ICUOAbbreviate
			...i $p(^DHCICUOrder(icuoId),"^",37)'=+$p(orderPara,$c(3),38) s isQuit=0	//ICUORemarks
			...//s paraItemId=$p(orderPara,$c(3),39)
			...i $p(^DHCICUOrder(icuoId),"^",39)'=+$p(orderPara,$c(3),40) s isQuit=0	//ICUOTotalQty
			...q:isQuit
			...s unSameIcuoId=icuoId
			...s ^tmpICUDebug("DupInsert",icuaId,startDate,startTime,unSameIcuoId)=""
	.//d orderObj.%Save()
	.//w "  "_isFind_"  isFind\unSameIcuoId  "_unSameIcuoId,!
	.q:(isFind)&(unSameIcuoId="")&(orderId="")
	.//w " next ",!
	.s saveStatus=orderObj.%Save()
	.i (unSameIcuoId'="")&(+saveStatus'=0) d
		..s curIcuoId=orderObj.%Id()
		..q:+curIcuoId=0
		..s ^tmpICUDebug("DupInsert",icuaId,startDate,startTime,unSameIcuoId)=curIcuoId_"^"_$h
		..s $p(^DHCICUOrder(unSameIcuoId),"^",25)="C"
		..s $p(^DHCICUOrder(curIcuoId),"^",14)=$p(^DHCICUOrder(unSameIcuoId),"^",14)
		..i $p(^DHCICUOrder(curIcuoId),"^",14)=""  s $p(^DHCICUOrder(curIcuoId),"^",14)=unSameIcuoId
		..s $p(^DHCICUOrder(curIcuoId),"^",23)=unSameIcuoId
		..s $p(^DHCICUOrder(curIcuoId),"^",25)="E"
		..//d ..CheckDoctorHandover(icuaId,curIcuoId,startDate,startTime)
	.i (orderObj.ICUOOeoreDr'="")&(ifOperOEOrder="Y") d
	..i orderObj.ICUOEditFlag="N" d ..NurseExecOrder(orderObj.ICUOOeoreDr,orderObj.ICUOUserDr)  
	..i orderObj.ICUOEditFlag="D" d ..UndoNurseExecOrder(orderObj.ICUOOeoreDr,orderObj.ICUOUserDr)
	.i result'="" s result=result_"^"
	.s result=result_orderObj.%Id()
	.d ..CheckDoctorHandover(icuaId,orderObj.%Id(),startDate,startTime)
	.d orderObj.%Close()
	.s ^tmpICUDebug("SaveICUOrder",icuaId,startDate,startTime,i)=orderPara
	q result
}
*/
/// 批量保存重症监护数据
/// orderParaList由重症监护数据串拼接而成，以"^"分割。数据串以$c(3)分割，按照表DHC_ICU_Order的SqlColumnNumber顺序拼接而成。
/// 数据串第一个字段固定为数据的RowId(ICUO_RowId)，如果是新增的数据，那么第一个字段为空。
/// 返回结果为保存后的数据Id串，以"^"分割
ClassMethod SaveICUOrder(orderParaList As %String) As %String
{
	s result=""
	k SyncOEOREList
	set icuaId=""
	f i=1:1:$l(orderParaList,"^")  d
	.s orderPara=$p(orderParaList,"^",i)
	.q:orderPara=""
	.///判断个人模板id不属于该icuaId则退出 20210911
	.s icuaId=$p(orderPara,$c(3),2)
	.q:$d(^DHCICUArrange(+icuaId))<1
	.s pItemId=$p(orderPara,$c(3),39)
	.if ((pItemId'="")&&($p($g(^DHCICUPara($p(pItemId,"||",1))),"^",1)'=icuaId)) d
	..set ^DHCICUUIDebugLog("SaveICUOrderWrongParaId",icuaId,+$h,$p($h,",",2))=orderParaList
	..do ##class(User.DHCICULog).Log("SaveICUOrderWrongParaId",icuaId, "web.DHCICUOrder", "SaveICUOrder", orderParaList)
	..set i=$l(orderParaList,"^")+1
	..
	..SET mygenex = ##class(%Exception.General).%New("数据出现异常，保存失败","999",,"数据异常，保存失败，请退出程序后重新进入")
	..throw mygenex
	.q:((pItemId'="")&&($p($g(^DHCICUPara($p(pItemId,"||",1))),"^",1)'=icuaId))
	.
	.s orderObj=..SetICUOrderValue(orderPara)
	.s orderId=$p(orderPara,$c(3),1)
	.s icuaId=$p(orderPara,$c(3),2)
	.s ^DHCICUOrderGlobalLog(icuaId,$zd(+$h,3),$zt($p($h,",",2),1),i)=orderPara
	.s icucriId=$p(orderPara,$c(3),3)
	.s startDate=##class(DHCClinicCom).ConvertToDateH($p(orderPara,$c(3),6))
	.s startTime=##class(DHCClinicCom).ConvertToTimeH($p(orderPara,$c(3),7))
	.;b "here"
	.s icuoId="",oldNormalIcuoId="",sameIcuoId=""
	.//w icucriId_"\"_startDate_"\"_icuaId_"\"_startTime,!
	.i orderId="" d
		..f  s icuoId=$o(^DHCICUOrder(0,"RecordItem",+icucriId,+startDate,+icuaId,+startTime,icuoId)) q:(icuoId="")  d
			...q:'$d(^DHCICUOrder(icuoId))
			...q:"ICD"[$p(^DHCICUOrder(icuoId),"^",25)
			...//w "    icuoId="_icuoId
			...s paraItemId=$p(orderPara,$c(3),39)
			...s icuoIcupiId=$p(^DHCICUOrder(icuoId),"^",38)
			...q:$p(^DHCICUOrder(icuoId),"^",3)'=$p(orderPara,$c(3),4) // ICUO_Oeore_Dr 2014-03-22
			...q:(icuoIcupiId="")!(paraItemId="")
			...q:(icuoIcupiId'=paraItemId)
			...
			...i $$IsSameData(icuoId,orderPara) s sameIcuoId=icuoId
			...e  d
			....s oldNormalIcuoId=icuoId
			....s ^tmpICUDebug("DupInsert",icuaId,startDate,startTime,oldNormalIcuoId)=""
	.//d orderObj.%Save()
	.//w "  "_isFind_"  isFind\oldNormalIcuoId  "_oldNormalIcuoId,!
	.i sameIcuoId'="" d
	..s curIcuoId=sameIcuoId
	.e  d
	..s saveStatus=orderObj.%Save()
	..s curIcuoId=orderObj.%Id()
	..d ProcessOldData
	..d orderObj.%Close()
	..;d ..OnDataChanged(icuaId, curIcuoId, startDate, startTime)	///20210910 
	..;d ..CheckDoctorHandover(icuaId,curIcuoId,startDate,startTime)
	..s ^tmpICUDebug("SaveICUOrder",icuaId,startDate,startTime,i)=orderPara
	.i result'="" s result=result_"^"
	.s result=result_curIcuoId
	
	try
	{
		do ##class(User.DHCICUOrderLog).LogSaveIcuOrder(icuaId,orderParaList)
	}
	catch
	{
	}
	d SyncOEORE
	
	q result
	
ProcessOldData
	i (oldNormalIcuoId'="")&(+saveStatus'=0) d
		.
		.q:+curIcuoId=0
		.s ^tmpICUDebug("DupInsert",icuaId,startDate,startTime,oldNormalIcuoId)=curIcuoId_"^"_$h
		.s $p(^DHCICUOrder(oldNormalIcuoId),"^",25)="C"
		.s $p(^DHCICUOrder(curIcuoId),"^",14)=$p(^DHCICUOrder(oldNormalIcuoId),"^",14)
		.i $p(^DHCICUOrder(curIcuoId),"^",14)=""  s $p(^DHCICUOrder(curIcuoId),"^",14)=oldNormalIcuoId
		.s $p(^DHCICUOrder(curIcuoId),"^",23)=oldNormalIcuoId
		.s $p(^DHCICUOrder(curIcuoId),"^",25)="E"
		.//d ..CheckDoctorHandover(icuaId,curIcuoId,startDate,startTime)
	i (orderObj.ICUOOeoreDr'="") d
	.s SyncOperation=$s(orderObj.ICUOEditFlag="N":"Exec",orderObj.ICUOEditFlag="E":"Exec",orderObj.ICUOEditFlag="C":"UndoExec",orderObj.ICUOEditFlag="D":"UndoExec",1:"ERROR")
	.s SyncOEOREList(orderObj.ICUOOeoreDr,SyncOperation,orderObj.ICUOStartDate,orderObj.ICUOStartTime)=$lb(orderObj.ICUOICUADr.%Id(),orderObj.ICUOUserDr)
	.//i orderObj.ICUOEditFlag="N" d ..NurseExecOrder(orderObj.ICUOOeoreDr,orderObj.ICUOUserDr)  
	.//i orderObj.ICUOEditFlag="D" d ..UndoNurseExecOrder(orderObj.ICUOOeoreDr,orderObj.ICUOUserDr)
	q
IsSameData(icuoId,orderPara)
	q:$p(^DHCICUOrder(icuoId),"^",9)'=$p(orderPara,$c(3),10) 0 //ICUO_Arcim_Dr
	q:$p(^DHCICUOrder(icuoId),"^",10)'=$p(orderPara,$c(3),11) 0 //ICUO_Note
	q:+$p(^DHCICUOrder(icuoId),"^",11)'=+$p(orderPara,$c(3),12) 0 //ICUO_Qty
	q:$p(^DHCICUOrder(icuoId),"^",12)'=$p(orderPara,$c(3),13) 0 //ICUO_UomDr
	q:+$p(^DHCICUOrder(icuoId),"^",13)'=+$p(orderPara,$c(3),14) 0 //ICUO_Concentration
	q:$p(^DHCICUOrder(icuoId),"^",15)'=$p(orderPara,$c(3),16) 0 //ICUO_InstrDr
	q:$p(^DHCICUOrder(icuoId),"^",16)'=$p(orderPara,$c(3),17) 0 //ICUO_ViewCatDr
	q:+$p(^DHCICUOrder(icuoId),"^",19)'=+$p(orderPara,$c(3),20) 0 //ICUO_Speed
	q:$p(^DHCICUOrder(icuoId),"^",20)'=$p(orderPara,$c(3),21) 0 //ICUO_SpeedUnitDr
	q:+$p(^DHCICUOrder(icuoId),"^",28)'=+$p(orderPara,$c(3),29) 0 //ICUOVolume
	q:+$p(^DHCICUOrder(icuoId),"^",31)'=+$p(orderPara,$c(3),32) 0 //ICUOPreparedVolume
	q:$p(^DHCICUOrder(icuoId),"^",37)'=$p(orderPara,$c(3),38) 0 //ICUORemarks
	q:+$p(^DHCICUOrder(icuoId),"^",39)'=+$p(orderPara,$c(3),40) 0 //ICUOTotalQty
	q:+$p(^DHCICUOrder(icuoId),"^",40)'=+$p($g(orderPara),$c(3),41) 0	//ICUO_DoseSpeed
	q 1
	
SyncOEORE
	set ifOperOEOrder=$g(^DHCCLSet("ICU","OperOEOrder"))
	if (ifOperOEOrder'="Y")&&(icuaId'=111) quit
	set oeoreId=""
	for
	{
		set oeoreId=$o(SyncOEOREList(oeoreId))
		quit:oeoreId=""
		
		if $d(SyncOEOREList(oeoreId,"Exec"))
		{
			//Exec
			set date=$o(SyncOEOREList(oeoreId,"Exec",""))
			set time=$o(SyncOEOREList(oeoreId,"Exec",date,""))
			set icuaId=$lg(SyncOEOREList(oeoreId,"Exec",date,time),1)
			set userId=$lg(SyncOEOREList(oeoreId,"Exec",date,time),2)
			
			//set oeoreStr=oeoreId_"^^^^^"_$zd(date,4)_"^"_$zt(time)_"^^^"
			//m ^DHCICUTMP201707("NurseExec","DHCICUOrder")=SyncOEOREList
			//do ..NurseExecOrder(oeoreStr,userId)
			do ##class(appcom.OEOrdExec).UpdateStatus(oeoreId,"F",userId,date,time)
		}
		elseif $d(SyncOEOREList(oeoreId,"UndoExec"))
		{
			//UndoExec
			set date=$o(SyncOEOREList(oeoreId,"UndoExec",""))
			set time=$o(SyncOEOREList(oeoreId,"UndoExec",date,""))
			set icuaId=$lg(SyncOEOREList(oeoreId,"UndoExec",date,time),1)
			set userId=$lg(SyncOEOREList(oeoreId,"UndoExec",date,time),2)
			set isCompletelyRemoved=$$IsCompletelyRemoved(oeoreId,icuaId)
			
			set SyncOEOREList(oeoreId,"UndoExec",date,time)=SyncOEOREList(oeoreId,"UndoExec",date,time)_$lb(isCompletelyRemoved)
			//m ^DHCICUTMP201707("NurseExec","DHCICUOrder")=SyncOEOREList
			
			if isCompletelyRemoved
			{
				//set oeoreStr=oeoreId_"^^^^^"_$zd(date,4)_"^"_$zt(time)_"^^^"
				//do ..UndoNurseExecOrder(oeoreStr,userId)
				do ##class(appcom.OEOrdExec).UpdateStatus(oeoreId,"C",userId,date,time)
			}
		}
	}
	quit
	
IsCompletelyRemoved(oeoreId,icuaId)
	set icuoId="",isCompletelyRemoved=1
	for
	{
		set icuoId=$o(^DHCICUOrder(0,"OEORE",oeoreId,icuaId,icuoId))
		quit:icuoId=""
		
		set icuoEditFlag=$p(^DHCICUOrder(icuoId),"^",25)
		if ("NE"[icuoEditFlag)
		{
			set isCompletelyRemoved = 0
			quit
		}
	}
	
	quit isCompletelyRemoved
}

ClassMethod OnDataChanged(icuaId, curIcuoId, startDate, startTime)
{
	d ..CheckDoctorHandover(icuaId,curIcuoId,startDate,startTime)
	d ##class(web.DHCICUMicroPump).GenPumpDataFromUI(icuaId,curIcuoId,startDate,startTime)
}

ClassMethod SetICUOrderValue(orderPara As %String) As User.DHCICUOrder
{
	;q:($p(orderPara,$c(3),39)'="")
	s orderId=$p(orderPara,$c(3),1)
	s order=""
	q:(orderPara="") order
	i orderId=""  s order=##class(User.DHCICUOrder).%New()
	e  s order=##class(User.DHCICUOrder).%OpenId(orderId)
	s order.ICUOICUADr=##class(User.DHCICUArrange).%OpenId($p(orderPara,$c(3),2))
	s order.ICUOComOrdDr=##class(User.DHCICUCRecordItem).%OpenId($p(orderPara,$c(3),3))
	s order.ICUOOeoreDr=$p(orderPara,$c(3),4)
	s order.ICUOUserDr=$p(orderPara,$c(3),5)
	s order.ICUOStartDate=##class(web.DHCClinicCom).ConvertToDateH($p(orderPara,$c(3),6))
	s order.ICUOStartTime=##class(web.DHCClinicCom).ConvertToTimeH($p(orderPara,$c(3),7))
	s order.ICUOEndDate=##class(web.DHCClinicCom).ConvertToDateH($p(orderPara,$c(3),8))
	s order.ICUOEndTime=##class(web.DHCClinicCom).ConvertToTimeH($p(orderPara,$c(3),9))
	s order.ICUOArcimDr=$p(orderPara,$c(3),10)
	s order.ICUONote=$p(orderPara,$c(3),11)
	s order.ICUOQty=+$p(orderPara,$c(3),12)
	s order.ICUOUomDr=$p(orderPara,$c(3),13)
	s order.ICUOConcentration=+$p(orderPara,$c(3),14)
	s originateFromICUOId=$p(orderPara,$c(3),15)
	i originateFromICUOId'="" s order.ICUOOriginateFromICUODr=##class(User.DHCICUOrder).%OpenId(originateFromICUOId)
	s order.ICUOInstrDr=$p(orderPara,$c(3),16)
	s order.ICUOViewCatDr=##class(User.DHCICUCViewCat).%OpenId($p(orderPara,$c(3),17))
	s order.ICUOFlag=$p(orderPara,$c(3),18)
	s order.ICUODrugMode=$p(orderPara,$c(3),19)
	s order.ICUOSpeed=+$p(orderPara,$c(3),20)
	s speedUnitId=$p(orderPara,$c(3),21) 
	i speedUnitId'="" s order.ICUOSpeedUnitDr=##class(User.DHCICUCSpeedUnit).%OpenId(speedUnitId)
	s icuoId=$p(orderPara,$c(3),24)
	i icuoId'="" s order.ICUOICUODR=##class(User.DHCICUOrder).%OpenId(icuoId)
	s order.ICUOReason=$p(orderPara,$c(3),25)
	s order.ICUOEditFlag=$p(orderPara,$c(3),26)
	
	i (orderId="")||(order.ICUOEditFlag="N") d
	.s order.ICUOUpdateDate=+$h	//##class(web.DHCClinicCom).ConvertToDateH($p(orderPara,$c(3),22))
	.s order.ICUOUpdateTime=$p($h,",",2) //##class(web.DHCClinicCom).ConvertToTimeH($p(orderPara,$c(3),23))
	
	s order.ICUORecLocDr=$p(orderPara,$c(3),27)
	s order.ICUODocUserDr=$p(orderPara,$c(3),28)
	s order.ICUOVolume=+$p(orderPara,$c(3),29)
	s order.ICUOSource=$p(orderPara,$c(3),30)
	s order.ICUOType=$p(orderPara,$c(3),31)
	s order.ICUOPreparedVolume=+$p(orderPara,$c(3),32)
	s order.ICUOAttachOeoriId=$p(orderPara,$c(3),33)
	s order.ICUOReportResult=$p(orderPara,$c(3),34)
	s order.ICUOAbbreviate=$p(orderPara,$c(3),35)
	s order.ICUOOrdItemNote=$p(orderPara,$c(3),36)
	s mainIcuoId=$p(orderPara,$c(3),37)
	i mainIcuoId'="" s order.ICUOMainIcuoDr=##class(User.DHCICUOrder).%OpenId(mainIcuoId)
	s order.ICUORemarks=$p(orderPara,$c(3),38)
	s paraItemId=$p(orderPara,$c(3),39)
	i paraItemId'="" s order.ICUOICUPIDr=##class(User.DHCICUParaItem).%OpenId(paraItemId)
	s order.ICUOTotalQty=+$p(orderPara,$c(3),40)
	;原来是40是total，41是dosespeed
	s order.ICUODoseSpeed=+$p($g(orderPara),$c(3),41)	//保存剂量
	q order
}

ClassMethod Replace(str As %String, subStr As %String, value As %String) As %String
{
	s i=$find(str,subStr)
	s begin=i-$L(subStr)-1	
	s str=$E(str,1,begin)_value_$E(str,i,$L(str))
	q str
}

/// 新版未用
/// w ##class(web.DHCICUArrange).GetOrderValueByIdAndDate("5329","2013/7/11","44") //慢慢不用
ClassMethod GetOrderValueByIdAndDate(icucriId As %String, icuaId As %String = "", startDate As %String = "", endDate = "") As %String
{
	q:icucriId="" ""
	q:icuaId="" ""
	s ret="",icuoId=""
	f  s icuoId=$O(^DHCICUOrder(0,"CommOrd",icucriId,icuaId,icuoId)) q:icuoId=""  d
		.q:'$d(^DHCICUOrder(icuoId))
		.q:(startDate'="")&($p(^DHCICUOrder(icuoId),"^",5)<startDate)
		.q:(endDate'="")&($p(^DHCICUOrder(icuoId),"^",5)>endDate)
		.q:"ICD"[$p(^DHCICUOrder(icuoId),"^",25)
		.s ret=$p(^DHCICUOrder(icuoId),"^",11)
		.i ret="0" s ret=$p(^DHCICUOrder(icuoId),"^",10)
	q ret
}

ClassMethod SetMainSubIcucriList(icuaId As %String, mainList As %String) As %String
{
	q:+icuaId=0 -1
	s icuaId = +icuaId
	s wardId=+$p(^DHCICUArrange(icuaId),"^",4)
	
	s wardCtlocId=$p(^PAWARD(wardId),"^",5)
	q:wardCtlocId="" -2
	s icupId=$o(^DHCICUPara(0,"Ctloc",wardCtlocId,""))
	q:icupId="" -3
	s icupiSub=0
	f  s icupiSub=$o(^DHCICUPara(icupId,"I",icupiSub)) q:icupiSub=""  d
		.s icucriId=$p(^DHCICUPara(icupId,"I",icupiSub),"^",4)
		.q:icucriId=""
		.q:'$d(^DHCICUC("RecordItem",icucriId))
		.q:$p(^DHCICUC("RecordItem",icucriId),"^",3)'="D"
		.q:$p(^DHCICUC("RecordItem",icucriId),"^",23)=""
		.s mainList($p(^DHCICUC("RecordItem",icucriId),"^",23),icucriId)=$p(^DHCICUC("RecordItem",icucriId),"^",24)
		.//w $p(^DHCICUC("RecordItem",icucriId),"^",23)_"    "_icucriId_"/"_$p(^DHCICUC("RecordItem",icucriId),"^",24),!
	q 0
}

// ##class(web.DHCICUOrder).ClearLog(date)

// 清除前10天的数据，如25号清除15号的数据

ClassMethod ClearLog(iDate As %String)
{
	// ##class(web.DHCICUOrder).ClearLog(iDate)
	s logKeepDays=25	
	d ClearDevLog("StartEq",logKeepDays)
	d ClearDevLog("StopEq",logKeepDays)

	d ClearDevLog("InsertToOrder",logKeepDays)
	// 清楚实际时间格式的数据: ^DHCANICUDEBUG(type,date,time..)
	s type="" f  s type=$o(^DHCANICUDEBUG(type)) q:type=""  d
	.i $ISVALIDNUM(type) k ^DHCANICUDEBUG(type)
	.q:((type="InsertToOrder")||(type="NBP"))
	.s date="" f  s date=$o(^DHCANICUDEBUG(type,date)) q:date=""  d
	..i date<30 d
	...s span=date-iDate
	...i $zabs(span)>=logKeepDays  k ^DHCANICUDEBUG(type,date)

	..e  d
	...s span=+$h-date
	...i $zabs(span)>=logKeepDays  k ^DHCANICUDEBUG(type,date)
	q "0"
ClearDevLog(type,logKeepDays)	
	s source="" f  s source=$o(^DHCANICUDEBUG(type,source)) q:source=""  d
	.s eqId="" f  s eqId=$o(^DHCANICUDEBUG(type,source,eqId)) q:eqId=""  d
	..s date="" f  s date=$o(^DHCANICUDEBUG(type,source,eqId,date)) q:date=""  d
	...s span=iDate-date
	...i span>logKeepDays k ^DHCANICUDEBUG(type,source,eqId,date) w type,":",date,!
	...e  i span<0  k ^DHCANICUDEBUG(type,source,eqId,date) w type,":",date,!
	q
}

/// 根据时间时间查找整点数据
/// date:日期，如"2013-08-14"
/// from:int型，小时数，如10点为10
/// count:循环次数，如4小时为4
ClassMethod ConfirmDataByTime(date, from, count)
{
	// w ##class(web.DHCICUOrder).ConfirmDataByTime("2021-08-21",17,3) ;入库20:00-21:00的数据
	s bedId="",i=0,locId=0
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	s endTime=from+count
	q:(from>24)||(from<0) "开始时间范围：0~23"
	q:(endTime>24)||(endTime<0) "结束时间超过范围：0~23"
	// 查找DHC_ICU_BedEquip表中配置的所以病区的locId
	
	s wardId="" f  s wardId=$O(^User.DHCICUDeviceI("DepartmentIndex",wardId)) q:wardId=""  d
	.s wardLocId=$p($g(^PAWARD(+wardId)),"^",5)
	.q:wardLocId=""
	.s PLIST(wardLocId)=wardLocId
	
	/**
	f  s bedId=$O(^DHCICUBedEquip(0,"Bed",bedId)) q:bedId=""  d
	.s wardId=+bedId
	.q:wardId=0
	.s wardLocId=$p($g(^PAWARD(+wardId)),"^",5)
	.q:wardLocId=""
	.s PLIST(wardLocId)=wardLocId
	.w wardLocId_","
	*/
	w !
	// 循环执行每一个科室
	m ^TMPICUDEBUG("ConfirmCollectData","locId")=PLIST
	set locId=""
	f  s locId=$O(PLIST(locId)) q:locId=""  d
	.w "locId:"_locId,!
	.
	.f i=1:1:count  d
	..w "Confirm:"_$ztime((from+i)*3600-1)
	..;b "Confirm"
	..s retStr=..ConfirmSingleCollectData("",date,(from+i)*3600,locId)
	..
	.w !
	q "0"
}

/// 计算评分
/// date:日期
/// hour:小时数，如上午9点为"9"，下午3点为"15"
/// ifPerHour是否每小时执行（非24小时）
ClassMethod ProcessScore(date, iDate, hour, locId, ifPerHour = 0)
{
	i date'=+date s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	s $ZT="ERROR"
	s rStr1=##class(web.DHCCLScore).AutoAddScoreOrder(date-1,hour*3600,date,hour*3600,"",locId,"APACHEII","APACHEII")
	s rStr2=##class(web.DHCCLScore).AutoAddScoreOrder(date-1,hour*3600,date,hour*3600,"",locId,"SOFA","SOFA","",0,ifPerHour)
	s ^DHCANICUDEBUG("Score",iDate,hour,locId,232)=$zd($p($h,",",1),3)_" "_$zt($p($h,",",2))_":"_rStr1
	s ^DHCANICUDEBUG("Score",iDate,hour,locId,233)=$zd($p($h,",",1),3)_" "_$zt($p($h,",",2))_":"_rStr2
	q ""
ERROR
	s logDate=+$h
	s logTime=$p($h,",",2)
	s loDate=##class(web.DHCClinicCom).ConvertToDateH(logDate)
	s logTime=##class(web.DHCClinicCom).ConvertToTimeH(logTime)
	s ^DHCANICUDEBUG("Score",logDate,logTime,"Err")=locId_" "_$ZE_"  "_$zd(+$h)_" "_$zt($p($h,",",2))
	q ""
}

ClassMethod ClearCollectDataByLocId(dstLocId, days, isDebug = "Y")
{
	// d ##class(web.DHCICUOrder).ClearCollectDataByLocId(33,0,"Y")
	s date=$p($h,",",1)-days
	s time=$p($h,",",2)
	s icuaId=0
	f  s icuaId=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId)) q:icuaId=""  d
	.q:'$d(^DHCICUArrange(icuaId))
	.s itemStr=^DHCICUArrange(icuaId)
	.s bedId=$p(itemStr,"^",4)
	.q:bedId=""
	.s locId=$p(bedId,"||",1)
	.i dstLocId=locId d
	..;删除数据
	..s bedId=$p(^DHCICUArrange(icuaId),"^",4)
	..s wardDesc=$p(^PAWARD($p(bedId,"||",1)),"^",2)
	..s ^DHCANICUDEBUG("DelDevData",date,time,icuaId)=$zdate($p($h,",",1))_":"_wardDesc_" "_bedId
	..i isDebug="N" d
	...&SQL(delete from DHC_ICU_CollectData where ICUCD_Parref=:icuaId and ICUCD_StartDate=:date)
	..e  d
	...;w "Date:"_$zd(date)_",icuaId:"_icuaId,!
}

ClassMethod GetDoseSpeed(icuoId, patWeight = "", icucriDataField = "", ifWeightDose = "0") As %String
{
	q:+icuoId=0 ""
	s value=""
	i (icucriDataField="") d
		.s icucriId=$p($g(^DHCICUOrder(icuoId)),"^",2)
		.q:icucriId=""
		.s icucriDataField=$p($g(^DHCICUC("RecordItem",icucriId)),"^",24)
	//w icucriDataField,!
	i (icucriDataField="DoseSpeed") d
		.s tmpValue=$p(^DHCICUOrder(icuoId),"^",19)*$p(^DHCICUOrder(icuoId),"^",13)
		.;w tmpValue,"\"_$p(^DHCICUOrder(icuoId),"^",19)_"\"_$p(^DHCICUOrder(icuoId),"^",13),!
		.s sUnitId=$p(^DHCICUOrder(icuoId),"^",20)
		.i sUnitId="" w "sUnitId="_sUnitId,"/"_(+^DHCICUOrder(icuoId)),"/"_icuoId,!
		.q:sUnitId<1
		.q:+$p(^DHCICUC("SUnit",sUnitId),"^",5)=0
		.s value=(tmpValue/$p(^DHCICUC("SUnit",sUnitId),"^",5))*$p(^DHCICUC("SUnit",sUnitId),"^",8)
		.//w value_" value\"_sUnitId_"\"_^DHCICUC("SUnit",sUnitId),!
		.s uomId=$p(^DHCICUOrder(icuoId),"^",12)
		.//i uomId="" d
			.//.s oeoreId=$p(^DHCICUOrder(icuoId),"^",3)
			.//.w "oeoreId="_oeoreId,!
			.//.q:oeoreId=""
			.//.s oeordId=+oeoreId
			.//.s oeoriSub=$p(oeoreId,"||",2)
			.//.s unitUomId=$p($g(^OEORD(oeordId,"I",+oeoriSub,2)),"^",3)
			.//.w unitUomId,!
		.
		.;w uomId_" uomId\"_$p(^DHCICUC("SUnit",sUnitId),"^",4),!
		.i uomId'=$p(^DHCICUC("SUnit",sUnitId),"^",4) d //单位不同的换算
			..s baseSUnitId=$p(^DHCICUC("SUnit",sUnitId),"^",7)
			..s tmpSUnitId=0,isFind=0
			..f  s tmpSUnitId=$o(^DHCICUC("SUnit",tmpSUnitId)) q:(tmpSUnitId="")!(isFind)  d
				...q:$p(^DHCICUC("SUnit",tmpSUnitId),"^",7)'=baseSUnitId
				...q:+$p(^DHCICUC("SUnit",tmpSUnitId),"^",8)=0
				...i uomId'=$p(^DHCICUC("SUnit",tmpSUnitId),"^",4) d
					....s value=value*$p(^DHCICUC("SUnit",tmpSUnitId),"^",8)
					....//w "findValue="_value,"\"_^DHCICUC("SUnit",tmpSUnitId),!
					....s isFind=1
		.i patWeight="" d
			..s icuaId=+^DHCICUOrder(icuoId)
			..s patWeight=$p($g(^DHCICUArrange(icuaId)),"^",25)
		.i (patWeight>0)&($p(^DHCICUC("SUnit",sUnitId),"^",3)["W") d
			..s value=value/patWeight
		.e  d
			..i ifWeightDose s value=value/patWeight
		.//w "patWeight="_patWeight_"\"_value,!
		.i $l($p(value,".",2))>3 s value=$fn(value,"",3)
		.i value<0.000001 s value=""
		.i $p(value,".")="" s value=0_value
	q value
}

ClassMethod GetArcimCodeByIcuoId(icuoId) As %String
{
	q:'$d(^DHCICUOrder(icuoId)) ""
	s oeoreId=$p(^DHCICUOrder(icuoId),"^",3)
	q:oeoreId="" ""
	s oeordId=+$p(oeoreId,"||",1)
	s oeoriSub=+$p(oeoreId,"||",2)
    s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
    q:arcimId=""
    q $p($g(^ARCIM($p(arcimId,"||",1),$p(arcimId,"||",2),1)),"^",1)
}

/// 根据数据定义取值：dataField:"DoseSpeed"和"DateTime"不是原有字段
ClassMethod GetRecordValueSingle(icuoId, dataField = "", patWeight = "", needNote = "", needOeoriNote = "")
{
	q:'$d(^DHCICUOrder(icuoId)) ""
	i (dataField="")!("^Note^Qty^DoseSpeed^Volume^Speed^Concentration^DateTime^"'[("^"_dataField_"^")) d
		.s icucriId=$p(^DHCICUOrder(icuoId),"^",2)
		.i icucriId="" s ^tmpIcuErrorData("nullComOrd",icuoId)=""
		.q:icucriId=""
		.s dataField=$p($g(^DHCICUC("RecordItem",icucriId)),"^",24)
	//w dataField,!
	s curNote=$p(^DHCICUOrder(icuoId),"^",10)
	q:(dataField="Note")&(needNote="") curNote
	q:(dataField="Note")&((needNote'="")&(("^"_needNote_"^")[("^"_curNote_"^"))) curNote
	q:(dataField="Qty") $p(^DHCICUOrder(icuoId),"^",11)
	i (dataField="DoseSpeed") d
		.s doseSpeed=""
		.s icuoOeoriDr=$p($g(^DHCICUOrder(icuoId)),"^",3)
		.s oeordId=+icuoOeoriDr
		.s oeoriSub=$p(icuoOeoriDr,"||",2)
		.;s ^tmpicumfc(icuoId)=icuoOeoriDr_"/"_needOeoriNote_"/"_$g(^OEORD(oeordId,"I",+oeoriSub,"DEP",1))
		.q:oeordId=0
		.s oriNote=$g(^OEORD(oeordId,"I",+oeoriSub,"DEP",1))
		.//w oriNote_" need:"_needOeoriNote,!
		.q:(needOeoriNote'="")&&(("^"_needOeoriNote_"^")'[("^"_oriNote_"^"))
		.s doseSpeed=$p(^DHCICUOrder(icuoId),"^",40)
		.i doseSpeed="" s doseSpeed=##class(web.DHCICUOrder).GetDoseSpeed(icuoId,patWeight,"DoseSpeed")
	q:(dataField="DoseSpeed") doseSpeed
	q:(dataField="Volume") $p(^DHCICUOrder(icuoId),"^",28)
	q:(dataField="Speed") $p(^DHCICUOrder(icuoId),"^",19)
	q:(dataField="Concentration") $p(^DHCICUOrder(icuoId),"^",13)
	q:(dataField="DateTime") $zd($p(^DHCICUOrder(icuoId),"^",5),3)_" "_$zt($p(^DHCICUOrder(icuoId),"^",6))
	q ""
}

/// 取数据，type:Min最低值,Max最高值,First第一个值,MinMax最低值^最高值,Exact最接近exactDate,exactTime的值 Times数据存在次数,dayTimes天次(一天最多一次)
/// dateField:"DateTime", 附加时间。
/// w ##class(web.DHCICUOrder).GetRecordValue(2240,5330,$h,28800,$h,57600,"Exact",$h,"11:20")
/// w ##class(web.DHCICUOrder).GetRecordValue(9051,5330,63971,18000,63971,18000,"First","","")
ClassMethod GetRecordValue(icuaId, icucriId, fromDate, fromTime, toDate, toTime, type = "", exactDate = "", exactTime = "", oeoriNote = "", dataField = "", refIcucriId = "", refValue = "", needNote = "", fromQtyValue = "", toQtyValue = "", ARCIMRowIdStr = "") As %String
{
	q:icuaId="" ""
	q:icucriId="" ""
	k ^TMPICU("RecordValue",$j)
	q:'$d(^DHCICUC("RecordItem"))="" ""
	i icucriId'=+icucriId s icucriId=##class(web.DHCICUCom).GetIcuriIdByCode(icucriId)	
	q:icucriId="" ""
	s icucriDataField=$p($g(^DHCICUC("RecordItem",icucriId)),"^",24)	
	q:icucriDataField="" ""
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s fromTime=##class(web.DHCClinicCom).ConvertToTimeH(fromTime)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	s toTime=##class(web.DHCClinicCom).ConvertToTimeH(toTime)
	
	s exactDate=##class(web.DHCClinicCom).ConvertToDateH(exactDate,"")
	s exactTime=##class(web.DHCClinicCom).ConvertToTimeH(exactTime,"")
	s minQty="",maxQty="",value="",sumQty="",touchQty="",timesInt=0,averageQty="",DescQty=""
	s userId="",maxUserId="",minUserId=""
	s baseIcuoId="",ifQuit=0,preDate="",preTime="",preDeparture="",curDeparture=""
	s maxDate=0,dayTimes=0,valueDateTime="",minDateTime="",maxDateTime="",lastDate=0
	s icuoRemarks=""
	s date=fromDate-1
	s findRecordId="",valueDateTime="",minDateTime="",maxDateTime=""
	;w "From:",$zd(fromDate)," ",$zt(fromTime),"date:",$zd(exactDate)," time:",$zt(exactTime)," recordId:",icucriId
	f  s date=$o(^DHCICUOrder(0,"RecordItem",icucriId,date)) q:(date="")!(date>toDate)!(ifQuit)  d
		.//w "date=",date,"/"_"toDate="_toDate,!
		.s time=""
		.;b ;zui
		.//w icucriId_"/"_date_"/"_fromTime_"/"_toTime,!
		.f  s time=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time)) q:(time="")!(ifQuit)  d
			..q:(date=fromDate)&(time<fromTime)
			..q:(date=toDate)&(time>toTime)  //打开之前屏蔽，参与结束日期和时间过滤 mfc 20180531
			..s ifRefQuit=1
			..
			..i refIcucriId'="" d
				...;w date,"/"_time,!
				...s refIcuoId="",curRefValue=""
				...f  s refIcuoId=$o(^DHCICUOrder(0,"RecordItem",refIcucriId,date,icuaId,time,refIcuoId)) q:(refIcuoId="")  d
					....q:'$d(^DHCICUOrder(refIcuoId))
					....q:"ICD"[$p(^DHCICUOrder(refIcuoId),"^",25)
					....;w refIcuoId,!
					....s curRefValue=..GetRecordValueSingle(refIcuoId)
					....i curRefValue=refValue s ifRefQuit=0
				...//w refIcucriId_"/"_curRefValue,"/"_ifRefQuit,! b
			..q:(refIcucriId'="")&(ifRefQuit)
			..s icuoId=""
			..f  s icuoId=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time,icuoId)) q:(icuoId="")!(ifQuit)  d
				...q:'$d(^DHCICUOrder(icuoId))
				...
				...s icuoRemarks=$p(^DHCICUOrder(icuoId),"^",37)
				...q:"ICD"[$p(^DHCICUOrder(icuoId),"^",25)
				...;q:(arcimCodeStr'="")&&(("^"_arcimCodeStr_"^")'[("^"_..GetArcimCodeByIcuoId(icuoId)_"^"))
				...;i arcimCodeStr'="" w arcimCodeStr_"/compare "_..GetArcimCodeByIcuoId(icuoId),!
				...s userId=$p(^DHCICUOrder(icuoId),"^",4)
				...//w "execDate="_exactDate,!
				...i (exactDate'="")&(type="Exact") d
					....s preDeparture=##class(web.DHCClinicCom).CalculateDuration(preDate,preTime,exactDate,exactTime)
					....s curDeparture=##class(web.DHCClinicCom).CalculateDuration(date,time,exactDate,exactTime)
					....i ($zabs(preDeparture)<$zabs(curDeparture)) s ifQuit=1
				...;b ;02
				...q:ifQuit
				...s icupiCode=""
				...i oeoriNote'="" d
					....s icupiId=$p(^DHCICUOrder(icuoId),"^",38)
					....q:icupiId=""
					....;w icupiId_"/",!
					....s icupiCode=$p(^DHCICUPara(+icupiId,"I",+$p(icupiId,"||",2)),"^",13)
				...//w icupiCode,!
				...//i icuaId=20032 w icucriId_"/"_date_"/"_icuaId_"/"_time,!
				...//w icupiCode_"/"_oeoriNote
				...s isIncludedOeoriNote=1
				...i oeoriNote'="" d
					....f i=1:1:$l(oeoriNote,"^") d
						.....s curOeoriNote=$p(oeoriNote,"^",i)
						.....i ((","_icupiCode_",")[((","_curOeoriNote_","))) s isIncludedOeoriNote=0
				...q:(icupiCode'="")&(oeoriNote'="")&(isIncludedOeoriNote)
				...s value=..GetRecordValueSingle(icuoId,dataField,"",needNote)
				...//w "value="_value,!
				...q:value=""
				...i sumQty="" s sumQty=value
				...e  s sumQty=sumQty+value
				...s timesInt=timesInt+1
				...s averageQty=$FN((sumQty/timesInt),"",2) //平均值,按平均值比较大小
				...//w sumQty,"/"_value_"int="_timesInt_"/"_averageQty,!
				...i ((("^Qty^Volume^DoseSpeed^")[("^"_icucriDataField_"^"))&(((fromQtyValue'="")&&(value<fromQtyValue))!((toQtyValue'="")&&(value>toQtyValue)))) s value="" q
				...i type="All" d
				    ....;b ;"All"
					....s ^TMPICU("RecordValue",$j,date_","_time,icuoId)=value //传值到主窗口
					....s ^TMPICUO("RecordValue",$j,date_","_time,icuoId)=value_"@"_icuoId //传值和ID到主窗口
				    ....i icuoRemarks'=""  s ^TMPICU("RecordValue",$j,date_","_time,icuoId)=value_"-"_icuoRemarks
				    ....i icuoRemarks'=""  s ^TMPICUO("RecordValue",$j,date_","_time,icuoId)=value_"-"_icuoRemarks_"@"_icuoId
				...i type="DayTimes" d
					....i maxDate<date s maxDate=date,dayTimes=dayTimes+1
				...s valueDateTime=$zd(date,3)_" "_$zt(time,2)
				...s findRecordId=icuoId
				...i (dataField="")&(type'="Times")&&(icucriDataField="Note")&(type'="touchQty")&(type'="averageQty")&(type'="DayTimes")&(type'="All")&(type'="Exact") s ifQuit=1  //20150408 whl Add 统计数据存在的个数   //2010201 update LYN  Exact条件判断
				...i (type="First")||(type="FirstDT") s ifQuit=1
				...i (type="Yes")!(type="No") s ifQuit=1
				...s preDate=date,preTime=time
				...i type="Description" d
					....s icupiId=$p(^DHCICUOrder(icuoId),"^",38)
					....q:icupiId=""
					....s desc=$p(^DHCICUPara(+icupiId,"I",+$p(icupiId,"||",2)),"^",14)
					....i DescQty="" s DescQty=value_" "_desc
					....e  s DescQty=DescQty_"#"_value_" "_desc	
					....b ;02
				...i (type="touchQty") d //获取连续值
				....i (date=lastDate) d
				.....i touchQty="" s touchQty=value_" "_$zt(time,2)
				.....e  s touchQty=touchQty_"#"_value_" "_$zt(time,2)
				....e  d
				.....i touchQty="" s touchQty=value_" "_valueDateTime
				.....e  s touchQty=touchQty_"#"_value_" "_valueDateTime
				...s lastDate=date				
				...//i $p(^DHCICUOrder(baseIcuoId),"^",10)=baseValue s ifQuit=1
				...i ((icucriDataField="Qty")!(icucriDataField="DoseSpeed"))&((minQty="")!(value<minQty)) d
					....s minQty=value,minDateTime=$zd(date,3)_" "_$zt(time,2),minUserId=userId
				...i ((icucriDataField="Qty")!(icucriDataField="DoseSpeed"))&((maxQty="")!(value>maxQty)) d
					....s maxQty=value,maxDateTime=$zd(date,3)_" "_$zt(time,2),maxUserId=userId
				...;w "min="_minQty_" max="_maxQty,!
				... ;b ;li end
	//w "findRecordId:"+findRecordId,!
	//w "daytimes="_dayTimes,"/"_value,!
	//q:type="All"&(dataField="DateTime") allValue	
	;b ;liyinuo
	q:type="Times" timesInt  //20150408 whl Add 返回统计数据存在的个数
	q:(type="Description")&&(value'="") DescQty //update by lyn
	q:type="DayTimes" dayTimes
	q:(dataField="")&(icucriDataField="Note")&(type'="touchQty")&(type'="averageQty")&(type'="Average") value
	i dataField="AddDateTime" d //
		.s value=value_"~"_valueDateTime
		.s minQty=minQty_"~"_minDateTime
		.s maxQty=maxQty_"~"_maxDateTime
	i dataField="DateTime" d
		.s value=valueDateTime
		.s minQty=minDateTime
		.s maxQty=maxDateTime
	i dataField="UserId" d
		.s value=userId
		.s minQty=minUserId
		.s maxQty=maxUserId
		.//w userId_"/"_minUserId_"/"_maxUserId,!
	i dataField="IcuoIdAndMinV" d
		.s minQty=findRecordId_"#"_minQty
		.s value=findRecordId_"#"_value_"#"_valueDateTime
	q:type="First" value
	q:type="Min" minQty
	q:type="Max" maxQty
	q:type="MinMax" minQty_"#"_maxQty	
	q:type="Exact" value
	q:type="Sum" sumQty
	q:type="touchQty" touchQty	
	q:(type="averageQty")!(type="Average") averageQty
	q:(type="FirstDT")&&(value'="") value_"~"_valueDateTime
	q:(type="MinDT")&&(value'="") minQty_"~"_minDateTime
	q:(type="MaxDT")&&(value'="") maxQty_"~"_maxDateTime
	q:(type="MinMaxDT")&&(value'="") minQty_"~"_minDateTime_"#"_maxQty_"~"_maxDateTime
	i (type="Yes")&&(value'="") s value="是"
	e  i (type="Yes")&&(value="") s value="否"
	i (type="No")&&(value'="") s value="否"
	e  i (type="No")&&(value="") s value="是"
	q value
}

/// w ##class(web.DHCICUOrder).CalculateRecordValue(21182,5345,64861,43696,64862,52200,"DurationMax","","","","AddDateTime","","","",90,9999)
ClassMethod CalculateRecordValue(icuaId, icucriId, fromDate, fromTime, toDate, toTime, type = "", needOeoriNote = "", needNote = "", fromQtyValue = "", toQtyValue = "", interval = "") As %String
{
	w "CalculateRecordValue ",!
	q:icuaId="" ""
	q:icucriId="" ""
	q:'$d(^DHCICUC("RecordItem"))="" ""
	i icucriId'=+icucriId s icucriId=##class(web.DHCICUCom).GetIcuriIdByCode(icucriId)	
	//w icucriId,"/"
	q:icucriId="" ""
	s icucriDataField=$p($g(^DHCICUC("RecordItem",icucriId)),"^",24)	
	//w icucriDataField,!
	q:icucriDataField="" ""
	q:((icucriDataField'="Qty")&(icucriDataField'="DoseSpeed")) ""
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s fromTime=##class(web.DHCClinicCom).ConvertToTimeH(fromTime)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	s toTime=##class(web.DHCClinicCom).ConvertToTimeH(toTime)
	
	s preDate="",preTime="",value="",valueStr="",maxQty="",minQty=""
	s date=fromDate-1
	s findRecordId="",valueDateTime="",minDateTime="",maxDateTime=""
	f  s date=$o(^DHCICUOrder(0,"RecordItem",icucriId,date)) q:(date="")!(date>toDate)  d
		.s time=""
		.f  s time=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time)) q:(time="")  d
			..q:(date=fromDate)&(time<fromTime)
			..q:(date=toDate)&(time>toTime)
			..s icuoId=""
			..f  s icuoId=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time,icuoId)) q:(icuoId="")  d
				...q:'$d(^DHCICUOrder(icuoId))
				...q:"ICD"[$p(^DHCICUOrder(icuoId),"^",25)
				...w "  "_##Class(DHCClinicCom).CalculateDuration(preDate,preTime,date,time,"M"),!
				...q:(interval'="")&&(preDate'="")&&(##Class(DHCClinicCom).CalculateDuration(preDate,preTime,date,time,"M")<interval)
				...s value=..GetRecordValueSingle(icuoId,icucriDataField,"",needNote,needOeoriNote)
				...q:value=""
				...q:("^DurationMin^DurationMax^"[("^"_type_"^"))&&((fromQtyValue'="")&&(value<fromQtyValue)) //原始值比较
				...q:("^DurationMin^DurationMax^"[("^"_type_"^"))&&((toQtyValue'="")&&(value>toQtyValue)) //原始值比较
				...
				...i (minQty="")!(value<minQty) s minQty=value
				...i (maxQty="")!(value>maxQty) s maxQty=value
				...i valueStr'="" s valueStr=valueStr_"#"
				...s valueStr=valueStr_value
				...s preDate=date,preTime=time
				...//
				...
	w valueStr,!
	q:("^DurationMin^DurationMax^"[("^"_type_"^"))&($l(valueStr,"#")<2) ""
	q:("^DurationMin^DurationMax^"[("^"_type_"^")) valueStr
	
	//q:(type="MaxDiff") valueStr
	s diff=maxQty-minQty
	q:(type="MaxDiff")&&((fromQtyValue'="")&&(diff<fromQtyValue)) ""
	q:(type="MaxDiff")&&((toQtyValue'="")&&(value>toQtyValue)) ""
	q:(type="MaxDiff") diff
	
	s value=..CalculateList(valueStr,type)
	
	q value
}

/// valueStr:以"#"分割的数值，type：DecreaseRatio，IncreaseRatio
ClassMethod CalculateList(valueStr, type) As %String
{
	//w valueStr,!
	s value="",incRatio="",decRatio="",minValue="",postMaxValue="",maxValue="",postMinValue=""
	s sum="",count="",average=""
	i ("^IncreaseRatio^DecreaseRatio^Average^"[("^"_type_"^")) d
		.f i=1:1:$l(valueStr,"#") d
	    	..s curValue=$p(valueStr,"#",i)
	    	..q:+curValue=0
	    	..s sum=sum+curValue,count=count+1
	    	..i +minValue=0 s minValue=curValue,maxValue=curValue // q
	    	..i (minValue="")!(curValue<minValue) d //小于最小值
	    		...s minValue=curValue,postMinValue=value
	    		...s postMaxValue="" //后续极小值置空
	    		...//w "min"
	    	..e  i (maxValue="")!(curValue>maxValue) d //大于最大值
	    		...s maxValue=curValue,postMaxValue=curValue
	    		...s postMinValue=""
	    		...//w "max"
	    	..//w minValue_"/"_maxValue_"/"_curValue_"/"_postMinValue_"/"_postMaxValue,!
	    	..s curIncRatio=curValue/minValue
	    	..s curDecRatio=curValue/maxValue
	    	..i (decRatio="")!(curDecRatio<decRatio) s decRatio=curDecRatio
	    	..i (incRatio="")!(curIncRatio>incRatio) s incRatio=curIncRatio
	    	..
	//w decRatio_"/"_incRatio,!
	//w $fn(100*(incRatio-1),"",2)_"%",! b
	i count>0 s average=$fn(sum/count,"",2)
	q:(type="DecreaseRatio") $fn(100*(1-decRatio),"",2)_"%"
	q:(type="IncreaseRatio") $fn(100*(incRatio-1),"",2)_"%"
	q:(type="Average") average
	q ""
}

/// 20140721
ClassMethod GetLabRec(OeordID)
{
	s ordId=$p(OeordID,"||",1)
 	s ordsub=$p(OeordID,"||",2)
 	q:'($l(ordId)!$l(ordsub)) ""
 	//200019||A020||1
 	//200014||A020||1
 	s ordInfo=$G(^OEORD(ordId,"I",ordsub,3)) 
 	s labinfo=$p(ordInfo,"^",35)
 	s labno=$p(labinfo,"||",1)	;检验号
 	s ts=$p(labinfo,"||",2)	;
 	s tscnt=$p(labinfo,"||",3)	
 	s tc=$o(^TEPI(labno,1,ts,tscnt,"DATA",""),-1) ;检验项目对应代码Id
 	s NationLong=$p(^TTAB("TC",tc),"\",18)
 	s comOrdId=$o(^DHCICUC("RecordItem",0,"Code",NationLong,""),-1)
}

/// 通过时间点和范围查找数据
/// icuaId:
/// icucriId:常用医嘱ID
/// date,time:日期时间
/// scope:范围，单位：分钟
/// type:查找方式，默认：最接近查找时间的值，
/// 		其他：First:第一个值，Min:最小值，Max:最大值，MinMax:最大最小值，
/// 
ClassMethod GetRecordValueByScope(icuaId, icucriId, date, time, scope = 20, type = "Exact") As %String
{
	// s icuaId=2240
	// s icucriId=5330
	// s date="2014-03-01"
	// s time=22*3600
	// w ##class(web.DHCICUCom).GetRecordValueByScope(icuaId, icucriId, date,time)
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	
	s scope=scope*60
	s dateSec=3600*24
	s startDateTime=((date*dateSec)+time)-scope
	s endDateTime=((date*dateSec)+time)+scope
	
	s fromDate=startDateTime\dateSec
	s fromTime=startDateTime#dateSec
	s toDate=endDateTime\dateSec
	s toTime=endDateTime#dateSec
	
	// w "From:",$zd(fromDate)," ",$zt(fromTime),!
	// w "To:",$zd(toDate)," ",$zt(toTime),!
	
	s retStr=..GetRecordValue(icuaId, icucriId, fromDate, fromTime, toDate, toTime, type, date, time)
	q retStr
}

/// 计算持续时间，
/// 
/// 返回：持续日期、小时、分钟、次数
/// w ##class(web.DHCICUOrder).GetRecordDuration(2124,5347,$h-10,0,$h,0,60,"压力支持/CPAP")
ClassMethod GetRecordDuration(icuaId, icucriId, fromDate, fromTime, toDate, toTime, minInterval, note, oeoriNote = "", minQty = "", maxQty = "") As %String
{
	q:icuaId="" ""
	q:icucriId="" ""
	q:'$d(^DHCICUC("RecordItem"))="" ""
	s icucriDataField=$p($g(^DHCICUC("RecordItem",icucriId)),"^",24)
	q:icucriDataField="" ""
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s fromTime=##class(web.DHCClinicCom).ConvertToTimeH(fromTime)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	s toTime=##class(web.DHCClinicCom).ConvertToTimeH(toTime)
	
	s icupiIdList=""
	i oeoriNote'="" d
		.f i=1:1:$l(oeoriNote,"^") d
			..s curOeoriNote=$p(oeoriNote,"^",i)
			..s icupId=$o(^DHCICUPara(0,"ICUA",icuaId,""))
			..q:icupId=""
			..s icupiSub=10000
			..f  s icupiSub=$o(^DHCICUPara(icupId,"I",icupiSub)) q:icupiSub=""  d
				...q:icucriId'=$p(^DHCICUPara(icupId,"I",icupiSub),"^",4)
				...i $p(^DHCICUPara(icupId,"I",icupiSub),"^",19)="" s mainIcupiSub=icupiSub
				...//i $p(^DHCICUPara(icupId,"I",icupiSub),"^",19)=(icupId_"||"_mainIcupiSub),$p(^DHCICUPara(icupId,"I",icupiSub),"^",4)=sofaCVSDoseSpeedIcucriId d
				...s icupiCode=$p(^DHCICUPara(icupId,"I",icupiSub),"^",13)
				...i (icupiCode[(","_curOeoriNote)) d
					....s curIcupiId=icupId_"||"_icupiSub
					....s icupiIdList=icupiIdList_"^"
					....s icupiIdList=icupiIdList_curIcupiId
	//w "icupiIdList="_icupiIdList,!
	s duraDay=0,duraHour=0,duraMin=0,times=0
	s ifQuit=0
	s firstDate="",firstTime="",lastDate="",lastTime="" //开始结束时间
	s preDate="",preTime="" //上一有效数据时间
	s date=fromDate-1
	f  s date=$o(^DHCICUOrder(0,"RecordItem",icucriId,date)) q:(date="")!(date>toDate)!(ifQuit)  d
		.s time=""
		.f  s time=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time)) q:(time="")!(ifQuit)  d
			..q:(date=fromDate)&(time<fromTime)
			..q:(date=toDate)&(time>toTime)  //打开之前屏蔽，参与结束日期和时间过滤 mfc 20180531
			..s icuoId=""
			..f  s icuoId=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time,icuoId)) q:(icuoId="")!(ifQuit)  d
				...q:'$d(^DHCICUOrder(icuoId))
				...//w date_" date/time "_time,!
				...q:"ICD"[$p(^DHCICUOrder(icuoId),"^",25)
				...//i $p(^DHCICUOrder(icuoId),"^",10)'="" w $p(^DHCICUOrder(icuoId),"^",10)_"/"_icuoId_"/"_$p(^DHCICUOrder(icuoId),"^",34),!
				...q:(note'="")&($l(note,"^")>1)&(("^"_note_"^")'[("^"_$p(^DHCICUOrder(icuoId),"^",10)_"^")) //add mfc 添加多选项或者筛选判断
				...q:(note'="")&($l(note,"^")=1)&($p(^DHCICUOrder(icuoId),"^",10)'[note)
				...;q:(note'="")&($p(^DHCICUOrder(icuoId),"^",10)'[note)
				...
				...q:(oeoriNote'="")&(("^"_icupiIdList_"^")'[("^"_$p(^DHCICUOrder(icuoId),"^",38)_"^"))
				...
				...s value="",ifInRange=1
				...i (minQty'="")&(maxQty'="") s value=##class(web.DHCICUOrder).GetRecordValueSingle(icuoId,icucriDataField)
				...i (minQty'="")&(maxQty'="")&((value<minQty)!(value>maxQty)) s ifInRange=0
				...
				...//w " "_date_" date/time "_time,"/"_icucriId_"/"_icuoId_"/"_ifInRange,!
				...i ifInRange,firstDate="" s firstDate=date,firstTime=time,preDate=date,preTime=time
				...//i ifNewDuration s firstDate=date,firstTime=time,preDate=date,preTime=time,ifNewDuration=0 q
				...q:firstDate="" 			
				...s intervalMin=##class(web.DHCClinicCom).CalculateDuration(preDate,preTime,date,time,"M")
				...s lastDate=date,lastTime=time
				...//w " "_firstDate_"^"_firstTime_"^"_preDate_"^"_preTime_"^"_date_"^"_time_"^"_lastDate_"^"_lastTime,!
				...//w intervalMin_"/"_$p(^DHCICUOrder(icuoId),"^",10),!
				...i (intervalMin>minInterval)!('ifInRange) d //有中断数据时计算
					....s tmpDuraMin=duraMin
					....i ifInRange d
						.....s duraMin=duraMin+##class(web.DHCClinicCom).CalculateDuration(firstDate,firstTime,preDate,preTime,"M")
						.....//w $zd(firstDate,3)_"/"_$zt(firstTime),"/"_$zd(preDate,3),"/"_$zt(preTime)_"/"_tmpDuraMin_"/"_duraMin,"/"_(duraMin-tmpDuraMin),!
					....e  d
						.....s duraMin=duraMin+##class(web.DHCClinicCom).CalculateDuration(firstDate,firstTime,date,time,"M")
						.....//w $zd(firstDate,3)_"/"_$zt(firstTime),"/"_$zd(date,3),"/"_$zt(time)_"/"_tmpDuraMin_"/"_duraMin,"/"_(duraMin-tmpDuraMin),!
					....//i (icuaId=9601) b  //add duraMin
					....s times=times+1
					....s duraDay=duraDay+date-firstDate
					....i ifInRange d
						.....s firstDate=date,firstTime=time,preDate=date,preTime=time
					....e  d
						.....s firstDate="",firstTime="",preDate="",preTime=""
				...e  s preDate=date,preTime=time //更新上一有效数据
	i preDate>0 d
		.q:firstDate=""
		.q:lastDate=""
		.s duraMin=duraMin+##class(web.DHCClinicCom).CalculateDuration(firstDate,firstTime,lastDate,lastTime,"M")
		.//w "last:"_$zd(firstDate,3)_"/"_$zt(firstTime),"/"_$zd(preDate,3),"/"_$zt(preTime)_"/"_tmpDuraMin_"/"_duraMin,"/"_(duraMin-tmpDuraMin),!
		.//i (icuaId=9601) b  //last duraMin
		.s times=times+1
		.s duraDay=duraDay+lastDate-firstDate
	s duraHour=(duraMin+30)\60
	q duraDay_"^"_duraHour_"^"_duraMin_"^"_times
}

/// 计算持续时间，
/// 
/// 返回：持续日期、小时、分钟、次数
/// w ##class(web.DHCICUOrder).GetCatheterDuration(2124,5949,$h-100,0,$h,0,5953,5961,"63192.4212")
ClassMethod GetCatheterDuration(icuaId, icucriId, fromDate, fromTime, toDate, toTime, inCathIcucriId = "", exCathIcucriId = "", outDateTime = "") As %String
{
	q:icuaId="" ""
	q:(icucriId="")!(inCathIcucriId="")!(exCathIcucriId="") ""
	q:'$d(^DHCICUC("RecordItem"))="" ""
	s icucriDataField=$p($g(^DHCICUC("RecordItem",icucriId)),"^",24)
	q:icucriDataField="" ""
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s fromTime=##class(web.DHCClinicCom).ConvertToTimeH(fromTime)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	s toTime=##class(web.DHCClinicCom).ConvertToTimeH(toTime)
	
	s icupId=$o(^DHCICUPara(0,"ICUA",icuaId,""))
	q:icupId="" ""
	s icupiSub=0,isQuit=0
	s mainIcupiId=0,inCathIcupiId="",exCathIcupiId=""
	f  s icupiSub=$o(^DHCICUPara(icupId,"I",icupiSub)) q:(icupiSub="")!(isQuit)  d //子项到主项的映射
		.s icupiStr=^DHCICUPara(icupId,"I",icupiSub)
		.i $p(icupiStr,"^",4)[icucriId s mainIcupiId=icupId_"||"_icupiSub w "main"_mainIcupiId,!
		.q:mainIcupiId=""
		.i ($p(icupiStr,"^",19)=mainIcupiId)&($p(icupiStr,"^",4)=inCathIcucriId) s inCathIcupiId=icupId_"||"_icupiSub w inCathIcupiId,!
		.i ($p(icupiStr,"^",19)=mainIcupiId)&($p(icupiStr,"^",4)=exCathIcucriId) s exCathIcupiId=icupId_"||"_icupiSub w exCathIcupiId,!
		.i inCathIcupiId'="",exCathIcupiId'="" s isQuit=1
		.
	w icupId_"^"_mainIcupiId_"^"_inCathIcupiId_"^"_exCathIcupiId,!
	
	s duraDay=0,duraHour=0,duraMin=0,times=0
	s ifNewDuration=1,firstDate="",firstTime="",preDate="",preTime="",lastDate="",lastTime=""
	s date=fromDate-1
	f  s date=$o(^DHCICUOrder(0,"RecordItem",inCathIcucriId,date)) q:(date="")!(date>toDate)  d
		.s time=""
		.f  s time=$o(^DHCICUOrder(0,"RecordItem",inCathIcucriId,date,icuaId,time)) q:(time="")  d
			..q:(date=fromDate)&(time<fromTime)
			..q:(date=toDate)&(time>toTime)
			..s icuoId=""
			..f  s icuoId=$o(^DHCICUOrder(0,"RecordItem",inCathIcucriId,date,icuaId,time,icuoId)) q:(icuoId="")  d
				...q:'$d(^DHCICUOrder(icuoId))
				...q:$p(^DHCICUOrder(icuoId),"^",38)'=inCathIcupiId
				...q:"ICD"[$p(^DHCICUOrder(icuoId),"^",25)
				...s inCathDateTime=$p(^DHCICUOrder(icuoId),"^",10)
				...s inCathDate=##class(web.DHCClinicCom).ConvertToDateH($p(inCathDateTime," "))
				...s inCathTime=##class(web.DHCClinicCom).ConvertToTimeH($p(inCathDateTime," ",2))
				...s catheter(inCathDate*100000+inCathTime)=""
				...;i (icuaId="1816")&&(icucriId="5949") w inCathDate_",",inCathTime,!
		.//w "Ex",!
		.s time=""
		.f  s time=$o(^DHCICUOrder(0,"RecordItem",exCathIcucriId,date,icuaId,time)) q:(time="")  d
			..q:(date=fromDate)&(time<fromTime)
			..q:(date=toDate)&(time>toTime)
			..s icuoId=""
			..f  s icuoId=$o(^DHCICUOrder(0,"RecordItem",exCathIcucriId,date,icuaId,time,icuoId)) q:(icuoId="")  d		
				...q:'$d(^DHCICUOrder(icuoId))		
				...q:$p(^DHCICUOrder(icuoId),"^",38)'=exCathIcupiId				
				...q:"ICD"[$p(^DHCICUOrder(icuoId),"^",25)			
				...s exCathDateTime=$p(^DHCICUOrder(icuoId),"^",10)
				...s exCathDate=##class(web.DHCClinicCom).ConvertToDateH($p(exCathDateTime," "))
				...s exCathTime=##class(web.DHCClinicCom).ConvertToTimeH($p(exCathDateTime," ",2))
				...s exCathDTList(exCathDate*100000+exCathTime)=""
				...;w exCathDate_",ex:  ",exCathTime,!
	
	s exCathDT=""
	f  s exCathDT=$o(exCathDTList(exCathDT)) q:exCathDT=""  d
		.s inCathDT=exCathDT
		.f  s inCathDT=$o(catheter(inCathDT),-1) q:inCathDT=""  d
			..q:catheter(inCathDT)'=""
			..s catheter(inCathDT)=exCathDT
			..//w exCathDT_",",catheter(inCathDT),!
	s inCathDT="",duraDay=0,duraMin=0,times=0,preExCathDT="",ExDateValue=0
	f  s inCathDT=$o(catheter(inCathDT)) q:(inCathDT="")!(ExDateValue=1)  d
		.;q:preExCathDT=catheter(inCathDT) //屏蔽此处，添加下面保护判断 20140717
		.q:(preExCathDT'="")&&(preExCathDT=catheter(inCathDT))
		.s inCathDate=inCathDT\100000
		.s inCathTime=inCathDT-(inCathDate*100000)
		.//w catheter(inCathDT)_"|",inCathDT,!
		.s exCathDate=catheter(inCathDT)\100000
		.s exCathTime=catheter(inCathDT)-(exCathDate*100000)
		.;i catheter(inCathDT)="" s exCathDate=+$h,exCathTime=$p($h,",",2) //20140917没有拔管日期获取出院日期
		.i catheter(inCathDT)="" s ExDateValue=1,exCathDate=$p($g(outDateTime),".",1),exCathTime=("."_$p($g(outDateTime),".",2))*100000		
		.;i (icuaId="1816")&&(icucriId="5949") w inCathDate_"/",inCathTime_":",exCathDate,"/"_exCathTime_"/"_outDateTime,!
		.s duraMin=duraMin+##class(web.DHCClinicCom).CalculateDuration(inCathDate,inCathTime,exCathDate,exCathTime,"M")
		.s times=times+1
		.s duraDay=duraDay+exCathDate-inCathDate
		.s preExCathDT=catheter(inCathDT)
	s duraHour=(duraMin+30)\60
	q duraDay_"^"_duraHour_"^"_duraMin_"^"_times
}

/// Creator：      	whl
/// CreatDate：    	2014-03-19
/// Description： 	判断监护记录是否有有效数据
/// Table：        	DHC_ICU_Order
/// Input：        	icuaId
/// Output：       是Y否N
/// Return：       
ClassMethod CheckValidICUAID(icuaId As %String = "") As %String
{
	q:icuaId="" "N"
	q:'$d(^DHCICUArrange(icuaId)) "N"
	//w "in check "
	q:$p($g(^DHCICUArrange(icuaId)),"^",10)="N" "Y"
	q:$p($g(^DHCICUArrange(icuaId)),"^",10)="A" "N"
	//w " continue "
	s height=$p($g(^DHCICUArrange(icuaId)),"^",24) ;身高
	s weight=$p($g(^DHCICUArrange(icuaId)),"^",25) ;体重

    //s residentCtcpDr=$p($g(^DHCICUArrange(icuaId)),"^",28) ;住院医生
	//s attendingCtcpDr=$p($g(^DHCICUArrange(icuaId)),"^",29) ;主治医生
    s isHaveValidOrder="N"
    s isHaveValidIcuaId="N"
    s tmpIcuoId=""
    f  s tmpIcuoId=$o(^DHCICUOrder(0,"Arr",icuaId,tmpIcuoId)) q:(tmpIcuoId="")!(isHaveValidOrder)  d
		.s userId=$p(^DHCICUOrder(tmpIcuoId),"^",4) ;
		.q:userId="" 
		.q:("NE"'[$p(^DHCICUOrder(tmpIcuoId),"^",25)) ;
		.s isHaveValidOrder="Y"
	;i (isHaveValidOrder="Y")&(height'="")&(weight'="")  s isHaveValidIcuaId="Y"
	i (isHaveValidOrder="Y") s isHaveValidIcuaId="Y"   //身高体重未填，取消身高体重判断 20211117 wcj	 
	q isHaveValidIcuaId
}

/// 获取数据列的显示时间(用于判断非整点列)
ClassMethod GetDisplayDateTime(icuaId As %String, startDate As %String, startTime As %String, endDate As %String, endTime As %String, recordCatIdStr As %String) As %String
{
	s result=""
	s startDate=##class(web.DHCANOPCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCANOPCom).ConvertToTimeH(startTime)
	s endDate=##class(web.DHCANOPCom).ConvertToDateH(endDate)
	s endTime=##class(web.DHCANOPCom).ConvertToTimeH(endTime)
	s icuoStartTime="",icuoRowId="",findValidData="N"
	f i=startDate:1:endDate  d
	.f  s icuoStartTime=$o(^DHCICUOrder(0,"SttDateTime",i,icuaId,icuoStartTime)) q:(icuoStartTime="")  d
	..q:((i=startDate)&(icuoStartTime<startTime	))!((i=endDate)&(icuoStartTime>endTime))
	..s findValidData="N"
	..f  s icuoRowId=$o(^DHCICUOrder(0,"SttDateTime",i,icuaId,icuoStartTime,icuoRowId)) q:(icuoRowId="")!(findValidData="Y")  d
	...s editFlag=$p(^DHCICUOrder(icuoRowId),"^",25)
	...q:(editFlag'["NE")
	...s recordCatId=$p(^DHCICUOrder(icuoRowId),"^",16)_"^"
	...q:(recordCatIdStr'="")&(recordCatIdStr'[recordCatId)
	...i (result'="") s result=result_"^"
	...s result=result_##class(web.DHCANOPCom).ConvertToDate(i)_" "_##class(web.DHCANOPCom).ConvertToTime(icuoStartTime)
	...s findValidData="Y"
	
	q result
}

/// 插入筛选数据
ClassMethod SetPredictData(startDate As %String, startTime As %String, endDate As %String, endTime As %String) As %String
{
	//w ##class(web.DHCICUOrder).SetPredictData($h-1,0,$h,0)
	s result="0"
	s startDate=##class(web.DHCANOPCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCANOPCom).ConvertToTimeH(startTime)
	s endDate=##class(web.DHCANOPCom).ConvertToDateH(endDate)
	s endTime=##class(web.DHCANOPCom).ConvertToTimeH(endTime)
	s icuoStartTime="",icuoRowId="",findValidData="N"
	s icucpId=0
	f  s icucpId=$o(^DHCICUCPredict(icucpId)) q:icucpId=""  d
		.s wardLocIdStr=$lg(^DHCICUCPredict(icucpId),3)
		.f i=1:1:$l(wardLocIdStr,"^") d
			..s wardLocId=$p(wardLocIdStr,"^",i)
			..q:wardLocId=""
			..s patList=##class(web.DHCICUCom).FindWardPatient("",wardLocId) //找当前病区病人
			..s wardId=$o(^PAWARD(0,"WARD_LocationDR",wardLocId,0))
			..//s EpisodeID_"/before "_patList,!
			..f j=1:1:$l(patList,"^") d
				...s icuaId=$p($p(patList,"^",j),"|",4)
				...w icuaId,!
			..//s icuaId=$p(patList,"^")
			..//f  s icuaId=$o(^DHCICUOrder(0,"SttDateTime",startDate,icuaId)) q:icuaId=""  d //当天来当天走的？
				...q:'$d(^DHCICUArrange(icuaId))
				...q:+$p($g(^DHCICUArrange(icuaId)),"^",4)'=wardId
				...s curEpisodeID=$p(^DHCICUArrange(icuaId),"^",1)
				...q:curEpisodeID=""
				...q:("^"_patList_"|")[("^"_curEpisodeID_"|")
				...//w icuaId_"\"_curEpisodeID,!
				...s patList=patList_"^"_curEpisodeID_"|"
	q patList
}

/// 自动插入筛查数据
/// 入参：日期、时间
/// startDate:开始日期,startTime:开始时间
/// endDate：评分日期, endTime：评价时间
/// needIcuaId:icuaId
/// needWardLocId:登陆科室
ClassMethod AutoAddPredictOrder(startDate, startTime, endDate, endTime, needIcuaId = "", needWardLocId = "", userId = "", ifDebug = 0) As %String
{
	//w ##class(web.DHCICUOrder).AutoAddPredictOrder($h-25,0,$h+1,0,"","","",1)
	s $ZT="AutoAddPredictOrderError"
	s STX=$c(2)
	s ETX=$c(3)
	s logTime=$p($h,",",2)
	s ^DHCANICUDEBUG("AutoAddPredictOrder",+$h,logTime)=$zd(+$h)_" "_$zt($p($h,",",2))
	s retStr=0
	s startDate=##class(web.DHCANOPCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCANOPCom).ConvertToTimeH(startTime)
	s endDate=##class(web.DHCANOPCom).ConvertToDateH(endDate)
	s endTime=##class(web.DHCANOPCom).ConvertToTimeH(endTime)
	s startDateTime=startDate+((startTime+1)/100000)
	s endDateTime=endDate+((endTime+1)/100000)
	
	f date=startDate:1:endDate d
		.s icuaId=""
		.f  s icuaId=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId)) q:icuaId=""  d
			..q:'$d(^DHCICUArrange(icuaId))
			..q:(needIcuaId'="")&(icuaId'=needIcuaId)
			..//q:+$p($g(^DHCICUArrange(icuaId)),"^",4)'=wardId
			..s icuaIdList(icuaId)=""
	
	s icuoStartTime="",icuoRowId="",findValidData="N"
	k levelList
	s icucpId=0
	f  s icucpId=$o(^DHCICUCPredict(icucpId)) q:icucpId=""  d
		.//q:icucpId=1 //!!??
		.s mainIcucriCode=$lg(^DHCICUCPredict(icucpId),1)
		.s mainIcucriId=$o(^DHCICUC("RecordItem",0,"Code",mainIcucriCode,""))
		.q:mainIcucriId=""
		.
		.s wardLocIdStr=$lg(^DHCICUCPredict(icucpId),3)
		.s icuaId=""
		.f  s icuaId=$o(icuaIdList(icuaId)) q:icuaId=""  d
			..s wardId=+$p($g(^DHCICUArrange(icuaId)),"^",4)
			..s wardLocId=$p(^PAWARD(+wardId),"^",5)
			..//w "icuaId="_icuaId,!
			..q:("^"_wardLocIdStr_"^")'[("^"_wardLocId_"^")
			..q:'$d(^DHCICUArrange(icuaId))
			..s icupId=$o(^DHCICUPara(0,"ICUA",icuaId,""))
			..s icupiSub=0,mainIcupiSub=""
			..f  s icupiSub=$o(^DHCICUPara(icupId,"I",icupiSub)) q:icupiSub=""  d
				...i $p(^DHCICUPara(icupId,"I",icupiSub),"^",4)=mainIcucriId s mainIcupiSub=icupiSub
			..//q:mainIcupiSub=""
			..s triggerDate="",triggerTime="",sum=0
			..s icucpiSub=0
			..f  s icucpiSub=$o(^DHCICUCPredict(icucpId,"I",icucpiSub)) q:icucpiSub=""  d
				...s icucriCode=$lg(^DHCICUCPredict(icucpId,"I",icucpiSub),1)
				...q:icucriCode=""
				...s icucpiTrigger=$lg(^DHCICUCPredict(icucpId,"I",icucpiSub),4)
				...q:'icucpiTrigger
				...s icucpRefIcuriCode=$lg(^DHCICUCPredict(icucpId,"I",icucpiSub),18)
				...//w icucpRefIcuriCode,!
				...s icucpRefIcuriId=##class(web.DHCICUCom).GetIcuriIdByCode(icucpRefIcuriCode)
				...//w icucpRefIcuriId,!
				...s icucriId=$o(^DHCICUC("RecordItem",0,"Code",icucriCode,"")) //triggerId
				...q:icucriId=""
				...w "triggerCode="_icucriCode_"/"_icucriId,!
				...s date=startDate-1
				...f  s date=$o(^DHCICUOrder(0,"RecordItem",icucriId,date)) q:(date="")!(date>endDate)  d
					....s time=""
					....f  s time=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time)) q:time=""  d
						.....s icuoId=""
						.....f  s icuoId=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time,icuoId)) q:icuoId=""  d
							......q:"ICD"[$p(^DHCICUOrder(icuoId),"^",25)
							......s icupiId=$p(^DHCICUOrder(icuoId),"^",38)
							......s subIcupiId=$p(icupiId,"||",2) // 2014-05-16
							......q:subIcupiId=""				  // 2014-05-16 
							......s mainIcupiId=$p(^DHCICUPara(icupId,"I",$p(icupiId,"||",2)),"^",19)
							......//q:mainIcupiId=""
							......s subIcupiId=$p(mainIcupiId,"||",2) // 2014-05-16
							......s mainIcuciId=""
							......i subIcupiId'=""  d  
								.......s mainIcuciId=$p(^DHCICUPara(icupId,"I",$p(mainIcupiId,"||",2)),"^",4)
							......//w "icucpRefIcuriId="_icucpRefIcuriId_"/"_mainIcuciId,!
							......q:(icucpRefIcuriId'="")&(("^"_icucpRefIcuriId_"^")'[("^"_mainIcuciId_"^"))
							......s icuoNote=$p($g(^DHCICUOrder(icuoId)),"^",10)
							......s needNote=$lg(^DHCICUCPredict(icucpId,"I",icucpiSub),11)
							......//w icuaId_"/"_icucriCode_"                 =code/icuoId="_icuoId,"/"_mainIcuciId,!
							......q:(needNote'="")&(("^"_needNote_"^")'[("^"_icuoNote_"^"))
							......//w "================="
							......s triggerDate=$p($g(^DHCICUOrder(icuoId)),"^",5)
							......s triggerTime=$p($g(^DHCICUOrder(icuoId)),"^",6)
							......//s triggerDate=date,triggerTime=time
							......s sum=$lg(^DHCICUCPredict(icucpId,"I",icucpiSub),7)
							......//w icuaId_"    sum="_sum,!
							......s level=$lg(^DHCICUCPredict(icucpId,"I",icucpiSub),21)
							......k levelList
							......s levelList(+level)=""
							......s retStr=$$CreatePredictData
	q retStr
CreatePredictData()
	s curIcucpiSub=0,isQuit=0,orderParaList=""
	f  s curIcucpiSub=$o(^DHCICUCPredict(icucpId,"I",curIcucpiSub)) q:(curIcucpiSub="")  d
		.//w icucpId_"/"_curIcucpiSub_"/"_icucpiTrigger,"/"_isQuit,!
		.q:$lg(^DHCICUCPredict(icucpId,"I",curIcucpiSub),4)
		.i $lg(^DHCICUCPredict(icucpId,"I",curIcucpiSub),12)="AheadHour" d
			..s level=$lg(^DHCICUCPredict(icucpId,"I",curIcucpiSub),21)
			..q:$d(levelList(+level))
			..s icucriCode=$lg(^DHCICUCPredict(icucpId,"I",curIcucpiSub),1)
			..q:icucriCode=""
			..s icucriId=$o(^DHCICUC("RecordItem",0,"Code",icucriCode,""))
			..s fromDate=triggerDate,fromTime=triggerTime
			..s searchType=$lg(^DHCICUCPredict(icucpId,"I",curIcucpiSub),5)
			..s dataField=$lg(^DHCICUCPredict(icucpId,"I",curIcucpiSub),6)
			..s aheadHour=$lg(^DHCICUCPredict(icucpId,"I",curIcucpiSub),13)
			..s fromDate=fromDate-(aheadHour\24)
			..s aheadTime=(aheadHour-(aheadHour\24*24))*3600
			..s fromTime=fromTime-aheadTime
			..i fromTime<0 s fromTime=86400+fromTime,fromDate=fromDate-1
			..s needNote=$lg(^DHCICUCPredict(icucpId,"I",curIcucpiSub),11)
			..//w icuaId_"/"_icucriId_"/"_fromDate_"/"_fromTime_"/"_triggerDate_"/"_triggerTime_"/"_dataField,!
			..s value=""
			..i $lg(^DHCICUCPredict(icucpId,"I",curIcucpiSub),3)="R" d
				...i "^DurationDay^DurationHour^Times^"'[("^"_dataField_"^") d
					....s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,icucriId,fromDate,fromTime,triggerDate,triggerTime,searchType,"","","","","","",needNote)
					....//w "value="_value,!
				...e  d
					....s fromIcucriId="" //$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),22)
					....s toIcucriId="" //$lg(^DHCICUCInquiry(icuciId,"I",icuciiSub),23)
					....i (fromIcucriId'="")&(toIcucriId'="") d
						.....s durationStr=##class(web.DHCICUOrder).GetCatheterDuration(icuaId,icucriId,fromDate,fromTime,triggerDate,triggerTime,fromIcucriId,toIcucriId)
					....e  d
						.....s durationStr=##class(web.DHCICUOrder).GetRecordDuration(icuaId,icucriId,fromDate,fromTime,triggerDate,triggerTime,120,needNote)
					....//w durationStr,!
					....i dataField="DurationDay" s value=value+$p(durationStr,"^",1)
					....i dataField="DurationHour" s value=value+$p(durationStr,"^",2)
					....i dataField="Times" s value=value+$p(durationStr,"^",4)
			..i $lg(^DHCICUCPredict(icucpId,"I",curIcucpiSub),3)="L" d
				...s testCode=$lg(^DHCICUCPredict(icucpId,"I",curIcucpiSub),1)
				...//w testCode_"    in/"_fromDate_"/"_fromTime_"/"_toDate_"/"_toTime,!
				...s EpisodeID=+^DHCICUArrange(icuaId)
				...s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
				...s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
				...q:regNo=""
				...s testQtyStr=##class(web.DHCClinicCom).GetTestResult("", regNo, "", testCode, fromDate, fromTime, triggerDate, triggerTime, 0)
				...//w testCode_"  =testCode/testStr="_testQtyStr,"/"_minQty_"/"_maxQty,!
				...//i testQtyStr'="" s value=+testQtyStr
				...s minValue="",maxValue=""
				...f j=1:1:$l(testQtyStr,ETX) d
					....q:(searchType="First")&(value'="")
					....s testQty=$p(testQtyStr,ETX,j)
					....q:testQty=""
					....i searchType="First" s value=+testQty
					....i (minValue="")!(minValue>+testQty) s minValue=+testQty
					....i (maxValue="")!(maxValue<+testQty) s maxValue=+testQty
				...i searchType="Max" s value=maxValue
				...i searchType="Min" s value=minValue
			..q:value=""
			..//s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,icucriId,fromDate,fromTime,triggerDate,triggerTime,searchType,"","","","","","",needNote)
			..//w wardLocId_"  "_icucriId_": value="_value_" sum="_sum,"/"_fromDate,"/"_fromTime,"/"_triggerDate,"/"_triggerTime,"/"_needNote,!
			..s minQty=$lg(^DHCICUCPredict(icucpId,"I",curIcucpiSub),8)
			..s maxQty=$lg(^DHCICUCPredict(icucpId,"I",curIcucpiSub),9)
			..//w value_"/"_minQty_"/"_maxQty,!
			..i (maxQty'="")&(value>minQty)&(value<maxQty) d
				...s sum=sum+$lg(^DHCICUCPredict(icucpId,"I",curIcucpiSub),7)
				...s levelList(+level)=""
			..i (needNote'="")&(value'="") d
				...s sum=sum+$lg(^DHCICUCPredict(icucpId,"I",curIcucpiSub),7)
				...s levelList(+level)=""
			..//w "sum="_sum,!
			..q:sum<$lg(^DHCICUCPredict(icucpId),6)
			..//w " get sum:"_sum,!
			..s sum=0
			..s $p(orderPara,$c(3),2)=icuaId
			..s $p(orderPara,$c(3),3)=mainIcucriId
			..s $p(orderPara,$c(3),5)=userId
			..s $p(orderPara,$c(3),6,9)=triggerDate_$c(3)_triggerTime_$c(3)_triggerDate_$c(3)_triggerTime
			..s $p(orderPara,$c(3),11)=""
			..s $p(orderPara,$c(3),12)=""
			..i $p(^DHCICUC("RecordItem",mainIcucriId),"^",24)="Note" s $p(orderPara,$c(3),11)=$lg(^DHCICUCPredict(icucpId),2)
			..i $p(^DHCICUC("RecordItem",mainIcucriId),"^",24)="Qty" s $p(orderPara,$c(3),12)=$lg(^DHCICUCPredict(icucpId),2)
			..s $p(orderPara,$c(3),17)=$p(^DHCICUC("RecordItem",mainIcucriId),"^",5) //viewCat
			..s $p(orderPara,$c(3),18)="N"
			..s $p(orderPara,$c(3),22)=+$h
			..s $p(orderPara,$c(3),23)=$p($h,",",2)
			..s $p(orderPara,$c(3),26)="N"
			..s $p(orderPara,$c(3),39)=icupId_"||"_mainIcupiSub
			..i orderParaList'="" s orderParaList=orderParaList_"^"
			..s orderParaList=orderParaList_orderPara
			..//w "  return: "_icucriId_"\"_$p(^DHCICUC("RecordItem",icucriId),"^",2)_"\"_icucriList(icucriId),"\"_
			..//w $p($g(^DHCICUC("RecordItem",mainIcucriId)),"^",2)_" 待插入数据:"_orderPara,!
			..//b ;data
			..s papmiId=$p($g(^PAADM(+^DHCICUArrange(icuaId))),"^",1)
			..s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
			..s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
			..//w "debug="_ifDebug,"/"_regNo_"/"_patName_"/"_wardLocId_"/"_icuaId,"/"_$zd(triggerDate,3),"/"_$zt(triggerTime),!
			..i 'ifDebug d
	    		...//w "save"
				...s retStr=##class(web.DHCICUOrder).SaveICUOrder(orderParaList)
				...//w retStr,!
				...s ^DHCANICUDEBUG("AutoAddPredictOrder",endDate,endTime)=orderParaList
	q 0
AutoAddPredictOrderError
	s ^DHCANICUDEBUG("AutoAddPredictOrder",+$h,logTime)=$ZE
	//w $ZE,!
	q ""
}

// 生成医生交接班记录

ClassMethod CheckDoctorHandover(icuaId, curIcuoId, sDate, sTime)
{
	q:curIcuoId="" ""	///ly 20210512
	q:$p(^DHCICUOrder(curIcuoId),"^",25)="" ""
	q:"NE"'[$p(^DHCICUOrder(curIcuoId),"^",25) ""
	s $ZT="CheckDoctorHandoverError"
	s ^tmpIcuDebug("CheckDoctorHandover",+$h,$p($h,",",2),icuaId)=icuaId_" "_curIcuoId_" "_sDate_" "_sTime
	// w ##class(web.DHCICUOrder).CheckDoctorHandover(icuaId,curIcuoId,sDate,sTime)

	s recordId=$p($g(^DHCICUOrder(curIcuoId)),"^",2)
	s code=$p($g(^DHCICUC("RecordItem",recordId)),"^",1)
	s retStr=""
	q:((code'="YSJJBJLSJFWJSSJ")&&(code'="YSJJBJLSJFWKSSJ")) "-1"
	
	i '$ISVALIDNUM(sDate) s sDate=##class(web.DHCClinicCom).ConvertToDateH(sDate)
	i '$ISVALIDNUM(sTime) s sTime=##class(web.DHCClinicCom).ConvertToTimeH(sTime)
	s startDateTime="",endDateTime=""
	i startDateTime="" s startDateTime=$$GetValueByCode(icuaId,"YSJJBJLSJFWKSSJ",sDate,sTime)
	i endDateTime="" s endDateTime=$$GetValueByCode(icuaId,"YSJJBJLSJFWJSSJ",sDate,sTime)
	q:startDateTime="" "startDateTime is null"
	q:endDateTime="" "endDateTime is null"
	//w startDateTime," ",endDateTime,!
	s resStr=..DoctorHandover(icuaId,startDateTime,endDateTime,sDate,sTime)
	q resStr
	
GetValueByCode(icuaId,code,sDate,sTime)
	s recordId="",value=""
	s recordId=$O(^DHCICUC("RecordItem",0,"Code",code,recordId))
	s dataField=$p($g(^DHCICUC("RecordItem",recordId)),"^",24)
	
	s icuoId="" f  s icuoId=$O(^DHCICUOrder(0,"RecordItem",recordId,sDate,icuaId,sTime,icuoId)) q:icuoId=""  d
	.q:'$d(^DHCICUOrder(icuoId))
	.q:"ICD"[$p(^DHCICUOrder(icuoId),"^",25)
	.s value=##class(web.DHCICUOrder).GetRecordValueSingle(icuoId,dataField)
	//w code,":","recordId:",recordId,"  ",value,!
	q value
CheckDoctorHandoverError
	// 异常处理
	s ErrorMsg=$ZE
	s paraStr=icuaId_","_curIcuoId_","_sDate_","_sTime
	s time=$p($h,",",2)
	s ^tmpIcuDebug("CheckDoctorHandover",+$h,time)=ErrorMsg
	s ^tmpIcuDebug("CheckDoctorHandover",+$h,time,"Para")=paraStr
	q ErrorMsg
	q
}

ClassMethod DoctorHandover(icuaId, startDateTime, endDateTime, date, Time)
{
	s $ZT="DoctorHandoverError"

	// w ##class(web.DHCICUOrder).DoctorHandover(icuaId,startDateTime,endDateTime,dateTime,date,Time)
	s fromDate=$p(startDateTime," ",1)
	s fromTime=$p(startDateTime," ",2)
	s toDate=$p(endDateTime," ",1)
	s toTime=$p(endDateTime," ",2)
	
	
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s fromTime=##class(web.DHCClinicCom).ConvertToTimeH(fromTime)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	s toTime=##class(web.DHCClinicCom).ConvertToTimeH(toTime)
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(date)
	s startTime=##class(web.DHCClinicCom).ConvertToTimeH(Time)
	
	// 通过icuaId获取个人模板Id
	s paraId=""
	s paraId=$O(^DHCICUPara(0,"ICUA",icuaId,paraId))
	i paraId'="" d
	.s sub=""
	.f  s sub=$O(^DHCICUPara(paraId,"I",sub)) q:sub=""  d
	..s itemStr=$g(^DHCICUPara(paraId,"I",sub))
	..s recordId=$p(itemStr,"^",4)
	..s mainId=$p(itemStr,"^",19)
	..q:recordId=""
	..s TEMPRecordToParaItem(recordId)=paraId_"||"_sub
	..i mainId'="" d
	...s mainSubId=$p(mainId,"||",2)
	...s mainRecordId=$p($g(^DHCICUPara(paraId,"I",mainSubId)),"^",4)
	...q:mainRecordId=""
	...s mainRecordStr=$g(^DHCICUC("RecordItem",mainRecordId))
	...s formatStr=$p(mainRecordStr,"^",25)
	...s args=$p(mainRecordStr,"^",27)
	...s TEMPRecordToParaItem(recordId,"MainItem")=mainId
	...i ((formatStr'="")&&(args'="")) d
	...s TEMPRecordToParaItem(recordId,"MainItem")=mainId_"^"_formatStr_"^"_args
	...
	
	// 生命体征
	s TMPDoctorHandover(6913,"RecordItems","YSJJBJLSMTZ")="HR;NMBP;AMBP;SPO2;CVP" // "HR;NSBP;NDBP;NMBP;ASBP;ADBP;AMBP;SPO2;CVP"
	s TMPDoctorHandover(6913,"RecordItems","YSJJBJLSMTZ","Type")="Scope" ; Scope;Balance;LastValue;Dose;DrugName;Days
	s TMPDoctorHandover(6913,"RecordItems","YSJJBJLSMTZ","Name")="生命体征"
	// 呼吸机参数
	s TMPDoctorHandover(6914,"RecordItems","YSJJBJLHXJCS")="VentilatorMode;RR-Set;FiO2-Set;Ppeak;PEEPS;VTe;MVe" // VentilatorMode;RR-Set;VTi;PS;PEEP;FiO2;FiO2-Set;Pplat;Ppeak;Pmean;I/E-Set;PEEPS;VTe;MVe
	s TMPDoctorHandover(6914,"RecordItems","YSJJBJLHXJCS","Type")="LastValue"
	s TMPDoctorHandover(6914,"RecordItems","YSJJBJLHXJCS","Name")="呼吸机"
	// 血滤参数
	s TMPDoctorHandover(6915,"RecordItems","YSJJBJLXLCS")="CRRTDevType;BloodPumpSeed;FormerDiluent;DiluentAfter;UltrafiltrationRateSet" //CRRTDevType;BloodPumpSeed;FormerDiluent;DiluentAfter;PBP_METHOD;TMP;UltrafiltrationRateSet;UltrafiltrationRateAct
	s TMPDoctorHandover(6915,"RecordItems","YSJJBJLXLCS","Type")="LastValue"
	s TMPDoctorHandover(6915,"RecordItems","YSJJBJLXLCS","Name")="血滤"
	// 静脉泵入药物
	s TMPDoctorHandover(6916,"RecordItems","YSJJBJLJMBRYW")="DetailDosePump"
	s TMPDoctorHandover(6916,"RecordItems","YSJJBJLJMBRYW","Type")="DrugName"
	s TMPDoctorHandover(6916,"RecordItems","YSJJBJLJMBRYW","Name")="静脉泵入药物"
	// 抗微生物药物
	s TMPDoctorHandover(6917,"RecordItems","YSJJBJLKSS")=""
	s TMPDoctorHandover(6917,"RecordItems","YSJJBJLKSS","Type")="Antibiotic"
	s TMPDoctorHandover(6917,"RecordItems","YSJJBJLKSS","Name")="抗微生物药物"
	// 危急值
	s TMPDoctorHandover(6918,"RecordItems","YSJJBJLWJZ")="LabPanic"
	s TMPDoctorHandover(6918,"RecordItems","YSJJBJLWJZ","Type")="Record"
	s TMPDoctorHandover(6918,"RecordItems","YSJJBJLWJZ","Name")="危急值"
	// 输血 
	s TMPDoctorHandover(6919,"RecordItems","YSJJBJLSX")=""
	s TMPDoctorHandover(6919,"RecordItems","YSJJBJLSX","Type")="Blood"
	s TMPDoctorHandover(6919,"RecordItems","YSJJBJLSX","Name")="输血"
	// 每小时尿量范围
	s TMPDoctorHandover(6922,"RecordItems","YSJJBJLMXSNLFW")="nyndgnl"
	s TMPDoctorHandover(6922,"RecordItems","YSJJBJLMXSNLFW","Type")="Scope;IORate"
	s TMPDoctorHandover(6922,"RecordItems","YSJJBJLMXSNLFW","Name")="尿量与平衡"
	s TMPDoctorHandover(6922,"RecordItems","YSJJBJLMXSNLFW","Unit")="ml/hr"
	// 血流动力学结果 
	s TMPDoctorHandover(6923,"RecordItems","YSJJBJLXLDLXJG")="Height;Weight;BSA;CO;CI;P:SV(ml);P:SI;P:SVR;SVRI;S:PAWP;PVR;PVRI;P:CCO;P:CCI;P:GEDV;P:GEDVI;P:ITBV(ml);P:ITBVI(ml/㎡);P:EVLW(ml);P:EVLWI;P:GEF;P:CFI(L/MIN);P:dpmax;P:SVV(%);PPV;RVSW;S:RVSWI;LVSW;S:LVSWI"
	s TMPDoctorHandover(6923,"RecordItems","YSJJBJLXLDLXJG","Type")="LastValue"
	s TMPDoctorHandover(6923,"RecordItems","YSJJBJLXLDLXJG","Para")="2"
	s TMPDoctorHandover(6923,"RecordItems","YSJJBJLXLDLXJG","Name")="血流动力学"
	// 末两次血气结果
	s TMPDoctorHandover(6924,"RecordItems","YSJJBJLMLCXQJG")="SampleType;pH;pCO2;pO2;Na+;K+;Cl-;Ca++;Hct;Glu;Lac;sO2;BE;AnionGap;HCO3-"
	s TMPDoctorHandover(6924,"RecordItems","YSJJBJLMLCXQJG","Type")="LastValue"
	s TMPDoctorHandover(6924,"RecordItems","YSJJBJLMLCXQJG","Para")="2"
	s TMPDoctorHandover(6924,"RecordItems","YSJJBJLMLCXQJG","Name")="血气"
	
	// 末两次血常规
	s TMPDoctorHandover(6925,"RecordItems","YSJJBJLMLCXCGGGSQXJMJG")="血常规:WBC,PLT,MCHC,HCT,HGB"_";肝功:ALT,TBIL,TBDL,ABL"_";肾功:K,NA,CL,CA,CR,BUN,UREA,GLU"_";心肌酶:0011,0345,0346"  //"血常规:WBC,NEUT%,LY%,MONO%,RBC,PLT,Hb,HCT"_",肝功:ALT,TBIL,TBDL,ABL"_",肾功:K,Na,CL,Ca,CR,BUN,UREA,GLU"_",心肌酶:CK,CKMB,cTnI"
	s TMPDoctorHandover(6925,"RecordItems","YSJJBJLMLCXCGGGSQXJMJG","Type")="LabLastValue"
	s TMPDoctorHandover(6925,"RecordItems","YSJJBJLMLCXCGGGSQXJMJG","Para")="2"
	s TMPDoctorHandover(6925,"RecordItems","YSJJBJLMLCXCGGGSQXJMJG","Name")="检验"
	s i=""  f  s i=$O(TMPDoctorHandover(i)) q:i=""  d
	.
	.s code=""  f  s code=$O(TMPDoctorHandover(i,"RecordItems",code)) q:code=""  d
	..s codeList=$g(TMPDoctorHandover(i,"RecordItems",code))
	..s typeList=$g(TMPDoctorHandover(i,"RecordItems",code,"Type"))
	..s icucriId=0,searchId=0
	..s searchId=$O(^DHCICUC("RecordItem",0,"Code",code,searchId))
	..;生成数据
	..s valueList=""
	..s typeCount=$L(typeList,";")
	..s result=""
	..f j=1:1:typeCount  d
	...s valueList=""
	...b //code
	...s type=$p(typeList,";",j)
	...q:type=""
	...i type="Scope" d
	....s valueList=..GetVluueByCodeList(icuaId,codeList,fromDate,fromTime,toDate,toTime,"MinMax")
	....s unit=$g(TMPDoctorHandover(i,"RecordItems",code,"Unit"))
	....i valueList'="" s valueList=valueList_unit
	...i type="IORate" d
	....s text="目前平衡(从{0}到{1}):"
	....s fromDatetimeStr=##class(web.DHCClinicCom).ConvertToDate(fromDate)_" "_##class(web.DHCClinicCom).ConvertToTime(fromTime)
	....s toDatetimeStr=##class(web.DHCClinicCom).ConvertToDate(toDate)_" "_##class(web.DHCClinicCom).ConvertToTime(toTime)
	....s valueList=..GetIORate(icuaId,fromDate,fromTime,toDate,toTime) b // GetIORate
	....s text=##class(web.DHCClinicCom).Replace(text,"{0}",fromDatetimeStr)
	....s text=##class(web.DHCClinicCom).Replace(text,"{1}",toDatetimeStr)
	....s valueList=text_valueList
	...e  i type="LastValue" d
	....s num=$g(TMPDoctorHandover(searchId,"RecordItems",code,"Para"))
	....
	....i +num<=0 s num=1
	....s valueList=..GetVluueByCodeList(icuaId,codeList,fromDate,fromTime,toDate,toTime,"LastValue",num)
	....
	...e  i type="DrugName" d
	....s recordId=""
	....s recordId=$O(^DHCICUC("RecordItem",0,"Code",codeList,recordId))
	....s valueList=..GetPumpDrugByIcuaId(icuaId, recordId, fromDate,fromTime,toDate,toTime,"Dose")
	...e  i type="Record" d
	....s recordId=""
	....s recordId=$O(^DHCICUC("RecordItem",0,"Code",codeList,recordId))
	....s valueList=..GetLastValueList(icuaId,recordId,fromDate,fromTime,toDate,toTime,1,-1)
	...e  i "Antibiotic;Blood"[type d
	....s valueList=..GetDrugUseInfo(icuaId,fromDate,fromTime,toDate,toTime,type)
	....
	...e  i type="LabLastValue" d
	....;b ///
	....s subTypeLen=$L(codeList,";")
	....f subTypeIndex=1:1:subTypeLen d
	.....s subCodeList=$p(codeList,";",subTypeIndex)
	.....s num=$g(TMPDoctorHandover(searchId,"RecordItems",code,"Para"))
	.....s value=$$LabRes(icuaId,$p(subCodeList,":",2),fromDate, fromTime, toDate, toTime,num)
	.....s subTypeName=$p(subCodeList,":",1)
	.....i value'="" d
	......i valueList="" s valueList=subTypeName_":"_$c(13)_$c(10)_value
	......e  s valueList=valueList_$c(13)_$c(10)_subTypeName_":"_value
	....b //// LabRes ///
	...
	...i result="" s result=valueList
	...e  s result=result_","_valueList
	...
	..s resultTxt=$g(TMPDoctorHandover(i,"RecordItems",code,"Name"))
	..//w resultTxt_":"_"valueList:"_valueList,!
	..b ;//// $$Insert2ICUOrder /////
	..
	..
	..i result'="" s result=resultTxt_": "_$c(13)_$c(10)_result s reStr=$$Insert2ICUOrder(icuaId,searchId,startDate,startTime,"",result)
	..
	q ""
	
Insert2ICUOrder(icuaId,icucriId,startDate,startTime,numValue,txtValue)
	b
	//w startDate," ",startTime," ",numValue," ",txtValue,!
	s paraItemId=""
	s paraItemId=$g(TEMPRecordToParaItem(icucriId))
	s reStr=##class(web.DHCICUCom).Insert2ICUOrder(icuaId,icucriId,startDate,startTime,numValue,txtValue,paraItemId)
	q reStr
LabRes(icuaId,codeList,fromDate, fromTime, toDate, toTime,count)	
	s EpisodeID=$p(^DHCICUArrange(icuaId),"^",1)
	s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s retStr="",testStr=""
	s standardCode=$p(codeList,",",1)
	s dateTimeList=##class(web.DHCICUOrder).GetTestResult(regNo,standardCode,fromDate,fromTime,toDate,toTime,count,"DateTime")
	q:dateTimeList="" ""
	s timeLen=$L(dateTimeList,"^")
	s len=$L(codeList,",")
	b ///////s len=$L(codeList,";")
	s timeIndex=1 f timeIndex=1:1:timeLen  d
	.s qDateTime=$p(dateTimeList,"^",timeIndex)
	.s qDate=qDateTime\(24*3600)
	.s qTime=qDateTime#(24*3600)
	.
	.s retStr=""_$zd(qDate)_" "_$zt(qTime)
	.s k=1 f k=1:1:len  d
	..s standardCode=$p(codeList,",",k)
	..//s standardCode=$g(^tmpicudebug("StandCode",standardCode))
	..q:standardCode=""
	..//s value=##class(web.DHCClinicCom).GetTestResult("", regNo, "", standardCode, fromDate, fromTime, toDate, toTime, count)
	..
	..s value=##class(web.DHCICUOrder).GetTestResult(regNo,standardCode,qDate,qTime,qDate,qTime,count,"",-1,qDateTime)
	..
	..q:value=""
	..
	..s r1=$p(value,"\",1),r2=$p(value,"\",2),rDate=$p(value,"\",4),rTime=$p(value,"\",5),testDesc=$p(value,"\",6)
	..s value=$p(value,"\",1)_$p(value,"\",2)
	..
	..i retStr="" s retStr=testDesc_":"_value
	..e  s retStr=retStr_"; "_testDesc_":"_value
	.i testStr="" s testStr=retStr
	.e  s testStr=testStr_$c(13)_$c(10)_retStr
	q testStr
DoctorHandoverError
	// 异常处理
	s ErrorMsg=$ZE
	s paraStr=icuaId_","_startDateTime_","_endDateTime
	s logTime=$p($h,",",2)
	s ^tmpIcuDebug("DoctorHandover",+$h,logTime)=ErrorMsg_$zd(+$h)_" "_$zt($p($h,",",2))
	s ^tmpIcuDebug("DoctorHandover",+$h,logTime,"Para")=paraStr
	q ErrorMsg
}

// 按常用医嘱ID找出离时间点最近的N组数据

ClassMethod GetLastValueList(icuaId, icucriId, fromDate, fromTime, toDate, toTime, num = 1, order = 1, type = "")
{
	
	// w ##class(web.DHCICUOrder).GetLastValueList(icuaId,icucriId,fromDate,fromTime,toDate,toTime,num=1,order=1,type)
	i '$ISVALIDNUM(fromDate) s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	i '$ISVALIDNUM(fromTime) s fromTime=##class(web.DHCClinicCom).ConvertToTimeH(fromTime)
	i '$ISVALIDNUM(toDate) s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	i '$ISVALIDNUM(toTime) s toTime=##class(web.DHCClinicCom).ConvertToTimeH(toTime)
	s sOneDay=24*3600
	s startDateTime=fromDate*sOneDay+fromTime
	s endDateTime=toDate*sOneDay+toTime
	s count=0,valueList="",ifQuit=0
	s icucriDataField=$p($g(^DHCICUC("RecordItem",icucriId)),"^",24)
	i order=1 s date=fromDate-1
	e  s date=toDate+1
	f  s date=$o(^DHCICUOrder(0,"RecordItem",icucriId,date),order) q:(date="")!(ifQuit)  d
	.i order=1 d
	..i date=fromDate s time=fromTime-1
	..e  s time=-1
	.e  d
	..i date=toDate s time=toTime+1
	..e  s time=sOneDay+1
	.f  s time=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time),order) q:(time="")!(ifQuit)  d
	..s dateTime=date*sOneDay+time
	..;w $zd(date)," ",$zt(time),!
	..i ((dateTime>endDateTime)||(dateTime<startDateTime)||(count>=num)) s ifQuit=1 
	..q:ifQuit=1
	..
	..s icuoId="" s icuoId=$o(^DHCICUOrder(0,"RecordItem",icucriId,date,icuaId,time,icuoId),order) q:(icuoId="")!(ifQuit)  d
	...
	...q:'$d(^DHCICUOrder(icuoId))
	...q:"ICD"[$p(^DHCICUOrder(icuoId),"^",25)
	...s value=##class(web.DHCICUOrder).GetRecordValueSingle(icuoId,icucriDataField)
	...s count=count+1
	...i type="Sum" d
	....;w $d(date)," ",$t(time),":",value,!
	....s valueList=+value+valueList
	...e  i type="DateTime" d
	....i valueList="" s valueList=dateTime
	....e  s valueList=valueList_","_dateTime
	...e  d
	....;w value,!
	....i valueList="" s valueList=$zd(date)_" "_$zt(time)_" "_value
	....e  s valueList=valueList_","_$zd(date)_" "_$zt(time)_" "_value
	q valueList
}

ClassMethod GetDrugUseInfo(icuaId, sDate, sTime, eDate, eTime, type = "Antibiotic")
{
	// W ##class(web.DHCICUOrder).GetDrugUseInfo(2798,"2014-05-18","00:00","2014-05-19","23:00")
	s episodeId=$p($g(^DHCICUArrange(icuaId)),"^",1)
	q:episodeId="" ""
	i '$ISVALIDNUM(sDate) s sDate=##class(web.DHCClinicCom).ConvertToDateH(sDate)
	i '$ISVALIDNUM(sTime) s sTime=##class(web.DHCClinicCom).ConvertToTimeH(sTime)
	i '$ISVALIDNUM(eDate) s eDate=##class(web.DHCClinicCom).ConvertToDateH(eDate)
	i '$ISVALIDNUM(eTime) s eTime=##class(web.DHCClinicCom).ConvertToTimeH(eTime)
	//new (episodeid)
	/*s USTAT=$O(^OEC("OSTAT",0,"Code","U",0))
	s drugNameList=""
	s oeori=0 f  s oeori=$o(^DAUP("ADM",episodeid,oeori))  q:oeori=""  d
	.S OrdStatus=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",13)
	.q:USTAT=OrdStatus        //作废医嘱不符合条件
	*/
	s drugNameList=""
	s oeordId=$o(^OEORD(0,"Adm",episodeId,""))
	q:oeordId="" "" // 未开过医嘱
	s date=sDate-1
	s oneDaySecs=24*3600
	s startDateTime=sDate*oneDaySecs+sTime
	s endDateTime=eDate*oneDaySecs+eTime
	i type="Antibiotic" s startDateTime=endDateTime-oneDaySecs // 抗微生物药物只列出"结束时间"前24小时内的药品
	s ifQuit=0
	s date=eDate+1 f  s date=$o(^OEORDi(0,"StDt",date),-1) q:(date="")  d
	.s oeoriSub="" f  s oeoriSub=$o(^OEORDi(0,"StDt",date,oeordId,oeoriSub)) q:((oeoriSub="")||(ifQuit))  d
	..s arcimId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",2)
	..s oeoriId=oeordId_"||"_oeoriSub
    ..s firstSttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
    ..s firstSttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
    ..s firstSttDateTime=firstSttDate*oneDaySecs+firstSttTime
    ..;w $zd(firstSttDate)," ",! b
    ..q:firstSttDateTime>endDateTime
    ..i firstSttDateTime<startDateTime s ifQuit=1
    ..
	..s ordStatCode=##Class(web.DHCClinicCom).GetOrdStatCode(oeoriId)
	..q:"UID"[ordStatCode
	..
	..i type="Antibiotic" d
	...d Antibiotic(oeoriId,arcimId)
	..e  i type="Blood" d Blood(arcimId,oeoriId)
	// 找出结束一小时往前24小时的药品
	
	// 计算天数
	i type="Antibiotic" d
	.s arcimId="" f  s arcimId=$O(TMPDrug(arcimId)) q:arcimId=""  d
	..s TMPDrug(arcimId)=TMPDrug(arcimId)_","_$$GetLastContinueDays(arcimId,eDate)_"天"
	
	
	s arcimId="" f  s arcimId=$O(TMPDrug(arcimId)) q:arcimId=""  d
	.s itemName=$g(TMPDrug(arcimId))
	.s vol=+$g(TMPDrug(arcimId,"Vol"))
	.i vol'=0 s itemName=itemName_":"_vol
	.i drugNameList="" s drugNameList=itemName_$g(TMPDrug(arcimId,"unit"))
	.e  s drugNameList=drugNameList_","_itemName_$g(TMPDrug(arcimId,"unit"))
	Q drugNameList
Antibiotic(oeoriId,arcimId)
	
	w arcimId,!
	// 抗微生物药物
	s PoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(arcimId)
	s PoisonCode=""
	i PoisonRowid'="" s PoisonCode=$P(^PHCPO(PoisonRowid),"^",1)
	i ..IsAntibiotic(arcimId) d
	.
	.;i ((PoisonCode="KSS1")||(PoisonCode="KSS2")||(PoisonCode="KSS3")) d
	.s arcimDesc=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",2)
	.;i drugNameList="" s drugNameList=arcimDesc_" Dose:"_$$GetDose(icuaId,oeoriId)
	.;e  s drugNameList=drugNameList_","_arcimDesc_" Dose:"_$$GetDose(icuaId,oeoriId)
	.s arcimDesc=##class(web.DHCClinicCom).SubStr(arcimDesc,"","(")
	.s arcimDesc=##class(web.DHCClinicCom).SubStr(arcimDesc,"","[")
	.s doseStr=##class(web.DHCClinicCom).GetOeorditemInfo(oeoriId)
	.s doseValue=$p(doseStr,"^",11)
	.s unitUomId=$p(doseStr,"^",12)
	.s unitStr=$p($g(^CT("UOM",unitUomId)),"^",2)
	.
	.s rootOeoriId=$$GetRootOeorId(oeoriId) 
	.s time=+$$GetTimeSpan(rootOeoriId)
	.i ((time>0)&&($g(TMPDrug(arcimId,"Time"))<time)) s TMPDrug(arcimId,"Time")=time
	.b //dose//
	.//w time_"天",!
	.s oeordId=$p(oeoriId,"||",1)
	.s oeoriSub=$p(oeoriId,"||",2)
	.s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
	.s phcfrCode=$p(^PHCFR(phcfrId),"^",1)
	.s TMPDrug(arcimId)=arcimDesc_":"_doseValue_unitStr_","_phcfrCode // _","_+$g(TMPDrug(arcimId,"Time"))_"天"   //_" Dose:"_$$Traverse(oeoriId)  // $$GetDose(icuaId,oeoriId) 因为搞生素医嘱都非泵入药，所以暂不计算剂量,需要查出绑定的医嘱才能计算剂量和天数
	.s oeorDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
    .s oeorTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
    .s TMPDrug(arcimId,"DateTime",+oeorDate,+oeorTime)=oeorDate_","_oeorTime
    .;s ^DHCANICUDEBUG("Antibiotic",icuaId,arcimId,+oeorDate,+oeorTime)=$zd(oeorDate)_$zt(oeorTime)
	.
	.
	
	q
GetTotalDays(arcimId)
	s days=0
	/*s ^OEORDi(0,"ARCIM",oeordId,arcimId,date)
	s sub="" f  s sub=$O(TMPDrug(arcimId,"DateTime",sub)) q:sub=""  d
	.s days=days+1
	*/
	s sub="" f  s sub=$O(^OEORDi(0,"ARCIM",oeordId,arcimId,sub)) q:sub=""  d
	.s days=days+1
	q days
GetLastContinueDays(arcimId,endDate)
	s lastDay=0,days=0,Quit=0
	s sub=endDate+1 f  s sub=$O(^OEORDi(0,"ARCIM",oeordId,arcimId,sub),-1) q:((sub="")||(Quit))  d
	.
	.
	.i ((lastDay'=0)&&($zabs(lastDay-sub)>1)) s Quit=1
	.q:Quit
	.s days=days+1
	.s lastDay=sub
	q days
Blood(arcimId,oeoriId)
	q:oeoriId="" ""
	// 输血
	s mainViewCat="" f  s mainViewCat=$o(^DHCICUC("OrdMapping",mainViewCat)) q:mainViewCat=""  d
	.s viewCat="" f  s viewCat=$o(^DHCICUC("OrdMapping",mainViewCat,viewCat)) q:viewCat=""  d
	..
	..s itemStr=$g(^DHCICUC("OrdMapping",mainViewCat,viewCat,arcimId))
	..q:itemStr=""
	..q:itemStr'["血液制品"
	..s bloodVol=$p(itemStr,"^",6)
	..s oeorditemStr=##class(web.DHCICUOrder).GetOeorditemInfo(oeoriId)
	..s oeoriNote=$p(oeorditemStr,"^",17) //医嘱备注 42	血液名称
	..s name=$p(itemStr,"^",7)
	..s TMPDrug(arcimId)=oeoriNote
	..s totalVol=+$g(TMPDrug(arcimId,"Vol"))+bloodVol
	..s TMPDrug(arcimId,"Vol")=totalVol
	..s TMPDrug(arcimId,"unit")="ml"
	q 
GetDose(icuaId,oeoriId)
	s icuOeoriId=oeoriId_"||"_"1"
	s dose="",ifQuit2=0
	s icuoId="" f  s icuoId=$O(^DHCICUOrder(0,"OEORE",icuOeoriId,icuaId,icuoId),-1) q:((icuoId="")||(ifQuit2=1))  d
	.s icucrdName=$p($g(^DHCICUOrder(icuoId)),"^",2)
	.//w icucrdName,!
	.q:'$d(^DHCICUOrder(icuoId))
	.q:"ICD"[$p(^DHCICUOrder(icuoId),"^",25)
	.s icucriId=$p(^DHCICUOrder(icuoId),"^",2)
	.i icucriId="" s ^tmpIcuErrorData("nullComOrd",icuoId)=""
	.q:icucriId=""
	.s dataField=$p($g(^DHCICUC("RecordItem",icucriId)),"^",24)
	.i dataField="DoseSpeed" d
	..s dose=##class(web.DHCICUOrder).GetDoseSpeed(icuoId,"","DoseSpeed")
	..s ifQuit2=1
	q 
GetRootOeorId(oeoriId)
	s oeordId=$p(oeordId,"||",1)
	s oeoriSub=$p(oeordId,"||",2)
	q:((oeordId="")||(oeoriSub="")) oeoriId
	s parentOeoriId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)
	s doseQty=0
	q:parentOeoriId="" oeoriId
	q $$GetRootOeorId(oeoriId)
GetTimeSpan(oeoriId,type="Day")
	s oeoriId=$$GetRootOeorId(oeoriId)
	s oeordId=$p(oeoriId,"||",1)
	s oeoriSub=$p(oeoriId,"||",2)
	s rootDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
    s rootTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
    //w $zd(rootDate)," ",$zt(rootTime),!
    s span=((eDate*oneDaySecs)+eTime)-((firstSttDate*oneDaySecs)+firstSttTime)
    b
    q:type="Day" (span\oneDaySecs)
    q:type="Hour" (span\3600)
    q ""
GetDoseFromOEORD(oeordId,oeoriSub)
	s doseQty=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",1)
	q doseQty
IsAntibiotics(arcimId)
	s PoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(arcimId)
	q:$D(^DHCANICUDEBUG("drug",arcimId)) 1
	q:PoisonRowid="" 0
	i PoisonRowid'="" s PoisonCode=$P(^PHCPO(PoisonRowid),"^",1)
	s isAnti=0
	i ((PoisonCode="KSS1")||(PoisonCode="KSS2")||(PoisonCode="KSS3")) s isAnti=1
	q isAnti
}

/// 泵入药
ClassMethod GetPumpDrugByIcuaId(icuaId, recordId, startDate, startTime, endDate, endTime, type = "") As %String
{
	// w ##class(web.DHCICUOrder).GetPumpDrugByIcuaId(icuaId, recordId, startDate,startTime,endDate,endTime)
	i '$ISVALIDNUM(startDate) s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	i '$ISVALIDNUM(startTime) s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	i '$ISVALIDNUM(endDate) s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	i '$ISVALIDNUM(endTime) s endTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
	q:recordId="" ""
	s time="",rowId="",quit=0
	s drugNamList=""
	s endDateTime=(endDate*24*3600)+endTime
	s date=startDate-1
	//w recordId," ",!
	f  s date=$o(^DHCICUOrder(0,"RecordItem",recordId,date))  q:((date="")||(quit=1))  d
	.s time=0
	.f  s time=$o(^DHCICUOrder(0,"RecordItem",recordId,date,icuaId,time))  q:((time="")||(quit=1))  d
	..s dateTime=(date*24*3600)+time
	..i dateTime>endDateTime s quit=1
	..
	..q:quit=1
	..
	..s rowId=""
	..f  s rowId=$o(^DHCICUOrder(0,"RecordItem",recordId,date,icuaId,time,rowId))  q:rowId=""  d
	...q:("NE"'[$p(^DHCICUOrder(rowId),"^",25))
	...s itemStr=$g(^DHCICUOrder(rowId))
	...s drugName=$p(itemStr,"^",34)
	...s value=##class(web.DHCICUOrder).GetDoseSpeed(rowId) ;Dose
	...s doseParaId=$p(itemStr,"^",38)
	...s parentId=$p(doseParaId,"||",1)
	...s childId=$p(doseParaId,"||",2)
	...
	...q:(parentId="")||(childId="")
	...s mainParaItemId=$p($g(^DHCICUPara(parentId,"I",childId)),"^",19)
	...
	...i mainParaItemId'="" s parentId=$p(mainParaItemId,"||",1) s childId=$p(mainParaItemId,"||",2)
	...q:(parentId="")||(childId="")
	...
	...s drugName=$p($p($g(^DHCICUPara(parentId,"I",childId)),"^",13),",",3)
	...;s drugName=##class(web.DHCClinicCom).SubStr(drugName,"(",")")
	...i drugName'="" d 
	....s TMPDrug(drugName)=drugName
	....//w drugName,":",value,!
	....;i $g(TMPDrug(drugName,"dose"))="" d
	....s TMPDrug(drugName,"dose")=value
	....s icuoSpeedUnitDr=$p(itemStr,"^",20)
	....s unitDesc=""
	....i icuoSpeedUnitDr'="" s unitDesc=$p($g(^DHCICUC("SUnit",icuoSpeedUnitDr)),"^",1)
	....s TMPDrug(drugName,"unit")=unitDesc
	....s TMPDrug(drugName,"DateTime")=$zd(date)_$zt(time)
	....
	....;b // value //
	
	s valueList=""
	s drugName=""  f  s drugName=$o(TMPDrug(drugName)) q:drugName=""  d
	.
	.s unitDesc=$g(TMPDrug(drugName,"unit"))
	.
	.i type="Dose" s value=drugName_"("_$g(TMPDrug(drugName,"dose"))_unitDesc_")"
	.e  s value=drugName
	.i valueList=""  s valueList=value
	.e  s valueList=valueList_","_value
	
	q valueList
}

// 获取最后一组数据

ClassMethod GetVluueByCodeList(icuaId, codeList, fromDate, fromTime, toDate, toTime, type, num = 1)
{
	// w ##class(web.DHCICUOrder).GetVluueByCodeList(3005,"HR;NMBP;AMBP;SPO2;CVP",63334,32400,63336,54000)
	
	// 以下作废	
	d InitTempicuRecordItem(icuaId)
	s count=$L(codeList,";")
	s valueList=""
	i type="LastValue" s valueList=$$FindLastValue(icuaId)
	q:valueList'="" valueList
	f j=1:1:count d
	.s rCode=$p(codeList,";",j)
	.s icucriId=0
	.s icucriId=$O(^DHCICUC("RecordItem",0,"Code",rCode,icucriId))
	.;倒序查找时方法需要重写
	.i type'="LastValue" d
	..s reStr=##class(web.DHCICUOrder).GetRecordValue(icuaId,icucriId,fromDate,fromTime,toDate,toTime,type)
	..s reStr=##class(web.DHCClinicCom).Replace(reStr,"^","-")
	..
	.e  s reStr=$$FindLastValue(icuaId) // s reStr=..GetLastValueList(icuaId,icucriId,fromDate,fromTime,toDate,toTime,num,-1)
	.//w rCode,":",reStr,!
	.q:((reStr="")||(reStr="-"))
	.s itemName=$$GetName(icuaId,icucriId)
	.i itemName="" s itemName=rCode
	.i valueList="" s valueList=itemName_":"_reStr
	.e  s valueList=valueList_"; "_itemName_":"_reStr
	q valueList
InitTempicuRecordItem(icuaId)
	// 根据个人模板生成名称的索引
	s paraRowId=""
	s paraRowId=$O(^DHCICUPara(0,"ICUA",icuaId,paraRowId))
	//q:paraRowId="" ""
	s sub="" f  s sub=$O(^DHCICUPara(paraRowId,"I",sub)) q:sub=""  d
	.s tName=$p($g(^DHCICUPara(paraRowId,"I",sub)),"^",14)
	.s viewCatDr=$p($g(^DHCICUPara(paraRowId,"I",sub)),"^",11)
	.s recordItemId=$p($g(^DHCICUPara(paraRowId,"I",sub)),"^",4)
	.q:recordItemId=""
	.s ^TempicuRecordItem(icuaId,recordItemId)=tName
	.s ^TempicuRecordItem(icuaId,recordItemId,"ViewCatDr")=viewCatDr
	
	q ""
GetName(icuaId,icucriId)
	s name=$g(^TempicuRecordItem(icuaId,icucriId))
	q name
FindLastValue(icuaId)
	s ^tmpicudebug("GetVluueByCodeList")=icuaId_" "_codeList_" "_fromDate_" "_fromTime_" "_toDate_" "_toTime_" "_type_" "_num
	s rset=##class(%ResultSet).%New("web.DHCICUOrder:FindDataByRecordId")
	s ret="",valueStr=""	
	do rset.Execute(icuaId,codeList,codeList,fromDate,fromTime,toDate,toTime,num)
	while (rset.Next()) {
	s data=rset.GetData(1)
	i valueStr="" s valueStr=data
	e  s valueStr=valueStr_$c(13)_$c(10)_data
	}
	d rset.Close()
	s valueStr=##class(web.DHCClinicCom).Replace(valueStr,";","; ")
	q valueStr
}

// 根据icuaId、开始时间、结束时间，返回出入量平衡

// 返回: inVol_"/"_+outVol

ClassMethod GetIORate(icuaId, fromDate, fromTime, toDate, toTime)
{
	// W ##class(web.DHCICUOrder).GetIORate(icuaId,fromDate,fromTime,toDate,toTime)
	i '$ISVALIDNUM(fromDate) s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	i '$ISVALIDNUM(fromTime) s fromTime=##class(web.DHCClinicCom).ConvertToTimeH(fromTime)
	i '$ISVALIDNUM(toDate) s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	i '$ISVALIDNUM(toTime) s toTime=##class(web.DHCClinicCom).ConvertToTimeH(toTime)
	s inVol=0,outVol=0
	//b // xxxxxxxxxx
	s wardCtlocId=##Class(web.DHCICUCom).GetWardCtlocId("",icuaId)
	q:wardCtlocId="" "" ;登陆科室ID为空
	s sub="" f  s sub=$O(^DHCICUC("IOItem",0,"Ctloc",wardCtlocId,sub)) q:sub=""  d
	.s itemStr=^DHCICUC("IOItem",sub)
	.s icucriId=$p(itemStr,"^",4)	
	.q:icucriId=""
	.s mainItemId=$p(^DHCICUC("IOItem",sub),"^",9)
	.q:mainItemId=""
	.s mainItemCode=$p($g(^DHCICUC("IOItem",mainItemId)),"^",1)
	.q:mainItemCode=""
	.q:$d(TMPRecord(icucriId)) // 配置中是一种平衡一个配置向,一个常用医嘱ID会对应多条记录
	.
	.s TMPRecord(icucriId)=icucriId
	.s code=$p(itemStr,"^",2)
	.s flag=$p(itemStr,"^",3)
	.s value=##class(web.DHCICUOrder).GetLastValueList(icuaId,icucriId,fromDate,fromTime,toDate,toTime,1000*1000,1,"Sum")
	.q:value=""
	.;w flag_" "_sub_" "_code_"("_icucriId_")"_":"_value,!
	.s sumVol=+$g(TMPVol(mainItemCode))
	.s sumVol=+value+sumVol
	.s TMPVol(mainItemCode)=sumVol
	s inVol=$g(TMPVol("TotalIn"))
	s outVol=$g(TMPVol("TotalOut"))
	//b //GetIORate
	q inVol_"/"_+outVol
}

ClassMethod GetTestResult(regNo, standardCode, fromDate, fromTime, toDate, toTime, num = 1, type = "DateTime", order = -1, quryDateTime = 0) As %String
{
	//w ##class(web.DHCICUDebug).GetTestResult(regNo,standardCode, fromDate, fromTime, toDate, toTime,type,num)
	i '$ISVALIDNUM(fromDate) s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	i '$ISVALIDNUM(fromTime) s fromTime=##class(web.DHCClinicCom).ConvertToTimeH(fromTime)
	i '$ISVALIDNUM(toDate) s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	i '$ISVALIDNUM(toTime) s toTime=##class(web.DHCClinicCom).ConvertToTimeH(toTime)	
	q:standardCode="" ""
	s sOneDay=24*3600
	s testCode="",retStr="",fromDateTime=fromDate*sOneDay+fromTime,toDateTime=toDate*sOneDay+toTime
	f  s testCode=$o(^TTABi("TC","NNL",standardCode,testCode)) q:testCode=""  d
	.d TestFun
	//w retStr,!
	q retStr
TestFun		
	// 初始化查询条件
	s Quit=0,count=0
	i order=1 s date=fromDate-1
	e  s date=toDate+1
	// 查询
	f  s date=$o(^TDHCOldResult(1,regNo,testCode,date),order)  q:(date="")!(Quit)  d
	.i order=1 d
	..i date=fromDate s time=fromTime-1
	..e  s time=-1
	.e  d
	..i date=toDate s time=toTime+1
	..e  s time=sOneDay+1
	.f  s time=$o(^TDHCOldResult(1,regNo,testCode,date,time),order)  q:(time="")!(Quit)  d
	..s dateTime=date*sOneDay+time
	..//w $zd(date)," ",$zt(time),!
	..i ((dateTime>toDateTime)||(dateTime<fromDateTime)) s Quit=1 
	..
	..s labNo="" f  s labNo=$o(^TDHCOldResult(1,regNo,testCode,date,time,labNo)) q:(labNo="")!(Quit)  d
	...s testSet="" f  s testSet=$o(^TDHCOldResult(1,regNo,testCode,date,time,labNo,testSet)) q:testSet=""  d
	....// 处理数据
	....d ProcessData(regNo,testCode,date,time,labNo,testSet)
	
ProcessData(regNo,testCode,date,time,labNo,testSet)
	s sub=$o(^TDHCOldResult(1,regNo,testCode,date,time,labNo,testSet,""))
	s result=$p(^TEPI(labNo,1,testSet,sub,"DATA",testCode),"\",1)
	s receiveDate=$p(^TEPI(labNo,1,testSet,sub),"\",1)
	s receiveTime=$p(^TEPI(labNo,1,testSet,sub),"\",2)
	s receiveDateTime=receiveDate*sOneDay+receiveTime
	//i ((receiveDateTime>toDateTime)||(receiveDateTime<fromDateTime)) s Quit=1
	b
	q:Quit
	q:((quryDateTime>0)&&(dateTime'=quryDateTime))
	i type="DateTime" d
	.i retStr="" s retStr=dateTime
	.e  s retStr=retStr_"^"_dateTime
	e  d
	.s range=$g(^TEPI(labNo,1,testSet,sub,"DATA",testCode,"Ranges"))
	.s unit=$g(^TEPI(labNo,1,testSet,sub,"DATA",testCode,"Unit"))
	.s testDesc=$p($g(^TTAB("TC",testCode)),"\",12)
	.i retStr'="" s retStr=retStr_"^"
	.s retStr=retStr_result_"\"_unit_"\"_range_"\"_receiveDate_"\"_receiveTime_"\"_testDesc
	s count=count+1
	i num<=count s Quit=1
}

/// 返回值格式: Value1^Value1^Value3...
///             Value的是以"^"分隔开的，数量顺序由queryId中配置确定
/// 			用queryId中的查询项目查询，然后以queryId显示项目显示
/// scope       :  查询数据时的查找范围
/// icuaId      : DHC_ICU_Arrange的RowId
/// queryIdStr  : 要查询的Id串，是逻辑与的关系，同一时间内包含所以ID才能满足条件
/// codeList 要显示的ID串
/// fromDate,fromTime: 起始时间点
/// toDate,toTime    : 结束时间点 
///        toDate是0时，查询fromDate的fromTime开始fromDate这一天的数据
/// 查找显示项的时间范围，为0时精确查找
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","FindDataByRecordId",icuaId,queryId)
Query FindDataByRecordId(icuaId, queryStr, codeList, fromDate = 0, fromTime = 0, toDate = 0, toTime = 0, dataCount = 2, type = "Gas") As %Query(ROWSPEC = "Items:%String") [ SqlProc ]
{
}

ClassMethod FindDataByRecordIdExecute(ByRef qHandle As %Binary, icuaId, queryStr, codeList, fromDate = 0, fromTime = 0, toDate = 0, toTime = 0, dataCount = 2, type = "Gas") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1	
	s STX=$c(2)
	s ETX=$c(3)
	
	// D ##class(%ResultSet).RunQuery("web.DHCICUDebug","FindDataByRecordId",icuaId,queryStr,codeList)
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	s fromTime=##class(web.DHCClinicCom).ConvertToTimeH(fromTime)
	s fromTime=##class(web.DHCClinicCom).ConvertToTimeH(toTime)
	d InitTempicuRecordItem(icuaId)
	s scope=0
	i ((fromDate)&(toDate=0)) d
	.;查fromdate一天的数据
	.s toDate=fromDate+1
	.s toTime=0
	s daySecs=3600*24
	s fromDateTime=(daySecs*fromDate)+fromTime
	s toDateTime=(daySecs*toDate)+fromTime
	s queryStr=$p(queryStr,";",1)
	s queryCodeCount=$L(queryStr,";"),queryIdStr=""
	f i=1:1:queryCodeCount d
	.s code=$p(queryStr,";",i)
	.s id=""
	.s id=$O(^DHCICUC("RecordItem",0,"Code",code,id))
	.i queryIdStr="" s queryIdStr=id
	.e  s queryIdStr=queryIdStr_"^"_id
	
	s queryIdCount=$l(queryIdStr,"^")	
	s icucriId=$p(queryIdStr,"^",1)
	q:icucriId="" $$$OK	
	
	s dateTimeList=##class(web.DHCICUOrder).GetLastValueList(icuaId,icucriId,fromDate,fromTime,toDate,toTime,dataCount,-1,"DateTime")
	
	// 通过displayIdStr中的ID取各时间点的数据
	s dateTimeCount=$L(dateTimeList,",")
	s index=1  f index=1:1:dateTimeCount  d
	.s dateTime=$p(dateTimeList,",",index)
	.s qDate=dateTime\daySecs
	.s qTime=dateTime#daySecs
	.q:qDate<=0
	.s regNo=##class(web.DHCICUStat).GetInfoByIcuaId(icuaId,"regNo")
	.s valueStr=$$OneTimePoint(icuaId,codeList,qDate,qTime,regNo)
	.s ret=$$OutputRow1(valueStr)
	.//w valueStr,!
	..
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OneTimePoint(icuaId,codeList,qDate,qTime,regNo)
	// 返回一个电间点各查寻项目的值
	s dateTime=$zd(qDate,3)_" "_$zt(qTime)
	//w "DateTime:",dateTime,!
	s codeCount=$L(codeList,";")
	s valueStr=dateTime
	b /////////
	
	s i=1 f i=1:i:codeCount d
	.s code=$p(codeList,";",i)
	.//w code,!
	.i type="Lab"
	..s value=##class(web.DHCClinicCom).GetTestResultByScope("", regNo, "", code, qDate, qTime,scope, isSingle)
	..s value=$p(value,STX,1)
	..i value'="" 
	.e  i type="Gas" d
	..;血气
	..s recordId="" s recordId=$O(^DHCICUC("RecordItem",0,"Code",code,recordId))
	..s value=##class(web.DHCICUOrder).GetRecordValueByScope(icuaId,recordId,qDate,qTime,scope)
	..s value=$$GetName(icuaId,recordId)_":"_value
	.s valueStr=valueStr_";"_value
	q valueStr

GetStatus(rowId)
	q:'##class(User.DHCICUOrder).%ExistsId(rowId) "Invalid RowId"
	s obj=##class(User.DHCICUOrder).%OpenId(rowId)
	s editFlag=obj.ICUOEditFlag
	d obj.%Close()	
	q editFlag
InitTempicuRecordItem(icuaId)
	// 根据个人模板生成名称的索引
	s paraRowId=""
	s paraRowId=$O(^DHCICUPara(0,"ICUA",icuaId,paraRowId))
	//q:paraRowId="" ""
	s sub="" f  s sub=$O(^DHCICUPara(paraRowId,"I",sub)) q:sub=""  d
	.s tName=$p($g(^DHCICUPara(paraRowId,"I",sub)),"^",14)
	.s viewCatDr=$p($g(^DHCICUPara(paraRowId,"I",sub)),"^",11)
	.s recordItemId=$p($g(^DHCICUPara(paraRowId,"I",sub)),"^",4)
	.q:recordItemId=""
	.s ^TempicuRecordItem(icuaId,recordItemId)=tName
	.s ^TempicuRecordItem(icuaId,recordItemId,"ViewCatDr")=viewCatDr
	
	q ""
GetName(icuaId,icucriId)
	s name=$g(^TempicuRecordItem(icuaId,icucriId))
	q name
OutputRow1(data)
	set Data=$lb(data)
 	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit ind
}

ClassMethod FindDataByRecordIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDataByRecordIdExecute ]
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

ClassMethod FindDataByRecordIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDataByRecordIdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// 根据医嘱码表判断是否是抗微生物药物

ClassMethod IsAntibiotic(arcimId)
{
	// w ##class(web.DHCICUOrder).IsAntibiotic(arcimId)
	s phcSubCat=""
	s arcimObj=##Class(User.ARCItmMast).%OpenId(arcimId)
	s $ZT="ERROR"
	s phcSubCat=arcimObj.ARCIMPHCDFDR.PHCDFPHCDParRef.PHCDPHCSCDR.%Id()
	// w arcimObj.ARCIMPHCDFDR.PHCDFPHCDParRef.PHCDPHCSCDR.PHCSCDesc,!
	d arcimObj.%Close()
	q:phcSubCat="" 0
	s viewCatId=$O(^DHCICUC("ViewCat",0,"AntimicrobialAgents",""))
	s catList=$p($g(^DHCICUC("ViewCat",viewCatId)),"^",7)
	q ("~"_catList_"~")[("~"_phcSubCat_"~")
ERROR
	s phcSubCat=""
	i arcimObj'="" d arcimObj.%Close()
	q 0
}

Query FindIcuCollectDataBySQL(icuaId As %String, startDate As %String, startTime As %String, endDate As %String, endTime As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select %ID As Id,
		ICUCD_ComOrd_Dr As RecordItemId,
		ICUCD_Parref As IcuaId,
		ICUCD_StartDate As StartDate,
		ICUCD_StartTime As StartTime,
		ICUCD_Note As Note,
		ICUCD_Qty As Qty,
		ICUCD_UpdateDate As UpdateDate,
		ICUCD_UpdateTime As UpdateTime
		from DHC_ICU_CollectData
		where ICUCD_Parref=:icuaId and ICUCD_StartDate>=:startDate and ICUCD_StartDate<=:endDate
}

Query FindIcuOrderBySQL(icuaId As %String, startDate As %String, startTime As %String, endDate As %String, endTime As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select %ID As Id,
		   ICUO_ICUA_Dr As IcuaId,
		   ICUO_ComOrd_Dr As RecordItemId,
		   ICUO_Oeore_Dr As OEOreId,
		   ICUO_User_Dr As UserId,
		   ICUO_StartDate As StartDate,
		   ICUO_StartTime As StartTime,
		   ICUO_EndDate As EndDate,
		   ICUO_EndTime As EndTime,
		   ICUO_Arcim_Dr As ArcimId,
		   ICUO_Note As Note,
		   ICUO_Qty As Qty,
		   ICUO_Uom_Dr As UomId,
		   ICUO_Concentration As Concentration,
		   ICUO_OriginateFromICUO_Dr As OriginalOrderId,
		   ICUO_Instr_Dr As InstrId,
		   ICUO_ViewCat_Dr As RecordCatId,
		   ICUO_Speed As Speed,
		   ICUO_SpeedUnit_Dr As SpeedUnitId,
		   ICUO_UpdateDate As UpdateDate,
		   ICUO_UpdateTime As UpdateTime,
		   ICUO_EditFlag As EditFlag,
		   ICUO_DocUser_Dr As DocUserId,
		   ICUO_Volume As Volume,
		   ICUO_Source As Source,
		   ICUO_PreparedVolume As PreparedVolume,
		   ICUO_Abbreviate As Abbreviate,
		   ICUO_Remarks As Remarks,
		   ICUO_ICUPI_Dr As ParaItemId,
		   ICUO_TotalQty As TotalQty
		   from dhc_icu_order
		   where ICUO_ICUA_Dr=:icuaId and ICUO_StartDate>=:startDate and ICUO_StartDate<=:endDate and ICUO_EditFlag in ('N','E') and ICUO_Source in ('M','A','I')
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

/// 调用检验结果
/// d ##class(web.DHCICUOrder).InsertICUOrderByOeordId()
ClassMethod InsertICUOrderByOeordId()
{
	s ^tmpICUDebug("LabF",$p($h,",",1),$p($h,",",2))="in: "_$zdate($p($h,",",1))_" "_$ztime($p($h,",",2))
	s $zt="ERROR"
	s icubeId=0,sttDate=+$h
	f  s icubeId=$o(^DHCICUBedEquip(icubeId)) q:icubeId=""  d
		.s bedId=$p(^DHCICUBedEquip(icubeId),"^",1)
		.q:bedId=""
		.;b ;1
		.s interval=$p(^DHCICUBedEquip(icubeId),"^",6)
		.s bStat=$p(^DHCICUBedEquip(icubeId),"^",8)
		.q:'$d(^DHCICUArrange(0,"BedStatus",bedId,"M"))
		.s icuaId=$o(^DHCICUArrange(0,"BedStatus",bedId,"M",""))
		.q:icuaId="" 	
		.s AdmId=$p($g(^DHCICUArrange(icuaId)),"^",1)
		.s oeordId=$o(^OEORD(0,"Adm",AdmId,""))
		.q:oeordId=""
		.s oeoriSub=0
		.f  s oeoriSub=$o(^OEORDi(0,"StDt",sttDate,oeordId,oeoriSub)) q:(oeoriSub="")  d
			..;b	;2
			..s OrdStr1=$g(^OEORD(oeordId,"I",oeoriSub,1))
			..s OrdStr3=$g(^OEORD(oeordId,"I",oeoriSub,3))
			..s ItmMastDr=$p(OrdStr1,"^",2)
			..q:ItmMastDr=""
			..q:(..isLabTS(ItmMastDr)'=1)
			..;b	;3
			..s ordInfo=$G(^OEORD(oeordId,"I",oeoriSub,3)) 
			..s labinfo=$p(ordInfo,"^",35)
			..s labno=$p(labinfo,"||",1)	;检验号
			..q:labno=""
			..s ts=$p(labinfo,"||",2)	;医嘱套编码
			..q:ts=""
			..s tscnt=$p(labinfo,"||",3)	
			..q:tscnt=""
			..s tc=""
		    ..f  s tc=$Order(^TEPI(labno,1,ts,tscnt,"DATA",tc)) Quit:tc=""  Do
			    ...s resstr=$p(^(tc),"\",1)
			 	...s NationLong=$p(^TTAB("TC",tc),"\",12)
			 	...;通过nationlog知道对应的常用医嘱,没有则不插入,如果几个项目中都有Na怎么处理
			 	...q:NationLong=""
			 	...q:$d(^DHCICUC("RecordItem",0,"Code",NationLong))<0
		 		...s comOrdId=$o(^DHCICUC("RecordItem",0,"Code",NationLong,""),-1)
		 		...q:comOrdId=""
			 	...s temres=##class(DHCLabToEPR.DHCLabTestSetQuery).GetTestCodeResult(labno,tc,resstr)
			 	...s ItemDesc=$p(temres,$Char(2),2)
			 	...s ItemResult=$p(temres,$Char(2),3)
			 	...s reportDate=$p(^TEPI(labno,1,ts,tscnt),"\",4)
			 	...s reportTime=($p(^TEPI(labno,1,ts,tscnt),"\",5))*60
			 	...	s ^tmpICUDebug("LabF2",$p($h,",",1),$p($h,",",2))="in: "_$zdate($p($h,",",1))_" "_$ztime($p($h,",",2))
			 	...s value=..InTCICUOrder(icuaId,comOrdId,reportDate,reportTime,ItemResult,"")
	
ERROR
	s ^tmpICUDebug("LabF")=$ZE
}

ClassMethod InTCICUOrder(icuaId As %String, icucriId As %String, date As %String, time As %String, numValue As %String, txtValue As %String) As %String
{
	//w ##Class(web.DHCICUCom).Insert2ICUOrder(icuaId, icucriId, date, time,numValue, txtValue)
	s rowId="" ,retStr=0
	// 查询后插入
	s isFind=0
	s sub=""
	f  s sub=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId,time,sub)) q:((sub="")||(isFind=1))  d
	.s ctuomId=$p($g(^DHCICUOrder(sub)),"^",2)
	.i ctuomId=icucriId s isFind=1 s rowId=sub
	
	s paraItemRowId=""
	s paraRowId="" f  s paraRowId=$o(^DHCICUPara(0,"ICUA",icuaId,paraRowId)) q:paraRowId=""  d
	.s paraSub=""  f  s paraSub=$o(^DHCICUPara(paraRowId,"I",paraSub)) q:paraSub=""  d
	..q:$d(^DHCICUPara(paraRowId,"I",paraSub))<1
	..s comOrdId=$p($g(^DHCICUPara(paraRowId,"I",paraSub)),"^",4)
	..if comOrdId=icucriId  d
	...s paraItemRowId=paraRowId_"||"_paraSub
	
	// 已存在则修改，否则插入数据
	i isFind=1  d
		.
		.s retStr=$$UPDATE()
	e  s retStr=$$INSERT()
	q retStr
INSERT()		
	s PLIST(2)=icuaId //icuaId
	s PLIST(3)=icucriId //icucriId
	s PLIST(5)="" //userId
	s PLIST(6)=date //startDate
	s PLIST(7)=time //startTime
	s PLIST(8)=date //endDate
	s PLIST(9)=time //endTime
	s PLIST(11)=txtValue
	s PLIST(12)=numValue
	s PLIST(13)="" //ctuomId
	s PLIST(17)=$p($g(^DHCICUC("RecordItem",icucriId)),"^",5) //ancvcId
	s PLIST(18)="N" //ICUO_Flag
	s PLIST(22)=+$h //ICUO_UpdateDate
	s PLIST(23)=$p($h,",",2) //ICUO_UpdateTime
	s PLIST(24)="" //ICUO_ICUO_Dr
	s PLIST(26)="N" //ICUO_EditFlag
	s PLIST(30)="I" //ICUO_ICUO_Source
	s PLIST(31)=$p($g(^DHCICUC("RecordItem",icucriId)),"^",3) //ICUO_Type
	
	s PLIST(39)=paraItemRowId
	&SQL(Insert into DHC_ICU_Order Values :PLIST())

	i SQLCODE s retStr=icuaId_":ICU SQLCODE:"_SQLCODE //icuoId"插入数据错! SQLCode="_SQLCODE
	q SQLCODE
	
UPDATE()
	s updateTime=$p($h,",",2)
	s updateDate=+$h
	&sql(update DHC_ICU_Order set ICUO_UpdateTime=:updateTime,
	 ICUO_UpdateDate=:updateDate ,
	 ICUO_Note=:txtValue,
	 ICUO_Qty=:numValue
	 where ICUO_RowId=:rowId
	 )	
	i SQLCODE=0 q 1
	e  q SQLCODE
}

// 无创血压入库

ClassMethod NBPConfirmData(icuaId, dstDate, dstTime, scope = 3600)
{
	// w ##class(web.DHCICUOrder).NBPConfirmData(4497, "2014-11-11", "10:00")
	i dstDate'=+dstDate s dstDate=##class(web.DHCClinicCom).ConvertToDateH(dstDate)
	i dstTime'=+dstTime s dstTime=##class(web.DHCClinicCom).ConvertToTimeH(dstTime)
	
	s NBPs="NSBP",NBPd="NDBP",NBPm="NMBP",NBP="NBP",isExit=0
	// 如果存在配置，则加载配置
	i $g(^DHCCLSet("ICU","NBPs"))'="" s NBPs=$g(^DHCCLSet("ICU","NBPs"))
	i $g(^DHCCLSet("ICU","NBPd"))'="" s NBPd=$g(^DHCCLSet("ICU","NBPd"))
	i $g(^DHCCLSet("ICU","NBPm"))'="" s NBPm=$g(^DHCCLSet("ICU","NBPm"))
	i $g(^DHCCLSet("ICU","NBP"))'="" s NBP=$g(^DHCCLSet("ICU","NBP"))
	
	s NBPsId=$O(^DHCICUC("RecordItem",0,"Code",NBPs,""))
	s NBPdId=$O(^DHCICUC("RecordItem",0,"Code",NBPd,""))
	s NBPmId=$O(^DHCICUC("RecordItem",0,"Code",NBPm,""))
	s NBPId=$O(^DHCICUC("RecordItem",0,"Code",NBP,""))
	i ((NBPsId="")||(NBPdId="")||(NBPmId="")) d
	.s ^TMPICUDEBUG("NBPConfirmData",+$h)=##class(web.DHCClinicCom).ConvertToDate(date)_" "_##class(web.DHCClinicCom).ConvertToTime(time)_NBPsId_"/"_NBPdId_"/"_NBPmId
	
	s index=0
	s date="" f  s date=$O(^DHCICUArrange(0,"CData",icuaId,date),-1) q:((isExit)||(date=""))  d
	.i date=dstDate s time=dstTime+1
	.e  s time=""
	.f  s time=$O(^DHCICUArrange(0,"CData",icuaId,date,time),-1) q:((isExit)||(time=""))  d
	..i $zabs(((date*3600*24)+time)-((dstDate*3600*24)+dstTime))>scope s isExit=1 q 
	..
	..s sys=..FindCollectData(icuaId,date,time,NBPsId)
	..q:sys=""
	..s dia=..FindCollectData(icuaId,date,time,NBPdId)
	..s mean=..FindCollectData(icuaId,date,time,NBPmId)
	..s calMean=(sys*(1/4))+(dia*(3/4))
	..//===========入库==============
	..w icuaId_" "_##class(web.DHCClinicCom).ConvertToDate(date)_" "_##class(web.DHCClinicCom).ConvertToTime(time)_"  "_sys_"/"_dia_"/"_mean,!
	..s isExit=1 ; 只找最近的一组数据
	..
	..i ..FindAnyDataFromCollectData(icuaId,dstDate,dstTime) d
	...; 如果半小时之内有其他生命体征数据，则认为病人仍在ICU,需要入库；否则，认为已离开ICU，不将无创血压填写在curTime
	...; 以下入库方式可能会修改用户添加的数据,但因为采集的数据更客观所以覆盖(也避免重复调用时产生多条数据引起数据库爆涨)
	...s sysId=##class(web.DHCICUCom).Insert2ICUOrder(icuaId,NBPsId,dstDate,dstTime,sys,"")
	...s diaId=##class(web.DHCICUCom).Insert2ICUOrder(icuaId,NBPdId,dstDate,dstTime,dia,"")
	...s meanId=##class(web.DHCICUCom).Insert2ICUOrder(icuaId,NBPmId,dstDate,dstTime,mean,"")
	...s nbpId=##class(web.DHCICUCom).Insert2ICUOrder(icuaId,NBPId,dstDate,dstTime,"",sys_"/"_dia_"("_mean_")")
	...s ^tmpdebug("dtj-nbp",icuaId,dstDate,dstDate,NBPs)=sysId_" "_sys_" "_##class(web.DHCClinicCom).ConvertToDate(date)_" "_##class(web.DHCClinicCom).ConvertToTime(time)
	...s ^tmpdebug("dtj-nbp",icuaId,dstDate,dstDate,NBPd)=diaId_" "_dia_" "_##class(web.DHCClinicCom).ConvertToDate(date)_" "_##class(web.DHCClinicCom).ConvertToTime(time)
	...s ^tmpdebug("dtj-nbp",icuaId,dstDate,dstDate,NBPm)=meanId_" "_mean_" "_##class(web.DHCClinicCom).ConvertToDate(date)_" "_##class(web.DHCClinicCom).ConvertToTime(time)
	..i ((mean>=sys)||(mean<=dia)) d
	...; ========异常数据入库==========
	...s str="icuaId:"_icuaId_"  "_##class(web.DHCClinicCom).ConvertToDate(date)_" "_##class(web.DHCClinicCom).ConvertToTime(time)_"  "_sys_"/"_dia_"/"_mean
	...//w str,!
	...s dateStr=##class(web.DHCClinicCom).ConvertToDate(date)
	...s ^tmpdebug("dtj-Collect",dateStr,icuaId,index)=str
	...s index=index+1
	q "Over"
}

// 从DHC_ICU_CollectData表中查找某时间点的数据

ClassMethod FindCollectData(icuaId, date, time, recordId)
{
	i date'=+date s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i time'=+time s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	s value="",itemId=""
	s i="" f  s i=$O(^DHCICUArrange(0,"CData",icuaId,date,time,i)) q:((i="")||(recordId=itemId))  d
	.s itemStr=$g(^DHCICUArrange(icuaId,"C",i))
	.s itemId=$p(itemStr,"^",1)
	.i recordId=itemId d
	..s value=$p(itemStr,"^",5)
	
	q value
}

// 查找curDate,curTime近scope秒内是否有数据

// 如curDate=2014-11-11，curTime=09:00，则查寻09:30到10:00的数据

ClassMethod FindAnyDataFromCollectData(icuaId, curDate, curTime, scope = 1800)
{
	// w ##class(web.DHCICUOrder).FindAnyDataFromCollectData(icuaId,curDate,curTime)
	i curDate'=+curDate s curDate=##class(web.DHCClinicCom).ConvertToDateH(curDate)
	i curTime'=+curTime s curTime=##class(web.DHCClinicCom).ConvertToTimeH(curTime)
	s findData=0,isExit=0
	s date="" f  s date=$O(^DHCICUArrange(0,"CData",icuaId,date),-1) q:((isExit)||(date=""))  d
	.i date=curDate s time=curTime+1
	.e  s time=""
	.f  s time=$O(^DHCICUArrange(0,"CData",icuaId,date,time),-1) q:((isExit)||(time=""))  d
	..i $zabs(((date*3600*24)+time)-((curDate*3600*24)+curTime))>scope s isExit=1 q 
	..s findData=1
	..s isExit=1
	..w $zt(time),!
	q findData
}

ClassMethod ConfirmHFCollectData(isDebug As %String = "") As %String
{
	// w ##class(web.DHCICUOrder).ConfirmHFCollectData()
	SET $ZTRAP="ERR"
	s time=$p($h,",",2)
	s hour=time\3600
	s min=(time-(hour*3600))\60
	s dStr=$zd($p($h,",",1))
	s iDate=+$p(dStr,"/",2)
	
	
	s ^tmpICUDebug("ConfirmHFCollectData","First")=$zt($p($h,",",2))
	s bedId="" s locId="" s retStr=""
	// 查找DHC_ICU_BedEquip表中配置的所以病区的locId
	f  s bedId=$O(^DHCICUBedEquip(0,"Bed",bedId)) q:bedId=""  d
	.s wardId=+bedId
	.s wardLocId=$p($g(^PAWARD(+wardId)),"^",5)
	.q:wardLocId=""
	.s PLIST(wardLocId)=wardLocId
	// 循环执行每一个科室
	m ^TMPICUDEBUG("ConfirmHFCollectData","locId")=PLIST
	f  s locId=$O(PLIST(locId)) q:locId=""  d
	.SET $ZTRAP="ERR"
	.b
	.q:isDebug'=""
	.// 血滤每小时自动填充数据
	.w ##class(web.DHCICUOrder).LoadHFData(locId)
	.
ERR
	s ^TMPICUDEBUG("ConfirmHFCollectData",iDate,$ztime($p($h,",",2)))=$zerror
	q "-1"
}

// 血滤每小时自动填充采集数据

ClassMethod LoadHFData(ctlocId, date = "", time = "")
{
	// w ##class(web.DHCICUOrder).LoadHFData(ctlocId,date,time)
	i date="" s date=+$H
	i time="" s time=$p($H,",",2)
	i date'=+date s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i time'=+time s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	s wardId=""
	s patientList=##class(web.DHCICUCom).FindWardPatient(wardId, ctlocId)
	
	i date'=+date s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i time'=+time s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	S $ZT="ERRORLoadHFData"
	q:patientList="" 0
	s scope=3600
	
	s time=((time+(scope/2))\3600)*3600 // 四舍五入
	
	f i=1:1:$l(patientList,"^") d
	.q:$p(patientList,"^",i)=""
	.s icuaId=$p($p(patientList,"^",i),"|",4)
	.q:icuaId=""
	.w "icuaId: ",icuaId," ",$zd(date),$zt(time),!
	.s ^tmpicudebug("HF",icuaId,$zd(date),$zt(time))=$zd(date)_" "_$zt(time)
	.d ..LoadHFPatData(icuaId,date,time)
	q "Success"
ERRORLoadHFData
	s ^tmpicudebug("LoadHFData-Error",+$h,$p($h,",",2))=$ZERROR
}

// 测试

ClassMethod LoadByData(icuaId, date)
{
	// w ##class(web.DHCICUOrder).LoadByData(icuaId,date)
	f i=0:1:23 d
	.d ..LoadHFMainItemData(icuaId,date,i*3600)
	.
	q "SUCCESS"
}

// 按icuaId和时间点生成血滤数据

// 如time:07:00则生成06:00的数据

ClassMethod LoadHFPatData(icuaId, date, time)
{
	// w ##class(web.DHCICUOrder).LoadHFPatData(icuaId,date,time)
	i date'=+date s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i time'=+time s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	s insertDate=date,insertTime=time-3600
	i insertTime<0 s insertDate=date-1,insertTime=23*3600
	d Init
	s ^tmpICUDebug("ConfirmHFCollectData",icuaId,date,time)=icuaId
	s sub="" f  s sub=$O(tmpicudebug(sub)) q:sub=""  d
	.s cumulatId=+$g(tmpicudebug(sub))
	.s paraItemId=$g(tmpicudebug(sub,"ParaItemId"))
	.
	.i cumulatId>0 d
	..s value=..GetValueOfHour(icuaId,cumulatId,date,time)
	..
	..i value'="" d
	...
	...d ##class(web.DHCICUCom).Insert2ICUOrder(icuaId,sub,insertDate,insertTime,value,"",paraItemId)
	...
	.e  d
	..s setValueDate=date
	..i time=0 s setValueDate=date-1 s setValueTime=23*3600
	..e  s setValueTime=(time-3600)
	..
	..s value=..GetLastValue(icuaId,sub,setValueDate,setValueTime)
	..
	..&sql(select ICUCRI_DataField into:field from DHC_ICUC_RecordItem where ICUCRI_RowId=:sub)
	..s note=""
	..i field'="Qty" s note=value,value=""
	..
	..d ##class(web.DHCICUCom).Insert2ICUOrder(icuaId,sub,insertDate,insertTime,value,note,paraItemId)
	..
	d ##class(web.DHCICUOrder).LoadHFMainItemData(icuaId,insertDate,insertTime)
	q ""
Init
    NEW %ROWCOUNT,%ROWID
    s SQLCODE=""
    SET name="LastName,FirstName",state="##"
    &sql(DECLARE EmpCursor CURSOR FOR 
        SELECT ICUCRI_RowId, ICUCRI_SummaryICUCRI_Dr
        INTO :recordItemId,:summaryRecordItemId FROM DHC_ICUC_RecordItem
        WHERE ICUCRI_ViewCat_Dr=249)
   
    &sql(OPEN EmpCursor)
    FOR { &sql(FETCH EmpCursor)
        QUIT:SQLCODE
        s paraItemId=""
        
        &sql(select top 1 ICUPI_RowId into:paraItemId from dhc_icu_paraitem where ICUPI_Parref->ICUP_ICUA_Dr=:icuaId and ICUPI_ComOrd_Dr=:recordItemId Order by ICUPI_ChildSub desc)
         i (paraItemId'="") d 
        .
        .s rootParaItem=""
        .&sql(SELECT ICUPI_ICUPI_Dr into :rootParaItem FROM DHC_ICU_ParaItem WHERE ICUPI_RowId=:paraItemId)
        .s isTemp=$$IsTemplate(rootParaItem)
        .i ('isTemp) d ; 如果是模板项目则不作处理
        ..s tmpicudebug(recordItemId)=summaryRecordItemId
        ..s tmpicudebug(recordItemId,"ParaItemId")=paraItemId
        ..;s ^tmpICUDebug("ConfirmHFCollectData",icuaId,"ParaItemId",recordItemId)=paraItemId
        ..
   }
   &sql(CLOSE EmpCursor)
   q
IsTemplate(paraItemId)
	s templateCount=0
	&sql(SELECT count(*) into:templateCount FROM DHC_ICU_ParaItemDetail 
	WHERE ICUPID_Parref=:paraItemId AND 
	ICUPID_ICUCP_Dr->ICUCP_Code='IsTemplate')
	q (templateCount>0)
}

// 加载CRRT主项数据

// 如date:2015-04-22,time:07:00 ,则从07:00时间点查找子项放到07:00

ClassMethod LoadHFMainItemData(icuaId, date, time)
{
	// w ##class(web.DHCICUOrder).LoadHFMainItemData(icuaId,date,time)
	i date'=+date s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i time'=+time s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	//s insertDate=date,insertTime=time-3600
	//i insertTime<0 s insertDate=date-1,insertTime=23*3600
	s ^tmpicudebug("LoadHFMainItemData",icuaId,date,time)=icuaId
	// CRRT主项
	s CRRTMainCode="UserDefinedxueyelvguoJINBAO"
	s CRRTMainId=""
	&sql(SELECT ICUCRI_RowId into:CRRTMainId FROM DHC_ICUC_RecordItem WHERE ICUCRI_Code=:CRRTMainCode)
	q:CRRTMainId="" "未找到CRRT主项"
	s paraItemId=""
	&sql(select top 1 ICUPI_RowId into:paraItemId from dhc_icu_paraitem where ICUPI_Parref->ICUP_ICUA_Dr=:icuaId and ICUPI_ComOrd_Dr=:CRRTMainId Order by ICUPI_ChildSub desc)
	q:paraItemId="" "没有找到paraItemId"
	s dataFormat="",formatField=""
	&sql(select ICUCRI_DataFormat,ICUCRI_FormatField into:dataFormat,:formatField from DHC_ICUC_RecordItem where ICUCRI_RowId=:CRRTMainId)
	s value=dataFormat
	s count=$L(formatField,";")
	s find="false"
	f j=0:1:count d
    .s fStr=..Replace("{N}","N",j)
    .s subRecordItemCode=$p(formatField,";",(j+1))
    .s recordItemId=""
    .s iValue="",txtValue=""
    .&sql(SELECT ICUCRI_RowId into:recordItemId FROM DHC_ICUC_RecordItem WHERE ICUCRI_Code=:subRecordItemCode)
    .i recordItemId'="" d
    ..&sql(SELECT ICUO_Qty,ICUO_Note into:iValue,:txtValue FROM DHC_ICU_Order WHERE ICUO_ICUA_Dr=:icuaId AND ICUO_ComOrd_Dr=:recordItemId AND ICUO_StartDate=:date AND ICUO_StartTime=:time)
    ..
    ..s oneValue=""
    ..i iValue'="" s oneValue=iValue
    ..e  i txtValue'="" s oneValue=txtValue
    ..s value=..Replace(value,fStr,oneValue)
    ..i oneValue'="" s find="true"
    
    i find="true" d
    .i $p(value,"/",1)="" s value=$p(value,"/",2)
    .d ##class(web.DHCICUCom).Insert2ICUOrder(icuaId,CRRTMainId,date,time,"",value,paraItemId)
    q "0"
}

ClassMethod GetValueOfHour(icuaId, recordItemId, date, time)
{
	// w ##class(web.DHCICUOrder).GetValueOfHour(icuaId,recordItemId,date,time)
	i date'=+date s date=##class(web.DHCClinicCom).ConvertToDateH(date)

	i time'=+time s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	s postValue="",preValue="" ;后一个值，前一个值
	s postValue=..GetLastValue(icuaId,recordItemId,date,(time))
	q:postValue="" "" ;后上小时内一个数据没有则没有数据
	
	s preValue=..GetLastValue(icuaId,recordItemId,date,(time-3600))
	
	i preValue="" d
	.s preValue=..GetFirstValue(icuaId,recordItemId,date,time)
	.
	
	i preValue'=""  d
	.s value=postValue-preValue
	.
	e  s value="" ;如果这个小时只有一个数据，认为这小时没有出入量
	
	q value
}

// 查询上时间点最后一条记录

// 如19:00，日查询18:00到19:00的数据

ClassMethod GetLastValue(icuaId, recordItemId, date, time)
{
	// w ##class(web.DHCICUOrder).GetLastValue(icuaId,recordItemId,date,time)
	i date'=+date s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i time'=+time s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	s hour=time\3600
	i hour=0 s date=date-1,hour=24 ; 如果是0点数据查询前一天23点这一小时的数据
	s startTime=(hour-1)*3600
	s endTime=(hour)*3600
	
	s value=""
	s note=""
	//&sql(SELECT TOP 1 ICUCD_Qty into:value  FROM DHC_ICU_CollectData WHERE ICUCD_Parref=1209 AND ICUCD_StartDate=63522 AND ICUCD_ComOrd_Dr=6939 AND (ICUCD_StartTime>(8*3600) AND ICUCD_StartTime<(9*3600)) ORDER BY ICUCD_StartTime)
	&sql(SELECT TOP 1 ICUCD_Qty,ICUCD_Note into:value,:note FROM DHC_ICU_CollectData WHERE ICUCD_Parref=:icuaId AND ICUCD_StartDate=:date AND ICUCD_ComOrd_Dr=:recordItemId AND (ICUCD_StartTime>:startTime AND ICUCD_StartTime<:endTime) ORDER BY ICUCD_StartTime desc )
	i value="" s value=note
	q value
}

ClassMethod GetFirstValue(icuaId, recordItemId, date, time)
{
	// w ##class(web.DHCICUOrder).GetFirstValue(icuaId,recordItemId,date,time)
	i date'=+date s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i time'=+time s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	s hour=time\3600
	i hour=0 s date=date-1,hour=24 ; 如果是0点数据查询前一天23点这一小时的数据
	s startTime=(hour-1)*3600
	s endTime=(hour)*3600
	s value=""
	
	//&sql(SELECT TOP 1 ICUCD_Qty into:value  FROM DHC_ICU_CollectData WHERE ICUCD_Parref=1209 AND ICUCD_StartDate=63522 AND ICUCD_ComOrd_Dr=6939 AND (ICUCD_StartTime>(8*3600) AND ICUCD_StartTime<(9*3600)) ORDER BY ICUCD_StartTime)
	&sql(SELECT TOP 1 ICUCD_Qty,ICUCD_Note into:value,:note FROM DHC_ICU_CollectData WHERE ICUCD_Parref=:icuaId AND ICUCD_StartDate=:date AND ICUCD_ComOrd_Dr=:recordItemId AND (ICUCD_StartTime>:startTime AND ICUCD_StartTime<:endTime) ORDER BY ICUCD_StartTime )
	i value="" s value=note
	q value
}

/// 根据评分子项目等分获取相关数据
/// w ##class(web.DHCICUOrder).GetARDSOrderByPredict("4874","","ARDSZD","2015-01-20","2015-01-21")
ClassMethod GetARDSOrderByPredict(icuaId, ctlocId = "", mainPredictCode = "", startDate = "", endDate = "") As %String
{
	q:icuaId=""
	i startDate'=+startDate s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	i endDate'=+endDate s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s inDateTime=##class(web.DHCICUCom).GetWardInDateTime("",icuaId,"","","^","D")
	q:inDateTime=""		
	s inDate=$p(inDateTime,"^"),inTime=$p(inDateTime,"^",2)
	s outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
	i outDateTime="" s outDate=+$h,outTime=$p($h,",",2)
	e  s outDate=$p(outDateTime,"^"),outTime=$p(outDateTime,"^",2) 
	s retStr=""
	s icucpId=0
	f  s icucpId=$o(^DHCICUCPredict(icucpId)) q:icucpId=""  d		
		.s mainIcucriCode=$lg(^DHCICUCPredict(icucpId),1)
		.q:(mainPredictCode'="")&&(mainPredictCode'=mainIcucriCode)
		.;w mainIcucriCode,!
		.s mainIcucriId=$o(^DHCICUC("RecordItem",0,"Code",mainIcucriCode,""))
		.q:mainIcucriId=""
		.s mainValue=$lg(^DHCICUCPredict(icucpId),5)
		.s mainScore=$lg(^DHCICUCPredict(icucpId),6)
		.s wardLocIdStr=$lg(^DHCICUCPredict(icucpId),3)
		.q:(ctlocId'="")&&(wardLocIdStr'=ctlocId)
		.s triggerDate="",triggerTime="",sum=0
		.s icucpiSub=0,subRetStr="",subRetScore=""
		.f  s icucpiSub=$o(^DHCICUCPredict(icucpId,"I",icucpiSub)) q:icucpiSub=""  d
		..s icucriCode=$lg(^DHCICUCPredict(icucpId,"I",icucpiSub),1)
		..q:icucriCode=""
		..s icucpiTrigger=$lg(^DHCICUCPredict(icucpId,"I",icucpiSub),4)
		..q:'icucpiTrigger
		..s dataField=$lg(^DHCICUCPredict(icucpId,"I",icucpiSub),6)
		..s dataScore=$lg(^DHCICUCPredict(icucpId,"I",icucpiSub),7)
		..s dataNote=$lg(^DHCICUCPredict(icucpId,"I",icucpiSub),10)
		..s minQty=$lg(^DHCICUCPredict(icucpId,"I",icucpiSub),8)
		..s maxQty=$lg(^DHCICUCPredict(icucpId,"I",icucpiSub),9)
		..s icucpRefIcuriCode=$lg(^DHCICUCPredict(icucpId,"I",icucpiSub),18)
		..;w icucpRefIcuriCode,!
		..s icucpRefIcuriId=##class(web.DHCICUCom).GetIcuriIdByCode(icucpRefIcuriCode)
		..s icucriId=$o(^DHCICUC("RecordItem",0,"Code",icucriCode,"")) //triggerId
		..q:icucriId=""
		..s value=""
		..i $lg(^DHCICUCPredict(icucpId,"I",icucpiSub),3)="R" d
			...i "^DurationDay^DurationHour^Times^"'[("^"_dataField_"^") d
				....;w icuaId_"/"_icucriId_"/"_inDate_"/"_inTime_"/"_outDate_"/"_outTime_"/"_"Min",!
				....s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,icucriId,inDate,inTime,outDate,outTime,dataNote,"","","",dataField,"","","")
				....;w value,!
		..q:(minQty'="")&&($p(value,"#",2)<minQty)
		..q:(maxQty'="")&&($p(value,"#",2)>maxQty)
		..;q:value'=dataNote
		..i subRetStr="" s subRetStr=value
		..e  s subRetStr=subRetStr_"^"_value 
		..s subRetScore=subRetScore+dataScore
		..;w subRetScore,!		
		.q:subRetScore<mainScore
		.s value=##class(web.DHCICUOrder).GetRecordValue(icuaId,mainIcucriId,inDate,inTime,outDate,outTime,"","","","",dataField,"","","")
		.;w value,!
		.q:(mainValue'="")&&(mainValue'=$p(value,"#",2))	
		.s subRetStr=value_"^"_subRetStr
		.i retStr="" s retStr=subRetStr
		.e  s retStr=retStr_"^"_subRetStr
		
	q retStr
}

/// 每小时的1分钟时执行[血滤、输液泵使用]
ClassMethod EveryHourTask()
{
	// w ##class(web.DHCICUOrder).EveryHourTask()
	S $ZT="EveryHourTaskError"

	s sub="" f  s sub=$O(^DHCICUBedEquip(sub)) q:sub=""  d
	. 
	.s bedId=$p($g(^DHCICUBedEquip(sub)),"^",1)
	.s wardId=+bedId
	.s wardLocId=$p($g(^PAWARD(+wardId)),"^",5)
	.q:wardLocId=""
	.s PLIST(wardLocId)=wardLocId
	
	// 循环执行每一个科室
	s locId="" f  s locId=$O(PLIST(locId)) q:locId=""  d
	.
	.w "EachWard:",locId,!
	.d EachWard(locId)
	.
	q "Over"
EveryHourTaskError
	d ..Log("EveryHourTask",$ZERROR)
	q ""
EachWard(locId)
	SET $ZTRAP="EachWardError"
	d ..LoadHFData(locId)
	d ..LoadPumpData(locId)
	d ..Log("EveryHourTask-EachWard",locId)
	q
EachWardError
	d ..Log("EveryHourTask-EachWard-Error",$ZERROR)
	q
}

ClassMethod LoadPumpData(ctlocId, date = "", time = "")
{
	// w ##class(web.DHCICUOrder).LoadPumpData(ctlocId,date,time)
	i date="" s date=+$H
	i time="" s time=$p($H,",",2)
	i date'=+date s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i time'=+time s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	s wardId=""
	s patientList=##class(web.DHCICUCom).FindWardPatient(wardId, ctlocId)
	
	i date'=+date s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i time'=+time s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	S $ZT="ERRORLoadPumpData"
	
	q:patientList="" 0
	
	s scope=3600
	
	s time=((time+(scope/2))\3600)*3600-3600 // 四舍五入
	
	f i=1:1:$l(patientList,"^") d
	.q:$p(patientList,"^",i)=""
	.s icuaId=$p($p(patientList,"^",i),"|",4)
	.q:icuaId=""
	.w "icuaId: ",icuaId," ",$zd(date),$zt(time),!
	.s ^tmpicudebug("Pump",icuaId,$zd(date),$zt(time))=$zd(date)_" "_$zt(time)
	.d ..Log("LoadPumpPatData",icuaId_","_date_","_time)
	.d ##class(web.DHCICUMicroPump).LoadPumpPatData(icuaId,date,time)
	q "Success"
ERRORLoadPumpData
	s ^tmpicudebug("LoadPumpData-Error",+$h,$p($h,",",2))=$ZERROR
}

// 加载CollectData表中向前找离date和time最近的数据到ICUOrder表中

// ICUOrder表的时间为date和time

// date和time: 查找时间

// scope: 查找范围

// 		!!!还未使用!!!    将在2015年11月更新  邓体进 

// 		FOR: 每一病人均记录每小时入库情况,避免因一个床的数据加载导致之后所以床的数据加载失败

ClassMethod LoadColloctDataByIcuaId(icuaId, date, time, scope = 3600)
{
	// w ##class(web.DHCICUOrder).LoadColloctDataByIcuaId(date,time,icuaId)
	s $ZT="ERRORLoadColloctDataByIcuaId" 
	i date'=+date s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i time'=+time s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	d ..Log("LoadColloctDataByIcuaId"_icuaId,"BeforeLoad:"_date_" "_time)
	s curDate=date,curTime=time
	i curTime=0 s curTime=24*3600,curDate=curDate-1
	s isExit=0
	f  s curTime=$o(^DHCICUArrange(0,"CData",icuaId,curDate,curTime),-1) q:((curTime="")!(isExit))  d
		.i $zabs(((date*3600*24)+time)-((curDate*3600*24)+curTime))>scope s isExit=1 q //十分钟内数据
		.
		.s icucdSub=""
		.f  s icucdSub=$o(^DHCICUArrange(0,"CData",icuaId,curDate,curTime,icucdSub)) q:icucdSub=""  d
			..q:'$d(^DHCICUArrange(icuaId,"C",icucdSub))
			..q:$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",1)=""
			..q:$d(IcucriList($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",1)))
			..s recordItemId=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",1) ;2014-11-11 dtj
			..s recordItemCode=$p($g(^DHCICUC("RecordItem",recordItemId)),"^",1)
			..i ((recordItemCode'="NSBP")&&(recordItemCode'="NDBP")&&(recordItemCode'="NMBP")) d
			...; 非无创血压
			...s IcucriList(recordItemId)=icucdSub
			..
	s hour=$p($h,",",2)\3600
	// 每小时更新一次组合项数据
	i $g(^tmpicudebug("ConfirmData-GroupData"))=hour d
	.m comItems=^tmpicudebug("ConfirmData-GroupData")
	e  d 
	.k ^tmpicudebug("ConfirmData-GroupData")
	.d Init
	.s ^tmpicudebug("ConfirmData-GroupData")=hour
	s icucriId=""
	f  s icucriId=$o(IcucriList(icucriId)) q:icucriId=""  d
	.
	.s icucdSub=IcucriList(icucriId)
	.q:'$d(^DHCICUArrange(icuaId,"C",icucdSub))
	.s txtValue=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",4) //ICUO_Note
	.s numValue=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",5) //ICUO_Qty
	.b // before Insert!!!!!!!!!!!!!
	.d Insert2ICUOrder
	.// 组合项数据收集
	.s itemName=$p($g(^DHCICUC("RecordItem",icucriId)),"^",1)
	.s itemValue="" s txtValue=""
	.i itemValue="" s itemValue=numValue
	.
	.s isub=""
	.f  s isub=$o(comItems(isub)) q:isub=""  d  
	..s comItem=comItems(isub)
	..i comItem[itemName s comItems(isub,icuaId,itemName)=itemValue
	.
	// 组合项
	s isub="" f  s isub=$o(comItems(isub)) q:isub=""  d 
	.;b "After s isub=$o(comItems(isub)) q:isub=""  d "
	.s csub="" s csub=$o(comItems(isub,icuaId,csub))
	.q:csub=""
	.s icucriId=isub
	.s txtValue=comItems(isub,"format") ;{0}/{1}({2})
	.s count=$l(txtValue,"{")-2
	.s nullValue=txtValue
	.f j=0:1:count d
	..;s fStr=$REPLACE("{N}","N",j);2010以上
	..s fStr=..Replace("{N}","N",j)
	..
	..s itemName=$p(comItems(isub),";",j+1)
	..i itemName="" s aValue=""
	..e  s aValue=$g(comItems(isub,icuaId,itemName))
	..
	..;s txtValue=$REPLACE(txtValue,fStr,aValue) ;Cache2010以上支持
	..s txtValue=..Replace(txtValue,fStr,aValue)
	..s nullValue=..Replace(nullValue,fStr,"")
	.;如果值为空则退出
	.q:nullValue=txtValue  
	.d Insert2ICUOrder
	
	d ..Log("LoadColloctDataByIcuaId"_icuaId,"BeforeLoad:"_date_" "_time)
	
	q 0
	
Insert2ICUOrder	
	s wardIds=$g(^DHCCLSet("RecentDataWardId")) ;不需要添加最近时间的参数的科室
	s wardId=$p($p($g(^DHCICUArrange(icuaId)),"^",4),"||",1)
	s InsertedRecentData=""
	s viewCat=$p($g(^DHCICUC("RecordItem",icucriId)),"^",5)
	q:(("^"_wardIds_"^")[("^"_wardId_"^"))&&(viewCat=231)
	// 查询后插入
	//b "Insert2ICUOrder1"
	s isFind=0
	s sub=""
	f  s sub=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId,time,sub)) q:((sub="")||(isFind=1))  d
	.s ctuomId=$p($g(^DHCICUOrder(sub)),"^",2)
	.i ctuomId=icucriId s isFind=1 	 
	q:isFind=1
	//b "Insert2ICUOrder2"
	k PLIST
	s PLIST(2)=icuaId //icuaId
	s PLIST(3)=icucriId //icucriId
	s PLIST(5)="" //userId
	s PLIST(6)=date //startDate
	s PLIST(7)=time //startTime
	s PLIST(8)=date //endDate
	s PLIST(9)=time //endTime
	s PLIST(11)=txtValue
	s PLIST(12)=numValue
	s PLIST(13)="" //ctuomId
	s PLIST(17)=$p($g(^DHCICUC("RecordItem",icucriId)),"^",5) //ancvcId
	s PLIST(18)="N" //ICUO_Flag
	s PLIST(22)=+$h //ICUO_UpdateDate
	s PLIST(23)=$p($h,",",2) //ICUO_UpdateTime
	s PLIST(24)="" //ICUO_ICUO_Dr
	s PLIST(26)="N" //ICUO_EditFlag
	s PLIST(30)="I" //ICUO_ICUO_Source
	s PLIST(31)=$p($g(^DHCICUC("RecordItem",icucriId)),"^",3) //ICUO_Type
	
	&SQL(Insert into DHC_ICU_Order Values :PLIST())
	s retStr=SQLCODE
	i SQLCODE s retStr=icuoId_":ICU SQLCODE:"_SQLCODE //icuoId"插入数据错! SQLCode="_SQLCODE
	s ^tmpICUDebug("Confirmed",$h)=SQLCODE_",rowId="_$g(%ROWID)
	q 
Init
	// 组合项初始化
	s comOrd=""
	//b "Init"
	f  s comOrd=$o(^DHCICUC("RecordItem",comOrd)) q:comOrd=""  d
	.s comItem=$g(^DHCICUC("RecordItem",comOrd))
	.s cTypeID=$p(comItem,"^",5)
	.q:cTypeID=""
	.s cTypeCode=$p($g(^DHCICUC("ViewCat",cTypeID)),"^",1) // 类型:只处理生命体征
	.q:cTypeCode=""
	.s forStr=$p(comItem,"^",25)
	.s paraStr=$p(comItem,"^",27)
	.
	.i ($p(comItem,"^",24)="Note")&((cTypeCode="VitalSign")||(cTypeCode="ICUBloodAnalysis")||(cTypeCode="ICUBloodAnalysis")||(cTypeCode="RespiratorySupport")||(cTypeCode="HF"))&(forStr["{0}") d
	..s comItems(comOrd)=$p(comItem,"^",27) ;NSBP;NDBP;NMBP
	..s comItems(comOrd,"format")=$p(comItem,"^",25) ; {0}/{1}({2})	
	m ^tmpicudebug("ConfirmData-GroupData")=comItems
	q "0"
ERRORLoadColloctDataByIcuaId
	d ..Log("LoadColloctDataByIcuaId-Error"_icuaId,date_" "_time_$ZERROR)
}

/// 取监护数据DHC_ICU_Order
/// 入参：监护Id,就诊号EpisodeID,病区wardLocId，科室ctlocId(可为病区,为科室时找关联病区),
/// 所需要查询的显示分类ancvcIdStr(用"^"分割的串)查，起止时间。icuoSourceStr="MA"只取手工录入数据
Query FindIcuOrderDebug(icuaId, startDate, startTime, endDate, endTime, EpisodeID = "", ctlocId = "", ancvcIdStr = "", icuoSourceStr = "", shiftStartTime = "") As %Query(ROWSPEC = "Id,RecordItemId,OeoreId,UserId,StartDate,StartTime,EndDate,EndTime,ArcimId,Note,Qty,UomId,Concentration,OriginalOrderId,InstrId,RecordCatId,Flag,DrugMode,Speed,UpdateDate,UpdateTime,Reason,EditFlag,EditedIcuoId,RecvLoc,DocUserId,Volume,SpeedUnitId,Source,Type,AncoDesc,ArcimDesc,PrepareIntake,AttachOeoriId,Report,ArrangeId,MainOeoreId,SubOrderId,Priority,Instruction,Frequency,OeoriNote,Abbreviate,OrderItemNote,MainIcuoId,Remarks,ParaItemId,DoseSpeed") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","FindIcuOrder",1945,60000,0,66000,0,"","","","MAI")
ClassMethod FindIcuOrderDebugExecute(ByRef qHandle As %Binary, icuaId, startDate, startTime, endDate, endTime, EpisodeID = "", ctlocId = "", ancvcIdStr = "", icuoSourceStr = "", shiftStartTime = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	s ^dhcicudebug("FindIcuOrder")=icuaId_","_startDate_","_startTime_","_endDate_","_endTime_","_EpisodeID_","_ctlocId_","_ancvcIdStr_","_icuoSourceStr_","_shiftStartTime
	k ^TMPICU("Order",$j)
	//k ^TMPICU("OrderRet",$j)
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s endTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
	i shiftStartTime'="" s shiftStartTime=##class(web.DHCClinicCom).ConvertToTimeH(shiftStartTime)
	i startTime\60*60=startTime s startTime=startTime+30
	i endTime\60*60=endTime s endTime=endTime+30
	i shiftStartTime'="",shiftStartTime\60*60=shiftStartTime s shiftStartTime=shiftStartTime+30
	i (icuaId'="")&(shiftStartTime'="") d
		.s icuaStartDate=$p(^DHCICUArrange(icuaId),"^",6)
		.//i startTime<shiftStartTime s startDate=startDate-1
		.i startTime'>shiftStartTime s startDate=startDate-1
		.s startTime=shiftStartTime
		.
		.///取打印记录最早时间作为数据开始时间
		.s icuprId="",isFind=0
		.f  s icuprId=$o(^DHCICUArrange(icuaId,"PR",icuprId),-1) q:(+icuprId=0)!(isFind)  d
			..s icuprDate=$p(^DHCICUArrange(icuaId,"PR",icuprId),"^")
			..s icuprTime=$p(^DHCICUArrange(icuaId,"PR",icuprId),"^",2)
			..i ##class(web.DHCClinicCom).CompareDateTime(startDate,startTime,icuprDate,icuprTime)>0 d
				...s printSecond=icuprTime-(icuprTime\60*60)
				...//s ^tmpYpz("startDT",11)=^tmpYpz("startDT",11)_"|"_icuprId_"^"_printSecond
				...q:(printSecond=21) //小结所在行为21和22秒，跨行显示
				...s startDate=icuprDate
				...s startTime=icuprTime+1
				...s isFind=1
		.i 'isFind d //取监护开始时间
			..s startDate=icuaStartDate,startTime=$p(^DHCICUArrange(icuaId),"^",8)
			..s startTime=startTime-18000
			..i startTime<0 s startTime=startTime+86400,startDate=startDate-1
		.///取打印记录最晚时间页的结束时间作为数据结束时间
		.s icuprId=0,isFind=0
		.f  s icuprId=$o(^DHCICUArrange(icuaId,"PR",icuprId)) q:(+icuprId=0)!(isFind)  d
			..s icuprDate=$p(^DHCICUArrange(icuaId,"PR",icuprId),"^")
			..s icuprTime=$p(^DHCICUArrange(icuaId,"PR",icuprId),"^",2)
			..i ##class(web.DHCClinicCom).CompareDateTime(endDate,endTime,icuprDate,icuprTime)<1 d
				...s endDate=icuprDate
				...s endTime=icuprTime+1
				...s isFind=1
	s sttDateTime=startDate+(startTime/100000)
	s endDateTime=endDate+(endTime/100000)
	s icuaIdList=##class(web.DHCICUCom).FindIcuaIdList(icuaId, EpisodeID,ctlocId)
	i icuaIdList="" s qHandle=$lb(0,repid,0) q $$$OK
	
	//s ancvcCodeList=$g(^DHCCLSet("ICU","AllDataAncvcCode"))
	//s icucriIdStr=##class(web.DHCICUCom).GetAncoIdByAncvcCode(ancvcCodeList)
	s icucriIdStr=##class(web.DHCICUCom).GetIcucriIdByAncvcId(ancvcIdStr)
	s curDateTime=$h+($p($h,",",2)/100000)
	s fDate=startDate-1
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
	        ..q:icuoSourceStr="I"
	        ..
	        ..k adjTimeList
	        ..s icuoSttTime=""
	        ..f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
	            ...//q:(curDate=startDate)&(icuoSttTime<startTime)
	            ...//q:(curDate=endDate)&(icuoSttTime'<endTime)  //结束时间跨时间段?
	            ...k tmpCurTime //当前时间点最后修改数据记录
	            ...s haveDrug=0,haveMonData=0,haveExclude=0
	            ...s icuoId="",seq=0
	            ...f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
	                ....q:$d(^DHCICUOrder(icuoId))<1
	                ....s icucriId=$p(^DHCICUOrder(icuoId),"^",2)
	                ....q:(icucriIdStr'="")&(icucriId'="")&(("^"_icucriIdStr_"^")[("^"_icucriId_"^"))
	                ....q:$$GetIcuoData("Y")<0
	                .... 
	                ....s icucriCode=""
	                ....i icucriId'="" s icucriCode=$p($g(^DHCICUC("RecordItem",+icucriId)),"^")
	                ....q:icucriCode=""
	                ....//i (arcimId'="")!(icucriCode="UserDefinedDrugItem") s haveDrug=1
	                ....i (arcimId'="")!($p(^DHCICUC("RecordItem",+icucriId),"^",3)="D") s haveDrug=1
	                ....i (icucriCode'="NursingRecord")!($p(^DHCICUOrder(icuoId),"^",17)'="T") s haveMonData=1
	                ....
	                ....q:(arcimId="")&(icucriCode'="UserDefinedDrugItem")&(icucriCode'="NursingRecord")
	                ....q:(icucriCode="NursingRecord")&($p(^DHCICUOrder(icuoId),"^",17)'="T") //非独占时间
	                ....//q:(startTime-(startTime\60*60)>20) //非生成数据
	                ....
	                ....s adjTimeList(icuoStartDateTime)=""
	                ....s mainIcuoId=$p(^DHCICUOrder(icuoId),"^",36)
	                ....i mainIcuoId="" s mainIcuoId=icuoId
	                ....i (icucriCode="NursingRecord")&($p(^DHCICUOrder(icuoId),"^",17)="T") d
	                	.....s mainIcuoId=0_mainIcuoId //保证护理记录在后面
	                	.....s haveExclude=1
	                ....s adjTimeList(icuoStartDateTime,mainIcuoId,icuoId)=updateDateTime_"^"_oreGroup_icucriId_arcimId_"^"_icuoId
	            ...i 'haveDrug,haveMonData,haveExclude s adjTimeList(icuoStartDateTime,0,0)=0
			..s icuoStartDateTime=""
			..f  s icuoStartDateTime=$o(adjTimeList(icuoStartDateTime)) q:icuoStartDateTime=""  d
				...s mainIcuoId=$o(adjTimeList(icuoStartDateTime,"")) //第一个时间不调整
				...f  s mainIcuoId=$o(adjTimeList(icuoStartDateTime,mainIcuoId)) q:mainIcuoId=""  d
					....q //新版暂不自动调整时间
					....
					....s curDateTime=icuoStartDateTime
					....s isFind=0,newDateTime=""
					....
					....f j=1:1:20 d //暂用20个
						.....s curDateTime=curDateTime+0.00001
						.....i curDateTime-$p(curDateTime,".")>0.86399 s curDateTime=$p(curDateTime,".")+1
						.....q:$d(adjTimeList(curDateTime))
						.....q:isFind
						.....s newDateTime=curDateTime
						.....s isFind=1
					....//w mainIcuoId_"/"_icuoStartDateTime_"/"_newDateTime,!
					....q:newDateTime=""
					....s adjTimeList(newDateTime)=""
					....s adjTimeList(icuoStartDateTime,mainIcuoId)=newDateTime
					....s icuoStartTime=(icuoStartDateTime-$p(icuoStartDateTime,"."))*100000
					....s newTime=(newDateTime-$p(newDateTime,"."))*100000
					....s icuoId=""
					....f  s icuoId=$o(adjTimeList(icuoStartDateTime,mainIcuoId,icuoId)) q:icuoId=""  d
						.....s updateDateTime=$p(adjTimeList(icuoStartDateTime,mainIcuoId,icuoId),"^",1)
						.....s oreGroupStr=$p(adjTimeList(icuoStartDateTime,mainIcuoId,icuoId),"^",2)
						.....q:'$d(^TMPICU("Order",$j,icuaId,updateDateTime,oreGroupStr,icuoId))
						.....s $p(^TMPICU("Order",$j,icuaId,updateDateTime,oreGroupStr,icuoId),"^",6)=$zt(newTime)
						.....k ^DHCICUOrder(0,"SttDateTime",$p(icuoStartDateTime,"."),icuaId,icuoStartTime,icuoId)
						.....s ^DHCICUOrder(0,"SttDateTime",$p(icuoStartDateTime,"."),icuaId,newTime,icuoId)=""
						.....s $p(^DHCICUOrder(icuoId),"^",6)=newTime
	f i=1:1:$l(icuaIdList,"^") d
		.s icuaId=$p(icuaIdList,"^",i)
		.q:icuaId=""
		.f j=1:1:$l(icucriIdStr,"^") d
			..s icucriId=$p(icucriIdStr,"^",j)
			..q:icucriId=""
			..s icuoId="",seq=0
			..f  s icuoId=$o(^DHCICUOrder(0,"CommOrd",icucriId,icuaId,icuoId)) q:icuoId=""  d
				...q:$$GetIcuoData("Y")<0
	
	s icuaId="" f  s icuaId=$o(^TMPICU("Order",$j,icuaId))  q:icuaId=""  d
	 	.s updateDateTime="" f  s updateDateTime=$o(^TMPICU("Order",$j,icuaId,updateDateTime))  q:updateDateTime=""  d
	     	..s icucriArcimId="" f  s icucriArcimId=$o(^TMPICU("Order",$j,icuaId,updateDateTime,icucriArcimId))  q:icucriArcimId=""  d
	         	...s icuoId="" f  s icuoId=$o(^TMPICU("Order",$j,icuaId,updateDateTime,icucriArcimId,icuoId))  q:icuoId=""  d
	             	....//s i=i+1
	             	....//s ^TMPICU("OrderRet",$j,i)=^TMPICU("Order",$j,icuaId,updateDateTime,icucriArcimId,icuoId)
	             	....s Data=^TMPICU("Order",$j,icuaId,updateDateTime,icucriArcimId,icuoId)
	             	....d OutputIcuOrder
 	s qHandle=$lb(0,repid,0)
	q $$$OK
GetIcuoData(ifByDateTime = "")
	q:'$d(^DHCICUOrder(icuoId)) -1
	q:(icuoSourceStr'="")&(icuoSourceStr'[$p(^DHCICUOrder(icuoId),"^",29)) -2
	s icuoUpdateDate=$p(^DHCICUOrder(icuoId),"^",21)
	s icuoUpdateTime=$p(^DHCICUOrder(icuoId),"^",22)
	s icuoStartDate=$p(^DHCICUOrder(icuoId),"^",5)
	s icuoStartTime=$p(^DHCICUOrder(icuoId),"^",6)
	s icuoEndDate=$p(^DHCICUOrder(icuoId),"^",7)
	s icuoEndTime=$p(^DHCICUOrder(icuoId),"^",8)
	s mainIcuoEditFlag=$p(^DHCICUOrder(icuoId),"^",25)
	q:"I"[mainIcuoEditFlag -3 //旧版本ICD

	s icuoStartDateTime=icuoStartDate+(icuoStartTime/100000)
	s icuoEndDateTime=icuoEndDate+(icuoEndTime/100000)
	q:(ifByDateTime="Y")&(icuoEndDateTime'>sttDateTime) -4 //开始时间点不计
	q:(ifByDateTime="Y")&(icuoStartDateTime>endDateTime) -5 //结束时间点计入
	//q:($p(^DHCICUOrder(icuoId),"^",29)="I")&(curDateTime-icuoStartDateTime>30) -6 //不查看三十天以上的数据，旧版一天
	
	s arcimId=$p(^DHCICUOrder(icuoId),"^",9)				//ICUO_ARCIM_Dr
	s icucriId=$p(^DHCICUOrder(icuoId),"^",2)				//ICUO_ComOrd_Dr
	q:(icucriIdStr'="")&(("^"_icucriIdStr_"^")'[("^"_icucriId_"^")) -7
	s ancvcId=$p(^DHCICUOrder(icuoId),"^",16)			//ICUO_ViewCat_Dr
	q:(icucriId="")&(arcimId="")&(ancvcId="") -8
	s oeoreId=$p(^DHCICUOrder(icuoId),"^",3)
	s oeordId=+oeoreId
	s oeoriSub=$p(oeoreId,"||",2)
	s oeoreSub=$p(oeoreId,"||",3)
	s oeoriId=""
	i oeoriSub'="" s oeoriId=oeordId_"||"_oeoriSub
	
	i $p($g(^DHCICUC("RecordItem",+icucriId)),"^",2)="MicroPump" d
		.q:oeoriSub=""
		.s xDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",34)
    	.q:xDate=""
    	.s xTime=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",15)
		.i ##class(web.DHCClinicCom).CompareDateTime(icuoEndDate,icuoEndTime,xDate,xTime)>0 d
			..s icuoEndDate=xDate,icuoEndTime=xTime
			..i ##class(web.DHCClinicCom).CompareDateTime(icuoStartDate,icuoStartTime,icuoEndDate,icuoEndTime)>0 d
				...s icuoEndDate=icuoStartDate,icuoEndTime=icuoStartTime
			..s $p(^DHCICUOrder(icuoId),"^",7)=icuoEndDate,$p(^DHCICUOrder(icuoId),"^",8)=icuoEndTime
	
	s curId=icuoId //s tmpStr=icuoId_"^"
	s curIcucriId=icucriId //s tmpStr=tmpStr_icucriId_"^"
	//s tmpStr=tmpStr_oeoreId_"^"	//ICUO_OEORE_Dr
	s curUserId=$p(^DHCICUOrder(icuoId),"^",4) // tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",4)_"^"	//ICUO_User_Dr
	s curStartDate=$zd(icuoStartDate,3) //s tmpStr=tmpStr_$ZD(icuoStartDate,3)_"^"			//ICUO_StartDate
	s curStartTime=$zt(icuoStartTime) //s tmpStr=tmpStr_$ZT(icuoStartTime)_"^"
	s curEndDate=$zd(icuoEndDate,3) //s tmpStr=tmpStr_$ZD(icuoEndDate,3)_"^"
	s curEndTime=$zt(icuoEndTime) //s tmpStr=tmpStr_$ZT(icuoEndTime)_"^"
	//s tmpStr=tmpStr_arcimId_"^"
	s curNote=$p(^DHCICUOrder(icuoId),"^",10) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",10)_"^"	//ICUO_Note num:10
	s curQty=$p(^DHCICUOrder(icuoId),"^",11) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",11)_"^"	//ICUO_Qty
	
	s oeorditemStr=..GetOeorditemInfo(oeoriId)
	i oeorditemStr="" s oeorditemStr=..GetICUOrditemInfo(icuoId)
	s uomId=$p(^DHCICUOrder(icuoId),"^",12)
	i uomId="" s uomId=$p(oeorditemStr,"^",12)
	//s tmpStr=tmpStr_uomId_"^"	//ICUO_Uom_Dr
	s icuoConcentration=$p(^DHCICUOrder(icuoId),"^",13) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",13)_"^"	//ICUO_Concentration
	s icuoOriginateFromIcuodr=$p(^DHCICUOrder(icuoId),"^",14) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",14)_"^"	//ICUO_OriginateFromICUO_Dr
	s phcinId=$p(^DHCICUOrder(icuoId),"^",15)	
	//s tmpStr=tmpStr_phcinId_"^"	//ICUO_Instr_Dr
	s ancvcDesc=""
	i ancvcId'="" s ancvcDesc=$p($g(^DHCICUC("ViewCat",ancvcId)),"^",2)
	s doseSpeed=$p($g(^DHCICUOrder(icuoId)),"^",40)
	i (+doseSpeed=0)&(icucriId=5380) s doseSpeed=##class(web.DHCICUOrder).GetDoseSpeed(icuoId,"","DoseSpeed")
	//s tmpStr=tmpStr_ancvcId_"^" //tmpStr_ancvcDesc_"^"
	s icuoFlag=$p(^DHCICUOrder(icuoId),"^",17) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",17)_"^"	//ICUO_Flag
	s icuoDrugMode=$p(^DHCICUOrder(icuoId),"^",18) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",18)_"^"	//ICUO_DrugMode
	s icuoSpeed=$p(^DHCICUOrder(icuoId),"^",19) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",19)_"^"	//ICUO_Speed
	s curUpdateDate=$zd(icuoUpdateDate,3) //s tmpStr=tmpStr_$ZD(icuoUpdateDate,3)_"^" //num:20
	s curUpdateTime=$zt(icuoUpdateTime) //s tmpStr=tmpStr_$ZT(icuoUpdateTime)_"^"
	s icuoReason=$p(^DHCICUOrder(icuoId),"^",24) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",24)_"^"	//ICUO_Reason
	s curEditFlag=$p(^DHCICUOrder(icuoId),"^",25) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",25)_"^"	//ICUO_EditFlag
	s curEditedId=$p(^DHCICUOrder(icuoId),"^",23) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",23)_"^"	//ICUO_ICUO_DR
	s icuoRecLocId=$p(^DHCICUOrder(icuoId),"^",26) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",26)_"^"	//ICUO_RecLoc_Dr
	s curDocUserId=$p(^DHCICUOrder(icuoId),"^",27) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",27)_"^"	//ICUO_DocUser_Dr
	s icuoVolume=+$p(^DHCICUOrder(icuoId),"^",28) //s tmpStr=tmpStr_+$p(^DHCICUOrder(icuoId),"^",28)_"^"	//ICUO_Volume
	s icuoSpeedUnitDr=$p(^DHCICUOrder(icuoId),"^",20) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",20)_"^" //ICUO_SpeedUnit_Dr
	s icuoSource=$p(^DHCICUOrder(icuoId),"^",29) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",29)_"^"	//ICUO_Source
	s icuoType=$p(^DHCICUOrder(icuoId),"^",30) //tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",30)_"^"	//ICUO_Type //num:30
	s icucriDesc=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",2) //s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",+$p(^DHCICUOrder(icuoId),"^",2))),"^",2)_"^"
	s arcimDesc=$p($g(^ARCIM(+arcimId,1,1)),"^",2) //s tmpStr=tmpStr_$p($g(^ARCIM(+arcimId,1,1)),"^",2)_"^"
	s icuoPreparedVolume=+$p(^DHCICUOrder(icuoId),"^",31) //s tmpStr=tmpStr_+$p(^DHCICUOrder(icuoId),"^",31)_"^"	//ICUO_PreparedVolume
	s icuoAttachOeoriId=$p(^DHCICUOrder(icuoId),"^",32) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",32)_"^"     //ICUO_AttachOeoriId
	s icuoReportResult=$p(^DHCICUOrder(icuoId),"^",33) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",33)_"^"     //ICUO_ReportResult
	//s tmpStr=tmpStr_icuaId_"^"  //
	i $p(oeorditemStr,"^",6)'="" s $p(oeorditemStr,"^",6)=$p(oeorditemStr,"^",6)_"||"_oeoreSub
	s mainOeoriId=$p(oeorditemStr,"^",6) //s tmpStr=tmpStr_$p(oeorditemStr,"^",6)_"^"		//主医嘱mainOeoriId
	s subOeoriId=$p(oeorditemStr,"^",7) //s tmpStr=tmpStr_$p(oeorditemStr,"^",7)_"^"		//从医嘱subOeoriId
	s oecprDesc=$p(oeorditemStr,"^",13) //s tmpStr=tmpStr_$p(oeorditemStr,"^",13)_"^"		//优先级
	s phcinDesc=$p(oeorditemStr,"^",5) //s tmpStr=tmpStr_$p(oeorditemStr,"^",5)_"^"		//用法 phcinDesc  40
	s prcfrDesc=$p(oeorditemStr,"^",15) //s tmpStr=tmpStr_$p(oeorditemStr,"^",15)_"^"		//频率 num: 41
	s oeoriNote=$p(oeorditemStr,"^",17) //s tmpStr=tmpStr_$p(oeorditemStr,"^",17)_"^"		//医嘱备注 42
	s curAbbreviate=$p(^DHCICUOrder(icuoId),"^",34)
	i curAbbreviate="" s curAbbreviate=##class(web.DHCClinicCom).GetOeoriGroupDesc(oeoriId)
	//s tmpStr=tmpStr_icuoAbbreviate_"^"	//常用医嘱缩写 ICUO_Abbreviate
	//s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",34)_"^"	//常用医嘱缩写 ICUO_Abbreviate
	s icuoOrdItemNote=$p(^DHCICUOrder(icuoId),"^",35) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",35)_"^"	//HIS医嘱说明 ICUO_OrdItemNote
	s icuoMainIcuoDr=$p(^DHCICUOrder(icuoId),"^",36) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",36)_"^"	//主医嘱的ICUOId：ICUO_MainIcuo_Dr
	s icuoRemarks=$p(^DHCICUOrder(icuoId),"^",37) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",37)	//ICUO_Remarks
	s icuoIcupiDr=$p(^DHCICUOrder(icuoId),"^",38) //s tmpStr=tmpStr_"^"_$p(^DHCICUOrder(icuoId),"^",38)	//ICUO_ICUPI_Dr  total 47

	s mainOeoriSub=$p(mainOeoriId,"||",2)
	s tmpDateTime=icuoStartDate+(icuoStartTime/100000)
	s tmpSub=oeoriSub
	i mainOeoriSub="" s mainOeoriSub=oeoriSub,tmpSub=0
	s oreGroup=mainOeoriSub+((seq/100)+(tmpSub/1000000))
	
	s updateDateTime=icuoUpdateDate+(icuoUpdateTime/100000)
	s curTimeStr=icucriId_","_oeoreId_","_icuoIcupiDr_"^"_icuoStartDateTime
	s originalAncvcId=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",5)
	//i ("^"_$g(^DHCCLSet("CollectAncvcId"))_"^")[originalAncvcId s curTimeStr=icucriId_","
	i icucriId>0,"EN"[mainIcuoEditFlag,$g(tmpCurTime(curTimeStr))'="" d //clear duplicate data
		.//w updateDateTime_" update/"_icucriId_"/"_icuoId_": "_tmpCurTime(curTimeStr),!
		.i updateDateTime'<$g(tmpCurTime(curTimeStr)) d
			..k ^TMPICU("Order",$j,icuaId,$p(tmpCurTime(curTimeStr),"^"),$p(tmpCurTime(curTimeStr),"^",2),$p(tmpCurTime(curTimeStr),"^",3))
			..s clearIcuoId=+$p(tmpCurTime(curTimeStr),"^",3)
			..q:'$d(^DHCICUOrder(clearIcuoId))
			..s $p(^DHCICUOrder(clearIcuoId),"^",25)=""
			..s ^TMPICUClear(clearIcuoId)=icuaId_"/"_$h_"/"_icuoStartDateTime
		.e  d
			..//w icuoId_"/"_curTimeStr_"/"_$g(tmpCurTime(curTimeStr)),!
			..s $p(^DHCICUOrder(icuoId),"^",25)=""
			..s ^TMPICUClear(icuoId)=icuaId_"/"_$h_"/"_icuoStartDateTime
			..//w "k:"_icuoId
	q:("EN"[mainIcuoEditFlag)&(updateDateTime<$g(tmpCurTime(curTimeStr))) -11 //当前时间点有正常数据，但不是最新修改
	//i startDate=63204,icucriId=5330 w mainIcuoEditFlag_"/3:"_updateDateTime_"^"_oreGroup_","_icucriId_","_arcimId_"^"_icuoId,!
	i ("EN"[mainIcuoEditFlag)&(icucriId>0) d
		.s tmpCurTime(curTimeStr)=updateDateTime_"^"_oreGroup_","_icucriId_","_arcimId_"^"_icuoId //记录最新修改数据
	 	.//i startDate=63204,icucriId=5330 w curTimeStr_"/4:"_tmpCurTime(curTimeStr),!
	 	.//w curTimeStr_"/tmpCurTime:"_tmpCurTime(curTimeStr),!
	s curId=icuoId
	s icuodSub=0
	s ^TMPICU("Order",$j,icuaId,updateDateTime,oreGroup_","_icucriId_","_arcimId,icuoId)=$lb(curId,curIcucriId,oeoreId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,icuoConcentration,icuoOriginateFromIcuodr,phcinId,ancvcId,icuoFlag,icuoDrugMode,icuoSpeed,curUpdateDate,curUpdateTime,icuoReason,curEditFlag,curEditedId,icuoRecLocId,curDocUserId,icuoVolume,icuoSpeedUnitDr,icuoSource,icuoType,icucriDesc,arcimDesc,icuoPreparedVolume,icuoAttachOeoriId,icuoReportResult,icuaId,mainOeoriId,subOeoriId,oecprDesc,phcinDesc,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoMainIcuoDr,icuoRemarks,icuoIcupiDr,doseSpeed)
	//s ^TMPICU("Order",$j,icuaId,updateDateTime,oreGroup_","_icucriId_","_arcimId,icuoId_","_icuodSub)=$lb(curId,curIcucriId,oeoreId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,icuoConcentration,icuoOriginateFromIcuodr,phcinId,ancvcId,icuoFlag,icuoDrugMode,icuoSpeed,curUpdateDate,curUpdateTime,icuoReason,curEditFlag,curEditedId,icuoRecLocId,curDocUserId,icuoVolume,icuoSpeedUnitDr,icuoSource,icuoType,icucriDesc,arcimDesc,icuoPreparedVolume,icuoAttachOeoriId,icuoReportResult,icuaId,mainOeoriId,subOeoriId,oecprDesc,phcinDesc,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoMainIcuoDr,icuoRemarks,icuoIcupiDr)
	//s ^TMPICU("Ordes",$j,icuaId,updateDateTime,oreGroup_","_icucriId_","_arcimId,icuoId_","_icuodSub)=curId_"^"_curIcucriId_"^"_oeoreId_"^"_curUserId_"^"_curStartDate_"^"_curStartTime_"^"_curEndDate_"^"_curEndTime_"^"_arcimId_"^"_curNote_"^"_curQty_"^"_uomId_"^"_icuoConcentration_"^"_icuoOriginateFromIcuodr_"^"_phcinId_"^"_ancvcId_"^"_icuoFlag_"^"_icuoDrugMode_"^"_icuoSpeed_"^"_curUpdateDate_"^"_curUpdateTime_"^"_icuoReason_"^"_curEditFlag_"^"_curEditedId_"^"_icuoRecLocId_"^"_curDocUserId_"^"_icuoVolume_"^"_icuoSpeedUnitDr_"^"_icuoSource_"^"_icuoType_"^"_icucriDesc_"^"_arcimDesc_"^"_icuoPreparedVolume_"^"_icuoAttachOeoriId_"^"_icuoReportResult_"^"_icuaId_"^"_mainOeoriId_"^"_subOeoriId_"^"_oecprDesc_"^"_phcinDesc_"^"_prcfrDesc_"^"_oeoriNote_"^"_curAbbreviate_"^"_icuoOrdItemNote_"^"_icuoMainIcuoDr_"^"_icuoRemarks_"^"_icuoIcupiDr
	//w "all:"_tmpStr,!
	f  s icuodSub=$o(^DHCICUOrder(icuoId,"D",icuodSub)) q:icuodSub=""  d
		.q //未用
		.
		.q:"C"[mainIcuoEditFlag
		.q:$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",12)["D"
		.s icuodStartDate=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",1)
		.s icuodStartTime=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",2)
		.s icuodStartDateTime=icuodStartDate+(icuodStartTime/100000)
		.q:endDateTime'>icuodStartDateTime
	 	.s icuodEndDate=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",3)
		.s icuodEndTime=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",4)
		.s icuodEndDateTime=icuodEndDate+(icuodEndTime/100000)
		.q:sttDateTime>icuodEndDateTime
		.
		.s curId=icuoId_"||"_icuodSub //s $p(tmpStr,"^",1)=icuoId_"||"_icuodSub
		.s curStartDate=$zd(icuodStartDate,3) //s $p(tmpStr,"^",5)=$ZD(icuodStartDate,3)
	 	.s curStartTime=$zt(icuodStartTime) //s $p(tmpStr,"^",6)=$ZT(icuodStartTime)
		.s curEndDate=$zd(icuodEndDate,3) //s $p(tmpStr,"^",7)=$ZD(icuodEndDate,3)
		.s curEndTime=$zt(icuodEndTime) //s $p(tmpStr,"^",8)=$ZT(icuodEndTime)
		.s curIcucriId=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",5) //ICUOD_ComOrd_Dr
		.s curAbbreviate=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",6) //ICUOD_Abbreviate
		.s curQty=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",7) //icuod_Qty
		.s curNote=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",8) //icuod_Note
		.s curUserId=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",9) //icuod_User_Dr
		.s curUpdateDate=$zd($p(^DHCICUOrder(icuoId,"D",icuodSub),"^",10),3) //icuod_UpdateDate
		.s curUpdateTime=$zt($p(^DHCICUOrder(icuoId,"D",icuodSub),"^",11)) //icuod_UpdateTime
		.s curEditFlag=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",12) //icuod_EditFlag
	    .s curEditedId=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",13) //icuod_icuod_Dr
		.s ^TMPICU("Order",$j,icuaId,updateDateTime,oreGroup_","_icucriId_","_arcimId,icuoId_","_icuodSub)=$lb(curId,curIcucriId,oeoreId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,icuoConcentration,icuoOriginateFromIcuodr,phcinId,ancvcId,icuoFlag,icuoDrugMode,icuoSpeed,curUpdateDate,curUpdateTime,icuoReason,curEditFlag,curEditedId,icuoRecLocId,curDocUserId,icuoVolume,icuoSpeedUnitDr,icuoSource,icuoType,icucriDesc,arcimDesc,icuoPreparedVolume,icuoAttachOeoriId,icuoReportResult,icuaId,mainOeoriId,subOeoriId,oecprDesc,phcinDesc,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoMainIcuoDr,icuoRemarks,icuoIcupiDr)
		.//s ^TMPICU("Ordes",$j,icuaId,updateDateTime,oreGroup_","_icucriId_","_arcimId,icuoId_","_icuodSub)=curId_"^"_curIcucriId_"^"_oeoreId_"^"_curUserId_"^"_curStartDate_"^"_curStartTime_"^"_curEndDate_"^"_curEndTime_"^"_arcimId_"^"_curNote_"^"_curQty_"^"_uomId_"^"_icuoConcentration_"^"_icuoOriginateFromIcuodr_"^"_phcinId_"^"_ancvcId_"^"_icuoFlag_"^"_icuoDrugMode_"^"_icuoSpeed_"^"_curUpdateDate_"^"_curUpdateTime_"^"_icuoReason_"^"_curEditFlag_"^"_curEditedId_"^"_icuoRecLocId_"^"_curDocUserId_"^"_icuoVolume_"^"_icuoSpeedUnitDr_"^"_icuoSource_"^"_icuoType_"^"_icucriDesc_"^"_arcimDesc_"^"_icuoPreparedVolume_"^"_icuoAttachOeoriId_"^"_icuoReportResult_"^"_icuaId_"^"_mainOeoriId_"^"_subOeoriId_"^"_oecprDesc_"^"_phcinDesc_"^"_prcfrDesc_"^"_oeoriNote_"^"_curAbbreviate_"^"_icuoOrdItemNote_"^"_icuoMainIcuoDr_"^"_icuoRemarks_"^"_icuoIcupiDr
	q 0
GetCollectData(ifByDateTime="")
	q:'$d(^DHCICUArrange(icuaId,"C",icucdSub)) -1
	s icucdStartDate=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",2)
	s icucdStartTime=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",3)

	s icucdStartDateTime=icucdStartDate+(icucdStartTime/100000)
	s icucdEndDateTime=icucdStartDateTime
	q:(ifByDateTime="Y")&(icucdEndDateTime'>sttDateTime) -4 //开始时间点不计
	q:(ifByDateTime="Y")&(icucdStartDateTime>endDateTime) -5 //结束时间点计入
	
	s icucriId=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",1)
	q:icucriId="" -2
	s icucdUpdateDate=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",6)
	s icucdUpdateTime=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",7)
	s updateDateTime=icucdUpdateDate+(icucdUpdateTime/100000)
	
	s curId="" //s tmpStr="^" //??
	s curIcucriId=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",1) //s tmpStr=tmpStr_$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",1)_"^"
	s oeoreId="" //s tmpStr=tmpStr_"^"	//ICUO_OEORE_Dr
	s curUserId="" //s tmpStr=tmpStr_"^"	//ICUO_User_Dr
	s curStartDate=$zd($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",2),3) //s tmpStr=tmpStr_$ZD($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",2),3)_"^"	//ICUO_StartDate
	s curStartTime=$zt($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",3)) //s tmpStr=tmpStr_$ZT($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",3))_"^"
	s curEndDate=$zd($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",2),3) //s tmpStr=tmpStr_$ZD($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",2),3)_"^"
	s curEndTime=$zt($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",3)) //s tmpStr=tmpStr_$ZT($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",3))_"^"
	s arcimId="" //s tmpStr=tmpStr_"^"
	s curNote=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",4) //s tmpStr=tmpStr_$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",4)_"^"	//ICUO_Note num:10
	s curQty=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",5) //s tmpStr=tmpStr_$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",5)_"^"	//ICUO_Qty
	s uomId="" //s tmpStr=tmpStr_"^"	//ICUO_Uom_Dr
	s icuoConcentration="" //s tmpStr=tmpStr_"^"	//ICUO_Concentration
	s icuoOriginateFromIcuodr="" //s tmpStr=tmpStr_"^"	//ICUO_OriginateFromICUO_Dr
	s phcinId="" //s tmpStr=tmpStr_"^"	//ICUO_Instr_Dr
	s ancvcId=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",5) //s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",icucriId)),"^",5)_"^" //tmpStr_ancvcDesc_"^"
	s doseSpeed=""
	s icuoFlag="N" //s tmpStr=tmpStr_"N^"	//ICUO_Flag
	s icuoDrugMode="" //s tmpStr=tmpStr_"^"	//ICUO_DrugMode
	s icuoSpeed="" //s tmpStr=tmpStr_"^"	//ICUO_Speed
	s curUpdateDate=$zd(icucdUpdateDate,3) //s tmpStr=tmpStr_$ZD(icucdUpdateDate,3)_"^" //num:20
	s curUpdateTime=$zt(icucdUpdateTime) //s tmpStr=tmpStr_$ZT(icucdUpdateTime)_"^"
	s icuoReason="" //s tmpStr=tmpStr_"^"	//ICUO_Reason
	s curEditFlag="N" //s tmpStr=tmpStr_"N^"	//ICUO_EditFlag
	s curEditedId="" //s tmpStr=tmpStr_"^"	//ICUO_ICUO_DR
	s icuoRecLocId="" //s tmpStr=tmpStr_"^"	//ICUO_RecLoc_Dr
	s curDocUserId="" //s tmpStr=tmpStr_"^"	//ICUO_DocUser_Dr
	s icuoVolume=0 //s tmpStr=tmpStr_"0^"	//ICUO_Volume
	s icuoSpeedUnitDr="" //s tmpStr=tmpStr_"^" //ICUO_SpeedUnit_Dr
	s icuoSource="A" //s tmpStr=tmpStr_"A^"	//ICUO_Source
	s icuoType=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",3) //s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",icucriId)),"^",3)_"^"	//ICUO_Type //num:30
	s icucriDesc=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",2) //s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",icucriId)),"^",2)_"^"
	s arcimDesc="" //s tmpStr=tmpStr_"^"
	s icuoPreparedVolume=0 //s tmpStr=tmpStr_"0^"	//ICUO_PreparedVolume
	s icuoAttachOeoriId="" //s tmpStr=tmpStr_"^"     //ICUO_AttachOeoriId
	s icuoReportResult="" //s tmpStr=tmpStr_"^"     //ICUO_ReportResult
	//s tmpStr=tmpStr_icuaId_"^"  //
	s mainOeoriId="",subOeoriId="",oecprDesc="",phcinDesc="",prcfrDesc="",oeoriNote="",curAbbreviate="",icuoOrdItemNote="",icuoMainIcuoDr="",icuoRemarks="",icuoIcupiDr=""
	s $p(tmpStr,"^",47)="^"
	s ^TMPICU("Order",$j,icuaId,updateDateTime,icucriId,icucdSub)=$lb(curId,curIcucriId,oeoreId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,icuoConcentration,icuoOriginateFromIcuodr,phcinId,ancvcId,icuoFlag,icuoDrugMode,icuoSpeed,curUpdateDate,curUpdateTime,icuoReason,curEditFlag,curEditedId,icuoRecLocId,curDocUserId,icuoVolume,icuoSpeedUnitDr,icuoSource,icuoType,icucriDesc,arcimDesc,icuoPreparedVolume,icuoAttachOeoriId,icuoReportResult,icuaId,mainOeoriId,subOeoriId,oecprDesc,phcinDesc,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoMainIcuoDr,icuoRemarks,icuoIcupiDr,doseSpeed)
	q 0
    
OutputIcuOrder
	//s Data=$lb(curId,curIcucriId,oeoreId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,icuoConcentration,icuoOriginateFromIcuodr,phcinId,ancvcId,icuoFlag,icuoDrugMode,icuoSpeed,curUpdateDate,curUpdateTime,icuoReason,curEditFlag,curEditedId,icuoRecLocId,curDocUserId,icuoVolume,icuoSpeedUnitDr,icuoSource,icuoType,icucriDesc,arcimDesc,icuoPreparedVolume,icuoAttachOeoriId,icuoReportResult,icuaId,mainOeoriId,subOeoriId,oecprDesc,phcinDesc,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoMainIcuoDr,icuoRemarks,icuoIcupiDr)
	//s Data=$lb(Id,RecordItemId,OeoreId,UserId,StartDate,StartTime,EndDate,EndTime,ArcimId,Note,Qty,UomId,Concentration,OriginalOrderId,InstrId,RecordCatId,Flag,DrugMode,Speed,UpdateDate,UpdateTime,Reason,EditFlag,EditedIcuoId,RecvLoc,DocUserId,Volume,SpeedUnitId,Source,Type,icucriDesc,ArcimDesc,PrepareIntake,AttachOeoriId,Report,ArrangeId,MainOeoreId,SubOrderId,Priority,Instruction,Frequency,OeoriNote,Abbreviate,OrderItemNote,MainIcuoId,Remarks,ParaItemId)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	s ^DHCICUDebug(icuaId,ind)=Data
	q
}

ClassMethod FindIcuOrderDebugFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindIcuOrderExecute ]
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

ClassMethod FindIcuOrderDebugClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindIcuOrderExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Creator：    YuanLin
/// CreatDate：  2016-11-03
/// Input：      上传日期、病人IcuaId、护士Id
/// Description：保存护士向FTP服务器上传护理记录单PDF的操作记录
/// w ##class(web.DHCICUOrder).SaveSubmitRecord("2016-11-11",92,69)
ClassMethod SaveSubmitRecord(printDT, IcuaId, userId) As %String
{
	q:printDT="" "请选择上传日期!"
	q:IcuaId="" "病人Id不能为空!"
	q:userId="" "用户Id不能为空!"
	s RowId="",saveFlag="N",EndDate="",EndTime=""
	s SubmitDate=$p($h,",",1)
	s SubmitTime=$p($h,",",2)
	s printDT=$zdh(printDT,3)
	s ^DHCICUArrange(0,"SubmitRecord",IcuaId,0)=""
	s rowId="" f  s rowId=$O(^DHCICUArrange(0,"SubmitRecord",IcuaId,rowId)) q:(rowId="")  d     //查找是否已有该天的上传记录存在
	.s printDate=$p(^DHCICUArrange(0,"SubmitRecord",IcuaId,rowId),"^",1)
	.q:(printDate'=printDT)
	.s ^DHCICUArrange(0,"SubmitRecord",IcuaId,rowId)=printDT_"^"_SubmitDate_"^"_SubmitTime_"^"_userId
	.s saveFlag="Y"
	i saveFlag="N" d
	.s RowId=$O(^DHCICUArrange(0,"SubmitRecord",IcuaId,RowId),-1)
	.s ^DHCICUArrange(0,"SubmitRecord",IcuaId,RowId+1)=printDT_"^"_SubmitDate_"^"_SubmitTime_"^"_userId
	s EndDate=$p(^DHCICUArrange(IcuaId),"^",7)
	s EndTime=$p(^DHCICUArrange(IcuaId),"^",9)
	i ((EndDate="")||(EndTime="")) d
	.s $p(^DHCICUArrange(IcuaId),"^",7)=$p($g(^DHCICUArrange(+IcuaId)),"^",44)
    .s $p(^DHCICUArrange(IcuaId),"^",9)=$p($g(^DHCICUArrange(+IcuaId)),"^",45)
	q 0
}

/// Creator：    YuanLin
/// CreatDate：  2016-11-04
/// Input：      上传日期、病人IcuaId、护士Id
/// Description：输出上传护理记录单PDF的操作记录
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetSubmitRecord",92)
Query GetSubmitRecord(IcuaId) As %Query(ROWSPEC = "printDT,SubmitDT,userDesc") [ SqlProc ]
{
}

ClassMethod GetSubmitRecordExecute(ByRef qHandle As %Binary, IcuaId) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	k ^TMPICU("Record",$j)
	k ^TMPICU("List",IcuaId)
	s rowId=0,printDTRowId=0,SubmitDT="",userDesc=""
	f  s rowId=$O(^DHCICUArrange(0,"SubmitRecord",IcuaId,rowId))  q:(rowId="")  d
	.s printDT=$p(^DHCICUArrange(0,"SubmitRecord",IcuaId,rowId),"^",1)
	.s SubmitDate=$p(^DHCICUArrange(0,"SubmitRecord",IcuaId,rowId),"^",2)
	.s SubmitTime=$p(^DHCICUArrange(0,"SubmitRecord",IcuaId,rowId),"^",3)
	.s userId=$p(^DHCICUArrange(0,"SubmitRecord",IcuaId,rowId),"^",4)
	.s ^TMPICU("List",IcuaId,printDT)=printDT_"^"_SubmitDate_"^"_SubmitTime_"^"_userId
	f  s printDTRowId=$O(^TMPICU("List",IcuaId,printDTRowId))  q:(printDTRowId="")  d
	.s printDT=$p(^TMPICU("List",IcuaId,printDTRowId),"^",1)
	.s SubmitDate=$p(^TMPICU("List",IcuaId,printDTRowId),"^",2)
	.s SubmitTime=$p(^TMPICU("List",IcuaId,printDTRowId),"^",3)
	.s userId=$p(^TMPICU("List",IcuaId,printDTRowId),"^",4)
	.i printDT'=""  s printDT=$ZD(printDT,3)
	.i SubmitDate'=""  s SubmitDate=$ZD(SubmitDate,3)
	.i SubmitTime'=""  s SubmitTime=$ZT(SubmitTime,2)
	.i (SubmitDate'=""&& SubmitTime'="") s SubmitDT=SubmitDate_" "_SubmitTime
	.i userId'="" s userDesc=$p($g(^SSU("SSUSR",userId)),"^",2)
	.s ^TMPICU("Record",IcuaId,$j)=$lb(printDT,SubmitDT,userDesc)
	.do OutputRecord
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRecord
	s ^CacheTemp(repid,ind)=^TMPICU("Record",IcuaId,$j)
 	s ind=ind+1
	q
}

ClassMethod GetSubmitRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSubmitRecordExecute ]
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

ClassMethod GetSubmitRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSubmitRecordExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 取监护数据DHC_ICU_Order
/// 入参：监护Id,就诊号EpisodeID,病区wardLocId，科室ctlocId(可为病区,为科室时找关联病区),
/// 所需要查询的显示分类ancvcIdStr(用"^"分割的串)查，起止时间。icuoSourceStr="MA"只取手工录入数据
Query FindIcuOrderByDischarge(icuaId, startDate, startTime, endDate, endTime, EpisodeID = "", ctlocId = "", ancvcIdStr = "", icuoSourceStr = "", shiftStartTime = "") As %Query(ROWSPEC = "Id,RecordItemId,OeoreId,UserId,StartDate,StartTime,EndDate,EndTime,ArcimId,Note,Qty,UomId,Concentration,OriginalOrderId,InstrId,RecordCatId,Flag,DrugMode,Speed,UpdateDate,UpdateTime,Reason,EditFlag,EditedIcuoId,RecvLoc,DocUserId,Volume,SpeedUnitId,Source,Type,AncoDesc,ArcimDesc,PrepareIntake,AttachOeoriId,Report,ArrangeId,MainOeoreId,SubOrderId,Priority,Instruction,Frequency,OeoriNote,Abbreviate,OrderItemNote,MainIcuoId,Remarks,ParaItemId,DoseSpeed,TotalQty") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","FindIcuOrderByDischarge",1945,60000,0,66000,0,"","","","MAI")
ClassMethod FindIcuOrderByDischargeExecute(ByRef qHandle As %Binary, icuaId, startDate, startTime, endDate, endTime, EpisodeID = "", ctlocId = "", ancvcIdStr = "", icuoSourceStr = "", shiftStartTime = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	s ^dhcicudebug("FindIcuOrderByDischarge")=icuaId_","_startDate_","_startTime_","_endDate_","_endTime_","_EpisodeID_","_ctlocId_","_ancvcIdStr_","_icuoSourceStr_","_shiftStartTime
	k ^TMPICU("Order",$j)
	//k ^TMPICU("OrderRet",$j)
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s endTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
	i shiftStartTime'="" s shiftStartTime=##class(web.DHCClinicCom).ConvertToTimeH(shiftStartTime)
	i startTime\60*60=startTime s startTime=startTime+30
	i endTime\60*60=endTime s endTime=endTime+30
	i shiftStartTime'="",shiftStartTime\60*60=shiftStartTime s shiftStartTime=shiftStartTime+30
	i (icuaId'="")&(shiftStartTime'="") d
		.s icuaStartDate=$p(^DHCICUArrange(icuaId),"^",6)
		.//i startTime<shiftStartTime s startDate=startDate-1
		.i startTime'>shiftStartTime s startDate=startDate-1
		.s startTime=shiftStartTime
		.
		.///取打印记录最早时间作为数据开始时间
		.s icuprId="",isFind=0
		.f  s icuprId=$o(^DHCICUArrange(icuaId,"PR",icuprId),-1) q:(+icuprId=0)!(isFind)  d
			..s icuprDate=$p(^DHCICUArrange(icuaId,"PR",icuprId),"^")
			..s icuprTime=$p(^DHCICUArrange(icuaId,"PR",icuprId),"^",2)
			..i ##class(web.DHCClinicCom).CompareDateTime(startDate,startTime,icuprDate,icuprTime)>0 d
				...s printSecond=icuprTime-(icuprTime\60*60)
				...//s ^tmpYpz("startDT",11)=^tmpYpz("startDT",11)_"|"_icuprId_"^"_printSecond
				...q:(printSecond=21) //小结所在行为21和22秒，跨行显示
				...s startDate=icuprDate
				...s startTime=icuprTime+1
				...s isFind=1
		.i 'isFind d //取监护开始时间
			..s startDate=icuaStartDate,startTime=$p(^DHCICUArrange(icuaId),"^",8)
			..s startTime=startTime-18000
			..i startTime<0 s startTime=startTime+86400,startDate=startDate-1
		.///取打印记录最晚时间页的结束时间作为数据结束时间
		.s icuprId=0,isFind=0
		.f  s icuprId=$o(^DHCICUArrange(icuaId,"PR",icuprId)) q:(+icuprId=0)!(isFind)  d
			..s icuprDate=$p(^DHCICUArrange(icuaId,"PR",icuprId),"^")
			..s icuprTime=$p(^DHCICUArrange(icuaId,"PR",icuprId),"^",2)
			..i ##class(web.DHCClinicCom).CompareDateTime(endDate,endTime,icuprDate,icuprTime)<1 d
				...s endDate=icuprDate
				...s endTime=icuprTime+1
				...s isFind=1
	s sttDateTime=startDate+(startTime/100000)
	s endDateTime=endDate+(endTime/100000)
	s icuaIdList=##class(web.DHCICUCom).FindIcuaIdList(icuaId, EpisodeID,ctlocId)
	i icuaIdList="" s qHandle=$lb(0,repid,0) q $$$OK
	
	//s ancvcCodeList=$g(^DHCCLSet("ICU","AllDataAncvcCode"))
	//s icucriIdStr=##class(web.DHCICUCom).GetAncoIdByAncvcCode(ancvcCodeList)
	s icucriIdStr=##class(web.DHCICUCom).GetIcucriIdByAncvcId(ancvcIdStr)
	s curDateTime=$h+($p($h,",",2)/100000)
	s fDate=startDate-1
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
	        ..q:icuoSourceStr="I"
	        ..
	        ..k adjTimeList
	        ..s icuoSttTime=""
	        ..f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
	            ...//q:(curDate=startDate)&(icuoSttTime<startTime)
	            ...//q:(curDate=endDate)&(icuoSttTime'<endTime)  //结束时间跨时间段?
	            ...k tmpCurTime //当前时间点最后修改数据记录
	            ...s haveDrug=0,haveMonData=0,haveExclude=0
	            ...s icuoId="",seq=0
	            ...f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
	                ....q:$d(^DHCICUOrder(icuoId))<1
	                ....s icucriId=$p(^DHCICUOrder(icuoId),"^",2)
	                ....q:(icucriIdStr'="")&(icucriId'="")&(("^"_icucriIdStr_"^")[("^"_icucriId_"^"))
	                ....q:$$GetIcuoData("Y")<0
	                .... 
	                ....s icucriCode=""
	                ....i icucriId'="" s icucriCode=$p($g(^DHCICUC("RecordItem",+icucriId)),"^")
	                ....q:icucriCode=""
	                ....//i (arcimId'="")!(icucriCode="UserDefinedDrugItem") s haveDrug=1
	                ....i (arcimId'="")!($p(^DHCICUC("RecordItem",+icucriId),"^",3)="D") s haveDrug=1
	                ....i (icucriCode'="NursingRecord")!($p(^DHCICUOrder(icuoId),"^",17)'="T") s haveMonData=1
	                ....
	                ....q:(arcimId="")&(icucriCode'="UserDefinedDrugItem")&(icucriCode'="NursingRecord")
	                ....q:(icucriCode="NursingRecord")&($p(^DHCICUOrder(icuoId),"^",17)'="T") //非独占时间
	                ....//q:(startTime-(startTime\60*60)>20) //非生成数据
	                ....
	                ....s adjTimeList(icuoStartDateTime)=""
	                ....s mainIcuoId=$p(^DHCICUOrder(icuoId),"^",36)
	                ....i mainIcuoId="" s mainIcuoId=icuoId
	                ....i (icucriCode="NursingRecord")&($p(^DHCICUOrder(icuoId),"^",17)="T") d
	                	.....s mainIcuoId=0_mainIcuoId //保证护理记录在后面
	                	.....s haveExclude=1
	                ....s adjTimeList(icuoStartDateTime,mainIcuoId,icuoId)=updateDateTime_"^"_oreGroup_icucriId_arcimId_"^"_icuoId
	            ...i 'haveDrug,haveMonData,haveExclude s adjTimeList(icuoStartDateTime,0,0)=0
			..s icuoStartDateTime=""
			..f  s icuoStartDateTime=$o(adjTimeList(icuoStartDateTime)) q:icuoStartDateTime=""  d
				...s mainIcuoId=$o(adjTimeList(icuoStartDateTime,"")) //第一个时间不调整
				...f  s mainIcuoId=$o(adjTimeList(icuoStartDateTime,mainIcuoId)) q:mainIcuoId=""  d
					....q //新版暂不自动调整时间
					....
					....s curDateTime=icuoStartDateTime
					....s isFind=0,newDateTime=""
					....
					....f j=1:1:20 d //暂用20个
						.....s curDateTime=curDateTime+0.00001
						.....i curDateTime-$p(curDateTime,".")>0.86399 s curDateTime=$p(curDateTime,".")+1
						.....q:$d(adjTimeList(curDateTime))
						.....q:isFind
						.....s newDateTime=curDateTime
						.....s isFind=1
					....//w mainIcuoId_"/"_icuoStartDateTime_"/"_newDateTime,!
					....q:newDateTime=""
					....s adjTimeList(newDateTime)=""
					....s adjTimeList(icuoStartDateTime,mainIcuoId)=newDateTime
					....s icuoStartTime=(icuoStartDateTime-$p(icuoStartDateTime,"."))*100000
					....s newTime=(newDateTime-$p(newDateTime,"."))*100000
					....s icuoId=""
					....f  s icuoId=$o(adjTimeList(icuoStartDateTime,mainIcuoId,icuoId)) q:icuoId=""  d
						.....s updateDateTime=$p(adjTimeList(icuoStartDateTime,mainIcuoId,icuoId),"^",1)
						.....s oreGroupStr=$p(adjTimeList(icuoStartDateTime,mainIcuoId,icuoId),"^",2)
						.....q:'$d(^TMPICU("Order",$j,icuaId,updateDateTime,oreGroupStr,icuoId))
						.....s $p(^TMPICU("Order",$j,icuaId,updateDateTime,oreGroupStr,icuoId),"^",6)=$zt(newTime)
						.....k ^DHCICUOrder(0,"SttDateTime",$p(icuoStartDateTime,"."),icuaId,icuoStartTime,icuoId)
						.....s ^DHCICUOrder(0,"SttDateTime",$p(icuoStartDateTime,"."),icuaId,newTime,icuoId)=""
						.....s $p(^DHCICUOrder(icuoId),"^",6)=newTime
	f i=1:1:$l(icuaIdList,"^") d
		.s icuaId=$p(icuaIdList,"^",i)
		.q:icuaId=""
		.f j=1:1:$l(icucriIdStr,"^") d
			..s icucriId=$p(icucriIdStr,"^",j)
			..q:icucriId=""
			..s icuoId="",seq=0
			..f  s icuoId=$o(^DHCICUOrder(0,"CommOrd",icucriId,icuaId,icuoId)) q:icuoId=""  d
				...q:$$GetIcuoData("Y")<0
	
	s icuaId="" f  s icuaId=$o(^TMPICU("Order",$j,icuaId))  q:icuaId=""  d
	 	.s updateDateTime="" f  s updateDateTime=$o(^TMPICU("Order",$j,icuaId,updateDateTime))  q:updateDateTime=""  d
	     	..s icucriArcimId="" f  s icucriArcimId=$o(^TMPICU("Order",$j,icuaId,updateDateTime,icucriArcimId))  q:icucriArcimId=""  d
	         	...s icuoId="" f  s icuoId=$o(^TMPICU("Order",$j,icuaId,updateDateTime,icucriArcimId,icuoId))  q:icuoId=""  d
	             	....//s i=i+1
	             	....//s ^TMPICU("OrderRet",$j,i)=^TMPICU("Order",$j,icuaId,updateDateTime,icucriArcimId,icuoId)
	             	....s Data=^TMPICU("Order",$j,icuaId,updateDateTime,icucriArcimId,icuoId)
	             	....d OutputIcuOrder
 	s qHandle=$lb(0,repid,0)
	q $$$OK
GetIcuoData(ifByDateTime = "")
	q:'$d(^DHCICUOrder(icuoId)) -1
	q:(icuoSourceStr'="")&(icuoSourceStr'[$p(^DHCICUOrder(icuoId),"^",29)) -2
	s icuoUpdateDate=$p(^DHCICUOrder(icuoId),"^",21)
	s icuoUpdateTime=$p(^DHCICUOrder(icuoId),"^",22)
	s icuoStartDate=$p(^DHCICUOrder(icuoId),"^",5)
	s icuoStartTime=$p(^DHCICUOrder(icuoId),"^",6)
	s icuoEndDate=$p(^DHCICUOrder(icuoId),"^",7)
	s icuoEndTime=$p(^DHCICUOrder(icuoId),"^",8)
	s mainIcuoEditFlag=$p(^DHCICUOrder(icuoId),"^",25)
	q:"I"[mainIcuoEditFlag -3 //旧版本ICD

	s icuoStartDateTime=icuoStartDate+(icuoStartTime/100000)
	s icuoEndDateTime=icuoEndDate+(icuoEndTime/100000)
	q:(ifByDateTime="Y")&(icuoEndDateTime'>sttDateTime) -4 //开始时间点不计
	q:(ifByDateTime="Y")&(icuoStartDateTime>endDateTime) -5 //结束时间点计入
	//q:($p(^DHCICUOrder(icuoId),"^",29)="I")&(curDateTime-icuoStartDateTime>30) -6 //不查看三十天以上的数据，旧版一天
	
	s arcimId=$p(^DHCICUOrder(icuoId),"^",9)				//ICUO_ARCIM_Dr
	s icucriId=$p(^DHCICUOrder(icuoId),"^",2)				//ICUO_ComOrd_Dr
	q:(icucriIdStr'="")&(("^"_icucriIdStr_"^")'[("^"_icucriId_"^")) -7
	s ancvcId=$p(^DHCICUOrder(icuoId),"^",16)			//ICUO_ViewCat_Dr
	q:(icucriId="")&(arcimId="")&(ancvcId="") -8
	s oeoreId=$p(^DHCICUOrder(icuoId),"^",3)
	s oeordId=+oeoreId
	s oeoriSub=$p(oeoreId,"||",2)
	s oeoreSub=$p(oeoreId,"||",3)
	s oeoriId=""
	i oeoriSub'="" s oeoriId=oeordId_"||"_oeoriSub
	
	i $p($g(^DHCICUC("RecordItem",+icucriId)),"^",2)="MicroPump" d
		.q:oeoriSub=""
		.s xDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",34)
    	.q:xDate=""
    	.s xTime=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",15)
		.i ##class(web.DHCClinicCom).CompareDateTime(icuoEndDate,icuoEndTime,xDate,xTime)>0 d
			..s icuoEndDate=xDate,icuoEndTime=xTime
			..i ##class(web.DHCClinicCom).CompareDateTime(icuoStartDate,icuoStartTime,icuoEndDate,icuoEndTime)>0 d
				...s icuoEndDate=icuoStartDate,icuoEndTime=icuoStartTime
			..s $p(^DHCICUOrder(icuoId),"^",7)=icuoEndDate,$p(^DHCICUOrder(icuoId),"^",8)=icuoEndTime
	
	s curId=icuoId //s tmpStr=icuoId_"^"
	s curIcucriId=icucriId //s tmpStr=tmpStr_icucriId_"^"
	//s tmpStr=tmpStr_oeoreId_"^"	//ICUO_OEORE_Dr
	s curUserId=$p(^DHCICUOrder(icuoId),"^",4) // tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",4)_"^"	//ICUO_User_Dr
	s curStartDate=$zd(icuoStartDate,3) //s tmpStr=tmpStr_$ZD(icuoStartDate,3)_"^"			//ICUO_StartDate
	s curStartTime=$zt(icuoStartTime) //s tmpStr=tmpStr_$ZT(icuoStartTime)_"^"
	s curEndDate=$zd(icuoEndDate,3) //s tmpStr=tmpStr_$ZD(icuoEndDate,3)_"^"
	s curEndTime=$zt(icuoEndTime) //s tmpStr=tmpStr_$ZT(icuoEndTime)_"^"
	//s tmpStr=tmpStr_arcimId_"^"
	s curNote=$p(^DHCICUOrder(icuoId),"^",10) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",10)_"^"	//ICUO_Note num:10
	s curQty=$p(^DHCICUOrder(icuoId),"^",11) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",11)_"^"	//ICUO_Qty
	
	s oeorditemStr=..GetOeorditemInfo(oeoriId)
	i oeorditemStr="" s oeorditemStr=..GetICUOrditemInfo(icuoId)
	s uomId=$p(^DHCICUOrder(icuoId),"^",12)
	i uomId="" s uomId=$p(oeorditemStr,"^",12)
	//s tmpStr=tmpStr_uomId_"^"	//ICUO_Uom_Dr
	s icuoConcentration=$p(^DHCICUOrder(icuoId),"^",13) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",13)_"^"	//ICUO_Concentration
	s icuoOriginateFromIcuodr=$p(^DHCICUOrder(icuoId),"^",14) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",14)_"^"	//ICUO_OriginateFromICUO_Dr
	s phcinId=$p(^DHCICUOrder(icuoId),"^",15)	
	//s tmpStr=tmpStr_phcinId_"^"	//ICUO_Instr_Dr
	s ancvcDesc=""
	i ancvcId'="" s ancvcDesc=$p($g(^DHCICUC("ViewCat",ancvcId)),"^",2)
	s doseSpeed=$p($g(^DHCICUOrder(icuoId)),"^",40)
	i (+doseSpeed=0)&(icucriId=5380) s doseSpeed=##class(web.DHCICUOrder).GetDoseSpeed(icuoId,"","DoseSpeed")
	//s tmpStr=tmpStr_ancvcId_"^" //tmpStr_ancvcDesc_"^"
	s icuoFlag=$p(^DHCICUOrder(icuoId),"^",17) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",17)_"^"	//ICUO_Flag
	s icuoDrugMode=$p(^DHCICUOrder(icuoId),"^",18) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",18)_"^"	//ICUO_DrugMode
	s icuoSpeed=$p(^DHCICUOrder(icuoId),"^",19) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",19)_"^"	//ICUO_Speed
	s curUpdateDate=$zd(icuoUpdateDate,3) //s tmpStr=tmpStr_$ZD(icuoUpdateDate,3)_"^" //num:20
	s curUpdateTime=$zt(icuoUpdateTime) //s tmpStr=tmpStr_$ZT(icuoUpdateTime)_"^"
	s icuoReason=$p(^DHCICUOrder(icuoId),"^",24) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",24)_"^"	//ICUO_Reason
	s curEditFlag=$p(^DHCICUOrder(icuoId),"^",25) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",25)_"^"	//ICUO_EditFlag
	s curEditedId=$p(^DHCICUOrder(icuoId),"^",23) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",23)_"^"	//ICUO_ICUO_DR
	s icuoRecLocId=$p(^DHCICUOrder(icuoId),"^",26) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",26)_"^"	//ICUO_RecLoc_Dr
	s curDocUserId=$p(^DHCICUOrder(icuoId),"^",27) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",27)_"^"	//ICUO_DocUser_Dr
	s icuoVolume=+$p(^DHCICUOrder(icuoId),"^",28) //s tmpStr=tmpStr_+$p(^DHCICUOrder(icuoId),"^",28)_"^"	//ICUO_Volume
	s icuoSpeedUnitDr=$p(^DHCICUOrder(icuoId),"^",20) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",20)_"^" //ICUO_SpeedUnit_Dr
	s icuoSource=$p(^DHCICUOrder(icuoId),"^",29) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",29)_"^"	//ICUO_Source
	s icuoType=$p(^DHCICUOrder(icuoId),"^",30) //tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",30)_"^"	//ICUO_Type //num:30
	s icucriDesc=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",2) //s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",+$p(^DHCICUOrder(icuoId),"^",2))),"^",2)_"^"
	s arcimDesc=$p($g(^ARCIM(+arcimId,1,1)),"^",2) //s tmpStr=tmpStr_$p($g(^ARCIM(+arcimId,1,1)),"^",2)_"^"
	s icuoPreparedVolume=+$p(^DHCICUOrder(icuoId),"^",31) //s tmpStr=tmpStr_+$p(^DHCICUOrder(icuoId),"^",31)_"^"	//ICUO_PreparedVolume
	s icuoAttachOeoriId=$p(^DHCICUOrder(icuoId),"^",32) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",32)_"^"     //ICUO_AttachOeoriId
	s icuoReportResult=$p(^DHCICUOrder(icuoId),"^",33) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",33)_"^"     //ICUO_ReportResult
	//s tmpStr=tmpStr_icuaId_"^"  //
	i $p(oeorditemStr,"^",6)'="" s $p(oeorditemStr,"^",6)=$p(oeorditemStr,"^",6)_"||"_oeoreSub
	s mainOeoriId=$p(oeorditemStr,"^",6) //s tmpStr=tmpStr_$p(oeorditemStr,"^",6)_"^"		//主医嘱mainOeoriId
	s subOeoriId=$p(oeorditemStr,"^",7) //s tmpStr=tmpStr_$p(oeorditemStr,"^",7)_"^"		//从医嘱subOeoriId
	s oecprDesc=$p(oeorditemStr,"^",13) //s tmpStr=tmpStr_$p(oeorditemStr,"^",13)_"^"		//优先级
	s phcinDesc=$p(oeorditemStr,"^",5) //s tmpStr=tmpStr_$p(oeorditemStr,"^",5)_"^"		//用法 phcinDesc  40
	s prcfrDesc=$p(oeorditemStr,"^",15) //s tmpStr=tmpStr_$p(oeorditemStr,"^",15)_"^"		//频率 num: 41
	s oeoriNote=$p(oeorditemStr,"^",17) //s tmpStr=tmpStr_$p(oeorditemStr,"^",17)_"^"		//医嘱备注 42
	s curAbbreviate=$p(^DHCICUOrder(icuoId),"^",34)
	i curAbbreviate="" s curAbbreviate=##class(web.DHCClinicCom).GetOeoriGroupDesc(oeoriId)
	//s tmpStr=tmpStr_icuoAbbreviate_"^"	//常用医嘱缩写 ICUO_Abbreviate
	//s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",34)_"^"	//常用医嘱缩写 ICUO_Abbreviate
	s icuoOrdItemNote=$p(^DHCICUOrder(icuoId),"^",35) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",35)_"^"	//HIS医嘱说明 ICUO_OrdItemNote
	s icuoMainIcuoDr=$p(^DHCICUOrder(icuoId),"^",36) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",36)_"^"	//主医嘱的ICUOId：ICUO_MainIcuo_Dr
	s icuoRemarks=$p(^DHCICUOrder(icuoId),"^",37) //s tmpStr=tmpStr_$p(^DHCICUOrder(icuoId),"^",37)	//ICUO_Remarks
	s icuoIcupiDr=$p(^DHCICUOrder(icuoId),"^",38) //s tmpStr=tmpStr_"^"_$p(^DHCICUOrder(icuoId),"^",38)	//ICUO_ICUPI_Dr  total 47

	s mainOeoriSub=$p(mainOeoriId,"||",2)
	s tmpDateTime=icuoStartDate+(icuoStartTime/100000)
	s tmpSub=oeoriSub
	i mainOeoriSub="" s mainOeoriSub=oeoriSub,tmpSub=0
	s oreGroup=mainOeoriSub+((seq/100)+(tmpSub/1000000))
	
	s updateDateTime=icuoUpdateDate+(icuoUpdateTime/100000)
	s curTimeStr=icucriId_","_oeoreId_","_icuoIcupiDr_"^"_icuoStartDateTime
	s originalAncvcId=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",5)
	//i ("^"_$g(^DHCCLSet("CollectAncvcId"))_"^")[originalAncvcId s curTimeStr=icucriId_","
	i icucriId>0,"EN"[mainIcuoEditFlag,$g(tmpCurTime(curTimeStr))'="" d //clear duplicate data
		.//w updateDateTime_" update/"_icucriId_"/"_icuoId_": "_tmpCurTime(curTimeStr),!
		.i updateDateTime'<$g(tmpCurTime(curTimeStr)) d
			..k ^TMPICU("Order",$j,icuaId,$p(tmpCurTime(curTimeStr),"^"),$p(tmpCurTime(curTimeStr),"^",2),$p(tmpCurTime(curTimeStr),"^",3))
			..s clearIcuoId=+$p(tmpCurTime(curTimeStr),"^",3)
			..q:'$d(^DHCICUOrder(clearIcuoId))
			..s $p(^DHCICUOrder(clearIcuoId),"^",25)=""
			..s ^TMPICUClear(clearIcuoId)=icuaId_"/"_$h_"/"_icuoStartDateTime
		.e  d
			..//w icuoId_"/"_curTimeStr_"/"_$g(tmpCurTime(curTimeStr)),!
			..s $p(^DHCICUOrder(icuoId),"^",25)=""
			..s ^TMPICUClear(icuoId)=icuaId_"/"_$h_"/"_icuoStartDateTime
			..//w "k:"_icuoId
	q:("EN"[mainIcuoEditFlag)&(updateDateTime<$g(tmpCurTime(curTimeStr))) -11 //当前时间点有正常数据，但不是最新修改
	//i startDate=63204,icucriId=5330 w mainIcuoEditFlag_"/3:"_updateDateTime_"^"_oreGroup_","_icucriId_","_arcimId_"^"_icuoId,!
	i ("EN"[mainIcuoEditFlag)&(icucriId>0) d
		.s tmpCurTime(curTimeStr)=updateDateTime_"^"_oreGroup_","_icucriId_","_arcimId_"^"_icuoId //记录最新修改数据
	 	.//i startDate=63204,icucriId=5330 w curTimeStr_"/4:"_tmpCurTime(curTimeStr),!
	 	.//w curTimeStr_"/tmpCurTime:"_tmpCurTime(curTimeStr),!
	s curId=icuoId
	s icuodSub=0
	s totalQty=$p(^DHCICUOrder(icuoId),"^",39)
	s ^TMPICU("Order",$j,icuaId,updateDateTime,oreGroup_","_icucriId_","_arcimId,icuoId)=$lb(curId,curIcucriId,oeoreId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,icuoConcentration,icuoOriginateFromIcuodr,phcinId,ancvcId,icuoFlag,icuoDrugMode,icuoSpeed,curUpdateDate,curUpdateTime,icuoReason,curEditFlag,curEditedId,icuoRecLocId,curDocUserId,icuoVolume,icuoSpeedUnitDr,icuoSource,icuoType,icucriDesc,arcimDesc,icuoPreparedVolume,icuoAttachOeoriId,icuoReportResult,icuaId,mainOeoriId,subOeoriId,oecprDesc,phcinDesc,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoMainIcuoDr,icuoRemarks,icuoIcupiDr,doseSpeed,totalQty)
	//s ^TMPICU("Order",$j,icuaId,updateDateTime,oreGroup_","_icucriId_","_arcimId,icuoId_","_icuodSub)=$lb(curId,curIcucriId,oeoreId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,icuoConcentration,icuoOriginateFromIcuodr,phcinId,ancvcId,icuoFlag,icuoDrugMode,icuoSpeed,curUpdateDate,curUpdateTime,icuoReason,curEditFlag,curEditedId,icuoRecLocId,curDocUserId,icuoVolume,icuoSpeedUnitDr,icuoSource,icuoType,icucriDesc,arcimDesc,icuoPreparedVolume,icuoAttachOeoriId,icuoReportResult,icuaId,mainOeoriId,subOeoriId,oecprDesc,phcinDesc,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoMainIcuoDr,icuoRemarks,icuoIcupiDr)
	//s ^TMPICU("Ordes",$j,icuaId,updateDateTime,oreGroup_","_icucriId_","_arcimId,icuoId_","_icuodSub)=curId_"^"_curIcucriId_"^"_oeoreId_"^"_curUserId_"^"_curStartDate_"^"_curStartTime_"^"_curEndDate_"^"_curEndTime_"^"_arcimId_"^"_curNote_"^"_curQty_"^"_uomId_"^"_icuoConcentration_"^"_icuoOriginateFromIcuodr_"^"_phcinId_"^"_ancvcId_"^"_icuoFlag_"^"_icuoDrugMode_"^"_icuoSpeed_"^"_curUpdateDate_"^"_curUpdateTime_"^"_icuoReason_"^"_curEditFlag_"^"_curEditedId_"^"_icuoRecLocId_"^"_curDocUserId_"^"_icuoVolume_"^"_icuoSpeedUnitDr_"^"_icuoSource_"^"_icuoType_"^"_icucriDesc_"^"_arcimDesc_"^"_icuoPreparedVolume_"^"_icuoAttachOeoriId_"^"_icuoReportResult_"^"_icuaId_"^"_mainOeoriId_"^"_subOeoriId_"^"_oecprDesc_"^"_phcinDesc_"^"_prcfrDesc_"^"_oeoriNote_"^"_curAbbreviate_"^"_icuoOrdItemNote_"^"_icuoMainIcuoDr_"^"_icuoRemarks_"^"_icuoIcupiDr
	//w "all:"_tmpStr,!
	f  s icuodSub=$o(^DHCICUOrder(icuoId,"D",icuodSub)) q:icuodSub=""  d
		.q //未用
		.
		.q:"C"[mainIcuoEditFlag
		.q:$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",12)["D"
		.s icuodStartDate=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",1)
		.s icuodStartTime=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",2)
		.s icuodStartDateTime=icuodStartDate+(icuodStartTime/100000)
		.q:endDateTime'>icuodStartDateTime
	 	.s icuodEndDate=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",3)
		.s icuodEndTime=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",4)
		.s icuodEndDateTime=icuodEndDate+(icuodEndTime/100000)
		.q:sttDateTime>icuodEndDateTime
		.
		.s curId=icuoId_"||"_icuodSub //s $p(tmpStr,"^",1)=icuoId_"||"_icuodSub
		.s curStartDate=$zd(icuodStartDate,3) //s $p(tmpStr,"^",5)=$ZD(icuodStartDate,3)
	 	.s curStartTime=$zt(icuodStartTime) //s $p(tmpStr,"^",6)=$ZT(icuodStartTime)
		.s curEndDate=$zd(icuodEndDate,3) //s $p(tmpStr,"^",7)=$ZD(icuodEndDate,3)
		.s curEndTime=$zt(icuodEndTime) //s $p(tmpStr,"^",8)=$ZT(icuodEndTime)
		.s curIcucriId=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",5) //ICUOD_ComOrd_Dr
		.s curAbbreviate=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",6) //ICUOD_Abbreviate
		.s curQty=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",7) //icuod_Qty
		.s curNote=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",8) //icuod_Note
		.s curUserId=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",9) //icuod_User_Dr
		.s curUpdateDate=$zd($p(^DHCICUOrder(icuoId,"D",icuodSub),"^",10),3) //icuod_UpdateDate
		.s curUpdateTime=$zt($p(^DHCICUOrder(icuoId,"D",icuodSub),"^",11)) //icuod_UpdateTime
		.s curEditFlag=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",12) //icuod_EditFlag
	    .s curEditedId=$p(^DHCICUOrder(icuoId,"D",icuodSub),"^",13) //icuod_icuod_Dr
		.s ^TMPICU("Order",$j,icuaId,updateDateTime,oreGroup_","_icucriId_","_arcimId,icuoId_","_icuodSub)=$lb(curId,curIcucriId,oeoreId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,icuoConcentration,icuoOriginateFromIcuodr,phcinId,ancvcId,icuoFlag,icuoDrugMode,icuoSpeed,curUpdateDate,curUpdateTime,icuoReason,curEditFlag,curEditedId,icuoRecLocId,curDocUserId,icuoVolume,icuoSpeedUnitDr,icuoSource,icuoType,icucriDesc,arcimDesc,icuoPreparedVolume,icuoAttachOeoriId,icuoReportResult,icuaId,mainOeoriId,subOeoriId,oecprDesc,phcinDesc,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoMainIcuoDr,icuoRemarks,icuoIcupiDr)
		.//s ^TMPICU("Ordes",$j,icuaId,updateDateTime,oreGroup_","_icucriId_","_arcimId,icuoId_","_icuodSub)=curId_"^"_curIcucriId_"^"_oeoreId_"^"_curUserId_"^"_curStartDate_"^"_curStartTime_"^"_curEndDate_"^"_curEndTime_"^"_arcimId_"^"_curNote_"^"_curQty_"^"_uomId_"^"_icuoConcentration_"^"_icuoOriginateFromIcuodr_"^"_phcinId_"^"_ancvcId_"^"_icuoFlag_"^"_icuoDrugMode_"^"_icuoSpeed_"^"_curUpdateDate_"^"_curUpdateTime_"^"_icuoReason_"^"_curEditFlag_"^"_curEditedId_"^"_icuoRecLocId_"^"_curDocUserId_"^"_icuoVolume_"^"_icuoSpeedUnitDr_"^"_icuoSource_"^"_icuoType_"^"_icucriDesc_"^"_arcimDesc_"^"_icuoPreparedVolume_"^"_icuoAttachOeoriId_"^"_icuoReportResult_"^"_icuaId_"^"_mainOeoriId_"^"_subOeoriId_"^"_oecprDesc_"^"_phcinDesc_"^"_prcfrDesc_"^"_oeoriNote_"^"_curAbbreviate_"^"_icuoOrdItemNote_"^"_icuoMainIcuoDr_"^"_icuoRemarks_"^"_icuoIcupiDr
	q 0
GetCollectData(ifByDateTime="")
	q:'$d(^DHCICUArrange(icuaId,"C",icucdSub)) -1
	s icucdStartDate=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",2)
	s icucdStartTime=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",3)

	s icucdStartDateTime=icucdStartDate+(icucdStartTime/100000)
	s icucdEndDateTime=icucdStartDateTime
	q:(ifByDateTime="Y")&(icucdEndDateTime'>sttDateTime) -4 //开始时间点不计
	q:(ifByDateTime="Y")&(icucdStartDateTime>endDateTime) -5 //结束时间点计入
	
	s icucriId=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",1)
	q:icucriId="" -2
	s icucdUpdateDate=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",6)
	s icucdUpdateTime=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",7)
	s updateDateTime=icucdUpdateDate+(icucdUpdateTime/100000)
	
	s curId="" //s tmpStr="^" //??
	s curIcucriId=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",1) //s tmpStr=tmpStr_$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",1)_"^"
	s oeoreId="" //s tmpStr=tmpStr_"^"	//ICUO_OEORE_Dr
	s curUserId="" //s tmpStr=tmpStr_"^"	//ICUO_User_Dr
	s curStartDate=$zd($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",2),3) //s tmpStr=tmpStr_$ZD($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",2),3)_"^"	//ICUO_StartDate
	s curStartTime=$zt($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",3)) //s tmpStr=tmpStr_$ZT($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",3))_"^"
	s curEndDate=$zd($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",2),3) //s tmpStr=tmpStr_$ZD($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",2),3)_"^"
	s curEndTime=$zt($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",3)) //s tmpStr=tmpStr_$ZT($p(^DHCICUArrange(icuaId,"C",icucdSub),"^",3))_"^"
	s arcimId="" //s tmpStr=tmpStr_"^"
	s curNote=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",4) //s tmpStr=tmpStr_$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",4)_"^"	//ICUO_Note num:10
	s curQty=$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",5) //s tmpStr=tmpStr_$p(^DHCICUArrange(icuaId,"C",icucdSub),"^",5)_"^"	//ICUO_Qty
	s uomId="" //s tmpStr=tmpStr_"^"	//ICUO_Uom_Dr
	s icuoConcentration="" //s tmpStr=tmpStr_"^"	//ICUO_Concentration
	s icuoOriginateFromIcuodr="" //s tmpStr=tmpStr_"^"	//ICUO_OriginateFromICUO_Dr
	s phcinId="" //s tmpStr=tmpStr_"^"	//ICUO_Instr_Dr
	s ancvcId=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",5) //s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",icucriId)),"^",5)_"^" //tmpStr_ancvcDesc_"^"
	s doseSpeed=""
	s icuoFlag="N" //s tmpStr=tmpStr_"N^"	//ICUO_Flag
	s icuoDrugMode="" //s tmpStr=tmpStr_"^"	//ICUO_DrugMode
	s icuoSpeed="" //s tmpStr=tmpStr_"^"	//ICUO_Speed
	s curUpdateDate=$zd(icucdUpdateDate,3) //s tmpStr=tmpStr_$ZD(icucdUpdateDate,3)_"^" //num:20
	s curUpdateTime=$zt(icucdUpdateTime) //s tmpStr=tmpStr_$ZT(icucdUpdateTime)_"^"
	s icuoReason="" //s tmpStr=tmpStr_"^"	//ICUO_Reason
	s curEditFlag="N" //s tmpStr=tmpStr_"N^"	//ICUO_EditFlag
	s curEditedId="" //s tmpStr=tmpStr_"^"	//ICUO_ICUO_DR
	s icuoRecLocId="" //s tmpStr=tmpStr_"^"	//ICUO_RecLoc_Dr
	s curDocUserId="" //s tmpStr=tmpStr_"^"	//ICUO_DocUser_Dr
	s icuoVolume=0 //s tmpStr=tmpStr_"0^"	//ICUO_Volume
	s icuoSpeedUnitDr="" //s tmpStr=tmpStr_"^" //ICUO_SpeedUnit_Dr
	s icuoSource="A" //s tmpStr=tmpStr_"A^"	//ICUO_Source
	s icuoType=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",3) //s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",icucriId)),"^",3)_"^"	//ICUO_Type //num:30
	s icucriDesc=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",2) //s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",icucriId)),"^",2)_"^"
	s arcimDesc="" //s tmpStr=tmpStr_"^"
	s icuoPreparedVolume=0 //s tmpStr=tmpStr_"0^"	//ICUO_PreparedVolume
	s icuoAttachOeoriId="" //s tmpStr=tmpStr_"^"     //ICUO_AttachOeoriId
	s icuoReportResult="" //s tmpStr=tmpStr_"^"     //ICUO_ReportResult
	//s tmpStr=tmpStr_icuaId_"^"  //
	s mainOeoriId="",subOeoriId="",oecprDesc="",phcinDesc="",prcfrDesc="",oeoriNote="",curAbbreviate="",icuoOrdItemNote="",icuoMainIcuoDr="",icuoRemarks="",icuoIcupiDr=""
	s $p(tmpStr,"^",47)="^"
	s ^TMPICU("Order",$j,icuaId,updateDateTime,icucriId,icucdSub)=$lb(curId,curIcucriId,oeoreId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,icuoConcentration,icuoOriginateFromIcuodr,phcinId,ancvcId,icuoFlag,icuoDrugMode,icuoSpeed,curUpdateDate,curUpdateTime,icuoReason,curEditFlag,curEditedId,icuoRecLocId,curDocUserId,icuoVolume,icuoSpeedUnitDr,icuoSource,icuoType,icucriDesc,arcimDesc,icuoPreparedVolume,icuoAttachOeoriId,icuoReportResult,icuaId,mainOeoriId,subOeoriId,oecprDesc,phcinDesc,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoMainIcuoDr,icuoRemarks,icuoIcupiDr,doseSpeed)
	q 0
    
OutputIcuOrder
	//s Data=$lb(curId,curIcucriId,oeoreId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,icuoConcentration,icuoOriginateFromIcuodr,phcinId,ancvcId,icuoFlag,icuoDrugMode,icuoSpeed,curUpdateDate,curUpdateTime,icuoReason,curEditFlag,curEditedId,icuoRecLocId,curDocUserId,icuoVolume,icuoSpeedUnitDr,icuoSource,icuoType,icucriDesc,arcimDesc,icuoPreparedVolume,icuoAttachOeoriId,icuoReportResult,icuaId,mainOeoriId,subOeoriId,oecprDesc,phcinDesc,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoMainIcuoDr,icuoRemarks,icuoIcupiDr)
	//s Data=$lb(Id,RecordItemId,OeoreId,UserId,StartDate,StartTime,EndDate,EndTime,ArcimId,Note,Qty,UomId,Concentration,OriginalOrderId,InstrId,RecordCatId,Flag,DrugMode,Speed,UpdateDate,UpdateTime,Reason,EditFlag,EditedIcuoId,RecvLoc,DocUserId,Volume,SpeedUnitId,Source,Type,icucriDesc,ArcimDesc,PrepareIntake,AttachOeoriId,Report,ArrangeId,MainOeoreId,SubOrderId,Priority,Instruction,Frequency,OeoriNote,Abbreviate,OrderItemNote,MainIcuoId,Remarks,ParaItemId)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindIcuOrderByDischargeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindIcuOrderByDischargeExecute ]
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

ClassMethod FindIcuOrderByDischargeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindIcuOrderByDischargeExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 获取病人打印信息
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintOrdersNew","374","2021-09-10","07:00","2021-09-11","06:59","YINLIUYANSEXZ","GDSZICU")
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintOrdersNew","2","2021-07-30","07:00","2021-07-31","06:59","JiChuHuLi","GDSZICU1")
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintOrdersNew","2","2021-07-30","07:00","2021-07-31","06:59","LengReLiao","GDSZICU1")
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintOrdersNew","4","2021-04-25","07:00","2021-04-26","23:59","JiLiLA")
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintOrdersNew","4","2021-04-25","07:00","2021-04-26","23:59","YaoDaChiYLG")
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintOrdersNew","4","2021-04-25","07:00","2021-04-26","23:59","ExecTime^Temper^HR^Resp^NBP^ABP^SPO2^consciousnessICU^Pupil;Size^Pupil;LightReflecting^Pupil^OrderText^Administration^PQty^InfactQty^HisSpeed^UrineVolume^Proportion^Stool^OtherIOName^OtherIOQty^NursingRecord.PressureSoreICU.DVTScore.PipeScoreICU.FallScore.TTPF.RASS.CPOT.ZWScore.Glasgow.Overturn.SpongeBathInBed.AerosolInhalation.Sputum.AirwayCare.Oralcare.PerinealCare.DroppingTheTrachea.HLBCG.HLZDPT.QYZL.AVCare.CVP.BSICU.JCPGY.ICP.VentilatorMode.PEEP.FiO2.Ppeak.Pmean.VT.RAW.CR.ETCO2.OtherIn^NursingRecord^PressureSoreICU^DVTScore^PipeScoreICU^FallScore^TTPF^RASS^CPOT^ZWScore^Glasgow^Overturn^SpongeBathInBed^AerosolInhalation^Sputum^AirwayCare^Oralcare^PerinealCare^DroppingTheTrachea^HLBCG^HLZDPT^AVCare^Oralcare^CVP^BSICU^JCPGY^ICP^VentilatorMode^PEEP^FiO2^Ppeak^Pmean^VT^RAW^CR^ETCO2^OtherIn^OperationUser")
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintOrdersNew","129","2021-08-20","05:00","2021-08-20","05:00","ExecTime^Temper^HR^Resp^NBP^ABP^SPO2^consciousnessICU^Pupil;Size^Pupil;LightReflecting^Pupil^OrderText^Administration^PQty^InfactQty^HisSpeed^UrineVolume^Proportion^Stool^OtherIOName^OtherIOQty^NursingRecord.PressureSoreICU.DVTScore.PipeScoreICU.FallScore.TTPF.RASS.CPOT.ZWScore.Glasgow.Overturn.SpongeBathInBed.AerosolInhalation.Sputum.AirwayCare.Oralcare.PerinealCare.DroppingTheTrachea.HLBCG.HLZDPT.QYZL.AVCare.CVP.BSICU.JCPGY.ICP.VentilatorMode.PEEP.FiO2.Ppeak.Pmean.VT.RAW.CR.ETCO2.OtherIn^NursingRecord^PressureSoreICU^DVTScore^PipeScoreICU^FallScore^TTPF^RASS^CPOT^ZWScore^Glasgow^Overturn^SpongeBathInBed^AerosolInhalation^Sputum^AirwayCare^Oralcare^PerinealCare^DroppingTheTrachea^HLBCG^HLZDPT^AVCare^Oralcare^CVP^BSICU^JCPGY^ICP^VentilatorMode^PEEP^FiO2^Ppeak^Pmean^VT^RAW^CR^ETCO2^OtherIn^OperationUser")
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintOrdersNew","218","2021-09-05","07:00","2021-09-06","06:59","YINLIUYANSEXZ","GDSZICU")
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintOrdersNew","129","2021-08-19","08:00","2021-08-20","07:59","NursingRecord^OperationUser")
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintOrdersNew","47","2021-09-07","07:00","2021-09-08","06:59","TiWeiPICU","GDSZPICU")
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintOrdersNew","701","2021-10-23","08:00","2021-10-24","07:59","TiWeiPICU","GDSZPICU")
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintOrdersNew","855","2021-10-27","07:00","2021-10-28","06:59","XueTangICU","GDSZICU")
Query GetPrintOrdersNew(icuaId, stdate, sttime, enddate, endtime, ItemCodeStr, PrintTemplateCode As %String = "", ctlocRowId As %String = "") As %Query(ROWSPEC = "PrintDT,Orders,User,DocUser,userId") [ SqlProc ]
{
}

ClassMethod GetPrintOrdersNewExecute(ByRef qHandle As %Binary, icuaId, stdate, sttime, enddate, endtime, ItemCodeStr, PrintTemplateCode As %String = "", ctlocRowId As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^TMPDHCICU("GetPrintOrdersNew")
	k ^TMPDHCICU("GetPrintOrdersNewOut")
	s stdate=##class(web.DHCClinicCom).ConvertToDateH(stdate)
	s sttime=##class(web.DHCClinicCom).ConvertToTimeH(sttime)
	s enddate=##class(web.DHCClinicCom).ConvertToDateH(enddate)
	s endtime=##class(web.DHCClinicCom).ConvertToTimeH(endtime)
	
	if (PrintTemplateCode="GDSZPICU") s ctlocRowId=558
	
	s kFlag="N"
	f curDate=stdate:1:enddate d
	.s icuoSttTime=""
	.;s kFlag="N"
	.;///NICU管道护理
	.;s PipeLineCount=0,PipeLineId1="",PipeLineId2="",PipeLineId3="",PipeLineId4=""
	.;///ICU引流管颜色性状
	.;s YINLIUYANSECount=0,YINLIUYANSEXZId1="",YINLIUYANSEXZId2="",YINLIUYANSEXZId3="",YINLIUYANSEXZId4="",YINLIUYANSEXZId5="",YINLIUYANSEXZId6=""
	.;///ICU基础护理
	.;s JiChuHuLiCount=0,JiChuHuLiId1="",JiChuHuLiId2="",JiChuHuLiId3=""
	.;///ICU冷热疗
	.;s LengReLiaoCount=0,LengReLiaoId1="",LengReLiaoId2=""
	.;///ICU换药
	.;s HuanYaoCount=0,HuanYaoId1="",HuanYaoId2="",HuanYaoId3="",HuanYaoId4=""
	.
	.f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
	..q:(curDate=stdate)&&(icuoSttTime<sttime)    //早于开始时间
	..q:(curDate=enddate)&&(icuoSttTime>endtime)    //晚于结束时间
	..b ;0
	..;i ((icuoSttTime>=sttime)&(kFlag="N")) d
	..i ((((curDate=stdate)&(icuoSttTime>=sttime))||((curDate=enddate)&&(icuoSttTime<=endtime)))&(kFlag="N"))  d
	...b //1
	...///NICU管道护理
	...s PipeLineCount=0,PipeLineId1="",PipeLineId2="",PipeLineId3="",PipeLineId4=""
	...///ICU引流管颜色性状
	...s YINLIUYANSECount=0,YINLIUYANSEXZId1="",YINLIUYANSEXZId2="",YINLIUYANSEXZId3="",YINLIUYANSEXZId4="",YINLIUYANSEXZId5="",YINLIUYANSEXZId6=""
	...///ICU基础护理
	...s JiChuHuLiCount=0,JiChuHuLiId1="",JiChuHuLiId2="",JiChuHuLiId3=""
	...///ICU冷热疗
	...s LengReLiaoCount=0,LengReLiaoId1="",LengReLiaoId2=""
	...///ICU换药
	...s HuanYaoCount=0,HuanYaoId1="",HuanYaoId2="",HuanYaoId3="",HuanYaoId4=""
	...s kFlag="Y"
 	..s ^TMPDHCICU("GetPrintOrders",icuaId,curDate,icuoSttTime)=$zd(curDate,3)_" "_$zt(icuoSttTime,2)
	..s orderStr="",UserStr="",OtherUserStr="",UserFlag="N",otherUserFlag="N",DocUserFlag="N",DocUserStr=""
	..s inoutId="",inoutStr=""
	..s icuoDocUserDrStr=""	//冠签 20210808
	..f  s inoutId=$o(^DHCICUOrder("ICUInOut",icuaId,curDate,icuoSttTime,inoutId)) q:inoutId=""  d
	...s inoutValue=$p($g(^DHCICUOrder("ICUInOut",icuaId,curDate,icuoSttTime,inoutId)),"^",1)
	...s inoutCode=$p($g(^DHCICUC("RecordItem",inoutId)),"^",1)
	...s inout=inoutCode_"#"_inoutId_"#"_inoutValue
	...i inoutStr="" s inoutStr=inout
	...e  s inoutStr=inoutStr_";"_inout
	..s icuoId="",oriDateTime=100000000,oriUserId="",oriUserDesc=""
	..f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
	...q:$d(^DHCICUOrder(icuoId))<1
	...s icuoUserStr="",icuoOrderStr="",icuoValue="",icucriCode="",icuoComOrdDr="",icuoDocUserStr=""
	...s orderEditFlag=$p($g(^DHCICUOrder(icuoId)),"^",25)
	...q:orderEditFlag="C"
	...s icuoComOrdDr=$p($g(^DHCICUOrder(icuoId)),"^",2)
    ...q:icuoComOrdDr=""
	...s icucriCode=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",1)
	...;q:(ItemCodeStr'="")&&(ItemCodeStr'[icucriCode)
	...s codeFlag=..CheckItemCode(icucriCode,ItemCodeStr)
	...s ICUOViewCat=$p($g(^DHCICUOrder(icuoId)),"^",16)
	...;q:(codeFlag="N")&&(ICUOViewCat'="331")&&(ICUOViewCat'="378")&&(ICUOViewCat'="338")&&(ICUOViewCat'="340")
	...;q:(codeFlag="N")&&(ICUOViewCat'="331")&&(ICUOViewCat'="378")
	...;q:(codeFlag="N")&&(ICUOViewCat'="331")
	...q:((codeFlag="N")&&((ICUOViewCat'="331")||(PrintTemplateCode'="GDSZNICU")))&&((codeFlag="N")&&((ICUOViewCat'="378")||(PrintTemplateCode'="GDSZICU")))&&((codeFlag="N")&&((ICUOViewCat'="338")||(PrintTemplateCode'="GDSZICU1")))&&((codeFlag="N")&&((ICUOViewCat'="340")||(PrintTemplateCode'="GDSZICU1")))&&((codeFlag="N")&&((ICUOViewCat'="343")||(PrintTemplateCode'="GDSZICU1")))
	...;q:((codeFlag="N")&&((ICUOViewCat'="378")||(PrintTemplateCode'="GDSZICU")))
	...s icuoUserDr=$p($g(^DHCICUOrder(icuoId)),"^",4)
	...s curOrderDate=$p($g(^DHCICUOrder(icuoId)),"^",21)
	...s curOrderTime=$p($g(^DHCICUOrder(icuoId)),"^",22)
	...;s oriUserId=icuoUserDr
	...
	...s curOrderDT=curOrderDate+(curOrderTime/100000)
	...i (curOrderDT<oriDateTime) d
	....s oriDateTime=curOrderDT
	....s oriUserId=icuoUserDr
	...s originalIcuoId=$p($g(^DHCICUOrder(icuoId)),"^",14)	///取数据原始用户信息，不取修改后的用户信息
	...
	...s originalIcuoUserDr="",originalIcuoUserDesc=""
	...i originalIcuoId'=""  d
	....s originalIcuoUserDr=$p($g(^DHCICUOrder(originalIcuoId)),"^",4)
	....i originalIcuoUserDr="" s oriUserId=icuoUserDr
	....s curOriDate=$p($g(^DHCICUOrder(originalIcuoId)),"^",21)
	....s curOriTime=$p($g(^DHCICUOrder(originalIcuoId)),"^",22)
	....s curOriDT=curOriDate+(curOriTime/100000)
	....i (curOriDT<oriDateTime) d
	.....s oriDateTime=curOriDT
	.....i originalIcuoUserDr'="" s oriUserId=originalIcuoUserDr
	...;i originalIcuoUserDr="" s oriUserId=icuoUserDr
	...i oriUserId'="" s oriUserDesc=$p($g(^SSU("SSUSR",oriUserId)),"^",2)
	...s icuoUserDesc=""
	...i icuoUserDr'="" s icuoUserDesc=$p($g(^SSU("SSUSR",icuoUserDr)),"^",2)
	...
	...s icuoDocUserDesc=""
	...s icuoDocUserDr=$p($g(^DHCICUOrder(icuoId)),"^",27)									///双签用户
	...i icuoDocUserDr'=""  d
	....s icuoDocUserDesc=$p($g(^SSU("SSUSR",icuoDocUserDr)),"^",2)
	....s icuoDocUserDrStr=icuoDocUserDr
	...
	...s OtherDesc=$p($g(^DHCICUOrder(icuoId,"OtherUser")),"^",2)
    ...s icuoNote=$p($g(^DHCICUOrder(icuoId)),"^",10)
    ...s icuoQty=+$p($g(^DHCICUOrder(icuoId)),"^",11)
    ...s ICUOICUPIDr=$p($g(^DHCICUOrder(icuoId)),"^",38)
    ...q:ICUOICUPIDr=""
    ...q:(ICUOICUPIDr'="")&&($p(ICUOICUPIDr,"||",1)'="")&&($p(ICUOICUPIDr,"||",2)'="")&&($p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",20)="N") //已删除医嘱不加载
	...s icuoDataType=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",24)
	...;w !,icuoComOrdDr_"^"_icuoDataType_"^"_icucriCode_"^"_icuoQty_"^"_icuoNote
	...i "Qty,Volume"[icuoDataType s icuoValue=icuoQty
	...i icuoDataType="Note" s icuoValue=icuoNote
	...;i icuoValue=0 s icuoValue=""
	...i (+icuoValue>0)&(+icuoValue<1) s icuoValue=$fn(icuoValue,"",$l($p(icuoValue,".",2)))
	...q:($p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",19)'="")&&(ICUOViewCat="331")  //管道不取子项
	...i (ICUOViewCat="331")&&("GuanDaoHuLi03,UACHuLi,AlineHuLi,UVCHuLi,PICCHuLi,WeiGuanKeDu,WeiYeiColor,WeiCYL,NiaoYeColor,NiaoYeCharacter,NiaoGuanFix,NiaoGuanUnobstr,WeiYePHPh"'[icucriCode) d //管道
	....i (ICUOICUPIDr'=PipeLineId1)&&(ICUOICUPIDr'=PipeLineId2)&&(ICUOICUPIDr'=PipeLineId3)&&(ICUOICUPIDr'=PipeLineId4) d
	.....s PipeLineCount=PipeLineCount+1
	.....i PipeLineCount=1 s PipeLineId1=ICUOICUPIDr
	.....i PipeLineCount=2 s PipeLineId2=ICUOICUPIDr
	.....i PipeLineCount=3 s PipeLineId3=ICUOICUPIDr
	.....i PipeLineCount=4 s PipeLineId4=ICUOICUPIDr
	.....s icucriCode="PipeLine"_PipeLineCount
	....e  i ICUOICUPIDr=PipeLineId1 d
	.....s icucriCode="PipeLine"_1
	.....s PipeLineId1=ICUOICUPIDr
	....e  i ICUOICUPIDr=PipeLineId2 d
	.....s icucriCode="PipeLine"_2
	.....s PipeLineId2=ICUOICUPIDr
	....e  i ICUOICUPIDr=PipeLineId3 d
	.....s icucriCode="PipeLine"_3
	.....s PipeLineId3=ICUOICUPIDr
	....e  i ICUOICUPIDr=PipeLineId4 d
	.....s icucriCode="PipeLine"_4
	.....s PipeLineId4=ICUOICUPIDr
	...
	...i (ICUOViewCat="378")  d //ICU引流颜色性状
	....i (ICUOICUPIDr'=YINLIUYANSEXZId1)&&(ICUOICUPIDr'=YINLIUYANSEXZId2)&&(ICUOICUPIDr'=YINLIUYANSEXZId3)&&(ICUOICUPIDr'=YINLIUYANSEXZId4)&&(ICUOICUPIDr'=YINLIUYANSEXZId5)&&(ICUOICUPIDr'=YINLIUYANSEXZId6) d
	.....s YINLIUYANSECount=YINLIUYANSECount+1
	.....i YINLIUYANSECount=1 s YINLIUYANSEXZId1=ICUOICUPIDr
	.....i YINLIUYANSECount=2 s YINLIUYANSEXZId2=ICUOICUPIDr
	.....i YINLIUYANSECount=3 s YINLIUYANSEXZId3=ICUOICUPIDr
	.....i YINLIUYANSECount=4 s YINLIUYANSEXZId4=ICUOICUPIDr
	.....i YINLIUYANSECount=5 s YINLIUYANSEXZId5=ICUOICUPIDr
	.....i YINLIUYANSECount=6 s YINLIUYANSEXZId6=ICUOICUPIDr
	.....s icucriCode="YINLIUYANSEXZ"_YINLIUYANSECount
	....e  i ICUOICUPIDr=YINLIUYANSEXZId1 d
	.....s icucriCode="YINLIUYANSEXZ"_1
	.....s YINLIUYANSEXZId1=ICUOICUPIDr
	....e  i ICUOICUPIDr=YINLIUYANSEXZId2 d
	.....s icucriCode="YINLIUYANSEXZ"_2
	.....s YINLIUYANSEXZId2=ICUOICUPIDr
	....e  i ICUOICUPIDr=YINLIUYANSEXZId3 d
	.....s icucriCode="YINLIUYANSEXZ"_3
	.....s YINLIUYANSEXZId3=ICUOICUPIDr
	....e  i ICUOICUPIDr=YINLIUYANSEXZId4 d
	.....s icucriCode="YINLIUYANSEXZ"_4
	.....s YINLIUYANSEXZId4=ICUOICUPIDr
	....e  i ICUOICUPIDr=YINLIUYANSEXZId5 d
	.....s icucriCode="YINLIUYANSEXZ"_5
	.....s YINLIUYANSEXZId5=ICUOICUPIDr
	....e  i ICUOICUPIDr=YINLIUYANSEXZId6 d
	.....s icucriCode="YINLIUYANSEXZ"_6
	.....s YINLIUYANSEXZId6=ICUOICUPIDr
	...
	...i ((ICUOViewCat="338")&&("TiWei,Oralcare,Sputum,PerinealCare"'[icucriCode)&&(ctlocRowId'=558))  d //ICU基础护理
	....;w "icucriCode:"_icucriCode,!
	....i (ICUOICUPIDr'=JiChuHuLiId1)&&(ICUOICUPIDr'=JiChuHuLiId2)&&(ICUOICUPIDr'=JiChuHuLiId3) d
	.....s JiChuHuLiCount=JiChuHuLiCount+1
	.....i JiChuHuLiCount=1 s JiChuHuLiId1=ICUOICUPIDr
	.....i JiChuHuLiCount=2 s JiChuHuLiId2=ICUOICUPIDr
	.....i JiChuHuLiCount=3 s JiChuHuLiId3=ICUOICUPIDr
	.....s icucriCode="JiChuHuLi"_JiChuHuLiCount
	....e  i ICUOICUPIDr=JiChuHuLiId1 d
	.....s icucriCode="JiChuHuLi"_1
	.....s JiChuHuLiId1=ICUOICUPIDr
	....e  i ICUOICUPIDr=JiChuHuLiId2 d
	.....s icucriCode="JiChuHuLi"_2
	.....s JiChuHuLiId2=ICUOICUPIDr
	....e  i ICUOICUPIDr=JiChuHuLiId3 d
	.....s icucriCode="JiChuHuLi"_3
	.....s JiChuHuLiId3=ICUOICUPIDr
	...
	...i (ICUOViewCat="340")  d //ICU冷热疗
	....i (ICUOICUPIDr'=LengReLiaoId1)&&(ICUOICUPIDr'=LengReLiaoId2) d
	.....s LengReLiaoCount=LengReLiaoCount+1
	.....i LengReLiaoCount=1 s LengReLiaoId1=ICUOICUPIDr
	.....i LengReLiaoCount=2 s LengReLiaoId2=ICUOICUPIDr
	.....s icucriCode="LengReLiao"_LengReLiaoCount
	....e  i ICUOICUPIDr=LengReLiaoId1 d
	.....s icucriCode="LengReLiao"_1
	.....s LengReLiaoId1=ICUOICUPIDr
	....e  i ICUOICUPIDr=LengReLiaoId2 d
	.....s icucriCode="LengReLiao"_2
	.....s LengReLiaoId2=ICUOICUPIDr
	...
	...i (ICUOViewCat="343")  d //ICU换药
	....i ((ICUOICUPIDr'=HuanYaoId1)&&(ICUOICUPIDr'=HuanYaoId2)&&(ICUOICUPIDr'=HuanYaoId3)&&(ICUOICUPIDr'=HuanYaoId4)) d
	.....s HuanYaoCount=HuanYaoCount+1
	.....i HuanYaoCount=1 s HuanYaoId1=ICUOICUPIDr
	.....i HuanYaoCount=2 s HuanYaoId2=ICUOICUPIDr
	.....i HuanYaoCount=3 s HuanYaoId3=ICUOICUPIDr
	.....i HuanYaoCount=4 s HuanYaoId4=ICUOICUPIDr
	.....s icucriCode="HuanYao"_HuanYaoCount
	....e  i ICUOICUPIDr=HuanYaoId1 d
	.....s icucriCode="HuanYao"_1
	.....s HuanYaoId1=ICUOICUPIDr
	....e  i ICUOICUPIDr=HuanYaoId2 d
	.....s icucriCode="HuanYao"_2
	.....s HuanYaoId2=ICUOICUPIDr
	....e  i ICUOICUPIDr=HuanYaoId3 d
	.....s icucriCode="HuanYao"_3
	.....s HuanYaoId3=ICUOICUPIDr
	....e  i ICUOICUPIDr=HuanYaoId4 d
	.....s icucriCode="HuanYao"_4
	.....s HuanYaoId4=ICUOICUPIDr
	...
	...
	...;特殊字符处理
	...i ICUOViewCat="191"  d //护理记录 
	....s icuoValue=$replace(icuoValue,";",",")
	....s icuoValue=$replace(icuoValue,"/",",")
	....s icuoValue=$replace(icuoValue,"^",",")
	....s icuoValue=$replace(icuoValue,"#",",")
	....s icuoValue=$replace(icuoValue,"；",",")
	...i ((icuoComOrdDr'=5039)&&(icuoComOrdDr'=7537))  d
	....if ((icuoComOrdDr=7349)||(icuoComOrdDr=7361))  d
	.....i (icuoComOrdDr=7349) s icuoValue=##class(web.DHCICUTest2).GetTanYeKB(icuaId,curDate,icuoSttTime)	///20211101 ly add
	.....i (icuoComOrdDr=7361) s icuoValue=##class(web.DHCICUTest2).GetTanYeQD(icuaId,curDate,icuoSttTime)	///20211101 ly add
	....else  d
	.....if $l(icuoValue,"*")>1 s icuoValue=$p(icuoValue,"*",1)	///20210808 ly add
	....;curDate,icuaId,icuoSttTime
	...
	...;i ((icuoValue=0)&&(ICUOViewCat'="310")&&(ICUOViewCat'="331")&&(ICUOViewCat'="215")&&(ICUOViewCat'="222")&&(ICUOViewCat'=330)&&(ICUOViewCat'="249")) s icuoValue=""    //评分,生命体征,出入量,CRRT
	...s icuoOrderStr=icucriCode_$c(3)_icuoComOrdDr_$c(3)_icuoValue_$c(3)_ICUOViewCat_$c(3)_icuoId
	...i orderStr="" s orderStr=$tr(icuoOrderStr,";","；")	///20210426 ly
	...e  s orderStr=orderStr_";"_$tr(icuoOrderStr,";","；")	///20210426 ly
	...i icuoUserDesc'="" d
	....q:UserFlag="Y"
	....i UserStr="" s UserStr=icuoUserDesc
	....e  i UserStr'[icuoUserDesc s UserStr=UserStr_"/"_icuoUserDesc
	....s UserFlag="Y"
	...i OtherDesc'="" d
	....q:otherUserFlag="Y"
	....i UserStr="" s UserStr=OtherDesc
	....e  i UserStr'[OtherDesc s UserStr=UserStr_"/"_OtherDesc
	....s otherUserFlag="Y"
	...
	...i icuoDocUserDesc'="" d		///双签20210501 ly
	....i DocUserStr="" s DocUserStr=icuoDocUserDesc
	....e  i DocUserStr'[icuoDocUserDesc s DocUserStr=DocUserStr_","_icuoDocUserDesc
	...
	..i orderStr="" k ^TMPDHCICU("GetPrintOrdersNew",icuaId,curDate,icuoSttTime) q
	..;s UserStr=$p(UserStr,"/",1)
	..i inoutStr'="" s orderStr=orderStr_";"_$tr(inoutStr,";","；")	///20210426 ly
	..i (icuoDocUserDrStr="")&&(PrintTemplateCode="GDSZNICU") s icuoDocUserDrStr=..GetGQUserId(icuaId,curDate,icuoSttTime)  //NICU获取冠签
	..s ^TMPDHCICU("GetPrintOrdersNew",icuaId,curDate,icuoSttTime)=^TMPDHCICU("GetPrintOrders",icuaId,curDate,icuoSttTime)_"^"_orderStr_"^"_UserStr_"^"_DocUserStr_"^"_oriUserId_","_icuoDocUserDrStr

    s Date="" f  s Date=$o(^TMPDHCICU("GetPrintOrdersNew",icuaId,Date)) q:Date=""  d
	.s Time="" f  s Time=$o(^TMPDHCICU("GetPrintOrdersNew",icuaId,Date,Time)) q:Time=""  d
	..s DT=$p($g(^TMPDHCICU("GetPrintOrdersNew",icuaId,Date,Time)),"^",1)
	..s Orders=$p($g(^TMPDHCICU("GetPrintOrdersNew",icuaId,Date,Time)),"^",2)
	..;s Orders=$tr(Orders,";","；")
	..s User=$p($g(^TMPDHCICU("GetPrintOrdersNew",icuaId,Date,Time)),"^",3)
	..s DocUser=$p($g(^TMPDHCICU("GetPrintOrdersNew",icuaId,Date,Time)),"^",4)
	..s userId=$p($g(^TMPDHCICU("GetPrintOrdersNew",icuaId,Date,Time)),"^",5)
	..s ^TMPDHCICU("GetPrintOrdersNewOut",icuaId,Date,Time)=$lb(DT,Orders,User,DocUser,userId)
    ..Do PrintOrdersNew

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK


PrintOrdersNew
 Set ^CacheTemp(repid,ind)=^TMPDHCICU("GetPrintOrdersNewOut",icuaId,Date,Time)
 Set ind=ind+1
 quit
}

ClassMethod GetPrintOrdersNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintOrdersNewExecute ]
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

ClassMethod GetPrintOrdersNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintOrdersNewExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 获取冠签用户
ClassMethod GetGQUserId(icuaId, date, time) As %String
{
	s icuoDocUserDrStr=""
	s icuoId=""
	f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId,time,icuoId)) q:icuoId=""  d
	.s orderEditFlag=$p($g(^DHCICUOrder(icuoId)),"^",25)
	.q:orderEditFlag="C"
	.s icuoDocUserDr=$p($g(^DHCICUOrder(icuoId)),"^",27)									///双签用户
	.q:icuoDocUserDr=""
	.s icuoDocUserDrStr=icuoDocUserDr
	
	q icuoDocUserDrStr
}

/// 获取病人打印信息
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintOrdersNew","374","2021-09-10","07:00","2021-09-11","06:59","YINLIUYANSEXZ","GDSZICU")
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintOrdersNew","2","2021-07-30","07:00","2021-07-31","06:59","JiChuHuLi","GDSZICU1")
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintOrdersNew","2","2021-07-30","07:00","2021-07-31","06:59","LengReLiao","GDSZICU1")
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintOrdersNew","4","2021-04-25","07:00","2021-04-26","23:59","JiLiLA")
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintOrdersNew","4","2021-04-25","07:00","2021-04-26","23:59","YaoDaChiYLG")
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintOrdersNew","4","2021-04-25","07:00","2021-04-26","23:59","ExecTime^Temper^HR^Resp^NBP^ABP^SPO2^consciousnessICU^Pupil;Size^Pupil;LightReflecting^Pupil^OrderText^Administration^PQty^InfactQty^HisSpeed^UrineVolume^Proportion^Stool^OtherIOName^OtherIOQty^NursingRecord.PressureSoreICU.DVTScore.PipeScoreICU.FallScore.TTPF.RASS.CPOT.ZWScore.Glasgow.Overturn.SpongeBathInBed.AerosolInhalation.Sputum.AirwayCare.Oralcare.PerinealCare.DroppingTheTrachea.HLBCG.HLZDPT.QYZL.AVCare.CVP.BSICU.JCPGY.ICP.VentilatorMode.PEEP.FiO2.Ppeak.Pmean.VT.RAW.CR.ETCO2.OtherIn^NursingRecord^PressureSoreICU^DVTScore^PipeScoreICU^FallScore^TTPF^RASS^CPOT^ZWScore^Glasgow^Overturn^SpongeBathInBed^AerosolInhalation^Sputum^AirwayCare^Oralcare^PerinealCare^DroppingTheTrachea^HLBCG^HLZDPT^AVCare^Oralcare^CVP^BSICU^JCPGY^ICP^VentilatorMode^PEEP^FiO2^Ppeak^Pmean^VT^RAW^CR^ETCO2^OtherIn^OperationUser")
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintOrdersNew","129","2021-08-20","05:00","2021-08-20","05:00","ExecTime^Temper^HR^Resp^NBP^ABP^SPO2^consciousnessICU^Pupil;Size^Pupil;LightReflecting^Pupil^OrderText^Administration^PQty^InfactQty^HisSpeed^UrineVolume^Proportion^Stool^OtherIOName^OtherIOQty^NursingRecord.PressureSoreICU.DVTScore.PipeScoreICU.FallScore.TTPF.RASS.CPOT.ZWScore.Glasgow.Overturn.SpongeBathInBed.AerosolInhalation.Sputum.AirwayCare.Oralcare.PerinealCare.DroppingTheTrachea.HLBCG.HLZDPT.QYZL.AVCare.CVP.BSICU.JCPGY.ICP.VentilatorMode.PEEP.FiO2.Ppeak.Pmean.VT.RAW.CR.ETCO2.OtherIn^NursingRecord^PressureSoreICU^DVTScore^PipeScoreICU^FallScore^TTPF^RASS^CPOT^ZWScore^Glasgow^Overturn^SpongeBathInBed^AerosolInhalation^Sputum^AirwayCare^Oralcare^PerinealCare^DroppingTheTrachea^HLBCG^HLZDPT^AVCare^Oralcare^CVP^BSICU^JCPGY^ICP^VentilatorMode^PEEP^FiO2^Ppeak^Pmean^VT^RAW^CR^ETCO2^OtherIn^OperationUser")
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintOrdersNew","218","2021-09-05","07:00","2021-09-06","06:59","YINLIUYANSEXZ","GDSZICU")
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintOrdersNew","129","2021-08-19","08:00","2021-08-20","07:59","NursingRecord^OperationUser")
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintOrdersNew","47","2021-09-07","07:00","2021-09-08","06:59","HuanYao","GDSZICU1")
Query GetPrintOrdersNewICU(icuaId, stdate, sttime, enddate, endtime, ItemCodeStr, PrintTemplateCode As %String = "") As %Query(ROWSPEC = "PrintDT,Orders,User,DocUser,userId") [ SqlProc ]
{
}

ClassMethod GetPrintOrdersNewICUExecute(ByRef qHandle As %Binary, icuaId, stdate, sttime, enddate, endtime, ItemCodeStr, PrintTemplateCode As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^TMPDHCICU("GetPrintOrdersNewICU")
	k ^TMPDHCICU("GetPrintOrdersNewICUOut")
	s stdate=##class(web.DHCClinicCom).ConvertToDateH(stdate)
	s sttime=##class(web.DHCClinicCom).ConvertToTimeH(sttime)
	s enddate=##class(web.DHCClinicCom).ConvertToDateH(enddate)
	s endtime=##class(web.DHCClinicCom).ConvertToTimeH(endtime)
	s kFlag="N"
	
	f curDate=stdate:1:enddate d
	.s icuoSttTime=""
	.
	.f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
	..q:(curDate=stdate)&&(icuoSttTime<sttime)    //早于开始时间
	..q:(curDate=enddate)&&(icuoSttTime>endtime)    //晚于结束时间
	..;i ((icuoSttTime>=sttime)&(kFlag="N")) d
	..i ((((curDate=stdate)&(icuoSttTime>=sttime))||((curDate=enddate)&&(icuoSttTime<=endtime)))&(kFlag="N"))  d
	...///NICU管道护理
	...s PipeLineCount=0,PipeLineId1="",PipeLineId2="",PipeLineId3="",PipeLineId4=""
	...///ICU引流管颜色性状
	...s YINLIUYANSECount=0,YINLIUYANSEXZId1="",YINLIUYANSEXZId2="",YINLIUYANSEXZId3="",YINLIUYANSEXZId4="",YINLIUYANSEXZId5="",YINLIUYANSEXZId6=""
	...///ICU基础护理
	...;s JiChuHuLiCount=0,JiChuHuLiId1="",JiChuHuLiId2="",JiChuHuLiId3=""
	...///ICU冷热疗
	...s LengReLiaoCount=0,LengReLiaoId1="",LengReLiaoId2=""
	...///ICU换药
	...s HuanYaoCount=0,HuanYaoId1="",HuanYaoId2="",HuanYaoId3="",HuanYaoId4=""
	...;ICU护理操作单
	...;生活护理
	...s SHHLCount=0
	...s (SHHL1,SHHL2,SHHL3,SHHL4,SHHL5,SHHL6)=""
	...;基础护理
	...s JCHLCount=0
	...s (JCHL1,JCHL2,JCHL3,JCHL4,JCHL5,JCHL6,JCHL7)=""
	...;专科护理
	...s ZKHLCount=0
	...s (ZKHL1,ZKHL2,ZKHL3,ZKHL4)=""
	...;功能锻炼
	...s GNDLCount=0
	...s (GNDL1,GNDL2,GNDL3)=""
	...;约束
	...s YSCount=0
	...s (YS1,YS2,YS3,YS4,YS5)=""
	...s kFlag="Y"
 	..s ^TMPDHCICU("GetPrintOrdersICU",icuaId,curDate,icuoSttTime)=$zd(curDate,3)_" "_$zt(icuoSttTime,2)
	..s orderStr="",UserStr="",OtherUserStr="",UserFlag="N",otherUserFlag="N",DocUserFlag="N",DocUserStr=""
	..s inoutId="",inoutStr=""
	..s icuoDocUserDrStr=""	//冠签 20210808
	..f  s inoutId=$o(^DHCICUOrder("ICUInOut",icuaId,curDate,icuoSttTime,inoutId)) q:inoutId=""  d
	...s inoutValue=$p($g(^DHCICUOrder("ICUInOut",icuaId,curDate,icuoSttTime,inoutId)),"^",1)
	...s inoutCode=$p($g(^DHCICUC("RecordItem",inoutId)),"^",1)
	...s inout=inoutCode_"#"_inoutId_"#"_inoutValue
	...i inoutStr="" s inoutStr=inout
	...e  s inoutStr=inoutStr_";"_inout
	..s icuoId="",oriDateTime=100000000,oriUserId="",oriUserDesc=""
	..f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
	...q:$d(^DHCICUOrder(icuoId))<1
	...s icuoUserStr="",icuoOrderStr="",icuoValue="",icucriCode="",icuoComOrdDr="",icuoDocUserStr=""
	...s orderEditFlag=$p($g(^DHCICUOrder(icuoId)),"^",25)
	...q:orderEditFlag="C"
	...s icuoComOrdDr=$p($g(^DHCICUOrder(icuoId)),"^",2)
    ...q:icuoComOrdDr=""
	...s icucriCode=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",1)
	...s ICUOICUPIDr=$p($g(^DHCICUOrder(icuoId)),"^",38)
    ...q:ICUOICUPIDr=""
    ...s paraViewCat=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",11)    //模板所属分类
	...;q:(ItemCodeStr'="")&&(ItemCodeStr'[icucriCode)
	...s codeFlag=..CheckItemCode(icucriCode,ItemCodeStr)
	...s ICUOViewCat=$p($g(^DHCICUOrder(icuoId)),"^",16)
	...
	...q:((codeFlag="N")&&((ICUOViewCat'="331")||(PrintTemplateCode'="GDSZNICU")))&&((codeFlag="N")&&((ICUOViewCat'="378")||(PrintTemplateCode'="GDSZICU")))&&((codeFlag="N")&&((ICUOViewCat'="338")||(PrintTemplateCode'="GDSZICU1")))&&((codeFlag="N")&&((ICUOViewCat'="340")||(PrintTemplateCode'="GDSZICU1")))&&((codeFlag="N")&&((ICUOViewCat'="343")||(PrintTemplateCode'="GDSZICU1"))&&((paraViewCat'="337")||(PrintTemplateCode'="GDSZICU1"))&&((paraViewCat'="338")||(PrintTemplateCode'="GDSZICU1"))&&((paraViewCat'="339")||(PrintTemplateCode'="GDSZICU1"))&&((paraViewCat'="341")||(PrintTemplateCode'="GDSZICU1"))&&((paraViewCat'="342")||(PrintTemplateCode'="GDSZICU1")))
	...;q:((codeFlag="N")&&((ICUOViewCat'="378")||(PrintTemplateCode'="GDSZICU")))
	...s icuoUserDr=$p($g(^DHCICUOrder(icuoId)),"^",4)
	...s curOrderDate=$p($g(^DHCICUOrder(icuoId)),"^",21)
	...s curOrderTime=$p($g(^DHCICUOrder(icuoId)),"^",22)
	...;s oriUserId=icuoUserDr
	...
	...s curOrderDT=curOrderDate+(curOrderTime/100000)
	...i (curOrderDT<oriDateTime) d
	....s oriDateTime=curOrderDT
	....s oriUserId=icuoUserDr
	...s originalIcuoId=$p($g(^DHCICUOrder(icuoId)),"^",14)	///取数据原始用户信息，不取修改后的用户信息
	...
	...s originalIcuoUserDr="",originalIcuoUserDesc=""
	...i originalIcuoId'=""  d
	....s originalIcuoUserDr=$p($g(^DHCICUOrder(originalIcuoId)),"^",4)
	....i originalIcuoUserDr="" s oriUserId=icuoUserDr
	....s curOriDate=$p($g(^DHCICUOrder(originalIcuoId)),"^",21)
	....s curOriTime=$p($g(^DHCICUOrder(originalIcuoId)),"^",22)
	....s curOriDT=curOriDate+(curOriTime/100000)
	....i (curOriDT<oriDateTime) d
	.....s oriDateTime=curOriDT
	.....i originalIcuoUserDr'="" s oriUserId=originalIcuoUserDr
	...;i originalIcuoUserDr="" s oriUserId=icuoUserDr
	...i oriUserId'="" s oriUserDesc=$p($g(^SSU("SSUSR",oriUserId)),"^",2)
	...s icuoUserDesc=""
	...i icuoUserDr'="" s icuoUserDesc=$p($g(^SSU("SSUSR",icuoUserDr)),"^",2)
	...
	...s icuoDocUserDesc=""
	...s icuoDocUserDr=$p($g(^DHCICUOrder(icuoId)),"^",27)									///双签用户
	...i icuoDocUserDr'=""  d
	....s icuoDocUserDesc=$p($g(^SSU("SSUSR",icuoDocUserDr)),"^",2)
	....s icuoDocUserDrStr=icuoDocUserDr
	...
	...s OtherDesc=$p($g(^DHCICUOrder(icuoId,"OtherUser")),"^",2)
    ...s icuoNote=$p($g(^DHCICUOrder(icuoId)),"^",10)
    ...s icuoQty=+$p($g(^DHCICUOrder(icuoId)),"^",11)
    ...s ICUOICUPIDr=$p($g(^DHCICUOrder(icuoId)),"^",38)
    ...q:ICUOICUPIDr=""
    ...q:(ICUOICUPIDr'="")&&($p(ICUOICUPIDr,"||",1)'="")&&($p(ICUOICUPIDr,"||",2)'="")&&($p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",20)="N") //已删除医嘱不加载
	...s icuoDataType=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",24)
	...;w !,icuoComOrdDr_"^"_icuoDataType_"^"_icucriCode_"^"_icuoQty_"^"_icuoNote
	...i "Qty,Volume"[icuoDataType s icuoValue=icuoQty
	...i icuoDataType="Note" s icuoValue=icuoNote
	...i icucriCode="HuxidaoVolume" d  //呼吸道分泌量
	....i icuoValue="少量" s icuoValue="1"
	....i icuoValue="中量" s icuoValue="2"
	....i icuoValue="大量" s icuoValue="3"
	....i icuoValue="无" s icuoValue="0"
	...;i icuoValue=0 s icuoValue=""
	
	...q:($p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",19)'="")&&(ICUOViewCat="331")  //管道不取子项
	...i (ICUOViewCat="331")&&("GuanDaoHuLi03,UACHuLi,AlineHuLi,UVCHuLi,PICCHuLi,WeiGuanKeDu,WeiYeiColor,WeiCYL,NiaoYeColor,NiaoYeCharacter,NiaoGuanFix,NiaoGuanUnobstr,WeiYePHPh"'[icucriCode) d //管道
	....i (ICUOICUPIDr'=PipeLineId1)&&(ICUOICUPIDr'=PipeLineId2)&&(ICUOICUPIDr'=PipeLineId3)&&(ICUOICUPIDr'=PipeLineId4) d
	.....s PipeLineCount=PipeLineCount+1
	.....i PipeLineCount=1 s PipeLineId1=ICUOICUPIDr
	.....i PipeLineCount=2 s PipeLineId2=ICUOICUPIDr
	.....i PipeLineCount=3 s PipeLineId3=ICUOICUPIDr
	.....i PipeLineCount=4 s PipeLineId4=ICUOICUPIDr
	.....s icucriCode="PipeLine"_PipeLineCount
	....e  i ICUOICUPIDr=PipeLineId1 d
	.....s icucriCode="PipeLine"_1
	.....s PipeLineId1=ICUOICUPIDr
	....e  i ICUOICUPIDr=PipeLineId2 d
	.....s icucriCode="PipeLine"_2
	.....s PipeLineId2=ICUOICUPIDr
	....e  i ICUOICUPIDr=PipeLineId3 d
	.....s icucriCode="PipeLine"_3
	.....s PipeLineId3=ICUOICUPIDr
	....e  i ICUOICUPIDr=PipeLineId4 d
	.....s icucriCode="PipeLine"_4
	.....s PipeLineId4=ICUOICUPIDr
	...
	...i (ICUOViewCat="378")  d //ICU引流颜色性状
	....i icuoValue="棕褐色" s icuoValue="BR"
	....i icuoValue="黄色" s icuoValue="Y"
	....i icuoValue="淡血性" s icuoValue="LB"
	....i icuoValue="鲜血性" s icuoValue="DB"
	....i icuoValue="白色" s icuoValue="W"
	....i icuoValue="绿色" s icuoValue="G"
	....i icuoValue="黄绿色" s icuoValue="YG"
	....i icuoValue="血性" s icuoValue="B"
	....i (ICUOICUPIDr'=YINLIUYANSEXZId1)&&(ICUOICUPIDr'=YINLIUYANSEXZId2)&&(ICUOICUPIDr'=YINLIUYANSEXZId3)&&(ICUOICUPIDr'=YINLIUYANSEXZId4)&&(ICUOICUPIDr'=YINLIUYANSEXZId5)&&(ICUOICUPIDr'=YINLIUYANSEXZId6) d
	.....s YINLIUYANSECount=YINLIUYANSECount+1
	.....i YINLIUYANSECount=1 s YINLIUYANSEXZId1=ICUOICUPIDr
	.....i YINLIUYANSECount=2 s YINLIUYANSEXZId2=ICUOICUPIDr
	.....i YINLIUYANSECount=3 s YINLIUYANSEXZId3=ICUOICUPIDr
	.....i YINLIUYANSECount=4 s YINLIUYANSEXZId4=ICUOICUPIDr
	.....i YINLIUYANSECount=5 s YINLIUYANSEXZId5=ICUOICUPIDr
	.....i YINLIUYANSECount=6 s YINLIUYANSEXZId6=ICUOICUPIDr
	.....s icucriCode="YINLIUYANSEXZ"_YINLIUYANSECount
	....e  i ICUOICUPIDr=YINLIUYANSEXZId1 d
	.....s icucriCode="YINLIUYANSEXZ"_1
	.....s YINLIUYANSEXZId1=ICUOICUPIDr
	....e  i ICUOICUPIDr=YINLIUYANSEXZId2 d
	.....s icucriCode="YINLIUYANSEXZ"_2
	.....s YINLIUYANSEXZId2=ICUOICUPIDr
	....e  i ICUOICUPIDr=YINLIUYANSEXZId3 d
	.....s icucriCode="YINLIUYANSEXZ"_3
	.....s YINLIUYANSEXZId3=ICUOICUPIDr
	....e  i ICUOICUPIDr=YINLIUYANSEXZId4 d
	.....s icucriCode="YINLIUYANSEXZ"_4
	.....s YINLIUYANSEXZId4=ICUOICUPIDr
	....e  i ICUOICUPIDr=YINLIUYANSEXZId5 d
	.....s icucriCode="YINLIUYANSEXZ"_5
	.....s YINLIUYANSEXZId5=ICUOICUPIDr
	....e  i ICUOICUPIDr=YINLIUYANSEXZId6 d
	.....s icucriCode="YINLIUYANSEXZ"_6
	.....s YINLIUYANSEXZId6=ICUOICUPIDr
	...
	...i (ICUOViewCat="340")  d //ICU冷热疗
	....i (ICUOICUPIDr'=LengReLiaoId1)&&(ICUOICUPIDr'=LengReLiaoId2) d
	.....s LengReLiaoCount=LengReLiaoCount+1
	.....i LengReLiaoCount=1 s LengReLiaoId1=ICUOICUPIDr
	.....i LengReLiaoCount=2 s LengReLiaoId2=ICUOICUPIDr
	.....s icucriCode="LengReLiao"_LengReLiaoCount
	....e  i ICUOICUPIDr=LengReLiaoId1 d
	.....s icucriCode="LengReLiao"_1
	.....s LengReLiaoId1=ICUOICUPIDr
	....e  i ICUOICUPIDr=LengReLiaoId2 d
	.....s icucriCode="LengReLiao"_2
	.....s LengReLiaoId2=ICUOICUPIDr
	...
	...i (ICUOViewCat="343")  d //ICU换药
	....i ((ICUOICUPIDr'=HuanYaoId1)&&(ICUOICUPIDr'=HuanYaoId2)&&(ICUOICUPIDr'=HuanYaoId3)&&(ICUOICUPIDr'=HuanYaoId4)) d
	.....s HuanYaoCount=HuanYaoCount+1
	.....i HuanYaoCount=1 s HuanYaoId1=ICUOICUPIDr
	.....i HuanYaoCount=2 s HuanYaoId2=ICUOICUPIDr
	.....i HuanYaoCount=3 s HuanYaoId3=ICUOICUPIDr
	.....i HuanYaoCount=4 s HuanYaoId4=ICUOICUPIDr
	.....s icucriCode="HuanYao"_HuanYaoCount
	....e  i ICUOICUPIDr=HuanYaoId1 d
	.....s icucriCode="HuanYao"_1
	.....s HuanYaoId1=ICUOICUPIDr
	....e  i ICUOICUPIDr=HuanYaoId2 d
	.....s icucriCode="HuanYao"_2
	.....s HuanYaoId2=ICUOICUPIDr
	....e  i ICUOICUPIDr=HuanYaoId3 d
	.....s icucriCode="HuanYao"_3
	.....s HuanYaoId3=ICUOICUPIDr
	....e  i ICUOICUPIDr=HuanYaoId4 d
	.....s icucriCode="HuanYao"_4
	.....s HuanYaoId4=ICUOICUPIDr
	...i (paraViewCat="337")  d //生活护理
	....i ((ICUOICUPIDr'=SHHL1)&&(ICUOICUPIDr'=SHHL2)&&(ICUOICUPIDr'=SHHL3)&&(ICUOICUPIDr'=SHHL4)&&(ICUOICUPIDr'=SHHL5)&&(ICUOICUPIDr'=SHHL6)) d
	.....s SHHLCount=SHHLCount+1
	.....i SHHLCount=1 s SHHL1=ICUOICUPIDr
	.....i SHHLCount=2 s SHHL2=ICUOICUPIDr
	.....i SHHLCount=3 s SHHL3=ICUOICUPIDr
	.....i SHHLCount=4 s SHHL4=ICUOICUPIDr
	.....i SHHLCount=5 s SHHL5=ICUOICUPIDr
	.....i SHHLCount=6 s SHHL6=ICUOICUPIDr
	.....s icucriCode="SHHL"_SHHLCount
	....e  i ICUOICUPIDr=SHHL1 d
	.....s icucriCode="SHHL"_1
	.....s SHHL1=ICUOICUPIDr
	....e  i ICUOICUPIDr=SHHL2 d
	.....s icucriCode="SHHL"_2
	.....s SHHL2=ICUOICUPIDr
	....e  i ICUOICUPIDr=SHHL3 d
	.....s icucriCode="SHHL"_3
	.....s SHHL3=ICUOICUPIDr
	....e  i ICUOICUPIDr=SHHL4 d
	.....s icucriCode="SHHL"_4
	.....s SHHL4=ICUOICUPIDr
	....e  i ICUOICUPIDr=SHHL5 d
	.....s icucriCode="SHHL"_5
	.....s SHHL5=ICUOICUPIDr
	....e  i ICUOICUPIDr=SHHL6 d
	.....s icucriCode="SHHL"_6
	.....s SHHL6=ICUOICUPIDr
	...i (paraViewCat="338")  d //基础护理
	....i ((ICUOICUPIDr'=JCHL1)&&(ICUOICUPIDr'=JCHL2)&&(ICUOICUPIDr'=JCHL3)&&(ICUOICUPIDr'=JCHL4)&&(ICUOICUPIDr'=JCHL5)&&(ICUOICUPIDr'=JCHL6)&&(ICUOICUPIDr'=JCHL7)) d
	.....s JCHLCount=JCHLCount+1
	.....i JCHLCount=1 s JCHL1=ICUOICUPIDr
	.....i JCHLCount=2 s JCHL2=ICUOICUPIDr
	.....i JCHLCount=3 s JCHL3=ICUOICUPIDr
	.....i JCHLCount=4 s JCHL4=ICUOICUPIDr
	.....i JCHLCount=5 s JCHL5=ICUOICUPIDr
	.....i JCHLCount=6 s JCHL6=ICUOICUPIDr
	.....i JCHLCount=7 s JCHL7=ICUOICUPIDr
	.....s icucriCode="JCHL"_JCHLCount
	....e  i ICUOICUPIDr=JCHL1 d
	.....s icucriCode="JCHL"_1
	.....s JCHL1=ICUOICUPIDr
	....e  i ICUOICUPIDr=JCHL2 d
	.....s icucriCode="JCHL"_2
	.....s JCHL2=ICUOICUPIDr
	....e  i ICUOICUPIDr=JCHL3 d
	.....s icucriCode="JCHL"_3
	.....s JCHL3=ICUOICUPIDr
	....e  i ICUOICUPIDr=JCHL4 d
	.....s icucriCode="JCHL"_4
	.....s JCHL4=ICUOICUPIDr
	....e  i ICUOICUPIDr=JCHL5 d
	.....s icucriCode="JCHL"_5
	.....s JCHL5=ICUOICUPIDr
	....e  i ICUOICUPIDr=JCHL6 d
	.....s icucriCode="JCHL"_6
	.....s JCHL6=ICUOICUPIDr
	....e  i ICUOICUPIDr=JCHL7 d
	.....s icucriCode="JCHL"_7
	.....s JCHL7=ICUOICUPIDr
	...i (paraViewCat="339")  d //专科护理
	....i ((ICUOICUPIDr'=ZKHL1)&&(ICUOICUPIDr'=ZKHL2)&&(ICUOICUPIDr'=ZKHL3)&&(ICUOICUPIDr'=ZKHL4)) d
	.....s ZKHLCount=ZKHLCount+1
	.....i ZKHLCount=1 s ZKHL1=ICUOICUPIDr
	.....i ZKHLCount=2 s ZKHL2=ICUOICUPIDr
	.....i ZKHLCount=3 s ZKHL3=ICUOICUPIDr
	.....i ZKHLCount=4 s ZKHL4=ICUOICUPIDr
	.....s icucriCode="ZKHL"_ZKHLCount
	....e  i ICUOICUPIDr=ZKHL1 d
	.....s icucriCode="ZKHL"_1
	.....s ZKHL1=ICUOICUPIDr
	....e  i ICUOICUPIDr=ZKHL2 d
	.....s icucriCode="ZKHL"_2
	.....s ZKHL2=ICUOICUPIDr
	....e  i ICUOICUPIDr=ZKHL3 d
	.....s icucriCode="ZKHL"_3
	.....s ZKHL3=ICUOICUPIDr
	....e  i ICUOICUPIDr=ZKHL4 d
	.....s icucriCode="ZKHL"_4
	.....s ZKHL4=ICUOICUPIDr
	...i (paraViewCat="341")  d //功能锻炼
	....i ((ICUOICUPIDr'=GNDL1)&&(ICUOICUPIDr'=GNDL2)&&(ICUOICUPIDr'=GNDL3)) d
	.....s GNDLCount=GNDLCount+1
	.....i GNDLCount=1 s GNDL1=ICUOICUPIDr
	.....i GNDLCount=2 s GNDL2=ICUOICUPIDr
	.....i GNDLCount=3 s GNDL3=ICUOICUPIDr
	.....s icucriCode="GNDL"_GNDLCount
	....e  i ICUOICUPIDr=GNDL1 d
	.....s icucriCode="GNDL"_1
	.....s GNDL1=ICUOICUPIDr
	....e  i ICUOICUPIDr=GNDL2 d
	.....s icucriCode="GNDL"_2
	.....s GNDL2=ICUOICUPIDr
	....e  i ICUOICUPIDr=GNDL3 d
	.....s icucriCode="GNDL"_3
	.....s GNDL3=ICUOICUPIDr
	...i (paraViewCat="342")  d //约束
	....i ((ICUOICUPIDr'=YS1)&&(ICUOICUPIDr'=YS2)&&(ICUOICUPIDr'=YS3)&&(ICUOICUPIDr'=YS4)&&(ICUOICUPIDr'=YS5)) d
	.....s YSCount=YSCount+1
	.....i YSCount=1 s YS1=ICUOICUPIDr
	.....i YSCount=2 s YS2=ICUOICUPIDr
	.....i YSCount=3 s YS3=ICUOICUPIDr
	.....i YSCount=4 s YS4=ICUOICUPIDr
	.....i YSCount=5 s YS5=ICUOICUPIDr
	.....s icucriCode="YS"_YSCount
	....e  i ICUOICUPIDr=YS1 d
	.....s icucriCode="YS"_1
	.....s YS1=ICUOICUPIDr
	....e  i ICUOICUPIDr=YS2 d
	.....s icucriCode="YS"_2
	.....s YS2=ICUOICUPIDr
	....e  i ICUOICUPIDr=YS3 d
	.....s icucriCode="YS"_3
	.....s YS3=ICUOICUPIDr
	....e  i ICUOICUPIDr=YS4 d
	.....s icucriCode="YS"_4
	.....s YS4=ICUOICUPIDr
	....e  i ICUOICUPIDr=YS5 d
	.....s icucriCode="YS"_5
	.....s YS5=ICUOICUPIDr
	...
	...;特殊字符处理
	...i ICUOViewCat="191"  d //护理记录 
	....s icuoValue=$replace(icuoValue,";",",")
	....s icuoValue=$replace(icuoValue,"/",",")
	....s icuoValue=$replace(icuoValue,"^",",")
	....s icuoValue=$replace(icuoValue,"#",",")
	....s icuoValue=$replace(icuoValue,"；",",")
	...i ((icuoComOrdDr'=5039)&&(icuoComOrdDr'=7537))  d
	....if $l(icuoValue,"*")>1 s icuoValue=$p(icuoValue,"*",1)	///20210808 ly add
	...
	...;i ((icuoValue=0)&&(ICUOViewCat'="310")&&(ICUOViewCat'="331")&&(ICUOViewCat'="215")&&(ICUOViewCat'="222")&&(ICUOViewCat'=330)&&(ICUOViewCat'="249")) s icuoValue=""    //评分,生命体征,出入量,CRRT
	...s icuoOrderStr=icucriCode_$c(3)_icuoComOrdDr_$c(3)_icuoValue_$c(3)_ICUOViewCat_$c(3)_icuoId
	...i orderStr="" s orderStr=$tr(icuoOrderStr,";","；")	///20210426 ly
	...e  s orderStr=orderStr_";"_$tr(icuoOrderStr,";","；")	///20210426 ly
	...i icuoUserDesc'="" d
	....q:UserFlag="Y"
	....i UserStr="" s UserStr=icuoUserDesc
	....e  i UserStr'[icuoUserDesc s UserStr=UserStr_"/"_icuoUserDesc
	....s UserFlag="Y"
	...i OtherDesc'="" d
	....q:otherUserFlag="Y"
	....i UserStr="" s UserStr=OtherDesc
	....e  i UserStr'[OtherDesc s UserStr=UserStr_"/"_OtherDesc
	....s otherUserFlag="Y"
	...
	...i icuoDocUserDesc'="" d		///双签20210501 ly
	....i DocUserStr="" s DocUserStr=icuoDocUserDesc
	....e  i DocUserStr'[icuoDocUserDesc s DocUserStr=DocUserStr_","_icuoDocUserDesc
	...
	..i orderStr="" k ^TMPDHCICU("GetPrintOrdersNewICU",icuaId,curDate,icuoSttTime) q
	..;s UserStr=$p(UserStr,"/",1)
	..i inoutStr'="" s orderStr=orderStr_";"_$tr(inoutStr,";","；")	///20210426 ly
	..
	..s ^TMPDHCICU("GetPrintOrdersNewICU",icuaId,curDate,icuoSttTime)=^TMPDHCICU("GetPrintOrdersICU",icuaId,curDate,icuoSttTime)_"^"_orderStr_"^"_UserStr_"^"_DocUserStr_"^"_oriUserId_","_icuoDocUserDrStr

    s Date="" f  s Date=$o(^TMPDHCICU("GetPrintOrdersNewICU",icuaId,Date)) q:Date=""  d
	.s Time="" f  s Time=$o(^TMPDHCICU("GetPrintOrdersNewICU",icuaId,Date,Time)) q:Time=""  d
	..s DT=$p($g(^TMPDHCICU("GetPrintOrdersNewICU",icuaId,Date,Time)),"^",1)
	..s Orders=$p($g(^TMPDHCICU("GetPrintOrdersNewICU",icuaId,Date,Time)),"^",2)
	..;s Orders=$tr(Orders,";","；")
	..s User=$p($g(^TMPDHCICU("GetPrintOrdersNewICU",icuaId,Date,Time)),"^",3)
	..s DocUser=$p($g(^TMPDHCICU("GetPrintOrdersNewICU",icuaId,Date,Time)),"^",4)
	..s userId=$p($g(^TMPDHCICU("GetPrintOrdersNewICU",icuaId,Date,Time)),"^",5)
	..s ^TMPDHCICU("GetPrintOrdersNewICUOut",icuaId,Date,Time)=$lb(DT,Orders,User,DocUser,userId)
    ..Do PrintOrdersNew

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK


PrintOrdersNew
 Set ^CacheTemp(repid,ind)=^TMPDHCICU("GetPrintOrdersNewICUOut",icuaId,Date,Time)
 Set ind=ind+1
 quit
}

ClassMethod GetPrintOrdersNewICUFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintOrdersNewICUExecute ]
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

ClassMethod GetPrintOrdersNewICUClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintOrdersNewICUExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Creator：      	wxx
/// CreatDate：    	2019-08-30
/// Description： 	保存病人打印记录
/// Table：        	DHC_ICU_PrintRecord
/// Input：        	入参：icuaId监护ID, sttime打印页起始日期, time打印页起始时间,enddate打印页结束日期, endtime打印页结束时间, dateTimeSeq序号(暂未用), page打印页, pageRow行数, userId用户
/// Return：       	返回：0成功，其它出错信息。
/// w ##Class(web.DHCICUOrder).SavePrintRecordNew("31299","2018-09-20","02:00","2018-09-20","15:30","5","20","113")
ClassMethod SavePrintRecordNew(icuaId, stdate, sttime, enddate, endtime, page, pageRow, userId) As %String
{
	s ^tmpwxx("SavePrintRecordXY",icuaId,$h)=icuaId_"^"_stdate_"^"_sttime_"^"_enddate_"^"_endtime_"^"_page_"^"_pageRow_"^"_userId
	q:icuaId="" "监护号不能为空!"
	q:'$d(^DHCICUArrange(icuaId)) "监护号没有数据!"
	q:page="" "页码不能为空!"
	q:(stdate="")!(sttime="")!(enddate="")!(endtime="") "日期和时间不能为空!"
	s stdate=##class(web.DHCCLCom).ConvertToDateH(stdate)
	s sttime=##class(web.DHCCLCom).ConvertToTimeH(sttime)
	s enddate=##class(web.DHCCLCom).ConvertToDateH(enddate)
	s endtime=##class(web.DHCCLCom).ConvertToTimeH(endtime)
	k PLIST
	s PLIST(3)=+$h
	s PLIST(4)=$p($h,",",2)
	s PLIST(5)=""
	s PLIST(6)=page
	s PLIST(7)=pageRow
	s PLIST(8)=userId
	s PLIST(9)=stdate
	s PLIST(10)=sttime
	s PLIST(11)=enddate
	s PLIST(12)=endtime
	
	s icuprSub=$o(^DHCICUArrange(0,"PrintPage",icuaId,page,""))
	i icuprSub'="" d
		.s icuprId=icuaId_"||"_icuprSub
		.&sql(update DHC_ICU_PrintRecord VALUES :PLIST() WHERE ICUPR_RowId=:icuprId)
	e  d
		.s PLIST(0)=icuaId
		.&sql(insert into DHC_ICU_PrintRecord VALUES :PLIST())
	s retStr=0
	i SQLCODE s retStr="保存数据错! code="_SQLCODE
	q retStr
}

/// Creator：      	wxx
/// CreatDate：    	2010-03-30
/// Description： 	获取病人打印记录
/// Table：        	DHC_ICU_PrintRecord
/// Input：        	入参：icuaId监护ID, date重症记录日期, time重症记录时间, page打印页。
/// Return：       	返回：0成功，其它出错信息。
ClassMethod GetPrintRecordNew(icuaId, date, time, page, isNextPage As %String = "Y") As %String
{
	q:icuaId="" "监护号不能为空!"
	q:'$d(^DHCICUArrange(icuaId)) "监护号没有数据!"
	//q:page="" "页码不能为空!"
	i date'="" s date=##class(web.DHCCLCom).ConvertToDateH(date)
	i time'="" s time=##class(web.DHCCLCom).ConvertToTimeH(time)
	i time'="",time\60*60=time s time=time+30
	
	s retStr="",icuprSub=""
	i page'="" s icuprSub=$o(^DHCICUArrange(0,"PrintPage",icuaId,page,""))
	i icuprSub="",date="" d
		.s page=$o(^DHCICUArrange(0,"PrintPage",icuaId,""),-1)
		.q:page=""
		.s icuprSub=$o(^DHCICUArrange(0,"PrintPage",icuaId,page,""),-1)
	i icuprSub'="" d
		.s icuprStr=$g(^DHCICUArrange(icuaId,"PR",icuprSub))
		.q:icuprStr=""
		.s $p(icuprStr,"^",1)=$zd($p(icuprStr,"^",1),3)
		.s $p(icuprStr,"^",2)=$zt($p(icuprStr,"^",2))
		.s $p(icuprStr,"^",7)=$zd($p(icuprStr,"^",7),3)
		.s $p(icuprStr,"^",8)=$zt($p(icuprStr,"^",8))
		.s $p(icuprStr,"^",9)=$zd($p(icuprStr,"^",9),3)
		.s $p(icuprStr,"^",10)=$zt($p(icuprStr,"^",10))
		.s retStr=$tr(icuprStr,"^",$c(3))
	q:retStr'="" retStr
	q:date="" retStr
	
	q retStr
}

ClassMethod SavePrintPages(icuaId, Pages) As %String
{
	q:(icuaId="")||(Pages="") ""
	s ^DHCICUArrange(icuaId,"PrintPages")=Pages
    
    q 0
}

/// w ##Class(web.DHCICUOrder).SaveICUInOut("14","2020/7/21","16:00","6691","7(13)","10211")
ClassMethod SaveICUInOut(icuaId, date, time, icuoComOrdDr, value, userId) As %String
{
	i date'="" s date=##class(web.DHCCLCom).ConvertToDateH(date)
	i time'="" s time=##class(web.DHCCLCom).ConvertToTimeH(time)
    s ^DHCICUOrder("ICUInOut",icuaId,date,time,icuoComOrdDr)=value_"^"_userId
    
    q 0
}

/// 获取病人打印生命体征折线图
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintLineChar","14","2020/7/27","Temper")
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintLineChar","60","2020/8/14","Temper")
Query GetPrintLineChar(icuaId, date, ItemCodeStr, ctlocId As %String = "") As %Query(ROWSPEC = "icucCode,CharStr") [ SqlProc ]
{
}

ClassMethod GetPrintLineCharExecute(ByRef qHandle As %Binary, icuaId, date, ItemCodeStr, ctlocId As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^TMPDHCICU("GetPrintLineChar")
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	if ((ctlocId=210)||(ctlocId=234)||(ctlocId=278)||(ctlocId=1220)){
		s sttime=##class(web.DHCClinicCom).ConvertToTimeH("7:00")
		s endtime=##class(web.DHCClinicCom).ConvertToTimeH("6:59")
	}
	else
	{
		s sttime=##class(web.DHCClinicCom).ConvertToTimeH("8:00")
		s endtime=##class(web.DHCClinicCom).ConvertToTimeH("7:59")
	}
	s vsFlag="" //曲线说明
	
	f curDate=date:1:(date+1) d
	.s icuoSttTime=""
	.f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
	..;w !,curDate_"^"_icuoSttTime
	..q:(curDate=date)&&(icuoSttTime<sttime)    //早于开始时间
	..q:(curDate=(date+1))&&(icuoSttTime>endtime)    //晚于开始时间
	..s icuoId=""
	..s vsFlag=..GetLastVSNote(icuaId,curDate,icuoSttTime,ctlocId) ///区分有创和无创折线图是否显示
	..s vsPluseFlag=..GetLastVSPluse(icuaId,curDate,icuoSttTime,ctlocId)	///判断脉搏是否显示
	..;w vsFlag,!
	..;b ;vsFlag 1
	..f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
	...q:$d(^DHCICUOrder(icuoId))<1
	...s icuoUserStr="",icuoOrderStr="",icuoValue="",icucriCode="",icuoComOrdDr=""
	...s orderEditFlag=$p($g(^DHCICUOrder(icuoId)),"^",25)
	...q:orderEditFlag="C"
	...;w !,icuoId
	...s icuoComOrdDr=$p($g(^DHCICUOrder(icuoId)),"^",2)
    ...q:icuoComOrdDr=""
    ...q:(vsFlag="有创")&&("5332,5333,5334,5335"[icuoComOrdDr)	///区分有创和无创折线图是否显示
    ...q:(vsFlag="无创")&&("5336,5337,5338,5339"[icuoComOrdDr)
    ...
    ...q:((vsPluseFlag="")||(vsPluseFlag="×"))&&("5419"[icuoComOrdDr)&&((ctlocId=278)||(ctlocId=210)||(ctlocId=234)||(ctlocId=1220))	///判断脉搏是否显示
    ...
    ...;w !,vsFlag_"^"_$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",1)
	...s icucriCode=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",1)
	...q:(ItemCodeStr'="")&&(ItemCodeStr'[icucriCode)
	...;b ;2
	...s icuoUserDr=$p($g(^DHCICUOrder(icuoId)),"^",4)
	...i icuoUserDr'="" s icuoUserDesc=$p($g(^SSU("SSUSR",icuoUserDr)),"^",2)
	...s OtherDesc=$p($g(^DHCICUOrder(icuoId,"OtherUser")),"^",2)
    ...s icuoNote=$p($g(^DHCICUOrder(icuoId)),"^",10)
    ...s icuoQty=+$p($g(^DHCICUOrder(icuoId)),"^",11)
    ...s ICUOICUPIDr=$p($g(^DHCICUOrder(icuoId)),"^",38)
    ...s boolICUOICUP=0
    ...i "5332,5333,5334,5335,5336,5337,5338,5339"[icuoComOrdDr  d
    ....s boolICUOICUP=1
    ...q:((ICUOICUPIDr="")&&(boolICUOICUP=0))
    ...q:(boolICUOICUP=0)&&(ICUOICUPIDr'="")&&($p(ICUOICUPIDr,"||",1)'="")&&($p(ICUOICUPIDr,"||",2)'="")&&($p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",20)="N") //已删除医嘱不加载
	...;b ;3
	...s icuoDataType=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",24)
	...;w !,icuoComOrdDr_"^"_icuoDataType_"^"_icucriCode_"^"_icuoQty_"^"_icuoNote
	...i "Qty,Volume"[icuoDataType s icuoValue=icuoQty
	...i icuoDataType="Note" s icuoValue=icuoNote
	...s ^TMPDHCICU("GetPrintLineChar",icuaId,icucriCode,curDate,icuoSttTime,icuoId)=icuoValue
    
    s icucCode="" f  s icucCode=$o(^TMPDHCICU("GetPrintLineChar",icuaId,icucCode)) q:icucCode=""  d
    .s CharStr=""
    .s icucdate="" f  s icucdate=$o(^TMPDHCICU("GetPrintLineChar",icuaId,icucCode,icucdate)) q:icucdate=""  d
    ..s icuctime="" f  s icuctime=$o(^TMPDHCICU("GetPrintLineChar",icuaId,icucCode,icucdate,icuctime)) q:icuctime=""  d
    ...s icucId="" f  s icucId=$o(^TMPDHCICU("GetPrintLineChar",icuaId,icucCode,icucdate,icuctime,icucId)) q:icucId=""  d
    ....s ret=""
    ....s icucValue=$g(^TMPDHCICU("GetPrintLineChar",icuaId,icucCode,icucdate,icuctime,icucId))
    ....q:icucValue=""
    ....s ret=$zd(icucdate,3)_" "_$zt(icuctime,2)_"^"_icucValue
    ....i CharStr="" s CharStr=ret
    ....e  s CharStr=CharStr_";"_ret
    .q:CharStr=""
    .s Data=$lb(icucCode,CharStr)
    .Do GetPrintLineChar

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK


GetPrintLineChar
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetPrintLineCharFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintLineCharExecute ]
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

ClassMethod GetPrintLineCharClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintLineCharExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 获取病人打印生命体征记录单数据
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintDataChar","14","2020/7/27","VitalSign^ContinuousInjectionPumps^IntravenousInfusion^NasalFeedingPumping^Injection^NursingRecordItems^ICUCareEvaluateItem^DrugIntake")
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintDataChar","3","2021-04-19","VitalSign^RespiratorySupport^Oral^ContinuousInjectionPumps^IntravenousInfusion^NasalFeedingPumping^Injection^CRRT^DrugIntake^NursingRecordItems^Pipe^ICUCareEvaluateItem")
Query GetPrintDataChar(icuaId, date, ViewCatStr) As %Query(ROWSPEC = "icucViewCat,icucDesc,icupDr,dateTime,DataStr") [ SqlProc ]
{
}

ClassMethod GetPrintDataCharExecute(ByRef qHandle As %Binary, icuaId, date, ViewCatStr) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^TMPDHCICU("GetPrintDataChar")
	k ^TMPDHCICU("GetPrintDataCharOther")
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	s sttime=##class(web.DHCClinicCom).ConvertToTimeH("8:00")
	s endtime=##class(web.DHCClinicCom).ConvertToTimeH("7:59")
	
	s icuoUserStr=""
	f curDate=date:1:(date+1) d
	.s icuoSttTime=""
	.f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
	..;w !,curDate_"^"_icuoSttTime
	..q:(curDate=date)&&(icuoSttTime<sttime)    //早于开始时间
	..q:(curDate=(date+1))&&(icuoSttTime>endtime)    //晚于开始时间
	
	..s inoutId="",inoutValue="",inoutVC="",inoutUser="",inoutDesc=""
	..f  s inoutId=$o(^DHCICUOrder("ICUInOut",icuaId,curDate,icuoSttTime,inoutId)) q:inoutId=""  d
	...s inoutValue=$p($g(^DHCICUOrder("ICUInOut",icuaId,curDate,icuoSttTime,inoutId)),"^",1)
	...s inoutUserId=$p($g(^DHCICUOrder("ICUInOut",icuaId,curDate,icuoSttTime,inoutId)),"^",2)
	...i inoutUserId'="" s inoutUser=$p($g(^SSU("SSUSR",inoutUserId)),"^",2)
	...s inoutCode=$p($g(^DHCICUC("RecordItem",inoutId)),"^",1)
	...s inoutDesc=$p($g(^DHCICUC("RecordItem",inoutId)),"^",2)
	...s inoutVC=$p($g(^DHCICUC("RecordItem",inoutId)),"^",5)
	...s inoutIndex=""
	...f i=1:1:$length(ViewCatStr,"^") d
    ....s VCDr=$p(ViewCatStr,"^",i)
    ....;b //1
    ....i $p(VCDr,"_",2)=$p($g(^DHCICUC("ViewCat",inoutVC)),"^",1) s inoutIndex=$p(VCDr,"_",1)
    ...q:inoutIndex=""
	...i inoutValue'="" s ^TMPDHCICU("GetPrintDataChar",+icuaId,inoutIndex,inoutVC,"InOut",inoutId,inoutDesc,curDate,icuoSttTime,"InOut")=inoutValue_"^"_inoutUser
	...;s inout=inoutCode_"#"_inoutId_"#"_inoutValue
	...;i inoutStr="" s inoutStr=inout
	...;e  s inoutStr=inoutStr_";"_inout
	..s icuoId=""
	..f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
	...q:$d(^DHCICUOrder(icuoId))<1
	...s icuoOrderStr="",icuoValue="",icucriCode="",icuoComOrdDr=""
	...s orderEditFlag=$p($g(^DHCICUOrder(icuoId)),"^",25)
	...q:orderEditFlag="C"
	...;w !,icuoId
	...s icuoComOrdDr=$p($g(^DHCICUOrder(icuoId)),"^",2)
    ...q:icuoComOrdDr=""
    ...
    ...s ICUOViewCat=$p($g(^DHCICUOrder(icuoId)),"^",16)
    ...q:ICUOViewCat=""
    ...q:(ViewCatStr'="")&&(ViewCatStr'[$p($g(^DHCICUC("ViewCat",ICUOViewCat)),"^",1))
    ...s index=""
    ...f i=1:1:$length(ViewCatStr,"^") d
    ....s VCDr=$p(ViewCatStr,"^",i)
    ....i $p(VCDr,"_",2)=$p($g(^DHCICUC("ViewCat",ICUOViewCat)),"^",1) s index=$p(VCDr,"_",1)
    ...s icucViewCat=$p($g(^DHCICUC("ViewCat",ICUOViewCat)),"^",2)
	...s icucriCode=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",1)
	...s icuoUserDr=$p($g(^DHCICUOrder(icuoId)),"^",4)
	...i icuoUserDr'="" s icuoUserDesc=$p($g(^SSU("SSUSR",icuoUserDr)),"^",2)
	...i icuoUserStr'[icuoUserDesc d
	....i icuoUserStr="" s icuoUserStr=icuoUserDesc
	....e  s icuoUserStr=icuoUserStr_"  "_icuoUserDesc
	...s OtherDesc=$p($g(^DHCICUOrder(icuoId,"OtherUser")),"^",2)
    ...s icuoNote=$p($g(^DHCICUOrder(icuoId)),"^",10)
    ...s icuoQty=+$p($g(^DHCICUOrder(icuoId)),"^",11)
    ...s ICUOICUPIDr=$p($g(^DHCICUOrder(icuoId)),"^",38)
    ...q:ICUOICUPIDr=""
    ...q:(ICUOICUPIDr'="")&&($p(ICUOICUPIDr,"||",1)'="")&&($p(ICUOICUPIDr,"||",2)'="")&&($p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",20)="N") //已删除医嘱不加载
	...q:$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",19)'=""  //不取子项
	...s paraDesc=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",14)
	...s icuoDataType=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",24)
	...;w !,icuoComOrdDr_"^"_icuoDataType_"^"_icucriCode_"^"_icuoQty_"^"_icuoNote
	...i "Qty,Volume"[icuoDataType s icuoValue=icuoQty
	...i icuoDataType="Note" s icuoValue=icuoNote
	...q:index=""
	...i ICUOViewCat'=310 s ^TMPDHCICU("GetPrintDataChar",+icuaId,index,ICUOViewCat,ICUOICUPIDr,icuoComOrdDr,paraDesc,curDate,icuoSttTime,icuoId)=icuoValue_"^"_icuoUserDesc
    ...s ^TMPDHCICU("GetPrintDataCharOther",+icuaId,curDate,icuoSttTime,icuoId)=paraDesc_":"_icuoValue
    
    

    
    i icuoUserStr'="" s ^TMPDHCICU("GetPrintDataCharOther",+icuaId,date+1,25140,"ZQM")="护士"_":"_icuoUserStr_"   "_"审核人"

    s indx="" f  s indx=$o(^TMPDHCICU("GetPrintDataChar",+icuaId,indx)) q:indx=""  d
    .;b //1
    .s viewCatDr="" f  s viewCatDr=$o(^TMPDHCICU("GetPrintDataChar",+icuaId,indx,viewCatDr)) q:viewCatDr=""  d
    ..s icupDr="" f  s icupDr=$o(^TMPDHCICU("GetPrintDataChar",+icuaId,indx,viewCatDr,icupDr)) q:icupDr=""  d
    ...s icucViewCat=$p($g(^DHCICUC("ViewCat",viewCatDr)),"^",1)
    ...s icucDr="" f  s icucDr=$o(^TMPDHCICU("GetPrintDataChar",+icuaId,indx,viewCatDr,icupDr,icucDr)) q:icucDr=""  d
    ....s paraName="" f  s paraName=$o(^TMPDHCICU("GetPrintDataChar",+icuaId,indx,viewCatDr,icupDr,icucDr,paraName)) q:paraName=""  d
    .....s DataStr="",userStr=""
    .....s icucdate="" f  s icucdate=$o(^TMPDHCICU("GetPrintDataChar",+icuaId,indx,viewCatDr,icupDr,icucDr,paraName,icucdate)) q:icucdate=""  d
    ......s icuctime="" f  s icuctime=$o(^TMPDHCICU("GetPrintDataChar",+icuaId,indx,viewCatDr,icupDr,icucDr,paraName,icucdate,icuctime)) q:icuctime=""  d
    .......s icucId="" f  s icucId=$o(^TMPDHCICU("GetPrintDataChar",+icuaId,indx,viewCatDr,icupDr,icucDr,paraName,icucdate,icuctime,icucId)) q:icucId=""  d
    ........s ret=""
    ........s icucValue=$p($g(^TMPDHCICU("GetPrintDataChar",+icuaId,indx,viewCatDr,icupDr,icucDr,paraName,icucdate,icuctime,icucId)),"^",1)
    ........q:icucValue=""
    ........s icucValue=$replace(icucValue,";",",")
    ........s icucValue=$replace(icucValue,"/",",")
    ........s icucUser=$p($g(^TMPDHCICU("GetPrintDataChar",+icuaId,indx,viewCatDr,icupDr,icucDr,paraName,icucdate,icuctime,icucId)),"^",2)
    ........i icucUser'="" s icucUser=$zd(icucdate,3)_" "_$zt(icuctime,2)_"^"_icucUser
    ........i userStr="" s userStr=icucUser
    ........e  i icucUser'="" s userStr=userStr_","_icucUser
    ........s ret=$zd(icucdate,3)_" "_$zt(icuctime,2)_"^"_icucValue
    ........i DataStr="" s DataStr=ret
    ........e  s DataStr=DataStr_";"_ret
    .....;s Data=$lb("签名",userStr)
    .....;Do GetPrintDataChar
    .....;q:icucriDesc'="ABP(mmHg)"
    .....s Data=$lb(icucViewCat,paraName,icupDr,"",DataStr)
    .....Do GetPrintDataChar
	
	s odate="" f  s odate=$o(^TMPDHCICU("GetPrintDataCharOther",+icuaId,odate)) q:odate=""  d
	.s otime="" f  s otime=$o(^TMPDHCICU("GetPrintDataCharOther",+icuaId,odate,otime)) q:otime=""  d
	..s DataStr=""
	..s icuoid="" f  s icuoid=$o(^TMPDHCICU("GetPrintDataCharOther",+icuaId,odate,otime,icuoid)) q:icuoid=""  d
	...s icuov=$g(^TMPDHCICU("GetPrintDataCharOther",+icuaId,odate,otime,icuoid))
	...q:icuov=""
	...s icuov=$replace(icuov,";",",")
	...s icuov=$replace(icuov,"/",",")
	...i DataStr="" s DataStr=icuov
	...e  s DataStr=DataStr_";"_icuov
	..s dateTime=$zd(odate,3)_" "_$zt(otime,2)
	..s Data=$lb("","","",dateTime,DataStr)
    ..Do GetPrintDataChar

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK

GetPrintDataChar
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetPrintDataCharFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintDataCharExecute ]
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

ClassMethod GetPrintDataCharClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintDataCharExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 获取病人打印生命体征记录单数据
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintDataCharYC","14","2020/7/27","VitalSign^ContinuousInjectionPumps^IntravenousInfusion^NasalFeedingPumping^Injection^NursingRecordItems^ICUCareEvaluateItem^DrugIntake")
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintDataCharYC","3","2021/4/19","VitalSign^RespiratorySupport^Oral^ContinuousInjectionPumps^IntravenousInfusion^NasalFeedingPumping^Injection^CRRT^DrugIntake^NursingRecordItems^Pipe^ICUCareEvaluateItem")
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintDataCharYC","2","2021/05/06","VitalSign^RespiratorySupport^Oral^ContinuousInjectionPumps^IntravenousInfusion^NasalFeedingPumping^Injection^CRRT^DrugIntake^NursingRecordItems^ICUCareEvaluateItem^SystemaNervosum^ICURespirationSupport^Other^ICUIntake")
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintDataCharYC","2","2021/05/20","VitalSign^RespiratorySupport^Oral^ContinuousInjectionPumps^IntravenousInfusion^NasalFeedingPumping^Injection^CRRT^DrugIntake^NursingRecordItems^ICUCareEvaluateItem^SystemaNervosum^ICURespirationSupport^Other^ICUIntake^DigestiveSystem^CirculatorySystem")
/// "VitalSign^RespiratorySupport^Oral^ContinuousInjectionPumps^IntravenousInfusion^NasalFeedingPumping^Injection^CRRT^DrugIntake^NursingRecordItems^ICUCareEvaluateItem^SystemaNervosum^ICURespirationSupport^Other^ICUIntake^DigestiveSystem^CirculatorySystem^DigestiveSystemPICU"
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintDataCharYC","3","2021/8/6","VitalSign^RespiratorySupport^Oral^ContinuousInjectionPumps^IntravenousInfusion^NasalFeedingPumping^Injection^CRRT^DrugIntake^NursingRecordItems^ICUCareEvaluateItem^SystemaNervosum^ICURespirationSupport^Other^ICUIntake^DigestiveSystem^CirculatorySystem^DigestiveSystemPICU")
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintDataCharYC","12","2021/8/10","PipeLine")
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintDataCharYC","12","2021/8/10","VitalSign^RespiratorySupport^Oral^ContinuousInjectionPumps^IntravenousInfusion^NasalFeedingPumping^Injection^CRRT^DrugIntake^NursingRecordItems^ICUCareEvaluateItem^SystemaNervosum^ICURespirationSupport^Other^ICUIntake^DigestiveSystem^CirculatorySystem^DigestiveSystemPICU^PipeLine")
/// VitalSign^RespiratorySupport^Oral^ContinuousInjectionPumps^IntravenousInfusion^NasalFeedingPumping^Injection^CRRT^DrugIntake^NursingRecordItems^ICUCareEvaluateItem^SystemaNervosum^ICURespirationSupport^Other^ICUIntake^DigestiveSystem^CirculatorySystem^DigestiveSystemPICU^PipeLine
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintDataCharYC","105","2021-08-19","IntravenousInfusion",61)
Query GetPrintDataCharYC(icuaId As %String, date As %String, ViewCatStr As %String, locId As %String = "") As %Query(ROWSPEC = "icucViewCat,icucDesc,icupDr,icucDr,dateTime,DataStr,user") [ SqlProc ]
{
}

ClassMethod GetPrintDataCharYCExecute(ByRef qHandle As %Binary, icuaId As %String, date As %String, ViewCatStr As %String, locId As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ^TMPCCQ("ICUPrintData",$h)=icuaId_"###"_date_"###"_ViewCatStr_"###"_locId
	k ^TMPDHCICU("GetPrintDataChar")
	k ^TMPDHCICU("GetPrintDataCharOther")
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	s sttime=##class(web.DHCClinicCom).ConvertToTimeH("8:00")
	s endtime=##class(web.DHCClinicCom).ConvertToTimeH("7:59")
	i ((locId="210")||(locId="234")||(locId="278")||(locId="1220")){   //ICU
		s sttime=##class(web.DHCClinicCom).ConvertToTimeH("7:00")
		s endtime=##class(web.DHCClinicCom).ConvertToTimeH("6:59")
	}
	s icuoUserStr=""
	f curDate=date:1:(date+1) d
	.s icuoSttTime=""
	.f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
	..;w !,curDate_"^"_icuoSttTime
	..q:(curDate=date)&&(icuoSttTime<sttime)    //早于开始时间
	..q:(curDate=(date+1))&&(icuoSttTime>endtime)    //晚于开始时间
	..s inoutId="",inoutValue="",inoutVC="",inoutUser="",inoutDesc=""
	..f  s inoutId=$o(^DHCICUOrder("ICUInOut",icuaId,curDate,icuoSttTime,inoutId)) q:inoutId=""  d
	...s inoutValue=$p($g(^DHCICUOrder("ICUInOut",icuaId,curDate,icuoSttTime,inoutId)),"^",1)
	...s inoutUserId=$p($g(^DHCICUOrder("ICUInOut",icuaId,curDate,icuoSttTime,inoutId)),"^",2)
	...i inoutUserId'="" s inoutUser=$p($g(^SSU("SSUSR",inoutUserId)),"^",2)
	...s inoutCode=$p($g(^DHCICUC("RecordItem",inoutId)),"^",1)
	...s inoutDesc=$p($g(^DHCICUC("RecordItem",inoutId)),"^",2)
	...s inoutVC=$p($g(^DHCICUC("RecordItem",inoutId)),"^",5)
	...i inoutValue'="" s ^TMPDHCICU("GetPrintDataChar",icuaId,inoutVC,"InOut",inoutId,inoutDesc,curDate,icuoSttTime,"InOut")=inoutValue_"^"_inoutUser
	...;s inout=inoutCode_"#"_inoutId_"#"_inoutValue
	...;i inoutStr="" s inoutStr=inout
	...;e  s inoutStr=inoutStr_";"_inout
	..s icuoId=""
	..f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
	...q:$d(^DHCICUOrder(icuoId))<1
	...s icuoOrderStr="",icuoValue="",icucriCode="",icuoComOrdDr=""
	...s orderEditFlag=$p($g(^DHCICUOrder(icuoId)),"^",25)
	...q:((orderEditFlag="C")||(orderEditFlag=""))
	...;w !,icuoId
	...s icuoComOrdDr=$p($g(^DHCICUOrder(icuoId)),"^",2)
    ...q:icuoComOrdDr=""
    ...s ICUOViewCat=$p($g(^DHCICUOrder(icuoId)),"^",16)
    ...q:ICUOViewCat=""
    ...
    ...q:((ICUOViewCat=373)&&($p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",23)'=""))
    ...
    ...q:(ViewCatStr'="")&&(ViewCatStr'[$p($g(^DHCICUC("ViewCat",ICUOViewCat)),"^",1))
    ...s icucViewCat=$p($g(^DHCICUC("ViewCat",ICUOViewCat)),"^",2)
	...s icucriCode=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",1)
	...s icuoUserDr=$p($g(^DHCICUOrder(icuoId)),"^",4)
	...
	...s icuoUserDesc=""
	...i icuoUserDr'="" s icuoUserDesc=$p($g(^SSU("SSUSR",icuoUserDr)),"^",2)
	...i icuoUserStr'[icuoUserDesc d
	....i icuoUserStr="" s icuoUserStr=icuoUserDesc
	....e  s icuoUserStr=icuoUserStr_"  "_icuoUserDesc
	...s OtherDesc=$p($g(^DHCICUOrder(icuoId,"OtherUser")),"^",2)
    ...s icuoNote=$p($g(^DHCICUOrder(icuoId)),"^",10)
    ...s icuoQty=+$p($g(^DHCICUOrder(icuoId)),"^",11)
    ...;i (icuoQty<1)&&($p(icuoQty,".",1)'=0) s icuoQty="0"_icuoQty    //小于0且个位数为空时，加0
    ...i (icuoQty>0)&(icuoQty<1) s icuoQty=$fn(icuoQty,"",$l($p(icuoQty,".",2)))
    ...;b //ccq
    ...s ICUOICUPIDr=$p($g(^DHCICUOrder(icuoId)),"^",38)
    ...q:(ICUOICUPIDr="")
    ...q:$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1))),"^",1)'=icuaId	///不是该病人对应个人模板的数据过滤 ly 20210910
    ...;w ICUOICUPIDr,!
    ...;q:((ICUOICUPIDr="")&&((ICUOViewCat'="215")&&(ICUOViewCat'="218")))
    ...
    ...q:(ICUOICUPIDr'="")&&($p(ICUOICUPIDr,"||",1)'="")&&($p(ICUOICUPIDr,"||",2)'="")&&($p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",20)="N") //已删除医嘱不加载
	...///ly 20210506 注释了不取子项的q
	...q:(($p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",19)'="")&&((ICUOViewCat=251)||(ICUOViewCat=252)))  //不取子项
	...
	...q:$d(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2)))<1	///模板项目不存在则过滤 ly20210420
	...
	...s paraDesc=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",14)
	...;s paraDescAbbreviation=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",21)	///ly20210501	简称
	...s icuoDataType=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",24)
	...;w !,icuoComOrdDr_"^"_icuoDataType_"^"_icucriCode_"^"_icuoQty_"^"_icuoNote
	...i (icuoQty>0)&(icuoQty<1) s icuoQty=$fn(icuoQty,"",$l($p(icuoQty,".",2)))
	...i "Qty,Volume"[icuoDataType s icuoValue=icuoQty
	...s:(icuoComOrdDr=9161)&(icuoQty=0) icuoValue=+$p($g(^DHCICUOrder(icuoId)),"^",28)		// 港大输血自定义医嘱入量保存在Volume字段了。
	...i icuoDataType="Note" s icuoValue=icuoNote
	...i "IntravenousInfusion^Injection^ContinuousInjectionPumps^XZP^Oral,NasalFeedingPumping"[$p($g(^DHCICUC("ViewCat",ICUOViewCat)),"^",1) d
	....s icuoValue=+icuoValue
	....s icuoValue=$fn(icuoValue,"",$l($p(icuoValue,".",2)))
	...s ^TMPDHCICU("GetPrintDataChar",+icuaId,ICUOViewCat,ICUOICUPIDr,icuoComOrdDr,paraDesc,curDate,icuoSttTime,icuoId)=icuoValue_"^"_icuoUserDesc_"^"_icucriCode
	...;s ^TMPDHCICU("GetPrintDataChar",+icuaId,ICUOViewCat,ICUOICUPIDr,icuoComOrdDr,paraDesc_"@"_paraDescAbbreviation,curDate,icuoSttTime,icuoId)=icuoValue_"^"_icuoUserDesc_"^"_icucriCode
    ...;s ^TMPDHCICU("GetPrintDataCharOther",icuaId,curDate,icuoSttTime,icuoId)=paraDesc_":"_icuoValue_"^"_icucriCode
    
    ;最新执行医嘱获取
    d ..GetOrderItemList(icuaId,$zd(date,3)_" "_$zt(sttime,2),$zd(date+1,3)_" "_$zt(endtime,2))
    s orRowId=""
    f  s orRowId=$o(^TMPICUPrint("GetPrintDataChar",icuaId,orRowId)) q:orRowId=""  d
    .s orStDate=""
    .f  s orStDate=$o(^TMPICUPrint("GetPrintDataChar",icuaId,orRowId,orStDate)) q:orStDate=""  d
    ..s orStTime=""
    ..f  s orStTime=$o(^TMPICUPrint("GetPrintDataChar",icuaId,orRowId,orStDate,orStTime)) q:orStTime=""  d
    ...s orDesc=$list(^TMPICUPrint("GetPrintDataChar",icuaId,orRowId,orStDate,orStTime),1)
    ...s orViewCat=$list(^TMPICUPrint("GetPrintDataChar",icuaId,orRowId,orStDate,orStTime),2)
    ...s orVolume=$list(^TMPICUPrint("GetPrintDataChar",icuaId,orRowId,orStDate,orStTime),3)
    ...if ((orVolume<1)&&($p(orVolume,".",1)="")) s orVolume="0"_orVolume						///20211126 NICU小于1不显示小数点处理ly
    ...;s orUserDesc=$list(^TMPICUPrint("GetPrintDataChar",icuaId,orRowId,orStDate,orStTime),4)
    ...;s orAuditUser=$list(^TMPICUPrint("GetPrintDataChar",icuaId,orRowId,orStDate,orStTime),5)
    ...s orCodeId=$list(^TMPICUPrint("GetPrintDataChar",icuaId,orRowId,orStDate,orStTime),6)
    ...s orCode=$p($g(^DHCICUC("RecordItem",orCodeId)),"^",1)
    ...s icuoId="or"_orRowId
    ...;w !,orCodeId_"^"_orCode
    ...s ^TMPDHCICU("GetPrintDataChar",+icuaId,orViewCat,"orderList","orderList",orDesc,orStDate,orStTime,icuoId)=orVolume_"^"_""_"^"_orCode
    
    
    ;i icuoUserStr'="" s ^TMPDHCICU("GetPrintDataCharOther",icuaId,date+1,25140,"ZQM")="护士"_":"_icuoUserStr_"   "_"审核人"

    s viewCatDr="" f  s viewCatDr=$o(^TMPDHCICU("GetPrintDataChar",icuaId,viewCatDr)) q:viewCatDr=""  d
    .s icupDr="" f  s icupDr=$o(^TMPDHCICU("GetPrintDataChar",icuaId,viewCatDr,icupDr)) q:icupDr=""  d
    ..s icucViewCat=$p($g(^DHCICUC("ViewCat",viewCatDr)),"^",1)
    ..s icucDr="" f  s icucDr=$o(^TMPDHCICU("GetPrintDataChar",icuaId,viewCatDr,icupDr,icucDr)) q:icucDr=""  d
    ...s paraName="" f  s paraName=$o(^TMPDHCICU("GetPrintDataChar",icuaId,viewCatDr,icupDr,icucDr,paraName)) q:paraName=""  d
    ....s DataStr="",userStr=""
    ....s icucdate="" f  s icucdate=$o(^TMPDHCICU("GetPrintDataChar",icuaId,viewCatDr,icupDr,icucDr,paraName,icucdate)) q:icucdate=""  d
    .....s icuctime="" f  s icuctime=$o(^TMPDHCICU("GetPrintDataChar",icuaId,viewCatDr,icupDr,icucDr,paraName,icucdate,icuctime)) q:icuctime=""  d
    ......s icucId="" f  s icucId=$o(^TMPDHCICU("GetPrintDataChar",icuaId,viewCatDr,icupDr,icucDr,paraName,icucdate,icuctime,icucId)) q:icucId=""  d
    .......s ret=""
    .......s icucValue=$p($g(^TMPDHCICU("GetPrintDataChar",icuaId,viewCatDr,icupDr,icucDr,paraName,icucdate,icuctime,icucId)),"^",1)
    
    .......q:icucValue=""
    .......s icucValue=$replace(icucValue,";",",")
    .......;i ((icucDr=9160)||(icucDr=7916)) s icucValue=icucValue
    .......;else   s icucValue=$replace(icucValue,"/",",")
    .......s icucUser=$p($g(^TMPDHCICU("GetPrintDataChar",icuaId,viewCatDr,icupDr,icucDr,paraName,icucdate,icuctime,icucId)),"^",2)
    .......i icucUser'="" s icucUser=$zd(icucdate,3)_" "_$zt(icuctime,2)_"^"_icucUser
    .......s icucCode=$p($g(^TMPDHCICU("GetPrintDataChar",icuaId,viewCatDr,icupDr,icucDr,paraName,icucdate,icuctime,icucId)),"^",3)
    .......i userStr="" s userStr=icucUser
    .......e  i icucUser'="" s userStr=userStr_","_icucUser
    .......s ret=$zd(icucdate,3)_" "_$zt(icuctime,2)_"^"_icucValue
    .......i DataStr="" s DataStr=ret
    .......e  s DataStr=DataStr_";"_ret
    .......;w !,icucId
    ....;s Data=$lb("签名",userStr)
    ....;Do GetPrintDataChar
    ....;q:icucriDesc'="ABP(mmHg)"
    ....s Data=$lb(icucViewCat,paraName,icupDr,icucCode,"",DataStr,userStr)
    ....Do GetPrintDataCharYC
	
	s odate="" f  s odate=$o(^TMPDHCICU("GetPrintDataCharOther",icuaId,odate)) q:odate=""  d
	.s otime="" f  s otime=$o(^TMPDHCICU("GetPrintDataCharOther",icuaId,odate,otime)) q:otime=""  d
	..s DataStr=""
	..s icuoid="" f  s icuoid=$o(^TMPDHCICU("GetPrintDataCharOther",icuaId,odate,otime,icuoid)) q:icuoid=""  d
	...s icuov=$g(^TMPDHCICU("GetPrintDataCharOther",icuaId,odate,otime,icuoid))
	...q:icuov=""
	...s icuov=$replace(icuov,";",",")
	...;s icuov=$replace(icuov,"/",",")
	...i DataStr="" s DataStr=icuov
	...e  s DataStr=DataStr_";"_icuov
	..s dateTime=$zd(odate,3)_" "_$zt(otime,2)
	..s Data=$lb("","","","",dateTime,DataStr,"")
    ..Do GetPrintDataCharYC

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK


GetPrintDataCharYC
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetPrintDataCharYCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintDataCharYCExecute ]
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

ClassMethod GetPrintDataCharYCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintDataCharYCExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 获取病人打印生命体征记录单数据
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintDataCharYCNew","14","2020/7/27","VitalSign^ContinuousInjectionPumps^IntravenousInfusion^NasalFeedingPumping^Injection^NursingRecordItems^ICUCareEvaluateItem^DrugIntake")
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","GetPrintDataCharYCNew","3","2021/4/19","VitalSign^RespiratorySupport^Oral^ContinuousInjectionPumps^IntravenousInfusion^NasalFeedingPumping^Injection^CRRT^DrugIntake^NursingRecordItems^Pipe^ICUCareEvaluateItem")
Query GetPrintDataCharYCNew(icuaId, date, ViewCatStr) As %Query(ROWSPEC = "icucViewCat,icucDesc,icupDr,icucDr,dateTime,DataStr,user,paraNameAbbrev") [ SqlProc ]
{
}

ClassMethod GetPrintDataCharYCNewExecute(ByRef qHandle As %Binary, icuaId, date, ViewCatStr) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^TMPDHCICU("GetPrintDataChar")
	k ^TMPDHCICU("GetPrintDataCharOther")
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	s sttime=##class(web.DHCClinicCom).ConvertToTimeH("8:00")
	s endtime=##class(web.DHCClinicCom).ConvertToTimeH("7:59")
	
	s icuoUserStr=""
	f curDate=date:1:(date+1) d
	.s icuoSttTime=""
	.f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
	..;w !,curDate_"^"_icuoSttTime
	..q:(curDate=date)&&(icuoSttTime<sttime)    //早于开始时间
	..q:(curDate=(date+1))&&(icuoSttTime>endtime)    //晚于开始时间
	..s inoutId="",inoutValue="",inoutVC="",inoutUser="",inoutDesc=""
	..f  s inoutId=$o(^DHCICUOrder("ICUInOut",icuaId,curDate,icuoSttTime,inoutId)) q:inoutId=""  d
	...s inoutValue=$p($g(^DHCICUOrder("ICUInOut",icuaId,curDate,icuoSttTime,inoutId)),"^",1)
	...s inoutUserId=$p($g(^DHCICUOrder("ICUInOut",icuaId,curDate,icuoSttTime,inoutId)),"^",2)
	...i inoutUserId'="" s inoutUser=$p($g(^SSU("SSUSR",inoutUserId)),"^",2)
	...s inoutCode=$p($g(^DHCICUC("RecordItem",inoutId)),"^",1)
	...s inoutDesc=$p($g(^DHCICUC("RecordItem",inoutId)),"^",2)
	...s inoutVC=$p($g(^DHCICUC("RecordItem",inoutId)),"^",5)
	...i inoutValue'="" s ^TMPDHCICU("GetPrintDataChar",icuaId,inoutVC,"InOut",inoutId,inoutDesc,curDate,icuoSttTime,"InOut")=inoutValue_"^"_inoutUser
	...;s inout=inoutCode_"#"_inoutId_"#"_inoutValue
	...;i inoutStr="" s inoutStr=inout
	...;e  s inoutStr=inoutStr_";"_inout
	..s icuoId=""
	..f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
	...q:$d(^DHCICUOrder(icuoId))<1
	...s icuoOrderStr="",icuoValue="",icucriCode="",icuoComOrdDr=""
	...s orderEditFlag=$p($g(^DHCICUOrder(icuoId)),"^",25)
	...q:((orderEditFlag="C")||(orderEditFlag=""))
	...;w !,icuoId
	...s icuoComOrdDr=$p($g(^DHCICUOrder(icuoId)),"^",2)
    ...q:icuoComOrdDr=""
    ...s ICUOViewCat=$p($g(^DHCICUOrder(icuoId)),"^",16)
    ...q:ICUOViewCat=""
    ...q:(ViewCatStr'="")&&(ViewCatStr'[$p($g(^DHCICUC("ViewCat",ICUOViewCat)),"^",1))
    ...s icucViewCat=$p($g(^DHCICUC("ViewCat",ICUOViewCat)),"^",2)
	...s icucriCode=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",1)
	...s icuoUserDr=$p($g(^DHCICUOrder(icuoId)),"^",4)
	...i icuoUserDr'="" s icuoUserDesc=$p($g(^SSU("SSUSR",icuoUserDr)),"^",2)
	...i icuoUserStr'[icuoUserDesc d
	....i icuoUserStr="" s icuoUserStr=icuoUserDesc
	....e  s icuoUserStr=icuoUserStr_"  "_icuoUserDesc
	...s OtherDesc=$p($g(^DHCICUOrder(icuoId,"OtherUser")),"^",2)
    ...s icuoNote=$p($g(^DHCICUOrder(icuoId)),"^",10)
    ...s icuoQty=+$p($g(^DHCICUOrder(icuoId)),"^",11)
    ...s ICUOICUPIDr=$p($g(^DHCICUOrder(icuoId)),"^",38)
    ...q:ICUOICUPIDr=""
    ...q:(ICUOICUPIDr'="")&&($p(ICUOICUPIDr,"||",1)'="")&&($p(ICUOICUPIDr,"||",2)'="")&&($p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",20)="N") //已删除医嘱不加载
	...q:$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",19)'=""  //不取子项
	...q:$d(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2)))<1	///模板项目不存在则过滤 ly20210420
	...s paraDesc=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",14)
	...s paraDescAbbreviation=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",21)
	...s icuoDataType=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",24)
	...;w !,icuoComOrdDr_"^"_icuoDataType_"^"_icucriCode_"^"_icuoQty_"^"_icuoNote
	...i "Qty,Volume"[icuoDataType s icuoValue=icuoQty
	...i icuoDataType="Note" s icuoValue=icuoNote
	...i "IntravenousInfusion^Injection^ContinuousInjectionPumps^XZP^Oral,NasalFeedingPumping"[$p($g(^DHCICUC("ViewCat",ICUOViewCat)),"^",1) s icuoValue=+icuoValue
	...;s ^TMPDHCICU("GetPrintDataChar",+icuaId,ICUOViewCat,ICUOICUPIDr,icuoComOrdDr,paraDesc,curDate,icuoSttTime,icuoId)=icuoValue_"^"_icuoUserDesc_"^"_icucriCode
	...s ^TMPDHCICU("GetPrintDataChar",+icuaId,ICUOViewCat,ICUOICUPIDr,icuoComOrdDr,paraDesc,"_"_paraDescAbbreviation,curDate,icuoSttTime,icuoId)=icuoValue_"^"_icuoUserDesc_"^"_icucriCode
    ...;s ^TMPDHCICU("GetPrintDataCharOther",icuaId,curDate,icuoSttTime,icuoId)=paraDesc_":"_icuoValue_"^"_icucriCode
    
    ;i icuoUserStr'="" s ^TMPDHCICU("GetPrintDataCharOther",icuaId,date+1,25140,"ZQM")="护士"_":"_icuoUserStr_"   "_"审核人"

    s viewCatDr="" f  s viewCatDr=$o(^TMPDHCICU("GetPrintDataChar",icuaId,viewCatDr)) q:viewCatDr=""  d
    .s icupDr="" f  s icupDr=$o(^TMPDHCICU("GetPrintDataChar",icuaId,viewCatDr,icupDr)) q:icupDr=""  d
    ..s icucViewCat=$p($g(^DHCICUC("ViewCat",viewCatDr)),"^",1)
    ..s icucDr="" f  s icucDr=$o(^TMPDHCICU("GetPrintDataChar",icuaId,viewCatDr,icupDr,icucDr)) q:icucDr=""  d
    ...s paraName="" f  s paraName=$o(^TMPDHCICU("GetPrintDataChar",icuaId,viewCatDr,icupDr,icucDr,paraName)) q:paraName=""  d
    ....s paraNameAbbrev="" f  s paraNameAbbrev=$o(^TMPDHCICU("GetPrintDataChar",icuaId,viewCatDr,icupDr,icucDr,paraName,"_"_paraNameAbbrev)) q:"_"_paraNameAbbrev=""  d
    .....s DataStr="",userStr=""
    .....s icucdate="" f  s icucdate=$o(^TMPDHCICU("GetPrintDataChar",icuaId,viewCatDr,icupDr,icucDr,paraName,icucdate)) q:icucdate=""  d
    ......s icuctime="" f  s icuctime=$o(^TMPDHCICU("GetPrintDataChar",icuaId,viewCatDr,icupDr,icucDr,paraName,icucdate,icuctime)) q:icuctime=""  d
    .......s icucId="" f  s icucId=$o(^TMPDHCICU("GetPrintDataChar",icuaId,viewCatDr,icupDr,icucDr,paraName,icucdate,icuctime,icucId)) q:icucId=""  d
    ........s ret=""
    ........s icucValue=$p($g(^TMPDHCICU("GetPrintDataChar",icuaId,viewCatDr,icupDr,icucDr,paraName,icucdate,icuctime,icucId)),"^",1)
    ........q:icucValue=""
    ........s icucValue=$replace(icucValue,";",",")
    ........s icucValue=$replace(icucValue,"/",",")
    ........s icucUser=$p($g(^TMPDHCICU("GetPrintDataChar",icuaId,viewCatDr,icupDr,icucDr,paraName,icucdate,icuctime,icucId)),"^",2)
    ........i icucUser'="" s icucUser=$zd(icucdate,3)_" "_$zt(icuctime,2)_"^"_icucUser
    ........s icucCode=$p($g(^TMPDHCICU("GetPrintDataChar",icuaId,viewCatDr,icupDr,icucDr,paraName,icucdate,icuctime,icucId)),"^",3)
    ........i userStr="" s userStr=icucUser
    ........e  i icucUser'="" s userStr=userStr_","_icucUser
    ........s ret=$zd(icucdate,3)_" "_$zt(icuctime,2)_"^"_icucValue
    ........i DataStr="" s DataStr=ret
    ........e  s DataStr=DataStr_";"_ret
    .....;s Data=$lb("签名",userStr)
    .....;Do GetPrintDataChar
    .....;q:icucriDesc'="ABP(mmHg)"
    .....s Data=$lb(icucViewCat,paraName,icupDr,icucCode,"",DataStr,userStr,paraNameAbbrev)
    .....Do GetPrintDataCharYCNew
	
	s odate="" f  s odate=$o(^TMPDHCICU("GetPrintDataCharOther",icuaId,odate)) q:odate=""  d
	.s otime="" f  s otime=$o(^TMPDHCICU("GetPrintDataCharOther",icuaId,odate,otime)) q:otime=""  d
	..s DataStr=""
	..s icuoid="" f  s icuoid=$o(^TMPDHCICU("GetPrintDataCharOther",icuaId,odate,otime,icuoid)) q:icuoid=""  d
	...s icuov=$g(^TMPDHCICU("GetPrintDataCharOther",icuaId,odate,otime,icuoid))
	...q:icuov=""
	...s icuov=$replace(icuov,";",",")
	...s icuov=$replace(icuov,"/",",")
	...i DataStr="" s DataStr=icuov
	...e  s DataStr=DataStr_";"_icuov
	..s dateTime=$zd(odate,3)_" "_$zt(otime,2)
	..s Data=$lb("","","","",dateTime,DataStr,"","")
    ..Do GetPrintDataCharYCNew

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK


GetPrintDataCharYCNew
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetPrintDataCharYCNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintDataCharYCNewExecute ]
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

ClassMethod GetPrintDataCharYCNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintDataCharYCNewExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetPrintPages(icuaId As %String) As %String
{
	q:(icuaId="")
	s Pages=0
	s Pages=$g(^DHCICUArrange(icuaId,"PrintPages"))
    
    q Pages
}

/// w ##class(web.DHCICUOrder).GetOrderNum("128","403||1||31")
ClassMethod GetOrderNum(icuaId, oeoreId) As %String
{
	q:icuaId="" -1
	q:oeoreId="" -1
	s orderId=0,count=0
	f  s orderId=$o(^DHCICUOrder(0,"OEORE",oeoreId,icuaId,orderId)) q:orderId=""  d
	.i $p(^DHCICUOrder(orderId),"^",25)="N" d
	..s count=count+1
	q count
}

/// 获取项目汇总量
/// w ##class(web.DHCICUOrder).GetSumQty("3","XiaoBian01","2021-08-08","09:00")
ClassMethod GetSumQty(icuaId As %String, code As %String, date As %String, time As %String, ctloc As %String = "") As %String
{
	q:icuaId="" 0
	s startTime=28800	///默认8点
	if ((ctloc=210)||(ctloc=234)||(ctloc=278)||(ctloc=1220)) 
	{
		s startTime=25200	///icu科室默认是7点
	}
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	s sumQty=0
	s comId=""
	s comId=$o(^DHCICUC("RecordItem",0,"Code",code,""))
	b ;1
	s icuoId=""
	f  s icuoId=$o(^DHCICUOrder(0,"CommOrd",comId,icuaId,icuoId)) q:icuoId=""  d
	.s icuoStartDate=$p($g(^DHCICUOrder(icuoId)),"^",5)
	.s icuoStartTime=$p($g(^DHCICUOrder(icuoId)),"^",6)
	.;q:(icuoStartDate>date)||((icuoStartDate=date)&&(icuoStartTime>time))
	.///	小于当前日期				当前日期八点前和time后排除												下一天，超过time的除外				
	.q:(icuoStartDate<date)||((icuoStartDate=date)&&((icuoStartTime>time)||(icuoStartTime<startTime)))||((icuoStartDate=(date+1))&&(icuoStartTime>time))
	.s orderEditFlag=$p($g(^DHCICUOrder(icuoId)),"^",25)
	.q:"CD"[orderEditFlag
	.s ICUOICUPIDr=$p($g(^DHCICUOrder(icuoId)),"^",38)
    .q:ICUOICUPIDr=""
    .q:(ICUOICUPIDr'="")&&($p(ICUOICUPIDr,"||",1)'="")&&($p(ICUOICUPIDr,"||",2)'="")&&($p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",20)="N") //已删除医嘱不加载
    .s icuoDataType=$p($g(^DHCICUC("RecordItem",comId)),"^",24)
    .q:icuoDataType'="Qty"
    .s icuoQty=+$p($g(^DHCICUOrder(icuoId)),"^",11)
    .s sumQty=sumQty+icuoQty
    ;if sumQty'=0  d
    ;.if $l(sumQty,".")>1  d
    ;..s sumQty=$fn(sumQty,"",1)
    ;.e  s sumQty=sumQty
    q sumQty
}

/// 获取导管内容
/// w ##Class(web.DHCICUOrder).GetDGStr(12,"2021-08-10")
ClassMethod GetDGStr(icuaId As %String, date As %String) As %String
{
	k ^TMPGetDGStr
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	s sttime=##class(web.DHCClinicCom).ConvertToTimeH("8:00")
	s endtime=##class(web.DHCClinicCom).ConvertToTimeH("7:59")
	s icuoUserStr=""
	f curDate=date:1:(date+1) d
	.s icuoSttTime=""
	.f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
	..;w !,curDate_"^"_icuoSttTime
	..q:(curDate=date)&&(icuoSttTime<sttime)    //早于开始时间
	..q:(curDate=(date+1))&&(icuoSttTime>endtime)    //晚于开始时间
	..s icuoId=""
	..f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
	...q:$d(^DHCICUOrder(icuoId))<1
	...s icuoOrderStr="",icuoValue="",icucriCode="",icuoComOrdDr=""
	...s orderEditFlag=$p($g(^DHCICUOrder(icuoId)),"^",25)
	...q:orderEditFlag="C"
	...;w !,icuoId
	...s icuoComOrdDr=$p($g(^DHCICUOrder(icuoId)),"^",2)
    ...q:icuoComOrdDr=""
    ...q:((icuoComOrdDr=5956)||(icuoComOrdDr=6059)||(icuoComOrdDr=5602)||(icuoComOrdDr=5964)||(icuoComOrdDr=6354)||(icuoComOrdDr=6538)||(icuoComOrdDr=6795))	///ly20210512
    ...s ICUOViewCat=$p($g(^DHCICUOrder(icuoId)),"^",16)
    ...q:(ICUOViewCat'="236")&&(ICUOViewCat'="235")   //导管
    ...s ICUOICUPIDr=$p($g(^DHCICUOrder(icuoId)),"^",38)
    ...q:ICUOICUPIDr=""
    ...q:(ICUOICUPIDr'="")&&($p(ICUOICUPIDr,"||",1)'="")&&($p(ICUOICUPIDr,"||",2)'="")&&($p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",20)="N") //已删除医嘱不加载
	...s icupiSeqNo=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",8)  //排序号
	...;q:$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",19)'=""  //不取子项
	...s paraDesc=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",14)
	...
	...s icuoNote=$p($g(^DHCICUOrder(icuoId)),"^",10)
    ...s icuoQty=+$p($g(^DHCICUOrder(icuoId)),"^",11)
    ...s icuoDataType=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",24)
	...i "Qty,Volume"[icuoDataType s icuoValue=icuoQty
	...i icuoDataType="Note" s icuoValue=icuoNote
	...s mainPidr=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",19)  //主项模板ID
	...i mainPidr=""  d //主项
	....s ^TMPGetDGStr(ICUOICUPIDr)=paraDesc
	...e  d  //子项
	....s ^TMPGetDGStr(mainPidr,ICUOICUPIDr,icupiSeqNo)=paraDesc_":"_icuoValue
	
	s DGStr=""
	
	s i=0
	s mainId="" f  s mainId=$o(^TMPGetDGStr(mainId)) q:mainId=""  d
	.q:$g(^TMPGetDGStr(mainId))=""
	.s i=i+1
	.s DGDetail=i_"."_$g(^TMPGetDGStr(mainId))
	.s chlId="" f  s chlId=$o(^TMPGetDGStr(mainId,chlId)) q:chlId=""  d
	..s no="" f  s no=$o(^TMPGetDGStr(mainId,chlId,no)) q:no=""  d
	...s DGDetail=DGDetail_$c(3)_$g(^TMPGetDGStr(mainId,chlId,no))
	.i DGStr="" s DGStr=DGDetail
	.e  s DGStr=DGStr_$c(3)_DGDetail
	
	;b //1
	q DGStr
}

/// w ##class(web.DHCICUOrder).GetICUDGOrderIdStr(80,"2021-08-16","369,370")
/// w ##class(web.DHCICUOrder).GetICUDGOrderIdStr(161,"2021-08-23","369,370")
/// w ##class(web.DHCICUOrder).GetICUDGOrderIdStr(65,"2021-08-23","369,370")
ClassMethod GetICUDGOrderIdStr(icuaId As %String, date As %String, viewCatStr As %String, baseTime As %String = "07:00") As %String
{
	quit:(icuaId="")!(date="")!(viewCatStr="")!(baseTime="") ""
	set printStartDateH=+##class(web.DHCClinicCom).ConvertToDateH(date,"")
	set printStartTimeH=+##class(web.DHCClinicCom).ConvertToTimeH(baseTime,"")
	set printStartDTH=printStartDateH+(printStartTimeH/100000)
	set printEndDTH=printStartDateH+1+((printStartTimeH-1)/100000)
	&sql(declare ICUDGCursor cursor for select 
		 ICUO_RowId,ICUO_StartDate,ICUO_StartTime,ICUO_EndDate,ICUO_EndTime,ICUO_ComOrd_Dr->ICUCRI_Desc,
		 ICUO_ICUPI_Dr,ICUO_ICUPI_Dr->ICUPI_ICUPI_Dr,ICUO_Note 
		 into :rowId,:startDate,:startTime,:endDate,:endTime,:recordItemDesc,:paraItemId,:mainParaItemId,:note
		 from SQLUser.DHC_ICU_Order
		 where ICUO_ICUA_Dr=:icuaId
		 and (","_:viewCatStr_"," [ STRING(",",ICUO_ViewCat_dr,","))
		 and ICUO_EditFlag in ('N','E'))	
	&sql(open ICUDGCursor)
	set result=""
	k ^TMPTube($j)
	k ^TMPTubeDate($j)
	for
	{
		&sql(fetch ICUDGCursor)
		quit:(SQLCODE'=0)
		set startDTH=startDate+(startTime/100000)
		//b:mainParaItemId="223||10232"
		if (mainParaItemId'="")
		{
			set ^TMPTube($j,mainParaItemId,startDTH,rowId)=$lb(recordItemDesc,note)	
		}
		else
		{
			continue:paraItemId=""
			set ^TMPTube($j,paraItemId,startDTH,rowId)=$lb(recordItemDesc,note)
		}
		//b:(rowId=242468) //ccq
		/*if ("^置管日期^置管时间^带入时间^带入日期^尿管插管日期^" [ ("^"_recordItemDesc_"^"))
		{
			;set existsStartDTH=$$GetIntubeDTH(mainParaItemId)
			;continue:(+existsStartDTH>0)&(startDTH>existsStartDTH)	// 如果已经存在置管时间，那么取最早的置管时间
			set curIntubeDate=$p(note," ",1),curIntubeTime=$p(note," ",2)
			set curIntubeDateH=+##class(web.DHCClinicCom).ConvertToDateH(curIntubeDate,"")
			set curIntubeTimeH=+##class(web.DHCClinicCom).ConvertToTimeH(curIntubeTime,"")
			continue:(curIntubeDateH=0)
			set curIntubeDTH=curIntubeDateH+(curIntubeTimeH/100000)
			set ^TMPTubeDate($j,mainParaItemId,curIntubeDTH,"I")=$lb(rowId,note)
		}
		
		if ("^拔管日期^拔管时间^" [ ("^"_recordItemDesc_"^"))
		{
			set curOuttubeDate=$p(note," ",1),curOuttubeTime=$p(note," ",2)
			set curOuttubeDateH=+##class(web.DHCClinicCom).ConvertToDateH(curOuttubeDate,"")
			set curOuttubeTimeH=+##class(web.DHCClinicCom).ConvertToTimeH(curOuttubeTime,"")
			continue:(curOuttubeDateH=0)
			set curOuttubeDTH=curOuttubeDateH+(curOuttubeTimeH/100000)
			set ^TMPTubeDate($j,mainParaItemId,curOuttubeDTH,"O")=$lb(rowId,note)	
		}*/
		
		b:(mainParaItemId="223||10226")&((recordItemDesc="拔管日期")) //ccq
		set:(recordItemDesc="置管日期") ^TMPTubeDate($j,mainParaItemId,startDTH,"I")=$lb(rowId,note)
		set:(recordItemDesc="拔管日期") ^TMPTubeDate($j,mainParaItemId,startDTH,"O")=$lb(rowId,note)
		set:(recordItemDesc="置管时间") ^TMPTubeDate($j,mainParaItemId,startDTH,"I")=$lb(rowId,note)
		set:(recordItemDesc="拔管时间") ^TMPTubeDate($j,mainParaItemId,startDTH,"O")=$lb(rowId,note)
		
		set:(recordItemDesc="带入时间") ^TMPTubeDate($j,mainParaItemId,startDTH,"I")=$lb(rowId,note)
		set:(recordItemDesc="带入日期") ^TMPTubeDate($j,mainParaItemId,startDTH,"I")=$lb(rowId,note)
		
		set:(recordItemDesc="尿管插管日期") ^TMPTubeDate($j,mainParaItemId,startDTH,"I")=$lb(rowId,note)
	}
	&sql(close ICUDGCursor)
	//b //ccq2
	set icuoRowId=0,paraItemIndex=""
	//b //ccq
	for
	{
		set paraItemIndex=$o(^TMPTubeDate($j,paraItemIndex))
		quit:(paraItemIndex="")
		set dateTimeIndex=0
		for
		{
			set dateTimeIndex=$o(^TMPTubeDate($j,paraItemIndex,dateTimeIndex))
			quit:(dateTimeIndex="")
			continue:('$d(^TMPTubeDate($j,paraItemIndex,dateTimeIndex,"I")))
			
			
			
			set tubeInDateInfo=^TMPTubeDate($j,paraItemIndex,dateTimeIndex,"I")
			set tubeInDT=$lg(tubeInDateInfo,2)
			set tubeInDateH=+##class(web.DHCClinicCom).ConvertToDateH($p(tubeInDT," ",1),"")
			set tubeInTimeH=+##class(web.DHCClinicCom).ConvertToTimeH($p(tubeInDT," ",2),"")
			set tubeInDTH=tubeInDateH+(tubeInTimeH/100000)
			continue:(tubeInDTH>printEndDTH)
			//b:(paraItemIndex="254||10286") //ccq4
			set tubeOutInfo=$$GetTubeOutInfo(paraItemIndex,dateTimeIndex)
			b:(paraItemIndex="223||10226") //tubeoutInfo
			set tubeOutDT=$lg(tubeOutInfo,2)
			set tubeOutRowId=$lg(tubeOutInfo,1)
			if (tubeOutDT'="")
			{
				//b:(paraItemIndex="254||10286") //ccq7
				set tubeOutDateH=+##class(web.DHCClinicCom).ConvertToDateH($p(tubeOutDT," ",1),"")
				set tubeOutTimeH=+##class(web.DHCClinicCom).ConvertToTimeH($p(tubeOutDT," ",2),"")
				set tubeOutDTH=tubeOutDateH+(tubeOutTimeH/100000)
				b:(paraItemIndex="223||10226") //tubeout
				continue:(tubeOutDTH<printStartDTH)
				b:(paraItemIndex="223||10226") //tubeout2
				//b:(paraItemIndex="254||10286") //ccq8
			}
			set icuoRowId=0
			//b:paraItemIndex="223||10232" 
			/*set curDateTimeIndex=dateTimeIndex-0.00001
			for
			{
				set curDateTimeIndex=$o(^TMPTube($j,paraItemIndex,curDateTimeIndex))
				quit:(curDateTimeIndex="")
				for
				{
					set icuoRowId=$o(^TMPTube($j,paraItemIndex,curDateTimeIndex,icuoRowId))
					quit:(icuoRowId="")
					set:(result'="") result=result_"^"
					//b:(paraItemIndex="254||10286") //ccq9
					set result=result_icuoRowId	
				}
					
			}*/
			for
			{
				set icuoRowId=$o(^TMPTube($j,paraItemIndex,dateTimeIndex,icuoRowId))
				quit:(icuoRowId="")
				set:(result'="") result=result_"^"
				//b:(paraItemIndex="254||10286") //ccq9
				set result=result_icuoRowId	
			}
			set:($g(tubeOutDTH)>=printStartDTH)&($g(tubeOutDateH)=printStartDateH)&(tubeOutRowId'="") result=result_"^"_tubeOutRowId
		}	
	}
	
	quit result

GetTubeOutInfo(tubeInMainParaItemId,tubeInDateTimeH)
	set tubeOutDateTimeH=tubeInDateTimeH,tubeOutStr=""
	for
	{
		set tubeOutDateTimeH=$o(^TMPTubeDate($j,tubeInMainParaItemId,tubeOutDateTimeH))
		quit:(tubeOutDateTimeH="")!(tubeOutStr'="")
		//b:(paraItemIndex="254||10286") //ccq5
		if ($d(^TMPTubeDate($j,tubeInMainParaItemId,tubeOutDateTimeH,"O")))
		{
			set tubeOutStr=^TMPTubeDate($j,tubeInMainParaItemId,tubeOutDateTimeH,"O")	
		}	
	}
	quit tubeOutStr
GetIntubeDTH(tubeInMainParaItemId)
	set intubeDTH="",tubeDTH=0
	for
	{
		set tubeDTH=$o(^TMPTubeDate($j,mainParaItemId,tubeDTH))	
		quit:(tubeDTH="")!(intubeDTH'="")
		set:($d(^TMPTubeDate($j,mainParaItemId,tubeDTH,"I"))) intubeDTH=tubeDTH
	}
	quit intubeDTH
}

/// 获取导管内容ICU
/// w ##Class(web.DHCICUOrder).GetDGStrICUNew(80,"2021-08-16","369,370","07:00")
/// w ##Class(web.DHCICUOrder).GetDGStrICUNew(115,"2021-08-18","374","08:00")
/// w ##Class(web.DHCICUOrder).GetDGStrICUNew(31,"2021-08-23","374","08:00",558)
/// w ##Class(web.DHCICUOrder).GetDGStrICUNew(12,"2021-08-23","374","08:00",236)
/// w ##Class(web.DHCICUOrder).GetDGStrICUNew(65,"2021-08-23","369,370","07:00",234)
ClassMethod GetDGStrICUNew(icuaId As %String, date As %String, viewCatStr As %String, baseTime As %String, ctlocId As %String = "") As %String
{
	s DGStr=""
	s DGStrNew=##class(web.DHCICUCatheterDetailICU).GetCatheterRecordByDate(icuaId,date,"07:00",ctlocId)
	if (DGStrNew'="")
	{
		s DGStr=DGStrNew
	}
	else{
		k ^TMPGetDGStr($j)
		s icuoUserStr=""
		set icuoIdStr=..GetICUDGOrderIdStr(icuaId,date,viewCatStr,baseTime)

		quit:(icuoIdStr="") ""
		for i=1:1:$l(icuoIdStr,"^")
		{
			set icuoId=$p(icuoIdStr,"^",i)
			continue:(icuoId="")
			continue:$d(^DHCICUOrder(icuoId))<1
			s icuoOrderStr="",icuoValue="",icucriCode="",icuoComOrdDr=""
			s orderEditFlag=$p($g(^DHCICUOrder(icuoId)),"^",25)
			s icuoComOrdDr=$p($g(^DHCICUOrder(icuoId)),"^",2)
			continue:(icuoComOrdDr=8003)||(icuoComOrdDr=8756)
	    	continue:icuoComOrdDr=""
	    	s ICUOViewCat=$p($g(^DHCICUOrder(icuoId)),"^",16)
	    	s ICUOICUPIDr=$p($g(^DHCICUOrder(icuoId)),"^",38)
	    	continue:ICUOICUPIDr=""
	    	continue:(ICUOICUPIDr'="")&&($p(ICUOICUPIDr,"||",1)'="")&&($p(ICUOICUPIDr,"||",2)'="")&&($p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",20)="N") //已删除医嘱不加载
			s icupiSeqNo=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",8)  //排序号
			s paraDesc=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",14)
			s icuoNote=$p($g(^DHCICUOrder(icuoId)),"^",10)
	    	s icuoQty=+$p($g(^DHCICUOrder(icuoId)),"^",11)
	    	s icuoDataType=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",24)
			i "Qty,Volume"[icuoDataType s icuoValue=icuoQty
			i icuoDataType="Note" s icuoValue=icuoNote
			s mainPidr=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",19)  //主项模板ID
			b:(mainPidr="238||10215") //ccq 
			if (mainPidr="")
			{
				s ^TMPGetDGStr($j,ICUOICUPIDr)=paraDesc
			}
			else
			{
				s ^TMPGetDGStr($j,mainPidr,ICUOICUPIDr,icupiSeqNo)=paraDesc_":"_icuoValue
			}
		}
		
		s DGStr=""
		
		s i=0
		s mainId="" f  s mainId=$o(^TMPGetDGStr($j,mainId)) q:mainId=""  d
		.;q:($g(^TMPGetDGStr($j,mainId))="")&&(viewCatStr'[374)
		.q:($g(^TMPGetDGStr($j,mainId))="")
		.s i=i+1
		.s DGDetail=i_"."_$g(^TMPGetDGStr($j,mainId))
		.s chlId="" f  s chlId=$o(^TMPGetDGStr($j,mainId,chlId)) q:chlId=""  d
		..s no="" f  s no=$o(^TMPGetDGStr($j,mainId,chlId,no)) q:no=""  d
		...s DGDetail=DGDetail_$c(3)_$g(^TMPGetDGStr($j,mainId,chlId,no))
		.i DGStr="" s DGStr=DGDetail
		.e  s DGStr=DGStr_$c(3)_DGDetail
	}	
	q DGStr
}

/// 获取导管内容ICU
/// w ##Class(web.DHCICUOrder).GetDGStrICU(20,"2021-08-11")
ClassMethod GetDGStrICU(icuaId As %String, date As %String) As %String
{
	k ^TMPGetDGStr
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	s sttime=##class(web.DHCClinicCom).ConvertToTimeH("7:00")
	s endtime=##class(web.DHCClinicCom).ConvertToTimeH("6:59")
	s icuoUserStr=""
	f curDate=date:1:(date+1) d
	.s icuoSttTime=""
	.f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
	..;w !,curDate_"^"_icuoSttTime
	..q:(curDate=date)&&(icuoSttTime<sttime)    //早于开始时间
	..q:(curDate=(date+1))&&(icuoSttTime>endtime)    //晚于开始时间
	..s icuoId=""
	..f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
	...q:$d(^DHCICUOrder(icuoId))<1
	...s icuoOrderStr="",icuoValue="",icucriCode="",icuoComOrdDr=""
	...s orderEditFlag=$p($g(^DHCICUOrder(icuoId)),"^",25)
	...q:orderEditFlag="C"
	...;w !,icuoId
	...s icuoComOrdDr=$p($g(^DHCICUOrder(icuoId)),"^",2)
    ...q:icuoComOrdDr=""
    ...;q:((icuoComOrdDr=6059)||(icuoComOrdDr=5602)||(icuoComOrdDr=5964)||(icuoComOrdDr=6354)||(icuoComOrdDr=6538)||(icuoComOrdDr=6795))	///ly20210512
    ...s ICUOViewCat=$p($g(^DHCICUOrder(icuoId)),"^",16)
    ...q:((ICUOViewCat'="369")&&(ICUOViewCat'="370"))   //导管+引流管
    ...s ICUOICUPIDr=$p($g(^DHCICUOrder(icuoId)),"^",38)
    ...q:ICUOICUPIDr=""
    ...q:(ICUOICUPIDr'="")&&($p(ICUOICUPIDr,"||",1)'="")&&($p(ICUOICUPIDr,"||",2)'="")&&($p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",20)="N") //已删除医嘱不加载
	...s icupiSeqNo=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",8)  //排序号
	...;q:$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",19)'=""  //不取子项
	...s paraDesc=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",14)
	...
	...s icuoNote=$p($g(^DHCICUOrder(icuoId)),"^",10)
    ...s icuoQty=+$p($g(^DHCICUOrder(icuoId)),"^",11)
    ...s icuoDataType=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",24)
    ...q:icuoComOrdDr=8762
	...i "Qty,Volume"[icuoDataType s icuoValue=icuoQty
	...i icuoDataType="Note" s icuoValue=icuoNote
	...s mainPidr=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",19)  //主项模板ID
	...i mainPidr=""  d //主项
	....s ^TMPGetDGStr(ICUOICUPIDr)=paraDesc
	...e  d  //子项
	....s ^TMPGetDGStr(mainPidr,ICUOICUPIDr,icupiSeqNo)=paraDesc_":"_icuoValue
	
	s DGStr=""
	
	s i=0
	s mainId="" f  s mainId=$o(^TMPGetDGStr(mainId)) q:mainId=""  d
	.q:$g(^TMPGetDGStr(mainId))=""
	.s i=i+1
	.s DGDetail=i_"."_$g(^TMPGetDGStr(mainId))
	.s chlId="" f  s chlId=$o(^TMPGetDGStr(mainId,chlId)) q:chlId=""  d
	..s no="" f  s no=$o(^TMPGetDGStr(mainId,chlId,no)) q:no=""  d
	...s DGDetail=DGDetail_$c(3)_$g(^TMPGetDGStr(mainId,chlId,no))
	.i DGStr="" s DGStr=DGDetail
	.e  s DGStr=DGStr_$c(3)_DGDetail
	
	;b //1
	q DGStr
}

/// 获取导管内容CCU
/// w ##Class(web.DHCICUOrder).GetDGStrCCU(12,"2021-08-23")
ClassMethod GetDGStrCCU(icuaId As %String, date As %String) As %String
{
	k ^TMPGetDGStr
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	s sttime=##class(web.DHCClinicCom).ConvertToTimeH("8:00")
	s endtime=##class(web.DHCClinicCom).ConvertToTimeH("7:59")
	s icuoUserStr=""
	f curDate=date:1:(date+1) d
	.s icuoSttTime=""
	.f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
	..;w !,curDate_"^"_icuoSttTime
	..q:(curDate=date)&&(icuoSttTime<sttime)    //早于开始时间
	..q:(curDate=(date+1))&&(icuoSttTime>endtime)    //晚于开始时间
	..s icuoId=""
	..f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
	...q:$d(^DHCICUOrder(icuoId))<1
	...s icuoOrderStr="",icuoValue="",icucriCode="",icuoComOrdDr=""
	...s orderEditFlag=$p($g(^DHCICUOrder(icuoId)),"^",25)
	...q:orderEditFlag="C"
	...;w !,icuoId
	...s icuoComOrdDr=$p($g(^DHCICUOrder(icuoId)),"^",2)
    ...q:icuoComOrdDr=""
    ...q:((icuoComOrdDr=5956)||(icuoComOrdDr=6059)||(icuoComOrdDr=5602)||(icuoComOrdDr=5964)||(icuoComOrdDr=6354)||(icuoComOrdDr=6538)||(icuoComOrdDr=6795))	///ly20210512
    ...s ICUOViewCat=$p($g(^DHCICUOrder(icuoId)),"^",16)
    ...q:(ICUOViewCat'="369")&&(ICUOViewCat'="370")   //导管
    ...s ICUOICUPIDr=$p($g(^DHCICUOrder(icuoId)),"^",38)
    ...q:ICUOICUPIDr=""
    ...q:(ICUOICUPIDr'="")&&($p(ICUOICUPIDr,"||",1)'="")&&($p(ICUOICUPIDr,"||",2)'="")&&($p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",20)="N") //已删除医嘱不加载
	...s icupiSeqNo=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",8)  //排序号
	...;q:$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",19)'=""  //不取子项
	...s paraDesc=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",14)
	...
	...s icuoNote=$p($g(^DHCICUOrder(icuoId)),"^",10)
    ...s icuoQty=+$p($g(^DHCICUOrder(icuoId)),"^",11)
    ...s icuoDataType=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",24)
	...i "Qty,Volume"[icuoDataType s icuoValue=icuoQty
	...i icuoDataType="Note" s icuoValue=icuoNote
	...s mainPidr=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",19)  //主项模板ID
	...i mainPidr=""  d //主项
	....s ^TMPGetDGStr(ICUOICUPIDr)=paraDesc
	...e  d  //子项
	....s ^TMPGetDGStr(mainPidr,ICUOICUPIDr,icupiSeqNo)=paraDesc_":"_icuoValue
	
	s DGStr=""
	
	s i=0
	s mainId="" f  s mainId=$o(^TMPGetDGStr(mainId)) q:mainId=""  d
	.q:$g(^TMPGetDGStr(mainId))=""
	.s i=i+1
	.s DGDetail=i_"."_$g(^TMPGetDGStr(mainId))
	.s chlId="" f  s chlId=$o(^TMPGetDGStr(mainId,chlId)) q:chlId=""  d
	..s no="" f  s no=$o(^TMPGetDGStr(mainId,chlId,no)) q:no=""  d
	...s DGDetail=DGDetail_$c(3)_$g(^TMPGetDGStr(mainId,chlId,no))
	.i DGStr="" s DGStr=DGDetail
	.e  s DGStr=DGStr_$c(3)_DGDetail
	
	q DGStr
}

/// 获取导管内容NICU
/// w ##Class(web.DHCICUOrder).GetDGStrNICU(6,"2021-05-07")
ClassMethod GetDGStrNICU(icuaId As %String, date As %String) As %String
{
	k ^TMPGetDGStr
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	s sttime=##class(web.DHCClinicCom).ConvertToTimeH("8:00")
	s endtime=##class(web.DHCClinicCom).ConvertToTimeH("7:59")
	s icuoUserStr=""
	f curDate=date:1:(date+1) d
	.s icuoSttTime=""
	.f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
	..;w !,curDate_"^"_icuoSttTime
	..q:(curDate=date)&&(icuoSttTime<sttime)    //早于开始时间
	..q:(curDate=(date+1))&&(icuoSttTime>endtime)    //晚于开始时间
	..s icuoId=""
	..f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
	...q:$d(^DHCICUOrder(icuoId))<1
	...s icuoOrderStr="",icuoValue="",icucriCode="",icuoComOrdDr=""
	...s orderEditFlag=$p($g(^DHCICUOrder(icuoId)),"^",25)
	...q:orderEditFlag="C"
	...;w !,icuoId
	...s icuoComOrdDr=$p($g(^DHCICUOrder(icuoId)),"^",2)
    ...q:icuoComOrdDr=""
    ...s ICUOViewCat=$p($g(^DHCICUOrder(icuoId)),"^",16)
    ...q:ICUOViewCat'="372"   //导管
    ...s ICUOICUPIDr=$p($g(^DHCICUOrder(icuoId)),"^",38)
    ...q:ICUOICUPIDr=""
    ...q:(ICUOICUPIDr'="")&&($p(ICUOICUPIDr,"||",1)'="")&&($p(ICUOICUPIDr,"||",2)'="")&&($p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",20)="N") //已删除医嘱不加载
	...s icupiSeqNo=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",8)  //排序号
	...;q:$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",19)'=""  //不取子项
	...s paraDesc=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",14)
	
	...s icuoNote=$p($g(^DHCICUOrder(icuoId)),"^",10)
    ...s icuoQty=+$p($g(^DHCICUOrder(icuoId)),"^",11)
    ...s icuoDataType=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",24)
	...i "Qty,Volume"[icuoDataType s icuoValue=icuoQty
	...i icuoDataType="Note" s icuoValue=icuoNote
	...s mainPidr=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",19)  //主项模板ID
	...i mainPidr=""  d //主项
	....s ^TMPGetDGStr(ICUOICUPIDr)=paraDesc
	...e  d  //子项
	....s ^TMPGetDGStr(mainPidr,ICUOICUPIDr,icupiSeqNo)=paraDesc_":"_icuoValue
	
	s DGStr=""
	
	s i=0
	s mainId="" f  s mainId=$o(^TMPGetDGStr(mainId)) q:mainId=""  d
	.q:$g(^TMPGetDGStr(mainId))=""
	.s i=i+1
	.s DGDetail=i_"."_$g(^TMPGetDGStr(mainId))
	.s chlId="" f  s chlId=$o(^TMPGetDGStr(mainId,chlId)) q:chlId=""  d
	..s no="" f  s no=$o(^TMPGetDGStr(mainId,chlId,no)) q:no=""  d
	...s DGDetail=DGDetail_$c(3)_$g(^TMPGetDGStr(mainId,chlId,no))
	.i DGStr="" s DGStr=DGDetail
	.e  s DGStr=DGStr_$c(3)_DGDetail
	
	;b //1
	q DGStr
}

/// 获取导管内容NICU
/// w ##Class(web.DHCICUOrder).GetDGStrPICU(6,"2021-05-07")
ClassMethod GetDGStrPICU(icuaId As %String, date As %String) As %String
{
	k ^TMPGetDGStr
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	s sttime=##class(web.DHCClinicCom).ConvertToTimeH("8:00")
	s endtime=##class(web.DHCClinicCom).ConvertToTimeH("7:59")
	s icuoUserStr=""
	f curDate=date:1:(date+1) d
	.s icuoSttTime=""
	.f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
	..;w !,curDate_"^"_icuoSttTime
	..q:(curDate=date)&&(icuoSttTime<sttime)    //早于开始时间
	..q:(curDate=(date+1))&&(icuoSttTime>endtime)    //晚于开始时间
	..s icuoId=""
	..f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
	...q:$d(^DHCICUOrder(icuoId))<1
	...s icuoOrderStr="",icuoValue="",icucriCode="",icuoComOrdDr=""
	...s orderEditFlag=$p($g(^DHCICUOrder(icuoId)),"^",25)
	...q:orderEditFlag="C"
	...;w !,icuoId
	...s icuoComOrdDr=$p($g(^DHCICUOrder(icuoId)),"^",2)
    ...q:icuoComOrdDr=""
    ...s ICUOViewCat=$p($g(^DHCICUOrder(icuoId)),"^",16)
    ...q:ICUOViewCat'="374"   //导管
    ...s ICUOICUPIDr=$p($g(^DHCICUOrder(icuoId)),"^",38)
    ...q:ICUOICUPIDr=""
    ...q:(ICUOICUPIDr'="")&&($p(ICUOICUPIDr,"||",1)'="")&&($p(ICUOICUPIDr,"||",2)'="")&&($p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",20)="N") //已删除医嘱不加载
	...s icupiSeqNo=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",8)  //排序号
	...;q:$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",19)'=""  //不取子项
	...s paraDesc=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",14)
	
	...s icuoNote=$p($g(^DHCICUOrder(icuoId)),"^",10)
    ...s icuoQty=+$p($g(^DHCICUOrder(icuoId)),"^",11)
    ...s icuoDataType=$p($g(^DHCICUC("RecordItem",icuoComOrdDr)),"^",24)
	...i "Qty,Volume"[icuoDataType s icuoValue=icuoQty
	...i icuoDataType="Note" s icuoValue=icuoNote
	...s mainPidr=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",19)  //主项模板ID
	...i mainPidr=""  d //主项
	....s ^TMPGetDGStr(ICUOICUPIDr)=paraDesc
	...e  d  //子项
	....s ^TMPGetDGStr(mainPidr,ICUOICUPIDr,icupiSeqNo)=paraDesc_":"_icuoValue
	
	s DGStr=""
	
	s i=0
	s mainId="" f  s mainId=$o(^TMPGetDGStr(mainId)) q:mainId=""  d
	.q:$g(^TMPGetDGStr(mainId))=""
	.s i=i+1
	.s DGDetail=i_"."_$g(^TMPGetDGStr(mainId))
	.s chlId="" f  s chlId=$o(^TMPGetDGStr(mainId,chlId)) q:chlId=""  d
	..s no="" f  s no=$o(^TMPGetDGStr(mainId,chlId,no)) q:no=""  d
	...s DGDetail=DGDetail_$c(3)_$g(^TMPGetDGStr(mainId,chlId,no))
	.i DGStr="" s DGStr=DGDetail
	.e  s DGStr=DGStr_$c(3)_DGDetail
	
	;b //1
	q DGStr
}

/// 获取用户签名
/// w ##Class(web.DHCICUOrder).GetUserSignInfo(7,"2021-04-29")
/// w ##Class(web.DHCICUOrder).GetUserSignInfo(6,"2021-05-07")
ClassMethod GetUserSignInfo(icuaId As %String, date As %String) As %String
{
	q:icuaId="" "重症排班Id不能为空"
	q:date="" "0"
	s date=##Class(web.DHCANOPCom).ConvertToDateH(date)
	s TypeStr=""
	s CASignId=""
	f  s CASignId=$o(^DHCICUDigitalSignLog(0,"DateICUA",date," "_icuaId,CASignId)) q:CASignId=""  d
	.q:$d(^DHCICUDigitalSignLog(CASignId))<1
	.
	.s Type="",UserDesc=""
	.s SignDr=$li(^DHCICUDigitalSignLog(CASignId),1)
	.s UserDr=$li(^DHCICUDigitalSignLog(CASignId),2)
	.s UserInfo=##class(web.DHCICUCom).GetUserTypeName(UserDr)
	.s UserDesc=$p(UserInfo,"^",2)
	.;s AdmDr=$li(^DHCICUDigitalSignLog(CASignId),3)
	.;s DocumentCode=$li(^DHCICUDigitalSignLog(CASignId),5)
	.;s ContentHash=$li(^DHCICUDigitalSignLog(CASignId),6)
	.s IsValid=$li(^DHCICUDigitalSignLog(CASignId),7)
	.q:IsValid=0
	.;s StartDateH=$li(^DHCICUDigitalSignLog(CASignId),8)
	.;s StartDate=##class(web.DHCClinicCom).ConvertToDate(StartDateH)
	.
	.s Type=$li(^DHCICUDigitalSignLog(CASignId),12)
	.i TypeStr="" s TypeStr=Type_":"_UserDesc_":"_UserDr
	.else  s TypeStr=TypeStr_"#"_Type_":"_UserDesc_":"_UserDr
	q TypeStr
}

ClassMethod CheckItemCodeOld(code, needCodeStr) As %String
{
	s flag="N"
	q:code="" "N"
	q:needCodeStr="" "N"
	f i=1:1:$length(needCodeStr,"^") d
	.s needCode=$p(needCodeStr,"^",i)
	.i code=needCode s flag="Y"
	
	q flag
}

ClassMethod CheckItemCode(code, needCodeStr) As %String
{
	s flag="N"
	q:code="" "N"
	q:needCodeStr="" "N"
	f i=1:1:$length(needCodeStr,"^") d
	.s needCode=$p(needCodeStr,"^",i)
	.f j=1:1:$length(needCode,";") d
	..s needCode1=$p(needCode,";",j)
	..i code=needCode1 s flag="Y"
	
	q flag
}

/// w ##class(web.DHCICUOrder).InDrugICUOrder(orderStr)
ClassMethod InDrugICUOrder(orderStr As %String) As %String
{
	//n (orderStr)
	q:orderStr=""
	//b:($p(orderStr,"^",1)=151)
	i ($p(orderStr,"^",2)=5374)&($p(orderStr,"^",1)=151) s ^cshq("test",1)=orderStr
	
	s isCurTime="",date="",time=""
	s min=+$g(^DHCCLSet("ICU","ConfirmedTime")) ;入库间隔分钟数
	i min=0 s min=60
	s sti=min*60 ;入库间隔时间(以秒为单位)
	s ssti=10*60 ;采集间隔

	i (date="")!(time="") d
	.s date=$p($h,",",1)
	.s time=$p($h,",",2)

	i isCurTime="" d
	.s time=((time+(sti/2))\sti)*sti
	.i time=(24*3600) s time=0,date=date+1
	i time="" s time=0
	
	s icuaId=$p(orderStr,"^",1)
	s icucriId=$p(orderStr,"^",2)
	s oeOrderId=$p(orderStr,"^",3)
	

	s editFlag="C"
	s IcuoRowId=""
	s HadRecord=0
	
	//输液通路无主医嘱停止自动插入
	s NoMainOrd=0
	s MainOrderId=""
	i (($p(orderStr,"^",2)=5382)!($p(orderStr,"^",2)=5377)) d 
	.&sql(SELECT ICUO_RowId into:MainOrderId FROM DHC_ICU_Order WHERE ICUO_ICUA_Dr=:icuaId AND ICUO_Oeore_Dr=:oeOrderId AND ICUO_EditFlag!=:editFlag AND ICUO_StartDate=:date AND ICUO_StartTime=:time )
	.i MainOrderId="" s NoMainOrd=1
	
	s longOrd=$p(^OEORD(+oeOrderId,"I",$p(oeOrderId,"||",2),1),"^",8)
	i longOrd=5 d
	.s oeOrderId=$p(oeOrderId,"||",1)_"||"_$p(oeOrderId,"||",2)_"||"_"%"
	.b:oeOrderId["5412057||173"
	.&sql(SELECT ICUO_RowId into:IcuoRowId  FROM DHC_ICU_Order WHERE ICUO_ICUA_Dr=:icuaId AND ICUO_ComOrd_Dr=:icucriId AND ICUO_Oeore_Dr like:oeOrderId AND ICUO_EditFlag!=:editFlag AND ICUO_StartDate=:date AND ICUO_StartTime=:time )
	e  d
	.&sql(SELECT ICUO_RowId into:IcuoRowId  FROM DHC_ICU_Order WHERE ICUO_ICUA_Dr=:icuaId AND ICUO_ComOrd_Dr=:icucriId AND ICUO_Oeore_Dr=:oeOrderId AND ICUO_EditFlag!=:editFlag AND ICUO_StartDate=:date AND ICUO_StartTime=:time )
	i IcuoRowId'="" s HadRecord=1
	;b ;1111
	s PLIST(2)=$p(orderStr,"^",1) //icuaId
	s PLIST(3)=$p(orderStr,"^",2) //icucriId
	s PLIST(4)=$p(orderStr,"^",3) //oeOrderId
	s PLIST(5)="" //userId
	s PLIST(6)=date //startDate
	s PLIST(7)=time //startTime
	s PLIST(8)=date //endDate
	s PLIST(9)=time //endTime
	s PLIST(10)=$p(orderStr,"^",9)
	s PLIST(11)=$p(orderStr,"^",10)	//ICUONote
	i $p(PLIST(11),".",1)="" s PLIST(11)="0"_$p(orderStr,"^",10)
	i ($l(PLIST(11))>5)&(PLIST(11)[".") s PLIST(11)=$FN(PLIST(11),"",5) 
	/*
	i +$p(orderStr,"^",11)=0 d
	.s qty=0_$p(orderStr,"^",11)
	.s PLIST(12)=qty
	e  s PLIST(12)=$p(orderStr,"^",11)*/
	
	s PLIST(12)=$p(orderStr,"^",11)
	s PLIST(13)=$p(orderStr,"^",12) //ctuomId
	s PLIST(14)=$p(orderStr,"^",13)
	s PLIST(15)=$p(orderStr,"^",14)
	s PLIST(16)=$p(orderStr,"^",15)

	s PLIST(17)=$p(orderStr,"^",16) //ancvcId
	s PLIST(18)=$p(orderStr,"^",17) //ICUO_Flag
	
	s PLIST(19)=$p(orderStr,"^",18)
	s PLIST(20)=$p(orderStr,"^",19)
	s PLIST(21)=$p(orderStr,"^",20)
	
	s PLIST(22)=+$h //ICUO_UpdateDate
	s PLIST(23)=$p($h,",",2) //ICUO_UpdateTime
	s PLIST(24)=$p(orderStr,"^",23) //ICUO_ICUO_Dr
	s PLIST(25)=$p(orderStr,"^",24)
	s PLIST(26)="N"  //"N" //ICUO_EditFlag
	
	s PLIST(27)=$p(orderStr,"^",26)
	//s PLIST(28)=$p(orderStr,"^",27)
	s PLIST(29)=$p(orderStr,"^",28)	//ICUOVolume
	
	s PLIST(30)= "M" //$p(orderStr,"^",29) //ICUO_ICUO_Source
	s PLIST(31)=$p(orderStr,"^",30) //ICUO_Type
	
	s PLIST(32)=$p(orderStr,"^",31)
	s PLIST(33)=$p(orderStr,"^",32)
	s PLIST(34)=$p(orderStr,"^",33)
	
	s PLIST(35)=$p(orderStr,"^",34)
	s PLIST(36)=$p(orderStr,"^",35)
	s PLIST(37)=$p(orderStr,"^",36)
	
	//s PLIST(38)=$p(orderStr,"^",37) //备注
	s PLIST(39)=$p(orderStr,"^",38)
	s PLIST(40)=$p(orderStr,"^",39)
	s PLIST(41)=$p(orderStr,"^",40)
	/*
	i +$p(orderStr,"^",40)=0 d
	.s qty1=0_$p(orderStr,"^",40)
	.s PLIST(41)=qty1
	e  s PLIST(41)=$p(orderStr,"^",40)*/

	//临时注释
	i (HadRecord=0)&&(NoMainOrd=0) &SQL(Insert into DHC_ICU_Order Values :PLIST())
	
	//e  &SQL(Update DHC_ICU_Order Values :PLIST() where ICUO_RowId=:IcuoRowId)

	i SQLCODE s retStr=icuaId_":ICU SQLCODE:"_SQLCODE //icuoId"插入数据错! SQLCode="_SQLCODE
	q SQLCODE
}

/// ICU
/// w ##Class(web.DHCICUOrder).GetLastVSNote(2,65904,37454)
/// NICU
/// w ##Class(web.DHCICUOrder).GetLastVSNote(3,65904,52844,61)
ClassMethod GetLastVSNote(icuaId As %String, date As %String, time As %String, ctlocId As %String = "") As %String
{
	q:icuaId="" ""
	k ^tmpGetLastVSNote
	s ctlocCommOrdID=7473
	if ((ctlocId=278)||(ctlocId=234)||(ctlocId=210)||(ctlocId=1220)) s ctlocCommOrdID=7473
	if (ctlocId=61) s ctlocCommOrdID=7337
	if (ctlocId=236) s ctlocCommOrdID=7473
	s ret=""
	s icuoId=""
	f  s icuoId=$o(^DHCICUOrder(0,"CommOrd",ctlocCommOrdID,icuaId,icuoId)) q:icuoId=""  d
	.s icuoStatus=$p($g(^DHCICUOrder(icuoId)),"^",25)
	.q:"CD"[icuoStatus
	.s ICUOICUPIDr=$p($g(^DHCICUOrder(icuoId)),"^",38)
	.q:(ICUOICUPIDr'="")&&($p(ICUOICUPIDr,"||",1)'="")&&($p(ICUOICUPIDr,"||",2)'="")&&($p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",20)="N") //已删除医嘱不加载
	.s icuoSD=$p($g(^DHCICUOrder(icuoId)),"^",5)
	.s icuoST=$p($g(^DHCICUOrder(icuoId)),"^",6)
	.;w !,icuoId
	.q:(date=icuoSD)&&(icuoST>time)
	.q:icuoSD>date
	.s icuoNote=$p($g(^DHCICUOrder(icuoId)),"^",10)
	.q:(icuoNote'="有创")&&(icuoNote'="无创")
	.s ^tmpGetLastVSNote(icuoSD,icuoST)=icuoNote
	
	s dt="" f  s dt=$o(^tmpGetLastVSNote(dt)) q:dt=""  d
	.s tt="" f  s tt=$o(^tmpGetLastVSNote(dt,tt)) q:tt=""  d
	..s ret=$g(^tmpGetLastVSNote(dt,tt))
	
	q ret
}

/// ICU 勾选脉搏显示  就显示脉搏 否则不显示
/// w ##Class(web.DHCICUOrder).GetLastVSPluse(3,65930,53699,278)
ClassMethod GetLastVSPluse(icuaId As %String, date As %String, time As %String, ctlocId As %String = "") As %String
{
	q:icuaId="" ""
	k ^tmpGetLastVSNote
	s ctlocCommOrdID=7484
	if ((ctlocId=278)||(ctlocId=210)||(ctlocId=234)||(ctlocId=1220)) s ctlocCommOrdID=7484
	s ret=""
	s icuoId=""
	f  s icuoId=$o(^DHCICUOrder(0,"CommOrd",ctlocCommOrdID,icuaId,icuoId)) q:icuoId=""  d
	.s icuoStatus=$p($g(^DHCICUOrder(icuoId)),"^",25)
	.q:"CD"[icuoStatus
	.s ICUOICUPIDr=$p($g(^DHCICUOrder(icuoId)),"^",38)
	.q:(ICUOICUPIDr'="")&&($p(ICUOICUPIDr,"||",1)'="")&&($p(ICUOICUPIDr,"||",2)'="")&&($p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",20)="N") //已删除医嘱不加载
	.s icuoSD=$p($g(^DHCICUOrder(icuoId)),"^",5)
	.s icuoST=$p($g(^DHCICUOrder(icuoId)),"^",6)
	.;w !,icuoId
	.q:(date=icuoSD)&&(icuoST>time)
	.q:icuoSD>date
	.s icuoNote=$p($g(^DHCICUOrder(icuoId)),"^",10)
	.q:(icuoNote'="√")&&(icuoNote'="×")
	.s ^tmpGetLastVSNote(icuoSD,icuoST)=icuoNote
	
	s dt="" f  s dt=$o(^tmpGetLastVSNote(dt)) q:dt=""  d
	.s tt="" f  s tt=$o(^tmpGetLastVSNote(dt,tt)) q:tt=""  d
	..s ret=$g(^tmpGetLastVSNote(dt,tt))
	
	q ret
}

/// w ##Class(web.DHCICUOrder).GetMainItemDesc(2004)
ClassMethod GetMainItemDesc(icuoId As %String) As %String
{
   q:icuoId="" ""
   s ICUOICUPIDr=$p($g(^DHCICUOrder(icuoId)),"^",38)
   q:ICUOICUPIDr="" ""
   s mainPIDr=$p($g(^DHCICUPara($p(ICUOICUPIDr,"||",1),"I",$p(ICUOICUPIDr,"||",2))),"^",19)
   i mainPIDr="" s mainPIDr=ICUOICUPIDr
   s itemDesc=""
   s itemDesc=$p($g(^DHCICUPara($p(mainPIDr,"||",1),"I",$p(mainPIDr,"||",2))),"^",14)
   
   q itemDesc
}

/// 危急值自动插入重症系统中
/// d ##class(web.DHCICUOrder).GetLabPanic(5262,"你好吗",65558,41835)
/// w ##class(web.DHCICUOrder).GetLabPanic(5262,"你好吗",65558,41835)
ClassMethod GetLabPanic(AdmId, LabPanic, startDate, startTime)
{
	q:AdmId=""
	
	if startDate="" s startDate=+$h
	else  s startDate=##Class(web.DHCANOPCom).ConvertToDateH(startDate)
	if startTime="" s startTime=$p($h,",",2)
	else  s startTime=##Class(web.DHCANOPCom).ConvertToTimeH(startTime)

	s icuaId=$o(^DHCICUArrange(0,"Adm",AdmId,""),-1)
	q:icuaId=""
	
	s LabPanic=$tr(LabPanic,"^",$c(2))
	;s a=..InTCICUOrder(icuaId,5476,startDate,startTime,"",LabPanic)	///5476危急值，5039特殊记录
	s a=..InTCICUOrderWJZ(icuaId,5039,startDate,startTime,"",LabPanic)	///5476危急值，5039特殊记录
	q a
}

ClassMethod InTCICUOrderWJZ(icuaId As %String, icucriId As %String, date As %String, time As %String, numValue As %String, txtValue As %String) As %String
{
	//w ##Class(web.DHCICUCom).Insert2ICUOrder(icuaId, icucriId, date, time,numValue, txtValue)
	s rowId="" ,retStr=0
	// 查询后插入
	s isFind=0
	s sub=""
	f  s sub=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId,time,sub)) q:((sub="")||(isFind=1))  d
	.s ctuomId=$p($g(^DHCICUOrder(sub)),"^",2)
	.i ctuomId=icucriId s isFind=1 s rowId=sub
	.
	// 已存在则修改，否则插入数据
	i isFind=1  d
	.s retStr=$$UPDATE()
	e  s retStr=$$INSERT()
	q retStr
INSERT()
	s PLIST(2)=icuaId //icuaId
	s PLIST(3)=icucriId //icucriId
	s PLIST(5)="" //userId
	s PLIST(6)=date //startDate
	s PLIST(7)=time //startTime
	s PLIST(8)=date //endDate
	s PLIST(9)=time //endTime
	s PLIST(11)=txtValue
	s PLIST(12)=numValue
	s PLIST(13)="" //ctuomId
	s PLIST(17)=$p($g(^DHCICUC("RecordItem",icucriId)),"^",5) //ancvcId
	s PLIST(18)="N" //ICUO_Flag
	s PLIST(22)=+$h //ICUO_UpdateDate
	s PLIST(23)=$p($h,",",2) //ICUO_UpdateTime
	s PLIST(24)="" //ICUO_ICUO_Dr
	s PLIST(26)="N" //ICUO_EditFlag
	s PLIST(30)="I" //ICUO_ICUO_Source
	s PLIST(31)=$p($g(^DHCICUC("RecordItem",icucriId)),"^",3) //ICUO_Type
	&SQL(Insert into DHC_ICU_Order Values :PLIST())

	i SQLCODE s retStr=icuaId_":ICU SQLCODE:"_SQLCODE //icuoId"插入数据错! SQLCode="_SQLCODE
	q SQLCODE
	
UPDATE()
	s updateTime=$p($h,",",2)
	s updateDate=+$h
	
	s textValueStr=txtValue
	if (icucriId="5039") d
	.s textValue=##class(web.DHCICUOrder).GetValueByICUORowId(rowId)
	.if (textValue'="")  d
	..s textValueStr=textValue_"。"_txtValue
	
	&sql(update DHC_ICU_Order set ICUO_UpdateTime=:updateTime,
	 ICUO_UpdateDate=:updateDate ,
	 ICUO_Note=:textValueStr,
	 ICUO_Qty=:numValue
	 where ICUO_RowId=:rowId
	 )	
	i SQLCODE=0 q 1
	e  q SQLCODE
}

/// w ##Class(web.DHCICUOrder).InTCICUOrderNBP(1233, "", "2021-11-26", "16:00","", "33","12177")
ClassMethod InTCICUOrderNBP(icuaId As %String, icucriId As %String, date As %String, time As %String, numValue As %String, txtValue As %String, userId As %String = "") As %String
{
	q:((date="")||(time="")) "-1"
	s date=##class(web.DHCClinicCom).ConvertToDateH(date),time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	s icucriId="5039"
	s rowId="" ,retStr=0
	// 查询后插入
	s isFind=0
	s sub=""
	f  s sub=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId,time,sub)) q:((sub="")||(isFind=1))  d
	.s ctuomId=$p($g(^DHCICUOrder(sub)),"^",2)
	.q:($p(^DHCICUOrder(sub),"^",25)="C")
	.i ctuomId=icucriId s isFind=1 s rowId=sub
	.
	// 已存在则修改，否则插入数据
	i isFind=1  d
	.s retStr=$$UPDATE()
	e  s retStr=$$INSERT()
	q retStr
INSERT()
	s PLIST(2)=icuaId //icuaId
	s PLIST(3)=icucriId //icucriId
	s PLIST(5)=userId
	s PLIST(6)=date //startDate
	s PLIST(7)=time //startTime
	s PLIST(8)=date //endDate
	s PLIST(9)=time //endTime
	s PLIST(11)=txtValue
	s PLIST(12)=numValue
	s PLIST(13)="" //ctuomId
	s PLIST(17)=$p($g(^DHCICUC("RecordItem",icucriId)),"^",5) //ancvcId
	s PLIST(18)="N" //ICUO_Flag
	s PLIST(22)=+$h //ICUO_UpdateDate
	s PLIST(23)=$p($h,",",2) //ICUO_UpdateTime
	s PLIST(24)="" //ICUO_ICUO_Dr
	s PLIST(26)="N" //ICUO_EditFlag
	s PLIST(30)="I" //ICUO_ICUO_Source
	s PLIST(31)=$p($g(^DHCICUC("RecordItem",icucriId)),"^",3) //ICUO_Type
	&SQL(Insert into DHC_ICU_Order Values :PLIST())

	i SQLCODE s retStr=icuaId_":ICU SQLCODE:"_SQLCODE //icuoId"插入数据错! SQLCode="_SQLCODE
	q SQLCODE
	
UPDATE()
	s updateTime=$p($h,",",2)
	s updateDate=+$h
	
	s textValueStr=txtValue
	if (icucriId="5039") d
	.s textValue=##class(web.DHCICUOrder).GetValueByICUORowId(rowId)
	.if (textValue'="")  d
	..s textValueStr=textValue_"。"_txtValue
	
	&sql(update DHC_ICU_Order set ICUO_UpdateTime=:updateTime,
	 ICUO_UpdateDate=:updateDate ,
	 ICUO_Note=:textValueStr,
	 ICUO_Qty=:numValue,
	 ICUO_EditFlag="N"
	 where ICUO_RowId=:rowId
	 )	
	i SQLCODE=0 q SQLCODE
	e  q 1
}

/// 入参：ICUORowId是DHC_ICU_Order表ID
/// 获取Order表中改ID下面Note节点的值
/// w ##class(web.DHCICUOrder).GetValueByICUORowId(1417)
ClassMethod GetValueByICUORowId(ICUORowId As %String) As %String
{
	q:ICUORowId=""
	set txtValue=""
	&sql(select ICUO_Note into :txtValue from DHC_ICU_Order where ICUO_RowId=:ICUORowId)
	q txtValue
}

/// 血糖值自动插入重症系统中
/// d ##class(web.DHCICUOrder).GetLabXueTang(5262,"你好吗",65558,41835)
/// w ##class(web.DHCICUOrder).GetLabXueTang(5262,"11",65558,41835)
/// AdmId:就诊号，LabPanic：血糖值,startDate：日期, startTime：时间
ClassMethod GetLabXueTang(AdmId, LabPanic, startDate, startTime)
{
	q:AdmId=""
	
	if (+LabPanic=0) s LabPanic=""
	b ;1
	
	if startDate="" s startDate=+$h
	else  s startDate=##Class(web.DHCANOPCom).ConvertToDateH(startDate)
	if startTime="" s startTime=$p($h,",",2)
	else  s startTime=##Class(web.DHCANOPCom).ConvertToTimeH(startTime)

	s icuaId=$o(^DHCICUArrange(0,"Adm",AdmId,""),-1)
	q:icuaId="" "非重症系统患者"
	
	s LabPanic=$tr(LabPanic,"^",$c(2))
	s a=..InTCICUOrder(icuaId,7582,startDate,startTime,LabPanic,"")
	q a
}

ClassMethod SaveTemplatePageNo(icuaId, printDate, templateCode, pageNo) As %String
{
	s printDate=##Class(web.DHCANOPCom).ConvertToDateH(printDate)
	s ^DHCICUPrintLog("PageNo",icuaId,templateCode,printDate)=pageNo
	
	q 0
}

ClassMethod GetTemplatePageNo(icuaId, printDate, templateCode) As %String
{
	s ret=0
	s printDate=##Class(web.DHCANOPCom).ConvertToDateH(printDate)
	s date=""
	f  s date=$o(^DHCICUPrintLog("PageNo",icuaId,templateCode,date)) q:date=""  d
	.q:date>=printDate
	.s ret=$g(^DHCICUPrintLog("PageNo",icuaId,templateCode,date))
	;s ret=$g(^DHCICUPrintLog("PageNo",icuaId,templateCode,templateCode))
	
	
	q +ret
}

/// w ##class(web.DHCICUOrder).GetCatheterRecordByDate(138,"2021-08-23")
/// w ##class(web.DHCICUOrder).GetCatheterRecordByDate(12,"2021-08-27","08:00")
/// w ##class(web.DHCICUOrder).GetCatheterRecordByDate(167,"2021-08-30","08:00")
ClassMethod GetCatheterRecordByDate(icuaId, printDate, baseTime As %String = "7:00", ctLoc = "") As %String
{
	quit:('##class(User.DHCICUArrange).%ExistsId(icuaId)) "E^重症监护记录ID不存在"
	quit:(printDate="") "E^打印日期不能为空"
	quit:(baseTime="") "E^每天第一个班次的开始时间不能为空"
	set ret=""
	set printStartDateH=##class(web.DHCClinicCom).ConvertToDateH(printDate,"")
	set printStartTimeH=##class(web.DHCClinicCom).ConvertToTimeH(baseTime,"")
	set printStartDTH=printStartDateH+(printStartTimeH/100000)
	set printEndDateH=printStartDateH+1
	set printEndTimeH=printStartTimeH-1
	set printEndDTH=printEndDateH+(printEndTimeH/100000)
	&sql(declare PrintCatheterCursor cursor for select RowId into :RowId
		 from SQLUser.DHC_ICU_CatheterRecord
		 where Arrange=:icuaId
		 and EditFlag='Normal'
		 and (IntubateDate<=:printEndDateH or TakeInDate<=:printEndDateH)
		 and (ExtubateDate>=:printStartDateH or ExtubateDate is null))
	&sql(open PrintCatheterCursor)
	//set retArray=##class(%DynamicArray).%New()
	set i=0
	for
	{
		&sql(fetch PrintCatheterCursor)	
		quit:(SQLCODE'=0)
		//b //ccq2
		set catheterRecord=##class(User.DHCICUCatheterRecord).%OpenId(RowId)
		set intubeDTH=0
		if (catheterRecord.IntubateDate>0)&(catheterRecord.IntubateTime>0)
		{
			set intubeDTH=catheterRecord.IntubateDate+(catheterRecord.IntubateTime/100000)	
		}
		elseif (catheterRecord.TakeInDate>0)&(catheterRecord.TakeInTime>0)
		{
			set intubeDTH=catheterRecord.TakeInDate+(catheterRecord.TakeInTime/100000)	
		}
		continue:(intubeDTH=0)
		continue:(intubeDTH>printEndDTH)
		if (catheterRecord.ExtubateDate>0)&(catheterRecord.ExtubateTime>0)
		{
			set extubeDTH=catheterRecord.ExtubateDate+(catheterRecord.ExtubateTime/100000)
			//b //ccq
			continue:(extubeDTH<printStartDateH)	
		}
		set i=i+1
		set thisCatheter=i_"."_catheterRecord.Catheter.Description
		set:(catheterRecord.IntubateDate>0)&(catheterRecord.IntubateTime>0) thisCatheter=thisCatheter_$c(3)_"置管时间:"_##class(web.DHCClinicCom).ConvertToDateTime(catheterRecord.IntubateDate,catheterRecord.IntubateTime,"")
		set:(catheterRecord.TakeInDate>0)&(catheterRecord.TakeInTime>0) thisCatheter=thisCatheter_$c(3)_"带入时间:"_##class(web.DHCClinicCom).ConvertToDateTime(catheterRecord.TakeInDate,catheterRecord.TakeInTime,"")
		
		set tbDate=catheterRecord.ExtubateDate,tbTime=catheterRecord.ExtubateTime
		;b ;1
		continue:(tbDate>0)&(tbTime>0)&((printStartDateH>tbDate)||((printStartDateH=tbDate)&(tbTime<28800)))	///拔管之后过滤
		b ;11
		if (tbDate>0)&(tbTime>0)&(((printStartDateH=tbDate)&(tbTime>=28800))||((printStartDateH=tbDate-1)&(tbTime<28800)))	///根据拔管时间控制打印
		{
			 set thisCatheter=thisCatheter_$c(3)_"拔管时间:"_##class(web.DHCClinicCom).ConvertToDateTime(tbDate,tbTime,"")
		}
		;b ;2
		/*
		if (catheterRecord.ExtubateDate>0)&(catheterRecord.ExtubateTime>0)&(printStartDateH>=catheterRecord.ExtubateDate)
		{
			 set thisCatheter=thisCatheter_$c(3)_"拔管时间:"_##class(web.DHCClinicCom).ConvertToDateTime(catheterRecord.ExtubateDate,catheterRecord.ExtubateTime,"")
		}
		*/
		if (catheterRecord.Type'="") set thisCatheter=thisCatheter_$c(3)_"导管型号:"_catheterRecord.Type
		if (catheterRecord.TotalLength'="") set thisCatheter=thisCatheter_$c(3)_"置管长度:"_catheterRecord.TotalLength_"cm"
		if (catheterRecord.ExposedLenth'="") set thisCatheter=thisCatheter_$c(3)_"外露长度:"_catheterRecord.ExposedLenth_"cm"
		if (catheterRecord.ExposedScale'="") set thisCatheter=thisCatheter_$c(3)_"外露刻度:"_catheterRecord.ExposedScale_"cm"
		if (catheterRecord.MarkOnSkin'="") set thisCatheter=thisCatheter_$c(3)_"体表标志:"_catheterRecord.MarkOnSkin_"cm"
		if (catheterRecord.TailPos'="") set thisCatheter=thisCatheter_$c(3)_"末端位置:"_catheterRecord.TailPos
		if (catheterRecord.AdjustDateTime'="") set thisCatheter=thisCatheter_$c(3)_"调整时间:"_catheterRecord.AdjustDateTime
		if (catheterRecord.Note'="") set thisCatheter=thisCatheter_$c(3)_"备注:"_catheterRecord.Note
		;if (catheterRecord.Position'="") set thisCatheter=thisCatheter_$c(3)_"置入位置:"_catheterRecord.Position.Description
		if (catheterRecord.Position'="") set thisCatheter=thisCatheter_$c(3)_"置入位置:"_catheterRecord.Position
        if (ret="") set ret=thisCatheter
        else  set ret=ret_$c(3)_thisCatheter
		
		/*set resCatheter=##class(%DynamicObject).%New()
		set resCatheter.CatheterDesc=catheterRecord.Catheter.Description
		set resCatheter.IntubeDT=""
		set:(catheterRecord.IntubateDate>0)&(catheterRecord.IntubateTime>0) resCatheter.IntubeDT=##class(web.DHCClinicCom).ConvertToDateTime(catheterRecord.IntubateDate,catheterRecord.IntubateTime,"")
		set resCatheter.TakeInDT=""
		set:(catheterRecord.TakeInDate>0)&(catheterRecord.TakeInTime>0) resCatheter.TakeInDT=##class(web.DHCClinicCom).ConvertToDateTime(catheterRecord.TakeInDate,catheterRecord.TakeInTime,"")
		set resCatheter.ExtubeDT=""
		set:(catheterRecord.ExtubateDate>0)&(catheterRecord.ExtubateTime>0) resCatheter.ExtubeDT=##class(web.DHCClinicCom).ConvertToDateTime(catheterRecord.ExtubateDate,catheterRecord.ExtubateTime,"")
		set resCatheter.Type=catheterRecord.Type
		set resCatheter.TotalLength=catheterRecord.TotalLength
		set resCatheter.ExposedLenth=catheterRecord.ExposedLenth
		set resCatheter.ExposedScale=catheterRecord.ExposedScale
		set resCatheter.MarkOnSkin=catheterRecord.MarkOnSkin
		set resCatheter.TailPos=catheterRecord.TailPos
		set resCatheter.AdjustDateTime=catheterRecord.AdjustDateTime
		set resCatheter.Note=catheterRecord.Note
		set resCatheter.PositionDesc=""
		set:($isobject(catheterRecord.Position)) resCatheter.PositionDesc=catheterRecord.Position.Description
		do retArray.%Push(resCatheter)*/
	}
	&sql(close PrintCatheterCursor)
	
	quit ret
}

/// 取医生医嘱OE_OrdItem
/// 入参：ifDrug为"Y"查询药品，ifDrug为"N"查询治疗，治疗医嘱大类的ID定义在^DHCCLSet("ICU","TherapyCatId")中，为空查询全部
/// 	  ifStand"Y"查询长期医嘱，为"N"查询临时医嘱，为""查询全部。
///       ifNurExecuted为"Y"查询护士已执行医嘱，ifNurExecuted为"N"查询护士未执行医嘱，为空查询全部；
/// 临时医嘱: 按医嘱表时间判,不跨天; 当天的第一条返回医嘱时间(直接显示),其它的返回分发时间(提前半小时显示),一次只显示一条
/// 长期医嘱: 按执行表时间判,会跨天(提前半小时显示),一次只显示一条
/// d ##class(%ResultSet).RunQuery("web.DHCICUOrder","FindDtHealthOrderItem","9","2021-07-19","2021-07-19","Y","","")
Query FindOEOreItems(icuaId, startDate = "", endDate = "", ifDrug = "Y", ifStand = "", ifNurExecuted = "") As %Query(ROWSPEC = "Id,RecordItemId,OeoreId,UserId,StartDate,StartTime,EndDate,EndTime,ArcimId,Note,Qty,UomId,Concentration,OriginalOrderId,InstrId,RecordCatId,Flag,DrugMode,Speed,UpdateDate,UpdateTime,Reason,EditFlag,EditedIcuoId,RecvLoc,DocUserId,Volume,SpeedUnitId,Source,Type,AncoDesc,ArcimDesc,PreparedIntake,AttachOeoriId,Report,ArrangeId,MainOeoreId,SubOrderId,Priority,Instruction,Frequency,OeoriNote,Abbreviate,OrderItemNote,MainIcuoId,OrderItemStatus,OrderItemSeqNo,IcuoCtcpDesc,OriginalOrderItemId,icuoStartDateTime,Description") [ SqlProc ]
{
}

ClassMethod FindOEOreItemsExecute(ByRef qHandle As %Binary, icuaId, startDate = "", endDate = "", ifDrug = "Y", ifStand = "", ifNurExecuted = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1

	k ^TMPICU("Oeore",$j)
	i icuaId="" s qHandle=$lb(0,repid,0) q $$$OK
	i ..SetMainSubIcucriList(icuaId,.mainSubIcucriList)<0 s qHandle=$lb(0,repid,0) q $$$OK

	s EpisodeID=$p(^DHCICUArrange(+icuaId),"^",1)
	q:EpisodeID="" 0

	s Config=##Class(websys.Configuration).%OpenId(1)
	s LABDATA=Config.LabDataNamespace
	s CurNamespace=$ZNSPACE

	//查找医生所下医嘱
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	i oeordId="" s qHandle=$lb(0,repid,0) q $$$OK //未开过医嘱

	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)

	s fDate=startDate-1,tDate=endDate
	d ##class(web.DHCICUCom).GetAdmPriorityList(1,"",.admPriorityList)
	s needArcbsId=$g(^DHCCLSet("ICU","BillSub")) //此账单子类作为药品处理ARC_BillSub
	s isOrdOnce=$g(^DHCCLSet("ICU","OrdOnce"))	 //医嘱只出现一次
	s isExecStandNow=$g(^DHCCLSet("ICU","ExecStandNow")) //是否执行当天长嘱
	s phcinStr=$g(^DHCCLSet("ICU","IgnorePhcinId")) //不需要处理的用药途径
	s ignoreFreqArcimIdStr=$g(^DHCCLSet("ICU","IgnoreFreqArcimIdStr")) //不考虑频次(Q1H,Q2H)，必须显示的医嘱
	s locId=$p($g(^DHCICUArrange(+icuaId)),"^",2)
	i (locId'="")&&($d(^DHCCLSet("ICU","IgnoreFreqArcimIdStr",locId))) d //不同科室显示医嘱
	.s ignoreFreqArcimIdStr=$g(^DHCCLSet("ICU","IgnoreFreqArcimIdStr",locId))	
	s NoIgnoreFreqArcimIdStr="" 
	i (locId'="")&&($d(^DHCCLSet("ICU","NoIgnoreFreqArcimIdStr",locId))) d //不同科室不显示医嘱
	.s NoIgnoreFreqArcimIdStr=$g(^DHCCLSet("ICU","NoIgnoreFreqArcimIdStr",locId))
	//s therapyCatIdStr=$g(^DHCCLSet("ICU","TherapyCatId"))
	s oeoriSub=0,oeoriIdStr=""
	
	s icuoAttachOeoriId=""
	s curUserId="" //ICUO_User_Dr
	s curNote=""	//ICUO_Note
	s icuoSource="M" //ICUO_Source
	s curDocUserId="" //ICUO_DocUser_Dr
	s curEndDate="" //ICUO_EndDate
	s curEndTime="" //ICUO_EndTime
	s icuoOriginateFromIcuodr="" //ICUO_Compli_Dr
	s icuoFlag="N" //ICUO_Flag
	s icuoDrugMode="" //ICUO_DrugMode
	s curUpdateDate="",curUpdateTime=""
	s icuoReason="" //ICUO_Reason
	s curEditedId="" //ICUO_ICUO_DR
	s doseTestQty=""
	s wardCtlocId=##Class(web.DHCICUCom).GetWardCtlocId("",icuaId)
	s locIdStr=##class(web.DHCClinicCom).GetLinkLocId(wardCtlocId)
	s volumeCtuomId=##Class(web.DHCClinicCom).GetVolumeCtuomId()
	s wardId=+$p($g(^DHCICUArrange(+icuaId)),"^",4)
	s abbrevLocIdStr=$g(^DHCCLSet("ICU","AbbrevLocId"))
	s isAbbrevArcim=0
	i ("^"_abbrevLocIdStr_"^")[("^"_+wardCtlocId_"^") s isAbbrevArcim=1

	s isDebug=0
	i $g(^tmpIcuDebug("DocOrd"))=icuaId s isDebug=1
	f sttDate=fDate:1:tDate d
		.s ordSttTime=""
		.;f  s oeoriSub=$o(^OEORDi(0,"StDt",sttDate,oeordId,oeoriSub)) q:(oeoriSub="")  d
		.f  s ordSttTime=$o(^OEORDi(0,"Date",oeordId,sttDate,ordSttTime))  q:ordSttTime=""  d
		..s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"Date",oeordId,sttDate,ordSttTime,oeoriSub)) q:(oeoriSub="")  d
			...i isDebug s ^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)="//1.In"
			...
			...q:'$d(^OEORD(oeordId,"I",oeoriSub))
			...s oeoriId=oeordId_"||"_oeoriSub
			...s ordStatCode=##Class(web.DHCClinicCom).GetOrdStatCode(oeoriId)
			...;q:oeoriId'="555||9"
			...q:(ordStatCode="U")!(ordStatCode="I")
			...s oeoriXDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",34)
    		...s oeoriXTime=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",15)
    		...i oeoriXDate="" s oeoriXDate=99999
    		...s oeoriXDateTime=oeoriXDate+(oeoriXTime/100000)
    		...i isDebug s ^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)_"//1.1 discon & Extra Drug?"_oeoriXDate
    		...s oecprId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",8)
			...q:oecprId=""
			...;w oeoriId,!
			...;b ;0
			...s oecprCode=$p(^OECPR(oecprId),"^",1)
			...q:oecprCode=""
			...q:((ordStatCode="D")!(ordStatCode="PD"))&((oecprCode'="S")&(oecprCode'="OMST")&(oecprCode'="OMCQZT"))
			...s orcatId=##Class(web.DHCClinicCom).GetOrdCatId(oeoriId)
			...;w orcatId,!
			...q:orcatId=""
			...s ocgrpId=$p($g(^OEC("ORCAT",orcatId)),"^",15) //OEC_OrderCategoryGroup
			...s ocgrpCode=$p($g(^OEC("OCGRP",+ocgrpId)),"^",1)
			...s arcicOrderType=##Class(web.DHCClinicCom).GetOrdSubCatType(oeoriId)
			...s arcimId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",2)
			...s arcimDesc=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",2)
			...
			...;医嘱序号
			...s orderItemSeqNo=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",4)
			...;20130830+医嘱状态--
			...s orderItemStatus=""
		    ...s ordStatId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)  ;OEORI_ItemStat_DR
		    ...s orderItemStatus=$p($g(^OEC("OSTAT",+ordStatId)),"^",2)
		    ...;---
			...s ordLocId=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",2)
			...;w ordLocId,locIdStr,!
			...q:(ordLocId'="")&(("^"_locIdStr_"^")'[("^"_ordLocId_"^"))&(ordLocId'=wardCtlocId)
			...
			...s icuoType=arcicOrderType
			...s arcsgId=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",9)
			...i (arcsgId'="")&(arcsgId=needArcbsId) s icuoType="D"
			...//i arcicOrderType="R" s icuoType="D" //药品
			...i ocgrpCode="EXAM" s icuoType="L"
			...
			...i isDebug s ^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)_"//2.Exam & Extra Drug?"_arcsgId_"=="_needArcbsId
			...//q:("RL"'[arcicOrderType)&(ocgrpCode'="EXAM")&((arcsgId'="")&(arcsgId'=needArcbsId))&(("^"_therapyCatIdStr_"^")'[("^"_orcatId_"^"))
			...;w oeoriId,!
			...s icucriStr=..GetIcucriStr(oeoriId,icuaId)
			...;w oeoriId_"-"_icucriStr,!
			...;w oeoriId,"----",icucriStr,!
			...//s ifOmitFreq=""
			...//i icucriStr'="" s ifOmitFreq=$p(icucriStr,"^",9)
			...s icucriId=+icucriStr
			...i isDebug s ^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)_"//3.MappingComOrd?"
			...q:icucriId'>0
			...s curIcucriId=icucriId
			...q:'$d(^DHCICUC("RecordItem",curIcucriId))
			...s icuoType=$p($g(^DHCICUC("RecordItem",curIcucriId)),"^",3)
			...s icucriDesc=$p($g(^DHCICUC("RecordItem",+icucriId)),"^",2) //s tmpStr=tmpStr_$p($g(^DHCICUC("RecordItem",+icucriId)),"^",2)_"^"
			...s ancvcId="" //$o(^DHCICUC("ViewCat",0,"DrugIntake",""))
			...i icucriId>0 s ancvcId=$p($g(^DHCICUC("RecordItem",icucriId)),"^",5)
			...s icucriType=$p($g(^DHCICUC("RecordItem",icucriId)),"^",3)
			...
			...
			...i isDebug s ^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)_"//4.Drug?"_ifDrug_"/"_icuoType_"/"_icucriType
			...q:(ifDrug="Y")&(icucriType'="D") //&(icuoType'="R")&(icucriType'="D") //药品
			...
			...i isDebug s ^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)_"//4.1.Drug?"_ifDrug_"/"_icuoType_"/"_icucriType
			...q:(ifDrug="N")&(icucriType="D") //&((icuoType="R")!(icucriType="D")) //(("^"_therapyCatIdStr_"^")'[("^"_orcatId_"^")) //治疗
			...
			...i isDebug s ^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)_"//5.UnExecLab?"
			...//q:(ordStatCode'="E")&(arcicOrderType="L") //检验
			...i isDebug s ^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)_"//6.UnExecExam?"
			...//q:(ordStatCode'="E")&(ocgrpCode="EXAM")   //检查
			...
			...//s lIcucriId=0,icucriId=0
			...//f  s lIcucriId=$o(^DHCICUC("RecordItem",lIcucriId)) q:(lIcucriId="")!(icucriId>0)  d
			...//.i arcimId=$p($G(^DHCICUC("RecordItem",lIcucriId)),"^",4) s icucriId=lIcucriId
			...//q:"ONE^OUT"[oecprCode //取药医嘱和出院带药
			...s isStandSort=2
			...i (oecprCode="S")!(oecprCode="OMST")!(oecprCode="OMCQZT") s isStandSort=1
			...i isDebug s ^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)_"//7.stand?"
			...q:(ifStand="Y")&(oecprCode'="S")&(oecprCode'="OMST")&(oecprCode'="OMCQZT")
			...i isDebug s ^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)_"//8.normal?"
			...q:(ifStand="N")&(ifStand'="Y")&((oecprCode="S")!(oecprCode="OMST")!(oecprCode="OMCQZT"))
			...//s icucriStr=""
			...//i icucriId>0 s icucriStr=$g(^DHCICUC("RecordItem",+icucriId))
			...//i $p(icucriStr,"^",11)="" s $p(icucriStr,"^",11)=""
			...//i $p(icucriStr,"^",4)="" s $p(icucriStr,"^",4)=arcimId
			...//s $p(icucriStr,"^",5)=ancvcId
			...
			...s phcinId=+$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7)
			...i isDebug s ^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)_"//9.phcinStr?"
			...q:(icuoType="D")&(phcinId'="")&(("^"_phcinStr_"^")[("^"_phcinId_"^"))
			...i isDebug s ^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)_"//9.1 phcinStr?"
			...q:(phcinId'="")&(("^"_$g(^DHCCLSet("ICU","MicroPumpInstrId"))_"^")[("^"_phcinId_"^"))&(arcicOrderType="R")
			...i isDebug s ^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)_"//9.2 phcinStr?"_phcinId_"|"_arcicOrderType_"|"_icuoType
			...//q:(phcinId'="")&(arcicOrderType'="R")&(ifDrug="N")
			...q:(icuoType="D")&(ifDrug="N")
			...;b ;1
			...s phcfrFactor=1,phcfrCode=""
			...s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
			...i phcfrId'="" d 
				....s phcfrFactor=$p(^PHCFR(phcfrId),"^",2)
				....s phcfrCode=$p(^PHCFR(phcfrId),"^",1)
			...;w phcfrFactor,"%",phcfrCode,!
			...i isDebug s ^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)_"//9.8phcinStr?"
			...//q:(ifOmitFreq'="Y")&(phcfrCode="Ialways") //暂时写死
			...q:(phcfrCode="Ialways") //暂时写死
			...//q:(ifDrug="N")&(ifOmitFreq'="Y")&((phcfrCode="IQ1H")!(phcfrCode="IQ2H"))&(("^"_ignoreFreqArcimIdStr_"^")'[("^"_arcimId_"^"))
			...q:(ifDrug="N")&((phcfrCode="IQ1H")!(phcfrCode="IQ2H"))&(("^"_ignoreFreqArcimIdStr_"^")'[("^"_arcimId_"^"))
			...;b ;2
			...s icuoReportResult=""
			...i ocgrpCode="EXAM" s icuoReportResult=..GetRisReportResult(oeoriId)  //取检查结果
			...i arcicOrderType="L" s icuoReportResult=..GetLabReportResult(oeoriId,CurNamespace,LABDATA) //取检验结果
			...i isDebug s ^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)_"//10.labResult?"
			...//q:(icuoReportResult="")&(arcicOrderType="L")
			...i isDebug s ^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)_"//11.examResult?"
			...//q:(icuoReportResult="")&(ocgrpCode="EXAM")
			...;w icucriStr,!,arcimDesc,!,"---------------------------------------------",!
			...s oeoriSttDat=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
			...s oeoriSttTim=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
			...i $o(^OEORD(oeordId,"I",oeoriSub,"X",0))="" d //没有执行记录则插入
				....q:(oecprCode="S")!(oecprCode="OMST")!(oecprCode="OMCQZT")
				....s PLIST(0)=oeoriId
				....s PLIST(16)=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",1)  ;剂量OEORE_PhQtyOrd
				....s PLIST(26)=oeoriSttDat  ;OEORE_ExStDate
				....s PLIST(27)=oeoriSttTim ;OEORE_ExStTime
				....s PLIST(41)=0                                             ;OEORE_PhQtyIss
				....s PLIST(42)=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",1)  ;剂量OEORE_QtyAdmin
				....s PLIST(43)="TB"                                          ;OEORE_Billed
				....&sql(insert into OE_OrdExec Values :PLIST())
				....s ^TmpDebug("insertExec","Find",oeordId,oeoriSub)=$zd(+$h)_" "_$zt($p($h,",",2))
				....//i SQLCODE s ok="执行记录插入有误!"
			...
			...s icuoRecLocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
			...//s oeoriAddUserId=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)
			...//s eqUomQty=##class(web.DHCICUCom).GetEqUomQty(arcimId)
			...s doseQty=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",1)
			...s unitUomId=""
			...i doseQty'="" s unitUomId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",3)
			...i unitUomId'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)
			...i (doseQty'="")&($p(doseQty,".")="") s doseQty="0"_doseQty
			...s curQty=doseQty //ICUO_Qty
			...
			...s phcdtTimeList=""
			...s phcdtId=0
			...f  s phcdtId=$o(^PHCFR(+phcfrId,"DT",phcdtId)) q:phcdtId=""  d
				....i phcdtTimeList'="" s phcdtTimeList=phcdtTimeList_"^"
				....s phcdtTimeList=phcdtTimeList_^PHCFR(+phcfrId,"DT",phcdtId)
			...i phcdtTimeList="" s phcdtTimeList=28800
			...
			...s description=##class(web.DHCClinicCom).GetOeoriGroupDesc(oeoriId,isAbbrevArcim)
			...s curAbbreviate=description
			...
			...s oeorditemStr=..GetOeorditemInfo(oeoriId)
			...;w oeoriId,"------",oeorditemStr,!
			...i phcinId="" s phcinId=+$p(oeorditemStr,"^",3)
			...s subOeoriId=$p(oeorditemStr,"^",7) //从医嘱subOeoriId
			...s oecprDesc=$p(oeorditemStr,"^",13) //优先级
			...s phcinDesc=$p(oeorditemStr,"^",5) //用法 phcinDesc  40
			...q:((phcinDesc="口服")||(phcinDesc["鼻饲")||(phcinDesc["吸入")||(phcinDesc["外用")||(phcinDesc["漱口"))
			...;q:((phcinDesc="口服"))
			...s prcfrDesc=$p(oeorditemStr,"^",15) //频率 num: 41
			...s oeoriNote=$p(oeorditemStr,"^",17) //医嘱备注 42
			...s icuoPreparedVolume=$p(oeorditemStr,"^",18) //ICUO_PreparedVolume
			...;W icuoPreparedVolume,!
			...s icuoVolume=0 //ICUO_Volume
			...s icuoSpeedUnitDr=0 //ICUO_SpeedUnit_Dr
			...s uomId=unitUomId //ICUO_Uom_Dr
			...s icuoConcentration="" //ICUO_Concentration
			...s icuoSpeed="" //ICUO_Speed
			...i $l(icucriStr,"^")>1 d
				....s icuoSpeedUnitDr=$p(icucriStr,"^",2)
				....i $p(icucriStr,"^",3)'="" s uomId=$p(icucriStr,"^",3)
				....s icuoConcentration=$p(icucriStr,"^",4)
				....i $p(icucriStr,"^",5)>0 s curQty=$p(icucriStr,"^",5)
				....i $p(icucriStr,"^",6)>0 s icuoPreparedVolume=$p(icucriStr,"^",6)
				....i curQty'>0 s curQty=icuoPreparedVolume*icuoConcentration
				....i curQty'>0 s curQty=icuoPreparedVolume
				....//s curAbbreviate=$p(icucriStr,"^",7)
			...i +icuoSpeedUnitDr=0 d
				....s subIcucriId=""
					....f  s subIcucriId=$o(mainSubIcucriList(icucriId,subIcucriId)) q:subIcucriId=""  d
						.....i mainSubIcucriList(icucriId,subIcucriId)="Speed" s icuoSpeedUnitDr=1
			...i isDebug s ^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)_"//12.recordedOrder?"
			...q:(+icuoPreparedVolume>9999)&(icuoSpeedUnitDr>0)&(..RecordedOrder(oeoriId)="Y") //暂不根据配置走
			...//i (oeoriNote'="")&(ifDrug'="N") s curAbbreviate=curAbbreviate_"("_oeoriNote_")"
			...i (oeoriNote'="") d
			....i (icuoType="D") s curAbbreviate=curAbbreviate_"("_oeoriNote_")" ;药品
			....e  d ;非药品(治疗)
			.....s showNoteOeore=$g(^DHCCLSet("ICU","ShowNoteOeore"))
			.....i (showNoteOeore'="")&(("^"_showNoteOeore_"^")[("^"_arcimId_"^")) s curAbbreviate=curAbbreviate_"("_oeoriNote_")"
			...;b ;21
			...s originalOeoriId=""
			...i isStandSort=1 d
				....s originalOeoriId=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",12)
				....i originalOeoriId'="" s originalOeoriId=$p(originalOeoriId,"!!")
				....i originalOeoriId="" s originalOeoriId=oeoriId
			...s seq=0
			...s oeoreSub=0,oeoreId="",ifFind="N" //循环执行表，每条对应一个重症记录，没有对应上，则输出
			...f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:(oeoreSub="")!(ifFind="Y")  d
			    ....;W oeordId,"@",oeoriSub,"@",oeoreSub,!
				....//不论执行与否//q:$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",16)'=""  //不考虑在别处执行的情况
				....i isDebug s ^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)_"//21."_seq_"Exec?"
				....q:(ifNurExecuted="Y")&($p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",16)="")
				....i isDebug s ^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)_"//22."_seq_"unExec?"
				....//q:(ifNurExecuted="N")&($p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",16)'="")
				....//“停止执行”状态不显示
				....s oeoreStatusId=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",16)
				....s oeoreStatus=$p($g(^OEC("STAT",+oeoreStatusId)),"^",1)
				....q:(oeoreStatus="D")
				....
				....s oeoreId=oeoriId_"||"_oeoreSub
				....s seq=seq+1
				....;W icuoPreparedVolume,"@",icuoSpeedUnitDr,"@",seq,!
				....q:(+icuoPreparedVolume>9999)&(icuoSpeedUnitDr>0)&(seq>1)
				....s oeoreDate=oeoriSttDat //!会转日期和时间，不可移到上一循环
				....s oeoreTime=oeoriSttTim
				....i isDebug s ^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)_"//23."_seq_"Normal?"
				....q:(oecprCode'="S")&(oecprCode'="OMST")&(oecprCode'="OMCQZT")&(oeoreDate<startDate) //临嘱开始时间早于查询日期
				....s icuoCtcpDesc=""
				....
				....s curOeoreId=oeoriId_"||"_oeoreSub
				....s curIcuoId="",quitFlag=0,icuoEditFlag="",icuoId="",icuoStartDate=0,icuoStartTime=0
				....;W curOeoreId
				....f  s curIcuoId=$o(^DHCICUOrder(0,"OEORE",curOeoreId,icuaId,curIcuoId)) q:((curIcuoId="")!(quitFlag))  d
				    .....;W curIcuoId,"123",!
					.....q:'$d(^DHCICUOrder(+curIcuoId))
					.....s tmpIcuoEditFlag=$p(^DHCICUOrder(+curIcuoId),"^",25)
					.....i icuoEditFlag="" s icuoEditFlag=tmpIcuoEditFlag
					.....i (tmpIcuoEditFlag'="")&(("^N^E^")[("^"_tmpIcuoEditFlag_"^")) d
					......s icuoEditFlag=tmpIcuoEditFlag
					......s icuoPreparedVolume=$p(^DHCICUOrder(+curIcuoId),"^",31)
					.....e  q
					.....;i (("^N^E^")[("^"_icuoEditFlag_"^"))&(isOrdOnce="Y") s ifFind="Y"
					.....;i ("^N^E^")[("^"_icuoEditFlag_"^") s quitFlag=1 q //停止"D"视为未输入,相当于未处理过
					.....s icuoId=curIcuoId
					.....s icuoUserId=$p(^DHCICUOrder(+curIcuoId),"^",4)
					.....s ctcpId=$p($g(^SSU("SSUSR",+icuoUserId)),"^",14)
					.....s icuoCtcpDesc=$p($g(^CTPCP(+ctcpId,1)),"^",2)
					.....;W icuoCtcpDesc,!
					.....s curStartDate=$p(^DHCICUOrder(+curIcuoId),"^",5)
					.....s curStartTime=$p(^DHCICUOrder(+curIcuoId),"^",6)
					.....i icuoStartDate=0 s icuoStartDate=curStartDate s icuoStartTime=curStartTime
					.....s startDateTime=icuoStartDate*100000+icuoStartTime
					.....s curStartDateTime=icuoStartDate*100000+icuoStartTime
					.....i curStartDateTime<startDateTime s icuoStartDate=curStartDate s icuoStartTime=curStartTime
					.....
				....i isDebug s ^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)_"//24."_seq_"icuOrdered?"
				....q:quitFlag
				....i isDebug s ^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)_"//25."_seq_"updated?"
				....//q:($p(^DHCICUOrder(+icuoId),"^",14)'="")&(icuoEditFlag'="D") //ICUO_OriginateFromICUO_Dr 余液数据
				....//分发时间为1的临嘱取医嘱时间,不计时
				....i isDebug s ^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)_"//25.1:"_seq_"updated?"
				....//i (phcfrFactor=1)&(oecprCode'="S")&(oecprCode'="OMST") s oeoreId=curOeoreId q //100708
				....//调整临时医嘱的分发时间
				....i (oecprCode'="S")&(oecprCode'="OMST")&(oecprCode'="OMCQZT") d
					.....q:phcfrFactor=1 //无频次为1
					.....//q:seq=1
					.....s oeoreTime=$p(phcdtTimeList,"^",seq)
				....e  d //长嘱
					.....q:(+icuoPreparedVolume>9999)&(icuoSpeedUnitDr>0)
					.....s oeoreDate=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",1)
					.....s oeoreTime=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",2)
					.....i ifNurExecuted="" d
						......q:isExecStandNow=""
						......s oeoreTime=$p(phcdtTimeList,"^",seq)
						......i isExecStandNow'="Y" d
							.......s oeoreDate=oeoriSttDat+1
				....//i (oecprCode'="S")&(oecprCode'="OMST")&(seq=1) s oeoreId=curOeoreId q //临嘱第一条立即返
				....i isDebug s ^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)_"//26."_seq_"dayBefore?"
				....;W oeoreDate,"--",startDate,!
				....q:(oeoreDate<startDate)
				....i isDebug s ^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)_"//27."_seq_"dayAfter?"
				....q:(oeoreDate>endDate)
				....;W endDate,!
				....s curDate=+$h,curTime=$p($h,",",2)
				....i isDebug s ^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)_"//27.1"_seq_"discon later?"
				....q:(oeoriXDate<oeoreDate)!((oeoriXDate=oeoreDate)&(oeoriXTime<oeoreTime))
				....//q:((curDate-oeoreDate)*86400+curTime+1800-oeoreTime)<0
				....//s oeoreId=curOeoreId
				....;W oeoriXDate,"--",oeoreDate,"--",oeoriXTime,"--",oeoreTime,!
				....s ctacuId=##class(web.DHCICUCom).GetDateTimeListData(.admPriorityList,oeoreDate,oeoreTime)
				....i ctacuId'="",("|"_$p($g(^DHCCLSet("ICU","SERIOUS")),"^")_"|")'[("|"_ctacuId_"|") q
				....
				....//w uomId_"/"_icuoConcentration_": "_curQty_"/"_icuoPreparedVolume_" ="
				....i uomId=volumeCtuomId s icuoConcentration=1
				....i icuoPreparedVolume>0,+icuoConcentration=0 s icuoConcentration=$fn((curQty/icuoPreparedVolume),"",4)
				....;w "HJTEST2"_""_icuoConcentration,!
				....q:oeoreDate>+$h  //不显示今天之后的医嘱
				....s curId=+icuoId //ICUO_RowId
				....s curOeoreDate=$zd(oeoreDate,3) //ICUO_StartDate
				....s curOeoreTime=$zt(oeoreTime,2) //ICUO_StartTime
				....i icuoStartDate=0 s icuoStartDateTime=""
				....e  s icuoStartDateTime=$zd(icuoStartDate,3)_" "_$zt(icuoStartTime,2)
				....
				....s curEditFlag=icuoEditFlag //ICUO_EditFlag
				....s icuoOrdItemNote=$p($g(^DHCICUOrder(+icuoId)),"^",35) //HIS医嘱说明 ICUO_OrdItemNote 
				....s icuoMainIcuoDr=$p($g(^DHCICUOrder(+icuoId)),"^",36) //主医嘱的ICUOId：ICUO_MainIcuo_Dr  total 45
				....s mainOeoriId=$p(oeorditemStr,"^",6) //主医嘱mainOeoriId
				....i mainOeoriId'="" s mainOeoriId=mainOeoriId_"||"_oeoreSub
				....s mainOeoriSub=$p(mainOeoriId,"||",2)
				....//s ^TMPICU("Oeore",$j,icucriId_arcimId_oeoriId,+icuoUpdateDate,+icuoUpdateTime,icuoId)=tmpStr //_icuoId
				....s tmpDateTime=oeoreDate+(oeoreTime/100000)
				....s tmpSub=oeoriSub
				....i mainOeoriSub="" s mainOeoriSub=oeoriSub,tmpSub=0
				....s oreGroup=mainOeoriSub+((seq/100)+(tmpSub/1000000))
				....i isDebug s ^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)=^tmpIcuDebug("OEOREItem",icuaId,oeordId,oeoriSub)_"//99."_seq_"ok!"
				....//s ^TMPICU("Oeore",$j,tmpDateTime,oreGroup,oeoriSub,icucriId_arcimId_oeoriId)=tmpStr //_icuoId
				....i phcinId=0 s phcinId=""
				....I icuoCtcpDesc="" D
					.....s execCTPCP=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",15)
					.....i execCTPCP'="" s icuoCtcpDesc=$p($g(^CTPCP(execCTPCP,1)),"^",2) 
				....
				....s ^TMPICU("Oeore",$j,tmpDateTime,oreGroup,oeoriSub,icucriId_arcimId_oeoriId)=$lb(curId,curIcucriId,oeoreId,curUserId,curOeoreDate,curOeoreTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,icuoConcentration,icuoOriginateFromIcuodr,phcinId,ancvcId,icuoFlag,icuoDrugMode,icuoSpeed,curUpdateDate,curUpdateTime,icuoReason,curEditFlag,curEditedId,icuoRecLocId,curDocUserId,icuoVolume,icuoSpeedUnitDr,icuoSource,icuoType,icucriDesc,arcimDesc,icuoPreparedVolume,icuoAttachOeoriId,icuoReportResult,icuaId,mainOeoriId,subOeoriId,oecprDesc,phcinDesc,prcfrDesc,oeoriNote,curAbbreviate,icuoOrdItemNote,icuoMainIcuoDr,orderItemStatus,orderItemSeqNo,icuoCtcpDesc,originalOeoriId,icuoStartDateTime,description)
				....//s ^TMPICU("Ordes",$j,tmpDateTime,oreGroup,oeoriSub,icucriId_arcimId_oeoriId)=curId_"^"_curIcucriId_"^"_oeoreId_"^"_curUserId_"^"_curStartDate_"^"_curStartTime_"^"_curEndDate_"^"_curEndTime_"^"_arcimId_"^"_curNote_"^"_curQty_"^"_uomId_"^"_icuoConcentration_"^"_icuoOriginateFromIcuodr_"^"_phcinId_"^"_ancvcId_"^"_icuoFlag_"^"_icuoDrugMode_"^"_icuoSpeed_"^"_curUpdateDate_"^"_curUpdateTime_"^"_icuoReason_"^"_curEditFlag_"^"_curEditedId_"^"_icuoRecLocId_"^"_curDocUserId_"^"_icuoVolume_"^"_icuoSpeedUnitDr_"^"_icuoSource_"^"_icuoType_"^"_icucriDesc_"^"_arcimDesc_"^"_icuoPreparedVolume_"^"_icuoAttachOeoriId_"^"_icuoReportResult_"^"_icuaId_"^"_mainOeoriId_"^"_subOeoriId_"^"_oecprDesc_"^"_phcinDesc_"^"_prcfrDesc_"^"_oeoriNote_"^"_curAbbreviate_"^"_icuoOrdItemNote_"^"_icuoMainIcuoDr
	s updateDate="" f  s updateDate=$o(^TMPICU("Oeore",$j,updateDate))  q:updateDate=""  d
		.s updateTime="" f  s updateTime=$o(^TMPICU("Oeore",$j,updateDate,updateTime))  q:updateTime=""  d
			..s icucriArcimId="" f  s icucriArcimId=$o(^TMPICU("Oeore",$j,updateDate,updateTime,icucriArcimId))  q:icucriArcimId=""  d
				...s icuoId="" f  s icuoId=$o(^TMPICU("Oeore",$j,updateDate,updateTime,icucriArcimId,icuoId))  q:icuoId=""  d
					....//s ^TMPICU("OeoreRet",$j,i)=^TMPICU("Oeore",$j,updateDate,updateTime,icucriArcimId,icuoId)
					....s Data=^TMPICU("Oeore",$j,updateDate,updateTime,icucriArcimId,icuoId)
					....d OutputRowOEOreItems
	s qHandle=$lb(0,repid,0)
	q $$$OK

OutputRowOEOreItems
	//s Data=$lb(inattId,tPhcinId,tArcimId,tQty,tDefault)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindOEOreItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOEOreItemsExecute ]
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

ClassMethod FindOEOreItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOEOreItemsExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 获取病人医嘱数据(打印用)
/// w ##class(web.DHCICUOrder).GetOrderItemList("1156","2021-11-18 07:00","2021-11-19 06:59")
ClassMethod GetOrderItemList(icuaId As %String, startDT As %String, endDT As %String) As %String
{
	set startDTH=##class(ICU.Utils.DateTime).ConvertToDateTimeH(startDT,"")
	set endDTH=##class(ICU.Utils.DateTime).ConvertToDateTimeH(endDT,"")
	kill ^TMPICUPrint("GetPrintDataChar")
	kill ^TMPICUPrint("GetPrintDataCharInfo")
	set patWardId=$p($g(^DHCICUArrange(icuaId)),"^",87)
	set patLocId=$p($g(^PAWARD(patWardId)),"^",5)
	/*
	set itemList=##class(ICU.BS.Order).GetOrderItemListJSON(icuaId,startDT,endDT)
	for k=1:1:itemList.%Size()
	{
		set itemStr=itemList.%Get(k-1)
		set Order=itemStr.Order
		set orderDesc=$list(^ICU.Data.OrderD(Order),3)    //描述
		set InstructionID=$list(^ICU.Data.OrderD(Order),15)  //用法
		;set InstructionDesc=##class(CIS.AN.COM.String).GetDescByID("User.PHCInstruc","PHCINDesc1",InstructionID)
		//获取执行医嘱的所属显示分类
		set viewCatId=252  //默认静脉输液
		set oeorId=""
		set InstructId=0
		for 
		{
			set InstructId=$o(^DHCCLSet("ICU","Oeore","Instruct",InstructId,patLocId))
			quit:(InstructId="")
			set linkStr=$g(^DHCCLSet("ICU","Oeore","Instruct",InstructId,patLocId))
			for i=1:1:$length(linkStr,"^")
			{
				set linkId=$p(linkStr,"^",i)
				if linkId=InstructionID
				set oeorId=InstructId
			}
		}
		if oeorId'="" set viewCatId=$p($g(^DHCICUC("RecordItem",oeorId)),"^",5)
		else  set oeorId=5016  //默认静脉输入
		set CreateUserDesc=itemStr.CreateUserDesc  //执行人
		set AuditUserDesc=itemStr.AuditUserDesc    //联合部署
		set ^TMPICUPrint("GetPrintDataCharInfo",icuaId,Order)=$lb(orderDesc,viewCatId,"",CreateUserDesc,AuditUserDesc,oeorId)
	}*/
	set volumeDetails=##class(ICU.BS.Order).GetOrderSumDetailJSON(icuaId,startDT,endDT)
	for l=1:1:volumeDetails.%Size()
	{
		set detailStr=volumeDetails.%Get(l-1)
		set detailDate=detailStr.StartDate
		set detailTime=detailStr.StartTime
		set detailOrderId=detailStr.OrderID
		set detailHourVol=detailStr.HourVol
		/*if $g(^TMPICUPrint("GetPrintDataCharInfo",icuaId,detailOrderId))'="" 
		{
			set ^TMPICUPrint("GetPrintDataChar",icuaId,detailDate,detailTime,detailOrderId)=^TMPICUPrint("GetPrintDataCharInfo",icuaId,detailOrderId)
			set $list(^TMPICUPrint("GetPrintDataChar",icuaId,detailDate,detailTime,detailOrderId),3)=detailHourVol
		}*/
		set Order=detailOrderId
		set orderDesc=$list(^ICU.Data.OrderD(Order),3)    //描述
		set InstructionID=$list(^ICU.Data.OrderD(Order),15)  //用法
		;w !,Order_"^"_orderDesc_"^"_InstructionID_"^"_patLocId
		set InstructionDesc=##class(CIS.AN.COM.String).GetDescByID("User.PHCInstruc","PHCINDesc1",InstructionID)
		set:(InstructionDesc'="") orderDesc=orderDesc_" ("_InstructionDesc_")"
		set orderDesc=$replace(orderDesc,$c(13,10),"+")
		set orderDesc=$replace(orderDesc,$c(10),"+")
		//获取执行医嘱的所属显示分类
		set viewCatId=252  //默认静脉输液
		set oeorId=""
		set InstructId=0
		for 
		{
			set InstructId=$o(^DHCCLSet("ICU","Oeore","Instruct",InstructId))
			;w !,InstructId_"^"_patLocId
			quit:(InstructId="")
			set thidLocId=0
			for
			{
				set thidLocId=$o(^DHCCLSet("ICU","Oeore","Instruct",InstructId,thidLocId))
				quit:(thidLocId="")
				continue:(thidLocId'=patLocId)
				set linkStr=$g(^DHCCLSet("ICU","Oeore","Instruct",InstructId,thidLocId))
				for i=1:1:$length(linkStr,"^")
				{
					set linkId=$p(linkStr,"^",i)
					if linkId=InstructionID
					{
						set oeorId=InstructId
						;w !,oeorId
					}
				}
			}
		}
		set ctLocParaId=0
		if oeorId'="" 
		{
			set ctLocParaId=$o(^DHCICUPara(0,"Ctloc",patLocId,ctLocParaId))
			quit:ctLocParaId=""
			set paraId=0
			for
			{
				set paraId=$o(^DHCICUPara(ctLocParaId,"I",paraId))
				quit:paraId=""
				set paraItemId=$p($g(^DHCICUPara(ctLocParaId,"I",paraId)),"^",4)
				continue:paraItemId'=oeorId
				set viewCatId=$p($g(^DHCICUPara(ctLocParaId,"I",paraId)),"^",11)
			}
			
		}
		else  
		{
			set oeorId=5016  //默认静脉输入
		}
		set ^TMPICUPrint("GetPrintDataChar",icuaId,detailOrderId,##class(ICU.Utils.DateTime).ConvertToDateH(detailDate),##class(ICU.Utils.DateTime).ConvertToTimeH(detailTime))=$lb(orderDesc,viewCatId,detailHourVol,"","",oeorId)
	}

	quit 0
}

}
