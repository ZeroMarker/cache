/// 名称:	EMR.DOC.BL.EMRTSchemeNavTest
/// 描述:	病历导航测试
/// 编写者：huhao
/// 编写日期: 2022-7-25
/// 产品组：电子病历产品组
Class EMR.DOC.BL.EMRTSchemeNavTest Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取病历导航测试返回数据
/// Creator:    huhao
/// CreateDate: 2022-7-25
/// Input:      argArray  命令参数
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetNavTestData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s episodeID=argInJson.params.episodeID
	s userLocID=argInJson.params.userLocID
	s ssgroupID=argInJson.params.ssgroupID
	s langID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
    s strRes = ##Class(EMR.DOC.BL.EMRTSchemeNavTest).GetTestData(userLocID,ssgroupID,episodeID,langID,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes["-1^")
	{
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE) 
	q ..SetOutMessage(argOutMessage,"ERROR")
}

ClassMethod GetTestData(userLocID As %String, ssgroupID As %String, episodeID As %String, aLangid As %String = "20", ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes=""
	s resJson=##class(%DynamicArray).%New()
	s resData =##class(%ResultSet).%New("EMR.DOC.BL.EMRCategory:GetCategory")
	d resData.Execute(userLocID,ssgroupID,episodeID,aLangid)
	q:resData="" "-1^当前用户无可访问页面"
	while(resData.%Next())
	{
		s resobj=##class(%DynamicObject).%New()
		s resobj.ID=resData.Data("ID")
		s resobj.DOCCategoryCode=resData.Data("DOCCategoryCode")
		s resobj.ItemURL=resData.Data("ItemURL")
		s resobj.ItemParas=resData.Data("ItemParas")
		s resobj.ItemTitle=resData.Data("ItemTitle")
		s resobj.recordFlag=resData.Data("recordFlag")
		d resJson.%Push(resobj)
		s strRes="1"
	}
	d resJson.%ToJSON(argOutData)
	q strRes
}

}
