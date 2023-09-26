Import sqluser

/// Descript:红冲明细表相关
/// Creater: wxj
/// CreateDate: 2022-09-02
Class web.DHCSTMHUI.RedOffsetItm Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:红冲明细表相关
/// Creater: wxj
/// CreateDate: 2022-09-02
/// Table:HRP.MAT.INGRRedOffsetItm
/// Return：0：成功，
/// 失败：ErrCode:ErrInfo
ClassMethod Save(RowId, DetailData) As RtnObj
{
	n (RowId,DetailData)
	s RtnObj=##class(RtnObj).%New()
	i ((RowId="")||('$d(^HRP.MAT.INGRRedOffsetD(RowId))))  d
	.s Sc=RtnObj.Err(-2,"","红冲单不存在!","",0)
	q:RtnObj.success'=0 RtnObj
	i DetailData="" d
	.s Sc=RtnObj.Err(-3,"","不存在需要保存的明细!","",0)
	q:RtnObj.success'=0 RtnObj
	s PJObjItm=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObjItm.%FromJSON(DetailData)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-4,"","明细入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	s Err=""
	While (RtnObj.success=0) {
		s ListDataObj=PJObjItm.%Pop()
		q:ListDataObj=""
		s RedItmId=ListDataObj.%Get("RedItmId")
		s Inclb=ListDataObj.%Get("Inclb")
		s ToInclb=ListDataObj.%Get("ToInclb")
		s Qty=ListDataObj.%Get("Qty")
		s UomId=ListDataObj.%Get("UomId")
		s NewRp=ListDataObj.%Get("NewRp")
		s NewSp=ListDataObj.%Get("NewSp")
		s OldRp=ListDataObj.%Get("OldRp")
		s OldSp=ListDataObj.%Get("OldSp")
		s StoreFlag=ListDataObj.%Get("StoreFlag")
		s Ingri=ListDataObj.%Get("Ingri")
		i RedItmId="" d
		.s Obj=##class(HRP.MAT.INGRRedOffsetItm).%New()
		e  d
		.s Obj=##class(HRP.MAT.INGRRedOffsetItm).%OpenId(RedItmId)
		d Obj.INGRROIParRefSetObjectId(RowId)
		d Obj.INGRROIINCLBDRSetObjectId(Inclb)
		d Obj.INGRROITOINCLBDRSetObjectId(ToInclb)
		d Obj.INGRROICTUOMDRSetObjectId(UomId)
		d Obj.INGRROIIngriDRSetObjectId(Ingri)
		s Obj.INGRROIQty=Qty
		s Obj.INGRROIRp=NewRp
		s Obj.INGRROISp=NewSp
		s Obj.INGRROIOldRp=OldRp
		s Obj.INGRROIOldSp=OldSp
		s Obj.INGRROIStoreFlag=StoreFlag
		s Sc=Obj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-5,"","保存红冲明细失败!")
		q:RtnObj.success'=0
	}
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.RedOffsetItm","QueryDetail",1)
Query QueryDetail(Parref As %String) As Query(ROWSPEC = "RowId,IncId,InciCode,InciDesc,Spec,Model,ManfId,Manf,BatchNo,ExpDate,UomId,Uom,Qty:%Float,NewRp:%Float,NewSp:%Float,OldRp:%Float,OldSp:%Float,NewRpAmt:%Float,NewSpAmt:%Float,OldRpAmt:%Float,OldSpAmt:%Float,StoreFlag") [ SqlProc ]
{
}

ClassMethod QueryDetailExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	n (qHandle,Parref,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	q:Parref="" $$$OK
	s CH=0
	f  s CH=$o(^HRP.MAT.INGRRedOffsetD(Parref,"Itm",CH)) q:CH=""  d
	.s RowId=Parref_"||"_CH
	.s RedOffsetList=^HRP.MAT.INGRRedOffsetD(Parref,"Itm",CH)
	.s Inclb=$lg(RedOffsetList,2)
	.s ToInclb=$lg(RedOffsetList,3)
	.s Qty=$lg(RedOffsetList,4)
	.s UomId=$lg(RedOffsetList,5)
	.s NewRp=+$lg(RedOffsetList,6)
	.s NewSp=+$lg(RedOffsetList,7)
	.s OldRp=+$lg(RedOffsetList,8)
	.s OldSp=+$lg(RedOffsetList,9)
	.s Ingri=$lg(RedOffsetList,10)
	.s Initi=$lg(RedOffsetList,11)
	.s StoreFlag=$lg(RedOffsetList,13)
	.s OldRpAmt=OldRp*Qty
	.s OldSpAmt=OldSp*Qty
	.s NewRpAmt=NewRp*Qty
	.s NewSpAmt=NewSp*Qty
	.s IncId=+Inclb
	.s InciCode=$p(^INCI(IncId,1),"^",1)
	.s InciDesc=$p(^INCI(IncId,1),"^",2)
	.s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",IncId)
	.s Model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(IncId)
	.s BatExp=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(Inclb)
	.s BatchNo=$p(BatExp,"^",1)
	.s ExpDate=$p(BatExp,"^",2)
	.s ManfInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb)
	.s ManfId=$p(ManfInfo,"^",1)
	.s Manf=$p(ManfInfo,"^",2)
	.s Uom=""
	.s:UomId'="" Uom=$p(^CT("UOM",UomId),"^",2)
	.d OutPutDetail
	Quit $$$OK

OutPutDetail
	s Data=$lb(RowId,IncId,InciCode,InciDesc,Spec,Model,ManfId,Manf,BatchNo,ExpDate,
			UomId,Uom,Qty,NewRp,NewSp,OldRp,OldSp,NewRpAmt,NewSpAmt,OldRpAmt,OldSpAmt,
			StoreFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
