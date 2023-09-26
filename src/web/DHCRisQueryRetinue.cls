Import SQLUser

Class web.DHCRisQueryRetinue Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCRisQueryRetinue","QueryBookItemData","^^^^^687^","63400","63440")
Query QueryBookItemData(strCondition As %String, startdate As %String, enddate As %String) As %Query(ROWSPEC = "Tregno:%String,Tname:%String,Tsex:%String,Tbedno:%String,Titemname:%String,TstrDate:%String,TstrTime:%String,Tdepname:%String,TPatientStatus:%String,TAppointDate:%String,TAppointstTime:%String,TResDesc:%String,TstrRegDate:%String,TstrRegTime:%String,TStudyNo:%String,TReportDoc:%String,TReportVerifyDoc:%String,TRisStatusDesc:%String,Twarddesc:%String,TAge:%String,PrintFalg:%String,OEOrdItemID:%String,MeothodDesc:%String,RecLocDR:%String,IsSend:%String,Memo:%String,Retinue:%String,TAdmLoc:%String,BookedNo:%String")
{
}

ClassMethod QueryBookItemDataExecute(ByRef qHandle As %Binary, strCondition As %String, startdate As %String, enddate As %String) As %Status
{
   
   s ^DHCRis("TEMPZGYD")=strCondition_"&&&"_startdate_"&&&"_enddate
   
   
   s ward=$p(strCondition,"^",1)
   s ward=$p(ward,$c(0))
   //i ward="" s ward=%session.Get("LOGON.WARDID")
   
   s ArcItemRowid=$p(strCondition,"^",2)
   s ArcItemRowid=$p(ArcItemRowid,$c(0))
   
   s InRegNo=$p(strCondition,"^",3)
   s InRegNo=$p(InRegNo,$c(0))
   
   s RecLocId=$p(strCondition,"^",4)
   s RecLocId=$p(RecLocId,$c(0))
   
   s IsPrint=$p(strCondition,"^",5)
   s IsPrint=$p(IsPrint,$c(0))
   
   s InUserId=$p(strCondition,"^",6)
   s InUserId=$p(InUserId,$c(0))
   i InUserId="" s InUserId="71"
   
   s RetinueUserID=$p(strCondition,"^",7)
   i RetinueUserID'="" s RetinueUserID=..GetDispatcherDR(RetinueUserID)
   s RetinueUserID=$p(RetinueUserID,$c(0))
   
   s InAdmLocID=$p(strCondition,"^",8)
   s InAdmLocID=$p(InAdmLocID,$c(0))
   
   s RisStatusCode=$p(strCondition,"^",9)
   s RisStatusCode=$p(RisStatusCode,$c(0))
   
   s BKDesc=$p(strCondition,"^",10)
   s BKDesc=$p(BKDesc,$c(0))
   k ^DHCRISTEMPRETINUEQUERYDATA($g(InUserId))
   
   Set repid=$I(^CacheTemp)
   If $g(ind)="" Set ind=1
   
   if (RisStatusCode="B")
   {
     s return=..QueryBookedItem(ward,ArcItemRowid,InRegNo,RecLocId,IsPrint,InUserId,startdate,enddate,RetinueUserID,InAdmLocID,RisStatusCode,BKDesc)
     Quit $$$OK
   }else
   {
	  s return=..QuerybyItemDate(ward, ArcItemRowid, InRegNo, RecLocId, IsPrint, InUserId, startdate, enddate, RetinueUserID, InAdmLocID, RisStatusCode, BKDesc)
     Quit $$$OK  
   }
}

ClassMethod QueryBookItemDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBookItemDataExecute ]
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

