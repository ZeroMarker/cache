Import sqluser

/// Descript:应用程序设置相关的公共方法
/// Creater:    WFG
/// CreateDate: 2019-4-22
Class web.CSSDHUI.Common.AppCommon Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "CSSDCOMMON";

/// Description: 取业务单号-可供外部程序调用
/// Input:      AppName-程序名称,类组id,科室id
/// Return:     单号
ClassMethod GetAppNo(AppName As %String, machineNoDR As %String = "", gLocId As %String = "", gHospId As %String = "", Flag As %String = "") As %Library.String
{
	N (AppName,machineNoDR,gLocId,gHospId,Flag)
	s No=""
	I AppName="STER" D
	.s No=..CreateSterilizeNo(machineNoDR,gLocId,gHospId,Flag)
	i AppName="STERFIAL" D
	.s No=..CreateApplyNoPredoSter()
	i AppName="CLEANFIAL" D
	.s No=..CreateCleanNoPredoSter()
	i AppName="Apply" D
	.s No=..CreateApplyNo()
	i AppName="CallBack" d
	.s No=..CreateCallbackNo()
	i AppName="Disp" d
	.s No=..CreateDispNo()
	i AppName="Ullage" d
	.s No=..CreateUllageNo()
	i AppName="CSSDFTPFILEM" d
	.s No=..CreateFTPNo()
	Q No
}

ClassMethod CreateFTPNo()
{
	n
	s Date=+$h
	s Today=$zd(Date,3)
	s Year=$p(Today,"-",1)
	s Month=$p(Today,"-",2)
	s Day=$p(Today,"-",3)
	
	s FileSrc=$o(^CT.STER.CSSD.CommonFileI("DateSrc",Date,""),-1)
	s FileNum=+$e(FileSrc,9,13)
	i FileNum=0 s FileNum=1
	e  s FileNum=FileNum+1
	
	s No=Year_Month_Day_$tr($j(FileNum,5)," ","0")
	
	q No
}

/// 创建发放单号
/// w ##class(web.CSSDHUI.Common.AppCommon).CreateDispNo()
ClassMethod CreateDispNo() As %String [ Private ]
{
	s date=$zd(+$h,8)
	s pre="D"_date
	s MaxId=$o(^User.CSSDPackageDispMainD(""),-1)
	s maxNo=""
	i MaxId="" d
	.s maxNo=""
	e  d
	.s maxNo=$List(^User.CSSDPackageDispMainD(MaxId),4)
	.s tmpPre=$E(maxNo,1,9)
	.i pre'=tmpPre d
	..s maxNo=""
	s dispNo=+$e(maxNo,$l(maxNo)-2,$l(maxNo))
	s dispNo=dispNo+1
	s dispNo=$tr($j(dispNo,3)," ","0")
	s dispNo=pre_dispNo
	q dispNo
}

/// 灭菌批号生成规则：Type【BD 0 正常 1 测漏 2】 BD 001 002 003 正常 101 102 103 测漏 201 202 203 
/// w ##class(web.CSSDHUI.Common.AppCommon).CreateSterilizeNo("101")
ClassMethod CreateSterilizeNo(machineNoDr As %Integer, gLocId As %String, gHospId As %String, Flag As %String) As %String
{
	n (machineNoDr,gLocId,gHospId,Flag)
	s date=$zd(+$h,8)
	s dateday=+$h
	s Machineobj=##class(User.CSSDMachineConfig).%OpenId(machineNoDr)
	d Machineobj.%Reload()
	s machineNo=Machineobj.CSSDMCNum
	s MaxId=$o(^User.CSSDSterilizeRecordI("MachineDateLocFlag",machineNoDr,dateday,gLocId,Flag,""),-1)
	s machineNo=$tr($j(machineNo,3)," ","0") 
	s pre=date_machineNo_gHospId_Flag	;20210429101   101
	s maxNo=""
	i MaxId="" d
	.s maxNo=""
	e  d
	.s maxNo=$List(^User.CSSDSterilizeRecordD(MaxId),4)	;20210429101001
	.s tmpPre=$E(maxNo,1,11)_gHospId_Flag	;20210429101
	.i pre'=tmpPre d
	..s maxNo=""
	s No=+$e(maxNo,$l(maxNo)-1,$l(maxNo))	;取当前灭菌批号最后三位
	s No=No+1
	s No=$tr($j(No,2)," ","0")				;把空格转成0 ,比如"  3" 会转成"003"
	s No=pre_No
	q No
}

