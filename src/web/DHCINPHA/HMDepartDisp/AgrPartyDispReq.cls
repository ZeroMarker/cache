/// Description:病区科室协定方申请查询相关
/// Creator:    hulihua
/// CreateDate: 2017-12-15
/// Table:      DHC_OEDispensing-新医嘱打包表、DHC_OEDispBatch-打包子表、DHC_PhaAgrPartyReq-科室协定方申请主表、DHC_PhaAgrPartyReqItm-科室协定方申请子表
Class web.DHCINPHA.HMDepartDisp.AgrPartyDispReq Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Description:病区科室协定方申请汇总明细统一入口
/// Creator:	hulihua
/// CreateDate:	2017-12-15
/// Table:      DHC_OEDispensing-新医嘱打包表、DHC_OEDispBatch-打包子表
/// Input:		每页行数、页数、药房科室ID^病区ID
/// Output:		病区ID、病区名称
/// Return：    
/// Others:
/// w ##class(web.DHCINPHA.HMDepartDisp.AgrPartyDispReq).jsQueryAgrPartyReq("1","50","96!!216!!15/12/2017!!15/12/2017!!2754","total","1","")
/// w ##class(web.DHCINPHA.HMDepartDisp.AgrPartyDispReq).jsQueryAgrPartyReq("1","50","96!!1!!20/11/2017!!21/11/2017!!2754!!XDCF#1019277","detail","","jqGrid")
ClassMethod jsQueryAgrPartyReq(page, rows, params, querytype, Pid = "", style = "")
{
	n (page, rows, params, querytype, Pid, style)
	//s ^hlh($h)=$lb(page, rows, params, querytype, Pid, style)	
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	s jsQueryReqPid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid($this)
	s cellSplit="!!"
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s displocrowid=$p(params,cellSplit,1)
	s wardrowid=$p(params,cellSplit,2)
	s fromwardloc=$p(params,cellSplit,5)
	s DispCat="XDCF"
	q:displocrowid="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i Pid'="" d
	.i querytype="total" d OutPutTotal
	.i querytype="detail" d OutPutDetail
	q:Pid'="" ""
	s PID=..PCHCOLLS(displocrowid,wardrowid,DispCat,fromwardloc)
	q:PID="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson() 
	s Pid=PID
	i querytype="total" d OutPutTotal
	i querytype="detail" d OutPutDetail
	q ""
OutPutTotal
	s totalTitle="TArcimDr$$TDesc$$TQty$$TReqQty$$TUom$$TPID"
	s amtTotal=0
	s num=0
	s TmpCat=""
 	f  s TmpCat=$o(^TMP("DHCINPHA",$this,"PCHCOLLS",Pid,"DispCat",TmpCat)) q:TmpCat=""  d
 	.s SubStr=""
 	.f  s SubStr=$o(^TMP("DHCINPHA",$this,"PCHCOLLS",Pid,"DispCat",TmpCat,SubStr)) q:SubStr=""  d
 	..s DataStr=^TMP("DHCINPHA",$this,"PCHCOLLS",Pid,"DispCat",TmpCat,SubStr)
 	..s OrdItmRowid=$p(SubStr,"^",2)
 	..s DspQty=$p(DataStr,"^",2)
 	..s Ord=+OrdItmRowid
 	..s Chl=$p(OrdItmRowid,"||",2)
	..s ArcimId=$p(^OEORD(Ord,"I",Chl,1),"^",2)    ;ARCIM_RowId 
	..s ArcimDesc=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",2)  
    ..s tmpindex=ArcimDesc_"||"_ArcimId
    ..s Uom="付"
	..;按医嘱项汇总
	..i $d(^TMP("DHCINPHA",$this,"jsQueryAgrPartyReq",jsQueryReqPid,"TOTAL",tmpindex)) d
	...s $p(^TMP("DHCINPHA",$this,"jsQueryAgrPartyReq",jsQueryReqPid,"TOTAL",tmpindex),"^",3)=+$p(^TMP("DHCINPHA",$this,"jsQueryAgrPartyReq",jsQueryReqPid,"TOTAL",tmpindex),"^",3)+DspQty
	..e  d
	...s ^TMP("DHCINPHA",$this,"jsQueryAgrPartyReq",jsQueryReqPid,"TOTAL",tmpindex)=ArcimId_"^"_ArcimDesc_"^"_DspQty_"^"_Uom
	..
	.
	s count=0
	s tmpindex=""
	f  s tmpindex=$o(^TMP("DHCINPHA",$this,"jsQueryAgrPartyReq",jsQueryReqPid,"TOTAL",tmpindex)) q:tmpindex=""  d
 	.s result=^TMP("DHCINPHA",$this,"jsQueryAgrPartyReq",jsQueryReqPid,"TOTAL",tmpindex)
 	.s TArcimId=$p(result,"^",1)
	.s TDesc=$p(result,"^",2)
	.s TQty=$p(result,"^",3)
	.s TUom=$p(result,"^",4)
	.s ArcDateStr=##class(web.DHCSTPCHCOLLS).GetArcEndFlag(OrdItmRowid)
    .s ArcFlag=$p(ArcDateStr,"^",1)
	.i ArcFlag<0 s TCollStat="医嘱项</br>截止"
	.s TReqQty=""
	.s outputdata=TArcimId_"$$"_TDesc_"$$"_TQty_"$$"_TReqQty_"$$"_TUom_"$$"_Pid
	.s count=count+1
	.q:count<stpage
    .q:count>endpage
	.I count=stpage d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartStringJqGrid(count,rows)
	..W ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(totalTitle,outputdata,"$$")
	.e  d
	..W ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(totalTitle,outputdata,"$$")
	i count>0 w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign()
	k ^TMP("DHCINPHA",$this,"jsQueryAgrPartyReq",jsQueryReqPid,"TOTAL")
	i +count=0 w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(0)
	q ""
	
OutPutDetail
	s detailTitle1="TPID$$TAdmLoc$$TBedNo$$TPaName$$TRegNo$$TDesc$$TQty$$TPrescNo$$Toedis$$TUserAdd"
	s detailTitle2="TTimeAdd$$TDiagnose$$TAge$$Tsex$$TTimeDosing$$TDispIdStr"
	s detailTitle=detailTitle1_"$$"_detailTitle2
	s TSelect="Y" //发药明细默认勾选
	s countrecords=0,count=0
 	s TmpCat=""
 	f  s TmpCat=$o(^TMP("DHCINPHA",$this,"PCHCOLLS",Pid,"DispCat",TmpCat)) q:TmpCat=""  d
 	.s SubStr=""
 	.f  s SubStr=$o(^TMP("DHCINPHA",$this,"PCHCOLLS",Pid,"DispCat",TmpCat,SubStr)) q:SubStr=""  d
 	..s DataStr=^TMP("DHCINPHA",$this,"PCHCOLLS",Pid,"DispCat",TmpCat,SubStr)
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
	...w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonRowSign()
	...W ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(detailTitle,outputdata,"$$")
	..e  d
	...W ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(detailTitle,outputdata,"$$")
	i count>0 d
	.w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndStringJqGrid(count,rows)
	e  w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(0)
	q ""
}

