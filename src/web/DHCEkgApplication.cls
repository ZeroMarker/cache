Class web.DHCEkgApplication Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod CalAge(Birth, Today) As %String
{
 ; pass in date of birth in internal format
 n XBirth,XToday,AgeDay,AgeMth,AgeYear,CurrMth,CurrYear,AgeYr,UseDOB
 s Birth=$g(Birth),Today=$g(Today)
 s reage=""
 q:(Birth="") ""
 s IBirth="",IToday=""
 s IBirth=$zdh(Birth,3)
 s IToday=$zdh(Today,3)
  ;hack of date of birth
 i IBirth>2980000 s IBirth=""
 i IBirth<0 s IBirth=""
 q:'$G(IBirth) ""
  ;
 s XBirth=$ZD(IBirth)
 s XToday=$ZD(IToday)
 s AgeMth=XToday-XBirth
 s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
 s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
 s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
 s AgeYear=CurrYear-BirthYear
 ;
 i AgeDay<0 d
 . s AgeMth=AgeMth-1
 . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
 . q:XToday'=2
 . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
 i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1

 s $P(AgeYr,"|",12)=AgeYear
 i $P(AgeYr,"|",12)=0 d
 .i AgeMth=0 s reage=AgeDay_"天"
 .e  s reage=AgeMth_"月 "
 e  s reage=$p(AgeYr,"|",12)_"岁 "
  ;s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
 q reage
}

ClassMethod GetTypeDesc(type) As %String
{
	I type="I" d
	.s Desc="住院病人"
	else  i type="O" d 
	.s Desc="门诊病人"
	else  i type="E" d 
	.s Desc="急诊病人"
	else  i type="H" d
	.s Desc="体检病人" d
	else
	.s Desc="其他病人"
   q Desc
}

