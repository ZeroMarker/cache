Import SQLUser

/// //, websys.Abstract)
Class web.DHCEkgGetBookList Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 195;

/// d ##class(%ResultSet).RunQuery("web.DHCEkgGetBookList","QueryEkgExamItem",^TMPRIS11,^TMPRIS12,^TMPRIS13,^TMPRIS14)
/// d ##class(%ResultSet).RunQuery("web.DHCEkgGetBookList","QueryEkgExamItem","^40243515^^626^^^^苏香丽^^^^^false^^^^^^false^false^N^N^^^^^^^21/04/2013^23/04/2013^N^Y^Y","2/04/2013","23/04/2013","1")
/// BookedType ="" 或者是 0， 是用MEDTRAK 的预约方式 ， 1： 新开发的预约平台的预约方式
Query QueryEkgExamItem(strCondition As %String, StdDate As %String, enddate As %String, BookedType As %String = "") As %Query(ROWSPEC = "Tregno:%String,TName:%String,TSex:%String,TAge:%String,TDob:%String,TDiagonse:%String,TStudyNo:%String,TstrOrderName:%String,TDoctor:%String,TstrAccessionNum:%String,TstrDate:%String,TstrTime:%String,TAppointDate:%String,TAppointstTime:%String,TBookedDuration:%String,TstrRegDate:%String,TstrRegTime:%String,TReportDoc:%String,TReportVerifyDoc:%String,TPatientStatus:%String,Tpaadmdr:%String,TOeorditemdr:%String,TLocName:%String,Tprice:%String,TOEORIItemStatus:%String,TBillStatus:%String,TPatientType:%String,TNum:%String,TPerprice:%String,TIndex:%String,TRegEQ:%String,TBookedRes:%String,Tifbed:%String,TReportStatus:%String,TMainDoc:%String,TAssDoc:%String,TRegRoom:%String,TEQroupDesc:%String,TWardDesc:%String,TNo:%String,TRequired:%String,THopeTime:%String,TOrdStatus:%String,TPatMasDR:%String,TBodyPart:%String,TWeight:%String,TTelNo:%String,TIPNO:%String,TSentFilm:%String,TBedCode:%String,TSendPrint:%String,HasImage:%String,RecLocId:%String,RecLoc:%String,AutoInputFee:%String,EndInputFee:%String,Detail:%String,RejectAppReason:%String,BilledDesc:%String,PinYin:%String,ToDayOeItem:%String,CostRecords:%String,AppDate:%String,BookedUser:%String,PaymentDoc:%String,PlatStatus:%String,TEpissubtype:%String")
{
}

