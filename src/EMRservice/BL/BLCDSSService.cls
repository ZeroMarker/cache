/// desc第三方智能诊断工具（CDSS）逻辑处理类
/// creator duan
/// createDate 2020-06-03
Class EMRservice.BL.BLCDSSService Extends %RegisteredObject
{

/// desc 根据key取CDSS JSON结构数据
ClassMethod GetDataByKey(ACDSSTool As %String, AKeyLevel As %String, AType As %String, AAction As %String, AParamterArray As %ArrayOfDataTypes)
{
    s stream = ##class(%GlobalBinaryStream).%New()
    q:ACDSSTool="" stream
    s isActive=""
    s countChild=0
    for{
        s isActive = $O(^DHCEMRM.CDSSConfigI("cdssDataID"," "_ACDSSTool," "_$ZCVT(AKeyLevel,"U")," "_isActive))
        s isActive=$tr(isActive," ","")
        q:isActive=""
        if ((isActive=AType)||(isActive="ALL")){
            s action= ""
            for{
                s action = $O(^DHCEMRM.CDSSConfigI("cdssDataID"," "_ACDSSTool," "_$ZCVT(AKeyLevel,"U")," "_isActive," "_action))
                s action=$tr(action," ","")
                q:action=""
                if ((action=AAction)||(action="ALL")){
                    s cdssChildID = ""
                    for{
                        s cdssChildID=$O(^DHCEMRM.CDSSConfigI("cdssDataID"," "_ACDSSTool," "_$ZCVT(AKeyLevel,"U")," "_isActive," "_action,cdssChildID))
                        q:cdssChildID=""
                        s subStream = ..GetConfigDataByID(cdssChildID,AType,AAction,AParamterArray,ACDSSTool)
                        continue:subStream.IsNull()=1
                        d:countChild=0 stream.Write("{")
                        d:countChild>0 stream.Write(",")
                        s countChild = countChild+1
                        d stream.CopyFrom(subStream)
                    }
                }
            }   
        }
    }
    d:countChild>0 stream.Write("}")    
    q stream
}

/// desc 根据key取CDSS XML结构数据
ClassMethod GetXMLDataByKey(ACDSSTool As %String, AKeyLevel As %String, AType As %String, AAction As %String, AParamterArray As %ArrayOfDataTypes)
{
    s stream = ##class(%GlobalBinaryStream).%New()
    q:ACDSSTool="" stream
    s isActive=""
    s countChild=0
    for{
        s isActive = $O(^DHCEMRM.CDSSConfigI("cdssDataID"," "_ACDSSTool," "_$ZCVT(AKeyLevel,"U")," "_isActive))
        s isActive=$tr(isActive," ","")
        q:isActive=""
        if ((isActive=AType)||(isActive="ALL")){
            s action= ""
            for{
                s action = $O(^DHCEMRM.CDSSConfigI("cdssDataID"," "_ACDSSTool," "_$ZCVT(AKeyLevel,"U")," "_isActive," "_action))
                s action=$tr(action," ","")
                q:action=""
                if ((action=AAction)||(action="ALL")){
                    s cdssChildID = ""
                    for{
                        s cdssChildID=$O(^DHCEMRM.CDSSConfigI("cdssDataID"," "_ACDSSTool," "_$ZCVT(AKeyLevel,"U")," "_isActive," "_action,cdssChildID))
                        q:cdssChildID=""
                    
                        s subStream = ..GetConfigXMLDataByID(cdssChildID,AType,AAction,AParamterArray)
                        s countChild = countChild+1
                        d stream.CopyFrom(subStream)
                    }
                }
            }   
        }
    }
    q stream
}

/// desc 根据CDSS结构ID取JSON结构数据
ClassMethod GetConfigDataByID(ACdssDataID As %String, AType As %String, AAction As %String, AParamterArray As %ArrayOfDataTypes, ACDSSTool As %String)
{
    s (execCode,value)=""
    s stream = ##class(%GlobalBinaryStream).%New()
    s cdssObj = ##class(EMRmeta.CDSS.CDSSConfig).%OpenId(ACdssDataID)
    q:cdssObj="" stream
    s key = cdssObj.CDSSKey
    s keyType = cdssObj.CDSSKeyType
    s keyValue = $ZSTRIP(cdssObj.CDSSKeyValue,"*C")
    if (keyType="value"){
        d stream.Write(""""_key_""":"""_keyValue_"""")
    }elseif(keyType="param"){
        s value = ..GetExecCode(keyValue,keyValue,AParamterArray)
        s value=$Replace(value,"""","")
        d stream.Write(""""_key_""":"""_value_"""")
    }elseif(keyType="string"){
        s execCode=..GetExecCode(keyValue,"",AParamterArray)
        s:execCode'="" @execCode
        s:execCode'="" value = @"result"
        d stream.Write(""""_key_""":"""_value_"""") 
    }
    elseif(keyType="stream"){
        s execCode=..GetExecCode(keyValue,"",AParamterArray)    
        s:execCode'="" @execCode
        s:execCode'="" value = @"result"
        d stream.Write(""""_key_""":")
        if (value.IsNull()=1){
	        d value.Write("""""")
	        d stream.CopyFrom(value)
	    }else{
			d stream.Write("""")
			d stream.CopyFrom(value)
			d stream.Write("""")
		}
        
    }elseif(keyType="arrayString"){
        s execCode=..GetExecCode(keyValue,"",AParamterArray)    
        s:execCode'="" @execCode
        s:execCode'="" value = @"result"
        d stream.Write(""""_key_""":[""")
        d stream.Write(value)
        d stream.Write("""]")
    }elseif(keyType="arrayStream"){
        s execCode=..GetExecCode(keyValue,"",AParamterArray)    
        s:execCode'="" @execCode
        s:execCode'="" value = @"result"
        d stream.Write(""""_key_""":[")
		d stream.CopyFrom(value) 
        d stream.Write("]")
    }elseif(keyType="arrayChild"){
        d stream.Write(""""_key_""":[")
        s arrayStream = ..GetDataByKey(ACDSSTool,key,AType,AAction,AParamterArray)
        d stream.CopyFrom(arrayStream)
        d stream.Write("]")
    }elseif(keyType="objectChild"){
        d stream.Write(""""_key_""":")
        s objectStream = ..GetDataByKey(ACDSSTool,key,AType,AAction,AParamterArray)
        if (objectStream.IsNull()=1){
	        d objectStream.Write("""""")
	        d stream.CopyFrom(objectStream)
	    }else{
		   d stream.CopyFrom(objectStream) 
		}
        
    }elseif(keyType="emrData")
    {
        s execCode=..GetExecCode(keyValue,"",AParamterArray)    
        s:execCode'="" @execCode
        s:execCode'="" value = @"result"
        d:value.IsNull()'=1 stream.CopyFrom(value)  
    }elseif(keyType="objstream"){
	    
	    s hdsdcode =cdssObj.HDSDCode
	    if (hdsdcode'="")&&(hdsdcode["HDSD")
	    {
	   		s docId = AParamterArray.GetAt("ADocID")
	   		s InstanceID = AParamterArray.GetAt("AInstanceID")
	   		s cdssTool = AParamterArray.GetAt("ACdssTool")
	   		s objIstance = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
			q:(objIstance = "") stream
			
			if (objIstance.TitleCode '= "")&&(objIstance.TheECRecord.ChartItemType = "Multiple")
			{
				s hdsdcodeHDSDLinkEMRDoc = $o(^DHCEMRM.CDSS.HDSDLinkEMRDocI("IdxEMRDocCode"," "_cdssTool," "_docId," "_$zcvt(objIstance.TitleCode,"u"),""))
			
				q:($e(hdsdcodeHDSDLinkEMRDoc,2,*)'=hdsdcode) stream
			}
			else
			{
    			q:($d(^DHCEMRM.CDSS.HDSDLinkEMRDocI("IdxEMRDocHDSD"," "_ACDSSTool," "_docId," "_hdsdcode))=0) stream
			}
	    }
        s execCode=..GetExecCode(keyValue,"",AParamterArray)    
        s:execCode'="" @execCode
        s:execCode'="" value = @"result"
        d stream.Write(""""_key_""":{")
        if (value.IsNull()=1){
	        
	    }else{
			d stream.CopyFrom(value)
		}
		d stream.Write("}")
        
    }
    q stream
}

/// desc 根据CDSS结构ID取XML结构数据
ClassMethod GetConfigXMLDataByID(ACdssDataID As %String, AType As %String, AAction As %String, AParamterArray As %ArrayOfDataTypes, ACDSSTool As %String)
{
    s (execCode,value)=""
    s stream = ##class(%GlobalBinaryStream).%New()
    s cdssObj = ##class(EMRmeta.CDSS.CDSSConfig).%OpenId(ACdssDataID)
    q:cdssObj="" stream
    s key = cdssObj.CDSSKey
    s keyType = cdssObj.CDSSKeyType
    s keyValue = $ZSTRIP(cdssObj.CDSSKeyValue,"*C")
    d stream.Write("<"_key_">")
    if (keyType="value")
    {
        d stream.Write(keyValue)    
    }
    elseif(keyType="param")
    {
        s value = ..GetExecCode(keyValue,keyValue,AParamterArray)
        s value=$Replace(value,"""","")
        d stream.Write(value)
    }
    elseif(keyType="string")
    {
        s execCode=..GetExecCode(keyValue,"",AParamterArray)
        s:execCode'="" @execCode
        s:execCode'="" value = @"result"
        d stream.Write(value)       
    }
    elseif(keyType="stream")
    {
        s execCode=..GetExecCode(keyValue,"",AParamterArray)    
        s:execCode'="" @execCode
        s:execCode'="" value = @"result"
        d stream.CopyFrom(value)
    }
    elseif(keyType="objectChild")
    {
        s objectStream = ..GetDataByKey(ACDSSTool,key,AType,AAction,AParamterArray)
        d stream.CopyFrom(objectStream) 
    }
    d stream.Write("</"_key_">")
    q stream
}

/// desc 对KeyValue字段：值中存在的参数处理
ClassMethod GetExecCode(AKeyValue As %String, AParamter As %String, AParamterArray As %ArrayOfDataTypes)
{
    s paramter=AParamter
    s:paramter="" paramter = $P($P(AKeyValue,"(",3),")",1)
    s countParam = $L(paramter,",")
    for i=1:1:countParam
    {
        s paramItem=$P(paramter,",",i)
        continue:paramItem=""
        s defined = AParamterArray.IsDefined(paramItem)
        s:(defined=1) AKeyValue = $Replace(AKeyValue,paramItem,""""_AParamterArray.GetAt(paramItem)_"""")
        s:(defined=0) AKeyValue = $Replace(AKeyValue,paramItem,""""_paramItem_"""")
    }
    q AKeyValue
}

/// desc: 智能诊断工具相关js引入
/// creator：duan
/// createdate: 2020-01-01
/// debug: d ##class(EMRservice.BL.BLCDSSService).getCDSSUrl()
ClassMethod getCDSSUrl()
{
    s cdssType =""
    s cdssLock = ##class(EMRservice.BL.BLCDSSTool).GetCDSSLock()
    q:(cdssLock="") ""
	s userLocID = %session.Get("LOGON.CTLOCID")
	s userID = %session.Get("LOGON.USERID")
	
	for i=1:1:$L(cdssLock,"#")
    {
	    s cdssLockMessage= $P(cdssLock,"#",i)
	    s cdssLockType = $P(cdssLockMessage,"&",2)
	    s cdssLockFlag = $P(cdssLockMessage,"&",1)
	    s cdssDoc = $P(cdssLockFlag,"^",2)
    	s isCdssLock = $P(cdssLockFlag,"^",1)
		
		//指定科室开启逻辑
    	if (cdssLockType ="CDSSDH")
    	{
	    	if (isCdssLock="Y")	
	    	{
		    	//s isONStatus = ##class(web.DHCBL.BDP.BDPCDSSDeptUserAut).GetCDSSUserAutFlag(userLocID,userID)
		    	//优化为CDSSDH调用基础平台提供的接口进行判定启用
		    	s enableCDSSInfo = ##class(CF.BSP.SYS.SRV.CDSSService).GetEnableCDSS(userLocID , userID)
		    	
		    	q:(+enableCDSSInfo'=1)
		    	q:($l(enableCDSSInfo,"^")=1)
		    	
		    	s isONStatus = 0 
		    	for i=2:1:$l(enableCDSSInfo,"^")
		    	{
			    	s tmpCDSSInfo = $p(enableCDSSInfo,"^",i)
			    	s cdssCode = $p(tmpCDSSInfo,",",2)
			    	continue:($zcvt(cdssCode,"L") '= "mediway")
			    	s isONStatus = 1
			    }
		    	
		    	if (isONStatus = 1)
		    	{
			    	s:cdssType'="" cdssType = cdssType_"#"_ cdssLockType	
		            s:cdssType="" cdssType = cdssLockType
			    }
		    }
	    }
    	else
    	{
			if ((isCdssLock="Y")&(cdssDoc="")){
				//全院开启
				s:cdssType'="" cdssType =cdssType_"#"_cdssLockType	
				s:cdssType="" cdssType= cdssLockType
			}elseif ((isCdssLock="Y")&(cdssDoc'="")){
				// 指定科室开启
				for n=1:1:$L(cdssDoc,",")
				{
					if ($P(cdssDoc,",",n)=userLocID){
						s:cdssType'="" cdssType = cdssType_"#"_ cdssLockType	
						s:cdssType="" cdssType = cdssLockType
					}
				}  
			}
		}
	}
    q:cdssType="" ""
    
    for m=1:1:$L(cdssType,"#")
    {
	    w "<script type=""text/javascript"" src=""../scripts/emr/js/"_$P(cdssType,"#",m)_".js""></script>" ,!
    }
    w "<script type=""text/javascript"" src=""../scripts/emr/js/cdssTools.js""></script>"
}

/// desc 根据就诊号取主管医师
/// debug result=##class(EMRservice.BL.BLCDSSService).GetMainDoc(AEpisodeID,"name")
ClassMethod GetMainDoc(AEpisodeID As %String, AParamterType As %String)
{
    q:((AEpisodeID="")||(AParamterType="")) ""
    s (result,mainDocCode,mainDocName)=""
    //主管医师
    s mainDoc = ##class(EMRservice.HISInterface.PatientInfoAssist).MainDoc(AEpisodeID)
    s:mainDoc'="" mainDocCode=$P(mainDoc,"^",2)
    s:mainDoc'="" mainDocName=$P(mainDoc,"^",3)
    s result=mainDoc
    s:AParamterType="code" result=mainDocCode
    s:AParamterType="name" result=mainDocName
    q result
}

/// desc 根据HospitalID 取医院名称
/// debug result=##class(EMRservice.BL.BLCDSSService).GetHospitalName(AHospitalID)
ClassMethod GetHospitalName(AHospitalID As %String)
{
    s hospitalName =$Case(AHospitalID,"":"",:$P($G(^CT("HOSP",AHospitalID)),"^",2))
    q hospitalName
}

/// desc 根据HospitalID 取医院Code
/// debug result=##class(EMRservice.BL.BLCDSSService).GetHospitalCode(AHospitalID)
ClassMethod GetHospitalCode(AHospitalID As %String)
{
    s hospitalCode =$Case(AHospitalID,"":"",:$P($G(^CT("HOSP",AHospitalID)),"^",1))
    q hospitalCode
}

/// desc 根据登陆科室ID取登陆科室名字
/// debug result=##class(EMRservice.BL.BLCDSSService).GetUserLocName(AUserLocID)
ClassMethod GetUserLocName(AUserLocID As %String)
{
    s userLocName = $Case(AUserLocID,"":"",:$p($G(^CTLOC(AUserLocID)),"^",2))
    q userLocName
}

/// desc 根据登陆科室ID取登陆科室编码
/// debug result=##class(EMRservice.BL.BLCDSSService).GetUserLocCode(AUserLocID)
ClassMethod GetUserLocCode(AUserLocID As %String)
{
    s userLocCode = $Case(AUserLocID,"":"",:$p($G(^CTLOC(AUserLocID)),"^",1))
    q userLocCode
}

/// 根据登录用户ID取登录用户名称
/// result=##class(EMRservice.BL.BLCDSSService).GetUserName(AUserID)
ClassMethod GetUserName(AUserID As %String)
{
    s userName = $Case(AUserID,"":"",:$p($G(^SSU("SSUSR",AUserID)),"^",2))
    q userName
}

/// 根据登录用户ID取登录用户Code
/// result=##class(EMRservice.BL.BLCDSSService).GetUserCode(AUserID)
ClassMethod GetUserCode(AUserID As %String)
{
    s userCode = $Case(AUserID,"":"",:$p($G(^SSU("SSUSR",AUserID)),"^",1))
    q userCode
}

/// desc 根据就诊号取patientNo
/// debug result=##class(EMRservice.BL.BLCDSSService).GetPatientNo(AEpisodeID)
ClassMethod GetPatientNo(AEpisodeID As %String)
{
    q:AEpisodeID="" ""
    s patientNo=""
    s patientID = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
    s:patientID'="" patientNo = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(patientID)
    q patientNo
}

/// desc 获取身份证号
/// debug result=##class(EMRservice.BL.BLCDSSService).IDCard(AEpisodeID)
ClassMethod IDCard(AEpisodeID As %String)
{
    q:AEpisodeID="" ""
    s IDCard=""
    s patientID = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
    s IDCard=##class(EMRservice.HISInterface.PatientInfoAssist).IDCard(patientID)
    q IDCard
}

/// desc 根据就诊号取患者就诊类型
/// debug result=##class(EMRservice.BL.BLCDSSService).GetEpisodeType(AEpisodeID)
ClassMethod GetEpisodeType(AEpisodeID As %String)
{
    q:AEpisodeID="" ""
    s episodeType=""
    s episodeType = $ZCVT($p($G(^PAADM(AEpisodeID)),"^",2),"U")
    q episodeType
}

/// desc 根据就诊号取患者入院时间
/// debug result=##class(EMRservice.BL.BLCDSSService).GetAdmDateTime(AEpisodeID)
ClassMethod GetAdmDateTime(AEpisodeID As %String)
{
    q:(AEpisodeID="") ""
    s admDateTime=""
    //入院时间
    s admDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(AEpisodeID)
    s:admDateTime'="" admDateTime = $ZDateTime(admDateTime,3)
    q admDateTime
}

/// desc 根据就诊号取患者名字
/// debug result=##class(EMRservice.BL.BLCDSSService).GetName(AEpisodeID)
ClassMethod GetName(AEpisodeID As %String)
{
    q:AEpisodeID="" ""
    s name=""
    s patientId = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
    s:patientId'="" name = ##class(EMRservice.HISInterface.PatientInfoAssist).Name(patientId)   
    q name
}

/// desc 根据就诊号取患者年龄
/// debug result=##class(EMRservice.BL.BLCDSSService).GetAge(AEpisodeID)
ClassMethod GetAge(AEpisodeID As %String)
{
    q:AEpisodeID="" ""
    s age=""
    s patientId = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
    s admDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(AEpisodeID)
        //s age = ##Class(web.YGRHCommon).GetAgeDaysByEpisodeID(AEpisodeID)
    s admDate = $P(admDateTime,",",1)
    s admTime = $P(admDateTime,",",2)
    s age= ##Class(EMRservice.HISInterface.PatientInfoAssist).Age(patientId,AEpisodeID,admDate,admTime)
    s:age'="" age=$Replace(age,"岁","")
    q age
}

/// 二版 取病历相关数据
/// debug唯一模板使用ECrecordID w ##Class(EPRservice.BLCDSSserverceNew).getInstanceData(9910742,21456618,505)
/// 可重复模板 w ##Class(EPRservice.BLCDSSserverceNew).getInstanceData("9910589","21443631||4","509")
ClassMethod GetInstanceDataEPR(argEpisodeID As %String, argInstanceID As %String, argDocID As %String, argParam As %String = "")
{
    //s ^Temp("duan","getInstanceData")=argEpisodeID_","_argInstanceID_","_argDocID
    q:argInstanceID="" ""
    s (result,progressTypeTitle,createDate,createTime,createDateTime,rowid)=""
    s instanceIDFlag = $P(argInstanceID,"||",2)
    if (instanceIDFlag'=""){
        //可重复模板
        s objInstance=##Class(EPRinstance.InstanceData).%OpenId(argInstanceID)
        q:objInstance=""
        s progressTypeTitle = objInstance.Title
        s createDate = $ZDate(objInstance.CreateDate,3)
        s createTime = $ZTime(objInstance.CreateTime,1)
        s createDateTime = createDate_" "_createTime
    }else{
        //唯一模板 从日志表取创建时间
        &SQL(select CreateDate,CreateTime into :createDate,:createTime from EPRInstance.EPRLogs where EpisodeID = :argEpisodeID and EPRDocID = :argDocID)
        s:createDate'="" createDate = $ZDate(createDate,3)
        s:createTime'="" createTime = $ZTime(createTime,1)
        s createDateTime = createDate_" "_createTime
        //唯一模板 从病历展现结构取标题名称
        s objInstanceCategory = ##class(EPRmeta.EPRTemplateCategory).%OpenId(argDocID)
        q:objInstanceCategory=""
        s parentId = objInstanceCategory.ParentCategoryID
        s objInstanceCategoryParent = ##class(EPRmeta.EPRTemplateCategory).%OpenId(parentId)
        q:objInstanceCategoryParent=""
        s progressTypeTitle = objInstanceCategoryParent.CategoryName
    }
    s:argParam="createdatetime" result=createDateTime
    s:argParam="title" result=progressTypeTitle
    q result
}

/// desc 新版 取病历相关数据
/// debug result=##Class(EMRservice.BL.BLBaiDuCDSSService).GetInstanceData(AInstanceID,"title")
ClassMethod GetInstanceDataEMR(AInstanceID As %String, AParamterType As %String)
{
    q:AInstanceID="" ""
    s (result,objInstance)=""
    s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
    q:objInstance="" result
    s createDate = objInstance.CreateDate
    s createTime = objInstance.CreateTime
    s createDateTime = $ZDate(createDate,3)_" "_$ZTime(createTime,1)
    s title = objInstance.Title
    s:AParamterType="title" result=title
    s:AParamterType="createdatetime" result=createDateTime
    q result
}

/// JSON串特殊字符处理
ClassMethod JsonEscape(AValue As %String)
{
        s result = AValue
        s result = $Replace(result,"\","\\")
        s result = $Replace(result,"""","\""")
        s result = $Replace(result,"\\b","\b")
        s result = $Replace(result,"\\f","\f")
        s result = $Replace(result,"\\n","\n")
        s result = $Replace(result,"\\r","\r")
        s result = $Replace(result,"\\t","\t")
        q result
}

/// Desc:       处理XML不合法字符串
/// Creator:    duan
/// CreateDate: 2019-10-30  
/// Input:      AValue 字符串描述
/// OutPut:     result 处理好的字符串 
/// Debug:   w ##Class(EMRservice.Util.EscapeSpecialWord).XmlEscape("<<10ml")
ClassMethod XmlEscape(AValue As %String)
{
        s result = AValue
        s result = $Replace(result,"&","&amp;")
        s result = $Replace(result,"<","&lt;")
        s result = $Replace(result,">","&gt;")  
        q result
}

/// 二版病历 唯一模板取ECrecordID
/// w ##Class(EMRservice.BL.BLCDSSService).GetInstanceID(11305664,507)
ClassMethod GetECRecordID(AEpisodeID As %String, ADocID As %String)
{
    //s ^Temp("GetInstanceID")=argEpisodeID_"^"_argDocID
    q:(AEpisodeID="")||(ADocID="") ""
    s result=""
    s rowId=""
    for{
        s rowId=$O(^DHCEPRM.EPRTemplateI("IdxEPRCategoryID"," "_ADocID,rowId))
        q:rowId=""
        s templateObj = ##class(EPRmeta.EPRTemplate).%OpenId(rowId)
        continue:templateObj=""
        s bindTemplateID = templateObj.BindTemplateID
        s chartItemID = "CG"_bindTemplateID
        s strECRowID = ""
        s strECRowID = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_chartItemID,strECRowID))
        s result=strECRowID
        q:result'=""
    }
    q result
}

/// desc 根据就诊号取患者当前科室
/// debug result=##class(EMRservice.BL.BLCDSSService).GetCurrentDept(AEpisodeID,name)
ClassMethod GetCurrentDept(AEpisodeID As %String, AParamterType As %String)
{
    q:(AEpisodeID="") ""
    s (result,currentDeptName,currentDeptId)=""
    s currentDept = ##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(AEpisodeID)
    s:(currentDept '="") currentDeptName = $P(currentDept,"^",3)
    s:(currentDept '="") currentDeptId = $P(currentDept,"^",1)
    s result=currentDept
    s:AParamterType="id" result=currentDeptId
    s:AParamterType="name" result=currentDeptName
    q result
}

/// desc 根据就诊号取患者当前病区
/// debug result=##class(EMRservice.BL.BLCDSSService).GetCurrentWard(AEpisodeID,name)
ClassMethod GetCurrentWard(AEpisodeID As %String, AParamterType As %String)
{
    q:(AEpisodeID="") ""
    s (result,currentWardName,currentWardId)=""
    s currentWard = ##class(EMRservice.HISInterface.PatientInfoAssist).DisWard(AEpisodeID)
    s:(currentWard '="") currentWardName = $P(currentWard,"^",3)
    s:(currentWard '="") currentWardId = $P(currentWard,"^",1)
    s result=currentWard
    s:AParamterType="id" result=currentWardId
    s:AParamterType="name" result=currentWardName
    q result
}

/// desc 根据就诊号取患者床号
/// debug result=##class(EMRservice.BL.BLCDSSService).GetCurrentBed(AEpisodeID)
ClassMethod GetCurrentBed(AEpisodeID As %String)
{
    q:(AEpisodeID="") ""	
    s currentBed=""
    //入院时间
    s currentBed = ##class(EMRservice.HISInterface.PatientInfoAssist).DisBed(AEpisodeID)
    q currentBed
}

/// desc 判断病历是新版还是旧版 count>0 旧版
/// debug ##class(EMRservice.BL.BLCDSSService).GetOldRecCount(12189264)
ClassMethod GetOldRecCount(AEpisodeID As %String) As %Integer
{
    s $zt="errhandler"
    k SLQCODE
    s count=-1
    &sql(select count(*) into :count from EPRinstance.ECRecord where EpisodeID = :AEpisodeID)   
    q count
errhandler
    q -1
}

/// desc 判断当前模板是否关联了CDSS（2版）
ClassMethod isConnectCDSSEPR(AParam As %ArrayOfDataTypes)
{
    s result=0
    q:AParam="" result
    s objInstance=""
    s AInstanceID=AParam.GetAt("AInstanceID")
    s cdssTool = AParam.GetAt("ACdssTool")
    s ADocID = AParam.GetAt("ADocID")
    s instanceIDFlag = $P(AInstanceID,"||",2)
    s:instanceIDFlag'="" objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
    q:((instanceIDFlag'="")&(objInstance="")) result
    if ((AInstanceID'="") && (instanceIDFlag'=""))
    {
        s hdsdcode = $o(^DHCEMRM.CDSS.HDSDLinkEMRDocI("IdxEMRDocCode"," "_cdssTool," "_ADocID," "_objInstance.Title,""))
    }
    else
    {
        s hdsdcode = $o(^DHCEMRM.CDSS.HDSDLinkEMRDocI("IdxEMRDocHDSD"," "_cdssTool," "_ADocID,""))
    }
    s hdsdcode = $tr(hdsdcode," ","")
    s:hdsdcode'="" result=1
    q result
}

/// desc 判断当前模板是否关联了CDSS（新版）
ClassMethod isConnectCDSSEMR(AParam As %ArrayOfDataTypes)
{
    s result=0
    q:AParam="" result
    s objInstance=""
    s AInstanceID=AParam.GetAt("AInstanceID")
    s ADocID = AParam.GetAt("ADocID")
    s cdssTool = AParam.GetAt("ACdssTool")
    s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
    q:(objInstance = "") result
    
    if (objInstance.TitleCode '= "")&&(objInstance.TheECRecord.ChartItemType = "Multiple")
    {
        s hdsdcode = $o(^DHCEMRM.CDSS.HDSDLinkEMRDocI("IdxEMRDocCode"," "_cdssTool," "_ADocID," "_$zcvt(objInstance.TitleCode,"u"),""))
    }
    else
    {
        s hdsdcode = $o(^DHCEMRM.CDSS.HDSDLinkEMRDocI("IdxEMRDocHDSD"," "_cdssTool," "_ADocID,""))
    }
    
    s hdsdcode = $tr(hdsdcode," ","")
    s:hdsdcode'="" result=1
    q result
}

/// desc 根据就诊号取出生日期
/// debug result=##class(EMRservice.BL.BLCDSSService).GetBirthDate(AEpisodeID)
ClassMethod GetBirthDate(AEpisodeID As %String)
{
    q:AEpisodeID="" ""
    s result=""
    s patientId = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
    s Birthday=##Class(EMRservice.HISInterface.PatientInfoAssist).Birthday(patientId)
    if (Birthday'=""){
        s result =  $ZDateTime(Birthday,3)
    }
    q result
}

/// desc 根据就诊号取性别
/// debug result=##class(EMRservice.BL.BLCDSSService).GetGender(AEpisodeID)
ClassMethod GetGender(AEpisodeID As %String)
{
    q:(AEpisodeID = "") ""
    s (gender,patientId) =""
    s patientId = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
    s:patientId'="" gender = ##class(EMRservice.HISInterface.PatientInfoAssist).Gender(patientId, "")
    s:gender'="" gender = $P(gender, "^", 3)
    q gender
}

/// desc 获取时间戳
/// debug result=##class(EMRservice.BL.BLCDSSService).GetTimeStamp()
ClassMethod GetTimeStamp()
{
    s nowdate = $H
    s date = $P(nowdate,",",1)
    s time = $P(nowdate,",",2)
    s timeStamp = date*24*60*60+time
    q timeStamp
}

/// desc 获取就诊次数
/// debug result=##class(EMRservice.BL.BLCDSSService).GetEpisodeIDNum(AEpisodeID)
ClassMethod GetEpisodeIDNum(AEpisodeID As %String)
{
    s count=0
    s flag = "住院"
    q:AEpisodeID="" count
    s episodeType = ##class(EMRservice.BL.BLCDSSService).GetEpisodeType(AEpisodeID)
    s:episodeType="O" flag = "门诊"
    s:episodeType="E" flag = "急诊" 
    s ApatientId = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
    s ds = ##Class(%Library.ResultSet).%New("EMRservice.HISInterface.EpisodeInfo:GetEpisodeListByPID")
    d ds.Execute(ApatientId,"","")
    While (ds.Next()) {
        continue:(flag'=ds.Data("EpisodeType"))
        s count=count+1 
    }
    q count
}

/// Desc:       取病历文书与CDSS系统的对照ID
/// Creator:    duan
/// CreateDate: 2020-07-08
/// Input:      ADocID ADocID 病历目录展现结构第三层ID
/// Output:     CDSS对应文档代码
/// Debug:      result=##Class(EMRservice.BL.BLCDSSService).GetCDSSCode(ADocID,AInstanceID,"progresstype")
/// Debug:     w ##Class(EMRservice.BL.BLCDSSService).GetCDSSCode(390,"1112443||1","progresstype")
ClassMethod GetCDSSCode(ADocID As %String, AInstanceID As %String, AParamterType As %String, ACdssTool As %String) As %String
{
    q:((ADocID = "")||(AInstanceID = "")||(AParamterType="")) ""
    s (result,Id,objInstance,titleCode,cdssInstance) = ""
    s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
    q:(objInstance = "") result
    if (objInstance.TitleCode '= "")&&(objInstance.TheECRecord.ChartItemType = "Multiple")
    {
        s titleCode = $zcvt(objInstance.TitleCode,"u")
        
        s Id = $o(^DHCEMRM.CDSS.HDSDLinkCDSSI("IdxHDSDCDSSMul"," "_ACdssTool," "_ADocID," "_$zcvt(objInstance.TitleCode,"u"),""))
    }
    else
    {
        s Id = $o(^DHCEMRM.CDSS.HDSDLinkCDSSI("IdxHDSDCDSSSin"," "_ACdssTool," "_ADocID,""))
    }   
    q:(Id = "") result
    s cdssInstance = ##class(EMRmeta.CDSS.HDSDLinkCDSS).%OpenId(Id)
    q:cdssInstance="" result
    s progressType = $tr(cdssInstance.CDSSCode," ","")
    s progressTypeName = cdssInstance.DocumentDesc
    s:AParamterType="progresstype" result= progressType
    s:AParamterType="progresstypename" result= progressTypeName
    q result
}

/// desc  取模板ID和模板名称
/// debug result=##class(EMRservice.BL.BLCDSSService).GetTemplate(AInstanceID,title)
ClassMethod GetTemplate(AInstanceID As %String, Aparamter As %String)
{
    s (result,objInstance,objTemplate)=""
    q:AInstanceID="" 
    s objInstance = ##class(EMRinstance.InstanceData).%OpenId(AInstanceID)
    q:AInstanceID="" ""
    s templateID = objInstance.TemplateID
    s:templateID'="" objTemplate = ##class(EMRmeta.Template).%OpenId(templateID)
    q:objTemplate="" ""
    s templateTitle = objTemplate.DisplayName
    s:Aparamter="title" result = templateTitle
    s:Aparamter="id" result = templateID
    q result
}

/// desc 取病案号（住院）
/// debug result=##class(EMRservice.BL.BLCDSSService).GetIPRecordNoInfo(AEpisodeID)
ClassMethod GetIPRecordNoInfo(AEpisodeID As %String)
{
	q:AEpisodeID="" ""
	s result = ""
	// 住院病案号		[IPRecordNo]		PA_PatMas.PAPMI_Medicare
 	s result = ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(AEpisodeID,"")
 	q result
}

/// desc 配置当前系统环境为测试(TEST)/生产(PRODUCT),默认测试环境（会有很多提示信息，报错信息），测试通过后切换为生产环境，只保留必要的报错信息
/// debug w ##class(EMRservice.BL.BLCDSSService).GetEnvironment()
ClassMethod GetEnvironment()
{
	q "PRODUCT"
}

/// Desc: 取病历内容
/// Creator:Candy
/// CreateDate:2019-1-21
/// Input: argInstanceID 病历ID
/// Debug: w ##Class(EMRservice.BL.BLEpisodeRecrodService).GetDocumentContent("105||5")
ClassMethod GetDocumentContentByStream(argStream As %GlobalBinaryStream) As %GlobalBinaryStream
{
	s streamContent = ##class(%GlobalBinaryStream).%New()
	q:(argStream.Size <= 0) streamContent
	s streamScatterData = ##Class(EMRservice.Parser.StreamData).ParserStream(argStream,"<ScatterData","</ScatterData>","14")
	s sc =##class(%XML.XPATH.Document).CreateFromStream(streamScatterData,.scatterData)
	q:($$$ERROR(sc)) streamContent
	s sc = scatterData.EvaluateExpression("/ScatterData/Component","count(Section)",.sections)
	q:($$$ERROR(sc)||(sections.GetAt(1)="")) streamContent
	s count = sections.GetAt(1).Value
	s footer = ""
	for i=1:1:count
	{
		set sc=scatterData.EvaluateExpression("/ScatterData/Component/Section["_i_"]/Code","@DisplayName",.result)
		continue:($$$ERROR(sc)||(result.GetAt(1)=""))		
		s sectionName = result.GetAt(1).Value	
		//去掉页眉页脚 签名单元
		continue:(sectionName["页眉")
		continue:(sectionName["页脚")
		continue:(sectionName["签名")
		
		s:(sectionName'["：") sectionName= sectionName_"："
		d streamContent.Write(sectionName)
		s sc = scatterData.EvaluateExpression("/ScatterData/Component/Section["_i_"]/Text","text()",.result)
		continue:($$$ERROR(sc)||(result.GetAt(1)=""))
		s value = result.GetAt(1).Value
		s:(i = 2) footer = value
		continue:(i=2)
		d streamContent.Write(value)
		d streamContent.Write($c(13))	
	}
	d streamContent.Write(footer)
	q streamContent
}

/// desc 获取病历实例整份模板
/// debug result = ##class(EMRservice.BL.BLCDSSService).GetDocumentContent("1478593||2")
ClassMethod GetDocumentContent(AInstanceID As %String) As %Stream
{
	s streamContent = ##class(%GlobalBinaryStream).%New()
	q:AInstanceID="" streamContent
	
	// 8.5之前和8.5版本之后的做分支
	s Version = ##class(EMRmeta.VersionLib).GetVersion()
	if ($E(Version,6,6)=1)
	{
		s objInstance = ##class(EMRinstance.InstanceData).%OpenId(AInstanceID)
		q:(objInstance = "") streamContent
		q:(objInstance.Status '= "Save") streamContent
		d streamContent.CopyFrom(..GetDocumentContentByStream(objInstance.InstanceData))
	}
	else
	{
		d streamContent.CopyFrom(##class(EMRservice.InterfaceService.EMRRecordInfo).GetDocumentContent(AInstanceID))
	}
	q streamContent
}

/// desc 获取病历实例整份模板
/// debug result = ##class(EMRservice.BL.BLCDSSService).GetDocumentContentString("1478593||2")
ClassMethod GetDocumentContentString(AInstanceID As %String) As %String
{
	s request = ""
	q:AInstanceID="" request
	
	// 8.5之前和8.5版本之后的做分支
	s Version = ##class(EMRmeta.VersionLib).GetVersion()
	if ($E(Version,6,6)=1)
	{
		s objInstance = ##class(EMRinstance.InstanceData).%OpenId(AInstanceID)
		q:(objInstance = "") request
		q:(objInstance.Status '= "Save") request
		s streamContent = ##class(%GlobalBinaryStream).%New()
		d streamContent.CopyFrom(..GetDocumentContentByStream(objInstance.InstanceData))
	}
	else
	{
		d streamContent.CopyFrom(##class(EMRservice.InterfaceService.EMRRecordInfo).GetDocumentContent(AInstanceID))
	}
	
	s outString=streamContent.Read()
	s request=##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(outString)
	q request
}

}
