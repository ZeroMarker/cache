Import SQLUser

Class web.DHCRisDoctorBook Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 根据申请科室获取是否配置的预约资源标记
/// sunyi 2014-04-13	
/// w ##class(web.DHCRisDoctorBook).GetEqSetFlag("83")
ClassMethod GetEqSetFlag(LoginLocDR As %String) As %String
{
	 s Flag="N"
	 q:(LoginLocDR="") Flag
	 s Rowid=""
	 s Rowid=$o(^DHCRBCLocResourceSeti("App-Loc",LoginLocDR,Rowid))
	 i Rowid'="" s Flag="Y"
	 q Flag
}

/// 根据登陆用户获取所在科室
/// sunyi 2014-04-13	
/// w ##class(web.DHCRisDoctorBook).GetAppLocDRbyUser("687")
ClassMethod GetAppLocDRbyUser(SSURowid As %String) As %String
{
	s AppLocDR="",Flag="N"
	q:(SSURowid="") "^N"
	
	i SSURowid'="" d
	.s AppLocDR=$p($g(^SSU("SSUSR",SSURowid)),"^",4)
	.i AppLocDR'="" s Flag=..GetEqSetFlag(AppLocDR) 
	
	q AppLocDR_"^"_Flag
}

/// 根据就诊获取病人所院区
/// w ##class(web.DHCRisDoctorBook).GetPatientHospital("20019")
ClassMethod GetPatientHospital(paadmdr As %String) As %String
{
	 q:(paadmdr="") ""
	 s HospitalDR=$p($g(^PAADM(paadmdr,2)),"^",85)
	 i HospitalDR="" d
	 .s Docdr="",SSURowid="",AppLocDR=""
	 .s Docdr=$p(^PAADM(paadmdr),"^",9) ;;benna added
     .i $g(Docdr)'="" d
	 ..s SSURowid=$o(^SSU("SSUSR",0,"CTPCP",Docdr,-1))
	 ..i SSURowid'="" s AppLocDR=$p($g(^SSU("SSUSR",SSURowid)),"^",4)
	 ..i AppLocDR'="" s HospitalDR=$p($g(^CTLOC(AppLocDR)),"^",22)
	 q HospitalDR
}

/// 根据就诊信息查询病人医嘱
/// d ##class(%ResultSet).RunQuery("web.DHCRisDoctorBook","QueryServiceOrder","20019")
Query QueryServiceOrder(paadmdr As %String) As %Query(ROWSPEC = "ExamOrder:%String,OrderName:%String,Status:%String,datestr:%String,timestr:%String,RptStatus:%String,PatientStatusCode:%String,ReportStatusCode:%String,BK:%String,RecLocDR:%String,SGroupDR:%String")
{
}

ClassMethod QueryServiceOrderExecute(ByRef qHandle As %Binary, paadmdr As %String) As %Status
{
 
 Set repid=$I(^CacheTemp)
 s ind=1
 s ret=0
 s PaAdmID=$p(paadmdr,$C(0))
 s ^ts=paadmdr
 
 s strOrderName="",strStdate="",strAccessionNumber="",strExamOrder=""
 s strDateCreated="",strTimeCreated="",strSeriesModality=""
 s numb="",AppType="",RRowid=""
 s ordrowid=0,itmsub=0,Maxitmsub="",DHCRisSystemInfo="",DHCRisVersion=""
 
 i PaAdmID'="" d
  .f  s ordrowid=$o(^OEORD(0,"Adm",PaAdmID,ordrowid)) q:(ordrowid="")  d
  ..s itmsub=0 f  s itmsub=$o(^OEORD(ordrowid,"I",itmsub)) q:(itmsub="")  d
  ...s GetPatientStatusCode="",GetReportStatusCode=""
  ...s GetPatientStatus="",RejectAppReason=""
  ...s tmpItemStatus="",ItemCode="",RecLocDR="",ServerGroupDR=""
  ...s ordInfo="",IsBK="N",BK="未预约"
  ...s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(ordrowid, itmsub)
  ...q:(ordInfo="")
  ...s GetstrOrderName=$p(ordInfo,"^",1)
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
  ...s ServerGroupDR=$p($g(ordInfo),"^",36)
  ...q:(GetServerMaterial'="Service")&(GetServerMaterial'="S")
  ...q:(GetItemStatusCode'="V")&(GetItemStatusCode'="E")
  ...;获得申请单的使用样式
  ...s AppType=""
  ...s ExamOrder=ordrowid_"||"_itmsub
  ...s Info=##class(web.DHCRisApplicationBill).GetAppShape(ExamOrder)
  ...s AppType=$p(Info,"^",3)
  ...s RRowid="",bedone=""
  ...s RRowid=$o(^DHCRBAppOrdi(0,ExamOrder,0)) 
  ...s GetPatientStatusCode="",GetPatientStatus="",GetReportStatus=""
  ...i RRowid'="" d
  ....s GetPatientStatusCode="A"  ;申请
  ....s GetRejDR=$o(^DHCRBRejecti("OeordDR",ExamOrder,0))
  ....i GetRejDR'="" d
  .....s GetPatientStatusCode="RJ" ;----------拒绝申请
  ....else  d
  .....;------------------------- 显示预约信息
  .....i $g(^OEORD(ordrowid,"I",itmsub,6))'="" d
  ......s Getapprowid=$p(^OEORD(ordrowid,"I",itmsub,6),"^",5)
  ......i (Getapprowid'="")&(Getapprowid'=$C(0)) d
  .......s GetPatientStatusCode="B" s IsBK="Y"
  .......i IsBK="Y" s BK="已预约"
  .....s DetailRowid="",CAFlag=""
  .....s DetailRowid=$o(^DHCRBCResSchduleDetaili(0,ExamOrder,0)) 
  .....i DetailRowid'="" s CAFlag=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",7)
  .....i ((CAFlag'="Cancel")&(DetailRowid'="")) s GetPatientStatusCode="B" s IsBK="Y"
  .....i IsBK="Y" s BK="已预约"
  .....;------------------------------------------ 显示登记信息
  .....s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfo(ExamOrder)
  .....s GetStudyNo=$p(RegInfo,"^",1)
  .....i GetStudyNo'="" d
  ......s GetPatientStatusCode="I"
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
  ...i GetPatientStatusCode'="" s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
  ...i GetReportStatusCode'="" s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
  ...;s tmpItemStatus=##class(web.DHCRisclinicQueryOEItemDo).GetOEOrdStatus(ordrowid,itmsub)
  ...;s GetPatientStatus=$p(tmpItemStatus,"^",1)
  ...;s ItemCode=$p(tmpItemStatus,"^",2)
  ...;i ItemCode="A" s GetPatientStatus=""
  ...;i ItemCode="E" s GetPatientStatus="正在申请"
  ...Do OutServiceOrder
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutServiceOrder
 
 set Data=$lb(ExamOrder,GetstrOrderName,$g(GetPatientStatus),$g(GetstrDate),$g(GetstrTime),$g(GetReportStatus),$g(GetPatientStatusCode),$g(GetReportStatusCode),$g(BK),$g(RecLocDR),$g(ServerGroupDR))
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QueryServiceOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryServiceOrderExecute ]
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

