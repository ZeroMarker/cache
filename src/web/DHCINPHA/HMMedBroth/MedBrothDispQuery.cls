/// Description:揭药室查询相关
/// Creator:    hulihua
/// CreateDate: 2017-08-25
/// Table:      DHC_PhaMedBroth-揭药主表、DHC_PhaMedBrothItm-揭药子表
Class web.DHCINPHA.HMMedBroth.MedBrothDispQuery Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Description:查询所有需要揭药的病区科室
/// Creator:	hulihua
/// CreateDate:	2017-08-25
/// Table:      DHC_PhaMedBroth-揭药主表、DHC_PhaMedBrothItm-揭药子表
/// Input:		每页行数、页数、药房科室ID^病区ID
/// Output:		病区ID、病区名称
/// Return：    
/// Others:
/// w ##class(web.DHCINPHA.HMMedBroth.MedBrothDispQuery).GetMedBrothWardList("1","50","18/08/2017^21/09/2017^88^")
ClassMethod GetMedBrothWardList(page, rows, params) As %Library.String
{
	n (page, rows, params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	s StartDate=$p(params,"^",1)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=$p(params,"^",2)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s PhLocId=$p(params,"^",3)
	s WardLocId=$p(params,"^",4)
	s phLocHospId=$p($g(^CTLOC(PhLocId)),"^",22)
	s UncovMedFlag="N"
	S pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid($this)
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"GetMedBrothWardList",pid,"MedBrothWard")
	s n=0
	f Date=StartDate:1:EndDate d
	.s WardLoc=""
	.f  s WardLoc=$o(^DHCPHAMEDBi("ComFlagDateWardLoc",UncovMedFlag,Date,WardLoc))  q:WardLoc=""  d
	..s PhmbID=""
	..f  s PhmbID=$o(^DHCPHAMEDBi("ComFlagDateWardLoc",UncovMedFlag,Date,WardLoc,PhmbID))  q:PhmbID=""  d
	...s AdmDr=$p(^DHCPHAMEDB(PhmbID),"^",2)
	...s AdmWard=$p(^PAADM(AdmDr),"^",70)  			;病人当前所在的病区
	...s AdmWardLoc=$p(^PAWARD(AdmWard),"^",5)
	...q:(WardLocId'="")&&(AdmWardLoc'=WardLocId)
	...s admLocHospId=$p(^CTLOC(AdmWardLoc),"^",22)
	...q:(phLocHospId'="")&&(admLocHospId'=phLocHospId)
	...s prescNo=$p(^DHCPHAMEDB(PhmbID),"^",4)
	...q:(##class(PHA.DEC.Com.Method).GetCompleteFlag(prescNo) '= "Y")
	...s ord=$o(^OEORD(0,"PrescNo",prescNo,""))
	...q:ord="" 
	...s itm=$o(^OEORD(0,"PrescNo",prescNo,ord,""))
	...s oeoriId=ord_"||"_itm
	...s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeoriId,""),-1)
	...s dspStatue=$p($g(^DHCOEDISQTY(dspId)),"^",7)
	...q:dspStatue="R"
	...;构造明细临时global
	...s PhmbCh=""
	...f  s PhmbCh=$o(^DHCPHAMEDBi("ComFlagDateWardLoc",UncovMedFlag,Date,WardLoc,PhmbID,PhmbCh))  q:PhmbCh=""  d
	....s ^TMP("DHCINPHA",$this,"GetMedBrothWardList",pid,"MedBrothDetail",AdmWardLoc,PhmbID,PhmbCh)=""
	...;构造病区临时global
	...q:$d(^TMP("DHCINPHA",$this,"GetMedBrothWardList",pid,"MedBrothWard",AdmWardLoc))
	...s WardLocDesc=$p(^CTLOC(AdmWardLoc),"^",2)
	...s n=n+1
	...s ^TMP("DHCINPHA",$this,"GetMedBrothWardList",pid,"MedBrothWard",AdmWardLoc)=WardLocDesc
	..
	.
	q:n=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(n) //输出空的json串
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartSign(n) //输出json前缀串
	
	s WardLoc="",count=0
	f  s WardLoc=$o(^TMP("DHCINPHA",$this,"GetMedBrothWardList",pid,"MedBrothWard",WardLoc))  q:WardLoc=""  d
	.s WardLocDesc=^TMP("DHCINPHA",$this,"GetMedBrothWardList",pid,"MedBrothWard",WardLoc)
	.s mdata=WardLoc_"^"_WardLocDesc_"^"_pid
	.s count = count+1
	.s Title="TWardLocId^TWardLoc^TPid"
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"GetMedBrothWardList",pid,"MedBrothWard")
	q ""
}

