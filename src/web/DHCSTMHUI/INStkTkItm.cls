Import sqluser

Class web.DHCSTMHUI.INStkTkItm Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// 检索盘点帐盘表明细
/// Creator:	lxt
/// Date:2018-7-23
/// Argu:
/// Inst -盘点主表rowid
/// Others - (statFlag^inci^inciDesc^过滤冻结零库存(Y/N)^scg^incsc^管理组^货位)
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INStkTkItm","jsDHCSTInStkTkItm",167,"{"Inst":"167"}")
Query jsDHCSTInStkTkItm(Inst As %String, Others As %String) As Query(ROWSPEC = "Inst,RowId,Inclb,InciId,InciCode,InciDesc,Spec,ManfDesc,Barcode,FreezeQty:%Float,FreezeDate,FreezeTime,CountQty:%Float,CountDate,CountTime,CountUserId,CountUserName,Variance,Remark,Status,UomId,UomDesc,BatchNo,ExpDate,AdjFlag,StkBinDesc,AdjId,Sp:%Float,Rp:%Float,FreezeSpAmt:%Float,FreezeRpAmt:%Float,CountSpAmt:%Float,CountRpAmt:%Float,VarianceSpAmt:%Float,VarianceRpAmt:%Float,StkScgDesc,VendorDesc,StkCatDesc,SpecDesc,FreezeBarCodeStr,CountBarCodeStr,VarianceBarCodeStr,VarianceQty:%Float,StkQty:%Float,AvaQty:%Float") [ SqlProc ]
{
}

