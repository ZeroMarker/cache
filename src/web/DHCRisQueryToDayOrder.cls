Import SQLUser

Class web.DHCRisQueryToDayOrder Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCRisQueryToDayOrder","QueryToDayOrder","47525","83")	
Query QueryToDayOrder(EpisodeID As %String, LocDR As %String) As %Query(ROWSPEC = "ExamOrder:%String,OrderName:%String,Status:%String,datestr:%String,timestr:%String,LocDesc:%String,LocDR:%String,GetResDesc:%String,strRppDate:%String,strRppTime:%String,GetstrRegDate:%String,GetstrRegTime:%String,GetReportStatus:%String,GetRptDocName:%String,GetRptDate:%String,GetRptTime:%String,GetVerifyDocName:%String,GetVerifyDate:%String,GetVerifyTime:%String")
{
}

ClassMethod QueryToDayOrderExecute(ByRef qHandle As %Binary, EpisodeID As %String, LocDR As %String) As %Status
{

 Set repid=$I(^CacheTemp)
 s ind=1
 s ret=0
 s PaAdmID=$p(EpisodeID,$C(0))
 s LocDR=$p(LocDR,$c(0))
 s strOrderName="",strRecLoc="",strStdate="",strAccessionNumber="",strExamOrder="",Wldr="",ModTypedr="",ModType=""
 s strDateCreated="",strTimeCreated="",strSeriesModality="",strOrderDate="",strOrderTime="",strCommon=""
 s CurOrderNo="",pointer1="",pointer2="",numb="",AppType="",RRowid=""
 s ordrowid=0,itmsub=0,Maxitmsub="",DHCRisSystemInfo="",DHCRisVersion=""
 
 s DHCRisSystemInfo=##class(web.DHCRisCodeTableAdd).GetSystemParam()
 s DHCRisVersion=$p(DHCRisSystemInfo,"^",15)
 
 
 i PaAdmID'="" d
  .f  s ordrowid=$o(^OEORD(0,"Adm",PaAdmID,ordrowid)) q:(ordrowid="")  d
  ..s Maxitmsub=$o(^OEORD(ordrowid,"I",""),-1) q:(Maxitmsub="")
  ..f itmsub=Maxitmsub:-1:1 d
  ...s GetPatientStatusCode="",GetReportStatusCode=""
  ...s GetPatientStatus="",GetReportStatus="",GetResDesc="",strRppDate="",strRppTime="",RejectAppReason=""
  ...s GetstrRegDate="",GetstrRegTime="",GetRptDocName="",GetRptDate="",GetRptTime="",GetVerifyDocName="",GetVerifyDate="",GetVerifyTime="",Date1=""
  ...s Date=+$h
  ...s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(ordrowid, itmsub)
  ...i (DHCRisVersion="BJ_XH") d
  ....s GetstrOrderName=$p(ordInfo,"^",1) //28
  ...e  d
  ....s GetstrOrderName=$p(ordInfo,"^",1)
  ...s Date1=$p($g(^OEORD(ordrowid,"I",itmsub,1)),"^",9) //医嘱日期
  ...q:(Date1'="")&(Date1'=Date)
  ...s GetstrDate=$p(ordInfo,"^",2)
  ...s GetstrTime=$p(ordInfo,"^",3)
  ...s SubCatDesc=$p(ordInfo,"^",7)
  ...q:SubCatDesc="门诊诊疗费"
  ...q:SubCatDesc="挂号费"
  ...s GetItemStatusCode=$p(ordInfo,"^",14)
  ...s GetServerMaterial=$p(ordInfo,"^",18)
  ...s RecLocDesc=$p(ordInfo,"^",21)
  ...s RecLocDR=$p(ordInfo,"^",19)
  ...q:(LocDR'="")&(LocDR'=RecLocDR)
  ...s ItmCatDR=$p(ordInfo,"^",23)
  ...q:(GetServerMaterial'="Service")&(GetServerMaterial'="S")
  ...q:(GetItemStatusCode'="V")&(GetItemStatusCode'="E")
  ...;获得申请单的使用样式
  ...s AppType=""
  ...s ExamOrder=ordrowid_"||"_itmsub
  ...s Info=##class(web.DHCRisApplicationBill).GetAppShape(ExamOrder)
  ...s AppType=$p(Info,"^",3)
  ...s RRowid="",bedone=""
  ...s RRowid=$o(^DHCRBAppOrdi(0,ExamOrder,0)) 
  ...;--------------------------------------------------
  ...s GetPatientStatusCode="",GetPatientStatus="",GetReportStatus=""
  ...i RRowid'="" d
  ....s GetPatientStatusCode="A"  ;申请
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
  ...i GetPatientStatusCode'="" s GetPatientStatus=##class(web.DHCRisCommFunction).GetPatientStatusDesc(GetPatientStatusCode)
  ...i GetReportStatusCode'="" s GetReportStatus=##class(web.DHCRisCommFunction).GetReportStatusDesc(GetReportStatusCode)
  ...Do OutToDayOrder 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutToDayOrder
 
 set Data=$lb(ExamOrder,GetstrOrderName,GetPatientStatus,GetstrDate,GetstrTime,RecLocDesc,RecLocDR,GetResDesc,strRppDate,strRppTime,GetstrRegDate,GetstrRegTime,GetReportStatus,GetRptDocName,GetRptDate,GetRptTime,GetVerifyDocName,GetVerifyDate,GetVerifyTime)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QueryToDayOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryToDayOrderExecute ]
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

ClassMethod QueryToDayOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryToDayOrderExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
