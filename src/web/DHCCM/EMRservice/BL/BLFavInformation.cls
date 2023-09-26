Import sqluser

/// Desc:      收藏夹病例信息逻辑
/// Creator:   bianshuai
/// CreateDate:2016-10-11
Class web.DHCCM.EMRservice.BL.BLFavInformation Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       收藏病历
/// Creator:    Candy
/// CreateDate: 2014-11-25
/// Input:      AUserID 收藏用户
///             ACatalogID 收藏位置
///             AFavName 收藏名称
///             AMemo 备注
///             AInstanceID 收藏病历
/// Output:     result 0失败 1成功
/// Debug:      w ##Class(EMRservice.BL.BLFavInformation).AddFavInformation("0000000025",2,2,卡测试3 女123,"jrm123,fs123,test123",69)
ClassMethod AddFavInformation(ApatientNo As %String, AFavUserID As %String, ACatalogID As %String, AMemo As %String, ATags As %String, AEpisodeID As %String, AInstanceID As %String) As %String
{
	s result = "0"
	q:((ApatientNo = "")||(AFavUserID = "")||(ACatalogID = "")) result
	s patientId = $o(^PAPERi("PAPMI_PatNo",ApatientNo,""))
	q:(patientId = "") result
	s rowId = $o(^DHCPHF.FavInformationI("IdxMain",AFavUserID," "_ApatientNo,""))
	;s ^ddd(3)=rowId
	if (rowId = "")
	{
		s objFavInfo = ##Class(User.DHCPHFavInformation).%New()
	}
	else
	{
		s objFavInfo = ##Class(User.DHCPHFavInformation).%OpenId(rowId)
		
	}
	s objFavInfo.PatientNo = ApatientNo
	s objFavInfo.PatientName = ##class(EMRservice.HISInterface.PatientInfoAssist).Name(patientId)
	s bod = ##class(EMRservice.HISInterface.PatientInfoAssist).Birthday(patientId)
	s objFavInfo.PatientBOD = $p(bod,",",1)
	s gender = ##class(EMRservice.HISInterface.PatientInfoAssist).Gender(patientId,"")
	s objFavInfo.PatientGender = $P(gender,"^",3)
	s objFavInfo.CatalogID = ACatalogID
	s objFavInfo.Memo = AMemo
	s objFavInfo.FavUserID = AFavUserID
	s objFavInfo.Type = "Private"
	TStart
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
			s tmpAddTag = ##Class(web.DHCCM.EMRservice.BL.BLFavTag).AddFavTags(ATags,AFavUserID)
			if (tmpAddTag = "0")
			{
				Trollback
				q result				
			}
			s scInfoTag = ##Class(web.DHCCM.EMRservice.BL.BLFavTagInformation).AddInfotoTag(tmpAddTag,rowId)
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

/// Desc:       病例列表
/// Creator:    Candy
/// CreateDate: 2014-11-27
/// Input:      ACatalogID 目录ID
/// Output:     result Information json串
/// Debug:      w ##Class(EMRservice.BL.BLFavInformation).GetFavInfoByCataLog(1,1,"Share")
ClassMethod GetFavInfoByCataLog(AFavUserID As %String, ACatalogID As %String, ATypeID As %String) As %String
{
	s result = ""
	s count = 0
	q:(ACatalogID = "") result
	s seq = ""
	for
	{
		s seq = $o(^DHCPHF.FavInformationI("IdxUserCatalogSequence",AFavUserID," "_ACatalogID,seq))
		q:(seq = "")
		s rowId = $o(^DHCPHF.FavInformationI("IdxUserCatalogSequence",AFavUserID," "_ACatalogID,seq,""))
		continue:(rowId = "")
		s objInfo = ##Class(User.DHCPHFavInformation).%OpenId(rowId)
		continue:((objInfo.Type '= "Share")&&(ATypeID = "Share"))
		s infoJson = ##Class(web.DHCCM.EMRservice.BL.BLFavInformation).GetFavInfo(rowId)
		continue:(infoJson = "")
		s:(count '= 0) result = result_","
		s result = result_infoJson
		s count = count + 1
	}
	q "{""total"":["_result_"],""count"":"""_count_"""}"
}

/// Desvc:      取病例内容
/// Creator:    Candy
/// CreateDate: 2014-11-27
/// Debug:      w ##Class(web.DHCCM.EMRservice.BL.BLFavInformation).GetFavInfo(1)
ClassMethod GetFavInfo(AInfoID As %String) As %String
{
	s result = ""
	q:(AInfoID = "") result
	s objInfo = ##Class(User.DHCPHFavInformation).%OpenId(AInfoID)
	q:(objInfo = "") result
	s patientId = $o(^PAPERi("PAPMI_PatNo",objInfo.PatientNo,""))
	s tags = ##class(web.DHCCM.EMRservice.BL.BLFavTagInformation).GetTagsByInfoID(AInfoID)
	s records=##class(web.DHCCM.drugFav).GetRecordsByInfoID(AInfoID)
	q:(records = "") result
	s result = result_"{"
	s result = result_"""id"":"""_AInfoID_""""
	s result = result_",""PatientID"":"""_patientId_""""
	s result = result_",""PatientNo"":"""_objInfo.PatientNo_""""
	s result = result_",""Name"":"""_objInfo.PatientName_""""
	s result = result_",""Gender"":"""_objInfo.PatientGender_""""
	s result = result_",""BOD"":"""_##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(objInfo.PatientBOD)_""""
	s result = result_",""Memo"":"""_objInfo.Memo_""""
	s result = result_",""CatalogID"":"""_objInfo.CatalogID_""""
	s result = result_",""Type"":"""_objInfo.Type_""""
	s result = result_",""FavUserID"":"""_objInfo.FavUserID_""""
	s result = result_",""Records"":["_records_"]"
	s result = result_",""Tags"":["_tags_"]"
	s result = result_"}"
	q result
}

/// Desc:   按就诊取收藏病历列表
/// Creator:Candy
/// Debug:  w ##Class(EMRservice.BL.BLFavInformation).GetFavRecords(1)
ClassMethod GetFavRecords(AFavInfoID As %String) As %String
{
	s result = ""
	q:(AFavInfoID = "") result
	s count = 0
	s episodeId = ""
	for
	{
		s episodeId = $o(^DHCPHF.FavRecordI("IdxParRefEpisodeID",AFavInfoID,episodeId))
		q:(episodeId = "")
		s subId = ""
		s tmpResult = ""
		s tmpcount = 0
		for
		{
			s subId = $o(^DHCPHF.FavRecordI("IdxParRefEpisodeID",AFavInfoID,episodeId,subId))
			q:(subId = "")
			s rowId = AFavInfoID_"||"_subId
			s objFavRecrod = ##Class(User.DHCPHFavRecord).%OpenId(rowId)
			continue:(objFavRecrod = "")
			continue:(objFavRecrod.IsActive '= "Y")
			s ecrecordId = $p(objFavRecrod.InstanceID,"||",1)
			s instanceSubId = $p(objFavRecrod.InstanceID,"||",2)
			s json = ##Class(web.DHCCM.EMRservice.BL.BLClientCategory).GetInstanceJsonByID(ecrecordId,instanceSubId)
			continue:(json = "")
			s:(tmpcount '= 0) tmpResult = tmpResult_","
			s tmpResult = tmpResult_json
			s tmpcount = tmpcount + 1
		}	
		continue:(tmpResult = "")
		s:(count '= 0) result = result_","
		s tmpEpisodeId = $tr(episodeId," ","")
		s admDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(tmpEpisodeId)
		s:(admDateTime '= "") admDateTime = ##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml($p(admDateTime,",",1))_" "_$zt($p(admDateTime,",",2))
		s episodeType = $p(^PAADM(tmpEpisodeId),"^",2)
		s episodeType = $case(episodeType,"I":"住院","O":"门诊","E":"急诊",:"")
		s episodeLoc = ##class(EPRservice.HISInterface.PatientInfoAssist).CurrentDept(tmpEpisodeId)
		s episodeLoc = $p(episodeLoc,"^",3)
		s result = result_"{"
		s result = result_"""EpioseID"":"""_tmpEpisodeId_""""
		s result = result_",""EpisodeDateTime"":"""_admDateTime_""""
		s result = result_",""EpisodeType"":"""_episodeType_""""
		s result = result_",""EpisodeLoc"":"""_episodeLoc_""""
		s result = result_",""Records"":["_tmpResult_"]"
		s result = result_"}"
		s count = count + 1
	}
	q result
}

/// Desc: 未收藏病历列表
/// Creaotr:Candy
/// Debug:w ##Class(EMRservice.BL.BLFavInformation).GetNoFavRecords(1,76)
ClassMethod GetNoFavRecords(AFavInfoID As %String, AEpisodeID As %String) As %String
{
	s result = ""
	s count = 0
	s FavRecorIds = ""
	if (AFavInfoID '= "")
	{
		s subId = ""
		for
		{
			s subId = $o(^DHCPHF.FavRecordI("IdxParRefEpisodeID",AFavInfoID," "_AEpisodeID,subId))
			q:(subId = "")
			s rowId = AFavInfoID_"||"_subId
			s obj = ##Class(User.DHCPHFavRecord).%OpenId(rowId)
			continue:(obj = "")
			continue:(obj.IsActive = "N")
			s FavRecorIds = FavRecorIds_$lb(obj.InstanceID)
		}	
	}
	s date = ""
	for
	{
		s date = $o(^DHCPHI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_AEpisodeID," SAVE",date))
		q:(date = "")
		s time = ""
		for
		{
			s time = $o(^DHCPHI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_AEpisodeID," SAVE",date,time))
			q:(time = "")
			s parentId = ""
			for
			{
				s parentId = $o(^DHCPHI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_AEpisodeID," SAVE",date,time,parentId))
				q:(parentId = "")
				s subId = ""
				for
				{
					s subId = $o(^DHCPHI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_AEpisodeID," SAVE",date,time,parentId,subId))
					q:(subId = "")
					continue:(($F(FavRecorIds,parentId_"||"_subId))>0)
					s tempJson =  ##Class(web.DHCCM.EMRservice.BL.BLClientCategory).GetInstanceJsonByID(parentId,subId)
					continue:(tempJson = "")
					s:(count '= 0) result = result_","					
					s result = result_tempJson
					s count = count + 1
				}
			}
		}
	}
	q result
}

/// Desc:      添加收藏病历文书
/// Creator:   Candy
/// CreateDate:2014-12-2
/// Input:     AFavInfoID 病例ID
///            AInstanceID 病历ID
/// Output:    0 添加失败,1成功
/// Debug:     ##Class(EMRservice.BL.BLFavInformation).AddFavRecord(1,"
ClassMethod AddFavRecord(AFavInfoID As %String, AEpisodeID As %String, AInstanceID As %String) As %String
{
	s result = "0"
	q:((AFavInfoID = "")||(AEpisodeID = "")||(AInstanceID = "")) result
	s rowId = $o(^DHCPHF.FavRecordI("IdxParRefInstanceID",AFavInfoID," "_AEpisodeID," "_AInstanceID,""))
	if (rowId = "")
	{
		s objFavInfo = ##Class(User.DHCPHFavInformation).%OpenId(AFavInfoID)
		q:(objFavInfo = "") result
		s objFavRecord = ##Class(User.DHCPHFavRecord).%New()
		s objFavRecord.InstanceID = AInstanceID
		s objFavRecord.EpisodeID = AEpisodeID
		s objFavRecord.ParRef = objFavInfo
	}
	else
	{
		s objFavRecord = ##Class(User.DHCPHFavRecord).%OpenId(AFavInfoID_"||"_rowId)
		q:(objFavRecord = "") result
	}
	s objFavRecord.IsActive = "Y"
	
	s:($$$ISOK(objFavRecord.%Save())) result = "1"	
	q result
}

/// Desc:      取消收藏病历文书
/// Creator:   Candy
/// CreateDate:2014-12-2
/// Input:     AFavInfoID 病例ID
///            AInstanceID 病历ID
/// Output:    0 添加失败,1成功
/// Debug:     w ##Class(EMRservice.BL.BLFavInformation).CancelFavRecrod(1,76,"1||5")
ClassMethod CancelFavRecrod(AFavInfoID As %String, AEpisodeID As %String, AInstanceID As %String) As %String
{
	s result = "0"
	q:((AFavInfoID="")||(AEpisodeID="")||(AInstanceID="")) result
	s subId = $o(^DHCPHF.FavRecordI("IdxParRefInstanceID",AFavInfoID," "_AEpisodeID," "_AInstanceID,""))
	q:(subId = "") result
	s objFavRecord = ##Class(User.DHCPHFavRecord).%OpenId(AFavInfoID_"||"_subId)
	q:(objFavRecord = "") result
	s objFavRecord.IsActive = "N"
	s:($$$ISOK(objFavRecord.%Save())) result = "1"	
	q result
}

/// Desc:      查看当前病历是否被添加到收藏夹
/// CreateDate:2015-7-14
/// Input:     APatientNo 病人ID
///            AUserID 用户ID
///            AEpisodeID 就诊号
/// Output:    0：未被收藏,1：收藏
/// Debug:     w ##Class(EMRservice.BL.BLFavInformation).SearchFavRecord("0000000157",105,441,35||1)
ClassMethod SearchFavRecord(APatientNo As %String, AUserID As %String, AEpisodeID As %String, AInstanceID As %String) As %String
{
	s result=0
	q:((APatientNo="")||(AUserID="")||(AEpisodeID="")||(AInstanceID="")) result
	//userId收藏用户ID
	s userId = ##Class(web.DHCCM.EMRservice.BL.BLFavUser).GetFavUserID(AUserID)
	s rowId=$o(^DHCPHF.FavInformationI("IdxMain",userId," "_APatientNo,""))
	q:(rowId="") result
	s subId=$o(^DHCPHF.FavRecordI("IdxParRefInstanceID",rowId," "_AEpisodeID," "_AInstanceID,""))
	q:(subId="") result
	if (subId'=""){
		s result=1
	}
	q result
}

/// Desc:      删除收藏病例
/// Creator:   Candy
/// CreateDate:2014-12-3
/// Input:     AFavInfoID
/// Output:    0失败,1成功
/// Debug:     w ##Class(EMRservice.BL.BLFavInformation).DeleteFavInfo(9)
ClassMethod DeleteFavInfo(AFavInfoID As %String)
{
	s result = "0"
	q:(AFavInfoID = "") result
	s sc = ##Class(User.DHCPHFavInformation).%DeleteId(AFavInfoID)
	i $$$ISOK(sc) s result = "1"
	q result
}

/// Desc:      更改收藏目录
/// Creator:   Candy
/// CreateDate:2014-12-04
ClassMethod ModifyInfoCatalog(AFavInfoID As %String, ACatalogID As %String) As %String
{
	s result = "0"
	q:((ACatalogID = "")||(AFavInfoID = "")) result
	s objFavInfo = ##Class(User.DHCPHFavInformation).%OpenId(AFavInfoID)
	q:(objFavInfo = "") result
	s objFavInfo.CatalogID = ACatalogID
	s:($$$ISOK(objFavInfo.%Save())) result = "1"
	q result
}

/// Desc:      修改备注
/// Creator:   Candy
/// CreateDate:2014-12-04
ClassMethod ModifyInfoMemo(AFavInfoID As %String, AMemo As %String) As %String
{
	s result = "0"
	q:(AFavInfoID = "") result
	s objFavInfo = ##Class(User.DHCPHFavInformation).%OpenId(AFavInfoID)
	q:(objFavInfo = "") result
	s objFavInfo.Memo = AMemo
	s:($$$ISOK(objFavInfo.%Save())) result = "1"
	q result
}

/// Desc:       共享收藏病例
/// Creator:    Candy
/// CreateDate: 2014-11-19
/// Input:      AFavInfoID 目录ID
/// Output:     result 0 失败 1成功
/// Debug:      w ##Class(EMRservice.BL.BLFavInformation).ShareFavInfo(6)
ClassMethod ShareFavInfo(AFavInfoID As %String, AType As %String) As %String
{
	s result = "0"
	q:(AFavInfoID = "") result
	s objFavInfo = ##Class(User.DHCPHFavInformation).%OpenId(AFavInfoID)
	q:(objFavInfo = "") result
	q:(objFavInfo.CatalogID = "") result
	s objFavInfo.Type = "Share"
	TStart
	s sc = objFavInfo.%Save()
	if ($$$ISOK(sc))
	{
		if (AType = "Catalog")
		{
			s resultFlag = ##Class(web.DHCCM.EMRservice.BL.BLFavCatalog).setParentShare(objFavInfo.CatalogID)
		}
		else
		{
			s resultFlag = ##Class(web.DHCCM.EMRservice.BL.BLFavTag).SetParentTag(AFavInfoID)
		}
	    if (resultFlag = "0")
	    {
		    Trollback
		    q result
		}
		else
		{
			s objFavUser = ##Class(User.DHCPHFavUser).%OpenId(objFavInfo.FavUserID)
			if (objFavUser '= "")
			{
				s objFavUser.Type = "Share"
				s scFavUser = objFavUser.%Save()
				if ($$$ISOK(scFavUser))
				{
					TCommit
					s result = "1"
				}
				else
				{
					Trollback
	    			q result	
				}
			}
			else
			{
				Trollback
	    		q result					
			}
		}
	}
	q result
}

/// Desc:       取消病历收藏
/// Creator:    Candy
/// CreateDate: 2015-1-27 
ClassMethod UnShareFavInfo(AFavInfoID As %String) As %String
{
	s result = "0"
	q:(AFavInfoID = "") result
	s objFavInfo = ##Class(User.DHCPHFavInformation).%OpenId(AFavInfoID)
	q:(objFavInfo = "") result
    s objFavInfo.Type = "Private"
    s:($$$ISOK(objFavInfo.%Save())) result = "1"
    q result
}

/// Desc:       收藏目录下所有病历
/// Creator:    Candy
/// CreateDate: 2014-1-28
/// Input:      ACatalogID 目录ID
///            AType   Share/Private
/// Output:     result 1 成功，0 失败
ClassMethod ShareInfoByCatalogID(AFavUserID As %String, ACatalogID As %String, AType As %String) As %String
{
	s result = 0
	q:((ACatalogID = "")||(AType = "")) result
	s seq = "",result = 1
	Tstart
	for
	{
		s seq = $o(^DHCPHF.FavInformationI("IdxUserCatalogSequence",AFavUserID," "_ACatalogID,seq))
		q:(seq = "")
		s rowId = ""
		for
		{
			s rowId = $o(^DHCPHF.FavInformationI("IdxUserCatalogSequence",AFavUserID," "_ACatalogID,seq,rowId))
			q:(rowId = "")
			s objFavInfo = ##Class(User.DHCPHFavInformation).%OpenId(rowId)
			if (objFavInfo = "")
			{
				s result = 0
				q
			}
			s objFavInfo.Type = AType
			if ($$$ISERR(objFavInfo.%Save()))
			{
				s result = 0
				q
			}
		}
		q:(result = 0)
	}
	if (result = 0)
	{
		Trollback
	}
	else
	{
		Tcommit
	}
	q result
}

/// Desc:		查询病历
/// Creator:    Candy
/// CreateDate: 2014-12-16
/// 	Input:      AValue 查询条件
/// Output:     返回符合条件信息
/// Debug:      w ##Class(EMRservice.BL.BLFavInformation).Select("飘零")
ClassMethod Select(AValue As %String, ALocation As %String) As %String
{
	s result = ""
	q:(AValue = "") result
	s count = 0	
	s rowId = ""
	for
	{
		s rowId = $o(^DHCPHF.FavInformationD(rowId))
		q:(rowId = "")
		s tempResult = ..SelectByID(AValue,ALocation,rowId)
		continue:(tempResult = "")
		s:(count '=0 ) result = result_","
		s result = result_tempResult
		s count = count + 1
	}
	q "{""total"":["_result_"],""count"":"""_count_"""}"
}

/// Desc:		查询病例内容
/// Creator:		Candy
/// CreateDate:	2014-12-16
/// Input:       AValue 查询内容
/// 				ARowId 病例ID
/// Output:      病例内容
ClassMethod SelectByID(AValue As %String, ALocation As %String, ARowId As %String) As %String
{
	s result = ""
	q:(ARowId = "") result
	if (ALocation = "KeyWordRoot")
	{
		s tags = ..GetTagsByInfoID(ARowId)
		q:(tags = "") result
		if ($find(tags,AValue)>0)
		{
			s result = ..GetFavInfo(ARowId)
		}
	}else
	{
		s objInfo = ##Class(User.DHCPHFavInformation).%OpenId(ARowId)
		q:(objInfo = "") result
		s tags = ..GetTagsByInfoID(ARowId)
		q:(tags = "") result
		if ($find(objInfo.Memo,AValue)>0)
		{
			s result = ..GetFavInfo(ARowId)
		}
		elseif ($find(objInfo.PatientName,AValue)>0)
		{
			s result = ..GetFavInfo(ARowId)
		}
		elseif ($find(objInfo.PatientNo,AValue)>0)
		{
			s result = ..GetFavInfo(ARowId)
		}		
		elseif ($find(objInfo.PatientGender,AValue)>0)
		{
			s result = ..GetFavInfo(ARowId)
		}
		elseif ($find(objInfo.PatientBOD,AValue)>0)
		{
			s result = ..GetFavInfo(ARowId)
		}
		elseif ($find(tags,AValue)>0)
		{
			s result = ..GetFavInfo(ARowId)
		}
	}
	q result
}

ClassMethod GetTagsByInfoID(AInfoID As %String) As %String
{
	s result = ""
	q:(AInfoID = "") result
	s count = 0
	s tagId = ""
	for
	{
		s tagId = $o(^DHCPHF.FavTagInformationI("IdxInfoIDTag",AInfoID,tagId))
		q:(tagId = "")
		s objTag = ##Class(User.DHCPHFavTag).%OpenId(tagId)
		continue:(objTag = "")
		s:(count '= 0) result = result_","
		s result = result_objTag.TagName
		s count = count + 1
	}
	q result
}

}
