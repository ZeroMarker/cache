/// 名称:	EMR.OP.BL.KBNode
/// 描述:	门诊病历 Document(Doc) 文档片段业务类
/// 编写者：yejian
/// 编写日期: 2021-1-12
/// 产品组：电子病历产品组
Class EMR.OP.BL.KBNode Extends EMR.OP.COM.ActionBase
{

/// Desc:       加载片段内容
/// Creator:    yejian
/// CreateDate: 2021-7-27
/// Table:		CF_EMR_DOC.KBNode 文档片段表
/// Input:      argInJson  命令参数 {"action":"LOAD_KB_DOCUMENT","product":"GlobalEMR","params":{"id":"80||IT"}}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod LoadDocument(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s KBNodeID = ..GetIDByKey(argInJson.params.id)
    s strRes = ##Class(EMR.OP.BL.KBNode).LoadDocumentJson(KBNodeID,argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败,检查参数id",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","片段节点数据不存在，检查id参数",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       加载片段内容
/// Creator:    yejian
/// CreateDate: 2021-7-27
/// Input:     ANodeID 片段节点ID
/// Output:     成功：1 失败：     -200 必填项校验失败
/// 							   -301 片段节点不存在
/// debug : s AOutData = ##class(%GlobalBinaryStream).%New()
/// debug : ##Class(EMR.OP.BL.KBNode).LoadDocumentJson(14,AOutData)
ClassMethod LoadDocumentJson(aNodeID As %String, ByRef aArgOutData As %GlobalBinaryStream)
{
	q:(aNodeID="") "-200"
	s ObjNode = ##class(CF.EMR.DOC.KBNode).%OpenId(aNodeID)
	q:(ObjNode="") "-301"
	if (ObjNode.DocumentData.IsNull()=1){
		d aArgOutData.Write(..#NONE)
	}else {
		d ObjNode.DocumentData.Rewind()
		while (ObjNode.DocumentData.AtEnd = 0)
		{
			s tmpOut = ObjNode.DocumentData.Read(32000)
			s tmpUtf8 = $zcvt(tmpOut,"I","UTF8")

			d aArgOutData.Write(tmpUtf8)
		}
		
	}
	q "1"
}

/// Desc:       获取文档片段
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aParentId 目录ID
///             jsonCategory 目录json对象
/// Output:     q ##Class(EMR.DOC.BL.KBNode).GetKBNodeJsonByPID(1,"")
ClassMethod GetKBNodeJsonByPID(aParentId As %String, ByRef jsonCategory As %DynamicArray) As %String
{
	s res = "1"
	s rowID = $o(^CF.EMR.DOC.KBNodeI("IdxKBCategory",aParentId,""))
	s:(rowID="") res ="-1"
	s rowNID = ""
	for {
		s rowNID = $o(^CF.EMR.DOC.KBNodeI("IdxKBCategory",aParentId,rowNID))
		q:(rowNID = "")				
		s objKBNode = ##Class(CF.EMR.DOC.KBNode).%OpenId(rowNID)
	    continue:(objKBNode="")
	    s jsonSim  = ##class(%DynamicObject).%New()
	    s jsonSim.key = rowNID_"||IT"
	    s jsonSim.title = objKBNode.Name
	    s jsonSim.type = "IT"
	    s jsonSim.description = objKBNode.Description
	    s jsonSim.status = objKBNode.Status_""
		d jsonCategory.%Push(jsonSim)	
	}
	q res
}

}