/// Description:查询所选病区的时间段内的待揭药记录
/// Creator:	hulihua
/// CreateDate:	2017-08-29
/// Table:      DHC_PhaMedBroth-揭药主表、DHC_PhaMedBrothItm-揭药子表
/// Input:		每页行数、页数、药房科室ID^病区ID
/// Output:		病区ID、病区名称
/// Return：    
/// Others:
/// "1","200","2019-04-18^2019-10-18^245^^151^925"
/// w ##class(web.DHCINPHA.HMMedBroth.MedBrothDispQuery).GetWardLocMedBrothList("1","200","2019-04-18^2019-10-18^245^^151^925")
ClassMethod GetWardLocMedBrothList(page, rows, params) As %Library.String
{
	n (page, rows, params)
	//s ^tmyq("GetWardLocMedBrothList")=$lb(page, rows, params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i $g(page)="" s page=1
	i $g(rows)="" s rows=200
	s End = page*rows
	s Start=(page-1)*rows+1
	s StartDate=$p(params,"^",1)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=$p(params,"^",2)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s PhLocId=$p(params,"^",3)
	s WardLocId=$p(params,"^",5)
	s pid=$p(params,"^",6)
	s phsi=$o(^DHCPHSLi("PHLOC",PhLocId,WardLocId,""),-1)
	s SendFreqFactor=$s(phsi'="":$p(^DHCPHSL(phsi),"^",5),1:"")
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"GetWardLocMedBrothList",pid)
	//按照科室配置构造临时global
 	i (SendFreqFactor'=1000)&&(SendFreqFactor'="")&&(StartDate=EndDate)  d
	.s PhmbID=""
	.f  s PhmbID=$o(^TMP("DHCINPHA",$this,"GetMedBrothWardList",pid,"MedBrothDetail",WardLocId,PhmbID))  q:PhmbID=""  d
	..s LPhmbCh=$o(^TMP("DHCINPHA",$this,"GetMedBrothWardList",pid,"MedBrothDetail",WardLocId,PhmbID,""),-1)
	..s err=0
	..f i=1:1:SendFreqFactor-1 q:err'=0  d
	...s NPhmbCh=$o(^DHCPHAMEDB(PhmbID,"I",LPhmbCh))
	...s:NPhmbCh="" err=-1
	...q:NPhmbCh=""
	...s UncovMedFlag=$p(^DHCPHAMEDB(PhmbID,"I",LPhmbCh),"^",5)
	...q:UncovMedFlag="Y"			//已揭的过滤
	...q:$d(^TMP("DHCINPHA",$this,"GetMedBrothWardList",pid,"FacDet",WardLocId,PhmbID,NPhmbCh))
	...s ^TMP("DHCINPHA",$this,"GetMedBrothWardList",pid,"FacDet",WardLocId,PhmbID,NPhmbCh)=""
	...s LPhmbCh=NPhmbCh
	..
	.
	//构造时间段内查询到的临时global
	s PhmbID=""
	f  s PhmbID=$o(^TMP("DHCINPHA",$this,"GetMedBrothWardList",pid,"MedBrothDetail",WardLocId,PhmbID))  q:PhmbID=""  d
	.s PhmbCh=""
	.f  s PhmbCh=$o(^TMP("DHCINPHA",$this,"GetMedBrothWardList",pid,"MedBrothDetail",WardLocId,PhmbID,PhmbCh))  q:PhmbCh=""  d
	..M ^TMP("DHCINPHA",$this,"GetMedBrothWardList",pid,"FacDet",WardLocId,PhmbID,PhmbCh)=^TMP("DHCINPHA",$this,"GetMedBrothWardList",pid,"MedBrothDetail",WardLocId,PhmbID,PhmbCh)
	.
	//从病区构造和新增加两处global遍历取值
	s PhmbID="",n=0
	f  s PhmbID=$o(^TMP("DHCINPHA",$this,"GetMedBrothWardList",pid,"FacDet",WardLocId,PhmbID))  q:PhmbID=""  d
	.s prescNo=$p(^DHCPHAMEDB(PhmbID),"^",4)
	.s ord=$o(^OEORD(0,"PrescNo",prescNo,""))
	.q:ord="" 
	.s itm=$o(^OEORD(0,"PrescNo",prescNo,ord,""))
	.s oeoriId=ord_"||"_itm
	.s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeoriId,""),-1)
	.s dspStatue=$p($g(^DHCOEDISQTY(dspId)),"^",7)
	.q:dspStatue="R"
	.s PreFactor=$p(##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(prescNo),"^",2)
	.s Papmi=$p(^DHCPHAMEDB(PhmbID),"^",1)
	.s Adm=$p(^DHCPHAMEDB(PhmbID),"^",2)
	.s AdmWard=$p(^PAADM(Adm),"^",70)  			;病人当前所在的病区
	.s AdmWardLoc=$p(^PAWARD(AdmWard),"^",5)
	.s patInfo=##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetPatInfo(Adm)
	.s PatNo=$p(patInfo,"^",1)
	.s PatName=$p(patInfo,"^",3)
	.s PatSex=$p(patInfo,"^",4)
	.s BedId=$p(^PAADM(Adm),"^",73)	//未转病区则取当前床位，转病区则床号为空
 	.s Bed=$S(BedId'="":$p($g(^PAWARD($p(BedId,"||",1),"BED",$p(BedId,"||",2))),"^",1),1:"") 
	.s PhmbCh=""
	.f  s PhmbCh=$o(^TMP("DHCINPHA",$this,"GetMedBrothWardList",pid,"FacDet",WardLocId,PhmbID,PhmbCh))  q:PhmbCh=""  d
	..s UncovMedPocNum=$p(^DHCPHAMEDB(PhmbID,"I",PhmbCh),"^",6)	//应送袋数
	..s UncovMedFlag=$p(^DHCPHAMEDB(PhmbID,"I",PhmbCh),"^",5)
	..q:UncovMedFlag="Y"			//已揭的过滤
	..s UncovMedDate=$p(^DHCPHAMEDB(PhmbID,"I",PhmbCh),"^",2)
	..s UncovMedDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(UncovMedDate)
	..s Phmbi=PhmbID_"||"_PhmbCh
	..s AllSendFlag=##class(web.DHCINPHA.MTCommon.PublicCallMethod).CheckIfAllSend(prescNo,PhLocId)   
	..s AllSendStat=$s(AllSendFlag=1:"是",1:"否")
	..s:AllSendFlag=1 UncovMedPocNum=UncovMedPocNum*PreFactor
	..s Remark=$p(^DHCPHAMEDB(PhmbID,"I",PhmbCh),"^",8)
	..s WardLocDr=$p(^DHCPHAMEDB(PhmbID,"I",PhmbCh),"^",1)
	..s OldWardLocDr=$p(^DHCPHAMEDB(PhmbID,"I",PhmbCh),"^",14)
	..s:(OldWardLocDr="")&&(WardLocDr'=AdmWardLoc) OldWardLoc=WardLocDr	//对已转病区但未存表的进行处理
	..s OldWardLoc=$s(OldWardLocDr'="":$p(^CTLOC(OldWardLocDr),"^",2),1:"")
	..s BarCode=$p(^DHCPHAMEDB(PhmbID,"I",PhmbCh),"^",15)
	..s Index=Papmi_","_Adm
	..s Data1=PatNo_"^"_PatName_"^"_PatSex_"^"_Bed_"^"_prescNo
	..s Data2=UncovMedPocNum_"^"_UncovMedDate_"^"_Phmbi_"^"_AllSendStat_"^"_AllSendFlag
	..s Data3=$g(Remark)_"^"_PhmbID_"^"_$g(OldWardLoc)_"^"_BarCode
	..s Data=Data1_"^"_Data2_"^"_Data3
	..s n=n+1
	..s ^TMP("DHCINPHA",$this,"GetWardLocMedBrothList",pid,"PapMedPoc",Index,n)=Data
	.
	q:n=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(n) //输出空的json串
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartSign(n) //输出json前缀串
	
	s Index="",count=0
	f  s Index=$o(^TMP("DHCINPHA",$this,"GetWardLocMedBrothList",pid,"PapMedPoc",Index))  q:Index=""  d
	.s h=""
	.f  s h=$o(^TMP("DHCINPHA",$this,"GetWardLocMedBrothList",pid,"PapMedPoc",Index,h))  q:h=""  d
	..s mdata=^TMP("DHCINPHA",$this,"GetWardLocMedBrothList",pid,"PapMedPoc",Index,h)
	..s count = count+1
	..s Title1="TPatNo^TPatName^TPatSex^TBed^TPrescNo"
	..s Title2="TUncovMedPocNum^TUncovMedDate^TPhmbi^TAllSendStat^TAllSendFlag"
	..s Title3="TRemark^TPhmbID^TOldWardLoc^TBarCode"
	..s Title=Title1_"^"_Title2_"^"_Title3
	..q:(count<Start)||(count>End)
	..I count=Start d
	...w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	..e  d
	...w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	..
	.
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"GetWardLocMedBrothList",pid)
	q ""
}

/// Description:获取条码所在的病区ID
/// Creator:	hulihua
/// CreateDate:	2017-11-23
/// Table: 		DHC_PhaMedBroth-揭药主表、DHC_PhaMedBrothItm-揭药子表     
/// Input:		barcode-条码号
/// Output:		病区ID^病区描述
/// Return：    
/// Others:
/// w ##class(web.DHCINPHA.HMMedBroth.MedBrothDispQuery).GetBarWardLoc("I19101800001101")
ClassMethod GetBarWardLoc(barcode As %String) As %String
{
	n (barcode)
	q:barcode="" ""
	s prescNo=$e(barcode,1,13)
	s admord=$o(^OEORD(0,"PrescNo",prescNo,""))
	q:admord="" ""
    s adm=$p(^OEORD(admord),"^",1)
    s papmi=+$p(^PAADM(adm),"^",1)
	s phmbid=$o(^DHCPHAMEDBi("PapmiCompFlagPres",papmi,"N",prescNo,""),-1)
	q:phmbid="" ""
	s wardlocid=""
	s phmbch=0
	f  s phmbch=$o(^DHCPHAMEDB(phmbid,"I",phmbch))  q:(phmbch="")||(wardlocid'="")  d
	.s phbarcode=$p(^DHCPHAMEDB(phmbid,"I",phmbch),"^",15)
	.q:phbarcode'=barcode
	.s wardlocid=$p(^DHCPHAMEDB(phmbid,"I",phmbch),"^",1)
	s wardlocdesc=$p($g(^CTLOC(+wardlocid)),"^",2)
	q wardlocid_"^"_wardlocdesc
}

/// Description:查询满足条件的揭药处方信息列表
/// Creator:	hulihua
/// CreateDate:	2017-11-24
/// Table:      DHC_PhaMedBroth-揭药主表、DHC_PhaMedBrothItm-揭药子表
/// Input:		每页行数、页数、药房科室ID^病区ID
/// Output:		病区ID、病区名称
/// Return：    
/// Others:
/// w ##class(web.DHCINPHA.HMMedBroth.MedBrothDispQuery).GetBroDispPreList("1","50","25/11/2017^25/11/2017^257^")
ClassMethod GetBroDispPreList(page, rows, params) As %Library.String
{
	n (page, rows, params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	s DataDelim=##class(web.DHCINPHA.MTCommon.PublicCallMethod).RowDataDelim()
	s InPatNo=$p(params,DataDelim,4)
	s papmi=$s(InPatNo'="":$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(InPatNo),""),-1),1:"")
	q:(InPatNo'="")&&(papmi="") ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	S pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid($this)
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"GetBroDispPreList",pid,"BroDispPre")
	s n=0
	i InPatNo="" d
	.s StartDate=$p(params,DataDelim,1)
	.s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	.s EndDate=$p(params,DataDelim,2)
	.s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	.s WardLocId=$p(params,DataDelim,3)
	.f Date=StartDate:1:EndDate d
	..i WardLocId=""  d
	...s WardLoc=""
	...f  s WardLoc=$o(^DHCPHAMEDBi("ActDateWordLoc",Date,WardLoc))  q:WardLoc=""  d
	....s PhmbID=""
	....f  s PhmbID=$o(^DHCPHAMEDBi("ActDateWordLoc",Date,WardLoc,PhmbID))  q:PhmbID=""  d
	.....q:$d(^TMP("DHCINPHA",$this,"GetBroDispPreList",pid,"BroDispPre",PhmbID))
	.....s n=n+1
	.....d ..SetBroPreGlobal(pid,PhmbID)
	..e  d
	...s PhmbID=""
	...f  s PhmbID=$o(^DHCPHAMEDBi("ActDateWordLoc",Date,WardLocId,PhmbID))  q:PhmbID=""  d
	....q:$d(^TMP("DHCINPHA",$this,"GetBroDispPreList",pid,"BroDispPre",PhmbID))
	....s n=n+1
	....d ..SetBroPreGlobal(pid,PhmbID)
	....
	...
	..
	.
	e  d
	.s papmi=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(InPatNo),""),-1)
	.s MedBroCompFlag=""
	.f  s MedBroCompFlag=$o(^DHCPHAMEDBi("PapmiCompFlagPres",papmi,MedBroCompFlag))  q:MedBroCompFlag=""  d
	..s prescNo="" 
	..f  s prescNo=$o(^DHCPHAMEDBi("PapmiCompFlagPres",papmi,MedBroCompFlag,prescNo))  q:prescNo=""  d
	...s PhmbID=""
	...f  s PhmbID=$o(^DHCPHAMEDBi("PapmiCompFlagPres",papmi,MedBroCompFlag,prescNo,PhmbID))  q:PhmbID=""  d
	....s n=n+1
	....d ..SetBroPreGlobal(pid,PhmbID)
	...
	..
	.
	i n=0 d
	.d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"GetBroDispPreList",pid,"BroDispPre")
	q:n=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(n) //输出空的json串
	s Title1="TPatNo^TBedNo^TPatName^TFactor^TPrescForm"
	s Title2="TInstruc^TDocLoc^TSeekType^TSeekUserName^TSeekDate"
	s Title3="TPid^TPhmbId^TPrescNo"
	s Title=Title1_"^"_Title2_"^"_Title3
	// 输出Json数据
	s countrecords=n
    i End>countrecords s End=countrecords
	s Index="",count=0
	f  s Index=$o(^TMP("DHCINPHA",$this,"GetBroDispPreList",pid,"BroDispPre",Index))  q:Index=""  d
	.s mdata=^TMP("DHCINPHA",$this,"GetBroDispPreList",pid,"BroDispPre",Index)
	.s count = count+1
	.q:(count<Start)||(count>End)
    .i count=Start d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartStringJqGrid(countrecords,rows)
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.i count=End w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign()
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"GetBroDispPreList",pid,"BroDispPre")
	q ""
}

/// Description:构造满足条件的揭药处方信息临时glboal
/// Creator:	hulihua
/// CreateDate:	2017-11-24
/// Table:      DHC_PhaMedBroth-揭药主表、DHC_PhaMedBrothItm-揭药子表
/// Input:		pid-计数器，PhmbID-揭药主表ID
/// Output:		揭药处方信息临时glboal
/// Return：    
/// Others:
/// w ##class(web.DHCINPHA.HMMedBroth.MedBrothDispQuery).SetBroPreGlobal("1","50","24/08/2017^29/11/2017^")
ClassMethod SetBroPreGlobal(pid As %String, PhmbID As %String) As %Library.String
{
	N (pid,PhmbID)
	s admDr=$p(^DHCPHAMEDB(PhmbID),"^",2)
	s prescNo=$p(^DHCPHAMEDB(PhmbID),"^",4)
	s phac=##class(web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery).GetPhacByPres(prescNo)
	q:phac="" ""
	s patInfo=##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetPatInfo(admDr,phac)
	s PatNo=$p(patInfo,"^",1)									//登记号
	s PatName=$p(patInfo,"^",3)									//病人姓名
	s BedNo=$p(patInfo,"^",13)									//床号
	s prescStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(prescNo)
	s Instruc=$p(prescStr,"^",1)								//用法
	s Factor=$p(prescStr,"^",2)									//付数
	s PrescForm=$p(prescStr,"^",8)								//处方剂型
	s preOrdStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPreOrdInfo(prescNo)
	s DocLoc=$p(preOrdStr,"^",1)								//开单科室
	s SeekUserName=$p(preOrdStr,"^",3)							//提交护士
	s SeekDate=$p(preOrdStr,"^",4)								//提交时间
	s SeekType=$p(preOrdStr,"^",5)
	s SeekType=$s(SeekType="A":"护士提交",SeekType="A":"护士拒绝",1:"护士未提交")
	s Data1=PatNo_"^"_BedNo_"^"_PatName_"^"_Factor_"^"_PrescForm
	s Data2=Instruc_"^"_DocLoc_"^"_SeekType_"^"_SeekUserName_"^"_SeekDate
	s Data3=pid_"^"_PhmbID_"^"_prescNo
	s ^TMP("DHCINPHA",$this,"GetBroDispPreList",pid,"BroDispPre",PhmbID)=Data1_"^"_Data2_"^"_Data3
	q ""
}

/// Description:获取揭药处方的详细信息列表
/// Creator:	hulihua
/// CreateDate:	2017-11-25
/// Table:      DHC_PhaMedBroth-揭药主表、DHC_PhaMedBrothItm-揭药子表
/// Input:		每页行数、页数、计数器^揭药主表ID
/// Output:		病区ID、病区名称
/// Return：    
/// Others:
/// w ##class(web.DHCINPHA.HMMedBroth.MedBrothDispQuery).GetBroDispDetList("1","50","2019-06-14^2019-06-17^^^44")
ClassMethod GetBroDispDetList(page, rows, params) As %Library.String
{
	n (page, rows, params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	s DataDelim=##class(web.DHCINPHA.MTCommon.PublicCallMethod).RowDataDelim()
	s StartDate=$p(params,DataDelim,1)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=$p(params,DataDelim,2)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s WardLocId=$p(params,DataDelim,3)
	s InPatNo=$p(params,DataDelim,4)
	s phmbid=$p(params,DataDelim,5)
	s MedAllSendFlag=$p(^DHCPHAMEDB(phmbid),"^",10)
	s phmbich=0,count=0
	f  s phmbich=$o(^DHCPHAMEDB(phmbid,"I",phmbich)) q:phmbich=""  d
	.s WardLocDr=$p(^DHCPHAMEDB(phmbid,"I",phmbich),"^",1)
	.q:(InPatNo="")&&(WardLocId'="")&&(WardLocId'=WardLocDr)
	.s ActBrothDate=$p(^DHCPHAMEDB(phmbid,"I",phmbich),"^",3)
	.q:(InPatNo="")&&((ActBrothDate<StartDate)||(ActBrothDate>EndDate))
	.s BrothDate=$p(^DHCPHAMEDB(phmbid,"I",phmbich),"^",2)
	.s BrothDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(BrothDate)								//用药日期
	.s BrothUserId=$p(^DHCPHAMEDB(phmbid,"I",phmbich),"^",9)
	.s BrothName=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(BrothUserId),"^",2)			//揭药人
	.s UnPocNum=$p(^DHCPHAMEDB(phmbid,"I",phmbich),"^",6)														//应揭袋数
	.s ActUnPocNum=$p(^DHCPHAMEDB(phmbid,"I",phmbich),"^",7)													//揭药袋数
	.s ActBrothDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ActBrothDate)	
	.s BrothRemark=$p(^DHCPHAMEDB(phmbid,"I",phmbich),"^",8)
	.s BrothStatue=$s((MedAllSendFlag="Y")||(BrothRemark="煎药室已送"):"当日送",1:"明日送")		
	.s ActBrothTime=$p(^DHCPHAMEDB(phmbid,"I",phmbich),"^",4)
	.s ActBrothTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(ActBrothTime) 
	.s ActBrothDate=ActBrothDate_" "_ActBrothTime																//揭药日期
	.s NurCheckUserId=$p(^DHCPHAMEDB(phmbid,"I",phmbich),"^",11)										
	.s NurCheckUser=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(NurCheckUserId),"^",2)	//接收人
	.s NurCheckDate=$p(^DHCPHAMEDB(phmbid,"I",phmbich),"^",12)
	.s NurCheckDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(NurCheckDate)	
	.s NurCheckTime=$p(^DHCPHAMEDB(phmbid,"I",phmbich),"^",13)
	.s NurCheckTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(NurCheckTime) 
	.s NurCheckDate=NurCheckDate_" "_NurCheckTime																//接收时间
	.s WardLoc=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetLocInfoById(WardLocDr),"^",2)				//接收科室
	.s mdata=BrothDate_"^"_BrothName_"^"_UnPocNum_"^"_ActUnPocNum_"^"_ActBrothDate_"^"_BrothStatue_"^"_NurCheckDate_"^"_NurCheckUser_"^"_WardLoc
	.s count = count+1
	.s Title="TBrothDate^TBrothName^TUnPocNum^TActUnPocNum^TActBrothDate^TBrothStatue^TNurCheckDate^TNurCheckUser^TWardLoc"
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

