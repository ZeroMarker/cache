Import SQLUser

Class web.DHCRisWardQuery Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 21;

/// 登记日期，登记时间，病人状态
/// d ##class(%ResultSet).RunQuery("web.DHCRisWardQuery","QueryItemByWard","5^^^^^^N^N^4636^^Y","26/11/2018","26/11/2018")
/// d ##class(%ResultSet).RunQuery("web.DHCRisWardQuery","QueryItemByWard","^^^^B^^^^687","62578","62810")
Query QueryItemByWard(strCondition As %String, startdate As %String, enddate As %String) As %Query(ROWSPEC = "Tregno:%String,Tname:%String,Tsex:%String,Tbedno:%String,Titemname:%String,TstrDate:%String,TstrTime:%String,Tdepname:%String,TPatientStatus:%String,TAppointDate:%String,TAppointstTime:%String,TResDesc:%String,TstrRegDate:%String,TstrRegTime:%String,TStudyNo:%String,TReportDoc:%String,TReportVerifyDoc:%String,TRisStatusDesc:%String,Twarddesc:%String,TAge:%String,PrintFalg:%String,OEOrdItemID:%String,MeothodDesc:%String,RecLocDR:%String,IsSend:%String,Memo:%String,bodyRowid:%String")
{
}

ClassMethod QueryItemByWardExecute(ByRef qHandle As %Binary, strCondition As %String, startdate As %String, enddate As %String) As %Status
{
   
   s ^DHCRis("TEMPXX")=strCondition_"&&&"_startdate_"&&&"_enddate
   
   //if startdate["-" s startdate=$zdh(startdate,3)
   //if enddate["-" s enddate=$zdh(enddate,3)
   s startdate=##class(web.DHCRisCommFunction).changeDateToLogical(startdate)
   s enddate=##class(web.DHCRisCommFunction).changeDateToLogical(enddate)
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
   
   s selByBookDate=$p(strCondition,"^",11)
   
   k ^DHCRISTEMPWARDQUERYDATA($g(InUserId))
   
   Set repid=$I(^CacheTemp)
   If $g(ind)="" Set ind=1
   
   if (selByBookDate="Y")
   {
		s return=..QueryItemByBookDate(ward, ArcItemRowid, InRegNo, InStudyNo, RisStatusCode, RecLocId, IsPrint, InIsBedOrd, InUserId, startdate, enddate, IsNoBK)
	    Quit $$$OK	   
   }
   
   if (ward'="")
   {
	    s return=..QueryWardItem(ward, ArcItemRowid, InRegNo, InStudyNo, RisStatusCode, RecLocId, IsPrint, InIsBedOrd, InUserId, startdate, enddate, IsNoBK)
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
       //s return=..QueryByRegDate(ward, ArcItemRowid, InRegNo, InStudyNo, RisStatusCode, RecLocId, IsPrint, InIsBedOrd,InUserId,startdate, enddate)
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
       ..s bodydrList=##Class(web.DHCRisWorkBenchDoEx).GetstrOrderName(Oeorditemdr)
	   ..s AppBillNo=##Class(web.DHCAPPInterface).GetExaReqNo(Oeorditemdr)    //申请单号
	   ..;w !,"bodydrList="_bodydrList
	   ..s NumLeng=$L(bodydrList,"^")
	   ..f j=1:1:NumLeng  d  
	   ...s bodypart=$p($g(bodydrList),"^",j)
	   ...s bodypartRowid=$p($g(bodypart),":",1) 
	   ...s bodypartDesc=$p($g(bodypart),":",2) 
       ...;w !,"Oeorditemdr="_Oeorditemdr
       ...s IsBKFlag="",IsRegFlag=""
       ...s IsBKFlag=..GetBKFlag(Oeorditemdr,bodypartRowid)
       ...q:(IsBKFlag="Y")
       ...s IsRegFlag=..GetRegFlag(Oeorditemdr,bodypartRowid)
       ...q:(IsRegFlag="Y")
       ...s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
       ...s MeothodDesc="",Memo=""
       ...s methodInfo=..getBookType(Oeorditemdr,bodypartRowid)
       ...s MeothodDesc=$p(methodInfo,"^",2)
       ...;s MeothodDesc=..RequestBookType(arcimid)
       ...;q:((IsNoBK="Y")&((MeothodDesc=" ")!(MeothodDesc="")!(MeothodDesc'="不需预约")))
       ...;q:((IsNoBK="Y")&((MeothodDesc'="不需预约")&(MeothodDesc'="")))
       ...s IsSend=""
       ...;s IsSend=##class(web.DHCRisApplicationBill).IsSendAppBill(Oeorditemdr)
       ...s RecLocdr=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)
       ...q:(RecLocId'="")&(RecLocId'=RecLocdr)
       ...q:(ArcItemRowid'="")&(ArcItemRowid'=arcimid)
       ...s PrintFalg=""
       ...i bodypartRowid'="" s PrintFalg=$g(^DHCRISORDITEMPRINTED(Oeorditemdr,bodypartRowid))
       ...e  s PrintFalg=$g(^DHCRISORDITEMPRINTED(Oeorditemdr))
       ...q:(PrintFalg'="")&(IsPrint'=PrintFalg)
       ...s IsMemo=""
       ...s IsMemo=##class(web.DHCRisCommFunctionEx).ExistMemo(Oeorditemdr)
       ...i IsMemo="Y" s Memo="浏览"
       ...s bOut="N"  ;是否已经输出
       ...s paadmdr=$p(^OEORD(OrderRowid),"^",1) 
       ...s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
	   ...s GetRegNo=$p(PatInfo,"^",1)
	   ...q:(InRegNo'="")&(InRegNo'=GetRegNo)
	   ...;w !,"GetRegNo"_GetRegNo
	   ...s GetName=$p(PatInfo,"^",2)
	   ...s GetstrDOB=$p(PatInfo,"^",3)
	   ...s GetstrAge=$p(PatInfo,"^",4)
	   ...s GetstrAge=$p(GetstrAge," ")
	   ...s GetSexDesc=$p(PatInfo,"^",5)
	   ...s Getpatienttype=$p(PatInfo,"^",6)
	   ...q:(Getpatienttype'="I")
	   ...s Gettypedesc=$p(PatInfo,"^",7)
	   ...s GetLocName=$p(PatInfo,"^",8)
	   ...s GetIPNo=$p(PatInfo,"^",9)       ;住院号
	   ...s GetWardName=$p(PatInfo,"^",10)
	   ...s GetBedNo=$p(PatInfo,"^",11)
	   ...s GetReqLocDR=$p(PatInfo,"^",12)
	   ...s GetWardDR=$p(PatInfo,"^",14)
	   ...q:(ward'="")&(ward'=GetWardDR)
	   ...s Getroomdesc=$p(PatInfo,"^",15)
	   ...s GetSexDr=$p(PatInfo,"^",13)
	   ...s PapatmasDR=$p(PatInfo,"^",24)
	   ...s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(OrderRowid,itemsub,bodypartRowid)
	   ...s GetPatientStatusCode="A"
       ...s GetstrOrderName=$p(ordInfo,"^",1)
       ...q:(InIsBedOrd="N")&(GetstrOrderName["床旁")
       ...q:(InIsBedOrd="Y")&(GetstrOrderName'["床旁")
       ...s GetstrDate=$p(ordInfo,"^",2)
       ...s GetstrTime=$p(ordInfo,"^",3)
       ...s Getifbed=$p(ordInfo,"^",9)
       ...s GetItemStatusCode=$p(ordInfo,"^",14)
       ...s GetRecLocName=$p(ordInfo,"^",21)
       ...q:(GetItemStatusCode="U")!(GetItemStatusCode="D") ;过滤作废或停止医嘱
       ...s GetordDate=$p(ordInfo,"^",15)
       ...s GetordTime=$p(ordInfo,"^",16)
       ...s GetItemStatusCode=$p(ordInfo,"^",17)   			;医嘱状态
       ...s GetServerMaterial=$p(ordInfo,"^",18)   			;申请项目标记 
       ...q:(GetServerMaterial'="S")
       ...s GetRecLocDR=$p(ordInfo,"^",19)
       ...s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfo(Oeorditemdr,bodypartRowid)
       ...s GetStudyNo=$p(RegInfo,"^",1)
       ...i GetStudyNo'="" s GetPatientStatusCode="I"
       ...q:(InStudyNo'="")&(InStudyNo'=GetStudyNo)
       ...s GetstrRegDate=$p(RegInfo,"^",2)
       ...s GetstrRegTime=$p(RegInfo,"^",3)
       ...s GetRegDate=$p(RegInfo,"^",17)
       ...s GetResDesc="",strRppDate="",strRppTime=""
       ...i $g(^OEORD(OrderRowid,"I",itemsub,6))'="" d
       ....s Getapprowid=$p(^OEORD(OrderRowid,"I",itemsub,6),"^",5)
       ....i (Getapprowid'="")&(Getapprowid'=$C(0)) d
       .....s ResRowid=$p(Getapprowid,"||",1)
       .....s SchildSub=$p(Getapprowid,"||",2)
       .....s appointchildsub=$p(Getapprowid,"||",3)
       .....s ResDesc=""
 	   .....s CTCPDR=$p($g(^RB("RES",ResRowid)),"^",2)
       .....s CTCPDR=$p(CTCPDR,$c(0))
       .....i CTCPDR'="" d
       ......s GetResDesc=$p($g(^CTPCP(CTCPDR,1)),"^",2)
       .....else  d
       ......s EQDR=$p($g(^RB("RES",ResRowid)),"^",3)
       ......s GetResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
       .....s RppDate=$p(^RBAS(ResRowid,SchildSub),"^",1)
       .....s strRppDate=$zd(RppDate,3)
       .....s RppTime=$p(^RBAS(ResRowid,SchildSub),"^",4)
       .....s strRppTime=$zt(RppTime,1)
       ...s GetReportStatusCode="N"     ;未写报告
       ...s GetImgcount=0
       ...s GetRptID=""
       ...s GetRptDocDR="",GetRptDocName="",GetRptDate="",GetRptTime="",GetVerifyDocDR=""
       ...s GetVerifyDocName="",GetVerifyDate="",GetVerifyTime="",HaveImage=""
       ...i GetStudyNo'="" d
       ....s Imrowid=0 f  s Imrowid=$o(^DHCRBStudyi("StudyNo-Images",GetStudyNo,Imrowid)) q:Imrowid=""  d
       .....s GetPatientStatusCode="E"    ;正在检查
       .....s ExtName=$p($g(^DHCRBStudy(0,"StudyImages",Imrowid)),"^",2)
       .....i ((ExtName="avi")!(ExtName="dcm")!(ExtName="normal")!(ExtName="dsa"))  d
       ......s GetImgcount=GetImgcount+1
       ......s GetReportStatusCode="I"             ;图象已经采集
       ......s HaveImage="是"
       ....s ReportStuatCode="VS"
       ....s Rptrowid=0  f  s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",GetStudyNo,Rptrowid)) q:Rptrowid=""  d
       .....s GetRptID=$p(^DHCRBStudy("Report",Rptrowid),"^",2)
       .....s GetRptVersion=$p(^DHCRBStudy("Report",Rptrowid),"^",3)
       .....s GetRptStatusDR=$p(^DHCRBStudy("Report",Rptrowid),"^",4)
       .....i GetRptStatusDR'="" d
       ......s GetReportStatusCode=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",1)
       ......i ReportStuatCode[GetReportStatusCode d
       .......s GetPatientStatusCode="O"
       ......e  d
       .......s GetPatientStatusCode="E"
       ......s GetRptStatusDesc=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",2)
       .....s GetRptIsYX=$p(^DHCRBStudy("Report",Rptrowid),"^",7)
       .....s GetRptDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",8)
       .....i GetRptDocDR'="" s GetRptDocName=$p(^SSU("SSUSR",GetRptDocDR),"^",2)
       .....s GetRptDate=$p(^DHCRBStudy("Report",Rptrowid),"^",9)
       .....i GetRptDate'="" s GetRptDate=$zd(GetRptDate,3)
       .....s GetRptTime=$p(^DHCRBStudy("Report",Rptrowid),"^",10)
       .....i GetRptTime'="" s GetRptTime=$zt(GetRptTime,3)
       .....s GetVerifyDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",11)
       .....i GetVerifyDocDR'="" s GetVerifyDocName=$p(^SSU("SSUSR",GetVerifyDocDR),"^",2)
       .....s GetVerifyDate=$p(^DHCRBStudy("Report",Rptrowid),"^",12)
       .....i GetVerifyDate'="" s GetVerifyDate=$zd(GetVerifyDate,3) 
       .....s GetVerifyTime=$p(^DHCRBStudy("Report",Rptrowid),"^",13)
       .....i GetVerifyTime'="" s GetVerifyTime=$zt(GetVerifyTime,3)
       .....s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
       .....q:((RisStatusCode'="")&(RisStatusCode'="S")&(RisStatusCode'=GetPatientStatusCode))
       .....s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
       .....s bOut="Y"
       .....Do OutRowALLItemDate
       ...i bOut="N" d
       ....s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
       ....q:((RisStatusCode'="")&(RisStatusCode'="S")&(RisStatusCode'=GetPatientStatusCode))
       ....s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
       ....s bOut="Y"
       ....Do OutRowALLItemDate
    }
    
   s Count=..QueryBookedItem(ward, ArcItemRowid, InRegNo, InStudyNo, RisStatusCode, RecLocId, IsPrint, InIsBedOrd, InUserId,startdate, enddate,IsNoBK)
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK   
   
OutRowALLItemDate
    set Data=$lb(GetRegNo,GetName,GetSexDesc,GetBedNo,GetstrOrderName,GetstrDate,GetstrTime,GetRecLocName,GetReportStatus,strRppDate,strRppTime,GetResDesc,GetstrRegDate,GetstrRegTime,GetStudyNo,GetRptDocName,GetVerifyDocName,GetPatientStatus,GetWardName,GetstrAge,PrintFalg,Oeorditemdr,MeothodDesc,$g(GetRecLocDR),$g(IsSend),$g(Memo),$g(bodypartRowid))
    ;i ((GetRecLocDR'="180")&(GetRecLocDR'="181")) d
    s ^DHCRISTEMPWARDQUERYDATA($g(InUserId),ind)=$g(Oeorditemdr)_"^"_$J_"^"_$g(GetRecLocName)_"^"_$g(GetBedNo)_"^"_$g(GetRegNo)_"^"_$g(GetName)_"^"_$g(GetSexDesc)_"^"_$g(GetstrAge)_"^"_$g(GetstrOrderName)_"^"_$g(GetstrDate)_"^"_$g(GetstrTime)_"^"_$g(strRppDate)_"^"_$g(strRppTime)_"^"_$g(GetstrRegDate)_"^"_$g(GetstrRegTime)_"^"_$g(GetStudyNo)_"^"_$g(GetRptDocName)_"^"_$g(GetVerifyDocName)_"^"_$g(GetPatientStatus)_"^"_$g(GetWardName)_"^"_$g(GetResDesc)_"^"_PrintFalg_"^"_$g(MeothodDesc)_"^"_$g(GetRecLocDR)_"^"_$g(IsSend)_"^"_$g(Memo)_"^"_$g(bodypartRowid)
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
       ..s bodydrList=##Class(web.DHCRisWorkBenchDoEx).GetstrOrderName(Oeorditemdr)
	   ..s AppBillNo=##Class(web.DHCAPPInterface).GetExaReqNo(Oeorditemdr)    //申请单号
	   ..;w !,"bodydrList="_bodydrList
	   ..s NumLeng=$L(bodydrList,"^")
	   ..f j=1:1:NumLeng  d  
	   ...s bodypart=$p($g(bodydrList),"^",j)
	   ...s bodypartRowid=$p($g(bodypart),":",1) 
	   ...s bodypartDesc=$p($g(bodypart),":",2) 
       ...s IsBKFlag="",IsRegFlag=""
       ...s IsBKFlag=..GetBKFlag(Oeorditemdr,bodypartRowid)
       ...q:(IsBKFlag="Y")
       ...s IsRegFlag=..GetRegFlag(Oeorditemdr,bodypartRowid)
       ...q:(IsRegFlag="Y")
       ...s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
       ...s MeothodDesc=""
       ...s methodInfo=..getBookType(Oeorditemdr,bodypartRowid)
       ...s MeothodDesc=$p(methodInfo,"^",2)
       ...;s MeothodDesc=..RequestBookType(arcimid)
       ...;q:((IsNoBK="Y")&((MeothodDesc=" ")!(MeothodDesc="")!(MeothodDesc'="不需预约")))
       ...;q:((IsNoBK="Y")&((MeothodDesc'="不需预约")&(MeothodDesc'="")))
       ...s IsSend="",Memo=""
       ...;s IsSend=##class(web.DHCRisApplicationBill).IsSendAppBill(Oeorditemdr)
       ...s RecLocdr=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)
       ...q:(RecLocId'="")&(RecLocId'=RecLocdr)
       ...q:(ArcItemRowid'="")&(ArcItemRowid'=arcimid)
       ...s PrintFalg=""
       ...i bodypartRowid'="" s PrintFalg=$g(^DHCRISORDITEMPRINTED(Oeorditemdr,bodypartRowid))
       ...e  s PrintFalg=$g(^DHCRISORDITEMPRINTED(Oeorditemdr))
       ...q:(PrintFalg'="")&(IsPrint'=PrintFalg)
       ...s IsMemo=""
       ...s IsMemo=##class(web.DHCRisCommFunctionEx).ExistMemo(Oeorditemdr)
       ...i IsMemo="Y" s Memo="浏览"
       ...s bOut="N"  ;是否已经输出
       ...s paadmdr=$p(^OEORD(OrderRowid),"^",1) 
       ...s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
	   ...s GetRegNo=$p(PatInfo,"^",1)
	   ...q:(InRegNo'="")&(InRegNo'=GetRegNo)
	   ...;w !,"GetRegNo"_GetRegNo
	   ...s GetName=$p(PatInfo,"^",2)
	   ...s GetstrDOB=$p(PatInfo,"^",3)
	   ...s GetstrAge=$p(PatInfo,"^",4)
	   ...s GetstrAge=$p(GetstrAge," ")
	   ...s GetSexDesc=$p(PatInfo,"^",5)
	   ...s Getpatienttype=$p(PatInfo,"^",6)
	   ...q:(Getpatienttype'="I")
	   ...s Gettypedesc=$p(PatInfo,"^",7)
	   ...s GetLocName=$p(PatInfo,"^",8)
	   ...s GetIPNo=$p(PatInfo,"^",9)       ;住院号
	   ...s GetWardName=$p(PatInfo,"^",10)
	   ...s GetBedNo=$p(PatInfo,"^",11)
	   ...s GetReqLocDR=$p(PatInfo,"^",12)
	   ...s GetWardDR=$p(PatInfo,"^",14)
	   ...q:(ward'="")&(ward'=GetWardDR)
	   ...s Getroomdesc=$p(PatInfo,"^",15)
	   ...s GetSexDr=$p(PatInfo,"^",13)
	   ...s PapatmasDR=$p(PatInfo,"^",24)
	   ...s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(OrderRowid,itemsub,bodypartRowid)
	   ...s GetPatientStatusCode="A"
       ...s GetstrOrderName=$p(ordInfo,"^",1)
       ...q:(InIsBedOrd="N")&(GetstrOrderName["床旁")
       ...q:(InIsBedOrd="Y")&(GetstrOrderName'["床旁")
       ...s GetstrDate=$p(ordInfo,"^",2)
       ...s GetstrTime=$p(ordInfo,"^",3)
       ...s Getifbed=$p(ordInfo,"^",9)
       ...s GetItemStatusCode=$p(ordInfo,"^",14)
       ...s GetRecLocName=$p(ordInfo,"^",21)
       ...q:(GetItemStatusCode="U")!(GetItemStatusCode="D") ;过滤作废或停止医嘱
       ...s GetordDate=$p(ordInfo,"^",15)
       ...s GetordTime=$p(ordInfo,"^",16)
       ...s GetItemStatusCode=$p(ordInfo,"^",17)   			;医嘱状态
       ...s GetServerMaterial=$p(ordInfo,"^",18)   			;申请项目标记 
       ...q:(GetServerMaterial'="S")
       ...s GetRecLocDR=$p(ordInfo,"^",19)
       ...s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfo(Oeorditemdr,bodypartRowid)
       ...s GetStudyNo=$p(RegInfo,"^",1)
       ...i GetStudyNo'="" s GetPatientStatusCode="I"
       ...q:(InStudyNo'="")&(InStudyNo'=GetStudyNo)
       ...s GetstrRegDate=$p(RegInfo,"^",2)
       ...s GetstrRegTime=$p(RegInfo,"^",3)
       ...s GetRegDate=$p(RegInfo,"^",17)
       ...s GetResDesc="",strRppDate="",strRppTime=""
       ...i $g(^OEORD(OrderRowid,"I",itemsub,6))'="" d
       ....s Getapprowid=$p(^OEORD(OrderRowid,"I",itemsub,6),"^",5)
       ....i (Getapprowid'="")&(Getapprowid'=$C(0)) d
       .....s ResRowid=$p(Getapprowid,"||",1)
       .....s SchildSub=$p(Getapprowid,"||",2)
       .....s appointchildsub=$p(Getapprowid,"||",3)
       .....s ResDesc=""
 	   .....s CTCPDR=$p($g(^RB("RES",ResRowid)),"^",2)
       .....s CTCPDR=$p(CTCPDR,$c(0))
       .....i CTCPDR'="" d
       ......s GetResDesc=$p($g(^CTPCP(CTCPDR,1)),"^",2)
       .....else  d
       ......s EQDR=$p($g(^RB("RES",ResRowid)),"^",3)
       ......s GetResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
       .....s RppDate=$p(^RBAS(ResRowid,SchildSub),"^",1)
       .....s strRppDate=$zd(RppDate,3)
       .....s RppTime=$p(^RBAS(ResRowid,SchildSub),"^",4)
       .....s strRppTime=$zt(RppTime,1)
       ...s GetReportStatusCode="N"     ;未写报告
       ...s GetImgcount=0
       ...s GetRptID=""
       ...s GetRptDocDR="",GetRptDocName="",GetRptDate="",GetRptTime="",GetVerifyDocDR=""
       ...s GetVerifyDocName="",GetVerifyDate="",GetVerifyTime="",HaveImage=""
       ...i GetStudyNo'="" d
       ....s Imrowid=0 f  s Imrowid=$o(^DHCRBStudyi("StudyNo-Images",GetStudyNo,Imrowid)) q:Imrowid=""  d
       .....s GetPatientStatusCode="E"    ;正在检查
       .....s ExtName=$p($g(^DHCRBStudy(0,"StudyImages",Imrowid)),"^",2)
       .....i ((ExtName="avi")!(ExtName="dcm")!(ExtName="normal")!(ExtName="dsa"))  d
       ......s GetImgcount=GetImgcount+1
       ......s GetReportStatusCode="I"             ;图象已经采集
       ......s HaveImage="是"
       ....s ReportStuatCode="VS"
       ....s Rptrowid=0  f  s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",GetStudyNo,Rptrowid)) q:Rptrowid=""  d
       .....s GetRptID=$p(^DHCRBStudy("Report",Rptrowid),"^",2)
       .....s GetRptVersion=$p(^DHCRBStudy("Report",Rptrowid),"^",3)
       .....s GetRptStatusDR=$p(^DHCRBStudy("Report",Rptrowid),"^",4)
       .....i GetRptStatusDR'="" d
       ......s GetReportStatusCode=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",1)
       ......i ReportStuatCode[GetReportStatusCode d
       .......s GetPatientStatusCode="O"
       ......e  d
       .......s GetPatientStatusCode="E"
       ......s GetRptStatusDesc=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",2)
       .....s GetRptIsYX=$p(^DHCRBStudy("Report",Rptrowid),"^",7)
       .....s GetRptDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",8)
       .....i GetRptDocDR'="" s GetRptDocName=$p(^SSU("SSUSR",GetRptDocDR),"^",2)
       .....s GetRptDate=$p(^DHCRBStudy("Report",Rptrowid),"^",9)
       .....i GetRptDate'="" s GetRptDate=$zd(GetRptDate,3)
       .....s GetRptTime=$p(^DHCRBStudy("Report",Rptrowid),"^",10)
       .....i GetRptTime'="" s GetRptTime=$zt(GetRptTime,3)
       .....s GetVerifyDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",11)
       .....i GetVerifyDocDR'="" s GetVerifyDocName=$p(^SSU("SSUSR",GetVerifyDocDR),"^",2)
       .....s GetVerifyDate=$p(^DHCRBStudy("Report",Rptrowid),"^",12)
       .....i GetVerifyDate'="" s GetVerifyDate=$zd(GetVerifyDate,3) 
       .....s GetVerifyTime=$p(^DHCRBStudy("Report",Rptrowid),"^",13)
       .....i GetVerifyTime'="" s GetVerifyTime=$zt(GetVerifyTime,3)
       .....s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
       .....q:(RisStatusCode'="")&(RisStatusCode'=GetPatientStatusCode)
       .....s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
       .....s bOut="Y"
       .....Do OutRowItemDate
       ...i bOut="N" d
       ....s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
       ....q:(RisStatusCode'="")&(RisStatusCode'=GetPatientStatusCode)
       ....s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
       ....s bOut="Y"
       ....Do OutRowItemDate
    }
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK   
   
OutRowItemDate
    set Data=$lb(GetRegNo,GetName,GetSexDesc,GetBedNo,GetstrOrderName,GetstrDate,GetstrTime,GetRecLocName,GetReportStatus,strRppDate,strRppTime,GetResDesc,GetstrRegDate,GetstrRegTime,GetStudyNo,GetRptDocName,GetVerifyDocName,GetPatientStatus,GetWardName,GetstrAge,PrintFalg,Oeorditemdr,MeothodDesc,$g(GetRecLocDR),$g(IsSend),$g(Memo),$g(bodypartRowid))
    ;i ((GetRecLocDR'="180")&(GetRecLocDR'="181")) d
    s ^DHCRISTEMPWARDQUERYDATA($g(InUserId),ind)=$g(Oeorditemdr)_"^"_$J_"^"_$g(GetRecLocName)_"^"_$g(GetBedNo)_"^"_$g(GetRegNo)_"^"_$g(GetName)_"^"_$g(GetSexDesc)_"^"_$g(GetstrAge)_"^"_$g(GetstrOrderName)_"^"_$g(GetstrDate)_"^"_$g(GetstrTime)_"^"_$g(strRppDate)_"^"_$g(strRppTime)_"^"_$g(GetstrRegDate)_"^"_$g(GetstrRegTime)_"^"_$g(GetStudyNo)_"^"_$g(GetRptDocName)_"^"_$g(GetVerifyDocName)_"^"_$g(GetPatientStatus)_"^"_$g(GetWardName)_"^"_$g(GetResDesc)_"^"_PrintFalg_"^"_$g(MeothodDesc)_"^"_$g(GetRecLocDR)_"^"_$g(IsSend)_"^"_$g(Memo)_"^"_$g(bodypartRowid)
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
	         .q:(perInLocID="")
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
	         .....s BK=""
	         .....s BK=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",7) 
	         .....q:(BK="Cancel")
	         .....s Oeorditemdr=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",1)
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
             s AppBillNo=##Class(web.DHCAPPInterface).GetExaReqNo(Oeorditemdr)    //申请单号
	 
			 s bodydrList=""
			 if ($g(DetailRowid)'="")
			 {
			 	s bodydrList=##class(web.DHCRisWorkBenchDoEx).GetBookDetailBodyList($g(DetailRowid))
			 }
			 if ($g(DEBRwoid)'="")
			 {
				 s bodydrList=##class(web.DHCRisWorkBenchDoEx).GetExternalBookBodyListByRowid(DEBRwoid)
			 }
			 
			 if (bodydrList="")
			 {
				 ;获取医嘱的部位
				 s bodydrList=##class(web.DHCRisWorkBenchDoEx).GetstrOrderName(Oeorditemdr)
			 }
			 
			 ;w !,oeorditemdr_"**"_$g(DetailRowid)_"**"_$g(DEBRwoid)_"**"_bodydrList
			 s NumLeng=$L(bodydrList,"^")
			 f j=1:1:NumLeng  d  
			 .s bodypartRowid=$p($g(bodydrList),"^",j)
			 .s bodypartcode=$p($g(bodypart),":",1)
			 .s ordrowid=$p($g(Oeorditemdr),"||",1)
			 .s orditemchildsub=$p($g(Oeorditemdr),"||",2)
			 .s IsRegFlag=""
			 .s IsRegFlag=..GetRegFlag(Oeorditemdr,bodypartRowid)
			 .q:(IsRegFlag="Y")
			 .s arcimid=$p($g(^OEORD(ordrowid,"I",orditemchildsub,1)),"^",2)
			 .q:(arcimid="")
			 .s MeothodDesc=""
			 .s methodInfo=..getBookType(Oeorditemdr,bodypartRowid)
    		 .s MeothodDesc=$p(methodInfo,"^",2)
             .;s MeothodDesc=..RequestBookType(arcimid)
             .;q:((IsNoBK="Y")&((MeothodDesc=" ")!(MeothodDesc="")!(MeothodDesc'="不需预约")))
             .;q:((IsNoBK="Y")&((MeothodDesc'="不需预约")&(MeothodDesc'="")))
             .s IsSend="",Memo=""
             .;s IsSend=##class(web.DHCRisApplicationBill).IsSendAppBill(Oeorditemdr)
	         .s RecLocdr=$p($g(^OEORD(ordrowid,"I",orditemchildsub,3)),"^",6)
	         .q:(RecLocId'="")&(RecLocId'=RecLocdr)
	         .q:(ArcItemRowid'="")&(ArcItemRowid'=arcimid)
			 .s PrintFalg=""
	         .i bodypartRowid'="" s PrintFalg=$g(^DHCRISORDITEMPRINTED(Oeorditemdr,bodypartRowid))
       		 .e  s PrintFalg=$g(^DHCRISORDITEMPRINTED(Oeorditemdr))
	         .q:(PrintFalg'="")&(IsPrint'=PrintFalg)
	         .s IsMemo=""
             .s IsMemo=##class(web.DHCRisCommFunctionEx).ExistMemo(Oeorditemdr)
             .i IsMemo="Y" s Memo="浏览"
			 .s paadmdr=$p(^OEORD(ordrowid),"^",1)
			 .s papatmasmdr=$p(^PAADM(paadmdr),"^",1)  
			 .;get patient diagnose 
		     .q:(paadmdr="")
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
		     .;q:(Getpatienttype'="I")
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
		     .s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(ordrowid,orditemchildsub,bodypartRowid)
		     .s GetPatientStatusCode="A"
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
			 .s GetPatientStatusCode="B"
			 .s GetReportStatusCode="N"  ;未写报告
			 .s GetstrRegDate="",GetstrRegTime="",GetRptDocName="",GetVerifyDocName="",GetStudyNo="",GetIndex="",GetEQDesc=""
			 .s bOut="N",HaveImage=""
			 .s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfo(Oeorditemdr,bodypartRowid)
	         .s GetStudyNo=$p(RegInfo,"^",1)
	         .i GetStudyNo'="" s GetPatientStatusCode="I"
	         .q:(InStudyNo'="")&(InStudyNo'=GetStudyNo)
	         .s GetstrRegDate=$p(RegInfo,"^",2)
	         .s GetstrRegTime=$p(RegInfo,"^",3)
	         .s GetRegDate=$p(RegInfo,"^",17)
			 .s GetReportStatusCode="N"     ;未写报告
	         .s GetImgcount=0
	         .s GetRptID=""
	         .s GetRptDocDR="",GetRptDocName="",GetRptDate="",GetRptTime="",GetVerifyDocDR=""
	         .s GetVerifyDocName="",GetVerifyDate="",GetVerifyTime="",HaveImage=""
	         .i GetStudyNo'="" d
	         ..s Imrowid=0 f  s Imrowid=$o(^DHCRBStudyi("StudyNo-Images",GetStudyNo,Imrowid)) q:Imrowid=""  d
	         ...s GetPatientStatusCode="E"    ;正在检查
	         ...s ExtName=$p($g(^DHCRBStudy(0,"StudyImages",Imrowid)),"^",2)
	         ...i ((ExtName="avi")!(ExtName="dcm")!(ExtName="normal")!(ExtName="dsa"))  d
	         ....s GetImgcount=GetImgcount+1
	         ....s GetReportStatusCode="I"             ;图象已经采集
	         ....s HaveImage="是"
	         ..s ReportStuatCode="VS"
	         ..s Rptrowid=0  f  s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",GetStudyNo,Rptrowid)) q:Rptrowid=""  d
	         ...s GetRptID=$p(^DHCRBStudy("Report",Rptrowid),"^",2)
	         ...s GetRptVersion=$p(^DHCRBStudy("Report",Rptrowid),"^",3)
	         ...s GetRptStatusDR=$p(^DHCRBStudy("Report",Rptrowid),"^",4)
	         ...i GetRptStatusDR'="" d
	         ....s GetReportStatusCode=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",1)
	         ....i ReportStuatCode[GetReportStatusCode d
	         .....s GetPatientStatusCode="O"
	         ....e  d
	         .....s GetPatientStatusCode="E"
	         ....s GetRptStatusDesc=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",2)
	         ...s GetRptIsYX=$p(^DHCRBStudy("Report",Rptrowid),"^",7)
	         ...s GetRptDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",8)
	         ...i GetRptDocDR'="" s GetRptDocName=$p(^SSU("SSUSR",GetRptDocDR),"^",2)
	         ...s GetRptDate=$p(^DHCRBStudy("Report",Rptrowid),"^",9)
	         ...i GetRptDate'="" s GetRptDate=$zd(GetRptDate,3)
	         ...s GetRptTime=$p(^DHCRBStudy("Report",Rptrowid),"^",10)
	         ...i GetRptTime'="" s GetRptTime=$zt(GetRptTime,3)
	         ...s GetVerifyDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",11)
	         ...i GetVerifyDocDR'="" s GetVerifyDocName=$p(^SSU("SSUSR",GetVerifyDocDR),"^",2)
	         ...s GetVerifyDate=$p(^DHCRBStudy("Report",Rptrowid),"^",12)
	         ...i GetVerifyDate'="" s GetVerifyDate=$zd(GetVerifyDate,3) 
	         ...s GetVerifyTime=$p(^DHCRBStudy("Report",Rptrowid),"^",13)
	         ...i GetVerifyTime'="" s GetVerifyTime=$zt(GetVerifyTime,3)
	         ...s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
	         ...q:(((RisStatusCode'="")&(RisStatusCode'="S"))&(RisStatusCode'=GetPatientStatusCode))
	         ...s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
	         ...s bOut="Y"
	         ...set Data=$lb(GetRegNo,GetName,GetSexDesc,GetBedNo,GetstrOrderName,GetstrDate,GetstrTime,GetRecLocName,GetReportStatus,strRppDate,strRppTime,GetResDesc,GetstrRegDate,GetstrRegTime,GetStudyNo,GetRptDocName,GetVerifyDocName,GetPatientStatus,GetWardName,GetstrAge,PrintFalg,Oeorditemdr,$g(MeothodDesc),$g(GetRecLocDR),$g(IsSend),$g(Memo),$g(bodypartRowid))
	         ...;i ((GetRecLocDR'="180")&(GetRecLocDR'="181")) d
             ...s ^DHCRISTEMPWARDQUERYDATA($g(InUserId),ind)=$g(Oeorditemdr)_"^"_$J_"^"_$g(GetRecLocName)_"^"_$g(GetBedNo)_"^"_$g(GetRegNo)_"^"_$g(GetName)_"^"_$g(GetSexDesc)_"^"_$g(GetstrAge)_"^"_$g(GetstrOrderName)_"^"_$g(GetstrDate)_"^"_$g(GetstrTime)_"^"_$g(strRppDate)_"^"_$g(strRppTime)_"^"_$g(GetstrRegDate)_"^"_$g(GetstrRegTime)_"^"_$g(GetStudyNo)_"^"_$g(GetRptDocName)_"^"_$g(GetVerifyDocName)_"^"_$g(GetPatientStatus)_"^"_$g(GetWardName)_"^"_$g(GetResDesc)_"^"_PrintFalg_"^"_$g(MeothodDesc)_"^"_$g(GetRecLocDR)_"^"_$g(IsSend)
             ...s ^DHCRISTEMPWARDQUERYDATA($g(InUserId))=ind
   	         ...Set ^CacheTemp(repid,ind)=Data
	         ...Set ind=ind+1
 	         ...quit
	         .i bOut="N" d
	         ..s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
	         ..q:(((RisStatusCode'="")&(RisStatusCode'="S"))&(RisStatusCode'=GetPatientStatusCode))
	         ..s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
	         ..s bOut="Y"
	         ..set Data=$lb(GetRegNo,GetName,GetSexDesc,GetBedNo,GetstrOrderName,GetstrDate,GetstrTime,GetRecLocName,GetReportStatus,strRppDate,strRppTime,GetResDesc,GetstrRegDate,GetstrRegTime,GetStudyNo,GetRptDocName,GetVerifyDocName,GetPatientStatus,GetWardName,GetstrAge,PrintFalg,Oeorditemdr,$g(MeothodDesc),$g(GetRecLocDR),$g(IsSend),$g(Memo),$g(bodypartRowid))
             ..s ^DHCRISTEMPWARDQUERYDATA($g(InUserId),ind)=$g(Oeorditemdr)_"^"_$J_"^"_$g(GetRecLocName)_"^"_$g(GetBedNo)_"^"_$g(GetRegNo)_"^"_$g(GetName)_"^"_$g(GetSexDesc)_"^"_$g(GetstrAge)_"^"_$g(GetstrOrderName)_"^"_$g(GetstrDate)_"^"_$g(GetstrTime)_"^"_$g(strRppDate)_"^"_$g(strRppTime)_"^"_$g(GetstrRegDate)_"^"_$g(GetstrRegTime)_"^"_$g(GetStudyNo)_"^"_$g(GetRptDocName)_"^"_$g(GetVerifyDocName)_"^"_$g(GetPatientStatus)_"^"_$g(GetWardName)_"^"_$g(GetResDesc)_"^"_PrintFalg_"^"_$g(MeothodDesc)_"^"_$g(GetRecLocDR)_"^"_$g(IsSend)_"^"_$g(Memo)_"^"_$g(bodypartRowid)
             ..s ^DHCRISTEMPWARDQUERYDATA($g(InUserId))=ind
             ..;i ($g(^DHCRISNURSETMEP("TEMPNURSEITEMROWID"))'=Oeorditemdr)
   	         ..Set ^CacheTemp(repid,ind)=Data
	         ..Set ind=ind+1
 	         ..quit
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
      .s IsSend=##class(web.DHCRisApplicationBill).IsSendAppBill(Oeorditemdr)
      .s PrintFalg=""
      .i bodypartRowid'="" s PrintFalg=$g(^DHCRISORDITEMPRINTED(Oeorditemdr,bodypartRowid))
      .e  s PrintFalg=$g(^DHCRISORDITEMPRINTED(Oeorditemdr))
      .q:(PrintFalg'="")&(IsPrint'=PrintFalg)
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
      .;s methodInfo=..getBookType(Oeorditemdr,bodypartRowid)
      .;s MeothodDesc=$p(methodInfo,"^",2)
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
    set Data=$lb(GetRegNo,GetName,GetSexDesc,GetBedNo,GetstrOrderName,GetstrDate,GetstrTime,GetRecLocName,GetReportStatus,strRppDate,strRppTime,GetResDesc,GetstrRegDate,GetstrRegTime,GetStudyNo,GetRptDocName,GetVerifyDocName,GetPatientStatus,GetWardName,GetstrAge,PrintFalg,Oeorditemdr,$g(MeothodDesc),$g(GetRecLocDR),$g(IsSend),$g(Memo))
    ;i ((GetRecLocDR'="180")&(GetRecLocDR'="181")) d
    s ^DHCRISTEMPWARDQUERYDATA($g(InUserId),ind)=$g(Oeorditemdr)_"^"_$J_"^"_$g(GetRecLocName)_"^"_$g(GetBedNo)_"^"_$g(GetRegNo)_"^"_$g(GetName)_"^"_$g(GetSexDesc)_"^"_$g(GetstrAge)_"^"_$g(GetstrOrderName)_"^"_$g(GetstrDate)_"^"_$g(GetstrTime)_"^"_$g(strRppDate)_"^"_$g(strRppTime)_"^"_$g(GetstrRegDate)_"^"_$g(GetstrRegTime)_"^"_$g(GetStudyNo)_"^"_$g(GetRptDocName)_"^"_$g(GetVerifyDocName)_"^"_$g(GetPatientStatus)_"^"_$g(GetWardName)_"^"_$g(GetResDesc)_"^"_PrintFalg_"^"_$g(MeothodDesc)_"^"_$g(GetRecLocDR)_"^"_$g(IsSend)_"^"_$g(Memo)_"^"_$g(bodypartRowid)
    s ^DHCRISTEMPWARDQUERYDATA($g(InUserId))=ind
   	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
 	quit
}

ClassMethod QueryWardItem(ward, ArcItemRowid, InRegNo, InStudyNo, RisStatusCode, RecLocId, IsPrint, InIsBedOrd, InUserId, startdate, enddate, IsNoBK)
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
    ....s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
    ....q:(arcimid="")
    ....s ServerMaterial=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7)),"^",6)
    ....q:(ServerMaterial'="Service")&(ServerMaterial'="S")
    ....s bodydrList=##Class(web.DHCRisWorkBenchDoEx).GetstrOrderName(Oeorditemdr)
	....s AppBillNo=##Class(web.DHCAPPInterface).GetExaReqNo(Oeorditemdr)    //申请单号
	....;w !,"bodydrList="_bodydrList
	....s NumLeng=$L(bodydrList,"^")
	....f j=1:1:NumLeng  d  
	.....s bodypart=$p($g(bodydrList),"^",j)
	.....s bodypartRowid=$p($g(bodypart),":",1) 
	.....s bodypartDesc=$p($g(bodypart),":",2) 
    .....;s GetPatientStatusCode="A"
    .....s IsBKFlag="",IsRegFlag="",Memo=""
    .....s regRowid=..GetRegFlag(Oeorditemdr,bodypartRowid)
    .....;q:(IsRegFlag="Y")
    .....s IsBKFlag=..GetBKFlag(Oeorditemdr,bodypartRowid)
    .....i IsBKFlag="Y" s GetPatientStatusCode="B"
    .....q:((RisStatusCode="B")&(IsBKFlag'="Y")) //过滤未预约医嘱
    .....s IsSend=""
    .....;s IsSend=##class(web.DHCRisApplicationBill).IsSendAppBill(Oeorditemdr)
    .....s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
    .....q:(arcimid="")
    .....s ItemDate=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",9)
    .....q:((ItemDate'="")&((ItemDate<startdate)!(ItemDate>enddate)))
    .....s methodInfo=..getBookType(Oeorditemdr,bodypartRowid)
    .....s MeothodDesc=$p(methodInfo,"^",2)
    .....;s MeothodDesc=..RequestBookType(arcimid)
    .....;q:((IsNoBK="Y")&((MeothodDesc'="不需预约")&(MeothodDesc'="")))
    .....s RecLocdr=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)
    .....q:(RecLocId'="")&(RecLocId'=RecLocdr)
    .....q:(ArcItemRowid'="")&(ArcItemRowid'=arcimid)
    .....s PrintFalg=""
    .....i bodypartRowid'="" s PrintFalg=$g(^DHCRISORDITEMPRINTED(Oeorditemdr,bodypartRowid))
    .....e  s PrintFalg=$g(^DHCRISORDITEMPRINTED(Oeorditemdr))
    .....q:(PrintFalg'="")&(IsPrint'=PrintFalg)
    .....s bOut="N"  ;是否已经输出
    .....s paadmdr=$p(^OEORD(OrderRowid),"^",1) 
    .....s IsMemo=""
    .....s IsMemo=##class(web.DHCRisCommFunctionEx).ExistMemo(Oeorditemdr)
    .....i IsMemo="Y" s Memo="浏览" 
    .....s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
    .....q:(PatInfo="") 
    .....s GetRegNo=$p(PatInfo,"^",1)
	.....q:(InRegNo'="")&(InRegNo'=GetRegNo)
	.....s GetName=$p(PatInfo,"^",2)
	.....s GetstrDOB=$p(PatInfo,"^",3)
	.....s GetstrAge=$p(PatInfo,"^",4)
	.....s GetstrAge=$p(GetstrAge," ")
	.....s GetSexDesc=$p(PatInfo,"^",5)
	.....s Getpatienttype=$p(PatInfo,"^",6)
	.....q:(Getpatienttype'="I")
	.....s Gettypedesc=$p(PatInfo,"^",7)
	.....s GetLocName=$p(PatInfo,"^",8)
	.....s GetIPNo=$p(PatInfo,"^",9)       ;住院号
	.....s GetWardName=$p(PatInfo,"^",10)
	.....s GetBedNo=$p(PatInfo,"^",11)
	.....s GetReqLocDR=$p(PatInfo,"^",12)
	.....s GetWardDR=$p(PatInfo,"^",14)
	.....q:(ward'="")&(ward'=GetWardDR)
	.....s Getroomdesc=$p(PatInfo,"^",15)
	.....s GetSexDr=$p(PatInfo,"^",13)
	.....s PapatmasDR=$p(PatInfo,"^",24)
	.....s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(OrderRowid,itemsub,bodypartRowid)
	.....i IsBKFlag'="Y" s GetPatientStatusCode="A"
    .....s GetstrOrderName=$p(ordInfo,"^",1)
    .....q:(InIsBedOrd="N")&(GetstrOrderName["床旁")
    .....q:(InIsBedOrd="Y")&(GetstrOrderName'["床旁")
    .....s GetstrDate=$p(ordInfo,"^",2)
    .....s GetstrTime=$p(ordInfo,"^",3)
    .....s Getifbed=$p(ordInfo,"^",9)
    .....s GetItemStatusCode=$p(ordInfo,"^",14)
    .....s GetRecLocName=$p(ordInfo,"^",21)
    .....q:(GetItemStatusCode="U")!(GetItemStatusCode="D")!(GetItemStatusCode="C") ;过滤作废或停止医嘱
    .....s GetordDate=$p(ordInfo,"^",15)
    .....s GetordTime=$p(ordInfo,"^",16)
    .....s GetItemStatusCode=$p(ordInfo,"^",17)   			;医嘱状态
    .....s GetServerMaterial=$p(ordInfo,"^",18)   			;申请项目标记 
    .....q:(GetServerMaterial'="S")
    .....s GetRecLocDR=$p(ordInfo,"^",19)
    .....s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfo(Oeorditemdr,bodypartRowid)
    .....s GetStudyNo=$p(RegInfo,"^",1)
    .....i GetStudyNo'="" s GetPatientStatusCode="I"
    .....q:(InStudyNo'="")&(InStudyNo'=GetStudyNo)
    .....s GetstrRegDate=$p(RegInfo,"^",2)
    .....s GetstrRegTime=$p(RegInfo,"^",3)
    .....s GetRegDate=$p(RegInfo,"^",17)
    .....s GetResDesc="",strRppDate="",strRppTime="",BKInfo=""
    .....;i IsBKFlag="Y" s BKInfo=..GetBKInfo(Oeorditemdr,bodypartRowid)
    .....s BKInfo=..GetBKInfo(Oeorditemdr,bodypartRowid)
    .....s strRppDate=$p($g(BKInfo),"^",1)
    .....s strRppTime=$p($g(BKInfo),"^",2)
    .....s GetResDesc=$p($g(BKInfo),"^",3)
    .....s GetReportStatusCode="N"     ;未写报告
    .....s GetImgcount=0
    .....s GetRptID=""
    .....s GetRptDocDR="",GetRptDocName="",GetRptDate="",GetRptTime="",GetVerifyDocDR=""
    .....s GetVerifyDocName="",GetVerifyDate="",GetVerifyTime="",HaveImage=""
    .....i GetStudyNo'="" d
    ......s Imrowid=0 f  s Imrowid=$o(^DHCRBStudyi("StudyNo-Images",GetStudyNo,Imrowid)) q:Imrowid=""  d
    .......s GetPatientStatusCode="E"    ;正在检查
    .......s ExtName=$p($g(^DHCRBStudy(0,"StudyImages",Imrowid)),"^",2)
    .......i ((ExtName="avi")!(ExtName="dcm")!(ExtName="normal")!(ExtName="dsa"))  d
    ........s GetImgcount=GetImgcount+1
    ........s GetReportStatusCode="I"             ;图象已经采集
    ........s HaveImage="是"
    ......s ReportStuatCode="VS"
    ......s Rptrowid=0  f  s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",GetStudyNo,Rptrowid)) q:Rptrowid=""  d
    .......s GetRptID=$p(^DHCRBStudy("Report",Rptrowid),"^",2)
    .......s GetRptVersion=$p(^DHCRBStudy("Report",Rptrowid),"^",3)
    .......s GetRptStatusDR=$p(^DHCRBStudy("Report",Rptrowid),"^",4)
    .......i GetRptStatusDR'="" d
    ........s GetReportStatusCode=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",1)
    ........i ReportStuatCode[GetReportStatusCode d
    .........s GetPatientStatusCode="O"
    ........e  d
    .........s GetPatientStatusCode="E"
    ........s GetRptStatusDesc=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",2)
    .......s GetRptIsYX=$p(^DHCRBStudy("Report",Rptrowid),"^",7)
    .......s GetRptDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",8)
    .......i GetRptDocDR'="" s GetRptDocName=$p(^SSU("SSUSR",GetRptDocDR),"^",2)
    .......s GetRptDate=$p(^DHCRBStudy("Report",Rptrowid),"^",9)
    .......i GetRptDate'="" s GetRptDate=$zd(GetRptDate,3)
    .......s GetRptTime=$p(^DHCRBStudy("Report",Rptrowid),"^",10)
    .......i GetRptTime'="" s GetRptTime=$zt(GetRptTime,3)
    .......s GetVerifyDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",11)
    .......i GetVerifyDocDR'="" s GetVerifyDocName=$p(^SSU("SSUSR",GetVerifyDocDR),"^",2)
    .......s GetVerifyDate=$p(^DHCRBStudy("Report",Rptrowid),"^",12)
    .......i GetVerifyDate'="" s GetVerifyDate=$zd(GetVerifyDate,3) 
    .......s GetVerifyTime=$p(^DHCRBStudy("Report",Rptrowid),"^",13)
    .......i GetVerifyTime'="" s GetVerifyTime=$zt(GetVerifyTime,3)
    .......s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
    .......q:(RisStatusCode'="S")&(RisStatusCode'="")&(RisStatusCode'=GetPatientStatusCode)
    .......s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
    .......s bOut="Y"
    .......Do OutRowWard
    .....i bOut="N" d
    ......s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
    ......q:(RisStatusCode'="S")&(RisStatusCode'="")&(RisStatusCode'=GetPatientStatusCode)
    ......s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
    ......s bOut="Y"
    ......Do OutRowWard
    
    Set qHandle=$lb(0,repid,0)
   Quit $$$OK   
   
OutRowWard
    set Data=$lb(GetRegNo,GetName,GetSexDesc,GetBedNo,GetstrOrderName,GetstrDate,GetstrTime,GetRecLocName,GetReportStatus,strRppDate,strRppTime,GetResDesc,GetstrRegDate,GetstrRegTime,GetStudyNo,GetRptDocName,GetVerifyDocName,GetPatientStatus,GetWardName,GetstrAge,PrintFalg,Oeorditemdr,MeothodDesc,$g(GetRecLocDR),$g(IsSend),$g(Memo),$g(bodypartRowid))
    s ^DHCRISTEMPWARDQUERYDATA($g(InUserId),ind)=$g(Oeorditemdr)_"^"_$J_"^"_$g(GetRecLocName)_"^"_$g(GetBedNo)_"^"_$g(GetRegNo)_"^"_$g(GetName)_"^"_$g(GetSexDesc)_"^"_$g(GetstrAge)_"^"_$g(GetstrOrderName)_"^"_$g(GetstrDate)_"^"_$g(GetstrTime)_"^"_$g(strRppDate)_"^"_$g(strRppTime)_"^"_$g(GetstrRegDate)_"^"_$g(GetstrRegTime)_"^"_$g(GetStudyNo)_"^"_$g(GetRptDocName)_"^"_$g(GetVerifyDocName)_"^"_$g(GetPatientStatus)_"^"_$g(GetWardName)_"^"_$g(GetResDesc)_"^"_PrintFalg_"^"_$g(MeothodDesc)_"^"_$g(GetRecLocDR)_"^"_$g(IsSend)_"^"_$g(Memo)_"^"_$g(bodypartRowid)
    s ^DHCRISTEMPWARDQUERYDATA($g(InUserId))=ind
   	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
 	quit
}

ClassMethod GetWardByLoc(LocDr) As %String
{
	n (LocDr)
	q:(LocDr="") "^"
	;s LocDr="197"
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
/// d ##class(%ResultSet).RunQuery("web.DHCRisWardQuery","QueryWard","") 
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
    .s locID=$p($g(^PAWARD(rowid)),"^",5)
    .s contactName=""
    .if locID'="" d
	..s contactName=$p(^CTLOC(locID),"^",43)
	.s contactName=$ZCONVERT(contactName,"U")
    .i (InDesc="") d
    ..Do OutRowQueryWard
    .e  d
    ..if ((Getdesc[InDesc)||(contactName[InDesc)) d
    ...Do OutRowQueryWard
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
	s ^DHCRisTemp("QueryOrdItemCS")=ItemDesc
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
ClassMethod SetPrintFlag(oeorditemdr As %String, bodyRowid As %String = "")
{
	n (oeorditemdr,bodyRowid)
	s ^t=oeorditemdr
	if (bodyRowid'="")
	{
		s ^DHCRISORDITEMPRINTED(oeorditemdr,bodyRowid)="Y"
	}
	else
	{
		s ^DHCRISORDITEMPRINTED(oeorditemdr)="Y"
	}	
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
ClassMethod SetPrintDateTime(oeorditemdr As %String, bodyRowid As %String = "")
{
	n (oeorditemdr,bodyRowid)
	s PrintDate= $zd($h,3)
    s PrintTime=$zt($p($h,",",2))
    if (bodyRowid'="")
    {
	    s ^DHCRISPRINTDATETIME(oeorditemdr,bodyRowid)=PrintDate_"^"_PrintTime
    }
    else
    {
		s ^DHCRISPRINTDATETIME(oeorditemdr)=PrintDate_"^"_PrintTime
    }
	s Info=PrintDate_"^"_PrintTime
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

/// do ##class(web.DHCRisWardQuery).Test("62000","62810")
ClassMethod Test(startdate, enddate)
{
	for date=startdate:1:enddate
    {
       s OrderRowid=""  f  s OrderRowid=$o(^OEORDi(0,"ItemDate",date,OrderRowid)) q:(OrderRowid="")  d
       .s itemsub=""  f  s itemsub=$o(^OEORDi(0,"ItemDate",date,OrderRowid,itemsub)) q:(itemsub="")  d
       ..s Oeorditemdr=OrderRowid_"||"_itemsub
       ..w !,Oeorditemdr
  
    }
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

// w ##class(web.DHCRisWardQuery).Insert()

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

/// w ##class(web.DHCRisWardQuery).GetBKFlag("20017||3894")
ClassMethod GetBKFlag(oeorditemdr As %String, bodyRowid As %String = "") As %String
{
	n (oeorditemdr,bodyRowid)
	s BOOK="N",Rowid="",CancelFlag="",ERowid=""
	q:(oeorditemdr="") BOOK
	
	/*
	s Rowid=$o(^DHCRBCResSchduleDetaili(0,oeorditemdr,Rowid))
	i Rowid'="" s CancelFlag=$p($g(^DHCRBCResSchduleDetail("Detail",Rowid)),"^",7) 
	i ((Rowid'="")&(CancelFlag'="Cancel")) s BOOK="Y"
	*/
	
	s Rowid=##class(web.DHCRisResApptSchudleSystem).getBookDetailRowid(oeorditemdr_"^"_bodyRowid)
	i Rowid'="" s BOOK="Y"
	
	i BOOK="N"  d
	.s ERowid=##class(web.DHCRisWorkBenchDoEx).HasExternalBK(oeorditemdr,bodyRowid)
	.i ERowid'="" s BOOK="Y"
	
	q BOOK
}

/// w ##class(web.DHCRisWardQuery).GetRegFlag("20017||3894")
ClassMethod GetRegFlag(oeorditemdr As %String, bodyRowid As %String = "") As %String
{
	n (oeorditemdr,bodyRowid)
	 s RegFlag="N"
	 q:(oeorditemdr="") RegFlag
     
	 s regrowid=..getRegRowid(oeorditemdr,bodyRowid) //$o(^DHCPACRegInfoi("OEORI",oeorditemdr,""))  ; 登记的表中获得检查号
	 i regrowid'=""  s RegFlag="Y"
     q RegFlag
}

/// w ##class(web.DHCRisWardQuery).GetBKInfo("20017||3894")
ClassMethod GetBKInfo(oeorditemdr As %String, bodyRowid As %String = "") As %String
{
	n (oeorditemdr,bodyRowid)
	s BOOK="N",Rowid="",CancelFlag="",ERowid="",Info=""
	s AppointDate="",AppointTime="",ResDesc="",ResouceId="",CareProvId=""
	q:(oeorditemdr="") Info
	
	s Rowid=##class(web.DHCRisResApptSchudleSystem).getBookDetailRowid(oeorditemdr_"^"_bodyRowid)  //$o(^DHCRBCResSchduleDetaili(0,oeorditemdr,Rowid))
	i Rowid'="" s CancelFlag=$p($g(^DHCRBCResSchduleDetail("Detail",Rowid)),"^",7) 
	i ((Rowid'="")&(CancelFlag'="Cancel")) s BOOK="Y"
	i BOOK="Y" d
	.s SchRowid=$p($g(^DHCRBCResSchduleDetail("Detail",Rowid)),"^",2)
	.i SchRowid'="" d
	..s AppointDate=$p(^DHCRBCResourceSchdule(SchRowid),"^",2)
	..i AppointDate'="" s AppointDate=$zd(AppointDate,3)
	..s AppointTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",5)
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
	...i CareProvId'="" s ResDesc=$p($g(^CTPCP(CareProvId,1)),"^",2)
	...s Info=AppointDate_"^"_AppointTime_"^"_ResDesc
	
	
	s ExtRowid=##class(web.DHCRisWorkBenchDoEx).HasExternalBK(oeorditemdr,bodyRowid)
    i ExtRowid'="" d
    .s AppointDate=$p($g(^DHCRBCExternalBookInfo(ExtRowid)),"^",5)
    .s AppointTime=$p($g(^DHCRBCExternalBookInfo(ExtRowid)),"^",6)
    .s GetResDesc=$p($g(^DHCRBCExternalBookInfo(ExtRowid)),"^",4)
    .i AppointDate'="" s AppointDate=##class(websys.Conversions).DateLogicalToHtml(AppointDate)  ;$zd(AppointDate,3)
    .i AppointTime'="" s AppointTime=##class(websys.Conversions).TimeLogicalToHtml(AppointTime)   ;$zt(AppointstTime,1)
	.s BKStudyNo=$p($g(^DHCRBCExternalBookInfo(ExtRowid)),"^",12)
	.s resCode=$p($g(^DHCRBCExternalBookInfo(ExtRowid)),"^",3)
	.i resCode'="" d
	..s equipmentRowid=$o(^RBC("EQ",0,"Code",$$ALPHAUP^SSUTIL4(resCode),""))
	..i equipmentRowid'="" d 
	...s ResDesc=$p($g(^RBC("EQ",equipmentRowid)),"^",2)
	.s Info=AppointDate_"^"_AppointTime_"^"_$g(ResDesc)
	
	/*
	i BOOK="N"  d
	.s ERowid=$o(^DHCRBCExternalBookInfoi("OrdItemID",oeorditemdr,ERowid))
	.i ERowid'="" d
	..s AppointDate=$p($g(^DHCRBCExternalBookInfo(ERowid)),"^",5)
	..i AppointDate'="" s AppointDate=$zd(AppointDate,3)
	..s AppointTime=$p($g(^DHCRBCExternalBookInfo(ERowid)),"^",6)
	..i AppointTime'="" s AppointTime=$zt(AppointTime,1)
	..s ResDesc=$p($g(^DHCRBCExternalBookInfo(ERowid)),"^",4)
	..s Info=AppointDate_"^"_AppointTime_"^"_ResDesc
	*/
	
	q Info
}

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
	
	q Memo
}

ClassMethod getRegRowid(orderItemRowid As %String, bodyRowID As %String = "") As %String
{
	s ^TempDHCRis("getRegRowid")=$lb(orderItemRowid,bodyRowID)
	
	n (orderItemRowid,bodyRowID)
	s rowidRet=""
	s reginfoRowid=""
	for
	{
		s reginfoRowid=$o(^DHCPACRegInfoi("OEORI",orderItemRowid,reginfoRowid))
		q:(reginfoRowid="")
		if (bodyRowID="")
		{
			s rowidRet=reginfoRowid
		}
		else
		{
			s childSub=""
			for 
			{
				s childSub=$o(^DHCPACRegInfoBD("BODYPARTS",0,reginfoRowid,childSub))
				q:(childSub="")
				s bodyDr=$p(^DHCPACRegInfoBD("BODYPARTS",0,reginfoRowid,childSub),"^",1)
				if (bodyDr=bodyRowID )
				{
					s rowidRet=reginfoRowid
				}
			}
		}
		
	}
	
	q rowidRet
}

/// w ##class(web.DHCRisWardQuery).getBookType()
ClassMethod getBookType(orderRowid, bodyRowid As %String = "") As %String
{
	n (orderRowid, bodyRowid)
	s appointMethodId=""
	s Find=0
	s bookTypeRet=""
	q:(orderRowid="") ""
	s arcimid=$p(^OEORD($p(orderRowid,"||",1),"I",$p(orderRowid,"||",2),1),"^",2)
	//b //008
	if (bodyRowid'="")
	{
		s bookparamRowid=""
		s bookparamRowid=$o(^User.DHCRBCBookParamI("IndexItemBody",arcimid,bodyRowid,0))
		if (bookparamRowid'="")
		{
			s appointMethodId=$lg(^User.DHCRBCBookParamD(bookparamRowid),5)
		}
		
	}	
	else //if (appointMethodId="")
	{
		s BPRowid=$o(^DHCRBCItemBookProperTypei(arcimid,0))
		i (BPRowid'="")
		{
		  	s appointMethodId=$p(^DHCRBCItemBookProperty(BPRowid),"^",2)
		}
		
	}
	
	if (appointMethodId'="")
	{
		s appointMethodDesc=$p(^DHCRBCAppointMethod(appointMethodId),"^",2)
		s bookTypeRet=appointMethodId_"^"_appointMethodDesc
	}
	q bookTypeRet
}

ClassMethod QueryItemByBookDate(ward, ArcItemRowid, InRegNo, InStudyNo, RisStatusCode, RecLocId, IsPrint, InIsBedOrd, InUserId, startdate, enddate, IsNoBK)
{
	s numOfList=0
	 for dataFind=startdate:1:enddate
	 {
		s locRowid=""
		for
		{
			s locRowid=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",locRowid)) q:locRowid=""  d  
			;w !,locRowid
			 Set RowId="" f  s RowId=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",locRowid,dataFind,RowId)) q:RowId=""  d
			 .s gSchRowid="" f  s gSchRowid=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",locRowid,dataFind,RowId,gSchRowid)) q:gSchRowid=""  d 
			 ..;s SchRowid=0 f  s SchRowid=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",locCndtn,stDateDig,RowId,SchRowid)) q:SchRowid=""  d
			 ..;w !,gSchRowid
			 ..s DetailRowid=0  f  s DetailRowid=$o(^DHCRBCResSchduleDetaili("SchudleId",gSchRowid,DetailRowid)) q:DetailRowid=""  d
			 ...b //001
			 ...s Oeorditemdr=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",1)
			 ...q:(Oeorditemdr="")
			 ...s OrderRowid=$p(Oeorditemdr,"||",1)
			 ...s itemsub=$p(Oeorditemdr,"||",2)
			 ...s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
			 ...q:(arcimid="")
			 ...s bodylist=..getBookDetailBodylist(DetailRowid)
			 ...Do OutRowBook
		}
	 }
	 
	 b //01
	 for dataFind=startdate:1:enddate
	 {
		s locRowid=""
		for
		{
			s locRowid=$o(^DHCRBCExternalBookInfoi("Date",dataFind,locRowid)) q:(locRowid="")
			
			 s DEBRwoid="" f  s DEBRwoid=$o(^DHCRBCExternalBookInfoi("Date",dataFind,locRowid,DEBRwoid)) q:(DEBRwoid="")  d
			 .s Oeorditemdr=$p(^DHCRBCExternalBookInfo(DEBRwoid),"^",2)
			 .q:(Oeorditemdr="")
			 .s OrderRowid=$p(Oeorditemdr,"||",1)
			 .s itemsub=$p(Oeorditemdr,"||",2)
			 .s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
			 .;s AppointDate="",AppointstTime=""
			 .;s AppointDate=$p($g(^DHCRBCExternalBookInfo(DEBRwoid)),"^",5)
			 .;i AppointDate'="" s GetAppointDate=##class(websys.Conversions).DateLogicalToHtml(AppointDate)  ;$zd(AppointDate,3)
			 .;s AppointstTime=$p($g(^DHCRBCExternalBookInfo(DEBRwoid)),"^",6)
			 .;i AppointstTime'="" s GetAppointstTime=##class(websys.Conversions).TimeLogicalToHtml(AppointstTime)   ;$zt(AppointstTime,1)
			 .;s GetResDesc=$p($g(^DHCRBCExternalBookInfo(DEBRwoid)),"^",4)
			 .;s resCode=$p($g(^DHCRBCExternalBookInfo(DEBRwoid)),"^",3)
			 .;i resCode'="" d
			 .;.s equipmentRowid=$o(^RBC("EQ",0,"Code",$$ALPHAUP^SSUTIL4(resCode),""))
			 .;.i equipmentRowid'="" d 
			 .;..s GetResDesc=$p($g(^RBC("EQ",equipmentRowid)),"^",2)
			 .;w !,"exter GetResDesc="_GetResDesc
			 .;s BKStudyNo=$p($g(^DHCRBCExternalBookInfo(DEBRwoid)),"^",12)
			 .;s AppointUser=$p($g(^DHCRBCExternalBookInfo(DEBRwoid)),"^",7)
			 .s bodylist=##class(web.DHCRisWorkBenchDoEx).GetExternalBookBodyListByRowid(DEBRwoid)
			 .Do OutRowBook
		}
	 }
	 ;b //04
    
    Set qHandle=$lb(0,repid,0)
   Quit $$$OK   
   
OutRowBook
	;w !,Oeorditemdr
	s numBodyPart=$L(bodylist,"^")
	f j=1:1:numBodyPart  d
	.s bOut="N"	 
	.s bodypartRowid=$p(bodylist,"^",j)
	.s GetPatientStatusCode="B"
	.s IsBKFlag="Y",IsRegFlag="",Memo=""
	.s regRowid=..GetRegFlag(Oeorditemdr,bodypartRowid)
	.;q:((RisStatusCode="B")&(IsBKFlag'="Y")) //过滤未预约医嘱
	.s ItemDate=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",9)
	.s methodInfo=..getBookType(Oeorditemdr,bodypartRowid)
	.s MeothodDesc=$p(methodInfo,"^",2)
	.s RecLocdr=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)
	.q:(RecLocId'="")&(RecLocId'=RecLocdr)
	.q:(ArcItemRowid'="")&(ArcItemRowid'=arcimid)
	.s PrintFalg=""
	.i bodypartRowid'="" s PrintFalg=$g(^DHCRISORDITEMPRINTED(Oeorditemdr,bodypartRowid))
	.e  s PrintFalg=$g(^DHCRISORDITEMPRINTED(Oeorditemdr))
	.q:(PrintFalg'="")&(IsPrint'=PrintFalg)
	.s bOut="N"  ;是否已经输出
	.s paadmdr=$p(^OEORD(OrderRowid),"^",1) 
	.s IsMemo=""
	.s IsMemo=##class(web.DHCRisCommFunctionEx).ExistMemo(Oeorditemdr)
	.i IsMemo="Y" s Memo="浏览" 
	.s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
	.q:(PatInfo="") 
	.s GetRegNo=$p(PatInfo,"^",1)
	.q:(InRegNo'="")&(InRegNo'=GetRegNo)
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
	.;w !,ward_"***"_GetWardDR
	.q:(ward'="")&(ward'=GetWardDR)
	.s Getroomdesc=$p(PatInfo,"^",15)
	.s GetSexDr=$p(PatInfo,"^",13)
	.s PapatmasDR=$p(PatInfo,"^",24)
	.s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(OrderRowid,itemsub,bodypartRowid)
	.;b //001
	.;i IsBKFlag'="Y" s GetPatientStatusCode="A"
	.s GetstrOrderName=$p(ordInfo,"^",1)
	.q:(InIsBedOrd="N")&(GetstrOrderName["床旁")
	.q:(InIsBedOrd="Y")&(GetstrOrderName'["床旁")
	.s GetstrDate=$p(ordInfo,"^",2)
	.s GetstrTime=$p(ordInfo,"^",3)
	.s Getifbed=$p(ordInfo,"^",9)
	.s GetItemStatusCode=$p(ordInfo,"^",14)
	.s GetRecLocName=$p(ordInfo,"^",21)
	.;b //002
	.q:(GetItemStatusCode="U")!(GetItemStatusCode="D")!(GetItemStatusCode="C") ;过滤作废或停止医嘱
	.s GetordDate=$p(ordInfo,"^",15)
	.s GetordTime=$p(ordInfo,"^",16)
	.s GetItemStatusCode=$p(ordInfo,"^",17)   			;医嘱状态
	.s GetServerMaterial=$p(ordInfo,"^",18)   			;申请项目标记 
	.;b //003
	.q:(GetServerMaterial'="S")
	.s GetRecLocDR=$p(ordInfo,"^",19)
	.s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfo(Oeorditemdr,bodypartRowid)
	.s GetStudyNo=$p(RegInfo,"^",1)
	.i GetStudyNo'="" s GetPatientStatusCode="I"
	.;b //004
	.q:(InStudyNo'="")&(InStudyNo'=GetStudyNo)
	.s GetstrRegDate=$p(RegInfo,"^",2)
	.s GetstrRegTime=$p(RegInfo,"^",3)
	.s GetRegDate=$p(RegInfo,"^",17)
	.s GetResDesc="",strRppDate="",strRppTime="",BKInfo=""
	.;i IsBKFlag="Y" s BKInfo=..GetBKInfo(Oeorditemdr,bodypartRowid)
	.s BKInfo=..GetBKInfo(Oeorditemdr,bodypartRowid)
	.s strRppDate=$p($g(BKInfo),"^",1)
	.s strRppTime=$p($g(BKInfo),"^",2)
	.s GetResDesc=$p($g(BKInfo),"^",3)
	.s GetReportStatusCode="N"     ;未写报告
	.s GetImgcount=0
	.s GetRptID=""
	.s GetRptDocDR="",GetRptDocName="",GetRptDate="",GetRptTime="",GetVerifyDocDR=""
	.s GetVerifyDocName="",GetVerifyDate="",GetVerifyTime="",HaveImage=""
	.;b //005
	.i GetStudyNo'="" d
	..s Imrowid=0 f  s Imrowid=$o(^DHCRBStudyi("StudyNo-Images",GetStudyNo,Imrowid)) q:Imrowid=""  d
	...s GetPatientStatusCode="E"    ;正在检查
	...s ExtName=$p($g(^DHCRBStudy(0,"StudyImages",Imrowid)),"^",2)
	...i ((ExtName="avi")!(ExtName="dcm")!(ExtName="normal")!(ExtName="dsa"))  d
	....s GetImgcount=GetImgcount+1
	....s GetReportStatusCode="I"             ;图象已经采集
	....s HaveImage="是"
	..s ReportStuatCode="VS"
	..s Rptrowid=0  f  s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",GetStudyNo,Rptrowid)) q:Rptrowid=""  d
	...s GetRptID=$p(^DHCRBStudy("Report",Rptrowid),"^",2)
	...s GetRptVersion=$p(^DHCRBStudy("Report",Rptrowid),"^",3)
	...s GetRptStatusDR=$p(^DHCRBStudy("Report",Rptrowid),"^",4)
	...i GetRptStatusDR'="" d
	....s GetReportStatusCode=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",1)
	....i ReportStuatCode[GetReportStatusCode d
	.....s GetPatientStatusCode="O"
	....e  d
	.....s GetPatientStatusCode="E"
	....s GetRptStatusDesc=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",2)
	...s GetRptIsYX=$p(^DHCRBStudy("Report",Rptrowid),"^",7)
	...s GetRptDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",8)
	...i GetRptDocDR'="" s GetRptDocName=$p(^SSU("SSUSR",GetRptDocDR),"^",2)
	...s GetRptDate=$p(^DHCRBStudy("Report",Rptrowid),"^",9)
	...i GetRptDate'="" s GetRptDate=$zd(GetRptDate,3)
	...s GetRptTime=$p(^DHCRBStudy("Report",Rptrowid),"^",10)
	...i GetRptTime'="" s GetRptTime=$zt(GetRptTime,3)
	...s GetVerifyDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",11)
	...i GetVerifyDocDR'="" s GetVerifyDocName=$p(^SSU("SSUSR",GetVerifyDocDR),"^",2)
	...s GetVerifyDate=$p(^DHCRBStudy("Report",Rptrowid),"^",12)
	...i GetVerifyDate'="" s GetVerifyDate=$zd(GetVerifyDate,3) 
	...s GetVerifyTime=$p(^DHCRBStudy("Report",Rptrowid),"^",13)
	...i GetVerifyTime'="" s GetVerifyTime=$zt(GetVerifyTime,3)
	...s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
	...q:(RisStatusCode'="S")&(RisStatusCode'="")&(RisStatusCode'=GetPatientStatusCode)
	...s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
	...s bOut="Y"
	...Do OutItemByBookDate
	.i bOut="N" d
	..s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
	..q:(RisStatusCode'="S")&(RisStatusCode'="")&(RisStatusCode'=GetPatientStatusCode)
	..s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
	..s bOut="Y"
	..Do OutItemByBookDate
	
	quit
     
OutItemByBookDate
    set Data=$lb(GetRegNo,GetName,GetSexDesc,GetBedNo,GetstrOrderName,GetstrDate,GetstrTime,GetRecLocName,GetReportStatus,strRppDate,strRppTime,GetResDesc,GetstrRegDate,GetstrRegTime,GetStudyNo,GetRptDocName,GetVerifyDocName,GetPatientStatus,GetWardName,GetstrAge,PrintFalg,Oeorditemdr,MeothodDesc,$g(GetRecLocDR),$g(IsSend),$g(Memo),$g(bodypartRowid))
    s ^DHCRISTEMPWARDQUERYDATA($g(InUserId),ind)=$g(Oeorditemdr)_"^"_$J_"^"_$g(GetRecLocName)_"^"_$g(GetBedNo)_"^"_$g(GetRegNo)_"^"_$g(GetName)_"^"_$g(GetSexDesc)_"^"_$g(GetstrAge)_"^"_$g(GetstrOrderName)_"^"_$g(GetstrDate)_"^"_$g(GetstrTime)_"^"_$g(strRppDate)_"^"_$g(strRppTime)_"^"_$g(GetstrRegDate)_"^"_$g(GetstrRegTime)_"^"_$g(GetStudyNo)_"^"_$g(GetRptDocName)_"^"_$g(GetVerifyDocName)_"^"_$g(GetPatientStatus)_"^"_$g(GetWardName)_"^"_$g(GetResDesc)_"^"_PrintFalg_"^"_$g(MeothodDesc)_"^"_$g(GetRecLocDR)_"^"_$g(IsSend)_"^"_$g(Memo)_"^"_$g(bodypartRowid)
    s ^DHCRISTEMPWARDQUERYDATA($g(InUserId))=ind
   	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	b //003
 	quit
}

/// d ##class(%ResultSet).RunQuery("web.DHCRisWardQuery","QueryExeLoc","") 
Query QueryExeLoc(Desc As %String) As %Query(ROWSPEC = "desc:%String,rw:%String")
{
}

ClassMethod QueryExeLocExecute(ByRef qHandle As %Binary, Desc As %String) As %Status
{
	
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	/*s LocType="E"
	Set RowId=0	f  s RowId=$o(^CTLOC(0,"LocType",LocType,RowId)) q:RowId=""  d
	.s GetDesc=$p(^CTLOC(RowId),"^",2) 
	.i (GetDesc[Desc) d
	..Do OutputRow*/

 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s LocType="E"
 	s Desc=$ZCONVERT(Desc,"U") 
	Set RowId=0	f  s RowId=$o(^CTLOC(RowId)) q:RowId=""  d
	.s GetDesc=$p(^CTLOC(RowId),"^",2)
	.s Gettype=$p(^CTLOC(RowId),"^",13)
	.s contactName=$p(^CTLOC(RowId),"^",43)
	.s contactName=$ZCONVERT(contactName,"U")
	.q:(LocType'="")&(Gettype'=LocType)
	.i (Desc="") d
	..Do OutputRow
	.e  d
	..if ((GetDesc[Desc)||(contactName[Desc)) d
	...Do OutputRow
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow
	set Data=$lb(GetDesc,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryExeLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryExeLocExecute ]
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

ClassMethod getBookDetailBodylist(resScheduleDetailID As %String) As %String
{
	n (resScheduleDetailID)
	q:(resScheduleDetailID="") ""
	s bodyList=""
	s bodyRowid=""
	for
	{
		s bodyRowid=$o(^User.DHCRBCSchduleDetailBodyI("IndexDetailBody",resScheduleDetailID,bodyRowid))
		q:(bodyRowid="")
		if bodyList=""  s bodyList=bodyRowid
		e  s bodyList=bodyList_"^"_bodyRowid
	}
	q bodyList
}

ClassMethod GetCurrentDate()
{
	return $zd(+$h,3)_"   "_$zt($p($h,",",2),1)
}

}
