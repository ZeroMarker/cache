Import sqluser

Class web.DHCSTMHUI.DHCINGrtItm Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:   保存/更新退货单明细信息
/// Creator:    XuChao
/// CreateDate: 2018-5-30
/// Table:DHC_InGdRet,DHC_INGRTITM
/// Input:退货主表id;
/// Return：RtnObj
ClassMethod Update(RetId As %String, Rows As %String, OperData As %String, HospId As %String) As RtnObj
{
	n (RetId,Rows,OperData,HospId)
	s RtnObj=##class(RtnObj).%New()
	q:RetId="" RtnObj.Err(-21,"","主单id不能为空！")
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Rows)
	q:Sc'=0 RtnObj.Err(-22,"","入参解析失败!")

	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Ingri=Obj.%Get("Ingri")
		
		s OldIngrti=RowId	;记录保存之前,该条数据是新记录或是旧记录
		s Uom=Obj.%Get("Uom")
		i Uom="" d RtnObj.Err(-24,"","单位不能为空!","",0)
		q:RtnObj.success'=0
		
		s Qty=Obj.%Get("Qty")
		i Qty<=0 d RtnObj.Err(-25,"","数量不能小于等于0!","",0)
		q:RtnObj.success'=0
		
		s Rp=Obj.%Get("Rp")
		s Sp=Obj.%Get("Sp")
		s InvCode=Obj.%Get("InvCode")
		s InvNo=Obj.%Get("InvNo")
		s InvDate=Obj.%Get("InvDate")
		s InvDate=..DH2L(InvDate)
		s InvAmt=Obj.%Get("InvAmt")
		s SxNo=Obj.%Get("SxNo")
		s ReasonId=Obj.%Get("ReasonId")
		s HvBarCode=Obj.%Get("HvBarCode")
		s Remark=Obj.%Get("Remark")
		s SpecDesc=Obj.%Get("SpecDesc")
		s Inclb=Obj.%Get("Inclb")
		s ThirdCode=Obj.%Get("ThirdCode")
		s ThirdId=Obj.%Get("ThirdId")
		
		s RpAmt=Rp*Qty
		s SpAmt=Sp*Qty
		
		i Inclb="",Ingri'="" s Inclb=$p(^DHCINGR(+Ingri,"GRI",$p(Ingri,"||",2)),"^",1)
		i Inclb="" d RtnObj.Err(-23,"","批次有误") q
		
		i Ingri'="" d
		.s OldSp=$p(^DHCINGR(+Ingri,"GRI",$p(Ingri,"||",2)),"^",32)
		.s SpUom=$p(^DHCINGR(+Ingri,"GRI",$p(Ingri,"||",2)),"^",10)
		e  d
		.s SpUom=$p(^INCI(+Inclb,1),"^",10)
		.s OldSp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbSp(Inclb,+$h,SpUom,HospId)
		
		s InciId=$p(Inclb,"||",1)
		s InciCode=$p(^INCI(InciId,1),"^",1)
		
		s AvaQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbAvaQty(Inclb,Uom)
		i (AvaQty-Qty)<0 d RtnObj.Err(-26,"",ThirdId_" "_InciCode_"数量不能大于可用数量!","",0)
		q:RtnObj.success'=0
		
		;减去原占用库存
		i OldIngrti'=""  d
		.s RtnObj=..HandleRetItmDirtyQty(OldIngrti,0)
		q:RtnObj.success'=0
		
		s BUom=$p(^INCI(+Inclb,1),"^",10)
		s Fac1=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(Uom,BUom)
		s Fac2=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(SpUom,BUom)
		s OldSp=OldSp/Fac2*Fac1   ;转换成退货单位对应的售价
		s OldSpAmt=OldSp*Qty
		s RetAspAmt=(Sp-OldSp)*Qty
		i Uom=BUom d
		.s Sp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(Sp,HospId,2)
		.s OldSp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(OldSp,HospId,2)
		.s Rp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(Rp,HospId,2)
		e  d
		.s Sp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(Sp,HospId,1)
		.s Rp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(Rp,HospId,1)
		.s OldSp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(OldSp,HospId,1)
		s SpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(SpAmt,HospId)
		s OldSpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(OldSpAmt,HospId)
		s RpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
		s Pp=Rp
		s PpAmt=RpAmt
		s:+InvAmt=0 InvAmt=RpAmt

		if RowId=""  d
		.s obj=##class(User.DHCINGRTITM).%New()
		.d obj.INGRTIINGRTParrefSetObjectId(RetId)
		.s ch=$o(^INGRT(RetId,"DHCGRR",""),-1)+1
		.s obj.INGRTIChildSub=ch
		.s InvSetDate=""
		.s:InvNo'="" InvSetDate=+$h
		.s obj.INGRTIInvSetDate=InvSetDate
		e  d
		.s obj=##class(User.DHCINGRTITM).%OpenId(RowId)
		.d obj.%Reload()
		.s oldInvNo=obj.INGRTIInvNo 
		.s oldInvSetDate=obj.INGRTIInvSetDate
		.s InvSetDate=""
		.i (oldInvSetDate="")&&(oldInvNo="")&&(InvNo'="") d
		..s InvSetDate=+$h
		..s obj.INGRTIInvSetDate=InvSetDate
		
		s IngriObj=##class(User.DHCINGdRecItm).%OpenId(Ingri)
		s obj.INGRTIAspAmt=0
		s obj.INGRTIInvAmt=+InvAmt
		s InvDate=..DH2L(InvDate)
		s obj.INGRTIInvDate=InvDate
		s obj.INGRTIInvNo=InvNo
		s obj.INGRTIInvCode=InvCode
		s obj.INGRTIOldSp=+OldSp
		s obj.INGRTIOldSpAmt=+OldSpAmt
		s obj.INGRTIRealPrice=+Rp
		s obj.INGRTIRetAmount=+RpAmt
		s obj.INGRTIPpAmt=+PpAmt
		s obj.INGRTIRetQty=+Qty
		d obj.INGRTIRetUomDRSetObjectId(Uom)
		s obj.INGRTISalePrice=+Sp
		s obj.INGRTISpAmt=+SpAmt
		s obj.INGRTIPurPrice=+Pp
		s obj.INGRTIPpAmt=+PpAmt
		s obj.INGRTISxno=SxNo
		s obj.INGRTIINGRIDR=IngriObj
		d obj.INGRTIRetReasDRSetObjectId(ReasonId)
		d obj.INGRTIMEDRTITMDRSetObjectId(Inclb)
		s obj.INGRTIRemark=Remark
		s obj.INGRTISpecList=SpecDesc
		s Sc=obj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-27,"","插入明细失败!")
		q:RtnObj.success'=0
		
		s RowId=obj.%Id()
		;处理高值条码
		;insert Ingri时保存高值信息, update时不再处理
		i (OldIngrti="")&&(HvBarCode'="") d
		.s RtnObj=##class(web.DHCSTMHUI.DHCItmTrack).Update("R",RowId,HvBarCode,OperData)
		q:RtnObj.success'=0
		
		;增加新占用库存
		s RtnObj=..HandleRetItmDirtyQty(RowId,1)
		q:RtnObj.success'=0
		
		;保存第三方明细id(仅新增时)
		i (OldIngrti="") d
		.s ThirdObj={},ThirdObj.ThirdCode=ThirdCode,ThirdObj.Type="R",ThirdObj.Pointer=RowId,ThirdObj.ThirdId=ThirdId
		.s ThirdStr=ThirdObj.%ToJSON()
		.s RtnObj=##class(web.DHCSTMHUI.DHCServiceBill).Save(ThirdStr)
		q:RtnObj.success'=0
	}
	q RtnObj
}

