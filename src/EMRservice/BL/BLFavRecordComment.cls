/// Desc:      病历评价逻辑
/// Creator:   Candy
/// CreateDate:2014-12-9
Class EMRservice.BL.BLFavRecordComment Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc: 	  保存评论
/// Creator：  Candy
/// CreateDate:2014-12-9
ClassMethod SaveComment(AFavInfoID As %String, AContent As %String, AUserID As %String, AUserLocCode As %String, AInstanceID As %String, AScores As %String) As %String
{
	s result = ""
	q:(AContent = "")||(AFavInfoID="")||(AInstanceID="") result
	s objComment = ##Class(EMRinstance.Favorites.FavRecordComment).%New()
	s objComment.Content = AContent
	s objComment.InstanceID = AInstanceID
	s objComment.OPDate = $p($h,",",1)
	s objComment.OpTime = $p($h,",",2)
	s objComment.Scores = $case(AScores '= "",1:AScores,:0)
	s objComment.UserID = AUserID
	//新增评论人科室字段AUserLocCode
	s locRowId = ""
    s locRowId = $o(^CTLOC(0,"Code",AUserLocCode,locRowId))
    s locDesc = $p($g(^CTLOC(locRowId)),"^",2)
    s:(locDesc [ "-") locDesc = $p(locDesc,"-",2)
    s objComment.UserLocCode = locDesc
	s objComment.FavInfoID = AFavInfoID
	if ($$$ISOK(objComment.%Save()))
	{
		s HISFormatDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",$p($h,",",1))
		s HISFormatTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",$p($h,",",2))
		s result = result_"{"
		s result = result_"""id"":"""_objComment.%Id()_""""
		s result = result_",""content"":"""_AContent_""""
		s result = result_",""datetime"":"""_HISFormatDate_" "_HISFormatTime_""""
		s result = result_",""score"":"""_$case(AScores '= "",1:AScores,:0)_""""
		s result = result_",""userId"":"""_AUserID_""""
		s userName = ##class(EMRservice.BL.BLPowerUser).GetUserName(AUserID)
		s result = result_",""userName"":"""_userName_""""
		//新增评论人科室字段AUserLocCode
		s result = result_",""userLoc"":"""_locDesc_""""
		s result = result_"}"

	}
	q result
}

/// Desc:  		取评论信息
/// Creator:		Candy
/// CreateDate:	2014-12-9
/// Debug:		w ##Class(EMRservice.BL.BLFavRecordComment).GetComment(4,"2||1")
ClassMethod GetComment(AFavInfoID As %String, AInstanceID As %String) As %String
{
	s result = ""
	s count = 0
	q:(AFavInfoID = "")||(AInstanceID = "") result
	s rowId = ""
	for
	{
		s rowId = $o(^DHCEMRF.FavRecordCommentI("IdxFavInstanceID"," "_AFavInfoID," "_AInstanceID,rowId))
		q:(rowId = "")
		s objComment = ##Class(EMRinstance.Favorites.FavRecordComment).%OpenId(rowId)
		continue:(objComment = "")
		s:(count '= 0) result = result_","
		s result = result_"{"
		s result = result_"""id"":"""_rowId_""""
		s result = result_",""content"":"""_objComment.Content_""""
		s result = result_",""datetime"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",$zd(objComment.OPDate,3)_" "_$zt(objComment.OpTime))_""""
		s result = result_",""score"":"""_objComment.Scores_""""
		s result = result_",""userId"":"""_objComment.UserID_""""
		s userName = ##class(EMRservice.BL.BLPowerUser).GetUserName(objComment.UserID)
		s result = result_",""userName"":"""_userName_""""
		//获取评论人科室字段UserLocCode
		s result = result_",""userLoc"":"""_objComment.UserLocCode_""""
		s result = result_"}"
		s count = count + 1
	}
	q result
}

/// Desc:        插入评论回复
/// Creator: 	Candy
/// CreateDate: 	2014-12-12
/// Input:		ACommentID
/// 				AParentID
///             AContent
///         	AUserID
/// Ouput:       Json串
/// Debug:       w ##Class(EMRservice.BL.BLFavRecordComment).SetCommentRelay()		
ClassMethod SetCommentRelay(ACommentID As %String, AParentID As %String, AContent As %String, AUserID As %String)
{
	s result = ""
	q:(ACommentID = "")||(AParentID = "")||(AContent = "") result
	s objComment = ##Class(EMRinstance.Favorites.FavRecordComment).%OpenId(ACommentID)
	q:(objComment = "") result
	s objReply = ##Class(EMRinstance.Favorites.FavCommentReply).%New()
	s objReply.ParentID = AParentID
	s objReply.ParRef = objComment
	s objReply.ReplyContent = AContent
	s objReply.ReplyDate = $p($h,",",1)
	s objReply.ReplyTime = $p($h,",",2)
	s objReply.ReplyUser = AUserID
	s sc = objReply.%Save()
	if ($$$ISOK(sc))
	{
		s result = result_"{"
		s result = result_"""id"":"""_objReply.%Id()_""""
		s result = result_",""content"":"""_AContent_""""
		s result = result_",""parentId"":"""_AParentID_""""
		s result = result_",""commentId"":"""_ACommentID_""""
		s result = result_",""datetime"":"""_$zd(objReply.ReplyDate,3)_" "_$zt(objReply.ReplyTime)_""""
		s result = result_",""userId"":"""_AUserID_""""
		s userName = ##class(EMRservice.BL.BLPowerUser).GetUserName(AUserID)
		s userLoc = ##Class(EMRservice.BL.BLPowerUser).GetUserLoc(AUserID)
		s result = result_",""userName"":"""_userName_""""
		s result = result_",""userLoc"":"""_userLoc_""""
		s result = result_"}"
	}
	q result
}

/// Desc:       取评论回复
/// Creator:    Candy
/// CreateDate: 2012-12-12
/// Input:      ACommentID 评论ID
///            AParentID 父节点
/// OutPut:     json 串
/// Debug:      w ##Class(EMRservice.BL.BLFavRecordComment).GetCommentRelay(1,0)
ClassMethod GetCommentRelay(ACommentID As %String, AParentID As %String)
{
	s result = ""
	q:(ACommentID = "")||(AParentID = "") result
	s count = 0
	s subId = ""
	for
	{
		s subId = $o(^DHCEMRF.FavCommentReplyI("IdxParRefParentID",ACommentID,AParentID,subId))
		q:(subId = "")
		s rowId = ACommentID_"||"_subId
		s objReply = ##Class(EMRinstance.Favorites.FavCommentReply).%OpenId(rowId)
		continue:(objReply = "")
		s:(count '= 0) result = result_","
		s result = result_"{"
		s result = result_"""id"":"""_rowId_""""
		s result = result_",""content"":"""_objReply.ReplyContent_""""
		s result = result_",""parentId"":"""_objReply.ParentID_""""
		s result = result_",""commentId"":"""_ACommentID_""""
		s result = result_",""datetime"":"""_$zd(objReply.ReplyDate,3)_" "_$zt(objReply.ReplyTime)_""""
		s result = result_",""userId"":"""_objReply.ReplyUser_""""
		s userName = ##class(EMRservice.BL.BLPowerUser).GetUserName(objReply.ReplyUser)
		s userLoc = ##Class(EMRservice.BL.BLPowerUser).GetUserLoc(objReply.ReplyUser)
		s result = result_",""userName"":"""_userName_""""
		s result = result_",""userLoc"":"""_userLoc_""""
		s tempResult = ..GetCommentRelay(ACommentID,subId)
		s result = result_",""children"":["_tempResult_"]"
		s result = result_"}"
		s count = count + 1
	}
	q result
}

}
