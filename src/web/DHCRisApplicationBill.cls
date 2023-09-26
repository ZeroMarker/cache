Import SQLUser

/// 2014-05-29 注视GetCurrentStatus(paadmdr)函数的接口
Class web.DHCRisApplicationBill Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 68;

/// d ##class(%ResultSet).RunQuery("web.DHCRisApplicationBill","GetServiceOrder","58576","","")
/// 查询：GetServiceOrder
/// 参数 EpisodeID:paadmrowid,
/// 	 LocDr:CT_LOC.Rowid 暂时不用
/// 	 CheckSend：是否查询发送的申请
/// 功能：查询病人的申请医嘱
Query GetServiceOrder(EpisodeID As %String, LocDR As %String, CheckSend As %String) As %Query(ROWSPEC = "ExamOrder:%String,OrderName:%String,Status:%String,datestr:%String,timestr:%String,LocDesc:%String,LocDR:%String,GetResDesc:%String,strRppDate:%String,strRppTime:%String,GetstrRegDate:%String,GetstrRegTime:%String,GetReportStatus:%String,GetRptDocName:%String,GetRptDate:%String,GetRptTime:%String,GetVerifyDocName:%String,GetVerifyDate:%String,GetVerifyTime:%String,AppType:%String,RRowid:%String,GetPatientStatusCode:%String,RejectAppReason:%String,PrintNo:%String,ServiceID:%String,Service:%String,AppMethod:%String")
{
}

