/// 名称:	EMR.DOC.COM.ActionBase
/// 描述:	门诊病历 操作业务类
/// 编写者：yejian
/// 编写日期: 2021-1-12
/// 产品组：电子病历产品组
Class EMR.DOC.BL.EMRAction Extends EMR.DOC.COM.ActionBase
{

/// Desc:       根据Code取CF.EMR.DOC.EMRAction 记录
/// Creator:    yejian
/// CreateDate: 2022-4-13		
/// Input:       parCode
/// OutPut:      ActionName 
/// Debug:       w ##Class(EMR.DOC.BL.EMRAction).GetActionNameByCode("commit")
ClassMethod GetActionNameByCode(parCode As %String, aLangid As %String = "20") As %String
{
	q:(parCode = "") ""
	s rowId = $o(^CF.EMR.DOC.EMRActionI("IdxCode"," "_$zcvt(parCode,"U"),""))
	q:(rowId = "") ""
	s:(aLangid="") aLangid="20"
	s objEMRAction = ##Class(CF.EMR.DOC.EMRAction).%OpenId(rowId)
	s actionName =  ##Class(EMR.DOC.COM.Translation).GetTranByDesc("CF.EMR.DOC.EMRAction","Name",objEMRAction.Name,aLangid)
	q actionName
}

}
