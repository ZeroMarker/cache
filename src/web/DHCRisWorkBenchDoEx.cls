Import SQLUser

Class web.DHCRisWorkBenchDoEx Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 195;

/// d ##class(%ResultSet).RunQuery("web.DHCRisWorkBenchDoEx","QueryExamItem",^TMPRIS11,^TMPRIS12,^TMPRIS13,^TMPRIS14)
/// BookedType ="" 或者是 0， 是用MEDTRAK 的预约方式 ， 1： 新开发的预约平台的预约方式
Query QueryExamItem(strCondition As %String, StdDate As %String, enddate As %String, BookedType As %String = "") As %Query(ROWSPEC = "Tregno:%String,TName:%String,TSex:%String,TAge:%String,TDob:%String,TDiagonse:%String,TStudyNo:%String,TstrOrderName:%String,TDoctor:%String,TstrAccessionNum:%String,TstrDate:%String,TstrTime:%String,TAppointDate:%String,TAppointstTime:%String,TBookedDuration:%String,TstrRegDate:%String,TstrRegTime:%String,TReportDoc:%String,TReportVerifyDoc:%String,TPatientStatus:%String,Tpaadmdr:%String,TOeorditemdr:%String,TLocName:%String,Tprice:%String,TOEORIItemStatus:%String,TBillStatus:%String,TPatientType:%String,TNum:%String,TPerprice:%String,TIndex:%String,TRegEQ:%String,TBookedRes:%String,Tifbed:%String,TReportStatus:%String,TMainDoc:%String,TAssDoc:%String,TRegRoom:%String,TEQroupDesc:%String,TWardDesc:%String,TNo:%String,TRequired:%String,THopeTime:%String,TOrdStatus:%String,TPatMasDR:%String,TBodyPart:%String,TWeight:%String,TTelNo:%String,TIPNO:%String,TSentFilm:%String,TBedCode:%String,TSendPrint:%String,HasImage:%String,RecLocId:%String,RecLoc:%String,AutoInputFee:%String,EndInputFee:%String,Detail:%String,RejectAppReason:%String,BilledDesc:%String,PinYin:%String,ToDayOeItem:%String,CostRecords:%String,AppDate:%String,UrgentFlag:%String,TRegDoc:%String,TEpissubtype:%String,SGroupDesc:%String,SGroupDR:%String,AppointUser:%String,AppBillView:%String,AdmReason:%String,ExterBK:%String,BodyCode:%String,AppBillNo:%String,BKStudyNo:%String,AccUsePrice:%String,GetResultFlag:%String")
{
}

