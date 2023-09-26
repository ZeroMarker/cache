/// Desc:      用户收藏夹
/// Creator:   Candy
/// CreateDate:2014-11-21
Class EMRservice.BL.BLFavUser Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:      添加收藏用户
/// Creator:   Candy
/// CeateDate: 2014-11-24
/// Input:     AUserID 用户ID
/// OutPut:    result 0 失败
/// Debug:     w ##Class(EMRservice.BL.BLFavUser).CreateFavUser(105)
ClassMethod CreateFavUser(AUserID As %String) As %String
{
	s result = "0"
	q:(AUserID = "") result
	s rowId = $o(^DHCEMRF.FavUserI("IdxUserID"," "_AUserID,""))
	if (rowId = "")
	{
		s objFavUser = ##Class(EMRinstance.Favorites.FavUser).%New()
		q:(objFavUser = "") result
	}
	else
	{
		s objFavUser = ##Class(EMRinstance.Favorites.FavUser).%OpenId(rowId)
		q:(objFavUser = "") result
	}

	s objUser = ##Class(User.SSUser).%OpenId(AUserID)
	s objFavUser.UserID = AUserID
	s objFavUser.UserCode = objUser.SSUSRInitials
	s objFavUser.UserLocID = objUser.SSUSRDefaultDeptDR.%Id()
	s objFavUser.UserName = objUser.SSUSRName
	s objFavUser.UserGorupID = objUser.SSUSRGroup.%Id()
	s objFavUser.UserLocDesc = objUser.SSUSRDefaultDeptDR.CTLOCDesc
	s objFavUser.UserGorupDesc = objUser.SSUSRGroup.SSGRPDesc
	s objFavUser.Type = "Private"
	s objUser = ""
	s:(objFavUser.%Save()) result = objFavUser.%Id()
	q result
}

/// Input:      AUserID 用户ID
/// Output:     result  目录结构
/// Debug:      w ##Class(EMRservice.BL.BLFavorite).GetFavTree(105)	
ClassMethod GetFavUserID(AUserID As %String) As %String
{
	s result = ""
	q:(AUserID = "") result
	s rowId = $o(^DHCEMRF.FavUserI("IdxUserID"," "_AUserID,""))
	if (rowId = "")
	{
		s rowId = ##Class(EMRservice.BL.BLFavUser).CreateFavUser(AUserID)
		q:(rowId = 0) result
	}
	s result = rowId
	q result
}

/// Desc:      取消收藏用户
/// Creator:   Candy
/// CreateDate:2015-1-28
/// Input:     AID FavUserID
///           AType Share/Private
/// Output:    result 成功1 失败0
/// Debug:     w ##Class(EMRservice.BL.BLFavUser).ShareFavUser(1,"Share")
ClassMethod ShareFavUser(AID As %String, AType As %String) As %String
{
	s result = "0"
	q:(AID = "") result
	s objFavUser = ##Class(EMRinstance.Favorites.FavUser).%OpenId(AID)
	q:(objFavUser = "") result
	s objFavUser.Type = AType
	Tstart
	s scUser = objFavUser.%Save()
	if ($$$ISOK(scUser))
	{
		s resultCatalog = ##Class(EMRservice.BL.BLFavCatalog).ShareCatalogByParentID(AID,"0",AType)
		if (resultCatalog '= "1")
		{
			Trollback
			q result
		}
		s resultTag = ##Class(EMRservice.BL.BLFavTag).ShareAllTag(AID,AType)
		if (resultTag '= "1")
		{
			Trollback
			q result
		} 
		Tcommit
		s result = "1"
	}
	q result
}

}
