/// Desc:       标签逻辑业务类
/// Creator:    Candy
/// CreateDate: 2014-11-19
Class EMRservice.BL.BLFavTag Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       添加标签
/// Creator:    Candy
/// CreateDate: 2014-11-20
/// Input:      ATagName 病例名称
///             AParentID 用户ID
/// Output:     result rowid 保存成功 0保存失败	
/// Debug:      w ##Class(EMRservice.BL.BLFavTag).AddFavTag("青年男性",1)
ClassMethod AddFavTag(ATagName As %String, AFavUserID As %String) As %String
{
	s result = "0"
	q:((ATagName = "")||(AFavUserID = "")) result
	s rowId = $o(^DHCEMRF.FavTagI("IdxTagName"," "_$zcvt(ATagName,"U"),""))	
	if (rowId = "")
	{
		s objFavTag = ##Class(EMRinstance.Favorites.FavTag).%New()
		q:(objFavTag = "")
	}
	else
	{
		s objFavTag = ##Class(EMRinstance.Favorites.FavTag).%OpenId(rowId)
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

/// Desc:       删除标签
/// Creator:    Lina
/// CreateDate: 2018-04-16
/// Input:      rowID 表EMRinstance_Favorites.FavTag的rowID
/// Output:     result  0保存失败 否则返回RowID
/// Debug:      w ##Class(EMRservice.BL.BLFavCatalog).DelFavTag(1)
ClassMethod DelFavTag(rowID As %String) As %String
{
	s result = "0"
	q:(rowID = "") result
	s sc = ##Class(EMRinstance.Favorites.FavTag).%DeleteId(rowID)
	s:($$$ISOK(sc)) result = "1"
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
	s objFavTag = ##Class(EMRinstance.Favorites.FavTag).%OpenId(AID)
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
	s objFavTag = ##Class(EMRinstance.Favorites.FavTag).%OpenId(AID)
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
			s infoId = $o(^DHCEMRF.FavTagInformationI("IdxTagInfoID",AID,infoId))
			q:(infoId = "")
			s objFavInfo = ##Class(EMRinstance.Favorites.FavInformation).%OpenId(infoId)
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
		s seq = $o(^DHCEMRF.FavTagI("IdxUserIDSeq"," "_AFavUserID,seq))
		q:(seq = "")
		s rowId = ""
		for
		{
			s rowId = $o(^DHCEMRF.FavTagI("IdxUserIDSeq"," "_AFavUserID,seq,rowId))
			q:(rowId = "")
			s objTag = ##Class(EMRinstance.Favorites.FavTag).%OpenId(rowId)
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
	s rowId = $o(^DHCEMRF.FavTagInformationI("IdxInfoIDTag",AFavInfoID,""))
	q:(rowId = "") result
	s objFavTag = ##Class(EMRinstance.Favorites.FavTag).%OpenId(rowId)
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
	s objPreFavTag = ##Class(EMRinstance.Favorites.FavTag).%OpenId(APreID)
	q:(objPreFavTag = "")
	s objNextFavTag = ##Class(EMRinstance.Favorites.FavTag).%OpenId(ANextID)
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
ClassMethod GetTagTree(AFavUserID As %String, AType As %String) As %GlobalCharacterStream
{
    s result = ##Class(%GlobalCharacterStream).%New()
	s count = 0
	q:(AFavUserID  = "") result
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s rowId = ""
	for
	{
		s rowId = $o(^DHCEMRF.FavTagI("IdxFavUserID"," "_AFavUserID,rowId))
		q:(rowId = "")
		s objTag = ##Class(EMRinstance.Favorites.FavTag).%OpenId(rowId)
		continue:(objTag = "")
		continue:((AType = "Share")&&(objTag.Type '= "Share"))
		s name = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRinstance.Favorites.FavTag","TagName",objTag.TagName,langid)
        d:(count '= 0) result.Write(",")
        d result.Write("{")
        d result.Write("""id"":"""_rowId_"""")
		d result.Write(",""text"":"""_name_"""")
        d result.Write(",""attributes"":{")
        d result.Write("""favUserId"":"""_AFavUserID_"""")
        d result.Write(",""type"":""KeyWord""")
        d result.Write("}")
        d result.Write("}")
		s count = count + 1
	}
	q result
}

}
