/// Desc:获得Html病历文档
/// Creator:Candy
/// CreateDate:2022-10-26
Class EMRservice.BL.BLHtmlDoc Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       取病历目录;展现结构
/// Creator:    Candy
/// CreateDate: 2018-6-4
/// Input:      AEpisodeID 就诊号  
///             AType 访问应用类型 (WEBDOC 移动查房 / WEBPAT 互联网患者查看病历)           
/// Output:     <Categorys><Category><Name>住院病案首页</Name><InstanceID></InstanceID></Category>……</Categorys>
/// Debug:      w ##Class(EMRservice.BL.BLHtmlDoc).GetEncRecordCategory(4,"WEBDOC")
ClassMethod GetEncRecordCategoryRunning(AEpisodeID As %String, AType As %String) As %GlobalBinaryStream
{
	s resXml = ##Class(%GlobalBinaryStream).%New()
	q:(AEpisodeID = "") resXml
	q:(..IsAdmShow(AEpisodeID,AType)'=1) resXml
	
	d resXml.Write("<Categorys>")
	s res = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetAllCategory")
	d res.Execute(AEpisodeID)
	
	s space = ""
	s emrVersion = ##Class(EMRmeta.VersionLib).GetVersion()
	s emrVersion = $E(emrVersion,6,6)
	//获取当前要连续显示的目录
	s docIDArry = ##Class(%ArrayOfDataTypes).%New()
	
	s docStr = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("docShowAll")
	if (docStr'=""){
		s len = $l(docStr,",")
		for k=1:1:len{
			s item = $p(docStr,",",k)
			d docIDArry.SetAt(1,item)
		}
	}
	
	s:(emrVersion < 8) space = " "
	while res.%Next()
	{
		s ItemType = res.Data("ItemType")
		continue:(res.Data("ItemType") '= "EMR")
		s categoryID = res.Data("ItemCategoryID")	
		s docIds = ##Class(EMRservice.BL.BLClientCategory).GetDocIdsByParent(categoryID)
		s length = $l(docIds,",")
		s tmp = ""
		for I=1:1:length
		{
			s docId = $p(docIds,",",I)
			
			s ecrecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",space_AEpisodeID,space_docId,""))		
			continue:(ecrecordId = "")
			d Output
		}
		if (tmp '= "")
		{
			s objEmrCategory = ##class(EMRmeta.EMRTemplateCategory).%OpenId(categoryID)
			continue:(objEmrCategory = "")
			d resXml.Write("<Category>")
			d resXml.Write("<CategoryName>"_objEmrCategory.CategoryName_"</CategoryName>")
			d resXml.Write("<DataList>")
			d resXml.Write(tmp)
			d resXml.Write("</DataList>")
			d resXml.Write("</Category>")
		}
	 }
	d resXml.Write("</Categorys>")
	q resXml
	
Output
	s subId = ""
	for
	{
		s subId = $o(^DHCEMRI.InstanceDataI("IdxECRecord",ecrecordId,subId))
		q:(subId = "")
		s instanceId = ecrecordId_"||"_subId
		continue:(..IsInstanceShow(instanceId,AType) '= 1)
		s obj = ##class(EMRinstance.InstanceData).%OpenId(instanceId)
		continue:(obj = "")
		continue:(obj.Status '= "Save")   
		s titleName =  obj.Title 
		if (docIDArry.GetAt(docId)=1){
			s categoryObj = ##class(EMRmeta.EMRTemplateCategory).%OpenId(categoryID)
			 s titleName=categoryObj.CategoryName	
		}
       	s encData = ..GetEnInstanceId(instanceId,AType)
       	s tmp = tmp_"<Instance>"
       	s tmp = tmp_"<Name>"_titleName_"</Name>"
       	s tmp = tmp_"<Date>"_$zd(obj.HappenDate,3)_" "_$zt(obj.HappenTime)_"</Date>"
       	s tmp = tmp_"<InstanceID>"_encData_"</InstanceID>"
       	s tmp= tmp_"</Instance>"
       	q:(docIDArry.GetAt(docId)=1) //只读一个
	}			
	q
}

/// Desc:       取病历目录;展现结构
/// Creator:    Candy
/// CreateDate: 2018-6-4
/// Input:      AEpisodeID 就诊号  
///             AType 访问应用类型 (WEBDOC 移动查房 / WEBPAT 互联网患者查看病历)           
/// Output:     <Categorys><Category><Name>住院病案首页</Name><InstanceID></InstanceID></Category>……</Categorys>
/// Debug:      w ##Class(EMRservice.BL.BLHtmlDoc).GetEncRecordCategory(4,"WEBDOC")
ClassMethod GetEncRecordCategory(AEpisodeID As %String, AType As %String) As %GlobalBinaryStream
{
	s resXml = ##Class(%GlobalBinaryStream).%New()
	q:(AEpisodeID = "") resXml
	q:(..IsAdmShow(AEpisodeID,AType)'=1) resXml
	
	d resXml.Write("<Categorys>")
	s res = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetAllCategory")
	d res.Execute(AEpisodeID)
	
	s space = ""
	s emrVersion = ##Class(EMRmeta.VersionLib).GetVersion()
	s emrVersion = $E(emrVersion,6,6)
	s:(emrVersion < 8) space = " "
	while res.%Next()
	{
		s ItemType = res.Data("ItemType")
		continue:(res.Data("ItemType") '= "EMR")
		s categoryID = res.Data("ItemCategoryID")	
		s docIds = ##Class(EMRservice.BL.BLClientCategory).GetDocIdsByParent(categoryID)
		s length = $l(docIds,",")
		s tmp = ""
		for I=1:1:length
		{
			s docId = $p(docIds,",",I)
			
			s ecrecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",space_AEpisodeID,space_docId,""))		
			continue:(ecrecordId = "")
			d Output
		}
		if (tmp '= "")
		{
			s objEmrCategory = ##class(EMRmeta.EMRTemplateCategory).%OpenId(categoryID)
			continue:(objEmrCategory = "")
			d resXml.Write("<Category>")
			d resXml.Write("<CategoryName>"_objEmrCategory.CategoryName_"</CategoryName>")
			d resXml.Write("<DataList>")
			d resXml.Write(tmp)
			d resXml.Write("</DataList>")
			d resXml.Write("</Category>")
		}
	 }
	d resXml.Write("</Categorys>")
	q resXml
	
Output
	s subId = ""
	for
	{
		s subId = $o(^DHCEMRI.InstanceDataI("IdxECRecord",ecrecordId,subId))
		q:(subId = "")
		s instanceId = ecrecordId_"||"_subId
		continue:(..IsInstanceShow(instanceId,AType) '= 1)
		s obj = ##class(EMRinstance.InstanceData).%OpenId(instanceId)
		continue:(obj = "")
		continue:(obj.Status '= "Save")       	
       	s encData = ..GetEnInstanceId(instanceId,AType)
       	s tmp = tmp_"<Instance>"
       	s tmp = tmp_"<Name>"_obj.Title_"</Name>"
       	s tmp = tmp_"<Date>"_$zd(obj.HappenDate,3)_" "_$zt(obj.HappenTime)_"</Date>"
       	s tmp = tmp_"<InstanceID>"_encData_"</InstanceID>"
       	s tmp= tmp_"</Instance>"
	}			
	q
}

/// Desc:       返回病历ID
/// Creator:    Candy
/// CreateDate: 2022-10-26
/// Input:      AID 病历目录ID
///             AType 访问类型
/// Output:     result 加密后ID
ClassMethod GetEnInstanceId(AID As %String, AType As %String) As %String
{
	s result = ""
	s id = AID
   	s encKey = "GlobaEMRBSBrowse"
   	s ts = $$GetTS()
   	s ran = $$GetRandom()
   	s encData = ran_"-"_$p(id,"||",1)_"-"_ts_"-"_$p(id,"||",2)_"-"_AType
   	s encData = ##class(%SYSTEM.Encryption).AESCBCEncrypt(encData,encKey,"")
   	s encData = ##Class(web.Util.Encryption).Byte2Hex(encData)
   	s result = encData
   	q result
   	
GetTS(a)
	s dt = $zdt($NOW(),3,1,3)
	s dt = $extract(dt,3,*)
	s dt = $replace(dt,"-","")
	s dt = $replace(dt,":","")
	s dt = $replace(dt,".","")
	s dt = $replace(dt," ","")
	q dt
	
GetRandom(a)
	q $r(999999999999999)
}

/// Desc:       返回病历ID
/// Creator:    Candy
/// CreateDate: 2022-10-26
/// Input:      AID 病历目录ID
/// Output:     result 病历ID-访问类型
ClassMethod GetUnEncInstanceId(AID As %String) As %String
{
	s result = ""
	q:(AID = "") result
	s encKey = "GlobaEMRBSBrowse"
	s UnenData = ##Class(web.Util.Encryption).Hex2Byte(AID)
	s UnenData = ##class(%SYSTEM.Encryption).AESCBCDecrypt(UnenData,encKey)
	q:($l(UnenData,"-") '= 5) result 
	s result = $p(UnenData,"-",2)_"||"_$p(UnenData,"-",4)_"-"_$p(UnenData,"-",5)
	q result
}

/// Desc:       查看病历文档控制
/// Creator:    Candy
/// CreateDate: 2022-10-26
/// Input:      AInstanceId 病历ID
///             AType 访问应用类型 (WEBDOC 移动查房 / WEBPAT 互联网患者查看病历)
/// Output:     result 0 不能访问 1 可以访问
ClassMethod IsInstanceShow(AInstanceId As %String, AType As %String) As %String
{
	s result = 0
	if (AType = "WEBPAT")
	{
		s signStatus = ##Class(EMRservice.BOPrivAssist).HasValidSign(AInstanceId)
		q:(signStatus '= 1) result
		s result = 1
	}
	elseif (AType = "WEBDOC")
	{
		s result = 1
	}
	q result
}

/// Desc:       查看病历就诊控制
/// Creator:    Candy
/// CreateDate: 2022-10-26
/// Input:      AEpisodeID 就诊ID
///             AType 访问类型 (WEBDOC 移动查房 / WEBPAT 互联网患者查看病历)
/// Output:     result 0 不能访问 1 可以访问
ClassMethod IsAdmShow(AEpisodeID As %String, AType As %String) As %String
{
	s result = 0
	if (AType = "WEBPAT")
	{
		s admStatus = $P($g(^PAADM(AEpisodeID)),"^",20)
		q:(admStatus = "C") result
		s admType = $P($g(^PAADM(AEpisodeID)),"^",2)
		q:(admType '= "O") result
		s admDate = $P($G(^PAADM(AEpisodeID)),"^",6)
		s today = $p($h,",",1)
		q:((today - admDate) > 30) result
		s result = 1
	}
	elseif (AType = "WEBDOC")
	{
		s result = 1
	}
	q result
}

/// Desc:       获取HTML文档服务
/// Creator:    Candy
/// CreateDate: 2022-10-26
/// Input:      ID 病历目录ID
///             AAppCode  访问者应用代码（需要在基础平台第三系统管理中注册）
/// Debug:      w ##Class(EMRservice.BL.BLHtmlDoc).GetHtmlDocument("1||1","WEBPAT")
ClassMethod GetHtmlDocumentRunning(AID As %String, AAppCode As %String) As %GlobalBinaryStream
{
	s res = ##class(%GlobalBinaryStream).%New()
	s argOutData = ##class(%GlobalBinaryStream).%New()
	s outMessage = ##class(%GlobalBinaryStream).%New()
	s unResult = ..GetUnEncInstanceId(AID)
	s InstanceId = $p(unResult,"-",1)
	s vistType = $p(unResult,"-",2)
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(InstanceId)
	q:(objInstance = "") res 
	
	s cpClassFlag = ##class(%Dictionary.CompiledClass).%ExistsId("EMRservice.BL.BLInstanceDataCompressInfo")
	s cpMethodFlag = ##class(%Dictionary.CompiledMethod).%ExistsId("EMRservice.BL.BLInstanceDataCompressInfo||GetIsCompressByInstanceID")
	if (cpClassFlag '= 0 && cpMethodFlag '= 0)
	{
		s zipflag = ##class(EMRservice.BL.BLInstanceDataCompressInfo).GetIsCompressByInstanceID(InstanceId)	
		q:(zipflag = "TRUE") res
	}    
	s instanceIds = ##Class(%ListOfDataTypes).%New()
	if (objInstance.TheECRecord.DocumentType = "DOC")
    {
		d ..GetDocInstanceID(InstanceId,instanceIds)
		d ##Class(EMRservice.BL.BLInstanceData).LoadDocument(argOutData,instanceIds,outMessage)
		s res = ##Class(EMRservice.ParseWordXML).handleWordXmlByDom(argOutData,instanceIds)	 	      
    }
    else
    {
		d instanceIds.InsertAt(InstanceId,"1")
		d ##Class(EMRservice.BL.BLInstanceData).LoadDocument(argOutData,instanceIds,outMessage)
		s res = ##Class(EMRservice.ParseGridXML).handleGridXmlByXPath(argOutData,InstanceId)  
	}
	d ..SetBrowseLogs(InstanceId,vistType,AAppCode)
	q res
}

/// Desc:       获取HTML文档服务
/// Creator:    Candy
/// CreateDate: 2022-10-26
/// Input:      ID 病历目录ID
///             AAppCode  访问者应用代码（需要在基础平台第三系统管理中注册）
/// Debug:      w ##Class(EMRservice.BL.BLHtmlDoc).GetHtmlDocument("1||1","WEBPAT")
ClassMethod GetHtmlDocument(AID As %String, AAppCode As %String) As %GlobalBinaryStream
{
	s res = ##class(%GlobalBinaryStream).%New()
	s argOutData = ##class(%GlobalBinaryStream).%New()
	s outMessage = ##class(%GlobalBinaryStream).%New()
	s unResult = ..GetUnEncInstanceId(AID)
	s InstanceId = $p(unResult,"-",1)
	s vistType = $p(unResult,"-",2)
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(InstanceId)
	q:(objInstance = "") res 
	
	s cpClassFlag = ##class(%Dictionary.CompiledClass).%ExistsId("EMRservice.BL.BLInstanceDataCompressInfo")
	s cpMethodFlag = ##class(%Dictionary.CompiledMethod).%ExistsId("EMRservice.BL.BLInstanceDataCompressInfo||GetIsCompressByInstanceID")
	if (cpClassFlag '= 0 && cpMethodFlag '= 0)
	{
		s zipflag = ##class(EMRservice.BL.BLInstanceDataCompressInfo).GetIsCompressByInstanceID(InstanceId)	
		q:(zipflag = "TRUE") res
	}    
	s instanceIds = ##Class(%ListOfDataTypes).%New()
	d instanceIds.InsertAt(InstanceId,"1")
	d ##Class(EMRservice.BL.BLInstanceData).LoadDocument(argOutData,instanceIds,outMessage)
	if (objInstance.TheECRecord.DocumentType = "DOC")
    {
		s res = ##Class(EMRservice.ParseWordXML).handleWordXmlByDom(argOutData,instanceIds)	      
    }
    else
    {
		s res = ##Class(EMRservice.ParseGridXML).handleGridXmlByXPath(argOutData,InstanceId)  
	}
	d ..SetBrowseLogs(InstanceId,vistType,AAppCode)
	q res
}

/// Creator:    yn
/// CreateDate: 2023-04-26
/// Input:      word类型的eCRecordId
/// Out      	病历instanceid的list
/// Desc       	获取word类型的instanceID 
/// Debug:      w ##Class(EMRservice.BL.BLHtmlDoc).GetDocInstanceID("270||1","")
ClassMethod GetDocInstanceID(AInstanceId, instanceIDs)
{
	s eCRecordId = $p(AInstanceId,"||",1)
	q:eCRecordId=""
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceId)
	try{
		s docId = objInstance.TheECRecord.ChartItemID.%Id()
		s DocumentCharacteristic = objInstance.TheECRecord.DocumentCharacteristic
	}catch{
		s ecRecordId = objInstance.TheECRecord
		s ecobj = ##Class(EMRinstance.ECRecord).%OpenId(ecRecordId)
		s docId = ecobj.ChartItemID
		s DocumentCharacteristic = ecobj.DocumentCharacteristic
		}
	//获取当前要连续显示的目录
	s docIDArry = ##Class(%ArrayOfDataTypes).%New()
	
	s docStr = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("docShowAll")
	if (docStr'=""){
		s len = $l(docStr,",")
		for k=1:1:len{
			s item = $p(docStr,",",k)
			d docIDArry.SetAt(1,item)
		}
	}
	if ((docIDArry.GetAt(docId)'=1)||(DocumentCharacteristic = "0")){
		d instanceIDs.InsertAt(AInstanceId,"1")
	}else{
 		s date = "", emrNum = 1
		for
		{
			s date = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",eCRecordId," SAVE",date))
			q:(date = "")
			s time = ""
			for
			{
				s time = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",eCRecordId," SAVE",date,time)) 
				q:(time = "")
				s subId = ""
				for
				{
					s subId = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",eCRecordId," SAVE",date,time,subId))
					q:(subId = "")	
					s instanceId = eCRecordId_"||"_subId
					d instanceIDs.InsertAt(instanceId,emrNum)
					s emrNum = emrNum+1
				}
			}
		}			
	}
	q
}

/// Desc:       记录浏览日志
/// Creator:    Candy
/// CreateDate: 2022-11-25
/// Input:      AInstanceId 病历ID
///             AType 访问类型 (WEBDOC 移动查房 / WEBPAT 互联网患者查看病历)
///             AAppCode  访问者应用代码（需要在基础平台第三系统管理中注册）
ClassMethod SetBrowseLogs(AInstanceId As %String, AType As %String, AAppCode As %String)
{
	s result = 0
	q:(AInstanceId = "")||(AType = "") result
	s obj = ##class(EMRinstance.BSEMRBrowseLogs).%New()
	s obj.ActDate = $p($h,",",1)
	s obj.ActTime = $p($h,",",2)
	s obj.ActType = AType
	s obj.UserCode = AAppCode
	s obj.InstanceId = AInstanceId
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = 1 
	q result
}

/// Desc:       取浏览日志是否患者查看过状态
/// Creator:    Candy
/// CreateDate: 2022-11-25
/// Input:      AInstanceId 病历ID
/// OutPut:     result 1 浏览过，0 未浏览
ClassMethod GetBrowseLogs(AInstanceId As %String) As %String
{
	s result = 0
	s:($d(^DHCEMRI.BSEMRBrowseLogsI("IdxInstanceIdType"," "_AInstanceId," WEBPAT"))>0) result = 1
	q result
}

}
