Import sqluser

/// wfg
Class web.CSSDHUI.PackageSterilize.SterilizeItem Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:
/// CreatDate:2019-6-18
/// Description: 判断灭菌单中是否有需要生物监测的消毒包
/// Table:CSSD_PackageSterilize
/// Input:mainId:主表id
/// Output:
/// Return:日志信息
/// d ##class(web.CSSDHUI.PackageSterilize.SterilizeItem).IsBioBat("147")
ClassMethod IsBioBat(mainId) As %Library.String
{
	n (%session,mainId)
	s Ret=0
	s SterItmId=0
	f  s SterItmId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSParref",mainId,SterItmId)) q:(SterItmId="")||(Ret=1)  d
	.s SterItmObj=##Class(User.CSSDPackageSterilize).%OpenId(SterItmId)
	.q:'$IsObject(SterItmObj)
	.s PkgBioFlag=SterItmObj.CSSDPSPackage.CSSDPNotBioFlag
	.i PkgBioFlag="Y" s Ret=1
	.q:Ret=1
	.s Label=SterItmObj.CSSDPSLabel
	.s PkgId=SterItmObj.CSSDPSPackageGetObjectId()
	.s IsExt=##class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PkgId)
	.q:IsExt'="Y"
	.s FixedLabel=##class(web.CSSDHUI.Common.PackageInfoCommon).GetFixedLabel(Label)
	.s Len=$l(FixedLabel)
	.s WLCodeLabel=$E(Label,1,Len+6)
	.s ExtBindId=$o(^User.CSSDExtDevBindI("IndexCSSDExtLabel",WLCodeLabel,""))
	.q:ExtBindId=""
	.s ExtObj = ##class(User.CSSDExtDevBind).%OpenId(ExtBindId)
	.q:'$IsObject(ExtObj)
	.d ExtObj.%Reload()
	.s Implants=ExtObj.CSSDExtImplants				//外来器械是否有植入物
	.i Implants="Y" s Ret=1
	
	q Ret
}

/// CreatDate:	2019-6-18
/// Description:保存消毒包分类信息
/// Table:		CSSD_PackageSterilize
/// Input:		MainId:主表id, Detail(支持多个标签传入)
/// Output:		RtnObj.Json()
/// Return:		
/// w ##class(web.CSSDHUI.PackageSterilize.SterilizeItem).jsSaveSterDetail("33","0001202109120000")
ClassMethod jsSaveSterDetail(Params, Detail) As %Library.String
{
	n (%session,Params,Detail)
	s $ZT=..sssError()
	s MethodName=$CLASSNAME()_".jsSaveSterDetail"
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i ((Params="")||(Detail="")) q RtnObj.Err(-1,"",MethodName_"入参为空!").Json()
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_"入参解析失败!").Json()
	
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s Label=Obj.%Get("Label")
		s RtnObj=..SaveSterDetail(Params,Label)
		continue:RtnObj.success<0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	
	tc
	q RtnObj.Json()
}

