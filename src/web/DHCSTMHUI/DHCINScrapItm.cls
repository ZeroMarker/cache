Import sqluser

Class web.DHCSTMHUI.DHCINScrapItm Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	保存/更新报损明细信息
/// Creater:	qsx
/// CreateDate:	2012-08-30
/// Table:DHC_INSpItm
/// Input:主表id,
/// 明细id^批次ID^单位RowId^报损数量^进价^进价金额^批价^批价金额^售价^售价金额
/// 明细id^批次ID^单位RowId^报损数量^进价^进价金额^批价^批价金额^售价^售价金额
/// Output:		
/// Return：0：成功，
/// w ##class(web.DHCSTMHUI.DHCINScrapItm).Save("96","[{""HVBarCode"":""YL20181017001"",""Inclb"":""2766||4||2"",""Qty"":1,""PurUomId"":""2"",""Rp"":""1000"",""Sp"":""1200"",""AvaQty"":""1""}]")
ClassMethod Save(InscrapId As %String, ListData As %String) As RtnObj
{
	n (InscrapId,ListData)
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$CLASSNAME()_".Save"
	i InscrapId="" q RtnObj.Err(-1,"",InscrapId,MethodName_":参数错误").Json()
	i ListData="" s RtnObj.rowid=InscrapId q RtnObj
	s LocId=$p(^DHCINSP(InscrapId),"^",5)
	s UserId=$p(^DHCINSP(InscrapId),"^",6)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(ListData)
	i Sc'=0 d RtnObj.Err(-1,"",MethodName_":参数解析错误")
	q:RtnObj.success'=0 RtnObj
	i ..sssLock(##class(web.DHCSTMHUI.DHCINScrap).%GetParameter("AppName")_InscrapId)<0 d RtnObj.Err(-99,"","加锁失败!")
	q:RtnObj.success'=0 RtnObj
	while(RtnObj.success=0){
		s Obj=##class(web.DHCSTMHUI.Common.FromJson).%New()
		s Obj=PJObj.%Pop()
		q:Obj=""
		s Inscrapi=Obj.%Get("RowId")
		s Inclb=Obj.%Get("Inclb")
		q:Inclb=""
		s BarCode=Obj.%Get("HVBarCode")
		s Inci=$p(Inclb,"||",1)
		s InciDesc=$p(^INCI(Inci,1),"^",2)
		i Inscrapi'="" d
		.s RtnObj=..HandleItmDirtyQty(Inscrapi,0)
		continue:RtnObj.success<0
		s RowStr=Obj.%ToJSON()
		s RtnObj=..Update(InscrapId,RowStr)
		continue:RtnObj.success<0
		s InscrapRowId=RtnObj.rowid
		s RtnObj=..HandleItmDirtyQty(InscrapRowId,1)
		continue:RtnObj.success<0
		;处理高值条码
		i (Inscrapi="")&&(BarCode'="") d
		.s OperData=LocId_"^"_UserId_"^"_Inci_"^^^"
		.s RtnObj=##class(web.DHCSTMHUI.DHCItmTrack).Update("D",InscrapRowId,BarCode,OperData)
		continue:RtnObj.success<0
	}
	q RtnObj
}

/// 插入或更新报损单明细记录数据
/// Author:zhwh
/// Date: 2012-07-20
/// Argu:
///  inscrapItm - 子表rowid
///  Inscrap  - 父表rowid
/// w ##class(web.DHCSTMHUI.DHCINScrapItm).Update(48,"{""Inclb"":""2841||2||1"",""InciCode"":""GZ00076"",""InciDesc"":""分流管(脑脊液分流管及附件)[823832]"",""Incil"":""2841||2"",""BatExp"":""2018051676~"",""Manf"":""美国强生"",""Qty"":""2"",""PurUomId"":""67"",""PurUomDesc"":""套"",""Sp"":""39000"",""Rp"":""39000"",""AvaQty"":""40"",""InclbQty"":""40""}")
ClassMethod Update(InscrapId As %String, Data As %String) As RtnObj
{
	n (InscrapId,Data)
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$CLASSNAME()_".Update"
	i InscrapId="" s Sc=RtnObj.Err(-1,"",InscrapId,MethodName_":参数错误")
	s AppName=##class(web.DHCSTMHUI.DHCINScrap).%GetParameter("AppName")
	i ..sssLock(AppName_InscrapId)<0 q RtnObj.Err(-2,"",MethodName_"加锁失败")
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Data)
	i Sc'=0 d RtnObj.Err(-1,"",MethodName_":参数解析错误") 
	q:RtnObj.success'=0 RtnObj
	s InscrapItmId=PJObj.%Get("RowId")
	s Inclb=PJObj.%Get("Inclb")
	s PurUomId=PJObj.%Get("UomId")
	s Qty=PJObj.%Get("Qty")
	i +Qty'>0 d RtnObj.Err(-4,"","存在报损数量小于或等于0！","",0)
	q:RtnObj.success'=0 RtnObj
	s AvaQty=PJObj.%Get("AvaQty")
	i AvaQty<Qty d RtnObj.Err(-5,"","报损数量大于批次可用数量！","",0)
	q:RtnObj.success'=0 RtnObj
	s Rp=PJObj.%Get("Rp")
	s Sp=PJObj.%Get("Sp")
	s RpAmt=Rp*Qty
	s SpAmt=Sp*Qty
	s Pp=Rp,PpAmt=RpAmt
	s Inci=+Inclb
	s BUom=$p(^INCI(Inci,1),"^",10)
	s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUom)
	i InscrapItmId="" d
	.s Obj=##class(User.DHCINSpItm).%New(InscrapId)
	.d Obj.INSPIParrefSetObjectId(InscrapId)
	.s Obj.INSPIChildsub=1+$o(^DHCINSP(InscrapId,"I",""),-1)
	e  d
	.s Obj=##class(User.DHCINSpItm).%OpenId(InscrapItmId)
	.d Obj.%Reload()
	d Obj.INSPICTUOMDRSetObjectId(PurUomId)
	d Obj.INSPIINCLBDRSetObjectId(Inclb)
	s Obj.INSPIQty=+Qty
	s Obj.INSPIRp=+Rp
	s Obj.INSPIRpAmt=+RpAmt
	s Obj.INSPIPp=+Pp
	s Obj.INSPIPpAmt=+PpAmt
	s Obj.INSPISp=+Sp
	s Obj.INSPISpAmt=+SpAmt
	s Obj.INSPIQtyBUom=(+Qty)*ConFac
	s Sc=Obj.%Save()
	d ..sssUnLock(AppName_InscrapId)
	i $$$ISERR(Sc) q RtnObj.Err(-3,"",MethodName_":保存失败!")
	s RtnObj.rowid=Obj.%Id()
	q RtnObj
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINScrapItm","DHCINSpD","5")
Query DHCINSpD(Inscrap As %String) As Query(ROWSPEC = "RowId,Inclb,Inci,InciCode,InciDesc,Spec,Manf,PurUomId,PurUomDesc,Qty,Rp:%Float,RpAmt:%Float,Sp:%Float,SpAmt:%Float,Pp:%Float,PpAmt:%Float,BatExp,ExpDate,InclbQty:%Float,HVFlag,HVBarCode,IncscDesc,IncscType,AvaQty:%Float,BUomId,ConFac:%Float,UomId,UomDesc,SpecDesc,OriginalStatus,dhcit") [ SqlProc ]
{
}

ClassMethod DHCINSpDExecute(ByRef qHandle As %Binary, Inscrap As %String) As %Status
{
	n (qHandle,Inscrap)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Inscrap="" $$$OK
	s sql="select %ID RowId,"
	s sql=sql_"inspi_inclb_dr Inclb,"
	s sql=sql_"inspi_ctuom_dr Uom,"	
	s sql=sql_"inspi_ctuom_dr->ctuom_desc UomDesc,"	
	s sql=sql_"inspi_qty Qty,"	
	s sql=sql_"inspi_rp Rp,"	
	s sql=sql_"inspi_rpamt RpAmt,"	
	s sql=sql_"inspi_sp Sp,"	
	s sql=sql_" inspi_spamt SpAmt,"	
	s sql=sql_"inspi_pp Pp,"	
	s sql=sql_"inspi_ppamt PpAmt "	
	s sql=sql_" from DHC_INSpItm"
	s sql=sql_" where inspi_parref="_Inscrap
	s sql=sql_" ORDER BY INSPI_Childsub asc"
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId=xrs.Data("RowId")
		s Inclb=xrs.Data("Inclb")
		s PurUomId=xrs.Data("Uom")
		s PurUomDesc=xrs.Data("UomDesc")
		s Qty=xrs.Data("Qty")
		s Rp=xrs.Data("Rp")
		s RpAmt=xrs.Data("RpAmt")
		s Sp=xrs.Data("Sp")
		s SpAmt=xrs.Data("SpAmt")
		s Pp=xrs.Data("Pp")
		s PpAmt=xrs.Data("PpAmt")

		s Inci=+Inclb
		s InciCode=$p(^INCI(Inci,1),"^",1)
		s InciDesc=$p(^INCI(Inci,1),"^",2)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",+Inclb)
		s Manf=$p(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb),"^",2)
		s Incibin=$p(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetStkBinByIncil(Inclb),"^",1)
		s IncscDr=$p($G(^INCI(Inci,2)),"^",2)
		s IncscDesc=$p($G(^INC("SC",IncscDr)),"^",2)
		s BatExp=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(Inclb)
		s BatNo=$p(BatExp,"^",1)
		s ExpDate=$p(BatExp,"^",2)
		s BatExp=BatNo_"~"_ExpDate
		s AvaQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbAvaQty(Inclb,PurUomId)
		s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
		s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr("D",RowId)
		s dhcit="",OriginalStatus=""
		i HVBarCode'="" d
		.s dhcit=$o(^DHCIT(0,"LABEL",HVBarCode,0))
		.s:dhcit'="" OriginalStatus=$p(^DHCIT(dhcit),"^",35)
		s IncscType=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci),"^",6)
		s InclbQty = ##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLBU(Inclb,+$h,PurUomId)
		s BUomId=$p(^INCI(Inci,1),"^",10)
		s PUomId=$p(^INCI(Inci,3),"^",6)
		s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PUomId,BUomId)
		s UomId=PurUomId
		s UomDesc=PurUomDesc
		s SpecDesc=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSpecDescByInclb(Inclb)
		d OutPutRow
	}

	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,Inclb,Inci,InciCode,InciDesc,
		Spec,Manf,PurUomId,PurUomDesc,Qty,
		Rp,RpAmt,Sp,SpAmt,Pp,
		PpAmt,BatExp,ExpDate,InclbQty,
		HVFlag,HVBarCode,IncscDesc,IncscType,AvaQty,
		BUomId,ConFac,UomId,UomDesc,SpecDesc,OriginalStatus,dhcit)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 删除报损单单明细记录
