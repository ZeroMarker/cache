Import sqluser

/// wfg
Class web.CSSDHUI.PackageSterilize.SterilizeCar Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:wfg
/// CreatDate:2020.1.7
/// Description:灭菌架中,扫描增加消毒包
/// Table:cssd_sterilizecardetail
/// Input:carlbl:灭菌架 pkglbl:消毒包标签
/// Output:
/// Return:日志信息
/// w ##class(web.CSSDHUI.PackageSterilize.SterilizeCar).jsSaveSterCar("600006001","L00052022030400003")
ClassMethod jsSaveSterCar(CarLabel As %String, Label As %String) As %Library.String
{
	n (CarLabel,Label,%session)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..AddCar(CarLabel,Label)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:wfg
/// CreatDate:2020.1.7
/// Description:批量处理消毒包 1添加到灭菌架   2 直接生成灭菌单据(明细)
/// Table:cssd_sterilizecardetail
/// Input:Detail:明细数据 carLabel:灭菌架label
/// Output:
/// Return:日志信息
/// w ##class(web.CSSDHUI.PackageSterilize.SterilizeCar).jsAddCarByLabel("[{""RowId"":""368"",""Label"":""00042023042000003"",""BioFlag"":""N""}]","7")
ClassMethod jsAddCarByLabel(Detail As %String, CarLabel As %String = "") As %Library.String
{
	n (Detail,CarLabel,%session)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 q RtnObj.Err(-1,"","没有要添加的消毒包数据！")
	ts
	while('Sc){
		s Obj=PJObj.%Pop()
		q:Obj=""

		s PackId=Obj.%Get("RowId")
		s PackObj=##class(User.CSSDPackagePack).%OpenId(PackId)
		d PackObj.%Reload()
		s Label=PackObj.CSSDPPLabel
		s RtnObj=..AddCar(CarLabel,Label)
		continue:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:wfg
/// CreatDate:2020.1.7
/// Description:往灭菌架内添加消毒包
/// Table:cssd_sterilizecardetail
/// Input:pkglbl:消毒包标签 carLabel:灭菌架label
/// Output:
/// Return:日志信息
/// d ##class(web.CSSDHUI.PackageSterilize.SterilizeCar).AddCar("606232001","20782023041100001")
ClassMethod AddCar(CarLabel As %String, Label As %String) As web.CSSDHUI.RtnObj
{
	n (CarLabel,Label,%session)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i ((CarLabel="")||(Label="")) q RtnObj.Err(-1,"","标签不能为空!")

	s PackId=$o(^User.CSSDPackagePackI("CSSDPPLabelIndex",Label,""))
	s PackObj=##class(User.CSSDPackagePack).%OpenId(PackId)
	s PkgId=PackObj.CSSDPPPackageGetObjectId()

	i PkgId="" q RtnObj.Err(-3,"","标签绑定的消毒包不存在！")
	s CarSterType=..GetSterCarType(CarLabel)
	i CarSterType="" q RtnObj.Err(-2,"","灭菌架未维护灭菌方式！")
	s PkgSterType=PackObj.CSSDPPPackage.CSSDPSterTypeGetObjectId()
	i ((PkgSterType'="")&&(CarSterType'=PkgSterType)) q RtnObj.Err(-2,"","灭菌方式不符！")
	
	s SterMainId=$o(^User.CSSDSterilizeRecordI("IndexCSSDSRCarLBL",CarLabel,""),-1)
	i SterMainId'="" d
	.s CheckFlag=$lg(^User.CSSDSterilizeRecordD(SterMainId),27)
	.q:CheckFlag'=""	;验收后可继续添加
	.d RtnObj.Err(-4,"","灭菌架使用中，无法添加消毒包！")	;完成且未验收的灭菌架不可添加新的消毒包
	q:RtnObj.success'=0 RtnObj

	s SterCarDetailId=$o(^User.CSSDSterilizeCarDetailI("IndexPkgLabel",Label,""))
	i SterCarDetailId'="" q RtnObj.Err(-3,"","已经添加过该消毒包,请核实！")

	s SterItmId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSLabel",Label,""))
	i SterItmId'="" d
	.s SterMainId=$lg(^User.CSSDPackageSterilizeD(SterItmId),13)
	.s SterItmCheckFlag=$lg(^User.CSSDPackageSterilizeD(SterItmId),22)
	.s CheckFlag=$lg(^User.CSSDSterilizeRecordD(SterMainId),27)
	.q:((CheckFlag="2")||(SterItmCheckFlag="N"))	;之前灭菌验收不合格的,仍可继续装车
	.i SterMainId'="" d RtnObj.Err(-4,"","该消毒包已灭菌,无法添加！")
	q:RtnObj.success'=0 RtnObj

	s DispFlag=##class(web.CSSDHUI.PackageDisp.Disp).CheckLabelDispExist(Label)
	q:DispFlag="Y" RtnObj.Err(-5,"","已发放,无法添加！")

	s SterCarDetailObj=##class(User.CSSDSterilizeCarDetail).%New()
	s SterCarDetailObj.CSSDSCDCarLabel=CarLabel
	s SterCarDetailObj.CSSDSCDPkgLabel=Label
	d SterCarDetailObj.CSSDSCDPkgDrSetObjectId(PkgId)
	s SterCarDetailObj.CSSDSCDPkgNum=1
	s Sc=SterCarDetailObj.%Save()
	i $$$ISERR(Sc) q RtnObj.Err(-3,"","装车失败!")

	d PackObj.%Reload()
	s PackObj.CSSDPPIsLoadSteCar=1
	s Sc=PackObj.%Save()
	i $$$ISERR(Sc) q RtnObj.Err(-3,"","修改打包表状态失败!")

	q RtnObj
}

/// Creator:ban
/// CreatDate:2020.3.31
/// Description:获取灭菌架的灭菌方式
/// Table:
/// Input:carLabel:灭菌架label
/// Output:
/// Return:日志信息
/// d ##class(web.CSSDHUI.PackageSterilize.SterilizeCar).GetSterCarType(1)
ClassMethod GetSterCarType(CarLabel As %String) As %Library.String
{
	n (CarLabel,%session)
	q:CarLabel="" ""

	s PgkId=$lg(^User.CSSDCodeDictD(CarLabel),5)
	s PkgDesc=$lg(^User.CSSDCodeDictD(CarLabel),6)
	s SterType=""
	s:PgkId'="" SterType=$lg(^User.CSSDPackageD(PgkId),21)
	q SterType
}

/// Creator:ban
/// CreatDate:2020.3.31
/// Description:获取灭菌器的灭菌方式
/// Table:
/// Input:carLabel:灭菌架label
/// Output:
/// Return:日志信息
/// d ##class(web.CSSDHUI.PackageSterilize.SterilizeCar).GetMachineNoType("1")
ClassMethod GetMachineNoType(MachineNoDR As %String) As %Library.String
{
	n (MachineNoDR,%session)
	s MachineNoType=""
	s:MachineNoDR'="" MachineNoType=$lg(^User.CSSDMachineConfigD(MachineNoDR),17)
	q MachineNoType
}

/// Creator:wfg
/// CreatDate:2020.1.7
/// Description:删除灭菌架数据
/// Table:cssd_sterilizecardetail
/// Input:		Json型字符串
/// Output:
/// Return:日志信息
/// w ##class(web.CSSDHUI.PackageSterilize.SterilizeCar).jsDelete(^tmpbin(171))
ClassMethod jsDelete(Params As %String) As %Library.String
{
	n (Params,%session)
	s $ZT=..sssError()
	s MethodName=$CLASSNAME()_".jsDelete"
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_":参数解析错误").Json()

	ts
	While(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""

		s RowId=Obj.%Get("RowId")
		continue:RowId=""

		s RtnObj=..Delete(RowId)
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

ClassMethod Delete(SterItmId As %String) As web.CSSDHUI.RtnObj
{
	n (SterItmId,%session)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()

	s SterCarDetailObj=##Class(User.CSSDSterilizeCarDetail).%OpenId(SterItmId)
	i SterCarDetailObj="" q RtnObj.Err(-2,"","该数据已被删除，请刷新核实!")

	s PkgLabel=SterCarDetailObj.CSSDSCDPkgLabel
	&sql(update cssd_packagepack set CSSDPP_IsLoadSteCar=0 where CSSDPP_Label=:PkgLabel)
	i SQLCODE'=0 q RtnObj.Err(-1,SterItmId,"修改打包表状态失败！:"_$ClassName()_".jsDelete:SQLCODE"_SQLCODE_":"_$g(%msg))

	&sql(delete from cssd_sterilizecardetail where ID=:SterItmId)
	i SQLCODE'=0 q RtnObj.Err(-2,SterItmId,"修改打包表状态失败！:"_$ClassName()_".jsDelete:SQLCODE"_SQLCODE_":"_$g(%msg))

	q RtnObj
}

/// Creator:wfg
/// CreatDate:2020.1.7
/// Description:根据灭菌架label获取灭菌子表的数据列表
/// Table:cssd_sterilizecardetail
/// Input:CarLabel:灭菌架label
/// Output:
/// Return:日志信息
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.PackageSterilize.SterilizeCar","SelectByCarLabel","002002001")
Query SelectByCarLabel(CarLabel As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Label,PkgDesc,Qty:%Float")
{
}

ClassMethod SelectByCarLabelExecute(ByRef qHandle As %Binary, CarLabel As %String) As %Status
{
	n (qHandle,CarLabel,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	q:CarLabel="" $$$OK
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT Id as RowId, CSSDSCD_PkgLabel AS label,"
		_" CSSDSCD_PkgDr AS PkgId, CSSDSCD_PkgNum AS qty FROM cssd_sterilizecardetail "
		_" WHERE CSSDSCD_CarLabel= '"_CarLabel_"' order by RowId desc"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s Label = Result.Data("label")
		s PkgId = Result.Data("PkgId")
		s Qty = Result.Data("qty")

		continue:PkgId=""
		s PkgObj = ##class(User.CSSDPackage).%OpenId(PkgId)
		continue:PkgObj=""
		s PkgDesc=PkgObj.CSSDPDesc
		s AttributeId=PkgObj.CSSDPPackTypeDetail
		i AttributeId="1" d
		.s PkgDesc=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetCodeDictName(Label)

		d OutPutRow
	}
	d Result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,Label,PkgDesc,Qty)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:wfg
/// CreatDate:2020.1.7
/// Description:根据查询获取待加入的消毒包
/// Table:cssd_sterilizecardetail
/// Input:Params:查询入参
/// Output:
/// Return:日志信息
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.PackageSterilize.SterilizeCar","SelectAllWaitingSter",^tmpllkkll)"{""StartDate"":""2023-04-17"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""EndDate"":""2023-04-18"",""LineCode"":"""",""PMachineNo"":"""",""AttributeDesc"":"""",""CarLabel"":"""",""MachineNoDR"":""3""}")
Query SelectAllWaitingSter(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Label,PkgDesc,PackUserName,PackChkUserName,AttributeId,AttributeDesc,PackerName,BioFlag,LevelFlag,MaterialDesc,MachineDesc,HeatNo,ApplyNo,CallBackNo,SterTypeDesc,SterTypeColor") [ SqlProc ]
{
}

ClassMethod SelectAllWaitingSterExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s Pid=..NewPid()
	k ^TMPCSSD("WAITINGSTER",Pid)
	s Num=1
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	s PAttributeId=PJObj.%Get("AttributeDesc")
	s PCarLabel = PJObj.%Get("CarLabel")
	s PMachineNoDR = PJObj.%Get("MachineNoDR")
	s gHospId=PJObj.%Get("gHospId")
	s gUserId=PJObj.%Get("gUserId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gLocId=PJObj.%Get("gLocId")
	s PLineId=PJObj.%Get("LineCode")
	s pMachine=PJObj.%Get("PMachineNo")		;待灭菌弹窗灭菌器
	s ExactMatchFlag=PJObj.%Get("ExactMatchFlag")
	s PStartDate=..DH2L(PStartDate)
	s PEndDate=..DH2L(PEndDate)
	s LineLocStr=##class(web.CSSDHUI.Common.PackageInfoCommon).GetLocByLine(PLineId)
	s IsLowTempFlag=""
	i PMachineNoDR="" d
	.s SterType=..GetSterCarType(PCarLabel)
	e  d
	.s SterType =..GetMachineNoType(PMachineNoDR)
	s:SterType'="" IsLowTempFlag=$lg(^User.CSSDSterTypeD(SterType),7)
	
	s PackId=""
	f  s PackId=$o(^User.CSSDPackagePackI("CSSDPPIsLoadSteCarIndex","0",PackId)) q:PackId=""  d
	.s RowId=PackId
	.s (PackUserName,PackChkUserName,PackerName,ApplyNo,CallBackNo)=""
	.s PackObj=##class(User.CSSDPackagePack).%OpenId(PackId)
	.q:'$IsObject(PackObj)
	.d PackObj.%Reload()
	.s CSSDPPDate = PackObj.CSSDPPDate
	.s LevelFlag = PackObj.CSSDPPLevelFlag
	.s Label = PackObj.CSSDPPLabel
	.s PkgId = PackObj.CSSDPPPackage.%Id()
	.s MaterialObj=PackObj.CSSDPPMaterialDr
	.s PackUserObj = PackObj.CSSDPPAckUserDr
	.s PackChkUserObj = PackObj.CSSDPPUserDr
	.s PackerObj=PackObj.CSSDPPPackUserDr
	.s BioFlag=PackObj.CSSDPPPackage.CSSDPNotBioFlag
	.s ToLocId=PackObj.CSSDPPPackLocDrGetObjectId()
	.s HeatNo = PackObj.CSSDPPHeatNo
	.s CallDetailObj=PackObj.CSSDPPCallDetailDr
	.i $IsObject(CallDetailObj) d
	..s CallBackObj=CallDetailObj.CSSDCDParref
	..q:'$IsObject(CallBackObj)
	..s ApplyType=CallDetailObj.CSSDCDParref.CSSDPCApplyType
	..i ApplyType '="2" s CallBackNo=CallBackObj.CSSDPCSerialNo
	..s ApplyDetailObj=CallDetailObj.CSSDCDPackageApplyDetailDR
	..q:'$IsObject(ApplyDetailObj)
	..s ApplyId=ApplyDetailObj.CSSDPADParref
	..q:ApplyId=""
	..s ApplyNo=##class(User.CSSDPackageApply).%OpenId(ApplyId).CSSDPANO
	.s Machine=PackObj.CSSDPPMachineDRGetObjectId()
	.q:(pMachine'="")&&(pMachine'=Machine)
	.q:(ExactMatchFlag="Y")&&(PMachineNoDR'=Machine)
	.s MachineDesc = PackObj.CSSDPPMachineDR.CSSDMCAlias
	.q:PkgId=""
	.q:(LineLocStr'="")&&(LineLocStr'[("^"_ToLocId_"^"))
	.
	.s TransId= $o(^User.CSSDTransI("CSSDTLabel",Label,""))
	.q:TransId=""
	.s TransObj=##Class(User.CSSDTrans).%OpenId(TransId)
	.q:'$IsObject(TransObj)
	.d TransObj.%Reload()
	.s ExpDate=TransObj.CSSDTExpDate
	.s NowDate=$p($h,",",1)
	.q:NowDate>=ExpDate
	.s Status=$lg(^User.CSSDTransD(TransId),8)
	.q:Status="PA" ;过滤停用标签
	.i $IsObject(PackUserObj) s PackUserName=PackUserObj.SSUSRName
	.i $IsObject(PackChkUserObj) s PackChkUserName=PackChkUserObj.SSUSRName
	.i $IsObject(PackerObj) s PackerName=PackerObj.SSUSRName
	.
	.q:((CSSDPPDate<PStartDate)||(CSSDPPDate>PEndDate))
	.s:LevelFlag="" LevelFlag=0
	.s SterPredoDetailId=$o(^User.CSSDSterPredoDetailI("IndexLable",Label,""))
	.s (SterPredoDetailStates,MainStatus)=""
	.i SterPredoDetailId'="" d
	..s SterPredoDetailObj=##class(User.CSSDSterPredoDetail).%OpenId(SterPredoDetailId)
	..q:'$IsObject(SterPredoDetailObj)
	..s SterPredoDetailStates=SterPredoDetailObj.CSSDSPStates
	..s SterPredoObj=SterPredoDetailObj.CSSDSPDMainDr
	..i $IsObject(SterPredoObj) s MainStatus=SterPredoObj.CSSDSPStatus
	.q:((SterPredoDetailStates="Y")||(MainStatus=0))
	.
	.s DispFlag=##class(web.CSSDHUI.PackageDisp.Disp).CheckLabelDispExist(Label)
	.q:DispFlag="Y"
	.
	.s PkgObj=##class(User.CSSDPackage).%OpenId(PkgId)
	.s PkgDesc=PkgObj.CSSDPDesc
	.s AttributeId=PkgObj.CSSDPPackTypeDetail
	.s PkgSterTypeObj=PkgObj.CSSDPSterType
	.s PkgSterType=PkgSterTypeObj.%Id()
	.q:PkgSterType=""
	.s PkgIsLowerTemp=PkgSterTypeObj.CSSDSTIsLowerTemp
	.s SterTypeDesc=PkgSterTypeObj.CSSDSTSterName
	.s SterTypeColor=PkgSterTypeObj.CSSDSTDisplayColor
	.s ParamsStr=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	.s IsLowSterModeMix=##Class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDSTERILIZE","IsLowSterModeMix",ParamsStr)
	.q:(IsLowSterModeMix="Y")&&(SterType'="")&&(IsLowTempFlag'="")&&(IsLowTempFlag'=PkgIsLowerTemp)
	.q:(IsLowSterModeMix="N")&&(SterType'="")&&(SterType'=PkgSterType)
	.q:(PAttributeId'="")&&(PAttributeId'=AttributeId)
	.s AttributeDesc=##class(web.CSSDHUI.Common.PackageInfoCommon).GetPackageDetailDesc(AttributeId)
	.i AttributeId="1" d
	..s PkgDesc=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetCodeDictName(Label)
	.
	.s MaterialDesc=$s(MaterialObj'="":MaterialObj.CSSDMDesc,1:"")
	.s ^TMPCSSD("WAITINGSTER",Pid,LevelFlag,Num)=RowId_"^"_Label_"^"_PkgDesc_"^"_PackUserName_"^"_PackChkUserName_"^"_AttributeId_"^"_AttributeDesc_"^"_PackerName_"^"_BioFlag_"^"_LevelFlag_"^"_MaterialDesc_"^"_MachineDesc_"^"_HeatNo_"^"_ApplyNo_"^"_CallBackNo_"^"_SterTypeDesc_"^"_SterTypeColor
	.s Num=Num+1
	
	s TmpLevel=""
	f  s TmpLevel=$o(^TMPCSSD("WAITINGSTER",Pid,TmpLevel),-1) q:TmpLevel=""  d
	.s TmpNum=0
	.f  s TmpNum=$o(^TMPCSSD("WAITINGSTER",Pid,TmpLevel,TmpNum)) q:TmpNum=""  d
	..s LabelInfo=^TMPCSSD("WAITINGSTER",Pid,TmpLevel,TmpNum)
	..s RowId=$p(LabelInfo,"^",1)
	..s Label=$p(LabelInfo,"^",2)
	..s PkgDesc=$p(LabelInfo,"^",3)
	..s PackUserName=$p(LabelInfo,"^",4)
	..s PackChkUserName=$p(LabelInfo,"^",5)
	..s AttributeId=$p(LabelInfo,"^",6)
	..s AttributeDesc=$p(LabelInfo,"^",7)
	..s PackerName=$p(LabelInfo,"^",8)
	..s BioFlag=$p(LabelInfo,"^",9)
	..s LevelFlag=$p(LabelInfo,"^",10)
	..s MaterialDesc=$p(LabelInfo,"^",11)
	..s MachineDesc=$p(LabelInfo,"^",12)
	..s HeatNo=$p(LabelInfo,"^",13)
	..s ApplyNo=$p(LabelInfo,"^",14)
	..s CallBackNo=$p(LabelInfo,"^",15)
	..s SterTypeDesc=$p(LabelInfo,"^",16)
	..s SterTypeColor=$p(LabelInfo,"^",17)
	..d OutPutPackageRow

	Quit $$$OK
OutPutPackageRow
	s Data=$lb(RowId,Label,PkgDesc,PackUserName,PackChkUserName,
			AttributeId,AttributeDesc,PackerName,BioFlag,LevelFlag,MaterialDesc,MachineDesc,HeatNo,ApplyNo,CallBackNo,SterTypeDesc,SterTypeColor)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
