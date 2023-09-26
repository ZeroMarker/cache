Import sqluser

Class web.CSSDHUI.CallBack.CallBackItm Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:lxt
/// CreatDate:2019.10.18
/// Description:根据主表rowid获取回收子表的数据列表
/// Table:CSSD_CallBackDetailNew
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.CallBack.CallBackItm","SelectByF","1")
Query SelectByF(MainId As %String, Sort As %String = "") As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,PackageDR,PackageName,LevelFlag,InfectFlag,Qty:%Float,PackageLabel,DictLabel,LabelQty,TotalPrice:%Float,PackTypeDetail,MaterialDr,MaterialDesc,Price:%Float,SterTypeColor,ApplyDetailDr,ReqQty:%Float,DispQty:%Float,PatientId,PatientName,oprDoctor,instNurse,circNurse,oprDt,OprRoomDesc,OprRoomNo,UseLocDesc,infectName,No,FrLocDesc") [ SqlProc ]
{
}

ClassMethod SelectByFExecute(ByRef qHandle As %Binary, MainId As %String, Sort As %String = "") As %Status
{
	n (%session,qHandle,MainId,Sort)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:MainId="" $$$OK
	
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT CSSDCD_Rowid As RowId,CSSDCD_Parref_DR AS MainId,CSSDCD_Package_DR As PkgId,CSSDCD_LevelFlag AS ReqLevel,CSSDCDP_BeInfected as InfectFlag,CSSDCD_Qty AS Qty,"
		_"CSSDCD_Material AS MaterialId,CSSDCD_Material->CSSDM_Desc as MaterialDesc,CSSDCD_Package_DR->CSSDP_UnitPrice as Price,"
		_"CSSDPC_PackageLabel AS Label,CSSDPC_DictLabel AS CodeDict,"
		_"CSSDCD_PackageApplyDetailDR AS ApplyItmId,CSSDCD_PackageApplyDetailDR->CSSDPAD_ReqQty as ApplyQty,"
		_"CSSDCD_DispQty AS DispQty "
		_" FROM CSSD_CallBackDetailNew "
		_"WHERE CSSDCD_Parref_DR in("_MainId_")"
	i Sort'="" s SqlStr=SqlStr_" order by CSSDCD_Rowid "_Sort
	
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{	
		s RowId = Result.Data("RowId")
		s MainId = Result.Data("MainId")
		s PkgId = Result.Data("PkgId")
		s ReqLevel = Result.Data("ReqLevel")
		s InfectFlag = Result.Data("InfectFlag")
		s Qty = Result.Data("Qty")
		s MaterialId = Result.Data("MaterialId")
		s MaterialDesc = Result.Data("MaterialDesc")
		s Price = Result.Data("Price")
		s Label = Result.Data("Label")
		s CodeDict = Result.Data("CodeDict")
		s ApplyItmId = Result.Data("ApplyItmId")
		s ApplyQty = Result.Data("ApplyQty")
		s DispQty = Result.Data("DispQty")
		s:ReqLevel="" ReqLevel=0
		s PkgObj = ##class(User.CSSDPackage).%OpenId(PkgId)
		continue:'$IsObject(PkgObj)
		s PkgDesc=PkgObj.CSSDPDesc
		s AttributeCode=PkgObj.CSSDPPackTypeDetail
		s TotalPrice = Qty*Price
		i AttributeCode="1" s PkgDesc=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetCodeDictName(CodeDict)
		s SterTypeInfo=##class(web.CSSDHUI.PackageInfo.Package).GetSterTypeInfo(PkgId)
		s SterTypeColor=$p(SterTypeInfo,"^",3)
		//关联的标签数（扫标签录入）
		&sql(SELECT count(1) into :LabelQty FROM CSSD_Trans where CSSDT_CallBackDetail_DR=:RowId)
		//手术室使用信息
		s (PatientId,PatientName,OprDoctorName,InstNurseName,CircNurseName,OprDT,OprRoomDesc,OprRoomNo,UseLocDesc,InfectDesc)=""
		s UseInfo=##Class(web.CSSDHUI.Stat.TransStat).GetPkgUseInfo(Label)
		i UseInfo'="" d
		.s PatientId=$p(UseInfo,"|",1)
		.s PatientName=$p(UseInfo,"|",2)
		.s OprDoctorName=$p(UseInfo,"|",3)
		.s InstNurseName=$p(UseInfo,"|",4)
		.s CircNurseName=$p(UseInfo,"|",5)
		.s OprDate=..DL2H($p(UseInfo,"|",6))
		.s OprTime=..TL2H($p(UseInfo,"|",11))
		.s OprDT=OprDate_" "_OprTime
		.s OprRoomDesc=$p(UseInfo,"|",7)
		.s OprRoomNo=$p(UseInfo,"|",8)
		.s UseLocDesc=$p(UseInfo,"|",9)
		.s InfectDesc=$p(UseInfo,"|",10)
		s MainObj=##class(User.CSSDPackageCallback).%OpenId(MainId)
		s No=MainObj.CSSDPCSerialNo
		s FrLocDesc=MainObj.CSSDPCFromLocDr.CTLOCDesc
		d OutPutRow
	}
	d Result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,PkgId,PkgDesc,ReqLevel,InfectFlag,Qty,Label,CodeDict,LabelQty,TotalPrice,
		AttributeCode,MaterialId,MaterialDesc,Price,SterTypeColor,
		ApplyItmId,ApplyQty,DispQty,
		PatientId,PatientName,OprDoctorName,InstNurseName,CircNurseName,OprDT,OprRoomDesc,OprRoomNo,UseLocDesc,InfectDesc,
		No,FrLocDesc
	)
	
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:lxt
/// CreatDate:2019.10.18
/// Description:删除回收明细
/// w ##class(web.CSSDHUI.CallBack.CallBackItm).jsDelete(^templxt("aaaa"))
ClassMethod jsDelete(Params) As %Library.String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!").Json()
	
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		continue:RowId=""
		s CBItmObj=##class(User.CSSDCallbackDetailNew).%OpenId(RowId)
		continue:'$IsObject(CBItmObj)
		s RtnObj=..Delete(RowId)
		q:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:lxt
