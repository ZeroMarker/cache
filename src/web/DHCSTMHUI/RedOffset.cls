Import sqluser

/// Descript:红冲主表相关
/// Creater: wxj
/// CreateDate: 2022-09-01
Class web.DHCSTMHUI.RedOffset Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTMREDOFFSET";

/// Descript:	创建红冲单信息(Js调用)
/// Creator:	wxj
/// CreateDate:	2022-09-01
/// w ##class(web.DHCSTMHUI.RedOffset).jsCreate(^tempxj("RecMainData"),^tempxj("RecDetailData"))
ClassMethod jsCreate(RecMainData, DetailData) As %Library.String
{
	n (RecMainData,DetailData)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Create(RecMainData,DetailData)
	q RtnObj.Json()
}

/// Descript:	创建红冲单信息
/// Creator:	wxj
/// CreateDate:	2022-09-01
/// Table:	HRP_MAT_INGRRedOffset
/// Return：成功：主表id;失败：ErrCode:ErrInfo
/// w ##class(web.DHCSTMHUI.RedOffset).Save(^tempxj("MainInfo"),^tempxj("ListData"))
ClassMethod Create(RecMainData, DetailData) As RtnObj
{
	n (RecMainData,DetailData)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(RecMainData)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!","",0)
	s GroupId=PJObj.%Get("gGroupId")
	s UserId=PJObj.%Get("gUserId")
	s LocId=PJObj.%Get("RecLocId")
	ts
	s RtnObj=..Update(RecMainData)
	i RtnObj.success'=0 tro  q RtnObj
	s RowId=RtnObj.rowid
	i DetailData'=""  d
	.s RtnObj=##class(web.DHCSTMHUI.RedOffsetItm).Save(RowId,DetailData)
	i RtnObj.success'=0 tro  q RtnObj
	
	///保存时自动完成
	s Param=GroupId_"^"_LocId_"^"_UserId
	s AppName=..%GetParameter("AppName")
	s AutoCompAfterSave=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"AutoCompAfterSave",Param)
	s Params="{""gUserId"":"""_UserId_""",""gGroupId"":"""_GroupId_"""}"
	i AutoCompAfterSave="Y" d
	.s RtnObj=..MakeComplete(RowId,Params)
	i RtnObj.success'=0  tro  q RtnObj	
	tc
	s RtnObj.rowid=RowId
	q RtnObj
}

/// Descript:	保存/更新红冲单信息
/// Creator:	wxj
/// CreateDate:	2022-09-01
/// Table:	HRP_MAT_INGRRedOffset
ClassMethod Update(RecMainData As %String) As RtnObj
{
	n (RecMainData,%session)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(RecMainData)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!","","0")
	s RowId=PJObj.%Get("RowId")
	s VenId=PJObj.%Get("VendorId")
	i VenId="" q RtnObj.Err(-2,"","供应商不能为空!","","0")
	s LocId=PJObj.%Get("RecLocId")
	i LocId="" q RtnObj.Err(-3,"","红冲科室不能为空!","","0")
	s CreateUser=PJObj.%Get("gUserId")
	s CreateDate=+$h
	s CreateTime=$p($h,",",2)
	s StkType=..sssCode()
	;生成单号
	s AppName=..%GetParameter("AppName")
	s ret=..sssLock(AppName)
	i ret'=0 q RtnObj.Err(-99,"","生成红冲单号加锁失败!")
	s RedNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,"",LocId)
	i RedNo="" d ..sssUnLock(AppName) d RtnObj.Err(-4,"","生成红冲单号失败!")
	q:RtnObj.success'=0 RtnObj
	i RowId="" d
	.s Obj=##class(HRP.MAT.INGRRedOffset).%New()
	e  d
	.s Obj=##class(HRP.MAT.INGRRedOffset).%OpenId(RowId)
	s Obj.INGRRONo=RedNo
	d Obj.INGRROAPCVMDRSetObjectId(VenId)
	d Obj.INGRROLocDRSetObjectId(LocId)
	d Obj.INGRROCreateUserSetObjectId(CreateUser)	
	s Obj.INGRROCreateDate=CreateDate
	s Obj.INGRROCreateTime=CreateTime
	s Sc=Obj.%Save()
	i $$$ISERR(Sc) q RtnObj.Err(-4,"","保存红冲单主表失败!")
	s RowId=Obj.%Id()
	s RtnObj.rowid=RowId
	d ..sssUnLock(AppName)
	q RtnObj
}

/// Descript:完成红冲单(Js调用)
/// Creator: wxj
/// CreateDate: 2022-09-06
/// w ##class(web.DHCSTMHUI.RedOffset).jsMakeComplete()
ClassMethod jsMakeComplete(RedId As %String) As %Library.String
{
	n (RedId)
	s RtnObj=##class(RtnObj).%New()
	s $ZT=..sssError()
	s RtnObj=..MakeComplete(RedId)
	q RtnObj.Json()
}

/// Descript:完成红冲单
/// Creator: wxj
/// CreateDate: 2022-09-06
/// w ##class(web.DHCSTMHUI.RedOffset).MakeComplete()
ClassMethod MakeComplete(RedId As %String) As RtnObj
{
	n (RedId)
	s RtnObj=##class(RtnObj).%New()
	i RedId=""  q RtnObj.Err(-2,"","请选择红冲单","",0)
	i '$d(^HRP.MAT.INGRRedOffsetD(RedId))  q RtnObj.Err(-3,"","红冲单不存在!","",0)
	i $lg(^HRP.MAT.INGRRedOffsetD(RedId),8)="Y"  q RtnObj.Err(-4,"","红冲单已经完成!","",0)
	s CompFlag="Y",CompDate=+$h,CompTime=$p($h,",",2)
	&sql(update HRP_MAT.INGRRedOffset set INGRRO_CompFlag=:CompFlag,
	INGRRO_CompleteDate=:CompDate,INGRRO_CompleteTime=:CompTime 
	where %ID=:RedId)
	i SQLCODE'=0 q RtnObj.Err(-5,"","操作完成失败!")
	q RtnObj
}

/// Descript:取消完成红冲单(Js调用)
/// Creator: wxj
/// CreateDate: 2022-09-06
ClassMethod jsCancleComplete(RedId As %String) As %Library.String
{
	n (RedId)
	s RtnObj=##class(RtnObj).%New()
	s $ZT=..sssError()
	s RtnObj=..CancleComplete(RedId)
	q RtnObj.Json()
}

/// Descript:取消完成红冲单
/// Creator: wxj
/// CreateDate: 2022-09-06
ClassMethod CancleComplete(RedId As %String) As RtnObj
{
	n (RedId)
	s RtnObj=##class(RtnObj).%New()
	i RedId=""  q RtnObj.Err(-2,"","请选择红冲单","",0)
	i '$d(^HRP.MAT.INGRRedOffsetD(RedId))  q RtnObj.Err(-3,"","红冲单不存在!","",0)
	i $lg(^HRP.MAT.INGRRedOffsetD(RedId),8)'="Y"  q RtnObj.Err(-4,"","红冲单未完成!","",0)
	i $lg(^HRP.MAT.INGRRedOffsetD(RedId),11)="Y" q RtnObj.Err(-5,"","红冲单已经审核!","",0)
	
	s Complete="N"
	&sql(update HRP_MAT.INGRRedOffset set INGRRO_CompFlag=:CompFlag,
	INGRRO_CompleteDate=NULL,INGRRO_CompleteTime=NULL 
	where %ID=:RedId)
	i SQLCODE'=0 q RtnObj.Err(-6,"","取消完成失败!")
	q RtnObj
}

/// Descript:	根据RowId取得红冲单主表信息
/// Creator: wxj
/// CreateDate: 2022-09-06
ClassMethod Select(RedId As %String) As %String
{
	n (RedId)
	q:+RedId=0 ""
	
	s RedMainList=^HRP.MAT.INGRRedOffsetD(RedId)
	s RedNo=$lg(RedMainList,2)
	s RedVendorId=$lg(RedMainList,3)
	s RedLocId=$lg(RedMainList,4)
	s CreateUserId=$lg(RedMainList,5)
	s CreateDate=$lg(RedMainList,6)
	s CreateTime=$lg(RedMainList,7)
	s CompFlag=$lg(RedMainList,8)
	
	s (RedLocIdDesc,RedVendorDesc,CreateUserDesc)=""
	s:RedLocId'="" RedLocIdDesc=$p(^CTLOC(RedLocId),"^",2)
	s:RedVendorId'="" RedVendorDesc=$p(^APC("APCVM",RedVendorId),"^",3)
	s:CreateUserId'="" CreateUserDesc=$p(^SSU("SSUSR",CreateUserId),"^",2)
	s:+CreateDate'=0 CreateDate=..DL2H(CreateDate)
	s:+CreateTime'=0 CreateTime=..TL2H(CreateTime)
	s RedVendor=..sssComboStr(RedVendorId,RedVendorDesc)
	s RedLoc=..sssComboStr(RedLocId,RedLocIdDesc)
	s CreateUser=..sssComboStr(CreateUserId,CreateUserDesc)
	s Data=RedId_"^"_RedNo_"^"_RedVendor_"^"_RedLoc_"^"_CreateUser_"^"_CreateDate_"^"_CreateTime_"^"_CompFlag
	s Title="RowId^RedNo^RedVendor^RedLoc^CreateUser^CreateDate^CreateTime^Comp"
	s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Rtn
}

/// Descript:	获取入库单信息
/// Creator:	wxj
/// CreateDate:	2022-09-01
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.RedOffset","GetRecMain",^tempxj("GetRecMain"))
Query GetRecMain(Params As %String) As Query(ROWSPEC = "IngrId,IngrNo,VendorId,VendorDesc,RecLocId,RecLocDesc,CreateDate,AuditDate")
{
}

ClassMethod GetRecMainExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Params="" $$$OK
	
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s PStartDate=PJobj.%Get("StartDate")
	s PEndDate=PJobj.%Get("EndDate") 
	s PRecNo=PJobj.%Get("RecNo")
	s PVendorId=PJobj.%Get("Vendor")
	s PRecLoc=PJobj.%Get("RecLoc")
	s PInciDesc=PJobj.%Get("InciDesc")
	s PInci=PJobj.%Get("Inci")
	s gUserId=PJobj.%Get("gUserId")
	s gHospId=PJobj.%Get("gHospId")
	s gGroupId=PJobj.%Get("gGroupId")
	s PHVFlag="N"
	q:(PStartDate="")||(PEndDate="")||(PRecLoc="") $$$OK
	
	s PStartDate=..DH2L(PStartDate)
	s PEndDate=..DH2L(PEndDate)
	s PHospId=..sssHospId(PRecLoc)
	s:PHospId="" PHospId=gHospId
	s StkGrplist=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(gUserId,..sssCode(),PRecLoc,"",PHospId)
	s sqlStr = "SELECT INGR_RowId Ingr,INGR_No IngrNo,INGR_APCVM_DR VendorId,INGR_APCVM_DR->APCVM_Name VendorDesc,"
		_"INGR_Loc_Dr->CTLOC_Desc RecLocDesc,INGR_Loc_Dr RecLocId,INGR_StkType StkType,INGR_CreateDate CreateDate,"
		_"INGR_Date AuditDate,INGR_SCG_DR StkGrpId "
		_"FROM DHC_INGdRec "
		_"WHERE INGR_AuditFlag='Y' AND (INGR_CreateDate BETWEEN "_PStartDate_" AND "_PEndDate_") and INGR_Loc_Dr="_PRecLoc
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sqlStr)
	s sc=result.Execute()
	i $$$ISERR(sc) q $$$OK
	While(result.Next())
	{
		s IngrId = result.Data("Ingr")
		s StkType=result.Data("StkType")
		CONTINUE:StkType'=..sssCode()
		s IngrNo = result.Data("IngrNo")
		CONTINUE:(PRecNo'="")&(IngrNo'[PRecNo)
		s VendorId = result.Data("VendorId")
		CONTINUE:(PVendorId'="")&(VendorId'=PVendorId)
		s VendorDesc = result.Data("VendorDesc")
		s RecLocId = result.Data("RecLocId")
		s RecLocDesc = result.Data("RecLocDesc")
		s CreateDate=result.Data("CreateDate")
		s AuditDate=result.Data("AuditDate")
		s RecLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(RecLocDesc)
		s:VendorId'="" VendorDesc=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetDateVendor(CreateDate,VendorId)
		s StkGrpId=result.Data("StkGrpId")
		CONTINUE:(StkGrpId'="")&&(StkGrplist'="")&&(("^"_StkGrplist_"^")'[("^"_StkGrpId_"^"))	;按照人员类组过滤入库单
		s DocHVFlag=##class(web.DHCSTMHUI.Common.UtilCommon).GetCertDocHVFlag(IngrId,"G")
		CONTINUE:(PHVFlag'="")&&(DocHVFlag'=PHVFlag)
		s Chl=""
		s:PInci'="" Chl=$o(^DHCINGR(0,"INCI",PInci,IngrId,0))
		CONTINUE:(PInci'="")&(Chl="")
		s Ret=0
		s:PInciDesc'="" Ret=##class(web.DHCSTMHUI.DHCINGdRec).CheckInciDesc(IngrId,PInciDesc)
		CONTINUE:(PInciDesc'="")&&(Ret'=0)
		s:CreateDate'="" CreateDate=..DL2H(CreateDate)
		s:AuditDate'="" AuditDate=..DL2H(AuditDate)
		d OutPutRecMain
	}
	Quit $$$OK

OutPutRecMain
	s Data=$lb(IngrId,IngrNo,VendorId,VendorDesc,RecLocId,RecLocDesc,CreateDate,AuditDate)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	获取入库单明细信息
/// Creator:	wxj
/// CreateDate:	2022-09-01
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.RedOffset","GetRecDetail",^tempxj("GetRecDetail"))
Query GetRecDetail(MainIdStr As %String, Params As %String) As Query(ROWSPEC = "Ingri,Inci,InciCode,InciDesc,Spec,Model,BatNo,ExpDate,IngrUomId,IngrUomDesc,IngrQty:%Float,ManfId,ManfDesc,Rp:%Float,RpAmt:%Float")
{
}

ClassMethod GetRecDetailExecute(ByRef qHandle As %Binary, MainIdStr As %String, Params As %String) As %Status
{
	n (qHandle,MainIdStr,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	q:MainIdStr="" $$$OK
	s PInciDesc=PJObj.%Get("InciDesc")
	s PInci=PJObj.%Get("Inci")
	
	s len=$l(MainIdStr,"^")
	f i=1:1:len d
	.s Ingr=$p(MainIdStr,"^",i)
	.s ch=""
	.f  s ch=$o(^DHCINGR(Ingr,"GRI",ch)) q:ch=""  d
	..s Ingri=Ingr_"||"_ch
	..s IngriInfo=$g(^DHCINGR(Ingr,"GRI",ch))
	..s Inci=$p(IngriInfo,"^",25)
	..q:'$d(^INCI(Inci,1))||'$d(^INCI(Inci,2))||'$d(^INCI(Inci,3))
	..q:(PInci'="")&&(Inci'=PInci)
	..s BatNo=$p(IngriInfo,"^",13)
	..s ExpDate=$p(IngriInfo,"^",9)
	..s IngrQty=$p(IngriInfo,"^",4)
	..s IngrUomId=$p(IngriInfo,"^",10)
	..s ManfId=$p(IngriInfo,"^",29)
	..s Rp=$p(IngriInfo,"^",30)
	..s RpAmt=$p(IngriInfo,"^",31)
	..s InciCode=$p(^INCI(Inci,1),"^",1)
	..s InciDesc=$p(^INCI(Inci,1),"^",2)
	..s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
	..s Model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(Inci)
	..s IngrUomDesc=$p(^CT("UOM",IngrUomId),"^",2)
	..s ManfDesc=$s(ManfId'="":$p(^PHMNF(ManfId),"^",2),1:"")
	..s:ExpDate'="" ExpDate=..DL2H(ExpDate)
	..d OutPutRecDetail
	Quit $$$OK

OutPutRecDetail
	s Data=$lb(Ingri,Inci,InciCode,InciDesc,Spec,Model,BatNo,ExpDate,IngrUomId,IngrUomDesc,IngrQty,ManfId,ManfDesc,Rp,RpAmt)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	获取库存明细信息
/// Creator:	wxj
/// CreateDate:	2022-09-01
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.RedOffset","GetInitDetail","188||1")
Query GetInitDetail(IngriStr As %String) As Query(ROWSPEC = "Inclb,ToInclb,LocDesc,InciDesc,InclbAvaQty:%Float,UomId,UomDesc,OldRp:%Float,OldSp:%Float,StoreFlag,Ingri,Inci,Qty:%Float")
{
}

ClassMethod GetInitDetailExecute(ByRef qHandle As %Binary, IngriStr As %String) As %Status
{
	n (qHandle,IngriStr,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:IngriStr="" $$$OK
	s Pid=..NewPid()
	k ^TMPDHCSTM("RedInclbDetail",Pid)
	s len=$l(IngriStr,"^")
	f i=1:1:len d
	.s Ingri=$p(IngriStr,"^",i)
	.s Ingr=+Ingri
	.s Ingrch=$p(Ingri,"||",2)
	.s IngrLoc=$p(^DHCINGR(Ingr),"^",13)
	.s IngriInfo=$g(^DHCINGR(Ingr,"GRI",Ingrch))
	.s IngrUom=$p(IngriInfo,"^",10)
	.s OldRp=$p(IngriInfo,"^",30)
	.s OldSp=$p(IngriInfo,"^",32)
	.s Inclb=$p(^DHCINGR(+Ingri,"GRI",$p(Ingri,"||",2)),"^",1)
	.s FrInclbQty=$p(^INCI(+Inclb,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",2)
	.s FrDirtyQty=$p(^INCI(+Inclb,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",3)
	.s FrInclbAvaQty=FrInclbQty-FrDirtyQty
	.i '$d(^TMP("RedInclbDetail",Pid,IngrLoc,Inclb,"*")) d
	..s ^TMPDHCSTM("RedInclbDetail",Pid,IngrLoc,Inclb,"*")=FrInclbAvaQty_"^"_OldRp_"^"_OldSp_"^"_IngrUom_"^"_Ingri
	.e  d
	..s ^TMPDHCSTM("RedInclbDetail",Pid,IngrLoc,Inclb,"*")=FrInclbAvaQty+$p(^TMPDHCSTM("RedInclbDetail",Pid,IngrLoc,Inclb,"*"),"^",1)
	.s Init=""
	.f  s Init=$o(^DHCINIT(0,"INCLB",Inclb,Init)) q:Init=""  d
	..s ch=""
	..f  s ch=$o(^DHCINIT(0,"INCLB",Inclb,Init,ch)) q:ch=""  d
	...s Initi=Init_"||"_ch
	...s ToLocId=$p(^DHCINIT(Init),"^",6)
	...s InitInDate=$p(^DHCINIT(Init),"^",15)
	...s InitQty=$p(^DHCINIT(Init,"ITI",ch),"^",1)
	...s Intr=$o(^DHCINTR(0,"TypePointer","K",Initi,""))
	...q:+Intr'>0
	...s ToInclb=$p(^DHCINTR(Intr),"^",7)
	...s ToInclbQty=$p(^INCI(+ToInclb,"IL",$p(ToInclb,"||",2),"LB",$p(ToInclb,"||",3)),"^",2)
	...s ToDirtyQty=$p(^INCI(+ToInclb,"IL",$p(ToInclb,"||",2),"LB",$p(ToInclb,"||",3)),"^",3)
	...s ToInclbAvaQty=ToInclbQty-ToDirtyQty
	...i '$d(^TMP("RedInclbDetail",Pid,ToLocId,Inclb,ToInclb)) d
	....s ^TMPDHCSTM("RedInclbDetail",Pid,ToLocId,Inclb,ToInclb)=ToInclbAvaQty_"^"_OldRp_"^"_OldSp_"^"_IngrUom_"^"_Ingri
	.e  d
	....s ^TMPDHCSTM("RedInclbDetail",Pid,ToLocId,Inclb,ToInclb)=ToInclbAvaQty+$p(^TMPDHCSTM("RedInclbDetail",Pid,ToLocId,Inclb,ToInclb),"^",1)
	s LocId=""
	f  s LocId=$o(^TMPDHCSTM("RedInclbDetail",Pid,LocId)) q:LocId=""  d
	.s LocDesc=$p(^CTLOC(LocId),"^",2)
	.s Inclb=""
	.f  s Inclb=$o(^TMPDHCSTM("RedInclbDetail",Pid,LocId,Inclb)) q:Inclb=""  d
	..s ToLocInclb=""
	..f  s ToLocInclb=$o(^TMPDHCSTM("RedInclbDetail",Pid,LocId,Inclb,ToLocInclb)) q:ToLocInclb=""  d
	...s InclbAvaQty=$p(^TMPDHCSTM("RedInclbDetail",Pid,LocId,Inclb,ToLocInclb),"^",1)
	...q:InclbAvaQty'>0
	...s OldRp=$p(^TMPDHCSTM("RedInclbDetail",Pid,LocId,Inclb,ToLocInclb),"^",2)
	...s OldSp=$p(^TMPDHCSTM("RedInclbDetail",Pid,LocId,Inclb,ToLocInclb),"^",3)
	...s UomId=$p(^TMPDHCSTM("RedInclbDetail",Pid,LocId,Inclb,ToLocInclb),"^",4)
	...s Ingri=$p(^TMPDHCSTM("RedInclbDetail",Pid,LocId,Inclb,ToLocInclb),"^",5)
	...s StoreFlag="",ToInclb=ToLocInclb
	...s:ToLocInclb="*" StoreFlag="Y",ToInclb=""
	...s Inci=+Inclb
	...s InciDesc=$p(^INCI(Inci,1),"^",2)
	...s BUomId=$p(^INCI(Inci,1),"^",10)
	...s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
	...s InclbAvaQty=InclbAvaQty/UomFac
	...s Qty=InclbAvaQty ;红冲数量默认可用库存
	...s UomDesc =$p(^CT("UOM",UomId),"^",2)
	...d OutPutInitDetail
	k ^TMPDHCSTM("RedInclbDetail",Pid)
	Quit $$$OK

OutPutInitDetail
	s Data=$lb(Inclb,ToInclb,LocDesc,InciDesc,InclbAvaQty,UomId,UomDesc,OldRp,OldSp,StoreFlag,Ingri,Inci,Qty)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:   审核红冲单(Js调用)
/// Creator:   	wxj
/// CreateDate: 2022-09-05
/// w ##class(web.DHCSTMHUI.RedOffset).jsAudit(30,"{""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2"",""MENUID"":""60005""}")
ClassMethod jsAudit(RedIdStr, Params) As %Library.String
{
	n (RedIdStr,Params,%session)
	s RtnObj=##class(RtnObj).%New()
	s $ZT=..sssError()
	s del="^"
	s cnt=$l(RedIdStr,del)
	s ErrMsg="",Succnt=0,RowidStr=""
	f i=1:1:cnt d
	.s RedId=$p(RedIdStr,del,i)
	.s RtnObj=..Audit(RedId,Params)
	.i RtnObj.success=0 d
	..s Succnt=Succnt+1
	..i RowidStr="" d
	...s RowidStr= RedId
	..e  d
	...s RowidStr=RowidStr_"^"_RedId
	.e  d
	..s msginfo=RedId_":"_RtnObj.msg
	..i ErrMsg="" d
	...s ErrMsg= msginfo
	..e  d
	...s ErrMsg=ErrMsg_"#"_msginfo
	s RtnObj.rowid=RowidStr
	s RtnObj.msg=cnt_"@"_Succnt_"@"_ErrMsg
	s RtnObj.success=0
	q RtnObj.Json()
}

/// Descript:   审核红冲单
/// Creator:    wxj
/// CreateDate: 2022-09-05
/// w ##class(web.DHCSTMHUI.RedOffset).Audit(11,"{""RedLoc"":""163"",""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2""}")
ClassMethod Audit(RedId, Params) As RtnObj
{
	n (RedId,Params,%session)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0  q RtnObj.Err(-1,"","入参解析失败!","",0)
	s LocId=PJObj.%Get("RedLoc")
	s UserId=PJObj.%Get("gUserId")
	s HospId=PJObj.%Get("gHospId")
	s GroupId=PJObj.%Get("gGroupId")
	s gLocId=PJObj.%Get("gLocId")
	i ((RedId="")||('$d(^HRP.MAT.INGRRedOffsetD(RedId)))) q RtnObj.Err(-2,"","红冲单不存在!","",0)
	s CompFlag=$lg(^HRP.MAT.INGRRedOffsetD(RedId),8)
	i CompFlag'="Y" q RtnObj.Err(-3,"","红冲单尚未完成,不能审核!","",0)
	s AuditFlag=$lg(^HRP.MAT.INGRRedOffsetD(RedId),11)
	i AuditFlag="Y" q RtnObj.Err(-4,"","红冲单已审核!","",0)
	s RedNo=$lg(^HRP.MAT.INGRRedOffsetD(RedId),2)
	s RedVendor=$lg(^HRP.MAT.INGRRedOffsetD(RedId),3)
	s RedLoc=$lg(^HRP.MAT.INGRRedOffsetD(RedId),4)
	s Param=GroupId_"^"_LocId_"^"_UserId_"^"_HospId
	s AppName=..%GetParameter("AppName")	
	i ..sssLock(AppName_RedId)'=0 q RtnObj.Err(-99,"","加锁失败!")
	s CH=0
	ts
	s RetDetailArr=[],RecDetailArr=[]
	f  s CH=$o(^HRP.MAT.INGRRedOffsetD(RedId,"Itm",CH)) q:(CH="")||(RtnObj.success'=0)  d
	.s Pointer=RedId_"||"_CH
	.s RedOffsetList=^HRP.MAT.INGRRedOffsetD(RedId,"Itm",CH)
	.s Inclb=$lg(RedOffsetList,2)
	.s ToInclb=$lg(RedOffsetList,3)
	.s RedQty=$lg(RedOffsetList,4)
	.s RedUom=$lg(RedOffsetList,5)
	.s NewRp=+$lg(RedOffsetList,6)
	.s NewSp=+$lg(RedOffsetList,7)
	.s OldRp=+$lg(RedOffsetList,8)
	.s OldSp=+$lg(RedOffsetList,9)
	.s Ingri=$lg(RedOffsetList,10)
	.s Initi=$lg(RedOffsetList,11)
	.s StoreFlag=$lg(RedOffsetList,13)
	.s OldRpAmt=OldRp*RedQty
	.s OldSpAmt=OldSp*RedQty
	.s NewRpAmt=NewRp*RedQty
	.s NewSpAmt=NewSp*RedQty
	.s IncId=+Inclb
	.s BatExp=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(Inclb)
	.s BatchNo=$p(BatExp,"^",1)
	.s ExpDate=$p(BatExp,"^",2)
	.s ManfId=+##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb)
	.i StoreFlag'="Y" d
	..;自动退库
	..s ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(ToInclb,-RedQty)
	..i ret<0 d RtnObj.Err(-5,Pointer,":退库处理库存失败") q 
	..s TrData="RT"_"^"_RedNo_"^"_ToInclb_"^"_-RedQty_"^"_RedUom_"^"_OldSp
	..s TrData=TrData_"^"_UserId_"^"_Pointer_"^"_OldRp_"^"_OldRpAmt_"^"_OldSpAmt
	..s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(TrData)
	..i RtnObj.success'=0 d RtnObj.Err(-4,ToInclb,MethodName_":退库失败")
	.q:RtnObj.success'=0
	.i StoreFlag'="Y" d
	..;自动退库接收
	..s ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(Inclb,RedQty)
	..i ret<0 d RtnObj.Err(-6,Pointer,":退库处理库存失败") q 
	..s TrData="RK"_"^"_RedNo_"^"_Inclb_"^"_+RedQty_"^"_RedUom_"^"_OldSp
	..s TrData=TrData_"^"_UserId_"^"_Pointer_"^"_OldRp_"^"_OldRpAmt_"^"_OldSpAmt
	..s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(TrData)
	..i RtnObj.success'=0 d RtnObj.Err(-5,Inclb,MethodName_":退库接收失败")
	.q:RtnObj.success'=0
	.s RetDetailObj={}
	.d RetDetailObj.%Set("Ingri",Ingri)
	.d RetDetailObj.%Set("Uom",RedUom)
	.d RetDetailObj.%Set("Qty",RedQty)
	.d RetDetailObj.%Set("Rp",OldRp)
	.d RetDetailObj.%Set("Sp",OldSp)
	.d RetDetailObj.%Set("Inclb",Inclb)
	.d RetDetailArr.%Push(RetDetailObj)
	.s RecDetailObj={}
	.d RecDetailObj.%Set("IncId",IncId)
	.d RecDetailObj.%Set("BatchNo",BatchNo)
	.d RecDetailObj.%Set("ExpDate",ExpDate)
	.d RecDetailObj.%Set("ManfId",ManfId)
	.d RecDetailObj.%Set("IngrUomId",RedUom)
	.d RecDetailObj.%Set("RecQty",RedQty)
	.d RecDetailObj.%Set("Rp",NewRp)
	.d RecDetailObj.%Set("Sp",NewSp)
	.d RecDetailObj.%Set("RedItmId",Pointer)
	.d RecDetailArr.%Push(RecDetailObj)
	i RtnObj.success'=0  tro  q RtnObj
	;自动退货
	s RetDetail=RetDetailArr.%ToJSON()
	s RetMainObj="{""RetLoc"":"""_RedLoc_""",""Vendor"":"""_RedVendor_""",""gUserId"":"""_UserId_""",""gGroupId"":"""_GroupId_""",""gHospId"":"""_HospId_"""}"
	s RtnObj=##class(web.DHCSTMHUI.DHCINGdRet).Save(RetMainObj,RetDetail)
	i RtnObj.success'=0  tro  q RtnObj
	s RetId=RtnObj.rowid
	s RetAuditObj="{""RowId"":"""_RetId_""",""gUserId"":"""_UserId_"""}"
	s Params="{""gUserId"":"""_UserId_""",""gGroupId"":"""_GroupId_""",""gHospId"":"""_HospId_"""}"
	s AutoCompAfterSaveDRET=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTRETURNM","AutoCompAfterSaveDRET",Params)
	i AutoCompAfterSaveDRET'="Y" d
	.s RtnObj=##class(web.DHCSTMHUI.DHCINGdRet).SetCompleted(RetAuditObj)
	i RtnObj.success'=0  tro  q RtnObj
	s AutoAuditAfterCompDRET=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTRETURNM","AutoAuditAfterCompDRET",Params)
	i AutoAuditAfterCompDRET'="Y" d
	.s RtnObj =##class(web.DHCSTMHUI.DHCINGdRet).Audit(RetAuditObj)
	i RtnObj.success'=0  tro  q RtnObj
	;记录退货id到主表
	&sql(update HRP_MAT.INGRRedOffset set INGRRO_INGRT_DR=:RetId where %id=:RedId)
	;自动入库
	s RecMainObj="{""RecLoc"":"""_RedLoc_""",""ApcvmDr"":"""_RedVendor_""",""gUserId"":"""_UserId_""",""gGroupId"":"""_GroupId_""",""gHospId"":"""_HospId_"""}"
	s RecDetail=RecDetailArr.%ToJSON()
	s RtnObj=##class(web.DHCSTMHUI.DHCINGdRec).Save(RecMainObj,RecDetail)
	i RtnObj.success'=0  tro  q RtnObj
	s RecId=RtnObj.rowid
	s AutoCompAfterSaveIN=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTIMPORTM","AutoCompAfterSaveIN",Param)
	i AutoCompAfterSaveIN'="Y" d
	.s RtnObj=##class(web.DHCSTMHUI.DHCINGdRec).MakeComplete(RecId,Params)
	i RtnObj.success'=0  tro  q RtnObj
	s AutoAuditAfterComp=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTIMPORTM","AutoAuditAfterComp",Param)
	i AutoAuditAfterComp'="Y" d
	.s RtnObj=##class(web.DHCSTMHUI.DHCINGdRec).Audit(RecId,Params,GroupId)
	i RtnObj.success'=0 tro  q RtnObj
	;记录入库id到主表
	&sql(update HRP_MAT.INGRRedOffset set INGRRO_INGR_DR=:RecId where %id=:RedId)
	;自动出库
	s RtnObj=..CreateNewInit(RedId,UserId)
	i RtnObj.success'=0 tro  q RtnObj
	;更新红冲主表审核标志
	s AuditDate=+$h,AuditTime=$p($h,",",2)
	&sql(update HRP_MAT.INGRRedOffset set INGRRO_AuditFlag='Y',INGRRO_AuditUser=:UserId,INGRRO_AuditDate=:AuditDate,INGRRO_AuditTime=:AuditTime where %id=:RedId)
	tc
	q RtnObj
}

/// 自动出库
ClassMethod CreateNewInit(RedId, UserId) As RtnObj
{
	n (RedId,UserId,%session)
	s RtnObj=##class(RtnObj).%New()
	s RedNo=$lg(^HRP.MAT.INGRRedOffsetD(RedId),2)
	s CH=""
	f  s CH=$o(^HRP.MAT.INGRRedOffsetD(RedId,"Itm",CH)) q:(CH="")||(RtnObj.success'=0)  d
	.s Pointer=RedId_"||"_CH
	.s RedOffsetList=^HRP.MAT.INGRRedOffsetD(RedId,"Itm",CH)
	.s ToInclb=$lg(RedOffsetList,3)
	.s RedQty=$lg(RedOffsetList,4)
	.s RedUom=$lg(RedOffsetList,5)
	.s NewRp=+$lg(RedOffsetList,6)
	.s NewSp=+$lg(RedOffsetList,7)
	.s NewIngri=$lg(RedOffsetList,12)
	.q:+NewIngri'>0
	.s StoreFlag=$lg(RedOffsetList,13)
	.q:StoreFlag="Y"
	.s Ingr=+NewIngri
	.s Ingrch=$p(NewIngri,"||",2)
	.q:'$d(^DHCINGR(Ingr,"GRI",Ingrch))
	.s NewRpAmt=NewRp*RedQty
	.s NewSpAmt=NewSp*RedQty
	.s ProvInclb=$p(^DHCINGR(Ingr,"GRI",Ingrch),"^",1)
	.s NewInclb=..GetToLocInclb(ProvInclb,ToInclb)
	.q:+NewInclb'>0
	.;自动出库
	.s ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(ProvInclb,-RedQty)
	.i ret<0 d RtnObj.Err(-3,Pointer,MethodName_":出库处理库存失败") q 
	.s TrData="NT"_"^"_RedNo_"^"_ProvInclb_"^"_-RedQty_"^"_RedUom_"^"_NewSp
	.s TrData=TrData_"^"_UserId_"^"_Pointer_"^"_NewRp_"^"_NewRpAmt_"^"_NewSpAmt
	.s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(TrData)
	.i RtnObj.success'=0 d RtnObj.Err(-4,ProvInclb,MethodName_":出库失败")
	.q:RtnObj.success'=0
	.;自动出库接收
	.s ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(NewInclb,RedQty)
	.i ret<0 d RtnObj.Err(-3,Pointer,MethodName_":出库处理库存失败") q 
	.s TrData="NK"_"^"_RedNo_"^"_NewInclb_"^"_+RedQty_"^"_RedUom_"^"_NewSp
	.s TrData=TrData_"^"_UserId_"^"_Pointer_"^"_NewRp_"^"_NewRpAmt_"^"_NewSpAmt
	.s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(TrData)
	.i RtnObj.success'=0 d RtnObj.Err(-5,NewInclb,MethodName_":出库接收失败")
	.q:RtnObj.success'=0
	q RtnObj
}

ClassMethod GetToLocInclb(ProvInclb, ToInclb) As %String
{
	n (ProvInclb,ToInclb)
	s Inci=$p(ProvInclb,"||",1)
	s IncilSub=$p(ProvInclb,"||",2)
	s InclbSub=$p(ProvInclb,"||",3)
	q:'$d(^INCI(Inci,"IL",IncilSub,"LB",InclbSub)) -1
	s ToInci=$p(ToInclb,"||",1)
	s ToIncilSub=$p(ToInclb,"||",2)
	s ToInclbSub=$p(ToInclb,"||",3)
	q:'$d(^INCI(ToInci,"IL",ToIncilSub,"LB",ToInclbSub)) -1
	q:Inci'=ToInci -1
	s ToLoc=$p(^INCI(ToInci,"IL",ToIncilSub),"^",1)
	s Incib=$p(^INCI(Inci,"IL",IncilSub,"LB",InclbSub),"^",1)
	s Ibsub=$p(Incib,"||",2) 
	q:Ibsub="" -1
	q:($d(^INCI(Inci,"IB",Ibsub))=0)!($d(^INCI(Inci,"IB",Ibsub))=10) -1
	
	l +^DBLock($zn,Inci_"^"_ToLoc):10 e  q ""
	s Incil="",Inclb=""
	s Ilch=$O(^INCI("IL_LOC",ToLoc,Inci,""))
	i Ilch="" d
	.&sql(insert into inc_itmloc(incil_Inci_parref,incil_ctloc_dr)
		values (:Inci,:ToLoc) )
	.i SQLCODE=0 s incil=%ROWID  
	.s Ilch=$P(Incil,"||",2)
	e  d
	.s Incil=Inci_"||"_Ilch
	s Lb=$o(^INCI("LB_IB",Incib,Inci,Ilch,""))
	i Lb="" d
	.&sql(insert into INC_ItmLcBt (inclb_incil_parref,inclb_incib_dr)
		values(:Incil,:Incib) )
	.i SQLCODE=0 s Inclb=%ROWID
	e  d
	.s Inclb=Inci_"||"_Ilch_"||"_Lb

	l -^DBLock($zn,Inci_"^"_ToLoc)
	q Inclb
}

/// Descript:	查询红冲主表信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.RedOffset","Query","{""RedLoc"":""163"",""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2"",""MENUID"":""60005"",""StartDate"":""2022-08-16"",""CreateUser"":"""",""Vendor"":"""",""EndDate"":""2022-09-15"",""AuditFlag"":""N"",""InciDesc"":"""",""CompFlag"":""Y"",""Inci"":"""",""RedNo"":""""}")
Query Query(Params As %String) As Query(ROWSPEC = "RowId:%Integer,RedNo,RedLoc,Vendor,CreateUser,CreateDate,AuditUser,AuditDate,CompFlag,AuditFlag") [ SqlProc ]
{
}

