Import SQLUser

Class web.CSSDHUI.Clean.CleanInfo Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:wn
/// CreatDate:2020.1.9
/// Description:清洗页面获取清洗方式
/// Table:cssd_cleantype
/// Input: cleanCode:页面输入的清洗方式号
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.Clean.CleanInfo).GetCleanType("11","{""BDPHospital"":""2"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}")
ClassMethod GetCleanType(CleanCode As %String, Params As %String)
{
	n (%session,CleanCode,Params)
	q:CleanCode="" "{}"

	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q "{}"

	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)

	s (RowId,Ret,CleanTypeId,CleanTypeMode,CleanTypeUseFlag,IsManualTemp)=""
	f  s RowId=$o(^User.CSSDCleanTypeI("IndexCleanCode",CleanCode,RowId)) q:(+RowId=0)||(Ret="Y")  d
	.s result =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_CleanType",RowId,pHospId)
	.q:result="N"
	.
	.s CleanTypeObj = ##class(User.CSSDCleanType).%OpenId(RowId)
	.d CleanTypeObj.%Reload()
	.q:'$IsObject(CleanTypeObj)
	.
	.s CleanTypeId=RowId
	.s CleanTypeMode=CleanTypeObj.CSSDCTCleanMode
	.s CleanTypeUseFlag=CleanTypeObj.CSSDCTNotUseFlag
	.s IsManualTemp=CleanTypeObj.CSSDCTIsManualTemp
	.q:CleanTypeUseFlag'="Y"
	.
	.s Ret="Y"
	q:Ret'="Y" "{}"

	s Data = CleanTypeId_"^"_CleanTypeMode_"^"_CleanTypeUseFlag_"^"_IsManualTemp
	s Title="CleanTypeId^CleanTypeMode^CleanTypeUseFlag^CleanTypeIsManualTemp"
	s CleanTypeStr=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q CleanTypeStr
}

/// Creator:wn
/// CreatDate:2020.1.9
/// Description:清洗页面获取清洗程序
/// Table:CSSD_BaseCode
/// Input: cleanCode:页面输入的清洗程序号
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.Clean.CleanInfo).GetCleanPro(^templxt("11"),^templxt("22"))
ClassMethod GetCleanPro(CleanCode As %String, Params As %String)
{
	n (%session,CleanCode,Params)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q "{}"

	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)

	s (RowId,ret,CleanProId,CleanProCode,CleanProName,UseFlag)=""
	f  s RowId=$o(^User.CSSDBaseCodeI("IndexCSSDDCCodeType",CleanCode,"1001",RowId)) q:(+RowId=0)||(ret'="")  d
	.s result =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_BaseCode",RowId,pHospId)
	.q:result="N"
	.
	.s BaseCodeObj = ##class(User.CSSDBaseCode).%OpenId(RowId)
	.q:'$IsObject(BaseCodeObj)
	.
	.d BaseCodeObj.%Reload()
	.s CleanProId=RowId
	.s CleanProCode=BaseCodeObj.CSSDDCCode
	.s CleanProName=BaseCodeObj.CSSDDCName
	.s UseFlag=BaseCodeObj.CSSDDCNotUseFlag
	.q:UseFlag'="Y"
	.
	.s ret="Y"
	q:ret'="Y" "{}"

	s CleanProData = CleanProId_"^"_CleanProCode_"^"_CleanProName_"^"_UseFlag
	s CleanProTitleStr="CleanProId^CleanProCode^CleanProName^UseFlag"
	s CleanProStr=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(CleanProData,CleanProTitleStr)
	q CleanProStr
}

