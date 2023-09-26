/// process exam item 
Class web.DHCEkgOeorditem Extends %Library.RegisteredObject
{

// 更新医嘱结果状态，供报告使用,返回医嘱结果的ROWID

ClassMethod GetOeorditemMemo(oeorditemrowid) As %String
{
	s strCommon="" 
	s OrderRowid=$p(oeorditemrowid,"||",1)
	s itemsub=$p(oeorditemrowid,"||",2)
	s numb=$g(^OEORD(OrderRowid,"I",itemsub,"DEP",0))	
	f i=1:1:numb d
	.s Common=^OEORD(OrderRowid,"I",itemsub,"DEP",i)
	.s strCommon=strCommon_" "_Common
    q strCommon
}

ClassMethod GetOeorditminfo(OrderRowid, itemsub, patType) As %String
{
    s requestdoc="",ItemStatusCode="",SGroupDesc="",BillFlag=""
    q:(OrderRowid="")!(itemsub="") ""
    s oeorditemdr=OrderRowid_"||"_itemsub
    s retinfo="^^^^^^^^^^^^^^^^^^^^"
    i $g(^OEORD(OrderRowid,"I",itemsub,1))="" q retinfo
    s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
    s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
    s strOrderCode=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",1)
    s Date1=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",9)  ;医嘱日期 OEORI_Date
	s strDate=$zd(Date1,3)
	s Time1=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",17) ;医嘱的开始时间
	s strTime=$zt(Time1,1)
	s RecLocdr=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",6)
	//s ssusrdr=$p(^OEORD(OrderRowid,"I",itemsub,7),"^",1) ;下医嘱医生
	//if ssusrdr'="" s requestdoc=$p(^SSU("SSUSR",ssusrdr),"^",2)         ; request doctor
	s caredr=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",11) ;
    if caredr'="" d
    .s requestdoc=$p($g(^CTPCP(caredr,1)),"^",2)
    .i ($g(^DHCRisGetNameSet)="ID")&&($p($g(^CTPCP(caredr,1)),"^",3)'="") s requestdoc=$p($g(^CTPCP(caredr,1)),"^",3)
	s strAccessionNum=$p($g(^OEORD(OrderRowid,"I",itemsub,8)),"^",19) 
    s ServerGroupDR=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),8),"^",7)
    i ServerGroupDR'="" s SGroupDesc=$p($g(^RBC("SG",ServerGroupDR)),"^",2)
    s ItmCatDR=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",10)
	s OrdCatDr=$p(^ARC("IC",ItmCatDR),"^",8)
	s subCatDesc=$p(^ARC("IC",ItmCatDR),"^",2) ; 医嘱子类
	s CatDesc=$p(^OEC("ORCAT",OrdCatDr),"^",2) ; 医嘱大类
	s ItemStatDR=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",13) ; 医嘱状态
	i ItemStatDR'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
	s ifbed=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7)),"^",16)
	s price="",Num="",TotalPrice=""
    s DHCRisSystemInfo=##class(web.DHCEkgSystemParam).GetSystemParam()
    s DHCRisVersion=$p(DHCRisSystemInfo,"^",15)
    s Num=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",12)
    s TotalPrice=""
    s SttDate=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",9)  
	s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
	s paadmdr=$p(^OEORD(OrderRowid),"^",1)
	i paadmdr'="" d
	.s BillFlag=$p(^PAADM(paadmdr),"^",45)  //20091230  sunyi
    if (DHCRisVersion="BJ_DT")!(DHCRisVersion="BJ_JST")!(DHCRisVersion="DT_SY")!(DHCRisVersion="NB_MZ")!(DHCRisVersion="AH_SL")!(DHCRisVersion="CD_HX1")!(DHCRisVersion="BJ_YY")!(DHCRisVersion="BJ_FX") d  //sy 2009-3-1
	.s OEPrice=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",25)		;;取出P   价格 OE_OrdItem->OEORI_Price
	.s paadmdr=$p(^OEORD(OrderRowid),"^",1)  
	.s instypedr=$p(^PAADM(paadmdr,1),"^",7)
	.s CurrSpace=$ZNSPACE
    .d ##class(web.DHCEkgSystemParam).SetWebNameSpace()
	.s priceinfo=##class(web.UDHCJFPRICE).GetOrderPrice("", instypedr, arcimid, SttDate, "", "", "", OEPrice)
	.zn CurrSpace
	.s price=$p(priceinfo,"^",1)
	.s TotalPrice=price*Num
	if (DHCRisVersion="HN_XYOYY") d
	.s paadmdr=$p(^OEORD(OrderRowid),"^",1)
	.s CurrSpace=$ZNSPACE
    .d ##class(web.DHCEkgSystemParam).SetWebNameSpace()
 	.s price=##class(web.DHCPACSPrice).GetPrice(paadmdr,oeorditemdr)
 	.zn CurrSpace
	.s TotalPrice=price*Num
   if (DHCRisVersion="HRB_HYD") d
	.s CurrSpace=$ZNSPACE
	.d ##class(web.DHCEkgSystemParam).SetMedTrakNameSpace() 
	.s priceinfo=$$GetOrderPrice^DHCPRICE("","",arcimid,SttDate,"","","","") 
	.zn CurrSpace
	.s price=$p(priceinfo,"^",1)
	.s TotalPrice=price*Num
	//获取计费状态
	if (patType="住院病人")
	{
		s billed=$p(^OEORD(OrderRowid,"I",itemsub,"X",1),"^",6)
	}
	else 
	{
		s billed=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",5)
	}
	s ResultFlag=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",5)   ;医嘱结果状态
	s ServerMaterial=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7)),"^",6)
	s strCommon=""
	s retinfo=strOrderName_"^"_strDate_"^"_strTime_"^"_requestdoc_"^"_strAccessionNum_"^"_SGroupDesc_"^"_subCatDesc_"^"_CatDesc_"^"_ifbed_"^"_price_"^"_Num_"^"_TotalPrice_"^"_billed_"^"_$g(ItemStatusCode)_"^"_Date1_"^"_Time1_"^"_$g(ItemStatusCode)_"^"_$g(ServerMaterial)_"^"_RecLocdr_"^"_$g(ResultFlag)_"^"_strCommon_"^"_BillFlag_"^"_arcimid_"^"_strOrderCode
	q retinfo
}

