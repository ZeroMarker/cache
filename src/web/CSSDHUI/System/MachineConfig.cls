Import sqluser

Class web.CSSDHUI.System.MachineConfig Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.System.MachineConfig","QueryMachineInfo","{""BDPHospital"":""2"",""MachineType"":""sterilizer"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}")
Query QueryMachineInfo(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Alias,MachineNum:%Integer,Manufacture,ManufactureDesc,DataPath,ExtType,IsBd,NotUseFlag,LoadNum,TempType,TempTypeDesc,SterCar,SterCarName,IsLeak,LeakTime,FileNamePrefix,Cycle,Model,SupLocId,SupLocDesc,MulBinFlag,BioTime") [ SqlProc ]
{
}

ClassMethod QueryMachineInfoExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	
	s gLocId = PJObj.%Get("gLocId")
	s gHospId=PJObj.%Get("gHospId")
	s PType = PJObj.%Get("MachineType")
	s PHospId=PJObj.%Get("BDPHospital")
	s HospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(PHospId,gHospId)

	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="select ID as RowId, CSSDMC_Alias as Alias,CSSDMC_Num as MachineNum,"
			_"CSSDMC_MachineType as MachineType,CSSDMC_Manufacture as Manufacture,CSSDMC_SterCar as SterCar,"
			_"CSSDMC_DataPath as DataPath,CSSDMC_ExtType as ExtType,CSSDMC_IsBD as IsBd,"
			_"CSSDMC_NotUseFlag AS NotUseFlag,CSSDMC_LoadNum as LoadNum,CSSDMC_TempType AS TempType,"
			_"CSSDMC_CreateLocDr,CSSDMC_IsLeak,CSSDMC_LeakTime,CSSDMC_FileNamePrefix,CSSDMC_Cycle,"
			_"CSSDMC_Model,CSSDMC_SupLoc_DR SupLocId,CSSDMC_SupLoc_DR->CTLOC_Desc as SupLocDesc,CSSDMC_MulBinFlag as MulBinFlag, "
			_"CSSDMC_BioTime "
			_" from CSSD_MachineConfig "
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s Alias=Result.Data("Alias")
		s MachineNum = Result.Data("MachineNum")
		s Manufacture = Result.Data("Manufacture")
		s DataPath = Result.Data("DataPath")
		s ExtType=Result.Data("ExtType")
		s IsBd=Result.Data("IsBd")
		s NotUseFlag=Result.Data("NotUseFlag")
		s LoadNum=Result.Data("LoadNum")
		s TempType=Result.Data("TempType")
		s SterCar=Result.Data("SterCar")
		s IsLeak=Result.Data("CSSDMC_IsLeak")
		s LeakTime=Result.Data("CSSDMC_LeakTime")
		s FileNamePrefix=Result.Data("CSSDMC_FileNamePrefix")
		s Cycle=Result.Data("CSSDMC_Cycle")
		s Model=Result.Data("CSSDMC_Model")
		s SupLocId=Result.Data("SupLocId")
		s SupLocDesc=Result.Data("SupLocDesc")
		s MulBinFlag=Result.Data("MulBinFlag")
		s MachineType = Result.Data("MachineType")
		s CreateLocDr=Result.Data("CSSDMC_CreateLocDr")
		s BioTime=Result.Data("CSSDMC_BioTime")
		s result =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_MachineConfig",RowId,HospId)
		continue:result="N"
		continue:((PType'="")&&(MachineType'=PType))
		
		s (ManufactureDesc,TempTypeDesc,SterCarName)=""
		s VenObj=##class(User.CSSDVen).%OpenId(Manufacture)
		s:$IsObject(VenObj) ManufactureDesc=VenObj.CSSDVenName
		s SterCarObj = ##class(User.CSSDCodeDict).%OpenId(SterCar)
		s:$IsObject(SterCarObj) SterCarName = SterCarObj.CSSDCDPackName
		
		i (MachineType="sterilizer") d
		.s TempTypeObj=##class(User.CSSDSterType).%OpenId(TempType)
		.s:$IsObject(TempTypeObj) TempTypeDesc=TempTypeObj.CSSDSTSterName
		e  i (MachineType="washer") d
		.s TempTypeObj=##class(User.CSSDCleanType).%OpenId(TempType)
		.s:$IsObject(TempTypeObj) TempTypeDesc=TempTypeObj.CSSDCTCleanMode
		d OutPutRow
	}
	d Result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,Alias,MachineNum,Manufacture,ManufactureDesc,
		DataPath,ExtType,IsBd,NotUseFlag,LoadNum,
		TempType,TempTypeDesc,SterCar,SterCarName,IsLeak,LeakTime,
		FileNamePrefix,Cycle,Model,SupLocId,SupLocDesc,MulBinFlag,BioTime)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 保存机器信息