ClassMethod GetServiceOrderExecute(ByRef qHandle As %Binary, EpisodeID As %String, LocDR As %String, CheckSend As %String) As %Status
{
 ///-------
 ///oooooooooo
 
 s ^TMPRIS111=EpisodeID_"^"_LocDR_"^"_CheckSend
 Set repid=$I(^CacheTemp)
 
 s UserID=%session.Get("LOGON.USERID")
 i UserID="" s UserID="71"
 k ^DHCRISAPPCOUNT(UserID)
 
 s ind=1
 s ret=0
 s PaAdmID=$p(EpisodeID,$C(0))
 s LocDR=$p(LocDR,$c(0))
 s strOrderName="",strRecLoc="",strStdate="",strAccessionNumber="",strExamOrder="",Wldr="",ModTypedr="",ModType=""
 s strDateCreated="",strTimeCreated="",strSeriesModality="",strOrderDate="",strOrderTime="",strCommon=""
 s CurOrderNo="",pointer1="",pointer2="",numb="",AppType="",RRowid=""
 s statuscheck="1"
 s ordrowid=0,itmsub=0,Maxitmsub="",DHCRisSystemInfo="",DHCRisVersion="",AppCount=0
 
 s DHCRisSystemInfo=##class(web.DHCRisCodeTableAdd).GetSystemParam()
 s DHCRisVersion=$p(DHCRisSystemInfo,"^",15)
 
 i PaAdmID'="" d
  .f  s ordrowid=$o(^OEORD(0,"Adm",PaAdmID,ordrowid)) q:(ordrowid="")  d
  ..s itmsub=0 f  s itmsub=$o(^OEORD(ordrowid,"I",itmsub)) q:(itmsub="")  d
  ...s GetPatientStatusCode="",GetReportStatusCode="",PrintNo=""
  ...s GetPatientStatus="",GetReportStatus="",GetResDesc="",strRppDate="",strRppTime="",RejectAppReason=""
  ...s GetstrRegDate="",GetstrRegTime="",GetRptDocName="",GetRptDate="",GetRptTime="",GetVerifyDocName="",GetVerifyDate="",GetVerifyTime=""
  ...s tmpItemStatus="",ItemCode="",ordInfo=""
  ...s arcimid=$p($g(^OEORD(ordrowid,"I",itmsub,1)),"^",2)
  ...q:(arcimid="")
  ...s ServerMaterial=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7)),"^",6)
  ...q:(ServerMaterial'="Service")&(ServerMaterial'="S")
  ...s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(ordrowid, itmsub)
  ...q:(ordInfo="")
  ...s AppointMethodId="",BPRowid="",AppMethod=""
  ...i arcimid'="" s BPRowid=$o(^DHCRBCItemBookProperTypei(arcimid,0))
  ...i BPRowid'="" s AppointMethodId=$p($g(^DHCRBCItemBookProperty(BPRowid)),"^",2) 
  ...i AppointMethodId'="" s AppMethod=$p($g(^DHCRBCAppointMethod(AppointMethodId)),"^",2)
  ...s ServiceInfo="",ServiceID="",Service=""
  ...s ServiceInfo=##class(web.DHCRisCommFunctionEx).GetServiceGroup(arcimid)
  ...s ServiceID=$p($g(ServiceInfo),"^",1)
  ...s Service=$p($g(ServiceInfo),"^",2)
  ...i (DHCRisVersion="BJ_XH") d
  ....s GetstrOrderName=$p(ordInfo,"^",1) //28
  ...e  d
  ....s GetstrOrderName=$p(ordInfo,"^",1)
  ...s GetstrDate=$p(ordInfo,"^",2)
  ...s GetstrTime=$p(ordInfo,"^",3)
  ...s SubCatDesc=$p(ordInfo,"^",7)
  ...q:SubCatDesc="门诊诊疗费"
  ...q:SubCatDesc="挂号费"
  ...s GetItemStatusCode=$p(ordInfo,"^",14)
  ...s GetServerMaterial=$p(ordInfo,"^",18)
  ...s RecLocDesc=$p(ordInfo,"^",21)
  ...s RecLocDR=$p(ordInfo,"^",19)
  ...s ItmCatDR=$p(ordInfo,"^",23)
  ...;q:(GetServerMaterial'="Service")&(GetServerMaterial'="S")
  ...q:(GetItemStatusCode'="V")&(GetItemStatusCode'="E")
  ...;获得申请单的使用样式
  ...;s AppCatDR=$O(^DHCRBCAppi("ItmCat",ItmCatDR,0))
  ...s AppType=""
  ...;i AppCatDR'="" s AppType=$p(^DHCRBCApp("ItmCat",AppCatDR),"^",2)
  ...s ExamOrder=ordrowid_"||"_itmsub
  ...s Info=..GetAppShape(ExamOrder)
  ...s AppType=$p(Info,"^",3)
  ...s RRowid="",bedone=""
  ...;s RRowid=$o(^DHCRBAppi("OrdRowid",ExamOrder,0))
  ...s RRowid=$o(^DHCRBAppOrdi(0,ExamOrder,0)) 
  ...s GetPatientStatusCode="",GetPatientStatus="",GetReportStatus=""
  ...i RRowid'="" d
  ....s GetPatientStatusCode="A"  ;申请
  ....i $d(^DHCRisPrintAppIndex(ExamOrder)) s PrintNo=$g(^DHCRisPrintAppIndex(ExamOrder))_"次"
  ....s GetRejDR=$o(^DHCRBRejecti("OeordDR",ExamOrder,0))
  ....i GetRejDR'="" d
  .....s GetPatientStatusCode="RJ"
  .....s RejectAppReason="拒绝原因" 
  .....;---------------------------------------;拒绝申请
  ....else  d
  .....;--------------------------------------- 显示预约信息
  .....i $g(^OEORD(ordrowid,"I",itmsub,6))'="" d
  ......s Getapprowid=$p(^OEORD(ordrowid,"I",itmsub,6),"^",5)
  ......i (Getapprowid'="")&(Getapprowid'=$C(0)) d
  .......s ResRowid=$p(Getapprowid,"||",1)
  .......s SchildSub=$p(Getapprowid,"||",2)
  .......s appointchildsub=$p(Getapprowid,"||",3)
  .......s ResDesc=""
  .......s CTCPDR=$p($g(^RB("RES",ResRowid)),"^",2)
  .......s CTCPDR=$p(CTCPDR,$c(0))
  .......i CTCPDR'="" d
  ........s GetResDesc=$p($g(^CTPCP(CTCPDR,1)),"^",2)
  .......else  d
  ........s EQDR=$p($g(^RB("RES",ResRowid)),"^",3)
  ........i EQDR'="" d 
  .........s GetResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
  .......s RppDate=$p($g(^RBAS(ResRowid,SchildSub)),"^",1)
  .......i RppDate'="" s strRppDate=$zd(RppDate,3)
  .......s RppTime=$p($g(^RBAS(ResRowid,SchildSub)),"^",4)
  .......i RppTime="" s strRppTime=$zt(RppTime,1)
  .......s GetPatientStatusCode="B"
  .....s BkInfo=""
  .....s BkInfo=##class(web.DHCRisResourceApptSchudleEx).RequestBookInfo(ExamOrder)
  .....i BkInfo'=""  s strRppDate=$p(BkInfo,"^",1) s strRppTime=$p(BkInfo,"^",2) s GetPatientStatusCode="B"
  .....;------------------------------------------ 显示登记信息
  .....s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfo(ExamOrder)
  .....s GetStudyNo=$p(RegInfo,"^",1)
  .....i GetStudyNo'="" d
  ......s GetPatientStatusCode="I"
  ......s GetstrRegDate=$p(RegInfo,"^",2)
  ......s GetstrRegTime=$p(RegInfo,"^",3)
  ......s GetImgcount=0
  ......s Imrowid=0 f  s Imrowid=$o(^DHCRBStudyi("StudyNo-Images",GetStudyNo,Imrowid)) q:Imrowid=""  d
  .......s GetPatientStatusCode="E"    ;正在检查
  .......s ExtName=$p($g(^DHCRBStudy(0,"StudyImages",Imrowid)),"^",2)
  .......i ((ExtName="avi")!(ExtName="dcm")!(ExtName="normal")!(ExtName="dsa"))  d
  ........s GetImgcount=GetImgcount+1
  ........s GetReportStatusCode="I"             ;图象已经采集
  ......s sReportStuatCode="VS"
  ......s Rptrowid=0  f  s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",GetStudyNo,Rptrowid)) q:Rptrowid=""  d
  .......s GetRptID=$p(^DHCRBStudy("Report",Rptrowid),"^",2)
  .......s GetRptVersion=$p(^DHCRBStudy("Report",Rptrowid),"^",3)
  .......s GetRptStatusDR=$p(^DHCRBStudy("Report",Rptrowid),"^",4)
  .......i GetRptStatusDR'="" d
  ........s GetReportStatusCode=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",1)
  ........i sReportStuatCode[GetReportStatusCode d
  .........s GetPatientStatusCode="O"
  ........e  d
  .........s GetPatientStatusCode="E"
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
  ...i (((CheckSend="")&(GetPatientStatusCode=""))!(GetPatientStatusCode="RJ")!(CheckSend="on")) d 
  ....i GetPatientStatusCode'="" s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
  ....i GetReportStatusCode'="" s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
  ....;s tmpItemStatus=##CLASS(web.DHCRisclinicQueryOEItemDo).GetOEOrdStatus(ordrowid,itmsub)
  ....;s GetPatientStatus=$p(tmpItemStatus,"^",1)
  ....;s ItemCode=$p(tmpItemStatus,"^",2)
  ....;i ItemCode="A" s GetPatientStatus=""
  ....;i ItemCode="E" s GetPatientStatus="正在申请"
  ....Do OutServiceOrder
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutServiceOrder
 if (CheckSend="on")!(CheckSend="") d
 .s AppCount=AppCount+1
 .s ^DHCRISAPPCOUNT(UserID)=AppCount
 set Data=$lb(ExamOrder,GetstrOrderName,GetPatientStatus,GetstrDate,GetstrTime,RecLocDesc,RecLocDR,GetResDesc,strRppDate,strRppTime, GetstrRegDate,GetstrRegTime,GetReportStatus,GetRptDocName,GetRptDate,GetRptTime,GetVerifyDocName,GetVerifyDate,GetVerifyTime,AppType,RRowid,GetPatientStatusCode,RejectAppReason,PrintNo,$g(ServiceID),$g(Service),$g(AppMethod))
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetServiceOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetServiceOrderExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod GetServiceOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetServiceOrderExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

// s bb=##class(web.DHCRisApplicationBill).GetAppItemInfo("57731||1");

Query GetGoal(OEorditemID As %String) As %Query(ROWSPEC = "goaldesc:%String,goalrowid:%String")
{
}

ClassMethod GetGoalExecute(ByRef qHandle As %Binary, OEorditemID As %String) As %Status
{
  Set repid=$I(^CacheTemp)
  s ind=1
  q:OEorditemID=""
  s ord=$p(OEorditemID,"||",1)
  s itm=$p(OEorditemID,"||",2)
  s paadmdr=$p(^OEORD(ord),"^",1)
  s OeItemMastDR=$p(^OEORD(ord,"I",itm,1),"^",2)
  s goalrowid=0,goaldesc=""
  /*f  s goalrowid=$o(^DHCRBAppi("Goal-orditem",OeItemMastDR,goalrowid)) q:(goalrowid="")  d
  .s goaldesc=$p($g(^DHCRBCApp("GLOBAL",goalrowid)),"^",2) 
  .Do OutGoal */
  f  s goalrowid=$o(^DHCRBAppi("Goal-Paadm",paadmdr,goalrowid)) q:(goalrowid="")  d
  .s goaldesc=$p($g(^DHCRBCApp("GLOBAL",goalrowid)),"^",2)
  .Do OutGoal
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutGoal
 set Data=$lb(goaldesc,goalrowid)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetGoalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGoalExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod GetGoalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGoalExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query Getillstr(paadmrowid As %String) As %Query(ROWSPEC = "illstr:%String,illstrrowid:%String,orderrowid:%String")
{
}

ClassMethod GetillstrExecute(ByRef qHandle As %Binary, paadmrowid As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 s ind=1
 s illstrrowid=0,illstr="",orderrowid="",admrowid=""
  f  s illstrrowid=$o(^DHCRBAppi("illstatu-roditem",paadmrowid,illstrrowid)) q:(illstrrowid="")  d
  .s admrowid=$p(^DHCRBCApp("IllStatus",illstrrowid),"^",1) 
  .s orderrowid=$p(^DHCRBCApp("IllStatus",illstrrowid),"^",2) 
  .s illstr=$p(^DHCRBCApp("IllStatus",illstrrowid),"^",3)
  .;w illstrrowid
  .D Outillstr 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
Outillstr
 set Data=$lb(illstr,illstrrowid,orderrowid)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetillstrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetillstrExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod GetillstrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetillstrExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

//s Info=..GetAppShape(oeorditemrowid)

ClassMethod GetAppShape(oeorditemrowid As %String) As %String
{
    s ComponentName="",PrintTemp="",AppSetrowid="",ShapeDR=""
    s oeorditemrowid=$p(oeorditemrowid,"@")
	if oeorditemrowid'=""  
	{
		s OrderRowid=$p(oeorditemrowid,"||",1)
		s paadmdr=$p(^OEORD(OrderRowid),"^",1)
		s paadmtype=$p(^PAADM(paadmdr),"^",2)
		s paadmreasondr=$p(^PAADM(paadmdr,1),"^",7)
		s Code=""
		i paadmreasondr'="" s Code=$p(^PAC("ADMREA",paadmreasondr),"^",1) 
		s itemsub=$p(oeorditemrowid,"||",2)
		s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
		s ItmCatDR=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",10)
		s OrdCatDr=$p(^ARC("IC",ItmCatDR),"^",8)
		; ^DHCRBCAppi("ItmMast",{DIMAS_ArcItem_DR},{DIMAS_Rowid})
		s AppItmrowid=$o(^DHCRBCAppi("ItmMast",arcimid,0))
		i AppItmrowid'="" d
		 .s ShapeDR=$p(^DHCRBCApp("ItmMast",AppItmrowid),"^",2)   
		else  d
		 .;^DHCRBCAppi("ItmCat",{DICAS_ItemCat_DR},{DICAS_Rowid}) 
		 .;^DHCRBCAppi("ItmCat",{DICAS_ItemCat_DR},{DICAS_Rowid})
		 .s AppCatrowid=$o(^DHCRBCAppi("ItmCat",ItmCatDR,0))
		 .i AppCatrowid '=""  d
		 ..s ShapeDR=$p(^DHCRBCApp("ItmCat",AppCatrowid),"^",2) 
		 .e  d
		 ..s AppBigCatRowid=$o(^DHCRBCAppi("OrdCat",OrdCatDr,0)) 
		 ..i AppBigCatRowid'="" d
		 ...s ShapeDR=$p(^DHCRBCApp("OrdCat",AppBigCatRowid),"^",2) 
    }
    s HtmlShape=""
    s SystemInfo=##class(web.DHCRisCommFunction).GetSystemParam()
    s DHCRisVersion=$p(SystemInfo,"^",15)
    
    i ShapeDR'="" d  
    .s ComponentName=$p(^DHCRBApp("Shape",ShapeDR),"^",2)
    .s PrintTemp=$p(^DHCRBApp("Shape",ShapeDR),"^",3)
    .i DHCRisVersion="BJ_JST"  d
    ..i Code="奥运运动员" d 
    ...s PrintTemp1=$p(PrintTemp,"~",2)
    ..else  if paadmtype="E"  d 
    ...s PrintTemp1=$p(PrintTemp,"~",3)
    ..else  d
    ...s PrintTemp1=$p(PrintTemp,"~",1) 
    ..i PrintTemp1="" s PrintTemp=$p(PrintTemp,"~",1)  
    ..else  s PrintTemp=PrintTemp1
    .s HtmlShape=$g(^DHCRBApp("Shape",ShapeDR,"html"))
    //在CACHE 查询的结果返回到前端，如果$c(13,10),就会中断，所以要把$c(13,10)用$c(1)替换
    s Num=$l(HtmlShape,$C(13,10))
	s strHtmlConent=""
	for I=1:1:Num d
	.s pHtmlConent=$p(HtmlShape,$C(13,10),I)
	.i strHtmlConent="" d
	..s strHtmlConent=pHtmlConent
	.else  d 
	..s strHtmlConent=strHtmlConent_$C(1)_pHtmlConent
    q ComponentName_"^"_PrintTemp_"^"_ShapeDR_"^"_strHtmlConent
}

/// 函数：SaveAppBill
/// 功能：保存状态
/// 参数：申请单内容，医嘱ID(多个用@分割),期望执行日期，用户ID
///      html浏览内容，选择字段内容，申请单打印内容，部位信息,
///      字段对应医嘱项目ID(用于生成新的医嘱,多条用@分割)
/// 2011-11-23 sunyi
ClassMethod SaveAppBill(XMLConent As %String(MaxLength=65536), OeOrditemID As %String, XDate As %String, UserID As %String, HtmlConent As %String, ItemInfo As %String, PrintParamInfo As %String = "", BodyInfo As %String = "", MutiArcItemMastId As %String = "", DoctorID As %String = "", Ungent As %String = "", AppUserID As %String = "")
{
	s $zt="SendMessageET"
	
	s AppRowid=""
	s xdate=$zdh(XDate,4)
	s FirstOrditem=$p(OeOrditemID,"@",1)
	//协和判断发送申请单如误操作插入床旁医嘱停止该医嘱
	//d ..StopItemExit(FirstOrditem)
	s AppRowid=$o(^DHCRBAppOrdi(0,FirstOrditem,0)) 
	s OEordRowid=$p(FirstOrditem,"||",1)
	s ChildSub=$p(FirstOrditem,"||",2)
	s AdmId=$p(^OEORD(OEordRowid),"^",1) 
	s arcimid=$p($g(^OEORD(OEordRowid,"I",ChildSub,1)),"^",2)
	i arcimid'="" d
	.s ItmCatRowid=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1)),"^",10)
	

	///更新备注信息 OEORI_Remarks
	if BodyInfo'="" d
	.s count=$g(^OEORD(OEordRowid,"I",ChildSub,"REM",0))
    .i (count="") 
    ..s count=1
    .else  d
    ..s count=count+1
    .s ^OEORD(OEordRowid,"I",ChildSub,"REM",0)=count
    .s ^OEORD(OEordRowid,"I",ChildSub,"REM",count)=BodyInfo
    
	s RecLocDR=$p(^OEORD(OEordRowid,"I",ChildSub,3),"^",6)  
	s date=+$h
	s time=$p($h,",",2)
	
	s strHtmlConent=""
	if (HtmlConent'="")
	{
		s len=$l(HtmlConent,$c(1))
		for i=1:1:len d
		.s perline=$p(HtmlConent,$c(1),i)
		.if strHtmlConent="" d 
		..s strHtmlConent=perline
		.else  d
		..s strHtmlConent=strHtmlConent_$c(13,10)_perline
	} 
	
	if (AppRowid="")
	{
		&sql(insert into DHCRB_ApplicationBill(DRA_OeItemID_DR, DRA_USER_DR,DRA_Date,DRA_Xdate, DRA_Time, DRA_LocID_DR,DRA_DoctorId,DRA_URGENCY) values ( :FirstOrditem,:UserID,:date,:xdate,:time,:RecLocDR,:DoctorID,:Ungent))
		q:SQLCODE SQLCODE
		s rowid=$p(%ROWID,$c(1))
		s ^DHCRBApp("Bill",rowid,"XMLContent")=XMLConent
		s ^DHCRBApp("Bill",rowid,"html")=strHtmlConent
		s ^DHCRBApp("Bill",rowid,"ItemInfo")=ItemInfo
		s ^DHCRBApp("Bill",rowid,"PrintParam")=PrintParamInfo
	
		
		s nums=$l(OeOrditemID,"@")
		for i=1:1:nums  d
		.s perOEOrdItemID=$p(OeOrditemID,"@",i)
        .&sql(insert into DHCRB_ApplicationBill_OrdItem (DAO_ParRef,DAO_OrdItem_DR) values (:rowid,:perOEOrdItemID))
	}
	else
	{
		&sql(update DHCRB_ApplicationBill(DRA_OeItemID_DR, DRA_USER_DR,DRA_Date,DRA_Xdate, DRA_Time,DRA_LocID_DR,DRA_DoctorId,DRA_URGENCY) values ( :FirstOrditem,:UserID,:date,:xdate,:time,:RecLocDR,:DoctorID,:Ungent) where DRA_RowID=:AppRowid )
		s ^DHCRBApp("Bill",AppRowid,"XMLContent")=XMLConent
		s ^DHCRBApp("Bill",AppRowid,"html")=strHtmlConent
		s ^DHCRBApp("Bill",AppRowid,"ItemInfo")=ItemInfo
		s ^DHCRBApp("Bill",AppRowid,"PrintParam")=PrintParamInfo
		
		&sql(delete from DHCRB_ApplicationBill_OrdItem where DAO_ParRef=:AppRowid)
		
	   s nums=$l(OeOrditemID,"@")
	   for i=1:1:nums  d
	   .s perOEOrdItemID=$p(OeOrditemID,"@",i)
       .&sql(insert into DHCRB_ApplicationBill_OrdItem (DAO_ParRef,DAO_OrdItem_DR) values (:AppRowid,:perOEOrdItemID))
	}
	
   ///根据字段对应的医嘱项目的ROWID,ARCITEMMAST ROWID ,插入医嘱
   if MutiArcItemMastId '="" d
   .s count=$l(MutiArcItemMastId,"@")
   .s Orditmstr=""
   .f i=1:1:count d
   ..s ArcItemRowid=$p(MutiArcItemMastId,"@",i)
   ..;i (ArcItemRowid="22145||1")!(ArcItemRowid="14634||1") d 
   ...;s ret=..Insert(FirstOrditem, ArcItemRowid)
   ..e  d
   ...i Orditmstr="" d
   ....s Orditmstr=ArcItemRowid_$c(2)_"1"
   ...else  d
   ....s Orditmstr=Orditmstr_$c(1)_ArcItemRowid_$c(2)_"1"
   ...s ret=##class(web.DHCOEOrdItem).InsertContinuousOrder(AdmId, UserID, Orditmstr)
   
   /*i ItmCatRowid="35" d
   .s SetArcItemRowid="",val=""  //要插入的医嘱项目ID
   .s val=..InsertTeXu(AdmId,FirstOrditem,SetArcItemRowid)*/
   
   /*i ItmCatRowid="235" d    ; ---test
   .s SetArcItemRowid="11150||1",val=""  //要插入的医嘱项目ID
   .s val=..InsertTeXu(AdmId,FirstOrditem,SetArcItemRowid)*/
	
    ///---------------------------以下是接口的调用部分
	s paadmdr=$p(^OEORD(OEordRowid),"^",1)
    s paadmtype=$p(^PAADM(paadmdr),"^",2)
      
    s stay=""
    s stay =##class(web.DHCADMVisitStat).GetPatCurStat(paadmdr)
	i stay'="" s stay=$zcvt($p($g(stay),"^",1),"U")
	
	s BookedFlag=""
	s BookedFlag=..IsAutoBooked(FirstOrditem) 
	s ^dhcrisTmp("BookedFlag") = BookedFlag_";"_OeOrditemID
	if (BookedFlag'="Y")
	{
	    do ##class(web.DHCRisSendToRis4Set).SendApptoRis4(OeOrditemID, XMLConent)
	}
	/*else
	{
		s DetailRowid="",CancelFlag=""
		s DetailRowid=$o(^DHCRBCResSchduleDetaili(0,FirstOrditem,0))
		i DetailRowid'="" s CancelFlag=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",7)
		
		if ((DetailRowid="")!(CancelFlag="Cancel"))
		{
			//s ret=##class(web.DHCRisBookParam).AutoBooked(FirstOrditem,+$h,$p($h,",",2),"")
			s ret=##class(web.DHCRisBookCommFunction).AutoBooked(FirstOrditem,+$h,$p($h,",",2),"",AppUserID,"","")
		}
	}*/
	

    //申请单消息直接发到集成平台HIS端接口
    i ((paadmtype="I")!((paadmtype="E")&((stay="STAY")!(stay="SALVAGE"))))
    {
   		s SendOrdRowid=""
   		s nums=$l(OeOrditemID,"@")
   		for i=1:1:nums  d
   		.s perOEOrdItemID=$p(OeOrditemID,"@",i)
   		.i SendOrdRowid="" s SendOrdRowid=perOEOrdItemID
   		.e  s SendOrdRowid=SendOrdRowid_"^"_perOEOrdItemID 
   		s ret=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDRISAPPBILLINFO",SendOrdRowid)
    }
   
    /*i ((paadmtype="I")&($g(^DHCRisIPSendMessage)="Y")) d      ; 对于住院病人发送HL7消息
	.d ..SendHL7Message(FirstOrditem)*/
	
	q SQLCODE
	
SendMessageET
    tro
    q -1
}

// 函数 GetAppBill:  获得申请单的内容

// 参数 OeOrditemID：格式: 医嘱ID@医嘱ID1@医嘱ID2

// 返回：申请单的内容

// do ##class(web.DHCRisApplicationBill).GetAppBill("3864||4@3864||6")

ClassMethod GetAppBill(OeOrditemID)
{
	
	s XMLConent="",strDate="",LocDR="",strTime="",UserDR="",strXDate="",XMLContent=""
	s strXMLConent=""
	;s AppRowid=$o(^DHCRBAppi("OrdRowid",OeOrditemID,0))
	;;/////////////////////////
	s AppRowid=""
	s Nums=$l(OeOrditemID,"@")
	for i=1:1:Nums d
	.s perOrditemID=$p(OeOrditemID,"@",i)
	.s AppRowid=$o(^DHCRBAppOrdi(0,perOrditemID,0))
	.q:AppRowid="" 
	;s AppRowid=$o(^DHCRBAppOrdi(0,OeOrditemID,0)) 
	if AppRowid'="" d
	.s Date=$p($g(^DHCRBApp("Bill",AppRowid)),"^",1)
	.s strDate=$zd(Date,3)
	.s LocDR=$p($g(^DHCRBApp("Bill",AppRowid)),"^",4)
	.s oeorditemdr=$p($g(^DHCRBApp("Bill",AppRowid)),"^",6)
	.s Time=$p($g(^DHCRBApp("Bill",AppRowid)),"^",8)
	.i Time'="" s strTime=$zt(Time,3)
	.s UserDR=$p($g(^DHCRBApp("Bill",AppRowid)),"^",9)
	.s XDate=$p($g(^DHCRBApp("Bill",AppRowid)),"^",10)
	.i XDate'="" s strXDate=$zd(XDate,3)
	.s XMLContent=$g(^DHCRBApp("Bill",AppRowid,"XMLContent"))
	.s Num=$l(XMLContent,$C(13,10))
	.s strXMLConent=""
	.for I=1:1:Num d
	..s pXMLConent=$p(XMLContent,$C(13,10),I)
	..i strXMLConent="" d
	...s strXMLConent=pXMLConent
	..else  d 
	...s strXMLConent=strXMLConent_$C(1)_pXMLConent
	s GetValue=strXMLConent_$c(2)_strDate_$c(2)_strTime_$c(2)_UserDR_$c(2)_strXDate
	q GetValue
}

/// s ret=##class(web.DHCRisApplicationBill).SaveGlobal(^tmp111,^tmp11)
ClassMethod SaveGlobal(Oeorditemrowid1, GlobalDesc)
{
	s Oeorditemrowid=$p(Oeorditemrowid1,"@",1)
	s OrderRowid=$p(Oeorditemrowid,"||",1)
	s itemsub=$p(Oeorditemrowid,"||",2)
	s paadmdr=$p($g(^OEORD(OrderRowid)),"^",1)
	s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	&sql(insert into DHCRBC_Goal (DRG_ArcItmMast_DR,DRG_GoalDesc,DRG_PAADM_DR) values(:arcimid,:GlobalDesc,:paadmdr))
	q SQLCODE
}

//s bb=##class(web.DHCRisApplicationBill).GetGlobal("57770||2^57770||3")

ClassMethod GetGlobal(Oeorditemrowid) As %String
{
	s (rowid,GlobDesc,DHCRisSystemInfo,DHCRisVersion)=""
	
	s OrderRowid=$p(Oeorditemrowid,"||",1)
	s itemsub=$p(Oeorditemrowid,"||",2)
	s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2) 
	s DHCRisSystemInfo=##class(web.DHCRisCodeTableAdd).GetSystemParam()
    s DHCRisVersion=$p(DHCRisSystemInfo,"^",15)
    i (DHCRisVersion="BJ_XH")
    {
	   s GlobDesc=$g(^OEORD(OrderRowid,"I",itemsub,"DEP",1))
	}
	else
	{         
		s rowid=$o(^DHCRBAppi("Goal-orditem",arcimid,0)) 
		s price=##class(web.DHCRisCommFunction).GetItemPrice(Oeorditemrowid)
		s Num=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",12)
    
		s TotalPrice=price*Num
		i TotalPrice="" s TotalPrice=0
		s TotalPrice=TotalPrice_"元"
		if (rowid'="")
		{
			s GlobDesc=$p($g(^DHCRBCApp("GLOBAL",rowid)),"^",2)
			s GlobDesc=GlobDesc_"(总价"_TotalPrice_")"
		}
		else  
		{
			//医嘱名称作为检查目的		 
			s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
			s GlobDesc=strOrderName_"(总价"_TotalPrice_")"
		}
		
    }
    
	q GlobDesc
}

/*ClassMethod SaveCurrentStatus(Oeorditemrowid, paadmdr, CurrentStatus) As %String
{
    n (Oeorditemrowid, paadmdr, CurrentStatus)
    s ^DHCRis("Temp11")=Oeorditemrowid_"^"_paadmdr_"^"_CurrentStatus
    s rowid=""
 	&sql(select DIS_Rowid into :rowid from DHCRBC_IllStatus where DIS_Oeorditem_DR =:Oeorditemrowid and DIS_PaAdm_DR=:paadmdr)
	if (rowid="") d
	 .&sql(insert into DHCRBC_IllStatus(DIS_PaAdm_DR,DIS_Oeorditem_DR, DIS_IllStatus)values(:paadmdr,:Oeorditemrowid,:CurrentStatus))
	else  d
	.&sql(update DHCRBC_IllStatus (DIS_PaAdm_DR,DIS_Oeorditem_DR, DIS_IllStatus)values(:paadmdr,:Oeorditemrowid,:CurrentStatus) where DIS_Rowid=:rowid)
	q SQLCODE
}*/
ClassMethod SaveCurrentStatus(Oeorditemrowid, paadmdr, CurrentStatus As %String = "") As %String
{
    n (Oeorditemrowid, paadmdr, CurrentStatus)
    s SQLCODE=0,ret=0
    s ^DHCRis("Temp11")=Oeorditemrowid_"^"_paadmdr_"^"_CurrentStatus
    s rowid=""
 	&sql(select DIS_Rowid into :rowid from DHCRBC_IllStatus where DIS_Oeorditem_DR =:Oeorditemrowid and DIS_PaAdm_DR=:paadmdr)
	if (rowid="") d
	 .&sql(insert into DHCRBC_IllStatus(DIS_PaAdm_DR,DIS_Oeorditem_DR)values(:paadmdr,:Oeorditemrowid))
	 .s srowid=$p(%ROWID,$c(1))
     .i srowid'="" d
     ..s ^DHCRBCApp("IllStatus",srowid,"Desc")=CurrentStatus
	else  d
	.&sql(update DHCRBC_IllStatus (DIS_PaAdm_DR,DIS_Oeorditem_DR)values(:paadmdr,:Oeorditemrowid) where DIS_Rowid=:rowid)
	.s srowid=$p($g(%ROWID),$c(1))
    .i srowid'="" d
    ..s ^DHCRBCApp("IllStatus",srowid,"Desc")=CurrentStatus
	q SQLCODE
}

ClassMethod Save(ID As %String) As %String
{
	if $IsObject(%request.Get("PatientNow")){
		#dim obj as %CSP.CharacterStream
		set obj = %request.Get("PatientNow")
		set j=0
		while('obj.AtEnd){
			set j=j+1
			set ^DHCRBCApp("IllStatus",ID,"Desc",j)=obj.Read()
		}
		do obj.%Close()
		set obj = ""
	}else{
		s ^DHCRBCApp("IllStatus",ID,"Desc",j)=%request.Get("PatientNow")
	}
	q 0
}

ClassMethod GetCurrentStatus(paadmdr)
{
   s rowid="",Desc="",Desc0=""
   s rowid=$o(^DHCRBAppi("illstatu-roditem",paadmdr,""),-1)
   if (rowid'="")
   {
      ;s Desc=$p($g(^DHCRBCApp("IllStatus",rowid)),"^",3)
       s Desc=$g(^DHCRBCApp("IllStatus",rowid,"Desc"))
       q Desc
   }
  
   s SystemInfo=##class(web.DHCRisCommFunction).GetSystemParam()
   s DHCRisVersion=$p(SystemInfo,"^",15)
  
   if DHCRisVersion="BJ_DT" d
   .s eleCode="体格检查.体格检查#TYPE:Segment#TID:78#TVER:0#GCODE:G0001"
   .s eleCode1="一般项目主诉.主  诉#TYPE:TextDesc#TID:76#TVER:0#ECODE:E0055"
   .s eleCode2="一般项目主诉.主  诉#TYPE:TextDesc#TID:76#TVER:0#ECODE:E0055"
   .s eleCode3="一般情况主诉病史(妇科).主  诉#TYPE:TextDesc#TID:236#TVER:0#ECODE:E0055"
   .s eleCode4="一般项目主诉.主  诉#TYPE:TextDesc#TID:658#TVER:0#ECODE:E0055"
   .s eleCode5="体格检查.体格检查#TYPE:Segment#TID:533#TVER:0#GCODE:G0001"
   .s eleCode6="一般项目主诉.科  别#TYPE:Simple#TID:658#TVER:0#SCODE:I0029#VTYPE:V"
   .s Desc=##class(web.DHCRisCommFunctionEx).GetEPRV2Element(paadmdr, "658", "E0055")
   .s Desc1=##class(web.DHCRisCommFunctionEx).GetEPRV2Element(paadmdr, "533", "G0001")
   .i (Desc="")&(Desc1="") d
   ..s Desc=##class(web.DHCRisCommFunctionEx).GetEPRV2Element(paadmdr, eleCode2, 0)
   ..s Desc1=##class(web.DHCRisCommFunctionEx).GetEPRV2Element(paadmdr, eleCode3, 0)
   .s Desc2=Desc_$C(10)_$C(13)_Desc1
   .s Desc=Desc2
   else  d
   .s Desc1=##class(EPRservice.HISInterface.PatientInfoAssist).MainAccount(paadmdr)
   .s Desc2=##class(EPRservice.HISInterface.PatientInfoAssist).PatHistory(paadmdr)
   .s Desc3=##class(EPRservice.HISInterface.PatientInfoAssist).RecordSummary(paadmdr)
   .s Desc=Desc1_$C(10)_$C(13)_Desc2_$C(10)_$C(13)_Desc3
   .;if Desc="" d
   ..;s Desc=##class(web.DHCRisApplicationBill).GetMedicalRecord(paadmdr)
   q Desc
}

/// 函数 DelAppBill 删除申请单
/// 时间 2012-07-11
/// 参数  MutiOeorditemrowid  多条医嘱用@
/// do ##class(web.DHCRisApplicationBill).DelAppBill("20017||3878")
ClassMethod DelAppBill(MutiOeorditemrowid As %String) As %String
{
	s ^SY=MutiOeorditemrowid
	s MyDelete=0,SQLCODE=-1
    s OEOrdItemID=$p(MutiOeorditemrowid,"@",1)
    s MyDelete=..DeleteApp(OEOrdItemID)
   
    i MyDelete=1 d
    .s RRowid=$o(^DHCRBAppOrdi(0,OEOrdItemID,0))
    .&sql(delete from DHCRB_ApplicationBill_OrdItem where DAO_ParRef=:RRowid)
    .&sql(delete from DHCRB_ApplicationBill where DRA_Rowid=:RRowid )
    
    do ##class(web.DHCRisSendToRis4Set).DelApptoRis4(MutiOeorditemrowid)
    
	q SQLCODE
}

/// d ##class(%ResultSet).RunQuery("web.DHCRisApplicationBill","GetAppShapeField","2")
Query GetAppShapeField(AppRowID As %String) As %Query(ROWSPEC = "ItemDesc:%String,Content:%String,Option:%String,ItemType:%String,Require:%String,FieldDR:%String,iRows:%String,ItemMastId:%String,ValueContent:%String")
{
}

ClassMethod GetAppShapeFieldExecute(ByRef qHandle As %Binary, AppRowID As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 s ind=1
 ;s AppRowID=1
 
 s ChildSub=0
 s Index=0 f  s Index=$o(^DHCRBCAppSFi("FieldIndex",AppRowID,Index)) q:Index=""  d
 .s ChildSub=$o(^DHCRBCAppSFi("FieldIndex",AppRowID,Index,""),-1)
 .s FieldDR=$p(^DHCRBCAppSF("ShapeField",0,AppRowID,ChildSub),"^",1)    
 .s ItemMastId=$p(^DHCRBCAppSF("ShapeField",0,AppRowID,ChildSub),"^",2) //对应医嘱项目
 .q:FieldDR=""
 .i $g(^DHCRBApp("Field",FieldDR))'="" d
 ..s ItemDesc=$p($g(^DHCRBApp("Field",FieldDR)),"^",1)                 // 字段描述
 ..s ItemType=$p($g(^DHCRBApp("Field",FieldDR)),"^",2)                 // 字段类型，TEXTBOX,LISTBOX,CHECKBOX
 ..s Content=$p($g(^DHCRBApp("Field",FieldDR)),"^",3)                  //  字段内容
 ..s Option=$p($g(^DHCRBApp("Field",FieldDR)),"^",4)                   
 ..s Require=$p($g(^DHCRBApp("Field",FieldDR)),"^",5)                 // 字段是否是必填项目
 ..;s ValueContent=##class(web.DHCRisApplicationBill).GetValueContent(FieldDR)
 ..s ValueContent=""
 ..s Rowid=0  f  s Rowid=$o(^DHCRBAppi("FieldContent",FieldDR,Rowid)) q:Rowid=""  d
 ...s Value=$p(^DHCRBApp("FieldContent",Rowid),"^",2) 
 ...s Code=$p(^DHCRBApp("FieldContent",Rowid),"^",4)
 ...i ValueContent="" s ValueContent=Value
 ...else  s ValueContent=ValueContent_"&"_Value
 ..d OutField
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutField
 set Data=$lb(ItemDesc,Content,Option,ItemType,Require,FieldDR,ind,ItemMastId,ValueContent)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetAppShapeFieldFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAppShapeFieldExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod GetAppShapeFieldClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAppShapeFieldExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod SetAppItemData() As %String
{
	Set itmName="Content_"_rs.GetDataByName("iRows")
    Set DataType=rs.GetDataByName("ItemType")
	Set Val=rs.GetDataByName("Content")
	Set Requre=rs.GetDataByName("Require")
	Set FieldDR=rs.GetDataByName("FieldDR")
	Set Option=rs.GetDataByName("Option")
	Set PaadmDR=$g(%request.Data("EpisodeID",1))
	

	if (Option="default")
	{
		i ((PaadmDR'="")&(FieldDR'="")) d
		.s Rowid=$o(^DHCRBCSAFi("APPFILED-ID",PaadmDR,FieldDR,0))
		.i Rowid'="" d
		..s Val=$p($g(^DHCRBCSAF("SAVE-APPFIELD",Rowid)),"^",4)
	}  
	
    s Active="1"
    s Active=$s(Active="1":"",1:"disabled")
    
  
    i DataType="ListBox" d
    .Write "<select id='"_itmName_"' name='"_itmName_"' size=1 "_Active_" style='WIDTH: 200px; HEIGHT: 24px'>"
	.; 可以使空字段
	.i Requre'="1" Write "<option  value=''></option>"
	.s temp=##class(web.DHCRisApplicationBill).GetValueContent(FieldDR)
	.f Index=1:1:($l(temp,$c(1))) d
	..s s=$p(temp,$c(1),Index)
	..s Content=$p(s,"^",1)
	..If Content=Val Write "<option value="_Content_" selected>"_Content_"</option>"
	..Else  Write "<option value="_Content_">"_Content_"</option>"
	.Write "</select>"
	.i Requre="1" d
	..Write "<IMG id='i"_itmName_"' name='i"_itmName_"'  src='../images/websys/Required.gif'>"
    e  i DataType="TextBox" d
    .Write "<input id='"_itmName_"' name='"_itmName_"' "_Active
	.Write " style='WIDTH: 104px; HEIGHT: 24px' value='"_Val_"'>"
	.i Requre="1" d
	..Write "<IMG id='i"_itmName_"' name='i"_itmName_"'  src='../images/websys/Required.gif'>"
    e  i DataType="CheckBox" d
    .Write "<input id='"_itmName_"' name='"_itmName_"' "_Active
    .Write " style='WIDTH: 25px; HEIGHT: 25px' type='CheckBox' value='ON'>"
    .i Requre="1" d
    ..Write "<IMG id='i"_itmName_"' name='i"_itmName_"'  src='../images/websys/Required.gif'>"
    else  d
    .Write "<input id='"_itmName_"' name='"_itmName_"' "_Active
	.Write " style='WIDTH: 104px; HEIGHT: 24px' value='"_Val_"'>"
 	q ""
}

ClassMethod GetValueContent(FieldDR As %String) As %String
{
	 s RetInfo=""
	 s Rowid=0  f  s Rowid=$o(^DHCRBAppi("FieldContent",FieldDR,Rowid)) q:Rowid=""  d
	 .s Value=$p(^DHCRBApp("FieldContent",Rowid),"^",2) 
	 .s Code=$p(^DHCRBApp("FieldContent",Rowid),"^",4)
	 .i RetInfo="" s RetInfo=Value_"^"_Code
	 .else  s RetInfo=RetInfo_$c(1)_Value_"^"_Code
	 q RetInfo
}

Query QueryAppTemplList(FieldTag As %String, LocID As %String, UserID As %String) As %Query(ROWSPEC = "TemplName:%String,Content:%String,DocName:%String,Rowid:%String")
{
}

ClassMethod QueryAppTemplListExecute(ByRef qHandle As %Binary, FieldTag As %String, LocID As %String, UserID As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 s ind=1
 s ^tmpgppppp=FieldTag_"^"_LocID_"^"_UserID
 s rowid=0 f  s rowid=$o(^DHCRBCAppi("Loc-Template",LocID,rowid) ) q:(rowid="")  d
 .s GetFieldTag=$p(^DHCRBCApp("Template",rowid),"^",3)
 .q:FieldTag'=GetFieldTag
 .s GetUserID=$p(^DHCRBCApp("Template",rowid),"^",5)
 .q:(UserID'="")&(UserID'=GetUserID) 
 .s Name=$p(^DHCRBCApp("Template",rowid),"^",4)
 .s Content=^DHCRBCApp("Template",rowid,"Content")
 .s UserDesc=""
 .i GetUserID'="" s UserDesc=$p(^SSU("SSUSR",GetUserID),"^",2)
 .d OutTempl
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutTempl
 set Data=$lb(Name,Content,UserDesc,rowid)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QueryAppTemplListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAppTemplListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryAppTemplListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAppTemplListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod SaveStatusTemplate(Desc, Content, UsrID, LocID, FieldTag)
{
	//&sql(select DAST_RowID into :Rowid from  DHCRBC_ApplicationTempl where 
  &sql(insert into DHCRBC_ApplicationTempl (DSAT_User_DR,DAST_TemplName,DAST_FieldTag,DAST_Content,DAST_AppLoc_DR) values(:UsrID,:Desc,:FieldTag,:Content,:LocID))
  q SQLCODE
}

ClassMethod IsSameApplication(OrditemRowid)
{
	s PreApprowid="",IsSame=1	
	s nums=$l(OrditemRowid,"^")
    s OEOrdItemID=$p(OrditemRowid,"^",1)
	s PreRRowid=$o(^DHCRBAppOrdi(0,OEOrdItemID,0))
	for i=2:1:nums  d
    .s perOEOrdItemID=$p(OrditemRowid,"^",i)
	.s RRowid=$o(^DHCRBAppOrdi(0,perOEOrdItemID,0))
	.i PreRRowid'=RRowid  s IsSame=0
    q IsSame
}

//d ##class(web.DHCRisApplicationBill).DeleteApp("26801||8")

ClassMethod DeleteApp(OrditemRowid)
{
	  s MayDeleteApp=0
	  s OEOrdItemID=$p(OrditemRowid,"^",1)
	  s ordrowid=$p(OEOrdItemID,"||",1)
	  s itmsub=$p(OEOrdItemID,"||",2)
	  
	  s RRowid=$o(^DHCRBAppOrdi(0,OEOrdItemID,0)) 
	  if RRowid'="" d
	  .s MayDeleteApp=1
	 
	  i $g(^OEORD(ordrowid,"I",itmsub,6))'="" d
      .s Getapprowid=$p($g(^OEORD(ordrowid,"I",itmsub,6)),"^",5)
      .i Getapprowid'="" s MayDeleteApp=0
      s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfo(OEOrdItemID)
      s GetStudyNo=$p($g(RegInfo),"^",1)
      i GetStudyNo'=""  s MayDeleteApp=0
      q MayDeleteApp
}

ClassMethod DeleteAppTempList(Rowid As %String)
{
	&sql(delete from DHCRBC_ApplicationTempl where DAST_RowID=:Rowid)
	q SQLCODE
}

/// w ##class(web.DHCRisApplicationBill).GetHtmlAppBill("20017||3873")
ClassMethod GetHtmlAppBill(OeOrditemID)
{
	s htmlConent="",strhtmlConent=""
	if OeOrditemID'="" 
	{
	s AppRowid=$o(^DHCRBAppOrdi(0,OeOrditemID,0)) 
	if AppRowid'="" d
	.s htmlConent=$g(^DHCRBApp("Bill",AppRowid,"html"))
	.s Num=$l(htmlConent,$C(13,10))
	.for I=1:1:Num d
	..s phtmlConent=$p(htmlConent,$C(13,10),I)
	..i strhtmlConent="" d
	...s strhtmlConent=phtmlConent
	..else  d 
	...s strhtmlConent=strhtmlConent_""_phtmlConent
	
	.s strtmphtmlConent=strhtmlConent
	.s strhtmlConent=""
	.s Num=$l(strtmphtmlConent,$C(0))
	.for I=1:1:Num d
	..s phtmlConent=$p(strtmphtmlConent,$C(0),I)
	..i strhtmlConent="" d
	...s strhtmlConent=phtmlConent
	..else  d 
	...s strhtmlConent=strhtmlConent_""_phtmlConent
	}
	q strhtmlConent
}

/// /函数 SaveFieldValue
/// /功能：保存申请单字段的值，便于查询和统计
/// /作者：龚平
/// /说明：保存申请单字段的时候保存所有的字段的值
/// web.DHCRisApplicationBill.SaveFieldValue
ClassMethod SaveFieldValue(OEordItemID, FieldName, Desciption, Value, type)
{
	s FRowid=""
	s FRowid=$o(^DHCRBCAppi("FieldName",FieldName,0))
	i FRowid="" d
	.&sql(insert into DHCRBC_StaticAppBillField(DSBF_Name,DSBF_Type,DSBF_Description)values(:FieldName,:type,:Desciption))
	s FindName=0   
    s Rowid=0 f  s Rowid=$o(^DHCRBAppi("Orditem",OEordItemID,Rowid)) q:Rowid=""  d
    .s Name=$p(^DHCRBApp("FieldValue",Rowid),"^",1)
    .i Name=FieldName  d
    ..s FindName=1
    ..&sql(update DHCRB_StaticAppBillFieldValue(DSFV_Value)values(:Value) where DSFV_OEOrditem_DR=:OEordItemID and DSFV_Name=:FieldName)
    if FindName=0  d
    .&sql(insert into DHCRB_StaticAppBillFieldValue (DSFV_Value,DSFV_OEOrditem_DR,DSFV_Name) values (:Value,:OEordItemID,:FieldName))
	q SQLCODE
}

ClassMethod saveUltrasonic(OEorditemIDvalue, list)
{
	k ^RisRecord("Ultrasonic",OEorditemIDvalue)
	s ^RisRecord("Ultrasonic",OEorditemIDvalue)=list
	q
}

ClassMethod savect(OEorditemIDvalue, list)
{
	k ^RisRecord("CT",OEorditemIDvalue)
	s ^RisRecord("CT",OEorditemIDvalue)=list
	q
}

/// /保存主诉病史  --------------肿瘤医院需求
/// / d ##class(web.DHCRisApplicationBill).SaveMedicalRecord("137641","eeeeeeeeeee")
ClassMethod SaveMedicalRecord(paadmdr, Desc)
{
	&sql(select DIS_Rowid into :rowid from DHCRBC_IllStatus where DIS_Oeorditem_DR ="" and DIS_PaAdm_DR=:paadmdr)
	if (rowid="") d
	 .&sql(insert into DHCRBC_IllStatus(DIS_PaAdm_DR,DIS_Oeorditem_DR)values(:paadmdr,""))
	 .s rowid=%ROWID
	 .s ^DHCRBCApp("IllStatus",rowid,"MRD")=Desc
	else  d
	.s ^DHCRBCApp("IllStatus",rowid,"MRD")=Desc
	.;&sql(update DHCRBC_IllStatus (DIS_PaAdm_DR,DIS_MedicalRecord)values(:paadmdr,:Desc) where DIS_Rowid=:rowid)
	q SQLCODE
}

ClassMethod GetMedicalRecord(paadmdr) As %String
{
	s rowid="",desc=""
	&sql(select DIS_rowid into :rowid from DHCRBC_IllStatus where DIS_PaAdm_DR=:paadmdr and DIS_Oeorditem_DR="")
	if rowid'="" d
	 .s desc=$g(^DHCRBCApp("IllStatus",rowid,"MRD"))
	q desc
}

ClassMethod GetAppItemInfo(OeOrditemID As %String) As %String
{
	s ItemConent="",AppRowid=""
	s AppRowid=$o(^DHCRBAppOrdi(0,OeOrditemID,0)) 
	if AppRowid'="" d
	.s ItemConent=$g(^DHCRBApp("Bill",AppRowid,"ItemInfo"))
	q ItemConent
}

ClassMethod GetAppInfo(OeOrditemID As %String) As %String
{
	q:OeOrditemID="" "^^^"
	s Ordrowid=$p(OeOrditemID,"||",1)
	s paadmdr=$p(^OEORD(Ordrowid),"^",1) 
	s Diagnose=##class(web.DHCRisCommFunctionEx).GetDiagnose(paadmdr) //
	s Current=..GetCurrentStatus(paadmdr)
	s Global=..GetGlobal(OeOrditemID)
	s ItemInfo=..GetAppItemInfo(OeOrditemID)
	s ItemInfo=$tr(ItemInfo,$c(2)," ")
	s ItemInfo=$tr(ItemInfo,"^" ,"     ")
	s ItemInfo=$tr(ItemInfo,"true" ,"Y")
	s ItemInfo=$tr(ItemInfo,"false" ,"N")
	s Info=Diagnose_"^"_Current_"^"_ItemInfo_"^"_Global
	q Info
}

//查询 QueryPrintFieldItemInfo

//功能 查询申请单字段内容，为打印使用

//

//d ##class(%ResultSet).RunQuery("web.DHCRisApplicationBill","QueryPrintFieldItemInfo","67229||4")

Query QueryPrintFieldItemInfo(OEorditemID As %String) As %Query(ROWSPEC = "ItemDesc:%String")
{
}

ClassMethod QueryPrintFieldItemInfoExecute(ByRef qHandle As %Binary, OEorditemID As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 s ind=1

 s ItemInfo=..GetAppItemInfo(OEorditemID)
 s ItemInfo=$tr(ItemInfo,$c(2)," ")
 s ItemInfo=$tr(ItemInfo,"^" ,"     ")
 s ItemInfo=$tr(ItemInfo,"true" ,"Y")
 s ItemInfo=$tr(ItemInfo,"false" ,"N")
 d OutPrintField
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutPrintField
 set Data=$lb(ItemInfo)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

//SG_YB

ClassMethod QueryPrintFieldItemInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPrintFieldItemInfoExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryPrintFieldItemInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPrintFieldItemInfoExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

//d ##class(web.DHCRisApplicationBill).GetOrdName("57770||3^57770||2")

ClassMethod GetOrdName(Oeorditemrowid As %String) As %String
{
	n (Oeorditemrowid)
	s (strOrderName,perOrdOrderName,perOeOrditemRowid)=""
	s Nums=$l(Oeorditemrowid,"@")
	for i=1:1:Nums d
	.s perOeOrditemRowid=$p(Oeorditemrowid,"@",i)
	.s OrderRowid=$p(perOeOrditemRowid,"||",1)
	.s itemsub=$p(perOeOrditemRowid,"||",2)
	.s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
	.//医嘱名称作为检查目的		 
	.s perOrdOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	.i strOrderName="" s strOrderName=perOrdOrderName
	.else  s strOrderName=strOrderName_","_perOrdOrderName
 	q strOrderName
}

ClassMethod IsOEOrdItemNeedRequest(OEOrdItemIDs As %String) As %String
{
	//1402||1*440947||51*V^879||1*440947||52*V^
	;s ^yh("IsOEOrdItemNeedRequest","OEOrdItemIDs")=OEOrdItemIDs
	s retcode="0"
	//医嘱项、医嘱大类、医嘱子类有申请单定义则设置retcode="1"
	for i=1:1:$Length(OEOrdItemIDs,"^")-1
	{
		s arcimid=$p($p(OEOrdItemIDs,"^",i),"*",1)
		s ItmCatDR=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",10)
		s OrdCatDr=$p(^ARC("IC",ItmCatDR),"^",8)
		if ($d(^DHCRBCAppi("ItmCat",ItmCatDR))'=0) d
		.s retcode="1"
		q
	}
	quit retcode
}

//d ##class(web.DHCRisApplicationBill).SendHL7Message("22352||17")

/// /发送HL7消息
ClassMethod SendHL7Message(OEOrdItemID)
{
   n (OEOrdItemID)
   q:OEOrdItemID="" 
   s orderrowid=$p(OEOrdItemID,"||",1)
   s childsub=$p(OEOrdItemID,"||",2)
   s paadmdr=$p(^OEORD(orderrowid),"^",1)
   
   s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
   s GetRegNo=$p(PatInfo,"^",1)
   s GetName=$p(PatInfo,"^",2)
   s GetstrDOB=$p(PatInfo,"^",3)
   s GetstrDOB=$zdh(GetstrDOB,4)
   s GetstrDOB=$zd(GetstrDOB,3)
   s GetSexDesc=$p(PatInfo,"^",5)
   s Getpatienttype=$p(PatInfo,"^",6)
   s Gettypedesc=$p(PatInfo,"^",7)
   s GetLocName=$p(PatInfo,"^",8)
   s GetIPNo=$p(PatInfo,"^",9)
   s GetWardName=$p(PatInfo,"^",10)
   s GetBedNo=$p(PatInfo,"^",11)
   s TelNo=$p(PatInfo,"^",19)
   s address=$p(PatInfo,"^",22)
   d ##class(web.DHCRisHL7).SendPatientInfo("", GetRegNo, GetName, GetstrDOB, GetSexDesc, address, TelNo, "", "", Getpatienttype, GetWardName, "", GetBedNo, "", "", "", "", "", paadmdr)

   s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(orderrowid,childsub)
   s GetstrOrderName=$p(ordInfo,"^",1)
   s GetstrDate=$p(ordInfo,"^",2)
   s GetstrTime=$p(ordInfo,"^",3)
   s Getrequestdoc=$p(ordInfo,"^",4)
   s GetstrAccessionNum=$p(ordInfo,"^",5)
   s GetSGroupDesc=$p(ordInfo,"^",6)
   s GetsubCatDesc=$p(ordInfo,"^",7)
   s GetCatDesc=$p(ordInfo,"^",8)
   s Getifbed=$p(ordInfo,"^",9)
   s Getprice=$p(ordInfo,"^",10)
   s GetordDate=$p(ordInfo,"^",15)
   s ItemCode=$p(ordInfo,"^",22)
   s RelevantInfo=..GetAppInfo(OEOrdItemID)
   d ##class(web.DHCRisHL7).SendORMO01Message("", "NW", GetRegNo, GetName, OEOrdItemID, Getpatienttype, Getrequestdoc, paadmdr, ItemCode, GetstrOrderName, "05", RelevantInfo, GetWardName,GetLocName, GetBedNo,GetstrDOB,GetSexDesc,address, TelNo,"","")
   							//SendORMO01Message(MessageID, ControlID, PatientID, PatientName, oeorditemrowid, PatientClass, OrderProvider, VisitNumber, ArcItmCode, ArcItemName, RecLoc, RelevantInfo, Ward, Room, Bed,DOB="", Sex="男", Address="", HomeTel="", BussinessTel="", MaritalStatus="")
}

//d ##class(web.DHCRisApplicationBill).GetSelectType()

ClassMethod GetSelectType() As %String
{
	s Type=1
	if $g(^DHCRisAppSelectType)="" s ^DHCRisAppSelectType=1
	s Type=^DHCRisAppSelectType
	q Type
}

// 停医嘱 调用 Control="CA"

// 新医嘱      Control="NW"

ClassMethod SendHL7Message1(OEOrdItemID As %String, Control As %String = "NW")
{
   n (OEOrdItemID)
   q:OEOrdItemID="" 
   s orderrowid=$p(OEOrdItemID,"||",1)
   s childsub=$p(OEOrdItemID,"||",2)
   s paadmdr=$p(^OEORD(orderrowid),"^",1)
   s itmmastdr=$p($g(^OEORD(orderrowid,"I",childsub,1)),"^",2) 
   s ARCIMItemCat=$p(^ARCIM($p(itmmastdr,"||",1),$p(itmmastdr,"||",2),1),"^",10)  
   s ItemCatDesc=$p(^ARC("IC",ARCIMItemCat),"^",2)          ;----------------------------- 检查子类名称
   s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
   s GetRegNo=$p(PatInfo,"^",1)
   s GetName=$p(PatInfo,"^",2)
   s GetstrDOB=$p(PatInfo,"^",3)
   s GetstrDOB=$zdh(GetstrDOB,4)
   s GetstrDOB=$zd(GetstrDOB,3)
   s GetSexDesc=$p(PatInfo,"^",5)
   s Getpatienttype=$p(PatInfo,"^",6)
   s Gettypedesc=$p(PatInfo,"^",7)
   s GetLocName=$p(PatInfo,"^",8)
   s GetIPNo=$p(PatInfo,"^",9)
   s GetWardName=$p(PatInfo,"^",10)
   s GetBedNo=$p(PatInfo,"^",11)
   s TelNo=$p(PatInfo,"^",19)
   s address=$p(PatInfo,"^",22)
   s cardno=$p(PatInfo,"^",35)

   s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(orderrowid,childsub)
   s GetstrOrderName=$p(ordInfo,"^",1)
   s GetstrDate=$p(ordInfo,"^",2)
   s GetstrTime=$p(ordInfo,"^",3)
   s Getrequestdoc=$p(ordInfo,"^",4)
   s GetstrAccessionNum=$p(ordInfo,"^",5)
   s GetSGroupDesc=$p(ordInfo,"^",6)
   s GetsubCatDesc=$p(ordInfo,"^",7)
   s GetCatDesc=$p(ordInfo,"^",8)
   s Getifbed=$p(ordInfo,"^",9)
   s Getprice=$p(ordInfo,"^",10)
   s GetordDate=$p(ordInfo,"^",15)
   s ItemCode=$p(ordInfo,"^",22)
   s RelevantInfo=..GetAppInfo(OEOrdItemID)
   s requestLoc=$p(ordInfo,"^",24)
   s requestdoccode=$p(ordInfo,"^",25)
   s Getrequestdoc=requestdoccode_"^"_Getrequestdoc
   
   s TotalPrice=0
   ;s TotalPrice=##class(web.DHCRisApplicationBill).GetItemTotalPrice(OEOrdItemID)

   s Info=##class(web.DHCRisApplicationBill).GetAppShape(OEOrdItemID)
   s ShapDR=$p(Info,"^",3)
   if ShapDR'="" d
   .s AppType=$p(^DHCRBApp("Shape",ShapDR),"^",1) 
   .i (AppType="1")!(AppType="4")!(AppType="5") d
   ..d ##class(web.DHCRisHL7).SendPatientInfo("", GetRegNo, GetName, GetstrDOB, GetSexDesc, address, TelNo, "", "", Getpatienttype, GetWardName, "", GetBedNo, "", "", "", "", "", paadmdr,"1",cardno,GetIPNo,AppType,OEOrdItemID)
   ..d ##class(web.DHCRisHL7).SendORMO01Message("", Control, GetRegNo, GetName, OEOrdItemID, Getpatienttype, Getrequestdoc, paadmdr, ItemCode, GetstrOrderName, "", RelevantInfo, "", requestLoc, "","1",cardno,GetIPNo,AppType,"","","","","","","","")
   .else  i (AppType="2")!(AppType="11")!(AppType="15") d
   ..; 超声消息
   ..d ##class(web.DHCRisHL7).SendPatientInfo("", GetRegNo, GetName, GetstrDOB, GetSexDesc, address, TelNo, "", "", Getpatienttype, GetWardName, "", GetBedNo, "", "", "", "", "", paadmdr,"2",cardno,GetIPNo,AppType,OEOrdItemID)
   ..d ##class(web.DHCRisHL7).SendORMO01Message("", Control, GetRegNo, GetName, OEOrdItemID, Getpatienttype, Getrequestdoc, paadmdr, ItemCode, GetstrOrderName, "", RelevantInfo, "", requestLoc, "","2",cardno,GetIPNo,AppType,GetstrDOB,GetSexDesc, address, TelNo,"","",TotalPrice,ItemCatDesc)
   .else  if (AppType="电子肠镜检查申请单")!(AppType="电子胃肠镜检查申请单")!(AppType="支气管检查申请单") !(AppType="电子胃肠镜检查申请单") d
   ..; 内镜消息
   ..d ##class(web.DHCRisHL7).SendPatientInfo("", GetRegNo, GetName, GetstrDOB, GetSexDesc, address, TelNo, "", "", Getpatienttype, GetWardName, "", GetBedNo, "", "", "", "", "", paadmdr,"3",cardno,GetIPNo,AppType,OEOrdItemID)
   ..d ##class(web.DHCRisHL7).SendORMO01Message("", Control, GetRegNo, GetName, OEOrdItemID, Getpatienttype, Getrequestdoc, paadmdr, ItemCode, GetstrOrderName, "", RelevantInfo, "", requestLoc, "","3",cardno,GetIPNo,AppType,"","","","","","","","")
}

/// Query:QueryItemToBodyPart
/// 功能：根据医嘱项目查询对应的部位
/// 作者：gongping
/// 日期：2011-07-27  73754||283
/// d ##class(%ResultSet).RunQuery("web.DHCRisApplicationBill","QueryItemToBodyPart","73754||283")
Query QueryItemToBodyPart(OEorditemID As %String) As %Query(ROWSPEC = "BodyPartId:%String,BodyCode:%String,BodyDesc:%String,ExclusionFlag:%String")
{
}

ClassMethod QueryItemToBodyPartExecute(ByRef qHandle As %Binary, OEorditemID As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 s ind=1
 i OEorditemID="" Set qHandle=$lb(0,repid,0)
 Quit:OEorditemID="" $$$OK
 k ^TMPBodyPartOut
 
 s num=$l(OEorditemID,"@")
 f i=1:1:num  d
 .s perOrditemId=$p(OEorditemID,"@",i)
 .s OrderRowid=$p(perOrditemId,"||",1)
 .s itemsub=$p(perOrditemId,"||",2) 
 .s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
 .i arcimid'="" d
 ..s Rowid=0  f  s Rowid=$o(^DHCRBCi("ItemToBodyPart",0,arcimid,Rowid)) q:Rowid=""  d
 ...s ExclusionFlag=$p(^DHCRBC("ItemToBodyPart",Rowid),"^",4)
 ...s BodyPartId=$p(^DHCRBC("ItemToBodyPart",Rowid),"^",2)
 ...i BodyPartId'="" d
 ....s BodyCode=$p(^MRC("BODP",BodyPartId),"^",1)  
 ....s BodyDesc=$p(^MRC("BODP",BodyPartId),"^",2)
 ....i $g(^TMPBodyPartOut(BodyCode))="" d 
 .....s ^TMPBodyPartOut(BodyCode)=BodyCode
 .....d OutPrintBodyPart
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutPrintBodyPart
 set Data=$lb(BodyPartId,BodyCode,BodyDesc,ExclusionFlag)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

//SG_YB

ClassMethod QueryItemToBodyPartFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryItemToBodyPartExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryItemToBodyPartClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryItemToBodyPartExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetBodyPartList(OEorditemID As %String) As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisApplicationBill:QueryItemToBodyPart")
	s ret=""
	s count=0
	do rset.Execute(OEorditemID)
	while (rset.Next())
	{
	   i ret="" s ret=rset.GetData(2)_"&"_rset.GetData(4)_"-"_rset.GetData(3)
	   e  s ret=ret_"@"_rset.GetData(2)_"&"_rset.GetData(4)_"-"_rset.GetData(3)

	}	
	d rset.Close()
	q ret
}

ClassMethod GetItemInfoDesc(OrditemRowid As %String) As %String
{
	s AppRowid=$o(^DHCRBAppOrdi(0,OrditemRowid,0))
	i AppRowid'="" d
	.s ItemInfo=^DHCRBApp("Bill",AppRowid,"ItemInfo")
	/*
	.s count=$l(ItemInfo,"^")
	.for i=1:count:1 d
	..s pItemInfo=$p(ItemInfo,"^",i)
	..s ItemName=$p(pItemInfo,$c(2),1)  
	*/                    
	q ItemName
}

ClassMethod For()
{
	f i=1900:-1:1 d
	.q:(i=6)
	.w !,i
}

/// 查询名称：QueryLocUser
/// 功能：查询预约方法
/// 参数：
/// 返回：
/// 作者：sunyi
/// 日期：2011-11-22
/// d ##class(%ResultSet).RunQuery("web.DHCRisApplicationBill","QueryLocUser","63801||1112@")
Query QueryLocUser(OEorditemID As %String) As %Query(ROWSPEC = "Rowid:%String,Desc:%String,Code:%String")
{
}

ClassMethod QueryLocUserExecute(ByRef qHandle As %Binary, OEorditemID As %String) As %Status
{
	
 s ind=1
 Set repid=$I(^CacheTemp)
 s OerdItemID=$p(OEorditemID,"@",1)
 ;s OerdItemID=OEorditemID
 q:(OerdItemID="")
 s OrderRowid=$p(OerdItemID,"||",1)
 s itemsub=$p(OerdItemID,"||",2)
 s RecLocDR=""
 s RecLocDR=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)
 q:(RecLocDR="")
 
 s resrowid=0 f  s resrowid=$o(^RB("RES",0,"CTLOC",RecLocDR,resrowid)) q:(resrowid="")  d
 .s ResInfo=^RB("RES",resrowid)
 .s CareProvrowid=$p($g(ResInfo),"^",2)
 .s ssusercode="",ssusername=""
 .i CareProvrowid'=""  d
 ..s ssuserrowid=$o(^SSU("SSUSR",0,"CTPCP",CareProvrowid,0))
 ..q:(ssuserrowid="")!(ssuserrowid=$C(0))
 ..s ssusercode=$p(^SSU("SSUSR",ssuserrowid),"^",1)
 ..s ssusername=$p(^SSU("SSUSR",ssuserrowid),"^",2)
 ..Do OutMethod
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK 
OutMethod
 set Data=$lb(ssuserrowid,ssusername,ssusercode)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryLocUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocUserExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryLocUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLocUserExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

//do ##class(web.DHCRisApplicationBill).GetPostureList("20017||3862@")

/*ClassMethod GetPostureList(OEorditemID As %String) As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisApplicationBill:QueryItemToPosture")
	s ret=""
	s count=0
	do rset.Execute(OEorditemID)
	while (rset.Next())
	{
	   i ret="" s ret=rset.GetData(2)_"-"_rset.GetData(3)
	   e  s ret=ret_"^"_rset.GetData(2)_"-"_rset.GetData(3)

	}	
	d rset.Close()
	q ret
}*/
ClassMethod GetPostureList(OEorditemID As %String) As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisApplicationBill:QueryItemToPosture")
	kill ^DHCRISPOSTURETMP("PostureList",$J)
	s ret=""
	s count=0
	do rset.Execute(OEorditemID)
	while (rset.Next())
	{
	   if (rset.GetData(3)'="") set ^DHCRISPOSTURETMP("PostureList",$J,rset.GetData(3))=rset.GetData(2)
	}
	d rset.Close()
	set PostureDesc=""
	while($order(^DHCRISPOSTURETMP("PostureList",$J,PostureDesc))'="")
	{
		set PostureDesc=$order(^DHCRISPOSTURETMP("PostureList",$J,PostureDesc))
		set PostureID=^DHCRISPOSTURETMP("PostureList",$J,PostureDesc)
		i ret="" s ret=PostureID_"-"_PostureDesc
	    e  s ret=ret_"@"_PostureID_"-"_PostureDesc
	}
	kill ^DHCRISPOSTURETMP("PostureList",$J)	
	
	q ret
}

/// Query:QueryItemToPosture
/// 功能：根据医嘱项目查询对应的体位
/// 作者：sunyi
/// 日期：2011-12-02
/// d ##class(%ResultSet).RunQuery("web.DHCRisApplicationBill","QueryItemToPosture","20017||3862@")
Query QueryItemToPosture(OEorditemID As %String) As %Query(ROWSPEC = "BodyPartId:%String,PostureID:%String,PostureDesc:%String")
{
}

ClassMethod QueryItemToPostureExecute(ByRef qHandle As %Binary, OEorditemID As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 s ind=1
 i OEorditemID="" Set qHandle=$lb(0,repid,0)
 Quit:OEorditemID="" $$$OK
 
 s num=$l(OEorditemID,"@")
 f i=1:1:num  d
 .s perOrditemId=$p(OEorditemID,"@",i)
 .q:(perOrditemId="")
 .s OrderRowid=$p($g(perOrditemId),"||",1)
 .s itemsub=$p($g(perOrditemId),"||",2)
 .s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
 .i arcimid'="" d
 ..s Rowid=0  f  s Rowid=$o(^DHCRBCi("ItemToBodyPart",0,arcimid,Rowid)) q:Rowid=""  d
 ...s BodyPartId=$p(^DHCRBC("ItemToBodyPart",Rowid),"^",2)
 ...q:(BodyPartId="")
 ...s PostureID=0 f  s PostureID=$o(^DHCRBCi("PosturetoBodyPart",0,BodyPartId,PostureID)) q:PostureID=""  d
 ....s PostureDesc=$p($g(^DHCRBC("PosturetoBodyPart",PostureID)),"^",2)
 ....d OutPrintPosture
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutPrintPosture
 set Data=$lb(BodyPartId,PostureID,PostureDesc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

//SG_YB

ClassMethod QueryItemToPostureFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryItemToPostureExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryItemToPostureClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryItemToPostureExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 得到医嘱项目关联身体部位是否互斥标记
/// sunyi 2011-12-03
/// w ##class(web.DHCRisApplicationBill).GetExclusionFlag("20017||3862@")
ClassMethod GetExclusionFlag(OEorditemID As %String) As %String
{
	s ExclusionFlag=""
	s perOrditemId=$p(OEorditemID,"@",1)
	s OrderRowid=$p($g(perOrditemId),"||",1)
    s itemsub=$p($g(perOrditemId),"||",2)
    s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
    q:(arcimid="")
    s DIBPRowid=$o(^DHCRBCItemBookProperTypei(arcimid,""))
    q:(DIBPRowid="")
    s ExclusionFlag=$p($g(^DHCRBCItemBookProperty(DIBPRowid)),"^",8)
    q ExclusionFlag
}

/// 返回自动划价标识  Y-自动划价 “”或N -手动
/// sunyi 2011-12-03
ClassMethod GetAutoInputFeeFlag(arcimid As %String, Paadmdr As %String = "") As %String
{
    q:(arcimid="")
    s DIBPRowid=$o(^DHCRBCItemBookProperTypei(arcimid,""))
    q:(DIBPRowid="")
    s AutoInputFeeFlag=$p($g(^DHCRBCItemBookProperty(DIBPRowid)),"^",3)
    q AutoInputFeeFlag
}

/// 存放申请单界面上没有存位置的新加字段
/// sunyi 2011-12-10
ClassMethod SetAppInfo(OEorditemID As %String, Info As %String) As %String
{
	s num=$l(OEorditemID,"@")
    f i=1:1:num  d
    .s perOrditemId=$p(OEorditemID,"@",i)
    .q:(perOrditemId="")
	.s LocDoctor=$p($g(Info),"^",1)
	.s OtherBodyPart=$p($g(Info),"^",2)
	.s HopeDate=$p($g(Info),"^",3)
	.s Posture=$p($g(Info),"^",4)
	.s BodyParts=$p($g(Info),"^",5)
	.s Purpose=$p($g(Info),"^",6)
	.s ^DHCRISAPPINFOS("APPLICATIONBILL",perOrditemId)=LocDoctor_"^"_OtherBodyPart_"^"_HopeDate_"^"_Posture_"^"_BodyParts_"^"_Purpose
	q 0
}

/// 协和医院得到选中的其他部位标识，用于判断其他部位框是否可用
/// sunyi 2011-12-10
/// do ##class(web.DHCRisApplicationBill).GetOtherBodyPartFalg("5||36@")
ClassMethod GetOtherBodyPartFalg(OEorditemID As %String) As %String
{
	s perOrditemId=$p(OEorditemID,"@",1)
	q:(perOrditemId="") ""
	s AppInfo=""
	s AppInfo=$g(^DHCRISAPPINFOS("APPLICATIONBILL",perOrditemId))
	q:(AppInfo="") ""
	
	s OtherBodyDesc="",OtherBodyFlag=""
	s OtherBodyDesc=$p(AppInfo,"^",2)
	i OtherBodyDesc'=""  s OtherBodyFlag=$p(OtherBodyDesc,"&",1)
	s Posture=$p($g(AppInfo),"^",4)
	
	q OtherBodyFlag_"^"_Posture
}

/// 根据医嘱ID返回医嘱状态
/// sunyi 2011-12-10
/// A 医嘱已审核  E 申请已发送   BK 预约  RJ 拒绝申请
/// w ##class(web.DHCRisApplicationBill).GetPatientStatus("73754||283@")
ClassMethod GetPatientStatus(OEorditemID As %String) As %String
{
  s perOrditemId=$p(OEorditemID,"@",1)
  q:(perOrditemId="") ""
  s Ordrowid=$p(perOrditemId,"||",1)
  s itmsub=$p(perOrditemId,"||",2)
  s Status=""
  s Status=$p($g(^OEORD(Ordrowid,"I",itmsub,1)),"^",5)
  s ^DHCRis("Status123")=Status
  q Status
}

ClassMethod Insert(Oeorditemrowid, ArcItemRowid)
{
	q:(Oeorditemrowid="") "-1"
	q:(ArcItemRowid="") "-1"
	
	s OEordRowid=$p(Oeorditemrowid,"||",1)
    s itemsub=$p(Oeorditemrowid,"||",2)
	    
	if (ArcItemRowid="22145||1") //床旁
	{    
	     s IsExit=""
	     s IsExit=..IsBedSideItem(Oeorditemrowid, ArcItemRowid)
	     
		 i (IsExit'="Y")
		 {
			 &SQL(select * into :PLIST() from SQLUser.OE_OrdItem where oeori_rowid=:Oeorditemrowid)
		 
		     s (pattype,instype,ArcItemID,sttdate,PriorityDR,InstrDR,LinkToOrder,Price,GetPrice,paadmdr,paadmtype)=""
		 
		     s paadmdr=$p($g(^OEORD(OEordRowid)),"^",1)
		     s paadmtype=$p(^PAADM(paadmdr),"^",2)
		     
			 s ArcItemID=PLIST(4)
			 s sttdate=PLIST(17)
			 s PriorityDR=PLIST(23)
			 s InstrDR=PLIST(27)
			 s LinkToOrder=PLIST(52)
			 s Price=PLIST(79)
		     s UserID=PLIST(120)
		     
			 s ret=##class(web.UDHCJFPRICE).GetOrderPrice(pattype, instype, ArcItemID, sttdate, PriorityDR, InstrDR, LinkToOrder, Price,Oeorditemrowid)
			 i (ret'="")
			 {
				s GetPrice=$p($g(ret),"^",1) 
				s GetPrice=GetPrice-30
				s PLIST(79)=GetPrice
				s ^DHCRis("TempRIS")=GetPrice
			 }
			 
			 
	         K PLIST(2)
		     K PLIST(1)
		     s PLIST(4)=ArcItemRowid
		     s PLIST(230)=Oeorditemrowid
		 
		 
		     &SQL(insert into SQLUser.OE_OrdItem values :PLIST())
		    
		     i (paadmdr'="")&(paadmtype="I") 
			 {   
			 	 s rets=##class(web.UDHCJFBILL).BILLN(paadmdr,UserID,"")
			 }
		     q SQLCODE
		     
		 }
	}
	 
	if (ArcItemRowid="14634||1") //手术 
	{
		 s $p(^OEORD(OEordRowid,"I",itemsub,"DHC"),"^",25)="Y"	 
	}
	 
	q 0
}

/// do ##class(web.DHCRisApplicationBill).Insert("75||176","22145||1")
/// w ##class(web.DHCRisApplicationBill).GetAppItemName("75||44")
/// do ##class(web.DHCRisApplicationBill).GetAppItemName("5||136")
ClassMethod GetAppItemName(OEorditemID As %String) As %String
{
	s strItemName="",arcimid="",strOrderName="",Info=""
	s AppInfo="",Posture="",BodyPartDesc="",BodyInfo="",OtherBodyPart=""
	
	s perOrditemId=$p(OEorditemID,"@",1)
	q:(perOrditemId="")
	
	s OrderRowid =$p($g(perOrditemId),"||",1)
	s itemsub=$p($g(perOrditemId),"||",2)
	i (OrderRowid'="")&(itemsub'="")
	{
	   s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	   q:(arcimid="") Info
       q:'$d(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1))
       ;申请单上实际遗嘱名称
       s strOrderName=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),9)),"^",14) 
       i strOrderName="" s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2) 
       s AppInfo=$g(^DHCRISAPPINFOS("APPLICATIONBILL",perOrditemId))
       i (AppInfo'="") d
       .s OtherBodyPart=$p($g(AppInfo),"^",2)
       .i OtherBodyPart'=""  s OtherBodyPart=$p($g(OtherBodyPart),"&",2)
       .s Posture=$p($g(AppInfo),"^",4)
       .s BodyPart=$p($g(AppInfo),"^",5)
       .i (BodyPart'="") d
       ..s num=$l(BodyPart,"&")
       ..f i=1:1:num  d
       ...s BodyPartDesc=$p(BodyPart,"&",i)
       ...i BodyPartDesc="其他部位" s BodyPartDesc=OtherBodyPart
       ...q:(BodyPartDesc="")
       ...i BodyInfo="" s BodyInfo=BodyPartDesc
       ...e  d
       ....s BodyInfo=BodyInfo_"、"_BodyPartDesc
       s Info=Posture_BodyInfo_strOrderName
	}

    q Info
}

/// 协和医院和医学科根据申请单样式设置提示信息(这里固定样式ID)
/// sunyi 2012-01-05
ClassMethod DisplayRevelation(OEorditemID As %String) As %String
{
	s perOrditemId=$p(OEorditemID,"@",1)
	q:(perOrditemId="") "N"
	s Info="",IsDisplay="N"
	
    s Info=..GetAppShape(perOrditemId)
    i (Info'="")
    {
	   s ShapeDR=$p(Info,"^",3)
	   i ShapeDR="1" d
	   .s IsDisplay="Y"    
	}
	
	q IsDisplay
}

/// 得到存放申请单的体位与部位
/// do ##class(web.DHCRisApplicationBill).GetSelBodyPart("10544||3")
/// sunyi 2012-09-10
ClassMethod GetSelBodyPart(OEorditemID As %String) As %String
{
    s perOrditemId=$p(OEorditemID,"@",1)
    q:(perOrditemId="")
    s (Info,Posture,BodyParts,BodyInfo,BodyPartDesc,value)=""
    
    i ($d(^DHCRISAPPINFOS("APPLICATIONBILL",perOrditemId)))
    {
	    s Info=$g(^DHCRISAPPINFOS("APPLICATIONBILL",perOrditemId))
	    i Info'="" d
	    .s Posture=$p($g(Info),"^",4)
	    .s BodyParts=$p($g(Info),"^",5)
	    .i (BodyParts'="") d
        ..s num=$l(BodyParts,"&")
        ..f i=1:1:num  d
        ...s BodyPartDesc=$p(BodyParts,"&",i)
        ...i BodyInfo="" s BodyInfo=BodyPartDesc
        ...q:(BodyPartDesc="")
        ...e  d
        ....s BodyInfo=BodyInfo_"、"_BodyPartDesc
	}
	
	s value=Posture_"^"_BodyInfo
	
	q value
}

/// 获取多条医嘱的总价格
/// w ##class(web.DHCRisApplicationBill).GetTotalPrice("59866||687@59866||688")
ClassMethod GetTotalPrice(OEorditemID) As %String
{
	s num=$l(OEorditemID,"@")
	s Info="",TotalPrice=""
    f i=1:1:num  d
    .s perOrditemId=$p(OEorditemID,"@",i)
    .q:(perOrditemId="")
	.s OrderRowid=$p(perOrditemId,"||",1)
	.s itemsub=$p(perOrditemId,"||",2)
	.s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2) 
    .s price=##class(web.DHCRisCommFunction).GetItemPrice(perOrditemId)
	.s Num=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",12)
	.s TotalPrice=price*Num
	.i TotalPrice="" s TotalPrice=0
	.i Info="" s Info=TotalPrice
	.e  d
	..s Info=Info+TotalPrice
	s Info=Info_("元")
	q Info
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

/// w ##class(web.DHCRisApplicationBill).IsAutoBooked("73754||285")
ClassMethod IsAutoBooked(oeorditemdr As %String) As %String
{
	q:(oeorditemdr="")
	s oeordrowid=$p(oeorditemdr,"||",1)
	s oeorisub=$p(oeorditemdr,"||",2)
	
	s Flag="N"
	s (IPRowid,IPRowid,AppointMethodId,AppointMethod)=""
	
	s itmmastdr=$p($g(^OEORD(oeordrowid,"I",oeorisub,1)),"^",2)
	i itmmastdr'=""  s IPRowid=$o(^DHCRBCItemBookProperTypei(itmmastdr,0)) 
	i IPRowid'="" s AppointMethodId=$p($g(^DHCRBCItemBookProperty(IPRowid)),"^",2)
	i AppointMethodId'="" s AppointMethod=$p(^DHCRBCAppointMethod(AppointMethodId) ,"^",2)
    

	i (AppointMethod="自动预约")
	{
	  s Flag="Y"
	}
	
	q Flag
}

/// do ##class(web.DHCRisApplicationBill).SetSattus()
ClassMethod SetSattus()
{
	s ^DHCRisIPSendMessage="Y"
}

/// 协和插入特需医嘱
/// do ##class(web.DHCRisApplicationBill).InsertTeXu("76741","76983||2","11150||1")
ClassMethod InsertTeXu(Paadmdr, Oeorditemrowid, ArcItemRowid) As %String
{
	s ^t=Paadmdr_"^"_Oeorditemrowid_"^"_ArcItemRowid
	q:(Paadmdr="") "0"
	q:(ArcItemRowid="") "0"
	
	s OEordRowid=$p(Oeorditemrowid,"||",1)
    s itemsub=$p(Oeorditemrowid,"||",2)
    
	s IsFlag="",InDate=""
	s InDate=$p($g(^OEORD(OEordRowid,"I",itemsub,1)),"^",9)
	s IsFlag=..IsExist(Paadmdr,ArcItemRowid,InDate)
	
	i (IsFlag'="Y")
	{
		 &SQL(select * into :PLIST() from SQLUser.OE_OrdItem where oeori_rowid=:Oeorditemrowid)
	 
	     s (pattype,instype,ArcItemID,sttdate,PriorityDR,InstrDR,LinkToOrder,Price,GetPrice,paadmdr,paadmtype)=""
	 
		
		 s paadmdr=$p($g(^OEORD(OEordRowid)),"^",1)
		 s paadmtype=$p(^PAADM(paadmdr),"^",2)
		 s pattype=$p(^PAADM(paadmdr,1),"^",6)
	 
	 
		 s ArcItemID=PLIST(4)
		 s sttdate=PLIST(17)
		 s PriorityDR=PLIST(23)
		 s InstrDR=PLIST(27)
		 s LinkToOrder=PLIST(52)
		 s Price=PLIST(79)
	     s UserID=PLIST(120)
	     
		 s ret=##class(web.UDHCJFPRICE).GetOrderPrice(pattype, instype, ArcItemID, sttdate, PriorityDR, InstrDR, LinkToOrder, Price,Oeorditemrowid)
		 i (ret'="")
		 {
			s GetPrice=$p($g(ret),"^",1) 
			;s GetPrice=60
			s PLIST(79)=GetPrice
		 }
		 
		 
         K PLIST(2)
	     K PLIST(1)
	     s PLIST(4)=ArcItemRowid
	     s PLIST(230)=Oeorditemrowid
	 
	 
	     &SQL(insert into SQLUser.OE_OrdItem values :PLIST())
	    
	     i (paadmdr'="")&(paadmtype="I") 
		 {   
		 	 s rets=##class(web.UDHCJFBILL).BILLN(paadmdr,UserID,"")
		 }
	     q SQLCODE
	     
	}
	
	q 0
}

/// w ##class(web.DHCRisApplicationBill).IsExist("74451","11150||1")
ClassMethod IsExist(Paadmdr As %String, ArcItemRowid As %String, InDate As %String) As %String
{
 s IsExitFlag="N"
 s OrderRowid=""

 s OrderRowid=$o(^OEORD(0,"Adm",Paadmdr,OrderRowid))
 q:(OrderRowid="") "N"
 q:(InDate="") "N"

 s itemsub=0 f  s itemsub=$o(^OEORDi(0,"ARCIM",OrderRowid,ArcItemRowid,InDate,itemsub)) q:(itemsub="")  d
 .s (ItemStatDR,arcimid,ItemStatusCode,Date)=""
 .s ItemStatDR=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",13) ; 医嘱状态
 .i ItemStatDR'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
 .s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
 .i ItemStatusCode'="D" s IsExitFlag="Y"
 .i IsExitFlag="Y" BREAK:IsExitFlag
    
 q IsExitFlag
}

/// w ##class(web.DHCRisApplicationBill).IsBedSideItem("76983||2","11150||1")
ClassMethod IsBedSideItem(Oeorditemrowid, InArcItemRowid) As %String
{
	q:(Oeorditemrowid="") "Y"
	
	s OrderRowid=$p($g(Oeorditemrowid),"||",1)
	s IsExit="N"
	
	s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
	.s MOedItemRowid=$p($g(^OEORD(OrderRowid,"I",itemsub,11)),"^",39)
	.s GetArcItmRowid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	.s ItemStatDR=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",13) ; 医嘱状态
    .i ItemStatDR'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
	.i ((MOedItemRowid=Oeorditemrowid)&(InArcItemRowid=GetArcItmRowid)&(ItemStatusCode'="D")) d
	..s IsExit="Y"
	.i IsExit="Y"  BREAK:IsExit
	
	q IsExit
}

/// 协和根据主医嘱ID停止插入错误的子医嘱
/// do ##class(web.DHCRisApplicationBill).StopItemExit("74301||219")
ClassMethod StopItemExit(Oeorditemrowid)
{
	s SetArcimid="22145||1",InDate=""
	s OrderRowid=$p(Oeorditemrowid,"||",1)
    s itemsub=$p(Oeorditemrowid,"||",2)
    s ExitItemRowid=""
    
	s InDate=$p($g(^OEORD(OEordRowid,"I",itemsub,1)),"^",9)
	q:(InDate="")
	s itemsubL=0 f  s itemsubL=$o(^OEORDi(0,"ARCIM",OrderRowid,SetArcimid,InDate,itemsubL)) q:(itemsubL="")  d
	.s ExitItemRowid=OEordRowid_"||"_itemsubL
	.s MOedItemRowid=$p($g(^OEORD(OrderRowid,"I",itemsubL,11)),"^",39)
	.s GetArcItmRowid=$p($g(^OEORD(OrderRowid,"I",itemsubL,1)),"^",2)
	.s ItemStatDR=""
	.s ItemStatDR=$p(^OEORD(OrderRowid,"I",itemsubL,1),"^",13) ; 医嘱状态
    .i ItemStatDR'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
	.i ((MOedItemRowid=Oeorditemrowid)&(SetArcimid=GetArcItmRowid)&(ItemStatusCode'="D")) d
	..do ##class(web.DHCOEOrdItem).Stop(ExitItemRowid,"")
}

//do ##class(web.DHCRisApplicationBill).SetCarrentAppFiled("1^2^3^4")

ClassMethod SetCarrentAppFiled(Info As %String)
{
	s PaadmDR=$p($g(Info),"^",1)
	s OeOrditemID=$p($g(Info),"^",2) 
	s AppFieldDR=$p($g(Info),"^",3)
	s AppFieldValue=$p($g(Info),"^",4)
	
	s rowid=""
 	&sql(select DSA_Rowid into :rowid from DHCRBC_Save_AppFiled where (DSA_Paadm_DR =:PaadmDR and DSA_AppField_DR=:AppFieldDR))
	i (rowid="") d
	 .&sql(insert into DHCRBC_Save_AppFiled(DSA_Paadm_DR,DSA_OEOrdItem_DR,DSA_AppField_DR,DSA_AppField_Value)values
	                                  (:PaadmDR,:OeOrditemID,:AppFieldDR,:AppFieldValue))
	e  d
	.&sql(update DHCRBC_Save_AppFiled(DSA_AppField_Value)values(:AppFieldValue) where DSA_Rowid=:rowid)
    
	q SQLCODE
}

ClassMethod DelSaveAppFiled(PaadmDR As %String, FieldDR As %String) As %String
{
	s SQLCODE=0
	
	i ((PaadmDR'="")&(FieldDR'="")) d
	.s Rowid=$o(^DHCRBCSAFi("APPFILED-ID",PaadmDR,FieldDR,0))
	.i Rowid'="" d
    ..&sql(delete from DHCRBC_Save_AppFiled where DSA_Rowid=:Rowid)
    
    q SQLCODE
}

// w ##class(web.DHCRisApplicationBill).IsSendAppBillAll("53||37")

// 判断是否发送申请单

// 返回值：flag(Y/N)^医嘱Rowid(rowid@rowid@rowid)  

ClassMethod IsSendAppBillAll(OeOrditemID) As %String
{
	
	s flag="N",ordList="",ret=""
	s AppRowid=""
	;s Nums=$l(OeOrditemID,"@")
	//for i=1:1:Nums d
	//.s perOrditemID=$p(OeOrditemID,"@",i)
	s AppRowid=$o(^DHCRBAppOrdi(0,OeOrditemID,AppRowid))
	if AppRowid'="" d
	.s flag="Y"
	.s childSub="" f  s childSub=$o(^DHCRBAppOrd("OrdItem",AppRowid,childSub)) q:(childSub="")  d
	..i ordList="" d
	...s ordList=$p(^DHCRBAppOrd("OrdItem",AppRowid,childSub),"^",1)
	..e  d
	...s ordList=ordList_"@"_$p(^DHCRBAppOrd("OrdItem",AppRowid,childSub),"^",1)
	s ret=flag_"^"_ordList
	s ^DHCRisTemp("1")=ret
	q ret
}

/// 去除JSON数据中的特殊字符
ClassMethod EvalJSON(instr As %String) As %String
{
	;w ##class(ext.util.String).EvalJSON("a\")
	s mystr = instr
	
	q:(mystr="") mystr
	
	s mystr = ..Replace(mystr,"\", "\\")
	
	s mystr = ..Replace(mystr,"'", "\'")
	
	s mystr = ..Replace(mystr,$c(13), "")
	
	s mystr = ..Replace(mystr,$c(10), "")
	
	q mystr
}

/// 要求被替换的内容不能=""
ClassMethod Replace(instr As %String, substr As %String, replacement As %String) As %String
{
	;
	q:(substr="") instr
	;q:(replacement="") instr
	q:'($l(instr,substr)>1) instr
	
	s mylen=$l(instr,substr)
	for myIdx=1:1:mylen {
		s myary(myIdx)=$p(instr,substr, myIdx)
	}
		
	s mystr=""
	s myIdx=""
	s myIdx=$o(myary(myIdx))
	while (myIdx'=""){
		s myrepstr=""
		i ($o(myary(myIdx))=""){
			s myrepstr=myary(myIdx)
		}else{
			s myrepstr=myary(myIdx)_replacement
		}
		
		i (mystr=""){
			s mystr=myrepstr
		}else{
			s mystr=mystr_myrepstr
		}
		
		s myIdx=$o(myary(myIdx))
		q:(myIdx="")
	}
	
	q mystr
}

ClassMethod GetAppShapeById(ShapeDR As %String) As %String
{
    s ComponentName="",PrintTemp="",AppSetrowid="",HtmlShape=""
    b //01
    i ShapeDR'="" d  
    .s ComponentName=$p(^DHCRBApp("Shape",ShapeDR),"^",2)
    .s PrintTemp=$p(^DHCRBApp("Shape",ShapeDR),"^",3)
    .s HtmlShape=$g(^DHCRBApp("Shape",ShapeDR,"html"))
    //在CACHE 查询的结果返回到前端，如果$c(13,10),就会中断，所以要把$c(13,10)用$c(1)替换
    s Num=$l(HtmlShape,$C(13,10))
	s strHtmlConent=""
	for I=1:1:Num d
	.s pHtmlConent=$p(HtmlShape,$C(13,10),I)
	.i strHtmlConent="" d
	..s strHtmlConent=pHtmlConent
	.else  d 
	..s strHtmlConent=strHtmlConent_$C(1)_pHtmlConent
    q ComponentName_"^"_PrintTemp_"^"_ShapeDR_"^"_strHtmlConent
}

/// w ##class(web.DHCRisApplicationBill).GetGoalFlag("63||433")
/// 同仁增加判断申请单检查目的不为空手填,否则 默认医嘱项目
ClassMethod GetGoalFlag(OEorditemID) As %String
{
	s perOrditemId="",Flag="",ArcItm="",arcimid=""
    q:(OEorditemID="") Flag
   
    s perOrditemId=$p(OEorditemID,"@",1)
    q:(perOrditemId="") Flag
    s OrderRowid=$p(perOrditemId,"||",1)
    s itemsub=$p(perOrditemId,"||",2)
    s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
    q:(arcimid="") Flag
	&sql(select ARCIM_Text5 into Flag from Arc_ItmMast where ARCIM_RowId=:arcimid) 
	
	q Flag
}

//获取病史及临床所见

/// w ##class(web.DHCRisApplicationBill).GetItemInfo("20017||3875")
ClassMethod GetItemInfo(OeOrditemID As %String) As %String
{
	q:OeOrditemID="" "^"
	s Ordrowid=$p(OeOrditemID,"||",1)
	s paadmdr=$p(^OEORD(Ordrowid),"^",1) 
	s Diagnose=##class(web.DHCRisCommFunctionEx).GetDiagnose(paadmdr) //
	s ItemInfo=..GetAppItemInfo(OeOrditemID)
	s ItemInfo=$tr(ItemInfo,$c(2)," ")
	s ItemInfo=$tr(ItemInfo,"^" ,"     ")
	s ItemInfo=$tr(ItemInfo,"true" ,"Y")
	s ItemInfo=$tr(ItemInfo,"false" ,"N")
	;s Info=Diagnose_" "_ItemInfo
	s Info=Diagnose_"  病史: "_ItemInfo
	q Info
}

ClassMethod SetNoSendAppCount(UserID, Number) As %String
{
	s AppCount=0
	
	q:'$d(^DHCRISAPPCOUNT(UserID))
	q:(Number=0)
	s AppCount=$g(^DHCRISAPPCOUNT(UserID))-Number
	s ^DHCRISAPPCOUNT(UserID)=AppCount
	q AppCount
}

ClassMethod GetNoSendAppCount(UserID) As %String
{
	s AppCount=0
	q:'$d(^DHCRISAPPCOUNT(UserID)) ""
	s AppCount=$g(^DHCRISAPPCOUNT(UserID))
	q AppCount
}

/// w ##class(web.DHCRisApplicationBill).GetAppBillPrintData("20017||3857")
ClassMethod GetAppBillPrintData(OeOrditemID As %String) As %String
{
	s Info=""
	q:(OeOrditemID="") Info
	s GetBkInfo="",PaadmInfo="",GetOrdInfoL=""
	s perOeOrditemID=""
	s perOeOrditemID=$p(OeOrditemID,"@",1)
	s perOrderRowid=$p(perOeOrditemID,"||",1)
	s peritemsub=$p(perOeOrditemID,"||",2)
	
	s RecLocDR="",paadmdr="",patienttype=""
	s RecLocDR=$p(^OEORD(perOrderRowid,"I",peritemsub,3),"^",6)
	
	s paadmdr=$p(^OEORD(perOrderRowid),"^",1)
    i paadmdr'="" s patienttype=$p(^PAADM(paadmdr),"^",2) 
    
    //获取科室地址信息
    s GetBkInfo=..GetBKLocation(RecLocDR,patienttype)
    s GetOrdInfoL=..GetOrdInfo(perOrderRowid,peritemsub)
    s PaadmInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
    s Info=GetBkInfo_"^"_PaadmInfo_"^"_GetOrdInfoL
	q Info
}

ClassMethod GetBKLocation(LocDR As %String, Pattype As %String) As %String
{
	s Locaction="^"
	q:(LocDR="") Locaction
	s LocSetRowid="",RecLocAddress="",BookedAddress=""
	
	s LocSetRowid=$o(^DHCRBCLocationi("Rec-LocDR",LocDR,LocSetRowid)) 
	i (LocSetRowid'="") 
	{
       s RecLocAddress=$p($g(^DHCRBCLocation("LOCATION",LocSetRowid)),"^",2)
       s BookedAddress=$p($g(^DHCRBCLocation("LOCATION",LocSetRowid)),"^",3)
 
       i (LocDR="155") d
       .i (Pattype="O") s RecLocAddress="门诊楼二层B超室"
       .i (Pattype="I") s RecLocAddress="在病房楼三层B超室"
       s Locaction=RecLocAddress_"^"_BookedAddress
	}
	
	q Locaction
}

ClassMethod GetOrdInfo(OrderRowid, itemsub) As %String
{
	s arcimid="",OrderName="",ifbed="床旁^"
	s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	q:(arcimid="") "^"
	s OrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	i (OrderName["床旁") s ifbed="床旁^"
	q ifbed
}

/// 函数:GetContraindication
/// 功能:根据医嘱项目ID获取禁忌症
/// w ##class(web.DHCRisApplicationBill).GetContraindication("390||4")
/// 函数:GetContraindication
/// 功能:根据医嘱项目ID获取禁忌症
/// w ##class(web.DHCRisApplicationBill).GetContraindication("20017||3893@20017||3895@20017||3893")
ClassMethod GetContraindication(OEItmRowidGroup As %String) As %String
{
	s ContInfo=""
    s Counts=$l(OEItmRowidGroup,"@")
    q:(OEItmRowidGroup="") ContInfo
    
	s InputInfo=##class(web.DHCRisResourceApptSchudle).GetFormatInfo(OEItmRowidGroup)
    s ContInfo=##class(web.DHCRisResourceApptSchudle).RequestKnowledgeInfo("Q",InputInfo,"","2")
   
	q ContInfo
}

/// 函数:GetContraindication
/// 功能:根据医嘱项目ID获取禁忌症
/// w ##class(web.DHCRisApplicationBill).GetGetIndication("20017||3893@20017||3895@20017||3893")
ClassMethod GetIndication(OEItmRowidGroup As %String) As %String
{
	s ContInfo=""
    s Counts=$l(OEItmRowidGroup,"@")
    q:(OEItmRowidGroup="") ContInfo
	
    s InputInfo=##class(web.DHCRisResourceApptSchudle).GetFormatInfo(OEItmRowidGroup)
    s ContInfo=##class(web.DHCRisResourceApptSchudle).RequestKnowledgeInfo("Q",InputInfo,"","3")
 
	q ContInfo
}

/// guanhantain，2015-01-27
/// w ##class(web.DHCRisApplicationBill).InvokeHISLog(^DHCRISTMP("ModelName"),^DHCRISTMP("OEORowid"),^DHCRISTMP("SecretDesc"))
ClassMethod InvokeHISLog(ModelName As %String, OEORowid As %String, SecretDesc As %String) As %String
{
	s ret=""
	s ret=##class(web.DHCRisCommFunctionEx).IsValidClassName("web.DHCEventLog")
	q:(ret=0) ""
	
	i ModelName="" d
	.s ModelName="DHCPACSPRINTAPP"
	
	s Condition="{OEORowid:"""_OEORowid_""",Date:"""_+$h_""",Time:"""_$p($h,",",2)_"""}"   //两个双引号代表一个双引号
	
	s orderrowid=$p(OEORowid,"||",1)
	s paadmdr=$p(^OEORD(orderrowid),"^",1)
	s papatmasmdr=$p(^PAADM(paadmdr),"^",1)      
    s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
    s Content="{EpisodeId:"""_paadmdr_""",Patient:"""_RegNo_""",OEORowid:"""_OEORowid_"""}"
    s SecretCode=""
    i SecretDesc="" d
    .Set SecretCode=$O(^User.DHCSecretLevelI("Code",""),-1)
    .Set SecretLevelRowId=$O(^User.DHCSecretLevelI("Code",SecretCode,""))
	.Set SecretCode=$lg(^User.DHCSecretLevelD(SecretLevelRowId),2)
    e  d
	.&sql(select Level_Code into :SecretCode from DHC_SecretLevel where Level_Desc=:SecretDesc)  //7.2以下库没有此表
    s res=##class(web.DHCEventLog).EventLog(ModelName, Condition, Content, SecretCode)
    q res
}

/// ///////////////////////////////////////TEST/////////////////////////////////////////////////
/// w ##class(web.DHCRisApplicationBill).GetRRowid("10||33:10||32")
ClassMethod GetRRowid(MutiOrd) As %String
{
 

 s count=0
 s count=$l(MutiOrd,":") //获取里list的长度进行循环
 s lastAppRowid=""
 s SameApp="Y"
 s AppInfo=""
 s NoSameApp=""
 
  for i=1:1:count
  {
	 s perMutiOrd="",AppRowid=""
	 s perMutiOrd=$p(MutiOrd,":",i)	
	 s AppRowid=$o(^DHCRBAppOrdi(0,perMutiOrd,0))
	 i (lastAppRowid'="")&(lastAppRowid'=AppRowid ) d  
	 .s SameApp="N"
	 i AppInfo="" s AppInfo=AppRowid
	 e  d
	 .s AppInfo=AppInfo_"@"_AppRowid
	 s lastAppRowid=AppRowid  
  }
  
  i (AppInfo'="")&(SameApp="N")
  {
	  s NoSameApp=..SplitAppArray(AppInfo)
  }
  w !,"NoSameApp="_NoSameApp
  q AppInfo
}

ClassMethod SplitAppArray(AppRowidArray) As %String
{
	s SameCount=0
	s SameCount=$l(AppRowidArray,"@") 
	s perSameAppRowid=""
	
	s SetInfo=""
	
	for j=1:1:SameCount 
    {
	   s perSameAppRowid=$p(AppRowidArray,"@",j)
	   
       i (perSameAppRowid'="")  d
	   .i $g(SameAppArray(perSameAppRowid))="" d
	   ..s SameAppArray(perSameAppRowid)=perSameAppRowid
		       
    }
	
   s SameRowid="" f  s SameRowid=$o(SameAppArray(SameRowid)) q:(SameRowid="")  d
   .i SetInfo="" s SetInfo=SameAppArray(SameRowid)
   .e  d
   ..s SetInfo=SetInfo_"@"_SameAppArray(SameRowid)

   k SameAppArray
   
   q SetInfo
}

/// w ##class(web.DHCRisApplicationBill).SplitMutiord("22770")
ClassMethod SplitMutiord(perAppRowid)
{
	q:(perAppRowid="")
	
	s OrdItemGroup=""
	s Appsub=0 f  s Appsub=$o(^DHCRBAppOrd("OrdItem",perAppRowid,Appsub)) q:(Appsub="")  d
	.s OEOrdItemID="",OrderRowid="",itemsub="",approwid="",regrowid=""
	.s OEOrdItemID=$p($g(^DHCRBAppOrd("OrdItem",perAppRowid,Appsub)),"^",1)
	.s OrderRowid=$p(OEOrdItemID,"||",1)
	.s itemsub=$p(OEOrdItemID,"||",2)
	.i $g(^OEORD(OrderRowid,"I",itemsub,6))'="" s approwid=$p($g(^OEORD(OrderRowid,"I",itemsub,6)),"^",5)
	.q:(approwid'="")
	.s regrowid=$o(^DHCPACRegInfoi("OEORI",OEOrdItemID,0))
	.q:(regrowid'="")
	.q:(OEOrdItemID="")
	.i OrdItemGroup="" s OrdItemGroup=OEOrdItemID
	.e  d
	..s OrdItemGroup=OrdItemGroup_"@"_OEOrdItemID
	
	q OrdItemGroup
}

/// ////////////////////////////////////测试//////////////////////////////////////
/// w ##class(web.DHCRisApplicationBill).GetAppBillPrintData("3||64")
/// sunyi 2014-09-10
ClassMethod GetAppBillPrintDataZY(OeOrditemID As %String) As %String
{
	s Info=""
	q:(OeOrditemID="") Info
	
	s perOeOrditemID=""
	s perOeOrditemID=$p(OeOrditemID,"@",1)
	s perOrderRowid=$p(perOeOrditemID,"||",1)
	s peritemsub=$p(perOeOrditemID,"||",2)
	
	s RecLocDR="",paadmdr="",patienttype="",admLocdr=""
	s RecLocDR=$p(^OEORD(perOrderRowid,"I",peritemsub,3),"^",6)
	
	s paadmdr=$p(^OEORD(perOrderRowid),"^",1)
    i paadmdr'="" d
    .s patienttype=$p(^PAADM(paadmdr),"^",2) 
    .s admLocdr=$p($g(^PAADM(paadmdr)),"^",4)
    
  //获取科室地址信息
  s Info=..GetBKLocationZY(RecLocDR,patienttype,admLocdr)
	
	//获取卡信息,guanhantian,2014-10-29
	s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
	s GetRegNo=$p(PatInfo,"^",1)
	s cardinfo=##class(web.DHCRisCommFunctionEx).GetCardInfoByRegNo(GetRegNo)
	s cardtype=$p(cardinfo,",",2)
	i cardtype="" s cardtype="卡号"
	i cardtype="北京医保卡" s cardtype="社保卡号"
	i cardtype="京医通卡" s cardtype="京医通卡号"
	i cardtype="院内条码卡" s cardtype="院内条码卡号"
	s Info=Info_"^"_cardtype_":"
	
	q Info
}

ClassMethod GetBKLocationZY(LocDR As %String, Pattype As %String, admLocdr As %String) As %String
{
	s Locaction="^"
	q:(LocDR="") Locaction
	s LocSetRowid="",RecLocAddress="",BookedAddress=""
	
	s LocSetRowid=$o(^DHCRBCLocationi("Rec-LocDR",LocDR,LocSetRowid)) 
	i (LocSetRowid'="") 
	{
       s RecLocAddress=$p($g(^DHCRBCLocation("LOCATION",LocSetRowid)),"^",2)
       s BookedAddress=$p($g(^DHCRBCLocation("LOCATION",LocSetRowid)),"^",3)
 
       i ((LocDR="155")||(LocDR="156")) d
       .i (Pattype="O") s RecLocAddress="门诊楼二层B超室"
       .;i (Pattype="I") s RecLocAddress="病房楼三层B超室"
       .i ((Pattype="I")||(admLocdr="118")) s RecLocAddress=""
       s Locaction=RecLocAddress_"^"_BookedAddress
	}
	
	q Locaction
}

/// Query:QueryItemToPosture
/// 功能：根据医嘱项目查询对应的体位
/// 作者：sunyi
/// 日期：2011-12-02
/// d ##class(%ResultSet).RunQuery("web.DHCRisApplicationBill","QueryBodyPartToPosture","14")
Query QueryBodyPartToPosture(InBodyPartId As %String) As %Query(ROWSPEC = "BodyPartId:%String,PostureID:%String,PostureDesc:%String")
{
}

ClassMethod QueryBodyPartToPostureExecute(ByRef qHandle As %Binary, InBodyPartId As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 s ind=1
 i InBodyPartId="" Set qHandle=$lb(0,repid,0)
 Quit:InBodyPartId="" $$$OK
 
 s PostureID=0 f  s PostureID=$o(^DHCRBCi("PosturetoBodyPart",0,InBodyPartId,PostureID)) q:PostureID=""  d
 .s PostureDesc=$p($g(^DHCRBC("PosturetoBodyPart",PostureID)),"^",2)
 .d OutBodyPartToPosture
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutBodyPartToPosture
 set Data=$lb(InBodyPartId,PostureID,PostureDesc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

//SG_YB

ClassMethod QueryBodyPartToPostureFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBodyPartToPostureExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryBodyPartToPostureClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBodyPartToPostureExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// w ##class(web.DHCRisApplicationBill).GetPostureListbyPartID("14")
ClassMethod GetPostureListbyPartID(BodyPartID As %String) As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisApplicationBill:QueryBodyPartToPosture")
	kill ^DHCRISPOSTURETMP("PostureList",$J)
	s ret=""
	s count=0
	do rset.Execute(BodyPartID)
	while (rset.Next())
	{
	   if (rset.GetData(3)'="") set ^DHCRISPOSTURETMP("PostureList",$J,rset.GetData(3))=rset.GetData(2)
	}
	d rset.Close()
	set PostureDesc=""
	while($order(^DHCRISPOSTURETMP("PostureList",$J,PostureDesc))'="")
	{
		set PostureDesc=$order(^DHCRISPOSTURETMP("PostureList",$J,PostureDesc))
		set PostureID=^DHCRISPOSTURETMP("PostureList",$J,PostureDesc)
		i ret="" s ret=PostureID_"-"_PostureDesc
	    e  s ret=ret_"@"_PostureID_"-"_PostureDesc
	}
	kill ^DHCRISPOSTURETMP("PostureList",$J)	
	
	q ret
}

/// 南山医院修改发送申请单成功后，调用接口程序。
/// sunyi-2015-09-11
/// w ##Class(web.DHCRisApplicationBill).InsertAppToPACS("3||108")
ClassMethod InsertAppToPACS(OeOrditemID As %String) As %String
{
	q:(OeOrditemID="") "1"
	s pacsret=0
	s FirstOrditem=$p(OeOrditemID,"@",1)
	s AppRowid="",GetRecLocDR="",XMLConent="",RecLocCode=""
	s AppRowid=$o(^DHCRBAppOrdi(0,FirstOrditem,0))
	w !,"AppRowid="_AppRowid
	i AppRowid'="" s XMLConent=$g(^DHCRBApp("Bill",AppRowid,"XMLContent"))
	s GetRecLocDR=$p(^OEORD($p(FirstOrditem,"||",1),"I",$p(FirstOrditem,"||",2),3),"^",6)
	w !,"XMLConent="_XMLConent
	i ((GetRecLocDR'="")&(GetRecLocDR'=" ")) d
	.s RecLocCode=$p(^CTLOC(GetRecLocDR),"^",1)

    ;s ret=##class(RISService.InvokeRISService).InvokeInsertApp(OeOrditemID,XMLConent)
    ;对应的科室代码可以通过 SELECT * FROM CT_LOC查询，查看.南山妇幼的超声科为"妇幼功能科超声"
	;现在开启CT接口，其他开启之修改此代码
	
	i ((RecLocCode="妇幼功能科超声")!(RecLocCode="妇幼功能科放射")!(RecLocCode="妇幼功能科心电图")!(RecLocCode="蛇口超声诊断科")!(RecLocCode="蛇口放射科")!(RecLocCode="蛇口胃镜室")!(RecLocCode="4002")!(RecLocCode="4016")!(RecLocCode="4018")!(RecLocCode="4019")!(RecLocCode="4022")!(RecLocCode="M030")!(RecLocCode="M031")!(RecLocCode="XL4008")!(RecLocCode="XL4002")!(RecLocCode="XL4001")) d
    .s ^DHCRISAPPSEND1(OeOrditemID)=OeOrditemID
    .s pacsret=##class(RISService.InvokeRISService).InsertAppPACS(OeOrditemID,XMLConent)
    
    q pacsret
}

/// w ##Class(web.DHCRisApplicationBill).GetKnowledgeItemBodyPart("3||108","股动脉&股静脉")
ClassMethod GetKnowledgeItemBodyPart(OeOrditemIDGroup As %String, BodyPart As %String = "") As %String
{
	q:(OeOrditemIDGroup="") ""
	s BodyPartCode=""
	s BPCount=0
	s ArrayItem=""
	
	i (BodyPart'="")
	{
		s BPCount=$l(BodyPart,"&")
		for i=1:1:BPCount 
        {
		   s perBodyPart=$p(BodyPart,"&",i)
		   s perBodyPart=$ZCONVERT(perBodyPart,"U")
		   s BPRowId="",perCode=""
		   s BPRowId=$o(^MRC("BODP",0,"Desc",perBodyPart,BPRowId))
		   i BPRowId'="" d
		   .s perCode=$p(^MRC("BODP",BPRowId),"^",1)
		   .i BodyPartCode="" d
		   ..s BodyPartCode=perCode
		   .e  d
		   ..s BodyPartCode=BodyPartCode_":"_perCode
     
        }
	}
	
	i (BodyPartCode'="")
	{
		s ItemCount=0
		s ItemCount=$l(OeOrditemIDGroup,"@")
		for j=1:1:ItemCount 
        {
	       s perItemID=$p(OeOrditemIDGroup,"@",j) 
	       i ArrayItem="" d
	       .s ArrayItem=perItemID_"^"_BodyPartCode
	       e  d
	       .s ArrayItem=ArrayItem_$c(2)_perItemID_"^"_BodyPartCode
        }
	}
	
	q ArrayItem
}

}