/// Description:整理病区科室协定方待发药信息,直接从打包表检索数据
/// Creator:	hulihua
/// CreateDate:	2018-02-06
/// Table:      DHC_OEDispensing--新医嘱打包表, OE_OrdItem
/// Input:		药房ID、病区科室ID、发药类别、计数器、申请单日期
/// Output:		npid 进程号
/// Return：    
/// Others:
/// w ##class(web.DHCINPHA.HMDepartDisp.AgrPartyDispReq).PCHCOLLS("96","64513","64603")
ClassMethod PCHCOLLS(LocId As %String, WardLoc As %String, DispCat As %String, FromWardLoc As %String, npid As %Integer = "", PhaAprReqDate As %String = "") As %Integer
{
 n (LocId,WardLoc,DispCat,FromWardLoc,npid,PhaAprReqDate)
 s HospId=$p($g(^CTLOC(LocId)),"^",22)
 s:npid="" npid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid($this)
 d ..KillTmp(npid) 
 q:WardLoc="" -1							;病区不能为空
 s:PhaAprReqDate="" PhaAprReqDate=+$h
 s i=0
 s WardGroupDr=""
 f  s WardGroupDr=$o(^DHCOEDISQTY(0,"AdmLoc",WardLoc,WardGroupDr))  q:WardGroupDr=""  d
 .s Cat=DispCat
 .s DspId=0
 .f  s DspId=$o(^DHCOEDISQTY(0,"AdmLoc",WardLoc,WardGroupDr,"TC",LocId,DispCat,DspId)) q:DspId=""  d
 ..s WardLocId=$p(^DHCOEDISQTY(DspId),"^",22)
 ..q:WardLocId=""
 ..s OrdItmRowid=$p(^DHCOEDISQTY(DspId),"^",1)     ;OE_OrdItem表指针
 ..s OrdExeRowid=$p(^DHCOEDISQTY(DspId),"^",3)     ;OE_OrdExec表指针 
 ..s AdmDr=$p(^DHCOEDISQTY(DspId),"^",26)
 ..q:AdmDr=""
 ..s AdmWard=$p(^PAADM(AdmDr),"^",70)  		;病人当前病房
 ..s AdmType=$p($g(^PAADM(AdmDr)),"^",2)
 ..q:AdmType'="I"  							;过滤非住院病人    
 ..s Ord=+OrdExeRowid
 ..s Chl=$p(OrdExeRowid,"||",2)
 ..s OreChl=$p(OrdExeRowid,"||",3)
 ..q:Ord=""
 ..q:Chl=""
 ..q:'$d(^OEORD(Ord))
 ..q:'$d(^OEORD(Ord,"I",Chl))
 ..s PriorDr=$p(^OEORD(Ord,"I",Chl,1),"^",8) 
 ..q:PriorDr=""  																			;优先级不存在的不予发放 2006-05-27 
 ..s Priority=$p(^OECPR(PriorDr),"^",1) 													;医嘱优先级代码              
 ..q:Priority["OM" 																			;自备药即刻,8.0新增嘱托医嘱 
 ..q:'$d(^OEORD(Ord,"I",Chl,"X",OreChl,"BILL"))
 ..s OrderStatusDr=$p(^OEORD(Ord,"I",Chl,"X",OreChl,"BILL"),"^",1)  						;医嘱状态
 ..q:OrderStatusDr=""
 ..s OeFlag=$p(^OEC("OSTAT",OrderStatusDr),"^",1)          									;医嘱核实、未核实、停止状态 
 ..q:##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)=0  								;判断执行记录状态是否可配药
 ..s OrdWardLocDr=$p(^OEORD(Ord,"I",Chl,9),"^",2)
 ..q:(FromWardLoc'="")&&(FromWardLoc'=OrdWardLocDr)
 ..s DateDosing=$p(^DHCOEDISQTY(DspId),"^",21)
 ..q:DateDosing'<PhaAprReqDate																;每次积累要小于申请日期
 ..s TimeDosing=$p(^DHCOEDISQTY(DspId),"^",20)  											;分发时间
 ..s ConfirmFlag=$p($g(^DHCOEDISQTY(DspId)),"^",17)
 ..i WardLoc=$p(^PAWARD(AdmWard),"^",5) d
 ...s BedId=$p(^PAADM(AdmDr),"^",73)	
 ...i BedId'="" s Bed=$p($g(^PAWARD($p(BedId,"||",1),"BED",$p(BedId,"||",2))),"^",1)        ;病人床号
 ...e  s Bed=""
 ..e  d
 ...s BedId=""
 ...s Bed=""
 ..s PatBed=Bed 
 ..s DepLoc=$p(^DHCOEDISQTY(DspId),"^",23) 													;病人所在科室
 ..s DspQty=$p(^DHCOEDISQTY(DspId),"^",11)   												;本顿发药数
 ..s ArcimId=$p(^OEORD(Ord,"I",Chl,1),"^",2)                                    			;医嘱 ARC_ItmMast ARCI
 ..q:ArcimId=""
 ..q:$d(^TMP("DHCINPHA","web.DHCINPHA.HMDepartDisp.AgrPartyDispQuery","PCHCOLLSByReq",npid,"ARCIMDR",ArcimId))	;协定方发药界面过滤掉申请数量为0的		
 ..s DateTime=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(DateDosing,"IP")_","_##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(TimeDosing,"IP")
 ..s Prescno=$p(^OEORD(Ord,"I",Chl,1),"^",14)
 ..i TimeDosing'="" S TimeDosing=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(TimeDosing,"IP") 
 ..s Data1=Prescno_"^"_DspQty_"^"_PatBed_"^"_OeFlag_"^"_DepLoc_"^"_Bed_"^"_BedId_"^"_DspId_"^"_ConfirmFlag_"^"_TimeDosing
 ..s Data2=LocId_"^"_DateTime
 ..;按照同一个人的同一次就诊的医嘱ID去构造
 ..s j=ArcimId_"^"_OrdItmRowid_"^"_AdmDr_"^"_WardLoc    
 ..s i=i+1 
 ..i '$d(^TMP("DHCINPHA",$this,"PCHCOLLS",npid,"DispCat",Cat,j))  d
 ...s ^TMP("DHCINPHA",$this,"PCHCOLLS",npid,"DispCat",Cat,j)=Data1_"^"_Data2
 ..e  d
 ...s $p(^TMP("DHCINPHA",$this,"PCHCOLLS",npid,"DispCat",Cat,j),"^",2)=$p(^TMP("DHCINPHA",$this,"PCHCOLLS",npid,"DispCat",Cat,j),"^",2)+DspQty
 ...s $p(^TMP("DHCINPHA",$this,"PCHCOLLS",npid,"DispCat",Cat,j),"^",8)=$p(^TMP("DHCINPHA",$this,"PCHCOLLS",npid,"DispCat",Cat,j),"^",8)_","_DspId
 ...s $p(^TMP("DHCINPHA",$this,"PCHCOLLS",npid,"DispCat",Cat,j),"^",10)=$p(^TMP("DHCINPHA",$this,"PCHCOLLS",npid,"DispCat",Cat,j),"^",10)_","_TimeDosing
 ..
 .
 i i>0 q npid    
 q ""
}

/// Description:查询满足条件的未发药申请单列表
/// Creator:	hulihua
/// CreateDate:	2018-03-27
/// Table:      DHC_PhaAgrPartyReq-科室协定方申请主表
/// Input:		每页行数、页数、开始日期^截止日期^药房科室ID^病区ID
/// Output:		病区ID、病区名称
/// Return：    
/// Others:
/// Debug:		w ##class(web.DHCINPHA.HMDepartDisp.AgrPartyDispReq).GetAgrParReqList("1","50","96^322^R")
ClassMethod GetAgrParReqList(page, rows, params) As %Library.String
{
	n (page, rows, params)
	//s ^hlh($h)=$lb(page, rows, params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	s DataDelim=##class(web.DHCINPHA.MTCommon.PublicCallMethod).RowDataDelim()
	s phaLoc=$p(params,DataDelim,1)
	s wardLoc=$p(params,DataDelim,2)
	s aprStatus=$p(params,DataDelim,3)
	s Title="TPhaAprId^TAgrReqNo^TAgrReqDate^TAgrReqUser^TAgrFromWard"
	s count=0
	s PhaAprId=""
	f  s PhaAprId=$o(^DHCPHAAPRi("StatusWardLocPhLoc",aprStatus,wardLoc,phaLoc,PhaAprId)) q:PhaAprId=""  d
	.s AgrReqNo=$p(^DHCPHAAPR(PhaAprId),"^",10)
	.s AgrReqDate=$p(^DHCPHAAPR(PhaAprId),"^",3)
	.s AgrReqTime=$p(^DHCPHAAPR(PhaAprId),"^",4)
	.s AgrReqDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AgrReqDate)
	.s AgrReqTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(AgrReqTime)
	.s AgrReqDate=AgrReqDate_" "_AgrReqTime
	.s AgrReqUser=$p(^DHCPHAAPR(PhaAprId),"^",5)
	.s AgrReqUser=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(AgrReqUser),"^",2)
	.s AgrFromWard=$p(^DHCPHAAPR(PhaAprId),"^",12)
	.s AgrFromWard=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetLocInfoById(AgrFromWard),"^",2)
	.s mdata=PhaAprId_"^"_AgrReqNo_"^"_AgrReqDate_"^"_AgrReqUser_"^"_AgrFromWard
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonRowSign()
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	i count>0 d
	.w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndStringJqGrid(count,rows)
	e  d
	.w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(0)
	q ""
}

