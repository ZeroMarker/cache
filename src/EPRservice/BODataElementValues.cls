/// 名称：		EPRservice.BODataElementValues
/// 描述：		数据值域代码服务类
/// 编写者：	yejian
/// 编写时间：	2012-7-10
Class EPRservice.BODataElementValues Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "DataElementValuesInfo";

/// Creator:	yejian
/// CreatDate:	2012-7-10
/// Desc:		判断标示符是否存在
/// Input：		aGlossaryID：Id,aEntifier: 数据元标示符
/// Return：	string
/// w ##Class(EPRservice.BODataElementValues).CheckEntifier("","CV02.01.101","01")
ClassMethod CheckEntifier(aDEValuesID As %String, aDECVMID As %String, aDEVID As %String) As %String [ WebMethod ]
{
	q:(aDECVMID="")||(aDECVMID=$C(0))||(aDEVID="")||(aDEVID=$C(0)) "内部标识符不能为空"
	 
	s rowID = $O(^DHCEPRM.DataElementValuesI("IdxDevsID"," "_aDECVMID," "_aDEVID,""))
	if (rowID = "")
	{
		//内部标识符不存在, OK
		q ""
	}
	else
	{
		if (rowID = aDEValuesID)
		{
			//内部标识符存在且属于当前范畴, OK
			q ""
		}
		else
		{
			s obj = ##Class(EPRmeta.DataElementValues).%OpenId(rowID)
			q "内部标识符与["_obj.DEVID_"]冲突!"
		}
	}
}

