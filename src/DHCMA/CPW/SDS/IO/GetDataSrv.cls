/// 获取外部数据服务类
Class DHCMA.CPW.SDS.IO.GetDataSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 病案相关数据接口1
/// 取单条编目诊断/手术
/// -------:诊断(D/1:主要诊断、D/2:次要诊断、D/3:医院感染诊断、D/4:病理诊断、D/5:损伤中毒的外部因素、D/6:门急诊诊断、D/7:入院诊断)
/// -------:手术(O/1:手术、O/2:操作)
/// w ##class(DHCMA.CPW.SDS.IO.GetDataSrv).GetFrontPageICD()
ClassMethod GetFrontPageICD(aEpisodeID As %String, aGetType As %String, aRowIndex As %String = "1")
{
	new (aEpisodeID,aGetType,aRowIndex)
	Set return=""
	Set $zt="GetFrontPageICDErr"
	Quit:(aEpisodeID="")||(aGetType="")
	//类型转换
	Set ICDType=$p(aGetType,"/",1)
	Set ICDSubType=$p(aGetType,"/",2)
	If (ICDType="D"){
		Set ICDSubType=$Select(ICDSubType=1:3,ICDSubType=2:4,ICDSubType=3:6,ICDSubType=4:7,ICDSubType=6:1,ICDSubType=7:2,1:ICDSubType)
	}
	Set aGetType=ICDType_"/"_ICDSubType
	Set return=##class(MA.IPMR.IO.OutService).GetICDByAdm(aEpisodeID,aGetType,aRowIndex)
	Set:return="" return=##class(MA.IPMR.IOSrv.DirectConn.MR.ForHIS).GetICDByAdm(aEpisodeID,aGetType,aRowIndex)
	Quit return
GetFrontPageICDErr
	Quit ""
}

/// 病案相关数据接口2
/// 取全部编目诊断/手术
/// w ##class(DHCMA.CPW.SDS.IO.GetDataSrv).GetFrontPageICDAll()
ClassMethod GetFrontPageICDAll(aEpisodeID As %String, aGetType As %String)
{
	new (aEpisodeID,aGetType)
	Set return=""
	Set $zt="GetFrontPageICDAErr"
	Quit:(aEpisodeID="")||(aGetType="")
	//类型转换
	Set ICDType=$p(aGetType,"/",1)
	Set ICDSubType=$p(aGetType,"/",2)
	If (ICDType="D"){
		Set ICDSubType=$Select(ICDSubType=1:3,ICDSubType=2:4,ICDSubType=3:6,ICDSubType=4:7,ICDSubType=6:1,ICDSubType=7:2,1:ICDSubType)
	}
	Set:ICDSubType'="" aGetType=ICDType_"/"_ICDSubType
	Set return=##class(MA.IPMR.IO.OutService).GetICDAllByAdm(aEpisodeID,aGetType)
	Set:return="" return=##class(MA.IPMR.IOSrv.DirectConn.MR.ForHIS).GetICDAllByAdm(aEpisodeID,aGetType,aRowIndex)
	Quit return
GetFrontPageICDAErr
	Quit ""
}

/// 病案相关数据接口3
/// Description:      根据日期取就诊列表
/// w ##class(DHCMA.CPW.SDS.IO.GetDataSrv).IGetFPCodingAdms("2019-01-01")
ClassMethod IGetFPCodingAdms(aDateFrom, aDateTo As %String = "", aDateType As %String = "3", aHospID As %String = "", aMrType As %String = "7", aLocGroup As %String = "", aAdmLoc As %String = "", aAdmWard As %String = "", aDischLoc As %String = "", aDischWard As %String = "", aDeathFlag As %String = "")
{
	new (aDateType,aHospID,aMrType,aLocGroup,aAdmLoc,aAdmWard,aDischLoc,aDischWard,aDateFrom,aDateTo,aDeathFlag)
	Set:aDateTo="" aDateTo=aDateFrom
	Set return=""
	Set $zt="IGetFPCodingAdmsErr"
	Quit:(aDateFrom="") return
	Set ErrMsg=""
	//默认检索4版病案接口
	Set MAFlag=##class(%Dictionary.CompiledClass).%OpenId("MA.IPMR.IO.OutService")
	Set AdmLen=0
	If (MAFlag'="") {
		Set FPAdmsList=##class(MA.IPMR.IO.OutService).GetEpisodeList(aHospID,aDateType,aMrType,aLocGroup,aAdmLoc,aAdmWard,aDischLoc,aDischWard,aDateFrom,aDateTo,aDeathFlag)
		Set:FPAdmsList'="" AdmLen=FPAdmsList.Count()
		Set adms=""
		If (AdmLen>0) {
			//如果从4版取到就诊数组，转换为就诊字符串,与3版统一
			For xind=1:1:AdmLen {
				Set xadm=FPAdmsList.GetAt(xind)
				Set adms=adms_","_xadm
			}
			Set return=adms
			Quit return
		}
	}
	//如果4版病案接口无数据，继续取三版
	Set WMRFlag=##class(%Dictionary.CompiledClass).%OpenId("DHCWMR.IO.ToOutService")
	If (WMRFlag'="")&&(AdmLen<1) {
		Set admInfo=##class(DHCWMR.IO.ToOutService).IGetFPCodingAdms(aDateFrom)
		Set adms=admInfo
		//分离就诊号信息
		Set:admInfo["^" adms=$p(admInfo,"^",5)
		Set return=adms
	}
	Quit return
	//没有处理极端情况：
	//2版病案编目
	/*if MRSVersion=2 {
		s ds = ##class(%Library.ResultSet).%New("web.DHCWMRInterface.FrontPage:QryFrontPage")
		d ds.Execute(xDate,aToDate)
			
		}
	while(ds.Next()) {
		if (MRSVersion=3) {
			Set xPaadm=ds.Data("EpisodeID")
		}else{ 
			Set xPaadm=ds.Data("Paadm")
		}
	*/
	//3版与4版同时有编目记录的情况-将3 4 版接口通取后拼串即可
IGetFPCodingAdmsErr
	Quit ""
}

}
