/// 名称:	EMR.DOC.BL.EMRLogsView
/// 描述:	病历操作日志查看逻辑类
/// 编写者：yejian
/// 编写日期: 2021-1-12
/// 产品组：电子病历产品组
Class EMR.DOC.BL.EMRLogsView Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取当前病历操作日志
/// Creator:    yejian
/// CreateDate: 2022-10-19
/// Table:		
/// Input:      argInJson  命令参数 {"action": "GET_DETAILLOG","params": {"documentID": "1"},"product": "OP"}
/// 			patientID 住院号 	
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetDetailLog(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s product=argInJson.product
    s documentID=argInJson.params.documentID
	s langID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
    s strRes = ##Class(EMR.DOC.BL.EMRLogsView).GetDetailLogJson(product,documentID,langID,.argOutData)
	//1 获取成功
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

/// Desc:       获取当前病历操作日志
/// Creator:    yejian
/// CreateDate: 2022-10-13
/// Input:      aProduct 项目标识
///             aDocumentID 文档ID
/// OutPut:    	argOutData    返回数据
/// Retrun: 	失败 -1^错误信息，成功 就诊列表
/// debug:     	d ##Class(EMR.DOC.BL.EMRLogsView).GetDetailLogJson()
ClassMethod GetDetailLogJson(aProduct As %String, aDocumentID As %String, aLangid As %String = "20", ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"	
	s strRes = ""
	q:(aDocumentID = "") "-1^文档ID不能为空"
	s arrJson = ##class(%DynamicArray).%New()
	s ds = ##Class(%Library.ResultSet).%New("EMR.DOC.BL.EMRLogsView:GetDetialLog")
	d ds.Execute(aDocumentID,aLangid)
	s json = ""
	s count = 0
	While (ds.Next())
	{
		s jsonItem = ##class(%DynamicObject).%New()
		s jsonItem.OrderID = ds.Data("OrderID")
		s jsonItem.LoginUserName = ds.Data("LoginUser")
		s jsonItem.OperUserName = ds.Data("OperUser")
		s jsonItem.OperDate = ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("OperDate"))
		s jsonItem.OperTime = ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("OperTime"))
		s jsonItem.MachineIP = ds.Data("MachineIP")
		s actionName=""
		if (ds.Data("Action") = "打印")
		{
			s actionName = ds.Data("Action")
			s:(actionName = "") actionName = "已打印"
		}else{
			s actionName = ds.Data("Action")
		}
		s jsonItem.Action = actionName
		s jsonItem.TplName = ds.Data("TplName")
		s jsonItem.CASignID = ds.Data("CASignID")
		s jsonItem.ProductSource = ds.Data("ProductSource")
		s jsonItem.TplCreateDate = ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("TplCreateDate"))
		s jsonItem.TplCreateTime = ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("TplCreateTime"))
		s jsonItem.TplHappenDate = ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("TplHappenDate"))
		s jsonItem.TplHappenTime = ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("TplHappenTime"))
		d arrJson.%Push(jsonItem)
	}
	d arrJson.%ToJSON(argOutData)
	q "1"
Error 
    d argOutData.Write(..#NONE)
	q "-1^Err:"_$zerror
}