/// Creator:
/// CreatDate:2019-6-18
/// Description: 保存灭菌明细信息
/// Table:CSSD_PackageSterilize
/// Input:mainId:主表id,barCode:标签码
/// Output:
/// Return:日志信息
/// d ##class(web.CSSDHUI.PackageSterilize.SterilizeItem).SaveSterDetail("296","10062023021600001")
ClassMethod SaveSterDetail(Params, Label) As web.CSSDHUI.RtnObj
{
	n (%session,Params,Label)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_"入参解析失败!").Json()
	s gHospId=PJObj.%Get("gHospId")
	s gUserId=PJObj.%Get("gUserId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gLocId=PJObj.%Get("gLocId")
	s SterMainId=PJObj.%Get("SterMainId")
	i ((SterMainId="")||(Label="")) q RtnObj.Err(-1,"","入参不能为空!")
	
	s SterMainObj=##Class(User.CSSDSterilizeRecord).%OpenId(SterMainId)
	i '$IsObject(SterMainObj) q RtnObj.Err(-1,"","灭菌批号不存在，请刷新核查!")
	s IsLowTempFlag=""
	d SterMainObj.%Reload()
	s TempType=SterMainObj.CSSDSRMachineNoDR.CSSDMCTempType
	s LoadNum=SterMainObj.CSSDSRMachineNoDR.CSSDMCLoadNum
	s IsChk=SterMainObj.CSSDSRIsCHK
	s ComFlag=SterMainObj.CSSDSRComplateFlag
	s:TempType'="" IsLowTempFlag=$lg(^User.CSSDSterTypeD(TempType),7)
	i IsChk=1 q RtnObj.Err(-3,"","已经验收不能再添加消毒包灭菌!","",0)
	i (ComFlag="Y")||(ComFlag="F") q RtnObj.Err(-2,"","已经确认灭菌不能再添加消毒包灭菌!","",0)
	
	s TransId= $o(^User.CSSDTransI("CSSDTLabel",Label,""))
	i TransId="" q RtnObj.Err(-4,"","无效的标签")
	
	s TransObj=##Class(User.CSSDTrans).%OpenId(TransId)
	i '$IsObject(TransObj) q RtnObj.Err(-4,"","无效标签","",0)
	
	d TransObj.%Reload()
	i $IsObject(TransObj) d
	.s SterItmId= TransObj.CSSDTSterilize
	.s ExpDate=TransObj.CSSDTExpDate
	s NowDate=$p($h,",",1)
	i NowDate>=ExpDate q RtnObj.Err(-6,"","该标签已经过期!")
	
	s PkgId=TransObj.CSSDTPackageGetObjectId()
	i PkgId="" q RtnObj.Err(-4,"","无效标签","",0)
	s PkgObj=##Class(User.CSSDPackage).%OpenId(PkgId)
	d PkgObj.%Reload()
	s (PkgDesc,PkgSterWay,PkgIsLowerTemp)=""
	i $IsObject(PkgObj) d
	.s PkgDesc = PkgObj.CSSDPDesc
	.s SterTypeObj=PkgObj.CSSDPSterType
	.q:'$IsObject(SterTypeObj)
	.s PkgSterWay=SterTypeObj.%Id()
	.s PkgIsLowerTemp=SterTypeObj.CSSDSTIsLowerTemp
	i PkgSterWay="" q RtnObj.Err(-5,"",PkgDesc_" - 未维护灭菌方式，请先维护！","",0)
	
	s ParamsStr=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	s IsLowSterModeMix=##Class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDSTERILIZE","IsLowSterModeMix",ParamsStr)
	i ((IsLowSterModeMix="Y")&&(IsLowTempFlag'="")&&(IsLowTempFlag'=PkgIsLowerTemp)) q RtnObj.Err(-5,"","消毒包与灭菌器的灭菌方式不一致，请核对扫码","",0)
	i ((IsLowSterModeMix="N")&&(PkgSterWay'="")&&(PkgSterWay'=TempType)) q RtnObj.Err(-5,"","消毒包与灭菌器的灭菌方式不一致，请核对扫码","",0)
	
	s IsExistId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSParrefLabel",SterMainId,Label,""))
	i IsExistId'="" q RtnObj.Err(-5,"","该标签已灭菌,不能重复添加!","",0)
	s RtnObj=..IsCleanOrSter(Label)
	q:RtnObj.success'=0 RtnObj
	
	s DispFlag=##class(web.CSSDHUI.PackageDisp.Disp).CheckLabelDispExist(Label)
	i DispFlag="Y" q RtnObj.Err(-5,"","该标签已发放，不能添加!","",0)
	
	s SterCarDetailId=$o(^User.CSSDSterilizeCarDetailI("IndexPkgLabel",Label,""))
	i SterCarDetailId'="" q RtnObj.Err(-6,"","该标签已绑定灭菌架，不能添加！")
	
	s Count=0
	s SterItmId=""
	f  s SterItmId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSParref",SterMainId,SterItmId)) q:SterItmId=""  d
	.s Count=Count+1
	i (LoadNum'="")&&(Count>=LoadNum) q RtnObj.Err(-2,"","装载数量已达上限")
	
	ts
	&sql(insert into CSSD_PackageSterilize
		(CSSDPS_Label, CSSDPS_Package_DR, CSSDPS_Parref_DR, CSSDPS_Qty, CSSDPS_SerialNo )
		values(:Label,:PkgId,:SterMainId,1,1)
	)
	i SQLCODE'=0 d
	.d RtnObj.Err(-6,"","保存灭菌明细数据失败:"_$ClassName()_".SaveSterDetail:SQLCODE"_SQLCODE_":"_$g(%msg))
	i RtnObj.success'=0 tro  q RtnObj
	s SterId=%ROWID
	
	&sql(update cssd_packagepack set CSSDPP_IsLoadSteCar=1 where CSSDPP_Label=:Label)
	i SQLCODE'=0 d
	.d RtnObj.Err(-7,"","修改已装载灭菌失败:"_$ClassName()_".SaveSterDetail:SQLCODE"_SQLCODE_":"_$g(%msg))
	i RtnObj.success'=0 tro  q RtnObj
	
	tc
	s RtnObj.rowid=SterId
	q RtnObj
}

/// Creator:ban
/// CreatDate:2022-3-07
/// Description: 判断扫码的标签是否已灭菌或者是否已重新清洗，避免重复灭菌
/// Table:CSSD_PackageSterilize
/// Input:sterLabel:标签码
/// Output:
/// Return:日志信息
/// d ##class(web.CSSDHUI.PackageSterilize.SterilizeItem).IsCleanOrSter("104022001000004")
ClassMethod IsCleanOrSter(Label) As web.CSSDHUI.RtnObj
{
	n (%session,Label)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i Label="" q RtnObj.Err(-1,"","入参不能为空!")
	q:RtnObj.success'=0 RtnObj
	
	s (SterNo,SterPredoItmStates,SecondCleanNo)="",IsState="N"
	s SterItmId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSLabel",Label,""),-1)
	i SterItmId'="" d
	.s SterItmObj=##class(User.CSSDPackageSterilize).%OpenId(SterItmId)
	.q:'$IsObject(SterItmObj)
	.s IsState=SterItmObj.CSSDPSStates
	.s SterNo=SterItmObj.CSSDPSParref.CSSDSRNo
	.;如果合格和空不让重复添加
	i IsState'="N" d RtnObj.Err(-2,"","已在灭菌批号："_SterNo_"重新灭菌，不能进行清洗或灭菌操作，请重新查询核对！")
	q:RtnObj.success'=0 RtnObj
	
	s SterPredoItmId=$o(^User.CSSDSterPredoDetailI("IndexLable",Label,""),-1)
	i SterPredoItmId'="" d
	.s SterPredoItmObj=##class(User.CSSDSterPredoDetail).%OpenId(SterPredoItmId)
	.q:'$IsObject(SterPredoItmObj)
	.s SterPredoItmStates=SterPredoItmObj.CSSDSPStates
	.s SecondCleanItmObj=SterPredoItmObj.CSSDSPCleanDetailDr	//不合格再次清洗对应的明细ID
	.q:'$IsObject(SecondCleanItmObj)
	.s SecondCleanMainObj=SecondCleanItmObj.CSSDCDPCleanMain	//不合格再次清洗对应的主单据
	.q:'$IsObject(SecondCleanMainObj)
	.s SecondCleanNo=SecondCleanMainObj.CSSDCNo
	i SterPredoItmStates="Y" d RtnObj.Err(-2,"","该条码灭菌不合格，已在清洗批号："_SecondCleanNo_"重新清洗，请核对！","",0)
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Creator:
/// CreatDate:2019-6-18
/// Description: 删除灭菌单数据
/// Table:CSSD_PackageSterilize
/// Input:rowId:主表id
/// Output:
/// Return:日志信息
/// d ##class(web.CSSDHUI.PackageSterilize.SterilizeItem).jsDelete(3)
ClassMethod jsDelete(Params As %String) As %Library.String
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

/// Creator:
/// CreatDate:2019-6-18
/// Description: 根据主表删除所有明细
/// Table:CSSD_PackageSterilize
/// Input:rowId:主表id
/// Output:
/// Return:日志信息
/// d ##class(web.CSSDHUI.PackageSterilize.SterilizeItem).Delete(3)
ClassMethod Delete(SterItemId As %String) As web.CSSDHUI.RtnObj
{
	n (%session,SterItemId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i SterItemId="" q RtnObj.Err(-1,"","入参不能为空!")
	
	s SterItemObj=##class(User.CSSDPackageSterilize).%OpenId(SterItemId)
	d SterItemObj.%Reload()
	i '$IsObject(SterItemObj) q RtnObj.Err(-1,"","单据不存在,请核实!","",0)
	
	s Label=SterItemObj.CSSDPSLabel
	s CompFlag=SterItemObj.CSSDPSParref.CSSDSRComplateFlag
	s IsCheck=SterItemObj.CSSDPSParref.CSSDSRIsCHK
	i (CompFlag="Y")||(CompFlag="F") q RtnObj.Err(-5,"","已经灭菌作业,不能删除!","",0)
	i IsCheck'="" q RtnObj.Err(-1,"","已经验收处理,不能删除!","",0)
	
	ts
	&sql(update cssd_packagepack set CSSDPP_IsLoadSteCar=0 where CSSDPP_label=:Label)
	i SQLCODE'=0 d
	.d RtnObj.Err(-2,SterItemId,"修改打包表数据失败!:"_$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
	i RtnObj.success<0 tro  q RtnObj
	
	&sql(delete from cssd_packagesterilize where %id=:SterItemId)
	i SQLCODE'=0 d
	.d RtnObj.Err(-3,SterItemId,"此明细删除失败!:"_$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
	i RtnObj.success<0 tro  q RtnObj
	
	tc
	q RtnObj
}

/// Creator:
/// CreatDate:2019-6-18
/// Description: 根据主表rowid获取灭菌子表的数据列表
/// Table:CSSD_PackageSterilize
/// Input:SterId:主表id
/// Output:
/// Return:日志信息
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.PackageSterilize.SterilizeItem","SelectByF","458","","{""ColFlag"":""Y""}")
Query SelectByF(SterMainId As %String, PLabel As %String = "") As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Label,PkgDesc,Qty,RecallFlag,SerialNo,ReasonId,ReasonDesc,LevelFlag") [ SqlProc ]
{
}

ClassMethod SelectByFExecute(ByRef qHandle As %Binary, SterMainId As %String, PLabel As %String = "") As %Status
{
	n (%session,qHandle,SterMainId,PLabel)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:SterMainId="" $$$OK
	
	s Result=##class(%Library.ResultSet).%New()
	s SterItmId=""
	f  s SterItmId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSParref",SterMainId,SterItmId)) q:SterItmId=""  d
	.s (PackageName,objSterilize,ReasonDr)=""
	.s SterItmObj=##class(User.CSSDPackageSterilize).%OpenId(SterItmId)
	.d SterItmObj.%Reload()
	.q:('$IsObject(SterItmObj))
	.s RowId=SterItmObj.%Id()
	.s Label = SterItmObj.CSSDPSLabel
	.s PkgId = SterItmObj.CSSDPSPackageGetObjectId()
	.s Qty = SterItmObj.CSSDPSQty
	.s RecallFlag = SterItmObj.CSSDPSRecallFlag
	.s SerialNo = SterItmObj.CSSDPSSerialNo
	.s ReasonObj=SterItmObj.CSSDPSReason
	.q:(PLabel'="")&&(Label'[PLabel)
	.s (LevelFlag,PackObj,ReasonId,ReasonDesc)=""
	.s PackId=$o(^User.CSSDPackagePackI("CSSDPPLabelIndex",Label,""))
	.s:PackId'="" PackObj=##class(User.CSSDPackagePack).%OpenId(PackId)
	.q:'$IsObject(PackObj)
	.d PackObj.%Reload()
	.s LevelFlag=PackObj.CSSDPPLevelFlag
	.q:PkgId=""
	.s PkgObj = ##class(User.CSSDPackage).%OpenId(PkgId)
	.d PkgObj.%Reload()
	.s PkgDesc=PkgObj.CSSDPDesc
	.s AttributeId=PkgObj.CSSDPPackTypeDetail
	.i AttributeId="1" d
	..s PkgDesc=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetCodeDictName(Label)
	.i $IsObject(ReasonObj) d
	..s ReasonId = ReasonObj.%Id()
	..s ReasonDesc=ReasonObj.CSSDSteFailDesc
	.d OutPutRow
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,Label,PkgDesc,Qty,RecallFlag,SerialNo,ReasonId,ReasonDesc,LevelFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:
/// CreatDate:2023-4-25
/// Description: 根据主表rowid获取灭菌子表的汇总数据列表
/// Table:CSSD_PackageSterilize
/// Input:SterId:主表id
/// Output:
/// Return:日志信息
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.PackageSterilize.SterilizeItem","SelectSumItms","466","")
Query SelectSumItms(SterMainId As %String, PLabel As %String = "") As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,PkgDesc,Qty:%Integer") [ SqlProc ]
{
}

ClassMethod SelectSumItmsExecute(ByRef qHandle As %Binary, SterMainId As %String, PLabel As %String = "") As %Status
{
	n (%session,qHandle,SterMainId,PLabel)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s Pid=..NewPid()
	k ^TMPCSSD("CSSDSUMSTERITMS",Pid)
	q:SterMainId="" $$$OK
	
	s Result=##class(%Library.ResultSet).%New()
	s SterItmId=""
	f  s SterItmId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSParref",SterMainId,SterItmId)) q:SterItmId=""  d
	.s (PackageName,objSterilize)=""
	.s SterItmObj=##class(User.CSSDPackageSterilize).%OpenId(SterItmId)
	.d SterItmObj.%Reload()
	.q:('$IsObject(SterItmObj))
	.s RowId=SterItmObj.%Id()
	.s Label = SterItmObj.CSSDPSLabel
	.s Qty = SterItmObj.CSSDPSQty
	.s PkgObj = SterItmObj.CSSDPSPackage
	.q:(PLabel'="")&&(Label'[PLabel)
	.s PkgId=PkgObj.%Id()
	.q:PkgId=""
	.s PkgDesc=PkgObj.CSSDPDesc
	.s AttributeId=PkgObj.CSSDPPackTypeDetail
	.i AttributeId="1" d
	..s PkgDesc=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetCodeDictName(Label)
	.i $d(^TMPCSSD("CSSDSUMSTERITMS",Pid,PkgId)) d
	..s $p(^TMPCSSD("CSSDSUMSTERITMS",Pid,PkgId),"^",2)=$p(^TMPCSSD("CSSDSUMSTERITMS",Pid,PkgId),"^",2)+1
	.e  d
	..s ^TMPCSSD("CSSDSUMSTERITMS",Pid,PkgId)=PkgDesc_"^"_1
	s TmpId=""
	f  s TmpId=$o(^TMPCSSD("CSSDSUMSTERITMS",Pid,TmpId)) q:TmpId=""  d
	.s PkgInfo=^TMPCSSD("CSSDSUMSTERITMS",Pid,TmpId)
	.s RowId=TmpId
	.s PkgDesc=$p(PkgInfo,"^",1)
	.s Qty=$p(PkgInfo,"^",2)
	.d OutPutRowItms
	Quit $$$OK
OutPutRowItms
	s Data=$lb(RowId,PkgDesc,Qty)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
