/// web.CDSS.MachineLearning.BloodTranService
Class web.CDSS.MachineLearning.BloodTranService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "BloodTranService";

Parameter LOCATION = "http://127.0.0.1/imedical/web/";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// TODO:添加自变量和实施.
/// Test
Method Test() As %String [ WebMethod ]
{
	Quit "Test"
}

/// Creator:xuwenhu
/// CreatDate:2021-06-30
/// Description:第三方调用数据接口(后台调用)，获取输血信息
/// Table:
/// Input: action: 服务编号 message：请求流传给改参数
/// Return:
/// Others:w ##class(web.CDSS.MachineLearning.BloodTranService).BloodTranServer(action,message)
Method BloodTranServer(action As %String, message As %Stream.GlobalCharacter) As %String [ WebMethod ]
{
	s str=""
    while 'message.AtEnd
    {
        s str=str_message.ReadLine()
    }
 	s SaveDict={}
 	s XMLObj=##class(web.CDSS.Public.XML).FromXML(str)
 	q:XMLObj=""
 	if ((action="BLOOD_TRANS_INFORMATION")||(action="BLOOD_MATCHING_INFORMATION"))   //输血信息&配血信息
 	{
	 	s body=XMLObj.Get("BloodTransInfo")  //body下可能有多条数据
		/******************遍历body下的多条数据********************/
 		while body.Next(.nodeName, .nodeVal) 
 		{
	 		d:nodeName="IDNO" SaveDict.%Set("IDNO",nodeVal)  							//患者主索引，患者在医疗机构的唯一标识
	 		d:nodeName="PatientDR" SaveDict.%Set("PatientDR",nodeVal)  					//病人标识（就诊医院id
	 		d:nodeName="VisitID" SaveDict.%Set("VisitID",nodeVal)  						//就诊次数编号（第几次）
	 		d:nodeName="VisitType" SaveDict.%Set("VisitType",nodeVal)  					//就诊类型
	 		if (nodeName="BloodProductInfo")
	 		{
		 		d SaveDict.%Set("BloodTransVolume",nodeVal.Get("BloodTransVolume"))  		//输血量
		 		d SaveDict.%Set("BloodTransVolumeU",nodeVal.Get("BloodTransVolumeU"))  		//输血量单位
		 		d SaveDict.%Set("BloodTransSite",nodeVal.Get("BloodTransSite"))  			//输血部位
		 		d SaveDict.%Set("BloodTransType",nodeVal.Get("BloodTransType"))  			//输血血型（ABO血型系统）
		 		d SaveDict.%Set("BloodTransTypeRh",nodeVal.Get("BloodTransTypeRh"))  		//输血血型（Rh血型系统）
		 		d SaveDict.%Set("BloodTransClass",nodeVal.Get("BloodTransClass"))  			//输血品名称
		 		d SaveDict.%Set("BTIndication",nodeVal.Get("BTIndication"))  				//输血指征
		 		d SaveDict.%Set("BTIndicationValue",nodeVal.Get("BTIndicationValue"))  			//指征值
		 		d SaveDict.%Set("BTIndicationValueUnit",nodeVal.Get("BTIndicationValueUnit"))  	//指征值单位
		 		d SaveDict.%Set("PassFlag",nodeVal.Get("PassFlag"))  						//同步标记（0为同步，1为新增）
		 	}
		 	if (nodeName="BloodProductInfos")				//20210709 多个输血品兼容
		 	{
			 	s BloodProductBody=nodeVal
				while BloodProductBody.Next(.nodeName1, .nodeVal1) 
 				{
	 				d SaveDict.%Set("BloodTransVolume",nodeVal1.Get("BloodTransVolume"))  		//输血量
			 		d SaveDict.%Set("BloodTransVolumeU",nodeVal1.Get("BloodTransVolumeU"))  		//输血量单位
			 		d SaveDict.%Set("BloodTransSite",nodeVal1.Get("BloodTransSite"))  			//输血部位
			 		d SaveDict.%Set("BloodTransType",nodeVal1.Get("BloodTransType"))  			//输血血型（ABO血型系统）
			 		d SaveDict.%Set("BloodTransTypeRh",nodeVal1.Get("BloodTransTypeRh"))  		//输血血型（Rh血型系统）
			 		d SaveDict.%Set("BloodTransClass",nodeVal1.Get("BloodTransClass"))  			//输血品名称
			 		d SaveDict.%Set("BTIndication",nodeVal1.Get("BTIndication"))  				//输血指征
			 		d SaveDict.%Set("BTIndicationValue",nodeVal1.Get("BTIndicationValue"))  			//指征值
			 		d SaveDict.%Set("BTIndicationValueUnit",nodeVal1.Get("BTIndicationValueUnit"))  	//指征值单位
			 		d SaveDict.%Set("PassFlag",nodeVal1.Get("PassFlag"))  						//同步标记（0为同步，1为新增）
 				}	
			}
 		}
 		s SaveDict=SaveDict.%ToJSON()
 		try
    	{
        	d ..SaveBloodTransInfo(SaveDict)
    	}
    	catch e
    	{
	    	if ($d(^TMPCDSSCDLERROR(1))=0)
	    	{
		    	s number=1
	    	}
	    	else
	    	{
        		s number=$o(^TMPCDSSCDLERROR(""),-1)+1
	    	}
        	s ^TMPCDSSCDLERROR(number)=SaveDict_"&&"_e.Name
    	}	 	
	}
	q "success"
}

