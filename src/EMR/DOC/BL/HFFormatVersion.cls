/// 名称:	EMR.DOC.BL.HFFormatVersion
/// 描述:	文档版式管理版本逻辑业务
/// 编写者: duan
/// 编写日期: 	2021-03-22
/// 产品组：	电子病历产品组
Class EMR.DOC.BL.HFFormatVersion Extends EMR.DOC.COM.ActionBase
{

/// Desc:       新建版本
/// Creator:    duan
/// CreateDate: 2021-03-22
/// Input:      argArray  命令参数 {"params": {"action": "ADD_HFFORMAT_VERSION","args": {"ParentID": "2",//版式ID"UserCode":"YS01",//用户Code"IP":"127.0.0.1",//IP地址"Remark":""}},"product": "GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddHFVersion(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"	
	s HFFVersion = ##class(EMR.DOC.DTO.HFFormatVersion).%New()
	s HFFVersion.HFFormat = ..GetIDByKey(argInJson.params.id)
	s HFFVersionLog = ##class(EMR.DOC.DTO.HFFormatStatusMLog).%New()
	s HFFVersionLog.CreateID = argInJson.params.userCode
	s HFFVersionLog.ModifyID = argInJson.params.userCode
	s HFFVersionLog.OperateMachineIP = argInJson.params.IP
	TSTART
    //新增版本
    s strRes = ##Class(EMR.DOC.BL.HFFormatVersion).AddHFVersionJson(HFFVersion,HFFVersionLog,.argOutData)
	if (strRes = "1")
	{ 
		TCOMMIT
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-101")
	{  
		Trollback
		q ..SetOutMessage(argOutMessage,"ERROR","操作版式数据记录失败",2)
	}
	elseif(strRes="-102")
	{  
		Trollback
		q ..SetOutMessage(argOutMessage,"ERROR","操作版本数据记录失败",2)
	}
	elseif(strRes="-103")
	{  
		Trollback
		q ..SetOutMessage(argOutMessage,"ERROR","添加日志失败",2)
	}
	elseif(strRes="-104")
	{  
		Trollback
		q ..SetOutMessage(argOutMessage,"ERROR","有未发布的版本，不允许添加新版本",2)
	}
	elseif(strRes="-200")
	{  
		Trollback
		q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	}
	elseif(strRes="-301")
	{  
		Trollback
		q ..SetOutMessage(argOutMessage,"ERROR","版式记录不存在,检查参数",2)
	}
	else
	{
		Trollback
		q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	Trollback
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       删除版本
/// Creator:    duan
/// CreateDate: 2021-03-22
/// Input:      argArray  命令参数 {{"action":"DELETE_HFFORMAT_VERSION","params":{"ID":"9","IP":"127.0.0.1","userCode":"YS01"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod DeleteHFVersion(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s HFFormatVersionID = ..GetIDByKey(argInJson.params.id)
	s DTOHFLog = ##Class(EMR.DOC.BL.HFFormatStatusMLog).GetMaxLog(HFFormatVersionID)
	s DTOHFLog.ModifyID = argInJson.params.userCode
	s DTOHFLog.OperateMachineIP = argInJson.params.IP
	
    s strRes = ##Class(EMR.DOC.BL.HFFormatVersion).DeleteHFVersionJson(HFFormatVersionID,DTOHFLog)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","id参数必填",2)
	}
	elseif(strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","操作数据记录失败",2)
	}
	elseif(strRes="-102")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","当前版本不允许删除",2)
	}
	elseif(strRes="-103")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","添加删除日志失败",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","版本数据不存在，检查id参数是否正确",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       保存版本
/// Creator:    duan
/// CreateDate: 2021-03-22
/// Input:      argArray  命令参数 {"action":"SAVE_HFFORMAT_VERSION","params":{"id":"1","userCode":"YS01","operateMachineIP":"127.0.0.1"},"product":"GlobalEMR"}-----------------------------8eb5b37251gef文档数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod SaveHFVersion(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s status = 1
	s HFVersionID = ..GetIDByKey(argInJson.params.id)
    s objVersion  = ##class(EMR.DOC.DTO.HFFormatVersion).%New()
    s objVersion.ID = HFVersionID
	s objVersion.Status = status
	d objVersion.XmlPackageData.CopyFrom(argInData)
	s DTOHFLog = ##Class(EMR.DOC.BL.HFFormatStatusMLog).GetMaxLog(HFVersionID)
	s DTOHFLog.ModifyID = argInJson.params.userCode
	s DTOHFLog.Status = status
	s DTOHFLog.Remark=argInJson.params.remark
	s DTOHFLog.OperateMachineIP = argInJson.params.IP
	
    s strRes = ##Class(EMR.DOC.BL.HFFormatVersion).SaveHFVersionJson(objVersion,DTOHFLog)
	if (strRes = "1")
	{ 
		 q argOutMessage.success = ..#OK
	}
	elseif(strRes = "-101")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","操作数据记录失败",2)
	}
	elseif(strRes = "-102")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","保存日志失败",2)
	}
	elseif(strRes = "-200")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","版本ID未传",2)
	}
	else
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       加载版式（版本）
/// Creator:    duan
/// CreateDate: 2021-03-22
/// Input:      argArray  命令参数 {"params":{"action":"LOAD_HFFORMAT","args":{"ID":"2"}},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod LoadHFVersion(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ID =..GetIDByKey(argInJson.params.id)
	s type = ..GetTypeByKey(argInJson.params.id)
	if (type="LF"){
		//根据版式获取版式最新的发布的版本ID
		s HFVersionID = ##Class(EMR.DOC.BL.HFFormatVersion).GetVersionIDByHFFormat(ID)
		if (HFVersionID=""){
			q ..SetOutMessage(argOutMessage,"ERROR","当前版式没有已经发布的版本",2)
		}
	}else{
		s HFVersionID = ID
	}
    s strRes = ##Class(EMR.DOC.BL.HFFormatVersion).LoadHFVersionJson(HFVersionID,.argOutData)
	if (strRes="1")
	{
		q argOutMessage.success = ..#OK
	}
	elseif (strRes = "-200")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","参数id必传",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未查找到数据记录，检查id参数是否正确",2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       发布版本
