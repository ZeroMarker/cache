/// Desc:       标签病例逻辑
/// Creator:    Candy
/// CreateDate: 2014-11-28
Class EMRservice.BL.BLFavTagInformation Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc: 添加标签病例
/// Debug: ##Class(EMRservice.BL.BLFavTagInformation).AddInfotoTag("1,2,3",7)
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
		s rowId = $o(^DHCEMRF.FavTagInformationI("IdxTagInfoID",tagId,AInformationID,""))
		if (flag = "false")
		{
			continue:(rowId = "")
			s sc = ##Class(EMRinstance.Favorites.FavTagInformation).%DeleteId(rowId)
			s:($$$ISERR(sc)) result = "0"		
		}
		else
		{
		    continue:(rowId '= "")
		    s objTagInfo = ##Class(EMRinstance.Favorites.FavTagInformation).%New()
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

/// Desc: 取标签下病例
/// Debug: w ##Class(EMRservice.BL.BLFavTagInformation).GetInfoByTag(1)
ClassMethod GetInfoByTag(ATagID As %String, AType As %String) As %String
{
	s result = ""
	q:(ATagID = "") result
	s count = 0
	s rowId = ""
	for
	{
		s rowId = $o(^DHCEMRF.FavTagInformationI("IdxTagID",ATagID,rowId))
		q:(rowId = "")
		s objTagInfo = ##Class(EMRinstance.Favorites.FavTagInformation).%OpenId(rowId)
		continue:(objTagInfo = "")
		s infoId = objTagInfo.InformationID
		s objInfo = ##Class(EMRinstance.Favorites.FavInformation).%OpenId(infoId)
		continue:((objInfo="")||((objInfo.Type '= "Share")&&(AType = "Share")))
		s infoJson = ##Class(EMRservice.BL.BLFavInformation).GetFavInfo(infoId)
		continue:(infoJson = "")
		s:(count '= 0) result = result_","
		s result = result_infoJson
		s count = count + 1
	}
	q "{""total"":["_result_"],""count"":"""_count_"""}"
}

/// Desc:		取病例所在标签
/// Creator:	Candy
/// CreateDate:	2014-12-12
/// Input:      AInfoID 病例ID
/// Output:     TagID json 串
/// Debug:      w ##class(EMRservice.BL.BLFavTagInformation).GetTagsByInfoID(4)
ClassMethod GetTagsByInfoID(AInfoID As %String) As %String
{
	s result = ""
	q:(AInfoID = "") result
	s count = 0
	s tagId = ""
	for
	{
		s tagId = $o(^DHCEMRF.FavTagInformationI("IdxInfoIDTag",AInfoID,tagId))
		q:(tagId = "")
		s objTag = ##Class(EMRinstance.Favorites.FavTag).%OpenId(tagId)
		continue:(objTag = "")
		s:(count '= 0) result = result_","
		s result = result_"{"
		s result = result_"""TagID"":"""_tagId_""""
		s result = result_",""TagName"":"""_objTag.TagName_""""
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
/// Debug:      w ##class(EMRservice.BL.BLFavTagInformation).Select("飘零")
ClassMethod Select(AValue As %String) As %String
{
	s result = ""
	q:(AValue = "") result
	s count = 0
	s tagId = ""
	for
	{
		s tagId = $o(^DHCEMRF.FavTagInformationI("IdxTagInfoID",tagId))
		q:(tagId = "")
		s rowId = ""
		for
		{
			s rowId = $o(^DHCEMRF.FavTagInformationI("IdxTagInfoID",tagId,rowId))
			q:(rowId = "")
			s tempResult = ##Class(EMRservice.BL.BLFavInformation).SelectByID(AValue,rowId)
			continue:(tempResult = "")
			s:(count '=0 ) result = result_","
			s result = result_tempResult
			s count = count + 1
		}
	}
	q "{""total"":["_result_"],""count"":"""_count_"""}"
}

}
