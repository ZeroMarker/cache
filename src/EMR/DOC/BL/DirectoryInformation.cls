/// 名称:	EMR.DOC.BL.DirectoryInformation
/// 描述:	门诊病历 文档索引业务逻辑类
/// 编写者：yejian
/// 编写日期: 2022-5-24
/// 产品组：电子病历产品组
Class EMR.DOC.BL.DirectoryInformation Extends EMR.DOC.COM.ActionBase
{

/// Desc:       取文档目录信息
/// Creator:    yejian
/// CreateDate: 2022-5-24
/// Table:		EMR_OP.ECRecord 实例主表，EMR_OP.DocumentData 实例表
/// Input:      argInJson  命令参数 {"action":"LOAD_DOCUMENT_INDEX","params":{"documentID":"17|1"},"product":"OP"}
/// 			argInData 病历流数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetDocumentIndex(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s dtoItem = ##class(EMR.DOC.DTO.DirectoryInformation).%New()
	s dtoItem.DocumentID = argInJson.params.documentID
    s strRes = ##Class(EMR.DOC.BL.DirectoryInformation).GetDocumentIndexJson(dtoItem,.argOutData)
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
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取文档索引数据
/// Creator:    yejian
/// CreateDate: 2022-5-24
/// Input:      dtoInData 实例对象
/// OutPut:     成功 返回实例ID，
/// 			失败 -1^失败提示信息 
/// 				argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.OP.BL.DocumentData).GetDocumentIndexJson("YS01","TEMPLATE",.argOutData)
ClassMethod GetDocumentIndexJson(dtoInData As EMR.DOC.DTO.DirectoryInformation, ByRef argOutData As %GlobalBinaryStream) As %String
{
  	s strRes ="1"
    q:(dtoInData.DocumentID = "") "-1^入参实例ID为空"
    s strDocumentID = dtoInData.DocumentID
    s arrItem = ##class(%DynamicArray).%New()
   
    s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(strDocumentID)
    ;s objDocument = ##Class(EMR.DB.DocumentData).%OpenId(strDocumentID)
    q:(objDocument = "") "-1^根据是实例ID获取实例对象失败"
    s AEpisodeID = objDocument.EpisodeID.%Id()
    s docCategoryCode = $zcvt(objDocument.DOCCategoryCode,"U")
    s TILDocumentData = ##class(EMR.DAO.DocumentData).GetTureIndexLocation(AEpisodeID)
    s statue = $zcvt(objDocument.Status,"U")
    if (statue = "DELETE")||(objDocument.Serial '= "1")
    {
		d arrItem.%Push(strDocumentID)
    }
    else
    {
        
        // SAVE状态默认病程全部加载设置
        s date = ""
		for
		{
			s date = $o(@TILDocumentData@("IdxEpisodeDCCodeHDT",AEpisodeID," "_docCategoryCode,date))
			q:(date = "")
			s time = ""
			for
			{
				s time = $o(@TILDocumentData@("IdxEpisodeDCCodeHDT",AEpisodeID," "_docCategoryCode,date,time)) 
				q:(time = "")
				s subId =""
				for
				{
					s subId = $o(@TILDocumentData@("IdxEpisodeDCCodeHDT",AEpisodeID," "_docCategoryCode,date,time,subId)) 
					q:(subId = "")
					s objDoc = ##Class(EMR.DAO.DocumentData).doOpenByID(subId)
					//删除状态分开显示
					s curStatue = $zcvt(objDoc.Status,"U")
					continue:(curStatue="UNSAVE")
					continue:(curStatue="DELETE")||(objDoc.Serial '= "1")
					d arrItem.%Push(subId)
					
				}
			}
		}
        k objDocument,objDoc
    }
    d arrItem.%ToJSON(argOutData)
	q strRes
}

/// Desc:       取文档目录信息(ID加密)
/// Creator:    yejian
/// CreateDate: 2022-5-24
/// Table:		EMR_OP.ECRecord 实例主表，EMR_OP.DocumentData 实例表
/// Input:      argInJson  命令参数 {"action":"LOAD_DOCUMENT_INDEX","params":{"documentID":"17|1"},"product":"OP"}
/// 			argInData 病历流数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetEncDocumentIndex(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s dtoItem = ##class(EMR.DOC.DTO.DirectoryInformation).%New()
	s documentID = ##class(EMR.DOC.COM.EncryptionTool).GetUnEncDocId(argInJson.params.documentID)
	s dtoItem.DocumentID = documentID
    s strRes = ##Class(EMR.DOC.BL.DirectoryInformation).GetEncDocumentIndexJson(dtoItem,.argOutData)
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
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       取文档索引数据(ID加密)
/// Creator:    yejian
/// CreateDate: 2022-5-24
/// Input:      dtoInData 实例对象
/// OutPut:     成功 返回实例ID，
/// 			失败 -1^失败提示信息 
/// 				argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.OP.BL.DocumentData).GetDocumentIndexJson("YS01","TEMPLATE",.argOutData)
ClassMethod GetEncDocumentIndexJson(dtoInData As EMR.DOC.DTO.DirectoryInformation, ByRef argOutData As %GlobalBinaryStream) As %String
{
  	s strRes ="1"
    q:(dtoInData.DocumentID = "") "-1^入参实例ID为空"
    s strDocumentID = dtoInData.DocumentID
    s arrItem = ##class(%DynamicArray).%New()
   
    s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(strDocumentID)
    ;s objDocument = ##Class(EMR.DB.DocumentData).%OpenId(strDocumentID)
    q:(objDocument = "") "-1^根据是实例ID获取实例对象失败"
    s AEpisodeID = objDocument.EpisodeID.%Id()
    s docCategoryCode = $zcvt(objDocument.DOCCategoryCode,"U")
    s TILDocumentData = ##class(EMR.DAO.DocumentData).GetTureIndexLocation(AEpisodeID)
    s statue = $zcvt(objDocument.Status,"U")
    if (statue = "DELETE")||(objDocument.Serial '= "1")
    {
	    s subEncID = ##class(EMR.DOC.COM.EncryptionTool).GetEncDocId(strDocumentID)
		d arrItem.%Push(subEncID)
    }
    else
    {
        
        // SAVE状态默认病程全部加载设置
        s date = ""
		for
		{
			s date = $o(@TILDocumentData@("IdxEpisodeDCCodeHDT",AEpisodeID," "_docCategoryCode,date))
			q:(date = "")
			s time = ""
			for
			{
				s time = $o(@TILDocumentData@("IdxEpisodeDCCodeHDT",AEpisodeID," "_docCategoryCode,date,time)) 
				q:(time = "")
				s subId =""
				for
				{
					s subId = $o(@TILDocumentData@("IdxEpisodeDCCodeHDT",AEpisodeID," "_docCategoryCode,date,time,subId)) 
					q:(subId = "")
					s objDoc = ##Class(EMR.DAO.DocumentData).doOpenByID(subId)
					//删除状态分开显示
					s curStatue = $zcvt(objDoc.Status,"U")
					continue:(curStatue="UNSAVE")
					continue:(curStatue="DELETE")||(objDoc.Serial '= "1")
					s subEncID = ##class(EMR.DOC.COM.EncryptionTool).GetEncDocId(subId)
					d arrItem.%Push(subEncID)
				}
			}
		}
        k objDocument,objDoc
    }
    d arrItem.%ToJSON(argOutData)
	q strRes
}

}