/// Argu:
///   inscrap - 报损单明细记录rowid
/// Return：
///   0 -Success
///   <0 - failure
/// w ##class(web.DHCSTMHUI.DHCINScrapItm).Delete("")
ClassMethod jsDelete(Params As %String) As %String
{
	n (Params)
	s $ZT=..sssError()
	s MethodName=$CLASSNAME()_".Delete"
	s RtnObj=##class(RtnObj).%New()
	s AppName=##class(web.DHCSTMHUI.DHCINScrap).%GetParameter("AppName")
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_":参数解析错误").Json()
	
	ts
	While(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s Inspi=Obj.%Get("RowId")
		continue:Inspi=""
		i ##class(web.DHCSTMHUI.DHCINScrapItm).AllowDel(Inspi)<0 d
		.d RtnObj.Err(-100,"","已完成或已审核不允许删除!","",0)
		q:RtnObj.success<0
		s Inscrap=+Inspi
		i ..sssLock(AppName_Inscrap)<0 d
		.d RtnObj.Err(-99,Inscrap,MethodName_":加锁失败")
		q:RtnObj.success<0
		s RtnObj=..Delete(Inspi)
		continue:RtnObj.success<0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// 是否允许删除
/// Author: zhwh
/// Date:2012-07-23
/// Argu: 
///  inscrpItm - 报损单子表rowid
/// Return:
///  0 - success
///  <0 - failure
ClassMethod Delete(Inspi As %String) As RtnObj
{
	n (Inspi)
	s MethodName=$CLASSNAME()_".Delete"
	s RtnObj=##class(RtnObj).%New()
	s AppName=##class(web.DHCSTMHUI.DHCINScrap).%GetParameter("AppName")

	i Inspi="" q RtnObj.Err(-1,"",MethodName_":参数错误")
	s Inscrap=+Inspi
	i ..sssLock(Inscrap)<0 d RtnObj.Err(-99,Inscrap,MethodName_":加锁失败")
	q:RtnObj.success<0 RtnObj
	i ..AllowDel(Inscrap)<0 d RtnObj.Err(-100,"","已完成或已审核不允许删除!","",0)
	
	ts
	s RtnObj=..HandleItmDirtyQty(Inspi,0)
	i RtnObj.success<0 d ..sssUnLock(AppName_Inscrap) q RtnObj
	s RtnObj=##class(web.DHCSTMHUI.DHCItmTrackDetail).DelByPointer("D",Inspi)
	i RtnObj.success<0 d ..sssUnLock(AppName_Inscrap) q RtnObj
	&sql(delete from DHC_INSpItm where %ID=:Inspi)
	i SQLCODE'=0 d
	.d ..sssUnLock(AppName_Inscrap)
	.d RtnObj.Err(-5,Inspi,MethodName_":删除失败","{Inspi:"_Inspi_"}")
	q:RtnObj.success<0 RtnObj
	tc
	q RtnObj
}

/// 是否允许删除
/// Author: zhwh
/// Date:2012-07-23
/// Argu: 
///  inscrpItm - 报损单子表rowid
/// Return:
///  0 - 允许
///  <0 - 不允许
ClassMethod AllowDel(Inspi As %String) As %String
{
	n (Inspi)
	s Inscrap=+Inspi
	s Obj=##class(User.DHCINScrap).%OpenId(Inscrap)
	d Obj.%Reload()	
	s Comp=Obj.INSCPCompleted
	q:Comp="Y" -1
	s ChkFlag=Obj.INSCPChkFlag
	q:ChkFlag="Y" -2
	q 0
}

/// Descript:	处理报损明细的占用数量
/// Author:		qiushengxin
/// CreateDate:	2020-03-19
/// Input:		报损子表rowid, Sign(0:减, 1:增)
/// Output:	w ##class(web.DHCSTMHUI.DHCINScrapItm).HandleItmDirtyQty("9||1",1)	
ClassMethod HandleItmDirtyQty(Inspi As %String, Sign As %String) As RtnObj
{
	n (Inspi,Sign)
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$CLASSNAME()_".HandleItmDirtyQty"
	s obj=##class(User.DHCINSpItm).%OpenId(Inspi)
	s Inclb=obj.INSPIINCLBDR.%Id()
	s Qty=obj.INSPIQty
	s UomId=obj.INSPICTUOMDR.%Id()
	s BUomId=$p(^INCI(+Inclb,1),"^",10)
	s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
	s Qty=Qty*UomFac		;基本单位对应的数量
	i Sign="0" s Qty=-Qty	;回退
	s Err=##class(web.DHCSTMHUI.Common.StockHandle).UpdateDirtyQty(Inclb,Qty)
	i (+Err'=0)&&(Sign=0) q RtnObj.Err(-1,"",MethodName_":清除占用失败")
	i (+Err'=0)&&(Sign=1) q RtnObj.Err(-2,"",MethodName_":增加占用失败")
	q RtnObj
}

}
