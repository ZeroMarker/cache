Import sqluser

/// Descript:	物资医嘱发放调用
/// Creator:    wangjiabin
/// CreateDate: 2013-11-08
Class web.DHCSTMHUI.PCHCOLLSM Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCITMTRACKM";

/// 供医生站调用
/// Description:根据高值条码获取医嘱项等信息
/// Return: 	医嘱rowid^status^inclb^stkQty(逻辑库存)^avaQty(可用库存)^locID(批次信息对应的loc)^locDesc^Y/N(是否为高值)
/// w ##class(web.DHCSTMHUI.PCHCOLLSM).GetArcimByLabel("bat20210312001","")
ClassMethod GetArcimByLabel(barcode As %String, Loc As %String = "")
{
	n (barcode,Loc)
	q:barcode="" ""
	;s dhcit=$o(^DHCIT(0,"LABEL",barcode,0))
	;2014-12-27 添加根据生产厂家自带条码取值
	s inci=""
	s dhcit=$o(^DHCIT(0,"LABEL",barcode,0))
	s:dhcit="" dhcit=$o(^DHCIT(0,"ORIGINALCODE",barcode,0))
	
	s (inci,status,inclb)=""
	i dhcit'="" d
	.s inci=$p(^DHCIT(dhcit),"^",1)
	.s status=$p(^DHCIT(dhcit),"^",5)
	.s inclb=$p(^DHCIT(dhcit),"^",12)
	
	i inci="" d
	.s inci=$o(^INCI(0,"BarCode",$$ALPHAUP^SSUTIL4(barcode),""))
	q:inci="" ""
	
	s arcim=$p(^INCI(inci,1),"^",3)
	s info=""
	i dhcit="" d
	.s info=arcim_"^"_"Enable"_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_"N"
	s:arcim="" info=""
	q:dhcit="" info
	
	s isAllowOrderInfo=..IsAllowOrder(dhcit)
	s isAllowOrder=$p(isAllowOrderInfo,"^",1)
	
	;不允许开医嘱,设置status
	s:isAllowOrder="N" status="NoAudit"
	
	s (OriginalStatus,OriginalStatusFlag,locID,stkQty,avaQty)=""
	s OriginalStatus=$p(^DHCIT(dhcit),"^",35)
	s OriginalStatusFlag=$s(OriginalStatus="NotUnique":"Y",1:"")
	i (OriginalStatusFlag="Y") d
	.s QtyList=..GetQtyByBarCodeLoc(Loc,barcode)
	.s stkQty=$p(QtyList,"^",1)
	.s avaQty=$p(QtyList,"^",2)
	.s locID=Loc
	e  i inclb'="" d
	.s il=$p(inclb,"||",2),lb=$p(inclb,"||",3)
	.s stkQty=$p(^INCI(+inclb,"IL",il,"LB",lb),"^",2)
	.s dirtyQty=$p(^INCI(+inclb,"IL",il,"LB",lb),"^",3)
	.s avaQty=stkQty-dirtyQty
	.s locID=$p(^INCI(+inclb,"IL",il),"^",1)
	.
	.s incib=$p(^INCI(+inclb,"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	.q:incib=""
	.s IB=$p(incib,"||",2)
	.s reccallflag=$p(^INCI(+incib,"IB",$p(incib,"||",2)),"^",3)
	.s:reccallflag="Y" avaQty=0    ///批次锁定后  置可用数量为0  控制开医嘱
	.
	.s ExpDate=$p(^INCI(+inclb,"IB",IB),"^",2)
	.i (ExpDate'="")&&(ExpDate<(+$h))&&(status="Enable") d
	..s status="Expire"		;过期的,不继续使用Enable状态
	
	
	s locDesc=$s(locID'="":$p(^CTLOC(locID),"^",2),1:"")
	s RegBarCode=$p(^DHCIT(dhcit),"^",2)	;物资注册高值条码
	s Str=arcim_"^"_status_"^"_inclb_"^"_stkQty_"^"_avaQty
		_"^"_locID_"^"_locDesc_"^"_"Y"_"^"_RegBarCode_"^"_OriginalStatusFlag
	
	q Str
}

/// 医生站调用
/// CreatDate:	2018-05-22
/// Description:根据医嘱rowid,获取对应条码
/// Input:		oeori
/// OutPut:		高值条码(如有多个条码,#隔开)
/// w ##class(web.DHCSTMHUI.PCHCOLLSM).GetBarCodeStr("1353||20")
ClassMethod GetBarCodeStr(Oeori) As %String
{
	n (Oeori)
	s Ord=$p(Oeori,"||",1),Itm=$p(Oeori,"||",2)
	q:(Ord="")||(Itm="")||'$d(^OEORD(Ord,"I",Itm)) ""
	
	s IntrTypeInfo=..sssOeoriTrType(Oeori)
	s DispIntrType=$p(IntrTypeInfo,"^",1)
	s BarCodeStr=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr(DispIntrType,Oeori)
	q BarCodeStr
}

/// 医生站等调用
/// CreatDate:	2018-12-08
/// Description:获取可用库存
/// Input:		医嘱项rowid, 科室id
/// OutPut:		可以库存数量(库存-在途-占用)
/// w ##class(web.DHCSTMHUI.PCHCOLLSM).GetAvailQtyByArc("1908||1",153)
ClassMethod GetAvailQtyByArc(Arcim As %String, LocId As %String)
{
	n (Arcim,LocId)
	q:Arcim="" 0
	q:LocId="" 0
	s Arc=$p(Arcim,"||",1)
	q:Arc="" 0
	s Inci=$o(^INCI(0,"ARCIM_DR",Arc,""))
	q:Inci="" 0
	
	s AvaQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetAvaQty(LocId,Inci,"")
	q AvaQty
}

/// 医生站调用
/// CreatDate:	2014-12-25
/// Description:发放物资时库存修改, 高值跟踪信息处理
/// Table:	dhc_itmtrack,dhc_itmtrackdetail,dhc_intrans等
/// Input:  oeori(长期医嘱处理时,传入执行记录rowid),
/// 		barcode(高值条码),
/// 		CallFlag(调用标记:审核医嘱传递"ORDER",计费后调用传递"BILL")
/// OutPut:	
/// Return: 0-正确; 其他:错误
/// w ##class(web.DHCSTMHUI.PCHCOLLSM).Disp("14||325","","ORDER")
ClassMethod Disp(oeori As %String, barcode As %String = "", CallFlag = "") As %String
{
	n (oeori,barcode,CallFlag)
	
	k ^||TMPDHCSTMZTCOUNT
	s TLevel=$TL ;当前事务层级
	s LogTypeInfo="HIS"_"^"_$CLASSNAME()_"^"_"Disp"
	s Params=oeori_";"_barcode_";"_CallFlag
	s ret=0
	
	;不是长期医嘱的,取oeori(而非oeore)
	s Oeord=$p(oeori,"||",1),Ch=$p(oeori,"||",2)
	q:(Oeord="")!(Ch="") -1
	q:'$d(^OEORD(Oeord,"I",Ch)) -1
	s arcim=$p(^OEORD(Oeord,"I",Ch,1),"^",2)
	q:arcim="" -2
	
	s priority=$p(^OEORD(Oeord,"I",Ch,1),"^",8)
	s priorCode=""
	i $d(^OECPR(priority)) d
	.s priorCode=$p(^OECPR(priority),"^",1)
	.s:priorCode'="S" oeori=$p(oeori,"||",1,2)
	q:priorCode["OM" 0
	
	s Adm=$P(^OEORD(+oeori),"^",1)
	s admloc=$p(^PAADM(Adm),"^",4)
	s inci=$o(^INCI(0,"ARCIM_DR",$p(arcim,"||",1),""))
	s HospitalId=$p($G(^CTLOC(admloc)),"^",22) ;如果传入的为空取就诊科室
	
	//库存项与计费项未关联过滤
	s ExistFlag=##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).CheckIncLTar(arcim)
	q:ExistFlag="N" 0
	
	/*日志及错误陷阱*/
	d ##class(web.DHCSTMHUI.InterfaceLog).Log(.LogRowId,LogTypeInfo,Params)
	s $ZT="DispError"
	
	/*数据处理*/
	s Param="^^^"_HospitalId
	s BatSpFlag=..sssBatSpFlag(HospitalId,inci)
	
	;减库存时如果传过来的是自带码转化成院内码，避免补录后停医嘱报错
	i barcode'="" d
	.s dhcit=$o(^DHCIT(0,"ORIGINALCODE",barcode,0))
	.s:dhcit'="" barcode=$p(^DHCIT(dhcit),"^",2)
	s:barcode="" barcode=##class(web.DHCSTMHUI.SRVCOMMON).GetBarcodeByOrd(oeori)  //可不传条码
	
	s (HVFlag,TableFlag)=""
	i inci'="" d
	.s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(inci)
	.s TableFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetTableFlag(inci)
	s dhcit=""
	i barcode'="" d
	.s dhcit=$o(^DHCIT(0,"LABEL",barcode,0))
	.s:dhcit="" dhcit=$o(^DHCIT(0,"ORIGINALCODE",barcode,""))
	s AutoRecHVFlag=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCITMTRACKM","DispAutoRecHV",Param)
	
	if (inci="") {
		;医嘱项未关联库存项,按DHC_InciLinkTar配置消减;批次售价也是相同调用
		s ret=##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).DispByTariff(oeori,CallFlag)
	}elseif (BatSpFlag=1) {
		;批次售价
		s ret=##class(web.DHCSTMHUI.SRVINTERFACE).DispMaterial(oeori,barcode,CallFlag)
		i ((AutoRecHVFlag="Y")&&(ret=0)) d
		.d ##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).CreateRecByOeori(oeori) //根据医嘱id入实库
	}else {
		;统一售价
		i ((barcode'="")&&(dhcit'="")) d
		.s ret=..DispMaterial(oeori,barcode,CallFlag)
		.i ((AutoRecHVFlag="Y")&&(ret=0)) d
		..d ##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).CreateRecByOeori(oeori)  //根据医嘱id入实库
		e  i (HVFlag="Y")&&(TableFlag="Y") d
		.;若 高值&&跟台,自动生成条码并记录跟踪信息
		.q:CallFlag="BILL"
		.s ret=..RecordTableMaterial(oeori)
		e  d
		.s ret=##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).DispMaterial(oeori,CallFlag)
	}
	d ##class(web.DHCSTMHUI.InterfaceLog).Log(.LogRowId,"","",ret)
	job ##class(web.DHCSTMHUI.ServiceForHRP).SendOeori(oeori,"Disp",HospitalId)
	q ret
DispError
	q $$InterfaceError^DHCSTMHUIERROR(.LogRowId,TLevel)
}

/// 供医生站调用
/// CreatDate:	2014-12-25
/// Description:停医嘱处理库存
/// Table:		in_trans,inc_itmloc,inc_itmlcbt,dhc_itmtrackdetail
/// Input:		医嘱明细rowid(长期医嘱传入执行记录rowid), 高值条码(低值耗材,或不使用条码,传"")
/// Return:0,成功；非0，错误 
/// w ##class(web.DHCSTMHUI.PCHCOLLSM).Return("477||3", "", "3^1573")
ClassMethod Return(oeori As %String, barcode As %String = "", RetStr As %String = "") As %String
{
	n (oeori,barcode,RetStr)
	k ^||TMPDHCSTMZTCOUNT
	s TLevel=$TL ;当前事务层级
	s LogTypeInfo="HIS"_"^"_$CLASSNAME()_"^"_"Return"
	s Params=oeori_";"_barcode_";"_RetStr
	
	s ret=0
	;2016-02-02 不是长期医嘱的,取oeori(而非oeore)
	s Oeord=$p(oeori,"||",1),Ch=$p(oeori,"||",2)
	s priority=$p(^OEORD(Oeord,"I",Ch,1),"^",8)
	s priorCode=""
	i $d(^OECPR(priority)) d
	.s priorCode=$p(^OECPR(priority),"^",1)
	.s:priorCode'="S" oeori=$p(oeori,"||",1,2)
	q:priorCode["OM" 0
	
	s Adm=$P(^OEORD(+oeori),"^",1)
	s admloc=$p(^PAADM(Adm),"^",4)
	s HospitalId=$p($G(^CTLOC(admloc)),"^",22)
	s arcim=$p(^OEORD(Oeord,"I",Ch,1),"^",2)
	s inci=$o(^INCI(0,"ARCIM_DR",$p(arcim,"||",1),""))
	
	//库存项与计费项未关联过滤
	s ExistFlag=##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).CheckIncLTar(arcim)
	q:ExistFlag="N" 0
	
	d ##class(web.DHCSTMHUI.InterfaceLog).Log(.LogRowId,LogTypeInfo,Params)
	s $ZT="ReturnError"

	;barcode为空时,保险起见检索dhc_itmtrack数据
	i barcode="" d
	.s IntrTypeInfo=..sssOeoriTrType(oeori)
	.s intrType=$p(IntrTypeInfo,"^",1)
	.s barcode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr(intrType,oeori)
	
	s (HVFlag,TableFlag)=""
	i inci'="" d
	.s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(inci)
	.s TableFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetTableFlag(inci)
	
	if (inci="")&&(barcode="") {
		;医嘱项未关联库存项
		s ret=##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).ReturnByTariff(oeori)
	}else {
		i barcode'="" d
		.s ret=..ReturnMaterial(oeori)
		e  d
		.s ret=##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).ReturnMaterial(oeori,RetStr)
	}
	d ##class(web.DHCSTMHUI.InterfaceLog).Log(.LogRowId,"","",ret)
	;2022-05 rem:目前此方法调用两次,应该是医嘱方面的问题, 这里暂时注释, 将此方法分高低值处理
	;job ##class(web.DHCSTMHUI.ServiceForHRP).SendOeori(oeori,"Return",HospitalId)
	q ret
ReturnError
	q $$InterfaceError^DHCSTMHUIERROR(.LogRowId,TLevel)
}

/// CreatDate:	2013-11-08
/// Description:发放物资时库存修改, 高值跟踪信息处理
/// Table:	dhc_itmtrack,dhc_itmtrackdetail,dhc_intrans等
/// Input:  oeori, barcode(高值条码), CallFlag(调用标记:审核医嘱-"ORDER",计费-"BILL")
/// OutPut:	
/// Return: 0-正确;-1,-2,-3,-4医嘱错误;-5没有医嘱数量;-6已经发药或已经退药,-7库存不足;
/// -8处理库存错误; -9保存高值信息失败
ClassMethod DispMaterial(oeori As %String, barcode As %String, CallFlag As %String = "") As %String
{
	n (oeori,barcode,CallFlag)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	;2016-02-02 不是长期医嘱的,取oeori(而非oeore)
	i $l(oeori,"||")=3 d
	.s Oeord=$p(oeori,"||",1),Ch=$p(oeori,"||",2)
	.s priority=$p(^OEORD(Oeord,"I",Ch,1),"^",8)
	.q:'$d(^OECPR(priority))
	.s priorCode=$p(^OECPR(priority),"^",1)
	.s:priorCode'="S" oeori=$p(oeori,"||",1,2)
	s Adm=$P(^OEORD(+oeori),"^",1)
	s admloc=$p(^PAADM(Adm),"^",4)
	s HospitalId=$p($G(^CTLOC(admloc)),"^",22) ;如果传入的为空取就诊科室
	s ord=$p(oeori,"||",1,1)
	s itm=$p(oeori,"||",2,2)
	q:(ord="")!(itm="") -1
	q:'$d(^OEORD(ord,"I",itm)) -1
	s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) 
	q:arcim="" -2
	
	s recloc=$p(^OEORD(ord,"I",itm,3),"^",6)
	q:recloc="" -3
	s inci=$o(^INCI(0,"ARCIM_DR",$p(arcim,"||",1),"")) 
	q:inci="" -4

	s paadm=$p(^OEORD(ord),"^",1)
	s admtype=$p(^PAADM(paadm),"^",2)
	s Param="^"_recloc_"^^"_HospitalId
	s matDisp=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTMATDISPM","HVMatDisp",Param)
	;2017-06-16 暂时注释下方的过滤,高值门诊发放还需医生站开医嘱等相应改造
	;q:(admtype="O")&&(matDisp="Y") -7	;高值走门诊发放时不处理

	s IntrTypeInfo=..sssOeoriTrType(oeori)
	s intrType=$p(IntrTypeInfo,"^",1)
	q:(admtype="I")&&(CallFlag="BILL") 0	;2017-02-23: 住院患者,计费调用时不再处理
	;paymodeflag: 1-押金收费模式 0-普通收费模式
	s paymodeflag=##class(web.DHCSTMHUI.Common.ServiceCommon).GetStayPayMode(HospitalId)
	;stayFlag: 1-有留观医嘱 0-无留观医嘱
	s stayFlag=##class(web.DHCSTMHUI.Common.ServiceCommon).GetStayStatus(paadm)
	
	s buomDr=$p(^INCI(inci,1),"^",10)
	s presc=$p(^OEORD(ord,"I",itm,1),"^",14)   	;处方号
	s sttdate=$p(^OEORD(ord,"I",itm,1),"^",9)
	s sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(inci,+$h,buomDr,HospitalId)				;单价
	s userid=+$p(^OEORD(ord,"I",itm,1),"^",11)		;开单医生(CT_CareProv)
	s:userid'="" userid=$o(^SSU("SSUSR",0,"CTPCP",userid,0))
	;
	s confqty=+$p($g(^OEORD(ord,"I",itm,1)),"^",12)	;取材料医嘱数量
	q:confqty=0 -5
	;
	l +^DHCOEDISPENSING(oeori):20  e  q -100   ;加锁
	s oeStatus=..ChkDspStatus(oeori)
	i oeStatus'="TC" d
	.l -^DHCOEDISPENSING(oeori)
	q:oeStatus'="TC" -6
	;
	s dhcit=$o(^DHCIT(0,"LABEL",barcode,0))
	s:dhcit="" dhcit=$o(^DHCIT(0,"ORIGINALCODE",barcode,""))
	q:dhcit="" -9
	s inclb=$p(^DHCIT(dhcit),"^",12)
	//20190525批次管理的码做批次转换
	s OriginalStatus=$p(^DHCIT(dhcit),"^",35)
	i OriginalStatus="NotUnique" d
	.s inclb=##class(web.DHCSTMHUI.DHCItmTrack).GetInclbByBarcodeQty(recloc,barcode,confqty)
	//批次码添加
	q:(inclb="")||($p(inclb,"||",1)'=inci) -9
	s rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(inclb,buomDr,HospitalId)
	l +^DHCINCLCBT(inclb):20  e  q -99
	s dhcitStatus=$p(^DHCIT(dhcit),"^",5)
	s packflag=..GetPackFlag(barcode)
	
	//i (CallFlag'="BILL")&&(dhcitStatus'="Enable")&&(packflag'=0) l -^DHCOEDISPENSING(oeori),^DHCINCLCBT(inclb) q -9

	s err=0
	tstart
	
	;2017-02-23: 医嘱审核时调用, 计费时不再调用
	;记录高值跟踪信息
	i dhcitStatus'="Used" {
		s operData="^"_userid_"^"_inci_"^^^^"
		s RtnObj=##class(web.DHCSTMHUI.DHCItmTrack).Update(intrType,oeori,barcode,operData)
		i RtnObj.success'=0 d
		.s err=-9
		.tro 1
		.l -^DHCINCLCBT(inclb)
		.l -^DHCOEDISPENSING(oeori)
		q:err<0 err
	}
 
	;2017-02-23: 住院患者,或门诊患者计费或急诊押金模式留观审核医嘱时或急诊押金模式非留观计费时或急诊普通模式计费时, 调用下面的方法
	i (admtype="I")||((admtype="O")&&(CallFlag'="ORDER"))||((admtype="E")&&(paymodeflag=1)&&(stayFlag'=-1)&&(CallFlag="ORDER"))||((admtype="E")&&(paymodeflag=1)&&(stayFlag=-1)&&(CallFlag="BILL"))||((admtype="E")&&(paymodeflag=0)&&(CallFlag'="ORDER")) {
		;处理医嘱发放-->记录物资发放信息dhc_hvmat_orditm-->清在途-->减库存,插台帐
		s err=##Class(web.DHCSTMHUI.COMMOE).UpdDispensingByOeori(oeori,"C",+$h,$p($h,",",2),userid,intrType,"")
		i err'=0 d
		.trollback 1
		.l -^DHCINCLCBT(inclb)			;incil去锁
		.l -^DHCOEDISPENSING(oeori)		;去锁
		q:err'=0 err
	
		// 插入到中间表(物资发放)
		s spAmt=sp*confqty
		s incib="",batno="",expdate="",manf="",vendor=""
		s IL=$p(inclb,"||",2),LB=$p(inclb,"||",3)
		s incib=$p(^INCI(inci,"IL",IL,"LB",LB),"^",1)
		i incib'="" d
		.s IB=$p(incib,"||",2)
		.s batno=$p(^INCI(inci,"IB",IB),"^",1)
		.s expdate=$p(^INCI(inci,"IB",IB),"^",2)
		.s dhcIncib=$o(^DHCINCIB(0,"INCIB",incib,""),-1)
		.i dhcIncib'="" s manf=$p(^DHCINCIB(dhcIncib),"^",7)
		s vendor=$p(^DHCIT(dhcit),"^",11)
		s admLoc=$p(^OEORD(ord,"I",itm,9),"^",2)
		s $p(data,"^",1)=""
		s $p(data,"^",2)=oeori
		s $p(data,"^",3)=""
		s $p(data,"^",4)=""
		s $p(data,"^",5)=""
		s $p(data,"^",6)=""  //收费状态
		s $p(data,"^",7)=spAmt   //收费金额
		s $p(data,"^",8)=admLoc
		s $p(data,"^",9)=userid
		s $p(data,"^",10)=""
		s $p(data,"^",11)=batno
		s $p(data,"^",12)=manf
		s $p(data,"^",13)=vendor
		s $p(data,"^",14)=buomDr
		s $p(data,"^",15)=confqty
		s $p(data,"^",16)=rp
		s $p(data,"^",17)=sp
		s $p(data,"^",18)=barcode
		s canceled="",invno="",invdate="",invamt=""
		s remark="高值材料发放"
		i expdate'="" s expdate=$zd(expdate,3)
		s $p(data,"^",19)=expdate
		s $p(data,"^",20)=canceled  //取消标志
		s $p(data,"^",21)=invno
		i invdate'="" s invdate=$zd(invdate,3)
		s $p(data,"^",22)=invdate
		s $p(data,"^",23)=invamt
		s $p(data,"^",24)=inci
		s $p(data,"^",25)=remark
		s $p(data,"^",26)=..GetIngri(barcode)
		s ret=##class(web.DHCSTMHUI.HVMatOrdItm).Update(data)
		i +ret'>0 s err=-9
		i err<0 d
		.trollback 1
		.l -^DHCINCLCBT(inclb)			;inclb去锁
		.l -^DHCOEDISPENSING(oeori)		;去锁
		q:err<0 err

		s qty=-confqty
		s rpAmt=rp*qty,spAmt=sp*qty
		//清除在途数量
		;s ret=..ClearResQty(inclb,qty)
		s ReservedObj={}
		s Incil=$p(inclb,"||",1,2)
		s ReservedObj.Type="Oeori",ReservedObj.Pointer=oeori,ReservedObj.Incil=Incil,ReservedObj.Qty=qty
		s ReservedParams=ReservedObj.%ToJSON()
		s RtnObj=##class(web.DHCSTMHUI.MATReservedDetail).SetReservedDetail(ReservedParams)
		i RtnObj.success<0 tro 1 q -7

		//处理库存 2017-10-31:不再根据"无库存医嘱"判断
		s ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(inclb,qty)
		i +ret<0 s err=-8 tro 1
		q:+ret<0 err
		
		;台帐
		s lstdata=intrType_"^"_presc_"^"_inclb_"^"_qty_"^"_buomDr_"^"_sp_"^"_userid_"^"_oeori_"^"_rp_"^"_rpAmt_"^"_spAmt
		s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(lstdata)
		i RtnObj.success'=0 s ret=-11
		i +ret<0 d
		.s err=-8
		.tro 1
		.l -^DHCINCLCBT(inclb)
		.l -^DHCOEDISPENSING(oeori)
		q:+ret<0 err
	}
	tcommit
	l -^DHCINCLCBT(inclb)			;incil去锁
	l -^DHCOEDISPENSING(oeori)		;去锁
	q err
}

/// CreatDate:2011-11-11		;2015-12-09重写
/// Description:停医嘱处理库存
/// 备注：库存类型不是"M"的不处理,无库存医嘱不处理
/// Table:in_trans,inc_itmloc,inc_itmlcbt,dhc_itmtrackdetail
/// Input:医嘱明细rowid
/// Return:0,成功；非0，错误 
ClassMethod ReturnMaterial(oeori) As %String
{
	n (oeori)
	q:oeori="" ""
	;2016-02-02 不是长期医嘱的,取oeori(而非oeore)
	i $l(oeori,"||")=3 d
	.s Oeord=$p(oeori,"||",1),Ch=$p(oeori,"||",2)
	.s priority=$p(^OEORD(Oeord,"I",Ch,1),"^",8)
	.q:'$d(^OECPR(priority))
	.s priorCode=$p(^OECPR(priority),"^",1)
	.s:priorCode'="S" oeori=$p(oeori,"||",1,2)
	
	s ord=+oeori
	s itm=$p(oeori,"||",2)
	s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) 
	q:arcim="" ""
	s recloc=$p(^OEORD(ord,"I",itm,3),"^",6) 
	q:recloc="" ""
	s OeoriInci=$o(^INCI(0,"ARCIM_DR",$p(arcim,"||",1),""))

	s paadm=$p(^OEORD(+oeori),"^",1)
	s admtype=$p(^PAADM(paadm),"^",2)
	s admloc=$p(^PAADM(paadm),"^",4)
	s HospitalId=$p($G(^CTLOC(admloc)),"^",22) ;如果传入的为空取就诊科室
	s Param="^"_recloc_"^^"_HospitalId
	s matDisp=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTMATDISPM","HVMatDisp",Param)
	;2017-06-16 暂时注释下方的过滤
	;q:(admtype="O")&&(matDisp="Y") -7	;高值走门诊发放时不处理

	s IntrTypeInfo=..sssOeoriTrType(oeori)
	s dispType=$p(IntrTypeInfo,"^",1)
	s intrType=$p(IntrTypeInfo,"^",2)	

	s barcodeStr=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr(dispType,oeori)
	s barcodeLen=$l(barcodeStr,"#")

	s inci=""
	i (barcodeStr'="")&&(barcodeLen=1) d
	.s dhcit=$o(^DHCIT(0,"LABEL",barcodeStr,0))
	.q:dhcit=""
	.s inci=$p(^DHCIT(dhcit),"^",1)
	
	s ret=0
	i barcodeStr="" d
	.;这里可以考虑调用低值接口
	.s ret=0
	.
	e  i (barcodeLen=1)&&(OeoriInci=inci)  d
	.;医嘱对应一个条码,且库存项和医嘱的arcim对应(直接扫码录医嘱的情况)
	.s ret=..ReturnMaterialOld(oeori,barcodeStr)
	e  d
	.;医嘱(高值治疗类型)绑定高值条码,或高值包模式, 这时可能用多个高值条码,且不应处理dhc_oedispensing
	.s ret=..ReturnMaterialMore(oeori)
	
	job ##class(web.DHCSTMHUI.ServiceForHRP).SendOeori(oeori,"Return",HospitalId)
	
	q ret
}

/// CreatDate:2011-11-11
/// Description:停医嘱处理库存(处理一个条码)
/// 备注：库存类型不是"M"的不处理,无库存医嘱不处理
/// Table:in_trans,inc_itmloc,inc_itmlcbt,dhc_itmtrackdetail
/// Input:医嘱明细rowid,高值条码
/// Return:0,成功；非0，错误 
ClassMethod ReturnMaterialOld(oeori, barcode) As %String [ Private ]
{
	n (oeori,barcode)
	q:oeori="" ""
	q:barcode="" ""
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s ord=+oeori
	s itm=$p(oeori,"||",2)
	s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) 
	q:arcim="" ""
	s recloc=$p(^OEORD(ord,"I",itm,3),"^",6) 
	q:recloc="" ""

	s dhcit=$o(^DHCIT(0,"LABEL",barcode,0))
	q:dhcit="" ""
	s inci=$p(^DHCIT(dhcit),"^",1)
	q:inci="" ""
	s dhcitinclb=$p(^DHCIT(dhcit),"^",12)
	s buomDr=$p(^INCI(inci,1),"^",10)

	s IntrTypeInfo=..sssOeoriTrType(oeori)
	s dispType=$p(IntrTypeInfo,"^",1)
	s intrType=$p(IntrTypeInfo,"^",2)	
	
	s presc=$p(^OEORD(ord,"I",itm,1),"^",14)   	;处方号
	s userid=+$p(^OEORD(ord,"I",itm,1),"^",11)		;开单医生(CT_CareProv)
	s:userid'="" userid=$o(^SSU("SSUSR",0,"CTPCP",userid,0))

	s err=0

	l +^DHCOEDISPENSING(oeori):20  e  q -100   ;加锁
	s oeStatus=..ChkDspStatus(oeori)
	;q:oeStatus'="C" 0
	;2017-02-28 dhc_oedispensing状态为R的,quit
	i (oeStatus'="C")&&(oeStatus'="TC") d
	.l -^DHCOEDISPENSING(oeori)
	.s err=-10
	q:err'=0 err
	

	tstart

	s isDHCITDetail=$d(^DHCITD(0,"Type",intrType,"Pointer",oeori,dhcit))
	s OriginalStatus=$p(^DHCIT(dhcit),"^",35)
	s TableFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetTableFlag(inci)
	;不存在跟踪记录的,才调用
	;2018-03-21:跟台高值,标记特殊处理
	i (isDHCITDetail=0) {
		s operData="^"_userid_"^"_inci_"^^^"
		s NewIntrType=intrType
		s:((TableFlag="Y")&&(dhcitinclb="")&&(OriginalStatus="Table")) NewIntrType="S"_intrType
		s RtnObj=##class(web.DHCSTMHUI.DHCItmTrack).Update(NewIntrType,oeori,barcode,operData)
		i RtnObj.success'=0 d
		.s err=-11 
		.l -^DHCOEDISPENSING(oeori) 
		.tro 1
		q:err<0 err
	}

	s retqty=0
	s trid=$o(^DHCINTR(0,"TypePointer",dispType,oeori,0))
	i trid'="" d
	.s inclb=$p(^DHCINTR(trid),"^",7)
	.;20180920不是材料的过滤
	.s inci=$p(^DHCINTR(trid),"^",15)
   	.q:inci=""
    .s stkCatGrpType=##Class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).GetItmStkGrpType(inci)
    .q:stkCatGrpType'="M"
	.s qty=$p(^DHCINTR(trid),"^",6)
	.s retqty=-qty
	e  d
	.i $p(oeori,"||",3)="" d
	..s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,0))
	.i $p(oeori,"||",3)'="" d
	..s dspId=$o(^DHCOEDISQTY(0,"OEORE",oeori,0))
	.q:dspId=""
	.s dspqty=$p(^DHCOEDISQTY(dspId),"^",5)
	.s retqty=dspqty
	;2017-02-23未作库存消减处理的,DHC_OEDispensing不插入R类型数据
	i (oeStatus="C")&&(+retqty'=0) {
		s err=##Class(web.DHCSTMHUI.COMMOE).InsDispensing(oeori,"R",+$h,$p($h,",",2),userid,intrType,"",retqty,buomDr)
		i err'=0 d
		.trollback 1
		.l -^DHCOEDISPENSING(oeori)
		q:err'=0 err
	}
	
	;记录回退信息(DHC_HVMat_OrdItmRet)
	s DataStr=oeori_"^"_barcode
	s Ret=##class(web.DHCSTMHUI.HVMatOrdItmRet).Save(DataStr)
	i Ret<0 d
	.s err=-12
	.tro 1
	.l -^DHCOEDISPENSING(oeori)
	q:err<0 err
	
	//发放时有台帐记录的,处理库存相关
	s trid=$o(^DHCINTR(0,"TypePointer",dispType,oeori,0))
	i trid'="" {
		;处理dhc_oedispensing
		s inclb=$p(^DHCINTR(trid),"^",7)
		;20180920不是材料的过滤
		s inci=$p(^DHCINTR(trid),"^",15)
    	q:inci=""
    	s stkCatGrpType=##Class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).GetItmStkGrpType(inci)
    	q:stkCatGrpType'="M"
		s qty=$p(^DHCINTR(trid),"^",6)
		s qty=-qty
		s rp=$p(^DHCINTR(trid),"^",16)
		s sp=$p(^DHCINTR(trid),"^",14)
		;handle stockQty
		s ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(inclb,qty)
		s:ret'=0 err=1
		i err>0 d
		.trollback 1
		.l -^DHCOEDISPENSING(oeori)
		q:err>0 err

		;台帐
		s rpAmt=rp*qty,spAmt=sp*qty
		s lstdata=intrType_"^"_presc_"^"_inclb_"^"_qty_"^"_buomDr_"^"_sp_"^"_userid_"^"_oeori_"^"_rp_"^"_rpAmt_"^"_spAmt
		s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(lstdata)
		i RtnObj.success'=0 s err=3
		i err>0 d
		.trollback 1
		.l -^DHCOEDISPENSING(oeori)
		q:err>0 err
	}
	
	;2014-07-21:对于虚库高值,判断是否已经补录,如已补录进行特殊处理
	;先记录跟踪信息,处理库存台帐,再处理补录单据
	s ret=##class(web.DHCSTMHUI.PCHCOLLSRela).HandleMainLocInfo(oeori,barcode)
	i ret<0 tro 1  l -^DHCOEDISPENSING(oeori) q ret

	tcommit
	l -^DHCOEDISPENSING(oeori)
	q 0
}

/// CreatDate:2011-11-11
/// Description:停医嘱处理库存(处理多个条码)
/// 备注：库存类型不是"M"的不处理,无库存医嘱不处理
/// Table:in_trans,inc_itmloc,inc_itmlcbt,dhc_itmtrackdetail
/// Input:医嘱明细rowid,高值条码
/// Return:0,成功；非0，错误 
ClassMethod ReturnMaterialMore(oeori) As %String [ Private ]
{
	n (oeori)
	q:oeori="" ""
	;q:barcode="" ""
	s ord=+oeori
	s itm=$p(oeori,"||",2)
	s recloc=$p(^OEORD(ord,"I",itm,3),"^",6) 
	q:recloc="" ""
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s IntrTypeInfo=..sssOeoriTrType(oeori)
	s dispType=$p(IntrTypeInfo,"^",1)
	s intrType=$p(IntrTypeInfo,"^",2)

	s presc=$p(^OEORD(ord,"I",itm,1),"^",14)		;处方号
	s sttdate=$p(^OEORD(ord,"I",itm,1),"^",9)
	s userid=+$p(^OEORD(ord,"I",itm,1),"^",11)		;开单医生(CT_CareProv)
	s:userid'="" userid=$o(^SSU("SSUSR",0,"CTPCP",userid,0))

	l +^DHCOEDISPENSING(oeori):20  e  q -100   ;加锁
	s barcodeStr=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr(dispType,oeori)
	s barcodeLen=$l(barcodeStr,"#")
	
	s ret=0,err=0
	ts
	f i=1:1:barcodeLen q:err'=0  d
	.s barcode=$p(barcodeStr,"#",i)
	.s dhcit=$o(^DHCIT(0,"LABEL",barcode,0))
	.q:dhcit=""
	.s ReturnFlag=..BarCodeReturnFlag(dhcit,oeori)
	.q:ReturnFlag=1		;该条码已存在退回记录的,不再处理
	.s inci=$p(^DHCIT(dhcit),"^",1)
	.q:inci=""
	.s dhcitinclb=$p(^DHCIT(dhcit),"^",12)
	.s buomDr=$p(^INCI(inci,1),"^",10)
	.s sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(inci,+$h,buomDr,"")	;售价
	.
	.;记录高值跟踪信息
	.;2018-03-21:跟台高值,标记特殊处理
	.s TableFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetTableFlag(inci)
	.s NewIntrType=intrType
	.s:((TableFlag="Y")&&(dhcitinclb="")) NewIntrType="S"_intrType
	.s operData="^"_userid_"^"_inci_"^^^"
	.s RtnObj=##class(web.DHCSTMHUI.DHCItmTrack).Update(NewIntrType,oeori,barcode,operData)
	.i RtnObj.success'=0 s err=-11
	.q:err<0
	.
	.;记录回退信息(DHC_HVMat_OrdItmRet)
	.s DataStr=oeori_"^"_barcode
	.s Ret=##class(web.DHCSTMHUI.HVMatOrdItmRet).Save(DataStr)
	.i Ret'>0 d
	..s err=-12
	.q:err<0
	.
	.;处理库存,台帐
	.s trid=##class(web.DHCSTMHUI.DHCItmTrack).GetDhcitIntrID(dhcit,dispType,oeori)
	.i trid'="" d
	..;非材料的过滤
	..s inci=$p(^DHCINTR(trid),"^",15)
    ..q:inci=""
    ..s stkCatGrpType=##Class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).GetItmStkGrpType(inci)
    ..q:stkCatGrpType'="M" 
	..s inclb=$p(^DHCINTR(trid),"^",7)
	..s qty=$p(^DHCINTR(trid),"^",6)
	..s qty=-qty
	..;s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	..;handle stockQty
	..s ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(inclb,qty)
	..s:ret'=0 err=-1
	..q:err'=0
	..
	..;handle dhc_intrans
	..s rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(inclb,buomDr,"")
	..s rpAmt=rp*qty,spAmt=sp*qty
	..s lstdata=intrType_"^"_presc_"^"_inclb_"^"_qty_"^"_buomDr_"^"_sp_"^"_userid_"^"_oeori_"^"_rp_"^"_rpAmt_"^"_spAmt
	..s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(lstdata)
	..i RtnObj.success'=0 s err=-3
	..q:err'=0
	.
	.
	.;2014-07-21:对于虚库高值,判断是否已经补录,如已补录进行特殊处理
	.;先记录跟踪信息,库存台帐,再处理补录单据
	.s ret=##class(web.DHCSTMHUI.PCHCOLLSRela).HandleMainLocInfo(oeori,barcode)
	.i ret<0 s err=-10
	.q:err'=0
	
	i err'=0 l -^DHCOEDISPENSING(oeori) tro
	tc
	l -^DHCOEDISPENSING(oeori)
	q err
}

ClassMethod ChkDspStatus(Oeori) As %String
{
	n (Oeori)
	s RetStatus=""
	//倒序查找先判断是否有退药状态
	s DspID=""
	i $p(Oeori,"||",3)'=""  d
	.f  s DspID=$o(^DHCOEDISQTY(0,"OEORE",Oeori,DspID),-1) q:(DspID="")!(RetStatus'="")  d
	..s DspStatus=$p(^DHCOEDISQTY(DspID),"^",7)
	..s RetStatus=DspStatus
	e  d
	.s Oeori=$p(Oeori,"||",1,2)
	.f  s DspID=$o(^DHCOEDISQTY(0,"OEORI",Oeori,DspID),-1) q:(DspID="")!(RetStatus'="")  d
	..s DspStatus=$p(^DHCOEDISQTY(DspID),"^",7)
	..s RetStatus=DspStatus
	q RetStatus
}

/// 供医生站调用
/// 根据医嘱项取高值标志
/// Author:zhwh
/// Date:2014-1-1
/// Arguments:
///   arcim -医嘱项rowid
/// Return:
///  高值标志: Y,N
ClassMethod GetArcimHighValueFlag(arcim As %String) As %String
{
	n (arcim)	
	s result="N"
	s arcim=$P(arcim,"||",1)
	q:arcim="" result
	s inci=$o(^INCI(0,"ARCIM_DR",arcim,""))
	q:inci="" result
	s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci,..sssCode())
	q:ScgInfo="" result		;非物资的,按N处理(药品也启用此字段,不过滤会引起冲突)
	s TableFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetTableFlag(inci)
	q:TableFlag="Y" result		;2016-11-14: 若为跟台耗材,医生站不按高值控制
	i '$d(^||TMP("UseItmTrack")) d
	.s AppCode=##class(web.DHCSTMHUI.DHCItmTrack).%GetParameter("AppName")
	.s UseItmTrack=##Class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppCode,"UseItmTrack","")
	.s ^||TMP("UseItmTrack")=UseItmTrack
	s UseItmTrack=^||TMP("UseItmTrack")
	q:UseItmTrack'="Y" result	
	s result=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(inci)
	q result
}

/// 根据条码找出入库明细rowid
/// Author:zhwh
/// Date:2014-01-03
/// Arguments:
///  label - 条码
/// Return:
///    入库明细rowid
ClassMethod GetIngri(label As %String) As %String
{
	n (label)
	q:label="" ""
	s dhcit=$o(^DHCIT(0,"LABEL",label,0))
	i dhcit="" s dhcit=$o(^DHCIT(0,"ORIGINALCODE",label,0))
	q:dhcit="" ""
	
	s ingri=""
	s Ch=0
	f  s Ch=$o(^DHCITD(dhcit,"I",Ch)) q:(Ch="")||(ingri'="")  d
	.s Type=$p(^DHCITD(dhcit,"I",Ch),"^",2)
	.q:Type'="G"
	.s ingri=$p(^DHCITD(dhcit,"I",Ch),"^",1)
	
	q ingri
}

/// CreatDate:	2015-06-24
/// Description:发放物资时库存修改, 高值跟踪信息处理(同仁高值医嘱包类型医嘱)
/// 			医嘱直接绑定条码时使用(比如***手术)
/// Table:		dhc_itmtrack,dhc_itmtrackdetail,dhc_intrans等
/// Input:		oeori, dhcit(高值条码对应rowid)
/// OutPut:	
/// Return: 0-正确;-1,-2,-3,-4医嘱错误;-5没有医嘱数量;-6已经发药或已经退药,-7库存不足;
/// 		-8处理库存错误; -9保存高值信息失败
ClassMethod DispHVByDhcit(oeori As %String, dhcit As %String) As %String
{
	n (oeori,dhcit)
	s $ZT=..sssError()
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s ord=$p(oeori,"||",1)
	s itm=$p(oeori,"||",2)
	q:(ord="")!(itm="") -1
	q:'$d(^OEORD(ord,"I",itm)) -1
	
	i $l(oeori,"||")=3 d
	.s priority=$p(^OEORD(ord,"I",itm,1),"^",8)
	.q:'$d(^OECPR(priority))
	.s priorCode=$p(^OECPR(priority),"^",1)
	.s:priorCode'="S" oeori=$p(oeori,"||",1,2)
	
	q:dhcit="" -1
	s barcode=$p(^DHCIT(dhcit),"^",2)
	q:barcode="" -1
	s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) 
	q:arcim="" -2
	s recloc=$p(^OEORD(ord,"I",itm,3),"^",6)
	q:recloc="" -3
	s OeoriInci=$o(^INCI(0,"ARCIM_DR",$p(arcim,"||",1),"")) 
	q:OeoriInci'="" -4		;医嘱的医嘱项关联了库存项的,不处理
	s inci=$p(^DHCIT(dhcit),"^",1)
	s buomDr=$p(^INCI(inci,1),"^",10)
	s presc=$p(^OEORD(ord,"I",itm,1),"^",14)   	;处方号
	s sttdate=$p(^OEORD(ord,"I",itm,1),"^",9)
	s sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(inci,+$h,buomDr,"")				;单价
	s userid=+$p(^OEORD(ord,"I",itm,1),"^",11)		;开单医生(CT_CareProv)
	s:userid'="" userid=$o(^SSU("SSUSR",0,"CTPCP",userid,0))
	s confqty=1	;材料医嘱数量
	;
	l +^DHCOEDISPENSING(oeori):20  e  q -100   ;加锁
	;
	s inclb=$p(^DHCIT(dhcit),"^",12)
	l +^DHCINCLCBT(inclb):20  e  q -99
	s dhcitStatus=$p(^DHCIT(dhcit),"^",5)
	i dhcitStatus'="Enable" l -^DHCOEDISPENSING(oeori) q -9

	s IntrTypeInfo=..sssOeoriTrType(oeori)
	s intrType=$p(IntrTypeInfo,"^",1)

	s err=0
	s ret=0
	tstart

	;记录高值跟踪信息
	s operData="^"_userid_"^"_inci_"^^^^"
	s RtnObj=##class(web.DHCSTMHUI.DHCItmTrack).Update(intrType,oeori,barcode,operData)
	i RtnObj.success'=0 s ret=-1
	i +ret<0 s err=-9 tro 1
	q:err<0 err

	;2015-12-09 ;医嘱(高值治疗类型)绑定条码时,不再处理打包表数据
	/*
	s err=##Class(web.DHCSTMHUI.COMMOE).UpdDispensingByOeori(oeori,"C",+$h,$p($h,",",2),userid,intrType,"")
	i err'=0 d
	.trollback 1
	.l -^DHCINCLCBT(inclb)			;incil去锁
	.l -^DHCOEDISPENSING(oeori)	;去锁
	q:err'=0 err
	*/

	s qty=-confqty
	;handle stockQty
	s ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(inclb,qty)
	i +ret<0 s err=-8 tro 1  q err
	//
	s rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(inclb,buomDr,"")
	s rpAmt=rp*qty,spAmt=sp*qty
	;handle dhc_intrans
	s lstdata=intrType_"^"_presc_"^"_inclb_"^"_qty_"^"_buomDr_"^"_sp_"^"_userid_"^"_oeori_"^"_rp_"^"_rpAmt_"^"_spAmt
	s intrid=""
	s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(lstdata)
	i RtnObj.success'=0  s err=-8 tro 1  q err
	i RtnObj.success=0  s intrid=RtnObj.rowid ;记录台账ID
	//记录台账ID到DHC_ItmTrackDetail中
	s ret=##class(web.DHCSTMHUI.DHCItmTrack).UpdateDhcitIntrID(dhcit,intrid,intrType,oeori)
	// 清除在途数量
	;s ret=..ClearResQty(inclb,-confqty)
	s ReservedObj={}
	s Incil=$p(inclb,"||",1,2)
	s ReservedObj.Type="Oeori",ReservedObj.Pointer=oeori,ReservedObj.Incil=Incil,ReservedObj.Qty=-confqty
	s ReservedParams=ReservedObj.%ToJSON()
	s RtnObj=##class(web.DHCSTMHUI.MATReservedDetail).SetReservedDetail(ReservedParams)
	i RtnObj.success<0 tro 1 q -7
 
	s rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(inclb,buomDr,"")
	s spAmt=sp*confqty
	// 插入到中间表(物资发放)
	s incib="",batno="", expdate="",manf="",vendor=""
	&sql(select inclb_incib_dr,inclb_incib_dr->incib_no,inclb_incib_dr->incib_expdate 
	      into :incib,:batno, :expdate from inc_itmlcbt where inclb_rowid=:inclb)

	i incib'="" d     
	.&sql(select incib_phmnf_dr into :manf from dhc_incitmbat where incib_incib_dr=:incib)

	&sql(select dhcit_apcvm_dr into :vendor from dhc_itmtrack where dhcit_label=:barcode)

	s $p(data,"^",1)=""
	s $p(data,"^",2)=oeori
	s $p(data,"^",3)=""
	s $p(data,"^",4)=""
	s $p(data,"^",5)=""
	s $p(data,"^",6)=""  //收费状态
	s $p(data,"^",7)=spAmt   //收费金额
	s admLoc=""
	&sql(select oeori_admloc_dr into :admLoc from oe_orditem where %id=:oeori)
	s $p(data,"^",8)=admLoc
	s $p(data,"^",9)=userid
	s $p(data,"^",10)=""
	s $p(data,"^",11)=batno
	s $p(data,"^",12)=manf
	s $p(data,"^",13)=vendor
	s $p(data,"^",14)=buomDr
	s $p(data,"^",15)=confqty
	s $p(data,"^",16)=rp
	s $p(data,"^",17)=sp
	s $p(data,"^",18)=barcode
	s canceled="",invno="",invdate="",invamt=""
	s remark="高值材料发放"
	i expdate'="" s expdate=$zd(expdate,3)
	s $p(data,"^",19)=expdate
	s $p(data,"^",20)=canceled  //取消标志
	s $p(data,"^",21)=invno
	i invdate'="" s invdate=$zd(invdate,3)
	s $p(data,"^",22)=invdate
	s $p(data,"^",23)=invamt
	s $p(data,"^",24)=inci
	s $p(data,"^",25)=remark
	s $p(data,"^",26)=..GetIngri(barcode)
	s ret=##class(web.DHCSTMHUI.HVMatOrdItm).Update(data)
	i +ret<0 s err=-9
	i ret["<ERROR>" s err=-91
	i err<0 d
	.trollback 1
	.l -^DHCINCLCBT(inclb)			;inclb去锁
	.l -^DHCOEDISPENSING(oeori)	;去锁
	q:err<0 err

	tcommit
	l -^DHCINCLCBT(inclb)			;incil去锁
	l -^DHCOEDISPENSING(oeori)		;去锁
	q err
}

/// 供医生站调用
/// Description:根据条码和接收科室 开医嘱的时候进行转移 
/// Return: 	
ClassMethod InIsTrf(barcode As %String, loc As %String)
{
	n (barcode,loc)
	q:barcode="" -1
	q:loc="" -2
	&sql(select %id into :dhcit from DHC_ItmTrack where DHCIT_Label=:barcode)
	q:$g(dhcit)="" -3
	s inci=$p(^DHCIT(dhcit),"^",1)
	s status=$p(^DHCIT(dhcit),"^",5)
	s inclb=$p(^DHCIT(dhcit),"^",12)
	s PurUomId=$p(^INCI(inci,3),"^",6)
	q:inci="" -4
	s arcim=$p(^INCI(inci,1),"^",3)
	i inclb'="" d
	.s il=$p(inclb,"||",2),lb=$p(inclb,"||",3)
	.s stkQty=$p(^INCI(+inclb,"IL",il,"LB",lb),"^",2)
	.s dirtyQty=$p(^INCI(+inclb,"IL",il,"LB",lb),"^",3)
	.s avaQty=stkQty-dirtyQty
	.s locID=$p(^INCI(+inclb,"IL",il),"^",1)
	.s locDesc=$p(^CTLOC(locID),"^",2)
	q:loc=locID 0   ;在当前科室 不处理
	q:status'="Enable" -5 
	q:avaQty'=1 -6
	
	s status=10		;出库单状态
	s stkType=..sssCode()
	s remark="开医嘱自动"
	s userId=""
	s mainData=locID_"^"_loc_"^^^N^"_status_"^"_userId_"^^"_stkType_"^"_remark
	s listData="^"_inclb_"^"_avaQty_"^"_PurUomId_"^^^"_barcode
	s ret=##class(web.DHCSTMHUI.DHCINIsTrf).Save("",mainData,listData)
	q:ret<0 -6
	s ret1=##class(web.DHCSTMHUI.DHCINIsTrf).TransOutAuditYes(ret,userId,"","Y")
	q ret1<0 -7
	s ret2=##class(web.DHCSTMHUI.DHCINIsTrf).TransInAuditYes(ret,UserId)
	q ret2<0 -8
	q 0
}

/// 供医生站调用
/// Description:根据高值条码判断是不是高值包
/// Return: 	0是包 其他不是包
ClassMethod GetPackFlag(barcode As %String)
{
	n (barcode)
	q:barcode="" -1
	s dhcit=$o(^DHCIT(0,"LABEL",barcode,0))
	s:dhcit="" dhcit=$o(^DHCIT(0,"ORIGINALCODE",barcode,""))		;2015-10-20 add
	q:dhcit="" -3
	s inci=$p(^DHCIT(dhcit),"^",1)
	q:inci="" -2
	s packflag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPackChargeFlag(inci)
	;&sql(select * from DHC_PackChargeLink where PCL_Pack_DR=:inci)
	q:packflag="Y" 0
	q packflag
}

/// CreatDate:	2015-12-10
/// Creator:	wangjiabin
/// Description:判断该条码是否有对应oeori的退回记录(台帐Y或H)
/// Table:		dhc_itmtrackdetail
/// Input:		dhcit(高值条码对应rowid), oeori
/// OutPut:	
/// Return:		1:有, 其他:没有
ClassMethod BarCodeReturnFlag(dhcit, oeori) As %String [ Private ]
{
	n (dhcit,oeori)
	s ret=""
	q:dhcit="" ret
	q:oeori="" ret
	&sql(select * from DHC_ItmTrackDetail where DHCITD_Parref=:dhcit
		and DHCITD_Type in ('MY','MH','SMY') and DHCITD_Pointer=:oeori)
	i SQLCODE=0 s ret=1
	q ret
}

/// Descript:   判断明细是否审核
/// 			考虑到可能添加的其他信息, 调用时$piece截取
/// Creator:    wangjiabin
/// CreateDate: 2016-10-28
/// Input:      dhcit
/// Output:     
/// Return： (Y/N) ^ 未审核时的单据信息
ClassMethod IsAllowOrder(dhcit) As %Library.String [ Private ]
{
	n (dhcit)
	q:dhcit="" ""
	s Status=$p(^DHCIT(dhcit),"^",5)
	
	s lastCh=+$o(^DHCITD(dhcit,"I",""),-1)
	q:(Status="Enable")&&(lastCh'>0) "Y"		//2017-09-07 现有库存直接绑定条码的,按Y处理
	q:(lastCh'>0) "N"
	
	s isAudit="Y"
	s pointer=$p(^DHCITD(dhcit,"I",lastCh),"^",1)
	s type=$p(^DHCITD(dhcit,"I",lastCh),"^",2)

	i type="T" d
	.;最新跟踪信息为T类型的(出库制单或审核),不可开医嘱
	.s isAudit="N"
	e  d
	.q:(type="H")||(type="Y")||(type="MH")||(type="MY")||(type="MFC")	;2017-02-23: 门诊高值未计费时没有台帐
	.;没有台帐的(未审核)
	.s intr=$o(^DHCINTR(0,"TypePointer",type,pointer,0))
	.s:intr="" isAudit="N"

	q isAudit
}

/// Description:记录跟台高值(供医生站调用)
/// 	审核的程序执行完之后,调用即可,不必区分该医嘱是否为材料医嘱,该方法内部控制
/// Creator:	wangjiabin
/// CreateDate:	2016-11-14
/// Input:		医嘱rowid
/// Output:     
/// Return:		0:成功, 其他:失败
/// w ##class(web.DHCSTMHUI.PCHCOLLSM).RecordTableMaterial("567||54")
ClassMethod RecordTableMaterial(oeori As %String) As %Library.String
{
	n (oeori)
	s Oeord=$p(oeori,"||",1),Ch=$p(oeori,"||",2)
	q:(Oeord="")!(Ch="") -1
	q:'$d(^OEORD(Oeord,"I",Ch)) -1
	s arcim=$p(^OEORD(Oeord,"I",Ch,1),"^",2)
	q:arcim="" 0
	q:$p(arcim,"||",1)="" 0
	s inci=$o(^INCI(0,"ARCIM_DR",$p(arcim,"||",1),""))
	q:inci="" 0							;过滤无库存项的
	s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	s StkType=$p(ScgInfo,"^",3)
	q:StkType'=..sssCode() 0			;过滤不是材料的
	s Scg=$p(ScgInfo,"^",5)
	s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(inci)
	q:HVFlag'="Y" 0						;过滤不是高值的
	s TableFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetTableFlag(inci)
	q:TableFlag'="Y" 0					;过滤不是跟台耗材的
	
	s UserId=+$p(^OEORD(Oeord,"I",Ch,1),"^",11)			;开单医生(CT_CareProv)
	s:UserId'="" UserId=$o(^SSU("SSUSR",0,"CTPCP",UserId,0))
	;s MainInfo=oeori_"^"_UserId
	s confqty=+$p($g(^OEORD(Oeord,"I",Ch,1)),"^",12)	;医嘱数量
	s confqty=$SYSTEM.SQL.CEILING(confqty)
	
	s (hvm,BatchNo,ExpDate,SpecDesc,OriginalCode)=""
	s OeoriTableFlag="Y"
	;s ListDetail=hvm_"^"_inci_"^"_confqty_"^"_BatchNo_"^"_ExpDate_"^"_SpecDesc_"^"_OriginalCode
	s title="orirowid^inci^qty^batno^expdate^specdesc^originalcode^OeoriTableFlag"
	s data=hvm_"^"_inci_"^"_confqty_"^"_BatchNo_"^"_ExpDate_"^"_SpecDesc_"^"_OriginalCode_"^"_OeoriTableFlag
	s ListDetailobj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(data,title)
	s ListDetail="["_ListDetailobj_"]"
	
	s recloc=$p(^OEORD(Oeord,"I",Ch,3),"^",6)
	s HospId=$s(recloc'="":$p(^CTLOC(recloc),"^",22),1:"")
	s Maintitle="gHospId^gUserId"
	s Maindata=HospId_"^"_UserId
	s MainInfo=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Maindata,Maintitle)
 ;;;;;;;;;;这里暂时直接调用
 	s RtnObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s RetRtnObj=##class(web.DHCSTMHUI.OeoriBindInci).Save(oeori,ListDetail,MainInfo)
	s Sc=RtnObj.%FromJSON(RetRtnObj)
	;s RtnObj=##class(web.DHCSTMHUI.OeoriBindInci).Save(MainInfo,ListDetail,HospId)
	q:RtnObj.%Get("success")'=0 -10
	q 0
}

/// Description: 检查医嘱明细是否已发放材料 0 未发, 1 已发, 2已退
/// Creator: lxt
/// CreatDate: 2017-6-1
/// w ##class(web.DHCSTMHUI.PCHCOLLSM).CheckDispStaByOeori()
ClassMethod CheckDispStaByOeori(oeori) As %String
{
	n (oeori)
	s dspflag="C"
	s dspflagR="R"
	s fyflag=0
   	s dsp=""
   	f  s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,dsp)) q:dsp=""  d
   	.s status=$p(^DHCOEDISQTY(dsp),"^",7)
   	.i status=dspflag s fyflag=1
   	.i status=dspflagR s fyflag=2
   	q fyflag
}

/// Descripton:判断高值医嘱是否进行退货确认
/// Date:20170706
/// Creator:liuhui
/// w ##class(web.DHCSTMHUI.PCHCOLLSM).GetRetFlag("1||71")
ClassMethod GetRetFlag(oeori) As %String
{
	n (oeori)
	s RetFlag="Y"
	s IntrTypeInfo=..sssOeoriTrType(oeori)
	s intrType=$p(IntrTypeInfo,"^",1)
	s barcode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr(intrType,oeori)
	q:barcode="" RetFlag
	
	s Adm=$P(^OEORD(+oeori),"^",1)
	s admloc=$p(^PAADM(Adm),"^",4)
	s:admloc'="" HospitalId=$p($G(^CTLOC(admloc)),"^",22) ;如果传入的为空取就诊科室
	s Param="^^^"_$g(HospitalId)
	s AppName=..%GetParameter("AppName")
	s UseRet=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"UseRet",Param)
	s (IngrFlag,RetOriFlag)=""
	&sql(select ori_ingrflag,ORI_RetOriFlag into :IngrFlag,:RetOriFlag from dhc_hvmat_orditm where ORI_OEORI_DR=:oeori)
	i ((UseRet="Y")&&(IngrFlag="Y")&&(RetOriFlag'="Y")) s RetFlag="N"
	
	q RetFlag
}

/// CreatDate: 2017-08-30 lihui
/// Description: 医嘱绑定高值条码撤销审核
/// Table: DHC_INTRANS,inc_itmloc,inc_itmlcbt,DHC_ItmTrack,DHC_ItmTrackDetail,DHC_HVMat_OrdItm
/// Input: 医嘱明细rowid,高值条码
/// Return: 0,成功；非0，错误
/// w ##class(web.DHCSTMHUI.PCHCOLLSM).ReturnHVByDhcit("7482||2",15674)
ClassMethod ReturnHVByDhcit(oeori As %String, dhcit As %String) As %String
{
	n (oeori,dhcit)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	q:oeori="" -1
	q:dhcit="" -1
	s ord=+oeori
	s itm=$p(oeori,"||",2)
	s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) 
	q:arcim="" -2
	s recloc=$p(^OEORD(ord,"I",itm,3),"^",6) 
	q:recloc="" -3
    s barcode=$p(^DHCIT(dhcit),"^",2)
	q:barcode="" -1
	s inci=$p(^DHCIT(dhcit),"^",1)
	q:inci="" -4
	s inci=$p(^DHCIT(dhcit),"^",1)
	s buomDr=$p(^INCI(inci,1),"^",10)

	s IntrTypeInfo=..sssOeoriTrType(oeori)
	s dispType=$p(IntrTypeInfo,"^",1)
	s intrType=$p(IntrTypeInfo,"^",2)

	s presc=$p(^OEORD(ord,"I",itm,1),"^",14)   	;处方号
	s userid=+$p(^OEORD(ord,"I",itm,1),"^",11)		;开单医生(CT_CareProv)
	s:userid'="" userid=$o(^SSU("SSUSR",0,"CTPCP",userid,0))
	s err=0

	l +^DHCOEDISPENSING(oeori):20  e  q -100   ;加锁
	tstart

	;s isDHCITDetail=$d(^DHCITD(0,"Type",intrType,"Pointer",oeori,dhcit))
	;存在的跟踪记录的可以再次添加,因为有台账ID不同,医嘱绑定条码使用,其他方法调用请注意；
	;i isDHCITDetail=0 {
		s operData="^"_userid_"^"_inci_"^^^"
		s RtnObj=##class(web.DHCSTMHUI.DHCItmTrack).Update(intrType,oeori,barcode,operData)
		i RtnObj.success'=0 d
		.s err=-11 
		.l -^DHCOEDISPENSING(oeori) 
		.tro 1
		q:err<0 err
	;}
	
	;2014-07-21:对于虚库高值,判断是否已经补录,如已补录进行特殊处理
	;2017-05-15:先记录跟踪信息,再处理补录单据
	s ret=##class(web.DHCSTMHUI.PCHCOLLSRela).HandleMainLocInfo(oeori,barcode)
	i ret<0 tro 1  l -^DHCOEDISPENSING(oeori) q ret

	//20170830 医嘱绑定高值条码有台帐记录的,处理库存相关 存在多个台账记录，不知取哪条？
	s trid=##class(web.DHCSTMHUI.DHCItmTrack).GetDhcitIntrID(dhcit,dispType,oeori)
	i +trid>0 {
		s inclb=$p(^DHCINTR(trid),"^",7)
		s qty=$p(^DHCINTR(trid),"^",6)
		s qty=-qty
		s rp=$p(^DHCINTR(trid),"^",16)
		s sp=$p(^DHCINTR(trid),"^",14)
		;handle stockQty
		s ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(inclb,qty)
		s:ret="" err=1
		i err>0 d
		.trollback 1
		.l -^DHCOEDISPENSING(oeori)
		q:err>0 err

		s rpAmt=rp*qty,spAmt=sp*qty
		s lstdata=intrType_"^"_presc_"^"_inclb_"^"_qty_"^"_buomDr_"^"_sp_"^"_userid_"^"_oeori_"^"_rp_"^"_rpAmt_"^"_spAmt
		s intrid=""
		s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(lstdata)
		s:RtnObj.success'=0 err=3
		i err>0 d
		.trollback 1
		.l -^DHCOEDISPENSING(oeori)
		q:err>0 err
		i RtnObj.success=0  s intrid=RtnObj.rowid ;记录台账ID
		//记录台账ID到DHC_ItmTrackDetail中
		s ret=##class(web.DHCSTMHUI.DHCItmTrack).UpdateDhcitIntrID(dhcit,intrid,intrType,oeori)
		s:ret'=0 err=-11
		i err<0 d
		.trollback 1
		.l -^DHCOEDISPENSING(oeori)
		q:err<0 err
	}
	tcommit
	l -^DHCOEDISPENSING(oeori)
	q 0
}

/// Descript:	根据高值短码,检索对应的高值条码信息(宁医大)
/// Creator:	wangjiabin
/// CreateDate:	2018-09-03
/// Input:		高值短码(又称批次码), FindFlag(1:精确查找, 0:模糊查询)
/// Output:		ArcimId(医嘱项rowid),ArcimCode(医嘱项代码),ArcimDesc(医嘱项名称),HVBarCode(系统高值条码),OriginalCode(出厂自带条码),
/// 			BatchCode(批次码)
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.PCHCOLLSM","GetDetailByShortCode","10")
Query GetDetailByShortCode(ShortCode, FindFlag = "1") As websys.Query(ROWSPEC = "ArcimId,ArcimCode,ArcimDesc,HVBarCode,OriginalCode,BatchCode")
{
}

ClassMethod GetDetailByShortCodeExecute(ByRef qHandle As %Binary, ShortCode, FindFlag = "1") As %Status
{
	n (qHandle,ShortCode,FindFlag)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s Status="Temp"
	s DHCIT=""
	f  s DHCIT=$o(^DHCIT(0,"Status",Status,DHCIT),-1) q:DHCIT=""  d
	.s BatchCode=$p(^DHCIT(DHCIT),"^",34)
	.q:(FindFlag=1)&&(BatchCode'=ShortCode)
	.q:(FindFlag=0)&&(BatchCode'[ShortCode)
	.s InciId=$p(^DHCIT(DHCIT),"^",1)
	.q:InciId=""
	.s ArcimId=$p(^INCI(InciId,1),"^",3)
	.q:ArcimId=""
	.s Sub=$p(ArcimId,"||",1),Ver=$p(ArcimId,"||",2)
	.q:(Sub="")||(Ver="")
	.s ArcimCode=$p(^ARCIM(Sub,Ver,1),"^",1)
	.s ArcimDesc=$p(^ARCIM(Sub,Ver,1),"^",1)
	.s HVBarCode=$p(^DHCIT(DHCIT),"^",2)
	.s OriginalCode=$p(^DHCIT(DHCIT),"^",13)
	.d OutPutShortCodeRow
	
	Quit $$$OK
OutPutShortCodeRow
	s Data=$lb(ArcimId,ArcimCode,ArcimDesc,HVBarCode,OriginalCode,BatchCode)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// zhangxiao
/// 20190525
/// 根据医嘱接收科室和高值条码获取该条码在医嘱接收科室的库存
/// 改为直接验证库存，库存足够返回Y ，否则返回N
/// w ##class(web.DHCSTMHUI.PCHCOLLSM).GetQtyByBarCode("764","1928-XHC01009-200101-20190521-190101-1111111111111111111111111111111111111111111111-1905220001","1")
ClassMethod GetQtyByBarCode(LocId, BarCode, ArcQty) As %String
{
	n (LocId,BarCode,ArcQty)
	;s ^zx(22)=$lb(LocId,BarCode,ArcQty)
	s dhcit="",OriginalStatus="",Qty=0,Flag="N"
	q:LocId="" Flag
	q:BarCode="" Flag
  	s dhcit=$o(^DHCIT(0,"LABEL",BarCode,0))
  	q:dhcit="" Flag
  	s OriginalStatus=$p(^DHCIT(dhcit),"^",35)
  	s Inclb=$p(^DHCIT(dhcit),"^",12)
  	s Status=$p(^DHCIT(dhcit),"^",5)
  	q:Status'="Enable" Flag
  	s NewInclb=##class(web.DHCSTMHUI.DHCItmTrack).GetInclbByInclb(LocId,Inclb)
  	q:NewInclb="" Flag
  	
  	s Inci=+NewInclb
	s IL=$p(NewInclb,"||",2)
	s LB=$p(NewInclb,"||",3)
	s Qty=$p(^INCI(Inci,"IL",IL,"LB",LB),"^",2)
	s DirtyQty=$p(^INCI(Inci,"IL",IL,"LB",LB),"^",3)
	s:DirtyQty="" DirtyQty=0
	;s Qty=Qty-DirtyQty  //可用数量等于库存数量减去占用数量？批次占用数量？
	s AvaQty=Qty-DirtyQty
	
	s BuomId=$p(^INCI(Inci,1),"^",10)
	s ArcId=$p(^INCI(Inci,1),"^",3)
	q:+ArcId=0 Flag
	s BillingUom=$p(^ARCIM(+ArcId,$p(ArcId,"||",2),8),"^",14)
	q:BillingUom="" Flag
	s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(BillingUom,BuomId) 
	s AvaQty=AvaQty/Fac
	i AvaQty>=ArcQty d
	.s Flag="Y"
	q Flag
}

/// 根据 BarCode 和Loc  获取某科室对应库存
/// 20201027
/// w ##class(web.DHCSTMHUI.PCHCOLLSM).GetQtyByBarCodeLoc("392","3333")
ClassMethod GetQtyByBarCodeLoc(LocId As %String, BarCode As %String) As %String
{
	n (LocId,BarCode)
	;s ^zx(222)=$lb(LocId,BarCode)
	s AvaQtyTotal=0,StkQty=0
	q:LocId="" StkQty_"^"_AvaQtyTotal
	q:BarCode="" StkQty_"^"_AvaQtyTotal
	
	s dhcit=$o(^DHCIT(0,"LABEL",BarCode,0))
	s:dhcit="" dhcit=$o(^DHCIT(0,"ORIGINALCODE",BarCode,0))
	q:dhcit="" StkQty_"^"_AvaQtyTotal
	s Inci=$p(^DHCIT(dhcit),"^",1)
	
	s TmpToInclb=""
	s Incib=0
	f  s Incib=$o(^DHCINCIB(0,"BarCode",Incib))  q:(Incib="")  d
	.s dhIncib=0
	.f  s dhIncib=$o(^DHCINCIB(0,"BarCode",Incib,BarCode,dhIncib)) q:(dhIncib="")  d
	..s Inci=+Incib
	..s IL=0
	..f  s IL=$o(^INCI("LB_IB",Incib,Inci,IL)) q:(IL="")  d
	...s TmpLoc=$p(^INCI(Inci,"IL",IL),"^",1)
	...q:TmpLoc'=LocId
	...s LB=0
	...f  s LB=$o(^INCI("LB_IB",Incib,Inci,IL,LB)) q:(LB="")  d
	....
	....s Inclb=Inci_"||"_IL_"||"_LB
	....s:TmpToInclb="" TmpToInclb=Inclb
	....s PhQty=$p(^INCI(Inci,"IL",IL,"LB",LB),"^",2)
	....s DirtyQty=$p(^INCI(Inci,"IL",IL,"LB",LB),"^",3)
	....s AvaQty=PhQty-DirtyQty
	....s AvaQtyTotal=AvaQty+AvaQtyTotal
	....s StkQty=StkQty+PhQty
	
	q StkQty_"^"_AvaQtyTotal
}

}
