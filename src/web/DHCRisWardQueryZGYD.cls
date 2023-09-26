Import SQLUser

Class web.DHCRisWardQueryZGYD Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 21;

// 登记日期，登记时间，病人状态

/// d ##class(%ResultSet).RunQuery("web.DHCRisWardQueryZGYD","QueryItemByWard","^^^^I^^^^687","62578","62810")
/// d ##class(%ResultSet).RunQuery("web.DHCRisWardQueryZGYD","QueryItemByWard","^^^^B^^^^687","62578","62810")
Query QueryItemByWard(strCondition As %String, startdate As %String, enddate As %String) As %Query(ROWSPEC = "Tregno:%String,Tname:%String,Tsex:%String,Tbedno:%String,Titemname:%String,TstrDate:%String,TstrTime:%String,Tdepname:%String,TPatientStatus:%String,TAppointDate:%String,TAppointstTime:%String,TResDesc:%String,TstrRegDate:%String,TstrRegTime:%String,TStudyNo:%String,TReportDoc:%String,TReportVerifyDoc:%String,TRisStatusDesc:%String,Twarddesc:%String,TAge:%String,PrintFalg:%String,OEOrdItemID:%String,MeothodDesc:%String,RecLocDR:%String,IsSend:%String,Memo:%String,BookedNo:%String")
{
}

ClassMethod QueryItemByWardExecute(ByRef qHandle As %Binary, strCondition As %String, startdate As %String, enddate As %String) As %Status
{
   
   s ^DHCRis("TEMPXX")=strCondition_"&&&"_startdate_"&&&"_enddate
   
   
   s ward=$p(strCondition,"^",1)
   s ward=$p(ward,$c(0))
   i ward="" s ward=%session.Get("LOGON.WARDID")
   
   s ArcItemRowid=$p(strCondition,"^",2)
   s ArcItemRowid=$p(ArcItemRowid,$c(0))
   
   s InRegNo=$p(strCondition,"^",3)
   s InRegNo=$p(InRegNo,$c(0))
   
   s InStudyNo=$p(strCondition,"^",4) 
   s InStudyNo=$p(InStudyNo,$c(0))
   
   s RisStatusCode=$p(strCondition,"^",5)
   s RisStatusCode=$p(RisStatusCode,$c(0))
   
   s RecLocId=$p(strCondition,"^",6)
   s RecLocId=$p(RecLocId,$c(0))
   
   s IsPrint=$p(strCondition,"^",7)
   s IsPrint=$p(IsPrint,$c(0))
   
   s InIsBedOrd=$p(strCondition,"^",8)
   s InIsBedOrd=$p(InIsBedOrd,$c(0))
   
   s InUserId=$p(strCondition,"^",9)
   s InUserId=$p(InUserId,$c(0))
   i InUserId="" s InUserId="71"
   
   s IsNoBK=$p(strCondition,"^",10)
   
   s BKDesc=$p(strCondition,"^",11)
   s BKDesc=$p(BKDesc,$c(0))
   k ^DHCRISTEMPWARDQUERYDATA($g(InUserId))
   
   Set repid=$I(^CacheTemp)
   If $g(ind)="" Set ind=1
   
   if (ward'="")
   {
	    s return=..QueryWardItem(ward, ArcItemRowid, InRegNo, InStudyNo, RisStatusCode, RecLocId, IsPrint, InIsBedOrd, InUserId, startdate, enddate, IsNoBK,BKDesc)
	    Quit $$$OK
   }
   elseif ((RisStatusCode="")!(RisStatusCode="S"))
   {
	   s return=..QueryAllItembyDate(ward, ArcItemRowid, InRegNo, InStudyNo, RisStatusCode, RecLocId, IsPrint, InIsBedOrd,InUserId, startdate, enddate,IsNoBK) 
	   Quit $$$OK
   }
   elseif (RisStatusCode="A")
   {
       s return=..QueryByItemDate(ward, ArcItemRowid, InRegNo, InStudyNo, RisStatusCode, RecLocId, IsPrint, InIsBedOrd,InUserId, startdate, enddate,IsNoBK)
       Quit $$$OK
   }
   elseif (RisStatusCode="B")
   {
       s return=..QueryBookedItem(ward, ArcItemRowid, InRegNo, InStudyNo, RisStatusCode, RecLocId, IsPrint, InIsBedOrd, InUserId,startdate, enddate,IsNoBK)
       Quit $$$OK
   }else
   {
       s return=..QueryByRegDate(ward, ArcItemRowid, InRegNo, InStudyNo, RisStatusCode, RecLocId, IsPrint, InIsBedOrd,InUserId,startdate, enddate)
       Quit $$$OK 
   }
}

ClassMethod QueryItemByWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryItemByWardExecute ]
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

