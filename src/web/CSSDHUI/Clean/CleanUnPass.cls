Import SQLUser

Class web.CSSDHUI.Clean.CleanUnPass Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:ban
/// CreatDate:2020.10.21
/// Description:清洗页面获取待清洗不合格包弹窗数据
/// Table: CSSD_PackageCallback,cssd_cleandetailpacks
/// Input: Params:查询条件 以及 科室ID等
/// Output:
/// Return:
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Clean.CleanUnPass","SelectUnPassClean","{""UnPassCleanStartDate"":""2022-05-29"",""gUserId"":""13922"",""gLocId"":""396"",""gGroupId"":""102"",""gHospId"":""3"",""UnPassCleanEndDate"":""2022-05-30""}")
Query SelectUnPassClean(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "PkgId,CodeDictId,PkgDesc,BackLocDesc,ApplyNo,PkgNum,AttributeId,UnPassDetailId,CleanDetailId,CallBackDetailId,CleanNum,ExtId,LevelFlag,UsedPrdoRowId,BeInfected") [ SqlProc ]
{
}

ClassMethod SelectUnPassCleanExecute(ByRef qHandle As %Binary, Params As %String = "") As %Status
{
	n (%session,qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	
	s gLocId = PJObj.%Get("gLocId")
	s gHospId=PJObj.%Get("gHospId")
	s pStartDate = PJObj.%Get("UnPassCStartDate")
	s pEndDate = PJObj.%Get("UnPassCEndDate")
	s pStartDate=..DH2L(pStartDate)
	s pEndDate=..DH2L(pEndDate)
	
	f date=pStartDate:1:pEndDate d
	.s UsedPrdoRowId="" 
	.f  s UsedPrdoRowId=$o(^User.CSSDUsedPrdoI("CSSDUPDateIndex",date,UsedPrdoRowId)) q:UsedPrdoRowId=""  d
	..q:'$d(^User.CSSDUsedPrdoD(UsedPrdoRowId))
	..
	..s UsedPrdoObj=##class(User.CSSDUsedPrdo).%OpenId(UsedPrdoRowId)
	..s UnPassDate=UsedPrdoObj.CSSDUPDate
	..s tmpUPDate=..DH2L(UnPassDate)
	..s CleanNum=UsedPrdoObj.CSSDUPNo
	..s Status=UsedPrdoObj.CSSDSPStatus
	..s UnLocId=UsedPrdoObj.CSSDUPLocGetObjectId()
	..s ShowDataFlag=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CT_Loc",UnLocId,gHospId)
	..q:ShowDataFlag="N"
	..q:Status'=1
	..
	..s UsedPrdoDetailRowId=""
	..f  s UsedPrdoDetailRowId=$o(^User.CSSDUsedPredoDetailI("CSSDUPDMainDrIndex",UsedPrdoRowId,UsedPrdoDetailRowId)) q:UsedPrdoDetailRowId=""  d
	...;q:'$d(^User.CSSDUsedPredoDetailD(UsedPrdoDetailRowId))
	...
	...s UsedPrdoDetailObj=##class(User.CSSDUsedPredoDetail).%OpenId(UsedPrdoDetailRowId)
	...s PkgId=UsedPrdoDetailObj.CSSDUPDPkgGetObjectId()
	...s PkgObj=##class(User.CSSDPackage).%OpenId(PkgId)
	...s PkgDesc=PkgObj.CSSDPDesc
	...s AttributeId=PkgObj.CSSDPPackTypeDetail
	...
	...s (OprLabel,FromLocDesc,ApplyNo,CallBackDetailId,ExtId,LevelFlag,CleanDetailId)=""
	...s UnPassDetailId=UsedPrdoDetailRowId
	...s CleanDetailObj=UsedPrdoDetailObj.CSSDUPDCleanDetailDr
	...s PkgNum = UsedPrdoDetailObj.CSSDUPDPkgNum
	...s UsedPrdoDetailStatus=UsedPrdoDetailObj.CSSDUPDStates
	...s CodeDictId = UsedPrdoDetailObj.CSSDUPDBarCode
	...q:UsedPrdoDetailStatus'=""
	...
	...i $IsObject(CleanDetailObj) d
	....s CleanDetailId=CleanDetailObj.%Id()
	....s LevelFlag=CleanDetailObj.CSSDCDPLevelFlag
	....i $IsObject(CleanDetailObj.CSSDCDPExtDR)  s ExtId=CleanDetailObj.CSSDCDPExtDR.%Id()
	....s CallBackDetailObj = CleanDetailObj.CSSDCDPCallBackDetailDr
	....q:'$IsObject(CallBackDetailObj)
	....
	....s CallBackDetailId=CallBackDetailObj.%Id()
	....s BackLocDesc = CallBackDetailObj.CSSDCDParref.CSSDPCFromLocDr.CTLOCDesc
	....s ApplyNo = CallBackDetailObj.CSSDCDParref.CSSDPCSerialNo
	....s BeInfected=CallBackDetailObj.CSSDCDPBeInfected
	....
	...i AttributeId=1 d	//标牌追溯包获取固定条码
	....s SubStr=CleanNum_","_PkgId_","_CodeDictId
	....q:$d(OutPutFlag("Opr",SubStr))
	....
	....s OutPutFlag("Opr",SubStr)=""
	....d OutPutRowOrd
	...i AttributeId=10 d
	....s SubStr=CleanNum_","_PkgId_","_ApplyNo
	....q:$d(OutPutFlag("ZK",SubStr))
	....
	....s OutPutFlag("ZK",SubStr)=""
	....d OutPutRowOrd
	...i AttributeId=2 d
	....s SubStr=CleanNum_","_PkgId_","_ApplyNo
	....q:$d(OutPutFlag("Ord",SubStr))
	....
	....s OutPutFlag("Ord",SubStr)=""
	....d OutPutRowOrd
	Quit $$$OK
OutPutRowOrd
	s Data=$lb(PkgId,CodeDictId,PkgDesc,BackLocDesc,ApplyNo,PkgNum,AttributeId,UnPassDetailId,CleanDetailId,CallBackDetailId,CleanNum,ExtId,LevelFlag,UsedPrdoRowId,BeInfected)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:ban
/// CreatDate:2020.10.16
/// Description:清洗页面待清洗不合格包弹窗添加消毒包功能
/// Table: CSSD_UsedPredoDetail , CSSD_UsedPredoDetail
/// Input: Params ：科室等信息 , mainId : 主表ID
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.Clean.CleanUnPass).SaveUnPassClean(^tmpllkjgfj,^tmpookfv)
ClassMethod SaveUnPassClean(Params, MainId) As %Library.String
{
	n (%session,Params,MainId)
	s MethodName=$ClassName()_".SaveUnPassClean"
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	i MainId="" d RtnObj.Err(-2,"","请选择清洗主表")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s RtnObj=##class(web.CSSDHUI.Clean.CleanInfo).CheckBeforeAddItm(MainId)
	i RtnObj.success<0 q RtnObj.Json()
	
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s PkgId=Obj.%Get("PkgId")
		s PkgDesc=Obj.%Get("PkgDesc")
		s CodeDictId=Obj.%Get("CodeDictId")
		s PkgNum=Obj.%Get("PkgNum")
		s AttributeId=Obj.%Get("AttributeId")		//包属性
		s UsedPrdoRowId=Obj.%Get("UsedPrdoRowId")	//不合格单据ID
		s UPStatus=$lg(^User.CSSDUsedPrdoD(UsedPrdoRowId),6)
		i UPStatus'=1 d RtnObj.Err(-3,"","未确认不合格登记！")
		q:RtnObj.success'=0
		
		s UnPassDetailId=Obj.%Get("UnPassDetailId")  //不合格明细ID
		s CleanStatus=$lg(^User.CSSDUsedPredoDetailD(UnPassDetailId),16)
		i CleanStatus="Y" d RtnObj.Err(-3,"","已添加,勿重复添加！")
		q:RtnObj.success'=0
		
		s CleanDetailId=Obj.%Get("CleanDetailId")	//不合格时绑定的清洗明细ID
		s LevelFlag=Obj.%Get("LevelFlag")
		s CallBackDetailId=Obj.%Get("CallBackDetailId")	//专科包对应的回收明细ID
		s ExtId=Obj.%Get("ExtId")	//外来器械登记表ID
		
		;不合格的清洗明细，重新清洗时，需要绑定原不合格数据绑定的清洗明细id，用于删除清洗明细时进行状态回置
		&sql(insert into cssd_cleandetailpacks(CSSDCDP_CleanMainDR, CSSDPR_Package_DR, CSSDCDP_Qty, CSSDCDP_IsCrtLbl, CSSDCDP_CreatedQty,CSSDCDP_CallBackDetailDr,CSSDCDP_BindCleanDetailId,CSSDCDP_Label,CSSDCDP_TotalQty,CSSDCDP_ExtDR,CSSDCDP_Flag,CSSDCDP_LevelFlag) values 
			(:MainId,:PkgId,:PkgNum,0,0,:CallBackDetailId,:CleanDetailId,:CodeDictId,:PkgNum,:ExtId,'N',:LevelFlag))
		i SQLCODE'=0 d RtnObj.Err(-2,"","插入数据失败"_MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg))
		q:RtnObj.success'=0
		
		s NewCleanDetailId = %ROWID
		i CleanDetailId'="" d
		.;更新原有不合格清洗的明细数据，绑定新的清洗明细Id
		.&sql(update cssd_cleandetailpacks set CSSDCDP_CleanDetailId=:NewCleanDetailId where ID=:CleanDetailId)
		.i SQLCODE'=0 d RtnObj.Err(-3,"","重新清洗绑定明细数据失败"_MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg))
		q:RtnObj.success'=0
		
		i ExtId'="" d
		.s RtnObj=..UpdateExtCleanState(ExtId,MainId)	//清洗不合格重新清洗，需要修改登记表状态以及清洗表状态
		q:RtnObj.success'=0
		
		&sql(UPDATE CSSD_UsedPredoDetail SET CSSDUPD_States = 'Y' WHERE CSSDUPD_CleanDetailDr=:CleanDetailId)
		i SQLCODE'=0  d RtnObj.Err(-5,"","更新清洗不合格明细数据失败"_MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg))
		q:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2020.10.21
/// Description:清洗页面获取待清洗不合格包弹窗数据
/// Table: CSSD_PackageCallback ,cssd_cleandetailpacks
/// Input: Params : 查询条件 以及 科室ID等
/// Output:
/// Return:
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Clean.CleanUnPass","SelectUnPassSter",^tmpoolkjhdc)
Query SelectUnPassSter(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "SterDate,PkgId,PkgDesc,Label,SterNum,UnPassSterDetailID,AttributeId,PkgClassDesc,UnPassNum,ReasonId,ReasonDesc") [ SqlProc ]
{
}

ClassMethod SelectUnPassSterExecute(ByRef qHandle As %Binary, Params As %String = "") As %Status
{
	n (%session,qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	
	s pStartDate = PJObj.%Get("UnPassSStartDate")
	s pEndDate = PJObj.%Get("UnPassSEndDate")
	s gLocId = PJObj.%Get("gLocId")
	s gHospId=PJObj.%Get("gHospId")
	s pStartDate=..DH2L(pStartDate)
	s pEndDate=..DH2L(pEndDate)
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT csp.CSSDSP_Dt As SterDate,csp.CSSDSP_No as UnPassNum,csp.CSSDSP_SterNo AS SterNum,cspd.CSSDSPD_Num AS SterLabel,"
			_" cspd.CSSDSP_Package_DR AS PkgId,cspd.CSSDSP_Package_DR->CSSDP_Desc AS PkgDesc,cspd.ID AS UnPassSterDetailID,"
			_" cspd.CSSDSPD_Resion as ReasonId FROM CSSD_SterPredo csp,CSSD_SterPredoDetail cspd "
			_" WHERE csp.ID=cspd.CSSDSPD_MainDr AND csp.CSSDSP_Status=1 AND cspd.CSSDSP_States IS NULL "	
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s SterDate = Result.Data("SterDate")
		s TmpDate=..DH2L(SterDate)
		continue:((pStartDate'="")&(TmpDate<pStartDate))
		continue:((pEndDate'="")&(TmpDate>pEndDate))
		s PkgDesc = Result.Data("PkgDesc")
		s PkgId = Result.Data("PkgId")
		s SterNum = Result.Data("SterNum")
		s UnPassNum = Result.Data("UnPassNum")	//不合格单号
		s ReasonId = Result.Data("ReasonId")	//不合格原因
		s ReasonDesc=""
		i ReasonId'="" d
		.s ReasonObj=##class(User.CSSDSteCheckReason).%OpenId(ReasonId)
		.s ReasonDesc=ReasonObj.CSSDSteFailDesc
		s Label = Result.Data("SterLabel")
		s UnPassSterDetailID = Result.Data("UnPassSterDetailID")
		s PkgInfo=##Class(User.CSSDPackage).%OpenId(PkgId)
		s HospitalId=PkgInfo.CSSDPHospital.%Id()
		continue:(HospitalId'=gHospId)
		s AttributeId=PkgInfo.CSSDPPackTypeDetail
		s PkgClassDesc=PkgInfo.CSSDPPackClass.CSSDPCPackCalssName
		continue:AttributeId=7   ;非循环包不需要清洗
		i AttributeId=1 d
		.s PkgDesc = ##class(web.CSSDHUI.Common.PackageInfoCommon).GetCodeDictName(Label)
		
		s IsState=""
		s SterDetailId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSLabel",Label,""),-1)
		i SterDetailId'="" d
		.s IsState=##class(User.CSSDPackageSterilize).%OpenId(SterDetailId).CSSDPSStates
		.;如果合格和空不让重复添加
		continue:IsState'="N"
		d OutPutRowSter
	}
	Quit $$$OK
OutPutRowSter
	s Data=$lb(SterDate,PkgId,PkgDesc,Label,SterNum,UnPassSterDetailID,AttributeId,PkgClassDesc,UnPassNum,ReasonId,ReasonDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:ban
/// CreatDate:2020.10.26
/// Description:清洗页面待灭菌不合格包弹窗添加消毒包功能
/// Table: cssd_cleandetailpacks CSSD_SterPredoDetail
/// Input: Params ：消毒包明细表ID,清洗数量等信息 , mainId : 主表ID
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.Clean.CleanUnPass).SaveUnPassSter("[{""SterDate"":""2023-03-17 09:17:12"",""PkgId"":""228"",""PkgDesc"":""手术室妇科腹腔镜001002"",""Label"":""104009002000002"",""SterNum"":""202303170012103"",""UnPassSterDetailID"":""71"",""AttributeId"":""1"",""PkgClassDesc"":""手术室器械包"",""UnPassNum"":""20230300002"",""ReasonId"":""4"",""ReasonDesc"":""标签字迹不清晰""}]","155")
ClassMethod SaveUnPassSter(Params, MainId) As %Library.String
{
	n (%session,Params,MainId)
	s MethodName=$ClassName()_".SaveUnPassSter"
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	i MainId="" d RtnObj.Err(-2,"","请选择清洗主表")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s RtnObj=##class(web.CSSDHUI.Clean.CleanInfo).CheckBeforeAddItm(MainId)
	i RtnObj.success<0 q RtnObj.Json()
	
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s PkgId=Obj.%Get("PkgId")
		s PkgObj= ##Class(User.CSSDPackage).%OpenId(PkgId)
		d PkgObj.%Reload()
		;s AttributeId=PkgObj.CSSDPPackTypeDetail
		
		s PkgClassId=PkgObj.CSSDPPackClassGetObjectId()
		s Label=Obj.%Get("Label")
		s UnPassSterDetailID=Obj.%Get("UnPassSterDetailID")
		s AttributeId=Obj.%Get("AttributeId")
		s FixedLabel=##class(web.CSSDHUI.Common.PackageInfoCommon).GetFixedLabel(Label)
		s RtnObj=##class(web.CSSDHUI.PackageSterilize.SterilizeItem).IsCleanOrSter(Label)
		q:RtnObj.success'=0
		
		s Qty=1,ExtFlag="N"
		s IsExt=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PkgId)
		s (CallBackDetailId,CleanDetailId,SterPredoCleanDetail)=""
		i AttributeId=1 d
		.i IsExt="Y" d	//外来器械灭菌不合格新增数据
		..i FixedLabel="" d RtnObj.Err(-1,"","外来器械"_Label_"对应的标牌错误!") q
		..
		..s ExtId=$o(^User.CSSDExtDevBindI("IndexCSSDExtCodeIsTransfer",FixedLabel,"N",""))
		..i ExtId="" d RtnObj.Err(-1,"","清洗前，请先做外来器械登记！")	q
		..
		..s RtnObj=..UpdateExtCleanState(ExtId,MainId)	//灭菌不合格重新清洗，需要修改登记表状态以及清洗表状态
		..s regId=$o(^User.CSSDCleanDetailPacksI("IndexMainDrPkgdr",MainId,PkgId,""))
		..i regId="" d
		...&sql(insert into cssd_cleandetailpacks(CSSDCDP_CleanMainDR, CSSDPR_Package_DR, CSSDCDP_Qty, CSSDCDP_IsCrtLbl, CSSDCDP_CreatedQty,CSSDCDP_CallBackDetailDr,CSSDCDP_BindCleanDetailId,CSSDCDP_Label,CSSDCDP_TotalQty,CSSDCDP_ExtDR,CSSDCDP_Flag,CSSDCDP_LevelFlag) values (:MainId,:PkgId,1,0,0,:CallBackDetailId,:CleanDetailId,:FixedLabel,1,:ExtId,'N',:ExtFlag))
		...i SQLCODE'=0 d RtnObj.Err(-2,"","插入数据失败"_MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg))
		...q:RtnObj.success'=0
		...
		..e  d
		...&sql(UPDATE CSSD_CleanDetailPacks SET CSSDCDP_Qty=CSSDCDP_Qty+:Qty, CSSDCDP_TotalQty=CSSDCDP_TotalQty+:Qty WHERE ID =:regId)
		...i SQLCODE'=0 d RtnObj.Err(-2,"","更新数据失败"_MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg))
		...q:RtnObj.success'=0
		.q:RtnObj.success'=0
		.
		.e  d	//标牌追溯包灭菌不合格新增数据
		..&sql(insert into cssd_cleandetailpacks(CSSDCDP_CleanMainDR, CSSDPR_Package_DR, CSSDCDP_Qty, CSSDCDP_IsCrtLbl, CSSDCDP_CreatedQty,CSSDCDP_CallBackDetailDr,CSSDCDP_CleanDetailId,CSSDCDP_Label,CSSDCDP_TotalQty,CSSDCDP_Flag) values (:MainId,:PkgId,1,0,0,:CallBackDetailId,:CleanDetailId,:FixedLabel,1,:ExtFlag))
		..i SQLCODE'=0 d RtnObj.Err(-2,"","插入数据失败"_MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg))
		..s SterPredoCleanDetail=%ROWID	;用以绑定灭菌不合格子表 回置状态
		..
		e  d	//非标牌追溯包灭菌不合格新增数据
		.s detailId=""
		.s detailId=$o(^User.CSSDCleanDetailPacksI("IndexMainDrPkgdr",MainId,PkgId,""))
		.i detailId="" d
		..&sql(insert into cssd_cleandetailpacks(CSSDCDP_CleanMainDR, CSSDPR_Package_DR, CSSDCDP_Qty, CSSDCDP_IsCrtLbl, CSSDCDP_CreatedQty,CSSDCDP_TotalQty,CSSDCDP_Flag) values (:MainId,:PkgId,:Qty,0,0,:Qty,:ExtFlag))
		..i SQLCODE'=0 d RtnObj.Err(-3,"","插入清洗明细失败")
		..s SterPredoCleanDetail=%ROWID
		..
		.e  d
		..&sql(update cssd_cleandetailpacks set CSSDCDP_Qty=CSSDCDP_Qty+:Qty,CSSDCDP_TotalQty=CSSDCDP_TotalQty+:Qty  where ID=:detailId)
		..i SQLCODE'=0 d RtnObj.Err(-4,"","更新清洗明细失败")
		..s SterPredoCleanDetail=detailId
		q:RtnObj.success'=0
		
		&sql(UPDATE CSSD_SterPredoDetail SET CSSDSP_States = 'Y',CSSDSP_CleanDetailDr=:SterPredoCleanDetail WHERE ID=:UnPassSterDetailID)
		i SQLCODE'=0 d RtnObj.Err(-4,"","更新不合格明细数据失败"_MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg))
		q:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2020.12.11
/// Description:根据外来器械标签以及主单据更新外来器械表状态以及清洗表状态
/// Table: CSSD_ExtDevBind
/// Input: extId : 外来器械表ID  nowState:当前状态
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.Clean.CleanUnPass).UpdateExtCleanState("100200001","1")
ClassMethod UpdateExtCleanState(extId As %String, mainId As %String) As web.CSSDHUI.RtnObj
{
	n (%session,extId,mainId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s extObj = ##class(User.CSSDExtDevBind).%OpenId(extId)
	d extObj.%Reload()
	s nowState = extObj.CSSDExtStatus
	s Qty = extObj.CSSDExtRecNum
	&sql(UPDATE CSSD_ExtDevBind SET CSSDExt_Status ='W' WHERE CSSDExt_Rowid=:extId)
	i SQLCODE'=0  d RtnObj.Err(-1,"","外来器械更新登记状态失败！")
	q:RtnObj.success'=0 RtnObj
	
	&sql(UPDATE CSSD_Clean SET CSSDC_Flag= 'E' WHERE ID=:mainId)
	i SQLCODE'=0  d RtnObj.Err(-1,"","清洗主表更新外来状态失败！")
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Creator:wb
/// CreatDate:2020.11.26
/// Description:清洗页面获取待添加外来器械包弹窗数据
/// Table:  cssd_cleandetailpacks
/// Input: Params
/// Output:
/// Return:
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Clean.CleanUnPass","SelectUnExt","{""StartDate"":""2023-01-10"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""EndDate"":""2023-01-11""}")
Query SelectUnExt(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,PkgId,PkgDesc,AttributeDesc,CodeDictId,SickerName,RegistNo,RecNum,VenDesc,Status,StatusDesc,OperatorType,OperatorTypeDesc,CallBackDetailId,LevelFlag") [ SqlProc ]
{
}

ClassMethod SelectUnExtExecute(ByRef qHandle As %Binary, Params As %String = "") As %Status
{
	n (%session,qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	
	s gHospId = PJObj.%Get("gHospId")
	s pStartDate = PJObj.%Get("EStartDate")
	s pEndDate = PJObj.%Get("EEndDate")
	s pStartDate=..DH2L(pStartDate)
	s pEndDate=..DH2L(pEndDate)
	
	S Pid=..NewPid()
	k ^CSSDTMPID(Pid,"CallBack")
	f Date=pStartDate:1:pEndDate d
	.s ExtCallBackId=""
	.f  s ExtCallBackId=$o(^User.CSSDExtCallBackLabelI("CSSDECLDateIndex",Date,ExtCallBackId)) q:ExtCallBackId=""  d
	..s ExtCallBackObj=##class(User.CSSDExtCallBackLabel).%OpenId(ExtCallBackId)
	..q:'$IsObject(ExtCallBackObj)
	..s Qty = ExtCallBackObj.CSSDECLQty
	..s ExtObj=ExtCallBackObj.CSSDECLParrefDr
	..q:'$IsObject(ExtObj)
	..s Status = ExtCallBackObj.CSSDECLStatus
	..s CallBackDetailObj=ExtCallBackObj.CSSDECLCallBackDetailDr
	..q:CallBackDetailObj'="" ;回收的外来器械显示在回收明细弹框
	..s PackageObj=ExtObj.CSSDExtInstruName
	..q:'$IsObject(PackageObj)
	..s HospitalId=PackageObj.CSSDPHospital.%Id()
	..q:(HospitalId'=gHospId)
	..q:((Status'="B")&&(Status'="C"))
	..s RowId = ExtObj.%Id()
	..s ExtStatus=ExtObj.CSSDExtStatus
	..q:((Status'="B")&&(Status'="C"))
	..
	..s CompFlag="Y",LevelFlag="0",CallBackDetailId=""
	..i $IsObject(CallBackDetailObj) d
	...s CallBackDetailId=CallBackDetailObj.%Id()
	...s CallBackId=CallBackDetailObj.CSSDCDParrefGetObjectId()
	...q:CallBackId=""
	...s CompFlag=$lg(^User.CSSDPackageCallbackD(CallBackId),14)
	...s CBLevelFlag=$lg(^User.CSSDPackageCallbackD(CallBackId),26)
	...i CBLevelFlag="1" s LevelFlag="1"
	..q:(CompFlag'="Y")
	..
	..i '$d(^CSSDTMPID(Pid,"CallBack",RowId)) d
	...s ^CSSDTMPID(Pid,"CallBack",RowId)=RowId_"^"_CallBackDetailId_"^"_Qty_"^"_LevelFlag
	..e  d
	...s CallBackDetailStr=$p(^CSSDTMPID(Pid,"CallBack",RowId),"^",2)
	...i (","_CallBackDetailStr_",")'[(","_CallBackDetailId_",") d
	....s CallBackDetailStr=CallBackDetailStr_","_CallBackDetailId
	...s Qty=$p(^CSSDTMPID(Pid,"CallBack",RowId),"^",3)+1
	...i LevelFlag="1" s ExtLevel="1"
	...e  s ExtLevel=$p(^CSSDTMPID(Pid,"CallBack",RowId),"^",4)
	...s ^CSSDTMPID(Pid,"CallBack",RowId)=RowId_"^"_CallBackDetailStr_"^"_Qty_"^"_ExtLevel
	
	s Sub=""
	f  s Sub=$o(^CSSDTMPID(Pid,"CallBack",Sub)) q:Sub=""  d
	.s Sdata=$g(^CSSDTMPID(Pid,"CallBack",Sub))
	.s RowId = $P(Sdata,"^",1)
	.s CallBackDetailStr=$P(Sdata,"^",2)
	.s RecNum = $P(Sdata,"^",3)
	.s LevelFlag = $P(Sdata,"^",4)
	.s ExtObj=##class(User.CSSDExtDevBind).%OpenId(RowId)
	.s Status = ExtObj.CSSDExtStatus
	.q:Status="T"
	.s RecDate = ExtObj.CSSDExtRecDate
	.s RecDate=..DH2L(RecDate)
	.s PkgObj=ExtObj.CSSDExtInstruName
	.s PkgId = PkgObj.%Id()
	.s PkgDesc = PkgObj.CSSDPDesc
	.s AttributeDesc = PkgObj.CSSDPPackTypeDetail
	.s CodeDict =ExtObj.CSSDExtCode
	.s SickerName = ExtObj.CSSDExtSickerName
	.s RegistNo = ExtObj.CSSDExtHospitalNo
	.s VenDesc = ExtObj.CSSDExtFirm.CSSDVenName
	.s OperatorType = ExtObj.CSSDExtOperatorType
	.s ExtRecNum=ExtObj.CSSDExtRecNum
	.q:RecNum'=ExtRecNum	//标签未全部回收的不允许清洗
	.s StatusDesc=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetStatusChinese(Status)
	.s OperatorTypeDesc=""
	.s:OperatorType=0 OperatorTypeDesc="择期手术"
	.s:OperatorType=1 OperatorTypeDesc="急诊手术"
	.d OutPutRowExt
	
	k ^CSSDTMPID(Pid,"CallBack")
	Quit $$$OK
OutPutRowExt
	s Data=$lb(RowId,PkgId,PkgDesc,AttributeDesc,CodeDict,SickerName,RegistNo,RecNum,VenDesc,Status,StatusDesc,OperatorType,OperatorTypeDesc,CallBackDetailStr,LevelFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:wb
/// CreatDate:2020.11.26
/// Description:清洗页面待添加外来器械包弹窗添加消毒包功能
/// Table: cssd_cleandetailpacks 
/// Input: Params ：消毒包明细表ID,清洗数量等信息 , mainId : 主表ID
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.Clean.CleanUnPass).SaveUnExt("[{""RowId"":""23"",""PkgId"":""2225"",""PkgDesc"":""外来器械test02(N)"",""AttributeDesc"":""1"",""CodeDictId"":""106508006"",""SickerName"":"""",""RegistNo"":"""",""RecNum"":""2"",""VenDesc"":""厂商01"",""Status"":""B"",""StatusDesc"":""登记"",""OperatorType"":""0"",""OperatorTypeDesc"":""择期手术"",""CallBackDetailId"":"""",""LevelFlag"":""0""},{""RowId"":""22"",""PkgId"":""2225"",""PkgDesc"":""外来器械test02(N)"",""AttributeDesc"":""1"",""CodeDictId"":""106508005"",""SickerName"":"""",""RegistNo"":"""",""RecNum"":""2"",""VenDesc"":""厂商01"",""Status"":""C"",""StatusDesc"":""已回收"",""OperatorType"":""0"",""OperatorTypeDesc"":""择期手术"",""CallBackDetailId"":""144,145"",""LevelFlag"":""0""},{""RowId"":""20"",""PkgId"":""2225"",""PkgDesc"":""外来器械test02(N)"",""AttributeDesc"":""1"",""CodeDictId"":""106508002"",""SickerName"":"""",""RegistNo"":"""",""RecNum"":""1"",""VenDesc"":""厂商01"",""Status"":""C"",""StatusDesc"":""已回收"",""OperatorType"":""0"",""OperatorTypeDesc"":""择期手术"",""CallBackDetailId"":""146"",""LevelFlag"":""0""}]","15")
ClassMethod SaveUnExt(Params, MainId) As %Library.String
{
	n (%session,Params,MainId)
	s MethodName=$ClassName()_".SaveUnExt"
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!").Json()
	
	i MainId="" d RtnObj.Err(-2,"","请选择清洗主表")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s RtnObj=##class(web.CSSDHUI.Clean.CleanInfo).CheckBeforeAddItm(MainId)
	i RtnObj.success<0 q RtnObj.Json()
	
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s RowId=Obj.%Get("RowId")
		q:RowId=""
		s PkgId=Obj.%Get("PkgId")
		s CodeDictId=Obj.%Get("CodeDictId")
		s Status=Obj.%Get("Status")
		s LevelFlag=Obj.%Get("OperatorType")	//急诊的需要标识紧急
		s CallBackDetailId=Obj.%Get("CallBackDetailId")	//回收明细表对于的id串
		s FirstCallBackDetailId=$p(CallBackDetailId,",",1)	//暂只记录一个id
		s:LevelFlag'=1 LevelFlag=Obj.%Get("LevelFlag")
		s AttributeId=Obj.%Get("AttributeId")
		s RecNum=Obj.%Get("RecNum")
		s ExtObj=##class(User.CSSDExtDevBind).%OpenId(RowId)
		s Status=ExtObj.CSSDExtStatus
		i (Status'="B")&&(Status'="C") d RtnObj.Err(-2,"","已添加请勿重复添加!")
		q:RtnObj.success'=0
		
		s Flag="N"		//二次清洗标志
		i Status="C" s Flag="Y"
		
		s CleanDetailId=""
		&sql(insert into cssd_cleandetailpacks(CSSDCDP_CleanMainDR, CSSDPR_Package_DR, 
			CSSDCDP_Qty, CSSDCDP_IsCrtLbl, CSSDCDP_CreatedQty,CSSDCDP_CallBackDetailDr,
			CSSDCDP_CleanDetailId,CSSDCDP_Label,CSSDCDP_ExtDR,CSSDCDP_Flag,CSSDCDP_TotalQty,CSSDCDP_LevelFlag) values 
			(:MainId,:PkgId,:RecNum,0,0,:FirstCallBackDetailId,:CleanDetailId,:CodeDictId,:RowId,:Flag,:RecNum,:LevelFlag))
		i SQLCODE'=0 d RtnObj.Err(-2,"","插入数据失败"_MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg))
		q:RtnObj.success'=0
		
		&sql(UPDATE CSSD_Clean SET CSSDC_Flag = 'E' WHERE ID=:MainId)
		i SQLCODE'=0 d RtnObj.Err(-5,"","更新外来器械标志失败"_MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg))
		q:RtnObj.success'=0
		
		s RtnObj=##Class(web.CSSDHUI.Clean.CleanInfo).UpdateExtState(RowId,Status)
		q:RtnObj.success'=0
		
		//处理回收明细
		i CallBackDetailId'="" d
		.s Len=$l(CallBackDetailId,",")
		.f i=1:1:Len q:(RtnObj.success'=0)  d
		..s TmpCallBackDetailId=$p(CallBackDetailId,",",i)
		..&sql(update CSSD_CallBackDetailNew set CSSDCD_IsClean='Y' where CSSDCD_Rowid=:TmpCallBackDetailId)
		..i SQLCODE'=0 d RtnObj.Err(-3,"","更新数据失败"_MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg))
		q:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:zn
/// CreatDate:2020.12.10
/// Description:清洗页面获取待清洗标牌追溯包弹窗数据
/// Table:  CSSD_CallBackDetailNew
/// Input: Params
/// Output:
/// Return:
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Clean.CleanUnPass","SelectUnOpr","{""StartDate"":""2022-12-20"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""EndDate"":""2022-12-22""}")
Query SelectUnOpr(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,PkgId,PkgDesc,AttributeDesc,CodeDict,BackQty,BackLocId,BackLocDesc,LevelFlag,SterTypeColor,BackNo,BeInfected") [ SqlProc ]
{
}

ClassMethod SelectUnOprExecute(ByRef qHandle As %Binary, Params As %String = "") As %Status
{
	n (%session,qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	
	s gHospId=PJObj.%Get("gHospId")
	s pStartDate = PJObj.%Get("StartDate")
	s pEndDate = PJObj.%Get("EndDate")
	s pStartDate=..DH2L(pStartDate)
	s pEndDate=..DH2L(pEndDate)
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr=" SELECT CSSDCD_Rowid AS RowId, CSSDCD_Package_DR AS PkgId,CSSDCD_Package_DR->CSSDP_Desc AS PkgDesc,CSSDCD_Parref_DR->CSSDPC_SerialNo as SerialNo,"
			_" CSSDCD_Package_DR->CSSDP_PackTypeDetail AS AttributeId,CSSDPC_DictLabel AS CodeDict ,CSSDCD_Parref_DR->CSSDPC_FromLoc_DR as BackLocId,"
			_" CSSDCD_Parref_DR->CSSDPC_AckDate AS OprCallDate,CSSDCD_Parref_DR->CSSDPC_FromLoc_DR->CTLOC_Desc as BackLocDesc "
			_" ,CSSDCD_LevelFlag,CSSDCDP_BeInfected,CSSDCD_Parref_DR->CSSDPC_ConfirmFlag as ConfirmFlag "
			_" FROM CSSD_CallBackDetailNew WHERE CSSDCD_IsClean IS NULL AND  CSSDCD_Package_DR->CSSDP_PackTypeDetail=1 "
			_" and CSSDCD_Parref_DR->CSSDPC_AckDate between "_pStartDate_" and "_pEndDate
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s PkgId = Result.Data("PkgId")
		s PkgInfo=##class(User.CSSDPackage).%OpenId(PkgId)
		s PkgClassId=PkgInfo.CSSDPPackClass.%Id()
		s HospitalId=PkgInfo.CSSDPHospital.%Id()
		continue:(HospitalId'=gHospId)
		s IsExt=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PkgId)
		continue:IsExt="Y"
		s PkgDesc = Result.Data("PkgDesc")
		s AttributeId = Result.Data("AttributeId")
		s CodeDict = Result.Data("CodeDict")
		s OprCallDate = Result.Data("OprCallDate")
		s BackLocId = Result.Data("BackLocId")
		s BackLocDesc = Result.Data("BackLocDesc")
		s LevelFlag = Result.Data("CSSDCD_LevelFlag")
		s BackNo = Result.Data("SerialNo")
		s BeInfected=Result.Data("CSSDCDP_BeInfected")
		s BackQty=1
		s SterTypeColor=$p(##class(web.CSSDHUI.PackageInfo.Package).GetSterTypeInfo(PkgId),"^",3)
		d OutPutRowOpr
	}
	Quit $$$OK
OutPutRowOpr
	s Data=$lb(RowId,PkgId,PkgDesc,AttributeDesc,CodeDict,BackQty,BackLocId,BackLocDesc,LevelFlag,SterTypeColor,BackNo,BeInfected)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Modifiers:lxt 202203
/// w ##Class(web.CSSDHUI.Clean.CleanUnPass).jsSaveUnOpr(^tmpllkokkkl,^tmpllokl)
ClassMethod jsSaveUnOpr(Params, Main) As %Library.String
{
	n (%session,Params,Main)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..SaveUnOpr(Params,Main)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:zn
/// Modifiers:lxt 202203
/// CreatDate:2020.12.10
/// Description:清洗单添加标牌追溯包（通过扫码或列表选择）
/// Table: cssd_cleandetailpacks ,CSSD_CallBackDetailNew
/// Input: Params ：消毒包明细表ID,清洗数量等信息 , mainId : 主表ID
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.Clean.CleanUnPass).SaveUnOpr("[{""PkgDr"":""264"",""PkgName"":""外来器械包"",""packTypeDetail"":""1"",""Code"":""000271013"",""SickerName"":"""",""No"":""1111"",""RecNum"":""4"",""VenName"":""阿里巴巴""}]","112")
ClassMethod SaveUnOpr(Params, Main) As web.CSSDHUI.RtnObj
{
	n (%session,Params,Main)
	s MethodName=$ClassName()_".SaveUnOpr"
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s MainObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=MainObj.%FromJSON(Main)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败")
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")
	
	s MainId=MainObj.%Get("MainId")
	s gHospId = MainObj.%Get("gHospId")
	s glocId = MainObj.%Get("gLocId")
	s gUserId=MainObj.%Get("gUserId")
	s gGroupId=MainObj.%Get("gGroupId")
	i MainId="" q RtnObj.Err(-2,"","请选择清洗主表")
	
	s RtnObj=##class(web.CSSDHUI.Clean.CleanInfo).CheckBeforeAddItm(MainId)
	q:RtnObj.success<0 RtnObj
	
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s RowId=Obj.%Get("RowId")
		s PkgId=Obj.%Get("PkgId")
		s Qty=Obj.%Get("BackQty")
		s LevelFlag=Obj.%Get("LevelFlag")
		s CodeDictId=Obj.%Get("CodeDict")
		i RowId'="" d
		.s CleanDetailPacksId=$o(^User.CSSDCleanDetailPacksI("IndexCallBackDetailDr",RowId,0))
		.i CleanDetailPacksId'="" d RtnObj.Err(-2,"","标牌"_CodeDictId_"已经清洗!")
		q:RtnObj.success'=0
		
		s ParamData=gUserId_"^"_glocId_"^"_gGroupId_"^"_gHospId
		s ParamTitle="gUserId^gLocId^gGroupId^gHospId"
		s Param=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(ParamData,ParamTitle)
		s CheckTimeFlag=##class(web.CSSDHUI.Clean.CleanInfo).CheckCleanMinInterval(CodeDictId,MainId,Param)
		i CheckTimeFlag="N" d RtnObj.Err(-1,"","距上次清洗时间过短") q
		
		s Flag=##class(web.CSSDHUI.Clean.CleanInfo).GetIsClean(MainId,CodeDictId)
		i Flag'=0 d RtnObj.Err(-1,"","重复扫描标签！") q
		
		//处理外来器械
		s ExtId="",ExtFlag="N"
		s PkgObj=##Class(User.CSSDPackage).%OpenId(PkgId)
		s PkgClass=PkgObj.CSSDPPackClass.%Id()
		s IsExt=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PkgId)
		i IsExt="Y" d
		.s ExtId=$o(^User.CSSDExtDevBindI("IndexCSSDExtCodeIsTransfer",CodeDictId,"N",""))
		.i ExtId="" d RtnObj.Err(-1,"","清洗前，请先做外来器械登记！") q
		.
		.s ExtObj = ##class(User.CSSDExtDevBind).%OpenId(ExtId)
		.d ExtObj.%Reload()
		.s NowState = ExtObj.CSSDExtStatus
		.i ((NowState'="B")&&(NowState'="C")) d RtnObj.Err(-1,"","不是登记和回收状态的外来器械包")	q
		.q:RtnObj.success'=0
		.
		.s Qty = ExtObj.CSSDExtRecNum
		.s RtnObj=##class(web.CSSDHUI.Clean.CleanInfo).UpdateExtState(ExtId,NowState)
		.q:RtnObj.success'=0
		.
		.i NowState="B" d
		..&sql(UPDATE CSSD_Clean SET CSSDC_Flag= 'E' WHERE ID=:MainId)
		..i SQLCODE'=0 d RtnObj.Err(-1,"","更新清洗单外来器械标志失败")
		..
		.e  i NowState="C" d
		..s ExtFlag="Y"
		q:RtnObj.success'=0
		
		//处理回收明细
		i RowId'="" d
		.&sql(update CSSD_CallBackDetailNew set CSSDCD_IsClean='Y' where CSSDPC_DictLabel=:CodeDictId AND CSSDCD_IsClean IS NULL)
		.i SQLCODE'=0 d RtnObj.Err(-3,"","更新数据失败"_MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg))
		q:RtnObj.success'=0
		
		//新增清洗单明细
		s IsCrtLbl=0
		&sql(Insert into CSSD_CleanDetailPacks (
			CSSDCDP_CleanMainDR,CSSDPR_Package_DR,CSSDCDP_Label,CSSDCDP_IsCrtLbl,
			CSSDCDP_Qty,CSSDCDP_TotalQty,CSSDCDP_CallBackDetailDr,
			CSSDCDP_LevelFlag,CSSDCDP_ExtDR,CSSDCDP_Flag,CSSDCDP_CreatedQty) 
			values (:MainId,:PkgId,:CodeDictId,:IsCrtLbl,
			:Qty,:Qty,:RowId,:LevelFlag,:ExtId,:ExtFlag,0))
		i SQLCODE'=0 d RtnObj.Err(-2,"","插入数据失败"_MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg)) q
		q:RtnObj.success'=0
		
		s CleanDetailId=%ROWID
		s RtnObj.rowid=CleanDetailId
	}
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

}
