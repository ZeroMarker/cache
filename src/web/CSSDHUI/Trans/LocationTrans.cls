Import SQLUser

/// 标牌位置追溯
Class web.CSSDHUI.Trans.LocationTrans Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Descript:标牌位置追溯
/// Creator:ban
/// CreateDate:2022-11-18
/// Table:cssd_codedict
/// Input:查询条件
/// Return：标牌位置追溯数据
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Trans.LocationTrans","QueryOprPkgLoc","{""PsnType"":"""",""gUserId"":""15952"",""gLocId"":""37"",""gGroupId"":""294"",""gHospId"":""2"",""OprPkg"":""""}")
/// call web_CSSDHUI_Trans.LocationTrans_QueryOprPkgLoc("{}")
Query QueryOprPkgLoc(Params As %Text) As web.CSSDHUI.Query(ROWSPEC = "CodeDict,CodeDictDesc,Label,CurLocationDesc,Remark,ExpDate") [ SqlProc ]
{
}

ClassMethod QueryOprPkgLocExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (qHandle,Params)
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s PCurLocation=PJObj.%Get("CurLocation")
	s PPkgId=PJObj.%Get("OprPkg")
	s gHospId=PJObj.%Get("gHospId")
	s SqlStr="SELECT ID, CSSDCD_PackDR, CSSDCD_Code, CSSDCD_CreateLocDr FROM cssd_codedict"
			_" WHERE CSSDCD_PackDR->CSSDP_PackTypeDetail=1"
	s result=##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(SqlStr)
	d result.Execute()
	While(result.Next())
	{
		s CodeDictId=result.Data("ID")
		s CodeDict=result.Data("CSSDCD_Code")
		s PkgId=result.Data("CSSDCD_PackDR")
		s CreateLocDr=result.Data("CSSDCD_CreateLocDr")
		continue:(PPkgId'="")&&(PPkgId'=PkgId)
		s ShowDataFlag=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CT_Loc",CreateLocDr,gHospId)
		continue:ShowDataFlag="N"
		
		s CurInfo=..GetOprPkgLoc(CodeDictId)
		s CodeDictDesc=$p(CurInfo,"^",1)
		s Label=$p(CurInfo,"^",2)
		s CurLocation=$p(CurInfo,"^",3)
		s CurLocationDesc=$p(CurInfo,"^",4)	;当前位置: 污染区,无菌区等
		s Remark=$p(CurInfo,"^",5)
		s ExpDate=$p(CurInfo,"^",7)
		continue:((PCurLocation'="")&&(PCurLocation'=CurLocation))
		s lbLocInfo=$lb(CodeDict,CodeDictDesc,Label,CurLocationDesc,Remark,ExpDate)
		d OutputRowLocation
	}
	q $$$OK