/// Creator:wn
/// Modifiers:lxt 202203
/// CreatDate:2020.1.10
/// Description:清洗页面查询数据
/// Table:cssd_clean
/// Input: Params：页面传过来的查询条件
/// Output:
/// Return:
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Clean.CleanInfo","SelectAll",^tmpllkjjl)
Query SelectAll(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,CleanNum,MachineNo,MachineAlias,CleanDate,CleanerName,ChkerName,IsCheck,CleanTypeDesc,CleanProDesc,IsCmtEnterMachine,LevelFlag,MachineFileDesc,CleanLoc,CleanBasketDesc,BeInfected") [ SqlProc ]
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary, Params As %String = "") As %Status
{
	n (%session,qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK

	s pCleanId = PJObj.%Get("CleanId")
	s pStartDate = PJObj.%Get("StartDate")
	s pEndDate=PJObj.%Get("EndDate")
	s pCleanTypeId = PJObj.%Get("CleanType")
	s pCleanMachineId = PJObj.%Get("CleanMachine")
	s pCleanStroId = PJObj.%Get("CleanStro")
	s pCleanerId = PJObj.%Get("Cleaner")
	s gLocId = PJObj.%Get("gLocId")
	s pCleanLoc=PJObj.%Get("CleanLoc")
	s pCleanBasket=PJObj.%Get("CleanBasket")
	i (pCleanId="")&&(pStartDate="")&&(pEndDate="") q $$$OK

	s pStartDate=..DH2L(pStartDate)
	s pEndDate=..DH2L(pEndDate)

	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="select ID ,cssdc_no as CleanNum,CSSDC_MachineConfigDr,CSSDC_MachineConfigDr->cssdmc_alias as MachineAlias,cssdc_machineno as MachineNo,"
			_" cssdc_date as CleanDate,cssdc_time as CleanTime,"
			_" cssdc_cleanerdr as CleanerId,cssdc_cleanerdr->ssusr_name as CleanerName,CSSDC_Loc_DR,CSSDC_Loc_DR->CTLOC_Desc as CleanLoc,"
			_" cssdc_chkerdr->ssusr_name as ChkerName,cssdc_iscreatelbl as iscreatelbl,"
			_" CSSDC_CleanProgress as pro,cssdc_cleanmethod CleanTypeId,cssdc_cleanmethod->CSSDCT_CleanMode as CleanTypeDesc,"
			_" CSSDC_IsCmtEnterMachine as IsCmtEnterMachine,CSSDC_Result as CheckResult,CSSDC_FileName,CSSDC_CleanVehicleLbl "
			_" from cssd_clean where cssdc_date between "_pStartDate_" and "_pEndDate

	i pCleanId'="" s SqlStr=SqlStr_" and ID="_pCleanId
	.;s (pStartDate,pEndDate,pCleanTypeId,pCleanMachineId,pCleanStroId,pCleanerId)=""
	i pCleanLoc'="" s SqlStr=SqlStr_" and CSSDC_Loc_DR='"_pCleanLoc_"' "
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("ID")
		s CleanNum = Result.Data("CleanNum")
		s MachineNo = Result.Data("MachineNo")
		s CleanDate = Result.Data("CleanDate")
		s MachineAlias = Result.Data("MachineAlias")
		s CleanTime = Result.Data("CleanTime")
		s CleanerId = Result.Data("CleanerId")
		s CleanerName = Result.Data("CleanerName")
		s ChkerName = Result.Data("ChkerName")
		s CleanTypeId = Result.Data("CleanTypeId")
		s CleanTypeDesc = Result.Data("CleanTypeDesc")
		s IsCmtEnterMachine = Result.Data("IsCmtEnterMachine")
		s IsCheck = Result.Data("CheckResult")
		s CleanLoc = Result.Data("CleanLoc")
		s CleanBasketId = Result.Data("CSSDC_CleanVehicleLbl")		//清洗架
		s CleanProId = Result.Data("pro")
		s CleanProDesc=""
		i CleanProId'="" d
		.s CleanProObj=##class(User.CSSDBaseCode).%OpenId(CleanProId)
		.i $IsObject(CleanProObj) s CleanProDesc=CleanProObj.CSSDDCName

		s MachineConfigId = Result.Data("CSSDC_MachineConfigDr")
		s LevelFlag=..GetLevelFlag(RowId)
		s BeInfected=..GetBeInfected(RowId)
		s MachineFileDesc = Result.Data("CSSDC_FileName")
		continue:((pCleanerId'="")&&(CleanerId'="")&&(pCleanerId'=CleanerId))
		continue:((pCleanTypeId'="")&&(CleanTypeId'="")&&(pCleanTypeId'=CleanTypeId))
		continue:((pCleanStroId'="")&&(CleanProId'="")&&(pCleanStroId'=CleanProId))
		continue:((pCleanMachineId'="")&&(MachineConfigId'="")&&(pCleanMachineId'=MachineConfigId))
		continue:((pCleanBasket'="")&&(pCleanBasket'=CleanBasketId))
		s CleanBasketDesc=""
		s:CleanBasketId'="" CleanBasketDesc=$lg(^User.CSSDCodeDictD(CleanBasketId),6)
		s CleanDate=..DL2H(CleanDate)
		s CleanTime=..TL2H(CleanTime)
		s CleanDateTime=CleanDate_" "_CleanTime
		d OutPutRow
	}
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,CleanNum,MachineNo,MachineAlias,CleanDateTime,
		CleanerName,ChkerName,IsCheck,CleanTypeDesc,CleanProDesc,
		IsCmtEnterMachine,LevelFlag,MachineFileDesc,CleanLoc,CleanBasketDesc,BeInfected)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:wn
/// CreatDate:2020.11.06
/// Description:判断清洗主表的明细是否存在紧急包
/// Table:CSSD_CleanDetailPacks
/// Input: ID 清洗主表ID
/// Output:
/// Return: 存在 1 不存在-1
/// w ##Class(web.CSSDHUI.Clean.CleanInfo).GetLevelFlag("30")
ClassMethod GetLevelFlag(ID) As %Library.String
{
	s (LevelFlag,cleandetailId)=""
	f  s cleandetailId=$o(^User.CSSDCleanDetailPacksI("IndexMainDr",ID,cleandetailId)) q:((cleandetailId="")||(LevelFlag=1))  d
	.s cleandetailobj=##class(User.CSSDCleanDetailPacks).%OpenId(cleandetailId)
	.d cleandetailobj.%Reload()
	.s LevelFlag=cleandetailobj.CSSDCDPLevelFlag
	q LevelFlag
}

/// Description:判断清洗主表的明细是否存在感染包
ClassMethod GetBeInfected(ID) As %Library.String
{
	s DetailId="",BeInfected="N",CBDetailId=""
	f  s DetailId=$o(^User.CSSDCleanDetailPacksI("IndexMainDr",ID,DetailId)) q:(DetailId="")||(BeInfected="Y")  d
	.s Obj=##class(User.CSSDCleanDetailPacks).%OpenId(DetailId)
	.d Obj.%Reload()
	.s CBDetailId=Obj.CSSDCDPCallBackDetailDrGetObjectId()
	.q:CBDetailId=""
	.s CBDetailObj=##class(User.CSSDCallbackDetailNew).%OpenId(CBDetailId)
	.q:'$IsObject(CBDetailObj)
	.d CBDetailObj.%Reload()
	.s BeInfected=CBDetailObj.CSSDCDPBeInfected
	q BeInfected
}

/// Creator:wn
/// Modifiers:lxt 202203
/// CreatDate:2020.1.10
/// Description:清洗页面新增单据信息
/// Table:CSSD_Clean
/// Input: Params：所要增加的单据的清洗信息
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.Clean.CleanInfo).jsSaveClean(^tmplkjll)
ClassMethod jsSaveClean(Params) As %Library.String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s RtnObj=..SaveClean(Params)
	q RtnObj.Json()
}

/// Modifiers:lxt 202203
ClassMethod SaveClean(Params) As web.CSSDHUI.RtnObj
{
	n (%session,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败！")

	s curDate=+$h
	s curTime=$p($h,",",2)

	s pCleanTypeId=PJObj.%Get("CleanType")
	s pCleanerId=PJObj.%Get("Cleaner")
	s pCleanStroId=PJObj.%Get("CleanStro")
	s pCleanMachineId=PJObj.%Get("CleanMachine")
	s pCleanBasket=PJObj.%Get("CleanBasket")
	s gUserId=PJObj.%Get("gUserId")
	s gHospId=PJObj.%Get("gHospId")
	s gLocId=PJObj.%Get("gLocId")
	s gCleanLoc=PJObj.%Get("CleanLoc")

	i pCleanMachineId="" s CleanMachineNo="0"
	e  s CleanMachineNo=$List(^User.CSSDMachineConfigD(pCleanMachineId),3)

	ts
	s AppName="Clean"
	s Ret=..sssLock(AppName)
	i Ret'=0 tro  q RtnObj.Err(-99,"","生成单号加锁失败")

	s No=..CreateCleanNo(CleanMachineNo,gCleanLoc,gHospId)	//生成清洗批号
	i No="" tro  d ..sssUnLock(AppName) q RtnObj.Err(-1,"","单号为空")

	s Iscmt="0"
	&sql(Insert into CSSD_Clean
		(CSSDC_CleanMethod,CSSDC_MachineNo,CSSDC_CleanerDR,CSSDC_CleanProgress,CSSDC_No,
		CSSDC_Time,CSSDC_Date,CSSDC_Loc_DR,CSSDC_IsCmtEnterMachine,CSSDC_MachineConfigDr,CSSDC_CleanVehicleLbl,
		CSSDC_CreateDate,CSSDC_CreateTime)
		values(
		:pCleanTypeId,:CleanMachineNo,:pCleanerId,:pCleanStroId,:No,
		:curTime,:curDate,:gCleanLoc,:Iscmt,:pCleanMachineId,:pCleanBasket,
		:curDate,:curTime
		))
	d ..sssUnLock(AppName)
	i SQLCODE'=0 tro  q RtnObj.Err(-1,"","插入数据失败:SQLCODE"_SQLCODE)

	s MainId=%ROWID

	;清洗架自动获取装载的消毒包
	i pCleanBasket'="" d
	.s BasketId=""
	.f  s BasketId=$o(^User.CSSDBasketPackDetailI("CSSDCBPBSKLabelIsCleanIndex",pCleanBasket,"N",BasketId)) q:BasketId=""  d
	..s CodeDictObj=##class(User.CSSDCodeDict).%OpenId(pCleanBasket)
	..d CodeDictObj.%Reload()
	..s CodeDict=CodeDictObj.CSSDCDCode ;清洗架标牌
	..s RtnObj = ..SaveCleanBasket(MainId,CodeDict)
	..q:RtnObj.success'=0
	i RtnObj.success'=0 tro  q RtnObj.Err(-100,"","加载清洗架明细失败")

	tc
	s RtnObj.rowid=MainId
	q RtnObj
}

/// Creator:wn
/// Modifiers:lxt 202203
/// CreatDate:2020.1.10
/// Description:清洗页面新增单据信息,新增时带入篮筐绑定的该清洗数据
/// Table:CSSD_Clean
/// Input: Params：所要增加的单据的清洗信息
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.Clean.CleanInfo).SaveCleanBasket("26","300001002")
ClassMethod SaveCleanBasket(MainId, BasketLabel) As web.CSSDHUI.RtnObj
{
	n (%session,MainId,BasketLabel)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()

	s RtnObj=##class(web.CSSDHUI.Clean.CleanInfo).CheckBeforeAddItm(MainId)
	i RtnObj.success<0 q RtnObj

	s CleanObj=##class(User.CSSDClean).%OpenId(MainId)
	s MachineId=CleanObj.CSSDCMachineGetObjectId()
	;q:'$IsObject(MachineObj) RtnObj.Err(-3,"","使用清洗架装载必须选择对应清洗机！")
	s CodeDictId=$o(^User.CSSDCodeDictI("CSSDCDCodeIndex",BasketLabel,0))
	s BasketPackId=$o(^User.CSSDBasketPackDetailI("CSSDCBPBSKLabelIsCleanIndex",CodeDictId,"N",0))
	q:BasketPackId="" RtnObj.Err(-3,"","清洗架没有要清洗的消毒包")

	s PackMachineId=$lg(^User.CSSDBasketPackDetailD(BasketPackId),10)
	;q:(MachineId'=PackMachineId) RtnObj.Err(-3,"","使用清洗架装载必须选择对应清洗机！")

	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT ID,CSSDCBP_Package_DR AS PkgId,CSSDCBP_PackageLabel, CSSDCBP_Qty,CSSDCBP_MachineNo_DR,CSSDCBP_CallBackDetail_DR"
			_" FROM CSSD_BasketPackDetail WHERE isnull(CSSDCBP_IsClean,'N')='N' "
			_" and CSSDCBP_BSKLabel='"_CodeDictId_"'"

	s count=0
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId=Result.Data("ID")
		s PkgId=Result.Data("PkgId")
		s Qty=Result.Data("CSSDCBP_Qty")
		s PkgLabel=Result.Data("CSSDCBP_PackageLabel")
		s CallBackDetailId=Result.Data("CSSDCBP_CallBackDetail_DR")
		s DetailId=""
		i PkgLabel'="" d
		.s (CallId,LevelFlag,ComplateFlag,CallMainId,UseFlag,CycleCount)=""
		.
		.//处理外来器械
		.s ExtId=""
		.s IsExt=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PkgId)
		.i IsExt="Y" d
		..s ExtId=$o(^User.CSSDExtDevBindI("IndexCSSDExtCodeIsTransfer",PkgLabel,"N",""))
		..i ExtId="" d RtnObj.Err(-1,"","清洗前，请先做外来器械登记！") q
		..
		..s ExtObj = ##class(User.CSSDExtDevBind).%OpenId(ExtId)
		..d ExtObj.%Reload()
		..s NowState = ExtObj.CSSDExtStatus
		..i ((NowState'="B")&&(NowState'="C")) d RtnObj.Err(-1,"","不是登记和回收状态的外来器械包")	q
		.q:RtnObj.success'=0
		.
		.&sql(select max(ID) into :TmpCleanItmId from CSSD_CleanDetailPacks where CSSDCDP_Label=:PkgLabel AND CSSDCDP_IsCrtLbl = 0)
		.i (IsExt'="Y")&&(SQLCODE=0)&&(TmpCleanItmId'="") d RtnObj.Err(-1,"","该标牌追溯包已清洗未打包！") q
		.
		.&sql(select max(CSSDCD_Rowid) into :tmpCallId from CSSD_CallBackDetailNew where CSSDPC_DictLabel =:PkgLabel AND CSSDCD_IsClean IS NULL)
		.i SQLCODE=0 s CallId=tmpCallId
		.i CallId'="" s CallMainId=$lg(^User.CSSDCallbackDetailNewD(CallId),2)
		.i CallMainId'="" s ComplateFlag=$lg((^User.CSSDPackageCallbackD(CallMainId)),14)
		.
		.&sql(select CSSDCD_CycleCount,CSSDCD_NotUseFlag into :CycleCount,:UseFlag from CSSD_CodeDict WHERE CSSDCD_Code =:PkgLabel)
		.i (IsExt'="Y")&&(CycleCount'=0)&&(ComplateFlag'="Y")  d RtnObj.Err(-2,"","该标牌追溯包未回收或已添加！") q
		.
		.i (UseFlag="N")  d RtnObj.Err(-3,"","该标牌追溯包已被停用，请核对！") q
		.
		.i CallId'="" s LevelFlag=##class(User.CSSDCallbackDetailNew).%OpenId(CallId).CSSDCDLevelFlag
		.
		.s OprObj={}
		.s OprObj.RowId=CallId,OprObj.PkgId=PkgId,OprObj.CodeDict=PkgLabel,OprObj.BackQty=1,OprObj.LevelFlag=LevelFlag
		.s OprStr="["_OprObj.%ToJSON()_"]"
		.s MainObj={}
		.s MainObj.MainId=MainId
		.s MainStr=MainObj.%ToJSON()
		.s RtnObj=##class(web.CSSDHUI.Clean.CleanUnPass).SaveUnOpr(OprStr,MainStr)
		.s DetailId=RtnObj.rowid
		e  i CallBackDetailId="" d
		.s ParamsData=MainId_"^"_PkgId_"^"_Qty
		.s ParamsTitle="MainId^PkgId^PkgNum"
		.s Params=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(ParamsData,ParamsTitle)
		.s RtnObj=..SaveCommonPackage(Params)
		.s DetailId=RtnObj.rowid
		e  d
		.s CallBackObj={}
		.s DetailList=$g(^User.CSSDCallbackDetailNewD(CallBackDetailId))
		.s CallBackQty=$lg(DetailList,4)
		.s MaterialId=$lg(DetailList,11)
		.s ReqLevel=$lg(DetailList,12)
		.s CallBackObj.CallBackItmId=CallBackDetailId
		.s CallBackObj.PkgId=PkgId
		.s CallBackObj.WillQty=Qty
		.s CallBackObj.MaterialId=MaterialId
		.s CallBackObj.ReqLevel=ReqLevel
		.s CallBackObj.BackQty=CallBackQty
		.s CallBackStr="["_CallBackObj.%ToJSON()_"]"
		.s RtnObj=..SaveUnCleanOrd(CallBackStr,MainId)
		.s DetailId=RtnObj.rowid
		q:RtnObj.success'=0

		&sql(UPDATE CSSD_BasketPackDetail SET CSSDCBP_IsClean = 'Y',CSSDCBP_CleanDr = :DetailId WHERE ID=:RowId)
		i SQLCODE'=0 d RtnObj.Err(-3,"","更新清洗架数据失败！") q

		s count=count+1
	}
	i count=0 d RtnObj.Err(-3,"","清洗筐没有要清洗数据！"_RtnObj.msg)
	q:RtnObj.success'=0 RtnObj

	&sql(UPDATE CSSD_Clean SET CSSDC_CleanVehicleLbl = :CodeDictId WHERE ID=:MainId)
	i SQLCODE'=0 d RtnObj.Err(-3,"","更新清洗表失败！")

	q RtnObj
}

/// Creator:wn
/// CreatDate:2020.1.10
/// Description:生成清洗批号
/// Table:CSSD_Clean
/// Input: MachineNo : 清洗批号
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.Clean.CleanInfo).CreateCleanNo("1",1,2)
ClassMethod CreateCleanNo(MachineNo, gLocId, gHospId) As %String
{
	n (%session,MachineNo,gLocId,gHospId)
	s date=$zd(+$h,8)
	s dateday=+$h
	s regid=$o(^User.CSSDCleanI("IndexMachineNoDateLocDr",MachineNo,dateday,gLocId,""),-1)
	i regid'="" d
	.s maxNo=$List(^User.CSSDCleanD(regid),8)

	e  d
	.s maxNo=""
	s CleanNum=+$e(maxNo,$l(maxNo)-4,$l(maxNo))
	s CleanNum=CleanNum+1
	s CleanNum=$tr($j(CleanNum,5)," ","0")
	s CleanNo=date_MachineNo_gHospId_CleanNum
	q CleanNo
}

/// w ##class(web.CSSDHUI.Clean.CleanInfo).jsCmtEnterMachine(^templxt("jsCmtEnterMachine"))
ClassMethod jsCmtEnterMachine(Params) As %Library.String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s RtnObj=..CmtEnterMachine(Params)
	q RtnObj.Json()
}

/// Creator:wn
/// CreatDate:2020.1.10
/// Description:清洗页面确认清洗功能
/// Table:CSSD_Clean
/// Input: Params：主表单据的ID
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.Clean.CleanInfo).CmtEnterMachine("6","")
ClassMethod CmtEnterMachine(Params As %String)
{
	n (%session,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()

	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj

	s pId=PJObj.%Get("Id")
	s pStartTime=PJObj.%Get("StartTime")
	s pStartTime=..TH2L(pStartTime)
	s curTime=$p($h,",",2)
	s curDate=+$h
	s:pStartTime="" pStartTime=curTime

	s CleanMainObj=##Class(User.CSSDClean).%OpenId(pId)
	s MachineId=CleanMainObj.CSSDCMachineGetObjectId()
	s MachineNo=CleanMainObj.CSSDCMachineNo				;机器号
	s CmtFlag=CleanMainObj.CSSDCIsCmtEnterMachine
	i CmtFlag="1" q RtnObj.Err(-2,"","该单据已清洗,请核实!","",0)

	//获取上一次清洗状态及时间
	s CompareCleanRecordTime=""
	i MachineId'="" d
	.s MachineObj=##class(User.CSSDMachineConfig).%OpenId(MachineId)
	.q:'$IsObject(MachineObj)
	.
	.d MachineObj.%Reload()
	.s MulBinFlag=MachineObj.CSSDMCMulBinFlag
	.s RowId=0
	.f  s RowId=$o(^User.CSSDCleanI("IndexMachineDRDateDr",MachineId,curDate,RowId)) q:(RowId="")||(RtnObj.success'=0)  d
	..s CleanObj=##class(User.CSSDClean).%OpenId(RowId)
	..q:'$IsObject(CleanObj)
	..
	..d CleanObj.%Reload()
	..s IsCmtEnter=CleanObj.CSSDCIsCmtEnterMachine	;确认清洗
	..s CleanRecordTime=CleanObj.CSSDCTime
	..s Result=CleanObj.CSSDCResult					;验收
	..i Result=1 s CompareCleanRecordTime=CleanRecordTime	//只取验收的上一次清洗机的验收时间
	..i ((Result="")&&(IsCmtEnter="1")&&(MulBinFlag'="Y")) d RtnObj.Err(-2,"","该清洗机存在未验收信息，不能确认清洗！")
	q:RtnObj.success'=0 RtnObj

	q:(CompareCleanRecordTime>pStartTime) RtnObj.Err(-3,"","清洗时间必须大于前一次"_..TL2H(CompareCleanRecordTime))

	ts
	s AppName="Clean"_pId
	s Ret=..sssLock(AppName)
	i Ret'=0 tro  q RtnObj.Err(-99,"","加锁失败")

	//处理清洗单状态及清洗时间
	&sql(update cssd_clean set CSSDC_IsCmtEnterMachine='1',cssdc_time=:pStartTime,cssdc_date=:curDate where ID=:pId)
	i SQLCODE'=0 tro  d ..sssUnLock(AppName) q RtnObj.Err(-2,"","确认清洗失败!")

	//处理清洗机运行次数
	i MachineId'="" d
	.s Num=..GetMachineDayCycle(MachineId)
	.&sql(update cssd_clean set CSSDC_Num=:Num where ID=:pId)
	.i SQLCODE'=0  d RtnObj.Err(-5,"","更新清洗对应机器运行次数失败")
	i RtnObj.success'=0 tro  d ..sssUnLock(AppName) q RtnObj

	tc

	s RtnObj.rowid=pId
	q RtnObj
}

/// w ##class(web.CSSDHUI.Clean.CleanInfo).jsCancelEnterMachine(^tmpplll)
ClassMethod jsCancelEnterMachine(Params) As %Library.String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s RtnObj=..CancelEnterMachine(Params)
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2021.4.25
/// Description:清洗页面取消清洗功能
/// Table:CSSD_Clean
/// Input: CleanId：主表单据的ID
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.Clean.CleanInfo).CancelEnterMachine("55")
ClassMethod CancelEnterMachine(Params As %String)
{
	n (%session,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj

	s CleanId=PJObj.%Get("CleanId")
	q:CleanId="" RtnObj.Err(-1,"","请选择清洗单","",0)

	s CleanMainObj=##Class(User.CSSDClean).%OpenId(CleanId)
	d CleanMainObj.%Reload()
	s IsCmtEnterMachine = CleanMainObj.CSSDCIsCmtEnterMachine	;是否已确认清洗(0:未确认清洗、1：确认清洗)
	s IsCheck = CleanMainObj.CSSDCResult	//;是否进行验收(""：未验收、0：验收不合格、1：验收合格)

	q:IsCmtEnterMachine="0" RtnObj.Err(-2,"","未确认清洗，不能取消！","",0)
	q:IsCheck'="" RtnObj.Err(-3,"","已验收，不能取消！","",0)

	s AppName="Clean"_CleanId
	s Ret=..sssLock(AppName)
	i Ret'=0 q RtnObj.Err(-99,"","加锁失败")

	s ItemId=""
	f  s ItemId=$o(^User.CSSDCleanDetailPacksI("IndexMainDr",CleanId,ItemId)) q:ItemId=""  d
	.s States=$lg(^User.CSSDCleanDetailPacksD(ItemId),14)
	.s TotalQty=$lg(^User.CSSDCleanDetailPacksD(ItemId),22)
	.s UnPassQty=$lg(^User.CSSDCleanDetailPacksD(ItemId),17)
	.i UnPassQty>0 d
	..&sql(update CSSD_CleanDetailPacks set CSSDCDP_Qty=:TotalQty,CSSDCDP_States=NULL,CSSDCDP_Reason=NULL,CSSDCDP_UnPassQty=NULL where ID=:ItemId)
	..i SQLCODE'=0 d RtnObj.Err(-5,"","取消清洗失败!")
	q:RtnObj.success'=0 RtnObj

	&sql(update cssd_clean set CSSDC_IsCmtEnterMachine='0' where ID=:CleanId)
	i SQLCODE'=0 d RtnObj.Err(-4,"","取消清洗失败!")
	q:RtnObj.success'=0 RtnObj

	d ..sssUnLock(AppName)
	q RtnObj
}

/// Creator:ban
/// CreatDate:2022.4.15
/// Description:取消清洗验收功能
/// Table:CSSD_Clean
/// Input: Params：主表单据的
/// Output:
/// Return:
/// w ##class(web.CSSDHUI.Clean.CleanInfo).jsCleanCheckCancel(^templxt("jsCancelEnterMachine"))
ClassMethod jsCleanCheckCancel(Params) As %Library.String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..CleanCheckCancel(Params)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2022.4.15
/// Description:清洗验收页面的取消验收功能
/// Table:CSSD_Clean
/// Input: Params：主表单据的ID
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.Clean.CleanInfo).CleanCheckCancel(^tempyj("cc"))
ClassMethod CleanCheckCancel(Params As %String)
{
	n (%session,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i (Params="") d RtnObj.Err(-1,"","参数是空!","",0)
	q:RtnObj.success'=0 RtnObj

	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-2,"","入参解析失败！","",0)
	q:RtnObj.success'=0 RtnObj

	s MainId=PJObj.%Get("ID")
	s CleanMainObj=##class(User.CSSDClean).%OpenId(MainId)
	i '$IsObject(CleanMainObj) d RtnObj.Err(-2,"","未获取到清洗信息!","",0)
	q:RtnObj.success'=0 RtnObj

	s CleanFlag=CleanMainObj.CSSDCFlag
	s IsCheck=CleanMainObj.CSSDCResult
	s IsCreateLbl=CleanMainObj.CSSDCIsCreateLbl
	i IsCreateLbl=1 d RtnObj.Err(-5,"","已生成标签,不能取消验收!","",0)
	q:RtnObj.success'=0 RtnObj

	s (Flag,result,curTime,currDate,checker)=""
	s CleanDetailId=""
	f  s CleanDetailId=$o(^User.CSSDCleanDetailPacksI("IndexMainDr",MainId,CleanDetailId)) q:(CleanDetailId="")||(RtnObj.success'=0)  d
	.s CleanDetailObj=##class(User.CSSDCleanDetailPacks).%OpenId(CleanDetailId)
	.d CleanDetailObj.%Reload()
	.q:'$IsObject(CleanDetailObj)
	.;判断是否部分生成了标签
	.s CreatedQty=CleanDetailObj.CSSDCDPCreatedQty
	.i CreatedQty>0 d RtnObj.Err(-51,"","已生成部分标签,不能取消验收!","",0)
	.q:RtnObj.success'=0
	.
	.s (State,Reason)=""
	.s ExtDR=CleanDetailObj.CSSDCDPExtDR
	.s TotalQty=CleanDetailObj.CSSDCDPTotalQty
	.i ExtDR="" s Flag="Y"	;证明该单据中不止是 只有外来器械,是混合清洗的单据
	.;取消验收，明细数据状态恢复，包括部分清洗数、不合格数、原因、验收状态回置
	.&sql(update cssd_cleandetailpacks set CSSDCDP_States=:State,CSSDCDP_Reason=:Reason,CSSDCDP_Qty=:TotalQty,CSSDCDP_UnPassQty='0' where ID=:CleanDetailId)
	.i SQLCODE'=0 d RtnObj.Err(-4,"","更新清洗子表失败!")
	.q:RtnObj.success'=0
	.
	.;i ExtDR'="" d
	..;&sql(Update CSSD_ExtDevBind set CSSDExt_Status='B' where CSSDExt_Rowid=:ExtDR)
	..;i SQLCODE'=0 d RtnObj.Err(-1,"","取消验收操作，外来器械更新状态失败！")
	.q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj

	&sql(update cssd_clean set CSSDC_Result=:result,cssdc_chktime=:curTime,CSSDC_ChkDate=:currDate,cssdc_ChkerDR=:checker where ID=:MainId)
	i SQLCODE'=0 d RtnObj.Err(-3,"","更新清洗主表失败!")
	q:RtnObj.success'=0 RtnObj

	//清洗验收不合格时，取消验收需要根据不合格登记信息是否提交控制删除
	s UsedPrdoId=$o(^User.CSSDUsedPrdoI("IndexClean",MainId,""))
	i UsedPrdoId'="" d
	.s UsedPrdoObj = ##class(User.CSSDUsedPrdo).%OpenId(UsedPrdoId)
	.s States=UsedPrdoObj.CSSDSPStatus
	.i States=1 d RtnObj.Err(-2,"","清洗对应的不合格登记信息已提交，不能取消验收！")
	.q:RtnObj.success'=0
	.
	.s UsedPrdoDetailId=$o(^User.CSSDUsedPredoDetailI("CSSDUPDMainDrIndex",UsedPrdoId,""))
	.i UsedPrdoDetailId'="" d
	..&sql(DELETE FROM CSSD_UsedPredoDetail WHERE CSSDUPD_MainDr=:UsedPrdoId)
	..i SQLCODE'=0 d RtnObj.Err(-4,"","取消验收操作，删除不合格登记详情信息报错！")
	..q:RtnObj.success'=0
	.q:RtnObj.success'=0
	.
	.&sql(DELETE FROM CSSD_UsedPredo WHERE ID=:UsedPrdoId)
	.i SQLCODE'=0 d RtnObj.Err(-5,"","取消验收操作，删除不合格登记信息报错！")
	.q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj

	q RtnObj
}

/// Creator:wn
/// CreatDate:2020.1.10
/// Description:清洗验收页面验收合格功能
/// Table:CSSD_Clean
/// Input: Params：主表单据的ID、登录人以及科室等信息
/// Output:
/// Return:
/// w ##class(web.CSSDHUI.Clean.CleanInfo).jsCleanCheck(^templxt("jsCancelEnterMachine"))
ClassMethod jsCleanCheck(Params, ID As %String) As %Library.String
{
	n (%session,Params,ID)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..CleanCheck(Params,ID)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:wn
/// CreatDate:2020.1.10
/// Description:清洗验收页面验收合格功能
/// Table:CSSD_Clean
/// Input: Params：主表单据的ID、登录人以及科室等信息
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.Clean.CleanInfo).CleanCheck("{""cleantypev"":"""",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""cleanCodev"":"""",""cleanStrov"":"""",""Iscmt"":""1"",""checkerv"":"""",""FStartDate"":""2021-05-14"",""FEndDate"":""2021-05-14"",""cleanmachine"":"""",""CheckTime"":"""",""checker"":""""}","10")
ClassMethod CleanCheck(Params As %String)
{
	n (%session,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i Params="" d RtnObj.Err(-1,"","参数是空!","",0)
	q:RtnObj.success'=0 RtnObj

	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败！","",0)
	q:RtnObj.success'=0 RtnObj

	s ID=PJObj.%Get("ID")
	s gUserId=PJObj.%Get("gUserId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gLocId=PJObj.%Get("gLocId")
	s gHospId=PJObj.%Get("gHospId")
	s pChecker=PJObj.%Get("Checker")
	s pCheckTime=PJObj.%Get("CheckTime")

	i pChecker="" s pChecker=gUserId
	s currDate=$p($h,",",1)
	s curTime=$p($h,",",2)
	s pCheckTime=..TH2L(pCheckTime)
	i pCheckTime'="" d
	.s curTime=pCheckTime

	s CleanTypeId=$lg(^User.CSSDCleanD(ID),2)
	s CleanDate=$List(^User.CSSDCleanD(ID),3)
	s CleanTime=$List(^User.CSSDCleanD(ID),5)
	s MachineNum=$List(^User.CSSDCleanD(ID),9)
	s CleanProId=$lg(^User.CSSDCleanD(ID),15)
	s IsCmtEnter=$List(^User.CSSDCleanD(ID),18)	//清洗标记
	s CleanFlag=$List(^User.CSSDCleanD(ID),22)	//获取清洗主表是否包含外来器械
	s FileName=$lg(^User.CSSDCleanD(ID),25)
	s IsResult=$lg(^User.CSSDCleanD(ID),14)	//验收标记
	s MachineDr=$lg(^User.CSSDCleanD(ID),19)
	i IsCmtEnter'="1" q RtnObj.Err(-1,"","该清洗单未提交或已撤销,请核实!","",0)
	i IsResult'="" d RtnObj.Err(-1,"","该清洗单已验收！","",0)
	q:RtnObj.success'=0 RtnObj

	s DateTime=(currDate-CleanDate)*24*60*60
	s Time=curTime-CleanTime

	;手工清洗标记
	s IsManual=$lg(^User.CSSDCleanTypeD(CleanTypeId),5)
	;清洗程序验收时长
	s ProInterval=$s(CleanProId'="":$lg(^User.CSSDBaseCodeD(CleanProId),9),1:"")

	s Param=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	i (MachineNum="0")||(IsManual="Y") d
	.s MinTime=##Class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDCLEAN","CleanCheckManualInterval",Param)*60
	e  i ProInterval'="" d
	.s MinTime=ProInterval*60
	e  d
	.s MinTime=##Class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDCLEAN","CleanCheckval",Param)*60

	i ((DateTime+Time)<MinTime) d RtnObj.Err(-4,"","清洗时间不足,不能验收！")
	q:RtnObj.success'=0 RtnObj

	s Flag=""
	&sql(update cssd_clean set CSSDC_Result='1',cssdc_chktime=:curTime,CSSDC_ChkDate=:currDate,cssdc_ChkerDR=:pChecker where ID=:ID)
	i SQLCODE'=0 d RtnObj.Err(-3,"","更新清洗主表失败!")
	q:RtnObj.success'=0 RtnObj

	s CleanDetailId=""
	f  s CleanDetailId=$o(^User.CSSDCleanDetailPacksI("IndexMainDr",ID,CleanDetailId)) q:((CleanDetailId="")||(RtnObj.success'=0))  d
	.s CleanDetailObj=##class(User.CSSDCleanDetailPacks).%OpenId(CleanDetailId)
	.i $IsObject(CleanDetailObj) d
	..d CleanDetailObj.%Reload()
	..s State=CleanDetailObj.CSSDCDPStates
	..s ExtDR=CleanDetailObj.CSSDCDPExtDR
	..i ExtDR="" s Flag="Y"	;证明该单据中不止是 只有外来器械,是混合清洗的单据
	..i State="" d
	...&sql(update cssd_cleandetailpacks set CSSDCDP_States='Y' where ID=:CleanDetailId)
	...i SQLCODE'=0 d RtnObj.Err(-2,"","更新清洗子表失败!")
	..q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj

	i ((CleanFlag="E")&&(Flag="Y")) d
	.&sql(UPDATE CSSD_Clean SET CSSDC_Flag = 'MC' WHERE ID=:ID)
	.i SQLCODE'=0 d RtnObj.Err(-3,"","更新混合清洗主表状态失败!")
	q:RtnObj.success'=0 RtnObj

	s MachinePre=""
	i MachineDr'="" d
	.s MachineData=^User.CSSDMachineConfigD(MachineDr)
	.s MachinePre=$lg(MachineData,7)

	;清洗合格的时候，需要给当前清洗批号自动匹配机器文件
	i (FileName="")&&(MachinePre'="") d
	.s Type="washer"
	.s FileData=ID_"^"_gHospId_"^"_Type
	.s Title="RowIdStr^gHospId^Type"
	.s FileParams=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(FileData,Title)
	.s RtnObj=##class(web.CSSDHUI.MachineData.DataDeal).FileMatch(FileParams)
	q:RtnObj.success'=0 RtnObj

	q RtnObj
}

/// Creator:wn
/// CreatDate:2020.1.10
/// Description:清洗验收页面验收不合格功能
/// Table:CSSD_Clean
/// Input: Params：主表单据的ID、登录人以及科室等信息
/// Output:
/// Return:
/// w ##class(web.CSSDHUI.Clean.CleanInfo).jsCleanCheckNPass(^tmpljl("2"),"")
ClassMethod jsCleanCheckNPass(Params As %String, Details As %String = "") As %Library.String
{
	n (%session,Params,Details)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..CleanCheckNPass(Params,Details)
	i RtnObj.success'=0 tro  q RtnObj.Json()

	tc
	q RtnObj.Json()
}

/// Creator:wn
/// CreatDate:2020.1.10
/// Description:清洗验收页面验收不合格功能
/// Table:CSSD_Clean
/// Input: Params：主表单据的ID、登录人以及科室等信息;Details：明细数据，为空整单验收，不为空按明细验收
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.Clean.CleanInfo).CleanCheckNPass(^tmpmy("scv"),^tmpmy("fre"))
ClassMethod CleanCheckNPass(Params As %String, Details As %String = "")
{
	n (%session,Params,Details)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!","",0)

	s DetailObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=DetailObj.%FromJSON(Details)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!","",0)

	s pCleanMainID=PJObj.%Get("ID")
	s pChecker=PJObj.%Get("Checker")
	s pCheckTime=PJObj.%Get("CheckTime")
	s pReasonId=PJObj.%Get("UnqualifiedReason")
	s gUserId=PJObj.%Get("gUserId")
	s gHospId=PJObj.%Get("gHospId")
	s gLocId=PJObj.%Get("gLocId")
	s CurDate=$P($h,",",1),CurTime=$P($h,",",2)
	s pCheckTime=..TH2L(pCheckTime)
	i pCheckTime="" s pCheckTime=CurTime
	i pChecker="" s pChecker=gUserId
	s CleanObj = ##class(User.CSSDClean).%OpenId(pCleanMainID)
	d CleanObj.%Reload()
	i '$IsObject(CleanObj) q RtnObj.Err(-1,"","清洗单不存在！")

	s CleanNum = CleanObj.CSSDCNo
	s CleanLocId=CleanObj.CSSDCLocDrGetObjectId()
	s IsCmtEnter=CleanObj.CSSDCIsCmtEnterMachine	//清洗标记
	s IsResult=CleanObj.CSSDCResult					//验收标记
	s MachineDr=CleanObj.CSSDCMachineGetObjectId()
	i IsCmtEnter'="1" q RtnObj.Err(-1,"","该清洗单未提交或已撤销,请核实!","",0)
	i IsResult'="" q RtnObj.Err(-1,"","该清洗单已验收！","",0)

	//处理不合格登记主表
	s UPRowId=$o(^User.CSSDUsedPrdoI("IndexCleanStatus",pCleanMainID,"0",0))
	i UPRowId="" d
	.s Ret=..sssLock("CleanFail")
	.i Ret'=0 d RtnObj.Err(-1,"","生成清洗不合格批号加锁失败！") q
	.
	.s UPNo=##class(web.CSSDHUI.Common.AppCommon).GetAppNo("CLEANFIAL")
	.s UPStatus=0
	.&sql(insert into cssd_usedpredo
		(CSSDUP_No,CSSDUP_Loc,CSSDUP_Register,CSSDUP_Status,CSSDUP_CleanNo,CSSDUP_Date,CSSDUP_Time,CSSDUP_Clean_Dr)
		values
		(:UPNo,:CleanLocId,:pChecker,:UPStatus,:CleanNum,:CurDate,:CurTime,:pCleanMainID))
	.d ..sssUnLock("CleanFail")
	.i SQLCODE'=0 d RtnObj.Err(-2,"","插入数据失败"_MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg)) q
	.s UPRowId=%ROWID
	q:RtnObj.success'=0 RtnObj

	if (Details="") {	//清洗单整单验收不合格
		s CleanDetailId=""
		f  s CleanDetailId=$o(^User.CSSDCleanDetailPacksI("IndexMainDr",pCleanMainID,CleanDetailId)) q:(CleanDetailId="")||(RtnObj.success'=0)  d
		.s CleanDetailObj=##class(User.CSSDCleanDetailPacks).%OpenId(CleanDetailId)
		.s PkgId=CleanDetailObj.CSSDPRPackageGetObjectId()
		.s CleanQty=CleanDetailObj.CSSDCDPTotalQty
		.s LastQty=CleanDetailObj.CSSDCDPQty	//剩余清洗数量
		.q:LastQty=0
		.
		.s States=CleanDetailObj.CSSDCDPStates
		.q:States="N"	//过滤验收不合格明细
		.
		.s UnPassQty=CleanQty	//本次不合格数量
		.//处理不合格登记明细表及清洗子表
		.s RtnObj=..CleanCheckNPassDetail(UPRowId,CleanDetailId,UnPassQty,pReasonId)
		.q:RtnObj.success'=0

	}else{		//清洗单明细验收不合格
		while(RtnObj.success=0){
			s Obj=DetailObj.%Pop()
			q:Obj=""

			s CleanDetailId=Obj.%Get("RowId")
			s LastQty=Obj.%Get("Qty")
			i LastQty'>0 d RtnObj.Err(-2,"","已全部不合格")

			s UnPassQty=Obj.%Get("UnPassQtyEdit")
			i UnPassQty="" s UnPassQty = LastQty
			i UnPassQty>LastQty d RtnObj.Err(-2,"","不合格数量不能超过数量")
			q:RtnObj.success'=0

			s CleanDetailObj=##class(User.CSSDCleanDetailPacks).%OpenId(CleanDetailId)
			s States=CleanDetailObj.CSSDCDPStates
			i States="N" d RtnObj.Err(-2,"","该明细已验收")
			q:RtnObj.success'=0

			//处理不合格登记明细表及清洗子表
			s RtnObj=..CleanCheckNPassDetail(UPRowId,CleanDetailId,UnPassQty,pReasonId)
			q:RtnObj.success'=0
		}
	}
	q:RtnObj.success'=0 RtnObj

	//处理清洗子表
	s Count=0
	&sql(select count(1) into :Count from CSSD_CleanDetailPacks where isnull(CSSDCDP_States,'')='' and CSSDCDP_CleanMainDR=:pCleanMainID)
	i Count=0 d
	.&sql(update cssd_clean set CSSDC_Result='0',cssdc_chktime=:pCheckTime,CSSDC_ChkDate=:CurDate,cssdc_ChkerDR=:pChecker where ID=:pCleanMainID)
	.i SQLCODE'=0 d RtnObj.Err(-2,"","清洗不合格失败!")
	.q:RtnObj.success'=0
	.
	.//清洗不合格，需要给当前清洗批号自动匹配机器文件
	.s MachinePre=""
	.i MachineDr'="" d
	..s MachineData=^User.CSSDMachineConfigD(MachineDr)
	..s MachinePre=$lg(MachineData,7)
	.
	.s FileName=$lg(^User.CSSDCleanD(pCleanMainID),25)
	.i (FileName="")&&(MachinePre'="") d
	..s Type="washer"
	..s FileData=pCleanMainID_"^"_gHospId_"^"_Type
	..s Title="RowIdStr^gHospId^Type"
	..s FileParams=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(FileData,Title)
	..s RtnObj=##class(web.CSSDHUI.MachineData.DataDeal).FileMatch(FileParams)
	i RtnObj.success<0 q RtnObj

	q RtnObj
}

/// 处理单条清洗明细的不合格登记处理（存在未提交合并，不存在新增）（消毒包有明细按明细处理，没有按包处理）
ClassMethod CleanCheckNPassDetail(UPRowId, CleanDetailId, UnPassQty, ReasonId) As web.CSSDHUI.RtnObj
{
	n (%session,UPRowId,CleanDetailId,UnPassQty,ReasonId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	q:(CleanDetailId="")||(UnPassQty="") RtnObj

	s CleanDetailObj=##class(User.CSSDCleanDetailPacks).%OpenId(CleanDetailId)
	s PkgId=CleanDetailObj.CSSDPRPackageGetObjectId()
	s CleanQty=CleanDetailObj.CSSDCDPTotalQty
	s Label=CleanDetailObj.CSSDCDPLabel

	//处理不合格登记子表
	s PkgItmId=$o(^User.CSSDPackageItemI("CSSDPIPackageIndex",PkgId,""))

	i PkgItmId="" d												//1消毒包没有明细
	.s UPItmId=$o(^User.CSSDUsedPredoDetailI("CSSDUPDMainCleanDPkgIndex",UPRowId,CleanDetailId,PkgId,0))
	.i UPItmId="" d												//1-1不存在未提交的登记
	..s SummitUnPassQty=..GetUsedPredoPdkQty(CleanDetailId,1)	//已提交不合格数量
	..i (UnPassQty+SummitUnPassQty)>CleanQty s SumUnPassQty=(CleanQty-SummitUnPassQty)
	..e  s SumUnPassQty=UnPassQty
	..&sql(INSERT INTO CSSD_UsedPredoDetail(CSSDUPD_MainDr,CSSDUPD_Pkg,CSSDUPD_SumNum,CSSDUPD_PkgNum,CSSDUPD_CleanDetailDr,CSSDUPD_BarCode,CSSDUP_QxpcNum,CSSDUPD_QueWhy)
		values (:UPRowId,:PkgId,:SumUnPassQty,:SumUnPassQty,:CleanDetailId,:Label,:SumUnPassQty,:ReasonId))
	.
	.e  d														//1-2存在未提交的登记
	..s SummitUnPassQty=..GetUsedPredoPdkQty(CleanDetailId,1)	//已提交不合格数量
	..s UPItmObj=##class(User.CSSDUsedPredoDetail).%OpenId(UPItmId)
	..s UPItmUnPassQty=UPItmObj.CSSDUPDPkgNum
	..i (UnPassQty+UPItmUnPassQty)>(CleanQty-SummitUnPassQty) s SumUnPassQty=(CleanQty-SummitUnPassQty)
	..e  s SumUnPassQty=UnPassQty+UPItmUnPassQty
	..&sql(update CSSD_UsedPredoDetail set CSSDUPD_SumNum=:SumUnPassQty,CSSDUPD_PkgNum=:SumUnPassQty,CSSDUP_QxpcNum=:SumUnPassQty,CSSDUPD_QueWhy=:ReasonId where %ID=:UPItmId)
	.i SQLCODE'=0 d RtnObj.Err(-3,"","按包保存不合格明细失败！") q

	e  d														//2消毒包存在明细
	.s PkgItmId=0
	.f  s PkgItmId=$o(^User.CSSDPackageItemI("CSSDPIPackageIndex",PkgId,PkgItmId)) q:(PkgItmId="")||(RtnObj.success'=0)  d
	..s PkgItmObj=##class(User.CSSDPackageItem).%OpenId(PkgItmId)
	..s PkgItmFac=PkgItmObj.CSSDPIQty
	..s ItmId=PkgItmObj.CSSDPIItmDR.%Id()
	..s UPItmId=$o(^User.CSSDUsedPredoDetailI("CSSDUPDMainCleanDItmIndex",UPRowId,CleanDetailId,ItmId,0))
	..i UPItmId="" d											//2-1不存在未提交的登记
	...s SummitUnPassQty=..GetUsedPredoPdkQty(CleanDetailId,1)
	...i (UnPassQty+SummitUnPassQty)>CleanQty s SumUnPassQty=(CleanQty-SummitUnPassQty)
	...e  s SumUnPassQty=UnPassQty
	...s SumUnPassQtyItm=SumUnPassQty*PkgItmFac
	...&sql(INSERT INTO CSSD_UsedPredoDetail(CSSDUPD_MainDr,CSSDUPD_Itm,CSSDUPD_Pkg,CSSDUPD_SumNum,CSSDUPD_PkgNum,CSSDUPD_CleanDetailDr,CSSDUPD_BarCode,CSSDUP_QxpcNum,CSSDUPD_QueWhy)
		values (:UPRowId,:ItmId,:PkgId,:SumUnPassQtyItm,:SumUnPassQty,:CleanDetailId,:Label,:SumUnPassQtyItm,:ReasonId))
	..
	..e  d														//2-2存在未提交的登记
	...s SummitUnPassQty=..GetUsedPredoPdkQty(CleanDetailId,1)
	...s UPItmObj=##class(User.CSSDUsedPredoDetail).%OpenId(UPItmId)
	...s UPItmUnPassQty=UPItmObj.CSSDUPDPkgNum
	...i (UnPassQty+UPItmUnPassQty)>(CleanQty-UPItmUnPassQty) s SumUnPassQty=(CleanQty-SummitUnPassQty)
	...e  s SumUnPassQty=UnPassQty+UPItmUnPassQty
	...s SumUnPassQtyItm=SumUnPassQty*PkgItmFac
	...&sql(update CSSD_UsedPredoDetail set CSSDUPD_SumNum=:SumUnPassQtyItm,CSSDUPD_PkgNum=:SumUnPassQty,CSSDUP_QxpcNum=:SumUnPassQtyItm,CSSDUPD_QueWhy=:ReasonId where %ID=:UPItmId)
	..i SQLCODE'=0 d RtnObj.Err(-3,"","按器械保存不合格明细失败！") q
	.q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj

	//处理清洗子表状态
	s SumUnPassQty=..GetUsedPredoPdkQty(CleanDetailId,"")
	s LastCleanQty=CleanQty-SumUnPassQty
	s NewStatus=""
	i LastCleanQty=0 s NewStatus="N"
	&sql(update cssd_cleandetailpacks set CSSDCDP_Reason=:ReasonId,CSSDCDP_States=:NewStatus,CSSDCDP_qty=:LastCleanQty,CSSDCDP_UnPassQty=:SumUnPassQty where ID=:CleanDetailId)
	i SQLCODE'=0 d RtnObj.Err(-2,"","更新清洗子表不合格状态失败!")
	q:RtnObj.success'=0 RtnObj

	q RtnObj
}

/// 获取当前清洗明细在清洗不合格登记中的消毒包数量
ClassMethod GetUsedPredoPdkQty(CleanDetailId, Status)
{
	n (%session,CleanDetailId,Status)
	q:CleanDetailId="" 0

	s UPMainStr=""
	s UPPkgNumSum=0,UPMainStr=""
	s UPItmId=0
	f  s UPItmId=$o(^User.CSSDUsedPredoDetailI("CSSDUPDCleanDItmIndex",CleanDetailId,UPItmId)) q:(UPItmId="")  d
	.s UPItmObj=##class(User.CSSDUsedPredoDetail).%OpenId(UPItmId)
	.q:'$IsObject(UPItmObj)
	.
	.s UPPkgId=UPItmObj.CSSDUPDPkg.%Id()
	.s UPPkgNum=UPItmObj.CSSDUPDPkgNum
	.s UPMainId=UPItmObj.CSSDUPDMainDr.%Id()
	.s UPStatus=UPItmObj.CSSDUPDMainDr.CSSDSPStatus
	.q:(UPMainStr'="")&&(("^"_UPMainStr_"^")[("^"_UPMainId_"^"))
	.
	.s UPMainStr=UPMainStr_"^"_UPMainId
	.q:(Status'="")&&(UPStatus'=Status)
	.
	.s UPMainStr=UPMainId_"^"_UPPkgId
	.s UPPkgNumSum=UPPkgNumSum+UPPkgNum

	q UPPkgNumSum
}

/// Creator:ban
/// CreatDate:2020.12.11
/// Description:更新外来器械表状态
/// Table: CSSD_ExtDevBind
/// Input: extId : 外来器械表ID  nowState:当前状态
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.Clean.CleanInfo).UpdateExtState("16","B")
ClassMethod UpdateExtState(extId As %String, nowState As %String) As %Library.String
{
	n (%session,extId,nowState)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i nowState="C" s NextStatus="SW"
	i nowState="B" s NextStatus="W"
	i nowState="SW" s NextStatus="SS"
	&sql(UPDATE CSSD_ExtDevBind SET CSSDExt_Status =:NextStatus WHERE CSSDExt_Rowid=:extId)
	i SQLCODE'=0 d RtnObj.Err(-1,"","外来器械更新登记状态失败！")
	q:RtnObj.success'=0 RtnObj

	&sql(UPDATE CSSD_ExtCallBackLabel SET CSSDECL_Status=:NextStatus WHERE CSSDECL_Parref_DR=:extId and CSSDECL_Status=:nowState)
	i SQLCODE'=0  d RtnObj.Err(-1,"","外来器械更新回收明细状态失败！")
	q RtnObj
}

/// Creator:wn
/// CreatDate:2020.1.10
/// Description:清洗页面扫码添加标牌追溯包(标牌追溯包，清洗筐)
/// Table: CSSD_CodeDict , User.CSSDPackage
/// Input: mainId:清洗主表单据ID , barCode:扫描的条码
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.Clean.CleanInfo).jsSaveCleanDetail("{""ComPkgNum"":"""",""gUserId"":""6423"",""gLocId"":""166"",""gGroupId"":""294"",""gHospId"":""2"",""CodeDictId"":""103006001"",""MainId"":""10""}")
ClassMethod jsSaveCleanDetail(Params) As %Library.String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!")

	s MainId = PJObj.%Get("MainId")
	s pCodeDict = PJObj.%Get("CodeDictId")
	s gHospId = PJObj.%Get("gHospId")
	s glocId = PJObj.%Get("gLocId")
	s gUserId=PJObj.%Get("gUserId")
	;灭菌召回("RC") 直接清洗
	s TransStatus=""
	s TransId=$o(^User.CSSDTransI("CSSDTLabel",pCodeDict,""))
	i TransId'="" d
	.s TransStatus=##class(User.CSSDTrans).%OpenId(TransId).CSSDTStatus

	s CodeDicList=##class(web.CSSDHUI.Common.PackageInfoCommon).GetLabel(pCodeDict)
	s CodeDict=$p(CodeDicList,"^",1)
	i CodeDict="" q RtnObj.Err(-2,"","无效标牌！")
	s ExpiredFlag="N"
	s LastTransId=$o(^User.CSSDTransI("CodeDict",CodeDict,""),-1)		//固定标牌最后一次Trans记录
	s CSSDTLabel=""
	i LastTransId'="" d
	.s TransObj=##class(User.CSSDTrans).%OpenId(LastTransId)
	.d TransObj.%Reload()
	.q:'$IsObject(TransObj)
	.s TransStatus=TransObj.CSSDTStatus
	.s ExpDate=TransObj.CSSDTExpDate
	.s CSSDTLabel=TransObj.CSSDTLabel
	.q:(TransStatus="C")||(TransStatus="U")
	.i (ExpDate<+$h)&&(LastTransId=TransId)&&(TransId'="") s ExpiredFlag="Y"
	.i (TransId="")&&(ExpDate<+$h) s ExpiredFlag="Y"
	s PkgType=$p(CodeDicList,"^",2)
	s PkgId=$p(CodeDicList,"^",3)
	s IsExt=##class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PkgId)

	ts
	i PkgType="1" d	//标牌追溯包
	.s (CallId,LevelFlag,ComplateFlag,CallMainId,UseFlag,CycleCount)=""
	.i IsExt'="Y" d
	..&sql(select max(ID) into :TmpCleanItmId from CSSD_CleanDetailPacks where CSSDCDP_Label=:CodeDict AND CSSDCDP_IsCrtLbl = 0)
	..i (SQLCODE=0)&&(TmpCleanItmId'="") d RtnObj.Err(-1,"","该标牌追溯包已清洗未打包！") q
	..q:RtnObj.success'=0
	..
	..&sql(select max(CSSDCD_Rowid) into :tmpCallId from CSSD_CallBackDetailNew where CSSDPC_DictLabel =:CodeDict AND CSSDCD_IsClean IS NULL)
	..i SQLCODE=0 s CallId=tmpCallId
	..i CallId'="" s CallMainId=$lg(^User.CSSDCallbackDetailNewD(CallId),2)
	..i CallMainId'="" s ComplateFlag=$lg((^User.CSSDPackageCallbackD(CallMainId)),14)
	..
	..&sql(select CSSDCD_CycleCount,CSSDCD_NotUseFlag into :CycleCount,:UseFlag from CSSD_CodeDict WHERE CSSDCD_Code =:CodeDict)
	..i (CycleCount'=0)&&(ComplateFlag'="Y")&&(TransStatus'="RC")&&(ExpiredFlag'="Y") d RtnObj.Err(-2,"","该标牌追溯包未回收或已添加！") q
	..
	..&sql(select max(ID) into :tmpApplyId from CSSD_PackageApplyDetail where CSSDPAD_BarCode =:CodeDict AND CSSDPAD_BackQty IS NULL)
	..i (SQLCODE=0)&&(tmpApplyId'="") d RtnObj.Err(-1,"","该标牌追溯包已在申请单!") q
	..q:RtnObj.success'=0
	..
	..i (UseFlag="N")  d RtnObj.Err(-3,"","该标牌追溯包已被停用，请核对！") q
	..s CleanBasketId=""
	..i CallId'="" d
	...s LevelFlag=##class(User.CSSDCallbackDetailNew).%OpenId(CallId).CSSDCDLevelFlag
	...s CleanBasketId=$o(^User.CSSDBasketPackDetailI("CSSDCBPICallBackIndex",CallId,""))
	..i CleanBasketId'="" d RtnObj.Err(-5,"","该标牌追溯包已加入清洗架，请核对！") q
	.q:RtnObj.success'=0
	.
	.i (ExpiredFlag="Y")&&(TransStatus'="TC") d
	..//过期包进行过期处理
	..s DealMain=Params
	..s MinusDate=ExpDate-$H
	..s DealDetailObj={}
	..s DealDetailArr=[]
	..d DealDetailObj.%Set("Label",CSSDTLabel)
	..d DealDetailObj.%Set("TransId",LastTransId)
	..d DealDetailObj.%Set("MinusDate",MinusDate)
	..d DealDetailObj.%Set("Status",TransStatus)
	..d DealDetailArr.%Push(DealDetailObj)
	..s DealDetail=DealDetailArr.%ToJSON()
	..s RtnObj=##class(web.CSSDHUI.Stat.ExpireQueryStat).ExpDeal(DealMain,DealDetail)
	..q:RtnObj.success'=0
	.
	.s OprData=CallId_"^"_PkgId_"^"_CodeDict_"^"_1_"^"_LevelFlag
	.q:RtnObj.success'=0
	.s Title="RowId^PkgId^CodeDict^BackQty^LevelFlag"
	.s OprStr=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(OprData,Title)
	.s OprStr="["_OprStr_"]"
	.s RtnObj=##class(web.CSSDHUI.Clean.CleanUnPass).SaveUnOpr(OprStr,Params)
	.q:RtnObj.success'=0
	.
	.s NewCleanDetailId=RtnObj.rowid
	.i ExpiredFlag="Y" d
	..&sql(UPDATE CSSD_Trans SET CSSDT_ExpDealCleanDetailDr=:NewCleanDetailId WHERE CSSDT_Rowid=:LastTransId)
	..i SQLCODE'=0  d RtnObj.Err(-3,"","重新清洗绑定明细数据失败:SQLCODE"_SQLCODE_":"_$g(%msg))
	..q:RtnObj.success'=0
	e  i PkgType="3" d	//清洗筐
	.s RtnObj = ..SaveCleanBasket(MainId,CodeDict)
	e  i (PkgType="2")||(PkgType="10") d
	.s ParamsData=MainId_"^"_PkgId_"^"_1
	.s ParamsTitle="MainId^PkgId^PkgNum"
	.s Params=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(ParamsData,ParamsTitle)
	.s RtnObj=..SaveCommonPackage(Params)
	i RtnObj.success'=0 tro  q RtnObj.Json()

	tc
	s RtnObj.rowid=MainId
	q RtnObj.Json()
}

ClassMethod CheckCleanMinInterval(CodeDictId, CleanId, Params)
{
	n (%session,CodeDictId,CleanId,Params)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 "Y"

	s gUserId=PJObj.%Get("gUserId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gLocId=PJObj.%Get("gLocId")
	s gHospId=PJObj.%Get("gHospId")
	s Flag="Y"
	b ;1
	s LastCleanDetailId=$o(^User.CSSDCleanDetailPacksI("CSSDIndexCDPLabel",CodeDictId,0),-1)	//-1取的是最大ID
	q:LastCleanDetailId="" Flag

	s LastCleanMainId=$lg(^User.CSSDCleanDetailPacksD(LastCleanDetailId),3)
	q:LastCleanMainId=CleanId Flag

	s Param=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	s MinTime=##Class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDCLEAN","MinInterval",Param)*60	//从cssd_Parameter表中取出时间间隔参数
	q:+MinTime'>0 Flag

	s NowDate=+$h
	s NowTime=$p($h,",",2)
	&sql(select CSSDC_Time,CSSDC_Date into :CleanTime,:CleanDate from cssd_clean where ID=:LastCleanMainId)
	;//取同一标牌追溯包上一次清洗的日期和时间
	s DateToSecond=(NowDate-CleanDate)*24*60*60	//判断是否是同一天,并转化为秒坐时间单位
	s TimeToSecond=NowTime-CleanTime
	s BetweenSeconds=DateToSecond+TimeToSecond	//同一消毒包两次清洗的时间间隔
	i BetweenSeconds<MinTime s Flag="N"

	q Flag
}

/// Creator:wn
/// CreatDate:2020.1.10
/// Description:清洗页面删除明细并判定普通循环包
/// Table: CSSD_CallBackDetailNew ,CSSD_CleanDetailPacks
/// Input: rowId ：明细的ID
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.Clean.CleanInfo).jsDelete("[{""RowId"":""42"",""ApplyNo"":""C20230421003"",""BackLocDesc"":""手术室"",""PkgDesc"":""外来器械1001"",""CodeDictId"":""100003001"",""Qty"":""2"",""Iscmt"":""0"",""IsResult"":"""",""ReasonId"":"""",""UnPassQty"":"""",""ReasonDesc"":"""",""TotalQty"":""2"",""PkgFlag"":"""",""LevelFlag"":""1"",""BeInfected"":""N""}]")
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

		s RtnObj=..Delete(RowId)
		q:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// 前端不能直接调用删除清洗明细表
ClassMethod Delete(RowId) As web.CSSDHUI.RtnObj
{
	n (%session,RowId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s CleanDetailObj = ##class(User.CSSDCleanDetailPacks).%OpenId(RowId)
	q:'$IsObject(CleanDetailObj) RtnObj.Err(-1,"","数据已删除")

	s (ExtId,ExtCallBackId,PkgId)=""
	s MainId=CleanDetailObj.CSSDCDPCleanMain.%Id()
	s PkgId=CleanDetailObj.CSSDPRPackage.%Id()
	s CleanDetailId = CleanDetailObj.CSSDCDPBindCleanDetailId	;不合格的清洗明细，重新清洗会绑定原有的清洗明细Id
	s CodeDict=CleanDetailObj.CSSDCDPLabel
	s ExtObj=CleanDetailObj.CSSDCDPExtDR
	i $IsObject(ExtObj) s ExtId=ExtObj.%Id()

	s CleanObj=##class(User.CSSDClean).%OpenId(MainId)
	s isCmt=CleanObj.CSSDCIsCmtEnterMachine
	i isCmt'=0 d RtnObj.Err("-2","","已确认清洗不允许删除") q RtnObj

	//处理外来器械
	i ExtId'="" d
	.s Status=##class(User.CSSDExtDevBind).%OpenId(ExtId).CSSDExtStatus
	.i Status="W" s NextStatus="B"
	.i Status="SW" s NextStatus="C"
	.
	.&sql(UPDATE CSSD_ExtDevBind SET CSSDExt_Status =:NextStatus WHERE CSSDExt_Rowid=:ExtId)
	.i SQLCODE'=0 d RtnObj.Err(-3,"","更新外来器械登记状态失败！") q
	.
	.&sql(UPDATE CSSD_ExtCallBackLabel SET CSSDECL_Status=:NextStatus WHERE CSSDECL_Parref_DR=:ExtId and CSSDECL_Status=:Status)
	.i SQLCODE'=0 d RtnObj.Err(-3,"","外来器械明细更新回收状态失败！") q
	.//处理分包回收明细
	.&sql(update CSSD_CallBackDetailNew set CSSDCD_IsClean=null where CSSDCD_Rowid in (SELECT CSSDECL_CallBackDetailDr FROM SQLUser.CSSD_ExtCallBackLabel WHERE CSSDECL_Parref_DR=:ExtId))
	e  d
	.s CallBackDetailId=$List(^User.CSSDCleanDetailPacksD(RowId),13)
	.q:CallBackDetailId=""
	.&sql(update CSSD_CallBackDetailNew set CSSDCD_IsClean=null where CSSDCD_Rowid=:CallBackDetailId)
	.i SQLCODE'=0 d RtnObj.Err(-1,"","更新CSSD_CallBackDetailNew失败!")
	.;更新清洗容器装载表
	//.s DetailId=$o(^User.CSSDBasketPackDetailI("CSSDCBPICleanDrPackageIndex",RowId,PkgId,""))
	//.i DetailId'="" d
	//..s CallBackDetailDr=$lg(^User.CSSDBasketPackDetailD(DetailId),2)
	//..i CallBackDetailDr'="" d
	//...&sql(update CSSD_BasketPackDetail set CSSDCBP_IsClean='N' where CSSDCBP_CallBackDetail_Dr=(SELECT CSSDCDP_CallBackDetailDr FROM SQLUser.CSSD_CleanDetailpacks WHERE ID=:RowId))
	//...i SQLCODE'=0 d RtnObj.Err(-1,"","更新CSSD_BasketPackDetail失败!")
	i RtnObj.success'=0 q RtnObj
	///处理过期绑定的清洗数据
	i CodeDict'="" d
	.s LastTransId=$o(^User.CSSDTransI("CodeDict",CodeDict,""),-1)		//固定标牌最后一次Trans记录
	.i LastTransId'="" d
	..s TransObj=##class(User.CSSDTrans).%OpenId(LastTransId)
	..d TransObj.%Reload()
	..q:'$IsObject(TransObj)
	..q:'$IsObject(TransObj.CSSDTExpDealCleanDetailDr)
	..
	..s TransStatus=TransObj.CSSDTStatus
	..s ExpDealCleanDetailDr=TransObj.CSSDTExpDealCleanDetailDr.%Id()
	..i (TransStatus="TC")&&(ExpDealCleanDetailDr=RowId) d
	...&sql(UPDATE CSSD_Trans SET CSSDT_ExpDealCleanDetailDr=null WHERE CSSDT_Rowid=:LastTransId)
	...i SQLCODE'=0 d RtnObj.Err(-5,"","CSSD_Trans更新过期绑定清洗明细失败！SQLCODE"__SQLCODE_":"_$g(%msg))
	...q:RtnObj.success'=0
	//处理清洗明细
	&sql(delete from CSSD_CleanDetailPacks where ID=:RowId)
	i SQLCODE'=0 d RtnObj.Err(-2,"","删除CSSD_CleanDetailPacks失败!")
	i RtnObj.success'=0 q RtnObj

	//处理清洗架
	s DetailId=$o(^User.CSSDBasketPackDetailI("CSSDCBPICleanDrPackageIndex",RowId,PkgId,""))
	i DetailId'="" d
	.&sql(UPDATE CSSD_BasketPackDetail SET CSSDCBP_IsClean = 'N',CSSDCBP_CleanDr=null WHERE ID=:DetailId)
	.i SQLCODE'=0 d RtnObj.Err(-3,"","更新清洗架失败")
	i RtnObj.success'=0 q RtnObj

	//处理不合格登记
	i CleanDetailId'="" d
	.&sql(UPDATE CSSD_UsedPredoDetail SET CSSDUPD_States=null WHERE CSSDUPD_CleanDetailDr=:CleanDetailId)
	.i SQLCODE'=0 d RtnObj.Err(-3,"","更新不合格登记失败")
	i RtnObj.success'=0 q RtnObj

	s SterPredoDetailId=""
	f  s SterPredoDetailId=$o(^User.CSSDSterPredoDetailI("IndexCleanDetailDr",RowId,SterPredoDetailId)) q:(SterPredoDetailId="")||(RtnObj.success'=0)  d
	.&sql(UPDATE CSSD_SterPredoDetail SET CSSDSP_States=null,CSSDSP_CleanDetailDr=null WHERE ID=:SterPredoDetailId)
	.i SQLCODE'=0 d RtnObj.Err(-34,"","更新灭菌不合格登记失败")
	i RtnObj.success'=0 q RtnObj

	q RtnObj
}

/// Creator:wn
/// CreatDate:2020.1.10
/// Description:清洗页面删除主表单据
/// Table: CSSD_CleanDetailpacks,CSSD_Clean
/// Input: rowId ：主表单据ID
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.Clean.CleanInfo).jsDeleteMain("194")
ClassMethod jsDeleteMain(Params) As %Library.String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s RtnObj=..DeleteMain(Params)
	q RtnObj.Json()
}

/// Creator:wn
/// CreatDate:2020.1.10
/// Description:清洗页面删除主表单据前端不允许调用
/// Table: CSSD_CleanDetailpacks,CSSD_Clean
/// Input: rowId ：主表单据ID
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.Clean.CleanInfo).DeleteMain("194")
ClassMethod DeleteMain(Params) As web.CSSDHUI.RtnObj
{
	n (%session,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")

	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""

		s RowId=Obj.%Get("RowId")
		s CleanObj=##class(User.CSSDClean).%OpenId(RowId)
		s IsCmtEnterMachine=CleanObj.CSSDCIsCmtEnterMachine
		i IsCmtEnterMachine'=0 d RtnObj.Err("-2","","已确认清洗不允许删除") q

		s DetailId=""
		s DetailId=0
		f  s DetailId=$o(^User.CSSDCleanDetailPacksI("IndexMainDr",RowId,DetailId)) q:(DetailId="")||(RtnObj.success'=0)  d
		.q:+DetailId=0
		.
		.s RtnObj=..Delete(DetailId)
		q:RtnObj.success'=0

		&sql(delete from CSSD_Clean where ID=:RowId)
		i SQLCODE'=0 d RtnObj.Err("-2","","删除数据失败！") q
	}
	i RtnObj.success'=0 tro  q RtnObj
	tc
	q RtnObj
}

/// Creator:wn
/// CreatDate:2020.1.10
/// Description:判断当前清洗单据内添加的标牌追溯包是否重复
/// Table: CSSD_CleanDetailPacks
/// Input: CleanMainDr : 清洗主表ID , Label ：扫描标牌追溯包的标签
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.Clean.CleanInfo).GetIsClean("25","000249001")
ClassMethod GetIsClean(CleanMainId As %String, Label As %String) [ SqlProc ]
{

	n (%session,CleanMainId,Label)
	s Ret=0
	s RegId=""
	f  s RegId=$o(^User.CSSDCleanDetailPacksI("IndexMainDr",CleanMainId,RegId)) q:((RegId="")||(Ret=1))  d
	.s DetailLabel=$lg(^User.CSSDCleanDetailPacksD(RegId),4)
	.i Label=DetailLabel s Ret=1
	q Ret
}

/// Creator:wn
/// CreatDate:2020.1.10
/// Description:查找清洗主表的明细
/// Table: CSSD_CleanDetailPacks
/// Input: Params : 主单据ID
/// Output:
/// Return:
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Clean.CleanInfo","SelectCleanDetail","42")
Query SelectCleanDetail(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,ApplyNo,BackLocDesc,PkgDesc,CodeDictId,Qty,Iscmt,IsResult,ReasonId,UnPassQty,ReasonDesc,TotalQty,PkgFlag,LevelFlag,BeInfected") [ SqlProc ]
{
}

ClassMethod SelectCleanDetailExecute(ByRef qHandle As %Binary, Params As %String = "") As %Status
{
	n (%session,qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Params="" $$$OK

	s RowId=""
	f  s RowId=$o(^User.CSSDCleanDetailPacksI("IndexMainDr",Params,RowId)) q:RowId=""  d
	.s CleanDetailData=$g(^User.CSSDCleanDetailPacksD(RowId))
	.s MainId=$lg(CleanDetailData,3)
	.s CodeDictId=$lg(CleanDetailData,4)
	.s PkgId=$lg(CleanDetailData,5)
	.q:PkgId=""
	.
	.s Qty=$lg(CleanDetailData,6)
	.s CBItmId=$lg(CleanDetailData,13)
	.s ReasonId=$lg(CleanDetailData,15)
	.s UnPassQty=$lg(CleanDetailData,17)
	.s GreenFlag=$lg(CleanDetailData,20)
	.s PkgFlag=$lg(CleanDetailData,21)
	.s TotalQty=$lg(CleanDetailData,22)
	.s LevelFlag=$lg(CleanDetailData,29)
	.
	.s (ReasonDesc,ApplyNo,BackLocDesc)=""
	.i ReasonId'=""  d
	..s ReasonObj=##class(User.CSSDCleanItmReason).%OpenId(ReasonId)
	..s ReasonDesc=ReasonObj.CSSDRejectDesc
	.
	.s Cleanobj=##class(User.CSSDClean).%OpenId(MainId)
	.s Iscmt=Cleanobj.CSSDCIsCmtEnterMachine
	.s IsResult=Cleanobj.CSSDCResult
	.
	.s AttributeId=$lg(^User.CSSDPackageD(PkgId),15)
	.i AttributeId=1 d		;消毒包名称, 标牌追溯包取标牌编码名称
	..s DictId=$o(^User.CSSDCodeDictI("CSSDCDCodeIndex",CodeDictId,""))
	..s PkgDesc=$s(DictId'="":$lg(^User.CSSDCodeDictD(DictId),6),1:"")
	.e  d
	..s PkgDesc=$lg(^User.CSSDPackageD(PkgId),5)
	.
	.s BeInfected="N"
	.i (CBItmId'="")&&($d(^User.CSSDCallbackDetailNewD(CBItmId))) d	//回收信息
	..s CBItmInfo=^User.CSSDCallbackDetailNewD(CBItmId)
	..s BeInfected=$lg(CBItmInfo,13) ;感染标志
	..s CBId=$lg(CBItmInfo,2)
	..s CBInfo=^User.CSSDPackageCallbackD(CBId)
	..s BackLocId=$lg(CBInfo,3)
	..s ApplyNo=$lg(CBInfo,8)
	..s BackLocDesc=$s(BackLocId'="":$p(^CTLOC(BackLocId),"^",2),1:"")
	..
	.d OutPutRowClanDetail
	Quit $$$OK
OutPutRowClanDetail
	s Data=$lb(RowId,ApplyNo,BackLocDesc,PkgDesc,CodeDictId,Qty,Iscmt,IsResult,ReasonId,UnPassQty,ReasonDesc,TotalQty,PkgFlag,LevelFlag,BeInfected)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:wn
/// CreatDate:2020.1.11
/// Description:清洗验收页查询数据
/// Table: CSSD_CleanDetailPacks
/// Input: Params : 清洗验收页面查询条件
/// Output:
/// Return:
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Clean.CleanInfo","SelectAllCleanCheck",^tmpljl("1")"{""FStartDate"":""2020-01-10"",""gUserId"":""1"",""gLocId"":""382"",""gGroupId"":""274"",""gHospId"":""2"",""FEndDate"":""2020-01-11"",""cleantypev"":"""",""cleanCodev"":"""",""cleanStrov"":"""",""Iscmt"":""1"",""cleanmachine"":""""}")
Query SelectAllCleanCheck(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "ID:%Integer,CleanNum,MachineNo,CleanDate,CleanTime,VehicleLabel,CleanerName,ChkerName,CleanType,CleanPro,IsCmtEnterMachine,IsResult,CheckTime,LevelFlag,CheckDateTime,MachineFileDesc,CleanState,CleanLoc,BeInfected") [ SqlProc ]
{
}

ClassMethod SelectAllCleanCheckExecute(ByRef qHandle As %Binary, Params As %String = "") As %Status
{
	n (%session,qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK

	s pCleanState=PJObj.%Get("CleanState")	;2未验收 1合格 0不合格 ""表示全部
	s pStartDate= PJObj.%Get("StartDate")
	s pEndDate= PJObj.%Get("EndDate")
	s gLocId = PJObj.%Get("gLocId")
	s pCleanMachineId = PJObj.%Get("CleanMachine")
	s pCleanTypeId = PJObj.%Get("CleanType")
	s pCleanLocId=PJObj.%Get("CleanLoc")
	s pStartDate=..DH2L(pStartDate)
	s pEndDate=..DH2L(pEndDate)
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="select ID ,cssdc_no as CleanNum ,{fn CONVERT(cssdc_date,SQL_VARCHAR)} as CleanDate,cssdc_time as  CleanTime,"
		_" cssdc_cleanVehicleLbl as VehicleLabel,cssdc_cleanerdr->ssusr_name as CleanerName ,cssdc_chkerdr->ssusr_name as ChkerName , "
		_" cssdc_iscreatelbl as iscreatelbl,CSSDC_CleanProgress as CleanProId,cssdc_cleanmethod->CSSDCT_CleanMode as CleanType,"
		_"CSSDC_IsCmtEnterMachine as IsCmtEnterMachine,CSSDC_Result as IsResult,CSSDC_Chktime as CheckTime,CSSDC_ChkDate,"
		_" CSSDC_MachineConfigDr,CSSDC_FileName,CSSDC_MachineConfigDr->CSSDMC_Alias as CleanMachine,CSSDC_Loc_DR->CTLOC_Desc as CleanLoc, "
		_" cssdc_cleanmethod CleanTypeId"
		_" from cssd_clean where cssdc_date between "_pStartDate_" AND "_pEndDate_" and CSSDC_IsCmtEnterMachine='1' "
	i pCleanLocId'="" d
	.s SqlStr=SqlStr_" and cssdc_loc_Dr='"_pCleanLocId_"' "
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s ID = Result.Data("ID")
		s CleanNum = Result.Data("CleanNum")
		s CleanLoc = Result.Data("CleanLoc")
		s MachineNo = Result.Data("CleanMachine")
		s MachineId = Result.Data("CSSDC_MachineConfigDr")
		continue:((pCleanMachineId'="")&&(pCleanMachineId'=MachineId))

		s CleanDate = Result.Data("CleanDate")
		s CleanTime = Result.Data("CleanTime")
		s CleanTime=..TL2H(CleanTime)
		s CleanDate=CleanDate_" "_CleanTime

		s VehicleLabel = Result.Data("VehicleLabel")
		s CleanerName = Result.Data("CleanerName")
		s ChkerName = Result.Data("ChkerName")
		s CleanType = Result.Data("CleanType")
		s CleanProId=Result.Data("CleanProId")
		s IsCmtEnterMachine = Result.Data("IsCmtEnterMachine")
		s CheckTime = Result.Data("CheckTime")
		s CheckTime=..TL2H(CheckTime)

		s CheckDate = Result.Data("CSSDC_ChkDate")
		s CheckDate=..DL2H(CheckDate)
		s CheckDateTime=CheckDate_" "_CheckTime

		s LevelFlag=..GetLevelFlag(ID)
		s CleanPro=$s(CleanProId'="":$lg(^User.CSSDBaseCodeD(CleanProId),4),1:"")
		s MachineFileDesc = Result.Data("CSSDC_FileName")	//判断是否单据提交
		s IsResult=Result.Data("IsResult")
		continue:((pCleanState=1)&&(IsResult'=1))
		continue:((pCleanState=0)&&(IsResult'=0))
		continue:((pCleanState=2)&&(IsResult'=""))
		s CleanTypeId=Result.Data("CleanTypeId")
		continue:(pCleanTypeId'="")&&(pCleanTypeId'=CleanTypeId)
		s BeInfected=..GetBeInfected(ID)
		d OutPutRowCleanCheck

	}
	Quit $$$OK
OutPutRowCleanCheck
	s Data=$lb(ID,CleanNum,MachineNo,CleanDate,CleanTime,VehicleLabel,CleanerName,ChkerName,CleanType,CleanPro,IsCmtEnterMachine,IsResult,CheckTime,LevelFlag,CheckDateTime,MachineFileDesc,CleanState,CleanLoc,BeInfected)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:wn
/// CreatDate:2020.1.11
/// Description:清洗页面获取待清洗专科器械包
/// Table: CSSD_PackageCallback ,CSSD_CallBackDetailNew
/// Input: Params : 待清洗专科器械包弹框查询条件  如日期
/// Output:
/// Return:
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Clean.CleanInfo","SelectAllCleanCheck","{""SelReqWinStartDate"":""2020-01-11"",""gUserId"":""1"",""gLocId"":""382"",""gGroupId"":""274"",""gHospId"":""2"",""SelReqWinEndDate"":""2020-01-11""}")
Query SelectUnClean(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "DetailID:%Integer,ApplyNo,BackLocDesc,PkgId,PkgDesc,BackQty,MaterialId,MaterialDesc,LevelFlag") [ SqlProc ]
{
}

ClassMethod SelectUnCleanExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (%session,qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK

	s Result=##class(%Library.ResultSet).%New()
	s pStartDate = PJObj.%Get("StartDate")
	s pEndDate = PJObj.%Get("EndDate")
	s pStartDate=..DH2L(pStartDate)
	s pEndDate=..DH2L(pEndDate)
	s SqlStr="SELECT b.CSSDCD_rowid as DetailId,a.CSSDPC_SerialNo as ApplyNo,"
			_"a.CSSDPC_FromLoc_DR->CTLOC_Desc AS BackLocDesc,b.CSSDCD_Package_DR as PkgId,"
			_"b.CSSDCD_Package_Dr->CSSDP_Desc AS PkgDesc,"
			_"CSSDCD_Material AS MaterialId,b.CSSDCD_Qty as BackQty,b.CSSDCD_LevelFlag as LevelFlag "
			_" FROM CSSD_PackageCallback a,CSSD_CallBackDetailNew b "
			_" WHERE a.CSSDPC_Rowid=b.CSSDCD_Parref_DR AND a.CSSDPC_AckUser_DR IS NOT NULL "
			_" and CSSDCD_IsClean is null and b.CSSDCD_Package_DR->CSSDP_PackTypeDetail=10 "
			_" and a.CSSDPC_ReqLevel!=1 and a.CSSDPC_AckDate between "_pStartDate_" and "_pEndDate
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s DetailId = Result.Data("DetailId")
		s ApplyNo = Result.Data("ApplyNo")
		s MaterialId=Result.Data("MaterialId")
		s MaterialDesc=##class(User.CSSDMaterial).%OpenId(MaterialId).CSSDMDesc
		s BackLocDesc = Result.Data("LocDesc")
		s PkgId = Result.Data("PkgId")
		s PkgDesc = Result.Data("PkgDesc")
		s BackQty = Result.Data("BackQty")
		s LevelFlag = Result.Data("LevelFlag")
		d OutPutRowUnClean
	}
	Quit $$$OK
OutPutRowUnClean
	s Data=$lb(DetailID,ApplyNo,BackLocDesc,PkgId,PkgDesc,BackQty,MaterialId,MaterialDesc,LevelFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:wn
/// CreatDate:2020.1.11
/// Description:清洗页面待清洗专科器械包弹窗添加消毒包功能
/// Table: cssd_cleandetailpacks , CSSD_CallBackDetailNew
/// Input: Params ：科室等信息 , mainId : 主表ID
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.Clean.CleanInfo).SaveUnClean("[{""DetailID"":""95"",""ApplyNo"":""C20191219001"",""LocName"":""消毒供应室"",""pkgdr"":""1045"",""pkgName"":""专科器械包测试"",""BackQty"":""2""}]","166")
ClassMethod SaveUnClean(Params, MainId) As %Library.String
{
	n (%session,Params,MainId)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()

	i MainId="" d RtnObj.Err(-2,"","请选择清洗主表")
	q:RtnObj.success'=0 RtnObj.Json()

	s RtnObj=..CheckBeforeAddItm(MainId)
	i RtnObj.success<0 q RtnObj.Json()

	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""

		s DetailId=Obj.%Get("DetailId")
		s PkgId=Obj.%Get("PkgId")
		s BackQty=Obj.%Get("BackQty")
		s MaterialId=Obj.%Get("MaterialId")
		&sql(insert into cssd_cleandetailpacks(CSSDCDP_CleanMainDR, CSSDPR_Package_DR, CSSDCDP_Qty, CSSDCDP_IsCrtLbl, CSSDCDP_CreatedQty,CSSDCDP_CallBackDetailDr,CSSDCDP_TotalQty,CSSDCDP_MaterialDR) values (:MainId,:PkgId,:BackQty,0,0,:DetailId,:BackQty,:MaterialId))
		i SQLCODE'=0  d RtnObj.Err(-2,"","插入数据失败"_MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg))

		&sql(update CSSD_CallBackDetailNew set CSSDCD_IsClean='Y' where CSSDCD_rowid=:DetailId)
		i SQLCODE'=0  d RtnObj.Err(-3,"","更新数据失败"_MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg))
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Creator:wn
/// CreatDate:2020.1.11
/// Description:清洗页面待清洗公用包弹窗添加消毒包功能
/// Table: cssd_cleandetailpacks
/// Input: Params ：消毒包明细表ID,清洗数量等信息 , mainId : 主表ID
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.Clean.CleanInfo).SaveUnOrdClean("[{""pkgdr"":""876"",""pkgName"":""肝胆胰包"",""backQty"":""3"",""cleanQty"":""0"",""unCleanQty"":""3""}]","166")
ClassMethod SaveUnOrdClean(Params, MainId) As %Library.String
{
	n (%session,Params,MainId)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()

	i MainId="" d RtnObj.Err(-2,"","请选择清洗主表")
	q:RtnObj.success'=0 RtnObj.Json()

	s RtnObj=..CheckBeforeAddItm(MainId)
	i RtnObj.success<0 q RtnObj.Json()

	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""

		s PkgId=Obj.%Get("PkgId")
		s WillQty=Obj.%Get("WillQty")
		s UnCleanQty=Obj.%Get("UnCleanQty")
		s MaterialId=Obj.%Get("MaterialId")
		q:UnCleanQty=0

		i WillQty="" s WillQty=UnCleanQty
		i WillQty>UnCleanQty s WillQty=UnCleanQty

		s DetailId=$o(^User.CSSDCleanDetailPacksI("IndexMainDrMaterialPkgdr",MainId,MaterialId,PkgId,""))
		i DetailId=""  d
		.&sql(insert into cssd_cleandetailpacks(CSSDCDP_CleanMainDR, CSSDPR_Package_DR, CSSDCDP_Qty, CSSDCDP_IsCrtLbl, CSSDCDP_CreatedQty,CSSDCDP_TotalQty,CSSDCDP_MaterialDR) values (:MainId,:PkgId,:WillQty,0,0,:WillQty,:MaterialId))
		.i SQLCODE'=0 d RtnObj.Err(-3,"","插入清洗明细失败")

		e  d
		.&sql(update cssd_cleandetailpacks set CSSDCDP_Qty=CSSDCDP_Qty+:WillQty,CSSDCDP_TotalQty=CSSDCDP_TotalQty+:WillQty  where ID=:DetailId)
		.i SQLCODE'=0 d RtnObj.Err(-4,"","更新清洗明细失败")
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// 获取所有待清洗消毒包(按回收记录)
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Clean.CleanInfo","SelectUnCleanOrd",^tmpllokm)
Query SelectUnCleanOrd(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "CallBackItmId:%Integer,PkgId,PkgDesc,BackQty,CleanQty,UnCleanQty,MaterialId,MaterialDesc,ApplyLocDesc,CallBackNo,ReqLevel,BeInfected,SterType,CodeDict,SterTypeColor") [ SqlProc ]
{
}

ClassMethod SelectUnCleanOrdExecute(ByRef qHandle As %Binary, Params As %String = "") As %Status
{
	n (%session,qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK

	s pStartDate = PJObj.%Get("CBStartDate")
	s pEndDate = PJObj.%Get("CBEndDate")
	s gHospId=PJObj.%Get("gHospId")
	s pReqLevel=PJObj.%Get("ReqLevel")
	s pSterTypeId=PJObj.%Get("SterTypeId")
	s pPkgId=PJObj.%Get("PkgDesc")
	s CBMainId=PJObj.%Get("ApplyId")
	s pStartDate=..DH2L(pStartDate)
	s pEndDate=..DH2L(pEndDate)
	
	f Date=pStartDate:1:pEndDate d
	.s LocId=""
	.f  s LocId=$o(^User.CSSDPackageCallbackI("CSSDAckDateToLoc",Date,LocId)) q:LocId=""  d
	..s CallBackId=""
	..f  s CallBackId=$o(^User.CSSDPackageCallbackI("CSSDAckDateToLoc",Date,LocId,CallBackId)) q:CallBackId=""  d
	...q:(CBMainId'="")&&(CBMainId'[CallBackId)
	...q:'$d(^User.CSSDCallbackDetailNewI("CSSDCDParrefIndex",CallBackId))
	...
	...s CallBackNo=$lg(^User.CSSDPackageCallbackD(CallBackId),8)
	...s ApplyLocId=$lg(^User.CSSDPackageCallbackD(CallBackId),3)
	...s BackLocId=$lg(^User.CSSDPackageCallbackD(CallBackId),10)
	...s ShowDataFlag=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CT_Loc",BackLocId,gHospId)
	...q:ShowDataFlag="N"
	...
	...s ApplyType=$lg(^User.CSSDPackageCallbackD(CallBackId),23)
	...q:ApplyType=1		//过滤借包单
	...
	...s ApplyLocDesc=""
	...s:ApplyLocId'="" ApplyLocDesc=$p(^CTLOC(ApplyLocId),"^",2)
	...
	...s DetailId="",Str=""
	...f  s DetailId=$o(^User.CSSDCallbackDetailNewI("CSSDCDParrefIndex",CallBackId,DetailId)) q:DetailId=""  d
	....s DetailList=$g(^User.CSSDCallbackDetailNewD(DetailId))
	....s PkgId=$lg(DetailList,3)
	....q:PkgId=""
	....
	....s BackQty=$lg(DetailList,4)
	....s CodeDict=$lg(DetailList,9)
	....s MaterialId=$lg(DetailList,11)
	....s ReqLevel=$lg(DetailList,12)
	....q:(pReqLevel'="")&&(pReqLevel'=ReqLevel)	//过滤紧急
	....q:(CodeDict'="")&&(Str[CodeDict) ;控制外来器械一个标牌多个标签的只显示一条
	....i Str="" s Str=CodeDict
	....e  s Str=CodeDict_","_Str
	....
	....s IsExit=##class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PkgId)
	....s TmpNum=0,ItemId=""
	....i IsExit="Y" d
	.....f  s ItemId=$o(^User.CSSDCallbackDetailNewI("CSSDPCDictLabelIndex",CodeDict,ItemId)) q:ItemId=""  d
	......i ItemId'="" s TmpNum=TmpNum+1
	....i TmpNum'=0 s BackQty=TmpNum ;外来器械回收数量
	....s BeInfected=$lg(DetailList,13)
	....s AttributeId=$lg(^User.CSSDPackageD(PkgId),15)
	....q:AttributeId=7 ;过滤非循环包，非循环包不需要清洗
	....
	....s CleanQty=..GetCleanQtyByCB(DetailId)
	....s CleanCarQty=0
	....s CleanQty=CleanQty+CleanCarQty
	....s UnCleanQty=BackQty-CleanQty
	....i UnCleanQty<0 s UnCleanQty=0
	....q:UnCleanQty=0					//过滤清洗完成明细
	....
	....s PkgDesc=$lg(^User.CSSDPackageD(PkgId),5)
	....s SterTypeId=$lg(^User.CSSDPackageD(PkgId),21)
	....q:(pSterTypeId'="")&&(pSterTypeId'=SterTypeId)
	....q:(pPkgId'="")&&(pPkgId'=PkgId)
	....s SterType=$s(SterTypeId'="":$lg(^User.CSSDSterTypeD(SterTypeId),3),1:"")
	....s SterTypeColor=$s(SterTypeId'="":$lg(^User.CSSDSterTypeD(SterTypeId),8),1:"")
	....s MaterialDesc=$s(MaterialId'="":$lg(^User.CSSDMaterialD(MaterialId),3),1:"")
	....;过滤加入清洗架的消毒包
	....s CleanBasketId=""
	....s CleanBasketId=$o(^User.CSSDBasketPackDetailI("CSSDCBPICallBackIndex",DetailId,""))
	....q:CleanBasketId'=""
	....
	....d OutPutOrd
	Quit $$$OK
OutPutOrd
	s Data=$lb(DetailId,PkgId,PkgDesc,BackQty,CleanQty,UnCleanQty,MaterialId,MaterialDesc,
			ApplyLocDesc,CallBackNo,ReqLevel,BeInfected,SterType,CodeDict,SterTypeColor)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 取回收记录的清洗数量
/// w ##class(web.CSSDHUI.Clean.CleanInfo).GetCleanQtyByCB(1)
ClassMethod GetCleanQtyByCB(CallBackItmId)
{
	n (%session,CallBackItmId)
	q:CallBackItmId="" ""

	s SumCleanQty=0
	s CleanItmId=""
	f  s CleanItmId=$o(^User.CSSDCleanDetailPacksI("IndexCallBackDetailDr",CallBackItmId,CleanItmId)) q:CleanItmId=""  d
	.s CleanQty=$lg(^User.CSSDCleanDetailPacksD(CleanItmId),22)
	.s SumCleanQty=SumCleanQty+CleanQty

	q SumCleanQty
}

/// CreatDate:	2021-05-14
/// Description:根据已回收记录进行清洗
/// Input:
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.Clean.CleanInfo).jsSaveUnCleanOrd("[{""CallBackItmId"":""12"",""PkgId"":""3"",""PkgDesc"":""外来器械1"",""BackQty"":""1"",""CleanQty"":""0"",""UnCleanQty"":""1"",""MaterialId"":""3"",""MaterialDesc"":""医用纸袋"",""ApplyLocDesc"":""产科门诊"",""CallBackNo"":""C20230424001"",""ReqLevel"":""0"",""BeInfected"":""N"",""SterType"":""高温灭菌"",""CodeDict"":""100003003"",""SterTypeColor"":""#d1a71b"",""WillQty"":""""}]","8")
ClassMethod jsSaveUnCleanOrd(Params, MainId) As %Library.String
{
	n (%session,Params,MainId)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s RtnObj=..SaveUnCleanOrd(Params,MainId)
	q RtnObj.Json()
}

ClassMethod SaveUnCleanOrd(Params, MainId) As web.CSSDHUI.RtnObj
{
	n (%session,Params,MainId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i MainId="" q RtnObj.Err(-2,"","请选择清洗主表")
	s RtnObj=..CheckBeforeAddItm(MainId)
	i RtnObj.success<0 q RtnObj
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!")
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s CallBackItmId=Obj.%Get("CallBackItmId")
		s CallBackMainId=$lg(^User.CSSDCallbackDetailNewD(CallBackItmId),2)
		s CallBackCompFlag=$lg(^User.CSSDPackageCallbackD(CallBackMainId),14)
		i CallBackCompFlag'="Y" d RtnObj.Err(-1,"","部分明细的回收单未提交!")
		continue:RtnObj.success'=0
		s PkgId=Obj.%Get("PkgId")
		s CodeDict=Obj.%Get("CodeDict")
		s BackQty=Obj.%Get("BackQty")
		s WillQty=Obj.%Get("WillQty")
		s MaterialId=Obj.%Get("MaterialId")
		s ReqLevel=Obj.%Get("ReqLevel")
		s CleanQty=..GetCleanQtyByCB(CallBackItmId)
		s CleanCarQty=0
		s CleanQty=CleanQty+CleanCarQty
		s UnCleanQty=BackQty-CleanQty
		i UnCleanQty<0 s UnCleanQty=0
		continue:UnCleanQty=0

		s IsExt=##class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PkgId)
		s ExtId="",CSSDCDPFlag=""
		i IsExt="Y" d
		.s ExtId=$o(^User.CSSDExtDevBindI("IndexCSSDExtCode",CodeDict,""))
		.s CSSDCDPFlag="Y"
		i WillQty="" s WillQty=UnCleanQty
		i WillQty>UnCleanQty s WillQty=UnCleanQty
		s CleanDetailId=""		;记录已存在清洗记录的rowid
		s CleanItmId=""
		f  s CleanItmId=$o(^User.CSSDCleanDetailPacksI("IndexMainDr",MainId,CleanItmId)) q:(CleanItmId="")||(CleanDetailId'="")  d
		.s CBDetailId=$lg(^User.CSSDCleanDetailPacksD(CleanItmId),13)
		.q:(CBDetailId'=CallBackItmId)
		.
		.s CleanDetailId=CleanItmId
		i CleanDetailId="" d
		.s Obj=##class(User.CSSDCleanDetailPacks).%New()
		.d Obj.CSSDCDPCleanMainSetObjectId(MainId)
		.d Obj.CSSDPRPackageSetObjectId(PkgId)
		.d Obj.CSSDCDPMaterialDRSetObjectId(MaterialId)
		.d Obj.CSSDCDPCallBackDetailDrSetObjectId(CallBackItmId)
		.s Obj.CSSDCDPLabel=CodeDict
		.d Obj.CSSDCDPExtDRSetObjectId(ExtId)
		.s Obj.CSSDCDPFlag=CSSDCDPFlag
		e  d
		.s Obj=##class(User.CSSDCleanDetailPacks).%OpenId(CleanDetailId)
		s Obj.CSSDCDPQty=Obj.CSSDCDPQty+WillQty
		s Obj.CSSDCDPTotalQty=Obj.CSSDCDPTotalQty+WillQty
		s Obj.CSSDCDPCreatedQty=0
		s Obj.CSSDCDPIsCrtLbl=0

		i ReqLevel="1" s Obj.CSSDCDPGreenFlag=1,Obj.CSSDCDPLevelFlag=1
		s Sc=Obj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-1,"","清洗明细更新失败!") q
		s RtnObj.rowid=Obj.%Id()
		
		s CleanFlag="Y"
		i (WillQty=UnCleanQty)&&(IsExt'="Y") d
		.&sql(Update CSSD_CallBackDetailNew Set CSSDCD_IsClean=:CleanFlag Where CSSDCD_Rowid=:CallBackItmId)
		.i SQLCODE'=0 d RtnObj.Err(-1,"","更新回收明细失败!")
		continue:RtnObj.success'=0
		
		i (IsExt="Y")&&(WillQty=UnCleanQty) d
		.&sql(Update CSSD_CallBackDetailNew Set CSSDCD_IsClean=:CleanFlag Where CSSDPC_DictLabel=:CodeDict and CSSDCD_IsClean IS NULL)
		.i SQLCODE'=0 d RtnObj.Err(-1,"","更新回收明细失败!") q
		.
		.&sql(Update CSSD_ExtDevBind Set CSSDExt_Status='SW' Where CSSDExt_Code=:CodeDict)
		.i SQLCODE'=0 d RtnObj.Err(-1,"","更新外来器械登记表失败!") q
		.
		.&sql(UPDATE CSSD_ExtCallBackLabel SET CSSDECL_Status='SW' WHERE CSSDECL_Parref_DR=:ExtId and CSSDECL_Status='C')
		.i SQLCODE'=0 d RtnObj.Err(-3,"","更新外来器械标签明细表失败！") q
		continue:RtnObj.success'=0
		
		
	}
	i RtnObj.success<0 tro  q RtnObj
	tc
	q RtnObj
}

/// 普通循环包明细添加
/// w ##class(web.CSSDHUI.Clean.CleanInfo).JsSaveCommonPackage(^tmpmy("778"))
ClassMethod JsSaveCommonPackage(Params As %String) As %String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s RtnObj=..SaveCommonPackage(Params)
	q RtnObj.Json()
}

/// Creator:wn
/// CreatDate:2020.1.11
/// Description:清洗页面添加普通循环包功能
/// Table: CSSD_CleanDetailPacks
/// Input: mainId : 主表ID  PackageDr:添加消毒包的ID  Number:添加数量
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.Clean.CleanInfo).JsSaveCommonPackage("1015","746","1")
ClassMethod SaveCommonPackage(Params) As web.CSSDHUI.RtnObj
{
	n (%session,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","入参不能为空!")

	s MainId = PJObj.%Get("MainId")
	s PkgId = PJObj.%Get("PkgId")
	s PkgNum = PJObj.%Get("PkgNum")
	i ((MainId="")||(PkgId="")||(PkgNum="")) q RtnObj.Err(-1,"","入参不能为空!")

	s RtnObj=..CheckBeforeAddItm(MainId)
	i RtnObj.success<0 q RtnObj

	s DetailId=""
	s Regid=0
	f  s Regid=$o(^User.CSSDCleanDetailPacksI("IndexMainDrPkgdr",MainId,PkgId,Regid)) q:(Regid="")||(DetailId'="")  d
	.s CleanDetailCbk=$List(^User.CSSDCleanDetailPacksD(Regid),13)
	.q:CleanDetailCbk'=""	//手工添加的包与回收添加的单明细分开
	.s DetailId=Regid

	ts
	i DetailId="" d
	.&sql(insert into CSSD_CleanDetailPacks (CSSDCDP_CleanMainDR,CSSDPR_Package_DR,CSSDCDP_Qty,CSSDCDP_CreatedQty,CSSDCDP_IsCrtLbl,CSSDCDP_TotalQty) VALUES(:MainId,:PkgId,:PkgNum,0,0,:PkgNum))
	e  d
	.&sql(update CSSD_CleanDetailPacks set CSSDCDP_Qty = CSSDCDP_Qty+:PkgNum,CSSDCDP_TotalQty=CSSDCDP_TotalQty+:PkgNum where ID=:DetailId)
	i SQLCODE'=0 tro  q RtnObj.Err(-2,"","普通循环包更新失败")
	s RowId=%ROWID

	s RtnObj.rowid=RowId
	tc
	q RtnObj
}

/// Creator:	wangjiabin
/// CreatDate:	2021-09-23
/// Description:清洗单追加明细前的判断
/// Table: CSSD_Clean
/// Input: ID
ClassMethod CheckBeforeAddItm(CleanId) As web.CSSDHUI.RtnObj
{
	n (%session,CleanId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i CleanId="" q RtnObj.Err(-1,"","参数错误")

	s Obj=##class(User.CSSDClean).%OpenId(CleanId)
	i Obj="" q RtnObj.Err(-1,"","单据不存在,请重新查询!","",0)

	s CmtFlag=Obj.CSSDCIsCmtEnterMachine
	i CmtFlag="1" q RtnObj.Err(-2,"","该单据已清洗,不可再追加明细,请核实!","",0)

	q RtnObj
}

/// 查询绿色通道的回收制单 用于清洗
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Clean.CleanInfo","SelectForGreenFlag",^tmpljlkkoo)
Query SelectForGreenFlag(Params As %String = "") As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,No,BackLocDesc,BackDate,BackTime,BackUserName,ReqFlag,DispFlag,ReqLevel,ReqLevelDesc,InfectFlag") [ SqlProc ]
{
}

ClassMethod SelectForGreenFlagExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (%session,qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 $$$OK

	s pBackLoc=PJObj.%Get("BackLoc")
	s pStartDate=PJObj.%Get("CBStartDate")
	s pEndDate=PJObj.%Get("CBEndDate")
	s gHospId=PJObj.%Get("gHospId")
	s pStartDate=..DH2L(pStartDate)
	s pEndDate=..DH2L(pEndDate)
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr=" select CSSDPC_Rowid As RowId,CSSDPC_ToLoc_DR,CSSDPC_SerialNo,CSSDPC_FromLoc_DR,"
			_" CSSDPC_AckDate,CSSDPC_AckTime,CSSDPC_AckUser_DR,CSSDPC_ComplateFlag,CSSDPC_ReqLevel"
			_" from CSSD_PackageCallback where CSSDPC_ComplateFlag='Y'"
			_" and nvl(CSSDPC_ApplyType,'') in ('',0,4,5) and CSSDPC_ReqLevel = 1 "
			_" and CSSDPC_AckDate between "_pStartDate_" and "_pEndDate
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s Ret=..GetCleanDetailByCallBack(RowId)
		continue:Ret'=1
		s No = Result.Data("CSSDPC_SerialNo")
		s ToLocId=Result.Data("CSSDPC_ToLoc_DR")
		s ShowDataFlag=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CT_Loc",ToLocId,gHospId)
		continue:ShowDataFlag="N"
		s ReqFlag=Result.Data("CSSDPC_ComplateFlag")
		s BackLocId=Result.Data("CSSDPC_FromLoc_DR")
		continue:((pBackLoc'="")&(pBackLoc'=BackLocId))
		s BackDate= Result.Data("CSSDPC_AckDate")
		s BackTime=Result.Data("CSSDPC_AckTime")
		s BackUserId=Result.Data("CSSDPC_AckUser_DR")
		s ReqLevel=Result.Data("CSSDPC_ReqLevel")
		s BackDate = ..DL2H(BackDate)
		s BackTime=..TL2H(BackTime)
		s BackLocDesc="",AckUserDesc="",ReqLevelDesc=""
		s:BackLocId'="" BackLocDesc=..sssLocDesc(BackLocId)
		s:BackUserId'="" BackUserName=..sssUserName(BackUserId)
		s InfectFlag=##class(web.CSSDHUI.CallBack.CallBack).GetInfectFlag(RowId)
		i ReqLevel'="" d
		.s ReqLevelDesc=##class(web.CSSDHUI.Common.PackageInfoCommon).getReqLevelDesc(ReqLevel)
		d OutPutRowForGreen
	}
	d Result.Close()
	Quit $$$OK
OutPutRowForGreen
	s Data=$lb(RowId,No,BackLocDesc,BackDate,BackTime,BackUserName,ReqFlag,DispFlag,ReqLevel,ReqLevelDesc,InfectFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 根据回收制单主表判断该单据是否已绿色通道清洗
/// w ##Class(web.CSSDHUI.Clean.CleanInfo).GetCleanDetailByCallBack(785,255)
ClassMethod GetCleanDetailByCallBack(CallBackMainId As %String) As %Library.String
{
	s Ret=-1
	s regid=""
	f  s regid=$o(^User.CSSDCallbackDetailNewI("CSSDCDParrefIndex",CallBackMainId,regid))  q:((regid="")||(Ret>0))  d
	.s Obj=##class(User.CSSDCallbackDetailNew).%OpenId(regid)
	.s IsClean=Obj.CSSDCDIsClean
	.s:IsClean'="Y" Ret=1
	q Ret
}

/// w ##Class(web.CSSDHUI.Clean.CleanInfo).jsCreateCleanByCallback("5","[{""RowId"":""12"",""MainId"":""5"",""PkgId"":""1"",""PkgDesc"":""ptb-1"",""BackQty"":""2"",""DispQty"":""0"",""PreDispQty"":""2"",""LevelFlag"":""1"",""Material"":"""",""CodeDict"":"""",""Label"":"""",""BeInfected"":""N"",""Status"":""""}]")
ClassMethod jsCreateCleanByCallback(CleanId As %String, Details As %String) As %Library.String
{
	n (%session,CleanId,Details)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Details)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	i CleanId="" d RtnObj.Err(-1,"","清洗主单为空！")
	q:RtnObj.success'=0 RtnObj.Json()
	
	ts
	While(RtnObj.success=0)
	{
		s Obj=##class(web.CSSDHUI.Common.FromJson).%New()
		s Obj=PJObj.%Pop()
		q:Obj=""

		s CallBackItmId=Obj.%Get("CallBackItmId")
		s MainId=Obj.%Get("MainId")
		s PkgId=Obj.%Get("PkgId")
		s BackQty=Obj.%Get("BackQty")
		s CodeDict=Obj.%Get("CodeDict")
		s MaterialId=Obj.%Get("MaterialId")
		s ReqLevel=Obj.%Get("ReqLevel")
		s RetData=CallBackItmId_"^"_PkgId_"^"_BackQty_"^"_CodeDict_"^"_MaterialId_"^"_ReqLevel
		s RetTitle="CallBackItmId^PkgId^BackQty^CodeDict^MaterialId^ReqLevel"
		s Ret=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(RetData,RetTitle)
		s Ret="["_Ret_"]"
		s RtnObj=..SaveUnCleanOrd(Ret,CleanId)
		continue:RtnObj.success'=0
		
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:zn
/// CreatDate:2020.12.11
/// Description:对外来器械二次消毒控制
/// Table:CSSD_Clean
/// Return:日志信息
/// w ##class(web.CSSDHUI.Clean.CleanInfo).jsExtSterlize(^templxt("aa"),^templxt("bb"))
ClassMethod jsExtSterlize(Params As %String, Details As %String) As %String
{
	n (%session,Params,Details)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	s PJDetailObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s ScDetail=PJDetailObj.%FromJSON(Details)
	i ((ScDetail'=0)||(Sc'=0)) d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()

	ts
	while(RtnObj.success=0){
		s Obj=PJDetailObj.%Pop()
		q:Obj=""

		s DetailId=Obj.%Get("RowId")
		s CleanMainID=PJObj.%Get("ID")
		s CleanDetailObj=##Class(User.CSSDCleanDetailPacks).%OpenId(DetailId)
		s CleanMainObj=##Class(User.CSSDClean).%OpenId(CleanMainID)
		d CleanMainObj.%Reload()
		s IsResult=CleanMainObj.CSSDCResult
		i IsResult'=1 d RtnObj.Err(-2,"","消毒前需清洗验收合格!")
		q:RtnObj.success'=0

		s ExtCode=CleanDetailObj.CSSDCDPLabel
		s Extdr=CleanDetailObj.CSSDCDPExtDR.%Id()
		s ExtObj=##class(User.CSSDExtDevBind).%OpenId(Extdr)
		s TransFlag=ExtObj.CSSDExtIsTransfer
		i TransFlag="Y" d RtnObj.Err(-1,"","已移交，不能二次消毒")
		q:RtnObj.success'=0
		&sql(Update CSSD_CleanDetailPacks set CSSDCDP_Flag='SS' where ID=:DetailId )
		i SQLCODE'=0 d RtnObj.Err(-1,"","更新清洗主表失败！")
		s RtnObj=..UpdateExtState(Extdr,"SW")
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// 获取所有待清洗公用包(按回收记录汇总)
/// why2021-7-28
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Clean.CleanInfo","SelectUnCleanOrd","{""StartDate"":""2021-07-27"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""EndDate"":""2021-07-27""}")
Query SelectAllUnCleanOrd(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "PkgId,PkgDesc,BackQty,CleanQty,UnCleanQty,MaterialId,MaterialDesc") [ SqlProc ]
{
}

ClassMethod SelectAllUnCleanOrdExecute(ByRef qHandle As %Binary, Params As %String = "") As %Status
{
	n (%session,qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK

	s pStartDate = PJObj.%Get("StartDate")
	s pEndDate = PJObj.%Get("EndDate")
	s pStartDate=..DH2L(pStartDate)
	s pEndDate=..DH2L(pEndDate)

	S Pid=..NewPid()
	k ^TMPCSSDCALLBACK("CallBack",Pid)
	f Date=pStartDate:1:pEndDate d
	.s LocId=""
	.f  s LocId=$o(^User.CSSDPackageCallbackI("CSSDAckDateToLoc",Date,LocId)) q:LocId=""  d
	..s CallBackId=""
	..f  s CallBackId=$o(^User.CSSDPackageCallbackI("CSSDAckDateToLoc",Date,LocId,CallBackId)) q:CallBackId=""  d
	...q:'$d(^User.CSSDCallbackDetailNewI("CSSDCDParrefIndex",CallBackId))
	...
	...s CallBackNo=$lg(^User.CSSDPackageCallbackD(CallBackId),8)
	...s ApplyLocId=$lg(^User.CSSDPackageCallbackD(CallBackId),3)
	...s ReqLevel=$lg(^User.CSSDPackageCallbackD(CallBackId),26) ;是否紧急
	...q:ReqLevel=1 ;过滤掉紧急的走绿色通道
	...
	...s ApplyLocDesc=""
	...s:ApplyLocId'="" ApplyLocDesc=$p(^CTLOC(ApplyLocId),"^",2)
	...
	...s DetailId=""
	...s sumqty=0
	...f  s DetailId=$o(^User.CSSDCallbackDetailNewI("CSSDCDParrefIndex",CallBackId,DetailId)) q:DetailId=""  d
	....s DetailList=$g(^User.CSSDCallbackDetailNewD(DetailId))
	....s PkgId=$lg(DetailList,3)
	....s BackQty=$lg(DetailList,4)
	....s MaterialId=$lg(DetailList,11)
	....q:PkgId=""
	....
	....s AttributeId=$lg(^User.CSSDPackageD(PkgId),15)
	....q:AttributeId'=2 		;过滤掉不是公用包的
	....
	....s PkgDesc=$lg(^User.CSSDPackageD(PkgId),5)
	....s MaterialDesc=$s(MaterialId'="":$lg(^User.CSSDMaterialD(MaterialId),3),1:"")
	....S Index=PkgId_"^"_MaterialId
	....If $d(^TMPCSSDCALLBACK("CallBack",Pid,Index)) D
	.....S $P(^TMPCSSDCALLBACK("CallBack",Pid,Index),"^",3)=$P(^TMPCSSDCALLBACK("CallBack",Pid,Index),"^",3)+BackQty
	....Else  D
	.....S ^TMPCSSDCALLBACK("CallBack",Pid,Index)=PkgId_"^"_MaterialId_"^"_BackQty_"^"_MaterialDesc_"^"_PkgDesc

	S Sub=""
	F  S Sub=$o(^TMPCSSDCALLBACK("CallBack",Pid,Sub)) Q:Sub=""  D
	.S Sdata=$g(^TMPCSSDCALLBACK("CallBack",Pid,Sub))
	.S PkgId=$P(Sdata,"^",1)
	.S MateId=$P(Sdata,"^",2)
	.S BackQty=$P(Sdata,"^",3)
	.S MateDesc=$P(Sdata,"^",4)
	.S PkgDesc=$P(Sdata,"^",5)
	.S CleanQty=..GetCleanQtyByCBSum(pStartDate,pEndDate,LocId,PkgId,MateId)
	.s UnCleanQty=BackQty-CleanQty
	.q:UnCleanQty<=0
	.
	.S Data=$lb(PkgId,PkgDesc,BackQty,CleanQty,UnCleanQty,MateId,MateDesc)
	.S ^CacheTemp(repid,ind)=Data
	.S ind=ind+1
	k ^TMPCSSDCALLBACK("CallBack",Pid)
	Quit $$$OK
}

/// 取公用包清洗数量根据日期,科室,消毒包和包装材料id汇总
/// why20210728
/// w ##class(web.CSSDHUI.Clean.CleanInfo).GetCleanQtyByCBNew("65952","65953","","249","1")
ClassMethod GetCleanQtyByCBSum(StartDate, EndDate, CleanLocId, PkgId, MaterialId)
{
	n (%session,StartDate, EndDate, CleanLocId, PkgId, MaterialId)
	s SumCleanQty=0
	f Date=StartDate:1:EndDate d
	.s LocId=""
	.f  s LocId=$o(^User.CSSDCleanI("IndexDateLoc",Date,LocId)) q:LocId=""  d
	..s CleanId=""
	..f  s CleanId=$o(^User.CSSDCleanI("IndexDateLoc",Date,LocId,CleanId)) q:CleanId=""  d
	...q:'$d(^User.CSSDCleanDetailPacksI("IndexMainDr",CleanId))
	...
	...s CleanDetailId=""
	...s CleanDetailId=$o(^User.CSSDCleanDetailPacksI("IndexMainDrMaterialPkgdr",CleanId,MaterialId,PkgId,""))
	...q:CleanDetailId=""
	...
	...s CleanQty=$lg(^User.CSSDCleanDetailPacksD(CleanDetailId),6)
	...s GreenFlag=$lg(^User.CSSDCleanDetailPacksD(CleanDetailId),20)
	...q:GreenFlag'=""    ;过滤掉走绿色通道的
	...
	...s SumCleanQty=SumCleanQty+CleanQty
	q SumCleanQty
}

ClassMethod CompareTime(cleantime As %String)
{
	n (%session,cleantime)
	s CleanTimeLogical=..TH2L(cleantime)
	s currTime=$p($h,",",2)
	s flag=0
	i CleanTimeLogical>currTime d
	.s flag=1
	q flag
}

/// W ##CLASS(web.CSSDHUI.PackageSterilize.Sterilize).GetMachineDayCycle(1)
ClassMethod GetMachineDayCycle(MachineNoId)
{
	n (%session,MachineNoId)
	q:MachineNoId="" 0

	s dateday=+$h
	s num=0
	s rowid=""
	f  s rowid=$o(^User.CSSDCleanI("IndexMachineDRDateDr",MachineNoId,dateday,rowid)) q:rowid=""  d
	.s CompFlag=$list(^User.CSSDCleanD(rowid),18)
	.q:CompFlag'=1
	.s num=num+1

	q num
}

/// Description:计算清洗界面角标数量
/// Creator:lxt
/// Date:20220318
/// Table:
/// Input:Params
/// Output:Json
/// w ##class(web.CSSDHUI.Clean.CleanInfo).GetMarkQty(^templxt("GetMarkQty"))
ClassMethod GetMarkQty(Params)
{
	n (%session,Params)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q "{}"

	s pStartDate = PJObj.%Get("StartDate")
	s pEndDate = PJObj.%Get("EndDate")
	s gHospId = PJObj.%Get("gHospId")
	s gGroupId = PJObj.%Get("gGroupId")
	s gLocId = PJObj.%Get("gLocId")
	s gUserId = PJObj.%Get("gUserId")
	s Data=pStartDate_"^"_pEndDate_"^"_gHospId_"^"_gGroupId_"^"_gLocId_"^"_gUserId
	s TmpTitle="gHospId^gGroupId^gLocId^gUserId"
	s (CallBackNum,CreateNum,OprNum,ExtNum,UnPassCleanNum,UnPassSterNum,ExpireDealNum)=0

	s CallBackTitle="CBStartDate^CBEndDate^"_TmpTitle
	s CallBackParams=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,CallBackTitle)
	s CallBackResult=##class(%Library.ResultSet).%New("web.CSSDHUI.Clean.CleanInfo:SelectUnCleanOrd") ;回收单
	s sc=CallBackResult.Execute(CallBackParams)
	i $$$ISERR(sc) q "{}"

	While(CallBackResult.Next()){s CallBackNum=CallBackNum+1}
	d CallBackResult.Close()

	s CreateTitle="CBStartDate^CBEndDate^"_TmpTitle
	s CreateParams=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,CreateTitle)
	s CreateResult=##class(%Library.ResultSet).%New("web.CSSDHUI.Clean.CleanInfo:SelectForGreenFlag") ;紧急回收单
	s sc=CreateResult.Execute(CreateParams)
	i $$$ISERR(sc) q "{}"

	While(CreateResult.Next()){s CreateNum=CreateNum+1}
	d CreateResult.Close()

	s ExtTitle="EStartDate^EEndDate^"_TmpTitle
	s ExtParams=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,ExtTitle)
	s ExtResult=##class(%Library.ResultSet).%New("web.CSSDHUI.Clean.CleanUnPass:SelectUnExt") ;外来器械
	s sc=ExtResult.Execute(ExtParams)
	i $$$ISERR(sc) q "{}"

	While(ExtResult.Next()){s ExtNum=ExtNum+1}
	d ExtResult.Close()

	s UnPassCleanTitle="UnPassCStartDate^UnPassCEndDate^"_TmpTitle
	s UnPassCleanParams=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,UnPassCleanTitle)
	s UnPassCleanResult=##class(%Library.ResultSet).%New("web.CSSDHUI.Clean.CleanUnPass:SelectUnPassClean") ;清洗不合格
	s sc=UnPassCleanResult.Execute(UnPassCleanParams)
	i $$$ISERR(sc) q "{}"

	While(UnPassCleanResult.Next()){s UnPassCleanNum=UnPassCleanNum+1}
	d UnPassCleanResult.Close()

	s UnPassSterTitle="UnPassSStartDate^UnPassSEndDate^"_TmpTitle
	s UnPassSterParams=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,UnPassSterTitle)
	s UnPassSterResult=##class(%Library.ResultSet).%New("web.CSSDHUI.Clean.CleanUnPass:SelectUnPassSter") ;灭菌不合格
	s sc=UnPassSterResult.Execute(UnPassSterParams)
	i $$$ISERR(sc) q "{}"

	While(UnPassSterResult.Next()){s UnPassSterNum=UnPassSterNum+1}
	d UnPassSterResult.Close()

	s ExpireDealTitle="ExpStartDate^ExpEndDate^"_TmpTitle
	s ExpireDealParams=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,ExpireDealTitle)
	s ExpireDealResult=##class(%Library.ResultSet).%New("web.CSSDHUI.Clean.CleanExpireDeal:SelectExpireDeal") ;过期包
	s sc=ExpireDealResult.Execute(ExpireDealParams)
	i $$$ISERR(sc) q "{}"

	While(ExpireDealResult.Next()){s ExpireDealNum=ExpireDealNum+1}
	d ExpireDealResult.Close()

	s RetData=CallBackNum_"^"_CreateNum_"^"_ExtNum_"^"_UnPassCleanNum_"^"_UnPassSterNum_"^"_ExpireDealNum
	s RetTitle="CallBackNum^CreateNum^ExtNum^UnPassCleanNum^UnPassSterNum^ExpireDealNum"
	s Ret=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(RetData,RetTitle)

	q Ret
}

/// 取回收记录的清洗装车数量
/// w ##class(web.CSSDHUI.Clean.CleanInfo).GetCleanQtyByCB(1)
ClassMethod GetCleanQtyByCBCar(CallBackItmId)
{
	n (%session,CallBackItmId)
	q:CallBackItmId="" ""

	s SumCleanQty=0
	s CleanItmId=""
	f  s CleanItmId=$o(^User.CSSDBasketPackDetailI("CSSDCBPICallBackIndex",CallBackItmId,CleanItmId)) q:CleanItmId=""  d
	.s CleanQty=$lg(^User.CSSDBasketPackDetailD(CleanItmId),5)
	.s SumCleanQty=SumCleanQty+CleanQty

	q SumCleanQty
}

/// Description:判断当前标签是否存在当前清洗单
/// Creator:ZhuoLK
/// CreatDate:2021-06-4
/// Input:清洗主单id，标签
/// OutPut:Y-存在，N-不存在
ClassMethod IFLabelByCLeanDetail(Clean, Label) As %String
{
	n (Clean,Label)
	s CleanDetail="",Flag="N"
	f  s CleanDetail=$o(^User.CSSDCleanDetailPacksI("IndexMainDr",Clean,CleanDetail)) q:CleanDetail=""  d
	.&sql(select count(*) into:num FROM CSSD_Trans WHERE CSSDT_Clean_DR=:CleanDetail AND CSSDT_Label=:Label)
	.s:num'=0 Flag="Y"
	.q:Flag="Y"
	
	q Flag
}

}
