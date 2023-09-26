/// Desc:批量签名逻辑类
Class EMRservice.BL.GroupSignType Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:    取数据
/// Creator: Candy
/// Input:   AType Nur护士 Doc 医生
/// 		 AMedicine 中医：Chinese 西医：""
/// Debug:   w ##class(EMRservice.BL.GroupSignType).GetData("Nur")
ClassMethod GetData(AType As %String, AMedicine As %String = "") As %String
{
	s json = ""
	s type = $case(AType,"":"",:" "_$zcvt(AType,"U"))
	s rowId = ""
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	for
	{
		s rowId = $o(^DHCEMRM.GroupSignTypeI("IdxCategory",type,rowId))
		q:(rowId = "")
		s obj = ##Class(EMRmeta.GroupSignType).%OpenId(rowId)
		continue:(obj = "")
		continue:(obj.Type '= AMedicine)
		s name = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.GroupSignType","Name",obj.Name,langid)
		s:(json '= "") json = json_","
		s json = json_"{"
		s json = json_"""Name"":"""_name_""""
		s json = json_",""Code"":"""_obj.Code_""""
		s json = json_",""GlossaryCode"":"""_obj.GlossaryCode_""""
		s json = json_"}"
	}
	q "["_json_"]"
}

/// Desc:    保存数据
/// Creator: Candy
/// Input:   AName 
ClassMethod SetData(AName As %String, ACode As %String, AGlossary As %String, ACategory As %String, AType As %String = "") As %String
{
	q:(ACode = "") ""
	s rowId = $o(^DHCEMRM.GroupSignTypeI("IdxCodeType"," "_$zcvt(ACode,"U")," "_$zcvt(AType,"U"),""))
	if (rowId = "")	
	{
		s obj = ##Class(EMRmeta.GroupSignType).%New()
	}
	else
	{
		s obj = ##Class(EMRmeta.GroupSignType).%OpenId(rowId)
	}
	s obj.Category = ACategory
	s obj.Code = ACode
	s obj.Name = AName
	s obj.GlossaryCode = AGlossary
	s obj.Type = AType
	d obj.%Save()
	q "1"
}

/// Input:   
/// Debug: d ##Class(EMRservice.BL.GroupSignType).InitData("","Y")
ClassMethod InitData(AType As %String = "", IsDelData As %String = "N")
{
	if (IsDelData="Y")
	{
		K ^DHCEMRM.GroupSignTypeD
		K ^DHCEMRM.GroupSignTypeI
		K ^DHCEMRM.GroupSignTypeS
	}
	d ..SetData("住院医师签名","residentCheck","HDSD00.11.141","Doc","")
	d ..SetData("主治医师签名","attendingCheck","HDSD00.11.138","Doc","")
	d ..SetData("主（副主）任医师签名","chiefCheck,viceChiefCheck","HDSD00.11.137","Doc","")
	d ..SetData("质控医师签名","qcdocCheck","HDSD00.11.128","Doc","")
	d ..SetData("科主任签名","chairmanCheck","HDSD00.11.056","Doc","")
	d ..SetData("主诊医师签名","inChargeCheck","HDSD00.11.574","Doc","")
	d ..SetData("责任护士签名","chargeNurseCheck","HDSD00.11.120","Nur","")
	d ..SetData("质控护士签名","qcnurseCheck","HDSD00.11.128","Nur","")
	
	d ..SetData("住院医师签名","residentCheck","HDSD00.12.168","Doc","Chinese")
	d ..SetData("主治医师签名","attendingCheck","HDSD00.12.165","Doc","Chinese")
	d ..SetData("主（副主）任医师签名","chiefCheck,viceChiefCheck","HDSD00.12.164","Doc","Chinese")
	d ..SetData("质控医师签名","qcdocCheck","HDSD00.12.143","Doc","Chinese")
	d ..SetData("科主任签名","chairmanCheck","HDSD00.12.063","Doc","Chinese")
	d ..SetData("主诊医师签名","inChargeCheck","HDSD00.11.574","Doc","Chinese")
	d ..SetData("责任护士签名","chargeNurseCheck","HDSD00.12.135","Nur","Chinese")
	d ..SetData("质控护士签名","qcnurseCheck","HDSD00.12.141","Nur","Chinese")
}

}