OutputRowLocation
	s Data=lbLocInfo
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:查找标牌追溯包的当前位置
/// Creator:ban
/// CreateDate:2022-11-18
/// Table:cssd_codedict
/// Input:查询条件
/// Return：标牌追溯包的当前位置
/// w ##Class(web.CSSDHUI.Trans.LocationTrans).GetOprPkgLoc("1") 
ClassMethod GetOprPkgLoc(CodeDictId As %String) As %String
{
	n (CodeDictId)
	q:CodeDictId="" ""
	
	s CodeDict=$lg(^User.CSSDCodeDictD(CodeDictId),2)
	s CodeDictDesc=$lg(^User.CSSDCodeDictD(CodeDictId),6)
	
	s (Label,CurLocation,CurLocationDesc,Remark,ExpDate)=""
	s PackId=$o(^User.CSSDPackagePackI("CodeDict",CodeDictId,""),-1)

	i PackId'="" d
	.s Label=$lg(^User.CSSDPackagePackD(PackId),3)
	.s TransId=$o(^User.CSSDTransI("CSSDTLabel",Label,""))
	.q:TransId=""
	.s TransObj=##Class(User.CSSDTrans).%OpenId(TransId)
	.s Status=TransObj.CSSDTStatus
	.s ExpDate=TransObj.CSSDTExpDate
	.s CleanItmId=TransObj.CSSDTCleanGetObjectId()
	.s SterItmId=TransObj.CSSDTSterilizeGetObjectId()
	.s ExpDate=..DL2H(ExpDate)
	.
	.i ((Status="D")||(Status="R")||(Status="U")) d
	..s toLocId=""
	..&sql(select CSSDPD_ToLoc_DR into :toLocId from cssd_packagedisp where CSSDPD_Label=:Label)
	..s CurLocationDesc=..sssLocDesc(toLocId)
	.
	.e  i Status="C" d
	..s CurLocation="CallBack"
	..s CurLocationDesc="回收区"
	..s CleanItmId=$o(^User.CSSDCleanDetailPacksI("CSSDIndexCDPLabel",CodeDict,""),-1)
	..i CleanItmId'="" d
	...s CleanItmObj=##Class(User.CSSDCleanDetailPacks).%OpenId(CleanItmId)
	...s CleanObj=CleanItmObj.CSSDCDPCleanMain
	...s IsCrtLbl=CleanItmObj.CSSDCDPIsCrtLbl		;是否生成标签
	...
	...s MachineNo=CleanObj.CSSDCMachineNo
	...s CheckResult=CleanObj.CSSDCResult
	...s CleanDate=CleanObj.CSSDCDate
	...s CleanTime=CleanObj.CSSDCTime
	...s CleanDate=..DL2H(CleanDate)
	...s CleanTime=..TL2H(CleanTime)
	...
	...i IsCrtLbl=0 d
	....s Label=""
	....i CheckResult="" d
	.....s CurLocation="Clean"
	.....s CurLocationDesc="清洗机"
	.....s Remark=MachineNo_"号清洗机,进清洗机时间"_CleanDate_" "_CleanTime
	....e  i CheckResult=1 d
	.....s CurLocation="Pack"
	.....s CurLocationDesc="打包区"
	.....s Remark="未打印标签"
	....e  i CheckResult=0 d
	.....s CurLocation="Clean"
	.....s CurLocationDesc="清洗机"
	.....s Remark="清洗验收不合格"
	.
	.e  i Status="P" d
	..s CurLocation="Pack"
	..s CurLocationDesc="打包区"
	..s Remark="已经打印标签"
	..s SterItmId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSLabel",Label,""),-1)
	..i SterItmId'="" d
	...s CurLocation="Ster"
	...s CurLocationDesc="灭菌器"
	...s SterItmObj=##Class(User.CSSDPackageSterilize).%OpenId(SterItmId)
	...s SterObj=SterItmObj.CSSDPSParref
	...
	...s MachineNo=SterObj.CSSDSRMachineNo
	...s SterDate=SterObj.CSSDSRDate
	...s SterTime=SterObj.CSSDSRTime
	...s SterDate=..DL2H(SterDate)
	...s SterTime=..TL2H(SterTime)
	...s Remark=MachineNo_"号灭菌器,进灭菌器时间"_SterDate_" "_SterTime
	.
	.e  i Status="S" d
	..s CurLocation="Disp"
	..s CurLocationDesc="无菌区"
	.
	.e  i Status="TC" d
	..s CurLocationDesc="过期处理"
	..s Remark="过期处理"
	.
	e  d
	.
	.s CleanItmId=$o(^User.CSSDCleanDetailPacksI("CSSDIndexCDPLabel",CodeDict,""),-1)
	.i CleanItmId'="" d
	..s CleanItmObj=##Class(User.CSSDCleanDetailPacks).%OpenId(CleanItmId)
	..i CleanItmObj.CSSDCDPIsCrtLbl=0 d
	...s CleanObj=CleanItmObj.CSSDCDPCleanMain
	...s MachineNo=CleanObj.CSSDCMachineNo
	...s CheckResult=CleanObj.CSSDCResult
	...s CleanDate=CleanObj.CSSDCDate
	...s CleanTime=CleanObj.CSSDCTime
	...s CleanDate=..DL2H(CleanDate)
	...s CleanTime=..TL2H(CleanTime)
	...
	...i CheckResult="" d
	....s CurLocation="Clean"
	....s CurLocationDesc="清洗机"
	....s Remark=MachineNo_"号清洗机,进清洗机时间"_CleanDate_" "_CleanTime
	...e  i CheckResult=1 d
	....s CurLocation="Pack"
	....s CurLocationDesc="打包区"
	....s Remark="未打印标签"
	...e  i CheckResult=0 d
	....s CurLocation="Clean"
	....s CurLocationDesc="清洗机"
	....s Remark="清洗验收不合格"
	.e  d
	..s CurLocationDesc="未使用"
	
	s Ret=CodeDictDesc_"^"_Label_"^"_CurLocation_"^"_CurLocationDesc_"^"_Remark_"^"_CodeDict_"^"_ExpDate
	q Ret
}

}
