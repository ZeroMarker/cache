/// 名称:	EMR.DOC.BL.RoutingMenu
/// 描述:	通用文档管理模块 Document(Doc) 功能字典表
/// 编写者:	zzy
/// 编写日期: 	2021-11-11
/// 产品组：	电子病历产品组
Class EMR.DOC.BL.RoutingMenu Extends EMR.DOC.COM.ActionBase
{

/// Desc:      获取操作权限数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"GET_ROUTING_MENU", "params":{"userCode":"YS01" },"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetRoutingMenu(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s value = argInJson.params.value
	s jArryMeun = ##class(%DynamicArray).%New()
    s strRes = ##Class(EMR.DOC.BL.RoutingMenu).GetRoutingMenuJson(value,0,.jArryMeun)
	if (strRes = "1")
	{ 	
		d jArryMeun.%ToJSON(argOutData)
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = -101)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","id不能为空",2)
	}
	elseif (strRes = -102)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","数据表名不能为空",2)
	}
	elseif (strRes = -103)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","配置表不存在",2)
	}
	elseif (strRes = -104)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","数据表查询失败",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取操作权限数据
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      
/// 
ClassMethod GetRoutingMenuJson(SearchText As %String, ParentId As %String, ByRef jsonArr As %DynamicArray) As %String
{
	s strRes = "1"
	s seq = ""
	for {
		s seq = $o(^CT.EMR.DOC.DictFunctionI("IdxRowId",ParentId,seq))
		q:(seq = "")	
		s rowID = ""	
		for 
			{
			s rowID = $o(^CT.EMR.DOC.DictFunctionI("IdxRowId",ParentId,seq,rowID))
			q:(rowID = "")		
			s obj = ##Class(CT.EMR.DOC.DictFunction).%OpenId(rowID)
			continue:((obj="")  || ($find(obj.FuncName,SearchText) = 0))
			
			s jsonItem  = ##class(%DynamicObject).%New()
			s jsonItem.key = obj.%Id()	
        	s jsonItem.title = obj.FuncName
        	
        	s arrItem = ##class(%DynamicArray).%New()
			s result = ##class(EMR.DOC.BL.RoutingMenu).GetRoutingMenuJson(SearchText,jsonItem.key,.arrItem)
			if (arrItem.%Size() >0) {
					s jsonItem.children = arrItem
			}
			d jsonArr.%Push(jsonItem)
		
		}
	}
	q strRes
}

ClassMethod InitRoutingMenu(argFile As %String)
{
	k ^CT.EMR.DOC.DictFunctionI
	k ^CT.EMR.DOC.DictFunctionD
	s Stream=##class(%FileCharacterStream).%New()
	s Stream.Filename=argFile
	s FileCnt=1
	While 'Stream.AtEnd {
		s Line=Stream.ReadLine()
		s FuncCode = $p(Line,$c(9),2)
		s FuncName = $p(Line,$c(9),3)
		s ParentCode = $p(Line,$c(9),6)
		s ParentID = $p(Line,$c(9),7)
		s Sequence = $p(Line,$c(9),8)
		s Perms = $p(Line,$c(9),9)
		s Type = $p(Line,$c(9),10)
		s Compoent = $p(Line,$c(9),11)
		s Icon = $p(Line,$c(9),12)
		s Path = $p(Line,$c(9),13)
		s UpdateTime = $p(Line,$c(9),14)
		s Visible = $p(Line,$c(9),15)
		s obj=##Class(CT.EMR.DOC.DictFunction).%New()
		s obj.FuncCode = FuncCode
		s obj.FuncName = FuncName
		s obj.ParentCode = ParentCode
		s obj.ParentID = ParentID
		s obj.Sequence = Sequence
		s obj.Perms = Perms
		s obj.Type = ##class(CT.EMR.DOC.DictFunctionTypes).%OpenId(Type)
		s obj.Component = Compoent
		s obj.Icon = Icon
		s obj.Path = Path
		s obj.UpdateTime = UpdateTime
		s obj.Visible = Visible
		d obj.%Save()
		d obj.%Close()
		s obj=""
		
		s FileCnt=FileCnt+1
	}
	w !,"10_DictFunction: "_FileCnt_" rows imported"
	quit
}

}
