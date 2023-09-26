Import sqluser

/// Descript:	推送给第三方物流软件的方法
/// 	1.涉及第三方单据明细id的记录,需注意入库/出库/退货/调整-(如果用到)等接口的特殊处理.
/// Creator:	wangjiabin
/// CreateDate:	2021-10-04
Class web.DHCSTMService.HRPJson.HRP2STMClient Extends (%RegisteredObject, web.DHCSTMHUI.StkTypeM, %XML.Adaptor) [ Not ProcedureBlock ]
{

Parameter ServiceType [ Final ] = "HRP";

/// 传递科室信息
/// w ##class(web.DHCSTMService.HRPJson.HRP2STMClient).SendLoc("1,2")
ClassMethod SendLoc(LocIdStr = "")
{
	n (LocIdStr)
	s LocSendObj={}
	s LocArray=[]
	
	s LocId=0
	f  s LocId=$o(^CTLOC(LocId)) q:LocId=""  d
	.q:(LocIdStr'="")&&((","_LocIdStr_",")'[(","_LocId_","))
	.
	.s LocCode=##class(web.DHCSTMService.HRPJson.CommonInfo).GetLoc4Ser(LocId)
	.s LocDesc=$p(^CTLOC(LocId),"^",2)
	.s LocObj={}
	.d LocObj.%Set("dept_code",LocCode)
	.d LocObj.%Set("dept_name",LocDesc)
	.d LocArray.%Push(LocObj)
	
	s Data=LocArray.%ToJSON()
	s DataFormat="02"	;01-xml, 02-json
	s Code="100011"
	s LocSendObj.dataFormat="02"
	s ServiceObj=##class(web.DHCSTMService.HRPJson.StandardServicePort).%New()
	s Result=ServiceObj.syncApi(Code,Data,DataFormat)
	s ResultObj={}.%FromJSON(Result)
	s ResultCode=ResultObj.resultCode
	
	q ResultCode
}

/// 1.普通高值医嘱接口, 100451, 按台帐组织
/// 2.跟台高值接口, 100451, 根据dhc_hvmat_oridm组织
/// 3.低值接口, 100450, 按台帐组织(数据和普通高值基本一致,少一个bar_code)
ClassMethod SendOeori(Oeore, Type)
{
	n (Oeore,Type)
	q:Oeore="" ""
	q:(Type'="Disp")&&(Type'="Return") ""
	
	s PriorCode=##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).PriorityCode(Oeore)
	s:PriorCode'="S" Oeore=$p(Oeore,"||",1,2)
	
	s BarCode=##class(web.DHCSTMHUI.SRVCOMMON).GetBarcodeByOrd(Oeore)
	s DHCIT=""
	i BarCode'="" d
	.s DHCIT=$o(^DHCIT(0,"LABEL",BarCode,0))
	.s:DHCIT="" DHCIT=$o(^DHCIT(0,"ORIGINALCODE",BarCode,0))
	
	s Oeord=$p(Oeore,"||",1),Ch=$p(Oeore,"||",2)
	s ArcimId=$p(^OEORD(Oeord,"I",Ch,1),"^",2)
	s Adm=$P(^OEORD(Oeord),"^",1)
	s AdmLocId=$p(^PAADM(Adm),"^",4)
	s Inci=$o(^INCI(0,"ARCIM_DR",$p(ArcimId,"||",1),""))
	;s HospId=$p(^CTLOC(Adm),"^",22)
	
	s (HVFlag,TableFlag)=""
	i Inci'="" d
	.s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	.s TableFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetTableFlag(Inci)
	
	i (DHCIT'="") d
	.;普通高值, 按条码开医嘱
	.s Code="100451"
	.s OeoriArray=..GetIntrInfo4HRP(Oeore,Type)
	.
	e  i (HVFlag="Y")&&(TableFlag="Y") d
	.;跟台高值, 自动生成条码, 医嘱内没有记录
	.s Code="100451"
	.s OeoriArray=[]			;跟台高值, 后续单独写
	.
	e  d
	.;低值情况
	.s Code="100450"
	.s OeoriArray=..GetIntrInfo4HRP(Oeore,Type)
	
	i OeoriArray.%Size()=0 q ""
	
	s Data=OeoriArray.%ToJSON()
	s DataFormat="02"			;02-表示json
	s ServiceType=..%GetParameter("ServiceType")
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"",ServiceType,$CLASSNAME(),"SendOeori",Code_","_Data)
	
	s ServiceObj=##class(web.DHCSTMService.HRPJson.StandardServicePort).%New()
	s RetJson=ServiceObj.syncApi(Code,Data,DataFormat)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,RetJson,ServiceType)
	s ResultObj={}.%FromJSON(RetJson)
	s ResultCode=ResultObj.resultCode
	
	q ResultCode
}

/// 获取用于传输给HRP的台帐数据
/// 高值,低值-通用
/// Input:		医嘱rowid(低值传入的是Oeore), Type(Disp/Return,分别表示发放/退回)
/// Output:		[]型数据
ClassMethod GetIntrInfo4HRP(Oeore, Type) [ Private ]
{
	n (Oeore,Type)
	
	s OeoriArray=[]
	
	s Ord=$p(Oeore,"||",1),OrdCh=$p(Oeore,"||",2)
	s AdmId=$p(^OEORD(Ord),"^",1)
	s ArcimId=$p(^OEORD(Ord,"I",OrdCh,1),"^",2)
	s RecLocId=$p(^OEORD(Ord,"I",OrdCh,3),"^",6)
	s DoctorId=$p(^OEORD(Ord,"I",OrdCh,7),"^",1)		;OEORI_UserAdd 医嘱录入人
	
	s Arc=$p(ArcimId,"||",1),Ver=$p(ArcimId,"||",2)
	s ArcimCode=$p(^ARCIM(Arc,Ver,1),"^",1)
	s ArcimDesc=$p(^ARCIM(Arc,Ver,1),"^",2)
	
	s Papmi=$p(^PAADM(AdmId),"^",1)
	s AdmLocId=$p(^PAADM(AdmId),"^",4)
	s BedId=$p(^PAADM(AdmId),"^",73)
	s BedNo=$s(BedId'="":$p(^PAWARD(+BedId,"BED",$p(BedId,"||",2)),"^",1),1:"")
	s AdmNo=$p(^PAPER(Papmi,"PAT",1),"^",1)		;登记号
	s AdmName=$p(^PAPER(Papmi,"ALL"),"^",1)
	
	s AdmLocCode=##class(web.DHCSTMService.HRPJson.CommonInfo).GetLoc4Ser(AdmLocId)
	s AdmLocDesc=$p(^CTLOC(AdmLocId),"^",2)
	s RecLocCode=##class(web.DHCSTMService.HRPJson.CommonInfo).GetLoc4Ser(RecLocId)
	s RecLocDesc=$p(^CTLOC(RecLocId),"^",2)
	s DoctorInitial=$p(^SSU("SSUSR",DoctorId),"^",1)	;工号
	s DoctorName=$p(^SSU("SSUSR",DoctorId),"^",2)
	
	s IntrTypeInfo=##class(web.DHCSTMHUI.StkTypeM).sssOeoriTrType(Oeore)
	i Type="Disp" s IntrType=$p(IntrTypeInfo,"^",1)
	e  s IntrType=$p(IntrTypeInfo,"^",2)
	s HRPAdmType=$s((IntrType="MP")||(IntrType="MY"):"1",1:"0")		;0-门诊, 1-住院
	
	s Intr=0
	f  s Intr=$o(^DHCINTR(0,"TypePointer",IntrType,Oeore,Intr)) q:Intr=""  d
	.s IntrInfo=^DHCINTR(Intr)
	.s Date=$p(IntrInfo,"^",2)
	.s Time=$p(IntrInfo,"^",3)
	.s Qty=-$P(IntrInfo,"^",6)			;发放:正数, 退回:负数
	.s Inclb=$p(IntrInfo,"^",7)
	.s UomId=$p(IntrInfo,"^",10)
	.s StockDetailId=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetDetailIdByInclb(Inclb)
	.q:StockDetailId=""					;不是对照批次的,不推送
	.
	.s OeoriDate=$zd(Date,3)
	.s Inci=$p(Inclb,"||",1)
	.s InciCode=$p(^INCI(Inci,1),"^",1)
	.s InciDesc=$p(^INCI(Inci,1),"^",2)
	.s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr(IntrType,Oeore)
	.
	.s Obj={}
	.d Obj.%Set("receive_id",Intr)
	.d Obj.%Set("charge_date",OeoriDate)
	.d Obj.%Set("advice_no",Oeore)
	.d Obj.%Set("detail_code",ArcimCode)
	.d Obj.%Set("detail_name",ArcimDesc)
	.d Obj.%Set("only_batch_sn",StockDetailId)
	.d Obj.%Set("inv_code",InciCode)
	.d Obj.%Set("inv_name",InciDesc)
	.d Obj.%Set("bar_code",HVBarCode)
	.d Obj.%Set("charge_num",Qty)
	.d Obj.%Set("out_num",Qty)
	.d Obj.%Set("order_dept_code",AdmLocCode)
	.d Obj.%Set("order_dept_name",AdmLocDesc)
	.d Obj.%Set("exec_dept_code",RecLocCode)
	.d Obj.%Set("exec_dept_name",RecLocDesc)
	.d Obj.%Set("charge_code","")
	.d Obj.%Set("charge_name","")
	.d Obj.%Set("nurse_code","")
	.d Obj.%Set("nurse_name","")
	.d Obj.%Set("doc_code",DoctorInitial)
	.d Obj.%Set("doc_name",DoctorName)
	.d Obj.%Set("patient_name",AdmName)
	.d Obj.%Set("hospital_no",AdmNo)
	.d Obj.%Set("bed_no",BedNo)
	.d Obj.%Set("doc_type",HRPAdmType)				;0-门诊, 1-住院
	.
	.d OeoriArray.%Push(Obj)
	
	q OeoriArray
}

/// 推送普通材料消耗任务
ClassMethod SendTask() As %String
{
	s st=+$H-1
	s et=+$H-1
	s:st'="" st=$zd(st,3)
	s:et'="" et=$zd(et,3)
	d ..SendDispInfo(st,et)
	q
}

/// Descript:	低值医嘱消减任务
/// Creator:	wangjiabin
/// CreateDate:	2017-07-27
/// Input:		开始日期(Y-m-d), 截止日期(Y-m-d)
/// Return:	
/// receive_id:%String,sell_price:%Float,amount:%Float,bar_code:%String,is_high_value:%String,doc_advice_code:%String,doc_advice_date:%String,patient_code:%String,patient_name:%String,emp_code:%String,doctor_name:%String,charge_date:%String,message:%String,oper_date:%String,bed_no:%String,hospital_no:%String,exec_dept_name:%String,exec_dept_code:%String,order_dept_name:%String,order_dept_code:%String,charge_code:%String,charge_name:%String,only_batch_sn:%String
/// w ##class(web.DHCSTMService.HRPJson.HRP2STMClient).SendDispInfo("2022-05-27","2022-05-27")
ClassMethod SendDispInfo(Stdate As %String, Endate As %String) As %String
{
	n (Stdate,Endate)
	s rs=##class(%ResultSet).%New()
	s rs.ClassName="web.DHCSTMService.HRPJson.HRP2STMClient"
	s rs.QueryName="GetDispInfo"
	s Sc=rs.Execute(Stdate,Endate)
	i $$$ISERR(Sc) q $$$OK
	
	s DispInfoArr=[]
	While rs.Next(.sc) {
		s receiveid=rs.Data("receive_id")			;收费流水号
		s chargedate=rs.Data("charge_date")			;收费日期
		s adviceno=rs.Data("advice_no")				;医嘱编号
		s detailcode=rs.Data("detail_code")			;收费项编码
		s detailname=rs.Data("detail_name")			;收费项名称
		s invcode=rs.Data("inv_code")
		s invname=rs.Data("inv_name")
		s onlybatchsn=rs.Data("only_batch_sn")		;唯一批次码
		s chargenum=rs.Data("charge_num")			;收费数量
		s outnum=rs.Data("out_num")					;消耗数量
		s orderdeptcode=rs.Data("admlocCode")		;开单科室编码
		s orderdeptname=rs.Data("admlocDesc")		;开单科室名称
		s execdeptcode=rs.Data("exec_dept_code")	;执行科室编码
		s execdeptname=rs.Data("exec_dept_name")	;执行科室名称
		s chargecode=rs.Data("charge_code")			;收费员工号
		s chargename=rs.Data("charge_name")			;收费员姓名
		s nursecode=rs.Data("nurse_code")			;护士工号
		s nursename=rs.Data("nurse_name")			;护士姓名
		s doccode=rs.Data("doc_code")				;医生工号
		s docname=rs.Data("doc_name")				;医生姓名
		s patientname=rs.Data("patient_name")		;患者姓名
		s hospitalno=rs.Data("hospital_no")			;住院号
		s bedno=rs.Data("bed_no")					;病床号
		s doctype=rs.Data("doc_type")				;医嘱类别

		s DispInfoObj={}
		d DispInfoObj.%Set("receive_id",receiveid,"string")
		d DispInfoObj.%Set("charge_date",chargedate,"string")
		d DispInfoObj.%Set("advice_no",adviceno,"string")
		d DispInfoObj.%Set("detail_code",detailcode,"string")
		d DispInfoObj.%Set("detail_name",detailname,"string")
		d DispInfoObj.%Set("only_batch_sn",onlybatchsn,"string")
		d DispInfoObj.%Set("inv_code",invcode,"string")
		d DispInfoObj.%Set("inv_name",invname,"string")
		d DispInfoObj.%Set("charge_num",chargenum,"string")
		d DispInfoObj.%Set("out_num",outnum,"string")
		d DispInfoObj.%Set("order_dept_code",orderdeptcode,"string")
		d DispInfoObj.%Set("order_dept_name",orderdeptname,"string")
		d DispInfoObj.%Set("exec_dept_code",execdeptcode,"string")
		d DispInfoObj.%Set("exec_dept_name",execdeptname,"string")
		d DispInfoObj.%Set("charge_code",chargecode,"string")
		d DispInfoObj.%Set("charge_name",chargename,"string")
		d DispInfoObj.%Set("nurse_code",nursecode,"string")
		d DispInfoObj.%Set("nurse_name",nursename,"string")
		d DispInfoObj.%Set("doc_code",doccode,"string")
		d DispInfoObj.%Set("doc_name",docname,"string")
		d DispInfoObj.%Set("patient_name",patientname,"string")
		d DispInfoObj.%Set("hospital_no",hospitalno,"string")
		d DispInfoObj.%Set("bed_no",bedno,"string")
		d DispInfoArr.%Push(DispInfoObj)
	}
	s Data=DispInfoArr.%ToJSON()
	s DataFormat="02"
	s Code="100450"
	s ServiceObj=##class(web.DHCSTMService.HRPJson.StandardServicePort).%New()
	s Result=ServiceObj.syncApi(Code,Data,DataFormat)
	s ResultObj={}.%FromJSON(Result)
	s ResultCode=ResultObj.resultCode
	
	q ResultCode
}

/// Descript:	医嘱台帐信息
/// Creator:	wangjiabin
/// CreateDate:	2017-07-27
/// Input:		开始日期(Y-m-d), 截止日期(Y-m-d)
/// Return:		
/// d ##class(%ResultSet).RunQuery("web.DHCSTMService.HRPJson.HRP2STMClient","GetDispInfo","2022-05-27","2022-05-27")
Query GetDispInfo(StartDate As %String, EndDate As %String) As websys.Query(ROWSPEC = "receive_id:%String,charge_date:%String,advice_no:%String,detail_code:%String,detail_name:%String,inv_code:%String,inv_name:%String,only_batch_sn:%String,bar_code:%String,charge_num:%Float,out_num:%Float,charge_price:%Float,order_dept_code:%String,order_dept_name:%String,exec_dept_code:%String,exec_dept_name:%String,charge_code:%String,charge_name:%String,nurse_code:%String,nurse_name:%String,doc_code:%String,doc_name:%String,patient_name:%String,hospital_no:%String,bed_no:%String,doc_type:%String,is_high_value:%String,only_batch_sn:%String,message:%String,inv_code:%String,inv_desc:%String,admlocCode:%String,admlocDesc:%String")
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
	...s Sp=$p(TrInfo,"^",14)
	...
	...s hvid=$o(^DHCHVMORI(0,"OEORI",Pointer,""))
	...q:hvid'=""
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
	...q:'$d(^INCI(Inci,1))
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
	...s Papmi=$p(^PAADM(AdmId),"^",1)
	...q:Papmi=""
	...s AdmNo=$p(^PAPER(Papmi,"PAT",1),"^",1)		;登记号
	...s AdmName=$p(^PAPER(Papmi,"ALL"),"^",1)
	...;s Medno=$p(^PAPER(Papmi,"PAT",1),"^",22)
	...s BedId=$p(^PAADM(AdmId),"^",73)
	...s BedNo=$s(BedId'="":$p(^PAWARD(+BedId,"BED",$p(BedId,"||",2)),"^",1),1:"")
	...s OrdDate=$p(^OEORD(Ord,"I",OrdCh,3),"^",7)
	...s:OrdDate'="" OrdDate=$zd(OrdDate,3)
	...s AdmType="" ;就诊类型
	...
	...s DoctorId=$p(^OEORD(Ord,"I",OrdCh,7),"^",1)		;OEORI_UserAdd 医嘱录入人
	...s DocLocId=$p(^OEORD(Ord,"I",OrdCh,7),"^",2)
	...s DoctorInitial=$p(^SSU("SSUSR",DoctorId),"^",1)
	...s DoctorName=$p(^SSU("SSUSR",DoctorId),"^",2)
	...s DocLocCode=DocLocId
	...s DocLocDesc=$s(DocLocId'="":$p(^CTLOC(DocLocId),"^",2),1:"")
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

/*
/// 功能：高值耗材数据开医嘱和停医嘱（实时同步）
/// 备注1：判断调用节点 ##class(web.DHCSTMHUI.PCHCOLLSM).Disp .return 等
/// 备注2：防止医嘱审核报错，是否判断8.4的接口返回值。错误日志记录。
/// 参数 医嘱id：oeori,条码：barcode,类型：type：（disp：开医嘱，return：停医嘱)
/// housc 20200416
/// w ##class(web.DHCSTMService.HRPJson.HRP2STMClient).SendHVOeori("8197||2","000000001991","disp")
ClassMethod SendHVOeori(Oeori As %String, barcode As %String, Type As %String, HospId) As %String
{
	n (Oeori,barcode,Type,HospId)
	s SerTypeId=$p(^DHCSTM("ServiceConfig","HRP"_HospId),"^",4)
	
	s Ret=0
	s Ord=$p(Oeori,"||",1),OrdCh=$p(Oeori,"||",2)
	s Oeori=Ord_"||"_OrdCh
	s HvMatArr=[],RowIdStr=""
	
	i (Type="disp") {
		s HvmId="" 
		f  s HvmId=$o(^DHCHVMORI(0,"OEORI",Oeori,HvmId)) q:(HvmId="")||(Ret'=0)  d
		.s HvMatobj=..getObjData(Oeori,Type,HvmId)
		.i HvMatobj.%Get("receive_id")="" s Ret=-6 q
		.d HvMatArr.%Push(HvMatobj)
		.i RowIdStr="" s RowIdStr=HvmId
		.e  s RowIdStr=RowIdStr_","_HvmId
	}elseif(Type="return"){
		s HvmRetId="" 
		f  s HvmRetId=$o(^DHCHVMORIRET(0,"OEORI",Oeori,HvmRetId)) q:(HvmRetId="")||(Ret'=0)  d
		.s HvMatobj=..getObjData(Oeori,Type,HvmRetId)
		.i HvMatobj.%Get("receive_id")="" s Ret=-6 
		.q:Ret'=0
		.d HvMatArr.%Push(HvMatobj)
		.i RowIdStr="" s RowIdStr=HvmRetId
		.e  s RowIdStr=RowIdStr_","_HvmRetId
	}
	q:Ret<0 Ret
	
	s Data=HvMatArr.%ToJSON()
	s DataFormat="02"
	s Code="100451"
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"",SerTypeId,$CLASSNAME(),"SendHVOeori",Code_","_Data)
	
	s ServiceObj=##class(web.DHCSTMService.HRPJson.StandardServicePort).%New()
	s RetJson=ServiceObj.syncApi(Code,Data,DataFormat)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,RetJson,SerTypeId)
	s ResultObj={}.%FromJSON(RetJson)
	s ResultCode=ResultObj.resultCode
	
	i (ResultCode="00")&&(Type="disp") d
	.s Ret=..SetHvSendHRPFlag(RowIdStr)
	e  i (ResultCode="00")&&(Type="return") d
	.s Ret=..SetHvRetSendHRPFlag(RowIdStr)
	
	q Ret
}

/// 功能：普通耗材数据开医嘱和停医嘱（实时同步）
/// 备注1：判断调用节点 ##class(web.DHCSTMHUI.PCHCOLLSM).Disp .return 等
/// 参数 医嘱id：oeori，医嘱类型 type
ClassMethod SendNormalOeori(Oeori As %String, type As %String, HospId) As %String
{
	n (Oeori,type,HospId)
	s SerTypeId=$p(^DHCSTM("ServiceConfig","HRP"_HospId),"^",4)
	s Ret=0	
	s inputparmas=Oeori_","_type
	s NorMalOrdArr=[]
	s NorMalOrdobj=..getObjData(Oeori,type,"")
	i obj.%Get("receive_id")="" s Ret=-6 q Ret
	d NorMalOrdArr.%Push(NorMalOrdobj)
	s Data=NorMalOrdArr.%ToJSON()
	
	s DataFormat="02"
	s Code="100450"
	s ServiceObj=##class(web.DHCSTMService.HRPJson.StandardServicePort).%New()
	s Result=ServiceObj.syncApi(Code,Data,DataFormat)
	s ResultObj={}.%FromJSON(Result)
	s ResultCode=ResultObj.resultCode
	i ResultCode'="0"  d
	.d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"-110",SerTypeId,$ZNAME,"SendNorMalOrdItmByOeori",inputparmas)

	q ResultCode
}

/// Input:		Oeori-医嘱rowid, type-(disp/return二选一), hvid(dhc_hvmat_orditm或Ret,和type字段匹配使用)
/// 			目前的用法, 高值必须传递hvid, 否则按照低值处理了...
ClassMethod getObjData(Oeori As %String, type As %String, hvid As %String = "")
{
	n (Oeori,type,hvid)
	s obj={}
	s trtypeInfo=..sssOeoriTrType(Oeori)
	s dispType=$p(trtypeInfo,"^",1)
	i type="disp" d
	.s dispType=$p(trtypeInfo,"^",1)
	e  d
	.s dispType=$p(trtypeInfo,"^",2)
	s trid=$o(^DHCINTR(0,"TypePointer",dispType,Oeori,0))
	q:(trid="")&&(hvid="") obj
	
	s Ord=+Oeori,OrdCh=$p(Oeori,"||",2)
	q:'$d(^OEORD(Ord,"I",OrdCh)) obj
	s Inclb="",barcode=""
	
	i (trid'="")&&(hvid="") d						;普通医嘱
	.s TrInfo=^DHCINTR(trid)
	.s OeoriDate=$p(TrInfo,"^",2)
	.s Inclb=$p(TrInfo,"^",7)
	.s Qty=$p(TrInfo,"^",6)
	.s Qty=-Qty
	.s:OeoriDate'="" OeoriDate=$zd(OeoriDate,3)
	.
	e  i (trid="")&&(hvid'="") d					;跟台高值医嘱
	.i type="disp" d
	..s trid=..FormatId(type,hvid)
	..s OeoriDate=$p(^DHCHVMORI(hvid,1),"^",8)
	..s ingri=$p(^DHCHVMORI(hvid,1),"^",12)
	..s Qty=$p(^DHCHVMORI(hvid,1),"^",19)			;表内记录的正数
	..s barcode=$p(^DHCHVMORI(hvid,1),"^",24)
	..s Inci=$p(^DHCHVMORI(hvid,1),"^",34)
	..
	..q:Inci=""
	..s:OeoriDate'="" OeoriDate=$zd(OeoriDate,3)
	..
	..i ingri'="" d
	...s Inclb=$p(^DHCINGR(+ingri,"GRI",$p(ingri,"||",2)),"^",1)
	.
	.e  d
	..s trid=..FormatId(type,hvid)
	..s OeoriDate=$p(^DHCHVMORIRET(hvid,1),"^",8)
	..;s HvmId=$p(^DHCHVMORIRET(hvid,1),"^",12)		;dhc_hvmat_orditm
	..s Qty=-$p(^DHCHVMORIRET(hvid,1),"^",19)		;表内记录的正数
	..s barcode=$p(^DHCHVMORIRET(hvid,1),"^",24)
	..s Inci=$p(^DHCHVMORIRET(hvid,1),"^",34)
	..s ingri=$p(^DHCHVMORIRET(hvid,1),"^",36)
	..q:Inci=""
	..s:OeoriDate'="" OeoriDate=$zd(OeoriDate,3)
	..
	..i ingri'="" d
	...s Inclb=$p(^DHCINGR(+ingri,"GRI",$p(ingri,"||",2)),"^",1)
	.
	e  i hvid'="" d									;普通高值
	.s OeoriDate=$p(^DHCHVMORI(hvid,1),"^",2)
	.s ingri=$p(^DHCHVMORI(hvid,1),"^",12)
	.s barcode=$p(^DHCHVMORI(hvid,1),"^",24)
	.s Inci=$p(^DHCHVMORI(hvid,1),"^",34)
	.s:OeoriDate'="" OeoriDate=$zd(OeoriDate,3)
	.
	.s TrInfo=^DHCINTR(trid)
	.s Qty=-$p(TrInfo,"^",6)						;disp-取正数, return-取负数
	.s Inclb=$p(TrInfo,"^",7)
	
	;批次对接Id
	s BatId=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetDetailIdByInclb(Inclb)
	
	s Arcim=$p(^INCI(Inci,1),"^",3)
	s ArcimSub=$p(Arcim,"||",1),ArcimVer=$p(Arcim,"||",2)
	q:(Arcim="")||(ArcimSub="")||(ArcimVer="") obj
	
	s AdmId=$p(^OEORD(Ord),"^",1)
	s oeoriRecLoc=$p(^OEORD(Ord,"I",OrdCh,3),"^",6)
	s DoctorId=$p(^OEORD(Ord,"I",OrdCh,7),"^",1)		;OEORI_UserAdd 医嘱录入人
	s DocLocId=$p(^OEORD(Ord,"I",OrdCh,7),"^",2)
	q:AdmId="" obj
	
	s Papmi=$p(^PAADM(AdmId),"^",1)
	s AdmLocId=$p(^PAADM(AdmId),"^",4)
	q:Papmi="" obj
	
	s AdmNo=$p(^PAPER(Papmi,"PAT",1),"^",1)		;登记号
	s AdmName=$p(^PAPER(Papmi,"ALL"),"^",1)
	s BedId=$p(^PAADM(AdmId),"^",73)
	s BedNo=$s(BedId'="":$p(^PAWARD(+BedId,"BED",$p(BedId,"||",2)),"^",1),1:"")
	
	s AdmLocCode=##class(web.DHCSTMService.HRPJson.CommonInfo).GetLoc4Ser(AdmLocId)
	s AdmLocDesc=$p(^CTLOC(AdmLocId),"^",2)
	s RecLocCode=##class(web.DHCSTMService.HRPJson.CommonInfo).GetLoc4Ser(oeoriRecLoc)
	s RecLocDesc=$p(^CTLOC(oeoriRecLoc),"^",2)
	s DocLocCode=##class(web.DHCSTMService.HRPJson.CommonInfo).GetLoc4Ser(DocLocId)
	s DocLocDesc=$s(DocLocId'="":$p(^CTLOC(DocLocId),"^",2),1:"")
	s DoctorInitial=$p(^SSU("SSUSR",DoctorId),"^",1)	;工号
	s DoctorName=$p(^SSU("SSUSR",DoctorId),"^",2)
	
	s InciCode=$p(^INCI(Inci,1),"^",1)
	s InciDesc=$p(^INCI(Inci,1),"^",2)
	s ArcCode=$p(^ARCIM(ArcimSub,ArcimVer,1),"^",1)
	s ArcDesc=$p(^ARCIM(ArcimSub,ArcimVer,1),"^",2)
	
	d obj.%Set("receive_id",trid)
	d obj.%Set("charge_date",OeoriDate)
	d obj.%Set("advice_no",Oeori)
	d obj.%Set("detail_code",ArcCode)
	d obj.%Set("detail_name",ArcDesc)
	d obj.%Set("only_batch_sn",BatId)
	d obj.%Set("inv_code",InciCode)
	d obj.%Set("inv_name",InciDesc)
	d obj.%Set("bar_code",barcode)
	d obj.%Set("charge_num",Qty)
	d obj.%Set("out_num",Qty)
	d obj.%Set("order_dept_code",AdmLocCode)
	d obj.%Set("order_dept_name",AdmLocDesc)
	d obj.%Set("exec_dept_code",RecLocCode)
	d obj.%Set("exec_dept_name",RecLocDesc)
	d obj.%Set("charge_code","")
	d obj.%Set("charge_name","")
	d obj.%Set("nurse_code","")
	d obj.%Set("nurse_name","")
	d obj.%Set("doc_code",DoctorInitial)
	d obj.%Set("doc_name",DoctorName)
	d obj.%Set("patient_name",AdmName)
	d obj.%Set("hospital_no",AdmNo)
	d obj.%Set("bed_no",BedNo)
	
	q obj
}
*/
ClassMethod GetBarcodeByOrd(oeori As %String) As %String
{
	n (oeori)
	S oeori=$P(oeori,"||",1,2)  //考虑到医嘱执行记录
	Q:oeori="" ""
	s ord=$p(oeori,"||",1)
	s itm=$p(oeori,"||",2)
	q:(ord="")||(itm="") ""
	s BarCode=$p(^OEORD(ord,"I",itm,"DHC"),"^",14)
	q BarCode
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

ClassMethod SetHvSendHRPFlag(RowIdStr As %String) [ Private ]
{
	n (RowIdStr)
	s Ret=0
	&sql(update dhc_hvmat_orditm set ORI_SendHRPFlag='Y' where ORI_RowId in (:RowIdStr))
	i SQLCODE'=0 d
	.s Ret=-11
	q Ret
}

ClassMethod SetHvRetSendHRPFlag(RowIdStr As %String) [ Private ]
{
	n (RowIdStr)
	s Ret=0
	&sql(update DHC_HVMat_OrdItmRet set ORI_RSendHRPFlag='Y' where ORIR_RowId in (:RowIdStr))
	i SQLCODE'=0 d
	.s Ret=-11
	q Ret
}

}