ClassMethod Delete(RowId As %String) As web.CSSDHUI.RtnObj
{
	n (%session,RowId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	q:RowId="" RtnObj.Err(-1,"","入参不能为空!")
	
	s CBItmObj=##Class(User.CSSDCallbackDetailNew).%OpenId(RowId)
	i '$IsObject(CBItmObj) d RtnObj.Err(-2,"","明细不存在!")
	q:RtnObj.success'=0 RtnObj
	d CBItmObj.%Reload()
	
	s Qty=CBItmObj.CSSDCDQty
	s Label=CBItmObj.CSSDPCPackageLabel
	s ApplyItmObj=CBItmObj.CSSDCDPackageApplyDetailDR
	s CBMainObj=CBItmObj.CSSDCDParref
	i '$IsObject(CBMainObj) d RtnObj.Err(-2,"","单据不存在!")
	q:RtnObj.success'=0 RtnObj
	
	s CompFlag=CBMainObj.CSSDPCComplateFlag
	s MainId=CBMainObj.%Id()
	s FrLocId=CBMainObj.CSSDPCFromLocDrGetObjectId()
	s ToLocId=CBMainObj.CSSDPCToLocDrGetObjectId()
	q:CompFlag'="N" RtnObj.Err(-1,"","已提交不能删除")
	
	s PkgId=CBItmObj.CSSDCDPackageDrGetObjectId()
	s CodeDict=CBItmObj.CSSDPCDictLabel
	s IsExit=##class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PkgId)
	
	s Str=""
	i IsExit="Y" d
	.s ItemId=""
	.f  s ItemId=$o(^User.CSSDCallbackDetailNewI("CSSDPCDictLabelIndex",CodeDict,ItemId)) q:ItemId=""  d
	..i Str="" s Str=ItemId
	..e  s Str=ItemId_","_Str
	..
	..&sql(Delete From CSSD_CallBackDetailNew WHERE CSSDCD_Rowid=:ItemId)
	..i SQLCODE<0 d RtnObj.Err(-2,"","删除回收明细失败!")
	e  d
	.&sql(Delete From CSSD_CallBackDetailNew WHERE CSSDCD_Rowid=:RowId)
	.i SQLCODE<0 d RtnObj.Err(-2,"","删除回收明细失败!")
	q:RtnObj.success'=0 RtnObj
	
	i Str="" s Str=RowId
	//更新申请
	i $IsObject(ApplyItmObj) d
	.s ApplyItmId=ApplyItmObj.%Id()
	.s BackQty=ApplyItmObj.CSSDPADBackQty
	.s BackQty=BackQty-Qty
	.&sql(Update CSSD_PackageApplyDetail set CSSDPAD_BackQty=:BackQty where ID=:ApplyItmId)
	.i SQLCODE'=0 d RtnObj.Err(-3,"","更新回收申请数量失败!"_SQLCODE) q
	q:RtnObj.success'=0 RtnObj
	
	//更新回收单紧急标志
	s RtnObj=##class(web.CSSDHUI.CallBack.CallBack).UpdateCBMainUrgent(MainId)
	q:RtnObj.success'=0 RtnObj
	
	s Length=$L(Str,",")
	f j=1:1:Length d
	.s Id=$p(Str,",",j)
	.s TransId=0
	.f  s TransId=$o(^User.CSSDTransI("CallBackItm",Id,"")) q:TransId=""  d
	..s TransObj=##class(User.CSSDTrans).%OpenId(TransId)
	..s Label=TransObj.CSSDTLabel
	..s ExpDealDate=TransObj.CSSDTExpDealDate
	..s useinfo=##Class(web.CSSDHUI.Stat.TransStat).GetPkgUseInfo(Label)
	..s UpdateStatus="R"
	..i ExpDealDate'="" s UpdateStatus="TC"
	..e  i useinfo'="" s UpdateStatus="U"
	..&sql(update cssd_trans set cssdt_status=:UpdateStatus,CSSDT_CallBackDetail_DR=NULL,
		CSSDT_CallBack_DR=NULL,CSSDT_CurrLoc_DR=:FrLocId where cssdt_label=:Label)
	..i SQLCODE'=0 d RtnObj.Err(-5,"","更新追踪表失败")
	..s ExtRowid=$o(^User.CSSDExtCallBackLabelI("CSSDECLLabelCallBackDrIndex",Label,Id,""))
	..i ExtRowid'="" d
	...&sql(DELETE FROM CSSD_ExtCallBackLabel WHERE CSSDECL_Rowid =:ExtRowid)
	...i SQLCODE'=0 d RtnObj.Err(-5,"","删除外来器械回收明细数据失败！")
	...q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Creator:lxt
/// CreatDate:2019.10.18
/// Description:保存回收单明细
/// Table:CSSD_CallBackDetailNew,CSSD_PackageApplyDetail
/// w ##class(web.CSSDHUI.CallBack.CallBackItm).jsSave(^templxt("jsSave1"),^templxt("jsSave2"))
ClassMethod jsSave(MainId As %String, Params As %String) As %Library.String
{
	n (%session,MainId,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..Save(MainId,Params)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:lxt
/// 保存前端不允许调用
ClassMethod Save(MainId As %String, Params As %String) As web.CSSDHUI.RtnObj
{
	n (%session,MainId,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	q:((MainId="")||(Params="")) RtnObj.Err(-1,"","入参不能为空!")
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-2,"","入参解析失败!")
	
	s MainObj=##class(User.CSSDPackageCallback).%OpenId(MainId)
	q:'$IsObject(MainObj) RtnObj.Err(-1,"","回收单不存在！")
	
	s CompFlag=MainObj.CSSDPCComplateFlag
	q:CompFlag'="N" RtnObj.Err(-2,"","已完成不能保存！","",0)
	
	s FrLocId=MainObj.CSSDPCFromLocDrGetObjectId()
	s ToLocId=MainObj.CSSDPCToLocDrGetObjectId()
	
	s MainReqLevel=0
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s PkgId=Obj.%Get("PackageDR")
		s Qty=Obj.%Get("Qty")
		s PkgLabel=Obj.%Get("PackageLabel")
		s CodeDict=Obj.%Get("DictLabel")
		s ApplyItmId=Obj.%Get("ApplyDetailDr")
		s MaterialId=Obj.%Get("MaterialDr")
		s ReqLevel=Obj.%Get("ReqLevel")
		s InfectFlag=Obj.%Get("InfectFlag")
		s:ReqLevel="" ReqLevel=0
		s:InfectFlag="" InfectFlag="N"
		s:ReqLevel=1 MainReqLevel=1
		i ((Qty=0)||(Qty<0)) d RtnObj.Err(-5,"","回收数量必须大于0!")
		continue:RtnObj.success'=0
		
		i ApplyItmId'="" d
		.s ApplyItmObj=##class(User.CSSDPackageApplyDetail).%OpenId(ApplyItmId)
		.d ApplyItmObj.%Reload()
		.s ApplyPkgId=ApplyItmObj.CSSDPADPackageDr.%Id()
		.s ApplyInfectFlag=ApplyItmObj.CSSDPADBeInfected
		.s InfectFlag=ApplyInfectFlag
		.i PkgId'=ApplyPkgId d RtnObj.Err(-6,"","请删除重新添加") q
		.s Backqty=ApplyItmObj.CSSDPADBackQty
		.s Reqty=ApplyItmObj.CSSDPADReqQty
		.s SumQty=0
		.s CBItmId=""
		.f  s CBItmId=$o(^User.CSSDCallbackDetailNewI("CSSDCDPackageApplyDetailDRIndex",ApplyItmId,CBItmId)) q:CBItmId=""  d
		..q:(RowId'="")&&(RowId=CBItmId)
		..s CBItmQty=$List((^User.CSSDCallbackDetailNewD(CBItmId)),4)
		..s SumQty=SumQty+CBItmQty
		.i Qty>(Reqty-SumQty) d RtnObj.Err(-8,"","回收数量不能大于请领数量!") q
		.s TotalQty=SumQty+Qty
		.&sql(Update CSSD_PackageApplyDetail set CSSDPAD_BackQty=:TotalQty where ID=:ApplyItmId)
		.i SQLCODE'=0 d RtnObj.Err(-10,"","更新申请单回收数量失败!") q
		continue:RtnObj.success'=0
		
		s MatInfo=##class(web.CSSDHUI.Common.PackageInfoCommon).GetMaterialExpireLength(MaterialId,PkgId)
		s Price=$p(MatInfo,"^",2)
	
		i RowId="" d
		.s ItmObj=##class(User.CSSDCallbackDetailNew).%New()
		e  d
		.s ItmObj=##class(User.CSSDCallbackDetailNew).%OpenId(RowId)
		d ItmObj.CSSDCDParrefSetObjectId(MainId)
		d ItmObj.CSSDCDPackageDrSetObjectId(PkgId)
		d ItmObj.CSSDCDMaterialSetObjectId(MaterialId)
		s ItmObj.CSSDCDQty=Qty
		s ItmObj.CSSDCDDispQty=0
		s ItmObj.CSSDCDPrice=Price
		s ItmObj.CSSDPCPackageLabel=PkgLabel
		s ItmObj.CSSDPCDictLabel=CodeDict
		s ItmObj.CSSDCDLevelFlag=ReqLevel
		d ItmObj.CSSDCDPackageApplyDetailDRSetObjectId(ApplyItmId)
		s ItmObj.CSSDCDPBeInfected=InfectFlag
		s Sc=ItmObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-5,"",$ClassName()_"jsSave:保存失败!")
		continue:RtnObj.success'=0
		s CBItmId=ItmObj.%Id()
		
		s Label=CodeDict
		s:Label="" Label=PkgLabel
		i Label'="" d
		.s LabelInfo=##class(web.CSSDHUI.Common.PackageInfoCommon).GetLabel(Label)
		.s CodeDict=$p(LabelInfo,"^",1)
		.s PackTypeDetail=$p(LabelInfo,"^",2)
		.s TmpRowId=""
		.i PackTypeDetail=1 d
		..s CodeLength=$l(CodeDict)
		..&sql(select max(cssdt_rowid) into :TmpRowId from cssd_trans where substr(cssdt_label,1,:CodeLength)=:CodeDict)
		.e  d
		..&sql(select max(cssdt_rowid) into :TmpRowId from cssd_trans where cssdt_label=:Label)
		.q:TmpRowId=""
		.s TransObj=##Class(User.CSSDTrans).%OpenId(TmpRowId)
		.s TransLabel=TransObj.CSSDTLabel
		.s DispId=TransObj.CSSDTDispGetObjectId()
		.s TrfId=TransObj.CSSDTTrfDRGetObjectId()
		.s Status=TransObj.CSSDTStatus
		.i TrfId'="" s DispId=TrfId	//先判断调拨类型发放单
		.s TransCBItm=TransObj.CSSDTCallBackDetailGetObjectId()
		.i TransCBItm'="" d RtnObj.Err(-3,"","已回收")
		.q:RtnObj.success'=0
		.i ((Status'="R")&&(Status'="U")&&(Status'="TC")) d
		..d RtnObj.Err(-3,"","标签当前不是接收、使用、过期处理状态，不能回收！")
		.q:RtnObj.success'=0
		.i DispId'="" d
		..s DispObj=##class(User.CSSDPackageDisp).%OpenId(DispId)
		..s DispToLocId=DispObj.CSSDPDToLocDrGetObjectId()
		..i (FrLocId'="")&&(DispToLocId'="")&&(FrLocId'=DispToLocId) d RtnObj.Err(-1,"","回收科室与标签所在科室不符")
		.q:RtnObj.success'=0
		.//更新跟踪表
		.&sql(UPDATE CSSD_Trans SET CSSDT_CallBack_DR=:MainId,
			CSSDT_CallBackDetail_DR=:CBItmId,CSSDT_Status='C',CSSDT_CurrLoc_DR=:ToLocId 
			WHERE CSSDT_Label=:TransLabel)
		.i SQLCODE'=0 d RtnObj.Err(-3,"","更新追踪信息数据失败！")
		.q:RtnObj.success'=0
		continue:RtnObj.success'=0
	}
	q:RtnObj.success'=0 RtnObj
	
	s RtnObj=##class(web.CSSDHUI.CallBack.CallBack).UpdateCBMainUrgent(MainId)
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Creator:wb
/// CreatDate:2019.12.5
/// Description:根据标签获取明细信息
/// Table:CSSD_PackageItem,CSSD_ConsumeDetail
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.CallBack.CallBackItm","SelectByLabel","436","")
Query SelectByLabel(PackageRowId As %String, PackageLabel As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,itmDr,Desc,Spec,Qty:%Integer,SerialNo:%Integer,ConsumeQty,ConsumeReasonDR,ConsumeReasonName,NotUseFlag,Remarks,OneOffFlag") [ SqlProc ]
{
}

ClassMethod SelectByLabelExecute(ByRef qHandle As %Binary, PackageRowId As %String, PackageLabel As %String) As %Status
{
	n (%session,qHandle,PackageRowId,PackageLabel)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:PackageRowId="" $$$OK
	s Result=##class(%Library.ResultSet).%New()
	s ExtDev="",ExtDetailId=""
	i PackageLabel'="" d
	.s FixedLabel=##class(web.CSSDHUI.Common.PackageInfoCommon).GetFixedLabel(PackageLabel)
	.s CodeLength=$l(FixedLabel)
	.s ExtDev=$o(^User.CSSDExtDevBindI("IndexCSSDExtLabel",$e(PackageLabel,1,CodeLength+6),0))	//判断条码是否在外来器械登记表中
	.i ExtDev'="" d
	..&sql(SELECT CSSDEBD_Rowid into:ExtDetailId from CSSD_ExtDevBindDetail WHERE CSSDEBD_Parref_DR=:ExtDev)
	i ExtDetailId="" d
	.s SqlStr = "SELECT ID As RowId ,CSSDPI_Itm_DR As Itm ,CSSDPI_Qty As Qty From CSSD_PackageItem where CSSDPI_Package_DR = "_PackageRowId_" "
	e  d
	.s SqlStr = "SELECT CSSDEBD_Rowid As RowId ,CSSDEBD_Itm_DR As Itm,CSSDEBD_Qty As Qty From CSSD_ExtDevBindDetail where CSSDEBD_Label = '"_PackageLabel_"' "
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{	
		s RowId = Result.Data("RowId")
		s itmDr = Result.Data("Itm")
		s Qty = Result.Data("Qty")
		s SerialNo = ""
		s Desc=$lg(^User.CSSDItemD(itmDr),2)
		s Spec=$lg(^User.CSSDItemD(itmDr),3)
		s Remarks=$lg(^User.CSSDItemD(itmDr),6)
		s OneOffFlag=$lg(^User.CSSDItemD(itmDr),9)
		s (ConsumeQty,ConsumeReasonDR)=""
		&sql(SELECT CSSDCD_ConsumeQty,CSSDCD_ConsumeReason_DR INTO ConsumeQty,ConsumeReasonDR FROM CSSD_ConsumeDetail WHERE CSSDCD_Label=:PackageLabel AND CSSDCD_Itm_DR=:itmDr)
		i ConsumeReasonDR="" s NotUseFlag=""
		e  s NotUseFlag=$lg(^User.CSSDMachineConsumeReasonD(ConsumeReasonDR),4)
		s ConsumeReasonName=""
		i ConsumeReasonDR'="" s ConsumeReasonName=$lg(^User.CSSDMachineConsumeReasonD(ConsumeReasonDR),3)
		d OutPutPackageItmRow
	}
	d Result.Close()
	Quit $$$OK
OutPutPackageItmRow
	s Data=$lb(RowId,itmDr,Desc,Spec,Qty,SerialNo,ConsumeQty,ConsumeReasonDR,ConsumeReasonName,NotUseFlag,Remarks,OneOffFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:wb
/// CreatDate:2019.12.5
/// Description:添加消毒包中的明细jsAddConsume
/// Table:CSSD_ConsumeDetail
/// w ##class(web.CSSDHUI.CallBack.CallBackItm).jsAddConsume()
ClassMethod jsAddConsume(Params As %String, PackageLabel As %String, LocDr As %String, CallBackDr) As %Library.String
{
	n (%session,Params,PackageLabel,LocDr,CallBackDr)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s RtnObj=..AddConsume(Params,PackageLabel,LocDr,CallBackDr)
	q RtnObj.Json()
}

ClassMethod AddConsume(Params As %String, PackageLabel As %String, LocDr As %String, CallBackDr) As web.CSSDHUI.RtnObj
{
	n (%session,Params,PackageLabel,LocDr,CallBackDr)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i PackageLabel="" d RtnObj.Err(-1,"","器械第一次使用，不做报损登记!")
	q:RtnObj.success'=0 RtnObj
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","参数解析错误")
	q:RtnObj.success'=0 RtnObj
	
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s itmDr=Obj.%Get("itmDr")
		s Qty=Obj.%Get("Qty")
		s ConsumeQty=Obj.%Get("ConsumeQty")
		continue:ConsumeQty=""
		s ConsumeReasonDR=Obj.%Get("ConsumeReasonDR")
		s PConsumeReasonDR=""
		s PConsumeReasonDR=$o(^User.CSSDConsumeDetailI("CSSDCDLabelItmIndex",PackageLabel,itmDr,""))
		i PConsumeReasonDR="" d
		.&sql(Insert into CSSD_ConsumeDetail(CSSDCD_Callback_Dr,CSSDCD_Label,CSSDCD_Itm_DR,CSSDCD_ConsumeQty,CSSDCD_ConsumeReason_DR,CSSDCD_Loc_DR) values(:CallBackDr,:PackageLabel,:itmDr,:ConsumeQty,:ConsumeReasonDR,:LocDr))
		.i SQLCODE'=0 d RtnObj.Err(-2,"",$ClassName()_"jsAddConsume:保存失败!") q
		e  d
		.&sql(update CSSD_ConsumeDetail set CSSDCD_ConsumeQty=:ConsumeQty,CSSDCD_ConsumeReason_DR=:ConsumeReasonDR where CSSDCD_Label=:PackageLabel AND CSSDCD_Itm_DR=:itmDr)
		.i SQLCODE'=0 d RtnObj.Err(-3,"",$ClassName()_"jsAddConsume:修改失败!") q
		continue:RtnObj.success'=0
		i ConsumeQty>Qty d RtnObj.Err(-4,"","缺少数量不能大于总数量!")
		continue:RtnObj.success'=0
	}
	
	i RtnObj.success<0 tro  q RtnObj
	tc
	q RtnObj
}

/// Creator:wb
/// CreatDate:2020.4.7
/// Description:保存回收单明细(借包单用)
/// Table:CSSD_CallBackDetailNew,CSSD_PackageApplyDetail
/// d ##class(web.CSSDHUI.CallBack.CallBackItm).SaveByBorrow()
ClassMethod SaveByBorrow(CallBackMainId, ApplyMainId, ReqLevel) As web.CSSDHUI.RtnObj
{
	n (%session,CallBackMainId,ApplyMainId,ReqLevel)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i ((CallBackMainId="")||(ApplyMainId="")) d RtnObj.Err(-1,"","入参不能为空！")
	q:RtnObj.success'=0 RtnObj
	s ApplyDetail=0
	f  s ApplyDetail=$o(^User.CSSDPackageApplyDetailI("CSSDPADParrefIndex",ApplyMainId,ApplyDetail)) q:((ApplyDetail="")||(RtnObj.success'=0))  d
	.s ApplyDetailObj=##Class(User.CSSDPackageApplyDetail).%OpenId(ApplyDetail)
	.d ApplyDetailObj.%Reload()
	.s PackageObj = ApplyDetailObj.CSSDPADPackageDr
	.s PkgId=PackageObj.%Id()
	.s MaterialObj = ApplyDetailObj.CSSDPADMaterialDR
	.s Qty = ApplyDetailObj.CSSDPADReqQty
	.q:'$IsObject(ApplyDetailObj)
	.s Price=""
	.i $IsObject(MaterialObj) d
	..s MaterialId=MaterialObj.%Id()
	..s MaterialInfo=##class(web.CSSDHUI.Common.PackageInfoCommon).GetMaterialExpireLength(MaterialId,PkgId)
	..s Price=$p(MaterialInfo,"^",2)
	.s itmobj=##class(User.CSSDCallbackDetailNew).%New()
	.d itmobj.CSSDCDParrefSetObjectId(CallBackMainId)
	.s itmobj.CSSDCDPackageDr=PackageObj
	.s itmobj.CSSDCDMaterial=MaterialObj
	.s itmobj.CSSDCDQty=Qty
	.s itmobj.CSSDCDDispQty=0
	.s itmobj.CSSDCDPrice=Price
	.s itmobj.CSSDCDLevelFlag=ReqLevel
	.d itmobj.CSSDCDPackageApplyDetailDRSetObjectId(ApplyDetail)
	.s Sc=itmobj.%Save()
	.i $$$ISERR(Sc) d RtnObj.Err(-5,"",$ClassName()_"jsSave:保存失败!")
	.q:RtnObj.success'=0	
	i RtnObj.success'=0 q RtnObj

	q RtnObj
}

/// Creator:lxt
/// CreatDate:2021.10.18
/// Description:回收时候紧急标牌追溯包
/// Table:CSSD_ConsumeDetail
/// w ##class(web.CSSDHUI.CallBack.CallBackItm).jsUrgent("{""RowId"":""125"",""PackageDR"":""3"",""PackageName"":""标牌追溯包1007"",""MaterialDr"":""5"",""MaterialDesc"":""无纺布"",""Qty"":""1"",""PackageLabel"":"""",""DictLabel"":""100003007"",""ApplyDetailDr"":"""",""oprDoctor"":"""",""instNurse"":"""",""circNurse"":"""",""infectName"":"""",""oprDt"":"""",""ReqQty"":"""",""DispQty"":""0"",""Price"":""3"",""TotalPrice"":""3"",""LevelFlag"":"""",""SterTypeColor"":""""}")
ClassMethod jsUrgent(Params As %String, Flag As %String) As %Library.String
{
	n (%session,Params,Flag)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!").Json()
	
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		continue:RowId=""
		s RtnObj=..Urgent(RowId,Flag)
		q:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:lxt
/// Input:Flag Y-紧急 N-取消紧急
ClassMethod Urgent(RowId As %String, Flag As %String) As web.CSSDHUI.RtnObj
{
	n (%session,RowId,Flag)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	q:RowId="" RtnObj.Err(-1,"","入参不能为空!")
	
	s CBDetailObj=##class(User.CSSDCallbackDetailNew).%OpenId(RowId)
	d CBDetailObj.%Reload()
	q:'$IsObject(CBDetailObj) RtnObj.Err(-1,"","明细不存在")
	
	s MainId=$lg(^User.CSSDCallbackDetailNewD(RowId),2)
	s CompFlag=$lg(^User.CSSDPackageCallbackD(MainId),14)
	q:CompFlag="Y" RtnObj.Err(-2,"","单据已经提交")
	
	i Flag="N" s NewLevel=0
	e  s NewLevel=1
	&sql(update CSSD_CallBackDetailNew set CSSDCD_LevelFlag=:NewLevel where CSSDCD_Rowid=:RowId)
	i SQLCODE'=0 d RtnObj.Err(-3,"","更新子表失败")
	q:RtnObj.success'=0 RtnObj
	
	s RtnObj=##class(web.CSSDHUI.CallBack.CallBack).UpdateCBMainUrgent(MainId)
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Creator:lxt
ClassMethod jsInfect(Params As %String, Flag As %String) As %Library.String
{
	n (%session,Params,Flag)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!").Json()
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		continue:RowId=""
		s RtnObj=..Infect(RowId,Flag)
		q:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:lxt
ClassMethod Infect(RowId As %String, Flag As %String) As web.CSSDHUI.RtnObj
{
	n (%session,RowId,Flag)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	q:RowId="" RtnObj.Err(-1,"","入参不能为空!")
	
	s CBDetailObj=##class(User.CSSDCallbackDetailNew).%OpenId(RowId)
	d CBDetailObj.%Reload()
	q:'$IsObject(CBDetailObj) RtnObj.Err(-1,"","明细不存在")
	
	s MainId=$lg(^User.CSSDCallbackDetailNewD(RowId),2)
	s CompFlag=$lg(^User.CSSDPackageCallbackD(MainId),14)
	q:CompFlag="Y" RtnObj.Err(-2,"","单据已经提交")
	
	i Flag="N" s NewInfect="N"
	e  s NewInfect="Y"
	&sql(update CSSD_CallBackDetailNew set CSSDCDP_BeInfected=:NewInfect where CSSDCD_Rowid=:RowId)
	i SQLCODE'=0 d RtnObj.Err(-3,"","更新子表失败")
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Creator:ljl
/// CreatDate:2023-3-31
/// Description:回收制单页面:查询待回收的标牌(R、U、TC状态）
/// Table:CSSD_Trans
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.CallBack.CallBackItm","UnCallBackCodeDict",^templxt("un"))
Query UnCallBackCodeDict(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "CodeDict,CodeDictDesc,Status,StatusDesc,CurLocDesc,Label") [ SqlProc ]
{
}

ClassMethod UnCallBackCodeDictExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (%session,Params,qHandle)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 $$$OK
	s gHospId=PJObj.%Get("gHospId")
	s gLocId=PJObj.%Get("gLocId")
	s gUserId=PJObj.%Get("gUserId")
	
	s CodeDictId=""
	f  s CodeDictId=$o(^User.CSSDTransI("CodeDictDR",CodeDictId),-1) q:CodeDictId=""  d
	.s ShowDataFlag=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_CodeDict",CodeDictId,gHospId)
	.q:ShowDataFlag="N"
	.s TransId=$o(^User.CSSDTransI("CodeDictDR",CodeDictId,""),-1)
	.
	.s TransObj=##class(User.CSSDTrans).%OpenId(TransId)
	.d TransObj.%Reload()
	.q:TransObj=""
	.s Label=TransObj.CSSDTLabel
	.s AttributeId=TransObj.CSSDTPackage.CSSDPPackTypeDetail
	.s Status=TransObj.CSSDTStatus
	.s DispObj=TransObj.CSSDTDisp
	.s PackObj=TransObj.CSSDTPack
	.s PackLocId=PackObj.CSSDPPLocDrGetObjectId()
	.s PkgId=TransObj.CSSDTPackageGetObjectId()
	.q:AttributeId'="1"
	.q:(Status'="R")&&(Status'="U")&&(Status'="TC")
	.
	.i $IsObject(DispObj) d
	..s CurLocId=DispObj.CSSDPDParrefDr.CSSDPDMToLocDrGetObjectId()
	.e  d
	..s CurLocId=PackLocId
	.s CurLocDesc=$p(^CTLOC(CurLocId),"^",2)
	.
	.s StatusDesc=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetStatusChinese(Status)
	.s CodeDict=##class(web.CSSDHUI.Common.PackageInfoCommon).GetFixedLabel(Label)
	.s CodeDictDesc=##class(web.CSSDHUI.Common.PackageInfoCommon).GetCodeDictName(CodeDict)
	.
	.;外来器械控制同一标牌的所有标签都接收再在弹框显示
	.s flag="0"
	.s IsExt=##class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PkgId)
	.i IsExt="Y" d
	..s ItemRowId=0
	..s CodeLength=$l(CodeDict)
	..s NewLabel=$e(Label,1,CodeLength+6)	;标牌编码号加上6位流水号
	..f  s ItemRowId=$o(^User.CSSDPackagePackI("CSSDPPNewLabelIndex",NewLabel,ItemRowId)) q:((ItemRowId="")||(flag="1"))  d
	...s ItemObj=##Class(User.CSSDPackagePack).%OpenId(ItemRowId)
	...s PkgLabel=ItemObj.CSSDPPLabel
	...s Id=$o(^User.CSSDTransI("CSSDTLabel",PkgLabel,0))
	...s PkgStatus=##class(User.CSSDTrans).%OpenId(Id).CSSDTStatus
	...i (PkgStatus'="R")&&(PkgStatus'="U")&&(PkgStatus'="TC") s flag="1"
	.q:flag="1"
	.
	.d OutPutRow1
	
	q $$$OK	
OutPutRow1
	s Data=$lb(CodeDict,CodeDictDesc,Status,StatusDesc,CurLocDesc,Label)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
