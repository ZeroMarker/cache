Import sqluser

/// wfg
/// 2019-6-19
/// 回收相关
Class web.CSSDHUI.CallBack.CallBack Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:lxt
/// CreatDate:20221214
/// Description:回收查询方法
/// Table:CSSD_PackageCallback
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.CallBack.CallBack","SelectAll","",34)
Query SelectAll(Params As %String = "", ID = "") As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,No,CBDate,CBTime,CBDateTime,ToLocId,ToLocDesc,FroLocDR,FroLocDesc,ToUserId,ToUser,AckDate,AckTime,AckDT,AckUser,AckUserDesc,ComplateFlag,OPRFlag,ReqLevel,BeInfected,Remark,ApplyId,ApplyUserName,ApplyDateTime,ApplyNo") [ SqlProc ]
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary, Params As %String = "", ID = "") As %Status
{
	n (%session,qHandle,Params,ID)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 $$$OK
	
	s PCBNo=PJObj.%Get("FReqNo")
	s PReqLocId=PJObj.%Get("ReqLoc")
	s PSupLocId=PJObj.%Get("SupLoc")
	s PToUserId=PJObj.%Get("toUser")
	s PStatus=PJObj.%Get("FStatus")
	s PStartDate=PJObj.%Get("FStartDate")
	s PEndDate=PJObj.%Get("FEndDate")
	s PStartTime=PJObj.%Get("FStartTime")
	s PEndTime=PJObj.%Get("FEndTime")
	s PFloorCodeId=PJObj.%Get("FloorCode")
	s LineCodeId=PJObj.%Get("LineCode")
	s PRowIdStr=PJObj.%Get("RowIdStr")
	s POPRFlag=PJObj.%Get("FIsOPRFlag")
	s gHospId=PJObj.%Get("gHospId")
	s gLocId=PJObj.%Get("gLocId")
	s gUserId=PJObj.%Get("gUserId")
	s:ID'="" PRowIdStr=ID
	q:((PRowIdStr="")&&((PSupLocId="")||(PStartDate="")||(PEndDate=""))) $$$OK
	
	s PStartDate=..DH2L(PStartDate)
	S PEndDate=..DH2L(PEndDate)
	s PStartTime=..TH2L(PStartTime)
	s PEndTime=..TH2L(PEndTime)
	
	s SqlStr="select CSSDPC_Rowid AS RowId, CSSDPC_SerialNo AS CBNo,CSSDPC_Date AS CBDate,CSSDPC_Time as CBTime,"
		_"CSSDPC_ToLoc_DR AS ToLocId, CSSDPC_ToUser_DR AS ToUserId, CSSDPC_FromLoc_DR AS FrLocId,"
		_"CSSDPC_AckDate AS AckDate,CSSDPC_AckTime AS AckTime, CSSDPC_AckUser_DR AS AckUserId,"
		_"CSSDPC_ComplateFlag AS CompFlag, CSSDPC_ISOPRFlag AS OPRFlag,CSSDPC_ReqLevel AS ReqLevel,"
		_"CSSDPC_Remark AS Remark,CSSDPC_PackageApplyDR->CSSDPA_NO As ApplyNo "
		_" from CSSD_PackageCallback where CSSDPC_ComplateFlag!='W'"	//过滤借包、非循环包申请自动生成的回收单
	i PRowIdStr="" s SqlStr=SqlStr_" and CSSDPC_Date between "_PStartDate_" AND "_PEndDate_" "
	e  s SqlStr=SqlStr_"and CSSDPC_Rowid in ("_PRowIdStr_")"
	
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s CBNo=Result.Data("CBNo")
		s CBDate=Result.Data("CBDate")
		s CBTime=Result.Data("CBTime")
		s ToLocId=Result.Data("ToLocId")
		s ToUserId=Result.Data("ToUserId")
		s FrLocId=Result.Data("FrLocId")
		s AckDate=Result.Data("AckDate")
		s AckTime=Result.Data("AckTime")
		s AckUserId=Result.Data("AckUserId")
		s CompFlag=Result.Data("CompFlag")
		s OPRFlag=Result.Data("OPRFlag")
		s ReqLevel=Result.Data("ReqLevel")
		s Remark=Result.Data("Remark")
		s ApplyNo=Result.Data("ApplyNo")
		continue:(PRowIdStr="")&&(PSupLocId'="")&(PSupLocId'=ToLocId)
		continue:(PRowIdStr="")&&(PToUserId'="")&(PToUserId'=ToUserId)
		continue:(PRowIdStr="")&&(PReqLocId'="")&(PReqLocId'=FrLocId)
		continue:(PRowIdStr="")&&(PCBNo'="")&(PCBNo'=CBNo)
		continue:(PRowIdStr="")&&(POPRFlag'="")&(POPRFlag'=OPRFlag)
		continue:(PRowIdStr="")&&(PStartTime'="")&&(PStartDate'="")&&(PStartDate=CBDate)&&(CBTime<PStartTime)
		continue:(PRowIdStr="")&&(PEndTime'="")&&(PEndDate'="")&&(PEndDate=CBDate)&&(CBTime>=PEndTime)
		continue:(PRowIdStr="")&&(PStatus'="")&&(PStatus'=CompFlag)
		s ToUserName=..sssUserName(ToUserId)
		s AckUserName=..sssUserName(AckUserId)
		s FrLocDesc=..sssLocDesc(FrLocId)
		s ToLocDesc=..sssLocDesc(ToLocId)
		s:CBDate'="" CBDate=..DL2H(CBDate)
		s:CBTime'="" CBTime=..TL2H(CBTime)
		s CBDT=CBDate_" "_CBTime
		s:AckDate'="" AckDate=..DL2H(AckDate)
		s:AckTime'="" AckTime=..TL2H(AckTime)
		s AckDT=AckDate_" "_AckTime
		s InfectFlag=..GetInfectFlag(RowId)
		//申请单信息
		s (ApplyUserName,ApplyDT)=""
		s ApplyId=$lg(^User.CSSDPackageCallbackD(RowId),24)
		i ApplyId'="" d
		.s ApplyInfo=$g(^User.CSSDPackageApplyD(ApplyId))
		.s ApplyUserId=$lg(ApplyInfo,8)
		.s ApplyDate=$lg(ApplyInfo,25)
		.s ApplyTime=$lg(ApplyInfo,26)
		.s ApplyUserName=..sssUserName(ApplyUserId)
		.s ApplyDate=..DL2H(ApplyDate)
		.s ApplyTime=..TL2H(ApplyTime)
		.s ApplyDT=ApplyDate_" "_ApplyTime
		
		d OutPutRow
	}
	d Result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,CBNo,CBDate,CBTime,CBDT,
		ToLocId,ToLocDesc,FrLocId,FrLocDesc,ToUserId,ToUserName,
		AckDate,AckTime,AckDT,AckUserId,AckUserName,
		CompFlag,OPRFlag,ReqLevel,InfectFlag,Remark,
		ApplyId,ApplyUserName,ApplyDT,ApplyNo
	)
	
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:lxt
/// 依据回收主单ID获取感染标志
ClassMethod GetInfectFlag(CBId) As %Library.String
{
	n (%session,CBId)
	s InfectFlag="N"
	q:CBId="" InfectFlag
	
	s CBItmId=0
	f  s CBItmId=$o(^User.CSSDCallbackDetailNewI("CSSDCDParrefIndex",CBId,CBItmId)) q:((CBItmId="")||(InfectFlag="Y"))  d
	.s CBInfectFlag=$lg(^User.CSSDCallbackDetailNewD(CBItmId),13)
	.s:CBInfectFlag="Y" InfectFlag="Y"
	.
	q InfectFlag
}

