Class EMRservice.Observer.SubjectEPRInfo Extends %RegisteredObject [ ProcedureBlock ]
{

/// w ##Class(EMRservice.Observer.SubjectEPRInfo).RegInfo("WMRInfection","SAVE|67","67","病案首页","#TYPE:Simple#TID:67#TVER:0#SCODE:I0556#VTYPE:CANDV","出院诊断","0")
ClassMethod RegEPRInfo(ASubjectType, ASubjectEvent, ATemplateID, ATemplateDesc, AEPRItemCode, AEPRItmeDesc, AValueCodeIsRowID) As %String
{
	s subjectInfoID = ..GetEPRInfoID(ASubjectType, ASubjectEvent, ATemplateID, AEPRItemCode)
	if (subjectInfoID = "")
	{
		s subjectInfoID = ..InsertEPRInfo(ASubjectType, ASubjectEvent, ATemplateID, ATemplateDesc, AEPRItemCode, AEPRItmeDesc, AValueCodeIsRowID)
	}
	else
	{
		do ..UpdateEPRInfo(subjectInfoID, ASubjectType, ASubjectEvent, ATemplateID, ATemplateDesc, AEPRItemCode, AEPRItmeDesc, AValueCodeIsRowID)
	}
	
	q subjectInfoID
}

ClassMethod GetEPRInfoID(ASubjectType, ASubjectEvent, ATemplateID, AEPRItemCode) As %String
{
	s subjectEPRInfoID = $O(^DHCEMRM.SubjectEPRInfoI("IdxMain"," "_$zcvt(ASubjectType,"u")," "_$zcvt(ASubjectEvent,"u")," "_ATemplateID," "_$zcvt(AEPRItemCode,"u"),""))
	q subjectEPRInfoID
}

ClassMethod InsertEPRInfo(ASubjectType, ASubjectEvent, ATemplateID, ATemplateDesc, AEPRItemCode, AEPRItmeDesc, AValueCodeIsRowID) As %String
{
	s obj = ##Class(EMRmeta.SubjectEPRInfo).%New()
	s obj.SubjectType = ASubjectType
	s obj.SubjectEvent = ASubjectEvent
	s obj.EPRTemplateID = ATemplateID
	s obj.EPRTemplateDesc = ATemplateDesc
	s obj.EPRItemCode = AEPRItemCode
	s obj.EPRItemDesc = AEPRItmeDesc
	s obj.ValueCodeIsRowID = AValueCodeIsRowID
	s sc = obj.%Save()
	if $$$ISOK(sc)
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

ClassMethod UpdateEPRInfo(ASubjectEPRInfoID, ASubjectType, ASubjectEvent, ATemplateID, ATemplateDesc, AEPRItemCode, AEPRItmeDesc, AValueCodeIsRowID) As %String
{
	s obj = ##Class(EMRmeta.SubjectEPRInfo).%OpenId(ASubjectEPRInfoID)
	q:(obj = "") ""
	
	s obj.SubjectType = ASubjectType
	s obj.SubjectEvent = ASubjectEvent
	s obj.EPRTemplateID = ATemplateID
	s obj.EPRTemplateDesc = ATemplateDesc
	s obj.EPRItemCode = AEPRItemCode
	s obj.EPRItemDesc = AEPRItmeDesc
	s obj.ValueCodeIsRowID = AValueCodeIsRowID
	s sc = obj.%Save()
	if $$$ISOK(sc)
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

/// w ##Class(EMRservice.Observer.SubjectEPRInfo).GetInfoByType("201764","WMRInfection","SAVE|67")
ClassMethod GetInfoByType(AEpisodeID As %String, ASubjectType As %String, ASubjectEvent As %String, AInstanceDataID As %String = "") As %String
{
	s value = ""
	
	if (ASubjectType = "WMRInfection") 
	{
		s value = ..GetWMRInfectionItem(AEpisodeID, ASubjectEvent)
	}
	
	q value
}

/// Desc:	自定义的病案首页诊断信息
/// Return:	itemRowID1_"^"_itemCode1_"^"_itemDesc1_$c(1)_itemRowID2_"^"_itemCode2_"^"_itemDesc2 
ClassMethod GetWMRInfectionItem(AEpisodeID As %String, ASubjectEvent As %String, AInstanceDataID As %String = "") As %String
{
	//b "s"
	s retValue = ""
	
	s bigType = " WMRINFECTION", bigEvent = " "_$zcvt(ASubjectEvent,"u")
	s subEPRInfoID = ""
	for {
		s subEPRInfoID = $O(^DHCEMRM.SubjectEPRInfoI("IdxTypeEvent",bigType,bigEvent,subEPRInfoID))
		q:(subEPRInfoID="")
		
		s obj = ##Class(EMRmeta.SubjectEPRInfo).%OpenId(subEPRInfoID)
		continue:(obj = "")
		
		s oneDiag = obj.EPRItemCode
		continue:(oneDiag="")||(oneDiag=$c(0))
		s isRowID = obj.ValueCodeIsRowID
		
		//b "s"
		if (AInstanceDataID = "")
		{	
			s itemValue = ##Class(EMRservice.BL.BLScatterData).GetScatterData(AEpisodeID,oneDiag,"")
		}
		else
		{
			s itemValue = ##Class(EMRservice.BL.BLScatterData).GetScatterData(AEpisodeID,oneDiag,AInstanceDataID)
		}
		if (itemValue '= "")&&(itemValue '= "^")
		{
			s itemRowID = "", itemCode = "", itemDesc = ""
			
			if (isRowID = "1")
			{
				s itemRowID = $p(itemValue, "^", 1)
				s:(itemRowID'="") itemCode = $p($g(^MRC("ID",itemRowID)),"^",4)
				s itemDesc = $p(itemValue, "^", 2)
			}
			else
			{
				s itemRowID = ""
				s itemCode = $P(itemValue,"^", 1)
				s itemDesc = $p(itemValue,"^", 2)
			}
			
			if (retValue = "")
			{	s retValue = itemRowID_"^"_itemCode_"^"_itemDesc }
			else
			{	s retValue = retValue_$c(1)_itemRowID_"^"_itemCode_"^"_itemDesc }
		}
	}
	
	q retValue
}

/// d ##Class(EMRservice.Observer.SubjectEPRInfo).Init()
ClassMethod Init() As %String
{
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|67","67","病案首页","#TYPE:Simple#TID:67#TVER:0#SCODE:I0556#VTYPE:CANDV","入院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|67","67","病案首页","#TYPE:Simple#TID:67#TVER:0#SCODE:I0600#VTYPE:CANDV","门急诊诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|67","67","病案首页","#TYPE:Simple#TID:67#TVER:0#SCODE:I0512#VTYPE:CANDV","出院诊断1","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|67","67","病案首页","#TYPE:Simple#TID:67#TVER:0#SCODE:I0511#VTYPE:CANDV","出院诊断2","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|67","67","病案首页","#TYPE:Simple#TID:67#TVER:0#SCODE:I0513#VTYPE:CANDV","出院诊断3","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|67","67","病案首页","#TYPE:Simple#TID:67#TVER:0#SCODE:I0514#VTYPE:CANDV","出院诊断4","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|67","67","病案首页","#TYPE:Simple#TID:67#TVER:0#SCODE:I0515#VTYPE:CANDV","出院诊断5","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|67","67","病案首页","#TYPE:Simple#TID:67#TVER:0#SCODE:I0516#VTYPE:CANDV","出院诊断6","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|67","67","病案首页","#TYPE:Simple#TID:67#TVER:0#SCODE:I0517#VTYPE:CANDV","出院诊断7","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|67","67","病案首页","#TYPE:Simple#TID:67#TVER:0#SCODE:I0518#VTYPE:CANDV","出院诊断8","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|67","67","病案首页","#TYPE:Simple#TID:67#TVER:0#SCODE:I0519#VTYPE:CANDV","出院诊断9","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|67","67","病案首页","#TYPE:Simple#TID:67#TVER:0#SCODE:I0520#VTYPE:CANDV","出院诊断10","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|67","67","病案首页","#TYPE:Simple#TID:67#TVER:0#SCODE:I0521#VTYPE:CANDV","出院诊断11","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|67","67","病案首页","#TYPE:Simple#TID:67#TVER:0#SCODE:I0522#VTYPE:CANDV","出院诊断12","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|67","67","病案首页","#TYPE:Simple#TID:67#TVER:0#SCODE:I0523#VTYPE:CANDV","出院诊断13","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|67","67","病案首页","#TYPE:Simple#TID:67#TVER:0#SCODE:I0524#VTYPE:CANDV","出院诊断14","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|67","67","病案首页","#TYPE:Simple#TID:67#TVER:0#SCODE:I0525#VTYPE:CANDV","出院诊断15","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|67","67","病案首页","#TYPE:Simple#TID:67#TVER:0#SCODE:I0526#VTYPE:CANDV","出院诊断16","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|67","67","病案首页","#TYPE:Simple#TID:67#TVER:0#SCODE:I0527#VTYPE:CANDV","出院诊断17","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|67","67","病案首页","#TYPE:Simple#TID:67#TVER:0#SCODE:I0528#VTYPE:CANDV","出院诊断18","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|67","67","病案首页","#TYPE:Simple#TID:67#TVER:0#SCODE:I0529#VTYPE:CANDV","出院诊断19","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|67","67","病案首页","#TYPE:Simple#TID:67#TVER:0#SCODE:I0530#VTYPE:CANDV","出院诊断20","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|67","67","病案首页","#TYPE:Simple#TID:67#TVER:0#SCODE:I0531#VTYPE:CANDV","出院诊断21","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|67","67","病案首页","#TYPE:Simple#TID:67#TVER:0#SCODE:I0532#VTYPE:CANDV","出院诊断22","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|67","67","病案首页","#TYPE:Simple#TID:67#TVER:0#SCODE:I0533#VTYPE:CANDV","出院诊断23","0")
	
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|41","41","住院病历-初步诊断","#TYPE:Simple#TID:41#TVER:0#SCODE:I0016#VTYPE:CANDV","入院诊断1","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|41","41","住院病历-初步诊断","#TYPE:Simple#TID:41#TVER:0#SCODE:I0007#VTYPE:CANDV","入院诊断2","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|41","41","住院病历-初步诊断","#TYPE:Simple#TID:41#TVER:0#SCODE:I0008#VTYPE:CANDV","入院诊断3","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|41","41","住院病历-初步诊断","#TYPE:Simple#TID:41#TVER:0#SCODE:I0009#VTYPE:CANDV","入院诊断4","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|41","41","住院病历-初步诊断","#TYPE:Simple#TID:41#TVER:0#SCODE:I0010#VTYPE:CANDV","入院诊断5","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|41","41","住院病历-初步诊断","#TYPE:Simple#TID:41#TVER:0#SCODE:I0011#VTYPE:CANDV","入院诊断6","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|41","41","住院病历-初步诊断","#TYPE:Simple#TID:41#TVER:0#SCODE:I0012#VTYPE:CANDV","入院诊断7","0")
	
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|42","42","住院病历-初步诊断","#TYPE:Simple#TID:42#TVER:0#SCODE:I0136#VTYPE:CANDV","入院诊断1","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|42","42","住院病历-初步诊断","#TYPE:Simple#TID:42#TVER:0#SCODE:I0146#VTYPE:CANDV","入院诊断2","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|42","42","住院病历-初步诊断","#TYPE:Simple#TID:42#TVER:0#SCODE:I0145#VTYPE:CANDV","入院诊断3","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|42","42","住院病历-初步诊断","#TYPE:Simple#TID:42#TVER:0#SCODE:I0144#VTYPE:CANDV","入院诊断4","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|42","42","住院病历-初步诊断","#TYPE:Simple#TID:42#TVER:0#SCODE:I0143#VTYPE:CANDV","入院诊断5","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|42","42","住院病历-初步诊断","#TYPE:Simple#TID:42#TVER:0#SCODE:I0142#VTYPE:CANDV","入院诊断6","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|42","42","住院病历-初步诊断","#TYPE:Simple#TID:42#TVER:0#SCODE:I0141#VTYPE:CANDV","入院诊断7","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|42","42","住院病历-初步诊断","#TYPE:Simple#TID:42#TVER:0#SCODE:I0140#VTYPE:CANDV","入院诊断8","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|42","42","住院病历-初步诊断","#TYPE:Simple#TID:42#TVER:0#SCODE:I0139#VTYPE:CANDV","入院诊断9","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|42","42","住院病历-初步诊断","#TYPE:Simple#TID:42#TVER:0#SCODE:I0138#VTYPE:CANDV","入院诊断10","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|42","42","住院病历-初步诊断","#TYPE:Simple#TID:42#TVER:0#SCODE:I0137#VTYPE:CANDV","入院诊断11","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|42","42","住院病历-初步诊断","#TYPE:Simple#TID:42#TVER:0#SCODE:I0152#VTYPE:CANDV","入院诊断12","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|42","42","住院病历-初步诊断","#TYPE:Simple#TID:42#TVER:0#SCODE:I0153#VTYPE:CANDV","入院诊断13","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|42","42","住院病历-初步诊断","#TYPE:Simple#TID:42#TVER:0#SCODE:I0150#VTYPE:CANDV","入院诊断14","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|42","42","住院病历-初步诊断","#TYPE:Simple#TID:42#TVER:0#SCODE:I0151#VTYPE:CANDV","入院诊断15","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|42","42","住院病历-初步诊断","#TYPE:Simple#TID:42#TVER:0#SCODE:I0147#VTYPE:CANDV","入院诊断16","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|42","42","住院病历-初步诊断","#TYPE:Simple#TID:42#TVER:0#SCODE:I0149#VTYPE:CANDV","入院诊断17","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|42","42","住院病历-初步诊断","#TYPE:Simple#TID:42#TVER:0#SCODE:I0154#VTYPE:CANDV","入院诊断19","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|42","42","住院病历-初步诊断","#TYPE:Simple#TID:42#TVER:0#SCODE:I0156#VTYPE:CANDV","入院诊断20","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|42","42","住院病历-初步诊断","#TYPE:Simple#TID:42#TVER:0#SCODE:I0148#VTYPE:CANDV","入院诊断18","0")
	
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|43","43","入院记录(中医科)","#TYPE:Segment#TID:44#TVER:0#GCODE:G0091","初步诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|43","43","入院记录(中医科)","#TYPE:Segment#TID:44#TVER:0#GCODE:G0111","初步诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|43","43","入院记录(中医科)","#TYPE:Segment#TID:44#TVER:0#GCODE:G0112","初步诊断","0")


	
	
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|55","55","通用出院记录","#TYPE:Simple#TID:55#TVER:0#SCODE:I0189#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|55","55","通用出院记录","#TYPE:Simple#TID:55#TVER:0#SCODE:I0190#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|55","55","通用出院记录","#TYPE:Simple#TID:55#TVER:0#SCODE:I0191#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|55","55","通用出院记录","#TYPE:Simple#TID:55#TVER:0#SCODE:I0192#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|55","55","通用出院记录","#TYPE:Simple#TID:55#TVER:0#SCODE:I0193#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|55","55","通用出院记录","#TYPE:Simple#TID:55#TVER:0#SCODE:I0194#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|55","55","通用出院记录","#TYPE:Simple#TID:55#TVER:0#SCODE:I0195#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|55","55","通用出院记录","#TYPE:Simple#TID:55#TVER:0#SCODE:I0196#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|55","55","通用出院记录","#TYPE:Simple#TID:55#TVER:0#SCODE:I0198#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|55","55","通用出院记录","#TYPE:Simple#TID:55#TVER:0#SCODE:I0199#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|55","55","通用出院记录","#TYPE:Simple#TID:55#TVER:0#SCODE:I0200#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|55","55","通用出院记录","#TYPE:Simple#TID:55#TVER:0#SCODE:I0201#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|55","55","通用出院记录","#TYPE:Simple#TID:55#TVER:0#SCODE:I0202#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|55","55","通用出院记录","#TYPE:Simple#TID:55#TVER:0#SCODE:I0203#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|55","55","通用出院记录","#TYPE:Simple#TID:55#TVER:0#SCODE:I0204#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|55","55","通用出院记录","#TYPE:Simple#TID:55#TVER:0#SCODE:I0205#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|55","55","通用出院记录","#TYPE:Simple#TID:55#TVER:0#SCODE:I0206#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|55","55","通用出院记录","#TYPE:Simple#TID:55#TVER:0#SCODE:I0207#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|55","55","通用出院记录","#TYPE:Simple#TID:55#TVER:0#SCODE:I0208#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|55","55","通用出院记录","#TYPE:Simple#TID:55#TVER:0#SCODE:I0209#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|55","55","通用出院记录","#TYPE:Simple#TID:55#TVER:0#SCODE:I0210#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|55","55","通用出院记录","#TYPE:Simple#TID:55#TVER:0#SCODE:I0211#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|55","55","通用出院记录","#TYPE:Simple#TID:55#TVER:0#SCODE:I0212#VTYPE:CANDV","出院诊断","0")

	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|101","101","出院记录","#TYPE:Simple#TID:101#TVER:0#SCODE:I0244#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|101","101","出院记录","#TYPE:Simple#TID:101#TVER:0#SCODE:I0245#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|101","101","出院记录","#TYPE:Simple#TID:101#TVER:0#SCODE:I0246#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|101","101","出院记录","#TYPE:Simple#TID:101#TVER:0#SCODE:I0247#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|101","101","出院记录","#TYPE:Simple#TID:101#TVER:0#SCODE:I0248#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|101","101","出院记录","#TYPE:Simple#TID:101#TVER:0#SCODE:I0249#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|101","101","出院记录","#TYPE:Simple#TID:101#TVER:0#SCODE:I0250#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|101","101","出院记录","#TYPE:Simple#TID:101#TVER:0#SCODE:I0251#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|101","101","出院记录","#TYPE:Simple#TID:101#TVER:0#SCODE:I0252#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|101","101","出院记录","#TYPE:Simple#TID:101#TVER:0#SCODE:I0253#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|101","101","出院记录","#TYPE:Simple#TID:101#TVER:0#SCODE:I0254#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|101","101","出院记录","#TYPE:Simple#TID:101#TVER:0#SCODE:I0255#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|101","101","出院记录","#TYPE:Simple#TID:101#TVER:0#SCODE:I0256#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|101","101","出院记录","#TYPE:Simple#TID:101#TVER:0#SCODE:I0257#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|101","101","出院记录","#TYPE:Simple#TID:101#TVER:0#SCODE:I0258#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|101","101","出院记录","#TYPE:Simple#TID:101#TVER:0#SCODE:I0259#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|101","101","出院记录","#TYPE:Simple#TID:101#TVER:0#SCODE:I0260#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|101","101","出院记录","#TYPE:Simple#TID:101#TVER:0#SCODE:I0261#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|101","101","出院记录","#TYPE:Simple#TID:101#TVER:0#SCODE:I0262#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|101","101","出院记录","#TYPE:Simple#TID:101#TVER:0#SCODE:I0263#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|101","101","出院记录","#TYPE:Simple#TID:101#TVER:0#SCODE:I0264#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|101","101","出院记录","#TYPE:Simple#TID:101#TVER:0#SCODE:I0265#VTYPE:CANDV","出院诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|101","101","出院记录","#TYPE:Simple#TID:101#TVER:0#SCODE:I0266#VTYPE:CANDV","出院诊断","0")

	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|126","126","中医出院记录","#TYPE:Simple#TID:126#TVER:0#SCODE:S0065#VTYPE:CANDV","中医诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|126","126","中医出院记录","#TYPE:Simple#TID:126#TVER:0#SCODE:S0066#VTYPE:CANDV","中医诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|126","126","中医出院记录","#TYPE:Simple#TID:126#TVER:0#SCODE:S0061#VTYPE:CANDV","中医诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|126","126","中医出院记录","#TYPE:Simple#TID:126#TVER:0#SCODE:S0060#VTYPE:CANDV","中医诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|126","126","中医出院记录","#TYPE:Simple#TID:126#TVER:0#SCODE:S0071#VTYPE:CANDV","中医诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|126","126","中医出院记录","#TYPE:Simple#TID:126#TVER:0#SCODE:S0072#VTYPE:CANDV","中医诊断","0")
	
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|126","126","中医出院记录","#TYPE:Simple#TID:126#TVER:0#SCODE:S0059#VTYPE:CANDV","西医诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|126","126","中医出院记录","#TYPE:Simple#TID:126#TVER:0#SCODE:S0063#VTYPE:CANDV","西医诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|126","126","中医出院记录","#TYPE:Simple#TID:126#TVER:0#SCODE:S0058#VTYPE:CANDV","西医诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|126","126","中医出院记录","#TYPE:Simple#TID:126#TVER:0#SCODE:S0074#VTYPE:CANDV","西医诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|126","126","中医出院记录","#TYPE:Simple#TID:126#TVER:0#SCODE:S0073#VTYPE:CANDV","西医诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|126","126","中医出院记录","#TYPE:Simple#TID:126#TVER:0#SCODE:S0057#VTYPE:CANDV","西医诊断","0")
	
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|99","99","修正诊断","#TYPE:Simple#TID:99#TVER:0#SCODE:I0001#VTYPE:CANDV","修正诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|99","99","修正诊断","#TYPE:Simple#TID:99#TVER:0#SCODE:I0002#VTYPE:CANDV","修正诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|99","99","修正诊断","#TYPE:Simple#TID:99#TVER:0#SCODE:I0003#VTYPE:CANDV","修正诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|99","99","修正诊断","#TYPE:Simple#TID:99#TVER:0#SCODE:I0004#VTYPE:CANDV","修正诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|99","99","修正诊断","#TYPE:Simple#TID:99#TVER:0#SCODE:I0005#VTYPE:CANDV","修正诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|99","99","修正诊断","#TYPE:Simple#TID:99#TVER:0#SCODE:I0006#VTYPE:CANDV","修正诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|99","99","修正诊断","#TYPE:Simple#TID:99#TVER:0#SCODE:I0007#VTYPE:CANDV","修正诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|99","99","修正诊断","#TYPE:Simple#TID:99#TVER:0#SCODE:I0008#VTYPE:CANDV","修正诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|99","99","修正诊断","#TYPE:Simple#TID:99#TVER:0#SCODE:I0009#VTYPE:CANDV","修正诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|99","99","修正诊断","#TYPE:Simple#TID:99#TVER:0#SCODE:I00010#VTYPE:CANDV","修正诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|99","99","修正诊断","#TYPE:Simple#TID:99#TVER:0#SCODE:I00014#VTYPE:CANDV","修正诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|99","99","修正诊断","#TYPE:Simple#TID:99#TVER:0#SCODE:I00015#VTYPE:CANDV","修正诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|99","99","修正诊断","#TYPE:Simple#TID:99#TVER:0#SCODE:I00016#VTYPE:CANDV","修正诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|99","99","修正诊断","#TYPE:Simple#TID:99#TVER:0#SCODE:I00017#VTYPE:CANDV","修正诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|99","99","修正诊断","#TYPE:Simple#TID:99#TVER:0#SCODE:I00018#VTYPE:CANDV","修正诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|99","99","修正诊断","#TYPE:Simple#TID:99#TVER:0#SCODE:I00019#VTYPE:CANDV","修正诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|99","99","修正诊断","#TYPE:Simple#TID:99#TVER:0#SCODE:I00020#VTYPE:CANDV","修正诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|99","99","修正诊断","#TYPE:Simple#TID:99#TVER:0#SCODE:I00021#VTYPE:CANDV","修正诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|99","99","修正诊断","#TYPE:Simple#TID:99#TVER:0#SCODE:I00022#VTYPE:CANDV","修正诊断","0")
	w !, ##Class(EMRservice.Observer.SubjectEPRInfo).RegEPRInfo("WMRInfection","SAVE|99","99","修正诊断","#TYPE:Simple#TID:99#TVER:0#SCODE:I00023#VTYPE:CANDV","修正诊断","0")
}

}
