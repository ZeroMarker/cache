Class CT.WS.BO.BODataValueMap Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "DataValueMapInfo";

/// Creator:	yejian
/// CreatDate:	2012-7-10
/// Desc:		判断数据是否存在
/// Input：		aMapID：Id,aGlossaryItemID: 关联ID,aTempID:模版ID
/// Return：	string
/// w ##Class(EPRservice.BOGlossaryItemMap).CheckExist("","CV02.01.101","01")
ClassMethod CheckExist(aSystemCode As %String, aDicCode As %String, aCtmDictCode As %String) As %String [ WebMethod ]
{
	q:(aSystemCode="")||(aDicCode=$C(0))||(aCtmDictCode="")||(aCtmDictCode=$C(0)) "内部标识符不能为空"
	s rowID = ""
	s rowID = $o(^DHCCTWS.DataValueMapI("IdxSystemCodeDicCodeCode"," "_$ZCONVERT(aSystemCode,"U")," "_$ZCONVERT(aDicCode,"U")," "_$ZCONVERT(aCtmDictCode,"U"),rowID))
	if (rowID = "")
	{
		//内部标识符不存在, OK
		q ""
	}
	else
	{
		//s obj = ##Class(CT.WS.DataValueMap).%OpenId(rowID)
		q rowID

	}
}

