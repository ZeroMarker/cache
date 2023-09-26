Import sqluser

Class web.DHCSTMHUI.DHCINAdjItm Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// 插入或者更新库存调整单明细
ClassMethod Update(adj As %String, RowStr As %String) As RtnObj
{
	n (adj,RowStr)
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$CLASSNAME()_".Update"
	s AppName=##class(web.DHCSTMHUI.DHCINAdj).%GetParameter("AppName")
	i adj="" q RtnObj.Err(-1,"",MethodName_":主单ID不能为空","",0)
	s locId=$p(^DHCINAD(adj),"^",16)
	s userId=$p(^DHCINAD(adj),"^",3)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(RowStr)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_":参数解析失败")
	s adjitm=PJObj.%Get("RowId")
	s inclb=PJObj.%Get("Inclb")
	s Qty=PJObj.%Get("Qty")
	s uom=PJObj.%Get("UomId")
	s rp=PJObj.%Get("Rp")
	s sp=PJObj.%Get("Sp")
	s Remark=PJObj.%Get("Remark")
	s BarCode=PJObj.%Get("HvBarCode")
	s ThirdCode=PJObj.%Get("ThirdCode")
	s ThirdId=PJObj.%Get("ThirdId")
	
	s SpAmt=sp*Qty
	s RpAmt=rp*Qty
	s spAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(SpAmt,2)
	s rpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(RpAmt,2)
	s loc=$p($G(^INCI(+inclb,"IL",$p(inclb,"||",2))),"^",1)
	s buom=$P(^INCI(+inclb,1),"^",10)
	s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,buom)
	s qtybuom=Qty*fac
	i adjitm="" d
	.s Obj=##class(User.DHCINAdjItm).%New(adj)
	.d Obj.INADIINADParRefSetObjectId(adj)
	.s Obj.INADIChildSub=1+$o(^DHCINAD(adj,"ADI",""),-1)
	e  d
	.s Obj=##class(User.DHCINAdjItm).%OpenId(adjitm)
	.d Obj.%Reload()
	d Obj.INADIINCLBDRSetObjectId(inclb)
	s Obj.INADIQty=+Qty
	d Obj.INADICTUOMDRSetObjectId(uom)
	s Obj.INADIUCost=+sp
	s Obj.INADIRP=+rp
	s Obj.INADIRPAmt=+RpAmt
	s Obj.INADISPAmt=+SpAmt
	s Obj.INADIQtyBUom=+qtybuom
	d Obj.INADICTLOCDRSetObjectId(loc)
	s Obj.INADIRemark=Remark
	s Sc=Obj.%Save()
	d ..sssUnLock(AppName_adj)
	i $$$ISERR(Sc) q RtnObj.Err(-2,"",MethodName_":保存失败!")
	;处理高值条码
	s IniadjRowId=Obj.%Id()
	i (adjitm="")&&(BarCode'="") d
	.s operData=locId_"^"_userId_"^^^^"_inclb
	.s RtnObj=##class(web.DHCSTMHUI.DHCItmTrack).Update("A",IniadjRowId,BarCode,operData,"")
	q:RtnObj.success'=0 RtnObj
	
	;保存第三方明细id(仅新增时)
	i (adjitm="") d
	.s ThirdObj={},ThirdObj.ThirdCode=ThirdCode,ThirdObj.Type="A",ThirdObj.Pointer=IniadjRowId,ThirdObj.ThirdId=ThirdId
	.s ThirdStr=ThirdObj.%ToJSON()
	.s RtnObj=##class(web.DHCSTMHUI.DHCServiceBill).Save(ThirdStr)
	q:RtnObj.success<0 RtnObj
	
	s RtnObj.rowid=Obj.%Id()
	q RtnObj
}

/// 删除一条库存调整单明细记录
/// Author:zhwh
/// Date:2012-07-10
/// Argu:
/// 	adjitm -  库存调整单明细rowid
/// Return:
///    0 - success
///    <0 - failure
/// 
ClassMethod Delete(adjitm As %String) As RtnObj
{
	n (adjitm)
    s MethodName=$CLASSNAME()_".Delete"
	s RtnObj=##class(RtnObj).%New()
	s AppName=##class(web.DHCSTMHUI.DHCINAdj).%GetParameter("AppName")
	i adjitm="" q RtnObj.Err(-1,"",MethodName_":参数错误")
	s adj=+adjitm
	i ##class(web.DHCSTMHUI.DHCINAdj).AllowDel(adj)<0 q RtnObj.Err(-2,"",MethodName_":单据已完成不允许删除!","",0)
	i ..sssLock(AppName_adj)<0 q RtnObj.Err(-99,adj,MethodName_":加锁失败","",0)
	ts
	;先删除高值跟踪记录
	s RtnObj=##class(web.DHCSTMHUI.DHCItmTrackDetail).DelByPointer("A",adjitm)
	i RtnObj.success<0 tro  d ..sssUnLock(AppName_adj) q RtnObj
	&sql(delete from DHC_INAdjItm where %ID=:adjitm)
	i SQLCODE'=0 d
	.tro
	.d ..sssUnLock(AppName_adj)
	.d RtnObj.Err(-5,Initi,MethodName_":删除失败","{adjitm:"_adjitm_"}")
	q:RtnObj.success<0 RtnObj	
	tc
	d ..sssUnLock(AppName_adj)
	q RtnObj
}