ClassMethod QueryItemByWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryItemByWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryAllItembyDate(ward, ArcItemRowid, InRegNo, InStudyNo, RisStatusCode, RecLocId, IsPrint, InIsBedOrd, InUserId, startdate, enddate, IsNoBK)
{
	for date=startdate:1:enddate
    {
       s OrderRowid=0  f  s OrderRowid=$o(^OEORDi(0,"ItemDate",date,OrderRowid)) q:(OrderRowid="")  d
       .;q:(RisStatusCode="")
       .s itemsub=0  f  s itemsub=$o(^OEORDi(0,"ItemDate",date,OrderRowid,itemsub)) q:(itemsub="")  d
       ..s Oeorditemdr=OrderRowid_"||"_itemsub
       ..;w !,"Oeorditemdr="_Oeorditemdr
       ..s IsBKFlag="",IsRegFlag=""
       ..;s IsBKFlag=..GetBKFlag(Oeorditemdr)
       ..;q:(IsBKFlag="Y")
       ..;s IsRegFlag=..GetRegFlag(Oeorditemdr)
       ..;q:(IsRegFlag="Y")
       ..s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
       ..s MeothodDesc="",Memo=""
       ..s MeothodDesc=..RequestBookType(arcimid)
       ..;q:((IsNoBK="Y")&((MeothodDesc=" ")!(MeothodDesc="")!(MeothodDesc'="不需预约")))
       ..q:((IsNoBK="Y")&((MeothodDesc'="不需预约")&(MeothodDesc'="")))
       ..s IsSend=""
       ..s IsSend=..IsSendAppBill(Oeorditemdr)
       ..s RecLocdr=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)
       ..q:(RecLocId'="")&(RecLocId'=RecLocdr)
       ..q:(ArcItemRowid'="")&(ArcItemRowid'=arcimid)
       ..s PrintFalg=""
       ..s PrintFalg=$g(^DHCRISORDITEMPRINTED(Oeorditemdr))
       ..i PrintFalg="" s PrintFalg="N"
       ..;q:(PrintFalg'="")&(IsPrint'=PrintFalg)
       ..q:(IsPrint'="")&(IsPrint'=PrintFalg)
       ..s IsMemo=""
       ..s IsMemo=##class(web.DHCRisCommFunctionEx).ExistMemo(Oeorditemdr)
       ..i IsMemo="Y" s Memo="浏览"
       ..s bOut="N"  ;是否已经输出
       ..s paadmdr=$p(^OEORD(OrderRowid),"^",1) 
       ..s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
	   ..s GetRegNo=$p(PatInfo,"^",1)
	   ..q:(InRegNo'="")&(InRegNo'=GetRegNo)
	   ..;w !,"GetRegNo"_GetRegNo
	   ..s GetName=$p(PatInfo,"^",2)
	   ..s GetstrDOB=$p(PatInfo,"^",3)
	   ..s GetstrAge=$p(PatInfo,"^",4)
	   ..s GetstrAge=$p(GetstrAge," ")
	   ..s GetSexDesc=$p(PatInfo,"^",5)
	   ..s Getpatienttype=$p(PatInfo,"^",6)
	   ..q:(Getpatienttype'="I")
	   ..s Gettypedesc=$p(PatInfo,"^",7)
	   ..s GetLocName=$p(PatInfo,"^",8)
	   ..s GetIPNo=$p(PatInfo,"^",9)       ;住院号
	   ..s GetWardName=$p(PatInfo,"^",10)
	   ..s GetBedNo=$p(PatInfo,"^",11)
	   ..s GetReqLocDR=$p(PatInfo,"^",12)
	   ..s GetWardDR=$p(PatInfo,"^",14)
	   ..q:(ward'="")&(ward'=GetWardDR)
	   ..s Getroomdesc=$p(PatInfo,"^",15)
	   ..s GetSexDr=$p(PatInfo,"^",13)
	   ..s PapatmasDR=$p(PatInfo,"^",24)
	   ..s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(OrderRowid,itemsub)
	   ..s GetPatientStatusCode="A"
       ..s GetstrOrderName=$p(ordInfo,"^",1)
       ..q:(InIsBedOrd="N")&(GetstrOrderName["床旁")
       ..q:(InIsBedOrd="Y")&(GetstrOrderName'["床旁")
       ..s GetstrDate=$p(ordInfo,"^",2)
       ..s GetstrTime=$p(ordInfo,"^",3)
       ..s Getifbed=$p(ordInfo,"^",9)
       ..s GetItemStatusCode=$p(ordInfo,"^",14)
       ..s GetRecLocName=$p(ordInfo,"^",21)
       ..q:(GetItemStatusCode="U")!(GetItemStatusCode="D") ;过滤作废或停止医嘱
       ..s GetordDate=$p(ordInfo,"^",15)
       ..s GetordTime=$p(ordInfo,"^",16)
       ..s GetItemStatusCode=$p(ordInfo,"^",17)   			;医嘱状态
       ..s GetServerMaterial=$p(ordInfo,"^",18)   			;申请项目标记 
       ..q:(GetServerMaterial'="S")
       ..s GetRecLocDR=$p(ordInfo,"^",19)
       ..s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfo(Oeorditemdr)
       ..s GetStudyNo=$p(RegInfo,"^",1)
       ..i GetStudyNo'="" s GetPatientStatusCode="I"
       ..q:(InStudyNo'="")&(InStudyNo'=GetStudyNo)
       ..s GetstrRegDate=$p(RegInfo,"^",2)
       ..s GetstrRegTime=$p(RegInfo,"^",3)
       ..s GetRegDate=$p(RegInfo,"^",17)
       ..s GetResDesc="",strRppDate="",strRppTime=""
       ..i $g(^OEORD(OrderRowid,"I",itemsub,6))'="" d
       ...s Getapprowid=$p(^OEORD(OrderRowid,"I",itemsub,6),"^",5)
       ...i (Getapprowid'="")&(Getapprowid'=$C(0)) d
       ....s ResRowid=$p(Getapprowid,"||",1)
       ....s SchildSub=$p(Getapprowid,"||",2)
       ....s appointchildsub=$p(Getapprowid,"||",3)
       ....s ResDesc=""
 	   ....s CTCPDR=$p($g(^RB("RES",ResRowid)),"^",2)
       ....s CTCPDR=$p(CTCPDR,$c(0))
       ....i CTCPDR'="" d
       .....s GetResDesc=$p($g(^CTPCP(CTCPDR,1)),"^",2)
       ....else  d
       .....s EQDR=$p($g(^RB("RES",ResRowid)),"^",3)
       .....s GetResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
       ....s RppDate=$p(^RBAS(ResRowid,SchildSub),"^",1)
       ....s strRppDate=$zd(RppDate,3)
       ....s RppTime=$p(^RBAS(ResRowid,SchildSub),"^",4)
       ....s strRppTime=$zt(RppTime,1)
       ..s GetReportStatusCode="N"     ;未写报告
       ..s GetImgcount=0
       ..s GetRptID=""
       ..s GetRptDocDR="",GetRptDocName="",GetRptDate="",GetRptTime="",GetVerifyDocDR=""
       ..s GetVerifyDocName="",GetVerifyDate="",GetVerifyTime="",HaveImage=""
       ..i GetStudyNo'="" d
       ...s Imrowid=0 f  s Imrowid=$o(^DHCRBStudyi("StudyNo-Images",GetStudyNo,Imrowid)) q:Imrowid=""  d
       ....s GetPatientStatusCode="E"    ;正在检查
       ....s ExtName=$p($g(^DHCRBStudy(0,"StudyImages",Imrowid)),"^",2)
       ....i ((ExtName="avi")!(ExtName="dcm")!(ExtName="normal")!(ExtName="dsa"))  d
       .....s GetImgcount=GetImgcount+1
       .....s GetReportStatusCode="I"             ;图象已经采集
       .....s HaveImage="是"
       ...s ReportStuatCode="VS"
       ...s Rptrowid=0  f  s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",GetStudyNo,Rptrowid)) q:Rptrowid=""  d
       ....s GetRptID=$p(^DHCRBStudy("Report",Rptrowid),"^",2)
       ....s GetRptVersion=$p(^DHCRBStudy("Report",Rptrowid),"^",3)
       ....s GetRptStatusDR=$p(^DHCRBStudy("Report",Rptrowid),"^",4)
       ....i GetRptStatusDR'="" d
       .....s GetReportStatusCode=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",1)
       .....i ReportStuatCode[GetReportStatusCode d
       ......s GetPatientStatusCode="O"
       .....e  d
       ......s GetPatientStatusCode="E"
       .....s GetRptStatusDesc=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",2)
       ....s GetRptIsYX=$p(^DHCRBStudy("Report",Rptrowid),"^",7)
       ....s GetRptDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",8)
       ....i GetRptDocDR'="" s GetRptDocName=$p(^SSU("SSUSR",GetRptDocDR),"^",2)
       ....s GetRptDate=$p(^DHCRBStudy("Report",Rptrowid),"^",9)
       ....i GetRptDate'="" s GetRptDate=$zd(GetRptDate,3)
       ....s GetRptTime=$p(^DHCRBStudy("Report",Rptrowid),"^",10)
       ....i GetRptTime'="" s GetRptTime=$zt(GetRptTime,3)
       ....s GetVerifyDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",11)
       ....i GetVerifyDocDR'="" s GetVerifyDocName=$p(^SSU("SSUSR",GetVerifyDocDR),"^",2)
       ....s GetVerifyDate=$p(^DHCRBStudy("Report",Rptrowid),"^",12)
       ....i GetVerifyDate'="" s GetVerifyDate=$zd(GetVerifyDate,3) 
       ....s GetVerifyTime=$p(^DHCRBStudy("Report",Rptrowid),"^",13)
       ....i GetVerifyTime'="" s GetVerifyTime=$zt(GetVerifyTime,3)
       ....s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
       ....q:((RisStatusCode'="")&(RisStatusCode'="S")&(RisStatusCode'=GetPatientStatusCode))
       ....s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
       ....s bOut="Y"
       ....Do OutRowALLItemDate
       ..i bOut="N" d
       ...s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
       ...q:((RisStatusCode'="")&(RisStatusCode'="S")&(RisStatusCode'=GetPatientStatusCode))
       ...s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
       ...s bOut="Y"
       ...Do OutRowALLItemDate
    }
    
   s Count=..QueryBookedItem(ward, ArcItemRowid, InRegNo, InStudyNo, RisStatusCode, RecLocId, IsPrint, InIsBedOrd, InUserId,startdate, enddate,IsNoBK)
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK   
   
OutRowALLItemDate
    set Data=$lb(GetRegNo,GetName,GetSexDesc,GetBedNo,GetstrOrderName,GetstrDate,GetstrTime,GetRecLocName,GetReportStatus,strRppDate,strRppTime,GetResDesc,GetstrRegDate,GetstrRegTime,GetStudyNo,GetRptDocName,GetVerifyDocName,GetPatientStatus,GetWardName,GetstrAge,PrintFalg,Oeorditemdr,MeothodDesc,$g(GetRecLocDR),$g(IsSend),$g(Memo),$g(BookedNo))
    ;i ((GetRecLocDR'="180")&(GetRecLocDR'="181")) d
    s ^DHCRISTEMPWARDQUERYDATA($g(InUserId),ind)=$g(Oeorditemdr)_"^"_$J_"^"_$g(GetRecLocName)_"^"_$g(GetBedNo)_"^"_$g(GetRegNo)_"^"_$g(GetName)_"^"_$g(GetSexDesc)_"^"_$g(GetstrAge)_"^"_$g(GetstrOrderName)_"^"_$g(GetstrDate)_"^"_$g(GetstrTime)_"^"_$g(strRppDate)_"^"_$g(strRppTime)_"^"_$g(GetstrRegDate)_"^"_$g(GetstrRegTime)_"^"_$g(GetStudyNo)_"^"_$g(GetRptDocName)_"^"_$g(GetVerifyDocName)_"^"_$g(GetPatientStatus)_"^"_$g(GetWardName)_"^"_$g(GetResDesc)_"^"_PrintFalg_"^"_$g(MeothodDesc)_"^"_$g(GetRecLocDR)_"^"_$g(IsSend)
    s ^DHCRISTEMPWARDQUERYDATA($g(InUserId))=ind
   	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
 	quit
}

ClassMethod QueryByItemDate(ward, ArcItemRowid, InRegNo, InStudyNo, RisStatusCode, RecLocId, IsPrint, InIsBedOrd, InUserId, startdate, enddate, IsNoBK)
{
	for date=startdate:1:enddate
    {
       s OrderRowid=0  f  s OrderRowid=$o(^OEORDi(0,"ItemDate",date,OrderRowid)) q:(OrderRowid="")  d
       .;q:(RisStatusCode="")
       .s itemsub=0  f  s itemsub=$o(^OEORDi(0,"ItemDate",date,OrderRowid,itemsub)) q:(itemsub="")  d
       ..s Oeorditemdr=OrderRowid_"||"_itemsub
       ..;w !,"Oeorditemdr="_Oeorditemdr
       ..s IsBKFlag="",IsRegFlag=""
       ..s IsBKFlag=..GetBKFlag(Oeorditemdr)
       ..q:(IsBKFlag="Y")
       ..s IsRegFlag=..GetRegFlag(Oeorditemdr)
       ..q:(IsRegFlag="Y")
       ..s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
       ..s MeothodDesc=""
       ..s MeothodDesc=..RequestBookType(arcimid)
       ..;q:((IsNoBK="Y")&((MeothodDesc=" ")!(MeothodDesc="")!(MeothodDesc'="不需预约")))
       ..q:((IsNoBK="Y")&((MeothodDesc'="不需预约")&(MeothodDesc'="")))
       ..s IsSend="",Memo=""
       ..s IsSend=..IsSendAppBill(Oeorditemdr)
       ..s RecLocdr=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)
       ..q:(RecLocId'="")&(RecLocId'=RecLocdr)
       ..q:(ArcItemRowid'="")&(ArcItemRowid'=arcimid)
       ..s PrintFalg=""
       ..s PrintFalg=$g(^DHCRISORDITEMPRINTED(Oeorditemdr))
       ..i PrintFalg="" s PrintFalg="N"
       ..;q:(PrintFalg'="")&(IsPrint'=PrintFalg)
       ..q:(IsPrint'="")&(IsPrint'=PrintFalg)
       ..s IsMemo=""
       ..s IsMemo=##class(web.DHCRisCommFunctionEx).ExistMemo(Oeorditemdr)
       ..i IsMemo="Y" s Memo="浏览"
       ..s bOut="N"  ;是否已经输出
       ..s paadmdr=$p(^OEORD(OrderRowid),"^",1) 
       ..s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
	   ..s GetRegNo=$p(PatInfo,"^",1)
	   ..q:(InRegNo'="")&(InRegNo'=GetRegNo)
	   ..;w !,"GetRegNo"_GetRegNo
	   ..s GetName=$p(PatInfo,"^",2)
	   ..s GetstrDOB=$p(PatInfo,"^",3)
	   ..s GetstrAge=$p(PatInfo,"^",4)
	   ..s GetstrAge=$p(GetstrAge," ")
	   ..s GetSexDesc=$p(PatInfo,"^",5)
	   ..s Getpatienttype=$p(PatInfo,"^",6)
	   ..q:(Getpatienttype'="I")
	   ..s Gettypedesc=$p(PatInfo,"^",7)
	   ..s GetLocName=$p(PatInfo,"^",8)
	   ..s GetIPNo=$p(PatInfo,"^",9)       ;住院号
	   ..s GetWardName=$p(PatInfo,"^",10)
	   ..s GetBedNo=$p(PatInfo,"^",11)
	   ..s GetReqLocDR=$p(PatInfo,"^",12)
	   ..s GetWardDR=$p(PatInfo,"^",14)
	   ..q:(ward'="")&(ward'=GetWardDR)
	   ..s Getroomdesc=$p(PatInfo,"^",15)
	   ..s GetSexDr=$p(PatInfo,"^",13)
	   ..s PapatmasDR=$p(PatInfo,"^",24)
	   ..s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(OrderRowid,itemsub)
	   ..s GetPatientStatusCode="A"
       ..s GetstrOrderName=$p(ordInfo,"^",1)
       ..q:(InIsBedOrd="N")&(GetstrOrderName["床旁")
       ..q:(InIsBedOrd="Y")&(GetstrOrderName'["床旁")
       ..s GetstrDate=$p(ordInfo,"^",2)
       ..s GetstrTime=$p(ordInfo,"^",3)
       ..s Getifbed=$p(ordInfo,"^",9)
       ..s GetItemStatusCode=$p(ordInfo,"^",14)
       ..s GetRecLocName=$p(ordInfo,"^",21)
       ..q:(GetItemStatusCode="U")!(GetItemStatusCode="D") ;过滤作废或停止医嘱
       ..s GetordDate=$p(ordInfo,"^",15)
       ..s GetordTime=$p(ordInfo,"^",16)
       ..s GetItemStatusCode=$p(ordInfo,"^",17)   			;医嘱状态
       ..s GetServerMaterial=$p(ordInfo,"^",18)   			;申请项目标记 
       ..q:(GetServerMaterial'="S")
       ..s GetRecLocDR=$p(ordInfo,"^",19)
       ..s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfo(Oeorditemdr)
       ..s GetStudyNo=$p(RegInfo,"^",1)
       ..i GetStudyNo'="" s GetPatientStatusCode="I"
       ..q:(InStudyNo'="")&(InStudyNo'=GetStudyNo)
       ..s GetstrRegDate=$p(RegInfo,"^",2)
       ..s GetstrRegTime=$p(RegInfo,"^",3)
       ..s GetRegDate=$p(RegInfo,"^",17)
       ..s GetResDesc="",strRppDate="",strRppTime=""
       ..i $g(^OEORD(OrderRowid,"I",itemsub,6))'="" d
       ...s Getapprowid=$p(^OEORD(OrderRowid,"I",itemsub,6),"^",5)
       ...i (Getapprowid'="")&(Getapprowid'=$C(0)) d
       ....s ResRowid=$p(Getapprowid,"||",1)
       ....s SchildSub=$p(Getapprowid,"||",2)
       ....s appointchildsub=$p(Getapprowid,"||",3)
       ....s ResDesc=""
 	   ....s CTCPDR=$p($g(^RB("RES",ResRowid)),"^",2)
       ....s CTCPDR=$p(CTCPDR,$c(0))
       ....i CTCPDR'="" d
       .....s GetResDesc=$p($g(^CTPCP(CTCPDR,1)),"^",2)
       ....else  d
       .....s EQDR=$p($g(^RB("RES",ResRowid)),"^",3)
       .....s GetResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
       ....s RppDate=$p(^RBAS(ResRowid,SchildSub),"^",1)
       ....s strRppDate=$zd(RppDate,3)
       ....s RppTime=$p(^RBAS(ResRowid,SchildSub),"^",4)
       ....s strRppTime=$zt(RppTime,1)
       ..s GetReportStatusCode="N"     ;未写报告
       ..s GetImgcount=0
       ..s GetRptID=""
       ..s GetRptDocDR="",GetRptDocName="",GetRptDate="",GetRptTime="",GetVerifyDocDR=""
       ..s GetVerifyDocName="",GetVerifyDate="",GetVerifyTime="",HaveImage=""
       ..i GetStudyNo'="" d
       ...s Imrowid=0 f  s Imrowid=$o(^DHCRBStudyi("StudyNo-Images",GetStudyNo,Imrowid)) q:Imrowid=""  d
       ....s GetPatientStatusCode="E"    ;正在检查
       ....s ExtName=$p($g(^DHCRBStudy(0,"StudyImages",Imrowid)),"^",2)
       ....i ((ExtName="avi")!(ExtName="dcm")!(ExtName="normal")!(ExtName="dsa"))  d
       .....s GetImgcount=GetImgcount+1
       .....s GetReportStatusCode="I"             ;图象已经采集
       .....s HaveImage="是"
       ...s ReportStuatCode="VS"
       ...s Rptrowid=0  f  s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",GetStudyNo,Rptrowid)) q:Rptrowid=""  d
       ....s GetRptID=$p(^DHCRBStudy("Report",Rptrowid),"^",2)
       ....s GetRptVersion=$p(^DHCRBStudy("Report",Rptrowid),"^",3)
       ....s GetRptStatusDR=$p(^DHCRBStudy("Report",Rptrowid),"^",4)
       ....i GetRptStatusDR'="" d
       .....s GetReportStatusCode=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",1)
       .....i ReportStuatCode[GetReportStatusCode d
       ......s GetPatientStatusCode="O"
       .....e  d
       ......s GetPatientStatusCode="E"
       .....s GetRptStatusDesc=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",2)
       ....s GetRptIsYX=$p(^DHCRBStudy("Report",Rptrowid),"^",7)
       ....s GetRptDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",8)
       ....i GetRptDocDR'="" s GetRptDocName=$p(^SSU("SSUSR",GetRptDocDR),"^",2)
       ....s GetRptDate=$p(^DHCRBStudy("Report",Rptrowid),"^",9)
       ....i GetRptDate'="" s GetRptDate=$zd(GetRptDate,3)
       ....s GetRptTime=$p(^DHCRBStudy("Report",Rptrowid),"^",10)
       ....i GetRptTime'="" s GetRptTime=$zt(GetRptTime,3)
       ....s GetVerifyDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",11)
       ....i GetVerifyDocDR'="" s GetVerifyDocName=$p(^SSU("SSUSR",GetVerifyDocDR),"^",2)
       ....s GetVerifyDate=$p(^DHCRBStudy("Report",Rptrowid),"^",12)
       ....i GetVerifyDate'="" s GetVerifyDate=$zd(GetVerifyDate,3) 
       ....s GetVerifyTime=$p(^DHCRBStudy("Report",Rptrowid),"^",13)
       ....i GetVerifyTime'="" s GetVerifyTime=$zt(GetVerifyTime,3)
       ....s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
       ....q:(RisStatusCode'="")&(RisStatusCode'=GetPatientStatusCode)
       ....s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
       ....s bOut="Y"
       ....Do OutRowItemDate
       ..i bOut="N" d
       ...s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
       ...q:(RisStatusCode'="")&(RisStatusCode'=GetPatientStatusCode)
       ...s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
       ...s bOut="Y"
       ...Do OutRowItemDate
    }
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK   
   
OutRowItemDate
    set Data=$lb(GetRegNo,GetName,GetSexDesc,GetBedNo,GetstrOrderName,GetstrDate,GetstrTime,GetRecLocName,GetReportStatus,strRppDate,strRppTime,GetResDesc,GetstrRegDate,GetstrRegTime,GetStudyNo,GetRptDocName,GetVerifyDocName,GetPatientStatus,GetWardName,GetstrAge,PrintFalg,Oeorditemdr,MeothodDesc,$g(GetRecLocDR),$g(IsSend),$g(Memo),$g(BookedNo))
    ;i ((GetRecLocDR'="180")&(GetRecLocDR'="181")) d
    s ^DHCRISTEMPWARDQUERYDATA($g(InUserId),ind)=$g(Oeorditemdr)_"^"_$J_"^"_$g(GetRecLocName)_"^"_$g(GetBedNo)_"^"_$g(GetRegNo)_"^"_$g(GetName)_"^"_$g(GetSexDesc)_"^"_$g(GetstrAge)_"^"_$g(GetstrOrderName)_"^"_$g(GetstrDate)_"^"_$g(GetstrTime)_"^"_$g(strRppDate)_"^"_$g(strRppTime)_"^"_$g(GetstrRegDate)_"^"_$g(GetstrRegTime)_"^"_$g(GetStudyNo)_"^"_$g(GetRptDocName)_"^"_$g(GetVerifyDocName)_"^"_$g(GetPatientStatus)_"^"_$g(GetWardName)_"^"_$g(GetResDesc)_"^"_PrintFalg_"^"_$g(MeothodDesc)_"^"_$g(GetRecLocDR)_"^"_$g(IsSend)
    s ^DHCRISTEMPWARDQUERYDATA($g(InUserId))=ind
   	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
 	quit
}

/// Test
ClassMethod QueryBookedItem(ward, ArcItemRowid, InRegNo, InStudyNo, RisStatusCode, RecLocId, IsPrint, InIsBedOrd, InUserId, startdate, enddate, IsNoBK)
{
	k ^DHCRISNURSETMEP("TEMPNURSEITEMROWID")
	k ^DHCRIS("TMPROWID")
	s QueryType=""
	s Count=$l($g(^DHCRISEXELOC("QueryExeLoc")),"@")
    s InLocID=$g(^DHCRISEXELOC("QueryExeLoc"))
    
	for date=startdate:1:enddate
    {
	     ;RB_ApptSchedule
         
            for i=1:1:Count  d
	         .s perInLocID=$p(InLocID,"@",i)
			 .s RowId="" f  s RowId=$o(^RB("RES",0,"CTLOC",perInLocID,RowId) ) q:RowId=""  d
			 ..i QueryType="2" d
			 ...s session=0 f  s session=$o(^RBAS(RowId,0,"DateSTime",date,session)) q:session=""  d
			 ....s childsub=0 f  s childsub=$o(^RBAS(RowId,0,"DateSTime",date,session,childsub)) q:childsub=""  d
			 .....s apptschinfo=^RBAS(RowId,childsub)
			 .....s AppointDate=$p(apptschinfo,"^",1)
			 .....q:AppointDate'=date
			 .....s GetAppointDate=$zd(AppointDate,3)
			 .....s AppointstTime=$p(apptschinfo,"^",4)
			 .....s GetAppointstTime=$zt(AppointstTime,1)
			 .....s ApptRowid=RowId_"||"_childsub
			 .....; RB_Appointment
			 .....s appointchildsub=0  f  s appointchildsub=$o(^RBAS(RowId,childsub,"APPT",appointchildsub)) q:appointchildsub=""  d
			 ......s apppintrowid=ApptRowid_"||"_appointchildsub
			 ......s ordrowid=0 
			 ......s ordrowid=$o(^OEORDi(0,"Appt",apppintrowid,ordrowid))
			 ......; 根据预约的时间点找医嘱
			 ......i ordrowid'=""  d
			 .......s orditemchildsub=0  
			 .......s orditemchildsub=$o(^OEORDi(0,"Appt",apppintrowid,ordrowid,orditemchildsub))
			 .......s Oeorditemdr=ordrowid_"||"_orditemchildsub
			 .......q:($d(^DHCRISNURSETMEP("TEMPNURSEITEMROWID",Oeorditemdr)))
             .......s ^DHCRISNURSETMEP("TEMPNURSEITEMROWID",Oeorditemdr)=""
			 .......Do OutRow5
	         ..s ResDesc=""
	         ..s CTCPDR=$p($g(^RB("RES",RowId)),"^",2)
	         ..i CTCPDR'="" d
	         ...s GetResDesc=$p($g(^CTPCP(CTCPDR,1)),"^",2)
	         ..else  d
	         ...s EQDR=$p($g(^RB("RES",RowId)),"^",3)
	         ...i EQDR'="" s GetResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
	         ..s gSchRowid="",BK=""
	         ..s gSchRowid=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",perInLocID,date,RowId,gSchRowid))
	         ..;w !,"gSchRowid="_gSchRowid
	         ..i (gSchRowid'="") d
	         ...s SchRowid=0 f  s SchRowid=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",perInLocID,date,RowId,SchRowid)) q:SchRowid=""  d
	         ....s DetailRowid=0  f  s DetailRowid=$o(^DHCRBCResSchduleDetaili("SchudleId",SchRowid,DetailRowid)) q:DetailRowid=""  d
	         .....s BK="",BookedNo=""
	         .....s BK=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",7)
	         .....;w !,"BK="_Oeorditemdr_BK 
	         .....q:(BK="Cancel")
	         .....s Oeorditemdr=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",1)
	         .....s BookedNo=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",20)
	         .....;w !,"Oeorditemdr="_Oeorditemdr
	         .....q:(Oeorditemdr="")
	         .....q:($d(^DHCRISNURSETMEP("TEMPNURSEITEMROWID",Oeorditemdr)))
             .....s ^DHCRISNURSETMEP("TEMPNURSEITEMROWID",Oeorditemdr)=""
	         .....s strRppDate="",strRppTime=""
	         .....s strRppDate=$p(^DHCRBCResourceSchdule(SchRowid),"^",2)
	         .....s strRppDate=$zd(strRppDate,3)
	         .....s strRppTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",5)
	         .....s strRppTime=$zt(strRppTime,1)
	         .....;判断detail表里是否有开始时间
	         .....i $p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",18)'="" d
	         ......s strRppTime=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",18)
	         .....i strRppTime'="" s strRppTime=$zt(strRppTime,1)
	         .....Do OutRow5
	         ..e  d
	         ...s DEBRwoid="" f  s DEBRwoid=$o(^DHCRBCExternalBookInfoi("Date",date,perInLocID,DEBRwoid)) q:(DEBRwoid="")  d
	         ....s Oeorditemdr=$p($g(^DHCRBCExternalBookInfo(DEBRwoid)),"^",2)
	         ....q:((Oeorditemdr="")!(Oeorditemdr=" "))
             ....q:($d(^DHCRISNURSETMEP("TEMPNURSEITEMROWID",Oeorditemdr)))
             ....s ^DHCRISNURSETMEP("TEMPNURSEITEMROWID",Oeorditemdr)=""
	         ....s strRppDate="",strRppTime=""
	         ....s strRppDate=$p($g(^DHCRBCExternalBookInfo(DEBRwoid)),"^",5)
	         ....s strRppDate=$zd(strRppDate,3)
	         ....s strRppTime=$p($g(^DHCRBCExternalBookInfo(DEBRwoid)),"^",6)
	         ....s strRppTime=$zt(strRppTime,1)
	         ....s GetResDesc=$p($g(^DHCRBCExternalBookInfo(DEBRwoid)),"^",4)
	         ....Do OutRow5

}

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
    
OutRow5
             
			 s ordrowid=$p($g(Oeorditemdr),"||",1)
			 s orditemchildsub=$p($g(Oeorditemdr),"||",2)
			 s IsRegFlag=""
			 s IsRegFlag=..GetRegFlag(Oeorditemdr)
			 q:(IsRegFlag="Y")
			 s arcimid=$p($g(^OEORD(ordrowid,"I",orditemchildsub,1)),"^",2)
			 q:(arcimid="")
			 s MeothodDesc=""
             s MeothodDesc=..RequestBookType(arcimid)
             ;q:((IsNoBK="Y")&((MeothodDesc=" ")!(MeothodDesc="")!(MeothodDesc'="不需预约")))
             q:((IsNoBK="Y")&((MeothodDesc'="不需预约")&(MeothodDesc'="")))
             s IsSend="",Memo=""
             s IsSend=..IsSendAppBill(Oeorditemdr)
	         s RecLocdr=$p($g(^OEORD(ordrowid,"I",orditemchildsub,3)),"^",6)
	         q:(RecLocId'="")&(RecLocId'=RecLocdr)
	         q:(ArcItemRowid'="")&(ArcItemRowid'=arcimid)
			 s PrintFalg="" 
	         s PrintFalg=$g(^DHCRISORDITEMPRINTED(Oeorditemdr))
	         i PrintFalg="" s PrintFalg="N"
	         ;q:(PrintFalg'="")&(IsPrint'=PrintFalg)
	         q:(IsPrint'="")&(IsPrint'=PrintFalg)
	         s IsMemo=""
             s IsMemo=##class(web.DHCRisCommFunctionEx).ExistMemo(Oeorditemdr)
             i IsMemo="Y" s Memo="浏览"
			 s paadmdr=$p(^OEORD(ordrowid),"^",1)
			 s papatmasmdr=$p(^PAADM(paadmdr),"^",1)  
			 ;get patient diagnose 
		     q:(paadmdr="")
	         s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
		     s GetRegNo=$p(PatInfo,"^",1)
		     q:(InRegNo'="")&(InRegNo'=GetRegNo)
		     ;w !,"GetRegNo"_GetRegNo
		     s GetName=$p(PatInfo,"^",2)
		     s GetstrDOB=$p(PatInfo,"^",3)
		     s GetstrAge=$p(PatInfo,"^",4)
		     s GetstrAge=$p(GetstrAge," ")
		     s GetSexDesc=$p(PatInfo,"^",5)
		     s Getpatienttype=$p(PatInfo,"^",6)
		     ;q:(Getpatienttype'="I")
		     s Gettypedesc=$p(PatInfo,"^",7)
		     s GetLocName=$p(PatInfo,"^",8)
		     s GetIPNo=$p(PatInfo,"^",9)       ;住院号
		     s GetWardName=$p(PatInfo,"^",10)
		     s GetBedNo=$p(PatInfo,"^",11)
		     s GetReqLocDR=$p(PatInfo,"^",12)
		     s GetWardDR=$p(PatInfo,"^",14)
		     q:(ward'="")&(ward'=GetWardDR)
		     s Getroomdesc=$p(PatInfo,"^",15)
		     s GetSexDr=$p(PatInfo,"^",13)
		     s PapatmasDR=$p(PatInfo,"^",24)
		     s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(ordrowid,orditemchildsub)
		     s GetPatientStatusCode="A"
	         s GetstrOrderName=$p(ordInfo,"^",1)
	         q:(InIsBedOrd="N")&(GetstrOrderName["床旁")
	         q:(InIsBedOrd="Y")&(GetstrOrderName'["床旁")
	         s GetstrDate=$p(ordInfo,"^",2)
	         s GetstrTime=$p(ordInfo,"^",3)
	         s Getifbed=$p(ordInfo,"^",9)
	         s GetItemStatusCode=$p(ordInfo,"^",14)
	         s GetRecLocName=$p(ordInfo,"^",21)
	         q:(GetItemStatusCode="U")!(GetItemStatusCode="D") ;过滤作废或停止医嘱
	         s GetordDate=$p(ordInfo,"^",15)
	         s GetordTime=$p(ordInfo,"^",16)
	         s GetItemStatusCode=$p(ordInfo,"^",17)   			;医嘱状态
	         s GetServerMaterial=$p(ordInfo,"^",18)   			;申请项目标记 
	         q:(GetServerMaterial'="S")
	         s GetRecLocDR=$p(ordInfo,"^",19)
			 s GetPatientStatusCode="B"
			 s GetReportStatusCode="N"  ;未写报告
			 s GetstrRegDate="",GetstrRegTime="",GetRptDocName="",GetVerifyDocName="",GetStudyNo="",GetIndex="",GetEQDesc=""
			 s bOut="N",HaveImage=""
			 s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfo(Oeorditemdr)
	         s GetStudyNo=$p(RegInfo,"^",1)
	         i GetStudyNo'="" s GetPatientStatusCode="I"
	         q:(InStudyNo'="")&(InStudyNo'=GetStudyNo)
	         s GetstrRegDate=$p(RegInfo,"^",2)
	         s GetstrRegTime=$p(RegInfo,"^",3)
	         s GetRegDate=$p(RegInfo,"^",17)
			 s GetReportStatusCode="N"     ;未写报告
	         s GetImgcount=0
	         s GetRptID=""
	         s GetRptDocDR="",GetRptDocName="",GetRptDate="",GetRptTime="",GetVerifyDocDR=""
	         s GetVerifyDocName="",GetVerifyDate="",GetVerifyTime="",HaveImage=""
	         i GetStudyNo'="" d
	         .s Imrowid=0 f  s Imrowid=$o(^DHCRBStudyi("StudyNo-Images",GetStudyNo,Imrowid)) q:Imrowid=""  d
	         ..s GetPatientStatusCode="E"    ;正在检查
	         ..s ExtName=$p($g(^DHCRBStudy(0,"StudyImages",Imrowid)),"^",2)
	         ..i ((ExtName="avi")!(ExtName="dcm")!(ExtName="normal")!(ExtName="dsa"))  d
	         ...s GetImgcount=GetImgcount+1
	         ...s GetReportStatusCode="I"             ;图象已经采集
	         ...s HaveImage="是"
	         .s ReportStuatCode="VS"
	         .s Rptrowid=0  f  s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",GetStudyNo,Rptrowid)) q:Rptrowid=""  d
	         ..s GetRptID=$p(^DHCRBStudy("Report",Rptrowid),"^",2)
	         ..s GetRptVersion=$p(^DHCRBStudy("Report",Rptrowid),"^",3)
	         ..s GetRptStatusDR=$p(^DHCRBStudy("Report",Rptrowid),"^",4)
	         ..i GetRptStatusDR'="" d
	         ...s GetReportStatusCode=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",1)
	         ...i ReportStuatCode[GetReportStatusCode d
	         ....s GetPatientStatusCode="O"
	         ...e  d
	         ....s GetPatientStatusCode="E"
	         ...s GetRptStatusDesc=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",2)
	         ..s GetRptIsYX=$p(^DHCRBStudy("Report",Rptrowid),"^",7)
	         ..s GetRptDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",8)
	         ..i GetRptDocDR'="" s GetRptDocName=$p(^SSU("SSUSR",GetRptDocDR),"^",2)
	         ..s GetRptDate=$p(^DHCRBStudy("Report",Rptrowid),"^",9)
	         ..i GetRptDate'="" s GetRptDate=$zd(GetRptDate,3)
	         ..s GetRptTime=$p(^DHCRBStudy("Report",Rptrowid),"^",10)
	         ..i GetRptTime'="" s GetRptTime=$zt(GetRptTime,3)
	         ..s GetVerifyDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",11)
	         ..i GetVerifyDocDR'="" s GetVerifyDocName=$p(^SSU("SSUSR",GetVerifyDocDR),"^",2)
	         ..s GetVerifyDate=$p(^DHCRBStudy("Report",Rptrowid),"^",12)
	         ..i GetVerifyDate'="" s GetVerifyDate=$zd(GetVerifyDate,3) 
	         ..s GetVerifyTime=$p(^DHCRBStudy("Report",Rptrowid),"^",13)
	         ..i GetVerifyTime'="" s GetVerifyTime=$zt(GetVerifyTime,3)
	         ..s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
	         ..q:(((RisStatusCode'="")&(RisStatusCode'="S"))&(RisStatusCode'=GetPatientStatusCode))
	         ..s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
	         ..s bOut="Y"
	         ..set Data=$lb(GetRegNo,GetName,GetSexDesc,GetBedNo,GetstrOrderName,GetstrDate,GetstrTime,GetRecLocName,GetReportStatus,strRppDate,strRppTime,GetResDesc,GetstrRegDate,GetstrRegTime,GetStudyNo,GetRptDocName,GetVerifyDocName,GetPatientStatus,GetWardName,GetstrAge,PrintFalg,Oeorditemdr,$g(MeothodDesc),$g(GetRecLocDR),$g(IsSend),$g(Memo),$g(BookedNo))
	         ..;i ((GetRecLocDR'="180")&(GetRecLocDR'="181")) d
             ..s ^DHCRISTEMPWARDQUERYDATA($g(InUserId),ind)=$g(Oeorditemdr)_"^"_$J_"^"_$g(GetRecLocName)_"^"_$g(GetBedNo)_"^"_$g(GetRegNo)_"^"_$g(GetName)_"^"_$g(GetSexDesc)_"^"_$g(GetstrAge)_"^"_$g(GetstrOrderName)_"^"_$g(GetstrDate)_"^"_$g(GetstrTime)_"^"_$g(strRppDate)_"^"_$g(strRppTime)_"^"_$g(GetstrRegDate)_"^"_$g(GetstrRegTime)_"^"_$g(GetStudyNo)_"^"_$g(GetRptDocName)_"^"_$g(GetVerifyDocName)_"^"_$g(GetPatientStatus)_"^"_$g(GetWardName)_"^"_$g(GetResDesc)_"^"_PrintFalg_"^"_$g(MeothodDesc)_"^"_$g(GetRecLocDR)_"^"_$g(IsSend)
             ..s ^DHCRISTEMPWARDQUERYDATA($g(InUserId))=ind
   	         ..Set ^CacheTemp(repid,ind)=Data
	         ..Set ind=ind+1
 	         ..quit
	         i bOut="N" d
	         .s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
	         .q:(((RisStatusCode'="")&(RisStatusCode'="S"))&(RisStatusCode'=GetPatientStatusCode))
	         .s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
	         .s bOut="Y"
	         .set Data=$lb(GetRegNo,GetName,GetSexDesc,GetBedNo,GetstrOrderName,GetstrDate,GetstrTime,GetRecLocName,GetReportStatus,strRppDate,strRppTime,GetResDesc,GetstrRegDate,GetstrRegTime,GetStudyNo,GetRptDocName,GetVerifyDocName,GetPatientStatus,GetWardName,GetstrAge,PrintFalg,Oeorditemdr,$g(MeothodDesc),$g(GetRecLocDR),$g(IsSend),$g(Memo),$g(BookedNo))
             .s ^DHCRISTEMPWARDQUERYDATA($g(InUserId),ind)=$g(Oeorditemdr)_"^"_$J_"^"_$g(GetRecLocName)_"^"_$g(GetBedNo)_"^"_$g(GetRegNo)_"^"_$g(GetName)_"^"_$g(GetSexDesc)_"^"_$g(GetstrAge)_"^"_$g(GetstrOrderName)_"^"_$g(GetstrDate)_"^"_$g(GetstrTime)_"^"_$g(strRppDate)_"^"_$g(strRppTime)_"^"_$g(GetstrRegDate)_"^"_$g(GetstrRegTime)_"^"_$g(GetStudyNo)_"^"_$g(GetRptDocName)_"^"_$g(GetVerifyDocName)_"^"_$g(GetPatientStatus)_"^"_$g(GetWardName)_"^"_$g(GetResDesc)_"^"_PrintFalg_"^"_$g(MeothodDesc)_"^"_$g(GetRecLocDR)_"^"_$g(IsSend)
             .s ^DHCRISTEMPWARDQUERYDATA($g(InUserId))=ind
             .;i ($g(^DHCRISNURSETMEP("TEMPNURSEITEMROWID"))'=Oeorditemdr)
   	         .Set ^CacheTemp(repid,ind)=Data
	         .Set ind=ind+1
 	         .quit
}

ClassMethod QueryByRegDate(ward, ArcItemRowid, InRegNo, InStudyNo, RisStatusCode, RecLocId, IsPrint, InIsBedOrd, InUserId, startdate, enddate)
{

	for date=startdate:1:enddate
    {
	  s Regrowid=0 f  s Regrowid=$o(^DHCPACRegInfoi("RegDate",date,Regrowid)) q:Regrowid=""  d    
      .s bOut="N"  ;是否已经输出
      .s GetPatientStatusCode="I"
      .s ExecuteLocId=$p(^DHCPACRegInfo(Regrowid),"^",13)
      .q:(RecLocId'="")&(RecLocId'=ExecuteLocId)  
      .s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfobyrowid(Regrowid)
      .s GetStudyNo=$p(RegInfo,"^",1)
      .q:(InStudyNo'="")&(InStudyNo'=GetStudyNo)
      .s GetstrRegDate=$p(RegInfo,"^",2)
      .s GetstrRegTime=$p(RegInfo,"^",3)
      .s Oeorditemdr=$p(RegInfo,"^",8)
      .s IsSend="",Memo=""
      .s IsSend=..IsSendAppBill(Oeorditemdr)
      .s PrintFalg=""
      .s PrintFalg=$g(^DHCRISORDITEMPRINTED(Oeorditemdr))
      .i PrintFalg="" s PrintFalg="N"
      .;q:(PrintFalg'="")&(IsPrint'=PrintFalg)
      .q:(IsPrint'="")&(IsPrint'=PrintFalg)
      .s IsMemo=""
      .s IsMemo=##class(web.DHCRisCommFunctionEx).ExistMemo(Oeorditemdr)
      .i IsMemo="Y" s Memo="浏览"
      .s paadmdr=$p(RegInfo,"^",9)
      .s GetRegDate=$p(RegInfo,"^",17)
      .s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
      .s GetRegNo=$p(PatInfo,"^",1)
      .q:(InRegNo'="")&(InRegNo'=GetRegNo)
      .;w !,"GetRegNo"_GetRegNo
      .s GetName=$p(PatInfo,"^",2)
      .s GetstrDOB=$p(PatInfo,"^",3)
      .s GetstrAge=$p(PatInfo,"^",4)
      .s GetstrAge=$p(GetstrAge," ")
 	  .s GetSexDesc=$p(PatInfo,"^",5)
      .s Getpatienttype=$p(PatInfo,"^",6)
      .q:(Getpatienttype'="I")
      .s Gettypedesc=$p(PatInfo,"^",7)
      .s GetLocName=$p(PatInfo,"^",8)
      .s GetIPNo=$p(PatInfo,"^",9)       ;住院号
      .s GetWardName=$p(PatInfo,"^",10)
      .s GetBedNo=$p(PatInfo,"^",11)
      .s GetReqLocDR=$p(PatInfo,"^",12)
      .s GetWardDR=$p(PatInfo,"^",14)
      .q:(ward'="")&(ward'=GetWardDR)
      .s Getroomdesc=$p(PatInfo,"^",15)
      .s GetSexDr=$p(PatInfo,"^",13)
      .s PapatmasDR=$p(PatInfo,"^",24)
      .s OrderRowid=$p(Oeorditemdr,"||",1)
      .s itemsub=$p(Oeorditemdr,"||",2)
      .s GetResDesc="",strRppDate="",strRppTime=""
      .s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
      .q:(ArcItemRowid'="")&(ArcItemRowid'=arcimid)
      .s MeothodDesc=""
      .s MeothodDesc=..RequestBookType(arcimid)
      .s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(OrderRowid,itemsub)
      .s GetstrOrderName=$p(ordInfo,"^",1)
      .q:(InIsBedOrd="N")&(GetstrOrderName["床旁")
      .q:(InIsBedOrd="Y")&(GetstrOrderName'["床旁")
      .s GetstrDate=$p(ordInfo,"^",2)
      .s GetstrTime=$p(ordInfo,"^",3)
      .s Getifbed=$p(ordInfo,"^",9)
      .s GetItemStatusCode=$p(ordInfo,"^",14)
      .s GetRecLocName=$p(ordInfo,"^",21)
      .q:(GetItemStatusCode="U")!(GetItemStatusCode="D") ;过滤作废或停止医嘱
      .s GetordDate=$p(ordInfo,"^",15)
      .s GetordTime=$p(ordInfo,"^",16)
      .s GetItemStatusCode=$p(ordInfo,"^",17)   			;医嘱状态
      .s GetServerMaterial=$p(ordInfo,"^",18)   			;申请项目标记
      .q:(GetServerMaterial'="S")
      .s GetRecLocDR=$p(ordInfo,"^",19)
      .;s ResultFlag=$p(ordInfo,"^",20)    
      .;q:ResultFlag="V"
      .i $g(^OEORD(OrderRowid,"I",itemsub,6))'="" d
      ..s Getapprowid=$p(^OEORD(OrderRowid,"I",itemsub,6),"^",5)
      ..i (Getapprowid'="")&(Getapprowid'=$C(0)) d
      ...s ResRowid=$p(Getapprowid,"||",1)
      ...s SchildSub=$p(Getapprowid,"||",2)
      ...s appointchildsub=$p(Getapprowid,"||",3)
      ...s ResDesc=""
 	  ...s CTCPDR=$p($g(^RB("RES",ResRowid)),"^",2)
      ...s CTCPDR=$p(CTCPDR,$c(0))
      ...i CTCPDR'="" d
      ....s GetResDesc=$p($g(^CTPCP(CTCPDR,1)),"^",2)
      ...else  d
      ....s EQDR=$p($g(^RB("RES",ResRowid)),"^",3)
      ....s GetResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
      ...s RppDate=$p(^RBAS(ResRowid,SchildSub),"^",1)
      ...s strRppDate=$zd(RppDate,3)
      ...s RppTime=$p(^RBAS(ResRowid,SchildSub),"^",4)
      ...s strRppTime=$zt(RppTime,1)
      .s GetReportStatusCode="N"     ;未写报告
      .s GetImgcount=0
      .s GetRptID=""
      .s GetRptDocDR="",GetRptDocName="",GetRptDate="",GetRptTime="",GetVerifyDocDR=""
      .s GetVerifyDocName="",GetVerifyDate="",GetVerifyTime="",HaveImage=""
      .s Imrowid=0 f  s Imrowid=$o(^DHCRBStudyi("StudyNo-Images",GetStudyNo,Imrowid)) q:Imrowid=""  d
      ..s GetPatientStatusCode="E"    ;正在检查
      ..s ExtName=$p($g(^DHCRBStudy(0,"StudyImages",Imrowid)),"^",2)
      ..i ((ExtName="avi")!(ExtName="dcm")!(ExtName="normal")!(ExtName="dsa"))  d
      ...s GetImgcount=GetImgcount+1
      ...s GetReportStatusCode="I"             ;图象已经采集
      ...s HaveImage="是"
      .s ReportStuatCode="VS"
      .s Rptrowid=0  f  s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",GetStudyNo,Rptrowid)) q:Rptrowid=""  d
      ..s GetRptID=$p(^DHCRBStudy("Report",Rptrowid),"^",2)
      ..s GetRptVersion=$p(^DHCRBStudy("Report",Rptrowid),"^",3)
      ..s GetRptStatusDR=$p(^DHCRBStudy("Report",Rptrowid),"^",4)
      ..i GetRptStatusDR'="" d
      ...s GetReportStatusCode=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",1)
      ...i ReportStuatCode[GetReportStatusCode d
      ....s GetPatientStatusCode="O"
      ...e  d
      ....s GetPatientStatusCode="E"
      ...s GetRptStatusDesc=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",2)
      ..s GetRptIsYX=$p(^DHCRBStudy("Report",Rptrowid),"^",7)
      ..s GetRptDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",8)
      ..i GetRptDocDR'="" s GetRptDocName=$p(^SSU("SSUSR",GetRptDocDR),"^",2)
      ..s GetRptDate=$p(^DHCRBStudy("Report",Rptrowid),"^",9)
      ..i GetRptDate'="" s GetRptDate=$zd(GetRptDate,3)
      ..s GetRptTime=$p(^DHCRBStudy("Report",Rptrowid),"^",10)
      ..i GetRptTime'="" s GetRptTime=$zt(GetRptTime,3)
      ..s GetVerifyDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",11)
      ..i GetVerifyDocDR'="" s GetVerifyDocName=$p(^SSU("SSUSR",GetVerifyDocDR),"^",2)
      ..s GetVerifyDate=$p(^DHCRBStudy("Report",Rptrowid),"^",12)
      ..i GetVerifyDate'="" s GetVerifyDate=$zd(GetVerifyDate,3) 
      ..s GetVerifyTime=$p(^DHCRBStudy("Report",Rptrowid),"^",13)
      ..i GetVerifyTime'="" s GetVerifyTime=$zt(GetVerifyTime,3)
      ..s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
      ..q:(RisStatusCode'="")&(RisStatusCode'=GetPatientStatusCode)
      ..s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
      ..s bOut="Y"
      ..Do OutRow
      .i bOut="N" d
      ..s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
      ..q:(RisStatusCode'="")&(RisStatusCode'=GetPatientStatusCode)
      ..s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
      ..s bOut="Y"
      ..Do OutRow
   }
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK   
   
OutRow
    set Data=$lb(GetRegNo,GetName,GetSexDesc,GetBedNo,GetstrOrderName,GetstrDate,GetstrTime,GetRecLocName,GetReportStatus,strRppDate,strRppTime,GetResDesc,GetstrRegDate,GetstrRegTime,GetStudyNo,GetRptDocName,GetVerifyDocName,GetPatientStatus,GetWardName,GetstrAge,PrintFalg,Oeorditemdr,$g(MeothodDesc),$g(GetRecLocDR),$g(IsSend),$g(Memo),$g(BookedNo))
    ;i ((GetRecLocDR'="180")&(GetRecLocDR'="181")) d
    s ^DHCRISTEMPWARDQUERYDATA($g(InUserId),ind)=$g(Oeorditemdr)_"^"_$J_"^"_$g(GetRecLocName)_"^"_$g(GetBedNo)_"^"_$g(GetRegNo)_"^"_$g(GetName)_"^"_$g(GetSexDesc)_"^"_$g(GetstrAge)_"^"_$g(GetstrOrderName)_"^"_$g(GetstrDate)_"^"_$g(GetstrTime)_"^"_$g(strRppDate)_"^"_$g(strRppTime)_"^"_$g(GetstrRegDate)_"^"_$g(GetstrRegTime)_"^"_$g(GetStudyNo)_"^"_$g(GetRptDocName)_"^"_$g(GetVerifyDocName)_"^"_$g(GetPatientStatus)_"^"_$g(GetWardName)_"^"_$g(GetResDesc)_"^"_PrintFalg_"^"_$g(MeothodDesc)_"^"_$g(GetRecLocDR)_"^"_$g(IsSend)
    s ^DHCRISTEMPWARDQUERYDATA($g(InUserId))=ind
   	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
 	quit
}

ClassMethod QueryWardItem(ward, ArcItemRowid, InRegNo, InStudyNo, RisStatusCode, RecLocId, IsPrint, InIsBedOrd, InUserId, startdate, enddate, IsNoBK, BKDesc)
{
	if ward="" Set qHandle=$lb(0,repid,0)
    q:ward="" $$$OK
    
    //s room=0 f  s room=$o(^PAROOM(room)) q:room=""  d  ;pac_room
    s room=0 f  s room=$o(^PAADMi("CurrWard",ward,room)) q:room=""  d
    .s papmidr=0 f  s papmidr=$o(^PAADMi("CurrWard",ward,room,papmidr)) q:papmidr=""  d 
    ..q:$p(^PAADM(papmidr),"^",20)'="A"                       
  	..s OrderRowid=0 f  s OrderRowid=$o(^OEORD(0,"Adm",papmidr,OrderRowid)) q:OrderRowid=""  d  
    ...s itemsub=0  f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:itemsub=""  d
    ....s Oeorditemdr=OrderRowid_"||"_itemsub
    ....;s GetPatientStatusCode="A"
    ....s IsBKFlag="",IsRegFlag="",Memo=""
    ....s IsRegFlag=..GetRegFlag(Oeorditemdr)
    ....q:(IsRegFlag="Y")
    ....s IsBKFlag=..GetBKFlag(Oeorditemdr)
    ....i IsBKFlag="Y" s GetPatientStatusCode="B"
    ....q:((RisStatusCode="B")&(IsBKFlag'="Y")) //过滤未预约医嘱
    ....s IsSend=""
    ....s IsSend=..IsSendAppBill(Oeorditemdr)
    ....s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
    ....q:(arcimid="")
    ....s ItemDate=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",9)
    ....;i Oeorditemdr="20017||3857" w !,ItemDate
    ....q:((ItemDate'="")&((ItemDate<startdate)!(ItemDate>enddate)))
    ....s MeothodDesc=""
    ....s MeothodDesc=..RequestBookType(arcimid)
    ....q:(BKDesc'="")&(BKDesc'=MeothodDesc)
    ....q:((IsNoBK="Y")&((MeothodDesc'="不需预约")&(MeothodDesc'="")))
    ....s RecLocdr=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)
    ....q:(RecLocId'="")&(RecLocId'=RecLocdr)
    ....q:(ArcItemRowid'="")&(ArcItemRowid'=arcimid)
    ....s PrintFalg=""
    ....s PrintFalg=$g(^DHCRISORDITEMPRINTED(Oeorditemdr))
    ....i PrintFalg="" s PrintFalg="N"
    ....;q:(PrintFalg'="")&(IsPrint'=PrintFalg)
    ....q:(IsPrint'="")&(IsPrint'=PrintFalg)
    ....;w !,"Oeorditemdr="_Oeorditemdr
    ....s bOut="N"  ;是否已经输出
    ....s paadmdr=$p(^OEORD(OrderRowid),"^",1) 
    ....s IsMemo=""
    ....s IsMemo=##class(web.DHCRisCommFunctionEx).ExistMemo(Oeorditemdr)
    ....i IsMemo="Y" s Memo="浏览" 
    ....s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
    ....q:(PatInfo="") 
    ....s GetRegNo=$p(PatInfo,"^",1)
	....q:(InRegNo'="")&(InRegNo'=GetRegNo)
	....s GetName=$p(PatInfo,"^",2)
	....s GetstrDOB=$p(PatInfo,"^",3)
	....s GetstrAge=$p(PatInfo,"^",4)
	....s GetstrAge=$p(GetstrAge," ")
	....s GetSexDesc=$p(PatInfo,"^",5)
	....s Getpatienttype=$p(PatInfo,"^",6)
	....q:(Getpatienttype'="I")
	....s Gettypedesc=$p(PatInfo,"^",7)
	....s GetLocName=$p(PatInfo,"^",8)
	....s GetIPNo=$p(PatInfo,"^",9)       ;住院号
	....s GetWardName=$p(PatInfo,"^",10)
	....s GetBedNo=$p(PatInfo,"^",11)
	....s GetReqLocDR=$p(PatInfo,"^",12)
	....s GetWardDR=$p(PatInfo,"^",14)
	....q:(ward'="")&(ward'=GetWardDR)
	....s Getroomdesc=$p(PatInfo,"^",15)
	....s GetSexDr=$p(PatInfo,"^",13)
	....s PapatmasDR=$p(PatInfo,"^",24)
	....s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(OrderRowid,itemsub)
	....i IsBKFlag'="Y" s GetPatientStatusCode="A"
    ....s GetstrOrderName=$p(ordInfo,"^",1)
    ....q:(InIsBedOrd="N")&(GetstrOrderName["床旁")
    ....q:(InIsBedOrd="Y")&(GetstrOrderName'["床旁")
    ....s GetstrDate=$p(ordInfo,"^",2)
    ....s GetstrTime=$p(ordInfo,"^",3)
    ....s Getifbed=$p(ordInfo,"^",9)
    ....s GetItemStatusCode=$p(ordInfo,"^",14)
    ....s GetRecLocName=$p(ordInfo,"^",21)
    ....q:(GetItemStatusCode="U")!(GetItemStatusCode="D")!(GetItemStatusCode="C") ;过滤作废或停止医嘱
    ....s GetordDate=$p(ordInfo,"^",15)
    ....s GetordTime=$p(ordInfo,"^",16)
    ....s GetItemStatusCode=$p(ordInfo,"^",17)   			;医嘱状态
    ....s GetServerMaterial=$p(ordInfo,"^",18)   			;申请项目标记 
    ....q:(GetServerMaterial'="S")
    ....s GetRecLocDR=$p(ordInfo,"^",19)
    ....s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfo(Oeorditemdr)
    ....s GetStudyNo=$p(RegInfo,"^",1)
    ....i GetStudyNo'="" s GetPatientStatusCode="I"
    ....q:(InStudyNo'="")&(InStudyNo'=GetStudyNo)
    ....s GetstrRegDate=$p(RegInfo,"^",2)
    ....s GetstrRegTime=$p(RegInfo,"^",3)
    ....s GetRegDate=$p(RegInfo,"^",17)
    ....s GetResDesc="",strRppDate="",strRppTime="",BKInfo="",BookedNo=""
    ....i IsBKFlag="Y" s BKInfo=..GetBKInfo(Oeorditemdr)
    ....s strRppDate=$p($g(BKInfo),"^",1)
    ....s strRppTime=$p($g(BKInfo),"^",2)
    ....s GetResDesc=$p($g(BKInfo),"^",3)
    ....s BookedNo=$p($g(BKInfo),"^",5)
    ....s GetReportStatusCode="N"     ;未写报告
    ....s GetImgcount=0
    ....s GetRptID=""
    ....s GetRptDocDR="",GetRptDocName="",GetRptDate="",GetRptTime="",GetVerifyDocDR=""
    ....s GetVerifyDocName="",GetVerifyDate="",GetVerifyTime="",HaveImage=""
    ....i GetStudyNo'="" d
    .....s Imrowid=0 f  s Imrowid=$o(^DHCRBStudyi("StudyNo-Images",GetStudyNo,Imrowid)) q:Imrowid=""  d
    ......s GetPatientStatusCode="E"    ;正在检查
    ......s ExtName=$p($g(^DHCRBStudy(0,"StudyImages",Imrowid)),"^",2)
    ......i ((ExtName="avi")!(ExtName="dcm")!(ExtName="normal")!(ExtName="dsa"))  d
    .......s GetImgcount=GetImgcount+1
    .......s GetReportStatusCode="I"             ;图象已经采集
    .......s HaveImage="是"
    .....s ReportStuatCode="VS"
    .....s Rptrowid=0  f  s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",GetStudyNo,Rptrowid)) q:Rptrowid=""  d
    ......s GetRptID=$p(^DHCRBStudy("Report",Rptrowid),"^",2)
    ......s GetRptVersion=$p(^DHCRBStudy("Report",Rptrowid),"^",3)
    ......s GetRptStatusDR=$p(^DHCRBStudy("Report",Rptrowid),"^",4)
    ......i GetRptStatusDR'="" d
    .......s GetReportStatusCode=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",1)
    .......i ReportStuatCode[GetReportStatusCode d
    ........s GetPatientStatusCode="O"
    .......e  d
    ........s GetPatientStatusCode="E"
    .......s GetRptStatusDesc=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",2)
    ......s GetRptIsYX=$p(^DHCRBStudy("Report",Rptrowid),"^",7)
    ......s GetRptDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",8)
    ......i GetRptDocDR'="" s GetRptDocName=$p(^SSU("SSUSR",GetRptDocDR),"^",2)
    ......s GetRptDate=$p(^DHCRBStudy("Report",Rptrowid),"^",9)
    ......i GetRptDate'="" s GetRptDate=$zd(GetRptDate,3)
    ......s GetRptTime=$p(^DHCRBStudy("Report",Rptrowid),"^",10)
    ......i GetRptTime'="" s GetRptTime=$zt(GetRptTime,3)
    ......s GetVerifyDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",11)
    ......i GetVerifyDocDR'="" s GetVerifyDocName=$p(^SSU("SSUSR",GetVerifyDocDR),"^",2)
    ......s GetVerifyDate=$p(^DHCRBStudy("Report",Rptrowid),"^",12)
    ......i GetVerifyDate'="" s GetVerifyDate=$zd(GetVerifyDate,3) 
    ......s GetVerifyTime=$p(^DHCRBStudy("Report",Rptrowid),"^",13)
    ......i GetVerifyTime'="" s GetVerifyTime=$zt(GetVerifyTime,3)
    ......s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
    ......q:(RisStatusCode'="S")&(RisStatusCode'="")&(RisStatusCode'=GetPatientStatusCode)
    ......s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
    ......s bOut="Y"
    ......Do OutRowWard
    ....i bOut="N" d
    .....s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
    .....q:(RisStatusCode'="S")&(RisStatusCode'="")&(RisStatusCode'=GetPatientStatusCode)
    .....s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
    .....s bOut="Y"
    .....Do OutRowWard
    
    Set qHandle=$lb(0,repid,0)
   Quit $$$OK   
   
OutRowWard
    set Data=$lb(GetRegNo,GetName,GetSexDesc,GetBedNo,GetstrOrderName,GetstrDate,GetstrTime,GetRecLocName,GetReportStatus,strRppDate,strRppTime,GetResDesc,GetstrRegDate,GetstrRegTime,GetStudyNo,GetRptDocName,GetVerifyDocName,GetPatientStatus,GetWardName,GetstrAge,PrintFalg,Oeorditemdr,MeothodDesc,$g(GetRecLocDR),$g(IsSend),$g(Memo),$g(BookedNo))
    s ^DHCRISTEMPWARDQUERYDATA($g(InUserId),ind)=$g(Oeorditemdr)_"^"_$J_"^"_$g(GetRecLocName)_"^"_$g(GetBedNo)_"^"_$g(GetRegNo)_"^"_$g(GetName)_"^"_$g(GetSexDesc)_"^"_$g(GetstrAge)_"^"_$g(GetstrOrderName)_"^"_$g(GetstrDate)_"^"_$g(GetstrTime)_"^"_$g(strRppDate)_"^"_$g(strRppTime)_"^"_$g(GetstrRegDate)_"^"_$g(GetstrRegTime)_"^"_$g(GetStudyNo)_"^"_$g(GetRptDocName)_"^"_$g(GetVerifyDocName)_"^"_$g(GetPatientStatus)_"^"_$g(GetWardName)_"^"_$g(GetResDesc)_"^"_PrintFalg_"^"_$g(MeothodDesc)_"^"_$g(GetRecLocDR)_"^"_$g(IsSend)
    s ^DHCRISTEMPWARDQUERYDATA($g(InUserId))=ind
   	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
 	quit
}

ClassMethod GetWardByLoc(LocDr) As %String
{
	s LocType=$p(^CTLOC(LocDr),"^","13")
	if (LocType="W")
	{
		s warrowid=0
		s warrowid=$o(^PAWARD(0,"WARD_LocationDR",LocDr,warrowid)) 
		s desc=$p(^PAWARD(warrowid),"^",2)
		q desc_"^"_warrowid
	}
	else
	{
		 q "^"
	}
}

/// 查询病区信息
/// w ##class(%ResultSet).RunQuery("web.DHCRisWardQuery","QueryWard","") 
Query QueryWard(InDesc As %String) As %Query(ROWSPEC = "Desc:%String,TRowid:%String")
{
}

ClassMethod QueryWardExecute(ByRef qHandle As %Binary, InDesc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
    i (InDesc'="")
    {
      s Info=""
      s Info=InDesc
      s Info=$p($g(InDesc),"-",1)
      s InDesc= $ZCONVERT(Info,"U")
	  
    }
    
    s rowid=0 f  s rowid=$o(^PAWARD(rowid)) q:rowid=""  d
    .s Getdesc=$p($g(^PAWARD(rowid)),"^",2)
    .i (InDesc="") d
    ..Do OutRowQueryWard
    .i (InDesc'="")&(Getdesc[InDesc) d
    ..Do OutRowQueryWard
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutRowQueryWard
	set Data=$lb(Getdesc,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryWardExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

ClassMethod QueryWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 查询医嘱项目
/// do ##class(%ResultSet).RunQuery("web.DHCRisWardQuery","QueryOrdItemCS","CS")
Query QueryOrdItemCS(ItemDesc As %String) As %Query(CONTAINID = 0, ROWSPEC = "ARCIMDesc:%String,ItemRowID:%String,SubCategoryDesc:%String")
{
}

ClassMethod QueryOrdItemCSExecute(ByRef qHandle As %Binary, ItemDesc As %String) As %Status
{
	s rARCIMDesc="",rItemRowID="",rSubCategoryDesc="",rPrice=""
	Set repid=$I(^CacheTemp)
	s index=1
	
	s ItemDesc=$g(ItemDesc)
	s ItemDesc=$ZCONVERT(ItemDesc,"U")
	s i=0
	s id=0 f  s id=$o(^ARC("ALIAS",id)) q:id=""  d
	.s text=$p(^ARC("ALIAS",id),"^",6)
	.s text=$ZCONVERT(text,"U")
	.q:($l(text)=0)
	.q:(($e((text),1,$l(ItemDesc)))'[ItemDesc)
	.s tarid=$p(^ARC("ALIAS",id),"^",1)
	.q:tarid=""
	.s id1=$p(tarid,"||",1)
	.s id2=$p(tarid,"||",2)
	.q:$d(^ARCIM(id1,id2,1))=0
	.s rItemRowID=id1_"||"_id2
	.s rARCIMDesc=$p(^ARCIM(id1,id2,1),"^",2)
	.s yzcode=$p(^ARCIM(id1,id2,1),"^",1)
	.s lei=""
	.s leiname=""
	.s daleicode=""
	.s daleiname=""
	.s uomcode=""
	.s uomdesc=""
	.s uomcode=$p(^ARCIM(id1,id2,8),"^",14)
	.i uomcode'="" s uomdesc=$p(^CT("UOM",uomcode),"^",2)
	.s lei=$p(^ARCIM(id1,id2,1),"^",10)
	.i lei'="" s rSubCategory=$p(^ARC("IC",lei),"^",2)
	.s daleicode=$p(^ARC("IC",lei),"^",8)
	.i daleicode'="" d
	..s rCategory=$p(^OEC("ORCAT",daleicode),"^",2)
	..;b //rCategory
	..i rCategory["检查" Do OutOrdItemCS
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutOrdItemCS
	set Data=$lb(rARCIMDesc,rItemRowID, rSubCategory)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod QueryOrdItemCSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOrdItemCSExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryOrdItemCSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOrdItemCSExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 获取RIS3.0检查状态
/// do ##class(web.DHCRisWardQuery).GetRisStatusList()
ClassMethod GetRisStatusList() As %String
{
	/*s rset=##class(%ResultSet).%New("web.DHCRisCommFunction","QueryStatus")
	s ret=""
	do rset.Execute()
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(2)_$C(1)_rset.GetData(3)
	    e  s ret=ret_"^"_rset.GetData(2)_$C(1)_rset.GetData(3)
	}	
	d rset.Close()
	q ret*/
	
	s ret="S"_$C(1)_"全部"_"^"_"A"_$C(1)_"未预约"_"^"_"B"_$C(1)_"已预约"
	q ret
}

/*ClassMethod GetRisStatusList() As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCommFunction:QuerySystemPatientStatus")
	s ret=""
	do rset.Execute()
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(2)_$C(1)_rset.GetData(3)
	    e  s ret=ret_"^"_rset.GetData(2)_$C(1)_rset.GetData(3)
	}	
	d rset.Close()
	q ret
}*/

/*ClassMethod SetPrintData(ward As %String) As %String
{
	if (ward'="") 
	{
	  s PRowid=$g(^DHCRISTEMPWARDQUERYDATA(ward,"Ward")) q:(PRowid="")
	  
	  s Info=""
	  s rowid=0 f  s rowid=$o(^DHCRISTEMPWARDQUERYDATA(ward,PRowid,"Ward",rowid))  q:rowid=""  d
	  .s Info=$g(^DHCRISTEMPWARDQUERYDATA(ward,PRowid,"Ward",rowid))_"&"_Info
	}
	else
	{
		 s Info=""
		 s rowid=0 f  s rowid=$o(^PAWARD(rowid)) q:rowid=""  d
		 .s PRowid=$g(^DHCRISTEMPWARDQUERYDATA(rowid,"Ward"))
		 .i PRowid'="" d
		 ..s Printrowid=0 f  s Printrowid=$o(^DHCRISTEMPWARDQUERYDATA(rowid,PRowid,"Ward",Printrowid))  q:Printrowid=""  d
	     ...s Info=$g(^DHCRISTEMPWARDQUERYDATA(rowid,PRowid,"Ward",Printrowid))_"&"_Info
	}
	 
	 q Info
}*/
/// w ##class(web.DHCRisWardQuery).SetPrintData("56")
/// 获取病区打印数据
/// 按照医嘱号来设置打印标示
/// sunyi 2011-12-16
ClassMethod SetPrintFlag(oeorditemdr As %String)
{
	s ^t=oeorditemdr
	s ^DHCRISORDITEMPRINTED(oeorditemdr)="Y"	
	q 0
}

ClassMethod GetAge(papatmasmdr As %String) As %String
{
	i (papatmasmdr'="")
	{
		s DOB=$p($g(^PAPER(papatmasmdr,"ALL")),"^",6)
	    i DOB="" d
	 	.s strDOB=""
	 	.s strAge=""
	 	e  d
	    .s strDOB=$ZD(DOB,3)
	    .s strToday=$ZD(+$h,3)
	    .s strAge=##class(web.DHCRisCommFunction).CalAge(strDOB,strToday)
	}
	
    q $g(strAge)
}

/// 判断医嘱是否已打印
/// "Y"_已打印——N_未打印
/// sunyi 2011-11-17
/// w ##class(web.DHCRisWardQuery).IsPrint("1747||50")
ClassMethod IsPrint(oeorditemdr As %String)
{
	
	s PrintFlag=$g(^DHCRISORDITEMPRINTED(oeorditemdr))
	
	i (PrintFlag="Y")
	{
	   s IsFlag="Y"
	}
	else
	{
		s IsFlag="N"
	}	
	
	q IsFlag
}

/// 打印时保存日期、时间到临时节点
/// sunyi 2011-11-18
ClassMethod SetPrintDateTime(oeorditemdr As %String)
{
	s PrintDate= $zd($h,3)
    s PrintTime=$zt($p($h,",",2))
	s ^DHCRISPRINTDATETIME(oeorditemdr)=PrintDate_"^"_PrintTime
	s Info=$g(^DHCRISPRINTDATETIME(oeorditemdr))
	q Info
}

ClassMethod GetPrintDataTime(oeorditemdr As %String)
{
	s PrintData=$g(^DHCRISPRINTDATETIME(oeorditemdr))
	q PrintData
}

/// 查询医嘱的接收科室
/// do ##class(%ResultSet).RunQuery("web.DHCRisWardQuery","QueryRecLoc","yxyx")
Query QueryRecLoc(Desc As %String) As %Query(ROWSPEC = "TRowid:%String,Desc:%String")
{
}

ClassMethod QueryRecLocExecute(ByRef qHandle As %Binary, Desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
    s LocType="E"
    
    s Desc=$ZCONVERT(Desc,"U")
    Set rowid=0	f  s rowid=$o(^CTLOC(0,"LocType",LocType,rowid)) q:rowid=""  d
	.s GetDesc=$p($g(^CTLOC(rowid)),"^",2) 
	.q:((Desc'="")&(GetDesc'[Desc))
	.Do OutRowRecLoc
	
	 Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
OutRowRecLoc
	set Data=$lb(rowid,GetDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryRecLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRecLocExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

ClassMethod QueryRecLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRecLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetPrintCount(UserId As %String)
{
 
    s Count=0
	s Count=$g(^DHCRISTEMPWARDQUERYDATA(UserId))
	q Count
}

ClassMethod SetPrintData(UserId As %String, i As %String = "1")
{
	s PrintData=""
	if ($d(^DHCRISTEMPWARDQUERYDATA(UserId,i)))
	{
	   s PrintData=	$g(^DHCRISTEMPWARDQUERYDATA(UserId,i))
	}
	q PrintData
}

/// do ##class(web.DHCRisWardQuery).SetExeLoc()
ClassMethod SetExeLoc()
{
	s Info="75@76@77@78@79@80@81@82@83@84@85@86@87@88"
	s ^DHCRISEXELOC("QueryExeLoc")=Info
}

ClassMethod RequestBookType(arcimid As %String) As %String
{
	q:(arcimid="") 
	s ItemBookeRowid="",MehtodDesc="",AppointmentMethodId=""
   	s ItemBookeRowid=$o(^DHCRBCItemBookProperTypei(arcimid,0))
   	i ItemBookeRowid'="" d
   	.s AppointmentMethodId=$p(^DHCRBCItemBookProperty(ItemBookeRowid),"^",2)
   	.i AppointmentMethodId'="" d
   	..s MehtodDesc=$p(^DHCRBCAppointMethod(AppointmentMethodId),"^",2)
   	q MehtodDesc
}

//w ##class(web.DHCRisWardQuery).Insert()

ClassMethod Insert() As %String
{
	s LocDR="83"
	s OrdRowid="20017||389"
	s ResCode="Vivi7"
	s ResDesc="vivi7"
	s BKDate="63333"
	s BKTime="48253"
	s Operater="ris"
	s Date=+$h
	s Time=$p($h,",",2)
	
	&sql(insert into  DHCRBC_ExternalBookInfo(DEB_Loc_DR,DEB_OrdRowid,DEB_ResourceCode,DEB_ResourceDesc,DEB_BookDate,DEB_BookTime,DEB_Operater,DEB_Date,DEB_Time) 
	    				    values (:LocDR,:OrdRowid,:ResCode,:ResDesc,:BKDate,:BKTime,:Operater,:Date,:Time))
	q SQLCODE
}

ClassMethod SetData(Arcitmid As %String, UserID As %String, Data As %String) As %String
{
     i ('$d(^DHCRISNURSEQUERYDATA(UserID,Arcitmid)))
     {
	     s ^DHCRISNURSETMPINDEX(UserID,Arcitmid)=1
	     s Index=^DHCRISNURSETMPINDEX(UserID,Arcitmid)
	     s ^DHCRISNURSEQUERYDATA(UserID,Arcitmid,Index)=Data
	 }else
	 {
		 s ^DHCRISNURSETMPINDEX(UserID,Arcitmid)=^DHCRISNURSETMPINDEX(UserID,Arcitmid)+1
		 s Index=^DHCRISNURSETMPINDEX(UserID,Arcitmid)
		 s ^DHCRISNURSEQUERYDATA(UserID,Arcitmid,Index)=Data
     }
     q 0
}

/// w ##class(web.DHCRisWardQuery).RequestPrintData("20017||3894")
ClassMethod RequestPrintData(oeorditemdr As %String) As %String
{
	//登记号^病案号^姓名^性别^年龄^床号^病区^医嘱^申请医生^申请科室^临床所见^检查目的^诊断
	q:(oeorditemdr="") ""
	s EpisodeID="",PaadmInfo="",Info="",arcimid="",AppLocDR="",GetMemo=""
	s OrderRowid=$p(oeorditemdr,"||",1)
	s itemsub=$p(oeorditemdr,"||",2)
	s EpisodeID=$p(^OEORD(OrderRowid),"^",1)
	q:(EpisodeID="") ""

    s PatientNow=##class(web.DHCRisApplicationBill).GetCurrentStatus(EpisodeID)
    s MainDiagose=##class(web.DHCRisCommFunctionEx).GetDiagnose(EpisodeID)
    s purpose=##class(web.DHCRisApplicationBill).GetGlobal(oeorditemdr)
	s PaadmInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(EpisodeID)
	
	i PaadmInfo'="" d
	.s GetRegNo=$p(PaadmInfo,"^",1)
	.s GetMedicareNo=$p(PaadmInfo,"^",33)
	.s GetName=$p(PaadmInfo,"^",2)
	.s GetSex=$p(PaadmInfo,"^",5)
	.s GetAge=$p(PaadmInfo,"^",4)
	.s Getbedno=$p(PaadmInfo,"^",11)
	.s Getwardname=$p(PaadmInfo,"^",10)
	.s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
	.s AppLocDR=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",3)
	.s GetMemo=..RequestMemo(oeorditemdr)
    .i arcimid'="" s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
    .s GetAppDoc=$p(PaadmInfo,"^",18)
    .;s GetAppLoc=$p(PaadmInfo,"^",39)
    .i AppLocDR'="" s GetAppLoc=$p($g(^CTLOC(AppLocDR)),"^",2)
    .i GetAppLoc'="" s GetAppLoc=$p($g(GetAppLoc),"-",2)
    .s Info=GetRegNo_"^"_GetMedicareNo_"^"_GetName_"^"_GetSex_"^"_GetAge_"^"_Getbedno
    .s Info=Info_"^"_Getwardname_"^"_strOrderName_"^"_GetAppDoc_"^"_GetAppLoc
    .s Info=Info_"^"_PatientNow_"^"_purpose_"^"_MainDiagose_"^"_GetMemo
    
    q Info
}

/// w ##class(web.DHCRisWardQueryZGYD).GetBKFlag("62227||3894")
ClassMethod GetBKFlag(oeorditemdr As %String) As %String
{
	s BOOK="N",Rowid="",CancelFlag="",ERowid=""
	q:(oeorditemdr="") BOOK
	
	s Rowid=$o(^DHCRBCResSchduleDetaili(0,oeorditemdr,Rowid))
	i Rowid'="" s CancelFlag=$p($g(^DHCRBCResSchduleDetail("Detail",Rowid)),"^",7) 
	i ((Rowid'="")&(CancelFlag'="Cancel")) s BOOK="Y"
	
	i BOOK="N"  d
	.s ERowid=$o(^DHCRBCExternalBookInfoi("OrdItemID",oeorditemdr,ERowid))
	.i ERowid'="" s BOOK="Y"
	
	q BOOK
}

/// w ##class(web.DHCRisWardQuery).GetRegFlag("20017||3894")
ClassMethod GetRegFlag(oeorditemdr As %String) As %String
{
	 s RegFlag="N"
	 q:(oeorditemdr="") RegFlag
     
	 s regrowid=$o(^DHCPACRegInfoi("OEORI",oeorditemdr,""))  ; 登记的表中获得检查号
	 i regrowid'=""  s RegFlag="Y"
     q RegFlag
}

/// w ##class(web.DHCRisWardQueryZGYD).GetBKInfo("20017||3894")
ClassMethod GetBKInfo(oeorditemdr As %String) As %String
{
	s BOOK="N",Rowid="",CancelFlag="",ERowid="",Info=""
	s AppointDate="",AppointTime="",ResDesc="",ResouceId="",CareProvId="",RInfo="",RoomAddress=""
	s BookIndex="",EndTime=""
	q:(oeorditemdr="") Info
	
	s Rowid=$o(^DHCRBCResSchduleDetaili(0,oeorditemdr,Rowid))
	i Rowid'="" s CancelFlag=$p($g(^DHCRBCResSchduleDetail("Detail",Rowid)),"^",7) 
	i ((Rowid'="")&(CancelFlag'="Cancel")) s BOOK="Y"
	i BOOK="Y" d
	.s SchRowid=$p($g(^DHCRBCResSchduleDetail("Detail",Rowid)),"^",2)
	.s BookIndex=$p($g(^DHCRBCResSchduleDetail("Detail",Rowid)),"^",20)
	.i SchRowid'="" d
	..s AppointDate=$p($g(^DHCRBCResourceSchdule(SchRowid)),"^",2)
	..i AppointDate'="" s AppointDate=$zd(AppointDate,3)
	..s AppointTime=$p($g(^DHCRBCResourceSchdule(SchRowid)),"^",5)
	..s EndTime=$p($g(^DHCRBCResourceSchdule(SchRowid)),"^",6)
	..i EndTime'="" s EndTime=$zt(EndTime,"1")
	..;判断detail表里是否有开始时间
	..i $p($g(^DHCRBCResSchduleDetail("Detail",Rowid)),"^",18)'="" d
	...s AppointTime=$p($g(^DHCRBCResSchduleDetail("Detail",Rowid)),"^",18)
	..i AppointTime'="" s AppointTime=$zt(AppointTime,1)
	..s ResouceId=$p($g(^DHCRBCResourceSchdule(SchRowid)),"^",1)
	..s ResourceDesc=""
	..i ResouceId'="" d
	...s EqId=$p(^RB("RES",ResouceId),"^",3)
	...s CareProvId=$p($g(^RB("RES",ResouceId)),"^",2)
	...i EqId'="" s ResDesc=$p($g(^RBC("EQ",EqId)),"^",2)
	...i EqId'="" s RInfo=..GetEqAddress(EqId)
	...i RInfo'="" s RoomAddress=$p($g(RInfo),"^",2)
	...i CareProvId'="" s ResDesc=$p($g(^CTPCP(CareProvId,1)),"^",2)
	...s Info=AppointDate_"^"_AppointTime_"^"_ResDesc_"^"_RoomAddress_"^"_BookIndex_"^"_EndTime
	
	i BOOK="N"  d
	.s ERowid=$o(^DHCRBCExternalBookInfoi("OrdItemID",oeorditemdr,ERowid))
	.i ERowid'="" d
	..s AppointDate=$p($g(^DHCRBCExternalBookInfo(ERowid)),"^",5)
	..i AppointDate'="" s AppointDate=$zd(AppointDate,3)
	..s AppointTime=$p($g(^DHCRBCExternalBookInfo(ERowid)),"^",6)
	..i AppointTime'="" s AppointTime=$zt(AppointTime,1)
	..s ResDesc=$p($g(^DHCRBCExternalBookInfo(ERowid)),"^",4)
	..s Info=AppointDate_"^"_AppointTime_"^"_ResDesc_"^^"_BookIndex_"^"_EndTime
	
	
	q Info
}

/// w ##class(web.DHCRisWardQueryZGYD).GetEqAddress("11")
ClassMethod GetEqAddress(EqId As %String) As %String
{
	s RoomID="",RoomDesc="",RoomAdress="",Info=""
	q:(EqId="") Info
	;s EqRowid=$p($g(^RB("RES",resourceId)),"^",3)
	i (EqId'="")
	{
		s RoomID=$o(^DHCRBC("EQDR-ROOM",EqId,RoomID))
		i RoomID'="" d
		.s RoomDesc=$p($g(^DHCRBC("Room",RoomID)),"^",2)
		.s RoomAdress= $p($g(^DHCRBC("Room",RoomID)),"^",4)
		.s Info=RoomDesc_"^"_RoomAdress
	}
	q Info
}

/// 20017||3899@20017||3900@76304||6
/// w ##class(web.DHCRisWardQueryZGYD).RequestMemo("20017||3899")
ClassMethod RequestMemo(OEOrdItemID As %String) As %String
{
	q:(OEOrdItemID="")
	s OEOrdItemID=$p(OEOrdItemID,"@",1)
	
	s OrderRowid=$p(OEOrdItemID,"||",1)
	s itemsub=$p(OEOrdItemID,"||",2)
	s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	s Memo="",MRowid="",MTRowid="",ERowid=""
	
	i arcimid'="" d
	.s MRowid=$o(^DHCRBAppi("Memo-ItMast",arcimid,0))
	.i MRowid'="" d
	..s MTRowid=$p($g(^DHCRBApp("Memo",MRowid)),"^",4)
	..i MTRowid'=""  s Memo=$p($g(^DHCRBCApp("Memo-Template",MTRowid)),"^",3)
	..i Memo="" s Memo=$p($g(^DHCRBApp("Memo",MRowid)),"^",2)
	
	i ((Memo="")!(Memo=" ")) d
	.s ERowid=$o(^DHCRBCExternalBookInfoi("OrdItemID",OEOrdItemID,ERowid))
	.i ERowid'="" s Memo=$p($g(^DHCRBCExternalBookInfo(ERowid)),"^",10)
	
	i Memo="" s Memo="无"
	
	q Memo
}

/// do ##class(web.DHCRisApplicationBill).IsSendAppBill("255246||9")
/// 判断是否发送了申请单
/// sunyi 2012-11-05
ClassMethod IsSendAppBill(OEorditemID As %String)
{
	s Send="N",AppRowid=""
	q:(OEorditemID="") Send
		 
	s AppRowid=$o(^DHCRBAppOrdi(0,OEorditemID,0)) 
    i AppRowid'="" d
    .s Send="Y"
    else  d
    .s Send="N"
    
    q Send
}

/*ClassMethod SplitSameBookGroup(OEOrdItemID As %String, UserID As %String) As %String
{
   q:(OEOrdItemID="") ""
   i UserID="" s UserID="71"
   k ^DHCRISSAMEBOOKED("SAMEBOOKITEM",UserID)
   
   s Count=$l(OEOrdItemID,"@")
   s Info=""
	
   f i=1:1:Count 
   {
	  s perOEOrditenRowid=$p(OEOrdItemID,"@",i)
	  s SchudleRowid="",DetailRowid="",paadmdr="",papatmasmdr="",RegNo=""
	  s OrderRowid=$p(perOEOrditenRowid,"||",1)
	  s paadmdr=$p(^OEORD(OrderRowid),"^",1)
	  i paadmdr'="" s papatmasmdr=$p($g(^PAADM(paadmdr)),"^",1)
	  i papatmasmdr'="" s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
	  s DetailRowid=$o(^DHCRBCResSchduleDetaili(0,perOEOrditenRowid,0))
	  i DetailRowid'="" s SchudleRowid=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",2)
	  i ((SchudleRowid'="")&(RegNo'=""))
	  {
		  i '$d(^DHCRISSAMEBOOKED("SAMEBOOKITEM",UserID,RegNo,SchudleRowid))
		  {
			 s ^DHCRISSAMEBOOKED("SAMEBOOKITEM",UserID,RegNo,SchudleRowid)=perOEOrditenRowid 
		  }else
		  {
			  i $d(^DHCRISSAMEBOOKED("SAMEBOOKITEM",UserID,RegNo,SchudleRowid)) d
			  .s ^DHCRISSAMEBOOKED("SAMEBOOKITEM",UserID,RegNo,SchudleRowid)=$g(^DHCRISSAMEBOOKED("SAMEBOOKITEM",UserID,RegNo,SchudleRowid))_"@"_perOEOrditenRowid
		  }  
	  } 
   }
   
   s RegNo=""  f  s RegNo=$o(^DHCRISSAMEBOOKED("SAMEBOOKITEM",UserID,RegNo)) q:(RegNo="")  d
   .s SchudleID=""  f  s SchudleID=$o(^DHCRISSAMEBOOKED("SAMEBOOKITEM",UserID,RegNo,SchudleID)) q:(SchudleID="")  d
   ..i Info="" s Info=$g(^DHCRISSAMEBOOKED("SAMEBOOKITEM",UserID,RegNo,SchudleID))
   ..e  d
   ...s Info=$g(^DHCRISSAMEBOOKED("SAMEBOOKITEM",UserID,RegNo,SchudleID))_"^"_Info
   
   q Info
}*/
/// 函数名称:GetSelItemGroup
/// 入参:(医嘱ID@医嘱ID@.....,用户ID)
/// 功能:根据选中的预约记录把相同病人的相同设备分组 
/// 返回值:医嘱ID@医嘱ID@^医嘱ID@医嘱ID@^........
/// 作者:sunyi
/// 日期:2014-08-06 
/// w ##class(web.DHCRisWardQueryZGYD).SplitSameBookGroup("20017||3899@20017||3900@76304||6@70113||280@74301||218","687")
/// w ##class(web.DHCRisWardQueryZGYD).SplitSameBookGroup("62223||627@62223||628@70113||280@74301||218@70113||278","687")
ClassMethod SplitSameBookGroup(OEOrdItemID As %String, UserID As %String) As %String
{
   q:(OEOrdItemID="") ""
   i UserID="" s UserID="71"
   k ^DHCRISSAMEBOOKED("SAMEBOOKITEM",UserID)
   k ^DHCRISFUWUTAIBOOKED("FUWUTAI",UserID)
   
   s Count=$l(OEOrdItemID,"@")
   s Info="",InfoN="",InfoS=""
	
   f i=1:1:Count 
   {
	  s perOEOrditenRowid=$p(OEOrdItemID,"@",i)
	  s SchudleRowid="",DetailRowid="",paadmdr="",papatmasmdr="",RegNo=""
	  s arcimid="",BPRowid="",AppointMethodId="",AppMethod=""
	  s OrderRowid=$p(perOEOrditenRowid,"||",1)
	  s itemsub=$p(perOEOrditenRowid,"||",2)
	  s paadmdr=$p(^OEORD(OrderRowid),"^",1)
	  i paadmdr'="" s papatmasmdr=$p($g(^PAADM(paadmdr)),"^",1)
	  i papatmasmdr'="" s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
	  s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	  i arcimid'="" s BPRowid=$o(^DHCRBCItemBookProperTypei(arcimid,0))
	  i BPRowid'="" s AppointMethodId=$p($g(^DHCRBCItemBookProperty(BPRowid)),"^",2) 
      i AppointMethodId'="" s AppMethod=$p($g(^DHCRBCAppointMethod(AppointMethodId)),"^",2)
      //w !,"AppMethod="_AppMethod
	  
	  s DetailRowid=$o(^DHCRBCResSchduleDetaili(0,perOEOrditenRowid,0))
	  i DetailRowid'="" s SchudleRowid=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",2)
	  i (AppMethod="自动预约")
	  {   
	      //w !,"SchudleRowid="_SchudleRowid_"--"_RegNo
		  i ((SchudleRowid'="")&(RegNo'=""))
		  {
			  i '$d(^DHCRISSAMEBOOKED("SAMEBOOKITEM",UserID,RegNo,SchudleRowid))
			  {
				 s ^DHCRISSAMEBOOKED("SAMEBOOKITEM",UserID,RegNo,SchudleRowid)=perOEOrditenRowid 
			  }else
			  {
				  i $d(^DHCRISSAMEBOOKED("SAMEBOOKITEM",UserID,RegNo,SchudleRowid)) d
				  .s ^DHCRISSAMEBOOKED("SAMEBOOKITEM",UserID,RegNo,SchudleRowid)=$g(^DHCRISSAMEBOOKED("SAMEBOOKITEM",UserID,RegNo,SchudleRowid))_"@"_perOEOrditenRowid
			  }  
		  } 
	  }else
	  {
		  i (RegNo'="") d
		  .i '$d(^DHCRISFUWUTAIBOOKED("FUWUTAI",UserID,RegNo)) d
		  ..s ^DHCRISFUWUTAIBOOKED("FUWUTAI",UserID,RegNo)=perOEOrditenRowid
		  .e  d
		  ..i $d(^DHCRISFUWUTAIBOOKED("FUWUTAI",UserID,RegNo)) d
		  ...s ^DHCRISFUWUTAIBOOKED("FUWUTAI",UserID,RegNo)=$g(^DHCRISFUWUTAIBOOKED("FUWUTAI",UserID,RegNo))_"@"_perOEOrditenRowid
		  
	  }
   }
   
   i ($d(^DHCRISSAMEBOOKED("SAMEBOOKITEM",UserID)))
   {
	   s RegNo=""  f  s RegNo=$o(^DHCRISSAMEBOOKED("SAMEBOOKITEM",UserID,RegNo)) q:(RegNo="")  d
	   .s SchudleID=""  f  s SchudleID=$o(^DHCRISSAMEBOOKED("SAMEBOOKITEM",UserID,RegNo,SchudleID)) q:(SchudleID="")  d
	   ..i Info="" s Info=$g(^DHCRISSAMEBOOKED("SAMEBOOKITEM",UserID,RegNo,SchudleID))
	   ..e  d
	   ...s Info=$g(^DHCRISSAMEBOOKED("SAMEBOOKITEM",UserID,RegNo,SchudleID))_"^"_Info
	   //w "--Yes----"_Info_"-------"
   }
   
   i ($d(^DHCRISFUWUTAIBOOKED("FUWUTAI",UserID)))
   {
	   s RegNo=""  f  s RegNo=$o(^DHCRISFUWUTAIBOOKED("FUWUTAI",UserID,RegNo)) q:(RegNo="")  d
	   .i InfoN="" s InfoN=$g(^DHCRISFUWUTAIBOOKED("FUWUTAI",UserID,RegNo))
	   .e  d
	   ..s InfoN=$g(^DHCRISFUWUTAIBOOKED("FUWUTAI",UserID,RegNo))_"^"_InfoN
	   //w "--NO----"_InfoN_"------"
   }
   i (Info'="")&(InfoN'="")
   {
	   s InfoS=InfoN_"^"_Info
   }elseif ((Info'="")&(InfoN=""))
   {
	   s InfoS=Info
   }elseif((Info="")&(InfoN'=""))
   {
	   s InfoS=InfoN
   }
   
   q InfoS
}

/// 函数名称:SameMemoGroup
/// 入参:同一病人的相同预约资源医嘱ID（用@分割,用户ID
/// 功能:根据同一病人的相同预约资源医嘱分组再按相同备份分组
/// 返回值:相同注意事项的医嘱ID用"@"分割不同用 "^"分割 20017||3899@20017||3900^20017||38....
/// 作者: sunyi 
/// 日期:2014-08-08
/// w ##class(web.DHCRisWardQueryZGYD).SameMemoGroup("20017||3899@20017||3900","687")
ClassMethod SameMemoGroup(SplitArray As %String, UserID As %String) As %String
{
	i UserID="" s UserID="71"
	k ^DHCRISSAMEMEMO("NOMEMO",UserID)
	k ^DHCRISSAMEMEMO("SAMEMEMO",UserID)
   
    s Counts=0
    s Counts=$l(SplitArray,"@")
    s Info=""
	
    for j=1:1:Counts 
    {   
        s MTRowid="",MRowid="",perOEOrdItemID="",OrderRowid="",itemsub=""
        s arcimid=""
        s perOEOrdItemID=$p(SplitArray,"@",j)
        ;w !,"perOEOrdItemID="_perOEOrdItemID
	    s OrderRowid=$p(perOEOrdItemID,"||",1)
	    ;w !,"OrderRowid="_OrderRowid
	    s itemsub=$p(perOEOrdItemID,"||",2)
	    ;w !,"itemsub="_itemsub
	    s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	    ;w !,"arcimid="_arcimid
	    i arcimid'="" s MRowid=$o(^DHCRBAppi("Memo-ItMast",arcimid,0))
	    i MRowid'="" s MTRowid=$p($g(^DHCRBApp("Memo",MRowid)),"^",4)
	    i (MTRowid'="")
	    {
		    i '$d(^DHCRISSAMEMEMO("SAMEMEMO",UserID,MTRowid))
		    {
		      s ^DHCRISSAMEMEMO("SAMEMEMO",UserID,MTRowid)=perOEOrdItemID
		    }
		    else
		    {
		       i $d(^DHCRISSAMEMEMO("SAMEMEMO",UserID,MTRowid)) d
		       .s ^DHCRISSAMEMEMO("SAMEMEMO",UserID,MTRowid)=$g(^DHCRISSAMEMEMO("SAMEMEMO",UserID,MTRowid))_"@"_perOEOrdItemID 
		    } 
		}else
		{
			i '$d(^DHCRISSAMEMEMO("NOMEMO",UserID))
		    {
		      s ^DHCRISSAMEMEMO("NOMEMO",UserID)=perOEOrdItemID
		    }
		    else
		    {
		       i $d(^DHCRISSAMEMEMO("NOMEMO",UserID)) d
		       .s ^DHCRISSAMEMEMO("NOMEMO",UserID)=$g(^DHCRISSAMEMEMO("NOMEMO",UserID))_"@"_perOEOrdItemID 
		    } 
		}
	}
	
	s MTRowid=""  f  s MTRowid=$o(^DHCRISSAMEMEMO("SAMEMEMO",UserID,MTRowid)) q:(MTRowid="")  d
	.i Info="" s Info=$g(^DHCRISSAMEMEMO("SAMEMEMO",UserID,MTRowid))
	.e  d
	..s Info=$g(^DHCRISSAMEMEMO("SAMEMEMO",UserID,MTRowid))_"^"_Info
	
	i $d(^DHCRISSAMEMEMO("NOMEMO",UserID))
	{   i Info="" s Info=$g(^DHCRISSAMEMEMO("NOMEMO",UserID))
	    e  d
	    .s Info=Info_"^"_$g(^DHCRISSAMEMEMO("NOMEMO",UserID))	
	}
	
	q Info
}

/// w ##class(web.DHCRisWardQueryZGYD).GetAttion("20017||3899@20017||3900^76304||6")
ClassMethod GetAttion(SameMemoAaray As %String) As %String
{
	s SameCounts=0
    s SameCounts=$l(SameMemoAaray,"^")
    s Info="",Memo=""
	
    for k=1:1:SameCounts 
    {
	    s perSameGroupCount=0
	    s perSameGroup="",OrdNameInfo="",perMemo=""
	    s perSameGroup=$p(SameMemoAaray,"^",k)
	    s perSameGroupCount=$l(perSameGroup,"@")
	    i perSameGroupCount'=0 s FistOEOrdItmRowid=$p(perSameGroup,"@",1)
	    i (FistOEOrdItmRowid'="")
	    {
		    s perMemo=..RequestMemo(FistOEOrdItmRowid)
		    s perMemo="            注意事项:"_perMemo
		}
	    f m=1:1:perSameGroupCount
	    {
		    s OEOrdItmRowid="",ArcItmID="",OrdName=""
		   
		    s OEOrdItmRowid=$p(perSameGroup,"@",m)
		    s OrderRowid=$p(OEOrdItmRowid,"||",1)
		    s itemsub=$p(OEOrdItmRowid,"||",2)
		    i OEOrdItmRowid'="" s ArcItmID=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
		    i ArcItmID'="" s OrdName=$p(^ARCIM($p(ArcItmID,"||",1),$p(ArcItmID,"||",2),1),"^",2)
		    i (OrdNameInfo="")
		    { 
		       s OrdNameInfo="检查项目:"_OrdName
		    }else
		    {
			   s OrdNameInfo=OrdNameInfo_$C(13,10)_"                     "_OrdName
			}
		   
		}
		
		 i (Info="")
		 { 
		    s Info=OrdNameInfo_$C(13,10)_perMemo
		 }else
		 {
			s Info=Info_$C(13,10)_OrdNameInfo_$C(13,10)_perMemo
		 }
	    
	       
    }
    
    q Info
}

/// 函数名称:GetBookedPrintInfo
/// 入参:同一病人的相同预约资源医嘱ID（用@分割,用户ID
/// 功能:返回打印信息
/// 返回值:
/// 作者: sunyi 
/// 日期:2014-08-08
/// w ##class(web.DHCRisWardQueryZGYD).GetBookedPrintInfo("20017||3900@20017||3899","687")
ClassMethod GetBookedPrintInfo(perSameBKAarray As %String, UserID As %String) As %String
{
	s Info=""
	i UserID="" s UserID="71"
	
	q:(perSameBKAarray="") Info
	s FristOrdItmRowid="",paadmdr="",OrderID="",ItemID="",PInfo="",BInfo=""
	s (RegNo,Name,strDOB,strAge,SexDesc,wardname,bedname,RecLocdr,RecLocDesc)=""
	s (AppointDate,AppointTime,ResDesc,Address,Memo,OEordItmIDGroup,PrintSet,BookedNo,strEndTime,Diagnose)=""
	s (BKMethod)=""
	s FristOrdItmRowid=$p(perSameBKAarray,"@",1)
	
	s OrderID=$p(FristOrdItmRowid,"||",1)
	s ItemID=$p(FristOrdItmRowid,"||",2)
	s paadmdr=$p(^OEORD(OrderID),"^",1)
	
	i (paadmdr'="")
	{
	   s PInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
	   i PInfo'="" d
	   .s RegNo=$p($g(PInfo),"^",1)
	   .s Name=$p($g(PInfo),"^",2)
	   .s strDOB=$p($g(PInfo),"^",3)
	   .s strAge=$p($g(PInfo),"^",4)
	   .s SexDesc=$p($g(PInfo),"^",5)
	   .s wardname=$p($g(PInfo),"^",10)
	   .s bedname=$p($g(PInfo),"^",11)
	   .s AppDoc=$p($g(PInfo),"^",18)
	   .s MedicareNo=$p($g(PInfo),"^",33)
	   .s Diagnose="" //..GetMainDiagnosByPAADM(paadmdr)
	} 
	
	
	s RecLocdr=$p(^OEORD(OrderID,"I",ItemID,3),"^",6)
	s caredr="",requestdoc=""
	s caredr=$p($g(^OEORD(OrderID,"I",ItemID,1)),"^",11) ;下医嘱医生
	if caredr'="" s requestdoc=$p($g(^CTPCP(caredr,1)),"^",2)
	if RecLocdr'="" d
	.s RecLocDesc=$p(^CTLOC(RecLocdr),"^",2)
	.i $f(RecLocDesc,"-")>0 d
	..s RecLocDesc=$p(RecLocDesc,"-",2)
	.s Address=$p($g(^CTLOC(RecLocdr),"ADDR"),"^",16)
	.;w !,"Address="_Address
	
    s ArcItemId=$p($g(^OEORD(OrderID,"I",ItemID,1)),"^",2)
    
	i (ArcItemId'="") 
	{   
	    if (Address="")
	    {
		    s DIBPRowid=""
			s DIBPRowid=$o(^DHCRBCItemBookProperTypei(ArcItemId,DIBPRowid))
			i DIBPRowid'="" s Address=$p($g(^DHCRBCItemBookProperty(DIBPRowid)),"^",5)
			;w !,"Address1="_Address
	    }
	    
	    s BKMethod=..RequestBookType(ArcItemId)
	    i BKMethod="" s BKMethod="服务台预约"
	}
    
	s BInfo=..GetBKInfo(FristOrdItmRowid)
	i BInfo'="" d
	.s AppointDate=$p($g(BInfo),"^",1)
	.s AppointTime=$p($g(BInfo),"^",2)
	.s ResDesc=$p($g(BInfo),"^",3)
	.s Address=$p($g(BInfo),"^",4)
	.s BookedNo=$p($g(BInfo),"^",5)
	.s strEndTime=$p($g(BInfo),"^",6)
	
	i BKMethod'="自动预约" d
	.s AppointDate="",AppointTime="",Address="待定"
	
	s OEordItmIDGroup=..SameMemoGroup(perSameBKAarray,UserID)
	i OEordItmIDGroup'="" d
	.s Memo=..GetAttion(OEordItmIDGroup)
	
	s SetCount=0
	s SetCount=$l(perSameBKAarray,"@")
    f m=1:1:SetCount d
    .s PrintSet=..SetPrintFlag($p(perSameBKAarray,"@",m))
   
	s Info=RecLocdr_"^"_RegNo_"^"_Name_"^"_SexDesc_"^"_strAge_"^"_wardname_"^"_bedname_"^"_RecLocDesc_"^"_AppointDate_"^"_AppointTime_"^"_ResDesc_"^"_Address_"^"_Memo_"^"_BookedNo_"^"_strEndTime_"^"_requestdoc_"^"_Diagnose_"^"_BKMethod
	
	q Info
}

/// 获取RIS3.0检查状态
/// do ##class(web.DHCRisWardQueryZGYD).GetPrintStatusList()
ClassMethod GetPrintStatusList() As %String
{
	s ret="S"_$C(1)_"全部"_"^"_"Y"_$C(1)_"已打印"_"^"_"N"_$C(1)_"未打印"
	q ret
}

ClassMethod GetMainDiagnosByPAADM(EpisodeID As %String) As %String
{
	q:EpisodeID="" "" //"-1^就诊号不能为空"
	s MRRowid=$p($g(^PAADM(EpisodeID)),"^",61)
	q:MRRowid="" "" //"-2^诊断号为空"
	s MainDiagnosDesc=""
	s MRDIAChildRowid=0 f  s MRDIAChildRowid=$o(^MR(MRRowid,"DIA",MRDIAChildRowid)) q:(childrowid="")!(MainDiagnosDesc'="")  d
	.s TYPChildsub=0 f  s TYPChildsub=$o(^MR(MRRowid,"DIA",MRDIAChildRowid,"TYP",TYPChildsub)) q:(TYPChildsub="")!(MainDiagnosDesc'="")  d
	..s TYPMRCDiagTyp=$p($g(^MR(MRRowid,"DIA",MRDIAChildRowid,"TYP",TYPChildsub)),"^",1)
	..q:TYPMRCDiagTyp=""
	..s DTYPDesc=$p(^MRC("DTYP",TYPMRCDiagTyp),"^",2)
	..if DTYPDesc["主诊断" d
	...s MRDIAICDCodeDR=$p(^MR(MRRowid,"DIA",MRDIAChildRowid),"^",1) 
	...q:MRDIAICDCodeDR=""
	...s MainDiagnosDesc=$p($g(^MRC("ID",MRDIAICDCodeDR)),"^",2)
	q MainDiagnosDesc
}

/// 根据科室ID获取所有设备ID
/// sunyi 2012-01-10  
/// w ##class(web.DHCRisWardQueryZGYD).GetBookMethod()
ClassMethod GetBookMethod() As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisBookParam:QueryBookMethod")
	s ret=""
	do rset.Execute()
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(1)_$C(1)_rset.GetData(2)
	    e  s ret=ret_"^"_rset.GetData(1)_$C(1)_rset.GetData(2)
	}	
	d rset.Close()
	s ret="0"_$C(1)_""_"^"_ret
	q ret
}

}
