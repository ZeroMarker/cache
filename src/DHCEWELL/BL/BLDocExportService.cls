/// 名称：		DHCEWELL.BL.BLDocExportService
/// 描述：		宁医大总院慢病管理系统EMR接口
/// 编写者：	yejian
/// 编写时间：	2017-2-5
Class DHCEWELL.BL.BLDocExportService Extends (%RegisteredObject, %XML.Adaptor)
{

/// 获取模板数据结构
/// w ##Class(DHCEWELL.BL.BLDocExportService).EmrDocument("112","HDSD00.13.01")
ClassMethod EmrDocument(AEpisodeID As %String, AGlossaryCategoryID As %String) As %GlobalCharacterStream
{

	s ItemsSet=##Class(%GlobalCharacterStream).%New()
	q:(AEpisodeID="") ItemsSet
	s glossaryCategoryID = $O(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_AGlossaryCategoryID,""))
	q:(glossaryCategoryID="") ItemsSet
	s objGlossaryC = ##Class(EPRmeta.GlossaryCategory).%OpenId(glossaryCategoryID)
	q:(objGlossaryC="") ItemsSet
	s categoryName = $tr(objGlossaryC.Name,"子集","")
	s PatientId=##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(AEpisodeID)
    s CurrentDepts = ##Class(EPRservice.HISInterface.PatientInfoAssist).CurrentDept(AEpisodeID)
    s curDeptID = $p(CurrentDepts,"^",1)
    s curDeptName = $p(CurrentDepts,"^",3)
    s DischgDocs=##Class(EPRservice.HISInterface.PatientInfoAssist).MainDoc(AEpisodeID)
    s docCode = $p(DischgDocs,"^",2)
    s docName = $p(DischgDocs,"^",3)
    s strCreateDate = ""
    
    s printTemplateDocId = ##Class(EPRservice.BLL.BLGetDataInfo).GetCtmDictIDByCtmDictCode(AGlossaryCategoryID)
	s EPRNum = ##class(EPRservice.BLL.BLGetDataInfo).GetSingleEPRNumByDocType(printTemplateDocId)
	s strUserDes = ##Class(EPRservice.BLL.BLGetDataInfo).GetLogStatus(AEpisodeID,printTemplateDocId,EPRNum)
	s strUserDes = ##Class(EPRinstance.EPRLogs).GetLogStatus("58","166","1")
	s strUserDes =""
	s userName = " "
	s createDate = ""
	s createTime = ""
	s createdt = " "
	if ($l(strUserDes,"|")>3)
	{
		s userName = $p($p(strUserDes,"|",2),":",2)
		s createDate = $p($p(strUserDes,"|",3)," ",4)
		s createTime = $p($p(strUserDes,"|",3)," ",5)
		if (createDate '= ""){
		s createDate = ##Class(EPRservice.BLL.BLDataETranFactory).GetDataByFormat(createDate,"D8","1")
		}
		if (createTime '= ""){
		s createTime = ##Class(EPRservice.BLL.BLDataETranFactory).GetDataByFormat(createTime,"D6","1")
		}
		s createdt = createDate _ "" _createTime
	}
    
    d ItemsSet.Write("<Doc>")
	d ItemsSet.Write("<DocId>"_AGlossaryCategoryID_"</DocId>") //病历主键标识
	d ItemsSet.Write("<PatientId>"_PatientId_"</PatientId>")	//病人号
	d ItemsSet.Write("<EncounterId>"_AEpisodeID_"</EncounterId>") //病人就诊号
	d ItemsSet.Write("<MainTypeId>"_AGlossaryCategoryID_"</MainTypeId>")	//病历的类别代码
	d ItemsSet.Write("<MainTypeName>"_categoryName_"</MainTypeName>")	// 病历的类别名称
	d ItemsSet.Write("<ContextText></ContextText>")	// 病历记录文本
	d ItemsSet.Write("<ContextXml></ContextXml>")	// 病历记录的xml形式
	d ItemsSet.Write("<DeptName>"_curDeptName_"</DeptName>")	// 科室名称
	d ItemsSet.Write("<DeptCode>"_curDeptID_"</DeptCode>")		// 科室代码
	d ItemsSet.Write("<DoctorName>"_docName_"</DoctorName>") // 医生名称
	d ItemsSet.Write("<DoctorCode>"_docCode_"</DoctorCode>")	// 医生代码
	d ItemsSet.Write("<MainCreateDate>"_strCreateDate_"</MainCreateDate>")	// 病历的创建日期
	d ItemsSet.Write("<items>")
	s result = ""
	s instances = ..GetInstanceIDSByTemID(AEpisodeID,AGlossaryCategoryID)
	s intInsCount = $ll(instances)
	if (intInsCount = 0)
	{
		;d ItemsSet.Write("<item>")
		;d ..getItem(AEpisodeID,AGlossaryCategoryID,.ItemsSet)
		;d ItemsSet.Write("</item>")
	}
	else
	{
		for i = 1:1:intInsCount
		{
			s AInstanceID = $lg(instances,i)
			continue:(AInstanceID="")
			s strTitle = $p(AInstanceID,"^",1)
			s strCreateDate = $p(AInstanceID,"^",2)
			s AInstanceID = $p(AInstanceID,"^",3)
			d ItemsSet.Write("<item>")
			;d ItemsSet.Write("<MainTypeId>"_AGlossaryCategoryID_"</MainTypeId>")	//病历的类别代码
			;d ItemsSet.Write("<MainTypeName>"_categoryName_"</MainTypeName>")	// 病历的类别名称
			d ItemsSet.Write("<ItemCreateDate>"_strCreateDate_"</ItemCreateDate>")	// 病历的创建日期
			d ..getItem(AEpisodeID,AGlossaryCategoryID,.ItemsSet,AInstanceID)
			d ItemsSet.Write("</item>")
		}
	}
	
	d ItemsSet.Write("</items>")
	d ItemsSet.Write("</Doc>")
	//导出为本地文件
	s strMeName =""_"EpisodeID "_AEpisodeID
	d ..exPortToXml(ItemsSet,strMeName)
	q ItemsSet
}

