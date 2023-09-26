/// 名称:	EMR.DOC.BL.EMRStatus
/// 描述:	病历操作状态类
/// 编写者：yejian
/// 编写日期: 2021-1-12
/// 产品组：电子病历产品组
Class EMR.DOC.BL.EMRStatus Extends EMR.DOC.COM.ActionBase
{

/// Desc:       根据Code取EMRmeta.EMRStatus 记录
/// Creator:    yejian
/// CreateDate: 2022-4-13	
/// Input:       parCode
/// OutPut:      StatusName 
/// Debug:       w ##Class(EMR.DOC.BL.EMRStatus).GetStatusNameByCode("unfinished")	
ClassMethod GetStatusNameByCode(parCode As %String, aLangID As %String = "20") As %String
{
	s statusName = ""
	q:(parCode = "") statusName
	s rowId = $o(^CF.EMR.DOC.EMRStatusI("IdxCode"," "_$zcvt(parCode,"U"),""))
	q:(rowId = "") statusName
	s objStatus = ##Class(CF.EMR.DOC.EMRStatus).%OpenId(rowId)
	q:(objStatus = "") statusName
	s statusName = objStatus.Name
	s statusName = ##Class(EMR.DOC.COM.Translation).GetTranByDesc("EMRmeta.EMRStatus","StatusName",statusName,aLangID)
	q statusName
}

}
