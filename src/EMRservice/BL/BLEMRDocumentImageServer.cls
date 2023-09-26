/// 名称: EMRservice.BL.BLEMRDocumentImageServer
/// 描述: 病历图片访问接口业务类
/// 编写者：FangLuoCheng
/// 编写日期: 2016-01-13
Class EMRservice.BL.BLEMRDocumentImageServer Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Description:   图片访问接口解析argInMessage参数，进行分支处理
/// Table：        
/// Input：        argInMessage :命令信息 JSON格式 { \"action\": \"GetPatientCategoryList\", "args": {\"adm\":\"1\"},\"OutType\": \"XML\"} 
/// 注OutType为输出类型 IMAGE：图片，XML:cdaXML文件
/// Output         argOutMessage:传出的函数XML结果流
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         w ##Class(EMRservice.BL.BLEMRDocumentImageServer).AcitonProxy(argInMessage,argOutMessage)	
ClassMethod AcitonProxy(argInMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream) As %String
{
	
	//解析json参数		       
	s objJson = ##Class(EMRservice.Parser.Json).%New()  
	s array = objJson.Deserialize(argInMessage)
	s strAction = array.GetAt("action")
	s args = array.GetAt("args")
	s outType =array.GetAt("OutType")
	//命令分发
	if (strAction = "GetFtpServerConfig")  
	{
		q argOutData.CopyFrom(##Class(EMRservice.BL.BLEMRDocumentImageServer).GetFtpServerConfig(outType))
	}
	elseif (strAction = "GetPatientCategoryList")
	{
		s strAdm = args.GetAt("adm")
		q argOutData.CopyFrom(##Class(EMRservice.BL.BLEMRDocumentImageServer).GetPatientCategoryList(strAdm,outType))
	}  
	elseif (strAction = "GetEMRImageList")
	{		
		s strAdm = args.GetAt("adm")
		s strInternalID = args.GetAt("InternalID")
		q argOutData.CopyFrom(##Class(EMRservice.BL.BLEMRDocumentImageServer).GetEMRImageList(strAdm,strInternalID,outType))
	}  	
	elseif (strAction = "GetEMRImageListByID")
	{		
		s strAdm = args.GetAt("adm")
		s strDocID = args.GetAt("DocID")
		q argOutData.CopyFrom(##Class(EMRservice.BL.BLEMRDocumentImageServer).GetEMRImageListByID(strAdm,strDocID,outType))
	}  	
	elseif (strAction = "GetEMRCDAXmlList")
	{		
		s strAdm = args.GetAt("adm")
		s strInternalID = args.GetAt("InternalID")
		q argOutData.CopyFrom(##Class(EMRservice.BL.BLEMRDocumentImageServer).GetEMRCDAXmlList(strAdm,strInternalID,outType))
	}  	
	elseif (strAction = "GetEMRCDAXmlListByID")
	{		
		s strAdm = args.GetAt("adm")
		s strDocID = args.GetAt("DocID")
		q argOutData.CopyFrom(##Class(EMRservice.BL.BLEMRDocumentImageServer).GetEMRCDAXmlListByID(strAdm,strDocID,outType))
	}  	
	
   q ""
}

// 获取病历图片存放FTP服务器地址、账号、密码

// 'server':'127.0.0.1','port':'21','username':'ftpuser','password':'ftpuser','timeout':'3000'

// w ##Class(EMRservice.BL.BLEMRDocumentImageServer).GetFtpServerConfig()

ClassMethod GetFtpServerConfig(outType As %String) As %GlobalBinaryStream
{
   
    s $zt = "Error"
	s stream = ##Class(%GlobalBinaryStream).%New()
	s RowID =""
	if (outType="XML")
	{
		s RowID=$O(^DHCEMRM.SysOptionI("NameIndex"," FTP_CONNECT_CDAXML",""))
	}
	if (RowID="")
	{
		s RowID=$O(^DHCEMRM.SysOptionI("NameIndex"," FTP_CONNECT_PARAMS",""))
	}
	if (RowID="")  
	{
		d OutputNull
		q stream
	}		
	s obj=##class(EMRmeta.SysOption).%OpenId(RowID)
	if (obj="") 
	{
		d OutputNull
		q stream
	}	
	d stream.Write("<FtpConfig>")
	s FtpParams=obj.OptionValue
	s Count=$l(FtpParams,",")
	for i=1:1:Count	
	{
		s Param=$P(FtpParams,",",i)
		s splitParamName=$P(Param,":",1)
		s ParamName=$P(splitParamName,"'",2)
		s splitParamValue=$P(Param,":",2)
		s ParamValue=$P(splitParamValue,"'",2)
		if (ParamName="server")
		{
			d stream.Write("<FtpIP>"_ParamValue_"</FtpIP>") 
		}
		elseif (ParamName="port")
		{
			d stream.Write("<FtpPort>"_ParamValue_"</FtpPort>") 
		}
		elseif (ParamName="username")
		{
			d stream.Write("<FtpUserName>"_$zcvt(ParamValue,"O","UTF8")_"</FtpUserName>") 
		}
		elseif (ParamName="password")
		{
			d stream.Write("<FtpUserPassWord>"_ParamValue_"</FtpUserPassWord>") 
		}	
	}
	d stream.Write("</FtpConfig>")	
	if (Count>0)
	{	
	    q stream
	}
	else
	{
		d OutputNull
		q stream		
	}
OutputNull
        s ErrorCode="C01"
		s ErrorDetail="数据为空"
		s stream = ##Class(%GlobalBinaryStream).%New()
		d stream.Write("<FtpConfig>")
		d stream.Write("<ErrorCode>"_ErrorCode_"</ErrorCode>")
		d stream.Write("<ErrorDetail>"_$zcvt(ErrorDetail,"O","UTF8")_"</ErrorDetail>")
		d stream.Write("</FtpConfig>")
		q stream
Error
        s ErrorCode="C03"
		s ErrorDetail="执行方法报错"
		s stream = ##Class(%GlobalBinaryStream).%New()
		d stream.Write("<FtpConfig>")
		d stream.Write("<ErrorCode>"_ErrorCode_"</ErrorCode>")
		d stream.Write("<ErrorDetail>"_$zcvt(ErrorDetail,"O","UTF8")_"</ErrorDetail>")
		d stream.Write("</FtpConfig>")
		q stream
}

// 根据adm（就诊号）获取患者本次就诊病历目录

// w ##Class(EMRservice.BL.BLEMRDocumentImageServer).GetPatientCategoryList("88")

ClassMethod GetPatientCategoryList(adm As %String, outType As %String = "") As %GlobalBinaryStream
{
	s $zt = "Error"
	s stream = ##Class(%GlobalBinaryStream).%New()
	if (adm="") 
	{
		d OutputNull
		q stream	
	}	
	s Flag="false" 
	s patientId=$P($G(^PAADM(adm)),"^",1)
	s parentId=" 0", curCategoryId="0"
	s OutcurCategoryChapterId="",OutcategoryChapterName=""	
	d stream.Write("<Categorys>")
	f  s curCategoryId=$O(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID",parentId,curCategoryId)) q:curCategoryId=""  d
       .q:curCategoryId=""
	   .s curCategoryChapterId=""	
	   .f  s curCategoryChapterId=$O(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID"," "_curCategoryId,curCategoryChapterId)) q:curCategoryChapterId=""  d
	   ..q:curCategoryChapterId="0"	
	   ..s docId = ##class(EMRservice.BL.BLEMRTemplateCategory).GetSubPrtTemplateCategory(curCategoryId, curCategoryChapterId)		//若为第二层目录,传入两个参数
	   ..q:docId=""		
	   ..s imageList=##class(EMRservice.BL.BLExportQueue).GetImageCount(adm,docId,outType)		
	   ..s imageCount = $p(imageList, "$", 1)	
	   ..q:(imageCount = 0)
	   ..s categoryChapter = ##class(EMRmeta.EMRTemplateCategory).%OpenId(curCategoryChapterId)
	   ..q:(categoryChapter = "")	  
	   ..s OutcurCategoryChapterId=curCategoryChapterId
	   ..s OutcategoryChapterName=categoryChapter.CategoryName
	   ..s docIDCount = $L(docId,"^")
	   ..s rdocID = ""
	   ..s ic =""
	   ..f ic=1:1:docIDCount d
	   ...S rdocID = $P(docId,"^",ic)
	   ...s categoryChapter = ##class(EMRmeta.EMRTemplateCategory).%OpenId(rdocID)
	   ...q:(categoryChapter = "")
	   ...s categoryInternalID=categoryChapter.InternalID
	   ...s Flag="true"	  
	   ...d stream.Write("<Category>")
	   ...d stream.Write("<InternalID>"_categoryInternalID_"</InternalID>")
	   ...d stream.Write("<CategoryName>"_OutcategoryChapterName_"</CategoryName>")
	   ...;d stream.Write("<CategoryName>"_$zcvt(OutcategoryChapterName,"O","UTF8")_"</CategoryName>")
	   ...d stream.Write("<DocID>"_rdocID_"</DocID>")
	   ...d stream.Write("</Category>")	  
	   
	   d stream.Write("</Categorys>")	
	   
	   if (Flag="true")  
	   {
		   q stream
	   }
	   else
	   {
		   d OutputNull
		   q stream	
	   }
	   
OutputNull
        s ErrorCode="C01"
		s ErrorDetail="数据为空"
		s stream = ##Class(%GlobalBinaryStream).%New()
		d stream.Write("<Categorys>")
		d stream.Write("<ErrorCode>"_ErrorCode_"</ErrorCode>")
		d stream.Write("<ErrorDetail>"_$zcvt(ErrorDetail,"O","UTF8")_"</ErrorDetail>")
		d stream.Write("</Categorys>")
		q stream
Error
        s ErrorCode="C03"
		s ErrorDetail="执行方法报错"
		s stream = ##Class(%GlobalBinaryStream).%New()
		d stream.Write("<Categorys>")
		d stream.Write("<ErrorCode>"_ErrorCode_"</ErrorCode>")
		d stream.Write("<ErrorDetail>"_$zcvt(ErrorDetail,"O","UTF8")_"</ErrorDetail>")
		d stream.Write("</Categorys>")
		q stream
}

// 根据目录编码获取目录的子编码

// w ##Class(EMRservice.BL.BLEMRDocumentImageServer).GetCategoryCodeList("50","HDSD00.13")

ClassMethod GetCategoryCodeList(adm As %String, aInternalID As %String) As %String
{
	
	 q:(adm="") ""	
	 q:(aInternalID="") ""      
	 s categoryInternalID="",curCategoryId="0"
	 s CategoryId=""	
	 &sql(select ID into:CategoryId from EMRmeta.EMRTemplateCategory where InternalID=:aInternalID)	
	 q:(CategoryId="") ""	
	 s categoryObj = ##class(EMRmeta.EMRTemplateCategory).%OpenId(CategoryId)
	 q:(categoryObj="")
	 if (categoryObj.CategoryType="TempCate")
	 {
		q:((categoryObj.InternalID="")||(categoryObj.InternalID=$C(0)))
		if (categoryInternalID="")
		{
		    s categoryInternalID=categoryObj.InternalID
		}
	    else
		{
			s categoryInternalID=categoryInternalID_"^"_categoryObj.InternalID
	    } 
	 }
	 else
	 {
	  for
	  {
		 s curCategoryId=$O(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID"," "_CategoryId,curCategoryId)) 
		 q:curCategoryId=""
		 s categoryObj = ##class(EMRmeta.EMRTemplateCategory).%OpenId(curCategoryId)
		 q:(categoryObj="")
		 if (categoryObj.CategoryType'="TempCate")
		 {
		    s curCategoryChapterId=""
		    for
		    {
			   s curCategoryChapterId=$O(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID"," "_curCategoryId,curCategoryChapterId)) 
			   q:curCategoryChapterId=""
			   s categoryObj = ##class(EMRmeta.EMRTemplateCategory).%OpenId(curCategoryChapterId)	
			   q:(categoryObj="")	
			   if (categoryObj.CategoryType="TempCate")	 
			   {	
			       continue:((categoryObj.InternalID="")||(categoryObj.InternalID=$C(0)))	
			       continue:(categoryInternalID[categoryObj.InternalID)			  
				   if (categoryInternalID="")
				   {
				      s categoryInternalID=categoryObj.InternalID
				   }
				   else
				   {
				      s categoryInternalID=categoryInternalID_"^"_categoryObj.InternalID
				   }
			   }
		    }
		 }
		 else
		 {		
		      continue:((categoryObj.InternalID="")||(categoryObj.InternalID=$C(0)))
		      continue:(categoryInternalID[categoryObj.InternalID)	
			  if (categoryInternalID="")
			   {
				   s categoryInternalID=categoryObj.InternalID
			   }
			  else
			   {
				  s categoryInternalID=categoryInternalID_"^"_categoryObj.InternalID
			   }
		 }
	   }	 
	 }
	
	 q categoryInternalID
}

// 根据adm（就诊号）、展现结构ID获取患者本次就诊病历目录下实例病历图像FTP路径，图像格式为JPG格式。

// w ##Class(EMRservice.BL.BLEMRDocumentImageServer).GetEMRImageList("50","HDSD00.13.01")

ClassMethod GetEMRImageList(adm As %String, aInternalID As %String, outType As %String = "") As %GlobalBinaryStream
{
	   
	s $zt = "Error"
	s stream = ##Class(%GlobalBinaryStream).%New()	
	if ((aInternalID="") || (aInternalID=$C(0)) || (adm="") || (adm=$C(0)) )  
	{ 
	   d OutputNull
	   q stream
	}	
	s InternalIDList=..GetCategoryCodeList(adm,aInternalID)	
	if ((InternalIDList="") || (InternalIDList=$C(0)))  
	{
		d OutputNull
		q stream
	}	
	s Flag="false" 		
	s patientId=$P($G(^PAADM(adm)),"^",1)
	s imageFileType=".jpg"
	s Num=$l(InternalIDList,"^")
	d stream.Write("<ImagePaths>") 
	for Ni=1:1:Num
	{
	  s InternalID=$P(InternalIDList,"^",Ni)
	  s docId=""
	  for
	  {		  
		  s docId=$O(^DHCEMRM.EMRTemplateCategoryI("IdxInternalID"," "_InternalID,docId)) 
		  q:(docId="")
		  s categoryObj = ##class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
		  q:(categoryObj="")
		  s aCategoryName=categoryObj.CategoryName
		  s imageList=##class(EMRservice.BL.BLExportQueue).GetImageCount(adm,docId,outType)		
	      s imageCount = $p(imageList, "$", 1)
	      continue:(imageCount=0)	
	      s imageSubList=$P(imageList,"$",2)
	      s Count=$l(imageSubList,"#")	 
	      d stream.Write("<ImagePath>")     
	      for i=1:1:Count
	      {		     
	       s TmpStr=$p(imageSubList,"#",i)	 
	       s InstanceID=$p(TmpStr,"^",2)
	       s InstanceID = $tr(InstanceID,"||","/")
	       s printType=$p(TmpStr,"^",3)
	       s logImageCount=$p(TmpStr,"^",4)	       
	       if (logImageCount>0)
	       {
		      s Flag="true"	  
		      d stream.Write("<InternalID>"_InternalID_"</InternalID>")	
	          ;d stream.Write("<CategoryName>"_$zcvt(aCategoryName,"O","UTF8")_"</CategoryName>")
	          d stream.Write("<CategoryName>"_aCategoryName_"</CategoryName>")
	          d stream.Write("<PageCount>"_logImageCount_"</PageCount>")
	       }
	       	    
	       for logPage=1:1:logImageCount
	       {		      
		      s volNo=patientId\10000+1		   
	          s fileLocation="/dhcepr/vol"_volNo_"/"_patientId_"/"_adm_"/"_InstanceID_"/"_logPage_imageFileType
	          d stream.Write("<ImagePathURL>"_fileLocation_"</ImagePathURL>")		      
	       }	       
	      }	
	      d stream.Write("</ImagePath>") 	      
	  }
	}
	d stream.Write("</ImagePaths>")  
	
	if (Flag="true")  
	   {
		   q stream
	   }
	else
	   {
		   d Error
		   q stream
	   }

OutputNull
        s ErrorCode="C03"
		s ErrorDetail="数据为空"	
		s stream = ##Class(%GlobalBinaryStream).%New()
		d stream.Write("<ImagePaths>")
		d stream.Write("<ErrorCode>"_ErrorCode_"</ErrorCode>")
		d stream.Write("<ErrorDetail>"_$zcvt(ErrorDetail,"O","UTF8")_"</ErrorDetail>")
		d stream.Write("</ImagePaths>")
		q stream
Error
        s ErrorCode="C01"
		s ErrorDetail="执行方法报错"
		s stream = ##Class(%GlobalBinaryStream).%New()
		d stream.Write("<ImagePaths>")
		d stream.Write("<ErrorCode>"_ErrorCode_"</ErrorCode>")
		d stream.Write("<ErrorDetail>"_$zcvt(ErrorDetail,"O","UTF8")_"</ErrorDetail>")
		d stream.Write("</ImagePaths>")
		q stream
}

// 根据adm（就诊号）、展现结构ID获取患者本次就诊病历目录下实例病历图像FTP路径，图像格式为JPG格式。

// w ##Class(EMRservice.BL.BLEMRDocumentImageServer).GetEMRImageListByID("50","1026^1234")

ClassMethod GetEMRImageListByID(adm As %String, aDocIDs As %String, outType As %String = "") As %GlobalBinaryStream
{
	   
	s $zt = "Error"
	s stream = ##Class(%GlobalBinaryStream).%New()	
	if ((aDocIDs="") || (aDocIDs=$C(0)) || (adm="") || (adm=$C(0)) )  
	{ 
	   d OutputNull
	   q stream
	}	
	s Flag="false" 		
	s patientId=$P($G(^PAADM(adm)),"^",1)
	s imageFileType=".jpg"
	s Num=$l(aDocIDs,"^")
	d stream.Write("<ImagePaths>") 
	for Ni=1:1:Num
	{
	  s docId=$P(aDocIDs,"^",Ni)
		  s categoryObj = ##class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
		  continue:(categoryObj="")
		  s aCategoryName=categoryObj.CategoryName
		  s imageList=##class(EMRservice.BL.BLExportQueue).GetImageCount(adm,docId,outType)		
	      s imageCount = $p(imageList, "$", 1)
	      continue:(imageCount=0)	
	      s imageSubList=$P(imageList,"$",2)
	      s Count=$l(imageSubList,"#")	 
	      d stream.Write("<ImagePath>")    
	      for i=1:1:Count
	      {		     
	       s TmpStr=$p(imageSubList,"#",i)	 
	       s InstanceID=$p(TmpStr,"^",2)
	       s InstanceID = $tr(InstanceID,"||","/")
	       s printType=$p(TmpStr,"^",3)
	       s logImageCount=$p(TmpStr,"^",4)	   
	       if (logImageCount>0)
	       {
		      s Flag="true"	  
		      d stream.Write("<DocID>"_docId_"</DocID>")	
	          //d stream.Write("<CategoryName>"_$zcvt(aCategoryName,"O","UTF8")_"</CategoryName>")
	          d stream.Write("<CategoryName>"_aCategoryName_"</CategoryName>")
	          d stream.Write("<PageCount>"_logImageCount_"</PageCount>")
	       }   
	       for logPage=1:1:logImageCount
	       {		      
		      s volNo=patientId\10000+1		   
	          s fileLocation="/dhcepr/vol"_volNo_"/"_patientId_"/"_adm_"/"_InstanceID_"/"_logPage_imageFileType
	          d stream.Write("<ImagePathURL>"_fileLocation_"</ImagePathURL>")		      
	       }	       
	       }	
	      d stream.Write("</ImagePath>") 	      
	}
	d stream.Write("</ImagePaths>")  
	
	if (Flag="true")  
	   {
		   q stream
	   }
	else
	   {
		   d Error
		   q stream
	   }

OutputNull
        s ErrorCode="C03"
		s ErrorDetail="数据为空"	
		s stream = ##Class(%GlobalBinaryStream).%New()
		d stream.Write("<ImagePaths>")
		d stream.Write("<ErrorCode>"_ErrorCode_"</ErrorCode>")
		d stream.Write("<ErrorDetail>"_$zcvt(ErrorDetail,"O","UTF8")_"</ErrorDetail>")
		d stream.Write("</ImagePaths>")
		q stream
Error
        s ErrorCode="C01"
		s ErrorDetail="执行方法报错"
		s stream = ##Class(%GlobalBinaryStream).%New()
		d stream.Write("<ImagePaths>")
		d stream.Write("<ErrorCode>"_ErrorCode_"</ErrorCode>")
		d stream.Write("<ErrorDetail>"_$zcvt(ErrorDetail,"O","UTF8")_"</ErrorDetail>")
		d stream.Write("</ImagePaths>")
		q stream
}

ClassMethod GetEMRCDAXmlList(adm As %String, aInternalID As %String, outType As %String = "") As %GlobalBinaryStream
{
	   
	s $zt = "Error"
	s stream = ##Class(%GlobalBinaryStream).%New()	
	if ((aInternalID="") || (aInternalID=$C(0)) || (adm="") || (adm=$C(0)) )  
	{ 
	   d OutputNull
	   q stream
	}	
	s InternalIDList=..GetCategoryCodeList(adm,aInternalID)	
	if ((InternalIDList="") || (InternalIDList=$C(0)))  
	{
		d OutputNull
		q stream
	}	
	s Flag="false" 		
	s patientId=$P($G(^PAADM(adm)),"^",1)
	s imageFileType=".xml"
	s Num=$l(InternalIDList,"^")
	d stream.Write("<xmlPaths>") 
	for Ni=1:1:Num
	{
	  s InternalID=$P(InternalIDList,"^",Ni)
	  s docId=""
	  for
	  {		  
		  s docId=$O(^DHCEMRM.EMRTemplateCategoryI("IdxInternalID"," "_InternalID,docId)) 
		  q:(docId="")
		  s categoryObj = ##class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
		  q:(categoryObj="")
		  s aCategoryName=categoryObj.CategoryName
		  s imageList=##class(EMRservice.BL.BLExportQueue).GetImageCount(adm,docId,outType)		
	      s imageCount = $p(imageList, "$", 1)
	      continue:(imageCount=0)	
	      s imageSubList=$P(imageList,"$",2)
	      s Count=$l(imageSubList,"#")	 
	      d stream.Write("<xmlPath>")     
	      for i=1:1:Count
	      {		     
	       s TmpStr=$p(imageSubList,"#",i)	 
	       s InstanceID=$p(TmpStr,"^",2)
	       s printType=$p(TmpStr,"^",3)
	       s logImageCount=$p(TmpStr,"^",4)	       
	       if (logImageCount>0)
	       {
		      s Flag="true"	  
		      d stream.Write("<InternalID>"_InternalID_"</InternalID>")	
	          ;d stream.Write("<CategoryName>"_$zcvt(aCategoryName,"O","UTF8")_"</CategoryName>")
	          d stream.Write("<CategoryName>"_aCategoryName_"</CategoryName>")
	          d stream.Write("<PageCount>"_logImageCount_"</PageCount>")
	       }
	       	    
	       for logPage=1:1:logImageCount
	       {		      
		      s volNo=patientId\10000+1
		      s strTheID =$P(InstanceID,"||",1)
		      s strinID =$P(InstanceID,"||",2)		   
	          s fileLocation="/emrcdaxml/vol"_volNo_"/"_patientId_"/"_adm_"/"_strTheID_"/"_strinID_imageFileType
	          d stream.Write("<xmlPathURL>"_fileLocation_"</xmlPathURL>")		      
	       }	       
	      }	
	      d stream.Write("</xmlPath>") 	      
	  }
	}
	d stream.Write("</xmlPaths>")  
	
	if (Flag="true")  
	   {
		   q stream
	   }
	else
	   {
		   d Error
		   q stream
	   }

OutputNull
        s ErrorCode="C03"
		s ErrorDetail="数据为空"	
		s stream = ##Class(%GlobalBinaryStream).%New()
		d stream.Write("<xmlPaths>")
		d stream.Write("<ErrorCode>"_ErrorCode_"</ErrorCode>")
		d stream.Write("<ErrorDetail>"_$zcvt(ErrorDetail,"O","UTF8")_"</ErrorDetail>")
		d stream.Write("</xmlPaths>")
		q stream
Error
        s ErrorCode="C01"
		s ErrorDetail="执行方法报错"
		s stream = ##Class(%GlobalBinaryStream).%New()
		d stream.Write("<xmlPaths>")
		d stream.Write("<ErrorCode>"_ErrorCode_"</ErrorCode>")
		d stream.Write("<ErrorDetail>"_$zcvt(ErrorDetail,"O","UTF8")_"</ErrorDetail>")
		d stream.Write("</xmlPaths>")
		q stream
}

// 根据adm（就诊号）、展现结构ID获取患者本次就诊病历目录下实例病历图像FTP路径，图像格式为JPG格式。

// w ##Class(EMRservice.BL.BLEMRDocumentImageServer).GetEMRImageListByID("50","1026^1234")

ClassMethod GetEMRCDAXmlListByID(adm As %String, aDocIDs As %String, outType As %String = "") As %GlobalBinaryStream
{
	   
	s $zt = "Error"
	s stream = ##Class(%GlobalBinaryStream).%New()	
	if ((aDocIDs="") || (aDocIDs=$C(0)) || (adm="") || (adm=$C(0)) )  
	{ 
	   d OutputNull
	   q stream
	}	
	s Flag="false" 		
	s patientId=$P($G(^PAADM(adm)),"^",1)
	s imageFileType=".xml"
	s Num=$l(aDocIDs,"^")
	d stream.Write("<xmlPaths>") 
	for Ni=1:1:Num
	{
	  s docId=$P(aDocIDs,"^",Ni)
		  s categoryObj = ##class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
		  continue:(categoryObj="")
		  s aCategoryName=categoryObj.CategoryName
		  s imageList=##class(EMRservice.BL.BLExportQueue).GetImageCount(adm,docId,outType)		
	      s imageCount = $p(imageList, "$", 1)
	      continue:(imageCount=0)	
	      s imageSubList=$P(imageList,"$",2)
	      s Count=$l(imageSubList,"#")	 
	      d stream.Write("<xmlPath>")    
	      for i=1:1:Count
	      {		     
	       s TmpStr=$p(imageSubList,"#",i)	 
	       s InstanceID=$p(TmpStr,"^",2)
	       s printType=$p(TmpStr,"^",3)
	       s logImageCount=$p(TmpStr,"^",4)	   
	       if (logImageCount>0)
	       {
		      s Flag="true"	  
		      d stream.Write("<DocID>"_docId_"</DocID>")	
	          //d stream.Write("<CategoryName>"_$zcvt(aCategoryName,"O","UTF8")_"</CategoryName>")
	          d stream.Write("<CategoryName>"_aCategoryName_"</CategoryName>")
	          d stream.Write("<PageCount>"_logImageCount_"</PageCount>")
	       }   
	       for logPage=1:1:logImageCount
	       {		      
		      s volNo=patientId\10000+1		   
	           s strTheID =$P(InstanceID,"||",1)
		      s strinID =$P(InstanceID,"||",2)		   
	          s fileLocation="/emrcdaxml/vol"_volNo_"/"_patientId_"/"_adm_"/"_strTheID_"/"_strinID_imageFileType
	          d stream.Write("<xmlPathURL>"_fileLocation_"</xmlPathURL>")		      
	       }	       
	       }	
	      d stream.Write("</xmlPath>") 	      
	}
	d stream.Write("</xmlPaths>")  
	
	if (Flag="true")  
	   {
		   q stream
	   }
	else
	   {
		   d Error
		   q stream
	   }

OutputNull
        s ErrorCode="C03"
		s ErrorDetail="数据为空"	
		s stream = ##Class(%GlobalBinaryStream).%New()
		d stream.Write("<xmlPaths>")
		d stream.Write("<ErrorCode>"_ErrorCode_"</ErrorCode>")
		d stream.Write("<ErrorDetail>"_$zcvt(ErrorDetail,"O","UTF8")_"</ErrorDetail>")
		d stream.Write("</xmlPaths>")
		q stream
Error
        s ErrorCode="C01"
		s ErrorDetail="执行方法报错"
		s stream = ##Class(%GlobalBinaryStream).%New()
		d stream.Write("<xmlPaths>")
		d stream.Write("<ErrorCode>"_ErrorCode_"</ErrorCode>")
		d stream.Write("<ErrorDetail>"_$zcvt(ErrorDetail,"O","UTF8")_"</ErrorDetail>")
		d stream.Write("</xmlPaths>")
		q stream
}

/// debugger:  d ##Class(EMRservice.BL.BLEMRDocumentImageServer).test()
ClassMethod test()
{
	
	s stream =##class(%GlobalBinaryStream).%New()
	s deel = """"
	//s tmp="{"_deel_"action"_deel_":"_deel_"GetFtpServerConfig"_deel_","_deel_"args"_deel_":"_deel_deel_","_deel_"OutType"_deel_":"_deel_"XML"_deel_"}"
	//s tmp="{"_deel_"action"_deel_":"_deel_"GetPatientCategoryList"_deel_","_deel_"args"_deel_":"_"{"_deel_"adm"_deel_":"_deel_"96"_deel_"}"_","_deel_"OutType"_deel_":"_deel_"XML"_deel_"}"
	s tmp ="{"_deel_"action"_deel_":"_deel_"GetEMRCDAXmlList"_deel_","_deel_"args"_deel_":"_"{"_deel_"adm"_deel_":"_deel_"96"_deel_","_deel_"InternalID"_deel_":"_deel_"HDSD00.14.02"_deel_"}"_","_deel_"OutType"_deel_":"_deel_"XML"_deel_"}"
	d stream.Write(tmp)

		
	s argOutData=##Class(%GlobalBinaryStream).%New()
	w ##Class(EMRservice.BL.BLEMRDocumentImageServer).AcitonProxy(stream,argOutData)	
	s AStream=##Class(%FileBinaryStream).%New()
	s AStream.Filename="e:\SAVE_DOCUMENT1.xml"
	d AStream.CopyFrom(argOutData)
	d AStream.SaveStream()
	d AStream.%Close()
	q
}

}
