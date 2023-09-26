/// Description:药房护士取药发药查询相关（按照备药单）
/// Creator:    hulihua
/// CreateDate: 2017-04-12
/// Table:      DHC_PHDraw备药单主表、DHC_PHDrawInc备药单子表（药品汇总）、DHC_PHDrawOrder备药单孙表（医嘱明细表）
Class web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Description:查询药房待发护士取药备药单列表
/// Creator:	hulihua
/// CreateDate:	2017-04-12
/// Table:      DHC_PHDraw
/// Input:		每页行数、页数、开始日期^截至日期^药房科室ID^备药单状态^备药单类型
/// Output:		病区科室ID、病区科室、备药单ID、备药单号、备药单日期、备药单时间、备药人
/// Return：    
/// w ##class(web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery).GetInPhDrawDispList("50","1","01/09/2017^00:00^01/12/2017^23:59^102^^30^2^")
ClassMethod GetInPhDrawDispList(rows, page, params) As %String
{
	n (rows, page,params)
	//s ^hlh($h)=$lb(rows, page,params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	s StartDate=$p(params,"^",1)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=$p(params,"^",3)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s PhLoc=$p(params,"^",5)
	s PhWardLoc=$p(params,"^",6)
	s PhdrStatus=$p(params,"^",7)
	s PhdrTypeStr=$p(params,"^",8)
	s ConnectNo=$p(params,"^",9)
	s PhrId=$s(ConnectNo'="":$o(^DHCINPHREQi(0,"DispLocConnectNo",PhLoc,ConnectNo,""),-1),1:"")
	s ConPhdr=$s(PhrId'="":$p(^DHCINPHREQ(PhrId),"^",9),1:"")
	q:(ConnectNo'="")&&(ConPhdr="") ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	S pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid("web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery")
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","GetInPhDrawDispList",pid)
	s n=0
	i ConPhdr="" d
	.f Date=StartDate:1:EndDate d
	..s phdrid=""
	..f  s phdrid=$o(^DHCPHDRAWi("LocDate",PhLoc,Date,phdrid))  q:phdrid=""  d
	...s n=..ConInPhDrawDispGlobal(phdrid,PhdrTypeStr,PhdrStatus,n,pid)
	..
	.
	e  d
	.s n=..ConInPhDrawDispGlobal(ConPhdr,PhdrTypeStr,PhdrStatus,n,pid)
	q:n=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(n) //输出空的json串
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartSign(n) //输出json前缀串
	;
	s count=0
	s h=""
	f  s h=$o(^TMP("DHCINPHA","web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","GetInPhDrawDispList",pid,h)) q:h=""  d
	.s mdata=^TMP("DHCINPHA","web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","GetInPhDrawDispList",pid,h)
	.s count = count+1
	.s Title1="TWardLocId^TWardLoc^TPhdrID^TPhdrNo^TPhdrDateComp"
	.s Title2="TPhdrUserComp"
	.s Title=Title1_"^"_Title2
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","GetInPhDrawDispList",pid)
	q ""
}

/// Description:构造药房待发护士取药备药单临时glboal
/// Creator:	hulihua
/// CreateDate:	2017-11-30
/// Table:      DHC_PHDraw
/// Input:		备药单ID、备药单状态、备药单类型、global条数、计数器
/// Output:		global条数
/// Return：    
/// w ##class(web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery).GetInPhDrawDispList("50","1","08/03/2017^00:00^12/04/2017^23:59^94^^30^2")
ClassMethod ConInPhDrawDispGlobal(phdrid, PhdrTypeStr, PhdrStatus, n, pid) As %String
{
	n (phdrid,PhdrTypeStr,PhdrStatus,n,pid)
	q:'$d(^DHCPHDRAW(phdrid)) n
	s phdrtype=$p(^DHCPHDRAW(phdrid),"^",4)
	q:PhdrTypeStr'=phdrtype n
	s phdrstatue=$p(^DHCPHDRAW(phdrid),"^",5)
	q:phdrstatue'=PhdrStatus n
	s wardlocid=$p(^DHCPHDRAW(phdrid),"^",3)
	s wardloc=$p(^CTLOC(wardlocid),"^",2)
	s phdrawno=$p(^DHCPHDRAW(phdrid),"^",1)
	s phdrdatecomp=$p(^DHCPHDRAW(phdrid),"^",11)
	s phdrdatecomp=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(phdrdatecomp)	//完成日期		
	s phdrtimecomp=$p(^DHCPHDRAW(phdrid),"^",12)
	s phdrtimecomp=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(phdrtimecomp)	//完成时间
	s phdrdatecomp=phdrdatecomp_" "_phdrtimecomp
	s phdrusercomp=$p(^DHCPHDRAW(phdrid),"^",7)				//完成人
	s phdrusercomp=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(phdrusercomp),"^",2)
	s n=n+1
	s data1=$g(wardlocid)_"^"_$g(wardloc)_"^"_$g(phdrid)_"^"_$g(phdrawno)_"^"_$g(phdrdatecomp)
	s data2=$g(phdrusercomp)
	s ^TMP("DHCINPHA","web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","GetInPhDrawDispList",pid,n)=data1_"^"_data2
	q n
}

/// Description:查询药房待发护士取药备药单明细列表
/// Creator:	hulihua
/// CreateDate:	2017-04-12
/// Table:      DHC_InPhReq、DHC_InPhReqItm
/// Input:		每页行数、页数、药房科室ID
/// Output:		备药单ID、备药单号、备药单日期、备药单时间、备药人
/// Return：    
/// w ##class(web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery).GetQueryDispList("50","1","953^30^^102^","total","")
ClassMethod GetQueryDispList(rows, page, params, querytype, ProcessId = "") As %String
{
	n (rows, page,params,querytype,ProcessId)
	//s ^hlh($h)=$lb(rows, page,params,querytype,ProcessId)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	i ProcessId'="" d
	.i querytype="total" d OutPutTotal
	.i querytype="detail" d OutPutDetail
	q:ProcessId'="" ""
	s pid=..PCHCOLLS(params)
	q:pid="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson() 
	s ProcessId=pid
	i querytype="total" d OutPutTotal
	i querytype="detail" d OutPutDetail
	q ""
OutPutTotal
	s count=0
	s WardLocID=""
	f  s WardLocID=$o(^TMP("DHCINPHA","web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","PCHCOLLS",ProcessId,"DispWard",WardLocID))  q:WardLocID=""  d
	.s h=""
	.f  s h=$o(^TMP("DHCINPHA","web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","PCHCOLLS",ProcessId,"DispWard",WardLocID,h)) q:h=""  d
	..s mdata=^TMP("DHCINPHA","web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","PCHCOLLS",ProcessId,"DispWard",WardLocID,h)
 	..s admDr=$p(h,"^",1)
 	..s OrdItmRowid=$p(h,"^",3)
 	..s PatNo=$p(mdata,"^",1)
 	..s DspQty=$p(mdata,"^",7)
 	..s TimeDosing=$p(mdata,"^",9)
 	..s Prescno=$p(mdata,"^",10)
 	..s ArcimDesc=$p(mdata,"^",12)
 	..s Generic=$p(mdata,"^",19)
	..i $f(Generic,"-") s Generic=$p(Generic,"-",2)
	..s Form=$p(mdata,"^",20)
	..s Spec=$p(mdata,"^",21)
	..s Manf=$p(mdata,"^",22)
	..s StkBin=$p(mdata,"^",23)
 	..s BedNo=$p(mdata,"^",27)
 	..s:BedNo="" BedNo="*"
 	..s PhdQty=$p(mdata,"^",28) 
 	..s Uom=$p(mdata,"^",29) 
 	..s DspBatch=$p(mdata,"^",31)
 	..s InciId=$p(mdata,"^",32)
 	..s CollStat=$p(mdata,"^",34)
 	..s RefuseQty=$p(mdata,"^",35)
 	..s CalDspQty=$p(mdata,"^",36)
 	..s ReturnQty=$s(RefuseQty=CalDspQty:0,1:CalDspQty)
 	..s ActDispQty=PhdQty-ReturnQty
    ..s tmpindex=ArcimDesc_","_InciId
	..;按药品汇总
	..i $d(^TMP("DHCINPHA","web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","GetQueryDispList",ProcessId,"TOTAL",tmpindex)) d
	...s $p(^TMP("DHCINPHA","web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","GetQueryDispList",ProcessId,"TOTAL",tmpindex),"^",2)=+$p(^TMP("DHCINPHA","web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","GetQueryDispList",ProcessId,"TOTAL",tmpindex),"^",2)+DspQty
	...s $p(^TMP("DHCINPHA","web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","GetQueryDispList",ProcessId,"TOTAL",tmpindex),"^",9)=+$p(^TMP("DHCINPHA","web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","GetQueryDispList",ProcessId,"TOTAL",tmpindex),"^",9)+PhdQty
	...s $p(^TMP("DHCINPHA","web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","GetQueryDispList",ProcessId,"TOTAL",tmpindex),"^",12)=+$p(^TMP("DHCINPHA","web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","GetQueryDispList",ProcessId,"TOTAL",tmpindex),"^",12)+CalDspQty
	...s $p(^TMP("DHCINPHA","web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","GetQueryDispList",ProcessId,"TOTAL",tmpindex),"^",13)=+$p(^TMP("DHCINPHA","web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","GetQueryDispList",ProcessId,"TOTAL",tmpindex),"^",13)+RefuseQty
	...s $p(^TMP("DHCINPHA","web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","GetQueryDispList",ProcessId,"TOTAL",tmpindex),"^",14)=+$p(^TMP("DHCINPHA","web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","GetQueryDispList",ProcessId,"TOTAL",tmpindex),"^",14)+ReturnQty
	...s $p(^TMP("DHCINPHA","web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","GetQueryDispList",ProcessId,"TOTAL",tmpindex),"^",15)=+$p(^TMP("DHCINPHA","web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","GetQueryDispList",ProcessId,"TOTAL",tmpindex),"^",15)+ActDispQty
	..e  d
	...s ^TMP("DHCINPHA","web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","GetQueryDispList",ProcessId,"TOTAL",tmpindex)=ArcimDesc_"^"_DspQty_"^"_Uom_"^"_Form_"^"_Spec_"^"_Manf_"^"_StkBin_"^"_Generic_"^"_PhdQty_"^"_ProcessId_"^"_CollStat_"^"_CalDspQty_"^"_RefuseQty_"^"_ReturnQty_"^"_ActDispQty
	..
	.
	
	s tmpindex=""
	f  s tmpindex=$o(^TMP("DHCINPHA","web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","GetQueryDispList",ProcessId,"TOTAL",tmpindex)) q:tmpindex=""  d
 	.s mdata=^TMP("DHCINPHA","web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","GetQueryDispList",ProcessId,"TOTAL",tmpindex)
	.s:($p(mdata,"^",12)'=0)&&(($p(mdata,"^",13)'=0))&&($p(mdata,"^",14)=0) $p(mdata,"^",11)="拒撤互抵"
	.s:($p(mdata,"^",12)'=0)&&(($p(mdata,"^",13)'=0))&&($p(mdata,"^",14)'=0) $p(mdata,"^",11)="撤销加拒绝"
	.s:($p(mdata,"^",12)'=0)&&(($p(mdata,"^",13)=0))&&($p(mdata,"^",14)'=0) $p(mdata,"^",11)="仅撤销"
	.s:($p(mdata,"^",12)=0)&&(($p(mdata,"^",13)'=0))&&($p(mdata,"^",14)=0) $p(mdata,"^",11)="仅拒绝"
	.s DispCollStat=$p(mdata,"^",11)
	.s index=$s(DispCollStat["撤销":0,DispCollStat["互抵":1,DispCollStat["仅拒绝":2,1:3)_","_tmpindex
	.M ^TMP("DHCINPHA","web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","GetQueryDispList",ProcessId,"INDEXTOTAL",index)=mdata
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","GetQueryDispList",ProcessId,"TOTAL")
	
	s count=0
	s tmpindex=""
	f  s tmpindex=$o(^TMP("DHCINPHA","web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","GetQueryDispList",ProcessId,"INDEXTOTAL",tmpindex)) q:tmpindex=""  d
 	.s mdata=^TMP("DHCINPHA","web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","GetQueryDispList",ProcessId,"INDEXTOTAL",tmpindex)
	.s count = count+1
	.s Title1="TDesc^TDspQty^TUom^TDrugForm^TSpec"
	.s Title2="TManf^TStkBin^TGeneric^TPhdQty^TPID"
	.s Title3="TCollStat^TCalDspQty^TRefuseQty^TReturnQty^TActDispQty"
	.s Title=Title1_"^"_Title2_"^"_Title3
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonRowSign()
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
   	i count>0 d
	.w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndStringJqGrid(count,rows)
	e  d
	.w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	//d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","GetQueryDispList",ProcessId,"INDEXTOTAL")
	q ""
	
OutPutDetail
	s count=0
	s WardLocID=""
	f  s WardLocID=$o(^TMP("DHCINPHA","web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","PCHCOLLS",ProcessId,"DispWard",WardLocID))  q:WardLocID=""  d
	.s h=""
	.f  s h=$o(^TMP("DHCINPHA","web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","PCHCOLLS",ProcessId,"DispWard",WardLocID,h)) q:h=""  d
	..s mdata=^TMP("DHCINPHA","web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","PCHCOLLS",ProcessId,"DispWard",WardLocID,h)
	..s:($p(mdata,"^",35)=$p(mdata,"^",36))&&($p(mdata,"^",34)["撤销") $p(mdata,"^",34)="拒撤互抵"
	..s count = count+1
	..s Title1="TPatNo^TPatName^TPatSex^TPatAge^TDiagnose"
	..s Title2="TWardLoc^TDspQty^TDataDosing^TTimeDosing^TPrescNo"
	..s Title3="TCookType^TArcimDesc^TPriorty^TDoseQty^TFreq"
	..s Title4="TInstruction^TDuration^TOrdAuditResult^TGeneric^TForm"
	..s Title5="TSpec^TManf^TStkBin^TUserAdd^TSkinTest"
	..s Title6="TAdmLoc^TBedNo^TPhdQty^TUom^TOrdStatus"
	..s Title7="TDspBatch^^^TCollStat^TRefuseQty"
	..s Title8="TCancelQty^TActDispQty"
	..s Title=Title1_"^"_Title2_"^"_Title3_"^"_Title4_"^"_Title5_"^"_Title6_"^"_Title7_"^"_Title8
	..q:(count<Start)||(count>End)
	..I count=Start d
	...w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonRowSign()
	...w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	..e  d
	...w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
   	i count>0 d
	.w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndStringJqGrid(count,rows)
	e  d
	.w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	q ""
}

/// Description:整理病区护士取药待发药信息,直接从请领表检索数据
/// Creator:	hulihua
/// CreateDate:	2017-04-12
/// Table:      DHC_PHDraw、DHC_PHDrawInc、DHC_PHDrawOrder
/// Input:		每页行数、页数、药房科室ID
/// Output:		请领单ID串^请领单状态^药品名称^药房科室
/// Return：	计数器值    
/// w ##class(web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery).PCHCOLLS("345^30^^94^")
ClassMethod PCHCOLLS(params As %String) As %Integer
{
	n (params)
	//s ^hlh($h)=params	
	s phdridstr=$p(params,"^",1)
	s PhdrStatus=$p(params,"^",2)
	s InciDr=$p(params,"^",3)
	s PhLoc=$p(params,"^",4)
	s RegNo=$p(params,"^",5)
	s n=0
	S pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid("web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery")
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","PCHCOLLS",pid,"DispWard")
	s cnt=$l(phdridstr,"#")
	f i=1:1:cnt d
 	.s phdrid=$p(phdridstr,"#",i) 
 	.s WardLocID=$p(^DHCPHDRAW(phdrid),"^",3)
 	.s WardLoc=$p(^CTLOC(WardLocID),"^",2)
 	.s phdrch=""
 	.f  s phdrch=$o(^DHCPHDRAW(phdrid,"INC",phdrch))  q:phdrch=""  d
 	..s phdricompflag=$p(^DHCPHDRAW(phdrid,"INC",phdrch),"^",5)
 	..q:phdricompflag'="Y"									//备药未完成的过滤
 	..s Inci=$p(^DHCPHDRAW(phdrid,"INC",phdrch),"^",1) 
 	..q:Inci="" 
 	..q:(InciDr'="")&&(Inci'=InciDr)
 	..s UomId=$p(^DHCPHDRAW(phdrid,"INC",phdrch),"^",4)
	..s Uom=$p(^CT("UOM",UomId),"^",2) 
 	..s phdrsub=0
 	..f  s phdrsub=$o(^DHCPHDRAW(phdrid,"INC",phdrch,"ORDER",phdrsub))  q:phdrsub=""  d
 	...s DspBatchId=$p(^DHCPHDRAW(phdrid,"INC",phdrch,"ORDER",phdrsub),"^",1)
 	...s DspId=+DspBatchId
 	...s PhdrawOrder=phdrid_"||"_phdrch_"||"_phdrsub
 	...s InPhReqDr=$p(^DHCPHDRAW(+phdrid,"INC",phdrch,"ORDER",phdrsub),"^",5)
 	...s DispFlag=##class(web.DHCINPHA.MTCommon.PublicServiceMethod).GetDispFlag(DspId,InPhReqDr)
 	...;如果一个打包记录有未发的子表则需要将已发的全部撤销！
 	...s:(DispFlag=1)&&($D(^DHCOEDISQTYi("DSPBStatus","TC",DspId))) DispFlag=0	
 	...s CollStat=$s(DispFlag=0:"仅撤销",1:"")
 	...s phdrefflag=$p(^DHCPHDRAW(phdrid,"INC",phdrch,"ORDER",phdrsub),"^",3)
	...//q:phdrefflag="Y"   //拒绝备药的数量也要加上（382427）
	...s PhdQty=$p(^DHCPHDRAW(phdrid,"INC",phdrch,"ORDER",phdrsub),"^",2)
	...s RefuseQty=$s(phdrefflag="Y":PhdQty,1:0)				//拒绝数量
	...s CancelQty=$s(DispFlag=0:PhdQty,1:0)					//撤销数量
	...s:phdrefflag="Y" PhdQty=0
	...i (CollStat="")&&(phdrefflag="Y")  d
	....s CollStat="仅拒绝"
	...e  i (CollStat="仅撤销")&&(phdrefflag="Y")  d
	....s CollStat="撤销加拒绝"
	...s ActDispQty=$s(PhdQty'=0:PhdQty-RefuseQty-CancelQty,1:0)
 	...s OrdItmRowid=$p(^DHCOEDISQTY(DspId),"^",1)     			//OE_OrdItem表指针
 	...s OrdExeRowid=$p(^DHCOEDISQTY(DspId),"^",3)     			//OE_OrdExec表指针 
 	...s admDr=$p(^DHCOEDISQTY(DspId),"^",26)
 	...s AdmWard=$p(^PAADM(admDr),"^",70)  						//病人当前病房   
 	...s Ord=+OrdExeRowid
 	...s Chl=$p(OrdExeRowid,"||",2)
 	...s OreChl=$p(OrdExeRowid,"||",3)
 	...s OrderStatusDr=$p(^OEORD(Ord,"I",Chl,"X",OreChl,"BILL"),"^",1)  //医嘱状态
 	...s OeFlag=$p(^OEC("OSTAT",OrderStatusDr),"^",1)          	//医嘱核实、未核实、停止状态
 	...s:('$d(^OEORD(Ord,"I",Chl,"X",OreChl,"BILL")))&&(OeFlag="V") OeFlag="核实" 
 	...s WardId="",BedNo=""
 	...f  s WardId=$o(^PAWARD(0,"WARD_LocationDR",WardLocID,WardId))  q:WardId=""  d
 	....i WardId=AdmWard d
 	.....s BedId=$p(^PAADM(admDr),"^",73)						//未转病区则取当前床位，转病区则床号为空
 	.....s BedNo=$s(BedId'="":$p($g(^PAWARD($p(BedId,"||",1),"BED",$p(BedId,"||",2))),"^",1),1:"")  //病人床号
 	...s DepLoc=$p(^DHCOEDISQTY(DspId),"^",23)			 		//病人所在科室 
 	...s AdmLocDesc=$p(^CTLOC(DepLoc),"^",2)                                      	
 	...s DspQty=##class(web.DHCSTCOMMONSRV).GetDspInciQtyByDsp(DspId,+Inci) //$p(^DHCOEDISQTY(DspId),"^",11)   				//本顿发药数
 	...s DataDosing=$p(^DHCOEDISQTY(DspId),"^",21)  				//分发日期
 	...s TimeDosing=$p(^DHCOEDISQTY(DspId),"^",20)  				//分发时间
 	...s ConfirmFlag=$p($g(^DHCOEDISQTY(DspId)),"^",17)
 	...s:DataDosing'="" DataDosing=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(DataDosing,"IP")
 	...s:TimeDosing'="" TimeDosing=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(TimeDosing,"IP")
 	...//病人信息
 	...s patInfo=##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetPatInfo(admDr)
 	...s PatNo=$p(patInfo,"^",1)
 	...q:(RegNo'="")&&(RegNo'=PatNo)
 	...s PatName=$p(patInfo,"^",3)
 	...s PatSex=$p(patInfo,"^",4)
 	...s PatAge=$p(patInfo,"^",5)
 	...s Diagnodesc=$p(patInfo,"^",9)
	...//医嘱明细信息
 	...s OrdInfo=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetOrdInfo(OrdItmRowid)
 	...s Prescno=$p(OrdInfo,"^",1)
	...s CookType=$p(OrdInfo,"^",2)                               
	...s ArcimDesc=$p(OrdInfo,"^",3)
	...s Priorty=$p(OrdInfo,"^",4) 								
	...s DoseQty=$p(OrdInfo,"^",5) 
	...s Freq=$p(OrdInfo,"^",6) 
	...s Instru=$p(OrdInfo,"^",7)
	...s Duration=$p(OrdInfo,"^",8)
	...s OrdAuditResult=$p(OrdInfo,"^",9)
	...s Generic=$p(OrdInfo,"^",10)
	...s Form=$p(OrdInfo,"^",11)   							
	...s Spec=$p(OrdInfo,"^",12)       						
	...s Manf=$p(OrdInfo,"^",13)     							
	...s StkBin=$p(OrdInfo,"^",14)        						
	...s UserAdd=$p(OrdInfo,"^",15)        						
	...s SkinTest=$p(OrdInfo,"^",16)	
	...s data1=PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_Diagnodesc			
	...s data2=WardLoc_"^"_DspQty_"^"_DataDosing_"^"_TimeDosing_"^"_Prescno			//10
	...s data3=CookType_"^"_ArcimDesc_"^"_Priorty_"^"_DoseQty_"^"_Freq
	...s data4=Instru_"^"_Duration_"^"_OrdAuditResult_"^"_Generic_"^"_Form			//20
	...s data5=Spec_"^"_Manf_"^"_StkBin_"^"_UserAdd_"^"_SkinTest
	...s data6=AdmLocDesc_"^"_BedNo_"^"_PhdQty_"^"_Uom_"^"_OeFlag					//30
	...s data7=DspBatchId_"^"_Inci_"^"_PhLoc_"^"_CollStat_"^"_RefuseQty
	...s data8=CancelQty_"^"_ActDispQty					
	...s data=data1_"^"_data2_"^"_data3_"^"_data4_"^"_data5_"^"_data6_"^"_data7_"^"_data8
	...s j=admDr_"^"_OrdItmRowid_"^"_DataDosing_"^"_DspBatchId_"^"_PhdrawOrder		//为了后面存发药孙表的方便不再合并 
	...s n=n+1
	...s ^TMP("DHCINPHA","web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","PCHCOLLS",pid,"DispWard",WardLocID,j)=data
	...
	..
	.
	q:n>0 pid
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","PCHCOLLS",pid,"DispWard")
	q ""
}

/// Description:护士领药点击发药之后处理发药相关的表结构
/// Creator:	hulihua
/// CreateDate:	2017-04-13
/// Table:      DHC_PHACollected--住院发药主表、DHC_PHACollectItm--住院发药子表、DHC_PhaCollectItmLB--住院发药孙表
/// Input:		每页行数、页数、药房科室ID
/// Output:		请领单ID串^请领单状态^药品名称^药房科室
/// Return：	计数器值    
/// w ##class(web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery).SaveDispData("813","114","94^6^6^22/03/2017^22/04/2017^2","16")
ClassMethod SaveDispData(pid As %String, WardLocID As %String, params As %String, wardphdrstr As %String) As %String
{
	n (pid,WardLocID,params,wardphdrstr)
	//s ^hlh($h)=$lb(pid,WardLocID,params,wardphdrstr)
	q:WardLocID="" ""
	s PhacLoc=$p(params,"^",1)
	s PhacUser=$p(params,"^",2)
	s TakeDrugUser=$p(params,"^",3)
	s PhacDateFrom=$p(params,"^",4)
	s PhacDateFrom=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(PhacDateFrom)
	s PhacDateTo=$p(params,"^",5)
	s PhacDateTo=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(PhacDateTo)
	s PhacType=$p(params,"^",6)
	s PhacRowid="",ret=0,j=0,Err=0,t=0,n=0
	s $ZT="Error^DHCSTERROR"
	tstart
	s SubStr=""
	f  s SubStr=$o(^TMP("DHCINPHA","web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","PCHCOLLS",pid,"DispWard",WardLocID,SubStr))  q:(SubStr="")||(Err'=0)  d
	.s admDr=$p(SubStr,"^",1)
 	.s OrdItmRowid=$p(SubStr,"^",2)
 	.s DateDosing=$p(SubStr,"^",3)
 	.s WardRowid=$o(^PAWARD(0,"WARD_LocationDR",WardLocID,""))
 	.s DataStr=^TMP("DHCINPHA","web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","PCHCOLLS",pid,"DispWard",WardLocID,SubStr)
 	.s DspBatch=$p(SubStr,"^",4)
 	.s PhdrawOrder=$p(SubStr,"^",5)
 	.q:+PhdrawOrder'=wardphdrstr
	.i PhacRowid=""  d
	..s listdata=PhacLoc_"^"_WardRowid_"^"_wardphdrstr_"^"_PhacDateFrom_"^"_PhacDateTo_"^"_PhacType_"^"_TakeDrugUser
	..s PhacRowid=##class(web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp).CreatePhaCollected(listdata)	//生成发药主表记录			
	.s:PhacRowid="" Err=""																				
	.q:PhacRowid="" 																				//主表插入失败  
	.s Ret=..SaveDispDetail(PhacRowid,DspBatch,OrdItmRowid,wardphdrstr,PhdrawOrder,"0")
	.s Err=$p(Ret,"^",1)
	.q:Err'=0
	.s DelFlag=$p(Ret,"^",2)
	.s:DelFlag="" j=j+1
	.s:DelFlag'="" t=t+1
	.s n=n+1
	;n=t 即为全部拒撤互抵的情况
	i (j=0)&&(PhacRowid'="") d
	.s ret=##class(web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp).DelPhaCollected(PhacRowid)			//明细保存不成功则删除主表
	i (j=0)&&(n'=t) tro
	q:(j=0)&&(n'=t) Err
	i (PhacRowid'>0)&&(n'=t) tro
	q:(PhacRowid'>0)&&(n'=t) PhacRowid
	;修改发药主表状态
	i n'=t d 
	.s ret=##class(web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp).Collect(PhacRowid,PhacUser)
	i ret'=0 tro
	q:ret'=0 ""
	i n=t d
	.s listdata="^"_wardphdrstr_"^"_WardLocID_"^0" 	
	e  d		
	.s listdata=PhacRowid_"^"_wardphdrstr_"^"_WardLocID_"^0"
	s Err=##class(web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp).UpdatePHDraw(listdata)
	i Err="" tro					
	q:Err="" Err 
	tcommit
	;发药完成之后K掉global
	d ..KillTmp(pid)	
	;发药后立即做账单      																			
	s:n'=t ret=##class(web.DHCSTPCHCOLLS).MakeBill(PhacRowid)										
	q PhacRowid
}

/// Description:处理发药明细等相关信息
/// Creator:	hulihua
/// CreateDate:	2017-04-14
/// Table:      DHC_PHACollectItm、DHC_PhaCollectItmLB、DHC_OEDispensing、DHC_PHDrawOrder、DHC_INTRANS
/// Input:		phac-发药主表ID、dhcoedis-备药孙表对应的dsp、oeori-备药孙表对应的医嘱ID、wardphdrstr-备药单ID串、phdrsubid-备药孙表ID、DispType-发药模式（0-PC端,1-移动端）
/// Output:		
/// Return：	0-成功，非0-失败  
/// w ##class(web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery).SaveDispDetail("640","20405||1","418||64","155","0")
ClassMethod SaveDispDetail(phac As %String, dspbatch As %String, oeori As %String, wardphdrstr As %String, phdrsubid As %String, DispType As %String) As %String
{
	n (phac,dspbatch,oeori,wardphdrstr,phdrsubid,DispType)
	q:dspbatch="" ""
	s ord=$p(oeori,"||",1),itm=$p(oeori,"||",2)
	q:'$d(^OEORD(ord,"I",itm)) ""
	s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) 
	q:arcim="" ""
	s dspId=+dspbatch
	q:dspId="" ""
	s dspSubId=$p(dspbatch,"||",2)
	q:+dspSubId=0 ""
	q:'$d(^DHCOEDISQTY(dspId,"I",dspSubId)) ""
	s recloc=$p($g(^DHCOEDISQTY(dspId)),"^",24)
	q:recloc="" ""
	s HospID=$p(^CTLOC(recloc),"^",22)
	s InPhReqDr=$p(^DHCPHDRAW(+phdrsubid,"INC",$p(phdrsubid,"||",2),"ORDER",$p(phdrsubid,"||",3)),"^",5)
	s DispFlag=##class(web.DHCINPHA.MTCommon.PublicServiceMethod).GetDispFlag(dspId,InPhReqDr)
	;如果一个打包记录有未发的子表则需要将已发的全部撤销！ 
	s:(DispFlag=1)&&($D(^DHCOEDISQTYi("DSPBStatus","TC",dspId))) DispFlag=0		  													
	s errCode=0,delflag=""
	s pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid($this)
	i $$Lock()<0  q -1   								//加锁
	s $ZT="Error^DHCSTERROR"						//增加错误处理
	tstart
	s inci=$p(^DHCOEDISQTY(dspId,"I",dspSubId),"^",5)																
	;不可发的配药记录串改孙表状态加库存删台帐
	i DispFlag'=1 d
	.s listdata=phdrsubid_"^"_dspbatch_"^"_pid
	.s ret=##class(web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp).HandleCalDsp(listdata)
	.i ret'=0 trollback  d Unlock s errCode=-2
	.q:errCode'=0
	.s delflag=1 
	e  d
	.s confstr=##class(web.DHCINPHA.MTCommon.PublicServiceMethod).GetDspPhdrQty(wardphdrstr,dspbatch)
	.s confqty=$p(confstr,"^",1)
	.i confqty=0 trollback  d Unlock s errCode=-3
	.q:errCode'=0 
	.;保存发药子表
	.s phach=$o(^DHCPHACi("PHADSPDR",dspId,phac,""),-1)
	.i phach="" d
	..s listdata=phac_"^"_oeori_"^"_dspId
	..s phaci=##class(web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp).InsPhacItm(listdata) 			//生成发药记录
	.e  d
	..s phaci=phac_"||"_phach
	.i phaci="" trollback  d Unlock s errCode=-4
	.q:errCode'=0
	.i DispType=1 d ##class(web.DHCINPHA.MTCommon.PublicServiceMethod).MakeBillPhaci(phaci)
	.;更新备药孙表
	.s phdrsubidstr=$p(confstr,"^",2)
	.s listdata=phaci_"^"_phdrsubidstr
	.s ret=##class(web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp).UpdatePHDrawOrder(listdata)
	.i ret="" trollback  d Unlock s errCode=-5
	.q:errCode'=0   																				//更新备药孙表
	.;保存发药批次表
	.s cnt=##class(web.DHCINPHA.MTCommon.PublicServiceMethod).GetInclbQty(phdrsubidstr,pid)
	.i cnt<=0 trollback  d Unlock  s errCode=-6
	.q:errCode'=0
	.s newclb=""
	.f  s newclb=$o(^TMP("DHCINPHA","web.DHCINPHA.MTCommon.PublicServiceMethod","GetInclbQty",pid,"INCLB",newclb)) q:(newclb="")!(errCode'=0)  d
	..s inclb=newclb
	..s data=^TMP("DHCINPHA","web.DHCINPHA.MTCommon.PublicServiceMethod","GetInclbQty",pid,"INCLB",newclb)
	..s qty=$p(data,"^",1)
	..s qty=-qty
	..s sp=$p(data,"^",2)
	..s spamt=$p(data,"^",3)
	..s spamt=-spamt
	..s rp=$p(data,"^",4)
	..s rpamt=$p(data,"^",5)
	..s rpamt=-rpamt
	..s listdata=phaci_"^"_inclb_"^"_qty_"^"_sp_"^"_spamt_"^"_rp_"^"_rpamt_"^"_dspbatch
	..s phacil=##class(web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp).InsPhacItmLB(listdata)			//生成发药批次记录
	..i phacil="" trollback  d Unlock  s errCode=-7 
	..q:errCode'=0
	..s intr=$p(data,"^",6)
	..s listdata=intr_"^"_phacil
	..;更新台帐表
	..s ret=##class(web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp).UpdateIntrans(listdata)
	..i ret="" trollback  d Unlock  s errCode=-8
	.q:errCode'=0
	.;更新打包表
	.S dspBatId=0,phacsub="",i=0,j=0
	.F  S dspBatId=$o(^DHCOEDISQTYi("DSPBStatus","C",dspId,dspBatId)) Q:dspBatId=""  D
	..s i=i+1
	.F  S phacsub=$O(^DHCPHAC(+phaci,"I",$P(phaci,"||",2),"B",phacsub))  Q:phacsub=""  D
	..s j=j+1
	.i i=j  d	
	..s ret=##class(web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp).UpdStatusForDODISS(phaci,dspId)
	..i ret<0 trollback  d Unlock s errCode=-9
	.
	q:errCode'=0 errCode 
	tcommit
	d Unlock
	q 0_"^"_delflag
	
Lock()
	l +^DHCINPHAHandleStock(dspId,"UDBL",dspSubId):5  e  q -1
	q 0

Unlock
	l -^DHCINPHAHandleStock(dspId,"UDBL",dspSubId)  ;去锁
	k ^TMP("DHCINPHA","web.DHCINPHA.MTCommon.PublicServiceMethod","GetInclbQty",pid)
	q
}

/// Description:装箱核对之前处理发药相关的表结构(移动端调用)
/// Creator:	hulihua
/// CreateDate:	2017-04-19
/// Table:      DHC_PHACollected--住院发药主表、DHC_PHDraw--备药单主表
/// Input:		WardLocID-病区科室ID、params-药房科室ID^装箱核对人ID^类型、wardphdrstr-备药单ID串
/// Output:		
/// Return：	发药主表ID   
/// w ##class(web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery).SaveSendDispData("501","369","94^1^6^20/03/2017^20/04/2017^2","73")
ClassMethod SaveSendDispData(WardLocID As %String, params As %String, wardphdrstr As %String) As %String
{
	n (WardLocID,params,wardphdrstr)
	//s ^hlh($h)=$lb(WardLocID,params,wardphdrstr)
	q:WardLocID="" ""
	s PhacLoc=$p(params,"^",1)
	s PhacUser=$p(params,"^",2)
	s PhacType=$p(params,"^",3)
	s len=$l(wardphdrstr,"#")
	s fromwardphdr="",towardphdr=""
	f j=1:1:len  d
	.s wardphdr=$p(wardphdrstr,"#",j)
	.s fromwardphdr=$s(fromwardphdr="":wardphdr,fromwardphdr<wardphdr:fromwardphdr,1:wardphdr)
	.s towardphdr=$s(towardphdr="":wardphdr,towardphdr>wardphdr:towardphdr,1:wardphdr)
	s PhacDateFrom=$p(^DHCPHDRAW(fromwardphdr),"^",11)
	s PhacDateTo=$p(^DHCPHDRAW(towardphdr),"^",11)
	s WardRowid=$o(^PAWARD(0,"WARD_LocationDR",WardLocID,""))
	s PhacRowid=..CheckPhdrPhac(wardphdrstr)
	;生成发药主表记录
	i PhacRowid=""  d
	.s listdata=PhacLoc_"^"_WardRowid_"^"_wardphdrstr_"^"_PhacDateFrom_"^"_PhacDateTo_"^"_PhacType_"^"
	.s PhacRowid=##class(web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp).CreatePhaCollected(listdata)	
	q:PhacRowid="" -1
	;更新备药主表记录 			
	s listdata=PhacRowid_"^"_wardphdrstr_"^"_WardLocID_"^1"
	s Err=##class(web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp).UpdatePHDraw(listdata)					
	q:Err="" -2										
	q PhacRowid
}

/// Description:装箱核对过程中处理发药子表、孙表、账单、台帐表、库存表、备药孙表等(移动端调用)
/// Creator:	hulihua
/// CreateDate:	2017-04-19
/// Table:      DHC_PHACollectItm、DHC_PhaCollectItmLB、DHC_INTRANS、DHC_PHDrawOrder
/// Input:		phac-发药主表ID、phdrsubid-备药孙表ID
/// Output:		
/// Return：	0-成功、非0-失败
/// w ##class(web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery).SaveSendDispDetail("231465","50392||3||1")
ClassMethod SaveSendDispDetail(phac As %String, phdrsubid As %String) As %String
{
	n (phac,phdrsubid)
	q:phdrsubid="" -1
	s phdr=+phdrsubid
	s phdrch=+$p(phdrsubid,"||",2)
	s phdrsub=+$p(phdrsubid,"||",3)	
	q:'$d(^DHCPHDRAW(phdr,"INC",phdrch,"ORDER",phdrsub)) -2
	s RefFlag=$p(^DHCPHDRAW(phdr,"INC",phdrch,"ORDER",phdrsub),"^",3)
	q:'$d(^DHCINTR(0,"TypePointer","L",phdrsubid))&&(RefFlag="Y") 0		//未减库存的拒绝备药孙表记录在装箱核对的时候不需要增加库存！
	s dspbatch=$p(^DHCPHDRAW(phdr,"INC",phdrch,"ORDER",phdrsub),"^",1)
	q:dspbatch="" -3
	s oeori=$p(^DHCOEDISQTY(+dspbatch),"^",1)
	s wardphdrstr=+phdrsubid
	s result=..SaveDispDetail(phac,dspbatch,oeori,wardphdrstr,phdrsubid,"1")
	s ret=$p(result,"^",1)
	q:ret'=0 ret
	q 0
}

/// Description:装箱核对之后更新发药主表(移动端调用)
/// Creator:	hulihua
/// CreateDate:	2017-04-19
/// Table:      DHC_PHACollected--住院发药主表
/// Input:		发药主表ID、装箱核对人、送药人
/// Output:		
/// Return：	0-成功
/// w ##class(web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery).UpdatePhac("501","369","73")
ClassMethod UpdatePhac(PhacRowid As %String, PhacUser As %String, SendUser As %String) As %String
{
	n (PhacRowid,PhacUser,SendUser)
	s ret=##class(web.DHCINPHA.MTTakeDrugDisp.SqlDbDrugDisp).Collect(PhacRowid,PhacUser,SendUser)
	q ret
}

/// Description:获取某备药串中属于该病区科室的备药串
/// Creator:	hulihua
/// CreateDate:	2017-04-14
/// Table:      CT_Antibiotics,DHC_Antibiotics
/// Input:		WardLocId-病区科室ID,PhdrRowidStr-需要检查的备药串
/// Output:
/// Return：    属于该科室病区的备药串
/// Others:
/// w ##class(web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery).GetWardPhdrStr("118","72#73#74#75#76#77#78#79#80")
ClassMethod GetWardPhdrStr(WardLocId As %String, PhdrRowidStr As %String) As %String
{
	n (WardLocId, PhdrRowidStr)
	s WardPhdrStr=""
	s len=$l(PhdrRowidStr,"#")
	f j=1:1:len d
	.s PhdrRowid=$p(PhdrRowidStr,"#",j)
	.s WardLoc=$p(^DHCPHDRAW(PhdrRowid),"^",3)
	.q:WardLoc'=WardLocId
	.s WardPhdrStr=$S(WardPhdrStr="":PhdrRowid,1:WardPhdrStr_"#"_PhdrRowid)
	q WardPhdrStr
}

/// Description:检查某次装箱核对是否已经存在发药主表
/// Creator:	hulihua
/// CreateDate:	2017-04-19
/// Table:      DHC_PHDraw备药单主表
/// Input:		PhdrRowidStr-某次装箱核对的备药主表串
/// Output:
/// Return：    ""-没有，>0-存在的发药主表
/// Others:		对于多个备药单一起核对的取第一个备药单的第一个发药主表ID进行合并
/// w ##class(web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery).CheckPhdrPhc("72#73#74#75#76#77#78#79#80")
ClassMethod CheckPhdrPhac(PhdrRowidStr As %String) As %String
{
	n (PhdrRowidStr)
	q:PhdrRowidStr="" ""
	s PhacRowid=0
	s len=$l(PhdrRowidStr,"#")
	f j=1:1:len q:PhacRowid'=0  d
	.s PhdrRowid=$p(PhdrRowidStr,"#",j)
	.s PhacRowid=+$p(^DHCPHDRAW(PhdrRowid),"^",17)
	s:PhacRowid=0 PhacRowid=""
	q PhacRowid
}

/// Description:Kill临时global
/// Creator:	hulihua
/// CreateDate:	2017-04-27
/// Table:      
/// Input: 		pid-计数器     
/// Output:		
/// Return：
/// w ##class(web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery).ClearTmp()
ClassMethod KillTmp(pid)
{
	n (pid)
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery","PCHCOLLS",pid,"DispWard")
	q ""
}

/// Description:检查扫描出的固化标签是否已经备药
/// Creator:	hulihua
/// CreateDate:	2017-06-08
/// Table:      
/// Input: 		connectno-固化单号     
/// Output:		
/// Return：
/// w ##class(web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery).CheckConnectNo()
ClassMethod CheckConnectNo(ConnectNo As %String, PhLoc As %String) As %String
{
	n (ConnectNo,PhLoc)
	q:ConnectNo="" 0
	s PhrId=$s(ConnectNo'="":$o(^DHCINPHREQi(0,"DispLocConnectNo",PhLoc,ConnectNo,""),-1),1:"")
	s ConPhdr=$s(PhrId'="":$p(^DHCINPHREQ(PhrId),"^",9),1:"")
	q ConPhdr
}

Storage Default
{
<Data name="InPhDrawDispQueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCINP2D46.InPhDrawDis85EDD</DataLocation>
<DefaultData>InPhDrawDispQueryDefaultData</DefaultData>
<IdLocation>^web.DHCINP2D46.InPhDrawDis85EDD</IdLocation>
<IndexLocation>^web.DHCINP2D46.InPhDrawDis85EDI</IndexLocation>
<StreamLocation>^web.DHCINP2D46.InPhDrawDis85EDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
