/// 名称:	EMR.DOC.BL.RefreshDataHidden
/// 描述:	不需要显示的同步数据业务逻辑
/// 编写者：yejian
/// 编写日期: 2022-6-14
/// 产品组：电子病历产品组
Class EMR.DOC.BL.RefreshDataHidden Extends EMR.DOC.COM.ActionBase
{

/// Desc:       设置不需要显示的同步数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		CF.EMR.OP.SysOption 门急诊系统参数表
/// Input:      argInJson  命令参数 {"action":"SET_REFRESHDATA_HIDDENCODE","params":{"DocumentID":"1||1","hiddenCode":["T1653979802234","M1653979771618"]},"product":"OP"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod SetRefreshDataHiddenCode(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strDocumentID = argInJson.params.documentID
	s arrHiddenCode = argInJson.params.hiddenCode
    s strRes = ##Class(EMR.DOC.BL.RefreshDataHidden).SetRefreshDataHiddenCodeJson(strDocumentID,arrHiddenCode,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1")
	{
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","更新数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取不需要显示的同步数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		CF.EMR.OP.SysOption 门急诊系统参数表
/// Input:      argInJson  命令参数 {"action":"GET_REFRESHDATA_HIDDENCODE","params":{"DocumentID":"1||1"},"product":"OP"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetRefreshDataHiddenCode(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strDocumentID = argInJson.params.documentID
    s strRes = ##Class(EMR.DOC.BL.RefreshDataHidden).GetRefreshDataHiddenCodeJson(strDocumentID,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       设置不需要显示的同步数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		EMR.OP.RefreshDataHidden 不需要显示的同步数据
/// Input: 		aDocumentID:实例ID
/// 			aHiddenCode:隐藏的编码数组
/// 			argOutData json数据
/// Output:     成功：1 失败 -1^失败信息 
/// debug:  s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.OP.BL.SysOption).LoadGlobalParametersJson(.obj)
ClassMethod SetRefreshDataHiddenCodeJson(aDocumentID As %String, aHiddenCode As %DynamicAbstractObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s $zt = "Error"
	q:(aDocumentID="") "-1^实例ID不能为空"
	q:(aHiddenCode="")||(aHiddenCode.%Size()=0) "-1^不需要显示的编码不能为空"
	
	s objInstance = ##class(EMR.DAO.DocumentData).doOpenByID(aDocumentID)
	q:(objInstance="") "-1^根据实例ID获取实例对象失败"
	s AEpisodeID = objInstance.EpisodeID.%Id()
	s TILSynDataConfig= ##class(EMR.DAO.SynDataConfig).GetTureIndexLocation(AEpisodeID)
 	Tstart
 	s strMark = "1"
 	s iter = aHiddenCode.%GetIterator()
 	while iter.%GetNext(.key,.item) {
	 	s strCode = item
	 	continue:(strCode="")
		s rowId = $o(@TILSynDataConfig@("IdxIDCode"," "_aDocumentID," "_$zcvt(strCode,"U"),""))
		continue:(rowId'="")
		s obj = ##class(EMR.DAO.SynDataConfig).doCreateInstance(AEpisodeID)
		s obj.DocumentID = aDocumentID
		s obj.Code = strCode
		s sc = obj.%Save()
		if ('sc) 
		{
			s strMark="-1"
			break
		}
 	}
 	if (strMark="1")
 	{
	 	TCOMMIT
 	}
 	else
 	{
	 	Trollback
	 	s strRes = ""
 	}
	d argOutData.Write(strRes)
	q strRes
Error
	Trollback
	q "-1^更新数据失败"
}

/// Desc:       获取不需要显示的同步数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		EMR.OP.RefreshDataHidden 不需要显示的同步数据
/// Input: 		aDocumentID:实例ID
/// 			argOutData json数据
/// Output:     成功：1 失败 -1^失败信息 
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.DOC.BL.RefreshDataHidden).GetRefreshDataHiddenCodeJson("1||1",.obj)
ClassMethod GetRefreshDataHiddenCodeJson(aDocumentID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(aDocumentID="") "-1^实例ID不能为空"
    s jsonArr  = ##class(%DynamicArray).%New()
    s objInstance = ##class(EMR.DAO.DocumentData).doOpenByID(aDocumentID)
	q:(objInstance="") "-1^根据实例ID获取实例对象失败"
	s AEpisodeID = objInstance.EpisodeID.%Id()
	s TILSynDataConfig= ##class(EMR.DAO.SynDataConfig).GetTureIndexLocation(AEpisodeID)
    s rowId= ""
	for{
		s rowId= $o(@TILSynDataConfig@("IdxDocumentID"," "_aDocumentID,rowId))
		q:(rowId = "")
		s obj = ##class(EMR.DAO.SynDataConfig).doOpenByID(AEpisodeID,rowId)
		d jsonArr.%Push(obj.Code)
	}
	d:(jsonArr.%Size()>0) jsonArr.%ToJSON(argOutData)
	q strRes
}

}