/// Desc:	获取InstanceID集合通过AEpisodeID和TemplateID,只针对可重复模板
/// Input：	AEpisodeID : 就诊指针
/// 		ACategoryInternalID : 指定术语集范畴内部标识符
/// Output:	术语值数组
/// Debug:	d ##Class(DHCEWELL.BL.BLDocExportService).GetInstanceIDSByTemID("14743959","HDSD00.14.01")
ClassMethod GetInstanceIDSByTemID(AEpisodeID As %String, AGlossaryCategoryID As %String) As %List
{
	s reslut = ""
	s strChartItemIDs = ""
	s strTitle =""
	s strCategoryS = "^HDSD00.11|CG22|$住院病案首页$^HDSD00.14.01|ML538&ML70|$首次病程记录$&$病程记录$^HDSD00.14.03|ML538|$首次查房记录$教授查房记录$上级医生查房记录$术前主刀医生查房$^HDSD00.14.02|ML538|$病程记录$病程记录（新起页）$^HDSD00.14.12|ML538|$术后记录$^HDSD00.06.02|ML538|$手术记录$^HDSD00.14.08|ML538|$抢救记录$^HDSD00.10.05|ML538|$病情告知$^HDSD00.10.06|ML538|$知情同意书$^HDSD00.10.01|ML538|$手术同意书$^HDSD00.14.10|ML538|$术前小结$^"
	s glossarycategoryID = AGlossaryCategoryID_"|"
	if (strCategoryS [ glossarycategoryID)
	{
		s strCount =$L(strCategoryS,"^")
		for i = 1:1:strCount
		{
			if ($p(strCategoryS,"^",i) [ glossarycategoryID)
			{
				s strChartItemIDs = $p($p(strCategoryS,"^",i),"|",2)
				s strTitle = $p($p(strCategoryS,"^",i),"|",3)
				q
			}
		}
	}
	else
	{
		q reslut
	}
	s strChartCount =$L(strChartItemIDs,"&")
	for k = 1:1:strChartCount
	{
		s strChartItemID = $p(strChartItemIDs,"&",k)
		s strECRowID = ""
		s strECRowID = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_strChartItemID,strECRowID))
		continue:(strECRowID = "")
		s objECRecord = ##Class(EPRinstance.ECRecord).%OpenId(strECRowID)
    
		Set key = ""
		do
		{ 
	    	S objInstanceData = objECRecord.Instances.GetNext(.key)
		    if (objInstanceData '= "")
	     	{ 
	     	  continue:((objInstanceData.Status="UnSave")||(objInstanceData.Status="Delete"))
	     	  if (strTitle'="")
	     	  {
		     	  s strInTitle ="$"_objInstanceData.Title_"$"
	     	  	if ((objECRecord.ChartItemType = "Single")||(strInTitle = strTitle)||(strTitle [ strInTitle))
	     	  	{
		     	  	//w "objInstanceData.Title: ",objInstanceData.Title," objInstanceData.ID: ",objInstanceData.%Id(),!
	     	  		s createDate = $zd(objInstanceData.CreateDate,3)_" "_$zt(objInstanceData.CreateTime,1)
	     	  		s strReslut = objInstanceData.Title_"^"_createDate_"^"_objInstanceData.%Id()
	     	  		s reslut = reslut_$lb(strReslut)
	     	  	}
     	  	
	     	  }
	     	  else
	     	  {
		     	s reslut = reslut_$lb(objInstanceData.%Id())
	     	  }
		  	} 
		 } 
		 while (key '="" )
	}
	q reslut
}

ClassMethod getItem(AEpisodeID As %String, AGlossaryCategoryID As %String, ByRef ItemsSet As %GlobalBinaryStream, AinstanceDataID As %String = "") As %String
{
	s StandDataArry=..GetDataByGlossaryCategory(AEpisodeID,AGlossaryCategoryID,AinstanceDataID)
	s key = "0"
	While (key'="")
	{
		s strValues = StandDataArry.GetNext(.key)
		s displayName = $p(strValues,"&#",1)
		s strValue = $p(strValues,"&#",2)
		continue:(strValue = "")
		q:(key="")
		s strItem = "<DItem ItemName="""_displayName_""" ItemValue="""_strValue_"""></DItem>"
		//s strItem = "<DItem ItemID="""_key_""" ItemName="""_displayName_""" ItemValue="""_strValue_"""></DItem>"
		//s strItem = $zcvt(strItem,"O","UTF8")
		;w strItem,!  
		d ItemsSet.Write(strItem)
    
	}
}

/// Desc:	获取指定术语集范畴下的所有术语值
/// Input：	AEpisodeID : 就诊指针
/// 		ACategoryInternalID : 指定术语集范畴内部标识符
/// Output:	术语值数组
/// Debug:	w ##Class(EPRservice.BIL.BIToHIP).GetDataByGlossaryCategory("14743959","HDSD00.14.01","21163794||1")
ClassMethod GetDataByGlossaryCategory(AEpisodeID As %String, ACategoryInternalID As %String, AinstanceDataID As %String = "") As %ArrayOfDataTypes
{
	//判断是旧版还是新版
	s count = ##class(EMRservice.BL.BLScatterData).GetOldRecCount(AEpisodeID)
	if (count<=0)
	{
		s retArray = ..GetNewDataByGlossaryCategory(AEpisodeID,ACategoryInternalID)
	}
	else
	{
		s glossaryCategoryID = $O(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_ACategoryInternalID,""))
		q:(glossaryCategoryID="") ""

		s retArray = ##Class(%ArrayOfDataTypes).%New()

		s glossaryID = ""
		for {
			s glossaryID = $O(^DHCEPRM.GlossaryI("IdxCategoryID"," "_glossaryCategoryID,glossaryID))
			q:(glossaryID="")
	
			s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(glossaryID)
			continue:(objGlossary="")
			s deName = objGlossary.Name
			s deName = $p(deName," ",2)
			s internalID = objGlossary.InternalID
			if ("HDSD00.11.110" = internalID)
			{
				s str = ""
			}
			//通过注册号，术语rowId获取业务数据
			s strDataValue = ..GetScatterDataByGlossaryID(AEpisodeID,glossaryID,AinstanceDataID)
			if (strDataValue ="")
			{
				s strDataValue = ##class(EPRservice.BOScatterData).GetScatterDataByGlossaryID(AEpisodeID,glossaryID)
			}
			s strDataValue = deName _"&#"_strDataValue
			;w internalID_":"_strDataValue,!
			d retArray.SetAt(strDataValue, internalID)
		}
	}
	q retArray
}

/// Desc:	获取指定术语集范畴下的所有标准术语值
/// Input：	AEpisodeID : 就诊指针
/// 		ACategoryInternalID : 指定术语集范畴内部标识符
/// Output:	术语值数组
/// Debug:	w ##Class(EMRservice.BL.BLScatterData).GetNewDataByGlossaryCategory("356","HDSD00.13.03")
ClassMethod GetNewDataByGlossaryCategory(AEpisodeID As %String, ACategoryInternalID As %String) As %ArrayOfDataTypes
{
	s ret = ##Class(%ArrayOfDataTypes).%New()
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	q:($d(ACategoryInternalID) = 0)||(ACategoryInternalID = "") ret
	
	s glossaryCategoryID = $O(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_ACategoryInternalID,""))
	q:(glossaryCategoryID="") ret
	//通过术语集目录获取关联的模板ID
	s objGlossaryCategory =  ##Class(EPRmeta.GlossaryCategory).%OpenId(glossaryCategoryID)
	q:(objGlossaryCategory="") ret
	s templateCategoryID = objGlossaryCategory.TemplateCategroyID
	q:(templateCategoryID="") ret
	//获取InstanceID集合
	s InstanceIDS = ##Class(EMRservice.BL.BLScatterData).GetInstanceIDByTInterID(AEpisodeID,templateCategoryID)
	s intInsCount = $ll(InstanceIDS)
	q:(intInsCount = 0) ret
	for i = 1:1:intInsCount
	{
		s AInstanceID = $lg(InstanceIDS,i)
		continue:(AInstanceID="")
		s retArray = ##Class(%ArrayOfDataTypes).%New()
		s templateID = ""
		s glossaryID = ""
		for {
			s glossaryID = $O(^DHCEPRM.GlossaryI("IdxCategoryID"," "_glossaryCategoryID,glossaryID))
			q:(glossaryID="")
	
			s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(glossaryID)
			continue:(objGlossary="")
			s deName = objGlossary.Name
			s deName = $p(deName," ",2)
			s strDataValue = ""
			//通过注册号，术语rowId获取业务数据
			s strDataValue =##Class(EMRservice.BL.BLScatterData).GetNewScatterDataByGlossaryID(AEpisodeID,glossaryID,AInstanceID)
		 	s strDataValue = deName _"&#"_strDataValue
		 	d ret.SetAt(strDataValue, objGlossary.InternalID)
		 }
		;d ret.SetAt(retArray, AInstanceID)
	 }
	 
	 q ret
}

/// Desc: 	使用术语集取电子病历打散数据
/// Return:	metaItemInfo$|value&|metaItemInfo$|value
/// Debug: 	w ##class(EPRservice.BLL.BLDataETranFactory).GetScatterDataByGlossaryID("58","1811","810||2")
ClassMethod GetScatterDataByGlossaryID(AEpisodeID As %String, AGlossaryID As %String, instanceDataID As %String = "") As %String
{
	s ret = ""
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	q:($d(AGlossaryID) = 0)||(AGlossaryID = "") ret
	s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(AGlossaryID)
	q:(objGlossary = "") ret
	
	s name = objGlossary.Name
	s type = objGlossary.GlossaryType
	
	if ($zcvt(type,"U") = "TG")
	{
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",AGlossaryID,rowID))
			q:(rowID = "")
			
			s objItem = ##Class(EPRmeta.GlossaryItem).%OpenId(rowID)
			
			s itemCode = objItem.ItemCode
			s valueType = objItem.ValueType
			s templateID = objItem.TemplateID
			s ret = ""
			if (instanceDataID = ""){
			s ret = ##Class(EPRservice.BOScatterData).GetScatterData(AEpisodeID,templateID,itemCode,valueType)
			}else{
			s ret = ##Class(EPRservice.BOScatterData).GetMultipleScatterData(AEpisodeID,templateID,itemCode,instanceDataID,valueType)
			}
			q:(ret '= "")&&(ret '= "Null")
		}	
	}
	else
	{
		s parGlossaryID = objGlossary.ParentID
		q:(parGlossaryID = "") ret

		s objParGlossary = ##Class(EPRmeta.Glossary).%OpenId(parGlossaryID)
		q:(objParGlossary = "") ret
			
		s parRowID = ""
		for {
			s parRowID = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",parGlossaryID,parRowID))
			q:(parRowID = "")
			
			s objParItem = ##Class(EPRmeta.GlossaryItem).%OpenId(parRowID)
			
			s parItemCode = objParItem.ItemCode
			s parValueType = objParItem.ValueType
			s parTemplateID = objParItem.TemplateID

			//s parItemValue = ##Class(EPRservice.BOScatterData).GetScatterData(AEpisodeID,parTemplateID,parItemCode,parValueType)
			//if (parItemValue = "")
			//{
			//	q
			//}
			s kbRowID = ""
			for {
				s kbRowID = $o(^DHCEPRM.GlossaryKBItemI("IdxGlossaryID",AGlossaryID,kbRowID))
				q:(kbRowID = "")
			
				s objParItem = ##Class(EPRmeta.GlossaryKBItem).%OpenId(kbRowID)
				s curItemCode = objParItem.ItemCode
				s curValueType = objParItem.ValueType
				s kbPartNo = objParItem.KBPartNo
				S KBNodeID = objParItem.KBNodeID
			
				s curTextSimpleRowID= ""
				for
				{
					s curTextSimpleRowID = $o(^DHCEPRI.ITextDescSimpleI("IdxForUpdate"," "_instanceDataID," "_parItemCode," "_KBNodeID," "_kbPartNo," "_curItemCode,curTextSimpleRowID))
					q:(curTextSimpleRowID = "")
					s curItemType = $e($tr(curItemCode," ",""),0,1)
					s curTextSimpleValue = ##Class(EPRservice.BOScatterData).GetITextDescSimpleValue(curTextSimpleRowID,curItemType,$tr(curValueType," ",""))
					if (curTextSimpleValue '= "")
					{
						s ret = curTextSimpleValue
						q	
					}	
				}	
			}	
		}
	}
	s:(ret="Null") ret = ""
	q ret
}

/// Creator:	yejian
/// CreatDate:  2012-7-9
/// Desc:		根据目录ID查找数据元
/// Input：		aCategoryID：术语范畴Id
/// Return：	EPRservice.dataset.EDataElementDataset: 术语集dataset
/// Debug:		d ##Class(%ResultSet).RunQuery("DHCEWELL.BL.BLDocExportService","SelectAllDataElement")
Query SelectAllDataElement() As %Query(ROWSPEC = "InternalID:%String,Name:%String")
{
}

ClassMethod SelectAllDataElementExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s rowID = ""
	
	for {
		s rowID = $o(^DHCEPRM.GlossaryCategoryD(rowID))
		q:(rowID = "")	
		
		s objDataElemen = ##Class(EPRmeta.GlossaryCategory).%OpenId(rowID)
		continue:(objDataElemen.ResChildCount<=0)
		s Entifier = objDataElemen.InternalID
		continue:(Entifier="")
		s Name = objDataElemen.Name
	
		
		s Data = $lb(Entifier,Name)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1
	}
	q $$$OK
}

ClassMethod SelectAllDataElementFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectAllDataElementExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod SelectAllDataElementClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectAllDataElementExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod exPortToXml(sourceA As %AbstractStream, nameA As %String)
{

	s objstreamF=##class(%FileCharacterStream).%New()
	s objstreamF.Filename="D:\xml\MetaData_"_nameA_"_.xml"
	d objstreamF.TranslateTableSet("UTF8")
	d objstreamF.CopyFrom(sourceA)
	d objstreamF.SaveStream()
	d objstreamF.%Close()
}

}
