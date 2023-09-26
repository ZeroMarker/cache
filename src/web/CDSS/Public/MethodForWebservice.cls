Class web.CDSS.Public.MethodForWebservice Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：陈莹
/// CreatDate：2020-05-15
/// Description：安徽省立同步数据调用接口			
/// Return：xml		
/// Others：w ##class(web.DHCBL.BDP.FunLib).GetMethod("web.CDSS.WarnDecision.OperationWarning[A]OperationWarning[A]52804502^08658866^1^住院^5599^医生01^91101^JJYQFKYLDY-锦江院区妇科医疗单元^1")
ClassMethod GetMethod(InputStr As %String) As %String
{
	n (InputStr)
	s $zt="ERRORGet"
	s className=$p(InputStr,"^",1)
	s methodName=$p(InputStr,"^",2)
	s rtn=""
	
	s InputStrlength=$l(InputStr,"[A]")
	s tkclass=$p(InputStr,"[A]",1)  //类名
	s tkmethod=$p(InputStr,"[A]",2)  //类方法
	Quit:((tkclass="")!(tkmethod="")) ""
	if (InputStrlength>2)  
	{
		for pcounti=3:1:InputStrlength  //类方法的参数赋值 
		{
			s xpcode="s p"_(pcounti-2)_"=$p(InputStr,""[A]"","_pcounti_")"
			x xpcode
		}  //p1, p2, 
	}
	s pcount=InputStrlength-2
	Set xcode="s ret=##class("_tkclass_")."_tkmethod_"("
	if pcount>0  Set xcode=xcode_"p1" For pcounti=2:1:pcount Set xcode=xcode_",p"_pcounti
	Set xcode = xcode_")"
	x xcode
	s ret=$tr(ret,$c(13,10),"")
	s ret=$tr(ret,$c(10),"")
	s ret=$tr(ret,$c(0),"")
	s ret=$tr(ret,$c(13),"")
	s ret = ##class(web.BDP.util.String).Replace(ret,"\r","")
	s ret = ##class(web.BDP.util.String).Replace(ret,"\n","")
	q ret
ERRORGet
	s ret=$ze
	q ret
}

/// Creator：石萧伟
/// CreatDate：2020-05-15
/// Description：安徽省立同步数据调用接口			
/// Return：xml		
/// Others：w ##class(web.CDSS.Public.MethodForWebservice).CallMethod("web.CDSS.TreatDecision.TreatPlan[A]GetTreatPlanTreeJson[A]538^0000000005^1^门诊^12175^医生01^ZYMZ001^呼吸内科门诊^1[A]高血压性心脏病")
ClassMethod SaveBlood(action As %String, message As %String) As %String
{
	n (action,message,%session)
	s $zt ="ERROR"
	s action = ##class(web.BDP.util.String).Replace(action,"""""","""")
	s message = ##class(web.BDP.util.String).Replace(message,"""""","""")
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write(message)
	s Soap= ##class(BloodTranService.BloodTranServiceSoap).%New()
	s Soap.Timeout=3 //设置超时时间3s 2021-08-05
	s ret=Soap.BloodTranServer(action,stream.Read())
	Q ret
}

/// Creator：陈莹
/// CreatDate：2020-05-15
/// Description：安徽省立同步数据调用接口			
/// Return：xml		
/// Others：w ##class(web.CDSS.Public.MethodForWebservice).CallMethod("web.CDSS.TreatDecision.TreatPlan[A]GetTreatPlanTreeJson[A]538^0000000005^1^门诊^12175^医生01^ZYMZ001^呼吸内科门诊^1[A]高血压性心脏病")
ClassMethod CallMethod(InputStr As %String) As %String
{
	n (InputStr,%session)
	s $zt ="ERROR"
	s deptid=""
	s userid=""
	s InputStr = ##class(web.BDP.util.String).Replace(InputStr,"""""","""")
	s Soap= ##class(CDSSService.CDSSServiceSoap).%New()
	s Soap.Timeout=3 //设置超时时间3s 2021-08-05
	s ret=Soap.CallMethod(InputStr)
	//s ^TMP("FWK",$now())=InputStr_"&&"_ret
	Q ret
ERROR
 	//s ^TMP("FWKError",$now())=InputStr_"&&"_$ze
 	Quit ""
}

/// Creator：石萧伟
/// CreatDate：2021-05-14
/// Description：根据科室id获取科室代码			
/// Return：科室代码	
/// Others：w ##class(web.CDSS.Public.MethodForWebservice).GetLocCodeByID(locId)
ClassMethod GetLocCodeByID(locId As %String) As %String
{
	n (locId)
	q:locId="" ""
	s CTLOCCode=$p($g(^CTLOC(locId)),"^",1) 		//科室Code
	q CTLOCCode
}

}