/// Description:获取未发药申请单的详细信息列表
/// Creator:	hulihua
/// CreateDate:	2018-03-27
/// Table:      DHC_PhaAgrPartyReqItm-科室协定方申请子表
/// Input:		每页行数、页数、申请主表ID
/// Output:		病区ID、病区名称
/// Return：    
/// Others:
/// Debug:		w ##class(web.DHCINPHA.HMDepartDisp.AgrPartyDispReq).GetAgrParReqDetList("1","50","1")
ClassMethod GetAgrParReqDetList(page, rows, params) As %Library.String
{
	n (page, rows, params)
	//s ^hlh($h)=$lb(page, rows, params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	s DataDelim=##class(web.DHCINPHA.MTCommon.PublicCallMethod).RowDataDelim()
	s PhaAprId=$p(params,DataDelim,1)
	s Title="TPhaApriId^TArcimDesc^TAccQty^TReqQty^TDispUom^TUpReqDate^TUpReqUser"
	s PhaAprCh=0,count=0
	f  s PhaAprCh=$o(^DHCPHAAPR(PhaAprId,"I",PhaAprCh))  q:PhaAprCh=""  d
	.q:'$d(^DHCPHAAPR(PhaAprId,"I",PhaAprCh))
	.s ArcimDr=$p(^DHCPHAAPR(PhaAprId,"I",PhaAprCh),"^",1)
	.s ArcimDesc=$p(^ARCIM($p(ArcimDr,"||",1),$p(ArcimDr,"||",2),1),"^",2)
	.s AccQty=+$p(^DHCPHAAPR(PhaAprId,"I",PhaAprCh),"^",2)
	.s ReqQty=+$p(^DHCPHAAPR(PhaAprId,"I",PhaAprCh),"^",3)
	.s DispUom="付"
	.s UpReqDate=$p(^DHCPHAAPR(PhaAprId,"I",PhaAprCh),"^",5)
	.s UpReqTime=$p(^DHCPHAAPR(PhaAprId,"I",PhaAprCh),"^",6)
	.s UpReqDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(UpReqDate)
	.s UpReqTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(UpReqTime)
	.s UpReqDate=UpReqDate_" "_UpReqTime
	.s UpReqUserDr=$p(^DHCPHAAPR(PhaAprId,"I",PhaAprCh),"^",7)
	.s UpReqUser=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(UpReqUserDr),"^",2)
	.s PhaApriId=PhaAprId_"||"_PhaAprCh
	.s mdata=PhaApriId_"^"_ArcimDesc_"^"_AccQty_"^"_ReqQty_"^"_DispUom_"^"_UpReqDate_"^"_UpReqUser
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonRowSign()
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.
	i count>0 d
	.w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndStringJqGrid(count,rows)
	e  w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(0)
	q ""
}

