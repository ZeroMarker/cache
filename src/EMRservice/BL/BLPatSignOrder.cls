/// 名称：		EMRservice.BL.BLPatSignOrder
/// 描述：		患者签名排序BL层
/// 编写者：	yejian
/// 编写时间：	2021-11-4
Class EMRservice.BL.BLPatSignOrder Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       初始化签名类型数据
/// Creator:    yejian
/// CreateDate: 2022-3-7
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMRservice.BL.BLPatSignOrder).InitSignType()
ClassMethod InitSignType()
{
	k ^DHCEMRM.PatSignKeyWordTypeI
	k ^DHCEMRM.PatSignKeyWordTypeD
	&sql(INSERT INTO EMRmeta.PatSignKeyWordType d(d.Code,d.Name) VALUES ('ISNULL','空值'))
	&sql(INSERT INTO EMRmeta.PatSignKeyWordType d(d.Code,d.Name) VALUES ('AGREE','同意'))
	&sql(INSERT INTO EMRmeta.PatSignKeyWordType d(d.Code,d.Name) VALUES ('REFUSE','拒绝'))
}

/// Desc:       初始化签名者类型数据
/// Creator:    yejian
/// CreateDate: 2022-3-7
/// Input:      
/// OutPut:     
/// debug:		d ##Class(EMRservice.BL.BLPatSignOrder).InitSignerType()
ClassMethod InitSignerType()
{
	k ^DHCEMRM.PatSignSignerTypeI
	k ^DHCEMRM.PatSignSignerTypeD
	&sql(INSERT INTO EMRmeta.PatSignSignerType d(d.Code,d.Name) VALUES ('ISNULL','空值'))
	&sql(INSERT INTO EMRmeta.PatSignSignerType d(d.Code,d.Name) VALUES ('SELF','患者签署'))
	&sql(INSERT INTO EMRmeta.PatSignSignerType d(d.Code,d.Name) VALUES ('FAMILY','家属签署'))
}

/// Desc:       获取签名类型
/// Creator:    yejian
/// CreateDate: 2022-3-7
/// Input:      
/// OutPut:     
/// Return:      dataset
/// debug:      d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLPatSignOrder","SelectSignType")
Query SelectSignType() As %SQLQuery(ROWSPEC = "Code:%String,Name:%String")
{
	SELECT Code, Name FROM EMRmeta.PatSignKeyWordType
}

/// Desc:       获取签名者类型
/// Creator:    yejian
/// CreateDate: 2022-6-23
/// Input:      
/// OutPut:     
/// Return:      dataset
/// debug:      d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLPatSignOrder","SelectSignerType")
Query SelectSignerType() As %SQLQuery(ROWSPEC = "Code:%String,Name:%String")
{
	SELECT Code, Name FROM EMRmeta.PatSignSignerType
}

/// Creator: yejian
/// CreatDate: 2021-11-4
/// Description：获取签名排序数据
/// Input: 	aTemplateID 模板ID,
/// 		aVersionNum 版本
/// Return: EMRservice.entity.EPatSignOrder 签名排序对象
/// Debug:	w ##Class(EMRservice.BL.BLPatSignOrder).GetPatSignOrderData("111","2")
ClassMethod GetPatSignOrderData(aTemplateID As %String, aVersionNum As %String) As EMRservice.entity.EPatSignOrder
{
	q:((aTemplateID="")||(aVersionNum="")) ""
	s strRowID = $o(^DHCEMRM.PatSignOrderI("idxTemID",aTemplateID,aVersionNum,""))
	q:(strRowID="") ""
	s objPatSignOrder = ##Class(EMRmeta.PatSignOrder).%OpenId(strRowID)
	q:(objPatSignOrder = "") ""
	
	s Result = ##Class(EMRservice.entity.EPatSignOrder).%New()
	s Result.ID = strRowID
	s Result.TemplateID = objPatSignOrder.TemplateID
	s Result.VersionNum = objPatSignOrder.VersionNum
	s Result.SignData = objPatSignOrder.SignData
	q Result
}

/// Creator: yejian
/// CreatDate: 2021-11-4
/// Description：更新签名排序数据
/// Input: 	ePatSignOrder 签名排序对象
/// Return: 1 成功，0 失败
/// Debug:	w ##Class(EMRservice.BL.BLPatSignOrder).UpPatSignOrderData()
ClassMethod UpPatSignOrderData(ePatSignOrder As EMRservice.entity.EPatSignOrder) As %String
{
	s strRes = "1"
	s strTypeID="",objType=""
	s strRowID = $o(^DHCEMRM.PatSignOrderI("idxTemID",ePatSignOrder.TemplateID,ePatSignOrder.VersionNum,""))
	if (strRowID="")
	{
		s objPatSignOrder = ##class(EMRmeta.PatSignOrder).%New()
		s objPatSignOrder.TemplateID = ePatSignOrder.TemplateID
		s objPatSignOrder.VersionNum = ePatSignOrder.VersionNum
	}
	else
	{
		s objPatSignOrder = ##class(EMRmeta.PatSignOrder).%OpenId(strRowID)
	}
	s objPatSignOrder.SignData = ePatSignOrder.SignData
	s sc = objPatSignOrder.%Save()
	s:('sc) strRes = "0"
	q strRes
}

/// 添加患者签数据（根据版本）
/// aTemplateID:模板ID，aOVersion：旧版本号，aNVersion，新版本号
ClassMethod AddSignOrderByVersion(aTemplateID As %String, aOVersion As %String, aNVersion As %String) As %String
{
	s res ="0"
	q:((aOVersion="")||(aNVersion="")||(aTemplateID="")) res
	q:((aOVersion=$c(0))||(aNVersion=$c(0))||(aTemplateID=$c(0))) res
	
	s arowID = $o(^DHCEMRM.PatSignOrderI("idxTemID",aTemplateID,aOVersion,""))
	q:(arowID = "") res
	s objTemplateSign = ##Class(EMRmeta.PatSignOrder).%OpenId(arowID)
	//如果没有,则新增;有则不处理
	s objSignItem = ##class(EMRmeta.PatSignOrder).%New()
	
	s objSignItem.TemplateID = objTemplateSign.TemplateID
	s objSignItem.VersionNum = aNVersion
	s objSignItem.SignData = objTemplateSign.SignData
	s sc =objSignItem.%Save()
	if ($$$ISOK(sc))
	{
		s res = objSignItem.%Id()
	}
	d objSignItem.%Close()
	d objTemplateSign.%Close()
	s objSignItem = ""
	//返回
	q res
}

/// Creator: yejian
/// CreatDate: 2021-11-4
/// Description：获取签名排序数据
/// Input: 	aTemplateID 模板ID,
/// 		aVersionNum 版本
/// Return: 签名排序对象Json
/// Debug:	w ##Class(EMRservice.BL.BLPatSignOrder).GetPatSignOrderJson("111","2")
ClassMethod GetPatSignOrderJson(aTemplateID As %String, aVersionNum As %String) As %String
{
	q:((aTemplateID="")||(aVersionNum="")) ""
	s strRowID = $o(^DHCEMRM.PatSignOrderI("idxTemID",aTemplateID,aVersionNum,""))
	q:(strRowID="") ""
	s objPatSignOrder = ##Class(EMRmeta.PatSignOrder).%OpenId(strRowID)
	q:(objPatSignOrder = "") ""
	
	s Result = objPatSignOrder.SignData
	s Result = $replace(Result,$c(10),"")
	s Result = $replace(Result,$c(13),"")
	s Result = $replace(Result," ","")
	s:(Result = "[]") Result = ""
	q Result
}

}