/// 删除调整单单明细记录
/// w ##class(web.DHCSTMHUI.DHCINAdjItm).jsDelete(^tmp(8))
ClassMethod jsDelete(Params As %String) As %String
{
	n (Params)
	s $ZT=..sssError()
	s MethodName=$CLASSNAME()_".Delete"
	s RtnObj=##class(RtnObj).%New()
	s AppName=##class(web.DHCSTMHUI.DHCINAdj).%GetParameter("AppName")
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_":参数解析错误")
	ts
	While(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s adjitm=Obj.%Get("RowId")
		continue:adjitm=""
		s RtnObj=..Delete(adjitm)
		continue:RtnObj.success<0
	}
	i RtnObj.success<0 d
	.tro
	e  d
	.tc
	q RtnObj.Json()
}

/// 检索库存调整单明细的Query
/// Author:zhwh
/// Date:2012-07-10
///  d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINAdjItm","DHCINAdjD",^tmplh(1)) 
Query DHCINAdjD(Params As %String, RQStr As %String = "") As Query(ROWSPEC = "RowId,Inclb,InciId,Code,InciDesc,Spec,ManfDesc,BatExp,expDate,Qty:%Float,UomId,uomDesc,qtyBUOM:%Float,Rp:%Float,RpAmt:%Float,Sp:%Float,SpAmt:%Float,insti,InclbQty:%Float,HVFlag,HvBarCode,AvaQty:%Float,BUomId,ConFac:%Float,OriginalStatus,batNo,dhcit") [ SqlProc ]
{
}

ClassMethod DHCINAdjDExecute(ByRef qHandle As %Binary, Params As %String, RQStr As %String = "") As %Status
{
	n (qHandle,Params,RQStr)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s InAdj=PJObj.%Get("InAdj")
	i InAdj="" d
	.s RQInAdj=$p(RQStr,"^",1)
	.s InAdj=RQInAdj
	q:InAdj="" $$$OK

	s sql="select %ID adjitm,"
	_"inadi_inclb_dr inclb,"
	_"inadi_inclb_dr->inclb_incib_dr->incib_no batNo,"
	_"inadi_inclb_dr->inclb_incib_dr->incib_expdate expDate,"  
	_"inadi_qty qty,"
	_"inadi_ctuom_dr uom ,"
	_"inadi_ucost sp ,"
	_"inadi_rp rp,"
	_"inadi_rpamt rpAmt,"
	_"inadi_spamt spAmt,"
	_"inadi_qtybuom qtyBUOM,"
	_"inadi_insti_dr insti"
	_" from dhc_inadjitm where inadi_inad_parref="_InAdj
	_" ORDER BY INADI_ChildSub asc"
	s xRS=##class(%Library.ResultSet).%New()
	d xRS.Prepare(sql)
	s xRS.RuntimeMode=0
	s sc=xRS.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xRS.Next())
	{
		s RowId=xRS.Data("adjitm")
		s Inclb=xRS.Data("inclb")
		s Qty=xRS.Data("qty")
		s UomId=xRS.Data("uom")
		s uomDesc=$p($G(^CT("UOM",UomId)),"^",2)
		s Rp=xRS.Data("rp")
		s Sp=xRS.Data("sp")
		s RpAmt=xRS.Data("rpAmt")
		s SpAmt=xRS.Data("spAmt")
		s qtyBUOM=xRS.Data("qtyBUOM")
		s insti= xRS.Data("insti")
		s batNo= xRS.Data("batNo")
		s expDate= xRS.Data("expDate")
		s expDate=..DL2H(expDate)
		s InclbQty = ##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLBU(Inclb,+$h,UomId)
		s DirtyQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbResQty(Inclb,UomId)
		s AvaQty = InclbQty - DirtyQty
		s BatExp=batNo_"~"_expDate
		s InciId=+Inclb
		s Code=$p($G(^INCI(+Inclb,1)),"^",1)
		s InciDesc=$p($G(^INCI(+Inclb,1)),"^",2)
		s BUomId=$p(^INCI(InciId,1),"^",10)
		s PurUomId=$p(^INCI(InciId,3),"^",6)
		s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",+Inclb)
		s ManfDesc=$p(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb),"^",2)
		s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(InciId)
		s HvBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr("A",RowId)
		s dhcit="",OriginalStatus=""
		i HvBarCode'="" d
		.s dhcit=$o(^DHCIT(0,"LABEL",HvBarCode,0))
		.s:dhcit'="" OriginalStatus=$p(^DHCIT(dhcit),"^",35)
		d OutPutRow
	}
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,Inclb,InciId,Code,InciDesc,
		Spec,ManfDesc,BatExp,expDate,Qty,
		UomId,uomDesc,qtyBUOM,Rp,RpAmt,
		Sp,SpAmt,insti,InclbQty,HVFlag,
		HvBarCode,AvaQty,BUomId,ConFac,OriginalStatus,
		batNo,dhcit)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 保存库存调整单明细数据
/// Author:zhwh
/// Date:2012-07-12
/// Argu:
/// 	  adj-库存调整单主表rowid
/// 	  rows - 明细记录数据串
/// Return:
///    0 - success
///    <0 - failure
ClassMethod Save(adj As %String, ListData) As RtnObj
{
	n (adj,ListData)
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$CLASSNAME()_".Save"
	i adj="" q RtnObj.Err(-5,adj,MethodName_":入参不能为空","",0)
	i ListData="" q RtnObj.Err(-5,adj,MethodName_":入参不能为空","",0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(ListData)
	i Sc'=0 q RtnObj.Err(-1,adj,MethodName_":参数解析错误")
	while(RtnObj.success=0){
		s Obj=##class(web.DHCSTMHUI.Common.FromJson).%New()
		s Obj=PJObj.%Pop()
		q:Obj=""
		s Iniadj=Obj.%Get("RowId")
		s Inclb=Obj.%Get("Inclb")
		q:Inclb=""
		s RowStr=Obj.%ToJSON()
		s RtnObj=..Update(adj,RowStr)
		continue:RtnObj.success<0
		s IniadjRowId=RtnObj.rowid
	}
	q RtnObj
}

}