ClassMethod QueryExamItemExecute(ByRef qHandle As %Binary, strCondition As %String, StdDate As %String, enddate As %String, BookedType As %String) As %Status
{

   s ^TMPRIS11=strCondition
   s ^TMPRIS12=StdDate
   s ^TMPRIS13=enddate
   s ^TMPRIS14=BookedType
   k ^DHCRisTmpPrintData
   s UserID=%session.Get("LOGON.USERID")
   i UserID="" s UserID="71"
   
   k ^DHCRISTEMPQUERYDATA(UserID)
   k ^tempQueryNum(UserID)
   k ^DHCRisExportExcelData($g(UserID)) 
   
   s StdDate=##class(websys.Conversions).DateHtmlToLogical(StdDate)
   s enddate=##class(websys.Conversions).DateHtmlToLogical(enddate)
   
   if ((StdDate="") || (StdDate="ERROR!"))  s StdDate=+$h
   if ((enddate="") || (enddate="ERROR!"))  s enddate=+$h
   
   s IndexI=0,IndexE=0,IndexO=0,IndexH=0,IndexN=0
   /*
   i $g(^DHCRisLookupCondition(UserID))'="" d
   .s strCondition=^DHCRisLookupCondition(UserID)
   .s StdDate=$p(^DHCRisLookupCondition(UserID),"^",29)
   .s StdDate=$zdh(StdDate,4)
   .s enddate=$p(^DHCRisLookupCondition(UserID),"^",30)
   .s enddate=$zdh(enddate,4)
   */
   
   s Intype=$p(strCondition,"^",1)
   s Intype=$p(Intype,$c(0))
   ;s Intype=##class(web.DHCRisCommFunction).GetPaadmTypeCode(IntypeDesc)
   s InRegNo=$p($g(strCondition),"^",2)
   s InRegNo=$p(InRegNo,$c(0))
   s InStudyNo=$p(strCondition,"^",3)
   s InStudyNo=$p(InStudyNo,$c(0))
   
   s InLocDr=$p(strCondition,"^",4)
   s InLocDr=$p(InLocDr,$c(0))
  
   if InLocDr="" s InLocDr=##class(web.DHCRisCommFunction).GetSession("SelLocID")
   if InLocDr="" s InLocDr=%session.Get("LOGON.CTLOCID")
  
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

   /*s InAppLocDR=""
   s InAppLocDR=$p($g(InAppLocDR),$c(0))*/

   s InEQGroupDR=$p(strCondition,"^",16)   
   s InEQGroupDR=$p($g(InEQGroupDR),$c(0))
   
   s InWardDR="" ;$p(strCondition,"^",18)
   s InWardDR="" ;$p($g(InWardDR),$c(0))
   
   s InNO=$p(strCondition,"^",18)
   s InNO=$p($g(InNO),$c(0))      //编号
   
   s IsFilmSet=$p(strCondition,"^",19)
   
   s IsNotLoc=$p(strCondition,"^",21)  //是否不显示本科室的病人 Y,N
   
   s QueryByRegDate=$p(strCondition,"^",22) //通过登记时间查询
     
   s IsUItem=$p($g(strCondition),"^",31)    //是否查询作废遗嘱
   
   s IsCostRecords=$p($g(strCondition),"^",32)    //是否查询已补费医嘱
   
   s InAppLocDR=$p($g(strCondition),"^",33) //申请科室DR
   s InAppLocDR=$p($g(InAppLocDR),$c(0))
   
   
   Set repid=$I(^CacheTemp)
   If $g(ind)="" Set ind=1
      
   if (InRegNo="")&(InStudyNo="")&(InName="")&(InNO="")  
   {
	   if (QueryByRegDate="Y")
	   {
		   
		   ;s return=..QueryByRegDate(Intype,InLocDr,InStdDate,Inenddate,InStatusCode,InReportDoc,InVerifyDoc,InResourceID,InRoomDR, InRegEQ, InRequireAppoint, InIsBedOrd, InRegNo, InStudyNo, InName, InPatientNo, InAppLocDR, InEQGroupDR, InWardDR, InNO, IsFilmSet, IsNotLoc,BookedType,IsUItem,IsCostRecords,UserID)
	   }
	   else
	   {
		   
		   s return=..QueryByLoc(Intype,InLocDr,InStdDate,Inenddate,InStatusCode,InReportDoc, InVerifyDoc,InResourceID,InRoomDR,InRegEQ,InRequireAppoint,InIsBedOrd,InRegNo,InStudyNo,InName,InPatientNo,InAppLocDR,InEQGroupDR,InWardDR,InNO,IsFilmSet,IsNotLoc,BookedType,IsUItem,IsCostRecords,UserID)
	   } //改
   	   Quit $$$OK
   }
   if (InStudyNo'="")
   {
	 //s return=..QueryByStudyNo(InLocDr, InRoomDR, InRegEQ, Intype, InRegNo, InStudyNo, InName, "", "", InStatusCode, "", InStdDate, Inenddate, "", "", InLocDr, "", "", InReportDoc, InVerifyDoc, "", "", "","", InWardDR, InEQGroupDR, InNO,InIsFindDate,BookedType,IsUItem,IsCostRecords,UserID,InAppLocDR)
	
	; s return=..QueryByNewStudyNo(InLocDr, InRoomDR, InRegEQ, Intype, InRegNo, InStudyNo, InName, "", "", InStatusCode, "", InStdDate, Inenddate, "", "", InLocDr, "", "", InReportDoc, InVerifyDoc, "", "", "","", InWardDR, InEQGroupDR, InNO,InIsFindDate,BookedType,IsUItem,IsCostRecords,UserID,InAppLocDR)
   	 Quit $$$OK
   }
   if (InRegNo'="")
   {
	  
	  s return=..QueryByRegNo(InLocDr, InRoomDR, InRegEQ, Intype, InRegNo, InStudyNo, InName, "", "", InStatusCode, "", InStdDate, Inenddate, "", "", InLocDr, "", "", InReportDoc, InVerifyDoc, "", "", "", "",InWardDR, InEQGroupDR, InNO,InIsFindDate,BookedType,IsUItem,IsCostRecords,UserID,InAppLocDR)
      Quit $$$OK     //改
   }
   if (InName'="")
   {
	    ;s return=..QueryByName(InLocDr, InRoomDR, InRegEQ, Intype, InRegNo, InStudyNo, InName, "", "", InStatusCode, "", InStdDate, Inenddate, "", "", InLocDr, "", "", InReportDoc, InVerifyDoc, "", "", "","", InWardDR, InEQGroupDR, InNO,InIsFindDate,BookedType,IsUItem,IsCostRecords,UserID,InAppLocDR)
      Quit $$$OK     //改
   }
   if (InNO'="")
   {
	 
	  ;s return=..QueryByOldNo(InLocDr, InRoomDR, InRegEQ, Intype, InRegNo, InStudyNo, InName, "", "", InStatusCode, "", InStdDate, Inenddate, "", "", InLocDr, "", "", InReportDoc, InVerifyDoc, "", "", "", "",InWardDR, InEQGroupDR, InNO,InIsFindDate,BookedType,IsUItem,IsCostRecords,UserID,InAppLocDR)
      Quit $$$OK
   }
}

ClassMethod QueryExamItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryExamItemExecute ]
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

ClassMethod QueryExamItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryExamItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// 通过登记日期查询

ClassMethod QueryByLoc(Intype As %String, InLocDr As %String, InStdDate As %String, Inenddate As %String, InStatusCode As %String, InReportDoc As %String, InVerifyDOc As %String, InResourceID As %String, InRoomDR As %String, InRegEQDR As %String, InRequireAppoint As %String, InIsBedOrd As %String, InRegNo As %String, InStudyNo As %String, InName As %String, InPatientNo As %String, InAppLocDR As %String, InEQGroupDR As %String, InWardDR As %String, InNO As %String, IsFilmSet As %String, IsNotLoc As %String, BookedType As %String, IsUItem As %String, IsCostRecords As %String, UserID As %String)
{
 
	
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s n=0
    s MainLocID=InLocDr
    s gAppLoc=InLocDr
	
    s LocArray=..GetLocArray(MainLocID)
    s Count=$l(LocArray,"@")
	
	f i=1:1:Count d
	.s InLocDr=$p(LocArray,"@",i)
	.q:(InLocDr="")
    .f date=InStdDate:1:Inenddate d
    ..i ((InRequireAppoint="Y")!(InRequireAppoint="")) d
    ...s count=..QueryBookedItem(Intype,InStatusCode,"",date,InLocDr,InResourceID,InReportDoc,InVerifyDOc,InIsBedOrd,InRoomDR,InRegEQDR, InRequireAppoint, InRegNo, InStudyNo,InName,InPatientNo,InAppLocDR,InEQGroupDR,InWardDR,InNO,IsFilmSet,BookedType,IsUItem,IsCostRecords,UserID,gAppLoc)  ;查询到指定的日期的预约医嘱
    ..s PriorityDR=0 f  s PriorityDR=$o(^OEORDi(0,"LocStDtPr",InLocDr,PriorityDR)) q:PriorityDR=""  d
    ...;w !,"PriorityDR"_PriorityDR 
    ...s OrderRowid=0 f  s OrderRowid=$o(^OEORDi(0,"LocStDtPr",InLocDr,PriorityDR,date,OrderRowid)) q:OrderRowid=""  d
    ....;w !,"OrderRowid="_OrderRowid 
    ....s itemsub=0 f  s itemsub=$o(^OEORDi(0,"LocStDtPr",InLocDr,PriorityDR,date,OrderRowid,itemsub)) q:itemsub=""  d
	.....s oeorditemdr=OrderRowid_"||"_itemsub
	.....;w !,"oeorditemdr="_oeorditemdr
	.....s bodydrList=##Class(web.DHCRisWorkBenchDoEx).GetstrOrderName(oeorditemdr)
	.....s AppBillNo=##Class(web.DHCAPPInterface).GetExaReqNo(oeorditemdr)    //申请单号
	.....;w !,"bodydrList="_bodydrList
	.....s NumLeng=$L(bodydrList,"^")
	.....f j=1:1:NumLeng  d  
	......s bodypart=$p($g(bodydrList),"^",j)
	......s bodypartcode=$p($g(bodypart),":",1) 
	......s bodypart=$p($g(bodypart),":",2)
	......s Detail="明细",RejectAppReason="",ToDayOeItem="",CostRecords="",AppBillView=""
	......s paadmdr=$p(^OEORD(OrderRowid),"^",1) 
	......s GetIDCDesc=##class(web.DHCRisCommFunctionEx).GetDiagnose(paadmdr)
    ......s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
    ......s GetRegNo=$p(PatInfo,"^",1)
    ......s AccUsePrice=##Class(web.DHCRisWorkBenchDoEx).GetAccUsePrice(GetRegNo)
    ......s GetName=$p(PatInfo,"^",2)
    ......s GetstrDOB=$p(PatInfo,"^",3)
    ......;f GetstrDOB'="" d
    ......;.s GetstrDOB=$zd($zdh(GetstrDOB,4),3)
    ......s GetstrAge=$p(PatInfo,"^",4)
 	......s GetSexDesc=$p(PatInfo,"^",5)
    ......s Getpatienttype=$p(PatInfo,"^",6)
    ......s Gettypedesc=$p(PatInfo,"^",7)
    ......s GetLocName=$p(PatInfo,"^",8)
    ......s GetIPNo=$p(PatInfo,"^",9)
    ......s GetWardName=$p(PatInfo,"^",10)
    ......s GetBedNo=$p(PatInfo,"^",11)
    ......s GetLocdr=$p(PatInfo,"^",12)
    ......;q:(gAppLoc'=GetLocdr)&(GetLocdr'="") ;中国医大增加
    ......s GetWardDr=$p(PatInfo,"^",14)
    ......s PapatmasDR=$p(PatInfo,"^",24)
    ......s Weight=$p(PatInfo,"^",21)
	......s TelNo=$p(PatInfo,"^",19)
	......s PinYin=$p(PatInfo,"^",38)
	......s Epissubtype=$p($g(PatInfo),"^",41)
	......s stay=$p($g(PatInfo),"^",42)
	......s AdmReason=$p($g(PatInfo),"^",43)
	......q:(InWardDR'="")&(GetWardDr'=InWardDR)
    ......q:(InPatientNo'="")&(InPatientNo'=GetIPNo)
    ......q:(InAppLocDR'="")&(GetLocdr'=InAppLocDR)
    ......q:(Intype'="")&(Intype'=Getpatienttype)
    ......q:(IsNotLoc="Y")&(GetLocdr=InLocDr)     ;不显示当前科室的病人，有写科室是执行科室又是住院科室）
    ......;b //022
    ......s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(OrderRowid,itemsub,bodypartcode)
    ......s GetstrOrderName=$p(ordInfo,"^",1)
    ......;i bodypart="" d
    ......;.s GetstrOrderName=GetstrOrderName
    ......;else  d
    ......;.s GetstrOrderName=GetstrOrderName_"("_bodypart_")"
    ......s BodyDescNew=bodypart
    ......;W !,"TBodyPart="_TBodyPart
    ......s GetstrDate=$p(ordInfo,"^",2)
    ......s GetstrTime=$p(ordInfo,"^",3)
    ......s Getrequestdoc=$p(ordInfo,"^",4)
    ......s GetstrAccessionNum=$p(ordInfo,"^",5)
    ......s GetSGroupDesc=$p(ordInfo,"^",6)
    ......s GetSGroupDR=$p($g(ordInfo),"^",36)
    ......s GetsubCatDesc=$p(ordInfo,"^",7)
    ......s GetCatDesc=$p(ordInfo,"^",8)
    ......s Getifbed=$p(ordInfo,"^",9)
    ......s Getprice=$p(ordInfo,"^",10)
    ......s GetNum=$p(ordInfo,"^",11)
    ......s GetTotalPrice=$p(ordInfo,"^",12)
    ......s Getbilled=$p(ordInfo,"^",13)
    ......s GetItemStatusCode=$p(ordInfo,"^",14)
    ......q:(GetItemStatusCode="U")&(IsUItem'="Y") ;查询作废医嘱
    ......q:(GetItemStatusCode="U")!(GetItemStatusCode="D")!(GetItemStatusCode="C")
    ......s GetordDate=$p(ordInfo,"^",15)
    ......s GetordTime=$p(ordInfo,"^",16)
    ......s GetItemStatusCode=$p(ordInfo,"^",17)
    ......s GetServerMaterial=$p(ordInfo,"^",18)
    ......s AutoInputFee=$p(ordInfo,"^",25) ;"需要另划价标志"
    ......i AutoInputFee="Y" s ToDayOeItem="查询"
    ......s EndInputFee=$p(ordInfo,"^",26)  ;"已另划价标识"
    ......s BilledDesc=$p(ordInfo,"^",27)
    ......s CheckEntryFlag=$p(ordInfo,"^",30)
    ......s GetExterFalg=$p(ordInfo,"^",32)  ;外部预约标识
    ......s GetResultFlag=$p(ordInfo,"^",38) ;第三方回传报告状态
    ......s Urgentflag=$p(ordInfo,"^",35) 
    ......;s ExterBK="N"
    ......;i GetExterFalg'="" s ExterBK="Y" 
    ......q:(IsCostRecords'="Y")&(CheckEntryFlag="Y") 
    ......i CheckEntryFlag="Y" s CostRecords="已补录"
    ......s ResultFlag=$p(ordInfo,"^",20)    ;医嘱的结果状态--------------安贞医院用以前MEDTRAK 的结果处理，处理的的报告，在技师工作站中不在显示
    ......q:ResultFlag="V"
    ......s strXDate="",AppDate=""
    ......s AppRowid=$o(^DHCRBAppOrdi(0,oeorditemdr,0)) 
    ......i AppRowid'="" d
    .......s XDate=$p($g(^DHCRBApp("Bill",AppRowid)),"^",10)
    .......s strXDate=##class(websys.Conversions).DateLogicalToHtml(XDate) ;$zd(XDate,3)
    .......s AppDate=$p($g(^DHCRBApp("Bill",AppRowid)),"^",1)
    .......i AppDate'="" s AppDate=##class(websys.Conversions).DateLogicalToHtml(AppDate) ;$zd(AppDate,3)
    .......s Urgentflag=$p($g(^DHCRBApp("Bill",AppRowid)),"^",26)
    .......s AppBillView="申请单浏览"
    .......q:(InRequireAppoint="N")&(GetSGroupDesc'="无需预约")&('(GetstrOrderName["床旁"))
    .......q:(InRequireAppoint="Y")&((GetSGroupDesc="无需预约")!(GetstrOrderName["床旁"))
    ......q:(InIsBedOrd="Y")&('(GetstrOrderName["床旁"))  ;检索床旁医嘱，不是床旁医嘱
    ......i (GetstrOrderName["床旁") S Getifbed="Y"
    ......s SystemParamInfo=##class(web.DHCRisCommFunction).GetSystemParam()
    ......s SendApptoLoc=$p(SystemParamInfo,"^",3)  ;没写申请单,是否发检查医嘱到检查科室
    ......s SendInPtoLoc=$p(SystemParamInfo,"^",4)  ;没收费是否把住院病人的检查项目发送到检查科室  
    ......s SendOutPtoLoc=$p(SystemParamInfo,"^",5) ;没收费是否把门诊检查项目发送到检查科室
    ......s SendEmPtoLoc=$p(SystemParamInfo,"^",6)   ;没收费是否把急诊病人检查项目发送到检查科室
    ......s QueryonlyExam=$p(SystemParamInfo,"^",9)  ;是否只查询检查项目
    ......s SendHPtoLoc=$p(SystemParamInfo,"^",10)   ;没收费是否把体检病人的检查项目发送检查科室
    ......q:(SendInPtoLoc="N")&(Getbilled'="P")&(Getpatienttype="I")    ;住院病人没有付费的退出
    ......q:(SendOutPtoLoc="N")&(Getbilled'="P")&(Getpatienttype="O")   ;门诊病人没有付费退出
    ......q:(SendEmPtoLoc="N")&(Getbilled'="P")&(stay'="STAY")&(Getpatienttype="E")   ;急症病人没付费退出
    ......q:(SendHPtoLoc="N")&(Getbilled'="P")&(Getpatienttype="H")   ;体检病人没付费退出
    ......q:(QueryonlyExam="Y")&(GetServerMaterial'="S") ;不是检查项目的则退出
    ......s GetPatientStatusCode="A"  ;申请
    ......i GetItemStatusCode="D" s GetPatientStatusCode="D"
    ......s GetReportStatusCode="N"  ;未写报告
    ......s Getapprowid="",GetRoomDr=""
    ......s GetRptDocName="",GetVerifyDocName="",GetStudyNo="",GetstrRegDate="",GetstrRegTime="",GetIndex="",GetEQDesc="",GetMainDoc="",GetAssDoc=""
    ......s GetEQDr="",GetRoomDesc="",GetAppointDate="",GetAppointstTime="",GetBookedDuration="",GetResDesc="",GetEQGroupDesc="",GetEQGroupDR="",NO="",HaveImage="" 
    ......s bOut="N" ,Getapprowid="",BookedRowid="",RegDoc="",AppointUser="" ;是否已经输出
    ......; 对于住院病人，去判断申请单  wf  20160801 新申请单不判断
    ......;s AllowSend="Y"
    ......;i (SendApptoLoc="N")&(Getpatienttype="I")  d
    ......;.s AppRowid=$o(^DHCRBAppOrdi(0,oeorditemdr,0)) 
    ......;.i AppRowid'="" d
    ......;..s AllowSend="Y"
    ......;.else  d
    ......;..s AllowSend="N"
    ......;q:AllowSend="N"
    ......i ((GetItemStatusCode="V")!(GetItemStatusCode="E")!(GetItemStatusCode="D")) d
    .......s GetRejDR=$o(^DHCRBRejecti("OeordDR",oeorditemdr,0))
	.......i GetRejDR'="" d
	........s GetPatientStatusCode="RJ" ;拒绝申请
	........s RejectAppReason="拒绝原因"
	.......else  d
	........i $g(^OEORD(OrderRowid,"I",itemsub,6))'="" s Getapprowid=$p($g(^OEORD(OrderRowid,"I",itemsub,6)),"^",5)  ; 已经预约RB_Appointment Rowid
	........s BookedRowid=##class(web.DHCRisResApptSchudleSystem).getBookDetailRowid(oeorditemdr_"^"_bodypartcode)
	.......q:((BookedType="1")&(BookedRowid'=""))    ;预约过的医嘱则退出 
	.......q:((BookedRowid="")&(InResourceID'="")) ;按预约资源查询，过滤掉没有预约的医嘱
	.......q:(GetExterFalg'="")
    .......i GetExterFalg'="" d
    ........s GetPatientStatusCode="B"
    ........s GetAppointDate=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",2)
    ........s GetAppointstTime=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",3)
	.......s FileSent=""
	.......s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfo(oeorditemdr,bodypartcode)
    .......s GetStudyNo=$p(RegInfo,"^",1)
    .......i GetStudyNo'="" d
    ........s GetPatientStatusCode="I"
    ........s GetstrRegDate=$p(RegInfo,"^",2)
    ........s GetstrRegTime=$p(RegInfo,"^",3)
    ........s GetIndex=$p(RegInfo,"^",4)
    ........s GetEQDesc=$p(RegInfo,"^",5)
    ........s GetMainDoc=$p(RegInfo,"^",6)
    ........s GetAssDoc=$p(RegInfo,"^",7)
    ........s GetRoomDesc=$p(RegInfo,"^",8)
    ........s GetRoomDr=$p(RegInfo,"^",9)
    ........s GetEQDr=$p(RegInfo,"^",10)
    ........s GetEQGroupDesc=$p(RegInfo,"^",11)
    ........s GetEQGroupDR=$p(RegInfo,"^",12)
    ........s NO=$p(RegInfo,"^",13)
    ........s BodyDescNew=$p(RegInfo,"^",17)   ///登记的部位全部屏蔽
    ........s Urgentflag=$p(RegInfo,"^",21)
    ........s RegDoc=$p(RegInfo,"^",24)
    ........s FileSent=##class(web.DHCRisWorkBenchDoEx).GetFilmSendDesc(GetStudyNo)
    ........s ReportSend=##class(web.DHCRisWorkBenchDoEx).GetReportSend(GetStudyNo)
    ........s GetImgcount=0
    ........q:GetStudyNo=""
    ........s Imrowid=0 f  s Imrowid=$o(^DHCRBStudyi("StudyNo-Images",GetStudyNo,Imrowid)) q:Imrowid=""  d
    .........s GetPatientStatusCode="E"    ;正在检查
    .........s ExtName=$p($g(^DHCRBStudy(0,"StudyImages",Imrowid)),"^",2)
    .........i ((ExtName="avi")!(ExtName="dcm")!(ExtName="normal")!(ExtName="dsa"))  d
    ..........s GetImgcount=GetImgcount+1
    ..........s GetReportStatusCode="I"             ;图象已经采集
    ..........s HaveImage="是"
    ........s sReportStuatCode="VS"
    ........;s Rptrowid=0  f  s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",GetStudyNo,Rptrowid)) q:Rptrowid=""  d
    ........s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",GetStudyNo,""),-1)
    ........i Rptrowid'="" d
    .........s GetRptID=$p(^DHCRBStudy("Report",Rptrowid),"^",2)
    .........s GetRptVersion=$p(^DHCRBStudy("Report",Rptrowid),"^",3)
    .........s GetRptStatusDR=$p(^DHCRBStudy("Report",Rptrowid),"^",4)
    .........i GetRptStatusDR'="" d
    ..........s GetReportStatusCode=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",1)
    ..........i sReportStuatCode[GetReportStatusCode d
    ...........s GetPatientStatusCode="O"
    ..........e  d
    ...........s GetPatientStatusCode="E"
    .........s GetRptDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",8)
    .........i GetRptDocDR'="" s GetRptDocName=$p(^SSU("SSUSR",GetRptDocDR),"^",2)
    .........s GetRptDate=$p(^DHCRBStudy("Report",Rptrowid),"^",9)
    .........i GetRptDate'="" s GetRptDate=##class(websys.Conversions).DateLogicalToHtml(GetRptDate)    ;$zd(GetRptDate,3)
    .........s GetRptTime=$p(^DHCRBStudy("Report",Rptrowid),"^",10)
    .........i GetRptTime'="" s GetRptTime=##class(websys.Conversions).TimeLogicalToHtml(GetRptTime)   ;$zt(GetRptTime,3)
    .........s GetVerifyDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",11)
    .........i GetVerifyDocDR'="" s GetVerifyDocName=$p(^SSU("SSUSR",GetVerifyDocDR),"^",2)
    .........s GetVerifyDate=$p(^DHCRBStudy("Report",Rptrowid),"^",12)
    .........i GetVerifyDate'="" s GetVerifyDate=$zd(GetVerifyDate,3) 
    .........s GetVerifyTime=$p(^DHCRBStudy("Report",Rptrowid),"^",13)
    .........i GetVerifyTime'="" s GetVerifyTime=$zt(GetVerifyTime,3)
    .........i ((IsFilmSet="false")!((IsFilmSet="true")&(FileSent="已发片")))&((InEQGroupDR="")!(GetEQGroupDR=InEQGroupDR))&((InRoomDR="")!(GetRoomDr=InRoomDR))&((InRegEQDR="")!(InRegEQDR=GetEQDr))&((InStatusCode="")!(InStatusCode[GetPatientStatusCode))&((InReportDoc="")!(InReportDoc=GetRptDocName))&((InVerifyDOc="")!(InVerifyDOc=GetVerifyDocName)) d 
   	..........s PatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
    ..........s ReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
    ..........s bOut="Y"
    ..........Do OutRowL4
    .......i ((IsFilmSet="false")!((IsFilmSet="true")&(FileSent="已发片")))&((InEQGroupDR="")!(GetEQGroupDR=InEQGroupDR))&((InRoomDR="")!(GetRoomDr=InRoomDR))&((InRegEQDR="")!(InRegEQDR=GetEQDr))&((InStatusCode="")!(InStatusCode[GetPatientStatusCode))&((InReportDoc="")!(InReportDoc=GetRptDocName))&((InVerifyDOc="")!(InVerifyDOc=GetVerifyDocName))&(bOut="N") d 
  	........s PatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
    ........s ReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
    ........s bOut="Y"
    ........Do OutRowL4
    
    //Do OutRowL4byType

   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
OutRowL4
    s Required=""
    i ((GetSGroupDesc="无需预约")!(GetstrOrderName["床旁")) s Required="N"
    s RecLoc=""
    i InLocDr'="" d
    .s RecLoc=$p(^CTLOC(InLocDr),"^",2)
    ;w !,"a_"_oeorditemdr_"***"_ExterBK 
    S BKStudyNo=""
    ;set Data=$lb(GetRegNo,GetName,GetSexDesc,GetstrAge,GetstrDOB,GetIDCDesc,GetStudyNo,GetstrOrderName,Getrequestdoc,GetstrAccessionNum,GetstrDate,GetstrTime,GetAppointDate,GetAppointstTime,GetBookedDuration,GetstrRegDate,GetstrRegTime,GetRptDocName,GetVerifyDocName,PatientStatus,paadmdr,oeorditemdr,GetLocName,GetTotalPrice,GetPatientStatusCode,Getbilled,Gettypedesc,GetNum,Getprice,GetIndex,GetEQDesc,GetResDesc,Getifbed,ReportStatus,GetMainDoc,GetAssDoc,GetRoomDesc,GetEQGroupDesc,GetWardName,NO,Required,strXDate,GetItemStatusCode,PapatmasDR,BodyDescNew,Weight,TelNo,GetIPNo,FileSent,GetBedNo,ReportSend,HaveImage,InLocDr,RecLoc,AutoInputFee,EndInputFee,Detail,RejectAppReason,BilledDesc,PinYin,ToDayOeItem,CostRecords,AppDate,Urgentflag,RegDoc,Epissubtype,GetSGroupDesc,GetSGroupDR,$g(AppointUser),$g(AppBillView),$g(AdmReason),$g(ExterBK),$g(bodypartcode),$g(AppBillNo),$g(BKStudyNo),AccUsePrice,GetResultFlag)
    ;s ret=..SetQueryData(Getpatienttype,UserID,Data)
    set Data=$lb(GetRegNo,GetName,GetSexDesc,GetstrAge,GetstrDOB,"",GetStudyNo,GetstrOrderName,Getrequestdoc,GetstrAccessionNum,GetstrDate,GetstrTime,GetAppointDate,GetAppointstTime,GetBookedDuration,GetstrRegDate,GetstrRegTime,GetRptDocName,GetVerifyDocName,PatientStatus,paadmdr,oeorditemdr,GetLocName,GetTotalPrice,GetPatientStatusCode,Getbilled,Gettypedesc,GetNum,Getprice,GetIndex,GetEQDesc,GetResDesc,Getifbed,ReportStatus,GetMainDoc,GetAssDoc,GetRoomDesc,GetEQGroupDesc,GetWardName,NO,Required,strXDate,GetItemStatusCode,PapatmasDR,BodyDescNew,Weight,TelNo,GetIPNo,FileSent,GetBedNo,ReportSend,HaveImage,InLocDr,RecLoc,AutoInputFee,EndInputFee,Detail,RejectAppReason,BilledDesc,PinYin,ToDayOeItem,CostRecords,AppDate,Urgentflag,RegDoc,Epissubtype,GetSGroupDesc,GetSGroupDR,$g(AppointUser),$g(AppBillView),$g(AdmReason),$g(ExterBK),$g(bodypartcode),$g(AppBillNo),$g(BKStudyNo),AccUsePrice,GetResultFlag)
 
    Set ^CacheTemp(repid,ind)=Data
    s ^DHCRisTmpPrintData(ind)=GetRegNo_"^"_GetName_"^"_GetSexDesc_"^"_GetstrAge_"^"_GetWardName_"^"_GetBedNo_"^"_GetStudyNo_"^"_$g(ReportSend)
   	s ^DHCRisTmpPrintData=ind
   	s ^DHCRisExportExcelData($g(UserID),ind)=GetRegNo_"^"_GetName_"^"_GetSexDesc_"^"_GetstrAge_"^"_GetstrDOB_"^"_$g(GetIDCDesc)_"^"_GetStudyNo_"^"_GetstrOrderName_"^"_Getrequestdoc_"^"_GetstrAccessionNum_"^"_GetstrDate_"^"_GetstrTime_"^"_GetAppointDate_"^"_GetAppointstTime_"^"_$g(GetBookedDuration)_"^"_GetstrRegDate_"^"_GetstrRegTime_"^"_$g(GetRptDocName)_"^"_$g(GetVerifyDocName)_"^"_PatientStatus_"^"_paadmdr_"^"_oeorditemdr_"^"_GetLocName_"^"_GetTotalPrice_"^"_GetPatientStatusCode_"^"_Getbilled_"^"_Gettypedesc_"^"_GetNum_"^"_Getprice_"^"_GetIndex_"^"_GetEQDesc_"^"_GetResDesc_"^"_Getifbed_"^"_ReportStatus_"^"_GetMainDoc_"^"_GetAssDoc_"^"_GetRoomDesc_"^"_GetEQGroupDesc_"^"_GetWardName_"^"_$g(NO)_"^"_$g(Required)_"^"_strXDate_"^"_GetItemStatusCode_"^"_PapatmasDR_"^"_BodyDescNew_"^"_Weight_"^"_TelNo_"^"_GetIPNo_"^"_$g(FileSent)_"^"_GetBedNo_"^"_$g(ReportSend)_"^"_$g(HaveImage)_"^"_InLocDr_"^"_RecLoc_"^"_$g(AutoInputFee)_"^"_$g(EndInputFee)_"^"_Detail_"^"_$g(RejectAppReason)_"^"_BilledDesc_"^"_PinYin_"^"_$g(ToDayOeItem)_"^"_CostRecords_"^"_AppDate_"^"_$g(Urgentflag)_"^"_$g(RegDoc)_"^"_$g(Epissubtype)_"^"_GetSGroupDesc_"^"_GetSGroupDR_"^"_$g(AppointUser)_"^"_$g(AdmReason)_"^"_bodypartcode_"^"_$g(AppBillNo)_"^"_$g(BKStudyNo)_"^"_AccUsePrice_"^"_GetResultFlag
   	s ^DHCRisExportExcelData($g(UserID))=ind
   	Set ind=ind+1
   	quit
    
OutRowL4byType
     s ind=1
     s ArrayType=..GetQueryOrder()
     s numl=0
     s numl=$L(ArrayType,"@")
     f s=1:1:numl  d
     .s type=$p(ArrayType,"@",s)
     .for j=1:1:$g(^tempQueryNum(UserID,type)) d
     ..Set ^CacheTemp(repid,ind)=$g(^DHCRISTEMPQUERYDATA(UserID,type,j))
	 ..Set ind=ind+1
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

// 未分部位查询

ClassMethod QueryByStudyNo(ExmLocID, RoomDR, DeviceDR, PatTypeDR, InRegNo, StudyID, InName, InSexDR, Age, InStudyStatusCode, InRptStatusCode, StdDate, EndDate, OrderItemDR, StudyWay, InReqLocDR, RptDesc, RptDiagnose, RptDocDR, VerifyDocDR, IsYX, IsDXBL, IsKYBL, zyh, WardDR, InEQGroupDR, InOldNo, InIsFindDate, BookedType, IsUItem, IsCostRecords, UserID, InAppLocDR)
{
	s bOut="N"  ;是否已经输出
    s Regrowid=0 f  s Regrowid=$o(^DHCPACRegInfoi("StudyNo",StudyID,Regrowid)) q:Regrowid=""  d 
    .s GetPatientStatusCode="I"
    .s bOut="N"  ;是否已经输出
    .s Detail="明细",RejectAppReason="",ToDayOeItem="",CostRecords="",Urgentflag=""
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
    .s BodyDesc=$p(RegInfo,"^",16)
    .s GetRegDate=$p(RegInfo,"^",17)
    .s Urgentflag=$p(RegInfo,"^",18)
    .s RegDoc=$p(RegInfo,"^",19)
    .q:(InIsFindDate="true")&(GetRegDate<StdDate)!(GetRegDate>EndDate)
    .s FileSent=##class(web.DHCRisWorkBenchDoEx).GetFilmSendDesc(GetStudyNo)
    .s ReportSend=##class(web.DHCRisWorkBenchDoEx).GetReportSend(GetStudyNo)
    .s strXDate="",AppDate=""
    .s AppRowid=$o(^DHCRBAppOrdi(0,Oeorditemdr,0)) 
    .i AppRowid'="" d
    ..s XDate=$p($g(^DHCRBApp("Bill",AppRowid)),"^",10)
    ..s strXDate=$zd(XDate,3)
    ..s AppDate=$p($g(^DHCRBApp("Bill",AppRowid)),"^",1)
    ..i AppDate'="" s AppDate=$zd(AppDate,3)
    ..s Urgentflag=$p($g(^DHCRBApp("Bill",AppRowid)),"^",26)
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
    .q:(InAppLocDR'="")&(GetReqLocDR'=InAppLocDR)
    .s GetWardDR=$p(PatInfo,"^",14)
    .s Getroomdesc=$p(PatInfo,"^",15)
    .s GetSexDr=$p(PatInfo,"^",13)
    .s PapatmasDR=$p(PatInfo,"^",24)
    .s Weight=$p(PatInfo,"^",21)
	.s TelNo=$p(PatInfo,"^",19)
	.s PinYin=$p(PatInfo,"^",38)
	.s Epissubtype=$p($g(PatInfo),"^",41)
	.s AdmReason=$p($g(PatInfo),"^",43)
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
    .s GetSGroupDR=$p($g(ordInfo),"^",36)
    .s GetsubCatDesc=$p(ordInfo,"^",7)
    .s GetCatDesc=$p(ordInfo,"^",8)
    .s Getifbed=$p(ordInfo,"^",9)
    .s Getprice=$p(ordInfo,"^",10)
    .s GetNum=$p(ordInfo,"^",11)
    .s GetTotalPrice=$p(ordInfo,"^",12)
    .s Getbilled=$p(ordInfo,"^",13)
    .s GetItemStatusCode=$p(ordInfo,"^",14)
    .q:(GetItemStatusCode="U")&(IsUItem'="Y") ;查询作废医嘱
    .s GetordDate=$p(ordInfo,"^",15)
    .s GetordTime=$p(ordInfo,"^",16)
    .s GetItemStatusCode=$p(ordInfo,"^",17)   			;医嘱状态
    .s GetServerMaterial=$p(ordInfo,"^",18)   			;申请项目标记
    .s ResultFlag=$p(ordInfo,"^",20)    ;医嘱的结果状态--------------安贞医院用以前MEDTRAK 的结果处理，处理的的报告，在技师工作站中不在显示
    .s AutoInputFee=$p(ordInfo,"^",25) ;"需要另划价标志"
    .i AutoInputFee="Y" s ToDayOeItem="查询"
    .s EndInputFee=$p(ordInfo,"^",26)  ;"已另划价标识"
    .s BilledDesc=$p(ordInfo,"^",27)
    .s BodyDesc=$p(ordInfo,"^",29)
    .s CheckEntryFlag=$p(ordInfo,"^",30)
    .s GetExterFalg=$p(ordInfo,"^",32)  ;外部预约标识
    .q:(IsCostRecords'="Y")&(CheckEntryFlag="Y") 
    .i CheckEntryFlag="Y" s CostRecords="已补录"
    .q:(InRequireAppoint="N")&(GetSGroupDesc'="无需预约")&('(GetstrOrderName["床旁"))
    .q:(InRequireAppoint="Y")&((GetSGroupDesc="无需预约")!(GetstrOrderName["床旁"))
    .q:(InIsBedOrd="Y")&('(GetstrOrderName["床旁"))  ;检索床旁医嘱，不是床旁医嘱
    .i (GetstrOrderName["床旁") S Getifbed="Y"
    .;q:ResultFlag="V"
    .s AppointUserDR="",AppointUser=""
    .i (BookedType="1") d                  ; 新开发的预约系统
    ..s BookedRowid=$o(^DHCRBCResSchduleDetaili(0,Oeorditemdr,0))
    ..i BookedRowid'="" d
    ...s Flags=""
    ...s Flags=$p(^DHCRBCResSchduleDetail("Detail",BookedRowid),"^",7)
    ...s SchudleRowid=$p(^DHCRBCResSchduleDetail("Detail",BookedRowid),"^",2)
    ...i ((SchudleRowid'="")&(Flags'="Cancel")) d
    ....s ResourceId=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",1)
    ....s AppointUserDR=$p($g(^DHCRBCResSchduleDetail("Detail",BookedRowid)),"^",15)
	....i AppointUserDR'="" s AppointUser=$p($g(^SSU("SSUSR",AppointUserDR)),"^",2)
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
    ....;wf 按时间预约修改查询出来的预约开始时间
	....i $p($g(^DHCRBCResSchduleDetail("Detail",BookedRowid)),"^",18)'="" s RppTime=$p($g(^DHCRBCResSchduleDetail("Detail",BookedRowid)),"^",18)
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
    .i GetExterFalg'="" d
    ..s GetPatientStatusCode="B"
    ..s strRppDate=$p($g(^DHCRISBOOKEDINFO(Oeorditemdr)),"^",2)
    ..s strRppTime=$p($g(^DHCRISBOOKEDINFO(Oeorditemdr)),"^",3)
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
	;set Data=$lb(RegNo,Name,SexDesc,strDOB,strAge,IDCDesc,$g(StudyNo),strOrderName,requestdoc,strAccessionNum,strDate,strTime,$g(AppointDate),$g(AppointstTime),$g(strRegDate),$g(strRegTime),$g(getReportDoc),$g(GetVerifyDocName),PatientStatus,paadmdr,oeorditemdr,$g(LocName),TotalPrice,PatientStatusCode,billed,$g(typedesc),Num,price,$g(Index),$g(EQDesc),$g(ResDesc),ifbed,ReportStatus,MainDoc,AssDoc,RoomDesc)
 	//set Data=$lb(GetRegNo,GetName,GetSexDesc,GetstrDOB,GetstrAge,GetIDCDesc,GetStudyNo,GetstrOrderName,Getrequestdoc,GetstrAccessionNum,GetstrDate,GetstrTime,GetAppointDate,GetAppointstTime,GetstrRegDate,GetstrRegTime,GetReportDoc,GetVerifyDocName,GetPatientStatus,paadmdr,oeorditemdr,GetLocName,GetTotalPrice,GetPatientStatusCode,Getbilled,Gettypedesc,GetNum,Getprice,GetIndex,GetEQDesc,GetResDesc,Getifbed,GetReportStatus,GetMainDoc,GetAssDoc,GetRoomDesc)
   	//流水号,80;预约日期,80;预约时间,80;预约资源,100;床旁遗嘱,80;住院号，病区，房间号，床号，费别，检查部位，收费状态
   	s RecLoc=""
    i RecLocId'="" d
    .s RecLoc=$p(^CTLOC(RecLocId),"^",2)

   	s Required=""
   	if (GetSGroupDesc="无需预约")!(GetstrOrderName["床旁") s Required="N"
   	set Data=$lb(GetRegNo,GetName,GetSexDesc,GetstrAge,GetstrDOB,GetIDCDesc,
   	 GetStudyNo,GetstrOrderName,Getrequestdoc,GetstrAccessionNum,GetstrDate,GetstrTime,strRppDate,strRppTime,GetBookedDuration,GetstrRegDate,GetstrRegTime,GetRptDocName,GetVerifyDocName,GetPatientStatus,paadmdr,Oeorditemdr, 	 
   	 GetLocName,GetTotalPrice,GetPatientStatusCode,Getbilled,Gettypedesc,GetNum,Getprice,GetIndex,GetEQDesc,GetResDesc,Getifbed,GetReportStatus,GetMainDoc,GetAssDoc,GetRoomDesc,GetEQGroupDesc,GetWardName,GetOldNo,Required,strXDate,GetItemStatusCode,PapatmasDR,BodyDesc,Weight,TelNo,GetIPNo,FileSent,GetBedNo,ReportSend,HaveImage,RecLocId,RecLoc,AutoInputFee,EndInputFee,Detail,RejectAppReason,BilledDesc,PinYin,ToDayOeItem,CostRecords,AppDate,Urgentflag,RegDoc,Epissubtype,GetSGroupDesc,GetSGroupDR,$g(AppointUser),$g(AdmReason))
   	Set ^CacheTemp(repid,ind)=Data
   	s ^DHCRisTmpPrintData(ind)=GetRegNo_"^"_GetName_"^"_GetSexDesc_"^"_GetstrAge_"^"_GetWardName_"^"_GetBedNo_"^"_GetStudyNo_"^"_$g(ReportSend)
   	s ^DHCRisTmpPrintData=ind
   	
   	s ^DHCRisExportExcelData($g(UserID),ind)=GetRegNo_"^"_GetName_"^"_GetSexDesc_"^"_GetstrAge_"^"_GetstrDOB_"^"_GetIDCDesc_"^"_GetStudyNo_"^"_GetstrOrderName_"^"_Getrequestdoc_"^"_GetstrAccessionNum_"^"_GetstrDate_"^"_GetstrTime_"^"_strRppDate_"^"_strRppTime_"^"_$g(GetBookedDuration)_"^"_GetstrRegDate_"^"_GetstrRegTime_"^"_$g(GetRptDocName)_"^"_$g(GetVerifyDocName)_"^"_GetPatientStatus_"^"_paadmdr_"^"_Oeorditemdr_"^"_GetLocName_"^"_GetTotalPrice_"^"_GetPatientStatusCode_"^"_Getbilled_"^"_Gettypedesc_"^"_GetNum_"^"_Getprice_"^"_GetIndex_"^"_GetEQDesc_"^"_GetResDesc_"^"_Getifbed_"^"_GetReportStatus_"^"_GetMainDoc_"^"_GetAssDoc_"^"_GetRoomDesc_"^"_GetEQGroupDesc_"^"_GetWardName_"^"_$g(GetOldNo)_"^"_Required_"^"_strXDate_"^"_GetItemStatusCode_"^"_PapatmasDR_"^"_BodyDesc_"^"_Weight_"^"_TelNo_"^"_GetIPNo_"^"_FileSent_"^"_GetBedNo_"^"_ReportSend_"^"_HaveImage_"^"_RecLocId_"^"_RecLoc_"^"_AutoInputFee_"^"_EndInputFee_"^"_Detail_"^"_RejectAppReason_"^"_BilledDesc_"^"_PinYin_"^"_ToDayOeItem_"^"_CostRecords_"^"_AppDate_"^"_Urgentflag_"^"_RegDoc_"^"_Epissubtype_"^"_$g(GetSGroupDesc)_"^"_$g(GetSGroupDR)_"^"_$g(AppointUser)_"^"_$g(AdmReason)
   	s ^DHCRisExportExcelData($g(UserID))=ind
	Set ind=ind+1
 	quit
}

ClassMethod QueryByRegNo(ExmLocID, RoomDR, DeviceDR, PatTypeDR, InRegNo, StudyID, InName, InSexDR, Age, InStudyStatusCode, InRptStatusCode, StdDate, EndDate, OrderItemDR, StudyWay, InReqLocDR, RptDesc, RptDiagnose, RptDocDR, VerifyDocDR, IsYX, IsDXBL, IsKYBL, zyh, WardDR, InEQGroupDR, InOldNo, InIsFindDate, BookedType, IsUItem, IsCostRecords, UserID, InAppLocDR)
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
	....;b //01
	....;w !,"oeorditemdr="_oeorditemdr
	....s bodydrList=##Class(web.DHCRisWorkBenchDoEx).GetstrOrderName(oeorditemdr)
	....s AppBillNo=##Class(web.DHCAPPInterface).GetExaReqNo(oeorditemdr)    //申请单号
	....;w !,"bodydrList="_AppBillNo
	....s NumLeng=$L(bodydrList,"^")
	....f j=1:1:NumLeng  d  
	.....s bodypart=$p($g(bodydrList),"^",j)
	.....s bodypartcode=$p($g(bodypart),":",1) 
	.....s bodypart=$p($g(bodypart),":",2) 
	.....s reploc=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)  ;
	.....s bQLoc=..IsQueryLoc(ExmLocID,reploc)
	.....q:(bQLoc=0)
	.....;b //01
	.....;q:(reploc'=ExmLocID)&(ExmLocID'="")
	.....s Date1=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",9)
	.....q:(InIsFindDate="true")&(Date1<StdDate)!(Date1>EndDate)
	.....s bOut="N"  ;是否已经输出
	.....s Detail="明细",RejectAppReason="",ToDayOeItem="",CostRecords=""
	.....s paadmdr=$p(^OEORD(OrderRowid),"^",1) 
	.....s GetIDCDesc=##class(web.DHCRisCommFunctionEx).GetDiagnose(paadmdr)
    .....s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
    .....;w !,"PatInfo="_PatInfo
    .....s GetRegNo=$p(PatInfo,"^",1)
    .....s AccUsePrice=##Class(web.DHCRisWorkBenchDoEx).GetAccUsePrice(GetRegNo)
    .....s GetName=$p(PatInfo,"^",2)
    .....s GetstrDOB=$p(PatInfo,"^",3)
    .....;if GetstrDOB'="" d
    .....;.s GetstrDOB=$zd($zdh(GetstrDOB,4),3)
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
    .....q:(InAppLocDR'="")&(GetReqLocDR'=InAppLocDR)
    .....s GetWardDR=$p(PatInfo,"^",14)
    .....s Getroomdesc=$p(PatInfo,"^",15)
    .....s GetSexDr=$p(PatInfo,"^",13)
    .....s PapatmasDR=$p(PatInfo,"^",24)
    .....s Weight=$p(PatInfo,"^",21)
	.....s TelNo=$p(PatInfo,"^",19)
	.....s PinYin=$p(PatInfo,"^",38)
	.....s Epissubtype=$p($g(PatInfo),"^",41)
	.....s stay=$p($g(PatInfo),"^",42)
	.....s AdmReason=$p($g(PatInfo),"^",43)
    .....s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(OrderRowid,itemsub,bodypartcode)
    .....s GetstrOrderName=$p(ordInfo,"^",1)
    .....;i bodypart="" d
    .....;.s GetstrOrderName=GetstrOrderName
    .....;else  d
    .....;.s GetstrOrderName=GetstrOrderName_"("_bodypart_")"
    .....s BodyDescNew=bodypart
    .....s GetstrDate=$p(ordInfo,"^",2)
    .....s GetstrTime=$p(ordInfo,"^",3)
    .....s Getrequestdoc=$p(ordInfo,"^",4)
    .....s GetstrAccessionNum=$p(ordInfo,"^",5)
    .....s GetSGroupDesc=$p(ordInfo,"^",6)    ;是否需要预约项目的标记
    .....s GetSGroupDR=$p($g(ordInfo),"^",36)
    .....s GetsubCatDesc=$p(ordInfo,"^",7)
    .....s GetCatDesc=$p(ordInfo,"^",8)
    .....s Getifbed=$p(ordInfo,"^",9)
    .....s Getprice=$p(ordInfo,"^",10)
    .....s GetNum=$p(ordInfo,"^",11)
    .....s GetTotalPrice=$p(ordInfo,"^",12)
    .....s Getbilled=$p(ordInfo,"^",13)
    .....s GetItemStatusCode=$p(ordInfo,"^",14)
    .....q:(GetItemStatusCode="U")&(IsUItem'="Y") ;查询作废医嘱
    .....q:(GetItemStatusCode="U")!(GetItemStatusCode="D")!(GetItemStatusCode="C")
    .....s GetordDate=$p(ordInfo,"^",15)
    .....s GetordTime=$p(ordInfo,"^",16)
    .....s GetItemStatusCode=$p(ordInfo,"^",17)   			;医嘱状态
    .....s GetServerMaterial=$p(ordInfo,"^",18)   			;申请项目标记
    .....s ResultFlag=$p(ordInfo,"^",20)    ;医嘱的结果状态--------------安贞医院用以前MEDTRAK 的结果处理，处理的的报告，在技师工作站中不在显示
    .....s AutoInputFee=$p(ordInfo,"^",25) ;"需要另划价标志"
    .....i AutoInputFee="Y" s ToDayOeItem="查询"
    .....s EndInputFee=$p(ordInfo,"^",26)  ;"已另划价标识"
    .....s BilledDesc=$p(ordInfo,"^",27)
    .....;s BodyDesc=$p(ordInfo,"^",29)
    .....s CheckEntryFlag=$p(ordInfo,"^",30)
    .....s GetExterFalg=$p(ordInfo,"^",32)  ;外部预约标识
    .....s GetResultFlag=$p(ordInfo,"^",38) ;第三方回传报告状态
    .....s Urgentflag=$p(ordInfo,"^",35)
    .....q:(IsCostRecords'="Y")&(CheckEntryFlag="Y") 
    .....i CheckEntryFlag="Y" s CostRecords="已补录"
    .....q:(InRequireAppoint="N")&(GetSGroupDesc'="无需预约")&('(GetstrOrderName["床旁"))
    .....q:(InRequireAppoint="Y")&((GetSGroupDesc="无需预约")!(GetstrOrderName["床旁"))
    .....q:(InIsBedOrd="Y")&('(GetstrOrderName["床旁"))  ;检索床旁医嘱，不是床旁医嘱
    .....i (GetstrOrderName["床旁") S Getifbed="Y"
    .....;q:ResultFlag="V"
    .....s SystemParamInfo=##class(web.DHCRisCommFunction).GetSystemParam()
    .....s SendApptoLoc=$p(SystemParamInfo,"^",3)  ;没写申请单,是否发检查医嘱到检查科室
    .....s SendInPtoLoc=$p(SystemParamInfo,"^",4)  ;没收费是否把住院病人的检查项目发送到检查科室  
    .....s SendOutPtoLoc=$p(SystemParamInfo,"^",5) ;没收费是否把门诊检查项目发送到检查科室
    .....s SendEmPtoLoc=$p(SystemParamInfo,"^",6)   ;没收费是否把急诊病人检查项目发送到检查科室
    .....s QueryonlyExam=$p(SystemParamInfo,"^",9)  ;是否只查询检查项目
    .....s SendHPtoLoc=$p(SystemParamInfo,"^",10)   ;没收费是否把体检病人的检查项目发送检查科室
    .....;b //02
    .....q:(SendInPtoLoc="N")&(Getbilled'="P")&(Getpatienttype="I")    ;住院病人没有付费的退出
    .....q:(SendOutPtoLoc="N")&(Getbilled'="P")&(Getpatienttype="O")   ;门诊病人没有付费退出
    .....q:(SendEmPtoLoc="N")&(Getbilled'="P")&(stay'="STAY")&(Getpatienttype="E")   ;急症病人没付费退出
    .....q:(SendHPtoLoc="N")&(Getbilled'="P")&(Getpatienttype="H")   ;体检病人没付费退出
    .....q:(QueryonlyExam="Y")&(GetServerMaterial'="S") ;不是检查项目的则退出
    .....;b //03
    .....;------------------------------------------------------------------
    .....s GetPatientStatusCode="A"
    .....s GetReportStatusCode="N"
    .....s Getapprowid="",GetStudyNo=""
    .....s GetRoomDr="",strRppDate="",strRppTime=""
    .....s GetImgcount="",GetMainDoc="",GetAssDoc="",GetBookedDuration=""
    .....s GetRptID="",GetRptVersion="",GetRptIsYX="",GetEQGroupDesc="",GetOldNo=""
    .....s GetRptDocDR="",GetRptDocName="",GetRptDate="",GetRptTime="",GetVerifyDocDR=""
    .....s GetVerifyDocName="",GetVerifyDate="",GetVerifyTime="",GetStudyDescDR=""
    .....s GetStudyWay="",GetBodyPartDR="",GetIsKYBL="",GetIsTSBL="",GetResultDesc="",GetExamDesc=""
    .....s GetIndex="",GetstrRegDate="",GetstrRegTime="",GetEQDr="",GetEQDesc="",GetRoomDesc="",GetEQGroupDR="",HaveImage="",BKStudyNo=""
    .....s AppointUserDR="",AppointUser="",AppBillView=""
    .....s (BookedRowid,BKStudyNo,BKStudyNo,BKStudyNo,AppointUser,ResourceId,GetResDesc,RppDate,strRppDate,RppTime,strRppTime,TimePeriodeCode,GetBookedDuration)=""
    .....i GetItemStatusCode="D" s GetPatientStatusCode="D"
    .....;--------------------------------------------------------------------
    .....;w !,GetItemStatusCode
    .....i (GetItemStatusCode="V")!(GetItemStatusCode="E")!(GetItemStatusCode="D") d
    ......;w !,"Getpatienttype"_Getpatienttype_"^"_oeorditemdr_"^"_paadmdr_"^"_SendApptoLoc
    ......;b //09
    ......s strXDate="",AppDate=""
    ......s AllowSend="Y",AppRowid=""
    ......i ((SendApptoLoc="N")&(Getpatienttype="I"))  d
    .......s AppRowid=$o(^DHCRBAppOrdi(0,oeorditemdr,0)) 
    .......i AppRowid'="" d
    ........s AllowSend="Y"
    ........s XDate=$p($g(^DHCRBApp("Bill",AppRowid)),"^",10)
    ........s strXDate=##class(websys.Conversions).DateLogicalToHtml(XDate)    ;$zd(XDate,3)
    ........s AppDate=$p($g(^DHCRBApp("Bill",AppRowid)),"^",1)
    ........i AppDate'="" s AppDate=##class(websys.Conversions).DateLogicalToHtml(AppDate)   ;$zd(AppDate,3)
    ........s Urgentflag=$p($g(^DHCRBApp("Bill",AppRowid)),"^",26)
    ........s AppBillView="申请单浏览"
    .......else  d
    ........s AllowSend="N"
    ......;q:AllowSend="N"
    ......s GetRejDR=$o(^DHCRBRejecti("OeordDR",oeorditemdr,0))
	......i GetRejDR'="" d
	.......s GetPatientStatusCode="RJ" ;拒绝申请
	.......s RejectAppReason="拒绝原因"
	......else  d
	.......s GetResDesc="",strRppDate="",strRppTime=""
	.......i BookedType="1"  d
	........s BookedRowid=##class(web.DHCRisResApptSchudleSystem).getBookDetailRowid(oeorditemdr_"^"_bodypartcode)
	........;w !,oeorditemdr_"***"_bodypartcode_"***"_BookedRowid
	........q:(BookedRowid="")  //按部位判断是否预约 wf 20170119
	........s Flags=""
	........i BookedRowid'="" s Flags=$p($g(^DHCRBCResSchduleDetail("Detail",BookedRowid)),"^",7) 
    ........i ((BookedRowid'="")&(Flags'="Cancel")) d
    .........s GetPatientStatusCode="B"
    .........s BKStudyNo=$p($g(^DHCRBCResSchduleDetail("Detail",BookedRowid)),"^",6)
    .........s SchudleRowid=$p(^DHCRBCResSchduleDetail("Detail",BookedRowid),"^",2)
    .........s AppointUserDR=$p($g(^DHCRBCResSchduleDetail("Detail",BookedRowid)),"^",15)
	.........i AppointUserDR'="" s AppointUser=$p($g(^SSU("SSUSR",AppointUserDR)),"^",2)
    .........i (SchudleRowid'="") d
    ..........s ResourceId=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",1)
    ..........s ResDesc=""
 	..........s CTCPDR=$p($g(^RB("RES",ResourceId)),"^",2)
    ..........s CTCPDR=$p(CTCPDR,$c(0))
    ..........i CTCPDR'="" d
    ...........s GetResDesc=$p($g(^CTPCP(CTCPDR,1)),"^",2)
    ..........else  d
    ...........;w !,"ResourceId="_ResourceId
    ...........s EQDR=$p($g(^RB("RES",ResourceId)),"^",3)
    ..........;w !,"EQDR="_EQDR
    ..........q:(EQDR="")
    ..........s GetResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
    ..........s RppDate=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",2)
    ..........s strRppDate=##class(websys.Conversions).DateLogicalToHtml(RppDate) ;$zd(RppDate,3)
    ..........;w !,strRppDate
    ..........s RppTime=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",5)
    ..........;wf 按时间预约修改查询出来的预约开始时间
	..........i $p($g(^DHCRBCResSchduleDetail("Detail",BookedRowid)),"^",18)'="" s RppTime=$p($g(^DHCRBCResSchduleDetail("Detail",BookedRowid)),"^",18)
    ..........s strRppTime=##class(websys.Conversions).TimeLogicalToHtml(RppTime)    ;$zt(RppTime,1)
    ..........;w !,oeorditemdr
    ..........s TimePeriodeCode=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",3)
    ..........i TimePeriodeCode'="" d 
    ...........s TpsRowid=$o(^DHCRBCTimePeriodSeti("Code",TimePeriodeCode,0))
    ...........s GetBookedDuration=$p(^DHCRBCTimePeriodSet(TpsRowid),"^",2)
	.......else  d    
    ........i $g(^OEORD(OrderRowid,"I",itemsub,6))'="" d
    .........s Getapprowid=$p(^OEORD(OrderRowid,"I",itemsub,6),"^",5)
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
    ...........s strRppDate=##class(websys.Conversions).DateLogicalToHtml(RppDate)  ;$zd(RppDate,3)
    ...........s RppTime=$p(^RBAS(ResRowid,SchildSub),"^",4)
    ...........s strRppTime=##class(websys.Conversions).TimeLogicalToHtml(RppTime)    ;$zt(RppTime,1)
    ...........s GetBookedDuration=$p(^RBAS(ResRowid,SchildSub,"APPT",appointchildsub),"^",23)
    ......s ExterBK="N"
    ......i ((GetExterFalg'="")&&(GetPatientStatusCode'="B")) d
    .......s ExterBK="Y"
    .......s GetPatientStatusCode="B"
    .......;s strRppDate=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",2)
    .......;s strRppTime=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",3)
    .......s ExtRowid=..HasExternalBK(oeorditemdr,bodypartcode)  ;$o(^DHCRBCExternalBookInfoi("OrdItemID",oeorditemdr,""))
    .......i ExtRowid'="" d
    ........s RppDate=$p($g(^DHCRBCExternalBookInfo(ExtRowid)),"^",5)
    ........s RppTime=$p($g(^DHCRBCExternalBookInfo(ExtRowid)),"^",6)
    ........s GetResDesc=$p($g(^DHCRBCExternalBookInfo(ExtRowid)),"^",4)
    ........i RppDate'="" s strRppDate=##class(websys.Conversions).DateLogicalToHtml(RppDate)  ;$zd(AppointDate,3)
    ........i RppTime'="" s strRppTime=##class(websys.Conversions).TimeLogicalToHtml(RppTime)   ;$zt(AppointstTime,1)
	........s BKStudyNo=$p($g(^DHCRBCExternalBookInfo(ExtRowid)),"^",12)
	........s resCode=$p($g(^DHCRBCExternalBookInfo(ExtRowid)),"^",3)
	........i resCode'="" d
	.........s equipmentRowid=$o(^RBC("EQ",0,"Code",$$ALPHAUP^SSUTIL4(resCode),""))
	.........i equipmentRowid'="" d 
	..........s GetResDesc=$p($g(^RBC("EQ",equipmentRowid)),"^",2)
	......s GetImgcount=0
	......;i GetItemStatusCode="E"  d  ; 医嘱执行
	......s FileSent="" ;,BodyDesc=""
	......s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfo(oeorditemdr,bodypartcode)
	......;w !,"RegInfo="_RegInfo
    ......s GetStudyNo=$p(RegInfo,"^",1)
    ......i GetStudyNo'="" d
    .......s GetPatientStatusCode="I"
    ......e  d
    .......s GetStudyNo=""    //BKStudyNo  
    ......i GetStudyNo'="" d
   	.......;s GetPatientStatusCode="I"
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
    .......s BodyDescNew=$p(RegInfo,"^",17)
    .......s Urgentflag=$p(RegInfo,"^",21)
    .......s RegDoc=$p(RegInfo,"^",24)
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
    ........i GetRptDate'="" s GetRptDate=##class(websys.Conversions).DateLogicalToHtml(GetRptDate)  ;$zd(GetRptDate,3)
    ........s GetRptTime=$p(^DHCRBStudy("Report",Rptrowid),"^",10)
    ........i GetRptTime'="" s GetRptTime=##class(websys.Conversions).TimeLogicalToHtml(GetRptTime)   ;$zt(GetRptTime,3)
    ........s GetVerifyDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",11)
    ........i GetVerifyDocDR'="" s GetVerifyDocName=$p(^SSU("SSUSR",GetVerifyDocDR),"^",2)
    ........s GetVerifyDate=$p(^DHCRBStudy("Report",Rptrowid),"^",12)
    ........i GetVerifyDate'="" s GetVerifyDate=$zd(GetVerifyDate,3) 
    ........s GetVerifyTime=$p(^DHCRBStudy("Report",Rptrowid),"^",13)
    ........i GetVerifyTime'="" s GetVerifyTime=$zt(GetVerifyTime,3)
    ........s GetStudyDescDR=$p(^DHCRBStudy("Report",Rptrowid),"^",17)
    ........i GetStudyDescDR'="" s GetStudyWay=$p(^DHCRBStudy("StudyDesc",GetStudyDescDR),"^",7)
    ........;s GetBodyPartDR=$p(^DHCRBStudy("Report",Rptrowid),"^",19)
    ........s GetIsKYBL=$p(^DHCRBStudy("Report",Rptrowid),"^",21)
    ........s GetIsTSBL=$p(^DHCRBStudy("Report",Rptrowid),"^",22)
    ........s GetExamDesc=$p(^DHCRBStudy("Report",Rptrowid),"^",5)
    ........s GetResultDesc=$p(^DHCRBStudy("Report",Rptrowid),"^",6)
    ........;b //05
    ........i (InStudyStatusCode="")!(GetPatientStatusCode=InStudyStatusCode)
    .........s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
    .........s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
    .........s bOut="Y"
    .........;Do OutRow5
    .........do SortByOrderDate
    ......;b //06
    ......i (bOut="N")&(InStudyStatusCode="")!(GetPatientStatusCode=InStudyStatusCode) d
    .......s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
    .......s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
    .......s bOut="Y"
    .......;Do OutRow5
    .......do SortByOrderDate
    
    //Do OuetRow5byType
   do outOrder
   
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
   
   

SortByOrderDate
	s RecLoc=""
    i reploc'="" d
    .s RecLoc=$p(^CTLOC(reploc),"^",2)

   	s Required=""
   	if (GetSGroupDesc="无需预约")!(GetstrOrderName["床旁") s Required="N"
  	set Data=$lb(GetRegNo,GetName,GetSexDesc,GetstrAge,GetstrDOB,GetIDCDesc,
   	GetStudyNo,GetstrOrderName,Getrequestdoc,GetstrAccessionNum,GetstrDate,GetstrTime,strRppDate,strRppTime,GetBookedDuration,GetstrRegDate,GetstrRegTime,GetRptDocName,GetVerifyDocName,GetPatientStatus,paadmdr,oeorditemdr, 	 
   	GetLocName,GetTotalPrice,GetPatientStatusCode,Getbilled,Gettypedesc,GetNum,Getprice,GetIndex,GetEQDesc,GetResDesc,Getifbed,GetReportStatus,GetMainDoc,GetAssDoc,GetRoomDesc,GetEQGroupDesc,GetWardName,GetOldNo,Required,strXDate,GetItemStatusCode,PapatmasDR,BodyDescNew,Weight,TelNo,GetIPNo,FileSent,GetBedNo,ReportSend,HaveImage,reploc,RecLoc,AutoInputFee,EndInputFee,Detail,RejectAppReason,BilledDesc,PinYin,ToDayOeItem,CostRecords,AppDate,Urgentflag,RegDoc,Epissubtype,GetSGroupDesc,GetSGroupDR,$g(AppointUser),$g(AppBillView),$g(AdmReason),$g(ExterBK),$g(bodypartcode),$g(AppBillNo),$g(BKStudyNo),AccUsePrice,GetResultFlag)
   	;s ret=..SetQueryData(Getpatienttype,UserID,Data)
	if oeorditemdr="104||22" b //002
   	s sortOrderData(GetordDate,GetordTime,oeorditemdr_"|"_$g(bodypartcode))=Data
   	
   	//b //out
   	//Set ^CacheTemp(repid,ind)=Data
   	s ^DHCRisTmpPrintData(ind)=GetRegNo_"^"_GetName_"^"_GetSexDesc_"^"_GetstrAge_"^"_GetWardName_"^"_GetBedNo_"^"_GetStudyNo_"^"_$g(ReportSend)
   	s ^DHCRisTmpPrintData=ind
   	
   	s ^DHCRisExportExcelData($g(UserID),ind)=GetRegNo_"^"_GetName_"^"_GetSexDesc_"^"_GetstrAge_"^"_GetstrDOB_"^"_GetIDCDesc_"^"_GetStudyNo_"^"_GetstrOrderName_"^"_Getrequestdoc_"^"_GetstrAccessionNum_"^"_$g(GetstrDate)_"^"_$g(GetstrTime)_"^"_$g(strRppDate)_"^"_$g(strRppTime)_"^"_GetBookedDuration_"^"_GetstrRegDate_"^"_GetstrRegTime_"^"_GetRptDocName_"^"_GetVerifyDocName_"^"_GetPatientStatus_"^"_paadmdr_"^"_oeorditemdr_"^"_GetLocName_"^"_GetTotalPrice_"^"_GetPatientStatusCode_"^"_Getbilled_"^"_Gettypedesc_"^"_GetNum_"^"_Getprice_"^"_GetIndex_"^"_GetEQDesc_"^"_$g(GetResDesc)_"^"_Getifbed_"^"_GetReportStatus_"^"_GetMainDoc_"^"_GetAssDoc_"^"_GetRoomDesc_"^"_GetEQGroupDesc_"^"_GetWardName_"^"_GetOldNo_"^"_Required_"^"_strXDate_"^"_GetItemStatusCode_"^"_PapatmasDR_"^"_BodyDescNew_"^"_Weight_"^"_TelNo_"^"_GetIPNo_"^"_FileSent_"^"_GetBedNo_"^"_$g(ReportSend)_"^"_$g(HaveImage)_"^"_reploc_"^"_RecLoc_"^"_AutoInputFee_"^"_EndInputFee_"^"_Detail_"^"_$g(RejectAppReason)_"^"_BilledDesc_"^"_PinYin_"^"_$g(ToDayOeItem)_"^"_CostRecords_"^"_AppDate_"^"_Urgentflag_"^"_$g(RegDoc)_"^"_$g(Epissubtype)_"^"_$g(GetSGroupDesc)_"^"_GetSGroupDR_"^"_$g(AppointUser)_"^"_$g(AdmReason)_"^"_$g(bodypartcode)_"^"_$g(AppBillNo)_"^"_$g(BKStudyNo)_"^"_AccUsePrice_"^"_GetResultFlag
   	s ^DHCRisExportExcelData($g(UserID))=ind
	
	quit
	
outOrder
	s dateFor="" f  s dateFor=$o(sortOrderData(dateFor),-1) q:(dateFor="")  d
	.s timeFor="" f  s timeFor=$o(sortOrderData(dateFor,timeFor),-1) q:(timeFor="")  d
	..s orderid="" f  s orderid=$o(sortOrderData(dateFor,timeFor,orderid)) q:(orderid="")  d
	...Set ^CacheTemp(repid,ind)=sortOrderData(dateFor,timeFor,orderid)
 	...Set ind=ind+1 
	;b //01
	quit

OutRow5
    s RecLoc=""
    i reploc'="" d
    .s RecLoc=$p(^CTLOC(reploc),"^",2)

   	s Required=""
   	if (GetSGroupDesc="无需预约")!(GetstrOrderName["床旁") s Required="N"
  	set Data=$lb(GetRegNo,GetName,GetSexDesc,GetstrAge,GetstrDOB,GetIDCDesc,
   	GetStudyNo,GetstrOrderName,Getrequestdoc,GetstrAccessionNum,GetstrDate,GetstrTime,strRppDate,strRppTime,GetBookedDuration,GetstrRegDate,GetstrRegTime,GetRptDocName,GetVerifyDocName,GetPatientStatus,paadmdr,oeorditemdr, 	 
   	GetLocName,GetTotalPrice,GetPatientStatusCode,Getbilled,Gettypedesc,GetNum,Getprice,GetIndex,GetEQDesc,GetResDesc,Getifbed,GetReportStatus,GetMainDoc,GetAssDoc,GetRoomDesc,GetEQGroupDesc,GetWardName,GetOldNo,Required,strXDate,GetItemStatusCode,PapatmasDR,BodyDescNew,Weight,TelNo,GetIPNo,FileSent,GetBedNo,ReportSend,HaveImage,reploc,RecLoc,AutoInputFee,EndInputFee,Detail,RejectAppReason,BilledDesc,PinYin,ToDayOeItem,CostRecords,AppDate,Urgentflag,RegDoc,Epissubtype,GetSGroupDesc,GetSGroupDR,$g(AppointUser),$g(AppBillView),$g(AdmReason),$g(ExterBK),$g(bodypartcode),$g(AppBillNo),$g(BKStudyNo),AccUsePrice,GetResultFlag)
   	;s ret=..SetQueryData(Getpatienttype,UserID,Data)
   	Set ^CacheTemp(repid,ind)=Data
   	s ^DHCRisTmpPrintData(ind)=GetRegNo_"^"_GetName_"^"_GetSexDesc_"^"_GetstrAge_"^"_GetWardName_"^"_GetBedNo_"^"_GetStudyNo_"^"_$g(ReportSend)
   	s ^DHCRisTmpPrintData=ind
   	
   	s ^DHCRisExportExcelData($g(UserID),ind)=GetRegNo_"^"_GetName_"^"_GetSexDesc_"^"_GetstrAge_"^"_GetstrDOB_"^"_GetIDCDesc_"^"_GetStudyNo_"^"_GetstrOrderName_"^"_Getrequestdoc_"^"_GetstrAccessionNum_"^"_$g(GetstrDate)_"^"_$g(GetstrTime)_"^"_$g(strRppDate)_"^"_$g(strRppTime)_"^"_GetBookedDuration_"^"_GetstrRegDate_"^"_GetstrRegTime_"^"_GetRptDocName_"^"_GetVerifyDocName_"^"_GetPatientStatus_"^"_paadmdr_"^"_oeorditemdr_"^"_GetLocName_"^"_GetTotalPrice_"^"_GetPatientStatusCode_"^"_Getbilled_"^"_Gettypedesc_"^"_GetNum_"^"_Getprice_"^"_GetIndex_"^"_GetEQDesc_"^"_$g(GetResDesc)_"^"_Getifbed_"^"_GetReportStatus_"^"_GetMainDoc_"^"_GetAssDoc_"^"_GetRoomDesc_"^"_GetEQGroupDesc_"^"_GetWardName_"^"_GetOldNo_"^"_Required_"^"_strXDate_"^"_GetItemStatusCode_"^"_PapatmasDR_"^"_BodyDescNew_"^"_Weight_"^"_TelNo_"^"_GetIPNo_"^"_FileSent_"^"_GetBedNo_"^"_$g(ReportSend)_"^"_$g(HaveImage)_"^"_reploc_"^"_RecLoc_"^"_AutoInputFee_"^"_EndInputFee_"^"_Detail_"^"_$g(RejectAppReason)_"^"_BilledDesc_"^"_PinYin_"^"_$g(ToDayOeItem)_"^"_CostRecords_"^"_AppDate_"^"_Urgentflag_"^"_$g(RegDoc)_"^"_$g(Epissubtype)_"^"_$g(GetSGroupDesc)_"^"_GetSGroupDR_"^"_$g(AppointUser)_"^"_$g(AdmReason)_"^"_$g(bodypartcode)_"^"_$g(AppBillNo)_"^"_$g(BKStudyNo)_"^"_AccUsePrice_"^"_GetResultFlag
   	s ^DHCRisExportExcelData($g(UserID))=ind
	Set ind=ind+1
	quit
	
OuetRow5byType
	
	s ind=1
    s ArrayType=..GetQueryOrder()
    s numl=0
    s numl=$L(ArrayType,"@")
    f i=1:1:numl  d
    .s type=$p(ArrayType,"@",i)
    .for j=1:1:$g(^tempQueryNum(UserID,type)) d
    ..Set ^CacheTemp(repid,ind)=$g(^DHCRISTEMPQUERYDATA(UserID,type,j))
	..Set ind=ind+1
 	quit
}

ClassMethod QueryByName(ExmLocID, RoomDR, DeviceDR, PatTypeDR, InRegNo, StudyID, InName, InSexDR, Age, InStudyStatusCode, InRptStatusCode, StdDate, EndDate, OrderItemDR, StudyWay, InReqLocDR, RptDesc, RptDiagnose, RptDocDR, VerifyDocDR, IsYX, IsDXBL, IsKYBL, zyh, WardDR, InEQGroupDR, InOldNo, InIsFindDate, BookedType, IsUItem, IsCostRecords, UserID, InAppLocDR)
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
		.....s bodydrList=##Class(web.DHCRisWorkBenchDoEx).GetstrOrderName(oeorditemdr)
		.....;w !,"bodydrList="_bodydrList
		.....s NumLeng=$L(bodydrList,"^")
		.....f j=1:1:NumLeng  d  
		......s bodypart=$p($g(bodydrList),"^",j)
		.....;q:(reploc'=ExmLocID)&(ExmLocID'="")
		.....s bQLoc=..IsQueryLoc(ExmLocID,reploc)
		.....q:(bQLoc=0)
		.....s Date1=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",9)
		.....q:(InIsFindDate="true")&(Date1<StdDate)!(Date1>EndDate)
		.....s bOut="N"  ;是否已经输出
		.....s Detail="明细",RejectAppReason="",ToDayOeItem="",CostRecords=""
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
	    .....q:(InAppLocDR'="")&(GetReqLocDR'=InAppLocDR)
	    .....s GetWardDR=$p(PatInfo,"^",14)
	    .....s Getroomdesc=$p(PatInfo,"^",15)
	    .....s GetSexDr=$p(PatInfo,"^",13)
	    .....s PapatmasDR=$p(PatInfo,"^",24)
	    .....s Weight=$p(PatInfo,"^",21)
		.....s TelNo=$p(PatInfo,"^",19)
		.....s PinYin=$p(PatInfo,"^",38)
		.....s Epissubtype=$p($g(PatInfo),"^",41)
		.....s stay=$p($g(PatInfo),"^",42)
		.....s AdmReason=$p($g(PatInfo),"^",43)
	    .....s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(OrderRowid,itemsub)
	    .....s GetstrOrderName=$p(ordInfo,"^",1)
	    .....i bodypart="" d
    	......s GetstrOrderName=GetstrOrderName
    	.....else  d
    	......s GetstrOrderName=GetstrOrderName_"("_bodypart_")"
    	.....s BodyDescNew=bodypart
	    .....s GetstrDate=$p(ordInfo,"^",2)
	    .....s GetstrTime=$p(ordInfo,"^",3)
	    .....s Getrequestdoc=$p(ordInfo,"^",4)
	    .....s GetstrAccessionNum=$p(ordInfo,"^",5)
	    .....s GetSGroupDesc=$p(ordInfo,"^",6)    ;是否需要预约项目的标记
	    .....s GetSGroupDR=$p($g(ordInfo),"^",36)
	    .....s GetsubCatDesc=$p(ordInfo,"^",7)
	    .....s GetCatDesc=$p(ordInfo,"^",8)
	    .....s Getifbed=$p(ordInfo,"^",9)
	    .....s Getprice=$p(ordInfo,"^",10)
	    .....s GetNum=$p(ordInfo,"^",11)
	    .....s GetTotalPrice=$p(ordInfo,"^",12)
	    .....s Getbilled=$p(ordInfo,"^",13)
	    .....s GetItemStatusCode=$p(ordInfo,"^",14)
	    .....q:(GetItemStatusCode="U")&(IsUItem'="Y") ;查询作废医嘱
	    .....q:(GetItemStatusCode="U")!(GetItemStatusCode="D")!(GetItemStatusCode="C")
	    .....s GetordDate=$p(ordInfo,"^",15)
	    .....s GetordTime=$p(ordInfo,"^",16)
	    .....s GetItemStatusCode=$p(ordInfo,"^",17)   			;医嘱状态
	    .....s GetServerMaterial=$p(ordInfo,"^",18)   			;申请项目标记
	    .....s AutoInputFee=$p(ordInfo,"^",25) ;"需要另划价标志"
	    .....i AutoInputFee="Y" s ToDayOeItem="查询"
	    .....s EndInputFee=$p(ordInfo,"^",26)  ;"已另划价标识"
	    .....s BilledDesc=$p(ordInfo,"^",27)
	    .....;s BodyDesc=$p(ordInfo,"^",29)
	    .....s CheckEntryFlag=$p(ordInfo,"^",30)
	    .....s GetExterFalg=$p(ordInfo,"^",32)  ;外部预约标识 
	    .....q:(IsCostRecords'="Y")&(CheckEntryFlag="Y")
        .....i CheckEntryFlag="Y" s CostRecords="已补录"
	    .....s ResultFlag=$p(ordInfo,"^",20)    ;医嘱的结果状态--------------安贞医院用以前MEDTRAK 的结果处理，处理的的报告，在技师工作站中不在显示
	    .....;q:ResultFlag="V"
	    .....q:(InRequireAppoint="N")&(GetSGroupDesc'="无需预约")&('(GetstrOrderName["床旁"))
        .....q:(InRequireAppoint="Y")&((GetSGroupDesc="无需预约")!(GetstrOrderName["床旁"))
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
	    .....q:(SendEmPtoLoc="N")&(Getbilled'="P")&(stay'="STAY")&(Getpatienttype="E")   ;急症病人没付费退出
	    .....q:(SendHPtoLoc="N")&(Getbilled'="P")&(Getpatienttype="H")   ;体检病人没付费退出
	    .....q:(QueryonlyExam="Y")&(GetServerMaterial'="S") ;不是检查项目的则退出
	    .....;------------------------------------------------------------------
	    .....s GetPatientStatusCode="A"
	    .....s GetReportStatusCode="N"
	    .....s Getapprowid="",GetStudyNo="",BKStudyNo=""
	    .....s GetRoomDr=""
	    .....s GetImgcount="",GetMainDoc="",GetAssDoc=""
	    .....s GetRptID="",GetRptVersion="",GetRptIsYX="",GetEQGroupDesc="",GetOldNo=""
	    .....s GetRptDocDR="",GetRptDocName="",GetRptDate="",GetRptTime="",GetVerifyDocDR=""
	    .....s GetVerifyDocName="",GetVerifyDate="",GetVerifyTime="",GetStudyDescDR=""
	    .....s GetStudyWay="",GetBodyPartDR="",GetIsKYBL="",GetIsTSBL="",GetResultDesc="",GetExamDesc=""
	    .....s GetIndex="",GetstrRegDate="",GetstrRegTime="",GetEQDr="",GetEQDesc="",GetRoomDesc="",GetEQGroupDR=""
	    .....s GetResDesc="",strRppDate="",strRppTime="",GetBookedDuration="",HaveImage="",Urgentflag="",BKStudyNo=""
	    .....s AppointUserDR="",AppointUser="",AppBillView=""
	    .....i GetItemStatusCode="D" s GetPatientStatusCode="D"
	    .....;--------------------------------------------------------------------
	    .....i (GetItemStatusCode="V")!(GetItemStatusCode="E")!(GetItemStatusCode="D") d
	    ......s strXDate="",AppDate=""
	    ......s AllowSend="Y"
	    ......i (SendApptoLoc="N")&(Getpatienttype="I")  d
	    .......s AppRowid=$o(^DHCRBAppOrdi(0,oeorditemdr,0)) 
	    .......i AppRowid'="" d
	    ........s AllowSend="Y"
	    ........s XDate=$p($g(^DHCRBApp("Bill",AppRowid)),"^",10)
	    ........s strXDate=$zd(XDate,3)
	    ........s AppDate=$p($g(^DHCRBApp("Bill",AppRowid)),"^",1)
        ........i AppDate'="" s AppDate=$zd(AppDate,3)
        ........s Urgentflag=$p($g(^DHCRBApp("Bill",AppRowid)),"^",26)
        ........s AppBillView="申请单浏览"
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
	    .........s Flags=""
	    .........s Flags=$p($g(^DHCRBCResSchduleDetail("Detail",BookedRowid)),"^",7)
	    .........q:(Flags="Cancel")
	    .........s GetPatientStatusCode="B"
	    .........s BKStudyNo=$p($g(^DHCRBCResSchduleDetail("Detail",BookedRowid)),"^",6)
	    .........s AppointUserDR=$p($g(^DHCRBCResSchduleDetail("Detail",BookedRowid)),"^",15)
	    .........i AppointUserDR'="" s AppointUser=$p($g(^SSU("SSUSR",AppointUserDR)),"^",2)
	    .........s SchudleRowid=$p($g(^DHCRBCResSchduleDetail("Detail",BookedRowid)),"^",2)
	    .........i SchudleRowid'="" d
	    ..........s ResourceId=$p($g(^DHCRBCResourceSchdule(SchudleRowid)),"^",1)
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
	    ..........;wf 按时间预约修改查询出来的预约开始时间
	    ..........i $p($g(^DHCRBCResSchduleDetail("Detail",BookedRowid)),"^",18)'="" s RppTime=$p($g(^DHCRBCResSchduleDetail("Detail",BookedRowid)),"^",18)
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
	    ......s ExterBK="N"
	    ......i GetExterFalg'="" d
	    .......s ExterBK="Y"
        .......s GetPatientStatusCode="B"
        .......s strRppDate=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",2)
        .......s strRppTime=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",3)
		......s GetImgcount=0
		......;i GetItemStatusCode="E"  d  ; 医嘱执行
		......s GetStudyNo="",FileSent="",RegDoc=""   ;登记
		......s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfo(oeorditemdr)
	    ......s GetStudyNo=$p(RegInfo,"^",1)
	    ......i GetStudyNo'="" d
	   	.......s GetPatientStatusCode="I"
	   	......e  d
	   	.......s GetStudyNo="" //BKStudyNo
	    ......i GetStudyNo'="" d
	   	.......;s GetPatientStatusCode="I"
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
	    .......s Urgentflag=$p(RegInfo,"^",21)
	    .......s RegDoc=$p(RegInfo,"^",24)
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
   	 GetLocName,GetTotalPrice,GetPatientStatusCode,Getbilled,Gettypedesc,GetNum,Getprice,GetIndex,GetEQDesc,GetResDesc,Getifbed,GetReportStatus,GetMainDoc,GetAssDoc,GetRoomDesc,GetEQGroupDesc,GetWardName,GetOldNo,Required,strXDate,GetItemStatusCode,PapatmasDR,BodyDescNew,Weight,TelNo,GetIPNo,FileSent,GetBedNo,ReportSend,HaveImage,reploc,RecLoc,AutoInputFee,EndInputFee,Detail,RejectAppReason,BilledDesc,PinYin,ToDayOeItem,CostRecords,AppDate,Urgentflag,RegDoc,Epissubtype,GetSGroupDesc,GetSGroupDR,$g(AppointUser),$g(AppBillView),$g(AdmReason),$g(ExterBK))
   	Set ^CacheTemp(repid,ind)=Data
   	s ^DHCRisTmpPrintData(ind)=GetRegNo_"^"_GetNameL_"^"_GetSexDesc_"^"_GetstrAge_"^"_GetWardName_"^"_GetBedNo_"^"_GetStudyNo_"^"_$g(ReportSend)
   	s ^DHCRisTmpPrintData=ind
   	s ^DHCRisExportExcelData($g(UserID),ind)=GetRegNo_"^"_GetNameL_"^"_GetSexDesc_"^"_GetstrAge_"^"_GetstrDOB_"^"_GetIDCDesc_"^"_GetStudyNo_"^"_GetstrOrderName_"^"_Getrequestdoc_"^"_GetstrAccessionNum_"^"_GetstrDate_"^"_GetstrTime_"^"_strRppDate_"^"_strRppTime_"^"_$g(GetBookedDuration)_"^"_GetstrRegDate_"^"_GetstrRegTime_"^"_$g(GetRptDocName)_"^"_$g(GetVerifyDocName)_"^"_$g(GetPatientStatus)_"^"_paadmdr_"^"_oeorditemdr_"^"_GetLocName_"^"_GetTotalPrice_"^"_GetPatientStatusCode_"^"_Getbilled_"^"_Gettypedesc_"^"_GetNum_"^"_Getprice_"^"_GetIndex_"^"_GetEQDesc_"^"_GetResDesc_"^"_Getifbed_"^"_GetReportStatus_"^"_GetMainDoc_"^"_GetAssDoc_"^"_GetRoomDesc_"^"_GetEQGroupDesc_"^"_GetWardName_"^"_$g(GetOldNo)_"^"_$g(Required)_"^"_strXDate_"^"_GetItemStatusCode_"^"_PapatmasDR_"^"_BodyDescNew_"^"_Weight_"^"_TelNo_"^"_$g(GetIPNo)_"^"_$g(FileSent)_"^"_GetBedNo_"^"_$g(ReportSend)_"^"_$g(HaveImage)_"^"_reploc_"^"_RecLoc_"^"_$g(AutoInputFee)_"^"_$g(EndInputFee)_"^"_Detail_"^"_$g(RejectAppReason)_"^"_BilledDesc_"^"_PinYin_"^"_ToDayOeItem_"^"_CostRecords_"^"_AppDate_"^"_$g(Urgentflag)_"^"_$g(RegDoc)_"^"_Epissubtype_"^"_GetSGroupDesc_"^"_GetSGroupDR_"^"_$g(AppointUser)_"^"_$g(AdmReason)
   	s ^DHCRisExportExcelData($g(UserID))=ind
	Set ind=ind+1
 	quit
}

ClassMethod QueryByOldNo(ExmLocID, RoomDR, DeviceDR, PatTypeDR, InRegNo, StudyID, InName, InSexDR, Age, InStudyStatusCode, InRptStatusCode, StdDate, EndDate, OrderItemDR, StudyWay, InReqLocDR, RptDesc, RptDiagnose, RptDocDR, VerifyDocDR, IsYX, IsDXBL, IsKYBL, zyh, WardDR, InEQGroupDR, InOldNo, InIsFindDate, BookedType, IsUItem, IsCostRecords, UserID, InAppLocDR)
{
	s Nodr=0 f  s Nodr=$o(^DHCPACRegInfoNOi("No",1,InOldNo,Nodr)) q:Nodr=""  d
	.s Regrowid=0 f  s Regrowid=$o(^DHCPACRegInfoi("No",Nodr,Regrowid)) q:Regrowid=""  d   
	..s bOut="N"  ;是否已经输出
    ..s GetPatientStatusCode="I"
    ..s Detail="明细",RejectAppReason="拒绝原因",ToDayOeItem="",CostRecords="",Urgentflag=""
    ..s AppBillView=""
    ..s RegDoc=""
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
    ..s BodyDesc=$p(RegInfo,"^",16)
    ..s GetRegDate=$p(RegInfo,"^",17)
    ..s Urgentflag=$p(RegInfo,"^",18)
    ..s RegDoc=$p(RegInfo,"^",19)
    ..q:(InIsFindDate="true")&(GetRegDate<StdDate)!(GetRegDate>EndDate)
    ..s FileSent=##class(web.DHCRisWorkBenchDoEx).GetFilmSendDesc(GetStudyNo)
    ..s ReportSend=##class(web.DHCRisWorkBenchDoEx).GetReportSend(GetStudyNo)
    ..s OrderRowid=$p(Oeorditemdr,"||",1)
    ..s itemsub=$p(Oeorditemdr,"||",2)
    ..s strXDate="",AppDate=""
    ..s AppRowid=$o(^DHCRBAppOrdi(0,Oeorditemdr,0))
    ..i AppRowid'="" d
    ...s XDate=$p($g(^DHCRBApp("Bill",AppRowid)),"^",10)
    ...s strXDate=$zd(XDate,3)
    ...s AppDate=$p($g(^DHCRBApp("Bill",AppRowid)),"^",1)
    ...i AppDate'="" s AppDate=$zd(AppDate,3)
    ...s Urgentflag=$p($g(^DHCRBApp("Bill",AppRowid)),"^",26)
    ...s AppBillView="申请单浏览"
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
    ..q:(InAppLocDR'="")&(GetReqLocDR'=InAppLocDR)
    ..s GetWardDR=$p(PatInfo,"^",14)
    ..s Getroomdesc=$p(PatInfo,"^",15)
    ..s GetSexDr=$p(PatInfo,"^",13)
    ..s PapatmasDR=$p(PatInfo,"^",24)
    ..s Weight=$p(PatInfo,"^",21)
	..s TelNo=$p(PatInfo,"^",19)
	..s PinYin=$p(PatInfo,"^",38)
	..s Epissubtype=$p($g(PatInfo),"^",41)
	..s AdmReason=$p($g(PatInfo),"^",43)
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
    ..s GetSGroupDR=$p($g(ordInfo),"^",36)
    ..s GetsubCatDesc=$p(ordInfo,"^",7)
    ..s GetCatDesc=$p(ordInfo,"^",8)
    ..s Getifbed=$p(ordInfo,"^",9)
    ..s Getprice=$p(ordInfo,"^",10)
    ..s GetNum=$p(ordInfo,"^",11)
    ..s GetTotalPrice=$p(ordInfo,"^",12)
    ..s Getbilled=$p(ordInfo,"^",13)
    ..s GetItemStatusCode=$p(ordInfo,"^",14)
    ..q:(GetItemStatusCode="U")&(IsUItem'="Y") ;查询作废医嘱
    ..q:(GetItemStatusCode="U")!(GetItemStatusCode="D")!(GetItemStatusCode="C")
    ..s GetordDate=$p(ordInfo,"^",15)
    ..s GetordTime=$p(ordInfo,"^",16)
    ..s GetItemStatusCode=$p(ordInfo,"^",17)   			;医嘱状态
    ..s GetServerMaterial=$p(ordInfo,"^",18)   			;申请项目标记
    ..s AutoInputFee=$p(ordInfo,"^",25) ;"需要另划价标志"
    ..i AutoInputFee="Y" s ToDayOeItem="查询"
    ..s EndInputFee=$p(ordInfo,"^",26)  ;"已另划价标识"
    ..s BilledDesc=$p(ordInfo,"^",27)
    ..s BodyDesc=$p(ordInfo,"^",29)
    ..s CheckEntryFlag=$p(ordInfo,"^",30)
    ..s GetExterFalg=$p(ordInfo,"^",32)  ;外部预约标识
    ..q:(IsCostRecords'="Y")&(CheckEntryFlag="Y") 
    ..i CheckEntryFlag="Y" s CostRecords="已补录"
    ..;s ResultFlag=$p(ordInfo,"^",20)    ;医嘱的结果状态--------------安贞医院用以前MEDTRAK 的结果处理，处理的的报告，在技师工作站中不在显示
    ..;q:ResultFlag="V"
    ..s GetResDesc="",strRppDate="",strRppTime="",GetBookedDuration="",AppointUserDR="",AppointUser=""
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
    ..s ExterBK="N" 
    ..i GetExterFalg'="" d
    ...s ExterBK="Y" 
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
    ..i GetItemStatusCode="D" s GetPatientStatusCode="D"
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
    
   //Do OutRowz4byYtpe
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
OutRowz4
	s Required=""
   	if (GetSGroupDesc="无需预约")!(GetstrOrderName["床旁") s Required="N"
   	set Data=$lb(GetRegNo,GetName,GetSexDesc,GetstrAge,GetstrDOB,GetIDCDesc,
   	 GetStudyNo,GetstrOrderName,Getrequestdoc,GetstrAccessionNum,GetstrDate,GetstrTime,strRppDate,strRppTime,$g(GetBookedDuration),GetstrRegDate,GetstrRegTime,GetRptDocName,GetVerifyDocName,GetPatientStatus,paadmdr,oeorditemdr, 	 
   	 GetLocName,GetTotalPrice,GetPatientStatusCode,Getbilled,Gettypedesc,GetNum,Getprice,GetIndex,GetEQDesc,GetResDesc,Getifbed,GetReportStatus,GetMainDoc,GetAssDoc,GetRoomDesc,GetEQGroupDesc,GetWardName,GetOldNo,Required,strXDate,GetItemStatusCode,PapatmasDR,BodyDesc,Weight,TelNo,GetIPNo,FileSent,GetBedNo,ReportSend,HaveImage,$g(InLocID),RecLoc,AutoInputFee,EndInputFee,Detail,RejectAppReason,BilledDesc,PinYin,ToDayOeItem,CostRecords,AppDate,Urgentflag,RegDoc,Epissubtype,GetSGroupDesc,GetSGroupDR,AppointUser,$g(AppBillView),$g(AdmReason),$g(ExterBK))
   	 ;s ret=..SetQueryData(Getpatienttype,UserID,Data)
   	 Set ^CacheTemp(repid,ind)=Data
     s ^DHCRisTmpPrintData(ind)=GetRegNo_"^"_GetName_"^"_GetSexDesc_"^"_GetstrAge_"^"_GetWardName_"^"_GetBedNo_"^"_GetStudyNo_"^"_$g(ReportSend)
   	 s ^DHCRisTmpPrintData=ind
   	 s ^DHCRisExportExcelData($g(UserID),ind)=GetRegNo_"^"_GetName_"^"_GetSexDesc_"^"_GetstrAge_"^"_GetstrDOB_"^"_GetIDCDesc_"^"_GetStudyNo_"^"_GetstrOrderName_"^"_Getrequestdoc_"^"_GetstrAccessionNum_"^"_GetstrDate_"^"_GetstrTime_"^"_strRppDate_"^"_strRppTime_"^"_$g(GetBookedDuration)_"^"_GetstrRegDate_"^"_GetstrRegTime_"^"_$g(GetRptDocName)_"^"_$g(GetVerifyDocName)_"^"_GetPatientStatus_"^"_paadmdr_"^"_oeorditemdr_"^"_GetLocName_"^"_GetTotalPrice_"^"_GetPatientStatusCode_"^"_Getbilled_"^"_Gettypedesc_"^"_GetNum_"^"_Getprice_"^"_GetIndex_"^"_GetEQDesc_"^"_GetResDesc_"^"_Getifbed_"^"_GetReportStatus_"^"_GetMainDoc_"^"_GetAssDoc_"^"_GetRoomDesc_"^"_GetEQGroupDesc_"^"_GetWardName_"^"_$g(GetOldNo)_"^"_$g(Required)_"^"_strXDate_"^"_GetItemStatusCode_"^"_PapatmasDR_"^"_BodyDesc_"^"_Weight_"^"_TelNo_"^"_$g(GetIPNo)_"^"_FileSent_"^"_GetBedNo_"^"_$g(ReportSend)_"^"_$g(HaveImage)_"^"_$g(InLocID)_"^"_RecLoc_"^"_$g(AutoInputFee)_"^"_$g(EndInputFee)_"^"_Detail_"^"_$g(RejectAppReason)_"^"_BilledDesc_"^"_PinYin_"^"_ToDayOeItem_"^"_CostRecords_"^"_AppDate_"^"_$g(Urgentflag)_"^"_$g(RegDoc)_"^"_$g(Epissubtype)_"^"_GetSGroupDesc_"^"_GetSGroupDR_"^"_$g(AppointUser)_"^"_$g(AdmReason)
   	 s ^DHCRisExportExcelData($g(UserID))=ind
     Set ind=ind+1
     quit
     
OutRowz4byYtpe    
 	s ind=1
    s ArrayType=..GetQueryOrder()
    s numl=0
    s numl=$L(ArrayType,"@")
    f i=1:1:numl  d
    .s type=$p(ArrayType,"@",i)
    .for j=1:1:$g(^tempQueryNum(UserID,type)) d
    ..Set ^CacheTemp(repid,ind)=$g(^DHCRISTEMPQUERYDATA(UserID,type,j))
	..Set ind=ind+1
 	quit
}

ClassMethod QueryBookedItem(Intype, InStatusCode, Inpaadmdr, InAppStDate, InLocID, InResourceID, InReportDoc, InReportVerifyDoc, InIsBedOrd, InRoomDR, InRegEQDR, InRequireAppoint, InRegNo, InStudyNo, InName, InPatientNo, InAppLocDR, InEQGroupDR, InWardDR, InNO, IsFilmSet, BookedType, IsUItem, IsCostRecords, UserID, gAppLoc) As %Integer
{
    
	 k ^DHCRISTMEP("TEMPITEMROWID")
	 k bookOrderList
	 s Detail="明细",RejectAppReason="",ToDayOeItem="",CostRecords=""
	 ;b //01
	 Set RowIdBook="" f  s RowIdBook=$o(^RB("RES",0,"CTLOC",InLocID,RowIdBook) ) q:RowIdBook=""  d
	 .;b //03
	 .s ResDesc=""
	 .s CTCPDR=$p($g(^RB("RES",RowIdBook)),"^",2)
	 .i CTCPDR'="" d
	 ..s GetResDesc=$p($g(^CTPCP(CTCPDR,1)),"^",2)
	 .else  d
	 ..s EQDR=$p($g(^RB("RES",RowIdBook)),"^",3)
	 ..i EQDR'="" s GetResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
	 .;w !,"GetResDesc="_GetResDesc
	 .q:(InResourceID'="")&(InResourceID'=RowIdBook)
	 .i BookedType="1" d
	 ..s gSchRowid="",DetailRowid=""
	 ..;s ExterBK="N"
	 ..;b //02
	 ..s gSchRowid=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",InLocID,InAppStDate,RowIdBook,gSchRowid))
	 ..;b //03
	 ..i (gSchRowid'="") d
	 ...s SchRowid=0 f  s SchRowid=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",InLocID,InAppStDate,RowIdBook,SchRowid)) q:SchRowid=""  d
	 ....s DetailRowid=0  f  s DetailRowid=$o(^DHCRBCResSchduleDetaili("SchudleId",SchRowid,DetailRowid)) q:DetailRowid=""  d
	 .....s oeorditemdr=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",1)
	 .....q:(oeorditemdr="")
	 .....;w !,"oeorditemdr="_oeorditemdr
	 .....;s AppBillNo=##Class(web.DHCEMInterface).GetExaReqNo(oeorditemdr)    //申请单号
	 .....s Flag="",AppointUserDR="",AppointUser=""
	 .....s Flag=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",7)
	 .....q:(Flag="Cancel")
	 .....;q:($d(^DHCRISTMEP("TEMPITEMROWID",oeorditemdr)))
	 .....;s ^DHCRISTMEP("TEMPITEMROWID",oeorditemdr)=""
	 .....s CTCPDR=$p($g(^RB("RES",RowIdBook)),"^",2)
	 .....i CTCPDR'="" d
	 ......s GetResDesc=$p($g(^CTPCP(CTCPDR,1)),"^",2)
	 .....else  d
	 ......s EQDR=$p($g(^RB("RES",RowIdBook)),"^",3)
	 ......i EQDR'="" s GetResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
	 .....s AppointDate=$p(^DHCRBCResourceSchdule(SchRowid),"^",2)
	 .....s GetAppointDate=##class(websys.Conversions).DateLogicalToHtml(AppointDate) ;$zd(AppointDate,3)
	 .....s AppointstTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",5)
	 .....;wf 按时间预约修改查询出来的预约开始时间
	 .....i $p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",18)'="" s AppointstTime=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",18)
	 .....s GetAppointstTime=##class(websys.Conversions).TimeLogicalToHtml(AppointstTime) ;$zt(AppointstTime,1)
	 .....;w !,"oeorditemdr="_oeorditemdr
	 .....s BKStudyNo="",AppointUserDR="",AppointUser=""
	 .....s BKStudyNo=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",6)
	 .....s AppointUserDR=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",15)
	 .....i AppointUserDR'="" s AppointUser=$p($g(^SSU("SSUSR",AppointUserDR)),"^",2)
	 .....Do OutRowA
	 .e  d
	 ..;b //01
	 ..s session=""
	 ..;s ExterBK="N"
	 ..f  s session=$o(^RBAS(RowIdBook,0,"DateSTime",InAppStDate,session)) q:session=""  d
	 ...s childsub=0 f  s childsub=$o(^RBAS(RowIdBook,0,"DateSTime",InAppStDate,session,childsub)) q:childsub=""  d
	 ....s apptschinfo=^RBAS(RowIdBook,childsub)
	 ....s AppointDate=$p(apptschinfo,"^",1)
	 ....q:AppointDate'=InAppStDate
	 ....s GetAppointDate=##class(websys.Conversions).DateLogicalToHtml(AppointDate) ;$zd(AppointDate,3)
	 ....s AppointstTime=$p(apptschinfo,"^",4)
	 ....s GetAppointstTime=##class(websys.Conversions).TimeLogicalToHtml(AppointstTime) ;$zt(AppointstTime,1)
	 ....s ApptRowid=RowIdBook_"||"_childsub
	 ....s BKStudyNo=""
	 ....; RB_Appointment
	 ....s appointchildsub=0  f  s appointchildsub=$o(^RBAS(RowIdBook,childsub,"APPT",appointchildsub)) q:appointchildsub=""  d
	 .....s apppintrowid=ApptRowid_"||"_appointchildsub
	 .....s ordrowid=0 
	 .....s GetBookedDuration=$p(^RBAS(RowIdBook,childsub,"APPT",appointchildsub),"^",23) 
	 .....s ordrowid=$o(^OEORDi(0,"Appt",apppintrowid,ordrowid))
	 .....; 根据预约的时间点找医嘱
	 .....i ordrowid'=""  d
	 ......s orditemchildsub=0  
	 ......s orditemchildsub=$o(^OEORDi(0,"Appt",apppintrowid,ordrowid,orditemchildsub))
	 ......s oeorditemdr=ordrowid_"||"_orditemchildsub
	 ......Do OutRowA
	 
	 //..i ((DetailRowid="")!(DetailRowid=0)) d //e  d
	 //...;b //02
	 s DEBRwoid="" f  s DEBRwoid=$o(^DHCRBCExternalBookInfoi("Date",InAppStDate,InLocID,DEBRwoid)) q:(DEBRwoid="")  d
	 .s oeorditemdr=$p(^DHCRBCExternalBookInfo(DEBRwoid),"^",2)
	 .;s ExterBK="Y"
	 .q:(oeorditemdr="")
	 .q:(InResourceID'="")  ;第三方预约不支持按预约资源查询
	 .;w !,DEBRwoid_"**"_InLocID 
	 .;q:($d(^DHCRISTMEP("TEMPITEMROWID",oeorditemdr)))
	 .;s ^DHCRISTMEP("TEMPITEMROWID",oeorditemdr)=""
	 .;w !,"oeorditemdrExt1="_oeorditemdr_"----"_ExterBK
	 .;b //03
	 .s AppointDate="",AppointstTime=""
	 .s AppointDate=$p($g(^DHCRBCExternalBookInfo(DEBRwoid)),"^",5)
	 .i AppointDate'="" s GetAppointDate=##class(websys.Conversions).DateLogicalToHtml(AppointDate)  ;$zd(AppointDate,3)
	 .s AppointstTime=$p($g(^DHCRBCExternalBookInfo(DEBRwoid)),"^",6)
	 .i AppointstTime'="" s GetAppointstTime=##class(websys.Conversions).TimeLogicalToHtml(AppointstTime)   ;$zt(AppointstTime,1)
	 .s GetResDesc=$p($g(^DHCRBCExternalBookInfo(DEBRwoid)),"^",4)
	 .s resCode=$p($g(^DHCRBCExternalBookInfo(DEBRwoid)),"^",3)
	 .i resCode'="" d
	 ..s equipmentRowid=$o(^RBC("EQ",0,"Code",$$ALPHAUP^SSUTIL4(resCode),""))
	 ..i equipmentRowid'="" d 
	 ...s GetResDesc=$p($g(^RBC("EQ",equipmentRowid)),"^",2)
	 .;w !,"exter GetResDesc="_GetResDesc
	 .s BKStudyNo=$p($g(^DHCRBCExternalBookInfo(DEBRwoid)),"^",12)
	 .s AppointUser=$p($g(^DHCRBCExternalBookInfo(DEBRwoid)),"^",7)
	 .Do OutRowA
	 
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
	 
OutRowA
	 //s bodydrList=##Class(web.DHCRisWorkBenchDoEx).GetstrOrderName(oeorditemdr)
	 s AppBillNo=##Class(web.DHCAPPInterface).GetExaReqNo(oeorditemdr)    //申请单号
	 
	 s bodydrList=""
	 if ($g(DetailRowid)'="")
	 {
	 	s bodydrList=..GetBookDetailBodyList($g(DetailRowid))
	 }
	 if ($g(DEBRwoid)'="")
	 {
		 s bodydrList=..GetExternalBookBodyListByRowid(DEBRwoid)
	 }
	 
	 if (bodydrList="")
	 {
		 ;获取医嘱的部位
		 s bodydrList=..GetstrOrderName(oeorditemdr)
	 }
	 
	 ;w !,oeorditemdr_"**"_$g(DetailRowid)_"**"_$g(DEBRwoid)_"**"_bodydrList
	 s NumLeng=$L(bodydrList,"^")
	 f j=1:1:NumLeng  d  
	 .s bodypart=$p($g(bodydrList),"^",j)
	 .s bodypartcode=$p($g(bodypart),":",1)
	 .;增加按部位判断是否预约
	 .;s detailBodyRowid=""
	 .;i ((bodypartcode'="")&(DetailRowid'="")) d
	 .;.s detailBodyRowid=$o(^User.DHCRBCSchduleDetailBodyI("IndexDetailBody",DetailRowid,bodypartcode,0))
	 .;q:((bodypartcode'="")&&(DetailRowid'="")&&(detailBodyRowid=""))
	 .;;;;;;;;;
	 .s bodypart=$p($g(bodypart),":",2) 
	 .s appOrderStatus=..getOrderBodyStatus(oeorditemdr,bodypartcode)
	 .s appOrderStatus=$p(appOrderStatus,"^",1)
	 .;w !,appOrderStatus_"**"_oeorditemdr_"**"_bodypartcode
	 .q:((appOrderStatus="D")||(appOrderStatus="C"))
	 .s GetPaadmr=$p($g(^OEORD($p($g(oeorditemdr),"||",1))),"^",1)
	 .s AppRowid=$o(^DHCRBAppOrdi(0,oeorditemdr,0)) 
	 .s AppDate="",Urgentflag="",AppBillView=""
	 .i AppRowid'="" d
	 ..s XDate=$p($g(^DHCRBApp("Bill",AppRowid)),"^",10)
	 ..s strXDate=##class(websys.Conversions).DateLogicalToHtml(XDate) ;$zd(XDate,3)
	 ..s AppDate=$p($g(^DHCRBApp("Bill",AppRowid)),"^",1)
     ..i AppDate'="" s AppDate=##class(websys.Conversions).DateLogicalToHtml(AppDate) ;$zd(AppDate,3)
     ..s Urgentflag=$p($g(^DHCRBApp("Bill",AppRowid)),"^",26)
     ..s AppBillView="申请单浏览"
	 .q:(Inpaadmdr'="")&(GetPaadmr'=Inpaadmdr)
	 .q:$g(GetPaadmr)=""
	 .s papatmasmdr=$p(^PAADM(GetPaadmr),"^",1)  
	 .;get patient diagnose 
	 .s GetIDCDesc=##class(web.DHCRisCommFunctionEx).GetDiagnose(GetPaadmr)
	 .s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(GetPaadmr)
	 .s GetRegNo=$p(PatInfo,"^",1)
	 .s AccUsePrice=##Class(web.DHCRisWorkBenchDoEx).GetAccUsePrice(GetRegNo)
	 .s GetName=$p(PatInfo,"^",2)
	 .s GetstrDOB=$p(PatInfo,"^",3)
	 .;if GetstrDOB'="" d
     .;.s GetstrDOB=$zd($zdh(GetstrDOB,4),3)
	 .s GetstrAge=$p(PatInfo,"^",4)
	 .s GetSexDesc=$p(PatInfo,"^",5)
	 .s Getpatienttype=$p(PatInfo,"^",6)
	 .s Gettypedesc=$p(PatInfo,"^",7)
	 .s GetLocName=$p(PatInfo,"^",8)
	 .s GetIPNo=$p(PatInfo,"^",9)
	 .s GetWardName=$p(PatInfo,"^",10)
	 .s GetBedNo=$p(PatInfo,"^",11)
	 .s GetLocdr=$p(PatInfo,"^",12)
	 .;q:(gAppLoc'=GetLocdr)&(GetLocdr'="") ;中国医大增加
	 .s GetWardDr=$p(PatInfo,"^",14)
	 .s PapatmasDR=$p(PatInfo,"^",24)
	 .s Weight=$p(PatInfo,"^",21)
	 .s TelNo=$p(PatInfo,"^",19)
	 .s PinYin=$p(PatInfo,"^",38)
	 .s Epissubtype=$p($g(PatInfo),"^",41)
	 .s AdmReason=$p($g(PatInfo),"^",43)
	 .q:(InWardDR'="")&(GetWardDr'=InWardDR)
	 .q:(InRegNo'="")&(GetRegNo'=InRegNo)
	 .q:(InName'="")&(GetName'[InName)
	 .q:(InPatientNo'="")&(InPatientNo'=GetIPNo)
	 .q:(InAppLocDR'="")&(GetLocdr'=InAppLocDR)
	 .q:(Intype'="")&(Intype'=Getpatienttype)
	 .s ordrowid=$p(oeorditemdr,"||",1)
	 .s orditemchildsub=$p(oeorditemdr,"||",2)
	 .s CheckEntryFlag="",CostRecords=""
	 .s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(ordrowid,orditemchildsub,bodypartcode)	 
	 .s GetstrOrderName=$p(ordInfo,"^",1)
	 .;i bodypart="" d
	 .;.s GetstrOrderName=GetstrOrderName
	 .;else  d
	 .;.s GetstrOrderName=GetstrOrderName_"("_bodypart_")"
	 ..s BodyDescNew=bodypart
	 .s GetstrDate=$p(ordInfo,"^",2)
	 .s GetstrTime=$p(ordInfo,"^",3)
	 .s Getrequestdoc=$p(ordInfo,"^",4)
	 .s GetstrAccessionNum=$p(ordInfo,"^",5)
	 .s GetSGroupDesc=$p(ordInfo,"^",6)
	 .s GetSGroupDR=$p($g(ordInfo),"^",36)
	 .s GetsubCatDesc=$p(ordInfo,"^",7)
	 .s GetCatDesc=$p(ordInfo,"^",8)
	 .s Getifbed=$p(ordInfo,"^",9)
	 .s Getprice=$p(ordInfo,"^",10)
	 .s GetNum=$p(ordInfo,"^",11)
	 .s GetTotalPrice=$p(ordInfo,"^",12)
	 .s Getbilled=$p(ordInfo,"^",13)
	 .s GetItemStatusCode=$p(ordInfo,"^",14)
	 .q:(GetItemStatusCode="U")&(IsUItem'="Y") ;查询作废医嘱
	 .q:(GetItemStatusCode="U")!(GetItemStatusCode="D")!(GetItemStatusCode="C")
	 .s GetordDate=$p(ordInfo,"^",15)
	 .s GetordTime=$p(ordInfo,"^",16)
	 .s GetItemStatusCode=$p(ordInfo,"^",17)
	 .s AutoInputFee=$p(ordInfo,"^",25) ;"需要另划价标志"
	 .i AutoInputFee="Y" s ToDayOeItem="查询"
	 .s EndInputFee=$p(ordInfo,"^",26)  ;"已另划价标识"
	 .s BilledDesc=$p(ordInfo,"^",27)
	 .s BodyDescNew=bodypart
	 .s CheckEntryFlag=$p(ordInfo,"^",30)
	 .s GetExterFalg=$p(ordInfo,"^",32)  ;外部预约标识
	 .s GetResultFlag=$p(ordInfo,"^",38) ;第三方回传报告状态
	 .s Urgentflag=$p(ordInfo,"^",35)
	 .q:(IsCostRecords'="Y")&(CheckEntryFlag="Y") 
     .i CheckEntryFlag="Y" s CostRecords="已补录"
	 .;s ResultFlag=$p(ordInfo,"^",20)    ;医嘱的结果状态--------------安贞医院用以前MEDTRAK 的结果处理，处理的的报告，在技师工作站中不在显示
	 .;q:ResultFlag="V"
	 .q:(InIsBedOrd="Y")&(Getifbed'="Y")  ;检索床旁医嘱，不是床旁医嘱
	 .s GetPatientStatusCode="B"
	 .s ExterBK="N"
     .i GetExterFalg'="" s ExterBK="Y"
	 .s GetReportStatusCode="N"  ;未写报告
	 .s GetstrRegDate="",GetstrRegTime="",GetRptDocName="",GetVerifyDocName="",GetStudyNo="",GetIndex="",GetEQDesc=""
	 .s GetEQDr="",GetMainDoc="",GetAssDoc="",GetRoomDesc="",GetRoomDr="",GetEQGroupDR="",GetEQGroupDesc=""
	 .s bOut="N",FileSent="",HaveImage="" ,RegDoc=""
	 .;i (GetItemStatusCode="E") d
	 .;s GetPatientStatusCode="I"  ;登记
	 .s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfo(oeorditemdr,bodypartcode)
	 .s GetStudyNo=$p(RegInfo,"^",1)
	 .i GetStudyNo'="" d
	 ..s GetPatientStatusCode="I"
	 .e  d
	 ..s GetPatientStatusCode="B"  s GetStudyNo=""    ;BKStudyNo   不取预约的检查号
	 .i GetStudyNo'="" d
	 ..;s GetPatientStatusCode="I"  ;登记
	 ..s GetstrRegDate=$p(RegInfo,"^",2)
	 ..s GetstrRegTime=$p(RegInfo,"^",3)
	 ..s GetIndex=$p(RegInfo,"^",4)
	 ..s GetEQDesc=$p(RegInfo,"^",5)
	 ..s GetMainDoc=$p(RegInfo,"^",6)
	 ..s GetAssDoc=$p(RegInfo,"^",7)
	 ..s GetRoomDesc=$p(RegInfo,"^",8)
	 ..s GetRoomDr=$p(RegInfo,"^",9)
	 ..s GetEQDr=$p(RegInfo,"^",10)
	 ..s GetEQGroupDesc=$p(RegInfo,"^",11)
	 ..s GetEQGroupDR=$p(RegInfo,"^",12)
	 ..s NO=$p(RegInfo,"^",13)
	 ..;s BodyDescNew=$p(RegInfo,"^",17)
	 ..s Urgentflag=$p(RegInfo,"^",21)
	 ..s RegDoc=$p(RegInfo,"^",24)
	 ..s FileSent=##class(web.DHCRisWorkBenchDoEx).GetFilmSendDesc(GetStudyNo)
	 ..s ReportSend=##class(web.DHCRisWorkBenchDoEx).GetReportSend(GetStudyNo)
	 ..s GetImgcount=0
	 ..s Imrowid=0 f  s Imrowid=$o(^DHCRBStudyi("StudyNo-Images",GetStudyNo,Imrowid)) q:Imrowid=""  d
	 ...s GetPatientStatusCode="E"    ;正在检查
	 ...s ExtName=$p($g(^DHCRBStudy(0,"StudyImages",Imrowid)),"^",2)
	 ...i ((ExtName="avi")!(ExtName="dcm")!(ExtName="normal")!(ExtName="dsa"))  d
	 ....s GetImgcount=GetImgcount+1
	 ....s ReportStatusCode="I"             ;图象已经采集
	 ....s HaveImage="是"
	 ..s sReportStuatCode="VS"
	 ..s Rptrowid=0  f  s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",GetStudyNo,Rptrowid)) q:Rptrowid=""  d
	 ...s GetRptID=$p(^DHCRBStudy("Report",Rptrowid),"^",2)
	 ...s GetRptVersion=$p(^DHCRBStudy("Report",Rptrowid),"^",3)
	 ...s GetRptStatusDR=$p(^DHCRBStudy("Report",Rptrowid),"^",4)
	 ...i GetRptStatusDR'="" d
	 ....s GetReportStatusCode=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",1)
	 ....i sReportStuatCode[GetReportStatusCode d
	 .....s GetPatientStatusCode="O"
	 ....e  d
	 .....s GetPatientStatusCode="E"
	 ...s GetRptDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",8)
	 ...i GetRptDocDR'="" s GetRptDocName=$p(^SSU("SSUSR",GetRptDocDR),"^",2)
	 ...s GetRptDate=$p(^DHCRBStudy("Report",Rptrowid),"^",9)
	 ...i GetRptDate'="" s GetRptDate=##class(websys.Conversions).DateLogicalToHtml(GetRptDate) ;$zd(GetRptDate,3)
	 ...s GetRptTime=$p(^DHCRBStudy("Report",Rptrowid),"^",10)
	 ...i GetRptTime'="" s GetRptTime=##class(websys.Conversions).TimeLogicalToHtml(GetRptTime)  ;$zt(GetRptTime,3)
	 ...s GetVerifyDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",11)
	 ...i GetVerifyDocDR'="" s GetVerifyDocName=$p(^SSU("SSUSR",GetVerifyDocDR),"^",2)
	 ...s GetVerifyDate=$p(^DHCRBStudy("Report",Rptrowid),"^",12)
	 ...i GetVerifyDate'="" s GetVerifyDate=$zd(GetVerifyDate,3) 
	 ...s GetVerifyTime=$p(^DHCRBStudy("Report",Rptrowid),"^",13)
	 ...i GetVerifyTime'="" s GetVerifyTime=$zt(GetVerifyTime,3)
	 ...i ((IsFilmSet="false")!((IsFilmSet="true")&(FileSent="已发片")))&((InStudyNo="")!(GetStudyNo=InStudyNo))&((InEQGroupDR="")!(GetEQGroupDR=InEQGroupDR))&((InRoomDR="")!(GetRoomDr=InRoomDR))&((InRegEQDR="")!(InRegEQDR=GetEQDr))&((InStatusCode="")!(InStatusCode[GetPatientStatusCode))&((InReportDoc="")!(InReportDoc=GetRptDocName))&((InVerifyDOc="")!(InVerifyDOc=GetVerifyDocName)) d 
	 ....s PatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
	 ....s ReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
	 ....s bOut="Y"
	 ....s RecLoc=""
     ....i InLocID'="" s RecLoc=$p(^CTLOC(InLocID),"^",2)
     ....s Required="Y"
     ....;w !,"oeorditemdrB01="_oeorditemdr_"###"_ExterBK
     ....set Data=$lb(GetRegNo,GetName,GetSexDesc,GetstrAge,GetstrDOB,GetIDCDesc,GetStudyNo,GetstrOrderName,Getrequestdoc,GetstrAccessionNum,GetstrDate,GetstrTime,GetAppointDate,GetAppointstTime,$g(GetBookedDuration),GetstrRegDate,GetstrRegTime,GetRptDocName,GetVerifyDocName,PatientStatus,GetPaadmr,oeorditemdr,GetLocName,GetTotalPrice,GetPatientStatusCode,Getbilled,Gettypedesc,GetNum,Getprice,GetIndex,GetEQDesc,GetResDesc,Getifbed,ReportStatus,GetMainDoc,GetAssDoc,GetRoomDesc,GetEQGroupDesc,GetWardName,NO,Required,strXDate,GetItemStatusCode,PapatmasDR,$g(BodyDescNew),Weight,TelNo,GetIPNo,FileSent,GetBedNo,ReportSend,HaveImage,InLocID,RecLoc,AutoInputFee,EndInputFee,Detail,RejectAppReason,BilledDesc,PinYin,ToDayOeItem,CostRecords,AppDate,Urgentflag,RegDoc,Epissubtype,GetSGroupDesc,GetSGroupDR,$g(AppointUser),$g(AppBillView),$g(AdmReason),$g(ExterBK),$g(bodypartcode),$g(AppBillNo),$g(BKStudyNo),AccUsePrice,GetResultFlag)
     ....s ^CacheTemp(repid,ind)=Data
     ....s ^DHCRisTmpPrintData(ind)=GetRegNo_"^"_GetName_"^"_GetSexDesc_"^"_GetstrAge_"^"_GetWardName_"^"_GetBedNo_"^"_GetStudyNo_"^"_$g(ReportSend)
   	 ....s ^DHCRisTmpPrintData=ind
   	 ....s ^DHCRisExportExcelData($g(UserID),ind)=$g(GetRegNo)_"^"_$g(GetName)_"^"_$g(GetSexDesc)_"^"_$g(GetstrAge)_"^"_$g(GetstrDOB)_"^"_$g(GetIDCDesc)_"^"_$g(GetStudyNo)_"^"_$g(GetstrOrderName)_"^"_$g(Getrequestdoc)_"^"_$g(GetstrAccessionNum)_"^"_$g(GetstrDate)_"^"_$g(GetstrTime)_"^"_$g(GetAppointDate)_"^"_$g(GetAppointstTime)_"^"_$g(GetBookedDuration)_"^"_$g(GetstrRegDate)_"^"_$g(GetstrRegTime)_"^"_$g(GetRptDocName)_"^"_$g(GetVerifyDocName)_"^"_$g(PatientStatus)_"^"_$g(GetPaadmr)_"^"_$g(oeorditemdr)_"^"_$g(GetLocName)_"^"_$g(GetTotalPrice)_"^"_$g(GetPatientStatusCode)_"^"_$g(Getbilled)_"^"_$g(Gettypedesc)_"^"_$g(GetNum)_"^"_$g(Getprice)_"^"_$g(GetIndex)_"^"_$g(GetEQDesc)_"^"_$g(GetResDesc)_"^"_Getifbed_"^"_ReportStatus_"^"_GetMainDoc_"^"_GetAssDoc_"^"_GetRoomDesc_"^"_GetEQGroupDesc_"^"_GetWardName_"^"_NO_"^"_Required_"^"_$g(strXDate)_"^"_GetItemStatusCode_"^"_PapatmasDR_"^"_$g(BodyDescNew)_"^"_Weight_"^"_TelNo_"^"_$g(GetIPNo)_"^"_$g(FileSent)_"^"_$g(GetBedNo)_"^"_$g(ReportSend)_"^"_$g(HaveImage)_"^"_InLocID_"^"_RecLoc_"^"_$g(AutoInputFee)_"^"_$g(EndInputFee)_"^"_$g(Detail)_"^"_$g(RejectAppReason)_"^"_$g(BilledDesc)_"^"_$g(PinYin)_"^"_$g(ToDayOeItem)_"^"_$g(CostRecords)_"^"_$g(AppDate)_"^"_$g(Urgentflag)_"^"_$g(RegDoc)_"^"_$g(Epissubtype)_"^"_$g(GetSGroupDesc)_"^"_$g(GetSGroupDR)_"^"_$g(AppointUser)_"^"_$g(AdmReason)_"^"_$g(bodypartcode)_"^"_$g(AppBillNo)_"^"_$g(BKStudyNo)_"^"_AccUsePrice_"^"_GetResultFlag
   	 ....s ^DHCRisExportExcelData($g(UserID))=ind
   	 ....Set ind=ind+1
  
	 .i ((IsFilmSet="false")!((IsFilmSet="true")&(FileSent="已发片")))&((InStudyNo="")!(GetStudyNo=InStudyNo))&((InEQGroupDR="")!(GetEQGroupDR=InEQGroupDR))&((InRoomDR="")!(GetRoomDr=InRoomDR))&((InRegEQDR="")!(InRegEQDR=GetEQDr))&((InStatusCode="")!(InStatusCode[GetPatientStatusCode))&((InReportDoc="")!(InReportDoc=GetRptDocName))&((InVerifyDOc="")!(InVerifyDOc=GetVerifyDocName))&(bOut="N") d 
	 ..s PatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
	 ..s ReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
	 ..s bOut="Y"
	 ..s RecLoc=""
     ..i InLocID'="" s RecLoc=$p(^CTLOC(InLocID),"^",2)
     ..s Required="Y"
     ..;w !,"oeorditemdrB02="_oeorditemdr_"###"_ExterBK
     ..;w !,"GetEQDesc="_AppBillNo
     ..;w !,"GetResDesc="_GetResDesc
     ..;set Data=$lb(GetRegNo,GetName,GetSexDesc,GetstrAge,GetstrDOB,GetIDCDesc,GetStudyNo,GetstrOrderName,Getrequestdoc,GetstrAccessionNum,GetstrDate,GetstrTime,GetAppointDate,GetAppointstTime,$g(GetBookedDuration),GetstrRegDate,GetstrRegTime,GetRptDocName,GetVerifyDocName,PatientStatus,GetPaadmr,oeorditemdr,GetLocName,GetTotalPrice,GetPatientStatusCode,Getbilled,Gettypedesc,GetNum,Getprice,GetIndex,GetEQDesc,GetResDesc,Getifbed,ReportStatus,GetMainDoc,GetAssDoc,GetRoomDesc,GetEQGroupDesc,GetWardName,NO,Required,strXDate,GetItemStatusCode,PapatmasDR,$g(BodyDescNew),Weight,TelNo,GetIPNo,FileSent,GetBedNo,ReportSend,HaveImage,InLocID,RecLoc,AutoInputFee,EndInputFee,Detail,RejectAppReason,BilledDesc,PinYin,ToDayOeItem,CostRecords,AppDate,Urgentflag,RegDoc,Epissubtype,GetSGroupDesc,GetSGroupDR,$g(AppointUser),$g(AppBillView),$g(AdmReason),$g(ExterBK),$g(bodypartcode),$g(AppBillNo),$g(BKStudyNo),AccUsePrice,GetResultFlag)
     ..set Data=$lb(GetRegNo,GetName,GetSexDesc,GetstrAge,GetstrDOB,"",GetStudyNo,GetstrOrderName,Getrequestdoc,GetstrAccessionNum,GetstrDate,GetstrTime,GetAppointDate,GetAppointstTime,$g(GetBookedDuration),GetstrRegDate,GetstrRegTime,GetRptDocName,GetVerifyDocName,PatientStatus,GetPaadmr,oeorditemdr,GetLocName,GetTotalPrice,GetPatientStatusCode,Getbilled,Gettypedesc,GetNum,Getprice,GetIndex,GetEQDesc,GetResDesc,Getifbed,ReportStatus,GetMainDoc,GetAssDoc,GetRoomDesc,GetEQGroupDesc,GetWardName,NO,Required,strXDate,GetItemStatusCode,PapatmasDR,$g(BodyDescNew),Weight,TelNo,GetIPNo,FileSent,GetBedNo,ReportSend,HaveImage,InLocID,RecLoc,AutoInputFee,EndInputFee,Detail,RejectAppReason,BilledDesc,PinYin,ToDayOeItem,CostRecords,AppDate,Urgentflag,RegDoc,Epissubtype,GetSGroupDesc,GetSGroupDR,$g(AppointUser),$g(AppBillView),$g(AdmReason),$g(ExterBK),$g(bodypartcode),$g(AppBillNo),$g(BKStudyNo),AccUsePrice,GetResultFlag)
     ..s ^DHCRisTmpPrintData(ind)=GetRegNo_"^"_GetName_"^"_GetSexDesc_"^"_GetstrAge_"^"_GetWardName_"^"_GetBedNo_"^"_GetStudyNo_"^"_$g(ReportSend)
   	 ..s ^DHCRisTmpPrintData=ind
   	 ..s ^DHCRisExportExcelData($g(UserID),ind)=$g(GetRegNo)_"^"_$g(GetName)_"^"_$g(GetSexDesc)_"^"_$g(GetstrAge)_"^"_$g(GetstrDOB)_"^"_$g(GetIDCDesc)_"^"_$g(GetStudyNo)_"^"_$g(GetstrOrderName)_"^"_$g(Getrequestdoc)_"^"_$g(GetstrAccessionNum)_"^"_$g(GetstrDate)_"^"_$g(GetstrTime)_"^"_$g(GetAppointDate)_"^"_$g(GetAppointstTime)_"^"_$g(GetBookedDuration)_"^"_$g(GetstrRegDate)_"^"_$g(GetstrRegTime)_"^"_$g(GetRptDocName)_"^"_$g(GetVerifyDocName)_"^"_$g(PatientStatus)_"^"_$g(GetPaadmr)_"^"_$g(oeorditemdr)_"^"_$g(GetLocName)_"^"_$g(GetTotalPrice)_"^"_$g(GetPatientStatusCode)_"^"_$g(Getbilled)_"^"_$g(Gettypedesc)_"^"_$g(GetNum)_"^"_$g(Getprice)_"^"_$g(GetIndex)_"^"_$g(GetEQDesc)_"^"_$g(GetResDesc)_"^"_Getifbed_"^"_ReportStatus_"^"_GetMainDoc_"^"_GetAssDoc_"^"_GetRoomDesc_"^"_GetEQGroupDesc_"^"_GetWardName_"^"_$g(NO)_"^"_Required_"^"_$g(strXDate)_"^"_GetItemStatusCode_"^"_PapatmasDR_"^"_$g(BodyDescNew)_"^"_Weight_"^"_TelNo_"^"_$g(GetIPNo)_"^"_$g(FileSent)_"^"_$g(GetBedNo)_"^"_$g(ReportSend)_"^"_$g(HaveImage)_"^"_InLocID_"^"_RecLoc_"^"_$g(AutoInputFee)_"^"_$g(EndInputFee)_"^"_$g(Detail)_"^"_$g(RejectAppReason)_"^"_$g(BilledDesc)_"^"_$g(PinYin)_"^"_$g(ToDayOeItem)_"^"_$g(CostRecords)_"^"_$g(AppDate)_"^"_$g(Urgentflag)_"^"_$g(RegDoc)_"^"_$g(Epissubtype)_"^"_$g(GetSGroupDesc)_"^"_$g(GetSGroupDR)_"^"_$g(AppointUser)_"^"_$g(AdmReason)_"^"_$g(bodypartcode)_"^"_$g(AppBillNo)_"^"_$g(BKStudyNo)_"^"_AccUsePrice_"^"_GetResultFlag
   	 ..s ^DHCRisExportExcelData($g(UserID))=ind
   	 ..s ^CacheTemp(repid,ind)=Data
   	 ..Set ind=ind+1
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
	q ^DHCRisTmpPrintData
}

ClassMethod GetData(i)
{
	q ^DHCRisTmpPrintData(i)
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

ClassMethod QueryByRegDate(Intype, InLocDr, InStdDate, Inenddate, InStatusCode, InReportDoc, InVerifyDoc, InResourceID, InRoomDR, InRegEQ, InRequireAppoint, InIsBedOrd, InRegNo, InStudyNo, InName, InPatientNo, InAppLocDR, InEQGroupDR, InWardDR, InNO, IsFilmSet, IsNotLoc, BookedType, IsUItem, IsCostRecords, UserID)
{
	for date=InStdDate:1:Inenddate
    {
	  s Regrowid=0 f  s Regrowid=$o(^DHCPACRegInfoi("RegDate",date,Regrowid)) q:Regrowid=""  d    
      .s bOut="N"  ;是否已经输出
      .s GetPatientStatusCode="I"
      .s ExecuteLocId=$p(^DHCPACRegInfo(Regrowid),"^",13)
      .q:InLocDr'=ExecuteLocId  
      .s Detail="明细",RejectAppReason="拒绝原因",ToDayOeItem="",CostRecords="",RegDoc="",Urgentflag=""
      .s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfobyrowid(Regrowid)
      .s GetStudyNo=$p(RegInfo,"^",1)
      .s GetstrRegDate=$p(RegInfo,"^",2)
      .s GetstrRegTime=$p(RegInfo,"^",3)
      .s GetIndex=$p(RegInfo,"^",4)
      .s GetEQDesc=$p(RegInfo,"^",5)
      .s GetMainDoc=$p(RegInfo,"^",6)
      .s GetAssDoc=$p(RegInfo,"^",7)
      .s Oeorditemdr=$p(RegInfo,"^",8)
      .;w !,"R="_Oeorditemdr
      .s paadmdr=$p(RegInfo,"^",9)
      .s GetRoomDesc=$p(RegInfo,"^",10)
      .s GetRoomDr=$p(RegInfo,"^",12)
      .s GetEQDr=$p(RegInfo,"^",11)
      .s GetEQGroupDesc=$p(RegInfo,"^",13)
      .s GetEQGroupDR=$p(RegInfo,"^",14)
      .s GetOldNo=$p(RegInfo,"^",15)
      .s BodyDesc=$p(RegInfo,"^",16)
      .s GetRegDate=$p(RegInfo,"^",17)
      .s Urgentflag=$p(RegInfo,"^",18)
      .s RegDoc=$p(RegInfo,"^",19)
      .s FileSent=##class(web.DHCRisWorkBenchDoEx).GetFilmSendDesc(GetStudyNo)
      .s ReportSend=##class(web.DHCRisWorkBenchDoEx).GetReportSend(GetStudyNo)
      .s strXDate="",AppDate="",AppBillView=""
      .s AppRowid=$o(^DHCRBAppOrdi(0,Oeorditemdr,0)) 
      .i AppRowid'="" d
      ..s XDate=$p($g(^DHCRBApp("Bill",AppRowid)),"^",10)
      ..s strXDate=$zd(XDate,3)
      ..s AppDate=$p($g(^DHCRBApp("Bill",AppRowid)),"^",1)
      ..i AppDate'="" s AppDate=$zd(AppDate,3)
      ..s Urgentflag=$p($g(^DHCRBApp("Bill",AppRowid)),"^",26)
      ..s AppBillView="申请单浏览"
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
      .q:(InAppLocDR'="")&(GetReqLocDR'=InAppLocDR)
      .s GetWardDR=$p(PatInfo,"^",14)
      .s Getroomdesc=$p(PatInfo,"^",15)
      .s GetSexDr=$p(PatInfo,"^",13)
      .s PapatmasDR=$p(PatInfo,"^",24)
      .s Weight=$p(PatInfo,"^",21)
	  .s TelNo=$p(PatInfo,"^",19)
	  .s PinYin=$p(PatInfo,"^",38)
	  .s Epissubtype=$p($g(PatInfo),"^",41)
	  .s AdmReason=$p($g(PatInfo),"^",43)
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
      .s GetSGroupDR=$p($g(ordInfo),"^",36)
      .s GetsubCatDesc=$p(ordInfo,"^",7)
      .s GetCatDesc=$p(ordInfo,"^",8)
      .s Getifbed=$p(ordInfo,"^",9)
      .s Getprice=$p(ordInfo,"^",10)
      .s GetNum=$p(ordInfo,"^",11)
      .s GetTotalPrice=$p(ordInfo,"^",12)
      .s Getbilled=$p(ordInfo,"^",13)
      .s GetItemStatusCode=$p(ordInfo,"^",14)
      .q:(GetItemStatusCode="U")&(IsUItem'="Y") ;查询作废医嘱
      .q:(GetItemStatusCode="U")!(GetItemStatusCode="D")!(GetItemStatusCode="C")
      .s GetordDate=$p(ordInfo,"^",15)
      .s GetordTime=$p(ordInfo,"^",16)
      .s GetItemStatusCode=$p(ordInfo,"^",17)   			;医嘱状态
      .s GetServerMaterial=$p(ordInfo,"^",18)   			;申请项目标记
      .s AutoInputFee=$p(ordInfo,"^",25) ;"需要另划价标志"
      .i AutoInputFee="Y" s ToDayOeItem="查询"
      .s EndInputFee=$p(ordInfo,"^",26)  ;"已另划价标识"
      .s BilledDesc=$p(ordInfo,"^",27)
      .s BodyDesc=$p(ordInfo,"^",29)
      .s CheckEntryFlag=$p(ordInfo,"^",30)
      .s GetExterFalg=$p(ordInfo,"^",32)  ;外部预约标识
      .q:(IsCostRecords'="Y")&(CheckEntryFlag="Y") 
      .i CheckEntryFlag="Y" s CostRecords="已补录"
      .;s ResultFlag=$p(ordInfo,"^",20)    ;医嘱的结果状态--------------安贞医院用以前MEDTRAK 的结果处理，处理的的报告，在技师工作站中不在显示
      .;q:ResultFlag="V"
      .q:(InRequireAppoint="N")&(GetSGroupDesc'="无需预约")&('(GetstrOrderName["床旁"))
      .q:(InRequireAppoint="Y")&((GetSGroupDesc="无需预约")!(GetstrOrderName["床旁"))
      .q:(InIsBedOrd="Y")&('(GetstrOrderName["床旁"))  ;检索床旁医嘱，不是床旁医嘱
      .i (GetstrOrderName["床旁") S Getifbed="Y"
      .s AppointUser="",AppointUserDR=""
      .i BookedType="1"  d   ; 新开发的预约系统
	  ..s BookedRowid=$o(^DHCRBCResSchduleDetaili(0,Oeorditemdr,0))
      ..i BookedRowid'="" d
      ...s SchudleRowid=$p(^DHCRBCResSchduleDetail("Detail",BookedRowid),"^",2)
      ...s Flags=""
      ...s Flags=$p(^DHCRBCResSchduleDetail("Detail",BookedRowid),"^",7)
      ...i (SchudleRowid'="")&(Flags'="Cancel") d
      ....s ResourceId=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",1)
      ....s AppointUserDR=$p($g(^DHCRBCResSchduleDetail("Detail",BookedRowid)),"^",15)
	  ....i AppointUserDR'="" s AppointUser=$p($g(^SSU("SSUSR",AppointUserDR)),"^",2)
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
      ....;wf 按时间预约修改查询出来的预约开始时间
	  ....i $p($g(^DHCRBCResSchduleDetail("Detail",BookedRowid)),"^",18)'="" s RppTime=$p($g(^DHCRBCResSchduleDetail("Detail",BookedRowid)),"^",18)
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
      .s ExterBK="N"
      .i GetExterFalg'="" d
      ..s ExterBK="Y"
      ..s GetPatientStatusCode="B"
      ..s strRppDate=$p($g(^DHCRISBOOKEDINFO(Oeorditemdr)),"^",2)
      ..s strRppTime=$p($g(^DHCRISBOOKEDINFO(Oeorditemdr)),"^",3)
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
      .;s Rptrowid=0  f  s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",GetStudyNo,Rptrowid)) q:Rptrowid=""  d
      .s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",GetStudyNo,""),-1)
      .i Rptrowid'="" d
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
      
      //Do OutRowbyType
   }
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK 
     
OutRow
   	s RecLoc=""
    i ExecuteLocId'="" d
    .s RecLoc=$p(^CTLOC(ExecuteLocId),"^",2)
 
   	s Required=""
   	if (GetSGroupDesc="无需预约")!(GetstrOrderName["床旁") s Required="N"
   	set Data=$lb(GetRegNo,GetName,GetSexDesc,GetstrAge,GetstrDOB,GetIDCDesc,
   	 GetStudyNo,GetstrOrderName,Getrequestdoc,GetstrAccessionNum,GetstrDate,GetstrTime,strRppDate,strRppTime,GetBookedDuration,GetstrRegDate,GetstrRegTime,GetRptDocName,GetVerifyDocName,GetPatientStatus,paadmdr,Oeorditemdr, 	 
   	 GetLocName,GetTotalPrice,GetPatientStatusCode,Getbilled,Gettypedesc,GetNum,Getprice,GetIndex,GetEQDesc,GetResDesc,Getifbed,GetReportStatus,GetMainDoc,GetAssDoc,GetRoomDesc,GetEQGroupDesc,GetWardName,GetOldNo,Required,strXDate,GetItemStatusCode,PapatmasDR,BodyDesc,Weight,TelNo,GetIPNo,FileSent,GetBedNo,ReportSend,HaveImage,ExecuteLocId,RecLoc,AutoInputFee,EndInputFee,Detail,RejectAppReason,BilledDesc,PinYin,ToDayOeItem,CostRecords,AppDate,Urgentflag,RegDoc,Epissubtype,GetSGroupDesc,GetSGroupDR,$g(AppointUser),$g(AppBillView),$g(AdmReason),$g(ExterBK))
   	;s ret=..SetQueryData(Getpatienttype,UserID,Data)
   	Set ^CacheTemp(repid,ind)=Data
   	s ^DHCRisTmpPrintData(ind)=GetRegNo_"^"_GetName_"^"_GetSexDesc_"^"_GetstrAge_"^"_GetWardName_"^"_GetBedNo_"^"_GetStudyNo_"^"_$g(ReportSend)
   	s ^DHCRisTmpPrintData=ind
   	
    s ^DHCRisExportExcelData($g(UserID),ind)=GetRegNo_"^"_GetName_"^"_GetSexDesc_"^"_GetstrAge_"^"_GetstrDOB_"^"_$g(GetIDCDesc)_"^"_GetStudyNo_"^"_GetstrOrderName_"^"_Getrequestdoc_"^"_GetstrAccessionNum_"^"_GetstrDate_"^"_GetstrTime_"^"_strRppDate_"^"_strRppTime_"^"_$g(GetBookedDuration)_"^"_GetstrRegDate_"^"_GetstrRegTime_"^"_$g(GetRptDocName)_"^"_$g(GetVerifyDocName)_"^"_GetPatientStatus_"^"_paadmdr_"^"_Oeorditemdr_"^"_GetLocName_"^"_GetTotalPrice_"^"_GetPatientStatusCode_"^"_Getbilled_"^"_Gettypedesc_"^"_GetNum_"^"_Getprice_"^"_GetIndex_"^"_GetEQDesc_"^"_GetResDesc_"^"_Getifbed_"^"_GetReportStatus_"^"_GetMainDoc_"^"_GetAssDoc_"^"_GetRoomDesc_"^"_GetEQGroupDesc_"^"_GetWardName_"^"_$g(GetOldNo)_"^"_$g(Required)_"^"_strXDate_"^"_GetItemStatusCode_"^"_PapatmasDR_"^"_BodyDesc_"^"_Weight_"^"_TelNo_"^"_GetIPNo_"^"_$g(FileSent)_"^"_GetBedNo_"^"_$g(ReportSend)_"^"_$g(HaveImage)_"^"_ExecuteLocId_"^"_RecLoc_"^"_$g(AutoInputFee)_"^"_$g(EndInputFee)_"^"_Detail_"^"_$g(RejectAppReason)_"^"_BilledDesc_"^"_PinYin_"^"_$g(ToDayOeItem)_"^"_CostRecords_"^"_$g(AppDate)_"^"_$g(Urgentflag)_"^"_$g(RegDoc)_"^"_$g(Epissubtype)_"^"_$g(GetSGroupDesc)_"^"_$g(GetSGroupDR)_"^"_$g(AppointUser)_"^"_$g(AdmReason)
    s ^DHCRisExportExcelDate($g(UserID))=ind
	Set ind=ind+1
	quit
	
 	
OutRowbyType
   s ind=1
   s ArrayType=..GetQueryOrder()
   s numl=0
   s numl=$L(ArrayType,"@")
   f i=1:1:numl  d
   .s type=$p(ArrayType,"@",i)
   .for j=1:1:$g(^tempQueryNum(UserID,type)) d
   ..Set ^CacheTemp(repid,ind)=$g(^DHCRISTEMPQUERYDATA(UserID,type,j))
   ..Set ind=ind+1
   quit
}

// 判断医嘱的接收科室是否在查询科室所关联的科室中

ClassMethod IsQueryLoc(LogInLocId As %String, OrditemRecLocId As %String) As %Integer
{
	 s bFind=0
	 s LinkSub=0 f  s LinkSub=$o(^CTLOC(LogInLocId,"LINK",LinkSub)) q:LinkSub=""  d    
     .s LinkLocDr=$p(^CTLOC(LogInLocId,"LINK",LinkSub),"^",1)
     .i LinkLocDr=OrditemRecLocId  s bFind=1
  
     i bFind=0 d
     .i OrditemRecLocId=LogInLocId  s bFind=1 
    
     q bFind
}

// 根据医嘱ID查找表另划价医嘱的组号，用于确定哪些医嘱需要统一划价处理

// sunyi 2011-12-12

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
	 
	 s hasLoc="N"
	 s LinkSub=$o(^CTLOC(LocID,"LINK",0)) 
	 if (LinkSub'="") 
	 {
		 s LinkSub=0 f  s LinkSub=$o(^CTLOC(LocID,"LINK",LinkSub)) q:LinkSub=""  d    
         .s InLocDr=$p(^CTLOC(LocID,"LINK",LinkSub),"^",1) 
         .i InLocDr=LocID  s hasLoc="Y"
         .i (Array="") s Array=InLocDr
         .else  d
         ..s Array=Array_"@"_InLocDr
	 }
	 if (Array="")
	 {
		 s Array=LocID
	 }
	 else
	 {
		 if (hasLoc="N")
		 {
			 s Array=Array_"@"_LocID
		 }
	 }
	 //else
	 //{   
	 //	 s Array=LocID
	 //} 
	q Array
}

/// 函数 AllowAutoQuery 
/// 功能 是否允许自动查询
/// 动作 Action : "" 或者是Auto 是 自动查询, 否这是其他条件的查询 
/// w ##class(web.DHCRisWorkBenchDoEx).AllowAutoQuery("")
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
	
	s (ResultFlag,Complete,itmmastdr,IPRowid,AppointMethodId,AppointMethod,RERowid,ResSchduleID)=""
	s IPRowid=""
	
	s itmmastdr=$p($g(^OEORD(oeordrowid,"I",oeorisub,1)),"^",2)
	i itmmastdr'=""  s IPRowid=$o(^DHCRBCItemBookProperTypei(itmmastdr,0)) 
	i IPRowid'="" s AppointMethodId=$p($g(^DHCRBCItemBookProperty(IPRowid)),"^",2)
	i AppointMethodId'="" s AppointMethod=$p(^DHCRBCAppointMethod(AppointMethodId) ,"^",2)
   
	
	s ResultFlag=$p($g(^OEORD(oeordrowid,"I",oeorisub,1)),"^",5)
    i ResultFlag'="" s RERowid=$o(^OEC("RESST",0,"Code",$$ALPHAUP^SSUTIL4(ResultFlag),""))
    i RERowid'="" s Complete=$p($g(^OEC("RESST",RERowid)),"^",2)
    
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
/// w ##class(web.DHCRisWorkBenchDoEx).GetRegNofromCardNo("000805581349")
ClassMethod GetRegNofromCardNo(CardNo As %String) As %String
{
    s CardRowid=0,RegNo=""
    s CardRowid=$o(^DHCCARDi("CF",0,"CardNo",CardNo,""),-1) 
    i CardRowid'="" d
    .s RegNo=$p($g(^DHCCARD("CF",CardRowid)),"^",6)
    q RegNo
}

ClassMethod SetQueryData(type As %String, UserID As %String, Data As %String) As %String
{
	  i type="I" d
	  .i IndexI=0 s IndexI=1
	  .e  d
	  ..s IndexI=IndexI+1
      .s ^DHCRISTEMPQUERYDATA(UserID,"I",IndexI)=Data
      .s ^tempQueryNum(UserID,"I")=IndexI
      
      i type="E" d
	  .i IndexE=0 s IndexE=1
	  .e  d
	  ..s IndexE=IndexE+1
      .s ^DHCRISTEMPQUERYDATA(UserID,"E",IndexE)=Data
      .s ^tempQueryNum(UserID,"E")=IndexE
      
      i type="O" d
	  .i IndexO=0 s IndexO=1
	  .e  d
	  ..s IndexO=IndexO+1
      .s ^DHCRISTEMPQUERYDATA(UserID,"O",IndexO)=Data
      .s ^tempQueryNum(UserID,"O")=IndexO
      
      i type="H" d
	  .i IndexH=0 s IndexH=1
	  .e  d
	  ..s IndexH=IndexH+1
      .s ^DHCRISTEMPQUERYDATA(UserID,"H",IndexH)=Data
      .s ^tempQueryNum(UserID,"H")=IndexH
      
      i type="N" d
	  .i IndexN=0 s IndexN=1
	  .e  d
	  ..s IndexN=IndexN+1
      .s ^DHCRISTEMPQUERYDATA(UserID,"N",IndexN)=Data
      .s ^tempQueryNum(UserID,"N")=IndexN
      
     q 0
}

// I-住院 E-急诊 O-门诊  H-体检 N-其他

/// 设置预约工作列表的显示顺序按病人类型显示
ClassMethod GetQueryOrder()
{
	s ArrayType="E@I@O@H@N"
	q ArrayType
}

/// 修改按检查号查询,通过检查号可以查询出“预约”..记录
/// 同时兼容以前版本的检查号查询 通过配置 ^DHCRISSTYUDYQUERYTYPE("TYPE")
/// 参数:1为新的查询 
/// sunyi 2013-08-06
ClassMethod QueryByNewStudyNo(ExmLocID, RoomDR, DeviceDR, PatTypeDR, InRegNo, StudyID, InName, InSexDR, Age, InStudyStatusCode, InRptStatusCode, StdDate, EndDate, OrderItemDR, StudyWay, InReqLocDR, RptDesc, RptDiagnose, RptDocDR, VerifyDocDR, IsYX, IsDXBL, IsKYBL, zyh, WardDR, InEQGroupDR, InOldNo, InIsFindDate, BookedType, IsUItem, IsCostRecords, UserID, InAppLocDR)
{
	
	 s bOut="N"  ;是否已经输出
	 s Detail="明细",RejectAppReason="",ToDayOeItem="",CostRecords="",Inpaadmdr=""
	
	 //if $g(^DHCRISSTYUDYQUERYTYPE("TYPE"))="1" d
	 s DRowid=""
	 s ExterBK="N"
	 s DRowid=$o(^DHCRBCResSchduleDetaili("StudyNo",StudyID,DRowid))
	 i DRowid'="" d
	 .s ExterBK="Y"
	 .s DetailRowid=0  f  s DetailRowid=$o(^DHCRBCResSchduleDetaili("StudyNo",StudyID,DetailRowid)) q:DetailRowid=""  d
	 ..s Oeorditemdr=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",1)
	 ..q:(Oeorditemdr="")
	 ..s Flag=""
	 ..s Flag=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",7)
	 ..q:(Flag="Cancel")
	 ..s BKStudyNo="",AppointUserDR="",AppointUserDR=""
	 ..s AppointUserDR=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",15)
	 ..i AppointUserDR'="" s AppointUser=$p($g(^SSU("SSUSR",AppointUserDR)),"^",2)
	 ..;s paadmdr=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",3)
	 ..s paadmdr=$p($g(^OEORD($p($g(Oeorditemdr),"||",1))),"^",1)
	 ..s BKStudyNo=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",6)
	 ..s SchRowid=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",2)
	 ..s AppRowid=$o(^DHCRBAppOrdi(0,Oeorditemdr,0)) 
	 ..s AppDate="",Urgentflag="",AppBillView=""
	 ..i AppRowid'="" d
	 ...s XDate=$p($g(^DHCRBApp("Bill",AppRowid)),"^",10)
	 ...s strXDate=$zd(XDate,3)
	 ...s AppDate=$p($g(^DHCRBApp("Bill",AppRowid)),"^",1)
     ...i AppDate'="" s AppDate=$zd(AppDate,3)
     ...s Urgentflag=$p($g(^DHCRBApp("Bill",AppRowid)),"^",26)
     ...s AppBillView="申请单浏览"
	 ..q:(Inpaadmdr'="")&(paadmdr'=Inpaadmdr)
	 ..s PapatmasDR=$p(^PAADM(paadmdr),"^",1) 
	 ..s ResourceId=$p($g(^DHCRBCResourceSchdule(SchRowid)),"^",1) 
	 ..s RppDate=$p($g(^DHCRBCResourceSchdule(SchRowid)),"^",2)
	 ..i RppDate'="" s strRppDate=$zd(RppDate,3)
	 ..s RppTime=$p($g(^DHCRBCResourceSchdule(SchRowid)),"^",5)
	 ..;wf 按时间预约修改查询出来的预约开始时间
     ..i $p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",18)'="" s RppTime=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",18)
	 ..i RppTime'="" s strRppTime=$zt(RppTime,1)
	 ..s GetResDesc="",CTCPDR="",EQDR=""
 	 ..i ResourceId'="" s CTCPDR=$p($g(^RB("RES",ResourceId)),"^",2)
     ..s CTCPDR=$p(CTCPDR,$c(0))
     ..i CTCPDR'="" s GetResDesc=$p($g(^CTPCP(CTCPDR,1)),"^",2)
     ..else  d
     ...s EQDR=$p($g(^RB("RES",ResourceId)),"^",3)
     ...s GetResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
	 ..;get patient diagnose 
	 ..s GetIDCDesc=##class(web.DHCRisCommFunctionEx).GetDiagnose(paadmdr)
	 ..s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
	 ..s GetRegNo=$p(PatInfo,"^",1)
	 ..s GetName=$p(PatInfo,"^",2)
	 ..s GetstrDOB=$p(PatInfo,"^",3)
	 ..s GetstrAge=$p(PatInfo,"^",4)
	 ..s GetSexDesc=$p(PatInfo,"^",5)
	 ..s Getpatienttype=$p(PatInfo,"^",6)
	 ..s Gettypedesc=$p(PatInfo,"^",7)
	 ..s GetLocName=$p(PatInfo,"^",8)
	 ..s GetIPNo=$p(PatInfo,"^",9)
	 ..s GetWardName=$p(PatInfo,"^",10)
	 ..s GetBedNo=$p(PatInfo,"^",11)
	 ..s GetLocdr=$p(PatInfo,"^",12)
	 ..s GetWardDr=$p(PatInfo,"^",14)
	 ..s PapatmasDR=$p(PatInfo,"^",24)
	 ..s Weight=$p(PatInfo,"^",21)
	 ..s TelNo=$p(PatInfo,"^",19)
	 ..s PinYin=$p(PatInfo,"^",38)
	 ..s Epissubtype=$p($g(PatInfo),"^",41)
	 ..s AdmReason=$p($g(PatInfo),"^",43)
	 ..q:(InWardDR'="")&(GetWardDr'=InWardDR)
	 ..q:(InRegNo'="")&(GetRegNo'=InRegNo)
	 ..q:(InName'="")&(GetName'[InName)
	 ..q:(InPatientNo'="")&(InPatientNo'=GetIPNo)
	 ..q:(InAppLocDR'="")&(GetLocdr'=InAppLocDR)
	 ..q:(Intype'="")&(Intype'=Getpatienttype)
	 ..s ordrowid=$p(Oeorditemdr,"||",1)
	 ..s orditemchildsub=$p(Oeorditemdr,"||",2)
	 ..s CheckEntryFlag="",CostRecords=""
	 ..s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(ordrowid,orditemchildsub)
	 ..s GetstrOrderName=$p(ordInfo,"^",1)
	 ..s GetstrDate=$p(ordInfo,"^",2)
	 ..s GetstrTime=$p(ordInfo,"^",3)
	 ..s Getrequestdoc=$p(ordInfo,"^",4)
	 ..s GetstrAccessionNum=$p(ordInfo,"^",5)
	 ..s GetSGroupDesc=$p(ordInfo,"^",6)
	 ..s GetSGroupDR=$p($g(ordInfo),"^",36)
	 ..s GetsubCatDesc=$p(ordInfo,"^",7)
	 ..s GetCatDesc=$p(ordInfo,"^",8)
	 ..s Getifbed=$p(ordInfo,"^",9)
	 ..s Getprice=$p(ordInfo,"^",10)
	 ..s GetNum=$p(ordInfo,"^",11)
	 ..s GetTotalPrice=$p(ordInfo,"^",12)
	 ..s Getbilled=$p(ordInfo,"^",13)
	 ..s GetItemStatusCode=$p(ordInfo,"^",14)
	 ..q:(GetItemStatusCode="U")&(IsUItem'="Y") ;查询作废医嘱
	 ..q:(GetItemStatusCode="U")!(GetItemStatusCode="D")!(GetItemStatusCode="C")
	 ..s GetordDate=$p(ordInfo,"^",15)
	 ..s GetordTime=$p(ordInfo,"^",16)
	 ..s GetItemStatusCode=$p(ordInfo,"^",17)
	 ..s RecLocId=$p(ordInfo,"^",19) 
	 ..s AutoInputFee=$p(ordInfo,"^",25) ;"需要另划价标志"
	 ..i AutoInputFee="Y" s ToDayOeItem="查询"
	 ..s EndInputFee=$p(ordInfo,"^",26)  ;"已另划价标识"
	 ..s BilledDesc=$p(ordInfo,"^",27)
	 ..s BodyDesc=$p(ordInfo,"^",29)
	 ..s CheckEntryFlag=$p(ordInfo,"^",30)
	 ..q:(IsCostRecords'="Y")&(CheckEntryFlag="Y") 
     ..i CheckEntryFlag="Y" s CostRecords="已补录"
	 ..;s ResultFlag=$p(ordInfo,"^",20)    ;医嘱的结果状态--------------安贞医院用以前MEDTRAK 的结果处理，处理的的报告，在技师工作站中不在显示
	 ..;q:ResultFlag="V"
	 ..q:(InIsBedOrd="Y")&(Getifbed'="Y")  ;检索床旁医嘱，不是床旁医嘱
	 ..s GetPatientStatusCode="B"
	 ..s GetReportStatusCode="N"  ;未写报告
	 ..s GetstrRegDate="",GetstrRegTime="",GetRptDocName="",GetVerifyDocName="",GetIndex="",GetEQDesc=""
	 ..s GetEQDr="",GetMainDoc="",GetAssDoc="",GetRoomDesc="",GetRoomDr="",GetEQGroupDR=""
	 ..s bOut="N",FileSent="",HaveImage="" ,BodyDesc="",RegDoc=""
	 ..s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfo(Oeorditemdr)
	 ..s GetStudyNo=$p(RegInfo,"^",1)
	 ..i GetStudyNo'="" d
	 ...s GetPatientStatusCode="I"
	 ..e  d
	 ...s GetPatientStatusCode="B"  s GetStudyNo="" // BKStudyNo
	 ..i GetStudyNo'="" d
	 ...s GetstrRegDate=$p(RegInfo,"^",2)
	 ...s GetstrRegTime=$p(RegInfo,"^",3)
	 ...s GetIndex=$p(RegInfo,"^",4)
	 ...s GetEQDesc=$p(RegInfo,"^",5)
	 ...s GetMainDoc=$p(RegInfo,"^",6)
	 ...s GetAssDoc=$p(RegInfo,"^",7)
	 ...s GetRoomDesc=$p(RegInfo,"^",8)
	 ...s GetRoomDr=$p(RegInfo,"^",9)
	 ...s GetEQDr=$p(RegInfo,"^",10)
	 ...s GetEQGroupDesc=$p(RegInfo,"^",11)
	 ...s GetEQGroupDR=$p(RegInfo,"^",12)
	 ...s NO=$p(RegInfo,"^",13)
	 ...s BodyDesc=$p(RegInfo,"^",17)
	 ...s Urgentflag=$p(RegInfo,"^",21)
	 ...s RegDoc=$p(RegInfo,"^",24)
	 ...s FileSent=##class(web.DHCRisWorkBenchDoEx).GetFilmSendDesc(GetStudyNo)
	 ...s ReportSend=##class(web.DHCRisWorkBenchDoEx).GetReportSend(GetStudyNo)
	 ...s GetImgcount=0
	 ...s Imrowid=0 f  s Imrowid=$o(^DHCRBStudyi("StudyNo-Images",GetStudyNo,Imrowid)) q:Imrowid=""  d
	 ....s GetPatientStatusCode="E"    ;正在检查
	 ....s ExtName=$p($g(^DHCRBStudy(0,"StudyImages",Imrowid)),"^",2)
	 ....i ((ExtName="avi")!(ExtName="dcm")!(ExtName="normal")!(ExtName="dsa"))  d
	 .....s GetImgcount=GetImgcount+1
	 .....s ReportStatusCode="I"             ;图象已经采集
	 .....s HaveImage="是"
	 ...s sReportStuatCode="VS"
	 ...s Rptrowid=0  f  s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",GetStudyNo,Rptrowid)) q:Rptrowid=""  d
	 ....s GetRptID=$p(^DHCRBStudy("Report",Rptrowid),"^",2)
	 ....s GetRptVersion=$p(^DHCRBStudy("Report",Rptrowid),"^",3)
	 ....s GetRptStatusDR=$p(^DHCRBStudy("Report",Rptrowid),"^",4)
	 ....i GetRptStatusDR'="" d
	 .....s GetReportStatusCode=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",1)
	 .....i sReportStuatCode[GetReportStatusCode d
	 ......s GetPatientStatusCode="O"
	 .....e  d
	 ......s GetPatientStatusCode="E"
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
	 ....s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
	 ....;s bOut="Y"
	 ....;Do OutRowNewStudyNo
	 ..;s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
	 ..;s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
	 ..s bOut="Y"
	 ..Do OutRowNewStudyNo
	else  d
    .s Regrowid=0 f  s Regrowid=$o(^DHCPACRegInfoi("StudyNo",StudyID,Regrowid)) q:Regrowid=""  d
    ..s GetPatientStatusCode="I"
    ..s bOut="N"  ;是否已经输出
    ..s Detail="明细",RejectAppReason="",ToDayOeItem="",CostRecords="",Urgentflag=""
    ..s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfobyrowid(Regrowid)
    ..s RecLocId=$p(^DHCPACRegInfo(Regrowid),"^",13)
    ..s GetStudyNo=$p(RegInfo,"^",1)
    ..s GetstrRegDate=$p(RegInfo,"^",2)
    ..s GetstrRegTime=$p(RegInfo,"^",3)
    ..s GetIndex=$p(RegInfo,"^",4)
    ..s GetEQDesc=$p(RegInfo,"^",5) ; GetEQDesc
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
    ..s BodyDesc=$p(RegInfo,"^",16)
    ..s GetRegDate=$p(RegInfo,"^",17)
    ..s Urgentflag=$p(RegInfo,"^",18)
    ..s RegDoc=$p(RegInfo,"^",19)
    ..q:(InIsFindDate="true")&(GetRegDate<StdDate)!(GetRegDate>EndDate)
    ..s FileSent=##class(web.DHCRisWorkBenchDoEx).GetFilmSendDesc(GetStudyNo)
    ..s ReportSend=##class(web.DHCRisWorkBenchDoEx).GetReportSend(GetStudyNo)
    ..s strXDate="",AppDate="",AppBillView=""
    ..s AppRowid=$o(^DHCRBAppOrdi(0,Oeorditemdr,0)) 
    ..i AppRowid'="" d
    ...s XDate=$p($g(^DHCRBApp("Bill",AppRowid)),"^",10)
    ...s strXDate=$zd(XDate,3)
    ...s AppDate=$p($g(^DHCRBApp("Bill",AppRowid)),"^",1)
    ...i AppDate'="" s AppDate=$zd(AppDate,3)
    ...s Urgentflag=$p($g(^DHCRBApp("Bill",AppRowid)),"^",26)
    ...s AppBillView="申请单浏览"
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
    ..q:(InAppLocDR'="")&(GetReqLocDR'=InAppLocDR)
    ..s GetWardDR=$p(PatInfo,"^",14)
    ..s Getroomdesc=$p(PatInfo,"^",15)
    ..s GetSexDr=$p(PatInfo,"^",13)
    ..s PapatmasDR=$p(PatInfo,"^",24)
    ..s Weight=$p(PatInfo,"^",21)
	..s TelNo=$p(PatInfo,"^",19)
	..s PinYin=$p(PatInfo,"^",38)
	..s Epissubtype=$p($g(PatInfo),"^",41)
	..s AdmReason=$p($g(PatInfo),"^",43)
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
    ..s GetSGroupDR=$p($g(ordInfo),"^",36)
    ..s GetsubCatDesc=$p(ordInfo,"^",7)
    ..s GetCatDesc=$p(ordInfo,"^",8)
    ..s Getifbed=$p(ordInfo,"^",9)
    ..s Getprice=$p(ordInfo,"^",10)
    ..s GetNum=$p(ordInfo,"^",11)
    ..s GetTotalPrice=$p(ordInfo,"^",12)
    ..s Getbilled=$p(ordInfo,"^",13)
    ..s GetItemStatusCode=$p(ordInfo,"^",14)
    ..q:(GetItemStatusCode="U")&(IsUItem'="Y") ;查询作废医嘱
    ..s GetordDate=$p(ordInfo,"^",15)
    ..s GetordTime=$p(ordInfo,"^",16)
    ..s GetItemStatusCode=$p(ordInfo,"^",17)   			;医嘱状态
    ..s GetServerMaterial=$p(ordInfo,"^",18)   			;申请项目标记
    ..s ResultFlag=$p(ordInfo,"^",20)    ;医嘱的结果状态--------------安贞医院用以前MEDTRAK 的结果处理，处理的的报告，在技师工作站中不在显示
    ..s AutoInputFee=$p(ordInfo,"^",25) ;"需要另划价标志"
    ..i AutoInputFee="Y" s ToDayOeItem="查询"
    ..s EndInputFee=$p(ordInfo,"^",26)  ;"已另划价标识"
    ..s BilledDesc=$p(ordInfo,"^",27)
    ..s BodyDesc=$p(ordInfo,"^",29)
    ..s CheckEntryFlag=$p(ordInfo,"^",30)
    ..s GetExterFalg=$p(ordInfo,"^",32)  ;外部预约标识
    ..q:(IsCostRecords'="Y")&(CheckEntryFlag="Y") 
    ..i CheckEntryFlag="Y" s CostRecords="已补录"
    ..q:(InRequireAppoint="N")&(GetSGroupDesc'="无需预约")&('(GetstrOrderName["床旁"))
    ..q:(InRequireAppoint="Y")&((GetSGroupDesc="无需预约")!(GetstrOrderName["床旁"))
    ..q:(InIsBedOrd="Y")&('(GetstrOrderName["床旁"))  ;检索床旁医嘱，不是床旁医嘱
    ..i (GetstrOrderName["床旁") S Getifbed="Y"
    ..;q:ResultFlag="V"
    ..i (BookedType="1") d                  ; 新开发的预约系统
    ...s BookedRowid=$o(^DHCRBCResSchduleDetaili(0,Oeorditemdr,0))
    ...i BookedRowid'="" d
    ....s Flags="",AppointUserDR="",AppointUser=""
    ....s Flags=$p(^DHCRBCResSchduleDetail("Detail",BookedRowid),"^",7)
    ....q:(Flags="Cancel")
    ....s AppointUserDR=$p($g(^DHCRBCResSchduleDetail("Detail",BookedRowid)),"^",15)
	....i AppointUserDR'="" s AppointUser=$p($g(^SSU("SSUSR",AppointUserDR)),"^",2)
    ....s SchudleRowid=$p(^DHCRBCResSchduleDetail("Detail",BookedRowid),"^",2)
    ....i (SchudleRowid'="") d
    .....s ResourceId=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",1)
    .....s ResDesc=""
 	.....s CTCPDR=$p($g(^RB("RES",ResourceId)),"^",2)
    .....s CTCPDR=$p(CTCPDR,$c(0))
    .....i CTCPDR'="" d
    ......s GetResDesc=$p($g(^CTPCP(CTCPDR,1)),"^",2)
    .....else  d
    ......s EQDR=$p($g(^RB("RES",ResourceId)),"^",3)
    ......s GetResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
    .....s RppDate=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",2)
    .....s strRppDate=$zd(RppDate,3)
    .....s RppTime=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",5)
    .....;wf 按时间预约修改查询出来的预约开始时间
	.....i $p($g(^DHCRBCResSchduleDetail("Detail",BookedRowid)),"^",18)'="" s RppTime=$p($g(^DHCRBCResSchduleDetail("Detail",BookedRowid)),"^",18)
    .....s strRppTime=$zt(RppTime,1)
    .....s GetBookedDuration=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",3)
    ..else  d
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
    .....s GetBookedDuration=$p(^RBAS(ResRowid,SchildSub,"APPT",appointchildsub),"^",23) 
    ..i GetExterFalg'="" d
    ...s ExterBK="Y"
    ...s GetPatientStatusCode="B"
    ...s strRppDate=$p($g(^DHCRISBOOKEDINFO(Oeorditemdr)),"^",2)
    ...s strRppTime=$p($g(^DHCRISBOOKEDINFO(Oeorditemdr)),"^",3)
    ..s GetReportStatusCode="N"     ;未写报告
    ..s GetImgcount=0
    ..s GetRptID=""
    ..s GetRptDocDR="",GetRptDocName="",GetRptDate="",GetRptTime="",GetVerifyDocDR=""
    ..s GetVerifyDocName="",GetVerifyDate="",GetVerifyTime="",GetStudyDescDR=""
    ..s GetStudyWay="",GetBodyPartDR="",GetIsKYBL="",GetIsTSBL="",GetResultDesc="",GetExamDesc="",HaveImage=""
    ..;s GetIndex="",GetEQDr="",GetEQDesc="",GetRoomDesc="",GetEQGroupDR=""
    ..s GetRptIsYX="",GetBookedDuration=""
    ..s Imrowid=0 f  s Imrowid=$o(^DHCRBStudyi("StudyNo-Images",StudyID,Imrowid)) q:Imrowid=""  d
    ...s GetPatientStatusCode="E"    ;正在检查
    ...s ExtName=$p($g(^DHCRBStudy(0,"StudyImages",Imrowid)),"^",2)
    ...i ((ExtName="avi")!(ExtName="dcm")!(ExtName="normal")!(ExtName="dsa"))  d
    ....s GetImgcount=GetImgcount+1
    ....s GetReportStatusCode="I"             ;图象已经采集
    ....s HaveImage="是"
    ..s ReportStuatCode="VS"
    ..s Rptrowid=0  f  s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",StudyID,Rptrowid)) q:Rptrowid=""  d
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
    ...Do OutRowNewStudyNo
    ..i bOut="N" d
    ...s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
    ...s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
    ...s bOut="Y"
    ...Do OutRowNewStudyNo
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
   
   
OutRowNewStudyNo
   	s RecLoc=""
    i RecLocId'="" d
    .s RecLoc=$p(^CTLOC(RecLocId),"^",2)
   	s Required=""
   	if (GetSGroupDesc="无需预约")!(GetstrOrderName["床旁") s Required="N"
   	set Data=$lb(GetRegNo,GetName,GetSexDesc,GetstrAge,GetstrDOB,GetIDCDesc,
   	 GetStudyNo,GetstrOrderName,Getrequestdoc,GetstrAccessionNum,GetstrDate,GetstrTime,strRppDate,strRppTime,GetBookedDuration,GetstrRegDate,GetstrRegTime,GetRptDocName,GetVerifyDocName,$g(GetPatientStatus),paadmdr,Oeorditemdr, 	 
   	 GetLocName,GetTotalPrice,GetPatientStatusCode,Getbilled,Gettypedesc,GetNum,Getprice,GetIndex,GetEQDesc,GetResDesc,Getifbed,$g(GetReportStatus),GetMainDoc,GetAssDoc,GetRoomDesc,GetEQGroupDesc,GetWardName,GetOldNo,Required,strXDate,GetItemStatusCode,PapatmasDR,BodyDesc,Weight,TelNo,GetIPNo,FileSent,GetBedNo,ReportSend,HaveImage,RecLocId,RecLoc,AutoInputFee,EndInputFee,Detail,RejectAppReason,BilledDesc,PinYin,ToDayOeItem,CostRecords,AppDate,Urgentflag,RegDoc,$g(Epissubtype),$g(GetSGroupDesc),$g(GetSGroupDR),$g(AppointUser),$g(AppBillView),$g(AdmReason),$g(ExterBK))
   	Set ^CacheTemp(repid,ind)=Data
   	s ^DHCRisTmpPrintData(ind)=GetRegNo_"^"_GetName_"^"_GetSexDesc_"^"_GetstrAge_"^"_GetWardName_"^"_GetBedNo_"^"_GetStudyNo_"^"_$g(ReportSend)
   	s ^DHCRisTmpPrintData=ind
   	
   	s ^DHCRisExportExcelData($g(UserID),ind)=$g(GetRegNo)_"^"_$g(GetName)_"^"_$g(GetSexDesc)_"^"_$g(GetstrAge)_"^"_$g(GetstrDOB)_"^"_$g(GetIDCDesc)_"^"_$g(GetStudyNo)_"^"_GetstrOrderName_"^"_Getrequestdoc_"^"_GetstrAccessionNum_"^"_GetstrDate_"^"_GetstrTime_"^"_strRppDate_"^"_strRppTime_"^"_$g(GetBookedDuration)_"^"_GetstrRegDate_"^"_GetstrRegTime_"^"_$g(GetRptDocName)_"^"_$g(GetVerifyDocName)_"^"_$g(GetPatientStatus)_"^"_paadmdr_"^"_Oeorditemdr_"^"_GetLocName_"^"_GetTotalPrice_"^"_$g(GetPatientStatusCode)_"^"_Getbilled_"^"_Gettypedesc_"^"_GetNum_"^"_Getprice_"^"_GetIndex_"^"_GetEQDesc_"^"_GetResDesc_"^"_Getifbed_"^"_$g(GetReportStatus)_"^"_GetMainDoc_"^"_GetAssDoc_"^"_GetRoomDesc_"^"_GetEQGroupDesc_"^"_GetWardName_"^"_$g(GetOldNo)_"^"_$g(Required)_"^"_strXDate_"^"_GetItemStatusCode_"^"_PapatmasDR_"^"_BodyDesc_"^"_Weight_"^"_TelNo_"^"_GetIPNo_"^"_$g(FileSent)_"^"_GetBedNo_"^"_$g(ReportSend)_"^"_$g(HaveImage)_"^"_RecLocId_"^"_RecLoc_"^"_$g(AutoInputFee)_"^"_$g(EndInputFee)_"^"_$g(Detail)_"^"_$g(RejectAppReason)_"^"_$g(BilledDesc)_"^"_PinYin_"^"_$g(ToDayOeItem)_"^"_$g(CostRecords)_"^"_$g(AppDate)_"^"_$g(Urgentflag)_"^"_$g(RegDoc)_"^"_$g(Epissubtype)_"^"_$g(GetSGroupDesc)_"^"_$g(GetSGroupDR)_"^"_$g(AppointUser)_"^"_$g(AdmReason)
   	s ^DHCRisExportExcelData($g(UserID))=ind
	Set ind=ind+1
 	quit
}

ClassMethod GetPrintCount(UserId As %String)
{
 
    s Count=0
	s Count=$g(^DHCRisExportExcelData(UserId))
	q Count
}

ClassMethod SetPrintData(UserId As %String, i As %String = "1")
{
	s PrintData=""
	if ($d(^DHCRisExportExcelData(UserId,i)))
	{
	   s PrintData=	$g(^DHCRisExportExcelData(UserId,i))
	}
	q PrintData
}

/// w ##class(web.DHCRisWorkBenchDoEx).HasExternalBK("23||8")
ClassMethod HasExternalBK(gOrdItemID As %String, bodyDR As %String = "") As %String
{
	q:(gOrdItemID="") ""
	s ExtRowid=""
	if (bodyDR="")
	{
		s ExtRowid=$o(^DHCRBCExternalBookInfoi("OrdItemID",gOrdItemID,""))
	}
	else
	{
		s bodyCode=$p($g(^DHCAPPART(bodyDR)),"^",2)
		if (bodyCode'="")
		{
			s ExtRowid=$o(^DHCRBCExternalBookInfoi("OrderBody",gOrdItemID,bodyCode,""))
		}
	}
	q ExtRowid
}

///  CreateDate：bianshuai
///  Descript:   获取报告医嘱项目信息(供其他组调用)
///  InPut:      医嘱ID
///  OutPut：    医嘱项ID:医嘱项目描述^体位ID:体位描述^部位1ID:部位1描述!部位2ID:部位2描述^后处理1ID:后处理1描述!后处理2ID:后处理2描述
///  w ##Class(web.DHCRisWorkBenchDoEx).GetCheckReqItmDetByOrdItm("2||95")
ClassMethod GetCheckReqItmDetByOrdItm(orditem As %String) As %String
{
	n (orditem)
	s arReqID=$o(^DHCAPREP(0,"OrdItem",orditem,""))
	Q:arReqID="" ""
	s CH=$o(^DHCAPREP(0,"OrdItem",orditem,arReqID,""))
	Q:CH="" ""
	Q:'$d(^DHCAPREP(arReqID,"AR",CH)) ""
	s arcimid=$p(^DHCAPREP(arReqID,"AR",CH),"^",1)        ///医嘱项目ID
	s itmmastid=$p(arcimid,"||",1)
	s itmmastver=$p(arcimid,"||",2)
	s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1) ///医嘱项代码
	s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) ///医嘱项名称
	
	s PosiDesc=""
	s PosiID=$p(^DHCAPREP(arReqID,"AR",CH),"^",2)     	   ///体位ID
	s:PosiID'="" PosiDesc=$p(^DHCAPPOS(PosiID),"^",2)	   ///体位
	
	s PartList=""
	s Sub=""
	f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:Sub=""  D
	.s PartID=+$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1) ///部位ID
	.s ExtStat=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",2) ///部位ID
	.Q:PartID=0
	.q:ExtStat="D"
	.s PartDesc=$p($g(^DHCAPPART(PartID)),"^",2) 				 ///部位
	.i PartList'="" s PartList=PartList_"^"_PartID_":"_PartDesc
	.E  s PartList=PartID_":"_PartDesc
	
	s DispMList=""
	s Sub=""
	f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"DI",Sub)) Q:Sub=""  D
	.s DispMID=$p(^DHCAPREP(arReqID,"AR",CH,"DI",Sub),"^",1) ///后处理ID
	.Q:DispMID=""
	.s DispMDesc=$p($g(^DHCAPDIM(DispMID)),"^",2) 				  ///后处理描述
	.i DispMList'="" s DispMList=DispMList_"!"_DispMID_":"_DispMDesc
	.E  s DispMList=DispMID_":"_DispMDesc
	
	;s ListData=arcimid_":"_arcitmdesc_"^"_PosiID_":"_PosiDesc_"^"_PartList_"^"_DispMList
	s ListData=arcitmdesc_"!"_PartList
	Q ListData
}

/// panpan
/// 新的申请单医嘱和部位拼接含(DR^Name)
/// w ##Class(web.DHCRisWorkBenchDoEx).GetstrOrderName("73||21")
ClassMethod GetstrOrderName(orditem As %String) As %String
{
	s StrOrderBodyName=##Class(web.DHCRisWorkBenchDoEx).GetCheckReqItmDetByOrdItm(orditem)
	s StrOrderName=$p($g(StrOrderBodyName),"!",1)
	s BodyName=$p($g(StrOrderBodyName),"!",2)
	/*
	s Num=0
    s Num=$L(BodyName,"^")
    s PartList=""
    f i=1:1:Num  d
    .s PartName=$p($g(BodyName),"^",i)
    .s NumLeng=$L(PartName,":")
    .s EveryBodyName=$p($g(PartName),":",2)
    .i PartList'="" s PartList=PartList_"^"_EveryBodyName
	.E  s PartList=EveryBodyName
	q PartList
	*/
	q BodyName
}

/// panpan
/// 新的申请单医嘱和部位DR拼接
/// w ##Class(web.DHCRisWorkBenchDoEx).GetstrOrderCode("2||95")
ClassMethod GetstrOrderCode(orditem As %String) As %String
{
	s StrOrderBodyName=##Class(web.DHCRisWorkBenchDoEx).GetCheckReqItmDetByOrdItm(orditem)
	s StrOrderName=$p($g(StrOrderBodyName),"!",1)
	s BodyName=$p($g(StrOrderBodyName),"!",2)
	
	s Num=0
    s Num=$L(BodyName,"^")
    s PartList=""
    f i=1:1:Num  d
    .s PartName=$p($g(BodyName),"^",i)
    .s NumLeng=$L(PartName,":")
    .s EveryBodyName=$p($g(PartName),":",1)
    .i PartList'="" s PartList=PartList_"^"_EveryBodyName
	.E  s PartList=EveryBodyName
	q PartList
}

/// /获取医嘱部位List,","DR.
/// w ##Class(web.DHCRisWorkBenchDoEx).GetBodyPart("32^31^")
ClassMethod GetBodyPart(code As %String) As %String
{
    
    
	s PartList=""
	s Num=$L(code,"^")
	f i=1:1:Num    d 
	.s PartID=$p(code,"^",i)
	.q:PartID=""
	.s PartDesc=$p($g(^DHCAPPART(PartID)),"^",2) 				 ///部位
	.i PartList'="" s PartList=PartList_"^"_PartID_":"_PartDesc
	.E  s PartList=PartID_":"_PartDesc
	q PartList
}

/// 医嘱部位名称的拼接，Name
/// w ##Class(web.DHCRisWorkBenchDoEx).GetBodyList("73||21")
ClassMethod GetBodyList(orditem As %String) As %String
{
	s StrOrderBodyName=##Class(web.DHCRisWorkBenchDoEx).GetCheckReqItmDetByOrdItm(orditem)
	s StrOrderName=$p($g(StrOrderBodyName),"!",1)
	s BodyName=$p($g(StrOrderBodyName),"!",2)

	s Num=0
    s Num=$L(BodyName,"^")
    s PartList=""
    f i=1:1:Num  d
    .s PartName=$p($g(BodyName),"^",i)
    .s NumLeng=$L(PartName,":")
    .s EveryBodyName=$p($g(PartName),":",2)
    .i PartList'="" s PartList=PartList_","_EveryBodyName
	.E  s PartList=EveryBodyName
	q PartList
}

/// 获取病人的费用类别
/// input:病人就诊id     output:就诊医保类型表id
/// w ##Class(web.DHCRisWorkBenchDoEx).GetFeeType("")
ClassMethod GetFeeType(EpisodeID As %String) As %String
{
	s EpisodeID=EpisodeID
    s FeeType=$p(^PAADM(EpisodeID,1),"^",7)
    q FeeType
}

// ^PAPERi("PAPMI_PatNo",$$ALPHAUP({PAPMI_No}),{PAPMI_RowId}) 

/// 根据regno获取病人pa_patMas表rowid
/// input:regno     
/// w ##Class(web.DHCRisWorkBenchDoEx).getPatMasRowid("")
ClassMethod getPatMasRowid(RegNo As %String) As %String
{
	s rowid=""
	q:(RegNo="") rowid
    s rowid=$o(^PAPERi("PAPMI_PatNo",$zcvt(RegNo,"U"),""))
    q rowid
}

/// Descript: 根据医嘱项获取部位树
/// w ##Class(web.DHCRisWorkBenchDoEx).GetPartTreeChildenByArc("6993||1")
ClassMethod GetPartTreeChildenByArc(itmmastid As %String) As %String
{
	n (itmmastid)
	    ///  是否存在孩子节点
	    s TraID=$o(^DHCAPPTRA(0,"Arc",itmmastid,""))
	Q:TraID="" ""
	s count=0
	///  有孩子节点的初始化时收缩
	/// w ","_##class(web.DHCAPPJsonCommon).getJsonTreeClosedSign()
	w ",""children"":["
	s TraID=""
	f  s TraID=$o(^DHCAPPTRA(0,"Arc",itmmastid,TraID)) q:TraID=""  d
	.s CH=""
	.f  s CH=$o(^DHCAPPTRA(0,"Arc",itmmastid,TraID,CH)) q:CH=""  d
	..s PartID=$p(^DHCAPPTRA(TraID,"I",CH),"^",1)
	..Q:'$D(^DHCAPPART(PartID))
	..s PartDesc=$p(^DHCAPPART(PartID),"^",2)   /// 部位
	..Q:$D(TreeLeafNote(PartID))
	..s TreeLeafNote(PartID)=PartDesc
	..
	..s count = count+1
	..i count=1 d
	...w ##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(PartID,PartDesc)
	..e  d
	...w ","_##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(PartID,PartDesc)
	..w "}"
	w "]"
	Q ""
}

/// 根据病人的登记号，获取病人卡内余额
/// w ##Class(web.DHCRisWorkBenchDoEx).GetAccUsePrice("0006126244")
ClassMethod GetAccUsePrice(RegNo As %String) As %String
{
    n (RegNo)
    q:RegNo="" ""
	;s UsePrice=##class(web.UDHCAccManageCLS7).GetAccInfoByPAPMI(RegNo,"")
	;s AccUsePrice=$p(UsePrice,"^",3)_"元"
	;s rtn=##class(web.UDHCJFARREARSMANAGE).CheckArrears(33,15,"OE")
	q $g(AccUsePrice)
}

/// 根据预约明细表rowid,查询出部位列表  20170119
ClassMethod GetBookDetailBodyList(bookDetailRowid) As %String
{
	
	q:(bookDetailRowid="") ""
	s bodylistGetByBookDetail=""
	s bodyRowidGetByDetail=""
	for
	{
		s bodyRowidGetByDetail=$o(^User.DHCRBCSchduleDetailBodyI("IndexDetailBody",bookDetailRowid,bodyRowidGetByDetail))
		q:(bodyRowidGetByDetail="")
		s bodyDetailRowidGetByBook=""
		for
		{
			s bodyDetailRowidGetByBook=$o(^User.DHCRBCSchduleDetailBodyI("IndexDetailBody",bookDetailRowid,bodyRowidGetByDetail,bodyDetailRowidGetByBook))
			q:(bodyDetailRowidGetByBook="")
			if (bodylistGetByBookDetail="")
			{
				s bodylistGetByBookDetail=$lg(^User.DHCRBCSchduleDetailBodyD(bodyDetailRowidGetByBook),3)_":"_$lg(^User.DHCRBCSchduleDetailBodyD(bodyDetailRowidGetByBook),4)
			}
			else
			{
				s bodylistGetByBookDetail=bodylistGetByBookDetail_"^"_$lg(^User.DHCRBCSchduleDetailBodyD(bodyDetailRowidGetByBook),3)_":"_$lg(^User.DHCRBCSchduleDetailBodyD(bodyDetailRowidGetByBook),4)
			}
		}
	}

	q bodylistGetByBookDetail
}

// 查找医嘱状态 返回值 : code^desc

ClassMethod getOrderBodyStatus(ordItemRowidIn As %String, bodyRowidIn As %String = "") As %String
{
	s ^DHCRisTemp("getOrderBodyStatus")=$g(ordItemRowidIn)_"^"_$g(bodyRowidIn)
	s statusDefault="^"
	q:(ordItemRowidIn="") statusDefault
	if ( bodyRowidIn="")
	{
		s ItemStatDROrder=$p(^OEORD($p(ordItemRowidIn,"||",1),"I",$p(ordItemRowidIn,"||",2),1),"^",13) ; 医嘱状态
		i ItemStatDROrder'="" 
		{
			s ItemStatusCodeOrder=$p(^OEC("OSTAT",ItemStatDROrder),"^",1)
			s ItemStatusCodeDesc=$p(^OEC("OSTAT",ItemStatDROrder),"^",2)
		}
		q $g(ItemStatusCodeOrder)_"^"_$g(ItemStatusCodeDesc)
	}

	s arReqID=$o(^DHCAPREP(0,"OrdItem",ordItemRowidIn,""))
	q:arReqID="" statusDefault
	s CH=$o(^DHCAPREP(0,"OrdItem",ordItemRowidIn,arReqID,""))
	q:CH="" statusDefault
	q:'$d(^DHCAPREP(arReqID,"AR",CH)) statusDefault
	
	
	s Sub="" f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:Sub=""  D
	.s PartID=+$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1) ///部位ID
	.q:(bodyRowidIn'=PartID)
	.s ExtStat=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",2) 
	.q:(ExtStat="")
	.s orderStatusRowid=$o(^OEC("OSTAT",0,"Code",$zcvt(ExtStat,"U"),""))
	.if orderStatusRowid'="" d
	..s ExtStatDesc=$p(^OEC("OSTAT",orderStatusRowid),"^",2)
	
	q $g(ExtStat)_"^"_$g(ExtStatDesc)
}

/// 根据预约明细表rowid,查询出部位列表  20170119
ClassMethod GetExternalBookBodyListByRowid(externalBookRowid As %String) As %String
{
	n (externalBookRowid)
	q:(externalBookRowid="") ""
	s bodylist=""
	
	s bodyCode=$p($g(^DHCRBCExternalBookInfo(externalBookRowid)),"^",13)
	
	if (bodyCode'="")
	{
		s orderItemRowid=$p($g(^DHCRBCExternalBookInfo(externalBookRowid)),"^",2)
		s bodyListForExternal=..GetstrOrderName(orderItemRowid)
		for numOfBody=1:1:$l(bodyListForExternal,"^")
		{
			s bodyInfo=$p(bodyListForExternal,"^",numOfBody)
			s bodyRowid=$p(bodyInfo,":",1)
			s bodyCodeGet=$p($g(^DHCAPPART(bodyRowid)),"^",2)
			if (bodyCodeGet=bodyCode)
			{
				s bodylist=bodyRowid
				quit
			}
		}
	}
	
	
	q bodylist
}

ClassMethod QueryBookedItemNew(Intype, InStatusCode, Inpaadmdr, InAppStDate, InLocID, InResourceID, InReportDoc, InReportVerifyDoc, InIsBedOrd, InRoomDR, InRegEQDR, InRequireAppoint, InRegNo, InStudyNo, InName, InPatientNo, InAppLocDR, InEQGroupDR, InWardDR, InNO, IsFilmSet, BookedType, IsUItem, IsCostRecords, UserID, gAppLoc) As %Integer
{
    
	 k ^DHCRISTMEP("TEMPITEMROWID")
	 k bookOrderList
	 
	 s reourceID=""
	 for
	 {
		 s reourceID=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",InLocID,InAppStDate,reourceID))
		 q:(reourceID="")
		 continue:(InResourceID'="")&(InResourceID'=reourceID)
		 s GetResDesc=""
		 s EQDR=$p($g(^RB("RES",reourceID)),"^",3)
	 	 i EQDR'="" s GetResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
		 s scheduleRowid=""
		 for
		 {
			 s scheduleRowid=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",InLocID,InAppStDate,reourceID,scheduleRowid))
			 q:(scheduleRowid="")
			 s (GetAppointDate,GetAppointstTime)=""
			 s AppointDate=$p(^DHCRBCResourceSchdule(scheduleRowid),"^",2)
	 		 s GetAppointDate=##class(websys.Conversions).DateLogicalToHtml(AppointDate) ;$zd(AppointDate,3)
			 s AppointstTime=$p(^DHCRBCResourceSchdule(scheduleRowid),"^",5)
			 s scheduleDetail=0
			 for
			 {
				 s scheduleDetail=$o(^DHCRBCResSchduleDetaili("SchudleId",scheduleRowid,scheduleDetail)) 
				 q:scheduleDetail=""
				 s oeorditemdr=$p($g(^DHCRBCResSchduleDetail("Detail",scheduleDetail)),"^",1)
			 	 continue:(oeorditemdr="")
			 	 s AppointUser=""
			 	 i $p($g(^DHCRBCResSchduleDetail("Detail",scheduleDetail)),"^",18)'="" s AppointstTime=$p($g(^DHCRBCResSchduleDetail("Detail",scheduleDetail)),"^",18)
	 			 s GetAppointstTime=##class(websys.Conversions).TimeLogicalToHtml(AppointstTime) ;$zt(AppointstTime,1)
			 	 s BKStudyNo=$p($g(^DHCRBCResSchduleDetail("Detail",scheduleDetail)),"^",6)
	 			 s AppointUserDR=$p($g(^DHCRBCResSchduleDetail("Detail",scheduleDetail)),"^",15)
	 			 i AppointUserDR'="" s AppointUser=$p($g(^SSU("SSUSR",AppointUserDR)),"^",2)
			 	 Do OutRowBookDetail
			 }
		 }
	 }
	 
	 s exterBookRowid=""
	 for
	 {
		 s exterBookRowid=$o(^DHCRBCExternalBookInfoi("Date",InAppStDate,InLocID,exterBookRowid))
		 q:(exterBookRowid="")
		 s oeorditemdr=$p(^DHCRBCExternalBookInfo(exterBookRowid),"^",2)
		 continue:(oeorditemdr="")
		 continue:(InResourceID'="")  ;第三方预约不支持按预约资源查询
		 s AppointDate="",AppointstTime=""
	 	 s AppointDate=$p($g(^DHCRBCExternalBookInfo(exterBookRowid)),"^",5)
	 	 i AppointDate'="" s GetAppointDate=##class(websys.Conversions).DateLogicalToHtml(AppointDate)  ;$zd(AppointDate,3)
	 	 s AppointstTime=$p($g(^DHCRBCExternalBookInfo(exterBookRowid)),"^",6)
	 	 i AppointstTime'="" s GetAppointstTime=##class(websys.Conversions).TimeLogicalToHtml(AppointstTime)   ;$zt(AppointstTime,1)
	 	 s GetResDesc=$p($g(^DHCRBCExternalBookInfo(exterBookRowid)),"^",4)
		 s BKStudyNo=""
		 s AppointUser=$p($g(^DHCRBCExternalBookInfo(exterBookRowid)),"^",7)
		 Do OutRowBookDetail
	 }
	 
	 
	 
	Set qHandle=$lb(0,repid,0)
   	Quit $$$OK
	
	
	 
OutRowBookDetail

	 //s bodydrList=##Class(web.DHCRisWorkBenchDoEx).GetstrOrderName(oeorditemdr)
	 s AppBillNo=##Class(web.DHCAPPInterface).GetExaReqNo(oeorditemdr)    //申请单号
	 
	 s bodydrList=""
	 if ($g(scheduleDetail)'="")
	 {
	 	s bodydrList=..GetBookDetailBodyList($g(scheduleDetail))
	 }
	 
	 if ($g(exterBookRowid)'="")
	 {
		 s bodydrList=..GetExternalBookBodyListByRowid(exterBookRowid)
	 }
	 
	 if (bodydrList="")
	 {
		 ;获取医嘱的部位
		 s bodydrList=..GetstrOrderName(oeorditemdr)
	 }
	 
	 ;w !,oeorditemdr_"**"_$g(DetailRowid)_"**"_$g(DEBRwoid)_"**"_bodydrList
	 s NumLeng=$L(bodydrList,"^")
	 f j=1:1:NumLeng  d  
	 .s bodypart=$p($g(bodydrList),"^",j)
	 .s bodypartcode=$p($g(bodypart),":",1)
	 .s bodypart=$p($g(bodypart),":",2) 
	 .s appOrderStatus=..getOrderBodyStatus(oeorditemdr,bodypartcode)
	 .s appOrderStatus=$p(appOrderStatus,"^",1)
	 .;w !,appOrderStatus_"**"_oeorditemdr_"**"_bodypartcode
	 .q:((appOrderStatus="D")||(appOrderStatus="C"))
	 .s GetPaadmr=$p($g(^OEORD($p($g(oeorditemdr),"||",1))),"^",1)
	 .s AppRowid=$o(^DHCRBAppOrdi(0,oeorditemdr,0)) 
	 .s AppDate="",Urgentflag="",AppBillView=""
	 .i AppRowid'="" d
	 ..s XDate=$p($g(^DHCRBApp("Bill",AppRowid)),"^",10)
	 ..s strXDate=##class(websys.Conversions).DateLogicalToHtml(XDate) ;$zd(XDate,3)
	 ..s AppDate=$p($g(^DHCRBApp("Bill",AppRowid)),"^",1)
     ..i AppDate'="" s AppDate=##class(websys.Conversions).DateLogicalToHtml(AppDate) ;$zd(AppDate,3)
     ..s Urgentflag=$p($g(^DHCRBApp("Bill",AppRowid)),"^",26)
     ..s AppBillView="申请单浏览"
	 .q:(Inpaadmdr'="")&(GetPaadmr'=Inpaadmdr)
	 .q:$g(GetPaadmr)=""
	 .s papatmasmdr=$p(^PAADM(GetPaadmr),"^",1)  
	 .;get patient diagnose 
	 .s GetIDCDesc=##class(web.DHCRisCommFunctionEx).GetDiagnose(GetPaadmr)
	 .s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(GetPaadmr)
	 .s GetRegNo=$p(PatInfo,"^",1)
	 .s AccUsePrice="" ;卡余额 ##Class(web.DHCRisWorkBenchDoEx).GetAccUsePrice(GetRegNo)
	 .s GetName=$p(PatInfo,"^",2)
	 .s GetstrDOB=$p(PatInfo,"^",3)
	 .;if GetstrDOB'="" d
     .;.s GetstrDOB=$zd($zdh(GetstrDOB,4),3)
	 .s GetstrAge=$p(PatInfo,"^",4)
	 .s GetSexDesc=$p(PatInfo,"^",5)
	 .s Getpatienttype=$p(PatInfo,"^",6)
	 .s Gettypedesc=$p(PatInfo,"^",7)
	 .s GetLocName=$p(PatInfo,"^",8)
	 .s GetIPNo=$p(PatInfo,"^",9)
	 .s GetWardName=$p(PatInfo,"^",10)
	 .s GetBedNo=$p(PatInfo,"^",11)
	 .s GetLocdr=$p(PatInfo,"^",12)
	 .;q:(gAppLoc'=GetLocdr)&(GetLocdr'="") ;中国医大增加
	 .s GetWardDr=$p(PatInfo,"^",14)
	 .s PapatmasDR=$p(PatInfo,"^",24)
	 .s Weight=$p(PatInfo,"^",21)
	 .s TelNo=$p(PatInfo,"^",19)
	 .s PinYin=$p(PatInfo,"^",38)
	 .s Epissubtype=$p($g(PatInfo),"^",41)
	 .s AdmReason=$p($g(PatInfo),"^",43)
	 .q:(InWardDR'="")&(GetWardDr'=InWardDR)
	 .q:(InRegNo'="")&(GetRegNo'=InRegNo)
	 .q:(InName'="")&(GetName'[InName)
	 .q:(InPatientNo'="")&(InPatientNo'=GetIPNo)
	 .q:(InAppLocDR'="")&(GetLocdr'=InAppLocDR)
	 .q:(Intype'="")&(Intype'=Getpatienttype)
	 .s ordrowid=$p(oeorditemdr,"||",1)
	 .s orditemchildsub=$p(oeorditemdr,"||",2)
	 .s CheckEntryFlag="",CostRecords=""
	 .s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(ordrowid,orditemchildsub,bodypartcode)	 
	 .s GetstrOrderName=$p(ordInfo,"^",1)
	 .s GetstrDate=$p(ordInfo,"^",2)
	 .s GetstrTime=$p(ordInfo,"^",3)
	 .s Getrequestdoc=$p(ordInfo,"^",4)
	 .s GetstrAccessionNum=$p(ordInfo,"^",5)
	 .s GetSGroupDesc=$p(ordInfo,"^",6)
	 .s GetSGroupDR=$p($g(ordInfo),"^",36)
	 .s GetsubCatDesc=$p(ordInfo,"^",7)
	 .s GetCatDesc=$p(ordInfo,"^",8)
	 .s Getifbed=$p(ordInfo,"^",9)
	 .s Getprice=$p(ordInfo,"^",10)
	 .s GetNum=$p(ordInfo,"^",11)
	 .s GetTotalPrice=$p(ordInfo,"^",12)
	 .s Getbilled=$p(ordInfo,"^",13)
	 .s GetItemStatusCode=$p(ordInfo,"^",14)
	 .q:(GetItemStatusCode="U")!(GetItemStatusCode="D")!(GetItemStatusCode="C")
	 .s GetordDate=$p(ordInfo,"^",15)
	 .s GetordTime=$p(ordInfo,"^",16)
	 .s GetItemStatusCode=$p(ordInfo,"^",17)
	 .s AutoInputFee=$p(ordInfo,"^",25) ;"需要另划价标志"
	 .i AutoInputFee="Y" s ToDayOeItem="查询"
	 .s EndInputFee=$p(ordInfo,"^",26)  ;"已另划价标识"
	 .s BilledDesc=$p(ordInfo,"^",27)
	 .s BodyDescNew=bodypart
	 .s CheckEntryFlag=$p(ordInfo,"^",30)
	 .s GetExterFalg=$p(ordInfo,"^",32)  ;外部预约标识
	 .s GetResultFlag=$p(ordInfo,"^",38) ;第三方回传报告状态
	 .s Urgentflag=$p(ordInfo,"^",35)
	 .q:(IsCostRecords'="Y")&(CheckEntryFlag="Y") 
     .i CheckEntryFlag="Y" s CostRecords="已补录"
	 .q:(InIsBedOrd="Y")&(Getifbed'="Y")  ;检索床旁医嘱，不是床旁医嘱
	 .s GetPatientStatusCode="B"
	 .s ExterBK="N"
     .i GetExterFalg'="" s ExterBK="Y"
	 .s GetReportStatusCode="N"  ;未写报告
	 .s GetstrRegDate="",GetstrRegTime="",GetRptDocName="",GetVerifyDocName="",GetStudyNo="",GetIndex="",GetEQDesc=""
	 .s GetEQDr="",GetMainDoc="",GetAssDoc="",GetRoomDesc="",GetRoomDr="",GetEQGroupDR="",GetEQGroupDesc=""
	 .s bOut="N",FileSent="",HaveImage="" ,RegDoc=""
	 .s regInfoRowid=##class(web.DHCRisResApptSchudleSystem).getRegRowid(oeorditemdr_"^"_bodypartcode)
	 .i regInfoRowid="" d
	 ..s GetPatientStatusCode="B"  s GetStudyNo=""    ;BKStudyNo   不取预约的检查号
	 .e  d
	 ..s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfo(oeorditemdr,bodypartcode)
	 ..s GetStudyNo=$p(RegInfo,"^",1)
	 ..s GetPatientStatusCode="I"
	 ..s GetstrRegDate=$p(RegInfo,"^",2)
	 ..s GetstrRegTime=$p(RegInfo,"^",3)
	 ..s GetIndex=$p(RegInfo,"^",4)
	 ..s GetEQDesc=$p(RegInfo,"^",5)
	 ..s GetMainDoc=$p(RegInfo,"^",6)
	 ..s GetAssDoc=$p(RegInfo,"^",7)
	 ..s GetRoomDesc=$p(RegInfo,"^",8)
	 ..s GetRoomDr=$p(RegInfo,"^",9)
	 ..s GetEQDr=$p(RegInfo,"^",10)
	 ..s GetEQGroupDesc=$p(RegInfo,"^",11)
	 ..s GetEQGroupDR=$p(RegInfo,"^",12)
	 ..s NO=$p(RegInfo,"^",13)
	 ..;s BodyDescNew=$p(RegInfo,"^",17)
	 ..s Urgentflag=$p(RegInfo,"^",21)
	 ..s RegDoc=$p(RegInfo,"^",24)
	 ..s FileSent="" //##class(web.DHCRisWorkBenchDoEx).GetFilmSendDesc(GetStudyNo)
	 ..s ReportSend="" //##class(web.DHCRisWorkBenchDoEx).GetReportSend(GetStudyNo)
	 ..s GetImgcount=0
	 ..s Imrowid=0 f  s Imrowid=$o(^DHCRBStudyi("StudyNo-Images",GetStudyNo,Imrowid)) q:Imrowid=""  d
	 ...s GetPatientStatusCode="E"    ;正在检查
	 ...s ExtName=$p($g(^DHCRBStudy(0,"StudyImages",Imrowid)),"^",2)
	 ...i ((ExtName="avi")!(ExtName="dcm")!(ExtName="normal")!(ExtName="dsa"))  d
	 ....s GetImgcount=GetImgcount+1
	 ....s ReportStatusCode="I"             ;图象已经采集
	 ....s HaveImage="是"
	 ..s sReportStuatCode="VS"
	 ..s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",GetStudyNo,0),-1)
	 ..i Rptrowid'="" d
	 ...s GetRptID=$p(^DHCRBStudy("Report",Rptrowid),"^",2)
	 ...s GetRptVersion=$p(^DHCRBStudy("Report",Rptrowid),"^",3)
	 ...s GetRptStatusDR=$p(^DHCRBStudy("Report",Rptrowid),"^",4)
	 ...i GetRptStatusDR'="" d
	 ....s GetReportStatusCode=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",1)
	 ....i sReportStuatCode[GetReportStatusCode d
	 .....s GetPatientStatusCode="O"
	 ....e  d
	 .....s GetPatientStatusCode="E"
	 ...s GetRptDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",8)
	 ...i GetRptDocDR'="" s GetRptDocName=$p(^SSU("SSUSR",GetRptDocDR),"^",2)
	 ...s GetRptDate=$p(^DHCRBStudy("Report",Rptrowid),"^",9)
	 ...i GetRptDate'="" s GetRptDate=##class(websys.Conversions).DateLogicalToHtml(GetRptDate) ;$zd(GetRptDate,3)
	 ...s GetRptTime=$p(^DHCRBStudy("Report",Rptrowid),"^",10)
	 ...i GetRptTime'="" s GetRptTime=##class(websys.Conversions).TimeLogicalToHtml(GetRptTime)  ;$zt(GetRptTime,3)
	 ...s GetVerifyDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",11)
	 ...i GetVerifyDocDR'="" s GetVerifyDocName=$p(^SSU("SSUSR",GetVerifyDocDR),"^",2)
	 ...s GetVerifyDate=$p(^DHCRBStudy("Report",Rptrowid),"^",12)
	 ...i GetVerifyDate'="" s GetVerifyDate=$zd(GetVerifyDate,3) 
	 ...s GetVerifyTime=$p(^DHCRBStudy("Report",Rptrowid),"^",13)
	 ...i GetVerifyTime'="" s GetVerifyTime=$zt(GetVerifyTime,3)
	 .i InLocID'="" s RecLoc=$p(^CTLOC(InLocID),"^",2)
	 .s PatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
	 .s ReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
	 .set Data=$lb(GetRegNo,GetName,GetSexDesc,GetstrAge,GetstrDOB,GetIDCDesc,GetStudyNo,GetstrOrderName,Getrequestdoc,GetstrAccessionNum,GetstrDate,GetstrTime,GetAppointDate,GetAppointstTime,$g(GetBookedDuration),GetstrRegDate,GetstrRegTime,GetRptDocName,GetVerifyDocName,PatientStatus,GetPaadmr,oeorditemdr,GetLocName,GetTotalPrice,GetPatientStatusCode,Getbilled,Gettypedesc,GetNum,Getprice,GetIndex,GetEQDesc,GetResDesc,Getifbed,ReportStatus,GetMainDoc,GetAssDoc,GetRoomDesc,GetEQGroupDesc,GetWardName,NO,Required,strXDate,GetItemStatusCode,PapatmasDR,$g(BodyDescNew),Weight,TelNo,GetIPNo,FileSent,GetBedNo,ReportSend,HaveImage,InLocID,$g(RecLoc),AutoInputFee,EndInputFee,Detail,RejectAppReason,BilledDesc,PinYin,ToDayOeItem,CostRecords,AppDate,Urgentflag,RegDoc,Epissubtype,GetSGroupDesc,GetSGroupDR,$g(AppointUser),$g(AppBillView),$g(AdmReason),$g(ExterBK),$g(bodypartcode),$g(AppBillNo),$g(BKStudyNo),AccUsePrice,GetResultFlag)
     .s ^CacheTemp(repid,ind)=Data
     .s ^DHCRisTmpPrintData(ind)=GetRegNo_"^"_GetName_"^"_GetSexDesc_"^"_GetstrAge_"^"_GetWardName_"^"_GetBedNo_"^"_GetStudyNo_"^"_$g(ReportSend)
   	 .s ^DHCRisTmpPrintData=ind
   	 .s ^DHCRisExportExcelData($g(UserID),ind)=$g(GetRegNo)_"^"_$g(GetName)_"^"_$g(GetSexDesc)_"^"_$g(GetstrAge)_"^"_$g(GetstrDOB)_"^"_$g(GetIDCDesc)_"^"_$g(GetStudyNo)_"^"_$g(GetstrOrderName)_"^"_$g(Getrequestdoc)_"^"_$g(GetstrAccessionNum)_"^"_$g(GetstrDate)_"^"_$g(GetstrTime)_"^"_$g(GetAppointDate)_"^"_$g(GetAppointstTime)_"^"_$g(GetBookedDuration)_"^"_$g(GetstrRegDate)_"^"_$g(GetstrRegTime)_"^"_$g(GetRptDocName)_"^"_$g(GetVerifyDocName)_"^"_$g(PatientStatus)_"^"_$g(GetPaadmr)_"^"_$g(oeorditemdr)_"^"_$g(GetLocName)_"^"_$g(GetTotalPrice)_"^"_$g(GetPatientStatusCode)_"^"_$g(Getbilled)_"^"_$g(Gettypedesc)_"^"_$g(GetNum)_"^"_$g(Getprice)_"^"_$g(GetIndex)_"^"_$g(GetEQDesc)_"^"_$g(GetResDesc)_"^"_Getifbed_"^"_ReportStatus_"^"_GetMainDoc_"^"_GetAssDoc_"^"_GetRoomDesc_"^"_GetEQGroupDesc_"^"_GetWardName_"^"_NO_"^"_Required_"^"_$g(strXDate)_"^"_GetItemStatusCode_"^"_PapatmasDR_"^"_$g(BodyDescNew)_"^"_Weight_"^"_TelNo_"^"_$g(GetIPNo)_"^"_$g(FileSent)_"^"_$g(GetBedNo)_"^"_$g(ReportSend)_"^"_$g(HaveImage)_"^"_InLocID_"^"_RecLoc_"^"_$g(AutoInputFee)_"^"_$g(EndInputFee)_"^"_$g(Detail)_"^"_$g(RejectAppReason)_"^"_$g(BilledDesc)_"^"_$g(PinYin)_"^"_$g(ToDayOeItem)_"^"_$g(CostRecords)_"^"_$g(AppDate)_"^"_$g(Urgentflag)_"^"_$g(RegDoc)_"^"_$g(Epissubtype)_"^"_$g(GetSGroupDesc)_"^"_$g(GetSGroupDR)_"^"_$g(AppointUser)_"^"_$g(AdmReason)_"^"_$g(bodypartcode)_"^"_$g(AppBillNo)_"^"_$g(BKStudyNo)_"^"_AccUsePrice_"^"_GetResultFlag
   	 .s ^DHCRisExportExcelData($g(UserID))=ind
   	 .i bodypartcode="" s OrderBookOut(oeorditemdr)=""
   	 .e  s OrderBookOut(oeorditemdr,bodypartcode)=""
   	 .Set ind=ind+1
}

/// 获取病人检查报告的检查所见内容
/// w ##class(web.DHCRisWorkBenchDoEx).getReportInfo("6761||2") wangfeng20171227
ClassMethod getReportInfo(orderItemRowid As %String) As %String
{
	n (orderItemRowid)
	s ^nw(66)=orderItemRowid
	s examSee=""
	q:(orderItemRowid="") examSee
	s regInfoRowid=$o(^DHCPACRegInfoi("OEORI",orderItemRowid,""))
	i (regInfoRowid=""){
	b //01
	s requestId=""
	s requestId=$o(^dbo.tblRequestI("indexBarcode"," "_orderItemRowid,requestId)) 
	b //02
	i (requestId=""){
	s regid=""
	s regid=$o(^DHCPACRegInfoi("OEORI",OEORowid,""),-1)
	q:regid=""
    s Staccnum=$p(^DHCPACRegInfo(regid),"^",2)
    q:Staccnum="" "^"
	s examSee=""
	s examSee=$o(^DHCRBStudyi("Report","StudyNo",Staccnum,""))
	q:examSee="" "^"	
		}
	s requestInfo=^dbo.tblRequestD(requestId)
	q:(requestInfo="")
	s examSee=$o(^dbo.tblExaminationI("idxRequestID",requestId,""))
	}
	i (regInfoRowid'="")
	{
		i $d(^DHCPACRegInfo(regInfoRowid))
		{
			s studyNo=$p(^DHCPACRegInfo(regInfoRowid),"^",2)
			if (studyNo'="")
			{
					s reportRowid=$o(^DHCRBStudyi("Report","StudyNo",studyNo,""),-1)
					if (reportRowid'="")
					{
						s examSee=$g(^DHCRBStudy("Report",reportRowid,"ExamDescEx"))
				
					}
			}
		}
	}
	q examSee
}

ClassMethod GetEKGRptInfo(OeordId As %String) As %String
{
	s $ZT="ERRORSEKGINFO"
	s (ReportState,Negative,DoctorName,DoctorId,ReportTime,Diagnose,ReportUrl,ReadStatus)=""
 	
	d GetRptInfoFromEKG
	
	;if UserId'="" set docCode=$p(^SSU("SSUSR",UserId),"^",1)
	;else  set docCode="" 
	
	set studyNo="EKG||"_OeordId
	;set ReadStatus=##class(RISService.TrakRISService).GetRPTCMStatus(OeordId,studyNo,docCode)
	;set ReadStatus=##Class(web.DHCEkgService).IfRptRead(OeordId,UserId)
	;set ReadStatus=$p(ReadStatus,"^",1)
	
	if DoctorName="" d
	.s PacsInfo=##Class(RISService.TrakRISService).GetReportContent("",OeordId)
	.s rtnInfo="检查所见:"_$p(PacsInfo,"^",1)_"诊断意见:"_$p(PacsInfo,"^",2)
 	e  s rtnInfo="阴性阳性："_Negative_"，检查者："_DoctorName_"，医生ID:"_DoctorId_",报告日期："_ReportTime_",诊断："_Diagnose //_",报告URL:"_ReportUrl _"^"_ReadStatus
 				
  	
 	q rtnInfo
	 	
GetRptInfoFromEKG
	new $NAMESPACE
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()	
  	s requestId=""
	s requestId=$o(^dbo.tblRequestI("indexBarcode"," "_OeordId,requestId))
	;b ;requestId
	q:(requestId="")
	s requestInfo=^dbo.tblRequestD(requestId)
	q:(requestInfo="")
	s examId=$o(^dbo.tblExaminationI("idxRequestID",requestId,""))
	q:(examId="")
	s examInfo=^dbo.tblExaminationD(examId)
	q:(examInfo="")
	s status=$li(examInfo,20)
	s ReportState="0"
	i ((status="15")!(status="17")) d
	.s ReportState="1"
	.s Negative=$li(examInfo,30)
	.s Diagnose=$li(examInfo,11)
	.i Diagnose'[$c(10) s Diagnose=Diagnose_$c(10) 
	.s D=""
	.f i=1:1:$l(Diagnose,$c(10)) d
	..s tmpD=$p(Diagnose,$c(10),i)
	..i (tmpD'="") d
	...i (D="") s D=tmpD
	...e  s D=D_","_tmpD
	.s Diagnose=D
	.s ReportTime=$li(examInfo,6)
	.s ReportUserID=$li(examInfo,7)
	.q:((ReportUserID="")!(ReportUserID="0"))
	.s userInfo=$g(^dbo.tblUserD(ReportUserID))
	.q:(userInfo="")
	.s DoctorId=$li(userInfo,8)
	.s DoctorName=$li(userInfo,11)
	.s urlCfgId=$o(^dbo.tblConfigureI("idxKey"," WEBURL",""))
	.q:(urlCfgId="")
	.s urlInfo=^dbo.tblConfigureD(urlCfgId)
	.q:(urlInfo="")
	.s url=$li(urlInfo,6)
	.s ReportUrl=url_"?OID="_OeordId
 	q
 
ERRORSEKGINFO
	Set ErrorMsg=$ZE
	new $NAMESPACE
	zn "DHC-APP"
	s ^tmpDHCEKG("GetEKGRptInfo",OeordId,$zd($h,3),$zt($p($h,",",2)))=ErrorMsg
	q "-1"
}

}