ClassMethod KillTmp(pid)
{
	n (pid)
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"PCHCOLLS",pid,"DispCat")
	q ""
}

/// Description:保存护士申请科室协定方信息
/// Creator:	hulihua
/// CreateDate:	2017-12-15
/// Table:      DHC_PhaAgrPartyReq-科室协定方申请主表、DHC_PhaAgrPartyReqItm-科室协定方申请子表
/// Input:		MainData-主表信息，ListData-明细信息
/// Output:		
/// Return：	0-成功，非0-失败    
/// Others:
/// w ##class(web.DHCINPHA.HMDepartDisp.AgrPartyDispReq).SaveReqData("96!!216!!16/12/2017!!16/12/2017!!2754!!R","22700||1^4^3")
ClassMethod SaveReqData(MainData As %String, ListData As %String) As %String
{
	n (MainData, ListData)
	//s ^hlh($h)=$lb(MainData, ListData)
	q:(MainData="")||(ListData="") -1
    tstart						;开启事务
    s $ZT="Error^DHCSTERROR"    ;增加错误处理
	s PhaAprId=##class(web.DHCINPHA.HMDepartDisp.SqlDbAgrParty).InsertAgrPartyReq(MainData)
	i PhaAprId'>0 trollback
    q:PhaAprId'>0 PhaAprId
    s LisLen=$l(ListData,"!!")
    s Ret=0
    f j=1:1:LisLen q:Ret'=0  d
    .s ListSqlStr=$p(ListData,"!!",j)
    .s Ret=##class(web.DHCINPHA.HMDepartDisp.SqlDbAgrParty).InsertAgrPartyReqItm(PhaAprId,ListSqlStr)
    i Ret'=0 trollback
    q:Ret'=0 Ret
    tcommit    					;提交事务
    q PhaAprId
}

