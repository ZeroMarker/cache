Class EMRservice.BL.BLEmrUisWebService Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

//d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLEmrUisWebService","SelectByDate","63472","31106","65472","31106")

Query SelectByDate(paraAD As %String, paraAT As %String, paraBD As %String, paraBT As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,CreateDate:%String,CreateTime:%String,TemplateID:%String,Name:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_UisWebService_SelectByDate, SqlProc ]
{
SELECT v.ID,v.CreateDate,v.CreateTime,v.TemplateID,t.Name FROM SQLUSER.EMRmeta.TemplateVersion v 
JOIN  SQLUSER.EMRmeta.Template t  
ON v.TemplateID = t.ID
WHERE ((v.CreateDate = :paraAD AND v.CreateTime >=:paraAT) 
OR(v.CreateDate = :paraBD AND v.CreateTime <=:paraBT) 
OR (v.CreateDate>:paraAD AND v.CreateDate <:paraBD))
}

Query SelectByTime(paraAD As %String, paraAT As %String, paraBD As %String, paraBT As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,CreateDate:%String,CreateTime:%String,TemplateID:%String,Name:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_UisWebService_SelectByTime, SqlProc ]
{
SELECT v.ID,v.CreateDate,v.CreateTime,v.TemplateID,t.Name FROM SQLUSER.EMRmeta.TemplateVersion v 
JOIN  SQLUSER.EMRmeta.Template t  
ON v.TemplateID = t.ID
WHERE (v.CreateDate = :paraAD AND v.CreateTime >=:paraAT  AND v.CreateTime <=:paraBT)
}

Query SelectEprByDate(paraAD As %String, paraAT As %String, paraBD As %String, paraBT As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,CreateDate:%String,CreateTime:%String,TemplateID:%String,Name:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_UisWebService_SelectEprByDate, SqlProc ]
{
SELECT v.ID,v.CreateDate,v.CreateTime,v.TemplateID,t.Name FROM SQLUSER.EPRmeta.TemplateVersion v 
JOIN  SQLUSER.EPRmeta.Template t  
ON v.TemplateID = t.ID
WHERE (v.CreateDate = :paraAD AND v.CreateTime >=:paraAT  AND v.CreateTime <=:paraBT)
}

Query SelectEprByTime(paraAD As %String, paraAT As %String, paraBD As %String, paraBT As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,CreateDate:%String,CreateTime:%String,TemplateID:%String,Name:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_UisWebService_SelectEprByTime, SqlProc ]
{
SELECT v.ID,v.CreateDate,v.CreateTime,v.TemplateID,t.Name FROM SQLUSER.EPRmeta.TemplateVersion v 
JOIN  SQLUSER.EPRmeta.Template t  
ON v.TemplateID = t.ID
WHERE ((v.CreateDate = :paraAD AND v.CreateTime >=:paraAT) 
OR(v.CreateDate = :paraBD AND v.CreateTime <=:paraBT) 
OR (v.CreateDate>:paraAD AND v.CreateDate <:paraBD))
}

/// d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLEmrUisWebService","SelectDateByDate","63472","31106","65472","31106")
Query SelectDateByDate(paraAD As %String, paraAT As %String, paraBD As %String, paraBT As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,ModifyDate:%String,ModifyTime:%String,EpisodeID:%String,TemplateID:%String,TemplateVersion:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_UisWebService_SelectDateByDate, SqlProc ]
{
SELECT v.ID,v.ModifyDate,v.ModifyTime,v.EpisodeID,v.TemplateID,v.TemplateVersion FROM SQLUSER.EMRinstance.InstanceData v
WHERE ((v.ModifyDate = :paraAD AND v.ModifyTime >=:paraAT) 
OR(v.ModifyDate = :paraBD AND v.ModifyTime <=:paraBT) 
OR (v.ModifyDate>:paraAD AND v.ModifyDate <:paraBD))
}

/// d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLEmrUisWebService","SelectDateByDate","63472","31106","65472","31106")
Query SelectDateByTime(paraAD As %String, paraAT As %String, paraBD As %String, paraBT As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,ModifyDate:%String,ModifyTime:%String,EpisodeID:%String,TemplateID:%String,TemplateVersion:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_UisWebService_SelectDateByTime, SqlProc ]
{
SELECT v.ID,v.ModifyDate,v.ModifyTime,v.EpisodeID,v.TemplateID,v.TemplateVersion FROM SQLUSER.EMRinstance.InstanceData v
WHERE (v.ModifyDate = :paraAD AND v.ModifyTime >=:paraAT AND v.ModifyTime <=:paraBT)
}

/// d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLEmrUisWebService","SelectEprDateByDate","63472","31106","65472","31106")
Query SelectEprDateByDate(paraAD As %String, paraAT As %String, paraBD As %String, paraBT As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,ModifyDate:%String,ModifyTime:%String,EpisodeID:%String,TemplateID:%String,TemplateVersion:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_UisWebService_SelectEprDateByDate, SqlProc ]
{
SELECT v.ID,v.ModifyDate,v.ModifyTime,e.EpisodeID,v.TemplateID,v.TemplateVersion FROM SQLUSER.EPRinstance.InstanceData v
JOIN  SQLUSER.EPRinstance.ECRecord e  
ON v.TheECRecord = e.ID
WHERE ((v.ModifyDate = :paraAD AND v.ModifyTime >=:paraAT) 
OR(v.ModifyDate = :paraBD AND v.ModifyTime <=:paraBT) 
OR (v.ModifyDate>:paraAD AND v.ModifyDate <:paraBD))
AND (v.status <> 'UnSave')
}

/// d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLEmrUisWebService","SelectEprDateByDate","63472","31106","65472","31106")
Query SelectEprDateByTime(paraAD As %String, paraAT As %String, paraBD As %String, paraBT As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,ModifyDate:%String,ModifyTime:%String,EpisodeID:%String,TemplateID:%String,TemplateVersion:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_UisWebService_SelectEprDateByTime, SqlProc ]
{
SELECT v.ID,v.ModifyDate,v.ModifyTime,e.EpisodeID,v.TemplateID,v.TemplateVersion FROM SQLUSER.EPRinstance.InstanceData v
JOIN  SQLUSER.EPRinstance.ECRecord e  
ON v.TheECRecord = e.ID
WHERE (v.ModifyDate = :paraAD AND v.ModifyTime >=:paraAT AND v.ModifyTime <=:paraBT) AND (v.status <> 'UnSave')
}

/// d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLEmrUisWebService","SelectEprDateByDate","63472","31106","65472","31106")
Query SelectEprDateByID(AEpisodeID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,ModifyDate:%String,ModifyTime:%String,EpisodeID:%String,TemplateID:%String,TemplateVersion:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_UisWebService_SelectEprDateByID, SqlProc ]
{
SELECT v.ID,v.ModifyDate,v.ModifyTime,e.EpisodeID,v.TemplateID,v.TemplateVersion FROM SQLUSER.EPRinstance.InstanceData v
JOIN  SQLUSER.EPRinstance.ECRecord e  
ON v.TheECRecord = e.ID
WHERE (e.EpisodeID = :AEpisodeID) AND (v.status <> 'UnSave')
}