/// 删除一条退货明细记录
/// Author ：zhwh
/// Date:2012-0-7-05
/// Argu:
///   reti  -退货单明细rowid
/// Return:
///  0 - success
///  <0 - failure
///     
ClassMethod Delete(Params As %String) As %String
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	s $ZT=..sssError()
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		q:RowId=""
		i ##class(web.DHCSTMHUI.DHCINGdRet).AllowDel(+RowId)<0 d
		.s Sc=RtnObj.Err(-2,"","不允许删除","",0)
		q:RtnObj.success'=0
		s RtnObj=..HandleRetItmDirtyQty(RowId,0)
		q:RtnObj.success'=0
		s RtnObj=##class(web.DHCSTMHUI.DHCItmTrackDetail).DelByPointer("R",RowId)
		q:RtnObj.success'=0
		&sql(Delete From DHC_INGrtItm Where INGRTI_RowId=:RowId)
		i SQLCODE<0 d
		.s Sc=RtnObj.Err(-2,"","删除明细失败!")
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	查找退货单明细
/// Creator:	XuChao
/// CreateDate:	2018-07-27
/// Table:		DHC_INGRTITM
/// Input:		排序，查询条件
/// Return：	明细信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINGrtItm","DHCINGdRetItm",5)
Query DHCINGdRetItm(RetId As %String) As Query(ROWSPEC = "RowId,Ingri,Inclb,Code,Description,Spec,SpecDesc,BatNo,ExpDate,Manf,Qty:%Float,Uom,UomDesc,Rp:%Float,RpAmt:%Float,Sp:%Float,SpAmt:%Float,OldSp:%Float,OldSpAmt:%Float,InvNo,InvDate,InvAmt:%Float,SxNo,Reason,ReasonId,AspAmt:%Float,StkQty:%Float,Incscdesc,StkType,Remark,SpecDesc,IntrStkQty:%Float,Model,InvCode,ConFac:%Float,HvFlag,HvBarCode,OriginalStatus,Inci,IngriLeftQty:%Float,InvCode,OrderDetailSubId,MatInsuCode,MatInsuDesc,PConFac:%Float,BUom") [ SqlProc ]
{
}

