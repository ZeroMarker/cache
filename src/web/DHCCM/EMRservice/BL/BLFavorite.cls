/// Desc:       收藏夹业务逻辑
/// Creator:    Candy
/// CreateDate: 2014-11-19
Class web.DHCCM.EMRservice.BL.BLFavorite Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       收藏夹目录及标签树
/// Creator:    Candy
/// CreateDate: 2014-11-26
/// Input:      AFavUserID 收藏用户ID
///            AType 加载类型
/// Debug:      w ##Class(EMRservice.BL.BLFavorite).GetFavTree(2)
ClassMethod GetFavTree(AFavUserID As %String, AType As %String) As %String
{
	s result = ""
	q:(AFavUserID = "") result
	s catalog = ##Class(web.DHCCM.EMRservice.BL.BLFavCatalog).GetFavCatalog(AFavUserID,"0",AType)
	s tag = ##Class(web.DHCCM.EMRservice.BL.BLFavTag).GetTagTree(AFavUserID,AType)
	s result = result_"{"
	s result = result_"""id"":""C"_AFavUserID_""""
	s result = result_",""text"":""<span style='font-weight:bold;'>收藏夹</span>"""
	s result = result_",""attributes"":{"
	s result = result_"""favUserId"":"""_AFavUserID_""""
	s result = result_",""type"":""CatalogRoot"""
	s result = result_"}"	
	s result = result_",""children"":["_catalog_"]"
	s result = result_"}"
	s result = result_","
	s result = result_"{"
	s result = result_"""id"":""T"_AFavUserID_""""
	s result = result_",""text"":""<span style='font-weight:bold;'>关键字</span>"""
	s result = result_",""attributes"":{"
	s result = result_"""favUserId"":"""_AFavUserID_""""
	s result = result_",""type"":""KeyWordRoot"""
	s result = result_"}"		
	s result = result_",""children"":["_tag_"]"
	s result = result_"}"
	q result
}

/// Desc:       收藏夹导航
/// Creator:    Candy
/// CreateDate: 2014-11-26
/// Input:      AUserID 用户ID
/// Output:     Json 串
/// Debug: 	   w ##Class(EMRservice.BL.BLFavorite).GetMyNavigation(105)
ClassMethod GetMyNavigation(AUserID As %String) As %String
{
	s result = ""
	q:(AUserID = "") result
	s rowId = $o(^DHCPHF.FavUserI("IdxUserID"," "_AUserID,""))
	q:(rowId = "") result
	s result = ..GetFavTree(rowId,"")
	q result
}

/// Desc: 共享收藏夹
/// Debug: w ##Class(EMRservice.BL.BLFavorite).GetShareNavigation(105)
ClassMethod GetShareNavigation(AUserID As %String) As %String
{
	s result = ""
	s rowId = ""
	s count = 0
	for
	{
		s rowId = $o(^DHCPHF.FavUserI("IdxType"," SHARE",rowId))
		q:(rowId = "")
		s objFavUser = ##Class(User.DHCPHFavUser).%OpenId(rowId)
		continue:(objFavUser = "")
		s userName = objFavUser.UserName
		s:(AUserID = objFavUser.UserID) userName = "我"
		s tmpFav = ..GetFavTree(rowId,"Share")
		s:(count '= 0) result = result_","
		s result = result_"{"
		s result = result_"""id"":"""_objFavUser.UserID_""""
		s result = result_",""text"":""<span style='font-weight:bold;font-size:12px;letter-spacing:1px;'>"_userName_"的共享收藏</span>"""
		s result = result_",""attributes"":{"
		s result = result_"""favUserId"":"""_rowId_""""
		s result = result_",""type"":""Root"""
		s result = result_"}"	
		s result = result_",""children"":["_tmpFav_"]"
		s result = result_"}"
		s count = count + 1
	}
	q result
}

/// 	Desc:		查询病历
/// Creator:    Candy
/// CreateDate: 2014-12-16
/// 	Input:      AValue 查询条件
/// Output:     返回符合条件信息
ClassMethod SelectInfo(AValue As %String, ALocation As %String) As %String
{
	s result = ""
	q:(AValue = "") result
	s result = ##Class(web.DHCCM.EMRservice.BL.BLFavInformation).Select(AValue,ALocation)
	q result
}

}
