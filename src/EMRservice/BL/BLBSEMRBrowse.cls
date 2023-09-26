/// Desc:       用html看病历浏览页面
/// Creator:    Candyxu
/// CreateDate: 2020-6-12
Class EMRservice.BL.BLBSEMRBrowse Extends (%RegisteredObject, %XML.Adaptor)
{

// 取多个系统参数

// output:返回一个对象，前台拿到的是对象

// w ##Class(EMRservice.BL.BLBSEMRBrowse).GetOptionValueByNameMulti("isDefaultviewRevision|ENABLE_DOCTOR_REVISION_MODE|ENABLE_REVISION_LINE_BY_LEVEL")

ClassMethod GetOptionValueByNameMulti(AName As %String, AFlag As %String = "") As %String
{
	s result = ##class(%GlobalCharacterStream).%New()
	d result.Write("{")
	s len = $L(AName,"|")
	for i=1:1:len
	{
		s name = $P(AName,"|",i)
		q:name=""
		s id=$o(^DHCEMRM.SysOptionI("NameIndex"," "_$zcvt(name,"U"),""))
		q:(""=id)
		s obj=##Class(EMRmeta.SysOption).%OpenId(id) 
		d:(result.Size > 1) result.Write(",")
		d result.Write("""" _name_""":"""_obj.OptionValue_"""")
	}
	d result.Write("}")	
	q result
}

/// Desc:       取病历xml,病程取所有
/// Creator:    Candy
/// CreateDate: 2020-6-12
/// Input:      AInstanceId 病历ID
/// Debug:      w ##Class(EMRservice.BL.BLBSEMRBrowse).GetData("98||28","test")
ClassMethod GetData(AInstanceId As %String, AType As %String, ATimeStamp As %String, ASignature As %String) As %GlobalBinaryStream
{
	s argOutData = ##class(%GlobalBinaryStream).%New()
	s outMessage = ##class(%GlobalBinaryStream).%New()
	s AESKey="GlobalEMR"
	Set Salt = ATimeStamp_AESKey 
	//校验超时
	Set Param = "instanceId="_AInstanceId_"&actType="_AType_"&timeStamp="_ATimeStamp
	Set TimeOut = ##class(web.Util.Encryption).HMACSHA256ValidSign(ASignature,Param,AESKey,Salt)
	if TimeOut<0 Quit argOutData
	if TimeOut>300 {
		// 超过5分钟
		q argOutData
	}
	
	s eCRecordId = $p(AInstanceId,"||",1)
	q:(eCRecordId = "")||(AType = "") argOutData
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceId)
	q:(objInstance = "") argOutData
	 
	///输出结果
    if (objInstance.TheECRecord.DocumentType="DOC")
    {
	    d argOutData.Write("WORD")
	}
	else
	{
		d argOutData.Write("GRID")
	}
	s zipList = ""
	s instanceIDs = ##Class(%ListOfDataTypes).%New()
    if (objInstance.TheECRecord.DocumentCharacteristic = "0")
    {  	
    	d instanceIDs.InsertAt(AInstanceId,"1")
	  	d ##Class(EMRservice.BL.BLInstanceData).LoadDocument(argOutData,instanceIDs,outMessage)
		s zipFlag = ..GetEMRZipFlag(AInstanceId)
		//添加是否压缩标识
		s zipList = "["""_zipFlag_"""]"
    }
    else
    {
	 	s date = "", emrNum = 1,zipList = "[" 
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
					s zipFlag = ..GetEMRZipFlag(instanceId)
					//添加是否压缩标识
					if (emrNum=1){
						s zipList = zipList_""""_zipFlag_""""
					}else{
						s zipList = zipList_","""_zipFlag_""""
						}
					s emrNum = emrNum+1
				}
			}
		}
		d ##Class(EMRservice.BL.BLInstanceData).LoadDocument(argOutData,instanceIDs,outMessage)
    	s zipList = zipList_"]"
    }
    
    ///存储访问日志
    s logStatus = ..SetLogs(AInstanceId,AType)
	q:(logStatus '= 1) ""  
	s ret = ##class(%GlobalBinaryStream).%New()
	d ret.Write(zipList)
	//复制病历流
    d argOutData.Rewind()
	while (argOutData.AtEnd = 0)
	{
		s tmpOut = argOutData.Read(32000)
		d ret.Write($zcvt(tmpOut,"I","UTF8"))
	}	  
    q ret
}

/// Desc:       获取病历是否压缩存储的标识
/// Creator:    Candy
/// CreateDate: 2020-6-12
/// Input:      AInstanceId 病历ID
/// Input:      FALSE 或 TRUE
/// Debug:      w ##Class(EMRservice.BL.BLBSEMRBrowse).GetEMRZipFlag("270||8")
ClassMethod GetEMRZipFlag(AInstanceId As %String)
{
	s flag = "FALSE"
	if (##class(%Dictionary.CompiledMethod).%ExistsId("EMRservice.BL.BLInstanceDataCompressInfo||GetIsCompressByInstanceID")'=0){
		s flag = ##class(EMRservice.BL.BLInstanceDataCompressInfo).GetIsCompressByInstanceID(AInstanceId)
		}else{
		s flag = "FALSE"
		}
	if (flag=""){
		s flag = "FALSE"
		}
	q $zcvt(flag,"U")
}

/// Desc:       取病历xml,病程取所有
/// Creator:    Candy
/// CreateDate: 2020-6-12
/// Input:      AInstanceId 病历ID
/// Debug:      w ##Class(EMRservice.BL.BLBSEMRBrowse).GetData("16||1","test")
ClassMethod GetSingleData(AInstanceId As %String, AType As %String, ATimeStamp As %String, ASignature As %String) As %GlobalBinaryStream
{
	s argOutData = ##class(%GlobalBinaryStream).%New()
	s outMessage = ##class(%GlobalBinaryStream).%New()
	
	s AESKey="GlobalEMR"
	Set Salt = ATimeStamp_AESKey 
	//校验超时
	Set Param = "instanceId="_AInstanceId_"&actType="_AType_"&timeStamp="_ATimeStamp
	Set TimeOut = ##class(web.Util.Encryption).HMACSHA256ValidSign(ASignature,Param,AESKey,Salt)
	if TimeOut<0 Quit argOutData
	if TimeOut>300 {
		// 超过5分钟
		q argOutData
	}
	
	
	
	s eCRecordId = $p(AInstanceId,"||",1)
	q:(eCRecordId = "")||(AType = "") argOutData
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceId)
	q:(objInstance = "") argOutData
	///输出结果
    if (objInstance.TheECRecord.DocumentType="DOC")
    {
	    d argOutData.Write("WORD")
	}
	else
	{
		d argOutData.Write("GRID")
	}
	s zipList = ""
	s instanceIDs = ##Class(%ListOfDataTypes).%New()
    d instanceIDs.InsertAt(AInstanceId,"1")
	d ##Class(EMRservice.BL.BLInstanceData).LoadDocument(argOutData,instanceIDs,outMessage)
	s zipFlag = ..GetEMRZipFlag(AInstanceId)
	//添加是否压缩标识
	s zipList = "["""_zipFlag_"""]"    
 
    ///存储访问日志
    s logStatus = ..SetLogs(AInstanceId,AType)
	q:(logStatus '= 1) ""

	s ret = ##class(%GlobalBinaryStream).%New()
	d ret.Write(zipList)
	//复制病历流
    d argOutData.Rewind()
	while (argOutData.AtEnd = 0)
	{
		s tmpOut = argOutData.Read(32000)
		d ret.Write($zcvt(tmpOut,"I","UTF8"))
	}	  
    q ret
}

/// Desc:       记录浏览日志
/// Creator:    Candy
/// CreateDate: 2020-11-25
/// Input:      AInstanceId 病历ID
ClassMethod SetLogs(AInstanceId As %String, AType As %String)
{
	s result = 0
	q:(AInstanceId = "")||(AType = "") result
	s obj = ##class(EMRinstance.BSEMRBrowseLogs).%New()
	s obj.ActDate = $p($h,",",1)
	s obj.ActTime = $p($h,",",2)
	s obj.ActType = AType
	s obj.InstanceId = AInstanceId
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = 1 
	q result
}

/// Desc:       查询病历是否被患者浏览过
/// Creator:    Candy
/// CreateDate: 2020-11-25
/// Input:      AInstanceId 病历ID
/// Output:     0 没有  1浏览过
ClassMethod GetPATViewStatus(AInstanceId) As %String
{
	s result = 0
	q:(AInstanceId = "") result = 0
	s type = $o(^DHCEMRI.BSEMRBrowseLogsI("IdxInstanceIdType"," "_AInstanceId,""))
	s type = $tr(type," ","")
	s:(type = "WEBPAT") result = 1
	q result
}

/// Desc:       取病历目录;展现结构
/// Creator:    Candy
/// CreateDate: 2018-6-4
/// Input:      argEpisodeID 就诊号
///             argInternalCategoryID  病历术语目前ID 例如：住院病案首页 HDSD00.11 多个以"^"分隔
/// Output:     <Categorys><Category><Name>病案首页</Name><InstanceID>168||1</InstanceID><InternalID>HDSD00.11</InternalID></Category>……<Categorys>
/// Debug:      w ##Class(EMRservice.BL.BLBSEMRBrowse).GetRecordCategory(4)
ClassMethod GetRecordCategory(argEpisodeID As %String, showType = "") As %GlobalBinaryStream
{
	s resXml = ##Class(%GlobalBinaryStream).%New()
	q:(argEpisodeID = "") result
	s ecrecords = ""

	d resXml.Write("<Categorys>")
	s docId = ""
	
	if (showType="write"){
		s docId = ""
		for
		{
			s docId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_argEpisodeID,docId))
			q:(docId = "")
			s ecrecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_argEpisodeID,docId,""))		
			continue:(ecrecordId = "")
			d Output
		}
	}else{
		s res = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetAllCategory")
		d res.Execute(argEpisodeID)
		
		while res.%Next()
		{
			s ItemType = res.Data("ItemType")
			if (ItemType = "EMR")
			{ 
				s categoryID = res.Data("ItemCategoryID")	
				s docIds = ##Class(EMRservice.BL.BLClientCategory).GetDocIdsByParent(categoryID)
				s length = $l(docIds,",")
				for I=1:1:length
				{
					s docId = $p(docIds,",",I)
					s ecrecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_argEpisodeID," "_docId,""))		
					continue:(ecrecordId = "")
					d Output
				}
			}
		 }
	}
	d resXml.Write("</Categorys>")
	d resXml.OutputToDevice()
	q resXml
Output
		s subId = ""
		for
		{
			s subId = $o(^DHCEMRI.InstanceDataI("IdxECRecord",ecrecordId,subId))
			q:(subId = "")
			s instanceId = ecrecordId_"||"_subId
			s obj = ##class(EMRinstance.InstanceData).%OpenId(instanceId)
			continue:(obj = "")
			continue:(obj.Status '= "Save")
			continue:((obj.TheECRecord.DocumentCharacteristic = "1")&&($f(ecrecords,ecrecordId)>0))
			s chartItemId = obj.TheECRecord.ChartItemID
			s objEmrTemplateCategory = ##class(EMRmeta.EMRTemplateCategory).%OpenId(chartItemId)
           	continue:(objEmrTemplateCategory = "")
			d resXml.Write("<Category>")
			d resXml.Write("<Name>"_objEmrTemplateCategory.CategoryName_"</Name>")
			d resXml.Write("<InstanceID>"_instanceId_"</InstanceID>")
			d resXml.Write("</Category>")
			s ecrecords = ecrecords_$lb(ecrecordId)
		}			
	q
}

}
