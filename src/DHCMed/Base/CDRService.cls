/// 名称: DHCMed.Base.CDRService
/// 描述: 临床数据读写服务(icare.entity.ClinicalRepository)的业务封装
/// 编写者：wuqk
/// 编写日期: 2012-05-10
Class DHCMed.Base.CDRService Extends DHCMed.Abstract
{

/// Creator：     wuqk
/// CreatDate：   2012-05-10
/// Description:  保存临床数据中心操作信息
/// Table：       icare.entity.ClinicalRepository
/// Input：       id:    dataString
/// Return：      返回状态
/// Others：   
/// w ##class(DHCMed.Base.CDRService).SaveData(dataString)
ClassMethod SaveData(dataString As %String) As %Status
{
	
	s serviceobj=##class(icare.TimeLineService.BOClinicalRepository).%New()
	s clinicobj=##class(icare.entity.ClinicalRepository).%New()
	s clinicobj.ActCode=$p(dataString,"^",1)
	s clinicobj.ActDate=$p(dataString,"^",2)
	s clinicobj.ActTime=$p(dataString,"^",3)
	s clinicobj.CareProviderID=$p(dataString,"^",4)
	s clinicobj.DataTypeCode=$p(dataString,"^",5)
	s clinicobj.ObjectID=$p(dataString,"^",6)
	s clinicobj.DataValue=$p(dataString,"^",7)
	s clinicobj.EpisodeID=$p(dataString,"^",8)
	s clinicobj.Parameters=$p(dataString,"^",9)
	s clinicobj.Summary=$p(dataString,"^",10)
	s id=serviceobj.Insert(clinicobj)
	quit id
}

/// Creator：     wuqk
/// CreatDate：   2012-05-10
/// Description:  保存医务管理相关临床数据中心操作信息
/// Table：       
/// Input：       EpisodeID
/// Return：      返回状态
/// Others：   
/// w ##class(DHCMed.Base.CDRService).ClearDHCMedData(EpisodeID)
ClassMethod ClearDHCMedData(EpisodeID As %String) As %Status
{
	set ret=..ClearDHCCPWData(EpisodeID)
	quit $$$OK
}

/// Creator：     wuqk
/// CreatDate：   2012-05-10
/// Description:  保存临床路径相关临床数据中心操作信息
/// DataTypeCode：1001 临床路径
/// ActCode：100101 入径；100102 出径
/// Input：       EpisodeID
/// Return：      返回状态
/// Others：   
/// w ##class(DHCMed.Base.CDRService).ClearDHCCPWData(EpisodeID)
ClassMethod ClearDHCCPWData(EpisodeID As %String) As %Status
{
	Set MRADM=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(EpisodeID)
	quit:MRADM="" $$$OK
	
	Set ClinPathWaysID=""
	For {
		Set ClinPathWaysID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRADM,ClinPathWaysID),-1)
		Quit:ClinPathWaysID=""
		Set objPathWay=##Class(User.DHCMRClinicalPathWay).%OpenId(ClinPathWaysID)
		Set InputString="100101^"_objPathWay.CPWInDate
		Set InputString=InputString_"^"_objPathWay.CPWInTime
		Set InputString=InputString_"^"_+##class(DHCMed.Base.CtPcp).GetByUserId(objPathWay.CPWInDoctorDR)
		Set InputString=InputString_"^"_"1001"
		Set InputString=InputString_"^"_ClinPathWaysID
		Set InputString=InputString_"^"_objPathWay.CPWPathwayDR.CPWCPWDicDR.CPWDDesc
		Set InputString=InputString_"^"_EpisodeID
		Set InputString=InputString_"^"_"EpisodeID="_EpisodeID_"&FORMPageMode=2"
		Set InputString=InputString_"^入径:"_objPathWay.CPWPathwayDR.CPWCPWDicDR.CPWDDesc
		do ..SaveData(InputString)
		
		
		if (objPathWay.CPWStatus="O"){
			Set OutputString="100102^"_objPathWay.CPWOutDate
			Set OutputString=OutputString_"^"_objPathWay.CPWOutTime
			Set OutputString=OutputString_"^"_+##class(DHCMed.Base.CtPcp).GetByUserId(objPathWay.CPWOutDoctorDR)
			Set OutputString=OutputString_"^"_"1001"
			Set OutputString=OutputString_"^"_ClinPathWaysID
			Set OutputString=OutputString_"^"_objPathWay.CPWPathwayDR.CPWCPWDicDR.CPWDDesc
			Set OutputString=OutputString_"^"_EpisodeID
			Set OutputString=OutputString_"^"_"EpisodeID="_EpisodeID_"&FORMPageMode=2"
			Set OutputString=OutputString_"^出径:原因("_objPathWay.CPWOutReasonDR.VRDesc_":"_objPathWay.CPWComments_")"
			do ..SaveData(OutputString)
		}
		
	}
	quit $$$OK
}

}