ClassMethod DHCINGdRetItmExecute(ByRef qHandle As %Binary, RetId As %String) As %Status
{
	n (qHandle,RetId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:RetId="" $$$OK
	s HospId=""
	s FrLocId=$p(^INGRT(RetId),"^",7)
	s:FrLocId'="" HospId=$p(^CTLOC(FrLocId),"^",22)
	s Sql="select %ID RowId,"
		_"ingrti_ingri_dr Ingri,"
		_"ingrti_ingri_dr->initm_phmnf_dr->phmnf_name Manf,"
		_"INGRTI_MEDRTITM_DR Inclb,"
		_"ingrti_retuom_dr Uom,"
		_"ingrti_retuom_dr->ctuom_desc UomDesc,"
		_"ingrti_retqty Qty,"
		_"ingrti_realprice Rp,"
		_"ingrti_retamount RpAmt,"
		_"ingrti_saleprice Sp,"
		_"ingrti_spamt SpAmt,"
		_"ingrti_invNo InvNo,"
		_"ingrti_invCode InvCode,"
		_"ingrti_invDate InvDate,"
		_"ingrti_invAmt InvAmt,"
		_"ingrti_sxno SxNo,"
		_"ingrti_oldSp OldSp,"
		_"ingrti_oldSpAmt OldSpAmt,"
		_"ingrti_retreas_dr ReasonId,"
		_"ingrti_retreas_dr->RET_Desc Reason,"
		_"ingrti_aspamt AspAmt,"
		_"INGRTI_Remark Remark,"
		_"INGRTI_InvCode InvCode,"
		_"INGRTI_SpecList SpecDesc "
		_" from DHC_INGRTITM "
		_" where INGRTI_INGRT_ParRef="_RetId 
		_" ORDER BY INGRTI_ChildSub ASC "
		
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(Sql)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId=xrs.Data("RowId")
		s Ingri=xrs.Data("Ingri")
		s Manf=xrs.Data("Manf")
		s Inclb=xrs.Data("Inclb")
		s Uom=xrs.Data("Uom")
		s UomDesc=xrs.Data("UomDesc")
		s Qty=xrs.Data("Qty")
		s Rp=xrs.Data("Rp")
		s RpAmt=xrs.Data("RpAmt")
		s Sp=xrs.Data("Sp")
		s SpAmt=xrs.Data("SpAmt")
		s InvNo=xrs.Data("InvNo")
		s InvCode=xrs.Data("InvCode")
		s InvDate=xrs.Data("InvDate")
		s InvDate=..DL2H(InvDate)
		s InvAmt=xrs.Data("InvAmt")
		s SxNo=xrs.Data("SxNo")
		s OldSp=xrs.Data("OldSp")
		s OldSpAmt=xrs.Data("OldSpAmt")
		s Reason=xrs.Data("Reason")
		s ReasonId=xrs.Data("ReasonId")
		s AspAmt=xrs.Data("AspAmt")  
		s Remark=xrs.Data("Remark")
		s SpecDesc=xrs.Data("SpecDesc")
		s Inci=+Inclb
		s Code=$p($G(^INCI(Inci,1)),"^",1)
		s Description=$p($G(^INCI(Inci,1)),"^",2)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
		s Incsc=$p($G(^INCI(Inci,2)),"^",2)
		s IncscDesc=$p($G(^INC("SC",Incsc)),"^",2)
		s InclbObj=##class(User.INCItmLcBt).%OpenId(Inclb)
		s BatNo=InclbObj.INCLBINCIBDR.INCIBNo
		s ExpDate=InclbObj.INCLBINCIBDR.INCIBExpDate
		s ExpDate=..DL2H(ExpDate)
		s StkQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbAvaQty(Inclb,Uom)   ;当前可用库存
		s StkType=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci),"^",6)
		s IntrStkQtyB=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetIntrStkQty("R",RowId)
		s BUom=$p(^INCI(Inci,1),"^",10)
		s PUom=$p(^INCI(Inci,3),"^",6)
		s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(Uom,BUom)
		s PConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PUom,BUom)
		s IntrStkQty=IntrStkQtyB/UomFac
		s Model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(Inci)
		s InvCode=xrs.Data("InvCode")
		s PurUom=$p(^INCI(Inci,3),"^",6)
		s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUom,BUom)
		s HvFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
		s HvBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr("R",RowId)
		s dhcit="",OriginalStatus=""
		i HvBarCode'="" d
		.s dhcit=$o(^DHCIT(0,"LABEL",HvBarCode,0))
		.s:dhcit'="" OriginalStatus=$p(^DHCIT(dhcit),"^",35)
		s IngriLeftQty=##class(web.DHCSTMHUI.DHCINGdRet).GetIngriLeftQty(Ingri,RowId)
		s Ingr=$p(Ingri,"||",1),IngrCh=$p(Ingri,"||",2)
		s OrderDetailSubId=""
		i Ingr'="" d
		.s OrderDetailSubId=$p(^DHCINGR(Ingr,"GRI",IngrCh),"^",64)
		s MatInsuInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMatInsuInfo(Inci,HospId)
		s MatInsuCode=$p(MatInsuInfo,"^",1)
		s MatInsuDesc=$p(MatInsuInfo,"^",2)
		d OutPutRow
	}
	q $$$OK
