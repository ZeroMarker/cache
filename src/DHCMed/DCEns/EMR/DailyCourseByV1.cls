/// 名称: DHCMed.DCEns.EMR.DailyCourseByV1
/// 描述: 电子病历日常病程数据同步类（东华电子病历V1.0）
/// 编写者：zhufei
/// 编写日期: 2016-04-14
Class DHCMed.DCEns.EMR.DailyCourseByV1 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2016-04-25
/// Description:  根据起止日期同步日常病程数据
/// Table：       DHCMed.DC.EMR.DailyCourse
/// Input：       FromDate:开始日期
///               ToDate:结束日期
///               HospCode:医院缩写码（DHCMed_DC_SYS.BTHospital.SCode）
/// Return：      OK
/// w ##class(DHCMed.DCEns.EMR.DailyCourseByV1).SyncDyCourseByDate("2015-03-10","2015-03-20","HIS01",1)
ClassMethod SyncDyCourseByDate(aFromDate As %String, aToDate As %String, aHospCode As %String, aInitFlag As %String = "0") As %String
{
	New (aFromDate,aToDate,aHospCode,aInitFlag)
	Set return="0^入参错误"
	Quit:(aFromDate="")||(aToDate="")||(aHospCode="") return
	
	Set return="-1^医院缩写码维护错误"
	Set flg=##class(DHCMed.DC.BTHospital).GetIDBySCode(aHospCode)
	Quit:flg="" return
	
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	
	If aInitFlag=1 {
		//日常病程数据
		Kill ^DHCMed.DC.EMR.DailyCourseD
		Kill ^DHCMed.DC.EMR.DailyCourseI
	}
	
	Set xAdmType=""
	For {
		Set xAdmType=$o(^DHCMed.DC.HIS.InHospitalI("IndexInHospital",aHospCode,xAdmType))
		Quit:xAdmType=""
		
		Continue:(xAdmType'="I")&&(xAdmType'="E")&&(xAdmType'="EP")
		
		Set xAdmDays=""
		For {
			Set xAdmDays=$o(^DHCMed.DC.HIS.InHospitalI("IndexInHospital",aHospCode,xAdmType,xAdmDays))
			Quit:xAdmDays=""
			
			Set xDate=$s(xAdmDays>0:aFromDate-xAdmDays,1:"")
			For {
				Set xDate=$o(^DHCMed.DC.HIS.InHospitalI("IndexInHospital",aHospCode,xAdmType,xAdmDays,xDate))
				Quit:xDate=""
				
				Quit:(xAdmDays>0)&&(xDate>(aToDate-xAdmDays+1))
				Quit:(xAdmDays<0)&&(xDate>aToDate)
				
				Set xID=0
				For {
					Set xID=$o(^DHCMed.DC.HIS.InHospitalI("IndexInHospital",aHospCode,xAdmType,xAdmDays,xDate,xID))
					Quit:xID=""
					
					Set objAdm=##class(DHCMed.DC.HIS.InHospital).GetObjById(xID)
					Continue:'$IsObject(objAdm)
					Continue:objAdm.IsActive'=1
					Set EpisodeID=objAdm.EpisodeID
					
					Set flg=..UpdateDailyCourse(EpisodeID,aFromDate,aToDate)
				}
			}
		}
	}
	
	Quit "OK"
}

/// Creator：     liyi
/// CreatDate：   2016-04-25
/// Description:  同步就诊记录时间段内日常病程记录
/// Table：       DHCMed.DC.EMR.DailyCourse
/// Input：       aPaadm:就诊ID
/// 	          aFromDate:开始日期
///               aToDate:结束日期
/// Return：      
/// w ##Class(DHCMed.DCEns.NIS.ObResultByV1).UpdateObservations(206,"","")
ClassMethod UpdateDailyCourse(aEpsiodeID As %String, aFromDate As %String, aToDate As %String)
{
	New (aEpsiodeID,aFromDate,aToDate)
	Set return=""
	Quit:(aEpsiodeID="")||(aFromDate="")||(aToDate="") return

	//病程通用：#{2||2-D-541}
	
	Quit return
}

}
