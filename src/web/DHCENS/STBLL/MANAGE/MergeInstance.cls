Class web.DHCENS.STBLL.MANAGE.MergeInstance Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2021—11-06
/// Description：HIS-API共库调用接口
/// Table：Ens_InterfaceMethod、Ens_ApiSysConfig Ens_SubApiSysConfig
/// Input：Input:方法代码,InputStream:入参字符流
/// Return：0:成功;-1:失败  
/// w ##class(web.DHCENS.STBLL.MANAGE.MergeInstance).SendMergeInfo()
ClassMethod SendMergeInfo(MethodCode As %String, InputContent As %Stream.GlobalCharacter) As %String
{
	s $ZT="Err"
	d InputContent.Rewind()
	s InputStr=InputContent.Read()
	s MethodID="",FunctionIDs=""
	s rtn=##class(%Stream.GlobalCharacter).%New()
	q:MethodCode="" rtn
	s MethodID=$o(^User.EnsInterfaceMethodI("MethodCode","classMethod",MethodCode,""))
	s:MethodID'="" FunctionIDs=$lg($g(^User.EnsInterfaceMethodD(MethodID)),5)
	s len=$l(FunctionIDs,",")
	f i=1:1:len {
		s FunctionID=$p(FunctionIDs,",",i)
		continue:+FunctionID=0
		s MessageCode=$lg($g(^Config.ENS.EnsSubApiSysConfigD(FunctionID)),5)
		s SystemCode=$lg($g(^Config.ENS.EnsSubApiSysConfigD(FunctionID)),2)
		s Hospital=$lg($g(^Config.ENS.EnsSubApiSysConfigD(FunctionID)),3)
		s SystemVersion=$lg($g(^Config.ENS.EnsSubApiSysConfigD(FunctionID)),4)
		continue:(SystemCode="")||(Hospital="")||(SystemVersion="")
		s SystemID=$o(^Config.ENS.EnsApiSysConfigI("PKSystemConfig",SystemCode,Hospital,SystemVersion,""))
		continue:+SystemID=0
		s SystemStatus=$lg($g(^Config.ENS.EnsApiSysConfigD(SystemID)),8)
		continue:SystemStatus'="Y"
		s DBMode=$lg($g(^Config.ENS.EnsApiSysConfigD(SystemID)),6)
		s DeptCodes=$lg($g(^Config.ENS.EnsApiSysConfigD(SystemID)),9)
		Continue:DeptCodes=""
		s DeptCode=$p(DeptCodes,",",1)
		s DeptDr=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(DeptCode),""))
		Continue:DeptDr=""
		s HospDr=$p($g(^CTLOC(DeptDr)),"^",22)
		continue:HospDr=""
		s HospCode=$p($g(^CT("HOSP",HospDr)),"^",1)
		continue:HospCode'=Hospital
		if MessageCode="MES0003" //医嘱状态变更消息单独处理
		{
			s ordItemIDs=InputStr
			s ordLen=$l(ordItemIDs,"^")
			for num=1:1:ordLen
			{
				s ordItemID=$p(ordItemIDs,"^",num)
				s ordRecDeptDr=$p($g(^OEORD($p(ordItemID,"||",1),"I",$p(ordItemID,"||",2),3)),"^",6)
				continue:ordRecDeptDr=""
				s ordRecDeptCode=$p($g(^CTLOC(ordRecDeptDr)),"^",1)
				continue:DeptCodes'[ordRecDeptCode
				if DBMode="共库" s DBList(FunctionID)=SystemCode_"^"_DeptCodes_"^"_MessageCode
			}
		}
		else
		{
			if DBMode="共库" s DBList(FunctionID)=SystemCode_"^"_DeptCodes_"^"_MessageCode
		}
	}
	q:'$D(DBList) rtn
	
	s funcrowid=""
	f {
		s funcrowid=$o(DBList(funcrowid))
		q:funcrowid=""
		s sysCode=$p($g(DBList(funcrowid)),"^",1)
		s deptCodes=$p($g(DBList(funcrowid)),"^",2)
		s messCode=$p($g(DBList(funcrowid)),"^",3)
		if sysCode="PIS" {
			s soap=##class(web.DHCENS.STBLL.MANAGE.PISSOAP.PISServiceSoap).%New()
			s soap.Timeout=1
			s parameter=""
			if messCode="MES0048" 
			{
				s parameter=##class(web.DHCENS.STBLL.PIS.METHOD.GetPisAppListInfo).SendAppBillNew(InputStr)
				s rtn=soap.Send(messCode,parameter)
			}
			elseif messCode="MES0003" 
			{
				s parameter=##class(web.DHCENS.STBLL.ORDER.METHOD.OEOrder).GetOrdersState(InputStr)
				s rtn=soap.Send(messCode,parameter)
			}
			elseif messCode="MES0016" 
			{
				s critiType=$p($p(InputStr,",",1),"||",1) //1:检验,2病理,3心电,4超声,5内镜,6放射
				if critiType="2"
				{
					s parameter=##class(web.DHCENS.STBLL.RIS.METHOD.RisCriticalValues).SendRISCriValueStatus(InputStr)
					s rtn=soap.Send(messCode,parameter)
				}
			}			
		}
		elseif sysCode="LIS" {
			set soap=##class(web.DHCENS.STBLL.MANAGE.LISSOAP.LISServiceSoap).%New()
			set soap.Timeout=1
			s critiType=$p($p(InputStr,",",1),"||",1)
			if (messCode="MES0004")&&(critiType="1") s parameter=##class(web.DHCENS.STBLL.LIS.METHOD.LisCriticalValues).SendCriValueStatus(InputStr)
			continue:parameter=""
			s rtn=soap.LISService(messCode,parameter)

		}
		elseif (sysCode="PACS")||(sysCode="US")||(sysCode="ES")||(sysCode="RIS") {
			set soap=##class(web.DHCENS.STBLL.MANAGE.PACSSOAP.RISWebServiceSoap).%New()
			set soap.Timeout=1
			if messCode="MES0003" 
			{
				s ret=##Class(RISService.InvokeRISService).DiscontinueAppInfoPACS(InputStr)
				d rtn.Write(ret)
			}
			elseif messCode="MES0016" 
			{
				s critiType=$p($p(InputStr,",",1),"||",1) //1:检验,2病理,3心电,4超声,5内镜,6放射
				if (critiType="4")||(critiType="5")||(critiType="6")
				{
					s parameter=##class(web.DHCENS.STBLL.RIS.METHOD.RisCriticalValues).SendRISCriValueStatus(InputStr)
					s rtn=soap.ClinicDealUrgency(parameter)
				}			
			}
		}
		elseif sysCode="EKG" {
			s parameter=""
			s soap=##class(web.DHCENS.STBLL.MANAGE.EKGSOAP.EKGService4ENSSoap).%New()
			s soap.Timeout=1
			if messCode="MES0003"  
			{				
				s parameter=##class(web.DHCENS.STBLL.ORDER.METHOD.OEOrder).GetOrdersState(InputStr)
				s rtn=soap.UpdateOrderStatus(parameter)				
			}
			elseif messCode="MES0016"
			{
				s critiType=$p($p(InputStr,",",1),"||",1) //1:检验,2病理,3心电,4超声,5内镜,6放射
				if (critiType="3")
				{
					s parameter=##class(web.DHCENS.STBLL.RIS.METHOD.RisCriticalValues).SendRISCriValueStatus(InputStr)
					s rtn=soap.CriticalValuesCheck(parameter)
				}
			}
			elseif messCode="MES0015"
			{
				s parameter=##class(web.DHCENS.STBLL.RIS.METHOD.GetRisAppInfo).SendAppBillByStudyNoNew(InputStr)
				s rtn=soap.AddAppBill(parameter)
			}
		}
	}
	q rtn
