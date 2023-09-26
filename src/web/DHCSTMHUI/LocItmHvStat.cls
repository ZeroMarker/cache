Import sqluser

/// Descript:高值全院库存
/// Creator:
/// CreateDate: 2022-12-21
Class web.DHCSTMHUI.LocItmHvStat Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.LocItmHvStat","LocItmStkAllHV",^tmpltx(12291))
Query LocItmStkAllHV(Params As %String(MAXLEN="")) As Query(ROWSPEC = "Label,CurrentLocId,CurrentLocDesc,Incil,Inci,InciCode,InciDesc,PurchCTUomDesc,BaseCTUomDesc,Sp:%Float,Spec,ManfDesc,Incib,BatchNo,ExpDate,Scg,ScgDesc,Incsc,IncscDesc,VendorDesc,IntrDate,IntrTime,Rp:%Float") [ SqlProc ]
{
}

ClassMethod LocItmStkAllHVExecute(ByRef qHandle As %Binary, Params As %String(MAXLEN="")) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s LocId=PJObj.%Get("PhaLoc")
	s pStartDate=PJObj.%Get("StartDate")
	s:pStartDate'="" pStartDate=..DH2L(pStartDate)
	s pInci=PJObj.%Get("Inci")
	s pStkGrpId=PJObj.%Get("ScgStk")
	s pStkCatId=PJObj.%Get("StkCat")
	s pManfId=PJObj.%Get("Manf")
	s pVendor=PJObj.%Get("Vendor")
	s pInciDesc=PJObj.%Get("InciDesc")
	s pINFOImportFlag=PJObj.%Get("INFOImportFlag")
	s pUseFlag=PJObj.%Get("UseFlag")
	s pARCItemCat=PJObj.%Get("ARCItemCat")
	s gHospId=PJObj.%Get("gHospId")
	s pStkGrpId=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr("",..sssCode(),"",pStkGrpId,gHospId)
	s Inci=0
	f  s Inci=$o(^DHCIT(0,"StatusInci","Enable",Inci)) q:(Inci="")  d
	.q:'$d(^INCI(Inci))
	.q:(pInci'="")&&(Inci'=pInci)
	.s StkGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s ScgDesc=$p(StkGrpInfo,"^",2)
	.s Scg=$p(StkGrpInfo,"^",5)
	.q:(pStkGrpId'="")&&(("^"_pStkGrpId_"^")'[("^"_Scg_"^"))
	.s ScgType=$p(StkGrpInfo,"^",3)
	.s Incsc=$p(^INCI(Inci,2),"^",2)
	.q:(pStkCatId'="")&&(Incsc'=pStkCatId)
	.s IncscDesc=$p($g(^INC("SC",Incsc)),"^",2)
	.s InciCode = $p(^INCI(Inci,1),"^",1)
	.s InciDesc = $p(^INCI(Inci,1),"^",2)
	.q:(pInci="")&&(pInciDesc'="")&&(InciDesc'[pInciDesc)
	.s NotUse=$p(^INCI(Inci,2),"^",9)
	.q:NotUse=pUseFlag
	.s ArcItmCatInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetArcItemCat(Inci)
	.s ItemCatId=$p(ArcItmCatInfo,"^",1)
	.q:(pARCItemCat'="")&&(ItemCatId'=pARCItemCat)
	.s ItmImpFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetItmImportFlag(Inci)
	.q:((pINFOImportFlag'="")&&(pINFOImportFlag'="全部"))&&(ItmImpFlag'=pINFOImportFlag)
	.s PurUomId=$p(^INCI(Inci,3),"^",6)
	.s BUomId=$p(^INCI(Inci,1),"^",10)
	.s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	.s (BaseCTUomDesc,PurchCTUomDesc)=""
	.s:BUomId'="" BaseCTUomDesc =$p(^CT("UOM",BUomId),"^",2)
	.s:PurUomId'="" PurchCTUomDesc =$p(^CT("UOM",PurUomId),"^",2)
	.s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
	.
	.s dhcit=0
	.f  s dhcit=$o(^DHCIT(0,"StatusInci","Enable",Inci,dhcit)) q:(+dhcit=0)||(dhcit="")  d
	..s Label=$p(^DHCIT(dhcit),"^",2)
	..s dhcitDate=$p(^DHCIT(dhcit),"^",8)
	..s VendorId=$p(^DHCIT(dhcit),"^",11)
	..s Inclb=$p(^DHCIT(dhcit),"^",12)
	..s ManfId=$p(^DHCIT(dhcit),"^",15)
	..q:Inclb=""
	..s Incil=$p(Inclb,"||",1,2)
	..s il=$p(Incil,"||",2)
	..s lb=$p(Inclb,"||",3)
	..s CurrentLocId=$p(^INCI(Inci,"IL",il),"^",1)
	..q:(LocId'="")&&(CurrentLocId'=LocId)
	..q:(pStartDate'="")&&(dhcitDate>pStartDate)
	..q:(pVendor'="")&&(VendorId'=pVendor)
	..q:(pManfId'="")&&(ManfId'=pManfId)
	..s ManfDesc=$s(ManfId'="":$p(^PHMNF(ManfId),"^",2),1:"")
	..s VendorDesc=$s(VendorId'="":$p(^APC("APCVM",VendorId),"^",3),1:"")
	..s Pointer=""
	..s (sub,IngrDate,IngrTime)=""
	..f  s sub=$o(^DHCITD(dhcit,"I",sub))  q:(sub="")||(Pointer'="")  d
	...s IntrType=$p(^DHCITD(dhcit,"I",sub),"^",2)
	...s:IntrType="G" Pointer=$p(^DHCITD(dhcit,"I",sub),"^",1)
	..s IntrStr=..GetIntrInfo("G",Pointer)
	..s IngrLogDate=$p(IntrStr,"^",1)
	..s IngrLogTime=$p(IntrStr,"^",2)
	..s:IngrLogDate'="" IngrDate=$zd(IngrLogDate,3)
	..s:IngrLogTime'="" IngrTime=$zt(IngrLogTime,1)
	..
	..s CurrentLocDesc=$P(^CTLOC(CurrentLocId),"^",2)
	..s HospId=$p(^CTLOC(CurrentLocId),"^",22)
	..s BatExp=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(Inclb)
	..s BatchNo=$p(BatExp,"^",1)
	..s ExpDate=$p(BatExp,"^",2)
	..s Incib=$p(^INCI(Inci,"IL",il,"LB",lb),"^",1)
	..s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inclb,pStartDate,PurUomId,HospId)
	..s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,BUomId,HospId)
	..d OutPutAllRow
	
	Quit $$$OK
OutPutAllRow
	s Data=$lb(Label,CurrentLocId,CurrentLocDesc,Incil,Inci,
			InciCode,InciDesc,PurchCTUomDesc,BaseCTUomDesc,Sp,
			Spec,ManfDesc,Incib,BatchNo,ExpDate,
			Scg,ScgDesc,Incsc,IncscDesc,VendorDesc,
			IngrDate,IngrTime,Rp)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 获取台帐日期,时间,人员
ClassMethod GetIntrInfo(Type As %String, Pointer As %String) As %String
{
	n (Type,Pointer)
	q:(Type="")||(Pointer="") ""
	s date=+$h,time=$p($h,",",2),user=""
	s str=""
	s intr=$o(^DHCINTR(0,"TypePointer",Type,Pointer,0))
	q:intr="" str
	s date=$p(^DHCINTR(intr),"^",2)
	s time=$p(^DHCINTR(intr),"^",3)
	s user=$p(^DHCINTR(intr),"^",11)
	s str=date_"^"_time_"^"_user
	q str
}

}
