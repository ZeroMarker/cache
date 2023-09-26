Import sqluser

Class web.CSSDHUI.System.DailySurvey Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:ban
/// CreatDate:2022-3-22
/// Description:根据参数获取日常监测数据
/// Table:CSSD_DailySurvey
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.System.DailySurvey","SelectAll","{""FStartDate"":""2022-08-15"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""FEndDate"":""2022-08-16""}")
Query SelectAll(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,DailyDate,PkgId,PkgDesc,PkgClassId,PkgClassDesc,SpecId,SpecDesc,Qty,PackCheckId,PropertyId,MaterialId,MaterialDesc,CheckMaterialId,PreciseProtectId,CardoProtectId,CheCardId,WidthId,DistanceId,TapeTooShortId,IncompleteCloseId,SixMarksId,VolumeId,WeightInstrusId,WeightDressId,PackUserId,CheckUserId,PackUserName,CheckUserName")
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"",MethodName_":参数解析失败")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s PStartDate=PJObj.%Get("FStartDate")
	s PEndDate=PJObj.%Get("FEndDate")
	q:PStartDate="" $$$OK
	q:PEndDate="" $$$OK
	
	s PStartDate=..DH2L(PStartDate)
	s PEndDate=..DH2L(PEndDate)
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT ID,CSSDS_Date,CSSDDS_PackageDR,CSSDDS_PackageDR->CSSDP_Desc AS PkgDesc,CSSDDS_Type,"
			_"CSSDDS_Type->CSSDPC_PackClassName as PackClassName,CSSDDS_Spec,CSSDDS_Qty,CSSDDS_Property,CSSDDS_SelectMaterial,"
			_"CSSDDS_SelectMaterial->CSSDM_Desc as MaterialDesc,CSSDDS_CheckMaterial,CSSDDS_PreciseProtect,CSSDDS_CardoProtect,"
			_"CSSDDS_Width,CSSDDS_Distance,CSSDDS_TapeTooShort,CSSDDS_IncompleteClose,CSSDDS_SixMarks,"
			_"CSSDDS_CheCard,CSSDDS_Volume,CSSDDS_WeightInstrus,CSSDDS_WeightDress,CSSDDS_PackDr,"
			_"CSSDDS_CheckDr,CSSDDS_PackCheck FROM CSSD_DailySurvey"
			_" where CSSDS_Date between "_PStartDate_" and "_PEndDate
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{	
		s RowId = Result.Data("ID")
		s DailyDate= Result.Data("CSSDS_Date")
		s PkgId = Result.Data("CSSDDS_PackageDR")
		s PkgDesc = Result.Data("PkgDesc")
		s PkgClassId = Result.Data("CSSDDS_Type")
		s PkgClassDesc = Result.Data("PackClassName")
		s SpecId = Result.Data("CSSDDS_Spec")
		s Qty = Result.Data("CSSDDS_Qty")
		s PackCheckId = Result.Data("CSSDDS_PackCheck")
		s PropertyId = Result.Data("CSSDDS_Property")
		s MaterialId = Result.Data("CSSDDS_SelectMaterial")
		s MaterialDesc = Result.Data("MaterialDesc")
		s CheckMaterialId=Result.Data("CSSDDS_CheckMaterial")
		s PreciseProtectId = Result.Data("CSSDDS_PreciseProtect")
		s CardoProtectId = Result.Data("CSSDDS_CardoProtect")
		s CheCardId = Result.Data("CSSDDS_CheCard")
		s WidthId = Result.Data("CSSDDS_Width")
		s DistanceId = Result.Data("CSSDDS_Distance")
		s TapeTooShortId = Result.Data("CSSDDS_TapeTooShort")
		s IncompleteCloseId = Result.Data("CSSDDS_IncompleteClose")
		s SixMarksId = Result.Data("CSSDDS_SixMarks")
		s VolumeId = Result.Data("CSSDDS_Volume")
		s WeightInstrusId = Result.Data("CSSDDS_WeightInstrus")
		s WeightDressId = Result.Data("CSSDDS_WeightDress")
		s PackUserId = Result.Data("CSSDDS_PackDr")
		s CheckUserId = Result.Data("CSSDDS_CheckDr")
		
		s DailyDate=..DL2H(DailyDate)
		s (PackUserName,CheckUserName)=""
		i PackUserId'="" s PackUserName=$p($g(^SSU("SSUSR",PackUserId)),"^",2)
		i CheckUserId'="" s CheckUserName=$p($g(^SSU("SSUSR",CheckUserId)),"^",2)
		
		s SpecDesc=""
		s PkgSpecObj=##class(CT.STER.CSSD.PackageSpec).%OpenId(SpecId)
		i $IsObject(PkgSpecObj) s SpecDesc=PkgSpecObj.PSSpecDesc
		d OutPutRow
	}
	d Result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,DailyDate,PkgId,PkgDesc,PkgClassId,PkgClassDesc,SpecId,SpecDesc,Qty,PackCheckId,PropertyId,MaterialId,MaterialDesc,CheckMaterialId,PreciseProtectId,CardoProtectId,CheCardId,WidthId,DistanceId,TapeTooShortId,IncompleteCloseId,SixMarksId,VolumeId,WeightInstrusId,WeightDressId,PackUserId,CheckUserId,PackUserName,CheckUserName)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:ban
