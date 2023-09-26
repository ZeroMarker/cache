Import sqluser

/// Creator:ban
/// CreatDate:2020-03-23
/// Description:外来器械登记后台类
/// Table:CSSD_ExtDevBind
Class web.CSSDHUI.CallBack.ForeignPkgRegister Extends (%RegisteredObject, %XML.Adaptor, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:ban
/// CreatDate:2020-03-23
/// Description:外来器械登记查询
/// Table:CSSD_ExtDevBind
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.CallBack.ForeignPkgRegister","GetDeviceRegister","{""MainDr"":""7"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}")
Query GetDeviceRegister(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,NowStatus,Label,InstruCode,InstruDr,InstruName,RecNum,InstruNum,Implants,PowerInstru,FunctionalCheck,SterParameter,SterTemp,BackWash,FirmDr,FirmName,Tel,Receipt,SerMan,RecDate,RecManDr,RecManName,UseDoctor,UseDate,OperatorType,ExtLocDr,ExtLocDesc,SickerName,HospitalNo,PatientSex,PatientAge,BedNo,IsTransfer,TransferDate,Transfer,TransferRec,Remark,HospitalDr,HospitalName") [ SqlProc ]
{
}

ClassMethod GetDeviceRegisterExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (%session,qHandle,Params)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 $$$OK
	
	s PPkgId=PJObj.%Get("package")
	s PStartDate=PJObj.%Get("RecDateValue")
	s PEndDate=PJObj.%Get("RecEndDateValue")
	s PRegNo=PJObj.%Get("RegisterNo")	//登记号
	s PTransRecUserName=PJObj.%Get("TransferRec")
	s POpPlanDr=PJObj.%Get("MainDr")
	s gHospId=PJObj.%Get("gHospId")
	s PStartDate=..DH2L(PStartDate)
	s PEndDate=..DH2L(PEndDate)
	
	s SqlStr = "SELECT CSSDExt_Rowid AS RowId,CSSDExt_Status AS Status,"
		_"CSSDExt_Label as Label,CSSDExt_Code AS CodeDict,CSSDExt_InstruName as PkgId,CSSDExt_InstruName->CSSDP_Desc as PkgDesc,"
		_"CSSDExt_RecNum AS RecNum,CSSDExt_InstruNum AS InstruNum,CSSDExt_Implants AS Implants,CSSDExt_PowerInstru as PowerInstru,CSSDExt_FunctionalCheck AS FuncCheck,"
		_"CSSDExt_SterParameter as SterParameter,CSSDExt_SterTemp as SterTemp,CSSDExt_Backwash as Backwash,"
		_"CSSDExt_Firm as FirmId,CSSDExt_Firm->CSSDVen_Name as FirmName,CSSDExt_Tel as FirmTel,CSSDExt_Receipt as Receipt,CSSDExt_SerMan AS SerUserName,"
		_"CSSDExt_ReciveDate AS RecDate,CSSDExt_ReciveTime AS RecTime,CSSDExt_RecMan as RecUserId,CSSDExt_RecMan->SSUSR_Name as RecUserName,"
		_"CSSDExt_UseDoctor as UseDoctor,CSSDExt_UseDate as UseDate,CSSDExt_OperatorType as OperatorType,CSSDExt_Loc as LocId,CSSDExt_Loc->CTLOC_Desc as LocDesc,"
		_"CSSDExt_SickerName as SickerName,CSSDExt_HospitalNo as HospitalNo,CSSDExt_PatientSex as Sex,CSSDExt_PatientAge as Age,CSSDExt_BedNo as BedNo,"
		_"CSSDExt_IsTransfer AS IsTrans,CSSDExt_TransfersDate AS TransDate,CSSDExt_TransfersTime AS TransTime,CSSDExt_Transfer->SSUSR_Name as TransUserName,CSSDExt_TransferRec AS TransRecUserName,"
		_"CSSDExt_Remark as Remark,CSSDExt_Hospital as HospId,CSSDExt_Hospital->HOSP_Desc as HospDesc "
		_"FROM CSSD_ExtDevBind where CSSDExt_Hospital="_gHospId
	i ((PStartDate'="")&&(PEndDate'="")) s SqlStr = SqlStr_" and CSSDExt_ReciveDate between "_PStartDate_" AND "_PEndDate_" "
	i PPkgId'="" s SqlStr = SqlStr_" and CSSDExt_InstruName = '" _PPkgId_ "'"
	i PRegNo'="" s SqlStr = SqlStr_" and CSSDExt_HospitalNo like '%"_PRegNo_"%'"
	i PTransRecUserName'="" s SqlStr = SqlStr_" and CSSDExt_TransferRec like '%"_PTransRecUserName_"%'"
	i POpPlanDr'="" s SqlStr = SqlStr_" and CSSDExt_OpPlanDr ='"_POpPlanDr_"'"
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s Status = Result.Data("Status")
		s Label = Result.Data("Label")
		s CodeDict = Result.Data("CodeDict")
		s PkgId = Result.Data("PkgId")
		s PkgDesc = Result.Data("PkgDesc")
		
		s RecNum = Result.Data("RecNum")
		s InstruNum = Result.Data("InstruNum")
		s ImplantsNum = Result.Data("Implants")
		s PowerInstru = Result.Data("PowerInstru")
		s FuncCheck = Result.Data("FuncCheck")
		s SterParameter = Result.Data("SterParameter")
		s SterTemp = Result.Data("SterTemp")
		s Backwash = Result.Data("Backwash")
		
		s FirmId = Result.Data("FirmId")
		s FirmName = Result.Data("FirmName")
		s FirmTel = Result.Data("FirmTel")
		s Receipt= Result.Data("Receipt")
		s SerUserName = Result.Data("SerUserName")
		
		s RecDate = Result.Data("RecDate")
		s RecTime = Result.Data("RecTime")
		s RecUserId = Result.Data("RecUserId")
		s RecUserName = Result.Data("RecUserName")
		
		s UseDoctor = Result.Data("UseDoctor")
		s UseDate = Result.Data("UseDate")
		s OperatorType = Result.Data("OperatorType")
		s LocId = Result.Data("LocId")
		s LocDesc = Result.Data("LocDesc")
		
		s SickerName = Result.Data("SickerName")
		s HospitalNo = Result.Data("HospitalNo")
		s Sex = Result.Data("Sex")
		s Age = Result.Data("Age")
		s BedNo = Result.Data("BedNo")
		
		s IsTrans = Result.Data("IsTrans")
		s TransDate = Result.Data("TransDate")
		s TransTime = Result.Data("TransTime")
		s TransUserName = Result.Data("TransUserName")
		s TransRecUserName = Result.Data("TransRecUserName")
		
		s Remark = Result.Data("Remark")
		s HospId = Result.Data("HospId")
		s HospDesc = Result.Data("HospDesc")
		
		s RecDate=..DL2H(RecDate)
		s UseDate=..DL2H(UseDate)
		s TransDate=..DL2H(TransDate)
		s TransTime=..TL2H(TransTime)
		s TransDate=TransDate_" "_TransTime
		i InstruNum="" s InstruNum=##class(web.CSSDHUI.CallBack.ForeignPkgDetail).SumQty(RowId,"N")
		i ImplantsNum="" s ImplantsNum=##class(web.CSSDHUI.CallBack.ForeignPkgDetail).SumQty(RowId,"Y")
		d OutPutPackage
	}
	d Result.Close()
	Quit $$$OK
	
OutPutPackage
	s Data=$lb(RowId,Status,Label,CodeDict,PkgId,PkgDesc,
		RecNum,InstruNum,ImplantsNum,PowerInstru,FuncCheck,SterParameter,SterTemp,Backwash,
		FirmId,FirmName,FirmTel,Receipt,SerUserName,
		RecDate,RecUserId,RecUserName,
		UseDoctor,UseDate,OperatorType,LocId,LocDesc,
		SickerName,HospitalNo,Sex,Age,BedNo,
		IsTrans,TransDate,TransUserName,TransRecUserName,
		Remark,HospId,HospDesc
	)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:ban
/// CreatDate:2020-03-23
/// Description:外来器械登记新增保存
/// Table:CSSD_ExtDevBind
/// w ##class(web.CSSDHUI.CallBack.ForeignPkgRegister).UpdateTransfer("[{""RowId"":""28"",""InstruCode"":""001338001"",""ExtLocDesc"":""呼吸内科门诊"",""ExtLocDr"":""1"",""InstruName"":""刮宫器械11件"",""InstruDr"":""3"",""RecNum"":""23"",""OperatorType"":""2"",""OperatorTypeDesc"":""择期手术"",""RecDate"":""2020-04-21 00:00:00"",""RecManName"":""Demo Group"",""RecManDr"":""1"",""SerMan"":""馨儿"",""Receipt"":""S112121"",""UseDoctor"":""刘菲"",""UseDate"":""2020-04-21"",""SickerName"":""王伟"",""HospitalNo"":""N2212121"",""FirmName"":""上海器械厂商"",""FirmDr"":""1"",""Tel"":""14523678756"",""InstruNum"":""22"",""Implants"":""Y"",""ImplantsDesc"":""是"",""PowerInstru"":""23"",""Rema rk"":""有植入物"",""HospitalName"":""东华标准版数字化医院[总院]"",""HospitalDr"":""2"",""FunctionalCheck"":"""",""PatientSex"":""1"",""PatientSexDesc"":""男""," "PatientAge"":""21"",""BedNo"":""22"",""SterParameter"":"""",""SterTemp"":"""",""BackWash"":"""",""Transfer"":""李丽"",""Label"":""001338001000001"",""TransferRec"":""demo"",""IsTransfer"":""是"",""TransferDate"":""2020-04-21 21:06:39""}]","{""package"":"""",""gUserId"":""11354"",""gLocId"":""316"",""gGroupId"":""103"",""gHospId"":""2"",""RecDateValue"":""2020-04-21"",""RegisterNo"":"""",""Transfer"":""Demo Group"",""TransferDr"":""1"",""TransferRec"":""张去哪""}")
ClassMethod jsUpdateTransfer(Main, Detail) As %Library.String
{
	n (%session,Main,Detail)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s RtnObj=..UpdateTransfer(Main,Detail)
	i RtnObj.success'=0 q RtnObj.Json()
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2020-03-23
/// Description:外来器械登记新增保存
/// Table:CSSD_ExtDevBind
/// w ##class(web.CSSDHUI.CallBack.ForeignPkgRegister).UpdateTransfer("[{""RowId"":""28"",""InstruCode"":""001338001"",""ExtLocDesc"":""呼吸内科门诊"",""ExtLocDr"":""1"",""InstruName"":""刮宫器械11件"",""InstruDr"":""3"",""RecNum"":""23"",""OperatorType"":""2"",""OperatorTypeDesc"":""择期手术"",""RecDate"":""2020-04-21 00:00:00"",""RecManName"":""Demo Group"",""RecManDr"":""1"",""SerMan"":""馨儿"",""Receipt"":""S112121"",""UseDoctor"":""刘菲"",""UseDate"":""2020-04-21"",""SickerName"":""王伟"",""HospitalNo"":""N2212121"",""FirmName"":""上海器械厂商"",""FirmDr"":""1"",""Tel"":""14523678756"",""InstruNum"":""22"",""Implants"":""Y"",""ImplantsDesc"":""是"",""PowerInstru"":""23"",""Rema rk"":""有植入物"",""HospitalName"":""东华标准版数字化医院[总院]"",""HospitalDr"":""2"",""FunctionalCheck"":"""",""PatientSex"":""1"",""PatientSexDesc"":""男""," "PatientAge"":""21"",""BedNo"":""22"",""SterParameter"":"""",""SterTemp"":"""",""BackWash"":"""",""Transfer"":""李丽"",""Label"":""001338001000001"",""TransferRec"":""demo"",""IsTransfer"":""是"",""TransferDate"":""2020-04-21 21:06:39""}]","{""package"":"""",""gUserId"":""11354"",""gLocId"":""316"",""gGroupId"":""103"",""gHospId"":""2"",""RecDateValue"":""2020-04-21"",""RegisterNo"":"""",""Transfer"":""Demo Group"",""TransferDr"":""1"",""TransferRec"":""张去哪""}")
ClassMethod UpdateTransfer(Main, Detail) As web.CSSDHUI.RtnObj
{
	n (%session,Main,Detail)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObjM=##class(web.CSSDHUI.Common.FromJson).%New()
	s PJObjD=##class(web.CSSDHUI.Common.FromJson).%New()
	s ScM=PJObjM.%FromJSON(Main)
	s ScD=PJObjD.%FromJSON(Detail)
	q:(ScM'=0||ScD'=0) RtnObj.Err(-1,"","入参解析失败!")
	
	s TransRecUserName = PJObjM.%Get("TransferRec")
	s gLocId = PJObjM.%Get("gLocId")
	s gUserId = PJObjM.%Get("gUserId")
	s CurDate=$zdt($h,3)
	s NowDate=$p($h,",",1)
	s NowTime=$p($h,",",2)
	
	ts
	while(RtnObj.success=0){
		s Obj=PJObjD.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")	//外来器械登记表ID
		s Label=Obj.%Get("Label")
		continue:RowId=""
		s ExtObj=##class(User.CSSDExtDevBind).%OpenId(RowId)
		d ExtObj.%Reload()
		s IsTransfer=ExtObj.CSSDExtIsTransfer
		s Status=ExtObj.CSSDExtStatus
		i IsTransfer="Y" d RtnObj.Err(-2,"","已经移交!")
		q:RtnObj.success'=0
		
		s StatusName = ##Class(web.CSSDHUI.Common.PackageInfoCommon).GetStatusChinese(Status)
		i ((Status'="SW")&&(Status'="SS")&&(Status'="C")) d RtnObj.Err(-3,"","该器械为"_StatusName_"状态,不能进行移交!")
		q:RtnObj.success'=0
		
		s CleanDetailId="",CleanMainId=""
		i Status="SW" d
		.&sql(SELECT max(ID) into :CleanDetailId FROM CSSD_CleanDetailPacks WHERE CSSDCDP_ExtDR=:RowId)
		.s CleanDetailObj=##class(User.CSSDCleanDetailPacks).%OpenId(CleanDetailId)
		.s CheckFlag=CleanDetailObj.CSSDCDPCleanMain.CSSDCResult
		.s CleanMainId=CleanDetailObj.CSSDCDPCleanMain.%Id()
		.i CheckFlag'=1 d RtnObj.Err(-3,"","未完成清洗，不能移交!")
		q:RtnObj.success'=0
		
		i Status="C" d
		.s CheckUse=..CheckUse(Label)
		.i CheckUse="Y" d RtnObj.Err(-3,"","存在已使用过器械包，必须进行二次清洗或高水平消毒后才能移交！")
		q:RtnObj.success'=0
		
		d ExtObj.CSSDExtTransferSetObjectId(gUserId)
		s ExtObj.CSSDExtTransferRec=TransRecUserName
		s ExtObj.CSSDExtTransferDate=CurDate
		s ExtObj.CSSDExtTransfersDate=NowDate
		s ExtObj.CSSDExtTransfersTime=NowTime
		s ExtObj.CSSDExtIsTransfer="Y"
		s ExtObj.CSSDExtStatus="T" //移交状态
		s Sc=ExtObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-5,"","外来器械移交失败！")
		q:RtnObj.success'=0
		
		i CleanMainId'="" d
		.s RtnObj=##class(web.CSSDHUI.Pack.CleanPackLabel).UpdateCleanIsCreateLbl(CleanMainId)
		q:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj
	tc
	q RtnObj
}

/// Creator:ban
/// CreatDate:2020-03-23
/// Description:外来器械登记删除
/// Table:CSSD_ExtDevBind
/// d ##class(web.CSSDHUI.CallBack.ForeignPkgRegister).DeleteForeignDevice("[{""RowId"":""44"",""InstruCode"":""004020001"",""ExtLocDesc"":"""",""ExtLocDr"":"""",""InstruName"":""全扁桃体摘除标牌追溯包"",""InstruDr"":""246"",""RecNum"":""2"",""OperatorType"":""2"",""OperatorTypeDesc"":""择期手术"",""RecDate"":""2021-01-18"",""RecManName"":""Demo Group"",""RecManDr"":""1"",""SerMan"":""王菲"",""Receipt"":"""",""UseDoctor"":"""",""UseDate"":""2021-01-18"",""SickerName"":"""",""HospitalNo"":""0887318"",""FirmName"":""西安厂家"",""FirmDr"":""1"",""Tel"":""15678672990"",""InstruNum"":""23"",""Implants"":""N"",""ImplantsDesc"":""否"",""PowerInstru"":"""",""Remark"":"""",""HospitalName"":""东华标准版数字化医院[总院]"",""HospitalDr"":""2"",""FunctionalCheck"":"""",""PatientSex"":"""",""PatientSexDesc"":"""",""PatientAge"":"""",""BedNo"":"""",""SterParameter"":"""",""SterTemp"":"""",""BackWash"":"""",""Transfer"":"""",""Label"":"""",""TransferRec"":"""",""IsTransfer"":""否"",""TransferDate"":"" "",""NowStatus"":""B"",""NowStatusDesc"":""登记""}]")
ClassMethod jsDelete(Params As %String) As %Library.String
{
	n (%session,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s sc=PJObj.%FromJSON(Params)
	q:sc'=0 RtnObj.Err(-1,"","入参解析失败!")
	
	ts
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s RtnObj=..DeleteForeignDevice(RowId)
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2020-03-23
/// Description:外来器械登记删除
/// Table:CSSD_ExtDevBind
/// d ##class(web.CSSDHUI.CallBack.ForeignPkgRegister).DeleteForeignDevice("[{""RowId"":""44"",""InstruCode"":""004020001"",""ExtLocDesc"":"""",""ExtLocDr"":"""",""InstruName"":""全扁桃体摘除手术器械包"",""InstruDr"":""246"",""RecNum"":""2"",""OperatorType"":""2"",""OperatorTypeDesc"":""择期手术"",""RecDate"":""2021-01-18"",""RecManName"":""Demo Group"",""RecManDr"":""1"",""SerMan"":""王菲"",""Receipt"":"""",""UseDoctor"":"""",""UseDate"":""2021-01-18"",""SickerName"":"""",""HospitalNo"":""0887318"",""FirmName"":""西安厂家"",""FirmDr"":""1"",""Tel"":""15678672990"",""InstruNum"":""23"",""Implants"":""N"",""ImplantsDesc"":""否"",""PowerInstru"":"""",""Remark"":"""",""HospitalName"":""东华标准版数字化医院[总院]"",""HospitalDr"":""2"",""FunctionalCheck"":"""",""PatientSex"":"""",""PatientSexDesc"":"""",""PatientAge"":"""",""BedNo"":"""",""SterParameter"":"""",""SterTemp"":"""",""BackWash"":"""",""Transfer"":"""",""Label"":"""",""TransferRec"":"""",""IsTransfer"":""否"",""TransferDate"":"" "",""NowStatus"":""B"",""NowStatusDesc"":""登记""}]")
ClassMethod DeleteForeignDevice(RowId As %String) As web.CSSDHUI.RtnObj
{
	n (%session,RowId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	
	s ExtObj = ##class(User.CSSDExtDevBind).%OpenId(RowId)
	q:'$IsObject(ExtObj) RtnObj.Err(-1,"","已删除")
	
	s Status=ExtObj.CSSDExtStatus
	q:(Status'="B") RtnObj.Err(-1,"","非登记状态，不能删除")
	
	&sql(Delete from CSSD_ExtDevBind where CSSDExt_Rowid=:RowId)
	q:SQLCODE<0 RtnObj.Err(-2,"","外来器械登记删除失败")
	
	q RtnObj
}

/// Creator:ban
/// CreatDate:2021-03-20
/// Description:根据登记号获取患者信息
/// Table:CSSD_ExtDevBind
/// w ##class(web.CSSDHUI.CallBack.ForeignPkgRegister).GetAdmListByHospitalNo("{""PatNo"":""0000000014"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}")
ClassMethod GetAdmListByHospitalNo(Params) As %Library.String
{
	n (%session,Params)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 "{}"
	
	s PatNo=PJObj.%Get("PatNo")
	s gHospId=PJObj.%Get("gHospId")
	q:PatNo="" "{}"
	
	s PatMasId="",MasId=0
	f  s MasId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatNo),MasId)) q:(MasId="")||(PatMasId'="")  d
	.s AdmId=$o(^PAPERdr(MasId,"ADM","I",""),-1)
	.q:AdmId=""
	.s LocId=$p($g(^PAADM(AdmId)),"^",4)
	.s LocHospId=..sssHospId(LocId)
	.q:gHospId'=LocHospId
	.s PatMasId=MasId
	q:+PatMasId=0 "{}"
	
	s IPNo=$p(^PAPER(PatMasId,"PAT",1),"^",1)		;登记号
	s Medicare=$p(^PAPER(PatMasId,"PAT",1),"^",22)  ;患者住院号
	s PatName=$p(^PAPER(PatMasId,"ALL"),"^",1)
	s Dob=$p($g(^PAPER(PatMasId,"ALL")),"^",6)		;出生日期
	s SexId=$p(^PAPER(PatMasId,"ALL"),"^",7)		;PA_Person
	s Tel=$p(^PAPER(PatMasId,"PER",1),"^",11)		;电话号码
	s Sex=""
	s:SexId'="" Sex=$p(^CT("SEX",SexId),"^",2)
	s Age=$p($zd(+$h,3),"-",1)-$p($zd(Dob,3),"-",1)
	s NowMonth=$p($zd(+$h,3),"-",2)
	s NowDay=$p($zd(+$h,3),"-",3)
	s DobMonth=$p($zd(Dob,3),"-",2)
	s DobDay=$p($zd(Dob,3),"-",3)
	s:(DobMonth>NowMonth)||((DobMonth=NowMonth)&&(DobDay>NowDay)) Age=Age-1
	s PaAdmId=$o(^PAPERdr(PatMasId,"ADM","I",""),-1)
	s (DeptId,WardId,BedId,WardCode,WardDesc,BedNo)=""
	i PaAdmId'="" d
	.s DeptId=$p($g(^PAADM(PaAdmId)),"^",4)
	.s WardId=$p($g(^PAADM(PaAdmId)),"^",70)
	.s BedId=$p($g(^PAADM(PaAdmId)),"^",73)
	
	i WardId'="" d
	.s WardCode=$p(^PAWARD(WardId),"^",1)
	.s WardDesc=$p(^PAWARD(WardId),"^",2)
	i BedId'="" s BedNo=$p($g(^PAWARD(+BedId,"BED",$p(BedId,"||",2))),"^",1)
	i DeptId'="" s DeptDesc=$p(^CTLOC(DeptId),"^",2)
	
	s DataStr=PatNo_"^"_PatName_"^"_Age_"^"_SexId_"^"_Sex_"^"_BedNo
		_"^"_WardCode_"^"_WardDesc_"^"_DeptId_"^"_DeptDesc_"^"_Medicare
		_"^"_Tel
	s TitleStr="PatNo^PatName^Age^SexId^Sex^BedNo"
		_"^WardCode^WardDesc^DeptId^DeptDesc^Medicare"
		_"^Tel"
	s JsonStr=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(DataStr,TitleStr)
	q JsonStr
}

/// Description：获取外来器械信息
/// Creator：lxt
/// CreateDate：20220531
/// w ##class(web.CSSDHUI.CallBack.ForeignPkgRegister).GetExtInfo("{""Label"":""106507001"",""RecDate"":""2023-01-10"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}")
ClassMethod GetExtInfo(Params)
{
	n (%session,Params)
	s ErrTitle="Err"
	s Err="",RetJson=""
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 s Err="参数解析失败！"
	q:Err'="" ##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Err,ErrTitle)
	
	s gHospId=PJObj.%Get("gHospId")
	s gLocId=PJObj.%Get("gLocId")
	s gUserId=PJObj.%Get("gUserId")
	s gGroupId=PJObj.%Get("gGroupId")
	s CodeDict=PJObj.%Get("Label")
	s RecDate=PJObj.%Get("RecDate")
	s RecDate=..DH2L(RecDate)
	i CodeDict="" s Err="标牌不能为空！"
	q:Err'="" ##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Err,ErrTitle)
	
	s RtnObj=##class(web.CSSDHUI.CallBack.ForeignPkgDetail).CheckExtFlag(CodeDict)
	i RtnObj.success'=0 s Err=RtnObj.msg
	q:Err'="" ##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Err,ErrTitle)
	
	s PackageInfo=##class(web.CSSDHUI.Common.PackageInfoCommon).GetPkgInfoByCodeDict(CodeDict)
	s PackTypeDetail=$p(PackageInfo,"^",2)
	s CodeDictId=$p(PackageInfo,"^",4)
	
	s CodeDictInfo=##class(User.CSSDCodeDict).%OpenId(CodeDictId)
	s CodeDictName=CodeDictInfo.CSSDCDPackName
	s PackageId=CodeDictInfo.CSSDCDPackDRGetObjectId()
	s PackageObj=##class(User.CSSDPackage).%OpenId(PackageId)
	s PackageClassId=PackageObj.CSSDPPackClassGetObjectId()
	s Firm=PackageObj.CSSDPZCompanyGetObjectId()
	
	s (FirmDesc,Tel,SerMan)=""
	i Firm'="" d
	.s FirmObj=##class(User.CSSDVen).%OpenId(Firm)
	.s FirmDesc=FirmObj.CSSDVenName
	.s Tel=FirmObj.CSSDVenTelephone
	.s SerMan=FirmObj.CSSDVenSaleManName
	
	s Data=PackageId_"^"_CodeDictId_"^"_CodeDictName_"^"_CodeDict_"^"_Firm_"^"_FirmDesc_"^"_Tel_"^"_SerMan
	s Title="PackageId^CodeDictId^CodeDictName^CodeDict^Firm^FirmDesc^Tel^SerMan"

	s RetJson=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q RetJson
}

/// Creator:lxt
/// CreatDate:20220628
/// Description:外来器械登记批量保存
/// Table:CSSD_ExtDevBind
/// w ##class(web.CSSDHUI.CallBack.ForeignPkgRegister).jsBatchSave(^templxt("jsBatchSave1"),^templxt("jsBatchSave2"))
ClassMethod jsBatchSave(Main, Details) As %Library.String
{
	n (%session,Main,Details)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..BatchSave(Main,Details)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

ClassMethod BatchSave(Main, Details) As %Library.String
{
	n (%session,Main,Details)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s MPJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=MPJObj.%FromJSON(Main)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")
	
	s DPJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=DPJObj.%FromJSON(Details)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")
	
	while(RtnObj.success=0){
		s Obj=DPJObj.%Pop()
		q:Obj=""
		s ObjJson=Obj.%ToJSON()
		s RtnObj=##class(web.CSSDHUI.CallBack.ForeignPkgDetail).Save(ObjJson,Main)
		q:RtnObj.success'=0
	}
	
	q RtnObj
}

/// w ##class(web.CSSDHUI.CallBack.ForeignPkgRegister).Select(1)
ClassMethod Select(RowId As %String) As %String
{
	n (%session,RowId)
	q:+RowId=0 ""

	s (ExtRowId,ExtState,ExtInstruCodeId,ExtInstruCodeDesc,ExtInstruId,ExtInstruName,
		ExtRecNum,ExtPowerInstru,ExtFunctionalCheck,
		ExtFirmId,ExtFirmDesc,ExtTel,ExtReceipt,ExtSerMan,
		ExtRecDate,ExtRecManDr,ExtRecManName,
		ExtUseDoctor,ExtUseDate,ExtOperatorType,ExtPatientLocId,ExtPatientLocDesc,
		ExtSickerName,ExtHospitalNo,ExtPatientSexId,ExtPatientSexDesc,ExtPatientAge,ExtBedNo,
		ExtRemark)=""
	&sql(SELECT CSSDExt_Rowid,CSSDExt_Status,
		CSSDExt_Code,CSSDExt_InstruName,CSSDExt_InstruName->CSSDP_Desc,
		CSSDExt_RecNum,CSSDExt_PowerInstru,CSSDExt_FunctionalCheck,
		CSSDExt_Firm,CSSDExt_Firm->CSSDVen_Name,CSSDExt_Tel,CSSDExt_Receipt,CSSDExt_SerMan,
		CSSDExt_ReciveDate,CSSDExt_RecMan,CSSDExt_RecMan->SSUSR_Name,
		CSSDExt_UseDoctor,CSSDExt_UseDate,CSSDExt_OperatorType,CSSDExt_Loc,CSSDExt_Loc->CTLOC_Desc,
		CSSDExt_SickerName,CSSDExt_HospitalNo,CSSDExt_PatientSex,CSSDExt_PatientAge,CSSDExt_BedNo,
		CSSDExt_Remark 
		into :ExtRowId,:ExtState,
		:ExtInstruCodeId,:ExtInstruId,:ExtInstruName,
		:ExtRecNum,:ExtPowerInstru,:ExtFunctionalCheck,
		:ExtFirmId,:ExtFirmDesc,:ExtTel,:ExtReceipt,:ExtSerMan,
		:ExtRecDate,:ExtRecManDr,:ExtRecManName,
		:ExtUseDoctor,:ExtUseDate,:ExtOperatorType,:ExtPatientLocId,:ExtPatientLocDesc,
		:ExtSickerName,:ExtHospitalNo,:ExtPatientSexId,:ExtPatientAge,:ExtBedNo,
		:ExtRemark
		from CSSD_ExtDevBind where CSSDExt_Rowid=:RowId)
		
	s ExtInstruCodeDesc="",ExtOperatorTypeDesc="",ExtFunctionalCheckDesc="",ExtPatientSexDesc=""
	s ExtInstruCodeDesc=##class(web.CSSDHUI.Common.PackageInfoCommon).GetCodeDictName(ExtInstruCodeId)
	i ExtOperatorType=1 s ExtOperatorTypeDesc="急诊手术"
	e  i ExtOperatorType=0 s ExtOperatorTypeDesc="择期手术"
	i ExtFunctionalCheck=1 s ExtFunctionalCheckDesc="完好"
	e  i ExtFunctionalCheck=2 s ExtFunctionalCheckDesc="异常"
	i ExtPatientSexId=1 s ExtPatientSexDesc="男"
	e  i ExtPatientSexId=2 s ExtPatientSexDesc="女"
	
	s ExtInstruCode=##class(web.CSSDHUI.Common.UtilCommon).ComboStr(ExtInstruCodeId,ExtInstruCodeDesc)
	s ExtInstruName=##class(web.CSSDHUI.Common.UtilCommon).ComboStr(ExtInstruId,ExtInstruName)
	s ExtRecManDr=##class(web.CSSDHUI.Common.UtilCommon).ComboStr(ExtRecManDr,ExtRecManName)
	s ExtPatientLoc=##class(web.CSSDHUI.Common.UtilCommon).ComboStr(ExtPatientLocId,ExtPatientLocDesc)
	s ExtFirm=##class(web.CSSDHUI.Common.UtilCommon).ComboStr(ExtFirmId,ExtFirmDesc)
	
	s ExtOperatorType=##class(web.CSSDHUI.Common.UtilCommon).ComboStr(ExtOperatorType,ExtOperatorTypeDesc)
	s ExtFunctionalCheck=##class(web.CSSDHUI.Common.UtilCommon).ComboStr(ExtFunctionalCheck,ExtFunctionalCheckDesc)
	s ExtPatientSex=##class(web.CSSDHUI.Common.UtilCommon).ComboStr(ExtPatientSexId,ExtPatientSexDesc)
	s ExtRecDate=..DL2H(ExtRecDate)
	s ExtUseDate=..DL2H(ExtUseDate)
	
	s Data=ExtRowId_"^"_ExtState_"^"_ExtInstruCode_"^"_ExtInstruId_"^"_ExtInstruName
		_"^"_ExtRecNum_"^"_ExtPowerInstru_"^"_ExtFunctionalCheck
		_"^"_ExtFirm_"^"_ExtTel_"^"_ExtReceipt_"^"_ExtSerMan
		_"^"_ExtRecDate_"^"_ExtRecManDr
		_"^"_ExtUseDoctor_"^"_ExtUseDate_"^"_ExtOperatorType_"^"_ExtPatientLoc
		_"^"_ExtSickerName_"^"_ExtHospitalNo_"^"_ExtPatientSex_"^"_ExtPatientAge_"^"_ExtBedNo
		_"^"_ExtRemark

	s Title="ExtRowId^ExtState^ExtInstruCode^ExtInstruId^ExtInstruName"
		_"^ExtRecNum^ExtPowerInstru^ExtFunctionalCheck"
		_"^ExtFirm^ExtTel^ExtReceipt^ExtSerMan"
		_"^ExtRecDate^ExtRecManDr"
		_"^ExtUseDoctor^ExtUseDate^ExtOperatorType^ExtPatientLoc"
		_"^ExtSickerName^ExtHospitalNo^ExtPatientSex^ExtPatientAge^ExtBedNo"
		_"^ExtRemark"

	s Rtn=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Rtn
}

/// Creator:ban
/// CreatDate:2022.10.18
/// Description:手术排班与外来器械进行患者绑定
/// Table:CSSD_ExtDevBind\CSSD_ExtCallBackLabel
/// d ##class(web.CSSDHUI.CallBack.ForeignPkgRegister).jsBindBarCode("{""RowId"":""4"",""PatName"":""zfmcs0707"",""PatGender"":""女"",""PatAge"":""34岁"",""RegNo"":""0000000001"",""MedcareNo"":""100001"",""PatientID"":""2"",""SourceTypeDesc"":""急诊"",""StatusDesc"":""完成"",""OperDate"":""2020-07-07"",""RoomDesc"":""手术间01"",""RoomCode"":""001"",""OperDeptID"":""144"",""OperDeptDesc"":""手术室"",""OperDesc"":""头部血管治疗性超声"",""HivStatus"":""未知"",""HbsStatus"":""未知"",""HcvStatus"":""未知"",""SypStatus"":""未知"",""PatDeptID"":""113"",""PatDeptDesc"":""内分泌科"",""SourceType"":""E""}","{""barCode"":""105021004"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}")
ClassMethod jsBindBarCode(Params As %String, ParamsTB As %String) As %Library.String
{
	n (Params,ParamsTB,%session)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..BindBarCode(Params,ParamsTB)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// 手术排班与外来器械进行患者绑定
ClassMethod BindBarCode(Params As %String, ParamsTB As %String) As web.CSSDHUI.RtnObj
{
	n (Params,ParamsTB,%session)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i ((ParamsTB="")||(Params="")) d RtnObj.Err(-1,"","入参不能为空!")
	q:RtnObj.success'=0 RtnObj
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s PJObjTB=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	s ScTB=PJObjTB.%FromJSON(ParamsTB)
	i ((Sc'=0)||(ScTB'=0)) d RtnObj.Err(-2,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	
	s NowDate=$p($h,",",1)
	s NowDate=..DL2H(NowDate)
	s barCode=PJObjTB.%Get("barCode")
	s gUserId = PJObjTB.%Get("gUserId")
	s gHospId = PJObjTB.%Get("gHospId")
	s gLocId=PJObjTB.%Get("gLocId")
	s gGroupId=PJObjTB.%Get("gGroupId")
	
	s OprScheduleId=PJObj.%Get("RowId")
	s SourceType=PJObj.%Get("SourceType")
	s SourceTypeDesc=PJObj.%Get("SourceTypeDesc")	//E:急诊  其他：择期
	s RegNo=PJObj.%Get("RegNo")	//患者登记号
	s OperDate=PJObj.%Get("OperDate")
	s OperDate=..DH2L(OperDate)
	s RoomDesc=PJObj.%Get("RoomDesc")
	s RoomCode=PJObj.%Get("RoomCode")
	s MedcareNo=PJObj.%Get("MedcareNo")
	s PatName=PJObj.%Get("PatName")
	s BedNo=PJObj.%Get("BedNo")
	s PatGender=PJObj.%Get("PatGender")
	s PatAge=PJObj.%Get("PatAge")
	s OperDeptDesc=PJObj.%Get("OperDeptDesc")
	s PatDeptDesc=PJObj.%Get("PatDeptDesc")
	s OperDeptID=PJObj.%Get("OperDeptID")
	s PatDeptID=PJObj.%Get("PatDeptID")
	s OperDesc=PJObj.%Get("OperDesc")	//手术名称
	s HivStatus=PJObj.%Get("HivStatus")	//艾滋
	s SypStatus=PJObj.%Get("SypStatus")	//梅毒
	s HbsStatus=PJObj.%Get("HbsStatus")	//乙肝
	s HcvStatus=PJObj.%Get("HcvStatus")	//丙肝
	s DoctorName=""
	s Sex=0
	i PatGender="男" s Sex=1
	e  i PatGender="女" s Sex=2
	s OperatorType=2
	i SourceType="E" s OperatorType=1
	
	s (CodeDictId,PackTypeDetail)=""
	s PackageInfo=##class(web.CSSDHUI.Common.PackageInfoCommon).GetPkgInfoByCodeDict(barCode)
	s PackTypeDetail=$p(PackageInfo,"^",2)
	s CodeDictId=$p(PackageInfo,"^",4)
	q:CodeDictId="" RtnObj.Err(-2,"","标牌不存在")
	
	s CodeDictInfo=##class(User.CSSDCodeDict).%OpenId(CodeDictId)
	d CodeDictInfo.%Reload()
	s PkgDr=CodeDictInfo.CSSDCDPackDRGetObjectId()
	s PackageObj=##class(User.CSSDPackage).%OpenId(PkgDr)
	s Firm=PackageObj.CSSDPZCompanyGetObjectId()
	s (FirmDesc,Tel,SerMan)=""
	i Firm'="" d
	.s FirmObj=##class(User.CSSDVen).%OpenId(Firm)
	.s FirmDesc=FirmObj.CSSDVenName
	.s Tel=FirmObj.CSSDVenTelephone
	.s SerMan=FirmObj.CSSDVenSaleManName
	
	s (RowId,FunctionalCheckId,Receipt,PowerInstru)=""
	s (Remark,SterParameter,SterTemp,BackWash,InstruNum,ImplantsNum)=""
	
	s Data1=RowId_"^"_PkgDr_"^"_barCode_"^"_OperDeptID_"^"_Firm_"^"_OperatorType_"^"_FunctionalCheckId
	s Data2=PatAge_"^"_BedNo_"^"_1_"^"_NowDate_"^"_gUserId_"^"_SerMan_"^"_Receipt_"^"_DoctorName
	s Data3=OperDate_"^"_PatName_"^"_RegNo_"^"_Tel_"^"_PowerInstru_"^"_Remark_"^"_SterParameter_"^"_SterTemp
	s Data4=BackWash_"^"_Sex_"^"_InstruNum_"^"_ImplantsNum_"^"_OprScheduleId
	s Data=Data1_"^"_Data2_"^"_Data3_"^"_Data4
	s Title1="ExtRowId^ExtInstruName^ExtInstruCode^ExtPatientLoc^ExtFirm^ExtOperatorType^ExtFunctionalCheck"
	s Title2="ExtPatientAge^ExtBedNo^ExtRecNum^ExtRecDate^ExtRecManDr^ExtSerMan^ExtReceipt^ExtUseDoctor"
	s Title3="ExtUseDate^ExtSickerName^ExtHospitalNo^ExtTel^ExtPowerInstru^ExtRemark^ExtSterParameter^ExtSterTemp"
	s Title4="ExtBackWash^ExtPatientSex^ExtInstruNum^ExtImplantsNum^OprScheduleId"
	s Title=Title1_"^"_Title2_"^"_Title3_"^"_Title4
	s Detail=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	s RtnObj=##class(web.CSSDHUI.CallBack.ForeignPkgDetail).Save(Detail,ParamsTB)
	
	q RtnObj
}

/// 判断消毒包是否存在可用标牌
ClassMethod ExistCodeDict(PkgId As %String, Details = "") As %Library.String
{
	n (PkgId,Details,%session)
	q:PkgId="" 0
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	
	s:Details'="" Details=","_Details_","
	s Ret="",Count=0
	s CodeDictId=0
	f  s CodeDictId=$o(^User.CSSDCodeDictI("PACKDR",PkgId,CodeDictId)) q:(CodeDictId="")  d
	.s CodeDictObj=##class(User.CSSDCodeDict).%OpenId(CodeDictId)
	.s CodeDict=CodeDictObj.CSSDCDCode
	.s UseFlag=CodeDictObj.CSSDCDNotUseFlag
	.q:UseFlag'="Y"
	.s RtnObj=##class(web.CSSDHUI.CallBack.ForeignPkgDetail).CheckExtFlag(CodeDict)
	.q:RtnObj.success'=0
	.s TmpCodeDict=","_CodeDict_","
	.q:(Details'="")&&(Details[TmpCodeDict)
	.s Count=Count+1
	.i Ret="" s Ret=CodeDict
	.e  s Ret=Ret_","_CodeDict
	
	q:Count=0 0
	
	q Ret
}

/// Creator:why
/// Date:2019-08-20
/// Description: codedict
/// Input:  StkGrpId
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.CallBack.ForeignPkgRegister","GetExistCodeDict","2225")
Query GetExistCodeDict(PkgDr As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetExistCodeDictExecute(ByRef qHandle As %Binary, PkgDr As %String) As %Status
{
	n (qHandle,PkgDr,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s Ret=..ExistCodeDict(PkgDr)
	q:Ret=0 $$$OK
	
	s Len=$l(Ret,",")
	
	f i=1:1:Len d
	.s CodeDict=$p(Ret,",",i)
	.s CodeDictId=$o(^User.CSSDCodeDictI("CSSDCDCodeIndex",CodeDict,0))
	.q:CodeDictId=""
	.s CodeDictObj=##class(User.CSSDCodeDict).%OpenId(CodeDictId)
	.s Description=CodeDictObj.CSSDCDPackName
	.d OutPutCodeDict
	Quit $$$OK
	
OutPutCodeDict
	s Data=$lb(CodeDict,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 依据NewLabelStr判断对应标签是否使用登记过
ClassMethod CheckUse(NewLabelStr) As %String
{
	n (NewLabelStr)
	
	s Ret="N"		//存在已使用
	s Len=$l(NewLabelStr,",")
	
	f i=1:1:Len q:Ret="Y"  d
	.s NewLabel=$p(NewLabelStr,",",i)
	.q:NewLabel=""
	.s PackId=0
	.f  s PackId=$o(^User.CSSDPackagePackI("CSSDPPNewLabelIndex",NewLabel,PackId)) q:(PackId="")||(Ret="Y")  d
	..s PackObj=##class(User.CSSDPackagePack).%OpenId(PackId)
	..s Label=PackObj.CSSDPPLabel
	..s TransOPId=$o(^User.CSSDTransOPI("CSSDTOPLabelIndex",Label,""))
	..i TransOPId'="" s Ret="Y"
	.
	q Ret
}

}