ClassMethod QueryServiceOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryServiceOrderExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 函数：QueryResSchduleEx
/// 功能：查询设备的预约资源
/// 参数：oeorditem.Rowid,CT_Loc.Rowid,RB_Resouce.Rowid,日期
/// 作者：sunyi
/// 日期: 2014-04-13
/// /// d ##class(%ResultSet).RunQuery("web.DHCRisDoctorBook","QueryResSchduleEx","83","Y","20017||3887","83","","63292")
Query QueryResSchduleEx(AppLocDR As %String, Flag As %String, OrditemRowid As %String, LocId As %String, ResourceId As %String, BookDate As %String) As %Query(ROWSPEC = "BookedDate:%String,TimeDesc:%String,ServiceGroupDesc:%String,StartTime:%String,EndTime:%String,Resource:%String,MaxNumber:%String,UseNumber:%String,RemainNumber:%String,AutoNumber:%String,AutoUseNumber:%String,Rowid:%String,ChargeTime:%String,HasBK:%String")
{
}

ClassMethod QueryResSchduleExExecute(ByRef qHandle As %Binary, AppLocDR As %String, Flag As %String, OrditemRowid As %String, LocId As %String, ResourceId As %String, BookDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//s ^t=AppLocDR_"^"_Flag_"^"_OrditemRowid_"^"_LocId_"^"_ResourceId_"^"_BookDate
 	k ^DHCRISSCHDULETMP("RISOLD")
 	i BookDate'="" s BookDate=$zdh(BookDate,"3")
 	i BookDate="" s BookDate=+$h
 	s HasBK=""
 	
    if ((Flag="Y")&(AppLocDR'=""))
    {
	    s GetResSchduleID="",ResSchduleID=""
	    i OrditemRowid'="" s GetResSchduleID=##class(web.DHCRisResourceApptSchudleEx).GetSchduleID(OrditemRowid)
	    i GetResSchduleID'="" d
	    .s ResSchduleID=GetResSchduleID
	    .s GetResource=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)
		.s IsBooked="Y"
		.s ^DHCRISSCHDULETMP("RISOLD")=GetResSchduleID
		.s HasBK="Y"
		.Do OutRow5
		
	    s Rowid=""  f  s Rowid=$o(^DHCRBCLocResourceSeti("App-Loc",AppLocDR,Rowid)) q:(Rowid="")  d
	    .s ResourceDR="", RecLocDR="",HasBK=""
	    .s ResourceDR=$p($g(^DHCRBCLocResourceSet("LoginLocRes",Rowid)),"^",2)
	    .s RecLocDR=$p($g(^DHCRBCLocResourceSet("LoginLocRes",Rowid)),"^",4)
	    .q:(ResourceDR="")
	    .q:(RecLocDR="")
	    .s ResSchduleID=0 f  s ResSchduleID=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",RecLocDR,BookDate,ResourceDR,ResSchduleID)) q:ResSchduleID=""  d
	    ..q:((GetResSchduleID'="")&($g(^DHCRISSCHDULETMP("RISOLD"))=ResSchduleID))
	    ..s GetResource=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)  
		..q:(ResourceId'="")&(GetResource'=ResourceId)
	    ..s IsBooked=""
	    ..Do OutRow5
	}
	else
	{
	 	if (OrditemRowid'="")  
	 	{
		 	s ResSchduleID=##class(web.DHCRisResourceApptSchudleEx).GetSchduleID(OrditemRowid)
		 	i ResSchduleID'="" d
		 	.s IsBooked="Y"
		 	.s ^DHCRISSCHDULETMP("RISOLD")=ResSchduleID
		 	.s HasBK="Y"
		 	.Do OutRow5
		  	s OrderRowid=$p(OrditemRowid,"||",1)
		 	s ItemRowid=$p(OrditemRowid,"||",2)
		 	s ArcItemId=$p(^OEORD(OrderRowid,"I",ItemRowid,1),"^",2)
		 	s ServcieGroupId=$p(^ARCIM($p(ArcItemId,"||",1),$p(ArcItemId,"||",2),8),"^",7)
		 	i ServcieGroupId'="" d
		 	.; 查询服务组的资源计划
		 	.s ResSchduleID=0 f  s ResSchduleID=$o(^DHCRBCResSchdulei("SericeGroup",ServcieGroupId,BookDate,ResSchduleID)) q:ResSchduleID=""  d
		 	..s HasBK=""
		 	..s GetLocId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",11) 
		 	..s GetResource=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)  
		 	..q:(ResourceId'="")&(GetResource'=ResourceId)
		 	..q:($g(^DHCRISSCHDULETMP("RISOLD"))=ResSchduleID)
		 	..;w !,GetLocId_"^"_LocId
		 	..q:GetLocId'=LocId
		 	..s IsBooked=""
		  	..s bFindBookeInfo=1
		 	..Do OutRow5
		 ;查询没有设置服务组的所有资源的预约计划,没有设置服务组的所有的医嘱都可以预约此设备
		 .;s GetResourceId=0 f  s GetResourceId=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",LocId,BookDate,GetResourceId)) q:GetResourceId=""  d
		 .;q:(ResourceId'="")&(ResourceId'=GetResourceId)
		 .;s ResSchduleID=0 f  s ResSchduleID=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",LocId,BookDate,GetResourceId,ResSchduleID)) q:ResSchduleID=""  d
		 .;.s ServiceGroupId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",4)
	     .;.d OutRow5 
	 	}
	 	else 
	 	{
		  i LocId="" s qHandle=$lb(0,repid,0)
		  Quit:LocId="" $$$OK
		  i ResourceId="" d
		  .s ResourceId=0 f  s ResourceId=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",LocId,BookDate,ResourceId)) q:ResourceId=""  d
		  ..s ResSchduleID=0 f  s ResSchduleID=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",LocId,BookDate,ResourceId,ResSchduleID)) q:ResSchduleID=""  d
		  ...d OutRow5
		  else  d
		  .s ResSchduleID=0 f  s ResSchduleID=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",LocId,BookDate,ResourceId,ResSchduleID)) q:ResSchduleID=""  d
	  	  ..d OutRow5 
	 	}
 	
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRow5

     s ResouceId=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",1)
	 s ResourceDesc=""
	 i ResouceId'="" d
	 .s EqId=$p($g(^RB("RES",ResouceId)),"^",3)
	 .s CareProvId=$p($g(^RB("RES",ResouceId)),"^",2)
	 .i EqId'="" s ResourceDesc=$p($g(^RBC("EQ",EqId)),"^",2)
	 .i CareProvId'="" s ResourceDesc=$p(^CTPCP(CareProvId,1),"^",2)
	 s Date=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",2)
	 s BookedDate=$zd(Date,3)
	 s TimeDescCode=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",3)
	 s TimeDesc=""
	 i TimeDescCode'="" d
	 .s TimeDescRowid=$o(^DHCRBCTimePeriodSeti("Code",TimeDescCode,0))
	 .s TimeDesc=$p(^DHCRBCTimePeriodSet(TimeDescRowid),"^",2)
	 
	 s ServiceGroupId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",4)
	 s ServiceGroupDesc=""
	 i ServiceGroupId'="" d
	 .s ServiceGroupDesc=$p(^RBC("SG",ServiceGroupId),"^",2) 
	 s StartTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",5)
	 s StartTime=$zt(StartTime)
	 s EndTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",6)
	 s CurrentTime=$p($h,",",2)
	 s CurrentDate=+$h
	 q:(((Date=CurrentDate)&(EndTime<CurrentTime))!(Date<CurrentDate))&($g(IsBooked)="")
	 ;q:((Date=CurrentDate)&(EndTime<CurrentTime))!(Date<CurrentDate)
	 s EndTime=$zt(EndTime)
	 s MaxNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",7)   ;最大的预约数
	 ;q:(MaxNumber="0")
	 s AutoNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",8)  ;自动预约数
	 s UseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",9)  ;总的预约使用数量
	 s RemainNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",10) ; 总的剩余数
	 s AutoUseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",13) ; 自动使用数
	 s ChargeTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",14)
	 s ChargeTime=$zt(ChargeTime)

    set Data=$lb(BookedDate,TimeDesc,ServiceGroupDesc,StartTime,EndTime,ResourceDesc,MaxNumber,UseNumber,RemainNumber,AutoNumber,AutoUseNumber,ResSchduleID,ChargeTime,HasBK)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryResSchduleExFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryResSchduleExExecute ]
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

ClassMethod QueryResSchduleExClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryResSchduleExExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 查询名称：QueryResource
/// 功能：查询登陆科室设备 或根据选中医嘱初始化设备列表
/// 参数：AppLoc:科室ROWID,Flag,OrditemRowid,BookDate
/// 返回：资源列表 
/// 作者：孙毅
/// 日期：2007-03-08
/// d ##class(%ResultSet).RunQuery("web.DHCRisDoctorBook","QueryRes","83","Y","20017||3887","")
/// d ##class(%ResultSet).RunQuery("web.DHCRisDoctorBook","QueryRes","","","20017||3887","")
Query QueryRes(AppLocDR As %String = "", AppFlag As %String, OrditemRowid As %String = "", BookDate As %String) As %Query(ROWSPEC = "TResDesc:%String,TRowid:%String")
{
}

ClassMethod QueryResExecute(ByRef qHandle As %Binary, AppLocDR As %String, AppFlag As %String, OrditemRowid As %String, BookDate As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=2

    i BookDate="" s BookDate=+$h
    
    if ((AppFlag="Y")&(AppLocDR'=""))
    {
	    s Rowid="" f  s Rowid=$o(^DHCRBCLocResourceSeti("App-Loc",AppLocDR,Rowid)) q:(Rowid="")  d
	    .s ResourceDR="", RecLocDR=""
	    .s ResourceDR=$p($g(^DHCRBCLocResourceSet("LoginLocRes",Rowid)),"^",2)
	    .s RecLocDR=$p($g(^DHCRBCLocResourceSet("LoginLocRes",Rowid)),"^",4)
	    .q:(ResourceDR="")
	    .q:(RecLocDR="")
	    .s EQDR=$p(^RB("RES",ResourceDR),"^",3)
	    .i EQDR'="" s ResDesc=$p(^RBC("EQ",EQDR),"^",2)
	    .DO OutputResRow
	}
	else
	{
		k ^DHCRISQUERYRESOURCE("RISRES")
		
		i (OrditemRowid'="")
		{
			s ArcItemId="",ResourceDR="",ResDesc=""
			s OrderRowid=$p(OrditemRowid,"||",1)
		 	s ItemRowid=$p(OrditemRowid,"||",2)
		 	s ArcItemId=$p(^OEORD(OrderRowid,"I",ItemRowid,1),"^",2)
		 	s ServcieGroupId=$p(^ARCIM($p(ArcItemId,"||",1),$p(ArcItemId,"||",2),8),"^",7)
		 	i ServcieGroupId'="" d
		 	.; 查询服务组的资源计划
		 	.s ResSchduleID=0 f  s ResSchduleID=$o(^DHCRBCResSchdulei("SericeGroup",ServcieGroupId,BookDate,ResSchduleID)) q:ResSchduleID=""  d
		 	..s ResourceDR="",ResDesc=""
		 	..s ResourceDR=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",1)
		 	..q:($g(^DHCRISQUERYRESOURCE("RISRES"))=ResourceDR) 
		 	..s ^DHCRISQUERYRESOURCE("RISRES")=ResourceDR
		 	..q:(ResourceDR="")
		 	..s EQDR=$p(^RB("RES",ResourceDR),"^",3)
	        ..i EQDR'="" s ResDesc=$p(^RBC("EQ",EQDR),"^",2)
	        ..DO OutputResRow
		}
		
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	

OutputResRow
	set Data=$lb($g(ResDesc),ResourceDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ^CacheTemp(repid,1)=$lb("所有","")
 	
 	Set ind=ind+1
	quit
}

ClassMethod QueryResFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryResExecute ]
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

ClassMethod QueryResClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryResExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##class(web.DHCRisDoctorBook).SetBookedInfo("20017||3881@20017||3886^6738^Y^Y^685^20019")
ClassMethod SetBookedInfo(Info As %String) As %String
{
	s OrderItemRowid=$p($g(Info),"^",1)
	s ResSchduleID=$p($g(Info),"^",2)
	s Flag=$p($g(Info),"^",3) 
	s IsBk=$p($g(Info),"^",4) 
	s UserID=$p($g(Info),"^",5)
	s paadmdr=$p($g(Info),"^",6)
	
	s Result="-1^0",GetParamInfo=""
	q:((ResSchduleID="")!(OrderItemRowid="")!(paadmdr="")) Result
	
	if IsBk'="Y" d
	.s AppMethodDR="1"
	e  d
	.s AppMethodDR="2"
	
	s InitParam=""
	s InitParam=..GetBookedParam(paadmdr,OrderItemRowid,ResSchduleID,Flag,UserID,AppMethodDR)
	q:(InitParam="") Result
	
	if (IsBk'="Y")
	{
		s Result=..InsertBookedData(InitParam)
	}
	else
	{
		s Result=..ReBookedData(InitParam)
	}
	
	q Result
}

/// w ##class(web.DHCRisDoctorBook).GetBookedParam("20019","20017||3881@20017||3880","6750","Y","685")
ClassMethod GetBookedParam(paadmdr As %String, OrderItemRowid As %String, ResSchduleID As %String, AppFlag As %String, UserID As %String, AppMethodDR As %String) As %String
{
	s (ResourcesInfo,GetEQDR,GetRoomDR,GroupDescDR,GetResDesc,GetRoomDesc,GroupDesc)=""
	s (RecLocDR,AppSetDR,perOrderItemRowid,Param,IsCIndex)=""
	s (IndexclsInfo,GetIndex,GetNoRuleCode,GetTypeDesc,GetAppDateType)=""
	s (Index,GroupIndex,RoomIndex,GetTypeRowid,MuitStudyNoInfo,SelectDate)=""
	s (OutParam,GetAppointMethod,PACSStudyNo)=""
	//w !,"AppFlag="_AppFlag
	s perOrderItemRowid=$p(OrderItemRowid,"@",1)
	s ResourcesInfo=..InitSelResources(ResSchduleID)
	i ResourcesInfo'="" d
	.s GetEQDR=$p($g(ResourcesInfo),"^",1)
	.s GetRoomDR=$p($g(ResourcesInfo),"^",2)
	.s GroupDescDR=$p($g(ResourcesInfo),"^",3)
	.s GroupDesc=$p($g(ResourcesInfo),"^",6)
	.s SelectDate=$p($g(ResourcesInfo),"^",7)
	.s RecLocDR=$p(^OEORD($p(perOrderItemRowid,"||",1),"I",$p(perOrderItemRowid,"||",2),3),"^",6)
	.i AppFlag="Y" s AppSetDR=$o(^DHCRBCLocResourceSeti("Booked-Resource",GetEQDR,AppSetDR))
	.i AppSetDR'="" s RecLocDR=$p($g(^DHCRBCLocResourceSet("LoginLocRes",AppSetDR)),"^",4)
	.s Param=GetEQDR_"^"_GroupDescDR_"^"_GetRoomDR_"^"_RecLocDR_"^"_perOrderItemRowid_"^"_ResSchduleID
	.s IsCIndex=##class(web.DHCRisResourceApptSchudleEx).IsUseUpdateNo(RecLocDR)
	.i IsCIndex'="" s IsCIndex=$p(IsCIndex,"^",1)
	.i IsCIndex="B" d
	..s IndexclsInfo=##class(web.DHCRisPatRegisterDoEx).GetIndexcls(Param)
	..i IndexclsInfo'="" d
	...s GetIndex=$p(IndexclsInfo,"^",1)
	...s GetNoRuleCode=$p(IndexclsInfo,"^",2)
	...s GetTypeDesc=$p(IndexclsInfo,"^",3)
	...s GetAppDateType=$p(IndexclsInfo,"^",4)
	...s GetTypeRowid=$p(IndexclsInfo,"^",5)
	...i GetNoRuleCode="L" s Index=GetIndex
	...i GetNoRuleCode="Z" s GroupIndex=GetIndex
	...i GetNoRuleCode="R" s RoomIndex=GetIndex
	.s MuitStudyNoInfo=..GetMuitStudyNo(OrderItemRowid,GroupDesc,GroupDescDR,RecLocDR,SelectDate)
	.i MuitStudyNoInfo'="" d
	..s OutParam=OrderItemRowid_"^"_ResSchduleID_"^"_AppMethodDR_"^^"_MuitStudyNoInfo_"^"_GetIndex_"^"_GroupIndex_"^"_RoomIndex_"^"_GetEQDR_"^"_GroupDescDR_"^"_GetRoomDR
	..s OutParam=OutParam_"^"_paadmdr_"^"_GetTypeRowid_"^"_$zdh(SelectDate,"3")_"^"_UserID_"^"_PACSStudyNo_"^"_AppFlag_"^"_RecLocDR
	
	q OutParam
}

ClassMethod GetMuitStudyNo(OrderItemRowid, GroupDesc, GroupDescDR, RecLocDR, SelectDate) As %String
{
	k ^DHCRISCREATESTUDYNOSTMP("MUI-STUDYNO")
	s MutiStudyNo=""
	
	s Counts=$l(OrderItemRowid,"@")
    
    for i=1:1:Counts
    {  
        s persOrditemRowid="",Studyinfo="",StudyNumber=""
	    s persOrditemRowid=$p(OrderItemRowid,"@",i)
	    s IsMore=""
	    s IsMore=##class(web.DHCRisCodeTableSet).IsCreateMoreStudyNo(RecLocDR,persOrditemRowid,GroupDesc)
	    i ('$d(^DHCRISCREATESTUDYNOSTMP("MUI-STUDYNO",StudyNo))) d
	    .s StudyInfo=##class(web.DHCRisBookParam).GetStudyNo(persOrditemRowid,GroupDesc,RecLocDR,SelectDate)
	  
	    i (StudyInfo'="")
	    {
	        s StudyNo=$p($g(StudyInfo),"^",1)_$p($g(StudyInfo),"^",2)
	        s StudyNumber=$p($g(StudyInfo),"^",2)
	    
	        if ($p($g(StudyInfo),"^",3)="1")
	     	{
		       s gIsUpdate="1"
		    }
		    
		    if (gIsUpdate="1")
		    {
		
			    i ('$d(^DHCRISCREATESTUDYNOSTMP("MUI-STUDYNO",StudyNo))) d
			    .s ret=##class(web.DHCRisPatRegisterDoEx).updatenumber(RecLocDR,GroupDescDR,StudyNumber,SelectDate)
			    
			    if (IsMore'="Y")
			    {
				    s ^DHCRISCREATESTUDYNOSTMP("MUI-STUDYNO",StudyNo)=StudyNo
				}
				
			}
		    
		    if MutiStudyNo="" d
		    .s MutiStudyNo=StudyNo
		    e  d
		    .s MutiStudyNo=MutiStudyNo_"@"_StudyNo
		    
	    }
	}
	
	q MutiStudyNo
}

/// w ##class(web.DHCRisDoctorBook).InitSelResources("4119")
ClassMethod InitSelResources(SchudleRowid As %String)
{
	 s (ResourceId,ResDesc,CTCPDR,EQDR,ResDesc,RoomDR,GroupDescDR,RoomDesc,BookedDate,Info)=""
	 s (RoomDesc)=""
	 i SchudleRowid'="" d
     .s ResourceId=$p($g(^DHCRBCResourceSchdule(SchudleRowid)),"^",1)
     .s BookedDate=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",2)
	 .i BookedDate'="" s BookedDate=$zd(BookedDate,3)
     .s ResDesc=""
 	 .s CTCPDR=$p($g(^RB("RES",ResourceId)),"^",2)
     .s CTCPDR=$p(CTCPDR,$c(0))
     .i CTCPDR'="" d
     ..s ResDesc=$p($g(^CTPCP(CTCPDR,1)),"^",2)
     .else  d
     ..s EQDR=$p($g(^RB("RES",ResourceId)),"^",3)
     ..s ResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
     ..s RoomDR=$o(^DHCRBC("EQDR-ROOM",EQDR,""))
     ..i RoomDR'="" s RoomDesc=$p($g(^DHCRBC("Room",RoomDR)),"^",2)
     ..s GroupDescDR=$p($g(^RBC("EQ",EQDR)),"^",3)
     ..i GroupDescDR'="" s GroupDesc=$p($g(^RBC("GRP",GroupDescDR)),"^",2)
     .s Info=$g(EQDR)_"^"_$g(RoomDR)_"^"_$g(GroupDescDR)_"^"_$g(ResDesc)_"^"_$g(RoomDesc)_"^"_$g(GroupDesc)_"^"_$g(BookedDate)
    
    q Info
}

/// 插入预约
ClassMethod InsertBookedData(InParam As %String) As %String
{
	s ^DHCRis("Ris2015")=Info
	k ^DHCRISDOCTMP("STUDYNO")
	
	s OrderItemRowid=$p(InParam,"^",1)
	s ResSchduleID=$p(InParam,"^",2)
	s AppointMethod=$p(InParam,"^",3)      ; 1: 手动， 2：自动
	s OherParam=$p($g(InParam),"^",4)     //计费标识 HIS
	s MuitStudyNo=$p($g(InParam),"^",5)
	s RegEQIndex=$p($g(InParam),"^",6)
	s CheckGroupIndex=$p($g(InParam),"^",7)
	s RoomIndex=$p($g(InParam),"^",8)
	s EQDr=$p($g(InParam),"^",9)
    s EQGroupDR=$p($g(InParam),"^",10)
    s RoomDR=$p($g(InParam),"^",11)
    s paadr=$p($g(InParam),"^",12)
    s IndexTypeDR=$p($g(InParam),"^",13)
    s InputRegDate=$p($g(InParam),"^",14)
    i InputRegDate'="" s InputRegDate=$zd(InputRegDate,3)
    s UserDR=$p($g(InParam),"^",15)
    s GetStudyNo=$p($g(InParam),"^",16) //PACS传入的检查号
    s GetFlag=$p($g(InParam),"^",17)    ;登陆科室资源配置标记Y/N
    s GetRecLocDR=$p($g(InParam),"^",18) 
    s OperateDate=+$h
	s OperateTime=$p($h,",",2)
    
	i paadr'="" s patienttype=$p(^PAADM(paadr),"^",2) ;病人类型
	s DHCRisSystemInfo=##class(web.DHCRisCommFunction).GetSystemParam()
    s DHCRisVersion=$p($g(DHCRisSystemInfo),"^",15)
    
    Set $ZT="ERROR"	
    s Count=$l(OrderItemRowid,"@")
    
    for i=1:1:Count 
    {
	  s Arrearage="1"
      s perOrditemRowid=$p(OrderItemRowid,"@",i)
      s StudyNo=$p($g(MuitStudyNo),"@",i)
      i GetStudyNo'="" s StudyNo=GetStudyNo
      s OrdRowid=$p(perOrditemRowid,"||",1)
      s itemsub=$p(perOrditemRowid,"||",2)
	  s EpisodeID=$p(^OEORD(OrdRowid),"^",1)
	  
	  //医嘱对应的就诊记录是否一致
	  i (paadr'=EpisodeID)
	  {
		 s SQLCODE="-10002",ret="0"
		 q:SQLCODE
      }
      
     
	  s RecLocdr=$p($g(^OEORD(OrdRowid,"I",itemsub,3)),"^",6)
	  i GetRecLocDR'="" s RecLocdr=GetRecLocDR
	  
	  s UseInfo="",UpType="",AppDateType=""
	  s UseInfo=##class(web.DHCRisResourceApptSchudleEx).IsUseUpdateNo(RecLocdr)
	  i (UseInfo'="")
	  {
		 s UpType=$p(UseInfo,"^",1)
		 s AppDateType=$p(UseInfo,"^",2)
	  }
	  
	  if (UpType="I")
	  {
		  s RoomIndex=""
		  s CheckGroupIndex=""
		  s RegEQIndex=""
	  }else
	  {
	    if ('$d(^DHCRISDOCTMP("STUDYNO",StudyNo)))
	    {
		    s MaxParam="",MaxIndexInfo=""
		    s MaxParam=EQDr_"^"_EQGroupDR_"^"_RoomDR_"^"_RecLocdr_"^"_perOrditemRowid_"^"_InputRegDate
		    s MaxIndexInfo=##class(web.DHCRisPatRegisterDoEx).GetCurrentMaxIndex(MaxParam)
		    i MaxIndexInfo'="" d
		    .s RegEQIndex=$p(MaxIndexInfo,"^",1)
		    .s CheckGroupIndex=$p(MaxIndexInfo,"^",2)
		    .s RoomIndex=$p(MaxIndexInfo,"^",3)
		}
	
	  }
	  
	  s Arrearage=##Class(web.UDHCJFARREARSMANAGE).CheckArrearsLevel(EpisodeID,"A","完全控制")
	  i (Arrearage="1")
	  { 
	     s SQLCODE="-999",ret="0"
	     q:SQLCODE
	  }

	  s value=""
	  s value=RegEQIndex_"^"_CheckGroupIndex_"^"_RoomIndex_"^"_EQDr_"^"_EQGroupDR_"^"_RoomDR_"^"_AppDateType_"^"_InputRegDate
  	  s MaxNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",7) 
      s AutoNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",8)
      s UseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",9) 
      s RemainNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",10) 
      s AutoUseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",13)
	  i UseNumber="" s UseNumber=0
   	  i AutoUseNumber="" s AutoUseNumber=0
   	  
   	  s ItmPatTypeRowid=""
   	  s OrderRowid=$p(perOrditemRowid,"||",1)
   	  s itemsub=$p(perOrditemRowid,"||",2)
   	  s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
   	  s ItemBookeRowid=$o(^DHCRBCItemBookProperTypei(arcimid,0))
   	  s ItmPatTypeRowid=$o(^DHCRBCItemPatTypeSeti("Code",arcimid,patienttype,ItmPatTypeRowid))
   	  s MehtodDesc=""
   	  i ItemBookeRowid'="" d
   	  .s AppointmentMethodId=$p(^DHCRBCItemBookProperty(ItemBookeRowid),"^",2)
   	  .i AppointmentMethodId'="" d
   	  ..s MehtodDesc=$p(^DHCRBCAppointMethod(AppointmentMethodId),"^",2)
   	  
   	  i ItmPatTypeRowid'="" d
   	  .s AppointmentMethodId=$p($g(^DHCRBCItemPatTypeSet("ItemPatTypeSet",ItmPatTypeRowid)),"^",3)
   	  .i AppointmentMethodId'=""  s MehtodDesc=$p(^DHCRBCAppointMethod(AppointmentMethodId),"^",2)
      
      i ((MehtodDesc="无需预约")!(MehtodDesc="不需预约")) s SQLCODE=-1000,ret=0
      q:(MehtodDesc="无需预约")!(MehtodDesc="不需预约")    
     
      TSTART
      s SQLCODE=100
      
      s IsCancel=""
      s IsCancel=##class(web.DHCRisResourceApptSchudleEx).IsCancelBooked(perOrditemRowid)
    
      i (IsCancel="Y")
      {
	      i ((AppointMethod="2")&(AutoUseNumber<AutoNumber)!((AppointMethod'="2")&(MaxNumber>UseNumber)))
	      {
	        &sql(update DHCRBC_ResSchduleDetail (DRPD_ResSchdule_ID,DRPD_EpsoideID,DRPD_AppointMethod,DRPD_StudyNo,DRPD_EQ_Index,DRPD_CheckGroupIndex,DRPD_RoomIndex,DRPD_CAFlag,DRPD_EQ_DR,DRPD_EQGroup_DR,DRPD_Room_DR,DRPD_IndexType_DR,DRPD_AppointUser_DR,DRPD_Operate_Date,DRPD_Operate_Time)
	                           values (:ResSchduleID,:EpisodeID,:AppointMethod,:StudyNo,:RegEQIndex,:CheckGroupIndex,:RoomIndex,'Booked',:EQDr,:EQGroupDR,:RoomDR,:IndexTypeDR,:UserDR,:OperateDate,:OperateTime) where  DRPD_OrderItem_ID=:perOrditemRowid) 
	        i (AppointMethod="2")&(AutoUseNumber<AutoNumber) s AutoUseNumber=AutoUseNumber+1            
	      } 
      }                    
      else
      {
	     i ((AppointMethod="2")&(AutoUseNumber<AutoNumber)) d
	     .&sql(insert into  DHCRBC_ResSchduleDetail(DRPD_ResSchdule_ID,DRPD_OrderItem_ID,DRPD_EpsoideID,DRPD_AppointMethod,DRPD_StudyNo,DRPD_EQ_Index,DRPD_CheckGroupIndex
	                          ,DRPD_RoomIndex,DRPD_EQ_DR,DRPD_EQGroup_DR,DRPD_Room_DR,DRPD_IndexType_DR,DRPD_AppointUser_DR,DRPD_Operate_Date,DRPD_Operate_Time) 
	    					values (:ResSchduleID,:perOrditemRowid,:EpisodeID,:AppointMethod,:StudyNo,:RegEQIndex,:CheckGroupIndex,:RoomIndex,:EQDr,:EQGroupDR,:RoomDR,:IndexTypeDR,:UserDR,:OperateDate,:OperateTime)) 					
	     .s AutoUseNumber=AutoUseNumber+1
	     else  if (MaxNumber>UseNumber)  d
	      .&sql(insert into  DHCRBC_ResSchduleDetail(DRPD_ResSchdule_ID,DRPD_OrderItem_ID,DRPD_EpsoideID,DRPD_AppointMethod,DRPD_StudyNo,DRPD_EQ_Index,DRPD_CheckGroupIndex
	                          ,DRPD_RoomIndex,DRPD_EQ_DR,DRPD_EQGroup_DR,DRPD_Room_DR,DRPD_IndexType_DR,DRPD_AppointUser_DR,DRPD_Operate_Date,DRPD_Operate_Time) 
	    				    values (:ResSchduleID,:perOrditemRowid,:EpisodeID,:AppointMethod,:StudyNo,:RegEQIndex,:CheckGroupIndex,:RoomIndex,:EQDr,:EQGroupDR,:RoomDR,:IndexTypeDR,:UserDR,:OperateDate,:OperateTime))
      }
         
						
     s DHCENSInfo="",ret="0"
     /*
     i (OherParam'="HIS")
     {
	   s ^TMPOrditemRowid=perOrditemRowid
	   s DHCENSInfo=##class(DHCENS.BC.BS.WebBCService).SendHisBookedInfo(perOrditemRowid)
       s ret=$p(DHCENSInfo,"^",1)     
     }
     */
     
      
     I SQLCODE TRollback  
	 q:SQLCODE 
	 
	 
     if ('$d(^DHCRISDOCTMP("STUDYNO",StudyNo)))
     {
	     i ((SQLCODE=0)&(UpType="B")) d
	      .do ##class(web.DHCRisPatRegisterDoEx).UpdateIndexcls(RecLocdr,value,ResSchduleID)
	      
	   	 s UseNumber=UseNumber+1
	   	 
	   	 if ((AppointMethod="1")&(MaxNumber<UseNumber))
	   	 {
		   	 s RemainNumber="0"
		 }
	   	 else
	   	 {
	   	     s RemainNumber=MaxNumber-UseNumber
	   	 }
	   	 
	   	 &sql(update DHCRBC_ResSchdule (DRPS_AutoUseNumber,DRPS_RemainNumber,DRPS_UseNumber)
	                          values (:AutoUseNumber,:RemainNumber,:UseNumber) where  DRPS_RowID=:ResSchduleID)     
     }                      
      /*i (OherParam'="HIS")
      {
        s DHCENSInfo=##class(DHCENS.BC.BS.WebBCService).UpdateHisBookedInfo(perOrditemRowid)
        s ret=$p(DHCENSInfo,"^",1) 
      } 
      */ 
      ;更新医嘱表及医嘱状态表的的数据
      s Now=$zd(+$H,8)_$zt($p($h,",",2))
      s SQLCODE=##class(RISService.TrakRISService).ORMO01XX(perOrditemRowid,"BK",Now,"","","")
      if (GetFlag="Y")
      {
	      &sql(Update SQLUser.OE_OrdItem 
				Set OEORI_RecDep_DR= :GetRecLocDR Where OEORI_RowId= :perOrditemRowid)
				
		  I SQLCODE TRollback  
	      q:SQLCODE 
	  }
      
      ;发送预约消息到RIS4系统
      i ((StudyNo'="")&('$d(^DHCRISDOCTMP("STUDYNO",StudyNo))))
      {            
         do ##class(web.DHCRisSendToRis4Set).SendBookedtoRIS4(StudyNo,RecLocdr)
      }
      s ^DHCRISDOCTMP("STUDYNO",StudyNo)=StudyNo
       
      I SQLCODE TRollback  
      I SQLCODE q 
  	  TCOMMIT
    }
    
    q SQLCODE_"^"_ret
    

ERROR	
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK
 	q SQLCODE_"^"_ret
}

/// 转预约
ClassMethod ReBookedData(InParam As %String) As %String
{
	//w !,"InParam="_InParam
	s OrderItemRowid=$p(InParam,"^",1)
	s GetResSchduleID=$p(InParam,"^",2)
	s AppointMethod=$p(InParam,"^",3)      ; 1: 手动， 2：自动
	s OherParam=$p($g(InParam),"^",4)     //计费标识 HIS
	s MuitStudyNo=$p($g(InParam),"^",5)
	s RegEQIndex=$p($g(InParam),"^",6)
	s CheckGroupIndex=$p($g(InParam),"^",7)
	s RoomIndex=$p($g(InParam),"^",8)
	s EQDr=$p($g(InParam),"^",9)
    s EQGroupDR=$p($g(InParam),"^",10)
    s RoomDR=$p($g(InParam),"^",11)
    s paadr=$p($g(InParam),"^",12)
    s IndexTypeDR=$p($g(InParam),"^",13)
    s InputRegDate=$p($g(InParam),"^",14)
    i InputRegDate'="" s InputRegDate=$zd(InputRegDate,3)
    s UserDR=$p($g(InParam),"^",15)
    s GetStudyNo=$p($g(InParam),"^",16) //PACS传入的检查号
    s GetFlag=$p($g(InParam),"^",17)    ;登陆科室资源配置标记Y/N
    s GetRecLocDR=$p($g(InParam),"^",18) 
    s OperateDate=+$h
	s OperateTime=$p($h,",",2)
	
    Set $ZT="ERROR1"	
    TSTART
    s SQLCODE=100,ret=0
    
    k ^DHCRISRESSCHUDLETMP("SchduleID")
    
    if (GetResSchduleID'="")
    { 
	     s Nums=$l(OrderItemRowid,"@")
		 
		 for k=1:1:Nums 
		 {
			  s perOrdItmRowid=$p(OrderItemRowid,"@",k)
			  s ResDetailRowid="",LastStudyNo=""
			  s ResDetailRowid=$o(^DHCRBCResSchduleDetaili(0,perOrdItmRowid,0))
			  
			  i ResDetailRowid'="" d
               .s ResSchduleID=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",2)
               .s LastStudyNo=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",6)
               
              if ((ResSchduleID'="")&('$d(^DHCRISRESSCHUDLETMP("SchduleID",LastStudyNo)))) 
              {  
		          s CAUseNumber=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",9)
			      s CARemainNumber=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",10)
			      
			      i CAUseNumber="" s CAUseNumber=0
			      i CARemainNumber="" s CARemainNumber=0
			     
			      i (CAUseNumber'=0 )
			      {
				      s CAUseNumber=CAUseNumber-1
				      s $p(^DHCRBCResourceSchdule(ResSchduleID),"^",9)=CAUseNumber
			      }
			      i (CARemainNumber'=0) 
			      {
				      s CARemainNumber=CARemainNumber+1
				      s $p(^DHCRBCResourceSchdule(ResSchduleID),"^",10)=CARemainNumber
				  }
				
				  s ^DHCRISRESSCHUDLETMP("SchduleID",LastStudyNo)=LastStudyNo
				  
              }
		 }
		  
		  s NewUseNumber=$p($g(^DHCRBCResourceSchdule(GetResSchduleID)),"^",9)
	      i NewUseNumber="" s NewUseNumber=0 
	      s MaxNumber=$p($g(^DHCRBCResourceSchdule(GetResSchduleID)),"^",7)
	      s NewRemainNumber=$p($g(^DHCRBCResourceSchdule(GetResSchduleID)),"^",10)
	      i NewRemainNumber="" s NewRemainNumber=MaxNumber
	     
	      i (NewRemainNumber'=0)
	      {  
		      s NewUseNumber=NewUseNumber+1
		      s NewRemainNumber=NewRemainNumber-1
		      s $p(^DHCRBCResourceSchdule(GetResSchduleID),"^",9)=NewUseNumber
		      s $p(^DHCRBCResourceSchdule(GetResSchduleID),"^",10)=NewRemainNumber
		      
		      s Counts=$l(OrderItemRowid,"@")
		    
		      for j=1:1:Counts 
              {
                s perOrdItmRowid=$p(OrderItemRowid,"@",j)
                s StudyNo=$p(MuitStudyNo,"@",j)
		        &sql(update DHCRBC_ResSchduleDetail (DRPD_ResSchdule_ID,DRPD_EpsoideID,DRPD_StudyNo,DRPD_EQ_Index,DRPD_CheckGroupIndex,DRPD_RoomIndex,DRPD_CAFlag,DRPD_EQ_DR,DRPD_EQGroup_DR,DRPD_Room_DR,DRPD_IndexType_DR,DRPD_AppointUser_DR,DRPD_Operate_Date,DRPD_Operate_Time)
		                           values (:GetResSchduleID,:paadr,:StudyNo,:RegEQIndex,:CheckGroupIndex,:RoomIndex,'Booked',:EQDr,:EQGroupDR,:RoomDR,:IndexTypeDR,:UserDR,:OperateDate,:OperateTime) where  DRPD_OrderItem_ID=:perOrdItmRowid)   
		        if (GetFlag="Y")
                {
			      &sql(Update SQLUser.OE_OrdItem Set OEORI_RecDep_DR= :GetRecLocDR Where OEORI_RowId= :perOrditemRowid)
			      		
				  I SQLCODE TRollback  
			      q:SQLCODE 
	            }    
              }           
	      }
	       
	      I SQLCODE TRollback  
          I SQLCODE q 
  	      TCOMMIT               
	}
    
    q SQLCODE_"^"_ret
    
ERROR1	
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK
 	q SQLCODE_"^"_ret
}

/// /----------------------------------------------------------------------------------------------
/// / 自动预约
ClassMethod AutoBookedInterface(Info As %String) As %String
{
	s Inpaadmdr=$p(Info,"^",1)
	s InOrderItemRowid=$p(Info,"^",2)
	s InAppLocDR=$p(Info,"^",3)
	s InChargeDate=$p(Info,"^",4)      
	s InChargeTime=$p($g(Info),"^",5)  
	s InUserDR=$p($g(Info),"^",6)
	s InResourceDR=$p($g(Info),"^",7)
	
	s SQLCODE="-1",GetHospitalDR="",Getpatienttype=""
	
	i Inpaadmdr'="" d
	.s GetHospitalDR=..GetPatientHospital(Inpaadmdr)
	.s Getpatienttype=$p(^PAADM(Inpaadmdr),"^",2)
	
	s ItemNums=$l(InOrderItemRowid,"@")
    
    for i=1:1:ItemNums
    {  
         s perOrditemRowid="",ItemMastRowid="",LocId="",BPRowid=""
         s AppointMethodId="",ServiceGroupId="",DetailRowid="",CAFlag=""
	     s perOrditemRowid=$p(InOrderItemRowid,"@",i)
	     
	     s SQLCODE="-1"
 
		 i (perOrditemRowid="") 
		 {
			 s SQLCODE="-005"
			 BREAK:SQLCODE
		 }
	 
		 s OrderRowid=$p(perOrditemRowid,"||",1)
	     s ItemRowid=$p(perOrditemRowid,"||",2)
	     s Paadmdr=$p($g(^OEORD(OrderRowid)),"^",1)
	 
	     s ItemMastRowid=$p($g(^OEORD(OrderRowid,"I",ItemRowid,1)),"^",2)
	     s LocId=$p($g(^OEORD(OrderRowid,"I",ItemRowid,3)),"^",6)
	     s Subscript=$p(ItemMastRowid,"||",1)
	     s Version=$p(ItemMastRowid,"||",2)
	 
	     s BPRowid=$o(^DHCRBCItemBookProperTypei(ItemMastRowid,0))
	     i (BPRowid="")
	     {
		     s SQLCODE="-001"
		     BREAK:SQLCODE
		 }
	     
	     s AppointMethodId=$p(^DHCRBCItemBookProperty(BPRowid),"^",2) 
	     i AppointMethodId'="" s AppMethod=$p(^DHCRBCAppointMethod(AppointMethodId),"^",2)
	     
	     s ItmPatTypeRowid=""
	     s ItmPatTypeRowid=$o(^DHCRBCItemPatTypeSeti("Code",ItemMastRowid,Getpatienttype,ItmPatTypeRowid))
	     i ItmPatTypeRowid'="" s AppointMethodId=$p($g(^DHCRBCItemPatTypeSet("ItemPatTypeSet",ItmPatTypeRowid)),"^",3)
	     i AppointMethodId'="" s AppMethod=$p(^DHCRBCAppointMethod(AppointMethodId),"^",2)
	     
	     i ((AppMethod="不需预约")!(AppMethod="无需预约"))
	     {
		     s SQLCODE="-002"
		     BREAK:SQLCODE
		 }
	
	     s ServiceGroupId=$p(^ARCIM(Subscript,Version,8),"^",7)
	     i (ServiceGroupId="")
	     {
		     s SQLCODE="-003"
		     BREAK:SQLCODE
		 }
	 
	     s DetailRowid=$o(^DHCRBCResSchduleDetaili(0,perOrditemRowid,0))
	     i DetailRowid'="" s CAFlag=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",7)
		 i ((DetailRowid'="")&(CAFlag'="Cancel"))
		 { 
		     s SQLCODE="-004"
		     BREAK:SQLCODE
		 }
		

	    
    }
    
    q SQLCODE
}

/// 函数：GetUseResPan
/// 功能：根据开始日期，和服务组获得可用的预约资源 
/// 参数： ChargeDate 计费日期 （数字） , ChargeTime 计费时间（数字） 
/// 返回：可用的预约资源(DHCRBC_ResSchdule,ROWID)^报到日期^报到时间
/// 作者：gongping 
/// 日期：2011-08-22 
ClassMethod GetUseResPan(ChargeDate As %Integer, ChargeTime As %Integer, ServiceGroupId As %String, Empty As %String, LocId As %String, OeorditemRowid As %String = "", GetEqDR As %String = "") As %String
{
		
	s bFind=0
	s Day=ChargeDate
	s UseResInfo=""
	s ServiceName=""
	
	i ServiceGroupId'="" d
    .s ServiceName=$p($g(^RBC("SG",ServiceGroupId)),"^",2)
    .;w !,ServiceName
    i (Empty'="Y")&(ServiceName="CTB组") d            ; 未空腹的CTB组第二天进行预约
    .s Day=Day+1  
   
	//查找可使用的预约资源
	while(bFind<1)
	{	
	    ;w !,Day_"^"_ChargeDate_"^"_ChargeTime_"^"_ServiceGroupId_"^"_LocId
		s UseResInfo=..GetDayUseBookInfo(Day,ChargeDate,ChargeTime,ServiceGroupId,LocId,OeorditemRowid,GetEqDR)
		;w !,"UseResInfo"_UseResInfo
		if (UseResInfo="")
		{
		    s Day=Day+1
		    i (Day-ChargeDate)>50  s bFind=1   ;如果超过50天没有，可能是系统没有设置排版，则退出循环
		   
		}	
		else    ; 找到可用的计划
		{   
			s bFind=1
		}
	}
	
	q UseResInfo
}

/// 函数：GetDayUseBookNum
/// 功能：获取制定日期可以预约的信息
/// 参数：日期，服务组
/// 返回：可用的预约资源(DHCRBC_ResSchdule,ROWID)^报到日期^报到时间
/// 作者：gongping 
/// 日期：2011-08-22 
ClassMethod GetDayUseBookInfo(Day As %Integer, InChargeDate As %Integer, InChargeTime As %Integer, ServiceGroupId As %String, LocId As %String, OEorditem As %String = "", GetEqDR As %String = "") As %String
{
	s MaxRemainNumber=0    ; 最大的剩余数
	s SelSchuldRowid=0
	
	s Info="",ServiceName=""
	
	// 是否是奥抗病人
	//s IsAK=..GetAokangPatient(OEorditem)

	i ServiceGroupId'="" d
    .s ServiceName=$p(^RBC("SG",ServiceGroupId),"^",2)

    ; 按时间段索引，查找服务组在某个时间段，某个资源的最大可预约数，并返回该可用的资源
    s TPRowid=0 f  s TPRowid=$o(^DHCRBCTimePeriodSet(TPRowid)) q:TPRowid=""  d
    .s TimeDuration=$p(^DHCRBCTimePeriodSet(TPRowid),"^",1)
    .s SchRowid=0 f  s SchRowid=$o(^DHCRBCResourceSchdulei("Date-Time-Res",LocId,Day,ServiceGroupId,TimeDuration,SchRowid)) q:SchRowid=""  d
 	..s AutoUseNumber=$p(^DHCRBCResourceSchdule(SchRowid),"^",13) ; 自动预约使用的数量
	..i AutoUseNumber="" s AutoUseNumber=0
	..s AutoNumber=$p(^DHCRBCResourceSchdule(SchRowid),"^",8)   ; 自动预约分配的数量
	..q:(AutoNumber="0")
	..s RessourceID=$p(^DHCRBCResourceSchdule(SchRowid),"^",1)
	..q:(GetEqDR'="")&(GetEqDR'=RessourceID)
	..s RemainNum=$p(^DHCRBCResourceSchdule(SchRowid),"^",10)   ; 剩余数
	..s MaxNumber=$p(^DHCRBCResourceSchdule(SchRowid),"^",7)
	..i (RemainNum="")!(RemainNum=0) s RemainNum=MaxNumber
	..s ChargeTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",14)  ; 截止缴费时间
	..i ChargeTime="" s ChargeTime=0                      ; 未设置截止缴费时间
	..s StartTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",5) 
	..s EndTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",6) 
	..s AutoRemainNum=AutoNumber-AutoUseNumber ; 自动可预约的剩余数
	..i RemainNum<=0  s AutoRemainNum=0        ; 剩余数 为0 ,自动剩余数 就设置为 0 表示不可以预约
	..i (Day=InChargeDate)&(ServiceName="CTA组")  d           ; 当天预约情况，判断缴费时间点，如果是下一天则不用判断
    ...i (InChargeTime<StartTime)&(AutoRemainNum>MaxRemainNumber)  d
	....s MaxRemainNumber=AutoRemainNum
	....s Info=SchRowid_"^"_Day_"^"_StartTime
	...i (InChargeTime<ChargeTime)&(AutoRemainNum>MaxRemainNumber) d
	....s MaxRemainNumber=AutoRemainNum
	....s Info=SchRowid_"^"_Day_"^"_StartTime   //EndTime 
	..else  i (Day=InChargeDate)&(ServiceName="CTB组")  d 
	...i (InChargeTime<ChargeTime)&(AutoRemainNum>MaxRemainNumber) d 
	....s MaxRemainNumber=AutoRemainNum
	....s Info=SchRowid_"^"_Day_"^"_StartTime   //EndTime 
	..else  d
	...i ((InChargeTime<EndTime)&(InChargeTime<ChargeTime)&(AutoRemainNum>MaxRemainNumber)) d 
	....s MaxRemainNumber=AutoRemainNum
	....s Info=SchRowid_"^"_Day_"^"_StartTime   //EndTime 
	..if (Day>InChargeDate)&(IsAK'="Y")  d
	...i (AutoRemainNum>MaxRemainNumber) d    ; 下一个工作日的预约，只考虑限额
	....s MaxRemainNumber=AutoRemainNum
	....s Info=SchRowid_"^"_Day_"^"_StartTime
	..else  if (Day>InChargeDate)&(IsAK="Y") d
	...i (AutoRemainNum>0)  d
	....s MaxRemainNumber=AutoRemainNum
	....s Info=SchRowid_"^"_Day_"^"_StartTime  //EndTime

	.; 找到这个时间段的最大剩余的资源，且不是奥抗阳性的病人则退出，否则取最后一个可以预约的时间段
	.i (MaxRemainNumber>0)&(IsAK'="Y") d 
	..s TPRowid=100

	q Info
}

Storage Default
{
<Data name="DHCRisDoctorBookDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCRisDoctorBookD</DataLocation>
<DefaultData>DHCRisDoctorBookDefaultData</DefaultData>
<IdLocation>^web.DHCRisDoctorBookD</IdLocation>
<IndexLocation>^web.DHCRisDoctorBookI</IndexLocation>
<StreamLocation>^web.DHCRisDoctorBookS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