/// Description:通过处方号获取该处方的揭药信息
/// Creator:	hulihua
/// CreateDate:	2018-01-10
/// Table:      DHC_PhaMedBroth-揭药主表、DHC_PhaMedBrothItm-揭药子表
/// Input:		每页行数、页数、计数器^揭药主表ID
/// Output:		病区ID、病区名称
/// Return：    
/// Others:
/// w ##class(web.DHCINPHA.HMMedBroth.MedBrothDispQuery).GetBroDispListByPresc("1","500","I18012202678")
ClassMethod GetBroDispListByPresc(page, rows, params) As %Library.String
{
	n (page, rows, params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	s prescNo=params
	s phmbid=$o(^DHCPHAMEDBi("PrescNo",prescNo,""),-1)
	q:phmbid="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	s MedAllSendFlag=$p(^DHCPHAMEDB(phmbid),"^",10)
	s phmbich=0,count=0
	f  s phmbich=$o(^DHCPHAMEDB(phmbid,"I",phmbich)) q:phmbich=""  d
	.q:'$d(^DHCPHAMEDB(phmbid,"I",phmbich))
	.s phmbiId=phmbid_"||"_phmbich
	.s MedBrothInfo=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetMedBrothInfo(phmbiId)
	.s ActBrothDate=$p(MedBrothInfo,"^",7)
	.s BrothDate=$p(MedBrothInfo,"^",3)			//用药日期
	.s BrothName=$p(MedBrothInfo,"^",5)			//揭药人
	.s UnPocNum=$p(MedBrothInfo,"^",15)			//应揭袋数
	.s ActUnPocNum=$p(MedBrothInfo,"^",6)		//揭药袋数
	.s ActBrothDate=$p(MedBrothInfo,"^",7)		//揭药日期	
	.s BrothRemark=$p(MedBrothInfo,"^",8)
	.s BrothStatue=$s((MedAllSendFlag="Y")||(BrothRemark="煎药室已送"):"当日送",1:"明日送")																												
	.s NurCheckUser=$p(MedBrothInfo,"^",17)		//接收人
	.s NurCheckDate=$p(MedBrothInfo,"^",18)		//接收时间
	.s WardLoc=$p(MedBrothInfo,"^",2)			//接收科室
	.s BoxCreateName=$p(MedBrothInfo,"^",19)	//封箱人
	.s BoxCreateDate=$p(MedBrothInfo,"^",20)	//封箱日期
	.s BoxPhHandName=$p(MedBrothInfo,"^",21)	//发放人
	.s BoxPhHandDate=$p(MedBrothInfo,"^",22)	//发放日期
	.s BoxLogisticsName=$p(MedBrothInfo,"^",23)	//配送人
	.s BoxWardHandName=$p(MedBrothInfo,"^",24)	//病区签收人
	.s BoxWardHandDate=$p(MedBrothInfo,"^",25)	//病区签收日期
	.s mdata1=BrothDate_"^"_BrothName_"^"_UnPocNum_"^"_ActUnPocNum_"^"_ActBrothDate
	.s mdata2=BrothStatue_"^"_NurCheckDate_"^"_NurCheckUser_"^"_WardLoc_"^"_BrothRemark
	.s mdata3=BoxCreateName_"^"_BoxCreateDate_"^"_BoxPhHandName_"^"_BoxPhHandDate_"^"_BoxLogisticsName
	.s mdata4=BoxWardHandName_"^"_BoxWardHandDate
	.s mdata=mdata1_"^"_mdata2_"^"_mdata3_"^"_mdata4
	.s count = count+1
	.s Title1="TBrothDate^TBrothName^TUnPocNum^TActUnPocNum^TActBrothDate"
	.s Title2="TBrothStatue^TNurCheckDate^TNurCheckUser^TWardLoc^TBrothRemark"
	.s Title3="TBoxCreateName^TBoxCreateDate^TBoxPhHandName^TBoxPhHandDate^TBoxLogisticsName"
	.s Title4="TBoxWardHandName^TBoxWardHandDate"
	.s Title=Title1_"^"_Title2_"^"_Title3_"^"_Title4
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

/// Description:获取煎药室全发和当日用已送列表
/// Creator:	hulihua
/// CreateDate:	2018-01-15
/// Table:      DHC_PhaMedBroth-揭药主表、DHC_PhaMedBrothItm-揭药子表
/// Input:
/// Output:		住院号、登记号、姓名、床号、处方号、揭药时间、揭药袋数、揭药人、转科之前病区、转科之后病区、子表ID
/// Return：    
/// Others:
/// 		"50","1","2020-07-10^2020-07-13^^212^"
/// w ##class(web.DHCINPHA.HMMedBroth.MedBrothDispQuery).GetCollectDataList("50","1","2020-07-14^2020-07-17^^212^I200716000032^2")
ClassMethod GetCollectDataList(rows, page, params) As %String
{
	n (rows, page, params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	s WardLocId=$p(params,"^",3)
	s PhaLocId=$p(params,"^",4)
	s phaLocHospId=$p($g(^CTLOC(+PhaLocId)),"^",22)
	s BarCode=$p(params,"^",5)
	s bagBatNo=$p(params,"^",6)
	S pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid($this)
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"GetCollectDataList",pid,"PHAMedBITM")
	s n=0
	//break "S+"
	i BarCode=""  d
	.s StartDate=$p(params,"^",1)
	.s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	.s EndDate=$p(params,"^",2)
	.s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	.f Date=StartDate:1:EndDate d
	..i WardLocId="" d
	...;病区为空的情况
	...f  s WardLocId=$o(^DHCPHAMEDBi("ActDateWordLoc",Date,WardLocId)) q:WardLocId=""  d
	....s phmbId=""
	....f  s phmbId=$o(^DHCPHAMEDBi("ActDateWordLoc",Date,WardLocId,phmbId))  q:phmbId=""  d
	.....s phmbCh=0
	.....f  s phmbCh=$o(^DHCPHAMEDBi("ActDateWordLoc",Date,WardLocId,phmbId,phmbCh))  q:phmbCh=""  d
	......d SetTmpGlobal
	....
	...
	..e  d
	...;选择了病区的情况
	...s phmbId=""
	...f  s phmbId=$o(^DHCPHAMEDBi("ActDateWordLoc",Date,WardLocId,phmbId))  q:phmbId=""  d
	....s phmbCh=0
	....f  s phmbCh=$o(^DHCPHAMEDBi("ActDateWordLoc",Date,WardLocId,phmbId,phmbCh))  q:phmbCh=""  d
	.....d SetTmpGlobal
	...
	..
	.
	e  d
	.;扫条码的情况
    .s phmbId=+$o(^DHCPHAMEDBi("BarCode",BarCode,""),-1)
    .q:phmbId=0
    .s MedAllSendFlag=$p($g(^DHCPHAMEDB(phmbId)),"^",10)
    .i MedAllSendFlag="Y" d
    ..s phmbCh=0
    ..f  s phmbCh=$o(^DHCPHAMEDB(phmbId,"I",phmbCh))  q:phmbCh=""  d
    ...d SetTmpGlobal
    ..
    .e  d
    ..s phmbCh=$o(^DHCPHAMEDBi("BarCode",BarCode,phmbId,""),-1)
    ..d SetTmpGlobal
    .
	q:n=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(n) //输出空的json串
 	i End>n s End=n
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartStringJqGrid(n,rows) //输出json前缀串
	s count=0
	s Index=""
	f  s Index=$o(^TMP("DHCINPHA",$this,"GetCollectDataList",pid,"PHAMedBITM",Index)) q:Index=""  d
	.s mdata=^TMP("DHCINPHA",$this,"GetCollectDataList",pid,"PHAMedBITM",Index)
	.s count = count+1
	.s Title1="TphmbiId^TWardLoc^TBrothDate^TBrothName^TActUnPocNum"
	.s Title2="TActBrothDate^TBrothStatue^TRemark^TPrescNo^TPatName"
	.s Title3="TPreFormType^TOrPasJarNum^TWardAbbr"
	.s Title=Title1_"^"_Title2_"^"_Title3
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"GetCollectDataList",pid,"PHAMedBITM")
	q ""	
SetTmpGlobal
	s UncovMedFlag=$p(^DHCPHAMEDB(phmbId,"I",phmbCh),"^",5)
	q:UncovMedFlag'="Y"									//未揭的过滤
    s BatNo=$p(^DHCPHAMEDB(phmbId,"I",phmbCh),"^",17)
    //q:BatNo'=""	
    q:(bagBatNo'="")&&(bagBatNo'=BatNo)										//已经有批次的过滤
	s phmbiId=phmbId_"||"_phmbCh	
    s MedBrothInfo=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetMedBrothInfo(phmbiId)
    s WardLocDr=$p(MedBrothInfo,"^",1)		
    s wardHospId=$p($g(^CTLOC(+WardLocDr)),"^",22)
    q:(phaLocHospId'="")&&(phaLocHospId'=wardHospId)	//判断院区																			
	s WardLoc=$p(MedBrothInfo,"^",2)					//接收科室
	s BrothDate=$p(MedBrothInfo,"^",3)					//用药日期
	s BrothUserName=$p(MedBrothInfo,"^",5)				//揭药人
	s ActUnPocNum=$p(MedBrothInfo,"^",6)				//揭药袋数 
	s ActBrothDate=$p(MedBrothInfo,"^",7)
	s BrothRemark=$p(MedBrothInfo,"^",8)
	s BrothStatue=$p(MedBrothInfo,"^",9)
	s prescNo=$p(MedBrothInfo,"^",10)
	s PatName=$p(MedBrothInfo,"^",11)
	s AdmDr=$p(MedBrothInfo,"^",13)
	s prescStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(prescNo)
	s PreFormType=$p(prescStr,"^",8)
	s OrPasJarNum=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetOralPasteJarNum(prescNo)
	s:OrPasJarNum'=0 ActUnPocNum=0
	s WardAbbr=$p(MedBrothInfo,"^",26)										
	s n=n+1
	s Index=WardLocDr_","_AdmDr_","_phmbiId
	s Data1=phmbiId_"^"_WardLoc_"^"_BrothDate_"^"_BrothUserName_"^"_ActUnPocNum
	s Data2=ActBrothDate_"^"_BrothStatue_"^"_BrothRemark_"^"_prescNo_"^"_PatName
	s Data3=PreFormType_"^"_OrPasJarNum_"^"_WardAbbr
	s ^TMP("DHCINPHA",$this,"GetCollectDataList",pid,"PHAMedBITM",Index)=Data1_"^"_Data2_"^"_Data3
	q
}

/// Description:查询满足条件的揭药批次列表
/// Creator:	hulihua
/// CreateDate:	2018-01-16
/// Table:      DHC_PhaMedBroth-揭药主表、DHC_PhaMedBrothItm-揭药子表
/// Input:		每页行数、页数、药房科室ID^病区ID
/// Output:		病区ID、病区名称
/// Return：    
/// Others:
/// w ##class(web.DHCINPHA.HMMedBroth.MedBrothDispQuery).GetBroPackBList("1","500","16/01/2018^16/01/2018^^")
ClassMethod GetBrothPackList(page, rows, params) As %Library.String
{
	n (page, rows, params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	s DataDelim=##class(web.DHCINPHA.MTCommon.PublicCallMethod).RowDataDelim()
	s StartDate=$p(params,DataDelim,1)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=$p(params,DataDelim,2)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s WardLocId=$p(params,DataDelim,3)
	s BroBatNo=$p(params,DataDelim,4)
	s PackBoxFlag=$p(params,DataDelim,5)
	s LogonLocId=$p(params,DataDelim,6)
	s LogonHospId=$p($g(^CTLOC(+LogonLocId)),"^",22)
	S pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid($this)
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"GetBrothPackList",pid,"WARDLOCBATNO")
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"GetBrothPackList",pid,"WARDLOCBATNODET")
	s n=0
	f Date=StartDate:1:EndDate d
	.i WardLocId="" d
	..f  s WardLocId=$o(^DHCPHAMEDBi("ActDateWardBatNo",Date,WardLocId)) q:WardLocId=""  d
	...i BroBatNo="" d
	....f  s BroBatNo=$o(^DHCPHAMEDBi("ActDateWardBatNo",Date,WardLocId,BroBatNo))  q:BroBatNo=""  d
	.....s phmbId=""
	.....f  s phmbId=$o(^DHCPHAMEDBi("ActDateWardBatNo",Date,WardLocId,BroBatNo,phmbId))  q:phmbId=""  d
	......s phmbCh=0
	......f  s phmbCh=$o(^DHCPHAMEDBi("ActDateWardBatNo",Date,WardLocId,BroBatNo,phmbId,phmbCh))  q:phmbCh=""  d
	.......d SetTmpPackGlobal
	......
	.....
	....
	...
	...e  d
	....s phmbId=""
	....f  s phmbId=$o(^DHCPHAMEDBi("ActDateWardBatNo",Date,WardLocId,BroBatNo,phmbId))  q:phmbId=""  d
	.....s phmbCh=0
	.....f  s phmbCh=$o(^DHCPHAMEDBi("ActDateWardBatNo",Date,WardLocId,BroBatNo,phmbId,phmbCh))  q:phmbCh=""  d
	......d SetTmpPackGlobal
	.....
	....
	...
	..
	.
	.e  d
	..i BroBatNo="" d
	...f  s BroBatNo=$o(^DHCPHAMEDBi("ActDateWardBatNo",Date,WardLocId,BroBatNo))  q:BroBatNo=""  d
	....s phmbId=""
	....f  s phmbId=$o(^DHCPHAMEDBi("ActDateWardBatNo",Date,WardLocId,BroBatNo,phmbId))  q:phmbId=""  d
	.....s phmbCh=0
	.....f  s phmbCh=$o(^DHCPHAMEDBi("ActDateWardBatNo",Date,WardLocId,BroBatNo,phmbId,phmbCh))  q:phmbCh=""  d
	......d SetTmpPackGlobal
	.....
	....
	...
	..e  d
	...s phmbId=""
	...f  s phmbId=$o(^DHCPHAMEDBi("ActDateWardBatNo",Date,WardLocId,BroBatNo,phmbId))  q:phmbId=""  d
	....s phmbCh=0
	....f  s phmbCh=$o(^DHCPHAMEDBi("ActDateWardBatNo",Date,WardLocId,BroBatNo,phmbId,phmbCh))  q:phmbCh=""  d
	.....d SetTmpPackGlobal
	....
	...
	..
	.
	q:n=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(n) //输出空的json串
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartSign(n) //输出json前缀串
	s Index="",count=0
	f  s Index=$o(^TMP("DHCINPHA",$this,"GetBrothPackList",pid,"WARDLOCBATNO",Index))  q:Index=""  d
	.s mdata=^TMP("DHCINPHA",$this,"GetBrothPackList",pid,"WARDLOCBATNO",Index)
	.s count = count+1
	.s Title1="TPid^TWardLoc^TBrothBatNo^TActUnPocNum^TWardLocDr"
	.s Title2="TPhmbiStr"
	.s Title=Title1_"^"_Title2
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"GetBrothPackList",pid,"WARDLOCBATNO")
	q ""
	
