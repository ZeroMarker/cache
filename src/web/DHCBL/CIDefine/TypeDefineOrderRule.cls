Import SQLUser

Class web.DHCBL.CIDefine.TypeDefineOrderRule Extends (%RegisteredObject, %XML.Adaptor, web.DHCBL.BLAbstract) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter EntityClassName = "web.DHCEntity.CIDefine.TypeDefineOrderRule";

Parameter PersistentClassName = "User.DHCCITypeDefineOrderRule";

ClassMethod DTOTransObj(DTObj As %ObjectHandle) As %ObjectHandle
{
	;w ##class(web.DHCBL.CIDefine.TypeDefineOrderRule).DHCAuditSaveDataToServer(^TMPXmlData)
	b	;;
	s myPObj=""
	s myNewFlag=0
	i DTObj.CTDRowID=""{
		q myPObj
	}
	
	s myParObj=##class(User.DHCCITypeDefine).%OpenId(DTObj.CTDRowID)
	if ('$IsObject(myParObj)){
		q myPObj
	}
	
	i DTObj.TORRowID="" {
		s myPObj=##class(User.DHCCITypeDefineOrderRule).%New()
		s myPObj.TORCTDParRef=myParObj
		s myNewFlag=1
	}else{
		s myPObj=##class(User.DHCCITypeDefineOrderRule).%OpenId(DTObj.TORRowID)
	}
	
	s myPObj.TORActiveFlag = DTObj.TORActiveFlag
	
	d myPObj.TORCTHospitalDRSetObjectId(DTObj.TORCTHospitalDR)
	d myPObj.TORRecLocDRSetObjectId(DTObj.TORRecLocDR)
	
	s myDate=""
	i (DTObj.TORDateFrom["/"){
		s myDate=$zdh(DTObj.TORDateFrom,4)
		
	}elseif(DTObj.TORDateFrom["-"){
		s myDate=$zdh(DTObj.TORDateFrom,3)
	}else{
		s myDate=+$h
	}
	
	s myPObj.TORDateFrom=myDate
	
	s myDate=""
	i (DTObj.TORDateTo["/"){
		s myDate=$zdh(DTObj.TORDateTo,4)
		
	}elseif(DTObj.TORDateTo["-"){
		s myDate=$zdh(DTObj.TORDateTo,3)
	}else{
		s myDate=""
	}
	s myPObj.TORDateTo=myDate
	
	s myTime=""
	if DTObj.TORTimeFrom[":"{
		s myTime=$zth(DTObj.TORTimeFrom)
	}
	s myPObj.TORTimeFrom=myTime
	
	s myTime=""
	if (DTObj.TORTimeTo[":"){
		s myTime=$zth(DTObj.TORTimeTo)
	}
	s myPObj.TORTimeTo=myTime
	
	i (+myNewFlag){
	}
	
	d myParObj.%Close()
	
	q myPObj
}

Query SelectAllByCTDRowID(CTDRowID As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID, TOR_RecLoc_DR,TOR_RecLoc_DR->CTLOC_Desc As CTLOC_Desc,TO_DATE(TOR_DateFrom,'DD/MM/YYYY') As TOR_DateFrom,
		TO_DATE(TOR_DateTo,'DD/MM/YYYY') As TOR_DateTo, CONVERT(VARCHAR(8),TOR_TimeFrom,108) As TOR_TimeFrom,
		CONVERT(VARCHAR(8),TOR_TimeTo,108) As TOR_TimeTo,TOR_ActiveFlag, TOR_CTHospital_DR, 
		TOR_CTHospital_DR->HOSP_Desc As HOSP_Desc
	FROM DHC_CITypeDefineOrderRule
	WHERE (TORCTDParRef = :CTDRowID)
}

Query SelectCTLocByCode(Code As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT CTLOC_Desc, CTLOC_RowID, CTLOC_Code
FROM CT_Loc
where CTLOC_Desc %STARTSWITH :Code or CTLOC_Code %STARTSWITH :Code
}

Query SelectHospital() As %SQLQuery(CONTAINID = 1)
{
SELECT HOSP_Desc,HOSP_RowID FROM CT_Hospital
}

}