ClassMethod GetPaadmInfo(paadmdr As %String) As %String
{
	s DHCRisSystemInfo=^DHCRisGetNameSet
     s RegNo="",Name="",strAge="",strDOB="",IPNO="",LocName="",SexDr=""
     s SexDesc="",typedesc="",IDCDesc="",patienttype="",wardname="",bedname=""
     s WardDr="",roomdesc="",feetype=""
     s DocName="",Docdr="",mradmdr="",Height="",Weight="",Telphone=""
     s DHCRisSystemInfo=""
     s papatmasmdr=$p(^PAADM(paadmdr),"^",1)        
     s RegNo=$p(^PAPER(papatmasmdr,"PAT",1),"^",1)  
     s Name=$p(^PAPER(papatmasmdr,"ALL"),"^",1)
     s DOB=$p(^PAPER(papatmasmdr,"ALL"),"^",6)
     .i DOB="" d
 	 ..s strDOB=""
 	 ..s strAge=""
 	 .e  d
     ..s strDOB=$ZD(DOB,3)
     ..s strToday=$ZD(+$h,3)
     ..s strAge=..CalAge(strDOB,strToday)
     s SexDr=$p(^PAPER(papatmasmdr,"ALL"),"^",7)
     s SexDesc=$p(^CT("SEX",SexDr),"^",2)
     s patienttype=$p(^PAADM(paadmdr),"^",2) ;病人类型
     s typedesc=..GetTypeDesc(patienttype)
  	 s Locdr=$p(^PAADM(paadmdr),"^",4)
     i $g(Locdr)'="" s LocName=$p(^CTLOC(Locdr),"^",2)
     s DHCRisSystemInfo=##class(web.DHCEkgSystemParam).GetSystemParam()
     s DHCRisVersion=$p(DHCRisSystemInfo,"^",15)
     s Adress=$g(^PAPER(papatmasmdr,"PER","ADD",1)) 
     i (DHCRisVersion="BJ_YY")!(DHCRisVersion="BJ_FX")!(DHCRisVersion="BJ_AZ") d  
     .s IPNO=$p(^PAPER(papatmasmdr,"PER",4),"^",4)   ;住院号(友谊/复兴医院）
     else  d
     .s IPNO=$p(^PAPER(papatmasmdr,"PAT",1),"^",2)
     ;s IPNO=$p(^PAPER(papatmasmdr,"PER",4),"^",4)   ;住院号(友谊医院）
     s Roomdr=$p(^PAADM(paadmdr),"^",69)
     i Roomdr'="" s roomdesc=$p(^PAROOM(Roomdr),"^",2)
     s WardDr=$p(^PAADM(paadmdr),"^",70)
     i WardDr'=""  s wardname=$p(^PAWARD(WardDr),"^",2)
     s beddr=$p(^PAADM(paadmdr),"^",73)
     i beddr'=""  d 
     .s wardrowid=$p(beddr,"||",1)
     .s bedchildsub=$p(beddr,"||",2)
     .s bedname=$p(^PAWARD(wardrowid,"BED",bedchildsub),"^",1)
     s admreasondr=$p(^PAADM(paadmdr,1),"^",7)
     i admreasondr'="" s feetype=$p(^PAC("ADMREA",admreasondr),"^",2)   ;费别
     s Docdr=$p(^PAADM(paadmdr),"^",9) ;;benna added
     s Telphone=$p(^PAPER(papatmasmdr,"PER",1),"^",11) 
     i $g(Docdr)'="" d
     .s DocName=$p(^CTPCP(Docdr,1),"^",2)
     .i $g(^DHCRisGetNameSet)="ID" s DocName=$p(^CTPCP(Docdr,1),"^",3)
     s mradmdr=$p(^PAADM(paadmdr),"^",61)
     i $g(mradmdr)'="" d
     .s Height=$p(^MR(mradmdr,"PRO",1),"^",20)
     .s Weight=$p(^MR(mradmdr,"PRO",1),"^",27)
     s Info=RegNo_"^"_Name_"^"_strDOB_"^"_strAge_"^"_$g(SexDesc)_"^"_patienttype_"^"_typedesc_"^"_$g(LocName)_"^"_IPNO_"^"_wardname_"^"_bedname_"^"_$g(Locdr)_"^"_SexDr_"^"_WardDr_"^"_roomdesc_"^"_feetype_"^"_Docdr_"^"_DocName_"^"_Telphone_"^"_Height_"^"_Weight
	 q Info
}

Query GetServiceOrder(PaAdmID As %String, Loc As %String) As %Query(ROWSPEC = "ExamOrder:%String,OrderName:%String,bedone:%String,datestr:%String,timestr:%String,GetstrRegDate:%String,GetstrRegTime:%String,GetMainDoc:%String,GetAssDoc:%String,GetRptDocName:%String,GetRptDate:%String,GetRptTime:%String,GetVerifyDocName:%String,GetVerifyDate:%String,GetVerifyTime:%String")
{
}

ClassMethod GetServiceOrderExecute(ByRef qHandle As %Binary, PaAdmID As %String, Loc As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 s ind=1
 s ret=0
 s PaAdmID=$p(PaAdmID,$C(0))
 s Loc=$p(Loc,$c(0))
  s strOrderName="",strRecLoc="",strStdate="",strAccessionNumber="",strExamOrder="",Wldr="",ModTypedr="",ModType=""
  s strDateCreated="",strTimeCreated="",strSeriesModality="",strOrderDate="",strOrderTime="",strCommon=""
  s CurOrderNo="",pointer1="",pointer2="",numb=""
  s OeREMID="",GoalName=""
  ;s aa="未核实",bb="停止",cc="执行",dd="暂缓",ee="核实", Statuscode=""
  ;  s pp=$g(^OEC("OSTAT",0,"Desc",ee))aa=2   bb=4  cc=6   dd=9  ee=1
  s statuscheck="1"
  s ord=0,itm=0
  f  s ord=$o(^OEORD(0,"Adm",PaAdmID,ord)) q:(ord="")  d
  . f  s itm=$o(^OEORD(ord,"I",itm)) q:(itm="")  d
  ..s ItemMastDr="",temStr="",Subscript="",Version="",OrdItemStatus="",ItemCatDR="",ARCICDesc="",OrderName="",OrderDate="",OrderTime="",RRowid="",dFlag=""
  ..s bedone="",timestr="",datestr=""
  ..s temStr=$g(^OEORD(ord,"I",itm,1))
  ..q:temStr=""
  ..s OrdItemStatusDR=$p(^OEORD(ord,"I",itm,1),"^",13)
  ..s GetItemStatusCode=""
  ..;q:GetItemStatusCode=""
  ..i OrdItemStatusDR'="" s GetItemStatusCode=$p(^OEC("OSTAT",OrdItemStatusDR),"^",1)
  ..q:(GetItemStatusCode'="V")&(GetItemStatusCode'="E") 
  ..;q:OrdItemStatus'=statuscheck
  ..s ItemMastDr=$p(^OEORD(ord,"I",itm,1),"^",2)  
  ..q:ItemMastDr=""
  ..s Subscript=$p(ItemMastDr,"||",1)
  ..s Version=$p(ItemMastDr,"||",2)
  ..s temStr=$g(^ARCIM(Subscript,Version,1))
  ..q:temStr=""
  ..s ServMaterial=$p(^ARCIM(Subscript,Version,7),"^",6)
  ..s ServMaterial=$g(ServMaterial)
  ..q:(ServMaterial'="Service")&(ServMaterial'="S")
  ..s ExamOrder=ord_"||"_itm
  ..s OrderName=$p(^ARCIM(Subscript,Version,1),"^",2)
  ..s OeREMID=$g(^OEORD(Subscript,"I",Version,"REM",0))
  ..i OeREMID="" d
  ...i $g(^OEORD(Subscript,"I",Version,"REM",OeREMID))'="" d
  ....s GoalName=$g(^OEORD(Subscript,"I",Version,"REM",OeREMID))
  ....i GoalName'="" s OrderName=OrderName_"(备注:"_GoalName_")"
  ..s OrderDate=$p(^OEORD(ord,"I",itm,3),"^",7)  ;3,7
  ..s datestr=$ZD(OrderDate,3)
  ..s OrderTime=$p(^OEORD(ord,"I",itm,1),"^",17)  ;3,7
  ..s timestr=$ZT(OrderTime,1)
  ..s bedone="",GetstrRegDate="",GetstrRegTime="",GetMainDoc="",GetAssDoc=""
  ..s GetRptDocName="",GetRptDate="",GetRptTime="",GetVerifyDocName="",GetVerifyDate="",GetVerifyTime=""
  ..s RRowid="" f  s RRowid=$o(^DHCRBAppi("OrdRowid",ExamOrder,RRowid)) q:RRowid=""  d
  ...s dFlag=$p(^DHCRBApp("Bill",RRowid),"^",1)
  ..i dFlag'=""  d
  ...s bedone="申请" 
  ...s GetRejDR=$o(^DHCRBRejecti("OeordDR",ExamOrder,0))
  ...i GetRejDR'="" d
  ....s bedone="拒绝申请"
  ...else  d
  ....i $g(^OEORD(ord,"I",itm,6))'="" d 
  .....s Getapprowid=$p(^OEORD(ord,"I",itm,6),"^",5)  ; 已经预约RB_Appointment Rowid
  .....i (Getapprowid'="") s bedone="预约" 
  .....s RegInfo=##class(web.DHCEkgRegister).GetRegInfo(ExamOrder)
  .....;w !,"RegInfo"_RegInfo
  .....s GetStudyNo=$p(RegInfo,"^",1)
  .....i GetStudyNo'="" d
  ......s bedone="登记"
  ......s GetstrRegDate=$p(RegInfo,"^",2)
  ......s GetstrRegTime=$p(RegInfo,"^",3)
  ......s GetMainDoc=$p(RegInfo,"^",6)
  ......s GetAssDoc=$p(RegInfo,"^",7)
  ......s Imrowid=0 f  s Imrowid=$o(^DHCRBStudyi("StudyNo-Images",GetStudyNo,Imrowid)) q:Imrowid=""  d
  .......s bedone="已采集图象"
  ......s sReportStuatCode="VS"
  ......s Rptrowid=0  f  s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",GetStudyNo,Rptrowid)) q:Rptrowid=""  d
  .......s GetRptID=$p(^DHCRBStudy("Report",Rptrowid),"^",2)
  .......s GetRptVersion=$p(^DHCRBStudy("Report",Rptrowid),"^",3)
  .......s GetRptStatusDR=$p(^DHCRBStudy("Report",Rptrowid),"^",4)
  .......i GetRptStatusDR'="" d
  ........s GetReportStatusCode=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",1)
  ........i sReportStuatCode[GetReportStatusCode d
  .........s GetPatientStatusCode="检查结束"
  ........e  d
  .........s GetPatientStatusCode="正在检查"
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
  ..else  d
  ...s bedone=""
  ..Do OutServiceOrder 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutServiceOrder
 set Data=$lb(ExamOrder,OrderName,bedone,datestr,timestr,GetstrRegDate,GetstrRegTime,GetMainDoc,GetAssDoc,GetRptDocName,GetRptDate,GetRptTime,GetVerifyDocName,GetVerifyDate,GetVerifyTime)
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

ClassMethod InsRD(StrEdt) As %Integer
{
  i StrEdt="" q 0
  s OeItemID=$P(StrEdt,"&",1)  
  s DocDR=$P(StrEdt,"&",2) 
  s LocDR=$P(StrEdt,"&",3) 
  s illnessdr=$P(StrEdt,"&",4)   
  s Goal=$P(StrEdt,"&",5)
  s XXDate=$P(StrEdt,"&",6) 
  s XDate=$zdh($g(XXDate),3) 
  s ttDate=$P(StrEdt,"&",7)
  s tType=$P(StrEdt,"&",8)
  s maindiagosedr=$P(StrEdt,"&",9)
  s XMLContent=$P(StrEdt,"&",10)
  s OeItemDate=$zdh($g(ttDate),3)               
  s RDate=+$h   
  s RTime=$P($h,",",2)
  s dFlag=""	
  s index=$o(^DHCRBApp("Bill",""),-1)+1
  ;s ^DHCRBApp = index
  s tempstr=RDate_"^"_Goal_"^"_illnessdr_"^"_LocDR_"^"_maindiagosedr_"^"_OeItemID_"^"_""_"^"_RTime _"^"_ DocDR _"^"_XDate
  s ^DHCRBApp("Bill",index)=tempstr
  s ^DHCRBApp("Bill",index,"XMLContent")=XMLContent
  s ^DHCRBAppi("OrdRowid",OeItemID,index)=""
  ; w $o(^DHCRBAppi("OrdRowid","11",""))
  q 0
}

ClassMethod EdtRD(StrEdt) As %Integer
{
  i StrEdt="" q 0
  s OeItemID=$P(StrEdt,"&",1)  
  s DocDR=$P(StrEdt,"&",2) 
  s LocDR=$P(StrEdt,"&",3) 
  s illnessdr=$P(StrEdt,"&",4)   
  s Goal=$P(StrEdt,"&",5)
  s XXDate=$P(StrEdt,"&",6) 
  s XDate=$zdh($g(XXDate),3)  
  s ttDate=$P(StrEdt,"&",7)
  s tType=$P(StrEdt,"&",8)
  s maindiagosedr=$P(StrEdt,"&",9)
  s OeItemDate=$zdh($g(ttDate),3)               
  s RDate=+$h   
  s RTime=$P($h,",",2)
  s dFlag=""	
  s index=$o(^DHCRBAppi("OrdRowid",OeItemID,""))
  ;s ^DHCRBApp = index
  s tempstr=RDate_"^"_Goal_"^"_illnessdr_"^"_LocDR_"^"_maindiagosedr_"^"_OeItemID_"^"_""_"^"_RTime _"^"_ DocDR _"^"_XDate
  s ^DHCRBApp("Bill",index)=tempstr
  ; w $o(^DHCRBAppi("OrdRowid","11",""))
  q 0
}

Query GetGoal(OrdRowID As %String) As %Query(ROWSPEC = "goalrowid:%String,goaldesc:%String")
{
}

ClassMethod GetGoalExecute(ByRef qHandle As %Binary, OrdRowID As %String) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCEkgApplication","GetGoal","8697||25")
 Set repid=$I(^CacheTemp)
 s ind=1
 q:OrdRowID=""
  s ord=$p(OrdRowID,"||",1)
  s itm=$p(OrdRowID,"||",2)
  s OeItemCat=$p(^OEORD(ord,"I",itm,1),"^",2)
  q:OeItemCat=""
 s goalrowid="",goaldesc=""
  f  s goalrowid=$o(^DHCRBAppi("Goal-orditem",OeItemCat,goalrowid)) q:(goalrowid="")  d
  .;w "  -  "_goalrowid_"  -  "
  .i goalrowid'="" d
  ..s goaldesc=""
  ..i $d(^DHCRBCApp("GLOBAL",goalrowid)) d 
  ...s goaldesc=$p(^DHCRBCApp("GLOBAL",goalrowid),"^",2) 
  ..Do OutGoal 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutGoal
 set Data=$lb(goalrowid,goaldesc)
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

Query Getillstr(paadmrowid As %String) As %Query(ROWSPEC = "illstrrowid:%String,orderrowid:%String,illstr:%String")
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
 set Data=$lb(illstrrowid,orderrowid,illstr)
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

ClassMethod InsIllstr(StrEdt) As %Integer
{
	 /*
  i StrEdt="" q 0
  s OeItem=$P(StrEdt,"&",1)  
  s PaAdm=$P(StrEdt,"&",2) 
  s Detail=$P(StrEdt,"&",3)
  s DHCRisSystemInfo=##class(web.DHCEkgSystemParam).GetSystemParam()
  s DHCRisVersion=$p(DHCRisSystemInfo,"^",15)
  i (DHCRisVersion="BJ_FX") d  //复兴升级0911 qzg
  .s index=$o(^DHCRBCApp("IllStatus",""),-1)+1
  .s tempstr=PaAdm_"^"_OeItem_"^"_Detail
  .s ^DHCRBCApp("IllStatus",index)=tempstr
  .s ^DHCRBAppi("illstatu-roditem",PaAdm,index)=""
  e  d
  .&sql(insert into DHCRBC_IllStatus (DIS_Oeorditem_DR,DIS_PaAdm_DR,DIS_IllStatus) values(:OeItem,:PaAdm,:Detail))
  .s index=$p(%ROWID,$c(1))
  q index
  */
}

ClassMethod EdtIllstr(StrEdt) As %Integer
{
  /*
  i StrEdt="" q 0
  s OeItem=$P(StrEdt,"&",1)  
  s PaAdm=$P(StrEdt,"&",2) 
  s Detail=$P(StrEdt,"&",3) 
  s illstrrowid=$P(StrEdt,"&",4)
  s ret=0
  
  s DHCRisSystemInfo=##class(web.DHCEkgSystemParam).GetSystemParam()
  s DHCRisVersion=$p(DHCRisSystemInfo,"^",15)
  i (DHCRisVersion="BJ_FX") d  //复兴升级0911 qzg
  .s index=illstrrowid
  .s tempstr=PaAdm_"^"_OeItem_"^"_Detail
  .s ^DHCRBCApp("IllStatus",index)=tempstr
  e  d
  .&sql(update DHCRBC_IllStatus(DIS_Oeorditem_DR,DIS_PaAdm_DR,DIS_IllStatus)values(:OeItem,:PaAdm,:Detail) where DIS_RowID=:illstrrowid)
  .s ret=SQLCODE
  q ret
  */
}

ClassMethod DelIllstr(StrEdt) As %Integer
{
  i StrEdt="" q 0
  s index=StrEdt
  s paadmdr=$p(^DHCRBCApp("IllStatus",index),"^",1)
  k ^DHCRBCApp("IllStatus",index)
  k ^DHCRBAppi("illstatu-roditem",paadmdr,index)
  q 0
}

ClassMethod InsGoal(StrEdt) As %Integer
{
  i StrEdt="" q 0
  s OeItem=$P(StrEdt,"&",1)  
  s Detail=$P(StrEdt,"&",2) 
  q:OeItem=""
  s ord=$p(OeItem,"||",1)
  s itm=$p(OeItem,"||",2)
  s OeItemCat=$p(^OEORD(ord,"I",itm,1),"^",2)
  s tempstr=OeItemCat_"^"_Detail
  i $d(^DHCRBAppi("Goal-orditem",OeItemCat)) d
  .s index=$o(^DHCRBAppi("Goal-orditem",OeItemCat,""))
  .s ^DHCRBCApp("GLOBAL",index)=tempstr
  e  d
  .s index=$o(^DHCRBCApp("GLOBAL",""),-1)+1
  .s ^DHCRBCApp("GLOBAL",index)=tempstr
  .s ^DHCRBAppi("Goal-orditem",OeItemCat,index)=""
  ; w $o(^DHCRBAppi("illstatu-roditem","11",""))
  q index
}

ClassMethod EdtGoal(StrEdt) As %Integer
{
  i StrEdt="" q 0  
  s OeItem=$P(StrEdt,"&",1)  
  s Detail=$P(StrEdt,"&",2) 
  s GoalRowid=$P(StrEdt,"&",3)
  q:OeItem="" 0
  s ord=$p(OeItem,"||",1)
  s itm=$p(OeItem,"||",2)
  s OeItemCat=$p(^OEORD(ord,"I",itm,1),"^",2) 
  s index=GoalRowid
  ;s ^DHCRBApp = index
  s tempstr=OeItemCat_"^"_Detail
  s ^DHCRBCApp("GLOBAL",index)=tempstr
  ; w $o(^DHCRBAppi("OrdRowid","11",""))
  q 0
}

ClassMethod DelGoal(StrEdt) As %Integer
{
  i StrEdt="" q 0
  s index=StrEdt
  s orditemdr=$p(^DHCRBCApp("GLOBAL",index),"^",1)
  k ^DHCRBCApp("GLOBAL",index)
  k ^DHCRBAppi("Goal-orditem",orditemdr,index)
  q 0
}

ClassMethod GetMainZD(ADMdr As %String) As %String
{
	//d ##class(web.DHCEkgApplication).GetMainZD("2810435")
 s DiagName="",DiagDR="",DiagType="",Info=""
 s DiagTypeDR=""
 i ADMdr="" q Info
 //从电子病历取主要诊断
 s DHCRisSystemInfo=##class(web.DHCEkgSystemParam).GetSystemParam()
 s DHCRisVersion=$p(DHCRisSystemInfo,"^",15)
 s PatientType=$P(^PAADM(ADMdr),"^",2) //modify by sjc 2007.6.12  增加了对于门诊与住院病人的分别处理，因住院病人通过EPR取诊断
 if ((DHCRisVersion="BJ_AZ")&(PatientType="I")) d  //modify by sjc 2007.6.12
 .s CurrSpace=$ZNSPACE
 .d ##class(web.DHCEkgSystemParam).SetEPRNameSpace()
 .s DiagName=##class(DHC.EPR.ExportUtil).GetByAdmidAndCode(ADMdr,"#{1||23-D-42}")
 .i DiagName'=""  s Info="^"_DiagName
 .zn CurrSpace
 q:Info'="" Info
 s MRRowId=$p(^PAADM(ADMdr),"^",61)
 i $d(^MR(MRRowId,"DIA",0)) d
 .s MRCount=^MR(MRRowId,"DIA",0) 
 .s MROrd=0
 .f  s MROrd=$o(^MR(MRRowId,"DIA",MROrd)) q:(MROrd="")   d
 ..s DiagDR=$p(^MR(MRRowId,"DIA",MROrd),"^",1)
 ..s DiagName="",DiagType=""
 ..i DiagDR'=""  d
 ...s DiagName=$p($g(^MRC("ID",DiagDR)),"^",2)
 ...s DiagTypeDR =$g( ^MR(MRRowId,"DIA",MROrd,"TYP",1))
 ...i $d(^MR(MRRowId,"DIA",MROrd,"DES",1)) d  
 ....s DiagName=^MR(MRRowId,"DIA",MROrd,"DES",1)
 ..s Info=Info_DiagDR_"^"_DiagName_";"  ;_"%"_DiagTypeDR
 q Info
}

ClassMethod GetEPRZS(paadmdr) As %String
{
 s ZS=""
 s DHCRisSystemInfo=##class(web.DHCEkgSystemParam).GetSystemParam()
 s DHCRisVersion=$p(DHCRisSystemInfo,"^",15)
 s CurrSpace=$ZNSPACE
 if (DHCRisVersion="BJ_AZ") d
 .d ##class(web.DHCEkgSystemParam).SetEPRNameSpace()
 .s ZS=##class(DHC.EPR.ExportUtil).GetByAdmidAndCode(paadmdr,"#{1||14-D-9}")
 .zn CurrSpace
 q ZS
}

ClassMethod InsertRDDetail(Info As %String) As %Integer
{
	/*
	s OeItemDR="",MediumDR="",FileFullName="",RRowid=""
	i Info="" q 0  
	s OeItemDR=$P(Info,"^",1)
    s MediumDR=$P(Info,"^",2)
	s FileFullName=$P(Info,"^",3)
	s RRowid=$o(^DHCRBAppi("OrdRowid",OeItemDR,""))
	i RRowid="" d
	. &sql(INSERT INTO RIS.DHCRB_ApplicationBill (DRA_OeItemID_DR,DRA_Medium_DR,DRA_FullFileName)values(:OeItemDR,:MediumDR,:FileFullName))
    e  d
    . &sql(UPDATE RIS.DHCRB_ApplicationBill SET DRA_Medium_DR =:MediumDR,DRA_FullFileName=:FileFullName where DRA_OeItemID_DR=:OeItemDR)
    
  q 0
  */
}

ClassMethod GetRDDetail(OeItemID As %String) As %String
{
 s DiagName="",DiagDR="",GoalDR="",GoalName="",IllstrDR="",IllstrName="",Info=""
 s DocDR="",DocName="",Rdate="",Xdate="",MediumDR="",MediumDRName="",ImgFileName=""
 i OeItemID="" q Info
 s DHCRisSystemInfo=##class(web.DHCEkgSystemParam).GetSystemParam()
 s DHCRisVersion=$p(DHCRisSystemInfo,"^",15)
 s OrderRowid=$p(OeItemID,"||",1)
 s itemsub=$p(OeItemID,"||",2)
 s RRowid=$o(^DHCRBAppi("OrdRowid",OeItemID,""))
 i RRowid'=""   d
 .s MediumDR=$p(^DHCRBApp("Bill",RRowid),"^",11)
 .i MediumDR'="" d
 ..s MediumDRName=$p(^DHCRBCServer("Medium",MediumDR),"^",2) 
 .s ImgFileName=$p(^DHCRBApp("Bill",RRowid),"^",12)
 .;s DiagDR=$p(^DHCRBApp("Bill",RRowid),"^",5)
 .;i DiagDR '=""  d
 .;.s DiagName=$p(^MRC("ID",DiagDR),"^",2)
 .s DiagName=$p(^DHCRBApp("Bill",RRowid),"^",5)
 .s GoalDR=$p(^DHCRBApp("Bill",RRowid),"^",2)
 .i GoalDR '="" d
 ..s GoalName=$p($g(^DHCRBCApp("GLOBAL",GoalDR)),"^",2) 
 .s IllstrDR=$p(^DHCRBApp("Bill",RRowid),"^",3)
 .i IllstrDR '="" d
 ..s IllstrName=$p($g(^DHCRBCApp("IllStatus",IllstrDR)),"^",3)
 .s OeREMID=$g(^OEORD(OrderRowid,"I",itemsub,"REM",0))
 .i OeREMID="" d
 ..i $g(^OEORD(OrderRowid,"I",itemsub,"REM",OeREMID))'="" d
 ...if (DHCRisVersion'="BJ_FX") s GoalName=$g(^OEORD(OrderRowid,"I",itemsub,"REM",OeREMID))
 .s DocDR=$p(^DHCRBApp("Bill",RRowid),"^",9)
 .i DocDR '="" d
 ..s DocName=$p(^SSU("SSUSR",DocDR),"^",2)
 .s Rdate=$p(^DHCRBApp("Bill",RRowid),"^",1)
 .s RTime=$p(^DHCRBApp("Bill",RRowid),"^",8)     ////申请时间
 .s RTime=$zt(RTime,1)
 .s Xdate=$p(^DHCRBApp("Bill",RRowid),"^",10)
 .s Info=DiagDR_"^"_DiagName_"^"_GoalDR_"^"_GoalName_"^"_IllstrDR_"^"_IllstrName_"^"_DocName_"^"_$ZD(Rdate,3) _"^"_$ZD(Xdate,3) _"^"_DocDR_"^"_MediumDR_"^"_MediumDRName_"^"_ImgFileName_"^"_RTime
 ;w Info
 q Info
}

ClassMethod GetYYRDDetail(OeItemID As %String) As %String
{
 s Info="",Date="",Detail="",DocID="",DocName="",Goal="",MainMemo="",Time="",XDate=""
 i OeItemID="" q Info
 s RRowid=$o(^DicomRDi("OrdRowid",OeItemID,""))
 i RRowid '=""   d
 .s Date=$p(^DicomRD(RRowid),"^",3)
 .s Detail=$p(^DicomRD(RRowid),"^",5)
 .s DocID=$p(^DicomRD(RRowid),"^",2)
 .i DocID '="" d
 ..s DocName=$p(^SSU("SSUSR",DocDR),"^",2)
 .s Goal=$p(^DicomRD(RRowid),"^",7)
 .s MainMemo=$p(^DicomRD(RRowid),"^",11)
 .s Time=$p(^DicomRD(RRowid),"^",4)
 .s XDate=$p(^DicomRD(RRowid),"^",8)
 .s Info=$ZD(Date,3)_"^"_Detail_"^"_DocName_"^"_Goal_"^"_MainMemo_"^"_Time_"^"_$ZD(XDate,3)
 ;w Info
 q Info
}

ClassMethod GetLocWard(LocDR As %String) As %String
{
 s WardDR="",WardCode="",WardDesc="",Info=""
 i LocDR="" q Info
 s WardDR=$o(^PAWARD(0,"WARD_LocationDR",LocDR,""))
 i WardDR="" q Info
 s WardCode=$p(^PAWARD(WardDR),"^",1)
 s WardDesc=$p(^PAWARD(WardDR),"^",2)
 s Info=WardDR_"^"_WardCode_"^"_WardDesc
 q Info
}

Query GetWardPat(WardRowID As %String) As %Query(ROWSPEC = "bed:%String,curname:%String,curregno:%String")
{
}

ClassMethod GetWardPatExecute(ByRef qHandle As %Binary, WardRowID As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 s ind=1
  q:WardRowID=""
 	n curNum,curparoom,curparowid,curpavisit,curadmno,curpapapmi,curregno,curname,CurrentBedDR5,BedWardP5
	n bedBEF,bedAFT
	k ^DHCTMPLCBED($j)
	s curNum=0
	s parward=WardRowID
	s curparoom=0 f  s curparoom=$o(^PAADMi("CurrWard",parward,curparoom)) q:curparoom=""  d
	.s curparowid=0 f  s curparowid=$o(^PAADMi("CurrWard",parward,curparoom,curparowid)) q:curparowid=""  d
	..s papmi="",CurrentBedDR="",BedWardP="" ,bed="" 
	..s curpavisit=$p($g(^PAADM(curparowid)),"^",20)
	..i curpavisit'="D" d
	...s curadmno=$p($g(^PAADM(curparowid)),"^",81)
	...s curpapapmi=$p($g(^PAADM(curparowid)),"^",1)
	...s curregno=$p($g(^PAPER(curpapapmi,"PAT",1)),"^",1)
	...s curname=$p($g(^PAPER(curpapapmi,"ALL")),"^",1)
	...s CurrentBedDR5=$p($g(^PAADM(curparowid)),"^",73) 
	...q:$g(CurrentBedDR5)=""                                    ;T:pac_bed
	...s BedWardP5=$p(CurrentBedDR5,"||",2)                        ;pac_ward
	...q:BedWardP5=""
	...s bed=$p($g(^PAWARD(parward,"BED",BedWardP5)),"^",1)          ;T:pac_bed     
	...q:$g(bed)="" 
	...;
	...s bedBEF=+bed
	...i bedBEF=0 d
	....i bed["-"  d
	.....s bedBEF=$p(bed,"-",1)
	.....s bedAFT=$p(bed,"-",2)
	....e  d
	.....s bedBEF=bed
	.....s bedAFT=0
	...e  d
	....i bed["-"  d
	.....s bedAFT=$p(bed,"-",2)
	....e  d
	.....s bedAFT=0
	...;s rowid=parowid
	...s ^DHCTMPLCBED($j,bedBEF,bedAFT,curparowid,bed)=$g(bed)_$c(2)_$g(curname)_$c(2)_$g(curregno)
    i $d(^DHCTMPLCBED($j))'=0 d
    .s bedBEF=0 f  s bedBEF=$o(^DHCTMPLCBED($j,bedBEF)) q:bedBEF=""  d
    ..s bedAFT="" f  s bedAFT=$o(^DHCTMPLCBED($j,bedBEF,bedAFT)) q:bedAFT=""  d
    ...s patrowid=0 f  s patrowid=$o(^DHCTMPLCBED($j,bedBEF,bedAFT,patrowid)) q:patrowid=""  d
    ....s curtembed=0 f  s curtembed=$o(^DHCTMPLCBED($j,bedBEF,bedAFT,patrowid,curtembed)) q:curtembed=""  d
    .....s curallitems=$g(^DHCTMPLCBED($j,bedBEF,bedAFT,patrowid,curtembed))
    .....s bed=$p(curallitems,$c(2),1)
    .....s curname=$p(curallitems,$c(2),2)
    .....s curregno=$p(curallitems,$c(2),3)
    .....s curNum=curNum+1
	.....Do OutWardPat
 Set qHandle=$lb(0,repid,0)
 i $d(^DHCTMPLCBED($j))'=0 k ^DHCTMPLCBED($j)
 Quit $$$OK
OutWardPat
 set Data=$lb(bed,curname,curregno)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetWardPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWardPatExecute ]
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

ClassMethod GetWardPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWardPatExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod UpdateRejectApplication(oeordrowid As %String, Info As %String) As %String
{
	/*
	s Selrowid=""
	i Info'="" d
	.s rowid=0 f  s rowid=$o(^DHCRBReject("Reason",rowid)) q:rowid=""  d
	..s Getinfo=$p(^DHCRBReject("Reason",rowid),"^",1)
	..i Getinfo=Info s Selrowid=rowid
	.i Selrowid="" d
	..&sql(insert into DHCRBC_RejectReason  (DRR_Desc) values (:Info))
	..i SQLCODE=0 s Selrowid=$p(%ROWID,$c(1))
	s rejArowid=$o(^DHCRBRejecti("OeordDR",oeordrowid,0))
	i rejArowid'="" d
	.&sql(update DHCRB_RejectApplication (DRA_OeordItm_DR,DRA_Reason_DR) values(:oeordrowid,:Selrowid) where  DRA_RowID=:rejArowid)
	else  d
	.&sql(insert into DHCRB_RejectApplication (DRA_OeordItm_DR,DRA_Reason_DR) values(:oeordrowid,:Selrowid))
	q SQLCODE
	*/
}

ClassMethod RemoveReject(oeordrowid As %String) As %String
{
	//&sql( delete from DHCRB_RejectApplication where DRA_OeordItm_DR=:oeordrowid)
	//q SQLCODE
}

Query QueryRejectReseaon() As %Query(ROWSPEC = "Desc:%String")
{
}

ClassMethod QueryRejectReseaonExecute(ByRef qHandle As %Binary) As %Status
{
 Set repid=$I(^CacheTemp)
 s ind=1
 s rowid=0 f  s rowid=$o(^DHCRBReject("Reason",rowid)) q:rowid=""  d
 .s Getinfo=$p(^DHCRBReject("Reason",rowid),"^",1)
 .Do OutR
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutR
 set Data=$lb(Getinfo)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QueryRejectReseaonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRejectReseaonExecute ]
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

ClassMethod QueryRejectReseaonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRejectReseaonExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

Query QueryNurse(strCondition As %String) As %Query(ROWSPEC = "Toeorditemdr:%String,TsPrint:%String,TPatientStatus:%String,TOrderDate:%String,TOrderTime:%String,TRegNo:%String,TBedNo:%String,TName:%String,TSexDesc:%String,TstrAge:%String,TstrOrderName:%String,TMemo:%String,TmPrint:%String,TMainDocName:%String,TSencDocName:%String,TAppointDate:%String,TAppointTime:%String,TNeedAppoint:%String,TPaadmRowid:%String")
{
}

ClassMethod QueryNurseExecute(ByRef qHandle As %Binary, strCondition As %String) As %Status
{
   ;s ^gptest1=strCondition 
   ;s  strCondition=
   ;病区rowid^病人登记号^状态Code^只显示床旁医YN^Y只显示无需预约 N只显示需要预约 A显示全部 ^开始日期^开始时间^结束日期^结束时间
   ;s ^benna=strCondition
   ;s strCondition="168&&&N&N&2006-12-28&00:00:00&2007-01-01&00:00:00"
   ;s strCondition="124&&&N&N&2007-01-02&00:00:00&2007-01-08&00:00:00"
   s InWardDR=$p(strCondition,"&",1)
   s InWardDR=$p($g(InWardDR),$c(0))
   
   s InRegNo=$p(strCondition,"&",2)
   s InRegNo=$p(InRegNo,$c(0))
   
   s InStatusCode=$p(strCondition,"&",3)
   s InStatusCode=$p(InStatusCode,$c(0))
   
   s InChuangpang=$p(strCondition,"&",4)
   s InChuangpang=$p(InChuangpang,$c(0))
   
   s InNoAppoint=$p(strCondition,"&",5)
   s InNoAppoint=$p(InNoAppoint,$c(0))
   
   
   s InStdDate=$p(strCondition,"&",6)
   s InStdDate=$p(InStdDate,$c(0))
   s InStdDate=$zdh($g(InStdDate),3)
   
   s InStdTime=$p(strCondition,"&",7)
   s InStdTime=$p(InStdTime,$c(0))
   s InStdTime=$ZTIMEH(InStdTime,1)
   
   s InEnddate=$p(strCondition,"&",8)
   s InEnddate=$p(InEnddate,$c(0))
   s InEnddate=$zdh($g(InEnddate),3)
   
   s InEndTime=$p(strCondition,"&",9)
   s InEndTime=$p(InEndTime,$c(0))
   s InEndTime=$ZTIMEH(InEndTime,1)
   
   //s ^gptest="^"_type_"^"_RegNo_"^"_StudyNo_"^"_LocDr_"^"_StdDate_"^"_enddate_"^"_StatusCode_"^"_ReportDoc_"^"_VerifyDoc_"^"_Name_"^"_ResourceID_"^"_OrderByIndex_"^"_RoomDR_"^"_InPatientNo_"^"_RequireAppoint_"^"_IsBedOrd_"^"_AppLocDR_"^"_EQGroupDR_"^"_WardDR_"^"_NO
   Set repid=$I(^CacheTemp)
   If $g(ind)="" Set ind=1
         
   //s LocDr=##class(web.DHCEkgLocInfo).GetLocDR(LocDesc)
   //if LocDr="" s LocDr=%session.Get("LOGON.CTLOCID")
   
   //type As %String, RegNo As %String, StudyNo As %String, LocDr As %String, StdDate As %String, enddate As %String, StatusCode As %String, ReportDoc As %String, VerifyDoc As %String, Name As %String, ResourceID As %String, OrderByIndex As %String, RegEQ As %String,RoomDR As %String,InPatientNo As %String,RequireAppoint As %String,IsBedOrd As %String,AppLocDR As %String,EQGroupDR As %String,WardDR As %String,NO As %String
   s return=..NQueryByWard(InWardDR,InRegNo,InStatusCode,InChuangpang,InNoAppoint,InStdDate, InStdTime,InEnddate,InEndTime)
  		//Set qHandle=$lb(0,repid,0)
   Quit $$$OK

   
	/*if (OrderByIndex="on")
   {
	 s return=..OrderByIndex(LocDr,StdDate,OrderByIndex)  
	 Quit $$$OK
   }
	i (RegNo="")&(StudyNo="")&(Name="")&(InPatientNo="")
    {
	    s return=..QueryByLoc(type,LocDr,StdDate,enddate,StatusCode,ReportDoc, VerifyDoc,ResourceID,RoomDR,RegEQ,RequireAppoint,IsBedOrd,RegNo,StudyNo,Name,InPatientNo,AppLocDR)
   	    Quit $$$OK
     }
   if (StudyNo'="") 
   {	
	   s return=..QueryByStudyNo(type,StudyNo, LocDr,StdDate,enddate,StatusCode,ReportDoc,VerifyDoc,IsBedOrd)
       Quit $$$OK
   }
   
   if (RegNo'="")
   {
	    s return=..QueryByRegNo(type,RegNo,LocDr,StdDate,enddate,StatusCode,ReportDoc,VerifyDoc)
		Quit $$$OK
   }
   
   if (Name'="")
   {
	   s return=..QueryByName(type,Name,LocDr,StdDate,enddate,StatusCode,ReportDoc, VerifyDoc)
	   Quit $$$OK
   }
   */
}

ClassMethod QueryNurseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryNurseExecute ]
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

ClassMethod QueryNurseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryNurseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryByWard(InWardDR As %String, InRegNo As %String, InStatusCode As %String, InChuangpang As %String, InNoAppoint As %String, InStdDate As %String, InStdTime As %String, InEnddate As %String, InEndTime As %String)
{
	
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    f date=InStdDate:1:InEnddate d
    .s count=..QueryBookedItem(InWardDR, InRegNo, InStatusCode, InChuangpang , InNoAppoint, date)  ;查询到指定的日期的预约医嘱
    .;s sPrint="",iiirowid="",tempneed=""
    .s OrderRowid="" f  s OrderRowid=$o(^OEORDi(0,"ItemDate",date,OrderRowid)) q:OrderRowid=""  d               ;循环查询
    ..s itemsub=0 f  s itemsub=$o(^OEORDi(0,"ItemDate",date,OrderRowid,itemsub)) q:(itemsub="")  d
    ...s GetPaadmr=""
    ...s sPrint="",mPrint="",iiirowid="",tempneed=""
	...s reploc=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)   ;检查科室
	...;q:(reploc'=InLocDr)&(InLocDr'="")
	...s oeorditemdr=OrderRowid_"||"_itemsub
	...s RRowid=$o(^DHCRBAppi("OrdRowid",oeorditemdr,""))
	...i $g(RRowid)'=""  d
	....s sPrint=$p(^DHCRBApp("Bill",RRowid),"^",7)
	....s mPrint=$p(^DHCRBApp("Bill",RRowid),"^",13)
	...;s iiirowid=$o(^DHCRBAppi("OrdRowid",OeItemID,"")) ;benna added
	...;q:'$d(iiirowid)
	...s paadmdr=$p(^OEORD(OrderRowid),"^",1) 
	...s pawarddr=$p(^PAADM(paadmdr),"^",70)  ; warddr
	...q:pawarddr'=InWardDR          ;过滤不是本病区的病人医嘱
	...s GetIDCDesc=##class(web.DHCEkgPatientInfo).GetDiagnose(paadmdr)
    ...s PatInfo=##class(web.DHCEkgPatientInfo).GetPaadmInfo(paadmdr)
    ...s GetRegNo=$p(PatInfo,"^",1)
    ...s GetName=$p(PatInfo,"^",2)
    ...s GetstrDOB=$p(PatInfo,"^",3)
    ...s GetstrAge=$p(PatInfo,"^",4)
 	...s GetSexDesc=$p(PatInfo,"^",5)
    ...s Getpatienttype=$p(PatInfo,"^",6)
    ...s Gettypedesc=$p(PatInfo,"^",7)
    ...s GetLocName=$p(PatInfo,"^",8)
    ...s GetIPNo=$p(PatInfo,"^",9)
    ...s GetWardName=$p(PatInfo,"^",10)
    ...s GetBedNo=$p(PatInfo,"^",11)
    ...s GetLocdr=$p(PatInfo,"^",12)
    ...;s GetWardDr=$p(PatInfo,"^",14)
    ...;q:(InWardDR'="")&(GetWardDr'=InWardDR)
    ...q:(InRegNo'="")&(GetRegNo'=InRegNo)
    ...;w GetRegNo_" "
    ...;q:(InName'="")&(GetName'[InName)
    ...;q:(InPatientNo'="")&(InPatientNo'=GetIPNo)
    ...;q:(InAppLocDR'="")&(GetLocdr'=InAppLocDR)
    ...;q:(Intype'="")&(Intype'=Getpatienttype)
    ...s GetPaadmr=$p(^OEORD(OrderRowid),"^",1)
    ...s ordInfo=##class(web.DHCEkgOeorditem).GetOeorditminfo(OrderRowid,itemsub)
    ...;s ^benna= ordInfo
    ...s GetstrOrderName=$p(ordInfo,"^",1)
    ...s GetstrDate=$p(ordInfo,"^",2)
    ...s GetstrTime=$p(ordInfo,"^",3)
    ...s Getrequestdoc=$p(ordInfo,"^",4)
    ...s GetstrAccessionNum=$p(ordInfo,"^",5)
    ...s GetSGroupDesc=$p(ordInfo,"^",6)
    ...s GetsubCatDesc=$p(ordInfo,"^",7)
    ...s GetCatDesc=$p(ordInfo,"^",8)
    ...s Getifbed=$p(ordInfo,"^",9)
    ...s Getprice=$p(ordInfo,"^",10)
    ...s GetNum=$p(ordInfo,"^",11)
    ...s GetTotalPrice=$p(ordInfo,"^",12)
    ...s Getbilled=$p(ordInfo,"^",13)
    ...s GetItemStatusCode=$p(ordInfo,"^",14)
    ...s GetordDate=$p(ordInfo,"^",15)
    ...s GetordTime=$p(ordInfo,"^",16)
    ...s GetItemStatusCode=$p(ordInfo,"^",17)
    ...q:GetItemStatusCode="D"   ;停止    
    ...s GetServerMaterial=$p(ordInfo,"^",18)
    ...q:(InNoAppoint="N")&(GetSGroupDesc="无需预约")  ;
    ...q:(InNoAppoint="Y")&(GetSGroupDesc'="无需预约")
    ...i (GetSGroupDesc="无需预约")  d  s tempneed="N"
    ...e  d  s tempneed="Y"
    ...;q:(InChuangpang="Y")&(Getifbed'="Y")  ;检索床旁医嘱，不是床旁医嘱
    ...q:(InChuangpang="Y")&(GetstrOrderName'["床旁")  ;检索床旁医嘱，不是床旁医嘱
    ...;s SystemParamInfo=##class(web.DHCEkgSystemParam).GetSystemParam()
    ...;s SendApptoLoc=$p(SystemParamInfo,"^",3)  ;没写申请单,是否发检查医嘱到检查科室
    ...;s SendInPtoLoc=$p(SystemParamInfo,"^",4)  ;没收费是否把住院病人的检查项目发送到检查科室  
    ...;s SendOutPtoLoc=$p(SystemParamInfo,"^",5) ;没收费是否把门诊检查项目发送到检查科室
    ...;s SendEmPtoLoc=$p(SystemParamInfo,"^",6)   ;没收费是否把急诊病人检查项目发送到检查科室
    ...;s QueryonlyExam=$p(SystemParamInfo,"^",9)  ;是否只查询检查项目
    ...;s SendHPtoLoc=$p(SystemParamInfo,"^",10)   ;没收费是否把体检病人的检查项目发送检查科室
    ...;q:(SendInPtoLoc="N")&(Getbilled'="P")&(Getpatienttype="I")    ;住院病人没有付费的退出
    ...;q:(SendOutPtoLoc="N")&(Getbilled'="P")&(Getpatienttype="O")   ;门诊病人没有付费退出
    ...;q:(SendEmPtoLoc="N")&(Getbilled'="P")&(Getpatienttype="E")   ;急症病人没付费退出
    ...;q:(SendHPtoLoc="N")&(Getbilled'="P")&(Getpatienttype="H")   ;体检病人没付费退出
    ...q:(GetServerMaterial'="Service")&(GetServerMaterial'="S") ;不是检查项目的则退出 q:(GetServerMaterial'="Service")
    ...s GetPatientStatusCode="A"  ;申请
    ...s GetReportStatusCode="N"  ;未写报告
    ...s Getapprowid="",GetRoomDr=""
    ...s GetRptDocName="",GetVerifyDocName="",GetStudyNo="",GetstrRegDate="",GetstrRegTime="",GetIndex="",GetEQDesc="",GetMainDoc="",GetAssDoc=""
    ...s GetEQDr="",GetRoomDesc="",GetAppointDate="",GetAppointstTime="",GetResDesc="",GetEQGroupDesc="",GetEQGroupDR="",NO=""
    ...s bOut="N"  ;是否已经输出
    ...i (GetItemStatusCode="V")!(GetItemStatusCode="E") d
    ....s GetRejDR=$o(^DHCRBRejecti("OeordDR",oeorditemdr,0))
	....i GetRejDR'="" d
	.....s GetPatientStatusCode="R" ;拒绝申请
	....else  d
	.....i $g(^OEORD(OrderRowid,"I",itemsub,6))'="" s Getapprowid=$p(^OEORD(OrderRowid,"I",itemsub,6),"^",5)  ; 已经预约RB_Appointment Rowid
	....;w "approwid  "_Getapprowid_"  "
	....q:Getapprowid'=""   ;预约过的医嘱则退出 
	....;w "  "_GetItemStatusCode_"  "
	....i GetItemStatusCode="E"  d  ; 医嘱执行
	.....;w "---- 6"
	.....;s PaadmRowid=oeorditemdr
	.....s GetPatientStatusCode="I"
	.....s RegInfo=##class(web.DHCEkgRegister).GetRegInfo(oeorditemdr)
	.....q:$g(RegInfo)=""
    .....s GetStudyNo=$p(RegInfo,"^",1)
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
    .....s GetImgcount=0
    .....q:$g(GetStudyNo)=""  ;20061228 add
    .....s Imrowid=0 f  s Imrowid=$o(^DHCRBStudyi("StudyNo-Images",GetStudyNo,Imrowid)) q:Imrowid=""  d
    ......s GetPatientStatusCode="E"    ;正在检查
    ......s ExtName=$p($g(^DHCRBStudy(0,"StudyImages",Imrowid)),"^",2)
    ......i ((ExtName="avi")!(ExtName="dcm")!(ExtName="normal")!(ExtName="dsa"))  d
    .......s GetImgcount=GetImgcount+1
    .......s GetReportStatusCode="I"             ;图象已经采集
    .....s sReportStuatCode="VS"
    .....;w " 1 "_oeorditemdr_"  "
    .....;s Rptrowid=0  f  s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",GetStudyNo,Rptrowid)) q:Rptrowid=""  d
    .....i 1  d
    ......;s GetRptID=$p(^DHCRBStudy("Report",Rptrowid),"^",2)
    ......;s GetRptVersion=$p(^DHCRBStudy("Report",Rptrowid),"^",3)
    ......;s GetRptStatusDR=$p(^DHCRBStudy("Report",Rptrowid),"^",4)
    ......;i GetRptStatusDR'="" d
    ......;.s GetReportStatusCode=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",1)
    ......;.i sReportStuatCode[GetReportStatusCode d
    ......;..s GetPatientStatusCode="O"
    ......;.e  d
    ......;..s GetPatientStatusCode="E"
    ......;s GetRptDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",8)
    ......;i GetRptDocDR'="" s GetRptDocName=$p(^SSU("SSUSR",GetRptDocDR),"^",2)
    ......;s GetRptDate=$p(^DHCRBStudy("Report",Rptrowid),"^",9)
    ......;i GetRptDate'="" s GetRptDate=$zd(GetRptDate,3)
    ......;s GetRptTime=$p(^DHCRBStudy("Report",Rptrowid),"^",10)
    ......;i GetRptTime'="" s GetRptTime=$zt(GetRptTime,3)
    ......;s GetVerifyDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",11)
    ......;i GetVerifyDocDR'="" s GetVerifyDocName=$p(^SSU("SSUSR",GetVerifyDocDR),"^",2)
    ......;s GetVerifyDate=$p(^DHCRBStudy("Report",Rptrowid),"^",12)
    ......;i GetVerifyDate'="" s GetVerifyDate=$zd(GetVerifyDate,3) 
    ......;s GetVerifyTime=$p(^DHCRBStudy("Report",Rptrowid),"^",13)
    ......;i GetVerifyTime'="" s GetVerifyTime=$zt(GetVerifyTime,3)
    ......i (InStatusCode="")!(InStatusCode[GetPatientStatusCode)  d 
   	.......s PatientStatus=##class(web.DHCEkgPatientInfo).GetPatientStatusDesc(GetPatientStatusCode)
    .......s ReportStatus=##class(web.DHCEkgReport).GetReportStatusDesc(GetReportStatusCode)
    .......s bOut="Y"
    .......Do OutRow4
    ....i ((InStatusCode="")!(InStatusCode[GetPatientStatusCode))&(bOut="N") d 
  	.....s PatientStatus=##class(web.DHCEkgPatientInfo).GetPatientStatusDesc(GetPatientStatusCode)
    .....s ReportStatus=##class(web.DHCEkgReport).GetReportStatusDesc(GetReportStatusCode)
    .....s bOut="Y"
    .....Do OutRow4
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
OutRow4
  ;OeItemID_"&"_sPrint打印标志_"&"_mStatus_"&"_$zd(RDate,3)医嘱时间_" "_$ZT(RTime,1)医嘱日期_"&"_PatRegNo_"&"_PatBed_"&"_PatName_"&"_PatSex_"&"_PatAge_"&"_sOeName_"/"_PatModName_"&"_sMemo批注_"&"_mPrint批注打印YN_"&"_主操作_"&"_副操作_"&"_预约时间_"&"_预约日期_"&"_是否需要预约医嘱
    ;set Data=$lb(GetRegNo,GetName,GetSexDesc,GetstrAge,GetstrDOB,GetIDCDesc,GetStudyNo,GetstrOrderName,Getrequestdoc,GetstrAccessionNum,GetstrDate,GetstrTime,GetAppointDate,GetAppointstTime,GetstrRegDate,GetstrRegTime,GetReportDoc,GetReportVerifyDoc,PatientStatus,paadmdr,oeorditemdr,GetLocName,GetTotalPrice,GetPatientStatusCode,Getbilled,Gettypedesc,GetNum,Getprice,GetIndex,GetEQDesc,GetResDesc,Getifbed,ReportStatus,GetMainDoc,GetAssDoc,GetRoomDesc,GetEQGroupDesc,GetWardName,NO)
  	s RRowid=""
  	s RRowid=$o(^DHCRBAppi("OrdRowid",oeorditemdr,""))
    i RRowid =""   s PatientStatus="医嘱核实"
  	set Data=$lb(oeorditemdr,sPrint,PatientStatus,strDate,strTime,GetRegNo,GetBedNo,GetName,GetSexDesc,GetstrAge,GetstrOrderName,"",mPrint,"","","","",tempneed,GetPaadmr)
  	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
 	quit
}

ClassMethod QueryBookedItem(InWardDR As %String, InRegNo As %String, InStatusCode As %String, InChuangpang As %String, InNoAppoint As %String, InAppStDate As %String) As %Integer
{
  ; Set RowId="" f  s RowId=$o(^RB("RES",0,"CTLOC",InLocID,RowId) ) q:RowId=""  d
 s sPrint="",tempneed=""
 Set RowId="" f  s RowId=$o(^RB("RES",RowId) ) q:RowId=""  d
 .s ResDesc=""
 .s CTCPDR=$p($g(^RB("RES",RowId)),"^",2)
 .i CTCPDR'="" d
 ..s GetResDesc=$p($g(^CTPCP(CTCPDR,1)),"^",2)
 ..i $g(^DHCRisGetNameSet)="ID" s GetResDesc=$p($g(^CTPCP(CTCPDR,1)),"^",3)
 .else  d
 ..s EQDR=$p($g(^RB("RES",RowId)),"^",3)
 ..q:(EQDR="")
 ..s GetResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
 .;q:(InResourceID'="")&(InResourceID'=RowId)
 .s session=0
 .;RB_ApptSchedule
 .f  s session=$o(^RBAS(RowId,0,"DateSTime",InAppStDate,session)) q:session=""  d
 ..s childsub=0 f  s childsub=$o(^RBAS(RowId,0,"DateSTime",InAppStDate,session,childsub)) q:childsub=""  d
 ...s apptschinfo=^RBAS(RowId,childsub)
 ...s AppointDate=$p(apptschinfo,"^",1)
 ...q:AppointDate'=InAppStDate
 ...s GetAppointDate=$zd(AppointDate,3)
 ...s AppointstTime=$p(apptschinfo,"^",4)
 ...s GetAppointstTime=$zt(AppointstTime,1)
 ...s ApptRowid=RowId_"||"_childsub
 ...; RB_Appointment
 ...s appointchildsub=0  f  s appointchildsub=$o(^RBAS(RowId,childsub,"APPT",appointchildsub)) q:appointchildsub=""  d
 ....s apppintrowid=ApptRowid_"||"_appointchildsub
 ....s ordrowid=0 
 ....s ordrowid=$o(^OEORDi(0,"Appt",apppintrowid,ordrowid))
 ....; 根据预约的时间点找医嘱
 ....i ordrowid'=""  d
 .....s sPrint="",mPrint=""
 .....s orditemchildsub=0  
 .....s orditemchildsub=$o(^OEORDi(0,"Appt",apppintrowid,ordrowid,orditemchildsub))
 .....s oeorditemdr=ordrowid_"||"_orditemchildsub
 .....s RRowid=$o(^DHCRBAppi("OrdRowid",oeorditemdr,""))
 .....i $g(RRowid)'=""  d
 ......s sPrint=$p(^DHCRBApp("Bill",RRowid),"^",7)
 ......s mPrint=$p(^DHCRBApp("Bill",RRowid),"^",13)
 .....s GetPaadmr=$p(^OEORD(ordrowid),"^",1)
 .....;q:(Inpaadmdr'="")&(GetPaadmr'=Inpaadmdr)
 .....s papatmasmdr=$p(^PAADM(GetPaadmr),"^",1)  
 .....;get patient diagnose 
 .....s IDCDesc=##class(web.DHCEkgPatientInfo).GetDiagnose(GetPaadmr)
 .....s PatInfo=##class(web.DHCEkgPatientInfo).GetPaadmInfo(GetPaadmr)
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
 .....q:(InWardDR'="")&(GetWardDr'=InWardDR)
 .....q:(InRegNo'="")&(GetRegNo'=InRegNo)
 .....;q:(InName'="")&(GetName'[InName)
 .....;q:(InPatientNo'="")&(InPatientNo'=GetIPNo)
 .....;q:(InAppLocDR'="")&(GetLocdr'=InAppLocDR)
 .....;q:(Intype'="")&(Intype'=Getpatienttype)
 .....s ordInfo=##class(web.DHCEkgOeorditem).GetOeorditminfo(ordrowid,orditemchildsub)
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
 .....s GetordDate=$p(ordInfo,"^",15)
 .....s GetordTime=$p(ordInfo,"^",16)
 .....s GetItemStatusCode=$p(ordInfo,"^",17)
 .....q:(InNoAppoint="N")&(GetSGroupDesc="无需预约")  ;
 .....q:(InNoAppoint="Y")&(GetSGroupDesc'="无需预约")
 .....i (GetSGroupDesc="无需预约")  d  s tempneed="N"
 .....e  d  s tempneed="Y"
 .....;q:(InChuangpang="Y")&(Getifbed'="Y")  ;检索床旁医嘱，不是床旁医嘱
 .....q:(InChuangpang="Y")&(GetstrOrderName'["床旁")  ;检索床旁医嘱，不是床旁医嘱
 .....s GetPatientStatusCode="B"
 .....s BookInfo=##class(web.DHCEkgAppointment).GetBookedInfo(oeorditemdr)
 .....;w "   !  "_BookInfo  _"  !   "
 .....s GetBookResc=$p(BookInfo,"^",1)
 .....s GetBookDate=$p(BookInfo,"^",2)
 .....s GetBookTime=$p(BookInfo,"^",3)
 .....s GetReportStatusCode="N"  ;未写报告
 .....s GetstrRegDate="",GetstrRegTime="",GetRptDocName="",GetVerifyDocName="",GetStudyNo="",GetIndex="",GetEQDesc=""
 .....s GetEQDr="",GetMainDoc="",GetAssDoc="",GetRoomDesc="",GetRoomDr="",GetEQGroupDR=""
 .....s bOut="N"
 .....i (GetItemStatusCode="E") d
 ......s GetPatientStatusCode="I"  ;登记
 ......s RegInfo=##class(web.DHCEkgRegister).GetRegInfo(oeorditemdr)
 ......s GetStudyNo=$p(RegInfo,"^",1)
 ......s GetstrRegDate=$p(RegInfo,"^",2)
 ......s GetstrRegTime=$p(RegInfo,"^",3)
 ......;w GetstrRegDate
 ......s GetIndex=$p(RegInfo,"^",4)
 ......s GetEQDesc=$p(RegInfo,"^",5)
 ......s GetMainDoc=$p(RegInfo,"^",6)
 ......s GetAssDoc=$p(RegInfo,"^",7)
 ......s GetRoomDesc=$p(RegInfo,"^",8)
 ......s GetRoomDr=$p(RegInfo,"^",9)
 ......s GetEQDr=$p(RegInfo,"^",10)
 ......s GetEQGroupDesc=$p(RegInfo,"^",11)
 ......s GetEQGroupDR=$p(RegInfo,"^",12)
 ......s NO=$p(RegInfo,"^",13)
 ......s GetImgcount=0
 ......q:$g(GetStudyNo)=""
 ......s Imrowid=0 f  s Imrowid=$o(^DHCRBStudyi("StudyNo-Images",GetStudyNo,Imrowid)) q:Imrowid=""  d
 .......s GetPatientStatusCode="E"    ;正在检查
 .......s ExtName=$p($g(^DHCRBStudy(0,"StudyImages",Imrowid)),"^",2)
 .......i ((ExtName="avi")!(ExtName="dcm")!(ExtName="normal")!(ExtName="dsa"))  d
 ........s GetImgcount=GetImgcount+1
 ........s ReportStatusCode="I"             ;图象已经采集
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
 .......;s GetRptDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",8)
 .......;i GetRptDocDR'="" s GetRptDocName=$p(^SSU("SSUSR",GetRptDocDR),"^",2)
 .......;s GetRptDate=$p(^DHCRBStudy("Report",Rptrowid),"^",9)
 .......;i GetRptDate'="" s GetRptDate=$zd(GetRptDate,3)
 .......;s GetRptTime=$p(^DHCRBStudy("Report",Rptrowid),"^",10)
 .......;i GetRptTime'="" s GetRptTime=$zt(GetRptTime,3)
 .......;s GetVerifyDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",11)
 .......;i GetVerifyDocDR'="" s GetVerifyDocName=$p(^SSU("SSUSR",GetVerifyDocDR),"^",2)
 .......;s GetVerifyDate=$p(^DHCRBStudy("Report",Rptrowid),"^",12)
 .......;i GetVerifyDate'="" s GetVerifyDate=$zd(GetVerifyDate,3) 
 .......;s GetVerifyTime=$p(^DHCRBStudy("Report",Rptrowid),"^",13)
 .......;i GetVerifyTime'="" s GetVerifyTime=$zt(GetVerifyTime,3)
 .......i ((InStatusCode="")!(InStatusCode[GetPatientStatusCode)) d 
 ........s PatientStatus=##class(web.DHCEkgPatientInfo).GetPatientStatusDesc(GetPatientStatusCode)
 ........s ReportStatus=##class(web.DHCEkgReport).GetReportStatusDesc(GetReportStatusCode)
 ........s bOut="Y"
 ........Do OutRowA
 .....i ((InStatusCode="")!(InStatusCode[GetPatientStatusCode))&(bOut="N") d 
 ......s PatientStatus=##class(web.DHCEkgPatientInfo).GetPatientStatusDesc(GetPatientStatusCode)
 ......s ReportStatus=##class(web.DHCEkgReport).GetReportStatusDesc(GetReportStatusCode)
 ......s bOut="Y"
 ......Do OutRowA
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutRowA
    ;set Data=$lb(RegNo,Name,SexDesc,strDOB,strAge,IDCDesc,$g(StudyNo),strOrderName,requestdoc,strAccessionNum,strDate,strTime,$g(strAppointDate),$g(strAppointstTime),$g(strRegDate),$g(strRegTime),$g(getReportDoc),$g(getReportVerifyDoc),PatientStatus,paadmdr,oeorditemdr,$g(LocName),TotalPrice,PatientStatusCode,billed,$g(typedesc),Num,price,$g(Index),$g(EQDesc),$g(ResDesc),ifbed,ReportStatus,RoomDesc)
    ; set Data=$lb(GetRegNo,GetName,GetSexDesc,GetstrAge,GetstrDOB,GetIDCDesc,GetStudyNo,GetstrOrderName,Getrequestdoc,GetstrAccessionNum,GetstrDate,GetstrTime,GetAppointDate,GetAppointstTime,GetstrRegDate,GetstrRegTime,GetReportDoc,GetReportVerifyDoc,PatientStatus,paadmdr,oeorditemdr,GetLocName,GetTotalPrice,GetPatientStatusCode,Getbilled,Gettypedesc,GetNum,Getprice,GetIndex,GetEQDesc,GetResDesc,Getifbed,ReportStatus,GetMainDoc,GetAssDoc,GetRoomDesc,GetEQGroupDesc,GetWardName,NO)
   set Data=$lb(oeorditemdr,sPrint,PatientStatus,GetstrDate,GetstrTime,GetRegNo,GetBedNo,GetName,GetSexDesc,GetstrAge,GetstrOrderName,"",mPrint,GetMainDoc,GetAssDoc,GetBookDate,GetBookTime,tempneed,GetPaadmr)
    //set Data=$lb(GetRegNo,GetName,GetSexDesc,GetstrDOB,GetstrAge,GetIDCDesc,GetStudyNo,GetstrOrderName,Getrequestdoc,GetstrAccessionNum,GetstrDate,GetstrTime,GetAppointDate,GetAppointstTime,GetstrRegDate,GetstrRegTime,GetReportDoc,GetReportVerifyDoc,GetPatientStatus,paadmdr,oeorditemdr,GetLocName,GetTotalPrice,GetPatientStatusCode,Getbilled,Gettypedesc,GetNum,Getprice,GetIndex,GetEQDesc,GetResDesc,Getifbed,GetReportStatus,GetMainDoc,GetAssDoc,GetRoomDesc,GetEQGroupDesc,GetWardName,NO)
  	;w "reg ok  "
  	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
 	quit
}

ClassMethod GetLastPInfo(paadmrowid As %String) As %String
{
  s illstr="",info=""
  s illstrrowid=$o(^DHCRBAppi("illstatu-roditem",paadmrowid,""),-1)
  q:illstrrowid="" info
  ;s orderrowid=$p(^DHCRBCApp("IllStatus",illstrrowid),"^",2) 
  s illstr=$p(^DHCRBCApp("IllStatus",illstrrowid),"^",3)
  s info=illstrrowid_"^"_illstr
  q info
}

ClassMethod GetBookDetail(Oeorditemdr As %String) As %String
{
 	s ResDesc="",strAppointDate="",strAppointstTime="" 
    s OrderRowid=$p(Oeorditemdr,"||",1)
    s itemsub=$p(Oeorditemdr,"||",2)
    s approwid=$p(^OEORD(OrderRowid,"I",itemsub,6),"^",5)
	i (approwid'="")&(approwid'=$c(0)) d 
	.s resrowid=$p(approwid,"||",1)
	.s CTCPDR=$p(^RB("RES",resrowid),"^",2)
	.i CTCPDR'="" d
	..s ResDesc=$p(^CTPCP(CTCPDR,1),"^",2)
	..i $g(^DHCRisGetNameSet)="ID" s ResDesc=$p(^CTPCP(CTCPDR,1),"^",3)
	.else  d
	..s EQDR=$p(^RB("RES",resrowid),"^",3)
	..s ResDesc=$p(^RBC("EQ",EQDR),"^",2)
	.s ctlocdr=$p(^RB("RES",resrowid),"^",1)
	.i ctlocdr'="" d
	..s LocDesc=$p(^CTLOC(ctlocdr),"^",2)
	.s Schrowid=$p(approwid,"||",2)
	.s scheInfo=^RBAS(resrowid,Schrowid)
	.s AppointDate=$p(scheInfo,"^",1)
	.s strAppointDate=$zd(AppointDate,3)
	.s endtime=$p(scheInfo,"^",5)
	.i endtime="86400" s endtime="0"
	.s strendtime=$zt(endtime,1)
	.s AppointstTime=$p(scheInfo,"^",4)
	.s strAppointstTime=$zt(AppointstTime,1)
	.s timefanwei=strAppointstTime_"~"_strendtime
	s OeItemCat=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
	s Memo=""
	s DHCRisSystemInfo=##class(web.DHCREkgSystemParam).GetSystemParam()
    s DHCRisVersion=$p(DHCRisSystemInfo,"^",15)
    i (DHCRisVersion="BJ_FX") d  //复兴升级0911 qzg
    .s index=$o(^DHCRBAppi("Memo-ItMast",OeItemCat,""))
	.i index'=""  d
	..s Memo=$p(^DHCRBApp("Memo",index),"^",2)
	e  d
	.s memorowid=""
    .s memorowid=$o(^DHCRBAppointmenti("OEorditem",Oeorditemdr,0))
    .i memorowid'="" d
    ..s Memo = $g(^DHCRBAppointment(memorowid,"Memo"))
    .e  d
    ..s index=$o(^DHCRBAppi("Memo-ItMast",OeItemCat,""))
	..i index'=""  d
	...s Memo=$p(^DHCRBApp("Memo",index),"^",2)
	s BookedInfo=ResDesc_"^"_strAppointDate_"^"_timefanwei_"^"_LocDesc_"^"_Memo
	q BookedInfo
}

ClassMethod UpPrint1(OeItemDR As %String) As %String
{
	//s tem="Y"
 //&sql(UPDATE RIS.DHCRB_ApplicationBill SET DRA_Print ='Y' where DRA_OeItemID_DR=:OeItemDR)
   //q tem
}

ClassMethod UpPrint2(OeItemDR As %String) As %String
{
 //s tem="Y"
 //&sql(UPDATE RIS.DHCRB_ApplicationBill SET DRA_MPrint ='Y' where DRA_OeItemID_DR=:OeItemDR)
 //q tem
}

ClassMethod GetLastZD(PaAdmID As %String) As %String
{
	//d ##class(web.DHCEkgApplication).GetLastZD("2810435")
  s MainDiagnose="",info=""
  s ord=""
  f  s ord=$o(^OEORD(0,"Adm",PaAdmID,ord)) q:(ord="")  d
  .s itm="" f  s itm=$o(^OEORD(ord,"I",itm)) q:(itm="")  d
  ..s RRowid="",MainDiagnose="",RRowid=""
  ..s ExamOrder=ord_"||"_itm
  ..;w ExamOrder_"   "
  ..s RRowid=$o(^DHCRBAppi("OrdRowid",ExamOrder,""),-1)
  ..i RRowid'=""  d 
  ...s MainDiagnose=$p(^DHCRBApp("Bill",RRowid),"^",5)
  ...s info=MainDiagnose
  ;w MainDiagnose
  ;w info
  q info
}

ClassMethod GetDocName(DocDR As %String) As %String
{
	s DocName=$p(^SSU("SSUSR",DocDR),"^",2)		 
	q DocName
}

ClassMethod GetHTMLMedium() As %String
{
	s MediumDR=""
	s RemainSize=""
	s ServerInfo=""
	s Info=""
	s MediumName="Application"
	//&sql(SELECT  DRM_RowId,DRM_RemainSize INTO :MediumDR,:RemainSize FROM RIS.DHCRBC_Medium  WHERE DRM_Name=:MediumName AND DRM_Full='N' )
	//i MediumDR'="" d
	.; s ServerInfo=..GetServerInfo(MediumDR)
	.// s Info= MediumName_"^"_MediumDR_"^"_RemainSize
	//q Info
}

ClassMethod InsMedia(Info As %String) As %String
{
	/*
    s MediumDR="",FileName=""
	i Info="" q ""  
	s MediumDR=$P(Info,"^",1)
    s FileName=$P(Info,"^",2)
    s OeItemDR=$P(Info,"^",3)
    q:OeItemDR ""
    &sql(UPDATE RIS.DHCRB_ApplicationBill SET DRA_Medium_DR =:MediumDR,DRA_FullFileName=:FileName where DRA_OeItemID_DR=:OeItemDR)
  q ""
  */
}

ClassMethod Getorderinfo(Rowid As %String) As %String
{
	s retInfo=""
  s DHCRisSystemInfo=##class(web.DHCEkgSystemParam).GetSystemParam()
  s DHCRisVersion=$p(DHCRisSystemInfo,"^",15)
  i (DHCRisVersion="BJ_FX") d  //复兴升级0911 qzg	
  .s i=1,Memo=""
  .s ord="",itm=""
  .s ord=$p(Rowid,"_",1)
  .s itm=$p(Rowid,"_",2)
  .if itm="" d
  ..s ord=$p(Rowid,"||",1)
  ..s itm=$p(Rowid,"||",2)
  .s MemoNum=$g(^OEORD(ord,"I",itm,"DEP",0))
  .i MemoNum>1 d
  ..FOR i=1:1:MemoNum d
  ...s Memo=Memo_$g(^OEORD(ord,"I",itm,"DEP",i))
  ...s retinfo=Memo
  e  d
  .S OEORDRowId="",OEORIChildsub="",Loc="",LocName=""
  .s OEORDRowId=$p(Rowid,"_",1)
  .s OEORIChildsub=$p(Rowid,"_",2)
  .s Loc=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",3)
  .i $g(Loc)'="" s LocName=$p(^CTLOC(Loc),"^",2)
  .s retinfo=Loc_"^"_LocName
 q retinfo
}

ClassMethod NQueryByWard(InWardDR As %String, InRegNo As %String, InStatusCode As %String, InChuangpang As %String, InNoAppoint As %String, InStdDate As %String, InStdTime As %String, InEnddate As %String, InEndTime As %String)
{
	
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    f date=InStdDate:1:InEnddate d
    .;s count=..QueryBookedItem(InWardDR, InRegNo, InStatusCode, InChuangpang , InNoAppoint, date)  ;查询到指定的日期的预约医嘱
    .;s sPrint="",iiirowid="",tempneed=""
    .s OrderRowid="" f  s OrderRowid=$o(^OEORDi(0,"ItemDate",date,OrderRowid)) q:OrderRowid=""  d               ;循环查询
    ..s itemsub=0 f  s itemsub=$o(^OEORDi(0,"ItemDate",date,OrderRowid,itemsub)) q:(itemsub="")  d
    ...s GetPaadmr=""
    ...s sPrint="",mPrint="",iiirowid="",tempneed="",flag="Y",RRowid=""
	...s reploc=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)   ;检查科室
	...;q:(reploc'=InLocDr)&(InLocDr'="")

	...s oeorditemdr=$g(OrderRowid)_"||"_$g(itemsub)
	...;s iiirowid=$o(^DHCRBAppi("OrdRowid",OeItemID,"")) ;benna added
	...;q:'$d(iiirowid)
	...s paadmdr=$p(^OEORD(OrderRowid),"^",1) 
	...s pawarddr=$p(^PAADM(paadmdr),"^",70)  ; warddr
	...q:pawarddr'=InWardDR          ;过滤不是本病区的病人医嘱
	...s GetIDCDesc=##class(web.DHCEkgPatientInfo).GetDiagnose(paadmdr)
    ...s PatInfo=##class(web.DHCEkgPatientInfo).GetPaadmInfo(paadmdr)
    ...s GetRegNo=$p(PatInfo,"^",1)
    ...s GetName=$p(PatInfo,"^",2)
    ...s GetstrDOB=$p(PatInfo,"^",3)
    ...s GetstrAge=$p(PatInfo,"^",4)
 	...s GetSexDesc=$p(PatInfo,"^",5)
    ...s Getpatienttype=$p(PatInfo,"^",6)
    ...s Gettypedesc=$p(PatInfo,"^",7)
    ...s GetLocName=$p(PatInfo,"^",8)
    ...s GetIPNo=$p(PatInfo,"^",9)
    ...s GetWardName=$p(PatInfo,"^",10)
    ...s GetBedNo=$p(PatInfo,"^",11)
    ...s GetLocdr=$p(PatInfo,"^",12)
    ...;s GetWardDr=$p(PatInfo,"^",14)
    ...;q:(InWardDR'="")&(GetWardDr'=InWardDR)
    ...q:(InRegNo'="")&(GetRegNo'=InRegNo)
    ...;w GetRegNo_" "
    ...;q:(InName'="")&(GetName'[InName)
    ...;q:(InPatientNo'="")&(InPatientNo'=GetIPNo)
    ...;q:(InAppLocDR'="")&(GetLocdr'=InAppLocDR)
    ...;q:(Intype'="")&(Intype'=Getpatienttype)
    ...s GetstrRegDate="",GetstrRegTime="",GetRptDocName="",GetVerifyDocName="",GetStudyNo="",GetIndex="",GetEQDesc=""
    ...s GetEQDr="",GetMainDoc="",GetAssDoc="",GetRoomDesc="",GetRoomDr="",GetEQGroupDR=""
    ...;s flag="Y"
    ...s GetPaadmr=$p(^OEORD(OrderRowid),"^",1)
    ...s ordInfo=##class(web.DHCEkgOeorditem).GetOeorditminfo(OrderRowid,itemsub)
    ...s GetstrOrderName=$p(ordInfo,"^",1)
    ...s GetstrDate=$p(ordInfo,"^",2)
    ...s GetstrTime=$p(ordInfo,"^",3)
    ...s Getrequestdoc=$p(ordInfo,"^",4)
    ...s GetstrAccessionNum=$p(ordInfo,"^",5)
    ...s GetSGroupDesc=$p(ordInfo,"^",6)
    ...s GetsubCatDesc=$p(ordInfo,"^",7)
    ...s GetCatDesc=$p(ordInfo,"^",8)
    ...s Getifbed=$p(ordInfo,"^",9)
    ...s Getprice=$p(ordInfo,"^",10)
    ...s GetNum=$p(ordInfo,"^",11)
    ...s GetTotalPrice=$p(ordInfo,"^",12)
    ...s Getbilled=$p(ordInfo,"^",13)
    ...s GetItemStatusCode=$p(ordInfo,"^",14)
    ...s GetordDate=$p(ordInfo,"^",15)
    ...s GetordTime=$p(ordInfo,"^",16)
    ...s GetItemStatusCode=$p(ordInfo,"^",17)
    ...q:GetItemStatusCode="D"   ;停止    
    ...s GetServerMaterial=$p(ordInfo,"^",18)
    ...q:(InNoAppoint="N")&(GetSGroupDesc="无需预约")  ;
    ...q:(InNoAppoint="Y")&(GetSGroupDesc'="无需预约")
    ...i (GetSGroupDesc="无需预约")  d  s tempneed="N"
    ...e  d  s tempneed="Y"
    ...;q:(InChuangpang="Y")&(Getifbed'="Y")  ;检索床旁医嘱，不是床旁医嘱
    ...q:(InChuangpang="Y")&(GetstrOrderName'["床旁")  ;检索床旁医嘱，不是床旁医嘱
    ...q:(GetServerMaterial'="Service")&(GetServerMaterial'="S") ;不是检查项目的则退出 q:(GetServerMaterial'="Service")
    ...s GetPatientStatusCode="A"  ;申请
    ...s GetReportStatusCode="N"  ;未写报告
    ...s Getapprowid="",GetRoomDr=""
    ...s GetRptDocName="",GetVerifyDocName="",GetStudyNo="",GetstrRegDate="",GetstrRegTime="",GetIndex="",GetEQDesc="",GetMainDoc="",GetAssDoc=""
    ...s GetEQDr="",GetRoomDesc="",GetAppointDate="",GetAppointstTime="",GetResDesc="",GetEQGroupDesc="",GetEQGroupDR="",NO=""
    ...;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ...s RegInfo=##class(web.DHCEkgRegister).GetRegInfo(oeorditemdr)
    ...s GetStudyNo=$p(RegInfo,"^",1)
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
    ...i $g(GetStudyNo)'=""  d
    ....s GetPatientStatusCode="I"  ;登记
    ....s RRowid=$o(^DHCRBAppi("OrdRowid",oeorditemdr,""))
	....i $g(RRowid)'=""  d
	.....s sPrint=$p(^DHCRBApp("Bill",RRowid),"^",7)
	.....s mPrint=$p(^DHCRBApp("Bill",RRowid),"^",13)
	.....;s GetPatientStatusCode="B"
    .....s BookInfo=##class(web.DHCEkgAppointment).GetBookedInfo(oeorditemdr)
    .....;w "   !  "_BookInfo  _"  !   "
    .....s GetBookResc=$p(BookInfo,"^",1)
    .....s GetBookDate=$p(BookInfo,"^",2)
    .....s GetBookTime=$p(BookInfo,"^",3)
    .....s bOut="N"
    ....s Imrowid=0 f  s Imrowid=$o(^DHCRBStudyi("StudyNo-Images",GetStudyNo,Imrowid)) q:Imrowid=""  d
    .....s GetPatientStatusCode="E"    ;正在检查
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
    ...e   d
    ....s BookInfo=##class(web.DHCEkgAppointment).GetBookedInfo(oeorditemdr)
    ....;w "   !  "_BookInfo  _"  !   "
    ....s GetBookResc=$p(BookInfo,"^",1)
    ....s GetBookDate=$p(BookInfo,"^",2)
    ....s GetBookTime=$p(BookInfo,"^",3)
    ....i $g(GetBookResc)'=""  d
    .....s GetPatientStatusCode="B"
    .....s RRowid=$o(^DHCRBAppi("OrdRowid",oeorditemdr,""))
	.....i $g(RRowid)'=""  d
	......s sPrint=$p(^DHCRBApp("Bill",RRowid),"^",7)
	......s mPrint=$p(^DHCRBApp("Bill",RRowid),"^",13)
	....e  d
	.....s RRowid=$o(^DHCRBAppi("OrdRowid",oeorditemdr,""))
	.....i $g(RRowid)'=""  d
	......s GetPatientStatusCode="A"
	......s sPrint=$p(^DHCRBApp("Bill",RRowid),"^",7)
	......s mPrint=$p(^DHCRBApp("Bill",RRowid),"^",13)
	.....e  d
	......s flag="N"
	......;w flag
	...;
	...;w "status:"_GetPatientStatusCode_":end  "
	...s GetRejDR=""
    ...s GetRejDR=$o(^DHCRBRejecti("OeordDR",oeorditemdr,0))
	....i GetRejDR'="" d
	.....s GetPatientStatusCode="R" ;拒绝申请
    ...i (InStatusCode="")!(InStatusCode[GetPatientStatusCode)  d 
   	....s PatientStatus=##class(web.DHCEkgPatientInfo).GetPatientStatusDesc(GetPatientStatusCode)
    ....s ReportStatus=##class(web.DHCEkgReport).GetReportStatusDesc(GetReportStatusCode)
    ....s bOut="Y"
    ....;w " 1 "_oeorditemdr_"  "
    ....Do OutRow44
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
OutRow44
  ;OeItemID_"&"_sPrint打印标志_"&"_mStatus_"&"_$zd(RDate,3)医嘱时间_" "_$ZT(RTime,1)医嘱日期_"&"_PatRegNo_"&"_PatBed_"&"_PatName_"&"_PatSex_"&"_PatAge_"&"_sOeName_"/"_PatModName_"&"_sMemo批注_"&"_mPrint批注打印YN_"&"_主操作_"&"_副操作_"&"_预约时间_"&"_预约日期_"&"_是否需要预约医嘱
    ;set Data=$lb(GetRegNo,GetName,GetSexDesc,GetstrAge,GetstrDOB,GetIDCDesc,GetStudyNo,GetstrOrderName,Getrequestdoc,GetstrAccessionNum,GetstrDate,GetstrTime,GetAppointDate,GetAppointstTime,GetstrRegDate,GetstrRegTime,GetReportDoc,GetReportVerifyDoc,PatientStatus,paadmdr,oeorditemdr,GetLocName,GetTotalPrice,GetPatientStatusCode,Getbilled,Gettypedesc,GetNum,Getprice,GetIndex,GetEQDesc,GetResDesc,Getifbed,ReportStatus,GetMainDoc,GetAssDoc,GetRoomDesc,GetEQGroupDesc,GetWardName,NO)
  	i flag="N" d
  	.i GetItemStatusCode="E" d
  	..s PatientStatus="医嘱执行"
  	.i GetItemStatusCode="V" d
  	..s PatientStatus="医嘱核实"
    set Data=$lb(oeorditemdr,sPrint,PatientStatus,GetstrDate,GetstrTime,GetRegNo,GetBedNo,GetName,GetSexDesc,GetstrAge,GetstrOrderName,"",mPrint,GetMainDoc,GetAssDoc,GetBookDate,GetBookTime,tempneed,GetPaadmr)
  	;s flag="Y"
  	;set Data=$lb(oeorditemdr,sPrint,PatientStatus,strDate,strTime,GetRegNo,GetBedNo,GetName,GetSexDesc,GetstrAge,GetstrOrderName,"",mPrint,"","","","",tempneed,GetPaadmr)
  	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
 	quit
}

Query tQueryNurse(strCondition As %String) As %Query(ROWSPEC = "Toeorditemdr:%String,TsPrint:%String,TPatientStatus:%String,TOrderDate:%String,TOrderTime:%String,TRegNo:%String,TBedNo:%String,TName:%String,TSexDesc:%String,TstrAge:%String,TstrOrderName:%String,TMemo:%String,TmPrint:%String,TMainDocName:%String,TSencDocName:%String,TAppointDate:%String,TAppointTime:%String,TNeedAppoint:%String,TPaadmRowid:%String")
{
}

ClassMethod tQueryNurseExecute(ByRef qHandle As %Binary, strCondition As %String) As %Status
{

   ;s  strCondition=
   ;病区rowid^病人登记号^状态Code^只显示床旁医YN^Y只显示无需预约 N只显示需要预约 A显示全部 ^开始日期^开始时间^结束日期^结束时间
   ;s ^benna=strCondition
   ;s strCondition="168&&&N&N&2006-12-28&00:00:00&2007-01-01&00:00:00"
   s strCondition="124&&&N&N&2007-01-07&00:00:00&2007-01-11&00:00:00"
   s InWardDR=$p(strCondition,"&",1)
   s InWardDR=$p($g(InWardDR),$c(0))
   
   s InRegNo=$p(strCondition,"&",2)
   s InRegNo=$p(InRegNo,$c(0))
   
   s InStatusCode=$p(strCondition,"&",3)
   s InStatusCode=$p(InStatusCode,$c(0))
   
   s InChuangpang=$p(strCondition,"&",4)
   s InChuangpang=$p(InChuangpang,$c(0))
   
   s InNoAppoint=$p(strCondition,"&",5)
   s InNoAppoint=$p(InNoAppoint,$c(0))
   
   
   s InStdDate=$p(strCondition,"&",6)
   s InStdDate=$p(InStdDate,$c(0))
   s InStdDate=$zdh($g(InStdDate),3)
   
   s InStdTime=$p(strCondition,"&",7)
   s InStdTime=$p(InStdTime,$c(0))
   s InStdTime=$ZTIMEH(InStdTime,1)
   
   s InEnddate=$p(strCondition,"&",8)
   s InEnddate=$p(InEnddate,$c(0))
   s InEnddate=$zdh($g(InEnddate),3)
   
   s InEndTime=$p(strCondition,"&",9)
   s InEndTime=$p(InEndTime,$c(0))
   s InEndTime=$ZTIMEH(InEndTime,1)
   
   //s ^gptest="^"_type_"^"_RegNo_"^"_StudyNo_"^"_LocDr_"^"_StdDate_"^"_enddate_"^"_StatusCode_"^"_ReportDoc_"^"_VerifyDoc_"^"_Name_"^"_ResourceID_"^"_OrderByIndex_"^"_RoomDR_"^"_InPatientNo_"^"_RequireAppoint_"^"_IsBedOrd_"^"_AppLocDR_"^"_EQGroupDR_"^"_WardDR_"^"_NO
   Set repid=$I(^CacheTemp)
   If $g(ind)="" Set ind=1
         
   //s LocDr=##class(web.DHCEkgLocInfo).GetLocDR(LocDesc)
   //if LocDr="" s LocDr=%session.Get("LOGON.CTLOCID")
   
   //type As %String, RegNo As %String, StudyNo As %String, LocDr As %String, StdDate As %String, enddate As %String, StatusCode As %String, ReportDoc As %String, VerifyDoc As %String, Name As %String, ResourceID As %String, OrderByIndex As %String, RegEQ As %String,RoomDR As %String,InPatientNo As %String,RequireAppoint As %String,IsBedOrd As %String,AppLocDR As %String,EQGroupDR As %String,WardDR As %String,NO As %String
   s return=..NQueryByWard(InWardDR,InRegNo,InStatusCode,InChuangpang,InNoAppoint,InStdDate, InStdTime,InEnddate,InEndTime)
  		//Set qHandle=$lb(0,repid,0)
   Quit $$$OK
}

ClassMethod tQueryNurseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = tQueryNurseExecute ]
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

ClassMethod tQueryNurseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = tQueryNurseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetReceiveDepartment(Rowid As %String) As %String
{
 ; pass in date of birth in internal format
 s OEORROWID=$P(Rowid,"||",1)
 s Childsub=$P(Rowid,"||",2)
 S ReceiveDepartment=$P(^OEORD(OEORROWID,"I",Childsub,3),"^",6)
 S:ReceiveDepartment'=""&&$D(^CTLOC(ReceiveDepartment)) ReceiveDepartment=$P(^CTLOC(ReceiveDepartment),"^",2)
 q ReceiveDepartment
}

ClassMethod GetXmlContent(OrdItemID As %String) As %String
{
 ; pass in date of birth in internal format
 s OrdItemID=$p(OrdItemID,"_",1)_"||"_$p(OrdItemID,"_",2)
 s Rowid=""
 s Rowid=$o(^DHCRBAppi("OrdRowid",OrdItemID,""))
 s XmlContent=""
 s:$d(^DHCRBApp("Bill",Rowid,"XMLContent")) XmlContent=^DHCRBApp("Bill",Rowid,"XMLContent")
 q XmlContent
}

ClassMethod GetPathologyInfo(OrdItemID As %String) As %String
{
 ;如果医嘱是病理医嘱，并且有对应的模板，
 ;则其返回值为:识别名称+$c(2)_excel名字
 ;如果非病理，则返回为空
 ;d ##class(web.DHCEkgApplication).GetPathologyInfo("")
 s OrdItemID=$p(OrdItemID,"_",1)_"||"_$p(OrdItemID,"_",2)
 s ord=$p(OrdItemID,"||",1)
 s itm=$p(OrdItemID,"||",2)
 s OeItemCat=$p(^OEORD(ord,"I",itm,1),"^",2)
 s DIMASRowid="",ComponentName="",ComponentTempName="",ReturnValue="",AppShapeDr=""
 b //OeItemCat
 //s OeItemCat="30306||1"
 s:$d(^DHCRBCAppi("ItmMast",OeItemCat)) DIMASRowid=$o(^DHCRBCAppi("ItmMast",OeItemCat,""))
 i DIMASRowid'="" d
 .s AppShapeDr=$p(^DHCRBCApp("ItmMast",DIMASRowid),"^",2) 
 i AppShapeDr'="" d
 .i $d(^DHCRBApp("Shape",AppShapeDr)) d
 ..s ComponentName=$p(^DHCRBApp("Shape",AppShapeDr),"^",2)
 ..s ComponentTempName=$p(^DHCRBApp("Shape",AppShapeDr),"^",3) //excel 打印模板文件名
 i ComponentName["BL" d  //为病理医嘱
 .S ReturnValue=ComponentName_$c(2)_ComponentTempName
 q ReturnValue
}

ClassMethod GetOrdItemFee(OrdItemID As %String) As %String
{
 ;根据病人医嘱信息取病人此条医嘱的费用,若为零则不打印，针对门诊病人
 ;d ##class(web.DHCEkgApplication).GetOrdItemFee("")
 
 //s OrdItemID=$p(OrdItemID,"_",1)_"||"_$p(OrdItemID,"_",2)
 //s ord=$p(OrdItemID,"||",1)
 //s itm=$p(OrdItemID,"||",2)
 //s TotalFee=0
 //d ##class(web.DHCEkgSystemParam).SetMedTrakNameSpace()
 //s TotalFee=$$getMasterOrderFee^CHOPOrderEntry(OrdItemID)
 //zn "RIS"
 //i TotalFee<0.001 s TotalFee=""
 S ReturnValue=""
 q ReturnValue
}

ClassMethod GetOrdItemMemo(OrdItemID As %String) As %String
{
	s i=1,Memo=""
    s ord=$p(OrdItemID,"||",1)
    s itm=$p(OrdItemID,"||",2)
    s MemoNum=$g(^OEORD(ord,"I",itm,"DEP",0))
    i MemoNum>1 d
    .FOR i=1:1:MemoNum d
    ..s Memo=Memo_$g(^OEORD(ord,"I",itm,"DEP",i))
    q Memo
}

Query QueryAppTemplList(FieldTag As %String, LocID As %String, UserID As %String) As %Query(ROWSPEC = "TemplName:%String,Content:%String,DocName:%String,Rowid:%String")
{
}

ClassMethod QueryAppTemplListExecute(ByRef qHandle As %Binary, FieldTag As %String, LocID As %String, UserID As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 s ind=1
 s UserID=$p(UserID,$c(0))
 s LocID=$p(LocID,$c(0))
 ;s LocID="787"
 ;s FieldTag=""
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

ClassMethod InsertAppTempl(UserID As %String, Name As %String, FieldTag As %String, Content As %String, LocID As %String) As %String
{
  //s RowID=""
  //&sql(insert into DHCRBC_ApplicationTempl (DSAT_User_DR,DAST_TemplName,DAST_FieldTag,DAST_AppLoc_DR) values(:UserID,:Name,:FieldTag,:LocID))
  //i SQLCODE=0 d
  .//s RowID=%ROWID
  .//s ^DHCRBCApp("Template",RowID,"Content")=Content
  //q RowID
}

ClassMethod DelAppTempl(RowID As %String) As %String
{
	//q:RowID="" ""
	//&sql(DELETE FROM  DHCRBC_ApplicationTempl WHERE DAST_RowID=:RowID)
    //q SQLCODE
}

ClassMethod UpdateAppTempl(RowID, Name, Content As %String) As %String
{
	//i RowID=""  q -1
	//&sql(UPDATE DHCRBC_ApplicationTempl SET DAST_TemplName=:Name WHERE DAST_RowID=:RowID)
	//s ^DHCRBCApp("Template",RowID,"Content")=Content
    //q SQLCODE
}

ClassMethod GetAppHtmlContent(OrdItemID As %String) As %String
{
	s htmlConent="",strhtmlConent=""
	if OrdItemID'="" 
	{
	s AppRowid=$o(^DHCRBAppOrdi(0,OrdItemID,0)) 
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

ClassMethod Operat(Str) As %Integer
{
  /*
  i Str="" q 0
  s PaAdm="",illStatus="",OERowid="",orderrowid=""
  
  s PaAdm=$p(Str,"&",1)
  s illStatus=$p(Str,"&",2)
  s OERowid =$p(Str,"&",3)
  
  s bOEItemHave=0
  s illstrrowid=0 f  s illstrrowid=$o(^DHCRBAppi("illstatu-roditem",PaAdm,illstrrowid)) q:(illstrrowid="")  d
  .s orderrowid=$p(^DHCRBCApp("IllStatus",illstrrowid),"^",2)
  .i orderrowid=OERowid  s bOEItemHave=1
  i bOEItemHave=0 d
  . &sql(insert into DHCRBC_IllStatus (DIS_PaAdm_DR,DIS_IllStatus,DIS_Oeorditem_DR)values(:PaAdm,:illStatus,:OERowid))
  e  d
  . &sql(update DHCRBC_IllStatus(DIS_IllStatus)values(:illStatus)where DIS_Oeorditem_DR=:OERowid)
   q SQLCODE
   */
}

Query QuerydoctorTempl(LocUserID As %String) As %Query(ROWSPEC = "TemplName:%String,Content:%String,Rowid:%String")
{
}

ClassMethod QuerydoctorTemplExecute(ByRef qHandle As %Binary, LocUserID As %String) As %Status
{
	
   Set repid=$I(^CacheTemp)
   s ind=1
   s LocID=$p(LocUserID,"^",1)
   s UserID=$p(LocUserID,"^",2)
   
   s ^tmpzxy=LocID_"^"_UserID
   s rowid=0 f  s rowid=$o(^DHCRBCAppi("Loc-Template",LocID,rowid) ) q:(rowid="")  d
   .s GetUserID=$p(^DHCRBCApp("Template",rowid),"^",5)
   .i (UserID="")&(UserID=GetUserID)
   .s Name=$p(^DHCRBCApp("Template",rowid),"^",4)
   .s Content=^DHCRBCApp("Template",rowid,"Content")
   .e 
   .q:(UserID'="")&(UserID'=GetUserID)  
   .s Name=$p(^DHCRBCApp("Template",rowid),"^",4)
   .s Content=^DHCRBCApp("Template",rowid,"Content")
   .s UserDesc=""
   .i GetUserID'="" s UserDesc=$p($g(^SSU("SSUSR",GetUserID)),"^",2)
   .d OutDocTempl
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
OutDocTempl
 set Data=$lb(Name,Content,rowid)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QuerydoctorTemplFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerydoctorTemplExecute ]
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

ClassMethod QuerydoctorTemplClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerydoctorTemplExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
