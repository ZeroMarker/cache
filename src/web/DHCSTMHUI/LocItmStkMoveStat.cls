Import sqluser

/// Descript:台账单品汇总查询
/// Creater:    zhangxiao
/// CreateDate:	2018-01-27
/// 
Class web.DHCSTMHUI.LocItmStkMoveStat Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// StartDate As %String, EndDate As %String, Loc As %String, ItmDr As %String
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.LocItmStkMoveStat","QueryDetail","{""PhaLoc"":""392"",""gUserId"":""6444"",""gLocId"":""392"",""gGroupId"":""264"",""gHospId"":""2"",""StartDate"":""27/08/2017"",""EndDate"":""09/09/2018"",""StkScg"":"""",""Inci"":""3206"",""InciDesc"":""爱母环""}")	
Query QueryDetail(Params As %String(MAXLEN="")) As Query(ROWSPEC = "TrId,TrDate,BatExp,PurUom,Sp:%Float,Rp:%Float,EndQty:%Float,EndQtyUom,TrQty:%Float,TrQtyUom,RpAmt:%Float,SpAmt:%Float,TrNo,TrAdm,TrMsg,EndRpAmt:%Float,EndSpAmt:%Float,Vendor,Manf,OperateUser,HVBarCode,EndQtyUomInclb,TrPointer,HospDesc,LocDesc,gUserName,printTime") [ SqlProc ]
{
}

ClassMethod QueryDetailExecute(ByRef qHandle As %Binary, Params As %String(MAXLEN="")) As %Status
{
 n (qHandle,Params)
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 q:Params="" $$$OK  
 s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
 d PJobj.%FromJSON(Params)
 s StartDate=PJobj.%Get("StartDate")
 s EndDate=PJobj.%Get("EndDate") 
 s Loc=PJobj.%Get("PhaLoc")
 s ItmDr=PJobj.%Get("Inci")
 s gUserId=PJobj.%Get("gUserId")
 q:Loc="" $$$OK
 q:StartDate="" $$$OK
 s:StartDate'="" StartDate=..DH2L(StartDate)
 q:EndDate="" $$$OK
 s:EndDate'="" EndDate=..DH2L(EndDate)
 q:ItmDr="" $$$OK
 q:gUserId="" $$$OK
 /*
 s:StartDate["-" StartDate=$zdh(StartDate,3)
 s:EndDate["-" EndDate=$zdh(EndDate,3)
 s:StartDate["/" StartDate=$zdh(StartDate,4)
 s:EndDate["/" EndDate=$zdh(EndDate,4)
 */
 s LocDesc=$s(Loc'="":$p(^CTLOC(Loc),"^",2),1:"")
 s:$f(LocDesc,"-") LocDesc=$p(LocDesc,"-",2)
 s HospId=$s(Loc'="":$p(^CTLOC(Loc),"^",22),1:"")
 s HospDesc=$s(HospId'="":$p(^CT("HOSP",HospId),"^",2),1:"")
 s:gUserId'="" gUserName=$p(^SSU("SSUSR",gUserId),"^",2)
 s Chl=$o(^INCI("IL_LOC",Loc,ItmDr,0))
 q:Chl="" $$$OK
 s Incil=ItmDr_"||"_Chl
 i $p(Incil,"||",3)'="" d
 .s INCLB=Incil,Incil=$p(Incil,"||",1,2)		;参数INCIL可传入inclb
 
 s BUomId=$p(^INCI(ItmDr,1),"^",10)
 s PurUomId=$p(^INCI(ItmDr,3),"^",6)
 s PurUomDesc=""
 s:PurUomId'="" PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
 s Factor=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
 s HospId=$p(^CTLOC(Loc),"^",22)
 ;计算开始日期前一天的结余数量
 s TmpDate=StartDate-1
 s BegQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).LocDayQtyUom(ItmDr,Loc,BUomId,TmpDate)  ;期初库存(基本数量)
 s BegQtyUom=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(ItmDr,BegQty)
 s DaySp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(ItmDr,TmpDate,BUomId,HospId)
 s BegSpAmt=BegQty*DaySp
 s BegRpAmt=##class(web.DHCSTMHUI.LocItmTransMove).GetRpAmtOfStockQty(Incil,TmpDate)
 s EndQty=BegQty
 s EndSpAmt=BegSpAmt
 s EndRpAmt=BegRpAmt
 s printTime=..DL2H(+$h)
 f Date=StartDate:1:EndDate d
 .s TrId="" 
 .f  s TrId=$o(^DHCINTR(0,"INCI",ItmDr,Date,TrId)) q:TrId=""  d
 ..q:'$d(^DHCINTR(TrId))
 ..s Inclb=$p(^DHCINTR(TrId),"^",7)
 ..q:Inclb=""
 ..;q:(INCLB'="")&&(INCLB'=Inclb)		;批次过滤
 ..s TmpIncil=$p(Inclb,"||",1,2)
 ..q:Incil'=TmpIncil           ;非统计科室库存
 ..s Incib=$p(^INCI(ItmDr,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1) ;批次指针
 ..s BatStr=""
 ..i Incib'=""  d
 ...s BatNo=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",1)
 ...s ExpDate=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",2)
 ...s:ExpDate'="" ExpDate=..DL2H(ExpDate)
 ...s BatStr=BatNo_"~"_ExpDate
 ..s TrType=$p(^DHCINTR(TrId),"^",1)                                         ;交易类型
 ..s TrPointer=$p(^DHCINTR(TrId),"^",9)                                         ;交易指针
 ..s TrUom=$p(^DHCINTR(TrId),"^",10)                                        ;交易单位
 ..s TrQty=$p(^DHCINTR(TrId),"^",6)                                         ;交易数量
 ..s TrNo=$p(^DHCINTR(TrId),"^",13)                                        ;交易号
 ..b
 ..s TrUser=$p(^DHCINTR(TrId),"^",11)                                     ;交易人
 ..s OperateUser=""
 ..s:TrUser'="" OperateUser=$p($g(^SSU("SSUSR",TrUser)),"^",2)
 ..s TrTime=$p(^DHCINTR(TrId),"^",3)
 ..s TrSp=$p(^DHCINTR(TrId),"^",14)        ;业务发生的售价
 ..s TrRp=$p(^DHCINTR(TrId),"^",16)        ;业务发生的进价
 ..s TrSpAmt=$p(^DHCINTR(TrId),"^",8)        ;售价金额
 ..s TrRpAmt=$p(^DHCINTR(TrId),"^",17)        ;进价金额
 ..s StkQty=$p(^DHCINTR(TrId),"^",18)        ;结余库存量
 ..s StkLbQty=$p(^DHCINTR(TrId),"^",19)        ;结余库存量(批次)
 ..s FacTr=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(TrUom,BUomId)
 ..s TrQtyB=TrQty*FacTr              ;基本单位数量
 ..s BUomSp=TrSp/FacTr               ;基本单位售价
 ..s PurUomSp=BUomSp*Factor          ;包装单位售价
 ..s BUomRp=TrRp/FacTr    //##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,BUomId) ;批次进价(基本单位)
 ..s PurUomRp=BUomRp*Factor            ;批次进价(包装单位)
 ..s PurUomRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(PurUomRp,HospId,1)
 ..s Manf=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb)
 ..i Manf'=""  s Manf=$p(Manf,"^",2)
 ..s EndQty=StkQty  //EndQty+TrQtyB         ;本条记录的结余库存
 ..s EndQtyUom=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(ItmDr,EndQty)
 ..s EndQtyUomInclb=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(ItmDr,StkLbQty)
 ..s TrQtyUom=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(ItmDr,TrQtyB)
 ..s EndSpAmt=EndSpAmt+TrSpAmt       ;结余金额(售价)
 ..s EndRpAmt=EndRpAmt+TrRpAmt         ;结余金额(进价)
 ..s VendorInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(Inclb,Date)  ;该批次对应的最后一次入库的供应商
 ..s Vendor=$p(VendorInfo,"^",2)
 ..s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr(TrType,TrPointer)
 ..
 ..s TrAdm="BX",TrMsg="BX"
 ..
 ..i (TrType="P")||(TrType="PM")||(TrType="MP") d
 ...s TrMsg="物资住院医嘱"        ;摘要
 ...;s oeori=$$GetPHPORI(TrPointer)
 ...;s OrdInfo=..GetOrdInfo(oeori)
 ...s OrdInfo=##class(web.DHCSTMHUI.LocItmTransMove).GetOrdInfo(TrPointer)
 ...s TrAdm=$p(OrdInfo,"^",1)
 ...s TrNo=$p(OrdInfo,"^",2)
 ..
 ..i (TrType="Y")||(TrType="YM")||(TrType="MY") d
 ...s TrMsg="物资住院医嘱废除"
 ...;s oeori=$$GetPHYORI(TrPointer)
 ...;s OrdInfo=..GetOrdInfo(oeori)
 ...s OrdInfo=##class(web.DHCSTMHUI.LocItmTransMove).GetOrdInfo(TrPointer)
 ...s TrAdm=$p(OrdInfo,"^",1)
 ...s TrNo=$p(OrdInfo,"^",2)
 ..
 ..i (TrType="F")||(TrType="MF") d
 ...s TrMsg="物资门诊医嘱"
 ...;s oeori=$$GetORI(TrPointer)
 ...;s OrdInfo=..GetOrdInfo(oeori)
 ...s OrdInfo=##class(web.DHCSTMHUI.LocItmTransMove).GetOrdInfo(TrPointer)
 ...s TrAdm=$p(OrdInfo,"^",1)
 ...s TrNo=$p(OrdInfo,"^",2)
 ...
 ..
 ..i (TrType="H")||(TrType="MH") d
 ...s TrMsg="物资门诊医嘱废除"
 ...;s oeori=$$GetRetORI(TrPointer)
 ...;s OrdInfo=..GetOrdInfo(oeori)
 ...s OrdInfo=##class(web.DHCSTMHUI.LocItmTransMove).GetOrdInfo(TrPointer)
 ...s TrAdm=$p(OrdInfo,"^",1)
 ...s TrNo=$p(OrdInfo,"^",2)
 ...
 ..
 ..i TrType="S" d
 ...s TrMsg="物资非正常医嘱"
 ...q:'$d(^DHCINAD($p(TrPointer,"||",1)))
 ...q:'$d(^SSU("SSUSR",$p(^DHCINAD($p(TrPointer,"||",1)),"^",3)))
 ...s TrAdm=$p(^SSU("SSUSR",$p(^DHCINAD($p(TrPointer,"||",1)),"^",3)),"^",2)
 ...
 ..
 ..i TrType="Z" d
 ...s TrMsg="物资非正常医嘱废除"
 ...q:'$d(^DHCINAD($p(TrPointer,"||",1)))
 ...q:'$d(^SSU("SSUSR",$p(^DHCINAD($p(TrPointer,"||",1)),"^",3)))
 ...s TrAdm=$p(^SSU("SSUSR",$p(^DHCINAD($p(TrPointer,"||",1)),"^",3)),"^",2)
 ...
 ..
 ..i TrType="K" d
 ...s TrMsg="转移入库" 
 ...q:'$d(^DHCINIT($p(TrPointer,"||",1)))
 ...q:$p(^DHCINIT($p(TrPointer,"||",1)),"^",5)=""
 ...s TrAdm=$p(^CTLOC($p(^DHCINIT($p(TrPointer,"||",1)),"^",5)),"^",2)   ;出库科室
 ...
 ..
 ..i (TrType="T")!(TrType="I") d
 ...s TrMsg="转移出库"
 ...q:'$d(^DHCINIT($p(TrPointer,"||",1)))
 ...q:$p(^DHCINIT($p(TrPointer,"||",1)),"^",6)=""
 ...s TrAdm=$p(^CTLOC($p(^DHCINIT($p(TrPointer,"||",1)),"^",6)),"^",2)    ;转入科室
 ...
 ..
 ..i TrType="G" d
 ...s TrMsg="入库"
 ...q:'$d(^DHCINGR($p(TrPointer,"||",1)))
 ...q:$p(^DHCINGR($p(TrPointer,"||",1)),"^",8)=""
 ...;q:'$d(^DHCINGR("APCVM",$p(^DHCINGR($p(TrPointer,"||",1)),"^",8)))
 ...s TrAdm=$p(^SSU("SSUSR",$p(^DHCINGR($p(TrPointer,"||",1)),"^",8)),"^",2) 
 ...
 ..
 ..i TrType="D" d
 ...s TrMsg="库存报损"
 ...s INSPId=$p(TrPointer,"||",1)
 ...q:'$d(^DHCINSP(INSPId))
 ...q:$p(^DHCINSP(INSPId),"^",6)=""
 ...s TrAdm=$p(^SSU("SSUSR",$p(^DHCINSP(INSPId),"^",6)),"^",2)
 ...
 ..
 ..i TrType="A" d
 ...s TrMsg="库存调整"
 ...q:'$d(^DHCINAD($p(TrPointer,"||",1)))
 ...q:$p(^DHCINAD($p(TrPointer,"||",1)),"^",3)=""
 ...s TrAdm=$p(^SSU("SSUSR",$p(^DHCINAD($p(TrPointer,"||",1)),"^",3)),"^",2)
 ...
 ..
 ..i TrType="R" d
 ...s TrMsg="退货"
 ...s INGRT=$p(TrPointer,"||",1)
 ...q:INGRT=""
 ...q:'$d(^INGRT(INGRT))
 ...q:$p(^INGRT(INGRT),"^",5)=""
 ...s TrAdm=$p(^SSU("SSUSR",$p(^INGRT(INGRT),"^",5)),"^",2)
 ...
 ..
 ..i TrType="M" d
 ...s TrMsg="制剂加工"
 ...q:'$d(^DHCINMAN(TrPointer))
 ...s Manuser=$p(^DHCINMAN(TrPointer),"^",23)
 ...q:Manuser=""
 ...s TrAdm=$p(^SSU("SSUSR",Manuser),"^",2)
 ...
 ..
 ..i TrType="X" d
 ...s TrMsg="制剂消耗"
 ...q:'$d(^DHCINMAN(+TrPointer)) 
 ...s Manuser=$p(^DHCINMAN(+TrPointer),"^",23)
 ...q:Manuser=""
 ...s TrAdm=$p(^SSU("SSUSR",Manuser),"^",2)
 ...
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
 ..s Data=$lb(TrId,..DL2H(Date)_"*"_..TL2H(TrTime),BatStr,PurUomDesc,PurUomSp,PurUomRp,EndQty,EndQtyUom,TrQtyB,TrQtyUom,TrRpAmt,TrSpAmt,TrNo,TrAdm,TrMsg,EndRpAmt,EndSpAmt,Vendor,Manf,OperateUser,HVBarCode,EndQtyUomInclb,TrPointer,HospDesc,LocDesc,gUserName,printTime) 
 ..s ^CacheTemp(repid,ind)=Data
 ..s ind=ind+1
 
 Quit $$$OK
}

}