/// Creator:lxt
/// CreatDate:2019.10.16
/// Description:保存回收单主表
/// d ##class(web.CSSDHUI.CallBack.CallBack).jsSave("{""SupLoc"":""166"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""ReqLoc"":""1"",""toUser"":""11889"",""FStatus"":"""",""isOPRFlag"":""N"",""toLocDr"":""166"",""FStartDate"":""2022-06-01"",""FStartTime"":"""",""FEndDate"":""2022-06-02"",""FEndTime"":""""}")
ClassMethod jsSave(Params) As %Library.String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..Update(Params)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:lxt
/// CreatDate:2019.10.16
/// Description:保存回收单主表
/// Table:CSSD_PackageCallback
/// ##class(web.CSSDHUI.CallBack.CallBack).Update 
ClassMethod Update(Params As %String) As web.CSSDHUI.RtnObj
{
	n (%session,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")
	
	s ToLocId=PJObj.%Get("SupLoc")
	s FrLocId=PJObj.%Get("ReqLoc")
	s ToUserId=PJObj.%Get("toUser")
	s OPRFlag=PJObj.%Get("FIsOPRFlag")
	s ReqType=PJObj.%Get("reqType")
	s ReqLevel=PJObj.%Get("ReqLevel")
	s ApplyMainId=PJObj.%Get("ApplyMainRow")
	s LendNo=PJObj.%Get("LendNo")
	s gUserId=PJObj.%Get("gUserId")
	s:ToUserId="" ToUserId=gUserId
	q:ToLocId="" RtnObj.Err(-3,"","供应科室不能为空!")
	s:ReqLevel="" ReqLevel=0
	
	s ret=..sssLock("CallBack")
	q:ret'=0 RtnObj.Err(-2,"","生成回收单号加锁失败！")
	
	s No=##class(web.CSSDHUI.Common.AppCommon).GetAppNo("CallBack")
	s CurDate=+$h
	s CurTime=$P($h,",",2)
	
	&sql(insert into CSSD_PackageCallback(
		CSSDPC_Date, CSSDPC_FromLoc_DR, CSSDPC_SerialNo, CSSDPC_Time, CSSDPC_ToLoc_DR,
		CSSDPC_ToUser_DR, CSSDPC_ISOPRFlag, CSSDPC_ComplateFlag,CSSDPC_ApplyType,
		CSSDPC_PackageApplyDR,CSSDPC_ReqLevel,CSSDPC_LendNO) 
		values(:CurDate,:FrLocId,:No,:CurTime,:ToLocId,
		:ToUserId,:OPRFlag,'N',:ReqType,:ApplyMainId,
		:ReqLevel,:LendNo))
	i SQLCODE'=0 d ..sssUnLock("CallBack") d RtnObj.Err(-3,"",$ClassName()_"Update:保存失败!")
	q:RtnObj.success'=0 RtnObj
	
	d ..sssUnLock("CallBack")
	s RowId=%ROWID
	
	i ApplyMainId'="" d
	.s RtnObj=..UpdateApplyCBFlag(ApplyMainId)
	q:RtnObj.success'=0 RtnObj
	
	s RtnObj.rowid=RowId
	q RtnObj
}

/// Creator:lxt
/// CreatDate:2019.10.16
/// Description:删除回收单
/// Table:CSSD_PackageCallback 
/// w ##class(web.CSSDHUI.CallBack.CallBack).jsDelete("37")
ClassMethod jsDelete(Params) As %Library.String
{
	n (%session,Params)
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
	i RowId="" d RtnObj.Err(-1,"","入参不能为空!")
	q:RtnObj.success'=0 RtnObj
	
	s MainObj=##Class(User.CSSDPackageCallback).%OpenId(RowId)
	i '$IsObject(MainObj) d RtnObj.Err(-2,"","单据不存在!")
	q:RtnObj.success'=0 RtnObj
	
	s CompFlag=MainObj.CSSDPCComplateFlag
	s ApplyMainId=MainObj.CSSDPCPackageApplyDRGetObjectId()
	i CompFlag="Y" d RtnObj.Err(-3,"","已提交不能删除")
	q:RtnObj.success'=0 RtnObj
	
	//删除明细
	s CBItmId=0
	f  s CBItmId=$o(^User.CSSDCallbackDetailNewI("CSSDCDParrefIndex",RowId,CBItmId)) q:(CBItmId="")||(RtnObj.success'=0)  d
	.s RtnObj=##class(web.CSSDHUI.CallBack.CallBackItm).Delete(CBItmId)
	q:RtnObj.success'=0 RtnObj
	
	//删除主单
	&sql(Delete FROM CSSD_PackageCallback WHERE CSSDPC_Rowid=:RowId)
	i SQLCODE<0 d RtnObj.Err(-4,"","删除回收单据失败!")
	q:RtnObj.success'=0 RtnObj
	
	//处理申请表回收标志
	s RtnObj=..UpdateApplyCBFlag(ApplyMainId)
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Creator:lxt
/// CreatDate:2019.9.28
/// Description:根据请领单制作回收单
/// Table:CSSD_CallbackDetailNew,CSSD_PackageCallback 
/// w ##class(web.CSSDHUI.CallBack.CallBack).jsCreateCallBackByApply(^templxt("save",1),^templxt("save",2))
ClassMethod jsCreateCallBackByApply(Params As %String, ItemRow As %String) As %Library.String
{
	n (%session,Params,ItemRow)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..CreateCallBackByApply(Params,ItemRow)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:lxt
ClassMethod CreateCallBackByApply(Params As %String, ItemRow As %String) As web.CSSDHUI.RtnObj
{
	n (%session,Params,ItemRow)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s PJItemObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	
	s gUserId=PJObj.%Get("gUserId")
	
	s ItemSc=PJItemObj.%FromJSON(ItemRow)
	i ItemSc'=0 d RtnObj.Err(-2,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	
	s Pid=..NewPid()
	k ^TMPCSSD(Pid,"CBBYApply")
	
	while(RtnObj.success=0){
		s Obj=PJItemObj.%Pop()
		q:Obj=""
		
		s RowId=Obj.%Get("RowId")
		s ReqQty=Obj.%Get("ReqQty")		;请领数量
		s PackageDR=Obj.%Get("PackageDR")
		s MaterialDr=Obj.%Get("MaterialId")
		s PreQty=Obj.%Get("NotQty")		;待回收数量
		s CodeDict=Obj.%Get("BarCode")
		continue:+PreQty=0
		
		s ApplyDetailObj=##class(User.CSSDPackageApplyDetail).%OpenId(RowId)
		d ApplyDetailObj.%Reload()
		continue:'$IsObject(ApplyDetailObj)
		s ApplyMainId=ApplyDetailObj.CSSDPADParref
		continue:ApplyMainId=""
		s ApplyMainObj=##class(User.CSSDPackageApply).%OpenId(ApplyMainId)
		d ApplyMainObj.%Reload()
		continue:'$IsObject(ApplyMainObj)
		s ReqFlag=ApplyMainObj.CSSDPAFlag
		i ReqFlag'=5 d RtnObj.Err(-4,"","存在未确认的回收申请单!")

		s ret=..IsCallBackAll(ApplyMainId)
		i ret=0 d RtnObj.Err(-3,"","已全部生成回收单,请核实!")
		q:RtnObj.success'=0

		s BackQty=$lg(^User.CSSDPackageApplyDetailD(RowId),8)	;已回收数量(从后台取)
		s NotQty=ReqQty-BackQty
		i PreQty>NotQty d RtnObj.Err(-5,"","要回收数量不能大于未回收数量!")
		continue:RtnObj.success'=0
		
		s DetailStr=PackageDR_"^"_MaterialDr_"^"_CodeDict_"^"_PreQty
		s ^TMPCSSD(Pid,"CBBYApply",ApplyMainId,RowId)=DetailStr
	}
	q:RtnObj.success'=0 RtnObj
	
	i '$d(^TMPCSSD(Pid,"CBBYApply")) d RtnObj.Err(-5,"","没有需要回收的申请")
	q:RtnObj.success'=0 RtnObj
	
	s ApplyMainId=0
	f  s ApplyMainId=$o(^TMPCSSD(Pid,"CBBYApply",ApplyMainId)) q:(ApplyMainId="")||(RtnObj.success'=0)  d
	.s ApplyMainObj=##class(User.CSSDPackageApply).%OpenId(ApplyMainId)
	.d ApplyMainObj.%Reload()
	.q:'$IsObject(ApplyMainObj)
	.s ReqLocId=ApplyMainObj.CSSDPAAPPLYLOCDR.%Id()
	.s SupLocId=ApplyMainObj.CSSDPALOCDR.%Id()
	.s ReqType=ApplyMainObj.CSSDPAType
	.s LendNo=ApplyMainObj.CSSDPALendNO		;归还单关联借包单
	.s ReqLevel=ApplyMainObj.CSSDPAReqLevel
	.s isOPRFlag="N",toUser=gUserId
	.s MainData=ReqLocId_"^"_SupLocId_"^"_toUser_"^"_isOPRFlag_"^"_ReqType_"^"_ApplyMainId_"^"_ReqLevel_"^"_LendNo
	.s MainTitleStr="ReqLoc^SupLoc^toUser^FIsOPRFlag^reqType^ApplyMainRow^ReqLevel^LendNo"
	.s MainParames=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(MainData,MainTitleStr)
	.s RtnObj=..Update(MainParames)
	.q:RtnObj.success'=0
	.s MainId=RtnObj.rowid
	.i MainId="" d RtnObj.Err(-5,"","生成回收主单失败")
	.q:RtnObj.success'=0
	.s ApplyItmId=0
	.f  s ApplyItmId=$o(^TMPCSSD(Pid,"CBBYApply",ApplyMainId,ApplyItmId)) q:(ApplyItmId="")||(RtnObj.success'=0)  d
	..s DetailStr=^TMPCSSD(Pid,"CBBYApply",ApplyMainId,ApplyItmId)
	..s PackageDR=$p(DetailStr,"^",1)
	..s MaterialDr=$p(DetailStr,"^",2)
	..s CodeDict=$p(DetailStr,"^",3)
	..s PreQty=$p(DetailStr,"^",4)
	..s PkgObj=##class(User.CSSDPackage).%OpenId(PackageDR)
	..s AttributeCode=PkgObj.CSSDPPackTypeDetail
	..s IsExt=##class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PackageDR)
	..i IsExt="Y" d
	...s RtnObj=..CallBackExtLabel(MainId,CodeDict,Params,ApplyItmId)
	..e  i AttributeCode=1 d
	...s RtnObj=..CallBackLabel(MainId,CodeDict,Params,ApplyItmId)
	..e  d
	...s DetailData=""_"^"_PackageDR_"^"_PreQty_"^"_""_"^"_CodeDict_"^"_ApplyItmId_"^"_MaterialDr_"^"_ReqLevel
	...s DetailTitle="RowId^PackageDR^Qty^PackageLabel^DictLabel^ApplyDetailDr^MaterialDr^ReqLevel"
	...s Detail=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(DetailData,DetailTitle)
	...s Detail="["_Detail_"]"
	...s RtnObj=##class(web.CSSDHUI.CallBack.CallBackItm).Save(MainId,Detail)
	...q:RtnObj.success'=0
	
	q RtnObj
}

/// Description:查询回收主表信息
/// Creator:	wn
/// CreatDate:	2019-12-11
/// Table:		cssd_packagecallback
/// w ##class(web.CSSDHUI.CallBack.CallBack).Select(67)
ClassMethod Select(CallbackId) As %String
{
	n (%session,CallbackId)
	q:CallbackId="" "{}"
	s MainObj=##Class(User.CSSDPackageCallback).%OpenId(CallbackId)
	d MainObj.%Reload()
	q:'$IsObject(MainObj) "{}"
	s ReqLocName=MainObj.CSSDPCFromLocDr.CTLOCDesc
	s SerialNo=MainObj.CSSDPCSerialNo
	s ToUserName=MainObj.CSSDPCToUserDr.SSUSRName
	s PcDate=MainObj.CSSDPCDate
	s PcTime=MainObj.CSSDPCTime
	s ReqUserName=MainObj.CSSDPCAckUserDr.SSUSRName
	s AckDate=MainObj.CSSDPCAckDate
	s AckTime=MainObj.CSSDPCAckTime
	s Remark=MainObj.CSSDPCRemark
	s ToLocId=MainObj.CSSDPCToLocDr.%Id()
	s PcDate = ..DL2H(PcDate)_" "_..TL2H(PcTime)
	s AckDate=..DL2H(AckDate)_" "_..TL2H(AckTime)
	s PrintDate=$zdt($h,3)
	
	s ApplyId=$lg(^User.CSSDPackageCallbackD(CallbackId),24)
	s (ApplyUserName,ApplyDateTime)=""
	i ApplyId'="" d
	.s ApplyInfo=$g(^User.CSSDPackageApplyD(ApplyId))
	.s ApplyUser=$lg(ApplyInfo,8)
	.s ApplyDate=$lg(ApplyInfo,25)
	.s ApplyTime=$lg(ApplyInfo,26)
	.i ApplyUser'="" s ApplyUserName=$p(^SSU("SSUSR",ApplyUser),"^",2)
	.s ApplyDate=..DL2H(ApplyDate)
	.s ApplyTime=..TL2H(ApplyTime)
	.s ApplyDateTime=ApplyDate_" "_ApplyTime
	
	s DataStr=CallbackId_"^"_ReqLocName_"^"_SerialNo_"^"_ToUserName_"^"_PcDate_"^"_ReqUserName_"^"_AckDate_"^"_Remark_"^"_PrintDate_"^"_ApplyUserName_"^"_ApplyDateTime_"^"_ToLocId
	s TitleStr="RowId^ReqLocName^SerialNo^ToUserName^PcDate^ReqUserName^AckDate^Remark^PrintDate^ApplyUserName^ApplyDateTime^ToLocId"
	s Rtn=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(DataStr,TitleStr)
	q Rtn
}

/// Creator:wb
/// CreatDate:2020-1-14
/// Description:根据请领主表id判断请领单是全部回收
/// Table:CSSD_PackageApplyDetail
/// d ##class(web.CSSDHUI.CallBack.CallBack).IsCallBackAll("20201100004")
ClassMethod IsCallBackAll(ApplyId) As %Library.String
{
	n (%session,ApplyId)
	s sumBackQty=0,sumReqQty=0
	s ApplyDetail=""
	f  s ApplyDetail=$o(^User.CSSDPackageApplyDetailI("CSSDPADParrefIndex",ApplyId,ApplyDetail)) q:ApplyDetail=""  d
	.s ApplyDetailObj=##Class(User.CSSDPackageApplyDetail).%OpenId(ApplyDetail)
	.d ApplyDetailObj.%Reload()
	.q:'$IsObject(ApplyDetailObj)
	.s BackQty=ApplyDetailObj.CSSDPADBackQty
	.s ReqQty=ApplyDetailObj.CSSDPADReqQty
	.s sumBackQty=sumBackQty+BackQty
	.s sumReqQty=sumReqQty+ReqQty
	
	s ret=sumReqQty-sumBackQty
	q ret
}

/// Creator:wb  wn
/// CreatDate:2020-1-14
/// Description:根据请领单判断相关回收单据是否全部提交
/// Table:CSSD_PackageApplydetail
/// w ##class(web.CSSDHUI.CallBack.CallBack).IsSubmitOrderAll(469,"20220300032")
ClassMethod IsSubmitOrderAll(MainId, ApplyId) As %Library.String
{
	n (%session,MainId,ApplyId)
	s IsSubmitOrderAll="Y"
	s ApplyDetailId=0
	f  s ApplyDetailId=$o(^User.CSSDPackageApplyDetailI("CSSDPADParrefIndex",ApplyId,ApplyDetailId)) q:((ApplyDetailId="")||(IsSubmitOrderAll'="Y"))  d
	.s CallbackDetailId=0
	.f  s CallbackDetailId=$o(^User.CSSDCallbackDetailNewI("CSSDCDPackageApplyDetailDRIndex",ApplyDetailId,CallbackDetailId)) q:((CallbackDetailId="")||(IsSubmitOrderAll'="Y"))  d
	..s CallBackMainId=$lg(^User.CSSDCallbackDetailNewD(CallbackDetailId),2)
	..s CallBackMainObj=##class(User.CSSDPackageCallback).%OpenId(CallBackMainId)
	..q:'$IsObject(CallBackMainObj)
	..d CallBackMainObj.%Reload()
	..q:CallBackMainId=MainId
	..s State=CallBackMainObj.CSSDPCComplateFlag
	..s:State'="Y" IsSubmitOrderAll="N"
	
	q IsSubmitOrderAll
}

ClassMethod CreateCallBackByBorrow(ApplyMainRowId As %String) As web.CSSDHUI.RtnObj
{
	n (%session,ApplyMainRowId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i ApplyMainRowId="" d RtnObj.Err(-1,"","入参不能为空!")
	q:RtnObj.success'=0 RtnObj
	
	s ApplyMainObj=##class(User.CSSDPackageApply).%OpenId(ApplyMainRowId)
	d ApplyMainObj.%Reload()
	s No=ApplyMainObj.CSSDPANO
	s ApplyItemRowId=""
	s fromLocDr=ApplyMainObj.CSSDPAAPPLYLOCDR.%Id()
	s reqType=ApplyMainObj.CSSDPAType
	s ReqLevel=ApplyMainObj.CSSDPAReqLevel
	s toLocDr=ApplyMainObj.CSSDPALOCDR.%Id()
	s toUserDr=ApplyMainObj.CSSDPAAPPLYUSERDR.%Id()
	s isOPRFlag="N"
	s ret=..IsCallBackAll(ApplyMainRowId)
	i ret=0 q RtnObj.Err(-6,"","已经全部回收!")

	s MainData=fromLocDr_"^"_toLocDr_"^"_toUserDr_"^"_isOPRFlag_"^"_reqType_"^"_ApplyMainRowId_"^"_ReqLevel_"^"_No
	s MainTitleStr="fromLocDr^toLocDr^toUserDr^isOPRFlag^reqType^ApplyMainRow^ReqLevel^No"
	s MainParames=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(MainData,MainTitleStr)
	s RtnObj=..UpdateByBorrow(MainParames)
	q:RtnObj.success'=0 RtnObj

	s CallBackId=RtnObj.rowid
	s RtnObj=##class(web.CSSDHUI.CallBack.CallBackItm).SaveByBorrow(CallBackId,ApplyMainRowId,ReqLevel)
	q:RtnObj.success'=0 RtnObj

	s RtnObj.rowid=CallBackId
	q RtnObj
}

/// Creator:wb
/// CreatDate:2020.3.30
/// Description:保存借包单回收单主表
/// Table:CSSD_PackageCallback
ClassMethod UpdateByBorrow(Main As %String) As web.CSSDHUI.RtnObj
{
	n (%session,Main)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Main)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	s ret=..sssLock("CallBack")
	i ret'=0 d RtnObj.Err(-2,"","生成回收单号加锁失败！")
	q:RtnObj.success'=0 RtnObj
	s No=##class(web.CSSDHUI.Common.AppCommon).GetAppNo("CallBack")
	s edate=+$h
	s etime=$P($h,",",2)
	s fromLocDr=PJObj.%Get("fromLocDr")
	s toLocDr=PJObj.%Get("toLocDr")
	s toUserDr=PJObj.%Get("toUserDr")
	s reqType=PJObj.%Get("reqType")
	s ReqLevel=PJObj.%Get("ReqLevel")
	s ApplyMainRow=PJObj.%Get("ApplyMainRow")
	s isOPRFlag=PJObj.%Get("isOPRFlag")
	&sql(insert into CSSD_PackageCallback( CSSDPC_Date ,CSSDPC_FromLoc_DR,CSSDPC_SerialNo,
		CSSDPC_Time,CSSDPC_ToLoc_DR, CSSDPC_ToUser_DR,CSSDPC_ISOPRFlag, CSSDPC_ApplyType,
		CSSDPC_ComplateFlag, CSSDPC_PackageApplyDR,CSSDPC_ReqLevel,CSSDPC_LendNO)
		values(:edate,:fromLocDr,:No,:etime,:toLocDr,
		:toUserDr,:isOPRFlag,:reqType,'W',:ApplyMainRow,:ReqLevel,:ApplyMainRow))
	i SQLCODE d ..sssUnLock("CallBack") d RtnObj.Err(-3,"",$ClassName()_"Update:保存失败!")
	q:RtnObj.success'=0 RtnObj

	d ..sssUnLock("CallBack")
	s RtnObj.rowid=%ROWID
	q RtnObj
}

/// Creator:lxt
/// CreatDate:2020.04.25
/// Description:更新回收制单的备注信息
/// d ##class(web.CSSDHUI.CallBack.CallBack).JsUpdateRemark()
/// table:CSSD_PackageCallback 
ClassMethod JsUpdateRemark(Rows As %String) As %Library.String
{
	n (%session,Rows)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s $ZT=..sssError()
	ts
	s RtnObj=..UpdateRemark(Rows)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:lxt
/// d ##class(web.CSSDHUI.CallBack.CallBack).UpdateRemark("[{""RowId"":""165"",""usrName"":"""",""CBDate"":""2020-04-24"",""CBTime"":""00:06:22"",""FroLocDR"":""1"",""FroLocDesc"":""内科普通门诊"",""No"":""63440"",""AckDate"":"""",""AckUser"":"""",""AckUserDesc"":"""",""ComplateFlag"":""N"",""ToUser"":"""",""Remark"":""123""}]")
ClassMethod UpdateRemark(Rows As %String) As web.CSSDHUI.RtnObj
{
	n (%session,Rows)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Rows)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	
	s TotalId=""
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Remark=Obj.%Get("Remark")
		s Obj=##class(User.CSSDPackageCallback).%OpenId(RowId)
		i '$IsObject(Obj) d RtnObj.Err(-2,"",$ClassName()_"单据不存在!")
		continue:RtnObj.success'=0
		&sql(Update CSSD_PackageCallback set CSSDPC_Remark = :Remark where CSSDPC_Rowid = :RowId)
		i SQLCODE'=0 d RtnObj.Err(-2,"",$ClassName()_"Update:保存失败!")
		continue:RtnObj.success'=0
		i TotalId="" s TotalId=RowId
		e  s TotalId=TotalId_","_RowId
	}
	q:RtnObj.success'=0 RtnObj

	s RtnObj.rowid=TotalId
	q RtnObj
}

/// Creator:lxt
/// CreatDate:2020.12.20
/// Description:回收单明细按标签/标牌录入
/// Table:cssd_trans,cssd_codedict
/// w ##class(web.CSSDHUI.CallBack.CallBack).jsCallBackLabel("64","102080001","{""SupLoc"":""166"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""FStartDate"":""2023-01-12"",""ReqLoc"":"""",""FEndDate"":""2023-01-15"",""toUser"":"""",""FStatus"":"""",""FStartTime"":"""",""FEndTime"":""""}")
ClassMethod jsCallBackLabel(MainId As %String, label As %String, Params As %String) As %String
{
	n (%session,MainId,label,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	
	s MainObj=##Class(User.CSSDPackageCallback).%OpenId(MainId)
	q:'$IsObject(MainObj) RtnObj.Err(-1,"","回收单不存在！").Json()
	
	s CompFlag=MainObj.CSSDPCComplateFlag
	q:CompFlag="Y" RtnObj.Err(-1,"","已提交不能添加").Json()
	
	s LabelInfo=##class(web.CSSDHUI.Common.PackageInfoCommon).GetLabel(label)
	s CodeDict=$p(LabelInfo,"^",1)
	s PackTypeDetail=$p(LabelInfo,"^",2)
	s PackageId=$p(LabelInfo,"^",3)
	s IsExt=##class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PackageId)
	q:(CodeDict="") RtnObj.Err(-1,"","未获取到标牌或标签信息").Json()
	
	ts
	i IsExt="Y" d
	.s RtnObj=..CallBackExtLabel(MainId,label,Params)
	e  i PackTypeDetail=1 d
	.s RtnObj=..CallBackLabel(MainId,label,Params)
	e  d
	.s RtnObj=..SaveOrdByLabel(MainId,label)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:lxt
/// 标牌追溯包标签录入
/// w ##class(web.CSSDHUI.CallBack.CallBack).CallBackLabel("95","L0205600400000301",2)	
ClassMethod CallBackLabel(MainId As %String, label As %String, Params As %String, ApplyItmId = "") As web.CSSDHUI.RtnObj
{
	n (%session,MainId,label,Params,ApplyItmId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	q:(MainId="") RtnObj.Err(-1,"","请选择回收单")
	q:(label="") RtnObj.Err(-1,"","标签不能为空")
	
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	
	s gHospId=PJObj.%Get("gHospId")
	s gLocId=PJObj.%Get("gLocId")
	s gUserId=PJObj.%Get("gUserId")
	s gGroupId=PJObj.%Get("gGroupId")
	s CBMainObj=##class(User.CSSDPackageCallback).%OpenId(MainId)
	s FrLocId=CBMainObj.CSSDPCFromLocDrGetObjectId()
	s ToLocId=CBMainObj.CSSDPCToLocDrGetObjectId()
	
	s LabelInfo=##class(web.CSSDHUI.Common.PackageInfoCommon).GetLabel(label)
	s CodeDict=$p(LabelInfo,"^",1)
	s PackTypeDetail=$p(LabelInfo,"^",2)
	s PackageId=$p(LabelInfo,"^",3)
	s UseFlag=$p(LabelInfo,"^",4)
	q:CodeDict="" RtnObj.Err(-3,"","对应标牌不存在")
	q:PackageId="" RtnObj.Err(-3,"","未找到对应消毒包")
	q:UseFlag="N" RtnObj.Err(-3,"","对应标牌已停用")
	
	s DefaultMatId=##class(web.CSSDHUI.Common.PackageInfoCommon).GetDefaultMaterial(PackageId)
	i DefaultMatId="" d RtnObj.Err(-1,"","该包未维护默认包装材料!")
	q:RtnObj.success'=0 RtnObj
	
	s MatInfo=##class(web.CSSDHUI.Common.PackageInfoCommon).GetMaterialExpireLength(DefaultMatId,PackageId)
	s Price=$p(MatInfo,"^",2)
	
	s CodeLength=$l(CodeDict)
	&sql(select max(cssdt_rowid) into :RowId from cssd_trans where substr(cssdt_label,1,:CodeLength)=:CodeDict)
	
	s PkgLabel=""
	i RowId'="" d
	.s TransObj=##Class(User.CSSDTrans).%OpenId(RowId)
	.s PkgLabel=TransObj.CSSDTLabel
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
	..q:RtnObj.success'=0
	e  d
	.s TmpCBTmpId=$o(^User.CSSDCallbackDetailNewI("CSSDPCDictLabelIndex",CodeDict,0))
	.i TmpCBTmpId'="" d RtnObj.Err(-3,"","已回收")
	.q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj
	
	s ReqLevel=0,InfectFlag="N"
	i ApplyItmId'="" d
	.s ApplyItmObj=##class(User.CSSDPackageApplyDetail).%OpenId(ApplyItmId)
	.d ApplyItmObj.%Reload()
	.q:'$IsObject(ApplyItmObj)
	.s ReqLevel=+ApplyItmObj.CSSDPADZExpress
	.s InfectFlag=ApplyItmObj.CSSDPADBeInfected
	.&sql(Update CSSD_PackageApplyDetail set CSSDPAD_BackQty=CSSDPAD_BackQty+1 where ID=:ApplyItmId)
	.i SQLCODE'=0 d RtnObj.Err(-1,"","更新申请单回收数量失败")
	q:RtnObj.success'=0 RtnObj
	
	//插入回收明细
	&sql(INSERT INTO CSSD_CallBackDetailNew(
		CSSDCD_Parref_DR,CSSDCD_Package_DR,CSSDCD_Qty,CSSDCD_DispQty,
		CSSDPC_PackageLabel,CSSDPC_DictLabel,CSSDCD_Material,CSSDCD_Price,
		CSSDCD_LevelFlag,CSSDCD_PackageApplyDetailDR,CSSDCDP_BeInfected)
		VALUES(:MainId,:PackageId,1,0,:PkgLabel,:CodeDict,:DefaultMatId,:Price,:ReqLevel,:ApplyItmId,:InfectFlag))
	i SQLCODE'=0 d RtnObj.Err(-1,"","回收明细保存失败!")
	q:RtnObj.success'=0 RtnObj
	s CBItmId=%ROWID
	
	i RowId'="" d
	.//更新跟踪表
	.&sql(UPDATE CSSD_Trans SET CSSDT_CallBack_DR=:MainId,
		CSSDT_CallBackDetail_DR=:CBItmId,CSSDT_Status='C',CSSDT_CurrLoc_DR=:ToLocId 
		WHERE CSSDT_Rowid=:RowId)
	.i SQLCODE'=0 d RtnObj.Err(-3,"","更新追踪信息数据失败！")
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Creator:lxt
/// 外来器械标签录入
ClassMethod CallBackExtLabel(MainId, label, Params, ApplyItmId = "") As web.CSSDHUI.RtnObj
{
	n (%session,MainId,label,Params,ApplyItmId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	q:(MainId="") RtnObj.Err(-1,"","请选择回收单")
	q:(label="") RtnObj.Err(-1,"","标签不能为空")
	
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	
	s gHospId=PJObj.%Get("gHospId")
	s gLocId=PJObj.%Get("gLocId")
	s gUserId=PJObj.%Get("gUserId")
	s gGroupId=PJObj.%Get("gGroupId")
	
	s LabelInfo=##class(web.CSSDHUI.Common.PackageInfoCommon).GetLabel(label)
	s CodeDict=$p(LabelInfo,"^",1)
	s PackTypeDetail=$p(LabelInfo,"^",2)
	s PackageId=$p(LabelInfo,"^",3)
	s UseFlag=$p(LabelInfo,"^",4)
	q:CodeDict="" RtnObj.Err(-3,"","对应标牌不存在")
	q:PackageId="" RtnObj.Err(-3,"","未找到对应消毒包")
	q:UseFlag="N" RtnObj.Err(-3,"","对应标牌已停用")
	
	s Param=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	//s IsExtSingleBack=##class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDCALLBACK","IsExtSingleBack",Param)
	s IsExtSingleBack="N"	//参数已去除，分包处理写法保留202301
	
	s PkgLabel="",CodeLength=$l(CodeDict)
	i IsExtSingleBack="N" d	//整包回收
	.s TmpRowId="",TmpLabel="",ItemRowId=0
	.&sql(select max(cssdt_rowid) into :TmpRowId from cssd_trans where substr(cssdt_label,1,:CodeLength)=:CodeDict)
	.i TmpRowId="" d RtnObj.Err(-4,"","消毒包未使用不能回收")
	.q:RtnObj.success'=0
	.s TmpLabel=$lg(^User.CSSDTransD(TmpRowId),5)
	.s NewLabel=$e(TmpLabel,1,CodeLength+6)	;标牌编码号加上6位流水号
	.f  s ItemRowId=$o(^User.CSSDPackagePackI("CSSDPPNewLabelIndex",NewLabel,ItemRowId)) q:((ItemRowId="")||(RtnObj.success'=0))  d
	..s ItemObj=##Class(User.CSSDPackagePack).%OpenId(ItemRowId)
	..s PkgLabel=ItemObj.CSSDPPLabel
	..s RtnObj=$$LabelDeal(MainId,PackageId,CodeDict,PkgLabel,ApplyItmId)
	e  d	//分包回收
	.i label=CodeDict d RtnObj.Err(-4,"","分包回收请录入标签而非标牌!")
	.q:RtnObj.success'=0
	.s PkgLabel=label
	.s RtnObj=$$LabelDeal(MainId,PackageId,CodeDict,PkgLabel,ApplyItmId)
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
	
LabelDeal(MainId,PackageId,CodeDict,PkgLabel,ApplyItmId)
	n (%session,MainId,PackageId,CodeDict,PkgLabel,ApplyItmId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s CBMainObj=##class(User.CSSDPackageCallback).%OpenId(MainId)
	s FrLocId=CBMainObj.CSSDPCFromLocDrGetObjectId()
	s ToLocId=CBMainObj.CSSDPCToLocDrGetObjectId()
	s CodeLength=$l(CodeDict)
	
	s DefaultMatId=##class(web.CSSDHUI.Common.PackageInfoCommon).GetDefaultMaterial(PackageId)
	i DefaultMatId="" d RtnObj.Err(-1,"","该包未维护默认包装材料!")
	q:RtnObj.success'=0 RtnObj
	
	s MatInfo=##class(web.CSSDHUI.Common.PackageInfoCommon).GetMaterialExpireLength(DefaultMatId,PackageId)
	s Price=$p(MatInfo,"^",2)
	
	s RowId=""
	&sql(select max(cssdt_rowid) into :RowId from cssd_trans where cssdt_label=:PkgLabel)
	i RowId="" d RtnObj.Err(-4,"","消毒包未使用不能回收")
	q:RtnObj.success'=0 RtnObj
	
	s TransObj=##Class(User.CSSDTrans).%OpenId(RowId)
	s DispId=TransObj.CSSDTDispGetObjectId()
	s TrfId=TransObj.CSSDTTrfDRGetObjectId()
	i TrfId'="" s DispId=TrfId	//先判断调拨类型发放单
	s Status=TransObj.CSSDTStatus
	s TransCBItm=TransObj.CSSDTCallBackDetailGetObjectId()
	i TransCBItm'="" d RtnObj.Err(-3,"","已回收")
	q:RtnObj.success'=0 RtnObj
	i ((Status'="R")&&(Status'="U")&&(Status'="TC")) d
	.d RtnObj.Err(-3,"","标签当前不是接收、使用、过期处理状态，不能回收！")
	q:RtnObj.success'=0 RtnObj
	
	i DispId'="" d
	.s DispObj=##class(User.CSSDPackageDisp).%OpenId(DispId)
	.s DispToLocId=DispObj.CSSDPDToLocDrGetObjectId()
	.i (FrLocId'="")&&(DispToLocId'="")&&(FrLocId'=DispToLocId) d RtnObj.Err(-1,"","回收科室与标签所在科室不符")
	q:RtnObj.success'=0 RtnObj
	
	s ReqLevel=0,InfectFlag="N"
	i ApplyItmId'="" d
	.s ApplyItmObj=##class(User.CSSDPackageApplyDetail).%OpenId(ApplyItmId)
	.d ApplyItmObj.%Reload()
	.q:'$IsObject(ApplyItmObj)
	.s ApplyId=ApplyItmObj.CSSDPADParref
	.s ApplyObj=##class(User.CSSDPackageApply).%OpenId(ApplyId)
	.d ApplyObj.%Reload()
	.q:'$IsObject(ApplyObj)
	.s ReqLevel=ApplyObj.CSSDPAReqLevel
	.s InfectFlag=ApplyItmObj.CSSDPADBeInfected
	.&sql(Update CSSD_PackageApplyDetail set CSSDPAD_BackQty=CSSDPAD_BackQty+1 where ID=:ApplyItmId)
	.i SQLCODE'=0 d RtnObj.Err(-1,"","更新申请单回收数量失败")
	q:RtnObj.success'=0 RtnObj
	
	//插入回收明细
	&sql(INSERT INTO CSSD_CallBackDetailNew(
		CSSDCD_Parref_DR,CSSDCD_Package_DR,CSSDCD_Qty,CSSDCD_DispQty,
		CSSDPC_PackageLabel,CSSDPC_DictLabel,CSSDCD_Material,CSSDCD_Price,
		CSSDCD_LevelFlag,CSSDCD_PackageApplyDetailDR,CSSDCDP_BeInfected)
		VALUES(:MainId,:PackageId,1,0,:PkgLabel,:CodeDict,:DefaultMatId,:Price,:ReqLevel,:ApplyItmId,:InfectFlag))
	i SQLCODE'=0 d RtnObj.Err(-1,"","回收明细保存失败!")
	q:RtnObj.success'=0 RtnObj
	s CBItmId=%ROWID
	
	//更新跟踪表
	&sql(UPDATE CSSD_Trans SET CSSDT_CallBack_DR=:MainId,
		CSSDT_CallBackDetail_DR=:CBItmId,CSSDT_Status='C',CSSDT_CurrLoc_DR=:ToLocId 
		WHERE CSSDT_Label=:PkgLabel)
	i SQLCODE'=0 d RtnObj.Err(-3,"","更新追踪信息数据失败！")
	q:RtnObj.success'=0 RtnObj
	
	s NewLabel=$e(PkgLabel,1,CodeLength+6)	;标牌编码号加上6位流水号
	s ExtRowId=$o(^User.CSSDExtDevBindI("IndexCSSDExtLabel",NewLabel,""))
	i ExtRowId'="" d
	.s CurDate=$p($h,",",1)
	.s ExCBId=$o(^User.CSSDExtCallBackLabelI("CSSDECLLabelCallBackDrIndex",PkgLabel,CBItmId,""))
	.q:ExCBId'=""
	.&sql(INSERT INTO CSSD_ExtCallBackLabel
		(CSSDECL_Parref_DR,CSSDECL_Qty,CSSDECL_Label,CSSDECL_Status,
		CSSDECL_CallBackDetailDr,CSSDECL_Date) 
		VALUES (:ExtRowId,1,:PkgLabel,"C",:CBItmId,:CurDate))
	.i SQLCODE'=0 d RtnObj.Err(-7,"","保存外来器械回收明细数据失败！") q
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Creator:lxt
/// 普通循环包标签录入
ClassMethod SaveOrdByLabel(MainId As %String, Label As %String) As web.CSSDHUI.RtnObj
{
	n (%session,MainId,Label)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i ((MainId="")||(Label="")) d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	
	s CBMainObj=##class(User.CSSDPackageCallback).%OpenId(MainId)
	s FrLocId=CBMainObj.CSSDPCFromLocDrGetObjectId()
	s ToLocId=CBMainObj.CSSDPCToLocDrGetObjectId()
	
	s LabelInfo=##class(web.CSSDHUI.Common.PackageInfoCommon).GetLabel(Label)
	s CodeDict=$p(LabelInfo,"^",1)
	s PackTypeDetail=$p(LabelInfo,"^",2)
	s PackageId=$p(LabelInfo,"^",3)
	s UseFlag=$p(LabelInfo,"^",4)
	q:PackageId="" RtnObj.Err(-3,"","未找到对应消毒包")
	
	s RowId=""
	&sql(select max(cssdt_rowid) into :RowId from cssd_trans where cssdt_label=:Label)
	q:RowId="" RtnObj.Err(-3,"","未找到标签信息")
	
	s DefaultMatId=##class(web.CSSDHUI.Common.PackageInfoCommon).GetDefaultMaterial(PackageId)
	i DefaultMatId="" d RtnObj.Err(-1,"","该包未维护默认包装材料!")
	q:RtnObj.success'=0 RtnObj
	
	s MatInfo=##class(web.CSSDHUI.Common.PackageInfoCommon).GetMaterialExpireLength(DefaultMatId,PackageId)
	s Price=$p(MatInfo,"^",2)
	
	s PkgLabel=""
	s TransObj=##Class(User.CSSDTrans).%OpenId(RowId)
	s PkgLabel=TransObj.CSSDTLabel
	s DispId=TransObj.CSSDTDispGetObjectId()
	s TrfId=TransObj.CSSDTTrfDRGetObjectId()
	s Status=TransObj.CSSDTStatus
	s TransCBItm=TransObj.CSSDTCallBackDetailGetObjectId()
	i TransCBItm'="" d RtnObj.Err(-3,"","已回收")
	q:RtnObj.success'=0 RtnObj
	i TrfId'="" s DispId=TrfId	//先判断调拨类型发放单
	i ((Status'="R")&&(Status'="U")&&(Status'="TC")) d
	.d RtnObj.Err(-3,"","标签当前不是接收、使用、过期处理状态，不能回收！")
	q:RtnObj.success'=0 RtnObj
	
	i DispId'="" d
	.s DispObj=##class(User.CSSDPackageDisp).%OpenId(DispId)
	.s DispToLocId=DispObj.CSSDPDToLocDrGetObjectId()
	.i (FrLocId'="")&&(DispToLocId'="")&&(FrLocId'=DispToLocId) d RtnObj.Err(-1,"","回收科室与标签所在科室不符")
	q:RtnObj.success'=0 RtnObj
	
	s Qty=1
	s CallBackDetailId=$o(^User.CSSDCallbackDetailNewI("CSSDCDParrefItmIndex",MainId,PackageId,""))
	i CallBackDetailId'="" d
	.s CallbackDetailObj=##class(User.CSSDCallbackDetailNew).%OpenId(CallBackDetailId)
	.d CallbackDetailObj.%Reload()
	.s TmpQty=CallbackDetailObj.CSSDCDQty		;已回收数量
	.s TmpQty=TmpQty+Qty
	.&sql(UPDATE CSSD_CallBackDetailNew SET CSSDCD_Qty=:TmpQty WHERE CSSDCD_Rowid=:CallBackDetailId )
	.i SQLCODE'=0 d RtnObj.Err(-3,"","更新回收明细数据失败！") q
	e  d
	.&sql(INSERT INTO CSSD_CallBackDetailNew (CSSDCD_Parref_DR,CSSDCD_Package_DR,CSSDCD_Qty
		,CSSDCD_DispQty,CSSDCD_Price,CSSDCD_IsClean,CSSDCD_Material,CSSDCD_LevelFlag,CSSDCDP_BeInfected)
		 VALUES (:MainId,:PackageId,:Qty,'0',:Price,'N',:MaterialDr,'0','N'))
	.i SQLCODE'=0 d RtnObj.Err(-4,"","新增回收明细数据失败！") q
	.s CallBackDetailId=%ROWID
	q:RtnObj.success'=0 RtnObj
	
	&sql(UPDATE CSSD_Trans SET CSSDT_CallBack_DR=:MainId,
		CSSDT_CallBackDetail_DR=:CallBackDetailId,CSSDT_Status='C',CSSDT_CurrLoc_DR=:ToLocId 
		WHERE CSSDT_Label=:Label)
	i SQLCODE'=0 d RtnObj.Err(-3,"","更新追踪信息数据失败！")
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Description：依据标签获取可回收的标签信息（批量扫码回收界面）
/// Creator：lxt
/// CreateDate：20220531
/// w ##class(web.CSSDHUI.CallBack.CallBack).GetCallBackLabelInfo("{""SupLoc"":""166"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""BarCode"":""dgsdfsd"",""Label"":""dgsdfsd""}")
ClassMethod GetCallBackLabelInfo(Params)
{
	n (%session,Params)
	s ErrTitle="Err"
	s Err="",RetJson=""
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 s Err="参数解析失败！"
	q:Err'="" ##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Err,ErrTitle)
	
	s gHospId=PJObj.%Get("gHospId")
	s gLocId=PJObj.%Get("gLocId")
	s gUserId=PJObj.%Get("gUserId")
	s gGroupId=PJObj.%Get("gGroupId")
	s pSupLocId=PJObj.%Get("SupLoc")
	s pLabel=PJObj.%Get("Label")
	i pLabel="" s Err="标签不能为空！"
	q:Err'="" ##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Err,ErrTitle)
	
	s PackageInfo=##class(web.CSSDHUI.Common.PackageInfoCommon).GetLabel(pLabel)
	s (PackTypeDetail,PackageId,CodeDict)=""
	i PackageInfo'="" d
	.s PackTypeDetail=$p(PackageInfo,"^",2)
	.s PackageId=$p(PackageInfo,"^",3)
	i PackageId="" s Err="错误得标签号"
	q:Err'="" ##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Err,ErrTitle)
	
	i PackTypeDetail="1" d
	.s CodeDict=##class(web.CSSDHUI.Common.PackageInfoCommon).GetFixedLabel(pLabel)
	.i CodeDict="" s Err="标签没有对应的标牌！"
	.q:Err'="" 
	.s DefaultMat=##class(web.CSSDHUI.Common.PackageInfoCommon).GetDefaultMaterial(PackageId)
	.i DefaultMat="" s Err="消毒包未维护默认包装材料！"
	.q:Err'=""
	.s tempCallDetialRowid=$o(^User.CSSDCallbackDetailNewI("CSSDCDPackageLabelIndex",pLabel,0))
	.i tempCallDetialRowid'="" s Err="标签已经存在其他回收单!"
	.q:Err'=""
	q:Err'="" ##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Err,ErrTitle)
	
	s TransRowId=""
	i pLabel=CodeDict d	//扫标牌
	.s CodeLength=$l(CodeDict)
	.&sql(select max(cssdt_rowid) into :TransRowId from cssd_trans where substr(cssdt_label,1,:CodeLength)=:pLabel)
	.i TransRowId="" d
	..s tempCallDetialRowid=$o(^User.CSSDCallbackDetailNewI("CSSDPCDictLabelIndex",CodeDict,0))
	..i tempCallDetialRowid'="" s Err="标牌已经存在其他回收单!"
	.q:Err'=""
	e  d	//扫标签
	.&sql(select cssdt_rowid into :TransRowId from cssd_trans where cssdt_label=:pLabel)
	q:Err'="" ##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Err,ErrTitle)
	
	s (ReqLocId,ReqLocDesc,Label)=""
	i TransRowId'="" d
	.s Trans=##Class(User.CSSDTrans).%OpenId(TransRowId)
	.s Label=Trans.CSSDTLabel
	.s CallBackD=Trans.CSSDTCallBackDetail
	.s TransStatus=Trans.CSSDTStatus
	.s DispId=Trans.CSSDTDispGetObjectId()
	.s TrfId=Trans.CSSDTTrfDRGetObjectId()
	.i TrfId'="" s DispId=TrfId	//先判断调拨类型发放单
	.i ((DispId="")&&(TransStatus'="TC")) s Err="未发放或过期未处理不能回收"
	.q:Err'=""
	.i DispId'="" d
	..s DispObj=##class(User.CSSDPackageDisp).%OpenId(DispId)
	..s ReqLocId=DispObj.CSSDPDToLocDrGetObjectId()
	..i (pSupLocId'="")&&(ReqLocId'="")&&(pSupLocId=ReqLocId) s Err="供应科室与回收科室不能相同！"
	..q:Err'=""
	..i ReqLocId'="" s ReqLocDesc=$p(^CTLOC(ReqLocId),"^",2)
	.i $IsObject(CallBackD) s Err="标签已回收！"
	.q:Err'=""
	.i ((TransStatus'="R")&&(TransStatus'="U")&&(TransStatus'="TC")) s Err="条码当前不是接收/使用状态不能回收!"
	.q:Err'=""
	e  d
	.s Label=pLabel
	q:Err'="" ##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Err,ErrTitle)
	
	s (PackageName)=""
	s packageObj = ##class(User.CSSDPackage).%OpenId(PackageId)
	&sql(select cssdcd_packname into :PackageName from cssd_codedict where cssdcd_code=:CodeDict)
	i PackageName="" d
	.s PackageName=packageObj.CSSDPDesc
	s useinfo=##Class(web.CSSDHUI.Stat.TransStat).GetPkgUseInfo(Label)
	s Data=PackageName_"^"_TransRowId_"^"_packageObj.CSSDPDesc_"^"_PackageId_"^"_CodeDict_"^"_Label_"^"_ReqLocId_"^"_ReqLocDesc_"^"_1_"^"_PackTypeDetail
	s Title="PackageName^RowId^packageDesc^PackageDR^DictLabel^PackageLabel^ReqLocId^ReqLocDesc^Qty^PackTypeDetail"
	i useinfo'="" d
	.s Data=Data_"^"_$p(useinfo,"|",3)_"^"_$p(useinfo,"|",4)_"^"_$p(useinfo,"|",5)_"^"_$p(useinfo,"|",10)_"^"_..DL2H($p(useinfo,"|",6))_" "_..TL2H($p(useinfo,"|",11))
	.s Title=Title_"^oprDoctor^instNurse^circNurse^infectName^oprDt"
	
	s RetJson=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q RetJson
}

/// Description：依据标签使用科室拆分生成回收单（批量扫码回收界面）
/// Creator：lxt
/// CreateDate：20220531
/// w ##class(web.CSSDHUI.CallBack.CallBack).jsCallBackOPRByLabel(^tmpljl,^tmpljl2)
ClassMethod jsCallBackOPRByLabel(Main As %String, Detail As %String) As %String
{
	n (%session,Main,Detail)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..CallBackOPRByLabel(Main,Detail)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Description：依据标签使用科室拆分生成回收单（批量扫码回收界面）
/// Creator：lxt
ClassMethod CallBackOPRByLabel(Main As %String, Detail As %String) As %String
{
	n (%session,Main,Detail)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s MPJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=MPJObj.%FromJSON(Main)
	q:Sc'=0 RtnObj.Err(-1,"","参数解析失败！","",0)
	
	s DPJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=DPJObj.%FromJSON(Detail)
	q:Sc'=0 RtnObj.Err(-1,"","参数解析失败！","",0)
	
	s gHospId=MPJObj.%Get("gHospId")
	s gLocId=MPJObj.%Get("gLocId")
	s gUserId=MPJObj.%Get("gUserId")
	s gGroupId=MPJObj.%Get("gGroupId")
	s pSupLocId=MPJObj.%Get("SupLoc")
	
	s Pid=..NewPid()
	k ^TMPCSSD("OPRLABEL",Pid)
	s Num=1
	while(RtnObj.success=0){
		s Obj=DPJObj.%Pop()
		q:Obj=""
		s PackageLabel=Obj.%Get("PackageLabel")
		s DictLabel=Obj.%Get("DictLabel")
		i PackageLabel="" s PackageLabel=DictLabel
		s ReqLocId=Obj.%Get("ReqLocId")
		s:ReqLocId="" ReqLocId=pSupLocId
		s PackTypeDetail=Obj.%Get("PackTypeDetail")
		s ^TMPCSSD("OPRLABEL",Pid,ReqLocId,Num)=PackageLabel
		s Num=Num+1
	}
	q:'$d(^TMPCSSD("OPRLABEL",Pid)) RtnObj.Err(-1,"","没有需要回收的信息","",0)
	
	s MainIds=""
	s ReqLocId=0
	f  s ReqLocId=$o(^TMPCSSD("OPRLABEL",Pid,ReqLocId)) q:(ReqLocId="")||(RtnObj.success'=0)  d
	.s MainId=$$CreateCallBackMain(pSupLocId,ReqLocId,gUserId,"")
	.i MainId="" d RtnObj.Err(-1,"","主单生成失败","",0)
	.q:RtnObj.success'=0
	.s Num=0
	.f  s Num=$o(^TMPCSSD("OPRLABEL",Pid,ReqLocId,Num)) q:(Num="")||(RtnObj.success'=0)  d
	..s Label=^TMPCSSD("OPRLABEL",Pid,ReqLocId,Num)
	..s LabelInfo=##class(web.CSSDHUI.Common.PackageInfoCommon).GetLabel(Label)
	..s CodeDict=$p(LabelInfo,"^",1)
	..s PackTypeDetail=$p(LabelInfo,"^",2)
	..s PackageId=$p(LabelInfo,"^",3)
	..s IsExt=##class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PackageId)
	..i IsExt="Y" d
	...;外来器械扫码回收
	...s RtnObj=..CallBackExtLabel(MainId,Label,Main)
	..e  i PackTypeDetail=1 d
	...;标牌追溯包扫码回收
	...s RtnObj=..CallBackLabel(MainId,Label,Main)
	..e  d
	...;普通循环包扫码回收
	...s RtnObj=..SaveOrdByLabel(MainId,Label)
	..q:RtnObj.success'=0
	.i MainIds="" s MainIds=MainId
	.e  s MainIds=MainIds_","_MainId
	q:RtnObj.success'=0 RtnObj
	
	k ^TMPCSSD("OPRLABEL",Pid)
	s RtnObj.rowid=MainIds
	q RtnObj
CreateCallBackMain(pSupLocId,ReqLocId,gUserId,isOPRFlag)
	n (%session,pSupLocId,ReqLocId,gUserId,isOPRFlag)
	s MainId=""
	s MainData=pSupLocId_"^"_ReqLocId_"^"_gUserId_"^"_isOPRFlag_"^^"_0
	s MainTitle="SupLoc^ReqLoc^toUser^isOPRFlag^reqType^ReqLevel"
	s MainParams=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(MainData,MainTitle)
	s RtnObj=..Update(MainParams)
	q:RtnObj.success'=0 ""
	s MainId=RtnObj.rowid
	q MainId
}

/// Description：依据明细处理主单紧急标志
/// Creator：lxt
ClassMethod UpdateCBMainUrgent(MainId) As web.CSSDHUI.RtnObj
{
	n (%session,MainId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	q:MainId="" RtnObj
	
	s CBItmId="",Flag=0
	f  s CBItmId=$o(^User.CSSDCallbackDetailNewI("CSSDCDParrefIndex",MainId,CBItmId)) q:((CBItmId="")||(Flag=1))  d
	.s LevelFlag=$lg(^User.CSSDCallbackDetailNewD(CBItmId),12)
	.s:LevelFlag=1 Flag=1
	
	&sql(Update CSSD_PackageCallback set CSSDPC_ReqLevel=:Flag where CSSDPC_Rowid=:MainId)
	i SQLCODE'=0 d RtnObj.Err(-1,"","更新回收单紧急标志失败!"_SQLCODE)
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Description：处理申请主单是否回收标志
/// Creator：lxt
ClassMethod UpdateApplyCBFlag(ApplyMainId) As web.CSSDHUI.RtnObj
{
	n (%session,ApplyMainId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	q:ApplyMainId="" RtnObj
	
	s Flag="N"
	s CBId=$O(^User.CSSDPackageCallbackI("CSSDPCPackageApplyIndex",ApplyMainId,0))
	i CBId'="" s Flag="Y"
	
	i Flag="Y" d
	.&sql(UPDATE CSSD_PackageApply SET CSSDPA_IsCount='Y' WHERE ID=:ApplyMainId)
	e  d
	.&sql(UPDATE CSSD_PackageApply SET CSSDPA_IsCount=NULL WHERE ID=:ApplyMainId)
	i SQLCODE'=0 d RtnObj.Err(-4,"","更新申请单回收中标志失败!")
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Description：处理申请主单是否完成回收标志
/// Creator：lxt
ClassMethod UpdateApplyCBCompFlag(ApplyMainId) As web.CSSDHUI.RtnObj
{
	n (%session,ApplyMainId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	q:ApplyMainId="" RtnObj
	
	s ApplyMainObj=##class(User.CSSDPackageApply).%OpenId(ApplyMainId)
	s ApplyType=ApplyMainObj.CSSDPAType
	
	s AlreadyCBFlag="Y"	//是否完成回收标志
	s ApplyItmId=""
	f  s ApplyItmId=$o(^User.CSSDPackageApplyDetailI("CSSDPADParrefIndex",ApplyMainId,ApplyItmId)) q:(ApplyItmId="")||(AlreadyCBFlag="N")  d
	.s ApplyItmObj=##Class(User.CSSDPackageApplyDetail).%OpenId(ApplyItmId)
	.q:'$IsObject(ApplyItmObj)
	.//s BackQty=ApplyDetailObj.CSSDPADBackQty
	.s ReqQty=ApplyItmObj.CSSDPADReqQty
	.
	.s CBItmId=0,SumCBQty=0
	.f  s CBItmId=$o(^User.CSSDCallbackDetailNewI("CSSDCDPackageApplyDetailDRIndex",ApplyItmId,CBItmId)) q:((CBItmId="")||(AlreadyCBFlag="N"))  d
	..s CBItmObj=##Class(User.CSSDCallbackDetailNew).%OpenId(CBItmId)
	..s CBMainObj=CBItmObj.CSSDCDParref
	..q:'$IsObject(CBMainObj)
	..d CBMainObj.%Reload()
	..s CompFlag=CBMainObj.CSSDPCComplateFlag
	..s:CompFlag'="Y" AlreadyCBFlag="N"	//存在未提交
	..s CBQty=CBItmObj.CSSDCDQty
	..s SumCBQty=SumCBQty+CBQty
	.
	.s:SumCBQty<ReqQty AlreadyCBFlag="N"	//存在未完全回收
	
	s state=5	//申请单确认状态
	i AlreadyCBFlag="Y" d	//完全回收
	.s state=2
	e  i ApplyType="1" d	//借包单回收单撤销，需要将请领单置7-归还状态
	.s state=7
	
	&sql(Update CSSD_PackageApply set CSSDPA_Flag=:state WHERE ID=:ApplyMainId)
	i SQLCODE d RtnObj.Err(-5,"","更新申请主单回收完成标志失败")
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Description：回收单提交
/// Creator：lxt
/// CreatDate:2019.10.16
/// Table:CSSD_PackageCallback,CSSD_PackageApply
/// w ##class(web.CSSDHUI.CallBack.CallBack).jsSubmitOrder("{""mainRowId"":12,""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}")
ClassMethod jsSubmitOrder(Params As %String) As %Library.String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")
	s MainIdStr=PJObj.%Get("mainRowId")
	
	ts
	s Len=$l(MainIdStr,"^")
	f i=1:1:Len q:(RtnObj.success'=0)  d
	.s MainId=$p(MainIdStr,"^",i)
	.s RtnObj=..SubmitOrder(MainId,Params)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Description：回收单提交
/// Creator：lxt
ClassMethod SubmitOrder(MainId As %String, Params As %String) As web.CSSDHUI.RtnObj
{
	n (%session,MainId,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")
	
	s gUserId=PJObj.%Get("gUserId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gLocId=PJObj.%Get("gLocId")
	s gHospId=PJObj.%Get("gHospId")
	i MainId="" d RtnObj.Err(-1,"","入参不能为空!")
	q:RtnObj.success'=0 RtnObj
	
	s MainObj=##Class(User.CSSDPackageCallback).%OpenId(MainId)
	d MainObj.%Reload()
	q:'$IsObject(MainObj) RtnObj.Err(-2,"","单据已删除")
	
	s CompFlag=MainObj.CSSDPCComplateFlag
	//s OPRFlag=MainObj.CSSDPCISOPRFlag
	s ToLocId=MainObj.CSSDPCToLocDr.%Id()
	s ApplyMainId=MainObj.CSSDPCPackageApplyDRGetObjectId()
	i CompFlag="Y" d RtnObj.Err(-2,"","已经提交单据不可以重复提交")
	q:RtnObj.success'=0 RtnObj
	
	s TmpCBItmId=$o(^User.CSSDCallbackDetailNewI("CSSDCDParrefIndex",MainId,0))
	i TmpCBItmId="" d RtnObj.Err(-3,"","无明细不能提交")
	q:RtnObj.success'=0 RtnObj
	
	s CurDate=+$h
	s CurTime=$P($h,",",2)
	&sql(Update CSSD_PackageCallback set CSSDPC_AckDate=:CurDate,CSSDPC_AckTime=:CurTime,
		CSSDPC_AckUser_DR=:gUserId, CSSDPC_ComplateFlag='Y' 
		WHERE CSSDPC_Rowid=:MainId)
	i SQLCODE'=0 d RtnObj.Err(-4,MainId,"更新提交信息失败！")
	q:RtnObj.success'=0 RtnObj
	
	//更新申请单回收完成标志
	i ApplyMainId'="" d
	.s RtnObj=..UpdateApplyCBCompFlag(ApplyMainId)
	q:RtnObj.success'=0 RtnObj
	
	//处理回收明细库存及标签
	s RtnObj=..DealDetailStatue(MainId,"C")
	q:RtnObj.success'=0 RtnObj
	
	s CBItmId=0,OprFlag="N"
	f  s CBItmId=$o(^User.CSSDCallbackDetailNewI("CSSDCDParrefIndex",MainId,CBItmId)) q:(CBItmId="")||(OprFlag="Y")  d
	.s CBItmObj=##class(User.CSSDCallbackDetailNew).%OpenId(CBItmId)
	.s AttributeCode=CBItmObj.CSSDCDPackageDr.CSSDPPackTypeDetail
	.i AttributeCode=1 s OprFlag="Y"
	
	s AppParam=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	s IsCreatDispFlag=##class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDCALLBACK","IsCreatDisp",AppParam)
	i (IsCreatDispFlag="Y")&&(OprFlag'="Y") d
	.s MainData=MainId_"^"_gLocId_"^"_gUserId_"^"_gHospId_"^"_gGroupId
	.s MainTitle="CallBackIdStr^gLocId^gUserId^gHospId^gGroupId"
	.s MainParams=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(MainData,MainTitle)
	.s RtnObj=##class(web.CSSDHUI.PackageDisp.Disp).CreateDispByCallBack(MainParams,"[]")
	.q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Description：回收单撤销
/// Creator：lxt
/// CreatDate:2019.11.16
/// Table:CSSD_CallbackDetailNew,CSSD_PackageApply,CSSD_PackageCallback
/// w ##class(web.CSSDHUI.CallBack.CallBack).jsCancelOrder(509,"{""SupLoc"":""382"",""gUserId"":""6461"",""gLocId"":""382"",""gGroupId"":""274"",""gHospId"":""2"",""ReqLoc"":"""",""toUser"":"""",""FStatus"":"""",""isOPRFlag"":""N"",""toUserDr"":"""",""fromLocDr"":"""",""toLocDr"":""382"",""FStartDate"":""2022-03-15"",""FStartTime"":"""",""FEndDate"":""2022-03-16"",""FEndTime"":""""}")
ClassMethod jsCancelOrder(mainRowId As %String, Params As %String) As %Library.String
{
	n (%session,mainRowId,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..CancelOrder(mainRowId,Params)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Description：回收单撤销
/// Creator：lxt
ClassMethod CancelOrder(mainRowId As %String, Params As %String) As web.CSSDHUI.RtnObj
{
	n (%session,mainRowId,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i mainRowId="" q RtnObj.Err(-1,"","入参不能为空!")
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-2,"","入参解析失败！")

	s gHospId=PJObj.%Get("gHospId")
	s gUserId=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s gGroupId=PJObj.%Get("gGroupId")
	s MainObj=##Class(User.CSSDPackageCallback).%OpenId(mainRowId)
	d MainObj.%Reload()
	q:'$IsObject(MainObj) RtnObj.Err(-2,"","主单已删除")
	
	s Flag=MainObj.CSSDPCComplateFlag
	i Flag'="Y" q RtnObj.Err(-3,"","未提交单据不能进行撤销操作!")
	s DispId=$o(^User.CSSDPackageDispMainI("CSSDPDMCallBackIndex",mainRowId,""))
	i DispId'="" q RtnObj.Err(-4,"","该单据已经生成发放单无法撤销!")

	s (ApplyMainId,ApplyType,CallBackItemRowId)=""
	f  s CallBackItemRowId=$o(^User.CSSDCallbackDetailNewI("CSSDCDParrefIndex",mainRowId,CallBackItemRowId)) q:((CallBackItemRowId="")||(RtnObj.success'=0)||(ApplyMainId'=""))  d
	.i $d(^User.CSSDCleanDetailPacksI("IndexCallBackDetailDr",CallBackItemRowId)) d RtnObj.Err(-5,"","该单据已清洗,不可撤销!","",0)
	.q:RtnObj.success<0
	.s CallBackItemObj=##Class(User.CSSDCallbackDetailNew).%OpenId(CallBackItemRowId)
	.s ApplyDetailObj=CallBackItemObj.CSSDCDPackageApplyDetailDR
	.q:'$IsObject(ApplyDetailObj)
	.s ApplyMainId=ApplyDetailObj.CSSDPADParref
	.q:ApplyMainId=""
	q:RtnObj.success<0 RtnObj

	&sql(Update CSSD_PackageCallback set CSSDPC_AckDate=null,CSSDPC_AckTime=null,
		CSSDPC_AckUser_DR=null, CSSDPC_ComplateFlag='N' 
		WHERE CSSDPC_Rowid=:mainRowId)
	i SQLCODE'=0 d RtnObj.Err(-8,mainRowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
	q:RtnObj.success'=0 RtnObj
	
	//更新申请单回收完成标志
	i ApplyMainId'="" d
	.s RtnObj=..UpdateApplyCBCompFlag(ApplyMainId)
	q:RtnObj.success'=0 RtnObj

	s RtnObj=..DealDetailStatue(mainRowId,"R")
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Creator:wb
/// CreatDate:2019.11.16
/// Description:提交或者撤销回收单时处理库存、外来器械标志
/// Table:CSSD_CallbackDetailNew,cssd_trans 
ClassMethod DealDetailStatue(MainId As %String, Type As %String = "C") As web.CSSDHUI.RtnObj
{
	n (%session,MainId,Type)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	q:MainId="" RtnObj
	
	s CBMainObj=##class(User.CSSDPackageCallback).%OpenId(MainId)
	s FrLocId=CBMainObj.CSSDPCFromLocDrGetObjectId()
	s ToLocId=CBMainObj.CSSDPCToLocDrGetObjectId()
	
	s CBItmId=""
	f  s CBItmId=$o(^User.CSSDCallbackDetailNewI("CSSDCDParrefIndex",MainId,CBItmId)) q:((CBItmId="")||(RtnObj.success'=0))  d
	.s CBItmObj=##class(User.CSSDCallbackDetailNew).%OpenId(CBItmId)
	.s Qty=CBItmObj.CSSDCDQty
	.s PkgId=CBItmObj.CSSDCDPackageDrGetObjectId()
	.s PkgLabel=CBItmObj.CSSDPCPackageLabel
	.s AttributeCode=CBItmObj.CSSDCDPackageDr.CSSDPPackTypeDetail
	.s IsExt=##class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PkgId)
	.//处理科室库存
	.i Type="C" s FrLocQty=-Qty,ToLocQty=Qty
	.e  s FrLocQty=Qty,ToLocQty=-Qty
	.s RtnObj=##class(web.CSSDHUI.System.LocPackageStock).UpdateCurQty(FrLocId,PkgId,FrLocQty)
	.q:RtnObj.success'=0
	.s RtnObj=##class(web.CSSDHUI.System.LocPackageStock).UpdateCurQty(ToLocId,PkgId,ToLocQty)
	.q:IsExt'="Y"	//非外来器械不继续往下处理
	.s TransId=0
	.f  s TransId=$o(^User.CSSDTransI("CallBackItm",CBItmId,TransId)) q:(TransId="")||(RtnObj.success'=0)  d
	..s TransObj=##class(User.CSSDTrans).%OpenId(TransId)
	..s Label=TransObj.CSSDTLabel
	..s FixedLabel=##class(web.CSSDHUI.Common.PackageInfoCommon).GetFixedLabel(Label)
	..s NewLabel=$E(Label,1,$l(FixedLabel)+6)	;标牌位数+6
	..;存在已经移交的外来器械则不能撤销提交
	..i Type="R" d
	...s ExtDevBindId=$o(^User.CSSDExtDevBindI("IndexCSSDExtLabel",NewLabel,0))
	...i ExtDevBindId'="" d
	....s IsTransFlag=$lg(^User.CSSDExtDevBindD(ExtDevBindId),47)
	....i IsTransFlag="Y" d RtnObj.Err(-7,"","存在已经移交的外来器械！")
	..q:RtnObj.success'=0
	..&Sql(SELECT count(1) into :Flag FROM cssd_trans WHERE cssdt_label in 
		(SELECT CSSDPP_Label FROM CSSD_PackagePack WHERE CSSDPP_NewLabel=:NewLabel) 
		AND CSSDT_Status !=:Type)
	..i ((Flag=0)&&(Type="C"))||((Flag>0)&&(Type="R")) d	//分包都回收处理/分包有一个撤销就处理
	...&sql(Update CSSD_ExtDevBind set CSSDExt_Status=:Type where CSSDExt_Label=:NewLabel)
	...i SQLCODE'=0 d RtnObj.Err(-6,"","更新外来器械标志失败！")
	.q:RtnObj.success'=0
	q RtnObj
}

/// Description:计算界面角标数量
/// Creator:lxt
/// Date:20220318
/// Table:
/// Input:Params
/// Output:Json
ClassMethod GetMarkQty(Params)
{
	n (%session,Params)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q "{}"
	
	s ApplyNum=0
	s ApplyResult=##class(%Library.ResultSet).%New("web.CSSDHUI.Apply.PackageApply:SelectAll")
	s sc=ApplyResult.Execute(Params)
	i $$$ISERR(sc) q "{}"
	While(ApplyResult.Next()){s ApplyNum=ApplyNum+1}
	d ApplyResult.Close()
	
	s RetData=ApplyNum
	s RetTitle="ApplyNum"
	s Ret=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(RetData,RetTitle)
	
	q Ret
}

}
