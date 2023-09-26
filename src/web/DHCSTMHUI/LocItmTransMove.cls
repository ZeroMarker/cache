Import sqluser

/// Descript:台帐查询
/// Creater:    ZhangDongmei
/// CreateDate: 2012-08-09
Class web.DHCSTMHUI.LocItmTransMove Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:   查询药品库存
/// Creater:    ZhangDongmei
/// CreateDate: 2012-08-09
/// Table:INC_ItmLoc,DHC_InTrans
/// Input:开始日期，截止日期,统计科室id,
/// 	类组id^库存分类id^库存项id^库存类型^^是否重点关注^统计标志(0:全部;1:零消耗;2:非零消耗)^规格^物资描述
/// Output:入库明细
/// Return：INCIL^库存项代码^库存项名称^库存分类^入库单位^基本单位^期初数量(基本单位)
/// ^期初数量(带单位)^期初金额(进价)^期初金额(售价)^期末数量(基本单位)^期末数量(带单位)
/// ^期末金额(进价)^期末金额(售价)
/// 
/// Others:目前台帐查询用 
/// w ##class(web.DHCSTMHUI.LocItmTransMove).LocItmStkMoveSum(1,15,$g(^tempxj(1)))
ClassMethod LocItmStkMoveSum(page, rows, Params As %String = "") As %Library.String
{
	n (page,rows,Params)
	s Start=(page-1)*rows
	s Limit=rows
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s LocId=PJObj.%Get("PhaLoc")
	s User=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gHospId=PJObj.%Get("gHospId")
	s StkGrpId=PJObj.%Get("StkGrpId")
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s StkCatId=PJObj.%Get("StkCat")
	s QueryFlag=PJObj.%Get("QueryFlag")
	s StockType=PJObj.%Get("StockType")
	s pMonitorFlag=PJObj.%Get("MonitorFlag")
	s ItmDesc=PJObj.%Get("InciDesc")
	s InciRowid=PJObj.%Get("Inci")
	s MinRp=PJObj.%Get("MinRp")
	s MaxRp=PJObj.%Get("MaxRp")
	s INFOSpec=PJObj.%Get("Spec")
	q:StartDate="" $$$NullJson
	q:EndDate="" $$$NullJson
	q:LocId="" $$$NullJson
	s:StartDate'="" StartDate=..DH2L(StartDate)
	s:EndDate'="" EndDate=..DH2L(EndDate)
	s pHospId=..sssHospId(LocId)
	s StkGrpId=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(User,..sssCode(),LocId,StkGrpId,pHospId)
	s HospId=$p(^CTLOC(LocId),"^",22)
	s End=Start+Limit
	Set json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	s Num=0
	s Inci=""
	f  s Inci=$o(^INCI("IL_LOC",LocId,Inci)) q:Inci=""  d
	.q:$o(^DHCLOCTOT(0,"LOCITMDATE",LocId,Inci,EndDate+1),-1)=""
	.s ChlSub=$o(^INCI("IL_LOC",LocId,Inci,0)) 
	.q:ChlSub=""
	.q:(InciRowid'="")&(InciRowid'=Inci)
	.s GrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s GrpId=$p(GrpInfo,"^",5)  
	.s GrpType=$p(GrpInfo,"^",3)
	.q:GrpType'=..sssCode()                     
	.q:(StkGrpId'="")&(("^"_StkGrpId_"^")'[("^"_GrpId_"^"))  //按类组过滤
	.s IncscDr=$p(^INCI(Inci,2),"^",2)
	.q:(StkCatId'="")&(IncscDr'=StkCatId)               //库存分类
	.s MonitorFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMonitorFlag(Inci)
	.q:(pMonitorFlag'="")&(MonitorFlag'= pMonitorFlag)           //是否为重点标志材料
	.s INCIL=Inci_"||"_ChlSub
	.s Flag=..CheckTrans(INCIL,StartDate,EndDate)
	.q:(QueryFlag=1)&(Flag=1)                   //只统计零消耗
	.q:(QueryFlag=2)&(Flag'=1)                  //只统计非零消耗
	.s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
	.q:(INFOSpec'="")&(INFOSpec'=Spec)
	.s InciCode=$p(^INCI(Inci,1),"^",1)
	.s InciDesc=$p(^INCI(Inci,1),"^",2) 
	.q:(ItmDesc'="")&(InciDesc'[ItmDesc)
	.s BUomId=$p(^INCI(Inci,1),"^",10)
	.s BUomDesc=$s(BUomId'="":$p(^CT("UOM",BUomId),"^",2),1:"")			;基本单位
	.s PurUomId=$p(^INCI(Inci,3),"^",6)
	.s PurUomDesc=$s(PurUomId'="":$p(^CT("UOM",PurUomId),"^",2),1:"")	;入库单位
	.s StkCatDesc=$s(IncscDr'="":$p(^INC("SC",IncscDr),"^",2),1:"")
	.s BegQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).LocDayQtyUom(Inci,LocId,BUomId,StartDate-1)	;期初库存(基本数量)
	.s EndQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).LocDayQtyUom(Inci,LocId,BUomId,EndDate)		;期末库存(基本数量)
	.q:(StockType=1)&&(EndQty'=0)		;只检索库存为零记录
	.q:(StockType=2)&&(EndQty'>0)		;只检索库存为正记录
	.q:(StockType=3)&&(EndQty'<0)		;只检索库存为负记录
	.q:(StockType=4)&&(EndQty=0)		;只检索非零库存
	.
	.s Num=Num+1
	.q:Num<=Start
	.q:Num>End
	.
	.s BegQtyUom=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(Inci,BegQty)
	.s EndQtyUom=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(Inci,EndQty)
	.
	.s BegSp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inci,StartDate-1,BUomId,HospId)		;期初售价
	.s EndSp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inci,EndDate,BUomId,HospId)		;期末售价
	.s BegSpAmt=BegSp*BegQty     ;期初金额(售价)
	.s EndSpAmt=EndSp*EndQty
	.s BegRpAmt=..GetRpAmtOfStockQty(INCIL,StartDate-1)    ;期初金额(进价)
	.s EndRpAmt=..GetRpAmtOfStockQty(INCIL,EndDate)     ;期末金额(进价)
	.s MatInsuInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMatInsuInfo(Inci,HospId)
	.s MatInsuCode=$p(MatInsuInfo,"^",1)
	.s MatInsuDesc=$p(MatInsuInfo,"^",2)
	.s Data1=INCIL_"^"_InciCode_"^"_InciDesc_"^"_StkCatDesc_"^"_PurUomDesc
	.s Data2=BUomDesc_"^"_BegQty_"^"_BegQtyUom_"^"_BegRpAmt_"^"_BegSpAmt
	.s Data3=EndQty_"^"_EndQtyUom_"^"_EndRpAmt_"^"_EndSpAmt_"^"_Spec_"^"_MatInsuCode_"^"_MatInsuDesc
	.s Data=Data1_"^"_Data2_"^"_Data3
	.d json.InsertRowData(Data)
	
	s TitleStr="INCIL^InciCode^InciDesc^StkCat^PurUom"
		_"^BUom^BegQty:number^BegQtyUom:number^BegRpAmt:number^BegSpAmt:number"
		_"^EndQty:number^EndQtyUom:number^EndRpAmt:number^EndSpAmt:number^Spec^MatInsuCode^MatInsuDesc"
	d json.getJsonData(TitleStr,Num)
	k json
	q ""
}

/// Descript:检测某科室库存项在指定的日期范围内是否发生过业务
/// Creater:    ZhangDongmei
/// CreateDate: 2012-12-24
/// Table:DHC_InTrans
/// Input:科室库存项id,开始日期，截止日期
/// Output:
/// Return：0：未发生过业务；1:发生过业务
/// 
ClassMethod CheckTrans(Incil, SD, ED)
{
	n (Incil,SD,ED)
	s Flag=0   ;零消耗
	f DD=SD:1:ED q:Flag=1  d
	.s TmpType=""
	.f  s TmpType=$o(^DHCINTR(0,"ILTYPEDATE",Incil,TmpType)) q:(TmpType="")!(Flag=1)  d
	..s TrId=""
	..f  s TrId=$o(^DHCINTR(0,"ILTYPEDATE",Incil,TmpType,DD,TrId)) q:(TrId="")!(Flag=1)  d
	...s Flag=1
	..
	.
	q Flag
}

/// Descript:查询台帐明细
/// Creater:    ZhangDongmei
/// CreateDate: 2012-02-16
/// Table:DHC_InTrans
/// Input:开始行,每页记录数,开始日期，截止日期,INC_ItmLoc表id
/// Output:	Start, Limit, StartDate, EndDate, INCIL(也可能是inclb), RpType(进价^大于^小于)
/// Return：业务日期^批号^单位^售价^进价^结余数量(基本单位)^结余数量(带单位)^增减数量(基本单位)
/// ^增减数量(带单位)^增减金额(进价)^增减金额(售价)^处理号^处理人^摘要
/// ^期末金额(进价)^期末金额(售价)^供应商^生产厂家^操作人^批次结存数量
/// Others:	2016-12-12 参数INCIL也可能传入inclb,用作统计批次台帐信息
/// w ##class(web.DHCSTMHUI.LocItmTransMove).LocItmStkMoveDetail(1,15,$g(^tempxj(2)),"10703||1")
ClassMethod LocItmStkMoveDetail(page, rows, ParamStr As %String = "", INCIL As %String = "") As %Library.String
{
	n (page,rows,ParamStr,INCIL)
	;s ^tempxj(2)=ParamStr
	s Start=(page-1)*rows
	s Limit=rows
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(ParamStr)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s MinRp=PJObj.%Get("MinRp")
	s MaxRp=PJObj.%Get("MaxRp")
	s PTransType=PJObj.%Get("TransType")

	q:StartDate="" ""
	q:EndDate="" ""
	q:INCIL="" ""
	s:StartDate'="" StartDate=..DH2L(StartDate)
	s:EndDate'="" EndDate=..DH2L(EndDate)
	s INCLB=""
	i $p(INCIL,"||",3)'="" d
	.s INCLB=INCIL,INCIL=$p(INCIL,"||",1,2)		;参数INCIL可传入inclb
	s json=##class(web.DHCSTMHUI.Common.JsonObj).%New()
	s End=Start+Limit

	s Inci=+INCIL
	s IL=$p(INCIL,"||",2)
	s LocId=$p(^INCI(Inci,"IL",IL),"^",1)
	s HospId=$p(^CTLOC(LocId),"^",22)
	s BUomId=$p(^INCI(Inci,1),"^",10)
	s PurUomId=$p(^INCI(Inci,3),"^",6)
	s PurUomDesc=$s(PurUomId'="":$p(^CT("UOM",PurUomId),"^",2),1:"")
	s Factor=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	;计算开始日期前一天的结余数量
	s TmpDate=StartDate-1
	s BegQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).LocDayQtyUom(Inci,LocId,BUomId,TmpDate)  ;期初库存(基本数量)
	s BegQtyUom=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(Inci,BegQty)
	s DaySp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inci,TmpDate,BUomId,HospId)
	s BegSpAmt=BegQty*DaySp
	s BegRpAmt=..GetRpAmtOfStockQty(INCIL,TmpDate)
	s BegSpAmt=..GetSpAmtOfStockQty(INCIL,TmpDate)
	s (BegQtyInclb,BegQtyInclbUom)=""
	i INCLB'="" d
	.s BegQtyInclb=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(INCLB,TmpDate)
	.s BegQtyInclbUom=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(Inci,BegQtyInclb)
	.s BegQtyUom=BegQtyInclbUom
	.s BegRpAmt=..GetRpAmtOfStockQty(INCLB,TmpDate)
	.s BegSpAmt=..GetSpAmtOfStockQty(INCLB,TmpDate)
	s Data="QS^"_..DL2H(StartDate)_"*00:00:01"_"^^^^^"_BegQty_"^"_BegQtyUom_"^^"
		_"^^^^^^"_BegRpAmt_"^"_BegSpAmt_"^^^"
		_"^^"_BegQtyInclbUom
	s Num=1
	i (Num>=Start)&&(Num<=End)  d
	.d json.InsertRowData(Data)

	s EndQty=BegQty
	s EndSpAmt=BegSpAmt
	s EndRpAmt=BegRpAmt
	f Date=StartDate:1:EndDate d
	.s TrId="" 
	.f  s TrId=$o(^DHCINTR(0,"INCI",Inci,Date,TrId)) q:TrId=""  d
	..q:'$d(^DHCINTR(TrId))
	..s IntrInfo=^DHCINTR(TrId)
	..s Inclb=$p(IntrInfo,"^",7)
	..q:Inclb=""
	..q:(INCLB'="")&&(INCLB'=Inclb)		;批次过滤
	..s TmpIncil=$p(Inclb,"||",1,2)
	..q:INCIL'=TmpIncil					;非统计科室库存
	..s IL=$p(Inclb,"||",2),LB=$p(Inclb,"||",3)
	..s Incib=$p(^INCI(Inci,"IL",IL,"LB",LB),"^",1)
	..s BatStr=""
	..i Incib'="" d
	...s IB=$p(Incib,"||",2)
	...s BatNo=$p(^INCI(Inci,"IB",IB),"^",1)
	...s ExpDate=$p(^INCI(Inci,"IB",IB),"^",2)
	...s:ExpDate'="" ExpDate=..DL2H(ExpDate)
	...s BatStr=BatNo_"~"_ExpDate
	..
	..s TrType=$p(IntrInfo,"^",1)				;类型
	..s TrTime=$p(IntrInfo,"^",3)
	..s TrQty=$p(IntrInfo,"^",6)				;数量
	..s TrSpAmt=$p(IntrInfo,"^",8)				;售价金额
	..s TrPointer=$p(IntrInfo,"^",9)			;指针
	..s TrUom=$p(IntrInfo,"^",10)				;单位
	..s TrUser=$p(IntrInfo,"^",11)
	..s TrNo=$p(IntrInfo,"^",13)				;交易号
	..s TrSp=$p(IntrInfo,"^",14)				;业务发生的售价
	..s TrRp=$p(IntrInfo,"^",16)				;业务发生的进价
	..s TrRpAmt=$p(IntrInfo,"^",17)				;进价金额
	..s StkQty=$p(IntrInfo,"^",18)				;结余库存量
	..s StkLbQty=$p(IntrInfo,"^",19)			;结余库存量(批次)
	..q:(PTransType'="")&&(TrType'=PTransType)
	..q:(MinRp'="")&&(TrRp<=MinRp)
	..q:(MaxRp'="")&&(TrRp>=MaxRp)
	..
	..s Num=Num+1
	..q:Num<=Start
	..q:Num>End
	..
	..s OperateUser=""
	..s:TrUser'="" OperateUser=$p(^SSU("SSUSR",TrUser),"^",2)
	..s FacTr=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(TrUom,BUomId)
	..s TrQtyB=TrQty*FacTr						;基本单位数量
	..s BUomRp=TrRp/FacTr
	..s BUomSp=TrSp/FacTr						;基本单位售价
	..s PurUomSp=BUomSp*Factor					;包装单位售价
	..s PurUomRp=BUomRp*Factor					;包装单位进价
	..s PurUomRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(PurUomRp,HospId,1)
	..
	..s EndQty=StkQty							;本条记录的结余库存
	..s EndQtyUom=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(Inci,EndQty)
	..s EndQtyUomInclb=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(Inci,StkLbQty)
	..s:INCLB'="" EndQtyUom=EndQtyUomInclb
	..s TrQtyUom=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(Inci,TrQtyB)
	..
	..s EndSpAmt=EndSpAmt+TrSpAmt				;结余金额(售价)
	..s EndRpAmt=EndRpAmt+TrRpAmt				;结余金额(进价)
	..s ManfInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb)
	..s Manf=$p(ManfInfo,"^",2)
	..s VendorInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(Inclb,Date)  ;该批次对应的最后一次入库的供应商
	..s Vendor=$p(VendorInfo,"^",2)
	..s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr(TrType,TrPointer)
	..s:HVBarCode="" HVBarCode=##class(web.DHCSTMHUI.DHCItmTrackDetailAddion).GetAddionLabel(TrType,TrPointer)
	..
	..s TrAdm="BX",TrMsg="BX",PatName="",OEORIOrdDeptDesc=""
	..
	..i (TrType="P")||(TrType="PM")||(TrType="MP") d
	...s TrMsg="物资住院医嘱"        ;摘要
	...s OrdInfo=..GetOrdInfo(TrPointer)
	...s TrAdm=$p(OrdInfo,"^",1)_","_$p(OrdInfo,"^",3)
	...s TrNo=$p(OrdInfo,"^",2)
	...s PatName=$p(OrdInfo,"^",3)
	...s OEORIOrdDeptDesc=$p(OrdInfo,"^",4)
	..
	..i (TrType="Y")||(TrType="MY") d
	...s TrMsg="物资住院医嘱废除"
	...s OrdInfo=..GetOrdInfo(TrPointer)
	...s TrAdm=$p(OrdInfo,"^",1)_","_$p(OrdInfo,"^",3)
	...s TrNo=$p(OrdInfo,"^",2)
	...s PatName=$p(OrdInfo,"^",3)
	...s OEORIOrdDeptDesc=$p(OrdInfo,"^",4)
	..
	..i (TrType="F")||(TrType="MF") d
	...s TrMsg="物资门诊医嘱"
	...s OrdInfo=..GetOrdInfo(TrPointer)
	...s TrAdm=$p(OrdInfo,"^",1)_","_$p(OrdInfo,"^",3)
	...s TrNo=$p(OrdInfo,"^",2)
	...s PatName=$p(OrdInfo,"^",3)
	...s OEORIOrdDeptDesc=$p(OrdInfo,"^",4)
	..
	..i (TrType="H")||(TrType="MH") d
	...s TrMsg="物资门诊医嘱废除"
	...s OrdInfo=..GetOrdInfo(TrPointer)
	...s TrAdm=$p(OrdInfo,"^",1)_","_$p(OrdInfo,"^",3)
	...s TrNo=$p(OrdInfo,"^",2)
	...s PatName=$p(OrdInfo,"^",3)
	...s OEORIOrdDeptDesc=$p(OrdInfo,"^",4)
	..
	..;20210715
	..i (TrType="MDP") d
	...s TrMsg="物资住院发放" 
	...s TrNo=$lg(^User.DHCInMatDispD(+TrPointer),2)
	...s TrAdmId=$lg(^User.DHCInMatDispD(+TrPointer),6)
	...s TrAdm=""
	...s:TrAdmId'="" TrAdm=$p(^CTLOC(TrAdmId),"^",2)
	...
	..
	..i (TrType="MDY") d
	...s TrMsg="物资住院退回" 
	...s TrNo=$lg(^User.DHCInMatRetD(+TrPointer),2)
	...s TrAdmId=$lg(^User.DHCInMatRetD(+TrPointer),6)
	...s TrAdm=""
	...s:TrAdmId'="" TrAdm=$p(^CTLOC(TrAdmId),"^",2)
	..
	..i TrType="K" d
	...s TrMsg="出库接收" 
	...q:'$d(^DHCINIT($p(TrPointer,"||",1)))
	...q:$p(^DHCINIT($p(TrPointer,"||",1)),"^",5)=""
	...s TrAdm=$p(^CTLOC($p(^DHCINIT($p(TrPointer,"||",1)),"^",5)),"^",2)	;出库科室
	..
	..i (TrType="T") d
	...s TrMsg="出库"
	...q:'$d(^DHCINIT($p(TrPointer,"||",1)))
	...q:$p(^DHCINIT($p(TrPointer,"||",1)),"^",6)=""
	...s TrAdm=$p(^CTLOC($p(^DHCINIT($p(TrPointer,"||",1)),"^",6)),"^",2)	;转入科室
	..
	..i TrType="G" d
	...s TrMsg="入库"
	...q:'$d(^DHCINGR($p(TrPointer,"||",1)))
	...q:$p(^DHCINGR($p(TrPointer,"||",1)),"^",8)=""
	...s TrAdm=$p(^SSU("SSUSR",$p(^DHCINGR($p(TrPointer,"||",1)),"^",8)),"^",2) 
	..
	..i TrType="D" d
	...s TrMsg="库存报损"
	...s INSPId=$p(TrPointer,"||",1)
	...q:'$d(^DHCINSP(INSPId))
	...q:$p(^DHCINSP(INSPId),"^",6)=""
	...s TrAdm=$p(^SSU("SSUSR",$p(^DHCINSP(INSPId),"^",6)),"^",2)
	..
	..i TrType="A" d
	...s TrMsg="库存调整"
	...q:'$d(^DHCINAD($p(TrPointer,"||",1)))
	...q:$p(^DHCINAD($p(TrPointer,"||",1)),"^",3)=""
	...s TrAdm=$p(^SSU("SSUSR",$p(^DHCINAD($p(TrPointer,"||",1)),"^",3)),"^",2)
	..
	..i TrType="R" d
	...s TrMsg="退货"
	...s INGRT=$p(TrPointer,"||",1)
	...q:INGRT=""
	...q:'$d(^INGRT(INGRT))
	...q:$p(^INGRT(INGRT),"^",5)=""
	...s TrAdm=$p(^SSU("SSUSR",$p(^INGRT(INGRT),"^",5)),"^",2)
	..
	..i TrType="C" d
	...s TrMsg="科室内发放"
	...q:'$d(^DHCINDS(+TrPointer))
	...s userDr=$p(^DHCINDS(+TrPointer),"^",4)
	...q:userDr=""
	...s TrAdm=$p(^SSU("SSUSR",userDr),"^",2)
	..
	..i TrType="L" d
	...s TrMsg="科室内退回"
	...q:'$d(^DHCINDSR(+TrPointer))
	...s userDr=$p(^DHCINDSR(+TrPointer),"^",4)
	...q:userDr=""
	...s TrAdm=$p(^SSU("SSUSR",userDr),"^",2)
	..i TrType="RT" d
	...s TrMsg="红冲退库"
	...q:'$d(^HRP.MAT.INGRRedOffsetD(+TrPointer))
	...q:'$d(^HRP.MAT.INGRRedOffsetD(+TrPointer,"Itm",$P(TrPointer,"||",2)))
	...s LocInclb=$lg(^HRP.MAT.INGRRedOffsetD(+TrPointer,"Itm",$P(TrPointer,"||",2)),3)
	...q:LocInclb=""
	...s Loc=$p(^INCI($p(LocInclb,"||",1),"IL",$p(LocInclb,"||",2)),"^",1)
	...q:Loc=""
	...s TrAdm=$p(^CTLOC(Loc),"^",2)
	..i TrType="RK" d
	...s TrMsg="红冲退库接收"
	...q:'$d(^HRP.MAT.INGRRedOffsetD(+TrPointer,"Itm",$P(TrPointer,"||",2)))
	...s LocInclb=$lg(^HRP.MAT.INGRRedOffsetD(+TrPointer,"Itm",$P(TrPointer,"||",2)),3)
	...q:LocInclb=""
	...s Loc=$p(^INCI($p(LocInclb,"||",1),"IL",$p(LocInclb,"||",2)),"^",1)
	...q:Loc=""
	...s TrAdm=$p(^CTLOC(Loc),"^",2)
	..i TrType="NT" d
	...s TrMsg="红冲出库"
	...q:'$d(^HRP.MAT.INGRRedOffsetD(+TrPointer,"Itm",$P(TrPointer,"||",2)))
	...s LocInclb=$lg(^HRP.MAT.INGRRedOffsetD(+TrPointer,"Itm",$P(TrPointer,"||",2)),3)
	...q:LocInclb=""
	...s Loc=$p(^INCI($p(LocInclb,"||",1),"IL",$p(LocInclb,"||",2)),"^",1)
	...q:Loc=""
	...s TrAdm=$p(^CTLOC(Loc),"^",2)
	..i TrType="NK" d
	...s TrMsg="红冲出库接收"
	...q:'$d(^HRP.MAT.INGRRedOffsetD(+TrPointer,"Itm",$P(TrPointer,"||",2)))
	...s LocInclb=$lg(^HRP.MAT.INGRRedOffsetD(+TrPointer,"Itm",$P(TrPointer,"||",2)),3)
	...q:LocInclb=""
	...s Loc=$p(^INCI($p(LocInclb,"||",1),"IL",$p(LocInclb,"||",2)),"^",1)
	...q:Loc=""
	...s TrAdm=$p(^CTLOC(Loc),"^",2)
	..
	..s DateTime=..DL2H(Date)_" "_..TL2H(TrTime)
	..s Data1=TrId_"^"_DateTime_"^"_BatStr_"^"_PurUomDesc_"^"_PurUomSp_"^"_PurUomRp_"^"_EndQty_"^"_EndQtyUom_"^"_TrQtyB_"^"_TrQtyUom
	..s Data2=TrRpAmt_"^"_TrSpAmt_"^"_TrNo_"^"_TrAdm_"^"_TrMsg_"^"_EndRpAmt_"^"_EndSpAmt_"^"_Vendor_"^"_Manf_"^"_OperateUser
	..s Data3=HVBarCode_"^"_EndQtyUomInclb_"^"_TrPointer_"^"_PatName_"^"_OEORIOrdDeptDesc
	..s Data=Data1_"^"_Data2_"^"_Data3
	..d json.InsertRowData(Data)
	..d OutAspAmount("YW")
	..d OutAspAmount("KC")
	s Title="TrId^TrDate^BatExp^PurUom^Sp:number^Rp:number^EndQty:number^EndQtyUom:number^TrQty:number^TrQtyUom:number"
		_"^RpAmt:number^SpAmt:number^TrNo^TrAdm^TrMsg^EndRpAmt:number^EndSpAmt:number^Vendor^Manf^OperateUser"
		_"^HVBarCode^EndQtyUomInclb^TrPointer^PatName^OEORIOrdDeptDesc"
	d json.getJsonData(Title,Num)
	k json
	q ""
OutAspAmount(ASPTYPE)
 s AspId=""
 f  s AspId=$O(^ASPA(0,"TranType",ASPTYPE,"Trans",TrId,AspId)) q:AspId=""  d
 .s AspAmoutRpAmt=$p(^ASPA(AspId),"^",12)
 .s AspAmoutSpAmt=$p(^ASPA(AspId),"^",5)
 .s AspDate=$p(^ASPA(AspId),"^",8)
 .s AspTime=$p(^ASPA(AspId),"^",9)
 .s EndRpAmt=EndRpAmt+AspAmoutRpAmt
 .s EndSpAmt=EndSpAmt+AspAmoutSpAmt
 .s Adjno=$p(^ASPA(AspId),"^",6)
 .s DateTime=..DL2H(AspDate)_" "_..TL2H(AspTime)
 .s Data1=TrId_"^"_DateTime_"^"_BatStr_"^"_PurUomDesc_"^"_PurUomSp_"^"_PurUomRp_"^"_EndQty_"^"_EndQtyUom_"^"_0_"^"_0
 .s Data2=AspAmoutRpAmt_"^"_AspAmoutSpAmt_"^"_Adjno_"^"_TrAdm_"^"_"调价损益"_"^"_EndRpAmt_"^"_EndSpAmt_"^"_Vendor_"^"_Manf_"^"_OperateUser
 .s Data3=""
 .s Data=Data1_"^"_Data2_"^"_Data3
 .s Num=Num+1
 .q:Num<=Start
 .q:Num>End
 .d json.InsertRowData(Data)
}

/// Descript:取医嘱信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-02-17
/// Table:
/// Input:OE_OrdItem表id
/// Output:
/// Return：病人就诊号^处方号
/// Others:
ClassMethod GetOrdInfo(Oeori) As %Library.String
{
	n (Oeori)
	q:Oeori="" ""
	s Ord=$p(Oeori,"||",1)
	s Chl=$p(Oeori,"||",2)
	s Adm=$p($g(^OEORD(Ord)),"^",1)
	s PatNo=""
	s PrescNo=""
	s PrescNo="",PatName="",OEORIOrdDeptDesc=""
	i Adm'="" d
	.s PaPmi=$p(^PAADM(Adm),"^",1)
	.s PatNo=$p(^PAPER(PaPmi,"PAT",1),"^",1)   ;病人就诊号（处理人）
	.s PatName=$p($g(^PAPER(PaPmi,"ALL")),"^",1)             //病人姓名
	i $d(^OEORD(Ord,"I",Chl,1)) d
	.s PrescNo=$p(^OEORD(Ord,"I",Chl,1),"^",14)   ;处理号
	.s OEORIOrdDeptDR=$P($G(^OEORD(Ord,"I",Chl,1)),"^",3)
	.s:OEORIOrdDeptDR'="" OEORIOrdDeptDesc=$p($g(^CTLOC(OEORIOrdDeptDR)),"^",2)	//开单科室
	q PatNo_"^"_PrescNo_"^"_PatName_"^"_OEORIOrdDeptDesc
}

/// Descript:计算库存进价金额
/// Table:
/// Input:		INC_ItmLoc表id(或Inclb)，库存日期
/// Output:
/// Return：进价金额
/// Others:
/// w ##class(web.DHCSTMHUI.LocItmTransMove).GetRpAmtOfStockQty("4442||3",+$h)
ClassMethod GetRpAmtOfStockQty(Incil, Date) As %Library.String
{
	n (Incil,Date)
	q:Incil="" 0
	q:Date="" 0
	s Inci=+Incil,IL=$p(Incil,"||",2),LBSub=$p(Incil,"||",3)
	s BUomId=$p(^INCI(Inci,1),"^",10)
	
	s LocId=$p(^INCI(Inci,"IL",IL),"^",1)
	s HospId=$p(^CTLOC(LocId),"^",22)
	i (LBSub="") d
	.s ILQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(Inci,LocId,Date)
	q:(LBSub="")&&(+ILQty=0) 0
	
	s RpAmt=0
	s LB=0
	f  s LB=$o(^INCI(Inci,"IL",IL,"LB",LB)) q:LB=""  d
	.q:(LBSub'="")&&(LB'=LBSub)		;按Inclb过滤
	.s Inclb=Inci_"||"_IL_"||"_LB
	.s Qty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(Inclb,Date)
	.q:+Qty=0
	.s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,BUomId,HospId,"",Date)
	.q:+Rp=0
	.s RpAmt=RpAmt+(Qty*Rp)
	q RpAmt
}

/// Descript:计算库存售价金额
/// Input: Incil(或Inclb), Date
ClassMethod GetSpAmtOfStockQty(Incil, Date) As %Library.String
{
	n (Incil,Date)
	q:Incil="" 0
	q:Date="" 0
	s Inci=+Incil,IL=$p(Incil,"||",2),LBSub=$p(Incil,"||",3)
	s BUomId=$p(^INCI(Inci,1),"^",10)
	
	s LocId=$p(^INCI(Inci,"IL",IL),"^",1)
	s HospId=$p(^CTLOC(LocId),"^",22)
	i (LBSub="") d
	.s ILQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(Inci,LocId,Date)
	q:(LBSub="")&&(+ILQty=0) 0
	
	s SpAmt=0
	s LB=0
	f  s LB=$o(^INCI(Inci,"IL",IL,"LB",LB)) q:LB=""  d
	.q:(LBSub'="")&&(LB'=LBSub)		;按Inclb过滤
	.s Inclb=Inci_"||"_IL_"||"_LB
	.s Qty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(Inclb,Date)
	.q:+Qty=0
	.s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetSp(Inclb,Date,BUomId,HospId)
	.q:+Sp=0
	.s SpAmt=SpAmt+(Qty*Sp)
	q SpAmt
}

}