SetTmpPackGlobal
	s UncovMedFlag=$p(^DHCPHAMEDB(phmbId,"I",phmbCh),"^",5)
	q:UncovMedFlag'="Y"									//未揭的过滤
    s BatNo=$p(^DHCPHAMEDB(phmbId,"I",phmbCh),"^",17)
    q:BatNo=""											//没有批次的过滤
    s PhBoxDr=$p(^DHCPHAMEDB(phmbId,"I",phmbCh),"^",16)
    q:(PackBoxFlag="N")&&(PhBoxDr'="")					//未装箱
    q:(PackBoxFlag="Y")&&(PhBoxDr="")					//已装箱
	s phmbiId=phmbId_"||"_phmbCh	
    s MedBrothInfo=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetMedBrothInfo(phmbiId)
    s WardLocDr=$p(MedBrothInfo,"^",1)	
    s WardHospId=$p($g(^CTLOC(+WardLocDr)),"^",22)	
    q:(LogonHospId'="")&&(LogonHospId'=WardHospId)																						
	s WardLoc=$p(MedBrothInfo,"^",2)					//接收科室
	s BrothDate=$p(MedBrothInfo,"^",3)					//用药日期
	s BrothUserName=$p(MedBrothInfo,"^",5)				//揭药人
	s ActUnPocNum=$p(MedBrothInfo,"^",6)				//揭药袋数 
	s ActBrothDate=$p(MedBrothInfo,"^",7)
	s BrothRemark=$p(MedBrothInfo,"^",8)
	s BrothStatue=$p(MedBrothInfo,"^",9)
	s prescNo=$p(MedBrothInfo,"^",10)
	s PatName=$p(MedBrothInfo,"^",11)
	s BrothBatNo=$p(MedBrothInfo,"^",12)
	s AdmDr=$p(MedBrothInfo,"^",13)										
	s n=n+1
	s Index1=WardLocDr_","_BrothBatNo
	i $d(^TMP("DHCINPHA",$this,"GetBrothPackList",pid,"WARDLOCBATNO",Index1))  d
	.s $p(^TMP("DHCINPHA",$this,"GetBrothPackList",pid,"WARDLOCBATNO",Index1),"^",4)=$p(^TMP("DHCINPHA",$this,"GetBrothPackList",pid,"WARDLOCBATNO",Index1),"^",4)+ActUnPocNum
	.s $p(^TMP("DHCINPHA",$this,"GetBrothPackList",pid,"WARDLOCBATNO",Index1),"^",6)=$p(^TMP("DHCINPHA",$this,"GetBrothPackList",pid,"WARDLOCBATNO",Index1),"^",6)_","_phmbiId
	e  d
	.s ^TMP("DHCINPHA",$this,"GetBrothPackList",pid,"WARDLOCBATNO",Index1)=pid_"^"_WardLoc_"^"_BrothBatNo_"^"_ActUnPocNum_"^"_WardLocDr_"^"_phmbiId
	s Index2=AdmDr_","_phmbiId
	s Data1=phmbiId_"^"_WardLoc_"^"_BrothDate_"^"_BrothUserName_"^"_ActUnPocNum
	s Data2=ActBrothDate_"^"_BrothStatue_"^"_BrothRemark_"^"_prescNo_"^"_PatName_"^"_AdmDr
	s ^TMP("DHCINPHA",$this,"GetBrothPackList",pid,"WARDLOCBATNODET",Index1,Index2)=Data1_"^"_Data2
	q
}

