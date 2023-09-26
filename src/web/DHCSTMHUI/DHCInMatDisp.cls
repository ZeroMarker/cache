Import sqluser

/// Descript:	物资住院发放
/// Creator:	lxt
/// CreateDate:	2021-04-20
Class web.DHCSTMHUI.DHCInMatDisp Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName = "DHCSTINMATDISPM";

/// Descript:	查询门诊待发放就诊列表
/// Creator:	lxt
/// CreateDate:	2021-03-01
/// Table:		
/// Input:		查询条件
/// Return：	门诊发放信息
/// w ##class(web.DHCSTMHUI.DHCInMatDisp).GetInMatDispPid(^templxt("GetInMatDispPid"))
ClassMethod GetInMatDispPid(Params As %String)
{
	n (Params)

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	
	s gHospId=PJObj.%Get("gHospId")
	s gLocId=PJObj.%Get("gLocId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gUserId=PJObj.%Get("gUserId")
	s pStartDate=PJObj.%Get("StartDate")
	s:pStartDate'="" pStartDate=..DH2L(pStartDate)
	s pStartTime=PJObj.%Get("StartTime")
	s:pStartTime'="" pStartTime=..TH2L(pStartTime)
	s:pStartTime="86399" pStartTime=""
	s pEndDate=PJObj.%Get("EndDate")
	s:pEndDate'="" pEndDate=..DH2L(pEndDate)
	s pEndTime=PJObj.%Get("EndTime")
	s:pEndTime'="" pEndTime=..TH2L(pEndTime)
	s:pEndTime="86399" pEndTime=""
	s pWardLocId=PJObj.%Get("WardLoc")
	s pInciId=PJObj.%Get("Inci")
	s pPatNo=PJObj.%Get("PatNo")
	s pDispFlag=PJObj.%Get("DispFlag")
	s PhaLocation=$o(^DHCPL(0,"Loc",gLocId,""))
	s DealOrdFlag=$p($g(^DHCPL(+PhaLocation)),"^",37)
	
	s Pid=..NewPid()
	k ^TMPDHCSTM("InMatLoc",Pid)
	k ^TMPDHCSTM("InMatCol",Pid)
	k ^TMPDHCSTM("InMatDetail",Pid)
	
	s DoseDate="",DspStatus="TC"
	f DoseDate=pStartDate:1:pEndDate d
	.s ArcimId=""
	.f  s ArcimId=$o(^DHCOEDISQTY(0,"RECARC",gLocId,DoseDate,DspStatus,ArcimId)) q:ArcimId=""  d
	..s InciId=$o(^INCI(0,"ARCIM_DR",$p(ArcimId,"||",1),""))
	..q:(pInciId'="")&&(pInciId'=InciId)
	..s IncscId = $p($g(^INCI(InciId, 2)), "^", 2)
	..s Type=$p(^INC("SC", IncscId), "^", 3)
	..q:Type'=..sssCode()
	..s BatSpFlag=..sssBatSpFlag(gHospId,InciId)
	..s DspId=0
	..f  s DspId=$o(^DHCOEDISQTY(0,"RECARC",gLocId,DoseDate,DspStatus,ArcimId,DspId)) q:DspId=""  d
	...q:(BatSpFlag="1")&&('$d(^DHCOEDISQTY(DspId,"I")))
	...s DspData=^DHCOEDISQTY(DspId)
	...s WardLocId=$p(DspData,"^",22)
	...s WardId=$o(^PAWARD(0,"WARD_LocationDR",WardLocId,""))
	...q:WardId=""
	...q:(pWardLocId'="")&&(pWardLocId'=WardLocId)
	...s Oeori=$p(DspData,"^",1)	//医嘱id
	...s AdmId=$p(^OEORD(+Oeori),"^",1)
	...s PatId=$p(^PAADM(AdmId),"^",1)
	...s PatNo=$p(^PAPER(PatId,"PAT",1),"^",2)
	...q:(pPatNo'="")&&(pPatNo'=PatNo)
	...
	...s DoseTime=$p(DspData,"^",20)
	...q:(pStartTime'="")&&(DoseDate=pStartDate)&&(DoseTime'="")&&(DoseTime<pStartTime)
	...q:(pEndTime'="")&&(DoseDate=pEndDate)&&(DoseTime'="")&&(DoseTime>pEndTime)
	...
	...s tEndDate=$p($g(^OEORD(+Oeori,"I",$p(Oeori,"||",2),9)),"^",9)
	...s tEndTime=$p($g(^OEORD(+Oeori,"I",$p(Oeori,"||",2),9)),"^",10)
	...q:(tEndDate=DoseDate)&&(tEndTime<DoseTime)		// 过滤-预停日期及时间小于要求执行记录时间
	...
	...s CheckDspConditonFlag=..CheckDspConditon(DspId)
	...q:CheckDspConditonFlag'="Y"
	...
	...//q:(pLongFlag="Y")&&(PriCode'="S")
	...
	...s DspQty=$p(DspData,"^",5)
	...q:+DspQty=0
	...
	...s BedNo=$p(..GetAdmBedCode(AdmId,WardLocId),"^",2)
	...s UomId=$p(^DHCOEDISQTY(DspId),"^",6)
	...s DspDate=$p(^DHCOEDISQTY(DspId),"^",8)
	...i DspDate="" s DspDate=+$h
	...i $d(^DHCOEDISQTY(DspId,"I")) d
	....s DspSub=0,SpAmt=0
	....f  s DspSub=$o(^DHCOEDISQTY(DspId,"I",DspSub)) q:(+DspSub=0)  d
	.....s DspI=DspId_"||"_DspSub
	.....s Inclb=$p(^DHCOEDISQTY(DspId,"I",DspSub),"^",1)
	.....s Qty=$p(^DHCOEDISQTY(DspId,"I",DspSub),"^",2)
	.....s Sp=$p(^DHCOEDISQTY(DspId,"I",DspSub),"^",4)
	.....s inclbspamt=Qty*Sp
	.....s SpAmt=SpAmt+inclbspamt
	...e  d
	....s Sp=##Class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(InciId,DspDate,UomId,gHospId,"")
	....s SpAmt=Sp*DspQty
	...s SpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(SpAmt,gHospId,2)
	...s WardIndex=$p(^CTLOC(WardLocId),"^",43)_"||"_$p(^CTLOC(WardLocId),"^",2)	//病区科室拼接+名称
	...s ^TMPDHCSTM(Pid,"InMatLoc",WardIndex)=WardLocId
	...s ColIndex=AdmId_"^"_BedNo
	...s ^TMPDHCSTM(Pid,"InMatCol",InciId,ColIndex,DspId)=DspQty_"^"_UomId_"^"_Sp_"^"_SpAmt
	...s ^TMPDHCSTM(Pid,"InMatDetail",WardIndex_"^"_AdmId,DoseDate_"^"_Oeori_"^"_DspId)=WardLocId_"^"_InciId_"^"_DspQty_"^"_UomId_"^"_Sp_"^"_SpAmt_"^"_BedNo	
	q Pid
}

ClassMethod CheckDspConditon(DspId) As %Library.String
{
	n (DspId)
	s DspData=^DHCOEDISQTY(DspId)
	s Oeori=$p(DspData,"^",1)	//医嘱id
	s Oeore=$p(DspData,"^",3)	//执行记录id
	s OrdId=+Oeori
	s OrdItm=+$p(Oeori,"||",2)
	s AdmId=$p(^OEORD(OrdId),"^",1)
	s AdmType=$p($g(^PAADM(AdmId)),"^",2)
	q:AdmType'="I" "N"	//过滤非住院
	
	s LocId=$p(^DHCOEDISQTY(DspId),"^",24)
	s PhaLocation=$o(^DHCPL(0,"Loc",LocId,""))
	//q:PhaLocation="" "N"
	s DealOrdFlag=$p($g(^DHCPL(+PhaLocation)),"^",37)
	
	//过滤执行记录停止
	q:..GetOrdState(Oeore)="N" "N"
	
	//过滤-医生科室
	s DocLocId=$p(^OEORD(OrdId,"I",OrdItm,7),"^",2)
	//q:..DoctorLocRefuse(LocId,DocLocId)=1 "N"
	
	//过滤-自备
	s PriorityId=$p(^OEORD(OrdId,"I",OrdItm,1),"^",8) 
	q:PriorityId="" "N"
	s PriCode=$p($g(^OECPR(+PriorityId)),"^",1)
	q:$ZCVT(PriCode,"U")["OM" "N"
	
	//过滤-护士审核
	//s ConfirmFlag=$p($g(^DHCOEDISQTY(DspId)),"^",17)
	//q:ConfirmFlag'="Y" "N"
	
	// 过滤-医嘱处理
	s SeeType=""
	i DealOrdFlag="Y" d
	.s SeeType=$p($g(^OEORD(OrdId,"I",OrdItm,"NUR")),"^",7)
	q:(SeeType'="")&&(SeeType'="A")&&(SeeType'="F")
	
	// 过滤-最终结算
	s ArcimId=$p(^OEORD(OrdId,"I",OrdItm,1),"^",2)
	s ArcCatId=$P($g(^ARCIM(+ArcimId,+$p(ArcimId,"||",2),1)),"^",10)
	q:ArcCatId="" "N"
	
	s ArcItmCatCode=$p($g(^ARC("IC",+ArcCatId)),"^",1)
	i '$d(GetInDispWardCat("AmtFlag",AdmId_"^"_ArcCatId_"^"_PriCode)) d
	.s AmtFlag=..IfCollectDrugAllowed(AdmId,ArcCatId_"^"_PriCode)
	.s GetInDispWardCat("AmtFlag",AdmId_"^"_ArcCatId_"^"_PriCode)=AmtFlag
	e  s AmtFlag=GetInDispWardCat("AmtFlag",AdmId_"^"_ArcCatId_"^"_PriCode)
	q:AmtFlag=0 "N"
	
	// 过滤-拒绝发药
	//s stdfId=$o(^STDF("DODIS",dspId,""))
	//q:stdfId'="" "N"

	q "Y"
}

/// Description:获取医嘱状态,判断是否可以发放
/// Input:医嘱执行表ID
/// Output:N 不可以  1 可以
ClassMethod GetOrdState(OrdExeRowid) As %String
{
	s Ord=$p(OrdExeRowid,"||",1)
	s Chl=$p(OrdExeRowid,"||",2)
	s Sub=$p(OrdExeRowid,"||",3)
	
	q:Ord="" "N"
	q:Chl="" "N"
	q:'$d(^OEORD(Ord)) "N"
	q:'$d(^OEORD(Ord,"I",Chl,"X",Sub,"BILL")) "N"
	
	s OrderStatusDr=$p(^OEORD(Ord,"I",Chl,"X",Sub,"BILL"),"^",1)		;医嘱状态
	q:OrderStatusDr="" "N"
	
	s OeFlag=$p(^OEC("OSTAT",OrderStatusDr),"^",1)		;医嘱核实、未核实、停止状态 
	q:(OeFlag'="V")&(OeFlag'="E") "N"				;执行记录的医嘱状态为停止的不发药
	
	s OreStatusDr=$p(^OEORD(Ord,"I",Chl,"X",Sub),"^",16)  ;护士执行状态
	q:OreStatusDr="" "Y"
	
	s AdminStatus=$p(^OEC("STAT",OreStatusDr),"^",1)
	q:AdminStatus="D" "N"
	
	q "Y"
}

/// Descriprtion:判断是否医特殊科室
/// Input:phaloc -药房科室, doctorloc -医生科室
/// Output: 1:拒绝的医生科室 0:非拒绝的医生科室
/// Table:CT_LocLinkLocation
ClassMethod DoctorLocRefuse(phaloc, doctorloc)
{
	n (phaloc,doctorloc)
	&sql(select * from CT_LocLinkLocation where link_parref=:phaloc and link_ctloc_dr=:doctorloc)
	q:'SQLCODE 1
	q 0
}

/// 是否允许发药,此处根据住院状态和计费点设置判断
/// returnvalue : 0  - 不允许，1 - 允许
ClassMethod IfCollectDrugAllowed(AdmId As %String, OrdItmCat As %String) As %String
{
	n (AdmId,OrdItmCat)
	s Result=1
	s FeePoint=##class(web.DHCSTMHUI.Common.ServiceCommon).GetFeePoint(OrdItmCat)	//0-开医嘱计费 1-发药计费
	q:(FeePoint="")!(FeePoint=0) Result
	s status=##class(web.DHCSTMHUI.Common.ServiceCommon).GetCurrentAdmStatus(AdmId)
	i status=0 d
	.s result=0
	q result
}

/// description: 根据就诊Id获取床号
/// tables:		 PA_Adm,PA_AdmTransaction
/// 1.婴儿床号会变,需取转科记录
/// 2.只要离开原床位,视为空
/// w ##class(web.DHCSTMHUI.DHCInMatDisp).GetAdmBedCode(4136)
/// input:		 admId(就诊Id),wardLocId(打包表DSPAdmLocDR,为空取当前床位)
/// output:		 床位Id^床位代码
ClassMethod GetAdmBedCode(admId, dspWardLocId = "")
{
	s dspWardId=$s(dspWardLocId'="":$o(^PAWARD(0,"WARD_LocationDR",dspWardLocId,"")),1:"")
	q:+admId=0 ""
	s admBedId=$p(^PAADM(admId),"^",73)
	q:admBedId="" ""
	s admWardId=$p(admBedId,"||",1)
	q:(dspWardId'="")&&(dspWardId'=admWardId) "" // 打包表记录病区与当前病区不一致时,返回空
	s bedCode=""
	s montherAdmId=$p(^PAADM(admId),"^",75) // 关联母亲就诊,不为空视为婴儿
	i montherAdmId'="" d
	.s transSub=""
	.f  s transSub = $O(^PAADM(admId,"TRANS",transSub),-1) q:(transSub="")!($g(bedId)'="")  d
	..s bedId=$p(^PAADM(admId,"TRANS",transSub),"^",8)
	..q:bedId=""
	..s bedCode=$p(^PAADM(admId,"TRANS",transSub),"^",33)
	q:(montherAdmId'="")&&(dspWardId'="")&&(+bedId'=dspWardId) ""
	q:montherAdmId'="" bedId_"^"_bedCode
	// 非婴儿保持原样
	s bedId=$p(^PAADM(admId),"^",73)
	i bedId'=""  s bedCode=$p($g(^PAWARD(+$p(bedId,"||",1),"BED",+$p(bedId,"||",2))),"^",1)
	q bedId_"^"_bedCode
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCInMatDisp","QueryInMatDisp",^templxt("QueryInMatDisp"))
Query QueryInMatDisp(Params As %String) As Query(ROWSPEC = "Pid,WardLocId,WardLocDesc") [ SqlProc ]
{
}

ClassMethod QueryInMatDispExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)

	s Pid=PJObj.%Get("Pid")
	s Sub=""
	f  s Sub=$o(^TMPDHCSTM(Pid,"InMatLoc",Sub)) q:Sub=""  d
	.s WardLocId=$p(^TMPDHCSTM(Pid,"InMatLoc",Sub),"^",1)
	.s WardLocDesc=$p(^CTLOC(WardLocId),"^",2)
	.d OutPutRow1
	
	Quit $$$OK
OutPutRow1
	s Data=$lb(Pid,WardLocId,WardLocDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCInMatDisp","QueryInMatDispCol",44391,21,^templxt("QueryInMatDispCol1"))
Query QueryInMatDispCol(Pid As %String, WardLocIdStr As %String, Params As %String) As Query(ROWSPEC = "InciId,InciCode,InciDesc,Spec,QtyBedStr,UomDesc,Sp:%Float,ColSpAmt:%Float,StkBin,ManfDesc,AvaQty:%Float,SumQtyTotal:%Float") [ SqlProc ]
{
}

ClassMethod QueryInMatDispColExecute(ByRef qHandle As %Binary, Pid As %String, WardLocIdStr As %String, Params As %String) As %Status
{
	n (qHandle,Pid,WardLocIdStr,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	
	s gHospId=PJObj.%Get("gHospId")
	s gLocId=PJObj.%Get("gLocId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gUserId=PJObj.%Get("gUserId")
	
	s InciId=""
	f  s InciId=$o(^TMPDHCSTM(Pid,"InMatCol",InciId)) q:InciId=""  d
	.s QtyBedStr="",Sp=0,ColSpAmt=0,UomId="",UomDesc="",SumQtyTotal=0
	.s Sub="",count2=0
	.f  s Sub=$o(^TMPDHCSTM(Pid,"InMatCol",InciId,Sub)) q:Sub=""  d
	..s AdmId=$p(Sub,"^",1)
	..s BedNo=$p(Sub,"^",2)
	..s DspId="",SumQty=0,count3=0
	..f  s DspId=$o(^TMPDHCSTM(Pid,"InMatCol",InciId,Sub,DspId)) q:DspId=""  d
	...s WardLocId=$p(^DHCOEDISQTY(DspId),"^",22)
	...q:(WardLocIdStr'="")&&((","_WardLocIdStr_",")'[(","_WardLocId_","))
	...s Qty=$p(^TMPDHCSTM(Pid,"InMatCol",InciId,Sub,DspId),"^",1)
	...s UomId=$p(^TMPDHCSTM(Pid,"InMatCol",InciId,Sub,DspId),"^",2)
	...s UomDesc=$p(^CT("UOM",UomId),"^",2)
	...s Sp=$p(^TMPDHCSTM(Pid,"InMatCol",InciId,Sub,DspId),"^",3)
	...s SpAmt=$p(^TMPDHCSTM(Pid,"InMatCol",InciId,Sub,DspId),"^",4)
	...s SumQty=SumQty+Qty
	...s ColSpAmt=ColSpAmt+SpAmt
	...s count3=count3+1
	..q:count3=0
	..s count2=count2+1
	..s SumQtyTotal=SumQtyTotal+SumQty ;合计数量
	..s QtyBed=SumQty_"/"_BedNo
	..i QtyBedStr="" s QtyBedStr=QtyBed
	..e  s QtyBedStr=QtyBedStr_","_QtyBed
	.q:count2=0
	.s InciCode=$p(^INCI(InciId,1),"^",1)
	.s InciDesc=$p(^INCI(InciId,1),"^",2)
	.
	.s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
	.s StkBin=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetInciBinStr(InciId),":",2)
	.s ManfDesc=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(InciId),"^",3)
	.s AvaQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetAvaQty(gLocId,InciId,UomId)
	.
	.d OutPutRow2
	
	Quit $$$OK
OutPutRow2
	s Data=$lb(InciId,InciCode,InciDesc,Spec,QtyBedStr,UomDesc,Sp,ColSpAmt,StkBin,ManfDesc,AvaQty,SumQtyTotal)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCInMatDisp","QueryInMatDispDetail",22783,7,^templxt("QueryInMatDispDetail1"))
Query QueryInMatDispDetail(Pid As %String, WardLocIdStr As %String, Params) As Query(ROWSPEC = "DspId,AdmLocId,AdmLocDesc,WardLocId,AdmId,BedNo,PatName,PatNo,Oeori,InciId,InciCode,InciDesc,Spec,Qty,UomId,UomDesc,Sp,SpAmt,OeoriFlag,StkBin,ManfDesc,AvaQty,DoseDate,DoseTime,PatAge,PatSex,DiagDesc,PriorityDesc") [ SqlProc ]
{
}

ClassMethod QueryInMatDispDetailExecute(ByRef qHandle As %Binary, Pid As %String, WardLocIdStr As %String, Params) As %Status
{
	n (qHandle,Pid,WardLocIdStr,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	
	s gHospId=PJObj.%Get("gHospId")
	s gLocId=PJObj.%Get("gLocId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gUserId=PJObj.%Get("gUserId")
	
	s AdmSub=""
	f  s AdmSub=$o(^TMPDHCSTM(Pid,"InMatDetail",AdmSub)) q:AdmSub=""  d
	.s AdmId=$p(AdmSub,"^",2)
	.s AdmLocId=$p(^PAADM(AdmId),"^",4)
	.s AdmLocDesc=$p(^CTLOC(AdmLocId),"^",2)
	.s PatObj=##class(web.DHCSTMHUI.Common.AdmInfo).GetPatientInfoByAdm(AdmId)
	.s PatId=PatObj.PatId
	.s PatName=PatObj.PatName
	.s PatNo=PatObj.PatNo
	.s PatAge=PatObj.PatAge
	.s PatSex=PatObj.PatSex
	.s AdmObj=##class(web.DHCSTMHUI.Common.AdmInfo).GetAdmInfo(AdmId)
	.s DiagDesc=AdmObj.DiagDesc
	.s DspSub=""
	.f  s DspSub=$o(^TMPDHCSTM(Pid,"InMatDetail",AdmSub,DspSub)) q:DspSub=""  d
	..s DoseDate=$p(DspSub,"^",1)
	..s Oeori=$p(DspSub,"^",2)
	..s DspId=$p(DspSub,"^",3)
	..s DoseTime=$p(^DHCOEDISQTY(DspId),"^",20)
	..s DetailData=^TMPDHCSTM(Pid,"InMatDetail",AdmSub,DspSub)
	..s WardLocId=$p(DetailData,"^",1)
	..s InciId=$p(DetailData,"^",2)
	..s Qty=$p(DetailData,"^",3)
	..s UomId=$p(DetailData,"^",4)
	..s Sp=$p(DetailData,"^",5)
	..s SpAmt=$p(DetailData,"^",6)
	..s BedNo=$p(DetailData,"^",7)
	..q:(WardLocIdStr'="")&&((","_WardLocIdStr_",")'[(","_WardLocId_","))
	..s OrdId=+Oeori
	..s OrdItm=$p(Oeori,"||",2)
	..s PriorityId=$p(^OEORD(OrdId,"I",OrdItm,1),"^",8)
	..s PriorityDesc=$p($g(^OECPR(+PriorityId)),"^",2)
	..s OeoriFlag=$p(^OEC("OSTAT",$p(^OEORD(OrdId,"I",OrdItm,1),"^",13)),"^",1)
	..s InciCode=$p(^INCI(InciId,1),"^",1)
	..s InciDesc=$p(^INCI(InciId,1),"^",2)
	..s UomDesc=$p(^CT("UOM",UomId),"^",2)
	..s RecLocId=+$p(^OEORD(OrdId,"I",OrdItm,3),"^",6)
	..s Incil=InciId
	..s il=$o(^INCI("IL_LOC",RecLocId,InciId,""))
	..s:il'="" Incil=InciId_"||"_il
	..s StkBin=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetInciBinStr(Incil),":",2)
	..s ManfDesc=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(InciId),"^",3)
	..s AvaQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetAvaQty(RecLocId,InciId,UomId)
	..s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
	..s:DoseDate'="" DoseDate=..DL2H(DoseDate)
	..s:DoseTime'="" DoseTime=..TL2H(DoseTime)
	..d OutPutRow3
	
	Quit $$$OK
OutPutRow3
	s Data=$lb(DspId,AdmLocId,AdmLocDesc,WardLocId,AdmId,BedNo,PatName,PatNo,Oeori,InciId,InciCode,InciDesc,Spec,Qty,UomId,UomDesc,Sp,SpAmt,OeoriFlag,StkBin,ManfDesc,AvaQty,DoseDate,DoseTime,PatAge,PatSex,DiagDesc,PriorityDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// w ##class(web.DHCSTMHUI.DHCInMatDisp).jsInMatDisp(^templxt("jsInMatDisp1"),^templxt("jsInMatDisp2"))
ClassMethod jsInMatDisp(Main As %String, Detail As %String) As %Library.String
{
	n (Main,Detail)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	ts
	s RtnObj=..InMatDisp(Main,Detail)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

ClassMethod InMatDisp(Main As %String, Detail As %String) As RtnObj
{
	n (Main,Detail)
	s RtnObj=##class(RtnObj).%New()
	
	s MainObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=MainObj.%FromJSON(Main)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")
	
	s DetailObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=DetailObj.%FromJSON(Detail)
	q:Sc'=0 RtnObj.Err(-2,"","明细入参解析失败!")
	
	s gHospId=MainObj.%Get("gHospId")
	s gGroupId=MainObj.%Get("gGroupId")
	s gLocId=MainObj.%Get("gLocId")
	s gUserId=MainObj.%Get("gUserId")
	s Pid=MainObj.%Get("Pid")
	s WardLocIdStr=MainObj.%Get("WardLocIdStr")
	
	s AppName=..%GetParameter("AppName")
	s Date=+$h
	s Time=$p($h,",",2)
	
	while(RtnObj.success=0){
		s Obj=DetailObj.%Pop()
		q:Obj=""
		s DspId=Obj.%Get("DspId")
		s Oeori=Obj.%Get("Oeori")
		s DoseDate=Obj.%Get("DoseDate")
		s BedNo=Obj.%Get("BedNo")
		s InciId=Obj.%Get("InciId")
		s DspQty=Obj.%Get("Qty")
		s UomId=Obj.%Get("UomId")
		s Sp=Obj.%Get("Sp")
		s SpAmt=Obj.%Get("SpAmt")
		s WardLocId=Obj.%Get("WardLocId")
		s AdmId=Obj.%Get("AdmId")
		s:DoseDate'="" DoseDate=..DH2L(DoseDate)
		s DspStatus=$p(^DHCOEDISQTY(DspId),"^",7)
		continue:DspStatus'="TC"
		
		s ^TMPDHCSTM(Pid,"InMatSave",WardLocId,DspId)=AdmId_"^"_Oeori_"^"_DoseDate_"^"_BedNo_"^"_InciId_"^"_DspQty_"^"_UomId_"^"_Sp_"^"_SpAmt
		
	}
	
	s WardLocId="",MainIdStr=""
	f  s WardLocId=$o(^TMPDHCSTM(Pid,"InMatSave",WardLocId))  q:(WardLocId="")||(RtnObj.success'=0)  d
	.s MatDispNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,"",gLocId)
	.i MatDispNo="" d RtnObj.Err(-2,"","发放单号生成失败！")
	.&sql(insert into DHC_InMatDisp(IDS_No,IDS_Date,IDS_Time,IDS_SSUSR_DR,IDS_CTLOC_DR,IDS_WardLoc_DR)
		values(:MatDispNo,:Date,:Time,:gUserId,:gLocId,:WardLocId))
	.i SQLCODE'=0 d RtnObj.Err(-3,"","发放主单保存失败！")
	.s MainId=%ROWID
	.i MainIdStr="" s MainIdStr=MainId
	.e  s MainIdStr=MainIdStr_","_MainId
	.s DspId="",chl=0
	.f  s DspId=$o(^TMPDHCSTM(Pid,"InMatSave",WardLocId,DspId))  q:(DspId="")||(RtnObj.success'=0)  d
	..s Data=^TMPDHCSTM(Pid,"InMatSave",WardLocId,DspId)
	..s AdmId=$p(Data,"^",1)
	..s Oeori=$p(Data,"^",2)
	..s DoseDate=$p(Data,"^",3)
	..s BedNo=$p(Data,"^",4)
	..s InciId=$p(Data,"^",5)
	..s DspQty=$p(Data,"^",6)
	..s UomId=$p(Data,"^",7)
	..s Sp=$p(Data,"^",8)
	..s SpAmt=$p(Data,"^",9)
	..s AdmLocId=$p(^PAADM(AdmId),"^",4)
	..s Ord=+Oeori
	..s Itm=$p(Oeori,"||",2)
	..s OeoriFlag=$p(^OEORD(Ord,"I",Itm,1),"^",13)
	..s chl=chl+1
	..&sql(insert into DHC_InMatDispItm(IDSI_ParRef,IDSI_ChildSub,IDSI_ADM_DR,IDSI_ADMLOC_DR,IDSI_OEORI_DR,IDSI_DSP_DR,IDSI_BedNo,IDSI_DoseDate,IDSI_OriStatus,IDSI_INCI_DR,IDSI_Qty,IDSI_Sp,IDSI_SpAmt)
		values(:MainId,:chl,:AdmId,:AdmLocId,:Oeori,:DspId,:BedNo,:DoseDate,:OeoriFlag,:InciId,:DspQty,:Sp,:SpAmt))
	..i SQLCODE'=0 d RtnObj.Err(-4,"","发放明细保存失败！")
	..s DetailId=%ROWID
	..s BatSpFlag=..sssBatSpFlag(gHospId,InciId)
	..i BatSpFlag=1 d	//批次价
	...s RtnObj=..InDispMatBat(DetailId)
	..e  d	//统一价
	...s RtnObj=..InDispMat(DetailId)
	
	i RtnObj.success=0 s RtnObj.rowid=MainIdStr
	q RtnObj
}

ClassMethod InDispMatBat(DetailId) As RtnObj
{
	n (DetailId)
	s RtnObj=##class(RtnObj).%New()
	s ReInsertFlag="N"
	
	s MainId=$p(DetailId,"||",1)
	s Detailchl=$p(DetailId,"||",2)
	s MainInfo=^User.DHCInMatDispD(MainId)
	
	s No=$lg(MainInfo,2)
	s UserId=$lg(MainInfo,5)
	s RecLocId=$lg(MainInfo,6)
	s WardLocId=$lg(MainInfo,7)
	
	s DetailInfo=^User.DHCInMatDispD(MainId,"ChildDHCInMatDispItm",Detailchl)
	s AdmId=$lg(DetailInfo,2)
	s AdmLocId=$lg(DetailInfo,3)
	s Oeori=$lg(DetailInfo,4)
	s DspId=$lg(DetailInfo,5)
	s InciId=$lg(DetailInfo,9)
	s DspQty=$lg(DetailInfo,10)
	s Sp=$lg(DetailInfo,11)
	s SpAmt=$lg(DetailInfo,12)
	s UomId=$p(^DHCOEDISQTY(DspId),"^",6)
	s Oeore=$p(^DHCOEDISQTY(DspId),"^",3)
	s PriorCode=##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).PriorityCode(Oeori)
	s:PriorCode'="S" Oeore=Oeori
	//加锁
	l +^DHCINCIL(RecLocId,InciId):10  e  q RtnObj.Err(-12,"","库存锁定失败！")
	
	s IntrType="MDP"	//住院发放
	i ReInsertFlag="N" d
	.s DspSub=0,TemDspSub=0
	.s TemDspSub=$o(^DHCOEDISQTY(DspId,"I",TemDspSub))
	.s Sp=$p(^DHCOEDISQTY(DspId,"I",TemDspSub),"^",4)
	.s DspSub=0,chl=0
	.f  s DspSub=$o(^DHCOEDISQTY(DspId,"I",DspSub)) q:(+DspSub=0)||(RtnObj.success'=0)  d
	..s DspI=DspId_"||"_DspSub
	..s Inclb=$p(^DHCOEDISQTY(DspId,"I",DspSub),"^",1)
	..s Qty=$p(^DHCOEDISQTY(DspId,"I",DspSub),"^",2)
	..s Rp=$p(^DHCOEDISQTY(DspId,"I",DspSub),"^",3)
	..s RpAmt=Qty*Rp
	..s SpAmt=Qty*Sp
	..s chl=chl+1
	..&sql(insert into DHC_InMatDispInclb(IDSLB_ParRef,IDSLB_ChildSub,IDSLB_INCLB_DR,IDSLB_DSPI_DR,
		IDSLB_Qty,IDSLB_Sp,IDSLB_SpAmt)
		values (:DetailId,:chl,:Inclb,:DspI,:Qty,:Sp,:SpAmt))
	..i SQLCODE'=0 d RtnObj.Err(-12,"","发放明细保存失败！") q
	..s DetailLB=%ROWID
	..s Qty=-Qty
	..s RpAmt=-RpAmt
	..s SpAmt=-SpAmt
	..//清在途
	..;s ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdInclbResQty(Inclb,Qty)
	..;i ret'=0 d RtnObj.Err(-13,"","清除在途失败！")
	..s ReservedObj={}
	..s ReservedObj.Type="DspBatch",ReservedObj.Pointer=DspI,ReservedObj.Inclb=Inclb,ReservedObj.Qty=Qty
	..s ReservedParams=ReservedObj.%ToJSON()
	..s RtnObj=##class(web.DHCSTMHUI.MATReservedDetail).SetReservedDetail(ReservedParams)
	..q:RtnObj.success<0
	..
	..//处理库存
	..s ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(Inclb,Qty)
	..i ret'=0 d RtnObj.Err(-14,"","处理库存失败")
	..s Data=IntrType_"^^"_Inclb_"^"_Qty_"^"_UomId_"^"_Sp_"^"_UserId_"^"_DetailLB_"^"_Rp_"^"_RpAmt_"^"_SpAmt
	..s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(Data) //处理台帐
	i RtnObj.success'=0 d
	.l -^DHCINCIL(RecLocId,InciId)
	q:RtnObj.success'=0 RtnObj
	
	//处理打包表
	s err=##Class(web.DHCSTMHUI.COMMOE).UpdDispensingByOeori(Oeore,"C",+$h,$p($h,",",2),UserId,IntrType,DetailId)
	i err'=0 d
	.d RtnObj.Err(-15,"","更新医嘱发放状态失败！")
	l -^DHCINCIL(RecLocId,InciId)
	q RtnObj
}

ClassMethod InDispMat(DetailId) As RtnObj
{
	n (DetailId)
	s RtnObj=##class(RtnObj).%New()
	
	s MainId=$p(DetailId,"||",1)
	s Detailchl=$p(DetailId,"||",2)
	s MainInfo=^User.DHCInMatDispD(MainId)
	s No=$lg(MainInfo,2)
	s UserId=$lg(MainInfo,5)
	s RecLocId=$lg(MainInfo,6)
	s WardLocId=$lg(MainInfo,7)
	s DetailInfo=^User.DHCInMatDispD(MainId,"ChildDHCInMatDispItm",Detailchl)
	s AdmId=$lg(DetailInfo,2)
	s AdmLocId=$lg(DetailInfo,3)
	s Oeori=$lg(DetailInfo,4)
	s DspId=$lg(DetailInfo,5)
	s InciId=$lg(DetailInfo,9)
	s DspQty=$lg(DetailInfo,10)
	s Sp=$lg(DetailInfo,11)
	s SpAmt=$lg(DetailInfo,12)
	s HospId=""
	s:RecLocId'="" HospId=$p(^CTLOC(RecLocId),"^",22)
	s UomId=$p(^DHCOEDISQTY(DspId),"^",6)
	s Oeore=$p(^DHCOEDISQTY(DspId),"^",3)
	s PriorCode=##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).PriorityCode(Oeori)
	s:PriorCode'="S" Oeore=Oeori
	s IntrType="MDP"	//住院发放
	//1.锁定
	l +^DHCINCIL(RecLocId,InciId):10  e  q RtnObj.Err(-12,"","库存锁定失败！")
	s tmpPid=##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).SelClbQty(RecLocId,InciId,DspQty)
	q:tmpPid="" RtnObj.Err(-11,"","发放明细保存失败！")
	
	s i=0,chl=0
	f  s i=$o(^TMPDHCSTM("SelClbQty",tmpPid,i)) q:(i="")||(RtnObj.success'=0)  d
	.s Inclb=$p(^TMPDHCSTM("SelClbQty",tmpPid,i),"^",1)
	.s Qty=$p(^TMPDHCSTM("SelClbQty",tmpPid,i),"^",2)
	.s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,UomId,HospId)
	.s RpAmt=Rp*Qty
	.s SpAmt=Sp*Qty
	.s chl=chl+1
	.&sql(insert into DHC_InMatDispInclb(IDSLB_ParRef,IDSLB_ChildSub,IDSLB_INCLB_DR,IDSLB_DSPI_DR,
		IDSLB_Qty,IDSLB_Sp,IDSLB_SpAmt)
		values (:DetailId,:chl,:Inclb,"",:Qty,:Sp,:SpAmt))
	.i SQLCODE'=0 d RtnObj.Err(-12,"","发放明细保存失败！")
	.s DetailLB=%ROWID
	.s Qty=-Qty
	.s RpAmt=-RpAmt
	.s SpAmt=-SpAmt
	.;s ret=##class(web.DHCSTMHUI.PCHCOLLSM).ClearResQty(Inclb,Qty) ;清在途数
	.;i ret'=0 d RtnObj.Err(-11,"","发放明细保存失败！")
	.s ReservedObj={}
	.s Incil=$p(Inclb,"||",1,2)
	.s ReservedObj.Type="Oeori",ReservedObj.Pointer=Oeore,ReservedObj.Incil=Incil,ReservedObj.Qty=Qty
	.s ReservedParams=ReservedObj.%ToJSON()
	.s RtnObj=##class(web.DHCSTMHUI.MATReservedDetail).SetReservedDetail(ReservedParams)
	.q:RtnObj.success<0
	.
	.s ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(Inclb,Qty)
	.i ret<0 d RtnObj.Err(-11,"","发放明细保存失败！")
	.s Data=IntrType_"^^"_Inclb_"^"_Qty_"^"_UomId_"^"_Sp_"^"_UserId_"^"_DetailId_"^"_Rp_"^"_RpAmt_"^"_SpAmt
	.s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(Data)
	i RtnObj.success'=0 d
	.l -^DHCINCIL(RecLocId,InciId)
	q:RtnObj.success'=0 RtnObj
	
	s err=##Class(web.DHCSTMHUI.COMMOE).UpdDispensingByOeori(Oeore,"C",+$h,$p($h,",",2),UserId,IntrType,DetailId)
	i err'=0 d
	.d RtnObj.Err(-15,"","更新医嘱发放状态失败！")
	l -^DHCINCIL(RecLocId,InciId)
	q RtnObj
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCInMatDisp","QueryInMatDispMain",^templxt("QueryInMatDispMain"))
Query QueryInMatDispMain(Params As %String) As Query(ROWSPEC = "RowId,DispNo,Date,Time,UserId,UserName,LocId,LocDesc,WardLocId,WardLocDesc") [ SqlProc ]
{
}

ClassMethod QueryInMatDispMainExecute(ByRef qHandle As %Binary, Params As %String) As %Status
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
	s pDispNo=PJObj.%Get("DispNo")
	
	s SqlStr = "select %ID as RowId,"
	s SqlStr=SqlStr_"IDS_No as DispNo,"
	s SqlStr=SqlStr_"IDS_Date as DspDate,"
	s SqlStr=SqlStr_"IDS_Time as DspTime,"
	s SqlStr=SqlStr_"IDS_SSUSR_DR as UserId,"
	s SqlStr=SqlStr_"IDS_CTLOC_DR as LocId,"
	s SqlStr=SqlStr_"IDS_WardLoc_DR as WardLocId "
	s SqlStr=SqlStr_" from DHC_InMatDisp"
	s SqlStr=SqlStr_" where IDS_CTLOC_DR="_gLocId
	
	s Result=##class(%Library.ResultSet).%New()
	d Result.Prepare(SqlStr)
	s sc=Result.Execute()
	i $$$ISERR(sc) q $$$OK
	While(Result.Next())
	{
		s LocDesc="",WardLocDesc="",UserName=""
		s RowId = Result.Data("RowId")
		s DispNo = Result.Data("DispNo")
		continue:(pDispNo'="")&&(pDispNo'=DispNo)
		s Date=Result.Data("DspDate")
		continue:Date<pStartDate
		continue:Date>pEndDate
		s:Date'="" Date=..DL2H(Date)
		s Time=Result.Data("DspTime")
		s:Time'="" Time=..TL2H(Time)
		s UserId=Result.Data("UserId")
		s:UserId'="" UserName=$p(^SSU("SSUSR",UserId),"^",2)
		s LocId=Result.Data("LocId")
		s:LocId'="" LocDesc=$p(^CTLOC(LocId),"^",2)
		s WardLocId=Result.Data("WardLocId")
		s:WardLocId'="" WardLocDesc=$p(^CTLOC(WardLocId),"^",2)
		continue:(pWardLocId'="")&&(pWardLocId'=WardLocId)
		d OutPutInDispMain
	}
	Quit $$$OK
	
OutPutInDispMain
	s Data=$lb(RowId,DispNo,Date,Time,UserId,UserName,LocId,LocDesc,WardLocId,WardLocDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCInMatDisp","QueryInMatDispItm",^templxt("QueryInMatDispItm"))
Query QueryInMatDispItm(Parref As %String) As Query(ROWSPEC = "RowId,AdmId,AdmLocId,AdmLocDesc,Oeori,DspId,UomId,UomDesc,BedNo,DoseDate,InciId,InciCode,InciDesc,Spec,Stkbin,Qty:%Float,Sp:%Float,SpAmt:%Float") [ SqlProc ]
{
}

ClassMethod QueryInMatDispItmExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	n (qHandle,Parref)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s SqlStr = "select %ID as RowId,"
	s SqlStr=SqlStr_"IDSI_ADM_DR as AdmId,"
	s SqlStr=SqlStr_"IDSI_ADMLOC_DR as AdmLocId,"
	s SqlStr=SqlStr_"IDSI_OEORI_DR as Oeori,"
	s SqlStr=SqlStr_"IDSI_DSP_DR as DspId,"
	s SqlStr=SqlStr_"IDSI_BedNo as BedNo,"
	s SqlStr=SqlStr_"IDSI_DoseDate as DoseDate,"
	s SqlStr=SqlStr_"IDSI_INCI_DR as InciId,"
	s SqlStr=SqlStr_"IDSI_Qty as Qty,"
	s SqlStr=SqlStr_"IDSI_Sp as Sp,"
	s SqlStr=SqlStr_"IDSI_SpAmt as SpAmt "
	s SqlStr=SqlStr_" from DHC_InMatDispItm where IDSI_ParRef="_Parref
	
	s Result=##class(%Library.ResultSet).%New()
	d Result.Prepare(SqlStr)
	s sc=Result.Execute()
	i $$$ISERR(sc) q $$$OK
	While(Result.Next())
	{
		s AdmLocDesc="",UomDesc=""
		s RowId = Result.Data("RowId")
		s AdmId = Result.Data("AdmId")
		s AdmLocId=Result.Data("AdmLocId")
		s:AdmLocId'="" AdmLocDesc=$p(^CTLOC(AdmLocId),"^",2)
		s Oeori=Result.Data("Oeori")
		s DspId=Result.Data("DspId")
		s UomId=$p(^DHCOEDISQTY(DspId),"^",6)
		s:UomId'="" UomDesc=$p(^CT("UOM",UomId),"^",2)
		s BedNo=Result.Data("BedNo")
		s DoseDate=Result.Data("DoseDate")
		s InciId=Result.Data("InciId")
		s InciCode=$p(^INCI(InciId,1),"^",1)
		s InciDesc=$p(^INCI(InciId,1),"^",2)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
		s Stkbin=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetInciBinStr(InciId),":",2)
		s Qty=Result.Data("Qty")
		s Sp=Result.Data("Sp")
		s SpAmt=Result.Data("SpAmt")
		d OutPutInDispDetail
	}
	Quit $$$OK
	
OutPutInDispDetail
	s Data=$lb(RowId,AdmId,AdmLocId,AdmLocDesc,Oeori,DspId,UomId,UomDesc,BedNo,DoseDate,InciId,InciCode,InciDesc,Spec,Stkbin,Qty,Sp,SpAmt)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