ClassMethod GetOeordResult(OrderRowid, itemsub) As %String
{
  s ResStatDR="",resrowid=0,Getresrowid=0,GetStatDR=4,HasResult=0
  s resrowid=0 f  s resrowid=$o(^OEORD(OrderRowid,"I",itemsub,"RES",resrowid)) q:resrowid=""  d 
  .s ResStatDR=$p(^OEORD(OrderRowid,"I",itemsub,"RES",resrowid),"^",2)
  .s HasResult=1
  .i ResStatDR'="" s Resultcode=$p(^OEC("RESST",ResStatDR),"^",1)
  .i (Resultcode="A")!(Resultcode="D") d   
  ..s GetStatDR=ResStatDR
  ..s Getresrowid=resrowid    
  i HasResult=1 d   //有结果
  .i Resultcode="E" d 
  ..s ReportStatusCode="R"  ;录入状态
  ..s PatientStatusCode="E"
  .i Resultcode="V" d
  ..s ReportStatusCode="V"
  ..s PatientStatusCode="O"
  .i Resultcode="S" d
  ..s ReportStatusCode="S"
  ..s PatientStatusCode="O"
  .i Resultcode="D"
  ..s ReportStatusCode="D"
  ..s PatientStatusCode="E"
  .s CPReportDocDr=$p(^OEORD(OrderRowid,"I",itemsub,"RES",Getresrowid),"^",35)
  .i $g(CPReportDocDr)'="" d
  ..i $g(^CTPCP(CPReportDocDr,1))'=""  d
  ...i ^DHCRisGetNameSet="ID" d 
  ....s getReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",3)
  ...else  d
  ....s getReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",2)      
  .s CPVerifyDr=$p(^OEORD(OrderRowid,"I",itemsub,"RES",Getresrowid),"^",36)
  .i $g(CPVerifyDr)'="" d
  ..i $g(^CTPCP(CPVerifyDr,1))'=""  d
  ...i ^DHCRisGetNameSet="ID" d 
  ....s getReportVerifyDoc=$p(^CTPCP(CPVerifyDr,1),"^",3)  
  ...else  d
  ....s getReportVerifyDoc=$p(^CTPCP(CPVerifyDr,1),"^",2)
  .s ReportDate=$p(^OEORD(OrderRowid,"I",itemsub,"RES",Getresrowid),"^",37)
  .i ReportDate'="" s strReportDate=$zd(ReportDate,3)
  .s ReportTime=$p(^OEORD(OrderRowid,"I",itemsub,"RES",Getresrowid),"^",37)
  .i ReportTime'="" s strReportTime=$zt(ReportTime,3)
  .s ReportVeriedDate=$p(^OEORD(OrderRowid,"I",itemsub,"RES",Getresrowid),"^",7)
  .i ReportVeriedDate'="" s strReportVeriedDate=$zd(ReportVeriedDate,3)
  .s ReportVeriedTime=$p(^OEORD(OrderRowid,"I",itemsub,"RES",Getresrowid),"^",8)
  .i ReportVeriedTime'="" s strReportVeriedTime=$zd(ReportVeriedTime,3)
  s info=HasResult_"^"_$g(ReportStatusCode)_"^"_$g(PatientStatusCode)_"^"_$g(getReportDoc)_"^"_$g(getReportVerifyDoc)_"^"_$g(strReportDate)_"^"_$g(strReportTime)_"^"_$g(strReportVeriedDate)_"^"_$g(strReportVeriedTime)
  q info
}

