/// 名称: DHCMed.DCEns.EMR.FirstCourseByV1
/// 描述: 电子病历首程数据同步类（东华电子病历V1.0）
/// 编写者：zhufei
/// 编写日期: 2016-04-14
Class DHCMed.DCEns.EMR.FirstCourseByV1 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2016-04-25
/// Description:  根据起止日期同步首程数据
/// Table：       DHCMed.DC.EMR.FirstCourse
/// Input：       FromDate:开始日期
///               ToDate:结束日期
///               HospCode:医院缩写码（DHCMed_DC_SYS.BTHospital.SCode）
/// Return：      OK
/// w ##class(DHCMed.DCEns.EMR.FirstCourseByV1).SyncFiCourseByDate("2016-04-25","2016-04-25","HIS01",1)
ClassMethod SyncFiCourseByDate(aFromDate As %String, aToDate As %String, aHospCode As %String, aInitFlag As %String = "0") As %String
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
		//首程数据
		Kill ^DHCMed.DC.EMR.FirstCourseD
		Kill ^DHCMed.DC.EMR.FirstCourseI
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
					
					Set flg=..UpdateFirstCourse(EpisodeID,aFromDate,aToDate)
				}
			}
		}
	}
	
	Quit "OK"
}

/// Creator：     liyi
/// CreatDate：   2016-04-25
/// Description:  同步就诊记录时间段内首程记录
/// Table：       DHCMed.DC.EMR.FirstCourse
/// Input：       aPaadm:就诊ID
/// 	          aFromDate:开始日期
///               aToDate:结束日期
/// Return：      
/// w ##Class(DHCMed.DCEns.EMR.FirstCourseByV1).UpdateFirstCourse(21947672,"2016-04-27","2016-04-27")
ClassMethod UpdateFirstCourse(aEpsiodeID As %String, aFromDate As %String, aToDate As %String)
{
	New (aEpsiodeID,aFromDate,aToDate)
	Set return=""
	Quit:(aEpsiodeID="")||(aFromDate="")||(aToDate="") return
	
	Set EmrFirstProgress = ##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("DPIO-EmrFirstProgress","")
	For aIndex = 1:1:$length(EmrFirstProgress,",")
	{
		Set EleCode = $p(EmrFirstProgress,",",aIndex)
		Continue:EleCode=""
		
		Set DataValue=..GetEprData(aEpsiodeID,EleCode,0)
		Continue:DataValue=""
		
		Set InputStr = aIndex
		Set InputStr = InputStr_"^"_aEpsiodeID
		Set InputStr = InputStr_"^"_DataValue
		Set InputStr = InputStr_"^"_""
		Set InputStr = InputStr_"^"_""
		Set InputStr = InputStr_"^"_""
		Set InputStr = InputStr_"^"_1
		
		Set ret = ##class(DHCMed.DC.EMR.FirstCourse).Update(InputStr,"^")
	}
	Quit 1
}

/// w ##Class(DHCMed.DCEns.EMR.FirstCourseByV1).GetEprData()
ClassMethod GetEprData(Paadm As %String, EleCode As %String, IsGetCode As %String)
{
	New (Paadm,EleCode,IsGetCode)
    Set CurrentNS=$ZNSPACE
    ZN "EPR"
    Set ret=##class(DHC.EPR.FPInterface.ExportTable).GetItemDataValueV1ForStat(Paadm,EleCode,IsGetCode)
    ZN CurrentNS
    Quit ret
}

Storage Default
{
<Data name="FirstCourseByV1DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DCEn4D2.FirstCourseB5BBD</DataLocation>
<DefaultData>FirstCourseByV1DefaultData</DefaultData>
<IdLocation>^DHCMed.DCEn4D2.FirstCourseB5BBD</IdLocation>
<IndexLocation>^DHCMed.DCEn4D2.FirstCourseB5BBI</IndexLocation>
<StreamLocation>^DHCMed.DCEn4D2.FirstCourseB5BBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
