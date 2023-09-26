Import sqluser

/// Descript:	同第三方物资管理软件间的库存同步类
/// Creator:	wangjiabin
/// CreateDate:	2017-07-26
Class web.DHCSTMService.HRP.Out2InServiceImpl Extends (%RegisteredObject, web.DHCSTMHUI.StkTypeM, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Descript:	低值医嘱消减任务
/// Creator:	wangjiabin
/// CreateDate:	2017-07-27
/// Input:		开始日期(Y-m-d), 截止日期(Y-m-d)
/// Return:	
/// receive_id:%String,sell_price:%Float,amount:%Float,bar_code:%String,is_high_value:%String,doc_advice_code:%String,doc_advice_date:%String,patient_code:%String,patient_name:%String,emp_code:%String,doctor_name:%String,charge_date:%String,message:%String,oper_date:%String,bed_no:%String,hospital_no:%String,exec_dept_name:%String,exec_dept_code:%String,order_dept_name:%String,order_dept_code:%String,charge_code:%String,charge_name:%String,in_iow_id:%String
/// w ##class(web.DHCSTMService.HRP.Out2InServiceImpl).SendDispInfo("2020-05-11","2020-05-11")
ClassMethod SendDispInfo(Stdate As %String, Endate As %String) As %String
{
	n (Stdate,Endate)
	s stream=##class(%GlobalCharacterStream).%New()
	s return=""
	s Head="<Request><Header><SourceSystem>02</SourceSystem><MessageID></MessageID></Header><Body>"
	s Afterward="</Body></Request>"
	SET rs=##class(%ResultSet).%New()
	SET rs.ClassName="web.DHCSTMService.HRP.Out2InServiceImpl"
	set rs.QueryName="GetDispInfo"
	DO rs.Execute(Stdate,Endate)
	s objList=##class(web.DHCSTMService.HRP.Model.DispInfoList).%New()
	While rs.Next(.sc) {
		s obj=##class(web.DHCSTMService.HRP.Model.DispInfo).%New()
		s obj.receiveid=rs.Data("receive_id")  ; 收费流水号
		s obj.chargedate=rs.Data("charge_date") ; 收费日期
		s obj.adviceno=rs.Data("advice_no") ; 医嘱编号
		s obj.detailcode=rs.Data("detail_code")  ; 收费项编码
		s obj.detailname=rs.Data("detail_name") ; 收费项名称
		s obj.invcode=rs.Data("inv_code") ; 
		s obj.invname=rs.Data("inv_name") ; 
		;s obj.batchno=rs.Data("batch_no") ; 
		s obj.onlybatchsn=rs.Data("in_iow_id") ; 唯一批次码  
		;s obj.barcode=rs.Data("bar_code") ; 
		s obj.chargenum=rs.Data("charge_num") ; 收费数量
		s obj.outnum=rs.Data("out_num") ; 消耗数量
		;s obj.chargeprice=rs.Data("charge_price") ; 
		s obj.orderdeptcode=rs.Data("admlocCode") ; 开单科室编码
		s obj.orderdeptname=rs.Data("admlocDesc") ; 开单科室名称
		s obj.execdeptcode=rs.Data("exec_dept_code") ; 执行科室编码
		s obj.execdeptname=rs.Data("exec_dept_name") ; 执行科室名称
		s obj.chargecode=rs.Data("charge_code") ; 收费员工号
		s obj.chargename=rs.Data("charge_name") ; 收费员姓名
		s obj.nursecode=rs.Data("nurse_code") ; 护士工号
		s obj.nursename=rs.Data("nurse_name") ; 护士姓名
		s obj.doccode=rs.Data("doc_code") ; 医生工号
		s obj.docname=rs.Data("doc_name") ; 医生姓名
		s obj.patientname=rs.Data("patient_name") ; 患者姓名
		s obj.hospitalno=rs.Data("hospital_no") ; 住院号
		s obj.bedno=rs.Data("bed_no") ; 病床号
		s obj.doctype=rs.Data("doc_type") ; 医嘱类别
		d objList.InfoModes.Insert(obj)
		if objList.InfoModes.Count()>500 d
		.s return=$$SendDispInfoMac()
	}
	if objList.InfoModes.Count()>0 d
	.s return=$$SendDispInfoMac()
	q return
	
SendDispInfoMac()
	d objList.XMLExportToStream(.stream)
	s transType="1004"
	s processingCode="100450"
	s businessno="00"
	s datatype="01"   ;xml格式
	s return=##class(web.DHCENS.EnsHISService).DHCHisInterface("SendLowValueToHRP",transType,processingCode,businessno,datatype,stream)
	d objList.InfoModes.Clear()
	s rescode=$P(return,"^",1)
	q rescode
}

/// Descript:	医嘱台帐信息
/// Creator:	wangjiabin
/// CreateDate:	2017-07-27
/// Input:		开始日期(Y-m-d), 截止日期(Y-m-d)
/// Return:		
/// d ##class(%ResultSet).RunQuery("web.DHCSTMService.HRP.Out2InServiceImpl","GetDispInfo","2020-04-27","2020-04-30")
Query GetDispInfo(StartDate As %String, EndDate As %String) As websys.Query(ROWSPEC = "receive_id:%String,charge_date:%String,advice_no:%String,detail_code:%String,detail_name:%String,inv_code:%String,inv_name:%String,only_batch_sn:%String,bar_code:%String,charge_num:%Float,out_num:%Float,charge_price:%Float,order_dept_code:%String,order_dept_name:%String,exec_dept_code:%String,exec_dept_name:%String,charge_code:%String,charge_name:%String,nurse_code:%String,nurse_name:%String,doc_code:%String,doc_name:%String,patient_name:%String,hospital_no:%String,bed_no:%String,doc_type:%String,is_high_value:%String,in_iow_id:%String,message:%String,inv_code:%String,inv_desc:%String,admlocCode:%String,admlocDesc:%String")
{
}

ClassMethod GetDispInfoExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String) As %Status
{
	n (qHandle,StartDate,EndDate)
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	s:StartDate["-" StartDate=$zdh(StartDate,3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s StkType="M"
	s TypeStr="MP^MY^MF^MH"
	s Len=$l(TypeStr,"^")
	f i=1:1:Len d
	.s TrType=$p(TypeStr,"^",i)
	.
	.f TrDate=StartDate:1:EndDate d
	..s TrDateZ=$zd(TrDate,3)
	..s Intr=0
	..f  s Intr=$o(^DHCINTR(0,"TypeDate",TrType,TrDate,Intr)) q:Intr=""  d
	...s TrInfo=^DHCINTR(Intr)
	...s Qty=$p(TrInfo,"^",6)
	...s Inclb=$p(TrInfo,"^",7)
	...s Pointer=$p(TrInfo,"^",9)
	...s hvid=$o(^DHCHVMORI(0,"OEORI",Pointer,""))
	...q:hvid'=""
	...s Sp=$p(TrInfo,"^",14)
	...
	...s Inci=$p(Inclb,"||",1),IL=$p(Inclb,"||",2),LB=$p(Inclb,"||",3)
	...q:(Inci="")||(IL="")||(LB="")
	...s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	...s ScgType=$p(ScgInfo,"^",3)
	...q:ScgType'=StkType
	...s Incib=$p(^INCI(Inci,"IL",IL,"LB",LB),"^",1)
	...q:Incib=""
	...s IB=$p(Incib,"||",2)
	...s DHCIncib=$o(^DHCINCIB(0,"INCIB",Incib,0))
	...q:DHCIncib=""
	...s BatId=$p(^DHCINCIB(DHCIncib),"^",20)		;第三方DetailId
	...;q:BatId=""
	...
	...s BatNo=$p(^INCI(Inci,"IB",IB),"^",1)
	...s ExpDate=+$p(^INCI(Inci,"IB",IB),"^",2)
	...s:ExpDate'="" ExpDate=$zd(ExpDate,3)
	...q:'$d(^INCI(Inci))
	...s InciCode=$p(^INCI(Inci,1),"^",1)
	...s InciDesc=$p(^INCI(Inci,1),"^",2)
	...
	...s LocId=$p(^INCI(Inci,"IL",IL),"^",1)
	...q:LocId=""
	...s LocCode=LocId		;$p(^CTLOC(LocId),"^",1)
	...s LocDesc=$p(^CTLOC(LocId),"^",2)
	...
	...s Oeori=Pointer
	...
	...s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	...s HVBarCode=..GetBarcodeByOrd(Oeori)
	...s Arcim=$p(^INCI(Inci,1),"^",3)
	...s ArcimSub=$p(Arcim,"||",1),ArcimVer=$p(Arcim,"||",2)
	...q:(Arcim="")||(ArcimSub="")||(ArcimVer="")
	...
	...s ArcCode=$p(^ARCIM(ArcimSub,ArcimVer,1),"^",1)
	...s ArcDesc=$p(^ARCIM(ArcimSub,ArcimVer,1),"^",2)
	...
	...s Ord=$p(Oeori,"||",1),OrdCh=$p(Oeori,"||",2)
	...q:(Ord="")||(OrdCh="")
	...s AdmId=$p(^OEORD(Ord),"^",1)
	...q:AdmId=""
	...s admloc=$p(^PAADM(AdmId),"^",4)
	...s admlocDesc="",admlocCode=""
	...i admloc'="" d
	....s admlocDesc=$p(^CTLOC(admloc),"^",2)
	....s admlocCode=admloc		;$p(^CTLOC(admloc),"^",1)
	...s Papmi=$p($g(^PAADM(AdmId)),"^",1)
	...q:Papmi=""
	...s AdmNo=$p($g(^PAPER(Papmi,"PAT",1)),"^",1)		;登记号
	...s AdmName=$p($g(^PAPER(Papmi,"ALL")),"^",1)
	...s Medno=$p($g(^PAPER(Papmi,"PAT",1)),"^",22)
	...s BedId=$p($g(^PAADM(AdmId)),"^",73)
	...s BedNo=$s(BedId'="":$p($g(^PAWARD(+BedId,"BED",$p(BedId,"||",2))),"^",1),1:"")
	...s OrdDate=$p(^OEORD(Ord,"I",OrdCh,3),"^",7)
	...s:OrdDate'="" OrdDate=$zd(OrdDate,3)
	...s AdmType="" ;就诊类型
	...
	...s DoctorId=$p(^OEORD(Ord,"I",OrdCh,7),"^",1)		;OEORI_UserAdd 医嘱录入人
	...s DocLocId=$p(^OEORD(Ord,"I",OrdCh,7),"^",2)
	...s DoctorInitial=$p(^SSU("SSUSR",DoctorId),"^",1)
	...s DoctorName=$p(^SSU("SSUSR",DoctorId),"^",2)
	...s DocLocCode=DocLocId		;$s(DocLocId'="":$p(^CTLOC($g(DocLocId)),"^",1),1:"")
	...s DocLocDesc=$s(DocLocId'="":$p(^CTLOC($g(DocLocId)),"^",2),1:"")
	...s ExeLocId=""
	...s ExeLocCode=LocId ;执行科室
	...s ExeLocDesc=LocDesc 
	...s Qty=-Qty
	...d OutPutTrDetail
	Quit $$$OK

OutPutTrDetail
	Set Data=$lb(Intr,OrdDate,Oeori,ArcCode,ArcDesc,InciCode,InciDesc,BatNo,HVBarCode,Qty,
				Qty,Sp,DocLocId,DocLocDesc,ExeLocCode,ExeLocDesc,"","","","",
				DoctorInitial,DoctorName,AdmName,AdmNo,BedNo,AdmType,HVFlag,BatId,"",InciCode,InciDesc,admloc,admlocDesc
	)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

/// w ##class(web.DHCSTMService.HRP.Out2InServiceImpl).SendReqInfoTask($H-1000,$h)
ClassMethod SendReqInfoTask(st As %String, et As %String) As %String
{
	n (st,et)
	s sqlStr="SELECT INRQ_RowId,INRQ_UserCompleted FROM SQLUser.IN_Request WHERE INRQ_Date BETWEEN '"_st_"' and '"_et_"'"
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sqlStr)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err  q $$$OK
	While(result.Next())
	{
		s req = result.Data("INRQ_RowId")
		s completeflag=result.Data("INRQ_UserCompleted")
		continue:completeflag'="Y"
		s ret=..SendReqInfo(req)
	}
	q 0
}

/// Descript:	推送申请单信息
/// Creator:	lihui
/// CreateDate:	20200415
/// Input:		ReqId(申请单ID)
/// Return:	0成功，其他失败
/// w ##class(web.DHCSTMService.HRP.Out2InServiceImpl).SendReqInfo(17)
ClassMethod SendReqInfo(ReqId As %String) As %String
{
	n (ReqId)
	q:(ReqId="")||('$d(^INRQ(ReqId))) 0
	s stream=##class(%GlobalCharacterStream).%New()
	s return=##class(%GlobalCharacterStream).%New()
	s ReqInfoList=##class(web.DHCSTMService.HRP.Model.ReqInfoList).%New()
	s ReqInfoDataList=##class(web.DHCSTMService.HRP.Model.ReqInfoDataList).%New()
	s ReqInfo=^INRQ(ReqId)
	s ReqInfoDataList.billno=$p(ReqInfo,"^",1)
	s CreateDate=$p(ReqInfo,"^",2)
	s ReqInfoDataList.createdate=$zd(CreateDate,3)
	s ReqLocId=$p(ReqInfo,"^",6)
	s HospId=$p(^CTLOC(ReqLocId),"^",22)
	s ReqLocCode=ReqLocId		;$p(^CTLOC(ReqLocId),"^",1)
	s ReqInfoDataList.deptcode=ReqLocCode
	s CreateUserId=$p(ReqInfo,"^",4)
	s CreateUserInit=$p(^SSU("SSUSR",CreateUserId),"^",1)
	s ReqInfoDataList.maker=CreateUserInit
	s remark=""
	&sql(SELECT INRQ_Remarks INTO:remark FROM IN_Request WHERE INRQ_RowId=:ReqId)
	s ReqInfoDataList.remark=remark
	s chl=""
	f  s chl=$o(^INRQ(ReqId,"RQI",chl)) q:chl=""  d
	.s itmInfo=^INRQ(ReqId,"RQI",chl)
	.s ReqItmInfo=##class(web.DHCSTMService.HRP.Model.ReqItmInfo).%New()
	.s inci=$p(itmInfo,"^",4)
	.s incicode=$p(^INCI(inci,1),"^",1)
	.s ReqItmInfo.invcode=incicode
	.s ReqItmInfo.qty=$p(itmInfo,"^",3)
	.s Uomid=$p(itmInfo,"^",5)
	.s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciBasicRp(inci,+$h,Uomid,HospId)
	.s ReqItmInfo.rp=Rp
	.d ReqInfoDataList.detail.Insert(ReqItmInfo)
	d ReqInfoList.data.Insert(ReqInfoDataList)
	d ReqInfoList.XMLExportToStream(.stream)
	s transType="1004"
	s processingCode="100452"
	s businessno="00"
	s datatype="01"   ;xml格式	
	s return=##class(web.DHCENS.EnsHISService).DHCHisInterface("SendApplicationToHRP",transType,processingCode,businessno,datatype,stream)
	d ReqInfoList.data.Clear()
	q 0
}

ClassMethod NewPid() As %String
{
  q $i(^DHCSTMPID("PID"))
}

/// 功能：普通耗材数据开医嘱和停医嘱（实时同步）
/// 备注1：判断调用节点 ##class(web.DHCSTMHUI.PCHCOLLSM).Disp .return 等
/// 参数 医嘱id：oeori，医嘱类型 type
ClassMethod SendNorMalOrdItmByOeori(Oeori As %String, type As %String, HospId) As %String
{
	n (Oeori,type,HospId)
	s SerTypeId=$p(^DHCSTM("ServiceConfig","HRP"_HospId),"^",4)
	
	s Ret=0
	s stream=##class(%GlobalCharacterStream).%New()
	s result=##class(web.DHCSTMService.HRP.Model.OperateResult).%New()
	
	s inputparmas=Oeori_","_type
	s objList=##class(web.DHCSTMService.HRP.Model.DispInfoList).%New()
	s obj=##class(web.DHCSTMService.HRP.Model.DispInfo).%New()
	s obj=..getObjData(Oeori,type,"","N")
	i obj.receiveid="" s Ret=-6 q Ret
	d objList.InfoModes.Insert(obj)
	d objList.XMLExportToStream(.stream)
	d objList.InfoModes.Clear()
    s transType="1004"
	s processingCode="100450"
	s businessno="00"
	s datatype="01"   ;xml格式
	s result=##class(web.DHCENS.EnsHISService).DHCHisInterface("SendLowValueToHRP",transType,processingCode,businessno,datatype,stream)
	s rescode=$p(result,"^",1)
	i rescode'="0"  d
    .d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"-110",SerTypeId,$ZNAME,"SendNorMalOrdItmByOeori",inputparmas)
	q rescode
}

/// 功能：高值耗材数据开医嘱和停医嘱（实时同步）
/// 备注1：判断调用节点 ##class(web.DHCSTMHUI.PCHCOLLSM).Disp .return 等
/// 备注2：防止医嘱审核报错，是否判断8.4的接口返回值。错误日志记录。
/// 参数 医嘱id：oeori,条码：barcode,类型：type：（disp：开医嘱，return：停医嘱)
/// housc 20200416
/// w ##class(web.DHCSTMService.HRP.Out2InServiceImpl).SendHvMatOrdItmByOeori("8197||2","000000001991","disp")
ClassMethod SendHvMatOrdItmByOeori(Oeori As %String, barcode As %String, type As %String, HospId) As %String
{
	n (Oeori,barcode,type,HospId)
	s SerTypeId=$p(^DHCSTM("ServiceConfig","HRP"_HospId),"^",4)
	
	s stream=##class(%GlobalCharacterStream).%New()
	s result=##class(web.DHCSTMService.HRP.Model.OperateResult).%New()
	s inputparmas=Oeori_","_barcode_","_type
	s objList=##class(web.DHCSTMService.HRP.Model.DispInfoList).%New()
	s Ret=0
	s Ord=$p(Oeori,"||",1),OrdCh=$p(Oeori,"||",2)
	s ori=Ord_"||"_OrdCh
	s hvid="" 
	f  s hvid=$o(^DHCHVMORI(0,"OEORI",ori,hvid)) q:(hvid="")||(Ret'=0)  d
	.s obj=##class(web.DHCSTMService.HRP.Model.DispInfo).%New()
	.s obj=..getObjData(Oeori,type,hvid,"N")
	.i obj.receiveid="" s Ret=-6 
	.q:Ret'=0
	.s objList=##class(web.DHCSTMService.HRP.Model.DispInfoList).%New()
	.d objList.InfoModes.Insert(obj)
	.d objList.XMLExportToStream(.stream)
	.d objList.InfoModes.Clear()
	.s transType="1004"
	.s processingCode="100451"
	.s businessno="00"
	.s datatype="01"   ;xml格式
	.s result=##class(web.DHCENS.EnsHISService).DHCHisInterface("SendHighValueToHRP",transType,processingCode,businessno,datatype,stream)
	.s rescode=$p(result,"^",1)
	.i rescode="0"  d
	..s ret=..SetHvSendHRPFlag(hvid)
	..i ret'=0  d
	...s Ret=-19
	...d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,Ret,SerTypeId,$ZNAME,"SetHvSendHRPFlag",hvid)
	.e  d
	..d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"-110",SerTypeId,$ZNAME,"SendHvMatOrdItmByOeori",inputparmas)
	q Ret
}

/// 非实时性的情况
/// 遍历dhc_hvmat_orditm表。
/// houshanchuan
/// w ##class(web.DHCSTMService.HRP.Out2InServiceImpl).SendHvMatToHRP()
ClassMethod SendHvMatToHRP() As %String
{
	s result=##class(web.DHCSTMService.HRP.Model.OperateResult).%New()
	
	s stream=##class(%GlobalCharacterStream).%New()
	s qty=1
	s pid=..NewPid()
	k ^TMPHVMATORDITMHRP(pid,"HRP")
	s hvid=""
	s err=0
	s objlist=##class(web.DHCSTMService.HRP.Model.DispInfoList).%New()
	f  s hvid=$O(^DHCHVMORI(0,"SendFourFlag","N",hvid)) q:(hvid="")||(err'=0)  d
	.s Oeori=$P(^DHCHVMORI(hvid,1),"^",1)
	.s obj=##class(web.DHCSTMService.HRP.Model.DispInfo).%New()
	.s obj=..getObjData(Oeori,"disp",hvid,"Y")
	.q:obj.receiveid=""
	.d objlist.InfoModes.Insert(obj)
	.s ^TMPHVMATORDITMHRP(pid,"HRP",hvid)=""
	.i objlist.InfoModes.Count()>200 d
	..s result=$$SendHvMatToHRP()
	i objlist.InfoModes.Count()>0 d
	.s result=$$SendHvMatToHRP()
	s pid=..NewPid()
	k ^TMPHVMATORDITMHRP(pid,"HRP")
	s hvid=""
	s err=0
	f  s hvid=$O(^DHCHVMORIRET(0,"RSendHRPFlag","N",hvid)) q:(hvid="")||(err'=0)  d
	.s Oeori=$P(^DHCHVMORIRET(hvid,1),"^",1)
	.s obj=##class(web.DHCSTMService.HRP.Model.DispInfo).%New()
	.s obj=..getObjData(Oeori,"return",hvid,"Y")
	.q:obj.receiveid=""
	.d objlist.InfoModes.Insert(obj)
	.s ^TMPHVMATORDITMHRP(pid,"HRP",hvid)=""
	.i objlist.InfoModes.Count()>200 d
	..s result=$$SendHvMatRetToHRP()
	i objlist.InfoModes.Count()>0 d
	.s result=$$SendHvMatRetToHRP()
	q 0
SendHvMatToHRP()
	d objlist.XMLExportToStream(.stream)
	d objlist.InfoModes.Clear()
	s ret=0
	;调用8.4接口，返回result
	s transType="1004"
	s processingCode="100451"
	s businessno="00"
	s datatype="01"   ;xml格式
	s result=##class(web.DHCENS.EnsHISService).DHCHisInterface("SendHighValueToHRP",transType,processingCode,businessno,datatype,stream)
	s rescode=$p(result,"^",1)
	i rescode="0" d
	.s hvmatid=""
	.ts
	.f  s hvmatid=$O(^TMPHVMATORDITMHRP(pid,"HRP",hvmatid)) q:(hvmatid="")||(ret'=0)  d
	..s ret=..SetHvSendHRPFlag(hvmatid)
	.i ret'=0 tro  q
	.q:ret'=0
	.tc
	i ret'=0 d
	.;错误日志
	k ^TMPHVMATORDITMHRP(pid,"HRP")
	q rescode
SendHvMatRetToHRP()
	d objlist.XMLExportToStream(.stream)
	d objlist.InfoModes.Clear()
	;s result=soap()
	s ret=0
	;调用8.4接口，返回result
	s transType="1004"
	s processingCode="100451"
	s businessno="00"
	s datatype="01"   ;xml格式
	s result=##class(web.DHCENS.EnsHISService).DHCHisInterface("SendHighValueToHRP",transType,processingCode,businessno,datatype,stream)
	s rescode=$p(result,"^",1)
	i rescode="0" d
	.s hvmatid=""
	.ts
	.f  s hvmatid=$O(^TMPHVMATORDITMHRP(pid,"HRP",hvmatid)) q:(hvmatid="")||(ret'=0)  d
	..s ret=..SetHvRetSendHRPFlag(hvmatid)
	.i ret'=0 tro  q
	.q:ret'=0
	.tc
	i ret'=0 d
	.;错误日志
	k ^TMPHVMATORDITMHRP(pid,"HRP")
	q rescode
}

ClassMethod SetHvSendHRPFlag(hvid As %String) [ Private ]
{
	n (hvid)
	s SendHRPFlag="Y"
	s ret=0
	&sql(update dhc_hvmat_orditm set ORI_SendHRPFlag=:SendHRPFlag where ORI_RowId=:hvid)
	i SQLCODE'=0 d
	.s ret=-11
	q ret
}

ClassMethod SetHvRetSendHRPFlag(hvid As %String) [ Private ]
{
	n (hvid)
	s SendHRPFlag="Y"
	s ret=0
	&sql(update DHC_HVMat_OrdItmRet set ORI_RSendHRPFlag=:SendHRPFlag where ORIR_RowId=:hvid)
	i SQLCODE'=0 d
	.s ret=-11
	q ret
}

/// 推送普通材料消耗任务
ClassMethod SendTask() As %String
{
	s st=+$H-1
	s et=+$H-1
	s:st'="" st=$zd(st,3)
	s:et'="" et=$zd(et,3)
	d ..SendDispInfo(st,et)
	d ..SendReqInfoTask(st,et)
	q
}

ClassMethod FormatId(Type, RowId)
{
	n (Type,RowId)
	s NewId=RowId
	i Type="disp" d
	.s NewId=10000000000000000+RowId
	e  i Type="return" d
	.s NewId=20000000000000000+RowId
	q NewId
}

ClassMethod getObjData(Oeori As %String, type As %String, hvid As %String = "", taskflag As %String = "") As web.DHCSTMService.HRP.Model.DispInfo
{
	n (Oeori,type,hvid,taskflag)
	s obj=##class(web.DHCSTMService.HRP.Model.DispInfo).%New()
	s trtypeInfo=..sssOeoriTrType(Oeori)
	s dispType=$p(trtypeInfo,"^",1)
	i type="disp" d
	.s Qty=1
	.s dispType=$p(trtypeInfo,"^",1)
	e  d
	.s Qty=-1
	.s dispType=$p(trtypeInfo,"^",2)
	s trid=$o(^DHCINTR(0,"TypePointer",dispType,Oeori,0))
	q:(trid="")&&(hvid="") obj
	s Ord=+Oeori,OrdCh=$p(Oeori,"||",2)
	s ori=Ord_"||"_OrdCh
	s BatId="",batno="",barcode=""
	i (trid'="")&&(hvid="") d                      ;普通医嘱
	.s TrInfo=^DHCINTR(trid)
	.s oriDate=$p(TrInfo,"^",2)
	.s:oriDate'="" oriDate=$zd(oriDate,3)
	.s Inclb=$p(TrInfo,"^",7)
	.s Sp=$p(TrInfo,"^",14)
	.s Qty=$p(TrInfo,"^",6)
	.s Qty=-Qty
	.s Inci=$p(Inclb,"||",1),IL=$p(Inclb,"||",2),LB=$p(Inclb,"||",3)
	.q:(Inci="")||(IL="")||(LB="")
	.s Incib=$p(^INCI(Inci,"IL",IL,"LB",LB),"^",1)
	.q:Incib=""
	.s DHCIncib=$o(^DHCINCIB(0,"INCIB",Incib,0))
	.q:DHCIncib=""
	.s BatId=$p(^DHCINCIB(DHCIncib),"^",20)		 ;第三方DetailId
	e  i (trid="")&&(hvid'="") d                 ;跟台高值医嘱
	.i taskflag'="Y" d                              ;实时同步
	..s trid=..FormatId(type,hvid)
	..s batno=$p(^DHCHVMORI(hvid,1),"^",13)
	..s barcode=$p(^DHCHVMORI(hvid,1),"^",24)                             
	..s Inci=$p(^DHCHVMORI(hvid,1),"^",34)
	..s oriDate=$p(^DHCHVMORI(hvid,1),"^",8)
	..s:oriDate'="" oriDate=$zd(oriDate,3)
	..s ingri=$p(^DHCHVMORI(hvid,1),"^",12)
	..s Inclb="",Incib="",IL="",LB="",DHCIncib="",BatId=""
	..i ingri'="" d
	...s Inclb=$p(^DHCINGR(+ingri,"GRI",$p(ingri,"||",2)),"^",1)
	...q:Inclb="" 
	...s IL=$p(Inclb,"||",2),LB=$p(Inclb,"||",3)
	...s Incib=$p($g(^INCI(Inci,"IL",IL,"LB",LB)),"^",1)
	...q:Incib=""
	...s DHCIncib=$o(^DHCINCIB(0,"INCIB",Incib,0))
	...q:DHCIncib=""
	...s BatId=$p(^DHCINCIB(DHCIncib),"^",20)		 ;第三方DetailId
	..;Inci取dhc_itmtrack
	..q:Inci=""
	..s Sp=$p(^DHCHVMORI(hvid,1),"^",21)
	.e  d       
	..s trid=..FormatId(type,hvid)                                 ;任务同步
	..s batno=$p(^DHCHVMORIRET(hvid,1),"^",13)
	..s barcode=$p(^DHCHVMORIRET(hvid,1),"^",24)
	..s Inci=$p(^DHCHVMORIRET(hvid,1),"^",34)
	..s oriDate=$p(^DHCHVMORIRET(hvid,1),"^",8)
	..s:oriDate'="" oriDate=$zd(oriDate,3)
	..s ingri=$p(^DHCHVMORIRET(hvid,1),"^",36)
	..s Inclb="",Incib="",IL="",LB="",DHCIncib="",BatId=""
	..
	..i ingri'="" d
	...s Inclb=$p(^DHCINGR(+ingri,"GRI",$p(ingri,"||",2)),"^",1)
	...q:Inclb="" 
	...s IL=$p(Inclb,"||",2),LB=$p(Inclb,"||",3)
	...s Incib=$p($g(^INCI(Inci,"IL",IL,"LB",LB)),"^",1)
	...q:Incib=""
	...s DHCIncib=$o(^DHCINCIB(0,"INCIB",Incib,0))
	...q:DHCIncib=""
	...s BatId=$p(^DHCINCIB(DHCIncib),"^",20)		 ;第三方DetailId
	..;Inci取dhc_itmtrack
	..q:Inci=""
	..s Sp=$p(^DHCHVMORI(hvid,1),"^",21)
	e  i hvid'="" d                              ;普通高值
	.s batno=$p(^DHCHVMORI(hvid,1),"^",13)
	.s barcode=$p(^DHCHVMORI(hvid,1),"^",24)                             
	.s Inci=$p(^DHCHVMORI(hvid,1),"^",34)
	.s oriDate=$p(^DHCHVMORI(hvid,1),"^",8)
	.s:oriDate'="" oriDate=$zd(oriDate,3)
	.s ingri=$p(^DHCHVMORI(hvid,1),"^",12)
	.s TrInfo=^DHCINTR(trid)
	.s Inclb=$p(TrInfo,"^",7)
	.s Sp=$p(TrInfo,"^",14)
	.s Inci=$p(Inclb,"||",1),IL=$p(Inclb,"||",2),LB=$p(Inclb,"||",3)
	.q:(Inci="")||(IL="")||(LB="")
	.s Incib=$p(^INCI(Inci,"IL",IL,"LB",LB),"^",1)
	.q:Incib=""
	.s DHCIncib=$o(^DHCINCIB(0,"INCIB",Incib,0))
	.q:DHCIncib=""
	.s BatId=$p(^DHCINCIB(DHCIncib),"^",20)		 ;第三方DetailId
	;q:BatId="" obj
	s incicode=$p(^INCI(Inci,1),"^",1)
	s Arcim=$p(^INCI(Inci,1),"^",3)
	s ArcimSub=$p(Arcim,"||",1),ArcimVer=$p(Arcim,"||",2)
	q:(Arcim="")||(ArcimSub="")||(ArcimVer="") obj 
	s ArcCode=$p(^ARCIM(ArcimSub,ArcimVer,1),"^",1)
	s ArcDesc=$p(^ARCIM(ArcimSub,ArcimVer,1),"^",2)
	s AdmId=$p(^OEORD(Ord),"^",1)
	q:AdmId="" obj
	s admloc=$p(^PAADM(AdmId),"^",4)
	s admlocCode="",admlocDesc=""
	i admloc'="" d
	.s admlocCode=admloc		;$p(^CTLOC(admloc),"^",1)
	.s admlocDesc=$p(^CTLOC(admloc),"^",2)
	s Papmi=$p($g(^PAADM(AdmId)),"^",1)
	q:Papmi="" obj
	s AdmNo=$p($g(^PAPER(Papmi,"PAT",1)),"^",1)		;登记号
	s AdmName=$p($g(^PAPER(Papmi,"ALL")),"^",1)
	s Medno=$p($g(^PAPER(Papmi,"PAT",1)),"^",22)
	s BedId=$p($g(^PAADM(AdmId)),"^",73)
	s BedNo=$s(BedId'="":$p($g(^PAWARD(+BedId,"BED",$p(BedId,"||",2))),"^",1),1:"")
	q:'$d(^OEORD(Ord,"I",OrdCh)) obj
	s oeoriRecLoc = $p(^OEORD(Ord,"I",OrdCh,3),"^",6)
	s RecLocCode=oeoriRecLoc		;$s(oeoriRecLoc'="":$p($g(^CTLOC(oeoriRecLoc)),"^",1),1:"")
	s RecLocDesc=$s(oeoriRecLoc'="":$p($g(^CTLOC(oeoriRecLoc)),"^",2),1:"")
	s AdmType="" ;就诊类型
	s DoctorId=$p(^OEORD(Ord,"I",OrdCh,7),"^",1)		;OEORI_UserAdd 医嘱录入人
	s DocLocId=$p(^OEORD(Ord,"I",OrdCh,7),"^",2)
	s DoctorInitial=$p(^SSU("SSUSR",DoctorId),"^",1)
	s DoctorName=$p(^SSU("SSUSR",DoctorId),"^",2)
	s DocLocCode=DocLocId		;$s(DocLocId'="":$p($g(^CTLOC(DocLocId)),"^",1),1:"")
	s DocLocDesc=$s(DocLocId'="":$p($g(^CTLOC(DocLocId)),"^",2),1:"")
	s obj.receiveid=trid  ; 收费流水号  实际台账id 跟台是什么呢？没有台账啊
	s obj.chargedate=oriDate ; 收费日期  
	s obj.adviceno=Oeori ; 医嘱编号   实际执行医嘱ID
	s obj.detailcode=ArcCode  ; 收费项编码
	s obj.detailname=ArcDesc ; 收费项名称
	s obj.invcode=incicode
	s obj.batchno=batno ; 先默认1 ;需要修改
	s obj.onlybatchsn=BatId ; 唯一批次码  应该返回8.4传来的。（查看) 一定要改 
	s obj.barcode=barcode ; 
	s obj.chargenum=Qty ; 收费数量
	s obj.outnum=Qty ; 消耗数量
	s obj.chargeprice=Sp 
	s obj.orderdeptcode=admlocCode ; 开单科室编码
	s obj.orderdeptname=admlocDesc ; 开单科室名称
	s obj.execdeptcode=RecLocCode ; 执行科室编码
	s obj.execdeptname=RecLocDesc ; 执行科室名称
	s obj.doccode=DoctorId ; 医生工号
	s obj.docname=DoctorName ; 医生姓名
	s obj.patientname=AdmName ;患者姓名
	s obj.hospitalno=AdmNo ; 住院号
	s obj.bedno=BedNo ; 病床号
	s obj.doctype="" ; 医嘱类别
	q obj
}

ClassMethod GetBarcodeByOrd(oeori As %String) As %String
{
	n (oeori)
	S oeori=$P(oeori,"||",1,2)  //考虑到医嘱执行记录
	Q:oeori="" ""
	s ord=$p(oeori,"||",1)
	s itm=$p(oeori,"||",2)
	q:(ord="")||(itm="") ""
	s BarCode=$p($G(^OEORD(ord,"I",itm,"DHC")),"^",14)
	q BarCode
}

}
