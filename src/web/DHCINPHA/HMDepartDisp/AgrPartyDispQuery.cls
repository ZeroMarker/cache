/// Description:科室协定方查询相关
/// Creator:    hulihua
/// CreateDate: 2017-11-16
/// Table:      DHC_OEDispensing-新医嘱打包表、DHC_OEDispBatch-打包子表、DHC_PhaAgrPartyReq-科室协定方申请主表、DHC_PhaAgrPartyReqItm-科室协定方申请子表
Class web.DHCINPHA.HMDepartDisp.AgrPartyDispQuery Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Description:查询所有需要发药的病区科室
/// Creator:	hulihua
/// CreateDate:	2017-11-16
/// Table:      DHC_OEDispensing--新医嘱打包表
/// Input:		每页行数、页数、药房科室ID^病区ID
/// Output:		病区ID、病区名称
/// Return：    
/// Others:
/// w ##class(web.DHCINPHA.HMDepartDisp.AgrPartyDispQuery).jsQueryAgrParReqList("1","50","16/12/2017!!16/12/2017!!96!!")
ClassMethod jsQueryAgrParReqList(page, rows, params) As %Library.String
{
	n (page, rows, params)
	//s ^hlh($h)=$lb(page, rows, params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson() 
	s page=1
	s rows=100
	s End=page*rows  					//结束行
	s Start=((page-1)*rows)+1 			//开始行
	s cellSplit="!!"
	s startDate=$p(params,cellSplit,1)
	s endDate=$p(params,cellSplit,2)
	s startDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(startDate)
	s endDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(endDate)
	s phaLoc=$p(params,cellSplit,3)
	s wardLoc=$p(params,cellSplit,4)
	S pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid($this)
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"jsQueryAgrParReqList",pid,"DISPAGRPREQ")
	s cnt=0
	f Date=startDate:1:endDate d
	.s PhaAprId=""
	.f  s PhaAprId=$o(^DHCPHAAPRi("DatePhLocStatus","R",Date,phaLoc,PhaAprId)) q:PhaAprId=""  d
	..s PhaAprWard=$p(^DHCPHAAPR(PhaAprId),"^",1)
	..q:(wardLoc'="")&&(wardLoc'=PhaAprWard)
	..s WardDesc=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetLocInfoById(PhaAprWard),"^",2)
	..s AgrReqNo=$p(^DHCPHAAPR(PhaAprId),"^",10)
	..s AgrReqDate=$p(^DHCPHAAPR(PhaAprId),"^",3)
	..s AgrReqDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AgrReqDate)
	..s AgrReqTime=$p(^DHCPHAAPR(PhaAprId),"^",4)
	..s AgrReqTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(AgrReqTime)
	..s AgrReqDate=AgrReqDate_" "_AgrReqTime
	..s AgrReqUser=$p(^DHCPHAAPR(PhaAprId),"^",5)
	..s AgrReqUser=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(AgrReqUser),"^",2)
	..s FromWardLoc=$p(^DHCPHAAPR(PhaAprId),"^",12)
	..s FromWardDesc=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetLocInfoById(FromWardLoc),"^",2)
	..;
	..s Index=PhaAprWard_","_PhaAprId
	..s Data1=PhaAprId_"^"_PhaAprWard_"^"_WardDesc_"^"_AgrReqNo_"^"_AgrReqDate
	..s Data2=AgrReqUser_"^"_FromWardLoc_"^"_$G(FromWardDesc)
	..s cnt=cnt+1
	..s ^TMP("DHCINPHA",$this,"jsQueryAgrParReqList",pid,"DISPAGRPREQ",Index)=Data1_"^"_Data2
	.
	i cnt=0 d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"jsQueryAgrParReqList",pid,"DISPAGRPREQ")
	q:cnt=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(cnt) //输出空的json串
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartSign(cnt) //输出json前缀串
	s $zt="ErrorjsQueryAgrParReqList"
	s Title1="TPhaAprId^TPhaAprWard^TWardLoc^TAgrReqNo^TAgrReqDate"
	s Title2="TAgrReqUser^TFromWardLoc^TFromWardDesc"
	s Title=Title1_"^"_Title2
	s End=cnt
	s count=0
	s Index=""
	f  s Index=$o(^TMP("DHCINPHA",$this,"jsQueryAgrParReqList",pid,"DISPAGRPREQ",Index)) q:Index=""  d
	.s mdata=^TMP("DHCINPHA",$this,"jsQueryAgrParReqList",pid,"DISPAGRPREQ",Index)
	.s count=count+1 
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"jsQueryAgrParReqList",pid,"DISPAGRPREQ")
	q ""