/// 灭菌不合格单号
/// w ##class(web.CSSDHUI.Common.AppCommon).CreateApplyNoPredoSter()
ClassMethod CreateApplyNoPredoSter() As %String
{
	new
	s date=$zd(+$h,8)
	s pre=$e(date,1,6)    
	s MaxId=$o(^User.CSSDSterPrdoD(""),-1)
	s maxNo=""
	i MaxId="" d
	.s maxNo=""
	e  d
	.s maxNo=$List(^User.CSSDSterPrdoD(MaxId),2)
	.s tmpPre=$E(maxNo,1,6)
	.i pre'=tmpPre d
	..s maxNo=""
	s ApplyNo=+$e(maxNo,$l(maxNo)-4,$l(maxNo))
	s ApplyNo=ApplyNo+1
	s ApplyNo=$tr($j(ApplyNo,5)," ","0")
	s ApplyNo=pre_ApplyNo
	q ApplyNo
}

/// 清洗不合格单号
/// w ##class(web.CSSDHUI.Common.AppCommon).CreateApplyNoPredoSter()
ClassMethod CreateCleanNoPredoSter() As %String [ Private ]
{
	new
	s date=$zd(+$h,8)
	s pre=$e(date,1,6)
	s MaxId=$o(^User.CSSDUsedPrdoD(""),-1)
	s maxNo=""
	i MaxId="" d
	.s maxNo=""
	e  d
	.s maxNo=$List(^User.CSSDUsedPrdoD(MaxId),2)
	.s tmpPre=$E(maxNo,1,6)
	.i pre'=tmpPre d
	..s maxNo=""
	s CleanNo=+$e(maxNo,$l(maxNo)-4,$l(maxNo))
	s CleanNo=CleanNo+1
	s CleanNo=$tr($j(CleanNo,5)," ","0")
	s CleanNo=pre_CleanNo
	q CleanNo
}

/// 请领单号
ClassMethod CreateApplyNo() As %String [ Private ]
{
	new
	s date=$zd(+$h,8)
	s pre=$e(date,1,6)
	s MaxId=$o(^User.CSSDPackageApplyD(""),-1)
	s maxNo=""
	i MaxId="" d
	.s maxNo=""
	e  d
	.s maxNo=$List(^User.CSSDPackageApplyD(MaxId),5)
	.s tmpPre=$E(maxNo,1,6)
	.i pre'=tmpPre d
	..s maxNo=""
	s ApplyNo=+$e(maxNo,$l(maxNo)-4,$l(maxNo))
	s ApplyNo=ApplyNo+1
	s ApplyNo=$tr($j(ApplyNo,5)," ","0")
	s ApplyNo=pre_ApplyNo
	q ApplyNo
}

/// 回收单号
ClassMethod CreateSerialNo() As %String [ Private ]
{
	new
	s date=$zd(+$h,8)
	s pre=$e(date,1,6)
	s MaxId=$o(^User.CSSDPackageCallbackD(""),-1)
	s maxNo=""
	i MaxId="" d
	.s maxNo=""
	e  d
	.s maxNo=$List(^User.CSSDPackageCallbackD(MaxId),8)
	.s tmpPre=$E(maxNo,1,6)
	.i pre'=tmpPre d
	..s maxNo=""
	s SerialNo=+$e(maxNo,$l(maxNo)-4,$l(maxNo))
	s SerialNo=SerialNo+1
	s SerialNo=$tr($j(SerialNo,5)," ","0")
	s SerialNo=pre_SerialNo
	q SerialNo
}

