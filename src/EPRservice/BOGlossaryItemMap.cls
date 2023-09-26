/// 名称：		EPRservice.BOGlossaryItemMap
/// 描述：		模版数据，数据元允许值映射服务类
/// 编写者：	yejian
/// 编写时间：	2012-7-10
Class EPRservice.BOGlossaryItemMap Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "GlossaryItemMapInfo";

/// Creator:	yejian
/// CreatDate:	2012-7-10
/// Desc:		判断数据是否存在
/// Input：		aMapID：Id,aGlossaryItemID: 关联ID,aTempID:模版ID
/// Return：	string
/// w ##Class(EPRservice.BOGlossaryItemMap).CheckExist("","CV02.01.101","01")
ClassMethod CheckExist(aMapID As %String, aGlossaryItemID As %String, aTempID As %String) As %String [ WebMethod ]
{
	q:(aGlossaryItemID="")||(aGlossaryItemID=$C(0))||(aTempID="")||(aTempID=$C(0)) "内部标识符不能为空"
	 
	s rowID = $O(^DHCEPRM.GlossaryItemMapI("IdxGloItemTemp"," "_aGlossaryItemID," "_aTempID,""))
	if (rowID = "")
	{
		//内部标识符不存在, OK
		q ""
	}
	else
	{
		if (rowID = aMapID)
		{
			//内部标识符存在且属于当前范畴, OK
			q ""
		}
		else
		{
			s obj = ##Class(EPRmeta.GlossaryItemMap).%OpenId(rowID)
			q "内部标识符与["_obj.DEVDes_"]冲突!"
		}
	}
}

