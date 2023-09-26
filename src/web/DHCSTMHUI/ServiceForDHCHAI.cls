Import sqluser

/// Descript:	提供医务管理（院感）
/// Creator:	lihui
/// CreateDate:	20211228
Class web.DHCSTMHUI.ServiceForDHCHAI Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// 出库数据
/// Author: lihui
/// Date: 20200922
/// OutPut：唯一ID,科室ID,科室名称,出库审核人ID,审核人,日期,物资代码,物资名称,规格,单位,数量,,,备注,库存分类ID,库存分类代码,库存分类名称,医院
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.ServiceForDHCHAI","QueryMatTrf","2020-01-01","2021-12-04",163,"")
Query QueryMatTrf(StartDate, EndDate, LocStr, IncscIdStr) As Query(ROWSPEC = "TrId,Loc,LocDesc,AuditUserid,AuditUser,Date,InciCode,InciDesc,Spec,BUomDesc,TrQtyB:%Float,regUser,regDate,remark,Incsc,IncscDesc,IncscCode,Hospital") [ SqlProc ]
{
}

ClassMethod QueryMatTrfExecute(ByRef qHandle As %Binary, StartDate, EndDate, LocStr, IncscIdStr) As %Status
{
	 n (qHandle,StartDate, EndDate, LocStr, IncscIdStr)
	 s repid=$I(^CacheTemp)
	 s ind=1
	 s qHandle=$lb(0,repid,0)
	 q:LocStr="" $$$OK
	 q:StartDate="" $$$OK
	 q:EndDate="" $$$OK
	 s StartDate=$zdh(StartDate,3)
	 s EndDate=$zdh(EndDate,3)
	 f Date=StartDate:1:EndDate d
	 .s len=$l(LocStr,"^")
	 .f i=1:1:len  d
	 ..s Loc=$p(LocStr,"^",i)
	 ..s LocDesc=$p(^CTLOC(Loc),"^",2) 
	 ..s ItmDr=0
	 ..f  s ItmDr=$o(^INCI("IL_LOC",Loc,ItmDr)) q:ItmDr=""  d
	 ...q:$o(^DHCLOCTOT(0,"LOCITMDATE",Loc,ItmDr,Date+1),-1)=""
	 ...s Chl=$o(^INCI("IL_LOC",Loc,ItmDr,0))
	 ...s Incil=ItmDr_"||"_Chl
	 ...s StkGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(ItmDr)
	 ...s ScgDesc=$p(StkGrpInfo,"^",2)
	 ...s Scg=$p(StkGrpInfo,"^",5)
	 ...s ScgType=$p(StkGrpInfo,"^",3)
	 ...q:ScgType'=..sssCode()
	 ...s Incsc=$p(^INCI(ItmDr,2),"^",2)
	 ...q:(IncscIdStr'="")&&(("^"_IncscIdStr_"^")'[("^"_Incsc_"^"))
	 ...s IncscDesc=$p($g(^INC("SC",Incsc)),"^",2) 
	 ...s IncscCode=$p($g(^INC("SC",Incsc)),"^",1)
	 ...s InciCode = $p(^INCI(ItmDr,1),"^",1)
	 ...s InciDesc = $p(^INCI(ItmDr,1),"^",2)
	 ...s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",ItmDr)
	 ...s BillUomStr=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetArcBuomByInc(ItmDr)
	 ...s BillUomDr=$P(BillUomStr,"^",1)
	 ...s BillUomDesc=$P(BillUomStr,"^",2)
	 ...s BUomId=$p(^INCI(ItmDr,1),"^",10)
	 ...s BUomDesc=$s(BUomId'="":$p(^CT("UOM",BUomId),"^",2),1:"")
	 ...s PurUomId=$p(^INCI(ItmDr,3),"^",6)
	 ...s PurUomDesc=$s(PurUomId'="":$p(^CT("UOM",PurUomId),"^",2),1:"")
	 ...s Factor=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	 ...s HospId=$p(^CTLOC(Loc),"^",22)
	 ...s Hospital=$s(HospId'="":$p(^CT("HOSP",HospId),"^",2),1:"")
	 ...s TrId="" 
	 ...f  s TrId=$o(^DHCINTR(0,"INCI",ItmDr,Date,TrId)) q:TrId=""  d
	 ....q:'$d(^DHCINTR(TrId))
	 ....s Inclb=$p(^DHCINTR(TrId),"^",7)
	 ....q:Inclb=""
	 ....s TmpIncil=$p(Inclb,"||",1,2)
	 ....q:Incil'=TmpIncil           ;非统计科室库存
	 ....s Incib=$p(^INCI(ItmDr,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1) ;批次指针
	 ....s (BatNo,ExpDate)=""
	 ....i Incib'=""  d
	 .....s BatNo=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",1)
	 .....s ExpDate=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",2)
	 .....s:ExpDate'="" ExpDate=$zd(ExpDate,3)
	 ....s TrType=$p(^DHCINTR(TrId),"^",1)                                         ;交易类型
	 ....q:(TrType'="T")&&(TrType'="K")
	 ....s TrPointer=$p(^DHCINTR(TrId),"^",9)                                         ;交易指针
	 ....s InIstrfinfo=^DHCINIT(+TrPointer)
	 ....s inititminfo=^DHCINIT(+TrPointer,"ITI",$p(TrPointer,"||",2))
	 ....s reqitmid=$p(inititminfo,"^",2)  ;申请单ID
	 ....s (OperLoc,AuditUserid,AuditUser)=""
	 ....i TrType="T" d
	 .....s OperLoc=$p(InIstrfinfo,"^",5)
	 .....s AuditUserid=$p(InIstrfinfo,"^",11)
	 .....s AuditUser=$p(^SSU("SSUSR",AuditUserid),"^",2)
	 ....i TrType="K" d
	 .....s OperLoc=$p(InIstrfinfo,"^",6)
	 ....q:OperLoc'=Loc
	 ....s TrUom=$p(^DHCINTR(TrId),"^",10)                                        ;交易单位
	 ....s TrQty=$p(^DHCINTR(TrId),"^",6)                                         ;交易数量
	 ....s TrNo=$p(^DHCINTR(TrId),"^",13)                                        ;交易号
	 ....s TrUser=$p(^DHCINTR(TrId),"^",11)                                     ;交易人
	 ....s OperateUser=""
	 ....s:TrUser'="" OperateUser=$p(^SSU("SSUSR",TrUser),"^",2)
	 ....s TrTime=$p(^DHCINTR(TrId),"^",3)
	 ....s TrSp=$p(^DHCINTR(TrId),"^",14)        ;业务发生的售价
	 ....s TrRp=$p(^DHCINTR(TrId),"^",16)        ;业务发生的进价
	 ....s TrSpAmt=$p(^DHCINTR(TrId),"^",8)        ;售价金额
	 ....s TrRpAmt=$p(^DHCINTR(TrId),"^",17)        ;进价金额
	 ....s StkQty=$p(^DHCINTR(TrId),"^",18)        ;结余库存量
	 ....s StkLbQty=$p(^DHCINTR(TrId),"^",19)        ;结余库存量(批次)
	 ....s FacTr=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(TrUom,BUomId)
	 ....s TrQtyB=TrQty*FacTr              ;基本单位数量
	 ....s BUomSp=TrSp/FacTr               ;基本单位售价
	 ....s PurUomSp=BUomSp*Factor          ;包装单位售价
	 ....s BUomRp=TrRp/FacTr    //##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,BUomId) ;批次进价(基本单位)
	 ....s PurUomRp=BUomRp*Factor            ;批次进价(包装单位)
	 ....s PurUomRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(PurUomRp,HospId,1)
	 ....s Manf=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb)
	 ....i Manf'=""  s Manf=$p(Manf,"^",2)
	 ....s VendorInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(Inclb,Date)  ;该批次对应的最后一次入库的供应商
	 ....s Vendor=$p(VendorInfo,"^",2)
	 ....s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr(TrType,TrPointer)
	 ....s (regUserid,regUser,regDate)=""
	 ....i reqitmid'="" d
	 .....s reqinfo=^INRQ(+reqitmid)
	 .....s regUserid=$p(reqinfo,"^",4)
	 .....s regUser=$s(regUserid'="":$p(^SSU("SSUSR",regUserid),"^",2),1:"")
	 .....s regDate=$p(reqinfo,"^",2)
	 .....s:regDate'="" regDate=$zd(regDate,3)
	 ....d OutputRowQueryMatTrf
	 Quit $$$OK
OutputRowQueryMatTrf	
	 s Data=$lb(TrId,Loc,LocDesc,AuditUserid,AuditUser,Date,InciCode,InciDesc,Spec,BUomDesc,TrQtyB,regUser,regDate,remark,Incsc,IncscDesc,IncscCode,Hospital)   
	 s ^CacheTemp(repid,ind)=Data
	 s ind=ind+1
	 
	 Quit $$$OK
	 q
}

}