ErrorjsQueryAgrParReqList
	k ^TMP("DHCINPHA",$this,"jsQueryAgrParReqList",pid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

/// Description:住院发药汇总明细统一入口
/// Creator:	hulihua
/// CreateDate:	2017-11-16
/// Table:      DHC_PhaMedBroth-揭药主表、DHC_PhaMedBrothItm-揭药子表
/// Input:		每页行数、页数、药房科室ID^病区ID
/// Output:		病区ID、病区名称
/// Return：    
/// Others:
/// w ##class(web.DHCINPHA.HMDepartDisp.AgrPartyDispQuery).jsQueryInDisp("1","50","96!!216!!16/12/2017!!16/12/2017!!2754!!XDCF!!2","total","","")
/// w ##class(web.DHCINPHA.HMDepartDisp.AgrPartyDispQuery).jsQueryInDisp("1","50","96!!1!!20/11/2017!!21/11/2017!!2754!!XDCF#1019277","detail","","jqGrid")
ClassMethod jsQueryInDisp(page, rows, params, querytype, Pid = "", style = "")
{
	n (page, rows, params, querytype, Pid, style)
	//s ^hlh($h)=$lb(page, rows, params, querytype, Pid, style)	
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	s cellSplit="!!"
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s displocrowid=$p(params,cellSplit,1)
	s wardrowid=$p(params,cellSplit,2)
	s Userid=$p(params,cellSplit,3)
	s DispCat=$p(params,cellSplit,4)
	s PhaAprId=$p(params,cellSplit,5)
	s FromWardLoc=$p(params,cellSplit,6)
	q:displocrowid="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i Pid'="" d
	.i querytype="total" d OutPutTotal
	.i querytype="detail" d OutPutDetail
	q:Pid'="" ""
	s PID=..PCHCOLLSByReq(PhaAprId)
	s PhaAprReqDate=$p(^DHCPHAAPR(PhaAprId),"^",3)
	q:PID="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson() 
	s PID=##class(web.DHCINPHA.HMDepartDisp.AgrPartyDispReq).PCHCOLLS(displocrowid,wardrowid,DispCat,FromWardLoc,PID,PhaAprReqDate)
	s Pid=PID
	i querytype="total" d OutPutTotal
	i querytype="detail" d OutPutDetail
	q ""
OutPutTotal
	s totalTitle="TPhaApriId$$TArcimDr$$TDesc$$TAccQty$$TReqQty$$TDspQty$$TUom$$TPID"
	s count=0
	s tmpindex=""
	f  s tmpindex=$o(^TMP("DHCINPHA",$this,"PCHCOLLSByReq",Pid,"DISPM",tmpindex)) q:tmpindex=""  d
 	.s result=^TMP("DHCINPHA",$this,"PCHCOLLSByReq",Pid,"DISPM",tmpindex)
 	.s TPhaApriId=$p(result,"^",1)
 	.s TArcimDr=$p(result,"^",2)
	.s TDesc=$p(result,"^",3)
	.s TAccQty=$p(result,"^",4)
	.S TReqQty=$p(result,"^",5)
	.s TDspQty=TReqQty
	.s TUom="付"
	.s outputdata=TPhaApriId_"$$"_TArcimDr_"$$"_TDesc_"$$"_TAccQty_"$$"_TReqQty_"$$"_TDspQty_"$$"_TUom_"$$"_Pid
	.s count=count+1
	.q:count<stpage
    .q:count>endpage
	.I count=stpage d
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonStartStringJqGrid(count,rows)
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(totalTitle,outputdata,"$$")
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(totalTitle,outputdata,"$$")
	.
	i count>0 w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	i +count=0 w ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	q ""
	
OutPutDetail
	s detailTitle1="TPID$$TAdmLoc$$TBedNo$$TPaName$$TRegNo$$TDesc$$TQty$$TPrescNo$$Toedis$$TUserAdd"
	s detailTitle2="TTimeAdd$$TDiagnose$$TAge$$Tsex$$TTimeDosing$$Tcooktype$$TDispIdStr"
	s detailTitle=detailTitle1_"$$"_detailTitle2
	s countrecords=0,count=0
 	s TmpCat=""
 	f  s TmpCat=$o(^TMP("DHCINPHA","web.DHCINPHA.HMDepartDisp.AgrPartyDispReq","PCHCOLLS",Pid,"DispCat",TmpCat)) q:TmpCat=""  d
 	.s SubStr=""
 	.f  s SubStr=$o(^TMP("DHCINPHA","web.DHCINPHA.HMDepartDisp.AgrPartyDispReq","PCHCOLLS",Pid,"DispCat",TmpCat,SubStr)) q:SubStr=""  d
 	..s DataStr=^TMP("DHCINPHA","web.DHCINPHA.HMDepartDisp.AgrPartyDispReq","PCHCOLLS",Pid,"DispCat",TmpCat,SubStr)
 	..s OrdItmRowid=$p(SubStr,"^",2)
 	..s AdmDr=$p(SubStr,"^",3)
 	..s Prescno=$p(DataStr,"^",1)
 	..s DspQty=$p(DataStr,"^",2)
 	..s BedNo=$p(DataStr,"^",3)
 	..s OeFlag=$p(DataStr,"^",4)
 	..s:OeFlag="V" OeFlag="核实"
 	..s AdmLoc=$p(DataStr,"^",5)
 	..s AdmLocDesc=$p(^CTLOC(AdmLoc),"^",2) 
 	..s BedId=$p(DataStr,"^",7)
 	..s DspIdStr=$p(DataStr,"^",8)
 	..s TimeDosing=$p(DataStr,"^",10)
 	..s RecLocId=$p(DataStr,"^",11)
 	..s DateTime=$p(DataStr,"^",12)
 	..s OrdInfo=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetOrdInfo(OrdItmRowid)
 	..s ArcimDesc=$p(OrdInfo,"^",3)
	..s UserAdd=$p(OrdInfo,"^",15)       ;医生
	..s patInfo=##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetPatInfo(AdmDr)	 
 	..s PatNo=$p(patInfo,"^",1) 
	..s PatName=$p(patInfo,"^",3)
	..s Sex=$p(patInfo,"^",4)
	..s Age=$p(patInfo,"^",5)    
	..s Diagnose=$p(patInfo,"^",9) 				
	..s outputdata1=Pid_"$$"_AdmLocDesc_"$$"_BedNo_"$$"_PatName_"$$"_PatNo_"$$"_ArcimDesc_"$$"_DspQty_"$$"_Prescno_"$$"_OrdItmRowid_"$$"_UserAdd
	..s outputdata2=DateTime_"$$"_Diagnose_"$$"_Age_"$$"_Sex_"$$"_TimeDosing_"$$"_DspIdStr
	..s outputdata=outputdata1_"$$"_outputdata2
	..s countrecords=countrecords+1
	..s count=count+1
	..q:count<stpage
    ..q:count>endpage
	..I count=stpage d
	...w ##class(web.DHCSTJQUERYCOMMON).getJsonRowSign()
	...W ##class(web.DHCSTJQUERYCOMMON).getJsonData(detailTitle,outputdata,"$$")
	..e  d
	...W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(detailTitle,outputdata,"$$")
	i count>0 d
	.w ##class(web.DHCSTJQUERYCOMMON).getJsonEndStringJqGrid(count,rows)
	e  w ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	q ""
}

/// Description:整理病区待发科室协定方汇总信息,直接从科室协定方申请表检索数据
/// Creator:	hulihua
/// CreateDate:	2017-12-16
/// Table:      DHC_PhaAgrPartyReq、DHC_PhaAgrPartyReqItm
/// Input:		药房ID、病区ID、开始日期、截至日期、发药人ID、发药类别、登录科室ID
/// Output:		npid 进程号
/// Return：    
/// Others:
/// w ##class(web.DHCINPHA.HMDepartDisp.AgrPartyDispQuery).PCHCOLLSByReq("2")
ClassMethod PCHCOLLSByReq(PhaAprId As %String) As %Integer
{
	n (PhaAprId)
	s npid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid($this) 
	d ..KillTmp(npid)
	s i=0
	s PhaAprCh=0
	f  s PhaAprCh=$o(^DHCPHAAPR(PhaAprId,"I",PhaAprCh))  q:PhaAprCh=""  d
	.q:'$d(^DHCPHAAPR(PhaAprId,"I",PhaAprCh))
	.s PhaApriId=PhaAprId_"||"_PhaAprCh
	.s ArcimId=$p(^DHCPHAAPR(PhaAprId,"I",PhaAprCh),"^",1)
	.s ^TMP("DHCINPHA",$this,"PCHCOLLSByReq",npid,"ARCIMDR",ArcimId)=""
	.s ArcimDesc=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",2)
	.s AccQty=$p(^DHCPHAAPR(PhaAprId,"I",PhaAprCh),"^",2)
	.s ReqQty=+$p(^DHCPHAAPR(PhaAprId,"I",PhaAprCh),"^",3)
	.q:ReqQty=0
	.k ^TMP("DHCINPHA",$this,"PCHCOLLSByReq",npid,"ARCIMDR",ArcimId)
	.s Index=PhaAprId_"||"_PhaAprCh
	.s i=i+1
	.s ^TMP("DHCINPHA",$this,"PCHCOLLSByReq",npid,"DISPM",Index)=PhaApriId_"^"_ArcimId_"^"_ArcimDesc_"^"_AccQty_"^"_ReqQty
	i i>0 q npid    
	q ""
}

/// Description：科室协定方已发药查询
/// Creator：    hulihua
/// CreatDate：  2018-01-12
/// Table：      DHC_PhaAgrPartyReq-科室协定方申请主表、DHC_PhaAgrPartyReqItm-科室协定方申请子表
/// Input：      StartDate-开始日期,EndDate-结束日期,StartTime-开始时间,EndTime-截至时间,PhaLocId-药房ID
/// Output：	 病区、申请单号、申请日期、申请人、本期积累开始日期、本积累截至日期、申请单发药金额、协定方名称、协定方数量     
/// Return：       
/// Others：
/// d ##Class(%ResultSet).RunQuery("web.DHCINPHA.HMDepartDisp.AgrPartyDispQuery","AgrPartyHerMed","2017-12-21","2018-01-12","D","96","482")     
Query AgrPartyHerMed(StartDate As %String, EndDate As %String, AprStatusStr As %String, PhaLocId As %String, WardLocId As %String = "", StatType As %String) As websys.Query(ROWSPEC = "TWardDesc:%String,TAgrReqNo:%String,TAgrReqDate:%String,TAgrReqUser:%String,TAgrDispDate:%String,TAgrDispUser:%String,TSumSpAmt:%Float,TArcimDesc:%String,TDispQty:%Integer,TDispUom:%String,TAccQty:%Integer,TAprStatuDesc:%String,TSumRpAmt:%Float,TFromWardDesc:%String") [ SqlProc ]
{
}

ClassMethod AgrPartyHerMedExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, AprStatusStr As %String, PhaLocId As %String, WardLocId As %String = "", StatType As %String) As %Status
{
	n (qHandle,StartDate,EndDate,AprStatusStr,PhaLocId,WardLocId,StatType)
	//s ^hlh($h)=$lb(StartDate,EndDate,AprStatusStr,PhaLocId,WardLocId,StatType)
	Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1
    q:(StartDate="")||(EndDate="") $$$OK
   	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	q:StartDate>EndDate $$$OK
	s pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid($this)
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"AgrPartyHerMed",pid,"DISPAGRPREQ")
	f Date=StartDate:1:EndDate d
	.s LenAprStatu=$l(AprStatusStr,",")
	.f j=1:1:LenAprStatu d
	..s AprStatus=$p(AprStatusStr,",",j)
	..s PhaAprId=""
	..i StatType=1 d
	...;按照发药日期
	...f  s PhaAprId=$o(^DHCPHAAPRi("DispDatePhloc",Date,PhaLocId,PhaAprId)) q:PhaAprId=""  d
	....d SetTmpGlobal
	...
	..e  d
	...;按照申请日期
	...f  s PhaAprId=$o(^DHCPHAAPRi("DatePhLocStatus",AprStatus,Date,PhaLocId,PhaAprId)) q:PhaAprId=""  d
	....d SetTmpGlobal
	...
	..
	.
	s Index1=""
	f  s Index1=$o(^TMP("DHCINPHA",$this,"AgrPartyHerMed",pid,"DISPAGRPREQ",Index1))  q:Index1=""  d
	.s Index2=""
	.f  s Index2=$o(^TMP("DHCINPHA",$this,"AgrPartyHerMed",pid,"DISPAGRPREQ",Index1,Index2))  q:Index2=""  d
	..s data=^TMP("DHCINPHA",$this,"AgrPartyHerMed",pid,"DISPAGRPREQ",Index1,Index2)
    ..s Data=$LISTFROMSTRING(data,"^") 
	..S ^CacheTemp(repid,ind)=Data
	..S ind=ind+1
	.
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"AgrPartyHerMed",pid,"DISPAGRPREQ")
	Set QHandle=$lb(0,repid,0)
    Quit $$$OK
    
