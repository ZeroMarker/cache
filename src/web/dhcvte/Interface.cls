/// 名称: web.dhcvte.Interface
/// 描述: VTE数据接口
/// 编写者：mazhaoyan
/// 编写日期: 2018-07-24
Class web.dhcvte.Interface [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Creator：     mazhaoyan
/// CreatDate：   2019-07-24
/// Description:  To病人列表图标接口
///               根据就诊号取当前病人风险等级
/// Table：       DHCMA.VTE.VtePointCase
/// Input：       EpisodeID:    User.PAADM
/// Return：      
/// w ##class(web.dhcvte.Interface).GetCurrRiskLevel(20692316)
ClassMethod GetCurrRiskLevel(EpisodeID As %String) As %String
{
	New (EpisodeID)
	Set return=""
	Set $ZT="GetCurrRiskLevelErr"
	Quit:EpisodeID="" return
	Set ID=0
	Set ID=$o(^DHCMA.VTE.VtePointCaseI("IndexEpisodeDr"," "_EpisodeID,ID))
	Quit:ID="" return
	Set VteType=$listget($g(^DHCMA.VTE.VtePointCaseD(ID)),5) ;确诊类型
	Quit:(VteType'=0)&&(VteType'="") return 
	Set riskLevel=$listget($g(^DHCMA.VTE.VtePointCaseD(ID)),3) ;风险等级
	//Quit:(riskLevel<3)||(riskLevel="") return
	//Set return="风险等级:"_$s(riskLevel="3":"中危",riskLevel="4":"高危",riskLevel="5":"极高危",1:"")
	Set return=riskLevel
	
	Quit return
	
GetCurrRiskLevelErr
	Quit ""
}

/// Creator：     mazhaoyan
/// CreatDate：   2019-07-24
/// Description:  To病人列表图标接口
///               根据就诊号取当前病人VTE类型
/// Table：       DHCMA.VTE.VtePointCase
/// Input：       EpisodeID:    User.PAADM
/// Return：      
/// w ##class(web.dhcvte.Interface).GetCurrVteType(20692316)
ClassMethod GetCurrVteType(EpisodeID As %String) As %String
{
	New (EpisodeID)
	Set return=""
	Set $ZT="GetCurrVteTypeErr"
	Quit:EpisodeID="" return
	Set ID=0
	Set ID=$o(^DHCMA.VTE.VtePointCaseI("IndexEpisodeDr"," "_EpisodeID,ID))
	Quit:ID="" return
	Set VteType=$listget($g(^DHCMA.VTE.VtePointCaseD(ID)),5) ;确诊类型 
	//Quit:(VteType=0)||(VteType="") return
	//Set return="确诊类型:"_$s(VteType="1":"肺栓塞",VteType="2":"深静脉血栓",VteType="3":"其他静脉血栓",1:"")
	Set return=VteType
	
	Quit return
	
GetCurrVteTypeErr
	Quit ""
}

/// Creator：     sunyingjie
/// CreatDate：   2020-07-09
/// Description:  To病人列表图标接口
///               根据就诊号判断当前病人是否新入院且未评估
/// Table：       DHCMA.VTE.VtePointCase
/// Input：       EpisodeID:    User.PAADM
/// Return：      
/// w ##class(web.dhcvte.Interface).IfVteEval(20692316)
ClassMethod IfVteEval(EpisodeID As %String) As %String
{
	New (EpisodeID)
	Set return=0
	Set $ZT="IfVteEvalErr"
	Quit:EpisodeID="" return
	Set ID=0
	Set ID=$o(^DHCMA.VTE.VtePointCaseI("IndexEpisodeDr"," "_EpisodeID,ID))
	Set newPatientFlag=##class(web.DHCSETIMAGE).IfNewPatient(EpisodeID)
	Quit:(newPatientFlag=0)||(ID'="") return
	Set return=1
	
	Quit return
	
IfVteEvalErr
	Quit 0
}

/// Creator：     sunyingjie
/// CreatDate：   2020-07-09
/// Description:  To病人列表图标接口
///               根据就诊号获取当前病人是否需要护士临床审核
/// Table：       DHCMA.VTE.VtePointCase
/// Input：       EpisodeID:    User.PAADM
/// Return：      
/// w ##class(web.dhcvte.Interface).GetCurrClcEval(20692316)
ClassMethod GetCurrClcEval(EpisodeID As %String) As %String
{
	New (EpisodeID)
	Set return=""
	Set $ZT="GetCurrClcEvalErr"
	Quit:EpisodeID="" return
	Set ID=0
	Set ID=$o(^DHCMA.VTE.VtePointCaseI("IndexEpisodeDr"," "_EpisodeID,ID))
	If ID=""{
		Set return="请审核VTE评估"
	}else{
		Set VteType=$listget($g(^DHCMA.VTE.VtePointCaseD(ID)),5) ;确诊类型 
		Quit:VteType'=0 return
		Set ClcEval=$listget($g(^DHCMA.VTE.VtePointCaseD(ID)),6) ;是否需要审核
		If ClcEval="1"{
			Set return="请审核VTE评估"
		}
	}
	
	Quit return
	
GetCurrClcEvalErr
	Quit ""
}

/// Creator：     wujiafeng
/// CreatDate：   2022-07-29
/// Description:  To病人列表图标接口
///               根据就诊号获取当前病人是否需要医生临床审核
/// Table：       DHCMA.VTE.VtePointCase
/// Input：       EpisodeID:    User.PAADM
/// Return：      
/// w ##class(web.dhcvte.Interface).GetCurrClcEvalDoc(20692316)
ClassMethod GetCurrClcEvalDoc(EpisodeID As %String) As %String
{
	New (EpisodeID)
	Set return=""
	Set $ZT="GetCurrClcEvalErr"
	Quit:EpisodeID="" return
	Set ID=0
	Set ID=$o(^DHCMA.VTE.VtePointCaseI("IndexEpisodeDr"," "_EpisodeID,ID))
	If ID=""{
		Set return="请审核VTE评估"
	}else{
		Set VteType=$listget($g(^DHCMA.VTE.VtePointCaseD(ID)),5) ;确诊类型 
		Quit:VteType'=0 return
		Set ClcEval=$listget($g(^DHCMA.VTE.VtePointCaseD(ID)),9) ;是否需要审核
		If ClcEval="1"{
			Set return="请审核VTE评估"
		}
	}
	
	Quit return
	
GetCurrClcEvalDocErr
	Quit ""
}

ClassMethod GetVteInfo(EpisodeID As %String) As %String
{
	New (EpisodeID)
	Set return=0
	Quit:EpisodeID="" return
	Set tResponse=##class(%Net.HttpRequest).%New()
	Set tResponse.Server="193.168.7.67"
	Set tResponse.Port="8081"
	Do tResponse.ContentTypeSet("application/json")
	DO tResponse.Get("api/getVteCheckInfo?patientId="_EpisodeID)
	Set res=tResponse.HttpResponse.Data
	Do ##class(ext.util.JsonObject).ParseJSON(res,"",.obj)
	Set DIAGNOSE=obj.DIAGNOSE
	Set VTECHECK=obj.VTECHECK
	Set RISKLEVEL=obj.RISKLEVEL
	Set BLOODLEVEL=obj.BLOODLEVEL
	set VTECHECKDATE=obj.VTECHECKDATE
	
	Quit DIAGNOSE_"^"_VTECHECK_"^"_RISKLEVEL_"^"_BLOODLEVEL_"^"_VTECHECKDATE
}

ClassMethod GetPatientDvtInfo(EpisodeID As %String) As %String
{
	New (EpisodeID)
	Set return=0
	Quit:EpisodeID="" return
	Set tResponse=##class(%Net.HttpRequest).%New()
	Set tResponse.Server="10.1.20.18"
	Set tResponse.Port="8081"
	Do tResponse.ContentTypeSet("application/json")
	DO tResponse.Get("/api/patientDvtStatus?EpisodeID="_EpisodeID)
	Set res=tResponse.HttpResponse.Data.Read()
	Set return=res
	
	Quit return
}

ClassMethod getVteRiskInfo(EpisodeID As %String) As %String
{
	New (EpisodeID)
	Set return=0
	Quit:EpisodeID="" return
	Set tResponse=##class(%Net.HttpRequest).%New()
	Set tResponse.Server="10.1.20.18"
	Set tResponse.Port="8082"
	Do tResponse.ContentTypeSet("application/json")
	DO tResponse.Get("/api/getVteRiskInfo?EpisodeID="_EpisodeID)
	Set res=tResponse.HttpResponse.Data
	Set obj = ##class(%DynamicObject).%FromJSON(res)

	Set LevelName = %Get("LEVLE_NAME")
	
	
	Quit LevelName
}

ClassMethod GetNodeCheckAbtRole(EpisodeID As %String) As %String
{
	New (EpisodeID)
	Set return=0
	Quit:EpisodeID="" return
	Set tResponse=##class(%Net.HttpRequest).%New()
	Set tResponse.Server="10.1.20.18"
	Set tResponse.Port="8081"
	Do tResponse.ContentTypeSet("application/json")
	DO tResponse.Get("/api/getNodeCheckAbtRole?EventType=DISC&EpisodeID="_EpisodeID)
	Set res=tResponse.HttpResponse.Data
	Set obj = ##class(%DynamicObject).%FromJSON(res)
	Quit:obj.code'=200 return
	Set data =  ##class(%DynamicObject).%FromJSON(obj.data)
	Set return=data.doctorCheck
		
	Quit return
}

}
