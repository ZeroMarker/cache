Import sqluser

/// Descript:	物资门诊退回
/// Creator:	lxt
/// CreateDate:	2021-03-01
Class web.DHCSTMHUI.DHCMatReturn Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName = "DHCSTMATDISPRETM";

/// Descript:	查询已发放列表
/// Creator:	lxt
/// CreateDate:	2021-03-01
/// Table:		
/// Input:		查询条件
/// Return：	发放信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCMatReturn","QueryMatReturn",^templxt("QueryMatReturn"))
Query QueryMatReturn(Params As %String) As Query(ROWSPEC = "DispId,PatId,PatNo,PatName,ReqDate,ReqTime,ReqUserName,IncludeReqFalg,DispDate,DispTime") [ SqlProc ]
{
}

ClassMethod QueryMatReturnExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)

	s pStartDate=PJObj.%Get("StartDate")
	s pEndDate=PJObj.%Get("EndDate")
	s pPatNo=PJObj.%Get("PatNo")	//登记号
	s pCardNo=PJObj.%Get("CardNo")	//卡号
	s gUserId=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gHospId=PJObj.%Get("gHospId")
	s:pStartDate'="" pStartDate=..DH2L(pStartDate)
	s:pEndDate'="" pEndDate=..DH2L(pEndDate)
	i (pPatNo="")&&(pCardNo'="") d
	.s pPatNo=##class(web.DHCSTMHUI.DHCMatDisp).GetPatNoByCardNo(pCardNo)
	q:(pCardNo'="")&&(pPatNo="") $$$OK
	
	s Param=gGroupId_"^"_gLocId_"^"_gUserId
	s AppName=..%GetParameter("AppName")
	s AllowRetByNoReq=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"AllowRetByNoReq",Param)
	
	f Date=pStartDate:1:pEndDate d
	.s DispId=""
	.f  s DispId=$o(^DHCMATDISP(0,"DateLoc",Date,gLocId,DispId)) q:DispId=""  d
	..s DispDate=$p(^DHCMATDISP(DispId),"^",2)
	..s:DispDate'="" DispDate=..DL2H(DispDate)
	..s DispTime=$p(^DHCMATDISP(DispId),"^",3)
	..s:DispTime'="" DispTime=..TL2H(DispTime)
	..s DispRetFlag="N"	//暂存申请退回的发放记录ID
	..s IncludeReqFalg="Y"	//是否退费申请
	..s Dispchl=""
	..f  s Dispchl=$o(^DHCMATDISP(DispId,"I",Dispchl)) q:(Dispchl="")!(DispRetFlag="Y")  d
	...s Oeori=$p(^DHCMATDISP(DispId,"I",Dispchl),"^",1)
	...s Adm=$p(^OEORD(+Oeori),"^",1)
	...q:Adm=""
	...s PatId=$p(^PAADM(Adm),"^",1)	//病人ID
	...s PatNo=$p(^PAPER(PatId,"PAT",1),"^",2)
	...q:(pPatNo'="")&&(pPatNo'=PatNo)			//登记号过滤
	...s PatName=$p(^PAPER(PatId,"ALL"),"^",1)
	...s DispQty=$p(^DHCMATDISP(DispId,"I",Dispchl),"^",6)	//发放数量
	...q:DispQty=0
	...s RetQty=+$p(^DHCMATDISP(DispId,"I",Dispchl),"^",9)	//已退回数量
	...s LeftQty=DispQty-RetQty	//剩余数量
	...q:LeftQty=0
	...s PrtId=##class(web.DHCSTMHUI.Common.ServiceCommon).GetOPPrtRowIDByOrdItm(Oeori)
	...s RetQtyStr=##class(web.DHCSTMHUI.Common.ServiceCommon).GetApplyRefundQty(Oeori,PrtId)	//总退费数量^申请退费数量^实际退费数量
	...s ReqQty=+$p(RetQtyStr,"^",2)
	...q:(AllowRetByNoReq'="Y")&&(ReqQty=0)
	...i ReqQty=0 d	//申请数量为0是判断是否展示已发放
	....s ReqQty=LeftQty
	...e  d
	....s IncludeReqFalg="Y"
	...q:ReqQty=0		//申请退费数量
	...//q:ReqQty>LeftQty	//申请退费数量>可申请数量
	...s ReqInfo=..GetRefundMsg(Oeori)
	...s ReqDate=$p(ReqInfo,"^",1)	//退费申请日期
	...s:ReqDate'="" ReqDate=..DL2H(ReqDate)
	...s ReqTime=$p(ReqInfo,"^",2)	//退费申请时间
	...s:ReqTime'="" ReqTime=..TL2H(ReqTime)
	...s ReqUserName=$p(ReqInfo,"^",3)	//退费申请人
	...d OutPutRow1
	...s DispRetFlag="Y"
	
	Quit $$$OK
OutPutRow1
	s Data=$lb(DispId,PatId,PatNo,PatName,ReqDate,ReqTime,ReqUserName,IncludeReqFalg,DispDate,DispTime)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 获取押金模式急诊留观状态	Y:是, N:否
ClassMethod GetStayFlag(Adm As %String) As %String
{
	n (Adm)
	s Flag="N"
	;paymodeflag: 1-押金收费模式 0-普通收费模式
	s PayModeFlag=##class(web.DHCSTMHUI.Common.ServiceCommon).GetStayPayMode("")
	;stayFlag: 1:留观, 2:曾经留观, -1:非留观
	s StayFlag=##class(web.DHCSTMHUI.Common.ServiceCommon).GetStayStatus(Adm)
	;押金模式下急诊留观时,不走退费申请,直接停医嘱
	i (PayModeFlag=1)&&(StayFlag'=-1) s Flag="Y"
	q Flag
}

/// Descript:	获取退费审核(申请)日期\申请人
/// Creator:	lxt
/// CreateDate:	20210301
/// Input:		医嘱明细Rowid
/// return:		最后一次的申请日期^申请人
/// w ##class(web.DHCSTMHUI.Common.ServiceCommon).GetStayStatus()
ClassMethod GetRefundMsg(Oeori)
{
	n (Oeori)
	q:Oeori="" ""
	s OERQRowID="",status="",refDate="",refUser="",refTime=""
	f  s OERQRowID=$o(^DHCOERefundQTY(0,"OEORI",Oeori,OERQRowID),-1) q:OERQRowID=""  d
	.q:'$d(^DHCOERefundQTY(OERQRowID))
	.s status=$p(^DHCOERefundQTY(OERQRowID),"^",4)
	.q:status'=0	//不是申请状态
	.s refDate=$p(^DHCOERefundQTY(OERQRowID),"^",6)
	.s refTime=$p(^DHCOERefundQTY(OERQRowID),"^",7)
	.s refUser=$p(^DHCOERefundQTY(OERQRowID),"^",5)
	.s:refUser'="" refUser=$p(^SSU("SSUSR",refUser),"^",2)
	.q:refDate'=""
	q refDate_"^"_refTime_"^"_refUser
}

/// Descript:	查询已发放明细列表
/// Creator:	lxt
/// CreateDate:	2021-03-01
/// Table:		
/// Input:		查询条件
/// Return：	发放信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCMatReturn","QueryMatReturnDetail",^templxt("QueryMatReturnDetail"))
Query QueryMatReturnDetail(Params As %String) As Query(ROWSPEC = "DispDetailId,Adm,Oeori,InciId,InciCode,InciDesc,Spec,UomId,UomDesc,Sp:%Float,Qty:%Float,LeftQty:%Float,ReqQty:%Float,SpAmt:%Float,LeftSpAmt:%Float,ReqSpAmt:%Float,BatNo,Barcode,ReqFalg") [ SqlProc ]
{
}

ClassMethod QueryMatReturnDetailExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)

	S DispId=PJObj.%Get("DispId")
	s gUserId=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gHospId=PJObj.%Get("gHospId")
	q:(DispId="") $$$OK
	
	s Param=gGroupId_"^"_gLocId_"^"_gUserId
	s AppName=..%GetParameter("AppName")
	s AllowRetByNoReq=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"AllowRetByNoReq",Param)
	
	s Dispchl=""
	f  s Dispchl=$o(^DHCMATDISP(DispId,"I",Dispchl)) q:Dispchl=""  d
	.s Oeori=$p(^DHCMATDISP(DispId,"I",Dispchl),"^",1)
	.s Adm=$p(^OEORD(+Oeori),"^",1)	//就诊ID
	.q:Adm=""
	.s PatId=$p(^PAADM(Adm),"^",1)	//病人ID
	.s PatNo=$p(^PAPER(PatId,"PAT",1),"^",2)
	.s PatName=$p(^PAPER(PatId,"ALL"),"^",1)
	.s DispQty=$p(^DHCMATDISP(DispId,"I",Dispchl),"^",6)	//发放数量
	.q:DispQty=0
	.s RetQty=+$p(^DHCMATDISP(DispId,"I",Dispchl),"^",9)	//已退回数量
	.s LeftQty=DispQty-RetQty	//剩余数量
	.q:LeftQty=0
	.s PrtId=##class(web.DHCSTMHUI.Common.ServiceCommon).GetOPPrtRowIDByOrdItm(Oeori)
	.s RetQtyStr=##class(web.DHCSTMHUI.Common.ServiceCommon).GetApplyRefundQty(Oeori,PrtId)	//总退费数量^申请退费数量^实际退费数量
	.s ReqQty=+$p(RetQtyStr,"^",2)
	.q:(AllowRetByNoReq'="Y")&&(ReqQty=0)
	.s Qty="",ReqFalg=""
	.i ReqQty=0 d	//申请数量为0是判断是否展示已发放
	..s ReqFalg="N"
	..s Qty=""
	.e  d
	..s ReqFalg="Y"
	..i ReqQty>LeftQty s Qty=LeftQty
	..e  s Qty=ReqQty
	.
	.s InciId=$p(^DHCMATDISP(DispId,"I",Dispchl),"^",5)
	.s Sp=$p(^DHCMATDISP(DispId,"I",Dispchl),"^",7)
	.s InciCode=$p(^INCI(InciId,1),"^",1)
	.s InciDesc=$p(^INCI(InciId,1),"^",2)
	.s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
	.s Dsp=$o(^DHCOEDISQTY(0,"OEORI",Oeori,0))
	.s UomId=$p($g(^DHCOEDISQTY(Dsp)),"^",6)	//发放单位
	.s UomDesc=$p($g(^CT("UOM",UomId)),"^",2)
	.s ReqSpAmt=Sp*ReqQty
	.s SpAmt=Sp*Qty
	.s LeftSpAmt=Sp*LeftQty
	.s DispDetailId=DispId_"||"_Dispchl
	.s IntrTypeInfo=..sssOeoriTrType(Oeori)
	.s DispType=$p(IntrTypeInfo,"^",1)
	.s Barcode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr(DispType,Oeori)
	.s BatNo="",DispInclb=""
	.f  s DispInclb=$o(^DHCMATDISP(DispId,"I",Dispchl,"B",DispInclb)) q:(DispInclb="")  d
	..s Inclb=$p(^DHCMATDISP(DispId,"I",Dispchl,"B",DispInclb),"^",1) 
	..s Incib=$p(^INCI($p(Inclb,"||",1),"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1)
	..i BatNo="" s BatNo=$p( ^INCI($p(Incib,"||",1),"IB",$p(Incib,"||",2)),"^",1)
	..e  s BatNo=BatNo_";"_$p( ^INCI($p(Incib,"||",1),"IB",$p(Incib,"||",2)),"^",1)
	.d OutPutRow2
	
	Quit $$$OK
OutPutRow2
	s Data=$lb(DispDetailId,Adm,Oeori,InciId,InciCode,InciDesc,Spec,UomId,UomDesc,Sp,Qty,LeftQty,ReqQty,SpAmt,LeftSpAmt,ReqSpAmt,BatNo,Barcode,ReqFalg)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// w ##class(web.DHCSTMHUI.DHCMatReturn).jsMatReturn(^templxt("jsMatReturn1"),^templxt("jsMatReturn2"))
ClassMethod jsMatReturn(Main As %String, Detail As %String) As %Library.String
{
	n (Main,Detail)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	ts
	s RtnObj=..MatReturn(Main,Detail)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

ClassMethod MatReturn(Main As %String, Detail As %String) As RtnObj
{
	n (Main,Detail)
	s RtnObj=##class(RtnObj).%New()
	
	s MainObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=MainObj.%FromJSON(Main)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")
	
	s DetailObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=DetailObj.%FromJSON(Detail)
	q:Sc'=0 RtnObj.Err(-2,"","明细入参解析失败!")
	
	s gUserId=MainObj.%Get("gUserId")
	s gGroupId=MainObj.%Get("gGroupId")
	s gHospId=MainObj.%Get("gHospId")
	s gLocId=MainObj.%Get("gLocId")
	s Date=$p($h,",",1)
	s Time=$p($h,",",2)
	s AppName=..%GetParameter("AppName")
	
	s MatReturnNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,"",gLocId)
	q:MatReturnNo="" RtnObj.Err(-1,"","退回单号生成失败！")
	
	&sql(insert into DHC_MatDispRet
		(RET_No,RET_Date,RET_Time,RET_SSUSR_DR,RET_CTLOC_DR)
		values
		(:MatReturnNo,:Date,:Time,:gUserId,:gLocId)
	)
	q:SQLCODE'=0 RtnObj.Err(-2,"","保存退回主表失败")
	s RetId=%ROWID
	
	while(RtnObj.success=0){
		s Obj=DetailObj.%Pop()
		q:Obj=""
		s DispDetailId=Obj.%Get("DispDetailId")
		s Adm=Obj.%Get("Adm")
		s Oeori=Obj.%Get("Oeori")
		s InciId=Obj.%Get("InciId")
		s Qty=Obj.%Get("Qty")
		continue:+Qty=0
		s UomId=Obj.%Get("UomId")
		s Sp=Obj.%Get("Sp")
		s SpAmt=Obj.%Get("SpAmt")
		s Barcode=Obj.%Get("Barcode")
		s DispId=+DispDetailId
		s DispChl=$p(DispDetailId,"||",2)
		
		//1.插入退回子表
		s chl=1+$o(^DHCMATDISRET(RetId,"I",""),-1)
		&sql(insert into DHC_MatDispRetItm(RETI_ParRef,RETI_ChildSub,RETI_OEORI_DR,RETI_DSI_DR,RETI_INCI_DR,RETI_Qty,RETI_Sp,RETI_SpAmt)
		values(:RetId,:chl,:Oeori,:DispDetailId,:InciId,:Qty,:Sp,:SpAmt))
		i SQLCODE'=0 d RtnObj.Err(-3,"","更新高值状态失败")
		//s RetItmId=RetId_"||"_chl
	
		//2.更新发放明细表退回数量
		s DispRetQty=$p(^DHCMATDISP(DispId,"I",DispChl),"^",9)+Qty
		&sql(UPDATE DHC_MatDispItm SET DSI_RetQty=:DispRetQty WHERE DSI_RowId=:DispDetailId)
		i SQLCODE'=0 d RtnObj.Err(-4,"","更新发放表退回数量失败")
		
		//3.更新退费申请方法
		s PrtID=##class(web.DHCSTMHUI.Common.ServiceCommon).GetOPPrtRowIDByOrdItm(Oeori)
		s Ret=##class(web.DHCSTMHUI.Common.ServiceCommon).SaveApplyRefundQty(Oeori_"^"_Qty,gUserId,PrtID)
		i Ret'=0 d RtnObj.Err(-5,"","更新退费申请失败")
		
		//4.处理库存、台账等
		i Barcode'="" d	//高值
		.s RtnObj=..ReturnHV(RetId,gUserId,MatReturnNo,Obj)
		e  d	//低值
		.s RtnObj=..ReturnMat(RetId,gUserId,MatReturnNo,Obj)
		
	}
	
	q RtnObj
}

/// retrow, dispiRow, inci, retQty, UserId, barcode
ClassMethod ReturnHV(RetId, UserId, MatReturnNo, Obj) As RtnObj
{
	n (RetId,UserId,MatReturnNo,Obj)
	s RtnObj=##class(RtnObj).%New()
	
	s DispDetailId=Obj.%Get("DispDetailId")
	s Adm=Obj.%Get("Adm")
	s Oeori=Obj.%Get("Oeori")
	s InciId=Obj.%Get("InciId")
	s Qty=Obj.%Get("Qty")
	s UomId=Obj.%Get("UomId")
	s Sp=Obj.%Get("Sp")
	s SpAmt=Obj.%Get("SpAmt")
	s Barcode=Obj.%Get("Barcode")
	s DispId=+DispDetailId
	s DispChl=$p(DispDetailId,"||",2)
	
	s IntrTypeInfo=..sssOeoriTrType(Oeori)
	s DispType=$p(IntrTypeInfo,"^",1)
	s IntrType=$p(IntrTypeInfo,"^",2)
	
	s dhcit=$o(^DHCIT(0,"LABEL",Barcode,0))
	q:dhcit="" RtnObj.Err(-31,"","高值条码不存在","",0)
	
	l +^DHCOEDISPENSING(Oeori):20  e  q RtnObj.Err(-32,"","医嘱锁定失败！")
	
	//1.处理高值状态（不存在跟踪记录的,才调用）
	s isDHCITDetail=$d(^DHCITD(0,"Type",IntrType,"Pointer",Oeori,dhcit))
	i (isDHCITDetail=0) {
		s operData="^"_UserId_"^"_InciId_"^^^"
		s RtnObj=##class(web.DHCSTMHUI.DHCItmTrack).Update(IntrType,Oeori,Barcode,operData)
		i RtnObj.success'=0 d
		.d RtnObj.Err(-33,"","更新高值状态失败")
		.l -^DHCOEDISPENSING(Oeori)
	}
	q:RtnObj.success'=0 RtnObj
	
	//2.更新医嘱状态
	s Ret=##Class(web.DHCSTMHUI.COMMOE).InsDispensing(Oeori,"R",+$h,$p($h,",",2),UserId,IntrType,"",Qty,UomId)
	i Ret'=0 d
	.d RtnObj.Err(-34,"","更新医嘱状态失败")
	.l -^DHCOEDISPENSING(Oeori)
	q:RtnObj.success'=0 RtnObj
	
	//3.记录高值退回信息
	s DataStr=Oeori_"^"_Barcode
	s Ret=##class(web.DHCSTMHUI.HVMatOrdItmRet).Save(DataStr)
	i Ret<0 d
	.d RtnObj.Err(-35,"","记录高值退回信息失败")
	.l -^DHCOEDISPENSING(Oeori)
	q:RtnObj.success'=0 RtnObj
	
	//4.处理库存
	s DispInclbChl=$o(^DHCMATDISP(DispId,"I",DispChl,"B",""))
	s Inclb=$p(^DHCMATDISP(DispId,"I",DispChl,"B",DispInclbChl),"^",1)
	
	s Ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(Inclb,Qty)
	i Ret'=0 d
	.d RtnObj.Err(-36,"","处理库存失败")
	.l -^DHCOEDISPENSING(Oeori)
	q:RtnObj.success'=0

	//5.插入台账
	s PrescNo=$p(^DHCMATDISP(DispId),"^",8)
	s Trid=$o(^DHCINTR(0,"TypePointer",DispType,Oeori,0))
	s Rp=$p(^DHCINTR(Trid),"^",16)
	s RpAmt=Rp*Qty
	s SpAmt=Sp*Qty
	s PrtID=##class(web.DHCSTMHUI.Common.ServiceCommon).GetOPPrtRowIDByOrdItm(Oeori)
	s lstdata=IntrType_"^"_MatReturnNo_"^"_Inclb_"^"_Qty_"^"_UomId_"^"_Sp_"^"_UserId_"^"_Oeori_"^"_Rp_"^"_RpAmt_"^"_SpAmt_"^"_PrtID
	s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(lstdata)
	i RtnObj.success'=0 d
	.d RtnObj.Err(-37,"","处理台账失败")
	.l -^DHCOEDISPENSING(Oeori)
	q:RtnObj.success'=0 RtnObj
	
	//6.对已补录虚库高值进行处理
	s Ret=##class(web.DHCSTMHUI.PCHCOLLSRela).HandleMainLocInfo(Oeori,Barcode)
	i Ret'=0 d
	.d RtnObj.Err(-38,"","处理补录数据失败")
	.l -^DHCOEDISPENSING(Oeori)
	q:RtnObj.success'=0 RtnObj
	
	s DispInclb=DispId_"||"_DispChl_"||"_DispInclbChl
	&sql(update DHC_MatDispItmInclb set DSLB_RetQty=:Qty where %ID=:DispInclb)
	i SQLCODE'=0 d
	.d RtnObj.Err(-39,"","更新明细退回数量失败")
	.l -^DHCOEDISPENSING(Oeori)
	q:RtnObj.success'=0 RtnObj
	
	l -^DHCOEDISPENSING(Oeori)
	q RtnObj
}

/// retrow, dispiRow, inci, retQty, UserId, barcode
ClassMethod ReturnMat(RetId, UserId, MatReturnNo, Obj) As RtnObj
{
	n (RetId,UserId,MatReturnNo,Obj)
	s RtnObj=##class(RtnObj).%New()
	
	s DispDetailId=Obj.%Get("DispDetailId")
	s Adm=Obj.%Get("Adm")
	s Oeori=Obj.%Get("Oeori")
	s InciId=Obj.%Get("InciId")
	s Qty=Obj.%Get("Qty")
	s UomId=Obj.%Get("UomId")
	s Sp=Obj.%Get("Sp")
	s SpAmt=Obj.%Get("SpAmt")
	s DispId=+DispDetailId
	s DispChl=$p(DispDetailId,"||",2)
	s Dsp=$o(^DHCOEDISQTY(0,"OEORI",Oeori,""))
	s UomId=$p(^DHCOEDISQTY(Dsp),"^",6)	;发放单位
	s DispLocId=$p(^DHCMATDISP(DispId),"^",5)
	s HospId=..sssHospId(DispLocId)
	
	s IntrTypeInfo=..sssOeoriTrType(Oeori)
	s DispType=$p(IntrTypeInfo,"^",1)
	s IntrType=$p(IntrTypeInfo,"^",2)
	
	l +^DHCOEDISPENSING(Oeori):20  e  q RtnObj.Err(-32,"","医嘱锁定失败！")
	
	//4.处理库存
	s DispInclbChl="",LeftQty=Qty
	f  s DispInclbChl=$o(^DHCMATDISP(DispId,"I",DispChl,"B",DispInclbChl)) q:(DispInclbChl="")||(LeftQty=0)||(RtnObj.success'=0)  d
	.s DispInclb=DispId_"||"_DispChl_"||"_DispInclbChl
	.s Inclb=$p(^DHCMATDISP(DispId,"I",DispChl,"B",DispInclbChl),"^",1)
	.s DispQty=$p(^DHCMATDISP(DispId,"I",DispChl,"B",DispInclbChl),"^",2)
	.s RetQty=$p(^DHCMATDISP(DispId,"I",DispChl,"B",DispInclbChl),"^",5)
	.i (RetQty+LeftQty)>DispQty d
	..s DelQty=DispQty-RetQty	//本次减掉数量
	..s RetQty=DispQty	//明细退回数量
	.e  d
	..s DelQty=LeftQty
	..s RetQty=RetQty+DelQty
	.&sql(update DHC_MatDispItmInclb set DSLB_RetQty=:RetQty where %ID=:DispInclb)
	.i SQLCODE'=0 d RtnObj.Err(-33,"","更新明细退回数量失败")
	.e  s LeftQty=LeftQty-DelQty
	.s Ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(Inclb,DelQty)
	.i Ret'=0 d RtnObj.Err(-34,"","处理库存失败")
	.s PrescNo=$p(^DHCMATDISP(DispId),"^",8)
	.s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,UomId,HospId)		;批次进价
	.s RpAmt=Rp*DelQty
	.s SpAmt=Sp*DelQty
	.s PrtID=##class(web.DHCSTMHUI.Common.ServiceCommon).GetOPPrtRowIDByOrdItm(Oeori)
	.s lstdata=IntrType_"^"_MatReturnNo_"^"_Inclb_"^"_DelQty_"^"_UomId_"^"_Sp_"^"_UserId_"^"_Oeori_"^"_Rp_"^"_RpAmt_"^"_SpAmt_"^"_PrtID
	.s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(lstdata)
	i RtnObj.success'=0 d
	.l -^DHCOEDISPENSING(Oeori)
	q:RtnObj.success'=0 RtnObj

	//5.更新医嘱状态
	s Ret=##Class(web.DHCSTMHUI.COMMOE).InsDispensing(Oeori,"R",+$h,$p($h,",",2),UserId,IntrType,"",Qty,UomId)
	i Ret'=0 d
	.d RtnObj.Err(-35,"","更新医嘱状态失败")
	
	i RtnObj.success'=0 d
	.l -^DHCOEDISPENSING(Oeori)
	q:RtnObj.success'=0 RtnObj
	
	l -^DHCOEDISPENSING(Oeori)
	q RtnObj
}

/// 查询住院退回主表信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCMatReturn","QueryMatDispRetMain",^templxt("QueryInMatDispMain"))
Query QueryMatDispRetMain(Params As %String) As Query(ROWSPEC = "RowId,DispRetNo,Date,Time,UserId,UserName,LocId,LocDesc") [ SqlProc ]
{
}

ClassMethod QueryMatDispRetMainExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	
	s gHospId=PJObj.%Get("gHospId")
	s gLocId=PJObj.%Get("gLocId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gUserId=PJObj.%Get("gUserId")
	s pStartDate=PJObj.%Get("StartDate")
	s:pStartDate'="" pStartDate=..DH2L(pStartDate)
	s pEndDate=PJObj.%Get("EndDate")
	s:pEndDate'="" pEndDate=..DH2L(pEndDate)
	s pWardLocId=PJObj.%Get("WardLoc")
	s pRetNo=PJObj.%Get("RetNo")
	
	s SqlStr = "select %ID as RowId,"
	s SqlStr=SqlStr_"RET_No as DispRetNo,"
	s SqlStr=SqlStr_"RET_Date as DspRetDate,"
	s SqlStr=SqlStr_"RET_Time as DspRetTime,"
	s SqlStr=SqlStr_"RET_SSUSR_DR as UserId,"
	s SqlStr=SqlStr_"RET_CTLOC_DR as LocId"
	s SqlStr=SqlStr_" from DHC_MatDispRet"
	//s SqlStr=SqlStr_" where RET_CTLOC_DR"_gLocId
	
	s Result=##class(%Library.ResultSet).%New()
	d Result.Prepare(SqlStr)
	s sc=Result.Execute()
	i $$$ISERR(sc) q $$$OK
	While(Result.Next())
	{
		s LocDesc="",UserName=""
		s RowId = Result.Data("RowId")
		s LocId=Result.Data("LocId")
		continue:(gLocId'="")&&(gLocId'=LocId)
		s DispRetNo = Result.Data("DispRetNo")
		continue:(pRetNo'="")&&(pRetNo'=DispRetNo)
		s Date=Result.Data("DspRetDate")
		continue:Date<pStartDate
		continue:Date>pEndDate
		s:Date'="" Date=..DL2H(Date)
		s Time=Result.Data("DspRetTime")
		s:Time'="" Time=..TL2H(Time)
		s UserId=Result.Data("UserId")
		s:UserId'="" UserName=$p(^SSU("SSUSR",UserId),"^",2)
		s:LocId'="" LocDesc=$p(^CTLOC(LocId),"^",2)
		d OutPutDispRetMain
	}
	Quit $$$OK
	
OutPutDispRetMain
	s Data=$lb(RowId,DispRetNo,Date,Time,UserId,UserName,LocId,LocDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCMatReturn","QueryMatDispRetItm",^templxt("QueryInMatDispItm"))
Query QueryMatDispRetItm(Parref As %String) As Query(ROWSPEC = "RowId,Oeori,UomId,UomDesc,InciId,InciCode,InciDesc,Spec,Qty:%Float,Sp:%Float,SpAmt:%Float,DispDate,DispTime") [ SqlProc ]
{
}

ClassMethod QueryMatDispRetItmExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	n (qHandle,Parref)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s SqlStr = "select %ID as RowId,"
	s SqlStr=SqlStr_"RETI_OEORI_DR as Oeori,"
	s SqlStr=SqlStr_"RETI_DSI_DR as MatDispItm,"
	s SqlStr=SqlStr_"RETI_INCI_DR as InciId,"
	s SqlStr=SqlStr_"RETI_Qty as Qty,"
	s SqlStr=SqlStr_"RETI_Sp as Sp,"
	s SqlStr=SqlStr_"RETI_SpAmt as SpAmt "
	s SqlStr=SqlStr_" from DHC_MatDispRetItm where RETI_ParRef="_Parref
	
	s Result=##class(%Library.ResultSet).%New()
	d Result.Prepare(SqlStr)
	s sc=Result.Execute()
	i $$$ISERR(sc) q $$$OK
	While(Result.Next())
	{
		s AdmLocDesc="",UomDesc=""
		s RowId = Result.Data("RowId")
		s Oeori=Result.Data("Oeori")
		s DspId=$o(^DHCOEDISQTY(0,"OEORI",Oeori,0))
		s UomDesc=""
		s UomId=$p(^DHCOEDISQTY(DspId),"^",6)
		s:UomId'="" UomDesc=$p(^CT("UOM",UomId),"^",2)
		s InciId=Result.Data("InciId")
		s InciCode=$p(^INCI(InciId,1),"^",1)
		s InciDesc=$p(^INCI(InciId,1),"^",2)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
		s Qty=Result.Data("Qty")
		s Sp=Result.Data("Sp")
		s SpAmt=Result.Data("SpAmt")
		s MatDispItm=Result.Data("MatDispItm")
		s (DispDate,DispTime)=""
		i +MatDispItm>0 d
		.s DMainId=+MatDispItm
		.s MainInfo=^DHCMATDISP(DMainId)
		.s DispTime=$p(MainInfo,"^",3)
		.s DispDate=$p(MainInfo,"^",2)
		.s DispTime=..TL2H(DispTime)
		.s DispDate=..DL2H(DispDate)
		d OutPutDispRetDetail
	}
	Quit $$$OK
	
OutPutDispRetDetail
	s Data=$lb(RowId,Oeori,UomId,UomDesc,InciId,InciCode,InciDesc,Spec,Qty,Sp,SpAmt,DispDate,DispTime)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
