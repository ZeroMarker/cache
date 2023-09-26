Import sqluser

/// wfg
Class web.CSSDHUI.PackageSterilize.Sterilize Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:
/// CreatDate:2019.5.7
/// Description:判断灭菌器是否需要测漏
/// Table:CSSD_MachineConfig,CSSD_SterilizeRecord
/// Input:Params 灭菌主表信息
/// Output:
/// Return:日志信息
/// w ##class(web.CSSDHUI.PackageSterilize.Sterilize).IfLeak(^tmpmy("sss")).Json()
ClassMethod IfLeak(MachineId, LeakTime) As web.CSSDHUI.RtnObj
{
	n (%session,MachineId,LeakTime)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s CurDate=+$h

	s LeakRowId=$o(^User.CSSDSterilizeRecordI("IndexMachineNoDRDateLeak",MachineId,CurDate,1,""),-1)
	i (LeakRowId="")&&(LeakTime="1") d
	.d RtnObj.Err(-1,"","该灭菌器当天首次使用需要进行测漏！")
	e  i (LeakRowId="") d
	.s LastDate=""
	.s SterDate=CurDate+1
	.f  s SterDate=$o(^User.CSSDSterilizeRecordI("IndexCSSDSRMachineNoDate",MachineId,SterDate),-1) q:(SterDate="")||(LastDate'="")  d
	..s SterId=""
	..f  s SterId=$o(^User.CSSDSterilizeRecordI("IndexCSSDSRMachineNoDate",MachineId,SterDate,SterId),-1) q:(SterId="")||(LastDate'="")  d
	...s SterLeakFlag=$lg(^User.CSSDSterilizeRecordD(SterId),45)
	...s SterIsChk=$lg(^User.CSSDSterilizeRecordD(SterId),27)
	...i (SterLeakFlag=1)&&(SterIsChk=1) s LastDate=SterDate
	.s DifDate=CurDate-LastDate
	.i (LeakTime="2")&&(DifDate>=7) d RtnObj.Err(-1,"","该灭菌器每周需要进行测漏！") q
	.i (LeakTime="3")&&(DifDate>=30) d RtnObj.Err(-1,"","该灭菌器每月需要进行测漏！") q
	e  i LeakRowId'="" d
	.s IsCheck=$lg(^User.CSSDSterilizeRecordD(LeakRowId),27)
	.i IsCheck="" d RtnObj.Err(-3,"","请将测漏记录验收合格")
	.i IsCheck=2 d RtnObj.Err(-3,"","该灭菌器测漏记录验收不合格，请重新测漏！")
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Creator:
/// CreatDate:2019.5.7
/// Description:判断灭菌器是否需要BD
/// Table:CSSD_MachineConfig,CSSD_SterilizeRecord
/// Input:Params 灭菌主表信息
/// Output:
/// Return:日志信息
/// w ##class(web.CSSDHUI.PackageSterilize.Sterilize).IfBD(^tmpmy("sss"))
ClassMethod IfBD(MachineId, ParamsStr) As web.CSSDHUI.RtnObj
{
	n (%session,MachineId,ParamsStr)
	
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s CurDate=+$h
	s CurTime=$p($h,",",2)
	s BDTime=##Class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDSTERILIZE","BDTime",ParamsStr)
	s:BDTime="" BDTime="00:00:00"
	s BDTime=..TH2L(BDTime)
	s SterMainId=$o(^User.CSSDSterilizeRecordI("IndexMachineNoDRDateBD",MachineId,CurDate,1,""),-1)
	i SterMainId'="" d
	.s SterTime=$lg(^User.CSSDSterilizeRecordD(SterMainId),8)
	.i (SterTime<BDTime)&&(CurTime>BDTime) d RtnObj.Err(-1,"","每天第一次灭菌需要进行BD测试!")
	.q:RtnObj.success'=0
	e  d
	.s YesterDay=CurDate-1
	.s SterMainId=$o(^User.CSSDSterilizeRecordI("IndexMachineNoDRDateBD",MachineId,YesterDay,1,""),-1)
	.i SterMainId="" d RtnObj.Err(-2,"","每天第一次灭菌需要进行BD测试!")
	.e  d
	..s YesterDayTime=$lg(^User.CSSDSterilizeRecordD(SterMainId),8)
	..i CurTime>BDTime d
	...d RtnObj.Err(-3,"","每天第一次灭菌需要进行BD测试!")
	..e  d
	...i YesterDayTime<=BDTime d RtnObj.Err(-4,"","每天第一次灭菌需要进行BD测试!")
	..q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj
	
	i SterMainId'="" d
	.s IsCheck=$lg(^User.CSSDSterilizeRecordD(SterMainId),27)
	.i IsCheck="" d RtnObj.Err(-5,"","请将BD测试记录验收合格")
	.i IsCheck=2 d RtnObj.Err(-6,"","该灭菌器BD测试记录验收不合格，请重新BD测试！")
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Creator:ban
/// CreatDate:2023.3.14
/// Description:测漏和BD的时候，如果存在已验收合格的记录，再次BD或测漏时需要Confirm确认
/// Table:CSSD_SterilizeRecord
/// Input: MachineId:机器ID Type:Confirm类型
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.PackageSterilize.Sterilize).ConfirmLeakOrBD("1","Leak")
ClassMethod ConfirmLeakOrBD(MachineId As %String, Type As %String)
{
	n (%session,MachineId,Type)
	q:MachineId="" "{}"
	
	s Message="",Ret=""
	s CurDate=+$h
	i Type="BD" d
	.s SterMainId=$o(^User.CSSDSterilizeRecordI("IndexMachineNoDRDateBD",MachineId,CurDate,1,""),-1)
	.i SterMainId'="" d
	..s IsCheck=$lg(^User.CSSDSterilizeRecordD(SterMainId),27)
	..i IsCheck=1 d
	...s Message="该灭菌器BD测试记录已验收合格，是否继续BD测试？"
	...s Ret="Y"
	e  i Type="Leak" d
	.s LeakRowId=$o(^User.CSSDSterilizeRecordI("IndexMachineNoDRDateLeak",MachineId,CurDate,1,""),-1)
	.i LeakRowId'="" d
	..s IsCheck=$lg(^User.CSSDSterilizeRecordD(LeakRowId),27)
	..i IsCheck=1 d
	...s Message="该灭菌器测漏记录已验收合格，是否继续测漏？"
	...s Ret="Y"
	s Data = Ret_"^"_Message
	s Title="Ret^Message"
	s CleanTypeStr=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q CleanTypeStr
}

/// Creator:
/// CreatDate:2019.5.7
/// Description:生成灭菌单时将灭菌架上面的包同时添加进来
/// Table:cssd_sterilizecardetail
/// Input:sterMain：灭菌主表id carBarCode：标签条码
/// Output:
/// Return:日志信息
/// w ##class(web.CSSDHUI.PackageSterilize.Sterilize).SaveSterCarPKg(257,"002002001")
ClassMethod SaveSterCarPKg(SterMainId As %String, CarLabelId As %String) As web.CSSDHUI.RtnObj
{
	n (%session,SterMainId,CarLabelId)
	
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i (SterMainId="")||(CarLabelId="") q RtnObj.Err(-2,"","参数不能为空!")
	
	s CarItmId=""
	f  s CarItmId=$o(^User.CSSDSterilizeCarDetailI("IndexCarLabel",CarLabelId,CarItmId)) q:((CarItmId="")||(RtnObj.success<0))  d
	.s CarItmObj=##class(User.CSSDSterilizeCarDetail).%OpenId(CarItmId)
	.d CarItmObj.%Reload()
	.s Label=CarItmObj.CSSDSCDPkgLabel
	.s PkgId=CarItmObj.CSSDSCDPkgDrGetObjectId()
	.s Qty=CarItmObj.CSSDSCDPkgNum
	.s SterItmObj=##class(User.CSSDPackageSterilize).%New()
	.s SterItmObj.CSSDPSLabel=Label
	.d SterItmObj.CSSDPSPackageSetObjectId(PkgId)
	.d SterItmObj.CSSDPSParrefSetObjectId(SterMainId)
	.s SterItmObj.CSSDPSQty=Qty
	.s SterItmObj.CSSDPSSerialNo=1
	.s Sc=SterItmObj.%Save()
	.i $$$ISERR(Sc) d RtnObj.Err(-1,"","保存灭菌架内消毒包失败!")
	.q:RtnObj.success'=0
	.&sql(update cssd_packagepack set CSSDPP_IsLoadSteCar=1 where CSSDPP_Label=:Label)
	.i SQLCODE'=0 d RtnObj.Err(-2,"","更新消毒包已装载状态失败!")
	.&sql(delete from cssd_sterilizecardetail where CSSDSCD_PkgLabel=:Label)
	.i SQLCODE'=0 d RtnObj.Err(-2,"","删除灭菌架内消毒包失败!")
	.q:RtnObj.success'=0
	
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Creator:
/// CreatDate:2019.5.7
/// Description:新增时保存灭菌主表信息
/// Table:CSSD_MachineConfig,CSSD_SterilizeRecord
/// Input:Params 灭菌主表信息
/// Output:
/// Return:日志信息
/// w ##class(web.CSSDHUI.PackageSterilize.Sterilize).jsSave(^tmpsjasjkajsksj)
ClassMethod jsSave(Params) As %Library.String
{
	n (%session,Params)
	s $ZT=..sssError()
	ts
	s RtnObj=..Save(Params)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:
/// CreatDate:2019.5.7
/// Description:新增时保存灭菌主表信息
/// Table:CSSD_MachineConfig,CSSD_SterilizeRecord
/// Input:Params 灭菌主表信息
/// Output:
/// Return:日志信息
/// w ##class(web.CSSDHUI.PackageSterilize.Sterilize).Save(^tmpmy("sss"))
ClassMethod Save(Params) As %Library.String
{
	n (%session,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"",..%Translate($CLASSNAME(),"入参解析失败!"))
	q:RtnObj.success'=0 RtnObj
	
	s PMachineId=PJObj.%Get("MachineNoValue")
	s PSterLocId = PJObj.%Get("SterLocId")
	s RowId=PJObj.%Get("RowId")
	s PSterUserId=PJObj.%Get("SterUserValue")
	s PSterCarCode=PJObj.%Get("SterCarValue")
	s PSterProId=PJObj.%Get("SterProValue")
	s PSterTime=PJObj.%Get("SterTime")
	s gHospId = PJObj.%Get("gHospId")
	s gGroupId = PJObj.%Get("gGroupId")
	s gUserId = PJObj.%Get("gUserId")
	s:PSterUserId="" PSterUserId=gUserId
	
	s CurDate=$p($h,",",1)
	s CurTime=$p($h,",",2)
	i PSterTime'="" s CurTime=..TH2L(PSterTime)
	s MachineObj=##class(User.CSSDMachineConfig).%OpenId(PMachineId)
	i '$IsObject(MachineObj) d RtnObj.Err(-1,"","未获取到灭菌器械信息!")
	q:RtnObj.success'=0 RtnObj
	
	d MachineObj.%Reload()
	s MachineNo=MachineObj.CSSDMCNum
	s IsBD=MachineObj.CSSDMCIsBD
	s IsLeak=MachineObj.CSSDMCIsLeak
	s LeakTime=MachineObj.CSSDMCLeakTime
	
	s ComplateFlag=""
	s TmpId=$o(^User.CSSDSterilizeRecordI("IndexCSSDSRMachineNoDate",PMachineId,CurDate,""),-1)
	s:TmpId'="" ComplateFlag=$lg(^User.CSSDSterilizeRecordD(TmpId),19)
	i ComplateFlag="N" d RtnObj.Err(-1,"","该灭菌器存在未确认灭菌的记录!")
	q:RtnObj.success'=0 RtnObj
	
	i PSterCarCode'="" d
	.s (SterRecordId,ExistFlag)=""
	.f  s SterRecordId=$o(^User.CSSDSterilizeRecordI("IndexCSSDSRCarLBL",PSterCarCode,SterRecordId),-1) q:((SterRecordId="")||(ExistFlag="Y"))  d
	..s ChkFlag=$lg(^User.CSSDSterilizeRecordD(SterRecordId),27)
	..s SterNo=$lg(^User.CSSDSterilizeRecordD(SterRecordId),4)
	..s SterDate=$lg(^User.CSSDSterilizeRecordD(SterRecordId),2)
	..i SterDate<CurDate-7 s ExistFlag="Y"
	..i ChkFlag="" d RtnObj.Err(-1,"","灭菌批号:"_SterNo_"中绑定的灭菌车未验收,请先验收!")
	q:RtnObj.success'=0 RtnObj
	
	i IsLeak="Y" d
	.s RtnObj=..IfLeak(PMachineId,LeakTime)
	q:RtnObj.success'=0 RtnObj
	
	s ParamsStr=gGroupId_"^"_PSterLocId_"^"_gUserId_"^"_gHospId
	i IsBD="Y" d
	.s RtnObj=..IfBD(PMachineId,ParamsStr)
	q:RtnObj.success'=0 RtnObj
	
	s Ret=..sssLock("Sterilize")
	i Ret'=0 d RtnObj.Err(-1,"","生成灭菌批号加锁失败！")
	q:RtnObj.success'=0 RtnObj
	
	s sterilizeNo=##class(web.CSSDHUI.Common.AppCommon).GetAppNo("STER",PMachineId,PSterLocId,gHospId,"1")
	s (IsBio,IsChe,IsPhy)="N"
	s IsPhy=##Class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDSTERILIZE","IsPhysicTest",ParamsStr)
	s IsChe=##Class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDSTERILIZE","IsCheTest",ParamsStr)
	s IfOverChkTime=##Class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDSTERILIZE","IfOverChkTime",ParamsStr)
	i IfOverChkTime="Y" d
	.s RtnObj=..IfOverTime(PMachineId,PSterTime)
	q:RtnObj.success'=0 RtnObj
	
	i RowId="" d
	.s SterMainObj=##class(User.CSSDSterilizeRecord).%New()
	.s SterMainObj.CSSDSRNo=sterilizeNo
	.s SterMainObj.CSSDSRDate=CurDate
	.s SterMainObj.CSSDSRTime=CurTime
	.d SterMainObj.CSSDSRUserDrSetObjectId(PSterUserId)
	.d SterMainObj.CSSDSRLocDrSetObjectId(PSterLocId)
	.s SterMainObj.CSSDSRBDResult=1
	.s SterMainObj.CSSDSRCreateDate=CurDate
	.s SterMainObj.CSSDSRCreateTime=CurTime
	e  d
	.s SterMainObj=##class(User.CSSDSterilizeRecord).%OpenId(RowId)
	.d SterMainObj.%Reload()
	s SterMainObj.CSSDSRMachineNo=MachineNo
	d SterMainObj.CSSDSRMachineNoDRSetObjectId(PMachineId)
	d SterMainObj.CSSDSRProgressDRSetObjectId(PSterProId)
	s SterMainObj.CSSDSRCarLBL=PSterCarCode
	s SterMainObj.CSSDSRIsBio=IsBio
	s SterMainObj.CSSDSRIsChe=IsChe
	s SterMainObj.CSSDSRIsPhy=IsPhy
	s SterMainObj.CSSDSRFlag=1	//正常灭菌标识为：1
	s Sc=SterMainObj.%Save()
	i $$$ISERR(Sc) d
	.d ..sssUnLock("Sterilize")
	.d RtnObj.Err(-5,"","保存失败!")
	q:RtnObj.success'=0 RtnObj
	
	s SterMainId=SterMainObj.%Id()
	d ..sssUnLock("Sterilize")
	i PSterCarCode'="" d
	.s RtnObj=..SaveSterCarPKg(SterMainId,PSterCarCode)
	q:RtnObj.success'=0 RtnObj
	
	s RtnObj=##class(web.CSSDHUI.System.MachineConfig).UpdateMachineCycle(PMachineId)
	q:RtnObj.success'=0 RtnObj
	
	s RtnObj.rowid=SterMainId
	q RtnObj
}

/// W ##CLASS(web.CSSDHUI.PackageSterilize.Sterilize).GetMachineDayCycle(1)
ClassMethod GetMachineDayCycle(MachineId)
{
	n (%session,MachineId)
	q:MachineId="" 0
	s CurDate=+$h
	s Num=0
	s LocId=""
	f  s LocId=$o(^User.CSSDSterilizeRecordI("IndexMachineNoDRDateLocDr",MachineId,CurDate,LocId)) q:LocId=""  d
	.s SterMainId=""
	.f  s SterMainId=$o(^User.CSSDSterilizeRecordI("IndexMachineNoDRDateLocDr",MachineId,CurDate,LocId,SterMainId)) q:SterMainId=""  d
	..s CompFlag=$lg(^User.CSSDSterilizeRecordD(SterMainId),19)
	..q:CompFlag'="F"
	..s LeakFlag=$lg(^User.CSSDSterilizeRecordD(SterMainId),45)
	..q:LeakFlag=1
	..s BDFlag=$lg(^User.CSSDSterilizeRecordD(SterMainId),13)
	..q:BDFlag=1
	..s Num=Num+1
	
	q Num
}

/// Creator:ban
/// CreatDate:2020.4.9
/// Description:重新灭菌
/// Table:CSSD_MachineConfig,CSSD_SterilizeRecord
/// Input:Params 灭菌主表信息
/// Output:
/// Return:日志信息
/// w ##class(web.CSSDHUI.PackageSterilize.Sterilize).jsRepeatSave(^templxt("bbb"))
ClassMethod jsRepeatSave(Params) As %Library.String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s gUserId=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s gHospId=PJObj.%Get("gHospId")
	s gGroupId = PJObj.%Get("gGroupId")
	s PMachineId=PJObj.%Get("MachineNoValue")
	s PSterCarValue=PJObj.%Get("SterCarValue")
	s PProgressDr=PJObj.%Get("SterProValue")
	s RowId=PJObj.%Get("OriginalRowId")			;原灭菌单RowId
	s CurDate=+$h
	s CurTime=$p($h,",",2)
	i (RowId="") q RtnObj.Err(-1,"","请选择灭菌单").Json()
	i (PProgressDr="") q RtnObj.Err(-1,"","请选择灭菌程序").Json()
	
	s MachineObj=##class(User.CSSDMachineConfig).%OpenId(PMachineId)
	i '$IsObject(MachineObj) q RtnObj.Err(-1,"","未获取到灭菌器信息").Json()
	
	d MachineObj.%Reload()
	s MachineNo=MachineObj.CSSDMCNum
	
	s SterMainObj=##class(User.CSSDSterilizeRecord).%OpenId(RowId)
	i '$IsObject(SterMainObj) q RtnObj.Err(-1,"","未获取到灭菌批次信息，请核对！").Json()
	
	d SterMainObj.%Reload()
	s SterNo=SterMainObj.CSSDSRNo
	s LeakLabel=SterMainObj.CSSDSRLeakLabel
	s BDLabel=SterMainObj.CSSDSRBdLabel
	s IsBio=SterMainObj.CSSDSRIsBio
	s IsChe=SterMainObj.CSSDSRIsChe
	s IsPhy=SterMainObj.CSSDSRIsPhy
	
	ts
	s SterProId=$o(^User.CSSDSterPrdoI("IndexCSSDSPSterNo",SterNo,""))
	i SterProId'="" d
	.s SterProObj = ##class(User.CSSDSterPrdo).%OpenId(SterProId)
	.s States=SterProObj.CSSDSPStatus
	.i States=1 d RtnObj.Err(-2,"","灭菌对应的不合格登记信息已提交，不能重新灭菌！") q
	.s SterProDetailId=$o(^User.CSSDSterPredoDetailI("IndexMainDr",SterProId,""))
	.i SterProDetailId'="" d
	..&sql(DELETE FROM CSSD_SterPredoDetail WHERE CSSDSPD_MainDr=:SterProId)
	..i SQLCODE'=0 d RtnObj.Err(-4,"","重新灭菌操作，删除不合格登记详情信息报错！") q
	.&sql(DELETE FROM CSSD_SterPredo WHERE ID=:SterProId)
	.i SQLCODE'=0 d RtnObj.Err(-5,"","重新灭菌操作，删除不合格登记信息报错！") q
	q:RtnObj.success'=0 RtnObj
	
	s SterilizeNo=##class(web.CSSDHUI.Common.AppCommon).GetAppNo("STER",PMachineId,gLocId,gHospId,"1")
	s SterObj=##class(User.CSSDSterilizeRecord).%New()
	s SterObj.CSSDSRMachineNo=MachineNo
	d SterObj.CSSDSRMachineNoDRSetObjectId(PMachineId)
	s SterObj.CSSDSRBDResult=1
	s SterObj.CSSDSRNo=SterilizeNo
	s SterObj.CSSDSRDate=CurDate
	s SterObj.CSSDSRTime=CurTime
	d SterObj.CSSDSRUserDrSetObjectId(gUserId)
	d SterObj.CSSDSRLocDrSetObjectId(gLocId)
	d SterObj.CSSDSRProgressDRSetObjectId(PProgressDr)
	s SterObj.CSSDSRCarLBL=PSterCarValue
	s SterObj.CSSDSRFlag=1
	d SterObj.CSSDSRSRDRSetObjectId(RowId)				;记录老的灭菌单id
	s SterObj.CSSDSRCreateDate=CurDate
	s SterObj.CSSDSRCreateTime=CurTime
	s SterObj.CSSDSRIsPhy=IsPhy
	s SterObj.CSSDSRIsChe=IsChe
	s SterObj.CSSDSRIsBio=IsBio
	s SterObj.CSSDSRBdLabel=BDLabel
	s SterObj.CSSDSRLeakLabel=LeakLabel
	s Sc=SterObj.%Save()
	i $$$ISERR(Sc) tro  q RtnObj.Err(-5,"","重新灭菌保存失败！").Json()
	s SterMainId=SterObj.%Id()
	
	s RtnObj=..RepeatSaveDetail(SterMainId,RowId)
	i RtnObj.success'=0 tro  q RtnObj.Err(-6,"",$ClassName()_"jsRepeatSave:重新灭菌，明细添加失败！").Json()
	
	s RtnObj=##class(web.CSSDHUI.System.MachineConfig).UpdateMachineCycle(PMachineId)
	i RtnObj.success'=0 tro  q RtnObj.Err(-8,"",$ClassName()_"jsRepeatSave:更新机器灭菌循环次数失败！").Json()
	
	tc
	s RtnObj.rowid=SterMainId
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2020.4.9
/// Description:重新灭菌，将原灭菌的明细数据增加到新灭菌器中
/// Table: CSSD_PackageSterilize
/// Input: mainRowid新增灭菌单据ID ,RowId:原灭菌单据ID
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.PackageSterilize.Sterilize).RepeatSaveDetail("37","36")
ClassMethod RepeatSaveDetail(SterMainId As %String, RowId As %String) As web.CSSDHUI.RtnObj
{
	n (%session,SterMainId,RowId)
	
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s SterItmId=""
	f  s SterItmId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSParref",RowId,SterItmId)) q:((SterItmId="")||(RtnObj.success<0))  d
	.s SterItmObj=##class(User.CSSDPackageSterilize).%OpenId(SterItmId)
	.q:('$IsObject(SterItmObj))
	.d SterItmObj.%Reload()
	.s Label=SterItmObj.CSSDPSLabel
	.s PkgId=SterItmObj.CSSDPSPackageGetObjectId()
	.&sql(insert into CSSD_PackageSterilize(CSSDPS_Label,CSSDPS_Package_DR,CSSDPS_Parref_DR,CSSDPS_Qty,CSSDPS_SerialNo ) values(:Label,:PkgId,:SterMainId,1,1))
	.i SQLCODE'=0 d RtnObj.Err(-3,"","重新灭菌，明细添加失败！")
	.q:RtnObj.success<0
	.&sql(update CSSD_PackagePack set CSSDPP_IsLoadSteCar=1 where CSSDPP_Label=:Label)
	.i SQLCODE'=0 d RtnObj.Err(-3,"","重新灭菌，修改标签状态！")
	.q:RtnObj.success<0
	q:RtnObj.success<0 RtnObj
	
	&sql(UPDATE CSSD_SterilizeRecord SET CSSDSR_WorkStatus='Y' WHERE CSSDSR_Rowid=:SterMainId)
	i SQLCODE'=0 d RtnObj.Err(-1,"","重新灭菌,修改单据状态失败!")
	q:RtnObj.success<0 RtnObj
	
	q RtnObj
}

/// Creator:why
/// CreatDate:2022.7.13
/// Description:更换灭菌器
/// Table:CSSD_MachineConfig,CSSD_SterilizeRecord
/// Input:Params 灭菌主表信息
/// Output:
/// Return:日志信息
/// w ##class(web.CSSDHUI.PackageSterilize.Sterilize).jsChange("{""SterLocId"":""166"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""FStartDate"":""2023-02-19"",""FEndDate"":""2023-02-20"",""MachineNoValue"":""1"",""SterCarValue"":""81"",""SterProValue"":""36"",""SterUserValue"":""12204"",""MachineNoSterType"":""20"",""SterTime"":"""",""OriginalRowId"":""317""}")
ClassMethod jsChange(Params) As %Library.String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s gUserId=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s gHospId=PJObj.%Get("gHospId")
	s gGroupId=PJObj.%Get("gGroupId")
	s PMachineId=PJObj.%Get("MachineNoValue")
	s PSterCarValue=PJObj.%Get("SterCarValue")
	s PSterProId=PJObj.%Get("SterProValue")
	s PSterUserId=PJObj.%Get("SterUserValue")
	s RowId=PJObj.%Get("OriginalRowId")			;原灭菌单RowId
	s:PSterUserId="" PSterUserId=gUserId
	s CurDate=+$h
	s CurTime=$p($h,",",2)
	i (RowId="") q RtnObj.Err(-1,"","请选择灭菌单").Json()
	i (PSterProId="") q RtnObj.Err(-1,"","请选择灭菌程序").Json()
	
	s MachineObj=##class(User.CSSDMachineConfig).%OpenId(PMachineId)
	i '$IsObject(MachineObj) q RtnObj.Err(-1,"","未获取到灭菌器械信息!").Json()
	
	d MachineObj.%Reload()
	s MachineNo=MachineObj.CSSDMCNum
	s IsBD=MachineObj.CSSDMCIsBD
	s IsLeak=MachineObj.CSSDMCIsLeak
	s LeakTime=MachineObj.CSSDMCLeakTime
	
	i IsLeak="Y" d
	.s RtnObj=..IfLeak(PMachineId,LeakTime)
	q:RtnObj.success'=0 RtnObj.Json()
	
	s ParamsStr=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	i IsBD="Y" d
	.s RtnObj=..IfBD(PMachineId,ParamsStr)
	q:RtnObj.success'=0 RtnObj.Json()
	
	ts
	s SterNo=##class(web.CSSDHUI.Common.AppCommon).GetAppNo("STER",PMachineId,gLocId,gHospId,"1")
	s SterObj=##class(User.CSSDSterilizeRecord).%New()
	s SterObj.CSSDSRMachineNo=MachineNo
	d SterObj.CSSDSRMachineNoDRSetObjectId(PMachineId)
	s SterObj.CSSDSRBDResult=1
	s SterObj.CSSDSRNo=SterNo
	s SterObj.CSSDSRDate=CurDate
	s SterObj.CSSDSRTime=CurTime
	d SterObj.CSSDSRUserDrSetObjectId(PSterUserId)
	d SterObj.CSSDSRLocDrSetObjectId(gLocId)
	d SterObj.CSSDSRProgressDRSetObjectId(PSterProId)
	s SterObj.CSSDSRCarLBL=PSterCarValue
	s SterObj.CSSDSRFlag=1				//正常灭菌标识为：1
	s SterObj.CSSDSRCreateDate=CurDate
	s SterObj.CSSDSRCreateTime=CurTime
	s Sc=SterObj.%Save()
	i $$$ISERR(Sc) tro  q RtnObj.Err(-5,"","更换灭菌器保存失败！").Json()
	s SterMainId=SterObj.%Id()
	
	s RtnObj=..RepeatSaveDetail(SterMainId,RowId)
	i RtnObj.success'=0 tro  q RtnObj.Err(-6,"",$ClassName()_"jsChange:更换灭菌器，明细添加失败！").Json()
	
	s RtnObj=##class(web.CSSDHUI.System.MachineConfig).UpdateMachineCycle(PMachineId)
	i RtnObj.success'=0 tro  q RtnObj.Err(-8,"",$ClassName()_"jsChange:更新机器灭菌循环次数失败！").Json()
	
	s RtnObj=..Delete(RowId)	//更换灭菌器删除原有灭菌信息
	i RtnObj.success'=0 tro  q RtnObj.Err(-6,"",$ClassName()_"jsChange:删除更换前灭菌记录失败！").Json()
	
	&sql(UPDATE CSSD_PackagePack set CSSDPP_IsLoadSteCar=1 where CSSDPP_label in 
	(SELECT CSSDPS_Label From CSSD_PackageSterilize Where CSSDPS_Parref_DR=:SterMainId))
	i SQLCODE<0 tro  q RtnObj.Err(-2,RowId,"更新灭菌明细标签状态失败！")
	
	tc
	s RtnObj.rowid=SterMainId
	q RtnObj.Json()
}

/// Creator:
/// CreatDate:2019.5.7
/// Description:查询灭菌主表数据
/// Table:CSSD_SterilizeRecord
/// Input:parame:查询条件
/// Output:
/// Return:日志信息
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.PackageSterilize.Sterilize","SelectAll","{""SterLocId"":""166"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""FStartDate"":""2022-12-12"",""FEndDate"":""2022-12-13"",""MachineNoValue"":"""",""SterCarValue"":"""",""SterProValue"":"""",""SterUserValue"":"""",""BoiValue"":"""",""MachineNoSterType"":"""",""SterWay"":"""",""SterProWay"":"""",""SterTime"":""""}")
Query SelectAll(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,MachineNo,MachineNoDR,No,SterDate,SterTime,SterDateTime,SterName,TempType,carLabel,Progress,ProgressDR,UsedTime,Temperature,Pressure,ComplateFlag,chkame,CheckDate,CHKTime,CheckDateTime,IsCHK,ChkFlag,BatLabel,ReasonId,ReasonDesc,WorkStatus,IsBio,BioCHKName,BioCHKDate,BioCHKTime,BioCHKDateTime,IsChe,CheResult,CheCHKName,CheCHKDate,CheCHKTime,CheCHKDateTime,IsPhy,PhyResult,PhyCHKDate,PhyCHKTime,PhyName,PhyCHKDateTime,SterPackageNum,LevelFlag,NotUseFlag,SterType,LeakLabelFlag,BDLabelFlag,CreateLoc,MachineFileName,MachineUrl,Remark") [ SqlProc ]
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (%session,qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 $$$OK
	s PRowId=PJObj.%Get("RowId")
	s PStartDate=PJObj.%Get("FStartDate")
	s PEndDate=PJObj.%Get("FEndDate")
	s PComplateFlag=PJObj.%Get("FComplateFlag")
	s PCheckFlag=PJObj.%Get("CheckFlag")
	s PMachineId=PJObj.%Get("MachineNoValue")
	s PSterProId=PJObj.%Get("SterProValue")
	s PSterUserId=PJObj.%Get("SterUserValue")
	s gLocId=PJObj.%Get("gLocId")
	s PCheckUserId=PJObj.%Get("CheckUserValue")
	s PMachineCount=PJObj.%Get("MachineCount")
	s PCheck=PJObj.%Get("QueryCheck")
	s PState=PJObj.%Get("QueryState")
	s PSterLocId=PJObj.%Get("SterLocId")
	s PSterCarValue=PJObj.%Get("SterCarValue")
	s PLabel=PJObj.%Get("Label")
	s PStartDate=..DH2L(PStartDate)
	s PEndDate=..DH2L(PEndDate)
	q:(PStartDate="")||(PEndDate="") $$$OK
	
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT CSSDSR_Rowid as RowId,CSSDSR_MachineNo_DR,CSSDSR_No,CSSDSR_CheckDate,CSSDSR_BioCHKDate,CSSDSR_CheCHKDate, "
			_" CSSDSR_Date,CSSDSR_Time,CSSDSR_User_DR as SterUserId,CSSDSR_User_DR->SSUSR_Name as SterUserName ,CSSDSR_FileName, "
			_" CSSDSR_UsedTime,CSSDSR_Temperature,CSSDSR_Pressure,CSSDSR_CarLBL, "
			_" CSSDSR_ThreeMResult,CSSDSR_BD_Result,CSSDSR_Progress_DR,CSSDSR_WorkStatus, "
			_" CSSDSR_CHKUser_DR as CheckUserId,CSSDSR_CHKUser_DR->SSUSR_Name as ChkUserName,CSSDSR_CHKTime,CSSDSR_FLAGREASON, "
			_" CSSDSR_IsCHK,CSSDSR_ChkFlag,CSSDSR_ComplateFlag,CSSDSR_BatLabel,CSSDSR_BD_Label, "
			_" CSSDSR_BioCHKUser_DR->SSUSR_Name as bioname,CSSDSR_BioCHKTime,CSSDSR_IsBio,CSSDSR_Loc_DR,CSSDSR_Loc_DR->CTLOC_Desc as CreateLoc, "
			_" CSSDSR_IsChe,CSSDSR_CheCHKUser_DR->SSUSR_Name as chename,CSSDSR_CheCHKTime,CSSDSR_CheResult,CSSDSR_LeakLabel,CSSDSR_ThreeMResult,"
			_" CSSDSR_IsPhy,CSSDSR_PhyCHKUser_DR->SSUSR_Name as PhyName,CSSDSR_PhyCHKDate,CSSDSR_PhyCHKTime,CSSDSR_PhyResult,CSSDSR_Remark "
			_" from CSSD_SterilizeRecord where CSSDSR_Date between "_PStartDate_" AND "_PEndDate_" order by CSSDSR_Rowid desc"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s MachineId = Result.Data("CSSDSR_MachineNo_DR")
		s CreateLocId = Result.Data("CSSDSR_Loc_DR")
		s CreateLocDesc = Result.Data("CreateLoc")
		s SterNo = Result.Data("CSSDSR_No")
		s SterDate=Result.Data("CSSDSR_Date")
		s SterTime=Result.Data("CSSDSR_Time")
		s SterUserId=Result.Data("SterUserId")
		s SterUserName = Result.Data("SterUserName")
		s UsedTime = Result.Data("CSSDSR_UsedTime")
		s Temperature = Result.Data("CSSDSR_Temperature")
		s Pressure = Result.Data("CSSDSR_Pressure")
		s SterProId = Result.Data("CSSDSR_Progress_DR")
		s WorkStatus = Result.Data("CSSDSR_WorkStatus") //重新灭菌状态
		s SterCarLabel = Result.Data("CSSDSR_CarLBL")		;灭菌架CSSD_CodeDict表ID
		
		s ChkUserId=Result.Data("CheckUserId")
		s ChkUserName = Result.Data("ChkUserName")
		s ChkDate = Result.Data("CSSDSR_CheckDate")	//验收日期
		s ChkTime=Result.Data("CSSDSR_CHKTime")
		s IsCHK = Result.Data("CSSDSR_IsCHK")
		s ChkFlag = Result.Data("CSSDSR_ChkFlag")
		s ComplateFlag = Result.Data("CSSDSR_ComplateFlag")
		s LeakLabelFlag = Result.Data("CSSDSR_LeakLabel")
		s BDLabelFlag = Result.Data("CSSDSR_BD_Label")	;bd检测
		s BatLabel = Result.Data("CSSDSR_BatLabel")		;生物监测
		s CheResult = Result.Data("CSSDSR_CheResult")	;化学监测
		s PhyResult = Result.Data("CSSDSR_PhyResult")	;物理监测
		s ReasonId = Result.Data("CSSDSR_FLAGREASON")	;不合格原因ID
		s NotUseFlag = Result.Data("CSSDSR_ThreeMResult")
		s MachineFileName = Result.Data("CSSDSR_FileName")
		s Remark = Result.Data("CSSDSR_Remark")
		s IsBio = Result.Data("CSSDSR_IsBio")
		s IsChe = Result.Data("CSSDSR_IsChe")
		s IsPhy = Result.Data("CSSDSR_IsPhy")
		
		continue:(PRowId'="")&&(PRowId'=RowId)
		continue:((PRowId="")&&(PSterLocId'="")&&(PSterLocId'=CreateLocId))
		continue:(PRowId="")&&(PSterUserId'="")&&(SterUserId'=PSterUserId)
		continue:(PRowId="")&&(PCheckUserId'="")&&(ChkUserId'=PCheckUserId)&&(ChkUserId'="")
		continue:((PRowId="")&&(PSterCarValue'="")&&(SterCarLabel'=PSterCarValue))
		continue:MachineId=""		;过滤c#版本数据
		s MachineObj=##class(User.CSSDMachineConfig).%OpenId(MachineId)
		continue:'$IsObject(MachineObj)
		s MachineNo=MachineObj.CSSDMCAlias
		s MachineUrl=MachineObj.CSSDMCDataPath
		continue:(PRowId="")&&(PMachineId'="")&&(PMachineId'=MachineId)
		continue:(PRowId="")&&(PMachineCount'="")&&(SterNo'[PMachineCount)
		
		continue:SterProId=""		;过滤老版本数据
		continue:(PRowId="")&&(PSterProId'="")&(PSterProId'=SterProId)
		
		;过滤标签
		s Flag=##class(web.CSSDHUI.PackageSterilize.Sterilize).IFLabelBySterDetail(RowId,PLabel)
		continue:(PLabel'="")&&(Flag="N")
		
		s (SterProDesc,SterCarDesc)=""
		s SterProObj=##class(User.CSSDBaseCode).%OpenId(SterProId)
		i $IsObject(SterProObj) s SterProDesc=SterProObj.CSSDDCName
		s SterCarObj = ##class(User.CSSDCodeDict).%OpenId(SterCarLabel)
		i $IsObject(SterCarObj) s SterCarDesc=SterCarObj.CSSDCDPackName
		
		continue:((PRowId="")&&(PCheckFlag="Y")&&(IsCHK=""))
		continue:((PRowId="")&&(PCheckFlag="N")&&(IsCHK'=""))
		continue:((PRowId="")&&(PState=1)&&(IsCHK'=1))
		continue:((PRowId="")&&(PState=2)&&(IsCHK'=2))
		continue:((PRowId="")&&(PState=0)&&(IsCHK'=""))
		
		;1-生物, 2-化学, 3-物理
		continue:(PRowId="")&&(PCheck=1)&&(IsBio'="Y")
		continue:(PRowId="")&&(PCheck=2)&&(IsChe'="Y")
		continue:(PRowId="")&&(PCheck=3)&&(IsPhy'="Y")
		
		continue:(PComplateFlag="F")&&(ComplateFlag'="F")
		continue:(PComplateFlag="Y")&&(ComplateFlag'="Y")&&(ComplateFlag'="F")
		continue:(PComplateFlag="N")&&(ComplateFlag'="N")
		
		s ReasonDesc=""
		i ReasonId'="" d
		.s ReasonDesc=##class(User.CSSDSteCheckReason).%OpenId(ReasonId).CSSDSteFailDesc
		s TempType=$lg(^User.CSSDMachineConfigD(MachineId),17)

		s SterDate = ..DL2H(SterDate)
		s SterTime = ..TL2H(SterTime)
		s ChkDate = ..DL2H(ChkDate)
		s ChkTime = ..TL2H(ChkTime)
		s SterDateTime=SterDate_" "_SterTime
		s SterChkDateTime=ChkDate_" "_ChkTime
		
		s BioMonitorInfo=..GetMonitorInfo("Bio",RowId)
		s BioCHKName=$p(BioMonitorInfo,"^",1)
		s BioCHKDateTime=$p(BioMonitorInfo,"^",2)
		
		s CheMonitorInfo=..GetMonitorInfo("Che",RowId)
		s CheCHKName=$p(CheMonitorInfo,"^",1)
		s CheCHKDateTime=$p(CheMonitorInfo,"^",2)
		
		s PhyMonitorInfo=..GetMonitorInfo("Phy",RowId)
		s PhyName=$p(PhyMonitorInfo,"^",1)
		s PhyCHKDateTime=$p(PhyMonitorInfo,"^",2)
		
		;记录灭菌单据类型
		s SterType=""
		k SterTypeArray
		i LeakLabelFlag=1 s SterTypeArray(1)="测漏"
		i BDLabelFlag=1 s SterTypeArray(2)="BD测试"
		i IsBio="Y" s SterTypeArray(3)="生物监测"
		i IsChe="Y" s SterTypeArray(4)="化学监测"
		i IsPhy="Y" s SterTypeArray(5)="物理监测"
		s TypeIndex=0
		f  s TypeIndex=$o(SterTypeArray(TypeIndex)) q:TypeIndex=""  d
		.s SterTypeDesc=SterTypeArray(TypeIndex)
		.i SterType="" s SterType=SterTypeDesc
		.e  s SterType=SterType_"/"_SterTypeDesc
		
		s (LevelFlag,SterItmId)="",SterPkgNum=0
		f  s SterItmId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSParref",RowId,SterItmId)) q:((SterItmId="")||(LevelFlag=1))  d
		.s SterItmObj=##class(User.CSSDPackageSterilize).%OpenId(SterItmId)
		.q:'$IsObject(SterItmObj)
		.d SterItmObj.%Reload()
		.s Label=SterItmObj.CSSDPSLabel
		.s SterPkgNum=SterPkgNum+1
		.s PackId=$o(^User.CSSDPackagePackI("CSSDPPLabelIndex",Label,""))
		.i PackId'="" d
		..s PackObj=##class(User.CSSDPackagePack).%OpenId(PackId)
		..q:'$IsObject(PackObj)
		..d PackObj.%Reload()
		..s LevelFlag=PackObj.CSSDPPLevelFlag
		d OutPutRow
	}
	d Result.Close()
	Quit $$$OK
	
OutPutRow
	s Data=$lb(RowId,MachineNo,MachineId,SterNo,SterDate,SterTime,SterDateTime,SterUserName,TempType,SterCarDesc,
		SterProDesc,SterProId,UsedTime,Temperature,Pressure,ComplateFlag,ChkUserName,ChkDate,CHKTime,SterChkDateTime,
		IsCHK,ChkFlag,BatLabel,ReasonId,ReasonDesc,WorkStatus,IsBio,BioCHKName,BioCHKDate,BioCHKTime,BioCHKDateTime,
		IsChe,CheResult,CheCHKName,CheCHKDate,CheCHKTime,CheCHKDateTime,IsPhy,PhyResult,PhyCHKDate,PhyCHKTime,PhyName,PhyCHKDateTime,
		SterPkgNum,LevelFlag,NotUseFlag,SterType,LeakLabelFlag,BDLabelFlag,CreateLocDesc,MachineFileName,MachineUrl,Remark)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:ban
/// CreatDate:2020.1.10
/// Description:灭菌验收页面验收不合格时将数据插入灭菌不合格登记页面(全部不合格)
/// Table: CSSD_SterPredo,CSSD_SterPredoDetail
/// Input: checker登录人ID ,sdeptdr:科室ID ,CleanMainID:清洗主表ID
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.PackageSterilize.Sterilize).CreateSterPredo("1","382","1")
ClassMethod CreateSterPredo(SterUserId As %String, gLocId As %Integer, SterMainId As %String, ReasonId As %String) As web.CSSDHUI.RtnObj
{
	n (%session,SterUserId,gLocId,SterMainId,ReasonId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s Ret=..sssLock("SterilizeFail")
	i Ret'=0 d RtnObj.Err(-1,"","生成灭菌不合格批号加锁失败！")
	q:RtnObj.success'=0 RtnObj
	
	s CurDateTime =$ZDATETIME($H,3)
	s CurTime=$P($h,",",2)
	s CurDate=$P($h,",",1)
	s SterFailNo=##class(web.CSSDHUI.Common.AppCommon).GetAppNo("STERFIAL")
	s SterMainObj = ##class(User.CSSDSterilizeRecord).%OpenId(SterMainId)
	i '$IsObject(SterMainObj) d RtnObj.Err(-1,"","未获取到灭菌批次信息！")
	q:RtnObj.success'=0 RtnObj
	
	d SterMainObj.%Reload()
	s SterNo = SterMainObj.CSSDSRNo
	&sql(INSERT INTO CSSD_SterPredo(CSSDSP_No,CSSDSP_Loc,CSSDSP_Dt,CSSDSP_Register,CSSDSP_Status,CSSDSP_SterNo,CSSDSP_Date,CSSDSP_Time)
		 VALUES (:SterFailNo,:gLocId,:CurDateTime,:SterUserId,0,:SterNo,:CurDate,:CurTime))
	i SQLCODE'=0 d ..sssUnLock("SterilizeFail") d RtnObj.Err(-2,"","插入数据失败"_MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg))
	q:RtnObj.success'=0 RtnObj
	
	d ..sssUnLock("SterilizeFail")
	s SterFailMainId=%ROWID
	
	s SterItmId=""
	f  s SterItmId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSParref",SterMainId,SterItmId)) q:((SterItmId="")||(RtnObj.success<0))  d
	.s SterItmObj=##class(User.CSSDPackageSterilize).%OpenId(SterItmId)
	.q:'$IsObject(SterItmObj)
	.d SterItmObj.%Reload()
	.s Label=SterItmObj.CSSDPSLabel
	.s PkgId=SterItmObj.CSSDPSPackageGetObjectId()
	.s States=SterItmObj.CSSDPSStates
	.q:States="N"
	.&sql(INSERT INTO CSSD_SterPredoDetail (CSSDSPD_MainDr,CSSDSPD_Num,CSSDSPD_SterNo,CSSDSPD_Resion,CSSDSP_Package_DR)
		VALUES (:SterFailMainId,:Label,:SterFailNo,:ReasonId,:PkgId))
	.i SQLCODE'=0 d RtnObj.Err(-3,"","添加失败！")
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Creator:wn
/// CreatDate:2020.4.10
/// Description:灭菌验收页面部分明细验收不合格时将数据插入灭菌不合格登记页面(单个不合格)
/// Table: CSSD_SterPredo,CSSD_SterPredoDetail
/// Input: checker登录人ID ,sdeptdr:科室ID ,CleanMainID:清洗主表ID
/// Output:
/// Return:
/// w ##Class(web.CSSDHUI.PackageSterilize.Sterilize).CreateSingleSterPredo("1","382","266","494,495","1")
ClassMethod CreateSingleSterPredo(SterUserId As %String, gLocId As %Integer, SterMainId As %String, SterItmIds As %String, ReasonId As %Integer) As web.CSSDHUI.RtnObj
{
	n (%session,SterUserId,gLocId,SterMainId,SterItmIds,ReasonId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s Ret=..sssLock("SterilizeFail")
	i Ret'=0 d RtnObj.Err(-1,"","生成灭菌不合格批号加锁失败！")
	q:RtnObj.success'=0 RtnObj
	
	s CurDateTime =$ZDATETIME($H,3)
	s CurDate=$p($h,",",1)
	s CurTime=$p($h,",",2)
	s SterFailNo=##class(web.CSSDHUI.Common.AppCommon).GetAppNo("STERFIAL")
	s SterMainObj = ##class(User.CSSDSterilizeRecord).%OpenId(SterMainId)
	i '$IsObject(SterMainObj) d RtnObj.Err(-1,"","未获取到灭菌批次信息！")
	q:RtnObj.success'=0 RtnObj
	
	d SterMainObj.%Reload()
	s SterNo = SterMainObj.CSSDSRNo
	s SterFailMainId=$o(^User.CSSDSterPrdoI("IndexSterNoStatus",SterNo,"0",""))
	i SterFailMainId="" d
	.&sql(INSERT INTO CSSD_SterPredo (CSSDSP_No,CSSDSP_Loc,CSSDSP_Dt,CSSDSP_Register,CSSDSP_Status,CSSDSP_SterNo,CSSDSP_Date,CSSDSP_Time)
		 VALUES (:SterFailNo,:gLocId,:CurDateTime,:SterUserId,0,:SterNo,:CurDate,:CurTime))
	.i SQLCODE'=0 d ..sssUnLock("SterilizeFail") d RtnObj.Err(-2,"","插入数据失败"_MethodName_":SQLCODE"_SQLCODE_":"_$g(%msg))
	.q:RtnObj.success'=0
	.d ..sssUnLock("SterilizeFail")
	.s SterFailMainId=%ROWID
	q:RtnObj.success'=0 RtnObj
	
	s Length=$L(SterItmIds,",")
	f j=1:1:Length  q:RtnObj.success<0  d
	.s SterItmId=$p(SterItmIds,",",j)
	.s PkgId=$lg(^User.CSSDPackageSterilizeD(SterItmId),12)
	.s Label=$lg(^User.CSSDPackageSterilizeD(SterItmId),3)
	.&sql(INSERT INTO CSSD_SterPredoDetail (CSSDSPD_MainDr,CSSDSPD_Num,CSSDSPD_SterNo,CSSDSPD_Resion,CSSDSP_Package_DR)
		 VALUES (:SterFailMainId,:Label,:SterFailNo,:ReasonId,:PkgId))
	.i SQLCODE'=0 d RtnObj.Err(-3,"","添加失败！")
	q:RtnObj.success<0 RtnObj
	
	q RtnObj
}

/// Creator:ban
/// CreatDate:2020.4.11
/// Description:验收更新追踪表的灭菌状态、绑定最新的灭菌明细dr，更新全部灭菌明细dr
/// Table:cssd_trans
/// Input:sterMainDr为灭菌主表的dr
/// Output:
/// Return:日志信息
/// d ##Class(web.CSSDHUI.PackageSterilize.Sterilize).UpdateTransAllSterState("184","","Y")
/// DetailIds=""证明是进行全部不合格或全部合格DetailIds'=""证明是进行部分不合格操作
ClassMethod UpdateTransAllSterState(SterMainId, SterItmIds, States) As web.CSSDHUI.RtnObj
{
	n (%session,SterMainId,SterItmIds,States)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s SterMainObj=##Class(User.CSSDSterilizeRecord).%OpenId(SterMainId)
	d SterMainObj.%Reload()
	i '$IsObject(SterMainObj) d RtnObj.Err(-1,"","未获取到灭菌信息!") q
	
	s SterLocId=SterMainObj.CSSDSRLocDr.%Id()
	s SterItmId=""
	f  s SterItmId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSParref",SterMainId,SterItmId))  q:SterItmId=""  d
	.q:((SterItmIds'="")&&(SterItmIds'[SterItmId))
	.s SterItmObj=##Class(User.CSSDPackageSterilize).%OpenId(SterItmId)	//灭菌明细表的实例
	.d SterItmObj.%Reload()
	.s Label=SterItmObj.CSSDPSLabel
	.s SterItmState=SterItmObj.CSSDPSStates
	.s PkgId=SterItmObj.CSSDPSPackage.%Id()
	.s PkgObj=##class(User.CSSDPackage).%OpenId(PkgId)
	.d PkgObj.%Reload()
	.s PkgClassId=PkgObj.CSSDPPackClassGetObjectId()
	.s IsExt=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PkgId)
	.s TransId=$o(^User.CSSDTransI("CSSDTLabel",Label,""))
	.s TransObj=##Class(User.CSSDTrans).%OpenId(TransId)
	.d TransObj.%Reload()
	.s AllSterId=TransObj.CSSDTAllSterilize
	.i ((AllSterId'="")&&(AllSterId'[SterItmId)) s AllSterId=AllSterId_"#"_SterItmId
	.i ((SterItmIds'="")&&(States="N"))  d	//进行部分不合格操作
	..&sql(update cssd_trans set cssdt_status='P',cssdt_sterilize_dr=:SterItmId,CSSDT_AllSterilize=(case when CSSDT_AllSterilize is null then :SterItmId else :AllSterId end) where cssdt_label=:Label)
	..i SQLCODE'=0 d RtnObj.Err(-1,"","灭菌合格操作，更新追踪表状态失败！") q
	..&sql(update cssd_packagepack set CSSDPP_IsLoadSteCar=0 where CSSDPP_Label=:Label)
	..i SQLCODE'=0 d RtnObj.Err(-1,"","灭菌不合格操作,更新打包表装车状态失败!")	q	;部分验收不合格后标签啊可以在待灭菌弹窗出现
	.i SterItmIds="" d	;进行全部合格或全部不合格操作
	..q:(SterItmState'="")&&(SterItmState'=States)
	..i States="Y" d	;全部合格操作
	...&sql(update cssd_trans set cssdt_status='S',cssdt_sterilize_dr=:SterItmId,CSSDT_AllSterilize=(case when CSSDT_AllSterilize is null then :SterItmId else :AllSterId end) where cssdt_label=:Label)
	...i SQLCODE'=0 d RtnObj.Err(-1,"","灭菌合格操作，更新追踪表状态失败！") q
	...i IsExt="Y" d
	....s FixedLabel=##class(web.CSSDHUI.Common.PackageInfoCommon).GetFixedLabel(Label)
	....s Len=$l(FixedLabel)
	....s WLCodeLabel=$E(Label,1,Len+6)
	....&sql(Update CSSD_ExtDevBind set CSSDExt_Status='S' where CSSDExt_Label=:WLCodeLabel and CSSDExt_Status='P')
	....i ((SQLCODE'=0)&(SQLCODE'=100)) d RtnObj.Err(-1,"","灭菌合格操作，外来器械更新状态失败！") q
	..e  d	;全部不合格操作
	...&sql(update cssd_trans set cssdt_status='P',cssdt_sterilize_dr=:SterItmId,CSSDT_AllSterilize=(case when CSSDT_AllSterilize is null then :SterItmId else :AllSterId end) where cssdt_label=:Label)
	...i SQLCODE'=0 d RtnObj.Err(-3,"","灭菌不合格操作，更新追踪表状态失败！") q
	...&sql(update cssd_packagepack set CSSDPP_IsLoadSteCar=0 where CSSDPP_Label=:Label)
	...i SQLCODE'=0 d RtnObj.Err(-3,"","灭菌不合格操作,更新打包表装车状态失败!") q
	q RtnObj
}

/// Creator:
/// CreatDate:2019.5.7
/// Description:验收不合格
/// Table:CSSD_SterilizeRecord
/// Input:MainId:灭菌主表id User:验收人 ResonDr:不合格原因dr
/// Output:
/// Return:日志信息
/// w ##class(web.CSSDHUI.PackageSterilize.Sterilize).jsFail("1")
ClassMethod jsFail(Params) As %String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..Fail(Params)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc 
	q RtnObj.Json()
}

ClassMethod Fail(Params) As web.CSSDHUI.RtnObj
{
	n (%session,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s PSterMainId = PJObj.%Get("SterMainId")
	s PReasonId = PJObj.%Get("ReasonId")
	s PIsSterFinish = PJObj.%Get("IsSterFinish")
	s PRemark = PJObj.%Get("Remark")
	s PUserId = PJObj.%Get("gUserId")
	s PCheckTime = PJObj.%Get("CheckTime")
	s PChkUserId = PJObj.%Get("CheckUserValue")
	s gHospId = PJObj.%Get("gHospId")
	s gLocId = PJObj.%Get("gLocId")
	s gGroupId = PJObj.%Get("gGroupId")
	s:PChkUserId'="" PUserId=PChkUserId
	i PSterMainId="" d RtnObj.Err(-1,"","参数是空!")
	q:RtnObj.success'=0 RtnObj
	
	s SterMainObj=##Class(User.CSSDSterilizeRecord).%OpenId(PSterMainId)
	d SterMainObj.%Reload()
	s IsCmt=SterMainObj.CSSDSRComplateFlag
	s FileName=SterMainObj.CSSDSRFileName
	s IsChk=SterMainObj.CSSDSRIsCHK
	s MachineDr=SterMainObj.CSSDSRMachineNoDRGetObjectId()
	i (PIsSterFinish="N")&&(IsCmt'="Y")&&(IsCmt'="F") d RtnObj.Err(-3,"","还未确认灭菌操作！")
	i ((PIsSterFinish="Y")&&(IsCmt'="F")) d RtnObj.Err(-3,"","还未进行灭菌完成操作！")
	q:RtnObj.success'=0 RtnObj
	
	i IsChk'="" d RtnObj.Err(-3,"","已经灭菌验收!")
	q:RtnObj.success'=0 RtnObj
	
	s CurrDate=$p($h,",",1)
	s CurTime=$p($h,",",2)
	s CheckTime=..TH2L(PCheckTime)
	i CheckTime'="" d
	.s CurTime=CheckTime
	s ChkResult=2
	
	s RtnObj=..CheckInterval(PSterMainId,CurTime)
	i RtnObj.success<0 q RtnObj
	
	&sql(Update CSSD_SterilizeRecord set CSSDSR_FLAGREASON=:PReasonId,CSSDSR_CheckDate=:CurrDate,
		CSSDSR_CHKTime=:CurTime,CSSDSR_IsChk=:ChkResult,CSSDSR_CHKUser_DR=:PUserId,CSSDSR_Remark=:PRemark
		where CSSDSR_Rowid=:PSterMainId
	)
	i SQLCODE'=0 q RtnObj.Err(-5,"","更新灭菌表数据失败")
	
	s SterItmId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSParref",PSterMainId,""))
	i SterItmId'="" d
	.s RtnObj=..UpdateTransAllSterState(PSterMainId,"","N")
	.q:RtnObj.success'=0
	.s RtnObj=..CreateSterPredo(PUserId,gLocId,PSterMainId,PReasonId)
	.q:RtnObj.success'=0
	.s ret=..UpdatePackageSterState(PSterMainId,PReasonId)
	.i ret'=0 d RtnObj.Err(-5,"","更新灭菌明细不合格状态失败！")
	.q:RtnObj.success'=0
	i RtnObj.success'=0 q RtnObj
	
	s MachinePre=""
	i MachineDr'="" d
	.s MachineData=^User.CSSDMachineConfigD(MachineDr)
	.s MachinePre=$lg(MachineData,7)
	
	;验收不合格时，给该批次自动匹配机器文件
	i (FileName="")&&(MachinePre'="") d
	.s Type="sterilizer"
	.s FileData=PSterMainId_"^"_gHospId_"^"_Type
	.s FileTitle="RowIdStr^gHospId^Type"
	.s FileParams=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(FileData,FileTitle)
	.s RtnObj=##class(web.CSSDHUI.MachineData.DataDeal).FileMatch(FileParams)
	
	q RtnObj
}

/// Creator:wn
/// CreatDate:2020.4.10
/// Description对部分明细验收不合格
/// Table:CSSD_SterilizeRecord
/// Input:MainId:灭菌主表id User:验收人 ResonDr:不合格原因dr
/// Output:
/// Return:日志信息
/// w ##class(web.CSSDHUI.PackageSterilize.Sterilize).jsSingleFail("266","1","1","382","495,496")
ClassMethod jsSingleFail(Params) As %String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gUserId = PJObj.%Get("gUserId")
	s gHospId = PJObj.%Get("gHospId")
	s gLocId = PJObj.%Get("gLocId")
	s gGroupId = PJObj.%Get("gGroupId")
	s SterMainId = PJObj.%Get("SterMainId")
	s ReasonId = PJObj.%Get("ReasonId")
	s SterItmIds = PJObj.%Get("ItmIds")
	s IsSterFinish = PJObj.%Get("IsSterFinish")
	i SterMainId="" d RtnObj.Err(-1,"","请选择不合格的灭菌信息!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s CurTime=$P($h,",",2)
	s CurDate=$P($h,",",1)
	s SterMainObj=##Class(User.CSSDSterilizeRecord).%OpenId(SterMainId)
	i '$IsObject(SterMainObj) d RtnObj.Err(-1,"","未获取到灭菌批次信息！")
	q:RtnObj.success'=0 RtnObj.Json()
	
	d SterMainObj.%Reload()
	s IsCmt=SterMainObj.CSSDSRComplateFlag
	s FileName=SterMainObj.CSSDSRFileName
	s IsChk=SterMainObj.CSSDSRIsCHK
	i (IsSterFinish="N")&&(IsCmt'="Y")&&(IsCmt'="F") d RtnObj.Err(-3,"","还未确认灭菌操作！")
	i ((IsSterFinish="Y")&&(IsCmt'="F")) d RtnObj.Err(-3,"","还未进行灭菌完成操作！")
	q:RtnObj.success'=0 RtnObj.Json()
	
	i IsChk'="" d RtnObj.Err(-3,"","已经灭菌验收!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s RtnObj=..CheckInterval(SterMainId)
	q:RtnObj.success'=0 RtnObj.Json()
	
	ts
	s States="N"
	s Len=$L(SterItmIds,",")
	f j=1:1:Len  q:RtnObj.success<0  d
	.s SterItmId=$p(SterItmIds,",",j)
	.s SterItmObj=##class(User.CSSDPackageSterilize).%OpenId(SterItmId)
	.q:'$IsObject(SterItmObj)
	.s ItmStates=SterItmObj.CSSDPSStates
	.i ItmStates'="" d RtnObj.Err(-5,"","该消毒包已灭菌验收，不能重复验收操作！")
	.q:RtnObj.success'=0
	.&sql(Update CSSD_PackageSterilize set CSSDPS_Reason=:ReasonId,CSSDPS_States=:States where CSSDPS_Rowid=:SterItmId)
	.i SQLCODE'=0 d RtnObj.Err(-5,"","更新灭菌明细表失败！")
	.s RtnObj =..UpdateTransAllSterState(SterMainId,SterItmId,"N")
	.q:RtnObj.success'=0
	.s RtnObj=..CreateSingleSterPredo(gUserId,gLocId,SterMainId,SterItmId,ReasonId)
	.q:RtnObj.success'=0
	i RtnObj.success'=0 tro  q RtnObj.Json()
	
	s Ret=..IsAllCheckFail(SterMainId)
	i Ret=0 d
	.&sql(UPDATE CSSD_SterilizeRecord SET CSSDSR_IsCHK='2',CSSDSR_FLAGREASON=:ReasonId,CSSDSR_CheckDate=:CurDate,CSSDSR_CHKTime=:CurTime,CSSDSR_CHKUser_DR=:gUserId where CSSDSR_Rowid=:SterMainId)
	.i SQLCODE'=0 d RtnObj.Err(-9,"","更新灭菌明细表失败！")
	.q:RtnObj.success'=0
	.;部分验收不合格的时候，如果全部部分不合格，需要给该批次自动匹配机器文件
	.i FileName="" d
	..s Type="sterilizer"
	..s FileData=SterMainId_"^"_gHospId_"^"_Type
	..s FileTitle="RowIdStr^gHospId^Type"
	..s FileParams=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(FileData,FileTitle)
	..s RtnObj=##class(web.CSSDHUI.MachineData.DataDeal).FileMatch(FileParams)
	..q:RtnObj.success'=0
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:wn
/// CreatDate:2020.6.1
/// Description:根据灭菌主表ID判断其所有明细是否均为不合格
/// Table:CSSD_SterilizeRecord
/// Input:MainId:灭菌主表id 
/// Output:
/// Return:日志信息
/// w ##class(web.CSSDHUI.PackageSterilize.Sterilize).IsAllCheckFail("153")
ClassMethod IsAllCheckFail(SterMainId As %String) As %String
{
	n (%session,SterMainId)
	s Ret=0
	s SterItmId=""
	f  s SterItmId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSParref",SterMainId,SterItmId)) q:((SterItmId="")||(Ret=1))  d
	.s ItmState=$lg(^User.CSSDPackageSterilizeD(SterItmId),22)
	.s:((ItmState="Y")||(ItmState="")) Ret=1
	q Ret
}

/// Creator:
/// CreatDate:2019.5.7
/// Description:验收合格
/// Table:CSSD_SterilizeRecord
/// Input:MainId:灭菌主表id User:验收人
/// Output:
/// Return:日志信息
/// w ##class(web.CSSDHUI.PackageSterilize.Sterilize).jsOK("")
ClassMethod jsOK(Params As %String) As %String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s RtnObj=..CheckOK(Params)
	q RtnObj.Json()
}

ClassMethod CheckOK(Params As %String) As web.CSSDHUI.RtnObj
{
	n (%session,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","参数解析错误!")
	
	s gUserId = PJObj.%Get("gUserId")
	s PCheckTime = PJObj.%Get("CheckTime")
	s PCheckUserId = PJObj.%Get("CheckUserValue")
	s PSterMainId = PJObj.%Get("SterMainId")
	s PIsSterFinish = PJObj.%Get("IsSterFinish")
	s PRemark = PJObj.%Get("Remark")
	s gHospId = PJObj.%Get("gHospId")
	s gGroupId = PJObj.%Get("gGroupId")
	s gLocId = PJObj.%Get("gLocId")
	s CheckTime=..TH2L(PCheckTime)
	i PSterMainId="" d RtnObj.Err(-1,"","参数是空！")
	q:RtnObj.success'=0 RtnObj
	
	s SterMainObj=##Class(User.CSSDSterilizeRecord).%OpenId(PSterMainId)
	i '$IsObject(SterMainObj) d RtnObj.Err(-1,"","未获取到灭菌批次信息！")
	q:RtnObj.success'=0 RtnObj
	
	d SterMainObj.%Reload()
	s IsChk=SterMainObj.CSSDSRIsCHK
	s IsCmt=SterMainObj.CSSDSRComplateFlag
	s FileName=SterMainObj.CSSDSRFileName
	s PhyResult=SterMainObj.CSSDSRPhyResult
	s CheResult=SterMainObj.CSSDSRCheResult
	s BioResult=SterMainObj.CSSDSRBatLabel
	s MachineDr=SterMainObj.CSSDSRMachineNoDRGetObjectId()
	s BDLabel=SterMainObj.CSSDSRBdLabel
	s LeakLabel=SterMainObj.CSSDSRLeakLabel
	i IsChk'="" q RtnObj.Err(-2,"","已经灭菌验收,请刷新核对！")
	i (PIsSterFinish="N")&&(IsCmt'="Y")&&(IsCmt'="F") q RtnObj.Err(-3,"","还未确认灭菌操作！","",0)
	i ((PIsSterFinish="Y")&&(IsCmt'="F")) q RtnObj.Err(-3,"","还未进行灭菌完成操作！","",0)
	i (PhyResult="2")||(CheResult="2")||(BioResult="2") q RtnObj.Err(-1,"","存在监测不合格记录,不可做灭菌合格验收!","",0)
	
	s RtnObj=..CheckInterval(PSterMainId,CheckTime)
	q:RtnObj.success'=0 RtnObj
	
	s CheckDate=$p($h,",",1)
	i CheckTime="" s CheckTime=$p($h,",",2)
	i PCheckUserId="" s PCheckUserId=gUserId
	s ChkResult=1
	
	ts
	&sql(update cssd_SterilizeRecord set CSSDSR_CHKTime=:CheckTime,CSSDSR_CheckDate=:CheckDate,CSSDSR_CHKUser_DR=:PCheckUserId,
		CSSDSR_IsChk=:ChkResult,CSSDSR_Remark=:PRemark where %ID=:PSterMainId)
	i SQLCODE'=0 tro  q RtnObj.Err(-5,"","灭菌程序报错！")
	
	s retState=..UpdatePackageSterState(PSterMainId,"")
	i retState'=0 tro  q RtnObj.Err(-7,"","更新灭菌明细合格状态失败！")
	
	s RtnObj=..UpdateTransAllSterState(PSterMainId,"","Y")
	i RtnObj.success'=0 tro  q RtnObj
	
	s MachinePre=""
	i MachineDr'="" d
	.s MachineData=^User.CSSDMachineConfigD(MachineDr)
	.s MachinePre=$lg(MachineData,7)
	
	;验收合格的时候，给该批次自动匹配机器文件
	i (FileName="")&&(MachinePre'="") d
	.s Type="sterilizer"
	.s FileData=PSterMainId_"^"_gHospId_"^"_Type
	.s FileTitle="RowIdStr^gHospId^Type"
	.s FileParams=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(FileData,FileTitle)
	.s RtnObj=##class(web.CSSDHUI.MachineData.DataDeal).FileMatch(FileParams)
	.q:RtnObj.success'=0
	i RtnObj.success'=0 tro  q RtnObj
	
	;灭菌验收合格后是否自动生成发放单
	s AppParam=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	s IfAutoDisp=##class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDSTERILIZE","IfAutoCreateDisp",AppParam)
	i (IfAutoDisp="Y")&&(BDLabel'="1")&&(LeakLabel'="1") d
	.s ParamsData=PSterMainId_"^"_gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	.s ParamsTitle="PSterMainId^gGroupId^gLocId^gUserId^gHospId"
	.s Params=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(ParamsData,ParamsTitle)
	.s RtnObj=..CreateDispBySter(Params)
	.i RtnObj.success'=0  tro  d RtnObj.Err(-8,"","自动生成发放单失败！")	
	i RtnObj.success'=0 tro  q RtnObj
	tc
	q RtnObj
}

/// 灭菌验收合格后自动生成发放单
ClassMethod CreateDispBySter(Params As %String) As web.CSSDHUI.RtnObj
{
	n (%session,Params)	
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","参数解析错误!")
	
	s PSterMainId = PJObj.%Get("PSterMainId")
	s gGroupId = PJObj.%Get("gGroupId")
	s gLocId = PJObj.%Get("gLocId")
	s gUserId = PJObj.%Get("gUserId")
	s gHospId = PJObj.%Get("gHospId")

	s DetailId="",ItemData=""
	f  s DetailId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSParref",PSterMainId,DetailId)) q:DetailId=""  d
	.s Label=##class(User.CSSDPackageSterilize).%OpenId(DetailId).CSSDPSLabel
	.s PackId=$o(^User.CSSDPackagePackI("CSSDPPLabelIndex",Label,""))
	.s PackObj=##class(User.CSSDPackagePack).%OpenId(PackId)
	.s CleanId=PackObj.CSSDPPCleanDetailDRGetObjectId()
	.s CBDetailId=##class(User.CSSDCleanDetailPacks).%OpenId(CleanId).CSSDCDPCallBackDetailDrGetObjectId()
	.s CBDetailObj=##class(User.CSSDCallbackDetailNew).%OpenId(CBDetailId)
	.s BackQty=CBDetailObj.CSSDCDQty
	.s PkgId=CBDetailObj.CSSDCDPackageDrGetObjectId()
	.s Material=CBDetailObj.CSSDCDMaterialGetObjectId()
	.s PreDispQty=BackQty ;要发放数量
	.s DispQty=CBDetailObj.CSSDCDDispQty
	.s LevelFlag=CBDetailObj.CSSDCDLevelFlag
	.s CBId=CBDetailObj.CSSDCDParrefGetObjectId()
	.s DetailData=CBDetailId_"^"_BackQty_"^"_PkgId_"^"_Material_"^"_PreDispQty_"^"_DispQty_"^"_LevelFlag_"^"_CBId
	.s DetailTitle="RowId^BackQty^PkgId^Material^PreDispQty^DispQty^LevelFlag^MainId"
	.s ItemDataD=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(DetailData,DetailTitle)
	.i ItemData="" s ItemData=ItemDataD
	.e  s ItemData=ItemDataD_","_ItemData
	s CBDetails="["_ItemData_"]"
	s MainData=gLocId_"^"_gUserId_"^"_gHospId_"^"_gGroupId
	s MainTitle="gLocId^gUserId^gHospId^gGroupId"
	s MainParams=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(MainData,MainTitle)
	s RtnObj=##class(web.CSSDHUI.PackageDisp.Disp).CreateDispByCallBack(MainParams,CBDetails)
	q:RtnObj.success'=0
	
	;发放单加入明细
	s ItemId="",ItemData="",DispMainId="",AttributeId=""
	f  s ItemId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSParref",PSterMainId,ItemId)) q:ItemId=""  d
	.s SterItemObj=##class(User.CSSDPackageSterilize).%OpenId(ItemId)
	.s AttributeId=SterItemObj.CSSDPSPackage.CSSDPPackTypeDetail
	.q:AttributeId="1"
	.s Label=SterItemObj.CSSDPSLabel
	.s PackId=$o(^User.CSSDPackagePackI("CSSDPPLabelIndex",Label,""))
	.s PackObj=##class(User.CSSDPackagePack).%OpenId(PackId)
	.s CleanId=PackObj.CSSDPPCleanDetailDRGetObjectId()
	.s CBDetailId=##class(User.CSSDCleanDetailPacks).%OpenId(CleanId).CSSDCDPCallBackDetailDrGetObjectId()
	.s DispDetailId=$o(^User.CSSDPackageDispI("CSSDPDCallBackDetailIndex",CBDetailId,"")) q:DispDetailId=""
	.s DispMainId=$lg(^User.CSSDPackageDispD(DispDetailId),26)
	.s DispData=Label_"^"_DispDetailId_"^"_gLocId_"^"_gUserId_"^"_gHospId_"^"_gGroupId
	.s DispTitle="Label^DispId^gLocId^gUserId^gHospId^gGroupId"
	.s DispParams=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(DispData,DispTitle)
	.i ItemData="" s ItemData=DispParams
	.e  s ItemData=DispParams_","_ItemData
	s DispDetails="["_ItemData_"]"
	
	i DispDetails'="[]" d
	.s MainData=DispMainId_"^"_gUserId_"^"_gGroupId_"^"_gLocId_"^"_gHospId
	.s MainTitle="MainId^gUserId^gGroupId^gLocId^gHospId"
	.s MainParams=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(MainData,MainTitle)
	.
	.s RtnObj=##class(web.CSSDHUI.PackageDisp.DispDetail).SaveDetail(MainParams,DispDetails)
	q:RtnObj.success'=0
	q RtnObj
}

/// Creator:ban
/// CreatDate:2020.4.9
/// Description:全部灭菌合格或者全部灭菌不合格，更新灭菌明细表合格状态
/// Table:CSSD_PackageSterilize
/// Input:MainId：灭菌主表的dr,ReasonDr：不合格原因Dr
/// Output:
/// Return:日志信息
/// d ##Class(web.CSSDHUI.PackageSterilize.Sterilize).UpdatePackageSterState("33","")
ClassMethod UpdatePackageSterState(SterMainId, ReasonId)
{
	n (%session,SterMainId,ReasonId)
	s err=0
	
	i ReasonId="" d
	.;全部灭菌合格时，需要去掉已部分不合格的明细，不合格的明细，状态值为N，只更新其他明细为合格状态
	.&sql(UPDATE CSSD_PackageSterilize SET CSSDPS_States='Y' 
		where CSSDPS_Parref_DR=:SterMainId and CSSDPS_States IS NULL)
	.i SQLCODE<0 s err=-4
	e  d
	.;全部灭菌不合格时，需要更新所有明细的状态值
	.&sql(UPDATE CSSD_PackageSterilize SET CSSDPS_States='N',CSSDPS_Reason=:ReasonDr
		where CSSDPS_Parref_DR=:SterMainId and CSSDPS_States IS NULL)
	.i SQLCODE<0 s err=-4
	
	q err
}

/// Creator:ban
/// CreatDate:2022.4.14
/// Description:取消验收时，数据状态进行恢复
/// Table:cssd_trans
/// Input:sterMainDr为灭菌主表的dr
/// Output:
/// Return:日志信息
/// d ##Class(web.CSSDHUI.PackageSterilize.Sterilize).CancelUpdateTransState(1)
ClassMethod CancelUpdateTransState(SterMainId) As web.CSSDHUI.RtnObj
{
	n (%session,SterMainId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s SterMainObj=##Class(User.CSSDSterilizeRecord).%OpenId(SterMainId)
	d SterMainObj.%Reload()
	i $IsObject(SterMainObj) s SterLocId=SterMainObj.CSSDSRLocDr.%Id()
	
	s SterItmId=""
	f  s SterItmId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSParref",SterMainId,SterItmId)) q:((SterItmId="")||(RtnObj.success'=0))  d
	.s AllRowId=""
	.s SterItmObj=##Class(User.CSSDPackageSterilize).%OpenId(SterItmId)	//灭菌明细表的实例
	.d SterItmObj.%Reload()
	.s Label=SterItmObj.CSSDPSLabel
	.s PkgObj=SterItmObj.CSSDPSPackage
	.s PkgId=PkgObj.%Id()
	.s PkgClassId=PkgObj.CSSDPPackClassGetObjectId()
	.s TransId=$o(^User.CSSDTransI("CSSDTLabel",Label,""))
	.s State="" 
	.s:TransId'="" State=$lg(^User.CSSDTransD(TransId),8)
	.i State="D" d RtnObj.Err(-1,"","已发放,不能取消验收!") q
	.&sql(update cssd_trans set cssdt_status='SP' where cssdt_label=:Label)
	.i SQLCODE'=0 d RtnObj.Err(-1,"","取消验收操作，更新追踪表状态失败！")
	.q:RtnObj.success'=0
	.
	.s IsExt=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetExtFlag(PkgId)
	.i IsExt="Y" d
	..s FixedLabel=##class(web.CSSDHUI.Common.PackageInfoCommon).GetFixedLabel(Label)
	..s CodeLength=$l(FixedLabel)
	..s WLCodeLabel=$E(Label,1,CodeLength+6)
	..&sql(Update CSSD_ExtDevBind set CSSDExt_Status='P' where CSSDExt_Label=:WLCodeLabel and CSSDExt_Status='S')
	..i ((SQLCODE'=0)&(SQLCODE'=100)) d RtnObj.Err(-1,"","取消验收操作，外来器械更新状态失败！")
	.q:RtnObj.success'=0
	.
	q RtnObj
}

/// Creator:ban
/// CreatDate:2022.4.14
/// Description:取消验收
/// Table:CSSD_SterilizeRecord
/// Input:MainId:灭菌主表id Check:验收类型
/// Output:
/// Return:日志信息
/// w ##class(web.CSSDHUI.PackageSterilize.Sterilize).jsCancel("{""SterInLoc"":""166"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""FStartDate"":""2023-04-17"",""FEndDate"":""2023-04-25"",""MachineNoValue"":"""",""SterProValue"":"""",""QueryState"":"""",""QueryCheck"":"""",""FComplateFlag"":""Y"",""MachineCount"":"""",""Label"":"""",""SterMainId"":""424""}")
ClassMethod jsCancel(Params As %String) As %String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..CancelCheck(Params)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

ClassMethod CancelCheck(Params As %String) As web.CSSDHUI.RtnObj
{
	n (%session,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i Params="" d RtnObj.Err(-1,"","参数是空！")
	q:RtnObj.success'=0 RtnObj
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","参数解析错误!")
	q:RtnObj.success'=0 RtnObj
	
	s PSterMainId = PJObj.%Get("SterMainId")
	
	s SterMainObj=##Class(User.CSSDSterilizeRecord).%OpenId(PSterMainId)
	d SterMainObj.%Reload()
	s IsChk=SterMainObj.CSSDSRIsCHK
	s SterNo=SterMainObj.CSSDSRNo
	s PhyResult=SterMainObj.CSSDSRPhyResult
	s CheResult=SterMainObj.CSSDSRCheResult
	s BatResult=SterMainObj.CSSDSRBatLabel
	s IsPhy=SterMainObj.CSSDSRIsPhy
	s IsChe=SterMainObj.CSSDSRIsChe
	s IsBio=SterMainObj.CSSDSRIsBio
	s SterChkDate=SterMainObj.CSSDSRCheckDate
	s SterChkTime=SterMainObj.CSSDSRCHKTime
	i IsChk="" q RtnObj.Err(-2,"","该灭菌批号未验收，不能取消验收！")
	
	s CurDate=+$h
	s CurTime=$p($h,",",2)
	s DateTime=(CurDate-SterChkDate)*24*60*60
	s Time=CurTime-SterChkTime
	s MinTime=2*24*60*60
	i ((DateTime+Time)>MinTime) q RtnObj.Err(-3,"","灭菌验收超过两天，不允许取消验收操作！")
	
	s SterProId=$o(^User.CSSDSterPrdoI("IndexCSSDSPSterNo",SterNo,""))
	i SterProId'="" d
	.s SterProObj = ##class(User.CSSDSterPrdo).%OpenId(SterProId)
	.s State=SterProObj.CSSDSPStatus
	.i State=1 d RtnObj.Err(-2,"","灭菌对应的不合格登记信息已提交，不能取消验收！") q
	.s SterProItmId=$o(^User.CSSDSterPredoDetailI("IndexMainDr",SterProId,""))
	.i SterProItmId'="" d
	..&sql(DELETE FROM CSSD_SterPredoDetail WHERE CSSDSPD_MainDr=:SterProId)
	..i SQLCODE'=0 d RtnObj.Err(-4,"","取消验收操作，删除不合格登记详情信息报错！") q
	.&sql(DELETE FROM CSSD_SterPredo WHERE ID=:SterProId)
	.i SQLCODE'=0 d RtnObj.Err(-5,"","取消验收操作，删除不合格登记信息报错！") q
	q:RtnObj.success'=0 RtnObj
	
	s (SterItmState,ReasonId)=""
	s SterItmId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSParref",PSterMainId,""))
	i SterItmId'="" d
	.&sql(UPDATE CSSD_PackageSterilize SET CSSDPS_States=:SterItmState,CSSDPS_Reason=:ReasonId where CSSDPS_Parref_DR=:PSterMainId )
	.i SQLCODE'=0 d RtnObj.Err(-6,"","取消验收更新灭菌详情状态报错！")
	q:RtnObj.success'=0 RtnObj
	
	s RtnObj=..CancelUpdateTransState(PSterMainId)
	q:RtnObj.success'=0 RtnObj
	
	s SterMainObj.CSSDSRCHKTime=""
	s SterMainObj.CSSDSRCheckDate=""
	s SterMainObj.CSSDSRCHKUserDR=""
	s SterMainObj.CSSDSRIsCHK=""
	s SterMainObj.CSSDFLAGREASON=""
	s Sc=SterMainObj.%Save()
	i $$$ISERR(Sc) q RtnObj.Err(-5,PSterMainId,"取消验收失败！")
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Creator:
/// CreatDate:2019.5.7
/// Description:确认灭菌操作 更新灭菌时间，已经确认灭菌的，不再更改时间,如果已经最后验收确认，将不允许更改
/// Table:cssd_trans
/// Input:sterMainDr为灭菌主表的dr
/// Output:
/// Return:日志信息
/// w ##Class(web.CSSDHUI.PackageSterilize.Sterilize).jsSetComplete(^tmpbin(1067))
ClassMethod jsSetComplete(Params) As %String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s RtnObj=..SetComplete(Params)
	q RtnObj.Json()
}

ClassMethod SetComplete(Params) As web.CSSDHUI.RtnObj
{
	n (%session,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","参数解析错误!")
	
	s PSterMainId=PJObj.%Get("SterMainId")
	s PSterTime=PJObj.%Get("SterTime")
	s gGroupId=PJObj.%Get("gGroupId")
	s gLocId=PJObj.%Get("gLocId")
	s gUserId=PJObj.%Get("gUserId")
	s gHospId=PJObj.%Get("gHospId")
	s CurDate=+$h
	s CurTime=$p($h,",",2)
	i PSterTime'="" s CurTime=..TH2L(PSterTime)
	i PSterMainId="" q RtnObj.Err(-1,"","入参错误!")
	
	s SterMainObj=##Class(User.CSSDSterilizeRecord).%OpenId(PSterMainId)
	i '$IsObject(SterMainObj) q RtnObj.Err(-2,"","未获取到灭菌信息，请核对!")
	
	d SterMainObj.%Reload()
	s IsChk=SterMainObj.CSSDSRIsCHK
	s IsCmt=SterMainObj.CSSDSRComplateFlag
	s BDLabel=SterMainObj.CSSDSRBdLabel
	s LeakLabel=SterMainObj.CSSDSRLeakLabel
	s MachineId=SterMainObj.CSSDSRMachineNoDRGetObjectId()
	s MachineNo=SterMainObj.CSSDSRMachineNoDR.CSSDMCNum
	s BioTime=SterMainObj.CSSDSRMachineNoDR.CSSDMCBioTime
	s IsBio=SterMainObj.CSSDSRIsBio
	
	i IsChk=1 q RtnObj.Err(-2,"","已经灭菌验收!")
	i IsCmt="Y" q RtnObj.Err(-3,"","已经确认灭菌!")
	
	s ParamsStr=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	s IfOverChkTime=##Class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDSTERILIZE","IfOverChkTime",ParamsStr)
	i IfOverChkTime="Y" d
	.s RtnObj=..IfOverTime(PMachineId,PSterTime)
	q:RtnObj.success'=0 RtnObj
	
	//生物监测周期判断
	i (BioTime'="")&&(IsBio'="Y")&&(BDLabel'=1)&&(LeakLabel'=1) d
	.s RtnObj=..ExistBio(MachineId,BioTime)
	q:RtnObj.success'=0 RtnObj
	
	s ParamsStr=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	s IsSterFinish=##class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDSTERILIZE","IsSterFinish",ParamsStr)
	s ComplateFlag="Y"
	i IsSterFinish="N" s ComplateFlag="F"		;不启用IsSterFinish参数时,自动置为F
	
	s IsBioTest=##class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDSTERILIZE","IsBioTest",ParamsStr)
	i (IsBioTest="Y")&&(IsBio'="Y") d
	.s SterItmId=0,IsExt=""
	.f  s SterItmId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSParref",PSterMainId,SterItmId)) q:(SterItmId="")||(IsExt="Y")  d
	..s SterItmObj=##Class(User.CSSDPackageSterilize).%OpenId(SterItmId)
	..q:'$IsObject(SterItmObj)
	..s BioFlag=SterItmObj.CSSDPSPackage.CSSDPNotBioFlag
	..s:BioFlag="Y" IsBio="Y"
	ts
	s Num=..GetMachineDayCycle(MachineId)
	s Num=Num+1
	i (BDLabel=1)||(LeakLabel=1) s Num=0
	&sql(update cssd_sterilizerecord set CSSDSR_ComplateFlag=:ComplateFlag,CSSDSR_Date=:CurDate,
		CSSDSR_Time=:CurTime,CSSDSR_Num=:Num,CSSDSR_IsBio=:IsBio where CSSDSR_Rowid=:PSterMainId
	)
	i SQLCODE'=0 tro  q RtnObj.Err(-4,"","确认灭菌报错!")
	
	s RtnObj=..UpdateTransSpState(PSterMainId,"SP")
	i RtnObj.success'=0 tro  q RtnObj
	
	tc
	q RtnObj
}

ClassMethod ExistBio(MachineId, BioTime) As web.CSSDHUI.RtnObj
{
	n (MachineId,BioTime)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	
	s CurDate=+$h
	s BioRowId=$o(^User.CSSDSterilizeRecordI("IndexMachineNoDRDateBat",MachineId,CurDate,"Y",""),-1)
	
	i BioTime="0" d
	.d RtnObj.Err(-3,"","该灭菌器需要进行生物监测")
	e  i (BioRowId="")&&(BioTime="1") d
	.d RtnObj.Err(-1,"","该灭菌器当天首次使用需要进行生物监测！") q
	e  i (BioRowId="") d
	.s LastDate=""
	.s SterDate=CurDate+1
	.f  s SterDate=$o(^User.CSSDSterilizeRecordI("IndexMachineNoDRDateBat",MachineId,SterDate),-1) q:(SterDate="")||(LastDate'="")  d
	..s SterId=""
	..f  s SterId=$o(^User.CSSDSterilizeRecordI("IndexMachineNoDRDateBat",MachineId,SterDate,"Y",SterId),-1) q:(SterId="")||(LastDate'="")  d
	...s BatLabel=$lg(^User.CSSDSterilizeRecordD(SterId),12)
	...i (BatLabel=1) s LastDate=SterDate
	.s DifDate=CurDate-LastDate
	.i (BioTime="2")&&(DifDate>=7) d RtnObj.Err(-1,"","该灭菌器每周需要进行生物监测！") q
	.i (BioTime="3")&&(DifDate>=30) d RtnObj.Err(-1,"","该灭菌器每月需要进行生物监测！") q
	e  i (BioRowId'="") d
	.s BioSterRObj=##class(User.CSSDSterilizeRecord).%OpenId(BioRowId)
	.s BioResult= BioSterRObj.CSSDSRBatLabel
	.i BioResult="" d RtnObj.Err(-3,"","前一次生物监测结果未验收") q
	.i BioResult=2 d RtnObj.Err(-3,"","前一次生物监测不合格，请重新监测") q
	.
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Creator:zn
/// CreatDate:2020.4.7
/// Description:取消确认灭菌
/// Table:cssd_sterilizerecord
/// Input:sterMainDr为灭菌主表的dr
/// Output:
/// Return:日志信息
/// d ##Class(web.CSSDHUI.PackageSterilize.Sterilize).jsNotComplete(1)
ClassMethod jsNotComplete(SterMainId As %String) As %String
{
	n (%session,SterMainId)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s RtnObj=..CancelComplete(SterMainId)
	q RtnObj.Json()
}

ClassMethod CancelComplete(SterMainId As %String) As web.CSSDHUI.RtnObj
{
	n (%session,SterMainId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i SterMainId="" q RtnObj.Err(-1,"","入参数是空！")
	
	s SterMainObj=##Class(User.CSSDSterilizeRecord).%OpenId(SterMainId)
	i '$IsObject(SterMainObj) q RtnObj.Err(-2,"","单据不存在,请刷新核实!","",0)
	
	d SterMainObj.%Reload()
	s BDLabel=SterMainObj.CSSDSRBdLabel
	s LeakLabel=SterMainObj.CSSDSRLeakLabel
	s IsChk=SterMainObj.CSSDSRIsCHK
	s IsCmt=SterMainObj.CSSDSRComplateFlag
	s MachineId=SterMainObj.CSSDSRMachineNoDRGetObjectId()
	i IsChk=1 q RtnObj.Err(-3,"","已经灭菌验收,不能撤销灭菌！","",0)
	i IsCmt="N" q RtnObj.Err(-3,"","未确认灭菌,不能撤销灭菌！","",0)
	
	s CurDate=+$h
	s CurTime=$p($h,",",2)
	ts
	s Num=..GetMachineDayCycle(MachineId)
	s Num=Num-1
	i (BDLabel=1)||(LeakLabel=1) s Num=0
	&sql(update cssd_sterilizerecord set CSSDSR_ComplateFlag='N', CSSDSR_Date=:CurDate, 
		CSSDSR_Time=:CurTime,CSSDSR_Num=:Num where CSSDSR_Rowid=:SterMainId
	)
	i SQLCODE'=0 tro  q RtnObj.Err(-4,"","撤销确认灭菌报错!")
	
	s RtnObj=..UpdateTransSpState(SterMainId,"P")
	i RtnObj.success'=0 tro  q RtnObj
	
	tc
	q RtnObj
}

/// Creator:
/// CreatDate:2020.4.7
/// Description:灭菌完成后台方法
/// Table:cssd_sterilizerecord
/// Input:sterMainDr为灭菌主表的dr
/// Output:
/// Return:日志信息
/// d ##Class(web.CSSDHUI.PackageSterilize.Sterilize).jsSetFinish(1)
ClassMethod jsSetFinish(SterMainId As %String) As %String
{
	n (%session,SterMainId)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s RtnObj=..SetFinish(SterMainId)
	q RtnObj.Json()
}

ClassMethod SetFinish(SterMainId As %String) As web.CSSDHUI.RtnObj
{
	n (%session,SterMainId)
	s MethodName=$CLASSNAME()_".SetFinish"
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i SterMainId="" q RtnObj.Err(-1,"","入参数是空！")
	
	s SterMainObj=##Class(User.CSSDSterilizeRecord).%OpenId(SterMainId)
	i '$IsObject(SterMainObj) q RtnObj.Err(-2,"","单据不存在,请刷新核实!","",0)
	
	d SterMainObj.%Reload()
	s IsChk=SterMainObj.CSSDSRIsCHK
	s IsCmt=SterMainObj.CSSDSRComplateFlag
	i IsChk=1 q RtnObj.Err(-2,"","已经灭菌验收！","",0)
	i IsCmt="N" q RtnObj.Err(-3,"","未确认灭菌！","",0)
	i IsCmt="F" q RtnObj.Err(-3,"","已进行灭菌完成操作！","",0)
	
	s CurDate=+$h
	s CurTime=$p($h,",",2)
	&sql(update cssd_sterilizerecord set CSSDSR_ComplateFlag='F', CSSDSR_Date=:CurDate, 
		CSSDSR_Time=:CurTime where CSSDSR_Rowid=:SterMainId
	)
	i SQLCODE'=0 q RtnObj.Err(-3,"","灭菌完成操作失败!")
	q RtnObj
}

/// Creator:
/// CreatDate:2019.5.7
/// Description:删除灭菌单数据-->后期可以考虑有明细的也可以删除(ps 修改打包表里面的是否装车标志)
/// Table:cssd_trans
/// Input:sterMainDr为灭菌主表的dr
/// Output:
/// Return:日志信息
/// d ##class(web.CSSDHUI.PackageSterilize.Sterilize).jsDelete("51")
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

/// Input:		灭菌主表rowid(CSSD_SterilizeRecord)
ClassMethod Delete(SterMainId As %String) As web.CSSDHUI.RtnObj
{
	n (%session,SterMainId)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i SterMainId="" q RtnObj.Err(-1,"","入参不能为空！")
	
	s SterMainObj=##Class(User.CSSDSterilizeRecord).%OpenId(SterMainId)
	i '$IsObject(SterMainObj) q RtnObj.Err(-2,"","单据不存在,请核实!","",0)
	
	d SterMainObj.%Reload()
	s IsChk=SterMainObj.CSSDSRIsCHK
	s IsCmt=SterMainObj.CSSDSRComplateFlag
	s MachineObj=SterMainObj.CSSDSRMachineNoDR
	s OriginalId=SterMainObj.CSSDSRSRDRGetObjectId()
	
	i IsChk=1 q RtnObj.Err(-2,"","已经灭菌验收！","",0)
	i IsCmt="Y" q RtnObj.Err(-3,"","已经确认灭菌！","",0)
	
	s MachineId=MachineObj.%Id()
	s Cycle=MachineObj.CSSDMCCycle-1
	
	ts
	&sql(UPDATE CSSD_PackagePack set CSSDPP_IsLoadSteCar=0
		where CSSDPP_label in (SELECT CSSDPS_Label From CSSD_PackageSterilize Where CSSDPS_Parref_DR=:SterMainId))
	i SQLCODE<0 tro  q RtnObj.Err(-2,RowId,"更新灭菌明细标签状态失败！")
	
	&sql(DELETE FROM CSSD_PackageSterilize WHERE CSSDPS_Parref_DR=:SterMainId)
	i SQLCODE<0 tro  q RtnObj.Err(-3,"","删除明细失败！")
	
	&sql(Delete FROM cssd_sterilizerecord where CSSDSR_Rowid=:SterMainId)
	i SQLCODE'=0 tro  q RtnObj.Err(-4,RowId,"删除灭菌信息失败！")
	
	&sql(UPDATE CSSD_MachineConfig SET CSSDMC_Cycle=:Cycle WHERE ID=:MachineId)
	i SQLCODE'=0 tro  q RtnObj.Err(-5,RowId,"更新灭菌循环次数失败！")
	
	i OriginalId'="" d
	.&sql(UPDATE CSSD_SterilizeRecord SET CSSDSR_WorkStatus=null WHERE CSSDSR_Rowid=:OriginalId)
	.i SQLCODE'=0 d RtnObj.Err(-5,RowId,"更新原有单据失败！")
	i RtnObj.success<0 tro  q RtnObj
	
	tc
	q RtnObj
}

/// Creator:
/// CreatDate:2023.4.23
/// Description:判断灭菌灭菌时间是否大于上一批次的验收时间，参数控制
/// Table:CSSD_MachineConfig,CSSD_SterilizeRecord
/// Input:Params 灭菌主表信息
/// Output:
/// Return:日志信息
/// w ##class(web.CSSDHUI.PackageSterilize.Sterilize).IfOverTime()
ClassMethod IfOverTime(MachineId, PSterTime) As web.CSSDHUI.RtnObj
{
	n (%session,MachineId,PSterTime)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s CurDate=+$h
	
	s SterChkTime=""
	s SterMainId=$o(^User.CSSDSterilizeRecordI("IndexCSSDSRMachineNoDate",MachineId,CurDate,""),-1)
	i SterMainId'="" d
	.s SterChkTime=$lg(^User.CSSDSterilizeRecordD(SterMainId),26)
	.s ifCheck=$lg(^User.CSSDSterilizeRecordD(SterMainId),27)	;灭菌验收状态 null未验收 2 验收不合格 1验收合格
	.i ifCheck="" d RtnObj.Err(-2,"","该灭菌器存在未验收信息！") q
	q:RtnObj.success'=0 RtnObj
	
	i PSterTime'="" d
	.s PSterTime=..TH2L(PSterTime)
	.s CompareSterTimeStr=..TL2H(SterChkTime)
	.i SterChkTime>PSterTime d RtnObj.Err(-3,"","灭菌时间必须大于前一次灭菌验收时间："_CompareSterTimeStr)
	.q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Creator:BAN
/// CreatDate:2021.1.22
/// Description:测漏
/// Table:cssd_sterilizerecord
/// Input:Params 进行测漏的主表入参数据
/// Output:
/// Return:日志信息
/// d ##class(web.CSSDHUI.PackageSterilize.Sterilize).jsLeakTest("{""SterLocId"":""166"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""FStartDate"":""2023-04-22"",""FEndDate"":""2023-04-23"",""MachineNoValue"":""1"",""SterCarValue"":"""",""SterProValue"":""36"",""SterUserValue"":""12763"",""MachineNoSterType"":""20"",""SterTime"":""09:00"",""Label"":""""}")
ClassMethod jsLeakTest(Params As %String) As %String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s RtnObj=..LeakTest(Params)
	q RtnObj.Json()
}

ClassMethod LeakTest(Params As %String) As web.CSSDHUI.RtnObj
{
	n (%session,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!")
	
	s PMachineId=PJObj.%Get("MachineNoValue")
	s PSterUserId=PJObj.%Get("SterUserValue")
	s PSterLocId=PJObj.%Get("SterLocId")
	s PSterCarCode=PJObj.%Get("SterCarValue")
	s PSterProId=PJObj.%Get("SterProValue")
	s PSterTime=PJObj.%Get("SterTime")
	s gHospId=PJObj.%Get("gHospId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gUserId=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s CurDate=+$h
	s CurTime=$p($h,",",2)
	i PSterTime'="" s CurTime=..TH2L(PSterTime)
	
	s ParamsStr=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	s IfOverChkTime=##Class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDSTERILIZE","IfOverChkTime",ParamsStr)
	i IfOverChkTime="Y" d
	.s RtnObj=..IfOverTime(PMachineId,PSterTime)
	q:RtnObj.success'=0 RtnObj
	
	i (PMachineId="")||(PSterLocId="") q RtnObj.Err(-1,"","参数有误!")
	s MachineNo=##class(User.CSSDMachineConfig).%OpenId(PMachineId).CSSDMCNum
	
	s LeakRowId=$o(^User.CSSDSterilizeRecordI("IndexMachineNoDRDateLeak",PMachineId,CurDate,1,""),-1)
	i LeakRowId'="" d
	.s ComplateFlag=$lg(^User.CSSDSterilizeRecordD(LeakRowId),19)
	.i ComplateFlag="N" d RtnObj.Err(-1,"","该灭菌器存在未确认灭菌的测漏记录!")
	.q:RtnObj.success'=0
	.s ifCheck=$lg(^User.CSSDSterilizeRecordD(LeakRowId),27)
	.i ifCheck="" d RtnObj.Err(-2,"","请将测漏记录验收合格！")
	.q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj
	
	s Ret=..sssLock("SterilizeLeak")
	i Ret'=0 q RtnObj.Err(-1,"","生成灭菌批号加锁失败！")
	s SterNo=##class(web.CSSDHUI.Common.AppCommon).GetAppNo("STER",PMachineId,PSterLocId,gHospId,"2")
	i SterNo="" d ..sssUnLock("SterilizeLeak") q RtnObj.Err(-1,"","生成灭菌批号失败！")
	
	ts
	s SterMainObj=##class(User.CSSDSterilizeRecord).%New()
	s SterMainObj.CSSDSRMachineNo=MachineNo
	d SterMainObj.CSSDSRMachineNoDRSetObjectId(PMachineId)
	s SterMainObj.CSSDSRNo=SterNo
	s SterMainObj.CSSDSRDate=CurDate
	s SterMainObj.CSSDSRTime=CurTime
	s SterMainObj.CSSDSRLeakLabel=1
	d SterMainObj.CSSDSRUserDrSetObjectId(PSterUserId)
	d SterMainObj.CSSDSRLocDrSetObjectId(PSterLocId)
	d SterMainObj.CSSDSRProgressDRSetObjectId(PSterProId)
	s SterMainObj.CSSDSRCarLBL=PSterCarCode
	s SterMainObj.CSSDSRFlag=2				//测漏标识为：2
	s SterMainObj.CSSDSRCreateDate=CurDate
	s SterMainObj.CSSDSRCreateTime=CurTime
	s Sc=SterMainObj.%Save()
	d ..sssUnLock("SterilizeLeak")
	i $$$ISERR(Sc) tro  q RtnObj.Err(-5,"","保存失败!")
	s SterMainId=SterMainObj.%Id()
	
	s RtnObj=##class(web.CSSDHUI.System.MachineConfig).UpdateMachineCycle(PMachineId)
	i RtnObj.success'=0 tro  q RtnObj.Err(-6,"",$ClassName()_"jsLeakTest:更新机器灭菌循环次数失败！")
	
	tc
	s RtnObj.rowid=SterMainId
	q RtnObj
}

/// Creator:wn
/// CreatDate:2019.5.7
/// Description:BD测试
/// Table:cssd_sterilizerecord
/// Input:Params 进行BD测试的主表入参数据
/// Output:
/// Return:日志信息
/// d ##class(web.CSSDHUI.PackageSterilize.Sterilize).jsBDTest("{""FStartDate"":""2020-03-05"",""gUserId"":""11354"",""gLocId"":""316"",""gGroupId"":""103"",""gHospId"":""2"",""FEndDate"":""2020-03-06"",""FMachineNo"":"""",""InciId"":"""",""MachineNo"":""04"",""MachineNoValue"":""6"",""SterPro"":""高温灭菌"",""SterProValue"":""5"",""SterCar"":""灭菌车001"",""SterCarValue"":""000009001"",""SterUser"":""Demo Group"",""SterUserValue"":""1""}")
ClassMethod jsBDTest(Params As %String) As %String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s RtnObj=..BDTest(Params)
	q RtnObj.Json()
}

ClassMethod BDTest(Params As %String) As web.CSSDHUI.RtnObj
{
	n (%session,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败！")
	
	s PMachineId=PJObj.%Get("MachineNoValue")
	s PSterUserId=PJObj.%Get("SterUserValue")
	s PSterLocId=PJObj.%Get("SterLocId")
	s gHospId=PJObj.%Get("gHospId")
	s gGroupId = PJObj.%Get("gGroupId")
	s gUserId = PJObj.%Get("gUserId")
	s gLocId = PJObj.%Get("gLocId")
	s PSterCarCode=PJObj.%Get("SterCarValue")
	s PSterProId=PJObj.%Get("SterProValue")
	s PSterTime=PJObj.%Get("SterTime")
	s CurDate=+$h
	s CurTime=$p($h,",",2)
	i PSterTime'="" s CurTime=..TH2L(PSterTime)
	i (PMachineId="")||(PSterLocId="") q RtnObj.Err(-1,"","参数有误!")
	
	s MachineNo=##class(User.CSSDMachineConfig).%OpenId(PMachineId).CSSDMCNum
	s ParamsStr=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	s IfOverChkTime=##Class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDSTERILIZE","IfOverChkTime",ParamsStr)
	i IfOverChkTime="Y" d
	.s RtnObj=..IfOverTime(PMachineId,PSterTime)
	q:RtnObj.success'=0 RtnObj
	
	s SterMainId=$o(^User.CSSDSterilizeRecordI("IndexMachineNoDRDateBD",PMachineId,CurDate,1,""),-1)
	i SterMainId'="" d
	.s ComplateFlag=$lg(^User.CSSDSterilizeRecordD(SterMainId),19)
	.i ComplateFlag="N" d RtnObj.Err(-1,"","该灭菌器存在未确认灭菌的BD记录!")
	.q:RtnObj.success'=0
	.s ifCheck=$lg(^User.CSSDSterilizeRecordD(SterMainId),27)
	.i ifCheck="" d RtnObj.Err(-2,"","请将BD测试记录验收合格！")
	.q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj
	
	s Ret=..sssLock("SterilizeBD")
	i Ret'=0 d RtnObj.Err(-1,"","生成灭菌批号加锁失败！")
	q:RtnObj.success'=0 RtnObj
	
	s SterNo=##class(web.CSSDHUI.Common.AppCommon).GetAppNo("STER",PMachineId,PSterLocId,gHospId,"0")
	i SterNo="" d ..sssUnLock("SterilizeBD") q RtnObj.Err(-1,"","生成灭菌批号失败！")
	
	ts
	s obj=##class(User.CSSDSterilizeRecord).%New()
	s obj.CSSDSRMachineNo=MachineNo
	d obj.CSSDSRMachineNoDRSetObjectId(PMachineId)
	s obj.CSSDSRBDResult=1
	s obj.CSSDSRNo=SterNo
	s obj.CSSDSRDate=CurDate
	s obj.CSSDSRTime=CurTime
	s obj.CSSDSRBdLabel=1
	d obj.CSSDSRUserDrSetObjectId(PSterUserId)
	d obj.CSSDSRLocDrSetObjectId(PSterLocId)
	d obj.CSSDSRProgressDRSetObjectId(PSterProId)
	s obj.CSSDSRCarLBL=PSterCarCode
	s obj.CSSDSRFlag=0				//BD标识为：0
	s obj.CSSDSRCreateDate=CurDate
	s obj.CSSDSRCreateTime=CurTime
	s Sc=obj.%Save()
	d ..sssUnLock("SterilizeBD")
	i $$$ISERR(Sc) tro  q RtnObj.Err(-5,"","保存失败！")
	s RowId=obj.%Id()
	
	s RtnObj=##class(web.CSSDHUI.System.MachineConfig).UpdateMachineCycle(PMachineId)
	i RtnObj.success'=0 tro  q RtnObj.Err(-6,"",$ClassName()_"jsBDTest:更新机器灭菌循环次数失败！")
	
	tc
	s RtnObj.rowid=RowId
	q RtnObj
}

/// CreatDate:	2022-03-29
/// Description:灭菌监测(物理,化学,生物)
/// Input:		Params({RowId:灭菌单据id, MonitorType:监测类型}
/// Output:
/// Return:日志信息
ClassMethod jsSetMonitor(Params As %String) As %String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s RtnObj=..SetMonitor(Params)
	q RtnObj.Json()
}

ClassMethod SetMonitor(Params As %String) As web.CSSDHUI.RtnObj
{
	n (%session,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s MethodName=$CLASSNAME()_".SetMonitor"
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_"参数解析错误!")
	
	s SterMainId=PJObj.%Get("SterMainId")
	s MonitorType=PJObj.%Get("MonitorType")
	i $lf($lb("Phy","Che","Bio"),MonitorType)'>0 q RtnObj.Err(-1,"",MethodName_"参数错误!")
	
	s SterMainObj=##Class(User.CSSDSterilizeRecord).%OpenId(SterMainId)
	i '$IsObject(SterMainObj) q RtnObj.Err(-1,"","未获取到灭菌批次信息!","",0)
	
	d SterMainObj.%Reload()
	s IsCheck=SterMainObj.CSSDSRIsCHK
	s IsPhy=SterMainObj.CSSDSRIsPhy
	s IsChe=SterMainObj.CSSDSRIsChe
	s IsBio=SterMainObj.CSSDSRIsBio
	i IsCheck="Y" q RtnObj.Err(-1,"","已开始灭菌,无法添加监测!","",0)
	i (MonitorType="Phy")&&(IsPhy="Y") q RtnObj.Err(-2,"","物理监测已开启！","",0)
	i (MonitorType="Che")&&(IsChe="Y") q RtnObj.Err(-2,"","化学监测已开启！","",0)
	i (MonitorType="Bio")&&(IsBio="Y") q RtnObj.Err(-2,"","生物监测已开启！","",0)
	i MonitorType="Phy" d
	.s SterMainObj.CSSDSRIsPhy="Y"
	e  i MonitorType="Che" d
	.s SterMainObj.CSSDSRIsChe="Y"
	e  i MonitorType="Bio" d
	.s SterMainObj.CSSDSRIsBio="Y"
	s Sc=SterMainObj.%Save()
	i $$$ISERR(Sc) q RtnObj.Err(-5,RowId,MethodName_"监测错误!")
	
	q RtnObj
}

/// Creator:ban
/// CreatDate:2023.4.20
/// Description:取消监测
/// Table:CSSD_SterilizeRecord
/// Input:MainId:灭菌主表id Check:监测类型
/// Output:
/// Return:日志信息
/// w ##class(web.CSSDHUI.PackageSterilize.Sterilize).jsCancelMonitor("{""CheckUserValue"":"""",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""UnqualifiedReason"":"""",""Check"":""1"",""CheckTime"":"""",""FileSel"":"""",""SterMainId"":""432""}")
ClassMethod jsCancelMonitor(Params As %String) As %String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..CancelMonitor(Params)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

ClassMethod CancelMonitor(Params As %String) As web.CSSDHUI.RtnObj
{
	n (%session,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i Params="" d RtnObj.Err(-1,"","参数是空！")
	q:RtnObj.success'=0 RtnObj
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","参数解析错误!")
	q:RtnObj.success'=0 RtnObj
	
	s PSterMainId = PJObj.%Get("SterMainId")
	s PCheck = PJObj.%Get("Check")
	
	s SterMainObj=##Class(User.CSSDSterilizeRecord).%OpenId(PSterMainId)
	d SterMainObj.%Reload()
	s IsChk=SterMainObj.CSSDSRIsCHK
	s SterNo=SterMainObj.CSSDSRNo
	s PhyResult=SterMainObj.CSSDSRPhyResult
	s CheResult=SterMainObj.CSSDSRCheResult
	s BatResult=SterMainObj.CSSDSRBatLabel
	s IsPhy=SterMainObj.CSSDSRIsPhy
	s IsChe=SterMainObj.CSSDSRIsChe
	s IsBio=SterMainObj.CSSDSRIsBio
	i ((PCheck="3")&&(IsPhy="N")) q RtnObj.Err(-2,"","物理监测未开启！","",0)
	i ((PCheck="3")&&(IsPhy="Y")&&(PhyResult="")) q RtnObj.Err(-1,"","未进行物理监测验收，不能取消监测操作!","",0)
	i ((PCheck="2")&&(IsChe="N")) q RtnObj.Err(-2,"","化学监测未开启！","",0)
	i ((PCheck="2")&&(IsChe="Y")&&(CheResult="")) q RtnObj.Err(-1,"","未进行化学监测验收，不能取消监测操作!","",0)
	i ((PCheck="1")&&(IsBio="N")) q RtnObj.Err(-2,"","生物监测未开启！","",0)
	i ((PCheck="1")&&(IsBio="Y")&&(BatResult="")) q RtnObj.Err(-1,"","未进行生物监测验收，不能取消监测操作!","",0)
	
	i (PCheck=1) d
	.s SterMainObj.CSSDSRBatLabel=""
	.s MonitorType="Bio"
	e  i (PCheck=2) d
	.s MonitorType="Che"
	.s SterMainObj.CSSDSRCheResult=""
	e  i (PCheck=3) d
	.s SterMainObj.CSSDSRPhyResult=""
	.s MonitorType="Phy"
	&sql(Delete from CSSD_SterilizeMonitor where SM_ParRef=:PSterMainId and SM_Type=:MonitorType)
	i SQLCODE'=0 d RtnObj.Err(-2,"","取消监测失败！")
	q:RtnObj.success'=0 RtnObj
	
	s Sc=SterMainObj.%Save()
	i $$$ISERR(Sc) q RtnObj.Err(-3,"","取消监测，状态更新失败！")
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// CreatDate:	2022-03-24
/// Description:物理/化学/生物监测
/// Input:		Params(MonitorType:监测类型, CheckResult:合格/不合格)
/// w ##class(web.CSSDHUI.PackageSterilize.Sterilize).jsCheckMonitor("{""MonitorType"":""Bio"",""CheckResult"":""1"",""SterMainId"":""285"",""CheckUserId"":"""",""CheckTime"":"""",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}")
ClassMethod jsCheckMonitor(Params) As %String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..CheckMonitor(Params)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// 监测效果验收
ClassMethod CheckMonitor(Params) As web.CSSDHUI.RtnObj
{
	n (%session,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s MethodName=$CLASSNAME()_".CheckMonitor"
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_"参数解析错误!")
	
	s PMonitorType=PJObj.%Get("MonitorType")
	s PCheckResult=PJObj.%Get("CheckResult")
	s PSterMainId=PJObj.%Get("SterMainId")
	s PCheckUserId=PJObj.%Get("CheckUserId")
	s PCheckTime=PJObj.%Get("CheckTime")
	s gUserId=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gHospId=PJObj.%Get("gHospId")
	i $lf($lb("Phy","Che","Bio"),PMonitorType)'>0 q RtnObj.Err(-1,"",MethodName_"参数错误!")
	i PSterMainId="" q RtnObj.Err(-1,"",MethodName_"参数错误！")
	s CheckTime=..TH2L(PCheckTime)
	
	s SterMainObj=##Class(User.CSSDSterilizeRecord).%OpenId(PSterMainId)
	q:'$IsObject(SterMainObj) RtnObj.Err(-1,"","灭菌单已删除!")
	
	d SterMainObj.%Reload()
	s IsPhy=SterMainObj.CSSDSRIsPhy
	s IsChe=SterMainObj.CSSDSRIsChe
	s IsBio=SterMainObj.CSSDSRIsBio
	s PhyResult=SterMainObj.CSSDSRPhyResult
	s CheResult=SterMainObj.CSSDSRCheResult
	s BioResult=SterMainObj.CSSDSRBatLabel
	s IsCHK=SterMainObj.CSSDSRIsCHK
	i IsCHK=2 q RtnObj.Err(-1,"","已验收不合格，不能进行监测合格！","",0)
	i (PMonitorType="Phy")&&(IsPhy'="Y") q RtnObj.Err(-2,"","物理监测未开启！","",0)
	i (PMonitorType="Phy")&&(PhyResult'="") q RtnObj.Err(-1,"","已进行物理监测验收!","",0)
	i (PMonitorType="Che")&&(IsChe'="Y") q RtnObj.Err(-2,"","化学监测未开启！","",0)
	i (PMonitorType="Che")&&(CheResult'="") q RtnObj.Err(-1,"","已进行化学监测验收!","",0)
	i (PMonitorType="Bio")&&(IsBio'="Y") q RtnObj.Err(-2,"","生物监测未开启！","",0)
	i (PMonitorType="Bio")&&(BioResult'="") q RtnObj.Err(-1,"","已进行生物监测验收!","",0)
	s RtnObj=..CheckInterval(PSterMainId,CheckTime)
	i RtnObj.success<0 q RtnObj
	
	s MonitorLevel=1
	s AppParam=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	i PMonitorType="Bio" d
	.s BioDoubleCheck=##Class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDSTERILIZE","BioDoubleCheck",AppParam)
	.i BioDoubleCheck="Y" s MonitorLevel=2
	
	s Level=+$o(^User.CSSDSterilizeMonitorI("TypeLevel",PSterMainId,PMonitorType,""),-1)
	s NewLevel=Level+1
	s CheckDate=$p($h,",",1)
	i CheckTime="" s CheckTime=$p($h,",",2)
	i PCheckUserId="" s PCheckUserId=gUserId
	s MonitorObj=##Class(User.CSSDSterilizeMonitor).%New()
	d MonitorObj.SMParRefSetObjectId(PSterMainId)
	s MonitorObj.SMType=PMonitorType
	d MonitorObj.SMUserDRSetObjectId(PCheckUserId)
	s MonitorObj.SMDate=CheckDate
	s MonitorObj.SMTime=CheckTime
	s MonitorObj.SMAuditFlag=PCheckResult
	s MonitorObj.SMLevel=NewLevel
	s Sc=MonitorObj.%Save()
	i $$$ISERR(Sc) d RtnObj.Err(-5,RowId,MethodName_"监测记录错误!")
	q:RtnObj.success'=0 RtnObj
	
	//当前监测全部完成
	i NewLevel=MonitorLevel d
	.s NoOkMonitorChl=$o(^User.CSSDSterilizeMonitorI("TypeAudit",PSterMainId,PMonitorType,2,0))
	.s AuditFlag="1"
	.i NoOkMonitorChl'="" s AuditFlag="2"
	.i PMonitorType="Phy" d
	..s SterMainObj.CSSDSRPhyResult=AuditFlag
	.e  i PMonitorType="Che" d
	..s SterMainObj.CSSDSRCheResult=AuditFlag
	.e  i PMonitorType="Bio" d
	..s SterMainObj.CSSDSRBatLabel=AuditFlag
	.s Sc=SterMainObj.%Save()
	.i $$$ISERR(Sc) d RtnObj.Err(-5,PSterMainId,MethodName_"监测错误!")
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Creator:lxt
/// CreateDate:20220517
/// Description:通过监测类型和灭菌单id获取监测结果
/// Table:CSSD_SterilizeMonitor
/// Input:监测类型和灭菌单id
/// Output:监测验收人员^最后一次验收时间
ClassMethod GetMonitorInfo(MonitorType, SterMainId)
{
	n (%session,MonitorType,SterMainId)
	q:(MonitorType="")||(SterMainId)="" ""
	
	s Chl=0,UserNameStr="",LastTimeStr=""
	f  s Chl=$o(^User.CSSDSterilizeMonitorI("Type",SterMainId,MonitorType,Chl)) q:Chl=""  d
	.s MonitorRowId=SterMainId_"||"_Chl
	.s MonitorObj=##Class(User.CSSDSterilizeMonitor).%OpenId(MonitorRowId)
	.q:'$IsObject(MonitorObj)
	.d MonitorObj.%Reload()
	.s UserId=MonitorObj.SMUserDRGetObjectId()
	.s Date=..DL2H(MonitorObj.SMDate)
	.s Time=..TL2H(MonitorObj.SMTime)
	.s UserName=..sssUserName(UserId)
	.i UserNameStr="" s UserNameStr=UserName
	.e  s UserNameStr=UserNameStr_","_UserName
	.s LastTimeStr=Date_" "_Time
	.
	q UserNameStr_"^"_LastTimeStr
}

/// Creator:	wangjiabin
/// CreatDate:	2022-03-24
/// Description:检查灭菌时长
/// Input:		RowId-灭菌单id
/// Output:
/// w ##class(web.CSSDHUI.PackageSterilize.Sterilize).CheckInterval("162","54332")
ClassMethod CheckInterval(SterMainId, CheckTime As %String = "") As web.CSSDHUI.RtnObj
{
	n (%session,SterMainId,CheckTime)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	q:SterMainId="" RtnObj.Err(-1,"","CheckInterval参数错误!")
	
	s SterDate=$lg(^User.CSSDSterilizeRecordD(SterMainId),2)
	s SterTime=$lg(^User.CSSDSterilizeRecordD(SterMainId),8)
	s LocId=$lg(^User.CSSDSterilizeRecordD(SterMainId),17)
	s SterProId=$lg(^User.CSSDSterilizeRecordD(SterMainId),36)
	
	s CurDate=+$h,CurTime=$p($h,",",2)
	s:CheckTime'="" CurTime=CheckTime
	s DateTime=(CurDate-SterDate)*24*60*60
	s Time=CurTime-SterTime
	
	s ProInterval=$lg(^User.CSSDBaseCodeD(SterProId),9)
	i ProInterval'="" d
	.s MinTime=ProInterval*60
	e  d
	.s ParamsStr="^"_LocId_"^^"		;此参数按科室或医院即可
	.s MinTime=##Class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDSTERILIZE","MinInterval",ParamsStr)*60
	
	i ((DateTime+Time)<0) q RtnObj.Err(-4,"","验收时间不能早于灭菌时间！")
	i ((DateTime+Time)<MinTime) q RtnObj.Err(-4,"","灭菌时间间隔过短！")
	q RtnObj
}

/// Creator:why
/// CreatDate:2021.7.21
/// Descript:灭菌主表
/// Table:CSSD_SterilizeRecord
/// Input: Params:所要修改的明细行 
/// Output:
/// Return:
/// d ##class(web.CSSDHUI.PackageSterilize.Sterilize).jsUpdateSterInfo("[{""RowId"":""267"",""PackageDR"":""748"",""PackageName"":""EHB-二号包"",""Qty"":""2"",""Remark"":"""",""RemarkInfo"":""123""}]")
ClassMethod jsUpdateSterInfo(Params) As %Library.String
{
	n (%session,Params)
	s $ZT=..sssError()
	ts
	s RtnObj=..UpdateSterInfo(Params)
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

ClassMethod UpdateSterInfo(Params) As web.CSSDHUI.RtnObj
{
	n (%session,Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s RowId=Obj.%Get("RowId")
		s Temperature=Obj.%Get("Temperature")
		s Pressure=Obj.%Get("Pressure")
		s UsedTime=Obj.%Get("UsedTime")
		s ThreeMResult=Obj.%Get("NotUseFlag")
		&sql(UPDATE CSSD_SterilizeRecord SET CSSDSR_Temperature=:Temperature,CSSDSR_Pressure=:Pressure,CSSDSR_ThreeMResult=:ThreeMResult,CSSDSR_UsedTime=:UsedTime where CSSDSR_Rowid=:RowId)
		i SQLCODE'=0 d RtnObj.Err(-2,"",$ClassName()_"Update:保存失败!")
		continue:RtnObj.success'=0
	}
	q RtnObj
}

ClassMethod UpdateTransSpState(SterMainId, State) As web.CSSDHUI.RtnObj
{
	n (%session,SterMainId,State)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s SterMainObj=##Class(User.CSSDSterilizeRecord).%OpenId(SterMainId)
	i '$IsObject(SterMainObj) q RtnObj.Err(-1,"","未获取到灭菌信息!")
	
	s SterItmId=""
	f  s SterItmId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSParref",SterMainId,SterItmId)) q:(SterItmId="")||(RtnObj.success'=0)  d
	.s SterItmObj=##Class(User.CSSDPackageSterilize).%OpenId(SterItmId)	//灭菌明细表的实例
	.d SterItmObj.%Reload()
	.s Label=SterItmObj.CSSDPSLabel
	.s TransId=$o(^User.CSSDTransI("CSSDTLabel",Label,""))
	.i TransId="" d RtnObj.Err(-1,"","未找到标签对应的追踪表信息!")
	.q:RtnObj.success'=0
	.&sql(UPDATE CSSD_Trans Set CSSDT_Status=:State where CSSDT_Label=:Label)
	.i SQLCODE d RtnObj.Err(-2,"","更新追踪表标签状态失败！")
	
	q RtnObj
}

/// Description:判断标签是否正在灭菌过程中
/// Creator：lxt
/// CreateDate：20220615
ClassMethod CheckLabelSterIng(Label)
{
	n (%session,Label)
	
	s SterId=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSLabel",Label,""),-1)
	q:SterId="" "N"
	
	s SterObj=##class(User.CSSDPackageSterilize).%OpenId(SterId)
	q:'$IsObject(SterObj) "N"
	
	s SterRId=SterObj.CSSDPSParref.CSSDSRIsCHK
	q:SterRId'="" "N"
	
	q "Y"
}

/// Description:计算灭菌界面-待灭菌角标数量
/// Creator:
/// Date:20221218
/// Table:
/// Input:Params
/// Output:Json
/// w ##class(web.CSSDHUI.PackageSterilize.Sterilize).GetMarkQty("{""FStartDate"":""2023-01-04"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""SterLocId"":""166"",""FEndDate"":""2023-01-05"",""MachineNoValue"":"""",""SterCarValue"":"""",""SterProValue"":"""",""SterUserValue"":"""",""BoiValue"":"""",""MachineNoSterType"":"""",""SterWay"":"""",""SterProWay"":"""",""SterTime"":""""}","1")
ClassMethod GetMarkQty(Params As %String, MachineId As %String)
{
	n (%session,Params,MachineId)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q "{}"
	
	s PStartDate = PJObj.%Get("FStartDate")
	s PEndDate = PJObj.%Get("FEndDate")
	s gHospId = PJObj.%Get("gHospId")
	s gGroupId = PJObj.%Get("gGroupId")
	s gLocId = PJObj.%Get("gLocId")
	s gUserId = PJObj.%Get("gUserId")
	s Data=PStartDate_"^"_PEndDate_"^"_MachineId_"^"_gHospId_"^"_gGroupId_"^"_gLocId_"^"_gUserId
	s SterTitle="StartDate^EndDate^MachineNoDR^gHospId^gGroupId^gLocId^gUserId"
	s SterParams=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,SterTitle)
	s SterNum=0
	
	s SterResult=##class(%Library.ResultSet).%New("web.CSSDHUI.PackageSterilize.SterilizeCar:SelectAllWaitingSter") ;待灭菌包
	s sc=SterResult.Execute(SterParams)
	i $$$ISERR(sc) q "{}"
	
	While(SterResult.Next()){s SterNum=SterNum+1}
	d SterResult.Close()
	
	q SterNum
}

/// Description:判断当前标签是否存在当前灭菌单
/// Creator:DYL
/// CreatDate:2023-04-18
/// Input:灭菌主单id，标签
/// OutPut:Y-存在，N-不存在
ClassMethod IFLabelBySterDetail(SterId, PLabel) As %String
{
	n (SterId,PLabel)
	s Flag="N"
	
	s Label=""
	f  s Label=$o(^User.CSSDPackageSterilizeI("IndexCSSDPSParrefLabel",SterId,Label)) q:((Label="")||(Flag="Y"))  d
	.i (Label[PLabel) s Flag="Y"
	q Flag
}

}