/// 标牌追溯包回收标签
ClassMethod CreateCallbackNo() As %String [ Private ]
{
	new
	s date=$zd(+$h,8)
	s pre="C"_date
	s MaxId=$o(^User.CSSDPackageCallbackD(""),-1)
	s maxNo=""
	i MaxId="" d
	.s maxNo=""
	e  d
	.s maxNo=$List(^User.CSSDPackageCallbackD(MaxId),8)
	.s tmpPre=$E(maxNo,1,9)
	.i pre'=tmpPre d
	..s maxNo=""
	s callbackNo=+$e(maxNo,$l(maxNo)-2,$l(maxNo))
	s callbackNo=callbackNo+1
	s callbackNo=$tr($j(callbackNo,3)," ","0")
	s callbackNo=pre_callbackNo
	q callbackNo
}

/// 报损单号
/// w ##class(web.CSSDHUI.Common.AppCommon).CreateUllageNo()
ClassMethod CreateUllageNo() As %String
{
	new
	s date=$zd(+$h,8)
	s pre=$e(date,1,6)
	s MaxId=$o(^User.CSSDUllageD(""),-1)
	s maxNo=""
	i MaxId="" d
	.s maxNo=""
	e  d
	.s maxNo=$List(^User.CSSDUllageD(MaxId),2)
	.s tmpPre=$E(maxNo,1,6)
	.i pre'=tmpPre d
	..s maxNo=""
	s UllageNo=+$e(maxNo,$l(maxNo)-4,$l(maxNo))
	s UllageNo=UllageNo+1
	s UllageNo=$tr($j(UllageNo,5)," ","0")
	s UllageNo=pre_UllageNo
	q UllageNo
}

/// 根据AppName,获取相应参数值
/// wfg 2019-7-29
/// Input:AppName,Param(安全组id^科室id^人员id)
/// w ##class(web.CSSDHUI.Common.AppCommon).GetAppPropStr("CSSDDISP")
ClassMethod GetAppPropStr(AppName As %String, Param As %String) As %String
{
	n (AppName,Param)
	q:AppName="" "{}"
	s AppId=..GetAppID(AppName)
	q:AppId="" "{}"
	;s LocId=$p(Param,"^",2)
	;s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
	s gHospId =$p(Param,"^",4)

	s PropValueStr=""
	s APCh=""
	f  s APCh=$o(^User.CSSDParameterI("IndexCSSDPCType",AppId,APCh)) q:APCh=""  d
	.s APCode=$li(^User.CSSDParameterD(APCh),2)
	.s APValue=..GetParamValue(AppName,APCode,Param)
	.i APCode="FtpPassword" d
	..s APValue=##class(web.CSSDHUI.Common.UtilCommon).DecryptPW(APValue)
	.s APValueStr=$c(34)_APCode_$c(34)_":"_$c(34)_APValue_$c(34)
	.
	.i PropValueStr="" d
	..s PropValueStr=APValueStr
	.e  d
	..s PropValueStr=PropValueStr_","_APValueStr

	s Ret="{"_PropValueStr_"}"
	q Ret
}

