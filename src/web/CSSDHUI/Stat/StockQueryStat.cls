Class web.CSSDHUI.Stat.StockQueryStat Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Descript:库存查询(注意供应室/临床科室的区分处理)
/// Creator:lxt
/// CreateDate:20221117
/// Table:CSSD_Trans
/// Input:查询条件
/// Return：库存数据
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Stat.StockQueryStat","SelectAll",^templxt("SelectAll"))
Query SelectAll(Params As %Text) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Label,CodeDict,PkgId,PkgDesc,AttributeId,AttributeDesc,SpecId,SpecDesc,Expdate,Status,StatusDesc,PackDate,PackLocId,PackLocDesc,SterLocId,SterLocDesc,SterDate") [ SqlProc ]
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1

	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s PPkgId=PJObj.%Get("PackageName")
	s PCodeDict=PJObj.%Get("CodeDict")
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	s PSpecId=PJObj.%Get("PkgSpec")
	s PPackLocId=PJObj.%Get("PackLoc")		;供应室
	s PRecLocId=PJObj.%Get("RecLoc")		;接收科室, 此值为空时,仅查询临床科室R类型数据(接收)
	s PStatus=PJObj.%Get("Status")
	s PRegNo=PJObj.%Get("RegNo")
	s gHospId=PJObj.%Get("gHospId")
	q:PStartDate="" $$$OK
	q:PEndDate="" $$$OK

	s PStartDate=..DH2L(PStartDate)
	s PEndDate=..DH2L(PEndDate)

	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT CSSDT_Rowid,CSSDT_Label,CSSDT_CodeDict,CSSDT_Package_DR,CSSDT_Date,CSSDT_ExpDate,CSSDT_Status,"
		_" CSSDT_Pack_DR,CSSDT_Pack_DR->CSSDPP_Loc_DR PackLocId,"
		_" CSSDT_Sterilize_DR,CSSDT_Sterilize_DR->CSSDPS_Parref_DR->CSSDSR_Date SterDate,CSSDT_Sterilize_DR->CSSDPS_Parref_DR->CSSDSR_Loc_DR SterLocId,"
		_" CSSDT_CurrLoc_DR "
		_" FROM CSSD_Trans where CSSDT_Date between "_PStartDate_" and "_PEndDate
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("CSSDT_Rowid")
		s Label = Result.Data("CSSDT_Label")
		s CodeDict=Result.Data("CSSDT_CodeDict")
		s PkgId = Result.Data("CSSDT_Package_DR")
		s PackDate = Result.Data("CSSDT_Date")
		s Expdate=Result.Data("CSSDT_ExpDate")
		s Status = Result.Data("CSSDT_Status")
		s PackId = Result.Data("CSSDT_Pack_DR")
		s PackLocId = Result.Data("PackLocId")
		s SterItmId = Result.Data("CSSDT_Sterilize_DR")
		s SterDate = Result.Data("SterDate")
		s SterLocId = Result.Data("SterLocId")
		s CurrLoc=Result.Data("CSSDT_CurrLoc_DR")
		continue:(PPackLocId'="")&&(PPackLocId'=PackLocId)
		continue:(PPkgId'="")&&(PPkgId'=PkgId)
		continue:(PCodeDict'="")&&(CodeDict'[PCodeDict)
		s ShowDataFlag=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_Package",PkgId,gHospId)
		continue:ShowDataFlag="N"

		s PkgObj = ##class(User.CSSDPackage).%OpenId(PkgId)
		s PkgDesc=PkgObj.CSSDPDesc
		s SpecId=PkgObj.CSSDPSpecDrGetObjectId()
		s AttributeId=PkgObj.CSSDPPackTypeDetail
		s SterTypeObj=PkgObj.CSSDPSterType
		s IsSter=PkgObj.CSSDPSterType.CSSDSTIsSter
		continue:((PSpecId'="")&(PSpecId'=SpecId))

		s StatusFlag="N"
		i (IsSter="Y")&&(Status="S") s StatusFlag="Y"		//需要灭菌器时要求灭菌完成
		e  i (IsSter="N")&&(Status="P") s StatusFlag="Y"	//不需要灭菌器时要求打包完成
		continue:(PRecLocId="")&&(StatusFlag="N")
		continue:(PRecLocId'="")&&(PStatus'="")&&((PStatus'[Status)||((PRecLocId'=CurrLoc)))

		s RegNo=""
		i PRegNo'="" d
		.s TransOPId=$o(^User.CSSDTransOPI("CSSDTOPLabelIndex",Label,""))
		.q:TransOPId=""
		.s Adm=$lg(^User.CSSDTransOPD(TransOPId),10)
		.s PatInfo=##class(web.CSSDHUI.PackageRegister.PkgRegister).ByAdmGetPatInfo(Adm)
		.s RegNo=$p(PatInfo,"^",1)
		continue:(PRegNo'="")&&(PRegNo'=RegNo)

		i AttributeId="1" s PkgDesc=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetCodeDictName(Label)
		s AttributeDesc=##class(web.CSSDHUI.Common.PackageInfoCommon).GetPackageDetailDesc(AttributeId)
		s StatusDesc=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetStatusChinese(Status)
		s PackDate=..DL2H(PackDate)
		s Expdate=..DL2H(Expdate)
		s SterDate=..DL2H(SterDate)
		s PackLocDesc=..sssLocDesc(PackLocId)
		s SterLocDesc=..sssLocDesc(SterLocId)
		s SpecDesc=$s(SpecId'="":PkgObj.CSSDPSpecDr.PSSpecDesc,1:"")
		d OutPutRow
	}
	d Result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,Label,CodeDict,PkgId,PkgDesc,AttributeId,AttributeDesc,SpecId,SpecDesc,Expdate,Status,StatusDesc,PackDate,PackLocId,PackLocDesc,SterLocId,SterLocDesc,SterDate)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