/// Desc:       获取患者病历操作日志
/// Creator:    yejian
/// CreateDate: 2022-10-19
/// Table:		
/// Input:      argInJson  命令参数 {"action": "GET_DETIALLOG","params": {"episodeID": "4"},"product": "OP"}
/// 			patientID 住院号 	
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetAllLog(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s product=argInJson.product
    s episodeID=argInJson.params.episodeID
	s langID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
    s strRes = ##Class(EMR.DOC.BL.EMRLogsView).GetAllLogJson(product,episodeID,langID,.argOutData)
	//1 获取成功
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

/// Desc:       获取患者病历操作日志
/// Creator:    yejian
/// CreateDate: 2022-10-13
/// Input:      aProduct 项目标识
///             aEpisodeID 就诊号
/// OutPut:    	argOutData    返回数据
/// Retrun: 	失败 -1^错误信息，成功 就诊列表
/// debug:     	d ##Class(EMR.DOC.BL.EMRLogsView).GetDetailLogJson()
ClassMethod GetAllLogJson(aProduct As %String, aEpisodeID As %String, aLangid As %String = "20", ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"	
	s strRes = ""
	q:(aEpisodeID = "") "-1^就诊号不能为空"
	s arrJson = ##class(%DynamicArray).%New()
	s TILDocLog = ##Class(EMR.DAO.DocLog).GetTureIndexLocation(aEpisodeID)
	s count =0
	s docID = ""
	for {
		s docID = $O(@TILDocLog@("IdxEpisodeIDDoc",aEpisodeID,docID))
		q:(docID="")
		s objDocument = ##class(EMR.DAO.DocumentData).doOpenByID(docID)
		continue:(objDocument="")||(("UnSave"=objDocument.Status))
		s ds = ##Class(%Library.ResultSet).%New("EMR.DOC.BL.EMRLogsView:GetDetialLog")
		d ds.Execute(docID,aLangid)
		s json = ""
		While (ds.Next())
		{
			s jsonItem = ##class(%DynamicObject).%New()
			s count = count+1
			s jsonItem.OrderID = count
			s jsonItem.LoginUserName = ds.Data("LoginUser")
			s jsonItem.OperUserName = ds.Data("OperUser")
			s jsonItem.OperDate = ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("OperDate"))
			s jsonItem.OperTime = ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("OperTime"))
			s jsonItem.MachineIP = ds.Data("MachineIP")
			s actionName=""
			if (ds.Data("Action") = "打印")
			{
				s actionName = ds.Data("ProductSource")
				s:(actionName = "") actionName = "已打印"
			}else{
				s actionName = ds.Data("Action")
			}
			s jsonItem.Action = actionName
			s jsonItem.TplName = ds.Data("TplName")
			s jsonItem.CASignID = ds.Data("CASignID")
			s jsonItem.ProductSource = ds.Data("ProductSource")
			s jsonItem.TplCreateDate = ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("TplCreateDate"))
			s jsonItem.TplCreateTime = ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("TplCreateTime"))
			s jsonItem.TplHappenDate = ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("TplHappenDate"))
			s jsonItem.TplHappenTime = ##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("TplHappenTime"))
			d arrJson.%Push(jsonItem)
		}
	}
	d arrJson.%ToJSON(argOutData)
	q "1"
Error 
    d argOutData.Write(..#NONE)
	q "-1^Err:"_$zerror
}

/// Desc:       病历日志明细
/// Creator:    yejian
/// CreateDate: 2022-10-13
/// Input:      aProduct 项目标识
///           	aDocumentID 目录展现结构挂模板一层的ID
/// OutPut:    	query数据           
/// Debug:      d ##class(%ResultSet).RunQuery("EMR.DOC.BL.EMRLogsView","GetDetialLog",76,35,1)
Query GetDetialLog(aDocumentID As %String, aLangid As %String = "20") As %Query(ROWSPEC = "OrderID:%String, LoginUser:%String,OperUser:%String, OperDate:%String, OperTime:%String, MachineIP:%String, Action:%String, TplName:%String, TplCreateDate:%String, TplCreateTime:%String, ProductSource:%String, CASignID:%String, ProductSourceCode:%String, TplHappenDate:%String, TplHappenTime:%String")
{
}