/// Creator:xuwenhu
/// CreatDate:2021-06-30
/// Description:输血信息入库
/// Table:
/// Input: json
/// Return:
/// Others:w ##class(web.CDSS.MachineLearning.BloodTranService).SaveBloodTransInfo(action,message)
ClassMethod SaveBloodTransInfo(json) As %String
{
	s json=[].%FromJSON(json)
    //获得推送内容
    s IDNO=json.%Get("IDNO")
    s PatientDR=json.%Get("PatientDR")
    //s VisitID=json.%Get("VisitID")
    s VisitID=$o(^WDT.CDSS.SignInfo("PatVisDRIndex",PatientDR,""),-1)+1   //获取最后一次就诊次+1
    s VisitType=json.%Get("VisitType")
    s BloodTransVolume=json.%Get("BloodTransVolume")
    s BloodTransVolumeU=json.%Get("BloodTransVolumeU")
    s BloodTransSite=json.%Get("BloodTransSite")
    s BloodTransType=json.%Get("BloodTransType")
    s BloodTransTypeRh=json.%Get("BloodTransTypeRh")
    s BloodTransClass=json.%Get("BloodTransClass")
    s BTIndication=json.%Get("BTIndication")
    s BTIndicationValue=json.%Get("BTIndicationValue")
    s BTIndicationValueUnit=json.%Get("BTIndicationValueUnit")
    s PassFlag=json.%Get("PassFlag")
    
    s obj = ##class(WDT.CDSS.BloodTransInfo).%New()
    s obj.IDNO= IDNO
    s obj.PatientDR =PatientDR
    s obj.VisitID =VisitID
    s obj.VisitType =VisitType
    s obj.BloodTransVolume =BloodTransVolume 
    s obj.BloodTransVolumeU=BloodTransVolumeU
    s obj.BloodTransSite=BloodTransSite
    s obj.BloodTransType=BloodTransType
    s obj.BloodTransTypeRh=BloodTransTypeRh
    s obj.BloodTransClass=BloodTransClass
    s obj.BTIndication=BTIndication
    s obj.BTIndicationValue=BTIndicationValue
    s obj.BTIndicationValueUnit=BTIndicationValueUnit
    s obj.PassFlag=PassFlag
    s sc=obj.%Save()
    q ""
}

}