/// litongxun
/// w ##class(web.CSSDHUI.Common.AppCommon).GetParamValue("CSSDAPPLAY","AutAuditAfterSub","102^166^11889^2")
ClassMethod GetParamValue(AppCode As %String, APCode As %String, StrParam As %String = "") As %Library.String
{
	n (AppCode,APCode,StrParam)
	s APValue=""
	q:AppCode="" APValue
	s App=..GetAppID(AppCode)
	q:App="" APValue
	q:APCode="" APValue
	s GroupId=$p(StrParam,"^",1)
	s LocId=$p(StrParam,"^",2)
	s UserId=$p(StrParam,"^",3)
	s HospId=$p(StrParam,"^",4)
	i (LocId'="")&&(HospId="") d
	.s HospId=$p(^CTLOC(LocId),"^",22)
	
	;先获取到参数id(CSSD_Parameter)
	s ParameterId="",ParamValue=""
	s RowId=""
	f  s RowId=$o(^User.CSSDParameterI("IndexCSSDPParaCodeType",APCode,App,RowId)) q:((RowId="")||(ParameterId'=""))  d
	.s ParamObj=##Class(User.CSSDParameter).%OpenId(RowId)
	.q:'$IsObject(ParamObj)
	.s ShowDataFlag=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_Parameter",RowId,HospId)
	.q:ShowDataFlag="N"
	.s ParameterId=RowId
	.s ParamValue=ParamObj.CSSDPParaValue
	q:ParameterId="" ""
	
	;优先按人取配置
	i (UserId'="")&&(APValue="")  d
	.s Ch=$o(^User.CSSDParameterItmI("TypePointer","U",UserId,ParameterId,""))
	.q:Ch=""
	.s ParameterItmId=ParameterId_"||"_Ch
	.s ParameterItmObj=##class(User.CSSDParameterItm).%OpenId(ParameterItmId)
	.s APValue=ParameterItmObj.PIValue
	q:APValue'="" APValue
	
	;安全组
	i (GroupId'="")&&(APValue="")  d
	.s Ch=$o(^User.CSSDParameterItmI("TypePointer","G",GroupId,ParameterId,""))
	.q:Ch=""
	.s ParameterItmId=ParameterId_"||"_Ch
	.s ParameterItmObj=##class(User.CSSDParameterItm).%OpenId(ParameterItmId)
	.s APValue=ParameterItmObj.PIValue
	q:APValue'="" APValue
	
	;不存在按人和安全组的定义，则按科室取
	i (LocId'="")&&(APValue="")  d
	.s Ch=$o(^User.CSSDParameterItmI("TypePointer","L",LocId,ParameterId,""))
	.q:Ch=""
	.s ParameterItmId=ParameterId_"||"_Ch
	.s ParameterItmObj=##class(User.CSSDParameterItm).%OpenId(ParameterItmId)
	.s APValue=ParameterItmObj.PIValue
	q:APValue'="" APValue
	
	Q ParamValue
}

/// Descript:取应用程序ID
ClassMethod GetAppID(AppCode) As %Library.String [ Private ]
{
	N (AppCode)
	S AppCode=$$ALPHAUP^SSUTIL4(AppCode)
	Q:AppCode="" ""
	S App=$O(^User.CSSDBaseDataTypeI("IndexCode","C",AppCode,""))
	Q App
}

///  Creator:why
///  CreatDate:2011.8.17
///  Description:生成配包的序列号
///  Table:
///  Input:
///  Output:
///  Return:
///  Others：w ##Class(web.CSSDHUI.Common.AppCommon).CreatePackSerialNo()
ClassMethod CreatePackSerialNo() As %String
{
	new
	s date=$zd(+$h,8)
	s pre="P"_date
	s MaxId=$o(^User.CSSDPackagePackD(""),-1)
	s maxNo=""
	i MaxId="" d
	.s maxNo=""
	e  d
	.s maxNo=$List(^User.CSSDPackagePackD(MaxId),10)
	.s tmpPre=$E(maxNo,1,9)
	.i pre'=tmpPre d
	..s maxNo=""
	s serialNo=+$e(maxNo,$l(maxNo)-2,$l(maxNo))
	s serialNo=serialNo+1
	s tmpNo="00"_serialNo
	s serialNo=$e(tmpNo,$l(tmpNo)-2,$l(tmpNo))
	s serialNo=pre_serialNo
	q serialNo
}

}
