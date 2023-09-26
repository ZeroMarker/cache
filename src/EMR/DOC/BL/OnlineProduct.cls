/// 名称：		EMR.DOC.BL.OnlineProduct
/// 描述：		已上线产品业务逻辑类
/// 编写者：	huhao
/// 编写时间：	2021-12-1
Class EMR.DOC.BL.OnlineProduct Extends EMR.DOC.COM.ActionBase
{

/// Creator:	huhao
/// CreatDate:  2021-12-1
/// Desc:		获取已上线产品信息
/// Input：		
/// Return：	失败：0，成功：1
ClassMethod GetPrcMsg(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s PrcName=argInJson.params.ProductName
    s strRes = ##class(EMR.DOC.BL.OnlineProduct).GetMsg(PrcName,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未查询到内容",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod GetMsg(PrcName As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s rowId=""
	s resJson=##class(%DynamicArray).%New()
	for
	{
		s resObj=##class(%DynamicObject).%New()
		s rowId=$o(^CF.EMR.DOC.ProductsD(rowId))
		s obj = ##Class(CF.EMR.DOC.Products).%OpenId(rowId)
		q:(obj= "")
		continue:obj.Status="0"
		if (PrcName="")
		{
			s resObj.key=rowId
			s resObj.ProductName=obj.ProductName
			s resObj.ProductCode=obj.ProductCode
			d resJson.%Push(resObj)
		}
		else
		{
			if ($find(obj.ProductName,PrcName)'=0)
			{
				s resObj.key=rowId
				s resObj.ProductName=obj.ProductName
				s resObj.ProductCode=obj.ProductCode
				d resJson.%Push(resObj)
			}
			else
			{break}
		}
		
	}
	d resJson.%ToJSON(argOutData)
	q "1"
}

/// Creator:	huhao
/// CreatDate:  2021/12/2
/// Desc:		通过产品代码获取产品名称
/// Input：		
/// Return：	失败：0，成功：1
ClassMethod GetProductName(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ProductCode=argInJson.params.ProductCode
    s strRes = ##class(EMR.DOC.BL.OnlineProduct).getName(ProductCode,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未查询到内容",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod getName(ProductCode As %String) As %String
{
	s rowId=$o(^CF.EMR.DOC.ProductsI("ProductCodeIndex"," "_ProductCode,""))
	s obj=##class(CF.EMR.DOC.Products).%OpenId(rowId)
	q obj.ProductName
}

/// Creator:	huhao
/// CreatDate:  2021-11-29
/// Desc:		新增上线产品
/// Input：		
/// Return：	失败：0，成功：1
ClassMethod AddProduct(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ProductCode=argInJson.params.ProductCode
	s ProductName=argInJson.params.ProductName
    s strRes = ##class(EMR.DOC.BL.OnlineProduct).Addprcdt(ProductCode,ProductName)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","添加失败，该产品已添加",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod Addprcdt(ProductCode As %String, ProductName As %String) As %String
{
	s rowId=$o(^CF.EMR.DOC.ProductsI("ProductCodeIndex"," "_$zcvt(ProductCode,"U"),""))
	s obj=##class(CF.EMR.DOC.Products).%OpenId(rowId)
	if (obj.Status="1")
	{
		q "0"
	}
	else 
	{
		s obj.ProductName=ProductName
		s obj.Status="1"
		s s=obj.%Save()
		q s
	}
}

/// Creator:	huhao
/// CreatDate:  2021-11-29
/// Desc:		编辑上线产品
/// Input：		
/// Return：	失败：0，成功：1
ClassMethod UpdateProduct(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ProductCode=argInJson.params.ProductCode
	s ProductName=argInJson.params.ProductName
    s strRes = ##class(EMR.DOC.BL.OnlineProduct).Updateprcdt(ProductCode,ProductName)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","更新失败，名称不能为空",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod Updateprcdt(ProductCode As %String, ProductName As %String) As %String
{
	if (ProductName="")
	{
		q "0"
	}
	else
	{
		s rowId=$o(^CF.EMR.DOC.ProductsI("ProductCodeIndex"," "_$zcvt(ProductCode,"U"),""))
		s obj=##class(CF.EMR.DOC.Products).%OpenId(rowId)
		s obj.ProductName=ProductName
		s s=obj.%Save()
		q s
	}
}

/// Creator:	huhao
/// CreatDate:  2021-11-29
/// Desc:		删除上线产品
/// Input：		
/// Return：	失败：0，成功：1
ClassMethod DeleteProduct(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ID=argInJson.params
    s strRes = ##class(EMR.DOC.BL.OnlineProduct).Deleteprcdt(ID)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","删除失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod Deleteprcdt(ID As %String) As %String
{
	;s rowId=$o(^CF.EMR.DOC.ProductsI("ProductCodeIndex"," "_$zcvt(ProductCode,"U"),""))
	s count=ID.%Size()
	for i=0:1:count
	{
		s rowid=ID.%Get(i)
		s obj=##class(CF.EMR.DOC.Products).%OpenId(rowid)
		q:obj=""
		s obj.Status="0"
		s s=obj.%Save()
	}
	q s
}

/// Creator:	huhao
/// CreatDate:  2021-1-4
/// Desc:		获取已上线产品列表
/// Input：		
/// Return：	失败：0，成功：1
ClassMethod GetProductList(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##class(EMR.DOC.BL.OnlineProduct).GetList(.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未查询到内容",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod GetList(ByRef argOutData As %GlobalBinaryStream) As %String
{
	s list=..QueryList()
	s resJson=##class(%DynamicArray).%New()
	while list.%Next()
	{
		s obj=##class(%DynamicObject).%New()
		s obj.label=list.GetDataByName("ProductCode")
		d resJson.%Push(obj)
	}
	d resJson.%ToJSON(argOutData)
	q "1"
}

ClassMethod QueryList(EventCode As %String) As %XML.DataSet
{
 	s dataset = ##Class(%XML.DataSet).%New("%DynamicQuery:SQL")
 	s sql = "SELECT ProductCode FROM CF_EMR_DOC.Products"
	s status=dataset.Prepare(sql)
	d dataset.Execute()
	if $$$ISERR(status) { q "" }
    q dataset
}

}