/// Creator:	yejian
/// CreatDate:	2012-7-10
/// Desc:		创建数据值域代码
/// Table：		EPRmeta.DataElementValues，EPRmeta.DataElementValuesCategory
/// Input：		aDataElementValues 数据元实体对象
/// Return：	数据元Id	
ClassMethod CreateDataElementValues(aDataElementValues As EPRservice.entity.EDataElementValues) As %String [ WebMethod ]
{
	s ret = ""
	
	// 检查数据元值域代码标示符是否唯一
	s existed = ..CheckEntifier("",aDataElementValues.DECVMID,aDataElementValues.DEVID)
	q:(existed '= "") ret
	
	s $zt = "OnCreateErrorHandler"
	
	TSTART
	
	// 创建Glossary
	s objDataElementValues = ##Class(EPRmeta.DataElementValues).%New()
	q:(objDataElementValues = "") ret
	
	s objDataElementValues.DEVID = aDataElementValues.DEVID
	s objDataElementValues.CreateDate = $piece($HOROLOG,",",1)
	s objDataElementValues.CreateTime = $piece($HOROLOG,",",2)
	s objDataElementValues.LastModifyDate = $piece($HOROLOG,",",1)
	s objDataElementValues.LastModifyTime = $piece($HOROLOG,",",2)
	s objDataElementValues.Meaning  = aDataElementValues.Meaning
	s objDataElementValues.Description  = aDataElementValues.Description
	s objDataElementValues.DECVMID  = aDataElementValues.DECVMID
	
	if ('objDataElementValues.%Save())
	{	
		TROLLBACK
		q ret
	}
	
	TCOMMIT
	
	s ret = objDataElementValues.%Id()
	q ret
	
OnCreateErrorHandler
	TROLLBACK
	q ret
}

/// Creator:	yejian
/// CreatDate:	2012-7-10
/// Desc:		删除数据值域代码
/// Table：		EPRmeta.DataElementValues，EPRmeta.DataElementValuesCategory
/// Input：		aDataElementValuesID：要删除的值域代码Id
/// Return：	"0":删除失败	"1":删除成功	
ClassMethod DeleteDataElementValues(aDataElementValuesID As %String) As %String [ WebMethod ]
{
	s ret = 0
	q:($d(aDataElementValuesID) = "") ret
	
	s objDataElementValues = ##Class(EPRmeta.DataElementValues).%OpenId(aDataElementValuesID)
	q:(objDataElementValues = "") ret

	TSTART
	
	// 删除Glossary
	s isSucceed = ##Class(EPRmeta.DataElementValues).%DeleteId(aDataElementValuesID)
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
/// Desc:		查询某个范畴下的所有值域代码
/// Input：		aDECVMID：值域代码标示符
/// Return：	EPRservice.dataset.EDataElementValuesDataset 值域代码集dataset
/// Debug:		w ##Class(EPRservice.BODataElementValues).SelectAllGlossaryByDECVMID(2)
ClassMethod SelectAllValuesByDECVMID(aDECVMID) As EPRservice.dataset.EDataElementValuesDataset [ WebMethod ]
{
	set result = ##Class(EPRservice.dataset.EDataElementValuesDataset).%New()
	Do result.SetArgs(aDECVMID)
	
	quit result
}

/// Creator:	yejian
/// CreatDate:	2012-7-10
/// Desc:		由某个值域代码ID获得值域代码对象
/// Input：		aDataElementId：值域代码Id
/// Return：	EPRservice.entity.EDataElementValues：值域代码实体对象
/// debug: w ##Class(EPRservice.BODataElementValues).SelectDataElementValuesById(4)
ClassMethod SelectDataElementValuesById(aDataElementId As %String) As EPRservice.entity.EDataElementValues [ WebMethod ]
{
	s objDataElementValues = ##Class(EPRmeta.DataElementValues).%OpenId(aDataElementId)
	q:(objDataElementValues = "") ""
	
	s objEDataElementValues = ##Class(EPRservice.entity.EDataElementValues).%New()
	q:(objEDataElementValues = "") ""

	s objEDataElementValues.ID = objDataElementValues.%Id()
	s objEDataElementValues.CreateDate = objDataElementValues.CreateDate
	s objEDataElementValues.CreateTime =  objDataElementValues.CreateTime
	s objEDataElementValues.LastModifyDate =objDataElementValues.LastModifyDate
	s objEDataElementValues.LastModifyTime = objDataElementValues.LastModifyTime
	s objEDataElementValues.DEVID  = objDataElementValues.DEVID 
	s objEDataElementValues.Meaning  = objDataElementValues.Meaning 
	s objEDataElementValues.Description  = objDataElementValues.Description 
	s objEDataElementValues.DECVMID  = objDataElementValues.DECVMID 
	
	q objEDataElementValues
}

/// Creator:	yejian
/// CreatDate:	2012-7-10
/// Desc:		更新值域代码
/// Input：		aEDataElementValues：术语实体对象
/// Return：	"0": 更新失败,  "1": 更新成功
ClassMethod UpdateDataElementValues(aEDataElementValues As EPRservice.entity.EDataElementValues) As %String [ WebMethod ]
{
	s ret = 0
	s objDataElementValues = ##Class(EPRmeta.DataElementValues).%OpenId(aEDataElementValues.ID)
	q:(objDataElementValues = "") ret

	TSTART
	
	// 更新objDataElementValues信息	
	s objDataElementValues.CreateDate = aEDataElementValues.CreateDate
	s objDataElementValues.CreateTime = aEDataElementValues.CreateTime
	s objDataElementValues.LastModifyDate = $piece($HOROLOG,",",1)
	s objDataElementValues.LastModifyTime = $piece($HOROLOG,",",2)
	s objDataElementValues.DEVID  = aEDataElementValues.DEVID 
	s objDataElementValues.Meaning  = aEDataElementValues.Meaning 
	s objDataElementValues.Description  = aEDataElementValues.Description
	s objDataElementValues.DECVMID  = aEDataElementValues.DECVMID 
	
	if ('objDataElementValues.%Save())
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
/// Table：		EPRmeta.DataElementValues，EPRmeta.DataElementValuesCategory
/// Input：		aDataElementValues 数据元实体对象
/// Return：	数据元Id
/// debug:   w ##Class(EPRservice.BODataElementValues).text("01","居民身份证","CV02.01.101")
ClassMethod text(aid As %String, aname As %String, acvid As %String) As %String [ WebMethod ]
{
	s ret = ""
	
	// 检查数据元值域代码标示符是否唯一
	s existed = ..CheckEntifier("",aid,acvid)
	q:(existed '= "") ret
	
	s $zt = "OnCreateErrorHandler"
	
	TSTART
	
	// 创建Glossary
	s objDataElementValues = ##Class(EPRmeta.DataElementValues).%New()
	q:(objDataElementValues = "") ret
	
	s objDataElementValues.DEVID =aid
	s objDataElementValues.CreateDate = $piece($HOROLOG,",",1)
	s objDataElementValues.CreateTime = $piece($HOROLOG,",",2)
	s objDataElementValues.LastModifyDate = $piece($HOROLOG,",",1)
	s objDataElementValues.LastModifyTime = $piece($HOROLOG,",",2)
	s objDataElementValues.Meaning  = aname
	s objDataElementValues.Description  = ""
	s objDataElementValues.DECVMID  = acvid
	
	if ('objDataElementValues.%Save())
	{	
		TROLLBACK
		q ret
	}
	
	TCOMMIT
	
	s ret = objDataElementValues.%Id()
	q ret
	
OnCreateErrorHandler
	TROLLBACK
	q ret
}

}