OutPutRow
	s Data=$lb(RowId,Ingri,Inclb,Code,Description,Spec,SpecDesc,BatNo,ExpDate,Manf,
		Qty,Uom,UomDesc,Rp,RpAmt,Sp,SpAmt,OldSp,OldSpAmt,InvNo,
		InvDate,InvAmt,SxNo,Reason,ReasonId,AspAmt,StkQty,IncscDesc,StkType,Remark,
		SpecDesc,IntrStkQty,Model,InvCode,ConFac,HvFlag,HvBarCode,OriginalStatus,Inci,IngriLeftQty,InvCode,
		OrderDetailSubId,MatInsuCode,MatInsuDesc,PConFac,BUom)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 根据退货主表的Id查询退货单号
/// Author:zhwh
/// Date:2012-07-16
/// Argu:RowId - 退货主表记录rowid
/// Return:退货单号
ClassMethod GetOrderByRowId(RowId As %String) As %String
{
	n (RowId)

	q:RowId="" ""
	q ##class(User.DHCINGDRET).%OpenId(RowId).INGRTNO
}

/// Descript:	根据退货单RowId取得明细信息(合并同单品高值)打印单据用
/// Creator:	lxt
/// CreateDate:	2019-03-29
/// Table:		DHC_INGRTITM
/// Input:		排序，查询条件   
/// Return：	退货明细
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINGrtItm","QueryHVColDetail","","",17)
Query QueryHVColDetail(RetId As %String) As Query(ROWSPEC = "InciCode,InciDesc,Spec,SpecDesc,BatNo,ExpDate,Qty:%Float,UomDesc,Rp:%Float,RpAmt:%Float,Sp:%Float,SpAmt:%Float,OldSp:%Float,OldSpAmt:%Float,InvNo,InvDate,InvAmt:%Float,InvCode,SxNo,Reason,AspAmt:%Float,IncscDesc,Remark,ManfDesc,Model,HvFlag") [ SqlProc ]
{
}

