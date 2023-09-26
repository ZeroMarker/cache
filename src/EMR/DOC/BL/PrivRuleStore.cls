/// /// 名称:	EMR.DOC.BL.PrivRuleStore
/// /// 描述:	脚本仓库
/// /// 编写者： huhao
/// /// 编写日期: 2022-4-19
/// /// 产品组：电子病历产品组
Class EMR.DOC.BL.PrivRuleStore Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取规则脚本仓库
/// Creator:    huhao
/// CreateDate: 2022-4-20
/// Input:      argInJson:{"action":"GET_RULESTORELIST","product":"GlobalEMR","params":{"userCode":"YS01","IP":"localhost"}}
/// OutPut:     argOutMessage:成功 1，失败 -1
/// 				argOutData：脚本内容Json数据
ClassMethod GetRuleStore(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s indata = ##class(%DynamicObject).%New()
	s indata.RuleDesc=argInJson.params.RuleDesc
	s indata.RuleCode=argInJson.params.RuleCode
	if ((indata.RuleCode="") && (indata.RuleDesc="") )
	{
   		 s strRes = ##class(EMR.DOC.BL.PrivRuleStore).GetAllCode(.argOutData)
   	}
    else
    {
	    s strRes = ##class(EMR.DOC.BL.PrivRuleStore).GetSearchCode(indata,.argOutData)
	}
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

/// Desc:       获取所有脚本仓库数据
/// Creator:    huhao
/// CreateDate: 2022-4-20
/// Input:     
/// OutPut:     argOutData：脚本JSON数据
ClassMethod GetAllCode(ByRef argOutData As %GlobalBinaryStream) As %String
{
	s resJson=##class(%DynamicArray).%New()
	s strRes="-1"
	s typeID=""
	for
	{
		s typeID=$o(^CF.EMR.DOC.PrivRuleStoreD(typeID))
		q:(typeID = "")			
		s obj = ##Class(CF.EMR.DOC.PrivRuleStore).%OpenId(typeID)
		continue:(obj.Status=0)
        continue:(obj="")
        s resObj  = ##class(%DynamicObject).%New()
        s resObj.key = typeID
        s resObj.RuleDesc =obj.RuleDesc
        s resObj.RuleCode =obj.RuleCode
        d resJson.%Push(resObj)
        s strRes ="1"
	}
	d resJson.%ToJSON(argOutData)
	q strRes
}

/// Desc:       查询脚本仓库数据
/// Creator:    huhao
/// CreateDate: 2022-4-20
/// Input:      RuleCode:脚本内容
/// 				RuleDesc：脚本描述
/// OutPut:     argOutData：脚本JSON数据
ClassMethod GetSearchCode(indata As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s resJson=##class(%DynamicArray).%New()
	s strRes="-1"
	s typeID=""
	for
	{
		s typeID=$o(^CF.EMR.DOC.PrivRuleStoreD(typeID))
		q:(typeID = "")			
		s obj = ##Class(CF.EMR.DOC.PrivRuleStore).%OpenId(typeID)
		continue:(obj.Status=0)
		continue:($find(obj.RuleDesc,indata.RuleDesc)=0)
		continue:($find(obj.RuleCode,indata.RuleCode)=0)
        continue:(obj="")
        s resObj  = ##class(%DynamicObject).%New()
        s resObj.key = typeID
        s resObj.RuleDesc =obj.RuleDesc
        s resObj.RuleCode =obj.RuleCode
        d resJson.%Push(resObj)
        s strRes ="1"
	}
	d resJson.%ToJSON(argOutData)
	q strRes
}

/// Desc:       新增脚本
/// Creator:    huhao
/// CreateDate: 2022-4-20
/// Input:      {"action":"ADD_RULESTORELIST","product":"GlobalEMR","params":{"RuleDesc":"test","RuleCode":"test","userCode":"YS01","IP":"localhost"}}
/// OutPut:     argOutMessage：成功信息 or 失败信息
/// 				argOutData:成功 1，失败 -1
ClassMethod AddRuleStore(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s indata = ##class(%DynamicObject).%New()
	s indata.RuleDesc=argInJson.params.RuleDesc
	s indata.RuleCode=argInJson.params.RuleCode
	s strRes = ##class(EMR.DOC.BL.PrivRuleStore).AddRule(indata,.argOutData)
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
	    q ..SetOutMessage(argOutMessage,"ERROR","添加失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Desc:       新增脚本仓库数据
/// Creator:    huhao
/// CreateDate: 2022-4-20
/// Input:      RuleCode:脚本内容
/// 				RuleDesc：脚本描述
/// OutPut:     argOutData：成功 1，失败 -1^失败信息
ClassMethod AddRule(indata As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes=""
	s rowId=""
	q:(indata.RuleCode="") "-1^脚本内容不能为空"
	q:(indata.RuleDesc="") "-1^脚本名称不能为空"
	s resObj=##Class(CF.EMR.DOC.PrivRuleStore).%New()
	s resObj.RuleCode=indata.RuleCode
	s resObj.RuleDesc=indata.RuleDesc
	S resObj.Status="1"
	s strRes=resObj.%Save()
	q strRes
}

/// Desc:       修改脚本
/// Creator:    huhao
/// CreateDate: 2022-4-20
/// Input:      {"action":"UPDATE_RULESTORELIST","product":"GlobalEMR","params":{"RuleCode":"test1","RuleDesc":"test","Id":"15","userCode":"YS01","IP":"localhost"}}
/// OutPut:     argOutMessage：成功信息 or 失败信息
/// 				argOutData:成功 1，失败 -1
ClassMethod UpdateRuleStore(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s indata = ##class(%DynamicObject).%New()
	s indata.Id=argInJson.params.Id
	s indata.RuleDesc=argInJson.params.RuleDesc
	s indata.RuleCode=argInJson.params.RuleCode
	s strRes = ##class(EMR.DOC.BL.PrivRuleStore).UpdateRule(indata,.argOutData)
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
	    q ..SetOutMessage(argOutMessage,"ERROR","更新出错",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Desc:       更新脚本仓库数据
/// Creator:    huhao
/// CreateDate: 2022-4-20
/// Input:      RuleCode:脚本内容
/// 				RuleDesc：脚本描述
/// OutPut:     argOutData：成功 1，失败 -1^失败信息
ClassMethod UpdateRule(indata As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes=""
	q:(indata.RuleCode="") "-1^请输入需要更新的脚本内容"
	q:(indata.RuleDesc="") "-1^脚本名称不能为空"
	s obj=##Class(CF.EMR.DOC.PrivRuleStore).%OpenId(indata.Id)
	q:obj="" "-1^脚本不存在"
	s obj.RuleCode=indata.RuleCode
	s obj.RuleDesc=indata.RuleDesc
	d obj.%Save()
	s strRes="1"
	q strRes
}

/// Desc:       删除脚本
/// Creator:    huhao
/// CreateDate: 2022-4-20
/// Input:      {"action":"DELETE_RULESTORELIST","product":"GlobalEMR","params":{"Id":"15","userCode":"YS01","IP":"localhost"}}
/// OutPut:     argOutMessage：成功信息 or 失败信息
/// 				argOutData:成功 1，失败 -1
ClassMethod DeleteRuleStore(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ID=argInJson.params.Id
	s strRes = ##class(EMR.DOC.BL.PrivRuleStore).DeleteRule(ID,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","删除出错",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Desc:       删除脚本数据
/// Creator:    huhao
/// CreateDate: 2022-4-20
/// Input:      ID：脚本仓库对应ID
/// OutPut:     argOutData：成功 1，失败 -1^失败信息
ClassMethod DeleteRule(ID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes="1"
	q:ID=""
	s sc=##Class(CF.EMR.DOC.PrivRuleStore).%DeleteId(ID)
	if ('$$$ISOK(sc)) 
	{
		s strRes="-1"
	}
	q strRes
}

/// Desc:       测试脚本
/// Creator:    huhao
/// CreateDate: 2022-10-11
/// Input:      Code：脚本内容
/// OutPut:     返回数据 成功 1,失败 -1,
/// Debug: 	
ClassMethod TestCode(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "ErrorT"
	s enviromentInfo=##class(EMR.DOC.DTO.PrivRuleData).%New()
	s ArrDocIds=##class(%DynamicArray).%New()
	s enviromentInfo.userid=3928
	s enviromentInfo.admid=201871
	s enviromentInfo.patientid=1
	s enviromentInfo.userloc=34
	s enviromentInfo.templateid=822
	s enviromentInfo.documentid=""
	s enviromentInfo.ssgroupid=576
	s enviromentInfo.documentids=ArrDocIds
	s enviromentInfo.categoryid=642
	s enviromentInfo.doccode=""
	s enviromentInfo.sessionid=""
	s enviromentInfo.docname=""
	s enviromentInfo.productcode="OP"
	
	s ScriptCode=argInJson.params.Code
	
	s strRes = ..ParsePrivRule(enviromentInfo,ScriptCode,.argOutData) 
	 
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","脚本内容有误",2)
	}
ErrorT
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Desc:           单条脚本校验
/// Modifier:       huhao
/// ModifyDateDime: 20221011
/// InPut:          aPrivRule 方法参数(userid^3928!admid^201871!patientid^1!documentid^""!userloc^34!templateid^822!ssgroupid^576!categoryid^642!doccode^67)
///                 argType 脚本类型(ActionPrivilege,LoadPrivilege)
/// 				aHospGroupID 院区分组ID
/// 				argProductCode 项目标识（OP 门诊，IP 住院
/// OutPut:         view^1!save^1!print^1!check^0!switch^1!switchtemplate^1!chiefcheck^0!attendingcheck^0!revise^0!commit^1
/// Return 			成功 1，失败 -1^失败信息
ClassMethod ParsePrivRule(aPrivRule As EMR.DOC.DTO.PrivRuleData, ScriptCode As %String, ByRef argOutJson As %DynamicAbstractObject = "") As %String
{
	s argOutJson = {"save":"1","print":"1","delete":"1","check":"1","recheck":"0","revokcheck":"0","reference":"1","export":"1","view":"1","new":"1","copypaste":"1","revise":"-1","viewrevise":"1","appoint":"1","authlevel":"300","commit":"1","applyedit":"0","unlock":"1","transfer":"1","quote":"0","autoapply":"0","patcheck":"1","patrecheck":"1"}
	s strRes = "1"
	s PrivControl = ##class(EMR.DOC.BL.SysOption).GetOptionValueByName("PrivControl",aPrivRule.productcode)
	q:(PrivControl '= "Y") strRes

	q:(ScriptCode = "") ""
	s operators = "save=1"	                       //保存
	s operators = operators_",print=1"		       //打印
	s operators = operators_",delete=1"		       //删除
	s operators = operators_",check=1"	           //医师审核
	s operators = operators_",recheck=0"		   //改签
	s operators = operators_",revokcheck=0"		   //撤销签名
	s operators = operators_",reference=1"         //文档对照
	s operators = operators_",export=1"            //导出文档
	s operators = operators_",view=1"              //查看病历
	s operators = operators_",new=1"               //创建病历
	s operators = operators_",copypaste=1"         //复制粘贴
	s operators = operators_",revise=-1"           //留痕
	s operators = operators_",viewrevise=1"        //显示留痕
	s operators = operators_",appoint=1"           //病历授权
	s operators = operators_",authlevel=300"       //病历授权级别
	s operators = operators_",commit=1"			   //送病案室
	s operators = operators_",applyedit=0"		   //自动审批
	s operators = operators_",unlock=1"		   	   //手工解锁
	s operators = operators_",transfer=1"          //病历转移
    s operators = operators_",quote=0"             //门诊历史病历引用
    s operators = operators_",autoapply=0"		   //门诊自动审批功能
	s operators = operators_",patcheck=1"	   	   //患者签名
	s operators = operators_",patrecheck=1"		   //患者改签
	s strRes = ##Class(EMR.DOC.BL.PrivRuleRun).ParsePrivRuleLogic(operators,aPrivRule,ScriptCode,.argOutJson)
	q strRes
}

}
