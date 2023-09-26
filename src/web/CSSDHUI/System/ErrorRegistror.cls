/// 错误信息更正后台类
Class web.CSSDHUI.System.ErrorRegistror Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:ban
/// CreatDate:2020-03-30
/// Description:消毒包清洗方式、灭菌方式不正确时，进行的更正登记
/// Table:CSSD_Trans
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.System.ErrorRegistror","SelectAll","{""package"":"""",""gUserId"":""13922"",""gLocId"":""166"",""gGroupId"":""294"",""gHospId"":""2"",""FDate"":""2021-09-10"",""FEndDate"":""2021-09-10""}")
Query SelectAll(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,TransDr,CleanMethodDR,CleanMethodName,CleanUser,CleanUserName,CleanMachineNo,CleanNo,ErrorDate,ErrorTime,PkgDr,PackageName,SterUser,SterUserName,SterNo,SterMachineNo,SterMethodDr,SterMethodName,SSterMethodDr,SSterMethodName,SCleanMethodDr,SCleanMethodName,UpdateUserDr,UpdateUserName,Remark") [ SqlProc ]
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 $$$OK
	s package=PJObj.%Get("package")
	s FDate=PJObj.%Get("FDate")
	s FEndDate=PJObj.%Get("FEndDate")
	s SupLocId=PJObj.%Get("SupLoc")
	q:SupLocId="" $$$OK
	s FDate=..DH2L(FDate)
	s FEndDate=..DH2L(FEndDate)
	s Result=##class(%Library.ResultSet).%New()	
	s SqlStr="SELECT CSSDT_Rowid,CSSDT_Clean_DR, CSSDT_Date,CSSDT_Time, CSSDT_Package_DR, CSSDT_Sterilize_DR,CSSDT_Pack_DR FROM CSSD_Trans where 1=1"
	i package'="" s SqlStr = SqlStr_" and CSSDT_Package_DR = "_package_""
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s (CleanMethodDR,CleanMethodName,CleanUser,CleanMachineNo,CleanNo,CleanDate,CleanTime)=""
		s (PackageName,SterUser,SterUserName,SterNo,SterMachineNo,SterMethodDr,SterMethodName)=""
		s RowId=""	
		s TransDr = Result.Data("CSSDT_Rowid")
		s CleanDr = Result.Data("CSSDT_Clean_DR")
		s ErrorDate = Result.Data("CSSDT_Date")
		s ErrorTime = Result.Data("CSSDT_Time")
		s ErrorTime=..TL2H(ErrorTime)
		s ErrorDate=..DL2H(ErrorDate)
		s TmpCommitDate=""
		s:ErrorDate'="" TmpCommitDate=..DH2L(ErrorDate)
		continue:(ErrorDate="")
		continue:(ErrorDate'="")&((FDate'="")&(FDate>TmpCommitDate))
		continue:(ErrorDate'="")&((FEndDate'="")&(FEndDate<TmpCommitDate))
		s PackDr = Result.Data("CSSDT_Pack_DR")
		s PackObj=##class(User.CSSDPackagePack).%OpenId(PackDr)
		s LocDr=PackObj.CSSDPPLocDr.%Id()
		continue:((SupLocId'="")&&(SupLocId'=LocDr))
		i CleanDr'=""  d
		.s CleanObj=##class(User.CSSDCleanDetailPacks).%OpenId(CleanDr)
		.i $IsObject(CleanObj) d
		..s CleanMainId =CleanObj.CSSDCDPCleanMain.%Id()
		..s CleanMainObj=##class(User.CSSDClean).%OpenId(CleanMainId)
		..i $IsObject(CleanMainObj) d
		...s CleanMachineNo=CleanMainObj.CSSDCMachine.CSSDMCAlias
		...s CleanMethodDR = CleanMainObj.CSSDCCleanMethod.%Id()	//原有清洗方式
		...i CleanMethodDR'=""  d
		....s CleanMethodObj=##class(User.CSSDCleanType).%OpenId(CleanMethodDR)
		....s CleanMethodName = CleanMethodObj.CSSDCTCleanMode
		...s CleanUser = CleanMainObj.CSSDCCleaner.%Id()
		...s:CleanUser'="" CleanUserName=$p($g(^SSU("SSUSR",CleanUser)),"^",2)
		...s CleanNo= CleanMainObj.CSSDCNo
		s PkgDr = Result.Data("CSSDT_Package_DR")
		i PkgDr'=""  d
		.s PackageObj=##class(User.CSSDPackage).%OpenId(PkgDr)
		.s PackageName = PackageObj.CSSDPDesc
		s SterDr=Result.Data("CSSDT_Sterilize_DR")
		i SterDr'=""  d
		.s SterObj=##class(User.CSSDPackageSterilize).%OpenId(SterDr)
		.i $IsObject(SterObj) d
		..s RecordObj = SterObj.CSSDPSParref
		..i $IsObject(RecordObj) d
		...s RecordId = RecordObj.%Id()
		...s SterRecordObj = ##class(User.CSSDSterilizeRecord).%OpenId(RecordId)
		...i $IsObject(SterRecordObj) d
		....s SterUserObj = SterRecordObj.CSSDSRUserDr
		....i $IsObject(SterUserObj) d
		.....s SterUser=SterUserObj.%Id()
		.....s:SterUser'="" SterUserName=$p($g(^SSU("SSUSR",SterUser)),"^",2)
		...s SterNo = SterRecordObj.CSSDSRNo
		...s MachineNoDr=SterRecordObj.CSSDSRMachineNoDR.%Id()
		...s SterMethodDr=$List(^User.CSSDMachineConfigD(MachineNoDr),17)
		...s SterMachineNo=$List(^User.CSSDMachineConfigD(MachineNoDr),10)
		...s SterMethodName=##class(User.CSSDSterType).%OpenId(SterMethodDr).CSSDSTSterName
		s (ErrorRowid,SCleanMethodDr,SCleanMethodName,SSterMethodDr,SSterMethodName,Remark,UpdateUserDr,UpdateUserName)=""
		s ErrorRowid=$o(^User.CSSDErrorRegistrationI("IndexCSSDSRTransDR",TransDr,ErrorRowid))
		i ErrorRowid'=""  d
		.s ErrorObj=##class(User.CSSDErrorRegistration).%OpenId(ErrorRowid)
		.i $IsObject(ErrorObj) d
		..s SSterMethodDr = ErrorObj.CSSDERSSterMethodDr	//更正的灭菌方式
		..s SterMethodObj =##class(User.CSSDSterType).%OpenId(SSterMethodDr)
		..i $IsObject(SterMethodObj) s SSterMethodName=SterMethodObj.CSSDSTSterName
		..s cleanTypeObj = ErrorObj.CSSDERSCleanMethodDr
		..i $IsObject(cleanTypeObj) d
		...s SCleanMethodDr = cleanTypeObj.%Id()	//更正的清洗方式
		...i SCleanMethodDr'=""  d
		....s SCleanMethodObj=##class(User.CSSDCleanType).%OpenId(SCleanMethodDr)
		....i $IsObject(SCleanMethodObj) s SCleanMethodName = SCleanMethodObj.CSSDCTCleanMode
		..s UserObj = ErrorObj.CSSDERUpdateUserDr
		..i $IsObject(UserObj) d
		...s UpdateUserDr = UserObj.%Id()	//更正人
		...s:UpdateUserDr'="" UpdateUserName=$p($g(^SSU("SSUSR",UpdateUserDr)),"^",2)
		..s Remark = ErrorObj.CSSDERRemark	//备注
		..s RowId=ErrorObj.%Id()
		d OutPutRow
 	}
 	d Result.Close()
 Quit $$$OK
OutPutRow
 s Data=$lb(RowId,TransDr,CleanMethodDR,CleanMethodName,CleanUser,CleanUserName,CleanMachineNo,CleanNo,ErrorDate,ErrorTime,PkgDr,PackageName,SterUser,SterUserName,SterNo,SterMachineNo,SterMethodDr,SterMethodName,SSterMethodDr,SSterMethodName,SCleanMethodDr,SCleanMethodName,UpdateUserDr,UpdateUserName,Remark)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// Creator:ban
/// CreatDate:2020-03-30
/// Description:消毒包清洗方式、灭菌方式不正确时，进行的更正登记
/// Table:CSSD_Trans
/// w ##class(web.CSSDHUI.System.ErrorRegistror).jsSave("[{""RowId"":"""",""TransDr"":""290"",""CleanMethodDR"":""2"",""CleanMethodName"":""机器清洗"",""CleanUser"":""10867"",""CleanUserName"":""李丽"",""CleanMachineNo"":""1"",""CleanNo"":""20200526100002"",""ErrorDate"":""2020-05-26"",""ErrorTime"":""10:50:53"",""PkgDr"":""331"",""PackageName"":""气管切开包"",""SterUser"":"""",""SterUserName"":"""",""SterNo"":"""",""SterMachineNo"":"""",""SterMethodDr"":"""",""SterMethodName"":"""",""SSterMethodDr"":"""",""SSterMethodName"":"""",""SCleanMethodDr"":""2"",""SCleanMethodName"":""机器清洗"",""UpdateUserDr"":"""",""UpdateUserName"":"""",""Remark"":""""}]","{""package"":"""",""gUserId"":""11354"",""gLocId"":""316"",""gGroupId"":""103"",""gHospId"":""2"",""FDate"":""2020-05-26""}")
ClassMethod jsSave(Params, Params2) As %Library.String
{
	n (Params,Params2)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s PJObj2=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	s Sc2=PJObj2.%FromJSON(Params2)
	i (Sc'=0||Sc2'=0) d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s UpdateDr=PJObj2.%Get("gUserId")
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId") 
		s TransDr=Obj.%Get("TransDr")
		i TransDr'="" s TransDr=##class(User.CSSDTrans).%OpenId(TransDr) 
		s CleanMethod=Obj.%Get("CleanMethodDR")	//原有清洗方式
		i CleanMethod'="" s CleanMethod=##class(User.CSSDCleanType).%OpenId(CleanMethod)
		
		s CleanUser=Obj.%Get("CleanUser")
		i CleanUser'="" s CleanUser=##class(User.SSUser).%OpenId(CleanUser)
		s CleanMachineNo=Obj.%Get("CleanMachineNo")
		s CleanNo=Obj.%Get("CleanNo")
		s SCleanMethodDr=Obj.%Get("SCleanMethodDr")	//更正的清洗方式
		i SCleanMethodDr'="" s SCleanMethodDr=##class(User.CSSDCleanType).%OpenId(SCleanMethodDr)
		s ErrorDate=Obj.%Get("ErrorDate")
		s ErrorTime=Obj.%Get("ErrorTime")
		s ErrorDate=..DH2L(ErrorDate)
		s PkgDr=Obj.%Get("PkgDr")
		i PkgDr'="" s PkgDr=##class(User.CSSDPackage).%OpenId(PkgDr)
		s SterUser=Obj.%Get("SterUser")
		i SterUser'="" s SterUser=##class(User.SSUser).%OpenId(SterUser)
		s SterNo=Obj.%Get("SterNo")
		s SterMachineNo=Obj.%Get("SterMachineNo")	//灭菌器
		s SSterMethodDr=Obj.%Get("SSterMethodDr")	//更新的灭菌方式
		s SterMethodDr=Obj.%Get("SterMethodDr")	//原有灭菌方式
		i ((SterMethodDr="")&&(SSterMethodDr'="")) d RtnObj.Err(-1,"","未灭菌不能进行灭菌方式修改！")
		q:RtnObj.success'=0
		s UpdateUserDr=UpdateDr	//更正人
		i UpdateUserDr'="" s UpdateUserDr=##class(User.SSUser).%OpenId(UpdateUserDr)
		s Remark=Obj.%Get("Remark")
		i RowId="" d
		.s obj=##class(User.CSSDErrorRegistration).%New()
		e  d
		.s obj=##class(User.CSSDErrorRegistration).%OpenId(RowId)
		.d obj.%Reload()
		s obj.CSSDERCleanNo=CleanNo
		s obj.CSSDERCleanUserDr=CleanUser
		s obj.CSSDERFCleanMethodDr=CleanMethod
		s obj.CSSDERSCleanMethodDr=SCleanMethodDr
		s obj.CSSDSRCleanMachineNo=CleanMachineNo
		s obj.CSSDERFSterMethodDr=SterMethodDr
		s obj.CSSDERSSterMethodDr=SSterMethodDr
		s obj.CSSDERSterNo=SterNo
		s obj.CSSDERSterUserDr=SterUser
		s obj.CSSDSRSterMachineNo=SterMachineNo
		s obj.CSSDERPackageDr=PkgDr
		s obj.CSSDERUpdateUserDr=UpdateUserDr
		s obj.CSSDERRemark=Remark
		;s obj.CSSDSRDate=ErrorDate
		;s obj.CSSDSRTime=ErrorTime
		s obj.CSSDSRTransDR=TransDr
		s Sc=obj.%Save()
		i RowId="" d
		.s RowId=obj.%Id()
		i $$$ISERR(Sc) d RtnObj.Err(-5,"",$ClassName()_"jsSaveMain:保存失败!")
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

}
