Class EMRservice.BLBSParseXML Extends %RegisteredObject
{

/// Desc:	将数据流转换为输出UTF8格式的流（入cache向外部输出时转码）
/// Input:	inputStream: 输入数据流
/// Output：UTF8格式的数据流
/// Debug:	w ##Class(EMRservice.BLBSParseXML).StreamOutConvertUTF8("")
ClassMethod StreamOutConvertUTF8(inputStream As %GlobalBinaryStream) As %GlobalBinaryStream
{
	s result = ##class(%GlobalBinaryStream).%New()
	
	while (inputStream.AtEnd = 0)
	{
		s tmpOut = inputStream.Read(32000)
		s tmpOut = $zcvt(tmpOut,"O","UTF8") 
		d result.Write(tmpOut)
	}
	
	q result
}

/// w ##Class(EMRservice.BLBSParseXML).GetDocument("22||1")
ClassMethod GetDocument(AInstanceID As %String) As %String
{
	s argOutData = ##class(%FileBinaryStream).%New() 
	s outMessage = ##class(%FileBinaryStream).%New()
	s instanceArry = ##class(%ListOfDataTypes).%New()
	d instanceArry.Insert(AInstanceID)
 	s status = ##Class(EMRservice.BL.BLInstanceData).LoadDocument(argOutData,instanceArry,outMessage)
 	
	s AStream=##Class(%FileBinaryStream).%New()
	s AStream.Filename="D:\SAVE_DOCUMENT_"_$tr(AInstanceID,"||","--")_".xml"
	d AStream.CopyFrom(argOutData)
	d AStream.SaveStream()
	d AStream.%Close()
	if (argOutData.Read()=""){
		q "该病历不存在！"
		}elseif (status=1){
		q "D:\SAVE_DOCUMENT_"_$tr(AInstanceID,"||","--")_".xml"
		}else{
		q -1	
		}
}

/// Desc:       将解析后的html流写到文件中
/// Creator:    yn
/// CreateDate: 2022-09-13
/// Input:      
/// Debug:      
ClassMethod WriteFile(argOutParams As %GlobalBinaryStream, fileName)
{
	s argOutParams = ..StreamOutConvertUTF8(argOutParams)
	s AStream=##Class(%FileBinaryStream).%New()
	s AStream.Filename="d:\emrparse\"_fileName_".html"
	d AStream.CopyFrom(argOutParams)
	d AStream.SaveStream()
	d AStream.%Close()
}

/// Desc:       读取本地xml文件流
/// Creator:    yn
/// CreateDate: 2022-10-11
/// Input:      
/// Debug:      w ##Class(EMRservice.BLBSParseXML).GetEMRHtmlData("error5","test")
ClassMethod ReadFile(fileName, type)
{
	s Stream =##class(%FileBinaryStream).%New()
	s Stream.Filename = "d:\emrparse\"_type_"\"_fileName_".xml"
	q Stream
}

/// Desc:       测试解析xml为html程序,从本地文件中获取
/// Creator:    yn
/// CreateDate: 2022-10-11
/// Input:      Type:DOC或grid,fileName:文件名，注意不能包含||
/// Debug:      w ##Class(EMRservice.BLBSParseXML).TestParseCode("GRID","fy","1||1")
ClassMethod TestParseCode(Type, fileName, InstanceId)
{
	s res = ##class(%GlobalBinaryStream).%New()
	s argOutData= ..ReadFile(fileName,Type)
	q:argOutData.FileBinarySize()=0 res
	if (Type="DOC")
    {
	    //word
		s res = ##Class(EMRservice.ParseWordXML).handleWordXmlByDom(argOutData,InstanceId)	      
    }else{
		//grid
		s res = ##Class(EMRservice.ParseGridXML).handleGridXmlByXPath(argOutData,InstanceId)  
	}
	q res
}

/// Desc:       将病历xml转换成html入口方法
/// Creator:    yn
/// CreateDate: 2022-09-13
/// Input:      AInstanceId 病历ID
/// Debug:      w ##Class(EMRservice.BLBSParseXML).GetEMRHtmlData("22||1","test").Read()
ClassMethod GetEMRHtmlData(AInstanceId As %String, AType As %String, htmlResArry = "") As %GlobalBinaryStream
{
	s res = ##class(%GlobalBinaryStream).%New()
	s argOutData = ##class(%GlobalBinaryStream).%New()
	s outMessage = ##class(%GlobalBinaryStream).%New()
	s eCRecordId = $p(AInstanceId,"||",1)
	if ((eCRecordId = "")||(AType = "")){
		d:htmlResArry'="" htmlResArry.SetAt("-1^请求参数为空","resDesc")
		q res
		}
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceId)
	if (objInstance = ""){
		d:htmlResArry'="" htmlResArry.SetAt("-1^无法获取病历xml数据","resDesc")
		q res
	}
	s zipFlag = ..GetPluginEMRZipFlag(AInstanceId)
	if (zipFlag="TRUE"){
		d:htmlResArry'="" htmlResArry.SetAt("-1^该病历为插件压缩存储，暂不支持解析","resDesc")
		q res		
	}
	
	if (objInstance.TheECRecord.DocumentType="DOC")
    {
	    //word
	    s instanceIDs = ##Class(%ListOfDataTypes).%New()
		d ..GetDocInstanceID(AInstanceId,instanceIDs)
		d ##Class(EMRservice.BL.BLInstanceData).LoadDocument(argOutData,instanceIDs,outMessage)
		s res = ##Class(EMRservice.ParseWordXML).handleWordXmlByDom(argOutData,instanceIDs,htmlResArry)	      		    	
    }else{
		s zipFlag = ..GetPluginEMRZipFlag(AInstanceId)
		if (zipFlag="TRUE"){
			d:htmlResArry'="" htmlResArry.SetAt("-1^该病历为插件压缩存储，暂不支持解析","resDesc")
			q res		
		}
		//grid
		s instanceIDs = ##Class(%ListOfDataTypes).%New()
		d instanceIDs.InsertAt(AInstanceId,"1")
		d ##Class(EMRservice.BL.BLInstanceData).LoadDocument(argOutData,instanceIDs,outMessage)
		s res = ##Class(EMRservice.ParseGridXML).handleGridXmlByXPath(argOutData,AInstanceId,htmlResArry)  
	}
	q res
}