/// Creator:	yejian
/// CreatDate:	2012-7-10
/// Desc:		创建数据
/// Table：		EPRmeta.GlossaryItemMap
/// Input：		EPRservice.entity.EGlossaryItemMap 映射关系实体对象
/// Return：	数据元Id	
ClassMethod CreateGlossaryItemMap(aGlossaryItemMap As EPRservice.entity.EGlossaryItemMap) As %String [ WebMethod ]
{
	s ret = ""
	
	// 检查数据是否唯一
	s existed = ..CheckExist("",aGlossaryItemMap.GlossaryItemID,aGlossaryItemMap.TempID)
	q:(existed '= "") ret
	
	s $zt = "OnCreateErrorHandler"
	
	TSTART
	
	// 创建Glossary
	s objGlossaryItemMap = ##Class(EPRmeta.GlossaryItemMap).%New()
	q:(objGlossaryItemMap = "") ret
	
	s objGlossaryItemMap.GlossaryItemID = aGlossaryItemMap.GlossaryItemID
	s objGlossaryItemMap.TempID = aGlossaryItemMap.TempID
	s objGlossaryItemMap.TempDes = aGlossaryItemMap.TempDes
	s objGlossaryItemMap.DECVMID = aGlossaryItemMap.DECVMID
	s objGlossaryItemMap.DEVID = aGlossaryItemMap.DEVID
	s objGlossaryItemMap.DEVDes  = aGlossaryItemMap.DEVDes
	s objGlossaryItemMap.CodeSystem = aGlossaryItemMap.CodeSystem
	if ('objGlossaryItemMap.%Save())
	{	
		TROLLBACK
		q ret
	}
	
	TCOMMIT
	
	s ret = objGlossaryItemMap.%Id()
	q ret
	
OnCreateErrorHandler
	TROLLBACK
	q ret
}

/// Creator:	yejian
/// CreatDate:	2012-7-10
/// Desc:		删除数据
/// Table：		EPRmeta.GlossaryItemMap
/// Input：		aMapID：要删除的值Id
/// Return：	"0":删除失败	"1":删除成功	
ClassMethod DeleteGlossaryItemMap(aMapID As %String) As %String [ WebMethod ]
{
   
	s ret = 0
	q:($d(aMapID) = "") ret
	
	s objGlossaryItemMap = ##Class(EPRmeta.GlossaryItemMap).%OpenId(aMapID)
	q:(objGlossaryItemMap = "") ret

	TSTART
	
	// 删除Glossary
	s isSucceed = ##Class(EPRmeta.GlossaryItemMap).%DeleteId(aMapID)
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
ClassMethod SelectByGlossaryItemID(aGlossaryItemID) As EPRservice.dataset.EGlossaryItemMapDataset [ WebMethod ]
{
	set result = ##Class(EPRservice.dataset.EGlossaryItemMapDataset).%New()
	Do result.SetArgs(aGlossaryItemID)
	
	quit result
}

/// Creator:	yejian
/// CreatDate:	2012-7-10
/// Desc:		根据关联ID查询所有值
/// Input：		aGlossaryItemID：关联ID
/// Return：	EPRservice.dataset.EGlossaryItemMapDataset 映射集dataset
/// Debug:		w ##Class(EPRservice.BOGlossaryItemMap).SelectByGlossaryItemID(2)
ClassMethod SelectByGlossaryCodeDECVMID(aDECVMID As %String, aCodeSystem As %String) As EPRservice.dataset.EGlossaryItemMapByCodeDataset [ WebMethod ]
{
	set result = ##Class(EPRservice.dataset.EGlossaryItemMapByCodeDataset).%New()
	Do result.SetArgs(aDECVMID,aCodeSystem)
	quit result
}

/// Creator:	yejian
/// CreatDate:	2012-7-10
/// Desc:		由某个ID获得对象
/// Input：		aMapId：值Id
/// Return：	EPRservice.entity.EGlossaryItemMap：实体对象
/// debug: w ##Class(EPRservice.BOGlossaryItemMap).SelectGlossaryItemMapById(4)
ClassMethod SelectGlossaryItemMapById(aMapId As %String) As EPRservice.entity.EGlossaryItemMap [ WebMethod ]
{
	s objGlossaryItemMap = ##Class(EPRmeta.GlossaryItemMap).%OpenId(aMapId)
	q:(objGlossaryItemMap = "") ""
	
	s objEGlossaryItemMap = ##Class(EPRservice.entity.EGlossaryItemMap).%New()
	q:(objEGlossaryItemMap = "") ""

	s objEGlossaryItemMap.ID = objGlossaryItemMap.%Id()
	s objEGlossaryItemMap.GlossaryItemID = objGlossaryItemMap.GlossaryItemID
	s objEGlossaryItemMap.TempID =  objGlossaryItemMap.TempID
	s objEGlossaryItemMap.TempDes =objGlossaryItemMap.TempDes
	s objEGlossaryItemMap.DEVID = objGlossaryItemMap.DEVID
	s objEGlossaryItemMap.DEVDes  = objGlossaryItemMap.DEVDes 
	s objEGlossaryItemMap.CodeSystem = objEGlossaryItemMap.CodeSystem
	
	q objEGlossaryItemMap
}

/// Creator:	yejian
/// CreatDate:	2012-7-10
/// Desc:		更新数据
/// Input：		aEGlossaryItemMap：实体对象
/// Return：	"0": 更新失败,  "1": 更新成功
ClassMethod UpdateGlossaryItemMap(aEGlossaryItemMap As EPRservice.entity.EGlossaryItemMap) As %String [ WebMethod ]
{
	s ret = 0
	s objGlossaryItemMap = ##Class(EPRmeta.GlossaryItemMap).%OpenId(aEGlossaryItemMap.ID)
	q:(objGlossaryItemMap = "") ret

	TSTART
	
	// 更新objGlossaryItemMap信息	
	s objGlossaryItemMap.GlossaryItemID  = aEGlossaryItemMap.GlossaryItemID 
	s objGlossaryItemMap.TempID  = aEGlossaryItemMap.TempID 
	s objGlossaryItemMap.TempDes  = aEGlossaryItemMap.TempDes 
	
	s objGlossaryItemMap.DEVID = aEGlossaryItemMap.DEVID
	s objGlossaryItemMap.DEVDes  = aEGlossaryItemMap.DEVDes 
	
	if ('objGlossaryItemMap.%Save())
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
/// Desc:		创建数据值域代码
/// Table：		EPRmeta.GlossaryItemMap，EPRmeta.GlossaryItemMapCategory
/// Input：		aGlossaryItemMap 数据元实体对象
/// Return：	数据元Id
/// debug:   w ##Class(EPRservice.BOGlossaryItemMap).text("01","居民身份证","CV02.01.101")
ClassMethod text(aid As %String, aname As %String, acvid As %String) As %String [ WebMethod ]
{
	s ret = ""
	
	// 检查数据元值域代码标示符是否唯一
	s existed = ..CheckExist("",aid,acvid)
	q:(existed '= "") ret
	
	s $zt = "OnCreateErrorHandler2"
	
	TSTART
	
	// 创建Glossary
	s objGlossaryItemMap = ##Class(EPRmeta.GlossaryItemMap).%New()
	q:(objGlossaryItemMap = "") ret
	
	s objGlossaryItemMap.GlossaryItemID  = aEGlossaryItemMap.GlossaryItemID 
	s objGlossaryItemMap.TempID  = aEGlossaryItemMap.TempID 
	s objGlossaryItemMap.TempDes  = aEGlossaryItemMap.TempDes 
	s objGlossaryItemMap.DEVID = aEGlossaryItemMap.DEVID
	s objGlossaryItemMap.DEVDes  = aEGlossaryItemMap.DEVDes 
	
	if ('objGlossaryItemMap.%Save())
	{	
		TROLLBACK
		q ret
	}
	
	TCOMMIT
	
	s ret = objGlossaryItemMap.%Id()
	q ret
	
OnCreateErrorHandler2
	TROLLBACK
	q ret
}

}