SetTmpGlobal
	q:'$d(^DHCPHAAPR(PhaAprId))
	s PhaAprWard=$p(^DHCPHAAPR(PhaAprId),"^",1)
	q:(WardLocId'="")&&(WardLocId'=PhaAprWard)
	s WardDesc=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetLocInfoById(PhaAprWard),"^",2)
	s AgrReqNo=PhaAprId_$p(^DHCPHAAPR(PhaAprId),"^",10)
	s AgrReqDate=$p(^DHCPHAAPR(PhaAprId),"^",3)
	s AgrReqTime=$p(^DHCPHAAPR(PhaAprId),"^",4)
	s AgrReqUser=$p(^DHCPHAAPR(PhaAprId),"^",5)
	s AgrReqUser=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(AgrReqUser),"^",2)
	s AgrDispDate=$p(^DHCPHAAPR(PhaAprId),"^",7)
	s AgrDispTime=$p(^DHCPHAAPR(PhaAprId),"^",8)
	s Index1=$s(AgrDispDate'="":AgrDispDate_","_AgrDispTime,1:1)
	s:StatType="2" Index1=$s(AgrReqDate'="":AgrReqDate_","_AgrReqTime,1:1)
	s AgrReqDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AgrReqDate)
	s AgrReqTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(AgrReqTime)
	s AgrReqDate=AgrReqDate_" "_AgrReqTime
	s AgrDispDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AgrDispDate)
	s AgrDispTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(AgrDispTime)
	s:AgrDispDate'="" AgrDispDate=AgrDispDate_" "_AgrDispTime 
	s AgrDispUser=$p(^DHCPHAAPR(PhaAprId),"^",9)
	s AgrDispUser=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(AgrDispUser),"^",2)
	s AprStatuDesc=$s(AprStatus="R":"已申请",AprStatus="D":"已发药",1:"作废")
	s FromWardLoc=$p(^DHCPHAAPR(PhaAprId),"^",12)
	s FromWardDesc=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetLocInfoById(FromWardLoc),"^",2)
	;计算申请单的总金额
	s InitDr=$p(^DHCPHAAPR(PhaAprId),"^",11)
	s InitCh="",SumRpAmt=0,SumSpAmt=0
	f  s InitCh=$o(^DHCINIT(InitDr,"ITI",InitCh))  q:InitCh=""  d
	.s RpAmt=+$p(^DHCINIT(InitDr,"ITI",InitCh),"^",16)
	.s SpAmt=+$p(^DHCINIT(InitDr,"ITI",InitCh),"^",18)
	.s SumRpAmt=SumRpAmt+RpAmt
	.s SumSpAmt=SumSpAmt+SpAmt
	s PhaAprCh=0
	f  s PhaAprCh=$o(^DHCPHAAPR(PhaAprId,"I",PhaAprCh))  q:PhaAprCh=""  d
	.q:'$d(^DHCPHAAPR(PhaAprId,"I",PhaAprCh))
	.s ArcimDr=$p(^DHCPHAAPR(PhaAprId,"I",PhaAprCh),"^",1)
	.s ArcimDesc=$p(^ARCIM($p(ArcimDr,"||",1),$p(ArcimDr,"||",2),1),"^",2)
	.s AccQty=+$p(^DHCPHAAPR(PhaAprId,"I",PhaAprCh),"^",2)
	.s DispQty=+$p(^DHCPHAAPR(PhaAprId,"I",PhaAprCh),"^",4)
	.q:DispQty=0
	.s DispUom="付"
	.s Index2=PhaAprId_"||"_PhaAprCh
	.s Data1=WardDesc_"^"_AgrReqNo_"^"_AgrReqDate_"^"_AgrReqUser_"^"_AgrDispDate
	.s Data2=AgrDispUser_"^"_SumSpAmt_"^"_ArcimDesc_"^"_DispQty_"^"_DispUom
	.s Data3=AccQty_"^"_AprStatuDesc_"^"_SumRpAmt_"^"_FromWardDesc
	.s ^TMP("DHCINPHA",$this,"AgrPartyHerMed",pid,"DISPAGRPREQ",Index1,Index2)=Data1_"^"_Data2_"^"_Data3
	q ""
}