/// Creator:    yn
/// CreateDate: 2023-04-26
/// Input:      word类型的eCRecordId
/// Out      	病历instanceid的list
/// Desc       	获取word类型的instanceID 
/// Debug:      w ##Class(EMRservice.BLBSParseXML).GetDocInstanceID("270||1")
ClassMethod GetDocInstanceID(AInstanceId, instanceIDs)
{
	s eCRecordId = $p(AInstanceId,"||",1)
	q:eCRecordId=""
	
	s docIDArry = ##Class(%ArrayOfDataTypes).%New()
	
	s docStr = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("docShowAll")
	if (docStr'=""){
		s len = $l(docStr,",")
		for k=1:1:len{
			s item = $p(docStr,",",k)
			d docIDArry.SetAt(1,item)
		}
	}
	if (docIDArry.GetAt(eCRecordId)'=1){
		//默认为非连续显示
		d instanceIDs.InsertAt(AInstanceId,"1")
		q
	}
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceId)
	if ((objInstance.TheECRecord.DocumentCharacteristic = "0")){
		d instanceIDs.InsertAt(AInstanceId,"1")
		q
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
		q			
	}
}

/// Creator:    yn
/// CreateDate: 2022-09-21
/// Input:      病历xml流数据，AInstanceId：实例ID
/// Out      	病历xml异常返回"" 正常返回html流
/// Desc       	对病历xml节点进行遍历，获取所需要的header以及section部分并处理获得最终的html流
/// Debug:      w ##Class(EMRservice.BLBSParseXML).handleWordXml()
ClassMethod GetNodeTargetSite(doc As %XML.Document, site As %String) As %XML.Node
{
	/*-start 将指针移动到site位置-*/
	s node = doc.GetDocumentElement() //指针在Document
	s status = node.MoveToFirstChild(1) 
	do{
		if (node.LocalName="StructuredBody"){
			s status = node.MoveToFirstChild(1)
			// StructuredBody子节点遍历
			do{
				if (node.LocalName="NInstanceData"||(node.LocalName="PresentationData")){
					s status = node.MoveToFirstChild(1)
					//NInstanceData子节点遍历
					do{
						if (node.LocalName=site){
							q
						}
					}while(node.MoveToNextSibling(1))
					q
				}
			}while(node.MoveToNextSibling(1))
			q
		}				
	}while(node.MoveToNextSibling(1))
	/*-end 将指针移动到site-*/
	q node
}

/// Creator:    yn
/// CreateDate: 2020-09-14
/// Input:      props
/// Out      	属性名值键值对
/// Debug:      w ##Class(EMRservice.BLBSParseXML).GetKeyValue("270||8")
ClassMethod GetKeyValue(props As %String, type = "") As %ArrayOfDataTypes
{
	s array = ##Class(%ArrayOfDataTypes).%New()
	q:props="" array
	s total = $l(props,";")
	for i=1:1:total{
		s item = $p(props,";",i)
		s key = $replace($p(item,":",1)," ","")
		s value = $e(item,$f(item,":"),*)
		if (key'=""){
			d array.SetAt(value,key)	
		}
	}
	q array
}

/// Creator:    yn
/// CreateDate: 2022-09-10
/// Input:      AInstanceId 病历ID
/// Output:      FALSE 或 TRUE 获取病历是否为插件压缩
/// Debug:      w ##Class(EMRservice.BLBSParseXML).GetEMRZipFlag("286||7")
ClassMethod GetPluginEMRZipFlag(AInstanceId As %String)
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

}