/// Description:获取选中的科室批次明细列表
/// Creator:	hulihua
/// CreateDate:	2018-01-16
/// Table:      DHC_PhaMedBroth-揭药主表、DHC_PhaMedBrothItm-揭药子表
/// Input:		每页行数、页数、药房科室ID^病区ID
/// Output:		病区ID、病区名称
/// Return：    
/// Others:
/// w ##class(web.DHCINPHA.HMMedBroth.MedBrothDispQuery).GetBroPackDetList("1","500","1708^127^1")
ClassMethod GetBroPackDetList(page, rows, params) As %Library.String
{
	n (page, rows, params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	s DataDelim=##class(web.DHCINPHA.MTCommon.PublicCallMethod).RowDataDelim()
	s pid=$p(params,DataDelim,1)
	s WardLocId=$p(params,DataDelim,2)
	s BrothBatNo=$p(params,DataDelim,3)
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartSign(0) //输出json前缀串
	s IndexNode=WardLocId_","_BrothBatNo
	s Index="",count=0
	f  s Index=$o(^TMP("DHCINPHA",$this,"GetBrothPackList",pid,"WARDLOCBATNODET",IndexNode,Index))  q:Index=""  d
	.s mdata=^TMP("DHCINPHA",$this,"GetBrothPackList",pid,"WARDLOCBATNODET",IndexNode,Index)
	.s JarNum=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetOralPasteJarNum($p(mdata,"^",9))
	.i (+JarNum)'=0  d
	..s $p(mdata,"^",5)=0
	..s $p(mdata,"^",12)=JarNum
	.s count = count+1
	.s Title1="TphmbiId^TWardLoc^TBrothDate^TBrothName^TActUnPocNum"
	.s Title2="TActBrothDate^TBrothStatue^TRemark^TPrescNo^TPatName^TAdm^TJarNum"
	.s Title=Title1_"^"_Title2
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	q ""
}

/// Description:护士领取登记扫描条码获取揭药信息
/// Creator:	hulihua
/// CreateDate:	2018-01-17
/// Table:		DHC_PhaMedBroth-揭药主表、DHC_PhaMedBrothItm-揭药子表      
/// Input:		barcode-条码号
/// Output:		
/// Return：	处方号、登记号、姓名、性别、年龄、用法、付数、煎药方式、开方科室
/// Others: 
/// w ##class(web.DHCINPHA.HMMedBroth.MedBrothDispQuery).GetMedBroPresByBarCode("I191212000038")
ClassMethod GetMedBroPresByBarCode(barcode As %String) As %String
{
	n (barcode)
	Q:barcode="" "-1^条码为空!"
	S prescNo=$e(barcode,1,13)
	Q:prescNo="" "-2^处方号为空!"
	S ord=$o(^OEORD(0,"PrescNo",prescNo,""),-1)
	Q:ord="" "-3^该处方不存在!"
	S phac=##class(web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery).GetPhacByPres(prescNo)
	Q:phac="" "-4^该处方药房还未发药!"
	S phacsub=$o(^DHCPHAC(phac,"I",""),-1)
	Q:phacsub="" "-5^该处方发药信息有误!"
	S phmbId=$o(^DHCPHAMEDBi("PrescNo",prescNo,""),-1)
	Q:phmbId="" "-6^该处方煎药未完成或揭药室还未采集!"
	S MedBroCompFlag=$p(^DHCPHAMEDB(phmbId),"^",5)
	Q:MedBroCompFlag="Y" "-7^该处方已揭药完成!"
	S admDr=$p(^DHCPHAMEDB(phmbId),"^",2)
	S patInfo=##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetPatInfo(admDr)
	S PatNo=$p(patInfo,"^")
	S PatName=$p(patInfo,"^",3)
	S PatSex=$p(patInfo,"^",4)
	S PatAge=$p(patInfo,"^",5)
	S prescStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(prescNo)
	S Factor=$p(prescStr,"^",2)
	S preOrdStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPreOrdInfo(prescNo)
	S DoctorLoc=$p(preOrdStr,"^",1)
	S DataDelim=##class(web.DHCINPHA.MTCommon.PublicCallMethod).RowDataDelim()
	S phmbCh=0,ResutListStr=""
	F  S phmbCh=$o(^DHCPHAMEDB(phmbId,"I",phmbCh))  Q:phmbCh=""  D
	.s phmbiId=phmbId_"||"_phmbCh
    .s MedBrothInfo=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetMedBrothInfo(phmbiId)
    .s UncovMedFlag=$p(MedBrothInfo,"^",14)
	.q:UncovMedFlag="Y"								;已揭的过滤	
	.s WardLoc=$p(MedBrothInfo,"^",2)				;接收科室
	.s BrothDate=$p(MedBrothInfo,"^",3)				;用药日期
	.s UncovMedPocNum=$p(MedBrothInfo,"^",15)
	.s BarCode=$p(MedBrothInfo,"^",16)
	.S ResutStr1=prescNo_DataDelim_PatNo_DataDelim_PatName_DataDelim_PatSex_DataDelim_PatAge
	.S ResutStr2=Factor_DataDelim_DoctorLoc_DataDelim_WardLoc_DataDelim_BrothDate_DataDelim_BarCode
	.S ResutStr3=UncovMedPocNum_DataDelim_phmbiId
	.S ResutStr=ResutStr1_DataDelim_ResutStr2_DataDelim_ResutStr3
	.S ResutListStr=$S(ResutListStr'="":ResutListStr_"&&"_ResutStr,1:ResutStr)
	q:ResutListStr="" "-10^未获取到待揭药领取信息"
	Q ResutListStr
}

/// Description:获取条码扫描需要的日期
/// Creator:	hulihua
/// CreateDate:	2017-11-23
/// Table: 		   
/// Input:		olddate-界面开始日期，type-扫码类型（+1下一天，-1上一天）
/// Output:		
/// Return：	新的日期    
/// Others:
/// w ##class(web.DHCINPHA.HMMedBroth.MedBrothDispQuery).GetBarDate("21/11/2017","+1")
ClassMethod GetBarDate(olddate As %String, type As %String) As %String
{
	n (olddate,type)
	s olddate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(olddate)
	s newdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(olddate+type)
	q newdate
}

/// Description:揭药室点击确认更新表数据
/// Creator:	hulihua
/// CreateDate:	2017-09-08
/// Table:      DHC_PhaMedBroth-揭药主表、DHC_PhaMedBrothItm-揭药子表
/// Input:		每页行数、页数、药房科室ID^病区ID
/// Output:		病区ID、病区名称
/// Return：    
/// Others:
/// 114||1^1^5^^1","10213
/// w ##class(web.DHCINPHA.HMMedBroth.MedBrothDispQuery).SavaBrothDisp("91||1^1^8^^1","10213")
ClassMethod SavaBrothDisp(listData As %String, BrothDispUser As %String) As %String
{
	n (listData,BrothDispUser)
	q:BrothDispUser="" "揭药人不能为空！"
	s len=$l(listData,"&&")
	s $ZT="Error^DHCSTERROR"
	ts 										;开启事务
	s ret=0
	f i=1:1:len  q:ret'=0  d
	.s phmbistr=$p(listData,"&&",i)
	.s phmbistr=phmbistr
	.s PhmbItmId=$p(phmbistr,"^",1)
	.s UncovMedFlag=$p($g(^DHCPHAMEDB(+PhmbItmId,"I",+$p(PhmbItmId,"||",2))),"^",5)
	.s:UncovMedFlag="Y" ret="-2"
	.q:ret'=0
	.s allsendflag=$p(phmbistr,"^",2)
	.i allsendflag="" d
	..s ret=##class(web.DHCINPHA.HMMedBroth.SqlDbBrothDisp).SaveBrothDispDb(phmbistr,BrothDispUser)
	.e  d
	..s ret=##class(web.DHCINPHA.HMMedBroth.SqlDbBrothDisp).SaveAllSendBrothDisp(phmbistr,BrothDispUser)
	.
	i ret'=0 tro
	q:ret'=0 ret
	tc ;提交事务
	q ret
}

/// Description:揭药室扫描全送采集装箱数据
/// Creator:	hulihua
/// CreateDate:	2018-01-16
/// Table:      DHC_PhaMedBrothItm-揭药子表
/// Input:		每页行数、页数、药房科室ID^病区ID
/// Output:		病区ID、病区名称
/// Return：    
/// Others:
/// w ##class(web.DHCINPHA.HMMedBroth.MedBrothDispQuery).GetWardLocMedBrothList("1","50","27/08/2017^01/09/2017^88^265")
ClassMethod SaveCollectData(listData As %String, brothBatNo As %String, brothUserDR As %String) As %String
{
	n (listData,brothBatNo,brothUserDR)
	q:brothBatNo="" -1
	q:listData="" -2
	s len=$l(listData,"&&")
	s ret=0
	s $ZT="Error^DHCSTERROR"
	ts 										;开启事务
	f i=1:1:len  q:ret'=0  d
	.s phmbiId=$p(listData,"&&",i)
	.s ret=##class(web.DHCINPHA.HMMedBroth.SqlDbBrothDisp).SaveBrothCollectDb(phmbiId,brothBatNo,"",brothUserDR)
	i ret'=0 tro
	q:ret'=0 ret
	tc ;提交事务
	q ret
}

/// Description:保存揭药室装箱数据
/// Creator:	hulihua
/// CreateDate:	2018-01-16
/// Table:      DHC_PhaMedBrothItm-揭药子表
/// Input:		listData-装箱的明细串，params（批次、药房ID、病区ID、装箱人、装箱数）
/// Output:		病区ID、病区名称
/// Return：    
/// Others:
/// w ##class(web.DHCINPHA.HMMedBroth.MedBrothDispQuery).SavePackBoxUpData("7663||7,8542||6,9103||4,9310||3,9365||3,9378||3,9381||3,9396||3,9407||3,9437||3,9496||3,9553||3,9664||3,9722||2,9750||3,9782||2,9783||3,9810||2","1^96^122^2754^0")
ClassMethod SavePackBoxUpData(listData As %String, SaveDataStr As %String) As %String
{
	n (listData,SaveDataStr)
	q:listData="" "-1^没有装箱记录！"
	s DataDelim=##class(web.DHCINPHA.MTCommon.PublicCallMethod).RowDataDelim()
	s brothBatNo=$p(SaveDataStr,DataDelim,1)
	q:brothBatNo="" "-2^装箱批次为空！"
	s PhaLocId=$p(SaveDataStr,DataDelim,2)
	q:PhaLocId="" "-3^装箱药房为空！"
	s WardLocId=$p(SaveDataStr,DataDelim,3)
	q:WardLocId="" "-4^装箱病区为空！"
	s PackUserId=$p(SaveDataStr,DataDelim,4)
	q:PackUserId="" "-5^装箱人为空！"
	s BoxNum=+$p(SaveDataStr,DataDelim,5)
	q:BoxNum=0 "-6^装箱箱数为0！"
	s len=$l(listData,",")
	s count=0
	f i=1:1:len	d
	.s phmbiId=$p(listData,",",i)
	.s PhBoxDr=$p(^DHCPHAMEDB(+phmbiId,"I",$p(phmbiId,"||",2)),"^",16)
    .q:PhBoxDr'=""			;已装箱的过滤
    .s BatNo=$p(^DHCPHAMEDB(+phmbiId,"I",$p(phmbiId,"||",2)),"^",17)
    .q:BatNo'=brothBatNo	;非该批次的过滤
	.s count=count+1
	q:count=0 "-7^该批次已装箱！"
	s $ZT="Error^DHCSTERROR"
	ts 										;开启事务
	;1、生成装箱信息
	s SqlStr=PhaLocId_"^"_WardLocId_"^"_BoxNum_"^"_PackUserId
	s PhBoxStr=##class(web.DHCINPHA.MTBinBox.SqlDbBinBox).InsertBox(SqlStr)
	i PhBoxStr<0 tro
	q:PhBoxStr<0 "-8"_"^"_PhBoxStr
	s phboxid=$p(PhBoxStr,"#",1)
	;2、处理揭药信息
	s ret=0
	f i=1:1:len  q:ret'=0  d
	.s phmbiId=$p(listData,",",i)
	.s ret=##class(web.DHCINPHA.HMMedBroth.SqlDbBrothDisp).SaveBrothCollectDb(phmbiId,"",phboxid)
	i ret'=0 tro
	q:ret'=0 "-9"_"^"_ret
	tc ;提交事务
	q ret_"^"_phboxid
}

/// Description:保存揭药室护士领取登记信息
/// Creator:	hulihua
/// CreateDate:	2018-01-17
/// Table:      DHC_PhaMedBrothItm-揭药子表
/// Input:		listData-装箱的明细串，params（批次、药房ID、病区ID、装箱人、装箱数）
/// Output:		病区ID、病区名称
/// Return：    
/// Others:
/// w ##class(web.DHCINPHA.HMMedBroth.MedBrothDispQuery).SavePackBoxUpData("7663||7,8542||6,9103||4,9310||3,9365||3,9378||3,9381||3,9396||3,9407||3,9437||3,9496||3,9553||3,9664||3,9722||2,9750||3,9782||2,9783||3,9810||2","1^96^122^2754^0")
ClassMethod SaveNuresTakeData(SqlStr As %String) As %String
{
	n (SqlStr)
	s DataDelim=##class(web.DHCINPHA.MTCommon.PublicCallMethod).RowDataDelim()
	s phmbiId=$p(SqlStr,DataDelim,1)
	q:phmbiId="" "-1^揭药记录不存在！"
	s regUserId=$p(SqlStr,DataDelim,2)
	q:(regUserId="")||('$d(^SSU("SSUSR",regUserId))) "-2^登记人为空或在系统中不存在！"
	s ret=##class(web.DHCINPHA.HMNurseCheck.SqlDbNurseCheck).SaveBroNurCheckDb(phmbiId,regUserId)
	q:ret'=0 "-3^"_ret
	q ret
}

/// Description:保存扫描协定膏方等手机端没有传入的数据
/// Creator:	hulihua
/// CreateDate:	2018-01-19
/// Table:      DHC_PhaMedBroth、DHC_PhaMedBrothItm、
/// Input:		BarCode-条码号
/// Output:		0-无需插入或插入成功，非0-插入失败
/// Return：    
/// Others:
/// w ##class(web.DHCINPHA.HMMedBroth.MedBrothDispQuery).SaveMedBrothNoData("I200716000022","13847","212")
ClassMethod SaveMedBrothNoData(barcode As %String, CollectUserId As %String, logonLocId As %String = "", batNo As %String = "") As %String
{
	N (barcode,CollectUserId,logonLocId,batNo)
	//s ^tmyq("SaveMedBrothNoData")=$lb(barcode,CollectUserId,logonLocId)
	Q:barcode="" 0
    S phmbId=+$o(^DHCPHAMEDBi("BarCode",barcode,""),-1)
    //Q:phmbId'=0 -7
    i phmbId=0 d
    .s phmbId=+$o(^DHCPHAMEDBi("PrescNo",barcode,""),-1)		
    //Q:phmbId'=0 -8
    S prescNo=$e(barcode,1,13)
	Q:prescNo="" -1
	S ord=$o(^OEORD(0,"PrescNo",prescNo,""),-1)
	Q:ord="" -2
	S phac=$O(^DHCPHAC(0,"Prescno",prescNo,""),-1)
	Q:phac="" -3
	s logonHospId=$p($g(^CTLOC(+logonLocId)),"^",22)
	s phacLocId=$p((^DHCPHAC(phac)),"^",1)
	s phacHospId=$p($g(^CTLOC(+phacLocId)),"^",22)
	q:(logonHospId'="")&&(logonHospId'=phacHospId) -9		//判断条码院区
	S phacsub=$o(^DHCPHAC(phac,"I",""),-1)
	Q:phacsub="" -4
	s decPmDr=$o(^BS.PHA.DEC.PMi("PRESCNO",prescNo,""),-1)
	Q:decPmDr="" -5		//未煎药
	Q:($p($g(^BS.PHA.DEC.PM(decPmDr)),"^",6)'="Y") -6	//未煎药完成
	b ;1
	i phmbId="" d
	.S ret=##class(web.DHCINPHA.HMMedBroth.SqlDbBrothDisp).GetMedBrothDataByPhc(phac,CollectUserId,"1",batNo)
	e  d
	.s phmbId=phmbId_"^^^^"_batNo
	.s ret=##class(web.DHCINPHA.HMMedBroth.SqlDbBrothDisp).SaveAllSendBrothDisp(phmbId,CollectUserId)
	Q ret
}

/// Description:界面关闭或者其它原因K掉临时global
/// Creator:	hulihua
/// CreateDate:	2017-09-20
/// Table:      
/// Input:		pid-计数器
/// Output:		0-成功
/// Return：    
/// Others:
ClassMethod KillDetailTmp(pid As %Integer)
{
	n (pid)
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"GetBrothPackList",pid,"WARDLOCBATNODET")
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"GetMedBrothWardList",pid,"MedBrothDetail")
	q 0
}

Storage Default
{
<Data name="MedBrothDispQueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCINPBC6C.MedBrothDis3DE7D</DataLocation>
<DefaultData>MedBrothDispQueryDefaultData</DefaultData>
<IdLocation>^web.DHCINPBC6C.MedBrothDis3DE7D</IdLocation>
<IndexLocation>^web.DHCINPBC6C.MedBrothDis3DE7I</IndexLocation>
<StreamLocation>^web.DHCINPBC6C.MedBrothDis3DE7S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
