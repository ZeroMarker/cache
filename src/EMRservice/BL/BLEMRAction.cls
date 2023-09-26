Class EMRservice.BL.BLEMRAction Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator:     Candy
/// CreateDate:  2014-3-19	
/// Desc:        根据parEpisodeID、parEMRStructID和parTemplateID判断当前操作是save还是complete
/// Input:       parEpisodeID, parEMRStructID：打印模板在病历结构表中的ID, parTemplateID: 打印模板下的界面模板ID
/// Return:      1 所有必填界面模板都已保存
/// 			 0 有部分必填界面模板未保存
/// 			 -1 所有界面模板都未保存
/// Others:      
ClassMethod GetSaveType(parEpisodeID As %String, parEMRDocID As %String) As %String
{
	s status = ""
	s status = ##class(EMRservice.EMRDoc.BODocsInGroup).IsAllNecessaryDocReady(parEpisodeID, parEMRDocID)	
	q:(status = "1") 1
	q status
}

/// Creator:     Candy
/// CreateDate:  2014-3-19	
/// Desc:        根据Code取EMRmeta.EMRAction 记录
/// Input:       parCode
/// OutPut:      ActionName 
/// Debug:       w ##Class(EMRservice.BL.BLEMRAction).GetActionNameByCode("commit")
ClassMethod GetActionNameByCode(parCode As %String) As %String
{
	q:(parCode = "") ""
	s rowId = $o(^DHCEMRM.EMRActionI("IdxActionCode"," "_$zcvt(parCode,"U"),""))
	q:(rowId = "") ""
	s objEMRAction = ##Class(EMRmeta.EMRAction).%OpenId(rowId)
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s actionName =  ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRAction","ActionName",objEMRAction.ActionName,langid)
	q actionName
}

/// Creator:     Candy
/// CreateDate:  2014-9-26	
/// Desc:        根据Code取EMRmeta.EMRAction 记录
/// Input:       parName
/// OutPut:      ActionCode 
/// Debug:       w ##Class(EMRservice.BL.BLEMRAction).GetActionCodeByName("提交")
ClassMethod GetActionCodeByName(parName As %String) As %String
{
	s result = ""
	q:(parName = "") result
	s rowId = $o(^DHCEMRM.EMRActionI("IdxActionName"," "_$zcvt(parName,"U"),""))
	q:(rowId = "") result
	s objEMRAction = ##Class(EMRmeta.EMRAction).%OpenId(rowId)
	s result = objEMRAction.ActionCode	
	q result
}

/// Desc:       添加状态数据
/// Creator:    Candy
/// CreateDate: 2016-8-9
/// Input:      ACode
///            AName
/// Debug:      w ##Class(EMRservice.BL.BLEMRAction).AddData("refresherCheck","进修医师签名")
ClassMethod AddData(ACode As %String, AName As %String) As %String
{
	s result = 0
	q:(ACode = "")||(AName = "") result
	s rowId = $o(^DHCEMRM.EMRActionI("IdxActionName"," "_$zcvt(ACode,"U"),""))
	if (rowId = "")
	{
		s obj = ##Class(EMRmeta.EMRAction).%New()
	}
	else
	{
		s obj = ##Class(EMRmeta.EMRAction).%OpenId(rowId)
	}
	s obj.ActionCode = ACode
	s obj.ActionName = AName
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = 1 
	q result
}

}
