/// ClassName:    DHCMed.SPEService.Service
/// Description:  特殊患者管理相关服务
/// Creator：     zhufei
/// CreatDate:    2015-11-04
Class DHCMed.SPEService.Service Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2015-11-04
/// Description:  特殊患者图标
/// Table：       DHCMed.SPE.Patients
/// Input：       aEpisodeID : 就诊号
/// Return：      返回String "^"分隔
/// w ##class(DHCMed.SPEService.Service).GetSpeInfoByAdm(189)
ClassMethod GetSpeInfoByAdm(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set xPatTypeID=0
	For {
		Set xPatTypeID=$o(^DHCMed.SPEi("Pat",0,"IndexAdmPatType",aEpisodeID,xPatTypeID))
		Quit:xPatTypeID=""
		
		Set xSpeID=0
		For {
			Set xSpeID=$o(^DHCMed.SPEi("Pat",0,"IndexAdmPatType",aEpisodeID,xPatTypeID,xSpeID))
			Quit:xSpeID=""
			
		    Set objSpe=##class(DHCMed.SPE.Patients).GetObjById(xSpeID)
		    Continue:'$IsObject(objSpe)
		    Continue:'$IsObject(objSpe.PSPatTypeDr)
		    Continue:'$IsObject(objSpe.PSCurrStatus)
			Set PatTypeID=objSpe.PSPatTypeDr.%Id()
			Set PatTypeDesc=objSpe.PSPatTypeDr.PTSDesc
			Set StatusCode=objSpe.PSCurrStatus.Code
			Set StatusDesc=objSpe.PSCurrStatus.Description
			Continue:StatusCode="0"  //作废 过滤
			Continue:StatusCode="3"  //关闭 过滤
			
			Set return=return_PatTypeDesc_";"
		}
	}
	Set:return'="" return=$e(return,1,$l(return)-1)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-11-04
/// Description:  特殊患者图标
/// Table：       DHCMed.SPE.PatientsLog
/// Input：       aEpisodeID : 就诊号
/// Return：      返回String "^"分隔
/// w ##class(DHCMed.SPEService.Service).GetSpeNoReadNews(189)
ClassMethod GetSpeNoReadNews(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set xPatTypeID=0
	For {
		Set xPatTypeID=$o(^DHCMed.SPEi("Pat",0,"IndexAdmPatType",aEpisodeID,xPatTypeID))
		Quit:xPatTypeID=""
		
		Set xSpeID=0
		For {
			Set xSpeID=$o(^DHCMed.SPEi("Pat",0,"IndexAdmPatType",aEpisodeID,xPatTypeID,xSpeID))
			Quit:xSpeID=""
			
		    Set objSpe=##class(DHCMed.SPE.Patients).GetObjById(xSpeID)
		    Continue:'$IsObject(objSpe)
		    Continue:'$IsObject(objSpe.PSPatTypeDr)
		    Continue:'$IsObject(objSpe.PSCurrStatus)
			Set PatTypeID=objSpe.PSPatTypeDr.%Id()
			Set PatTypeDesc=objSpe.PSPatTypeDr.PTSDesc
			Set StatusCode=objSpe.PSCurrStatus.Code
			Set StatusDesc=objSpe.PSCurrStatus.Description
			Continue:StatusCode="0"  //作废 过滤
			Continue:StatusCode="3"  //关闭 过滤
			
			Set xLogSub=0
			For {
				Set xLogSub=$o(^DHCMed.SPE("Pat",xSpeID,"Log",xLogSub))
				Quit:xLogSub=""
				
				Set SpeLogID=xSpeID_"||"_xLogSub
				Set objLog=##class(DHCMed.SPE.PatientsLog).GetObjById(SpeLogID)
				Continue:'$IsObject(objLog)
			    Continue:objLog.PSLIsActive'=1  //无效
			    Continue:'$IsObject(objLog.PSLStatus)
			    Continue:objLog.PSLStatus.Code'=9  //状态不符
			    Continue:objLog.PSLIsRead=1    //已读
				Continue:objLog.PSLNewsType'=2  //操作记录不显示
				Set Opinion=objLog.PSLOpinion
				
				Set return=return_Opinion_";"
			}
		}
	}
	Set:return'="" return=$e(return,1,$l(return)-1)
	Quit return
}

}
