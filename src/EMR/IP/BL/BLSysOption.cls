/// 名称:	EMR.IP.BL.BLSysOption
/// 描述:	系统参数业务逻辑类
/// 编写者：lifengbo 
/// 编写日期: 2023-03-09
/// 产品组：电子病历产品组 copyfrom  EMR.IP.BL.BLSysOption
Class EMR.IP.BL.BLSysOption Extends EMR.IP.COM.ActionBase
{

/// Desc:       根据名称获取系统参数值
/// Creator:    lifengbo
/// CreateDate: 2023-03-09
/// Input:      AName 名称
/// 			ADefaultValue 默认值 
/// OutPut:     返回系统参数值
/// Debug:     	s ret =[{"btnSave":"保存"},{"btnPrint":"打印"}]
/// 			w ##class(EMR.IP.BL.BLSysOption).GetOptionValueByName("OPEmrButtons","")
ClassMethod GetOptionValueByName(AName As %String, ADefaultValue As %String = "") As %String
{
	s sysOptionValue = ""
	s sysOptionValue=##Class(EMR.DOC.BL.SysOption).GetOptionValueByName(AName,..#ProductCode,ADefaultValue)
	q sysOptionValue
}

}
