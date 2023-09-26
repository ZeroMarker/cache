Class web.DHCCM.drugFav Extends %Persistent
{

/// Creator：      duwensheng
/// CreatDate：    2016-10-25
/// Description：  添加收藏
/// Table：        DHC_PHFavInformation、DHC_PHFavRecord、DHC_PHFavTag、DHC_PHFavTagInformation、DHC_PHFavCatalog
/// input:		   patientNo,favUserId,catalogId,memo,tags,episodeId,instanceId
/// Output：       0:收藏失败、1:收藏成功
/// Others：       d ##class(web.DHCCM.drugFav).OnPage()
ClassMethod OnPage()
{
	s patientNo = $Get(%request.Data("PatientNo",1),"")
	s favUserId = $Get(%request.Data("FavUserID",1),"")
	s catalogId = $Get(%request.Data("CatalogID",1),"")
	s memo = $Get(%request.Data("Memo",1),"")
	s tags = $Get(%request.Data("Tags",1),"")
	s episodeId = $Get(%request.Data("EpisodeID",1),"") //本次就诊号
	s instanceId = $Get(%request.Data("InstanceID",1),"") //药历id
	s:(instanceId = "undefined") instanceId = ""
	s result= ..AddFavInformation(patientNo,favUserId,catalogId,memo,tags,episodeId,instanceId)
	q result
}

/// Creator：      duwensheng
/// CreatDate：    2016-10-26
/// Description：  添加收藏
/// Table：        DHC_PHFavInformation、DHC_PHFavRecord、DHC_PHFavTag、DHC_PHFavTagInformation、DHC_PHFavCatalog
/// input:		   patientNo,favUserId,catalogId,memo,tags,episodeId,instanceId
/// Output：       0:收藏失败、1:收藏成功
/// Others：       w ##class(web.DHCCM.drugFav).AddFavInformation("6534094",1,1,"备注34","关键字43555","32595","2||3")
ClassMethod AddFavInformation(ApatientNo, AFavUserID, ACatalogID, AMemo, ATags, AEpisodeID, AInstanceID)
{
	s result = "0"
	q:((ApatientNo = "")||(AFavUserID = "")||(ACatalogID = "")) result
	;s patientId = $o(^PAPERi("PAPMI_PatNo",ApatientNo,""))
	;q:(patientId = "") result
	
	s objFavInfo = ##Class(User.DHCPHFavInformation).%New()
	s objFavInfo.PatientNo = ApatientNo
	s objFavInfo.PatientName = ##class(EMRservice.HISInterface.PatientInfoAssist).Name(ApatientNo)
	s bod = ##class(EMRservice.HISInterface.PatientInfoAssist).Birthday(ApatientNo)
	s objFavInfo.PatientBOD = $p(bod,",",1)
	s gender = ##class(EMRservice.HISInterface.PatientInfoAssist).Gender(ApatientNo,"")
	s objFavInfo.PatientGender = $P(gender,"^",3)
	s objFavInfo.CatalogID = ACatalogID
	s objFavInfo.Memo = AMemo
	s objFavInfo.FavUserID = AFavUserID
	s objFavInfo.Type = "Private"
	TS
	s sc = objFavInfo.%Save()
	if ($$$ISOK(sc))
	{
		s rowId = objFavInfo.%Id()
		s objFavInfo.Sequence = rowId
		d objFavInfo.%Save()
		if (AInstanceID '= "")
		{
			s scRecord = ..AddFavRecord(rowId,AEpisodeID,AInstanceID)
			if (scRecord = "0") 
			{
				Trollback
				q result
			}
		}
		if (ATags '= "")
		{
			s tmpAddTag = ..AddFavTags(ATags,AFavUserID)
			if (tmpAddTag = "0")
			{
				Trollback
				q result				
			}
			s scInfoTag = ..AddInfotoTag(tmpAddTag,rowId)
			if (scInfoTag = "0")
			{
				Trollback
				q result								
			}
		}
		TCOMMIT
		s result = "1"
	}
    q result
}

/// Creator：      duwensheng
/// CreatDate：    2016-10-27
/// Description：  添加收藏记录
/// Table：        DHC_PHFavRecord
/// input:		   AFavInfoID, AEpisodeID, AInstanceID
/// Output：       0:失败、1:成功
/// Others：      w ##class(web.DHCCM.drugFav).AddFavRecord(2,32595,"2||3")
ClassMethod AddFavRecord(AFavInfoID, AEpisodeID, AInstanceID)
{
	s result = "0"
	q:((AFavInfoID = "")||(AEpisodeID = "")||(AInstanceID = "")) result
	
	s objFavInfo = ##Class(User.DHCPHFavInformation).%OpenId(AFavInfoID)
	q:(objFavInfo = "") result
	s objFavRecord = ##Class(User.DHCPHFavRecord).%New()
	s objFavRecord.InstanceID = AInstanceID
	s objFavRecord.EpisodeID = AEpisodeID
	s objFavRecord.ParRef = objFavInfo
	s objFavRecord.IsActive = "Y"
	
	s:($$$ISOK(objFavRecord.%Save())) result = "1"	
	q result
}

/// Creator：      duwensheng
/// CreatDate：    2016-10-27
/// Description：  添加关键字
/// Table：        DHC_PHFavTag、DHC_PHFavTagInformation
/// input:		   ATagNames, AFavUserID
/// Output：       0:失败、1:成功
/// Others：       d ##class(web.DHCCM.drugFav).AddFavTags()
ClassMethod AddFavTags(ATagNames, AFavUserID)
{
	s result = ""
	q:(ATagNames = "")||(AFavUserID = "") result
	
	Tstart
	for i=1:1:$l(ATagNames,",")
	{
		s tagName = $p(ATagNames,",",i)
		s tempResult = ..AddFavTag(tagName,AFavUserID)
		if (tempResult = "0")
		{
			Trollback
			s result = "0"
			q
		}
		s:(i '= 1) result = result_","
		s result = result_tempResult
	}
	TCOMMIT:(result '= "0")
	q result
}

/// Creator：      duwensheng
/// CreatDate：    2016-10-27
/// Description：  添加关键字
/// Table：        DHC_PHFavTag、DHC_PHFavTagInformation
/// input:		   ATagNames, AFavUserID
/// Output：       0:失败、1:成功
/// Others：       d ##class(web.DHCCM.drugFav).AddFavTag()
ClassMethod AddFavTag(ATagName, AFavUserID) As %String
{
	s result = "0"
	q:((ATagName = "")||(AFavUserID = "")) result
	;s rowId = $o(^DHCPHF.FavTagI("IdxTagName"," "_$zcvt(ATagName,"U"),""))	
	;if (rowId = "")
	;{
		s objFavTag = ##Class(User.DHCPHFavTag).%New()
		;q:(objFavTag = "")
	;}
	;else
	;{
		;s objFavTag = ##Class(User.DHCPHFavTag).%OpenId(rowId)
		;q:(objFavTag = "")
	;}
	s objFavTag.TagName = ATagName
	s objFavTag.Type = "Private"
	s objFavTag.FavUserID = AFavUserID	
	s sc = objFavTag.%Save()
	Tstart
	if ($$$ISOK(sc))
	{
		s objFavTag.Sequence = objFavTag.%Id()
		if ($$$ISOK(objFavTag.%Save()))
		{
		 	s result = objFavTag.%Id()
		 	TCOMMIT
		}
		else
		{
			Trollback
		}
	}
	q result
}

/// Creator：      duwensheng
/// CreatDate：    2016-10-25
/// Description：  关联收藏和关键字
/// Table：        DHC_PHFavInformation、DHC_PHFavTag、DHC_PHFavTagInformation、DHC_PHFavCatalog
/// input:		   ATags、AInformationID
/// Output：       0:失败、1:成功
/// Others：       d ##class(web.DHCCM.drugFav).AddInfotoTag()
ClassMethod AddInfotoTag(ATags As %String, AInformationID As %String) As %String
{
	s result = "0"
	q:((AInformationID = "")||(ATags = "")) result
	s result = "1"
	Tstart
	for i=1:1:$l(ATags,",")
	{
		s tag = $p(ATags,",",i)
		s tagId = $p(tag,"^",1)
		s flag = $p(tag,"^",2)
		s rowId = $o(^DHCPHF.FavTagInformationI("IdxTagInfoID",tagId,AInformationID,""))
		if (flag = "false")
		{
			continue:(rowId = "")
			s sc = ##Class(User.DHCPHFavTagInformation).%DeleteId(rowId)
			s:($$$ISERR(sc)) result = "0"		
		}
		else
		{
		    continue:(rowId '= "")
		    s objTagInfo = ##Class(User.DHCPHFavTagInformation).%New()
		    s objTagInfo.InformationID = AInformationID
		    s objTagInfo.TagID = tagId
		    s sc = objTagInfo.%Save()
		    s:($$$ISERR(sc)) result = "0"	 
		}
		q:(result = "0")
	}
	if (result = "0")
	{
		Trollback
	}
	else
	{
		Tcommit
	}
    q result
}

/// Creator：      duwensheng
/// CreatDate：    2016-11-04
/// Description：  取抽藏页面收藏人的基本信息
/// Table：        DHC_PHFavRecord
/// input:		   FvaInfoID
/// Output：       0:失败、1:成功
/// Others：        w ##class(web.DHCCM.drugFav).GetRecordsByInfoID(4)
ClassMethod GetRecordsByInfoID(FvaInfoID)
{
	;s patientNo = $Get(%request.Data("PatientNo",1),"")
	s result=""
	s chiID=""
	f  s chiID=$o(^DHCPHF.FavRecordI("IdxParRef",FvaInfoID,chiID)) q:chiID=""  d
	.s ID= FvaInfoID_"||"_chiID
	.s obj=##class(User.DHCPHFavRecord).%OpenId(ID)
	.s EpisodeID=obj.EpisodeID //就诊号
	.s PAADMAdmDate=$p(^PAADM(EpisodeID),"^",6)
	.s:(PAADMAdmDate'="") PAADMAdmDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(PAADMAdmDate) //就诊日期
	.s episodeDept = ##class(EPRservice.HISInterface.PatientInfoAssist).CurrentDept(EpisodeID)		
	.s episodeDeptDesc = $p(episodeDept,"^",3) //科室
	.//年龄
	.s age = ##class(PHA.FACE.IN.Com).GetAge($p(^PAADM(EpisodeID),"^",1),EpisodeID)  ;年龄
	.//床位
	.s disBed = ##class(EMRservice.HISInterface.PatientInfoAssist).DisBed(EpisodeID)
	.//付费类型
	.s payType =  ##class(EMRservice.HISInterface.PatientInfoAssist).PayType(EpisodeID)
	.//药历模板id
	.s InstanceID=obj.InstanceID
	.s result = result_"{"
	.s result = result_"""EpisodeID"":"""_EpisodeID_""""
	.s result = result_",""PAADMAdmDate"":"""_PAADMAdmDate_""""
	.s result = result_",""InstanceID"":"""_InstanceID_""""
	.s result = result_",""episodeDeptDesc"":"""_episodeDeptDesc_""""
	.s result = result_",""age"":"""_age_""""
	.s result = result_",""disBed"":"""_disBed_""""
	.s result = result_",""payType"":"""_payType_""""
	.s result = result_"}"
	q result
}

/// Creator：      duwensheng
/// CreatDate：    2016-11-05
/// Description：  通过收藏的模板id取出模板的基本信息
/// Table：        DHC_PHInstanceData、DHC_PHECRecord
/// input:		   
/// Output：       0:失败、1:成功
/// Others：       w ##class(web.DHCCM.drugFav).getAllTempNews()
ClassMethod getAllTempNews()
{
	s result=""
	s ID=$Get(%request.Data("InstanceID",1),"")
	s obj1=##class(User.DHCPHInstanceData).%OpenId(ID)
	s tepId=$p(ID,"||")
	s obj2=##class(User.DHCPHECRecord).%OpenId(tepId)
	
	s id=ID
	s text=obj1.Title
	s chartItemType=obj2.ChartItemType
	s pluginType=obj2.DocumentType
	s emrDocId=obj2.ChartItemID
	
	s result = result_"{"
	s result = result_"""id"":"""_id_""""
	s result = result_",""text"":"""_text_""""
	s result = result_",""chartItemType"":"""_chartItemType_""""
	s result = result_",""pluginType"":"""_pluginType_""""
	s result = result_",""emrDocId"":"""_emrDocId_""""
	s result = result_"}"
	q result
}

/// Creator：      duwensheng
/// CreatDate：    2016-11-06
/// Description：  通过收藏的模板id取出就诊号
/// Table：        DHC_PHInstanceData
/// input:		   
/// Output：       
/// Others：       w ##class(web.DHCCM.drugFav).getEpsoideID()
ClassMethod getEpsoideID()
{
	s ID=$Get(%request.Data("InstanceID",1),"")
	s obj1=##class(User.DHCPHInstanceData).%OpenId(ID)
	s EpisodeID=obj1.EpisodeID
	q EpisodeID
}

/// Creator：      duwensheng
/// CreatDate：    2016-11-05
/// Description：  得到删除药历模板时的收藏id
/// Table：        DHC_PHFavInformation
/// input:		   
/// Output：       0:失败、1:成功
/// Others：       w ##class(web.DHCCM.drugFav).getFavID("4||10")
ClassMethod getFavID()
{
	s insId=$Get(%request.Data("InstanceId",1),"")
	s favId=$o(^DHCPHF.FavRecordI("IdxInstanceIDParRef"," "_insId,""))
	
	s result = "0"
	q:(favId = "") result
	s sc = ##Class(User.DHCPHFavInformation).%DeleteId(favId)
	i $$$ISOK(sc) s result = "1" //该药历曾经收藏过
	q result
}

Storage Default
{
<Data name="drugFavDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCCM.drugFavD</DataLocation>
<DefaultData>drugFavDefaultData</DefaultData>
<IdLocation>^web.DHCCM.drugFavD</IdLocation>
<IndexLocation>^web.DHCCM.drugFavI</IndexLocation>
<StreamLocation>^web.DHCCM.drugFavS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
