Import SQLUser

Class web.DHCBL.CIDefine.CIServiceTypeList Extends (%RegisteredObject, %XML.Adaptor, web.DHCBL.BLAbstract) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter EntityClassName = "web.DHCEntity.CIDefine.CIServiceTypeList";

Parameter PersistentClassName = "User.DHCCIServiceTypeList";

ClassMethod DTOTransObj(DTObj As %ObjectHandle) As %ObjectHandle
{
	;w ##class(web.DHCBL.CIDefine.CIServiceTypeList).DHCAuditSaveDataToServer(^TMPXmlData)
	b	;;
	s myPObj=""
	s myNewFlag=0
	
	i DTObj.CIRowID=""{
		q myPObj
	}
	s myParObj=##class(User.DHCCIService).%OpenId(DTObj.CIRowID)
	if ('$IsObject(myParObj)){
		q myPObj
	}
	
	i DTObj.STPLRowID="" {
		s myPObj=##class(User.DHCCIServiceTypeList).%New()
		s myNewFlag=1
	}else{
		s myPObj=##class(User.DHCCIServiceTypeList).%OpenId(DTObj.STPLRowID)
	}
	
	if (DTObj.STPLTypeDefineDR'=""){
		d myPObj.STPLTypeDefineDRSetObjectId(DTObj.STPLTypeDefineDR)
	}
	s myDate=""
	i (DTObj.STPLDateFrom["/"){
		s myDate=$zdh(DTObj.STPLDateFrom,4)
		
	}elseif(DTObj.STPLDateFrom["-"){
		s myDate=$zdh(DTObj.STPLDateFrom,3)
	}else{
		s myDate=+$h
	}
	
	s myPObj.STPLDateFrom=myDate
	
	s myDate=""
	i (DTObj.STPLDateTo["/"){
		s myDate=$zdh(DTObj.STPLDateTo,4)
		
	}elseif(DTObj.STPLDateTo["-"){
		s myDate=$zdh(DTObj.STPLDateTo,3)
	}else{
		s myDate=""
	}
	s myPObj.STPLDateTo=myDate
	
	i (+myNewFlag){
		d myParObj.STypeList.Insert(myPObj)
		d myParObj.%Save()
		s DTObj.STPLRowID=myPObj.%Id()
		b	;;ID
		s myPObj=##class(User.DHCCIServiceTypeList).%OpenId(DTObj.STPLRowID)
		d myParObj.%Close()
	}
	
	q myPObj
}

/// SELECT %ID,TO_DATE(STPL_DateFrom,"DD/MM/YYYY") As STPL_DateFrom,TO_DATE(STPL_DateTo,"DD/MM/YYYY") As STPL_DateTo,"STPLTypeDefineDR->%ID" AS STPL_TypeDefine_DR 
/// FROM SQLUser.DHCCIServiceTypeList
Query SelectAllByCIRowID(CIRowID As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID, STPL_TypeDefine_DR->%ID AS STPL_TypeDefine_DR, STPL_TypeDefine_DR->CTD_Desc  As CTD_Desc, TO_DATE(STPL_DateFrom,'DD/MM/YYYY') As STPL_DateFrom,TO_DATE(STPL_DateTo,'DD/MM/YYYY') As STPL_DateTo
FROM DHC_CIServiceTypeList
WHERE (STPLCISParRef = :CIRowID)
}

}
