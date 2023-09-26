/// Desc:       标签病例逻辑
/// Creator:    Candy
/// CreateDate: 2014-11-28
Class web.DHCCM.EMRservice.BL.BLFavTagInformation Extends (%RegisteredObject, %XML.Adaptor)
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
		s rowId = $o(^DHCPHF.FavTagInformationI("IdxTagID",ATagID,rowId))
		q:(rowId = "")
		s objTagInfo = ##Class(User.DHCPHFavTagInformation).%OpenId(rowId)
		continue:(objTagInfo = "")
		s infoId = objTagInfo.InformationID
		s objInfo = ##Class(User.DHCPHFavInformation).%OpenId(infoId)
		continue:((objInfo="")||((objInfo.Type '= "Share")&&(AType = "Share")))
		s infoJson = ##Class(web.DHCCM.EMRservice.BL.BLFavInformation).GetFavInfo(infoId)
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
		s tagId = $o(^DHCPHF.FavTagInformationI("IdxInfoIDTag",AInfoID,tagId))
		q:(tagId = "")
		s objTag = ##Class(User.DHCPHFavTag).%OpenId(tagId)
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
		s tagId = $o(^DHCPHF.FavTagInformationI("IdxTagInfoID",tagId))
		q:(tagId = "")
		s rowId = ""
		for
		{
			s rowId = $o(^DHCPHF.FavTagInformationI("IdxTagInfoID",tagId,rowId))
			q:(rowId = "")
			s tempResult = ##Class(web.DHCCM.EMRservice.BL.BLFavInformation).SelectByID(AValue,rowId)
			continue:(tempResult = "")
			s:(count '=0 ) result = result_","
			s result = result_tempResult
			s count = count + 1
		}
	}
	q "{""total"":["_result_"],""count"":"""_count_"""}"
}

}