/// Creator:    duan
/// CreateDate: 2021-03-22
/// Input:      argArray  命令参数 {"params":{"action":"PUBLISH_HFFORMAT_VERSION","args":{"id":"2"}},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod PublishVersion(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ID =..GetIDByKey(argInJson.params.id) 
	s status="2"
	s DTOHFLog = ##Class(EMR.DOC.BL.HFFormatStatusMLog).GetMaxLog(ID)
	s DTOHFLog.ModifyID = argInJson.params.userCode
	s DTOHFLog.Status = status
	s DTOHFLog.OperateMachineIP = argInJson.params.IP
    s strRes = ##Class(EMR.DOC.BL.HFFormatVersion).SetPublishVersion(ID,DTOHFLog)
	if (strRes="1")
	{
		q argOutMessage.success = ..#OK
	}
	elseif (strRes = "-201")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","参数id必传",2)
	}
	elseif (strRes = "-301")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","数据记录不存在，检查id",2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       添加版式版本
/// Creator:    duan
/// CreateDate: 2021-03-22
/// Input:      AVersion 版式版本对象
///             AMLog  版式日志对象
/// output:     成功 1 失败 	-104 有未发布的版本不允许添加新版本 -101 操作版式数据记录失败 -102 操作版本数据记录失败  -103 添加日志失败
/// 							-200 必填项校验失败
/// 							-301 版式对象不存在
/// Debug:      w ##Class(EMR.DOC.BL.HFFormatVersion).AddHFVersionJson()
ClassMethod AddHFVersionJson(AVersion As EMR.DOC.DTO.HFFormatVersion, AMLog As EMR.DOC.DTO.HFFormatStatusMLog, ByRef argOutData As %GlobalBinaryStream)
{
	q:((AVersion="")||(AVersion.HFFormat="")) "-200"
	s oldMaxVersion = ""
	s strPublishID = ""
	s HFFormatID = AVersion.HFFormat
	s count=0
	//有未发布的版本不允许添加新的版本
	&sql(SELECT COUNT(*) into :count  FROM CF_EMR_DOC.HFFormatVersion WHERE HFFormat = :HFFormatID and STATUS != "2")
	q:(count>0) "-104"
 	&sql(SELECT MAX(VersionNumber) into :oldMaxVersion  FROM CF_EMR_DOC.HFFormatVersion WHERE HFFormat = :HFFormatID)
 	&sql(SELECT MAX(ID) into :strPublishID FROM CF_EMR_DOC.HFFormatVersion WHERE HFFormat = :HFFormatID and Status="2")
	TSTART
	s objVersion = ##class(CF.EMR.DOC.HFFormatVersion).%New()
	s objHFFormat = ##class(CF.EMR.DOC.HFFormat).%OpenId(HFFormatID)
	if '(strPublishID=""){
		s objPublishVersion = ##class(CF.EMR.DOC.HFFormatVersion).%OpenId(strPublishID)
		if (objPublishVersion.XmlPackageData.IsNull()'=1){
			d objVersion.XmlPackageData.CopyFrom(objPublishVersion.XmlPackageData)
		}
	}

	if (objHFFormat ="")
	{
		TROLLBACK
		q "-301"
	}
	
	if (oldMaxVersion= "")
	{
		s objVersion.VersionNumber = 1
	} 
	elseif '(oldMaxVersion="")
	{
		s objVersion.VersionNumber =oldMaxVersion + 1
	} 	
	s objVersion.Status = 0
	s objVersion.EffectiveDate = $ZDATEH($ZDATE($h))
	s objVersion.EffectiveTime = $ZTIMEH($ZTIME($PIECE($h,",",2),1))
	
	
	//更新版式最新版本号
	s objHFFormat.LastVersion = objVersion.VersionNumber
	s objVersion.HFFormat =objHFFormat
	if '(objHFFormat.%Save())
	{
		TROLLBACK
		q "-101"
	}
	if '(objVersion.%Save())
	{
	 	TROLLBACK 
		q "-102"
	}
	
	s AMLog.HFVersionID = objVersion.%Id()
	s AMLog.HFFormatID =HFFormatID
	s AMLog.Status = objVersion.Status
	s AMLog.CreateDate = $ZDATEH($ZDATE($h))
 	s AMLog.CreateTime = $ZTIMEH($ZTIME($PIECE($h,",",2),1))
	s AMLog.ModifyDate = $ZDATEH($ZDATE($h))
	s AMLog.ModifyTime = $ZTIMEH($ZTIME($PIECE($h,",",2),1))
	s AMLog.Remark="新增版本"
	s strMRes = ##Class(EMR.DOC.BL.HFFormatStatusMLog).AddMLog(AMLog)
	if (strMRes ="-1")
	{
		TROLLBACK
		q "-103"
	}
	TCOMMIT
	q "1"
}

