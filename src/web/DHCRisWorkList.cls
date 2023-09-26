Import SQLUser

Class web.DHCRisWorkList Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCRisWorkList","QueryItem","^^^^I^^^^687","62578","62810")
Query QueryItem(strCondition As %String, startdate As %String, enddate As %String) As %Query(ROWSPEC = "Tregno:%String,Tname:%String,Tsex:%String,Tbedno:%String,Titemname:%String,TstrDate:%String,TstrTime:%String,Tdepname:%String,TPatientStatus:%String,TAppointDate:%String,TAppointstTime:%String,TResDesc:%String,TstrRegDate:%String,TstrRegTime:%String,TStudyNo:%String,TReportDoc:%String,TReportVerifyDoc:%String,TRisStatusDesc:%String,Twarddesc:%String,TAge:%String,PrintFalg:%String,OEOrdItemID:%String,MeothodDesc:%String,RecLocDR:%String,IsSend:%String,Memo:%String,BookedNo:%String,paadmdr:%String,PatientStatusCode:%String")
{
}

ClassMethod QueryItemExecute(ByRef qHandle As %Binary, strCondition As %String, startdate As %String, enddate As %String) As %Status
{
   
   s ^DHCRis("TEMPWORKLISTXX")=strCondition_"&&&"_startdate_"&&&"_enddate
   
   
   s ward=$p(strCondition,"^",1)
   s ward=$p(ward,$c(0))
   //i ward="" s ward=%session.Get("LOGON.WARDID")
   
   s InAppLocRowid=$p(strCondition,"^",2)
   s InAppLocRowid=$p(InAppLocRowid,$c(0))
   
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
   
   s InUserId=$p(strCondition,"^",8)
   s InUserId=$p(InUserId,$c(0))
   i InUserId="" s InUserId="71"
     
   s BKDesc=$p(strCondition,"^",9)
   s BKDesc=$p(BKDesc,$c(0))
   
   Set repid=$I(^CacheTemp)
   If $g(ind)="" Set ind=1
   
  
   s return=..QueryByItemDate(ward, InAppLocRowid, InRegNo, InStudyNo, RisStatusCode, RecLocId, IsPrint,InUserId,BKDesc,startdate, enddate)
   Quit $$$OK
}

ClassMethod QueryItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryItemExecute ]
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

