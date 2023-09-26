/// 名称:	EMR.OP.BL.OPResource
/// 描述:	门诊病历-获取资源区页签配置
/// 编写者：huhao
/// 编写日期: 2022-8-8
/// 产品组：电子病历产品组
Class EMR.OP.BL.OPResource Extends EMR.OP.COM.ActionBase
{

/// Desc:       获取门诊病历资源区列表
/// Creator:    huhao
/// CreateDate: 2022-8-8
/// Table:		CF_EMR_DOC.Resource 门诊病历资源区配置数据
/// Input:      argInJson  命令参数 {"action": "GET_OPRESOURCE","params": {"visibleType":""},"product": "OP"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetOPResource(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s Product=argInJson.product
	s visibleType=argInJson.params.visibleType
    s visibleType = $CASE(visibleType,"":"Panel",:visibleType)

    s strRes = ##Class(EMR.OP.BL.OPResource).GetOPResourceJson(Product,visibleType,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-1^")
	{
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
	
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       获取门诊病历资源区列表JSON
/// Creator:    huhao
/// CreateDate: 2022-8-8
/// Input:      visibleType 显示类型
/// 				Product 项目标识
/// OutPut:     成功 1 失败 -200
/// Debug:      
ClassMethod GetOPResourceJson(Product As %String, visibleType As %String = "Panel", ByRef argOutData As %GlobalBinaryStream) As %String
{
	s jsonArr = ##class(%DynamicArray).%New()
	s productID=""
	s productID = $o(^CT.EMR.DOC.ProductsI("IdxCode"," "_$zcvt(Product,"U"),""))
	q:(productID = "") "-1^获取项目标识失败"
	s strRes = ""
	s result = ##Class(%ResultSet).%New("EMR.OP.BL.OPResource:SelectOPResource")
	q:result="" "-1^查询资源区数据失败"
	d result.Execute(visibleType,productID)
	While result.Next() 
	{
     	s jsonItem = ##class(%DynamicObject).%New()
     	s jsonItem.name =result.GetDataByName("Name")
     	s jsonItem.title =result.GetDataByName("Title")
     	s jsonItem.frame =result.GetDataByName("Frame")
     	s jsonItem.content =result.GetDataByName("Content")
     	s jsonItem.href =result.GetDataByName("Href")
     	s jsonItem.zoom =result.GetDataByName("Zoom")
     	s jsonItem.scrolling =result.GetDataByName("Scrolling")
     	s jsonItem.refreshOnSelect =result.GetDataByName("RefreshOnSelect")
     	d jsonArr.%Push(jsonItem)
	}					
	d jsonArr.%ToJSON(argOutData)
	s strRes = "1"
	q strRes
}

/// Desc:       获取所有数据
/// Creator:    huhao
/// CreateDate: 2021-8-5
/// Input:      visibleType 显示类型
/// 				Product 项目标识
/// OutPut:     dataset
/// debug： 	d ##class(%ResultSet).RunQuery("EMR.OP.BL.OPResource","SelectOPResource")
Query SelectOPResource(visibleType As %String, Product As %String) As %SQLQuery
{
	select Name,Title,Frame,Content,Href,Zoom,Scrolling,RefreshOnSelect
	from CF_EMR_DOC.Resource where Visible=:visibleType and Product=:Product order by Position
}

}
