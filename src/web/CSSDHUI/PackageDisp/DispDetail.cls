Import SqlUser

Class web.CSSDHUI.PackageDisp.DispDetail Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:why
/// CreatDate:2020-2-13
/// Description:根据发放明细表rowid获取发放标签明细表
/// Table:CSSD_PackageDisp
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.PackageDisp.DispDetail","SelectByF","15")
Query SelectByF(DispId As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Label,PackageName,PackMaterial,PackMaterialName,PackageDR")
{
}

ClassMethod SelectByFExecute(ByRef qHandle As %Binary, DispId As %String) As %Status
{
	n (qHandle,DispId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:DispId="" $$$OK
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT CSSDPDD_Rowid as RowId,CSSDPDD_Label as Label,CSSDPDD_PackageDr as PackageDr,"
			_"CSSDPDD_PackMaterial,CSSDPDD_PackMaterial->CSSDM_Desc As PackMaterialName"
			_" FROM CSSD_PackageDispDetail WHERE CSSDPDD_Parref_DR in ("_DispId_")"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s Label = Result.Data("Label")
		s PackageDR = Result.Data("PackageDr")
		s PackMaterial = Result.Data("CSSDPDD_PackMaterial")
		s PackMaterialName= Result.Data("PackMaterialName")
		i PackageDR'=""  d
		.s packageObj = ##class(User.CSSDPackage).%OpenId(PackageDR)
		.s PackageName=packageObj.CSSDPDesc
		d OutPutRow
	}
	d Result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,Label,PackageName,PackMaterial,PackMaterialName,PackageDR)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:消毒包发放/按单据发放/消毒包调拨扫码发放共用(注意判断条件)
/// w ##class(web.CSSDHUI.PackageDisp.DispDetail).jsSaveDetail(^tmpmy("greg"),^tmpmy("gre2g"))
/// 前端调用
ClassMethod jsSaveDetail(MainParams, Params) As %Library.String
{
	n (%session,MainParams,Params)
	s $ZT=..sssError()
	
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s MainObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=MainObj.%FromJSON(MainParams)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!")
	s MainId=MainObj.%Get("MainId")
	
	ts
	s RtnObj=..SaveDetail(MainParams,Params)
	i RtnObj.success<0 tro  q RtnObj.Json()
	
	s IsOver="N",IsCommit="N"
	s DispId=0
	f  s DispId=$o(^User.CSSDPackageDispI("CSSDPDCParrefDr",MainId,DispId)) q:DispId=""  d
	.s DispInfo=##Class(User.CSSDPackageDisp).%OpenId(DispId)
	.q:'$IsObject(DispInfo)
	.d DispInfo.%Reload()
	.s Qty=DispInfo.CSSDPDQty
	.s DispQty=DispInfo.CSSDPDDispQty
	.s PackageDesc=DispInfo.CSSDPDPackage.CSSDPDesc
	.s UnDispQty=DispInfo.CSSDPDUnDispQty
	.i UnDispQty>0 s IsCommit="Y"
	.i DispQty>Qty s IsOver="Y"
	
	/*
	s MainObj=##Class(User.CSSDPackageDispMain).%OpenId(MainId)
	d MainObj.%Reload()
	s DispType=MainObj.CSSDPDMType
	i (DispType="N")&&(IsCommit="N") d
	.s ParamData=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId_"^"_MainId_"^"_"N"
	.s ParamTitle="gGroupId^gLocId^gUserId^gHospId^mainRowId^Type"
	.s Param=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(ParamData,ParamTitle)
	.s RtnObj=##class(web.CSSDHUI.PackageDisp.Disp).SubmitOrder(Param)
	i RtnObj.success<0 tro  q RtnObj.Json()
	*/
	
	i IsOver="Y" d RtnObj.Err(1,"",..%Translate($CLASSNAME(),PackageDesc_"已超出发放数量"),"",0)
	tc
	
	q RtnObj.Json()
}

ClassMethod SaveDetail(MainParams, Params) As web.CSSDHUI.RtnObj
{
	n (%session,MainParams,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	
	s MainObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=MainObj.%FromJSON(MainParams)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!")
	s MainId=MainObj.%Get("MainId")
	s gUserId=MainObj.%Get("gUserId")
	s gGroupId=MainObj.%Get("gGroupId")
	s gLocId=MainObj.%Get("gLocId")
	s gHospId=MainObj.%Get("gHospId")
	i MainId="" q RtnObj.Err(-2,"","请选择发放单据!")
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")
	
	s MainObj=##Class(User.CSSDPackageDispMain).%OpenId(MainId)
	d MainObj.%Reload()
	s DispUser=MainObj.CSSDPDMFromUserDrGetObjectId()
	s DispDate=MainObj.CSSDPDMDate
	s ToLoc=MainObj.CSSDPDMToLocDrGetObjectId()
	s CompleteFlag=MainObj.CSSDPDMComplateFlag
	s DocType=MainObj.CSSDPDMDocType
	s DispType=MainObj.CSSDPDMType
	q:CompleteFlag="Y" RtnObj.Err(-2,"",..%Translate($CLASSNAME(),"发放单已经提交不能添加明细！"),"",0)
	
	s Param=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	s IfMoreDispQty=##class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDDISP","IfMoreDispQty",Param)
	s FilterByLoc=##class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDDISP","FilterByLoc",Param)
	s IfComfiredRecLoc=##class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDDISP","IfComfiredRecLoc",Param)
	
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s barCode=Obj.%Get("Label")
		s DetailId=Obj.%Get("DispId")			;这个应该是RowId
		
		s packId=$o(^User.CSSDPackagePackI("CSSDPPLabelIndex",barCode,""))
		i packId="" d RtnObj.Err(-3,"",..%Translate($CLASSNAME(),"未找到该条码信息！"),"",0)
		q:RtnObj.success'=0 
		
		s PackObj=##Class(User.CSSDPackagePack).%OpenId(packId)
		d PackObj.%Reload()
		i (FilterByLoc="Y")&&(DocType'=1) d
		.s PackRecLoc=PackObj.CSSDPPPackLocDr
		.q:'$IsObject(PackRecLoc)
		.s PackRecLocId=PackRecLoc.%Id()
		.i ToLoc'=PackRecLocId d RtnObj.Err(-4,"","接收科室与标签对应接收科室不一致!","",0)
		
		s PkgLocId=..GetPkgLocByLabel(barCode)
		i (IfComfiredRecLoc="Y")&&(PkgLocId'="")&&(PkgLocId'=ToLoc) d
		.d RtnObj.Err(-4,"",..%Translate($CLASSNAME(),"包绑定科室与发放接收科室不同!"),"",0)
		q:RtnObj.success'=0
		
		s Flag=##class(web.CSSDHUI.PackageSterilize.Sterilize).CheckLabelSterIng(barCode)
		i Flag="Y" d RtnObj.Err(-9,"",..%Translate($CLASSNAME(),"灭菌中!"),"",0)
		q:RtnObj.success'=0
		
		s CodeDict=##class(web.CSSDHUI.Common.PackageInfoCommon).GetFixedLabel(barCode)
		i DocType'=1 d
		.s DispFlag=##class(web.CSSDHUI.PackageDisp.Disp).CheckLabelDispExist(barCode)
		.s TipStr=$s(CodeDict'="":CodeDict,1:barCode)
		.i DispFlag="Y" d RtnObj.Err(-9,"",..%Translate($CLASSNAME(),TipStr_"标签已发放"),"",0)
		q:RtnObj.success'=0
		
		s PackObj=##class(User.CSSDPackagePack).%OpenId(packId)
		d PackObj.%Reload()
		s PackMaterialId=PackObj.CSSDPPMaterialDrGetObjectId()
		s PackageObj=PackObj.CSSDPPPackage
		s LevelFlag=PackObj.CSSDPPLevelFlag
		s HospId=PackObj.CSSDPPPackage.CSSDPHospitalGetObjectId()
		i (gHospId'="")&&(HospId'=gHospId) d RtnObj.Err(-10,"",..%Translate($CLASSNAME(),"非本院条码!"),"",0)
		q:RtnObj.success'=0
		s PkgId=PackageObj.%Id()
		s AttributeId=PackageObj.CSSDPPackTypeDetail
		s IsSter=PackageObj.CSSDPSterType.CSSDSTIsSter
		i IsSter="Y" d
		.s TransId=$o(^User.CSSDTransI("CSSDTLabel",barCode,""))
		.s TransInfo=##Class(User.CSSDTrans).%OpenId(TransId)
		.d TransInfo.%Reload()
		.s ExpDate=TransInfo.CSSDTExpDate
		.s status=TransInfo.CSSDTStatus
		.s SterItmId=TransInfo.CSSDTSterilizeGetObjectId()
		.i SterItmId="" d RtnObj.Err(-5,"",..%Translate($CLASSNAME(),"没有灭菌,不能发放！"),"",0) q
		.s IsChkSate=##class(User.CSSDPackageSterilize).%OpenId(SterItmId).CSSDPSStates
		.i IsChkSate="N" d RtnObj.Err(-6,"",..%Translate($CLASSNAME(),"条码灭菌不合格,不能发放！"),"",0) q
		.s NowDate=+$h
		.i NowDate>=ExpDate d RtnObj.Err(-7,"",..%Translate($CLASSNAME(),"条码已经过期,不能发放！"),"",0) q
		.i status="RC" d RtnObj.Err(-8,"",..%Translate($CLASSNAME(),"条码召回状态,不能发放！"),"",0) q
		q:RtnObj.success'=0
		s Price=0
		s MatInfo=##class(web.CSSDHUI.Common.PackageInfoCommon).GetMaterialExpireLength(PackMaterialId,PkgId)
		s Price=$p(MatInfo,"^",2)

		i DispType="N" d
		.s:DetailId="" DetailId=$o(^User.CSSDPackageDispI("CSSDPDParrefDrIndex",MainId,PkgId,""))
		.i DetailId="" d RtnObj.Err(-10,"",..%Translate($CLASSNAME(),"此条码不是这个发放单！"),"",0)
		.q:RtnObj.success'=0
		.s DispInfo=##class(User.CSSDPackageDisp).%OpenId(DetailId)
		.d DispInfo.%Reload()
		.s UnDispQty=DispInfo.CSSDPDUnDispQty		// 未扫码数量
		.s DispQty=DispInfo.CSSDPDDispQty			// 扫码发放数量
		.s Qty=DispInfo.CSSDPDQty
		.i UnDispQty<=0 s NowUnDispQty=0
		.e  s NowUnDispQty=UnDispQty-1
		.s NowDispQty=DispQty+1
		.
		.i ((IfMoreDispQty="N")&&(NowDispQty>Qty)) d RtnObj.Err(-10,"",..%Translate($CLASSNAME(),"单据明细扫码数不能超过单据未发数！"),"",0)
		.q:RtnObj.success'=0
		.&sql(insert into CSSD_PackageDispDetail(CSSDPDD_Label,CSSDPDD_Parref_DR,
			CSSDPDD_PackageDr,CSSDPDD_DispPrice,CSSDPDD_PackMaterial)
			values(:barCode,:DetailId,:PkgId,:Price,:PackMaterialId))
		.i SQLCODE'=0 d RtnObj.Err(-12,"",..%Translate($CLASSNAME(),"保存扫码发放明细数据失败！"),"",0)
		.q:RtnObj.success'=0
		.&sql(update cssd_trans set cssdt_disp_dr=:DetailId,cssdt_status='D' where cssdt_label=:barCode )
		.i SQLCODE'=0 d RtnObj.Err(-13,"",..%Translate($CLASSNAME(),"更新追踪表状态数据失败！"),"",0)
		.q:RtnObj.success'=0
		.&sql(UPDATE CSSD_PackageDisp SET CSSDPD_Qty=:Qty,CSSDPD_UnDispQty=:NowUnDispQty,CSSDPD_DispQty=:NowDispQty WHERE CSSDPD_Rowid=:DetailId )
		.i SQLCODE'=0 d RtnObj.Err(-14,"",..%Translate($CLASSNAME(),"保存发放明细数据失败！"),"",0)
		.q:RtnObj.success'=0
		e  d
		.s Qty=1,nowTime=$p($h,",",2)
		.&sql(insert into cssd_packagedisp
			(CSSDPD_Label, CSSDPD_Package_DR ,CSSDPD_PackMaterial,CSSDPD_Qty,
			CSSDPD_Parref_DR,CSSDPD_DispUser_DR,CSSDPD_DispQty,CSSDPD_UnDispQty,CSSDPD_TotalPrice,
			CSSDPD_Date,CSSDPD_ToLoc_DR,CSSDPD_DispPrice,CSSDPD_FromLoc_Dr,CSSDPD_FromUser_Dr,CSSDPD_LevelFlag,
			CSSDPD_DispDate,CSSDPD_DispTime)
			values(:barCode,:PkgId,:PackMaterialId,:Qty,
				:MainId,:gUserId,1,0,:Price,
				:DispDate,:ToLoc,:Price,:FromLocDr,:gUserId,:LevelFlag,
				:nowDate,:nowTime)
			)
		.i SQLCODE'=0 d RtnObj.Err(-12,"",$ClassName()_"jsSaveDetail:"_..%Translate($CLASSNAME(),"保存发放明细数据失败!"))
		.q:RtnObj.success'=0
		.s PkgDispId=%ROWID
		.i AttributeId="1" d
		..s RtnObj=##class(web.CSSDHUI.PackageDisp.DispItm).UpdateWLStatus(barCode,"D")
		..q:RtnObj.success'=0
		.;e  i DocType'=1		//发放单
		..;s CallBackRowId=##class(web.CSSDHUI.PackageDisp.DispDetail).IsHasCallBack(ToLoc,DispDate,PkgId)	;判断是否存在对应的回收单
		..;i CallBackRowId'="" d
		..;.&sql(UPDATE CSSD_CallBackDetailNew SET CSSDCD_DispQty=CSSDCD_DispQty+1 WHERE CSSDCD_Rowid=:CallBackRowId)
		..;.i SQLCODE'=0 d RtnObj.Err(-13,"",$ClassName()_":SaveOrdDetail:"_..%Translate($CLASSNAME(),"更新回收单信息失败!"))
		..;q:RtnObj.success'=0
		.q:RtnObj.success'=0
		.i DocType=1 d
		..&sql(update cssd_trans set CSSDT_Trf_DR=:PkgDispId,cssdt_status='D' where cssdt_label=:barCode )
		.e  d
		..&sql(update cssd_trans set cssdt_disp_dr=:PkgDispId,cssdt_status='D' where cssdt_label=:barCode )
		..i SQLCODE'=0 d RtnObj.Err(-17,"",$ClassName()_"jsSaveDetail:"_..%Translate($CLASSNAME(),"保存明细数据失败!"))
		.q:RtnObj.success'=0
		q:RtnObj.success'=0
		s RtnObj.rowid=DetailId		// 扫码发放的时候 无法获取对应的明细ID 则默认显示最后一个标签对应的单据明细ID
	}
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Creator:why
/// CreatDate:2020-2-17
/// Description:删除发放标签明细
/// Table:同Delete方法中的Table一致
/// d ##class(web.CSSDHUI.PackageDisp.DispDetail).jsDelete(214)
ClassMethod jsDelete(Params As %String) As %Library.String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!").Json()
	
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s rowId=Obj.%Get("RowId")
		continue:rowId=""
		s RtnObj=..Delete(rowId)
		q:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:why
/// CreatDate:2020-2-17
/// Description:删除发放标签明细
/// Table:CSSD_PackageDisp	CSSD_PackageDispDetail
/// d ##class(web.CSSDHUI.PackageDisp.DispDetail).Delete(40)
ClassMethod Delete(rowId As %String) As web.CSSDHUI.RtnObj
{
	n (rowId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i rowId="" d RtnObj.Err(-1,"","入参不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	s DispDetailInfo=##class(User.CSSDPackageDispDetail).%OpenId(rowId)
	d DispDetailInfo.%Reload()
	s PackageObj=DispDetailInfo.CSSDPDDPackageDr
	s PackageDr=PackageObj.%Id()
	s Label=DispDetailInfo.CSSDPDDLabel
	s DispId=DispDetailInfo.CSSDPDDParrefDr.%Id()
	s DispObj = ##class(User.CSSDPackageDisp).%OpenId(DispId)
	s Qty=DispObj.CSSDPDQty
	s DispQty=DispObj.CSSDPDDispQty
	s UnDispQty=DispObj.CSSDPDUnDispQty
	i DispQty>Qty s UnDispQty=0	//已扫码发放数量大于额定发放数时，未扫码发放数设置为0
	e  s UnDispQty=UnDispQty+1
	s transId= $o(^User.CSSDTransI("CSSDTLabel",Label,""))
	s transInfo=##Class(User.CSSDTrans).%OpenId(transId)
	d transInfo.%Reload()
	s Status=transInfo.CSSDTStatus
	i (Status="U") d RtnObj.Err(-2,"","已经被患者使用不能删除","",0)
	q:RtnObj.success'=0 RtnObj
	&sql(Delete from CSSD_PackageDispDetail where CSSDPDD_Rowid=:rowId)
	i SQLCODE'=0  d RtnObj.Err(-5,"","删除数据失败","",0) 
	q:RtnObj.success'=0 RtnObj
	
	s TmpStatus="S"
	s:PackageObj.CSSDPSterType.CSSDSTIsSter'="Y" TmpStatus="P"	;针对只清洗不灭菌的情况
	&sql(Update CSSD_Trans set cssdt_disp_dr=null,cssdt_status=:TmpStatus where cssdt_label=:Label)
	i SQLCODE'=0  d
	.d RtnObj.Err(-3,rowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
	q:RtnObj.success'=0 RtnObj
	
	i DispQty>0 d
	.&sql(Update CSSD_PackageDisp set CSSDPD_DispQty=CSSDPD_DispQty-1,CSSDPD_UnDispQty=:UnDispQty where CSSDPD_Rowid=:DispId)
	.i SQLCODE'=0  d RtnObj.Err(-3,"","更新发放数量失败","",0) 
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Description:计算发放界面角标数量
/// Creator:lxt
/// Date:20220318
/// Table:
/// Input:Params
/// Output:Json
/// w ##class(web.CSSDHUI.PackageDisp.DispDetail).GetMarkQty(^tmpmy("vdv"))
ClassMethod GetMarkQty(Params)
{
	n (Params)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q "{}"	
	s pStartDate = PJObj.%Get("StartDate")
	s pEndDate = PJObj.%Get("EndDate")
	s gHospId = PJObj.%Get("gHospId")
	s gGroupId = PJObj.%Get("gGroupId")
	s gLocId = PJObj.%Get("gLocId")
	s gUserId = PJObj.%Get("gUserId")
	s DispFlag = PJObj.%Get("DispFlag")
	s pExcludeExt = PJObj.%Get("ExcludeExt")
	s TmpData=gHospId_"^"_gGroupId_"^"_gLocId_"^"_gUserId_"^"_DispFlag
	s TmpTitle="gHospId^gGroupId^gLocId^gUserId^DispFlag"
	s (ReturnNum,ApplyNum,FLApplyNum)=0
	s ReturnTitle=TmpTitle_"^StartDate^EndDate^ApplyType^ExcludeExt"
	s ReturnData=TmpData_"^"_pStartDate_"^"_pEndDate_"^"_"0,5"_"^"_pExcludeExt
	s ReturnParams=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(ReturnData,ReturnTitle)
	s ReturnResult=##class(%Library.ResultSet).%New("web.CSSDHUI.PackageDisp.CreateDispByApply:SelectDispForCallBack")
	s sc=ReturnResult.Execute(ReturnParams)
	i $$$ISERR(sc) q "{}"
	While(ReturnResult.Next()){s ReturnNum=ReturnNum+1}
	d ReturnResult.Close()

	s ApplyTitle=TmpTitle_"^StartDate^EndDate^ApplyType"
	s ApplyData=TmpData_"^"_pStartDate_"^"_pEndDate_"^"_"1"
	s ApplyParams=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(ApplyData,ApplyTitle)
	s ApplyResult=##class(%Library.ResultSet).%New("web.CSSDHUI.PackageDisp.CreateDispByApply:SelectDispForCallBack")
	s sc=ApplyResult.Execute(ApplyParams)
	i $$$ISERR(sc) q "{}"
	While(ApplyResult.Next()){s ApplyNum=ApplyNum+1}
	d ApplyResult.Close()

	s FLApplyTitle=TmpTitle_"^StartDate^EndDate^ApplyType"
	s FLApplyData=TmpData_"^"_pStartDate_"^"_pEndDate_"^"_"2"
	s FLApplyParams=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(FLApplyData,FLApplyTitle)
	s FLApplyResult=##class(%Library.ResultSet).%New("web.CSSDHUI.PackageDisp.CreateDispByApply:SelectDispForCallBack")
	s sc=FLApplyResult.Execute(FLApplyParams)
	i $$$ISERR(sc) q "{}"
	While(FLApplyResult.Next()){s FLApplyNum=FLApplyNum+1}
	d FLApplyResult.Close()
	
	s RetData=ReturnNum_"^"_ApplyNum_"^"_FLApplyNum
	s RetTitle="ReturnNum^ApplyNum^FLApplyNum"
	s Ret=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(RetData,RetTitle)
	
	q Ret
}

/// Creator:ban
/// CreatDate:2020-7-18
/// Description: 根据主表rowid获取所有已灭菌的消毒包(按单据发放-待发放弹窗/消毒包发放/消毒包调拨)
/// Table:CSSD_Trans
/// Input:DispMainRowid:发放主表id，Type：发放类型、手术、普通
/// Output:
/// Return:日志信息
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.PackageDisp.DispDetail","SelectAllSter",^tmpmy("vghjd"))
Query SelectAllSter(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Label,PackageName,PackageTypeDetail,PackageTypeDetailName,ExpDate,CSSDTDate,PackageDR,PackMaterial,LocDesc,LevelFlag") [ SqlProc ]
{
}

ClassMethod SelectAllSterExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	s PAttributeId=PJObj.%Get("PackageType")
	s gHospId=PJObj.%Get("gHospId")
	s gUserId=PJObj.%Get("gUserId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gLocId=PJObj.%Get("gLocId")
	s PMachineId=PJObj.%Get("PMachineNo")
	s PDocType=PJObj.%Get("DocType")
	s PPkgId=PJObj.%Get("packageDesc")
	s DispMainId=PJObj.%Get("DispMainId")
	s Type=PJObj.%Get("Type")
	s PPackageMatch=PJObj.%Get("PackageMatch")
	s ExactMatchFlag=PJObj.%Get("ExactMatchFlag")
	s PExcludeExt=PJObj.%Get("ExcludeExt")
	s PLevelFlag=PJObj.%Get("LevelFlag")
	s PStartDate=..DH2L(PStartDate)
	s PEndDate=..DH2L(PEndDate)
	
	s (ToLocId,FrLocId,PkgIds,DispCBItmIds)=""
	i DispMainId'="" d
	.s DispMainObj=##class(User.CSSDPackageDispMain).%OpenId(DispMainId)
	.d DispMainObj.%Reload()
	.q:'$IsObject(DispMainObj)
	.s ToLocId=DispMainObj.CSSDPDMToLocDrGetObjectId()
	.s FrLocId=DispMainObj.CSSDPDMFromLocDrGetObjectId()
	.s DispId=0
	.f  s DispId=$o(^User.CSSDPackageDispI("CSSDPDCParrefDr",DispMainId,DispId)) q:(DispId="")  d
	..s DispObj=##class(User.CSSDPackageDisp).%OpenId(DispId)
	..d DispObj.%Reload()
	..s PkgId=DispObj.CSSDPDPackageGetObjectId()
	..s DispCBItmId=DispObj.CSSDPDPackageCallBackDetailGetObjectId()
	..i PkgIds="" s PkgIds=PkgId
	..e  s PkgIds=PkgIds_","_PkgId
	..i DispCBItmIds="" s DispCBItmIds = DispCBItmId
	..e  s DispCBItmIds = DispCBItmIds_","_DispCBItmId
	
	s SqlStr="select CSSDT_Rowid,CSSDT_Date,CSSDT_Label, CSSDT_Status, CSSDT_ExpDate,CSSDT_Sterilize_DR,"
			_" CSSDT_Package_DR,CSSDT_Pack_DR->CSSDPP_LevelFlag as LevelFlag FROM CSSD_Trans "
			_" where CSSDT_Package_DR->CSSDP_PackTypeDetail in (1,2,7,10)"
	i PStartDate'="" d
	.s SqlStr=SqlStr_" and CSSDT_Date between "_PStartDate_" AND "_PEndDate
	e  i Type="ord" d	//按单据发放弹窗只显示该单据对应的标签
	.i PkgIds'="" s SqlStr=SqlStr_" and CSSDT_Package_DR in ("_PkgIds_")"
	
	;是否根据接收科室过滤
	s FilterByLoc="N"
	i PDocType'=1 d
	.s Param=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	.s FilterByLoc=##class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDDISP","FilterByLoc",Param)
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("CSSDT_Rowid")
		s Label = Result.Data("CSSDT_Label")
		s PackageId = Result.Data("CSSDT_Package_DR")
		s ExpDate = Result.Data("CSSDT_ExpDate")
		s CSSDTDate = Result.Data("CSSDT_Date")
		s LevelFlag = Result.Data("LevelFlag")
		s Status = Result.Data("CSSDT_Status")
		s CBItmId=$o(^User.CSSDCallbackDetailNewI("CSSDCDPackageLabelIndex",Label,0))
		s CurLocId=..GetCurLocByLabel(Label)
		s SterIngFlag=##class(web.CSSDHUI.PackageSterilize.Sterilize).CheckLabelSterIng(Label)
		s NowDate=$p($h,",",1)
		s IsExt=##class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PackageId)
		continue:(PExcludeExt="Y")&&(IsExt="Y")
		continue:CBItmId'=""						// 过滤已回收的
		continue:(FrLocId'="")&&(FrLocId'=CurLocId)	// 过滤不在发放/调拨科室的
		continue:SterIngFlag="Y"
		continue:((PDocType=1)&&(Status'="R"))
		continue:ExpDate<NowDate
		continue:((PDocType'=1)&&(Status'="P")&&(Status'="S"))
		continue:PackageId=""
		continue:(PPackageMatch="Y")&&((","_PkgIds_",")'[(","_PackageId_","))
		continue:(PLevelFlag=1)&&(LevelFlag'=1)
		continue:(PLevelFlag=0)&&(LevelFlag=1)
		s ExpDate=..DL2H(ExpDate)
		s CSSDTDate=..DL2H(CSSDTDate)
		s PkgObj = ##class(User.CSSDPackage).%OpenId(PackageId)
		s PkgDesc=PkgObj.CSSDPDesc
		s AttributeId=PkgObj.CSSDPPackTypeDetail
		s PkgSterType=PkgObj.CSSDPSterType
		s HospitalDr=PkgObj.CSSDPHospitalGetObjectId()
		s PkgIsSter=PkgSterType.CSSDSTIsSter
		s PkgDesc=..%FieldTranslate("User.CSSDPackage","CSSDPDesc",PkgDesc)
		s AttributeDesc=##class(web.CSSDHUI.Common.PackageInfoCommon).GetPackageDetailDesc(AttributeId)
		i AttributeId="1" d
		.s PkgDesc=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetCodeDictName(Label)
		s ShowDataFlag =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_Package",PackageId,gHospId)
		continue:ShowDataFlag="N"
		continue:(PAttributeId'="")&&(PAttributeId'=AttributeId)
		continue:(Status="P")&&(PkgIsSter="Y")
		continue:(PPkgId'="")&&(PPkgId'=PackageId)
		s PackId=$o(^User.CSSDPackagePackI("CSSDPPLabelIndex",Label,""))
		continue:PackId=""
		s PackObj=##class(User.CSSDPackagePack).%OpenId(PackId)
		continue:'$IsObject(PackObj)
		s MaterialObj=PackObj.CSSDPPMaterialDr
		s PackCBItmId=PackObj.CSSDPPCallDetailDrGetObjectId()
		s LocId=PackObj.CSSDPPPackLocDrGetObjectId()
		continue:(ExactMatchFlag="Y")&&(((","_DispCBItmIds_",")'[(","_PackCBItmId_","))||(PackCBItmId=""))
		continue:'$IsObject(MaterialObj)
		s PackMaterialDesc=MaterialObj.CSSDMDesc
		s PackMaterialDesc=..%FieldTranslate("User.CSSDMaterial","CSSDMDesc",PackMaterialDesc)
		s LocDesc=..sssLocDesc(LocId)
		continue:(FilterByLoc="Y")&&(LocId'="")&&(ToLocId'="")&&(LocId'=ToLocId)
		s (IsState,MachineId)=""
		s SterItmId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSLabel",Label,""),-1)
		i SterItmId'="" d
		.s SterItemObj=##class(User.CSSDPackageSterilize).%OpenId(SterItmId)
		.s IsState=SterItemObj.CSSDPSStates
		.s SterMainObj=SterItemObj.CSSDPSParref
		.s:$IsObject(SterMainObj) MachineId=SterMainObj.CSSDSRMachineNoDRGetObjectId()
		continue:IsState="N"
		continue:(PMachineId'="")&&(PMachineId'=MachineId)
		d OutPutAllSterRow
	}
	d Result.Close()
	Quit $$$OK
OutPutAllSterRow
	s Data=$lb(RowId,Label,PkgDesc,AttributeId,AttributeDesc,
		ExpDate,CSSDTDate,PackageId,PackMaterialDesc,LocDesc,LevelFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// w ##class(web.CSSDHUI.PackageDisp.DispDetail).GetCurLocByLabel("20722022061600004")
ClassMethod GetCurLocByLabel(Label)
{
	n (Label)
	
	s TransId=$o(^User.CSSDTransI("CSSDTLabel",Label,0))
	q:TransId="" ""
	
	s CurLocId=""
	s TransObj=##class(User.CSSDTrans).%OpenId(TransId)
	s BackId=TransObj.CSSDTCallBackGetObjectId()
	i BackId'="" d
	.s CurLocId=$lg(^User.CSSDPackageCallbackD(BackId),10)
	q:CurLocId'="" CurLocId
	
	s TrfId=TransObj.CSSDTTrfDRGetObjectId()
	i TrfId'="" d
	.s CurLocId=$lg(^User.CSSDPackageDispD(TrfId),10)
	q:CurLocId'="" CurLocId
	
	s DispObj=TransObj.CSSDTDisp
	i $IsObject(DispObj) d
	.s DispMainId=DispObj.CSSDPDParrefDr.%Id()
	.i DispMainId'="" d
	..s CurLocId=$lg(^User.CSSDPackageDispMainD(DispMainId),7)
	q:CurLocId'="" CurLocId
	
	s SterObj=TransObj.CSSDTSterilizeGetObjectId()
	i $IsObject(SterObj) d
	.s SterRId=SterObj.CSSDPSParrefGetObjectId()
	.i SterId'="" d
	..s CurLocId=$lg(^User.CSSDSterilizeRecordD(SterId),17)
	q:CurLocId'="" CurLocId
	
	s PackId=TransObj.CSSDTPackGetObjectId()
	i PackId'="" d
	.s CurLocId=$lg(^User.CSSDPackagePackD(PackId),4)
	q:CurLocId'="" CurLocId
	
	q CurLocId
}

/// Creator:ban
/// CreatDate:2020-10-27
/// Description:扫码发放-判断发放单扫描发放的消毒包是否存在对应的回收单
/// Table:CSSD_CSSDPackageCallback
/// d ##class(web.CSSDHUI.PackageDisp.DispDetail).IsHasCallBack("144","2021-10-27",310)
ClassMethod IsHasCallBack(DispLocDr As %String, DispDate As %String, PkgId As %String) As %Library.String
{
	n (DispLocDr,DispDate,PkgId)
	s DispDate=..DH2L(DispDate)
	s ret=0
	q:((DispLocDr="")||(DispDate="")||(PkgId="")) ret
	s (RowId,CallBackId)=""
	f  s CallBackId=$o(^User.CSSDPackageCallbackI("CSSDPCAckDateFromLocDrIndex",DispDate,DispLocDr,CallBackId)) q:CallBackId=""  d
	.s CallBackDetailId=""
	.i CallBackId'="" d
	..f  s CallBackDetailId=$o(^User.CSSDCallbackDetailNewI("CSSDCDParrefItmIndex",CallBackId,PkgId,CallBackDetailId)) q:((CallBackDetailId="")||(ret=1))  d
	...s CallBackDetailObj=##Class(User.CSSDCallbackDetailNew).%OpenId(CallBackDetailId)
	...q:'$IsObject(CallBackDetailObj)
	...s BackQty=CallBackDetailObj.CSSDCDQty
	...s DispQty=CallBackDetailObj.CSSDCDDispQty
	...i DispQty>=BackQty s ret=1
	...e  s RowId=CallBackDetailId
	q RowId
}

/// Creator: lihui
/// CreatDate: 20221018
/// Description: 根据标签获取包对应绑定的科室
/// Table: CSSD_PackagePack CSSD_Package
/// input：标签
/// return：科室ID^科室名称
/// w ##class(web.CSSDHUI.PackageDisp.DispDetail).GetPkgLocByLabel("120058002000001")
ClassMethod GetPkgLocByLabel(Label)
{
	n (Label)
	
	s PackInfo=##class(web.CSSDHUI.Common.PackageInfoCommon).GetLabel(Label)
	s PkgId=$p(PackInfo,"^",3)
	q:PkgId="" ""
	s PackageObj=##Class(User.CSSDPackage).%OpenId(PkgId)
	q:'$IsObject(PackageObj) ""
	s LocId=PackageObj.CSSDPLOCDRGetObjectId()
	
	q LocId
}

}
