Import SQLUser

Class web.DHCRisApplicationBillsyyd Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCRisApplicationBill","GetServiceOrder","19218","","")
/// 查询：GetServiceOrder
/// 参数 EpisodeID:paadmrowid,
/// 	 LocDr:CT_LOC.Rowid 暂时不用
/// 	 CheckSend：是否查询发送的申请
/// 功能：查询病人的申请医嘱
Query GetServiceOrder(EpisodeID As %String, LocDR As %String, CheckSend As %String) As %Query(ROWSPEC = "ExamOrder:%String,OrderName:%String,Status:%String,datestr:%String,timestr:%String,LocDesc:%String,LocDR:%String,GetResDesc:%String,strRppDate:%String,strRppTime:%String,GetstrRegDate:%String,GetstrRegTime:%String,GetReportStatus:%String,GetRptDocName:%String,GetRptDate:%String,GetRptTime:%String,GetVerifyDocName:%String,GetVerifyDate:%String,GetVerifyTime:%String")
{
}

ClassMethod GetServiceOrderExecute(ByRef qHandle As %Binary, EpisodeID As %String, LocDR As %String, CheckSend As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 s ind=1
 s ret=0
 s PaAdmID=$p(EpisodeID,$C(0))
 s LocDR=$p(LocDR,$c(0))
 s strOrderName="",strRecLoc="",strStdate="",strAccessionNumber="",strExamOrder="",Wldr="",ModTypedr="",ModType=""
 s strDateCreated="",strTimeCreated="",strSeriesModality="",strOrderDate="",strOrderTime="",strCommon=""
 s CurOrderNo="",pointer1="",pointer2="",numb=""
 s statuscheck="1"
 s ordrowid=0,itmsub=0
 i PaAdmID'="" d
  .f  s ordrowid=$o(^OEORD(0,"Adm",PaAdmID,ordrowid)) q:(ordrowid="")  d
  ..f  s itmsub=$o(^OEORD(ordrowid,"I",itmsub)) q:(itmsub="")  d
  ...s GetPatientStatusCode="",GetReportStatusCode=""
  ...s GetPatientStatus="",GetReportStatus="",GetResDesc="",strRppDate="",strRppTime=""
  ...s GetstrRegDate="",GetstrRegTime="",GetRptDocName="",GetRptDate="",GetRptTime="",GetVerifyDocName="",GetVerifyDate="",GetVerifyTime=""
  ...s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(ordrowid, itmsub)
  ...s GetstrOrderName=$p(ordInfo,"^",1)
  ...s GetstrDate=$p(ordInfo,"^",2)
  ...s GetstrTime=$p(ordInfo,"^",3)
  ...s SubCatDesc=$p(ordInfo,"^",7)
  ...q:SubCatDesc="诊疗费"
  ...q:SubCatDesc="挂号费"
  ...s GetItemStatusCode=$p(ordInfo,"^",14)
  ...s GetServerMaterial=$p(ordInfo,"^",18)
  ...s RecLocDesc=$p(ordInfo,"^",21)
  ...s RecLocDR=$p(ordInfo,"^",19)
  ...q:(GetServerMaterial'="Service")&(GetServerMaterial'="S")
  ...q:(GetItemStatusCode'="V")&(GetItemStatusCode'="E")
  ...s ExamOrder=ordrowid_"||"_itmsub
  ...s RRowid="",bedone=""
  ...;s RRowid=$o(^DHCRBAppi("OrdRowid",ExamOrder,0))
  ...s RRowid=$o(^DHCRBAppOrdi(0,ExamOrder,0)) 
  ...;--------------------------------------------------
  ...s GetPatientStatusCode="",GetPatientStatus="",GetReportStatus=""
  ...i RRowid'="" d
  ....s GetPatientStatusCode="A"  ;申请
  ....s GetRejDR=$o(^DHCRBRejecti("OeordDR",ExamOrder,0))
  ....i GetRejDR'="" d
  .....s GetPatientStatusCode="R" 
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
  ...i (((CheckSend="")&(GetPatientStatusCode=""))!(CheckSend="on")) d 
  ....i GetPatientStatusCode'="" s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
  ....i GetReportStatusCode'="" s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
  ....Do OutServiceOrder 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutServiceOrder
 
 set Data=$lb(ExamOrder,GetstrOrderName,GetPatientStatus,GetstrDate,GetstrTime,RecLocDesc,RecLocDR,GetResDesc,strRppDate,strRppTime, GetstrRegDate,GetstrRegTime,GetReportStatus,GetRptDocName,GetRptDate,GetRptTime,GetVerifyDocName,GetVerifyDate,GetVerifyTime)
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
  s OeItemMastDR=$p(^OEORD(ord,"I",itm,1),"^",2)
  s goalrowid=0,goaldesc=""
  f  s goalrowid=$o(^DHCRBAppi("Goal-orditem",OeItemMastDR,goalrowid)) q:(goalrowid="")  d
  .s goaldesc=$p(^DHCRBCApp("GLOBAL",goalrowid),"^",2) 
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

/// s Info=##class(web.DHCRisApplicationBill).GetAppShape(oeorditemrowid)
ClassMethod GetAppShape(oeorditemrowid As %String) As %String
{
	s ComponentName="",PrintTemp="",AppSetrowid="",ShapeDR=""
	if oeorditemrowid'=""  
	{
		s OrderRowid=$p(oeorditemrowid,"||",1)
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

ClassMethod SaveAppBill(XMLConent As %String, OeOrditemID As %String, XDate As %String, UserID As %String, HtmlConent As %String, ItemInfo As %String)
{
	
	s AppRowid=""
	s xdate=$zdh(XDate,4)
	;s AppRowid=$o(^DHCRBAppi("OrdRowid",OeOrditemID,0))
	s ^tmp11OeOrditemID=OeOrditemID
	s ^tmp111XDate=xdate
	s ^tmp1111UserID=UserID
	
	s FirstOrditem=$p(OeOrditemID,"^",1)
	s AppRowid=$o(^DHCRBAppOrdi(0,FirstOrditem,0)) 
	

	
	s OEordRowid=$p(FirstOrditem,"||",1)
	s ChildSub=$p(FirstOrditem,"||",2)
	
	
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
		&sql(insert into DHCRB_ApplicationBill(DRA_OeItemID_DR, DRA_USER_DR,DRA_Date,DRA_Xdate, DRA_Time, DRA_LocID_DR) values ( :FirstOrditem,:UserID,:date,:xdate,:time,:RecLocDR))
		q:SQLCODE SQLCODE
		s rowid=$p(%ROWID,$c(1))
		s ^DHCRBApp("Bill",rowid,"XMLContent")=XMLConent
		s ^DHCRBApp("Bill",rowid,"html")=strHtmlConent
		s ^DHCRBApp("Bill",rowid,"ItemInfo")=ItemInfo
	
		
		s nums=$l(OeOrditemID,"^")
		for i=1:1:nums  d
		.s perOEOrdItemID=$p(OeOrditemID,"^",i)
        .&sql(insert into DHCRB_ApplicationBill_OrdItem (DAO_ParRef,DAO_OrdItem_DR) values (:rowid,:perOEOrdItemID))
	}
	else
	{
		&sql(update DHCRB_ApplicationBill(DRA_OeItemID_DR, DRA_USER_DR,DRA_Date,DRA_Xdate, DRA_Time,DRA_LocID_DR) values ( :FirstOrditem,:UserID,:date,:xdate,:time,:RecLocDR) where DRA_RowID=:AppRowid )
		s ^DHCRBApp("Bill",AppRowid,"XMLContent")=XMLConent
		s ^DHCRBApp("Bill",AppRowid,"html")=strHtmlConent
		s ^DHCRBApp("Bill",AppRowid,"ItemInfo")=ItemInfo
	
		&sql(delete from DHCRB_ApplicationBill_OrdItem where DAO_ParRef=:AppRowid)
		
	   s nums=$l(OeOrditemID,"^")
	   for i=1:1:nums  d
	   .s perOEOrdItemID=$p(OeOrditemID,"^",i)
       .&sql(insert into DHCRB_ApplicationBill_OrdItem (DAO_ParRef,DAO_OrdItem_DR) values (:AppRowid,:perOEOrdItemID))
    
	}
	
	s paadmdr=$p(^OEORD(OEordRowid),"^",1)
    s paadmtype=$p(^PAADM(paadmdr),"^",2)
  
    i (paadmtype="I")&($g(^DHCRisIPSendMessage)="Y") d  ; 对于住院病人发送HL7消息   
	.d ..SendHL7Message(FirstOrditem)

	
	q SQLCODE
}

ClassMethod GetAppBill(OeOrditemID)
{
	s XMLConent="",strDate="",LocDR="",strTime="",UserDR="",strXDate="",XMLContent=""
	s strXMLConent=""
	;s AppRowid=$o(^DHCRBAppi("OrdRowid",OeOrditemID,0))
	s AppRowid=$o(^DHCRBAppOrdi(0,OeOrditemID,0)) 
	if AppRowid'="" d
	.s Date=$p(^DHCRBApp("Bill",AppRowid),"^",1)
	.s strDate=$zd(Date,3)
	.s LocDR=$p(^DHCRBApp("Bill",AppRowid),"^",4)
	.s oeorditemdr=$p(^DHCRBApp("Bill",AppRowid),"^",6)
	.s Time=$p(^DHCRBApp("Bill",AppRowid),"^",8)
	.s strTime=$zt(Time,3)
	.s UserDR=$p(^DHCRBApp("Bill",AppRowid),"^",9)
	.s XDate=$p(^DHCRBApp("Bill",AppRowid),"^",10)
	.s strXDate=$zd(XDate,3)
	.s XMLContent=$g(^DHCRBApp("Bill",AppRowid,"XMLContent"))
	.s Num=$l(XMLContent,$C(13,10))
	.s strXMLConent=""
	.for I=1:1:Num d
	..s pXMLConent=$p(XMLContent,$C(13,10),I)
	..;w !,"---------"_pXMLConent
	..i strXMLConent="" d
	...s strXMLConent=pXMLConent
	..else  d 
	...s strXMLConent=strXMLConent_$C(1)_pXMLConent
	s GetValue=strXMLConent_$c(2)_strDate_$c(2)_strTime_$c(2)_UserDR_$c(2)_strXDate
	q GetValue
}

ClassMethod SaveGlobal(Oeorditemrowid, GlobalDesc)
{
	s OrderRowid=$p(Oeorditemrowid,"||",1)
	s itemsub=$p(Oeorditemrowid,"||",2)
	s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
	&sql(insert into DHCRBC_Goal (DRG_ArcItmMast_DR,DRG_GoalDesc) values(:arcimid,:GlobalDesc))
	q SQLCODE
}

ClassMethod GetGlobal(Oeorditemrowid) As %String
{
	s OrderRowid=$p(Oeorditemrowid,"||",1)
	s itemsub=$p(Oeorditemrowid,"||",2)
	s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
	s rowid="",GlobDesc=""
	s rowid=$o(^DHCRBAppi("Goal-orditem",arcimid,0)) 
	s price=##class(web.DHCRisCommFunction).GetItemPrice(Oeorditemrowid)
	s Num=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",12)
    
	s TotalPrice=price*Num
	i TotalPrice="" s TotalPrice=0
	s TotalPrice=TotalPrice_"元"
	
	if (rowid'="")
	{
		s GlobDesc=$p($g(^DHCRBCApp("GLOBAL",rowid)),"^",2)
		//s GlobDesc=GlobDesc_"(总价"_TotalPrice_")"
	}
	/*else  
	{
		//医嘱名称作为检查目的		 
		s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
		s GlobDesc=strOrderName_"(总价"_TotalPrice_")"
 	
	}
	*/
	q GlobDesc
}

ClassMethod SaveCurrentStatus(Oeorditemrowid, paadmdr, CurrentStatus) As %String
{
    n (Oeorditemrowid, paadmdr, CurrentStatus)
    s rowid=""
 	&sql(select DIS_Rowid into :rowid from DHCRBC_IllStatus where DIS_Oeorditem_DR =:Oeorditemrowid and DIS_PaAdm_DR=:paadmdr)
	if (rowid="") d
	 .&sql(insert into DHCRBC_IllStatus(DIS_PaAdm_DR,DIS_Oeorditem_DR, DIS_IllStatus)values(:paadmdr,:Oeorditemrowid,:CurrentStatus))
	else  d
	.&sql(update DHCRBC_IllStatus (DIS_PaAdm_DR,DIS_Oeorditem_DR, DIS_IllStatus)values(:paadmdr,:Oeorditemrowid,:CurrentStatus) where DIS_Rowid=:rowid)
	q SQLCODE
}

ClassMethod GetCurrentStatus(paadmdr)
{
  s ^TMP("RIS",2)=paadmdr
   s rowid="",Desc=""
   s rowid=$o(^DHCRBAppi("illstatu-roditem",paadmdr,""),-1)
   if rowid'="" d
   .s Desc=$p(^DHCRBCApp("IllStatus",rowid),"^",3)
   ;if Desc="" d
   ;.s Desc=##class(web.DHCRisApplicationBill).GetMedicalRecord(paadmdr)
   q Desc
}

ClassMethod DelAppBill(Oeorditemrowid As %String) As %String
{
	s OEOrdItemID=$p(Oeorditemrowid,"^",1)
    s MyDelete=..DeleteApp(OEOrdItemID)
    s SQLCODE=100
    i MyDelete=1 d
	 .&sql(delete  from  DHCRB_ApplicationBill where  DRA_OeItemID_DR =:OEOrdItemID)
	q SQLCODE
}

Query GetAppShapeField(AppRowID As %String) As %Query(ROWSPEC = "ItemDesc:%String,Content:%String,Option:%String,ItemType:%String,Require:%String,FieldDR:%String,iRows:%String")
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
 .q:FieldDR=""
 .s ItemDesc=$p(^DHCRBApp("Field",FieldDR),"^",1)
 .s ItemType=$p(^DHCRBApp("Field",FieldDR),"^",2)
 .s Content=$p(^DHCRBApp("Field",FieldDR),"^",3)
 .s Option=$p(^DHCRBApp("Field",FieldDR),"^",4)
 .s Require=$p(^DHCRBApp("Field",FieldDR),"^",5)
 .d OutField
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutField
 set Data=$lb(ItemDesc,Content,Option,ItemType,Require,FieldDR,ind)
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
	;n (itmName,DataType,DicType,Val)
	/*
	Set itmName="comb"
	Set DataType="4"
	Set DicType="Marriage"
	Set Val="1"
	*/
    //ItemDesc:%String,Content:%String,Option:%String,ItemType:%String
    //ItemDesc:%String,Content:%String,Option:%String,ItemType:%String,Require:%String
	Set itmName="Content_"_rs.GetDataByName("iRows")
    Set DataType=rs.GetDataByName("ItemType")
	Set Val=rs.GetDataByName("Content")
	Set Requre=rs.GetDataByName("Require")
	Set FieldDR=rs.GetDataByName("FieldDR")  
	
    s Active="1"
    s Active=$s(Active="1":"",1:"disabled")
    
    //Write "<input type='checkbox' name='C1' value='ON'>"
    //Write "<input id='"_itmName_"' name='"_itmName_"' "_Active
    //Write "type='CheckBox' value='ON'>"
 
    
    i DataType="ListBox" d
    .Write "<select id='"_itmName_"' name='"_itmName_"' size=1 "_Active_" style='WIDTH: 180px; HEIGHT: 24px'>"
	.; 可以使空字段
	.i Requre'="1" Write "<option  value=''></option>"
	.s temp=##class(web.DHCRisApplicationBill).GetValueContent(FieldDR)
	.f Index=1:1:($l(temp,$c(1))) d
	..s s=$p(temp,$c(1),Index)
	..s Content=$p(s,"^",1)
	..If Content=Val Write "<option value="_Content_" selected>"_Content_"</option>"
	..Else  Write "<option value="_Content_">"_Content_"</option>"
	.Write "</select>"
    e  i DataType="Text" d
    .Write "<input id='"_itmName_"' name='"_itmName_"' "_Active
	.Write " style='WIDTH: 104px; HEIGHT: 24px' value='"_Val_"'>"
	.;Write "<IMG id='i"_itmName_"' name='i"_itmName_"'  src='../images/websys/lookupdate.gif'>"
    e  i DataType="CheckBox" d
    .Write "<input id='"_itmName_"' name='"_itmName_"' "_Active
    .Write " style='WIDTH: 25px; HEIGHT: 25px' type='CheckBox' value='ON'>"
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
      .s Getapprowid=$p(^OEORD(ordrowid,"I",itmsub,6),"^",5)
      .i Getapprowid'="" s MayDeleteApp=0
      s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfo(OEOrdItemID)
      s GetStudyNo=$p(RegInfo,"^",1)
      i GetStudyNo'=""  s MayDeleteApp=0
      q MayDeleteApp
}

ClassMethod DeleteAppTempList(Rowid As %String)
{
	&sql(delete from DHCRBC_ApplicationTempl where DAST_RowID=:Rowid)
	q SQLCODE
}

ClassMethod GetHtmlAppBill(OeOrditemID)
{
	s htmlConent="",strhtmlConent=""
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
	 .s desc=^DHCRBCApp("IllStatus",rowid,"MRD")
	q desc
}

ClassMethod GetAppItemInfo(OeOrditemID As %String) As %String
{
	s ItemConent=""
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

ClassMethod GetOrdName(Oeorditemrowid) As %String
{
	s OrderRowid=$p(Oeorditemrowid,"||",1)
	s itemsub=$p(Oeorditemrowid,"||",2)
	s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
	s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	
	s price=##class(web.DHCRisCommFunction).GetItemPrice(Oeorditemrowid)
	s Num=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",12)
    
	s TotalPrice=price*Num
	i TotalPrice="" s TotalPrice=0
	s TotalPrice=TotalPrice_"元"
	q strOrderName_"("_TotalPrice_")"
}

/// /发送HL7消息
ClassMethod SendHL7Message(OEOrdItemID)
{
   n (OEOrdItemID)
   s ^DHCRistmpOEOrdItemID=OEOrdItemID
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
   
   ;d ##class(web.DHCRisHL7).SendPatientInfo("", GetRegNo, GetName, GetstrDOB, GetSexDesc, address, TelNo, "", "", Getpatienttype, GetWardName, "", GetBedNo, "", "", "", "", "", paadmdr)

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
   
   s Info=##class(web.DHCRisApplicationBill).GetAppShape(OEOrdItemID)
   s ShapDR=$p(Info,"^",3)
   if ShapDR'="" d
   .s AppType=$p(^DHCRBApp("Shape",ShapDR),"^",1) 
   .i (AppType="1")!(AppType="2")!(AppType="3") d
   ..d ##class(web.DHCRisHL7).SendPatientInfo("", GetRegNo, GetName, GetstrDOB, GetSexDesc, address, TelNo, "", "", Getpatienttype, GetWardName, "", GetBedNo, "", "", "", "", "", paadmdr,"1")
   ..d ##class(web.DHCRisHL7).SendORMO01Message("", "NW", GetRegNo, GetName, OEOrdItemID, Getpatienttype, Getrequestdoc, paadmdr, ItemCode, GetstrOrderName, "", RelevantInfo, "", "", "","1")
   .else  if AppType="5" d
   ..; 超声消息
   ..d ##class(web.DHCRisHL7).SendPatientInfo("", GetRegNo, GetName, GetstrDOB, GetSexDesc, address, TelNo, "", "", Getpatienttype, GetWardName, "", GetBedNo, "", "", "", "", "", paadmdr,"2")
   ..d ##class(web.DHCRisHL7).SendORMO01Message("", "NW", GetRegNo, GetName, OEOrdItemID, Getpatienttype, Getrequestdoc, paadmdr, ItemCode, GetstrOrderName, "", RelevantInfo, "", "", "","2")
   .else  if AppType="7" d
   ..; 内镜消息
   ..d ##class(web.DHCRisHL7).SendPatientInfo("", GetRegNo, GetName, GetstrDOB, GetSexDesc, address, TelNo, "", "", Getpatienttype, GetWardName, "", GetBedNo, "", "", "", "", "", paadmdr,"3")
   ..d ##class(web.DHCRisHL7).SendORMO01Message("", "NW", GetRegNo, GetName, OEOrdItemID, Getpatienttype, Getrequestdoc, paadmdr, ItemCode, GetstrOrderName, "", RelevantInfo, "", "", "","3")
}

}
