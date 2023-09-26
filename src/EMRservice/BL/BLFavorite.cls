/// Desc:       收藏夹业务逻辑
/// Creator:    Candy
/// CreateDate: 2014-11-19
Class EMRservice.BL.BLFavorite Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       收藏夹目录及标签树
/// Creator:    Candy
/// CreateDate: 2014-11-26
/// Input:      AFavUserID 收藏用户ID
///            AType 加载类型
/// Debug:      w ##Class(EMRservice.BL.BLFavorite).GetFavTree(2)
ClassMethod GetFavTree(AFavUserID As %String, AType As %String) As %GlobalCharacterStream
{
	s result = ##Class(%GlobalCharacterStream).%New()
	q:(AFavUserID = "") result
	s catalog = ##Class(EMRservice.BL.BLFavCatalog).GetFavCatalog(AFavUserID,"0",AType)
	s tag = ##Class(EMRservice.BL.BLFavTag).GetTagTree(AFavUserID,AType)
	d result.Write("{")
	d result.Write("""id"":""C"_AFavUserID_"""")
	d result.Write(",""text"":""<span style='font-weight:bold;'>")
	s favDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","收藏夹")
	d result.Write(favDesc)
	d result.Write("</span>""")
	d result.Write(",""attributes"":{")
	d result.Write("""favUserId"":"""_AFavUserID_"""")
	d result.Write(",""type"":""CatalogRoot""")	
	d result.Write("}")
	if (catalog.Size '= 0)
	{
		d result.Write(",""children"":[")
		d result.CopyFrom(catalog)
		d result.Write("]")
	}
	d result.Write("}")
	d result.Write(",")
	d result.Write("{")
	d result.Write("""id"":""T"_AFavUserID_"""")
	d result.Write(",""text"":""<span style='font-weight:bold;'>")
	s keyDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","关键字")
	d result.Write(keyDesc)
	d result.Write("</span>""")
	d result.Write(",""attributes"":{")
	d result.Write("""favUserId"":"""_AFavUserID_"""")
	d result.Write(",""type"":""KeyWordRoot""")	
	d result.Write("}")	
    if (tag.Size '= 0)
    {
        d result.Write(",""children"":[")
        d result.CopyFrom(tag)
        d result.Write("]")
    }
	d result.Write("}")
	q result
}

/// Desc:       收藏夹导航
/// Creator:    Candy
/// CreateDate: 2014-11-26
/// Input:      AUserID 用户ID
/// Output:     Json 串
/// Debug: 	   w ##Class(EMRservice.BL.BLFavorite).GetMyNavigation(105)
ClassMethod GetMyNavigation(AUserID As %String) As %GlobalCharacterStream
{
	s result = ##Class(%GlobalCharacterStream).%New()
	s json = ##Class(%GlobalCharacterStream).%New()
	q:(AUserID = "") result
	s rowId = $o(^DHCEMRF.FavUserI("IdxUserID"," "_AUserID,""))
	q:(rowId = "") result
	d result.Write("[")
	s json = ..GetFavTree(rowId,"")
	d result.CopyFrom(json)
	d result.Write("]")
	q result
}

/// Desc: 共享收藏夹
/// Debug: w ##Class(EMRservice.BL.BLFavorite).GetShareNavigation(105)
ClassMethod GetShareNavigation(AUserID As %String) As %GlobalCharacterStream
{
	s result = ##Class(%GlobalCharacterStream).%New()
	s rowId = ""
	s count = 0
	d result.Write("[")
	for
	{
		s rowId = $o(^DHCEMRF.FavUserI("IdxType"," SHARE",rowId))
		q:(rowId = "")
		s objFavUser = ##Class(EMRinstance.Favorites.FavUser).%OpenId(rowId)
		continue:(objFavUser = "")
		s userName = objFavUser.UserName
		s:(AUserID = objFavUser.UserID) userName = "我"
		s tmpFav = ..GetFavTree(rowId,"Share")
		if (count '= 0)
		{
			d result.Write(",")
		}
		d result.Write("{")
		d result.Write("""id"":"""_objFavUser.UserID_"""")
		d result.Write(",""text"":""<span style='font-weight:bold;font-size:12px;letter-spacing:1px;'>"_userName_"的共享收藏</span>""")
		d result.Write(",""attributes"":{")
		d result.Write("""favUserId"":"""_rowId_"""")
		d result.Write(",""type"":""Root""")
		d result.Write("}")
		d result.Write(",""children"":[")
		d result.CopyFrom(tmpFav)
		d result.Write("]")
		d result.Write("}")
		s count = count + 1
	}
	d result.Write("]")
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
	s result = ##Class(EMRservice.BL.BLFavInformation).Select(AValue,ALocation)
	q result
}

}
