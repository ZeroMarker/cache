/// 名称:	EMR.DOC.BL.KBManage
/// 描述:	通用文档管理模块 Document(Doc) 文档片段统一逻辑管理类
/// 编写者：duan
/// 编写日期: 2021-05-06
/// 产品组：电子病历产品组
Class EMR.DOC.BL.KBManage Extends EMR.DOC.COM.ActionBase
{

/// Desc:       文档片段管理模块统一添加接口
/// Creator:    duan
/// CreateDate: 2021-05-10
/// Input:      argArray  	命令参数 {"action":"ADD_KB_MANAGE","params":{"id":173,"type":"CG"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod Add(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s type = ..GetTypeByKey(argInJson.params.id)
	;s argInJson.params.id = ..GetIDByKey(argInJson.params.id)
	s childType = $ZCVT(argInJson.params.childType,"U")
	if ((type="RT")||((type="CG")&&(childType="CG")))
	{
		//目录(根)节点上添加目录
		d ##Class(EMR.DOC.BL.KBCategory).AddCategory(argInJson,argInData,argOutMessage,argOutData)	
	}
	elseif((type="CG")&&(childType="DT"))
	{
		//目录节点上添加文档	
		d ##Class(EMR.DOC.BL.KBCategory).AddDocument(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif (type="DT")
	{
		/*文档节点上添加章节*/
		d ##Class(EMR.DOC.BL.KBCategory).AddSection(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif((type="ST")&&(childType="ST"))
	{
		/*章节节点上添加子章节*/
		d ##Class(EMR.DOC.BL.KBCategory).AddSubSection(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif((type="ST")&&(childType="KT"))
	{
		/*章节节点上添加分类*/
		d ##Class(EMR.DOC.BL.KBCategory).AddKBTree(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif((type="KT")&&(childType="KT"))
	{
		/*分类下添加分类*/
		d ##Class(EMR.DOC.BL.KBCategory).AddSubKBTree(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif((type="KT")&&(childType="IT"))
	{
		/*分类下添加片段*/
		d ##Class(EMR.DOC.BL.KBNode).AddNode(argInJson,argInData,argOutMessage,argOutData)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","类型不存在,检查参数id和childType",2)
	}
	q "1"
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       文档片段管理模块统一更新接口
/// Creator:    duan
/// CreateDate: 2021-05-10
/// Input:      argArray  	命令参数 {"action":"UPDATE_KB_MANAGE","params":{"id":173,"type":"CG"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod Update(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s type = ..GetTypeByKey(argInJson.params.id)
	s argInJson.params.id = ..GetIDByKey(argInJson.params.id)
	if (type="CG")||(type="RT")
	{
		/*更新目录*/
		d ##Class(EMR.DOC.BL.KBCategory).UpdateCategory(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif (type="DT")
	{
		/*更新文档*/
		d ##Class(EMR.DOC.BL.KBCategory).UpdateDocument(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif (type="ST")
	{
		/*更新章节*/
		d ##Class(EMR.DOC.BL.KBCategory).UpdateSection(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif(type="KT")
	{
		/*更新分类*/
		d ##Class(EMR.DOC.BL.KBCategory).UpdateKBTree(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif(type="IT")
	{
		/*更新片段*/
		d ##Class(EMR.DOC.BL.KBNode).UpdateNode(argInJson,argInData,argOutMessage,argOutData)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","类型不存在,检查参数id",2)
	}
	q "1"
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       文档片段管理模块统一删除接口
/// Creator:    duan
/// CreateDate: 2021-05-10
/// Input:      argArray  	命令参数 {"action":"UPDATE_KB_MANAGE","params":{"id":173,"type":"CG"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod Delete(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s type = ..GetTypeByKey(argInJson.params.id)
	s argInJson.params.id = ..GetIDByKey(argInJson.params.id)
	if (type="CG")
	{
		/*删除目录*/
		d ##Class(EMR.DOC.BL.KBCategory).DeleteCategory(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif (type="DT")
	{
		/*删除文档*/
		d ##Class(EMR.DOC.BL.KBCategory).DeleteDocument(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif (type="ST")
	{
		/*删除章节*/
		d ##Class(EMR.DOC.BL.KBCategory).DeleteSection(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif(type="KT")
	{
		/*删除分类*/
		d ##Class(EMR.DOC.BL.KBCategory).DeleteKBTree(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif(type="IT")
	{
		/*删除片段*/
		d ##Class(EMR.DOC.BL.KBNode).DeleteNode(argInJson,argInData,argOutMessage,argOutData)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","类型不存在,检查参数id",2)
	}
	q "1"
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:      文档片段目录排序
/// Creator:    huhao
/// CreateDate: 2022-9-1
/// Table:		CF.EMR.DOC.KBCategory
/// Input:      id:目录ID
/// 				operation：操作参数  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod SortCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s id=..GetIDByKey(argInJson.params.id)
	s type=..GetTypeByKey(argInJson.params.id)
	s operation=argInJson.params.operation
   	s strRes = ##class(EMR.DOC.BL.KBManage).sort(id,type,operation,.argOutData)
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
	    q ..SetOutMessage(argOutMessage,"ERROR","顺序变更失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod sort(id As %String, type As %String, operation As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes=""
	if (type="IT")
	{
		if (operation="mi_up")
		{
			s rowid="",flag=""
			s obj=##class(CF.EMR.DOC.KBNode).%OpenId(id)
			s productId=obj.Product.%Id(),parentID=obj.KBCategory.%Id(),oldseq=obj.Sequence,cSeq=obj.Sequence
			for
			{
				s oldseq=$o(^CF.EMR.DOC.KBNodeI("IdxKBCategorySeq",parentID,oldseq),-1)
				q:oldseq="" 
				s rowid=$o(^CF.EMR.DOC.KBNodeI("IdxKBCategorySeq",parentID,oldseq,rowid))
				&sql(select Product into flag from CF_EMR_DOC.KBNode where ID=:rowid)
				s sobj=##class(CT.EMR.DOC.Products).%OpenId(flag)
				q:((sobj'="")&&(oldseq'=""))
			}
			s changeobj=##class(CF.EMR.DOC.KBNode).%OpenId(rowid)
			q:changeobj="" "-1^无法上移"
			s obj.Sequence=changeobj.Sequence
			d obj.%Save()
			s changeobj.Sequence=cSeq
			d changeobj.%Save()
			s strRes="1"
			
		}
		elseif (operation="mi_down")
		{
			s rowid="",flag=""
			s obj=##class(CF.EMR.DOC.KBNode).%OpenId(id)
			s productId=obj.Product.%Id(),parentID=obj.KBCategory.%Id(),oldseq=obj.Sequence,cSeq=obj.Sequence
			for
			{
				s oldseq=$o(^CF.EMR.DOC.KBNodeI("IdxKBCategorySeq",parentID,oldseq))
				q:oldseq="" 
				s rowid=$o(^CF.EMR.DOC.KBNodeI("IdxKBCategorySeq",parentID,oldseq,rowid))
				&sql(select Product into flag from CF_EMR_DOC.KBNode where ID=:rowid)
				s sobj=##class(CT.EMR.DOC.Products).%OpenId(flag)
				q:((sobj'="")&&(oldseq'=""))
			}
			s changeobj=##class(CF.EMR.DOC.KBNode).%OpenId(rowid)
			q:changeobj="" "-1^无法下移"
			s obj.Sequence=changeobj.Sequence
			d obj.%Save()
			s changeobj.Sequence=cSeq
			d changeobj.%Save()
			s strRes="1"
		}
		else
		{
			q "-1^操作不存在"
		}
	}
	else
	{
		if (operation="mi_up")
		{
			s rowID=""
			s obj=##class(CF.EMR.DOC.KBCategory).%OpenId(id)
			s parentID=obj.ParentID,OldSeq=obj.CategorySeq,ChangeSeq=obj.CategorySeq
			s OldSeq=$o(^CF.EMR.DOC.KBCategoryI("IdxParentIDAndSeq"," "_parentID,OldSeq),-1)
			q:OldSeq="" "-1^无法上移"
			s rowID=$o(^CF.EMR.DOC.KBCategoryI("IdxParentIDAndSeq"," "_parentID,OldSeq,rowID))
			
			s newObj=##class(CF.EMR.DOC.KBCategory).%OpenId(rowID)
			s obj.CategorySeq=newObj.CategorySeq
			d obj.%Save()
			s newObj.CategorySeq=ChangeSeq
			d newObj.%Save()
			s strRes="1"
		
	}
		elseif(operation="mi_down")
		{
			s rowID=""
			s obj=##class(CF.EMR.DOC.KBCategory).%OpenId(id)
			s parentID=obj.ParentID,OldSeq=obj.CategorySeq,ChangeSeq=obj.CategorySeq
			s OldSeq=$o(^CF.EMR.DOC.KBCategoryI("IdxParentIDAndSeq"," "_parentID,OldSeq))
			q:OldSeq="" "-1^无法下移"
			s rowID=$o(^CF.EMR.DOC.KBCategoryI("IdxParentIDAndSeq"," "_parentID,OldSeq,rowID))
		
			s newObj=##class(CF.EMR.DOC.KBCategory).%OpenId(rowID)
			s obj.CategorySeq=newObj.CategorySeq
			d obj.%Save()
			s newObj.CategorySeq=ChangeSeq
			d newObj.%Save()
			s strRes="1"
		}
		else
		{
			q "-1^请传入操作参数"
		}

	}
	q strRes
}

}