ClassMethod GetDetialLogExecute(ByRef qHandle As %Binary, aDocumentID As %String, aLangid As %String = "20") As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
 	s ind = 1
 	s objDocument = ##class(EMR.DAO.DocumentData).doOpenByID(aDocumentID)
 	q:(objDocument="") $$$OK
 	s aEpisodeID =objDocument.EpisodeID.%Id()
 	s TILDocLog = ##Class(EMR.DAO.DocLog).GetTureIndexLocation(aEpisodeID)
 	s rowId = ""
 	for
 	{
    	s rowId = $o(@TILDocLog@("IdxDoc",aDocumentID,rowId))
    	q:(rowId = "")
    	s objInstanceLog = ##Class(EMR.DAO.DocLog).doOpenByID(aEpisodeID,rowId)
    	continue:(objInstanceLog = "")
    	s operUserName = objInstanceLog.OperateUserName
    	s operUserName = ##Class(EMR.DOC.COM.Translation).GetTranByDesc("User.SSUser","SSUSRName",objInstanceLog.OperateUserName,aLangid)
    	s loginUserName = objInstanceLog.LoginUserName
    	s loginUserName = ##Class(EMR.DOC.COM.Translation).GetTranByDesc("User.SSUser","SSUSRName",objInstanceLog.LoginUserName,aLangid)
    	s operDate = objInstanceLog.OperateDate
    	s:(operDate '= "") operDate = $zd(operDate,3)
    	s operTime = objInstanceLog.OperateTime
    	s:(operTime '= "") operTime = $zt(operTime,1)
    	s machineIP = objInstanceLog.OperateMachineIP
    	s EMRSignLogID = objInstanceLog.EMRSignLogID
    	s caSignID=""
    	if (EMRSignLogID'="")
    	{
	    	s isSignValid=0
	    	s signLogObj = ##Class(EMR.DAO.EMRSignLog).doOpenByID(aEpisodeID,EMRSignLogID)
	    	s:(signLogObj'="") isSignValid = signLogObj.isValid
	    	s:(signLogObj'="")&(isSignValid=1) caSignID = signLogObj.SignID
	    }
    	s action = objInstanceLog.Action
    	s actionName = ##Class(EMR.DOC.BL.EMRAction).GetActionNameByCode(action)
        s tplName = "",tplCreateDate = "",tplCreateTime = "",tplHappenDate="",tplHappenTime=""
		s tplName =  ##Class(EMR.DOC.COM.Translation).GetTranByDesc("EMR.DB.DocumentData","DOCName",objDocument.DOCName,aLangid)
        s tplCreateDate = $case(objDocument.CreateDate,"":"",:$zd(objDocument.CreateDate,3))
        s tplCreateTime = $case(objDocument.CreateTime,"":"",:$zt(objDocument.CreateTime))
        s tplHappenDate = $case(objDocument.HappenDate,"":"",:$zd(objDocument.HappenDate,3))
        s tplHappenTime = $case(objDocument.HappenTime,"":"",:$zt(objDocument.HappenTime))
		s productSourceCode = objInstanceLog.ProductSource
		s productSource =  ##Class(EMR.DOC.COM.Translation).GetTranByDesc("CF.EMR.DOC.Products","ProductName","电子病历",aLangid)
		if (productSourceCode '= "")
		{
			s productId = $O(^CF.EMR.DOC.ProductsI("ProductCodeIndex"," "_$zcvt(productSourceCode,"U"),""))
	    	if (productId '= "")
	    	{
	    		s objProduct = ##Class(CF.EMR.DOC.Products).%OpenId(productId)
	    		s productSource = ##Class(EMR.DOC.COM.Translation).GetTranByDesc("CF.EMR.DOC.Products","ProductName",objProduct.ProductName,aLangid)
	    	}
		}
        s data = $lb(ind,loginUserName,operUserName,operDate,operTime,machineIP,actionName,tplName,tplCreateDate,tplCreateTime,productSource,caSignID,productSourceCode,tplHappenDate,tplHappenTime)
		s ^CacheTemp(repid,ind) = data
		s ind=ind+1 
 	}
 	k objDocument
	Quit $$$OK
}

ClassMethod GetDetialLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDetialLogExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDetialLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDetialLogExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Desc:       获取当前病历是否打印操作
/// Creator:    yejian
/// CreateDate: 2022-10-19
/// Table:		
/// Input:      argInJson  命令参数 {"action": "GET_DOCHASACTION","params": {"documentID": "1","action":"print"},"product": "OP"}
/// 			documentID 文档ID,action 操作状态(print,save,delete) 	
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetDocHasAction(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s product=argInJson.product
    s documentID=argInJson.params.documentID
	s action = argInJson.params.action
	s action = $case(action,"":"print",:action)
    s strRes = ##Class(EMR.DOC.BL.EMRLogsView).GetDocHasActionJson(product,documentID,action,.argOutData)
	//1 获取成功
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

/// Desc:       获取当前病历是否打印操作
/// Creator:    yejian
/// CreateDate: 2022-10-13
/// Input:      aProduct 项目标识
///             aDocumentID 文档ID
/// 			aAction 操作状态
/// OutPut:    	argOutData    返回数据
/// Retrun: 	失败 -1^错误信息，成功 就诊列表
/// debug:     	d ##Class(EMR.DOC.BL.EMRLogsView).GetDetailLogJson()
ClassMethod GetDocHasActionJson(aProduct As %String, aDocumentID As %String, aAction As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt="Error"
	s strRes = 1
	q:(aDocumentID = "") "-1^文档ID不能为空" 
	q:(aAction="") "-1^操作状态不能为空"
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(aDocumentID)
	q:(objDocument = "") "-1^根据文档ID获取文档失败"
	s EpisodeID = objDocument.EpisodeID.%Id()
	s TILDocLog = ##Class(EMR.DAO.DocLog).GetTureIndexLocation(EpisodeID)
	if ($d(@TILDocLog@("IdxDocActionDateTime",aDocumentID," "_$zcvt(aAction,"U")))>0)
	{	
		d argOutData.Write(""""_objDocument.DOCName_"""")
	}
	else
	{
		d argOutData.Write(""""_0_"""")
	}
    q strRes
Error 
	q "-1^Err:"_$zerror
}

}
