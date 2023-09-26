Import sqluser

/// wfg
/// 2019-6-19
/// 统计打包表
Class web.CSSDHUI.Stat.PackStat Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Descript:	统计打包表数据
/// Creator:	wfg
/// CreateDate:	2019-7-11
/// Table:		CSSD_PackagePack
/// Input:		排序，查询条件
/// Return：	消毒包配包信息
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Stat.PackStat","QueryDetail",^tmpmy("cd"))
Query QueryDetail(Params As %Text) As web.CSSDHUI.Query(ROWSPEC = "PackLocId,PackLocDesc,PackDate,PackUserName,PackChkUserName,PkgId,PkgDesc,PkgClassId,PkgClassDesc,SpecId,Qty:%Integer,SterMachineDesc,MaterialDesc") [ SqlProc ]
{
}

ClassMethod QueryDetailExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	s PStartTime=PJObj.%Get("StartTime")
	s PEndTime=PJObj.%Get("EndTime")
	s PPackLocId=PJObj.%Get("PackLoc")
	s PPkgClassId=PJObj.%Get("PkgClass")
	s PPkgId=PJObj.%Get("PackName")
	s PSpecId=PJObj.%Get("PkgSpec")
	s gHospId=PJObj.%Get("gHospId")
	q:PStartDate="" $$$OK
	q:PEndDate="" $$$OK
	
	s:PStartTime'="" PStartTime=..TH2L(PStartTime)
	s:PEndTime'="" PEndTime=..TH2L(PEndTime)
	s:PStartTime="86399" PStartTime=""
	s:PEndTime="86399" PEndTime=""
	s PStartDate=..DH2L(PStartDate)
	s PEndDate=..DH2L(PEndDate)
	
	s sql="SELECT CSSDPP_Loc_DR PackLocId,CSSDPP_Loc_DR->CTLOC_Desc PackLocDesc,"
		_" CSSDPP_Date PackDate,CSSDPP_User_DR->SSUSR_Name PackUserName,"
		_" CSSDPP_Time PackTime,CSSDPP_AckUser_DR->SSUSR_Name PackChkUserName,"
		_" CSSDPP_Package_DR PkgId,CSSDPP_Package_DR->CSSDP_Desc as PkgDesc,CSSDPP_Qty Qty,"
		_" CSSDPP_Package_DR->CSSDP_SpecDr SpecId,CSSDPP_Package_DR->CSSDP_PackClassdr PkgClassId,"
		_" CSSDPP_Package_DR->CSSDP_PackClassdr->CSSDPC_PackClassName PkgClassDesc,"
		_" CSSDPP_Machine_DR SterMachineId,CSSDPP_Machine_DR->CSSDMC_Alias SterMachineDesc,"
		_" CSSDPP_Machine_DR SterMachineId,CSSDPP_Material_DR->CSSDM_Desc MaterialDesc "
		_" FROM CSSD_PackagePack "
		_" where CSSDPP_Date between "_PStartDate_" and "_PEndDate
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	d Result.Prepare(sql)
	d Result.Execute()
	While(Result.Next())
	{
		s PackLocId = Result.Data("PackLocId")
		s PackLocDesc = Result.Data("PackLocDesc")
		s PackDate = Result.Data("PackDate")
		s PackTime = Result.Data("PackTime")
		s PackUserName = Result.Data("PackUserName")
		s PackChkUserName = Result.Data("PackChkUserName")
		s PkgId = Result.Data("PkgId")
		s PkgDesc = Result.Data("PkgDesc")
		s PkgClassId = Result.Data("PkgClassId")
		s PkgClassDesc = Result.Data("PkgClassDesc")
		s SpecId = Result.Data("SpecId")
		s Qty = Result.Data("Qty")
		s SterMachineDesc = Result.Data("SterMachineDesc")
		s MaterialDesc= Result.Data("MaterialDesc")
		s ShowDataFlag=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CT_Loc",PackLocId,gHospId)
		continue:ShowDataFlag="N"
		continue:((PStartTime'="")&&(PackTime<PStartTime))&&(PackDate=PStartDate)
		continue:((PEndTime'="")&&(PackTime>=PEndTime))&&(PackDate=PEndDate)
		continue:((PPackLocId'="")&&(PPackLocId'=PackLocId))
		continue:((PPkgId'="")&&(PPkgId'=PkgId))
		continue:((PPkgClassId'="")&&(PPkgClassId'=PkgClassId))
		continue:((PSpecId'="")&&(PSpecId'=SpecId))
		s PackDate=..DL2H(PackDate)
		s PackTime=..TL2H(PackTime)
		s PackDate=PackDate_" "_PackTime
		d OutputRow
	}
	Quit $$$OK

OutputRow  
	s Data=$lb(PackLocId,PackLocDesc,PackDate,PackUserName,PackChkUserName,PkgId,PkgDesc,PkgClassId,PkgClassDesc,SpecId,Qty,SterMachineDesc,MaterialDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