/// Description：科室协定方按照病区汇总
/// Creator：    hulihua
/// CreatDate：  2018-05-07
/// Table：      DHC_PhaAgrPartyReq-科室协定方申请主表、DHC_PhaAgrPartyReqItm-科室协定方申请子表
/// Input：      StartDate-开始日期,EndDate-结束日期,StartTime-开始时间,EndTime-截至时间,PhaLocId-药房ID
/// Output：	 病区、申请单号、申请日期、申请人、本期积累开始日期、本积累截至日期、申请单发药金额、协定方名称、协定方数量     
/// Return：       
/// Others：
/// d ##Class(%ResultSet).RunQuery("web.DHCINPHA.HMDepartDisp.AgrPartyDispQuery","AgrPartyHerMedByWard","2017-12-21","2018-01-12","D","96","482")     
Query AgrPartyHerMedByWard(StartDate As %String, EndDate As %String, AprStatusStr As %String, PhaLocId As %String, WardLocId As %String = "") As websys.Query(ROWSPEC = "TWardDesc:%String,TAgrReqNo:%String,TAgrReqDate:%String,TAgrReqUser:%String,TAgrDispDate:%String,TAgrDispUser:%String,TSumSpAmt:%Float,TSumRpAmt:%Float") [ SqlProc ]
{
}

ClassMethod AgrPartyHerMedByWardExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, AprStatusStr As %String, PhaLocId As %String, WardLocId As %String = "") As %Status
{
	n (qHandle,StartDate,EndDate,AprStatusStr,PhaLocId,WardLocId)
	//s ^hlh($h)=$lb(StartDate,EndDate,AprStatusStr,PhaLocId,WardLocId)
	s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    q:(StartDate="")||(EndDate="") $$$OK
   	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	q:StartDate>EndDate $$$OK
	s pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid($this)
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"AgrPartyHerMedByWard",pid,"DISPAGRPREQ")
	f Date=StartDate:1:EndDate d
	.s LenAprStatu=$l(AprStatusStr,",")
	.f j=1:1:LenAprStatu d
	..s AprStatus=$p(AprStatusStr,",",j)
	..s PhaAprId=""
	..f  s PhaAprId=$o(^DHCPHAAPRi("DatePhLocStatus",AprStatus,Date,PhaLocId,PhaAprId)) q:PhaAprId=""  d
	...q:'$d(^DHCPHAAPR(PhaAprId))
	...s PhaAprWard=$p(^DHCPHAAPR(PhaAprId),"^",1)
	...q:(WardLocId'="")&&(WardLocId'=PhaAprWard)
	...s WardDesc=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetLocInfoById(PhaAprWard),"^",2)
	...s AgrReqNo=$p(^DHCPHAAPR(PhaAprId),"^",10)
	...s AgrReqDate=$p(^DHCPHAAPR(PhaAprId),"^",3)
	...s AgrReqTime=$p(^DHCPHAAPR(PhaAprId),"^",4)
	...s AgrReqUser=$p(^DHCPHAAPR(PhaAprId),"^",5)
	...s AgrReqUser=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(AgrReqUser),"^",2)
	...s AgrDispDate=$p(^DHCPHAAPR(PhaAprId),"^",7)
	...s AgrDispTime=$p(^DHCPHAAPR(PhaAprId),"^",8)
	...s AgrReqDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AgrReqDate)
	...s AgrReqTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(AgrReqTime)
	...s AgrReqDate=AgrReqDate_" "_AgrReqTime
	...s AgrDispDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AgrDispDate)
	...s AgrDispTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(AgrDispTime)
	...s:AgrDispDate'="" AgrDispDate=AgrDispDate_" "_AgrDispTime 
	...s AgrDispUser=$p(^DHCPHAAPR(PhaAprId),"^",9)
	...s AgrDispUser=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(AgrDispUser),"^",2)
	...s AprStatuDesc=$s(AprStatus="R":"已申请",AprStatus="D":"已发药",1:"作废")
	...;计算申请单的总金额
	...s InitDr=$p(^DHCPHAAPR(PhaAprId),"^",11)
	...s InitCh="",SumRpAmt=0,SumSpAmt=0
	...f  s InitCh=$o(^DHCINIT(InitDr,"ITI",InitCh))  q:InitCh=""  d
	....s RpAmt=+$p(^DHCINIT(InitDr,"ITI",InitCh),"^",16)
	....s SpAmt=+$p(^DHCINIT(InitDr,"ITI",InitCh),"^",18)
	....s SumRpAmt=SumRpAmt+RpAmt
	....s SumSpAmt=SumSpAmt+SpAmt
	...s Index=PhaAprId
	...s Data1=WardDesc_"^"_AgrReqNo_"^"_AgrReqDate_"^"_AgrReqUser_"^"_AgrDispDate
	...s Data2=AgrDispUser_"^"_SumSpAmt_"^"_SumRpAmt
	...s ^TMP("DHCINPHA",$this,"AgrPartyHerMedByWard",pid,"DISPAGRPREQ",Index)=Data1_"^"_Data2
	...
	..
	.
	s Index=""
	f  s Index=$o(^TMP("DHCINPHA",$this,"AgrPartyHerMedByWard",pid,"DISPAGRPREQ",Index))  q:Index=""  d
	.s data=^TMP("DHCINPHA",$this,"AgrPartyHerMedByWard",pid,"DISPAGRPREQ",Index)
    .s Data=$LISTFROMSTRING(data,"^") 
	.S ^CacheTemp(repid,ind)=Data
	.S ind=ind+1
	.
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"AgrPartyHerMedByWard",pid,"DISPAGRPREQ")
	Set QHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// w ##class(web.DHCINPHA.HMDepartDisp.AgrPartyDispQuery).SaveAgrParDisp("879","96^216^5^2754","5||1^23843||1^10^10!!5||2^23844||1^10^10!!5||3^22700||1^3^3")