/// Description:更新科室未发药的科室协定方信息
/// Creator:	hulihua
/// CreateDate:	2018-03-27
/// Table:      DHC_PhaAgrPartyReqItm-科室协定方申请子表
/// Input:		PhaApriId-科室协定方申请单明细信息
/// Output:		
/// Return：	0-成功，非0-失败    
/// Others:
/// w ##class(web.DHCINPHA.HMDepartDisp.AgrPartyDispReq).UpReqDetData("96!!216!!16/12/2017!!16/12/2017!!2754!!R","22700||1^4^3")
ClassMethod UpReqDetData(PhaApriId As %String, InputReqQty As %String, UpReqIUserId As %String) As %String
{
	n (PhaApriId,InputReqQty,UpReqIUserId)
	//s ^hlh($h)=$lb(PhaApriId,InputReqQty,UpReqIUserId)
	q:(PhaApriId="") -1
	s AprStatus=$p(^DHCPHAAPR(+PhaApriId),"^",6)
	q:AprStatus'="R" -3
	s ReqQty=+$p(^DHCPHAAPR(+PhaApriId,"I",$p(PhaApriId,"||",2)),"^",3)
	q:InputReqQty=ReqQty 0
    s $ZT="Error^DHCSTERROR"    ;增加错误处理
    s SqlStr=PhaApriId_"^^"_InputReqQty_"^"_UpReqIUserId
    s Ret=##class(web.DHCINPHA.HMDepartDisp.SqlDbAgrParty).UpdateAgrPartyReqItm(SqlStr,"1")
    q Ret
}

Storage Default
{
<Data name="AgrPartyDispReqDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCINPB5F0.AgrPartyDisE60ED</DataLocation>
<DefaultData>AgrPartyDispReqDefaultData</DefaultData>
<IdLocation>^web.DHCINPB5F0.AgrPartyDisE60ED</IdLocation>
<IndexLocation>^web.DHCINPB5F0.AgrPartyDisE60EI</IndexLocation>
<StreamLocation>^web.DHCINPB5F0.AgrPartyDisE60ES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