/// Creator:	yejian
/// CreatDate:	2012-7-10
/// Desc:		创建数据
/// Table：		CT.WS.DataValueMap
/// Input：		CT.WS.entity.EDataValueMap 映射关系实体对象
/// Return：	数据元Id	
ClassMethod CreateDataValueMap(aDataValueMap As CT.WS.entity.EDataValueMap) As %String [ WebMethod ]
{
	s ret = ""
	
	// 检查数据是否唯一
	s existed = ..CheckExist(aDataValueMap.SystemCode,aDataValueMap.DicCode,aDataValueMap.CtmDictCode)
	q:(existed '= "") ret
	
	s $zt = "OnCreateErrorHandler"
	
	TSTART
	
	// 创建Glossary
	s objDataValueMap = ""
	s objDataValueMap = ##Class(CT.WS.DataValueMap).%New()
	q:(objDataValueMap = "") ret
	

	s objDataValueMap.DECVMID = aDataValueMap.DECVMID
	s objDataValueMap.DEVID = aDataValueMap.DEVID
	s objDataValueMap.Meaning = aDataValueMap.Meaning
	s objDataValueMap.CtmDictCode = aDataValueMap.CtmDictCode
	s objDataValueMap.CtmDictDesc = aDataValueMap.CtmDictDesc
	s objDataValueMap.DicCode  = aDataValueMap.DicCode
	s objDataValueMap.SystemCode  = aDataValueMap.SystemCode
	
	if ('objDataValueMap.%Save())
	{	
		TROLLBACK
		q ret
	}
	
	TCOMMIT
	
	s ret = objDataValueMap.%Id()
	q ret
	
OnCreateErrorHandler
	TROLLBACK
	q ret
}

/// Creator:	yejian
/// CreatDate:	2012-7-10
/// Desc:		删除数据
/// Table：		CT.WS.DataValueMap
/// Input：		aMapID：要删除的值Id
/// Return：	"0":删除失败	"1":删除成功	
ClassMethod DeleteGlossaryItemMap(aMapID As %String) As %String [ WebMethod ]
{
   
	s ret = 0
	q:($d(aMapID) = "") ret
	
	s objDataValueMap = ##Class(CT.WS.DataValueMap).%OpenId(aMapID)
	q:(objDataValueMap = "") ret

	TSTART
	
	// 删除Glossary
	s isSucceed = ##Class(CT.WS.DataValueMap).%DeleteId(aMapID)
	if ('isSucceed)
	{
		TROLLBACK
		q ret
	}
	
	TCOMMIT
	
	s ret = 1
	q ret
}

/// Creator:	yejian
/// CreatDate:	2012-7-10
/// Desc:		根据关联ID查询所有值
/// Input：		aGlossaryItemID：关联ID
/// Return：	EPRservice.dataset.EGlossaryItemMapDataset 映射集dataset
/// Debug:		w ##Class(EPRservice.BOGlossaryItemMap).SelectByGlossaryItemID(2)
ClassMethod SelectDataValueMap(aGlossaryItemID) As CT.WS.dataset.EDataValueMapDataset [ WebMethod ]
{
	set result = ##Class(CT.WS.dataset.EDataValueMapDataset).%New()
	Do result.SetArgs(aGlossaryItemID)
	
	quit result
}

/// Creator:	yejian
/// CreatDate:	2012-7-10
/// Desc:		由某个ID获得对象
/// Input：		aMapId：值Id
/// Return：	CT.WS.entity.EDataValueMap：实体对象
/// debug: w ##Class(EPRservice.BOGlossaryItemMap).SelectGlossaryItemMapById(4)
ClassMethod SelectGlossaryItemMapById(aMapId As %String) As CT.WS.entity.EDataValueMap [ WebMethod ]
{
	s objDataValueMap = ##Class(CT.WS.DataValueMap).%OpenId(aMapId)
	q:(objDataValueMap = "") ""
	
	s objEDataValueMap = ##Class(CT.WS.entity.EDataValueMap).%New()
	q:(objEDataValueMap = "") ""

	s objEDataValueMap.ID = objDataValueMap.%Id()
	s objEDataValueMap.DECVMID = objDataValueMap.DECVMID
	s objEDataValueMap.DEVID = objDataValueMap.DEVID
	s objEDataValueMap.Meaning = objDataValueMap.Meaning
	s objEDataValueMap.CtmDictCode = objDataValueMap.CtmDictCode
	s objEDataValueMap.CtmDictDesc = objDataValueMap.CtmDictDesc
	s objEDataValueMap.DicCode  = objDataValueMap.DicCode
	s objEDataValueMap.SystemCode  = objDataValueMap.SystemCode
	
	q objEDataValueMap
}

/// Creator:	yejian
/// CreatDate:	2012-7-10
/// Desc:		更新数据
/// Input：		aEDataValueMap：实体对象
/// Return：	"0": 更新失败,  "1": 更新成功
ClassMethod UpdateGlossaryItemMap(aEDataValueMap As CT.WS.entity.EDataValueMap) As %String [ WebMethod ]
{
	s ret = 0
	s objDataValueMap = ##Class(CT.WS.DataValueMap).%OpenId(aEDataValueMap.ID)
	q:(objDataValueMap = "") ret

	TSTART
	// 更新objDataValueMap信息	
	s objDataValueMap.DECVMID = aEDataValueMap.DECVMID
	s objDataValueMap.DEVID = aEDataValueMap.DEVID
	s objDataValueMap.Meaning = aEDataValueMap.Meaning
	s objDataValueMap.CtmDictCode = aEDataValueMap.CtmDictCode
	s objDataValueMap.CtmDictDesc = aEDataValueMap.CtmDictDesc
	s objDataValueMap.DicCode  = aEDataValueMap.DicCode
	s objDataValueMap.SystemCode  = aEDataValueMap.SystemCode
	
	if ('objDataValueMap.%Save())
	{
		TROLLBACK
		q ret
	}
	
	TCOMMIT
	
	s ret = 1
	q ret
}

/// Creator：      yejian
/// CreatDate：    2013-4-24
/// Description:   取保存在配置表里面的字段名称
/// Table：        
/// Input：        ClassName：类名
/// Output：       
/// Return：       属性名称, 逗号分隔
/// test: w ##class(CT.WS.BO.BODataValueMap).GetDataJson("dhcc","s01")
ClassMethod GetDataJson(strSystemCode As %String, nodeCode As %String) As %String
{
	
   	q:(strSystemCode="") $$$OK
	q:(nodeCode="") $$$OK
	
	s Result = ##class(%ResultSet).%New("CT.WS.dao.DDataValueMap:SelectDataValueMap")
    d Result.Execute(strSystemCode,nodeCode)
    s json = ""
	while(Result.Next())
    {
		s json = json_"{id:'"_$g(Result.Data("ID"))_"',"
	 	s json = json_"CtmDictCode:'"_$g(Result.Data("DEVID"))_"',"
	 	s json = json_"CtmDictDesc:'"_$g(Result.Data("Meaning"))_"',"
	 	s json = json_"DEVID:'"_$g(Result.Data("CtmDictCode"))_"',"
		s json = json_"Meaning:'"_$g(Result.Data("CtmDictDesc"))_"'},"	
    }
    s json = $e(json, 1, $l(json)-1)
	//替换掉json串中的回车换行符号
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	s set1 ="{results:'33',rows:["_json_"]}"
	q set1
}

/// Creator:	yejian
/// CreatDate:	2012-7-10
/// Desc:		创建数据值域代码
/// Table：		CT.WS.DataValueMap，CT.WS.DataValueMapCategory
/// Input：		aDataValueMap 数据元实体对象
/// Return：	数据元Id
/// debug:   w ##Class(CT.WS.BO.BODataValueMap).text("dhcc@@s01@@1@@男@@gbt2312@@1@@男")
ClassMethod text(asystemcode As %String) As %String [ WebMethod ]
{
	s ret = ""
	s str =asystemcode
	// 检查数据元值域代码标示符是否唯一
	s existed = ..CheckExist($p(str,"@@",1),$p(str,"@@",2),$p(str,"@@",3))
	q:(existed '= "") ret
	s $zt = "OnCreateErrorHandler"
	TSTART
	// 创建Glossary
	s objDataValueMap = ##Class(CT.WS.DataValueMap).%New()
	q:(objDataValueMap = "") ret
	s objDataValueMap.SystemCode  = $p(str,"@@",1)
	s objDataValueMap.DicCode  = $p(str,"@@",2)
	s objDataValueMap.CtmDictCode = $p(str,"@@",3)
	s objDataValueMap.CtmDictDesc = $p(str,"@@",4)
	s objDataValueMap.DECVMID = $p(str,"@@",5)
	s objDataValueMap.DEVID = $p(str,"@@",6)
	s objDataValueMap.Meaning = $p(str,"@@",7)
	if ('objDataValueMap.%Save())
	{	
		TROLLBACK
		q ret
	}
	
	TCOMMIT
	
	s ret = objDataValueMap.%Id()
	q ret
	
OnCreateErrorHandler
	TROLLBACK
	q ret
}

}
