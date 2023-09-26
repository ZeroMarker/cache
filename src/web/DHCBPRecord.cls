Import SQLUser

Class web.DHCBPRecord Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 取监护数据DHC_BP_Record
/// 入参：监护Id,就诊号EpisodeID,病区wardLocId，科室ctlocId(可为病区,为科室时找关联病区),
/// 所需要查询的常用医嘱needbprId(用"^"分割的串)查，起止时间。bprSourceStr="MA"只取手工录入数据
Query FindBPRecord(bpaId, startDate, startTime, endDate, endTime, EpisodeID = "", ctlocId = "", needbpcoId = "", bprSourceStr = "") As %Query(ROWSPEC = "Id:%String,ArrangeId:%String,RecordItemId :%String,OeoriId:%String,UpdateUserId:%String,UpdateUserDesc:%String,StartDate:%String,StartTime:%String,EndDate:%String,EndTime:%String,ArcimId:%String,Note:%String,Qty:%String,UomId:%String,InstructId:%String,RecordCatId:%String,Speed:%String,UpdateDate:%String,UpdateTime:%String,EditStatus:%String,RecvLocId:%String,SpeedUnitId:%String,DataSource:%String,DataType:%String,ArcimDesc:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPRecord","FindBPRecord",8,60000,0,66000,0)
ClassMethod FindBPRecordExecute(ByRef qHandle As %Binary, bpaId, startDate, startTime, endDate, endTime, EpisodeID = "", ctlocId = "", needbpcoId = "", bprSourceStr = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	k ^TMPBP("Order",$j)
	s startDate=##class(web.DHCANOPCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCANOPCom).ConvertToTimeH(startTime)
	s endDate=##class(web.DHCANOPCom).ConvertToDateH(endDate)
	s endTime=##class(web.DHCANOPCom).ConvertToTimeH(endTime)
	s sttDateTime=startDate+(startTime/100000)
	s endDateTime=endDate+(endTime/100000)
	s bpaIdList=##class(web.DHCBPCom).FindBpaIdList(bpaId,EpisodeID,ctlocId)
	i bpaIdList="" s qHandle=$lb(0,repid,0) q $$$OK
	s curDateTime=$h+($p($h,",",2)/100000)
	s fDate=startDate-1
	f curDate=fDate:1:endDate d
	.f i=1:1:$l(bpaIdList,"^") d
	     ..s bpaId=$p(bpaIdList,"^",i)
         ..i bprSourceStr="I" d
	           ...s curTime=""
	           ...f  s curTime=$o(^DHCBPArrange(0,"CData",bpaId,curDate,curTime),-1) q:(curTime="")  d
	               ....s bpcdSub=""
	               ....f  s bpcdSub=$o(^DHCBPArrange(0,"CData",bpaId,curDate,curTime,bpcdSub)) q:bpcdSub=""  d
	                   .....q:$$GetCollectData("Y")<0
	    ..q:bprSourceStr="I"
	    ..k adjTimeList
	    ..s bprSttTime=""
	    ..f  s bprSttTime=$o(^DHCBPRecord(0,"DateTime",curDate,bpaId,bprSttTime)) q:bprSttTime=""  d
	            ...//q:(curDate=startDate)&(bprSttTime<startTime)
	            ...//q:(curDate=endDate)&(bprSttTime'<endTime)  //结束时间跨时间段?
	            ...k tmpCurTime //当前时间点最后修改数据记录
	            ...s haveDrug=0,haveMonData=0,haveExclude=0
	            ...s bprId="",seq=0
	            ...s bpcoIdList=""
	            ...f  s bprId=$o(^DHCBPRecord(0,"DateTime",curDate,bpaId,bprSttTime,bprId)) q:bprId=""  d
	                ....s bpcoId=$p(^DHCBPRecord(bprId),"^",2)
	                ....q:(bpcoIdList'="")&(bpcoId'="")&(("^"_bpcoIdList_"^")[("^"_bpcoId_"^"))
	                ....q:$$GetBprData("Y")<0
	                
	s bpaId="" f  s bpaId=$o(^TMPBP("Order",$j,bpaId))  q:bpaId=""  d
	 	.s startDT="" f  s startDT=$o(^TMPBP("Order",$j,bpaId,startDT))  q:startDT=""  d
        ..s bprId="" f  s bprId=$o(^TMPBP("Order",$j,bpaId,startDT,bprId))  q:bprId=""  d
	    ...s Data=^TMPBP("Order",$j,bpaId,startDT,bprId)
	    ...d OutputBPRecord
 	s qHandle=$lb(0,repid,0)
	q $$$OK
GetBprData(ifByDateTime = "")
	q:'$d(^DHCBPRecord(bprId)) -1
	q:(bprSourceStr'="")&(bprSourceStr'[$p(^DHCBPRecord(bprId),"^",29)) -2
	s bprUpdateDate=$li(^DHCBPRecord(bprId),22)
	s bprUpdateTime=$li(^DHCBPRecord(bprId),23)
	s bprStartDate=$li(^DHCBPRecord(bprId),5)
	s bprStartTime=$li(^DHCBPRecord(bprId),6)
	s bprEndDate=$li(^DHCBPRecord(bprId),7)
	s bprEndTime=$li(^DHCBPRecord(bprId),8)

	s bprStartDateTime=bprStartDate+(bprStartTime/100000)
	s STARTDT=bprStartDateTime
	s bprEndDateTime=bprEndDate+(bprEndTime/100000)
	;q:(ifByDateTime="Y")&(bprEndDateTime'>sttDateTime) -4 //开始时间点不计
	;q:(ifByDateTime="Y")&(bprStartDateTime>endDateTime) -5 //结束时间点计入
	;q:($p(^DHCBPRecord(bprId),"^",29)="I")&(curDateTime-bprStartDateTime>30) -6 //不查看三十天以上的数据，旧版一天
	
	s arcimId=$li(^DHCBPRecord(bprId),9)				//BPR_ARCIM_Dr
	s bpcoId=$li(^DHCBPRecord(bprId),2)				   //BPR_ComOrd_Dr
	q:(needbpcoId'="")&(("^"_needbpcoId_"^")'[("^"_bpcoId_"^")) -7
	s bpcvcId=$li(^DHCBPRecord(bprId),3)			//BPR_ViewCat_Dr
	q:(bpcoId="")&(arcimId="")&(bpcvcId="") -8
	s oeoriId=$li(^DHCBPRecord(bprId),4)
	s curId=bprId //s tmpStr=bprId_"^"
	s curbpcoId=bpcoId //s tmpStr=tmpStr_bpcoId_"^"
	//s tmpStr=tmpStr_oeoreId_"^"	//BPR_OEORE_Dr
	s curUserId=$li(^DHCBPRecord(bprId),21) // tmpStr=tmpStr_$p(^DHCBPRecord(bprId),"^",4)_"^"	//BPR_User_Dr
	i curUserId'="" s curUserDesc=$p($g(^SSU("SSUSR",curUserId)),"^",2)
	e  s curUserDesc=""
	s curStartDate=$zd(bprStartDate,3) //s tmpStr=tmpStr_$ZD(bprStartDate,3)_"^"			//BPR_StartDate
	s curStartTime=$zt(bprStartTime) //s tmpStr=tmpStr_$ZT(bprStartTime)_"^"
	s curEndDate=$zd(bprEndDate,3) //s tmpStr=tmpStr_$ZD(bprEndDate,3)_"^"
	s curEndTime=$zt(bprEndTime) //s tmpStr=tmpStr_$ZT(bprEndTime)_"^"
	//s tmpStr=tmpStr_arcimId_"^"
	
	s curNote=$li(^DHCBPRecord(bprId),15) //s tmpStr=tmpStr_$p(^DHCBPRecord(bprId),"^",10)_"^"	//BPR_Note num:10
	s curQty=$li(^DHCBPRecord(bprId),14) //s tmpStr=tmpStr_$p(^DHCBPRecord(bprId),"^",11)_"^"	//BPR_Qty
	
	s oeorditemStr=..GetOeordItemInfo(oeoriId)
	
	s uomId=$li(^DHCBPRecord(bprId),16)
	i uomId="" s uomId=$p(oeorditemStr,"^",12)
	s phcinId=$li(^DHCBPRecord(bprId),17)	
	s bpcvcDesc=""
	i bpcvcId'="" s bpcvcDesc=$lg(^DHCBPC("RecordCat",bpcvcId),2)
	s bprSpeed=$li(^DHCBPRecord(bprId),19) //s tmpStr=tmpStr_$p(^DHCBPRecord(bprId),"^",19)_"^"	//BPR_Speed
	s curUpdateDate=$zd(bprUpdateDate,3) //s tmpStr=tmpStr_$ZD(bprUpdateDate,3)_"^" //num:20
	s curUpdateTime=$zt(bprUpdateTime) //s tmpStr=tmpStr_$ZT(bprUpdateTime)_"^"
	s bprEditStatus=$li(^DHCBPRecord(bprId),10) //s tmpStr=tmpStr_$p(^DHCBPRecord(bprId),"^",25)_"^"	//BPR_EditFlag
	s bprRecLocId=$li(^DHCBPRecord(bprId),18) //s tmpStr=tmpStr_$p(^DHCBPRecord(bprId),"^",26)_"^"	//BPR_RecLoc_Dr
	s bprSpeedUnitDr=$li(^DHCBPRecord(bprId),20) //s tmpStr=tmpStr_$p(^DHCBPRecord(bprId),"^",20)_"^" //BPR_SpeedUnit_Dr
	s bprSource=$li(^DHCBPRecord(bprId),12) //s tmpStr=tmpStr_$p(^DHCBPRecord(bprId),"^",29)_"^"	//BPR_Source
	s bprType=$li(^DHCBPRecord(bprId),11) //tmpStr=tmpStr_$p(^DHCBPRecord(bprId),"^",30)_"^"	//BPR_Type //num:30
	s ancoDesc=$lg(^DHCBPC("RecordItem",+bpcoId),2) //s tmpStr=tmpStr_$p($g(^DHCANC("ComOrd",+$p(^DHCBPRecord(bprId),"^",2))),"^",2)_"^"
	s arcimDesc=$p($g(^ARCIM(+arcimId,1,1)),"^",2) //s tmpStr=tmpStr_$p($g(^ARCIM(+arcimId,1,1)),"^",2)_"^"
	i $p(oeorditemStr,"^",6)'="" s $p(oeorditemStr,"^",6)=$p(oeorditemStr,"^",6)_"||"_oeoreSub
	s mainOeoriId=$p(oeorditemStr,"^",6) //s tmpStr=tmpStr_$p(oeorditemStr,"^",6)_"^"		//主医嘱mainOeoriId
	s subOeoriId=$p(oeorditemStr,"^",7) //s tmpStr=tmpStr_$p(oeorditemStr,"^",7)_"^"		//从医嘱subOeoriId
	s oecprDesc=$p(oeorditemStr,"^",13) //s tmpStr=tmpStr_$p(oeorditemStr,"^",13)_"^"		//优先级
	s phcinDesc=$p(oeorditemStr,"^",5) //s tmpStr=tmpStr_$p(oeorditemStr,"^",5)_"^"		//用法 phcinDesc  40
	s prcfrDesc=$p(oeorditemStr,"^",15) //s tmpStr=tmpStr_$p(oeorditemStr,"^",15)_"^"		//频率 num: 41
	s oeoriNote=$p(oeorditemStr,"^",17) //s tmpStr=tmpStr_$p(oeorditemStr,"^",17)_"^"		//医嘱备注 42
	s curAbbreviate=$p(^DHCBPRecord(bprId),"^",34)
	i curAbbreviate="" s curAbbreviate=##class(web.DHCANOPCom).GetOeoriGroupDesc(oeoriId)
    s ^TMPBP("Order",$j,bpaId,STARTDT,bprId)=$lb(bprId,bpaId,curbpcoId,oeoriId,curUserId,curUserDesc,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,phcinId,bpcvcId,bprSpeed,curUpdateDate,curUpdateTime,bprEditStatus,bprRecLocId,bprSpeedUnitDr,bprSource,bprType,arcimDesc)
	q 0
GetCollectData(ifByDateTime="")
	q:'$d(^DHCBPArrange(bpaId,"C",bpcdSub)) -1
	s bpcdStartDate=$p(^DHCBPArrange(bpaId,"C",bpcdSub),"^",2)
	s bpcdStartTime=$p(^DHCBPArrange(bpaId,"C",bpcdSub),"^",3)

	s bpcdStartDateTime=bpcdStartDate+(bpcdStartTime/100000)
	s bpcdEndDateTime=bpcdStartDateTime
	q:(ifByDateTime="Y")&(bpcdEndDateTime'>sttDateTime) -4 //开始时间点不计
	q:(ifByDateTime="Y")&(bpcdStartDateTime>endDateTime) -5 //结束时间点计入
	
	s bpcoId=$p(^DHCBPArrange(bpaId,"C",bpcdSub),"^",1)
	q:bpcoId="" -2
	s bpcdUpdateDate=$p(^DHCBPArrange(bpaId,"C",bpcdSub),"^",6)
	s bpcdUpdateTime=$p(^DHCBPArrange(bpaId,"C",bpcdSub),"^",7)
	s updateDateTime=bpcdUpdateDate+(bpcdUpdateTime/100000)
	
	s curId="" //s tmpStr="^" //??
	s curbpcoId=$p(^DHCBPArrange(bpaId,"C",bpcdSub),"^",1) //s tmpStr=tmpStr_$p(^DHCBPArrange(bpaId,"C",bpcdSub),"^",1)_"^"
	s oeoreId="" //s tmpStr=tmpStr_"^"	//BPR_OEORE_Dr
	s curUserId="" //s tmpStr=tmpStr_"^"	//BPR_User_Dr
	s curStartDate=$zd($p(^DHCBPArrange(bpaId,"C",bpcdSub),"^",2),3) //s tmpStr=tmpStr_$ZD($p(^DHCBPArrange(bpaId,"C",bpcdSub),"^",2),3)_"^"	//BPR_StartDate
	s curStartTime=$zt($p(^DHCBPArrange(bpaId,"C",bpcdSub),"^",3)) //s tmpStr=tmpStr_$ZT($p(^DHCBPArrange(bpaId,"C",bpcdSub),"^",3))_"^"
	s curEndDate=$zd($p(^DHCBPArrange(bpaId,"C",bpcdSub),"^",2),3) //s tmpStr=tmpStr_$ZD($p(^DHCBPArrange(bpaId,"C",bpcdSub),"^",2),3)_"^"
	s curEndTime=$zt($p(^DHCBPArrange(bpaId,"C",bpcdSub),"^",3)) //s tmpStr=tmpStr_$ZT($p(^DHCBPArrange(bpaId,"C",bpcdSub),"^",3))_"^"
	s arcimId="" //s tmpStr=tmpStr_"^"
	s curNote=$p(^DHCBPArrange(bpaId,"C",bpcdSub),"^",4) //s tmpStr=tmpStr_$p(^DHCBPArrange(bpaId,"C",bpcdSub),"^",4)_"^"	//BPR_Note num:10
	s curQty=$p(^DHCBPArrange(bpaId,"C",bpcdSub),"^",5) //s tmpStr=tmpStr_$p(^DHCBPArrange(bpaId,"C",bpcdSub),"^",5)_"^"	//BPR_Qty
	s uomId="" //s tmpStr=tmpStr_"^"	//BPR_Uom_Dr
	s bprConcentration="" //s tmpStr=tmpStr_"^"	//BPR_Concentration
	s bprOriginateFromBprdr="" //s tmpStr=tmpStr_"^"	//BPR_OriginateFromBPR_Dr
	s phcinId="" //s tmpStr=tmpStr_"^"	//BPR_Instr_Dr
	s ancvcId=$p($g(^DHCANC("ComOrd",bpcoId)),"^",5) //s tmpStr=tmpStr_$p($g(^DHCANC("ComOrd",bpcoId)),"^",5)_"^" //tmpStr_ancvcDesc_"^"
	s bprFlag="N" //s tmpStr=tmpStr_"N^"	//BPR_Flag
	s bprDrugMode="" //s tmpStr=tmpStr_"^"	//BPR_DrugMode
	s bprSpeed="" //s tmpStr=tmpStr_"^"	//BPR_Speed
	s curUpdateDate=$zd(bpcdUpdateDate,3) //s tmpStr=tmpStr_$ZD(bpcdUpdateDate,3)_"^" //num:20
	s curUpdateTime=$zt(bpcdUpdateTime) //s tmpStr=tmpStr_$ZT(bpcdUpdateTime)_"^"
	s bprReason="" //s tmpStr=tmpStr_"^"	//BPR_Reason
	s curEditFlag="N" //s tmpStr=tmpStr_"N^"	//BPR_EditFlag
	s curEditedId="" //s tmpStr=tmpStr_"^"	//BPR_BPR_DR
	s bprRecLocId="" //s tmpStr=tmpStr_"^"	//BPR_RecLoc_Dr
	s curDocUserId="" //s tmpStr=tmpStr_"^"	//BPR_DocUser_Dr
	s bprVolume=0 //s tmpStr=tmpStr_"0^"	//BPR_Volume
	s bprSpeedUnitDr="" //s tmpStr=tmpStr_"^" //BPR_SpeedUnit_Dr
	s bprSource="A" //s tmpStr=tmpStr_"A^"	//BPR_Source
	s bprType=$p($g(^DHCANC("ComOrd",bpcoId)),"^",3) //s tmpStr=tmpStr_$p($g(^DHCANC("ComOrd",bpcoId)),"^",3)_"^"	//BPR_Type //num:30
	s ancoDesc=$p($g(^DHCANC("ComOrd",bpcoId)),"^",2) //s tmpStr=tmpStr_$p($g(^DHCANC("ComOrd",bpcoId)),"^",2)_"^"
	s arcimDesc="" //s tmpStr=tmpStr_"^"
	s bprPreparedVolume=0 //s tmpStr=tmpStr_"0^"	//BPR_PreparedVolume
	s bprAttachOeoriId="" //s tmpStr=tmpStr_"^"     //BPR_AttachOeoriId
	s bprReportResult="" //s tmpStr=tmpStr_"^"     //BPR_ReportResult
	//s tmpStr=tmpStr_bpaId_"^"  //
	s mainOeoriId="",subOeoriId="",oecprDesc="",phcinDesc="",prcfrDesc="",oeoriNote="",curAbbreviate="",bprOrdItemNote="",bprMainBprDr="",bprRemarks="",bprBppiDr=""
	s $p(tmpStr,"^",47)="^"
	s curUserDesc="aa"
	s ^TMPBP("Order",$j,bpaId,updateDateTime,bpcoId,bpcdSub)=$lb(curId,curbpcoId,oeoreId,curUserId,curUserDesc,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,bprConcentration,bprOriginateFromBprdr,phcinId,ancvcId,bprFlag,bprDrugMode,bprSpeed,curUpdateDate,curUpdateTime,bprReason,curEditFlag,curEditedId,bprRecLocId,curDocUserId,bprVolume,bprSpeedUnitDr,bprSource,bprType,ancoDesc,arcimDesc,bprPreparedVolume,bprAttachOeoriId,bprReportResult,bpaId,mainOeoriId,subOeoriId,oecprDesc,phcinDesc,prcfrDesc,oeoriNote,curAbbreviate,bprOrdItemNote,bprMainBprDr,bprRemarks,bprBppiDr)
	q 0
    
OutputBPRecord
    s ^TMPzt("gotobp",8)=2
	//s Data=$lb(curId,curbpcoId,oeoreId,curUserId,curStartDate,curStartTime,curEndDate,curEndTime,arcimId,curNote,curQty,uomId,bprConcentration,bprOriginateFromBprdr,phcinId,ancvcId,bprFlag,bprDrugMode,bprSpeed,curUpdateDate,curUpdateTime,bprReason,curEditFlag,curEditedId,bprRecLocId,curDocUserId,bprVolume,bprSpeedUnitDr,bprSource,bprType,ancoDesc,arcimDesc,bprPreparedVolume,bprAttachOeoriId,bprReportResult,bpaId,mainOeoriId,subOeoriId,oecprDesc,phcinDesc,prcfrDesc,oeoriNote,curAbbreviate,bprOrdItemNote,bprMainBprDr,bprRemarks,bprBppiDr)
	//s Data=$lb(Id,RecordItemId,OeoreId,UserId,StartDate,StartTime,EndDate,EndTime,ArcimId,Note,Qty,UomId,Concentration,OriginalOrderId,InstrId,RecordCatId,Flag,DrugMode,Speed,UpdateDate,UpdateTime,Reason,EditFlag,EditedBprId,RecvLoc,DocUserId,Volume,SpeedUnitId,Source,Type,BpcoDesc,ArcimDesc,PrepareIntake,AttachOeoriId,Report,ArrangeId,MainOeoreId,SubOrderId,Priority,Instruction,Frequency,OeoriNote,Abbreviate,OrderItemNote,MainBprId,Remarks,ParaItemId)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindBPRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPRecordExecute ]
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

ClassMethod FindBPRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPRecordExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
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
ClassMethod GetOeordItemInfo(oeoriId As %String) As %String
{
	//w ##class(web.DHCBPRecord).GetOeordItemInfo("911637||7")
	s oeoriSub=$p(oeoriId,"||",2)
	q:oeoriSub="" ""
	s oeordId=+oeoriId
	s oeoriId=oeordId_"||"_oeoriSub
	s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoriId)
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
	s volume=##Class(web.DHCANOPCom).GetVolume(oeoriId)
	s arcicOrderType=##Class(web.DHCCLCom).GetOrdSubCatType(oeoriId)
	s subOeoriId=""
	i oeoriSub'="" d
	    .s curOriSub=""
	    .f  s curOriSub=$o(^OEORDi(0,"OEORI",oeordId,oeoriId,curOriSub)) q:(curOriSub="")  d
			..s curArcimId=$p(^OEORD(oeordId,"I",curOriSub,1),"^",2)
			..s arcimDesc=$p($g(^ARCIM(+curArcimId,+$p(curArcimId,"||",2),1)),"^",2)
			..q:arcimDesc=""
		    ..q:(arcicOrderType="R")&(##Class(web.DHCCLCom).GetOrdSubCatType(oeordId_"||"_curOriSub)'=arcicOrderType)
		    ..i subOeoriId'="" s subOeoriId=subOeoriId_"!"
		    ..s subOeoriId=subOeoriId_oeordId_"||"_curOriSub
		    ..s volume=volume+##Class(web.DHCANOPCom).GetVolume(oeordId_"||"_curOriSub)
	
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

// 检测DHC_BP_BedEquip表中配置的所以病区的采集数据

// 返回值:最来返执行最来一个locId的的返回值

// w ##class(web.DHCBPRecord).ComfirmCollectData()

ClassMethod ComfirmCollectData(isDebug As %String = "") As %String
{
	s time=$p($h,",",2)
	s hour=time\3600
	s min=(time-(hour*3600))\60
	;i hour=0 k ^DHCANBPDEBUG // 零点清除日志
	s dStr=$zd($p($h,",",1))
	s iDate=+$p(dStr,"/",2)
	// 23点清除数据
	i hour=23 d ##class(web.DHCBPRecord).ClearLog(iDate)
	
	s ^tmpBPDebug("ComfirmCollectData","First")=$zt($p($h,",",2))
	s bedId="" s locId="" s retStr=""
	// 查找DHC_BP_BedEquip表中配置的所以病区的locId
	f  s bedId=$O(^DHCBPBedEquip(0,"Bed",bedId)) q:bedId=""  d
	.s wardId=+bedId
	.s wardLocId=$p(^PAWARD(+wardId),"^",5)
	.q:wardLocId=""
	.s PLIST(wardLocId)=wardLocId
	// 循环执行每一个科室
	m ^TMPBPDEBUG("ComfirmCollectData","locId")=PLIST
	f  s locId=$O(PLIST(locId)) q:locId=""  d
	.SET $ZTRAP="ERR"
	.;b
	.q:isDebug'=""
	.s retStr=..ConfirmSingleCollectData("","","",locId)
	.
	
	// 启动共享设备 "S^1^10.160.16.30^4001^5000^35^"
	s sub=""
	f  s sub=$O(^DHCCLSet("ShareDev",sub)) q:sub=""  d
	.
	.s item=^DHCCLSet("ShareDev",sub)
	.q:item=""
	.s source=$p(item,"^",1)
	.s eqId=$p(item,"^",2)
	.s ip=$p(item,"^",3)
	.s port=$p(item,"^",4)
	.s sti=$p(item,"^",5)
	.s eqTypeId=$p(item,"^",6)
	.q:eqTypeId=""
	.s interfaceProgram=$p($g(^DHCANC("CType",eqTypeId)),"^",1)
	.q:interfaceProgram=""
	.;b "Start Sahre Dev"
	.s retStr=##class(web.DHCANCom).StartDevTask("","",eqId,source,"",ip,port,sti,interfaceProgram,"")   
	// 启动当前所以需要监护的任务
	d ##class(web.DHCBPCom).StartAllTask()
	
	q retStr
	
ERR
	s ^TMPBPDEBUG("ComfirmCollectData",$ztime($p($h,",",2)))=$zerror
	q
}

// 返回值:

// 1:插入当前时间已确认，2:无插入项，0:成功(有插入项)

// w ##class(web.DHCBPRecord).ConfirmSingleCollectData("","","",locId)

// w ##class(web.DHCBPRecord).ConfirmSingleCollectData("",,"",locId)

ClassMethod ConfirmSingleCollectData(bpaId As %String = "", date As %String = "", time As %String = "", ctlocId As %String = "", isCurTime As %String = "") As %String
{
	// w ##class(web.DHCBPRecord).ConfirmCollectData("","","",56)
	s ^tmpBPDebug("Comfirm",$p($h,",",1),$p($h,",",2))="in"_$zdate($p($h,",",1))_$ztime($p($h,",",2))
	q:(bpaId="")&(ctlocId="") 0
	s wardId=+$p($g(^DHCBPArrange(+bpaId)),"^",4)
	i wardId=0 s wardId=""
	q:(wardId="")&(ctlocId="") 0
	// 初始化comItems
	i $o(^DHCCLSet("ComfirmData","GroupData"))="" d Init
	e  m comItems=^DHCCLSet("ComfirmData","GroupData")
	b "xx"

	s lastTime=""
	s min=+$g(^DHCCLSet("BP","ConfirmedTime")) ;入库间隔分钟数
	i min=0 s min=60
	s sti=min*60 ;入库间隔时间(以秒为单位)
	s ssti=10*60 ;采集间隔
	s scope=2*ssti ;入库时间振幅
	i (date="")!(time="") d
	.;以当前时间为基准计算
	.s date=$p($h,",",1)
	.s time=$p($h,",",2)
	.s lastTime=$g(^DHCCLSet("BP","ConfirmedDateTime",ctlocId)) ;上次入库时间
	i isCurTime="" d
	.s time=((time+(sti/2))\sti)*sti
	.i time=(24*3600) s time=0  s date=date+1 b
	b "befor"
	// 已确认则退出
	q:(date=$p(lastTime,"^",1))&(time=$p(lastTime,"^",2)) 1
	i isCurTime="" s ^DHCCLSet("BP","ConfirmedDateTime",ctlocId)=date_"^"_time

	s patientList=##class(web.DHCBPCom).FindWardPatient(wardId, ctlocId)
	q:patientList="" 0
	s isConfirmed=0
	s retStr=2
	b "begin"
	s paraBpaId=bpaId ;传入的bpaId
	f i=1:1:$l(patientList,"^") d
		.q:isConfirmed
		.q:$p(patientList,"^",i)=""
		.s bpaId=$p($p(patientList,"^",i),"|",4)
		.q:bpaId=""
		.;根据isCurTime=true时，根据只查找指定的bpaId
		.q:(isCurTime="true")&&(paraBpaId'=bpaId)
		.q:$p(^DHCBPArrange(bpaId),"^",18)'="M"
		.s bprId=""
		.f  s bprId=$o(^DHCBPRecord(0,"SttDateTime",date,bpaId,time,bprId)) q:(bprId="")!(isConfirmed)  d
			..q:'$d(^DHCBPRecord(bprId))
			..i $p(^DHCBPRecord(bprId),"^",29)="A" s isConfirmed=1
		.k ancoList
		.b "ss"
		.s curDate=date
		.s curTime=time
		.i curTime=0 s curTime=86400,curDate=curDate-1
		.s isExit=0
		.f  s curTime=$o(^DHCBPArrange(0,"CData",bpaId,curDate,curTime),-1) q:(curTime="")!(isExit)  d
			..
			..i $zabs(((date*3600*24)+time)-((curDate*3600*24)+curTime))>scope s isExit=1 q //十分钟内数据
			..
			..s bpcdSub=""
			..f  s bpcdSub=$o(^DHCBPArrange(0,"CData",bpaId,curDate,curTime,bpcdSub)) q:bpcdSub=""  d
				...q:'$d(^DHCBPArrange(bpaId,"C",bpcdSub))
				...q:$p(^DHCBPArrange(bpaId,"C",bpcdSub),"^",1)=""
				...q:$d(ancoList($p(^DHCBPArrange(bpaId,"C",bpcdSub),"^",1)))
				...s ancoList($p(^DHCBPArrange(bpaId,"C",bpcdSub),"^",1))=bpcdSub
		.b "begin2"
		.s bpcoId=""
		.f  s bpcoId=$o(ancoList(bpcoId)) q:bpcoId=""  d
			..
			..s bpcdSub=ancoList(bpcoId)
			..q:'$d(^DHCBPArrange(bpaId,"C",bpcdSub))
			..s txtValue=$p(^DHCBPArrange(bpaId,"C",bpcdSub),"^",4) //BPR_Note
			..s numValue=$p(^DHCBPArrange(bpaId,"C",bpcdSub),"^",5) //BPR_Qty
			..d Insert2BPRecord
			..;b "Insert"
			..// 组合项数据收集
			..s itemName=$p($g(^DHCANC("ComOrd",bpcoId)),"^",1)
			..s itemValue="" s txtValue=""
			..i itemValue="" s itemValue=numValue
			..
			..s isub=""
			..f  s isub=$o(comItems(isub)) q:isub=""  d  
			...s comItem=comItems(isub)
			...i comItem[itemName s comItems(isub,bpaId,itemName)=itemValue
			..
		.// 组合项
		.s txtValue=""
		.s numValue=""
		.s isub=""
		.
		.f  s isub=$o(comItems(isub)) q:isub=""  d 
		..;b "After s isub=$o(comItems(isub)) q:isub=""  d "
		..s csub="" s csub=$o(comItems(isub,bpaId,csub))
		..q:csub=""
		..s bpcoId=isub
		..s txtValue=comItems(isub,"format") ;{0}/{1}({2})
		..s count=$l(txtValue,"{")-2
		..s nullValue=txtValue
		..f j=0:1:count d
		...;s fStr=$REPLACE("{N}","N",j);2010以上
		...s fStr=..Replace("{N}","N",j)
		...
		...s itemName=$p(comItems(isub),";",j+1)
		...i itemName="" s aValue=""
		...e  s aValue=$g(comItems(isub,bpaId,itemName))
		...
		...;s txtValue=$REPLACE(txtValue,fStr,aValue) ;2010以上
		...s txtValue=..Replace(txtValue,fStr,aValue)
		...s nullValue=..Replace(nullValue,fStr,"")
		..;b "After i aValue'="" s txtValue=$REPLACE(txtValue,fStr,aValue)"
		..;如果值为空则退出
		..;b "如果值为空则退出"
		..q:nullValue=txtValue  
		..d Insert2BPRecord
	q retStr
	
Insert2BPRecord	
	// 查询后插入
	b "Insert2BPRecord1"
	s isFind=0
	s sub=""
	f  s sub=$o(^DHCBPRecord(0,"SttDateTime",date,bpaId,time,sub)) q:((sub="")||(isFind=1))  d
	.s ctuomId=$p($g(^DHCBPRecord(sub)),"^",2)
	.i ctuomId=bpcoId s isFind=1 	 
	q:isFind=1
	b "Insert2BPRecord2"
	k PLIST
	s PLIST(2)=bpaId //bpaId
	s PLIST(3)=bpcoId //bpcoId
	s PLIST(5)="" //userId
	s PLIST(6)=date //startDate
	s PLIST(7)=time //startTime
	s PLIST(8)=date //endDate
	s PLIST(9)=time //endTime
	s PLIST(11)=txtValue
	s PLIST(12)=numValue
	s PLIST(13)="" //ctuomId
	s PLIST(17)=$p($g(^DHCANC("ComOrd",bpcoId)),"^",5) //ancvcId
	s PLIST(18)="N" //BPR_Flag
	s PLIST(22)=+$h //BPR_UpdateDate
	s PLIST(23)=$p($h,",",2) //BPR_UpdateTime
	s PLIST(24)="" //BPR_BPR_Dr
	s PLIST(26)="N" //BPR_EditFlag
	s PLIST(30)="I" //BPR_BPR_Source
	s PLIST(31)=$p($g(^DHCANC("ComOrd",bpcoId)),"^",3) //BPR_Type
	&SQL(Insert into DHC_BP_Record Values :PLIST())
	i SQLCODE s retStr=bprId_":BP SQLCODE:"_SQLCODE //bprId"插入数据错! SQLCode="_SQLCODE
	s ^tmpBPDebug("Comfirmed",$h)=SQLCODE_",rowId="_$g(%ROWID)
	s retStr=0
	q 
Init
	// 组合项初始化
	s comOrd=""
	b "Init"
	f  s comOrd=$o(^DHCANC("ComOrd",comOrd)) q:comOrd=""  d
	.s comItem=$g(^DHCANC("ComOrd",comOrd))
	.s cTypeID=$p(comItem,"^",5)
	.q:cTypeID=""
	.s cTypeCode=$p($g(^DHCANC("ViewCat",cTypeID)),"^",1) // 类型:只处理生命体征
	.q:cTypeCode=""
	.s forStr=$p(comItem,"^",25)
	.s paraStr=$p(comItem,"^",27)
	.
	.i ($p(comItem,"^",24)="Note")&((cTypeCode="VitalSign")||(cTypeCode="BPBloodAnalysis")||(cTypeCode="BPBloodAnalysis")||(cTypeCode="RespiratorySupport")||(cTypeCode="HF"))&(forStr["{0}") d
	..s comItems(comOrd)=$p(comItem,"^",27) ;NSBP;NDBP;NMBP
	..s comItems(comOrd,"format")=$p(comItem,"^",25) ; {0}/{1}({2})	
	m ^DHCCLSet("ComfirmData","GroupData")=comItems	
	q
}

/// 批量保存重症监护数据
/// orderParaList由重症监护数据串拼接而成，以"^"分割。数据串以$c(3)分割，按照表DHC_BP_Record的SqlColumnNumber顺序拼接而成。
/// 数据串第一个字段固定为数据的RowId(BPR_RowId)，如果是新增的数据，那么第一个字段为空。
/// 返回结果为保存后的数据Id串，以"^"分割
ClassMethod SaveBPRecord(recordParaList As %String) As %String
{
	s result=""
	f i=1:1:$l(recordParaList,"^")  d
	.s recordPara=$p(recordParaList,"^",i)
	.q:recordPara=""
	.s recordObj=..SetBPRecordValue(recordPara)
	.d recordObj.%Save()
	.i result'="" s result=result_"^"
	.s result=result_recordObj.%Id()
	.d recordObj.%Close()
	q result
}

ClassMethod SetBPRecordValue(recordPara As %String) As User.DHCBPRecord
{
	s recordId=$p(recordPara,$c(3),1)
	s record=""
	q:(recordPara="") record
	i recordId=""  s record=##class(User.DHCBPRecord).%New()
	e  s record=##class(User.DHCBPRecord).%OpenId(recordId)
	s record.BPRBPArrangeDr=##class(User.DHCBPArrange).%OpenId($p(recordPara,$c(3),2))
	s record.BPRBPCRecordItemDr=##class(User.DHCBPCRecordItem).%OpenId($p(recordPara,$c(3),3))
	s record.BPROeoriDr=$p(recordPara,$c(3),4)
	s record.BPRUpdateUserDr=$p(recordPara,$c(3),5)
	s record.BPRStartDate=##class(web.DHCANOPCom).ConvertToDateH($p(recordPara,$c(3),6))
	s record.BPRStartTime=##class(web.DHCANOPCom).ConvertToTimeH($p(recordPara,$c(3),7))
	s record.BPREndDate=##class(web.DHCANOPCom).ConvertToDateH($p(recordPara,$c(3),8))
	s record.BPREndTime=##class(web.DHCANOPCom).ConvertToTimeH($p(recordPara,$c(3),9))
	s record.BPRArcimDr=$p(recordPara,$c(3),10)
	s record.BPRNote=$p(recordPara,$c(3),11)
	;i recordId'="" d
	.;s record.BPRQty=+$p(recordPara,$c(3),12)
	s record.BPRQty=$p(recordPara,$c(3),12)
	s record.BPRUomDr=$p(recordPara,$c(3),13)
	s record.BPRInstrctDr=$p(recordPara,$c(3),14)
	s record.BPRBPCRecordCatDr=##class(User.DHCBPCRecordCat).%OpenId($p(recordPara,$c(3),15))
	s record.BPRSpeed=+$p(recordPara,$c(3),16)
	s speedUnitId=$p(recordPara,$c(3),17) 
	i speedUnitId'="" s record.BPRSpeedUnitDr=##class(User.DHCANCSpeedUnit).%OpenId(speedUnitId)
	s record.BPRUpdateDate=##class(web.DHCANOPCom).ConvertToDateH($p(recordPara,$c(3),18))
	s record.BPRUpdateTime=##class(web.DHCANOPCom).ConvertToTimeH($p(recordPara,$c(3),19))
	s record.BPREditStatus=$p(recordPara,$c(3),20)
	s record.BPRRecLocDr=$p(recordPara,$c(3),21)
	s record.BPRSource=$p(recordPara,$c(3),22)
	s record.BPRType=$p(recordPara,$c(3),23)
	s record.BPRAbbreviate=$p(recordPara,$c(3),24)
	q record
}

ClassMethod Replace(str As %String, subStr As %String, value As %String) As %String
{
	s i=$find(str,subStr)
	s begin=i-$L(subStr)-1	
	s str=$E(str,1,begin)_value_$E(str,i,$L(str))
	q str
}

ClassMethod SetMainSubBpcoList(bpaId As %String, mainList As %String) As %String
{
	q:+bpaId=0 -1
	s bpaId = +bpaId
	s wardId=+$p(^DHCBPArrange(bpaId),"^",4)
	
	s wardCtlocId=$p(^PAWARD(wardId),"^",5)
	q:wardCtlocId="" -2
	s bppId=$o(^DHCBPPara(0,"Ctloc",wardCtlocId,""))
	q:bppId="" -3
	s bppiSub=0
	f  s bppiSub=$o(^DHCBPPara(bppId,"I",bppiSub)) q:bppiSub=""  d
		.s bpcoId=$p(^DHCBPPara(bppId,"I",bppiSub),"^",4)
		.q:'$d(^DHCANC("ComOrd",bpcoId))
		.q:$p(^DHCANC("ComOrd",bpcoId),"^",3)'="D"
		.q:$p(^DHCANC("ComOrd",bpcoId),"^",23)=""
		.s mainList($p(^DHCANC("ComOrd",bpcoId),"^",23),bpcoId)=$p(^DHCANC("ComOrd",bpcoId),"^",24)
		.//w $p(^DHCANC("ComOrd",bpcoId),"^",23)_"    "_bpcoId_"/"_$p(^DHCANC("ComOrd",bpcoId),"^",24),!
	q 0
}

// ##class(web.DHCBPRecord).ClearLog(date)

// 清除前10天的数据，如25号清除15号的数据

ClassMethod ClearLog(iDate As %String)
{
	s source="",eqId="",date=""
	f  s source=$o(^DHCANBPDEBUG("InsertToOrder",source)) q:source=""  d
	.f  s eqId=$o(^DHCANBPDEBUG("InsertToOrder",source,eqId)) q:eqId=""  d
	..f  s date=$o(^DHCANBPDEBUG("InsertToOrder",source,eqId,date)) q:date=""  d
	...s span=date-iDate
	...i $zabs(span)=10 k ^DHCANBPDEBUG("InsertToOrder",source,eqId,date) w date,!
	q "0"
}

/// 获取监护记录项目值
/// w ##Class(web.DHCBPRecord).GetBPRecordValue("69673",1)
ClassMethod GetBPRecordValue(bpaId As %String, recordItemId As %String, dataField As %String = "")
{
	s retStr="",MinV="",MaxV="",MinDT="",MaxDT=""
	q:(bpaId="")||(recordItemId="") retStr
	s bprId=""
	f  s bprId=$o(^DHCBPRecord(0,"RecordItem",recordItemId,bpaId,bprId)) q:bprId=""  d	
		.s curDate=$zd($li(^DHCBPRecord(bprId),5),3)
		.s curTime=$zt($li(^DHCBPRecord(bprId),6),2)
		.s curQty=$li(^DHCBPRecord(bprId),14)
		.s editStatus=$li(^DHCBPRecord(bprId),10)		
		.q:(editStatus="D")
		.i (dataField="Min")||(dataField="MinDT") d
			..i MinV="" s MinV=curQty,MinDT=curQty_" "_curDate_" "_curTime
			..i curQty<MinV s MinV=curQty,MinDT=curQty_" "_curDate_" "_curTime
			..i (dataField="Min") s retStr=MinV	
			..i (dataField="MinDT") s retStr=MinDTV
		.e  i (dataField="Max")||(dataField="MaxDT") d
			..i MaxV="" s MaxV=curQty,MaxDT=curQty_" "_curDate_" "_curTime
			..i curQty>MaxV s MaxV=curQty,MaxDT=curQty_" "_curDate_" "_curTime
			..i (dataField="Max") s retStr=MaxV	
			..i (dataField="MaxDT") s retStr=MaxDT
		.e  i dataField="touchQty" d  //连续值
			..i retStr="" s retStr=curQty_" "_curDate_" "_curTime
			..e  s retStr=retStr_"#"_curQty_" "_curDate_" "_curTime
		.e  s retStr=curQty
	q retStr
}

/// w ##class(web.DHCBPRecord).GetLastResultByRId(48,1)
ClassMethod GetLastResultByRId(ArrangeId As %String, recordId As %String) As %String
{
	s bprId=$o(^DHCBPRecord(0,"RecordItem",recordId,ArrangeId,""),-1)
	s curQty=$li(^DHCBPRecord(bprId),14)
	s curNote=$li(^DHCBPRecord(bprId),15)
	;b
	q curQty
}

}