ClassMethod QueryExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,%session,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	
	s PRowId=PJObj.%Get("RowId")
	s PRedLoc=PJObj.%Get("RedLoc")
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	s PCreateUser=PJObj.%Get("CreateUser")
	s PVendor=PJObj.%Get("Vendor")
	s PInci=PJObj.%Get("Inci")
	s PRedNo=PJObj.%Get("RedNo")
	s PAuditFlag=PJObj.%Get("AuditFlag")
	s PCompFlag=PJObj.%Get("CompFlag")	
	s PStartDate=..DH2L(PStartDate)
	s PEndDate=..DH2L(PEndDate)
	
	s SqlStr="SELECT ID, INGRRO_No, INGRRO_APCVM_DR, INGRRO_Loc_DR, INGRRO_CreateUser,"
		_"INGRRO_CreateDate,INGRRO_CreateTime,INGRRO_CompFlag,INGRRO_AuditFlag,"
		_"INGRRO_AuditUser,INGRRO_AuditDate,INGRRO_AuditTime"
		_" FROM HRP_MAT.INGRRedOffset where 1=1 "
	i PRowId'="" d
	.s SqlStr=SqlStr_" AND %ID="_PRowId
	e  d
	.s SqlStr=SqlStr_" and (INGRRO_CreateDate between "_PStartDate_" and "_PEndDate_") and INGRRO_Loc_DR="_PRedLoc
	s SqlStr=SqlStr_" Order by INGRRO_CreateDate Desc,INGRRO_CreateTime Desc"
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	s sc=Result.Execute()
	i $$$ISERR(sc) q $$$OK
	while (Result.Next())
	{
		s RowId=Result.Data("ID")
		s RedNo=Result.Data("INGRRO_No")
		s RedLocId=Result.Data("INGRRO_Loc_DR")
		s VendorId=Result.Data("INGRRO_APCVM_DR")
		s CreateUserId=Result.Data("INGRRO_CreateUser")		
		s CreateDate=Result.Data("INGRRO_CreateDate")
		s CreateTime=Result.Data("INGRRO_CreateTime")
		s CompFlag=Result.Data("INGRRO_CompFlag")
		s AuditFlag=Result.Data("INGRRO_AuditFlag")
		s AuditUserId=Result.Data("INGRRO_AuditUser")
		s AuditDate=Result.Data("INGRRO_AuditDate")
		s AuditTime=Result.Data("INGRRO_AuditTime")
		s:CompFlag="" CompFlag="N"
		s:AuditFlag="" AuditFlag="N"
		CONTINUE:(PRedNo'="")&(RedNo'[PRedNo)
		CONTINUE:(PVendor'="")&(VendorId'=PVendor)
		CONTINUE:(PCreateUser'="")&&(CreateUserId'=PCreateUser)
		CONTINUE:(PCompFlag'="")&(CompFlag'=PCompFlag)
		CONTINUE:(PAuditFlag'="")&(AuditFlag'=PAuditFlag)
		s (RedLoc,Vendor,CreateUser,AuditUser)=""
		s:RedLocId'="" RedLoc=$p(^CTLOC(RedLocId),"^",2)
		s:VendorId'="" Vendor=$p(^APC("APCVM",VendorId),"^",3)
		s:CreateUserId'="" CreateUser=$p(^SSU("SSUSR",CreateUserId),"^",2)
		s:CreateDate'="" CreateDate=..DL2H(CreateDate)
		s:AuditDate'="" AuditDate=..DL2H(AuditDate)
		s:AuditUserId'="" AuditUser=$p(^SSU("SSUSR",AuditUserId),"^",2)
		s:CreateTime'="" CreateTime=..TL2H(CreateTime)
		d OutPutRow
	}
	d Result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,RedNo,RedLoc,Vendor,CreateUser,
		CreateDate,AuditUser,AuditDate,CompFlag,AuditFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:删除红冲单(js调用)
/// w ##class(web.DHCSTMHUI.RedOffset).jsDelete(489)
ClassMethod jsDelete(RedId) As %Library.String
{
	n (RedId,%session)
	s RtnObj=##class(RtnObj).%New()
	s $ZT=..sssError()
	s RtnObj=..Delete(RedId)
	q RtnObj.Json()
}

/// Descript:	删除红冲单
///  w ##class(web.DHCSTMHUI.RedOffset).Delete(489)
ClassMethod Delete(RedId) As RtnObj
{
	n (RedId,%session)
	s RtnObj=##class(RtnObj).%New()
	i RedId=""  q RtnObj.Err(-1,"","请选择红冲单","",0)

	i '$d(^HRP.MAT.INGRRedOffsetD(RedId)) q RtnObj.Err(-2,"","红冲单不存在!","",0)
	s CompFlag=$lg(^HRP.MAT.INGRRedOffsetD(RedId),8)
	i CompFlag="Y" q RtnObj.Err(-3,"","红冲单已完成!","",0)
	s AuditFlag=$lg(^HRP.MAT.INGRRedOffsetD(RedId),11)
	i AuditFlag="Y" q RtnObj.Err(-4,"","红冲单已审核!","",0)
	
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("HRP_MAT.INGRRedOffset",RedId)
	&sql(Delete from HRP_MAT.INGRRedOffset where %ID=:RedId) 
	i SQLCODE'=0 d
	.d RtnObj.Err(-5,"","删除红冲单失败!")
	e  d
	.s RtnObj=##class(Log).SaveLog("HRP_MAT.INGRRedOffset","HRP.MAT.INGRRedOffset","红冲单",RedId,"","D",OldJsonStr)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

}