/// 获取模板数据结构
/// d ##Class(EMRservice.BL.BLEmrUisWebService).getEmrTemplates("2015-1-5 15:57:47","2015-2-28 15:57:47")
ClassMethod getEmrTemplates(paraA As %String, paraB As %String) As %ListOfObjects(ELEMENTTYPE="EMRservice.entity.EViewEMRTemplate")
{
	s retArray = ##Class(%ListOfObjects).%New()
	
	q:((paraA="")||(paraB="")) retArray
	s startD = ""
	s startT = ""
	s endD = ""
	s endT = ""
	if ((paraA [" ")&&(paraB[" "))
	{
		s startD = $ZDATEH($P(paraA," ",1),8)
		s startT = $ZTIMEH($P(paraA," ",2))
		s endD = $ZDATEH($P(paraB," ",1),8)
		s endT = $ZTIMEH($P(paraB," ",2))
	}
	q:((startD="")||(startT="")||(endD="")||(endT="")) retArray
	
	s result = ""
	if (startD = endD)
	{
		s result = ##class(%ResultSet).%New("EMRservice.BL.BLEmrUisWebService:SelectByTime")
	}
	else
	{
		s result = ##class(%ResultSet).%New("EMRservice.BL.BLEmrUisWebService:SelectByDate")
	}
	d result.Execute(startD,startT,endD,endT)
	q:(result = "")
	While result.Next() 
	{
		s objEmrTemplate =##Class(EMRservice.entity.EViewEMRTemplate).%New()
	 	s objEmrTemplate.TemplateVersionID = result.GetDataByName("ID")
	 	s CreateDate = result.GetDataByName("CreateDate")
	 	s CreateTime = result.GetDataByName("CreateTime")
	 	s objEmrTemplate.LastUpdateDateTime = $ZDATE(CreateDate,3) _" "_$ZTIME(CreateTime)
	 	s objEmrTemplate.TemplateID = result.GetDataByName("TemplateID")
	 	s objEmrTemplate.TemplateName = result.GetDataByName("Name")
	 	
	 	s objTemplateVersion = ##Class(EMRmeta.TemplateVersion).%OpenId(objEmrTemplate.TemplateVersionID)
    	q:(objTemplateVersion = "")
    	s objMetaData = ##class(%GlobalBinaryStream).%New()
    	d objMetaData.CopyFrom(objTemplateVersion.MetaData) 
    	
		s arrlist = ##Class(%ArrayOfDataTypes).%New()
		s ItemsSetD=##Class(%GlobalBinaryStream).%New()
    	s sc = ##class(%XML.TextReader).ParseStream(objMetaData,.reader)
    	continue:($$$ISERR(sc))
    	d reader.Rewind()
    	d ItemsSetD.Write("<root>")
    	d ..XMLDeserialize(reader,.ItemsSetD,arrlist,"False")
    	d ItemsSetD.Write("</root>")    	
		d reader.%OnClose()
    	d objEmrTemplate.ItemsSet.CopyFrom(ItemsSetD)
    	d retArray.Insert(objEmrTemplate)
    	
    	//导出为本地文件
    	;s streamTemplate=##Class(%GlobalBinaryStream).%New()
    	;d objEmrTemplate.XMLExportToStream(.streamTemplate)
    	;s strMeName = objEmrTemplate.TemplateName_objEmrTemplate.TemplateID
    	;d ..exPortToXml(objMetaData,objEmrTemplate.ItemsSet,strMeName)
	}
	q retArray
}

/// 获取模板数据结构
/// d ##Class(EMRservice.BL.BLEmrUisWebService).getEmrTemplateSimbs("2015-1-5 15:57:47","2015-2-28 15:57:47")
ClassMethod getEmrTemplateSimbs(paraA As %String, paraB As %String) As %ListOfObjects(ELEMENTTYPE="EMRservice.entity.EViewEMRTemplate")
{
	s retArray = ##Class(%ListOfObjects).%New()
	
	q:((paraA="")||(paraB="")) retArray
	s startD = ""
	s startT = ""
	s endD = ""
	s endT = ""
	if ((paraA [" ")&&(paraB[" "))
	{
		s startD = $ZDATEH($P(paraA," ",1),8)
		s startT = $ZTIMEH($P(paraA," ",2))
		s endD = $ZDATEH($P(paraB," ",1),8)
		s endT = $ZTIMEH($P(paraB," ",2))
	}
	q:((startD="")||(startT="")||(endD="")||(endT="")) retArray
	
	s result = ""
	if (startD = endD)
	{
		s result = ##class(%ResultSet).%New("EMRservice.BL.BLEmrUisWebService:SelectByTime")
	}
	else
	{
		s result = ##class(%ResultSet).%New("EMRservice.BL.BLEmrUisWebService:SelectByDate")
	}
	d result.Execute(startD,startT,endD,endT)
	q:(result = "")
	While result.Next() 
	{
		s objEmrTemplate =##Class(EMRservice.entity.EViewEMRTemplate).%New()
	 	s objEmrTemplate.TemplateVersionID = result.GetDataByName("ID")
	 	s CreateDate = result.GetDataByName("CreateDate")
	 	s CreateTime = result.GetDataByName("CreateTime")
	 	s objEmrTemplate.LastUpdateDateTime = $ZDATE(CreateDate,3) _" "_$ZTIME(CreateTime)
	 	s objEmrTemplate.TemplateID = result.GetDataByName("TemplateID")
	 	s objEmrTemplate.TemplateName = result.GetDataByName("Name")
	 	
	 	s objTemplateVersion = ##Class(EMRmeta.TemplateVersion).%OpenId(objEmrTemplate.TemplateVersionID)
    	q:(objTemplateVersion = "")
    	s objMetaData = ##class(%GlobalBinaryStream).%New()
    	d objMetaData.CopyFrom(objTemplateVersion.MetaData) 
    	
		s arrlist = ##Class(%ArrayOfDataTypes).%New()
		s ItemsSetD=##Class(%GlobalBinaryStream).%New()
    	s sc = ##class(%XML.TextReader).ParseStream(objMetaData,.reader)
    	continue:($$$ISERR(sc))
    	d reader.Rewind()
    	d ItemsSetD.Write("<root>")
    	d ..XMLDeserialize(.reader,.ItemsSetD,.arrlist,"True")
    	d ItemsSetD.Write("</root>")    	

    	d objEmrTemplate.ItemsSet.CopyFrom(ItemsSetD)
    	d retArray.Insert(objEmrTemplate)
    	
    	//导出为本地文件
    	;s streamTemplate=##Class(%GlobalBinaryStream).%New()
    	;d objEmrTemplate.XMLExportToStream(.streamTemplate)
    	;s strMeName = objEmrTemplate.TemplateName_objEmrTemplate.TemplateID
    	;d ..exPortToXml(objMetaData,objEmrTemplate.ItemsSet,strMeName)
	}
	q retArray
}

/// 获取模板数据结构
/// w ##Class(EMRservice.BL.BLEmrUisWebService).getEmrDocs("2015-6-4 15:57:47","2015-6-6 15:57:47")
ClassMethod getEmrDocs(paraA As %String, paraB As %String) As %ListOfObjects(ELEMENTTYPE="EMRservice.entity.EViewEMRDoc")
{
	s retArray = ##Class(%ListOfObjects).%New()
	
	q:((paraA="")||(paraB="")) retArray
	s startD = ""
	s startT = ""
	s endD = ""
	s endT = ""
	if ((paraA [" ")&&(paraB[" "))
	{
		s startD = $ZDATEH($P(paraA," ",1),8)
		s startT = $ZTIMEH($P(paraA," ",2))
		s endD = $ZDATEH($P(paraB," ",1),8)
		s endT = $ZTIMEH($P(paraB," ",2))
	}
	q:((startD="")||(startT="")||(endD="")||(endT="")) retArray
	
	s result = ""
	if (startD = endD)
	{
		s result = ##class(%ResultSet).%New("EMRservice.BL.BLEmrUisWebService:SelectDateByTime")
	}
	else
	{
		s result = ##class(%ResultSet).%New("EMRservice.BL.BLEmrUisWebService:SelectDateByDate")
	}
	d result.Execute(startD,startT,endD,endT)
	q:(result = "")
	While result.Next() 
	{
		s objEMRDoc =##Class(EMRservice.entity.EViewEMRDoc).%New()
	 	s objEMRDoc.InstanceDataID = result.GetDataByName("ID")
	 	s ModifyDate = result.GetDataByName("ModifyDate")
	 	s ModifyTime = result.GetDataByName("ModifyTime")
	 	s objEMRDoc.LastUpdateDateTime = $ZDATE(ModifyDate,3) _" "_$ZTIME(ModifyTime)
	 	s objEMRDoc.TemplateID = result.GetDataByName("TemplateID")
	 	s objEMRDoc.TemplateVersionID = result.GetDataByName("TemplateVersion")
	 	s EpisodeID = result.GetDataByName("EpisodeID")
	 	s emrTemID = $o(^DHCEMRM.EMRTemplateI("IdxBindTemplateID"," "_objEMRDoc.TemplateID,""))
	 	q:(emrTemID="")
	 	s objEmrTemp = ##Class(EMRmeta.EMRTemplate).%OpenId(emrTemID)
	 	q:(objEmrTemp="")
	 	s objEMRDoc.DocID = objEmrTemp.CategoryID
	 	s objEMRDoc.DocName = objEmrTemp.TemplateName
	 	s objEmrTempCat = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objEmrTemp.CategoryID)
	 	s objEMRDoc.FatherDocName = objEmrTempCat.CategoryName
	 	s objEMRDoc.VisitNumber =EpisodeID
	 	s objEMRDoc.PatientID=##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
	 	s objEMRDoc.PatientName=##class(EMRservice.HISInterface.PatientInfoAssist).Name(objEMRDoc.PatientID)
	 	s objEMRDoc.MRN = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetEpisodeNo(EpisodeID)
	 	
	 	s objInstanceData = ##Class(EMRinstance.InstanceData).%OpenId(objEMRDoc.InstanceDataID)
    	q:(objInstanceData = "")
    	s objMetaData = ##class(%GlobalBinaryStream).%New()
    	d objMetaData.CopyFrom(objInstanceData.InstanceData)
    	
    	s arrlist = ##Class(%ArrayOfDataTypes).%New()
    	s metaSet=##Class(%GlobalBinaryStream).%New()
    	s sc = ##class(%XML.TextReader).ParseStream(objInstanceData.InstanceMetaData,.reader)
    	q:($$$ISERR(sc))
    	d reader.Rewind()
    	d ..XMLDeserialize(reader,metaSet,arrlist,"False")
		
		s ItemsSet=##Class(%GlobalBinaryStream).%New()
    	d ItemsSet.Write("<root>")
    	s rowSecID = ""
    	for
    	{
	    	s rowSecID = $o(^DHCEMRI.ISectionDescI("IdxForUpdate"," "_objEMRDoc.InstanceDataID,rowSecID))
			q:(rowSecID = "")
			s rowID = ""
			for
			{
				s rowID = $o(^DHCEMRI.ISectionDescI("IdxForUpdate"," "_objEMRDoc.InstanceDataID,rowSecID,rowID))
				q:(rowID = "")
				s objSection = ##Class(EMRinstance.ISectionDesc).%OpenId(rowID)
				q:(objSection ="")
				s displayName = arrlist.GetAt(objSection.SectionCode)
				s strText = objSection.Text.Read(32000)
				s strText = $zcvt(strText,"O","XML")
		    	s strItem = "<Item ItemID="""_objSection.SectionCode_""" ItemName="""_displayName_""" ItemValue="""_strText_"""></Item>"
				s strItem = $zcvt(strItem,"O","UTF8")  
				d ItemsSet.Write(strItem)
				
			}
    	}
    	d ItemsSet.Write("</root>")
    	d objEMRDoc.ItemValueSet.CopyFrom(ItemsSet)
    	w objEMRDoc.InstanceDataID
    	d retArray.Insert(objEMRDoc)
    	
    	//导出为本地文件
    	;s streamTemplate=##Class(%GlobalBinaryStream).%New()
    	;d objEMRDoc.XMLExportToStream(.streamTemplate)
    	;s strMeName = objInstanceData.Title_objInstanceData.TemplateID
    	;d ..exPortToXml(objMetaData,objEMRDoc.ItemValueSet,strMeName)
	}
	q retArray
}

/// 获取模板数据结构
/// w ##Class(EMRservice.BL.BLEmrUisWebService).getEmrDocsSimbs("2015-6-4 15:57:47","2015-6-6 15:57:47")
ClassMethod getEmrDocsSimbs(paraA As %String, paraB As %String) As %ListOfObjects(ELEMENTTYPE="EMRservice.entity.EViewEMRDoc")
{
	s retArray = ##Class(%ListOfObjects).%New()
	
	q:((paraA="")||(paraB="")) retArray
	s startD = ""
	s startT = ""
	s endD = ""
	s endT = ""
	if ((paraA [" ")&&(paraB[" "))
	{
		s startD = $ZDATEH($P(paraA," ",1),8)
		s startT = $ZTIMEH($P(paraA," ",2))
		s endD = $ZDATEH($P(paraB," ",1),8)
		s endT = $ZTIMEH($P(paraB," ",2))
	}
	q:((startD="")||(startT="")||(endD="")||(endT="")) retArray
	
	s result = ""
	if (startD = endD)
	{
		s result = ##class(%ResultSet).%New("EMRservice.BL.BLEmrUisWebService:SelectDateByTime")
	}
	else
	{
		s result = ##class(%ResultSet).%New("EMRservice.BL.BLEmrUisWebService:SelectDateByDate")
	}

	d result.Execute(startD,startT,endD,endT)
	q:(result = "")
	While result.Next() 
	{
		s objEMRDoc =##Class(EMRservice.entity.EViewEMRDoc).%New()
	 	s objEMRDoc.InstanceDataID = result.GetDataByName("ID")
	 	s ModifyDate = result.GetDataByName("ModifyDate")
	 	s ModifyTime = result.GetDataByName("ModifyTime")
	 	s objEMRDoc.LastUpdateDateTime = $ZDATE(ModifyDate,3) _" "_$ZTIME(ModifyTime)
	 	s objEMRDoc.TemplateID = result.GetDataByName("TemplateID")
	 	s objEMRDoc.TemplateVersionID = result.GetDataByName("TemplateVersion")
	 	s EpisodeID = result.GetDataByName("EpisodeID")
	 	s emrTemID = $o(^DHCEMRM.EMRTemplateI("IdxBindTemplateID"," "_objEMRDoc.TemplateID,""))
	 	q:(emrTemID="")
	 	s objEmrTemp = ##Class(EMRmeta.EMRTemplate).%OpenId(emrTemID)
	 	q:(objEmrTemp="")
	 	s objEMRDoc.DocID = objEmrTemp.CategoryID
	 	s objEMRDoc.DocName = objEmrTemp.TemplateName
	 	s objEmrTempCat = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objEmrTemp.CategoryID)
	 	s objEMRDoc.FatherDocName = objEmrTempCat.CategoryName
	 	s objEMRDoc.VisitNumber =EpisodeID
	 	s objEMRDoc.PatientID=##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
	 	s objEMRDoc.PatientName=##class(EMRservice.HISInterface.PatientInfoAssist).Name(objEMRDoc.PatientID)
	 	s objEMRDoc.MRN = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetEpisodeNo(EpisodeID)
	 	
	 	s objInstanceData = ##Class(EMRinstance.InstanceData).%OpenId(objEMRDoc.InstanceDataID)
    	q:(objInstanceData = "")
    	s objMetaData = ##class(%GlobalBinaryStream).%New()
    	d objMetaData.CopyFrom(objInstanceData.InstanceData)
    	
    	s arrlist = ##Class(%ArrayOfDataTypes).%New()
    	s metaSet=##Class(%GlobalBinaryStream).%New()
    	s sc = ##class(%XML.TextReader).ParseStream(objInstanceData.InstanceMetaData,.reader)
    	q:($$$ISERR(sc))
    	d reader.Rewind()
    	d ..XMLDeserialize(reader,metaSet,arrlist,"True")
		
		s ItemsSet=##Class(%GlobalBinaryStream).%New()
    	d ItemsSet.Write("<root>")
    	s rowSecID = ""
    	for
    	{
	    	s rowSecID = $o(^DHCEMRI.ISectionDescI("IdxForUpdate"," "_objEMRDoc.InstanceDataID,rowSecID))
			q:(rowSecID = "")
			s rowID = ""
			for
			{
				s rowID = $o(^DHCEMRI.ISectionDescI("IdxForUpdate"," "_objEMRDoc.InstanceDataID,rowSecID,rowID))
				q:(rowID = "")
				s objSection = ##Class(EMRinstance.ISectionDesc).%OpenId(rowID)
				q:(objSection ="")
				s displayName = arrlist.GetAt(objSection.SectionCode)
				s strText = objSection.Text.Read(32000)
				s strText = $zcvt(strText,"O","XML")
		    	s strItem = "<Section SectionID="""_objSection.SectionCode_""" SectionName="""_displayName_""" SectionValue="""_strText_""">"
				s strItem = $zcvt(strItem,"O","UTF8")  
				d ItemsSet.Write(strItem)
				s rowComID = ""
		    	for
		    	{
			    	s rowComID = $o(^DHCEMRI.ICompositeSimpleI("IdxForUpdate"," "_objEMRDoc.InstanceDataID," "_objSection.SectionCode,rowComID))
					q:(rowComID = "")
					s rowSimCode = ""
					for
					{
						s rowSimCode = $o(^DHCEMRI.ICompositeSimpleI("IdxForUpdate"," "_objEMRDoc.InstanceDataID," "_objSection.SectionCode,rowComID,rowSimCode))
						q:(rowSimCode = "")
						s rowSimID = ""
						for
						{
							s rowSimID = $o(^DHCEMRI.ICompositeSimpleI("IdxForUpdate"," "_objEMRDoc.InstanceDataID," "_objSection.SectionCode,rowComID,rowSimCode,rowSimID))
							q:(rowSimID = "")
							s objSimple = ##Class(EMRinstance.ICompositeSimple).%OpenId(rowSimID)
							q:(objSimple ="")
							s displayName = arrlist.GetAt(objSimple.SimpleItemCode)
					    	s strItem = "<Item ItemID="""_objSimple.SimpleItemCode_""" ItemName="""_displayName_""" ItemValue="""_objSimple.DataValue_""" ItemDataType="""_objSimple.Type_"""></Item>"
							s strItem = $zcvt(strItem,"O","UTF8")  
							d ItemsSet.Write(strItem)
						}
					}
		    	}
				s strItem = "</Section>"
				d ItemsSet.Write(strItem)
			}
    	}
    	d ItemsSet.Write("</root>")
    	d objEMRDoc.ItemValueSet.CopyFrom(ItemsSet)
    	
    	d retArray.Insert(objEMRDoc)
    	
    	//导出为本地文件
    	;s streamTemplate=##Class(%GlobalBinaryStream).%New()
    	;d objEMRDoc.XMLExportToStream(.streamTemplate)
    	;s strMeName = objInstanceData.Title_objInstanceData.TemplateID
    	;d ..exPortToXml(objMetaData,objEMRDoc.ItemValueSet,strMeName)
	}
	q retArray
}

/// 获取模板数据结构
/// d ##Class(EMRservice.BL.BLEmrUisWebService).getEprTemplates("2014-1-6 15:57:47","2014-7-29 15:57:47")
ClassMethod getEprTemplates(paraA As %String, paraB As %String) As %ListOfObjects(ELEMENTTYPE="EMRservice.entity.EViewEMRTemplate")
{
	s retArray = ##Class(%ListOfObjects).%New()
	
	q:((paraA="")||(paraB="")) retArray
	s startD = ""
	s startT = ""
	s endD = ""
	s endT = ""
	if ((paraA [" ")&&(paraB[" "))
	{
		s startD = $ZDATEH($P(paraA," ",1),8)
		s startT = $ZTIMEH($P(paraA," ",2))
		s endD = $ZDATEH($P(paraB," ",1),8)
		s endT = $ZTIMEH($P(paraB," ",2))
	}
	q:((startD="")||(startT="")||(endD="")||(endT="")) retArray
	
	s result = ""
	if (startD = endD)
	{
		s result = ##class(%ResultSet).%New("EMRservice.BL.BLEmrUisWebService:SelectEprByDate")
	}
	else
	{
		s result = ##class(%ResultSet).%New("EMRservice.BL.BLEmrUisWebService:SelectEprByTime")
	}
	d result.Execute(startD,startT,endD,endT)
	q:(result = "")
	While result.Next() 
	{
		s objEmrTemplate =##Class(EMRservice.entity.EViewEMRTemplate).%New()
	 	s objEmrTemplate.TemplateVersionID = result.GetDataByName("ID")
	 	s CreateDate = result.GetDataByName("CreateDate")
	 	s CreateTime = result.GetDataByName("CreateTime")
	 	s objEmrTemplate.LastUpdateDateTime = $ZDATE(CreateDate,3) _" "_$ZTIME(CreateTime)
	 	s objEmrTemplate.TemplateID = result.GetDataByName("TemplateID")
	 	s objEmrTemplate.TemplateName = result.GetDataByName("Name")
	 	
	 	s objTemplateVersion = ##Class(EPRmeta.TemplateVersion).%OpenId(objEmrTemplate.TemplateVersionID)
    	q:(objTemplateVersion = "")
    	s objMetaData = ##class(%GlobalCharacterStream).%New()
    	d objMetaData.CopyFrom(objTemplateVersion.MetaData) 
    	
		s arrlist = ##Class(%ArrayOfDataTypes).%New()
		s ItemsSet=##Class(%GlobalCharacterStream).%New()
    	s sc = ##class(%XML.TextReader).ParseStream(objMetaData,.eprreader)
    	continue:($$$ISERR(sc))
    	d eprreader.Rewind()
    	d ItemsSet.Write("<root>")
    	d ..XMLEprDeserialize(eprreader,ItemsSet,arrlist)
    	d ItemsSet.Write("</root>")
    	d objEmrTemplate.ItemsSet.CopyFrom(ItemsSet)
    	
    	d retArray.Insert(objEmrTemplate)
    	
    	//导出为本地文件
    	;s streamTemplate=##Class(%GlobalBinaryStream).%New()
    	;d objEmrTemplate.XMLExportToStream(.streamTemplate)
    	;s strMeName = objEmrTemplate.TemplateName_objEmrTemplate.TemplateID
    	;d ..exPortToXml(objMetaData,objEmrTemplate.ItemsSet,strMeName)
    	
	}
	q retArray
}

/// 获取模板数据结构
/// w ##Class(EMRservice.BL.BLEmrUisWebService).getEprDocs("2015-5-8 9:23:41","2015-6-5 15:40:11")
ClassMethod getEprDocs(paraA As %String, paraB As %String) As %ListOfObjects(ELEMENTTYPE="EMRservice.entity.EViewEMRDoc")
{
	s retArray = ##Class(%ListOfObjects).%New()
	
	q:((paraA="")||(paraB="")) retArray
	s startD = ""
	s startT = ""
	s endD = ""
	s endT = ""
	if ((paraA [" ")&&(paraB[" "))
	{
		s startD = $ZDATEH($P(paraA," ",1),8)
		s startT = $ZTIMEH($P(paraA," ",2))
		s endD = $ZDATEH($P(paraB," ",1),8)
		s endT = $ZTIMEH($P(paraB," ",2))
	}
	q:((startD="")||(startT="")||(endD="")||(endT="")) retArray
	
	s result = ""
	if (startD = endD)
	{
		s result = ##class(%ResultSet).%New("EMRservice.BL.BLEmrUisWebService:SelectEprDateByTime")
	}
	else
	{
		s result = ##class(%ResultSet).%New("EMRservice.BL.BLEmrUisWebService:SelectEprDateByDate")
	}
	d result.Execute(startD,startT,endD,endT)
	q:(result = "")
	While result.Next() 
	{
		s objEMRDoc =##Class(EMRservice.entity.EViewEMRDoc).%New()
	 	s objEMRDoc.InstanceDataID = result.GetDataByName("ID")
	 	s ModifyDate = result.GetDataByName("ModifyDate")
	 	s ModifyTime = result.GetDataByName("ModifyTime")
	 	s objEMRDoc.LastUpdateDateTime = $ZDATE(ModifyDate,3) _" "_$ZTIME(ModifyTime)
	 	s objEMRDoc.TemplateID = result.GetDataByName("TemplateID")
	 	s objEMRDoc.TemplateVersionID = result.GetDataByName("TemplateVersion")
	 	s EpisodeID = result.GetDataByName("EpisodeID")
	 	s emrTemID = $o(^DHCEPRM.EPRTemplateI("IdxBindTemplateID"," "_objEMRDoc.TemplateID,""))
	 	continue:(emrTemID="")
	 	s objEmrTemp = ##Class(EPRmeta.EPRTemplate).%OpenId(emrTemID)
	 	q:(objEmrTemp="")
	 	s objEMRDoc.DocID = objEmrTemp.EPRCategoryID
	 	s objEMRDoc.DocName = objEmrTemp.EPRTemplateName
	 	s objEmrTempCat = ##Class(EPRmeta.EPRTemplateCategory).%OpenId(objEmrTemp.EPRCategoryID)
	 	s objEMRDoc.FatherDocName = objEmrTempCat.CategoryName
	 	s objEMRDoc.VisitNumber =EpisodeID
	 	s objEMRDoc.PatientID=##class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
	 	s objEMRDoc.PatientName=##class(EPRservice.HISInterface.PatientInfoAssist).Name(objEMRDoc.PatientID)
	 	s objEMRDoc.MRN = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetEpisodeNo(EpisodeID)
	 	
	 	s objMetaData = ##class(%GlobalCharacterStream).%New()
		s objMetaData = ##Class(EPRmeta.TemplateVersion).GetMetaData(objEMRDoc.TemplateID,objEMRDoc.TemplateVersionID)
    	;d objMetaData.CopyFrom(objTemplateVersion.MetaData) 
    	
		s arrlist = ##Class(%ArrayOfDataTypes).%New()
		s metaSet=##Class(%GlobalCharacterStream).%New()
    	s sc = ##class(%XML.TextReader).ParseStream(objMetaData,.eprreader)
    	continue:($$$ISERR(sc))
    	d eprreader.Rewind()
    	d ..XMLEprDeserialize(eprreader,metaSet,arrlist)

		s ItemsSet=##Class(%GlobalBinaryStream).%New()
    	d ItemsSet.Write("<root>")
    	s rowSimCodID = ""
    	for
    	{
	    	s rowSimCodID = $o(^DHCEPRI.ISimpleI("IdxForUpdate"," "_objEMRDoc.InstanceDataID,rowSimCodID))
			q:(rowSimCodID = "")
			s rowID = ""
			for
			{
				s rowID = $o(^DHCEPRI.ISimpleI("IdxForUpdate"," "_objEMRDoc.InstanceDataID,rowSimCodID,rowID))
				q:(rowID = "")
				s objSimp = ##Class(EPRinstance.ISimple).%OpenId(rowID)
				q:(objSimp ="")
				s displayName = arrlist.GetAt(objSimp.SimpleItemCode)
				s strValue = objSimp.DataValue
		    	s strItem = "<Item ItemID="""_objSimp.SimpleItemCode_""" ItemName="""_displayName_""" ItemValue="""_strValue_"""></Item>"
				;s strItem = $zcvt(strItem,"O","UTF8")  
				d ItemsSet.Write(strItem)
			}
    	}
    	s rowSegmID = ""
    	for
    	{
	    	s rowSegmID = $o(^DHCEPRI.ISegmentI("IdxForUpdate"," "_objEMRDoc.InstanceDataID,rowSegmID))
			q:(rowSegmID = "")
			s rowID = ""
			for
			{
				s rowID = $o(^DHCEPRI.ISegmentI("IdxForUpdate"," "_objEMRDoc.InstanceDataID,rowSegmID,rowID))
				q:(rowID = "")
				s objSegm = ##Class(EPRinstance.ISegment).%OpenId(rowID)
				q:(objSegm ="")
				s displayName = arrlist.GetAt(objSegm.SegmentCode)
				s strText = objSegm.Text.Read(32000)
				s strText = $zcvt(strText,"O","XML")
		    	s strItem = "<Item ItemID="""_objSegm.SegmentCode_""" ItemName="""_displayName_""" ItemValue="""_strText_"""></Item>"
				;s strItem = $zcvt(strItem,"O","UTF8")  
				d ItemsSet.Write(strItem)
			}
    	}
    	s rowTextDID = ""
    	for
    	{
	    	s rowTextDID = $o(^DHCEPRI.ITextDescI("IdxForUpdate"," "_objEMRDoc.InstanceDataID,rowTextDID))
			q:(rowTextDID = "")
			s rowID = ""
			for
			{
				s rowID = $o(^DHCEPRI.ITextDescI("IdxForUpdate"," "_objEMRDoc.InstanceDataID,rowTextDID,rowID))
				q:(rowID = "")
				s objTextD = ##Class(EPRinstance.ITextDesc).%OpenId(rowID)
				q:(objTextD ="")
				s displayName = arrlist.GetAt(objTextD.TextDescCode)
				s strText = objTextD.Text.Read(32000)
				s strText = $zcvt(strText,"O","XML")
		    	s strItem = "<Item ItemID="""_objTextD.TextDescCode_""" ItemName="""_displayName_""" ItemValue="""_strText_"""></Item>"
				;s strItem = $zcvt(strItem,"O","UTF8")  
				d ItemsSet.Write(strItem)
			}
    	}
    	d ItemsSet.Write("</root>")
    	d objEMRDoc.ItemValueSet.CopyFrom(ItemsSet)
    	
    	d retArray.Insert(objEMRDoc)
    	
    	//导出为本地文件
    	;s streamTemplate=##Class(%GlobalBinaryStream).%New()
    	;d objEMRDoc.XMLExportToStream(.streamTemplate)
    	;s strMeName ="InstanceData"_ objEMRDoc.DocName_objEMRDoc.TemplateID
    	;d ..exPortToXml(objMetaData,objEMRDoc.ItemValueSet,strMeName)
    	;q
	}
	q retArray
}

/// 获取模板数据结构
/// w ##Class(EMRservice.BL.BLEmrUisWebService).getEprDocs("2015-5-8 9:23:41","2015-6-5 15:40:11")
ClassMethod getEprDocsByID(AEpisodeID As %String) As %ListOfObjects(ELEMENTTYPE="EMRservice.entity.EViewEMRDoc")
{
	s retArray = ##Class(%ListOfObjects).%New()
	
	q:(AEpisodeID="") retArray

	s result = ""
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLEmrUisWebService:SelectEprDateByID")
	
	d result.Execute(AEpisodeID)
	q:(result = "")
	While result.Next() 
	{
		s objEMRDoc =##Class(EMRservice.entity.EViewEMRDoc).%New()
	 	s objEMRDoc.InstanceDataID = result.GetDataByName("ID")
	 	s ModifyDate = result.GetDataByName("ModifyDate")
	 	s ModifyTime = result.GetDataByName("ModifyTime")
	 	s objEMRDoc.LastUpdateDateTime = $ZDATE(ModifyDate,3) _" "_$ZTIME(ModifyTime)
	 	s objEMRDoc.TemplateID = result.GetDataByName("TemplateID")
	 	s objEMRDoc.TemplateVersionID = result.GetDataByName("TemplateVersion")
	 	s EpisodeID = result.GetDataByName("EpisodeID")
	 	s emrTemID = $o(^DHCEPRM.EPRTemplateI("IdxBindTemplateID"," "_objEMRDoc.TemplateID,""))
	 	continue:(emrTemID="")
	 	s objEmrTemp = ##Class(EPRmeta.EPRTemplate).%OpenId(emrTemID)
	 	q:(objEmrTemp="")
	 	s objEMRDoc.DocID = objEmrTemp.EPRCategoryID
	 	s objEMRDoc.DocName = objEmrTemp.EPRTemplateName
	 	s objEmrTempCat = ##Class(EPRmeta.EPRTemplateCategory).%OpenId(objEmrTemp.EPRCategoryID)
	 	s objEMRDoc.FatherDocName = objEmrTempCat.CategoryName
	 	s objEMRDoc.VisitNumber =EpisodeID
	 	s objEMRDoc.PatientID=##class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
	 	s objEMRDoc.PatientName=##class(EPRservice.HISInterface.PatientInfoAssist).Name(objEMRDoc.PatientID)
	 	s objEMRDoc.MRN = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetEpisodeNo(EpisodeID)
	 	
	 	s objMetaData = ##class(%GlobalCharacterStream).%New()
		s objMetaData = ##Class(EPRmeta.TemplateVersion).GetMetaData(objEMRDoc.TemplateID,objEMRDoc.TemplateVersionID)
    	;d objMetaData.CopyFrom(objTemplateVersion.MetaData) 
    	
		s arrlist = ##Class(%ArrayOfDataTypes).%New()
		s metaSet=##Class(%GlobalCharacterStream).%New()
    	s sc = ##class(%XML.TextReader).ParseStream(objMetaData,.eprreader)
    	continue:($$$ISERR(sc))
    	d eprreader.Rewind()
    	d ..XMLEprDeserialize(eprreader,metaSet,arrlist)

		s ItemsSet=##Class(%GlobalBinaryStream).%New()
    	d ItemsSet.Write("<root>")
    	s rowSimCodID = ""
    	for
    	{
	    	s rowSimCodID = $o(^DHCEPRI.ISimpleI("IdxForUpdate"," "_objEMRDoc.InstanceDataID,rowSimCodID))
			q:(rowSimCodID = "")
			s rowID = ""
			for
			{
				s rowID = $o(^DHCEPRI.ISimpleI("IdxForUpdate"," "_objEMRDoc.InstanceDataID,rowSimCodID,rowID))
				q:(rowID = "")
				s objSimp = ##Class(EPRinstance.ISimple).%OpenId(rowID)
				q:(objSimp ="")
				s displayName = arrlist.GetAt(objSimp.SimpleItemCode)
				s strValue = objSimp.DataValue
		    	s strItem = "<Item ItemID="""_objSimp.SimpleItemCode_""" ItemName="""_displayName_""" ItemValue="""_strValue_"""></Item>"
				;s strItem = $zcvt(strItem,"O","UTF8")  
				d ItemsSet.Write(strItem)
			}
    	}
    	s rowSegmID = ""
    	for
    	{
	    	s rowSegmID = $o(^DHCEPRI.ISegmentI("IdxForUpdate"," "_objEMRDoc.InstanceDataID,rowSegmID))
			q:(rowSegmID = "")
			s rowID = ""
			for
			{
				s rowID = $o(^DHCEPRI.ISegmentI("IdxForUpdate"," "_objEMRDoc.InstanceDataID,rowSegmID,rowID))
				q:(rowID = "")
				s objSegm = ##Class(EPRinstance.ISegment).%OpenId(rowID)
				q:(objSegm ="")
				s displayName = arrlist.GetAt(objSegm.SegmentCode)
				s strText = objSegm.Text.Read(32000)
				s strText = $zcvt(strText,"O","XML")
		    	s strItem = "<Item ItemID="""_objSegm.SegmentCode_""" ItemName="""_displayName_""" ItemValue="""_strText_"""></Item>"
				;s strItem = $zcvt(strItem,"O","UTF8")  
				d ItemsSet.Write(strItem)
			}
    	}
    	s rowTextDID = ""
    	for
    	{
	    	s rowTextDID = $o(^DHCEPRI.ITextDescI("IdxForUpdate"," "_objEMRDoc.InstanceDataID,rowTextDID))
			q:(rowTextDID = "")
			s rowID = ""
			for
			{
				s rowID = $o(^DHCEPRI.ITextDescI("IdxForUpdate"," "_objEMRDoc.InstanceDataID,rowTextDID,rowID))
				q:(rowID = "")
				s objTextD = ##Class(EPRinstance.ITextDesc).%OpenId(rowID)
				q:(objTextD ="")
				s displayName = arrlist.GetAt(objTextD.TextDescCode)
				s strText = objTextD.Text.Read(32000)
				s strText = $zcvt(strText,"O","XML")
		    	s strItem = "<Item ItemID="""_objTextD.TextDescCode_""" ItemName="""_displayName_""" ItemValue="""_strText_"""></Item>"
				;s strItem = $zcvt(strItem,"O","UTF8")  
				d ItemsSet.Write(strItem)
			}
    	}
    	d ItemsSet.Write("</root>")
    	d objEMRDoc.ItemValueSet.CopyFrom(ItemsSet)
    	
    	d retArray.Insert(objEMRDoc)
    	
    	//导出为本地文件
    	;s streamTemplate=##Class(%GlobalBinaryStream).%New()
    	;d objEMRDoc.XMLExportToStream(.streamTemplate)
    	;s strMeName ="InstanceData"_ objEMRDoc.DocName_objEMRDoc.TemplateID
    	;d ..exPortToXml(objMetaData,objEMRDoc.ItemValueSet,strMeName)
    	;q
	}
	q retArray
}

ClassMethod XMLDeserialize(ByRef reader As %XML.TextReader, ByRef ItemsSet As %GlobalBinaryStream, ByRef arrlist As %ArrayOfDataTypes, ByRef blnMark As %String)
{
	while reader.Read()
	{
		if ((reader.Name="Component") && (reader.NodeType = "element"))
		{
			while reader.Read()
			{
				q:((reader.Name = "Component")&&(reader.NodeType = "endelement"))
				if ((reader.Name = "Section")&&(reader.NodeType = "element"))
				{
					d ..XMLSecDeserialize(reader,ItemsSet,arrlist,blnMark)
				}
				
			}
		}
		q:((reader.Name = "MetaData")&&(reader.NodeType = "endelement"))
	}
}

ClassMethod XMLSecDeserialize(ByRef reader As %XML.TextReader, ByRef ItemsSet As %GlobalBinaryStream, ByRef arrlist As %ArrayOfDataTypes, ByRef blnMark As %String)
{
	s TypeName  = "" ;
	s Code = ""
	s DisplayName = ""
	while reader.Read()
	{
		if ((reader.Name = "Section")&&(reader.NodeType = "endelement"))
		{
			s strItem = "</Section>"
			d ItemsSet.Write(strItem)
			q
		}
		if ((reader.Name = "Code") && (reader.NodeType = "element"))
		{

			if (reader.MoveToAttributeName("Code")) s Code = reader.Value
			if (reader.MoveToAttributeName("DisplayName")) s DisplayName = reader.Value
			s strItem = "<Section SectionID="""_Code_""" SectionName="""_DisplayName_""">"
			S strItem = $zcvt(strItem,"O","UTF8") 
			d ItemsSet.Write(strItem)
			d arrlist.SetAt(DisplayName,Code)
		}
		elseif ((reader.Name = "Component")&&(reader.NodeType = "element"))
		{
			while reader.Read()
			{
				q:((reader.Name = "Component")&&(reader.NodeType = "endelement"))
				if ((reader.Name = "Section")&&(reader.NodeType = "element"))
				{
					d ..XMLSecDeserialize(reader,ItemsSet,arrlist,blnMark)
				}
				
			}
		}
		elseif ((reader.Name  = "Composite")&&(reader.NodeType = "element"))
		{
			if (blnMark = "True")
			{
				while reader.Read()
				{
					q:((reader.Name = "Composite") && (reader.NodeType = "endelement"))
					if ((reader.Name = "SubItems") && (reader.NodeType = "element"))
					{
						d ..XMLSubItemDeserialize(reader,ItemsSet,arrlist)
					}
				}
			}
			else
			{
				q
			}
		}
	}
}

ClassMethod XMLSubItemDeserialize(ByRef reader As %XML.TextReader, ByRef ItemsSet As %GlobalBinaryStream, ByRef arrlist As %ArrayOfDataTypes)
{
	while reader.Read()
	{
		q:((reader.Name = "SubItems") && (reader.NodeType = "endelement"))
		
		if (((reader.Name = "MIString")||(reader.Name = "MINumber")
		||(reader.Name = "MIDateTime")||(reader.Name = "MIMonoChoice")
		||(reader.Name = "MIMultiChoice")||(reader.Name = "MIDictionary")
		||(reader.Name = "MILink"))&& (reader.NodeType = "element"))
		{
			s TypeName = reader.Name
			s Code = ""
			s DisplayName = ""
			while reader.Read()
			{
				if ((reader.Name = "Code") && (reader.NodeType = "element"))
				{
					if (reader.Read())
		    		{
						;if (reader.MoveToAttributeName("Code")) s Code = reader.Value
						s Code =reader.Value
		    		}
				}
				elseif((reader.Name  = "DisplayName") && (reader.NodeType = "element"))
				{
					if reader.Read() 
		    		{
						s DisplayName =reader.Value
					}
				}
				q:(((reader.Name = "MIString")||(reader.Name = "MINumber")
				||(reader.Name = "MIDateTime")||(reader.Name = "MIMonoChoice")
				||(reader.Name = "MIMultiChoice")||(reader.Name = "MIDictionary")
				||(reader.Name = "MILink"))&&(reader.NodeType = "endelement"))
			}	
			s strItem = "<Item ItemID="""_Code_""" ItemName="""_DisplayName_""" ItemDataType="""_TypeName_"""></Item>"
			S strItem = $zcvt(strItem,"O","UTF8") 
			d ItemsSet.Write(strItem)
			d arrlist.SetAt(DisplayName,Code)
		}

	}
}

ClassMethod XMLEprDeserialize(ByRef reader As %XML.TextReader, ByRef ItemsSet As %GlobalBinaryStream, ByRef arrlist As %ArrayOfDataTypes)
{
	while reader.Read()
	{
		if ((reader.Name="MMetaData") && (reader.NodeType = "element"))
		{
			while reader.Read()
			{
				q:((reader.Name = "SubItems")&&(reader.NodeType = "endelement"))
				if ((reader.Name = "SubItems")&&(reader.NodeType = "element"))
				{
					
					d ..XMLEprItemsDeserialize(reader,ItemsSet,arrlist)
				}
				
			}
		}
		q:((reader.Name = "MMetaData")&&(reader.NodeType = "endelement"))
	}
}

ClassMethod XMLEprItemsDeserialize(ByRef reader As %XML.TextReader, ByRef ItemsSet As %GlobalBinaryStream, ByRef arrlist As %ArrayOfDataTypes)
{
	while reader.Read()
	{
		if (((reader.Name = "MIString")||(reader.Name = "MINumber")
		||(reader.Name = "MIDateTime")||(reader.Name = "MIMonoChoice")
		||(reader.Name = "MIMultiChoice")||(reader.Name = "MIDictionary")
		||(reader.Name = "MILink")||(reader.Name = "MISegment")
		||(reader.Name = "MITextDesc") )&& (reader.NodeType = "element"))
		{
			s TypeName = reader.Name
			s Code = ""
			s DisplayName = ""
			while reader.Read()
			{
				q:((reader.Name = "SubItems")&&(reader.NodeType = "endelement"))
				if ((reader.Name = "SubItems")&&(reader.NodeType = "element"))
				{
					q
				}
				if ((reader.Name = "Code") && (reader.NodeType = "element"))
				{
					if (reader.Read())
		    		{
						;if (reader.MoveToAttributeName("Code")) s Code = reader.Value
						s Code =reader.Value
		    		}
				}
				elseif((reader.Name  = "Text") && (reader.NodeType = "element"))
				{
					if reader.Read() 
		    		{
						s DisplayName =reader.Value   
					}
				}
				
				q:(((reader.Name = "MIString")||(reader.Name = "MINumber")
				||(reader.Name = "MIDateTime")||(reader.Name = "MIMonoChoice")
				||(reader.Name = "MIMultiChoice")||(reader.Name = "MIDictionary")
				||(reader.Name = "MILink")||(reader.Name = "MISegment")
				||(reader.Name = "MITextDesc"))&&(reader.NodeType = "endelement"))
			}	
			s strItem = "<Item ItemID="""_Code_""" ItemName="""_DisplayName_""" ItemDataType="""_TypeName_"""></Item>"
			;S strItem = $zcvt(strItem,"O","UTF8") 
			if (Code ="E0015")
			{
				s sert = ""
			}
			d ItemsSet.Write(strItem)
			d arrlist.SetAt(DisplayName,Code)
		}
		
	}
}

/// Desc:		提供给上海今创的接口(华西二院)
/// Input：		aCategoryID：术语范畴Id
/// Return：	EPRservice.dataset.EDataElementDataset: 术语集dataset
/// Debug:		d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLEmrUisWebService","GetEMRDataByDate","2016-5-24 0:00:00","2016-7-25 0:00:00")
Query GetEMRDataByDate(paraA As %String, paraB As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "EpisodeID:%String,PatientID:%String,RecordNo:%String,Name:%String,CatalogID:%String,ModifyDate:%String") [ SqlProc ]
{
}

ClassMethod GetEMRDataByDateExecute(ByRef qHandle As %Binary, paraA As %String, paraB As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s startD = ""
	s startT = ""
	s endD = ""
	s endT = ""
	if ((paraA [" ")&&(paraB[" "))
	{
		s startD = $ZDATEH($P(paraA," ",1),8)
		s startT = $ZTIMEH($P(paraA," ",2))
		s endD = $ZDATEH($P(paraB," ",1),8)
		s endT = $ZTIMEH($P(paraB," ",2))
	}
	
	s rowID=0
	s subID=0
	for d=startD:1:endD
	{
		for
		{
			s rowID = $o(^DHCEMRI.InstanceDataI("IdxModifyDate",d,rowID))
			q:(rowID="")
			s subID = $o(^DHCEMRI.InstanceDataI("IdxModifyDate",d,rowID,subID))
			continue:(subID="")
			s objECR =##Class(EMRinstance.ECRecord).%OpenId(rowID)
			s inRowID = rowID_"||"_subID
			s objInstance =##Class(EMRinstance.InstanceData).%OpenId(inRowID)
			continue:((objInstance="")||(objInstance.Status'="Save"))
		
		 	s strEpisodeID = objInstance.RealEpisodeID
		 	s strPatientID = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(strEpisodeID)
		 	s Hospital=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("HospitalName")

		 	// 住院病案号		[IPRecordNo]		PA_PatMas.PAPMI_Medicare
		 	s IPRecordNo = ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(strEpisodeID,Hospital)
		 	//s IPRecordNo=""
 	
		 	// 门诊病案号		[OPRecordNo]		PA_Person.PAPER_GovernCardNo
		 	s OPRecordNo = ##class(EMRservice.HISInterface.PatientInfoAssist).OPRecordNo(strPatientID,Hospital)
 	
		 	// 急诊病案号		[EPRecordNo]		DHC_Person.PAPER_FCMedicareCode1
		 	s EPRecordNo = ##class(EMRservice.HISInterface.PatientInfoAssist).EPRecordNo(strPatientID,Hospital)
		 	s RecordNo=IPRecordNo_ OPRecordNo_EPRecordNo
		 	//姓名
		 	s Name=##Class(EMRservice.HISInterface.PatientInfoAssist).Name(strPatientID)
		 	s strDocID = objECR.RealChartItemID
		 	s objTempCate =##Class(EMRmeta.EMRTemplateCategory).%OpenId(strDocID)
		 	continue:(objTempCate = "")
		 	s strCateID = objTempCate.ParentCategoryID
		 	continue:(strCateID = "")
		 	s objCategoryChapter =##Class(EMRmeta.EMRTemplateCategory).%OpenId(strCateID)
		 	continue:(objCategoryChapter = "")
		 	s strParCateID = objCategoryChapter.ParentCategoryID
		 	continue:(strParCateID="")
		 	
		 	s strCatalogID = "CD"_"_"_strParCateID_"_"_strCateID_"_"_strDocID
		 	s strModifyDate = $ZDATE(objInstance.ModifyDate,3) _" "_$ZTIME(objInstance.ModifyTime)
  		
			s Data = $lb(strEpisodeID,strPatientID,RecordNo,Name,strCatalogID,strModifyDate)
			s ^CacheTemp(repid,ind) = Data
			s ind = ind + 1
		}
	}
	q $$$OK
}

ClassMethod GetEMRDataByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEMRDataByDateExecute ]
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

ClassMethod GetEMRDataByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEMRDataByDateExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod exPortToXml(sourceA As %AbstractStream, sourceB As %AbstractStream, nameA As %String)
{
	s objEmrTemplate =##Class(EMRservice.entity.EViewEMRTemplate).%New()

	s objstreamF=##class(%FileCharacterStream).%New()
	s objstreamF.Filename="D:\xml\MetaData_"_nameA_"_.xml"
	d objstreamF.TranslateTableSet("UTF8")
	d objstreamF.CopyFrom(sourceA)
	d objstreamF.SaveStream()
	d objstreamF.%Close()

	s objstreamN=##class(%FileCharacterStream).%New()
	s objstreamN.Filename="D:\xml\NEW_"_nameA_"_.xml"
	d objstreamN.TranslateTableSet("UTF8")
	;d objEmrTemplate.XMLExportToStream(.xmlStream)
	d objstreamN.CopyFrom(sourceB)
	d objstreamN.SaveStream()
	d objstreamN.%Close()
}

}
