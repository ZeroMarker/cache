/// Desc：  	图库逻辑
/// Creaotr:    Donglulu
/// CreateDate: 2017-8-7
Class EMRservice.BL.Image.BLImage Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:		查找图库AParentID下的目录信息
/// Creator:    Donglulu
/// CreateTime: 2017-08-08
/// Input:		AParentID:父节点rowID
/// OutPut:     Category 流数据
/// Debug:      w ##Class(EMRservice.BL.Image.BLImage).GetCategoryNodes(0)
ClassMethod GetCategoryNodes(AParentID As %String) As %Stream
{
	s categorySeq = ""
	s count = 0 
	s strJson = ##class(%GlobalCharacterStream).%New()
	q:(AParentID = "") strJson
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	d strJson.Write("[")
	for
	{
		s categorySeq = $o(^DHCEMRM.Image.CategoryI("IdxParentIDSequence",AParentID,categorySeq))
		q:(categorySeq = "")
		s categoryID = $o(^DHCEMRM.Image.CategoryI("IdxParentIDSequence",AParentID,categorySeq,""))
		q:(categoryID = "")
		s objCategory = ##Class(EMRmeta.Image.Category).%OpenId(categoryID)
		q:(objCategory = "")
		s categoryName = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(objCategory.Name)
		s categoryName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.Image.Category","Name",categoryName,langid)
		s categoryDesc = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(objCategory.Description)
		
		if (count '= 0)
		{
			d strJson.Write(",")
		}
		d strJson.Write("{""code"":"""_objCategory.Code_"""")
		d strJson.Write(",""name"":"""_categoryName_"""")
		d strJson.Write(",""id"":"""_objCategory.Code_"""")
		d strJson.Write(",""text"":"""_categoryName_"""")
		d strJson.Write(",""desc"":"""_categoryDesc_"""")
		d strJson.Write(",""categoryID"":"""_categoryID_"""")
		d strJson.Write("}")

		s count = count + 1
	}
	d strJson.Write("]")
    q strJson
}

/// Desc:		根据AParentCode查找图库AParentID下的目录信息
/// Creator:    Donglulu
/// CreateTime: 2017-08-08
/// Input:		AParentCode:父节点code
/// OutPut:     Category 流数据
/// Debug:      w ##Class(EMRservice.BL.Image.BLImage).GetCategoryByParentCode("head")
ClassMethod GetCategoryByParentCode(AParentCode As %String) As %Stream
{
	s strJson = ##class(%GlobalCharacterStream).%New()
	q:(AParentCode = "") strJson
	s parentID = $o(^DHCEMRM.Image.CategoryI("IdxCode"," "_$zcvt(AParentCode,"U"),""))
	q:(parentID = "") strJson
	s strJson = ##Class(EMRservice.BL.Image.BLImage).GetCategoryNodes(parentID)
	q strJson
}

/// Desc:		查询categoryID下的图片数据信息
/// Creator:    Donglulu
/// CreateTime: 2017-08-09
/// Input:		categoryID:目录rowID
/// OutPut:     item 流数据
/// Debug:      w ##Class(EMRservice.BL.Image.BLImage).getCommonImageItem(4)
ClassMethod getCommonImageItem(ACategoryID As %String, AUserID As %String = "") As %Stream
{
	s itemSeq = ""
	s count = 0 
	s strJson = ##class(%GlobalCharacterStream).%New()
	q:(ACategoryID = "") strJson
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	d strJson.Write("[")
	for
	{
		s itemSeq = $o(^DHCEMRM.Image.ItemI("IdxCategoryIDIsPublishSequence"," "_ACategoryID,1,itemSeq))
		q:(itemSeq = "")
		s itemID = $o(^DHCEMRM.Image.ItemI("IdxCategoryIDIsPublishSequence"," "_ACategoryID,1,itemSeq,""))
		q:(itemID = "")
		s objitem = ##Class(EMRmeta.Image.Item).%OpenId(itemID)
		q:(objitem = "")
		s itemName = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(objitem.Name)
		s itemName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.Image.Item","Name",itemName,langid)
		s itemDesc = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(objitem.Description)
		s favoriteFlag = 1
        s userImageID = ""
		s:(AUserID'="") userImageID = $o(^DHCEMRM.Image.UserImageI("IdxUserItemID",AUserID,itemID,""))
		s:(userImageID = "") favoriteFlag = 0
		if (count '= 0)
		{
			d strJson.Write(",")
		}
		d strJson.Write("{""code"":"""_objitem.Code_"""")
		d strJson.Write(",""name"":"""_itemName_"""")
		d strJson.Write(",""desc"":"""_itemDesc_"""")
		d strJson.Write(",""itemID"":"""_itemID_"""")
		d strJson.Write(",""imageType"":"""_objitem.ImageType_"""")
		d strJson.Write(",""favoriteFlag"":"""_favoriteFlag_"""")
		d strJson.Write("}")

		s count = count + 1
	}
	d strJson.Write("]")
    q strJson
}

/// Desc:		查询图片数据流
/// Creator:    Donglulu
/// CreateTime: 2017-08-11
/// Input:		itemID
/// OutPut:     item 图片流数据
/// Debug:      w ##Class(EMRservice.BL.Image.BLImage).GetImageData(4)
ClassMethod GetImageData(AItemID As %String) As %Stream
{
 
	s strJson = ##class(%GlobalCharacterStream).%New()
	q:(AItemID = "") strJson
	s objitem = ##Class(EMRmeta.Image.Item).%OpenId(AItemID)
	d strJson.CopyFrom(objitem.ImageData)
    q strJson
}

/// Desc:		加入个人图库
/// Creator:    Donglulu
/// CreateTime: 2017-08-10
/// Input:		AItemID:图库表ID
/// OutPut:     0:失败，1:成功
/// Debug:      w ##Class(EMRservice.BL.Image.BLImage).AddUserImage(1)
ClassMethod AddUserImage(AItemID As %String, AUserID As %String) As %String
{
	s result = 0
	q:((AItemID = "")||(AUserID = "")) result
	s userImageID = $o(^DHCEMRM.Image.UserImageI("IdxUserItemID",AUserID,AItemID,""))	
    if (userImageID = "")
    {
	    s objUserImage = ##Class(EMRmeta.Image.UserImage).%New()
		s objUserImage.ItemID = AItemID
		s objUserImage.UserID = AUserID
		s objUserImage.Frequency = 0
		s sc = objUserImage.%Save()
	    s:($$$ISOK(sc)) result = 1
	    d objUserImage.%Close()	
		k objUserImage
    }
    else
    {
	    s result = 1
    }
	
	q result
}

/// Desc:		删除个人图库中的图片
/// Creator:    Donglulu
/// CreateTime: 2017-08-10
/// Input:		AItemID:图库表ID AUserID用户ID
/// OutPut:     0:失败，1:成功
/// Debug:      w ##Class(EMRservice.BL.Image.BLImage).DeleteUserImage(34,4133)
ClassMethod DeleteUserImage(AItemID As %String, AUserID As %String) As %String
{
	s result = "0"
	q:((AItemID = "")||(AUserID = "")) result
	s rowId = $o(^DHCEMRM.Image.UserImageI("IdxUserItemID",AUserID,AItemID,""))	
	if (rowId = "") 
	{
		s result = "1"
		q result
	}
	s sc = ##Class(EMRmeta.Image.UserImage).%DeleteId(rowId)
	s:($$$ISOK(sc)) result = "1"
	q result
}

/// Desc:		查询个人图库数据
/// Creator:    Donglulu
/// CreateTime: 2017-08-10
/// Input:		AUserID
/// OutPut:     item 流数据
/// Debug:      w ##Class(EMRservice.BL.Image.BLImage).getUserImageItem(359)
ClassMethod getUserImageItem(AUserID As %String) As %Stream
{
	s itemSeq = ""
	s count = 0 
	s strJson = ##class(%GlobalCharacterStream).%New()
	q:(AUserID = "") strJson
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	d strJson.Write("[")
	for
	{
		s itemSeq = $o(^DHCEMRM.Image.UserImageI("IdxUserSequenceItemID",AUserID,itemSeq),-1)
		q:(itemSeq = "")
		s itemID = ""
		for
		{
			s itemID = $o(^DHCEMRM.Image.UserImageI("IdxUserSequenceItemID",AUserID,itemSeq,itemID))
			q:(itemID = "")
			s objitem = ##Class(EMRmeta.Image.Item).%OpenId(itemID)
			continue:(objitem = "")
			s userImageID = $o(^DHCEMRM.Image.UserImageI("IdxUserSequenceItemID",AUserID,itemSeq,itemID,""))
			q:(userImageID = "")
			s itemName = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(objitem.Name)
			s itemName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.Image.Item","Name",itemName,langid)
			s itemDesc = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(objitem.Description)
		
			if (count '= 0)
			{
				d strJson.Write(",")
			}
			d strJson.Write("{""code"":"""_objitem.Code_"""")
			d strJson.Write(",""name"":"""_itemName_"""")
			d strJson.Write(",""desc"":"""_itemDesc_"""")
			d strJson.Write(",""itemID"":"""_itemID_"""")
			d strJson.Write(",""userImageID"":"""_userImageID_"""")
			d strJson.Write(",""imageType"":"""_objitem.ImageType_"""")
			d strJson.Write("}")

			s count = count + 1
		}
	}
	d strJson.Write("]")
    q strJson
}

/// Desc:		更改个人图库使用频率
/// Creator:    Donglulu
/// CreateTime: 2017-08-10
/// Input:		AUserID
/// 			AItemID:图库表ID
/// OutPut:     1：成功 0：失败
/// Debug:      d ##Class(EMRservice.BL.Image.BLImage).changeUserIMGfreq(4133,34)
ClassMethod changeUserIMGfreq(AUserID As %String, AItemID As %String)
{
	s userImageID = $o(^DHCEMRM.Image.UserImageI("IdxUserItemID",AUserID,AItemID,""))
	q:(userImageID = "")
	s userImage = ##Class(EMRmeta.Image.UserImage).%OpenId(userImageID)
	q:(userImage = "")
	s userImage.Frequency = userImage.Frequency + 1
	d userImage.%Save()
	d userImage.%Close()	
	k userImage
}

/// Desc:		查找图库AParentID下的目录信息
/// Creator:    Donglulu
/// CreateTime: 2017-08-08
/// Input:		AParentID:父节点rowID
/// OutPut:     Category 流数据
/// Debug:      w ##Class(EMRservice.BL.Image.BLImage).GetCategory("")
ClassMethod GetCategory(AUserID As %String) As %Stream
{
    s strJson = ##class(%GlobalCharacterStream).%New()
	d strJson.Write("{""id"":""tongyong""")
	d strJson.Write(",""text"":""")
	s commonDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","通用图库")
	d strJson.Write(commonDesc)
	d strJson.Write("""")
	s child = ##Class(EMRservice.BL.Image.BLImage).GetCommonCategory(0)
	d strJson.Write(",""children"":") d strJson.CopyFrom(child)
	d strJson.Write("}")
	if (AUserID '= "")
	{
		d strJson.Write(",")
		d strJson.Write("{""id"":""geren""")
		d strJson.Write(",""text"":""")
		s personDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","个人图库")
		d strJson.Write(personDesc)
		d strJson.Write("""")
		d strJson.Write(",""nodetype"":""userItem""")
		d strJson.Write("}")
	}
    q strJson
}

/// Desc:		查找图库AParentID下的目录信息
/// Creator:    Donglulu
/// CreateTime: 2017-08-08
/// Input:		AParentID:父节点rowID
/// OutPut:     Category 流数据
/// Debug:      w ##Class(EMRservice.BL.Image.BLImage).GetCommonCategory("")
ClassMethod GetCommonCategory(AParentID As %String) As %Stream
{
	s categorySeq = ""
	s count = 0 
	s strJson = ##class(%GlobalCharacterStream).%New()
	q:(AParentID = "") strJson
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	d strJson.Write("[")
	for
	{
		s categorySeq = $o(^DHCEMRM.Image.CategoryI("IdxParentIDSequence",AParentID,categorySeq))
		q:(categorySeq = "")
		s categoryID = $o(^DHCEMRM.Image.CategoryI("IdxParentIDSequence",AParentID,categorySeq,""))
		q:(categoryID = "")
		s objCategory = ##Class(EMRmeta.Image.Category).%OpenId(categoryID)
		q:(objCategory = "")
		s categoryName = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(objCategory.Name)
		s categoryName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.Image.Category","Name",categoryName,langid)
		s categoryDesc = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(objCategory.Description)
		
		s child = ##class(%GlobalCharacterStream).%New()
		s countChild = 0
		s categorySeqChild = ""
		d child.Write("[")
		for
		{
			s categorySeqChild = $o(^DHCEMRM.Image.CategoryI("IdxParentIDSequence",categoryID,categorySeqChild))
			q:(categorySeqChild = "")
			s categoryIDChild = $o(^DHCEMRM.Image.CategoryI("IdxParentIDSequence",categoryID,categorySeqChild,""))
			q:(categoryIDChild = "")
			s objCategoryChild = ##Class(EMRmeta.Image.Category).%OpenId(categoryIDChild)
			q:(objCategoryChild = "")
			s categoryNameChild = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(objCategoryChild.Name)
			s categoryNameChild = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.Image.Category","Name",categoryNameChild,langid)
			s categoryDescChild = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(objCategoryChild.Description)
	
			if (countChild '= 0)
			{
				d child.Write(",")
			}
			d child.Write("{""code"":"""_objCategoryChild.Code_"""")
			d child.Write(",""name"":"""_categoryNameChild_"""")
			d child.Write(",""id"":"""_objCategoryChild.Code_"""")
			d child.Write(",""text"":"""_categoryNameChild_"""")
			d child.Write(",""desc"":"""_categoryDescChild_"""")
			d child.Write(",""categoryID"":"""_categoryIDChild_"""")
			d child.Write(",""nodetype"":""commonItem""")
			d child.Write("}")

			s countChild = countChild + 1
		}
		d child.Write("]")
		if (count '= 0)
		{
			d strJson.Write(",")
		}
		d strJson.Write("{""code"":"""_objCategory.Code_"""")
		d strJson.Write(",""name"":"""_categoryName_"""")
		d strJson.Write(",""id"":"""_objCategory.Code_"""")
		d strJson.Write(",""text"":"""_categoryName_"""")
		d strJson.Write(",""desc"":"""_categoryDesc_"""")
		d strJson.Write(",""categoryID"":"""_categoryID_"""")
		d strJson.Write(",""nodetype"":""commonCategoryID""")
		d strJson.Write(",""children"":") d strJson.CopyFrom(child)
		d strJson.Write("}")

		s count = count + 1
	}
	d strJson.Write("]")
    q strJson
}

}
