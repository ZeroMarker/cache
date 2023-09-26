Import sqluser

/// Creator:cy
/// CreatDate:2019-8-28
/// Description:通过回收选取发放单
/// Table:CSSD_PackageCallback
Class web.CSSDHUI.PackageDisp.CreateDispByApply Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.PackageDisp.CreateDispByApply","SelectDispForCallBack",^templxt("disp"))
Query SelectDispForCallBack(Params As %String = "") As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,No,ReqLocDesc,ApplyDate,AckDate,AckUserDesc,ApplyUserDesc,DispFlag,ReqLevel,ApplyTypeDesc,ApplyNo,AllCreateFlag") [ SqlProc ]
{
}

ClassMethod SelectDispForCallBackExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 $$$OK
	s PReqLocId=PJObj.%Get("ReqLoc")
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	s PReqNo=PJObj.%Get("ReqNo")
	s PApplyNo=PJObj.%Get("ApplyNo")
	s PDispFlag=PJObj.%Get("DispFlag")
	s PLineCode=PJObj.%Get("LineCode")
	s gHospId=PJObj.%Get("gHospId")
	s PApplyType=PJObj.%Get("ApplyType")
	s PLabel=PJObj.%Get("CBBarCode")
	s PExcludeExt=PJObj.%Get("ExcludeExt")
	s PStartDate=..DH2L(PStartDate)
	s PEndDate=..DH2L(PEndDate)
	q:(PStartDate="")||(PEndDate="") $$$OK
	
	s CallBackId=""
	i PLabel'="" d
	.s PackId=$o(^User.CSSDPackagePackI("CSSDPPLabelIndex",PLabel,""))
	.s PackObj=##class(User.CSSDPackagePack).%OpenId(PackId)
	.q:'$IsObject(PackObj)
	.d PackObj.%Reload()
	.s CleanObj=PackObj.CSSDPPCleanDetailDR
	.q:'$IsObject(CleanObj)
	.s CBItmId=CleanObj.CSSDCDPCallBackDetailDrGetObjectId()
	.s:CBItmId'="" CallBackId=$lg(^User.CSSDCallbackDetailNewD(CBItmId),2)
	
	s LineLocStr=##class(web.CSSDHUI.Common.PackageInfoCommon).GetLocByLine(PLineCode)
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="select CSSDPC_Rowid As RowId,CSSDPC_SerialNo,CSSDPC_ToLoc_DR,"
			_"CSSDPC_FromLoc_DR,CSSDPC_Date,CSSDPC_Time,CSSDPC_ApplyType,"
			_"CSSDPC_AckDate,CSSDPC_AckTime,CSSDPC_ToUser_DR,CSSDPC_AckUser_DR,"
			_"CSSDPC_ComplateFlag,CSSDPC_IsDispFlag,CSSDPC_ReqLevel,CSSDPC_ISOPRFlag,"
			_"CSSDPC_PackageApplyDR->CSSDPA_NO"
			_" from CSSD_PackageCallback"
			_" where CSSDPC_Date between "_PStartDate_" AND "_PEndDate
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId=Result.Data("RowId")
		s No=Result.Data("CSSDPC_SerialNo")
		s ApplyNo=Result.Data("CSSDPA_NO")
		s SupLocId=Result.Data("CSSDPC_ToLoc_DR")
		s ApplyDate=Result.Data("CSSDPC_Date")
		s ApplyTime=Result.Data("CSSDPC_Time")
		s AckDate=Result.Data("CSSDPC_AckDate")
		s AckTime=Result.Data("CSSDPC_AckTime")
		s ReqLocId=Result.Data("CSSDPC_FromLoc_DR")
		s AckUserId=Result.Data("CSSDPC_AckUser_DR")
		s ApplyUserId=Result.Data("CSSDPC_ToUser_DR")
		s DispFlag=Result.Data("CSSDPC_IsDispFlag")
		s ReqLevel=Result.Data("CSSDPC_ReqLevel")
		s ComplateFlag=Result.Data("CSSDPC_ComplateFlag")
		s ApplyType=Result.Data("CSSDPC_ApplyType")
		s:ApplyType="" ApplyType=0
		s AllCreateFlag=..CheckItmDisp(RowId,PExcludeExt)
		s ShowDataFlag=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CT_Loc",SupLocId,gHospId)
		continue:ShowDataFlag="N"
		continue:(PLabel'="")&&(CallBackId'=RowId)
		continue:((ComplateFlag'="Y")&&(ComplateFlag'="W"))
		continue:((PReqNo'="")&&(PReqNo'=No))
		continue:((PApplyNo'="")&&(PApplyNo'=ApplyNo))
		continue:((PReqLocId'="")&&(PReqLocId'=ReqLocId))
		continue:(PDispFlag=1)&&(AllCreateFlag="Y")
		continue:(PDispFlag=2)&&((AllCreateFlag="N")||(DispFlag="Y"))
		continue:((PDispFlag=3)&&(DispFlag="N"))
		continue:(PApplyType'="")&&((","_PApplyType_",")'[(","_ApplyType_","))
		continue:(LineLocStr'="")&&(LineLocStr'[("^"_ReqLocId_"^"))
		s AckDate=..DL2H(AckDate)_" "_..TL2H(AckTime)
		s ApplyDate=..DL2H(ApplyDate)_" "_..TL2H(ApplyTime)
		s ReqLocDesc=..sssLocDesc(ReqLocId)
		s AckUserDesc=..sssUserName(AckUserId)
		s ApplyUserDesc=..sssUserName(ApplyUserId)
		s ApplyTypeDesc=##class(web.CSSDHUI.Common.PackageInfoCommon).getReqTypeDesc(ApplyType)
		d OutPutRow
	}
	d Result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,No,ReqLocDesc,ApplyDate,AckDate,AckUserDesc,ApplyUserDesc,DispFlag,ReqLevel,ApplyTypeDesc,ApplyNo,AllCreateFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// CreatDate:2019-8-28
/// Description:查询数据
/// Table:CSSD_CallBackDetailNew
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.PackageDisp.CreateDispByApply","SelectByF","6",""){""ExcludeEx"":""Y"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}")
Query SelectByF(ApplyId As %String, Params As %String = "") As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,MainId:%Integer,PkgId:%Integer,PkgDesc,BackQty,DispQty,PreDispQty,LevelFlag,Material,CodeDict,Label,BeInfected,Status") [ SqlProc ]
{
}