ClassMethod QueryBookItemDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBookItemDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryBookedItem(ward, ArcItemRowid, InRegNo, RecLocId, IsPrint, InUserId, startdate, enddate, RetinueUserID, InAdmLocID, RisStatusCode, BKDesc)
{
	k ^DHCRISYARDMANTMEP("TEMPITEMROWID")
	
	s QueryType=""
	s CountInfo=""
	s CountInfo=..GetSetExeLoc(InUserId)
	i (CountInfo="")
	{
		Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	}
	s Count=$l(CountInfo,"@")
    
	for date=startdate:1:enddate
    {
	     ;RB_ApptSchedule
         
            for i=1:1:Count  d
	         .s perInLocID=$p(CountInfo,"@",i)
			 .s RowId="" f  s RowId=$o(^RB("RES",0,"CTLOC",perInLocID,RowId)) q:RowId=""  d
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
			 .......q:($d(^DHCRISYARDMANTMEP("TEMPITEMROWID",Oeorditemdr)))
             .......s ^DHCRISYARDMANTMEP("TEMPITEMROWID",Oeorditemdr)=""
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
	         .....s BookedNo=""
	         .....s BookedNo=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",20)
	         .....q:(Oeorditemdr="")
	         .....q:'$d(^DHCRISORDITEMPRINTED(Oeorditemdr)) //预约未打印退出
	         .....q:(Oeorditemdr="")
	         .....q:($d(^DHCRISYARDMANTMEP("TEMPITEMROWID",Oeorditemdr)))
             .....s ^DHCRISYARDMANTMEP("TEMPITEMROWID",Oeorditemdr)=""
	         .....s strRppDate="",strRppTime=""
	         .....s strRppDate=$p(^DHCRBCResourceSchdule(SchRowid),"^",2)
	         .....s strRppDate=$zd(strRppDate,3)
	         .....s strRppTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",5)
	         .....s strRppTime=$zt(strRppTime,1)
	         .....;w !,"strRppTime1="_strRppTime
	         .....;判断detail表里是否有开始时间
	         .....i $p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",18)'="" d
	         ......s strRppTime=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",18)
	         ......i strRppTime'="" s strRppTime=$zt(strRppTime,1)
	         .....Do OutRow5
	         ..e  d
	         ...s DEBRwoid="" f  s DEBRwoid=$o(^DHCRBCExternalBookInfoi("Date",date,perInLocID,DEBRwoid)) q:(DEBRwoid="")  d
	         ....s Oeorditemdr=$p($g(^DHCRBCExternalBookInfo(DEBRwoid)),"^",2)
	         ....q:((Oeorditemdr="")!(Oeorditemdr=" "))
	         ....q:'$d(^DHCRISORDITEMPRINTED(Oeorditemdr)) //预约未打印退出
             ....q:($d(^DHCRISYARDMANTMEP("TEMPITEMROWID",Oeorditemdr)))
             ....s ^DHCRISYARDMANTMEP("TEMPITEMROWID",Oeorditemdr)=""
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
			 s paadmdr=$p(^OEORD(ordrowid),"^",1)
			 q:(paadmdr="")
			 s papatmasmdr=$p(^PAADM(paadmdr),"^",1)  
			 s GetAdmLocdr=$p(^PAADM(paadmdr),"^",4)
			 q:(InAdmLocID'="")&(InAdmLocID'=GetAdmLocdr)
			 ;get patient diagnose 
			 s ret=""
			 s ret=..IsExit(Oeorditemdr,InUserId)
			 q:(ret="N")
			 s IsRegFlag=""
			 s IsRegFlag=##class(web.DHCRisWardQueryZGYD).GetRegFlag(Oeorditemdr)
			 ;q:(IsRegFlag="Y")
			 s arcimid=$p($g(^OEORD(ordrowid,"I",orditemchildsub,1)),"^",2)
			 q:(arcimid="")
			 s ServerMaterial=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7)),"^",6)
             q:(ServerMaterial'="S")
			 s MeothodDesc=""
             s MeothodDesc=##class(web.DHCRisWardQueryZGYD).RequestBookType(arcimid)
             q:((MeothodDesc="不需预约")&(MeothodDesc="")&(BKDesc=""))
             q:(BKDesc'="")&(BKDesc'=MeothodDesc)
             s IsSend="",Memo=""
             s IsSend=##class(web.DHCRisWardQueryZGYD).IsSendAppBill(Oeorditemdr)
	         s RecLocdr=$p($g(^OEORD(ordrowid,"I",orditemchildsub,3)),"^",6)
	         q:(RecLocId'="")&(RecLocId'=RecLocdr)
	         q:(ArcItemRowid'="")&(ArcItemRowid'=arcimid)
			 s PrintFalg=""
	         s PrintFalg=$g(^DHCRISRETINUEPRINTDATA(Oeorditemdr))
	         q:(IsPrint="N")&(PrintFalg="Y")
	         s IsMemo=""
             s IsMemo=##class(web.DHCRisCommFunctionEx).ExistMemo(Oeorditemdr)
             i IsMemo="Y" s Memo="浏览"
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
		     s GetAdmLoc=$p(PatInfo,"^",40)
		     q:(ward'="")&(ward'=GetWardDR)
		     s GetRetinueRowid=""
		     ;w !,"GetWardDR="_GetWardDR
		     ;w !,"Oeorditemdr="_Oeorditemdr
		     i GetWardDR'="" s GetRetinueRowid=..GetRetinuebyWardDR(GetWardDR,Oeorditemdr)
		     q:(RetinueUserID'="")&(RetinueUserID'=GetRetinueRowid)
		     s (GetRetUser)=""
		     i GetRetinueRowid'="" s GetRetUser=..GetUser(GetRetinueRowid)
		     s Getroomdesc=$p(PatInfo,"^",15)
		     s GetSexDr=$p(PatInfo,"^",13)
		     s PapatmasDR=$p(PatInfo,"^",24)
		     s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(ordrowid,orditemchildsub)
		     s GetPatientStatusCode="A"
	         s GetstrOrderName=$p(ordInfo,"^",1)
	         ;q:(InIsBedOrd="N")&(GetstrOrderName["床旁")
	         ;q:(InIsBedOrd="Y")&(GetstrOrderName'["床旁")
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
	         ;q:(GetServerMaterial'="S")
	         s GetRecLocDR=$p(ordInfo,"^",19)
			 s GetPatientStatusCode="B"
			 s GetReportStatusCode="N"  ;未写报告
			 s GetstrRegDate="",GetstrRegTime="",GetRptDocName="",GetVerifyDocName="",GetStudyNo="",GetIndex="",GetEQDesc=""
			 s bOut="N",HaveImage=""
			 s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfo(Oeorditemdr)
	         s GetStudyNo=$p(RegInfo,"^",1)
	         i GetStudyNo'="" s GetPatientStatusCode="I"
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
	         ..q:((RisStatusCode'="")&(RisStatusCode'="S")&(RisStatusCode'=GetPatientStatusCode))
	         ..s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
	         ..s bOut="Y"
	         ..set Data=$lb(GetRegNo,GetName,GetSexDesc,GetBedNo,GetstrOrderName,GetstrDate,GetstrTime,GetRecLocName,GetReportStatus,strRppDate,strRppTime,GetResDesc,GetstrRegDate,GetstrRegTime,GetStudyNo,GetRptDocName,GetVerifyDocName,GetPatientStatus,GetWardName,GetstrAge,PrintFalg,Oeorditemdr,$g(MeothodDesc),$g(GetRecLocDR),$g(IsSend),$g(Memo),GetRetUser,$g(GetAdmLoc),$g(BookedNo))
             ..s ^DHCRISTEMPRETINUEQUERYDATA($g(InUserId),ind)=$g(Oeorditemdr)_"^"_$J_"^"_$g(GetRecLocName)_"^"_$g(GetBedNo)_"^"_$g(GetRegNo)_"^"_$g(GetName)_"^"_$g(GetSexDesc)_"^"_$g(GetstrAge)_"^"_$g(GetstrOrderName)_"^"_$g(GetstrDate)_"^"_$g(GetstrTime)_"^"_$g(strRppDate)_"^"_$g(strRppTime)_"^"_$g(GetstrRegDate)_"^"_$g(GetstrRegTime)_"^"_$g(GetStudyNo)_"^"_$g(GetRptDocName)_"^"_$g(GetVerifyDocName)_"^"_$g(GetPatientStatus)_"^"_$g(GetWardName)_"^"_$g(GetResDesc)_"^"_PrintFalg_"^"_$g(MeothodDesc)_"^"_$g(GetRecLocDR)_"^"_$g(IsSend)
             ..s ^DHCRISTEMPRETINUEQUERYDATA($g(InUserId))=ind
   	         ..Set ^CacheTemp(repid,ind)=Data
	         ..Set ind=ind+1
 	         ..quit
	         i bOut="N" d
	         .s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
	         .q:((RisStatusCode'="")&(RisStatusCode'="S")&(RisStatusCode'=GetPatientStatusCode))
	         .s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
	         .s bOut="Y"
	         .set Data=$lb(GetRegNo,GetName,GetSexDesc,GetBedNo,GetstrOrderName,GetstrDate,GetstrTime,GetRecLocName,GetReportStatus,strRppDate,strRppTime,GetResDesc,GetstrRegDate,GetstrRegTime,GetStudyNo,GetRptDocName,GetVerifyDocName,GetPatientStatus,GetWardName,GetstrAge,PrintFalg,Oeorditemdr,$g(MeothodDesc),$g(GetRecLocDR),$g(IsSend),$g(Memo),GetRetUser,$g(GetAdmLoc),$g(BookedNo))
             .s ^DHCRISTEMPRETINUEQUERYDATA($g(InUserId),ind)=$g(Oeorditemdr)_"^"_$J_"^"_$g(GetRecLocName)_"^"_$g(GetBedNo)_"^"_$g(GetRegNo)_"^"_$g(GetName)_"^"_$g(GetSexDesc)_"^"_$g(GetstrAge)_"^"_$g(GetstrOrderName)_"^"_$g(GetstrDate)_"^"_$g(GetstrTime)_"^"_$g(strRppDate)_"^"_$g(strRppTime)_"^"_$g(GetstrRegDate)_"^"_$g(GetstrRegTime)_"^"_$g(GetStudyNo)_"^"_$g(GetRptDocName)_"^"_$g(GetVerifyDocName)_"^"_$g(GetPatientStatus)_"^"_$g(GetWardName)_"^"_$g(GetResDesc)_"^"_PrintFalg_"^"_$g(MeothodDesc)_"^"_$g(GetRecLocDR)_"^"_$g(IsSend)
             .s ^DHCRISTEMPRETINUEQUERYDATA($g(InUserId))=ind
   	         .Set ^CacheTemp(repid,ind)=Data
	         .Set ind=ind+1
 	         .quit
}

ClassMethod SetPrintFlag(oeorditemdr As %String)
{
	q:(oeorditemdr="")
	s ^DHCRISRETINUEPRINTDATA(oeorditemdr)="Y"
	q 0
}

/// w ##class(web.DHCRisQueryRetinue).GetSetExeLoc("687")
ClassMethod GetSetExeLoc(UserRowid As %String) As %String
{
	s LocInfo="",Rowid=""
	q:(UserRowid="") LocInfo
	s Rowid=$o(^DHCRBCOutWorkerSeti("USER",UserRowid,Rowid))
	q:(Rowid="") LocInfo
	s LocSetRwoid="" f  s LocSetRwoid=$o(^DHCRBCYardmanLocSeti("Yardman-Loc",Rowid,LocSetRwoid)) q:(LocSetRwoid="")  d 
	.s LocId=$p($g(^DHCRBCYardmanLocSet(LocSetRwoid)),"^",2)
	.q:(LocId="") 
	.i LocInfo="" s LocInfo=LocId
	.e  d
	..s LocInfo=LocInfo_"@"_LocId
	
	q LocInfo
}

/// w ##class(web.DHCRisQueryRetinue).GetRetinuebyWardDR("19","20017||3870")
ClassMethod GetRetinuebyWardDR(GetWard As %String, InOeorditemdr As %String) As %String
{
	s DMRowid="",RetinueId="",UserID="",WorkerRowid=""
	
	q:(GetWard="") RetinueId
	q:(InOeorditemdr="") RetinueId
	s DMRowid=$o(^DHCRBModifyRetinuei("ORDITEM",InOeorditemdr,DMRowid))
	i DMRowid'="" s UserID=$p($g(^DHCRBModifyRetinue(DMRowid)),"^",3)
	i UserID'="" s WorkerRowid=$o(^DHCRBCOutWorkerSeti("USER",UserID,WorkerRowid))
	s RetinueId=WorkerRowid
	q:(RetinueId'="") RetinueId
	i RetinueId="" d
	.&Sql(select DRWS_Retinue_DR into :RetinueId from DHCRBC_RetinueWardSet where DRWS_Ward_DR=:GetWard)
	q RetinueId
}

/// w ##class(web.DHCRisQueryRetinue).GetDispatcherDR("687")
ClassMethod GetDispatcherDR(UserRowid As %String) As %String
{
	q:(UserRowid="")
	s DispatcherDR=""
	s DispatcherDR=$o(^DHCRBCOutWorkerSeti("USER",UserRowid,DispatcherDR))
	q DispatcherDR
}

/// w ##class(web.DHCRisQueryRetinue).GetUser("2")
ClassMethod GetUser(InRetinueId As %String) As %String
{
	 s (GetUserDR,User)=""
	 q:(InRetinueId="") GetRetUser 
	 i InRetinueId'="" s GetUserDR=$p($g(^DHCRBCOutWorkerSet(InRetinueId)),"^",1)
	 i GetUserDR'="" s User=$p($g(^SSU("SSUSR",GetUserDR)),"^",2)
	 q User
}

/// w ##class(web.DHCRisQueryRetinue).RequestModifyUser("13")
ClassMethod RequestModifyUser(UserDR) As %String
{
	s User=$p($g(^SSU("SSUSR",UserDR)),"^",2)
	q User
}

/// w ##class(web.DHCRisQueryRetinue).SaveModify("20017||3870@20017||3879","687","13")
ClassMethod SaveModify(oeorditemdr As %String, OperateUser As %String, User As %String) As %String
{
	s SQLCODE="-100"
	q:(oeorditemdr="") SQLCODE
	q:(OperateUser="") SQLCODE
	q:(User="") SQLCODE
	
	s OperateDate=+$h
    s OperateTime=$p($h,",",2)
    s Count=0
    s Count=$l(oeorditemdr,"@")
    for i=1:1:Count
    {
		s Rowid=""
		s peroeorditemdr=$p(oeorditemdr,"@",i)
		&Sql(select DMR_RowID into :Rowid from DHCRB_ModifyRetinue where DMR_OEordItem_DR=:peroeorditemdr)
		if Rowid="" d
		.&sql(Insert into DHCRB_ModifyRetinue(DMR_OEordItem_DR,DMR_ModifyUser_DR,DMR_RetinueUser_DR,DMR_Operate_Date,DMR_Operate_Time)
		                   values(:peroeorditemdr,:OperateUser,:User,:OperateDate,:OperateTime))
		                   
		e  d
		.&sql(UpDate DHCRB_ModifyRetinue(DMR_ModifyUser_DR,DMR_RetinueUser_DR,DMR_Operate_Date,DMR_Operate_Time)
		                   values(:OperateUser,:User,:OperateDate,:OperateTime) where DMR_RowID=:Rowid)   
    }                  
	                   
	q SQLCODE
}

/// w ##class(web.DHCRisQueryRetinue).GetSelPrintData("20017||3870")
ClassMethod GetSelPrintData(oeorditemdr As %String) As %String
{
	s (Info,paadmdr,OrderID,ItemID,PInfo,BInfo,strOrderName)=""
	s (RegNo,Name,strDOB,strAge,SexDesc,wardname,bedname,RecLocdr,RecLocDesc)=""
	s (AppointDate,AppointTime,ResDesc,Address,Memo,RetinueUser,WardDr,RetinueID,BookedNo)=""
	q:(oeorditemdr="") Info

	s OrderID=$p(oeorditemdr,"||",1)
	s ItemID=$p(oeorditemdr,"||",2)
	s paadmdr=$p(^OEORD(OrderID),"^",1)
	
	i (paadmdr'="")
	{
	   s WardDr=$p($g(^PAADM(paadmdr)),"^",70)
	   i WardDr'="" s RetinueID=..GetRetinuebyWardDR(WardDr,oeorditemdr)
	   i RetinueID'="" s RetinueUser=..GetUser(RetinueID)
	   
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
	} 
	
	s RecLocdr=$p(^OEORD(OrderID,"I",ItemID,3),"^",6)
	if RecLocdr'="" d
	.s RecLocDesc=$p(^CTLOC(RecLocdr),"^",2)
	.i $f(RecLocDesc,"-")>0 d
	..s RecLocDesc=$p(RecLocDesc,"-",2)
	.s Address=$p($g(^CTLOC(RecLocdr),"ADDR"),"^",16)
	.;w !,"Address="_Address
	
    s ArcItemId=$p($g(^OEORD(OrderID,"I",ItemID,1)),"^",2)
    s strOrderName=$p($g(^ARCIM($p(ArcItemId,"||",1),$p(ArcItemId,"||",2),1)),"^",2)  
    
	i ((ArcItemId'="")&(Address="")) 
	{   
	    s DIBPRowid=""
		s DIBPRowid=$o(^DHCRBCItemBookProperTypei(ArcItemId,DIBPRowid))
		i DIBPRowid'="" s Address=$p($g(^DHCRBCItemBookProperty(DIBPRowid)),"^",5)
		;w !,"Address1="_Address
	}
    
	s BInfo=##class(web.DHCRisWardQueryZGYD).GetBKInfo(oeorditemdr)
	i BInfo'="" d
	.s AppointDate=$p($g(BInfo),"^",1)
	.s AppointTime=$p($g(BInfo),"^",2)
	.s ResDesc=$p($g(BInfo),"^",3)
	.s Address=$p($g(BInfo),"^",4)
	.s BookedNo=$p($g(BInfo),"^",5)
	s Memo=##class(web.DHCRisWardQueryZGYD).RequestMemo(oeorditemdr)
	
	s Info=RecLocdr_"^"_RegNo_"^"_Name_"^"_SexDesc_"^"_strAge_"^"_wardname_"^"_bedname_"^"_RecLocDesc_"^"_AppointDate_"^"_AppointTime_"^"_ResDesc_"^"_Address_"^"_RetinueUser_"^"_strOrderName_"^"_Memo_"^"_BookedNo
	
	q Info
}

/// w ##class(web.DHCRisQueryRetinue).IsExit("20017||3870","1")
ClassMethod IsExit(Inoeorditemdr As %String, InUserID As %String) As %String
{
	s GetOrderID="",Getpaadmdr="",GetAdmLocDR="",DispatcherDR=""
	s Flag="N"
	s GetOrderID=$p(Inoeorditemdr,"||",1)
	s Getpaadmdr=$p(^OEORD(GetOrderID),"^",1)
	q:(Getpaadmdr="") Flag
	s GetAdmLocDR=$p($g(^PAADM(Getpaadmdr)),"^",4)
	q:(InUserID="") Flag
	s DispatcherDR=..GetDispatcherDR(InUserID)
	q:(DispatcherDR="") Flag
	s Rowid=""
	f   s Rowid=$o(^DHCRBCYardAdmLocSeti("Yard-AdmLoc",DispatcherDR,Rowid)) q:(Rowid="")  d
	.q:(Flag="Y")
	.s (AdmLocRowid)=""
	.s AdmLocRowid=$p($g(^DHCRBCYardAdmLocSet(Rowid)),"^",2)
	.i GetAdmLocDR=AdmLocRowid s Flag="Y"
	
	q Flag
}

/// 获取RIS3.0检查状态
/// do ##class(web.DHCRisQueryRetinue).GetRisStatusList()
ClassMethod GetRisStatusList() As %String
{
	s ret="S"_$C(1)_"全部"_"^"_"A"_$C(1)_"正在申请"_"^"_"I"_$C(1)_"登记"_"^"_"B"_$C(1)_"预约"
	s ret=ret_"^"_"E"_$C(1)_"正在检查"_"^"_"O"_$C(1)_"检查结束"
	q ret
}

ClassMethod QuerybyItemDate(ward, ArcItemRowid, InRegNo, RecLocId, IsPrint, InUserId, startdate, enddate, RetinueUserID, InAdmLocID, RisStatusCode, BKDesc)
{
	k ^DHCRISYARDMANTMEP("TEMPITEMROWID")
	
	s QueryType=""
	s CountInfo=""
	s CountInfo=..GetSetExeLoc(InUserId)
	i (CountInfo="")
	{
		Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	}
	s Count=$l(CountInfo,"@")
    
	for date=startdate:1:enddate
    {
	     ;RB_ApptSchedule
         
            for i=1:1:Count  d
	         .s perInLocID=$p(CountInfo,"@",i)
	         .;w !,"perInLocID="_perInLocID
	         .s OrderRowid=0  f  s OrderRowid=$o(^OEORDi(0,"ItemDate",date,OrderRowid)) q:(OrderRowid="")  d
             ..s itemsub=0  f  s itemsub=$o(^OEORDi(0,"ItemDate",date,OrderRowid,itemsub)) q:(itemsub="")  d
             ...s Oeorditemdr=OrderRowid_"||"_itemsub
             ...q:(Oeorditemdr="")
             ...s RecLocdr=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)
			 ...q:(RecLocdr'=perInLocID) ;按关注接受科室过滤
			 ...s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
			 ...q:(arcimid="")
			 ...s ServerMaterial=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7)),"^",6)
             ...q:(ServerMaterial'="Service")&(ServerMaterial'="S")
	         ...q:($d(^DHCRISYARDMANTMEP("TEMPITEMROWID",Oeorditemdr)))
             ...s ^DHCRISYARDMANTMEP("TEMPITEMROWID",Oeorditemdr)=""
			 ...Do OutRowItemDate

   }

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
    
OutRowItemDate
             s GetPatientStatusCode="A"
			 s ordrowid=$p($g(Oeorditemdr),"||",1)
			 s orditemchildsub=$p($g(Oeorditemdr),"||",2)
			 ;s arcimid=$p($g(^OEORD(ordrowid,"I",orditemchildsub,1)),"^",2)
			 ;q:(arcimid="")
			 ;s ServerMaterial=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7)),"^",6)
             ;q:(ServerMaterial'="S")
			 s RecLocdr=$p($g(^OEORD(ordrowid,"I",orditemchildsub,3)),"^",6)
			 ;q:(RecLocdr'=perInLocID) ;按关注接受科室过滤
	         q:(RecLocId'="")&(RecLocId'=RecLocdr)
			 s paadmdr=$p(^OEORD(ordrowid),"^",1)
			 q:(paadmdr="")
			 s papatmasmdr=$p(^PAADM(paadmdr),"^",1)  
			 s GetAdmLocdr=$p(^PAADM(paadmdr),"^",4)
			 q:(InAdmLocID'="")&(InAdmLocID'=GetAdmLocdr)
			 ;get patient diagnose 
			 s ret=""
			 s ret=..IsExit(Oeorditemdr,InUserId)
			 q:(ret="N")
			 s IsRegFlag="",IsBKFlag=""
			 s strRppDate="",strRppTime="",GetResDesc="",BookedNo="",BKInfo=""
			 s IsBKFlag=##class(web.DHCRisWardQueryZGYD).GetBKFlag(Oeorditemdr)
			 i IsBKFlag="Y" d
			 .s GetPatientStatusCode="B"
			 .s BKInfo=##class(web.DHCRisWardQueryZGYD).GetBKInfo(Oeorditemdr)
			 .s strRppDate=$p($g(BKInfo),"^",1)
			 .s strRppTime=$p($g(BKInfo),"^",2)
			 .s GetResDesc=$p($g(BKInfo),"^",3)
             .s BookedNo=$p($g(BKInfo),"^",5)
			 s IsRegFlag=##class(web.DHCRisWardQueryZGYD).GetRegFlag(Oeorditemdr)
			 i IsRegFlag="Y" s GetPatientStatusCode="I"
			 ;q:(IsRegFlag="Y")
			 s MeothodDesc=""
             s MeothodDesc=##class(web.DHCRisWardQueryZGYD).RequestBookType(arcimid)
             q:((MeothodDesc="不需预约")&(MeothodDesc="")&(BKDesc=""))
             q:(BKDesc'="")&(BKDesc'=MeothodDesc)
             s IsSend="",Memo=""
             s IsSend=##class(web.DHCRisWardQueryZGYD).IsSendAppBill(Oeorditemdr)
	         q:(ArcItemRowid'="")&(ArcItemRowid'=arcimid)
			 s PrintFalg=""
	         s PrintFalg=$g(^DHCRISRETINUEPRINTDATA(Oeorditemdr))
	         q:(IsPrint="N")&(PrintFalg="Y")
	         s IsMemo=""
             s IsMemo=##class(web.DHCRisCommFunctionEx).ExistMemo(Oeorditemdr)
             i IsMemo="Y" s Memo="浏览"
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
		     s GetAdmLoc=$p(PatInfo,"^",40)
		     q:(ward'="")&(ward'=GetWardDR)
		     s GetRetinueRowid=""
		     ;w !,"GetWardDR="_GetWardDR
		     ;w !,"Oeorditemdr="_Oeorditemdr
		     i GetWardDR'="" s GetRetinueRowid=..GetRetinuebyWardDR(GetWardDR,Oeorditemdr)
		     q:(RetinueUserID'="")&(RetinueUserID'=GetRetinueRowid)
		     s (GetRetUser)=""
		     i GetRetinueRowid'="" s GetRetUser=..GetUser(GetRetinueRowid)
		     s Getroomdesc=$p(PatInfo,"^",15)
		     s GetSexDr=$p(PatInfo,"^",13)
		     s PapatmasDR=$p(PatInfo,"^",24)
		     s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(ordrowid,orditemchildsub)
		     ;s GetPatientStatusCode="A"
	         s GetstrOrderName=$p(ordInfo,"^",1)
	         ;q:(InIsBedOrd="N")&(GetstrOrderName["床旁")
	         ;q:(InIsBedOrd="Y")&(GetstrOrderName'["床旁")
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
	         ;q:(GetServerMaterial'="S")
	         s GetRecLocDR=$p(ordInfo,"^",19)
			 ;s GetPatientStatusCode="B"
			 s GetReportStatusCode="N"  ;未写报告
			 s GetstrRegDate="",GetstrRegTime="",GetRptDocName="",GetVerifyDocName="",GetStudyNo="",GetIndex="",GetEQDesc=""
			 s bOut="N",HaveImage=""
			 s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfo(Oeorditemdr)
	         s GetStudyNo=$p(RegInfo,"^",1)
	         i GetStudyNo'="" s GetPatientStatusCode="I"
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
	         ..q:((RisStatusCode'="")&(RisStatusCode'="S")&(RisStatusCode'=GetPatientStatusCode))
	         ..s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
	         ..s bOut="Y"
	         ..set Data=$lb(GetRegNo,GetName,GetSexDesc,GetBedNo,GetstrOrderName,GetstrDate,GetstrTime,GetRecLocName,GetReportStatus,strRppDate,strRppTime,GetResDesc,GetstrRegDate,GetstrRegTime,GetStudyNo,GetRptDocName,GetVerifyDocName,GetPatientStatus,GetWardName,GetstrAge,PrintFalg,Oeorditemdr,$g(MeothodDesc),$g(GetRecLocDR),$g(IsSend),$g(Memo),GetRetUser,$g(GetAdmLoc),$g(BookedNo))
   	         ..Set ^CacheTemp(repid,ind)=Data
	         ..Set ind=ind+1
 	         ..quit
	         i bOut="N" d
	         .s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
	         .q:((RisStatusCode'="")&(RisStatusCode'="S")&(RisStatusCode'=GetPatientStatusCode))
	         .s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
	         .s bOut="Y"
	         .set Data=$lb(GetRegNo,GetName,GetSexDesc,GetBedNo,GetstrOrderName,GetstrDate,GetstrTime,GetRecLocName,GetReportStatus,strRppDate,strRppTime,GetResDesc,GetstrRegDate,GetstrRegTime,GetStudyNo,GetRptDocName,GetVerifyDocName,GetPatientStatus,GetWardName,GetstrAge,PrintFalg,Oeorditemdr,$g(MeothodDesc),$g(GetRecLocDR),$g(IsSend),$g(Memo),GetRetUser,$g(GetAdmLoc),$g(BookedNo))
   	         .Set ^CacheTemp(repid,ind)=Data
	         .Set ind=ind+1
 	         .quit
}

}