/// Desc:       删除版式版本
/// Creator:    duan
/// CreateDate: 2021-05-20
/// Input:      AHFVersionID 版式版本ID 
///             AMLog  版式日志对象
/// output:     成功 1 失败 	-101 操作版式版本数据记录失败 -102 版本状态不允许删除  -103 添加日志失败
/// 							-200 版本id未传
/// 							-301 版本对象不存在
ClassMethod DeleteHFVersionJson(AHFVersionID As %String, AMLog As EMR.DOC.DTO.HFFormatStatusMLog)
{
	s strRes = "-101"
	q:""=AHFVersionID "-200"
	/*状态为0,1,5的版本可以删除*/
	TSTART
	s objHFVersion = ##class(CF.EMR.DOC.HFFormatVersion).%OpenId(AHFVersionID)
	/* 版式LastVersion  -1 */
	q:(objHFVersion="") "-301"
	q:((objHFVersion.Status>1)&&(objHFVersion.Status'=5)) "-102"
	s HFFormatID = objHFVersion.HFFormat.%Id()
	s objHFFormat = ##class(CF.EMR.DOC.HFFormat).%OpenId(HFFormatID)
	s objHFFormat.LastVersion = objHFFormat.LastVersion - 1
	if '(objHFFormat.%Save())
	{
		TROLLBACK
		q strRes
	} 
	//增加删除日志记录
	s AMLog.HFVersionID=AHFVersionID
 	s AMLog.CreateDate = $ZDATEH($ZDATE($h))
 	s AMLog.CreateTime = $ZTIMEH($ZTIME($PIECE($h,",",2),1))
	s AMLog.ModifyDate = $ZDATEH($ZDATE($h))
	s AMLog.ModifyTime = $ZTIMEH($ZTIME($PIECE($h,",",2),1))
	s AMLog.Status = -1
	s AMLog.Remark="删除版本"
	s strMRes = ##Class(EMR.DOC.BL.HFFormatStatusMLog).AddMLog(AMLog)
	if (strMRes ="-1")
	{
		TROLLBACK
		q "-103"
	}
	///物理删除版式版本
	if '(objHFVersion.%DeleteId(AHFVersionID))
	{
		TROLLBACK
		q strRes
	} 
 	
	TCOMMIT
	s strRes="1"
	q strRes
}

/// Desc:       保存版式内容
/// Creator:    duan
/// CreateDate: 2021-05-20
/// Input:      AobjVersion 版式版本DTO 对象
///             AMLog  版式日志对象
/// output:     成功 1 失败 	-101 操作版式版本数据记录失败 -102  添加日志失败 -103 已经发布的版式不允许保存
/// 							-200 版本id未传
ClassMethod SaveHFVersionJson(AobjVersion As EMR.DOC.DTO.HFFormatVersion, AMLog As CF.EMR.DOC.HFFormatStatusMLog)
{
	TSTART
	s $zt = "Error"	
	if ((AobjVersion="") || (AobjVersion.ID=""))
	{
		TROLLBACK
		q "-200"	
	}

	s obj = ##class(CF.EMR.DOC.HFFormatVersion).%OpenId(AobjVersion.ID)
	if ((obj.Status>1)&&(obj.Status'=5))
	{
		TROLLBACK
		q "-103"	
	}
	s Status = "1"
	s:AobjVersion.Status'="" Status = AobjVersion.Status
	s obj.Status = Status //使用状态 0 新建，1 保存，2 发布, 3 申请审核,4 重新申请审核,5 审核不通过,-1 已删除
	d obj.XmlPackageData.Clear()
	d obj.XmlPackageData.CopyFrom(AobjVersion.XmlPackageData)
	
	s sc = obj.%Save()
	if '($$$ISOK(sc))
	{
		TROLLBACK
		q "-101"
	}
	
	s AMLog.Status = Status
	s AMLog.HFVersionID=AobjVersion.ID
	s AMLog.CreateDate = $ZDATEH($ZDATE($h))
 	s AMLog.CreateTime = $ZTIMEH($ZTIME($PIECE($h,",",2),1))
	s AMLog.ModifyDate = $ZDATEH($ZDATE($h))
	s AMLog.ModifyTime = $ZTIMEH($ZTIME($PIECE($h,",",2),1))

	s strMRes = ##Class(EMR.DOC.BL.HFFormatStatusMLog).AddMLog(AMLog)
	if (strMRes ="-1")
	{
		TROLLBACK
		q "-102"
	}
	TCOMMIT
	s strRes = "1"
	q strRes
Error
	TROLLBACK
	q "-101"
}

ClassMethod LoadHFVersionJson(AHFVersionID As %String, ByRef argOutData As %GlobalBinaryStream)
{
	q:(""=AHFVersionID) "-200"
	s objHFVersion = ##class(CF.EMR.DOC.HFFormatVersion).%OpenId(AHFVersionID)
	q:(""=objHFVersion) "-301"
	d objHFVersion.XmlPackageData.Rewind()
	while (objHFVersion.XmlPackageData.AtEnd = 0)
	{
		s tmpOut = objHFVersion.XmlPackageData.Read(30000)
		s tmpUtf8 = $zcvt(tmpOut,"I","UTF8")
		d argOutData.Write(tmpUtf8)
  	}
	s strRes = "1"
	q strRes
}

/// desc 获取文档版式最新发布的版本
/// input aID 文档版式ID
ClassMethod GetVersionIDByHFFormat(aID As %String)
{
	q:aID="" ""
	s ObjHFFormat = ##class(CF.EMR.DOC.HFFormat).%OpenId(aID)
	s PublishVersion = ObjHFFormat.PublishVersion
	q PublishVersion
}

/// desc 文档版式版本发布 （测试用：修改数据）
/// input aID 文档版本ID 55
/// output -201
/// debug w ##Class(EMR.DOC.BL.HFFormatVersion).SetPublishVersion()
ClassMethod SetPublishVersion(aID As %String, AMLog As CF.EMR.DOC.HFFormatStatusMLog)
{
	q:aID="" -201
	TSTART
	s ObjVersion = ##class(CF.EMR.DOC.HFFormatVersion).%OpenId(aID)
	q:(ObjVersion="") -301
	s ObjVersion.Status = 2
	s ObjHfformat = ObjVersion.HFFormat
	s ObjHfformat.PublishVersion = aID
	s sc = ObjVersion.%Save()
	if '($$$ISOK(sc))
	{
		TROLLBACK
		q -101
	}
	s sc = ObjHfformat.%Save()
	if '($$$ISOK(sc))
	{
		TROLLBACK
		q -101
	}
	
	s AMLog.Status = "2"
	s AMLog.CreateDate = $ZDATEH($ZDATE($h))
 	s AMLog.CreateTime = $ZTIMEH($ZTIME($PIECE($h,",",2),1))
	s AMLog.ModifyDate = $ZDATEH($ZDATE($h))
	s AMLog.ModifyTime = $ZTIMEH($ZTIME($PIECE($h,",",2),1))
	s AMLog.Remark="版本发布"

	s strMRes = ##Class(EMR.DOC.BL.HFFormatStatusMLog).AddMLog(AMLog)
	if (strMRes ="-1")
	{
		TROLLBACK
		q "-102"
	}
	
	TCOMMIT
	q 1
}

Query GetVersionByID(tempalte As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,versionNumber:%String", SELECTMODE = "RUNTIME") [ SqlName = GetVersionByID, SqlProc ]
{
	select ID,TepmplateVersionNumber from CF_EMR_DOC.TemplateVersion where Template = :template order by ID
}

}