ClassMethod SelectByFExecute(ByRef qHandle As %Binary, ApplyId As %String, Params As %String = "") As %Status
{
	n (qHandle,ApplyId,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:ApplyId="" $$$OK
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 $$$OK
	s PExcludeExt=PJObj.%Get("ExcludeExt")
	s Str=""
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="select CSSDCD_Rowid,CSSDCD_Package_DR,CSSDCD_Qty,CSSDCD_DispQty,CSSDCD_Parref_DR,"
			_"CSSDCD_LevelFlag,CSSDCD_Material,CSSDPC_DictLabel,CSSDPC_PackageLabel,CSSDCDP_BeInfected,CSSDCD_IsClean"
			_" FROM CSSD_CallBackDetailNew "
			_" WHERE CSSDCD_Parref_DR in ("_ApplyId_")"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId=Result.Data("CSSDCD_Rowid")
		s PkgId=Result.Data("CSSDCD_Package_DR")
		s BackQty=Result.Data("CSSDCD_Qty")
		s LevelFlag=Result.Data("CSSDCD_LevelFlag")
		s Material=Result.Data("CSSDCD_Material")
		s CodeDict=Result.Data("CSSDPC_DictLabel")
		s MainId=Result.Data("CSSDCD_Parref_DR")
		s BeInfected=Result.Data("CSSDCDP_BeInfected")
		s IsClean=Result.Data("CSSDCD_IsClean")
		;continue:IsClean="Y"
		
		;过滤加入清洗架的
		s CleanBasketId=$o(^User.CSSDBasketPackDetailI("CSSDCBPICallBackIndex",RowId,""))
		continue:CleanBasketId'=""
		
		;外来器械多个标签标牌显示一条
		continue:(CodeDict'="")&&(Str[CodeDict)
		s IsExit=##class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PkgId)
		s TmpNum=0,ItemId=""
		i IsExit="Y" d
		.f  s ItemId=$o(^User.CSSDCallbackDetailNewI("CSSDPCDictLabelIndex",CodeDict,ItemId)) q:ItemId=""  d
		..i ItemId'="" s TmpNum=TmpNum+1
		i TmpNum'=0 s BackQty=TmpNum
		i Str="" s Str=CodeDict
		e  s Str=Str_","_CodeDict
		s packageObj = ##class(User.CSSDPackage).%OpenId(PkgId)
		s PkgDesc=packageObj.CSSDPDesc
		s IsExt=##class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PkgId)
		continue:(PExcludeExt="Y")&&(IsExt="Y")
		i CodeDict'="" d
		.&sql(select cssdcd_packname into :PkgDesc from cssd_codedict where cssdcd_code=:CodeDict)
		s DispQty=##class(web.CSSDHUI.PackageDisp.DispItm).GetCallBackDispQty(RowId)
		s PreDispQty=BackQty-DispQty
		s Label=""
		s CleanItmId=$o(^User.CSSDCleanDetailPacksI("IndexCallBackDetailDr",RowId,""))
		i CleanItmId'="" d
		.&sql(select CSSDPP_Label into :Label from CSSD_PackagePack where CSSDPP_CleanDetail_DR=:CleanItmId)
		i Label'="" d
		.s TransId=$o(^User.CSSDTransI("CSSDTLabel",Label,""))
		.s transInfo=##Class(User.CSSDTrans).%OpenId(TransId)
		.d transInfo.%Reload()
		.s Status=transInfo.CSSDTStatus
		.s Status=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetStatusChinese(Status)
		s:CodeDict="" Label=""
		d OutPutRowId
	}
	d Result.Close()
	Quit $$$OK
OutPutRowId
	s Data=$lb(RowId,MainId,PkgId,PkgDesc,BackQty,DispQty,PreDispQty,LevelFlag,Material,CodeDict,Label,BeInfected,Status)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Decription:判断回收明细是否全部发放
/// Creator：lxt
/// CreateDate:20220614
/// w ##class(web.CSSDHUI.PackageDisp.CreateDispByApply).CheckItmDisp(29)
ClassMethod CheckItmDisp(CallBackId, ExcludeExt = "N")
{
	n (CallBackId,ExcludeExt)
	
	s Flag="Y"
	s ItmId=0
	f  s ItmId=$o(^User.CSSDCallbackDetailNewI("CSSDCDParrefIndex",CallBackId,ItmId)) q:(ItmId="")||(Flag="N")  d
	.s ItmObj=##class(User.CSSDCallbackDetailNew).%OpenId(ItmId)
	.d ItmObj.%Reload()
	.s PkgId=ItmObj.CSSDCDPackageDr.%Id()
	.s IsExt=##class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PkgId)
	.q:(ExcludeExt="Y")&&(IsExt="Y")	//过滤外来器械
	.s Qty = ItmObj.CSSDCDQty
	.s DispQty = ItmObj.CSSDCDDispQty
	.s PreDispQty=Qty-DispQty
	.q:PreDispQty<=0
	.s Flag="N"
	
	q Flag
}

}
