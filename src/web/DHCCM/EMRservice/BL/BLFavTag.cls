/// Desc:       标签逻辑业务类
/// Creator:    Candy
/// CreateDate: 2014-11-19
Class web.DHCCM.EMRservice.BL.BLFavTag Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       添加标签
/// Creator:    Candy
/// CreateDate: 2014-11-20
/// Input:      ATagName 病例名称
///             AParentID 用户ID
/// Output:     result rowid 保存成功 0保存失败	
/// Debug:      w ##Class(web.DHCCM.EMRservice.BL.BLFavTag).AddFavTag("青年男性",1)
ClassMethod AddFavTag(ATagName As %String, AFavUserID As %String) As %String
{
	s result = "0"
	q:((ATagName = "")||(AFavUserID = "")) result
	s rowId = $o(^DHCPHF.FavTagI("IdxTagName"," "_$zcvt(ATagName,"U"),""))	
	if (rowId = "")
	{
		s objFavTag = ##Class(User.DHCPHFavTag).%New()
		q:(objFavTag = "")
	}
	else
	{
		s objFavTag = ##Class(User.DHCPHFavTag).%OpenId(rowId)
		q:(objFavTag = "")
	}
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

/// Desc:       添加标签s
/// Creator:    Candy
/// CreateDate: 2014-12-18
/// Input:      ATagNames 标签名称
///            AFavUserID 收藏用户ID
/// Output:     result 1 成功 0失败
/// Debug:      w ##Class(EMRservice.BL.BLFavTag).AddFavTags("sss,1111",1)
ClassMethod AddFavTags(ATagNames As %String, AFavUserID As %String) As %String
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

/// Desc:       修改标签名称
/// Creator:    Candy
/// CreateDate: 2014-11-20
/// Input:      AID
///            ATagName  
/// Output:     result 1 修改成功,0 修改失败
ClassMethod UpdateFavTag(AID As %String, ATagName As %String) As %String
{
	s result = "0"
	q:((AID = "")||(ATagName = "")) result
	s objFavTag = ##Class(User.DHCPHFavTag).%OpenId(AID)
	q:(objFavTag = "")
	s objFavTag.TagName = ATagName
	s sc = objFavTag.%Save()
	s:($$$ISOK(sc)) result = "1"
	q result
}

/// Desc:       共享标签
/// Creator:    Candy
/// CreateDate: 2014-11-20
/// Input:      AID 目录ID
///             AType  Share/Private
/// Output:     result 0 失败 1成功
/// Debug:      w ##Class(EMRservice.BL.BLFavTag).ShareFavTag(1,"Share")
ClassMethod ShareFavTag(AID As %String, AType As %String) As %String
{
	s result = "0"
	q:(AID = "") result
	s objFavTag = ##Class(User.DHCPHFavTag).%OpenId(AID)
	q:(objFavTag = "")
	s objFavTag.Type = AType
	Tstart
	s result = "1"
	s sc = objFavTag.%Save()
	if ($$$ISOK(sc))
	{
		s infoId = ""
		for
		{
			s infoId = $o(^DHCPHF.FavTagInformationI("IdxTagInfoID",AID,infoId))
			q:(infoId = "")
			s objFavInfo = ##Class(User.DHCPHFavInformation).%OpenId(infoId)
			if (objFavInfo = "")
			{
				s result = "0"
				q
			}
			s objFavInfo.Type = AType
			s scFavInfo = objFavInfo.%Save()
			if ($$$ISERR(scFavInfo)) 
			{
				s result = "0"
				q
			}
		}
		if (result '= 1)
		{
			Trollback
			q result
		}
		TCommit								
	}
	q result
}

/// Desc:    共享所有标签
/// Creator: Candy
/// Debug:   w ##Class(EMRservice.BL.BLFavTag).ShareAllTag(1,"Share")
ClassMethod ShareAllTag(AFavUserID As %String, AType As %String) As %String
{
	s result = "0"
	q:((AFavUserID = "")||(AType = "")) result
	s seq = ""
	s result = "1"
	Tstart
	for
	{
		s seq = $o(^DHCPHF.FavTagI("IdxUserIDSeq"," "_AFavUserID,seq))
		q:(seq = "")
		s rowId = ""
		for
		{
			s rowId = $o(^DHCPHF.FavTagI("IdxUserIDSeq"," "_AFavUserID,seq,rowId))
			q:(rowId = "")
			s objTag = ##Class(User.DHCPHFavTag).%OpenId(rowId)
			continue:(objTag = "")
			s result = ..ShareFavTag(rowId,AType)
			q:(result = "0")
		}
		q:(result = "0")
	}
	if (result = "0")
	{
		Trollback
		q result
	}
	Tcommit
	q result
}

/// Desc:      设置共享上级tag
/// Creator:   Candy
/// CreateDate:2015-1-27
ClassMethod SetParentTag(AFavInfoID As %String) As %String
{
	s result = "0"
	s rowId = $o(^DHCPHF.FavTagInformationI("IdxInfoIDTag",AFavInfoID,""))
	q:(rowId = "") result
	s objFavTag = ##Class(User.DHCPHFavTag).%OpenId(rowId)
	q:(objFavTag = "") result
	s objFavTag.Type = "Share"
	s:($$$ISOK(objFavTag.%Save())) result = "1"
	q result
}

/// Desc:       调序
/// Creator:    Candy
/// CreateDate: 2014-11-20
/// Input:      APreID 
///            ANextID
/// Output:     result
ClassMethod SwapSequence(APreID As %String, ANextID As %String) As %String
{
	s result = "0"
	q:((APreID = "")||(ANextID = "")) result
	s objPreFavTag = ##Class(User.DHCPHFavTag).%OpenId(APreID)
	q:(objPreFavTag = "")
	s objNextFavTag = ##Class(User.DHCPHFavTag).%OpenId(ANextID)
	q:(objNextFavTag = "")
	s tempSequence = objPreFavTag.Sequence
	s objPreFavTag.Sequence = objNextFavTag.Sequence
	s objNextFavTag.Sequence = tempSequence
	Tstart
	s scPre = objPreFavTag.%Save()
	if ($$$ISOK(scPre))
	{
		s scNext = objNextFavTag.%Save()
		if ($$$ISOK(scNext))
		{
			TCOMMIT
			s result = "1"
		}
		else
		{
			Trollback
		}
	}
	q result
}

/// Debug: w ##Class(EMRservice.BL.BLFavTag).GetTagTree(1)
ClassMethod GetTagTree(AFavUserID As %String, AType As %String) As %String
{
	s result = ""
	s count = 0
	q:(AFavUserID  = "") result
	s rowId = ""
	for
	{
		s rowId = $o(^DHCPHF.FavTagI("IdxFavUserID"," "_AFavUserID,rowId))
		q:(rowId = "")
		s objTag = ##Class(User.DHCPHFavTag).%OpenId(rowId)
		continue:(objTag = "")
		continue:((AType = "Share")&&(objTag.Type '= "Share"))
		s:(count '= 0) result = result_","
		s result = result_"{"
		s result = result_"""id"":"""_rowId_""""
		s result = result_",""text"":"""_objTag.TagName_""""
		s result = result_",""attributes"":{"
		s result = result_"""favUserId"":"""_AFavUserID_""""
		s result = result_",""type"":""KeyWord"""
		s result = result_"}"
		s result = result_"}"
		s count = count + 1
	}
	q result
}

}
