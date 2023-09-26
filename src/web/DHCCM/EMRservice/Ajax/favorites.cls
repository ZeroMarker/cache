/// Desc:      收藏夹
/// Creator:   bianshuai
/// CreateDate:2016-10-11
Class web.DHCCM.EMRservice.Ajax.favorites Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s action = $Get(%request.Data("Action",1),"")
	if (action = "GetFavUserID")
	{
		s userID = $Get(%request.Data("UserID",1),"")
		s result = ##Class(web.DHCCM.EMRservice.BL.BLFavUser).GetFavUserID(userID)
		w result
	}
	//我的收藏目录
	elseif (action = "GetFavCatalog")
	{
		s favUserId = $Get(%request.Data("FavUserID",1),"")
		s result = ##Class(web.DHCCM.EMRservice.BL.BLFavCatalog).GetFavCatalog(favUserId,0,"")
		w "["_result_"]"	
	}
	//添加收藏
	elseif (action = "AddFavorite") 
	{
		s patientNo = $Get(%request.Data("PatientNo",1),"")
		s favUserId = $Get(%request.Data("FavUserID",1),"")
		s catalogId = $Get(%request.Data("CatalogID",1),"")
		s memo = $Get(%request.Data("Memo",1),"")
		s tags = $Get(%request.Data("Tags",1),"")
		s episodeId = $Get(%request.Data("EpisodeID",1),"")
		s instanceId = $Get(%request.Data("InstanceID",1),"")
		s:(instanceId = "undefined") instanceId = "" 
		w ##Class(web.DHCCM.EMRservice.BL.BLFavInformation).AddFavInformation(patientNo,favUserId,catalogId,memo,tags,episodeId,instanceId)
	}
	//收藏导航
	elseif (action = "GetMyNavigation") 
	{
		s userID = $Get(%request.Data("UserID",1),"")
		s result = ##Class(web.DHCCM.EMRservice.BL.BLFavorite).GetMyNavigation(userID)
		w "["_result_"]"
	}
	//共享导航
	elseif (action = "GetShareNavigation") 
	{
		s userID = $Get(%request.Data("UserID",1),"")	
		s result = ##Class(web.DHCCM.EMRservice.BL.BLFavorite).GetShareNavigation(userID)
		w "["_result_"]"	
	}
	//取目录下病例
	elseif (action = "GetFavInfoByCataLog")
	{
		s favUserId = $Get(%request.Data("FavUserID",1),"")
		s catalogId = $Get(%request.Data("CatalogID",1),"")
		s type = $Get(%request.Data("Type",1),"")
		s result = ##Class(web.DHCCM.EMRservice.BL.BLFavInformation).GetFavInfoByCataLog(favUserId,catalogId,type)
		w result
	}
	//收藏病例的病历文书
	elseif (action = "GetFavRecords") 
	{
		s favInfoId = $Get(%request.Data("FavInfoID",1),"")
		s result = ##Class(web.DHCCM.EMRservice.BL.BLFavInformation).GetFavRecords(favInfoId)
		w "["_result_"]"
	}
	//添加目录
	elseif (action = "AddCatalog")  
	{
		s parent = $Get(%request.Data("ParentID",1),"")
		s favUserId = $Get(%request.Data("FavUserID",1),"")
		s catalogName = $Get(%request.Data("CatalogName",1),"")
		s result = ##Class(web.DHCCM.EMRservice.BL.BLFavCatalog).CreateFavCatalog(parent,catalogName,favUserId)
		w result
	}
	// 添加标签
	elseif (action = "AddTag") 
	{
		s favUserId = $Get(%request.Data("FavUserID",1),"")
		if (favUserId = "")
		{
			s userId = $Get(%request.Data("UserID",1),"")
			s favUserId = $o(^DHCPHF.FavUserI("IdxUserID"," "_userId,""))
		}
		s tagName = $Get(%request.Data("TagName",1),"")
		s result = ##Class(web.DHCCM.EMRservice.BL.BLFavTag).AddFavTag(tagName,favUserId)
		w result
	}
	//加载标签
	elseif (action = "GetTags") 
	{
		s userId = $Get(%request.Data("UserID",1),"")
		s favUserId = $o(^DHCPHF.FavUserI("IdxUserID"," "_userId,""))
		if (favUserId '= "")
		{
			s result = ##Class(web.DHCCM.EMRservice.BL.BLFavTag).GetTagTree(favUserId,"")
		}
		else
		{
			s result = ""
		}
		w "["_result_"]"
	}
	//将病例增加到标签
	elseif (action = "AddInfoToTag") 
	{
		s tag = $Get(%request.Data("Tag",1),"")
		s favInfoId = $Get(%request.Data("FavInfoID",1),"")
		s result = ##Class(web.DHCCM.EMRservice.BL.BLFavTagInformation).AddInfotoTag(tag,favInfoId)
		w result
	}
	//根据标签取病例
	elseif (action = "GetInfoByTag") 
	{
		s tagId = $Get(%request.Data("TagID",1),"")
		s type = $Get(%request.Data("Type",1),"")
		s result = ##Class(web.DHCCM.EMRservice.BL.BLFavTagInformation).GetInfoByTag(tagId,type)
		w result
	}
	//未收藏病历
	elseif (action = "GetNoFavRecords") 
	{
		s favInfoId = $Get(%request.Data("FavInfoID",1),"")
		s episodeId = $Get(%request.Data("EpisodeID",1),"")
		s result = ##Class(web.DHCCM.EMRservice.BL.BLFavInformation).GetNoFavRecords(favInfoId,episodeId)
		w "["_result_"]"
	}
	//添加病历文书收藏
	elseif (action = "AddFavRecord") 
	{
		s favInfoId = $Get(%request.Data("FavInfoID",1),"")
		s episodeId =  $Get(%request.Data("EpisodeID",1),"")
		s instanceId =  $Get(%request.Data("InstanceID",1),"")
		s result = ##Class(web.DHCCM.EMRservice.BL.BLFavInformation).AddFavRecord(favInfoId,episodeId,instanceId)
		w result
	}
	//取消病历
	elseif (action = "CancelFavRecrod") 
	{
		s favInfoId = $Get(%request.Data("FavInfoID",1),"")
		s episodeId =  $Get(%request.Data("EpisodeID",1),"")
		s instanceId =  $Get(%request.Data("InstanceID",1),"")
		s result = ##Class(web.DHCCM.EMRservice.BL.BLFavInformation).CancelFavRecrod(favInfoId,episodeId,instanceId)
		w result
	}
	//取消病例收藏
	elseif (action = "DeleteFavInfomation") 
	{
		s favInfoId = $Get(%request.Data("FavInfoID",1),"")
		s result = ##Class(web.DHCCM.EMRservice.BL.BLFavInformation).DeleteFavInfo(favInfoId)
		w result
	}
	//更改病历节点
	elseif (action = "ModifyInfoCatalog") 
	{
		s favInfoId = $Get(%request.Data("FavInfoID",1),"")
		s catalogId =  $Get(%request.Data("CatalogID",1),"")
		s result = ##Class(web.DHCCM.EMRservice.BL.BLFavInformation).ModifyInfoCatalog(favInfoId,catalogId)
		w result	
	}
	//修改备注
	elseif (action = "ModifyInfoMemo") 
	{
		s favInfoId = $Get(%request.Data("FavInfoID",1),"")
		s memo = $Get(%request.Data("Memo",1),"")
		s result = ##Class(web.DHCCM.EMRservice.BL.BLFavInformation).ModifyInfoMemo(favInfoId,memo)
		w result
	}
	//共享病历
	elseif (action = "ShareInfomation") 
	{
		s favInfoId = $Get(%request.Data("FavInfoID",1),"")
		s dirType = $Get(%request.Data("DirType",1),"")
		s result = ##Class(web.DHCCM.EMRservice.BL.BLFavInformation).ShareFavInfo(favInfoId,dirType)
		w result
		
	}
	//取病例信息 
	elseif (action = "GetInfoByID") 
	{
		s favInfoId = $Get(%request.Data("FavInfoID",1),"")
		s result = ##Class(web.DHCCM.EMRservice.BL.BLFavInformation).GetFavInfo(favInfoId)
		w "["_result_"]"
	}
	//保存评价
	elseif (action = "SaveComment")
	{
		s favInfoId = $Get(%request.Data("FavInfoID",1),"") 
		s content = $Get(%request.Data("Content",1),"") 
		s userId = $Get(%request.Data("UserID",1),"") 
		//新增评论人科室字段userLocCode
		s userLocCode = $Get(%request.Data("UserLocCode",1),"")
		s instanceId = $Get(%request.Data("InstanceID",1),"") 
		s scores = $Get(%request.Data("Scores",1),"") 
		s result = ##Class(web.DHCCM.EMRservice.BL.BLFavRecordComment).SaveComment(favInfoId,content,userId,userLocCode,instanceId,scores)
		w "["_result_"]"
	}
	//显示评价
	elseif (action = "GetComment")
	{
		s favInfoId = $Get(%request.Data("FavInfoID",1),"") 
		s instanceId = $Get(%request.Data("InstanceID",1),"") 
		s result = ##Class(web.DHCCM.EMRservice.BL.BLFavRecordComment).GetComment(favInfoId,instanceId)
		w "["_result_"]"
	 //显示相关页评价
	}elseif (action="GetCurComment"){
		s favInfoId = $Get(%request.Data("FavInfoID",1),"") 
		s instanceId = $Get(%request.Data("InstanceID",1),"") 
		s pageIndex = $Get(%request.Data("PageIndex",1),"")
		s pageSize = $Get(%request.Data("PageSize",1),"")
		s result=##Class(web.DHCCM.EMRservice.BL.BLFavRecordComment).GetCurComment(favInfoId,instanceId,pageIndex,pageSize)
		w "["_result_"]"
		}
	//取病例所在标签
	elseif (action = "GetTagsByInfoID")
	{
		s favInfoId = $Get(%request.Data("FavInfoID",1),"") 
		s result = ##Class(web.DHCCM.EMRservice.BL.BLFavInformation).GetTagsByInfoID(favInfoId)
		w "["_result_"]"
	}
	//保存评论回复
	elseif (action = "SetReplyComment")
	{
		s commentId = $Get(%request.Data("CommentID",1),"") 
		s parentId = $Get(%request.Data("ParentID",1),"")
		s content = $Get(%request.Data("Content",1),"") 
		s userId = $Get(%request.Data("UserID",1),"") 
		s result = ##Class(web.DHCCM.EMRservice.BL.BLFavRecordComment).SetCommentRelay(commentId,parentId,content,userId)
		w result
	}
	//读取评论回复
	elseif (action = "GetReplyComment")
	{
		s commentId = $Get(%request.Data("CommentID",1),"")  
		s parentId = $Get(%request.Data("ParentID",1),"")
		s result = ##Class(web.DHCCM.EMRservice.BL.BLFavRecordComment).GetCommentRelay(commentId,parentId)
		w "["_result_"]"
	}
	//检索病历
	elseif (action = "SelectInfo")
	{
		s value = $Get(%request.Data("Value",1),"")
		s location = $Get(%request.Data("Location",1),"")
		s result = ##Class(web.DHCCM.EMRservice.BL.BLFavorite).SelectInfo(value,location)
		w result
	}
	//取消共享病例
	elseif (action = "UnShareFavInfo")
	{
		s favInfoId = $Get(%request.Data("FavInfoID",1),"") 
		s result = ##Class(web.DHCCM.EMRservice.BL.BLFavInformation).UnShareFavInfo(favInfoId)
		w result 	
	}
	//修改目录名称
	elseif (action = "UpdateCatalogTagName")
	{
		s id = $Get(%request.Data("ID",1),"")  
		s name = $Get(%request.Data("Name",1),"")	
		s type = $Get(%request.Data("Type",1),"")
		if (type = "Catalog")
		{
			s result = ##Class(web.DHCCM.EMRservice.BL.BLFavCatalog).UpdateFavCatalog(id,name)	
		}
		elseif (type = "KeyWord")
		{
			s result = ##Class(web.DHCCM.EMRservice.BL.BLFavTag).UpdateFavTag(id,name)
		}
		w result
	}
	elseif (action = "UnShareTree")
	{
		s dirType = $Get(%request.Data("DirType",1),"")
		s favInfoId = $Get(%request.Data("FavInfoID",1),"")
		s id = $Get(%request.Data("ID",1),"") 
		if (dirType = "Root")
		{
			s result = ##Class(web.DHCCM.EMRservice.BL.BLFavUser).ShareFavUser(favInfoId,"Private")
		}
		elseif (dirType = "CatalogRoot")
		{
			s result = ##Class(web.DHCCM.EMRservice.BL.BLFavCatalog).ShareCatalogByParentID(favInfoId,"0","Private")
		}
		elseif (dirType = "KeyWordRoot")
		{
			s result = ##Class(web.DHCCM.EMRservice.BL.BLFavTag).ShareAllTag(favInfoId,"Private")
		}
		elseif (dirType = "Catalog")
		{
			s result = ##Class(web.DHCCM.EMRservice.BL.BLFavCatalog).ShareFavCatalog(favInfoId,id,"Private")
		}
		elseif (dirType = "KeyWord")
		{
			s result = ##Class(web.DHCCM.EMRservice.BL.BLFavTag).ShareFavTag(id,"Private")
		}
		w result
	}
	Quit $$$OK
}

}