ClassMethod SaveAgrParDisp(pid As %String, MainInfo As %String, ListStr As %String) As %String
{
	n (pid,MainInfo,ListStr)
	//s ^hlh($h)=$lb(pid,MainInfo,ListStr)
 	s DispLocId=$p(MainInfo,"^",1)
 	s WardLocId=$p(MainInfo,"^",2)
 	s PhaAprId=$p(MainInfo,"^",3)
 	s DispUserId=$p(MainInfo,"^",4)
    s HospId=$p($g(^CTLOC(DispLocId)),"^",22) 
    s Complete="Y",Status="11",StkType="G",Remark="科室协定方转移",OpTypeId="71"
    tstart
    s $ZT="Error^DHCSTERROR"
    ;第一步，生成库存转移表并审核出库！
    s ListLen=$l(ListStr,"!!")
    s IfAllZFlag="",Err=0,MainId=""
    f l=1:1:ListLen  q:IfAllZFlag'=""  d
    .s ListData=$p(ListStr,"!!",l)
    .s DispQty=$p(ListData,"^",4)
    .q:DispQty=0
    .s IfAllZFlag=1
    s Ret=""
    i IfAllZFlag=1  d
    .s MainData=DispLocId_"^"_WardLocId_"^^"_OpTypeId_"^"_Complete_"^"_Status_"^"_DispUserId_"^^"_StkType_"^"_Remark
    .s Ret=##class(web.DHCST.DHCINIsTrf).Update("",MainData)
    i (IfAllZFlag=1)&&(+Ret'>0) trollback
    q:(IfAllZFlag=1)&&(Ret'>0) Ret
    s MainId=Ret
    d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"SaveAgrParDisp",pid,"INCI")
    f j=1:1:ListLen d
    .s ListData=$p(ListStr,"!!",j)
    .s arcimid=$p(ListData,"^",2)
    .s DispQty=$p(ListData,"^",4)
    .q:DispQty=0
    .s DepId=0 
	.f  s DepId=$O(^ARCIM(+arcimid,$p(arcimid,"||",2),"DEPEND",DepId)) q:DepId=""  d
	..s depdatefrom=$p(^ARCIM(+arcimid,$p(arcimid,"||",2),"DEPEND",DepId),"^",1)
	..q:(depdatefrom'="")&&(depdatefrom>+$h)
	..s depdateto=$p(^ARCIM(+arcimid,$p(arcimid,"||",2),"DEPEND",DepId),"^",2)
	..q:(depdateto'="")&&(depdateto<+$h)
	..s deparcimdr=$p(^ARCIM(+arcimid,$p(arcimid,"||",2),"DEPEND",DepId),"^",3)
	..q:deparcimdr=""
	..s DoseQtyCM=$p(^ARCIM(+arcimid,$p(arcimid,"||",2),"DEPEND",DepId),"^",7)
	..s UomDr=$p(^ARCIM(+arcimid,$p(arcimid,"||",2),"DEPEND",DepId),"^",8)
	..s TotalQty=DispQty*DoseQtyCM
    ..s InciId=$o(^INCI(0,"ARCIM_DR",+deparcimdr,""))
    ..q:InciId=""
    ..s Index=InciId_","_UomDr
    ..i $d(^TMP("DHCINPHA",$this,"SaveAgrParDisp",pid,"INCI",Index))  d
    ...s ^TMP("DHCINPHA",$this,"SaveAgrParDisp",pid,"INCI",Index)=+$G(^TMP("DHCINPHA",$this,"SaveAgrParDisp",pid,"INCI",Index))+TotalQty
    ..e  d
    ...s ^TMP("DHCINPHA",$this,"SaveAgrParDisp",pid,"INCI",Index)=TotalQty
    ..
    .
    s Index="",Count=0
    f  s Index=$o(^TMP("DHCINPHA",$this,"SaveAgrParDisp",pid,"INCI",Index))  q:(Index="")!(Err'=0)  d
    .s InciId=$p(Index,",",1)
    .s UomDr=$p(Index,",",2)
    .s TotalQty=^TMP("DHCINPHA",$this,"SaveAgrParDisp",pid,"INCI",Index)
    .s Chl=$o(^INCI("IL_LOC",DispLocId,InciId,0))
	.s Incil=InciId_"||"_Chl
    .s AvaQty=##class(web.DHCST.Common.DrugStkCommon).CurItmAvaQtyB(Incil,UomDr)
    .i TotalQty>AvaQty s Err=-10
    .q:TotalQty>AvaQty
    .s BUomDr=$p(^INCI(InciId,1),"^",10)
    .s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(UomDr,BUomDr)
    .s TotalQty=TotalQty*Fac 
    .s npid=##class(web.DHCST.DHCINIsTrfItm).GetInclbForTransfer(DispLocId,InciId,TotalQty)
    .q:npid=""
    .s InclbIndex=""
    .f  s InclbIndex=$o(^TMPGETINCLB(npid,InclbIndex)) q:(InclbIndex="")!(Err'=0)  d
    ..s IncInfo=^TMPGETINCLB(npid,InclbIndex)   ;批次信息
    ..s Inclb=$p(IncInfo,"^",4)
    ..s Qty=$p(IncInfo,"^",7)     		;批次转移数量
    ..s Qty=Qty/Fac
    ..s Rp=##class(web.DHCST.Common.PriceCommon).GetClbRp(Inclb,UomDr,HospId,"G",+$h,"")
    ..s Sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(Inclb,+$h,UomDr,HospId,"G","")  
    ..s NewSp=##class(web.DHCST.Common.PriceCommon).BatSpUom(Inclb,UomDr,HospId)
    ..s SpAmt=Sp*Qty
    ..s RpAmt=Rp*Qty
    ..s NewSpAmt=NewSp*Qty
    ..s SpAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(SpAmt,HospId)
    ..s NewSpAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(NewSpAmt,HospId)
    ..s RpAmt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
    ..s Data1=Inclb_"^"_Qty_"^"_UomDr_"^^"_Rp_"^"_RpAmt_"^"_Sp_"^"_SpAmt
    ..s Data2=Rp_"^"_RpAmt_"^"_NewSp_"^"_NewSpAmt_"^"_Remark
    ..s Detail=Data1_"^"_Data2
    ..s Count=Count+1
    ..;保存明细
    ..s Ret=##class(web.DHCST.DHCINIsTrfItm).Update("",MainId,Detail)
    ..i +Ret<=0  s Err=-3    ;保存明细失败
    ..q:+Ret<=0
    ..;增加新占用库存
    ..s Rowid=Ret
    ..s Ret=##class(web.DHCST.DHCINIsTrf).HandleTransItmDirtyQty(Rowid,1)  ;增加新占用库存
    ..i Ret'=0  s Err=-4    ;增加占用库存失败
    ..q:Ret'=0
    ..
    .k ^TMPGETINCLB(npid)
    i Err'=0 trollback
    q:Err'=0 Err
    i (Count<1)&&(MainId'="")  trollback
    q:(Count<1)&&(MainId'="") -5
    s:MainId'="" Err=##class(web.DHCST.DHCINIsTrf).TransOutAuditYes(MainId,DispUserId)
	i Err'=0 trollback 
	q:Err'=0 -6
	;第二步，处理打包表和打包子表！
	s PhacType="XDCF"
	s SubStr=""
	f  s SubStr=$o(^TMP("DHCINPHA","web.DHCINPHA.HMDepartDisp.AgrPartyDispReq","PCHCOLLS",pid,"DispCat",PhacType,SubStr))  q:(SubStr="")||(Err'=0)  d
 	.s OrdItmRowid=$p(SubStr,"^",2)
 	.s AdmDr=$p(SubStr,"^",3)
 	.s WardRowid=$p(SubStr,"^",4)  
 	.q:(WardRowid'=WardLocId)&&(WardRowid'="")  
 	.s DataStr=^TMP("DHCINPHA","web.DHCINPHA.HMDepartDisp.AgrPartyDispReq","PCHCOLLS",pid,"DispCat",PhacType,SubStr)
 	.s DspIdStr=$p(DataStr,"^",8)
  	.s DspId=+DspIdStr		     
	.s DspIdStr=##class(web.DHCSTPCHCOLLS).ReGetDodis(DspIdStr,+OrdItmRowid,$p(OrdItmRowid,"||",2))  ;重新获取配药记录串
	.q:DspIdStr=""
	.;医嘱项到期判断
 	.s ArcEndFlag=..CheckArcEndFlag(DspIdStr)
 	.q:ArcEndFlag=0
	.s cnt=$l(DspIdStr,",")
	.f i=1:1:cnt q:Err'=0  d
	..s dhcoedis=$p(DspIdStr,",",i) 
	..q:dhcoedis=""
 	..s Err=##class(web.DHCINPHA.HMDepartDisp.SqlDbAgrParty).UpdStatusForDODISS(dhcoedis,DispUserId,DispLocId)
 	..q:Err'=0
 	.q:Err'=0 	 
	i Err'=0 trollback
    q:Err'=0 Err
    ;第三步，处理科室协定方申请表！
    s SqlStr=PhaAprId_"^"_DispUserId_"^"_MainId
    s Err=##class(web.DHCINPHA.HMDepartDisp.SqlDbAgrParty).UpdateAgrPartyReq(SqlStr)
    i Err'=0 trollback
    s ListLen=$l(ListStr,"!!")
    f t=1:1:ListLen  q:Err'=0  d
    .s ListData=$p(ListStr,"!!",t)
    .s PhaApriId=$p(ListData,"^",1) 
    .s DispQty=$p(ListData,"^",4) 
    .s SqlStr=PhaApriId_"^"_DispQty
    .s Err=##class(web.DHCINPHA.HMDepartDisp.SqlDbAgrParty).UpdateAgrPartyReqItm(SqlStr)
    .q:Err'=0
    i Err'=0 trollback
	q:Err'=0 -9
	tcommit
	d ..KillTmp(pid)    
    q Err
}

/// Description:判断医嘱项是否到期
/// Creator:	hulihua
/// CreateDate:	2017-11-21
/// Table:      DHC_OEDispensing--新医嘱打包表, OE_OrdItem
/// Input:		DspIdStr(DHC_OEDispensing的RowID字符串,dspID1_","_dspID2)
/// Output:		0-不可发，1-可发
/// Return：    
/// Others:
/// w ##class(web.DHCINPHA.HMDepartDisp.AgrPartyDispQuery).CheckArcEndFlag("776")
ClassMethod CheckArcEndFlag(DspIdStr) As %String
{
	n (DspIdStr)
	s mDspId=$p(DspIdStr,",",1)
	q:mDspId="" 0
	q:$p(^DHCOEDISQTY(mDspId),"^",7)="C" 0
 	s DateDosing=$p($g(^DHCOEDISQTY(mDspId)),"^",21)
 	q:DateDosing="" 0
 	s reclocID=+$p(^DHCOEDISQTY(mDspId),"^",24)
 	s oeordItmID=$p(^DHCOEDISQTY(mDspId),"^",1)
	q:oeordItmID="" 0
 	s ord=$p(oeordItmID,"||",1)
	s chl=$p(oeordItmID,"||",2)
	q:(ord="")!(chl="") 0
	q:'$d(^OEORD(ord,"I",chl)) 0
	s priority=$p(^OECPR($p(^OEORD(ord,"I",chl,1),"^",8)),"^",1)
	q:priority["OM" 0
	s ArcEndDateFlag=1
	s oeori=ord_"||"_chl
    s ArcDateStr=##class(web.DHCSTPCHCOLLS).GetArcEndFlag(oeori)
    s ArcFlag=$p(ArcDateStr,"^",1)
    s:ArcFlag=-1 ArcEndDateFlag=0							
 	q ArcEndDateFlag
}

ClassMethod KillTmp(pid)
{
	n (pid)
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.HMDepartDisp.AgrPartyDispReq","PCHCOLLS",pid,"DispCat")
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"PCHCOLLSByReq",pid,"DISPM")
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"PCHCOLLSByReq",pid,"ARCIMDR")
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"SaveAgrParDisp",pid,"INCI")
	q ""
}

Storage Default
{
<Data name="AgrPartyDispQueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCINPB5F0.AgrPartyDis6C60D</DataLocation>
<DefaultData>AgrPartyDispQueryDefaultData</DefaultData>
<IdLocation>^web.DHCINPB5F0.AgrPartyDis6C60D</IdLocation>
<IndexLocation>^web.DHCINPB5F0.AgrPartyDis6C60I</IndexLocation>
<StreamLocation>^web.DHCINPB5F0.AgrPartyDis6C60S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