ClassMethod QueryEkgExamItemExecute(ByRef qHandle As %Binary, strCondition As %String, StdDate As %String, enddate As %String, BookedType As %String) As %Status
{
   s ^TMPRIS11=strCondition
   s ^TMPRIS12=StdDate
   s ^TMPRIS13=enddate
   s ^TMPRIS14=BookedType
   k ^DHCRisTmpPrintData123
   //s UserID=%session.Get("LOGON.USERID")
   //s UserID="04289"
   //i $g(^DHCRisLookupCondition(UserID))'="" d
   //.s strCondition=^DHCRisLookupCondition(UserID)
   //.s StdDate=$p(^DHCRisLookupCondition(UserID),"^",29)
   //.s StdDate=$zdh(StdDate,4)
   //.s enddate=$p(^DHCRisLookupCondition(UserID),"^",30)
   //.s enddate=$zdh(enddate,4)
   
   set:StdDate["-" StdDate=$zdh(StdDate, 3) 
   set:enddate["-" enddate=$zdh(enddate, 3)
   
   set:StdDate["/" StdDate=$zdh(StdDate, 4)
   set:enddate["/" enddate=$zdh(enddate, 4)
   
  
  b ;1
  
   s Intype=$p(strCondition,"^",1)
   s Intype=$p(Intype,$c(0))
   ;s Intype=##class(web.DHCRisCommFunction).GetPaadmTypeCode(IntypeDesc)
   s InRegNo=$p(strCondition,"^",2)
   s InRegNo=$p(InRegNo,$c(0))
   s InStudyNo=$p(strCondition,"^",3)
   s InStudyNo=$p(InStudyNo,$c(0))
   
   s InLocDr=$p(strCondition,"^",4)
   s InLocDr=$p(InLocDr,$c(0))
  
  
   //if InLocDr="" s InLocDr=##class(web.DHCRisCommFunction).GetSession("SelLocID")
   //if InLocDr="" s InLocDr=%session.Get("LOGON.CTLOCID")
  
   s InStdDate=StdDate
   s Inenddate=enddate
   
   s InStatusCode=$p(strCondition,"^",5)
   s InStatusCode=$p(InStatusCode,$c(0))
   s InReportDoc=$p(strCondition,"^",6)
   s InReportDoc=$p(InReportDoc,$c(0))
   s InVerifyDoc=$p(strCondition,"^",7)
   s InVerifyDoc=$p(InVerifyDoc,$c(0))
   s InName=$p(strCondition,"^",8)
   s InName=$p(InName,$c(0))
   
   s InResourceID=$p(strCondition,"^",9)
   s InResourceID=$p(InResourceID,$c(0))
   
   s InOrderByIndex=""
   
   s InRegEQ=$p(strCondition,"^",10)
   s InRegEQ=$p(InRegEQ,$c(0))
   s InRoomDR=$p(strCondition,"^",11)
   s InRoomDR=$p(InRoomDR,$c(0))
      
   
   s InPatientNo=$p(strCondition,"^",12)
   s InPatientNo=$p(InPatientNo,$c(0))
   
   s InIsFindDate=$p(strCondition,"^",13)
   s InIsFindDate=$p(InIsFindDate,$c(0))

   
   s InRequireAppoint=$p(strCondition,"^",14)
   s InRequireAppoint=$p($g(InRequireAppoint),$c(0))   
   
   s InIsBedOrd=$p(strCondition,"^",15)
   s InIsBedOrd=$p($g(InIsBedOrd),$c(0))

   s InAppLocDR=""
   s InAppLocDR=$p($g(InAppLocDR),$c(0))

   s InEQGroupDR=$p(strCondition,"^",16)   
   s InEQGroupDR=$p($g(InEQGroupDR),$c(0))
   
   s InWardDR="" ;$p(strCondition,"^",18)
   s InWardDR="" ;$p($g(InWardDR),$c(0))
   
   s InNO=$p(strCondition,"^",18)
   s InNO=$p($g(InNO),$c(0))      //编号
   
   s IsFilmSet=$p(strCondition,"^",19)
   
   s IsNotLoc=$p(strCondition,"^",21)        ;是否不显示本科室的病人 Y,N
   s QueryByRegDate=$p(strCondition,"^",22)  ;通过登记时间查询
   s IsUItem=$p($g(strCondition),"^",31)     ;是否查询作废遗嘱
   s IsCostRecords=$p($g(strCondition),"^",32)    ;是否查询已补费医嘱
   s IsBilled=$p($g(strCondition),"^",33)
   
   
     
   
   Set repid=$I(^CacheTemp)
   If $g(ind)="" Set ind=1
      
   
   
   if (InRegNo="")&(InStudyNo="")&(InName="")&(InNO="")  
   {
	   if (QueryByRegDate="Y")
	   {
		   s return=..QueryByRegDate(Intype, InLocDr, InStdDate, Inenddate, InStatusCode, InReportDoc, InVerifyDoc, InResourceID, InRoomDR, InRegEQ, InRequireAppoint, InIsBedOrd, InRegNo, InStudyNo, InName, InPatientNo, InAppLocDR, InEQGroupDR, InWardDR, InNO, IsFilmSet, IsNotLoc,BookedType,IsUItem,IsCostRecords)
	   }
	   else
	   {
		   s return=..QueryByLoc(Intype,InLocDr,InStdDate,Inenddate,InStatusCode,InReportDoc, InVerifyDoc,InResourceID,InRoomDR,InRegEQ,InRequireAppoint,InIsBedOrd,InRegNo,InStudyNo,InName,InPatientNo,InAppLocDR,InEQGroupDR,InWardDR,InNO,IsFilmSet,IsNotLoc,BookedType,IsUItem,IsCostRecords,IsBilled)
	   }
   	   Quit $$$OK
   }
   if (InStudyNo'="")
   {
	 s return=..QueryByStudyNo(InLocDr, InRoomDR, InRegEQ, Intype, InRegNo, InStudyNo, InName, "", "", InStatusCode, "", InStdDate, Inenddate, "", "", InLocDr, "", "", InReportDoc, InVerifyDoc, "", "", "","", InWardDR, InEQGroupDR, InNO,InIsFindDate,BookedType,IsUItem,IsCostRecords)
   	 Quit $$$OK
   }
   if (InRegNo'="")
   {
	  s return=..QueryByRegNo(InLocDr, InRoomDR, InRegEQ, Intype, InRegNo, InStudyNo, InName, "", "", InStatusCode, "", InStdDate, Inenddate, "", "", InLocDr, "", "", InReportDoc, InVerifyDoc, "", "", "", "",InWardDR, InEQGroupDR, InNO,InIsFindDate,BookedType,IsUItem,IsCostRecords)
      Quit $$$OK
   }
   if (InName'="")
   {
	    s return=..QueryByName(InLocDr, InRoomDR, InRegEQ, Intype, InRegNo, InStudyNo, InName, "", "", InStatusCode, "", InStdDate, Inenddate, "", "", InLocDr, "", "", InReportDoc, InVerifyDoc, "", "", "","", InWardDR, InEQGroupDR, InNO,InIsFindDate,BookedType,IsUItem,IsCostRecords)
      Quit $$$OK
   }
   if (InNO'="")
   {
	  s return=..QueryByOldNo(InLocDr, InRoomDR, InRegEQ, Intype, InRegNo, InStudyNo, InName, "", "", InStatusCode, "", InStdDate, Inenddate, "", "", InLocDr, "", "", InReportDoc, InVerifyDoc, "", "", "", "",InWardDR, InEQGroupDR, InNO,InIsFindDate,BookedType,IsUItem,IsCostRecords)
      Quit $$$OK
   }
}

ClassMethod QueryEkgExamItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEkgExamItemExecute ]
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

ClassMethod QueryEkgExamItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEkgExamItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

//通过登记日期查询

//w ##calss(web.DHCEkgGetBookList).QueryByLoc("","343",^TMPRIS12,^TMPRIS13,"","","","","","","","","","","","","","","","","","","","","","")

ClassMethod QueryByLoc(Intype As %String, InLocDr As %String, InStdDate As %String, Inenddate As %String, InStatusCode As %String, InReportDoc As %String, InVerifyDOc As %String, InResourceID As %String, InRoomDR As %String, InRegEQDR As %String, InRequireAppoint As %String, InIsBedOrd As %String, InRegNo As %String, InStudyNo As %String, InName As %String, InPatientNo As %String, InAppLocDR As %String, InEQGroupDR As %String, InWardDR As %String, InNO As %String, IsFilmSet As %String, IsNotLoc As %String, BookedType As %String, IsUItem As %String, IsCostRecords As %String, IsBilled As %String)
{
	
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s n=0
    s MainLocID=InLocDr
    s LocArray=..GetLocArray(MainLocID)
    s Count=$l(LocArray,"@")
	
	f i=1:1:Count d
	.s InLocDr=$p(LocArray,"@",i)
	.q:(InLocDr="")
    .f date=InStdDate:1:Inenddate d
    ..i ((InRequireAppoint="Y")!(InRequireAppoint="")) d
    ...s count=..QueryBookedItem(Intype,InStatusCode,"",date,InLocDr,InResourceID,InReportDoc,InVerifyDOc,InIsBedOrd,InRoomDR,InRegEQDR, InRequireAppoint, InRegNo, InStudyNo,InName,InPatientNo,InAppLocDR,InEQGroupDR,InWardDR,InNO,IsFilmSet,BookedType,IsUItem,IsCostRecords,IsBilled)  ;查询到指定的日期的预约医嘱
    ..s PriorityDR=0 f  s PriorityDR=$o(^OEORDi(0,"LocStDtPr",InLocDr,PriorityDR)) q:PriorityDR=""  d
    ...s OrderRowid=0 f  s OrderRowid=$o(^OEORDi(0,"LocStDtPr",InLocDr,PriorityDR,date,OrderRowid)) q:OrderRowid=""  d
    ....s itemsub=0 f  s itemsub=$o(^OEORDi(0,"LocStDtPr",InLocDr,PriorityDR,date,OrderRowid,itemsub)) q:itemsub=""  d
	.....s oeorditemdr=OrderRowid_"||"_itemsub
	.....;w !,"a_"_oeorditemdr
	.....q:itemsub[","
	.....s Detail="明细",RejectAppReason="",ToDayOeItem="",CostRecords="",BookedUser="",PaymentDoc=""
	.....s GetIDCDesc=""
	.....s ExterFalg=""
	.....s paadmdr=$p(^OEORD(OrderRowid),"^",1) 
	.....s GetIDCDesc=##class(web.DHCRisCommFunctionEx).GetDiagnose(paadmdr)
    .....s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
    .....s GetRegNo=$p(PatInfo,"^",1)
    .....s GetName=$p(PatInfo,"^",2)
    .....s GetstrDOB=$p(PatInfo,"^",3)
    .....s GetstrAge=$p(PatInfo,"^",4)
 	.....s GetSexDesc=$p(PatInfo,"^",5)
    .....s Getpatienttype=$p(PatInfo,"^",6)
    .....s Gettypedesc=$p(PatInfo,"^",7)
    .....s GetLocName=$p(PatInfo,"^",8)
    .....s GetIPNo=$p(PatInfo,"^",9)
    .....s GetWardName=$p(PatInfo,"^",10)
    .....s GetBedNo=$p(PatInfo,"^",11)
    .....s GetLocdr=$p(PatInfo,"^",12)
    .....s GetWardDr=$p(PatInfo,"^",14)
    .....s PapatmasDR=$p(PatInfo,"^",24)
    .....s Weight=$p(PatInfo,"^",21)
	.....s TelNo=$p(PatInfo,"^",19)
	.....s PinYin=$p(PatInfo,"^",38)
	.....s Epissubtype=$p($g(PatInfo),"^",41)
	.....q:(InWardDR'="")&(GetWardDr'=InWardDR)
    .....q:(InPatientNo'="")&(InPatientNo'=GetIPNo)
    .....q:(InAppLocDR'="")&(GetLocdr'=InAppLocDR)
    .....q:(Intype'="")&(Intype'=Getpatienttype)
    .....q:(IsNotLoc="Y")&(GetLocdr=InLocDr)     ;不显示当前科室的病人，有写科室是执行科室又是住院科室）
    .....s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(OrderRowid,itemsub)
    .....s GetstrOrderName=$p(ordInfo,"^",1)
    .....s GetstrDate=$p(ordInfo,"^",2)
    .....s GetstrTime=$p(ordInfo,"^",3)
    .....s Getrequestdoc=$p(ordInfo,"^",4)
    .....s GetstrAccessionNum=$p(ordInfo,"^",5)
    .....s GetSGroupDesc=$p(ordInfo,"^",6)
    .....s GetsubCatDesc=$p(ordInfo,"^",7)
    .....s GetCatDesc=$p(ordInfo,"^",8)
    .....s Getifbed=$p(ordInfo,"^",9)
    .....s Getprice=$p(ordInfo,"^",10)
    .....s GetNum=$p(ordInfo,"^",11)
    .....s GetTotalPrice=$p(ordInfo,"^",12)
    .....s Getbilled=$p(ordInfo,"^",13)
    .....s GetItemStatusCode=$p(ordInfo,"^",14)
    .....q:((GetItemStatusCode="U")&(IsUItem'="Y"))!(GetItemStatusCode="D")!(GetItemStatusCode="I")
    .....;q:(IsBilled'="Y")&(Getbilled="P")  ;xzy-2013-4-27 将已收费的显示出来
    .....s GetordDate=$p(ordInfo,"^",15)
    .....s GetordTime=$p(ordInfo,"^",16)
    .....s GetItemStatusCode=$p(ordInfo,"^",17)
    .....s GetServerMaterial=$p(ordInfo,"^",18)
    .....s AutoInputFee=$p(ordInfo,"^",25) ;"需要另划价标志"
    .....s EndInputFee=$p(ordInfo,"^",26)  ;"已另划价标识"
    .....s BilledDesc=$p(ordInfo,"^",27)
    .....s BodyDesc=$p(ordInfo,"^",29)
    .....s BookedUser=$p(ordInfo,"^",31)    ;预约操作员
    .....s GetPaymentDoc=$p(ordInfo,"^",33) ;补录操作员
    .....s GetPlatStatus=$p($g(ordInfo),"^",34) ;平台状态 
    .....s CheckEntryFlag=""
    .....s CheckEntryFlag=$p(ordInfo,"^",30) 
    .....q:(IsCostRecords'="Y")&(CheckEntryFlag="Y")
    .....i CheckEntryFlag="Y" s CostRecords="已补录" s PaymentDoc=GetPaymentDoc
    .....s ResultFlag=$p(ordInfo,"^",20)    ;医嘱的结果状态--------------安贞医院用以前MEDTRAK 的结果处理，处理的的报告，在技师工作站中不在显示
    .....q:ResultFlag="V"
    .....s strXDate="",AppDate="",AppTime=""
    .....s AppRowid=$o(^DHCRBAppi("OrdRowid",oeorditemdr,0)) 
    .....i AppRowid'="" d
    ......s XDate=$p(^DHCRBApp("Bill",AppRowid),"^",10)
    ......s strXDate=$zd(XDate,3)
    ......s AppDate=$p(^DHCRBApp("Bill",AppRowid),"^",1)
    ......i AppDate'="" s AppDate=$zd(AppDate,3)
    ......s AppTime=$p(^DHCRBApp("Bill",AppRowid),"^",8)
    ......i AppTime'="" s AppTime=$zt(AppTime)
    ......s AppDate=AppDate_" "_AppTime
    ......q:(InRequireAppoint="N")&(GetSGroupDesc'="无需预约")&('(GetstrOrderName["床旁"))
    ......q:(InRequireAppoint="Y")&((GetSGroupDesc="无需预约")!(GetstrOrderName["床旁"))
    .....q:(InIsBedOrd="Y")&('(GetstrOrderName["床旁"))  ;检索床旁医嘱，不是床旁医嘱
    .....i (GetstrOrderName["床旁") S Getifbed="Y"
    .....s SystemParamInfo=##class(web.DHCRisCommFunction).GetSystemParam()
    .....s SendApptoLoc=$p(SystemParamInfo,"^",3)  ;没写申请单,是否发检查医嘱到检查科室
    .....s SendInPtoLoc=$p(SystemParamInfo,"^",4)  ;没收费是否把住院病人的检查项目发送到检查科室  
    .....s SendOutPtoLoc=$p(SystemParamInfo,"^",5) ;没收费是否把门诊检查项目发送到检查科室
    .....s SendEmPtoLoc=$p(SystemParamInfo,"^",6)   ;没收费是否把急诊病人检查项目发送到检查科室
    .....s QueryonlyExam=$p(SystemParamInfo,"^",9)  ;是否只查询检查项目
    .....s SendHPtoLoc=$p(SystemParamInfo,"^",10)   ;没收费是否把体检病人的检查项目发送检查科室
    .....q:(SendInPtoLoc="N")&(Getbilled'="P")&(Getpatienttype="I")    ;住院病人没有付费的退出
    .....q:(SendOutPtoLoc="N")&(Getbilled'="P")&(Getpatienttype="O")   ;门诊病人没有付费退出
    .....q:(SendEmPtoLoc="N")&(Getbilled'="P")&(Getpatienttype="E")   ;急症病人没付费退出
    .....q:(SendHPtoLoc="N")&(Getbilled'="P")&(Getpatienttype="H")   ;体检病人没付费退出
    .....q:(QueryonlyExam="Y")&(GetServerMaterial'="S") ;不是检查项目的则退出
    .....s GetPatientStatusCode="A"  ;申请
    .....s GetReportStatusCode="N"  ;未写报告
    .....s Getapprowid="",GetRoomDr=""
    .....s GetRptDocName="",GetVerifyDocName="",GetStudyNo="",GetstrRegDate="",GetstrRegTime="",GetIndex="",GetEQDesc="",GetMainDoc="",GetAssDoc=""
    .....s GetEQDr="",GetRoomDesc="",GetAppointDate="",GetAppointstTime="",GetBookedDuration="",GetResDesc="",GetEQGroupDesc="",GetEQGroupDR="",NO="",HaveImage="" ;BodyDesc=""
    .....s bOut="N" ,Getapprowid="",BookedRowid="" ;是否已经输出
    .....s ExterFalg=..IsExternalBooked(oeorditemdr)
    .....i ExterFalg="Y" d
    ......s GetPatientStatusCode="B"
    ......s GetAppointDate=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",2)
    ......s GetAppointstTime=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",3)
    .....; 对于住院病人，去判断申请单
    .....s AllowSend="Y"
    .....i (SendApptoLoc="N")&(Getpatienttype="I")  d
    ......s AppRowid=$o(^DHCRBAppi("OrdRowid",oeorditemdr,0)) 
    ......i AppRowid'="" d
    .......s AllowSend="Y"
    ......else  d
    .......s AllowSend="N"
    .....q:AllowSend="N"
    .....i ((GetItemStatusCode="V")!(GetItemStatusCode="E")) d
    ......s GetRejDR=$o(^DHCRBRejecti("OeordDR",oeorditemdr,0))
	......i GetRejDR'="" d
	.......s GetPatientStatusCode="RJ" ;拒绝申请
	.......s RejectAppReason="拒绝原因"
	......else  d
	.......i $g(^OEORD(OrderRowid,"I",itemsub,6))'="" s Getapprowid=$p($g(^OEORD(OrderRowid,"I",itemsub,6)),"^",5)  ; 已经预约RB_Appointment Rowid
	.......s BookedRowid=$o(^DHCRBCResSchduleDetaili(0,oeorditemdr,0))
	......q:((((Getapprowid'="")!(InResourceID'=""))&(Getapprowid'=$c(0)))&(BookedType=""))   ;预约过的医嘱则退出 
	......q:((BookedType="1")&(BookedRowid'=""))    ;预约过的医嘱则退出 
	......s FileSent=""
	......s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfo(oeorditemdr)
    ......s GetStudyNo=$p(RegInfo,"^",1)
    ......;w !,"GetStudyNo"_GetStudyNo
    ......i GetStudyNo'="" d
    .......s GetPatientStatusCode="I"
    .......s GetstrRegDate=$p(RegInfo,"^",2)
    .......s GetstrRegTime=$p(RegInfo,"^",3)
    .......s GetIndex=$p(RegInfo,"^",4)
    .......s GetEQDesc=$p(RegInfo,"^",5)
    .......s GetMainDoc=$p(RegInfo,"^",6)
    .......s GetAssDoc=$p(RegInfo,"^",7)
    .......s GetRoomDesc=$p(RegInfo,"^",8)
    .......s GetRoomDr=$p(RegInfo,"^",9)
    .......s GetEQDr=$p(RegInfo,"^",10)
    .......s GetEQGroupDesc=$p(RegInfo,"^",11)
    .......s GetEQGroupDR=$p(RegInfo,"^",12)
    .......s NO=$p(RegInfo,"^",13)
    .......;s BodyDesc=$p(RegInfo,"^",17)
    .......s FileSent=##class(web.DHCRisWorkBenchDoEx).GetFilmSendDesc(GetStudyNo)
    .......s ReportSend=##class(web.DHCRisWorkBenchDoEx).GetReportSend(GetStudyNo)
    .......s GetImgcount=0
    .......q:GetStudyNo=""
    .......s Imrowid=0 f  s Imrowid=$o(^DHCRBStudyi("StudyNo-Images",GetStudyNo,Imrowid)) q:Imrowid=""  d
    ........s GetPatientStatusCode="E"    ;正在检查
    ........s ExtName=$p($g(^DHCRBStudy(0,"StudyImages",Imrowid)),"^",2)
    ........i ((ExtName="avi")!(ExtName="dcm")!(ExtName="normal")!(ExtName="dsa"))  d
    .........s GetImgcount=GetImgcount+1
    .........s GetReportStatusCode="I"             ;图象已经采集
    .........s HaveImage="是"
    .......s sReportStuatCode="VS"
    .......;s Rptrowid=0  f  s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",GetStudyNo,Rptrowid)) q:Rptrowid=""  d
    .......s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",GetStudyNo,""),-1)
    .......i Rptrowid'="" d
    ........s GetRptID=$p(^DHCRBStudy("Report",Rptrowid),"^",2)
    ........s GetRptVersion=$p(^DHCRBStudy("Report",Rptrowid),"^",3)
    ........s GetRptStatusDR=$p(^DHCRBStudy("Report",Rptrowid),"^",4)
    ........i GetRptStatusDR'="" d
    .........s GetReportStatusCode=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",1)
    .........i sReportStuatCode[GetReportStatusCode d
    ..........s GetPatientStatusCode="O"
    .........e  d
    ..........s GetPatientStatusCode="E"
    ........s GetRptDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",8)
    ........i GetRptDocDR'="" s GetRptDocName=$p(^SSU("SSUSR",GetRptDocDR),"^",2)
    ........s GetRptDate=$p(^DHCRBStudy("Report",Rptrowid),"^",9)
    ........i GetRptDate'="" s GetRptDate=$zd(GetRptDate,3)
    ........s GetRptTime=$p(^DHCRBStudy("Report",Rptrowid),"^",10)
    ........i GetRptTime'="" s GetRptTime=$zt(GetRptTime,3)
    ........s GetVerifyDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",11)
    ........i GetVerifyDocDR'="" s GetVerifyDocName=$p(^SSU("SSUSR",GetVerifyDocDR),"^",2)
    ........s GetVerifyDate=$p(^DHCRBStudy("Report",Rptrowid),"^",12)
    ........i GetVerifyDate'="" s GetVerifyDate=$zd(GetVerifyDate,3) 
    ........s GetVerifyTime=$p(^DHCRBStudy("Report",Rptrowid),"^",13)
    ........i GetVerifyTime'="" s GetVerifyTime=$zt(GetVerifyTime,3)
    ........i ((IsFilmSet="false")!((IsFilmSet="true")&(FileSent="已发片")))&((InEQGroupDR="")!(GetEQGroupDR=InEQGroupDR))&((InRoomDR="")!(GetRoomDr=InRoomDR))&((InRegEQDR="")!(InRegEQDR=GetEQDr))&((InStatusCode="")!(InStatusCode[GetPatientStatusCode))&((InReportDoc="")!(InReportDoc=GetRptDocName))&((InVerifyDOc="")!(InVerifyDOc=GetVerifyDocName)) d 
   	.........s PatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
    .........s ReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
    .........s bOut="Y"
    .........Do OutRowL4

    ......i ((IsFilmSet="false")!((IsFilmSet="true")&(FileSent="已发片")))&((InEQGroupDR="")!(GetEQGroupDR=InEQGroupDR))&((InRoomDR="")!(GetRoomDr=InRoomDR))&((InRegEQDR="")!(InRegEQDR=GetEQDr))&((InStatusCode="")!(InStatusCode[GetPatientStatusCode))&((InReportDoc="")!(InReportDoc=GetRptDocName))&((InVerifyDOc="")!(InVerifyDOc=GetVerifyDocName))&(bOut="N") d 
  	.......s PatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
    .......s ReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
    .......s bOut="Y"
    .......Do OutRowL4

   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
OutRowL4
    s Required=""
    i ((GetSGroupDesc="无需预约")!(GetstrOrderName["床旁")) s Required="N"
    ;set Data=$lb(RegNo,Name,SexDesc,strDOB,strAge,IDCDesc,$g(StudyNo),strOrderName,requestdoc,strAccessionNum,strDate,strTime,$g(strAppointDate),$g(strAppointstTime),$g(strRegDate),$g(strRegTime),$g(getReportDoc),$g(getReportVerifyDoc),PatientStatus,paadmdr,oeorditemdr,$g(LocName),TotalPrice,PatientStatusCode,billed,$g(typedesc),Num,price,$g(Index),$g(EQDesc),$g(ResDesc),ifbed,ReportStatus,RoomDesc)
    //TWeight:%String,TTelNo:%String,TIPNO:%String")
    s RecLoc=""
    i InLocDr'="" d
    .s RecLoc=$p(^CTLOC(InLocDr),"^",2)
    set Data=$lb(GetRegNo,GetName,GetSexDesc,GetstrAge,GetstrDOB,GetIDCDesc,GetStudyNo,GetstrOrderName,Getrequestdoc,GetstrAccessionNum,GetstrDate,GetstrTime,GetAppointDate,GetAppointstTime,GetBookedDuration,GetstrRegDate,GetstrRegTime,GetReportDoc,GetReportVerifyDoc,PatientStatus,paadmdr,oeorditemdr,GetLocName,GetTotalPrice,GetPatientStatusCode,Getbilled,Gettypedesc,GetNum,Getprice,GetIndex,GetEQDesc,GetResDesc,Getifbed,ReportStatus,GetMainDoc,GetAssDoc,GetRoomDesc,GetEQGroupDesc,GetWardName,NO,Required,strXDate,GetItemStatusCode,PapatmasDR,BodyDesc,Weight,TelNo,GetIPNo,FileSent,GetBedNo,ReportSend,HaveImage,InLocDr,RecLoc,AutoInputFee,EndInputFee,Detail,RejectAppReason,BilledDesc,PinYin,ToDayOeItem,CostRecords,AppDate,BookedUser,PaymentDoc,GetPlatStatus,Epissubtype)
    s ^DHCRisTmpPrintData123(ind)=GetRegNo_"^"_GetName_"^"_GetSexDesc_"^"_GetstrAge_"^"_GetWardName_"^"_GetBedNo_"^"_GetStudyNo_"^"_$g(ReportSend)
   	s ^DHCRisTmpPrintData123=ind
   	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
 	quit
}

/// 读取医嘱的计费点设置值
/// 入参：医嘱id，sub
/// 出参：计费点设置值
/// 编写：殷云山 于2011.5.26 
ClassMethod GetBCCondition(OrderRowid, itemsub)
{
    n (OrderRowid, itemsub)
     s arcitemdr=$p($G(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
     s arccatedr=$p($G(^ARCIM(+arcitemdr,$p(arcitemdr,"||",2),1)),"^",10)
     s BCRowId=""
     s BCRowId=$o(^DHCTarC("BC",0,arccatedr,BCRowId))
     s BCCondition="OD"
     i BCRowId'="" s BCCondition=$p(^DHCTarC("BC",BCRowId),"^",2)
     q BCCondition
}

/// 读取医嘱的计费点设置值
/// 入参：医嘱id，sub
/// 出参：计费点设置值
/// 编写：殷云山 于2011.5.26 
ClassMethod Getnotes(OrderRowid, itemsub)
{
   n (OrderRowid, itemsub)
 	s notes=""
	f rnum=1:1:$G(^OEORD(OrderRowid,"I",itemsub,"DEP",0))  d
	.s notes=$G(^OEORD(OrderRowid,"I",itemsub,"DEP",rnum))
	q notes
}

ClassMethod QueryByStudyNo(ExmLocID, RoomDR, DeviceDR, PatTypeDR, InRegNo, StudyID, InName, InSexDR, Age, InStudyStatusCode, InRptStatusCode, StdDate, EndDate, OrderItemDR, StudyWay, InReqLocDR, RptDesc, RptDiagnose, RptDocDR, VerifyDocDR, IsYX, IsDXBL, IsKYBL, zyh, WardDR, InEQGroupDR, InOldNo, InIsFindDate, BookedType, IsUItem, IsCostRecords)
{
	s bOut="N"  ;是否已经输出
    s Regrowid=0 f  s Regrowid=$o(^DHCPACRegInfoi("StudyNo",StudyID,Regrowid)) q:Regrowid=""  d 
    .s GetPatientStatusCode="I"
    .s bOut="N"  ;是否已经输出
    .s Detail="明细",RejectAppReason="",ToDayOeItem="",CostRecords="",BookedUser="",PaymentDoc=""
    .s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfobyrowid(Regrowid)
    .s RecLocId=$p(^DHCPACRegInfo(Regrowid),"^",13)
    .s GetStudyNo=$p(RegInfo,"^",1)
    .s GetstrRegDate=$p(RegInfo,"^",2)
    .s GetstrRegTime=$p(RegInfo,"^",3)
    .s GetIndex=$p(RegInfo,"^",4)
    .s GetEQDesc=$p(RegInfo,"^",5) ; GetEQDesc
    .s GetMainDoc=$p(RegInfo,"^",6)
    .s GetAssDoc=$p(RegInfo,"^",7)
    .s Oeorditemdr=$p(RegInfo,"^",8)
    .s paadmdr=$p(RegInfo,"^",9)
    .s GetRoomDesc=$p(RegInfo,"^",10)
    .s GetRoomDr=$p(RegInfo,"^",12)
    .s GetEQDr=$p(RegInfo,"^",11)
    .s GetEQGroupDesc=$p(RegInfo,"^",13)
    .s GetEQGroupDR=$p(RegInfo,"^",14)
    .s GetOldNo=$p(RegInfo,"^",15)
    .;s BodyDesc=$p(RegInfo,"^",16)
    .s GetRegDate=$p(RegInfo,"^",16)
    .q:(InIsFindDate="true")&(GetRegDate<StdDate)!(GetRegDate>EndDate)
    .s FileSent=##class(web.DHCRisWorkBenchDoEx).GetFilmSendDesc(GetStudyNo)
    .s ReportSend=##class(web.DHCRisWorkBenchDoEx).GetReportSend(GetStudyNo)
    .s strXDate="",AppDate=""
    .s AppRowid=$o(^DHCRBAppi("OrdRowid",Oeorditemdr,0)) 
    .i AppRowid'="" d
    ..s XDate=$p( ^DHCRBApp("Bill",AppRowid),"^",10)
    ..s strXDate=$zd(XDate,3)
    ..s AppDate=$p(^DHCRBApp("Bill",AppRowid),"^",1)
    ..i AppDate'="" s AppDate=$zd(AppDate,3)
    ..s AppTime=$p(^DHCRBApp("Bill",AppRowid),"^",8)
    ..i AppTime'="" s AppTime=$zt(AppTime)
    ..s AppDate=AppDate_" "_AppTime
    .s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
    .s GetRegNo=$p(PatInfo,"^",1)
    .s GetName=$p(PatInfo,"^",2)
    .s GetstrDOB=$p(PatInfo,"^",3)
    .s GetstrAge=$p(PatInfo,"^",4)
    .s GetstrAge=$p(GetstrAge," ")
 	.s GetSexDesc=$p(PatInfo,"^",5)
    .s Getpatienttype=$p(PatInfo,"^",6)
    .s Gettypedesc=$p(PatInfo,"^",7)
    .s GetLocName=$p(PatInfo,"^",8)
    .s GetIPNo=$p(PatInfo,"^",9)       ;住院号
    .s GetWardName=$p(PatInfo,"^",10)
    .s GetBedNo=$p(PatInfo,"^",11)
    .s GetReqLocDR=$p(PatInfo,"^",12)
    .s GetWardDR=$p(PatInfo,"^",14)
    .s Getroomdesc=$p(PatInfo,"^",15)
    .s GetSexDr=$p(PatInfo,"^",13)
    .s PapatmasDR=$p(PatInfo,"^",24)
    .s Weight=$p(PatInfo,"^",21)
	.s TelNo=$p(PatInfo,"^",19)
	.s PinYin=$p(PatInfo,"^",38)
	.s Epissubtype=$p($g(PatInfo),"^",41)
    .s OrderRowid=$p(Oeorditemdr,"||",1)
    .s itemsub=$p(Oeorditemdr,"||",2)
    .s GetResDesc="",strRppDate="",strRppTime=""
    .s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(OrderRowid,itemsub)
    .s GetstrOrderName=$p(ordInfo,"^",1)
    .s GetstrDate=$p(ordInfo,"^",2)
    .s GetstrTime=$p(ordInfo,"^",3)
    .s Getrequestdoc=$p(ordInfo,"^",4)
    .s GetstrAccessionNum=$p(ordInfo,"^",5)
    .s GetSGroupDesc=$p(ordInfo,"^",6)    ;是否需要预约项目的标记
    .s GetsubCatDesc=$p(ordInfo,"^",7)
    .s GetCatDesc=$p(ordInfo,"^",8)
    .s Getifbed=$p(ordInfo,"^",9)
    .s Getprice=$p(ordInfo,"^",10)
    .s GetNum=$p(ordInfo,"^",11)
    .s GetTotalPrice=$p(ordInfo,"^",12)
    .s Getbilled=$p(ordInfo,"^",13)
    .s GetItemStatusCode=$p(ordInfo,"^",14)
    .s GetordDate=$p(ordInfo,"^",15)
    .s GetordTime=$p(ordInfo,"^",16)
    .s GetItemStatusCode=$p(ordInfo,"^",17)   			;医嘱状态
    .q:((GetItemStatusCode="U")&(IsUItem'="Y"))!(GetItemStatusCode="D")!(GetItemStatusCode="I")
    .s GetServerMaterial=$p(ordInfo,"^",18)   			;申请项目标记
    .s ResultFlag=$p(ordInfo,"^",20)    ;医嘱的结果状态--------------安贞医院用以前MEDTRAK 的结果处理，处理的的报告，在技师工作站中不在显示
    .s AutoInputFee=$p(ordInfo,"^",25) ;"需要另划价标志"
    .s EndInputFee=$p(ordInfo,"^",26)  ;"已另划价标识"
    .s BilledDesc=$p(ordInfo,"^",27)
    .s BodyDesc=$p(ordInfo,"^",29)
    .s CheckEntryFlag=$p(ordInfo,"^",30) 
    .s BookedUser=$p(ordInfo,"^",31)
    .s GetPaymentDoc=$p(ordInfo,"^",33) ;补录操作员
    .s GetPlatStatus=$p(ordInfo,"^",34) ;平台状态
    .q:(IsCostRecords'="Y")&(CheckEntryFlag="Y")
    .i CheckEntryFlag="Y" s CostRecords="已补录" s PaymentDoc=GetPaymentDoc
    .;q:ResultFlag="V"
    .i (BookedType="1") d                  ; 新开发的预约系统
    ..s BookedRowid=$o(^DHCRBCResSchduleDetaili(0,Oeorditemdr,0))
    ..i BookedRowid'="" d
    ...s SchudleRowid=$p(^DHCRBCResSchduleDetail("Detail",BookedRowid),"^",2)
    ...i SchudleRowid'="" d
    ....s ResourceId=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",1)
    ....s ResDesc=""
 	....s CTCPDR=$p($g(^RB("RES",ResourceId)),"^",2)
    ....s CTCPDR=$p(CTCPDR,$c(0))
    ....i CTCPDR'="" d
    .....s GetResDesc=$p($g(^CTPCP(CTCPDR,1)),"^",2)
    ....else  d
    .....s EQDR=$p($g(^RB("RES",ResourceId)),"^",3)
    .....s GetResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
    ....s RppDate=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",2)
    ....s strRppDate=$zd(RppDate,3)
    ....s RppTime=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",5)
    ....s strRppTime=$zt(RppTime,1)
    ....s GetBookedDuration=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",3)
    .else  d
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
    ....s GetBookedDuration=$p(^RBAS(ResRowid,SchildSub,"APPT",appointchildsub),"^",23) 
    
    .s GetReportStatusCode="N"     ;未写报告
    .s GetImgcount=0
    .s GetRptID=""
    .s GetRptDocDR="",GetRptDocName="",GetRptDate="",GetRptTime="",GetVerifyDocDR=""
    .s GetVerifyDocName="",GetVerifyDate="",GetVerifyTime="",GetStudyDescDR=""
    .s GetStudyWay="",GetBodyPartDR="",GetIsKYBL="",GetIsTSBL="",GetResultDesc="",GetExamDesc="",HaveImage=""
    .;s GetIndex="",GetEQDr="",GetEQDesc="",GetRoomDesc="",GetEQGroupDR=""
    .s GetRptIsYX="",GetBookedDuration=""
    .s Imrowid=0 f  s Imrowid=$o(^DHCRBStudyi("StudyNo-Images",StudyID,Imrowid)) q:Imrowid=""  d
    ..s GetPatientStatusCode="E"    ;正在检查
    ..s ExtName=$p($g(^DHCRBStudy(0,"StudyImages",Imrowid)),"^",2)
    ..i ((ExtName="avi")!(ExtName="dcm")!(ExtName="normal")!(ExtName="dsa"))  d
    ...s GetImgcount=GetImgcount+1
    ...s GetReportStatusCode="I"             ;图象已经采集
    ...s HaveImage="是"
    .s ReportStuatCode="VS"
    .s Rptrowid=0  f  s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",StudyID,Rptrowid)) q:Rptrowid=""  d
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
    ..s GetStudyDescDR=$p(^DHCRBStudy("Report",Rptrowid),"^",17)
    ..i GetStudyDescDR'="" s GetStudyWay=$p(^DHCRBStudy("StudyDesc",GetStudyDescDR),"^",7)
    ..;s GetBodyPartDR=$p(^DHCRBStudy("Report",Rptrowid),"^",19)
    ..s GetIsKYBL=$p(^DHCRBStudy("Report",Rptrowid),"^",21)
    ..s GetIsTSBL=$p(^DHCRBStudy("Report",Rptrowid),"^",22)
    ..s GetExamDesc=$p(^DHCRBStudy("Report",Rptrowid),"^",5)
    ..s GetResultDesc=$p(^DHCRBStudy("Report",Rptrowid),"^",6)
    ..s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
    ..s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
    ..s bOut="Y"
    ..Do OutRow4
    .i bOut="N" d
    ..s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
    ..s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
    ..s bOut="Y"
    ..Do OutRow4
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
OutRow4
	;set Data=$lb(RegNo,Name,SexDesc,strDOB,strAge,IDCDesc,$g(StudyNo),strOrderName,requestdoc,strAccessionNum,strDate,strTime,$g(AppointDate),$g(AppointstTime),$g(strRegDate),$g(strRegTime),$g(getReportDoc),$g(getReportVerifyDoc),PatientStatus,paadmdr,oeorditemdr,$g(LocName),TotalPrice,PatientStatusCode,billed,$g(typedesc),Num,price,$g(Index),$g(EQDesc),$g(ResDesc),ifbed,ReportStatus,MainDoc,AssDoc,RoomDesc)
 	//set Data=$lb(GetRegNo,GetName,GetSexDesc,GetstrDOB,GetstrAge,GetIDCDesc,GetStudyNo,GetstrOrderName,Getrequestdoc,GetstrAccessionNum,GetstrDate,GetstrTime,GetAppointDate,GetAppointstTime,GetstrRegDate,GetstrRegTime,GetReportDoc,GetReportVerifyDoc,GetPatientStatus,paadmdr,oeorditemdr,GetLocName,GetTotalPrice,GetPatientStatusCode,Getbilled,Gettypedesc,GetNum,Getprice,GetIndex,GetEQDesc,GetResDesc,Getifbed,GetReportStatus,GetMainDoc,GetAssDoc,GetRoomDesc)
   	//流水号,80;预约日期,80;预约时间,80;预约资源,100;床旁遗嘱,80;住院号，病区，房间号，床号，费别，检查部位，收费状态
   	s RecLoc=""
    i RecLocId'="" d
    .s RecLoc=$p(^CTLOC(RecLocId),"^",2)

   	s Required=""
   	if (GetSGroupDesc="无需预约")!(GetstrOrderName["床旁") s Required="N"
   	set Data=$lb(GetRegNo,GetName,GetSexDesc,GetstrAge,GetstrDOB,GetIDCDesc,
   	 GetStudyNo,GetstrOrderName,Getrequestdoc,GetstrAccessionNum,GetstrDate,GetstrTime,strRppDate,strRppTime,GetBookedDuration,GetstrRegDate,GetstrRegTime,GetRptDocName,GetVerifyDocName,GetPatientStatus,paadmdr,Oeorditemdr, 	 
   	 GetLocName,GetTotalPrice,GetPatientStatusCode,Getbilled,Gettypedesc,GetNum,Getprice,GetIndex,GetEQDesc,GetResDesc,Getifbed,GetReportStatus,GetMainDoc,GetAssDoc,GetRoomDesc,GetEQGroupDesc,GetWardName,GetOldNo,Required,strXDate,GetItemStatusCode,PapatmasDR,BodyDesc,Weight,TelNo,GetIPNo,FileSent,GetBedNo,ReportSend,HaveImage,RecLocId,RecLoc,AutoInputFee,EndInputFee,Detail,RejectAppReason,BilledDesc,PinYin,ToDayOeItem,CostRecords,AppDate,BookedUser,PaymentDoc,GetPlatStatus,Epissubtype)
   	Set ^CacheTemp(repid,ind)=Data
   	s ^DHCRisTmpPrintData123(ind)=GetRegNo_"^"_GetName_"^"_GetSexDesc_"^"_GetstrAge_"^"_GetWardName_"^"_GetBedNo_"^"_GetStudyNo_"^"_$g(ReportSend)
   	s ^DHCRisTmpPrintData123=ind
	Set ind=ind+1
 	quit
}

ClassMethod QueryByRegNo(ExmLocID, RoomDR, DeviceDR, PatTypeDR, InRegNo, StudyID, InName, InSexDR, Age, InStudyStatusCode, InRptStatusCode, StdDate, EndDate, OrderItemDR, StudyWay, InReqLocDR, RptDesc, RptDiagnose, RptDocDR, VerifyDocDR, IsYX, IsDXBL, IsKYBL, zyh, WardDR, InEQGroupDR, InOldNo, InIsFindDate, BookedType, IsUItem, IsCostRecords)
{
	//^PAPERi("PAPMI_PatNo",$$ALPHAUP({PAPMI_No}),{PAPMI_RowId}) 
	//^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
	s InRegNo=$ZCONVERT(InRegNo,"U")
	s NoRowid=$o(^PAPERi("PAPMI_PatNo",InRegNo,0))
	if NoRowid=""  Set qHandle=$lb(0,repid,0)
	q:NoRowid="" $$$OK
	s paadmtype="" f  s paadmtype=$o(^PAPERdr(NoRowid,"ADM",paadmtype)) q:paadmtype=""  d
	.s paadmrowid=0 f  s paadmrowid=$o(^PAPERdr(NoRowid,"ADM",paadmtype,paadmrowid)) q:paadmrowid=""  d
	..s OrderRowid=0 f  s OrderRowid=$o(^OEORD(0,"Adm",paadmrowid,OrderRowid)) q:OrderRowid=""  d
	...s itemsub=0  f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:itemsub=""  d
	....s oeorditemdr=OrderRowid_"||"_itemsub 
	....;w !,oeorditemdr
	....s reploc=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)   ;
	....s bQLoc=..IsQueryLoc(ExmLocID,reploc)
	....q:(bQLoc=0)
	....;q:(reploc'=ExmLocID)&(ExmLocID'="")
	....s Date1=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",9)
	....q:(InIsFindDate="true")&(Date1<StdDate)!(Date1>EndDate)
	....s bOut="N"  ;是否已经输出
	....s Detail="明细",RejectAppReason="",ToDayOeItem="",CostRecords="",BookedUser="",PaymentDoc=""
	....s ExterFalg="",GetIDCDesc=""
	....s paadmdr=$p(^OEORD(OrderRowid),"^",1) 
	....s GetIDCDesc=##class(web.DHCRisCommFunctionEx).GetDiagnose(paadmdr)
    ....s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
    ....s GetRegNo=$p(PatInfo,"^",1)
    ....s GetName=$p(PatInfo,"^",2)
    ....s GetstrDOB=$p(PatInfo,"^",3)
    ....s GetstrAge=$p(PatInfo,"^",4)
    ....s GetstrAge=$p(GetstrAge," ")
 	....s GetSexDesc=$p(PatInfo,"^",5)
    ....s Getpatienttype=$p(PatInfo,"^",6)
    ....s Gettypedesc=$p(PatInfo,"^",7)
    ....s GetLocName=$p(PatInfo,"^",8)
    ....s GetIPNo=$p(PatInfo,"^",9)       ;住院号
    ....s GetWardName=$p(PatInfo,"^",10)
    ....s GetBedNo=$p(PatInfo,"^",11)
    ....s GetReqLocDR=$p(PatInfo,"^",12)
    ....s GetWardDR=$p(PatInfo,"^",14)
    ....s Getroomdesc=$p(PatInfo,"^",15)
    ....s GetSexDr=$p(PatInfo,"^",13)
    ....s PapatmasDR=$p(PatInfo,"^",24)
    ....s Weight=$p(PatInfo,"^",21)
	....s TelNo=$p(PatInfo,"^",19)
	....s PinYin=$p(PatInfo,"^",38)
	....s Epissubtype=$p($g(PatInfo),"^",41)
    ....s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(OrderRowid,itemsub)
    ....s GetstrOrderName=$p(ordInfo,"^",1)
    ....s GetstrDate=$p(ordInfo,"^",2)
    ....s GetstrTime=$p(ordInfo,"^",3)
    ....s Getrequestdoc=$p(ordInfo,"^",4)
    ....s GetstrAccessionNum=$p(ordInfo,"^",5)
    ....s GetSGroupDesc=$p(ordInfo,"^",6)    ;是否需要预约项目的标记
    ....s GetsubCatDesc=$p(ordInfo,"^",7)
    ....s GetCatDesc=$p(ordInfo,"^",8)
    ....s Getifbed=$p(ordInfo,"^",9)
    ....s Getprice=$p(ordInfo,"^",10)
    ....s GetNum=$p(ordInfo,"^",11)
    ....s GetTotalPrice=$p(ordInfo,"^",12)
    ....s Getbilled=$p(ordInfo,"^",13)
    ....s GetItemStatusCode=$p(ordInfo,"^",14)
    ....s GetordDate=$p(ordInfo,"^",15)
    ....s GetordTime=$p(ordInfo,"^",16)
    ....s GetItemStatusCode=$p(ordInfo,"^",17)   			;医嘱状态
    ....q:((GetItemStatusCode="U")&(IsUItem'="Y"))!(GetItemStatusCode="D")!(GetItemStatusCode="I")
    ....s GetServerMaterial=$p(ordInfo,"^",18)   			;申请项目标记
    ....s ResultFlag=$p(ordInfo,"^",20)    ;医嘱的结果状态--------------安贞医院用以前MEDTRAK 的结果处理，处理的的报告，在技师工作站中不在显示
    ....s AutoInputFee=$p(ordInfo,"^",25) ;"需要另划价标志"
    ....s EndInputFee=$p(ordInfo,"^",26)  ;"已另划价标识"
    ....s BilledDesc=$p(ordInfo,"^",27)
    ....s BodyDesc=$p(ordInfo,"^",29)
    ....s CheckEntryFlag=$p(ordInfo,"^",30)
    ....s BookedUser=$p(ordInfo,"^",31)
    ....s GetPaymentDoc=$p(ordInfo,"^",33) ;补录操作员
    ....s GetPlatStatus=$p(ordInfo,"^",34) ;平台状态
    ....q:(IsCostRecords'="Y")&(CheckEntryFlag="Y") 
    ....i CheckEntryFlag="Y" s CostRecords="已补录" s PaymentDoc=GetPaymentDoc
    ....;q:ResultFlag="V"
    ....s SystemParamInfo=##class(web.DHCRisCommFunction).GetSystemParam()
    ....s SendApptoLoc=$p(SystemParamInfo,"^",3)  ;没写申请单,是否发检查医嘱到检查科室
    ....s SendInPtoLoc=$p(SystemParamInfo,"^",4)  ;没收费是否把住院病人的检查项目发送到检查科室  
    ....s SendOutPtoLoc=$p(SystemParamInfo,"^",5) ;没收费是否把门诊检查项目发送到检查科室
    ....s SendEmPtoLoc=$p(SystemParamInfo,"^",6)   ;没收费是否把急诊病人检查项目发送到检查科室
    ....s QueryonlyExam=$p(SystemParamInfo,"^",9)  ;是否只查询检查项目
    ....s SendHPtoLoc=$p(SystemParamInfo,"^",10)   ;没收费是否把体检病人的检查项目发送检查科室
    ....q:(SendInPtoLoc="N")&(Getbilled'="P")&(Getpatienttype="I")    ;住院病人没有付费的退出
    ....q:(SendOutPtoLoc="N")&(Getbilled'="P")&(Getpatienttype="O")   ;门诊病人没有付费退出
    ....q:(SendEmPtoLoc="N")&(Getbilled'="P")&(Getpatienttype="E")   ;急症病人没付费退出
    ....q:(SendHPtoLoc="N")&(Getbilled'="P")&(Getpatienttype="H")   ;体检病人没付费退出
    ....q:(QueryonlyExam="Y")&(GetServerMaterial'="S") ;不是检查项目的则退出
    ....;------------------------------------------------------------------
    ....s GetPatientStatusCode="A"
    ....s GetReportStatusCode="N"
    ....s Getapprowid="",GetStudyNo=""
    ....s GetRoomDr="",strRppDate="",strRppTime=""
    ....s GetImgcount="",GetMainDoc="",GetAssDoc="",GetBookedDuration=""
    ....s GetRptID="",GetRptVersion="",GetRptIsYX="",GetEQGroupDesc="",GetOldNo=""
    ....s GetRptDocDR="",GetRptDocName="",GetRptDate="",GetRptTime="",GetVerifyDocDR=""
    ....s GetVerifyDocName="",GetVerifyDate="",GetVerifyTime="",GetStudyDescDR=""
    ....s GetStudyWay="",GetBodyPartDR="",GetIsKYBL="",GetIsTSBL="",GetResultDesc="",GetExamDesc=""
    ....s GetIndex="",GetstrRegDate="",GetstrRegTime="",GetEQDr="",GetEQDesc="",GetRoomDesc="",GetEQGroupDR="",HaveImage=""
    ....;--------------------------------------------------------------------
    ....i (GetItemStatusCode="V")!(GetItemStatusCode="E") d
    .....;w !,"Getpatienttype"_Getpatienttype_"^"_oeorditemdr_"^"_paadmdr
    .....s strXDate="",AppDate=""
    .....s AllowSend="Y",AppRowid=""
    .....i (SendApptoLoc="N")&(Getpatienttype="I")  d
    ......s AppRowid=$o(^DHCRBAppi("OrdRowid",oeorditemdr,0)) 
    ......i AppRowid'="" d
    .......s AllowSend="Y"
    .......s XDate=$p( ^DHCRBApp("Bill",AppRowid),"^",10)
    .......s strXDate=$zd(XDate,3)
    .......s AppDate=$p(^DHCRBApp("Bill",AppRowid),"^",1)
    .......i AppDate'="" s AppDate=$zd(AppDate,3)
    .......s AppTime=$p(^DHCRBApp("Bill",AppRowid),"^",8)
    .......i AppTime'="" s AppTime=$zt(AppTime)
    .......s AppDate=AppDate_" "_AppTime
    ......else  d
    .......s AllowSend="N"
    .....q:AllowSend="N"
    .....s GetRejDR=$o(^DHCRBRejecti("OeordDR",oeorditemdr,0))
	.....i GetRejDR'="" d
	......s GetPatientStatusCode="RJ" ;拒绝申请
	......s RejectAppReason="拒绝原因"
	.....else  d
	......s GetResDesc="",strRppDate="",strRppTime=""
	......s ExterFalg=..IsExternalBooked(oeorditemdr)
    ......i ExterFalg="Y" d
    .......s GetPatientStatusCode="B"
    .......s strRppDate=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",2)
    .......s strRppTime=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",3)
	......i BookedType="1"  d
	.......s BookedRowid=$o(^DHCRBCResSchduleDetaili(0,oeorditemdr,0))
    .......i BookedRowid'="" d
    ........s GetPatientStatusCode="B"
    ........s SchudleRowid=$p(^DHCRBCResSchduleDetail("Detail",BookedRowid),"^",2)
    ........i SchudleRowid'="" d
    ........s ResourceId=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",1)
    ........s ResDesc=""
 	........s CTCPDR=$p($g(^RB("RES",ResourceId)),"^",2)
    ........s CTCPDR=$p(CTCPDR,$c(0))
    ........i CTCPDR'="" d
    .........s GetResDesc=$p($g(^CTPCP(CTCPDR,1)),"^",2)
    ........else  d
    .........s EQDR=$p($g(^RB("RES",ResourceId)),"^",3)
    .........s GetResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
    .........s RppDate=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",2)
    .........s strRppDate=$zd(RppDate,3)
    .........;w !,strRppDate
    .........s RppTime=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",5)
    .........s strRppTime=$zt(RppTime,1)
    .........;w !,oeorditemdr
    .........s TimePeriodeCode=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",3)
    .........i TimePeriodeCode'="" d 
    ..........s TpsRowid=$o(^DHCRBCTimePeriodSeti("Code",TimePeriodeCode,0))
    ..........s GetBookedDuration=$p(^DHCRBCTimePeriodSet(TpsRowid),"^",2)
	......else  d      
    .......i $g(^OEORD(OrderRowid,"I",itemsub,6))'="" d
    ........s Getapprowid=$p(^OEORD(OrderRowid,"I",itemsub,6),"^",5)
    ........i (Getapprowid'="")&(Getapprowid'=$C(0)) d
    .........s GetPatientStatusCode="B"  
    .........s ResRowid=$p(Getapprowid,"||",1)
    .........s SchildSub=$p(Getapprowid,"||",2)
    .........s appointchildsub=$p(Getapprowid,"||",3)
   	.........s CTCPDR=$p($g(^RB("RES",ResRowid)),"^",2)
    .........s CTCPDR=$p(CTCPDR,$c(0))
    .........i CTCPDR'="" d
    ..........s GetResDesc=$p($g(^CTPCP(CTCPDR,1)),"^",2)
    .........else  d
    ..........s EQDR=$p($g(^RB("RES",ResRowid)),"^",3)
    ..........s GetResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
    ..........s RppDate=$p(^RBAS(ResRowid,SchildSub),"^",1)
    ..........s strRppDate=$zd(RppDate,3)
    ..........s RppTime=$p(^RBAS(ResRowid,SchildSub),"^",4)
    ..........s strRppTime=$zt(RppTime,1)
    ..........s GetBookedDuration=$p(^RBAS(ResRowid,SchildSub,"APPT",appointchildsub),"^",23)
	.....s GetImgcount=0
	.....;i GetItemStatusCode="E"  d  ; 医嘱执行
	.....s FileSent="" ;,BodyDesc=""
	.....s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfo(oeorditemdr)
    .....s GetStudyNo=$p(RegInfo,"^",1)
    .....i GetStudyNo'="" d
   	......s GetPatientStatusCode="I"
    ......s GetstrRegDate=$p(RegInfo,"^",2)
    ......s GetstrRegTime=$p(RegInfo,"^",3)
    ......s GetIndex=$p(RegInfo,"^",4)
    ......s GetEQDesc=$p(RegInfo,"^",5)
    ......s GetMainDoc=$p(RegInfo,"^",6)
    ......s GetAssDoc=$p(RegInfo,"^",7)
    ......s GetRoomDesc=$p(RegInfo,"^",8)
    ......s GetRoomDr=$p(RegInfo,"^",9)
    ......s GetEQDr=$p(RegInfo,"^",10)
    ......s GetEQGroupDesc=$p(RegInfo,"^",11)
    ......s GetEQGroupDR=$p(RegInfo,"^",12)
    ......s GetOldNo=$p(RegInfo,"^",13)
    ......;s BodyDesc=$p(RegInfo,"^",17)
    ......s FileSent=##class(web.DHCRisWorkBenchDoEx).GetFilmSendDesc(GetStudyNo)
    ......s ReportSend=##class(web.DHCRisWorkBenchDoEx).GetReportSend(GetStudyNo)
    ......s GetReportStatusCode="N"     ;未写报告
    ......s GetImgcount=0
    ......s GetRptID=""
    ......q:GetStudyNo=""
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
    ........s GetRptStatusDesc=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",2)
    ........s GetReportStatusCode=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",1)
    ........i ReportStuatCode[GetReportStatusCode d
    .........s GetPatientStatusCode="O"
    ........e  d
    .........s GetPatientStatusCode="E"
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
    .......s GetStudyDescDR=$p(^DHCRBStudy("Report",Rptrowid),"^",17)
    .......i GetStudyDescDR'="" s GetStudyWay=$p(^DHCRBStudy("StudyDesc",GetStudyDescDR),"^",7)
    .......;s GetBodyPartDR=$p(^DHCRBStudy("Report",Rptrowid),"^",19)
    .......s GetIsKYBL=$p(^DHCRBStudy("Report",Rptrowid),"^",21)
    .......s GetIsTSBL=$p(^DHCRBStudy("Report",Rptrowid),"^",22)
    .......s GetExamDesc=$p(^DHCRBStudy("Report",Rptrowid),"^",5)
    .......s GetResultDesc=$p(^DHCRBStudy("Report",Rptrowid),"^",6)
    .......i (InStudyStatusCode="")!(GetPatientStatusCode=InStudyStatusCode)
    ........s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
    ........s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
    ........s bOut="Y"
    ........Do OutRow5
    .....i (bOut="N")&(InStudyStatusCode="")!(GetPatientStatusCode=InStudyStatusCode) d
    ......s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
    ......s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
    ......s bOut="Y"
    ......Do OutRow5
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
OutRow5
    s RecLoc=""
    i reploc'="" d
    .s RecLoc=$p(^CTLOC(reploc),"^",2)

   	s Required=""
   	if (GetSGroupDesc="无需预约")!(GetstrOrderName["床旁") s Required="N"
  	set Data=$lb(GetRegNo,GetName,GetSexDesc,GetstrAge,GetstrDOB,GetIDCDesc,
   	GetStudyNo,GetstrOrderName,Getrequestdoc,GetstrAccessionNum,GetstrDate,GetstrTime,strRppDate,strRppTime,GetBookedDuration,GetstrRegDate,GetstrRegTime,GetRptDocName,GetVerifyDocName,GetPatientStatus,paadmdr,oeorditemdr, 	 
   	GetLocName,GetTotalPrice,GetPatientStatusCode,Getbilled,Gettypedesc,GetNum,Getprice,GetIndex,GetEQDesc,GetResDesc,Getifbed,GetReportStatus,GetMainDoc,GetAssDoc,GetRoomDesc,GetEQGroupDesc,GetWardName,GetOldNo,Required,strXDate,GetItemStatusCode,PapatmasDR,BodyDesc,Weight,TelNo,GetIPNo,FileSent,GetBedNo,ReportSend,HaveImage,reploc,RecLoc,AutoInputFee,EndInputFee,Detail,RejectAppReason,BilledDesc,PinYin,ToDayOeItem,CostRecords,AppDate,BookedUser,PaymentDoc,GetPlatStatus,Epissubtype)
   	Set ^CacheTemp(repid,ind)=Data
   	s ^DHCRisTmpPrintData123(ind)=GetRegNo_"^"_GetName_"^"_GetSexDesc_"^"_GetstrAge_"^"_GetWardName_"^"_GetBedNo_"^"_GetStudyNo_"^"_$g(ReportSend)
   	s ^DHCRisTmpPrintData123=ind
	Set ind=ind+1
 	quit
}

ClassMethod QueryByName(ExmLocID, RoomDR, DeviceDR, PatTypeDR, InRegNo, StudyID, InName, InSexDR, Age, InStudyStatusCode, InRptStatusCode, StdDate, EndDate, OrderItemDR, StudyWay, InReqLocDR, RptDesc, RptDiagnose, RptDocDR, VerifyDocDR, IsYX, IsDXBL, IsKYBL, zyh, WardDR, InEQGroupDR, InOldNo, InIsFindDate, BookedType, IsUItem, IsCostRecords)
{
	// ^PAPERi("PAPER_PatName",$$ALPHAUP({PAPMI_Name}),{PAPMI_RowId})
	// ^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
	s Isfirst=1
	s flag="N"
	s InName=$ZCONVERT(InName,"U")
	s GetName=InName 
	
	do 
	{
		if InName="" s flag="Y" q
		if (GetName'[InName) s flag="Y" q
		s GetName=$ZCONVERT(GetName,"U")
	
		s NoRowid=0 f  s NoRowid=$o(^PAPERi("PAPER_PatName",GetName,NoRowid))  q:NoRowid=""  d
		.s paadmtype="" f  s paadmtype=$o(^PAPERdr(NoRowid,"ADM",paadmtype)) q:paadmtype=""  d
		..s paadmrowid=0 f  s paadmrowid=$o(^PAPERdr(NoRowid,"ADM",paadmtype,paadmrowid)) q:paadmrowid=""  d
		...s OrderRowid=0 f  s OrderRowid=$o(^OEORD(0,"Adm",paadmrowid,OrderRowid)) q:OrderRowid=""  d
		....s itemsub=0  f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:itemsub=""  d
		.....s reploc=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)   ;
		.....s oeorditemdr=OrderRowid_"||"_itemsub 
		.....;q:(reploc'=ExmLocID)&(ExmLocID'="")
		.....s bQLoc=..IsQueryLoc(ExmLocID,reploc)
		.....q:(bQLoc=0)
		.....s Date1=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",9)
		.....q:(InIsFindDate="true")&(Date1<StdDate)!(Date1>EndDate)
		.....s bOut="N"  ;是否已经输出
		.....s Detail="明细",RejectAppReason="",ToDayOeItem="",CostRecords="",BookedUser="",PaymentDoc=""
		.....s ExterFalg=""
		.....s GetIDCDesc=""
		.....s paadmdr=$p(^OEORD(OrderRowid),"^",1) 
		.....s GetIDCDesc=##class(web.DHCRisCommFunctionEx).GetDiagnose(paadmdr)
	    .....s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
	    .....s GetRegNo=$p(PatInfo,"^",1)
	    .....s GetNameL=$p(PatInfo,"^",2)
	    .....s GetstrDOB=$p(PatInfo,"^",3)
	    .....s GetstrAge=$p(PatInfo,"^",4)
	    .....s GetstrAge=$p(GetstrAge," ")
	 	.....s GetSexDesc=$p(PatInfo,"^",5)
	    .....s Getpatienttype=$p(PatInfo,"^",6)
	    .....s Gettypedesc=$p(PatInfo,"^",7)
	    .....s GetLocName=$p(PatInfo,"^",8)
	    .....s GetIPNo=$p(PatInfo,"^",9)       ;住院号
	    .....s GetWardName=$p(PatInfo,"^",10)
	    .....s GetBedNo=$p(PatInfo,"^",11)
	    .....s GetReqLocDR=$p(PatInfo,"^",12)
	    .....s GetWardDR=$p(PatInfo,"^",14)
	    .....s Getroomdesc=$p(PatInfo,"^",15)
	    .....s GetSexDr=$p(PatInfo,"^",13)
	    .....s PapatmasDR=$p(PatInfo,"^",24)
	    .....s Weight=$p(PatInfo,"^",21)
		.....s TelNo=$p(PatInfo,"^",19)
		.....s PinYin=$p(PatInfo,"^",38)
		.....s Epissubtype=$p($g(PatInfo),"^",41)
	    .....s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(OrderRowid,itemsub)
	    .....s GetstrOrderName=$p(ordInfo,"^",1)
	    .....s GetstrDate=$p(ordInfo,"^",2)
	    .....s GetstrTime=$p(ordInfo,"^",3)
	    .....s Getrequestdoc=$p(ordInfo,"^",4)
	    .....s GetstrAccessionNum=$p(ordInfo,"^",5)
	    .....s GetSGroupDesc=$p(ordInfo,"^",6)    ;是否需要预约项目的标记
	    .....s GetsubCatDesc=$p(ordInfo,"^",7)
	    .....s GetCatDesc=$p(ordInfo,"^",8)
	    .....s Getifbed=$p(ordInfo,"^",9)
	    .....s Getprice=$p(ordInfo,"^",10)
	    .....s GetNum=$p(ordInfo,"^",11)
	    .....s GetTotalPrice=$p(ordInfo,"^",12)
	    .....s Getbilled=$p(ordInfo,"^",13)
	    .....s GetItemStatusCode=$p(ordInfo,"^",14)
	    .....s GetordDate=$p(ordInfo,"^",15)
	    .....s GetordTime=$p(ordInfo,"^",16)
	    .....s GetItemStatusCode=$p(ordInfo,"^",17) 
	    .....q:((GetItemStatusCode="U")&(IsUItem'="Y"))!(GetItemStatusCode="D")!(GetItemStatusCode="I")  ;医嘱状态
	    .....s GetServerMaterial=$p(ordInfo,"^",18)   			;申请项目标记
	    .....s AutoInputFee=$p(ordInfo,"^",25) ;"需要另划价标志"
	    .....s EndInputFee=$p(ordInfo,"^",26)  ;"已另划价标识"
	    .....s BilledDesc=$p(ordInfo,"^",27)
	    .....s BodyDesc=$p(ordInfo,"^",29)
        .....s CheckEntryFlag=$p(ordInfo,"^",30)
        .....s BookedUser=$p(ordInfo,"^",31)
        .....s GetPaymentDoc=$p(ordInfo,"^",33) ;补录操作员 
        .....s GetPlatStatus=$p(ordInfo,"^",34) ;平台状态
        .....q:(IsCostRecords'="Y")&(CheckEntryFlag="Y")
        .....i CheckEntryFlag="Y" s CostRecords="已补录" s PaymentDoc=GetPaymentDoc
	    .....s ResultFlag=$p(ordInfo,"^",20)    ;医嘱的结果状态--------------安贞医院用以前MEDTRAK 的结果处理，处理的的报告，在技师工作站中不在显示
	    .....;q:ResultFlag="V"
	    .....s SystemParamInfo=##class(web.DHCRisCommFunction).GetSystemParam()
	    .....s SendApptoLoc=$p(SystemParamInfo,"^",3)  ;没写申请单,是否发检查医嘱到检查科室
	    .....s SendInPtoLoc=$p(SystemParamInfo,"^",4)  ;没收费是否把住院病人的检查项目发送到检查科室  
	    .....s SendOutPtoLoc=$p(SystemParamInfo,"^",5) ;没收费是否把门诊检查项目发送到检查科室
	    .....s SendEmPtoLoc=$p(SystemParamInfo,"^",6)   ;没收费是否把急诊病人检查项目发送到检查科室
	    .....s QueryonlyExam=$p(SystemParamInfo,"^",9)  ;是否只查询检查项目
	    .....s SendHPtoLoc=$p(SystemParamInfo,"^",10)   ;没收费是否把体检病人的检查项目发送检查科室
	    .....q:(SendInPtoLoc="N")&(Getbilled'="P")&(Getpatienttype="I")    ;住院病人没有付费的退出
	    .....q:(SendOutPtoLoc="N")&(Getbilled'="P")&(Getpatienttype="O")   ;门诊病人没有付费退出
	    .....q:(SendEmPtoLoc="N")&(Getbilled'="P")&(Getpatienttype="E")   ;急症病人没付费退出
	    .....q:(SendHPtoLoc="N")&(Getbilled'="P")&(Getpatienttype="H")   ;体检病人没付费退出
	    .....q:(QueryonlyExam="Y")&(GetServerMaterial'="S") ;不是检查项目的则退出
	    .....;------------------------------------------------------------------
	    .....s GetPatientStatusCode="A"
	    .....s GetReportStatusCode="N"
	    .....s Getapprowid="",GetStudyNo=""
	    .....s GetRoomDr=""
	    .....s GetImgcount="",GetMainDoc="",GetAssDoc=""
	    .....s GetRptID="",GetRptVersion="",GetRptIsYX="",GetEQGroupDesc="",GetOldNo=""
	    .....s GetRptDocDR="",GetRptDocName="",GetRptDate="",GetRptTime="",GetVerifyDocDR=""
	    .....s GetVerifyDocName="",GetVerifyDate="",GetVerifyTime="",GetStudyDescDR=""
	    .....s GetStudyWay="",GetBodyPartDR="",GetIsKYBL="",GetIsTSBL="",GetResultDesc="",GetExamDesc=""
	    .....s GetIndex="",GetstrRegDate="",GetstrRegTime="",GetEQDr="",GetEQDesc="",GetRoomDesc="",GetEQGroupDR=""
	    .....s GetResDesc="",strRppDate="",strRppTime="",GetBookedDuration="",HaveImage=""
	    .....s ExterFalg=..IsExternalBooked(oeorditemdr)
        .....i ExterFalg="Y" d
        ......s GetPatientStatusCode="B"
        ......s strRppDate=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",2)
        ......s strRppTime=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",3)
	    .....;--------------------------------------------------------------------
	    .....i (GetItemStatusCode="V")!(GetItemStatusCode="E") d
	    ......s strXDate="",AppDate=""
	    ......s AllowSend="Y"
	    ......i (SendApptoLoc="N")&(Getpatienttype="I")  d
	    .......s AppRowid=$o(^DHCRBAppi("OrdRowid",oeorditemdr,0)) 
	    .......i AppRowid'="" d
	    ........s AllowSend="Y"
	    ........s XDate=$p( ^DHCRBApp("Bill",AppRowid),"^",10)
	    ........s strXDate=$zd(XDate,3)
	    ........s AppDate=$p(^DHCRBApp("Bill",AppRowid),"^",1)
        ........i AppDate'="" s AppDate=$zd(AppDate,3)
        ........s AppTime=$p(^DHCRBApp("Bill",AppRowid),"^",8)
        ........i AppTime'="" s AppTime=$zt(AppTime)
        ........s AppDate=AppDate_" "_AppTime
	    .......else  d
	    ........s AllowSend="N"
	    ......q:AllowSend="N"
	    ......s GetRejDR=$o(^DHCRBRejecti("OeordDR",oeorditemdr,0))
		......i GetRejDR'="" d
		.......s GetPatientStatusCode="RJ" ;拒绝申请
		.......s RejectAppReason="拒绝原因"
		......else  d
	    .......i BookedType="1"  d   ; 新开发的预约系统
		........s BookedRowid=$o(^DHCRBCResSchduleDetaili(0,oeorditemdr,0))
	    ........i BookedRowid'="" d
	    .........s GetPatientStatusCode="B"
	    .........s SchudleRowid=$p(^DHCRBCResSchduleDetail("Detail",BookedRowid),"^",2)
	    .........i SchudleRowid'="" d
	    ..........s ResourceId=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",1)
	    ..........s ResDesc=""
	 	..........s CTCPDR=$p($g(^RB("RES",ResourceId)),"^",2)
	    ..........s CTCPDR=$p(CTCPDR,$c(0))
	    ..........i CTCPDR'="" d
	    ...........s GetResDesc=$p($g(^CTPCP(CTCPDR,1)),"^",2)
	    ..........else  d
	    ...........s EQDR=$p($g(^RB("RES",ResourceId)),"^",3)
	    ...........s GetResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
	    ..........s RppDate=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",2)
	    ..........s strRppDate=$zd(RppDate,3)
	    ..........s RppTime=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",5)
	    ..........s strRppTime=$zt(RppTime,1)
	    ..........s TimePeriodeCode=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",3)
	    ..........i TimePeriodeCode'="" d 
	    ...........s TpsRowid=$o(^DHCRBCTimePeriodSeti("Code",TimePeriodeCode,0))
	    ...........s GetBookedDuration=$p(^DHCRBCTimePeriodSet(TpsRowid),"^",2)
	    .......else  d
		........i $g(^OEORD(OrderRowid,"I",itemsub,6))'="" d
	    .........s Getapprowid=$p(^OEORD(OrderRowid,"I",itemsub,6),"^",5)
	    .........s Getapprowid=$p(Getapprowid,$c(0))
	    .........i (Getapprowid'="")&(Getapprowid'=$C(0)) d
	    ..........s GetPatientStatusCode="B"
	    ..........s ResRowid=$p(Getapprowid,"||",1)
	    ..........s SchildSub=$p(Getapprowid,"||",2)
	    ..........s appointchildsub=$p(Getapprowid,"||",3)
	   	..........s CTCPDR=$p($g(^RB("RES",ResRowid)),"^",2)
	    ..........s CTCPDR=$p(CTCPDR,$c(0))
	    ..........i CTCPDR'="" d
	    ...........s GetResDesc=$p($g(^CTPCP(CTCPDR,1)),"^",2)
	    ..........else  d
	    ...........s EQDR=$p($g(^RB("RES",ResRowid)),"^",3)
	    ...........s GetResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
	    ...........s RppDate=$p(^RBAS(ResRowid,SchildSub),"^",1)
	    ...........s strRppDate=$zd(RppDate,3)
	    ...........s RppTime=$p(^RBAS(ResRowid,SchildSub),"^",4)
	    ...........s strRppTime=$zt(RppTime,1)
	    ...........s GetBookedDuration=$p(^RBAS(ResRowid,SchildSub,"APPT",appointchildsub),"^",23) 
		......s GetImgcount=0
		......;i GetItemStatusCode="E"  d  ; 医嘱执行
		......s GetStudyNo="",FileSent="" ;,BodyDesc=""                  ;登记
		......s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfo(oeorditemdr)
	    ......s GetStudyNo=$p(RegInfo,"^",1)
	    ......i GetStudyNo'="" d
	   	.......s GetPatientStatusCode="I"
	    .......s GetstrRegDate=$p(RegInfo,"^",2)
	    .......s GetstrRegTime=$p(RegInfo,"^",3)
	    .......s GetIndex=$p(RegInfo,"^",4)
	    .......s GetEQDesc=$p(RegInfo,"^",5)
	    .......s GetMainDoc=$p(RegInfo,"^",6)
	    .......s GetAssDoc=$p(RegInfo,"^",7)
	    .......s GetRoomDesc=$p(RegInfo,"^",8)
	    .......s GetRoomDr=$p(RegInfo,"^",9)
	    .......s GetEQDr=$p(RegInfo,"^",10)
	    .......s GetEQGroupDesc=$p(RegInfo,"^",11)
	    .......s GetEQGroupDR=$p(RegInfo,"^",12)
	    .......s GetOldNo=$p(RegInfo,"^",13)
	    .......;s BodyDesc=$p(RegInfo,"^",17)
	    .......s FileSent=##class(web.DHCRisWorkBenchDoEx).GetFilmSendDesc(GetStudyNo)
	    .......s ReportSend=##class(web.DHCRisWorkBenchDoEx).GetReportSend(GetStudyNo)
	    .......s GetReportStatusCode="N"     ;未写报告
	    .......s GetImgcount=0
	    .......s GetRptID=""
	    .......q:GetStudyNo=""
	    .......s Imrowid=0 f  s Imrowid=$o(^DHCRBStudyi("StudyNo-Images",GetStudyNo,Imrowid)) q:Imrowid=""  d
	    ........s GetPatientStatusCode="E"    ;正在检查
	    ........s ExtName=$p($g(^DHCRBStudy(0,"StudyImages",Imrowid)),"^",2)
	    ........i ((ExtName="avi")!(ExtName="dcm")!(ExtName="normal")!(ExtName="dsa"))  d
	    .........s GetImgcount=GetImgcount+1
	    .........s GetReportStatusCode="I"             ;图象已经采集
	    .........s HaveImage="是"
	    .......s ReportStuatCode="VS"
	    .......s Rptrowid=0  f  s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",GetStudyNo,Rptrowid)) q:Rptrowid=""  d
	    ........s GetRptID=$p(^DHCRBStudy("Report",Rptrowid),"^",2)
	    ........s GetRptVersion=$p(^DHCRBStudy("Report",Rptrowid),"^",3)
	    ........s GetRptStatusDR=$p(^DHCRBStudy("Report",Rptrowid),"^",4)
	    ........i GetRptStatusDR'="" d
	    .........s GetRptStatusDesc=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",2)
	    .........s GetReportStatusCode=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",1)
	    .........i ReportStuatCode[GetReportStatusCode d
	    ..........s GetPatientStatusCode="O"
	    .........e  d
	    ..........s GetPatientStatusCode="E"
	    ........s GetRptIsYX=$p(^DHCRBStudy("Report",Rptrowid),"^",7)
	    ........s GetRptDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",8)
	    ........i GetRptDocDR'="" s GetRptDocName=$p(^SSU("SSUSR",GetRptDocDR),"^",2)
	    ........s GetRptDate=$p(^DHCRBStudy("Report",Rptrowid),"^",9)
	    ........i GetRptDate'="" s GetRptDate=$zd(GetRptDate,3)
	    ........s GetRptTime=$p(^DHCRBStudy("Report",Rptrowid),"^",10)
	    ........i GetRptTime'="" s GetRptTime=$zt(GetRptTime,3)
	    ........s GetVerifyDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",11)
	    ........i GetVerifyDocDR'="" s GetVerifyDocName=$p(^SSU("SSUSR",GetVerifyDocDR),"^",2)
	    ........s GetVerifyDate=$p(^DHCRBStudy("Report",Rptrowid),"^",12)
	    ........i GetVerifyDate'="" s GetVerifyDate=$zd(GetVerifyDate,3) 
	    ........s GetVerifyTime=$p(^DHCRBStudy("Report",Rptrowid),"^",13)
	    ........i GetVerifyTime'="" s GetVerifyTime=$zt(GetVerifyTime,3)
	    ........s GetStudyDescDR=$p(^DHCRBStudy("Report",Rptrowid),"^",17)
	    ........i GetStudyDescDR'="" s GetStudyWay=$p(^DHCRBStudy("StudyDesc",GetStudyDescDR),"^",7)
	    ........s GetIsKYBL=$p(^DHCRBStudy("Report",Rptrowid),"^",21)
	    ........s GetIsTSBL=$p(^DHCRBStudy("Report",Rptrowid),"^",22)
	    ........s GetExamDesc=$p(^DHCRBStudy("Report",Rptrowid),"^",5)
	    ........s GetResultDesc=$p(^DHCRBStudy("Report",Rptrowid),"^",6)
	    ........i (InStudyStatusCode="")!(GetPatientStatusCode=InStudyStatusCode) d
	    .........s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
	    .........s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
	    .........s bOut="Y"
	    .........Do OutRow6
	    ......i (bOut="N")&(InStudyStatusCode="")!(GetPatientStatusCode=InStudyStatusCode) d
	    .......s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
	    .......s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
	    .......s bOut="Y"
	    .......Do OutRow6
	    s GetName=$o(^PAPERi("PAPER_PatName",GetName)) 
	}while ((GetName'="")&(flag'="Y"))
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
OutRow6
    s RecLoc=""
    i reploc'="" d
    .s RecLoc=$p(^CTLOC(reploc),"^",2)

  	s Required=""
   	if (GetSGroupDesc="无需预约")!(GetstrOrderName["床旁") s Required="N"
   	set Data=$lb(GetRegNo,GetNameL,GetSexDesc,GetstrAge,GetstrDOB,GetIDCDesc,
   	 GetStudyNo,GetstrOrderName,Getrequestdoc,GetstrAccessionNum,GetstrDate,GetstrTime,strRppDate,strRppTime,GetBookedDuration,GetstrRegDate,GetstrRegTime,GetRptDocName,GetVerifyDocName,GetPatientStatus,paadmdr,oeorditemdr, 	 
   	 GetLocName,GetTotalPrice,GetPatientStatusCode,Getbilled,Gettypedesc,GetNum,Getprice,GetIndex,GetEQDesc,GetResDesc,Getifbed,GetReportStatus,GetMainDoc,GetAssDoc,GetRoomDesc,GetEQGroupDesc,GetWardName,GetOldNo,Required,strXDate,GetItemStatusCode,PapatmasDR,BodyDesc,Weight,TelNo,GetIPNo,FileSent,GetBedNo,ReportSend,HaveImage,reploc,RecLoc,AutoInputFee,EndInputFee,Detail,RejectAppReason,BilledDesc,PinYin,ToDayOeItem,CostRecords,AppDate,BookedUser,PaymentDoc,GetPlatStatus,Epissubtype)
   	Set ^CacheTemp(repid,ind)=Data
   	s ^DHCRisTmpPrintData123(ind)=GetRegNo_"^"_GetNameL_"^"_GetSexDesc_"^"_GetstrAge_"^"_GetWardName_"^"_GetBedNo_"^"_GetStudyNo_"^"_$g(ReportSend)
   	s ^DHCRisTmpPrintData123=ind
	Set ind=ind+1
 	quit
}

ClassMethod QueryByOldNo(ExmLocID, RoomDR, DeviceDR, PatTypeDR, InRegNo, StudyID, InName, InSexDR, Age, InStudyStatusCode, InRptStatusCode, StdDate, EndDate, OrderItemDR, StudyWay, InReqLocDR, RptDesc, RptDiagnose, RptDocDR, VerifyDocDR, IsYX, IsDXBL, IsKYBL, zyh, WardDR, InEQGroupDR, InOldNo, InIsFindDate, BookedType, IsUItem, IsCostRecords)
{
	s Nodr=0 f  s Nodr=$o(^DHCPACRegInfoNOi("No",1,InOldNo,Nodr)) q:Nodr=""  d
	.s Regrowid=0 f  s Regrowid=$o(^DHCPACRegInfoi("No",Nodr,Regrowid)) q:Regrowid=""  d   
	..s bOut="N"  ;是否已经输出
    ..s GetPatientStatusCode="I"
    ..s Detail="明细",RejectAppReason="拒绝原因",ToDayOeItem="",CostRecords="",BookedUser="",PaymentDoc=""
    ..s ExterFalg=""
    ..s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfobyrowid(Regrowid)
    ..s GetStudyNo=$p(RegInfo,"^",1)
    ..s GetstrRegDate=$p(RegInfo,"^",2)
    ..s GetstrRegTime=$p(RegInfo,"^",3)
    ..s GetIndex=$p(RegInfo,"^",4)
    ..s GetEQDesc=$p(RegInfo,"^",5)
    ..s GetMainDoc=$p(RegInfo,"^",6)
    ..s GetAssDoc=$p(RegInfo,"^",7)
    ..s Oeorditemdr=$p(RegInfo,"^",8)
    ..s paadmdr=$p(RegInfo,"^",9)
    ..s GetRoomDesc=$p(RegInfo,"^",10)
    ..s GetRoomDr=$p(RegInfo,"^",12)
    ..s GetEQDr=$p(RegInfo,"^",11)
    ..s GetEQGroupDesc=$p(RegInfo,"^",13)
    ..s GetEQGroupDR=$p(RegInfo,"^",14)
    ..s GetOldNo=$p(RegInfo,"^",15)
    ..;s BodyDesc=$p(RegInfo,"^",16)
    ..s GetRegDate=$p(RegInfo,"^",16)
    ..q:(InIsFindDate="true")&(GetRegDate<StdDate)!(GetRegDate>EndDate)
    ..s FileSent=##class(web.DHCRisWorkBenchDoEx).GetFilmSendDesc(GetStudyNo)
    ..s ReportSend=##class(web.DHCRisWorkBenchDoEx).GetReportSend(GetStudyNo)
    ..s OrderRowid=$p(Oeorditemdr,"||",1)
    ..s itemsub=$p(Oeorditemdr,"||",2)
    ..s strXDate="",AppDate=""
    ..s AppRowid=$o(^DHCRBAppi("OrdRowid",Oeorditemdr,0)) 
    ..i AppRowid'="" d
    ...s XDate=$p( ^DHCRBApp("Bill",AppRowid),"^",10)
    ...s strXDate=$zd(XDate,3)
    ...s AppDate=$p(^DHCRBApp("Bill",AppRowid),"^",1)
    ...i AppDate'="" s AppDate=$zd(AppDate,3)
    ...s AppTime=$p(^DHCRBApp("Bill",AppRowid),"^",8)
    ...i AppTime'="" s AppTime=$zt(AppTime)
    ...s AppDate=AppDate_" "_AppTime
    ..s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
    ..s GetRegNo=$p(PatInfo,"^",1)
    ..s GetName=$p(PatInfo,"^",2)
    ..s GetstrDOB=$p(PatInfo,"^",3)
    ..s GetstrAge=$p(PatInfo,"^",4)
    ..s GetstrAge=$p(GetstrAge," ")
 	..s GetSexDesc=$p(PatInfo,"^",5)
    ..s Getpatienttype=$p(PatInfo,"^",6)
    ..s Gettypedesc=$p(PatInfo,"^",7)
    ..s GetLocName=$p(PatInfo,"^",8)
    ..s GetIPNo=$p(PatInfo,"^",9)       ;住院号
    ..s GetWardName=$p(PatInfo,"^",10)
    ..s GetBedNo=$p(PatInfo,"^",11)
    ..s GetReqLocDR=$p(PatInfo,"^",12)
    ..s GetWardDR=$p(PatInfo,"^",14)
    ..s Getroomdesc=$p(PatInfo,"^",15)
    ..s GetSexDr=$p(PatInfo,"^",13)
    ..s PapatmasDR=$p(PatInfo,"^",24)
    ..s Weight=$p(PatInfo,"^",21)
	..s TelNo=$p(PatInfo,"^",19)
	..s PinYin=$p(PatInfo,"^",38)
	..s Epissubtype=$p($g(PatInfo),"^",41)
    ..s OrderRowid=$p(Oeorditemdr,"||",1)
    ..s itemsub=$p(Oeorditemdr,"||",2)
    ..s GetResDesc="",strRppDate="",strRppTime=""
    ..s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(OrderRowid,itemsub)
    ..s GetstrOrderName=$p(ordInfo,"^",1)
    ..s GetstrDate=$p(ordInfo,"^",2)
    ..s GetstrTime=$p(ordInfo,"^",3)
    ..s Getrequestdoc=$p(ordInfo,"^",4)
    ..s GetstrAccessionNum=$p(ordInfo,"^",5)
    ..s GetSGroupDesc=$p(ordInfo,"^",6)    ;是否需要预约项目的标记
    ..s GetsubCatDesc=$p(ordInfo,"^",7)
    ..s GetCatDesc=$p(ordInfo,"^",8)
    ..s Getifbed=$p(ordInfo,"^",9)
    ..s Getprice=$p(ordInfo,"^",10)
    ..s GetNum=$p(ordInfo,"^",11)
    ..s GetTotalPrice=$p(ordInfo,"^",12)
    ..s Getbilled=$p(ordInfo,"^",13)
    ..s GetItemStatusCode=$p(ordInfo,"^",14)
    ..s GetordDate=$p(ordInfo,"^",15)
    ..s GetordTime=$p(ordInfo,"^",16)
    ..s GetItemStatusCode=$p(ordInfo,"^",17)   			;医嘱状态
    ..q:((GetItemStatusCode="U")&(IsUItem'="Y"))!(GetItemStatusCode="D")!(GetItemStatusCode="I")
    ..s GetServerMaterial=$p(ordInfo,"^",18)   			;申请项目标记
    ..s AutoInputFee=$p(ordInfo,"^",25) ;"需要另划价标志"
    ..s EndInputFee=$p(ordInfo,"^",26)  ;"已另划价标识"
    ..s BilledDesc=$p(ordInfo,"^",27)
    ..s BodyDesc=$p(ordInfo,"^",29)
    ..s CheckEntryFlag=$p(ordInfo,"^",30)
    ..s BookedUser=$p(ordInfo,"^",31)
    ..s GetPaymentDoc=$p(ordInfo,"^",33) ;补录操作员
    ..s GetPlatStatus=$p(ordInfo,"^",34) ;平台状态
    ..q:(IsCostRecords'="Y")&(CheckEntryFlag="Y") 
    ..i CheckEntryFlag="Y" s CostRecords="已补录"  s PaymentDoc=GetPaymentDoc
    ..;s ResultFlag=$p(ordInfo,"^",20)    ;医嘱的结果状态--------------安贞医院用以前MEDTRAK 的结果处理，处理的的报告，在技师工作站中不在显示
    ..;q:ResultFlag="V"
    ..s GetResDesc="",strRppDate="",strRppTime="",GetBookedDuration="",GetPatientStatusCode=""
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
    ....s GetBookedDuration=$p(^RBAS(ResRowid,SchildSub,"APPT",appointchildsub),"^",23) 
    ..s ExterFalg=..IsExternalBooked(Oeorditemdr)
    ..i ExterFalg="Y" d
    ...s GetPatientStatusCode="B"
    ...s strRppDate=$p($g(^DHCRISBOOKEDINFO(Oeorditemdr)),"^",2)
    ...s strRppTime=$p($g(^DHCRISBOOKEDINFO(Oeorditemdr)),"^",3)
    ..s GetReportStatusCode="N"     ;未写报告
    ..s GetImgcount=0
    ..s GetRptID=""
    ..s GetRptDocDR="",GetRptDocName="",GetRptDate="",GetRptTime="",GetVerifyDocDR=""
    ..s GetVerifyDocName="",GetVerifyDate="",GetVerifyTime="",GetStudyDescDR=""
    ..s GetStudyWay="",GetBodyPartDR="",GetIsKYBL="",GetIsTSBL="",GetResultDesc="",GetExamDesc=""
    ..s GetIndex="",GetEQDr="",GetEQDesc="",GetRoomDesc="",GetEQGroupDR="",HaveImage=""
    ..s GetRptIsYX=""
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
    ....s GetRptStatusDesc=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",2)
    ....s GetReportStatusCode=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",1)
    ....i ReportStuatCode[GetReportStatusCode d
    .....s GetPatientStatusCode="O"
    ....e  d
    .....s GetPatientStatusCode="E"
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
    ...s GetStudyDescDR=$p(^DHCRBStudy("Report",Rptrowid),"^",17)
    ...i GetStudyDescDR'="" s GetStudyWay=$p(^DHCRBStudy("StudyDesc",GetStudyDescDR),"^",7)
    ...;s GetBodyPartDR=$p(^DHCRBStudy("Report",Rptrowid),"^",19)
    ...s GetIsKYBL=$p(^DHCRBStudy("Report",Rptrowid),"^",21)
    ...s GetIsTSBL=$p(^DHCRBStudy("Report",Rptrowid),"^",22)
    ...s GetExamDesc=$p(^DHCRBStudy("Report",Rptrowid),"^",5)
    ...s GetResultDesc=$p(^DHCRBStudy("Report",Rptrowid),"^",6)
    ...s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
    ...s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
    ...s bOut="Y"
    ...Do OutRowz4
    ..i bOut="N" d
    ...s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
    ...s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
    ...s bOut="Y"
    ...Do OutRowz4
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
OutRowz4
	s Required=""
   	if (GetSGroupDesc="无需预约")!(GetstrOrderName["床旁") s Required="N"
   	set Data=$lb(GetRegNo,GetName,GetSexDesc,GetstrAge,GetstrDOB,GetIDCDesc,
   	 GetStudyNo,GetstrOrderName,Getrequestdoc,GetstrAccessionNum,GetstrDate,GetstrTime,strRppDate,strRppTime,$g(GetBookedDuration),GetstrRegDate,GetstrRegTime,GetRptDocName,GetVerifyDocName,GetPatientStatus,paadmdr,oeorditemdr, 	 
   	 GetLocName,GetTotalPrice,GetPatientStatusCode,Getbilled,Gettypedesc,GetNum,Getprice,GetIndex,GetEQDesc,GetResDesc,Getifbed,GetReportStatus,GetMainDoc,GetAssDoc,GetRoomDesc,GetEQGroupDesc,GetWardName,GetOldNo,Required,strXDate,GetItemStatusCode,PapatmasDR,BodyDesc,Weight,TelNo,GetIPNo,FileSent,GetBedNo,ReportSend,HaveImage,$g(InLocID),RecLoc,AutoInputFee,EndInputFee,Detail,RejectAppReason,BilledDesc,PinYin,ToDayOeItem,CostRecords,AppDate,BookedUser,PaymentDoc,GetPlatStatus,Epissubtype)
     Set ^CacheTemp(repid,ind)=Data
     s ^DHCRisTmpPrintData123(ind)=GetRegNo_"^"_GetName_"^"_GetSexDesc_"^"_GetstrAge_"^"_GetWardName_"^"_GetBedNo_"^"_GetStudyNo_"^"_$g(ReportSend)
   	 s ^DHCRisTmpPrintData123=ind

	Set ind=ind+1
 	quit
}

ClassMethod QueryBookedItem(Intype, InStatusCode, Inpaadmdr, InAppStDate, InLocID, InResourceID, InReportDoc, InReportVerifyDoc, InIsBedOrd, InRoomDR, InRegEQDR, InRequireAppoint, InRegNo, InStudyNo, InName, InPatientNo, InAppLocDR, InEQGroupDR, InWardDR, InNO, IsFilmSet, BookedType, IsUItem, IsCostRecords, IsBilled) As %Integer
{
	 ;w !,"BookedType="_BookedType
	 
	 s Detail="明细",RejectAppReason="",ToDayOeItem="",CostRecords=""
	 k ^DHCRISTMEP("TEMPITEMROWID")
	 if BookedType="1" d
	 .Set RowId="" f  s RowId=$o(^RB("RES",0,"CTLOC",InLocID,RowId) ) q:RowId=""  d
	 ..s ResDesc=""
	 ..s CTCPDR=$p($g(^RB("RES",RowId)),"^",2)
	 ..i CTCPDR'="" d
	 ...s GetResDesc=$p($g(^CTPCP(CTCPDR,1)),"^",2)
	 ..else  d
	 ...s EQDR=$p($g(^RB("RES",RowId)),"^",3)
	 ...i EQDR'="" s GetResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
	 ..q:(InResourceID'="")&(InResourceID'=RowId)
	 ..s SchRowid=0 f  s SchRowid=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",InLocID,InAppStDate,RowId,SchRowid)) q:SchRowid=""  d
	 ...s DetailRowid=0  f  s DetailRowid=$o(^DHCRBCResSchduleDetaili("SchudleId",SchRowid,DetailRowid)) q:DetailRowid=""  d
	 ....s oeorditemdr=$p(^DHCRBCResSchduleDetail("Detail",DetailRowid),"^",1)
	 ....q:($g(^DHCRISTMEP("TEMPITEMROWID"))=oeorditemdr)
	 ....s ^DHCRISTMEP("TEMPITEMROWID")=oeorditemdr
	 ....;w !,"oeorditemdr="_oeorditemdr
	 ....s GetPaadmr=$p(^DHCRBCResSchduleDetail("Detail",DetailRowid),"^",3)
	 ....s AppRowid=$o(^DHCRBAppi("OrdRowid",oeorditemdr,0)) 
	 ....i AppRowid'="" d
	 .....s AppDate=""
	 .....s XDate=$p(^DHCRBApp("Bill",AppRowid),"^",10)
	 .....s strXDate=$zd(XDate,3)
	 .....s AppDate=$p($g(^DHCRBApp("Bill",AppRowid)),"^",1)
     .....i AppDate'="" s AppDate=$zd(AppDate,3)
     .....s AppTime=$p(^DHCRBApp("Bill",AppRowid),"^",8)
     .....i AppTime'="" s AppTime=$zt(AppTime)
     .....s AppDate=AppDate_" "_AppTime
	 ....q:(Inpaadmdr'="")&(GetPaadmr'=Inpaadmdr)
	 ....s papatmasmdr=$p(^PAADM(GetPaadmr),"^",1)  
	 ....s AppointDate=$p(^DHCRBCResourceSchdule(SchRowid),"^",2)
	 ....s GetAppointDate=$zd(AppointDate,3)
	 ....s AppointstTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",5)
	 ....s GetAppointstTime=$zt(AppointstTime,1)
	 ....;get patient diagnose 
	 ....s GetIDCDesc=""
	 ....s GetIDCDesc=##class(web.DHCRisCommFunctionEx).GetDiagnose(GetPaadmr)
	 ....s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(GetPaadmr)
	 ....s GetRegNo=$p(PatInfo,"^",1)
	 ....s GetName=$p(PatInfo,"^",2)
	 ....s GetstrDOB=$p(PatInfo,"^",3)
	 ....s GetstrAge=$p(PatInfo,"^",4)
	 ....s GetSexDesc=$p(PatInfo,"^",5)
	 ....s Getpatienttype=$p(PatInfo,"^",6)
	 ....s Gettypedesc=$p(PatInfo,"^",7)
	 ....s GetLocName=$p(PatInfo,"^",8)
	 ....s GetIPNo=$p(PatInfo,"^",9)
	 ....s GetWardName=$p(PatInfo,"^",10)
	 ....s GetBedNo=$p(PatInfo,"^",11)
	 ....s GetLocdr=$p(PatInfo,"^",12)
	 ....s GetWardDr=$p(PatInfo,"^",14)
	 ....s PapatmasDR=$p(PatInfo,"^",24)
	 ....s Weight=$p(PatInfo,"^",21)
	 ....s TelNo=$p(PatInfo,"^",19)
	 ....s PinYin=$p(PatInfo,"^",38)
	 ....s Epissubtype=$p($g(PatInfo),"^",41)
	 ....q:(InWardDR'="")&(GetWardDr'=InWardDR)
	 ....q:(InRegNo'="")&(GetRegNo'=InRegNo)
	 ....q:(InName'="")&(GetName'[InName)
	 ....q:(InPatientNo'="")&(InPatientNo'=GetIPNo)
	 ....q:(InAppLocDR'="")&(GetLocdr'=InAppLocDR)
	 ....q:(Intype'="")&(Intype'=Getpatienttype)
	 ....s ordrowid=$p(oeorditemdr,"||",1)
	 ....s orditemchildsub=$p(oeorditemdr,"||",2)
	 ....s BookedUser="",PaymentDoc=""
	 ....s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(ordrowid,orditemchildsub)
	 ....s GetstrOrderName=$p(ordInfo,"^",1)
	 ....s GetstrDate=$p(ordInfo,"^",2)
	 ....s GetstrTime=$p(ordInfo,"^",3)
	 ....s Getrequestdoc=$p(ordInfo,"^",4)
	 ....s GetstrAccessionNum=$p(ordInfo,"^",5)
	 ....s GetSGroupDesc=$p(ordInfo,"^",6)
	 ....s GetsubCatDesc=$p(ordInfo,"^",7)
	 ....s GetCatDesc=$p(ordInfo,"^",8)
	 ....s Getifbed=$p(ordInfo,"^",9)
	 ....s Getprice=$p(ordInfo,"^",10)
	 ....s GetNum=$p(ordInfo,"^",11)
	 ....s GetTotalPrice=$p(ordInfo,"^",12)
	 ....s Getbilled=$p(ordInfo,"^",13)
	 ....s GetItemStatusCode=$p(ordInfo,"^",14)
	 ....s GetordDate=$p(ordInfo,"^",15)
	 ....s GetordTime=$p(ordInfo,"^",16)
	 ....s GetItemStatusCode=$p(ordInfo,"^",17)
	 ....q:((GetItemStatusCode="U")&(IsUItem'="Y"))!(GetItemStatusCode="D")!(GetItemStatusCode="I")
	 ....;q:(IsBilled'="Y")&(Getbilled="P")   ;xzy-2013-4-27 将已收费的显示出来
	 ....s AutoInputFee=$p(ordInfo,"^",25) ;"需要另划价标志"
	 ....s EndInputFee=$p(ordInfo,"^",26)  ;"已另划价标识"
	 ....s BilledDesc=$p(ordInfo,"^",27)
	 ....s BodyDesc=$p(ordInfo,"^",29)
	 ....s CheckEntryFlag="",CostRecords=""
	 ....s CheckEntryFlag=$p(ordInfo,"^",30)
	 ....s BookedUser=$p(ordInfo,"^",31) 
	 ....s GetPaymentDoc=$p(ordInfo,"^",33) ;补录操作员
	 ....s GetPlatStatus=$p(ordInfo,"^",34) ;平台状态
	 ....q:(IsCostRecords'="Y")&(CheckEntryFlag="Y") 
     ....i CheckEntryFlag="Y" s CostRecords="已补录" s PaymentDoc=GetPaymentDoc
	 ....s ResultFlag=$p(ordInfo,"^",20)    ;医嘱的结果状态--------------安贞医院用以前MEDTRAK 的结果处理，处理的的报告，在技师工作站中不在显示
	 ....;q:ResultFlag="V"
	 ....q:(InIsBedOrd="Y")&(Getifbed'="Y")  ;检索床旁医嘱，不是床旁医嘱
	 ....s GetPatientStatusCode="B"
	 ....s GetReportStatusCode="N"  ;未写报告
	 ....s GetstrRegDate="",GetstrRegTime="",GetRptDocName="",GetVerifyDocName="",GetStudyNo="",GetIndex="",GetEQDesc=""
	 ....s GetEQDr="",GetMainDoc="",GetAssDoc="",GetRoomDesc="",GetRoomDr="",GetEQGroupDR=""
	 ....s bOut="N",FileSent="",HaveImage="" ;,BodyDesc=""
	 ....;i (GetItemStatusCode="E") d
	 ....;s GetPatientStatusCode="I"  ;登记
	 ....s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfo(oeorditemdr)
	 ....s GetStudyNo=$p(RegInfo,"^",1)
	 ....i GetStudyNo'="" d
	 .....s GetPatientStatusCode="I"  ;登记
	 .....s GetstrRegDate=$p(RegInfo,"^",2)
	 .....s GetstrRegTime=$p(RegInfo,"^",3)
	 .....s GetIndex=$p(RegInfo,"^",4)
	 .....s GetEQDesc=$p(RegInfo,"^",5)
	 .....s GetMainDoc=$p(RegInfo,"^",6)
	 .....s GetAssDoc=$p(RegInfo,"^",7)
	 .....s GetRoomDesc=$p(RegInfo,"^",8)
	 .....s GetRoomDr=$p(RegInfo,"^",9)
	 .....s GetEQDr=$p(RegInfo,"^",10)
	 .....s GetEQGroupDesc=$p(RegInfo,"^",11)
	 .....s GetEQGroupDR=$p(RegInfo,"^",12)
	 .....s NO=$p(RegInfo,"^",13)
	 .....;s BodyDesc=$p(RegInfo,"^",17)
	 .....s FileSent=##class(web.DHCRisWorkBenchDoEx).GetFilmSendDesc(GetStudyNo)
	 .....s ReportSend=##class(web.DHCRisWorkBenchDoEx).GetReportSend(GetStudyNo)
	 .....s GetImgcount=0
	 .....s Imrowid=0 f  s Imrowid=$o(^DHCRBStudyi("StudyNo-Images",GetStudyNo,Imrowid)) q:Imrowid=""  d
	 ......s GetPatientStatusCode="E"    ;正在检查
	 ......s ExtName=$p($g(^DHCRBStudy(0,"StudyImages",Imrowid)),"^",2)
	 ......i ((ExtName="avi")!(ExtName="dcm")!(ExtName="normal")!(ExtName="dsa"))  d
	 .......s GetImgcount=GetImgcount+1
	 .......s ReportStatusCode="I"             ;图象已经采集
	 .......s HaveImage="是"
	 .....s sReportStuatCode="VS"
	 .....s Rptrowid=0  f  s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",GetStudyNo,Rptrowid)) q:Rptrowid=""  d
	 ......s GetRptID=$p(^DHCRBStudy("Report",Rptrowid),"^",2)
	 ......s GetRptVersion=$p(^DHCRBStudy("Report",Rptrowid),"^",3)
	 ......s GetRptStatusDR=$p(^DHCRBStudy("Report",Rptrowid),"^",4)
	 ......i GetRptStatusDR'="" d
	 .......s GetReportStatusCode=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",1)
	 .......i sReportStuatCode[GetReportStatusCode d
	 ........s GetPatientStatusCode="O"
	 .......e  d
	 ........s GetPatientStatusCode="E"
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
	 ......i ((IsFilmSet="false")!((IsFilmSet="true")&(FileSent="已发片")))&((InStudyNo="")!(GetStudyNo=InStudyNo))&((InEQGroupDR="")!(GetEQGroupDR=InEQGroupDR))&((InRoomDR="")!(GetRoomDr=InRoomDR))&((InRegEQDR="")!(InRegEQDR=GetEQDr))&((InStatusCode="")!(InStatusCode[GetPatientStatusCode))&((InReportDoc="")!(InReportDoc=GetRptDocName))&((InVerifyDOc="")!(InVerifyDOc=GetVerifyDocName)) d 
	 .......s PatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
	 .......s ReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
	 .......s bOut="Y"
	 .......Do OutRowA
	 ....i ((IsFilmSet="false")!((IsFilmSet="true")&(FileSent="已发片")))&((InStudyNo="")!(GetStudyNo=InStudyNo))&((InEQGroupDR="")!(GetEQGroupDR=InEQGroupDR))&((InRoomDR="")!(GetRoomDr=InRoomDR))&((InRegEQDR="")!(InRegEQDR=GetEQDr))&((InStatusCode="")!(InStatusCode[GetPatientStatusCode))&((InReportDoc="")!(InReportDoc=GetRptDocName))&((InVerifyDOc="")!(InVerifyDOc=GetVerifyDocName))&(bOut="N") d 
	 .....s PatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
	 .....s ReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
	 .....s bOut="Y"
	 .....Do OutRowA
	 else  d
	 .Set RowId="" f  s RowId=$o(^RB("RES",0,"CTLOC",InLocID,RowId) ) q:RowId=""  d
	 ..s ResDesc=""
	 ..s CTCPDR=$p($g(^RB("RES",RowId)),"^",2)
	 ..i CTCPDR'="" d
	 ...s GetResDesc=$p($g(^CTPCP(CTCPDR,1)),"^",2)
	 ..else  d
	 ...s EQDR=$p($g(^RB("RES",RowId)),"^",3)
	 ...i EQDR'="" s GetResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
	 ..q:(InResourceID'="")&(InResourceID'=RowId)
	 ..s session=0
	 ..;RB_ApptSchedule
	 ..f  s session=$o(^RBAS(RowId,0,"DateSTime",InAppStDate,session)) q:session=""  d
	 ...s childsub=0 f  s childsub=$o(^RBAS(RowId,0,"DateSTime",InAppStDate,session,childsub)) q:childsub=""  d
	 ....s apptschinfo=^RBAS(RowId,childsub)
	 ....s AppointDate=$p(apptschinfo,"^",1)
	 ....q:AppointDate'=InAppStDate
	 ....s GetAppointDate=$zd(AppointDate,3)
	 ....s AppointstTime=$p(apptschinfo,"^",4)
	 ....s GetAppointstTime=$zt(AppointstTime,1)
	 ....s ApptRowid=RowId_"||"_childsub
	 ....; RB_Appointment
	 ....s appointchildsub=0  f  s appointchildsub=$o(^RBAS(RowId,childsub,"APPT",appointchildsub)) q:appointchildsub=""  d
	 .....s apppintrowid=ApptRowid_"||"_appointchildsub
	 .....s ordrowid=0 
	 .....s GetBookedDuration=$p(^RBAS(RowId,childsub,"APPT",appointchildsub),"^",23) 
	 .....s ordrowid=$o(^OEORDi(0,"Appt",apppintrowid,ordrowid))
	 .....; 根据预约的时间点找医嘱
	 .....i ordrowid'=""  d
	 ......s orditemchildsub=0  
	 ......s orditemchildsub=$o(^OEORDi(0,"Appt",apppintrowid,ordrowid,orditemchildsub))
	 ......s oeorditemdr=ordrowid_"||"_orditemchildsub
	 ......s strXDate="",AppDate=""
	 ......s AppRowid=$o(^DHCRBAppi("OrdRowid",oeorditemdr,0)) 
	 ......i AppRowid'="" d
	 .......s XDate=$p(^DHCRBApp("Bill",AppRowid),"^",10)
	 .......s strXDate=$zd(XDate,3)
	 .......s AppDate=$p($g(^DHCRBApp("Bill",AppRowid)),"^",1)
     .......i AppDate'="" s AppDate=$zd(AppDate,3)
     .......s AppTime=$p(^DHCRBApp("Bill",AppRowid),"^",8)
     .......i AppTime'="" s AppTime=$zt(AppTime)
     .......s AppDate=AppDate_" "_AppTime
	 ......s GetPaadmr=$p(^OEORD(ordrowid),"^",1)
	 ......q:(Inpaadmdr'="")&(GetPaadmr'=Inpaadmdr)
	 ......s papatmasmdr=$p(^PAADM(GetPaadmr),"^",1)  
	 ......;get patient diagnose 
	 ......s GetIDCDesc=""
	 ......s GetIDCDesc=##class(web.DHCRisCommFunctionEx).GetDiagnose(GetPaadmr)
	 ......s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(GetPaadmr)
	 ......s GetRegNo=$p(PatInfo,"^",1)
	 ......s GetName=$p(PatInfo,"^",2)
	 ......s GetstrDOB=$p(PatInfo,"^",3)
	 ......s GetstrAge=$p(PatInfo,"^",4)
	 ......s GetSexDesc=$p(PatInfo,"^",5)
	 ......s Getpatienttype=$p(PatInfo,"^",6)
	 ......s Gettypedesc=$p(PatInfo,"^",7)
	 ......s GetLocName=$p(PatInfo,"^",8)
	 ......s GetIPNo=$p(PatInfo,"^",9)
	 ......s GetWardName=$p(PatInfo,"^",10)
	 ......s GetBedNo=$p(PatInfo,"^",11)
	 ......s GetLocdr=$p(PatInfo,"^",12)
	 ......s GetWardDr=$p(PatInfo,"^",14)
	 ......s PapatmasDR=$p(PatInfo,"^",24)
	 ......s Weight=$p(PatInfo,"^",21)
	 ......s TelNo=$p(PatInfo,"^",19)
	 ......s PinYin=$p(PatInfo,"^",38)
	 ......s Epissubtype=$p($g(PatInfo),"^",41)
	 ......q:(InWardDR'="")&(GetWardDr'=InWardDR)
	 ......q:(InRegNo'="")&(GetRegNo'=InRegNo)
	 ......q:(InName'="")&(GetName'[InName)
	 ......q:(InPatientNo'="")&(InPatientNo'=GetIPNo)
	 ......q:(InAppLocDR'="")&(GetLocdr'=InAppLocDR)
	 ......q:(Intype'="")&(Intype'=Getpatienttype)
	 ......s BookedUser="",PaymentDoc=""
	 ......s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(ordrowid,orditemchildsub)
	 ......s GetstrOrderName=$p(ordInfo,"^",1)
	 ......s GetstrDate=$p(ordInfo,"^",2)
	 ......s GetstrTime=$p(ordInfo,"^",3)
	 ......s Getrequestdoc=$p(ordInfo,"^",4)
	 ......s GetstrAccessionNum=$p(ordInfo,"^",5)
	 ......s GetSGroupDesc=$p(ordInfo,"^",6)
	 ......s GetsubCatDesc=$p(ordInfo,"^",7)
	 ......s GetCatDesc=$p(ordInfo,"^",8)
	 ......s Getifbed=$p(ordInfo,"^",9)
	 ......s Getprice=$p(ordInfo,"^",10)
	 ......s GetNum=$p(ordInfo,"^",11)
	 ......s GetTotalPrice=$p(ordInfo,"^",12)
	 ......s Getbilled=$p(ordInfo,"^",13)
	 ......s GetItemStatusCode=$p(ordInfo,"^",14)
	 ......s GetordDate=$p(ordInfo,"^",15)
	 ......s GetordTime=$p(ordInfo,"^",16)
	 ......s GetItemStatusCode=$p(ordInfo,"^",17)
	 ......q:((GetItemStatusCode="U")&(IsUItem'="Y"))!(GetItemStatusCode="D")!(GetItemStatusCode="I")
	 ......;q:(IsBilled'="Y")&(Getbilled="P")   ;xzy-2013-4-27 将已收费的显示出来
	 ......s AutoInputFee=$p(ordInfo,"^",25) ;"需要另划价标志"
	 ......s EndInputFee=$p(ordInfo,"^",26)  ;"已另划价标识"
	 ......s BilledDesc=$p(ordInfo,"^",27)
	 ......s BodyDesc=$p(ordInfo,"^",29)
	 ......s CheckEntryFlag="",CostRecords=""
	 ......s CheckEntryFlag=$p(ordInfo,"^",30)
	 ......s BookedUser=$p(ordInfo,"^",31) 
	 ......s GetPaymentDoc=$p(ordInfo,"^",33) ;补录操作员
	 ......s GetPlatStatus=$p(ordInfo,"^",34) ;平台状态
	 ......q:(IsCostRecords'="Y")&(CheckEntryFlag="Y")
     ......i CheckEntryFlag="Y" s CostRecords="已补录" s PaymentDoc=GetPaymentDoc
	 ......;s ResultFlag=$p(ordInfo,"^",20)    ;医嘱的结果状态--------------安贞医院用以前MEDTRAK 的结果处理，处理的的报告，在技师工作站中不在显示
	 ......;q:ResultFlag="V"
	 ......q:(InIsBedOrd="Y")&(Getifbed'="Y")  ;检索床旁医嘱，不是床旁医嘱
	 ......s GetPatientStatusCode="B"
	 ......s GetReportStatusCode="N"  ;未写报告
	 ......s GetstrRegDate="",GetstrRegTime="",GetRptDocName="",GetVerifyDocName="",GetStudyNo="",GetIndex="",GetEQDesc=""
	 ......s GetEQDr="",GetMainDoc="",GetAssDoc="",GetRoomDesc="",GetRoomDr="",GetEQGroupDR=""
	 ......s bOut="N",FileSent="",HaveImage="" ;BodyDesc=""
	 ......;i (GetItemStatusCode="E") d
	 ......;s GetPatientStatusCode="I"  ;登记
	 ......s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfo(oeorditemdr)
	 ......s GetStudyNo=$p(RegInfo,"^",1)
	 ......i GetStudyNo'="" d
	 .......s GetPatientStatusCode="I"  ;登记
	 .......s GetstrRegDate=$p(RegInfo,"^",2)
	 .......s GetstrRegTime=$p(RegInfo,"^",3)
	 .......s GetIndex=$p(RegInfo,"^",4)
	 .......s GetEQDesc=$p(RegInfo,"^",5)
	 .......s GetMainDoc=$p(RegInfo,"^",6)
	 .......s GetAssDoc=$p(RegInfo,"^",7)
	 .......s GetRoomDesc=$p(RegInfo,"^",8)
	 .......s GetRoomDr=$p(RegInfo,"^",9)
	 .......s GetEQDr=$p(RegInfo,"^",10)
	 .......s GetEQGroupDesc=$p(RegInfo,"^",11)
	 .......s GetEQGroupDR=$p(RegInfo,"^",12)
	 .......s NO=$p(RegInfo,"^",13)
	 .......;s BodyDesc=$p(RegInfo,"^",17)
	 .......s FileSent=##class(web.DHCRisWorkBenchDoEx).GetFilmSendDesc(GetStudyNo)
	 .......s ReportSend=##class(web.DHCRisWorkBenchDoEx).GetReportSend(GetStudyNo)
	 .......s GetImgcount=0
	 .......s Imrowid=0 f  s Imrowid=$o(^DHCRBStudyi("StudyNo-Images",GetStudyNo,Imrowid)) q:Imrowid=""  d
	 ........s GetPatientStatusCode="E"    ;正在检查
	 ........s ExtName=$p($g(^DHCRBStudy(0,"StudyImages",Imrowid)),"^",2)
	 ........i ((ExtName="avi")!(ExtName="dcm")!(ExtName="normal")!(ExtName="dsa"))  d
	 .........s GetImgcount=GetImgcount+1
	 .........s ReportStatusCode="I"             ;图象已经采集
	 .........s HaveImage="是"
	 .......s sReportStuatCode="VS"
	 .......s Rptrowid=0  f  s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",GetStudyNo,Rptrowid)) q:Rptrowid=""  d
	 ........s GetRptID=$p(^DHCRBStudy("Report",Rptrowid),"^",2)
	 ........s GetRptVersion=$p(^DHCRBStudy("Report",Rptrowid),"^",3)
	 ........s GetRptStatusDR=$p(^DHCRBStudy("Report",Rptrowid),"^",4)
	 ........i GetRptStatusDR'="" d
	 .........s GetReportStatusCode=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",1)
	 .........i sReportStuatCode[GetReportStatusCode d
	 ..........s GetPatientStatusCode="O"
	 .........e  d
	 ..........s GetPatientStatusCode="E"
	 ........s GetRptDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",8)
	 ........i GetRptDocDR'="" s GetRptDocName=$p(^SSU("SSUSR",GetRptDocDR),"^",2)
	 ........s GetRptDate=$p(^DHCRBStudy("Report",Rptrowid),"^",9)
	 ........i GetRptDate'="" s GetRptDate=$zd(GetRptDate,3)
	 ........s GetRptTime=$p(^DHCRBStudy("Report",Rptrowid),"^",10)
	 ........i GetRptTime'="" s GetRptTime=$zt(GetRptTime,3)
	 ........s GetVerifyDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",11)
	 ........i GetVerifyDocDR'="" s GetVerifyDocName=$p(^SSU("SSUSR",GetVerifyDocDR),"^",2)
	 ........s GetVerifyDate=$p(^DHCRBStudy("Report",Rptrowid),"^",12)
	 ........i GetVerifyDate'="" s GetVerifyDate=$zd(GetVerifyDate,3) 
	 ........s GetVerifyTime=$p(^DHCRBStudy("Report",Rptrowid),"^",13)
	 ........i GetVerifyTime'="" s GetVerifyTime=$zt(GetVerifyTime,3)
	 ........i ((IsFilmSet="false")!((IsFilmSet="true")&(FileSent="已发片")))&((InStudyNo="")!(GetStudyNo=InStudyNo))&((InEQGroupDR="")!(GetEQGroupDR=InEQGroupDR))&((InRoomDR="")!(GetRoomDr=InRoomDR))&((InRegEQDR="")!(InRegEQDR=GetEQDr))&((InStatusCode="")!(InStatusCode[GetPatientStatusCode))&((InReportDoc="")!(InReportDoc=GetRptDocName))&((InVerifyDOc="")!(InVerifyDOc=GetVerifyDocName)) d 
	 .........s PatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
	 .........s ReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
	 .........s bOut="Y"
	 .........Do OutRowA
	 ......i ((IsFilmSet="false")!((IsFilmSet="true")&(FileSent="已发片")))&((InStudyNo="")!(GetStudyNo=InStudyNo))&((InEQGroupDR="")!(GetEQGroupDR=InEQGroupDR))&((InRoomDR="")!(GetRoomDr=InRoomDR))&((InRegEQDR="")!(InRegEQDR=GetEQDr))&((InStatusCode="")!(InStatusCode[GetPatientStatusCode))&((InReportDoc="")!(InReportDoc=GetRptDocName))&((InVerifyDOc="")!(InVerifyDOc=GetVerifyDocName))&(bOut="N") d 
	 .......s PatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
	 .......s ReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
	 .......s bOut="Y"
	 .......Do OutRowA
	 Set qHandle=$lb(0,repid,0)
	 Quit $$$OK
OutRowA
    s RecLoc=""
    i InLocID'="" d
    .s RecLoc=$p(^CTLOC(InLocID),"^",2)
     s Required="Y"
     set Data=$lb(GetRegNo,GetName,GetSexDesc,GetstrAge,GetstrDOB,GetIDCDesc,GetStudyNo,GetstrOrderName,Getrequestdoc,GetstrAccessionNum,GetstrDate,GetstrTime,GetAppointDate,GetAppointstTime,$g(GetBookedDuration),GetstrRegDate,GetstrRegTime,GetReportDoc,GetReportVerifyDoc,PatientStatus,GetPaadmr,oeorditemdr,GetLocName,GetTotalPrice,GetPatientStatusCode,Getbilled,Gettypedesc,GetNum,Getprice,GetIndex,GetEQDesc,GetResDesc,Getifbed,ReportStatus,GetMainDoc,GetAssDoc,GetRoomDesc,GetEQGroupDesc,GetWardName,NO,Required,strXDate,GetItemStatusCode,PapatmasDR,$g(BodyDesc),Weight,TelNo,GetIPNo,FileSent,GetBedNo,ReportSend,HaveImage,InLocID,RecLoc,AutoInputFee,EndInputFee,Detail,RejectAppReason,BilledDesc,PinYin,ToDayOeItem,CostRecords,AppDate,BookedUser,PaymentDoc,GetPlatStatus,Epissubtype)
    Set ^CacheTemp(repid,ind)=Data
    s ^DHCRisTmpPrintData123(ind)=GetRegNo_"^"_GetName_"^"_GetSexDesc_"^"_GetstrAge_"^"_GetWardName_"^"_GetBedNo_"^"_GetStudyNo_"^"_$g(ReportSend)
   	s ^DHCRisTmpPrintData123=ind
	Set ind=ind+1
 	quit
}

/// 函数名称：GetFilmSendDesc
/// 功能：获得检查的发片状态
/// 参数：检查号
/// 返回：状态
/// 作者：龚平
/// 日期：2007-03-09
/// ##class(web.DHCRisWorkBenchDoEx).GetFilmSendDesc(StudyNo)
ClassMethod GetFilmSendDesc(StudyNo)
{
	s SendFilmDesc=""
	s studydescrowid=$o(^DHCRBStudyi("StudyDesc","StudyNo",StudyNo,0))
	i studydescrowid'="" d
	.s SendFilmDesc=$p(^DHCRBStudy("StudyDesc",studydescrowid),"^",13)
	q SendFilmDesc
}

/// 函数名称：GetReportSend
/// 功能：获得报告列表的打印状态
/// 参数：检查号
/// 返回：状态
/// 作者：龚平
/// 日期：2007-03-09
/// ##class(web.DHCRisWorkBenchDoEx).GetFilmSendDesc(StudyNo)
ClassMethod GetReportSend(StudyNo)
{
	s GetReportSend=""
	s studydescrowid=$o(^DHCRBStudyi("StudyDesc","StudyNo",StudyNo,0))
	i studydescrowid'="" d
	.s GetReportSend=$p(^DHCRBStudy("StudyDesc",studydescrowid),"^",14)
	q GetReportSend
}

/// 函数名称：SendFilm
/// 功能：实现发片操作
/// 参数：
/// 返回：状态
/// 作者：龚平
/// 日期：2007-03-09
ClassMethod SendFilm(StudyNo, Desc) As %String
{
  s ^SendF=StudyNo_"^"_Desc
  s studydescrowid=$o(^DHCRBStudyi("StudyDesc","StudyNo",StudyNo,0))
  i studydescrowid="" d
   .&sql(insert into DHCRB_StudyDesc(DRSD_StudyNo,DRSD_FilmSent) values (:StudyNo,:Desc))
  else  d
   .&sql(update DHCRB_StudyDesc set DRSD_FilmSent=:Desc where DRSD_StudyNo=:StudyNo)
  q SQLCODE
}

ClassMethod SetConditionInfo(Info, Userid)
{
	s ^DHCRisLookupCondition(Userid)=Info
}

ClassMethod GetConditionInfo(Userid) As %String
{
	 quit $g(^DHCRisLookupCondition(Userid))
}

ClassMethod CancelConditionInfo(Userid)
{
	 k ^DHCRisLookupCondition(Userid)
}

ClassMethod ExectueBilledOrder(Info, userid)
{
	/*
	/DHC_INVPRT ----->ROWID

   DHC_BillConINV
   DHC_PatientBill
   DHC_PatBillOrder.PBO_OEORI_DR
	*/
	s IsSuccess=$p(Info,"^",1)  // 结算是否成功
	q:IsSuccess'=0    
	s billno=0 f i=2:1:20 q:billno=""  d             //考虑最多20
	.s billno=$p(Info,"^",i)
	.q:billno="" 
	.s DHCBCIDR=0  f   s DHCBCIDR=$o(^DHCBCI(0,"INV",billno,DHCBCIDR)) q:(DHCBCIDR="")   d
	..s PatBillDR=$p(^DHCBCI(DHCBCIDR),"^",2)   ;DHC_PatientBill
	..s childsub=0  f  s childsub=$o(^DHCPB(PatBillDR,"O",childsub)) q:childsub=""  d
	...s oeorditemdr=$p(^DHCPB(PatBillDR,"O",childsub),"^",4)
	...s OrderRowid=$p(oeorditemdr,"||",1)
	...s itemsub=$p(oeorditemdr,"||",2)
	...s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
  	...s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
    ...;//E:执行状态
	...s ret=##class(web.DHCRisCommFunctionEx).UpdataOrdInfo(oeorditemdr,"E")
	
	q 0
}

ClassMethod GetNum()
{
	q ^DHCRisTmpPrintData123
}

ClassMethod GetData(i)
{
	q ^DHCRisTmpPrintData123(i)
}

ClassMethod PrintReport(StudyNo)
{
  q:StudyNo="" 0
  s studydescrowid=$o(^DHCRBStudyi("StudyDesc","StudyNo",StudyNo,0))
  i studydescrowid="" d
   .&sql(insert into DHCRB_StudyDesc(DRSD_StudyNo,DRSD_ReportPrint) values (:StudyNo,'Y'))
  else  d
   .&sql(update DHCRB_StudyDesc set DRSD_ReportPrint='Y' where DRSD_StudyNo=:StudyNo)
  q SQLCODE
}

ClassMethod QueryByRegDate(Intype, InLocDr, InStdDate, Inenddate, InStatusCode, InReportDoc, InVerifyDoc, InResourceID, InRoomDR, InRegEQ, InRequireAppoint, InIsBedOrd, InRegNo, InStudyNo, InName, InPatientNo, InAppLocDR, InEQGroupDR, InWardDR, InNO, IsFilmSet, IsNotLoc, BookedType, IsUItem, IsCostRecords)
{
	for date=InStdDate:1:Inenddate
    {
	  s Regrowid=0 f  s Regrowid=$o(^DHCPACRegInfoi("RegDate",date,Regrowid)) q:Regrowid=""  d    
      .s bOut="N"  ;是否已经输出
      .s GetPatientStatusCode="I"
      .s ExecuteLocId=$p(^DHCPACRegInfo(Regrowid),"^",13)
      .q:InLocDr'=ExecuteLocId  
      .s Detail="明细",RejectAppReason="拒绝原因",ToDayOeItem="",CostRecords="",BookedUser="",PaymentDoc=""
      .s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfobyrowid(Regrowid)
      .s GetStudyNo=$p(RegInfo,"^",1)
      .s GetstrRegDate=$p(RegInfo,"^",2)
      .s GetstrRegTime=$p(RegInfo,"^",3)
      .s GetIndex=$p(RegInfo,"^",4)
      .s GetEQDesc=$p(RegInfo,"^",5)
      .s GetMainDoc=$p(RegInfo,"^",6)
      .s GetAssDoc=$p(RegInfo,"^",7)
      .s Oeorditemdr=$p(RegInfo,"^",8)
      .s paadmdr=$p(RegInfo,"^",9)
      .s GetRoomDesc=$p(RegInfo,"^",10)
      .s GetRoomDr=$p(RegInfo,"^",12)
      .s GetEQDr=$p(RegInfo,"^",11)
      .s GetEQGroupDesc=$p(RegInfo,"^",13)
      .s GetEQGroupDR=$p(RegInfo,"^",14)
      .s GetOldNo=$p(RegInfo,"^",15)
      .;s BodyDesc=$p(RegInfo,"^",16)
      .s GetRegDate=$p(RegInfo,"^",17)
      .s FileSent=##class(web.DHCRisWorkBenchDoEx).GetFilmSendDesc(GetStudyNo)
      .s ReportSend=##class(web.DHCRisWorkBenchDoEx).GetReportSend(GetStudyNo)
      .s strXDate="",AppDate=""
      .s AppRowid=$o(^DHCRBAppi("OrdRowid",Oeorditemdr,0)) 
      .i AppRowid'="" d
      ..s XDate=$p( ^DHCRBApp("Bill",AppRowid),"^",10)
      ..s strXDate=$zd(XDate,3)
      ..s AppDate=$p(^DHCRBApp("Bill",AppRowid),"^",1)
      ..i AppDate'="" s AppDate=$zd(AppDate,3)
      ..s AppTime=$p(^DHCRBApp("Bill",AppRowid),"^",8)
      ..i AppTime'="" s AppTime=$zt(AppTime)
      ..s AppDate=AppDate_" "_AppTime
      .s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
      .s GetRegNo=$p(PatInfo,"^",1)
      .;w !,"GetRegNo"_GetRegNo
      .s GetName=$p(PatInfo,"^",2)
      .s GetstrDOB=$p(PatInfo,"^",3)
      .s GetstrAge=$p(PatInfo,"^",4)
      .s GetstrAge=$p(GetstrAge," ")
 	  .s GetSexDesc=$p(PatInfo,"^",5)
      .s Getpatienttype=$p(PatInfo,"^",6)
      .s Gettypedesc=$p(PatInfo,"^",7)
      .s GetLocName=$p(PatInfo,"^",8)
      .s GetIPNo=$p(PatInfo,"^",9)       ;住院号
      .s GetWardName=$p(PatInfo,"^",10)
      .s GetBedNo=$p(PatInfo,"^",11)
      .s GetReqLocDR=$p(PatInfo,"^",12)
      .s GetWardDR=$p(PatInfo,"^",14)
      .s Getroomdesc=$p(PatInfo,"^",15)
      .s GetSexDr=$p(PatInfo,"^",13)
      .s PapatmasDR=$p(PatInfo,"^",24)
      .s Weight=$p(PatInfo,"^",21)
	  .s TelNo=$p(PatInfo,"^",19)
	  .s PinYin=$p(PatInfo,"^",38)
	  .s Epissubtype=$p($g(PatInfo),"^",41)
      .s OrderRowid=$p(Oeorditemdr,"||",1)
      .s itemsub=$p(Oeorditemdr,"||",2)
      .s GetResDesc="",strRppDate="",strRppTime=""
      .s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(OrderRowid,itemsub)
      .s GetstrOrderName=$p(ordInfo,"^",1)
      .s GetstrDate=$p(ordInfo,"^",2)
      .s GetstrTime=$p(ordInfo,"^",3)
      .s Getrequestdoc=$p(ordInfo,"^",4)
      .s GetstrAccessionNum=$p(ordInfo,"^",5)
      .s GetSGroupDesc=$p(ordInfo,"^",6)    ;是否需要预约项目的标记
      .s GetsubCatDesc=$p(ordInfo,"^",7)
      .s GetCatDesc=$p(ordInfo,"^",8)
      .s Getifbed=$p(ordInfo,"^",9)
      .s Getprice=$p(ordInfo,"^",10)
      .s GetNum=$p(ordInfo,"^",11)
      .s GetTotalPrice=$p(ordInfo,"^",12)
      .s Getbilled=$p(ordInfo,"^",13)
      .s GetItemStatusCode=$p(ordInfo,"^",14)
      .s GetordDate=$p(ordInfo,"^",15)
      .s GetordTime=$p(ordInfo,"^",16)
      .s GetItemStatusCode=$p(ordInfo,"^",17)   			;医嘱状态
      .q:((GetItemStatusCode="U")&(IsUItem'="Y"))!(GetItemStatusCode="D")!(GetItemStatusCode="I")
      .s GetServerMaterial=$p(ordInfo,"^",18)   			;申请项目标记
      .s AutoInputFee=$p(ordInfo,"^",25) ;"需要另划价标志"
      .s EndInputFee=$p(ordInfo,"^",26)  ;"已另划价标识"
      .s BilledDesc=$p(ordInfo,"^",27)
      .s BodyDesc=$p(ordInfo,"^",29)
      .s CheckEntryFlag=$p(ordInfo,"^",30)
      .s BookedUser=$p(ordInfo,"^",31)
      .s GetPaymentDoc=$p(ordInfo,"^",33) ;补录操作员
      .s GetPlatStatus=$p(ordInfo,"^",34) ;平台状态
      .q:(IsCostRecords'="Y")&(CheckEntryFlag="Y") 
      .i CheckEntryFlag="Y" s CostRecords="已补录" s PaymentDoc=GetPaymentDoc
      .;s ResultFlag=$p(ordInfo,"^",20)    ;医嘱的结果状态--------------安贞医院用以前MEDTRAK 的结果处理，处理的的报告，在技师工作站中不在显示
      .;q:ResultFlag="V"
      .i BookedType="1"  d   ; 新开发的预约系统
	  ..s BookedRowid=$o(^DHCRBCResSchduleDetaili(0,Oeorditemdr,0))
      ..i BookedRowid'="" d
      ...s SchudleRowid=$p(^DHCRBCResSchduleDetail("Detail",BookedRowid),"^",2)
      ...i SchudleRowid'="" d
      ....s ResourceId=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",1)
      ....s ResDesc=""
 	  ....s CTCPDR=$p($g(^RB("RES",ResourceId)),"^",2)
      ....s CTCPDR=$p(CTCPDR,$c(0))
      ....i CTCPDR'="" d
      .....s GetResDesc=$p($g(^CTPCP(CTCPDR,1)),"^",2)
      ....else  d
      .....s EQDR=$p($g(^RB("RES",ResourceId)),"^",3)
      .....s GetResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
      ....s RppDate=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",2)
      ....s strRppDate=$zd(RppDate,3)
      ....s RppTime=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",5)
      ....s strRppTime=$zt(RppTime,1)
      ....s GetBookedDuration=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",3)
      .else  i $g(^OEORD(OrderRowid,"I",itemsub,6))'="" d
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
      ...s GetBookedDuration=$p(^RBAS(ResRowid,SchildSub,"APPT",appointchildsub),"^",23)
      
      
      .s GetReportStatusCode="N"     ;未写报告
      .s GetImgcount=0
      .s GetRptID=""
      .s GetRptDocDR="",GetRptDocName="",GetRptDate="",GetRptTime="",GetVerifyDocDR=""
      .s GetVerifyDocName="",GetVerifyDate="",GetVerifyTime="",GetStudyDescDR=""
      .s GetStudyWay="",GetBodyPartDR="",GetIsKYBL="",GetIsTSBL="",GetResultDesc="",GetExamDesc=""
      .s GetRptIsYX="",GetBookedDuration="",HaveImage=""
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
      ..s GetStudyDescDR=$p(^DHCRBStudy("Report",Rptrowid),"^",17)
      ..i GetStudyDescDR'="" s GetStudyWay=$p(^DHCRBStudy("StudyDesc",GetStudyDescDR),"^",7)
      ..;s GetBodyPartDR=$p(^DHCRBStudy("Report",Rptrowid),"^",19)
      ..s GetIsKYBL=$p(^DHCRBStudy("Report",Rptrowid),"^",21)
      ..s GetIsTSBL=$p(^DHCRBStudy("Report",Rptrowid),"^",22)
      ..s GetExamDesc=$p(^DHCRBStudy("Report",Rptrowid),"^",5)
      ..s GetResultDesc=$p(^DHCRBStudy("Report",Rptrowid),"^",6)
      ..s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
      ..s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
      ..s bOut="Y"
      ..Do OutRow
      .i bOut="N" d
      ..s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
      ..s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
      ..s bOut="Y"
      ..Do OutRow
   }
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK   
OutRow
	;set Data=$lb(RegNo,Name,SexDesc,strDOB,strAge,IDCDesc,$g(StudyNo),strOrderName,requestdoc,strAccessionNum,strDate,strTime,$g(AppointDate),$g(AppointstTime),$g(strRegDate),$g(strRegTime),$g(getReportDoc),$g(getReportVerifyDoc),PatientStatus,paadmdr,oeorditemdr,$g(LocName),TotalPrice,PatientStatusCode,billed,$g(typedesc),Num,price,$g(Index),$g(EQDesc),$g(ResDesc),ifbed,ReportStatus,MainDoc,AssDoc,RoomDesc)
 	//set Data=$lb(GetRegNo,GetName,GetSexDesc,GetstrDOB,GetstrAge,GetIDCDesc,GetStudyNo,GetstrOrderName,Getrequestdoc,GetstrAccessionNum,GetstrDate,GetstrTime,GetAppointDate,GetAppointstTime,GetstrRegDate,GetstrRegTime,GetReportDoc,GetReportVerifyDoc,GetPatientStatus,paadmdr,oeorditemdr,GetLocName,GetTotalPrice,GetPatientStatusCode,Getbilled,Gettypedesc,GetNum,Getprice,GetIndex,GetEQDesc,GetResDesc,Getifbed,GetReportStatus,GetMainDoc,GetAssDoc,GetRoomDesc)
   	//流水号,80;预约日期,80;预约时间,80;预约资源,100;床旁遗嘱,80;住院号，病区，房间号，床号，费别，检查部位，收费状态
   	s RecLoc=""
    i ExecuteLocId'="" d
    .s RecLoc=$p(^CTLOC(ExecuteLocId),"^",2)

 
   	s Required=""
   	if (GetSGroupDesc="无需预约")!(GetstrOrderName["床旁") s Required="N"
   	set Data=$lb(GetRegNo,GetName,GetSexDesc,GetstrAge,GetstrDOB,GetIDCDesc,
   	 GetStudyNo,GetstrOrderName,Getrequestdoc,GetstrAccessionNum,GetstrDate,GetstrTime,strRppDate,strRppTime,GetBookedDuration,GetstrRegDate,GetstrRegTime,GetRptDocName,GetVerifyDocName,GetPatientStatus,paadmdr,Oeorditemdr, 	 
   	 GetLocName,GetTotalPrice,GetPatientStatusCode,Getbilled,Gettypedesc,GetNum,Getprice,GetIndex,GetEQDesc,GetResDesc,Getifbed,GetReportStatus,GetMainDoc,GetAssDoc,GetRoomDesc,GetEQGroupDesc,GetWardName,GetOldNo,Required,strXDate,GetItemStatusCode,PapatmasDR,BodyDesc,Weight,TelNo,GetIPNo,FileSent,GetBedNo,ReportSend,HaveImage,ExecuteLocId,RecLoc,AutoInputFee,EndInputFee,Detail,RejectAppReason,BilledDesc,PinYin,ToDayOeItem,CostRecords,AppDate,BookedUser,PaymentDoc,GetPlatStatus,Epissubtype)
   	Set ^CacheTemp(repid,ind)=Data
   	s ^DHCRisTmpPrintData123(ind)=GetRegNo_"^"_GetName_"^"_GetSexDesc_"^"_GetstrAge_"^"_GetWardName_"^"_GetBedNo_"^"_GetStudyNo_"^"_$g(ReportSend)
   	s ^DHCRisTmpPrintData123=ind
	Set ind=ind+1
 	quit
}

//判断医嘱的接收科室是否在查询科室所关联的科室中

ClassMethod IsQueryLoc(LogInLocId As %String, OrditemRecLocId As %String) As %Integer
{
	 s bFind=0
	 s LinkSub=0 f  s LinkSub=$o(^CTLOC(LogInLocId,"LINK",LinkSub)) q:LinkSub=""  d    
    .s LinkLocDr=$p(^CTLOC(LogInLocId,"LINK",LinkSub),"^",1)
    .i LinkLocDr=OrditemRecLocId  s bFind=1
     q bFind
}

//根据医嘱ID查找表另划价医嘱的组号，用于确定哪些医嘱需要统一划价处理

//sunyi 2011-12-12

ClassMethod GetItemGroup(OEOrdItemID As %String) As %String
{
	q:(OEOrdItemID="") "-1"
	s OrderRowid=$p(OEOrdItemID,"||",1)
	s itemsub=$p(OEOrdItemID,"||",2)
	s GetItemGroupID=$P(^OEORD(OrderRowid,"I",itemsub,"6"),"^",1)
	q GetItemGroupID
}

ClassMethod GetArcItmRowid(OEOrdItemID As %String) As %String
{
    q:(OEOrdItemID="") "-1"	
    s OrderRowid=$p(OEOrdItemID,"||",1)
	s itemsub=$p(OEOrdItemID,"||",2)
	s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	q:(arcimid="") "-1"
	q arcimid
}

/// w ##class(web.DHCRisWorkBenchDoEx).GetLocArray("83")
/// 如果科室没有配置Link默认查询本科数据
ClassMethod GetLocArray(LocID As %String) As %String
{
	 s LinkSub="",Array=""
	 
	 s LinkSub=$o(^CTLOC(LocID,"LINK",0)) 
	 if (LinkSub'="") 
	 {
		 s LinkSub=0 f  s LinkSub=$o(^CTLOC(LocID,"LINK",LinkSub)) q:LinkSub=""  d    
         .s InLocDr=$p(^CTLOC(LocID,"LINK",LinkSub),"^",1) 
         .i (Array="") s Array=InLocDr
         .else  d
         ..s Array=Array_"@"_InLocDr
	 }
	 else
	 {   
	 	 s Array=LocID
	 } 
	q Array
}

/// /函数 AllowAutoQuery 
/// 功能 是否允许自动查询
/// 动作 Action : "" 或者是Auto 是 自动查询, 否这是其他条件的查询 
ClassMethod AllowAutoQuery(Action As %String) As %String
{
	s IsAllowQuery="N"
	if $g(^DHCRisAutoQuery)="" s ^DHCRisAutoQuery="Y"
	if ^DHCRisAutoQuery="N"  D
	.s IsAllowQuery="N"
	.s ^DHCRisAutoQuery="Y"
	else  d
	.s IsAllowQuery="Y"
	.s ^DHCRisAutoQuery="N"
   q IsAllowQuery
}

/// 判断是否是外部预约医嘱
/// do ##class(web.DHCRisWorkBenchDoEx).IsExternalBooked("70||918")
ClassMethod IsExternalBooked(oeorditemdr As %String) As %String
{
	q:(oeorditemdr="") "N"
	s oeordrowid=$p(oeorditemdr,"||",1)
	s oeorisub=$p(oeorditemdr,"||",2)
	
	s (ResultFlag,Complete,itmmastdr,IPRowid,AppointMethodId,AppointMethod,RERowid,ResSchduleID,ret)=""
	s IPRowid=""
	
	s itmmastdr=$p($g(^OEORD(oeordrowid,"I",oeorisub,1)),"^",2)
	i itmmastdr'=""  s IPRowid=$o(^DHCRBCItemBookProperTypei(itmmastdr,0)) 
	i IPRowid'="" s AppointMethodId=$p($g(^DHCRBCItemBookProperty(IPRowid)),"^",2)
	i AppointMethodId'="" s AppointMethod=$p(^DHCRBCAppointMethod(AppointMethodId) ,"^",2)
       
   
    s ResultFlag=$p($g(^OEORD(oeordrowid,"I",oeorisub,1)),"^",5)
    i ResultFlag'="" s RERowid=$o(^OEC("RESST",0,"Code",$$ALPHAUP^SSUTIL4(ResultFlag),""))
    i RERowid'="" s Complete=$p($g(^OEC("RESST",RERowid)),"^",2)
    s ret=..SetBookedStatus(oeordrowid,oeorisub)
    i ret="Y" s AppointMethod="外部预约"
    
    i (AppointMethod="外部预约")&(Complete="预约")
	{
		q "Y"
	}
	else
	{
		q "N"
	}
}

/// 协和医院对于(住院病人)&(医嘱子类ID="30")
/// 设置预约方式为外部预约
/// w ##class(web.DHCRisWorkBenchDoEx).SetBookedStatus("73754","284")
ClassMethod SetBookedStatus(oeordrowid As %String, oeorisub As %String) As %String
{
    s arcimid="",ItmCatDR="",paadmdr="",patienttype=""
    s arcimid=$p(^OEORD(oeordrowid,"I",oeorisub,1),"^",2)   
    i (arcimid'="")
    {
	   s ItmCatDR=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",10)
	}
	
    s paadmdr=$p(^OEORD(oeordrowid),"^",1)
    i paadmdr'="" s patienttype=$p(^PAADM(paadmdr),"^",2)  
   
    i (ItmCatDR="30")&(patienttype="I")
    {
	    q "Y"
	}
	else
	{
		q "N"
	}
}

/// 根据卡号获得登记号 sunyi 
/// w ##class(web.DHCRisWorkBenchDoEx).GetRegNofromCardNo("115311677001")
ClassMethod GetRegNofromCardNo(CardNo As %String) As %String
{
    s CardRowid=0,RegNo=""
    s CardRowid=$o(^DHCCARDi("CF",0,"CardNo",CardNo,""),-1) 
    i CardRowid'="" d
    .s RegNo=$p($g(^DHCCARD("CF",CardRowid)),"^",6)
    q RegNo
}

/// 根据卡号获得登记号 sunyi 
/// w ##class(web.DHCRisWorkBenchDoEx).GetRegNofromCardNoLL("115311677001")
ClassMethod GetRegNofromCardNoLL(CardNo As %String) As %String
{
    s CardRowid=0,RegNo=""
    s CardRowid=$o(^DHCCARDi("CF",0,"CardNo",CardNo,""),-1) 
    i CardRowid'="" d
    .s RegNo=$p($g(^DHCCARD("CF",CardRowid)),"^",6)
    q RegNo
}

}
