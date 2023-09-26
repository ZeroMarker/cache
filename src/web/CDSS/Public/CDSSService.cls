/// web.CDSS.Public.CDSSService
Class web.CDSS.Public.CDSSService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// http://192.144.152.252/imedical/web/web.CDSS.Public.CDSSService.cls?WSDL
/// WebService 的名称.
Parameter SERVICENAME = "CDSSService";

// Parameter LOCATION = "http://192.144.152.252/imedical/web/";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// Creator：陈莹
/// CreatDate：2020-010-29
/// Description：HIS库调用CDSS服务器端			
/// Return：xml		
/// Others：w ##class(CDSSService.CDSSServiceSoap).%New().CallMethod("web.CDSS.Public.MethodForWebservice[A]jsQueryReqDetail[A]1[A]99999[A]web.CDSS.CMKB.DiseaseDeptDict[A]GetDataForCmb1[A][query][query]")
/// s $zt ="ERROR"
/// d ..WSSecurityLogin("_system","SYS")
/// ......
/// ERROR
/// s ^TMP("FWKError")=$ze
/// Quit ""
Method CallMethod(InputStr) As %String [ WebMethod ]
{
	s ^tmpsxw(1)=InputStr
	s returnStr = ""
	s returnStr= ##class(web.CDSS.Public.MethodForWebservice).GetMethod(InputStr)
	q returnStr
}

/// Creator:石萧伟
/// CreatDate:2021/6.16
/// Description：获得注意事项
/// Input：text = 检验/检查/手术/护理描述   type=检验/检查/手术/护理
/// Return:属性内容文本
Method OldGetAttention(text, type) As %String [ WebMethod ]
{
	 q:text="" ""
	 s termDesc = ##class(web.CDSS.IMP.InterDictMapping).GetDiectName(text,"",type) //获取知识库描述
	 s desc=""
	 s desc = ##class(web.DHCBL.MKB.MKBTermProDetail).GetWikiProDetails(type,termDesc,"注意事项")
     q desc
}

/// Creator:石萧伟
/// CreatDate:2021/6.16
/// Description：PDA数据获取
/// Input：text = 检验/检查/手术/护理描述   type=检验/检查/手术/护理
/// Return:属性内容文本
/// w ##class(web.CDSS.Public.CDSSService).GetAttentionTest("血常规检查五分类(含镜检)","检验","注意事项","51074340^9966555^1^住院^5599^医生01^91109^JJYQXEHXMYKYLDY-锦江院区小儿呼吸免疫科医疗单元")
/// w ##class(web.CDSS.Public.CDSSService).%New().GetAttention("血常规检查五分类(含镜检)","检验","注意事项","51074340^9966555^1^住院^5599^医生01^91109^JJYQXEHXMYKYLDY-锦江院区小儿呼吸免疫科医疗单元")
Method GetAttentionTest(text, type, pro, patientinfo) As %String [ WebMethod ]
{
	 s ^TMP("SXW")=text_","_type_pro_patientinfo
	 s OrderType = $CASE(type,"1":"药品","2":"检查","3":"检验","4":"手术","5":"护理","6":"处置","7":"膳食","8":"会诊","9":"麻醉","10":"其他") 
	 s termDesc = ##class(web.CDSS.IMP.InterDictMapping).GetDiectName(text,"",type) //获取知识库描述
	 //w type_" "_termDesc_" "_pro
	 //s desc = ##class(web.DHCBL.MKB.MKBTermProDetail).GetWikiProDetails(type,termDesc,pro)
	 s warning =##class(web.CDSS.WarnDecision.SingleOrderWarning).GetOrderWarningByRule(patientinfo,text,type)
	 s warning=[].%FromJSON(warning)
	 s warningResult =""
	 for i=0:1:(warning.%Size()-1)
	 {
		 s warningResult = warningResult_(i+1)_"."_warning.%Get(i).WarningTip
     }
	 //Q CDSSRet.%Get(0).WarningTip

	 //s desc = ##class(web.DHCBL.MKB.MKBTermProDetail).GetWikiProDetails("检查","腔内超声检查","注意事项")
     //q desc
     if (warningResult = "")
     {
	     if ##class(web.DHCBL.BDP.FunLib).IsValidMethodName("web.DHCBL.MKB.MKBTermProDetail","GetWikiProDetails")
		 {
		     s desc=##class(web.DHCBL.MKB.MKBTermProDetail).GetWikiProDetails(OrderType,termDesc,pro)	 
		 }
		 else
		 {
			 s desc=##class(web.CDSS.CMKB.TermProDetail).GetWikiProDetails(OrderType,termDesc,pro)	 	 
		 }
	     //s desc = ##class(web.DHCBL.MKB.MKBTermProDetail).GetWikiProDetails(type,termDesc,pro)
	     q desc
	 }
	 else
	 {
		 q warningResult
     }
}

/// Creator:石萧伟
/// CreatDate:2021/6.16
/// Description：PDA数据获取
/// Input：text = 检验/检查/手术/护理描述   type=检验/检查/手术/护理
/// Return:属性内容文本
/// w ##class(web.CDSS.Public.CDSSService).%New().GetAttention("妊娠剧吐","11","注意事项","4216^0000001667^1^3^12175^医生01^ZYZY001^呼吸内科")
Method GetAttention(pro, json) As %String [ WebMethod ]
{
	s info=[].%FromJSON(json)
	s WarnList=##class(web.CDSS.MachineLearning.InteractiveInterface).DHCHisInterface("CATCH_ORDER_WARNING",json)
	
	s AllInfo={}.%FromJSON(WarnList)
	
	s AllOrderEntry=info.%Get("OrderEntry")  //医嘱信息列表，医院数据
    for i=0:1:(AllOrderEntry.%Size()-1)
    {
        s OrderEntry=AllOrderEntry.%Get(i)
        s OrderType=OrderEntry.%Get("OrderType") 
        s OType=$case(OrderType,"1":"药品","2":"检查","3":"检验","4":"手术","5":"护理","6":"护理","10":"其他",:"")
        continue:OType=""
		s OrderName=OrderEntry.%Get("OrderContent")
	 	s termDesc = ##class(web.CDSS.IMP.ContrastDict).GetDiectName(OrderName,"",OType) //获取知识库描述
	 	s termDesc=$p(termDesc,"&%",1)
		if ##class(web.DHCBL.BDP.FunLib).IsValidMethodName("web.DHCBL.MKB.MKBTermProDetail","GetWikiProDetails")
		{
			s ProDetail=##class(web.DHCBL.MKB.MKBTermProDetail).GetWikiProDetails(OType,termDesc,pro)	 
		}
		else
		{
			s ProDetail=##class(web.CDSS.CMKB.TermProDetail).GetWikiProDetails(OType,termDesc,pro)	 	 
		}
		d AllInfo.%Set("WikiContent",ProDetail)
    }
    q AllInfo.%ToJSON()
}

/// Creator:阚延新
/// CreatDate:2021/8.6
/// Description：护理接口
/// Input：action message
/// Return:
/// w ##class(web.CDSS.Public.CDSSService).%New().DHCServerInterface("")
Method DHCServerInterface(action As %String, message As %Stream.GlobalCharacter) As %String [ WebMethod ]
{
	d ##class(web.CDSS.MachineLearning.InteplatformService).DHCServerInterface(action,message)
	q 0
}

}
