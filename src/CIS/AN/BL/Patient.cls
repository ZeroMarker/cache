/// 患者业务处理方法类
Class CIS.AN.BL.Patient Extends %RegisteredObject
{

/// w ##class(CIS.AN.BL.Patient).GetInstance(PatientID)
ClassMethod GetInstance(PatientID As %String) As CIS.AN.Patient
{
	set rowId=$O(^CIS.AN.PatientI("IPatID"," "_PatientID,""))
	if ##class(CIS.AN.Patient).%ExistsId(rowId) quit ##class(CIS.AN.Patient).%OpenId(rowId)
	
	quit ""
}

/// w ##class(CIS.AN.BL.Patient).ExistsInstance(PatientID)
ClassMethod ExistsInstance(PatientID As %String) As %Boolean
{
	set rowId=$O(^CIS.AN.PatientI("IPatID"," "_PatientID,""))
	if ##class(CIS.AN.Patient).%ExistsId(rowId) quit 1
	
	quit 0
}

}