ClassMethod QueryHVColDetailExecute(ByRef qHandle As %Binary, RetId As %String) As %Status
{
	n (qHandle,RetId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:RetId="" $$$OK

	s Sql="select %ID RowId,"
	s Sql=Sql_"ingrti_ingri_dr Ingri,"
	s Sql=Sql_"ingrti_ingri_dr->initm_phmnf_dr->phmnf_name Manf,"
	s Sql=Sql_"INGRTI_MEDRTITM_DR Inclb,"
	s Sql=Sql_"ingrti_retuom_dr Uom,"
	s Sql=Sql_"ingrti_retuom_dr->ctuom_desc UomDesc,"
	s Sql=Sql_"ingrti_retqty Qty,"
	s Sql=Sql_"ingrti_realprice Rp,"
	s Sql=Sql_"ingrti_retamount RpAmt,"
	s Sql=Sql_"ingrti_saleprice Sp,"
	s Sql=Sql_"ingrti_spamt SpAmt,"
	s Sql=Sql_"ingrti_invNo InvNo,"
	s Sql=Sql_"ingrti_invDate InvDate,"
	s Sql=Sql_"ingrti_invAmt InvAmt,"
	s Sql=Sql_"ingrti_sxno SxNo,"
	s Sql=Sql_"ingrti_oldSp OldSp,"
	s Sql=Sql_"ingrti_oldSpAmt OldSpAmt,"
	s Sql=Sql_"ingrti_retreas_dr ReasonId,"
	s Sql=Sql_"ingrti_retreas_dr->RET_Desc Reason,"
	s Sql=Sql_"ingrti_aspamt AspAmt,"
	s Sql=Sql_"INGRTI_Remark Remark,"
	s Sql=Sql_"INGRTI_InvCode InvCode "
	s Sql=Sql_" from DHC_INGRTITM "
	s Sql=Sql_" where INGRTI_INGRT_ParRef="_RetId 
	k ^TMPINGRTHVCOLDETAIL
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(Sql)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId=xrs.Data("RowId")
		s Ingri=xrs.Data("Ingri")
		s Manf=xrs.Data("Manf")
		s Inclb=xrs.Data("Inclb")
		s Uom=xrs.Data("Uom")
		s UomDesc=xrs.Data("UomDesc")
		s Qty=xrs.Data("Qty")
		s Rp=xrs.Data("Rp")
		s RpAmt=xrs.Data("RpAmt")
		s Sp=xrs.Data("Sp")
		s SpAmt=xrs.Data("SpAmt")
		s InvNo=xrs.Data("InvNo")
		s InvDate=xrs.Data("InvDate")
		s InvDate=..DL2H(InvDate)
		s InvAmt=xrs.Data("InvAmt")
		s SxNo=xrs.Data("SxNo")
		s OldSp=xrs.Data("OldSp")
		s OldSpAmt=xrs.Data("OldSpAmt")
		s Reason=xrs.Data("Reason")
		s ReasonId=xrs.Data("ReasonId")
		s AspAmt=xrs.Data("AspAmt")  
		s Remark=xrs.Data("Remark")
		s SpecDesc=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSpecDescByInclb(Inclb)
		s Inci=+Inclb
		s Code=$p($G(^INCI(Inci,1)),"^",1)
		s Description=$p($G(^INCI(Inci,1)),"^",2)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
		s Incsc=$p($G(^INCI(Inci,2)),"^",2)
		s IncscDesc=$p($G(^INC("SC",Incsc)),"^",2)
		s InclbObj=##class(User.INCItmLcBt).%OpenId(Inclb)
		s BatNo=InclbObj.INCLBINCIBDR.INCIBNo
		s ExpDate=InclbObj.INCLBINCIBDR.INCIBExpDate
		s ExpDate=..DL2H(ExpDate)
		s StkQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbAvaQty(Inclb,Uom)   ;当前可用库存
		s StkType=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci),"^",6)
		s IntrStkQtyB=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetIntrStkQty("R",RowId)
		s BUom=$p(^INCI(Inci,1),"^",10)
		s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(Uom,BUom)
		s IntrStkQty=IntrStkQtyB/UomFac
		s Model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(Inci)
		s InvCode=xrs.Data("InvCode")
		s PurUom=$p(^INCI(Inci,3),"^",6)
		s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUom,BUom)
		s HvFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
		s HvBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr("R",RowId)
		
		i '$d(^TMPINGRTHVCOLDETAIL(Inci))  d
		.s Data1=Code_"^"_Description_"^"_Spec_"^"_SpecDesc_"^"_BatNo
		.s Data2=ExpDate_"^"_Qty_"^"_UomDesc_"^"_Rp_"^"_RpAmt
		.s Data3=Sp_"^"_SpAmt_"^"_OldSp_"^"_OldSpAmt_"^"_InvNo
		.s Data4=InvDate_"^"_InvAmt_"^"_InvCode_"^"_SxNo_"^"_Reason
		.s Data5=AspAmt_"^"_IncscDesc_"^"_Remark_"^"_Manf_"^"_Model
		.s Data6=HvFlag
		.s ^TMPINGRTHVCOLDETAIL(Inci)=Data1_"^"_Data2_"^"_Data3_"^"_Data4_"^"_Data5_"^"_Data6
		e  d
		.s TmpQty=$p(^TMPINGRTHVCOLDETAIL(Inci),"^",7)+Qty
		.s TmpRpAmt=$p(^TMPINGRTHVCOLDETAIL(Inci),"^",10)+RpAmt
		.s TmpSpAmt=$p(^TMPINGRTHVCOLDETAIL(Inci),"^",12)+SpAmt
		.s TmpOldSpAmt=$p(^TMPINGRTHVCOLDETAIL(Inci),"^",14)+OldSpAmt
		.s TmpInvAmt=$p(^TMPINGRTHVCOLDETAIL(Inci),"^",17)+InvAmt
		.s TmpAspAmt=$p(^TMPINGRTHVCOLDETAIL(Inci),"^",21)+AspAmt
		.s $p(^TMPINGRTHVCOLDETAIL(Inci),"^",7)=TmpQty
		.s $p(^TMPINGRTHVCOLDETAIL(Inci),"^",10)=TmpRpAmt
		.s $p(^TMPINGRTHVCOLDETAIL(Inci),"^",12)=TmpSpAmt
		.s $p(^TMPINGRTHVCOLDETAIL(Inci),"^",14)=TmpOldSpAmt
		.s $p(^TMPINGRTHVCOLDETAIL(Inci),"^",17)=TmpInvAmt
		.s $p(^TMPINGRTHVCOLDETAIL(Inci),"^",21)=TmpAspAmt
	}
	s Inci=0
	f  s Inci=$o(^TMPINGRTHVCOLDETAIL(Inci)) q:(Inci="")  d
	.s InciCode=$p(^TMPINGRTHVCOLDETAIL(Inci),"^",1)
	.s InciDesc=$p(^TMPINGRTHVCOLDETAIL(Inci),"^",2)
	.s Spec=$p(^TMPINGRTHVCOLDETAIL(Inci),"^",3)
	.s SpecDesc=$p(^TMPINGRTHVCOLDETAIL(Inci),"^",4)
	.s BatNo=$p(^TMPINGRTHVCOLDETAIL(Inci),"^",5)
	.
	.s ExpDate=$p(^TMPINGRTHVCOLDETAIL(Inci),"^",6)
	.s Qty=$p(^TMPINGRTHVCOLDETAIL(Inci),"^",7)
	.s UomDesc=$p(^TMPINGRTHVCOLDETAIL(Inci),"^",8)
	.s Rp=$p(^TMPINGRTHVCOLDETAIL(Inci),"^",9)
	.s RpAmt=$p(^TMPINGRTHVCOLDETAIL(Inci),"^",10)
	.
	.s Sp=$p(^TMPINGRTHVCOLDETAIL(Inci),"^",11)
	.s SpAmt=$p(^TMPINGRTHVCOLDETAIL(Inci),"^",12)
	.s OldSp=$p(^TMPINGRTHVCOLDETAIL(Inci),"^",13)
	.s OldSpAmt=$p(^TMPINGRTHVCOLDETAIL(Inci),"^",14)
	.s InvNo=$p(^TMPINGRTHVCOLDETAIL(Inci),"^",15)
	.
	.s InvDate=$p(^TMPINGRTHVCOLDETAIL(Inci),"^",16)
	.s InvAmt=$p(^TMPINGRTHVCOLDETAIL(Inci),"^",17)
	.s InvCode=$p(^TMPINGRTHVCOLDETAIL(Inci),"^",18)
	.s SxNo=$p(^TMPINGRTHVCOLDETAIL(Inci),"^",19)
	.s Reason=$p(^TMPINGRTHVCOLDETAIL(Inci),"^",20)
	.
	.s AspAmt=$p(^TMPINGRTHVCOLDETAIL(Inci),"^",21)
	.s IncscDesc=$p(^TMPINGRTHVCOLDETAIL(Inci),"^",22)
	.s Remark=$p(^TMPINGRTHVCOLDETAIL(Inci),"^",23)
	.s ManfDesc=$p(^TMPINGRTHVCOLDETAIL(Inci),"^",24)
	.s Model=$p(^TMPINGRTHVCOLDETAIL(Inci),"^",25)
	.
	.s HvFlag=$p(^TMPINGRTHVCOLDETAIL(Inci),"^",26)
	.
	.d OutPutRowINGRTHVColDetail

	q $$$OK
