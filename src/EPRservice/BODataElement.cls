/// 名称：		EPRservice.BODataElement
/// 描述：		数据元服务类
/// 编写者：	yejian
/// 编写时间：	2012-7-10
Class EPRservice.BODataElement Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "DataElementInfo";

/// Creator:	yejian
/// CreatDate:	2012-7-10
/// Desc:		创建数据元
/// Table：		EPRmeta.DataElement，EPRmeta.DataElementCategory
/// Input：		aEDataElement 数据元实体对象
/// Return：	数据元Id	
ClassMethod CreateDataElement(aEDataElement As EPRservice.entity.EDataElement) As %String [ WebMethod ]
{
	s ret = ""
	
	// 检查术语GUID是否唯一
	s existed = ##Class(EPRmeta.DataElement).SelectByEntifier(aEDataElement.Entifier)
	q:(existed '= "") ret
	
	s $zt = "OnCreateErrorHandler"
	
	TSTART
	
	// 创建Glossary
	s objDataElement = ##Class(EPRmeta.DataElement).%New()
	q:(objDataElement = "") ret
	
	s objDataElement.CategoryID = aEDataElement.CategoryID
	s objDataElement.CreateDate = $piece($HOROLOG,",",1)
	s objDataElement.CreateTime = $piece($HOROLOG,",",2)
	s objDataElement.LastModifyDate = $piece($HOROLOG,",",1)
	s objDataElement.LastModifyTime = $piece($HOROLOG,",",2)
	s objDataElement.Entifier = aEDataElement.Entifier
	s objDataElement.Name = aEDataElement.Name
	s objDataElement.Versions = aEDataElement.Versions
	s objDataElement.RegOrgan = aEDataElement.RegOrgan
	s objDataElement.Environment = aEDataElement.Environment
	s objDataElement.Definition = aEDataElement.Definition
	s objDataElement.ClassModle = aEDataElement.ClassModle
	s objDataElement.DataType = aEDataElement.DataType
	s objDataElement.Format = aEDataElement.Format
	s objDataElement.DEVID = aEDataElement.DEVID
	s objDataElement.ResOrgan = aEDataElement.ResOrgan
	s objDataElement.State = aEDataElement.State
	s objDataElement.PutInOrgan = aEDataElement.PutInOrgan

	if ('objDataElement.%Save())
	{	
		TROLLBACK
		q ret
	}
	
	TCOMMIT
	
	s ret = objDataElement.%Id()
	q ret
	
OnCreateErrorHandler
	TROLLBACK
	q ret
}

/// Creator:	yejian
/// CreatDate:	2012-7-10
/// Desc:		删除数据元
/// Table：		EPRmeta.DataElement，EPRmeta.DataElementCategory
/// Input：		aDataElementID：要删除的术语Id
/// Return：	"0":删除失败	"1":删除成功	
ClassMethod DeleteGlossary(aDataElementID As %String) As %String [ WebMethod ]
{
	s ret = 0
	q:($d(aDataElementID) = "") ret
	
	s objDataElement = ##Class(EPRmeta.DataElement).%OpenId(aDataElementID)
	q:(objDataElement = "") ret

	TSTART
	
	// 删除Glossary
	s isSucceed = ##Class(EPRmeta.DataElement).%DeleteId(aDataElementID)
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
/// Desc:		判断标示符是否存在
/// Table：		EPRmeta.DataElement，EPRmeta.DataElementCategory
/// Input：		aGlossaryID：Id,aEntifier: 数据元标示符
/// Return：	string
/// w ##Class(EPRservice.BODataElement).CheckEntifier("55","55")
ClassMethod CheckEntifier(aGlossaryID As %String, aEntifier As %String) As %String [ WebMethod ]
{
	q:(aEntifier="")||(aEntifier=$C(0)) "内部标识符不能为空"
	 
	s id = $O(^DHCEPRM.DataElementI("IdxEntifier"," "_aEntifier,""))
	if (id = "")
	{
		//内部标识符不存在, OK
		q ""
	}
	else
	{
		if (id = aGlossaryID)
		{
			//内部标识符存在且属于当前术语范畴, OK
			q ""
		}
		else
		{
			s obj = ##Class(EPRmeta.DataElement).%OpenId(id)
			q "内部标识符与["_obj.Name_"]冲突!"
		}
	}
}

/// Creator:	yejian
/// CreatDate:	2012-7-10
/// Desc:		查询某个范畴下的所有数据元
/// Input：		aCategoryID：数据元范畴Id
/// Return：	EPRservice.dataset.EDataElementDataset 数据元集dataset
/// Debug:		w ##Class(EPRservice.BODataElement).SelectAllGlossaryByCategoryID(2)
ClassMethod SelectAllGlossaryByCategoryID(aCategoryID) As EPRservice.dataset.EDataElementDataset [ WebMethod ]
{
	set result = ##Class(EPRservice.dataset.EDataElementDataset).%New()
	Do result.SetArgs(aCategoryID)
	
	quit result
}

/// Creator:	yejian
/// CreatDate:	2012-7-10
/// Desc:		查询某个范畴下的所有数据元
/// Input：		aCategoryID：数据元范畴Id
/// Return：    数据元个数
/// Debug:		w ##Class(EPRservice.BODataElement)SelectCountbyCategoryID(2)
ClassMethod SelectCountbyCategoryID(aCategoryID) As %String [ WebMethod ]
{
	// 检查术语GUID是否唯一
	s strCount = ##Class(EPRmeta.DataElement).SelectCountbyCategoryID(aCategoryID)
	quit strCount
}

/// Creator:	yejian
/// CreatDate:	2012-7-10
/// Desc:		查询某个范畴下的所有数据元
/// Input：		aCategoryID：数据元范畴Id
/// Return：    数据元个数
/// Debug:		w ##Class(EPRservice.BODataElement).SelectDevIDByEntifier("DE02.01.001.03")
ClassMethod SelectDevIDByEntifier(aEntifier As %String) As %String [ WebMethod ]
{
	// 检查术语GUID是否唯一
	s strCount = ##Class(EPRmeta.DataElement).SelectDevIDByEntifier(aEntifier)
	quit strCount
}

/// Creator:	yejian
/// CreatDate:	2012-7-10
/// Desc:		由某个数据元ID获得数据元对象
/// Input：		aDataElementId：数据元Id
/// Return：	EPRservice.entity.EDataElement：数据元实体对象
ClassMethod SelectGlossaryById(aDataElementId As %String) As EPRservice.entity.EDataElement [ WebMethod ]
{
	s objDataElement = ##Class(EPRmeta.DataElement).%OpenId(aDataElementId)
	q:(objDataElement = "") ""
	
	s objEDataElement = ##Class(EPRservice.entity.EDataElement).%New()
	q:(objEDataElement = "") ""

	s objEDataElement.ID = objDataElement.%Id()
	s objEDataElement.CategoryID = objDataElement.CategoryID
	s objEDataElement.CreateDate = objDataElement.CreateDate
	s objEDataElement.CreateTime =  objDataElement.CreateTime
	s objEDataElement.LastModifyDate =objDataElement.LastModifyDate
	s objEDataElement.LastModifyTime = objDataElement.LastModifyTime
	s objEDataElement.Entifier = objDataElement.Entifier
	s objEDataElement.Name = objDataElement.Name
	s objEDataElement.Versions = objDataElement.Versions
	s objEDataElement.RegOrgan = objDataElement.RegOrgan
	s objEDataElement.Environment = objDataElement.Environment
	s objEDataElement.Definition = objDataElement.Definition
	s objEDataElement.ClassModle = objDataElement.ClassModle
	s objEDataElement.DataType = objDataElement.DataType
	s objEDataElement.Format = objDataElement.Format
	s objEDataElement.DEVID = objDataElement.DEVID
	s objEDataElement.ResOrgan = objDataElement.ResOrgan
	s objEDataElement.State = objDataElement.State
	s objEDataElement.PutInOrgan = objDataElement.PutInOrgan
	
	q objEDataElement
}

/// Creator:	yejian
/// CreatDate:	2012-7-10
/// Desc:		更新数据元
/// Input：		AEDataElement：术语实体对象
/// Return：	"0": 更新失败,  "1": 更新成功
ClassMethod UpdateGlossary(AEDataElement As EPRservice.entity.EDataElement) As %String [ WebMethod ]
{
	s ret = 0
	s objDataElement = ##Class(EPRmeta.DataElement).%OpenId(AEDataElement.ID)
	q:(objDataElement = "") ret

	TSTART
	
	// 更新objDataElement信息	
	s objDataElement.CreateDate = AEDataElement.CreateDate
	s objDataElement.CreateTime = AEDataElement.CreateTime
	s objDataElement.LastModifyDate = $piece($HOROLOG,",",1)
	s objDataElement.LastModifyTime = $piece($HOROLOG,",",2)
	s objDataElement.Entifier = AEDataElement.Entifier
	s objDataElement.Name = AEDataElement.Name
	s objDataElement.Versions = AEDataElement.Versions
	s objDataElement.RegOrgan = AEDataElement.RegOrgan
	s objDataElement.Environment = AEDataElement.Environment
	s objDataElement.Definition = AEDataElement.Definition
	s objDataElement.ClassModle = AEDataElement.ClassModle
	s objDataElement.DataType = AEDataElement.DataType
	s objDataElement.Format = AEDataElement.Format
	s objDataElement.DEVID = AEDataElement.DEVID
	s objDataElement.ResOrgan = AEDataElement.ResOrgan
	s objDataElement.State = AEDataElement.State
	s objDataElement.PutInOrgan = AEDataElement.PutInOrgan
	
	if ('objDataElement.%Save())
	{
		TROLLBACK
		q ret
	}
	
	TCOMMIT
	
	s ret = 1
	q ret
}

/*
/// Creator:	yejian
/// CreatDate:	2012-7-10
/// Desc:		创建数据元
/// Table：		EPRmeta.DataElement，EPRmeta.DataElementCategory
/// Input：		aEDataElement 数据元实体对象
/// Return：	数据元Id	
/// debugger:	w ##Class(EPRservice.BODataElement).test()
ClassMethod test() As %String [ WebMethod ]
{
	s ret = ""
	
	// 检查术语GUID是否唯一
	s existed = ##Class(EPRmeta.DataElement).SelectByEntifier("DEO2.01.001.00")
	q:(existed '= "") ret
	
	s $zt = "OnCreateErrorHandler"
	
	TSTART
	
	// 创建Glossary
	s objDataElement = ##Class(EPRmeta.DataElement).%New()
	q:(objDataElement = "") ret
	
	s objDataElement.CategoryID =2
	s objDataElement.CreateDate = $piece($HOROLOG,",",1)
	s objDataElement.CreateTime = $piece($HOROLOG,",",2)
	s objDataElement.LastModifyDate = $piece($HOROLOG,",",1)
	s objDataElement.LastModifyTime = $piece($HOROLOG,",",2)
	s objDataElement.Entifier = "DEO2.01.001.00"
	s objDataElement.Name = "参加工作日期"
	s objDataElement.Versions ="V1.0"
	s objDataElement.RegOrgan = "卫生部卫生信息标准专业委员会"
	s objDataElement.Environment ="卫生信息"
	s objDataElement.Definition = "本人参加工作（开始就业）当日就业公元纪年日期"
	s objDataElement.ClassModle = "分类法"
	s objDataElement.DataType ="D"
	s objDataElement.Format = "D8"
	s objDataElement.DEVID =""
	s objDataElement.ResOrgan =  "卫生部统计信息中心"
	s objDataElement.State = "标准状态"
	s objDataElement.PutInOrgan = "卫生部统计信息中心"
	
	if ('objDataElement.%Save())
	{	
		TROLLBACK
		q ret
	}
	
	TCOMMIT
	
	s ret = objDataElement.%Id()
	q ret
	
OnCreateErrorHandler
	TROLLBACK
	q ret
}
*/
}