Err
	s stream=##class(%Stream.GlobalCharacter).%New()
	d stream.Write("-1^"_$ze)
	q stream
}

/// Creator：ZhangXinying
/// CreatDate：2021-11-22
/// Description：判断病人是否欠费
/// Table：
/// Input：
/// Return：是否欠费标记
/// Others: 
/// w ##class(web.DHCENS.STBLL.MANAGE.MergeInstance).CheckArrears("")
ClassMethod CheckArrears(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set suCount=0,faCount=0,faInfo=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	set Response=##class(web.DHCENS.STBLL.MANAGE.MODEL.Response).%New()
	
	set header=##class(web.DHCENS.STBLL.MANAGE.MODEL.Header).%New()
	set header.SourceSystem="02"
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.MANAGE.MODEL.Respbody).%New()
	
	
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
	}
	else{
		set PAADMVisitNumber=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/OrdersBillStatusRt/PAADMVisitNumber","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set PAADMVisitNumber=$tr(fieldValue,$c(0),"")
		}
		set OEORIOrderItemID=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/OrdersBillStatusRt/OEORIOrderItemID","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set OEORIOrderItemID=$tr(fieldValue,$c(0),"")
		}
		set OEORIQty=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/OrdersBillStatusRt/OEORIQty","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set OEORIQty=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/OrdersBillStatusRt/Flag","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set Flag=$tr(fieldValue,$c(0),"")
		}
		set AdmType=$p($g(^PAADM(PAADMVisitNumber)),"^",2)
		set rtn=""
		if (OEORIOrderItemID'["||")&&(Flag="OE")
		{
			set rtn=##class(web.UDHCJFARREARSMANAGE).CheckArrears(PAADMVisitNumber,OEORIOrderItemID,Flag,"") //病理特检，欠费控制
		}
		else
		{
			set OrdStatusRowID = $p($g(^OEORD(+OEORIOrderItemID,"I",$p(OEORIOrderItemID,"||",2),1)),"^",13)   
    		if OrdStatusRowID'="" s OrdStatus=$p($g(^OEC("OSTAT",OrdStatusRowID)),"^",1)
    		if (OrdStatus="V")||(OrdStatus="E")
    		{
				if AdmType="I" set rtn=##class(web.UDHCJFARREARSMANAGE).CheckArrears(PAADMVisitNumber,OEORIOrderItemID_"||1"_$c(2)_OEORIQty,Flag)
				else  if (AdmType="O")||(AdmType="H")||(AdmType="E")  set rtn=##class(web.UDHCJFARREARSMANAGE).CheckArrears(PAADMVisitNumber,OEORIOrderItemID_$c(2)_OEORIQty,Flag)
    		}
    		else
    		{
	    		set rtn=OrdStatus	//医嘱状态为作废或停止、撤销的，直接返回
	    	}
		}
		set respBody=##class(web.DHCENS.STBLL.MANAGE.MODEL.Respbody).%New()
		set respBody.ResultCode="0"
		set respBody.ResultContent="成功"	
		set respBody.ResultFlag=rtn
		set Response.Respbody=respBody
		
		d Response.XMLExportToStream(.stream)
		q stream
	}
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator：ZhangXinying
/// CreatDate：2021-11-22
/// Description：判断病人是否在院
/// Table：
/// Input：
/// Return：是否在院
/// Others: 
/// w ##class(web.DHCENS.STBLL.MANAGE.MergeInstance).CheckInHospital("")
ClassMethod CheckInHospital(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set suCount=0,faCount=0,faInfo=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	set Response=##class(web.DHCENS.STBLL.MANAGE.MODEL.Response).%New()
	
	set header=##class(web.DHCENS.STBLL.MANAGE.MODEL.Header).%New()
	set header.SourceSystem="02"
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.MANAGE.MODEL.Respbody).%New()
	
	
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
	}
	else{
		set PAADMVisitNumber=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/DischStatusRt/PAADMVisitNumber","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set PAADMVisitNumber=$tr(fieldValue,$c(0),"")
		}
		set rtn=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(PAADMVisitNumber)
		set responseBody.ResultCode="0"
		set responseBody.ResultContent="成功"	
		set responseBody.ResultFlag=rtn
		set responseBody.DischStatus=$case(rtn,"0":"可计费","E":"医生办理出院","C":"医生撤销办理出院","F":"护士办理出院","R":"护士召回病人","B":"费用调整","T":"结束费用调整",:"")
		set AdmVisitStatus=$p($g(^PAADM(PAADMVisitNumber)),"^",20)
		if (rtn="")&&(AdmVisitStatus="A") 
		{
			set responseBody.ResultFlag="1"
			set responseBody.DischStatus="在院"
		}
		set Response.Respbody=responseBody
			
		d Response.XMLExportToStream(.stream)
		q stream
	}
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator：ZhangXinying
/// CreatDate：2021-11-22
/// Description：消息提示接口
/// Table：
/// Input：
/// Return：消息提示推送
/// Others: 
/// w ##class(web.DHCENS.STBLL.MANAGE.MergeInstance).GetMessageNotify("")
ClassMethod GetMessageNotify(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set suCount=0,faCount=0,faInfo=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	set Response=##class(web.DHCENS.STBLL.MANAGE.MODEL.Response).%New()
	
	set header=##class(web.DHCENS.STBLL.MANAGE.MODEL.Header).%New()
	set header.SourceSystem="02"
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.MANAGE.MODEL.Respbody).%New()
	
	
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
	}
	else{
		set (Context,ActionTypeCode,FromUserRowId,PAADMVisitNumber,OrdItemId,ToUserRowId,OtherInfoJson,ToLocRowId,EffectiveDays,CreateLoc)=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/MsgSendRt/Context","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set Context=$tr(fieldValue,$c(0),"")
		}	
		set tSC=tDocument.EvaluateExpression("/Request/Body/MsgSendRt/ActionTypeCode","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set ActionTypeCode=$tr(fieldValue,$c(0),"")
		}
		
		set tSC=tDocument.EvaluateExpression("/Request/Body/MsgSendRt/FromUserRowId","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set FromUserRowId=$tr(fieldValue,$c(0),"")
			if $d(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(FromUserRowId,"U"))) s FromUserRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(FromUserRowId,"U"),""))
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/MsgSendRt/OrdItemId","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set OrdItemId=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/MsgSendRt/ToUserRowId","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set ToUserRowId=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/MsgSendRt/OtherInfoJson","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set OtherInfoJson=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/MsgSendRt/ToLocRowId","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set ToLocRowId=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/MsgSendRt/EffectiveDays","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set EffectiveDays=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/MsgSendRt/CreateLoc","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set CreateLoc=$tr(fieldValue,$c(0),"")
		}
		set rtn=##class(websys.DHCMessageInterface).Send(Context,ActionTypeCode,FromUserRowId,PAADMVisitNumber,OrdItemId,ToUserRowId,OtherInfoJson,ToLocRowId,EffectiveDays,CreateLoc)
		set respBody=##class(web.DHCENS.STBLL.MANAGE.MODEL.Respbody).%New()
		set respBody.ResultCode="0"
		set respBody.ResultContent="成功"	
		set respBody.ResultFlag=rtn
		set Response.Respbody=respBody
		d Response.XMLExportToStream(.stream)
		q stream
	}
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator：ZhangXinying
/// CreatDate：2021-11-22
/// Description：判断是否HIS用户
/// Table：
/// Input：
/// Return：是否HIS用户
/// Others: 
/// w ##class(web.DHCENS.STBLL.MANAGE.MergeInstance).CheckIfHisUser("")
ClassMethod CheckIfHisUser(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set suCount=0,faCount=0,faInfo=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	set Response=##class(web.DHCENS.STBLL.MANAGE.MODEL.Response).%New()
	set header=##class(web.DHCENS.STBLL.MANAGE.MODEL.Header).%New()
	set header.SourceSystem="02"
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.MANAGE.MODEL.Respbody).%New()
	
	
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
	}
	else{
		set UserCode=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/CheckUserRt/UserCode","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set UserCode=$tr(fieldValue,$c(0),"")
		}
		if $d(^SSU("SSUSR",0,"SSUSR_Initials",UserCode))||($d(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(UserCode,"U"))))||($d(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode))))
		{
			set responseBody.ResultCode="0"
			set responseBody.ResultContent="成功"	
			set responseBody.ResultFlag="Y"	
		}
		else{
			set responseBody.ResultCode="0"
			set responseBody.ResultContent="成功"	
			set responseBody.ResultFlag="N"	
		}
		set Response.Respbody=responseBody
			
		d Response.XMLExportToStream(.stream)
		q stream
	}
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator：ZhangXinying
/// CreatDate：2021-11-22
/// Description：获取医嘱明细信息，公共接口
/// Table：OE_OrdItem
/// Input：
/// Return：医嘱明细信息xml
/// Others: 
/// w ##class(web.DHCENS.STBLL.MANAGE.MergeInstance).GetOEORIInfoList("")
ClassMethod GetOEORIInfoList(inputContent As %GlobalCharacterStream) As %GlobalCharacterStream
{
	s $zt="Err"
	set specimenNo=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(inputContent,.tDocument)
	if $$$ISERR(tSC) {
		Quit "-1^"_tSC
	}else{
		set tSC=tDocument.EvaluateExpression("/Request/Body/OEORIInfoRt/OEORIOrderItemID","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set OEORIOrderItemID=tRes.GetAt(1).Value							
			set OEORIOrderItemID=$tr(OEORIOrderItemID,$c(0),"")
		}
	}
	s stream=##class(%GlobalCharacterStream).%New()
	s stream=##class(web.DHCENS.STBLL.ORDER.METHOD.OEOrder).OEOrder(OEORIOrderItemID)
	q stream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	q stream
}