OutPutRowINGRTHVColDetail
	s Data=$lb(InciCode,InciDesc,Spec,SpecDesc,BatNo,
		ExpDate,Qty,UomDesc,Rp,RpAmt,
		Sp,SpAmt,OldSp,OldSpAmt,InvNo,
		InvDate,InvAmt,InvCode,SxNo,Reason,
		AspAmt,IncscDesc,Remark,ManfDesc,Model,
		HvFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	处理退货明细记录的占用数量
/// CreateDate:	2023-03-17
/// Input:		退货子表 Ingrti, Sign(0:减, 1:增)
/// Output:	w ##class(web.DHCSTMHUI.DHCINGrtItm).HandleRetItmDirtyQty("9||1",1)	
ClassMethod HandleRetItmDirtyQty(Ingrti As %String, Sign As %String) As RtnObj
{
	n (Ingrti,Sign)
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$CLASSNAME()_".HandleRetItmDirtyQty"
	s obj=##class(User.DHCINGRTITM).%OpenId(Ingrti)
	d obj.%Reload()
	s Inclb=obj.INGRTIMEDRTITMDRGetObjectId()
	s Qty=obj.INGRTIRetQty
	s Uom=obj.INGRTIRetUomDRGetObjectId()
	s BUom=$p(^INCI(+Inclb,1),"^",10)
	s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(Uom,BUom)
	s Qty=Qty*fac
	i Sign="0" s Qty=-Qty
	s Err=##class(web.DHCSTMHUI.Common.StockHandle).UpdateDirtyQty(Inclb,Qty)
	i (+Err'=0)&&(Sign=0) q RtnObj.Err(-1,"",MethodName_":清除占用失败")
	i (+Err'=0)&&(Sign=1) q RtnObj.Err(-2,"",MethodName_":增加占用失败")
	q RtnObj
}

}
