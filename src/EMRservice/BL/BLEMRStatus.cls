/// Desc:状态逻辑
/// Creaotr:Candy
/// CreateDate:2014-3-19
Class EMRservice.BL.BLEMRStatus Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator:     Candy
/// CreateDate:  2014-3-19	
/// Desc:        根据Code取EMRmeta.EMRStatus 记录
/// Input:       parCode
/// OutPut:      StatusName 
/// Debug:       w ##Class(EMRservice.BL.BLEMRStatus).GetStatusNameByCode("unfinished")	
ClassMethod GetStatusNameByCode(parCode As %String) As %String
{
	s statusName = ""
	q:(parCode = "") statusName
	s rowId = $o(^DHCEMRM.EMRStatusI("IdxStatusCode"," "_$zcvt(parCode,"U"),""))
	q:(rowId = "") statusName
	s objStatus = ##Class(EMRmeta.EMRStatus).%OpenId(rowId)
	q:(objStatus = "") statusName
	s statusName = objStatus.StatusName
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s statusName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.EMRStatus","StatusName",statusName,langid)
	q statusName
}

/// Desc:       添加状态数据
/// Creator:    Candy
/// CreateDate: 2016-8-9
/// Input:      ACode
///            AName
/// Debug:      w ##Class(EMRservice.BL.BLEMRStatus).AddData("coderChecked","编码员签名")
ClassMethod AddData(ACode As %String, AName As %String) As %String
{
	s result = 0
	q:(ACode = "")||(AName = "") result
	s rowId = $o(^DHCEMRM.EMRStatusI("IdxStatusCode"," "_$zcvt(ACode,"U"),""))
	if (rowId = "")
	{
		s obj = ##Class(EMRmeta.EMRStatus).%New()
	}
	else
	{
		s obj = ##Class(EMRmeta.EMRStatus).%OpenId(rowId)
	}
	s obj.StatusCode = ACode
	s obj.StatusName = AName
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = 1 
	q result
}

}