/// CreatDate:2022-3-22
/// Description:删除日常监测信息
/// Table:CSSD_DailySurvey
/// d ##class(web.CSSDHUI.System.DailySurvey).jsDelete(214)
ClassMethod jsDelete(Params As %String) As %Library.String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..Delete(Params)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2022-3-22
/// Description:删除日常监测信息
/// Table:CSSD_DailySurvey
/// d ##class(web.CSSDHUI.System.DailySurvey).Delete(214)
ClassMethod Delete(Params As %String) As web.CSSDHUI.RtnObj
{
	n (Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_":参数解析失败")
	
	While(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s RowId=Obj.%Get("RowId")
		&sql(Delete From CSSD_DailySurvey WHERE ID=:RowId)
		i SQLCODE'=0  d RtnObj.Err(-2,rowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
		continue:RtnObj.success<0
	}
	q:RtnObj.success<0 RtnObj
	
	q RtnObj
}

/// Creator:ban
/// CreatDate:2022-3-22
/// Description:保存日常监测信息
/// Table:CSSD_DailySurvey
/// d ##class(web.CSSDHUI.System.DailySurvey).jsSave(^tmpllljkk)
ClassMethod jsSave(Params As %String) As %Library.String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..Save(Params)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2022-3-22
/// Description:保存日常监测信息
/// Table:CSSD_DailySurvey
/// d ##class(web.CSSDHUI.System.DailySurvey).Save("33607","[{""PackageName"":""20cm弯钳"",""PackageDR"":""26"",""UnDispQty"":""2""}]")
ClassMethod Save(Params) As web.CSSDHUI.RtnObj
{
	n (Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i Params="" q RtnObj.Err(-1,"","入参不能为空!")
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-2,"","入参解析失败!")
	
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s RowId=Obj.%Get("RowId")
		s DailyDate=Obj.%Get("DailyDate")
		s PkgId=Obj.%Get("PkgId")
		s PkgClassId=Obj.%Get("PkgClassId")
		s SpecId=Obj.%Get("SpecId")
		s Qty=Obj.%Get("Qty")
		s PackCheckId=Obj.%Get("PackCheckId")
		s PropertyId=Obj.%Get("PropertyId")
		s MaterialId=Obj.%Get("MaterialId")
		s CheckMaterialId=Obj.%Get("CheckMaterialId")
		s PreciseProtectId=Obj.%Get("PreciseProtectId")
		s CardoProtectId=Obj.%Get("CardoProtectId")
		s CheCardId=Obj.%Get("CheCardId")
		s WidthId=Obj.%Get("WidthId")
		s DistanceId=Obj.%Get("DistanceId")
		s TapeTooShortId=Obj.%Get("TapeTooShortId")
		s IncompleteCloseId=Obj.%Get("IncompleteCloseId")
		s SixMarksId=Obj.%Get("SixMarksId")
		s VolumeId=Obj.%Get("VolumeId")
		s WeightInstrusId=Obj.%Get("WeightInstrusId")
		s WeightDressId=Obj.%Get("WeightDressId")
		s PackUserId=Obj.%Get("PackUserId")
		s CheckUserId=Obj.%Get("CheckUserId")
		s DailyDate=..DH2L(DailyDate)
		
		s obj=""
		i RowId="" d
		.s obj=##class(User.CSSDDailySurvey).%New()
		e  d
		.s obj=##class(User.CSSDDailySurvey).%OpenId(RowId)
		.d obj.%Reload()
		s obj.CSSDSDate=DailyDate
		s obj.CSSDDSPackage=##class(User.CSSDPackage).%OpenId(PkgId)
		s obj.CSSDDSType=##class(User.CSSDPackageClass).%OpenId(PkgClassId)
		s obj.CSSDDSSpec=SpecId
		s obj.CSSDDSQty=Qty
		s obj.CSSDDSPackCheck=PackCheckId
		s obj.CSSDDSProperty=PropertyId
		s obj.CSSDDSSelectMaterial=##class(User.CSSDMaterial).%OpenId(MaterialId)
		s obj.CSSDDSCheckMaterial=CheckMaterialId
		s obj.CSSDDSPreciseProtect=PreciseProtectId
		s obj.CSSDDSCardoProtect=CardoProtectId
		s obj.CSSDDSCheCard=CheCardId
		s obj.CSSDDSWidth=WidthId
		s obj.CSSDDSDistance=DistanceId
		s obj.CSSDDSTapeTooShort=TapeTooShortId
		s obj.CSSDDSIncompleteClose=IncompleteCloseId
		s obj.CSSDDSSixMarks=SixMarksId
		s obj.CSSDDSVolume=VolumeId
		s obj.CSSDDSWeightInstrus=WeightInstrusId
		s obj.CSSDDSWeightDress=WeightDressId
		s obj.CSSDDSPackDr=PackUserId
		s obj.CSSDDSCheckDr=CheckUserId
		s Sc=obj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-5,"",$ClassName()_":jsSave:保存失败!")
		q:RtnObj.success'=0
	}
	q RtnObj
}

}
