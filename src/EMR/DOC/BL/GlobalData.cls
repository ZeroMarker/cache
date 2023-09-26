/// 名称:	EMR.DOC.BL.GlobalData
/// 描述:	全局图表业务逻辑实现(门诊、住院)
/// 编写者：yejian
/// 编写日期: 2023-2-24
/// 产品组：电子病历产品组
Class EMR.DOC.BL.GlobalData Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取病历版本标识
/// Creator:    yejian
/// CreateDate: 2023-2-24
/// Table:		EMR_GB.GlobalData
/// Input:      argInJson  命令参数 {"product":"OP","action":"GET_VERSIONID","params":{"episodeID":"10209"}}
/// 			userLocID 科室ID，userID 用户ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetVersionID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s episodeID = argInJson.params.episodeID
    s strRes = ##Class(EMR.DOC.BL.GlobalData).GetVersionIDJson(episodeID,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取病历版本标识
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      aItem 个人短语对象
/// Output:     成功：1 失败  -1^失败信息
/// debug:  q ##Class(EMR.DOC.BL.GlobalData).GetVersionIDJson("10209")
ClassMethod GetVersionIDJson(aEpisodeID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(aEpisodeID="") "-1^就诊号不能为空"
    s strMark = ##Class(EMR.DOC.BL.GlobalData).GetEMRVersionID(aEpisodeID)
    s strMark=""""_strMark_""""
	d argOutData.Write(strMark)
	q strRes
}

/// Desc:       获取病历版本标识
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      aEpisodeID 就诊号
/// Output:     "" 没有写过病历，4：写过四版病历，3：写过三版病历，2：写过二版病历
/// debug:  q ##Class(EMR.DOC.BL.GlobalData).GetEMRVersionID("10209")
ClassMethod GetEMRVersionID(aEpisodeID As %String) As %String
{
	q:(aEpisodeID="") ""
    s id = $O(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_aEpisodeID, ""))
	q:(id '= "") "2"
	
	s id = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",aEpisodeID, ""))
	q:(id '= "") "3"
	
	s id = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_aEpisodeID, ""))
	q:(id '= "") "3"
	
	s id = $O(^EMR.GB.GlobalDataI("IdxMain",aEpisodeID, ""))
	q:(id '= "") "4"
	
	q ""
}

}