/// w ##class(web.CSSDHUI.System.MachineConfig).jsSave(^tmpwn("P"),^tmpwn("O"))
ClassMethod jsSave(Params As %String, Others As %String) As %Library.String
{
	n (Params,Others)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..Save(Params,Others)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// 保存机器信息
/// Creater:wxj
/// CreateDate:	2019-04-26
/// w ##class(web.CSSDHUI.System.MachineConfig).Save(^tmpwn("P"),^tmpwn("O"))
ClassMethod Save(Params As %String, Others As %String) As web.CSSDHUI.RtnObj
{
	n (Params,Others)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	s OthersObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s OthersSc=OthersObj.%FromJSON(Others)
	q:((Sc'=0)||(OthersSc'=0)) RtnObj.Err(-1,"","入参解析失败!")
	
	s PHospId=OthersObj.%Get("BDPHospital")
	s gHospId=OthersObj.%Get("gHospId")
	s gLocId=OthersObj.%Get("gLocId")
	s gGroupId=OthersObj.%Get("gGroupId")
	s gUserId=OthersObj.%Get("gUserId")
	s MachineType=OthersObj.%Get("MachineType")
	s HospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(PHospId,gHospId)
	
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s RowId=Obj.%Get("RowId")
		s Alias=Obj.%Get("Alias")
		s MachineNum=Obj.%Get("MachineNum")
		s Manufacture=Obj.%Get("Manufacture")
		s DataPath=Obj.%Get("DataPath")
		s ExtType=Obj.%Get("ExtType")
		s IsBd=Obj.%Get("IsBd")
		s LeakTime=Obj.%Get("LeakTime")
		s NotUseFlag=Obj.%Get("NotUseFlag")
		s Model=Obj.%Get("Model")
		s LoadNum=Obj.%Get("LoadNum")
		s TempType=Obj.%Get("TempType")
		s SterCar=Obj.%Get("SterCar")
		s FileNamePrefix=Obj.%Get("FileNamePrefix")
		s Cycle=Obj.%Get("Cycle")
		s SupLocId=Obj.%Get("SupLocId")
		s MulBinFlag=Obj.%Get("MulBinFlag")
		s BioTime=Obj.%Get("BioTime")
		
		s IsLeak="N"
		i LeakTime'="" s IsLeak="Y"
		
		s:MulBinFlag="" MulBinFlag="N"
		s:((IsBd="")&&(MachineType'="sterilizer")) IsBd="N"
		s:((IsLeak="")&&(MachineType'="sterilizer")) IsLeak="N"
		s AliasId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Alias",Alias,"CSSD_MachineConfig",HospId,"",MachineType)
		s MachineNumId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("MachineNum",MachineNum,"CSSD_MachineConfig",HospId,"",MachineType)
		
		i Alias="" d RtnObj.Err(-1,"","名称不能为空！")
		continue:RtnObj.success'=0
		i MachineNum="" d RtnObj.Err(-2,"","代码不能为空！")
		continue:RtnObj.success'=0
		i ((AliasId'="")&&(AliasId'=RowId)) d RtnObj.Err(-4,"","机器名称已存在！")
		continue:RtnObj.success'=0
		i ((MachineNumId'="")&&(MachineNumId'=RowId)) d RtnObj.Err(-5,"","机器代码已存在！")
		continue:RtnObj.success'=0
		
		s SterCarType=""
		s SterCarObj = ##class(User.CSSDCodeDict).%OpenId(SterCar)
		i $IsObject(SterCarObj) d
		.d SterCarObj.%Reload()
		.s SterCarDr = SterCarObj.CSSDCDPackDR.%Id()
		.s PackageCarObj = ##class(User.CSSDPackage).%OpenId(SterCarDr)
		.d PackageCarObj.%Reload()
		.s SterCarTypeObj = PackageCarObj.CSSDPSterType
		.s:$IsObject(SterCarTypeObj) SterCarType = SterCarTypeObj.%Id()
		.i SterCarType=""  d RtnObj.Err(-7,"","灭菌架未维护灭菌方式！")
		continue:RtnObj.success'=0
		i ((MachineType="sterilizer")&&(TempType'="")&&(SterCarType'="")&&(TempType'=SterCarType)) d RtnObj.Err(-8,"","灭菌器灭菌方式与灭菌架灭菌方式不匹配！")
		continue:RtnObj.success'=0
		
		i RowId="" d
		.s MachineObj=##class(User.CSSDMachineConfig).%New()
		e  d
		.s MachineObj=##class(User.CSSDMachineConfig).%OpenId(RowId)
		.d MachineObj.%Reload()
		s MachineObj.CSSDMCAlias=Alias
		s MachineObj.CSSDMCNum=MachineNum
		s MachineObj.CSSDMCMachineType=MachineType
		d MachineObj.CSSDMCManufactureSetObjectId(Manufacture)
		s MachineObj.CSSDMCDataPath=DataPath
		s MachineObj.CSSDMCExtType=ExtType
		s MachineObj.CSSDMCIsBD=IsBd
		s MachineObj.CSSDMCNotUseFlag=NotUseFlag
		s MachineObj.CSSDMCLoadNum=LoadNum
		s MachineObj.CSSDMCTempType=TempType
		d MachineObj.CSSDMCSterCarSetObjectId(SterCar)
		s MachineObj.CSSDMCIsLeak=IsLeak
		s MachineObj.CSSDMCLeakTime=LeakTime
		s MachineObj.CSSDMCFileNamePrefix=FileNamePrefix
		s MachineObj.CSSDMCCycle=Cycle
		s MachineObj.CSSDMCModel=Model
		d MachineObj.CSSDMCSupLocDRSetObjectId(SupLocId)
		s MachineObj.CSSDMCMulBinFlag=MulBinFlag
		s MachineObj.CSSDMCBioTime=BioTime
		s Sc=MachineObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-4,"",$ClassName()_":Save:保存厂商信息失败!")
		continue:RtnObj.success'=0
		
		i RowId="" d
		.s MachineId=MachineObj.%Id()
		.s Ret = ##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_MachineConfig",MachineId,HospId)
		.i Ret'=0 d RtnObj.Err(-8,"","关联院区失败!")
		continue:RtnObj.success'=0
	}
	q RtnObj
}

/// 删除机器信息
/// d ##class(web.CSSDHUI.System.MachineConfig).DeleteMachineInfo()
ClassMethod DeleteMachineInfo(Params As %String) As %Library.String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s sc=PJObj.%FromJSON(Params)
	q:sc'=0 RtnObj.Err(-1,"","入参解析失败!")
	s Obj=PJObj.%Pop()
	s RowId=Obj.%Get("RowId")
	
	&sql(Delete From CSSD_MachineConfig where ID=:RowId)
	q:SQLCODE'=0 RtnObj.Err(-11,"",$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
	s Ret=##class(web.CSSDHUI.HospMap).DeleteHospitals("CSSD_MachineConfig",RowId)
	q:Ret'=0 RtnObj.Err(-2,RowId,MethodName_":删除医院关联数据失败！,SQLOCDE:"_SQLCODE) 
	
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2021.10.29
/// Description:每次生成灭菌批号、清洗批号需要更新为新的循环数
/// Table:cssd_sterilizerecord
/// Input:MachineId：机器id
/// Output:
/// Return:日志信息
/// w ##class(web.CSSDHUI.System.MachineConfig).UpdateMachineCycle("2")
ClassMethod UpdateMachineCycle(MachineId As %String) As web.CSSDHUI.RtnObj
{
	n (MachineId)
	
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s MachineObj=##class(User.CSSDMachineConfig).%OpenId(MachineId)
	d MachineObj.%Reload()
	s Cycle=MachineObj.CSSDMCCycle+1
	&sql(UPDATE CSSD_MachineConfig SET CSSDMC_Cycle=:Cycle WHERE ID=:MachineId)
	i SQLCODE'=0 d RtnObj.Err(-1,"","更新机器循环次数失败！")
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

}
