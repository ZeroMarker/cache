Class web.CFPatConf Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 141;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "PATCF_EmergencySurChargeCode";

Parameter SQLDESCRIPTION = "PATCF_RowID";

Parameter SQLROWID = "PATCF_RowID";

/// 24/09/02 Log#28003 HP: Get allow discharge without financial discharge (AllowDisWOFin).
///  Used by PAAdm.EditEmergency and PAADMDischarge.Edit components.->AllowDisWOFin
/// wanghc PAADMDischarge.Edit components.->AllowDisWOFin
/// w ##Class(web.CFPatConf).GetAllowInpatDischWOFin()
ClassMethod GetAllowInpatDischWOFin() As %Library.String
{
	n rowid,objCF,val
	s val=""
	s rowid=$o(^CF("PATCF",0))
	s objCF=##class(User.CFPatConf).%OpenId(rowid)
	i $IsObject(objCF) s val=objCF.PATCFAllowInpatDischWOFin
	q val
}

/// wanghc 拿默认reason;出院结算界面PAADMDischarge.Edit->DefaultBedNotReadyReason
ClassMethod GetBedUnavailableReason()
{
	n rowid,objCF,val
	s rowid=$o(^CF("PATCF",0))
	s val=""
	s objCF=##class(User.CFPatConf).%OpenId(rowid)
	i $IsObject(objCF.PATCFUnavailBedStatus) s val=objCF.PATCFUnavailBedStatus.RNAVDesc
	q val
}

/// Gets the value a a field or the reference field if possible.
/// Field is the class property name of the field to retrieve.
/// If ChildField is also passed, retrives the ChildField reference from the Field reference pointer.
/// 
/// Note. No error checking, it is up to the calling code to pass correct parameters.
ClassMethod GetConfiguration(Field As %Library.String, ChildField As %Library.String = "") As %Library.String
{
	n ret,exp,cfobj
	s ret=""
	s cfobj=##class(User.CFPatConf).%OpenId(1)
	s exp="set cfobj=##class(User.CFPatConf).%OpenId(1) if $IsObject(cfobj) s ret=cfobj."_Field
	x exp
	if ChildField'=""&&$IsObject(ret){
		s exp = "s ret = ret."_ChildField
		x exp
	}
	Q ret
}

/// 08/11/02 Log#29719 HP: Get "Do Not Populate Discharge Date and Time for On Leave" set in system parameters.
/// Used by PAADMDischarge.Edit component.
/// zhouzq w ##Class(web.CFPatConf).GetNotPopDischDTOnLeave()
ClassMethod GetNotPopDischDTOnLeave() As %Library.String
{
	n objCF,val,rowid
	s val=""
	s rowid=$o(^CF("PATCF",0))
	s objCF=##class(User.CFPatConf).%OpenId(rowid)
	i $IsObject(objCF) s val=objCF.PATCFNotPopDischDateTimeOnLeave
	q val
}

/// Purpose - To return the NoOfYearsAgeSearch system parameter
/// Author - John Hart
/// by wuqk 2011-06-17
/// 原方法中包含request参数，暂不清楚如何处理，从界面的隐藏元素值看，暂输出常量
ClassMethod GetSystemConfig() As %Library.String
{
	quit "^^1^14^12^24^^^^^^"
}

ClassMethod ShowMonthsAfterInactive() As %Library.String
{
}

}