ClassMethod UpdateOrdStatus(Userid, StudyNo, ResultStatus)
{
 s rowid=0 f  s rowid=$o(^DHCPACRegInfoi("StudyNo",StudyNo,rowid)) q:rowid=""  d
 .s oeorditemrowid=$p(^DHCPACRegInfo(rowid),"^",11)
 .d ##class(web.DHCEkgOeorditem).UpdataOrdInfo(Userid, oeorditemrowid, "", "E", ResultStatus)
}

ClassMethod UpdataOrdInfo(Userid, OrditmRowid, ChildSub, Status, ResultStatus, PAADMDR = "") As %String
{
   s CurrSpace=$ZNSPACE
   d ##class(web.DHCEkgSystemParam).SetMedTrakNameSpace()
   s return=$$UpdataOrdInfo^DHCRisOrditemOP(Userid, OrditmRowid, ChildSub, Status, ResultStatus,PAADMDR)
   zn CurrSpace
   q return
}

ClassMethod StopLinkOrder(oeorditemrowid As %String, userid As %String) As %String
{
   s CurrSpace=$ZNSPACE
   d ##class(web.DHCEkgSystemParam).SetMedTrakNameSpace()
   d StopLinkOrder^CHOPOrderCommon(oeorditemrowid,userid)
   zn CurrSpace
   q 0
}

ClassMethod GetOrdStatus(oeorditemrowid As %String) As %String
{
 s GetItemStatusCode=""
 s OrderRowid=$p(oeorditemrowid,"||",1)
 s itemsub=$p(oeorditemrowid,"||",2)
 q:(OrderRowid="")!(itemsub="") ""
 s ordInfo=##class(web.DHCEkgOeorditem).GetOeorditminfo(OrderRowid,itemsub)
 s GetItemStatusCode=$p(ordInfo,"^",14)
 q GetItemStatusCode
}

}
