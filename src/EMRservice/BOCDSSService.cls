/// desc 第三方智能诊断工具（CDSS）入口
/// creator duan
/// createDate 2020-06-03
Class EMRservice.BOCDSSService Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
    s paramter  = $Get(%request.Data("param",1),"")
    s action  = $Get(%request.Data("action",1),"")
    if (action="GetOptions"){
        s result=..GetOptions(paramter)
        while (result.AtEnd = 0)
        {
            w $ZSTRIP(result.Read(32000),"*C",,$c(1)_$c(2))
        }
    }elseif(action="GetCDSSData"){
        s result= ..GetCDSSData(paramter)   
        while (result.AtEnd = 0)
        {
            w $ZSTRIP(result.Read(32000),"*C",,$c(1)_$c(2))
        }
    }elseif(action="GetEnvironment"){
        s result= ##class(EMRservice.BL.BLCDSSService).GetEnvironment()
        w $ZSTRIP(result,"*C",,$c(1)_$c(2))
    }
    Quit $$$OK
}

/// debug s obj = ##class(EMRservice.BOCDSSService).GetOptions("AEpisodeID:50892282,AUserLocID:1358,AHospitalID:2,AUserID:5599,APatientID:8910854")
/// desc CDSS初始化   判断是否开启CDSS，使用哪个产品的CDSS，以及该产品需要的初始化条件
ClassMethod GetOptions(AParamter As %String)
{
    s $ZT="ERROR"
    s resultStream = ##class(%GlobalBinaryStream).%New()
    s stream = ##class(%GlobalBinaryStream).%New()
    s message =""
    s cdssType = ""
    s paramArray = ..FormatParamter(AParamter)
    
    //开关控制
    s cdssLock = ##class(EMRservice.BL.BLCDSSTool).GetCDSSLock()
    s userLocID = paramArray.GetAt("AUserLocID")
    s userID = paramArray.GetAt("AUserID")
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
		    	s isONStatus = ##class(web.DHCBL.BDP.BDPCDSSDeptUserAut).GetCDSSUserAutFlag(userLocID,userID)
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
    if (cdssType=""){
	    s message = "没有维护可使用的第三方CDSS"
        d resultStream.Write("{""success"":""0"",""message"":"""_message_"""}")
        q resultStream
    }
    if (cdssType["CDSSHM"){
        s stream=##class(EMRservice.BL.BLCDSSHMService).GetInitData(paramArray)
        d:(resultStream.IsNull()=1) resultStream.Write("[")
        if (stream.IsNull()=1){
	      d resultStream.Write("{""success"":""0"",""message"":""惠每CDSS初始化出错""}")
        }
        d resultStream.CopyFrom(stream)
    } 
    if (cdssType["CDSSBD"){
        s stream=##class(EMRservice.BL.BLCDSSBDService).GetInitData(paramArray)
        if (resultStream.IsNull()=1){
	    	d resultStream.Write("[")
	    }else{
		    d resultStream.Write(",")
		}
		d:(stream.IsNull()=1) resultStream.Write("{""success"":""0"",""message"":""百度CDSS初始化出错""}")
        d resultStream.CopyFrom(stream)
    } 
    if (cdssType["CDSSDH"){
        s stream=##class(EMRservice.BL.BLCDSSDHService).GetInitData(paramArray)
        if (resultStream.IsNull()=1){
	    	d resultStream.Write("[")
	    }else{
		    d resultStream.Write(",")
		}
        d:(stream.IsNull()=1) resultStream.Write("{""success"":""0"",""message"":""东华CDSS初始化出错""}")
        d resultStream.CopyFrom(stream)
    }
    if (cdssType["CDSSRJ"){
        s stream=##class(EMRservice.BL.BLCDSSRJService).GetInitData(paramArray)
        if (resultStream.IsNull()=1){
	    	d resultStream.Write("[")
	    }else{
		    d resultStream.Write(",")
		}
        d:(stream.IsNull()=1) resultStream.Write("{""success"":""0"",""message"":""睿杰CDSS初始化出错""}")
        d resultStream.CopyFrom(stream)
    } 
    if (cdssType["CDSSWF"){
    	s stream=##class(EMRservice.BL.BLCDSSWFService).GetInitData(paramArray)
        if (resultStream.IsNull()=1){
	    	d resultStream.Write("[")
	    }else{
		    d resultStream.Write(",")
		}
        d:(stream.IsNull()=1) resultStream.Write("{""success"":""0"",""message"":""万方CDSS初始化出错""}")
        d resultStream.CopyFrom(stream)
    } 
    if (resultStream.IsNull()=1){
        d resultStream.Write("[{""success"":""0"",""message"":""CDSS工具"_cdssType_"不存在,请检查""}]")   
    }else{
		d resultStream.Write("]")  
	}
    q resultStream
ERROR
    d resultStream.Clear() 
    d resultStream.Write("[{""success"":""0"",""message"":"""_$zerror_"""}]")
    q resultStream
}

/// desc 取CDSS需要的结构化数据
/// debug s obj = ##class(EMRservice.BOCDSSService).GetCDSSData(""AEpisodeID:7911,AUserLocID:207,AUserID:17322,AInstanceID:3029||1,ADocID:622,AAction:SAVE,AType:I,ACdssTool:CDSSDH,AHospitalID:2"")
ClassMethod GetCDSSData(AParam As %String)
{
    s $ZT="ERROR"
    s result = ##class(%GlobalBinaryStream).%New()
    s paramArray = ..FormatParamter(AParam)
    s paramArray = ..GetInstanceInfo(paramArray)
    s cdssType = paramArray.GetAt("ACdssTool")
    if (cdssType="CDSSHM"){
        s result = ##class(EMRservice.BL.BLCDSSHMService).GetHMJsonData(paramArray)
    }elseif (cdssType="CDSSBD"){
        s result = ##class(EMRservice.BL.BLCDSSBDService).GetBDJsonData(paramArray)
    }elseif (cdssType="CDSSDH"){
        s result = ##class(EMRservice.BL.BLCDSSDHService).GetDHJsonData(paramArray)
    }elseif (cdssType="CDSSRJ"){
        s result=  ##class(EMRservice.BL.BLCDSSRJService).GetCDSSRJXmlData(paramArray)
    }else{
        d result.Write("{""success"":""0"",""message"":""CDSS工具"_cdssType_"不存在,请检查""}")
    }
    q result
ERROR
    d result.Clear() 
    d result.Write("{""success"":""0"",""message"":"""_$zerror_"""}")
    q result
}

/// desc 将参数字符串转换成参数数组 
/// creator duan
/// input  "AEpisodeID:50892282,AUserLocID:1358,AHospitalID:2,AUserID:5599,APatientID:8910854"
ClassMethod FormatParamter(AParamter As %String) As %ArrayOfDataTypes
{
	s result = ##class(%ArrayOfDataTypes).%New()
	q:AParamter="" result
	for i=1:1:$L(AParamter,",")
    {
        s key = $P($P(AParamter,",",i),":",1)
        s value = $P($P(AParamter,",",i),":",2)
        continue:key=""
        d result.SetAt(value,key)
    }
    //取医院ID
    d:""=result.GetAt("AHospitalID") result.SetAt(%session.Get("LOGON.HOSPID"),"AHospitalID")
    q result
}

/// desc 补充入参参数
ClassMethod GetInstanceInfo(AParamter As %ArrayOfDataTypes) As %ArrayOfDataTypes
{
	q:(AParamter.GetAt("AInstanceID")="") AParamter
	if (AParamter.GetAt("ADocID")=""){
		s InstanceData = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
		q:(InstanceData = "") ret
		s ECrecordID = $p(AInstanceID,"||",1)
		q:(ECrecordID = "") ret
		s ECRecordData = ##Class(EMRinstance.ECRecord).%OpenId(ECrecordID)
		q:(ECRecordData = "") ret
		s categoryId = ECRecordData.RealChartItemID
		d AParamter.SetAt(categoryId,"ADocID")
	}
	q AParamter
}

ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
	i ##Class(websys.SessionEvents).SessionExpired() q 1
	q 1
}

}