ClassMethod QueryItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryByItemDate(ward, InAppLocRowid, InRegNo, InStudyNo, RisStatusCode, RecLocId, IsPrint, InUserId, BKDesc, startdate, enddate)
{
	for date=startdate:1:enddate
    {
       s OrderRowid=0  f  s OrderRowid=$o(^OEORDi(0,"ItemDate",date,OrderRowid)) q:(OrderRowid="")  d
       .;q:(RisStatusCode="")
       .s itemsub=0  f  s itemsub=$o(^OEORDi(0,"ItemDate",date,OrderRowid,itemsub)) q:(itemsub="")  d
       ..s Oeorditemdr=OrderRowid_"||"_itemsub
       ..;i (Oeorditemdr="62223||627") w !,"OK"
       ..q:(Oeorditemdr="")
       ..s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
       ..q:(arcimid="")
       ..s ServerMaterial=""
       ..s ServerMaterial=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7)),"^",6)
       ..q:(ServerMaterial'="Service")&(ServerMaterial'="S")
       ..s paadmdr=$p(^OEORD(OrderRowid),"^",1)
       ..s AppLocRowid=""
       ..s AppLocRowid=$p($g(^OEORD(OrderRowid,"I",itemsub,7)),"^",2)
       ..;w !,"AppLocRowid="_AppLocRowid
       ..q:(InAppLocRowid'="")&(InAppLocRowid'=AppLocRowid) ;按开单科室过滤
       ..;w !,"InAppLocRowid="_InAppLocRowid
       ..;w !,"AppLocRowid="_AppLocRowid
       ..s RecLocdr=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)
       ..q:(RecLocId'="")&(RecLocId'=RecLocdr) ;按执行科室过滤
       ..s MeothodDesc=""
       ..s MeothodDesc=##class(web.DHCRisWardQueryZGYD).RequestBookType(arcimid)
       ..q:(BKDesc'="")&(BKDesc'=MeothodDesc) ;按预约类型过滤
       ..s IsSend="",Memo=""
       ..s IsSend=##class(web.DHCRisWardQueryZGYD).IsSendAppBill(Oeorditemdr)
       ..;q:(ArcItemRowid'="")&(ArcItemRowid'=arcimid)
       ..s PrintFalg=""
       ..s PrintFalg=$g(^DHCRISORDITEMPRINTED(Oeorditemdr))
       ..i PrintFalg="" s PrintFalg="N"
       ..q:(IsPrint'="")&(IsPrint'=PrintFalg) ;按是否打印过滤
       ..s IsMemo=""
       ..s IsMemo=##class(web.DHCRisCommFunctionEx).ExistMemo(Oeorditemdr)
       ..i IsMemo="Y" s Memo="浏览"
       ..s bOut="N"  ;是否已经输出 
       ..s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
	   ..s GetRegNo=$p(PatInfo,"^",1)
	   ..q:(InRegNo'="")&(InRegNo'=GetRegNo) ;按登记号过滤
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
	   ..q:(ward'="")&(ward'=GetWardDR) ;按病区过滤
	   ..s Getroomdesc=$p(PatInfo,"^",15)
	   ..s GetSexDr=$p(PatInfo,"^",13)
	   ..s PapatmasDR=$p(PatInfo,"^",24)
	   ..s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(OrderRowid,itemsub)
	   ..s GetPatientStatusCode="A"
       ..s GetstrOrderName=$p(ordInfo,"^",1)
       ..q:(GetstrOrderName["床旁")
       ..;q:(InIsBedOrd="N")&(GetstrOrderName["床旁")
       ..;q:(InIsBedOrd="Y")&(GetstrOrderName'["床旁")
       ..s GetstrDate=$p(ordInfo,"^",2)
       ..s GetstrTime=$p(ordInfo,"^",3)
       ..s Getifbed=$p(ordInfo,"^",9)
       ..s GetTotalPrice=$p(ordInfo,"^",12)
       ..s Getbilled=$p(ordInfo,"^",13)
       ..s GetItemStatusCode=$p(ordInfo,"^",14)
       ..s GetRecLocName=$p(ordInfo,"^",21)
       ..q:(GetItemStatusCode="U")!(GetItemStatusCode="D") ;过滤作废或停止医嘱
       ..s GetordDate=$p(ordInfo,"^",15)
       ..s GetordTime=$p(ordInfo,"^",16)
       ..s GetItemStatusCode=$p(ordInfo,"^",17)   			;医嘱状态
       ..s GetServerMaterial=$p(ordInfo,"^",18)   			;申请项目标记 
       ..;q:(GetServerMaterial'="S")
       ..s GetRecLocDR=$p(ordInfo,"^",19)
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
       ..s BKInfo="",BookedNo="",BKInfo=""
       ..s strRppDate="",strRppTime="",GetResDesc=""
       ..s IsBKFlag=##class(web.DHCRisWardQueryZGYD).GetBKFlag(Oeorditemdr)
       ..i IsBKFlag="Y" d
       ...s GetPatientStatusCode="B"
       ...s BKInfo=##class(web.DHCRisWardQueryZGYD).GetBKInfo(Oeorditemdr)
       ...s strRppDate=$p($g(BKInfo),"^",1)
       ...s strRppTime=$p($g(BKInfo),"^",2)
       ...s GetResDesc=$p($g(BKInfo),"^",3)
       ...s BookedNo=$p($g(BKInfo),"^",5)
       ..s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfo(Oeorditemdr)
       ..s GetStudyNo=$p(RegInfo,"^",1)
       ..i GetStudyNo'="" s GetPatientStatusCode="I"
       ..q:(InStudyNo'="")&(InStudyNo'=GetStudyNo) ;
       ..s GetstrRegDate=$p(RegInfo,"^",2)
       ..s GetstrRegTime=$p(RegInfo,"^",3)
       ..s GetRegDate=$p(RegInfo,"^",17)
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
       ....q:(RisStatusCode'="S")&(RisStatusCode'="")&(RisStatusCode'=GetPatientStatusCode)
       ....s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
       ....s bOut="Y"
       ....Do OutRowItemDate
       ..i bOut="N" d
       ...s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
       ...q:(RisStatusCode'="S")&(RisStatusCode'="")&(RisStatusCode'=GetPatientStatusCode)
       ...s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
       ...s bOut="Y"
       ...Do OutRowItemDate
    }
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK   
   
OutRowItemDate
    set Data=$lb(GetRegNo,GetName,GetSexDesc,GetBedNo,GetstrOrderName,GetstrDate,GetstrTime,GetRecLocName,GetReportStatus,strRppDate,strRppTime,GetResDesc,GetstrRegDate,GetstrRegTime,GetStudyNo,GetRptDocName,GetVerifyDocName,GetPatientStatus,GetWardName,GetstrAge,PrintFalg,Oeorditemdr,MeothodDesc,$g(GetRecLocDR),$g(IsSend),$g(Memo),$g(BookedNo),$g(paadmdr),$g(GetPatientStatusCode))
   	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
 	quit
}

ClassMethod GetAppLocDR(paadmdr As %String) As %String
{
	 s Docdr="",SSURowid="",AppLocDR=""
	 s Docdr=$p(^PAADM(paadmdr),"^",9)
     i $g(Docdr)'="" d
	 .s SSURowid=$o(^SSU("SSUSR",0,"CTPCP",Docdr,-1))
	 .i SSURowid'="" s AppLocDR=$p($g(^SSU("SSUSR",SSURowid)),"^",4)
	 q AppLocDR
}

ClassMethod GetLocName(LocID) As %String
{
	s LocName=""
	if (LocID'="") s LocName=$p(^CTLOC(LocID),"^",2)
	q LocName
}

/// 取消预约函数注释 sunyi 
/// 对于多预约医嘱转预约函数
/// sunyi 2012-12-09
ClassMethod DeleteBookInfo(Oeorditemdr) As %String
{
	Set $ZT="ERROR"
	s Count=$l(Oeorditemdr,"@")
	for i=1:1:Count 
    {
	    s perOrditemRowid=$p(Oeorditemdr,"@",i)
	    s OrderRowid=$p(perOrditemRowid,"||",1)
	    s itemsub=$p(perOrditemRowid,"||",2)
	    s approwid=""
	   	i $g(^OEORD(OrderRowid,"I",itemsub,6))'="" s approwid=$p(^OEORD(OrderRowid,"I",itemsub,6),"^",5)
	   	;q:$g(approwid)="" "" 
	   	;q:approwid=$C(0) "" 
	   	
	   	if (approwid'="")&&(approwid'=$c(0))
	   	{ 
		    TSTART
		   	&sql(update OE_OrdItem set OEORI_APPT_DR="" where OEORI_RowId=:perOrditemRowid)
		   	I SQLCODE TRollBack 
		    q:SQLCODE_"^"_"-1"  
		   
		   
		    s resrowid=$p(approwid,"||",1)
		   	s apptsch=$p(approwid,"||",2)
		   	s aptchildsub=$p(approwid,"||",3)
		    s Soltchild=0 f  s Soltchild=$o(^RBAS(resrowid,apptsch,"APPT",aptchildsub,"SLOT",Soltchild)) q:Soltchild=""  d
		    .s apptschdr=$p(^RBAS(resrowid,apptsch,"APPT",aptchildsub,"SLOT",Soltchild),"^",2)
		    .s resrowid1=$p(apptschdr,"||",1)
		   	.s apptsch1=$p(apptschdr,"||",2)
		    .s BookedNums=$p(^RBAS(resrowid1,apptsch1),"^",11)
		   	.i BookedNums'="" s BookedNums=BookedNums-1
		   	.i BookedNums="0" s BookedNums=""
		   	.&sql(update RB_ApptSchedule set AS_BookedSlots=:BookedNums where AS_RowId=:apptschdr)
		   	
		   	;I SQLCODE TRollBack  Quit SQLCODE
		   	&sql(delete from RB_ApptFollowOnSlots where RBFOS_ParRef=:approwid)
		    I SQLCODE TRollback  
            q:SQLCODE_"^"_"-1"
		   
		   	&sql(delete from RB_Appointment where APPT_RowId=:approwid)
		   	I SQLCODE TRollBack  
		    q:SQLCODE_"^"_"-1"
		    
		    TCOMMIT
		 }
		 else 
	   	 {
		   	  s SQLCODE=##class(web.DHCRisResourceApptSchudleZGYD).CancelBookedInfo(perOrditemRowid)	
	     }
		    
		 s DHCENSInfo="",ret="0"
		 ;s DHCENSInfo=##class(DHCENS.BC.BS.WebBCService).CancelHisBookedInfo(perOrditemRowid)
		 ;s ret=$p(DHCENSInfo,"^",1) 	    
		    
    }  
   	q SQLCODE_"^"_ret
   	
ERROR	
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK
 	q SQLCODE_"^"_ret
}

}