/// Creator：ZhangXinying
/// CreatDate：2022—08-06
/// Description：根据系统代码、科室代码判断HIS医技共库分库模式
/// Table：Ens_ApiSysConfig
/// Input：SystemCode:系统代码（AN、US、LIS、PACS、RIS、EKG、ES、PIS、EM）,系统所属科室代码
/// Return：共库、分库  
/// Debug:w ##class(web.DHCENS.STBLL.MANAGE.MergeInstance).GetSystemDbMode("RIS","ZYYJ005")
ClassMethod GetSystemDbMode(SystemCode As %String = "", DeptCode As %String = "") As %String
{
	try
	{	
		s apiSysConfigID="",dbMode=""
		q:SystemCode="" 
		for { 
	 		s apiSysConfigID=$o(^Config.ENS.EnsApiSysConfigI("systemCodeIndex",SystemCode,apiSysConfigID))
			q:apiSysConfigID=""
			s dbStatus=$lg($g(^Config.ENS.EnsApiSysConfigD(apiSysConfigID)),8)
			continue:dbStatus="N" 
			s dbDept=$lg($g(^Config.ENS.EnsApiSysConfigD(apiSysConfigID)),9)
			continue:(DeptCode'="")&&(dbDept'[DeptCode) 
			if DeptCode'=""
			{
				s DeptLocDr=$o(^CTLOC(0,"Code",$zcvt(DeptCode,"U"),""))
				q:DeptLocDr=""
				s HospDr=$p($g(^CTLOC(DeptLocDr)),"^",22)
				q:HospDr=""
				s HospCode=$p($g(^CT("HOSP",HospDr)),"^",1)
				s dbHospital=$lg($g(^Config.ENS.EnsApiSysConfigD(apiSysConfigID)),4)
				continue:(HospCode'="")&&(HospCode'=dbHospital)	
			}
			s dbMode=$lg($g(^Config.ENS.EnsApiSysConfigD(apiSysConfigID)),6)
			
		}
	}
	catch
	{
		s dbMode=""
	}
	q dbMode
}

}
