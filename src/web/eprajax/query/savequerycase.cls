/// Desc:    用于与前台JS进行ajax交互的应用,实现“查询方案”有关信息的保存操作
/// Creator: 牛才才
Class web.eprajax.query.savequerycase Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s action = $Get(%request.Data("action",1),"")
	
	s CaseNameObj=##class(EPRservice.entity.Query.EQueryCaseName).%New()
	s CaseNameObj.Name=$Get(%request.Data("QueryCaseName",1),"")
	s CaseNameObj.UserID=$Get(%request.Data("SaveUserID",1),"")
	s CaseNameObj.UserName=$Get(%request.Data("SaveUserName",1),"")
	s CaseNameObj.CTLocIDStr= ..UnEscape($Get(%request.Data("CTLocIDStr",1),""))
	s CaseNameObj.GroupIDStr=..UnEscape($Get(%request.Data("GroupIDStr",1),""))

	if (action = "SaveCase")
	{
		s curCaseID = "SaveNewCase"
		s ret = ##Class(EPRservice.BLL.Query.BLSaveQueryCaseInfo).SaveCaseName(curCaseID,CaseNameObj)
		
		if (ret > 0)
		{ 
			s ConditionStr =  ..UnEscape($Get(%request.Data("ConditionArr",1),""))
			d ##Class(EPRservice.BLL.Query.BLSaveQueryCaseInfo).SaveCondition(ConditionStr,ret)
			
			s ResultColsStr =  ..UnEscape($Get(%request.Data("ResultColsArr",1),""))
			d ##Class(EPRservice.BLL.Query.BLSaveQueryCaseInfo).SaveResultCols(ResultColsStr,ret)
			
			w ret
		}
		else
		{
			w ret
		}
	}
	elseif (action = "ModifyCase")
	{
		s curCaseID = $Get(%request.Data("CaseID",1),"")
		s ret = ##Class(EPRservice.BLL.Query.BLSaveQueryCaseInfo).SaveCaseName(curCaseID,CaseNameObj)
		if (ret = curCaseID)
		{
			d ##Class(EPRservice.BLL.Query.BLGetQueryCaseInfo).DeleteConditionByCaseID(curCaseID)
			s ConditionStr =  ..UnEscape($Get(%request.Data("ConditionArr",1),""))
			d ##Class(EPRservice.BLL.Query.BLSaveQueryCaseInfo).SaveCondition(ConditionStr,ret)
			
			d ##Class(EPRservice.BLL.Query.BLGetQueryCaseInfo).DeleteResultColsByCaseID(curCaseID)
			s ResultColsStr =  ..UnEscape($Get(%request.Data("ResultColsArr",1),""))
			d ##Class(EPRservice.BLL.Query.BLSaveQueryCaseInfo).SaveResultCols(ResultColsStr,ret)
			
			w ret
		}
		else
		{
			w ret
		}
	}
	q $$$OK
}

/// Description : 解码非ASCII字符
/// Input ：      InStr: 需要解码的字串
/// Return ：     成功－解码后的字串，失败－"Error"
/// d ##Class(web.eprajax.query.saveCase).UnEscape("insert into CSM.Project (Name,Description,Code,ChargeHospital,ChargeDept,Charger,PrjLevel,StartDate,EndDate,Status) values('%u533B%u9662%u4E34%u5E8A','%u6492%u6253%u7B97%u7684','1001','%u5237%u5237%u5237','%u5446%u5446%u5730','%u5237%u5237%u5237','%u9662%u7EA7','9/7/2010 12:00:00 AM','9/30/2010 12:00:00 AM',NULL)")
ClassMethod UnEscape(InStr As %String) As %String
{
 s $zt="ERROR"
 q:(InStr="") ""
 s num=1,tmpNum=1,retStr=""

 for num=1:1:$l(InStr,"%") {
 	s char=$p(InStr,"%",num)
 	if (num=1)
 	{
 		s retStr=$e(char,1,$l(char))
 	}
 	else
 	{
 		if ($zcvt($e(char,1,1),"U")'="U")
		{
 			s retStr=retStr_$char($zhex($e(char,1,2)))_$e(char,3,$l(char))
 		}
 		else
 		{
 			s retStr=retStr_$char($zhex($e(char,2,5)))_$e(char,6,$l(char))
 		}
 	}
 }
 s retStr=$tr(retStr,"`","%")
 q retStr
ERROR
 q "Error"
}

}