ClassMethod jsDHCSTInStkTkItmExecute(ByRef qHandle As %Binary, Inst As %String, Others As %String) As %Status
{
	n (qHandle,Inst,Others)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Inst="" $$$OK
	
	s LocId=$p(^DHCINST(Inst),"^",5)
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Others)
	s PStatFlag=PJobj.%Get("StatFlag")		;0:全部,1:仅盘盈,2:仅盘亏,3:仅无损益,4:仅有损益，5:帐盘不等于可用库存
	s PInciId=PJobj.%Get("InciId")
	s PInciDesc=PJobj.%Get("InciDesc")
	s PNoFreezeZero=PJobj.%Get("NoFreezeZero")		;过滤冻结零库存
	s PStkScgId=PJobj.%Get("StkScg")
	s PStkCatId=PJobj.%Get("StkCat")
	s PManGrpId=PJobj.%Get("ManGrpId")
	s PStkBinId=PJobj.%Get("StkBinId")
	
	s FCountNonzero=PJobj.%Get("FCountNonzero")
	s FFreezeNonzero=PJobj.%Get("FFreezeNonzero")
	
	s pHospId=..sssHospId(LocId)
	s ScgStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr("",..sssCode(),"",PStkScgId,pHospId)
	
	s sql="select %id RowId,"
		_"insti_inclb_dr Inclb,"
		_"insti_freezeqty FreezeQty,"
		_"insti_freezedate FreezeDate,"
		_"insti_freezetime FreezeTime,"
		_"insti_count1qty CountQty,"
		_"insti_count1date CountDate,"
		_"insti_count1time CountTime,"
		_"insti_count1person_dr CountUserId,"
		_"insti_count1person_dr->ssusr_name CountUserName,"
		_"insti_variance1 Variance,"
		_"insti_remarks Remark,"
		_"insti_status Status,"
		_"insti_ctuom_dr UomId,"
		_"insti_ctuom_dr->ctuom_desc UomDesc,"
		_"insti_batchNo BatchNo,"
		_"insti_expirydate ExpDate,"
		_"insti_stockcode InciCode,"
		_"insti_stockdesc InciDesc,"
		_"insti_stockbarcode Barcode,"
		_"insti_locdflag AdjFlag,"
		_"insti_stkbindesc StkBinId,"
		_"INSTI_Sp Sp,"
		_"INSTI_FreezeSpAmt FreezeSpAmt,"
		_"INSTI_Rp Rp,"
		_"INSTI_FreezeRpAmt FreezeRpAmt,"
		_"INSTI_Count1SpAmt CountSpAmt,"
		_"INSTI_Count1RpAmt CountRpAmt,"
		_"INSTI_Variance1SpAmt VarianceSpAmt,"
		_"INSTI_Variance1RpAmt VarianceRpAmt,"
		_"insti_inadi_dr AdjId"
		_" from dhc_instktkitm"
		_" where insti_inst_parref="_Inst

	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s (InciCode,InciDesc,StkCatDesc,StkBinDesc)=""
		
		s RowId=xrs.Data("RowId")
		s Inclb=xrs.Data("Inclb")
		s InciId=+Inclb
		s Incil=$p(Inclb,"||",1,2)
		continue:(PInciId'="")&(InciId'=PInciId)
		
		s:InciId'="" InciCode=$p(^INCI(InciId,1),"^",1)
		s:InciId'="" InciDesc=$p(^INCI(InciId,1),"^",2)
		continue:(PInciDesc'="")&(InciDesc'[PInciDesc)
		
		s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
		s StkType=$p(ScgInfo,"^",3)
		s StkScgDesc=$p(ScgInfo,"^",2)
		s StkScgId=$p(ScgInfo,"^",5)
		continue:StkType'=..sssCode()
		continue:(ScgStr'="")&&(("^"_ScgStr_"^")'[("^"_StkScgId_"^"))
		
		s StkCatId=$p(^INCI(InciId,2),"^",2)
		continue:(PStkCatId'="")&&(StkCatId'=PStkCatId)
		s:StkCatId'="" StkCatDesc=$p(^INC("SC",StkCatId),"^",2)
		
		s ManGrpId=##class(web.DHCSTMHUI.Common.DrugStkCommon).ManGrpByIncil(Incil)
		continue:(PManGrpId'="")&&(ManGrpId'=PManGrpId)
		
		;s StkBinId=$p(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetStkBinByIncil(Incil),"^",2)
		s StkBinId=xrs.Data("StkBinId")
		continue:(PStkBinId'="")&&(StkBinId'=PStkBinId)
		s:StkBinId'="" StkBinDesc=$p(^INC("SB",StkBinId),"^",2)
		
		s FreezeQty=xrs.Data("FreezeQty")
		continue:(PNoFreezeZero="Y")&&(+FreezeQty=0)
		
		s Variance=xrs.Data("Variance")
		continue:(PStatFlag=1)&(Variance<=0)
		continue:(PStatFlag=2)&(Variance>=0)
		continue:(PStatFlag=3)&(Variance'=0)
		continue:(PStatFlag=4)&(Variance=0)
		
		s Barcode=xrs.Data("Barcode")
		s Remark=xrs.Data("Remark")
		s Status=xrs.Data("Status")
		s BatchNo=xrs.Data("BatchNo")
		s ExpDate=xrs.Data("ExpDate")
		s AdjFlag=xrs.Data("AdjFlag")
		
		s FreezeDate=xrs.Data("FreezeDate")
		s FreezeTime=xrs.Data("FreezeTime")
		s CountQty=xrs.Data("CountQty")
		
		continue:(FFreezeNonzero="Y")&&(+FreezeQty=0)
		continue:(FCountNonzero="Y")&&(+CountQty=0)
		
		
		s CountDate=xrs.Data("CountDate")
		s CountTime=xrs.Data("CountTime")
		s CountUserId=xrs.Data("CountUserId")
		s CountUserName=xrs.Data("CountUserName")
		s UomId=xrs.Data("UomId")
		s UomDesc=xrs.Data("UomDesc")
		s Sp=xrs.Data("Sp")
		s Rp=xrs.Data("Rp")
		s FreezeSpAmt=xrs.Data("FreezeSpAmt")
		s FreezeRpAmt=xrs.Data("FreezeRpAmt")
		s CountSpAmt=xrs.Data("CountSpAmt")
		s CountRpAmt=xrs.Data("CountRpAmt")
		s VarianceSpAmt=xrs.Data("VarianceSpAmt")
		s VarianceRpAmt=xrs.Data("VarianceRpAmt")
		
		s BUomId=$p(^INCI(InciId,1),"^",10)
		s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
		s FreezeQty=FreezeQty/Fac		;按帐盘单位显示
		s:CountQty'="" CountQty=CountQty/Fac
		s:Variance'="" Variance=Variance/Fac
		s Sp=Sp*Fac			;按帐盘单位显示(帐盘价格为基本单位)
		s Rp=Rp*Fac
		
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
		s ManfDesc=$p(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb),"^",2)
		s VendorDesc=$p(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(Inclb),"^",2)
		s ExpDate=..DL2H(ExpDate)
		s:CountDate'="" CountDate=..DL2H(CountDate)
		s:CountTime'="" CountTime=..TL2H(CountTime)
		s:FreezeDate'="" FreezeDate=..DL2H(FreezeDate)
		s:FreezeTime'="" FreezeTime=..TL2H(FreezeTime)
		s AvaQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbAvaQty(Inclb,UomId)
		s diffQty=FreezeQty-CountQty
		continue:(PStatFlag=5)&&(diffQty<=AvaQty)
		s dhcit="",SpecDesc=""
		s:Barcode'="" dhcit=$o(^DHCIT(0,"LABEL",Barcode,0))
		s:dhcit'="" SpecDesc=$P(^DHCIT(dhcit),"^",19)
		s FreezeBarCodeStr=..GetBarCodeStr(RowId,"")
		s CountBarCodeStr=..GetBarCodeStr(RowId,"Y")
		s VarianceBarCodeStr=..GetBarCodeStr(RowId,"N")
		s StkQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(InciId,LocId,+$h)	//供应科室库存
		d OutPutRow
	}
	Quit $$$OK

OutPutRow
	s Data=$lb(Inst,RowId,Inclb,InciId,InciCode,InciDesc,Spec,ManfDesc,Barcode,FreezeQty,FreezeDate,FreezeTime,
	CountQty,CountDate,CountTime,CountUserId,CountUserName,Variance,Remark,Status,UomId,UomDesc,BatchNo,ExpDate,
	AdjFlag,StkBinDesc,AdjId,Sp,Rp,FreezeSpAmt,FreezeRpAmt,CountSpAmt,CountRpAmt,VarianceSpAmt,VarianceRpAmt,
	StkScgDesc,VendorDesc,StkCatDesc,SpecDesc,FreezeBarCodeStr,CountBarCodeStr,VarianceBarCodeStr,Variance,StkQty,AvaQty)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	插入或更新一条明细记录
/// Creator:	lxt
/// CreateDate:	2020-07-24
/// Table:		
/// Input:		明细id，主单id，科室批次 //,是否过滤零库存,是否使用高值盘点
/// Return：	
ClassMethod Update(Insti As %String, Inst As %String, Inclb As %String, UseItmTrack As %String = "", HvFlag As %String = "") As RtnObj
{
	//n (insti,inst,inclb,StkQtyNotZero,UseItmTrack)
	n (Insti,Inst,Inclb,UseItmTrack,HvFlag)
	s RtnObj=##class(RtnObj).%New()
	i Inst="" q RtnObj.Err(-501,"","账盘单不存在","",0)
	
	s InciId=+Inclb
	s Incil=$p(Inclb,"||",1,2)
	s Incib=$p(^INCI(InciId,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1)
	s BatNo=$p(^INCI(InciId,"IB",$p(Incib,"||",2)),"^",1)
	s ExpDate=$p(^INCI(InciId,"IB",$p(Incib,"||",2)),"^",2)
	s InciCode=$P($G(^INCI(InciId,1)),"^",1)
	s InciDesc=$P($G(^INCI(InciId,1)),"^",2)
	s BUomId=$P($G(^INCI(InciId,1)),"^",10)
	s PUomId=$p($G(^INCI(InciId,3)),"^",6)
	s Incsb=$p(^INCI(InciId,"IL",$p(Inclb,"||",2)),"^",2)	//货位
	s LocId=$$LOC^ST01(Inclb)
	s HospId=..sssHospId(LocId)
	s Barcode=$P($G(^INCI(InciId,3)),"^",9)
	//q:(StkQtyNotZero="Y")&&(qty=0) 0   ;盘点生成数据只要库存不等于0 的
	
	//按基本单位保存账盘数量和价格
	s QtyUom=$p(^INCI(InciId,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",2)
	s SpUom=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inclb,+$h,BUomId,HospId)
	s RpUom=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,BUomId,HospId)
	s FreezeSpAmt=QtyUom*SpUom
	s FreezeRpAmt=QtyUom*RpUom
	s FreezeSpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(FreezeSpAmt,HospId)
	s FreezeRpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(FreezeRpAmt,HospId)
	
	s pFreezeUom=$p(^DHCINST(Inst),"^",17)
	i pFreezeUom="1" s UomId=PUomId	//入库单位
	e  s UomId=BUomId
	
	i Insti="" d
	.s obj=##class(User.DHCInStkTkItm).%New(Inst)
	.d obj.INSTIINSTParrefSetObjectId(Inst)
	e  d
	.s obj=##class(User.DHCInStkTkItm).%OpenId(Insti)
	.d obj.%Reload()
	s obj.INSTIFreezeDate=+$h
	s obj.INSTIFreezeTime=$p($h,",",2)
	s obj.INSTIFreezeQty=QtyUom
	d obj.INSTICTUOMDRSetObjectId(UomId)
	d obj.INSTIINCLBDRSetObjectId(Inclb)
	d obj.INSTICTLOCDRSetObjectId(LocId)
	s obj.INSTIBatchNo=BatNo
	s obj.INSTIExpiryDate=ExpDate
	d obj.INSTIINCIDRSetObjectId(InciId)
	s obj.INSTIStockCode=InciCode
	s obj.INSTIStockDesc=InciDesc
	s obj.INSTIStockBarCode=Barcode
	s obj.INSTIStkBinDesc=Incsb
	s obj.INSTIFreezeRpAmt=FreezeRpAmt
	s obj.INSTIFreezeSpAmt=FreezeSpAmt
	s obj.INSTIRp=RpUom
	s obj.INSTISp=SpUom
	s sc=obj.%Save()
	i $$$ISERR(sc) q RtnObj.Err(-502,"","账盘明细保存失败!")
	s RowId=obj.%Id()

	i (Insti="")&&(UseItmTrack="Y")&&(HvFlag="Y") d
	.s RtnObj=##class(web.DHCSTMHUI.INStkTkItmTrack).Save(RowId)
	
	q RtnObj
}

/// 删除一条子表记录
/// Author:zhwh
/// Date:2012-08-01
/// Argu:
///  inst - 盘点子表记录rowid
/// Return：
///    0 - success
///    <0 -failure
ClassMethod Delete(insti As %String) As %String
{
 s inst=+insti
 q:##class(web.DHCSTMHUI.Common.AppCommon).Lock(##class(web.DHCSTMHUI.INStkTk).%GetParameter("AppName")_inst)<0 -99  //锁定 
 q:..AllowDel(insti)<0 -2
 s err=0
 &sql(delete from dhc_instktkitm where %id=:insti)
 i SQLCODE'=0 s err=-3
 d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(##class(web.DHCSTMHUI.INStkTk).%GetParameter("AppName")_inst)  //解锁
 q err
}

/// 判断记录是否允许删除
/// Author:zhwh
/// Date:2012-08-01
/// Argu:
///  insti - 子表记录rowid
/// Return：
///   记录数据串
ClassMethod AllowDel(insti As %String) As %String
{
 n (insti)
 s inst=+insti
 q ##class(web.DHCSTMHUI.INStkTk).AllowDel(inst)
}

/// 检查并设置某科室的所有库存批次的“活动”状态属性
/// （从当前活动状态=Y的批次中查找）
/// 该科室的库存批次的活动状态由Y->N的条件:
///   1.该批次库存为0且最近的盘点周期内没有发生任何业务。
/// 以下情况不可状态设置为"N"
///   1.该批次库存>0
///   2.本盘点周期内发生过业务
/// 
/// Author:zhwh
/// Date:2012-08-02
/// Argu:
///  Loc -科室rowid
/// Return：
///   0- sucess
///   <0 - failure
ClassMethod SetLcBtNonActive(Loc As %String) As %String
{
  n (Loc)
  s inci=0
  f  s inci=$o(^INCI("IL_LOC",Loc,inci)) q:inci=""  d
  .
  .s ch=$O(^INCI("IL_LOC",Loc,inci,""))
  .w ch,!
  .s lbCh=0
  .f  s lbch=$O(^INCI(inci,"IL",ch,"LB",lbCh)) q:lbCh=""  d
  ..s inclb=inci_"||"_ch_"||"_lbCh
  ..
  ..
  .
  .
  q 0
}

/// Descript:	检索insti对应高值条码明细
/// Creator:	lxt
/// CreateDate: 2016-1-28
/// Input:		insti
/// Return:		str串
ClassMethod GetBarCodeStr(insti As %String, Others As %String) As %String
{
	n (insti,Others)
	s Ret=""
	q:insti="" ""
	s AckFlag=$p(Others,"^",1)		;("Y":仅已盘点, "N":"仅未盘点", 其他:所有)
	s inst=+insti,ch=$p(insti,"||",2)
	s sub=0
	f  s sub=$o(^DHCINST(inst,"STI",ch,"STIT",sub)) q:sub=""  d
	.s institInfo=^(sub)
	.s instit=insti_"||"_sub
	.s dhcit=$p(institInfo,"^",1)
	.s HVBarCode=$p(^DHCIT(dhcit),"^",2)
	.s institFlag=$p(institInfo,"^",2)
	.q:(AckFlag="Y")&&(institFlag'="Y")
	.q:(AckFlag="N")&&(institFlag="Y")
	.s institDate=$p(institInfo,"^",3)
	.s:institDate'="" institDate=..DL2H(institDate)
	.s institTime=$p(institInfo,"^",4)
	.s:institTime'="" institTime=..TL2H(institTime)
	.s institUser=$p(institInfo,"^",5)
	.s:institUser'="" institUser=$p(^SSU("SSUSR",institUser),"^",2)
	.i Ret="" d
	..s Ret=HVBarCode
	.e  d
	..s Ret=Ret_"<br>"_HVBarCode
	q Ret
}

/// Descript:	盘点损益汇总
/// Creator:	aaa
/// CreateDate:	2018-09-19
/// Table:		dhc_instktkitm
/// Input:		排序，查询条件
/// Return：	盘点损益汇总
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INStkTkItm","DHCSTInStkTkItm","{""StatFlag"":""0"",""Inst"":""41"",""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2""}")
Query DHCSTInStkTkItm(Params As %Text) As Query(ROWSPEC = "rowid,inclb,inci,code,desc,spec,manf,barcode,freQty:%Float,freDate,freTime,countQty:%Float,countDate,countTime,countPerson,countPersonName,variance:%Float,remark,status,uom,uomDesc,batchNo,expDate,adjFlag,sbDesc,inadi,sp:%Float,rp:%Float,freezeSpAmt:%Float,freezeRpAmt:%Float,countSpAmt:%Float,countRpAmt:%Float,varianceSpAmt:%Float,varianceRpAmt:%Float,trueQty:%Float,scgDesc,vendor,incscdesc,specdesc,freeBarCode,countBarCode,varianceBarCode,VarianceQty:%Float,StkQty:%Float") [ SqlProc ]
{
}

ClassMethod DHCSTInStkTkItmExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (qHandle,Params)
	;s ^zx(8)=Params
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s Inst=PJObj.%Get("Inst")
	q:Inst="" $$$OK
	s Locid=$p(^DHCINST(Inst),"^",5)
	s PStatFlag=PJObj.%Get("StatFlag")   ;0:全部,1:仅盘盈,2:仅盘亏,3:仅无损益,4:仅有损益
	s PIncId=PJObj.%Get("IncId")
	s PIncDesc=PJObj.%Get("IncDesc")
	s PNoFreezeZero=PJObj.%Get("NoFreezeZero")  ;过滤冻结零库存
	s PScgId=PJObj.%Get("ScgId")
	s PIncscId=PJObj.%Get("IncscId")
	s PManGrpId=PJObj.%Get("ManGrpId")
	s PStkBinId=PJObj.%Get("StkBinId")
	s pHospId=..sssHospId(Locid)
	s ScgStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr("",..sssCode(),"",PScgId,pHospId)
	
	s sql="select %id rowid,"
	s sql=sql_"insti_inclb_dr inclb,"
	s sql=sql_"insti_freezeqty freQty,"
	s sql=sql_"insti_freezedate freDate,"
	s sql=sql_"insti_freezetime freTime,"
	s sql=sql_"insti_count1qty countQty,"
	s sql=sql_"insti_count1date countDate,"
	s sql=sql_"insti_count1time countTime,"
	s sql=sql_"insti_count1person_dr countPerson,"
	s sql=sql_"insti_count1person_dr->ssusr_name countPersonName,"
	s sql=sql_"insti_variance1 variance,"
	s sql=sql_"insti_remarks remark,"
	s sql=sql_"insti_status status,"
	s sql=sql_"insti_ctuom_dr uom,"
	s sql=sql_"insti_ctuom_dr->ctuom_desc uomDesc,"
	s sql=sql_"insti_batchNo batchNo,"
	s sql=sql_"insti_expirydate expDate,"
	s sql=sql_"insti_stockcode code,"
	s sql=sql_"insti_stockdesc descx,"
	s sql=sql_"insti_stockbarcode barcode,"
	s sql=sql_"insti_locdflag adjFlag,"
	s sql=sql_"insti_stkbindesc sbDesc,"
	s sql=sql_"INSTI_Sp Sp,"
	s sql=sql_"INSTI_FreezeSpAmt FreezeSpAmt,"
	s sql=sql_"INSTI_Rp Rp,"
	s sql=sql_"INSTI_FreezeRpAmt FreezeRpAmt,"
	s sql=sql_"INSTI_Count1SpAmt Count1SpAmt,"
	s sql=sql_"INSTI_Count1RpAmt Count1RpAmt,"
	s sql=sql_"INSTI_Variance1SpAmt Variance1SpAmt,"
	s sql=sql_"INSTI_Variance1RpAmt Variance1RpAmt,"
	s sql=sql_"insti_inadi_dr inadi"
	s sql=sql_" from dhc_instktkitm"
	s sql=sql_" where insti_inst_parref="_Inst
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s rowid=xrs.Data("rowid")
		s inclb=xrs.Data("inclb")
		s inci=+inclb
		s Incil=$p(inclb,"||",1,2)
		continue:(PIncId'="")&(inci'=PIncId)
		s InciDesc=$p(^INCI(inci,1),"^",2)
		continue:(PIncDesc'="")&(InciDesc'[PIncDesc)
		s scgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
		s stkType=$p(scgInfo,"^",3)
		s scgDesc=$p(scgInfo,"^",2)
		s TmpScgId=$p(scgInfo,"^",5)
		s TmpIncCatId=$p(^INCI(inci,2),"^",2)
		continue:(stkType'="")&&(stkType'=..sssCode())
		continue:(ScgStr'="")&&(("^"_ScgStr_"^")'[("^"_TmpScgId_"^"))
		continue:(PIncscId'="")&&(TmpIncCatId'=PIncscId)
		s incscdesc=""
		s:TmpIncCatId'="" incscdesc=$p(^INC("SC",TmpIncCatId),"^",2)
		
		i PManGrpId'="" d
		.s TmpManGrpId=##class(web.DHCSTMHUI.Common.DrugStkCommon).ManGrpByIncil(Incil)
		continue:(PManGrpId'="")&&(TmpManGrpId'=PManGrpId)
		i PStkBinId'="" d
		.s Incsb=$p(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetStkBinByIncil(Incil),"^",2)
		continue:(PStkBinId'="")&&(Incsb'=PStkBinId)
		
		s code=xrs.Data("code")
		s desc=xrs.Data("descx")
		s barcode=xrs.Data("barcode")
		s freQty=xrs.Data("freQty")
		continue:(PNoFreezeZero="Y")&&(+freQty=0)
		s freDate=xrs.Data("freDate")
		s freTime=xrs.Data("freTime")
		s countQty=xrs.Data("countQty")
		s countDate=xrs.Data("countDate")
		s countTime=xrs.Data("countTime")
		s countPerson=xrs.Data("countPerson")
		s countPersonName=xrs.Data("countPersonName")
		s variance=xrs.Data("variance")
		continue:(PStatFlag=1)&(variance<=0)
		continue:(PStatFlag=2)&(variance>=0)
		continue:(PStatFlag=3)&(variance'=0)
		continue:(PStatFlag=4)&(variance=0)
		s remark=xrs.Data("remark")
		s status=xrs.Data("status")
		;s uom=$p(^INCI(inci,1),"^",10) ;xrs.Data("uom")
		;s uomDesc=$p(^CT("UOM",uom),"^",2) ;xrs.Data("uomDesc")
		s uom=xrs.Data("uom")
		s uomDesc=xrs.Data("uomDesc")
		s bUom=$p(^INCI(inci,1),"^",10)
		s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,bUom)
		s freQty=freQty/Fac		;按帐盘单位显示
		s countQty=countQty/Fac
		s variance=variance/Fac
		
		s batchNo=xrs.Data("batchNo")
		s expDate=xrs.Data("expDate")
		s adjFlag=xrs.Data("adjFlag")
		s sbDesc=xrs.Data("sbDesc")
		s sp=xrs.Data("Sp")*Fac	;按帐盘单位显示(帐盘价格为基本单位)
		s freezeSpAmt=xrs.Data("FreezeSpAmt")
		s rp=xrs.Data("Rp")*Fac
		s freezeRpAmt=xrs.Data("FreezeRpAmt")
		s countSpAmt=xrs.Data("Count1SpAmt")
		s countRpAmt=xrs.Data("Count1RpAmt")
		s varianceSpAmt=xrs.Data("Variance1SpAmt")
		s varianceRpAmt=xrs.Data("Variance1RpAmt")
		s inadi=xrs.Data("inadi")
		s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci)
		s manf=$p(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(inclb),"^",2)
		s vendor=$p(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(inclb),"^",2)
		s expDate=..DL2H(expDate)
		s:countDate'="" countDate=..DL2H(countDate)
		s:countTime'="" countTime=..TL2H(countTime)
		s:freDate'="" freDate=..DL2H(freDate)
		s:freTime'="" freTime=..TL2H(freTime)
		s trueQty=""
		s dhcit="",specdesc=""
		s:barcode'="" dhcit=$o(^DHCIT(0,"LABEL",barcode,0))
		s:dhcit'="" specdesc=$P(^DHCIT(dhcit),"^",19)
		s freeBarCode=..GetBarCodeStr(rowid,"")
		s countBarCode=..GetBarCodeStr(rowid,"Y")
		s varianceBarCode=..GetBarCodeStr(rowid,"N")
		s VarianceQty=countQty-freQty
		s:countQty="" VarianceQty=""
		s locid=$p(^DHCINST(Inst),"^",5)
		s StkQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(inci,locid,+$h)	//供应科室库存
    	s StkQty=StkQty/Fac
	 	d OutPutRow1
	}
	Quit $$$OK

OutPutRow1
	s Data=$lb(rowid,inclb,inci,code,desc,spec,manf,barcode,freQty,freDate,freTime,countQty,countDate,countTime,countPerson,countPersonName,variance,remark,status,uom,uomDesc,batchNo,expDate,adjFlag,sbDesc,inadi,sp,rp,freezeSpAmt,freezeRpAmt,countSpAmt,countRpAmt,varianceSpAmt,varianceRpAmt,trueQty,scgDesc,vendor,incscdesc,specdesc,freeBarCode,countBarCode,varianceBarCode,VarianceQty,StkQty)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod DeleteItm(insti As %String) As %String
{
	n (insti)
	s inst=+insti
	q:##class(web.DHCSTMHUI.Common.AppCommon).Lock(##class(web.DHCSTMHUI.INStkTk).%GetParameter("AppName")_inst)<0 -99  //锁定 
	s adjcomplete=$P(^DHCINST(inst),"^",14)
	q:adjcomplete="Y" -2
	s err=0
	&sql(delete from dhc_instktkitm where %id=:insti)
	i SQLCODE'=0 s err=-3
	d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(##class(web.DHCSTMHUI.INStkTk).%GetParameter("AppName")_inst)  //解锁
	q err
}

}
