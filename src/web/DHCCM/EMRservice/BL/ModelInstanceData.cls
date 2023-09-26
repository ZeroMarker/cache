/// 名称:EMRservice.BL.ModelInstanceData
/// 描述:病历范例访问服务
/// 编写者：guozongtao
/// 编写日期: 2015-5-11
Class web.DHCCM.EMRservice.BL.ModelInstanceData Extends %RegisteredObject
{

/// 返回错误代码 1 为正常
ClassMethod SaveModelDocument(AInstanceID As %String, AUserID As %String, AStream As %GlobalBinaryStream, ATitle As %String, ModelInsCategoryID As %String) As %String
{
	s result = "-1"
	q:((AInstanceID ="") || (AStream = "")) result	
	
	s obj=##Class(EMRmeta.ModelInstanceData).%New()
	
	s obj.CreateDate=$p($h,",",1)
	s obj.CreateTime=$p($h,",",2)
	s obj.CreateUser=AUserID
	s obj.Name=ATitle
	s obj.FPinyin=##class(web.DHCINSUPort).GetCNCODE($tr(ATitle," ",""),4,"")
	s obj.ModelInsCategoryID=ModelInsCategoryID
			
    s streamMetaData = ##Class(EMRservice.Parser.StreamData).ParserStream(AStream,"<MetaData","</MetaData>","11")
    s streamScriptData = ##Class(EMRservice.Parser.StreamData).ParserStream(AStream,"<Scripts>","</Scripts>","10")
    s streamMediasData = ##Class(EMRservice.Parser.StreamData).ParserStream(AStream,"<Medias>","</Medias>","9")
    s streamInstanceData = ##Class(EMRservice.Parser.StreamData).ParserStream(AStream,"<NInstanceData","</NInstanceData>","16") 
    s streamScatterData = ##Class(EMRservice.Parser.StreamData).ParserStream(streamInstanceData,"<ScatterData","</ScatterData>","14")

    d obj.InstanceMetaData.CopyFrom(streamMetaData)
    d obj.InstanceScriptData.CopyFrom(streamScriptData)
   	d obj.InstanceMedia.CopyFrom(streamMediasData)
    d obj.InstanceData.CopyFrom(streamInstanceData) 

	s insData=##Class(User.DHCPHInstanceData).%OpenId(AInstanceID)
	s obj.TemplateID=insData.TemplateID
	s obj.TemplateVersion=insData.TemplateVersion	
	s obj.ListNo=insData.ListNo	
	s obj.Title=insData.Title	
	s obj.TitleCode=insData.TitleCode		
	
	s TheECRecordId=insData.TheECRecord	
	s obj.CategoryID=TheECRecordId.CategoryID
	s obj.CategoryType=TheECRecordId.CategoryType
	s obj.ChartItemID=TheECRecordId.ChartItemID
	s obj.ChartItemType=TheECRecordId.ChartItemType
	s obj.EpisodeID=TheECRecordId.EpisodeID
	s obj.EpisodeType=TheECRecordId.EpisodeType
	s obj.GroupCategoryID=TheECRecordId.GroupCategoryID
	s obj.PatientID=TheECRecordId.PatientID
	s obj.DocumentType=TheECRecordId.DocumentType	
			
	d obj.%Save()
	s obj.Sequence=obj.%Id()
	d obj.%Save()
	d obj.%Close()
	s obj=""
 	
 	q "1"
}

ClassMethod UpdateModelDocument(ModelID As %String, AUserID As %String, AStream As %GlobalBinaryStream) As %String
{
	s result = "-1"
	q:((ModelID ="") || (AStream = "")) result	
	
	s obj=##Class(EMRmeta.ModelInstanceData).%OpenId(ModelID)
	
	s obj.ModifyDate=$p($h,",",1)
	s obj.ModifyTime=$p($h,",",2)
	s obj.ModifyUser=AUserID
			
    s streamMetaData = ##Class(EMRservice.Parser.StreamData).ParserStream(AStream,"<MetaData","</MetaData>","11")
    s streamScriptData = ##Class(EMRservice.Parser.StreamData).ParserStream(AStream,"<Scripts>","</Scripts>","10")
    s streamMediasData = ##Class(EMRservice.Parser.StreamData).ParserStream(AStream,"<Medias>","</Medias>","9")
    s streamInstanceData = ##Class(EMRservice.Parser.StreamData).ParserStream(AStream,"<NInstanceData","</NInstanceData>","16") 
    s streamScatterData = ##Class(EMRservice.Parser.StreamData).ParserStream(streamInstanceData,"<ScatterData","</ScatterData>","14")

    d obj.InstanceMetaData.CopyFrom(streamMetaData)
    d obj.InstanceScriptData.CopyFrom(streamScriptData)
   	d obj.InstanceMedia.CopyFrom(streamMediasData)
    d obj.InstanceData.CopyFrom(streamInstanceData) 

	d obj.%Save()
	d obj.%Close()
	s obj=""
 	
 	q "1"
}

/// copyfrom : ##Class(EMRservice.BL.BLInstanceData).LoadDocument
ClassMethod LoadDocumentOld(ByRef AOutRecords As %GlobalBinaryStream, ModelID As %String) As %String
{
    s result = "-1"		
    q:(ModelID = "") result
 	s obj = ##Class(EMRmeta.ModelInstanceData).%OpenId(ModelID) 
	q:(obj = "") result
	//d AOutRecords.Write("-----------------------------7da4a26140fde")
	d AOutRecords.CopyFrom(##Class(EMRservice.BL.BLTemplate).GetRecordXML(obj.TemplateID,"Document",obj.Title,obj.TitleCode,obj.InstanceMetaData,obj.InstanceScriptData,obj.InstanceData,obj.InstanceMedia))
 
	s result = "1"
	q result
}

ClassMethod LoadDocument(ByRef AOutRecords As %GlobalBinaryStream, ModelID As %ListOfDataTypes, AOutMessage As %GlobalBinaryStream) As %String
{
    s result = "-1"		
    q:(ModelID = "") result
    //d AOutMessage.Write("[")
    s obj = ##Class(EMRmeta.ModelInstanceData).%OpenId(ModelID) 
	q:(obj = "") result
	
	d AOutRecords.CopyFrom(..GetRecordXML(obj.TemplateID,"Document",obj.Title,obj.TitleCode,obj.InstanceMetaData,obj.InstanceScriptData,obj.InstanceData,obj.InstanceMedia))
	s outMessage = ##Class(EMRservice.BL.Event.BLLinkDocument).GetLinkDocInfo(ModelID)
	//d:((AOutMessage.Size > 1)&&(outMessage '= "")) AOutMessage.Write(",")
    d AOutMessage.Write(outMessage)
    //d AOutMessage.Write("]")
	s result = "1"
	q result
}

ClassMethod GetRecordXML(ATempLateID As %String, AElementType As %String, ATitle As %String, ATitleCode As %String, AMetaData As %GlobalBinaryStream, AScriptData As %GlobalBinaryStream, AInstanceData As %GlobalBinaryStream, AMediasData As %GlobalBinaryStream) As %GlobalBinaryStream
{
	s stream = ##Class(%GlobalBinaryStream).%New()
	q:((ATempLateID= "")||(AElementType = "")) stream
	s objTemplate = ##Class(EMRmeta.Template).%OpenId(ATempLateID)
	q:((objTemplate = "")) stream
	s templatePropertyCode = "testCode"
	s templatePropertyName = "testName"
	if (objTemplate.TemplateProperty '= "")
	{
		s ctPropRowID = ""
	 	s ctPropRowID = $o(^DHCEMRM.CTPropertyI("IdxCode"," "_$zcvt(objTemplate.TemplateProperty,"U"),ctPropRowID))
		s objCTProperty = ##Class(EMRmeta.CTProperty).%OpenId(ctPropRowID)
		S templatePropertyCode = $zcvt(objCTProperty.PropertyCode,"O","UTF8")
		S templatePropertyName = $zcvt(objCTProperty.PropertyName,"O","UTF8")
	}
	s code = $ZSTRIP(objTemplate.Code,"*C")  //去特殊字符
	s code = $zcvt(code,"O","UTF8") //转为UTF8码制
	s displayName = $ZSTRIP(objTemplate.DisplayName,"*C") //去特殊字符
	s displayName = $zcvt(displayName,"O","UTF8") //转为UTF8码制
	s ATitleCode = $ZSTRIP(ATitleCode,"*C") 
	s ATitleCode = $zcvt(ATitleCode,"O","UTF8")
	s ATitle = $ZSTRIP(ATitle,"*C") 
	s ATitle = $zcvt(ATitle,"O","UTF8")
	//xml流
	
	d stream.Write("<?xml version=""1.0"" encoding=""UTF-8""?>")
	d stream.Write("<"_AElementType_">")
	d stream.Write("<Code Code="""_code_""" DisplayName="""_displayName_"""/>")
	d stream.Write("<TemplateGUID>"_objTemplate.GUID_"</TemplateGUID>")
	d stream.Write("<TemplateType>"_objTemplate.ChartItemType_"</TemplateType>")
	d stream.Write("<TemplateProperty Code="""_templatePropertyCode_""" DisplayName="""_templatePropertyName_"""/>")
	d stream.Write("<Title Code="""_ATitleCode_""" DisplayName="""_ATitle_"""/>")
	d stream.Write("<Macros>")
	d stream.Write("<Macro/>")
	d stream.Write("</Macros>")
	  
	//表格文档需要加打印信息
	d:( $zcvt(objTemplate.DocumentType,"U") = "GRID") stream.Write("<PrintSetup/>")
	d stream.Write("<StructuredBody>")
	d stream.CopyFrom(AMetaData)
	d stream.CopyFrom(AScriptData)
	d stream.CopyFrom(AMediasData)
	d stream.CopyFrom(AInstanceData)
	d stream.Write("</StructuredBody>")
	d stream.Write("</"_AElementType_">") 
	k objTemplate,AMetaData,AScriptData,AInstanceData,AMediasData
	q stream
}

/// copyfrom : ##Class(EMRservice.BL.BLQuotation).QuotationDocument
ClassMethod QuotationDocument(APatientID, AEpisodeID As %String, AModelID As %String, ADataTime As %String, ATitle As %String, ATitleCode As %String) As %String
{
	s result = ""
	q:((AEpisodeID = "")||(AModelID = "")) result
	s modelInsData = ##Class(EMRmeta.ModelInstanceData).%OpenId(AModelID)
	q:(modelInsData = "") result
	//生成实例ID
	s objEInstanceData = ##Class(EMRservice.entity.EInstanceData).%New()
	s objEInstanceData.GroupItemID = modelInsData.GroupItemID
	s objEInstanceData.GroupItemName = modelInsData.GroupItemName
	s objEInstanceData.Status = "UnSave"
	s date = $p(ADataTime," ",1),time = $p(ADataTime," ",2)
	s objEInstanceData.HappenDate = $Case(date,"":"",:$zdh(date,3))
	s objEInstanceData.HappenTime = $Case(time,"":"",:$zth(time))
	s objEInstanceData.Title = $case(ATitle="",1:modelInsData.Title,:ATitle)
	s objEInstanceData.TitleCode = $case(ATitleCode="",1:modelInsData.TitleCode,:ATitleCode)
	s objEInstanceData.TemplateID = modelInsData.TemplateID
	s objEInstanceData.TemplateVersion = modelInsData.TemplateVersion
	s objEInstanceData.EpisodeID = AEpisodeID
	
	s objEECRecord = ##Class(EMRservice.entity.EECRcord).%New()
	s objEECRecord.PatientID = APatientID   //modelInsData.PatientID
	s objEECRecord.EpisodeID = AEpisodeID
	s objEECRecord.CategoryID = modelInsData.CategoryID
	s objEECRecord.CategoryType =  modelInsData.CategoryType
	s objEECRecord.ChartItemType =modelInsData.ChartItemType
	s objEECRecord.DocumentType = modelInsData.DocumentType
	s objEECRecord.EpisodeType = $P($G(^PAADM(AEpisodeID)),"^",2)
	s rowID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_modelInsData.ChartItemID,""))
	if (rowID = "")
	{
		s objEECRecord.ID = ""
		s objEECRecord.InstanceCount = 1
		s objEECRecord.ChartItemID = modelInsData.ChartItemID
		s instanceID = ##Class(EMRservice.BL.BLInstanceData).SetECRInstanceData(objEECRecord,objEInstanceData)
	}else
	{
		s objEECRecord.ID = rowID
		s objEECRecord.InstanceCount =  +$li(^DHCEMRI.ECRecordD(rowID),9)+1
		s objEECRecord.ChartItemID = modelInsData.ChartItemID
		s instanceID = ##Class(EMRservice.BL.BLInstanceData).SetECRInstanceData(objEECRecord,objEInstanceData)
	}
    s result = instanceID
    q result
}

/// w ##Class(EMRservice.BL.ModelInstanceData).GetModelJson(876)
ClassMethod GetModelJson(usrID As %String) As %String
{
	s ret=""
	s id = ""
	For{
		s id=$O(^DHCEMRM.ModelInstanceDataI("IdxCreateUser", " "_usrID, id))
		q:(id="")
		s obj=##Class(EMRmeta.ModelInstanceData).%OpenId(id)
		if (ret="")
		{
			s ret="{""id"":"""_obj.%Id()_""",""text"":"""_obj.Name_"""}"
		}
		else
		{
			s ret=ret_",{""id"":"""_obj.%Id()_""",""text"":"""_obj.Name_"""}"
		}
	}
	
	q "["_ret_"]"
}

/// d ##Class(EMRservice.BL.ModelInstanceData).Test()
ClassMethod Test()
{
	s obj=##Class(EMRmeta.ModelInstanceData).%New()
	
	s obj.CategoryID="51"
	s obj.CategoryType="Normal"
	s obj.ChartItemID="53"
	s obj.ChartItemType="Single"
	s obj.EpisodeID="9"
	s obj.EpisodeType="I"
	s obj.GroupCategoryID=""
	s obj.PatientID="41"
	s obj.DocumentType="DOC"

	s obj.CreateDate=+$h
	s obj.CreateTime=$p($h,",",2)
	s obj.CreateUser="359"
	s obj.GroupItemID="51"
	s obj.GroupItemName="EMR090001 入院记录"
	s obj.HappenDate=+$h
	s obj.HappenTime=$p($h,",",2)
	
	s obj.InstanceData=""
	s obj.InstanceMetaData=""
	s obj.InstanceScriptData=""
	s obj.InstanceMedia=""
	
	s obj.ListNo="1"
	s obj.ModifyDate=+$h
	s obj.ModifyTime=$p($h,",",2) 
	s obj.ModifyUser="359"
	s obj.Status="Save"
	s obj.TemplateID=+$h
	s obj.TemplateVersion=1
	s obj.Title="入院记录-XXX个人模板"
	s obj.Remark=""
	s obj.TitleCode=""
	s obj.Memo=""

	d obj.%Save()
	d obj.%Close()
	s obj=""
}

/// w ##Class(EMRservice.BL.ModelInstanceData).SwapSequence("", "")
ClassMethod SwapSequence(ID1, ID2, flag As %String) As %String
{
	set result=0
	
	if (flag=0) {
		set obj1 = ##class(EMRmeta.ModelInstanceData).%OpenId(ID1)
		set obj2 = ##class(EMRmeta.ModelInstanceData).%OpenId(ID2)
	} else {
		set obj1 = ##class(EMRmeta.ModelInsCategory).%OpenId(ID1)
		set obj2 = ##class(EMRmeta.ModelInsCategory).%OpenId(ID2)		
	}
	q:((obj1 = "")||(obj2 = "")) result
	 
	set TempSequence = obj1.Sequence
	set obj1.Sequence = obj2.Sequence
	set obj2.Sequence = TempSequence
	
	set $zt = "SwapErrorHandler"
	
	Tstart
	
	set scResult = obj1.%Save()
	if $$$ISERR(scResult)
	{
		Trollback
		q result
	}
	
	set scResultSele = obj2.%Save() 
	if $$$ISERR(scResultSele)
	{
		Trollback
		q Ruslut
	}
	
	TCOMMIT
			    
	do obj1.%Close()
	do obj2.%Close()
	set obj1 = ""
	set obj2 = ""
	
	set Ruslut = 1
	q Ruslut
	

SwapErrorHandler
	Trollback
	q $zerror
}

ClassMethod RenameModelInstance(modelID As %Integer, newName As %String) As %String
{
	s obj=##Class(EMRmeta.ModelInstanceData).%OpenId(modelID)
	s obj.Name=newName
	s obj.FPinyin=##class(web.DHCINSUPort).GetCNCODE($tr(newName," ",""),4,"")
	d obj.%Save()	
	q "1"
}

ClassMethod NewModelCategory(userID, parentCateID, newName As %String) As %String
{
	s obj=##Class(EMRmeta.ModelInsCategory).%New()
	s obj.Name=newName
	s obj.FPinyin=##class(web.DHCINSUPort).GetCNCODE($tr(newName," ",""),4,"")
	s obj.ParentID=parentCateID
	s obj.CreateUser=userID
	d obj.%Save()
	s obj.Sequence=obj.%Id()
	d obj.%Save()		
	q obj.%Id()
}

ClassMethod RenameModelCategory(cateID As %Integer, newName As %String) As %String
{
	s obj=##Class(EMRmeta.ModelInsCategory).%OpenId(cateID)
	s obj.Name=newName
	s obj.FPinyin=##class(web.DHCINSUPort).GetCNCODE($tr(newName," ",""),4,"")
	d obj.%Save()	
	q "1"
}

ClassMethod RemoveModelIns(insID As %Integer) As %Boolean
{
	d ##Class(EMRmeta.ModelInstanceData).%DeleteId(insID)	
	q 1
}

ClassMethod RemoveModelInsCate(cateID As %Integer) As %Boolean
{
	d ##Class(EMRmeta.ModelInsCategory).%DeleteId(cateID)	
	q 1
}

ClassMethod MoveModelIns(parentID, modelInsID, isBottom, siblingID, userID As %String) As %String
{
	s $zt="ERROR"
		
	s obj=##Class(EMRmeta.ModelInstanceData).%OpenId(modelInsID)
	s obj.ModelInsCategoryID=parentID	
	d obj.%Save()	
	if (siblingID ="") { //append
		
	} else {
		s sibling = ##Class(EMRmeta.ModelInstanceData).%OpenId(siblingID)
	
		s flag = 0 // 0:向前 1:向后
		s:((isBottom=1) && (obj.Sequence < sibling.Sequence)) flag=1
		s:((isBottom=1) && (obj.Sequence > sibling.Sequence)) flag=0	
		s:((isBottom'=1) && (obj.Sequence < sibling.Sequence)) flag=1
		s:((isBottom'=1) && (obj.Sequence > sibling.Sequence)) flag=0
		s tmpSequence = obj.Sequence
		for {
			if (flag=1) {
				s tmpSequence=$O(^DHCEMRM.ModelInstanceDataI("IdxModelInsCateID", " "_userID, " "_parentID, tmpSequence))
			} else {
				s tmpSequence=$O(^DHCEMRM.ModelInstanceDataI("IdxModelInsCateID", " "_userID, " "_parentID, tmpSequence),-1)
			}
			q:(tmpSequence="")
			s id=$O(^DHCEMRM.ModelInstanceDataI("IdxModelInsCateID", " "_userID, " "_parentID, tmpSequence, ""))
			
			q:(flag=0)&&(isBottom=1)&&(id=siblingID)
			q:(flag=1)&&(isBottom'=1)&&(id=siblingID)
			s sibling = ##Class(EMRmeta.ModelInstanceData).%OpenId(id)
			s tmpSequence = sibling.Sequence
			s sibling.Sequence = obj.Sequence
			s obj.Sequence = tmpSequence
			d obj.%Save()
			d sibling.%Save()				
			q:(id=siblingID)
		}	
	}	
	q "1"
ERROR
	q $zerror
}

/// w ##Class(EMRservice.BL.ModelInstanceData).MoveModelInsCate(16, 20, 1, "", 2062)
ClassMethod MoveModelInsCate(parentID, cateID, isBottom, siblingID, userID As %String) As %String
{
	s $zt="ERROR"

	s cate = ##Class(EMRmeta.ModelInsCategory).%OpenId(cateID)	
	q:(cate="") "0"
	s cate.ParentID = parentID
	if (siblingID '="") {	
		s sibling = ##Class(EMRmeta.ModelInsCategory).%OpenId(siblingID)
	
		s flag = 0 // 0:向前 1:向后
		s:((isBottom=1) && (cate.Sequence < sibling.Sequence)) flag=1
		s:((isBottom=1) && (cate.Sequence > sibling.Sequence)) flag=0	
		s:((isBottom'=1) && (cate.Sequence < sibling.Sequence)) flag=1
		s:((isBottom'=1) && (cate.Sequence > sibling.Sequence)) flag=0
		s tmpSequence = cate.Sequence
		for {
			if (flag=1) {
				s tmpSequence=$O(^DHCEMRM.ModelInsCategoryI("IdxUsrParentSeq", " "_userID, " "_parentID, tmpSequence))
			} else {
				s tmpSequence=$O(^DHCEMRM.ModelInsCategoryI("IdxUsrParentSeq", " "_userID, " "_parentID, tmpSequence),-1)
			}
			q:(tmpSequence="")
			s id=$O(^DHCEMRM.ModelInsCategoryI("IdxUsrParentSeq", " "_userID, " "_parentID, tmpSequence, ""))
			q:(flag=0)&&(isBottom=1)&&(id=siblingID)
			q:(flag=1)&&(isBottom'=1)&&(id=siblingID)
			s sibling = ##Class(EMRmeta.ModelInsCategory).%OpenId(id)
			s tmpSequence = sibling.Sequence
			s sibling.Sequence = cate.Sequence
			s cate.Sequence = tmpSequence
			d cate.%Save()
			d sibling.%Save()				
			q:(id=siblingID)
		}	
	} else {
		s seq=$O(^DHCEMRM.ModelInsCategoryI("IdxUsrParentSeq", " "_userID, " "_parentID, ""),-1)
		if (seq="")	{
			d cate.%Save()				
		} else { 
			s id=$O(^DHCEMRM.ModelInsCategoryI("IdxUsrParentSeq", " "_userID, " "_parentID, seq, ""))
			s sibling = ##Class(EMRmeta.ModelInsCategory).%OpenId(id)
			if (cate.Sequence < sibling.Sequence) {
				s tmpSequence = sibling.Sequence
				s sibling.Sequence = cate.Sequence
				s cate.Sequence = tmpSequence
				d cate.%Save()
			}
		}
	}
	
	q "1"
ERROR
	q $zerror
}

/// IdxModelInsCateID On (CreateUser, ModelInsCategoryID, Sequence);
ClassMethod GetModelInstance(usrID, cateID As %String) As %Stream
{
    s result = ##class(%GlobalCharacterStream).%New()   
    s seq = ""
	For{
		s seq=$O(^DHCEMRM.ModelInstanceDataI("IdxModelInsCateID", " "_usrID, " "_cateID, seq))
		q:(seq="")
		
		s id=$O(^DHCEMRM.ModelInstanceDataI("IdxModelInsCateID", " "_usrID, " "_cateID, seq, ""))
		q:(id="")
		s obj=##Class(EMRmeta.ModelInstanceData).%OpenId(id)
		d:(result.Size > 0) result.Write(",")	
		d result.Write("{""id"":"""_obj.%Id()_""",""text"":"""_obj.Name_""",""attributes"":{""type"":""model"",""py"":"""_obj.FPinyin_"""}}")
	} 

	q result
}

/// Index IdxUsrParentSeq On (CreateUser, ParentID, Sequence);
ClassMethod GetModelCategory(usrID, parentID As %String) As %Stream
{
    s result = ##class(%GlobalCharacterStream).%New()   
    s seq = ""
	For{
		s seq=$O(^DHCEMRM.ModelInsCategoryI("IdxUsrParentSeq", " "_usrID, " "_parentID, seq))
		q:(seq="")
		
		s id=$O(^DHCEMRM.ModelInsCategoryI("IdxUsrParentSeq", " "_usrID, " "_parentID, seq, ""))
		q:(id="")
		s obj=##Class(EMRmeta.ModelInsCategory).%OpenId(id)
		d:(result.Size > 0) result.Write(",")	
		d result.Write("{""id"":"""_obj.%Id()_""",""text"":"""_obj.Name_""",""attributes"":{""type"":""category"",""py"":"""_obj.FPinyin_"""},""state"":""closed"",""children"":[")	
				
		s childCate=..GetModelCategory(usrID, obj.%Id())
		d:(childCate.Size>0) result.CopyFrom(childCate)
		
		
		s childIns=..GetModelInstance(usrID, obj.%Id())
		d:(childCate.Size>0)&&(childIns.Size > 0) result.Write(",")	
		d:(childIns.Size > 0) result.CopyFrom(childIns)		
		d result.Write("]}")
	}
	q result
}

/// w ##Class(EMRservice.BL.ModelInstanceData).GetModelInstanceNode(2062)
ClassMethod GetModelInstanceNode(usrID As %String) As %Stream
{
	s user = ##class(User.SSUser).%OpenId(usrID)
	s userName = user.SSUSRName
    s result = ##class(%GlobalCharacterStream).%New()
	d result.Write("{""id"":""0"",""text"":"""_userName_"的范例病历"",""attributes"":{""type"":""category"",""py"":""""},""state"":""open"",""children"":[")
	s childCate = ..GetModelCategory(usrID, 0)
	d:(childCate.Size>0) result.CopyFrom(childCate)
	
	
	s childIns=..GetModelInstance(usrID, 0)
	d:(childCate.Size>0)&&(childIns.Size > 0) result.Write(",")	
	d:(childIns.Size > 0) result.CopyFrom(childIns)		
	d result.Write("]}")
 
	q result
}

}
